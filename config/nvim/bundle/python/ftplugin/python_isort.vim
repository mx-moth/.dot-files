"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Isort
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Isort()
	let l:line = line(".")
	let l:isort = g:python3_bin . "/isort"
	exe "%! " . l:isort . " -"
	call setpos(".", [0, l:line, 0, 0])
endfunction
command! -nargs=0 Isort :call Isort()


function! s:IsortAuto()
	call Isort()
endfunction

let g:isort_automatic = 1

command! -nargs=0 Isort call Isort()

augroup python_isort
	au!
	au BufWritePre *.py call s:IsortAuto()
augroup END
