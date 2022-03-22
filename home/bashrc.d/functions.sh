# Handy alias' and functions for doing all sorts of shit.
# If a family of functions/alias' arises, they are put in a separate file.
# This is the catch-all misc section.

# Program alias'
# --------------

# Human readable, coloured ls
alias ls='ls -hF --color=auto --group-directories-first'

# Copy to the clipboard, for ctrl+v pasting
alias xclip='xclip -selection "clipboard"'

# Copy to the clipboard, and also print to stdout. Useful in long pipes
alias pxclip='tee >( xclip -selection "clipboard" )'

# Do nothing
alias noop='echo -n ""'

# Use like `command > output-from-command-`datestamp``
alias datestamp='date "+%Y-%m-%d"'
alias datetimestamp='date "+%Y-%m-%d-%H%M"'

# Start a simple static file server
alias serve="python3 -m http.server"

# Source the system-wide bach completion scripts.
# These take a second or two to run, so you have to enable them yourself.
_enable_bash_completion() {
	source /usr/share/bash-completion/bash_completion
	source ~/.config/bash_completion
}
alias ++magic="_enable_bash_completion"

# Tail syslog. I was typing this quite a lot, so alias.
alias syslog="sudo tail -f /var/log/syslog"

# Prettify a json chunk
# eg `curl http://example.com/api/user/1.json | pretty-json`
alias pretty-json="python3 -mjson.tool"

alias command?="command -pv &>/dev/null"

# Print tab-delimited input as a table
# I always forget if it is column/columns, and the -t flag trips me up.
# eg: run-script | table
alias table='column -t -s"	"'

alias nv='nvim -p'

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


# Example: fsck -y /dev/sdb1 && yn
alias yeaaaaaaah='printf "\e[%dm%s\e[0m %s\n" 32 "•" "(⌐■_■)"'
alias flip-table='printf "\e[%dm%s\e[0m %s\n" 31 "•" "(╯°□°)╯ ┻━┻"'
alias yn='yeaaaaaaah || flip-table'

alias ssh-add-all='ssh-add ~/.ssh/keys/*id_rsa'


function tmuxs {
	if [[ -z "$TMUX" ]] ; then
		tmux new-session -As "$@"
	else
		tmux switch-client -t "$@"
	fi
}

function _tmux_sanitise_name {
	tr -s '.' '-' | sed 's/^-|-$//'
}

