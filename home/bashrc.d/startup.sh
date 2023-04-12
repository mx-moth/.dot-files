if [[ $- == *i* ]] ; then
	# Unset TMOUT if TMOUT_BUST is set in ~/.bashrc.local
	if [[ -v TMOUT_BUST ]] ; then
		_tmout_bust
		unset TMOUT_BUST
	fi
	# Print a list of detached tmux sessions
	check-for-tmux
	++magic
fi
