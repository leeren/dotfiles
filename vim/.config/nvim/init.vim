" VIMRC

" Environment Variables {{{
let $RTP=split(&runtimepath, ',')[0]
let $VIMRC="$HOME/.config/nvim/init.vim"
" }}}

" Settings {{{
set expandtab                     " Prefer spaces over tabs in general
set path=,.                       " Relative to current file and everything under :pwd
set noswapfile                    " Disables swapfiles
set wildcharm=<C-z>
set shiftwidth=4 tabstop=4 softtabstop=4 smartindent
set colorcolumn=80

" }}}

" Mappings {{{
inoremap jj <Esc>
inoremap <C-d> <Del>
nnoremap <C-k> <Up>$
nnoremap <C-j> <Down>$
nnoremap ; :
nnoremap : ;
nnoremap ,e :e ./**/*<C-z><S-Tab>
nnoremap ,f :find ./**/*<C-z><S-Tab>

" Fast switching to the alternate file
nnoremap <BS> :buffer#<CR>
" Toggle Paste mode
nnoremap <leader>p :set paste!<CR>
" Command-line hjkl-style forward-search
cnoremap <C-k> <Up>
" Command-line hjkl-style reverse-search
cnoremap <C-j> <Down>
" Highlight pasted text
nnoremap <expr> gp '`[' . getregtype()[0] . '`]'

" Argslist navigation
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
nnoremap [A :first<CR>
nnoremap ]A :last<CR>

" Quickfix list navigation
nnoremap [q :cp<CR>
nnoremap ]q :cn<CR>

" Access file data
cnoremap \fp <C-R>=expand("%:p:h")<CR>
inoremap \fp <C-R>=expand("%:p:h")<CR>
cnoremap \fn <C-R>=expand("%:t:r")<CR>
inoremap \fn <C-R>=expand("%:t:r")<CR>
" }}}

" Terminal Configuration {{{
autocmd TermOpen * startinsert

" Prefer h-j-k-l mode-agnostic means of switching windows
tnoremap <M-h> <c-\><c-n><c-w>h
tnoremap <M-j> <c-\><c-n><c-w>j
tnoremap <M-k> <c-\><c-n><c-w>k
tnoremap <M-l> <c-\><c-n><c-w>l
inoremap <M-h> <Esc><c-w>h
inoremap <M-j> <Esc><c-w>j
inoremap <M-k> <Esc><c-w>k
inoremap <M-l> <Esc><c-w>l
vnoremap <M-h> <Esc><c-w>h
vnoremap <M-j> <Esc><c-w>j
vnoremap <M-k> <Esc><c-w>k
vnoremap <M-l> <Esc><c-w>l
nnoremap <M-h> <c-w>h
nnoremap <M-j> <c-w>j
nnoremap <M-k> <c-w>k
nnoremap <M-l> <c-w>l

" nr2char({expr}) returns string with value {expr}
" Equivalent to <C-\><C-n>"[reg]pi: paste the contents of [reg]
tnoremap <expr> <C-v> '<C-\><C-N>"'.nr2char(getchar()).'pi'

tnoremap jj <C-\><C-n>
" }}}
