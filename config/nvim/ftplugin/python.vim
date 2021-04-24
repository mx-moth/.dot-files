" Per-file python settings

if exists("b:did_ftplugin_python")
    finish
endif
let b:did_ftplugin_python = 1

setlocal expandtab
setlocal nosmartindent
setlocal comments=b:#,b:#:,fb:-,fb:*
setlocal omnifunc<
call HardMode(79)
