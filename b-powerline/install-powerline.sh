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
if [ ! -e $tmp ];then mkdir $tmp; fi
if [ ! -e $bakdot ];then mkdir $bakdot; fi
echo " Step 1: backing up current config-----------powerline"
powerlinebak="$bakdot/ori-powerline.$today"
if [ ! -e $powerlinebak ];then mkdir $powerlinebak; fi
for i in $HOME/.fonts/PowerlineSymbols.otf $HOME/.config/fontconfig; do [ -e $i ] && [ ! -L $i ] && mv $i $powerlinebak/$i; done
for i in $HOME/.fonts/PowerlineSymbols.otf $HOME/.config/fontconfig; do [ -L $i ] && unlink $i ; done
echo " Step 2: install ----------powerline"

# 安装 powerline
install=true
if locate *powerline* >/dev/null 2>&1;then install=false;fi
if [ ! -e $tmp/powerline ];then mkdir $tmp/powerline; fi
cd $tmp/powerline
if install;then
    pip install --user git+https://github.com/powerline/powerline
fi
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
if [ ! -e $HOME/.fonts ];then mkdir $HOME/.fonts; fi
cp PowerlineSymbols.otf $HOME/.fonts/
if [ ! -e $HOME/.config ];then mkdir $HOME/.config; fi
if [ ! -e $HOME/.config/fontconfig ];then mkdir -p $HOME/.config/fontconfig/conf.d; fi
cp 10-powerline-symbols.conf $HOME/.config/fontconfig/conf.d/
cd $CURRENT_DIR


