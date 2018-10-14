#!/bin/bash
# ====================================================
#   Copyright (C)2018 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : install-go-tools.sh
#   Last Modified : 2018-10-14 16:06
#   Describe      :
#
# ====================================================

mkdir -p ~/go/src/golang.org/x
cd ~/go/src/golang.org/x/
git clone --depth 1 --recursive https://github.com/golang/tools
git clone --depth 1 --recursive https://github.com/golang/lint
git clone --depth 1 --recursive https://github.com/golang/net
git clone --depth 1 --recursive https://github.com/golang/time
git clone --depth 1 --recursive https://github.com/golang/sys
git clone --depth 1 --recursive https://github.com/golang/text
git clone --depth 1 --recursive https://github.com/golang/image
git clone --depth 1 --recursive https://github.com/golang/debug
git clone --depth 1 --recursive https://github.com/golang/crypto
