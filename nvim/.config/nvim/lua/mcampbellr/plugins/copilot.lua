return {
    "github/copilot.vim",
    init = function() 
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_node_command = "~/.config/nvm/versions/node/v18.16.0/bin/node"
    end
}
