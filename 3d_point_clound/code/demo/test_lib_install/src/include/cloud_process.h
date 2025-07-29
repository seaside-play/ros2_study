#ifndef CLOUD_PROCESS_H_
#define CLOUD_PROCESS_H_

#include <string>

class CloudProcess {
 public:
  bool ConvertTxtToPcd(const std::string& src_path, const std::string& dst_path);
  bool Show(const std::string& pcd_path);
  bool Render();
};


#endif 