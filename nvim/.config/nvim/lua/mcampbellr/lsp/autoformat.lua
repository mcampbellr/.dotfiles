local M = {}

function M.enable_format_on_save()
    vim.cmd [[
        augroup format_on_save
        autocmd!
        autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })
        augroup end
    ]]
end

function M.disable_format_on_save()
    M.remove_augroup "format_on_save"
end

function M.toggle_format_on_save()
    if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
        M.enable_format_on_save()
        vim.notify "Enabled format on save"
    else
        M.disable_format_on_save()
        vim.notify "Disabled format on save"
    end
end

function M.remove_augroup(name)
    if vim.fn.exists("#" .. name) == 1 then
        vim.cmd("au! " .. name)
    end
end

vim.cmd [[ command! AutoSave execute 'lua require("mcampbellr.lsp.handlers").toggle_format_on_save()' ]]

return M
