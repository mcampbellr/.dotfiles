return {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
        require("colorizer").setup {
            "*",
            css = { rgb_fn = true },
            html = { names = false },
            sass = { rgb_fn = true },
            scss = { rgb_fn = true },
            stylus = { rgb_fn = true },
            tailwind = { css = true, css_fn = true },
        }
    end,
}
