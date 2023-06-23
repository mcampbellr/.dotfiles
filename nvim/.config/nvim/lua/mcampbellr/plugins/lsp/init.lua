return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "jose-elias-alvarez/null-ls.nvim" },
        { "b0o/SchemaStore.nvim" },
        { "nvim-tree/nvim-web-devicons" },
        { "glepnir/lspsaga.nvim" },
    },
    config = function()
        require "mcampbellr.plugins.lsp.configs"
        require "mcampbellr.plugins.lsp.autoformat"
        require "mcampbellr.plugins.lsp.handlers"
        require "mcampbellr.plugins.lsp.null-ls"

        local mason_lsp = require "mason-lspconfig"
        local mason = require "mason"
        local default_lsps =
            require("mcampbellr.plugins.lsp.configs").default_lsps

        mason.setup()
        mason_lsp.setup {
            ensure_installed = default_lsps,
        }
    end,
}
