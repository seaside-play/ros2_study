cmake_minimum_required(VERSION 3.8)
project(ros2_cpp)
add_executable(ros2_cpp_node ros2_cpp_node.cpp)


# 查找并添加依赖
find_package(rclcpp REQUIRED)
# 给可执行文件包含头文件
target_include_directories(ros2_cpp_node PUBLIC ${rclcpp_INCLUDE_DIRS})
# 给可执行文件链接库文件
target_link_libraries(ros2_cpp_node ${rclcpp_LIBRARIES})

ament_target_dependencies(cpp_node rclcpp) # 该命令，直接包括了上面的target_include_directories和target_link_libraries

install(TARGETS
cpp_node
DESTINATION lib/${PROJECT_NAME}
)

colcon build --packages-select demo_cpp_pkg1 demo_cpp_pkg2

include_directories(include) # 同级目录下