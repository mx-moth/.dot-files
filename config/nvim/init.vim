syntax on
set nocompatible
call pathogen#infect()

if has("autocmd")
	function! s:JumpToLastLine()
		if &filetype == "gitcommit"
			call setpos(".", [0, 1, 1, 0])
		elseif line("'\"") > 1 && line("'\"") <= line("$")
			execute "normal! g'\""
		endif
	endfunction

	au BufReadPost * call s:JumpToLastLine()

	filetype plugin indent on
endif

set nocompatible
set backspace=2
set mouse=a

" Show (partial) command in status line.
set showcmd

set backup
set writebackup
set backupdir=~/.cache/vim,/tmp

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

inoremap <Nul> <C-x><C-o>

" Search settings
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set incsearch       " Incremental search
set hlsearch
set gdefault        " Automatic global replacement

if exists('&concealcursor')
	set concealcursor=nc
	set conceallevel=1
endif

" Just highlight the word under the cursor with '*', instead of searching
nnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>:echo<CR>

" Clear the search highlight
nnoremap <Delete> :nohlsearch <cr>

" Magic searching by default
nnoremap / /\v
vnoremap / /\v

" Improved status line: always visible, shows [+] modification, read only
" status, git branch, filetype
set laststatus=2

" Appearance settings
set background=dark
set number          " Numbers in the margin
set showmatch       " Show matching brackets.
set diffopt=filler,foldcolumn:0
colorscheme my

" Customise the colour scheme. This probably doesnt belong in the real colour
" scheme file, as it is kind of a dirty hack
highlight ExtraWhitespace ctermbg=52 ctermfg=196 guibg=#ff0000 guibg=#000000
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

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
set nowrap
set linebreak
set formatoptions+=l
set breakat-=/:
set breakat+=>

set list
set listchars=tab:│\ ,extends:❯,precedes:❮,trail:_,eol:¬
set cursorline

set foldlevelstart=99
set fillchars=vert:║,fold:═

set nojoinspaces


" Custom filetype settings
au BufNewFile,BufRead *.cjs setfiletype javascript
au BufNewFile,BufRead *.thtml setfiletype php
au BufNewFile,BufRead *.pl setfiletype prolog
au BufNewFile,BufRead *.json setfiletype json
autocmd BufNewFile,BufRead *.csv setf csv

" Enable XML syntax folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax
au FileType xml setlocal foldlevel=99

" Enable modeline (Vim settings in a file)
set modeline

" enable per-directory .vimrc files
set exrc
set secure

" Default file type
set fileformat=unix

map <F7> <Esc>:set expandtab!<CR>
imap <F7> <Esc>:set expandtab!<CR>i

" Shift-Enter moves the rest of the line to a new line *above* the cursor
imap <Esc>OM <Esc>lDO<C-o>p

if &term =~ '256color'
	" Disable Background Color Erase (BCE) so that color schemes work properly
	" when Vim is used inside tmux and GNU screen.
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


function! ResizeRebalance()
	exec "normal \<C-w>="
endfunction
augroup ResizeRebalance
	au!
	autocmd VimResized * call ResizeRebalance()
augroup END

let g:deoplete#enable_at_startup = 1

let g:python3_venv = $HOME . "/.config/nvim/venv"
let g:python3_bin = g:python3_venv . "/bin"
let g:python3_host_prog = g:python3_bin . "/python"

let g:EditorConfig_core_mode = "external_command"
let g:EditorConfig_exec_path = g:python3_bin . "/editorconfig"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^

" Q is really annoying.
map Q :cc<CR>
nmap <F1> <Esc>
imap <F1> <Nop>

map K kJ

noremap <silent> <Leader>r :source $MYVIMRC<cr>

"Move a line or selection of text using Crtl+[jk] or Comamnd+[jk] on mac
nmap <silent> <C-j> mz:m+<CR>`z
nmap <silent> <C-k> mz:m-2<CR>`z
nmap <silent> <C-down> mz:m+<CR>`z
nmap <silent> <C-up> mz:m-2<CR>`z
vmap <silent> <C-j> :m'>+<CR>`<my`>mzgv`yo`z
vmap <silent> <C-k> :m'<-2<CR>`>my`<mzgv`yo`z
vmap <silent> <C-down> :m'>+<CR>`<my`>mzgv`yo`z
vmap <silent> <C-up> :m'<-2<CR>`>my`<mzgv`yo`z

" :W - Write then make. Usefull for compiling automatically
command! -nargs=0 WM :w | :!make

