" Per-file python settings
setlocal expandtab
setlocal nosmartindent
setlocal comments=b:#,b:#:,fb:-,fb:*
call HardMode(79)
setlocal omnifunc<

let b:ale_fixers = []
for fixer in ['black', 'isort']
	if executable(fixer)
		call add(b:ale_fixers, fixer)
	endif
endfor
