#!/bin/bash

set -e

T="tmux -q"
VERSION=`tmux -V | cut -d' ' -f2`
SESSION_NAME="$1"

function is_version() {
	test_version=$1
	actual_version=$VERSION

	best_version=$( sort -r <( echo "$test_version" ; echo "$actual_version" ) | head -n 1 )

	[[ "$best_version" == "$actual_version" ]]
}

if is_version "1.7" ; then
	SET_OPTION="set-option -gqs"
else
	SET_OPTION="set-option -gs"
fi
# Control-q for prefix. Bugger all uses it, and it is close
$T $SET_OPTION prefix "C-q"

# Using vim + tmux requires instant escape codes
$T $SET_OPTION escape-time 0

$T $SET_OPTION allow-rename off
$T $SET_OPTION display-time 3000

# Status bar style
# The coloura scheme is purple:
# * colour219 (bright) for focused items
# * colour125 (mid) for other items
# * colour053 (dark) for spacing/padding
$T $SET_OPTION status-bg colour$TMUX_FILL
is_version "1.7" && $T $SET_OPTION status-position top

$T $SET_OPTION status-left ''
$T $SET_OPTION status-left-fg colour$TMUX_ACTIVE
$T $SET_OPTION status-left-bg black

$T $SET_OPTION status-right '#(~/.tmux.d/music.sh)#(~/.tmux.d/battery.sh )'
$T $SET_OPTION status-right-length 100

$T $SET_OPTION status-interval 5

$T $SET_OPTION pane-active-border-fg colour$TMUX_ACTIVE
$T $SET_OPTION pane-border-fg colour$TMUX_FILL

$T $SET_OPTION window-status-current-fg black
$T $SET_OPTION window-status-current-bg colour$TMUX_ACTIVE
$T $SET_OPTION window-status-current-format "❨#I│#W❩"

$T $SET_OPTION window-status-fg black
$T $SET_OPTION window-status-bg colour$TMUX_INACTIVE
$T $SET_OPTION window-status-format " #I│#W "

$T $SET_OPTION message-command-fg colour$TMUX_ACTIVE
$T $SET_OPTION message-command-bg black
$T $SET_OPTION message-fg black
$T $SET_OPTION message-bg colour$TMUX_ACTIVE


### tmux bindings


## Window management

# PREFIX C-Q: Last window
$T bind '`' last-window

# PREFIX S-left/S-right: Switch windows using 
$T bind -n S-left prev
$T bind -n S-right next

# PREFIX S-left/S-right: Move windows
$T bind -r S-left  swap-window -t -1
$T bind -r S-right swap-window -t +1

# PREFIX ^C: Create named window
$T bind-key ^C command-prompt -p 'name:' "new-window -n '%1'"


## Pane management

# Split panes using | and -
$T bind '\' split-window -h
$T bind '|' split-window -h
$T bind '-' split-window -v
$T bind '_' split-window -v

# Remove default split pane binding since we replaced it
$T unbind %
$T unbind '"'

# Prefix C-Q for last pane
$T bind ^Q last-pane

# Disable repeatable keys when switching panes
$T bind-key Up    select-pane -U
$T bind-key Down  select-pane -D
$T bind-key Left  select-pane -L
$T bind-key Right select-pane -R

# Select panes with S-M-arrows
$T bind-key -n S-M-Up    select-pane -U
$T bind-key -n S-M-Down  select-pane -D
$T bind-key -n S-M-Left  select-pane -L
$T bind-key -n S-M-Right select-pane -R


## Misc bindings

# Reload this conf file
$T bind ^r run-shell "~/.tmux.d/conf.sh 1>/dev/null"


### Quick program launching

# PREFIX ^S: config panel
$T bind-key ^s run-shell '~/.tmux.d/activate-or-new-window.sh -t "⚙"'

# PREFIX ^i: IRC
$T bind-key ^i run-shell '~/.tmux.d/activate-or-new-window.sh -t "irc" "weechat-curses"'

# PREFIX S: SSH to a host
$T bind-key S command-prompt -p 'host:' "new-window -n '»%1' 'ssh %1'"

# PREFIX ^E: Edit a file
$T bind-key ^E command-prompt -p 'file:' 'new-window -n "%1" "vim -p %1"'

# PREFIX S-_: Open small terminal below or above
$T bind-key "_" split-window -vp 20
$T bind-key "+" new-window -dn '__split__' '\;' move-pane -vbp 80 -s ':__split__.'

# PREFIX S->: Open small terminal to the right or left
$T bind-key ">" split-window -hp 30
$T bind-key "<" new-window -dn '__split__' '\;' move-pane -hbp 70 -s ':__split__.'

$T bind-key C-y run-shell "tmux save-buffer - | DISPLAY=${DISPLAY:-:0} xclip -i -selection clipboard"
$T bind-key C-p run-shell "xclip -i -selection clipboard | tmux load-buffer -" '\;' paste-buffer



# Source local tmux commands
if [[ -e ~/.tmux.conf.local.sh ]] ; then
	$HOME/.tmux.conf.local.sh
fi
