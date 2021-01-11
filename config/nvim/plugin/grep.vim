"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :Grep - Search files for a pattern in a new tab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! <sid>Grep(args)
	let l:command="ag --vimgrep \$* " . a:args

	" Status message
	echohl WarningMsg
	echo "Searching for"
	echohl None
	echon ' ' . a:args

	" Do the grep
	let l:search = system(l:command)
	redraw

	" Bail if there were no search results
	if l:search == ''
		echohl ErrorMsg
		echo "No results"
		echohl None
		return
	endif

	" Open a new tab if the current tab is not empty
	let l:empty_tab = winnr('$') == 1 && bufname('%') == '' && !&modified
	if !l:empty_tab
		tabnew
	endif

	" Fill and open the location list
	setlocal grepformat=%f:%l:%c:%m
	lexpr l:search
	ll
endfunction

command! -nargs=+ -complete=file Grep call <sid>Grep(<q-args>)
