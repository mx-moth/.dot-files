# Set up the bash prompt nicely
# -----------------------------

if [ -z "$PS1" ] ; then return 0 ; fi

# Build up PS1
export VIRTUAL_ENV_DISABLE_PROMPT=true

function _hostname() {
	if command -v hostname &> /dev/null ; then
		hostname
	else
		cat /proc/sys/kernel/hostname
	fi
}

if [[ -z "$PROMPT_ORIGIN" ]] ; then
	export PROMPT_ORIGIN="${LC_SSH_ORIGIN}»"
	export LC_SSH_ORIGIN="${LC_SSH_ORIGIN}$( _hostname )»"
fi


# Set PS1. Levels are:
# * 0, low, minimal: Minimal PS1. Useful for slow systems, or systems with
#   basic shells
# * 1, medium, normal: Prompt showing coloured information, including
#   virtualenv status
# * 2, high, full: Prompt showing coloured information, including virtualenv
function _prompt_color() {
	local color="$1"
	local text="$2"
	printf '\[\e[%sm\]%s\[\e[0m\]' "$color" "$text"
}

alias prompt-level=_prompt_level
function _prompt_level() {
	local level=$1
	case $level in
	0|off|none)
		level=0
		export PS1='\$ '
		;;
	1|minimal)
		level=1
		local user="$( _prompt_color '32' '\u' )"
		local host="@$( _prompt_color '35' "${PROMPT_ORIGIN:0:-1}" )$( _prompt_color '38;5;13' '\h' )"
		local path=":$( _prompt_color '33' '\w' )"
		export PS1="[$user$host$path] \\$ "
		;;
	2|normal)
		level=2
		local user="$( _prompt_color '38;5;40' '\u' )"
		local host="@$( _prompt_color '38;5;246' "${PROMPT_ORIGIN:0:-1}" )$( _prompt_color '38;5;13' '\h' )"
		local path=":$( _prompt_color '38;5;202' '\w' )"
		local venv_content="⚒$( _prompt_color "38;5;51" '${VENV_DIR##*/}' )"
		local venv='$( if [[ -n "$VENV_DIR" ]] ; then echo "'"${venv_content}"'" ; fi )'
		export PS1='\n['"$user$host$venv$path"']\n\$ '
		;;
	*)
		echo "Unknown prompt-level: $1"
		return 1
	esac

	export PROMPT_LEVEL=$level
}

function _shift_prompt_level() {
	local level=$(( $PROMPT_LEVEL + $1 ))
	_prompt_level $level
}

alias -- ++prompt="_shift_prompt_level 1"
alias -- --prompt="_shift_prompt_level -1"

if [[ "$(tty)" == '/dev/tty'[0-9]* ]] ; then
	_prompt_level 1
else
	_prompt_level "${PROMPT_LEVEL:-2}"
fi
