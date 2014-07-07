#!/bin/bash
# i3 thread: https://faq.i3wm.org/question/150/how-to-launch-a-terminal-from-here/?answer=152#post-id-152


function cwdterm() {
	CMD=${1:-x-terminal-emulator}
	shift 1

	CWD=''
	# Get window ID
	ID=$(xdpyinfo | grep focus | cut -f4 -d " ")

	# Get PID of process whose window this is
	PID=$(xprop -id $ID | grep -m 1 PID | cut -d " " -f 3)

	# Get last child process (shell, vim, etc)
	if [ -n "$PID" ]; then
		TREE=$(pstree -lpnA "$PID" | tail -n 1)
		PID=$(echo "$TREE" | awk -F'---' '{print $NF}' | sed -re 's/[^0-9]//g')

		# If we find the working directory, run the command in that directory
		if [ -e "/proc/$PID/cwd" ]; then
			CWD=$(readlink "/proc/$PID/cwd")
		fi
	fi

	if [ -n "$CWD" ] && [ "$CWD" != "/" ]; then
		cd "$CWD" && exec "$CMD" "$@" &
	else
		cd ~ && exec "$CMD" "$@" &
	fi
}

cwdterm "$@" 1>/dev/null 2>/dev/null </dev/null &
