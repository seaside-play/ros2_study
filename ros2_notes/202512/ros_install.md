# 1 安装的功能（海龟 tf2 演示、tf2 工具、tf 核心功能）

1. 正确的包名及安装命令如下：

sudo apt-get install ros-humble-turtle-tf2-py ros-humble-tf2-tools ros-humble-tf2

- 命令说明：
    - ros-humble-turtle-tf2-py：ROS 2 中海龟 tf2 的演示功能包（Python 版本，对应 ROS 1 的turtle-tf2）
    - ros-humble-tf2-tools：你原来命令中已存在的 tf2 工具包（包名兼容，无需修改）
    - ros-humble-tf2：ROS 2 中 tf 的核心功能包（对应 ROS 1 的tf，ROS 2 中统一为tf2系列）

2. 验证安装是否成功

查看已安装的tf2相关包
- apt list --installed | grep ros-humble-tf2

查看海龟tf2包是否安装成功
- apt list --installed | grep ros-humble-turtle-tf2-py