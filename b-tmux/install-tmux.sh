#!/bin/bash
# ====================================================
#   Copyright (C)2015 All rights reserved.
#
#   Author  : bbxytl
#   Email   : bbxytl@gmail.com
#   FileName: install.sh
#   LastModify : 2015-07-20 10:02
#   Describe:
#
#   Log     :
#
# ====================================================


# 备份原始数据
BASEDIR=$(dirname $0)
cd $BASEDIR
CURRENT_DIR=`pwd`

lnif(){
    if [ -e "$1" ];then
        ln -sf "$1" "$2"
    fi
}

today=`date +%Y%m%d`
bakdot="$HOME/orgConfigBak"
if [ ! -e $bakdot ];then mkdir $bakdot; fi
if [ ! -e $HOME/tmp ];then mkdir $HOME/tmp; fi

echo "Step 3-1: bucking up current config --------------- Tmux"
tmuxbak="$bakdot/ori-tmux.$today"
if [ ! -e $tmuxbak ];then mkdir $tmuxbak; fi
for i in $HOME/.tmux.conf $HOME/.tmux.conf.local; do [ -e $i ] && [ ! -L $i ] && mv $i $tmuxbak/$i; done
for i in $HOME/.tmux.conf $HOME/.tmux.conf.local; do [ -L $i ] && unlink $i ; done
echo "Step 3-2: install tmux"
system_shell=$SHELLL
export SHELL="/bin/sh"
if [ ! -e $HOME/tmp/libevent.$today ];then mkdir $HOME/tmp/libevent.$today; fi
cd $HOME/tmp/libevent.$today
wget http://sourceforge.net/projects/levent/files/libevent/libevent-2.0/libevent-2.0.22-stable.tar.gz/download
tar -xzvf libevent-2.0.22-stable.tar.gz
cd libevent-2.0.22-stable
./configure
make && make verify && sudo make install
lnif /usr/local/lib/libevent-2.0.so.5 /usr/lib/libevent-2.0.so.5
if [ -e /usr/lib64 ];then
    lnif  /usr/local/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5
fi
cd $CURRENT_DIR
git clone https://github.com/tmux/tmux.git $HOME/tmp/tmux.$today
cd $HOME/tmp/tmux.$today
sh autogen.sh
./configure && make && sudo make install
cd $CURRENT_DIR
export SHELL=$system_shell
echo "Step 3-2: setting tu symlinks----------Vim"
lnif $CURRENT_DIR/tmux.conf $HOME/.tmux.conf
lnif $CURRENT_DIR/tmux.conf.local $HOME/.tmux.conf.local
cd $CURRENT_DIR

