" Jump to the same place we were at last time in a file that we just reopened
function! s:JumpToLastLine()
	if &filetype == "gitcommit"
		call setpos(".", [0, 1, 1, 0])
	elseif line("'\"") > 1 && line("'\"") <= line("$")
		execute "normal! g'\""
	endif
endfunction

au BufReadPost * call s:JumpToLastLine()
