# ~/.bashrc: executed by bash(1) for non-login shells.

# Path in the common things
PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/local/bin:/sbin:/bin"
LD_LIBRARY_PATH="/opt/local/lib:/usr/local/lib:/usr/lib"

# Cabal, for Haskell stuff
if [ -d $HOME/.cabal/bin ] ; then
	PATH="${HOME}/.cabal/bin:${PATH}"
fi

export PATH
export LD_LIBRARY_PATH

export TZ='Australia/Hobart'
export NODE_PATH=$HOME/local/node/lib/node_modules
umask 002

# Yay vim
export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'

# less: Quit if little text, Colours, fold, do not clear screen
export LESS='FRSX'

# Dont grep .svn folders.
export GREP_OPTIONS="--exclude-dir=\.svn"

# Add .ctp and .coffee files to ack, use less as pager
export ACK_OPTIONS="--pager=less --type-add php=.ctp --type-add js=.coffee"


# Search backwards and forwards through history easier
if echo "$-" | grep -q 'i' ; then
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
fi


# Source in extra scripts
# -----------------------

# This could be automated, but I prefer to opt-in to scripts that I want.
source "$HOME/.bashrc.d/functions.sh"
source "$HOME/.bashrc.d/prompt.sh"
source "$HOME/.bashrc.d/python.sh"
source "$HOME/.bashrc.d/venv.sh"

# Source in any local bashrc
if [[ -e ~/.bashrc.local ]] ; then
	source ~/.bashrc.local
fi
