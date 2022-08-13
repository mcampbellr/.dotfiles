local Remap = require('mcampbellr.keymap')
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local nmap = Remap.nmap

vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

--Remap space as leader key
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
nnoremap("<leader>rp", ':%s///g<left><left>')
-- Undotree
nnoremap("<leader>u", ":UndotreeToggle<CR>")

-- Naviagate buffers
nnoremap("<S-l>", ":bnext<CR>")
nnoremap("<S-h>", ":bprevious<CR>")

-- resource the nvim config
nmap("<Leader>rs", ":so ~/.config/nvim/init.lua<CR>")

-- Keep the cursor center
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")

-- Delete all the page content
nnoremap("<leader>Y", "ggVGy<esc>")

-- Delete all the page content
nnoremap("<leader>D", "ggdG<esc>")

-- Paste and replace all the page content
nnoremap("<leader>P", "ggVGp<esc>")

-- Select all the page content
nnoremap("<leader>V", "gg0VG$")

-- Delete the search highlighting
nnoremap("<Bslash>", ":let @/ = ''<CR>")

nnoremap("<Leader>+", ":vertical resize +10<CR>")
nnoremap("<Leader>-", ":vertical resize -5<CR>")

-- F keys
nnoremap("<F1>", ":lua require('harpoon.ui').nav_file(1)<CR>")
nnoremap("<F2>", ":lua require('harpoon.ui').nav_file(2)<CR>")
nnoremap("<F3>", ":lua require('harpoon.ui').nav_file(3)<CR>")
nnoremap("<F4>", ":lua require('harpoon.ui').nav_file(4)<CR>")
nnoremap("<F5>", ":lua require('harpoon.ui').nav_file(5)<CR>")
nnoremap("<F6>", ":lua require('harpoon.ui').nav_file(6)<CR>")
nnoremap("<F7>", ":LspToggleAutoFormat<CR>")
nnoremap("<F8>", ":Telescope resume<cr>")
nnoremap("<F9>", ":Registers<cr>")


-- Visual --
-- search for visually hightlighted text
vnoremap("<C-f>", 'y<ESC>/<c-r>"<CR><ESC>')

-- Paste in visual_mode
vnoremap("p", '"_dP')

vnoremap("<c-s>", ":'<,'>TakeScreenShot<cr> | :! open ~/Images/code-screenshot/ <CR>")
