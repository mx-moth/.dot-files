# This file is sourced last.
# These commands might have side effects in the shell that is being started,
# such as printing things to the console.

# Print a list of detached tmux sessions
if [[ "$SHLVL" -eq 1 ]] ; then
	_check_for_tmux
fi

# Source bash completions
++magic

if [[ -e "$HOME/.bashrc.startup" ]] ; then
	source "$HOME/.bashrc.startup"
fi
