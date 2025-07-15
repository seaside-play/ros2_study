# 1 Solve problem for displaying the mess code for tmux

解决在远程电脑上可以正确显示和输入中文，但是通过ssh访问后，vim中无法正常实现中文和输入中文的问题。

	# 客户端：传递LANG和LC_ALL变量
	ssh -o SendEnv=LANG -o SendEnv=LC_ALL chris@10.20.131.10

	# 服务器端：确保/etc/ssh/sshd_config包含以下内容
	AcceptEnv LANG LC_*



