local actions = require "telescope.actions"
local Remap = require('mcampbellr.keymap')
local nnoremap = Remap.nnoremap

nnoremap("<C-f>", ":Telescope find_files<CR>")
nnoremap("<C-t>", ":TodoTelescope<CR>")
nnoremap("<leader>ff", ":Telescope current_buffer_fuzzy_find<CR>")
nnoremap("<leader>dd", ":Telescope diagnostics<CR>")
nnoremap("<leader>bb", ":Telescope buffers<CR>")
nnoremap("<leader>gd", ":Telescope git_status<CR>")
nnoremap("<C-b>", ":Telescope buffers<CR>")
nnoremap("z=", ":Telescope spell_suggest<CR>")
nnoremap("<C-s>", ":Telescope oldfiles<CR>")
nnoremap("<C-g>", ":Telescope live_grep<CR>")
nnoremap("<leader>mm", ":Telescope marks<CR>")

nnoremap("<Leader>vrc", function()
  require('mcampbellr.telescope').search_dotfiles({ hidden = true })
end)

nnoremap("<C-n>", function()
  require('mcampbellr.telescope').search_notes({ hidden = true })
end)

local M = {}

M.search_dotfiles = function()
  require("telescope.builtin").find_files {
    prompt_title = "< VimRC >",
    cwd = vim.env.DOTFILES,
    hidden = true,
  }
end

M.search_notes = function()
  require("telescope.builtin").find_files {
    prompt_title = "< Notes >",
    cwd = vim.env.NOTES,
    hidden = true,
  }
end

M.git_branches = function()
  require("telescope.builtin").git_branches {
    attach_mappings = function(_, map)
      map("i", "<c-d>", actions.git_delete_branch)
      map("n", "<c-d>", actions.git_delete_branch)
      return true
    end,
  }
end

return M
