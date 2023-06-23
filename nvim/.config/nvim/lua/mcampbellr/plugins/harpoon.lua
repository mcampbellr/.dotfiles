return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    opts = {
        menu = {
            width = 80,
            height = 10,
        },
    },
    keys = {
        {
            "<leader>e", function()
                require("harpoon.ui").toggle_quick_menu()
            end
        },
        {
            "<leader>m", function()
                require("harpoon.mark").add_file()
            end
        }
    }
}

