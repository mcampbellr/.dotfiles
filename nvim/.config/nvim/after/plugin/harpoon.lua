local status, harpoon = pcall(require, "harpoon")
if not status then
    return
end

harpoon.setup {
    menu = {
        width = 80,
        height = 10,
    },
}

local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap

nnoremap("<leader>e", function()
    require("harpoon.ui").toggle_quick_menu()
end)

nnoremap("<leader>m", function()
    require("harpoon.mark").add_file()
end)
