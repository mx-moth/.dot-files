
function! s:GetRandomString() "{{{
	let string = system('head -c 47 /dev/urandom | base64')
    return substitute(string, "[\s\n]$", "", "")
endfunction "}}}

function! s:PrintRandomString() "{{{
	exe "normal i" . s:GetRandomString() . "\<ESC>"
endfunction "}}}

command! -nargs=0 GetRandomString call s:GetRandomString()
command! -nargs=0 PrintRandomString call s:PrintRandomString()

imap <C-W>r <Esc><Space>:PrintRandomString<Cr><insert>
nmap <C-W>r :PrintRandomString<Cr>
