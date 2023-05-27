# Colors
autoload -Uz colors && colors

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Environment variables set everywhere
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export EDITOR="nvim"
export TERMINAL="iterm2"
export BROWSER="brave"
export TERM="xterm-256color"
export HISTFILE=~/.zsh_history
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=008'

if [ -z "$TMUX" ]
then
  tmux attach -t Developer || tmux new -s Developer -c ~/Developer
fi

# check the ssh and add to keychain if they are not there
sshlist="$(ssh-add -l)"
if [[ $sshlist =~ 'The agent has no identities.' ]]; then
  ssh-add --apple-use-keychain ~/.ssh/tevora
  ssh-add --apple-use-keychain ~/.ssh/personal-github
  ssh-add --apple-use-keychain ~/.ssh/github
fi

# some useful options (man zshoptions)
setopt autocd nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# completions
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

source "$ZDOTDIR/zsh-functions"

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

# Sets and unsets 
unsetopt BEEP
setopt appendhistory
setopt HIST_SAVE_NO_DUPS # Don't write duplicate entries in the history file.
setopt SHARE_HISTORY # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS

# Aliases from 
eval $(thefuck --alias)
eval "$(zoxide init zsh)"

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
