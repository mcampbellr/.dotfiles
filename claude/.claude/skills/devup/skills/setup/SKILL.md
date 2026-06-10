---
name: setup
description: Configure devup for a repo — ensure the `devup` CLI + deps are installed and write a `run:` block into the repo's `.project-structure` so it can be launched with `devup`. Use when the user invokes /devup:setup, or asks to "set up devup", "configure local dev launch", "make this repo launchable", or "add a run block".
argument-hint: "[--here | <repo-path>]"
metadata:
  version: "1.0.0"
---

# /devup:setup — make a repo launchable with `devup`

Goal: configure a repo so `devup` can spin up its local dev stack (services + cloudflared tunnel) in tmux. Two outcomes:

1. The `devup` CLI and its deps (`tmux`, `yq`, `jq`) are installed and on PATH.
2. The repo's `.project-structure` carries a valid `run:` block (plus `code_dir` / `default_branch` / `tunnel` when applicable).

**You do not launch servers or attach tmux in this skill — only configure.** Running is the CLI's job (`devup`).

---

## Hard rules

- **Never start dev servers, never `devup up`, never attach tmux here.** Configuration only.
- **Preserve existing `.project-structure` keys** (`spec-path`, `specs_dir`, `spec_filename`, `ticket-pattern`, …). Merge/append the run-related keys — do not clobber.
- **No guesses on commands.** Verify every `cmd` against the repo's `package.json` scripts / `Makefile` targets / lockfiles. If a service's start command is ambiguous, ask via `AskUserQuestion`.
- **Do not commit.** The target repo is usually not the dotfiles repo; leave the edited `.project-structure` in the working tree for the user to review and commit.
- Install deps only with the user's consent (offer the exact `brew install` line).

---

## Step 0 — Resolve the target project root

`.project-structure` lives at the **project root**, which is:

- **Worktree-parent layout** — the folder that *contains* the worktrees dir, NOT a worktree itself. Detect by a child holding a bare repo, typically `<root>/code/.bare`. The monorepo code lives in `<root>/<code_dir>/<branch>/`.
- **Flat repo** — the git repo root (a real `.git` directory at the top).

Resolution:
1. If an explicit path arg is given, use it. If `--here`, use cwd.
2. Else walk up from cwd. If you pass through `<dir>/code/.bare` (or any `*/.bare`), the project root is the parent of that `code` dir. Otherwise the root is the enclosing git repo root.
3. Confirm the resolved root with the user in one line before writing.

---

## Step 1 — Ensure the CLI + deps

1. `command -v devup`. If missing, install the bundled binary:
   - `install -m 0755 "${CLAUDE_PLUGIN_ROOT}/bin/devup" "$HOME/.local/bin/devup"` (create `~/.local/bin` if needed; confirm it is on PATH, else tell the user to add it).
2. Check `tmux`, `yq` (mikefarah v4), `jq`. For any missing, offer: `brew install tmux yq jq` (only the missing ones). Do not install without consent.

---

## Step 2 — Detect layout fields

- `code_dir`: for worktree-parent layout, the dir holding `.bare` relative to root (commonly `code`). For a flat repo, **omit** this key.
- `default_branch`: read the bare repo's default branch
  (`git -C <root>/<code_dir>/.bare symbolic-ref --short HEAD` or inspect existing worktrees). Default `main`. For flat repos default `main` too.

---

## Step 3 — Detect services (propose, then confirm)

Inspect the worktree that will run (the `default_branch` worktree for worktree layout, or the flat root). Build a candidate `run:` list:

- **Node monorepo** (turbo + `pnpm-workspace.yaml`): root `package.json` `dev` script → `{ name: web, cmd: <pm> dev }`. Resolve `<pm>` from the lockfile (`pnpm-lock.yaml`→pnpm, `yarn.lock`→yarn, `package-lock.json`→npm, `bun.lockb`→bun).
- **Expo app** under `apps/*` (its `package.json` has an `expo` dep or `start: expo start`): a separate `{ name: mobile, cmd: <pm> start, cwd: apps/<app> }` — Expo is not part of the turbo `dev` graph.
- **Go service**: a `Makefile` with a `dev:` target → `{ name: api, cmd: make dev, cwd: <dir> }`. If `.air.toml` is present, `air` is the dev runner.
- **Flat multi-service repo**: one entry per top-level service dir that has its own dev runner (e.g. flagify: `api` make dev, `apps` pnpm dev, `cli` air, `javascript` pnpm dev, `playground` npm run dev).

Each entry: `name` (short, lowercase), `cmd` (verified), optional `cwd` (relative to the worktree root). Services that opt into port isolation can reference `DEV_PORT_OFFSET`, e.g. `cmd: PORT=$((3000 + DEV_PORT_OFFSET)) pnpm --filter api dev`.

---

## Step 4 — Detect the tunnel

1. List `~/.cloudflared/*.yml`. Each stem (e.g. `vng`, `flag`, `cdr`) maps to `~/.cloudflared/<stem>.yml` + `<stem>-cert.pem`.
2. Match a stem to this repo by name similarity; the run-name often differs from the stem (`vng` → `vanguard`). Read the run-name from the config's `tunnel:` field or from an existing `cloudflared` alias, or ask.
3. Propose `tunnel: { config: <stem>, name: <run-name> }`. If nothing matches, omit and ask whether the repo has a tunnel (the `run:` block works fine without one).

---

## Step 5 — Confirm before writing

Use `AskUserQuestion` to confirm the proposed **services list** and **tunnel** (let the user prune, rename, or add entries). Only proceed to write once confirmed.

---

## Step 6 — Write `.project-structure`

Merge into the existing file (YAML), preserving all current keys. Target shape:

```yaml
# ...existing keys (spec-path / specs_dir / ...) untouched...
code_dir: code            # omit for flat repos
default_branch: main
tunnel:                   # omit if none
  config: vng
  name: vanguard
run:
  - name: web
    cmd: pnpm dev
  - name: mobile
    cmd: pnpm start
    cwd: apps/app
```

`tunnel` may instead be a raw command string if the cloudflared invocation is non-standard.

---

## Step 7 — Verify + hand off

1. Verify it parses: `yq -o=json '.run' <root>/.project-structure | jq .` (must be a non-empty array).
2. Tell the user the next step verbatim, and stop:
   > Listo. Desde un worktree del repo corré `devup` para levantar el stack (o `devup -h` para subcomandos).

Do not run `devup` yourself.
