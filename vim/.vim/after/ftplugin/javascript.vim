set grepprg=LC_ALL=C\ grep\ -nrsH\ --exclude-dir={node_modules,.git} " External grep command to use
setlocal suffixesadd+=.js,.jsx,.json
setlocal isfname+=@-@
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\)

" User-defined command for running prettier on select lines (default all)
:command! -buffer -range=% Prettier let b:winview = winsaveview() |
  \ silent! execute <line1> . "," . <line2> . "!prettier --single-quote --stdin-filepath " . expand('%') | 
  \ call winrestview(b:winview)

" Autocommand for running gofmt and goimport on buffer saves
" TODO: Enable quickfix support so that errors don't propagate to stdout
augroup Prettify
  autocmd!
  autocmd BufWritePre <buffer> Prettier
augroup END
