#!/bin/bash
# ====================================================
#   Copyright (C)2015 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : install-zsh.sh
#   Last Modified : 2018-04-05 19:26
#   Describe      :
#
# ====================================================

if which zsh>/dev/null 2>&1 ;then
	echo " begin zshrc ...."
else
	echo -e '============================= \n
            需要先安装 zsh !!\n
			git clone git://git.code.sf.net/p/zsh/code zsh\n
			或者：\n
			git clone https://github.com/zsh-users/zsh\n
			编译安装。\n'
    exit
fi
if ls ~/.oh-my-zsh*>/dev/null 2>&1;then
    echo "oh-my-zsh already install...."
else
    echo -e '============================== \n
            需要安装 oh-my-zsh：\n
			sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"  \n'
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

if [ ! -e $HOME/.zshrc ] && [ ! -L $HOME/.zshrc ];then
    mv $HOME/.zshrc $HOME/.zshrc.oh-my-zsh.old
fi
echo " Step 1: backing up current config-----------Shell-Zsh"
shellbak="$bakdot/ori-zsh.$today"
if [ ! -e $shellbak ];then mkdir $shellbak; fi
for i in $HOME/.zshrc $HOME/.zshrc.oh-my-zsh; do [ -e $i ] && [ ! -L $i ] && mv $i $shellbak/; done
for i in $HOME/.zshrc $HOME/.zshrc.oh-my-zsh; do [ -L $i ] && unlink $i ; done

echo " Step 2: setting tu symlinks----------Shell-Zsh"
B_DOT="$HOME/.b-dot"
mkdir -p $B_DOT
lnif $CURRENT_DIR/zsh/zshrc.local $HOME/.zshrc
lnif $HOME/.oh-my-zsh/templates/zshrc.zsh-template $B_DOT/zshrc.oh-my-zsh
# sed 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="avit"/g' $HOME/.oh-my-zsh/templates/zshrc.zsh-template  > $HOME/.zshrc.oh-my-zsh
# lnif $CURRENT_DIR/zsh/incr.zsh $B_DOT/incr.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions $B_DOT/zsh-autosuggestions


mkdir -p $HOME/.local/bin
for i in $HOME/.local/bin/clean-docker ; do [ -L $i ] && unlink $i ; done
lnif $CURRENT_DIR/bash/clean-docker.sh $HOME/.local/bin/clean-docker
export PATH=$PATH:$HOME/.local/bin

echo " Step 3: source files -----------Shell-Zsh"
source $HOME/.zshrc



