local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

local icons = require "mcampbellr.icons"

local function open_nvim_tree(data)
    local directory = vim.fn.isdirectory(data.file) == 1

    if not directory then
        return
    end

    vim.cmd.enew()
    vim.cmd.bw(data.buf)
    vim.cmd.cd(data.file)

    require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

nvim_tree.setup {
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = false,
    update_cwd = true,
    diagnostics = {
        enable = true,
        icons = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Information,
            warning = icons.diagnostics.Warning,
            error = icons.diagnostics.Error,
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
        side = "left",
        number = true,
        relativenumber = true,
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
    renderer = {
        highlight_opened_files = "all",
        root_folder_label = false,
        special_files = {
            "README.md" == false,
            "init.lua" == true,
        },
        icons = {
            show = {
                git = true,
                folder = true,
                file = true,
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
