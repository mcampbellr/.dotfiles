---
name: flagify-release
description: Cut a release of the Flagify JavaScript SDKs — bump versions, changelog, docs (READMEs + website), build/lint/test gate, release PR, and git tag. The tag push triggers a CI workflow that publishes to npm automatically. Use when the user asks to "release", "ship", "publish", "cut a version" of the SDKs.
---

# /flagify-release

Cut a fully coordinated release of the four `@flagify/*` JavaScript SDKs. This skill walks through bumping versions, writing a ruthless CHANGELOG, updating every piece of documentation that references the affected behavior, gating on build/lint/tests, cutting release PRs, and tagging.

**Critical: the actual npm publish is automated.** Pushing a `vX.Y.Z` tag to the `flagifyhq/javascript` remote triggers a GitHub Actions release workflow that runs `pnpm -r publish --access public`. **You do not run `pnpm publish` manually.** Running it manually races with CI and corrupts the release. Your job ends at "tag pushed"; CI takes over.

The skill is manual in the sense of "author-driven": you decide the bump, write the changelog, gate on tests, and approve each step. But the publish itself is hands-off — you push the tag and wait for CI.

## Usage

```
/flagify-release              # infer bump from current merged PRs, walk through the full flow
/flagify-release patch        # force patch bump (1.0.6 → 1.0.7)
/flagify-release minor        # force minor bump (1.0.6 → 1.1.0)
/flagify-release major        # force major bump (1.0.6 → 2.0.0)
```

## Context the skill must gather before touching anything

1. **Which PR(s) are being released.** Ask the user if unclear. Note the number(s).
2. **Current state of each repo involved:**
   - `javascript/` — SDK source, must be on `main`, clean, pulled.
   - `apps/` — website docs (mdx files under `apps/apps/website/src/content/docs/v1/sdk/`), must be on `main`, clean, pulled.
3. **Current package.json version** of each of the 4 packages (`node`, `react`, `nestjs`, `astro`).
4. **Current npm registry version** of each package via `npm view @flagify/<pkg> version` — these can diverge from package.json if a previous release bumped + published but never committed the bump back (has happened, e.g. v1.0.7 docs release).
5. **Tag history:** `git tag --list "v*" | sort -V | tail -5`. The next tag must be strictly greater than the newest one.
6. **Existing CHANGELOG.md entries** at `javascript/CHANGELOG.md` — read top 40 lines to match tone and to detect skipped versions that need retroactive entries.
7. **CI release workflow:** confirm `.github/workflows/` in `javascript/` contains a workflow triggered on `push: tags: ['v*']` that runs `pnpm -r publish`. Never run the publish yourself — CI owns that step. npm auth on your laptop is irrelevant for this skill; the token lives in GitHub Actions secrets.

## Bump decision matrix

Before writing anything, decide the bump type and defend it out loud.

| Scenario | Bump | Example |
|---|---|---|
| Public API signatures changed (method removed, arg type tightened, return type narrowed) | **major** | `isEnabled` now returns `Promise<boolean>` |
| Observable behavior for existing callers changes silently but API is intact (e.g. flag values may shift, HTTP call pattern changes, billing implications) | **minor** + loud CHANGELOG | the v1.1.0 "always run targeting engine" fix |
| New method added, new option, additive only | **minor** | new `client.refreshAll()` method |
| Bug fix with no observable impact beyond the bug being gone, no new API | **patch** | fixed memory leak in SSE reconnection |
| Docs only (no code changes, no package.json bump) | don't cut a release — just merge the docs PR | — |

**Rule of thumb:** if a user could upgrade without reading the changelog and be surprised by something, bump at least minor and make the changelog loud. Minor bumps aren't free, but they're cheaper than a silent trap.

## Documentation surface — update ALL of these, every time

This is the part everyone forgets. A release is not done until these are all in sync.

### Package-level docs (in `javascript/`)

