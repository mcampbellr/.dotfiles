local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

local icons = require "mcampbellr.icons"

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
        width = 40,
        hide_root_folder = true,
        side = "left",
        mappings = {
            custom_only = true,
            list = {
                { key = "s", action = "vsplit" },
                { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
                { key = "<C-e>", action = "edit_in_place" },
                { key = "O", action = "edit_no_picker" },
                { key = { "<C-]>", "<2-RightMouse>" }, action = "cd" },
                { key = "<C-x>", action = "split" },
                { key = "<", action = "prev_sibling" },
                { key = ">", action = "next_sibling" },
                { key = "P", action = "parent_node" },
                { key = "<BS>", action = "close_node" },
                { key = "<Tab>", action = "preview" },
                { key = "K", action = "first_sibling" },
                { key = "J", action = "last_sibling" },
                { key = "I", action = "toggle_git_ignored" },
                { key = "H", action = "toggle_dotfiles" },
                { key = "U", action = "toggle_custom" },
                { key = "R", action = "refresh" },
                { key = "a", action = "create" },
                { key = "d", action = "remove" },
                { key = "D", action = "trash" },
                { key = "r", action = "rename" },
                { key = "<C-r>", action = "full_rename" },
                { key = "x", action = "cut" },
                { key = "c", action = "copy" },
                { key = "p", action = "paste" },
                { key = "y", action = "copy_name" },
                { key = "Y", action = "copy_path" },
                { key = "gy", action = "copy_absolute_path" },
                { key = "[e", action = "prev_diag_item" },
                { key = "[c", action = "prev_git_item" },
                { key = "]e", action = "next_diag_item" },
                { key = "]c", action = "next_git_item" },
                { key = "-", action = "dir_up" },
                { key = "f", action = "live_filter" },
                { key = "F", action = "clear_live_filter" },
                { key = "q", action = "close" },
                { key = "W", action = "collapse_all" },
                { key = "E", action = "expand_all" },
                { key = "S", action = "search_node" },
                { key = ".", action = "run_file_command" },
                { key = "<C-k>", action = "toggle_file_info" },
                { key = "g?", action = "toggle_help" },
                { key = "m", action = "toggle_mark" },
                { key = "bmv", action = "bulk_move" },
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
        highlight_opened_files = "all",
        special_files = {
            "README.md" == false,
            "init.lua" == true,
        },
        icons = {
            show = {
                git = true,
                folder = false,
                file = false,
                folder_arrow = true,
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
            },
        },
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
