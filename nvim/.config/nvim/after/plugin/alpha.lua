local dashboard = require "alpha.themes.dashboard"
math.randomseed(os.time())

local icons = require "user.icons"

local function pick_color()
  local colors = { "String", "Identifier", "Keyword", "Number", "Constant" }
  return colors[math.random(#colors)]
end

local function footer()
  local v = vim.version()
  local datetime = os.date " %d-%m-%Y   %H:%M:%S"
  return string.format(" %s   v%s.%s.%s  %s", "<mcampbellr>", v.major, v.minor, v.patch, datetime)
end

dashboard.section.header.val = {
  [[ _______             ____   ____.__         ]],
  [[ \      \   ____  ___\   \ /   /|__| _____  ]],
  [[ /   |   \_/ __ \/  _ \   Y   / |  |/     \ ]],
  [[/    |    \  ___(  <_> )     /  |  |  Y Y  \]],
  [[\____|__  /\___  >____/ \___/   |__|__|_|  /]],
  [[        \/     \/                        \/ ]],
}
dashboard.section.header.opts.hl = pick_color()

dashboard.section.buttons.val = {
  dashboard.button("f", icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
  dashboard.button("n", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("e", icons.ui.Search .. " Explorer", ":e . <CR>"),
  dashboard.button(
    "p",
    icons.git.Repo .. " Find project",
    ":lua require('telescope').extensions.projects.projects(require('telescope.themes').get_dropdown({previewer = false}))<CR>"
  ),
  dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("t", icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
  dashboard.button("d", icons.ui.Dotfiles .. " Dotfiles", ":e ~/.dotfiles <CR>"),
  dashboard.button("g", icons.git.Logo .. " Git Status", ":Git <CR>"),
  dashboard.button("c", icons.ui.Gear .. " Config", ":e ~/.config/nvim <CR>"),
  dashboard.button("z", icons.ui.Terminal .. " ZshConfig", ":e ~/.zshrc<CR>"),
  dashboard.button("m", icons.kind.Class .. " Cheat Sheet", ":TermExec cmd='ch'<CR>"),
  dashboard.button("q", icons.diagnostics.Error .. " Quit", ":qa<CR>"),
}

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = dashboard.section.header.opts.hl

dashboard.config.layout[1].val = 1

require("alpha").setup(dashboard.config)
