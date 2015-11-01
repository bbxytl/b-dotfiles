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

# 依赖包：
# ncurses-devel
#autoconf m4 perl automake
# 依赖命令：autoconf -ivf

PACKGES=$HOME/mydotfiles/packges
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
if which tmux >/dev/null 2>&1 ;then installfg=false;fi
if $installfg;then
    if [ ! -e $tmp/libevent.$today ];then mkdir $tmp/libevent.$today; fi
    cd $tmp/libevent.$today
    wget http://sourceforge.net/projects/levent/files/libevent/libevent-2.0/libevent-2.0.22-stable.tar.gz
    tar -xzvf libevent-2.0.22-stable.tar.gz
    cd libevent-2.0.22-stable
    ./configure --prefix=$HOME/.local
    make && make verify &&  make install
    #echo $PASSWD | sudo -S ln -sf /usr/local/lib/libevent-2.0.so.5 /usr/lib/libevent-2.0.so.5
    #if [ -e /usr/lib64 ];then
    #    echo $PASSWD | sudo -S ln -sf /usr/local/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5
    #fi
	cd $CURRENT_DIR
    git clone https://github.com/tmux/tmux.git $tmp/tmux.$today
    cd $tmp/tmux.$today
    sh autogen.sh
    ./configure --prefix=$HOME/.local
	make && make install
fi

cd $CURRENT_DIR
export SHELL=$system_shell
echo "Step 3-2: setting tu symlinks----------Tmux"
lnif $CURRENT_DIR/tmux.conf $HOME/.tmux.conf
lnif $CURRENT_DIR/tmux.conf.local $HOME/.tmux.conf.local

echo "Step 3-3: setting powerline fonts for tmux"
cd $tmp
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
if [ ! -e $HOME/.fonts ];then mkdir $HOME/.fonts; fi
cp PowerlineSymbols.otf $HOME/.fonts/
if [ ! -e $HOME/.config ];then mkdir $HOME/.config; fi
if [ ! -e $HOME/.config/fontconfig ];then mkdir -p $HOME/.config/fontconfig/conf.d; fi
cp 10-powerline-symbols.conf $HOME/.config/fontconfig/conf.d/

cd $CURRENT_DIR

