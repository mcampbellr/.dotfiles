local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<leader>S", "<cmd>lua require('spectre').open()<CR>", opts)

keymap("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", opts)
keymap("n", "<leader>s", "<cmd>lua require('spectre').open_visual()<CR>", opts)
keymap("n", "<leader>sf", "<cmd>lua require('spectre').open_file_search({select_word= true})<CR>", opts)
