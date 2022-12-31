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

-- Use a protected call so we don't error out on first use
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
    -- required plugins
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "lewis6991/impatient.nvim" -- Lua speed loader
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    use "akinsho/bufferline.nvim"

    -- Custom plugins
    use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
    use "Mephistophiles/surround.nvim" -- surround things easily
    use "RRethy/vim-illuminate"

    -- better comments
    use "numToStr/Comment.nvim"
    use "folke/todo-comments.nvim"
    use "JoosepAlviste/nvim-ts-context-commentstring"

    -- search and replace
    use "nvim-pack/nvim-spectre"

    -- File navigation
    use "kyazdani42/nvim-tree.lua"
    use "nvim-lualine/lualine.nvim"

    use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
    use "tpope/vim-repeat"

    -- Icons over nvim
    use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    }

    -- themes
    use "tjdevries/colorbuddy.nvim"
    use "mcampbellr/neosolarized.nvim"
    use "sainnhe/gruvbox-material"
    use "morhetz/gruvbox"

    -- cmp plugins
    use {
        "neovim/nvim-lspconfig",
        requires = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "tami5/lspsaga.nvim" }, -- nightly
            { "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
            { "b0o/SchemaStore.nvim" },
        },
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-buffer" }, -- buffer completions
            { "hrsh7th/cmp-path" }, -- path completions
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
            { "L3MON4D3/LuaSnip" }, --snippet engine
            { "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use
            {
                "tzachar/cmp-tabnine",
                run = "./install.sh",
                requires = "hrsh7th/nvim-cmp",
            },
        },
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-telescope/telescope-fzy-native.nvim" },
        },
    }

    use "ThePrimeagen/harpoon"

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use "windwp/nvim-ts-autotag"
    use "romgrk/nvim-treesitter-context"

    -- Undotree
    use "mbbill/undotree"

    -- Git
    use "lewis6991/gitsigns.nvim"
    use "dinhhuy258/git.nvim"

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
