# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$PATH:/Users/mariocampbell/Dev/flutter/bin"
export DOTFILES="/Users/mariocampbell/.dotfiles/"
export NOTES="/Users/mariocampbell/Notes/"
export DEV_FILES="/Users/mariocampbell/Dev/lab"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"
#THEME COLOR
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set name of the theme to lad --- ifset to "random", it will

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# beeping is annoying
unsetopt BEEP

#zsh-syntax-highlighting
plugins=(
  yarn
  zsh-interactive-cd
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# vim & nvim aliases
alias n='nvim'
alias n.='nvim'
alias nvc="cd ~/.dotfiles/nvim/.config/nvim"
alias dot="cd ~/.dotfiles/ "
alias vc="vimtheme"
# shortcuts aliases
alias cl='clear'

mkcdir () {
  mkdir -p -- "$1" &&
    cd -P -- "$1"
}

alias ccd=mkcdir
# configs aliases
alias zshrc='nvim ~/.zshrc'
alias hrc='n ~/.hyper.js'
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias tree="tree -L 3 --gitignore"
# tmux aliases
alias tm='tmux'
alias :q='exit'
# browser aliases
alias doc='docker'
# npm version aliases
alias patch="yarn version --patch"
alias minor="yarn version --minor"
alias major="yarn version --major"
# programing language aliases
# python
alias py='python3'
alias pip='pip3' 
# typescript
alias tsn="ts-node"
# react
alias cra='npx create-react-app'
alias crna='npx create-next-app@latest'
alias crnats='npx create-next-app@latest --ts'
# Custom git aliases
alias lg='lazygit'
alias g='git'
alias gwt="g worktree"
alias gwta="g worktree add"
alias gwtr="g worktree remove"
alias gwtm="g worktree move"
alias gst="g st"
alias gconf="g config --global -e"
alias glog="g log -20 --graph --oneline"
alias ga.="g add . && gst"

# Custom commands
alias gsw="$DEV_FILES/git-switcher/git-switcher.sh"
alias cg=". $DEV_FILES/rotator/rot.sh"
alias ch="$DEV_FILES/cht/cht.sh"
alias ss="$DEV_FILES/tmux/session"

alias cpwd="pwd | tr -d '\n' | pbcopy && echo 'pwd copied to clipboard'"

alias ff="fzf"

# gh auto completion
autoload -U compinit
compinit -i

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR=~/.nvm

source $(brew --prefix nvm)/nvm.sh

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh
# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
export TERM=xterm-256color-italic

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
