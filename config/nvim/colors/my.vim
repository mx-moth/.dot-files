set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "my"

let s:xterm_colors = {
    \ 'black':   '#000000', 'maroon':   '#800000', 'green':   '#008000', 'brown':   '#808000',
    \ 'navy':   '#000080', 'purple':   '#800080', 'teal':   '#008080', 'silver':   '#c0c0c0',
    \ 'grey':   '#808080', 'red':   '#ff0000', 'lime':  '#00ff00', 'yellow':  '#ffff00',
    \ 'blue':  '#0000ff', 'pink':  '#ff00ff', 'aqua':  '#00ffff', 'white': '#ffffff',
    \
    \ '0':   '#000000', '1':   '#800000', '2':   '#008000', '3':   '#808000', '4':   '#000080',
    \ '5':   '#800080', '6':   '#008080', '7':   '#c0c0c0', '8':   '#808080', '9':   '#ff0000',
    \ '10':  '#00ff00', '11':  '#ffff00', '12':  '#0000ff', '13':  '#ff00ff', '14':  '#00ffff',
    \ '15':  '#ffffff', '16':  '#000000', '17':  '#00005f', '18':  '#000087', '19':  '#0000af',
    \ '20':  '#0000df', '21':  '#0000ff', '22':  '#005f00', '23':  '#005f5f', '24':  '#005f87',
    \ '25':  '#005faf', '26':  '#005fdf', '27':  '#005fff', '28':  '#008700', '29':  '#00875f',
    \ '30':  '#008787', '31':  '#0087af', '32':  '#0087df', '33':  '#0087ff', '34':  '#00af00',
    \ '35':  '#00af5f', '36':  '#00af87', '37':  '#00afaf', '38':  '#00afdf', '39':  '#00afff',
    \ '40':  '#00df00', '41':  '#00df5f', '42':  '#00df87', '43':  '#00dfaf', '44':  '#00dfdf',
    \ '45':  '#00dfff', '46':  '#00ff00', '47':  '#00ff5f', '48':  '#00ff87', '49':  '#00ffaf',
    \ '50':  '#00ffdf', '51':  '#00ffff', '52':  '#5f0000', '53':  '#5f005f', '54':  '#5f0087',
    \ '55':  '#5f00af', '56':  '#5f00df', '57':  '#5f00ff', '58':  '#5f5f00', '59':  '#5f5f5f',
    \ '60':  '#5f5f87', '61':  '#5f5faf', '62':  '#5f5fdf', '63':  '#5f5fff', '64':  '#5f8700',
    \ '65':  '#5f875f', '66':  '#5f8787', '67':  '#5f87af', '68':  '#5f87df', '69':  '#5f87ff',
    \ '70':  '#5faf00', '71':  '#5faf5f', '72':  '#5faf87', '73':  '#5fafaf', '74':  '#5fafdf',
    \ '75':  '#5fafff', '76':  '#5fdf00', '77':  '#5fdf5f', '78':  '#5fdf87', '79':  '#5fdfaf',
    \ '80':  '#5fdfdf', '81':  '#5fdfff', '82':  '#5fff00', '83':  '#5fff5f', '84':  '#5fff87',
    \ '85':  '#5fffaf', '86':  '#5fffdf', '87':  '#5fffff', '88':  '#870000', '89':  '#87005f',
    \ '90':  '#870087', '91':  '#8700af', '92':  '#8700df', '93':  '#8700ff', '94':  '#875f00',
    \ '95':  '#875f5f', '96':  '#875f87', '97':  '#875faf', '98':  '#875fdf', '99':  '#875fff',
    \ '100': '#878700', '101': '#87875f', '102': '#878787', '103': '#8787af', '104': '#8787df',
    \ '105': '#8787ff', '106': '#87af00', '107': '#87af5f', '108': '#87af87', '109': '#87afaf',
    \ '110': '#87afdf', '111': '#87afff', '112': '#87df00', '113': '#87df5f', '114': '#87df87',
    \ '115': '#87dfaf', '116': '#87dfdf', '117': '#87dfff', '118': '#87ff00', '119': '#87ff5f',
    \ '120': '#87ff87', '121': '#87ffaf', '122': '#87ffdf', '123': '#87ffff', '124': '#af0000',
    \ '125': '#af005f', '126': '#af0087', '127': '#af00af', '128': '#af00df', '129': '#af00ff',
    \ '130': '#af5f00', '131': '#af5f5f', '132': '#af5f87', '133': '#af5faf', '134': '#af5fdf',
    \ '135': '#af5fff', '136': '#af8700', '137': '#af875f', '138': '#af8787', '139': '#af87af',
    \ '140': '#af87df', '141': '#af87ff', '142': '#afaf00', '143': '#afaf5f', '144': '#afaf87',
    \ '145': '#afafaf', '146': '#afafdf', '147': '#afafff', '148': '#afdf00', '149': '#afdf5f',
    \ '150': '#afdf87', '151': '#afdfaf', '152': '#afdfdf', '153': '#afdfff', '154': '#afff00',
    \ '155': '#afff5f', '156': '#afff87', '157': '#afffaf', '158': '#afffdf', '159': '#afffff',
    \ '160': '#df0000', '161': '#df005f', '162': '#df0087', '163': '#df00af', '164': '#df00df',
    \ '165': '#df00ff', '166': '#df5f00', '167': '#df5f5f', '168': '#df5f87', '169': '#df5faf',
    \ '170': '#df5fdf', '171': '#df5fff', '172': '#df8700', '173': '#df875f', '174': '#df8787',
    \ '175': '#df87af', '176': '#df87df', '177': '#df87ff', '178': '#dfaf00', '179': '#dfaf5f',
    \ '180': '#dfaf87', '181': '#dfafaf', '182': '#dfafdf', '183': '#dfafff', '184': '#dfdf00',
    \ '185': '#dfdf5f', '186': '#dfdf87', '187': '#dfdfaf', '188': '#dfdfdf', '189': '#dfdfff',
    \ '190': '#dfff00', '191': '#dfff5f', '192': '#dfff87', '193': '#dfffaf', '194': '#dfffdf',
    \ '195': '#dfffff', '196': '#ff0000', '197': '#ff005f', '198': '#ff0087', '199': '#ff00af',
    \ '200': '#ff00df', '201': '#ff00ff', '202': '#ff5f00', '203': '#ff5f5f', '204': '#ff5f87',
    \ '205': '#ff5faf', '206': '#ff5fdf', '207': '#ff5fff', '208': '#ff8700', '209': '#ff875f',
    \ '210': '#ff8787', '211': '#ff87af', '212': '#ff87df', '213': '#ff87ff', '214': '#ffaf00',
    \ '215': '#ffaf5f', '216': '#ffaf87', '217': '#ffafaf', '218': '#ffafdf', '219': '#ffafff',
    \ '220': '#ffdf00', '221': '#ffdf5f', '222': '#ffdf87', '223': '#ffdfaf', '224': '#ffdfdf',
    \ '225': '#ffdfff', '226': '#ffff00', '227': '#ffff5f', '228': '#ffff87', '229': '#ffffaf',
    \ '230': '#ffffdf', '231': '#ffffff', '232': '#080808', '233': '#121212', '234': '#1c1c1c',
    \ '235': '#262626', '236': '#303030', '237': '#3a3a3a', '238': '#444444', '239': '#4e4e4e',
    \ '240': '#585858', '241': '#606060', '242': '#666666', '243': '#767676', '244': '#808080',
    \ '245': '#8a8a8a', '246': '#949494', '247': '#9e9e9e', '248': '#a8a8a8', '249': '#b2b2b2',
    \ '250': '#bcbcbc', '251': '#c6c6c6', '252': '#d0d0d0', '253': '#dadada', '254': '#e4e4e4',
    \ '255': '#eeeeee', 'fg': 'fg', 'bg': 'bg', 'NONE': 'NONE' }

