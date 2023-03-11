local status, git = pcall(require, "git")
if not status then
    return
end

git.setup {
    default_mappings = false,
    keymaps = {
        blame = "<leader>gb",
        quit_blame = "q",
    },
}
