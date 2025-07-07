# bindkey

bindkey是 Zsh（Z Shell）中用于管理键盘按键绑定的核心命令，它决定了用户按下某个键时，Zsh 的行编辑器（ZLE, Zsh Line Editor）会执行什么操作

- `bindkey`: 展现绑定的key和行为
- `cat -v`: 可以进行输入的键盘，输出对应的内部码
- `bindkey | grep up-line-or-history`: 展现绑定的历史上下文是什么按键