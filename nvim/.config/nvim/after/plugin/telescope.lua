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
      oldfiles = {
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
require("telescope").load_extension('harpoon')
