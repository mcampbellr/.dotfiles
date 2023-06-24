local nvim_lsp = require "lspconfig"
local  mason_lsp = require "mason-lspconfig"
local lsp_configs = require "mcampbellr.plugins.lsp.configs"

local handlers = {
    function(server_name)
        nvim_lsp[server_name].setup {
            on_attach = lsp_configs.on_attach,
            capabilities = lsp_configs.capabilities,
        }
    end,
    ["tsserver"] = function()
        nvim_lsp.tsserver.setup {
            on_attach = lsp_configs.on_attach,
            capabilities = lsp_configs.capabilities,
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
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
    ["eslint"] = function()
        nvim_lsp.eslint.setup {
            on_attach = lsp_configs.on_attach,
            capabilities = lsp_configs.capabilities,
            filetypes = {
                "typescript",
                "typescriptreact",
                "typescript.tsx",
                "javascript",
                "javascriptreact",
                "javascript.jsx",
            },
        }
    end,
}

mason_lsp.setup_handlers(handlers)