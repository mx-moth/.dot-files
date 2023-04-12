" Ctrl+p settings
"
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v' . join([
	\     '^\.git$', '^\.svn$', '^\.hg$',
	\     '^build$', '^output', '^var$',
	\     'venv$', '.venv', '^__pycache__$', '.tox',
	\     'node_modules$',
	\     'frontend\/static$', '^build$',
	\     'docs\/build$',
	\     'repos$',
	\     'htmlmypy$', 'htmlcov$',
	\ ], '|'),
	\ 'file': '\.pyc$\|\.so$\|\.class$\|.swp$\|\.pid\|\.beam$',
	\ }

let g:ctrlp_open_multiple_files = 'tj'
