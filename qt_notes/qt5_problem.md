# 1 ubuntu 22.04下安装qt 5.15.3后没有qt5-example的问题
## 1.1 方法
虽然 Ubuntu 22.04 以 Qt 6 为主，但官方源中确实存在 Qt 5.15.3 的示例包。尝试以下命令：

        # 强制更新软件源索引
        sudo apt update --fix-missing

        # 安装 Qt 5 示例（可能需要指定完整包名）
        sudo apt install qtbase5-examples qtdeclarative5-examples

以上方法，可以更新exmaples的内容

若是通过官网安装的话，可能不能满足对特定QT版本的需求

## 1.2 验证

- 有两个qt版，分别是：
    - Qt 5.15.3： /usr/lib/qt/bin/qtmake
    - Qt 5.15.12： /usr/local/Qt-5.15.12/bin/qtmake

- 那么qt的example的路径在哪里呢？

    - ls /usr/share/qt5/examples/

## 1.3 安装目录查找

sudo apt install qtbase5-examples qtdeclarative5-examples如何查找这两个example的安装目录？

使用 dpkg 查看包的具体内容

- dpkg -L qtbase5-examples
- dpkg -L qtdeclarative5-examples

通过dpkg查找包的具体内容后发现，是在：`/usr/lib/x86_64-linux-gnu/qt5/exmaples`里面

## 1.4 如何将下载的qtbase5-example和qtcreator中的example进行关联呢？

在 Qt Creator 中配置示例路径
- 打开 Qt Creator，进入 工具 > 选项（或按 Ctrl+Alt+S）。
- 在左侧菜单中选择 帮助 > 示例。
- 在右侧的 示例路径 区域：
- 点击 添加 按钮。
- 输入示例代码的路径（如 /usr/share/qt5/examples）。
- 点击 确定 保存。

由于无法找到添加按钮，该方案，将通过apt安装的example复制到`/usr/share/qt5/examples`目录下，方法如下：

- sudo cp -r /原路径/Examples ~/QtProjects/  # 复制到目标目录
- sudo mv /原路径/Examples ~/QtProjects/  # 移动（需管理员权限）

另一种可用的方案：将example放到home目录下，有qt直接打开工程

sudo cp -r ./exmaples /home/chris
sudo chown -R chris:chris ./examples/ 将所有的子文件夹的拥有者都改成chris

# 1.5 QtCreator中无法输入中文

## 1.5.1 初步设置

    sudo apt install mlocate # 安装locate工具

    sudo updatedb # 更新文件索引（首次安装后需要执行）

    locate qtcreator.desktop | grep -i share/applications # 
    /home/chris/.local/share/applications/org.qt-project.qtcreator.desktop
    /home/chris/qtcreator-11.0.3/share/applications/org.qt-project.qtcreator.desktop


    sudo vim /usr/share/applications/qtcreator.desktop

    - Exec=qtcreator %F
    + Exec=env QT_IM_MODULE=fcitx qtcreator %F # 至此，qtcreator中就可以输入中文

## 1.5.2 关键步骤设置插件

- 查找插件文件
    - locate libfcitxplatforminputcontextplugin.so

- 经典路径
    - /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so

- 复制插件到Qt Creator插件目录：
    - sudo cp /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so /opt/Qt/Tools/QtCreator/lib/Qt/plugins/platforminputcontexts/

- T490 ubuntu 22.04 方案

sudo cp /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so  /home/chris/qtcreator-11.0.3/lib/Qt/plugins/platforminputcontexts

sudo cp /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so  /home/chris/qtcreator-11.0.3/lib/qtcreator/plugins

sudo cp /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so
 /usr/local/Qt-5.15.12/plugins/platforminputcontexts

插件路径可通过 qmake -query QT_INSTALL_PLUGINS 查询。

依然无法解决

## 1.5.3 继续排查

若问题依旧，建议提供 fcitx-diagnose 和 qtcreator --version 的输出以进一步诊断。

- fcitx-diagnose

出现如下错误


        3.  Qt IM module files:

            Found fcitx qt module: `/lib/x86_64-linux-gnu/fcitx/qt/libfcitx-quickphrase-editor5.so`.
            Found fcitx im module for Qt5: `/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so`.
            **Cannot find fcitx input method module for Qt4.**

在.bashrc or .zshrc中添加如下内容：`export QT_IM_MODULE=fcitx`


## 1.5.4 qt5ct设置qt5的配置

- bash: qt5ct
- fonts: 
    - 原来： Sans Serif 9
    - 修改为：Lucida Console 14