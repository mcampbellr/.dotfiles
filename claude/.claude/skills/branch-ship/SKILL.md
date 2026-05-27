---
name: branch-ship
description: "Create feature branch from main, stage changes, commit with conventional message, push with -u. Safe git workflow."
when_to_use: "When user wants to ship changes on a new branch: 'branch and ship', 'create branch and push', 'ship this on a branch', or invokes /branch-ship. Not for committing on the current branch (/ship)."
argument-hint: "[branch-name (optional)]"
disable-model-invocation: true
allowed-tools:
  - Bash(git *)
  - Bash(date *)
  - Read
  - Grep
  - Agent
  - AskUserQuestion
---

# /branch-ship — Branch, commit, and push workflow

Create a feature branch from the latest main (or base branch), stage the current changes, commit with a Conventional Commits message, and push. Safe by default: no force-push, no amend, no hook skips.

## Hard rules

- **Never force-push.** Never `--force` or `--force-with-lease`.
- **Never amend.** Always create new commits.
- **Never skip hooks.** No `--no-verify`.
- **Never stage secrets.** If `.env`, credentials, or key files are in the diff, warn and exclude them.
- **Commit messages in English.** Always. Conversation stays in the user's language.
- **Co-Authored-By footer:** `Co-Authored-By: Claude <noreply@anthropic.com>` — no model name.

---

## Step 1 — Assess the working tree

Run in parallel:

```bash
git status
git diff --stat
git diff --cached --stat
git log --oneline -10
git rev-parse --abbrev-ref HEAD
git remote -v
```

Determine:
- `CURRENT_BRANCH` — where we are now.
- `BASE_BRANCH` — `main` if it exists, else `master`, else ask.
- `HAS_STAGED` — whether there are already staged changes.
- `HAS_UNSTAGED` — whether there are unstaged changes.
- `HAS_UNTRACKED` — whether there are untracked files.

If there are no changes at all (nothing staged, unstaged, or untracked), tell the user and stop.

---

## Step 2 — Determine branch name

If `$ARGUMENTS` is non-empty, use it as the branch name (sanitize: lowercase, replace spaces with `-`, strip invalid chars).

If `$ARGUMENTS` is empty, derive a branch name from the diff:

1. Spawn a Haiku subagent to analyze the diff and produce a branch name:
   - `model: "haiku"`
   - Read-only. Pass the `git diff --stat` output.
   - Prompt: "Given this diff stat, produce a single kebab-case git branch name following the pattern `<type>/<short-description>` where type is one of: feat, fix, refactor, chore, docs, test, style, perf. Return ONLY the branch name, nothing else."
   - Example output: `feat/add-user-avatar-upload`

2. If on `CURRENT_BRANCH` that is NOT `BASE_BRANCH` and there are commits ahead, ask the user:
   - **Stay on current branch** — commit and push here.
   - **Create new branch** — use the derived name.

Set `TARGET_BRANCH`.

---

## Step 3 — Create and switch to the branch (if needed)

If `TARGET_BRANCH` != `CURRENT_BRANCH`:

```bash
git fetch origin <BASE_BRANCH>
git checkout -b <TARGET_BRANCH> origin/<BASE_BRANCH>
```

If the branch already exists on remote, ask the user whether to:
- Track the existing remote branch.
- Pick a different name.

If we created a new branch from `BASE_BRANCH` and had unstaged/untracked changes, they carry over (git preserves working tree on checkout -b).

---

## Step 4 — Stage changes

Analyze the diff to identify files to stage. Rules:
- **Exclude** `.env`, `*.pem`, `*.key`, `credentials.*`, `*secret*` — warn the user.
- **Exclude** large binaries (>5MB) — warn the user.
- Stage specific files by name. Never `git add -A` or `git add .`.

If there are already staged changes AND unstaged changes, ask the user:
- **Stage everything** (minus exclusions).
- **Keep current staging** — only commit what's already staged.
- **Let me pick** — list files for the user to choose.

---

## Step 5 — Generate commit message

Spawn a Haiku subagent to draft the commit message:
- `model: "haiku"`
- Read-only. Pass: `git diff --cached --stat` and `git diff --cached` (truncated to first 200 lines if large).
- Prompt: "Analyze this staged diff. Produce a Conventional Commits message: `<type>(<scope>): <summary>` on the first line (imperative, lowercase, no period, ≤72 chars), then a blank line, then 1-3 bullet points explaining WHY (not what). Return ONLY the commit message, nothing else."

Present the generated message to the user via `AskUserQuestion`:
- **Use this message** (show the message).
- **Edit it** — open-ended input.

---

## Step 6 — Commit

Commit using a HEREDOC. Append the Co-Authored-By footer:

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <summary>

- <why bullet 1>
- <why bullet 2>

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

If a pre-commit hook fails: read the error, fix the cause if trivial (formatting, lint), re-stage, and create a **new** commit (never amend). If the fix is non-trivial, report the error and stop.

---

## Step 7 — Push

```bash
git push -u origin <TARGET_BRANCH>
```

If push fails due to divergence, do NOT force-push. Tell the user and suggest:
- `git pull --rebase origin <TARGET_BRANCH>` then retry.

---

## Step 8 — Summarize and stop

Output:
- Branch name and remote URL (if available).
- Commit SHA (short).
- Files changed count.
- Suggest next step: "Create a PR with `/review` or `gh pr create`."

Done.
