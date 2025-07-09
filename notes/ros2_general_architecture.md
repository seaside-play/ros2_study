# sudo apt install ros-humble-desktop-full 会安装哪些工具？

sudo apt install ros-humble-desktop-full 会安装 ROS 2 Humble 发行版的完整桌面环境，包含

- 核心组件、
- 可视化工具、
- 仿真环境
- 常用库

以下是具体分类及包含的主要工具：

# 1 核心组件
1. ROS 2 基础库
- rclcpp：C++ 客户端库
- rclpy：Python 客户端库
- rmw_implementation：中间件抽象层（默认使用 Fast-DDS）
2. 通信与消息
- rosidl：消息 / 服务定义工具（.msg/.srv 文件生成器）
- ament_cmake/ament_python：构建系统
3. 命令行工具
- ros2cli：ROS 2 命令行接口（ros2 node, ros2 topic, ros2 service等）
- colcon：构建工具
# 2 可视化与调试工具
1. RViz 3D 可视化
- 3D 场景渲染器，支持机器人模型、点云、激光雷达数据等显示
2. rqt 工具集
- rqt_graph：节点 / 话题关系图
- rqt_console：日志查看器
- rqt_plot：实时数据绘图
- rqt_reconfigure：动态参数配置
3. 调试工具
- ros2 bag：数据记录与回放
- launch：多节点启动管理器
# 3 仿真环境
1. Gazebo Classic
- 机器人动力学仿真（默认安装 Gazebo 11）
2. Ignition Gazebo
新一代仿真引擎（可选安装，需单独配置）
3. Turtlesim
简单的海龟仿真（用于教学和测试）
# 4 机器人功能包
1. 导航与建图
- Navigation2：机器人导航栈（AMCL 定位、规划器等）
- SLAM 工具（如 Cartographer、LGSVL）
2. 运动控制
- MoveIt 2：机械臂运动规划
3. 感知与处理
- OpenCV：计算机视觉库
- PCL（Point Cloud Library）：点云处理

# 5 开发工具与依赖
1. 编译器与构建工具
- GCC、Clang（C/C++ 编译器）
- Python 3.10 及相关依赖
2. IDE 支持
- 对 VS Code、CLion 的官方支持插件
3. 测试框架
- Google Test（C++）、pytest（Python）
# 6 示例与教程
- ros2_examples：官方示例代码（C++/Python 节点通信）
- turtlesim：教学用海龟仿真
# 7 其它
## 7.1 对比其他安装选项
- 安装选项	|  包含内容 
- ros-humble-desktop-full	全部核心组件、可视化工具、仿真环境、导航与建图功能包
- ros-humble-desktop	核心组件 + 可视化工具（不含仿真和高级功能包）
- ros-humble-ros-base	仅基础库和命令行工具（适合服务器或资源受限环境）
## 7.2 验证安装内容
安装后，可通过以下命令查看已安装的包列表：

bash
    dpkg -l | grep ros-humble-

