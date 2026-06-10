# devup

Worktree-aware launcher for a repo's local dev stack. `devup` reads a `run:`
block from the repo's `.project-structure` and brings up one tmux window per
service (plus a cloudflared tunnel) — in an **isolated session per repo+worktree**.

It replaces static process-manager configs (e.g. moxide), whose hardcoded paths
break with the bare-repo / git-worktree layout (`<repo>/code/<branch>/`).

## CLI

```
devup            start (or attach to) the current worktree's session
devup attach     attach to the session if it exists
devup stop       kill the current worktree's session
devup restart    stop + start
devup ls         list devup tmux sessions
devup -h         full help + config schema
```

The CLI is a single bash script (`bin/devup`); it only needs to be on `PATH`.
Run it from anywhere inside a project — it finds the project root, resolves the
active worktree, and launches the stack.

## Quick start

```yaml
# .project-structure at the project root
code_dir: code            # omit for a flat (non-worktree) repo
default_branch: main
tunnel: { config: vng, name: vanguard }
run:
  - { name: web, cmd: pnpm dev }
  - { name: mobile, cmd: pnpm start, cwd: apps/app }
```

Then `cd` into any worktree and run `devup`. Don't hand-write the block — run
the `/devup-setup` skill in a repo and it detects the layout, services, and
tunnel and writes it for you.

## Configurator skill

- **Local (now):** `/devup-setup` — shipped as a loose user skill under
  `claude/.claude/skills/devup-setup/` in the dotfiles; loads automatically via
  the stow symlink, no install needed.
- **Namespaced (`/devup:setup`):** install this directory as a github
  marketplace plugin:
  ```sh
  claude plugin marketplace add mcampbellr/.dotfiles
  claude plugin install devup
  ```
  Loose skills and skills-dir plugins expose a skill by its bare name; only a
  github-marketplace plugin yields the `plugin:skill` namespace.

## Docs

- [configuration.md](./docs/configuration.md) — the full `.project-structure`
  schema with real worked examples (cdr, vanguardhq, flagify).
- [how-it-works.md](./docs/how-it-works.md) — project-root & worktree
  resolution, sessions, `DEV_PORT_OFFSET`, and the first-come tunnel rule.

## Requirements

`tmux`, `yq` (mikefarah v4), `jq`, and `cloudflared` (only if you declare a tunnel).
