local KEYMAP = {}

local function bind(op, outer_opts)
    outer_opts = outer_opts or { noremap = true, silent = true }

    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", outer_opts, opts or {})
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

KEYMAP.nmap = bind("n", { noremap = false })
KEYMAP.nnoremap = bind "n"
KEYMAP.vnoremap = bind "v"
KEYMAP.xnoremap = bind "x"
KEYMAP.inoremap = bind "i"

return KEYMAP
