local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local yank_group = augroup("HighlightYank", {})

-- autocommand to run Lazy Sync when any of the files in the plugins directory is updated
autocmd("BufWritePost", {
    group = augroup("lazy_sync", {}),
    pattern = "*/lua//mcampbellr/plugins/*",
    callback = function()
        vim.cmd "Lazy Sync"
    end,
})

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

-- resize splits if window got resized
autocmd({ "VimResized" }, {
    group = augroup("resize_splits", {}),
    callback = function()
        vim.cmd "tabdo wincmd ="
    end,
})

-- close some filetypes with <q>
autocmd("FileType", {
    group = augroup("close_with_q", {}),
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set(
            "n",
            "q",
            "<cmd>close<cr>",
            { buffer = event.buf, silent = true }
        )
    end,
})

autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir", {}),
    callback = function(event)
        if event.match:match "^%w%w+://" then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

vim.cmd [[
  augroup _general_settings
    autocmd!
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
  au BufRead,BufNewFile *.handlebars set filetype=html5
  au BufRead,BufNewFile *.txt setlocal spell
]]
