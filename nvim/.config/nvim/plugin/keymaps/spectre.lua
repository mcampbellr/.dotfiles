local status, _ = pcall(require, "spectre")
if not status then
    return
end

local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

nnoremap("<leader>S", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>")
vnoremap("<leader>S", "<esc>:lua require('spectre').open_visual()<CR>")
--nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
