let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" Load pathogen bundle loader
filetype off 
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Have Vim load indentation rules and plugins according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Show (partial) command in status line.
set showcmd

" Open a maximum of 30 tabs on start up
set tabpagemax=30

" Save marks and stuff
set viminfo+='100,f1

" Bash style tab completion
set wildmenu
set wildmode=longest:full

" Search settings
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hlsearch

" Improved status line: always visible, shows [+] modification, read only
" status, git branch, etc.
set laststatus=2
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" Appearance settings
set background=dark
colorscheme my
highlight FoldColumn ctermfg=darkyellow ctermbg=darkgrey
set number          " Numbers in the margin
set showmatch		" Show matching brackets.
set foldcolumn=3    " Fold column is three bits wide

set showfulltag     " Auto-complete things?

" Indentation settings
set tabstop=4       " I like four space tabs for indenting
set shiftwidth=4    " I like four space tabs for indenting
set smartindent     " Syntax aware indenting
set autoindent      " Auto indent
set lbr             " Put line breaks at word ends, not in the middle of characters
set scrolloff=10

" Custom filetype settings
au BufNewFile,BufRead *.cjs setfiletype javascript
au BufNewFile,BufRead *.thtml setfiletype php
au BufNewFile,BufRead *.pl setfiletype prolog
au BufNewFile,BufRead *.php call s:php_init()
au BufNewFile,BufRead *.json setfiletype json
autocmd BufNewFile,BufRead *.csv setf csv

" Enable XML syntax folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

function! s:php_init()
	set foldmethod=manual|EnableFastPHPFolds
	map <F5> <Esc>:EnableFastPHPFolds<Cr>
	map <F6> <Esc>:EnablePHPFolds<Cr>
	map <F7> <Esc>:DisablePHPFolds<Cr>
endfunction

autocmd FileType php set keywordprg=$HOME/.vim/plugins/php_doc

" Enable modeline (Vim settings in a file)
set modeline

" enable per-directory .vimrc files
set exrc
set secure

" Default file type
set fileformat=unix

" Man page plugin
runtime ftplugin/man.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^

"Move a line or selection of text using Crtl+[jk] or Comamnd+[jk] on mac
nmap <silent> <C-j> mz:m+<CR>`z
nmap <silent> <C-k> mz:m-2<CR>`z
nmap <silent> <C-down> mz:m+<CR>`z
nmap <silent> <C-up> mz:m-2<CR>`z
vmap <silent> <C-j> :m'>+<CR>`<my`>mzgv`yo`z
vmap <silent> <C-k> :m'<-2<CR>`>my`<mzgv`yo`z
vmap <silent> <C-down> :m'>+<CR>`<my`>mzgv`yo`z
vmap <silent> <C-up> :m'<-2<CR>`>my`<mzgv`yo`z

" Nul (aka. Ctrl-Space) does dicky things. Lets stop that.
imap <Nul> <Nop>

command -nargs=0 WM :w | :!make

" Supertab options
let g:SuperTabDefaultCompletionType="context"
let g:SuperTabContextDefaultCompletionType="<c-p>"
let g:SnipMateSuperTab=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatically mkdir for files in non-existant directories
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup BWCCreateDir
	au!
	autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatically chmod +x for files starting with #! .../bin/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod +x  | endif | endif


