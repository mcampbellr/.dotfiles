# Commit & Push — Ship It

Commit ALL pending changes. Nothing should be left uncommitted.

## Instructions

1. Run `git status` to see ALL untracked and modified files (staged and unstaged).
2. Run `git diff` and `git diff --cached` to understand what changed.
3. Run `git log --oneline -5` to match the repo's commit message style.

4. **Rebase from remote main:**
   - Run `git fetch origin main` to get the latest remote main.
   - Run `git rebase origin/main`. If there are conflicts, resolve them and continue.
   - ALWAYS rebase against `origin/main` (remote), never local `main`.

5. **Decide how to commit:**
   - If the user specified specific features or groupings, respect that and create separate commits per feature/group.
   - If the user said nothing specific: look at the changes and decide whether one commit or multiple logical commits makes more sense. Group by feature/area if the changes span multiple unrelated things.
   - **CRITICAL: Every single changed and untracked file MUST be included in a commit. Nothing is left behind.**
   - Do NOT commit files that contain secrets (.env, credentials, etc.) — warn the user instead.

6. For each commit:
   - Stage the relevant files with `git add <specific files>`.
   - Write a concise commit message (1-2 sentences) that focuses on the "why".
   - End every commit message with: `Co-Authored-By: Claude <noreply@anthropic.com>`
   - Use a HEREDOC for the commit message to ensure correct formatting.

7. Run `git status` to confirm the working tree is clean and nothing was left behind.

8. **Ask the user if they want a code review before pushing.**
   - Use `AskUserQuestion` to ask whether they want to run a code review before pushing.
   - If they say yes:
     - Launch the `code-review` agent using the Agent tool with `subagent_type: "code-review"`.
     - Pass this prompt to the agent: "Review the current branch changes before push. Run git diff origin/main...HEAD and git log origin/main..HEAD to see all commits and diffs. Report findings by severity (P0 blockers, P1 important, P2 minor). Focus on bugs, security issues, and violations of project conventions. Be concise."
     - Wait for the agent to finish and present the full review to the user.
     - If there are P0 blockers, **do not proceed to push** — inform the user and stop. They must fix the issues first.
   - If they decline the review, skip straight to the push question.

9. **Ask the user if they want to push.** Do NOT push automatically. If they say yes, run `git push` (use `git push -u origin <branch>` if there's no upstream).

## Arguments
- $ARGUMENTS: Optional — specific features or files to commit separately. If empty, commit everything logically.
