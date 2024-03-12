return {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            typescript = { "eslint_d", { "prettierd", "prettier" } },
            typescriptreact = { "eslint_d", { "prettierd", "prettier" } },
            vue = { "eslint_d", { "prettierd", "prettier" } },
            json = { "prettierd", "prettier" },
            jsonc = { "prettierd", "prettier" },
            html = { "prettierd", "prettier" },
            go = { "gofmt", "goimports", "golines" },
            make = { "cmakelang" }
        },
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 3000,
            lsp_fallback = true,
        },
    },
}
