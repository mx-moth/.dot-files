#!/bin/bash

readonly VERSION="0.1"

cmd_for_usage() {
	echo "Usage: pass for pass-name"
}

cmd_for() {
	local path="$1"
	check_sneaky_paths "$path"

	passfile="$PREFIX/$path.gpg"
	if [[ ! -f "$passfile" ]] ; then
		die "$path is not in the password store"
	fi

	COMMAND="show"
	cmd_show "$path" | tail -n+2 | sed '/./,$!d'

	echo ""
	read -p "Press Enter to copy password"
	cmd_show -c "$path"
}

if [[ $# -ne 1 ]] ; then
	cmd_for_usage
	return 0
fi

cmd_for "$@"
