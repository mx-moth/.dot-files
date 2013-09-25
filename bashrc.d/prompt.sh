# Set up the bash prompt nicely
# -----------------------------

# Build up PS1
export VIRTUAL_ENV_DISABLE_PROMPT=true
export VCPROMPT_STAGED='+'
export VCPROMPT_MODIFIED='*'
export VCPROMPT_UNTRACKED='?'

sep="╱"
list=$( ppids  "$sep" )
if ! [ -z "$LC_SSH_PPLIST" ] ; then
	list="${LC_SSH_PPLIST}$sep$list"
fi
if [ "$list" != "$( basename $SHELL )" ] ; then
	export _PARENT_PROCESS_LIST="$list"
	export LC_SSH_PPLIST="$list$sepssh@$( hostname )"
fi

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
		export PS1='\n[ \[\e[38;5;40m\]\u\[\e[0m\] at \[\e[38;5;13m\]\h\[\e[0m\]$( if [[ x"$VIRTUAL_ENV" != x ]] ; then dir=$( basename $( echo -n "$VIRTUAL_ENV" | sed -e"s/\/venv\/\?$//" ) ) ; echo " working on \[\e[38;5;51m\]$dir\[\e[0m\]" ; fi ) in \[\e[38;5;202m\]\w\[\e[0m\] $( [ -z "$_PARENT_PROCESS_LIST" ] && echo "running \[\e[38;5;93m\]$_PARENT_PROCESS_LIST\[\e[0m\] " )]\n\$ '
		;;
	2|high|full)
		level=2
		export PS1='\n[ \[\e[38;5;40m\]\u\[\e[0m\] at \[\e[38;5;13m\]\h\[\e[0m\]$( ${VCPROMPT} -f " on \[\e[38;5;130m\]%n\[\e[0m\]:\[\e[38;5;214m\]%b\[\e[0m\]\[\e[38;5;239m\] [\[\e[0m\]\[\e[31m\]%m\[\e[0m\]\[\e[38;5;33m\]%u\[\e[0m\]\[\e[38;5;239m\]]\[\e[0m\]" --format-git " on \[\e[38;5;130m\]%n\[\e[0m\]:\[\e[38;5;214m\]%b\[\e[0m\]\[\e[38;5;239m\] [\[\e[0m\]\[\e[32m\]%a\[\e[0m\]\[\e[31m\]%m\[\e[0m\]\[\e[38;5;33m\]%u\[\e[0m\]\[\e[38;5;239m\]]\[\e[0m\]")$( if [[ x"$VIRTUAL_ENV" != x ]] ; then dir=$( basename $( echo -n "$VIRTUAL_ENV" | sed -e"s/\/venv\/\?$//" ) ) ; echo " working on \[\e[38;5;51m\]$dir\[\e[0m\]" ; fi ) in \[\e[38;5;202m\]\w\[\e[0m\] $( [ -z "$_PARENT_PROCESS_LIST" ] && echo "running \[\e[38;5;93m\]$_PARENT_PROCESS_LIST\[\e[0m\] " )]\n\$ '
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

prompt-level "${PROMPT_LEVEL:-1}"
