local status_ok, transparent = pcall(require, "transparent")

if not status_ok then
    print "failed to load transparent"
    return
end

transparent.setup {
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
}
