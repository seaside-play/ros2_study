#!/bin/bash
#-----修改记录-----
#1.2017年08月28日 liyuan: create by liyuan 
#2.2017年09月05日 liyuan: 修改了HMI升级打包的方式，直接在update.tar下存放所有的文件　
#3.2017年09月19日 wanghaipeng: 增加了打包HMI_x86

#用于生成安装包
#生成工具所在路径，环境不同需要更改
CURRENT_PATH=`pwd`
CURRENT_HOME_PATH="${HOME}"/
PACKAGE_GENERATOR_PATH=`dirname $CURRENT_PATH`/
#打包结果生成路径
PACKAGE_DEST_DIR="$PACKAGE_GENERATOR_PATH"Install/
#打包所需的源文件所在路径
PACKAGE_SOURCE_DIR="$PACKAGE_GENERATOR_PATH"SourceFiles/
#打包指令所在路径
PACKAGE_COMMAND_DIR="$PACKAGE_GENERATOR_PATH"Command/
#当前主机所在路径
CURRENT_LOCAL_PATH="$CURRENT_HOME_PATH"HMI_workspace/

#带颜色的信息输出
ColorEcho(){
	echo -e "\033[40;33m $1 \033[0m"
}
#把动态库拷到Source文件目录
CopyDynamicLibrary(){
if [ $1 == gnu ]; then
	ColorEcho "Copy gnu!"
        sudo cp -r /root/ARCSimage/plugins/weld "$PACKAGE_SOURCE_DIR"weld_gnu
        sudo cp /home/ae/config/plugins/weld/* "$PACKAGE_SOURCE_DIR"weld_gnu/config
	exit 1
fi
	ColorEcho "delete xenomai!"
	sudo rm -rf "$PACKAGE_SOURCE_DIR""weld_$1"/RC/weld/plugins/*
	sudo rm -rf "$PACKAGE_SOURCE_DIR""weld_$1"/RC/weld/subprog/*
	ColorEcho "Copy xenomai!"
	ColorEcho "Copy RC!"
	sudo cp -rf /home/ae/config/plugins/weld "$PACKAGE_SOURCE_DIR""weld_$1"/RC/weld/config/plugins/   
	sudo cp -rf /root/ARCSimage/plugins/weld "$PACKAGE_SOURCE_DIR""weld_$1"/RC/weld/plugins/
	sudo cp -rf ../../../weld/src/packfiles/config/subprog/weld "$PACKAGE_SOURCE_DIR""weld_$1"/RC/weld/subprog/
	ColorEcho "Copy HMI!"
	sudo cp -rf "$CURRENT_LOCAL_PATH"newRobotHMI/depend_files/alarm/packages/weld/* "$PACKAGE_SOURCE_DIR""weld_$1"/HMI/alarm/
	sudo cp -rf "$CURRENT_LOCAL_PATH"newRobotHMI/depend_files/language/packages/weld/* "$PACKAGE_SOURCE_DIR""weld_$1"/HMI/language/
	sudo cp -rf "$CURRENT_LOCAL_PATH"newRobotHMI/depend_files/qss/packages/weld/* "$PACKAGE_SOURCE_DIR""weld_$1"/HMI/qss/
	sudo cp -rf "$CURRENT_LOCAL_PATH"newRobotHMI/depend_files/parameter/packages/weld/* "$PACKAGE_SOURCE_DIR""weld_$1"/HMI/parameter/
        sudo cp -rf "$CURRENT_LOCAL_PATH"hmi_lib/arm/libWeldPackage.so.1.0.0 "$PACKAGE_SOURCE_DIR""weld_$1"/HMI/lib/


}

GenerateFinish(){
	sync
	sync
	ColorEcho "Copy Finish!!!"
}

#-----主函数-----

#把动态库拷到Source文件目录
CopyDynamicLibrary $1

#生成结束
GenerateFinish
