local Remap = require "mcampbellr.keymap"
local nnoremap = Remap.nnoremap
nnoremap("<leader>dc", "<cmd>DapContinue<CR>")
nnoremap("<leader>do", "<cmd>DapStepOver<CR>")
nnoremap("<leader>dt", "<cmd>PBToggleBreakpoint<CR>")

nnoremap("<leader>dL", "<cmd>PBClearAllBreakpoints<CR>")
nnoremap("<leader>dl", "<cmd>lua require('dap').list_breakpoints(true)<cr>")

nnoremap("<leader>du", "<cmd>lua require('dapui').toggle()<CR>")
nnoremap("E", "<cmd>lua require('dapui').eval()<CR>")

nnoremap("<leader>jr", "<cmd>lua require('jester').run()<CR>")
nnoremap("<leader>jf", "<cmd>lua require('jester').run_file()<CR>")
nnoremap("<leader>jR", "<cmd>lua require('jester').debug()<CR>")
nnoremap("<leader>jF", "<cmd>lua require('jester').debug_file()<CR>")
nnoremap("<leader>jl", "<cmd>lua require('jester').run_last()<CR>")
nnoremap("<leader>jL", "<cmd>lua require('jester').debug_last()<CR>")
nnoremap("<leader>jL", "<cmd>lua require('jester').debug_last()<CR>")
