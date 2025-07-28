#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>

int main() {
  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud (new pcl::PointCloud<pcl::PointXYZ>);
  std::cout << "PCL library installed successfully!" << std::endl;
  return 0;
}
