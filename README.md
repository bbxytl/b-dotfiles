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
git clone https//github.com/bbxytl/b-dotfiles.git
cd b-dotfiles
./configure
```
- 分别安装，进入到各安装文件夹下，分别进行运行 `install-*.sh` 文件

## 说明
- 本vim配置参照 [k-vim][1]，不过去除了其 airline ，改而使用 vim-powerline (不是新版的，老版的不需要安装！)，因为 airline 在 tmux 下会导致 vim 显示问题。
- 简装版，没有使用任何需要安装的插件（vim），安装方式：`sh install-vim.sh`
- 全配版，特别区别是使用了 `YouCompleteMe` vim 插件！安装方式：`sh install-vim.sh  --complex`
- 如果使用 complex 版，需要编译安装 [YouCompleteMe][YouCompleteMe] 时，如果失败，请查看 **[文档][2]** ;
- 在安装 indexer 时，如果失败，使用:
```shell
" Bundle 'vim-scripts/indexer.tar.gz'
" 如果出问题了则使用：
cd ~/.vim/bundle/
git clone git@github.com:vim-scripts/indexer.tar.gz
```
- 每一个文件夹内的都可单独配置，tmux 安装可能需要先安装对应的 依赖包；
- [更新日志][log]在 [`log`][log] 目录下；

## 配置学习
- 本配置的部分可直接查看 vimrc 和 vimrc.bundles 进行查看
- 其他学习推荐：[use_vim_as_ide][3]

[1]: https://github.com/wklken/k-vim
[2]: https://github.com/Valloric/YouCompleteMe
[3]: https://github.com/bbxytl/use_vim_as_ide
[log]: log/version.md
[YouCompleteMe]: http://valloric.github.io/YouCompleteMe/
