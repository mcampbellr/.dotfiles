---
name: docs-update
description: Verify, audit, or update project documentation after code or product changes. Use when the user invokes /docs-update or asks "are the docs in sync", "check the website docs", "update docs after this merge", or "what docs do I need to refresh". Works in any repo by detecting documentation nodes (READMEs, *.mdx/.md, OpenAPI, Bruno, CLAUDE.md, decisions, npm READMEs, code with public APIs) and building a small graph in `.docs-updates` at the repo root. First run scans and persists the graph; subsequent runs diff against the saved git SHA, walk topic edges, and propose a checklist of docs that need refreshing. Spawns a sub-agent so the main session stays clean.
---

# /docs-update

Audits and updates documentation across a project. Treats docs as a graph: each doc is a node, edges are explicit cross-references, shared topics, and "must-stay-in-sync" relationships. The graph is persisted in `.docs-updates` at the repo root so future runs are incremental.

## When to invoke

- After a non-trivial merge to `main`: which docs got stale?
- Before a release: which user-facing pages still describe the old API?
- After a feature rename, deprecation, or schema change.
- During an audit: "show me every doc that references X."
- The user types `/docs-update`, "update the docs", "are docs in sync", "check website docs".

## Usage

```
/docs-update                    # auto: build .docs-updates if missing, otherwise diff + suggest
/docs-update --rebuild          # force a fresh scan, overwriting .docs-updates
/docs-update --plan             # print update checklist, do not edit anything
/docs-update --apply            # walk checklist and edit docs (with per-file confirmation)
/docs-update --since <git-ref>  # use a specific git ref instead of the saved SHA
/docs-update --topic <name>     # narrow to a single topic cluster (e.g. "webhooks")
```

## Operating principle

The skill **does not** do the heavy lifting itself. It **spawns a sub-agent** (`general-purpose`) with a self-contained brief, so the scan, graph build, and proposal all run in the agent's context. The main session only orchestrates and surfaces the result.

This matters because:
- The repo can be large (hundreds of docs) and the scan should not bloat the parent context.
- The graph rebuild can run in parallel with other work.
- The agent's report comes back as a compact checklist, not raw file dumps.

## `.docs-updates` schema

JSON file at the **repo root** (the directory where the user invoked the skill — verify it's a git repo first; if it's a monorepo of separate repos, ask the user which one to scan). Format:

```json
{
  "version": 1,
  "scanned_at": "2026-05-02T04:00:00Z",
  "git_sha": "abc1234",
  "repo_root": "/absolute/path",
  "nodes": [
    {
      "id": "apps/website/src/content/docs/cli/commands.mdx",
      "type": "website-docs",
      "topics": ["cli", "commands"],
      "checksum": "sha1:..."
    },
    {
      "id": "cli/README.md",
      "type": "readme",
      "topics": ["cli", "commands", "auth"],
      "checksum": "sha1:..."
    },
    {
      "id": "api/openapi.yaml",
      "type": "api-spec",
      "topics": ["webhooks", "flags", "auth"],
      "checksum": "sha1:..."
    }
  ],
  "edges": [
    {
      "from": "cli/README.md",
      "to": "apps/website/src/content/docs/cli/commands.mdx",
      "kind": "syncs-with",
      "reason": "CLAUDE.md mandates: update docs in 3 places — README, npm README, website"
    },
    {
      "from": "api/openapi.yaml",
      "to": "api/bruno/webhooks/",
      "kind": "describes",
      "reason": "Bruno collection mirrors OpenAPI endpoints"
    },
    {
      "from": "cli/cmd/webhooks.go",
      "to": "cli/README.md",
      "kind": "depends-on",
      "reason": "public CLI surface — README documents commands defined here"
    }
  ],
  "topics_index": {
    "webhooks": [
      "api/internal/domain/webhook/dispatcher.go",
      "api/internal/domain/webhook/model.go",
      "api/openapi.yaml",
      "apps/website/src/content/docs/v1/concepts/webhooks.mdx",
      "cli/cmd/webhooks.go",
      "cli/README.md"
    ]
  },
  "sync_triplets": [
    {
      "name": "cli-3-places",
      "members": ["cli/README.md", "cli/npm/README.md", "apps/website/src/content/docs/cli/commands.mdx"],
      "source": "CLAUDE.md → 'Update docs in 3 places'"
    }
  ]
}
```

Keep the schema minimal but extensible. Don't over-engineer — the goal is a graph that's *good enough to find affected docs*, not a perfect ontology.

## Algorithm — first run (scan + build)

When `.docs-updates` is missing (or `--rebuild`):

### 1. Identify documentation nodes

Walk the repo (skip `node_modules`, `.git`, `dist`, `build`, `.turbo`, `.next`, `target`, `vendor`, `graphify-out`):

