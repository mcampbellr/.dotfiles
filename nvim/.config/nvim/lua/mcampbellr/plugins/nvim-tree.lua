return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<Leader>n", ":NvimTreeToggle<CR>", silent = true },
    },
    init = function()
        local function open_nvim_tree(data)
            local directory = vim.fn.isdirectory(data.file) == 1

            if not directory then
                return
            end

            require("nvim-tree.api").tree.open()
        end

        vim.api.nvim_create_autocmd(
            { "VimEnter" },
            { callback = open_nvim_tree }
        )
    end,
    config = function()
        local icons = require "mcampbellr.icons"

        local function on_attach(bufnr)
            local api = require "nvim-tree.api"
            local function opts(desc)
                return {
                    desc = "nvim-tree: " .. desc,
                    buffer = bufnr,
                    noremap = true,
                    silent = true,
                    nowait = true,
                }
            end

            vim.keymap.set(
                "n",
                "<C-]>",
                api.tree.change_root_to_node,
                opts "CD"
            )
            vim.keymap.set(
                "n",
                "<C-e>",
                api.node.open.replace_tree_buffer,
                opts "Open: In Place"
            )
            vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts "Info")
            -- rename
            vim.keymap.set(
                "n",
                "e",
                api.fs.rename_basename,
                opts "Rename: Basename"
            )
            vim.keymap.set(
                "n",
                "<C-r>",
                api.fs.rename_sub,
                opts "Rename: Omit Filename"
            )
            vim.keymap.set("n", "r", api.fs.rename, opts "Rename")

            vim.keymap.set(
                "n",
                "s",
                api.node.open.vertical,
                opts "Open: Vertical Split"
            )
            vim.keymap.set(
                "n",
                "<BS>",
                api.node.navigate.parent_close,
                opts "Close Directory"
            )
            vim.keymap.set("n", "<CR>", api.node.open.edit, opts "Open")

            vim.keymap.set(
                "n",
                "<C-x>",
                api.node.open.horizontal,
                opts "Open: Horizontal Split"
            )
            vim.keymap.set(
                "n",
                "<Tab>",
                api.node.open.preview,
                opts "Open Preview"
            )
            vim.keymap.set(
                "n",
                ">",
                api.node.navigate.sibling.next,
                opts "Next Sibling"
            )
            vim.keymap.set(
                "n",
                "<",
                api.node.navigate.sibling.prev,
                opts "Previous Sibling"
            )
            vim.keymap.set("n", ".", api.node.run.cmd, opts "Run Command")
            vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts "Up")
            vim.keymap.set("n", "a", api.fs.create, opts "Create")
            vim.keymap.set(
                "n",
                "bmv",
                api.marks.bulk.move,
                opts "Move Bookmarked"
            )
            vim.keymap.set(
                "n",
                "B",
                api.tree.toggle_no_buffer_filter,
                opts "Toggle No Buffer"
            )
            vim.keymap.set("n", "c", api.fs.copy.node, opts "Copy")
            vim.keymap.set(
                "n",
                "C",
                api.tree.toggle_git_clean_filter,
                opts "Toggle Git Clean"
            )
            vim.keymap.set(
                "n",
                "[c",
                api.node.navigate.git.prev,
                opts "Prev Git"
            )
            vim.keymap.set(
                "n",
                "]c",
                api.node.navigate.git.next,
                opts "Next Git"
            )
            vim.keymap.set("n", "d", api.fs.remove, opts "Delete")
            vim.keymap.set("n", "D", api.fs.trash, opts "Trash")
            vim.keymap.set("n", "E", api.tree.expand_all, opts "Expand All")
            vim.keymap.set(
                "n",
                "]e",
                api.node.navigate.diagnostics.next,
                opts "Next Diagnostic"
            )
            vim.keymap.set(
                "n",
                "[e",
                api.node.navigate.diagnostics.prev,
                opts "Prev Diagnostic"
            )
            vim.keymap.set("n", "F", api.live_filter.clear, opts "Clean Filter")
            vim.keymap.set("n", "f", api.live_filter.start, opts "Filter")
            vim.keymap.set("n", "g?", api.tree.toggle_help, opts "Help")
            vim.keymap.set(
                "n",
                "gy",
                api.fs.copy.absolute_path,
                opts "Copy Absolute Path"
            )
            vim.keymap.set(
                "n",
                "H",
                api.tree.toggle_hidden_filter,
                opts "Toggle Dotfiles"
            )
            vim.keymap.set(
                "n",
                "I",
                api.tree.toggle_gitignore_filter,
                opts "Toggle Git Ignore"
            )
            vim.keymap.set(
                "n",
                "J",
                api.node.navigate.sibling.last,
                opts "Last Sibling"
            )
            vim.keymap.set(
                "n",
                "K",
                api.node.navigate.sibling.first,
                opts "First Sibling"
            )
            vim.keymap.set("n", "m", api.marks.toggle, opts "Toggle Bookmark")
            vim.keymap.set("n", "o", api.node.open.edit, opts "Open")
            vim.keymap.set(
                "n",
                "O",
                api.node.open.no_window_picker,
                opts "Open: No Window Picker"
            )
            vim.keymap.set("n", "p", api.fs.paste, opts "Paste")
            vim.keymap.set(
                "n",
                "P",
                api.node.navigate.parent,
                opts "Parent Directory"
            )
            vim.keymap.set("n", "q", api.tree.close, opts "Close")
            vim.keymap.set("n", "R", api.tree.reload, opts "Refresh")
            vim.keymap.set("n", "S", api.tree.search_node, opts "Search")
            vim.keymap.set(
                "n",
                "U",
                api.tree.toggle_custom_filter,
                opts "Toggle Hidden"
            )
            vim.keymap.set("n", "W", api.tree.collapse_all, opts "Collapse")
            vim.keymap.set("n", "x", api.fs.cut, opts "Cut")
            vim.keymap.set("n", "y", api.fs.copy.filename, opts "Copy Name")
            vim.keymap.set(
                "n",
                "Y",
                api.fs.copy.relative_path,
                opts "Copy Relative Path"
            )

            vim.keymap.set(
                "n",
                "<2-LeftMouse>",
                api.node.open.edit,
                opts "Open"
            )
            vim.keymap.set(
                "n",
                "<2-RightMouse>",
                api.tree.change_root_to_node,
                opts "CD"
            )
            -- END_DEFAULT_ON_ATTACH

            -- Mappings removed via:
            --   remove_keymaps
            --   OR
            --   view.mappings.list..action = ""
            --
            -- The dummy set before del is done for safety, in case a default mapping does not exist.
            --
            -- You might tidy things by removing these along with their default mapping.
            vim.keymap.set("n", "O", "", { buffer = bufnr })
            vim.keymap.del("n", "O", { buffer = bufnr })
            vim.keymap.set("n", "<2-RightMouse>", "", { buffer = bufnr })
            vim.keymap.del("n", "<2-RightMouse>", { buffer = bufnr })
            vim.keymap.set("n", "D", "", { buffer = bufnr })
            vim.keymap.del("n", "D", { buffer = bufnr })
            vim.keymap.set("n", "E", "", { buffer = bufnr })
            vim.keymap.del("n", "E", { buffer = bufnr })

            -- Mappings migrated from view.mappings.list
            --
            -- You will need to insert "your code goes here" for any mappings with a custom action_cb
            vim.keymap.set("n", "A", api.tree.expand_all, opts "Expand All")
            vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
            vim.keymap.set("n", "C", api.tree.change_root_to_node, opts "CD")
            vim.keymap.set("n", "P", function()
                local node = api.tree.get_node_under_cursor()
                print(node.absolute_path)
            end, opts "Print Node Path")

            vim.keymap.set("n", "Z", api.node.run.system, opts "Run System")
        end

        require("nvim-tree").setup {
            on_attach = on_attach,
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
                width = 55,
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
                        folder = false,
                        file = false,
                        folder_arrow = false,
                    },
                    glyphs = {
                        default = icons.documents.File,
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
                    enable = false,
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
    end,
}
