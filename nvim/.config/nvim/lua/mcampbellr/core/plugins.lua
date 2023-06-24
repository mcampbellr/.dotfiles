local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local status_lazy, lazy = pcall(require, "lazy")
if not status_lazy then
    vim.notify(lazy, vim.log.levels.ERROR)
    return
end

lazy.setup {
    spec = {
        { import = "mcampbellr.plugins" },
    },
    dev = {
        -- directory where you store your local plugin projects
        path = "~/Developer/Personal/nvim-plugins",
        patterns = {}, -- For example {"folke"}
        fallback = false, -- Fallback to git when local plugin doesn't exist
    },
}
