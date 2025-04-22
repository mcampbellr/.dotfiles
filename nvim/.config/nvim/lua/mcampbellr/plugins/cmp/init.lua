return {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-cmdline" },
        {
            "tzachar/cmp-tabnine",
            build = "./install.sh",
        },
        { "petertriho/cmp-git" },
        { "saadparwaiz1/cmp_luasnip" },
        { "L3MON4D3/LuaSnip" },
        { "rafamadriz/friendly-snippets" },
    },
    config = function()
        require "mcampbellr.plugins.cmp.configs"
    end,
}

