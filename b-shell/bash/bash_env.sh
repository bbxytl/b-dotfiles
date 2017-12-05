HOMELOCAL_PATH=$HOME/.local
# PATH -- bin
# PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin
PYTHON_BREW="/usr/local/opt/python/libexec/bin"
PATH=$HOMELOCAL_PATH/bin:$PYTHON_BREW:$PATH
export PATH

# # 动态链接库路径
# # LD_LIBRARY_PATH --- lib
# # LD_LIBRARY_PATH=$HOMELOCAL_PATH/lib:/usr/lib:/usr/local/lib
# LD_LIBRARY_PATH=$HOMELOCAL_PATH/lib:$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH

# #找到静态库的路径
# LIBRARY_PATH=$HOMELOCAL_PATH/lib:$LIBRARY_PATH
# export LIBRARY_PATH

# # gcc include 路径
# C_INCLUDE_PATH=$HOMELOCAL_PATH/include:$C_INCLUDE_PATH
# export C_INCLUDE_PATH

# # g++ include 路径
# CPLUS_INCLUDE_PATH=$HOMELOCAL_PATH/include:$CPLUS_INCLUDE_PATH
# export CPLUS_INCLUDE_PATH


# # SYS_PKGCONFIG=/usr/local/lib/pkgconfig
# PYTHON_PKGCONFIG=$HOMELOCAL_PATH/lib/pkgconfig
# PKG_CONFIG_PATH=$PYTHON_PKGCONFIG:$SYS_PKGCONFIG
# export PKG_CONFIG_PATH

# color for man 需要安装 most
# export PAGER="most"
export PAGER="most"

# # Get color support for 'less'
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

# virtualenvswrapper 配置
# if [ `id -u` != '0' ]; then
  export VIRTUALENV_USE_DISTRIBUTE=1        # <-- Always use pip/distribute
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
  export PIP_REQUIRE_VIRTUALENV=true
  # 在执行pip的时候让系统自动开启虚拟环境
  export PIP_RESPECT_VIRTUALENV=true
  # 使用python，把默认Python放到虚拟环境中是为了方便管理，保持系统的干净
  alias pysys="workon pysys"

# fi


export PYTHONSTARTUP=$HOME/.pystartup.py
# export PATH=$PATH:/usr/local/Cellar/aria2/1.31.0/bin
alias aria2c="aria2c --conf-path=$HOME/.aria2/aria2.conf --log=$HOME/.cache/aria2/run.log"


# if [ $MY_BASH ];then
	# PS1='(MY_BASH)\[\e[1;35m\][\[\e[1;33m\]\u@\h \[\e[1;31m\]\w\[\e[1;35m\]]\[\e[1;36m\]\$ \[\e[0m\]'
# fi

