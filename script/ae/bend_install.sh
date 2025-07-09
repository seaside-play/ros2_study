#!/bin/bash
#-----修改记录-----
#1.2017年08月28日 liyuan: create by liyuan 
#2.2017年09月05日 liyuan: 修改了HMI升级打包的方式，直接在update.tar下存放所有的文件　
#3.2017年09月19日 wanghaipeng: 增加了打包HMI_x86

#用于生成安装包
#生成工具所在路径，环境不同需要更改
CURRENT_PATH=`pwd`
PACKAGE_GENERATOR_PATH=`dirname $CURRENT_PATH`/
#打包结果生成路径
PACKAGE_DEST_DIR="$PACKAGE_GENERATOR_PATH"Install/
#打包所需的源文件所在路径
PACKAGE_SOURCE_DIR="$PACKAGE_GENERATOR_PATH"SourceFiles/
#打包指令所在路径
PACKAGE_COMMAND_DIR="$PACKAGE_GENERATOR_PATH"Command/

#带颜色的信息输出
ColorEcho(){
	echo -e "\033[40;33m $1 \033[0m"
}

#创建输出目录，如果存在就文件则清空
CreateDIR(){
	for output_dir in bend_lxrt bend_xenomai;
	do
		if [ ! -d "$PACKAGE_DEST_DIR""$output_dir" ]; then
			mkdir -p "$PACKAGE_DEST_DIR""$output_dir"
		else
			rm -rf "$PACKAGE_DEST_DIR""$output_dir"/*
		fi
	done
}

#创建安装包，目前只有lxrt和xenomai，还未支持GnuLinux
CreatePackage(){
	if [ $1 = "pack-bend" ]; then
		for output_dir in bend_lxrt bend_xenomai;
		do
			ColorEcho "Generating ${output_dir} package..."
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
	        	tar -cf bend.tar bend
                        tar -cf "$PACKAGE_DEST_DIR"${output_dir}/update.tar -C "$PACKAGE_SOURCE_DIR"${output_dir} .
			cd "$PACKAGE_DEST_DIR""$output_dir"
			"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
			oldFileName=$1_$2.update
			mv $oldFileName $1_$2_${output_dir}.update
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
			rm -rf bend.tar
			cd "$PACKAGE_DEST_DIR"${output_dir}
			rm -rf update.tar
		done
	fi
}


GenerateFinish(){
	sync
	sync
	ColorEcho "Finish!!!"
}

#-----主函数-----
#创建目录，清空原有的包
CreateDIR
#创建弧焊包
CreatePackage pack-bend $2
#生成结束
GenerateFinish
