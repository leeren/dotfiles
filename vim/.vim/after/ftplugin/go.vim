set shiftwidth=2 tabstop=2 softtabstop=2 noexpandtab autoindent smartindent

setlocal path=.,**,$GOROOT/src 
setlocal keywordprg=$HOME/profile.d/util/vim/keywordprg/go.sh

" User-defined command for running gofmt on select lines (default all)
:command! -buffer -range=% Gofmt let b:winview = winsaveview() |
  \ silent! execute <line1> . "," . <line2> . "!gofmt " | 
  \ call winrestview(b:winview)

" Autocommand for running gofmt and goimport on buffer saves
augroup Goupdate
  autocmd!
  autocmd BufWritePre <buffer> Gofmt
augroup END
