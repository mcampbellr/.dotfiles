local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)
    -- Required Plugins
    use { "wbthomason/packer.nvim" } -- Have packer manage itself
    use { "nvim-lua/popup.nvim" } -- An implementation of the Popup API from vim in Neovim
    use { "lewis6991/impatient.nvim" } -- Lua speed loader
    use { "nvim-lua/plenary.nvim" } -- Useful lua functions used ny lots of plugins
    use { "akinsho/bufferline.nvim" }
    -- Developer plugins
    use {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        requires = { "nvim-tree/nvim-web-devicons" },
    }

    -- Custom Plugins
    use { "windwp/nvim-autopairs" } -- Autopairs, integrates with both cmp and treesitter
    use { "Mephistophiles/surround.nvim" } -- surround things easily

    -- Better Comments
    use { "numToStr/Comment.nvim" }
    use { "folke/todo-comments.nvim" }
    use { "JoosepAlviste/nvim-ts-context-commentstring" }

    -- File Navigation
    use { "kyazdani42/nvim-tree.lua" }
    use { "nvim-lualine/lualine.nvim" }
    -- Search and Replacke
    use { "windwp/nvim-spectre" }
    use { "github/copilot.vim" }

    -- Colors in Text
    use { "norcalli/nvim-colorizer.lua" }

    -- Themes
    use { "sainnhe/gruvbox-material" }
    use { "navarasu/onedark.nvim" }
    use { "xiyaowong/nvim-transparent" }

    -- Cmp Plugins
    use {
        "neovim/nvim-lspconfig",
        requires = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
            { "b0o/SchemaStore.nvim" },
            { "nvim-tree/nvim-web-devicons" },
            { "glepnir/lspsaga.nvim" },
        },
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "saadparwaiz1/cmp_luasnip" },
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
    }
    -- Tmux Integrations
    use { "christoomey/vim-tmux-navigator" }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-telescope/telescope-fzy-native.nvim" },
        },
    }

    -- Quick list
    use { "kevinhwang91/nvim-bqf", ft = "qf" }
    use { "ThePrimeagen/harpoon" }

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use { "windwp/nvim-ts-autotag" }
    use { "romgrk/nvim-treesitter-context" }

    -- Undotree
    use { "mbbill/undotree" }

    -- Git
    use { "dinhhuy258/git.nvim" }
    use { "lewis6991/gitsigns.nvim" }

    -- DAP
    use { "David-Kunz/jester" }
    use { "Weissle/persistent-breakpoints.nvim" }
    use { "mfussenegger/nvim-dap" }
    use { "rcarriga/nvim-dap-ui" }

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
