return {
    "norcalli/nvim-colorizer.lua",
    config = function()
        require("colorizer").setup {
            "css",
            "javascript",
            "vim",
            "html",
            "lua",
            "typescriptreact",
            "javascriptreact",
            "vue",
        }
    end,
}
