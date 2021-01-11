"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatically mkdir for files in non-existant directories
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:CheckDirectoryExists()
	if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h"))
		call system(printf("mkdir -p %s", shellescape(expand('%:h'), 1)))
		redraw!
	endif
endfunction

augroup BWCCreateDir
	au!
	autocmd BufWritePre * call s:CheckDirectoryExists()
augroup END
