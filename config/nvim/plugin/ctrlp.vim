" Ctrl+p settings
"
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v' . join([
	\     '^\.git$', '^\.svn$', '^\.hg$',
	\     '^build$', '^output', '^var$',
	\     '^__pycache__$', '.tox',
	\     'node_modules$',
	\     'frontend\/static$', '^build$',
	\     'docs\/build$',
	\     'repos$',
	\     'htmlmypy$', 'htmlcov$',
	\ ], '|'),
	\ 'file': '\.pyc$\|\.so$\|\.class$\|.swp$\|\.pid\|\.beam$',
	\ }

if !empty($PYTHON_VENV_NAME)
	let g:ctrlp_custom_ignore['dir'] .= '|' . $PYTHON_VENV_NAME
endif

if !empty($CONDA_PREFIX_NAME)
	let g:ctrlp_custom_ignore['dir'] .= '|' . $CONDA_PREFIX_NAME
endif

let g:ctrlp_open_multiple_files = 'tj'
