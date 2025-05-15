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
nnoremap("<up>", "<Nop>")
nnoremap("<down>", "<Nop>")
nnoremap("<left>", "<Nop>")
nnoremap("<right>", "<Nop>")

-- Delete black hole
nnoremap("<leader>d", '"_d')
nnoremap("<leader>D", '"_D')
nnoremap("<leader>dd", '"_dd')

-- Replace
nmap("<leader>rp", ":%s///g<left><left>")
nmap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- Undotree
nnoremap("<leader>u", ":UndotreeToggle | UndotreeFocus<CR>")

-- Resource the nvim config and print success with <leader>rs
nnoremap("<leader>rs", ":source %<CR>:echo 'Sourced!'<CR>")

-- Keep the cursor center
nnoremap("J", "mzJ`z")

-- next greatest remap ever
nnoremap("<leader>y", '"+y')
nnoremap("<leader>Y", '"+Y')
vnoremap("<leader>y", '"+y')

-- Select all the page content
nnoremap("<leader>V", "gg0VG$")

-- Delete the search highlighting
nnoremap("<Bslash>", ":let @/ = ''<CR>")

-- Rezize splits
nnoremap("<Leader>+", ":vertical resize +10<CR>")
nnoremap("<Leader>-", ":vertical resize -10<CR>")

-- function to format the code
local function format_code()
    vim.lsp.buf.format({ async = false })
    print("formatting")
end


nmap("<leader>f", function()
    format_code()
end)

-- Harpoon
for i = 1, 9 do
    nnoremap(
        "<F" .. i .. ">",
        ":lua require('harpoon.ui').nav_file(" .. i .. ")<CR>"
    )
end

-- toogle between disable an enable copilot

nnoremap("<F10>", ":Copilot disable<CR>")
nnoremap("<F11>", ":Copilot enable<CR>")

nnoremap("<F12>", function()
    --[[ require("mcampbellr.plugins.lsp.autoformat").toggle_format_on_save() ]]
end)

-- Visual --

-- search for visually hightlighted text
vnoremap("<C-f>", 'y<ESC>/<c-r>"<CR><ESC>')

-- Allow moving the selected lines up and down and keep selection
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")
vnoremap("<Tab>", ">gv")
vnoremap("<S-Tab>", "<gv")

-- Paste in visual_mode
vnoremap("p", '"_dP')
