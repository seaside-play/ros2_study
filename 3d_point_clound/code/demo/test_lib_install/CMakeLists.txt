cmake_minimum_required(VERSION 3.10)
project(PCLTest)

# 设置C++标准
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 查找PCL库
find_package(PCL 1.12 REQUIRED COMPONENTS common io)
include_directories(${PCL_INCLUDE_DIRS})
link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})

# 添加可执行文件
add_executable(test_pcl main.cpp)
target_link_libraries(test_pcl ${PCL_LIBRARIES})