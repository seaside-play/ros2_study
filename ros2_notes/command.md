# 1 罗列重要的命令

# 1.1 查看节点信息
ros2 node list
ros2 node info /cpp_node

# 1.2 编译源代码并运行节点

# 编译

0. 创建功能包，以便生成框架结构:ros2 pkg create demo_cpp_pkg --build_type=ament_cmake(ament_python) --license Apache-2.0
1. 编写独立的源代码；
2. 将main函数添加到setup.py/entry_points中，可以有多个；
3. 在package.xml添加依赖信息；
4. colcon build编译生成功能包和节点；
5. 通过source设置环境变量，source install/setup.bash zsh\
6. 使用ros2 run 功能包名 节点名运行节点；
7. 使用 ros2 node 程序查看node相关的信息；

#编译
cd ~/ros2_ws
colcon build --symlink-install  # 推荐使用 --symlink-install 加速开发
colcon build --packages-select demo_cpp_pkg # 选择某一个功能包进行构建，功能包最佳实践Workspace
colcon build  # 编译当前功能包下的全部功能包
# 运行节点
source install/setup.bash(setup.zsh)
ros2 run demo_python_pkg python_node
# 查看功能包的路径
echo $AMENT_PREFIX_PATH
