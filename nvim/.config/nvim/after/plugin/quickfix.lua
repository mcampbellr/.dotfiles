local status, quickfix = pcall(require, "bqf")

if not status then
    return
end

quickfix.setup {
    auto_enable = true,
    auto_resize_height = true, -- highly recommended enable
    preview = {
        win_height = 24,
        win_vheight = 24,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        show_title = false,
        should_preview_cb = function(bufnr, _)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
                -- skip file size greater than 100k
                ret = false
            elseif bufname:match "^fugitive://" then
                -- skip fugitive buffer
                ret = false
            end
            return ret
        end,
    },
    -- make `drop` and `tab drop` to become preferred
    func_map = {
        open = "",
        openc = "<CR>",
        drop = "<CR>",
        split = "<C-s>",
        tabdrop = "<C-t>",
        -- set to empty string to disable
        tabc = "",
        ptogglemode = "z,",
    },
    filter = {
        fzf = {
            action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
    },
}