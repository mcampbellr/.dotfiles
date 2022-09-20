vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_enable_italic = 0

vim.g.hybrid_transparent_background = 1
vim.g.enable_italic_font = 1
vim.g.enable_bold_font = 1

vim.cmd "colorscheme gruvbox-material"
--[[ vim.cmd "colorscheme solarized" ]]

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

  hi TabLineSel guibg=NONE
  hi TabLine guibg=NONE
  hi TabLineFill guibg=NONE
  hi TabLineSel guifg=orange
  hi Visual  guifg=#000000 guibg=#bc7795 gui=none

  hi TelescopeBorder guifg=#5eacd

  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
]]