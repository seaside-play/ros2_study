#include "include/cloud_process.h"

#include <chrono>
#include <thread>

#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>

#include <pcl/filters/voxel_grid.h>
#include <pcl/filters/passthrough.h>
#include <pcl/visualization/pcl_visualizer.h>
#include <pcl/features/normal_3d.h>
#include <pcl/surface/gp3.h>

#include <vtkSmartPointer.h>
#include <vtkRenderer.h>
#include <vtkRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkOpenGLShaderProperty.h>

#include <fstream>
#include <sstream>

bool CloudProcess::ConvertTxtToPcd(const std::string& src_path, const std::string& dst_path) {
    // 创建点云对象
    pcl::PointCloud<pcl::PointNormal>::Ptr cloud(new pcl::PointCloud<pcl::PointNormal>);
    
    // 打开文件
    std::ifstream file(src_path);
    if (!file.is_open()) {
        std::cerr << "无法打开文件！" << std::endl;
        return false;
    }
    
    std::string line;
    // 逐行读取数据
    while (std::getline(file, line)) {
        std::istringstream iss(line);
        pcl::PointNormal point;
        
        std::string token;
        int count = 0;
        float x, y, z, nx, ny, nz;
        while (std::getline(iss, token, ',')) {
            if (token.empty()) continue; // 跳过空字符串（如连续逗号的情况）

            // 转换为浮点数并赋值
            try {
                float val = std::stof(token);
                switch (count) {
                    case 0: point.x = val; break;
                    case 1: point.y = val; break;
                    case 2: point.z = val; break;
                    case 3: point.normal_x = val; break;
                    case 4: point.normal_y = val; break;
                    case 5: point.normal_z = val; break;
                    default: break; // 超过6个字段时忽略
                }
                count++;
            } catch (...) {
                std::cerr << "行数据格式错误：" << line << std::endl;
                break;
            }
        }
        // // 读取六个参数
        // if (!(iss >> point.x >> point.y >> point.z >> point.normal_x >> point.normal_y >> point.normal_z)) {
        //     std::cerr << "读取点数据失败！" << std::endl;
        //     return (-1);
        // }
        
        // 添加点到点云
        cloud->points.push_back(point);
    }
    
    // 设置点云属性
    cloud->width = cloud->points.size();
    cloud->height = 1;  // 无序点云
    cloud->is_dense = true;
    
    // 输出点云信息
    std::cout << "读取的点云包含 " << cloud->points.size() << " 个点" << std::endl;
    
    // 可以将点云保存为PCD格式
    pcl::io::savePCDFileASCII(dst_path, *cloud);
    std::cout << "点云已保存为: " << dst_path << std::endl;

    return true;
}

bool CloudProcess::Show(const std::string &pcd_path) {
    // 1. 加载PCD文件
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
    if (pcl::io::loadPCDFile<pcl::PointXYZ>(pcd_path, *cloud) == -1) {
        PCL_ERROR("Couldn't read the PCD file\n");
        return false;
    }
    std::cout << "Loaded " << cloud->size() << " points from PCD file." << std::endl;

    // 2. 点云处理：体素网格降采样（可选）
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_filtered(new pcl::PointCloud<pcl::PointXYZ>);
    pcl::VoxelGrid<pcl::PointXYZ> sor;
    sor.setInputCloud(cloud);
    sor.setLeafSize(0.01f, 0.01f, 0.01f); // 设置体素大小（1cm）
    sor.filter(*cloud_filtered);
    std::cout << "Downsampled to " << cloud_filtered->size() << " points." << std::endl;

    // 3. 点云处理：直通滤波（可选）
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_pass(new pcl::PointCloud<pcl::PointXYZ>);
    pcl::PassThrough<pcl::PointXYZ> pass;
    pass.setInputCloud(cloud_filtered);
    pass.setFilterFieldName("z");
    pass.setFilterLimits(0.0, 1.0); // 只保留z坐标在0-1米之间的点
    pass.filter(*cloud_pass);
    std::cout << "Filtered to " << cloud_pass->size() << " points." << std::endl;

    // 4. 计算法线（用于后续处理或可视化）
    pcl::PointCloud<pcl::Normal>::Ptr normals(new pcl::PointCloud<pcl::Normal>);
    pcl::NormalEstimation<pcl::PointXYZ, pcl::Normal> ne;
    pcl::search::KdTree<pcl::PointXYZ>::Ptr tree(new pcl::search::KdTree<pcl::PointXYZ>);
    ne.setInputCloud(cloud_pass);
    ne.setSearchMethod(tree);
    ne.setRadiusSearch(0.01); // 设置搜索半径为3cm
    ne.compute(*normals);
    std::cout << "Normals computed." << std::endl;

    // 5. 保存处理后的点云
    pcl::io::savePCDFileASCII("processed_cloud.pcd", *cloud_pass);
    std::cout << "Saved processed cloud to 'processed_cloud.pcd'" << std::endl;

    // 6. 可视化点云（使用PCL Visualizer）
    pcl::visualization::PCLVisualizer::Ptr viewer(new pcl::visualization::PCLVisualizer("3D Viewer"));
    viewer->setBackgroundColor(0, 0, 0); // 设置背景为黑色
    
    // 添加点云
    pcl::visualization::PointCloudColorHandlerCustom<pcl::PointXYZ> single_color(cloud_pass, 255, 255, 255);
    viewer->addPointCloud<pcl::PointXYZ>(cloud_pass, single_color, "sample cloud");
    viewer->setPointCloudRenderingProperties(pcl::visualization::PCL_VISUALIZER_POINT_SIZE, 1, "sample cloud");
    
    // 可选：添加法线（会降低性能，点云较密集时建议跳过）
    // viewer->addPointCloudNormals<pcl::PointXYZ, pcl::Normal>(cloud_pass, normals, 10, 0.05, "normals");
    return true;

    // 添加坐标系
    viewer->addCoordinateSystem(1.0);
    viewer->initCameraParameters();

    // 7. 可选：表面重建（将点云转换为网格）
    // 注意：此步骤需要法线已计算
    pcl::PolygonMesh triangles;
    pcl::GreedyProjectionTriangulation<pcl::PointNormal> gp3;
    pcl::PointCloud<pcl::PointNormal>::Ptr cloud_with_normals(new pcl::PointCloud<pcl::PointNormal>);
    
    // 合并点和法线
    pcl::concatenateFields(*cloud_pass, *normals, *cloud_with_normals);
    
    // 设置重建参数
    gp3.setInputCloud(cloud_with_normals);
    gp3.setSearchRadius(0.025); // 设置搜索半径
    gp3.setMu(2.5); // 设置最大距离系数
    gp3.setMaximumNearestNeighbors(100); // 设置最大近邻数
    gp3.setMaximumSurfaceAngle(M_PI / 4); // 设置最大表面角（45度）
    gp3.setMinimumAngle(M_PI / 18); // 设置最小三角形角（10度）
    gp3.setMaximumAngle(2 * M_PI / 3); // 设置最大三角形角（120度）
    gp3.setNormalConsistency(false); // 设置法线一致性
    gp3.reconstruct(triangles); // 执行重建
    
    // 添加重建的网格到可视化
    viewer->addPolygonMesh(triangles, "mesh");

    // 8. 显示可视化窗口并等待关闭
    std::cout << "Press 'q' to exit the visualization window." << std::endl;
    while (!viewer->wasStopped()) {
        viewer->spinOnce(100);
        std::this_thread::sleep_for(std::chrono::microseconds(100000));
    }

    return true;
}

