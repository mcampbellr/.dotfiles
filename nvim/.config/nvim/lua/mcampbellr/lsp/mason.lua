local status, mason = pcall(require, "mason")
if not status then
    return
end

local status, mason_lsp = pcall(require, "mason-lspconfig")

mason.setup()
mason_lsp.setup()
