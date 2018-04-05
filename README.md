# b-dotFiles
----
## 主要配置有：
- shell
- vim
- tmux
- 中文man

## 安装方式
- 首先clone到本地：
```
git clone https//github.com/bbxytl/b-dotfiles --recursive
cd b-dotfiles
./configure
cd ~/mydotfiles/b-dotfiles
```
- 分别安装，进入到各安装文件夹下，分别进行运行 `install-*.sh` 文件

## 说明
- vim 配置安装查看 [b-vim][b-vim];
- 每一个文件夹内的都可单独配置，tmux 安装可能需要先安装对应的 依赖包；
- [更新日志][log]在 [`log`][log] 目录下；

## 帮助文档
- [shell][shell]
- [vim][vim]

[b-vim]: https://github.com/nine2/b-vim
[log]: log/version.md
[shell]: ./b-shell/README.md
[vim]: ./b-vim/README.md
