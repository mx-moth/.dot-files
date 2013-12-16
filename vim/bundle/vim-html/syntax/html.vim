" Vim syntax file
" Language:	HTML
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" URL:		http://www.fleiner.com/vim/syntax/html.vim
" Last Change:  2006 Jun 19

" Please check :help html.vim for some comments and a description of the options

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'html'
endif

" don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

syntax spell toplevel

syn case ignore

" mark illegal characters
syn match htmlError "[<>&]"


" tags
syn region  htmlString   contained start=+"+ end=+"+ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc
syn region  htmlString   contained start=+'+ end=+'+ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc
syn match   htmlValue    contained "=[\t ]*[^'" \t>][^ \t>]*"hs=s+1   contains=javaScriptExpression,@htmlPreproc
syn region  htmlEndTag             start=+</+      end=+>+ contains=htmlTagN,htmlTagError
syn region  htmlTag                start=+<[^/]+   end=+>+ contains=htmlTagN,htmlAttr,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc
syn match   htmlTagN     contained +<\s*[-a-zA-Z0-9:]\++hs=s+1 contains=htmlSpecialTagName,@htmlTagNameCluster
syn match   htmlTagN     contained +</\s*[-a-zA-Z0-9:]\++hs=s+2 contains=htmlSpecialTagName,@htmlTagNameCluster
syn match   htmlTagError contained "[^>]<"ms=s+1


syn match   htmlAttr     contained /\<[a-zA-Z0-9:-]\+/ nextgroup=htmlAttr
syn match   htmlAttr     contained /\<[a-zA-Z0-9:-]\+=/he=e-1 nextgroup=htmlValue,htmlString,htmlAttr


" special characters
syn match htmlSpecialChar "&#\=[0-9A-Za-z]\{1,8};"

" Comments (the real ones or the old netscape ones)
if exists("html_wrong_comments")
  syn region htmlComment                start=+<!--+    end=+--\s*>+
else
  syn region htmlComment                start=+<!+      end=+>+   contains=htmlCommentPart,htmlCommentError
  syn match  htmlCommentError contained "[^><!]"
  syn region htmlCommentPart  contained start=+--+      end=+--\s*+  contains=@htmlPreProc
endif
syn region htmlComment                  start=+<!DOCTYPE+ keepend end=+>+

" server-parsed commands
syn region htmlPreProc start=+<!--#+ end=+-->+ contains=htmlPreStmt,htmlPreError,htmlPreAttr
syn match htmlPreStmt contained "<!--#\(config\|echo\|exec\|fsize\|flastmod\|include\|printenv\|set\|if\|elif\|else\|endif\|geoguide\)\>"
syn match htmlPreError contained "<!--#\S*"ms=s+4
syn match htmlPreAttr contained "\w\+=[^"]\S\+" contains=htmlPreProcAttrError,htmlPreProcAttrName
syn region htmlPreAttr contained start=+\w\+="+ skip=+\\\\\|\\"+ end=+"+ contains=htmlPreProcAttrName keepend
syn match htmlPreProcAttrError contained "\w\+="he=e-1
syn match htmlPreProcAttrName contained "\(expr\|errmsg\|sizefmt\|timefmt\|var\|cgi\|cmd\|file\|virtual\|value\)="he=e-1

