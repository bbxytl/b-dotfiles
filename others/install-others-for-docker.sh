#!/bin/bash
# ====================================================
#   Copyright (C)2017 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : install-others-for-docker.sh
#   Last Modified : 2017-07-24 15:11
#   Describe      :
#
#   Log           :
#
# ====================================================


PACKGES=$HOME/mydotfiles/packges

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

lnif $CURRENT_DIR/gitconfig.sh $HOME/.gitconfig
lnif $CURRENT_DIR/gitignore $HOME/.gitignore


