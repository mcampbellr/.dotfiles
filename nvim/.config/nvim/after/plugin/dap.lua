local dap = require "dap"
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { os.getenv "HOME" .. "/.local/share/vscode-node-debug2/out/src/nodeDebug.js" },
}
--
dap.configurations.javascript = {
  {
    name = "Launch",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
}
--
require("nvim-dap-virtual-text").setup()
require("dap").set_log_level "DEBUG"

dap.defaults.fallback.terminal_win_cmd = "20split new"
vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "🟦", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

keymap("n", "<leader>dh", ':lua require"dap".toggle_breakpoint()<CR>', opts)
keymap("n", "<leader>di", ':lua require"dap.ui.widgets".hover()<CR>', opts)
keymap("n", "<leader>da", ':lua require"user.debugHelper".attach()<CR>', opts)
keymap("n", "<leader>dA", ':lua require"user.debugHelper".attachToRemote()<CR>', opts)
keymap("n", "<leader>dR", ':lua require"dap".clear_breakpoints()<CR>', opts)
keymap("n", "<leader>dc", ':lua require"dap".terminate()<CR>', opts)
keymap("n", "<A-n>", ':lua require"dap".step_out()<CR>', opts)
keymap("n", "<A-t>", ':lua require"dap".step_into()<CR>', opts)
keymap("n", "<A-t>", ':lua require"dap".step_over()<CR>', opts)
keymap("n", "<A-h>", ':lua require"dap".continue()<CR>', opts)
