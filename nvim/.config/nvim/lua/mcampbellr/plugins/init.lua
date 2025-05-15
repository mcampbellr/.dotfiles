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
