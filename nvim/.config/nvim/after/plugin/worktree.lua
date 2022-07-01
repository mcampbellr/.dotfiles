local Remap = require('mcampbellr.keymap')
local nnoremap = Remap.nnoremap

nnoremap("<leader>gwt", function()
  require('telescope').extensions.git_worktree.git_worktrees()
end);

nnoremap("<leader>gwn", function()
  require('telescope').extensions.git_worktree.create_git_worktree()
end);
