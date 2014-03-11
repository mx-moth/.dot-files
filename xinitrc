#!/bin/bash

function cmd? {
	command -V "$1" &>/dev/null && "$@"
}

# Start ssh/gpg daemons for the whole session
eval $( ssh-agent )
eval $( gpg-agent --daemon --sh --write-env-file="~/.gnupg/gpg-agent-info-jaws"; echo "GPG_AGENT_PID=$?" )

# No bell, fast keyboard repeat rate
xset r rate 160
xset b off

# Xresources
xrdb $HOME/.Xresources
[[ -e "$HOME/.Xresources.local" ]] && xrdb -merge /home/tim/.Xresources.local

# Source local stuff (xrandr screens, etc)
cmd? ~/.xinitrc.local

# Window manager
exec ck-launch-session i3

# Kill the ssh/gpg agents
kill $SSH_AGENT_PID
kill $GPG_AGENT_PID
