# 项目名称：ROS 2 中使用moveit 2 让六轴机械臂抓取物体


## 如何让机械臂动起来？

简单来讲，如果知道一个机器人的URDF模型，并且知道关节位置，即可计算出任何时刻机器人各个坐标系间的TF。
/joint_states话题的消息类型为sensor_msgs/JointState，用来表示关节状态的标准传感器数据类型。
在实际机器人中一般需要自己编写驱动关节对外发布/joint_states话题，而不是使用joint_state_publisher节点。
可以编写模拟发布机械臂各个关节的位置到/joint_states话题上。
实现机械臂各个关节的运动。
