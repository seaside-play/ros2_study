# 1 如何查看C++标准库的版本？

# 2 如何创建`C_Cpp_properties.json`文件
使用vscode调试时，需要使用该配置文件，以指定编译器和包含的路径

# 3 使用clangd最后一步

务必在cmake时使用 `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`或在`CMakeLists.txt`中，添加如下配置：

    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

以确保使用Clangd时，可以随时关联代码提醒

# 4 创建功能包

First ,ros2 pkg create demo_python_pkg --build-type ament_python --license Apache-2.0

    In demo_python_pkg/demo_python_pkg directory, create python_node.py, and write the source code. Then, use 
    
Second, colcon build 
    
    to build, it will add three directories. They are install, log and build. 
   1. install, include the executable files;
   2. log, include the log during build;
   3. build, include tempory file for exetuable files.

   There are two files, setup.py and package.xml,
Thrid,   package.xml list should include the dependency library, e.g rclpy
Fourth,   setup.py should specify the main function entity in entry_points/console_scripts e.g 'python_node=demo_python_pkg.python_node:main', specify the foder.file.main_function.


Fifth, source install/setup.zsh or install/setup.bash to put current package node into the ros the environment, so that we can run the new created the ros node.

Other command:

- ros2 node list
- ros2 node info /sepcified_node_name


