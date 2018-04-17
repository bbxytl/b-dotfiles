#!/bin/bash
# ====================================================
#   Copyright (C)2018 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : bash_alias.sh
#   Last Modified : 2018-04-05 19:22
#   Describe      :
#
# ====================================================
# 自身配置的 命令

SYS_VERSION=`uname -s`

export EDITOR='vim'

DOT_CONFIG_MYDOT="$HOME/mydotfiles"
DOT_CONFIG_BDOT="$DOT_CONFIG_MYDOT/b-dotfiles"


alias v='/usr/bin/vi'
alias vi='vim'
# User specific aliases and functions
##Productivity
if [ $SYS_VERSION = 'Darwin' ];then
# mac 隐藏文件
	alias fshow='defaults write com.apple.finder AppleShowAllFiles -bool true'
	alias fhide='defaults write com.apple.finder AppleShowAllFiles -bool false'
fi

alias ll="ls  -l"
alias lla="ll -A"
alias llt="ll -t"
alias la="ls -A"

# virtualenv
alias vte='virtualenv'
alias mkvte='mkvirtualenv'
alias deact='deactivate'
alias rmvte='rmvirtualenv'


# tmux
alias tmat="tmux attach -t"
alias tmnn="tmux new -s"
alias tmls="tmux ls"
alias tmrn="tmux rename-window"
alias tmux='tmux -2'


alias cdu="cd -"
alias cdb="cd ~/mydotfiles/b-dotfiles"
alias cdd="cd ~/data"
alias cdp="cd ~/data/projects"
alias cdc="cd ~/data/projects/cpp"

alias cdl="cd ~/data/lean"
alias cdg="cd ~/data/git"
alias cal="cal -m"
# 临时文件目录
alias cdt="cd ~/data/tmp"
alias cdmt="cd ~/mydotfiles/tmp"


alias rec="cd ~/Recycle"
alias rmabs="/bin/rm"
alias tac="tail -r"

# 当前目录的名称
export PWD_DIR="${PWD##*/}"
alias curdirname="echo $PWD_DIR"

