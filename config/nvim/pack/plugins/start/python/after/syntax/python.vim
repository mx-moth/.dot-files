" we need the conceal feature (vim ≥ 7.3)
if !has('conceal')
    finish
endif

" remove the keywords. we'll re-add them below
syntax clear pythonOperator

syntax match pythonOperator "\<is\>"
syntax match pythonOperator "[[\]{}<>()=!&|~:.]"

syntax match pyNiceOperator "\<in\>" conceal cchar=∈
syntax match pyNiceOperator "\<or\>" conceal cchar=∨
syntax match pyNiceOperator "\<and\>" conceal cchar=∧
" include the space after “not” – if present – so that “not a” becomes “¬a”.
" also, don't hide “not” behind  ‘¬’ if it is after “is ”.
syntax match pyNiceOperator "\%(is \)\@<!\<not\%( \|\>\)" conceal cchar=¬
syntax match pyNiceOperator "\<not in\>" conceal cchar=∉
syntax match pyNiceOperator "<=" conceal cchar=≤
syntax match pyNiceOperator ">=" conceal cchar=≥
" only conceal “==” if alone, to avoid concealing SCM conflict markers
syntax match pyNiceOperator "=\@<!===\@!" conceal cchar=≅
syntax match pyNiceOperator "!=" conceal cchar=≆

syntax match pyNiceOperator "\<is not\>" conceal cchar=≢
syntax match pyNiceOperator "\<is\>\%( not\>\)\@!" conceal cchar=≡
" ≔ ≇ ≃ ≄ ≈ ≉ ≅ ≆ ≡ ≢

syntax keyword pyNiceOperator sum conceal cchar=∑
syntax match pyNiceOperator "\<\%(math\.\)\?sqrt\>" conceal cchar=√
syntax match pyNiceKeyword "\<\%(math\.\)\?pi\>" conceal cchar=π

syntax keyword pyNiceOperator return conceal cchar=«
syntax keyword pyNiceOperator yield conceal cchar=⟷
syntax keyword pyNiceOperator raise conceal cchar=^
syntax keyword pyNiceOperator def conceal cchar=ƒ
syntax keyword pyNiceOperator for conceal cchar=∀

syntax match pyNiceOperator "\.\@<!\<any\>\ze(" conceal cchar=∃
syntax match pyNiceOperator "\<not any\>" conceal cchar=∄
syntax match pyNiceOperator "\.\@<!\<all\>\ze(" conceal cchar=∀

syntax keyword pyNiceStatement lambda conceal cchar=λ

hi link pyNiceOperator Operator
hi link pyNiceStatement Statement
hi link pyNiceKeyword Keyword
hi link pythonInclude Statement

