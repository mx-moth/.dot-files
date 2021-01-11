setlocal expandtab

if exists("g:did_ftplugin_erlang")
    finish
endif
let g:did_ftplugin_erlang = 1

let g:erlangCompletionGrep='zgrep'
let g:erlangManSuffix='erl\.gz'
