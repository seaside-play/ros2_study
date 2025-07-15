git clone ssh://wuchaojiang@10.20.201.23:22/home/gituser/robot/newARCS

vim ~/.ssh/config

    Host 10.20.201.23
            HostKeyAlgorithms ssh-rsa,ssh-dss
            PubkeyAcceptedKeyTypes ssh-rsa,ssh-dss


Compile boost-1.50