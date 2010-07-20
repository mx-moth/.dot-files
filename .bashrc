# ~/.bashrc: executed by bash(1) for non-login shells.

export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'
export PS1='\[\e[1m\][\u@\h \W]\[\e[32m\]\$\[\e[0m\] '
export LESS='FRSX'
export SMARTGIT_JAVA_HOME='/usr/lib/jvm/java-6-sun/'
export GREP_OPTIONS="--exclude-dir=\.svn"
export ACK_OPTIONS="--pager=less"
umask 022

# Include the alias' file
. ~/.shells/alias

# Include custom scripts
for file in ~/.shells/scripts/* ; do
	. $file
done
