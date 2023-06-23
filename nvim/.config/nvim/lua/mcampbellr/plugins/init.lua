return {
-- library used by other plugins
    { "nvim-lua/plenary.nvim", lazy = true },
    -- makes some plugins dot-repeatable like leap
    { "tpope/vim-repeat", event = "VeryLazy" },
    {"lewis6991/impatient.nvim"},
    {"christoomey/vim-tmux-navigator"},
}

--[[]]
--[[ -- Install your plugins here ]]
--[[     -- Local development ]]
--[[     use "~/Developer/Personal/docker.nvim" ]]
--[[]]
--[[     -- Required Plugins ]]
--[[     use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim ]]
--[[      -- Lua speed loader ]]
--[[     use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins ]]
--[[     use "akinsho/bufferline.nvim" ]]
--[[]]
--[[     -- Custom Plugins ]]
--[[     use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter ]]
--[[     use "Mephistophiles/surround.nvim" -- surround things easily ]]
--[[]]
--[[     -- Better Comments ]]
--[[     use "numToStr/Comment.nvim" ]]
--[[     use "folke/todo-comments.nvim" ]]
--[[     use "JoosepAlviste/nvim-ts-context-commentstring" ]]
--[[]]
--[[     -- File Navigation ]]
--[[     use "kyazdani42/nvim-tree.lua" ]]
--[[     use "nvim-lualine/lualine.nvim" ]]
--[[     -- Search and Replacke ]]
--[[     use "windwp/nvim-spectre" ]]
--[[     use "github/copilot.vim" ]]
--[[]]
--[[     use "norcalli/nvim-colorizer.lua" ]]
--[[]]
--[[     -- Themes ]]
--[[     use "sainnhe/gruvbox-material" ]]
--[[     use  ]]
--[[     use "xiyaowong/nvim-transparent" ]]
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

