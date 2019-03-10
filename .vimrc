" source /usr/share/vim/google/google.vim
"{{{ Plugin
filetype plugin indent on
syntax on
"}}}
" Basics {{{

" Options
set shell=/usr/bin/zsh
set foldmethod=marker
set nohlsearch
set grepprg=LC_ALL=C\ grep\ -nrsH " External grep command to use
set expandtab " Insert spaces for tabs 
set hidden " Don't abandon buffers"
set wildignore+=**/node_modules/**
set wildignore+=**/dist/**
set wildcharm=<C-z> " Like wildchar (character to type for wildcard expansion) but recognizable in macro"
set path=**
set noswapfile
set tags=./tags,tags; " Start searching in current directory and stop at root
set cmdheight=2

" Mappings
nnoremap gV `[v`]
nnoremap ' `
nnoremap Q @q
nmap <Space> /
nmap <C-Space> ?
inoremap <C-d> <C-O>x
imap jj <Esc>
nnoremap <BS> :buffer#<CR>
nnoremap ,b :buffer *
nnoremap ,B :sbuffer *
nnoremap ,f :find *
nnoremap ,s :sfind *
nnoremap ,t :tabfind *
nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,S :sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,V :vert sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,T :tabfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,e :e **/*<C-z><S-Tab>
nnoremap ,l :lcd ~/workspace/
nnoremap <leader>w :se wildignore+=**/node_modules/**<CR>
nnoremap <leader>W :se wildignore=<CR>
inoremap \s <C-R>=system("")<Left><Left>
nnoremap <leader>t :tabfind *
inoremap (; (<CR>);<C-c>O
inoremap (, (<CR>),<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap {, {<CR>},<C-c>O
inoremap [; [<CR>];<C-c>O
inoremap [, [<CR>],<C-c>O
nnoremap <leader>a :args<CR>
nnoremap <leader>lc :lcd %:p:h
nnoremap <leader>l :argadd %<CR>
nnoremap <leader>j :let @"=substitute(@", '\n', '', 'g')<CR>
nnoremap cp :let @" = expand("%:p:h")<CR>
nnoremap <leader>n :e ~/.vim<CR>
nnoremap <leader>v :e ~/.vimrc<CR>
nnoremap <leader>f :e <C-R>='~/.vim/ftplugin/'.&filetype.'.vim'<CR><CR>
nnoremap <leader>b :e ~/.zshrc<CR>
nnoremap <leader>t :e ~/TODO<CR>
nnoremap <leader>p :set paste!<CR>
vnoremap ; :
vnoremap : ;
nnoremap ; :
nnoremap : ;
nnoremap <silent> <Leader>z :tabe %<CR>
nnoremap <silent> <Leader>o :tabc<CR>
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 6/5)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 5/6)<CR>
nnoremap <leader>d "_d
 
" Command-line reverse-search without arrow keys
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

nnoremap <leader>s :mks! ~/.vim/sessions/
cnoremap \fp <C-R>=expand("%:p:h")<CR>/
tnoremap \fp <C-R>=expand("%:p:h")<CR>/
inoremap \fp <C-R>=expand("%:p:h")<CR>/
cnoremap \fn <C-R>=expand("%:t:r")<CR>
tnoremap \fn <C-R>=expand("%:t:r")<CR>
inoremap \fn <C-R>=expand("%:t:r")<CR>

cnoreabbrev v vert

" Symbol navigation
nnoremap ,j :tjump /
nnoremap ,p :ptjump /
nnoremap ,d :dlist /
nnoremap ,i :ilist /

" Fast internal grepping
nnoremap ,v :vim//**/*.ts<Left><Left><Left><Left><Left><Left><Left><Left>

" Fast global grepping
nnoremap <silent> ,G :Grep 

" Fast global search
nnoremap ,g :g//#<Left><Left>

