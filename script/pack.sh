#!/bin/bash

# src_dir=$(pwd)
src_dir=/home/ae/workspace/code/pack


src_arcs=${src_dir}/ARCS
arcs_md5=$(md5sum "$src_arcs" | awk '{print $1}')
echo $arcs_md5

src_arcs_pdb=${src_dir}/ARCS.pdb

src_so=${src_dir}/libarcs_rtt_xenomai.so
so_md5=$(md5sum $src_so)
echo "$src_so $so_md5" 

src_so_pdb=${src_dir}/libarcs_rtt_xenomai.so.pdb

# 更新安装包的ARCS和libarcs_rtt_xenomai.so文件
UpdateFiles() {
  dst_dir=/home/ae/workspace/code/UpdateTool/UpdateTool_master/upgrade/SourceFiles

  for dir in ${dst_dir}/*/; do
    if [ -d "$dir" ]; then
      dst_arcs="$dir"Binaries/ARCS
      if [ -e "$dst_arcs" ]; then
        cp -vf "$src_arcs" "$dst_arcs"
        echo "$dst_arcs md5sum is " $(md5sum "$dst_arcs")
      fi

      dst_so="$dir"Libraries/libarcs_rtt_xenomai.so
      if [ -e "$dst_so" ]; then
        cp -vf "$src_so" "$dst_so"
        echo "$dst_so md5sum is " $(md5sum "$dst_so")
      fi
    fi
  done
}

# 打包
MakePackage() {
  make_package=/home/ae/workspace/code/UpdateTool/UpdateTool_master/upgrade/Command/make_package.sh
  formmatted_date=$(date +%y%m%d)
  version="2.6.6.$formmatted_date"_rc
  "$make_package" -all $version $version
}

# echo ${src_dir}
# echo ${ARCS}
# echo ${ARCS_PDB}
# echo ${SO}
# echo ${SO_PDB}
