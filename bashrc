# ~/.bashrc: executed by bash(1) for non-login shells.

export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'
export PS1='\[\e[1m\][\u@\h \W]\[\e[32m\]\$\[\e[0m\] '
export LESS='FRSX'
export SMARTGIT_JAVA_HOME='/usr/lib/jvm/java-6-sun/'
export GREP_OPTIONS="--exclude-dir=\.svn"
export ACK_OPTIONS="--pager=less --type-add php=.ctp --type-add js=.coffee"
export MANPATH=$MANPATH':/home/tim/.local/share/man/'
umask 002

# Include the alias' file
. ~/.shells/alias

if [ -f "/etc/bash_completion.d/git" ] ; then
	. "/etc/bash_completion.d/git"
	export GIT_PS1_SHOWDIRTYSTATE=true
	export GIT_PS1_SHOWUNTRACKEDFILES=true
	export PS1='\[[1m\][\u@\h \W\[[0;33m\]$(__git_ps1 " (%s)")\[[0;1m\]]\[[32m\]\$\[[0m\] '
fi

# Include custom scripts
for file in ~/.shells/scripts/* ; do
	. $file
done
