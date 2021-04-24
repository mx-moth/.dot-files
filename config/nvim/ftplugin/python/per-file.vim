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

" Use pflake8 if it is available. pflake8 draws settings from pyproject.toml
if executable('pflake8')
	let g:ale_python_flake8_executable = 'pflake8'
	let g:ale_python_flake8_use_global = 1
endif
