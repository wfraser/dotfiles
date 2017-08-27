MACOS=false
if [ $(uname -s) = "Darwin" ]; then
    MACOS=true
fi

if [ $HOST = "wfraser-mbp.corp.dropbox.com" ]; then
    # pull in some environment variables saved here
    source ~/.bash_profile

    function android_versions_with() {
        pushd ~/src/xplat >/dev/null
        git tag --contains $1 | awk -F/ '/dbapp-android/{print $2}' | sort -t. -k1,1nr -k2,2nr -k3,3nr
        popd >/dev/null
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
alias weather='curl wttr.in'
alias isodate='date +"%Y-%m-%dT%H:%M:%S%z"'
alias gcane="git commit --amend --no-edit"
alias human="awk 'BEGIN{split(\"kMGTE\", p, \"\")} {i=0; while(\$1>1024){\$1/=1024; i++} print \$1,p[i]}'"

if $MACOS; then
    alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
fi

function goto() {
    if [ -x ~/src/goto/target/debug/goto ]; then
        eval $(~/src/goto/target/debug/goto $*)
    else
        eval $(~/.cargo/bin/goto $*)
    fi
}

if $MACOS; then
    ncpus=$(sysctl -n hw.ncpu)
else
    ncpus=$(grep '^processor' /proc/cpuinfo | wc -l)
fi

alias make="make -j$((ncpus + 1))"

if [ "$HOST" = "odin" ]; then
    alias dstat='dstat -cdnmgy -N ethx0,ethi0'
elif [ "$HOST" = "sfo-arch1" ]; then
    alias dstat='dstat -cdnmgy -N eth0,eth1'
else
    alias dstat='dstat -cdnmgy'
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
    resize
fi

export EDITOR="/usr/bin/vim"

if [ $HOST = "odin" ]; then
    export PATH="$PATH:/home/wfraser/bin:/home/wfraser/shellscripts"
fi

if [ -d $HOME/.cargo/bin ]; then
    export PATH="$PATH:$HOME/.cargo/bin"
fi

if [ -d $HOME/.multirust/toolchains ]; then
    for toolchain in $HOME/.multirust/toolchains/*; do
        if $MACOS; then
            export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$toolchain/lib"
        else
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$toolchain/lib"
        fi
    done
fi

eval $(gpg-agent --daemon --allow-preset-passphrase 2>/dev/null)
export GPG_TTY="$TTY"

# Commands that start with a space are excluded from history! :)
setopt HIST_IGNORE_SPACE

setopt PROMPT_SUBST

# The following lines were added by compinstall

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

autoload -Uz compinit promptinit
compinit
promptinit

prompt walters

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

if [ -x "$HOME/reminders" ]; then
    $HOME/reminders
fi

# added by travis gem
[ -f /Users/wfraser/.travis/travis.sh ] && source /Users/wfraser/.travis/travis.sh || true