bool CloudProcess::Render() {
    // 创建一个简单的渲染场景
    vtkSmartPointer<vtkRenderer> renderer = vtkSmartPointer<vtkRenderer>::New();
    vtkSmartPointer<vtkRenderWindow> renderWindow = vtkSmartPointer<vtkRenderWindow>::New();
    renderWindow->AddRenderer(renderer);
    vtkSmartPointer<vtkRenderWindowInteractor> interactor = vtkSmartPointer<vtkRenderWindowInteractor>::New();
    interactor->SetRenderWindow(renderWindow);

    // 创建一个简单的mapper和actor
    vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
    actor->SetMapper(mapper);
    renderer->AddActor(actor);

    // 获取着色器属性对象（关键修改点）
    vtkOpenGLShaderProperty* shaderProperty = 
        vtkOpenGLShaderProperty::SafeDownCast(mapper->GetShaderProperty());

    // 自定义顶点着色器
    std::string vertexShader = 
        "//VTK::System::Dec\n"
        "attribute vec4 vertexMC;\n"
        "attribute vec3 normalMC;\n"
        "//VTK::Normal::Dec\n"
        "//VTK::Color::Dec\n"
        "//VTK::Texture::Dec\n"
        "//VTK::PositionVC::Dec\n"
        "//VTK::Light::Dec\n"
        "//VTK::Picking::Dec\n"
        "//VTK::DepthPeeling::Dec\n"
        "//VTK::Clip::Dec\n"
        "//VTK::CoordinateSystem::Dec\n"
        "\n"
        "void main(void)\n"
        "{\n"
        "  //VTK::Normal::Impl\n"
        "  //VTK::Color::Impl\n"
        "  //VTK::Texture::Impl\n"
        "  //VTK::PositionVC::Impl\n"
        "  //VTK::Light::Impl\n"
        "  //VTK::Picking::Impl\n"
        "  //VTK::DepthPeeling::Impl\n"
        "  //VTK::Clip::Impl\n"
        "  //VTK::CoordinateSystem::Impl\n"
        "  gl_Position = MCDCMatrix * vertexMC;\n"
        "}\n";

    // 自定义片段着色器
    std::string fragmentShader = 
        "//VTK::System::Dec\n"
        "//VTK::Output::Dec\n"
        "\n"
        "void main(void)\n"
        "{\n"
        "  gl_FragData[0] = vec4(1.0, 0.0, 0.0, 1.0); // 红色\n"
        "}\n";

    // 设置自定义着色器（关键修改点）
    shaderProperty->SetVertexShaderCode(vertexShader.c_str());
    shaderProperty->SetFragmentShaderCode(fragmentShader.c_str());

    // 渲染并启动交互
    renderWindow->Render();
    interactor->Start();

    return true;
}