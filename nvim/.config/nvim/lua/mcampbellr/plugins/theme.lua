return {
    --[[ "navarasu/onedark.nvim", ]]
    "sainnhe/gruvbox-material",
    dependencies = {
        "xiyaowong/nvim-transparent",
    },
    priority = 1000,
    lazy = false,
    init = function()
        -- Configurar transparencia
        require("transparent").setup {
            enable = true,
            extra_groups = {
                "Normal",
                "NormalNC",
                "NormalFloat",
                "FloatBorder",
                "VertSplit",
                "SignColumn",
                "EndOfBuffer",
                "NvimTreeNormal",
                "NvimTreeNormalNC",
                "NvimTreeEndOfBuffer",
                "NvimTreeVertSplit",
                "NvimTreeWinSeparator",
                "TelescopeNormal",
                "TelescopeBorder",
                "TelescopePromptNormal",
                "TelescopeResultsNormal",
                "TelescopePreviewNormal",
                "TabLine",
                "TabLineFill",
                "TabLineSel",
                "StatusLine",
                "StatusLineNC",
                "WinSeparator",
            },
            exclude_groups = {}, -- puedes excluir alguno si rompe algo
        }

        -- Aplicar colorscheme
        --[[ vim.cmd "colorscheme onedark" ]]
        vim.cmd "colorscheme gruvbox-material"

        -- Overrides manuales adicionales
        local set_hl = vim.api.nvim_set_hl
        local none = { bg = "none", ctermbg = "none" }

        set_hl(0, "Normal", none)
        set_hl(0, "NormalNC", none)
        set_hl(0, "NormalFloat", none)
        set_hl(0, "FloatBorder", none)

        -- normal text for nvim-tree
        set_hl(0, "NvimTreeNormal", { bg = "none", fg = "#9DA6B3" })
        -- unfocused text for nvim-tree
        set_hl(0, "NvimTreeNormalNC", { bg = "none", fg = "gray" })

        set_hl(0, "NvimTreeOpenedHL", { bg = "none", fg = "white" })

        -- folder name
        set_hl(0, "NvimTreeFolderName", { bg = "none", fg = "#C1461A" })
        set_hl(0, "NvimTreeFolderNameNC", { bg = "none", fg = "red" })
        set_hl(0, "NvimTreeOpenedFolderName", { bg = "none", fg = "#FF610C" })

        set_hl(0, "NvimTreeEndOfBuffer", none)
        set_hl(0, "NvimTreeVertSplit", none)
        set_hl(0, "SignColumn", none)
        set_hl(0, "EndOfBuffer", none)
        set_hl(0, "VertSplit", none)
        set_hl(0, "WinSeparator", none)
        set_hl(0, "TabLine", none)
        set_hl(0, "TabLineFill", none)
        set_hl(0, "TabLineSel", { fg = "orange", bg = "none" })
        set_hl(0, "CursorLineNr", { fg = "#47CC6F", bg = "none" })
        set_hl(0, "LineNr", { fg = "#5A6895", bg = "none" })
        set_hl(0, "ColorColumn", { bg = "#333540" })
        set_hl(0, "Visual", { fg = "black", bg = "#C174DF" })
        set_hl(0, "Folded", { fg = "orange", bg = "none" })

        -- Nvim tree
        --[[ set_hl(0, "NvimTreeFolderIcon", { fg = "#FFD700" }) ]]
        --[[ set_hl(0, "NvimTreeIndentMarker", { fg = "#555555" }) ]]
        --[[ set_hl(0, "NvimTreeOpenedFolderName", { fg = "#61afef", bold = true }) ]]
        --[[ set_hl(0, "NvimTreeFolderName", { fg = "#61afef" }) ]]
        --[[ set_hl(0, "NvimTreeRootFolder", { fg = "#e5c07b", bold = true }) ]]
        --[[ set_hl(0, "NvimTreeGitDirty", { fg = "#e06c75" }) ]]
        --[[ set_hl(0, "NvimTreeGitNew", { fg = "#98c379" }) ]]
        --[[ set_hl(0, "NvimTreeGitDeleted", { fg = "#be5046" }) ]]

        -- Para plugins de iluminación de palabras (como LSP, illuminated.nvim)
        set_hl(0, "IlluminatedWordText", { bg = "#333540" })
        set_hl(0, "IlluminatedWordRead", { bg = "#333540" })
        set_hl(0, "IlluminatedWordWrite", { bg = "#333540" })

        -- Cursiva si tu terminal lo permite
        vim.cmd [[
      let &t_ZH="\e[3m"
      let &t_ZR="\e[23m"
    ]]
    end,
}
