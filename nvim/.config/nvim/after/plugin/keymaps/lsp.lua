local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap

nnoremap(";r", ":LspRestart<CR>")
