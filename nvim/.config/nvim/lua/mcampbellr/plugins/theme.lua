return {
    "navarasu/onedark.nvim",
    dependencies = {
        {
            "xiyaowong/nvim-transparent",
            opts = {
                extra_groups = {
                    "NvimTreeNormal",
                    "NvimTreeVertSplit",
                    "NvimTreeEndOfBuffer",
                    "TabLineSel",
                    "TabLine",
                    "TabLineFill",
                    "TabLineSel",
                    "SignColumn",
                    "VertSplit",
                    "SignColumn",
                    "EndOfBuffer",
                },
            },
        },
    },
    priority = 1000,
    lazy = false,
    init = function()
        require("onedark").setup {
            -- Main options --
            style = "dark", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
            transparent = true, -- Show/hide background
            term_colors = false, -- Change terminal color as per the selected theme style
            ending_tildes = true, -- Show the end-of-buffer tildes. By default they are hidden
            cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

            -- toggle theme style ---
            toggle_style_key = "<leader>ts", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
            toggle_style_list = {}, -- List of styles to toggle between
            -- Change code style ---
            -- Options are italic, bold, underline, none
            -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
            code_style = {
                comments = "italic",
                keywords = "none",
                functions = "none",
                strings = "none",
                variables = "none",
            },
            -- Lualine options --
            lualine = {
                transparent = true, -- lualine center bar transparency
            },
            -- Plugins Config --
            diagnostics = {
                darker = true, -- darker colors for diagnostic
                undercurl = true, -- use undercurl instead of underline for diagnostics
                background = true, -- use background color for virtual text
            },
        }
        require("onedark").load()
        vim.cmd [[
          hi Normal guibg=NONE
          hi NormalNC guibg=NONE

          hi IlluminatedWordText guibg=#333540
          hi IlluminatedWordRead guibg=#333540
          hi IlluminatedWordWrite guibg=#333540

          hi Normal guibg=NONE ctermbg=NONE
          hi Visual guibg=#C174DF guifg=black
          hi LineNr guibg=NONE guifg=#5A6895
          hi SignColumn guibg=NONE ctermbg=NONE
          hi EndOfBuffer guibg=NONE ctermbg=NONE

          hi CursorLineNr guibg=NONE guifg=#47CC6F
          hi ColorColumn guibg=#333540

          hi VertSplit guibg=NONE
          hi SignColumn guibg=NONE
          hi Folded guibg=NONE guifg=orange

          hi TabLineSel guibg=NONE
          hi TabLine guibg=NONE
          hi TabLineFill guibg=NONE
          hi TabLineSel guifg=orange

          let &t_ZH="\e[3m"
          let &t_ZR="\e[23m"
        ]]
    end,
}
