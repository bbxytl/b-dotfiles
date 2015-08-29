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

# 可能需要的命令：autoconf 、automake 、m4
# curl -O http://mirrors.kernel.org/gnu/automake/automake-1.11.tar.gz
# curl -O http://mirrors.kernel.org/gnu/autoconf/autoconf-2.65.tar.gz
# curl -O http://mirrors.kernel.org/gnu/m4/m4-1.4.13.tar.gz


PACKGES=$HOME/mydotfiles/packges
if [ ! -e $PACKGES ];then mkdir $PACKGES;fi

today=`date +%Y%m%d`
tmp="$HOME/mydotfiles/tmp"
if [ ! -e $tmp ];then mkdir $tmp; fi

# 安装 man-zh
git clone https://github.com/lidaobing/manpages-zh.git $tmp/manpages-zh.$today
cd $tmp/manpages-zh.$today
sh autogen.sh
./configure --prefix=$HOME/.local/ --disable-zhtw
make && make install

# 不使用 b-shell 的话要使用下面命令（在命令行中）
# cd ~
# vi .bashrc
# 在 .bashrc 中增加：
#	alias cman='man -M $HOME/.local/zhman/share/man/zh_CN'
# source .bashrc   # 刷新
# cman cd          # 查看是否成功，如果要使用英文版，可继续使用 man 命令
cd $CURRENT_DIR

echo -e "如果需要 高亮 man ，需要安装 most，源码安装比较麻烦，\n
建议直接安装：http://www.cyberciti.biz/faq/unix-linux-color-man-pages-configuration/ \n
配置已经写入到 .bash_env.sh里了!\n
下载shell：\n
    下载安装 most 依赖的 slang \n
    wget http://www.jedsoft.org/releases/slang/slang-2.3.0.tar.bz2 \n
    下载安装 most \n
    wget http://www.jedsoft.org/releases/most/most-5.0.0a.tar.bz2"

