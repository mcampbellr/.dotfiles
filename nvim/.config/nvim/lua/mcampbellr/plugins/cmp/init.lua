return {
    enable = false,
    "hrsh7th/nvim-cmp",
    dependencies = {
        { "hrsh7th/cmp-buffer" }, 
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-nvim-lsp" }, 
        { "hrsh7th/cmp-nvim-lua" }, 
        { "saadparwaiz1/cmp_luasnip" }, 
        { "L3MON4D3/LuaSnip" }, 
        { 
            "tzachar/cmp-tabnine",
            build = "./install.sh"
        },
        { "rafamadriz/friendly-snippets" }, 
    },
    event = "BufEnter",
    config = function ()
        require("mcampbellr.plugins.cmp.configs")
    end
}
