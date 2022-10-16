local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap

nnoremap("<leader>fa", ":FlutterRun<CR>")
nnoremap("<leader>fq", ":FlutterQuit<CR>")
nnoremap("<leader>fr", ":FlutterHotReload<CR>")
nnoremap("<leader>fR", ":FlutterHotRestart<CR>")
nnoremap("<leader>fc", ":FlutterTab<CR>")
nnoremap("<leader>fD", ":FlutterVisualDebug<CR>")
