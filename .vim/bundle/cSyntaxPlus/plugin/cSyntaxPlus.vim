function! CSyntaxPlus()
   syntax keyword    Boolean     true false NULL TRUE FALSE
   syntax keyword    Statement   namespace stderr stdin stdout new this delete

   syntax match      _Block      "[{}]"
   syntax match      _IfBlock    "[()]"
   syntax match      _Bracket    "[\[\]]"
   syntax match      _Operator   display "[-+&|<>=!\/~.,;:*%&^?]"
   syntax region     _Comment    start="\/\*" end="\*\/"
   syntax match      _Comment    "\/\/.*$"
   syntax match      _Pointer    display "\w\+\s*->"  contains=_Operator
   syntax match      _Struct     display "\w\+\s*[.]" contains=_Operator
   syntax match      _Func       display "\w\+\s*("   contains=_IfBlock

   hi link _Operator Operator
   hi link _Bracket  Constant
   hi link _Comment  Comment
   hi link _Func     Function

   hi link _IfBlock  String
   hi link _Pointer  Type
   hi link _Struct   _Pointer

   hi _Block guifg=yellow1 guibg=NONE gui=none
endfunction
