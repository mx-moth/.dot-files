" Vim syntax file
" Language:     JavaScript
" Maintainer:   Yi Zhao (ZHAOYI) <zzlinux AT hotmail DOT com>
" Last Change:  June 4, 2009
" Version:      0.7.7
" Changes:      Add "undefined" as a type keyword
"
" TODO:
"  - Add the HTML syntax inside the JSDoc

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
endif

"" Drop fold if it set but VIM doesn't support it.
let b:javascript_fold='true'
if version < 600    " Don't support the old version
  unlet! b:javascript_fold
endif

"" dollar sigh is permittd anywhere in an identifier
setlocal iskeyword+=$

syntax sync fromstart

"" JavaScript comments
syntax keyword javaScriptCommentTodo    TODO FIXME XXX TBD contained
syntax region  javaScriptLineComment    start=+\/\/+ end=+$+ keepend contains=javaScriptCommentTodo,@Spell
syntax region  javaScriptLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend contains=javaScriptCommentTodo,@Spell fold
syntax region  javaScriptCvsTag         start="\$\cid:" end="\$" oneline contained
syntax region  javaScriptComment        start="/\*"  end="\*/" contains=javaScriptCommentTodo,javaScriptCvsTag,@Spell fold
syntax region  javaScriptHashBang       start="^#!"  end="$"

"" JSDoc support start
if !exists("javascript_ignore_javaScriptdoc")
  syntax case ignore

  "" syntax coloring for javadoc comments (HTML)
  "syntax include @javaHtml <sfile>:p:h/html.vim
  "unlet b:current_syntax

  syntax region javaScriptDocComment    matchgroup=javaScriptComment start="/\*\*\s*$"  end="\*/" contains=javaScriptDocAtTag,javaScriptCommentTodo,javaScriptCvsTag,@javaScriptHtml,@Spell fold
  syntax match  javaScriptDocAtTag      contained "@" nextgroup=javaScriptDocTags
  syntax match  javaScriptDocTags       contained "\(param\|argument\|requires\|exception\|throws\|type\|class\|extends\|see\|link\|member\|module\|method\|title\|namespace\|optional\|default\|base\|file\)\>" nextgroup=javaScriptDocSeeTag,javaScriptDocParam,javaScriptDocTypeParam skipwhite
  syntax match  javaScriptDocTags       contained "\(beta\|deprecated\|description\|fileoverview\|author\|license\|version\|returns\=\|constructor\|private\|protected\|final\|ignore\|addon\|exec\)\>"
  
  syntax match  javaScriptDocParam      contained "\%(#\|\w\|\.\|:\|\/\)\+"
  syntax match  javaScriptDocTypeParam  contained "{\%(#\|\w\|\.\|:\|\/\)\+}" nextgroup=javaScriptDocParam skipwhite
  syntax region javaScriptDocSeeTag     contained matchgroup=javaScriptDocSeeTag start="{@" end="}" contains=javaScriptDocTags

  syntax case match
endif   "" JSDoc end

syntax case match

"" Syntax in the JavaScript code
syntax match   javaScriptSpecial        "\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\."
syntax region  javaScriptStringD        start=+"+  skip=+\\\\\|\\$"+  end=+"+  contains=javaScriptSpecial
syntax region  javaScriptStringS        start=+'+  skip=+\\\\\|\\$'+  end=+'+  contains=javaScriptSpecial
syntax region  javaScriptRegexpString   start=+/\(\*\|/\)\@!+ skip=+\\\\\|\\/+ end=+/[gim]\{,3}+ contains=javaScriptSpecial oneline
syntax match   javaScriptNumber         /\<-\=\d\+L\=\>\|\<0[xX]\x\+\>/
syntax match   javaScriptFloat          /\<-\=\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
syntax match   javaScriptLabel          /\(?\s*\)\@<!\<[[:alnum:]$_-]\+\(\s*:\)\@=/

" Operator
syn match javaScriptOperator "[-=+%^&|*!.~?:]" contained display
syn match javaScriptOperator "[-+*/%^&|.]="  contained display
syn match javaScriptOperator "/[^*/]"me=e-1  contained display
syn match javaScriptOperator "&&\|\<and\>" contained display
syn match javaScriptOperator "||\|\<or\>" contained display
syn match javaScriptBracket "[(){}[\]]" display
syn match javaScriptRelation "[!=<>]=" contained display
syn match javaScriptRelation "[<>]"  contained display

"" JavaScript Prototype
syntax keyword javaScriptPrototype      prototype

"" Program Keywords
syntax keyword javaScriptSource         import export
syntax keyword javaScriptType           const undefined var void
syntax keyword javaScriptOperator       delete new in instanceof let typeof yeild
syntax keyword javaScriptBoolean        true false
syntax keyword javaScriptNull           null
syntax keyword javaScriptThis			this

"" Statement Keywords
syntax keyword javaScriptConditional    if else switch try catch finally
syntax keyword javaScriptRepeat         do while for
syntax keyword javaScriptBranch         break continue case default
syntax keyword javaScriptStatement      throw with return

syntax match javaScriptClass  "\<[A-Z][a-zA-Z0-9]*\>"

