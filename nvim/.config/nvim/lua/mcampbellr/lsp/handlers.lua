local status, nvim_lsp = pcall(require, "lspconfig")
if not status then
    return
end

local protocol = require "vim.lsp.protocol"

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })

local enable_format_on_save = function(_, bufnr)
    vim.api.nvim_clear_autocmds { group = augroup_format, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format { bufnr = bufnr }
        end,
    })
end

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    keymap(bufnr, "n", "gh", "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", opts)
    keymap(bufnr, "n", "gp", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", opts)
    keymap(bufnr, "n", "gt", "<cmd>lua require'lspsaga.provider'.type_definition()<CR>", opts)
    keymap(bufnr, "n", "<leader>a", "<cmd>Lspsaga code_action<cr>", opts)
    keymap(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
    keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
    keymap(bufnr, "n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
    keymap(bufnr, "n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
    keymap(bufnr, "i", "<C-k>", "<cmd>Lspsaga signature_help<CR>", opts)
    keymap(bufnr, "n", "gl", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    vim.cmd [[
        augroup format_on_save
        autocmd! 
        autocmd BufWritePre * lua vim.lsp.buf.format() 
        augroup end
    ]]

    -- print(client.name)

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

nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
    capabilities = capabilities,
}

nvim_lsp.sumneko_lua.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        enable_format_on_save(client, bufnr)
    end,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
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

nvim_lsp.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
        },
    },
}

nvim_lsp.tailwindcss.setup {
    on_attach = on_attach,
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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 5, prefix = "-" },
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
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
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
