#/bin/bash

#sudo apt update
#sudo apt install software-properties-common

#sudo add-apt-repository universe

#sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
#echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update
sudo apt upgrade -y
sudo apt install ros-humble-desktop

#场景1：安装后找不到ros2命令
source /opt/ros/humble/setup.bash
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc


#场景2：colcon build报错
sudo apt install python3-colcon-common-extensions


# 场景3：Rviz无法启动
sudo apt install mesa-utils
glxinfo | grep "OpenGL version"


# # 终端1
# ros2 run demo_nodes_cpp talker
# # 终端2 
# ros2 run demo_nodes_py listener
# # 终端3
# rqt_graph


# 💡 高手进阶配置
# 1.安装开发工具套件：
sudo apt install ros-dev-tools

# 2.配置ROS2工作空间
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
colcon build

# 3.推荐VS Code插件
# ROS
# CMake Tools
# URDF


