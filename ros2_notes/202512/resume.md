1. 掌握话题通信，服务和参数通信，动作通信（基于话题和服务）；
2. 掌握launch并灵活应用；
3. ROS 2 常用工具(tf, rqt, rviz, ros2 bag)
    - 熟练使用：tf（coordinate transformation， TF， 坐标转换）
        - 通过tf进行静态和动态坐标发布并监听坐标变换
    - 常用可视化工具：rqt 和 rviz（基础功能）
        - rqt：查看节点关系，请求服务
            - 安装rqt插件，方法如下：
                - sudo apt install ros-humble-rqt-\*
                - rm -rf ~/.config/ros.org/rqt_gui.ini： 删除rqt的默认配置文件，重启rqt会重新扫描和加载新安装的插件

        - rviz2：数据可视化工具，可实现如下功能
            - 坐标变换可视化和交互；
            - 实现机器人的传感器数据、激光雷达数据，点云和D模型的可视化与交互；

            它们的层级关系可以简单概括为：机器人传感器数据（大类） ⊃ 激光雷达数据（子类） ⊃ 点云（激光雷达数据的核心形态）；

            用法： 添加TF，获取当前系统中的TF坐标系数据，之后指定Fixed Frame（即原点坐标），就可以显示当前node的tf数据，同时通过修改Marker Scale和grid/Cell Size 调整显示的尺寸。
    - 数据记录工具：ros2 bag （记录话题数据，重复播放数据，数据分析和多次实验）
        - 机器人开发过程中的问题往往出在数据上，数据一般通过话题进行传递
        - ros2 bag:能够记录话题上发布的数据并保存下来，需要时重新播放数据，便于数据分析和多次实验。

        示例：对海龟的轨迹进行录制与重放

        重新播放话题有很多种操作：空格键：暂停或继续播放；按上下键：加快或减慢播放速度；按右键可以播放下一个消息

4. 机器人建模

    搭建一个机器人

- 使用URDF（Unified Robot Description Format）创建机器人 
- 使用ROS 2提供的 urdf_to_graphviz 将URDF结构进行可视化
    - 打开rviz2，使用RobotModel模块，修改资源来源Description Source为File，在Description File中选择要加载的urdf文件，最后修改Fixed Frame为base_link即可。
    - rviz2 要显示机器人模型，除了需要urdf之外，还需要通过TF输入各个部件之间的位姿关系。ROS 2，使用robot_state_publisher和joint_state_publisher将URDF文件转换为话题并将部件之间的位姿关系通过TF发布出来。
