require("telescope").setup {
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
  },
  file_ignore_patterns = { "node_modules", ".git" },
  pickers = {
    find_files = {
      theme = "dropdown",
      hidden = true,
      previewer = false,
    },
    live_grep = {
      theme = "dropdown",
      hidden = true,
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
    },
    oldfiles = {
      theme = "dropdown",
      previewer = false,
    },
  },
  extensions = {
    bookmarks = {
      selected_browser = "brave",
      url_open_command = "open",
      url_open_plugin = nil,
      full_path = true,
      firefox_profile_name = nil,
    },
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
}

require("telescope").load_extension "git_worktree"
require("telescope").load_extension "bookmarks"
require("telescope").load_extension "fzy_native"
