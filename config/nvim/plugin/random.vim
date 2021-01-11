function! s:GetRandomString(characters) "{{{
	let string = system('cat /dev/urandom | base64 | head -c ' . a:characters)
	return substitute(string, "[\s\n]$", "", "")
endfunction "}}}

function! s:PrintRandomString() "{{{
	exe "normal i" . <SID>:GetRandomString() . "\<ESC>"
endfunction "}}}

" Insert text at the current cursor position.
function! s:InsertText(text)
	let l:cur_line_num = line('.')
	let l:cur_col_num = col('.')
	let l:orig_line = getline('.')
	echo l:cur_line_num . ':' . cur_col_num . ', line length ' . strlen(l:orig_line)
	if strlen(l:orig_line) == l:cur_col_num
		echo "End of line!"
		let l:modified_line = l:orig_line . a:text
		let l:pos = strlen(modified_line)
	else
		echo "Not end of line!"
		let l:modified_line =
					\ strpart(orig_line, 0, cur_col_num - 1)
					\ . a:text
					\ . strpart(orig_line, cur_col_num - 1)
		let l:pos = cur_col_num + strlen(a:text)
	endif

	" Replace the current line with the modified line.
	call setline(cur_line_num, modified_line)
	" Place cursor on the last character of the inserted text.
	call setpos('.', [0, cur_line_num, pos, 0])
endfunction

inoremap <expr> <Plug>InsertRandom <SID>GetRandomString(60)
imap <Leader>r <Plug>InsertRandom
