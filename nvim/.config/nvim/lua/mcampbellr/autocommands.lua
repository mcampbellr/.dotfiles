local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank {
            higroup = "Visual",
            timeout = 40,
        }
    end,
})

vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo,spectre_panel nnoremap <silent> <buffer> q :close<CR>
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
    autocmd CmdWinEnter * quit
    autocmd BufEnter * :set colorcolumn=80
    autocmd FileType git.nvim,qf setlocal cursorline
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end

  augroup _tabsize
    autocmd!
    autocmd FileType go,lua,dart setlocal shiftwidth=4
    autocmd FileType go,lua,dart  setlocal tabstop=4
    autocmd FileType go,lua,dart setlocal softtabstop=4
  augroup end

  augroup acursorLine
    autocmd!
    autocmd FileType,BufEnter NvimTree* setlocal cursorline
  augroup END

  au BufRead,BufNewFile *.prettierrc,.repoconfig,*.json set filetype=jsonc
  au BufRead,BufNewFile *.styl set filetype=sass
  au BufRead,BufNewFile *.txt setlocal spell
]]
