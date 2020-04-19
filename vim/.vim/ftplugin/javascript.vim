 set grepprg=LC_ALL=C\ grep\ -nrsH\ --exclude-dir={node_modules,.git,Session.vim} " External grep command to use

setlocal suffixesadd+=.js,.jsx,.json

setlocal isfname+=@-@

setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\)

nnoremap <space><space> <C-w>ba<C-c><C-c><C-\><C-n>:sleep 100m<CR>aNODE_ENV=dev NODE_PATH=. node inspect ./src/index.js<CR><C-\><C-n>:sleep 500m<CR>ac<CR><C-\><C-n><C-w>p

set wildignore=**/node_modules/**,**/dist/**

nnoremap gp m`:silent keepjump  %!prettier --stdin --trailing-comma all --single-quote --stdin-filepath %<CR>``
