local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap('n', "<leader>bp", ":lua require'dap'.toggle_breakpoint()<CR>", opts)

local dap = require('dap')
dap.set_log_level('TRACE')

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv('HOME') .. '/debugers/vscode-node-debug2/out/src/nodeDebug.js' },
}
dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = { os.getenv("HOME") .. "/debugers/vscode-chrome-debug/out/src/chromeDebug.js" }
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require 'dap.utils'.pick_process,
  },
}

dap.configurations.vue = {
  {
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}"
  }
}

require('dap.ext.vscode').load_launchjs()
