local status, _ = pcall(require, "telescope")
if not status then
    return
end

local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap

nnoremap("<C-g>", function()
    if not pcall(require("telescope.builtin").git_files) then
        vim.cmd "Telescope find_files"
    end
end)

nnoremap("<C-f>", function()
    vim.cmd "Telescope find_files"
end)

nnoremap("<C-t>", function()
    if not pcall(require("telescope.builtin").git_status) then
        vim.cmd "Telescope find_files"
    end
end)

nnoremap("<C-s>", ":Telescope live_grep<CR>")

nnoremap("<C-b>", ":Telescope buffers<CR>")
nnoremap("<leader>/", ":Telescope current_buffer_fuzzy_find<CR>")
nnoremap("z=", ":Telescope spell_suggest<CR>")
nnoremap("<leader>d", ":Telescope diagnostics<CR>")

nnoremap("<Leader>vrc", function()
    require("mcampbellr.telescope").search_dotfiles()
end)
