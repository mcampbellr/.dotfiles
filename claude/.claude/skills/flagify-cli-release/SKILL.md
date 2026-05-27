---
name: flagify-cli-release
description: Cut a release of the Flagify Go CLI — bump CHANGELOG, sync docs (cli/README, npm shim README, website CLI pages), run go test + go vet, open release PRs, tag. Pushing the vX.Y.Z tag triggers a CI workflow that runs GoReleaser (binaries + Homebrew tap) and publishes the @flagify/cli npm shim automatically. Use when the user asks to "release", "ship", "publish", or "cut a version" of the flagifyhq/cli repo.
---

# /flagify-cli-release

Cut a coordinated release of the Flagify Go CLI. This skill walks through writing a ruthless CHANGELOG entry, updating every doc that describes affected behavior, gating on `go test ./...` + `go vet ./...`, cutting release PRs in `cli/` and `apps/`, and tagging. The `git push origin vX.Y.Z` step is the trigger — **the CI workflow at `cli/.github/workflows/release.yml` owns the publish**, running GoReleaser (cross-platform binaries + Homebrew tap bump) and the `@flagify/cli` npm shim publish.

**Critical: never run `goreleaser release` or `npm publish` manually.** GoReleaser's `before:` hook runs `go test ./...` as part of the release itself, so the CI run re-validates tests at publish time. Running GoReleaser locally races the tap update and can corrupt the release. Your job ends at "tag pushed"; CI takes over. Also **never manually bump `cli/npm/package.json` version** — the `npm` job in `release.yml` rewrites it from the tag via `npm version "$VERSION" --no-git-tag-version` before publish.

The skill is author-driven: you decide the bump, write the changelog, gate on tests, and approve each step. But the publish itself is hands-off.

## Usage

```
/flagify-cli-release              # infer bump from current merged PRs, walk through the full flow
/flagify-cli-release patch        # force patch bump (1.5.0 → 1.5.1)
/flagify-cli-release minor        # force minor bump (1.5.0 → 1.6.0)
/flagify-cli-release major        # force major bump (1.5.0 → 2.0.0)
```

## Context the skill must gather before touching anything

1. **Which PR(s) are being released.** Ask the user if unclear. Note the number(s). Read descriptions and diffs to understand surface area.
2. **Current state of each repo involved:**
   - `cli/` — Go source + npm shim, must be on `main`, clean, pulled, fetched.
   - `apps/` — website docs under `apps/apps/website/src/content/docs/v1/cli/`, must be on `main`, clean, pulled.
3. **Tag history:** `cd cli && git tag --list 'v*' | sort -V | tail -5`. The next tag must be strictly greater than the newest one.
4. **Current npm registry version** of the shim: `npm view @flagify/cli version`. If it's ahead of the newest git tag, the registry was bumped without a tag and needs a retroactive CHANGELOG entry.
5. **Current Homebrew tap formula version** (optional sanity check): `brew info flagifyhq/tap/flagify` — should match the newest git tag.
6. **Existing CHANGELOG.md entries** at `cli/CHANGELOG.md` — read top ~40 lines to match tone, section ordering, and link format.
7. **Release workflow sanity check:** confirm `cli/.github/workflows/release.yml` still has two jobs (`release` via `goreleaser/goreleaser-action`, then `npm` with `needs: release`) triggered on `push: tags: ['v*']`. If the file changed shape, the skill's verification steps may need updating.

## Bump decision matrix

State the reason out loud before editing anything.

| Scenario | Bump | Example |
|---|---|---|
| Public CLI UX changed in a way that breaks existing scripts (flag removed, positional arg required where none was, default behavior inverted) | **major** | `flagify keys revoke` now errors without a selector (v1.6.0 — treated as minor because no one should have relied on silent env-wide revoke, but documented loud) |
| New command or flag added, output format additive (`--format json` on a new command), no behavior change for existing scripts | **minor** | `flagify flags health` in v1.5.0 |
| Behavior changes silently for existing callers but API surface is intact (path shape, auth, exit codes) | **minor** + loud CHANGELOG "Breaking changes" section | project-scoped routes in v1.4.0 |
| Bug fix with no observable impact beyond the bug being gone | **patch** | SSE reconnect backoff fix |
| Docs only, no code changes | don't cut a release — merge the docs PR directly | — |

**Rule of thumb:** if a CI pipeline that piped old CLI output into `jq` could silently produce different results after upgrade, bump at least minor and open the CHANGELOG with a `### Breaking changes` block.

