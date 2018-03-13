#!/bin/bash
# ====================================================
#   Copyright (C)2015 All rights reserved.
#
#   Author  : bbxytl
#   Email   : bbxytl@gmail.com
#   FileName: install.sh
#   LastModify : 2015-07-20 10:02
#   Describe:	配置 shell--Bash 环境
#
#   Log     :
#
# ====================================================


BASEDIR=$(dirname $0)
cd $BASEDIR
CURRENT_DIR=`pwd`

lnif(){
    if [ -e "$1" ];then
        ln -sf "$1" "$2"
    fi
}

lnif $CURRENT_DIR/bash/bashrc $HOME/.bashrc
lnif $CURRENT_DIR/bash/bash_profile $HOME/.bash_profile
lnif $CURRENT_DIR/bash/DIR_COLORS $HOME/.dir_colors
lnif $CURRENT_DIR/bash/bash_env.sh $HOME/.bash_env.sh
lnif $CURRENT_DIR/bash/bash_alias.sh $HOME/.bash_alias.sh
lnif $CURRENT_DIR/bash/pystartup.py $HOME/.pystartup.py

lnif $CURRENT_DIR/zsh/zshrc.local $HOME/.zshrc
lnif $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc.oh-my-zsh
# sed 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="avit"/g' $HOME/.oh-my-zsh/templates/zshrc.zsh-template  > $HOME/.zshrc.oh-my-zsh

