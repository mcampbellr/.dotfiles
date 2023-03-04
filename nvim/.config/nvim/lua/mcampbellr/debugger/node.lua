local home = os.getenv "HOME"
local dap = require "dap"

print(home .. "/debugers/vscode-node-debug2/out/src/nodeDebug.js")

dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { home .. "/debugers/vscode-node-debug2/out/src/nodeDebug.js" },
}

dap.configurations.javascript = {
    {
        name = "Launch",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.loop.cwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
    },
    {
        name = "Attach to process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
    },
}
