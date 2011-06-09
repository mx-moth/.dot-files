# ~/.bashrc: executed by bash(1) for non-login shells.

export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'
export PS1='\[\e[1m\][\u@\h \W]\[\e[32m\]\$\[\e[0m\] '
export LESS='FRSX'
export SMARTGIT_JAVA_HOME='/usr/lib/jvm/java-6-sun/'
export GREP_OPTIONS="--exclude-dir=\.svn"
export ACK_OPTIONS="--pager=less --type-add php=.ctp --type-add js=.coffee"
export MANPATH=$MANPATH':/home/tim/.local/share/man/'
export TZ='Australia/Hobart'
export NODE_PATH=/usr/local/lib/node_modules
umask 002

# Include the alias' file
. ~/.shells/alias

if [ -f "/etc/bash_completion" ] ; then
	. "/etc/bash_completion"
fi

# Use git style prompt if we have the git completion function
# See http://stackoverflow.com/questions/1007538/check-if-a-function-exists-from-a-bash-script for an explination of the if ... then
if type -t __git_ps1 | grep -q "^function$" ; then
	export GIT_PS1_SHOWDIRTYSTATE=true
	export GIT_PS1_SHOWUNTRACKEDFILES=true
	export PS1='\[[1m\][\u@\h \W\[[0;33m\]$(__git_ps1 " (%s)")\[[0;1m\]]\[[32m\]\$\[[0m\] '
fi

# Include custom scripts
for file in ~/.shells/scripts/* ; do
	. $file
done

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

run_scripts()
{
    for script in $1/*; do
        [ -x "$script" ] || continue
        . $script
    done
}

run_scripts $HOME/.bashrc.d
