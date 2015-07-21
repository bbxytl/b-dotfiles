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
if [ ! -e $bakdot ];then mkdir $bakdot; fi

echo " Step 1: backing up current config-----------Shell"
shellbak="$bakdot/ori-shell.$today"
if [ ! -e $shellbak ];then mkdir $shellbak; fi
for i in $HOME/.bashrc $HOME/.bash_profile $HOME/.dir_colors $HOME/.inputrc; do [ -e $i ] && [ ! -L $i ] && mv $i $shellbak/; done
for i in $HOME/.bashrc $HOME/.bash_profile $HOME/.dir_colors $HOME/.inputrc; do [ -L $i ] && unlink $i ; done
echo " Step 2: setting tu symlinks----------Shell"
lnif $CURRENT_DIR/bashrc $HOME/.bashrc
lnif $CURRENT_DIR/bash_profile $HOME/.bash_profile
lnif $CURRENT_DIR/DIR_COLORS $HOME/.dir_colors
lnif $CURRENT_DIR/inputrc $HOME/.inputrc
echo " Step 3: source files -----------Shell"
source $HOME/.bashrc
source $HOME/.bash_profile
#source $HOME/.dir_colors
echo " Step 4: end of install ------------ Shell"
