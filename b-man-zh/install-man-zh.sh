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

echo "========================================"
echo "在 .bashrc 中增加："
echo "  alias cman='man -M $HOME/.local/zhman/share/man/zh_CN'"
echo "  source .bashrc"   # 刷新
# cman cd          # 查看是否成功，如果要使用英文版，可继续使用 man 命令
cd $CURRENT_DIR

echo "========================================"
echo -e "如果需要 高亮 man ，需要安装 most，源码安装比较麻烦，\n
建议直接安装：http://www.cyberciti.biz/faq/unix-linux-color-man-pages-configuration/ \n
配置已经写入到 .bash_env.sh里了!\n
下载shell：\n
    下载安装 most 依赖的 slang \n
    wget http://www.jedsoft.org/releases/slang/slang-2.3.0.tar.bz2 \n
    下载安装 most \n
    wget http://www.jedsoft.org/releases/most/most-5.0.0a.tar.bz2"
echo ""
echo "========================================"
echo "如果系统为 Mac ，则需要安装 groff 来正确的显示中文："
echo "brew install groff"
echo "或:"
echo "wget http://www.fengyachao.com/wp-content/uploads/2013/01/groff-1.21.tar.gz"
echo "  然后编译安装："
echo "   ./configure --prefix=$HOME/.local/ --without-x"
echo "   make && make install"
echo "将此语句加入到 /etc/man.conf 最后，可能需要 sudo"
echo "     NROFF preconv -e UTF8 | /usr/local/bin/nroff -Tutf8 -mandoc -c"
echo "========================================"
