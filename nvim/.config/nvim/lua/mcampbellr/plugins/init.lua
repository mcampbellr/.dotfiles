return {
    -- library used by other plugins
    { "nvim-lua/plenary.nvim", lazy = true },
    -- makes some plugins dot-repeatable like leap

    { "tpope/vim-dotenv", lazy = true },
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "nvim-lua/popup.nvim" },
    {
        "lewis6991/impatient.nvim",
        config = function()
            require("impatient").enable_profile()
        end,
    },
    --[[ { "folke/neodev.nvim", opts = {} }, ]]
    { "christoomey/vim-tmux-navigator" },
    { "mbbill/undotree" },
    {
        "echasnovski/mini.surround",
        config = function()
            require("mini.surround").setup {}
        end,
    },
    {
        "gerazov/vim-toggle-bool",
        keys = {
            { "<leader>tb", ":ToggleBool<cr>" },
        },
        dependencies = {
            "AndrewRadev/switch.vim",
        },
    },
}

--[[ -- Install your plugins here ]]
--[[     use "akinsho/bufferline.nvim" ]]
--[[     use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter ]]
--[[     use "Mephistophiles/surround.nvim" -- surround things easily ]]

--[[     use "windwp/nvim-spectre" ]]

--[[     use "norcalli/nvim-colorizer.lua" ]]

--[[     use "" ]]
--[[]]
--[[     -- Cmp Plugins ]]
--[[     use { ]]
--[[         "neovim/nvim-lspconfig", ]]
--[[         requires = { ]]
--[[             { "williamboman/mason.nvim" }, ]]
--[[             { "williamboman/mason-lspconfig.nvim" }, ]]
--[[             { "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters ]]
--[[             { "b0o/SchemaStore.nvim" }, ]]
--[[             { "nvim-tree/nvim-web-devicons" }, ]]
--[[             { "glepnir/lspsaga.nvim" }, ]]
--[[         }, ]]
--[[     } ]]
--[[]]
--[[     use { ]]
--[[         , ]]
--[[         requires = { ]]
--[[             { "hrsh7th/cmp-buffer" }, ]]
--[[             { "hrsh7th/cmp-path" }, ]]
--[[             { "hrsh7th/cmp-nvim-lsp" }, ]]
--[[             { "hrsh7th/cmp-nvim-lua" }, ]]
--[[             { "saadparwaiz1/cmp_luasnip" }, ]]
--[[             { "L3MON4D3/LuaSnip" }, ]]
--[[             { "tzachar/cmp-tabnine", run = "./install.sh" }, ]]
--[[             { "rafamadriz/friendly-snippets" }, ]]
--[[         }, ]]
--[[     } ]]
--[[     -- Tmux Integrations ]]
--[[     use "christoomey/vim-tmux-navigator" ]]
--[[]]
--[[]]
--[[     -- Quick list ]]
--[[     use { "kevinhwang91/nvim-bqf", ft = "qf" } ]]
--[[     use "ThePrimeagen/harpoon" ]]
--[[]]
--[[     -- Treesitter ]]
--[[     use { } ]]
--[[     use "windwp/nvim-ts-autotag" ]]
--[[     use "romgrk/nvim-treesitter-context" ]]
--[[]]
--[[     -- Undotree ]]
--[[     use "mbbill/undotree" ]]
--[[]]
--[[     -- Git ]]
--[[     use "dinhhuy258/git.nvim" ]]
--[[     use "lewis6991/gitsigns.nvim" ]]
--[[]]
--[[     -- DAP ]]
--[[     use "David-Kunz/jester" ]]
--[[     use "Weissle/persistent-breakpoints.nvim" ]]
--[[     use "mfussenegger/nvim-dap" ]]
--[[     use "rcarriga/nvim-dap-ui" ]]
--[[]]
