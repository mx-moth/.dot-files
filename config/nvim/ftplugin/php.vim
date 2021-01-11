"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PHP specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" Tie in with the PHP syntax file and folding helper
function! s:php_init()
	setlocal keywordprg=$HOME/.vim/plugins/php_doc  " Use the PHP doc
	setlocal foldmethod=manual|EnableFastPHPFolds
	setlocal foldcolumn=3
	map <F5> <Esc>:syntax sync fromstart<CR>
	map <F6> <Esc>:EnableFastPHPFolds<CR>
endfunction

augroup php
	au!
	au FileType php call s:php_init()
augroup END

function! s:autype(type, event, callback)
	let l:cmd_str = "autocmd %s * if &ft == '%s' | call %s() | endif"
	execute printf(l:cmd_str, a:event, a:type, a:callback)
endfunction
