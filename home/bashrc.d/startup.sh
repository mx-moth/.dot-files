# Print a list of detached tmux sessions
if [[ $- == *i* ]] ; then
	check-for-tmux
	_ssh_agent
fi
