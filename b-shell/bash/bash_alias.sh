
# 自身配置的 命令

SYS_VERSION=`uname -s`
if [ $SYS_VERSION != 'Linux' ];then
	SYS_VERSION='Mac'
fi

export EDITOR='vim'

DOT_CONFIG_MYDOT="$HOME/mydotfiles"
DOT_CONFIG_BDOT="$DOT_CONFIG_MYDOT/b-dotfiles"


alias v='/usr/bin/vi'
alias vi='vim'
# User specific aliases and functions
##Productivity
if [ $SYS_VERSION = 'Mac' ];then
# mac 隐藏文件
	alias fshow='defaults write com.apple.finder AppleShowAllFiles -bool true'
	alias fhide='defaults write com.apple.finder AppleShowAllFiles -bool false'

# mpv 播放器播放 bilibili 视频
	blimpv(){
		cur_dir=`pwd`
		cd "$DOT_CONFIG_MYDOT/packges/BiliDan"
		./bilidan.py $@
		cd $cur_dir
	}
fi

alias ll="ls  -l"
alias lla="ll -a"
alias llt="ll -t"
alias la="ls -a"

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

# . ~/.local/lib/python2.6/site-packages/powerline/bindings/bash/powerline.sh
# . ~/mydotfiles/packges/powerline/powerline/bindings/bash/powerline.sh

alias cdu="cd -"
alias cdb="cd ~/mydotfiles/b-dotfiles"
alias cdd="cd ~/data"
alias cdp="cd ~/data/projects"
alias cdc="cd ~/data/projects/cpp"
alias cdz="cd ~/data/projects/zlsg"
alias cdzl="cd ~/data/projects/zlsg/logic"
alias cdcd="cd ~/data/projects/coc_dev/"
alias cdcc="cd ~/data/projects/coc/logic"

alias cdopen="cd ~/data/git/open_channel"

alias cdl="cd ~/data/lean"
alias cdg="cd ~/data/git"
# 临时文件目录
alias cdt="cd ~/data/tmp"
alias cdmt="cd ~/mydotfiles/tmp"
export CACHE_TMP="$HOME/.cache/tmp"
export DTMP="$HOME/data/tmp"
export MTMP="$DOT_CONFIG_MYDOT/tmp"

alias rec="cd ~/Recycle"
alias rmabs="/bin/rm"

cdls(){
	echo -e '
cdu = "cd -"
cdd = "cd ~/data"
cdp = "cd ~/data/projects/"
cdc = "cd ~/data/projects/cpp"
cdz = "cd ~/data/projects/zlsg/trunk"
cdl = "cd ~/data/lean/"
cdg = "cd ~/data/git"
cdt = "cd ~/data/tmp/"
rec = "cd ~/Recycle"
cdlg
			'
}
# 当前目录的名称
export PWD_DIR="${PWD##*/}"
alias curdirname="echo $PWD_DIR"

config_dir=$HOME/.cache/cache_alias
log_dir=$config_dir/logs

log_file=$log_dir/commands.log
export FOUT=$log_file
alias cdlg="cd $log_dir"
alias lgcat="cat $log_file"
alias lgvim="vim $log_file"
alias lg="tee -a $log_file"
newlg(){
	if [ ! -e $log_dir ];then mkdir -p $log_dir;fi
	nowtime=`date +%Y%m%d%H%M%S`
	if [ ! -e $log_file ];then
		echo $nowtime'=================' >> $log_file
	else
		newfile=$log_file'.'$nowtime
		mv $log_file $newfile
		echo $nowtime'=================' >> $log_file
	fi
	echo $log_file
}
lgls(){
	echo "cdlg : 打开输出文件所在目录"
	echo "lgnew: 创建一个新的输出文件"
	echo "lgcat: 查看输出文件"
	echo "lgvim: vim打开输出文件"
	echo "lg   : 使用方式：command 2>&1 | lg"
	echo "       用于将输出输出到输出文件和屏幕"
	echo 'command >> $FOUT 用于将结果输出到输出文件'
}
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
	ifconfig
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
	ifconfig
	echo "Share_Dir : $share_dir"
	python share_up_down.py 8899
}


# 根据目前的使用环境，更新shell配置
sco(){
	if [ -f $HOME/.zshrc ];then source $HOME/.zshrc;return;fi
	if [ -f $HOME/.bashrc ];then source $HOME/.bashrc;return;fi
}

