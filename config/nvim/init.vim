syntax on
set nocompatible

if has("autocmd")
	filetype plugin indent on
endif

set backspace=2
set mouse=a

" Show (partial) command in status line.
set showcmd

set backup
set writebackup
set backupcopy=yes

set backupdir=~/.cache/vim
if !isdirectory(&backupdir)
	try
		call mkdir(&backupdir, "p")
	catch
		echo "Couldn't make backup directory " . &backupdir . ", using /tmp"
		set backupdir=/tmp
	endtry
endif

" Open a maximum of 30 tabs on start up
set tabpagemax=30

" Split to the right, and below
set splitright
set splitbelow

" Save marks and stuff
set viminfo+='100,f1

" Bash style tab completion
set wildmenu
set wildmode=longest:full
set showfulltag     " Auto-complete things?

" Search settings
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set incsearch       " Incremental search
set hlsearch
set gdefault        " Automatic global replacement

if exists('&concealcursor')
	set concealcursor=nc
	set conceallevel=0
endif

" Improved status line: always visible, shows [+] modification, read only
" status, git branch, filetype
set laststatus=2

" Appearance settings
set background=dark
set number          " Numbers in the margin
set diffopt=filler,foldcolumn:0
colorscheme my

" Open the quickfix window when there is stuff to show
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

" Indentation settings
set tabstop=4       " I like four space tabs for indenting
set shiftwidth=4    " I like four space tabs for indenting
set smartindent     " Syntax aware indenting
set autoindent      " Auto indent
set lbr             " Put line breaks at word ends, not in the middle of words
set scrolloff=20

" Breaking on >, and not on /, means HTML closing tags wrap better.
set breakat-=/:
set breakat+=>

" Wrap long lines, keeping the indent level, with a -- mark to show it
set wrap
set breakindent
set breakindentopt=sbr,min:20,shift:4
set showbreak=\ --
set linebreak

" Sensibly wrap comments while writing them
set formatoptions+=lcroqn1j

" Show tabs, lines that dont fit, and trailing spaces
set list
set listchars=tab:│\ ,extends:❯,precedes:❮,trail:_,eol:¬
set cursorline

set foldlevelstart=99
set fillchars=vert:║,fold:═

set nojoinspaces


" Enable modeline (Vim settings in a file)
set modeline

" enable per-directory .vimrc files
set exrc
set secure

" Default file type
set fileformat=unix

if &term =~ '256color'
	" Disable Background Color Erase (BCE) so that color schemes work properly
	" when Vim is used inside tmux and GNU screen.
	"
	" See also http://snk.tuxfamily.org/log/vim-256color-bce.html
	set t_ut=
endif

if &term =~ '^screen'
	" Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
	execute "set t_kP=\e[5;*~"
	execute "set t_kN=\e[6;*~"
	map <Esc>OH <Home>
	map! <Esc>OH <Home>
	map <Esc>OF <End>
	map! <Esc>OF <End>

	" tmux will send xterm-style keys when xterm-keys is on
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif


let g:deoplete#enable_at_startup = 1

let g:python_venv = $HOME . "/.config/nvim/venv2"
let g:python_bin = g:python_venv . "/bin"
let g:python_host_prog = g:python_bin . "/python"

let g:python3_venv = $HOME . "/.config/nvim/venv3"
let g:python3_bin = g:python3_venv . "/bin"
let g:python3_host_prog = g:python3_bin . "/python"

let g:EditorConfig_core_mode = "external_command"
let g:EditorConfig_exec_path = g:python3_bin . "/editorconfig"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Enable hard mode
"
" 79 character columns, automatic text wrapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! HardMode(...)
	" Hardcore mode: enabled
	if a:0 > 0
		let width = a:1
	else
		let width = 79
	end

	setlocal textwidth=0
	if width == 0
		setlocal colorcolumn=0
	else
		if exists("+colorcolumn")
			exec "setlocal colorcolumn=" . (l:width + 1)
		endif
	endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ctrl+p settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v' . join([
	\     '^\.git$', '^\.svn$', '^\.hg$',
	\     '^build$', '^output', '^var$',
	\     'venv$', '.venv', $PYTHON_VENV_NAME, '^__pycache__$', '.tox',
	\     'node_modules$',
	\     'frontend\/static$', '^build$',
	\     'docs\/build$',
	\     'repos$',
	\     'htmlmypy$', 'htmlcov$',
	\ ], '|'),
	\ 'file': '\.pyc$\|\.so$\|\.class$\|.swp$\|\.pid\|\.beam$',
	\ }

if filereadable($HOME . "/.nvimrc.local")
	source ~/.nvimrc.local
endif
