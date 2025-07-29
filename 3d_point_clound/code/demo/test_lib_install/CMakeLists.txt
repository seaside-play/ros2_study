cmake_minimum_required(VERSION 3.10)
project(PCLTest)

# 设置C++标准
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include_directories(
    ${PROJECT_SOURCE_DIR}/src/include  # 当前项目的include目录
    # /path/to/external/library/include  # 外部库的头文件路径
)

# 查找PCL库
find_package(PCL 1.12 REQUIRED COMPONENTS 
    common io search visualization
    surface features segmentation
)

include_directories(${PCL_INCLUDE_DIRS})
link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})


# 查找VTK库（自动包含所有依赖模块）
find_package(VTK 9.1 REQUIRED COMPONENTS 
    CommonCore CommonDataModel CommonMath 
    RenderingCore InteractionStyle RenderingOpenGL2
)

# 包含头文件目录
include_directories(
    ${PCL_INCLUDE_DIRS}
    ${VTK_INCLUDE_DIRS}
    ${PROJECT_SOURCE_DIR}/src/include
)

# 添加定义
add_definitions(${PCL_DEFINITIONS})

# 添加可执行文件
add_executable(test_pcl 
    main.cpp 
    src/cloud_process.cpp
)

target_link_libraries(test_pcl 
    ${PCL_LIBRARIES}  
    ${VTK_LIBRARIES}
)

# 修复函数返回值警告（可选但推荐）
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror=return-type")