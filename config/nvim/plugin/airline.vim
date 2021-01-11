let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#close_symbol = ''
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#bufferline#enabled = 0

function! AirlineInit()
	" Character number
	let g:airline_section_x = airline#section#create(['%4b│0x%-4B'])
	" Position in file
	let g:airline_section_y = airline#section#create(['%P of %L'])
	" Line/column
	let g:airline_section_z = airline#section#create(['%(%2.l:%-3c%'])
endfunction
autocmd VimEnter * call AirlineInit()

let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }
