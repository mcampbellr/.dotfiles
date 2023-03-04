local status_ok, transparent = pcall(require, "transparent")

if not status_ok then
    return
end

transparent.setup {
    enable = true,
    extra_groups = {
        "NvimTreeNormal",
        "NvimTreeVertSplit",
        "NvimTreeEndOfBuffer",
        "TabLineSel",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        "SignColumn",
        "VertSplit",
        "SignColumn",
        "EndOfBuffer",
    },
    disable = { "dashboard" },
}
