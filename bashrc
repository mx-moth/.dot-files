# ~/.bashrc: executed by bash(1) for non-login shells.


# Set up paths
# ------------

# Path in the common things
PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/local/bin:/sbin:/bin"
LD_LIBRARY_PATH="/opt/local/lib:/usr/local/lib:/usr/lib"

# Cabal, for Haskell stuff
if [ -d $HOME/.cabal/bin ] ; then
	PATH="${HOME}/.cabal/bin:${PATH}"
fi

export PATH
export LD_LIBRARY_PATH
export COMP_WORDS="${COMP_WORDS/:/}"


# Some bash configuration
# -----------------------

# Make things group readable/writable by default
umask 002

# Search backwards and forwards through history easier
if echo "$-" | grep -q 'i' ; then
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
fi


# Source in extra scripts
# -----------------------

# This could be automated, but I prefer to opt-in to scripts that I want.
source "$HOME/.bashrc.d/environment.sh"
source "$HOME/.bashrc.d/functions.sh"
source "$HOME/.bashrc.d/prompt.sh"
source "$HOME/.bashrc.d/python.sh"
source "$HOME/.bashrc.d/venv.sh"
source "$HOME/.bashrc.d/colours.sh"
source "$HOME/.bashrc.d/installers.sh"

# Source in any local bashrc
if [[ -e ~/.bashrc.local ]] ; then
	source ~/.bashrc.local
fi
