# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$PATH:/Users/mariocampbell/Dev/flutter/bin"
export DOTFILES="/Users/mariocampbell/.dotfiles/"
export DEV_FILES="/Users/mariocampbell/Dev/lab"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"
#THEME COLOR
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set name of the theme to lad --- ifset to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#zsh-syntax-highlighting
plugins=(
  yarn
  git
  macos
  tmux
  golang
  web-search
  last-working-dir
  zsh-interactive-cd
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
#
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"

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
alias gg='google'
alias sof='stackoverflow'
alias yt='youtube'
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
