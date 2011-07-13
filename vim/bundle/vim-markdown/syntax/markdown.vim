" Vim syntax file
" Language:	Markdown
" Maintainer:	Ben Williams <benw@plasticboy.com>
" URL:		http://plasticboy.com/markdown-vim-mode/
" Version:	9
" Last Change:  2009 May 18 
" Remark:	Uses HTML syntax file
" Remark:	I don't do anything with angle brackets (<>) because that would too easily
"		easily conflict with HTML syntax
" TODO: 	Handle stuff contained within stuff (e.g. headings within blockquotes)


" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

syn spell toplevel
syn case ignore
syn sync linebreaks=1

"additions to HTML groups
syn region htmlBold     start=/\\\@<!\(^\|\A\)\@=\*\@<!\*\*\*\@!/     end=/\\\@<!\*\@<!\*\*\*\@!\($\|\A\)\@=/   contains=@Spell,htmlItalic
syn region htmlItalic   start=/\\\@<!\(^\|\A\)\@=\*\@<!\*\*\@!/       end=/\\\@<!\*\@<!\*\*\@!\($\|\A\)\@=/      contains=htmlBold,@Spell
syn region htmlBold     start=/\\\@<!\(^\|\A\)\@=_\@<!___\@!/         end=/\\\@<!_\@<!___\@!\($\|\A\)\@=/       contains=htmlItalic,@Spell
syn region htmlItalic   start=/\\\@<!\(^\|\A\)\@=_\@<!__\@!/          end=/\\\@<!_\@<!__\@!\($\|\A\)\@=/        contains=htmlBold,@Spell

" [link](URL) | [link][id] | [link][]
syn region mkdLink matchgroup=mkdDelimiter      start="\!\?\[" end="\]\ze\s*[[(]" contains=@Spell nextgroup=mkdURL,mkdID skipwhite oneline
syn region mkdID matchgroup=mkdDelimiter        start="\["    end="\]" contained
syn region mkdURL matchgroup=mkdDelimiter       start="("     end=")"  contained

" Link definitions: [id]: URL (Optional Title)
" TODO handle automatic links without colliding with htmlTag (<URL>)
syn region mkdLinkDef matchgroup=mkdDelimiter   start="^ \{,3}\zs\[" end="]:" oneline nextgroup=mkdLinkDefTarget skipwhite
syn region mkdLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]"   contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+"+     end=+"+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+'+     end=+'+  contained
syn region mkdLinkTitle matchgroup=mkdDelimiter start=+(+     end=+)+  contained

"define Markdown groups
syn match  mkdLineContinue ".$" contained
syn match  mkdRule      /^\s*\*\s\{0,1}\*\s\{0,1}\*$/
syn match  mkdRule      /^\s*-\s\{0,1}-\s\{0,1}-$/
syn match  mkdRule      /^\s*_\s\{0,1}_\s\{0,1}_$/
syn match  mkdRule      /^\s*-\{3,}$/
syn match  mkdRule      /^\s*\*\{3,5}$/
syn match  mkdListItem  "^\s*[-*+]\s\+"
syn match  mkdListItem  "^\s*\d\+\.\s\+"
syn match  mkdCode      /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/
syn match  mkdLineBreak /  \+$/
syn region mkdCode      start=/\\\@<!`/		end=/\\\@<!`/
syn region mkdCode      start=/\s*``[^`]*/	end=/[^`]*``\s*/
syn region mkdBlockquote start=/^\s*>/		end=/$/                 contains=mkdLineBreak,mkdLineContinue,@Spell
syn region mkdCode      start="<pre[^>]*>"	end="</pre>"
syn region mkdCode      start="<code[^>]*>"	end="</code>"
syn region mkdCode	start=/^``[^`]*/	end=/[^`]*``.*/

"HTML headings
syn region mkdH1       start="^\s*#"                   end="\($\|#\+\)" contains=@Spell
syn region mkdH2       start="^\s*##"                  end="\($\|#\+\)" contains=@Spell
syn region mkdH3       start="^\s*###"                 end="\($\|#\+\)" contains=@Spell
syn region mkdH4       start="^\s*####"                end="\($\|#\+\)" contains=@Spell
syn region mkdH5       start="^\s*#####"               end="\($\|#\+\)" contains=@Spell
syn region mkdH6       start="^\s*######"              end="\($\|#\+\)" contains=@Spell
syn match  mkdH1       /^.\+\n=\+$/ contains=@Spell
syn match  mkdH2       /^.\+\n-\+$/ contains=@Spell

"highlighting for Markdown groups
HtmlHiLink mkdString	    String
HtmlHiLink mkdCode          Identifier
HtmlHiLink mkdBlockquote    Comment
HtmlHiLink mkdLineContinue  Comment
HtmlHiLink mkdListItem      Identifier
HtmlHiLink mkdRule          Identifier
HtmlHiLink mkdLineBreak     Todo
HtmlHiLink mkdLink          htmlLink
HtmlHiLink mkdURL           htmlString
HtmlHiLink mkdID            Identifier
HtmlHiLink mkdLinkDef       mkdID
HtmlHiLink mkdLinkDefTarget mkdURL
HtmlHiLink mkdLinkTitle     htmlString

HtmlHiLink mkdH1            Label
HtmlHiLink mkdH2            Label
HtmlHiLink mkdH3            Label
HtmlHiLink mkdH4            Label
HtmlHiLink mkdH5            Label
HtmlHiLink mkdH6            Label

HtmlHiLink mkdDelimiter     Delimiter

let b:current_syntax = "mkd"

delcommand HtmlHiLink
" vim: ts=8
