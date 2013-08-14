Getting `tmux`, `vim`, and your terminal emulator work together
===========================================================

This is mostly based on [this StackExchange answer](http://unix.stackexchange.com/a/34723).

Firstly, make sure you have a competent terminal emulator.
`Konsole`, `*rxvt`, and the like are competent. `Terminal.app` is not.

Your terminal emulator will probably set a `$TERM` variable.
This tells programs what control sequences the terminal will understand.
You should make sure this is set to `xterm-256color`.

Next, configure `tmux` by putting the following configuration lines at the
start of your `~/.tmux.conf`:

    set-option -g xterm-keys
    set-option -g default-terminal "screen-256color"

`tmux` will now respond correctly to xterm-style control sequences.
Additionally, it will set the `$TERM` variable to `screen-256color` in all shells it spawns,
overriding the previously set `xterm-256color`.
This lets `vim` et al know that they are running inside `tmux` or `screen`.

Finally, configure `vim` correctly.
Out of the box, `vim` responds to `xterm` style control sequences.
By setting `$TERM` to `screen-256color`, it no longer responds to them.
As `screen-256color` is required to get colours working correctly,
we have to instead reeducate `vim` on how to interpret `xterm` style control sequences.
Put the following in your `~/.vimrc`

    if &term =~ '256color'
        " Disable Background Color Erase (BCE) so that color schemes work
        " properly when Vim is used inside tmux and GNU screen.
        " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
        set t_ut=
    endif

    if &term =~ '^screen'
        " Page up/down keys
        " http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
        execute "set t_kP=\e[5;*~"
        execute "set t_kN=\e[6;*~"

        " Home/end keys
        map <Esc>OH <Home>
        map! <Esc>OH <Home>
        map <Esc>OF <End>
        map! <Esc>OF <End>

        " Arrow keys
        execute "set <xUp>=\e[1;*A"
        execute "set <xDown>=\e[1;*B"
        execute "set <xRight>=\e[1;*C"
        execute "set <xLeft>=\e[1;*D"
    endif

That should do it!
