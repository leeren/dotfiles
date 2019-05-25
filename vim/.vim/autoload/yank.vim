" Sends default register to terminal TTY using OSC 52 escape sequence
function! yank#Osc52Yank()
    let buffer=system('base64 -w0', @0)
    let buffer=substitute(buffer, "\n$", "", "")
    let buffer='\e]52;c;'.buffer.'\x07'
    silent exe "!echo -ne ".shellescape(buffer).
        \ " > ".shellescape(g:tty)
endfunction
