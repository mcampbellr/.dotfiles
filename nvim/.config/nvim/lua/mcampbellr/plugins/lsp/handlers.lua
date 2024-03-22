local nvim_lsp = require "lspconfig"
local mason_lsp = require "mason-lspconfig"
local lsp_configs = require "mcampbellr.plugins.lsp.configs"

local handlers = {
    function(server_name)
        nvim_lsp[server_name].setup {
            on_attach = lsp_configs.on_attach,
            capabilities = lsp_configs.capabilities,
        }
    end,
    ["sqlls"] = function()
        nvim_lsp.sqlls.setup {
            on_attach = lsp_configs.on_attach,
            capabilities = lsp_configs.capabilities,
            cmd = { "sql-language-server", "up", "--method", "stdio" },
        }
    end,
    ["bashls"] = function()
        nvim_lsp.bashls.setup {
            on_attach = lsp_configs.on_attach,
            capabilities = lsp_configs.capabilities,
            filetypes = { "sh", "zsh" },
        }
    end,
    ["volar"] = function()
        nvim_lsp.volar.setup {
            on_attach = lsp_configs.on_attach,
            init_options = {
                vue = {
                    hybridMode = false
                }
            },
            capabilities = lsp_configs.capabilities,
            filetypes = { "vue", "typescript", "javascript" },
        }
    end,
    ["tsserver"] = function()
        nvim_lsp.tsserver.setup {
            on_attach = lsp_configs.on_attach,
            capabilities = lsp_configs.capabilities,
            filetypes = { "vue","typescript", "typescriptreact", "typescript.tsx" },
            cmd = { "typescript-language-server", "--stdio" },
        }
    end,
    ["lua_ls"] = function()
        nvim_lsp.lua_ls.setup {
            on_attach = lsp_configs.on_attach,
            capabilities = lsp_configs.capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    format = {
                        enable = true,
                        defaultConfig = {
                            indent_style = "space",
                            indent_size = "2",
                        },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                },
            },
        }
    end,
    ["jsonls"] = function()
        nvim_lsp.jsonls.setup {
            on_attach = lsp_configs.on_attach,
            capabilities = lsp_configs.capabilities,
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                },
            },
        }
    end,
}

mason_lsp.setup_handlers(handlers)