export PREDIRS=$config_dir/predirs
# 最大保存 PREDIRS_CNT 条路径
export PREDIRS_CNT=20
pcd() {
	if [ ! -e $config_dir ];then
		mkdir -p $config_dir
	fi
	curpd=`pwd`
	no=0
	if [ -e $PREDIRS ];then
		cat $PREDIRS | while read line
		do
			let no++
			if [ $line = $curpd ];then
				# sed -i $no','$no'd' $PREDIRS
				if [ $SYS_VERSION = 'Mac' ];then
					sed -i '' "$no,$no d" $PREDIRS
				else
					sed -i $no','$no'd' $PREDIRS
				fi
				# break
			fi
		done
	fi
	if [ $no -gt $PREDIRS_CNT ];then
		line_no=1
		cat $PREDIRS | read lines
		echo $lines
		# sed -i $line_no','$line_no'd' $PREDIRS
		if [ $SYS_VERSION = 'Mac' ];then
			sed -i '' "$line_no,$line_no d" $PREDIRS
		else
			sed -i $line_no','$line_no'd' $PREDIRS
		fi
	fi
	echo $curpd >> $PREDIRS

	if [ $# -gt 0 ];then
		if [ -e $1 ];then
			cd $1
		else
			echo "$1 unexited !"
		fi
	fi
}
# 显示缓存了多少目录
pls() {
	if [ $# -gt 0 ];then
		if [ $1 = '-h' ] || [ $1 = '--help' ];then
				echo "pls : 显示缓存了多少目录；带参数 -h[--help] 时显示相关命令说明；带参数 -c 时清空缓存路径"
				echo "pcd : 缓存当前路径，后跟参数为新的要切换的路径，无参数时只缓存路径"
				echo "psd : 无参数时调用 pls，后跟数字参数！为 pls 输出的对应缓存路径的编号"
				echo "prm : 无参数时调用 pls，后跟数字参数！删除对应编号的缓存路径"
		else if [ $1 = '-c' ];then
				rm $PREDIRS
			else
				pls '-d'
			fi
		fi
	else
		if [ -e $PREDIRS ];then
			no=0
			cat $PREDIRS | while read line
			do
				let no++
				echo "$no : $line"
			done
		fi
	fi
}
psd() {
	if [ $# -ge 1 ];then
		if [ -e $PREDIRS ];then
			if [[ "$1" =~ "^[0-9]+$" ]] ;then
				no=0
				cat $PREDIRS | while read line
				do
					let no++
					if [ $no -eq $1 ];then
						cd $line
					fi
				done
			else
				pcd $1
			fi
		fi
	else
		pls '-h'
	fi
}
prm() {
	if [ $# -ge 1 ];then
		no=$1
		if [[ "$1" =~ "^[0-9]+$" ]] ;then
			if [ $SYS_VERSION = 'Mac' ];then
				sed -i '' "$no,$no d" $PREDIRS
			else
				sed -i $no','$no'd' $PREDIRS
			fi
		else
			echo "需要路径编号！"
			pls
		fi
	else
		echo "需要路径编号！"
		pls
	fi
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
		# cd
		# rmabs -rf $Rec
		# mkdir $Rec
		# # cd $Rec
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

rmls() {
	echo "rmls   : ls this cmd"
	echo "rec    : checkout to $Rec"
	echo "rm     : move curfile/dir to $Rec"
	echo "rmabs  : delete absolutely, use '/bin/rm'"
	echo "rmall  : delete all in $Rec"
	echo -e "rmbk   : revoke the last delete to $Rec \n  \tor revoke the arg1"
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
				# dir_dir=`dirname $f`
				# if [ $dir_dir = '.' ];then dir_dir=`pwd`;fi
				# rm_f=$f.____.$today
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
alias gbr="git br -a"
# 清空已过期分支
alias gcbr="git remote prune origin"
# 显示tag
alias gtag="git tag"
# 显示最近 n 次更改的文件
gln(){
	num=2
	if [ $# -gt 0 ];then
		num=$1
	fi
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

gpsh(){
	gci $@
	git push
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
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
sbs(){ du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e';}
alias intercept="sudo strace -ff -e trace=write -e write=1,2 -p"
alias meminfo='free -m -l -t'
alias psg="ps ux | grep"
alias volume="amixer get Master | sed '1,4 d' | cut -d [ -f 2 | cut -d ] -f 1"

##Network
#alias websiteget="wget --random-wait -r -p -e robots=off -U mozilla"
#alias listen="lsof -P -i -n"
#alias port='netstat -tulanp'
#gmail() { curl -u "$1" --silent "https://mail.google.com/mail/feed/atom" | sed -e 's/<\/fullcount.*/\n/' | sed -e 's/.*fullcount>//'}
#alias ipinfo="curl ifconfig.me && curl ifconfig.me/host"
#getlocation() { lynx -dump http:
#//www.ip-adress.com/ip_tracer/?QRY=$1|grep address|egrep 'city|state|country'|awk '{print $3,$4,$5,$6,$7,$8}'|sed 's\ip address flag \\'|sed 's\My\\';}
#
##Funny
#kernelgraph() { lsmod | perl -e 'print "digraph \"lsmod\" {";<>;while(<>){@_=split/\s+/; print "\"$_[0]\" -> \"$_\"\n" for split/,/,$_[3]}print "}"' | dot -Tpng | display -;}
#alias busy="cat /dev/urandom | hexdump -C | grep \"ca fe\""
#

alias cman='man -M $HOME/.local/share/man/zh_CN'

# alias tlshutdown='shutdown -h now'
# #alias tlreboot='sudo reboot'
# alias tlinit='sudo mount -t vboxsf VBoxShare /mnt/WinShare;
# if [ $? -ne 0 ];then
#     echo " mount VBoxShare share dir error!"
# fi
# sudo -S mount -t vboxsf TL /mnt/TlShare;

# if [ $? -ne 0 ];then
#     echo " mount TL share dir error!"
# fi
# '
# 更方便的查看 diff ，同时保存起来
__init_git_svn(){
	if [ ! -d $CACHE_TMP/git-diff ];then mkdir -p $CACHE_TMP/git-diff;fi
	if [ ! -d $CACHE_TMP/svn-diff ];then mkdir -p $CACHE_TMP/svn-diff;fi
	if [ ! -d $CACHE_TMP/git-st ];then mkdir -p $CACHE_TMP/git-st;fi
	if [ ! -d $CACHE_TMP/svn-st ];then mkdir -p $CACHE_TMP/svn-st;fi
}
gdf(){ __init_git_svn; now=`date +%Y%m%d-%H%M%S`.log;fl=$CACHE_TMP/git-diff/$now;git diff $@ > $fl;vim -M $fl; }
sdf(){ __init_git_svn; now=`date +%Y%m%d-%H%M%S`.log;fl=$CACHE_TMP/svn-diff/$now;svn diff $@ > $fl;vim -M $fl; }

gsg(){ __init_git_svn; now=`date +%Y%m%d-%H%M%S`.log;fl=$CACHE_TMP/git-st/$now;git status $@ > $fl;vim -M $fl; }
ssg(){ __init_git_svn; now=`date +%Y%m%d-%H%M%S`.log; fl=$CACHE_TMP/svn-st/$now; svn status $@ | sed '/.workspace.vim/d' > $fl; vim -M $fl; }

dif(){ diff -y $@ | less; }
# 清除所有log
alias gdfclear="rm $CACHE_TMP/git-diff/*"
alias sdfclear="rm $CACHE_TMP/svn-diff/*"
alias gdfls="ls $CACHE_TMP/git-diff/"
alias sdfls="ls $CACHE_TMP/svn-diff/"
alias gst="git status"
# svn 只显示修改
alias sst="svn status"
alias ssq="svn status -q"

# 配置当前项目文件的 vim 自定义配置

_work_out(){
	ln -s $2 $1/
}

_work_clear(){
	if [ -e $1/$2 ];then
		rm $1/$2
	fi
}

_ycm_out(){
	inclpath="\t<inlcule path='"$1"'/>"
	echo $inclpath >> $2
}

_opt_path(){
	$1 $2 $3
}

optpath(){
	ls $2 | while read lne;do
		if [ -d "$2/$lne" ];then
			_opt_path  $1 $2/$lne $3
			optpath $1 $2/$lne $3
		fi
	done
}
proconf(){
	workspace_vim=".workspace.vim"
	if [ ! -f $workspace_vim ];then
		cp $DOT_CONFIG_BDOT/b-vim/vim.config/project_vimrc/workspace.vim $workspace_vim
		echo "" >> $workspace_vim
		echo "set path+=,`pwd`/**" >> $workspace_vim
		echo "set tags+=`pwd`/tags" >> $workspace_vim
		echo "" >> $workspace_vim
		if [ `pwd` != $HOME ];then
			optpath _work_out `pwd` `pwd`/$workspace_vim
		fi
	fi
	if [ ! -f .ycm_simple_conf.xml ];then
		ycm_conf=.ycm_simple_conf.xml
		ori_ycm_conf=$DOT_CONFIG_BDOT/b-vim/vim.config/project_vimrc/ycm_simple_conf_mac_cpp_base_dir.xml
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
}
# 配置 git 仓库忽略文件
progit(){
	if [ ! -f .gitignore ];then
		cp $DOT_CONFIG_BDOT/others/gitignore .gitignore
	fi
}



