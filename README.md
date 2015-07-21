# b-dotFiles
----
## 主要配置有：
- shell
- vim
- tmux
- powerline

## 安装方式
- 一键安装
```shell
sh one2install
```
- 手动的安装全部
```
sudo chmod +x install-sh
sudo chmod +x config-sh
sh config-sh | tee -a log/config.log
sh install-sh | tee -a log/install.log
```

- 分别安装，进入到各安装文件夹下，分别进行运行 `install-*.sh` 文件

## 说明
- 本配置参照 [k-vim][1]，不过去除了其 airline ，改而使用 powerline ，因为 airline 在 tmux 下会导致 vim 显示问题。
- 在安装 YouCompleteMe 时，如果失败，请查看 **[文档][2]** ;
- 在安装 indexer 时，如果失败，使用:
```shell
" Bundle 'vim-scripts/indexer.tar.gz'
" 如果出问题了则使用：
cd ~/.vim/bundle/
git clone git@github.com:vim-scripts/indexer.tar.gz
```
- 每一个文件夹内的都可单独配置，单要先使用 `./config` 进行配置;

## 配置学习
- 本配置的部分可直接查看 vimrc 和 vimrc.bundles 进行查看
- 其他学习推荐：[use_vim_as_ide][3]

[1]: https://github.com/wklken/k-vim
[2]: https://github.com/Valloric/YouCompleteMe
[3]: https://github.com/bbxytl/use_vim_as_ide
