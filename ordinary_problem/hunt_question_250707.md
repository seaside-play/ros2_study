# 1 VSCode 的全局`settings.json`在哪里？

1. ctrl+, 
2. 选中:C_Cpp:Autocomplete,  点击右上角的“小文本”图标，打开`settings.json`
3. 


# 2 为vscode配置clangd 

在 Ubuntu 22.04 上使用 Clangd 为 VSCode 提供 C/C++ 代码分析和智能提示功能，需完成环境准备、Clangd 安装、编译数据库生成及 VSCode 配置四步操作。以下是具体步骤和配置建议：

## 2.1 环境准备

安装基础工具链

更新系统并安装编译工具（GCC/G++）、构建工具（CMake）和调试器（LLDB）：

sudo apt update && sudo apt upgrade -y
sudo apt install build-essential cmake lldb libllvm-dev llvm-dev clang-tools bear -y

- bear：用于生成 compile_commands.json（Clangd 依赖的编译数据库）。
- clang-tools：包含 Clangd 的默认版本（Ubuntu 22.04 默认提供 Clangd 14）。

## 2.2 生成编译数据库
Clangd 需要 compile_commands.json 来解析项目结构。使用 CMake 构建时，通过以下方式生成：

直接生成

在 CMake 命令中添加参数：

# 3 指定clangd

sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-14 100

