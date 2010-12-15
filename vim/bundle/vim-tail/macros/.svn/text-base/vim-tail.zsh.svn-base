#!/bin/zsh
#------------------------------------------------------------------------------
#  Description: Works like "tail -f" .
#          $Id$
#   Maintainer: Martin Krischik (krischik@users.sourceforge.net)
#      $Author$
#        $Date$
#      Version: 3.0
#    $Revision$
#     $HeadURL$
#      History: 17.11.2007 Now with Startup Scripts.
#    Help Page: tail.txt
#------------------------------------------------------------------------------

setopt No_X_Trace;

for I ; do
    if
        gvim --servername "tail" --remote-send ":TabTail ${I}<CR>";
    then
        ; # do nothing
    else
        gvim --servername "tail" --remote-silent +":TabTail %<CR>" "${I}"
    fi
    sleep 1;
done;

#------------------------------------------------------------------------------
#   Copyright (C) 2006  Martin Krischik
#
#   Vim is Charityware - see ":help license" or uganda.txt for licence details.
#------------------------------------------------------------------------------
#vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
#vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
