# 问题锦集

# 1 在英文版Ubuntu22.04上，安装chrome之后sogou拼音输入法无法输出中文

sudo apt install *gtk4 : 在英文版Ubuntu22.04上，解决安装chrome之后无法输入sogou中文输入法的问题


[https://blog.csdn.net/qq_45677678/article/details/147736896](https://blog.csdn.net/qq_45677678/article/details/147736896)


# 2 安装zsh之后出现的问题

## 2.1 有如下问题

1. sogou拼音输入法无法输出中文；
2. 启动shell之后，出现如下报错：

        /opt/ros/humble/setup.bash:.:11: no such file or directory: /home/chris/setup.sh

3. 启动shell之后，出现如下报错：

        zsh-syntax-highlighting: unhandled ZLE widget 'menu-search'
        zsh-syntax-highlighting: (This is sometimes caused by doing `bindkey <keys> menu-search` without creating the 'menu-search' widget with `zle -N` or `zle -C`.)
        zsh-syntax-highlighting: unhandled ZLE widget 'recent-paths'
        zsh-syntax-highlighting: (This is sometimes caused by doing `bindkey <keys> recent-paths` without creating the 'recent-paths' widget with `zle -N` or `zle -C`.)

## 2.2 解决方法

针对如下问题，有如下的解决方案

1. 针对`sogou拼音输入法无法输出中文`的解决方法：

- 问题原因：Zsh 可能未加载 .pam_environment 或 /etc/environment 中的环境变量。
- 解决方案： 分别编辑如下文件，并添加如下的

  - 编辑 /etc/environment（全局生效）
  - 编辑 ~/.pam_environment（用户级生效）：

        GTK_IM_MODULE=fcitx
        QT_IM_MODULE=fcitx
        XMODIFIERS=@im=fcitx

2. 针对`启动shell之后，出现如下报错，报错/opt/ros/humble/setup.bash:.:11`的解决方法：

    在.zshrc中，将`/opt/ros/humble/setup.bash`改为`/opt/ros/humble/setup.sh`，因为，这里已经变成了zsh的shell解释器

3. 针对`启动shell之后，出现如下报错 zle -N or zle -C：`的解决方法

    在`zsh-syntax-highlighting.zsh`之前，定义`recent-paths`函数并使用`bindkey`来绑定`memu-search`
        #-----------------------------------------------------------------------

        # First, define a function (if you're using a custom implementation)
        recent-paths() {
            # Your implementation here, e.g., insert a recent path
            zle insert-last-word
        }
        zle -N recent-paths  # Register the widget
        bindkey '^Xr' recent-paths  # Now bind it

        #----------------------------------------------------------------------
        # Define menu-search as an alias for Zsh's built-in history-incremental-search-forward
        zle -N menu-search history-incremental-search-forward
        bindkey '^X^S' menu-search  # Now bind it

        source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



# 3 安装Ubuntu系统后如何快速安装必备软件

编写一个初级的shell脚本，可快速部署必要的软件


    #/bin/sh

    sudo apt install -y g++
    sudo apt install -y gcc
    sudo apt install -y cmake
    sudo apt install -y git
    sudo apt install -y code 
    sudo apt install -y curl

# 4 安装zsh后shell历史命令不能连续展现

在终端中运行 cat -v，然后按方向键，确认输出的序列是否为 `^[[A`（向上）和 `^[[B`（向下）。

git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/plugins/zsh-history-substring-search