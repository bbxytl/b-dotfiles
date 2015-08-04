#!/bin/bash
# ====================================================
#   Copyright (C)2015 All rights reserved.
#
#   Author  : bbxytl
#   Email   : bbxytl@gmail.com
#   FileName: uninstall-vim.sh
#   LastModify : 2015-07-24 10:19
#   Describe:
#
#   Log     :
#
# ====================================================

for i in $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles $HOME/.vimrc.config_base $HOME/.vimrc.config_filetype $HOME/.indexer_files;do
    if [ -e $i ];then
		rm $i
	fi
done
if [ -e $HOME/.vimrc_other ];then
	mv $HOME/.vimrc_other $HOME/.vimrc
fi
