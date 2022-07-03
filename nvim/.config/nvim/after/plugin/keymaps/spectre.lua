local Remap = require('mcampbellr.keymap')
local nnoremap = Remap.nnoremap

nnoremap("<leader>sw", function()
  require('spectre').open_visual({ select_word = true })
end
)

nnoremap("<leader>s", function()
  require('spectre').open_visual()
end)

nnoremap("<leader>sf", function()
  require('spectre').open_file_search()
end)
