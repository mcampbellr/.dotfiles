local status, mason = pcall(require, "mason")
if not status then
    return
end

local masonstatus, mason_lsp = pcall(require, "mason-lspconfig")

if not masonstatus then
    return
end

mason.setup()
mason_lsp.setup {
    ensure_installed = { "sumneko_lua", "rust_analyzer", "gopls", "tsserver", "volar", "pyright" },
}
