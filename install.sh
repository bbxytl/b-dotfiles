#!/bin/bash
# ====================================================
#   Copyright (C)2015 All rights reserved.
#
#   Author  : bbxytl
#   Email   : bbxytl@gmail.com
#   FileName: run.sh
#   LastModify : 2015-07-20 14:45
#   Describe:
#
#   Log     :
#
# ====================================================

# 安装环境

BASEDIR=$(dirname $0)
cd $BASEDIR
CURRENT_DIR=`pwd`

echo " 安装环境，过程中需要输入密码。。。。。请输入："
read PASSWD


today=`date +%Y%m%d`
cd $HOME
if [ ! -e $HOME/mydotfiles ];then mkdir $HOME/mydotfiles;else mkdir $HOME/mydotfiles.$today;fi
mv $CURRENT_DIR $HOME/mydotfiles/b-dotfiles
PACKGES=$HOME/mydotfiles/packges
if [ ! -e $PACKGES ];then mkdir $PACKGES;else mkdir $PACKGES.$today;fi
CURRENT_DIR="$HOME/mydotfiles/b-dotfiles"
cd $CURRENT_DIR

# 配置 shell
echo $PASSWD | sudo -S chmod +x $CURRENT_DIR/b-shell/install-shell.sh
cd $CURRENT_DIR/b-shell
./install-shell.sh $PASSWD  $PACKGES

# 配置 tmux
echo $PASSWD | sudo -S chmod +x $CURRENT_DIR/b-tmux/install-tmux.sh
cd $CURRENT_DIR/b-tmux
./install-tmux.sh $PASSWD  $PACKGES

# 配置 powerline
echo $PASSWD | sudo -S chmod +x $CURRENT_DIR/b-powerline/install-powerline.sh
cd $CURRENT_DIR/b-powerline
./install-powerline.sh $PASSWD  $PACKGES

# 配置 中文 man
cd $CURRENT_DIR/b-man-zh
echo $PASSWD | sudo -S chmod +x $CURRENT_DIR/b-man-zh/install-man-zh.sh
./install-man-zh.sh $PASSWD  $PACKGES


# others
cd $CURRENT_DIR/others
echo $PASSWD | sudo -S chmod +x $CURRENT_DIR/others/install-others.sh
./install-others.sh $PASSWD  $PACKGES

# 配置 vim
cd $CURRENT_DIR/b-vim
echo $PASSWD | sudo -S chmod +x $CURRENT_DIR/b-vim/install-vim.sh
./install-vim.sh $PASSWD  $PACKGES

