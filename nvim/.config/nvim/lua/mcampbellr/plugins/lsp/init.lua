return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "b0o/SchemaStore.nvim" },
        { "nvim-tree/nvim-web-devicons" },
        { "glepnir/lspsaga.nvim" },
    },
    config = function()
        pcall(require, "mcampbellr.plugins.lsp.configs")
        pcall(require, "mcampbellr.plugins.lsp.autoformat")
        pcall(require, "mcampbellr.plugins.lsp.handlers")
        pcall(require, "mcampbellr.plugins.lsp.saga")

        local mason_lsp = require "mason-lspconfig"
        local mason = require "mason"
        local default_lsps =
            require("mcampbellr.plugins.lsp.configs").default_lsps

        mason.setup {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        }
        mason_lsp.setup {
            ensure_installed = default_lsps,
        }
    end,
}
