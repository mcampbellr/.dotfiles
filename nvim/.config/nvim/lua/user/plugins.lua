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
  -- My plugins here
  -- required plugins
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "lewis6991/impatient.nvim" -- Lua speed loader
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

  -- Custom plugins
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "lukas-reineke/indent-blankline.nvim" -- indentention of white lines
  use "Mephistophiles/surround.nvim" -- surround things easily
  use "tversteeg/registers.nvim" -- show registors using " in normal mode
  use "kevinhwang91/nvim-bqf" -- pretti preview in quicklist

  -- better comments
  use "numToStr/Comment.nvim"
  use "folke/todo-comments.nvim"
  use "JoosepAlviste/nvim-ts-context-commentstring"
  -- Icons over nvim
  use "kyazdani42/nvim-web-devicons"
  -- Better notifications
  use "rcarriga/nvim-notify"
  -- File navigation
  use "akinsho/bufferline.nvim"
  use "goolord/alpha-nvim"
  use "kyazdani42/nvim-tree.lua"
  use "moll/vim-bbye" -- Close buffer without close nvim
  use "nvim-lualine/lualine.nvim"

  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use "norcalli/nvim-colorizer.lua"
  use "ThePrimeagen/harpoon"
  use "tpope/vim-repeat"
  use "ahmedkhalf/project.nvim"

  -- language specific plugins
  use "lunarvim/vim-solidity"
  use "thosakwe/vim-flutter"
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
  }

  -- Colorschemes
  use "crusoexia/vim-monokai"
  use "overcache/NeoSolarized"
  use "folke/tokyonight.nvim"
  use "joshdick/onedark.vim"

  -- cmp plugins
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-emoji"
  use "hrsh7th/cmp-nvim-lua"
  use "David-Kunz/cmp-npm"
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use {
    "tzachar/cmp-tabnine",
    config = function()
      local tabnine = require "cmp_tabnine.config"
      tabnine:setup {
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = "..",
        ignored_file_types = { -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        },
      }
    end,

    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
  }

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  use "filipdutescu/renamer.nvim"
  use "ray-x/lsp_signature.nvim" -- Helper when typing functions and other things
  use "b0o/SchemaStore.nvim"
  use {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  }
  use {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  }

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-fzy-native.nvim"
  use "dhruvmanila/telescope-bookmarks.nvim"
  use "ThePrimeagen/git-worktree.nvim"

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "nvim-treesitter/playground"

  use "p00f/nvim-ts-rainbow"
  use "windwp/nvim-ts-autotag"
  use "romgrk/nvim-treesitter-context"
  use "mizlan/iswap.nvim"

  -- Git
  use "lewis6991/gitsigns.nvim"
  use "tpope/vim-fugitive"


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