# 通过浏览器共享某一目录
# 用法：
#	共享当前目录: webshare
#	共享指定目录: webshare [dir]
webshare(){
	share_dir=`pwd`
	if [ $# -gt 0 ];then
		if [ -d $1 ];then
			cd $1
			share_dir=`pwd`
		fi
	fi
	ifconfig |grep 'Bcast'
	echo "Share_Dir : $share_dir"
	python -m SimpleHTTPServer 8899
}
webshareup(){
	share_dir=`pwd`
	if [ $# -gt 0 ];then
		if [ -d $1 ];then
			cd $1
			share_dir=`pwd`
		fi
	fi
	cd $share_dir
	SHARE_UP_DOWN=$DOT_CONFIG_BDOT/others/share_up_down.py

	if [ ! -e share_up_down.py ];then
		ln -s $SHARE_UP_DOWN share_up_down.py
	fi
	ifconfig |grep 'Bcast'
	echo "Share_Dir : $share_dir"
	python share_up_down.py 8899
}


# 防误删操作
# 原来的删除操作
Rec=$HOME/Recycle
cmbck_file=$Rec/.cmbck_file.cmbck
# 清空回收站,只能用在回收站里
rmall() {
	if [ `pwd` = $Rec ];then
		ls $Rec | while read line;do
			rmabs -rf $line
		done
		rmabs $Rec/.cmbck_file.cmbck
		rmabs -rf $Rec/.*
	else
		if [ $# -ge 1 ];then
			if [ -d $1 ];then
				old_dir=`pwd`
				cd $1
				ls $1 | while read line;do
					rm  $line
				done
				cd $old_dir
			else
				echo "$i not exited !"
			fi
		else
			echo "This cmd only uses in $Rec when no arg of dir!"
		fi
	fi
}

# 将删除的文件全部放到回收站里,防误删
rm() {
	curdir=`pwd`
	if [ ! -e $Rec ];then
		mkdir $Rec
	fi
	if [ $# -gt 0 ];then
		tmp="--"
		today=`date +%Y%m%d%H%M%S`
		cnt=0
		for f in $@;do
			if [ ${f:0:1} != "-" ];then
				tmp=$f
				newf=${f##*/}'.____.'$today
				mv $f $Rec/$newf
				let cnt++
				echo "`pwd`" > $Rec/$newf.dir
				echo "$f" >> $Rec/$newf.dir
				echo "$newf" > $cmbck_file
				echo "$f : move $f to $Rec ! OK ! use 'rmls' show all cmds !"
			fi
		done
		if [ $tmp = "--" ];then
			rmabs $@
		else
			echo "CNT: $cnt ==========================================="
		fi
	else
		rmls
	fi
	cd $curdir
}

# 撤销最后一次的删除、某个文件的删除
rmbk() {
	curdir=`pwd`
	error="No dir : $Rec Or No file : $cmbck_file ,Can not comeback !"
	if [ $# -gt 0 ];then cbk_dir=$1;
	else if [ ! -e $Rec ] || [ ! -e $cmbck_file ];then
			echo $error
			return
		fi
		cat $cmbck_file | read cbk_dir
	fi
	cd $Rec

	ls $Rec | while read line;do
		if [ $line = $cbk_dir ];then
			back_dir_file=$line".dir"
			# .dir 中保存了两行，一行是删除此文件时所在的目录，
			# 另一行是当时删除的文件
			cnt=0
			mv_cur_dir=""
			is_this_dir=true
			cat $back_dir_file |while read back_dir;do
				if [ $cnt -lt 1 ];then
					mv_cur_dir=$back_dir
					if [ ! -e $back_dir ];then mkdir -p $back_dir;fi
					cd $back_dir;
				fi
				if [ $cnt -gt 1 ];then
					if [ -e $back_dir ];then back_dir=$back_dir".rmback";fi
					mv $Rec/$line $back_dir
					rmabs $Rec/$line.dir
					# 恢复的文件并不是在当前目录下
					if [ `ls $mv_cur_dir | wc -l` -eq 0 ];then rmabs -rf $mv_cur_dir;fi
					echo "Comeback $line to $back_dir !"
					cd $curdir
					return
				fi
				cnt=9
			done
		fi
	done
	echo "$cbk_dir not exited ! Maybe delete absolutely Or rmbk already !"
	cd $curdir
}

# 精简版log
alias gll="git lg | less"
# 精简版 分支
alias gbr="git br"
alias gbra="git br -a"
alias gbrh="git br | head"
# 清空已过期分支
alias gcbr="git remote prune origin"
# 显示tag
alias gtag="git tag"
# 显示最近 n 次更改的文件
gln(){
	num=2
	if [ $# -gt 0 ];then num=$1; fi
	git lg -n $num --stat | less
}
gci(){
	if [ `uname -s` != "Linux" ];then
			cmmt="update-from-Mac"
	else
			cmmt="update-from-Linux"
	fi
	if [ $# -gt 0 ];then
		cmmt=$1
	fi
	git add  --all
	git commit -m "$cmmt"
}

alias grep='grep --color=auto'
mcd() { mkdir -p "$1"; cd "$1";}
cls() { cd "$1"; ls;}
backup() { cp "$1"{,.bak};}
md5check() { md5sum "$1" | grep "$2";}
alias makescript="fc -rnl | head -1 >"
alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
alias c="clear"
alias histg="history | grep"
alias ..='cd ..'
alias ...='cd ../..'
extract() {
	if [ -f $1 ] ; then
	case $1 in
		*.tar.bz2)   tar xjf $1     ;;
		*.tar.gz)    tar xzf $1     ;;
		*.bz2)       bunzip2 $1     ;;
		*.rar)       unrar e $1     ;;
		*.gz)        gunzip $1      ;;
		*.tar)       tar xf $1      ;;
		*.tbz2)      tar xjf $1     ;;
		*.tgz)       tar xzf $1     ;;
		*.zip)       unzip $1       ;;
		*.Z)         uncompress $1  ;;
		*.7z)        7z x $1        ;;
		*)     echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

