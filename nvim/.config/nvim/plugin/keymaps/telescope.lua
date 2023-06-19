local status, _ = pcall(require, "telescope")
if not status then
    return
end

local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap

nnoremap("<C-f>", ":Telescope find_files<CR>")

nnoremap("<C-t>", function()
    if not pcall(require("telescope.builtin").git_status) then
        vim.cmd "Telescope find_files"
    end
end)

nnoremap("<C-b>", ":Telescope buffers<CR>")
nnoremap("<C-s>", ":Telescope oldfiles<CR>")
nnoremap("<C-g>", ":Telescope live_grep<CR>")
nnoremap("<leader>/", ":Telescope current_buffer_fuzzy_find<CR>")
nnoremap("z=", ":Telescope spell_suggest<CR>")
nnoremap("<leader>d", ":Telescope diagnostics<CR>")

nnoremap("<Leader>vrc", function()
    require("mcampbellr.telescope").search_dotfiles()
end)

nnoremap("<C-n>", function()
    require("mcampbellr.telescope").search_notes()
end)
