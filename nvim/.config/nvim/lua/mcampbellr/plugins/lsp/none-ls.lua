local status, null_ls = pcall(require, "null-ls")
if not status then
    return
end

local formatting = null_ls.builtins.formatting

null_ls.setup {
    sources = {
        formatting.prettierd,
        formatting.stylua,
        formatting.black,
        formatting.goimports,
        formatting.golines,
        formatting.yamlfix,
        formatting.prisma_format,
    },
}
