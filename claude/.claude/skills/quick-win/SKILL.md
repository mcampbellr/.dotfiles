---
name: quick-win
description: "Small change (not bug, not feature) → refine → apply → commit. Lighter than /bug and /idea."
when_to_use: "When user has a small refactor, rename, extract, tighten copy, add index, or other low-risk mechanical change. Not for bugs (/bug) or features (/idea)."
argument-hint: [quick-win-description]
disable-model-invocation: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash(git *)
  - Bash(date *)
  - Bash(mkdir *)
  - Bash(test *)
  - Bash(pnpm *)
  - Bash(npm *)
  - Bash(npx *)
  - Bash(go *)
  - Bash(cargo *)
  - Bash(ruff *)
  - Bash(mypy *)
  - Agent
  - AskUserQuestion
---

# /quick-win — Quick-win workflow

You handle `/quick-win [description]`. A quick win is a small change that is **not a bug** and **not a full feature** — a refactor, a rename, an extracted helper, a tightened copy, a missing index, a promoted file. The goal is to refine it just enough, document it in a single line, apply it, and commit. No OpenSpec proposal, no per-task planning directory, no STATE.md.

When to use which:
- `/bug` — something is broken, needs investigation, may change observable behavior. Stops at proposal.
- `/idea` — new feature or behavior. Stops at proposal.
- `/quick-win` — small mechanical-ish change with low risk. **Applies the change in the same run.**
- `/gsd-quick` — small change that still wants the full GSD plumbing (PLAN.md, STATE.md, full executor). Heavier than `/quick-win` on purpose.

Hard rules:

- **Stay small.** If during refinement the change turns out to need an OpenSpec proposal (cross-cutting scope, behavior change, new API surface), stop and tell the user to use `/idea` instead. Do not silently expand.
- **No installs.** If a dependency is missing, tell the user the exact command and stop.
- **Read-only refinement, then targeted edits.** The refiner is read-only. Once the brief is approved, you (main) execute the edits directly using Read/Edit/Write.
- **Ask at most 3 clarifying questions in a single batch.** Most quick wins should need zero. If the refiner returns more than 3 blocking questions, the change is too big — tell the user and suggest `/idea`.
- **Preserve the user's language.** If the raw description is in Spanish (or any non-English language), questions and the log entry stay in that language. The kebab-case slug and the commit message stay in English (standard git-artifact rule).
- **Commit at the end.** The skill commits the diff atomically with a Conventional Commits message. If the user wants to review before committing, they will say so — otherwise commit.

---

## Step 1 — Read the description from `$ARGUMENTS`

- The raw description is in `$ARGUMENTS`.
- If `$ARGUMENTS` is empty or whitespace-only, ask the user (via `AskUserQuestion`, open-ended) for the quick-win description before doing anything else. Do not proceed without one.

Hold the raw description as `RAW_QW`.

---

## Step 2 — Sanity-check that this is a quick win

Before spawning the refiner, look at `RAW_QW` for obvious red flags that mean it is **not** a quick win:

- Mentions new screen / new page / new tab / new modal → likely `/idea`
- Mentions "doesn't work" / "broken" / "regression" / "errors out" → likely `/bug`
- Mentions multiple unrelated changes ("and also" patterns) → ask the user to split or pick one
- Mentions schema / migration / new table / new endpoint → likely `/idea` (unless it is literally a one-line index)

If any red flag is hit, tell the user which command fits better and stop. Do not spawn the refiner.

---

## Step 3 — Refine with the `quick-win-refiner` subagent

Invoke the `quick-win-refiner` subagent via the `Agent` tool. Requirements:

- `subagent_type: "quick-win-refiner"`
- `model: "haiku"` — the subagent must run on Haiku.
- The subagent is **read-only**. It must not modify files and must not run shell commands.
- Pass `RAW_QW` plus this framing:

  > You are refining a raw quick-win request into a minimal execution brief. You are read-only — do not edit any files, do not run shell commands, only Read/Grep/Glob. Preserve the user's language. Be terse. Surface ambiguity only when it would change the diff. Return the exact section structure described in your agent definition.
  >
  > Raw quick-win request:
  >
  > <RAW_QW>

The subagent returns a brief with these sections (in this order):

1. Optimized Title
2. Kebab-case Slug
3. Change Type
4. What Changes
5. Why
6. Files to Touch
7. Acceptance
8. Risks
9. Blocking Clarifying Questions
10. Non-Blocking Notes

Call this output `BRIEF`.

**Scope guard:** if `BRIEF` contains more than 3 blocking questions, or its Files to Touch list spans more than ~6 files, or Risks lists user-visible behavior changes, stop and tell the user the change is too large for `/quick-win` and recommend `/idea`. Do not proceed.

---

## Step 4 — Resolve blocking ambiguity with the user (only if needed)

Read `BRIEF["Blocking Clarifying Questions"]`.

- If it is `None` or empty → skip to Step 5.
- If there are 1-3 questions → ask the user via `AskUserQuestion`. Use single-select or multi-select when the answer space is small and known; open-ended only when truly free-form.

After answers come back, fold them into `BRIEF`: update Files to Touch / What Changes / Acceptance as applicable.

---

## Step 5 — Append the log entry to `.planning/quick-wins.md`

The log lives at `.planning/quick-wins.md` (relative to the repo root). It is a single append-only file with a Markdown table.

