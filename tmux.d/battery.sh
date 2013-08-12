#!/bin/bash

set -e

BAT_PATH=/sys/class/power_supply/BAT1
BASE_COLOUR="#[fg=colour${TMUX_ACTIVE},bg=black]"

ON_BAT=$( [[ $( cat "${BAT_PATH}/status" ) == "Discharging" ]] && echo '1' || echo '0' )

echo -n "${BASE_COLOUR} "
[[ $ON_BAT == '1' ]] && echo -n '±' || echo -n '⚡'
echo -n " "

CAPACITY=`cat "${BAT_PATH}/capacity"`
CAPACITY_8=$(( $CAPACITY * 9 / 100 ))

BLOCKS=" ▁▂▃▄▅▆▇█"
echo -n "#[fg=green,bg=red]"
echo -n "${BLOCKS:$CAPACITY_8:1}"
echo -n "${BASE_COLOUR} "

if [[ $ON_BAT == '1' ]] ; then
	POWER_NOW=`cat "$BAT_PATH/power_now"`
	echo -n "$(( $POWER_NOW / (1024 ** 2) ))W "
fi

echo ''
