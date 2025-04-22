-- General Vim settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Netrw settings
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4

-- Syntax highlight
vim.cmd "syntax on"

-- Global options
local options = {
    -- Search
    ignorecase = false,
    smartcase = true,
    hlsearch = true,
    incsearch = true,

    -- UI
    termguicolors = true,
    signcolumn = "yes",
    background = "dark",
    colorcolumn = "80",
    number = true,
    relativenumber = true,
    numberwidth = 3,
    cmdheight = 1,

    -- Tabs/Indentation
    shiftwidth = 2,
    tabstop = 2,
    softtabstop = 2,
    expandtab = true,
    smartindent = true,

    -- File encoding
    fileencoding = "utf-8",

    -- Scrolling
    scrolloff = 10,
    sidescrolloff = 8,

    -- Windows
    splitbelow = true,
    splitright = true,

    -- Clipboard
    clipboard = "",

    -- Misc
    mouse = "a",
    hidden = true,
    wrap = false,
    backup = false,
    swapfile = false,
    undodir = os.getenv "HOME" .. "/.local/share/nvim/undodir",
    undofile = true,
    updatetime = 50,
    timeoutlen = 500,
    showmode = false,
    showmatch = true,
    conceallevel = 0,
    completeopt = { "menu", "menuone", "noselect" },
    pumheight = 10,
    list = false,
    guicursor = "",
    foldmethod = "indent",
    foldlevelstart = 99,
    foldenable = false,
    spellsuggest = "best",
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.shortmess:append "c"
vim.opt.iskeyword:append "-"
vim.opt.whichwrap:append "<,>,[,],h,l"

