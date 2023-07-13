# Handy aliases and functions for doing all sorts of shit.
# If a family of functions/aliases arises, they are put in a separate file.
# This is the catch-all misc section.

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

# Prettify a JSON chunk
# eg `curl https://example.com/api/user/1.json | pretty-json`
alias pretty-json="python3 -mjson.tool"

# Does a command exist
alias command?="command -pv &>/dev/null"

# Print tab-delimited input as a table
# I always forget if it is column/columns, and the -t flag trips me up.
# eg: run-script | table
alias table='column -t -s"	"'

# Start neovim with tabs
alias nv='nvim -p'

# Quick upwards directory traversal
# `..` - one level
# `::` - two levels
# `:::` - three levels
# etc
alias ..='cd ..'
colon=':'
dots='../'
for i in $( seq 2 10 ) ; do
	colon="${colon}:"
	dots="${dots}../"
	eval "alias $colon='cd $dots'"
done
unset colon dots


# Show whether the previous command succeeded or not.
# Example: fsck -y /dev/sdb1 && yn
alias yeaaaaaaah='printf "\e[%dm%s\e[0m %s\n" 32 "•" "(⌐■_■)"'
alias flip-table='printf "\e[%dm%s\e[0m %s\n" 31 "•" "(╯°□°)╯ ┻━┻"'
alias yn='yeaaaaaaah || flip-table'


# Trim whitespace from either end of stdin
function trim() {
	sed -e 's/^\\s\\+//;s/\\s\\+$//'
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


# Launch a program in the background, ignoring stdin, stdout, stderr.
# eg: `sequester noisy-gui-program`
function sequester() {
	nohup "$@" &>/dev/null &
}
complete -A command sequester


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


# Make a directory and cd in to it.
function mkcd() {
	mkdir -p "$1" && cd "$1"
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
	sep=${1:-$'\n'}
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

	echo "${path}"
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
				ip=$( sed 's!^    \(inet6\?\) \(.*\)/.*!\1\t\2!' <<< "$line" ) ;
				interfaces+=("$current_interface	$ip")
			fi
		else
			current_interface=$( cut -d' ' -f2 <<< "$line" )
			current_interface="${current_interface%:}"
		fi
	done

	(
		printf '%s\t%s\t%s\n' 'NAME' 'KIND' 'IP ADDRESS'
		IFS="$nl" echo "${interfaces[*]}" | sort -n
	) | column -s'	' -t -c "$COLUMNS"
}


# Make a random long password without too many awkward symbols
function mkpasswd() {
	cat /dev/urandom | base64 | head -c${1:-30}
	echo
}


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

# Create a named file with specific permissions.
# Creation is atomic - either the file is created with the permissions as set,
# or the call fails.
# The call fails if the file already exists,
# or if the file was unable to be created with the requested permissions.
#
# Usage:
#
#     atomic-create-file <path> <mode>
#
#     <path> is the path to the file to create,
#     <mode> is the symbolic permissions for the new file
#
# To create a file securely that is only writeable by the current user:
#
#     atomic-create-file /path/to/file u=rw
alias atomic-create-file="_atomic_create_file"
function _atomic_create_file() {
	local path="$1"
	local umask="${2:-`umask`}"
	(
		set -o noclobber
		umask "$umask"
		{ > "$path" ; } &> /dev/null
	)
}

# Export / import some session environment variables.
# Useful for importing SSH_AUTH_SOCKET, X11 display variables, etc
# in to long running tmux sessions after SSHing back in to a server.
#
# Usage:
#
#     $ ssh my-server
#     $ export-session-vars
#     $ tmuxs some-session
#     $ import-session-vars
_SESSION_FILE="$HOME/.session.env"
alias export-session-vars="_export_session_vars"
function _export_session_vars() {
	local var_names=( "${!SSH_@}" DISPLAY )
	local var_name

	rm -f "$_SESSION_FILE"
	_atomic_create_file "$_SESSION_FILE" "u=rw,g=,o=" || {
		echo "Could not securely create session file '$_SESSION_FILE'!" >&2
		return 1
	}

	echo "# Session environment variables" > $_SESSION_FILE
	for var_name in "${var_names[@]}" ; do
		echo "${!var_name@A}" >> $_SESSION_FILE
	done
}

# Dual of export-session-vars above
alias import-session-vars='source "$_SESSION_FILE"'


# If this is a login shell and TMOUT is set,
# `exec` a new login shell with TMOUT unset.
function _tmout_bust() {
	# If this is a login shell (i.e. we've just SSH'd in),
	# and TMOUT is non-zero, and the parent process is sshd,
	# attempt to start a new bash shell with TMOUT disabled.
	local _sentinel="TMOUT_SENTINEL"
	if shopt -q login_shell ; then
		# Check if TMOUT is non-zero and the parent process is sshd
		if [[
			# Check TMOUT is set and non-zero
			-v "TMOUT" && "$TMOUT" != 0
			# Check we're not in a recursive loop
			&& ! -v "${_sentinel}"
			# Check if the parent process is sshd
			&& "$( ps -o comm= -p "${PPID}" )" == "sshd"
		]] ; then
			# Disable TMOUT rubbish
			exec env TMOUT=0 "$_sentinel=1" bash -l
		fi
	fi
	unset "$_sentinel"
}
