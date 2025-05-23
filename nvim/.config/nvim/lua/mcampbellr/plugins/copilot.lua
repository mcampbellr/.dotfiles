return {
    "zbirenbaum/copilot.lua",
    event = "BufReadPre",
    build = ":Copilot auth",
    config = function()
        local nvm_dir = vim.fn.expand "$NVM_DIR"
        local latest_node_version_command = "ls "
        .. nvm_dir
        .. "/versions/node | sort -V | tail -n1"
        local latest_node_version = vim.fn.system(latest_node_version_command)
        latest_node_version = vim.fn.trim(latest_node_version)

        require("copilot").setup {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 25,
                keymap = {
                    accept = "<C-s>",
                    accept_word = false,
                    accept_line = false,
                    next = "<C-j>",
                    prev = "<C-k>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                yaml = true,
                markdown = true,
                gitcommit = true,
                gitrebase = true,
                help = false,
                ["*"] = true,
            },
            copilot_node_command = nvm_dir
                .. "/versions/node/"
                .. latest_node_version
                .. "/bin/node",
        }
    end,
}
