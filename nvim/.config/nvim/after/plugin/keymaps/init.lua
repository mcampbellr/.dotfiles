local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local nmap = Remap.nmap

-- Navigate and center the cursor in the middle
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- Remove the worst key in vim haha
nnoremap("Q", "<Nop>")

-- Normal --
-- Better window navigation
nnoremap("<up>", "<C-w>k")
nnoremap("<down>", "<C-w>j")
nnoremap("<left>", "<C-w>h")
nnoremap("<right>", "<C-w>l")

-- Resize with arrows
nnoremap("<C-Up>", ":resize -2<CR>")
nnoremap("<C-Down>", ":resize +2<CR>")
nnoremap("<C-Left>", ":vertical resize -2<CR>")
nnoremap("<C-Right>", ":vertical resize +2<CR>")

-- Replace
nmap("<leader>rp", ":%s///g<left><left>")
nmap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- Undotree
nnoremap("<leader>u", ":UndotreeToggle | UndotreeFocus<CR>")

-- Naviagate buffers
nnoremap("<S-l>", ":bnext<CR>")
nnoremap("<S-h>", ":bprevious<CR>")

-- Resource the nvim config
nmap("<Leader>rs", ":so ~/.config/nvim/init.lua<CR>")

-- Keep the cursor center
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")

-- next greatest remap ever
nnoremap("<leader>y", '"+y')
nnoremap("<leader>Y", '"+Y')
vnoremap("<leader>y", '"+y')

-- Delete without adding to the clipboard
nnoremap("<leader>d", '"_d')
vnoremap("<leader>d", '"_d')
nnoremap("<leader>p", '"+p')

-- Select all the page content
nnoremap("<leader>V", "gg0VG$")

-- Delete the search highlighting
nnoremap("<Bslash>", ":let @/ = ''<CR>")

-- Rezize splits
nnoremap("<Leader>+", ":vertical resize +10<CR>")
nnoremap("<Leader>-", ":vertical resize -5<CR>")

nmap("<leader>f", function()
    vim.lsp.buf.format()
    print "Formated!"
end)

nnoremap("<C-o>", "<cmd>silent !tmux neww ss<CR>")

-- F keys
nnoremap("<F1>", function()
    require("harpoon.ui").nav_file(1)
end)

nnoremap("<F2>", function()
    require("harpoon.ui").nav_file(2)
end)

nnoremap("<F3>", function()
    require("harpoon.ui").nav_file(3)
end)

nnoremap("<F4>", function()
    require("harpoon.ui").nav_file(4)
end)

nnoremap("<F5>", function()
    require("harpoon.ui").nav_file(5)
end)

nnoremap("<F6>", function()
    require("harpoon.ui").nav_file(6)
end)

nnoremap("<F7>", ":Telescope resume<cr>")
nnoremap("<F8>", ":Telescope registers<cr>")

-- Visual --
-- search for visually hightlighted text
vnoremap("<C-f>", 'y<ESC>/<c-r>"<CR><ESC>')

-- Allow moving the selected lines up and down and keep selection
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

-- Paste in visual_mode
vnoremap("p", '"_dP')

vnoremap("<c-s>", ":'<,'>TakeScreenShot<cr> | :! open ~/Images/code-screenshot/ <CR>")
