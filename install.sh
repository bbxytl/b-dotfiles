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

sudo yum install python-devel.x86_64
sudo yum groupinstall 'Development Tools'
sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo yum install the_silver_searcher


echo " 安装环境，过程中可能需要输入密码。。。。。"
echo " wget install......"
sudo yum install wget
echo " pip install......."
rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo yum install epel-release
sudo yum install python-pip
echo " tmux env install........"
sudo yum install ncurses-devel
sudo yum install autoconf m4 perl automake
sudo autoconf -ivf

sudo pip install pyflakes
sudo pip install pylint
sudo pip install pep8
pep8str="[pep8]\nmax-line-length = 120"
if [ ! -e $HOME/config ]; then mkdir $HOME/config; fi
if [ ! -e $HOME/.config/pep8 ];then
	echo -e pep8str > $HOME/.config/pep8
fi

# 一：安装 CMake 命令
if [ ! -e $HOME/tmp ];then mkdir $HOME/tmp ; fi
cd $HOME/tmp
wget http://www.cmake.org/files/v3.2/cmake-3.2.3.tar.gz
tar -zxvf cmake-3.2.3.tar.gz
cd cmake-3.2.3
./bootstrap
make && sudo make install
cd $CURRENT_DIR

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
