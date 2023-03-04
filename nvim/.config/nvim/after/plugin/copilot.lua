vim.cmd [[
 imap <silent><script><expr> <C-y> copilot#Accept("\<CR>")
 let g:copilot_no_tab_map = v:true
 let g:copilot_node_command= "~/.nvm/versions/node/v16.17.0/bin/node"
]]
