local k = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

k("n", "<leader>gp", ":Git push<CR>", opts)
k("n", "<leader>gst", ":vertical Git<CR>", opts)
k("n", "<leader>gl", ":Git log<CR>", opts)
k("n", "<leader>gb", ":Git blame<CR>", opts)

k("n", "<leader>gh", ":diffget//3<CR>", opts)
k("n", "<leader>gu", ":diffget//2<CR>", opts)
