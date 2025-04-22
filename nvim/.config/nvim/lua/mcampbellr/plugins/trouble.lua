local icons = require("mcampbellr.icons")

return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        signs = {
            -- icons / text used for a diagnostic
            error = icons.diagnostics.Error,
            warning = icons.diagnostics.Warning,
            hint = icons.diagnostics.Hint,
            information = icons.diagnostics.Information,
            other = icons.diagnostics.Question,
        },
    },
    config = function()
        vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
        vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
        vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
        vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
        vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
        vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
    end
}
