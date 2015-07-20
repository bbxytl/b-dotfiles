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


# 配置 shell
sudo chmod +x $CURRENT_DIR/b-shell/install-shell.sh
cd $CURRENT_DIR/b-shell
./install-shell.sh

# 配置 tmux
sudo chmod +x $CURRENT_DIR/b-tmux/install-tmux.sh
cd $CURRENT_DIR/b-tmux
./install-tmux.sh

# 配置 powerline
sudo chmod +x $CURRENT_DIR/b-powerline/install-powerline.sh
cd $CURRENT_DIR/b-powerline
./install-powerline.sh

# 配置 vim
cd $CURRENT_DIR/b-vim
sudo chmod +x $CURRENT_DIR/b-vim/install-vim.sh
./install-vim.sh

cd $CURRENT_DIR
