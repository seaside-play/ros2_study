#!/bin/bash
#-----修改记录-----
#1.2017年08月28日 liyuan: create by liyuan 
#2.2017年09月05日 liyuan: 修改了HMI升级打包的方式，直接在update.tar下存放所有的文件　
#3.2017年09月19日 wanghaipeng: 增加了打包HMI_x86
#4.2018年02月09日 liyuan: 添加了单独打包的功能
#5.20180323 liyuan:修改了打包名称
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
	for output_dir in GnuLinux ARCCD10 ARCCD20 ARCCD22 ARCCD2XP2 ARCSCARA HMI HMI_x86 ARC4 CB30I ARC5-280 palletize_xenomai palletize_quick_xenomai bend_xenomai weld_xenomai pdb;
	do
		if [ ! -d "$PACKAGE_DEST_DIR""$output_dir" ]; then
			mkdir -p "$PACKAGE_DEST_DIR""$output_dir"
		else
			rm -rf "$PACKAGE_DEST_DIR""$output_dir"/*
		fi
	done
}

#创建临时控制柜综合文件夹，将HMI和ARC4/ARCCD2XP2/ARCCD10/ARCCD20/ARCCD22/ARCSCARA/CB30I/ARC5-280柜体升级文件合并至AERobot中
CreateAERobotDIR(){
	if [ ! -d "$PACKAGE_DEST_DIR"AERobot ]; then
		mkdir -p "$PACKAGE_DEST_DIR"AERobot
	else
		rm -rf "$PACKAGE_DEST_DIR"AERobot/*
	fi

	#拷贝HMI
	tar -czf "$PACKAGE_DEST_DIR"AERobot/HMI.tar -C "$PACKAGE_SOURCE_DIR"HMI .

	mkdir -p "$PACKAGE_DEST_DIR"AERobot/ARCS
	#Binaries Libraries Others各柜体文件一致，在此使用ARC4中的文件夹
	cp -r "$PACKAGE_SOURCE_DIR"ARC4/Binaries "$PACKAGE_DEST_DIR"AERobot/ARCS
	cp -r "$PACKAGE_SOURCE_DIR"ARC4/Libraries "$PACKAGE_DEST_DIR"AERobot/ARCS
	cp -r "$PACKAGE_SOURCE_DIR"ARC4/Others "$PACKAGE_DEST_DIR"AERobot/ARCS
	cd "$PACKAGE_DEST_DIR"AERobot
	tar -czf ARCS.tar ARCS
	rm -rf "$PACKAGE_DEST_DIR"AERobot/ARCS

	#其余不一致文件放至对应柜体文件中
	for input_dir in ARC4 ARCCD2XP2 ARCCD10 ARCCD20 ARCCD22 ARCSCARA CB30I ARC5-280;
	do
		mkdir -p "$PACKAGE_DEST_DIR"AERobot/"$input_dir"
		cp -r "$PACKAGE_SOURCE_DIR""$input_dir"/Files "$PACKAGE_DEST_DIR"AERobot/"$input_dir"
		cp -r "$PACKAGE_SOURCE_DIR""$input_dir"/Scripts "$PACKAGE_DEST_DIR"AERobot/"$input_dir"
		cp -r "$PACKAGE_SOURCE_DIR""$input_dir"/install.sh "$PACKAGE_DEST_DIR"AERobot/"$input_dir"
		cp -r "$PACKAGE_SOURCE_DIR""$input_dir"/Readme.txt "$PACKAGE_DEST_DIR"AERobot/"$input_dir"
		cd "$PACKAGE_DEST_DIR"AERobot
		tar -czf "$input_dir".tar "$input_dir"
		rm -rf  "$PACKAGE_DEST_DIR"AERobot/"$input_dir"
	done
}

#创建安装包，目前只有lxrt和xenomai，还为支持GnuLinux
CreatePackage(){
	if [ $1 = "arcs" ]; then
		for output_dir in GnuLinux ARCCD10 ARCCD20 ARCCD22 ARCCD2XP2 ARC4 ARCSCARA CB30I ARC5-280;
		do
			ColorEcho "Generating ${output_dir} package..."
			#将源文件复制到临时目录，并使用strip删除动态库符号信息，减小动态库大小
			if [ ! -d "$PACKAGE_SOURCE_DIR""$output_dir""_bak"/"$output_dir" ]; then
				mkdir -p "$PACKAGE_SOURCE_DIR""$output_dir""_bak"/"$output_dir"
			else
				rm -rf "$PACKAGE_SOURCE_DIR""$output_dir""_bak"/*
			fi
			cp "$PACKAGE_SOURCE_DIR""$output_dir"/* -R "$PACKAGE_SOURCE_DIR""$output_dir""_bak"/"$output_dir"/
			#StripLibraries
			tar -czf "$PACKAGE_DEST_DIR""$output_dir"/update.tar -C "$PACKAGE_SOURCE_DIR""$output_dir""_bak" "$output_dir" 
			rm -rf "$PACKAGE_SOURCE_DIR""$output_dir""_bak"
			cd "$PACKAGE_DEST_DIR""$output_dir"
			"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
			oldFileName=$1_$2.update
			#20180323 liyuan:这个名字的格式与HMI的解析相关，修改前查看HMI代码
			#newFileName=`echo $oldFileName | sed "s/\(^[a-z_.0-9]\+\)\(update$\)/\1${output_dir}\.\2/g"`
			mv $oldFileName $1_$2_${output_dir}.update
			tar -czf "$PACKAGE_DEST_DIR""$output_dir"/update.tar -C "$PACKAGE_SOURCE_DIR" "$output_dir"
		done
		cd "$PACKAGE_DEST_DIR""pdb"
		tar -czf "$PACKAGE_DEST_DIR""pdb"/pdb.tar -C "$PACKAGE_SOURCE_DIR" "pdb"
	fi
	
	if [ $1 = "air-tp" ]; then
		ColorEcho "Generating HMI package..."
		tar -cf "$PACKAGE_DEST_DIR"HMI/update.tar -C "$PACKAGE_SOURCE_DIR"HMI .
		cd "$PACKAGE_DEST_DIR"HMI
		"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
	fi

	if [ $1 = "air-tp_x86" ]; then
		ColorEcho "Generating HMI_x86 package..."
		tar -cf "$PACKAGE_DEST_DIR"HMI_x86/update.tar -C "$PACKAGE_SOURCE_DIR"HMI_x86 .
		cd "$PACKAGE_DEST_DIR"HMI_x86
		"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
	fi
	
	if [ $1 = "pack-weld" ]; then
		for platform in xenomai;
		do
		    	output_dir=weld_${platform}
			ColorEcho "Generating ${output_dir} package..."
			tar -cf "$PACKAGE_DEST_DIR"${output_dir}/update_weld.tar -C "$PACKAGE_SOURCE_DIR"${output_dir} .
			#if [ ${platform} = "xenomai" ]; then
			#	StripWeldLibraries
			#fi
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
	        	tar -cf weld.tar weld
            		tar -cf "$PACKAGE_DEST_DIR"${output_dir}/update.tar -C "$PACKAGE_SOURCE_DIR"${output_dir} .
			cd "$PACKAGE_DEST_DIR""$output_dir"
			"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
			oldFileName=$1_$2.update
			mv $oldFileName $1_$2_${platform}.update
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
			rm -rf weld.tar
			cd "$PACKAGE_DEST_DIR"${output_dir}
			rm -rf update.tar
		done
	fi

	if [ $1 = "pack-palletize" ]; then
		for platform in xenomai;
		do
			output_dir=palletize_${platform}
			ColorEcho "Generating ${output_dir} package..."
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
	        tar -cf palletize.tar palletize
            tar -cf "$PACKAGE_DEST_DIR"${output_dir}/update.tar -C "$PACKAGE_SOURCE_DIR"${output_dir} .
			cd "$PACKAGE_DEST_DIR""$output_dir"
			"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
			oldFileName=$1_$2.update
			mv $oldFileName $1_$2_${platform}.update
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
			rm -rf palletize.tar
			cd "$PACKAGE_DEST_DIR"${output_dir}
			rm -rf update.tar
		done
	fi
	
	if [ $1 = "pack-palletize_quick" ]; then
		for platform in xenomai;
		do
			output_dir=palletize_quick_${platform}
			ColorEcho "Generating ${output_dir} package..."
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
	        tar -cf palletize_quick.tar palletize_quick
            tar -cf "$PACKAGE_DEST_DIR"${output_dir}/update.tar -C "$PACKAGE_SOURCE_DIR"${output_dir} .
			cd "$PACKAGE_DEST_DIR""$output_dir"
			"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
			oldFileName=$1_$2.update
			mv $oldFileName $1_$2_${platform}.update
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
			rm -rf palletize_quick.tar
			cd "$PACKAGE_DEST_DIR"${output_dir}
			rm -rf update.tar
		done
	fi

	if [ $1 = "pack-bend" ]; then
		for platform in xenomai;
		do
			output_dir=bend_${platform}
			ColorEcho "Generating ${output_dir} package..."
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
	        tar -cf bend.tar bend
            tar -cf "$PACKAGE_DEST_DIR"${output_dir}/update.tar -C "$PACKAGE_SOURCE_DIR"${output_dir} .
			cd "$PACKAGE_DEST_DIR""$output_dir"
			"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
			oldFileName=$1_$2.update
			mv $oldFileName $1_$2_${platform}.update
			cd "$PACKAGE_SOURCE_DIR"${output_dir}/RC
			rm -rf bend.tar
			cd "$PACKAGE_DEST_DIR"${output_dir}
			rm -rf update.tar
		done
	fi
	#if [ $1 = "pack-coop" ]; then
	#	for output_dir in ACR5;
	#	do
	#		ColorEcho "Generating ${output_dir} package..."
	#		tar -czf "$PACKAGE_DEST_DIR""$output_dir"/update.tar -C "$PACKAGE_SOURCE_DIR" "$output_dir" 
	#		cd "$PACKAGE_DEST_DIR""$output_dir"
	#		"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
	#		oldFileName=$1_$2.update
	#		#newFileName=`echo $oldFileName | sed "s/\(^[a-z_.0-9]\+\)\(update$\)/\1${output_dir}\.\2/g"`
	#		mv $oldFileName $1_$2_${output_dir}.update
	#	done
	#fi

	if [ $1 = "ae-robot" ]; then
		ColorEcho "Generating AERobot package..."
		CreateAERobotDIR
		cd "$PACKAGE_DEST_DIR"AERobot
		tar -cf update.tar *.tar --remove-files
		"$PACKAGE_COMMAND_DIR"aoi_update $1 $2
	fi
}

#将关于标准柜的PLC、INT、1200放到install中,暂时不用专门生成
CopyFirmware(){
	if [ ! -d "${PACKAGE_GENERATOR_PATH}Install/Firmware" ]; then
		mkdir -p "${PACKAGE_GENERATOR_PATH}Install/Firmware"
	fi
	cp ${PACKAGE_GENERATOR_PATH}Legacy/Firmware/* ${PACKAGE_GENERATOR_PATH}Install/Firmware
}

GenerateFinish(){
	sync
	sync
	ColorEcho "Finish!!!"
}

StripLibraries(){
	cd "$PACKAGE_SOURCE_DIR""$output_dir""_bak"/"$output_dir"/Libraries/
	if [ $output_dir = "GnuLinux" ]; then
		strip "libarcs-rkd.so"
		strip "libarcs_rtt_gnulinux.so"
		strip "libRkdInterface.so"
	else
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libarcs-rkd.so"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libarcs_rtt_xenomai.so"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libcanopen.so"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libethercat.so"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libethercat_rtdm.so.1"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libmelsec.so"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libmodbus.so.5.1.0"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libmotion_commu.so"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libRCF.so"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libreadline.so.5.2"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libRkdInterface.so"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "librtex.so"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "sqlite/libsqlite3.so.0.8.6"
		/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "sqlite/libxml2db_xenomai.so"
	fi
}

StripWeldLibraries(){
	cd "$PACKAGE_SOURCE_DIR"weld_xenomai/HMI/lib/
	/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libWeldPackage.so.1.0.0"
	cd "$PACKAGE_SOURCE_DIR"weld_xenomai/RC/weld/plugins/weld/
	/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libWeldDataBase.so"
	cd plugins
	/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libWeldBagInfo.so"
	/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libWelderService.so"
	/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libGlobalWeldService.so"
	/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libWeldCommandkit.so"
	/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libWeldServer.so"
	cd ../types/
	/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libWeldTransport.so"
	/usr/local/ti-sdk-am335x-evm/linux-devkit/sysroots/i686-arago-linux/usr/bin/arm-linux-gnueabihf-strip "libWeldTypekit.so"
}

#-----主函数-----
#判断两种使用方式: -all全部构建; -single单独构建
if [ $# != 3 ]; then
	echo "Command Format Error!!!"
	echo "1 usage: ./make_package.sh -all ARCS_version HMI_Version"
	echo "2 usage: ./make_package.sh -single packname version"
	echo "  packname: [arcs, air-tp, air-tp_x86, weld_xenomai, palletize_xenomai, palletize_quick_xenomai, bend_xenomai, acr5, ae-robot]"
	exit 1
fi

if [ $1 = "-all" ]; then
	#创建目录，清空原有的包
	CreateDIR
	#为标准柜1200 PLC INT使用
	CopyFirmware
	#生成ARCS包
	CreatePackage arcs $2
	#生成HMI包
	CreatePackage air-tp $3
	#生成HMI_x86包
	CreatePackage air-tp_x86 $3
	#生成weld包
	CreatePackage pack-weld $3
	#生成palletize包
	CreatePackage pack-palletize $3
	#生成palletize_quick包
	CreatePackage pack-palletize_quick $3
	#生成bend包
	CreatePackage pack-bend $3
	#生成coop包
	CreatePackage pack-coop $3
	#生成ae-robot包
	CreatePackage ae-robot $3
else
	#创建目录，清空原有的包
	CreateDIR
	if [ $2 = "arcs" ]; then
		#为标准柜1200 PLC INT使用
		CopyFirmware
		CreatePackage arcs $3
	elif [ $2 = "air-tp" ]; then
		CreatePackage air-tp $3
	elif [ $2 = "air-tp_x86" ]; then
		CreatePackage air-tp_x86 $3
	elif [ $2 = "weld" ]; then
		CreatePackage pack-weld $3
	elif [ $2 = "palletize" ]; then
		CreatePackage pack-palletize $3
	elif [ $2 = "palletize_quick" ]; then
		CreatePackage pack-palletize_quick $3
	elif [ $2 = "bend" ]; then
		CreatePackage pack-bend $3
	elif [ $2 = "acr5" ]; then
		CreatePackage pack-coop $3
	elif [ $2 = "ae-robot" ]; then
		CreatePackage ae-robot $3
	fi
fi

#安装编程手册
cp -R ${PACKAGE_SOURCE_DIR}ProgramDoc ${PACKAGE_DEST_DIR}

#安装系统参数自动化测试程序
cp -R ${PACKAGE_SOURCE_DIR}SystemParamAutoTest ${PACKAGE_DEST_DIR}

#复制Install文件夹说明文件
cp -R ${PACKAGE_SOURCE_DIR}InstallReadMe.md ${PACKAGE_DEST_DIR}ReadMe.md

#复制RelaseNote
cp -r ${PACKAGE_GENERATOR_PATH}ReleaseNotes ${PACKAGE_DEST_DIR}

#生成结束
GenerateFinish