function tmuxd {
	if [[ $# -gt 0 ]] ; then
		local dir=$( realpath -s "$1" )
	else
		local dir=$( pwd )
	fi
	local session_name=$( basename "$dir" | _tmux_sanitise_name )
	if [[ -z "$TMUX" ]] ; then
		tmuxs "$session_name" -c "$dir"
	else
		if ! tmux has-session -t="$session_name" 2>/dev/null ; then
			TMUX= tmux new-session -ds "$session_name" -c "$dir"
		fi
		tmux switch-client -t "$session_name"
	fi
}
++tmux() { tmuxd "$@" ; }


# Handy functions
# ---------------

# Trim whitespace from either end of stdin
function trim() {
	sed -e 's/^\\s\\+//;s/\\s\\+$//'
}

# Opens all matching files in vim, searching via ack-grep
alias ack-edit=_ack_edit
function _ack_edit() {
	ack-grep -l --print0 "$@" | xargs -0 $SHELL -c '$EDITOR -p "$@" < /dev/tty' ''
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
function _ls_parents() {
	local single="$( [[ $# -ge 2 ]] ; echo $? )"
	local args
	if [[ "$#" -eq 0 ]] ; then
		single="true"
		args=( "$( pwd )" )
	else
		single=$( [[ "$#" -eq 1 ]] && echo "true" || echo "false" )
		args=( "$@" )
	fi

	local path
	for arg in "${args[@]}" ; do
		path="$arg"
		local paths=( "$path" )

		# Find all the parents, up to the root directory
		while [[ "${path}" != '/' ]] ; do
			path=$( dirname "$path" )
			# prepend to the list, so items are listed from root to leaf
			paths=( "$path" "${paths[@]}" )
		done

		if ! "$single" ; then
			# Print out the directory being listed.
			# Use `ls` so the path gets coloured and shell-escaped
			ls -d "${arg%%/}"
		fi

		# List all the parents
		ls --sort=none --directory -l "${paths[@]}"
	done
}
alias ls-parents="_ls_parents"

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

	local columns=8
	if [[ $# -gt 1 ]] ; then
		columns=$2
	fi

	local prefix=''
	local format=''
	case "$base" in
		"oct") prefix="0" ; format="%o"  ;;
		"dec") prefix="" ; format="%d" ;;
		"hex") prefix="0x" ; format="%x"  ;;
	esac

	local padding=6

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
	for e in "${@:2}" ; do
		[ "$e" = "$1" ] && return 0
	done
	return 1
}


function ppids() {
	pid=$$
	sep=$1
	path=""

	while [ ${pid} -ne 0 ] ; do
		cmd=$( ps -p ${pid} -o comm= | trim )

		if ! elementIn "${cmd}" "${@:2}" ; then
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

# Draw a ========== line across your terminal to mark something
function hr () {
	char="${1:-─}"
	width=$( tput cols )
	for i in $( seq $width ) ; do
		echo -n "$char"
	done
	echo
}

# Turn off all screensavers, dpms, x-blanking, suspending, etc
alias movie-time=_movie_time
function _movie_time() {
	xset s off
	xset s noblank
	xset -dpms
}

# Print the ips of all network interfaces
function ips() {
	local interfaces=()
	local current_interface=""
	local active=false
	local nl=$'\n'
	local IFS="$nl"
	local line
	for line in $( ip addr ) ; do
		if [[ "$line" == "    "* ]] ; then
			if [[ "$line" == "    inet"* ]] ; then
				ip=$( sed 's!^    inet6\? \(.*\)/.*!\1!' <<< "$line" ) ;
				interfaces+=("$current_interface $ip")
			fi
		else
			current_interface=$( cut -d' ' -f2 <<< "$line" )
		fi
	done

	for interface in "${interfaces[@]}" ; do echo "$interface" ; done | column -t
}

# Start mutt, syncing with offlineimap before and after mutt runs
function mutt() {
	offlineimap -oqu Quiet &>>~/mutt.log &
	/usr/bin/mutt
	offlineimap -oqu Quiet &>>~/mutt.log &
}

# Make a random long password without too many awkward symbols
function mkpasswd() {
	cat /dev/urandom | base64 | head -c${1:-30}
	echo
}

# Complete tmux session names for `tmuxs` alias
function _tmux_sessions {
	local IFS=$'\n'
	local cur="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=()
	COMPREPLY+=($(compgen -W "$( tmux list-sessions -F '#S' 2>/dev/null )" -- "${cur}" ))
}
complete -o filenames -F _tmux_sessions tmuxs

# Print out a list of unattached tmux sessions, if you are not already in one.
alias check-for-tmux=_check_for_tmux
function _check_for_tmux {
	if [[ -n "$TMUX" ]] ; then return ; fi
	if ! which tmux &>/dev/null ; then return ; fi

	local sessions=$( tmux -q list-sessions 2>/dev/null | grep -v '(attached)' )
	local code=$!
	if [[ "$code" -ne 0 ]] ; then return ; fi
	if [[ -z "$sessions" ]] ; then return ; fi

	printf "\e[1m%s\e[0m\n" "Detached tmux sessions:"
	echo "$sessions"
}

function _pretty_xml() {
	local readonly imports="import sys; import xml.dom.minidom as x"
	local readonly script="print(x.parse(sys.stdin).toprettyxml())"
	python3 -c "$imports; $script"
}
alias pretty-xml="_pretty_xml"

function fix-bandcamp-download() {
	local dir=${1:-.}
	rename 's/^.* - (\d\d) (.*\.[a-zA-Z0-9]+)$/$1 - $2/' "${dir}"/*
}

# Rename a bunch of files using a sed substitution. The first argument should
# be a sed 's/re/sub/' extended regexp pattern. The remaining arguments are
# files to be renamed.
#
#     rename 's/foo/bar/' *.txt
function rename {
	if [[ $# -lt 2 || $# -eq 1 && ( "$1" == "-h" || "$1" == "--help" ) ]] ; then
		cat <<-USAGE
		Usage:
		    rename <sed-pattern> <files...>

		Renames a bunch of files based upon a sed pattern

		    rename 's/foo/bar/' *.txt
		USAGE
	fi
	local pattern="$1"
	shift
	local srcs=( "$@" )

	for src in "${srcs[@]}" ; do
		dest="$( echo "$src" | sed --regexp-extended "$pattern" )"
		if [[ "$src" != "$dest" ]] ; then
			printf '"%s" -> "%s"\n' "$src" "$dest"
			mv \
				--no-clobber \
				--no-target-directory \
				"$src" "$dest"
		fi
	done
}
