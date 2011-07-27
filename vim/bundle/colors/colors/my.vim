" Vim color file
" Maintainer:	Thorsten Maerz <info@netztorte.de>
" Last Change:	2006 Dec 07
" grey on black
" optimized for TFT panels

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
"colorscheme default
let g:colors_name = "my"

" Pinky values for values
highlight Constant  ctermfg=165 ctermbg=black
highlight Tag ctermfg=165 ctermbg=black
highlight String    ctermfg=161
highlight Character ctermfg=161
highlight Number    ctermfg=127
highlight Float     ctermfg=127
highlight Boolean   ctermfg=129
highlight Keyword   ctermfg=91  cterm=NONE
highlight Exception ctermfg=165 ctermbg=black


" Functions and identifiers get bluey colours
highlight Identifier ctermfg=12 cterm=NONE
highlight Function ctermfg=26 cterm=NONE
highlight Label ctermfg=24 cterm=NONE

" Statements (if, while, case) and operators (+, -) get green colours
highlight Statement ctermfg=40 cterm=NONE
highlight Conditional ctermfg=3 cterm=NONE
highlight Operator ctermfg=70 cterm=NONE
highlight Repeat ctermfg=40 cterm=NONE

highlight Delimiter ctermfg=40

highlight Type	ctermfg=yellow cterm=NONE
highlight TypeDef	ctermfg=yellow cterm=NONE
highlight Structure	ctermfg=yellow

highlight Special ctermfg=brown

highlight Error ctermbg=red ctermfg=black cterm=bold

highlight TODO 	ctermfg=black ctermbg=LightBlue cterm=NONE

" Available classes:
" * PreProc Include Define Macro PreCondit
" * StorageClass Structure Typedef
" * SpecialChar SpecialComment Debug
" * Ignore
" * Todo

" only for vim 5
if has("unix")
  if v:version<600
    highlight Normal  ctermfg=Grey	ctermbg=Black	cterm=NONE	guifg=Grey80      guibg=Black	gui=NONE
    highlight Search  ctermfg=Black	ctermbg=Red	cterm=bold	guifg=Black       guibg=Red	gui=bold
    highlight Visual  ctermfg=Black	ctermbg=yellow	cterm=bold	guifg=#404040			gui=bold
    highlight Special ctermfg=LightBlue			cterm=NONE	guifg=LightBlue			gui=NONE
    highlight Comment ctermfg=Cyan			cterm=NONE	guifg=LightBlue			gui=NONE
  endif
endif

