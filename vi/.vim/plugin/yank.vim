function Osc52Yank()
  let buffer=system('base64 | tr -d "\n"', @0)
  let buffer="\e]52;c;".buffer."\e\\"
  call writefile([buffer], g:tty, 'b')
endfunction

augroup Yank
  autocmd!
  autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
augroup END
