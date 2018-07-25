#!/bin/bash
# ====================================================
#   Copyright (C)2015 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : install-shell-for-docker.sh
#   Last Modified : 2018-04-05 19:28
#   Describe      :	配置 shell--Bash 环境
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

B_DOT="$HOME/.b-dot"
mkdir -p $B_DOT
lnif $CURRENT_DIR/bash/bashrc $HOME/.bashrc
lnif $CURRENT_DIR/bash/bash_profile $HOME/.bash_profile
lnif $CURRENT_DIR/bash/DIR_COLORS $HOME/.dir_colors
lnif $CURRENT_DIR/bash/pystartup.py $HOME/.pystartup.py

lnif $CURRENT_DIR/bash/bash_env.sh $B_DOT/bash_env.sh
lnif $CURRENT_DIR/bash/bash_alias.sh $B_DOT/bash_alias.sh

lnif $CURRENT_DIR/zsh/zshrc.local $HOME/.zshrc
lnif $HOME/.oh-my-zsh/templates/zshrc.zsh-template $B_DOT/zshrc.oh-my-zsh
# sed 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="avit"/g' $HOME/.oh-my-zsh/templates/zshrc.zsh-template  > $HOME/.zshrc.oh-my-zsh