" hjkl is an anti-pattern
noremap h <NOP>
noremap j <NOP>
noremap k <NOP>
noremap l <NOP>

" Scratch Buffer
command! SC vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile

cnoremap <expr> <CR> CCR()
" }}}
" {{{ Command-line Completion
" Command-line completion (credits to romainl)
function! CCR()
    let cmdline = getcmdline()
    if cmdline =~ '\v\C^(ls|files|buffers)'
        " like :ls but prompts for a buffer command
        return "\<CR>:b"
    elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
        " like :g//# but prompts for a command
        return "\<CR>:"
    elseif cmdline =~ '\v\C^(dlist)'
        " like :dlist or :ilist but prompts for a count for :djump or :ijump
        return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
    elseif cmdline =~ '\v\C^(cl|cli|lli)$'
        " like :clist or :llist but prompts for an error/location number
        return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
    elseif cmdline =~ '\v\C^old'
        " like :oldfiles but prompts for an old file to edit
        set nomore
        return "\<CR>:sil se more|e #<"
    elseif cmdline =~ '\v\C^changes'
        " like :changes but prompts for a change to jump to
        set nomore
        return "\<CR>:sil se more|norm! g;\<S-Left>"
    elseif cmdline =~ '\v\C^ju'
        " like :jumps but prompts for a position to jump to
        set nomore
        return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
    elseif cmdline =~ '\v\C^marks'
        " like :marks but prompts for a mark to jump to
        return "\<CR>:norm! `"
    elseif cmdline =~ '\v\C^undol'
        " like :undolist but prompts for a change to undo
        return "\<CR>:u "
    else
        return "\<CR>"
    endif
endfunction
" }}}
" {{{ Vimrc Auto-save
autocmd! bufwritepost .vimrc source %
" }}}
" {{{ Grep (,G)
command! -nargs=+ -complete=file_in_path -bar Grep silent! grep! <args> | redraw!
xnoremap <silent> ,G :<C-u>let cmd = "Grep " . visual#GetSelection() <bar>
                        \ call histadd("cmd", cmd) <bar>
                        \ execute cmd<CR>

" }}}
" OSC52 {{{
function! Osc52Yank()
    let buffer=system('base64 -w0', @0)
    let buffer=substitute(buffer, "\n$", "", "")
    let buffer='\e]52;c;'.buffer.'\x07'
    silent exe "!echo -ne ".shellescape(buffer)." > ".shellescape("/dev/pts/0")
endfunction
command! Osc52CopyYank call Osc52Yank()
nnoremap <leader>y :Osc52CopyYank<cr>
augroup Osc52Yank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
augroup END
" }}}
" {{{ File-Marks
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
  tnoremap <M-h> <c-\><c-n><c-w>h
  tnoremap <M-j> <c-\><c-n><c-w>j
  tnoremap <M-k> <c-\><c-n><c-w>k
  tnoremap <M-l> <c-\><c-n><c-w>l

  " nr2char({expr}) returns string with value {expr}
  " Equivalent to <C-\><C-n>"[reg]pi
  tnoremap <expr> <C-v> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  tnoremap <M-c> <c-\><c-n><Up>0y$i


  autocmd TermOpen * startinsert

  " Insert mode:
  inoremap <M-h> <Esc><c-w>h
  inoremap <M-j> <Esc><c-w>j
  inoremap <M-k> <Esc><c-w>k
  inoremap <M-l> <Esc><c-w>l

  " Visual mode:
  vnoremap <M-h> <Esc><c-w>h
  vnoremap <M-j> <Esc><c-w>j
  vnoremap <M-k> <Esc><c-w>k
  vnoremap <M-l> <Esc><c-w>l

  " Normal mode:
  nnoremap <M-h> <c-w>h
  nnoremap <M-j> <c-w>j
  nnoremap <M-k> <c-w>k
  nnoremap <M-l> <c-w>l
endif
" }}}
" {{{
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']
" }}}