if !exists("html_no_rendering")
  " rendering
  syn cluster htmlTop contains=@Spell,htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,javaScriptTag,javaScriptDollar,@htmlPreproc

  syn region htmlBold start="<b\>" end="</b>"me=e-4 contains=@htmlTop,htmlBoldUnderline,htmlBoldItalic
  syn region htmlBold start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop,htmlBoldUnderline,htmlBoldItalic
  syn region htmlBoldUnderline contained start="<u\>" end="</u>"me=e-4 contains=@htmlTop,htmlBoldUnderlineItalic
  syn region htmlBoldItalic contained start="<i\>" end="</i>"me=e-4 contains=@htmlTop,htmlBoldItalicUnderline
  syn region htmlBoldItalic contained start="<em\>" end="</em>"me=e-5 contains=@htmlTop,htmlBoldItalicUnderline
  syn region htmlBoldUnderlineItalic contained start="<i\>" end="</i>"me=e-4 contains=@htmlTop
  syn region htmlBoldUnderlineItalic contained start="<em\>" end="</em>"me=e-5 contains=@htmlTop
  syn region htmlBoldItalicUnderline contained start="<u\>" end="</u>"me=e-4 contains=@htmlTop,htmlBoldUnderlineItalic

  syn region htmlUnderline start="<u\>" end="</u>"me=e-4 contains=@htmlTop,htmlUnderlineBold,htmlUnderlineItalic
  syn region htmlUnderlineBold contained start="<b\>" end="</b>"me=e-4 contains=@htmlTop,htmlUnderlineBoldItalic
  syn region htmlUnderlineBold contained start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop,htmlUnderlineBoldItalic
  syn region htmlUnderlineItalic contained start="<i\>" end="</i>"me=e-4 contains=@htmlTop,htmlUnderlineItalicBold
  syn region htmlUnderlineItalic contained start="<em\>" end="</em>"me=e-5 contains=@htmlTop,htmlUnderlineItalicBold
  syn region htmlUnderlineItalicBold contained start="<b\>" end="</b>"me=e-4 contains=@htmlTop
  syn region htmlUnderlineItalicBold contained start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop
  syn region htmlUnderlineBoldItalic contained start="<i\>" end="</i>"me=e-4 contains=@htmlTop
  syn region htmlUnderlineBoldItalic contained start="<em\>" end="</em>"me=e-5 contains=@htmlTop

  syn region htmlItalic start="<i\>" end="</i>"me=e-4 contains=@htmlTop,htmlItalicBold,htmlItalicUnderline
  syn region htmlItalic start="<em\>" end="</em>"me=e-5 contains=@htmlTop
  syn region htmlItalicBold contained start="<b\>" end="</b>"me=e-4 contains=@htmlTop,htmlItalicBoldUnderline
  syn region htmlItalicBold contained start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop,htmlItalicBoldUnderline
  syn region htmlItalicBoldUnderline contained start="<u\>" end="</u>"me=e-4 contains=@htmlTop
  syn region htmlItalicUnderline contained start="<u\>" end="</u>"me=e-4 contains=@htmlTop,htmlItalicUnderlineBold
  syn region htmlItalicUnderlineBold contained start="<b\>" end="</b>"me=e-4 contains=@htmlTop
  syn region htmlItalicUnderlineBold contained start="<strong\>" end="</strong>"me=e-9 contains=@htmlTop

  syn region htmlLink start="<a\>\_[^>]*\<href\>" end="</a>"me=e-4 contains=@Spell,htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,javaScriptTag,javaScriptDollar,@htmlPreproc
  syn region htmlH1 start="<h1\>" end="</h1>"me=e-5 contains=@htmlTop
  syn region htmlH2 start="<h2\>" end="</h2>"me=e-5 contains=@htmlTop
  syn region htmlH3 start="<h3\>" end="</h3>"me=e-5 contains=@htmlTop
  syn region htmlH4 start="<h4\>" end="</h4>"me=e-5 contains=@htmlTop
  syn region htmlH5 start="<h5\>" end="</h5>"me=e-5 contains=@htmlTop
  syn region htmlH6 start="<h6\>" end="</h6>"me=e-5 contains=@htmlTop
  syn region htmlHead start="<head\>" end="</head>"me=e-7 end="<body\>"me=e-5 end="<h[1-6]\>"me=e-3 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,htmlLink,htmlTitle,javaScriptTag,javaScriptDollar,cssStyle,@htmlPreproc
  syn region htmlTitle start="<title\>" end="</title>"me=e-8 contains=htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,javaScriptTag,javaScriptDollar,@htmlPreproc
endif

syn keyword htmlTagName         contained noscript
if main_syntax != 'java' || exists("java_javascript")
  " JAVA SCRIPT
  syn include @htmlJavaScript syntax/javascript.vim
  unlet b:current_syntax
  syn region  javaScript start=+azazaza+ end=+azazazaaaa+ contains=javaScriptTag,javaScriptDollar
  syn region  javaScriptTag    start=+<script[^>]*>+ms=e keepend end=+</script>+me=s-1 contains=@htmlJavaScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc
  syn region  javaScriptDollar start=+\$\(code\|include\)(+ end=+)+ contains=@htmlJavaScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc

  " html events (i.e. arguments that include javascript commands)
  if exists("html_extended_events")
    syn region htmlEvent        contained start=+\<on\a\+\s*=[\t ]*'+ end=+'+ contains=htmlEventSQ
    syn region htmlEvent        contained start=+\<on\a\+\s*=[\t ]*"+ end=+"+ contains=htmlEventDQ
  else
    syn region htmlEvent        contained start=+\<on\a\+\s*=[\t ]*'+ end=+'+ keepend contains=htmlEventSQ
    syn region htmlEvent        contained start=+\<on\a\+\s*=[\t ]*"+ end=+"+ keepend contains=htmlEventDQ
  endif
  syn region htmlEventSQ        contained start=+'+ms=s+1 end=+'+me=s-1 contains=@htmlJavaScript
  syn region htmlEventDQ        contained start=+"+ms=s+1 end=+"+me=s-1 contains=@htmlJavaScript
  HtmlHiLink htmlEventSQ htmlEvent
  HtmlHiLink htmlEventDQ htmlEvent

  " a javascript expression is used as an arg value
  syn region  javaScriptExpression contained start=+&{+ keepend end=+};+ contains=@htmlJavaScript,@htmlPreproc