## Documentation surface — update ALL of these, every time

A CLI release is not done until these are all in sync.

### `cli/` repo

| File | Always check |
|---|---|
| `CHANGELOG.md` | New entry at top. Retroactive entries for any skipped versions. Section order: `### Breaking changes` (if any), `### Features`, `### Bug fixes`, `### Documentation`, `### Improvements`. |
| `README.md` | Command reference sections. Verify flag tables, positional args, and examples match new behavior. |
| `npm/README.md` | Commands table. Short-form — one row per command. |
| `npm/package.json` | **Leave `version: "0.0.0"` untouched.** The `npm` job in CI rewrites this from the tag at publish time. Touching it manually causes a version mismatch between the tag and the published shim. |
| `.goreleaser.yaml` | Usually untouched. Only edit if adding a new platform target, changing ldflags, or reshaping the Homebrew formula. |
| `cmd/*.go` | No version string should live in Go source — goreleaser injects via `-X github.com/flagifyhq/cli/cmd.Version={{.Version}}` (see `.goreleaser.yaml:17`). If you find a hardcoded `v1.5.0`, remove it. |

### `apps/` repo (website docs)

| File | Always check |
|---|---|
| `apps/website/src/content/docs/v1/cli/commands.mdx` | Full command reference. Every command that changed gets an updated section with example output, options table, and `<Callout>` for any behavior shift. |
| `apps/website/src/content/docs/v1/cli/overview.mdx` | Install methods + getting-started one-liners. Usually untouched unless install path or auth flow changes. |
| `apps/website/src/content/docs/v1/cli/configuration.mdx` | Config fields + defaults. Edit only if `internal/config/config.go` struct fields changed. |
| `apps/website/src/content/docs/v1/cli/ai-setup.mdx` (if present) | Edit if `flagify ai-setup` output changed. |

**Scan for staleness:** before committing, grep the three doc roots (`cli/README.md`, `cli/npm/README.md`, `apps/apps/website/src/content/docs/v1/cli/`) for the command(s) and flag names affected by this release. Any hit outside your own additions that describes the old behavior is a stale claim to fix.

### Related surfaces (only if the release touches them)

- `apps/apps/website/src/content/blog/` — if the release is big enough to warrant a launch post, draft one. Not blocking for the release.
- `cli/npm/TODO.md` — if the release fixes a TODO, remove the entry.
- `Flagify Docs/decisions/YYYY-MM-DD-*.md` — every non-trivial release should have at least one decision log. Often already written by the time the release happens; confirm the referenced decision is linked from the CHANGELOG entry.
- `api/bruno/` — only if the release is tied to an API change. CLI-only releases don't touch Bruno.

## Step-by-step flow

### Phase 1 — Prepare (no commits yet)

1. **Verify state** of `cli/` and `apps/`: on `main`, clean, pulled, fetched. If either is dirty, stop and ask.
2. **Resolve the merged PR(s)** being released. Confirm PR numbers with the user. Often the relevant work is already merged and the user has just finished a `review` loop — ask for the PR number(s) explicitly.
3. **Choose the bump type** using the matrix above. State the reason. Ask the user to confirm if it's a judgment call (especially for "silent behavior change minor" cases).
4. **Read the current `cli/CHANGELOG.md`** top section to match the style (tone, sections, link format, how PRs are cross-referenced).

### Phase 2 — Edit everything, no commits yet

1. **Write the CHANGELOG entry** at the top of `cli/CHANGELOG.md`:
   - Version header with release date and GitHub release tag link.
   - `### Breaking changes` first if any — loud, with migration recipe (`add --all` style).
   - Then `### Features`, `### Bug fixes`, `### Documentation`, `### Improvements`.
   - One link per PR.
   - **Retroactive entries** for any skipped versions between the newest git tag and npm shim version.
2. **Update `cli/README.md`** — surgical edits to affected command sections. Preserve existing tone. Add new flag rows to the options table; update code-block examples.
3. **Update `cli/npm/README.md`** — the commands table is one-row-per-command; keep it terse.
4. **Update website docs** in `apps/apps/website/src/content/docs/v1/cli/`:
   - `commands.mdx`: rewrite the affected command sections. Use `<Callout type="warning">` for breaking changes (include "Starting in CLI vX.Y.Z ..." so readers know which binary satisfies the doc), `<Callout type="tip">` for non-breaking behavior notes.
   - `configuration.mdx` / `overview.mdx`: only if they reference behavior that changed.
