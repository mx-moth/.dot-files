" Vim syntax file
" Language:	JSON
" Maintainer:	Jeroen Ruigrok van der Werven <asmodai@in-nomine.org>
" Last Change:	2009-06-16
" Version:      0.4

" Syntax setup
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded

if !exists("main_syntax")
	if version < 600
		syntax clear
	elseif exists("b:current_syntax")
		finish
	endif
	let main_syntax = 'json'
endif

" This is the only top level element allowed. A JSON document can be any json value
syn match	jsonDoc		""	nextgroup=@jsonValue

" Syntax: A JSON array starts with a [, has many jsonValues, and then ends with a ]
syn region	jsonArray	start=+\[+	end=+\]+	contains=@jsonValue fold skipwhite contained skipwhite skipnl skipempty

" Syntax: Strings
syn region	jsonString	start=+"+	skip=+\\\\\|\\"+	end=+"+	contains=jsonEscape contained
syn region	jsonStringSQ	start=+'+	skip=+\\\\\|\\"+	end=+'+

syn region	jsonObject	start=+{+	end=+}+ 	contains=jsonObjectKey,jsonObject,jsonArray fold skipwhite contained skipwhite skipnl skipempty
syn region	jsonObjectKey	matchGroup=jsonObject start=+"+	skip=+\\\\\|\\"+	end=+"[ 	\n\r]*:+	nextgroup=@jsonValue contained skipwhite skipnl skipempty

" Syntax: Escape sequences
syn match	jsonEscape	"\\["\\/bfnrt]" contained
syn match	jsonEscape	"\\u\x\{4}" contained

" Syntax: Numbers
syn match	jsonNumber	"-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>" contained
syn match	jsonNumError	"-\=\<0\d\.\d*\>" contained

" Syntax: Boolean
syn keyword jsonBoolean	true false contained

" Syntax: Null
syn keyword jsonNull	null contained

" Syntax: Braces
syn match jsonBrace +[\[\]{}]+ contained

syn cluster jsonValue	contains=jsonArray,jsonString,jsonObject,jsonNumber,jsonBoolean,jsonNull

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_json_syn_inits")
	if version < 508
		let did_json_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif
	HiLink jsonObject	Operator
	HiLink jsonArray	Operator

	HiLink jsonObjectKey	Identifier

	HiLink jsonString	String
	HiLink jsonEscape	Special
	HiLink jsonNumber	Number
	HiLink jsonNull		Keyword
	HiLink jsonBoolean	Boolean

	HiLink jsonNumError	Error
	HiLink jsonBadComma	Error
	HiLink jsonStringSQ	Error
	delcommand HiLink
endif

let b:current_syntax = "json"
if main_syntax == 'json'
	unlet main_syntax
endif

" Vim settings {{{2
" vim: ts=8 fdm=marker
