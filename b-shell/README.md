# 安装 shell
---
```shell
sh install-shell.sh
或 ./install-shell.sh
```

# 安装或更新 Zsh
---
需要先安装 zsh !!
git clone git://git.code.sf.net/p/zsh/code zsh
或者：
git clone https://github.com/zsh-users/zsh\n
编译安装。

当每次更新完 oh-my-zsh 时，运行以下命令：
```
ln $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc.oh-my-zsh
```

# 安装后运行命令
---
不论是 shell 还是 zsh 配置完后都要运行下面的命令：
```shell
source ~/.bashrc
```
