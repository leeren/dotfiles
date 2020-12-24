set shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent smartindent

" go to the next opening tag below the current line
nnoremap <buffer> ]] 0/$/;/<[a-zA-Z][a-zA-Z0-9]*\%(\_[^>]*>\)\@=<CR>
" go to next end of closing tag or empty element below current line
nnoremap <buffer> ][ 0/$/;/\%([^>]*$\)\@=<CR>
" go to the previous opening tag above the current line
nnoremap <buffer> [[ $?^?;?^[^<]*\zs<\%([a-za-z][a-za-z0-9]*\_[^>]*>\)\@=<CR>
" go to the previous closing tag above the current line
nnoremap <buffer> [] $?^?;?>\%([^>]*$\)\@=<CR>
" Go to the next tag element closing
nnoremap <buffer> ]} /><CR>
" Go to the previous tag element opening
nnoremap <buffer> [{ ?<<CR>

" operator-pending variants of the above normal mode mappings
onoremap <buffer> ]] /<\%([a-z][a-zA-Z0-9]*\_[^>]*>\)\@=<CR>
onoremap <buffer> ][ />\%([^>]*$\)\@=<CR>
onoremap <buffer> [[ ?^[^<]*\zs<\%([a-za-z][a-za-z0-9]*\_[^>]*>\)\@=<CR>
onoremap <buffer> [] \%([^>]*$\)\@=<CR>
onoremap <buffer> ]} /><CR>
onoremap <buffer> [{ ?<<CR>

" Semantics
setlocal iskeyword=@,48-57,_,-,\"

" Abbreviations
iabbrev <buffer> copyright Copyright =strftime("%Y")<CR> Leeren Chang

" Navigation
setlocal suffixesadd+=.html,.css,.txt,.js,.json

" Surround.vim
let b:surround_33 = "<!-- \r -->"
