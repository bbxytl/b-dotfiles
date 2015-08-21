
# Version 3.0
添加配置文件，大幅度修改！

# Version 2.1
添加一些别名等小修改.

# Version 2.0
完全废除原先的文件结构，划为一个个对应的小块，尽量减少安装附加软件！
所以如果是需要附加软件依赖的会在安装中提示，需要手动去安装依赖，
特别是在 tmux 和 python 中有关的依赖比较多，如果不知道安装什么依赖
可以查看对应的 install*.sh 文件查看！

# Simple-Version-1.0
----
重新自己配置了环境，这个是简易版的，没有使用需要编译，以及很麻烦的软件。
所有安装软件都是在 `$HOME/.local` 下，具体安装方式分离，到对应目录下运行对应的
`install-*.sh` 文件即可安装，具体内容可以查看 `install-*.sh` 内容！


# Version 1.1
------
添加了 中文 man 手册支持；
使用方法：
```shell
cman cd
```
github源：[https://github.com/lidaobing/manpages-zh][1]

### 目录结构
----
- ~/mydotfiles
	- config
	- install.sh
	- b-man-zh
		- install-man-zh
    - b-shell
        - install-shell.sh
        - bashrc
        - bash\_profile
    - b-vim
        - install-vim.sh
        - vimrc
        - vimrc.bundles
    - b-tmux
        - install-tmux.sh
        - tmux.conf
        - tmux.conf.local
    - b-powerline
        - install-powerline.sh

[1]: https://github.com/lidaobing/manpages-zh

# Version 1.0
--------
支持配置：
 shell
 vim
 tmux
 powerline
其中 vim 主要参照 [k-vim][2], 由于个人喜好，对其进行了更改；
### 目录结构
----
- ~/mydotfiles
	- config
	- install.sh
    - b-shell
        - install-shell.sh
        - bashrc
        - bash\_profile
    - b-vim
        - install-vim.sh
        - vimrc
        - vimrc.bundles
    - b-tmux
        - install-tmux.sh
        - tmux.conf
        - tmux.conf.local
    - b-powerline
        - install-powerline.sh

[2]: https://github.com/wklken/k-vim
