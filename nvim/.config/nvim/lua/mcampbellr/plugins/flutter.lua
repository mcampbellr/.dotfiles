local lsp_configs = require "mcampbellr.plugins.lsp.configs"

return {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("flutter-tools").setup {
            lsp = {
                on_attach = lsp_configs.on_attach,
                capabilities = lsp_configs.capabilities,
            },
        }
    end,
}
