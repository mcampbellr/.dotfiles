# -------------------------------------------------------------------
# ~/.zshrc
# Interactive shell configuration
# -------------------------------------------------------------------

# Only run in interactive shells
[[ -o interactive ]] || return


# -------------------------------------------------------------------
# 1) Colors
# -------------------------------------------------------------------
autoload -Uz colors && colors


# -------------------------------------------------------------------
# 2) Load helper functions (zsh_add_file / zsh_add_plugin)
# -------------------------------------------------------------------
source "$ZDOTDIR/zsh-functions"


# -------------------------------------------------------------------
# 3) Load environment (PATH, brew, XDG, SDKs...)
# Must happen BEFORE compinit.
# -------------------------------------------------------------------
zsh_add_file "zsh-exports"


# -------------------------------------------------------------------
# 4) Shell options / UX
# -------------------------------------------------------------------
setopt autocd nomatch menucomplete
setopt interactive_comments

stty stop undef
zle_highlight=('paste:none')


# -------------------------------------------------------------------
# 5) Completions
# -------------------------------------------------------------------
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist

if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.config/zsh/.zcompdump 2>/dev/null)" ]; then
  compinit
else
  compinit -C
fi

_comp_options+=(globdots)


# -------------------------------------------------------------------
# 6) Interactive tool init (ORDER MATTERS)
# -------------------------------------------------------------------

# --- zoxide (must be BEFORE aliases because alias cd='z') ---
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# --- fzf (after compinit) ---
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# --- direnv (if you use it) ---
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi


# -------------------------------------------------------------------
# 7) SSH agent (Apple Keychain)
# -------------------------------------------------------------------
ssh-add --apple-use-keychain 2>/dev/null


# -------------------------------------------------------------------
# 8) Load modular config files
# -------------------------------------------------------------------
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"
zsh_add_file "zsh-hooks"


# -------------------------------------------------------------------
# 9) Plugins
# -------------------------------------------------------------------
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "changyuheng/zsh-interactive-cd"


# -------------------------------------------------------------------
# 10) Auto-start tmux
# -------------------------------------------------------------------
if [[ -z "$TMUX" ]] && [[ "$TERM" != "screen" ]] && [[ "$TERM" != "screen-256color" ]]; then
  t Developer
fi


# -------------------------------------------------------------------
# 11) pnpm
# -------------------------------------------------------------------
export PNPM_HOME="/Users/mariocampbell/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
