ros2 node list
ros2 node info /cpp_node

cd ~/ros2_ws
colcon build --symlink-install  # 推荐使用 --symlink-install 加速开发
colcon build --packages-select demo_cpp_pkg # 选择某一个功能包进行构建，功能包最佳实践Workspace