" Switch tabs using meta(alt)-left/right
map <silent> <M-Left> gT
map <silent> <M-right> gt
imap <silent> <M-left> <Esc>gTi
imap <silent> <M-right> <Esc>gti

map <silent> <C-M-Left>  <C-w><Left>
map <silent> <C-M-Right> <C-w><Right>
map <silent> <C-M-Up>    <C-w><Up>
map <silent> <C-M-Down>  <C-w><Down>

" Split the view using | or -
map <silent> <C-w><C-\> :botright vert new<cr>
map <silent> <C-w><C--> :botright vert new<cr>
map <silent> <C-w><C-_> :botright vert new<cr>
map <silent> <C-w>\ :botright vert new<cr>
map <silent> <C-w>- :botright new<cr>

" Switch to a numbered tab
map <silent> <C-W>1 :tabn 1<Cr>
map <silent> <C-W>2 :tabn 2<Cr>
map <silent> <C-W>3 :tabn 3<Cr>
map <silent> <C-W>4 :tabn 4<Cr>
map <silent> <C-W>5 :tabn 5<Cr>
map <silent> <C-W>6 :tabn 6<Cr>
map <silent> <C-W>7 :tabn 7<Cr>
map <silent> <C-W>8 :tabn 8<Cr>
map <silent> <C-W>9 :tabn 9<Cr>


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
" => Open multiple files in tabs/windows in one command
"
" Usage:
"   :Etabs module/*.py
"   :Ewindows client.h client.cpp
"   :Evwindows logs/error.log logs/debug.log
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -complete=file -nargs=+ Etabs call s:ETW('tabnew', <f-args>)
command! -complete=file -nargs=+ Ewindows call s:ETW('new', <f-args>)
command! -complete=file -nargs=+ Evwindows call s:ETW('vnew', <f-args>)

function! s:ETW(what, ...)
	for f1 in a:000
		let files = glob(f1)
		if files == ''
			execute printf('%s %s', a:what, escape(f1, '\ "'))
		else
			for f2 in split(files, "\n")
				execute printf('%s %s', a:what, escape(f2, '\ "'))
			endfor
		endif
	endfor
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatically mkdir for files in non-existant directories
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:CheckDirectoryExists()
	if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h"))
		call system(printf("mkdir -p %s", shellescape(expand('%:h'), 1)))
		redraw!
	endif
endfunction

augroup BWCCreateDir
	au!
	autocmd BufWritePre * call s:CheckDirectoryExists()
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatically chmod +x for files starting with #! .../bin/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:AutoChmodX()
	if getline(1) =~ "^#!"
		call system(printf("chmod +x %s", shellescape(expand('%'), 1)))
	endif
endfunction

au BufWritePost * call s:AutoChmodX()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PHP specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tie in with the PHP syntax file and folding helper
function! s:php_init()
	setlocal keywordprg=$HOME/.vim/plugins/php_doc  " Use the PHP doc
	setlocal foldmethod=manual|EnableFastPHPFolds
	setlocal foldcolumn=3
	map <F5> <Esc>:syntax sync fromstart<CR>
	map <F6> <Esc>:EnableFastPHPFolds<CR>
endfunction

augroup php
	au!
	au FileType php call s:php_init()
augroup END

function! s:autype(type, event, callback)
	let l:cmd_str = "autocmd %s * if &ft == '%s' | call %s() | endif"
	execute printf(l:cmd_str, a:event, a:type, a:callback)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatically compile less files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:compile_less()
	let l:less = expand('%:p')
	let l:css = substitute(l:less, "\\<less\\>", "css", "g")
	let l:outfile = tempname()
	let l:errorfile = "/dev/null"
	let l:cmd = printf("!lessc --no-color %s > %s 2> %s",
	\	shellescape(l:less, 1),
	\	shellescape(l:outfile, 1),
	\	shellescape(l:errorfile, 1)
	\)
	silent execute l:cmd

	if v:shell_error
		call delete(l:outfile)
	else
		call rename(l:outfile, l:css)
	endif
endfunction

augroup less
	au!
	call s:autype('less', 'BufWritePost', 's:compile_less')

augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Objective-C settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType objc setlocal foldmethod=syntax foldnestmax=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType markdown call HardMode(79)
let g:markdown_fenced_languages = [
			\'coffee', 'css', 'erb=eruby', 'javascript',
			\'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml'
			\]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("+colorcolumn")
	autocmd FileType gitcommit setlocal colorcolumn=+1
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimscript settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType vim call HardMode(79)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Java settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd Filetype java setlocal omnifunc=javacomplete#Complete

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:PythonInit()
	setlocal expandtab
	setlocal nosmartindent
	call HardMode(79)
	setlocal omnifunc<
