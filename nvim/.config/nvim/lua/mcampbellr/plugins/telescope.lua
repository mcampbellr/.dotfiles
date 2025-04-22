return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
        local telescope = require "telescope"

        telescope.setup {
            defaults = {
                file_sorter = require("telescope.sorters").get_fzy_sorter,
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            },
            file_ignore_patterns = {
                "node_modules",
                ".git",
                "*.jpg",
                "*.jpeg",
                "*.png",
            },
            pickers = {
                find_files = {
                    hidden = false,
                    path_display = { truncate = 6 },
                },
                live_grep = {
                    hidden = false,
                    path_display = { truncate = 6 },
                },
                buffers = {},
                oldfiles = {},
            },
            extensions = {
                file_browser = {
                    select_buffer = true,
                    hijack_netrw = true,
                    hidden = {
                        file_browser = true,
                        folder_browser = true,
                    },
                },
                fzy_native = {
                    override_generic_sorter = false,
                    override_file_sorter = true,
                },
            },
        }

        telescope.load_extension "fzy_native"
    end,
    keys = {
        {
            "<C-g>",
            function()
                if not pcall(require("telescope.builtin").git_files) then
                    vim.cmd "Telescope git_files"
                end
            end,
        },
        {
            "<C-f>",
            function()
                vim.cmd "Telescope find_files"
            end,
        },
        {
            "<C-t>",
            function()
                if not pcall(require("telescope.builtin").git_status) then
                    vim.cmd "Telescope find_files"
                end
            end,
        },
        { "<C-s>", ":Telescope live_grep<CR>" },
        { "<C-b>", ":Telescope buffers<CR>" },
        { "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>" },
        { "z=", ":Telescope spell_suggest<CR>" },
        { "<leader>d", ":Telescope diagnostics<CR>" },
        {
            "<Leader>vrc",
            function()
                require("mcampbellr.telescope").search_dotfiles()
            end,
        },
        {
            "<leader>st",
            "<cmd>TodoTelescope<cr>",
            desc = "Todo",
        },
        {
            "<leader>sT",
            "<cmd>TodoTelescope<cr>",
            desc = "Todo/Fix/Fixme",
        },
    },
}
