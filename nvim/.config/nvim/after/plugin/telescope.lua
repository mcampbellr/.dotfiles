local status, telescope = pcall(require, "telescope")
if not status then
    return
end

telescope.setup {
    defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    },
    file_ignore_patterns = { "node_modules", ".git" },
    pickers = {
        find_files = {
            hidden = true,
        },
        live_grep = {
            hidden = true,
        },
        buffers = {},
        oldfiles = {},
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    },
}

telescope.load_extension "fzy_native"
