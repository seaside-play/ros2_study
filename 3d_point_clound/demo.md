
# 1 安装PCL

- sudo apt install -y git build-essential cmake libusb-1.0-0-dev libglfw3-dev libopenni2-dev
- sudo apt install -y libpcl-dev pcl-tools
- pcl_viewer --version


1. 确认 PCL 安装路径

    首先检查 PCL 头文件和库文件的实际安装位置：

        # 查找PCL头文件
        find /usr -name "pcd_io.h" 2>/dev/null
        可以看到在ubuntu22.04上使用apt安装的pcl版本是1.12，它使用C++11和C++14编写的
        所以，在CMakeLists.txt中，推荐使用set(CMAKE_CXX_STANDARD 14)

        # 查找PCL库文件
        find /usr -name "libpcl_common.so" 2>/dev/null

# 2 测试安装结果

1. 源代码

    #include <iostream>
    #include <pcl/io/pcd_io.h>
    #include <pcl/point_types.h>

    int main() {
      pcl::PointCloud<pcl::PointXYZ>::Ptr cloud (new pcl::PointCloud<pcl::PointXYZ>);
      std::cout << "PCL library installed successfully!" << std::endl;
      return 0;
    }

2. 编译

    g++ main.cpp -o test_pcl -I /usr/include/pcl-1.12 -I /usr/include/eigen3 -lpcl_common -lpcl_io

    ./test_pcl

3. CMakeLists.txt内容如下

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

# 3 包含头文件

        vim ~/.bashrc
        # 自定义Boost版本在 /usr/local/boost/1.50.0,去掉就可实现boost1.71.1
        export BOOST_ROOT=/usr/local/boost/1.50.0
        export CPLUS_INCLUDE_PATH=$BOOST_ROOT/include:$CPLUS_INCLUDE_PATH  # 头文件路径
        export LIBRARY_PATH=$BOOST_ROOT/lib:$LIBRARY_PATH                # 静态库搜索路径
        export LD_LIBRARY_PATH=$BOOST_ROOT/lib:$LD_LIBRARY_PATH        # 动态库搜索路径

        仿照boost库的写法添加pcl库：
        export PCL_ROOT=/usr/include/pcl-1.12
        export CPLUS_INCLUDE_PATH=$PCL_ROOT:$CPLUS_INCLUDE_PATH