local status, nvim_lsp = pcall(require, "lspconfig")
if not status then
    return
end

local M = {}

local protocol = require "vim.lsp.protocol"

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

    keymap(
        bufnr,
        "n",
        "<leader>a",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        opts
    )
    keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

    keymap(bufnr, "n", "gh", "<cmd>Lspsaga lsp_finder<CR>", opts)
    keymap(bufnr, "n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)
    keymap(bufnr, "n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", opts)
    keymap(bufnr, "n", "gpt", "<cmd>Lspsaga peek_type_definition<CR>", opts)
    keymap(bufnr, "n", "gpd", "<cmd>Lspsaga peek_definition<CR>", opts)
    keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
    keymap(bufnr, "n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
    keymap(bufnr, "n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
    keymap(bufnr, "i", "<C-k>", "<cmd>Lspsaga signature_help<CR>", opts)
    keymap(bufnr, "n", "gl", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    if
        client.name == "volar"
        or client.name == "tsserver"
        or client.name == "html"
        or client.name == "jsonls"
        or client.name == "sumneko_lua"
    then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end

    lsp_keymaps(bufnr)
    M.enable_format_on_save()
end

protocol.CompletionItemKind = {
    "", -- Text
    "", -- Method
    "", -- Function
    "", -- Constructor
    "", -- Field
    "", -- Variable
    "", -- Class
    "ﰮ", -- Interface
    "", -- Module
    "", -- Property
    "", -- Unit
    "", -- Value
    "", -- Enum
    "", -- Keyword
    "﬌", -- Snippet
    "", -- Color
    "", -- File
    "", -- Reference
    "", -- Folder
    "", -- EnumMember
    "", -- Constant
    "", -- Struct
    "", -- Event
    "ﬦ", -- Operator
    "", -- TypeParameter
}

-- Set up completion using nvim_cmp with LSP source
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.flow.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

nvim_lsp.bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

nvim_lsp.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
    capabilities = capabilities,
}

nvim_lsp.lua_ls.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
    end,
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

nvim_lsp.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

nvim_lsp.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
        },
    },
}
--[[ nvim_lsp.tailwindcss.setup { ]]
--[[     on_attach = on_attach, ]]
--[[     capabilities = capabilities, ]]
--[[ } ]]
nvim_lsp.eslint.setup {
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
    end,
    filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "javascript",
        "javascriptreact",
        "javascript.jsx",
    },
    capabilities = capabilities,
}

nvim_lsp.volar.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

nvim_lsp.cssls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 5, prefix = "●" },
        severity_sort = true,
    })

local icons = require "mcampbellr.icons"
local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(
        sign.name,
        { texthl = sign.name, text = sign.text, numhl = "" }
    )
end

local config = {
    virtual_text = false,
    signs = {
        active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
}

vim.diagnostic.config(config)

function M.enable_format_on_save()
    vim.cmd [[
        augroup format_on_save
        autocmd!
        autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })
        augroup end
    ]]
end

function M.disable_format_on_save()
    M.remove_augroup "format_on_save"
end

function M.toggle_format_on_save()
    if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
        M.enable_format_on_save()
        vim.notify "Enabled format on save"
    else
        M.disable_format_on_save()
        vim.notify "Disabled format on save"
    end
end

function M.remove_augroup(name)
    if vim.fn.exists("#" .. name) == 1 then
        vim.cmd("au! " .. name)
    end
end

vim.cmd [[ command! LspToggleAutoFormat execute 'lua require("mcampbellr.lsp.handlers").toggle_format_on_save()' ]]

return M