function! SetColour(name, opts)
	let l:opt_string = ''
	for [l:key, l:val] in items(a:opts)
		if l:key == "fg" || l:key == "bg"
			let l:cterm_color = l:val
			let l:gui_color = s:xterm_colors[substitute(l:val, '^0\+', '', '')]
			let opt_string .= ' cterm' . l:key . '=' . l:cterm_color
			let opt_string .= ' gui' . l:key . '=' . l:gui_color
		else
			let opt_string .= ' ' . key . '=' . val
		endif
	endfor
	exec "highlight "a:name." ".opt_string
endfunction

function! SetFgColour(name, fg)
	call SetColour(a:name, {'fg': a:fg, 'cterm': 'NONE', 'gui': 'NONE', 'bg': 'NONE'})
endfunction

function! SetBgColour(name, bg)
	call SetColour(a:name, {'fg': '016', 'cterm': 'NONE', 'gui': 'NONE', 'bg': a:bg})
endfunction

" highlight  guibg=NONE

call SetColour("Normal", {'fg': '252', 'ctermbg': 'NONE', 'guibg': 'NONE'})
call SetFgColour("NonText", "239")

" Pinky values for values
call SetFgColour("Constant", "165")
call SetFgColour("Tag", "165")
call SetFgColour("String", "169")
call SetFgColour("Character", "169")
call SetFgColour("Number", "164")
call SetFgColour("Float", "164")
call SetFgColour("Boolean", "129")
call SetFgColour("Keyword", "129")
call SetColour("Exception", {'ctermfg': '165', 'guifg': '#d700ff', 'ctermbg': 'NONE'})

