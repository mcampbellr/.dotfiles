return {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local icons = require "mcampbellr.icons"

        local error_color = "#F44747"
        local warn_color = "#ff8800"
        local info_color = "#FFCC66"
        local hint_color = "#4FC1FF"
        local perf_color = "#7C3AED"
        local note_color = "#4FC1FF"
        local temp_color = "#BFF3D2"
        local question_color = "#FFC44C"

        require("todo-comments").setup {
            signs = true, -- show icons in the signs column
            sign_priority = 8, -- sign priority
            keywords = {
                FIX = {
                    icon = icons.ui.Bug,
                    color = error_color,
                    alt = { "FIXME", "BUG", "ISSUE" },
                },
                TODO = { icon = icons.ui.Check, color = info_color },
                HACK = { icon = icons.ui.Fire, color = warn_color },
                WARN = {
                    icon = icons.diagnostics.Warning,
                    color = warn_color,
                    alt = { "WARNING" },
                },
                PERF = {
                    icon = icons.ui.Dashboard,
                    color = perf_color,
                    alt = { "PERFORMANCE", "OPTIMIZE" },
                },
                NOTE = {
                    icon = icons.ui.Note,
                    color = note_color,
                    alt = { "TICKET" },
                },
                QUESTION = {
                    icon = icons.ui.Question,
                    color = question_color,
                    alt = { "HELP" },
                },
                TEMP = {
                    icon = icons.ui.Clock,
                    color = temp_color,
                    alt = { "TEMPORAL" },
                },
                INFO = {
                    icon = icons.diagnostics.Information,
                    color = hint_color,
                },
                DEBUG = {
                    icon = icons.ui.Bug,
                    color = hint_color,
                    alt = { "DEBUG" },
                },
            },
            highlight = {
                before = "", -- "fg" or "bg" or empty
                keyword = "fg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
                after = "fg", -- "fg" or "bg" or empty
                pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
                comments_only = true, -- uses treesitter to match keywords in comments only
                max_line_len = 400, -- ignore lines longer than this
                exclude = {}, -- list of file types to exclude highlighting
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                pattern = [[\b(KEYWORDS):]], -- ripgrep regex
            },
        }
    end,
    keys = {
        {
            "]t",
            function()
                require("todo-comments").jump_next()
            end,
            desc = "Next todo comment",
        },
        {
            "[t",
            function()
                require("todo-comments").jump_prev()
            end,
            desc = "Previous todo comment",
        },
    },
}
