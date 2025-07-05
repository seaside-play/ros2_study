Zsh（Z Shell）是一款功能强大的交互式 shell，相比 Bash 拥有更丰富的功能（如智能补全、主题定制、插件系统等）。以下是在 Ubuntu 22.04 中安装和使用 Zsh 的完整指南：

# 1 安装 Zsh
- echo $SHELL  # 检查当前 shell,通常默认是/bin/bash
- sudo apt install zsh # 安装 Zsh
- chsh -s $(which zsh) # 设置 Zsh 为默认 shell

重启终端后生效（或执行 exec zsh 立即切换）。


# 2 配置 Zsh（推荐使用 Oh My Zsh）
Oh My Zsh 是 Zsh 的流行框架，提供大量插件和主题，简化配置流程：

1. 安装 Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

2. 常用配置文件
- 主配置：~/.zshrc
- 主题配置：~/.oh-my-zsh/themes/
- 插件配置：在.zshrc中修改plugins参数

# 3 核心功能与使用技巧
1. 智能补全
- 文件补全：输入部分文件名后按Tab自动补全
- 命令补全：输入cd /u后按Tab补全为/usr/
- 路径补全：支持模糊匹配，如cd ~/do<tab>补全为~/Documents/
- 插件增强：安装zsh-autosuggestions插件后，会显示历史命令建议（按→键采纳）。

2. 主题定制

    1. 查看可用主题

            ls ~/.oh-my-zsh/themes/

    2. 修改主题

        编辑.zshrc，修改ZSH_THEME参数：

            ZSH_THEME="robbyrussell"  # 默认主题
            # 或改为简洁主题：
            ZSH_THEME="极简主题名"  # 如 "agnoster"（需安装字体）

    
    3. 修改主题

        复制现有主题到~/.oh-my-zsh/themes/mytheme.zsh-theme并修改样式。


3. 插件系统

- 常用插件（在.zshrc的plugins中添加）：

            plugins=(
            git           # Git命令补全与提示
            docker        # Docker命令补全
            npm           # npm命令增强
            zsh-autosuggestions  # 命令自动建议
            zsh-syntax-highlighting  # 语法高亮
            )

- 安装插件
    - zsh-autosuggestions：

            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    - zsh-syntax-highlighting：

            git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 4 常用快捷键与命令            

操作	快捷键 / 命令	说明
- 清屏	clear 或 Ctrl+L	清空终端显示
- 查看历史命令	history	显示命令历史
- 快速跳转目录	cd -	切换到上一个目录
- 分屏终端（需终端支持）	Ctrl+Shift+T	新建标签页
- 搜索历史命令	Ctrl+R	反向搜索历史（输入关键词匹配）
- 终止当前命令	Ctrl+C	中断进程
- 后台运行命令	command &	命令后加&在后台运行


# 5 高级配置技巧
1. 自定义提示符
在.zshrc中添加：

bash
        # 简单示例：显示当前路径和用户名
        PROMPT="%n@%m %~ $ "

- %n：用户名
- %m：主机名
- %~：当前路径
- $：普通用户提示符（#为 root）
2. 环境变量配置
在.zshrc中添加：

bash
        # 添加Python虚拟环境路径
        export PATH="$HOME/.virtualenvs/myenv/bin:$PATH"
        # 配置Java路径
        export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
3. 别名设置
在.zshrc中添加：

bash
        alias ll="ls -laF"        # 显示详细文件信息
        alias grep="grep --color=auto"  # 搜索结果着色
        alias cp="cp -i"          # 复制时询问确认
# 6 故障排除与常见问题
1. 切换回 Bash
bash
    chsh -s $(which bash)

2. 终端显示乱码（主题字体问题）
- 安装 Powerline 字体（如fonts-powerline）：
        bash
        sudo apt install fonts-powerline

- 在终端设置中选择 Powerline 字体（如Meslo LG S DZ for Powerline）。
3. Oh My Zsh 安装失败
手动下载仓库：
bash
        git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc


# 7 推荐扩展工具
- 终端模拟器：
    - Tilix（支持分屏和标签页）
    - Kitty（高性能，支持 GPU 加速）
- Zsh 增强工具：
    - fzf：快速搜索和筛选（配合fzf-tab插件）
    - z：智能目录跳转

配置完成后，Zsh 将提供更高效的命令行体验。建议根据个人需求逐步调整插件和主题，避免过度配置导致性能下降。


# 8 主题推荐

[Reference](https://blog.csdn.net/u014796292/article/details/147208276)

1. 安装字体
安装 Powerlevel10k，需要预先下载主题所需字体

2. 下载安装所需字体
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf

wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf

wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf

wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

双击下载的字体并安装，在终端–配置文件首选项–配置文件（默认配置）–自定义字体中，选择“MesloLGS NF Regular”或者“MesloLGS NF”
安装完成后刷新字体缓存
