" invoke buildifier for formatting
:command! -buffer -range=% Buildify let b:winview = winsaveview() |
  \ execute <line1> . "," . <line2> . "!buildifier " | 
  \ call winrestview(b:winview)

augroup Buildify
  autocmd!
  autocmd BufWritePre <buffer> Buildify
augroup END
