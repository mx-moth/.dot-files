"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatically chmod +x for files starting with #! .../bin/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:AutoChmodX()
	if getline(1) =~ "^#!"
		call system(printf("chmod +x %s", shellescape(expand('%'), 1)))
	endif
endfunction

au BufWritePost * call s:AutoChmodX()
