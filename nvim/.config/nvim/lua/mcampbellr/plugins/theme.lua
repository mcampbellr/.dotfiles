return {
    "sainnhe/gruvbox-material",
    dependencies = {
        "xiyaowong/nvim-transparent",
    },
    priority = 1000,
    lazy = false,
    init = function()
        require("transparent").setup({
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
        })
        vim.cmd [[
            colorscheme gruvbox-material
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
