# Useful Functio# export ZDOTDIR=$HOME/.config/zsh
# source "$HOME/.config/zsh/.zshrc"
#!/bin/sh
export ZDOTDIR=$HOME/.config/zsh

if [ -z "$TMUX" ]
then
    tmux attach || tmux new -s main
fi

sshlist="$(ssh-add -l)"

if [[ $sshlist =~ 'The agent has no identities.' ]]; then
  ssh-add --apple-use-keychain ~/.ssh/tevora
  ssh-add --apple-use-keychain ~/.ssh/personal-github
  ssh-add --apple-use-keychain ~/.ssh/github
  ssh-add --apple-use-keychain ~/.ssh/thirdtime
fi

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
# compinit
_comp_options+=(globdots)		# Include hidden files.

# Colors
autoload -Uz colors && colors
source "$ZDOTDIR/zsh-functions"

# beeping is annoying
unsetopt BEEP

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"
zsh_add_file "zsh-hooks"
zsh_add_file "zsh-websearch"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "changyuheng/zsh-interactive-cd"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=008'

# completions
autoload -Uz compinit
compinit

# Environment variables set everywhere
export EDITOR="nvim"
export TERMINAL="iTerm2"
export BROWSER="chrome"
# tmux error fix
TERM="xterm-256color"
export TERM

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

HISTFILE=~/.zsh_history
export HISTSIZE=10000
setopt appendhistory
setopt HIST_SAVE_NO_DUPS # Don't write duplicate entries in the history file.
setopt SHARE_HISTORY # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
export SAVEHIST=$HISTSIZE

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
