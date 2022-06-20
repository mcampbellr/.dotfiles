vim.cmd [[
colorscheme gruvbox-material

let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_better_performance = 1

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

hi Comment cterm=italic gui=italic

hi TabLineSel guibg=NONE
hi TabLine guibg=NONE
hi TabLineFill guibg=NONE
hi TabLineSel guifg=orange

hi Visual  guifg=#000000 guibg=#bc7795 gui=none

hi TelescopeBorder guifg=#5eacd


let g:neosolarized_underline = 1
let g:neosolarized_italic = 1

let g:monokai_term_italic = 1
let g:monokai_gui_italic = 1

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
]]
