# -*- coding: utf-8 -*-
"""
To install:

    sudo apt-get install libiw-dev
    pip3 install basiciw netifaces-py3

"""

import subprocess

from i3pystatus import Status

status = Status(standalone=True)

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
                format="%Y-%m-%d %H:%M:%S",)

# The battery monitor has many formatting options, see README for details

status.register("battery",
                battery_ident="BAT1",
                format="{status} {percentage:.0f}% {consumption:.1f}W {remaining:%E%h:%M}",
                alert=False,
                interval=10,
                status={
                    "DIS": "⚡",
                    "CHR": "±",
                    "FULL": "±",
                },)

status.register("network",
                interface="eth0",
                format_up="E: {v4cidr}",
                format_down="",
                color_up="#ffffff")

status.register("wireless",
                interface="wlan0",
                format_up="W: {essid} {v4cidr}",
                format_down="",
                color_up="#ffffff")

status.register("mpd",
                format="{status} {title} - {album} - {artist}",
                status={
                    "pause": "▷",
                    "play": "▶",
                    "stop": "◾",
                },)

status.run()
