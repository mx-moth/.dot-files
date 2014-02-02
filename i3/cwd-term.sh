#!/bin/bash
# i3 thread: https://faq.i3wm.org/question/150/how-to-launch-a-terminal-from-here/?answer=152#post-id-152

CMD=${1:-x-terminal-emulator}
CWD=''

truncate -s0 /tmp/cwd-term.log
function log {
	echo "$@" >> /tmp/cwd-term.log
}

# Get window ID
ID=$(xdpyinfo | grep focus | cut -f4 -d " ")
log "ID:" $ID

# Get PID of process whose window this is
PID=$(xprop -id $ID | grep -m 1 PID | cut -d " " -f 3)
log "PID:" $PID

# Get last child process (shell, vim, etc)
if [ -n "$PID" ]; then
  TREE=$(pstree -lpnA $PID | tail -n 1)
  PID=$(echo $TREE | awk -F'---' '{print $NF}' | sed -re 's/[^0-9]//g')
  log "TREE:" $TREE
  log "PID:" $PID

  # If we find the working directory, run the command in that directory
  if [ -e "/proc/$PID/cwd" ]; then
    log "Found /proc/$PID/cwd"
    CWD=$(readlink /proc/$PID/cwd)
    log "CWD:" $CWD
  fi
fi

if [ -n "$CWD" ]; then
  cd $CWD && exec $CMD
else
  exec $CMD
fi
