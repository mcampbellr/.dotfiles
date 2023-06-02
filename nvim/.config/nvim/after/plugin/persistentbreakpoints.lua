local status, persist = pcall(require, "persistent-breakpoints")
if not status then
    return
end

persist.setup {
    load_breakpoints_event = { "BufReadPost" },
}
