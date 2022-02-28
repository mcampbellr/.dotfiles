local keymap = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }

keymap("n", "<leader>e", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
keymap("n", "<leader>m", ":lua require('harpoon.mark').add_file()<cr>", opts)
