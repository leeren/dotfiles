" Ignore node_modules, distribution folder, and javascript files
set wildignore=**/node_modules/**,**/dist/**

let &l:errorformat = '%-G,%EERROR: %f:%l:%c - %m,%WWARNING: %f:%l:%c - %m,%E%f(%l\,%c): error %m,%E%f(%l\,%c): error %m,%E%f(%l\,%c): %m,%Eerror %m'
let &l:makeprg = 'tsmake'

setlocal keywordprg=/usr/local/google/home/leeren/devdocs.sh

setlocal grepprg=LC_ALL=C\ grep\ -nrsH\ --exclude-dir={node_modules,.git} " External grep command to use

setlocal syntax=typescript

setlocal suffixesadd+=.ts,.tsx,.json,.js

setlocal include=\\%(\\<require\\s*(\\s*\\\|\\<import\\>[^;\"']*\\)[\"']\\zs[^\"']*

setlocal define=^\\s*\\(export\ \\)\\?\\<\\(type\\\|var\\\|interface\\\|const\\\|let\\\|\\(async\ \\)\\?function\\\|class\\)\\>

setlocal isfname+=@-@

setlocal sw=2

setlocal commentstring=//\ %s

setlocal includeexpr=TypeScriptIncludeExpression(v:fname)

nnoremap <leader>n :call NodeModulesIncsearchToggle()<CR>

nnoremap [<C-d> :silent! call JumpToDefinition(expand("<cword>"))<CR>

let g:node = 1

command! -nargs=1 DJ silent! call JumpToDefinition(<f-args>)

cnoreabbrev dj DJ

function! JumpToDefinition(definition)
    try
        exe 'djump' a:definition
    catch /^Vim(djump):E388:/
        exe 'norm gg'        
        exe 'keepjumps /' . split(a:definition, '/')[0] 
        exe "keepjumps norm f'gf"
    endtry
endfunction

function! NodeModulesIncsearchToggle()
    if g:node
        let g:node = 0
    else
        let g:node = 1
    endif
endfunction
    
function! TypeScriptIncludeExpression(fname) abort
    " BUILT-IN NODE MODULES
    " =====================
    " they aren't accessible so we might as well give up early
    if index([
        \ 'assert', 'async_hooks',
        \ 'child_process', 'cluster', 'crypto',
        \ 'dgram', 'dns', 'domain',
        \ 'events',
        \ 'fs',
        \ 'http', 'http2', 'https',
        \ 'inspector',
        \ 'net',
        \ 'os',
        \ 'path', 'perf_hooks', 'punycode',
        \ 'querystring',
        \ 'readline',
        \ 'stream', 'string_decoder',
        \ 'tls', 'tty',
        \ 'url', 'util',
        \ 'v8', 'vm',
        \ 'zlib' ], a:fname) != -1
        return 0
    endif
    
    " ./foo
    " ./foo/bar
    " ../foo
    " ../foo/bar
    " simplify module name to find it more easily
    let module_name = substitute(a:fname, '^\W*', '', '')


    " LOCAL IMPORTS
    " =============
    " they are everywhere so we must get them right
    if a:fname =~ '^\.'
        " ./
        if a:fname =~ '^\./$'
            return 'index.ts'
        endif

        " ../
        if a:fname =~ '\.\./$'
            return a:fname . 'index.ts'
        endif

        " first, look for the module name only
        " (findfile() uses 'suffixesadd')
        let found_plain = findfile(module_name, '.;')
        if len(found_plain)
            return found_plain
        endif

        " second, look for an index.ts file
        let found_index = findfile(module_name . '/index.ts', '.;')
        if len(found_index)
            return found_index
        endif

        " give up
        return a:fname
    endif
        
    " REQUIRE IMPORTS
    " ===============
    " first, look for the module name only
    " (findfile() uses 'suffixesadd')
    let found_plain = findfile(module_name, '.;')
    if len(found_plain)
        return found_plain
    endif

    " second, look for an index.js file
    let found_index = findfile(module_name . '/index.js', '.;')
    if len(found_index)
        return found_index
    endif

    if !g:node
        return 0
    endif

    " NODE IMPORTS
    " ============
    " localize the closest node_modules/
    let node_modules = finddir('node_modules', '.;', -1)

    " give up if there's none
    if !len(node_modules)
        return 0
    endif

    " split the filename in meaningful parts:
    " - a package name, used to search for the package in node_modules/
    " - a subpath if applicable, used to reach the right module
    "
    " example:
    " import bar from 'coolcat/foo/bar';
    " - package_name = coolcat
    " - sub_path     = foo/bar
    "
    " special case:
    " import something from '@scope/something/else';
    " - package_name = @scope/something
    " - sub_path     = else
    let parts = split(a:fname, '/')

    if parts[0] =~ '^@'
        let package_name = join(parts[0:1], '/')
        let sub_path = join(parts[2:-1], '/')
    else
        let package_name = parts[0]
        let sub_path = join(parts[1:-1], '/')
    endif

    " find the package.json for that package
    let package_json = node_modules[0] . '/' . package_name . '/package.json'

    " give up if there's no package.json
    if !filereadable(package_json)
        return 0
    endif

    if len(sub_path) == 0
        " grab data from the package.json
        let package = json_decode(join(readfile(package_json)))

        " build path from 'main' key
        return fnamemodify(package_json, ':p:h') . "/" . substitute(get(package, "main", "index.js"), '^\.\{1,2}\/', '', '')
    else
        " build the path to the module
        let common_path = fnamemodify(package_json, ':p:h') . '/' . sub_path

        " first, try with .ts
        let found_dotts = glob(common_path . '.ts', 1)
        if len(found_dotts)
            return found_dotts
        endif

        " second, try with /index.ts
        let found_index = glob(common_path . '/index.ts', 1)
        if len(found_index)
            return found_index
        endif

        " third, try with .js
        let found_dotts = glob(common_path . '.js', 1)
        if len(found_dotts)
            return found_dotts
        endif

        " fourth, try with /index.js
        let found_index = glob(common_path . '/index.js', 1)
        if len(found_index)
            return found_index
        endif

        " give up
        return 0
    endif

    " give up
    return 0
endfunction

augroup Linting
    autocmd!
    autocmd BufWritePost *.ts call Lint()
augroup END

function! Lint() abort
    silent make!
endfunction

nnoremap gp m`:silent keepjump  %!prettier --stdin --trailing-comma all --single-quote --stdin-filepath %<CR>``

nmap ]] /^[ \t]*\(export[ \t]\+\)\?\(default[ \t]\+\)\?\(async[ \t]\+\)\?function/-;/{<CR>
nmap [[ ?[{}]?+;?^[ \t]*\(export[ \t]\+\)\=\(default[ \t]\+\)\=\(async[ \t]\+\)\=function?-;/{<CR>
nmap ][ /^}$<CR>
nmap [] ?^}$<CR>
autocmd QuickFixCmdPost [^l]* cwindow
setlocal formatprg=./node_modules/.bin/prettier\ --stdin\ --stdin-filepath\ %\ --config\ node_modules/gts/prettier.config.js
nnoremap <leader>w :se wildignore+=**/node_modules/**<CR>
nnoremap <leader>W :se wildignore=<CR>

