MACOS=false
if [ $(uname -s) = "Darwin" ]; then
    MACOS=true
fi

if [ $HOST = "MM40Y7QJ97" ] || [ $HOST = "VCQ4Y0C6XV" ]; then
    if [ -f ~/.bash_profile ]; then
        # pull in some environment variables saved here
        source ~/.bash_profile
    fi

    function android_versions_with() {
        pushd ~/src/xplat >/dev/null
        git tag --contains $1 | awk -F/ '/dbapp-android/{print $2}' | sort -t. -k1,1nr -k2,2nr -k3,3nr
        popd >/dev/null
    }

    function mp_versions_with() {
        pushd ~/src/server >/dev/null
        git branch --remote --contains $1 'origin/mp/*'
        popd >/dev/null
    }

    function gh() {
        if [[ "$1" == "dbx" ]] && [[ "$2" == "land" ]]; then
            shift 2
            command gh dbx land --keep-branch=False $@
        else
            command gh $@
        fi
    }
fi

alias vi="vim"
alias cd..="cd .."
alias ll="ls -al"
if $MACOS; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias grep='grep --colour=auto'
alias vlock='clear && vlock'
alias pine='alpine'
alias xelatexmk="latexmk -e '\$pdflatex=\"xelatex\"' -pdf"
alias music='ncmpcpp'
alias sshfs='sshfs -o reconnect'
alias nvlc='vlc --intf=ncurses'
alias isodate='date +"%Y-%m-%dT%H:%M:%S%z"'
alias gcane="git commit --amend --no-edit"
alias human="awk 'BEGIN{split(\"kMGTPE\", p, \"\")} {i=0; while(\$1>=1024){\$1/=1024; i++} print \$1,p[i]}'"
alias sleepnoise="sox -c2 -n -d synth brownnoise treble -20 gain -5"
alias listen="sox --input-buffer 8192 --buffer 32 -d -d"

if $MACOS; then
    alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
fi

function weather() {
    curl "wttr.in/$@"
}

function goto() {
    if [ -x ~/src/goto/target/debug/goto ]; then
        eval $(~/src/goto/target/debug/goto $*)
    else
        eval $(~/.cargo/bin/goto $*)
    fi
}

# cargo+less
function cargol() {
    cmd=$1
    shift
    cargo $cmd --color=always $@ |& less -R
}

# ripgrep+less
function rgl() {
    rg -p $@ |& less -R
}

if $MACOS; then
    ncpus=$(sysctl -n hw.ncpu)
else
    ncpus=$(grep '^processor' /proc/cpuinfo | wc -l)
fi

alias make="make -j$((ncpus + 1))"

if which dool >/dev/null; then
    dstat=dool
else
    dstat=dstat
fi

if [ "$HOST" = "odin.home.codewise.org" ]; then
    alias dstat="$dstat -cdnmgy -N etherx0"
elif [ "$HOST" = "blackwall" ]; then
    alias dstat="$dstat -cdnmgy -N ether0,ether1,ether2,ether3,ether4,ether5"
elif [ "$HOST" = "sfo-arch1" ]; then
    alias dstat="$dstat -cdnmgy -N eth0,eth1"
else
    alias dstat="$dstat -cdnmgy"
fi

function bx() {
    $@ 1>/dev/null 2>/dev/null &
    return 0
}

function git-rev-number() {
    commit=""
    if [[ $1 == "" ]]; then
        commit=`git rev-list -n1 HEAD`
        #echo "usage: git-rev-number <commit-id>"
        #return 1
    else
        commit=$1
    fi
    number=`git rev-list --reverse HEAD | grep -n "^$commit" | cut -d: -f1`
    if [[ $number == "" ]]; then
        echo "commit not found"
        return 1
    else 
        echo $number
    fi
    return 0
}

function diffstat() {
    git show --format= --numstat $* | awk '{add+=$1;del+=$2}END{print"+"add",-"del}'
}

function allstat() {
    git log --format= --numstat $* | awk '{add+=$1;del+=$2}END{print"+"add",-"del}'
}

if [ ! -z $(grep '^/dev/ttyS' <<<$TTY) ]; then
    eval $(resize)
fi

export EDITOR=vim
export VISUAL=$EDITOR

if [ $HOST = "odin" ] || [ $HOST = "odin.home.codewise.org" ]; then
    export PATH="$PATH:/home/wfraser/shellscripts"
fi

if [ -d $HOME/bin ]; then
    export PATH="$PATH:$HOME/bin"
fi

if [ -d $HOME/.cargo/bin ]; then
    export PATH="$PATH:$HOME/.cargo/bin"
fi

eval $(gpg-agent --daemon --allow-preset-passphrase 2>/dev/null)
export GPG_TTY="$TTY"

if [ -z $SSH_AUTH_SOCK ]; then
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/id_ed25519
fi

# Commands that start with a space are excluded from history! :)
setopt HIST_IGNORE_SPACE

setopt PROMPT_SUBST

autoload -Uz compinit promptinit vcs_info

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/wfraser/.zshrc'
zstyle ':completion::complete:*' use-cache 1
zstyle ':vcs_info:*' actionformats \
    ' %F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
zstyle ':vcs_info:*' formats \
    ' %F{5}[%F{2}%b%F{5}]%f'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

compinit
promptinit

if [ ! -z $(hostname -f | grep '\.dev\.corp\.dropbox\.com$' ) ]; then
    PROMPT_PREFIX="%F{cyan}DEV%f "
else
    PROMPT_PREFIX=""
fi

vcs_info_wrapper() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}

#prompt walters
PROMPT=$'$PROMPT_PREFIX%B%(?..[%?] )%b%n@%U%m%u$(vcs_info_wrapper)%# '
RPROMPT="%F{${1:-green}}%~%f"

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt beep extendedglob nomatch notify
unsetopt appendhistory autocd
bindkey -e 
bindkey '^[[1~' vi-beginning-of-line
bindkey '^[[H' vi-beginning-of-line
bindkey '^[[4~' vi-end-of-line
bindkey '^[[F' vi-end-of-line
bindkey '^[[3~' delete-char

if ! $MACOS && [ ! -z $DISPLAY ]; then
    # set caps lock to escape
    xmodmap -e 'clear Lock'
    xmodmap -e 'keycode 0x42 = Escape'
fi

[ -x "$(which reminders)" ] && [ -f ~/reminders.conf ] && reminders ~/reminders.conf || true
