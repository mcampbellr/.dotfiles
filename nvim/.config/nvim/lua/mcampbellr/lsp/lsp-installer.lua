local status, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status then
  return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require("mcampbellr.lsp.handlers").on_attach,
    capabilities = require("mcampbellr.lsp.handlers").capabilities,
  }

  if server.name == "jsonls" then
    local jsonls_opts = require "mcampbellr.lsp.settings.jsonls"
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

  if server.name == "sumneko_lua" then
    local sumneko_opts = require "mcampbellr.lsp.settings.sumneko_lua"
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server.name == "volar" then
    local vuels_opts = require "mcampbellr.lsp.settings.vuels"
    opts = vim.tbl_deep_extend("force", vuels_opts, opts)
  end

  if server.name == "pyright" then
    local pyright_opts = require "mcampbellr.lsp.settings.pyright"
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server.name == "jdtls" then
    return
  end

  if server.name == "bashls" then
    local bashls_opts = require "mcampbellr.lsp.settings.bashls"
    opts = vim.tbl_deep_extend("force", bashls_opts, opts)
  end

  if server.name == "solang" then
    local solang_opts = require "mcampbellr.lsp.settings.solang"
    opts = vim.tbl_deep_extend("force", solang_opts, opts)
  end

  if server.name == "solc" then
    local solc_opts = require "mcampbellr.lsp.settings.solc"
    opts = vim.tbl_deep_extend("force", solc_opts, opts)
  end

  if server.name == "emmet_ls" then
    local emmet_ls_opts = require "mcampbellr.lsp.settings.emmet_ls"
    opts = vim.tbl_deep_extend("force", emmet_ls_opts, opts)
  end

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)