#!/bin/zsh

# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew..."
fi

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/mcampbellr/.zprofile

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
