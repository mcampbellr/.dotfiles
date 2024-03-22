return {
    'stevearc/conform.nvim',
    cmd = { "ConformInfo" },
    enabled = true,
    opts = {
        formatters_by_ft = {
            typescript = { "eslint_d", { "prettierd", "prettier" } },
            typescriptreact = { "eslint_d", { "prettierd", "prettier" } },
            vue = { "eslint_d", { "prettierd", "prettier" } },
            sql = { "sql-formatter" },
            json = { "prettierd", "prettier" },
            jsonc = { "prettierd", "prettier" },
            html = { "prettierd", "prettier" },
            go = { "gofmt", "goimports", "golines" },
            make = { "cmakelang" }
        },
    },
}
