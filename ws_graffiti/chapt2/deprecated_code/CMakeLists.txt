cmake_minimum_required(VERSION 3.8)
project(ros2_cpp)


set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(ros2_cpp_node ros2_cpp_node.cpp)

find_package(rclcpp REQUIRED)
target_include_directories(ros2_cpp_node PUBLIC ${rclcpp_INCLUDE_DIRS})
target_link_libraries(ros2_cpp_node ${rclcpp_LIBRARIES})