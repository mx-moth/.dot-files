#!/bin/bash

T="tmux"

opts=$( getopt -o t: -n 'activate-or-run-window.sh' -- "$@" )
eval set -- "$opts"

tmux_options=""
window_name=""
while true ; do
	case "$1" in
		-t) window_name="$2"; shift 2 ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done

# Attempt to activate the named window, else create it
if ! $T select-window -t "$window_name" ; then
	$T new-window -n "$window_name" "$@"
fi