- All `README.md` and `README.mdx` (any depth).
- All `*.md` and `*.mdx` files.
- `openapi.yaml` / `swagger.yaml` / `openapi.json`.
- `.bru` files (Bruno collections).
- `CLAUDE.md` / `AGENTS.md` files (instruction files often double as docs).
- Files in directories that look like docs roots: `docs/`, `Docs/`, `documentation/`, `decisions/`, `runbooks/`, `incidents/`, `learn/`.
- For monorepos: respect every package's own README.
- **Code files with public surface** (sample sparingly): `cli/cmd/*.go`, top-level `index.ts`, route registries — these become "code-public-api" nodes whose docs are downstream.

For each node, capture: `id` (relative path), `type`, raw text (briefly), and a checksum (sha1 of contents truncated to 12 chars is enough).

### 2. Extract topics

For each node, derive **topics** (3–7 short tokens):

- File stem (e.g., `webhooks.mdx` → `webhooks`).
- All h1 + h2 headings, normalized to lowercase, alphanumeric tokens (drop fillers: "introduction", "overview", "getting started").
- Parent folder name if it's not generic (skip `src`, `docs`, `content`, `pages`).
- For code: function/type names exported at the top of the file.

Then **dedupe and intersect across the corpus**: a topic that appears in only one file is probably noise (folder-specific). Keep topics that appear in ≥2 nodes — they're the connectors.

### 3. Build edges

Three sources, in order:

**(a) Explicit cross-references** — parse markdown:
- Internal links `[text](relative/path)` → edge `from → to`, kind `references`.
- Heading anchors `[text](#anchor)` → ignore (intra-doc).

**(b) Topic co-occurrence** — for each topic in `topics_index`, every pair of nodes sharing it gets an edge of kind `same-topic` with the topic name as `reason`. (Skip pairs already linked explicitly.) Cap per-topic at the most-cited 6 nodes to keep the graph readable.

**(c) Manual sync hints** — grep the corpus for known phrases that mean "these N files must stay in sync":
- "Update docs in 3 places", "sync with", "stay in lockstep", "must match", "mirrors".
- When a doc lists ≥2 paths after such a phrase, register a `sync_triplet` (or N-tuple) with all members and add edges among them, kind `syncs-with`.

CLAUDE.md files at the repo root are gold for this — they often state explicit sync rules.

### 4. Persist

Write `.docs-updates` to repo root. **Do not commit it** — it's a local working file. Add it to `.gitignore` if not already present (offer to do this; do not edit `.gitignore` without confirmation).

Print a summary: `Scanned N files, K topics, E edges, T sync-triplets. Saved to .docs-updates.`

## Algorithm — subsequent run (diff + suggest)

When `.docs-updates` exists and the user invokes the skill again:

### 1. Load context

Read `.docs-updates`. Note `git_sha` from the file.

### 2. Detect changes

Run `git diff <saved-sha>..HEAD --name-only` (or `--since <ref>` if provided). Filter to:
- Files that have a node in the graph (direct hit).
- Files in directories represented in `topics_index` even if not exactly matched (proximity hit).

### 3. Walk the graph

For each changed file `f`:

- If `f` is a node: collect its `topics`. For each topic, take all other nodes in `topics_index[topic]`. Also walk all outgoing edges from `f` of kind `syncs-with`, `references`, `describes`. Stop at depth 2 — further is noise.
- If `f` is not a node but lives in a known topic cluster: add the cluster's docs as candidates.

Each candidate doc gets a **score**:

- 3 points if it's the other side of a `syncs-with` edge from a changed file (direct sync mandate).
- 2 points if it shares ≥2 topics with a changed file.
- 1 point per shared topic otherwise.

Rank candidates desc. Drop anything below score 1.

### 4. Output checklist

Group by candidate's *type* (website-docs, readme, api-spec, …) and present:

```
## Docs likely affected by changes since <sha>

### Website docs (apps/website/src/content/docs/)
- [ ] cli/commands.mdx — added: webhooks command (cli/cmd/webhooks.go)
- [ ] v1/concepts/webhooks.mdx — env-scope rename (api/internal/domain/webhook/model.go)

### README / npm
- [ ] cli/README.md — webhooks command section (sync triplet: cli-3-places)
- [ ] cli/npm/README.md — same

### API spec / collections
- [ ] api/openapi.yaml — environment-scoped routes (POST /v1/projects/.../environments/.../webhooks)
- [ ] api/bruno/webhooks/ — Bruno collection missing per CLAUDE.md
```

For each item, include the *trigger* (the changed file) so the human can see why it's flagged.

### 5. (Optional) `--apply`

If `--apply` is set:

- For each item in the checklist, spawn a focused sub-agent with: the changed code (as context), the doc to update (as target), the type of update (rename, new feature, removal). Get a proposed diff. Confirm with the user. Apply.
- Skip items that need product judgment ("which examples to keep") — flag them for human review instead of guessing.