| File | Always check |
|---|---|
| `CHANGELOG.md` | New entry at top. Include retroactive entries for any skipped versions. |
| `packages/node/README.md` | `## User context & targeting` section + anywhere behavior is claimed. |
| `packages/react/README.md` | `## User context & targeting` + `### Where to mount the Provider` + any callouts about cache/anonymous behavior. |
| `packages/nestjs/README.md` | `identify` callback semantics — usually unchanged for non-engine fixes. |
| `packages/astro/README.md` | `## SSG limitations` section — make sure the list of what works at build time matches current engine behavior. |
| `packages/*/package.json` | Bump `version`. Inter-package deps via `workspace:*` resolve at publish time; do not manually bump the `@flagify/node` dep in react/nestjs/astro unless you're pinning on purpose. |
| Root `README.md` | Only if it claims specific behavior. Usually untouched. |

### Website docs (in `apps/apps/website/src/content/docs/v1/`)

| File | Always check |
|---|---|
| `sdk/javascript.mdx` | `## User context` section + any `<Callout>` about behavior. |
| `sdk/react.mdx` | `## User context & targeting` + `### Where to mount the Provider`. |
| `sdk/astro.mdx` | `## SSG limitations` — which rule types work at build time. |
| `sdk/nestjs.mdx` | `## Evaluating with user context` — usually unchanged. |
| `concepts/targeting.mdx` | Only if the release changes what a rule can do or how catch-all / rollout is described. |
| `examples/basic-usage.mdx` | Only if examples make a now-incorrect claim. |
| `quick-start.mdx`, `getting-started.mdx` | Scan for now-inaccurate one-liners. |

**Scan for staleness:** before committing, grep the docs for `defaultValue.*no user`, `without.*user.*default`, `anonymous.*default`, `requires.*user`, `must.*provide.*user`. Any hit outside your own additions is a stale claim to fix.

### Other doc surfaces (only if the release touches them)

- `cli/README.md`, `cli/npm/README.md` — only if the release changes CLI behavior or flag-related commands. SDK-only releases don't touch these.
- Bruno collection in `api/bruno/` — only if the API contract changed. SDK-only releases don't touch this.
- `playground/` — optional demo update; not blocking for the release.

## Step-by-step flow

### Phase 1 — Prepare (no commits yet)

1. **Verify state** of `javascript/` and `apps/`: on `main`, clean, pulled, fetched. If either is dirty, stop and ask.
2. **Resolve the merged PR** that's being released. Confirm with the user which PR number. Read its description and diff to understand the surface area.
3. **Choose the bump type** using the matrix above. State the reason out loud. Ask the user to confirm if it's a judgment call.
4. **Read the current CHANGELOG** top section to match the style (tone, sections, link format).

### Phase 2 — Edit everything, no commits yet

1. **Bump all 4 `package.json`** files to the new version. Use one Edit per file (not a script). Verify the old version appears exactly once per file before editing.
2. **Write the CHANGELOG entry** at the top of `javascript/CHANGELOG.md`:
   - Version header with release date and GitHub release tag link.
   - Sections: `### Bug Fixes`, `### Features`, `### Behavior Change` (loud, required for any silent observable change), `### Documentation`, `### Improvements` — in that order, skip sections that don't apply.
   - Include the PR link for each item.
   - **Add retroactive entries** for any skipped versions (check `git tag --list`).
3. **Update package READMEs** using surgical edits. Do not rewrite entire sections — add callouts or short clarification sentences. Preserve the existing tone.
4. **Update website mdx docs** in `apps/apps/website/src/content/docs/v1/sdk/`. Use `<Callout type="tip">` for behavior notes, `<Callout type="warning">` for breaking changes.
5. **Grep for stale claims** (see "Scan for staleness" above). Fix any hits.

### Phase 3 — Gate on build/lint/tests

Run, in order, and do not proceed on failure:

```
cd javascript
pnpm run build                                 # all 4 packages
pnpm run lint                                  # tsc --noEmit on all 4
cd packages/node && ../../node_modules/.bin/vitest run   # direct vitest call, pnpm filter doesn't resolve the bin
```

If any step fails, STOP. Investigate the root cause. Do not proceed with a broken release.

### Phase 4 — Commit, push, open PRs

**Two PRs, one per repo:**

1. `javascript/` — branch `release/vX.Y.Z`, commit message `chore(release): vX.Y.Z — <one-line headline>`. Body explains the bump decision, what's in the release, related PRs.
2. `apps/` — branch `docs/sdk-vX.Y.Z-<behavior-slug>`, commit message `docs(sdk): reflect vX.Y.Z <headline>`. Body lists each file and why, links back to the javascript release PR.

