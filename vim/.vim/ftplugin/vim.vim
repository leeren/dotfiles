" Settings for .vimrc
se sw=2 	                  " Google syle vimscript conventions
set foldmethod=marker             " Group folds with '{{{,}}}'

" Automatically source .vimrc on save
augroup Vimrc
  autocmd!
  autocmd! bufwritepost * source %
augroup END
