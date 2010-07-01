# ~/.bashrc: executed by bash(1) for non-login shells.

export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'
export PS1='\[\e[1m\][\u@\h \W]\[\e[32m\]\$\[\e[0m\] '
umask 022

# Include the alias' file
. ~/.shells/alias

# Include custom scripts
for file in ~/.shells/scripts/* ; do
	. $file
done

# You may uncomment the following lines if you want 'ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
