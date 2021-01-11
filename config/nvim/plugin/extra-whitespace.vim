" Highlight extra whitespace at the end of lines with bright red

highlight ExtraWhitespace ctermbg=52 ctermfg=196 guibg=#ff0000 guibg=#000000
match ExtraWhitespace /\s\+$/

autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
