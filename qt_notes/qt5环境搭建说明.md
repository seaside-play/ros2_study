- 环境：Ubuntu22.04

- 编译环境：
	gcc -v			11.4.0
	g++ -v			11.4.0

- qt环境：

		sudo apt-get install build-essential
		sudo apt-get install qtbase5-dev qtbase5-dev-tools
		sudo apt-get install qt5-doc
		sudo apt-get install qt5-quick-demos
		sudo apt-get install qtbase5-examples

- QtCreator安装：

		qt creator安装，拷贝qt-creator-opensource-linux-x86_64-11.0.3.run到qt文件夹下
		！！！！断开网络连接，打开终端！！！！执行以下命令
			sudo chmod 777 qt-creator-opensource-linux-x86_64-11.0.3.run	更改权限
			./qt-creator-opensource-linux-x86_64-11.0.3.run				一路向下next即可


至此，QtCreator和Ubuntu22.04自带的qt5.15.3已安装完成，打开QtCreator，点击工具栏中  编辑-Preferences ，进入构建套件，此时自动检测的默认版本为qt5.15.3，即可进行编译


- 使用Qt5.15.12

	1、文件安装
		将目录下的Qt-5.15.12.tar.xz拷贝到自己电脑本地任意位置，在该位置打开终端，执行以下命令

			sudo cp Qt-5.15.12.tar.xz /usr/local
			cd /usr/local
			sudo tar -xvf Qt-5.15.12.tar.xz

	2、配置环境变量

				sudo gedit ~/.bashrc
				sudo gedit ~/.zshrc
					在最后添加以下内容：

					export QTDIR=/usr/local/Qt-5.15.12
					export QT_SELECT=qt-5.15.12
					export PATH=$QTDIR/bin:$PATH
					export MANPATH=$QTDIR/man:$MANPATH
					export LD_LIBRARY_PATH=$QTDIR/lib:$LD_LIBRARY_PATH

				添加完成后执行	source ~/.bashrc
				新开终端，确认当前环境变量配置是否成功
				qmake -v，如果不是对应路径下的5.15.12，建议重启
				qmake -query		查看当前qmake设置

- 解决qmake无法读取版本的解决方案

			//20250717. Chaojiang Wu 001: fix Can't find version
			若使用以上两个命令找不到版本信息，可使用如下方式
			# 用qtchooser设置默认版本（如果安装了的话）
			qtchooser -install qt5.15.12 /usr/local/Qt-5.15.12/bin/qmake
			export QT_SELECT=qt5.15.12  # 使用你刚刚创建的ID

			# 或者用update-alternatives（Ubuntu系统）
			sudo update-alternatives --install /usr/bin/qmake qmake /usr/local/Qt-5.15.12/bin/qmake 100
			//2020717. Chaojiang Wu 001 End

至此，Qt5.15.12已成功安装，如需使用，请在QtCreator中配置构建套件
	点击工具栏中  编辑-Preferences ，进入构建套件，Qt版本，点击右侧添加，选择/usr/local/Qt-5.15.12/bin/qmake，建议本版本命名为Qt5.15.12，点击应用
	点击上方构建套件，点击右侧添加，将Qt版本更改为刚才已添加的版本，点击应用，确定

至此，Qt5.15.12构建套件已在QtCreator配置完成
