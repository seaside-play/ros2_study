# 1 如何查看C++标准库的版本？

# 2 如何创建`C_Cpp_properties.json`文件
使用vscode调试时，需要使用该配置文件，以指定编译器和包含的路径

# 3 使用clangd最后一步

务必在cmake时使用 `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`或在`CMakeLists.txt`中，添加如下配置：

    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


以确保使用Clangd时，可以随时关联代码提醒