1. Resolve the repo root:
   ```bash
   git rev-parse --show-toplevel
   ```
   If the current directory is not a git repo, fall back to the current working directory but warn the user that the log will live outside of version control.

2. Ensure `.planning/` exists:
   ```bash
   mkdir -p .planning
   ```

3. Check whether the log file exists:
   ```bash
   test -f .planning/quick-wins.md && echo exists || echo missing
   ```

4. If **missing**, create it with this exact content (use the Write tool):

   ```markdown
   # Quick Wins

   Append-only log of quick wins — small changes that are not bugs (`/bug`) and not full features (`/idea`). Each row documents a change refined by `/quick-win` and applied in the same session.

   | Date | Slug | Type | Summary | Files | Commit |
   | --- | --- | --- | --- | --- | --- |
   ```

5. **Append a new row** to the table for this quick win, with these columns:

   - `Date` — today's date as `YYYY-MM-DD` (resolve via `date +%F`, not a guess)
   - `Slug` — `BRIEF["Kebab-case Slug"]`
   - `Type` — `BRIEF["Change Type"]`
   - `Summary` — `BRIEF["What Changes"]` collapsed to a single line (≤ 120 chars; truncate with `…` if needed). Use the user's language.
   - `Files` — top 3 file paths from `BRIEF["Files to Touch"]`, separated by `; `. Strip `:line-range` suffixes; only the path. If more than 3, append `; +N more`.
   - `Commit` — `pending` (placeholder; backfilled in Step 8)

   Escape any `|` characters inside cell content as `\|`. Newlines inside cells must be replaced with a single space.

Use the `Edit` tool to append the row (do not rewrite the whole file).

---

## Step 6 — Execute the change

Apply the diff using `Read` + `Edit` (and `Write` only when promoting an inline component to a new file or creating a small new module that the brief explicitly calls out). Stay strictly within `BRIEF["Files to Touch"]` unless a collateral usage forces a small extra edit; if it does, note it under Non-Blocking Notes for the summary.

Rules during execution:
- No new abstractions beyond what the brief says.
- No reformatting unrelated lines.
- No drive-by fixes.
- If you discover the change is bigger than the brief while editing, stop, revert any partial edits (`git restore` only the files you touched), update the log row's Commit cell to `aborted: out of scope`, and tell the user to re-run as `/idea`.

---

## Step 7 — Validate

Run the **minimal** validation that fits the affected packages. Detect the stack from the repo:

- TypeScript/JavaScript repo (`package.json` at root or in a workspace) → run the project's typecheck script (`tsc --noEmit`, `pnpm check-types`, `npm run typecheck`, etc.) scoped to the touched workspace. If the repo uses pnpm workspaces or turborepo, scope to the touched filter.
- Python repo (`pyproject.toml` / `setup.py`) → run `ruff check` or `mypy` on the touched paths if the project uses them.
- Go repo (`go.mod`) → `go vet ./...` on the touched module.
- Rust (`Cargo.toml`) → `cargo check` on the touched crate.

If the repo has a project-specific rule that requires regenerating a sibling artifact after touching a source (e.g. a built `dist/`, generated types, codegen output, prisma migrations), do that regeneration as part of the validation step — read the repo's `CLAUDE.md` or `AGENTS.md` if present to discover those rules before editing.

Do **not** run the whole test suite for a quick win. If typecheck/build fails, fix the underlying issue or revert and report. Do not skip hooks.

---

## Step 8 — Commit and backfill the log

1. Stage **only** the files the quick win touched, plus `.planning/quick-wins.md`, plus any regenerated sibling artifacts from Step 7. Never use `git add -A` or `git add .`.

2. Commit with a Conventional Commits message in English:

   ```
   <type>(<scope>): <imperative summary>
   ```

   Where:
   - `<type>` = `BRIEF["Change Type"]`
   - `<scope>` = best-guess scope from the first touched path; mirror the existing pattern in `git log --oneline -20` for this repo (e.g., `mobile/<feature>`, `api/<feature>`, `<package>`). If the repo's commit style does not use scopes, omit it: `<type>: <summary>`.
   - `<summary>` = imperative, lowercase, no trailing period, ≤ 72 chars.

   Append the standard footer:

   ```
   Co-Authored-By: Claude <noreply@anthropic.com>
   ```

   Use a HEREDOC for the message (per global git rules). Never use `--no-verify`. Never use `--amend` — if hooks fail, fix the cause and create a new commit.

3. After the commit succeeds, capture the short SHA:
   ```bash
   git rev-parse --short HEAD
   ```

4. Backfill the log: use `Edit` to replace the `pending` cell in the row you appended in Step 5 with the short SHA (e.g., `abc1234`).

5. Stage and commit the log backfill as a second commit:

   ```
   docs(quick-wins): backfill commit sha for <slug>
   ```

   (Same Co-Authored-By footer.)

Two commits is intentional: the actual change is one atomic commit; the log row references it by SHA, so the row cannot be written until the SHA exists.

---

## Step 9 — Summarize and stop

Output a short summary to the user (in their language):

- Optimized title
- Slug + type
- Commit SHA of the change
- Path to the log entry: `.planning/quick-wins.md`
- Anything left under Non-Blocking Notes
- Suggested next quick win only if the refiner explicitly surfaced one; otherwise omit

Done. Do not start another quick win unless the user asks.
