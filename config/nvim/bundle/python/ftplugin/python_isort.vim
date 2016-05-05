"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Isort
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Isort()
	let l:line = line(".")
	let l:isort = g:python3_venv_bin . "isort"
	exe "%! " . l:isort . " -"
	call setpos(".", [0, l:line, 0, 0])
endfunction
command! -nargs=0 Isort :call Isort()


au BufWritePre python call s:Isort()