Push both, open both PRs with `gh pr create`. Include in each PR body:
- Link to the other PR.
- Test plan checklist.
- For the javascript PR: explicit post-merge checklist (tag, publish, smoke test).

**Stop here. Ask the user to review and merge both PRs.** Do not merge them yourself — that's the user's call.

### Phase 5 — Post-merge: tag, push, wait for CI (only after user confirms both PRs are merged)

1. `cd javascript && git checkout main && git pull --ff-only origin main`
2. Verify the release commit is on main: `git log --oneline -1` should show the `chore(release): vX.Y.Z` commit.
3. `git tag vX.Y.Z` — no annotated tag unless the user asks (matches their existing history).
4. **Tell the user the tag push will trigger the publish.** Something like: "Pushing `vX.Y.Z` now — this triggers the CI release workflow, which runs `pnpm -r publish --access public` and pushes all 4 packages to npm. I'm not going to run publish manually. Proceeding?"
5. On yes, `git push origin vX.Y.Z`.
6. **Wait for CI.** Watch the run with `gh run watch` or `gh run list --workflow=release --limit=1`. Do NOT run `pnpm publish` yourself — it races with CI and corrupts the release.
7. **Verify each package on npm** once CI reports green:
   ```
   npm view @flagify/node@X.Y.Z version
   npm view @flagify/react@X.Y.Z version
   npm view @flagify/nestjs@X.Y.Z version
   npm view @flagify/astro@X.Y.Z version
   ```
   All four must return the new version. If CI succeeded but npm view shows the old version, the registry is probably still propagating — wait 30s and retry.
8. Also verify `apps/` is already on main + pulled (the docs PR should have been merged before the tag push so the docs site matches the released SDK).

### Phase 6 — Smoke test

1. Pull `playground/` main. Run it locally if the user has it wired up. Open with the Anonymous persona and confirm whatever behavior the release is supposed to fix (e.g. for v1.1.0: the Dev Tools panel must render `true` for Anonymous).
2. If the playground reproduces the expected behavior, announce done.
3. If not, investigate — a failed smoke test on a published release is a roll-forward situation (npm doesn't let you unpublish), so dig in immediately.

## Critical gotchas

- **Never run `pnpm publish` manually.** The `javascript` repo has a CI workflow (`.github/workflows/release.yml` or similar) triggered on `push: tags: ['v*']` that runs the publish. Your job ends at `git push origin vX.Y.Z`. If you also run `pnpm publish` locally, you race CI and usually end up with a half-published release (some packages on the new version, some 409 Conflict) that npm cannot roll back.
- **`pnpm --filter @flagify/node test` doesn't work** — the `vitest` bin isn't in the package's own `node_modules/.bin`. Run `cd packages/node && ../../node_modules/.bin/vitest run` instead.
- **`pnpm run build` from a package subdirectory may fail** with "barrelsby: command not found" for the same PATH reason. Run `pnpm run build` (or `turbo run build`) from the `javascript/` root instead.
- **`workspace:*` resolves at publish time** — do NOT edit the internal `@flagify/node` dependency in `react`/`nestjs`/`astro` package.json to a literal version. Pnpm rewrites it automatically when publishing.
- **Tags must match what's on main.** Never tag a release commit from a branch that hasn't been merged yet — the tag will point to a commit that doesn't exist on main after the merge squash/rebase.
- **Never merge the PRs yourself.** Even with full authority to push, by policy all merges are user-reviewed.
- **Skipped npm versions are legal but noisy.** If npm has 1.0.7 and package.json has 1.0.6, jumping straight to 1.1.0 is fine — but note the skip in the CHANGELOG with a retroactive entry for the missing version so the changelog history matches the tag history.
- **The root of `flagify/` is not a git repo** — every file you touch must live inside one of the subdirectory repos. `PROJECT.md` at the monorepo root can't be committed anywhere.

## When to NOT use this skill

- Docs-only changes with no package.json bump — just merge the docs PR directly, no changelog entry, no tag, no publish.
- CLI releases (`flagifyhq/cli`) — different repo, different publishing flow (Go binaries + npm distribution shim). This skill is JavaScript-SDK-only.
- API releases (`flagifyhq/api`) — no npm publishing, the API deploys via its own pipeline.
- When the user explicitly says "don't publish" or "dry run" — in that case stop before Phase 5.
