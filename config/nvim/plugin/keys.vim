" Key bindings

" Toggle spaces/tabs with <F7>
map <F7> <Esc>:set expandtab!<CR>
imap <F7> <Esc>:set expandtab!<CR>i

" Alt-Enter moves the rest of the line to a new line *above* the cursor.
" Useful for breaking a comment off from the end of a line to the line above.
imap <A-Return> <Esc>lDO<C-o>p

" I forget what <Nul> is, but this opens omnifunc completion from insert mode
inoremap <Nul> <C-x><C-o>

" Just highlight the word under the cursor with '*', instead of searching
nnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>:echo<CR>

" Clear the search highlight
nnoremap <Delete> :nohlsearch <cr>

" Magic searching by default
nnoremap / /\v
vnoremap / /\v

"Remap VIM 0
map 0 ^

" Q is really annoying.
map Q :cc<CR>

" Disable <F1>
nmap <F1> <Esc>
imap <F1> <Nop>

" Like J, but joins with the line above
map K kJ

" Visual navigation over line-based navigation
nmap j gj
nmap k gk
nmap <up> gk
nmap <down> gj
imap <silent> <up> <C-o>gk
imap <silent> <down> <C-o>gj

" Reload config wih \r
noremap <silent> <Leader>r :source $MYVIMRC<cr>

"Move a line or selection of text using Crtl+[jk]
nmap <silent> <C-j> mz:m+<CR>`z
nmap <silent> <C-k> mz:m-2<CR>`z
vmap <silent> <C-j> :m'>+<CR>`<my`>mzgv`yo`z
vmap <silent> <C-k> :m'<-2<CR>`>my`<mzgv`yo`z

" Split the view using | or -
map <silent> <C-w><C-\> :botright vert new<cr>
map <silent> <C-w><C--> :botright new<cr>
map <silent> <C-w><C-_> :botright new<cr>
map <silent> <C-w>\ :botright vert new<cr>
map <silent> <C-w>- :botright new<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => :Q to quit the whole tab - exiting Vim if it is the last tab
"
" This differs from :tabclose, which does not quit if this tab is the last tab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:CloseTab()
	if tabpagenr('$') == 1
		qall
	else
		tabclose
	endif
endfunction
command! -nargs=0 Q call s:CloseTab()
