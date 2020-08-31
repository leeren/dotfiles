if exists("did_load_filetypes_userafter")
  finish
endif
let did_load_filetypes_userafter = 1

augroup filetypedetectuser
  au! BufNewFile,BufRead .adsdsbashrc.i setf sh
augroup END
