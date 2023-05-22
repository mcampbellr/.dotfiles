local status_ok, todo_comments = pcall(require, "todo-comments")
if not status_ok then
    return
end

local icons = require "mcampbellr.icons"

local error_red = "#F44747"
local warning_orange = "#ff8800"
local info_yellow = "#FFCC66"
local hint_blue = "#4FC1FF"
local perf_purple = "#7C3AED"
local note_pink = "#F78AE0"
local temp_aqua = "#BFF3D2"

todo_comments.setup {
    signs = true, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    keywords = {
        FIX = { icon = icons.ui.Bug, color = error_red, alt = { "FIXME", "BUG", "ISSUE" } },
        TODO = { icon = icons.ui.Check, color = info_yellow },
        HACK = { icon = icons.ui.Fire, color = warning_orange },
        WARN = { icon = icons.diagnostics.Warning, color = warning_orange, alt = { "WARNING" } },
        PERF = { icon = icons.ui.Dashboard, color = perf_purple, alt = { "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = icons.ui.Note, color = note_pink, alt = { "QUESTION", "TICKET" } },
        TEMP = { icon = icons.ui.Clock, color = temp_aqua, alt = { "TEMPORAL" } },
        INFO = { icon = icons.diagnostics.Information, color = hint_blue },
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
