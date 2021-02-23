" File: ~/.vim/syntax/agda.vim

if exists("b:current_syntax")
  finish
endif

syntax keyword agdaKeyword infix infixl infixr mutual primitive renaming rewrite with syntax postulate forall variable
syntax keyword agdaRecordEntries field constructor
syntax keyword agdaAccess private public abstract
syntax keyword agdaInclude import open using hiding as
syntax keyword agdaStructure data record module where instance
syntax keyword agdaType Set Set0 Set1 Set2 Set3 Nat Real Complex Bool
syntax keyword agdaBool true false
syntax cluster agdaInComment contains=agdaTODO,agdaFIXME,agdaXXX
syntax keyword agdaTODO contained TODO
syntax keyword agdaFIXME contained FIXME
syntax keyword agdaXXX contained XXX
syntax match agdaLineComment "\v--.*$" contains=@agdaInComment
syntax match agdaNumber "\v[0-9]+$"
syntax match agdaNumber "\v[+-][0-9]+$"
syntax region agdaString start=/\v"/ skip=/\v\\./ end=/\v"/
syntax match agdaIdentifier "\v[A-Za-z0-9_]"

highlight link agdaKeyword Keyword
highlight link agdaStructure Structure
highlight link agdaType Type
highlight link agdaBool Boolean
highlight link agdaTodo Todo
highlight link agdaInclude Include
highlight link agdaRecordEntries StorageClass
highlight link agdaAccess Keyword
highlight link agdaLineComment Comment
highlight link agdaNumber Number
highlight link agdaString String

let b:current_syntax = "agda"
