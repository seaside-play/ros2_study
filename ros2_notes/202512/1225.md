为了感知环境信息和执行动作，有传感器和执行器，
常见传感器为摄像头、雷达和惯性测量单位，
常见执行器有底盘、机械臂关键电机和电动夹爪

- ros2 run turtlesim turtlesim_node
- ros2 node info /turtlesim # 查看节点的详细信息

        ➜  ~ ros2 node info /turtlesim
        /turtlesim
        Subscribers:
            /parameter_events: rcl_interfaces/msg/ParameterEvent
            /turtle1/cmd_vel: geometry_msgs/msg/Twist # 话题名称和话题类型（消息接口）
        Publishers:
            /parameter_events: rcl_interfaces/msg/ParameterEvent
            /rosout: rcl_interfaces/msg/Log
            /turtle1/color_sensor: turtlesim/msg/Color
            /turtle1/pose: turtlesim/msg/Pose
        Service Servers:
            /clear: std_srvs/srv/Empty
            /kill: turtlesim/srv/Kill
            ...
        Service Clients:

        Action Servers:
            /turtle1/rotate_absolute: turtlesim/action/RotateAbsolute
        Action Clients:

- ros2 topic echo /turtle1/pose # 输出指定话题的内容,该话题是发布的内容，而topic echo就是用来获取发布的内容并展现出来
    - 海龟位置有5个参数：x，y为位置，theta：为方向，linear_velocity:线速度，angular_velocity:角速度

- ros2 topic info /turtle1/cmd_vel -v # 查看某一个话题的具体信息
- ros2 interface show geometry_msgs/msg/Twist # 查看某一个消息定义，该消息名称通过查看话题信息获得

        Vector3  linear
            float64 x
            float64 y
            float64 z
        Vector3  angular
            float64 x
            float64 y
            float64 z

- ros中规定，机器人前进的方向为x，
- ros2 可通过命令发布话题数据
- ros2 topic pub /turtle1/cmd_vel geometry_msgs/msg/Twist "{linear: {x: 1.0}}" # 通过花括号指定某一个变量的数据，区分消息结构层级，冒号后需要添加空格用于区分。
    - 虽然可以在命令行使用话题，但只能在程序中才可以灵活的使用话题


发布话题

- ros2 topic list -v： 发布话题后，可通过此命令查看所有发布的话题列表
- ros2 topic echo /novel: 实时查看话题信息，动态更新，根据发布者的发布频率可以看到数据的更新情况

- ROS 2 在局域网内会自动发现其它节点，我们只需要把信息用话题发布出来就可以了

# 3 系统状态检测与可视化工具

- 自定义通信接口：
    - `ros2 pkg create status_interfaces --build-type ament_cmake --dependencies rosidl_default_generators builtin_interfaces --license Apache-2.0`: 接口包需要单独create。
    - rosidl_default_generators: 用于将自定义的消息文件转化为C++、Python源码的模块
    - builtin_interfaces:是ROS 2中已有的一个消息接口功能包

    - 必须放在msg文件夹下，文件名以大写字母开头且只能有大小写字母以及数字组成。

- `包类型	是否加 rosidl_interface_packages	核心内容	编译规则`
    - `接口包	是	msg/srv/action	rosidl_generate_interfaces`
    - `普通功能包	否	节点源码、可执行文件	add_executable/ament_target_dependencies`

    - 注意点：
        
            <member_of_group>rosidl_interface_packages</member_of_group> 是 ROS 2 接口包的「身份标识」，仅用于纯 msg/srv/action 定义的包；含普通功能包（节点源码）绝对不能添加，否则会破坏编译流程。
            如果你的 demo_cpp_pkg 是包含 turtle_control 节点的功能包，需检查 package.xml 中是否误加了该标签，若有则立即删除，这可能是此前编译错误的隐藏原因之一。

# 4 服务和参数

- 应用场景：双向的
    - 如：一个节点发送图片请求另一个节点进行识别，另一个节点识别完之后将结果返回给请求节点；

- 服务：基于请求和响应的双向通行机制
- 参数：用于管理节点的设置  
    - 每个节点有很多参数需要动态调整，通过参数通信，就可以实现。

在ROS 2中，参数通信主要是基于服务通信实现的，所以放在一起学习。

- ros2 service list -t # 查找服务器列表和对应接口， -t参数表示显示服务的接口类型
    - 前面：服务名字, []是服务的接口类型
