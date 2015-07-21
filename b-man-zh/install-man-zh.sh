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

today=`date +%Y%m%d`
tmp="$HOME/mydotfiles/tmp"
if [ ! -e $tmp ];then mkdir $tmp; fi

# 安装 man-zh
git clone https://github.com/lidaobing/manpages-zh.git $tmp/manpages-zh.$today
cd $tmp/manpages-zh.$today
./configure --prefix=/usr/local/zhman --disable-zhtw 
make 
echo $PASSWD | sudo -S make install

# 不使用 b-shell 的话要使用下面命令（在命令行中）
# cd ~
# vi .bashrc
# 在 .bashrc 中增加：
#	alias cman='man -M /usr/local/zhman/share/man/zh_CN'
# source .bashrc   # 刷新
# cman cd          # 查看是否成功，如果要使用英文版，可继续使用 man 命令 
cd $CURRENT_DIR


