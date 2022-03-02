local opts = { noremap = true, silent = true }

-- local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<up>", "<C-w>k", opts)
keymap("n", "<down>", "<C-w>j", opts)
keymap("n", "<left>", "<C-w>h", opts)
keymap("n", "<right>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
keymap("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Naviagate buffers
keymap("n", "<S-l>", "<cmd>bnext<CR>", opts)
keymap("n", "<S-h>", "<cmd>bprevious<CR>", opts)

-- resource the nvim config
keymap("n", "<Leader>rs", ":so % <CR>", opts)

-- Keep the cursor center
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "J", "mzJ`z", opts)

-- Delete all the page content
keymap("n", "<leader>D", "ggdG<esc>", opts)

-- Paste and replace all the page content
keymap("n", "<leader>P", "ggVGp<esc>", opts)

-- Select all the page content
keymap("n", "<leader>V", "gg0VG$", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "J", "<cmd>m '>+1<cr>gv=gv", opts)
keymap("v", "K", "<cmd>m '<-2<cr>gv=gv", opts)

-- Paste in visual_mode
keymap("v", "p", '"_dP', opts)

keymap("v", "<C-s>", "<cmd>sort //[A-z|/<CR>", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Custom
keymap("n", "Q", "<cmd>Bdelete!<CR>", opts)
keymap("n", "<F3>", "<cmd>e .<cr>", opts)
keymap("n", "<F4>", "<cmd>Telescope resume<cr>", opts)
keymap("n", "<F5>", "<cmd>Telescope commands<CR>", opts)
keymap("n", "<F6>", "<cmd>TSHighlightCapturesUnderCursor<cr>", opts)
keymap("n", "<F7>", "<cmd>Telescope oldfiles<cr>", opts)
keymap("n", "<F9>", "<cmd>Alpha<cr>", opts)
keymap("n", "<F10>", "<cmd>e ~/Notes/<cr>", opts)
keymap("n", "<F11>", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "<Bslash>", "<cmd>let @/ = ''<CR>", opts)
keymap("n", "<C-s>", "<cmd>vsplit<cr>", opts)
