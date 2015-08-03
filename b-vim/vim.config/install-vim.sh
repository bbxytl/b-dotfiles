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
mv $HOME/.vimrc $HOME/.vimrc_other
echo " Step 1: bucking up current config --------------- Vim"
vimbak="$bakdot/ori-vim.$today"
if [ ! -e $vimbak ];then mkdir $vimbak; fi
for i in $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles $HOME/.vimrc.config_base $HOME/.vimrc.config_filetype $HOME/.indexer_files; do [ -e $i ] && [ ! -L $i ] && mv $i $vimbak/; done
for i in $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles $HOME/.vimrc.config_base $HOME/.vimrc.config_filetype $HOME/.indexer_files; do [ -L $i ] && unlink $i ; done

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
lnif $CURRENT_DIR/indexer_files $HOME/.indexer_files
lnif "$vimpacks" "$HOME/.vim"


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

echo " Step 4: install vundle"
if [ ! -e $vimpacks/bundle/vundle ]; then
    echo "Installing Vundle"
    git clone https://github.com/gmarik/vundle.git $vimpacks/bundle/vundle
else
    echo "Upgrde Vundle"
    cd "$HOME/.vim/bundle/vundle" && git pull origin master
fi
echo " Step 5: update/install plugins using Vundle -------- Vim"
system_shell=$SHELLL
export SHELL="/bin/sh"
vim -u $HOME/.vimrc.bundles +BundleInstall! +BundleClean +qall
export SHELL=$system_shell


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
