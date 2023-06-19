local status, colorizer = pcall(require, "colorizer")
if not status then
    return
end

colorizer.setup {
    "css",
    "javascript",
    "vim",
    "html",
    "lua",
    "typescriptreact",
    "javascriptreact",
    "vue",
}
