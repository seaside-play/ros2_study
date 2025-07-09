# 1 sed

sed（流编辑器，Stream Editor）是 Unix/Linux 系统中用于文本处理的强大工具。它通过正则表达式对文本进行替换、删除、插入、修改等操作，适合批量处理大量文本。

## 1.1 核心功能
1. 替换文本（最常用）

        bash
        sed 's/原文本/替换文本/g'  # 将所有匹配的原文本替换为新文本

        示例：将文件中的 apple 替换为 orange
        bash
        sed 's/apple/orange/g' input.txt > output.txt

2. 删除行

        bash
        sed '3d'  # 删除第3行
        sed '/pattern/d'  # 删除包含特定模式的行

3. 插入 / 追加行

        bash
        sed '3i\插入的内容'  # 在第3行前插入
        sed '3a\追加的内容'  # 在第3行后追加

4. 打印特定行

        bash
        sed -n '3p'  # 只打印第3行
        sed -n '/pattern/p'  # 只打印包含特定模式的行

## 1.2 关键参数
### 1.2.1 参数	作用

- `s`	替换（substitute）
- `g`	全局替换（global，否则只替换每行第一个匹配）
- `d`	删除（delete）
- `i`	插入（insert）
- `a`	追加（append）
- `-i`	直接修改原文件（in-place）
- `-n`	静默模式（只输出被明确打印的行）

### 1.2.2 示例详解
1. 替换示例

        bash
        echo "hello world" | sed 's/world/universe/g'
        # 输出：hello universe

2. 替换特殊字符

        替换 / 需要用 \/ 转义：

        bash
        echo "path/to/file" | sed 's:/:/new/:g'
        # 输出：path/new/to/new/file

3. 删除空行

        bash
        sed '/^$/d' input.txt  # 删除所有空行

4. 修改特定行

        bash
        sed '3s/old/new/' input.txt  # 只修改第3行的第一个 old

5. 组合多个命令

        用分号分隔多个操作：

        bash
        sed 's/old/new/; s/foo/bar/' input.txt

## 1.3 进阶技巧

- 正则表达式：sed 支持基本正则（BRE）和扩展正则（ERE，用 -E 选项）
        bash
        sed -E 's/[0-9]+/number/g'  # 替换所有数字为 "number"

- 引用变量：用双引号包围 sed 命令
        bash
        old="apple"
        new="orange"
        sed "s/$old/$new/g" input.txt

- 保存到原文件：用 -i 选项
        bash
        sed -i 's/old/new/g' input.txt  # 直接修改 input.txt

## 1.4 与其他工具对比
- 工具	适用场景	特点
- sed	流处理、正则替换	适合单行操作，速度快
- awk	复杂数据处理、格式化	支持变量、数组、函数
- grep	查找匹配行	只负责查找，不修改
## 1.5 总结
sed 是文本处理的瑞士军刀，尤其擅长：

- 批量替换文件中的字符串
- 基于模式删除或修改行
- 自动化文本处理任务

# 2 案例1

    num=$(echo "$file" | sed -n 's/.*_\([0-9]\+\).*/\1/p')
    if [[ -z "$num" ]]; then
        echo "错误：无法从 '$file' 中提取到数字！" >&2
        exit 1
    fi

    sed 's/.*_\([0-9]\+\).*/\1/'


这个命令主要由以下几个部分构成：

- s/.../.../：这是 sed 的替换命令，意思是用后面的内容替换前面匹配到的内容。
- .*_：.* 能够匹配任意数量的任意字符，_ 表示匹配下划线。所以 .*_ 的作用是匹配到最后一个下划线（因为 .* 是贪婪匹配，会尽可能多地匹配字符）。
- \([0-9]\+\)：
- \(...\) 是捕获组，它的功能是把括号内匹配到的内容保存下来，方便后续引用。
- [0-9] 代表匹配数字，等价于 \d。
- \+ 表示匹配前面的字符一次或多次（在基本正则表达式中，+ 需要转义为 \+）。

 综合起来，这个捕获组的作用是匹配一个或多个连续的数字。

- .*：匹配下划线后面数字之后的所有剩余字符。
- \1：在替换部分使用 \1，表示用前面第一个捕获组（也就是那串数字）来替换整个匹配到的内容。


# 3 `while IFS= read -r file;`

while IFS= read -r file; 是 Bash 中逐行读取输入的标准结构，用于安全地处理包含特殊字符（如空格、制表符、换行符）的文本。下面详细解析其含义和作用：
## 3.1 核心参数解析
1. IFS=

IFS（Internal Field Separator）是 Bash 的内置变量，默认值为空格、制表符、换行符。
IFS= 表示清空 IFS，这样在读取输入时，不会对行内的空格或制表符进行分词，确保整行内容被完整读取。

2. read -r

- read：Bash 内置命令，用于从标准输入读取一行数据，并将其分割后赋值给变量。
- -r：禁止反斜杠（\）转义。若不加 -r，read 会将 \n、\t 等视为转义字符。
- 工作流程
- 逐行读取输入：每次循环读取一行数据，直到输入结束。
- 赋值给变量：整行内容（包括空格、制表符）被赋值给变量 file。
- 处理特殊字符：

IFS= 确保行内的空格和制表符不被分割。
-r 确保反斜杠 \ 不被转义。


## 3.2 示例 1：处理包含空格的文件名
        bash
        # 假设输入为 "file with spaces.txt"
        while IFS= read -r file; do
            echo "文件名: '$file'"
        done <<< "file with spaces.txt"

        # 输出：
        # 文件名: 'file with spaces.txt'
        示例 2：对比有无 IFS= 和 -r 的区别
        bash
        # 输入包含空格和反斜杠
        input='first line\ second line'

        # 错误写法（默认IFS+无-r）
        while read file; do
            echo "错误: '$file'"
        done <<< "$input"

        # 正确写法（IFS= + -r）
        while IFS= read -r file; do
            echo "正确: '$file'"
        done <<< "$input"

        # 输出：
        # 错误: 'first line'
        # 正确: 'first line\ second line'

## 3.3 常见应用场景

1. 遍历文件内容

        bash
        while IFS= read -r line; do
            echo "处理行: $line"
        done < input.txt

2. 处理包含空格的文件名列表

        bash
        find . -name "*.txt" | while IFS= read -r file; do
            echo "处理文件: '$file'"
        done

3. 读取命令输出的每一行

        bash
        ls -l | while IFS= read -r line; do
            echo "文件信息: $line"
        done

## 3.4 注意事项

- 子 shell 问题：

使用管道（|）会创建子 shell，导致循环内的变量修改无法影响外部。例如：

        bash
        echo "a b c" | while IFS= read -r line; do
            var="$line"  # 此变量仅在子shell内有效
        done
        echo "$var"  # 输出为空

- 解决方案：使用进程替换（while ... done < <(command)）或输入重定向（while ... done < file）。
- 处理空行：

read 命令在遇到空行时仍会执行一次，但变量会被赋值为空。
若需跳过空行，可添加条件判断：

        bash
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue  # 跳过空行
            echo "处理: $line"
        done < input.txt


## 3.5 总结

while IFS= read -r file; 是 Bash 中安全逐行读取输入的标准写法，主要用于：

- 处理包含空格、制表符的文本。
- 保留反斜杠的原始含义。
- 避免因 IFS 导致的分词问题。

在处理文件名、配置文件或其他需要精确保留原始文本格式的场景中，这种写法尤为重要。