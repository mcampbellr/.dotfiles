local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

local mason_status, mason = pcall(require, "mason")
if not mason_status then
    return
end

local masons_lsp_status, mason_lsp = pcall(require, "mason-lspconfig")
if not masons_lsp_status then
    return
end

require "mcampbellr.lsp.configs"
require "mcampbellr.lsp.autoformat"
require "mcampbellr.lsp.handlers"
require "mcampbellr.lsp.null-ls"

mason.setup()
mason_lsp.setup {
    ensure_installed = default_lsps,
}
