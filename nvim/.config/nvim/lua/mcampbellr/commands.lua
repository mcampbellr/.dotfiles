local cmd = vim.cmd

cmd ":command! Q q"
cmd ":command! WQ wq"
cmd [[ command! LspToggleAutoFormat execute 'lua require("mcampbellr.lsp.handlers").toggle_format_on_save()' ]]
