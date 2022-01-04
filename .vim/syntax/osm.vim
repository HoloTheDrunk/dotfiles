" Vim syntax file
" Language: Open Street Maps Overpass Query
" Maintainer: Raphaël Duhen
" Latest Revision: 25 August 2021

if exists("b:current_syntax")
	finish
endif
let b:current_syntax = "osm"

syn keyword osmFunction around

syn keyword osmOutputSet ids tags skel body meta

syn match osmFilter '\[\"\a\+:\?\a*\"]' 
syn match osmFilter '\[\"\a\+:\?\a*\"=\".*\"\]'
syn match osmFilter '(\a\+:.*)'
syn match osmFilter '([0-9 \-+.,]\+)'
syn keyword osmDataType node way relation nw nr wr nwr nextgroup=osmFilter

syn match osmDataFlow '-\?>'
syn match osmDataFlow '<'

syn match osmBbox '\[bbox:.*\]'
syn match osmOut '\(\..+ \)\?out '

syn match osmDataRegister '\.\a\+'
syn match osmDataRegister '\._'

syn match osmParameter '\[\(out\|timeout\):.*\]'

syn keyword osmTodo contained TODO FIXME XXX NOTE !
syn match osmComment '//.*$' contains=osmTodo

syn region union start='(' end=')' fold transparent contains=osmDataType,osmFunction,osmDataFlow,osmFilter,osmDataRegister

hi def link osmDataType	Type
hi def link osmBbox	Function
hi def link osmOut Function
hi def link osmParameter PreProc
hi def link osmTodo	Todo
hi def link osmComment Comment
hi def link osmDataFlow Statement
hi def link osmFilter Special
hi def link osmDataRegister Constant
hi def link osmOutputSet Constant
hi def link osmFunction	Function
