setlocal shiftwidth=4 tabstop=4 softtabstop=4 smartindent
setlocal colorcolumn=80
setlocal commentstring=//\ %s
setlocal suffixesadd+=.sol
setlocal path=.,,src/**,script/**,test/**

compiler solidity
set include=^\\s*\\(import\\)\\s*\\({\\s*\\S\\+\\s*}\\s\\+from\\s\\+\\)*"\\zs\\S\\+\\ze";$
let &l:define  = '^\s*\('
             \ . '\(abstract\s\)*\(contract\)\s'
             \ . '\|\(bytes|bytes32|bytes4|bytes1|uint256|bool|string\)\(public\|private\|protected\|readonly\|static\)\s'
             \ . '\|\(function\s\|modifier\s\)'
             \ . '\|\(export\sdefault\s\|abstract\sclass\s\)'
             \ . '\|\(async\s\|struct\s\)'
             \ . '\|\(\ze\i\+([^)]*).*{$\)'
             \ . '\)'

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
