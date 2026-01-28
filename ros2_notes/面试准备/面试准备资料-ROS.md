1. 介绍ROS2提供的功能
主要是提供四大工具：四大通信机制（话题，服务，动作和参数），调试工具（rviz，rqt和ros2 bag），建模和运动学工具（运动学坐标转换与管理的TF工具，描述机器人结构、关节和传感器的文件格式URDF,Xacro）,开源工具和框架（仿真工具gazebo， 移动机器人导航应用框架navigation2，机械臂运动规划应用框架moveit2）

2. 介绍ROS2系统架构
系统架构可以分层5层，从下往上依次是：
（1）操作系统层（ROS2提供各种基本硬件驱动，如网卡驱动，USB驱动和常用摄像头驱动）
（2）DDS实现层（第三方数据分发服务，基于实时发布订阅协议RTPS来实现数据分发，如eProsima Fast DDS， Elipse Cyclone DDS， RTI Connext DDS）
（3）DDS接口层（即ROS中间件接口RMW(ros middleware interface),支持不同厂家的DDS，对外接口保持一致）
（4）ROS2客户端层（提供不同语言的ROS2客户端库（rcl：ros2 client library，如rclcpp，rclpy），使用这些库提供的接口，可以完成ros2的核心功能调用，如：话题，服务，动作和参数通信机制）
（5）应用层（基于rcl开发的程序都属于应用层）

3. ROS的本质
是用于快速搭建机器人的软件库（核心是通信）和工具集

4. ROS的作用
将传感器的数据发送给决策系统，然后将决策系统的输出发送给执行器执行

5. ROS2的命令行命令有哪些？
pkg，
run，launch，
node，
topic，action，service，param
interface

6. 话题通信机制有哪个关键点？
发布者，订阅者，话题名称和话题类型（struct或class）
ros2 node list # 查看所有的节点名
ros2 node info /turtlesim # 查看具体某个节点的详细内容
ros2 topic info /turtle1/pose -v # 查看话题的具体信息
ros2 interface show turtlesim/msg/Pose # 查看话题类型的详细内容(话题接口的详细内容)
ros2 topic echo /turtle1/pose --once # 输出话题内容一次
ros2 topic pub /turtle/cmd_vel geometry_msgs/msg/Twist "{linear: {x: 1.0}}"


重要函数py:
self.novel_publisher_ = self.create_publisher(话题接口类型，'话题名称', 10保存历史消息的队列长度) 
创建定时器，进行数据定时发布
self.novel_publisher_.publish(msg)
py:self.novel_subscriber = self.create_subscription(话题接口类型， '话题名称', self.novel_callback, 10保存历史消息的队列长度)
def novel_callback(msg):进行回调函数定义

重要函数cpp:
auto novel_publisher_ = create_publisher<话题接口类型>("话题名称", 10保存历史消息的队列长度) ;
创建定时器，进行数据定时发布;
novel_publisher_->publish(msg);
auto novel_subscriber_ = create_subscription<话题接口类型>("话题名称", 10, std::bind([&](const 话题接口类型::SharedPtr msg) -> void {}));

7. 特点
ROS2在局域网内会自动发现其它节点

8. 使用pkg创建功能包
自定义接口：ros2 pkg create *_interfaces --build-type ament_cmake --dependencies rosidl_default_generators builtin_interfaces --licenses Apache-2.0
命令规则：src/包名/msg/SystemStatus.msg 自定义接口：本质就是定义一个结构体，
消息接口支持9种数据类型：
bool/byte/char
int8/16/32/64, uint8/16/32/64
float32/64
string
builtin_interfaces/Time stamp

编译选项：rosidl_generator_interface(${PROJECT_NAME})
         "msg/SystemStatus.msg"
         DEPENDENCIES builtin_interfaces)
         功能包清单文件package.xml中，<member_of_group>rosidl_interface_packages</member_of_group> 消息接口功能包
py普通功能包：ros2 pkg create *_python_pkg --build-type ament_python --dependencies rclpy example_interfaces --lincense Apach2-2.0
注册，编译和运行
cpp普通功能包：ros2 pkg create *_cpp_pkg --build-type ament_cmake --dependencies rclcpp gometry_msgs turtlesim --lincense Apach2-2.0
 
9. ROS2 运行框架
rclcpp::init(argc, argv);
auto node = std::make_shared<节点类型>(参数);
rclcpp::spin(node);
rclcpp::shutdown();

10. 服务
服务：基于请求和响应的双向通信
ros2 service list -t # -t表示列出服务接口名称和类型
ros2 interface show 接口类型 # 查看接口详细定义
ros2 service call /spawn turtlesim/srv/Spawn "{x: 1, y: 1}" # 通过命令行调用服务生产新的海龟
范式：ros2 service call 接口名称 接口类型 接口具体请求内容
 
11. 参数
主要用于管理节点设置，基于服务通信实现，参数被视为节点的设置。
ros2 service list -t | grep parameter # 所展现的服务，对外提供参数的查询和设置接口
ros2 有一套关于参数的工具和库可供使用：
ros2 param list # 查看当前所有节点的参数列表
ros2 param describe /turtlesim background_r # 范式：ros2 param describe 节点 参数名称
ros2 param get /turtlesim background_r # 获取节点的参数值
ros2 param set /turtlesim background_r 255 # 设置节点的参数值
ros2 param dump /turtlesim > turtlesim_param.yam # 将参数导出到文件里
