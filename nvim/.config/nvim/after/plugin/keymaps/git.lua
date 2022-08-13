local Remap = require('mcampbellr.keymap')
local nnoremap = Remap.nnoremap

nnoremap(";gb", ":Gitsigns blame_line<CR>")
nnoremap("g[", ":Gitsigns next_hunk<CR>")
nnoremap("g]", ":Gitsigns prev_hunk<CR>")
-- Fugitive
nnoremap("<leader>gb", ":Git blame <CR>")
-- File history
nnoremap("<leader>fh", ":GitTimeLapse <CR>")
