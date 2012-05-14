# ~/.bashrc: executed by bash(1) for non-login shells.

PATH="$HOME/local/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/local/bin:/sbin:/bin"
LD_LIBRARY_PATH="/opt/local/lib:/usr/local/lib:/usr/lib"
for i in $HOME/local/*; do
	[ -d $i/bin ] && PATH="${i}/bin:${PATH}"
	[ -d $i/sbin ] && PATH="${i}/sbin:${PATH}"
	[ -d $i/include ] && CPATH="${i}/include:${CPATH}"
	[ -d $i/lib ] && LD_LIBRARY_PATH="${i}/lib:${LD_LIBRARY_PATH}"
	[ -d $i/lib/pkgconfig ] && PKG_CONFIG_PATH="${i}/lib/pkgconfig:${PKG_CONFIG_PATH}"
	[ -d $i/share/man ] && MANPATH="${i}/share/man:${MANPATH}"
done
export PATH
export CPATH
export LD_LIBRARY_PATH
export PKG_CONFIG_PATH
export MANPATH

export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'
export LESS='FRSX'
export GREP_OPTIONS="--exclude-dir=\.svn"
export ACK_OPTIONS="--pager=less --type-add php=.ctp --type-add js=.coffee"
export TZ='Australia/Hobart'
export NODE_PATH=$HOME/local/lib/node_modules
export PYTHONSTARTUP=~/.pythonrc
umask 002

# Program alias'
alias vi='vim -p'
alias ls='ls -hF --color=auto'
alias xclip='xclip -selection "clipboard"'

if [ -f "/etc/bash_completion" ] ; then
	. "/etc/bash_completion"
fi

if echo "$-" | grep -q 'i' ; then
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
fi

export PS1='\[\e[1m\][\u@\h \W]\[\e[32m\]\$\[\e[0m\] '
# Use git style prompt if we have the git completion function
# See http://stackoverflow.com/questions/1007538/check-if-a-function-exists-from-a-bash-script for an explination of the if ... then
if type -t __git_ps1 | grep -q "^function$" ; then
	export GIT_PS1_SHOWDIRTYSTATE=true
	export GIT_PS1_SHOWUNTRACKEDFILES=true
	export PS1='\[[1m\][\u@\h \W\[[0;33m\]$(__git_ps1 " (%s)")\[[0;1m\]]\[[32m\]\$\[[0m\] '
fi

run_scripts() {
    for script in $1/*; do
        . $script
    done
}

# Include custom scripts
run_scripts $HOME/.bashrc.d
