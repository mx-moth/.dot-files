# tmux helpers

function _tmux_sanitise_name {
	tr -s '.' '-' | sed 's/^-|-$//'
}

# Print out a list of unattached tmux sessions, if you are not already in one.
function _check_for_tmux {
	if [[ -v "TMUX" ]] ; then return ; fi
	if ! which tmux &>/dev/null ; then return ; fi

	local sessions=$( tmux -q list-sessions 2>/dev/null | grep -v '(attached)' )
	local code=$!
	if [[ "$code" -ne 0 ]] ; then return ; fi
	if [[ -z "$sessions" ]] ; then return ; fi

	printf "\e[1m%s\e[0m\n" "Detached tmux sessions:"
	echo "$sessions"
}

# Open or switch to a named tmux session
function tmuxs {
	if [[ -v "TMUX" ]] ; then
		tmux switch-client -t "$@"
	else
		tmux new-session -As "$@"
	fi
}

# Open or switch to a tmux session for the current (or given) directory.
# The session is named after the directory name.
# Usage: `tmuxd path/to/project`
alias ++tmux='tmuxd'
function tmuxd {
	if [[ $# -gt 0 ]] ; then
		local dir=$( realpath -s "$1" )
	else
		local dir=$( pwd )
	fi
	local session_name=$( basename "$dir" | _tmux_sanitise_name )
	if [[ -v "TMUX" ]] ; then
		if ! tmux has-session -t="$session_name" 2>/dev/null ; then
			TMUX= tmux new-session -ds "$session_name" -c "$dir"
		fi
		tmux switch-client -t "$session_name"
	else
		tmuxs "$session_name" -c "$dir"
	fi
}

# Complete tmux session names for `tmuxs` alias
function _tmux_sessions {
	local IFS=$'\n'
	local cur="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=()
	COMPREPLY+=($(compgen -W "$( tmux list-sessions -F '#S' 2>/dev/null )" -- "${cur}" ))
}
complete -F _tmux_sessions tmuxs
