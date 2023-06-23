return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "windwp/nvim-ts-autotag",
        {
            "romgrk/nvim-treesitter-context",
            opts = {
                enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
                throttle = true, -- Throttles plugin updates (may improve performance)
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
            }
        }
    },
    event = "BufEnter",
    build = ":TsUpdate",
    config = function() 
        require'nvim-treesitter.configs'.setup {
            ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
            ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
            highlight = {
                -- use_languagetree = true,
                enable = true, -- false will disable the whole extension
                -- disable = { "css", "html" }, -- list of language that will be disabled
                disable = { "css" }, -- list of language that will be disabled
                additional_vim_regex_highlighting = true,
            },
            autopairs = {
                enable = true,
            },
            indent = { enable = true, disable = { "yaml", "python", "css" } },
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
            autotag = {
                enable = true,
                disable = { "xml" },
            },
            playground = {
                enable = true,
            },
        }
    end
}
