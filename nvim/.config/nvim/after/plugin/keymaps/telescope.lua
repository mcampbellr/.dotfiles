local Remap = require('mcampbellr.keymap')
local nnoremap = Remap.nnoremap

nnoremap("<C-f>", ":Telescope find_files<CR>")
nnoremap("<C-t>", ":TodoTelescope<CR>")
nnoremap("<C-d>", ":Telescope git_status<CR>")
nnoremap("<C-b>", ":Telescope buffers<CR>")
nnoremap("<C-s>", ":Telescope oldfiles<CR>")
nnoremap("<C-g>", ":Telescope live_grep<CR>")
nnoremap("<leader>mm", ":Telescope marks<CR>")
nnoremap("z=", ":Telescope spell_suggest<CR>")
nnoremap(";f", ":Telescope current_buffer_fuzzy_find<CR>")
nnoremap(";;", ":Telescope diagnostics<CR>")

nnoremap("<Leader>vrc", function()
  require('mcampbellr.telescope').search_dotfiles()
end)

nnoremap("<C-n>", function()
  require('mcampbellr.telescope').search_notes()
end)
