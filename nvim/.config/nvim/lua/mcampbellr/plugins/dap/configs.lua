local dap = require "dap"
local dapui = require "dapui"
local jester = require "jester"
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
local icons = require "mcampbellr.icons"

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

dap.configurations.typescriptreact = {
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

vim.fn.sign_define("DapBreakpoint", {
    text = icons.ui.Circle,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
})

dapui.setup()

local function find_launch_json()
    local cwd = vim.fn.getcwd()
    local path = cwd .. "/.nvim/launch.json"

    local file = io.open(path, "r")

    if file ~= nil then
        io.close(file)
        return path
    end

    path = cwd .. "/.vscode/launch.json"

    file = io.open(path, "r")
    if file ~= nil then
        io.close(file)
        return path
    end

    return nil
end

require("dap.ext.vscode").load_launchjs(
    find_launch_json(),
    { node = { "typescript", "typescriptreact" } }
)
