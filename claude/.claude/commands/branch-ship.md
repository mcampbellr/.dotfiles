# Branch, Rebase & Ship

Create a new branch from the current state, rebase from main, commit all changes, and optionally push.

## Instructions

1. **Create a new branch:**
   - If `$ARGUMENTS` includes a branch name, use it. Otherwise, generate a descriptive branch name based on the changes (e.g. `feat/kyc-upload-unification`, `fix/mobile-responsive`).
   - Run `git checkout -b <branch-name>`.

2. **Rebase from main:**
   - Run `git fetch origin main` to get latest main.
   - Run `git rebase origin/main`. If there are conflicts, resolve them and continue.

3. **Review and commit:**
   - Run `git status` to see ALL untracked and modified files (staged and unstaged).
   - Run `git diff` and `git diff --cached` to understand what changed.
   - Run `git log --oneline -5` to match the repo's commit message style.
   - **Decide how to commit:**
     - If the user specified specific features or groupings, respect that and create separate commits per feature/group.
     - If the user said nothing specific: look at the changes and decide whether one commit or multiple logical commits makes more sense. Group by feature/area if the changes span multiple unrelated things.
     - **CRITICAL: Every single changed and untracked file MUST be included in a commit. Nothing is left behind.**
     - Do NOT commit files that contain secrets (.env, credentials, etc.) — warn the user instead.
   - For each commit:
     - Stage the relevant files with `git add <specific files>`.
     - Write a concise commit message (1-2 sentences) that focuses on the "why".
     - End every commit message with: `Co-Authored-By: Claude <noreply@anthropic.com>`
     - Use a HEREDOC for the commit message to ensure correct formatting.

4. Run `git status` to confirm the working tree is clean and nothing was left behind.

5. **Code review before push:**
   - Launch the `code-review` agent using the Agent tool with `subagent_type: "code-review"`.
   - Pass this prompt to the agent: "Review the current branch changes before push. Run git diff main...HEAD and git log main..HEAD to see all commits and diffs. Report findings by severity (P0 blockers, P1 important, P2 minor). Focus on bugs, security issues, and violations of project conventions. Be concise."
   - Wait for the agent to finish and present the full review to the user.
   - If there are P0 blockers, **do not proceed to push** — inform the user and stop. They must fix the issues and re-run the command.

6. **Ask the user if they want to push.** Do NOT push automatically. If they say yes, run `git push -u origin <branch-name>`.

## Arguments
- $ARGUMENTS: Optional — branch name and/or specific features or files to commit separately. If empty, auto-generate branch name and commit everything logically.
