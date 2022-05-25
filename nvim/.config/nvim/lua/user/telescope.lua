local actions = require "telescope.actions"

local k = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

k("n", "<C-f>", ":Telescope find_files<CR>", opts)
k("n", "<C-t>", ":TodoTelescope<CR>", opts)
k("n", "<leader>ff", ":Telescope current_buffer_fuzzy_find<CR>", opts)
k("n", "<leader>dd", ":Telescope diagnostics<CR>", opts)
k("n", "<leader>bb", ":Telescope buffers<CR>", opts)
k("n", "<leader>gd", ":Telescope git_status<CR>", opts)
k("n", "<C-b>", ":Telescope buffers<CR>", opts)
k("n", "z=", ":Telescope spell_suggest<CR>", opts)
k("n", "<C-s>", ":Telescope oldfiles<CR>", opts)
k("n", "<C-g>", ":Telescope live_grep<CR>", opts)
k("n", "<leader>mm", ":Telescope marks<CR>", opts)
k("n", "<Leader>vrc", ":lua require('user.telescope').search_dotfiles({ hidden = true })<CR>", opts)
k("n", "<C-n>", ":lua require('user.telescope').search_notes({ hidden = true })<CR>", opts)
k(
  "n",
  "<Leader>bm",
  ":lua require('telescope').extensions.bookmarks.bookmarks(require('telescope.themes').get_dropdown({previewer = false}))<CR>",
  opts
)
k(
  "n",
  "<Leader>gwt",
  ":lua require('telescope').extensions.git_worktree.git_worktrees(require('telescope.themes').get_dropdown({previewer = false}))<CR>",
  opts
)

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
