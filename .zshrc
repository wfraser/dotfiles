alias vi="vim"
alias cd..="cd .."
alias ll="ls -al"
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias lastaddr='last -i | perl -we '\''use Socket; while (<>) { chop; s/(\d+\.\d+\.\d+\.\d+)/defined($addr = gethostbyaddr(inet_aton("$1"), AF_INET)) ? $addr : "$1"/e; print "$_\n"; }'\'
alias vlock='clear && vlock'
alias qmake3='/usr/qt/3/bin/qmake'
alias pine='alpine'
alias xelatexmk="latexmk -e '\$pdflatex=\"xelatex\"' -pdf"
alias music='ncmpcpp'
alias sshfs='sshfs -o reconnect'

ncpus=`grep ^processor /proc/cpuinfo | wc -l`
alias make="make -j$((ncpus + 1))"

if [ "$HOST" = "odin" ]; then
    alias dstat='dstat -cdnmgy -N ethx0,ethi0'
elif [ "$HOST" = "sfo-arch1" ]; then
    alias dstat='dstat -cdnmgy -N eth0,eth1'
else
    alias dstat='dstat -cdnmgy'
fi

function bx()
{
    $@ 1>/dev/null 2>/dev/null &
    return 0
}

function git-rev-number()
{ 
    commit=""
    if [[ $1 == "" ]]; then
        commit=`git show HEAD | head -1 | cut -d" " -f2`
        #echo "usage: git-rev-number <commit-id>"
        #return 1
    else
        commit=$1
    fi
    number=`git rev-list --reverse HEAD | grep -n $commit | cut -d: -f1`
    if [[ $number == "" ]]; then
        echo "commit not found"
        return 1
    else 
        echo $number
    fi
    return 0
}


export EDITOR="/usr/bin/vim"

export PATH="$PATH:/usr/local/bin:/opt/java/bin:/home/wfraser/bin:/home/wfraser/shellscripts:/home/wfraser/.gem/ruby/2.0.0/bin"

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

#PROMPT="$PROMPT $(prompt_git_info)%{${fg[default]}%}"
#PS1="$PS1 $(prompt_git_info)%{${fg[default]}%}"

#precmd () { __git_ps1 "%B%(?..[%?] )%b%n@%U%m%u" "> " " (%s)" }

if [ -x "$HOME/reminders" ]; then
    $HOME/reminders
fi
