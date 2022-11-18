#!/bin/bash
# ====================================================
#   Copyright (C) 2022  All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : brew_source_replace.sh
#   Last Modified : 2022-10-08 17:05
#   Describe      :
#       https://cloud.tencent.com/developer/article/1614039
#       https://www.zhihu.com/question/31360766
#       https://blog.csdn.net/u011035397/article/details/115862286
# 对于 homebrew，需要替换的是4个模块的镜像：
# Homebrew
# Homebrew Core
# Homebrew-bottles
# Homebrew Cask
# 而最全的是 USTC（中科大镜像），其他家都缺少第4个，所以换了前三个后，执行 brew update 依然慢的要死; 具体替换方式如下：
#
# ====================================================

echo "===================================================="
echo "1. 查看 brew.git 当前源"
cd "$(brew --repo)" && git remote -v
# origin    https://github.com/Homebrew/brew.git (fetch)
# origin    https://github.com/Homebrew/brew.git (push)

echo "2. 查看 homebrew-core.git 当前源"
cd "$(brew --repo homebrew/core)" && git remote -v
# origin    https://github.com/Homebrew/homebrew-core.git (fetch)
# origin    https://github.com/Homebrew/homebrew-core.git (push)

echo "===================================================="
echo "3. 替换 Homebrew"
git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git


echo "4. 替换 Homebrew Core"
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git


echo "5. 替换 Homebrew Cask"
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git


echo "6. 替换 Homebrew Bottles"
# 对于 bash 用户：
# echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bash_profile
# source ~/.bash_profile
# 对于 zsh 用户：
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles/bottles' >> ~/.bashrc.local
source ~/.bashrc.local


echo "===================================================="
echo "7. 查看 brew.git 当前源"
cd "$(brew --repo)" && git remote -v
echo "8. 查看 homebrew-core.git 当前源"
cd "$(brew --repo homebrew/core)" && git remote -v

brew update
echo "======================Done=========================="
echo ""

##########################
### https://blog.csdn.net/u011035397/article/details/115862286
### 恢复数据源
# git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
# git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
# git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git
# brew update
##########################
