local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap

nnoremap("g[", ":Gitsigns next_hunk<CR>")
nnoremap("g]", ":Gitsigns prev_hunk<CR>")
nnoremap("<leader>gb", ":Gitsigns blame_line<CR>")

-- File history
--[[ nnoremap("<leader>fh", ":GitTimeLapse <CR>") ]]
