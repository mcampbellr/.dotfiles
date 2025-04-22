local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
    group = augroup("HighlightYank", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { higroup = "Visual", timeout = 40 }
    end,
})

-- Reload if file changes outside Vim
vim.o.autoread = true
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = augroup("AutoReadOnExternalChange", { clear = true }),
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd "checktime"
        end
    end,
})

-- Lazy sync on plugin file save
autocmd("BufWritePost", {
    group = augroup("LazySync", {}),
    pattern = "*/lua//mcampbellr/plugins/*",
    callback = function()
        vim.cmd "Lazy sync"
    end,
})

-- Git.nvim fix
autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "git.nvim" then
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { " " })
        end
    end,
})

-- Resize splits on window resize
autocmd("VimResized", {
    group = augroup("ResizeSplits", {}),
    callback = function()
        vim.cmd "tabdo wincmd ="
    end,
})

-- Close special buffers with 'q'
autocmd("FileType", {
    group = augroup("CloseWithQ", {}),
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

-- Auto-create directories on save
autocmd("BufWritePre", {
    group = augroup("AutoCreateDir", {}),
    callback = function(event)
        if event.match:match "^%w%w+://" then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Remove formatoptions c, r, o on BufWinEnter
autocmd("BufWinEnter", {
    group = augroup("FixFormatOptions", {}),
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove { "c", "r", "o" }
    end,
})

-- Set cursorline in NvimTree and qf
autocmd({ "BufEnter", "FileType" }, {
    group = augroup("CursorLineFT", {}),
    pattern = { "NvimTree*", "qf", "git.nvim" },
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

-- Git commit & markdown filetypes wrap + spell
autocmd("FileType", {
    group = augroup("WrapAndSpell", {}),
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Tab size for Lua and Go
autocmd("FileType", {
    group = augroup("TabSizeLuaGo", {}),
    pattern = { "lua", "go" },
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
    end,
})

-- Filetype assignments
autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("FiletypeDetect", {}),
    pattern = { "*.prettierrc", ".repoconfig", "*.json" },
    callback = function()
        vim.bo.filetype = "jsonc"
    end,
})

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.styl" },
    callback = function()
        vim.bo.filetype = "sass"
    end,
})

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { ".env", "*.env.*", ".envrc" },
    callback = function()
        vim.bo.filetype = "sh"
    end,
})

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.handlebars",
    callback = function()
        vim.bo.filetype = "html5"
    end,
})

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.txt",
    callback = function()
        vim.opt_local.spell = true
    end,
})

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.yml",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})