5. **Grep for stale claims** across all three doc locations (see "Scan for staleness" above). Fix any hits.
6. **Do NOT touch `cli/npm/package.json` version field.** CI rewrites it from the tag at publish time.

### Phase 3 — Gate on build/test/vet

Run, in order, and do not proceed on failure:

```bash
cd /Users/mariocampbell/Developer/Personal/flagify/cli
go build ./...
go vet ./...
go test ./...
```

Reason every step runs:

- `go build ./...` catches compile errors that `go test` might mask if the broken package has no tests.
- `go vet ./...` catches `fmt` verb mismatches, unreachable code, lock-copying bugs.
- `go test ./...` is both a local gate AND a CI gate — GoReleaser's `before:` hook in `.goreleaser.yaml:6-8` runs the same test suite as part of the release job. If local tests fail, CI will fail too, and your tag will point at a broken commit.

If any step fails, STOP. Do not proceed with a broken release. Never disable tests to unblock a release — fix the root cause.

**Optional sanity check:** `make release-dry` runs `goreleaser release --snapshot --skip=publish` locally to validate the goreleaser config without publishing. Use it if you edited `.goreleaser.yaml`.

### Phase 4 — Commit, push, open PRs

**Two PRs, one per repo:**

1. `cli/` — branch `release/vX.Y.Z`, commit message `chore(release): vX.Y.Z — <one-line headline>`. Body explains the bump decision, summarizes the CHANGELOG, links the feature PR(s).
2. `apps/` — branch `docs/cli-vX.Y.Z-<behavior-slug>`, commit message `docs(cli): reflect vX.Y.Z <headline>`. Body lists each file touched, links back to the `cli/` release PR.

Push both, open both PRs with `gh pr create`. Include in each PR body:

- Link to the other PR.
- Test plan checklist.
- In the `cli/` PR body: explicit post-merge checklist (tag, CI run watch, npm + Homebrew verification).
- In the `apps/` PR body: explicit note **"merge AFTER `npm view @flagify/cli version` reports X.Y.Z"** so the website doesn't reference a CLI version that isn't installable yet. If the release is a breaking change, this note is load-bearing — merging docs first creates a window where readers copy an example that silently does the old dangerous thing on their current CLI.

**Stop here. Ask the user to review and merge the `cli/` PR first.** Do not merge yourself — policy says all merges are user-reviewed.

### Phase 5 — Post-merge: tag, push, wait for CI (only after user confirms cli/ PR is merged)

1. `cd cli && git checkout main && git pull --ff-only origin main`.
2. Verify the release commit is on main: `git log --oneline -1` should show the `chore(release): vX.Y.Z` commit.
3. Re-read `CHANGELOG.md` top entry and confirm the version matches what you're about to tag.
4. `git tag vX.Y.Z` — no annotated tag unless the user asks (matches existing history).
5. **Tell the user the tag push will trigger the publish.** Something like: "Pushing `vX.Y.Z` now — this triggers `.github/workflows/release.yml`, which runs GoReleaser (builds darwin/linux/windows × amd64/arm64, creates the GH release, bumps the Homebrew tap) and then the `npm` job (rewrites `cli/npm/package.json` version from the tag and publishes `@flagify/cli` to npm). I will not run `goreleaser release` or `npm publish` manually. Proceeding?"
6. On yes, `git push origin vX.Y.Z`.
7. **Wait for CI.** Watch with `gh run watch` or poll `gh run list --workflow=release --limit=1`. Do NOT run GoReleaser or npm publish yourself — both race CI and corrupt the release.
8. **Verify on each channel** once CI reports green:
   ```bash
   npm view @flagify/cli@X.Y.Z version              # should return X.Y.Z
   brew update && brew info flagifyhq/tap/flagify   # formula line should show X.Y.Z
   gh release view vX.Y.Z --repo flagifyhq/cli      # should list darwin/linux/windows archives + checksums
   ```
   All three channels must return the new version before proceeding. If CI succeeded but a channel is still stale, wait 30-60s for propagation and retry.
9. **Only now tell the user to merge the `apps/` docs PR.** The website should not reference vX.Y.Z until vX.Y.Z is installable.

### Phase 6 — Smoke test

