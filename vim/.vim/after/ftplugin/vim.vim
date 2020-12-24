set shiftwidth=2 tabstop=2 softtabstop=2 noexpandtab autoindent smartindent

" Automatically source .vimrc on save
augroup Vimrc
  autocmd!
  autocmd! bufwritepost .vimrc source %
augroup END

