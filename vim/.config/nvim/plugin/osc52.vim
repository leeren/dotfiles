" Sends default register to terminal TTY using OSC 52 escape sequence
function Osc52Yank()
    let buffer=system('base64 | tr -d "\n"', @0)
    let buffer='\033]52;c;'.buffer.'\033\'
    silent exe "!echo -ne ".shellescape(buffer).
        \ " > ".(exists('g:tty') ? shellescape(g:tty) : '/dev/tty')
endfunction

" Like Osc52Yank, except send all the contents to a single line
" TODO: Figure out how to do this more cleanly.
function Osc52YankOneLine()
  let @"=substitute(@", '\n', '', 'g')
  call Osc52Yank() | redraw!
endfunction

" Automatically call OSC52 function on yank to sync register with host clipboard
augroup Yank
  autocmd!
  autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
augroup END
