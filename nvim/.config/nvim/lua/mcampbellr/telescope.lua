local actions = require "telescope.actions"

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
