local status, spectre = pcall(require, 'spectre')
if not status then return end

local Remap = require('mcampbellr.keymap')
local nnoremap = Remap.nnoremap

nnoremap("<leader>sw", function()
  spectre.open_visual({ select_word = true })
end
)

nnoremap("<leader>s", function()
  spectre.open_visual()
end)

nnoremap("<leader>sf", function()
  spectre.open_file_search()
end)
