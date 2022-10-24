vim.cmd "syntax enable"
vim.cmd "syntax on"

local options = {
    backup = false, -- creates a backup file
    clipboard = "", -- allows neovim to access the system clipboard
    cmdheight = 1, -- more space in the neovim command line for displaying messages
    colorcolumn = "80", -- set the width of the color column
    compatible = false,
    completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0, -- so that `` is visible in markdown files
    fileencoding = "utf-8", -- the encoding written to a file
    hidden = true, -- No idea how this works
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    incsearch = true, -- Incremental search
    mouse = "a", -- allow the mouse to be used in neovim
    number = true, -- set numbered lines
    numberwidth = 3, -- set number column width to 2 {default 4}
    pumheight = 10, -- pop up menu height
    relativenumber = true, -- set relative numbered lines
    scrolloff = 10, -- is one of my fav
    showmatch = true,
    showmode = false, -- we don't need to see things like -- INSERT -- anymore
    sidescrolloff = 8,
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    smartcase = true, -- smart case
    smartindent = true, -- make indenting smarter again
    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window
    swapfile = false, -- creates a swapfile
    termguicolors = true, -- set term gui colors (most terminals support this)
    undodir = "/Users/mcampbellr/.local/share/nvim/undodir", -- For the undo history
    undofile = true, -- enable persistent undo
    updatetime = 100, -- faster completion (4000ms default)
    wrap = false, -- display lines as one long line
    foldmethod = "indent", -- indentention fold method
    foldlevelstart = 20, -- expand folds to 20 levels - for open at first opening of a file
    spellsuggest = "best",
    list = true,
    listchars = "eol:↵,tab:  ,trail:•,extends:>,precedes:<",
    -- Tabs
    shiftwidth = 2, -- the number of spaces inserted for each indentation
    tabstop = 2, -- insert 4 spaces for a tab
    softtabstop = 2,
    expandtab = true, -- convert tabs to spaces
}

vim.opt.shortmess:append "c"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

for key, value in pairs(options) do
    vim.opt[key] = value
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
