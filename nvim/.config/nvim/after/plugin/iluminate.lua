local status, illuminate = pcall(require, "illuminate")

if not status then
    return
end

-- default configuration
illuminate.configure {
    delay = 300,
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = {
        "dirvish",
        "fugitive",
        "NvimTree",
        "harpoon",
        "qf",
    },
    min_count_to_highlight = 2,
}
