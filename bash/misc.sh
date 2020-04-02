if [[ $TERM == "9term" ]]; then
	alias ls='ls --color=none'
	alias man='man -P cat'
	export GIT_PAGER=cat
else
	alias ls='ls --color=auto'
fi

#PS1='[\u@\h \W]\$ '
#PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\n\$\[\033[00m\] '

green='\e[1;32m'
red='\e[1;31m'
txtreset='\e[0m'

smiley_color()
{
    if [ $? = 0 ]; then
        echo -e "${green}"
        return 0
    else
        echo -e "${red}"
        return 1
    fi
}

smiley_face()
{
    if [ $? = 0 ]; then
        echo -n ":)"
        return 0
    else
        echo -n ":("
        return 1
    fi
}

shopt -s histappend
shopt -s cdspell
shopt -s autocd

if [ -n "$PROMPT_COMMAND" ]; then
    PROMPT_COMMAND="$PROMPT_COMMAND;history -a"
else
    PROMPT_COMMAND="history -a"
fi

if [[ $TERM == "9term" ]]; then
        PROMPT_COMMAND="$PROMPT_COMMAND;awd"
fi

if [[ $TERM == "9term" ]]; then
	PS1="$ "
else
	PS1="\[\033[01;32m\]\u@\h\[\033[01;33m\] \w\n\[\$(smiley_color)\]\$(smiley_face) \[\033[01;34m\]\$\[\033[00m\] "
fi

eval $(dircolors -b ~/.dir_colors)

export PATH=$HOME/bin:$PATH
export PATH=$HOME/.cabal/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export EDITOR=vim

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias escreen='exec screen'
alias cal='cal -mw'
alias top='top -d1'

# causes all previous lines matching the current line to be removed from the history list before that line is saved
export HISTCONTROL=ignoredups
# do not truncate history file when this variable is unset
export HISTFILESIZE=1000000
export HISTSIZE=1000000

# Used by i3-sensible-terminal for starting terminals in i3.
# export TERMINAL=xterm
# export TERMINAL=xfce4-terminal
export TERMINAL=urxvt

# Enable the 'z' command.
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# Turn on 256 color support...
if [ "x$TERM" = "xxterm" ]
then
    export TERM="xterm-256color"
fi

# Disable ctrl-s freezing
stty -ixon

# Enable FZF completion (**<tab>)
source /usr/share/fzf/completion.bash
source /usr/share/fzf/key-bindings.bash
_fzf_setup_completion path git okular vim
export FZF_DEFAULT_COMMAND='fd --type f'
command -v blsd > /dev/null && export FZF_ALT_C_COMMAND='blsd'

source /usr/share/lf/lfcd.sh

bind -x '"\C-l": clear;'