If `--apply` is **not** set, just print the checklist and stop.

## How the main session orchestrates

When `/docs-update` is invoked, do this in the parent session:

1. Verify `pwd` is a git repo; if not, ask the user where to run.
2. Check `.docs-updates`:
   - Missing or `--rebuild`: spawn a `general-purpose` agent with a brief that includes the schema (above), the algorithm (above), and instructs it to *write* `.docs-updates` and then return a one-paragraph summary.
   - Present: spawn a `general-purpose` agent with a brief that includes the saved graph, the diff command, and instructs it to *return only the markdown checklist* (≤ 400 lines).
3. Surface the agent's output to the user verbatim.
4. If `--apply`, walk the checklist with one focused sub-agent per file (parallelize when independent).

Do not expand the algorithm in the parent session — that defeats the purpose.

## Brief template for the build-agent

When the parent session spawns the build-agent (first run / `--rebuild`), use this prompt template:

> You are a documentation-graph builder for `<repo-root>`.
>
> Build a graph of every documentation node in this repo and persist it to `.docs-updates` (JSON, format below). The graph will let future runs find which docs to update after a code change.
>
> **Schema**: `<paste schema from SKILL.md>`
>
> **Algorithm**: `<paste algorithm — first run from SKILL.md>`
>
> **Skip directories**: `node_modules .git dist build .turbo .next target vendor graphify-out coverage`.
>
> **Special signals to look for**:
> - `CLAUDE.md` files often list explicit sync rules ("update docs in N places", "stay in lockstep", "mirror"). Treat those as authoritative for `sync_triplets`.
> - For each `OpenAPI` spec, every endpoint maps to (a) a Bruno collection file under `bruno/` if present, (b) the CLI command that calls it, (c) the website docs page describing it.
> - For each `package.json` with a `version`, the README in the same directory and the `cli/npm/README.md` (if present) are sync targets.
>
> **Output**:
> 1. Write the JSON to `<repo-root>/.docs-updates`.
> 2. Add `.docs-updates` to `.gitignore` only if it isn't already there. Ask the parent before editing `.gitignore`.
> 3. Return a ≤ 200-word summary: counts of nodes / topics / edges / sync_triplets, plus the 5 most-connected nodes.

## Brief template for the query-agent

When the parent session spawns the query-agent (subsequent run), use this prompt template:

> You are a documentation-update advisor for `<repo-root>`.
>
> The graph is at `<repo-root>/.docs-updates`. Saved git_sha: `<sha>`.
>
> Run `git diff <sha>..HEAD --name-only` to find changed files since the last scan. (Or use `<since-ref>` if the user passed `--since`.)
>
> **Algorithm**: `<paste algorithm — subsequent run from SKILL.md>`
>
> **Output**: a markdown checklist (use the format from the SKILL.md "Output checklist" section). Group by doc type. Each item must include the trigger file in parentheses. Cap at 30 items; if more, summarize the long tail ("+ 14 more in apps/website/...").
>
> **Do not edit any files.** Only read.

## Brief template for the apply-agent

For each checklist item the user wants to apply, spawn a focused agent:

> You are a documentation editor.
>
> **Target file**: `<doc-path>`.
>
> **Trigger file** (the change driving this update): `<code-or-config-path>`.
>
> **Topic / nature of change**: `<one line: rename, new feature, removal, schema change>`.
>
> Read both files. Propose a precise edit (use the Edit tool) to make the doc reflect the trigger. Preserve voice, tone, and surrounding structure. Do not invent examples — copy patterns from the trigger file when needed.
>
> Return: a one-line confirmation of what you changed, or `SKIP — needs human judgment because <reason>` if the change is non-mechanical (e.g., choosing which deprecated example to keep).

## Failure modes to avoid

- **Don't try to be a search engine.** The graph is a heuristic, not ground truth. Always cite the trigger file in the checklist so a human can verify.
- **Don't over-cluster.** Topics with >6 members get capped — better to miss a few candidates than drown the user in noise.
- **Don't edit `.gitignore` without asking.** That's the user's file.
- **Don't commit `.docs-updates`.** It's per-checkout state, not project-shared (different developers have different `git_sha` baselines).
- **Don't edit user-facing docs without `--apply`.** The checklist is the default deliverable.
- **Don't run during merge conflicts.** Bail with an error if `git status` shows unmerged paths.

## Notes

- The graph is best-effort. Trust EXTRACTED edges (markdown links, sync_triplets from CLAUDE.md) more than INFERRED edges (topic co-occurrence).
- Re-run `/docs-update --rebuild` whenever the project structure changes substantially (new subrepo, major refactor, new doc directory).
- Combine with `/graphify` for deeper code-level traceability — `/graphify` indexes code symbols; `/docs-update` indexes doc nodes. They're complementary.
