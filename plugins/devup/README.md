# devup

Worktree-aware launcher for a repo's local dev stack. `devup` reads a `run:`
block from the repo's `.project-structure` and brings up one tmux window per
service plus a cloudflared tunnel — in an **isolated session per repo+worktree**.

It replaces static process-manager configs (e.g. moxide), whose hardcoded paths
break with the bare-repo / git-worktree layout (`<repo>/code/<branch>/`).

## Install

```sh
claude plugin marketplace add ~/.dotfiles/plugins/devup   # or the published repo
claude plugin install devup
```

Then run `/devup:setup` inside a repo to install the CLI, check deps
(`tmux`, `yq`, `jq`), and generate the `run:` block.

The CLI itself lives at `bin/devup` and only needs to be on `PATH`.

## CLI

```
devup            start (or attach to) the current worktree's session
devup attach     attach to the session if it exists
devup stop       kill the current worktree's session
devup restart    stop + start
devup ls         list devup tmux sessions
devup -h         full help + config schema
```

`devup` walks up from the cwd to find `.project-structure`, resolves the active
worktree (or `default_branch` when run from the project root), and exports
`DEV_WORKTREE` + `DEV_PORT_OFFSET` (0 for the default branch, a stable 100..900
otherwise) so services can opt into port isolation.

## `.project-structure` schema

```yaml
code_dir: code            # optional. Dir holding the bare repo + worktrees.
                          #   Omit for a flat (non-worktree) repo.
default_branch: main      # optional (default: main).
tunnel:                   # optional. {config,name} map ...
  config: vng             #   -> ~/.cloudflared/vng.yml + vng-cert.pem
  name: vanguard          #   -> cloudflared ... run vanguard
# tunnel: "raw command"       ... or a raw command string.
run:                      # required. One tmux window per entry.
  - name: api
    cmd: pnpm --filter api dev
    cwd: .                # optional, relative to the worktree root
  - name: app
    cmd: pnpm --filter app dev
```

## Requirements

`tmux`, `yq` (mikefarah v4), `jq`, and `cloudflared` (only if you declare a tunnel).
