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
if [ ! -e $bakdot ];then mkdir $bakdot; fi

echo " Step 1: backing up current config-----------Others"
othersbak="$bakdot/ori-others.$today"
if [ ! -e $othersbak ];then mkdir $othersbak; fi
for i in $HOME/.gitignore; do [ -e $i ] && [ ! -L $i ] && mv $i $othresbak/$i; done
for i in $HOME/.gitignore; do [ -L $i ] && unlink $i ; done
echo " Step 2: setting tu symlinks----------Others"
lnif $CURRENT_DIR/gitignore $HOME/.gitignore
echo " Step 3: end of install ------------ Others"
