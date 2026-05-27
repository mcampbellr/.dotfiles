---
name: bug
description: "Bug report → refined investigation → OpenSpec proposal. Read-only; never implements fixes."
when_to_use: "When user reports a bug, something broken, an error, a regression, or invokes /bug. Not for features (/idea) or small changes (/quick-win)."
argument-hint: [bug-description]
disable-model-invocation: true
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(openspec *)
  - Bash(git rev-parse *)
  - Agent
  - AskUserQuestion
  - Skill
---

# /bug — Bug investigation proposal workflow

You handle `/bug [description]`. The goal is to turn a raw, imperfect bug report into a high-quality OpenSpec proposal **for investigation/fix**, without implementing anything.

Hard rules:

- **Never implement a code fix in this skill.** Stop after the OpenSpec proposal is created. If the user wants the fix, they must invoke `/opsx:apply` (or ask explicitly).
- **Do not install npm packages.** If a dependency is missing, tell the user the exact command and stop.
- **Do not edit application code.** Read-only investigation only.
- **Ask at most 5 clarifying questions in a single batch.** If more are needed, prioritize blockers; the rest become "Open questions" in the proposal.

---

## Step 1 — Read the bug description from `$ARGUMENTS`

- The raw bug description is in `$ARGUMENTS`.
- If `$ARGUMENTS` is empty or whitespace-only, ask the user (via `AskUserQuestion`, open-ended) for the bug description before doing anything else. Do not proceed without a description.

Hold the raw description as `RAW_BUG`.

---

## Step 2 — Verify OpenSpec is available

Run:

```bash
openspec --version
```

- If the command fails or is not found, tell the user:

  > OpenSpec is not installed. Install it with:
  >
  >     npm install -g @fission-ai/openspec@latest
  >
  > Then re-run `/bug`.

  Stop here. Do not proceed.

- If OpenSpec is installed, check whether the project is initialized for OpenSpec (e.g., presence of `openspec/` directory at the repo root, or `openspec list` returning a usable response).

  - If **not initialized**, ask the user explicitly (via `AskUserQuestion`) whether to run:

        openspec init

    Only run it if the user confirms. Do not run `openspec init` without confirmation.

---

## Step 3 — Refine the bug report with the `bug-spec-refiner` subagent

Invoke the `bug-spec-refiner` subagent via the `Agent` tool. Requirements for this invocation:

- `subagent_type: "bug-spec-refiner"`
- `model: "haiku"` — the subagent must run on Haiku.
- The subagent is **read-only**. It must not modify files and must not run shell commands.
- Pass `RAW_BUG` plus enough framing so the agent can do its job cold:

  > You are refining a raw bug report into an investigation brief. You are read-only — do not edit any files, do not run shell commands, only Read/Grep/Glob if useful. Identify ambiguity instead of inventing product intent. Return the exact section structure described in your agent definition.
  >
  > Raw bug report:
  >
  > <RAW_BUG>

The subagent returns a structured brief with these sections (in this order):

1. Optimized Bug Title
2. Problem Summary
3. Expected Behavior
4. Actual Behavior
5. Reproduction Steps
6. Missing Reproduction Details
7. Suspected Code Area
8. Severity and Impact
9. Assumptions
10. Blocking Clarifying Questions
11. Non-Blocking Clarifying Questions
12. OpenSpec Proposal Prompt

Call this output `BRIEF`.

---

## Step 4 — Resolve blocking ambiguity with the user

Read `BRIEF["Blocking Clarifying Questions"]`.

Blocking ambiguity includes (non-exhaustive):

- Missing expected behavior
- Missing actual behavior
- Missing reproduction path
- Unclear affected feature/surface
- Unclear environment when environment is likely relevant (web vs mobile vs desktop, dev vs prod, browser, OS)
- Multiple possible bugs mixed into one report
- Risk of changing observable behavior without knowing product intent

If there are blocking questions:

- Ask the user via `AskUserQuestion`.
- **Maximum 5 questions in one batch.** If the subagent produced more, pick the 5 with the highest risk of changing the fix direction; promote the rest to "Open questions" in the proposal body.
- Use single-select or multi-select options when the answer space is small and known; fall back to open-ended (no options) only when truly free-form.

If the only ambiguity is non-blocking, skip the question round and carry those forward as "Open questions" in the proposal.

After answers come back, fold them into the brief: update Expected Behavior / Actual Behavior / Reproduction Steps / Scope as applicable, and shorten the Blocking Questions list to anything still unresolved (ideally zero).

---

## Step 5 — Create the OpenSpec proposal

Compose the final proposal prompt from the refined brief. The proposal body must contain these sections, in this order, with these exact headings:

- **Problem**
- **Scope**
- **Non-goals**
- **Reproduction steps**
- **Expected behavior**
- **Actual behavior**
- **Acceptance criteria**
- **Test plan**
- **Risks**
- **Open questions**

Frame the change as a **bug investigation/fix**, not a new feature. The kebab-case change name should be derived from the optimized title and prefixed `fix-` (e.g., `fix-checkout-double-charge`).

Prefer the OpenSpec slash command to create the proposal:

```
/opsx:propose <optimized bug investigation prompt>
```

Where `<optimized bug investigation prompt>` includes:

- The kebab-case change name (e.g., `fix-checkout-double-charge`)
- A one-line summary
- The full proposal body with the section structure above

If `/opsx:propose` is not available in the current session, fall back to invoking the `openspec-propose` skill (`Skill` tool with `skill: "openspec-propose"`) and pass the same composed prompt.

Do **not** call `/opsx:apply` or otherwise start implementation. The skill ends after the proposal is generated.

---

## Step 6 — Summarize and stop

Output a short summary to the user:

- Optimized bug title
- Path to the created OpenSpec change (e.g., `openspec/changes/fix-...`)
- Any remaining open questions
- Next step: "Review the proposal. When you're ready to implement, run `/opsx:apply fix-<name>`."

Do not proceed to implementation. Do not edit any source files. Stop.
