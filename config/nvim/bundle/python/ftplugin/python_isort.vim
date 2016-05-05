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


function! s:is_automatic()
	let l:vars = ['b:isort_automatic', 'w:isort_automatic', 't:isort_automatic', 'g:isort_automatic']
	for l:var in l:vars
		if exists(l:var)
			return eval(l:var)
		endif
	endfor
	return 0
endfunction


function! s:IsortAuto()
	if s:is_automatic()
		call Isort()
	endif
endfunction

let g:isort_automatic = 1

command! -nargs=0 Isort call Isort()

augroup python_isort
	au!
	au BufWritePre *.py call s:IsortAuto()
augroup END
