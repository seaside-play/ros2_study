#!/bin/bash

WORKSPACE_PATH=${HOME}/repository
HMI_SRC_PATH=$WORKSPACE_PATH/newRobotHMI
HMI_WELD_LIBRARY_PATH=$WORKSPACE_PATH/hmi_lib
ARCS_SRC_PATH=$WORKSPACE_PATH/newARCS
WELD_PACK_SRC_PATH=$WORKSPACE_PATH/weld


CURRENT_PATH=`pwd`
PACKAGE_GENERATOR_PATH=`dirname $CURRENT_PATH`

PACKAGE_DEST_DIR="$PACKAGE_GENERATOR_PATH"/Install
PACKAGE_SOURCE_DIR="$PACKAGE_GENERATOR_PATH"/SourceFiles
PACKAGE_COMMAND_DIR="$PACKAGE_GENERATOR_PATH"/Command

ColorEcho(){
    echo -e "\033[40;33m $1 \033[0m"
}

CopyDynamicLibrary(){
    ColorEcho "delete ori $1!"
    sudo rm -rf "$PACKAGE_SOURCE_DIR"/"weld_$1"/RC/weld/plugins/*
    sudo rm -rf "$PACKAGE_SOURCE_DIR"/"weld_$1"/RC/weld/subprog/*
    ColorEcho "Copy xenomai!"

    ColorEcho "Copy RC!"
    [[ -d $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/config/plugins/weld ]] || sudo mkdir -p $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/config/plugins/weld
    sudo cp -rf $WELD_PACK_SRC_PATH/src/packfiles/config/weld_db/weld.db $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/config/plugins/weld   
    sudo cp -rf $WELD_PACK_SRC_PATH/src/packfiles/config/weld_db/weld.sql $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/config/plugins/weld   

    [[ -d $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/plugins ]] || sudo mkdir -p $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/plugins
    sudo cp -rf $WELD_PACK_SRC_PATH/src/packfiles/dependency $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/plugins/   

    sudo cp -rf $WELD_PACK_SRC_PATH/xenomai/src/weld_database/libWeldDataBase.so $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/
    sudo cp -rf $WELD_PACK_SRC_PATH/xenomai/src/global_service/libGlobalWeldService.so $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/plugins/   
    sudo cp -rf $WELD_PACK_SRC_PATH/xenomai/src/bag_info/libWeldBagInfo.so $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/plugins/   
    sudo cp -rf $WELD_PACK_SRC_PATH/xenomai/src/commands/libWeldCommandkit.so $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/plugins/   
    sudo cp -rf $WELD_PACK_SRC_PATH/xenomai/src/channel_service/libWelderService.so $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/plugins/   
    sudo cp -rf $WELD_PACK_SRC_PATH/xenomai/src/rcf_server/libWeldServer.so $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/plugins/   
        
    sudo cp -rf $WELD_PACK_SRC_PATH/uninstall.sh $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/

    [[ -d $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/types/ ]] || sudo mkdir -p $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/types/
    sudo cp -rf $WELD_PACK_SRC_PATH/xenomai/src/transports/libWeldTransport.so $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/types/   
    sudo cp -rf $WELD_PACK_SRC_PATH/xenomai/src/types/libWeldTypekit.so $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/plugins/weld/types/   
    
    [[ -d $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/subprog/weld ]] || sudo mkdir -p $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/subprog/weld
    sudo cp -rf $WELD_PACK_SRC_PATH/src/packfiles/config/subprog/weld/* $PACKAGE_SOURCE_DIR/weld_$1/RC/weld/subprog/weld

    ColorEcho "Copy HMI!"
    sudo cp -rf $HMI_SRC_PATH/depend_files/alarm/packages/weld/* $PACKAGE_SOURCE_DIR/weld_$1/HMI/alarm/
    sudo cp -rf $HMI_SRC_PATH/depend_files/language/packages/weld/* $PACKAGE_SOURCE_DIR/weld_$1/HMI/language/
    sudo cp -rf $HMI_SRC_PATH/depend_files/qss/packages/weld/* $PACKAGE_SOURCE_DIR/weld_$1/HMI/qss/
    sudo cp -rf $HMI_SRC_PATH/depend_files/parameter/packages/weld/* $PACKAGE_SOURCE_DIR/weld_$1/HMI/parameter/
    sudo cp -rf $HMI_WELD_LIBRARY_PATH/arm/libWeldPackage.so.1.0.0 $PACKAGE_SOURCE_DIR/weld_$1/HMI/lib/
}

GenerateFinish(){
    sync
    sync
    ColorEcho "Copy Finish!!!"
}

#-----主函数-----
if [[ $# -eq 0 ]]
then
    ColorEcho "usage: "
    ColorEcho "  ./weld_sync_files.sh xenomai"
    exit 1
fi

#把动态库拷到Source文件目录
CopyDynamicLibrary $1

#生成结束
GenerateFinish
