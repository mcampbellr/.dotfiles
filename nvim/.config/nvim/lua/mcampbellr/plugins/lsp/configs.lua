local M = {}

local protocol_status, protocol = pcall(require, "vim.lsp.protocol")
if not protocol_status then
    return
end

local icons = require "mcampbellr.icons"

function M.lsp_keymaps(bufnr)
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
    keymap(bufnr, "n", "gl", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
end

function M.on_attach(client, bufnr)
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

    M.lsp_keymaps(bufnr)
end

-- Set up completion using nvim_cmp with LSP source
M.capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

M.diagnostic_config = {
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

M.default_lsps = {
    "bashls",
    "cssls",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "tailwindcss",
    "tsserver",
    "volar",
    "yamlls",
}

vim.diagnostic.config(M.diagnostic_config)

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 5, prefix = "●" },
        severity_sort = true,
    })

local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
}

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

for _, sign in ipairs(signs) do
    vim.fn.sign_define(
        sign.name,
        { texthl = sign.name, text = sign.text, numhl = "" }
    )
end

return M
