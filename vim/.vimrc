" VIMRC

" Basics {{{
filetype plugin indent on         " Add filetype, plugin, and indent support
syntax on                         " Turn on syntax highlighting
"}}}

" Settings {{{
set shell=/usr/bin/zsh            " Prefer zsh for shell-related tasks
set foldmethod=marker             " Group folds with '{{{,}}}'
set grepprg=LC_ALL=C\ grep\ -rns  " Faster ASCII-based grep
set expandtab                     " Prefer spaces over tabs
set hidden                        " Prefer hiding over unloading buffers
set wildcharm=<C-z>               " Macro-compatible command-line wildchar
set path=.,**                     " Search relative to current file + directory
set directory=/tmp//              " No swapfiles in current directory
set tags=./tags;,tags;            " ID Tags relative to current file + directory
set shiftwidth=2                  " Digestable defaults for config files
" }}}

" Mappings {{{
" Self-explanatory convenience mappings
imap jj <Esc>
nnoremap ' `
vnoremap ; :
vnoremap : ;
nnoremap ; :
nnoremap : ;

" Visually select pasted or yanked text
nnoremap gV `[v`]
" Copy Linux command-line character deletion
inoremap <C-d> <C-O>x
" Toggle Paste mode
nnoremap <leader>p :set paste!<CR>
" Fast switching to the alternate file
nnoremap <BS> :buffer#<CR>
" Faster buffer navigation
nnoremap ,b :buffer *
" Black hole deletes
nnoremap <leader>d "_d
" Command-line like forward-search
cnoremap <C-k> <Up>
" Command-line like reverse-search
cnoremap <C-j> <Down>
" Often utilize vertical splits
cnoreabbrev v vert
" Fast global commands
nnoremap ,g :g//#<Left><Left>
" Faster project-based editing
nnoremap ,e :e **/*<C-z><S-Tab>
" Join yanked text
nnoremap ,j :let @"=substitute(@", '\n', '', 'g')<CR>

" Bindings for more efficient path-based file navigation
nnoremap ,f :find *
nnoremap ,v :vert sfind *
nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,V :vert sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>

" More manageable brace expansions
inoremap (; (<CR>);<C-c>O
inoremap (, (<CR>),<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap {, {<CR>},<C-c>O
inoremap [; [<CR>];<C-c>O
inoremap [, [<CR>],<C-c>O

" Useful for accessing commonly-used files
nnoremap <leader>v :e ~/.vimrc<CR>
nnoremap <leader>f :e <C-R>='~/.vim/ftplugin/'.&filetype.'.vim'<CR><CR>
nnoremap <leader>z :e ~/.zshrc<CR>
nnoremap <leader>t :e ~/TODO<CR>

" Window management
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 6/5)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 5/6)<CR>

" Access file name data
cnoremap \fp <C-R>=expand("%:p:h")<CR>
tnoremap \fp <C-R>=expand("%:p:h")<CR>
inoremap \fp <C-R>=expand("%:p:h")<CR>
cnoremap \fn <C-R>=expand("%:t:r")<CR>
tnoremap \fn <C-R>=expand("%:t:r")<CR>
inoremap \fn <C-R>=expand("%:t:r")<CR>

" Symbol-based navigation
nnoremap ,t :tjump /
nnoremap ,d :dlist /
nnoremap ,i :ilist /

" Kill bad habits
noremap h <NOP>
noremap j <NOP>
noremap k <NOP>
noremap l <NOP>

" Scratch Buffer
command! SC vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile

" External Grep
command! -nargs=+ -complete=file_in_path -bar Grep sil! grep! <args> | redraw!

" Custom function aliases
nnoremap <silent> ,G :Grep
cnoremap <expr> <CR> cmdline#AutoComplete()
" }}}

" {{{ Autocommands
" Automatically source .vimrc on save
augroup Vimrc
  autocmd! bufwritepost .vimrc source %
augroup END

" Automatically call OSC52 function on yank to sync register with host clipboard
augroup Yank
  autocmd!
  autocmd TextYankPost * if v:event.operator ==# 'y' | call yank#Osc52Yank() | endif
augroup END

" Create file-marks for commonly edited file types
augroup FileMarks
  autocmd!
  autocmd BufLeave *.html normal! mH
  autocmd BufLeave *.js   normal! mJ
  autocmd BufLeave *.ts   normal! mT
  autocmd BufLeave *.vim  normal! mV
augroup END
" }}}

" Neovim {{{
if has("nvim")
  " Terminal mode:
  tnoremap <Esc> <C-\><C-n>
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
endif
" }}}

" Snippets {{{
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']
let g:UltiSnipsExpandTrigger="<tab>"
" }}}
