vim.g.hybrid_transparent_background = 1
vim.g.enable_italic_font = 1
vim.g.enable_bold_font = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_cursor = "orange"

vim.cmd [[colorscheme gruvbox-material]]

vim.cmd [[
  hi Normal guibg=NONE
  hi NormalNC guibg=NONE

  hi IlluminatedWordText guibg=#333540
  hi IlluminatedWordRead guibg=#333540
  hi IlluminatedWordWrite guibg=#333540

  hi Normal guibg=NONE ctermbg=NONE
  hi Visual guibg=#CB66A4 guifg=black
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

  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
]]
