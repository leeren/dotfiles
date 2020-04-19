" invoke buildifier for formatting
:command! -buffer -range=% Gofmt let b:winview = winsaveview() |
  \ execute <line1> . "," . <line2> . "!gofmt " | 
  \ call winrestview(b:winview)

augroup Gofmt
  autocmd!
  autocmd BufWritePre <buffer> Gofmt
augroup END
