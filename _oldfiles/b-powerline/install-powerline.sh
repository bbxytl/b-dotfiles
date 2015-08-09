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
packge="$HOME/mydotfiles/packges"
if [ ! -e $bakdot ];then mkdir $bakdot; fi
if [ ! -e $packge ];then mkdir $packge; fi
echo " Step 1: backing up current config-----------powerline"
powerlinebak="$bakdot/ori-powerline.$today"
if [ ! -e $powerlinebak ];then mkdir $powerlinebak; fi
for i in $HOME/.fonts/PowerlineSymbols.otf $HOME/.config/fontconfig; do [ -e $i ] && [ ! -L $i ] && mv $i $powerlinebak/; done
for i in $HOME/.fonts/PowerlineSymbols.otf $HOME/.config/fontconfig; do [ -L $i ] && unlink $i ; done
echo " Step 2: install ----------powerline"

# 安装 powerline
installfg=true
if which powerline >/dev/null 2>&1;then installfg=false;fi
if [ ! -e $packge/powerline ];then mkdir $packge/powerline; fi
cd $packge/powerline
if $installfg;then
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

