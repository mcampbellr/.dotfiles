local status_ok, dap = pcall(require, "dap")
if not status_ok then
    return
end
local dap_ui_status, dapui = pcall(require, "dapui")
if not dap_ui_status then
    return
end
local status_jester, jester = pcall(require, "jester")
if not status_jester then
    return
end

dap.active = true

dap.configurations.typescript = {
    {
        type = "node",
        name = "node attach",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
    },
}

local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

dap.adapters.node = {
    type = "executable",
    command = "node",
    name = "node-debug",
    args = { mason_path .. "packages/node-debug2-adapter/out/src/nodeDebug.js" },
}

dap.adapters.node2 = {
    type = "executable",
    command = "node",
    name = "node-debug",
    args = { mason_path .. "packages/node-debug2-adapter/out/src/nodeDebug.js" },
}

jester.setup {
    path_to_jest_run = "npm test --",
    dap = {
        type = "node2",
        request = "launch",
        cwd = vim.fn.getcwd(),
        args = { "--no-cache" },
        sourceMaps = true,
        protocol = "inspector",
        skipFiles = { "<node_internals>/**/*.js" },
        port = 9229,
        disableOptimisticBPs = true,
        testTimeout = 30000,
    },
}

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local icons = require "mcampbellr.icons"
vim.fn.sign_define("DapBreakpoint", {
    text = icons.ui.Circle,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
})

dapui.setup()

require("dap.ext.vscode").load_launchjs(
    nil,
    { node = { "typescript", "typescriptreact" } }
)
