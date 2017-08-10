#!/bin/bash
# ====================================================
#   Copyright (C)2017 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : install-green.sh
#   Last Modified : 2017-08-10 17:09
#   Describe      :
#
#   Log           :
#
# ====================================================
cur_path=`pwd` \
&& echo "GREEN_VIM_PATH=$cur_path" >> ~/.bashrc \
&& mybash="source $cur_path/green/active" \
&& mybashde="source $cur_path/green/deactive" \
&& echo "alias mybash=\"$mybash\"" >> ~/.bashrc \
&& echo "alias mybashde=\"$mybashde\"" >> ~/.bashrc \
&& BundlePath="$cur_path/vim.tmp/bundle" \
&& mkdir -p $BundlePath \
&& grep "^Bundle [',\"]\S*/" $cur_path/vimrc.bundles| sed "s/Bundle [',\"]/https:\/\/github.com\//g" | sed "s/[',\"]//g" | while read line;do \
	dirname=`echo ${line##*/} | sed 's/ //g'`; \
	echo "git clone --depth 1 $line  $BundlePath/$dirname"; \
	# git clone --depth 1 $line  $BundlePath/$dirname; \
done \
&& cp $cur_path/project_vimrc/molokai.vim $BundlePath/molokai/colors/molokai.vim


