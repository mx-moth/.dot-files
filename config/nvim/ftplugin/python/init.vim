"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Run-once python settings
if exists("g:did_ftplugin_python")
    finish
endif
let g:did_ftplugin_python = 1

function! InitPy()
	" Make the directory the current file is in first
	call system(printf("mkdir -p %s", shellescape(expand('%:h'), 1)))

	let l:dir = expand('%:h')
	let l:init = '__init__.py'

	" Search up the tree, making __init__.pys until a directory with an
	" __init__.py is reached
	while l:dir != '.' && l:dir != '/' && !glob(l:dir . '/' . l:init)
		call system(printf("touch %s", shellescape(l:dir . '/' . l:init)))
		let l:dir = fnamemodify('l:dir', ':h')
	endwhile
endfunction
command! -nargs=0 InitPy call InitPy()

let g:python_highlight_all = 1
let g:pyindent_open_paren = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'

let g:jedi#documentation_command = "<F1>"
let g:jedi#completions_enabled = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = 2
let g:jedi#use_tabs_not_buffers = '1'
let g:jedi#smart_auto_mappings = 0
let g:jedi#force_py_version = 3
