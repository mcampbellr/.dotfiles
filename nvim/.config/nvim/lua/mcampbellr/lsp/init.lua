local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require "mcampbellr.lsp.lsp-installer"
require("mcampbellr.lsp.handlers").setup()
require "mcampbellr.lsp.null-ls"
