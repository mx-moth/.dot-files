
hi badpar ctermbg=red
syn match badpar ')'

if !exists('g:rainbow_paren_colors')
	let g:rainbow_paren_colors = [
		\ 'darkgreen',
		\ 'darkcyan',
		\ 'magenta',
		\ 'darkgray',
		\ 'brown',
		\ 'gray',
		\ 'darkmagenta',
		\ 'darkgreen',
		\ 'darkgreen',
		\ 'darkcyan',
		\ 'magenta',
		\ 'darkgray',
		\ 'brown',
		\ 'gray',
		\ 'darkmagenta',
		\ 'darkgreen',
		\ 'darkcyan',
		\]
endif


let s:hi_pattern = 'hi level%dc ctermfg=%s'
let s:syn_pattern = 'syn region %s matchgroup=%s start=/%s/ end=/%s/ contains=TOP,%s,NoInParens'
let s:cluster_pattern = 'syn cluster rainbow_parens contains=@TOP,%s,NoInParens'

let s:brace_types = [['(', ')'], ['\[', '\]'], ['{', '}']]

let s:levels = reverse(g:rainbow_paren_colors)
let s:num_levels = len(s:levels)

function! rainbow_parens#activate()
	exec printf(s:cluster_pattern,
				\join(map(range(1, s:num_levels), '"level".v:val'), ','))

	for l:level in range(s:num_levels)
		exec printf(s:hi_pattern, l:level, s:levels[l:level])
		for l:brace in s:brace_types

			let l:region = 'level'. l:level . (l:level == 0 ? 'none' : '')
			let l:first = (l:level == 0) ? 1 : 0
			let l:group = l:first ? 'Normal' : ('level'. l:level . 'c')

			let l:next_levels = join(map(range(l:level, s:num_levels), '"level".v:val'), ',')

			let l:syn = printf(s:syn_pattern, l:region, l:group,
						\l:brace[0], l:brace[1], l:next_levels)
			exec l:syn
		endfor
	endfor
endfunction
