" Dont use the quickfix or loclist windows for errors
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
" Map [e/]e to prev/next errors from the linter
nnoremap <silent> [e <Plug>(ale_previous_wrap)
nnoremap <silent> ]e <Plug>(ale_previous_wrap)
