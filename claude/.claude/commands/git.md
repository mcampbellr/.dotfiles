Operate on the current working directory's git repository.

Execute ALL bash commands immediately without asking for permission.

---

**If `$ARGUMENTS` is a branch name (non-empty):**

1. Fetch latest:
   git fetch origin 2>&1

2. Detect local changes:
   git diff --name-only
   git diff --name-only --cached
   git ls-files --others --exclude-standard

3. Detect remote changes for target branch:
   git diff --name-only HEAD..origin/$ARGUMENTS 2>/dev/null || true

4. If there are local changes:

   - Compare file lists (local vs origin/$ARGUMENTS)
   - If overlap exists → assume conflict risk:
     git stash push -u -m "auto-stash before switching to $ARGUMENTS" 2>&1
     git reset --hard HEAD 2>&1

5. Checkout and pull:
   git checkout $ARGUMENTS 2>&1
   git pull 2>&1

6. If checkout fails (branch missing locally):
   git checkout -B $ARGUMENTS origin/$ARGUMENTS 2>&1
   git pull 2>&1

Output:

- repo-name ✓ $ARGUMENTS + pulled
- or exact error message
- append "(stashed local changes)" if stash was used

Do not explain anything — only output results.

---

**If `$ARGUMENTS` is empty:**

Run:

git branch --show-current
git status --short
git log main..HEAD --oneline 2>/dev/null || git log HEAD --oneline -5
git rev-list --count HEAD..origin/main 2>/dev/null

Then output:

- **Repo name** (from directory name)
- Current branch
- If NOT main:
  - commits ahead of main
  - list of commits
- Uncommitted changes (if any)
- If clean on main → "clean"

Format as a compact dashboard. No explanations.
