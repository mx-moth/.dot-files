let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" Load pathogen bundle loader
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" Uncomment the following to have Vim jump to the last position when reopening
" a file
if has("autocmd")
	function! s:JumpToLastLine()
		if line("'\"") > 1 && line("'\"") <= line("$")
			execute "normal! g'\""
		endif
	endfunction

	au BufReadPost * call s:JumpToLastLine()
endif

" Have Vim load indentation rules and plugins according to the detected
" filetype.
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
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set incsearch       " Incremental search
set hlsearch
set gdefault        " Automatic global replacement

" Just highlight the word under the cursor with '*', instead of searching
nnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>:echo<CR>

" Clear the search highlight
nnoremap <Delete> :nohlsearch <cr>

" Magic searching by default
nnoremap / /\v
vnoremap / /\v

" Improved status line: always visible, shows [+] modification, read only
" status, git branch, filetype, username, hostname
set laststatus=2
hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red
set statusline=%<%f\ ❖\ env:\ [%Y][%{$USER}][%{hostname()}]\ %(❖\ sts:\ %h%m%r%{fugitive#statusline()}\ %)%=%-14.(%l/%L:%c%V%)\ %P

" Appearance settings
set background=dark
colorscheme my
set number          " Numbers in the margin
set showmatch       " Show matching brackets.

" Customise the colour scheme. This probably doesnt belong in the real colour
" scheme file, as it is kind of a dirty hack
highlight FoldColumn ctermfg=darkyellow ctermbg=darkgrey
highlight ExtraWhitespace ctermbg=52 ctermfg=196
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

set showfulltag     " Auto-complete things?

" Indentation settings
set tabstop=4       " I like four space tabs for indenting
set shiftwidth=4    " I like four space tabs for indenting
set smartindent     " Syntax aware indenting
set autoindent      " Auto indent
set lbr             " Put line breaks at word ends, not in the middle of words
set scrolloff=40
set nowrap

set list
set listchars=tab:│\ ,extends:❯,precedes:❮,trail:␣

set foldlevelstart=99
set fillchars=vert:║,fold:═

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

" Man page plugin
runtime ftplugin/man.vim

map <F7> <Esc>:set expandtab!<CR>
imap <F7> <Esc>:set expandtab!<CR>i

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

" :W - Write then make. Usefull for compiling automatically
command! -nargs=0 WM :w | :!make


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

	if width == 0
		setlocal textwidth=0
	else
		exec "setlocal textwidth=".l:width
		if exists("+colorcolumn")
			setlocal colorcolumn=+1
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
function! PythonSuper()
	let l:found = 0
	let l:line = line('.')
	let l:defName = ''
	let l:className = ''

	let l:shiftwidth = &sw

	while getline(l:line) == ''
		let l:line = l:line - 1
	endwhile
	let l:currentIndent = len(matchstr(getline(line), '^ *')) / shiftwidth
	if getline(line) =~ (repeat(' ', currentIndent * shiftwidth).'def ')
		let l:currentIndent = l:currentIndent + 1
	endif

	let l:defIndent = currentIndent - 1
	let l:classIndent = currentIndent - 2

	let l:defPatt = '^'.repeat(' ', l:defIndent * l:shiftwidth).'def '
	let l:classPatt = '^'.repeat(' ', l:classIndent * l:shiftwidth).'class '

	while l:found == 0
		if l:line < 0
			return
		endif
		if getline(l:line) =~ l:defPatt
			let l:defMatch = matchlist(getline(l:line), defPatt.'\([a-zA-Z0-9]*\)')
			let l:defName = l:defMatch[1]
			let l:found = 1
			break
		endif
		let l:line = l:line - 1
	endwhile

	let l:found = 0
	while l:found == 0
		if l:line < 0
			return
		endif
		if getline(l:line) =~ l:classPatt
			let l:classMatch = matchlist(getline(l:line), classPatt.'\([a-zA-Z0-9]*\)')
			let l:className = l:classMatch[1]
			let l:found = 1
			break
		endif
		let l:line = l:line - 1
	endwhile

	let l:super = 'super('.l:className.', self).'.l:defName.'('

	" Various possible cases:
	" 1. On an empty (or white-space only)
	" 2. At the end of a line: val = super(...)
	" 3. In the middle of a line: val = fn(super(...))
	if getline('.') =~ '^\s*$'
		call setline(line('.'), repeat(' ', l:currentIndent * &sw).l:super)
		call cursor(line('.'), col('$'))
	elseif col('.') == col('$') - 1
		call setline(line('.'), getline('.').l:super)
		call cursor(line('.'), col('$') - 1)
	else
		let currentLine = getline('.')
		let currentColumn = col('.') - 1
		let newLine = currentLine[0:(l:currentColumn - 1)] . l:super . ')' . currentLine[(l:currentColumn):]
		call setline(line('.'), newLine)
		call cursor(line('.'), currentColumn + len(super) + 1)
	end
endfunction

function! s:PythonInit()
	setlocal expandtab
	setlocal nosmartindent
	call HardMode(79)
	nnoremap <leader>s :call PythonSuper()<CR>
	nnoremap <localleader>s :call PythonSuper()<CR>
endfunction

au FileType python call s:PythonInit()

let g:pyindent_open_paren = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Erlang settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType erlang setlocal expandtab

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ctrl+p settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_custom_ignore = {
	\ 'dir': '\.git$\|\.svn$\|\.hg$\|build$\|venv$',
	\ 'file': '\.pyc$\|\.so$\|\.class$\|.swp$',
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
