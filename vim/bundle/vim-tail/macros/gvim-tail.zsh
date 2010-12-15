#!/bin/zsh
#------------------------------------------------------------------------------
#  Description: Works like "tail -f" .
#          $Id: gvim-tail.zsh 29 2007-09-24 11:40:36Z krischik@users.sourceforge.net $
#   Maintainer: Martin Krischik (krischik@users.sourceforge.net)
#               Jason Heddings (vim at heddway dot com)
#      $Author: krischik@users.sourceforge.net $
#        $Date: 2007-09-24 21:40:36 +1000 (Mon, 24 Sep 2007) $
#      Version: 3.0
#    $Revision: 29 $
#     $HeadURL: http://vim-scripts.googlecode.com/svn/trunk/1714%20Tail%20Bundle/macros/gvim-tail.zsh $
#      History: 22.09.2006 MK Improve for vim 7.0
#               15.10.2006 MK Bram's suggestion for runtime integration
#		05.11.2006 MK Bram suggested to save on spaces
#               07.11.2006 MK Tabbed Tail
#               31.12.2006 MK Bug fixing
#               01.01.2007 MK Bug fixing
#               17.11.2007 Now with Startup Scripts.
#    Help Page: tail.txt
#------------------------------------------------------------------------------

setopt X_Trace;

for I ; do
    if
        gvim --servername "tail" --remote-send ":TabTail ${I}<CR>";
    then
        ; # do nothing
    else
        gvim --servername "tail" --remote-silent +":TabTail %<CR>" "${I}"
    fi
done;

#------------------------------------------------------------------------------
#   Copyright (C) 2006  Martin Krischik
#
#   Vim is Charityware - see ":help license" or uganda.txt for licence details.
#------------------------------------------------------------------------------
#vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab :
#vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
