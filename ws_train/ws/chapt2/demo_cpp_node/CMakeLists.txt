cmake_minimum_required(VERSION 3.8)
project(demo_cpp_node)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
# uncomment the following section in order to fill in
# further dependencies manually.
# find_package(<dependency> REQUIRED)

find_package(rclcpp REQUIRED) # 系统帮忙茶渣rclcpp库文件
add_executable(cpp_node src/cpp_node.cpp) # 生成可执行文件cpp_node，
ament_target_dependencies(cpp_node rclcpp) # 为可执行文件添加实质性的动态库引用
install(TARGETS # 添加安装的目标节点的起始标识
cpp_node # 添加具体的目标节点
DESTINATION lib/${PROJECT_NAME} # 将目标节点安装到目的位置，此处的${PROJECT_NAME}就是demo_cpp_node字符串
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  # the following line skips the linter which checks for copyrights
  # comment the line when a copyright and license is added to all source files
  set(ament_cmake_copyright_FOUND TRUE)
  # the following line skips cpplint (only works in a git repo)
  # comment the line when this package is in a git repo and when
  # a copyright and license is added to all source files
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