1. Reinstall the CLI via the channel the user prefers (`brew upgrade flagifyhq/tap/flagify` or `npm install -g @flagify/cli@X.Y.Z`).
2. `flagify version` — confirm it reports `vX.Y.Z` (the ldflags injection from `.goreleaser.yaml:17-18` should surface here).
3. Run the command(s) the release changed against a dev workspace and confirm the new behavior. For breaking changes, also run the old form and confirm it now errors as the CHANGELOG claims.
4. If smoke fails on a published release: **npm does not let you unpublish within 72h without support contact, and Homebrew tap can be force-pushed but brew caches for hours.** So a failed smoke is roll-forward — cut a `vX.Y.(Z+1)` patch with the fix, do NOT try to rewrite the tag or republish.
5. If smoke passes, announce done and link the GH release.

## Critical gotchas

- **Never run `goreleaser release` manually.** The CI workflow owns it. Running locally races the Homebrew tap update (separate repo, separate git push inside goreleaser) and frequently leaves the tap pointing at a broken formula while the GH release is fine. Recovery is painful.
- **Never run `npm publish` manually.** The `npm` job in `release.yml` rewrites `cli/npm/package.json` version from the tag before publishing. Running `npm publish` locally against the untouched `0.0.0` version does nothing useful, and if you bump it manually first, the tag-to-shim version correspondence breaks silently on subsequent runs.
- **`cli/npm/package.json` version stays `"0.0.0"` in the repo.** The `npm version "$VERSION" --no-git-tag-version` step (release.yml:44-46) bumps it in the CI checkout only; it's never committed back. If you see any other version in the repo, someone committed a bump by mistake — revert it before tagging.
- **Tests are gated twice** (locally in Phase 3 and again by GoReleaser's `before:` hook in `.goreleaser.yaml:6-8`). That's by design — CI re-validates, but local gating avoids pushing a bad tag in the first place.
- **Don't hardcode version in Go source.** `.goreleaser.yaml:17` injects `cmd.Version` via ldflags. If the source ever gets `var Version = "v1.6.0"`, delete the literal — `var Version = "dev"` (the fallback) is fine because ldflags overwrite at build.
- **Skipped versions are legal but noisy.** If git tags go v1.5.0 → v1.7.0, that's OK if you document the skip in the CHANGELOG with either a retroactive entry for v1.6.0 or a brief note explaining the jump.
- **Homebrew tap token can expire silently.** If `HOMEBREW_TAP_TOKEN` in GH Actions secrets is stale, the `release` job still succeeds (because GoReleaser only warns on tap push failure by default in some configs). After every release, `brew info flagifyhq/tap/flagify` is the authoritative check — if the formula is stale, rotate the token and re-push the tag (delete it first: `git push --delete origin vX.Y.Z && git tag -d vX.Y.Z && git tag vX.Y.Z && git push origin vX.Y.Z`).
- **Tag points to main, not the PR branch.** Never tag from the release PR branch — if main was squash-merged, the branch commit won't exist on main and the tag dangles. Always `git checkout main && git pull --ff-only` before tagging.
- **Never merge the PRs yourself.** Even with full authority to push, policy says all merges are user-reviewed.
- **The monorepo root is a git repo but the `Flagify Docs/` decision logs live there.** Don't try to commit decision logs from `cli/` — they belong to the root. Write or update decision docs before tagging, but commit them separately (if at all).
- **Breaking-change docs must not ship before the binary.** The `<Callout>` in `commands.mdx` typically says "Starting in CLI vX.Y.Z ...". If apps PR merges before npm/brew have X.Y.Z, readers will copy the new example and execute it against their pre-X.Y.Z binary, which may still have the old (often dangerous) behavior. Phase 5 step 8 exists precisely to prevent this.

## When to NOT use this skill

- SDK releases (`@flagify/node`, `@flagify/react`, `@flagify/nestjs`, `@flagify/astro`) — use `/flagify-release` instead. Different repo (`javascript/`), different publishing flow (`pnpm -r publish`), different doc surface (SDK pages, not CLI pages).
- API releases (`flagifyhq/api`) — no npm/brew, deploys via its own AWS pipeline. No skill covers this today; changes go through the standard PR + merge + deploy workflow.
- Docs-only changes with no Go code bump and no tag — merge the docs PR directly, no CHANGELOG entry, no tag. Only things that change a user-visible command or flag deserve a release.
- When the user explicitly says "don't publish" or "dry run" — stop before Phase 5. `make release-dry` (Phase 3 optional step) is the right tool for validating goreleaser config without publishing.