endif

if main_syntax != 'java' || exists("java_css")
  " embedded style sheets
  syn keyword htmlArg           contained media
  syn include @htmlCss syntax/css.vim
  unlet b:current_syntax
  syn region cssStyle start=+<style+ keepend end=+</style>+ contains=@htmlCss,htmlTag,htmlEndTag,htmlCssStyleComment,@htmlPreproc
  syn match htmlCssStyleComment contained "\(<!--\|-->\)"
  syn region htmlCssDefinition matchgroup=htmlArg start='style="' keepend matchgroup=htmlString end='"' contains=css.*Attr,css.*Prop,cssComment,cssLength,cssColor,cssURL,cssImportant,cssError,cssString,@htmlPreproc
  HtmlHiLink htmlStyleArg htmlString
endif

if main_syntax == "html"
  " synchronizing (does not always work if a comment includes legal
  " html tags, but doing it right would mean to always start
  " at the first line, which is too slow)
  syn sync match htmlHighlight groupthere NONE "<[/a-zA-Z]"
  syn sync match htmlHighlight groupthere javaScript "<script"
  syn sync match htmlHighlightSkip "^.*['\"].*$"
  syn sync minlines=10
endif

" The default highlighting.
if version >= 508 || !exists("did_html_syn_inits")
  if version < 508
    let did_html_syn_inits = 1
  endif
  hi def htmlTag                     ctermfg=Darkgray
  hi def htmlEndTag                  ctermfg=Darkgray
  HtmlHiLink htmlTagN                    Function
  HtmlHiLink htmlSpecialTagName          Exception
  HtmlHiLink htmlValue                   String
  HtmlHiLink htmlSpecialChar             Special
  HtmlHiLink htmlAttr                    Keyword
  
  if !exists("html_no_rendering")
    HtmlHiLink htmlH1                      Title
    HtmlHiLink htmlH2                      htmlH1
    HtmlHiLink htmlH3                      htmlH2
    HtmlHiLink htmlH4                      htmlH3
    HtmlHiLink htmlH5                      htmlH4
    HtmlHiLink htmlH6                      htmlH5
    HtmlHiLink htmlHead                    PreProc
    HtmlHiLink htmlTitle                   Title
    HtmlHiLink htmlBoldItalicUnderline     htmlBoldUnderlineItalic
    HtmlHiLink htmlUnderlineBold           htmlBoldUnderline
    HtmlHiLink htmlUnderlineItalicBold     htmlBoldUnderlineItalic
    HtmlHiLink htmlUnderlineBoldItalic     htmlBoldUnderlineItalic
    HtmlHiLink htmlItalicUnderline         htmlUnderlineItalic
    HtmlHiLink htmlItalicBold              htmlBoldItalic
    HtmlHiLink htmlItalicBoldUnderline     htmlBoldUnderlineItalic
    HtmlHiLink htmlItalicUnderlineBold     htmlBoldUnderlineItalic
    HtmlHiLink htmlLink                    htmlBold
    if !exists("html_my_rendering")
      hi def htmlBold                term=bold cterm=bold gui=bold
      hi def htmlBoldUnderline       term=bold,underline cterm=bold,underline gui=bold,underline
      hi def htmlBoldItalic          term=bold,italic cterm=bold,italic gui=bold,italic
      hi def htmlBoldUnderlineItalic term=bold,italic,underline cterm=bold,italic,underline gui=bold,italic,underline
      hi def htmlUnderline           term=underline cterm=underline gui=underline
      hi def htmlUnderlineItalic     term=italic,underline cterm=italic,underline gui=italic,underline
      hi def htmlItalic              term=italic cterm=italic gui=italic
    endif
  endif
  
  HtmlHiLink htmlPreStmt            PreProc
  HtmlHiLink htmlPreError           Error
  HtmlHiLink htmlPreProc            PreProc
  HtmlHiLink htmlPreAttr            String
  HtmlHiLink htmlPreProcAttrName    PreProc
  HtmlHiLink htmlPreProcAttrError   Error
  HtmlHiLink htmlSpecial            Special
  HtmlHiLink htmlSpecialChar        Special
  HtmlHiLink htmlStatement          Statement

  HtmlHiLink htmlComment            Comment
  HtmlHiLink htmlCommentPart        Comment

  HtmlHiLink htmlString             String
  HtmlHiLink htmlValue              String

  HtmlHiLink htmlCommentError       htmlError
  HtmlHiLink htmlTagError           htmlError
  HtmlHiLink htmlError              Error
  
  HtmlHiLink htmlCssStyleComment    Comment
  HtmlHiLink htmlCssDefinition      Special
endif

delcommand HtmlHiLink

let b:current_syntax = "html"

if main_syntax == 'html'
  unlet main_syntax
endif

" vim: ts=8
