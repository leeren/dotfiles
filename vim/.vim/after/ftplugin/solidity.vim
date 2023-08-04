set shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent smartindent
set colorcolumn=80
setlocal commentstring=//\ %s
compiler solidity

setlocal suffixesadd+=.sol
setlocal path=.,,src/**,script/**,test/**

set include=^\\s*\\(import\\)\\s*\\({\\S\\+\\s\\+from\\s\\+\\)*"\\zs\\S\\+\\ze";$

function! SolInclude(fname)
	if a:fname =~ '^openzeppelin'
		return substitute(a:fname, 'openzeppelin', 'lib/openzeppelin-contracts', 'g')
	endif
        if a:fname =~ '^forge-std'
                return substitute(a:fname, 'forge-std', 'lib/forge-std/src', 'g')
        endif
        if a:fname =~ '^ds-test'
                return substitute(a:fname, 'ds-test', 'lib/forge-std/lib/ds-test/src', 'g')
        endif
	return a:fname
endfunction

setlocal includeexpr=SolInclude(v:fname)


