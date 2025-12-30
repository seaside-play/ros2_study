# 1 参数通信

首先在服务端设置参数，并添加设置参数的回调函数，以响应客户端的请求

然后再客户端创建参数对象，并将参数值对象赋值给参数对象的valu属性，通过create_client创建客户端，并将需要动态参数以异步方式发送给服务端，并处理结果。

## 1.1 区分Python版本和C++版本

### 1.1.1 Python版本，在人脸检测项目中应用参数服务器

1. 创建一个参数对象；
2. 创建参数值对象并赋值；
3. 请求更新参数并处理；

### 1.1.2 C++版本，在巡逻海龟项目中应用参数服务器

将服务器中控制器的比例系数k_和最大速度max_speend_参数化
`
1. 通过declear_parameter和get_parameter进行参数设置和获取

订阅参数更新事件，以便动态更新参数

2. 修改其它节点的参数

首先创建参数对象，对参数名称进行赋值，然后创建参数值对象，对参数值的类型和对应类型数据进行赋值，最后调用call_set_parameters请求服务，根据结果判断参数是否需改成功。

完成之后，在main函数中调用添加的update_server_param_k方法，实现修改其它节点的参数。

# 2 使用launch启动脚本

简化节点启动，launch就是ROS 2中用于启动和管理ROS 2节点和进程的工具

launch工具在运行python格式的启动脚本时，会在文件中搜索名为generate_launch_description的函数来获取启动内容的描述信息。在函数中，会创建launch_ros.actions.Node类的对象，在创建该对象时，package参数用于指定功能包名称，executable参数指定可执行文件名称，output参数用于指定日志输出的位置，screen表示屏幕，log表示日志，both表示前两种同时输出。最后将三个节点的启动对象合成数组，调用launch.LaunchDescription创建**启动描述对象**并返回。launch工具在拿到启动描述对象后，会根据其内容完成启动。

- ros2 launch demo_cpp_pkg demo.launch.py

可以在ament_cmake类型的功能包中使用lauch工具，也可以在ament_python类型功能包下创建launch文件夹饼编写文件，之后再setup.py文件中添加路径配置。

如：
    
        data_files = [
            ...
            ('share/' + package_name + '/launch', glob('launch/*.launch.py')),
        ]

在启动节点时，launch还可以将参数传递给节点

launch使用方法：
1. 启动多个节点；
2. 能够传递参数，替换节点中的变量；launch.action.DeclareLaunchArgument('a', default_value='0.0')
和launch.substitions.LaunchConfiguration('a', default='1.0')
3. 要掌握launch并灵活应用
    需要了解动作、条件和替换三个launch组件的使用
    - 动作的更多使用方法：如包含其它launch文件，执行命令行（进程），运行节点，输出日志，组合和定时启动节点
    - 条件启动节点

