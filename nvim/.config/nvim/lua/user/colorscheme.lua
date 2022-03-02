vim.cmd [[
colorscheme onedark

set background=dark

highlight Normal guibg=NONE
highlight LineNr guibg=NONE guifg=#5A6895
highlight CursorLineNr guibg=NONE guifg=#47CC6F
highlight ColorColumn guibg=#333540

highlight VertSplit guibg=NONE
highlight SignColumn guibg=NONE
highlight Folded guibg=NONE guifg=orange

highlight Comment cterm=italic gui=italic

highlight TabLineSel guibg=NONE
highlight TabLine guibg=NONE
highlight TabLineFill guibg=NONE
highlight TabLineSel guifg=orange
highlight SignColumn guibg=none
highlight Normal guibg=none
highlight TelescopeBorder guifg=#5eacd

let g:neosolarized_underline = 1
let g:neosolarized_italic = 1

let g:monokai_term_italic = 1
let g:monokai_gui_italic = 1

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
]]