" Functions and identifiers get bluey colours
call SetFgColour("Identifier", "32")
call SetFgColour("Function", "26")
call SetFgColour("Label", "24")

" Statements (if, while, case) and operators (+, -) get green colours
call SetFgColour("Statement", "40")
call SetFgColour("Conditional", "40")
call SetFgColour("Operator", "70")
call SetFgColour("Repeat", "40")
call SetFgColour("Delimiter", "40")

" Type keywords (int, char, string, etc) are yellow
call SetFgColour("Type", "yellow")
call SetFgColour("TypeDef", "yellow")
call SetFgColour("Structure", "yellow")

" Special terms get brown colours
call SetFgColour("Special", "brown")
call SetFgColour("PreProc", "brown")

" RED
call SetColour("Error", {'ctermbg': 'red', 'ctermfg': 'black', 'cterm': 'bold', 'guifg': '#ff0000', 'guibg': 'black', 'gui': 'bold'})
call SetColour("ColorColumn", {'ctermbg': '233', 'guibg': '#222233', 'fg': 'NONE', 'cterm': 'NONE', 'gui': 'NONE'})

" Invert TODO tags
call SetColour("TODO", {'ctermfg': 'black', 'ctermbg': 'LightBlue', 'cterm': 'NONE', 'guifg': 'black', 'guibg': '#00ffff'})

" diffsplit highlighting
" Green/red/blue backgrounds for diff add/delete/change
highlight DiffAdd ctermbg=22 guibg=#002200
highlight DiffDelete ctermbg=52 guibg=#331111 guifg=#ff0000
highlight DiffChange ctermbg=17 guibg=#000033
highlight DiffText ctermbg=202 guibg=#333366

" Diff file highlighting
highlight diffAdded ctermbg=22 guibg=#002200
highlight diffRemoved ctermbg=52 guibg=#331111
highlight diffChanged ctermbg=17 guibg=#000033
highlight diffFile ctermfg=32 guifg=32
highlight diffLine ctermfg=244 guifg=244

call SetFgColour("SpecialKey", "239")

call SetColour("Folded", {'ctermfg': '5', 'ctermbg': '0', 'guifg': '#800080', 'guibg': 'black'})
call SetColour("SignColumn", {'ctermbg': 'NONE', 'guibg': 'NONE'})
call SetColour("SyntasticErrorSign", {'ctermbg': 'red', 'ctermfg': 'black'})
call SetColour("SyntasticWarningSign", {'ctermbg': 'yellow', 'ctermfg': 'black'})

call SetColour("Visual", {'fg': 'NONE', 'bg': '238'})
call SetColour("Cursor", {'fg': 'black', 'bg': '250'})

function! SourceColours()
	" The environment variables are not always present, for example if vim is
	" run via sudo. This script loads the environment variables from the
	" colours.sh script.
	let l:exportRe = '^\s*export\s\+'
	let l:colours = readfile($HOME."/.bashrc.d/colours.sh")
	for line in colours
		if l:line =~# l:exportRe
			let l:envSet = substitute(l:line, l:exportRe, "let $", "")
			exec l:envSet
		endif
	endfor
endfunction

if !exists("$VIM_ACTIVE")
	call SourceColours()
endif

if exists("$VIM_ACTIVE")
	let active = $VIM_ACTIVE
	let inactive = $VIM_INACTIVE
	let fill = $VIM_FILL
else
	let active = 117
	let inactive = 27
	let fill = 17
endif

call SetBgColour("StatusLine", active)
call SetBgColour("TabLineSel", active)
call SetBgColour("User1", active)

call SetBgColour("StatusLineNC", inactive)
call SetBgColour("TabLine", inactive)
call SetBgColour("StatusLineDull", inactive)

call SetBgColour("TabLineFill", fill)
call SetBgColour("StatusLineFill", fill)

call SetFgColour("TabLineLeft", active)
call SetFgColour("VertSplit", fill)

call SetColour("TabLineInvert", {'ctermfg': inactive, 'ctermbg': '016', 'cterm': 'NONE'})

call SetFgColour("LineNr", 242)
highlight clear CursorLine
call SetFgColour("CursorLineNr", 248)
call SetFgColour("Conceal", active)
call SetColour("MatchParen", {'fg': '33', 'bg': active})

call SetColour("NormalFloat", {'fg': 'NONE', 'bg': 'NONE'})
call SetColour("FloatBorder", {'fg': '17', 'bg': 'NONE'})
