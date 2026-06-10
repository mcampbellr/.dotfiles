# How it works

`devup` turns a `.project-structure` `run:` block into an isolated tmux session
per repo+worktree. This page documents the resolution and runtime behavior.

## Project root resolution

`devup` walks up from the current directory and stops at the **nearest
`.project-structure` that contains a `run:` block**.

The "has a `run:` block" check matters: a monorepo checked out as a worktree
frequently ships its own `.project-structure` carrying only spec paths
(`spec-path:` / `specs_dir:`), no `run:`. Stopping at the first file found would
pick that spec-only config and fail. Skipping configs without `run:` lets devup
climb past it to the project root's real config.

If no config with a `run:` block is found up to `/`, devup errors:
`no .project-structure with a 'run:' block found above <cwd>`.

## Worktree resolution

Given the project root and `code_dir`:

- **Worktree layout** (`code_dir` set and `<root>/<code_dir>` exists):
  - If the cwd is inside `<root>/<code_dir>/<segment>/…`, the active worktree is
    `<segment>` (the first path component under `code_dir`).
  - Otherwise (cwd at the root, or under `.bare`), it falls back to
    `default_branch`.
  - `WORKTREE_ROOT = <root>/<code_dir>/<worktree>`.
- **Flat repo** (no `code_dir`): `WORKTREE_ROOT = <root>`, worktree id = project
  name.

The worktree id is the **directory name** under `code_dir`, which is not
necessarily the git branch name (a worktree dir `new-patient-expediente` may
hold branch `feat/new-patient-expediente`).

## Sessions

One tmux session per repo+worktree:

- Worktree: `<project>-<worktree>` (e.g. `cdr-new-patient-expediente`).
- Flat repo: `<project>`.

Names are sanitized to `[A-Za-z0-9_-]`. Running `devup` again when the session
exists just **attaches** (idempotent) — it does not restart services. Each
service window is set `remain-on-exit on`, so a crashed process leaves its log
visible instead of closing the pane.

Attach behavior: inside tmux it `switch-client`s; outside it `attach-session`s.

## Port offset

Every window gets two env vars exported:

- `DEV_WORKTREE` — the worktree id.
- `DEV_PORT_OFFSET` — `0` for the `default_branch` worktree, otherwise a stable
  value in `100..900` derived from `cksum(worktree_id) % 9 + 1) * 100`.

The offset is **opt-in**: devup exports it, but a service only uses it if its
`cmd` references it (e.g. `PORT=$((3000 + DEV_PORT_OFFSET)) …`). This is what
lets two worktrees of the same repo run simultaneously without local port
clashes — provided the `run:` commands wire the offset in.

## Tunnel (first-come)

A cloudflared **named tunnel** is a singleton: it has a fixed-port ingress
(`hostname → localhost:<port>`), and running `cloudflared … run <name>` twice
registers two HA replicas that both point at the same port. So devup runs the
tunnel for **only one worktree at a time**.

The rule is **first-come, branch-agnostic**: the first worktree of a project
brought up runs the tunnel; any later worktree detects a sibling session
(`<project>` / `<project>-*`) that already has a `tunnel` window and skips its
own, logging:

```
tunnel already up in another '<project>' worktree; skipping here (reach services via localhost:<port+offset>)
```

Whichever worktree comes up first owns the public tunnel; the others are reached
locally on their offset ports. Stop the tunnel-owning session and the next
`devup` (or `devup restart`) on another worktree will claim it.

To expose a *second* worktree publicly at the same time you'd need a per-worktree
tunnel (e.g. a `cloudflared tunnel --url localhost:<port+offset>` quick tunnel) —
not currently built in.

## Subcommands

| Command | Behavior |
|---|---|
| `devup` / `devup up` | Start the current worktree's session, or attach if it exists. |
| `devup attach` | Attach to the session (error if it doesn't exist). |
| `devup stop` | Kill the current worktree's session. |
| `devup restart` | `stop` + `up`. |
| `devup ls` | List all tmux sessions. |
| `devup -h` | Help + schema. |

`-h` and `ls` work anywhere; the rest require a resolvable project root.

## Dependencies

`tmux`, `yq` (mikefarah v4), `jq`, and `cloudflared` (only if a tunnel is
declared). `devup` checks for them and prints an install hint if missing.
