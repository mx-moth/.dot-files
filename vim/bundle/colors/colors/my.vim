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

" Type keywords (int, char, string, etc) are yellow
highlight Type ctermfg=yellow cterm=NONE
highlight TypeDef ctermfg=yellow cterm=NONE
highlight Structure ctermfg=yellow

" Special terms get brown colours
highlight Special ctermfg=brown
highlight PreProc ctermfg=brown

" RED
highlight Error ctermbg=red ctermfg=black cterm=bold

" Invert TODO tags
highlight TODO 	ctermfg=black ctermbg=LightBlue cterm=NONE

" Green/red/blue backgrounds for diff add/delete/change
highlight DiffAdd ctermbg=22 ctermfg=white
highlight DiffDelete ctermbg=52 ctermfg=white
highlight DiffChange ctermbg=17 ctermfg=white

highlight DiffAdded ctermbg=22 ctermfg=white
highlight DiffRemoved ctermbg=52 ctermfg=white
highlight DiffChanged ctermbg=17 ctermfg=white

highlight SpecialKey ctermfg=239

highlight Folded ctermfg=5 ctermbg=0
" highlight DiffText	ctermfg=grey
" highlight diffAdded	ctermfg=grey
" highlight diffBDiffer	ctermfg=grey
" highlight diffChanged	ctermfg=grey
" highlight diffComment	ctermfg=grey
" highlight diffCommon	ctermfg=grey
" highlight diffDiffer	ctermfg=grey
" highlight diffFile	ctermfg=grey
" highlight diffIdentical	ctermfg=grey
" highlight diffIsA	ctermfg=grey
" highlight diffLine	ctermfg=grey
" highlight diffNewFile	ctermfg=grey
" highlight diffNoEOL	ctermfg=grey
" highlight diffOldFile	ctermfg=grey
" highlight diffOnly	ctermfg=grey
" highlight diffRemoved	ctermfg=grey
" highlight diffSubname	ctermfg=grey

" Available classes:
" * PreProc Include Define Macro PreCondit
" * StorageClass Structure Typedef
" * SpecialChar SpecialComment Debug
" * Ignore
" * Todo

highlight StatusLine  cterm=NONE ctermfg=016 ctermbg=32
highlight TabLine     cterm=NONE ctermfg=016 ctermbg=130
highlight TabLineSel  cterm=NONE ctermfg=016 ctermbg=202
highlight TabLineFill cterm=NONE ctermfg=016 ctermbg=94

" only for vim 5
if has("unix")
	if v:version<600
		highlight Normal  ctermfg=Grey ctermbg=Black cterm=NONE guifg=Grey80guibg=Black gui=NONE
		highlight Search  ctermfg=Black ctermbg=Red cterm=bold guifg=Black guibg=Red gui=bold
		highlight Visual  ctermfg=Black ctermbg=yellow cterm=bold guifg=#404040 gui=bold
		highlight Special ctermfg=LightBlue ctermbg=Black cterm=NONE guifg=LightBlue gui=NONE
		highlight Comment ctermfg=Cyan ctermbg=Black cterm=NONE guifg=LightBlue gui=NONE
	endif
endif

