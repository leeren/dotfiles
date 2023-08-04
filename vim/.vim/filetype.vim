" Sets a custom filetype for Bazel WORKSPACE files
autocmd BufNewFile,BufRead WORKSPACE set filetype=WORKSPACE
autocmd BufNewFile,BufRead *.sol set filetype=solidity
autocmd BufRead,BufNewFile *.hcl set filetype=hcl
autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json
