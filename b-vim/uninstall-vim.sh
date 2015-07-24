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

for i in $HOME/.ctags $HOME/.indexer_files $HOME/.vim $HOME/.vimrc $HOME/.vimrc.bundles;do
    rm $i
done
