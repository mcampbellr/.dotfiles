return {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            typescript = { "eslint_d", { "prettierd", "prettier" } },
            vue = { "eslint_d", { "prettierd", "prettier" } },
            go = { "gofmt", "goimports", "golines" },
        },
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_fallback = true,
        },
    },
}
