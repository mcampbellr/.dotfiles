# Colors
autoload -Uz colors && colors

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
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.config/zsh/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

_comp_options+=(globdots)		# Include hidden files.


source "$ZDOTDIR/zsh-functions"

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"
zsh_add_file "zsh-hooks"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "changyuheng/zsh-interactive-cd"