syntax keyword javaScriptExceptions     Error EvalError RangeError ReferenceError SyntaxError TypeError URIError

syntax keyword javaScriptFutureKeys     abstract enum int short boolean export interface static byte extends long super char final native synchronized class float package throws const goto private transient debugger implements protected volatile double import public

"" Code blocks
syntax cluster javaScriptAll       contains=javaScriptComment,javaScriptLineComment,javaScriptDocComment,javaScriptStringD,javaScriptStringS,javaScriptRegexpString,javaScriptNumber,javaScriptFloat,javaScriptLabel,javaScriptSource,javaScriptType,javaScriptOperator,javaScriptBoolean,javaScriptNull,javaScriptFunction,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptStatement,javaScriptClass,javaScriptExceptions,javaScriptFutureKeysjavaScriptDotNotation
syntax region  javaScriptBracket   matchgroup=javaScriptBracket start="\["he=e matchgroup=javaScriptBracket end="\]" transparent contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock
syntax region  javaScriptParen     matchgroup=javaScriptParen   start="("he=e  matchgroup=javaScriptParen end=")" transparent contains=@javaScriptAll,javaScriptParen,javaScriptBracket,javaScriptBlock
syntax region  javaScriptBlock     matchgroup=javaScriptBlock   start="{"he=e  matchgroup=javaScriptBlock end="}" transparent contains=@javaScriptAll,javaScriptParen,javaScriptBracket,javaScriptBlock

if main_syntax == "javascript"
  syntax sync clear
  syntax sync ccomment javaScriptComment minlines=200
  syntax sync match javaScriptHighlight grouphere javaScriptBlock /{/
endif

"" Fold control
if exists("b:javascript_fold")
	"syntax match   javaScriptFunction       /\<function\>/ nextgroup=javaScriptFuncName skipwhite
	syntax match   javaScriptFunction       /\<function\>/ nextgroup=javaScriptFuncBlock skipwhite
    syntax match   javaScriptOpAssign       /=\@<!=/ nextgroup=javaScriptFuncBlock skipwhite skipempty
    
	" syntax region  javaScriptFuncName       contained matchgroup=javaScriptFuncName start=/\%(\$\|\w\)*\s*(/he=e end=/)/hs=s,hle=e contains=javaScriptLineComment,javaScriptComment nextgroup=javaScriptFuncBlock skipwhite skipempty
    syntax region  javaScriptFuncBlock      contained matchgroup=javaScriptFuncBlock start="{"he=e end="}" transparent contains=@javaScriptAll,javaScriptParen,javaScriptBracket,javaScriptBlock fold

    if &l:filetype=='javascript' && !&diff
      " Fold setting
      " Redefine the foldtext (to show a JS function outline) and foldlevel
      " only if the entire buffer is JavaScript, but not if JavaScript syntax
      " is embedded in another syntax (e.g. HTML).
      setlocal foldmethod=syntax
      setlocal foldlevel=4
    endif
else
    syntax keyword javaScriptFunction       function
    setlocal foldmethod<
    setlocal foldlevel<
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink javaScriptComment              Comment
  HiLink javaScriptLineComment          Comment
  HiLink javaScriptDocComment           Comment
  HiLink javaScriptHashBang             Comment
  HiLink javaScriptCommentTodo          Todo
  HiLink javaScriptCvsTag               Function
  HiLink javaScriptDocAtTag             Special
  HiLink javaScriptDocTags              Special
  HiLink javaScriptDocSeeTag            Function
  HiLink javaScriptDocParam             Function
  HiLink javaScriptDocTypeParam         Type

  HiLink javaScriptStringS              String
  HiLink javaScriptStringD              String
  HiLink javaScriptRegexpString         String
  HiLink javaScriptCharacter            Character

  HiLink javaScriptPrototype            Keyword

  HiLink javaScriptConditional          Conditional
  HiLink javaScriptBranch               Conditional
  HiLink javaScriptRepeat               Repeat

  HiLink javaScriptStatement            Statement
  HiLink javaScriptFunction             Operator
  HiLink javaScriptFuncBlock            Operator
  HiLink javaScriptFuncName             Function
  HiLink javaScriptClass        		Identifier

  HiLink javaScriptError                Error

  HiLink javaScriptOperator             Operator
  HiLink javaScriptBracket              Operator
  HiLink javaScriptParen              Operator
  HiLink javaScriptBlock              Operator
  HiLink javaScriptType                 Type
  HiLink javaScriptNull                 Type
  HiLink javaScriptNumber               Number
  HiLink javaScriptFloat                Number
  HiLink javaScriptBoolean              Boolean
  HiLink javaScriptThis                 Keyword

  HiLink javaScriptLabel                Label

  HiLink javaScriptSpecial              Special
  HiLink javaScriptSource               Special
  HiLink javaScriptExceptions           Special

  delcommand HiLink
endif

" Define the htmlJavaScript for HTML syntax html.vim
"syntax clear htmlJavaScript
"syntax clear javaScriptExpression
syntax cluster  htmlJavaScript contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock
syntax cluster  javaScriptExpression contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock,@htmlPreproc

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif

" vim: ts=4
