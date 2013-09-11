# Handy alias' and functions for doing all sorts of shit.
# If a family of functions/alias' arises, they are put in a separate file.
# This is the catch-all misc section.

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

alias command?="command -pv &>/dev/null"

# Shortcut for launching `dolphin` in the current directory
alias eeee='sequester dolphin "$( pwd )" &>/dev/null'

# Quick directory traversal
alias ..='cd ..'

# alias ::='cd ../../'
for i in $( seq 2 10 ) ; do
	colon=''
	dots=''

	for a in $( seq 1 "$i" ) ; do
		colon="$colon:"
		dots="$dots../"
	done

	eval "alias $colon='cd $dots'"
done


# Handy functions
# ---------------

# Opens all matching files in vim, searching via ack-grep
function ack-edit() {
	ack-grep -l --print0 "$@" | xargs -0 $SHELL -c 'vim -p "$@" < /dev/tty'
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
	path=$( readlink -e ${1:-$( pwd )} )
	paths=("$path")
	while [[ $path != '/' ]] ; do
		path=$( dirname "$path" )
		paths+=("$path")
	done

	nullinate "${paths[@]}" | xargs -0 ls -ld
}

# Launch a program, ignoring stdin, stdout, stderr
# eg: `sequester noisy-gui-program`
function sequester() {
	nohup "$@" &>/dev/null &
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


# Print out all the 256 console colours. Useful when designing colour schemes
# for vim/bash/tmux/etc.
function aa_256 () {
	local base='10'
	if [[ $# -gt 0 ]] ; then
		base=$1
	fi

	local prefix=''
	local format=''
	case "$base" in
		"oct") prefix="0" ; format="%o"  ;;
		"dec") prefix="" ; format="%d" ;;
		"hex") prefix="0x" ; format="%x"  ;;
	esac

	local padding=6

	local columns=8
	local rows=$(( 256 / $columns ))

	local reset=$( tput op )
	local fill=$( printf %$(( ( $COLUMNS / $columns ) - $padding ))s )

	local colour=''
	local num=''
	local code=''
	local row=''
	local column=''

	num_format="%s${format} "
	padded_num_format="%${padding}s"
	colour_block="${fill// /=}$reset"

	for row in $( seq 0 "$rows" ) ; do
		for column in $( seq 0 $(( columns - 1 )) ) ; do
			colour=$(( $row + $column * $rows ))
			num="$( printf "${num_format}" "${prefix}" "${colour}" )"
			code="$( printf "${padded_num_format}" "${num}" )"
			echo -en "$code$( tput setaf $colour; tput setab $colour )$colour_block"
		done
		echo ''
	done
}

# Quickly print out a QR code to the terminal. Useful for sending a link to
# your phone, etc
function qrc() {
	qrencode -t ANSI -o - "$@"
}

# elementIn "one" ("one" "two" "three")
elementIn () {
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	return 1
}

function trim() {
	sed 's/^\s+//;s/\s+$//'
}

function ppids() {
	pid=$$
	sep=$1
	path=""
	ignore=("tmux" "urxvt" "init" "sshd")

	while [ ${pid} -ne 0 ] ; do
		cmd=$( ps -p ${pid} -o comm= | trim )

		if ! elementIn "${cmd}" "${ignore[@]}" ; then
			if [ -z "${path}" ] ; then
				path="${cmd}"
			else
				path="${cmd}${sep}${path}"
			fi
		fi

		pid=$( ps -p ${pid} -o ppid= | trim )
	done

	echo ${path}
}
