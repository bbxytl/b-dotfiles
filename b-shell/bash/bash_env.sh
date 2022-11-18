#!/bin/bash
# ====================================================
#   Copyright (C)2018 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : bash_env.sh
#   Last Modified : 2022-10-10 16:57
#   Describe      :
#
# ====================================================

HOMELOCAL_PATH=$HOME/.local
GO_BIN_PATH="$HOME/go/bin"
PATH=$HOMELOCAL_PATH/bin:$PYTHON_BREW:$GO_BIN_PATH:$PATH
PATH="/usr/local/opt/coreutils/libexec/gnubin:/Users/long/Library/Python/3.9/bin:$PATH"
PATH="$PATH:$(pyenv root)/shims"
export PATH
export HOME_CACHE="$HOME/.cache"

export GOPROXY="https://goproxy.cn,direct"

export PAGER="less"

# # Get color support for 'less'
if [ "`uname -s`" = 'Darwin' ];then
export LESS="--RAW-CONTROL-CHARS"
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
fi
# virtualenvswrapper 配置
# https://virtualenv.pypa.io/en/latest/installation.html
# python -m pip install --user virtualenv virtualenvwrapper
# if [ `id -u` != '0' ]; then
  # export VIRTUALENV_USE_DISTRIBUTE=1        # <-- Always use pip/distribute
  export WORKON_HOME=$HOME/.local/virtualenvs       # <-- Where all virtualenvs will be stored
  if [ -e $HOMELOCAL_PATH/bin/virtualenvwrapper.sh ];then
	  # echo "$HOMELOCAL_PATH"
	  source $HOMELOCAL_PATH/bin/virtualenvwrapper.sh
  else if [ -e /usr/local/bin/virtualenvwrapper.sh ];then
			source /usr/local/bin/virtualenvwrapper.sh
	   fi
  fi
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
  # 套件将被安装在系统环境中
  # export PIP_REQUIRE_VIRTUALENV=true
  # export PIP_REQUIRE_VIRTUALENV=false
  # 在执行pip的时候让系统自动开启虚拟环境
  # export PIP_RESPECT_VIRTUALENV=true

# fi


export PYTHONSTARTUP=$HOME/.pystartup.py
# export PATH=$PATH:/usr/local/Cellar/aria2/1.31.0/bin
alias aria2c="aria2c --conf-path=$HOME/.aria2/aria2.conf --log=$HOME/.cache/aria2/run.log"

if [ "`uname -s`" = 'Darwin' ];then
    # mac 下使用 vim8  可能会直接报错，使用下面的参数去除报错
    export DYLD_FORCE_FLAT_NAMESPACE=1
    # mac brew 关闭自动更新
    export HOMEBREW_NO_AUTO_UPDATE=true
fi

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"

if [ -f ~/.gvm/scripts/gvm ];then
    source ~/.gvm/scripts/gvm
fi

