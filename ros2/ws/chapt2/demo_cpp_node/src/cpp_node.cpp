#include "rclcpp/rclcpp.hpp"

#include <algorithm>
#include <memory>
#include <vector>

int main(int argc, char**argv) {
    rclcpp::init(argc, argv);

    auto node = std::make_shared<rclcpp::Node>("cpp_node");
    RCLCPP_INFO(node->get_logger(), "你好， C++ 节点");
    rclcpp::spin(node);
    rclcpp::shutdown();
    
    return 0;
}