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

if [ $# -ge 2 ];then
	PASSWD=$1
	PACKGES=$2
else
	echo "请输入密码："
	read PASSWD
	PACKGES=$HOME/mydotfiles/packges
fi

if [ ! -e $PACKGES ];then mkdir $PACKGES;fi

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
bakdot="$HOME/mydotfiles/orgConfigBak"
tmp="$HOME/mydotfiles/tmp"
if [ ! -e $bakdot ];then mkdir $bakdot; fi
if [ ! -e $tmp ];then mkdir $tmp; fi

echo "Step 3-1: bucking up current config --------------- Tmux"
tmuxbak="$bakdot/ori-tmux.$today"
if [ ! -e $tmuxbak ];then mkdir $tmuxbak; fi
for i in $HOME/.tmux.conf $HOME/.tmux.conf.local; do [ -e $i ] && [ ! -L $i ] && mv $i $tmuxbak/; done
for i in $HOME/.tmux.conf $HOME/.tmux.conf.local; do [ -L $i ] && unlink $i ; done
echo "Step 3-2: install tmux"
system_shell=$SHELLL
export SHELL="/bin/sh"

installfg=true
if locate *libevent*2*>/dev/null 2>&1 ;then installfg=false;fi
if $installfg;then
    if [ ! -e $tmp/libevent.$today ];then mkdir $tmp/libevent.$today; fi
    cd $tmp/libevent.$today
    wget http://sourceforge.net/projects/levent/files/libevent/libevent-2.0/libevent-2.0.22-stable.tar.gz
    tar -xzvf libevent-2.0.22-stable.tar.gz
    cd libevent-2.0.22-stable
    ./configure
    make && make verify && echo $PASSWD | sudo -S make install
    echo $PASSWD | sudo -S ln -sf /usr/local/lib/libevent-2.0.so.5 /usr/lib/libevent-2.0.so.5
    if [ -e /usr/lib64 ];then
        echo $PASSWD | sudo -S ln -sf /usr/local/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5
    fi
fi

cd $CURRENT_DIR
install=true
if locate *tmux*>/dev/null 2>&1 ;then install=false;fi
if $install;then
    git clone https://github.com/tmux/tmux.git $tmp/tmux.$today
    cd $tmp/tmux.$today
    sh autogen.sh
    ./configure && make && echo $PASSWD | sudo -S make install
fi

cd $CURRENT_DIR
export SHELL=$system_shell
echo "Step 3-2: setting tu symlinks----------Tmux"
lnif $CURRENT_DIR/tmux.conf $HOME/.tmux.conf
lnif $CURRENT_DIR/tmux.conf.local $HOME/.tmux.conf.local
cd $CURRENT_DIR

