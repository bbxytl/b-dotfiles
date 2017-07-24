#!/bin/bash
# ====================================================
#   Copyright (C)2015 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : install-vim.sh
#   Last Modified : 2015-10-30 14:54
#   Describe      :
#
#   Log           :
#
# ====================================================


# 默认安装 simple 版
COMPLEX=false
if [ $# -ge 1 ];then
	if [ $1="--complex" ];then
		COMPLEX=true
	else
		echo "Error arg! no arg to rum simple , arg: --complex to use ycm and so on !"
		exit
	fi
fi
Download=true
if [ $# -ge 2 ];then
	if [ $2="--no-download" ];then
		Download=false
	fi
fi
Download=false


PACKGES=$HOME/mydotfiles/packges
if [ ! -e $PACKGES ];then mkdir $PACKGES;fi


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
vimpacks="$PACKGES/vim"
if [ ! -e $bakdot ];then mkdir $bakdot; fi
if [ ! -e $vimpacks ];then mkdir $vimpacks; fi

# 保留 从 github 上搞来的配置
if [ -e $HOME/.vimrc ];then mv $HOME/.vimrc $HOME/.vimrc_other ;fi
echo " Step 1: bucking up current config --------------- Vim"
vimbak="$bakdot/ori-vim.$today"
if [ ! -e $vimbak ];then mkdir $vimbak; fi
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles $HOME/.vimrc.config_base $HOME/.vimrc.config_filetype ; do [ -e $i ] && [ ! -L $i ] && mv $i $vimbak/; done
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles $HOME/.vimrc.config_base $HOME/.vimrc.config_filetype ; do [ -L $i ] && unlink $i ; done
# for i in $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles $HOME/.vimrc.config_base $HOME/.vimrc.config_filetype $HOME/.indexer_files; do [ -e $i ] && [ ! -L $i ] && mv $i $vimbak/; done
# for i in $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles $HOME/.vimrc.config_base $HOME/.vimrc.config_filetype $HOME/.indexer_files; do [ -L $i ] && unlink $i ; done
for i in $HOME/.vim/tags_list ; do [ -e $i ] && cp $i $i.bak; done
for i in $HOME/.vim/tags_list ; do [ -L $i ] && unlink $i ; done

echo " Step 2: setting tu symlinks----------Vim"
if $COMPLEX;then
	bundlesfile=$CURRENT_DIR/vimrc.bundles_complex
else
	bundlesfile=$CURRENT_DIR/vimrc.bundles
fi

lnif $CURRENT_DIR/vimrc $HOME/.vimrc
lnif $bundlesfile $HOME/.vimrc.bundles
lnif $CURRENT_DIR/vimrc.config_base $HOME/.vimrc.config_base
lnif $CURRENT_DIR/vimrc.config_filetype $HOME/.vimrc.config_filetype
lnif "$vimpacks" "$HOME/.vim"

SYS_VERSION=`uname -s`
if [ $SYS_VERSION = 'Darwin' ];then
	lnif $CURRENT_DIR/tags_list_of_cpp/tags_list_mac $tags_list $HOME/.vim/tags_list
else if [ $SYS_VERSION = 'Linux' ];then
	lnif $CURRENT_DIR/tags_list_of_cpp/tags_list_linux $tags_list $HOME/.vim/tags_list
fi
fi

echo " Step 3: vim bk and undo dir and swp and view"
vimdir=$HOME/.vim
if [ ! -d $vimdir/vimbackup ]; then
    mkdir -p $vimdir/vimbackup
fi
if [ ! -d $vimdir/vimundo ];then
    mkdir -p $vimdir/vimundo
fi
if [ ! -d $vimdir/vimswap ];then
    mkdir -p $vimdir/vimswap
fi

if $Download ;then
echo " Step 4: install vundle"
if [ ! -e $vimdir/bundle/vundle ]; then
    echo "Installing Vundle"
    git clone https://github.com/gmarik/vundle.git $vimpacks/bundle/vundle
else
    echo "Upgrde Vundle"
    cd "$vimdir/bundle/vundle" && git pull origin master
fi
echo " Step 5: update/install plugins using Vundle -------- Vim"
system_shell=$SHELLL
export SHELL="/bin/sh"
vim -u $HOME/.vimrc.bundles +BundleInstall! +BundleClean +qall
export SHELL=$system_shell
fi

# 编译前确定安装了：sudo apt-get install python2.7-dev
#                   sudo yum install python-devel

# echo "Step5: compile YouCompleteMe"
# echo "It will take a long time, just be patient!"
# echo "If error,you need to compile it yourself"
# echo "cd $CURRENT_DIR/bundle/YouCompleteMe/ && bash -x install.sh --clang-completer"
# cd $vimpacks/bundle/YouCompleteMe/
# if [ `which clang` ]   # check system clang
# then
    # bash -x install.sh --clang-completer --system-libclang   # use system clang
# else
    # bash -x install.sh --clang-completer
# fi


# if [ ! -d $vimdir/vimviews ];then
#     mkdir -p $vimdir/vimviews
# fi
