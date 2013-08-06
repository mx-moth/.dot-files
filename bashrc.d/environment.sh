# Some environment configuration
# ------------------------------

# Thats where I live!
export TZ='Australia/Hobart'

# Yay vim
export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'

# less: Quit if little text, Colours, fold, do not clear screen
export LESS='FRSX'

# Dont grep .svn folders.
export GREP_OPTIONS="--exclude-dir=\.svn"

# Add .ctp and .coffee files to ack, use less as pager
export ACK_OPTIONS="--pager=less --type-add php=.ctp --type-add js=.coffee"
