# ~/.bashrc: executed by bash(1) for non-login shells.

# Path in the common things
PATH="$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/local/bin:/sbin:/bin"
LD_LIBRARY_PATH="/opt/local/lib:/usr/local/lib:/usr/lib"

# ~/local/ is much like /opt, but just for me. All bin/, include/, lib/, etc
# folders are pathed in
for i in $HOME/local/*; do
	[ -d $i/bin ] && PATH="${i}/bin:${PATH}"
	[ -d $i/sbin ] && PATH="${i}/sbin:${PATH}"
	[ -d $i/include ] && CPATH="${i}/include:${CPATH}"
	[ -d $i/lib ] && LD_LIBRARY_PATH="${i}/lib:${LD_LIBRARY_PATH}"
	[ -d $i/lib/pkgconfig ] && PKG_CONFIG_PATH="${i}/lib/pkgconfig:${PKG_CONFIG_PATH}"
	[ -d $i/share/man ] && MANPATH="${i}/share/man:${MANPATH}"
done

# Cabal, for Haskell stuff
if [ -d $HOME/.cabal/bin ] ; then
	PATH="${HOME}/.cabal/bin:${PATH}"
fi

export PATH
export CPATH
export LD_LIBRARY_PATH
export PKG_CONFIG_PATH
export MANPATH

export ACK_OPTIONS="--pager=less --type-add php=.ctp --type-add js=.coffee"
export TZ='Australia/Hobart'
export NODE_PATH=$HOME/local/node/lib/node_modules
umask 002

# Yay vim
export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'

# less: Quit if little text, Colours, fold, do not clear screen
export LESS='FRSX'

# Dont grep .svn folders.
export GREP_OPTIONS="--exclude-dir=\.svn"


# Program alias'
# --------------

# Start vim with tabs, instead of that :next rubbish
alias vi='vim -p'

# Human readable, coloured ls
alias ls='ls -hF --color=auto'

# Copy to the clipboard, for ctrl+v pasting
alias xclip='xclip -selection "clipboard"'

# Copy to the clipboard, and also print to stdout. Useful in long pipes
alias pxclip='tee >( xclip -selection "clipboard" )'

# Do nothing
alias noop='echo -n ""'

# Use like `command > output-from-command-`datestamp``
alias datestamp='date "+%Y-%m-%d-%H%m"'

# Start a simple static file server
alias serve="python -mSimpleHTTPServer"

# Source the system-wide bach completion scripts.
# These take a second or two to run, so you have to enable them yourself.
alias ++magic=". /etc/bash_completion"

# Tail syslog. I was typing this quite a lot, so alias.
alias syslog="sudo tail -f /var/log/syslog"

# Prettify a json chunk
# eg `curl http://example.com/api/user/1.json | pretty-json`
alias pretty-json="python -mjson.tool"


# Handy functions
# ---------------

function ack-edit() {
	vim +/"$1" -p $( ack-grep -l "$@" )
}

# Print out all arguments as they are supplied, separated by the null character.
# Useful when passing an array of file names to xargs or something. Example:
#
# paths=('file' 'path/with spaces/to file.txt')
# nullinate "${paths[@]}" | xargs -0 frobnicate
function nullinate() {
	is_first=1
	for arg in "$@" ; do
		if [[ "$is_first" -eq 1 ]] ; then
			is_first=0
		else
			echo -en "\0"
		fi
		echo -n "$arg"
	done
}

# List the heirarchy of directories leading to the named file/directory
# If no argument is supplied, `pwd` is used. Example:
#
#     $ ls-parents /usr/local/bin
#     drwxr-xr-x 28 root root 4096 Jan  2 10:08 /
#     drwxr-xr-x 10 root root 4096 Apr 23  2012 /usr
#     drwxr-xr-x 10 root root 4096 Apr 23  2012 /usr/local
#     drwxr-xr-x  2 root root 4096 Apr 23  2012 /usr/local/bin
#     $ cd
#     $ ls-parents
#     drwxr-xr-x 28 root root 4096 Jan  2 10:08 /
#     drwxr-xr-x  4 root root 4096 Dec  3 12:05 /home
#     drwxr-xr-x 38 tim  tim  4096 Jan  2 10:49 /home/tim
function ls-parents() {
	path=$( readlink -e ${1:-`pwd`} )
	paths=("$path")
	while [[ $path != '/' ]] ; do
		path=$( dirname "$path" )
		paths+=("$path")
	done

	nullinate "${paths[@]}" | xargs -0 ls -ld
}

# Fork a program, ignoring stdin, stdout, stderr
function sequester() {
	nohup "$@" &>/dev/null &
}

# Shortcut for launching `dolphin` in the current directory
function eeee() {
    sequester dolphin "$( pwd )"
}

# Combination of pgrep and ps. Basically does `ps $( pgrep pattren )` but
# behaves when no process' are found.
# eg: `psgrep python`
function psgrep() {
	pattern=$1
	pids="$( pgrep "$pattern" )"
	if [[ -z "$pids" ]] ; then
		return 1
	fi
	ps $pids
}

# Put the date before every line in stdin
# eg: `long-running-process | predate > log-file.txt`
function predate() {
	format=""
	case $1 in
		-u|--unix) format="+%s.%N" ;;
		-h|--human) format="" ;;
		-i|--iso8601) format="+%Y-%m-%d %H:%M:%S" ;;
		*) format=$1 ;;
	esac

	while read line ; do
		echo "[$( date $format )] $line"
	done
}

# Highlight a pattern in stdin
# eg: `foo -x bar.baz | highlight quux`
function highlight() {
	ack-grep --color --passthru "$@"
}

# Make a directory and cd in to it.
function mkcd() {
	mkdir -p "$1" && cd "$1"
}

# Compute the mathematical expression passed in on the command line.
# Dont forget to quote your input if using functions like sin, log, etc; or if
# using '*'.
# eg: `c '1 + 2 * sin(3)'`
function c() {
	script="print $@"
	if python -c 'import numpy' &>/dev/null ; then
		script="from numpy import *; $script"
	else
		script="from math import *; $script"
	fi
	python -c "$script" | pxclip
}


# Set up bash nicely
# ------------------

# Source in system bash completion, if it exists# The bit of magic makes it run asynchronously or something. See http://superuser.com/q/267771

# Search backwards and forwards through history easier
if echo "$-" | grep -q 'i' ; then
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
fi

# Build up PS1
export VIRTUAL_ENV_DISABLE_PROMPT=true
export VCPROMPT_STAGED='+'
export VCPROMPT_MODIFIED='*'
export VCPROMPT_UNTRACKED='?'
VCPROMPT="$HOME/.bashrc.d/vcprompt"

# Set PS1. Levels are:
# * 0, low, minimal: Minimal PS1. Useful for slow systems, or systems with
#   basic shells
# * 1, medium, normal: Prompt showing coloured information, including
#   virtualenv status
# * 2, high, full: Prompt showing coloured information, including virtualenv
#   and version control status

# Generated with bashrc.d/build_ps1.py
function prompt-level() {
	level=$1
	case $level in
	0|low|minimal)
		level=0
		export PS1='[ \u at \h in \W ] \$ '
		;;
	1|medium|normal)
		level=1
		export PS1='\n[ \[\e[38;5;40m\]\u\[\e[0m\] at \[\e[38;5;13m\]\h\[\e[0m\]$( if [[ x"$VIRTUAL_ENV" != x ]] ; then dir=$( basename $( echo -n "$VIRTUAL_ENV" | sed -e"s/\/venv\/\?$//" ) ) ; echo " working on \[\e[38;5;51m\]$dir\[\e[0m\]" ; fi ) in \[\e[38;5;202m\]\w\[\e[0m\] ]\n\$ '
		;;
	2|high|full)
		level=2
		export PS1='\n[ \[\e[38;5;40m\]\u\[\e[0m\] at \[\e[38;5;13m\]\h\[\e[0m\]$( ${VCPROMPT} -f " on \[\e[38;5;130m\]%n\[\e[0m\]:\[\e[38;5;214m\]%b\[\e[0m\]\[\e[38;5;239m\] [\[\e[0m\]\[\e[31m\]%m\[\e[0m\]\[\e[38;5;33m\]%u\[\e[0m\]\[\e[38;5;239m\]]\[\e[0m\]" --format-git " on \[\e[38;5;130m\]%n\[\e[0m\]:\[\e[38;5;214m\]%b\[\e[0m\]\[\e[38;5;239m\] [\[\e[0m\]\[\e[32m\]%a\[\e[0m\]\[\e[31m\]%m\[\e[0m\]\[\e[38;5;33m\]%u\[\e[0m\]\[\e[38;5;239m\]]\[\e[0m\]")$( if [[ x"$VIRTUAL_ENV" != x ]] ; then dir=$( basename $( echo -n "$VIRTUAL_ENV" | sed -e"s/\/venv\/\?$//" ) ) ; echo " working on \[\e[38;5;51m\]$dir\[\e[0m\]" ; fi ) in \[\e[38;5;202m\]\w\[\e[0m\] ]\n\$ '
		;;
	*)
		echo "Unknown prompt-level: $1"
		return 1
	esac

	export PROMPT_LEVEL=$level
}

function ++prompt () {
	level=$(( $PROMPT_LEVEL + 1))
	prompt-level $level
}

function --prompt () {
	level=$(( $PROMPT_LEVEL - 1))
	prompt-level $level
}

prompt-level 1


# Python
# ------
export PYTHONSTARTUP=~/.pythonrc
# Cache pip downloads, for faster installs
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

# Warn about using the global pip. This usually means we forgot to activate a
# virtualenv
system_pip=`which pip`
last_pip_time=0
pip_cooldown=300 # five minutes
function pip() {
	current_pip=`which pip`
	if [[ "$current_pip" == "$system_pip" ]] ; then
		current_time="$( date +%s )"
		if [[ "$(( $last_pip_time + $pip_cooldown ))" -le $current_time ]] ; then
			echo "You are using the system-wide pip."
			read -r -p "Are you sure you want to do this? [y/N] " response
		else
			response="y"
		fi

		case $response in
			[yY])
				$current_pip $@
				last_pip_time=$current_time
				;;
			*) ;;
		esac
	else
		$current_pip $@
	fi
}

function mkvenv() {
	virtualenv venv
	++venv
}


# Virtual environment helpers
# ---------------------------
# Quickly activate a venv in a standard location
function ++venv() {
	base="${1:-.}"
	locations=( 'venv' '.virthualenv' )
	paths=( "$base" "$base/.." )

	for path in "${paths[@]}" ; do
		for location in "${locations[@]}" ; do
			if [[ -d $path/$location ]] ; then
				source $path/$location/bin/activate
				return 0
			fi
		done
	done

	echo 'Could not find venv to activate' >&2
	return 1
}
function --venv() {
	deactivate
}


if [[ -e ~/.bashrc.local ]] ; then
	source ~/.bashrc.local
fi
