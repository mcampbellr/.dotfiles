#!/bin/zsh

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/mcampbellr/.zprofile

ln -s ./zsh/.zshenv ~/.zshenv

eval "$(/opt/homebrew/bin/brew shellenv)"

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# Set the default screenshot location to ~/screenshots
defaults write com.apple.screencapture location ~/screenshots

echo "

================================

"
stow */ 
echo "

${(%):-%F{green}}Dotfiles Stowed${(%):-%f}

================================

"

curl https://sh.rustup.rs -sSf | sh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

brew bundle --file=~/dotfiles/Brewfile

cd ~/.dotfiles/ && brew bundle
