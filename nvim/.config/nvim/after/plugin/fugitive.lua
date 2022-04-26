local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap('n', "<leader>gb", ":Git blame<CR>", opts)
keymap('n', "<leader>gst", ":Git<CR>", opts)
keymap('n', "<leader>gg", ":Git log<CR>", opts)
