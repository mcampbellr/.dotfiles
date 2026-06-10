# Configuration — `.project-structure`

`devup` is configured per project by a `run:` block (plus a few optional keys)
in the project's `.project-structure` file. The file is YAML and is shared with
other tooling (e.g. `/idea` reads `spec-path` / `specs_dir` from it); `devup`
only reads the keys below and ignores the rest.

## Where the file lives

At the **project root**:

- **Worktree layout** — the folder that *contains* the worktrees directory
  (the one holding `code/.bare`), **not** a worktree itself. The monorepo code
  lives in `<root>/<code_dir>/<branch>/`.
- **Flat repo** — the git repository root.

> A monorepo checked out as a worktree often ships *its own* `.project-structure`
> (spec paths only, no `run:`). `devup` skips any config without a `run:` block
> and keeps climbing, so the worktree's spec-only file does not shadow the
> project root's devup config. See [how-it-works.md](./how-it-works.md).

## Keys

| Key | Required | Default | Purpose |
|---|---|---|---|
| `run` | ✅ | — | List of services; one tmux window each. |
| `code_dir` | — | *(none)* | Directory holding the bare repo + worktrees. Omit for a flat repo. |
| `default_branch` | — | `main` | Worktree used when `devup` runs from the project root (not inside a worktree). Also the worktree whose `DEV_PORT_OFFSET` is `0`. |
| `tunnel` | — | *(none)* | cloudflared tunnel. `{config,name}` map or a raw command string. |

### `run`

```yaml
run:
  - name: api                       # tmux window name (short, lowercase)
    cmd: pnpm --filter api dev       # verified against package.json / Makefile
    cwd: .                           # optional, relative to the worktree root
  - name: app
    cmd: pnpm --filter app dev
```

Each window exports `DEV_WORKTREE` and `DEV_PORT_OFFSET`. A service can opt into
port isolation by referencing the offset:

```yaml
  - name: api
    cmd: PORT=$((3000 + DEV_PORT_OFFSET)) pnpm --filter api dev
```

### `tunnel`

Map form (standard cloudflared named tunnel). The config stem and the run-name
often differ (`vng` → `vanguard`):

```yaml
tunnel:
  config: vng     # -> ~/.cloudflared/vng.yml  +  ~/.cloudflared/vng-cert.pem
  name: vanguard  # -> cloudflared ... run vanguard
```

Expands to:

```
cloudflared tunnel --config ~/.cloudflared/vng.yml --origincert ~/.cloudflared/vng-cert.pem run vanguard
```

Raw form (any command), for non-standard invocations:

```yaml
tunnel: "cloudflared tunnel --url http://localhost:8080"
```

The tunnel is a **singleton** — only the first worktree brought up runs it. See
[how-it-works.md](./how-it-works.md#tunnel-first-come).

## Worked examples

### cdr — worktree monorepo (pnpm + turbo, Expo app)

```yaml
code_dir: code
default_branch: main
tunnel:
  config: cdr
  name: cdr
run:
  - name: web
    cmd: pnpm dev          # turbo: api, admin, website, packages
  - name: mobile
    cmd: pnpm start        # Expo, separate from the turbo graph
    cwd: apps/app
```

### vanguardhq — worktree monorepo

```yaml
spec-path: ./Vanguard Docs/specs   # other tooling; ignored by devup
code_dir: code
default_branch: main
tunnel:
  config: vng
  name: vanguard
run:
  - name: web
    cmd: pnpm run dev
  - name: mobile
    cmd: pnpm run start
    cwd: apps/app
```

### flagify — flat repo, multiple services

```yaml
specs_dir: "Flagify Docs/specs"    # other tooling; ignored by devup
# no code_dir → flat repo, code at the root
tunnel:
  config: flag
  name: flagify
run:
  - name: api
    cmd: make dev
    cwd: api
  - name: apps
    cmd: pnpm run dev
    cwd: apps
  - name: cli
    cmd: air
    cwd: cli
  - name: sdks
    cmd: pnpm dev
    cwd: javascript
  - name: playground
    cmd: npm run dev
    cwd: playground
```

You don't have to hand-write this — run `/devup-setup` in a repo and the skill
detects the layout/services/tunnel and writes the block for you.
