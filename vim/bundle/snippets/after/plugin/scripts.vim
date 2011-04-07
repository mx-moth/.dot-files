ino <silent> <C-Space> <c-r>=TriggerSnippet()<cr>
snor <silent> <C-Space> <esc>i<right><c-r>=TriggerSnippet()<cr>

"ino <silent> <C-S-Tab> <c-r>=BackwardsSnippet()<cr>
"snor <silent> <C-S-tab> <esc>i<right><c-r>=BackwardsSnippet()<cr>
ino <silent> <C-R><tab> <c-r>=ShowAvailableSnips()<cr>

" Terminals send 'nul' instead of ctrl-space, so lets just remap that for ease
" of use
imap <nul> <C-Space>
