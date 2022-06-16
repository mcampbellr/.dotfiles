local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback
local icons = require "user.icons"

nvim_tree.setup {
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {
    "startify",
    "dashboard",
    "alpha",
  },
  create_in_closed_folder = true,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = { ".DS_Store" },
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 50,
    height = 30,
    hide_root_folder = true,
    side = "left",
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "C", cb = tree_cb "cd" },
        { key = "u", cb = tree_cb "dir_up" },
        { key = "h", cb = tree_cb "close_node" },
        { key = "s", cb = tree_cb "vsplit" },
        { key = "f", cb = '' },
      },
    },
    number = true,
    relativenumber = true,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  renderer = {
    highlight_opened_files = "name",
    special_files = {
      "README.md" == false,
    },
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = false,
      },
      glyphs = {
        default = "",
        symlink = icons.ui.Symlink,
        git = {
          unstaged = icons.git.Mod,
          staged = icons.git.Diff,
          unmerged = icons.git.Unmerged,
          renamed = icons.git.Rename,
          deleted = icons.git.Remove,
          untracked = icons.git.Untracked,
          ignored = icons.git.Ignore,
        },
        folder = {
          default = icons.documents.SolidFolder,
          open = icons.documents.SolidFolderOpen,
          empty = icons.documents.FolderEmpty,
          empty_open = icons.documents.OpenFolderEmpty,
          symlink = icons.documents.Symlink,
        },
      }
    }
  },
  actions = {
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false,
      },
    },
  },
}

vim.api.nvim_set_keymap("n", "<Leader>n", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
