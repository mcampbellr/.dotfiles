local lspsaga = require "lspsaga"

local icons = require "mcampbellr.icons"

lspsaga.setup {
    debug = false,
    use_saga_diagnostic_sign = true,
    use_diagnostic_virtual_text = false,
    -- diagnostic sign
    error_sign = icons.diagnostics.Error,
    warn_sign = icons.diagnostics.Warning,
    hint_sign = icons.diagnostics.Hint,
    infor_sign = icons.diagnostics.Information,
    diagnostic_header_icon = icons.ui.Lightbulb,
    code_action_icon = " ",
    code_action = {
        num_shortcut = true,
        show_server_name = false,
        extend_gitsigns = true,
        keys = {
            quit = "q",
            exec = "<CR>",
        },
    },
    symbol_in_winbar = {
        enable = false
    },
    lightbulb = {
        enable = false,
        enable_in_insert = false,
        sign = false,
        sign_priority = 0,
        virtual_text = false,
    },
    finder_definition_icon = "  ",
    finder_reference_icon = "  ",
    max_preview_lines = 10,
    finder_action_keys = {
        open = "o",
        vsplit = "s",
        split = "i",
        quit = "q",
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
    },
    rename_action_keys = {
        quit = "<C-c>",
        exec = "<CR>",
    },
    definition_preview_icon = "  ",
    border_style = "single",
    rename_prompt_prefix = "➤",
    rename_output_qflist = {
        enable = false,
        auto_open_qflist = false,
    },
    server_filetype_map = {},
    diagnostic_prefix_format = "%d. ",
    diagnostic_message_format = "%m %c",
    highlight_prefix = false,
}
