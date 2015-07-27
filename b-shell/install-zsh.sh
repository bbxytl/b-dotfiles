#!/bin/bash
# ====================================================
#   Copyright (C)2015 All rights reserved.
#
#   Author  : bbxytl
#   Email   : bbxytl@gmail.com
#   FileName: install.sh
#   LastModify : 2015-07-20 10:02
#   Describe:	配置 shell--Zsh 环境
#
#   Log     :
#
# ====================================================
if which zsh>/dev/null 2>&1 ;then 
	echo " begin zshrc ...."
else
	echo -e ' 需要先安装 zsh !!\n 
			git clone git://git.code.sf.net/p/zsh/code zsh\n
			或者：\n
			git clone https://github.com/zsh-users/zsh\n
			编译安装。\n
			然后安装 oh-my-zsh：\n
			sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"'
	exit
fi

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


mv $HOME/.zshrc $HOME/.zshrc.oh-my-zsh
echo " Step 1: backing up current config-----------Shell-Zsh"
shellbak="$bakdot/ori-zsh.$today"
if [ ! -e $shellbak ];then mkdir $shellbak; fi
for i in $HOME/.zshrc $HOME/.sh_self_config; do [ -e $i ] && [ ! -L $i ] && mv $i $shellbak/; done
for i in $HOME/.zshrc $HOME/.sh_self_config; do [ -L $i ] && unlink $i ; done

echo " Step 2: setting tu symlinks----------Shell-Zsh"
lnif $CURRENT_DIR/zsh/zshrc.local $HOME/.zshrc
lnif $CURRENT_DIR/sh_self_config $HOME/.sh_self_config

echo " Step 3: source files -----------Shell-Zsh"
source $HOME/.zshrc

