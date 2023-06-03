vim.cmd [[
 imap <silent><script><expr> <C-y> copilot#Accept("\<CR>")
 let g:copilot_no_tab_map = v:true
 let g:copilot_node_command= "~/.config/nvm/versions/node/v18.16.0/bin/node"
]]
