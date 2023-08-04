let current_compiler = 'solidity'
CompilerSet makeprg=forge\ build
CompilerSet errorformat=%E%.%#%trror[%n]:\ %.%#31m%m
CompilerSet errorformat+=%C\ \ -->%f:%l:%c:
CompilerSet errorformat+=%-G%.%#					     " Ignore lines not matching above

