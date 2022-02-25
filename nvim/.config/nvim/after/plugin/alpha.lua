local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local icons = require "user.icons"

local dashboard = require "alpha.themes.dashboard"

dashboard.section.header.val = {
  [[]],
  [[ ██████╗ █████╗ ███╗   ███╗██████╗ ██████╗ ███████╗██╗     ██╗     ]],
  [[██╔════╝██╔══██╗████╗ ████║██╔══██╗██╔══██╗██╔════╝██║     ██║     ]],
  [[██║     ███████║██╔████╔██║██████╔╝██████╔╝█████╗  ██║     ██║     ]],
  [[██║     ██╔══██║██║╚██╔╝██║██╔═══╝ ██╔══██╗██╔══╝  ██║     ██║     ]],
  [[╚██████╗██║  ██║██║ ╚═╝ ██║██║     ██████╔╝███████╗███████╗███████╗]],
  [[ ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚═════╝ ╚══════╝╚══════╝╚══════╝]],
  [[]],
}

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

local function footer()
  return "< mcampbell />"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)
