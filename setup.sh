#!/bin/zsh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/mcampbellr/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install git
brew install stow

echo
echo "================================"
stow */ 
echo ${(%):-%F{green}}Dotfiles Stowed${(%):-%f}
echo "================================"
echo

curl https://sh.rustup.rs -sSf | sh

brew install neovim
brew install romkatv/powerlevel10k/powerlevel10k

brew install fsouza/prettierd/prettierd

brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

brew install exa
brew install jq
brew install lazygit
brew install fzf

$(brew --prefix)/opt/fzf/install

brew install ripgrep
brew install grep
brew install postgresql
brew install gnu-sed
brew install deno
brew install glow
brew install heroku
brew install fd

brew install --cask iterm2
brew install --cask loom
brew install --cask dbeaver-community
brew install --cask slack
brew install --cask microsoft-teams
brew install --cask insomnia
brew install --cask spotify
brew install --cask rectangle
brew install --cask visual-studio-code
brew install --cask docker
brew install --cask brave-browser
brew install --cask discord