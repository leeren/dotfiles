let current_compiler = 'solidity'
CompilerSet makeprg=npx\ hardhat\ compile
CompilerSet errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m
CompilerSet errorformat+=%C%m
CompilerSet errorformat+=%E%f:%l:%c:%m          " filename:line#:col#:message"
CompilerSet errorformat+=%-G%.%#					     " Ignore lines not matching above
