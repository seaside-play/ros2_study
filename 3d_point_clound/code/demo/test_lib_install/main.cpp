#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include "src/include/cloud_process.h"

int main() {
  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud (new pcl::PointCloud<pcl::PointXYZ>);
  std::cout << "PCL library installed successfully!" << std::endl;

  std::string dir {"/home/ae/repo/ros2_study/3d_point_clound/code/demo/test_lib_install/" };
  std::string file_name {"airplane/airplane_0001.txt"}; 
  std::string dst_file_name {"pcd/airplane_0001.pcd"};

  CloudProcess cloud_process;
  // clound_process.ConvertTxtToPcd(dir+file_name, dir+dst_file_name);
  // cloud_process.Show(dir+dst_file_name);
  cloud_process.Render();
  return 0;
}