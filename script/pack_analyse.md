# 1 计算一个文件的md5并赋值给一个变量

在 Bash 脚本中计算文件的 MD5 哈希值并将结果赋值给变量，可使用md5sum命令结合命令替换实现。以下是具体方法：

## 1.1 直接获取 MD5 值（标准方式）

      # 指定文件路径
      file_path="/path/to/your/file.txt"

      # 计算MD5并赋值给变量（仅哈希值部分）
      md5_hash=$(md5sum "$file_path" | awk '{print $1}')

      echo "文件的MD5哈希值: $md5_hash"

## 1.2 说明
- md5sum命令：在大多数 Linux 系统中可用，用于计算文件的 MD5 哈希值。
- 命令替换：$(...)语法会执行括号内的命令，并将输出结果作为字符串返回。
- awk '{print $1}'：用于从md5sum的输出中提取第一个字段（即哈希值部分）。
- 错误处理：建议添加文件存在性检查和命令执行状态判断，增强脚本的健壮性。
- 2>/dev/null: 将可能得错误丢掉