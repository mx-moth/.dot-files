#!/usr/bin/env python
"""
Make PS1 string
"""

import sys

_COLOURS = {
    'black'   : 0,
    'red'     : 1,
    'green'   : 2,
    'yellow'  : 3,
    'blue'    : 4,
    'magenta' : 5,
    'cyan'    : 6,
    'light-grey' : 7,
}
_BOLD = 1
_FORE_BASE = 30
_BACK_BASE = 40

def hide_text(text):
    """
    Wrap text in escape codes to hide it from display. See `man bash`, PROMPTING
    """
    return '\[' + text + '\]'

def escape(text):
    return hide_text('\e[' + text + 'm')

def make_colour_code(code, colour_type):
    """
    Make a colour code escape sequence. `code` can be either:

    * a string key in the `_COLOURS` dict
    * a three-tuple of `(r, g, b)`
    * a numeric xterm colour index

    `colour_type` must be one of `_FORE_BASE` or `_BACK_BASE`
    """

    if isinstance(code, basestring):
        return str(colour_type + _COLOURS[code])

    if isinstance(code, tuple):
        return str(colour_type + 8) + ';2;' + ';'.join(map(str, code))
    
    return '38;5;' + str(code)


def format_text(text, fore=None, back=None, bold=False):
    """
    Wrap text in shell format codes
    """
    codes = []

    if fore:
        codes.append(make_colour_code(fore, _FORE_BASE))

    if back:
        codes.append(make_colour_code(back, _BACK_BASE))

    if bold:
        codes.append(str(_BOLD))

    if codes:
        return escape(';'.join(codes)) + text + escape('0')
    else:
        return text


PS1 = ["\n"]
PS1 += ['[ ', format_text('\u', fore=40)]     # $USER
PS1 += [' at ', format_text('\h', fore=13)] # at $HOST


PS1 += ['$( vcprompt -f " on ',
    format_text('%n', fore=130), ':',
    format_text('%b', fore=214),
    format_text(' [', fore=239),
    format_text('%m', fore='red'),
    format_text('%u', fore=33),
    format_text(']', fore=239),
    '" ',
    '--format-git " on ',
    format_text('%n', fore=130), ':',
    format_text('%b', fore=214),
    format_text(' [', fore=239),
    format_text('%a', fore='green'),
    format_text('%m', fore='red'),
    format_text('%u', fore=33),
    format_text(']', fore=239),
    '"',
    ')']

VENV_COMMAND = "".join([
'if [[ x"$VIRTUAL_ENV" != x ]] ; then '
    'dir=$( basename $( echo -n "$VIRTUAL_ENV" | sed -e"s/\/venv\/\?$//" ) ) ; '
    'echo " working on ' + format_text('$dir', fore=51) + '" ; '
'fi'])
PS1 += ['$( ', VENV_COMMAND, ' )']

PS1 += [' in ', format_text('\w', fore=202)]  # in $DIRECTORY
PS1 += [" ]\n"]

PS1 += ['\$', ' '] # End, $

sys.stdout.write(''.join(PS1))
