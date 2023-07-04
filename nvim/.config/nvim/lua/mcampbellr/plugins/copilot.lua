return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    build = ":Copilot auth",
    config = function()
        require("copilot").setup {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 50,
                keymap = {
                    accept = "<C-y>",
                    accept_word = false,
                    accept_line = false,
                    next = "<C-j>",
                    prev = "<C-k>",
                    dismiss = "<C-]>",
                },
            },
            copilot_node_command = vim.fn.expand "$HOME"
                .. "/.config/nvm/versions/node/v18.16.0/bin/node",
        }
    end,
}