endfunction

au FileType python call s:PythonInit()

let g:pyindent_open_paren = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'
let g:python_no_builtin_highlight = 1

let g:jedi#documentation_command = "<F1>"
let g:jedi#completions_enabled = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = 2
let g:jedi#use_tabs_not_buffers = '1'
let g:jedi#smart_auto_mappings = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Erlang settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType erlang setlocal expandtab
let g:erlangCompletionGrep='zgrep'
let g:erlangManSuffix='erl\.gz'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ctrl+p settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_custom_ignore = {
	\ 'dir': join([
	\     '^\.git$', '^\.svn$', '^\.hg$',
	\     '^build$', '^output', '^var$',
	\     'venv$', 'node_modules$', '^__pycache__$',
	\     'frontend\/static$', '^build$',
	\ ], '\|'),
	\ 'file': '\.pyc$\|\.so$\|\.class$\|.swp$\|\.pid\|\.beam$',
	\ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Execute something on the command line, and display the output in a scratch
" buffer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))

  " Set up a scratch buffer
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number

  " Run the command, put it in the buffer
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw

  " Kill the window on exit
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  " <Leader>r to rerun the command
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'

  echo 'Shell command ' . command . ' executed.'
endfunction

command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Replace the selected text with the base64 encoded contents of the file named
" in the selection. Great for encoding images in CSS, etc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! <sid>MakeDataUri(filename)


	let mimetype = system('mimetype -b ' . shellescape(a:filename))
	let mimetype = substitute(mimetype, '\v^\s+|\s+$', '', 'g')

	let base64 = system('base64 -w 0 ' . shellescape(a:filename))
	let replacement = printf('data:%s;base64,%s', mimetype, base64)

	return replacement
endfunction

function! <sid>DataUriSelectedFilename()
	" This is bad. Find a better way
	normal gv"xy
	let selected_text = @x

	let named_file = ''
	if selected_text =~ '^/'
		let named_file=selected_text
	else
		let base_directory = expand('%:h')
		let named_file = simplify(base_directory . '/' . selected_text)
	end

	let @x = <sid>MakeDataUri(named_file)

	" TODO Also bad
	" re-select area and delete
	normal gvd
	" paste new string value back in
	normal "xp
endfunction

vnoremap <leader>bb :call <sid>DataUriSelectedFilename()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make a scratch buffer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! <sid>ScratchBuffer()
	botright new
	resize 10
	setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile
	setlocal nowrap number
endfunction

nnoremap <leader>s :call <sid>ScratchBuffer()<CR>

if filereadable($HOME . "/.vimrc.local")
	source ~/.vimrc.local
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rainbow parens
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:rainbow_active = 1
let g:rainbow_conf = {
	\'operators': '_,,,_',
	\'ctermfgs': [
		\'darkgreen', 'darkcyan', 'magenta', 'darkgray', 'brown',
		\'gray', 'darkmagenta', 'darkgreen', 'darkgreen', 'darkcyan',
		\'magenta', 'darkgray', 'brown', 'gray', 'darkmagenta', 'darkgreen',
		\'darkcyan',
	\],
	\'separately': {
		\'*': {},
		\'html': { },
		\'vim': { },
	\}
\}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <F8> :TagbarToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Dont use the quickfix or loclist windows for errors
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
" Map [e/]e to prev/next errors from the linter
nnoremap <silent> [e <Plug>(ale_previous_wrap)
nnoremap <silent> ]e <Plug>(ale_previous_wrap)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#close_symbol = ''
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_min_count = 2
function! AirlineInit()
	let g:airline_section_x = airline#section#create(['%4b│0x%-4B'])        " Character number
	let g:airline_section_y = airline#section#create(['%P of %L'])        " Position
	let g:airline_section_z = airline#section#create(['%(%2.l:%-3c%'])        " Line/column
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SCSS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup scss
	au!
	au FileType scss :setlocal iskeyword+=-
	au FileType scss :setlocal iskeyword+=\$
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jade
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup jade
	au!
	au FileType jade :setlocal noexpandtab
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ruby
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup ruby
	au!
	au FileType ruby setlocal expandtab
	au FileType ruby setlocal shiftwidth=2
	au FileType ruby setlocal tabstop=2
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" reStructredText
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup rst
	au!
	au FileType rst setlocal wrap
	au FileType rst setlocal spell
augroup END
