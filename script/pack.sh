#!/bin/bash

# src_dir=$(pwd)
#src_dir=/home/ae/workspace/code/pack
src_dir=/home/ae/ws/UpdateTool/new_version

dst_upgrade_folder=/home/ae/ws/UpdateTool/UpdateTool_master

echo $(whoami)

src_arcs=${src_dir}/ARCS
src_arcs_pdb=${src_dir}/ARCS.pdb
src_so=${src_dir}/libarcs_rtt_xenomai.so
src_so_pdb=${src_dir}/libarcs_rtt_xenomai.so.pdb

formmatted_date=$(date +%y%m%d)
version="2.6.6.$formmatted_date"_rc

PrintMd5() {
  if [ -e $1 ]; then 
    current_md5=$(md5sum "$1" | awk '{print $1}')
    echo $current_md5 $1 
  fi
}

# 更新二代柜的安装包的ARCS和libarcs_rtt_xenomai.so文件
UpdateFiles() {
  echo "-->UpdateFiles"
  dst_dir=$dst_upgrade_folder/upgrade/SourceFiles

  for dir in ${dst_dir}/*/; do
    if [ -d "$dir" ]; then
      dst_so="$dir"Libraries/libarcs_rtt_xenomai.so
      if [ -e "$dst_so" ]; then
        cp -f "$src_so" "$dst_so"
        PrintMd5 "$dst_so"
      else
        # echo "There are no " $dst_so
        continue
      fi

      dst_arcs="$dir"Binaries/ARCS
      if [ -e "$dst_arcs" ]; then
        cp -f "$src_arcs" "$dst_arcs"
        PrintMd5 "$dst_arcs"
      fi
    fi
  done
  echo "<--UpdateFiles"
}

# 打包
MakePackage() {
  echo "-->MakePackage"
  cd $dst_upgrade_folder/upgrade/Command
  ./make_package.sh -all $version $version
  echo "<--MakePackage"
}

CopyPDB() {
  echo "-->CopyPDB"
  dst_dir=$dst_upgrade_folder/upgrade/Install/pdb
  rm -fr $dst_dir
  mkdir -p $dst_dir
  
  PrintMd5 $src_arcs_pdb
  cp $src_arcs_pdb $dst_dir
  PrintMd5 $dst_dir/ARCS.pdb
  
  PrintMd5 $src_so_pdb
  cp $src_so_pdb $dst_dir
  PrintMd5 $dst_dir/libarcs_rtt_xenomai.so.pdb

  cd $dst_upgrade_folder/upgrade/Install/pdb
  tar -czvf pdb.tar.gz ./*
  rm ./libarcs_rtt_xenomai.so.pdb
  rm ./ARCS.pdb
  echo "<--CopyPDB"
}

ZipInstall() {
  echo "-->ZipInstall"
  install_dir=$dst_upgrade_folder/upgrade
  cd $install_dir
  zip -r9 $version.zip install/
  echo "<--ZipInstall"
}

PrintMd5 $src_arcs
PrintMd5 $src_so

UpdateFiles
MakePackage
CopyPDB
ZipInstall