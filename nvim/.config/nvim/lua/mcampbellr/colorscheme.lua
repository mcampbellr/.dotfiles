vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_enable_italic = 0

vim.g.hybrid_transparent_background = 1
vim.g.enable_italic_font = 1
vim.g.enable_bold_font = 1

vim.g.sonokai_style = "shusia"
vim.g.sonokai_better_performance = 1
vim.g.everforest_background = "hard"

--[[ local colorscheme = "sonokai" ]]
--[[ local colorscheme = "gruvbox-material" ]]
local colorscheme = "onedark"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found")
    return
end

vim.cmd [[
  hi Normal guibg=NONE
  hi NormalNC guibg=NONE

  hi Normal guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE guifg=#5A6895
  hi SignColumn guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE

  hi CursorLineNr guibg=NONE guifg=#47CC6F
  hi ColorColumn guibg=#333540

  hi VertSplit guibg=NONE
  hi SignColumn guibg=NONE
  hi Folded guibg=NONE guifg=orange

  hi HarpoonWindow guibg=NONE guifg=White
  hi HarpoonBorder guibg=NONE guifg=DarkGray

  hi TabLineSel guibg=NONE
  hi TabLine guibg=NONE
  hi TabLineFill guibg=NONE
  hi TabLineSel guifg=orange
  hi Visual  guifg=#000000 guibg=#bc7795 gui=none

  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
]]
