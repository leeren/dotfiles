" Settings for vimscript
se sw=2 	                  " Google syle vimscript conventions
set foldmethod=marker             " Group folds with '{{{,}}}'

" Automatically source .vimrc on save
augroup Vimrc
  autocmd!
  autocmd! bufwritepost .vimrc source %
augroup END
