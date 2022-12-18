local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require "mcampbellr.lsp.mason"
require "mcampbellr.lsp.handlers"
require "mcampbellr.lsp.null-ls"
