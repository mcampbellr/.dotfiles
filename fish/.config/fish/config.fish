set -x LANG en_us.UTF-8 

alias n='nvim'
alias pm='npm'
alias t=zox

alias debug="npm run start:debug"
alias serve="npm run serve"
alias tmrc="sh -c '\${EDITOR:-nvim} ~/.tmux.conf && tmux source ~/.tmux.conf && tmux display \"Config reloaded\"'"

alias dn="deno"

alias run=run_package_script

alias nvc="cd $DOTFILES/nvim/.config/nvim && n ."
alias dot="cd $DOTFILES"
alias crl="curl"

# Shortcuts Aliases
alias cl="clear"
alias ls='exa --no-user --icons'
alias la='ls -laFh'
alias ll='ls -l'
alias tree="ls -T -L 3 --git-ignore"
alias ip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}'"
alias fk="fuck"

alias br=openOrSearch

# mkcdir () {
#   mkdir -p -- "$1" &&
#     cd -P -- "$1"
# }

alias copy-branch='g branch --show-current | pbcopy'
alias branch='g branch --show-current'

alias notes="n ~/Notes/"
alias notess="ss ~/Notes/"

alias ccd=mkcdir
# configs aliases
alias zshrc="cd $DOTFILES/zsh/"
alias src="source ~/.config/fish/config.fish && echo '< zsh config reloaded >'"


# tmux aliases
alias tm='tmux'
alias tmk="tm kill-server"

# browser aliases
alias sof='stackoverflow'
alias yt='youtube'

# npm version aliases
alias npmci="nvm use & npm ci"
alias patch="yarn version --patch"
alias minor="yarn version --minor"
alias major="yarn version --major"

alias at='alacritty-themes'

# programing language aliases
# python
alias py='python3'
alias pip='pip3' 
# typescript
alias tsn="ts-node"

# Custom git aliases
alias lg='lazygit'
alias g='git'
alias gpush="g push"
alias gpull="g pull"
alias gsh="g stash -u"
alias gdff="g diff"
alias grb="g rebase"
alias gcommit="g commit"
alias glast="g show HEAD --quiet"
alias gwta="g cb"
alias gwtr="g worktree remove"
alias gwtl="g worktree list"
alias gwtm="g worktree move"
alias gwtp="g worktree prune --verbose"
alias gcp="g cherry-pick"
alias gbv="g branch -vv"
alias gclone="g clone"
alias gri="g rebase -i"
alias gst="g st"
alias gemails="git log --format='%ae - (%an)' | sort | uniq"
alias gconf="g config --global -e"
alias gt="jump_to_worktree"

set LOG_FORMAT="format:'%C(bold red)%h%C(reset) - %C(white)(%C(bold green)%ar%C(reset)%C(white)) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"

alias glg="g log -15 --graph --abbrev-commit --decorate --format=$LOG_FORMAT"
alias glog="g log --graph --abbrev-commit --decorate --format=$LOG_FORMAT"

# yarn commands

alias y="yarn"
alias yd="yarn run dev"
alias yb="yarn build"
alias ys="yarn run serve"

# Custom commands
alias cg=". $DEV_FILES/lab/rotator/rot.sh"

alias dev="ss ~/Developer/"

alias doc='docker'
alias dco="docker compose"

alias olocal="open http://localhost"
alias ht=htop

alias c='cargo'

alias top="ss ~/Workspace/tevora/top-frontend && ss ~/Workspace/tevora/portal-backend"
alias wsp="cd ~/Workspace/"

alias cpwd="pwd | tr -d '\n' | pbcopy && echo 'pwd copied to clipboard'"
alias gosleep="pmset sleepnow"


