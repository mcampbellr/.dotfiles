local Remap = require('mcampbellr.keymap')
local nnoremap = Remap.nnoremap

nnoremap("<leader>gb", ":Gitsigns blame_line<CR>")
nnoremap("g[", ":Gitsigns next_hunk<CR>")
nnoremap("g]", ":Gitsigns prev_hunk<CR>")
