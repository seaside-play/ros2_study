#!/bin/sh
#功能：确保/home/ae/log下的core文件最多保存最新产生的5个，以避免磁盘占用空间过大
#2025年06月06日 create by Chaojiang Wu
#2025年06月18日 FixBug：保留了最旧的5个core文件
#2025年07月07日 FixBug：删除旧版本的core文件，解决文件名有空格的逻辑错误处理

echo "-->clearup_core_files.sh"
# set -x
log_dir=/home/ae/log
echo "Log path ${log_dir}"
cd $log_dir

if [ -e ${log_dir}/core ]; then
    echo "Deleting old core file core" 
    rm ${log_dir}/core
fi 

ls -l core_* 2>/dev/null | while IFS= read -r file; do
    # grep -o 选项的作用是只输出匹配到的部分，而非整行内容
    # -l 是 wc 的选项，专门用于只显示行数（line count）。统计行数
    underscore_count=$(echo "$file" | grep -o '_' | wc -l)
    if [ "$underscore_count" -eq 1 ]; then
        echo "Deleting old core file $file"
        rm -f "$file"  # 实际删除（去掉 echo 测试）
    fi
done

# 将空格替换为$
temp_file=$(mktemp)
ls -1 core_* 2>/dev/null > "$temp_file" # 添加双引号的作用：防止分词和通配符扩展，保留字符串的字面意思
while IFS= read -r file; do
    filename=$(echo "${file}" | tr ' ' '$')
    filenames="${filenames}, ${filename}"
done < "$temp_file" # 避免使用管道，使用文件输入的方式
rm "$temp_file"
flienames="${filenames#, }" # 去掉字符串头部的特殊字符

# 按照时间戳降序排序
filenames=$(echo "$flienames" | tr ', ' '\n' | while IFS= read -r file; do
    num=$(echo "$file" | sed 's/.*_\([0-9]\+\).*/\1/')
    echo "$num $file"
done | sort -k1 -nr | cut -d' ' -f2-)  # 使用$()，可以将管道获得的字符串最终写入到变量中

# 删除旧的文件
count=0
for file in ${filenames}; do
    count=$((count + 1))
    if [ ${count} -gt 5 ]; then
        delete_file=$(echo "$file" | tr '$' ' ')
        echo "Deleting index ${count} file ${log_dir}/${delete_file}" 
        rm "${log_dir}/${delete_file}"
    fi
done

echo "<--clearup_core_files.sh"
