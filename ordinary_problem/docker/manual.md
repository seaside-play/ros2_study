- sudo apt update
- 有方法可以去掉sudo，直接已docker开始，方便操作
- docker images # 查看本地已下载的镜像
- docker run -it --name u22 ubuntu:22.04 bash #创建并启动一个基于 Ubuntu 22.04 镜像的 Docker 容器
  - 容器名称 u22 可用于后续操作，例如：
    - sudo docker stop u22 # 停止容器
    - sudo docker start -i u22  # `-i` 表示进入交互式 shell # 重启容器
    - sudo docker rm u22 # 删除容器
- 防丢失

    在 Docker 中，防止容器重启后丢失已安装程序的关键在于理解容器的临时性特性，并学会正确使用数据持久化和镜像保存技术。以下是详细解决方案：

      一、理解容器的临时性
      容器≠虚拟机：容器是镜像的临时运行实例，默认情况下，容器内的文件系统变更仅存在于容器运行时。
      数据丢失场景：
        ✅ 正常停止容器（docker stop）或退出交互式 shell（exit）不会删除数据，但下次启动容器时需使用相同容器实例。
        ❌ 重建容器（docker run 重新创建同名容器）或删除容器（docker rm）会导致数据丢失。

      二、正确保存容器状态的方法
      1. 保存容器为新镜像（推荐）
      将已安装程序的容器 “快照” 为新镜像，下次直接基于新镜像启动容器。

          docker ps -a # 1. 查看容器 ID 或名称
          docker commit <容器ID> <新镜像名>:<标签> # 2. 提交容器为新镜像（替换 <容器ID> 和 <新镜像名>）
          docker commit u22 u22-with-tools:v1 # 示例：
          docker run -it --name u22-v1 my-ubuntu22-with-tools:v1 bash # 3. 使用新镜像启动容器

      缺点：不断增加镜像，占具空间

      2. 使用数据卷（持久化关键数据）
      将容器内的关键目录（如应用配置、数据文件）挂载到宿主机，避免容器删除后数据丢失。

      # 启动容器时挂载数据卷
      docker run -it \
        -v /宿主机路径:/容器内路径 \  # 挂载数据卷
        --name u22 \
        ubuntu:22.04 bash

      # 示例：挂载宿主机的 /data 目录到容器的 /app/data
      docker run -it -v /data:/app/data --name u22 ubuntu:22.04 bash


      优点：数据与容器分离，可在不同容器间共享。
      适用场景：数据库文件、配置文件、上传的内容等。

      3. 使用 Dockerfile 构建自定义镜像（推荐长期方案）
      编写 Dockerfile 定义环境配置，通过 docker build 构建可复用的镜像。
      # Dockerfile
      FROM ubuntu:22.04
      RUN apt update && apt install -y \
        vim \
        curl \
        && rm -rf /var/lib/apt/lists/*
      CMD ["bash"]

      docker build -t u22-image . # 构建镜像
      docker run -it --name u22 u22-image bash # 基于自定义镜像启动容器

      # 常见操作
      docker images # 查看本地镜像
      docker ps # 查看运行中的容器
      docker ps -a # 查看所有容器（包括已停止的）

      
      Ctrl+P + Ctrl+Q # 退出容器但保持运行
      docker exec -it u22 bash # 重新进入已运行的容器
      docker stop u22 # 停止容器
      docker run -it u22-image bash  # 新容器，与之前的无关联 # 基于同一镜像启动新容器

- 如何进入已经停止的容器

      docker start <容器名或ID>
      docker start u22
      容器名或 ID：可通过 docker ps -a 查看。

- 如何进入已经运行的容器

      docker exec -it <容器名或ID> bash
      docker exec -it u22 bash

- 启动并进入
    
      docker start -ai <容器名或ID>
      docker start -ai u22

        -a（--attach）：启动后附加到容器的标准输入 / 输出。
        -i（--interactive）：保持交互式会话。

- 注意事项


    - 容器必须处于运行状态才能使用 docker exec 进入。
    - 若容器未正常启动（如启动后立即退出），需检查容器配置或日志：
      
          bash
          docker logs <容器名或ID>

    - 数据持久性：进入容器不会丢失之前安装的程序，除非容器被重建（docker run 重新创建同名容器）。

- 对比不同场景的进入方式

  - 容器状态	命令示例	说明
  - 已运行	`docker exec -it 容器名` bash	最常用方式，不影响容器运行。
  - 已停止	`docker start 容器名`	先启动，再用 exec 进入。
  - 已停止	`docker start -ai 容器名`	启动并直接进入（一步完成）。

- 总结：

  - 使用Dockerfile适合于临时验证某种方案，或临时使用某一中Demo运行的场景，其重点是临时性，实验性和验证性；
  - 若是自己长期使用特定容器环境下，一般不需要使用Dockerfile，直接在容器上不断使用就可以，容器是有运行和停止状态的。