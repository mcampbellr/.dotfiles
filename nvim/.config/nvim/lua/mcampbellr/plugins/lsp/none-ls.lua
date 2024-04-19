local status, null_ls = pcall(require, "null-ls")
if not status then
    return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
--[[ local code_actions = null_ls.builtins.code_actions ]]

null_ls.setup {
    sources = {
        formatting.prettierd,
        formatting.stylua,
        diagnostics.yamllint,
        formatting.yamlfix,
    },
}

