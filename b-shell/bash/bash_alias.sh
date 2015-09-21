
# 自身配置的 命令

SYS_VERSION=`uname -s`
if [ $SYS_VERSION != 'Linux' ];then
	SYS_VERSION='Mac'
fi

export EDITOR='vim'

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
        cd "$HOME/mydotfiles/packges/BiliDan"
        ./bilidan.py $@
        cd $cur_dir
    }
fi

alias ll="ls  -l"
alias lla="ll -a"
alias la="ls -a"

# virtualenv
alias vte='virtualenv'
# tmux
alias tmat="tmux attach -t"
alias tmnn="tmux new -s"
alias tmls="tmux ls"
alias tmrn="tmux rename-window"
alias tmux='tmux -2'

# . ~/.local/lib/python2.6/site-packages/powerline/bindings/bash/powerline.sh
# . ~/mydotfiles/packges/powerline/powerline/bindings/bash/powerline.sh

alias cdu="cd -"
alias cdd="cd ~/data"
alias cdp="cd ~/data/projects/"
alias cdc="cd ~/data/projects/cpp"
alias cdz="cd ~/data/projects/zlsg/trunk"
alias cdl="cd ~/data/lean/"
alias cdg="cd ~/data/git"
alias cdt="cd ~/data/tmp/"
alias rec="cd ~/Recycle"

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
            '
}


alias rmabs="/bin/rm"
# 当前目录的名称
export PWD_DIR="${PWD##*/}"
alias curdirname="echo $PWD_DIR"

config_dir=$HOME/.config/cache_alias
export PREDIRS=$config_dir/predirs
PREDIRS_README=$config_dir/predirs.md
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
            if [ ! -e $PREDIRS_README ];then
                echo "pls : 显示缓存了多少目录；带参数 -h[--help] 时显示相关命令说明；带参数 -c 时清空缓存路径" >> $PREDIRS_README
                echo "pcd : 缓存当前路径，后跟参数为新的要切换的路径，无参数时只缓存路径" >> $PREDIRS_README
                echo "psd : 无参数时调用 pls，后跟数字参数！为 pls 输出的对应缓存路径的编号" >> $PREDIRS_README
                echo "prm : 无参数时调用 pls，后跟数字参数！删除对应编号的缓存路径" >> $PREDIRS_README
            fi
            cat $PREDIRS_README
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
        # cd
        # rmabs -rf $Rec
        # mkdir $Rec
        # # cd $Rec
    else
        echo "This cmd only uses in $Rec !"
    fi
}

RMLS_README=$config_dir/rmls.md
rmls() {
   if [ ! -e $config_dir ];then mkdir $config_dir;fi
   if [ ! -e $RMLS_README ];then
       echo "rmls   : ls this cmd" >> $RMLS_README
       echo "rec    : checkout to $Rec" >> $RMLS_README
       echo "rm     : move curfile/dir to $Rec" >> $RMLS_README
       echo "rmabs  : delete absolutely, use '/bin/rm'" >> $RMLS_README
       echo "rmall  : delete all in $Rec" >> $RMLS_README
       echo -e "rmbk   : revoke the last delete to $Rec \n  \tor revoke the arg1" >> $RMLS_README
   fi
   cat $RMLS_README
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
		newf=${f##/*}
                mv $f $Rec/$newf.____.$today
                let cnt++
                # dir_dir=`dirname $f`
                # if [ $dir_dir = '.' ];then dir_dir=`pwd`;fi
                rm_f=$f.____.$today
                echo "`pwd`" > $Rec/$rm_f.dir
                echo "$f" >> $Rec/$rm_f.dir
                echo "$rm_f" > $cmbck_file
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
alias psg="ps aux | grep"
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

alias tlshutdown='shutdown -h now'
#alias tlreboot='sudo reboot'
alias tlinit='sudo mount -t vboxsf VBoxShare /mnt/WinShare;
if [ $? -ne 0 ];then
    echo " mount VBoxShare share dir error!"
fi
sudo -S mount -t vboxsf TL /mnt/TlShare;

if [ $? -ne 0 ];then
    echo " mount TL share dir error!"
fi
'

