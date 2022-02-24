local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        prompt_prefix = "  ",
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    },
    pickers = {
      find_files = {
        theme = "dropdown",
        previewer = false,
      },
      live_grep = {
        theme = "dropdown",
        previewer = false,
      },
      buffers = {
        theme = "dropdown",
        previewer = false,
      },
      recent_projects = {
        theme = "dropdown",
        previewer = false,
      }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
        bookmarks = {
          -- Available: 'brave', 'buku', 'chrome', 'chrome_beta', 'edge', 'safari', 'firefox'
          selected_browser = 'chrome',
          -- Either provide a shell command to open the URL
          url_open_command = 'open',
          -- Or provide the plugin name which is already installed
          -- Available: 'vim_external', 'open_browser'
          url_open_plugin = nil,
          -- Show the full path to the bookmark instead of just the bookmark name
          full_path = true,
          -- Provide a custom profile name for Firefox
          firefox_profile_name = nil,
        },
    },
})

require("telescope").load_extension("git_worktree")
require('telescope').load_extension('bookmarks')
require("telescope").load_extension("fzy_native")

local k = vim.api.nvim_set_keymap
local opts = { noremap= true, silent = true }

k("n", "<C-f>", ":Telescope find_files<CR>", opts)
k("n", "<C-b>", ":Telescope buffers<CR>", opts)
k("n", "<C-g>", ":Telescope live_grep<CR>", opts)
k("n", "<Leader>vrc", ":lua require('user.telescope').search_dotfiles({ hidden = true })<CR>", opts)
k("n", "<Leader>bm", ":lua require('telescope').extensions.bookmarks.bookmarks(require('telescope.themes').get_dropdown({previewer = false}))<CR>", opts)
k("n", "<Leader>gwt", ":lua require('telescope').extensions.git_worktree.git_worktrees(require('telescope.themes').get_dropdown({previewer = false}))<CR>", opts)

local M = {}

M.search_dotfiles = function()
    require("telescope.builtin").find_files({
        prompt_title = "< VimRC >",
        cwd = vim.env.DOTFILES,
        hidden = true,
    })
end

M.git_branches = function()
    require("telescope.builtin").git_branches({
        attach_mappings = function(_, map)
            map("i", "<c-d>", actions.git_delete_branch)
            map("n", "<c-d>", actions.git_delete_branch)
            return true
        end,
    })
end

return M