#System info
alias cmount="mount | column -t"
alias dirtree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
sbs(){ du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e';}
alias intercept="sudo strace -ff -e trace=write -e write=1,2 -p"
alias meminfo='free -m -l -t'
alias psg="ps ux | grep -a"
alias volume="amixer get Master | sed '1,4 d' | cut -d [ -f 2 | cut -d ] -f 1"
alias hsg="history | grep"

##Network
alias myip="ifconfig | grep 'broadcast'"
#alias websiteget="wget --random-wait -r -p -e robots=off -U mozilla"
#alias listen="lsof -P -i -n"
#alias port='netstat -tulanp'
#gmail() { curl -u "$1" --silent "https://mail.google.com/mail/feed/atom" | sed -e 's/<\/fullcount.*/\n/' | sed -e 's/.*fullcount>//'}
#alias ipinfo="curl ifconfig.me && curl ifconfig.me/host"
getlocation() { lynx -dump http:
//www.ip-adress.com/ip_tracer/?QRY=$1|grep address|egrep 'city|state|country'|awk '{print $3,$4,$5,$6,$7,$8}'|sed 's\ip address flag \\'|sed 's\My\\';}
#
##Funny
#kernelgraph() { lsmod | perl -e 'print "digraph \"lsmod\" {";<>;while(<>){@_=split/\s+/; print "\"$_[0]\" -> \"$_\"\n" for split/,/,$_[3]}print "}"' | dot -Tpng | display -;}
#alias busy="cat /dev/urandom | hexdump -C | grep \"ca fe\""
#

alias cman='man -M $HOME/.local/share/man/zh_CN'
# Use VIm as man pager
# vman () {
    # export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    # vim -R -c 'set ft=man nomod nolist' -c 'map q :q' \
    # -c 'map ' -c 'map b ' \
    # -c 'nmap K :Man =expand(\\\"\\\")' -\""

    # invoke man page
    # man $@

    # we muse unset the PAGER, so regular man pager is used afterwards
    # unset PAGER
# }

# alias shutdown='shutdown -h now'
# #alias reboot='sudo reboot'
# alias mount_init='sudo mount -t vboxsf VBoxShare /mnt/WinShare;
# if [ $? -ne 0 ];then
#     echo " mount VBoxShare share dir error!"
# fi
# '
# 更方便的查看 diff ，同时保存起来
export CACHE_TMP="$HOME/Recycle"
__init_git_svn(){
	if [ ! -d $CACHE_TMP/git-diff ];then mkdir -p $CACHE_TMP/git-diff;fi
	if [ ! -d $CACHE_TMP/svn-diff ];then mkdir -p $CACHE_TMP/svn-diff;fi
	if [ ! -d $CACHE_TMP/git-st ];then mkdir -p $CACHE_TMP/git-st;fi
	if [ ! -d $CACHE_TMP/svn-st ];then mkdir -p $CACHE_TMP/svn-st;fi
	if [ ! -d $CACHE_TMP/file-diff ];then mkdir -p $CACHE_TMP/file-diff;fi
}
gdf(){ __init_git_svn; now=`date +%Y%m%d-%H%M%S`.log;fl=$CACHE_TMP/git-diff/$now;git diff $@ > $fl;vim -M $fl; }
sdf(){ __init_git_svn; now=`date +%Y%m%d-%H%M%S`.log;fl=$CACHE_TMP/svn-diff/$now;svn diff $@ > $fl;vim -M $fl; }

gsg(){ __init_git_svn; now=`date +%Y%m%d-%H%M%S`.log;fl=$CACHE_TMP/git-st/$now;git status $@ > $fl;vim -M $fl; }
ssg(){ __init_git_svn; now=`date +%Y%m%d-%H%M%S`.log; fl=$CACHE_TMP/svn-st/$now; fl0=$fl".log";
	svn status $@ > $fl0
	cat ".svnignore" | while read line;do
		if [ -z $line ];then continue;fi;
		echo "$line"x| grep -q "^\s";test $? -eq 0 && continue
		sed "/$line/d" $fl0 > $fl;
		mv $fl $fl0;
	done
	mv $fl0 $fl;
	vim -M $fl;
}

# dif(){ diff -y $@ | less; }
dif(){ __init_git_svn; now=`date +%Y%m%d-%H%M%S`.log;fl=$CACHE_TMP/file-diff/$now;diff -c -a -b $@ > $fl;vim -M $fl; }
alias gst="git status"
# svn 只显示修改
alias sst="svn status | grep -v '.workspace.vim'"
alias ssq="svn status -q"
alias ssqm="ssq | grep '^M'"

alias ssta="sst | grep -v ^对 | grep -v ^Performing | grep -v ^$ \
	| grep -v 'etc/config' \
	| grep -v ' tags' \
	| grep -v ' log' \
	| grep -v ' start' \
	| grep -v ' stop' \
	| grep -v ' make' \
	| grep -v ' update' \
	| grep -v ' restart' \
	| grep -v ' rpc_update' \
	| grep -v ' shareprotocal.sh' \
	| grep -v ' tmp' \
	| grep -v ' dat' \
	| grep -v ' user' \
	| grep -v ' tmp_eval_file.c' \
	| grep -v '.log' \
	| grep -v ' .git*'\
	| grep ^\?"
alias sstm="ssq | grep -v '^对' | grep -v '^Performing' | grep -v '^$'"

# 配置当前项目文件的 vim 自定义配置
_work_out(){
	ln -s $2 $1/
}

_work_clear(){
	if [ -L "$1/$2" ];then
		rm "$1/$2"
		# unlink "$1/$2"
	fi
}

_ycm_out(){
	inclpath="\t<include path='"$1"'/>"
	echo $inclpath >> $2
}

_opt_path(){
	# echo "$1  $2 $3"
	$1 $2 $3
}

optpath(){
	ls -A $2 | while read lne;do
		# echo "$lne"
		if [ "$lne" = "." ];then continue; fi
		if [ "$lne" = ".." ];then continue; fi
		if [ "$lne" = ".git" ];then continue; fi
		if [ "$lne" = ".svn" ];then continue; fi
		if [ -d "$2/$lne" ];then
			_opt_path  $1 $2/$lne $3
			optpath $1 $2/$lne $3
		fi
	done
}
proconf(){
	workspace_vim=".workspace.vim"
	if [ ! -f $workspace_vim ];then
		cp $DOT_CONFIG_BDOT/b-vim/config/projects/workspace.vim $workspace_vim
		echo "" >> $workspace_vim
		echo "set path+=,`pwd`/**" >> $workspace_vim
		echo "set tags+=`pwd`/tags" >> $workspace_vim
		echo "" >> $workspace_vim
	fi
	workspace_vim=".workspace_syntax.vim"
	if [ ! -f $workspace_vim ];then
		cp $DOT_CONFIG_BDOT/b-vim/config/projects/workspace_syntax.vim $workspace_vim
	fi
	if [ ! -f .ycm_simple_conf.xml ];then
		ycm_conf=.ycm_simple_conf.xml
		ori_ycm_conf=$DOT_CONFIG_BDOT/b-vim/config/projects/ycm_simple_conf_mac_cpp_base_dir.xml
		cat $ori_ycm_conf | while read line;do
			if [ "$line" = "</project>" ];then
				echo "" >> $ycm_conf
				optpath _ycm_out `pwd` $ycm_conf
			fi
			echo $line >> $ycm_conf
		done
	fi
}
# 清除 项目中自定义 vim 配置文件
proclr(){
	workspace_vim=".workspace.vim"
	optpath _work_clear `pwd` $workspace_vim
	_work_clear `pwd` $workspace_vim

	workspace_vim=".workspace_syntax.vim"
	optpath _work_clear `pwd` $workspace_vim
	_work_clear `pwd` $workspace_vim
}
# 配置 git 仓库忽略文件
progit(){
	if [ ! -f .gitignore ];then
		cp $DOT_CONFIG_BDOT/others/gitignore .gitignore
	fi
}

dsvn=".svn"
_gitaddsvn(){
	git add "$1/$2/*"
}
gitaddsvn(){
	optpath _gitaddsvn `pwd` $dsvn
	_gitaddsvn `pwd` $dsvn
}

# 生成密码
randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}

# 格式化输出 json
format_json(){
cat $1 | python -m json.tool > "$1.format.json"
}
alias jsonpertty="python -m json.tool"
alias http="http --pretty all"
# Mac 上使用, 需要 brew install jq
alias fmtjson='pbpaste | jq "." | pbcopy; echo "json formated and pasted to clipboard: "; pbpaste | jq'

alias gitinfo="cat .git/config"


############## docker ###############
# 删除所有容器
alias docker_rm_all_container="docker ps -a |grep Exited | cut -d ' ' -f1 | xargs docker rm"
alias docker_rm_all_container_created="docker ps -a |grep Created | cut -d ' ' -f1 | xargs docker rm"
alias dockerps="docker ps -a"

alias freepic="freepic -d -p"

alias gpp="g++"

# 查看vim 的备份文件
alias lsvimbak="ls *|rev|cut -d_  -f1 |rev|base64 -D"

alias tree="tree -C"

## 日期设置
alias datestr="date +'%Y-%m-%d %H:%M:%S'"
alias datets="date '+%s'"



