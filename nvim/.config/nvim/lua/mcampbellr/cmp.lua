local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

local check_backspace = function()
    local line, col = vim.api.nvim_win_get_cursor()
    return col ~= 0 and string.match(vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col), "%s") == nil
end

require("luasnip/loaders/from_vscode").lazy_load()

vim.g.cmp_active = true

local source_mapping = {
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    luasnip = "[SNIP]",
    buffer = "[BUFF]",
    path = "[PATH]",
}

local icons = require "mcampbellr.icons"
local kind_icons = icons.kind

cmp.setup {
    enabled = function()
        local buftype = vim.api.nvim_buf_get_option(0, "buftype")
        if buftype == "prompt" then
            return false
        end
        return vim.g.cmp_active
    end,
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = kind_icons[vim_item.kind]

            vim_item.menu = (source_mapping)[entry.source.name]
            return vim_item
        end,
    },
    experimental = {
        ghost_text = false,
    },
    mapping = cmp.mapping.preset.insert {
        ["<CR>"] = cmp.mapping.confirm {
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
        },
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<C-l>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        ["<c-n>"] = cmp.mapping(function(fallback)
            if luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path" },
    }, {
        { name = "buffer" },
    }),
}

-- Set configuration for specific filetype.
--[[ cmp.setup.filetype("gitcommit", { ]]
--[[     sources = cmp.config.sources({ ]]
--[[         { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it. ]]
--[[     }, { ]]
--[[         { name = "buffer" }, ]]
--[[     }), ]]
--[[ }) ]]
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})
