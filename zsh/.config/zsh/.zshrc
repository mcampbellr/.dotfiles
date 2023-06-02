# Colors
autoload -Uz colors && colors

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


if [ -z "$TMUX" ]
then
  /opt/homebrew/bin/tmux attach -t Developer || /opt/homebrew/bin/tmux new -s Developer -c ~/Developer
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

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
