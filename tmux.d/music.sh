#!/bin/bash

source ~/.bashrc.d/colours.sh

MPD_HOST=$( tmux show-environment 'MPD_HOST' )
if $! ; then
	MPC="mpc --host=${MPD_HOST#MPD_HOST=}"
else
	MPC="mpc"
fi

function exists? {
	command -v "$@" 1>/dev/null 2>/dev/null
}

exists? mpc || exit 0

out=$( $MPC )

[[ $( echo "$out" | wc -l ) -eq 1 ]] && exit 0

song=$( $MPC current --format='[%track%[-%disc%]: ][%title%[ - %album%][ - %artist%]' )
play_info=$( echo "$out" | head -n 2 | tail -n 1)
mpd_info=$( echo "$out" | tail -n 1)

case "${play_info%% *}" in
	'[playing]') left="❨"; right="❩" ;;
	'[paused]')  left=" "; right=" " ;;
esac

echo -n "#[bg=colour${TMUX_INACTIVE},fg=colour16]"
echo -n "${left}${song}${right}"
echo -n "#[bg=colour${TMUX_FILL},fg=colour16] "
