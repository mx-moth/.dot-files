" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
" set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

set showcmd			" Show (partial) command in status line.
set tabpagemax=30

" Save marks and stuff
set viminfo+='100,f1

" Bash style tab completion
set wildmode=longest:full
set wildmenu

" Search settings
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hlsearch

" Appearance settings
set background=dark
colorscheme torte
set number
set showmatch		" Show matching brackets.
set showfulltag

" Indentation settings
set tabstop=4       " I like four space tabs for indenting
set shiftwidth=4    " I like four space tabs for indenting
set smartindent     " Syntax aware indenting
set autoindent      " Auto indent
set lbr             " Put line breaks at word ends, not in the middle of characters

" Custom filetype settings
au BufNewFile,BufRead *.thtml setfiletype php
au BufNewFile,BufRead *.pl setfiletype prolog
au BufNewFile,BufRead *.php call s:php_init()
autocmd BufNewFile,BufRead *.csv setf csv

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

function! s:php_init()
	set foldmethod=manual|EnableFastPHPFolds
	map <F5> <Esc>:EnableFastPHPFolds<Cr>
	map <F6> <Esc>:EnablePHPFolds<Cr>
	map <F7> <Esc>:DisablePHPFolds<Cr>
endfunction

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
