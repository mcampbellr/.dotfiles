local status ,actions = pcall(require, "telescope.actions");
if not status then
    return
end

local M = {}

M.search_dotfiles = function()
    require("telescope.builtin").git_files {
        prompt_title = "< DOTFILES >",
        cwd = vim.env.DOTFILES,
        hidden = true,
    }
end

M.search_notes = function()
    require("telescope.builtin").git_files {
        prompt_title = "< Notes >",
        cwd = vim.env.NOTES,
        hidden = true,
    }
end

return M
