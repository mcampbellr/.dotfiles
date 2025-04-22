# Colors
autoload -Uz colors && colors

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# check the ssh and add to keychain if they are not there
ssh-add --apple-use-keychain 2>/dev/null

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
zsh_add_file "./work/enviroments"
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

if [[ -z "$TMUX" ]] && [[ "$TERM" != "screen" ]] && [[ "$TERM" != "screen-256color" ]]; then
  t Developer
fi

