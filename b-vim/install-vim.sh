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

if [ -e $PACKGES ];then mkdir $PACKGES;fi

# 一：配置 shell 环境
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
vimpacks="$PACKGES/vim"
if [ ! -e $bakdot ];then mkdir $bakdot; fi
if [ ! -e $tmp ];then mkdir $tmp; fi
if [ ! -e $vimpacks ];then mkdir $vimpacks; fi

echo " Step 1: bucking up current config --------------- Vim"
vimbak="$bakdot/ori-vim.$today"
if [ ! -e $vimbak ];then mkdir $vimbak; fi
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles; do [ -e $i ] && [ ! -L $i ] && mv $i $vimbak/$i; done
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles; do [ -L $i ] && unlink $i ; done
echo " Step 2: setting tu symlinks----------Vim"
lnif $CURRENT_DIR/vimrc $HOME/.vimrc
lnif $CURRENT_DIR/vimrc.bundles $HOME/.vimrc.bundles
lnif "$vimpacks" "$HOME/.vim"
echo " Step 3: install vundle"
if [ ! -e $vimpacks/bundle/vundle ]; then
    echo "Installing Vundle"
    git clone https://github.com/gmarik/vundle.git $vimpacks/bundle/vundle
else
    echo "Upgrde Vundle"
    cd "$HOME/.vim/bundle/vundle" && git pull origin master
fi
echo " Step 4: update/install plugins using Vundle -------- Vim"
system_shell=$SHELLL
export SHELL="/bin/sh"
vim -u $HOME/.vimrc.bundles +BundleInstall! +BundleClean +qall
export SHELL=$system_shell

echo "Step5: compile YouCompleteMe"
echo "It will take a long time, just be patient!"
echo "If error,you need to compile it yourself"
echo "cd $CURRENT_DIR/bundle/YouCompleteMe/ && bash -x install.sh --clang-completer"
cd $vimpacks/bundle/YouCompleteMe/
if [ `which clang` ]   # check system clang
then
    bash -x install.sh --clang-completer --system-libclang   # use system clang
else
    bash -x install.sh --clang-completer
fi


echo " Step 5: vim bk and undo dir"
if [ ! -d /tmp/vimbk ]; then
    echo $PASSWD | sudo -S  mkdir -p /tmp/vimbk
fi
if [ ! -d /tmp/vimundo ];then
    echo $PASSWD | sudo -S  mkdir -p /tmp/vimundo
fi
