local cmp = require "cmp"
local luasnip = require "luasnip"

require("luasnip/loaders/from_vscode").lazy_load()

vim.g.cmp_active = true

local source_mapping = {
    nvim_lsp = "[LSP]",
    cmp_tabnine = "[T9]",
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
        ["<C-y>"] = cmp.mapping.confirm {
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
        { name = "cmp_tabnine" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path" },
    }, {
        { name = "buffer" },
    }),
}

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = "buffer" },
        { name = "cmp_tabnine" },
    }),
})

-- add new keymap to cmdline table
local cmp_cmdline = cmp.mapping.preset.cmdline()

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp_cmdline,
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp_cmdline,
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline", keyword_length = 3 },
    }),
})
