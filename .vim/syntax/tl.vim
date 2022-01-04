" Vim syntax file
" Language: Translation File
" Maintainer: Raphaël Duhen
" Latest Revision: 29 August 2021

if exists("b:current_syntax")
	finish
endif
let b:current_syntax = "tl"

syn match tlTitle '\[.*\]'
syn match tlPage '[ \t]*Page \d\+'
syn match tlPanel '[ \t]*Panel \d\+'
syn match tlTextNumber '[ \t]\d\+[.:]'
syn match tlNote '[ \t]*NOTE:.*$'
syn match tlNote '[ \t]*LEGACY:.*$'
syn match tlNote '[ \t]*RAW:.*$'

hi def link tlTitle PreProc
hi def link tlPage Type
hi def link tlPanel Type
hi def link tlTextNumber Statement
hi def link tlNote Comment
