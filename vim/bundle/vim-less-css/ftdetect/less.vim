autocmd BufNewFile,BufRead *.less
      \ if &ft =~# '^\%(conf\|modula2\)$' |
      \   set ft=less |
      \ else |
      \   setf less| 
      \ endif
