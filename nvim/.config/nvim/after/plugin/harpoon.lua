local status, _ = pcall(require, "harpoon")
if not status then
    return
end

local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap

nnoremap("<leader>e", function()
    require("harpoon.ui").toggle_quick_menu()
end)

nnoremap("<leader>m", function()
    require("harpoon.mark").add_file()
end)
