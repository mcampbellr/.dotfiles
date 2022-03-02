local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<leader>gwt", ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", opts)
keymap("n", "<leader>gwn", ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", opts)
