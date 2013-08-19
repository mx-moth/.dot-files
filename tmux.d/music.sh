#!/bin/bash

source ~/.bashrc.d/colours.sh

function exists? {
	command -v "$@" 1>/dev/null 2>/dev/null
}

exists? mpc || exit 0

out=$( mpc )

[[ $( echo "$out" | wc -l ) -eq 1 ]] && exit 0

song=$( echo "$out" | head -n 1 )
play_info=$( echo "$out" | head -n 2 | tail -n 1)
mpd_info=$( echo "$out" | tail -n 1)

case $( echo "$play_info" | cut -d' ' -f1 ) in
	'[playing]') left="❨"; right="❩" ;;
	'[paused]')  left=" "; right=" " ;;
esac

echo -n "#[bg=colour${TMUX_INACTIVE},fg=colour16]"
echo -n "${left}${song}${right}"
echo -n "#[bg=colour${TMUX_FILL},fg=colour16] "
