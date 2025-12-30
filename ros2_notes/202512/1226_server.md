# 1 使用python服务通信实现人脸识别

使用接口功能包来定义服务接口类型

要实现服务通信，需要创建服务的服务端和客户端，完成请求和响应。

结合视觉知识，做一个人脸检测服务。

步骤：

1. 创建一个服务**消息接口**；
2. 创建一个**服务端节点**，用来接收图片并进行识别；
3. 创建一个**客户端节点**，请求服务并显示识别的结果；

# 1.1 实现人脸检测接口功能包

# 1.2 使用Python实现人脸检测

## 1.2.1 人脸检测服务端实现（重点回调函数）

实现逻辑（重点）：

创建服务端的人脸检测节点类，并设置节点名称，创建CvBridge（用于将ROS 2 的image数据转化成opencv可用的格式），创建服务，设置接口类型，服务名称和回调函数。确定默认图像路径以及默认采样次数1和默认模型hog。在服务回调函数中，将request中的image由CvBridge的imgmsg_to_cv2转换为opencv能识别的image对象，若没有可转换图像就使用本地默认图像，通过cv2.imread获得图像对象。开始设置图像识别的开始时间和结束时间，而图像识别使用face_recognition的face_locations函数，来识别图像中的人脸，并将结果数据复制到response中。

知识点摘要：

在Python中有很多库可以实现人脸检测功能，如`face_recognition`库。

导入opencv库cv2

ament_index_python库中导入get_package_share_directory函数，可以通过包名获取功能包的安装目录，可返回安装目录下的
share目录绝对路径

ROS 2和opencv中的Image格式不兼容，需要使用CvBridge类进行格式转换。

使用create_service创建一个服务，有三个参数，依次分别是：消息接口类型，服务名称，处理请求的回调函数

        self.service_ = self.create_service(FaceDetector, '/face_dectect', self.detect_face_callback)

重点是服务处理回调函数，两个参数分别是request和response        

## 1.2.2 人脸检测客户端实现（重点）

首先准备图像，将图像放在resource下，并通过setup.py中的data_files注册图像路径。
创建服务的客户端，通过create_client函数，两个参数分别是服务接口类型，已经服务的名称
创建CvBridge对象，用他的函数将opencv的image格式转换成ROS 2 可识别的image，通过其接口cv2_to_imgmsg完成
获得本地图片的路径，并通过opencv.imread读取图片资源，在发送请求时需要将该图片资源转换成ROS 2可识别的图像格式

发送请求：在创建服务的客户端节点之后，就可以调用发送请求的函数，在该函数中，首先通过wait_for_service来检测服务是否启动，不启动，则每隔1s检测一次并通过get_logger()打印日志。

如服务已上线，则创建接口类型的Request()对象，并将opencv的image转换ROS 2的image格式，之后通过call_async(request)来发送该请求，并使用rclpy.spin_until_future_complete(self, future)来等待处理结果完成。之后，调用future.result()函数，获得response。最后读取reponse的内容，即个数和位置信息，通过cv2.rectangle在image上画出正方形，并显示出来。并使用cv2.waitKey(0)，来结束图象展现。

# 2 用C++服务通信做一个巡逻海龟

既然能够做一个巡逻海龟，那么就可以做一个巡逻机器人了！！！

结合闭环控制，做一个巡逻海龟来学习如何使用C++创建服务通信的服务端和客户端。

同样

首选，创建一个服务接口；
然后，基于闭环控制节点创建一个服务，用来接收目标位置；服务端提供了控制海龟到目标点的服务；

最后，创建一个客户端节点，随机生成位置并请求服务；客户端只需要随机生成目标点，并请求服务端进行处理即可；

# 3 参数通讯机制：在Python节点中使用参数

ROS 2的参数支持通过代码进行声明、查询、设置和删除

经常用的是参数的声明和设置


        # 声明参数和获取参数
        self.declare_parameter('face_locations_upsample_times', 1)
        self.declare_parameter('face_locations_model', "hog")
        self.upsmaple_times_ = self.get_parameter('face_locations_upsample_times').value
        self.model_ = self.get_parameter('face_locations_model').value


项目：使用参数通信机制，将人脸检测服务中的**采样次数和检测模型进行参数化**。

启动节点后，通过ros2 param list 可以查看参数列表，之后通过

ros2 param set /face_detection_node face_location_model cnn
---
Set parameter successful

还可以通过在启动节点时指定参数的值，只需要使用--ros-args和-p来指定就可以了

在参数被设置后，要想第一时间获取参数更新并赋值给对应的属性，就需要**订阅参数设置事件**。

参数是基于服务实现的，那么节点运行起来后，就会对外提供参数查询和设置等**服务**，根据这一原理，就可以编写一个服务的客户端来修改其它节点的参数。

