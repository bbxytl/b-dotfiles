# Version 4.0

2015.10.24

```
* b35da1e - (HEAD -> master, origin/master, origin/HEAD) 更正更新文件名和最后修改日期的bug，使用<F4>或 uh 来更新当前文件的最后更新日期和文件$
* 0c78ee3 - 修改ctags，增加include文件之间的跳转，同时支持mac下stl的源码查找 (32 hours ago) <bbxytl>
* b944563 - 去除搜索设置 (12 days ago) <bbxytl>
* 6db0f12 - lg记录以及rm的bug修复 (12 days ago) <bbxytl>
* 355137f - 去除保存文件时自动去空格操作，使用<leader>,来完成操作 (2 weeks ago) <bbxytl>
*   652c7f3 - Merge branch 'master' of github.com:bbxytl/b-dotfiles (2 weeks ago) <bbxytl>
|\
| * 2b5e9ba - 添加别名llt (2 weeks ago) <bbxytl>
* |   255e68d - Merge branch 'master' of github.com:bbxytl/b-dotfiles (2 weeks ago) <bbxytl>
|\ \
| |/
| * 03e6a18 - 添加gitignore (3 weeks ago) <bbxytl>
* | bc29d58 - 测试 (2 weeks ago) <bbxytl>
|/
* 685e1cc - 修改tab (3 weeks ago) <bbxytl>
* 577ab21 - 添加linux不同情况下的python虚拟环境支持 (4 weeks ago) <bbxytl>
* 8545c6a - 添加Python虚拟环境 virtualenv 和管理工具 virtualenvwrapper (4 weeks ago) <bbxytl>
* 32716a7 - 小修改 (5 weeks ago) <bbxytl>
* 351c654 - tab设置为原来的，非空格，4位 (5 weeks ago) <bbxytl>
* 1f79880 - vim 和 ack 配置 (5 weeks ago) <bbxytl>
* 0e4093a - Q2 (5 weeks ago) <bbxytl>
*   5d7b623 - Merge branch 'master' of github.com:bbxytl/b-dotfiles (5 weeks ago) <bbxytl>
|\
| * f117d69 - 小修改 (5 weeks ago) <bbxytl>
| * 5bf2597 - vi 重定向为 vim，并将原 vi 重命名为 v (5 weeks ago) <bbxytl>
* | f9e6844 - Q2 (5 weeks ago) <bbxytl>
|/
* ae24d1e - mac shell 修改 (7 weeks ago) <bbxytl>
* 7c5257f - mac 适应性修改 (7 weeks ago) <bbxytl>
*   e76d925 - alias Merge (7 weeks ago) <bbxytl>
|\
| * 861ae0d - 修改 configurebug (7 weeks ago) <bbxytl>
* | 74fd1fc - vim 配置 (7 weeks ago) <bbxytl>
|/
* 4b11047 - 区别mac 和 linux 下命令的区别：sed (8 weeks ago) <bbxytl>
* b7869a9 - mac (8 weeks ago) <bbxytl>
```

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
