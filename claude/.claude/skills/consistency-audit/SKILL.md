---
name: consistency-audit
description: |
  Find places where the codebase does the same thing two different ways and the
  outlier is almost certainly an oversight. Use when the user invokes
  /consistency-audit, /audit-consistency, or asks "find inconsistencies",
  "is this the way we do X here", "are there outliers", or "this differs from
  the rest of the repo". Reports divergences with majority pattern, outlier
  locations, and a one-line suggested fix. Asks the user when the right
  pattern is genuinely ambiguous instead of guessing.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Edit
  - AskUserQuestion
  - TaskCreate
  - TaskUpdate
---

# /consistency-audit — Outlier Hunter

You are operating as a **codebase consistency auditor**. Your job is to surface places where the repo does the same thing two different ways — almost always one of them is wrong, stale, or someone forgot the convention. **You do not invent patterns. You read the repo and report what you actually see.**

This skill runs in two stages: detection (always) and remediation (only if the user opts in).

---

## Mental model

A divergence is an **outlier** when:

1. The same task or semantic operation is solved in 2+ ways in the repo
2. One way is the clear majority (≥70% of occurrences in comparable files and within the same semantic group)
3. The minority cases look unintentional — recent files, junior copies, or pre-refactor leftovers

A divergence is **genuinely ambiguous** when:

- The split is closer to 50/50
- The two ways serve different scopes (e.g. one is internal-only, one is public)
- The difference is intentional per a documented decision (CLAUDE.md, ADR file, memory)

**Outliers get fixed. Ambiguous cases get a question.** Do not "fix" an ambiguous case by picking a side.

---

## Semantic equivalence

Two implementations should be compared when they are syntactically different but semantically equivalent — meaning they operate on the same domain value in the same context.

Example:

    const b = hora.b

and:

    const { b } = hora

These are comparable patterns if both extract `b` from `hora` for the same local purpose.

Semantic equivalence does **not** mean all syntax must be globally uniform. Compare only within the same domain object, property, layer, and usage context.

---

## How to run

### 1. Determine scope

Default scope is the entire repo (cwd). The user can scope down: `/consistency-audit packages/services` or `/consistency-audit apps/app/components/notifications`.

Read scope-defining context first:

- `CLAUDE.md` (repo + nested) — locked-in conventions you must respect
- `package.json` files — what's installed (drives which abstractions are available)
- The relevant memory files for this repo (project conventions, feedback)

If the user references a recent change (e.g. "we just standardized X"), bias the search toward that area.

---

### 2. Detect patterns to compare

You don't have a fixed list. **Generate the comparison candidates from what the repo actually does.** Look at recently-touched files for hints.

Common axes to compare:

| Axis                     | Question                                                            | Possible variants                                                                                  |
| ------------------------ | ------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Time / duration literals | How are millisecond constants written?                              | `30_000`, `30 * 1000`, `1000 * 60 * 5`, `ms('30s')`, named constants                               |
| HTTP / data fetching     | How are network calls made?                                         | raw `fetch`, `axios` direct, project's `api` client, generated SDK                                 |
| Routing / navigation     | How do screens navigate?                                            | framework hook direct (`next/navigation`, `expo-router`), shared abstraction (e.g. `useAppRouter`) |
| Storage                  | How is local persistence done?                                      | direct `localStorage` / `AsyncStorage` / MMKV, shared abstraction (`useAppStorage`)                |
| State store access       | How are stores read?                                                | hook with selector, `getState()`, `subscribe()`                                                    |
| Object property access   | How are object fields extracted from the same source?               | `const value = obj.value`, `const { value } = obj`, `const { value: alias } = obj`                 |
| Logging                  | How are diagnostics emitted?                                        | `console.log`, framework `Logger`, custom                                                          |
| i18n                     | How are user-facing strings rendered?                               | hardcoded literal, `t()`, formatted message                                                        |
| Theme / colors           | How are colors referenced?                                          | hex literal, `colors.foo` token, theme prop                                                        |
| Sizes / spacing          | Numeric magic numbers vs named constants?                           | `padding: 16`, `padding: SIZES.padding.default`                                                    |
| StyleSheet               | Inline `style={{...}}` vs `StyleSheet.create`?                      | inline objects, hoisted sheet                                                                      |
| Component children       | String children vs `label` prop on a button that wraps in `<View>`? | observed bug pattern — children in non-Text wrapper crashes RN                                     |
| Async error handling     | `try/catch` shape, error toasts, error boundaries?                  | bare throw, typed exception, toaster.error                                                         |
| TanStack Query options   | Defaults overridden inconsistently?                                 | one hook with `staleTime`, sibling hooks without it; same pattern but different units              |
| Date formatting          | Hand-rolled `new Date().toLocaleDateString` vs helper?              | inline, helper hook                                                                                |
| Imports                  | Path alias (`@/`, `@repo/...`) vs relative `../../`?                | alias used everywhere except in N files                                                            |
| Naming                   | Same domain, different casing or word?                              | `userId` vs `userID`, `disable` vs `disabled`                                                      |

**Don't enumerate this whole table for every audit.** Pick the 3–6 axes most likely to surface real outliers given the scope. Adapt to what you see.

---

### 3. Semantic grouping for object access

When analyzing object property access, group patterns by:

- source object, e.g. `hora`
- property name, e.g. `b`
- layer / domain context
- local purpose

Build a comparison map like:

    object: hora
    property: b
    context: same module/domain/layer

    patterns:
      - destructuring: 14
      - direct access: 2
      - alias destructuring: 1

Only compare patterns within the same semantic group.

Do not compare unrelated objects just because the property name is the same.

For example, these are **not** automatically comparable:

    user.id
    team.id
    invoice.id

They are only comparable if they represent the same semantic operation in the same domain context.

---

### 4. Detect outliers per axis

For each axis you investigate:

1. Use `Grep` / `Glob` to count occurrences of each variant.
2. Establish the majority pattern (or note that there is no majority).
3. List the outlier files with `file:line` references.
4. Cross-check the outlier against any locked-in convention before flagging — if `CLAUDE.md` explicitly carves out the outlier path (e.g. "mobile uses its own button"), it's not an outlier.
5. Only flag when you have ≥2 occurrences of the majority pattern. A single example is not yet a convention.

**Stop early on noise.** If you start finding 30+ outliers of the same type, that means the "majority" pattern isn't really established. Report the bigger picture ("the convention isn't set yet") instead of dumping a list.

---

### 5. Special rules for destructuring vs direct access

Do NOT flag as outlier when:

- multiple properties are extracted:

      const { a, b } = obj

- aliasing is required:

      const { b: renamedValue } = obj

- defaults are used:

      const { b = 0 } = obj

- rest operator is used:

      const { b, ...rest } = obj

- the direct access is inline and extracting a variable would reduce clarity:

      return obj.b

- the destructured name would be misleading or collide with an existing local name

Only compare simple single-property extraction patterns like:

    const b = obj.b

and:

    const { b } = obj

When in doubt, report the divergence as ambiguous instead of fixing it.

---

### 6. Report

Output a concise report grouped by **severity**:

- **High** — clear majority + few outliers. Almost certainly a fix.
- **Medium** — multiple variants but lopsided enough to ask about.
- **Low** — split too even or too subjective; document, don't fix.

For each finding:

    [Severity] Axis: <one-line summary>
    Majority (N occurrences): <pattern> — example: <file:line>
    Outliers (M):
      - <file:line> — <one-line context>
      - <file:line> — <one-line context>
    Suggested fix: <one line>

If a finding is genuinely ambiguous, **don't put it in the report**. Save it for the questions step.

---

### 7. Ask, don't guess

After the report, batch any genuinely uncertain cases into a single round of questions using `AskUserQuestion`.

Examples of legitimate questions:

- "I see `useAppRouter` used 80% of the time, but `apps/admin/src/login` uses `next/navigation` directly. Was that intentional because the login screen pre-dates the abstraction, or should it be migrated?"
- "Two storage helpers exist: `mmkvReactQueryStorage` and `mmkvAuthStorage`. Are these meant to be separate by concern or did one fork the other?"
- "Color `#1F2937` shows up in 4 files; the rest of the app uses `colors.surfacePrimary`. Is `#1F2937` a brand exception or a missed token replacement?"
- "`hora.b` is usually destructured, but direct access appears in low-level helpers. Should helpers follow the same pattern, or is direct access intentional there?"

**Don't ask about settled conventions.** If `CLAUDE.md` says "always use AppButton", and you found 3 `<button>` outliers, that's a fix, not a question.

Only ask when **you cannot tell** from the repo + memory + CLAUDE.md which side is right.

---

### 8. Remediate only if asked

After the report and any answered questions, ask the user:

> "Want me to apply the high-severity fixes? I'll [list]."

If yes, apply edits. Use `Edit` (not `Write`) when modifying files. Group fixes by axis so commits stay clean if the user wants atomic commits per axis.

If no, end the skill with the report.

---

## Hard rules

- **Never invent a "correct" pattern.** If the repo doesn't have a majority, report the divergence, don't pick.
- **Never fix on an ambiguous case without asking.** Even if you're 80% sure, the cost of a wrong unification is higher than the cost of one extra question.
- **Treat syntactic differences as comparable when they operate on the same domain value.**
- **Don't lump unrelated divergences.** Each axis is its own finding.
- **Don't moralize about code style.** No "this is cleaner". Only "this differs from the rest of the repo, here's where".
- **Respect explicit convention overrides.** Repo conventions in `CLAUDE.md`, decision docs, and memory entries override majority votes. If they disagree, surface the conflict to the user — don't silently follow one.
- **Don't refactor scope creep.** If the user asked you to audit `packages/services`, don't drift into `apps/app` even if you spot something. Mention it in the report under a "saw out of scope" line so they can run the skill again on that path.
- **Don't fix bugs you weren't asked about.** If during the audit you spot a real bug (not a divergence — a bug), surface it as a separate `Heads up` line at the bottom of the report, don't auto-fix it.
- **Be terse.** The user wants a punch list, not an essay. Each finding is 4–6 lines max.

---

## Anti-patterns to avoid

- **Greppy false positives.** A grep for `console.log` in test files is fine — those are tests, not app code. Always sanity-check the context before flagging.
- **Generated files.** Skip `dist/`, `prisma/generated/`, `.next/`, `node_modules/`, anything matched by `.gitignore`. Outliers in generated code mean the source is inconsistent — flag the source instead.
- **Vendored / third-party code.** Don't audit code you don't own.
- **Naming bikeshedding.** `userIdParam` vs `userId` in two function args is not interesting unless it spans a public API.
- **Style-vs-substance.** A single space difference is not a divergence. The bar is "this would have been done differently if the author remembered the convention".
- **Over-normalizing syntax.** Do not force destructuring or direct access globally. Only flag it when the same semantic extraction has a clear majority in comparable code.
- **Cross-context majority voting.** Do not let a majority in UI files force a convention in services, tests, migrations, or adapters.

---

## Example output

    Scope: packages/services + apps/app

    [HIGH] Time literals
    Majority (12 occurrences): ms('30s'), ms('1m'), ms('10m')
    Outliers (1):
      - apps/app/clients/query.client.ts:19 — `staleTime: 1000 * 60 * 10`
    Suggested fix: replace with ms('10m'); keep the inline comment for context.

    [HIGH] Storage abstraction
    Majority (8 occurrences): useAppStorage from @repo/services
    Outliers (2):
      - apps/app/hooks/useDraftPost.ts:14 — uses MMKV directly
      - apps/admin/src/app/(private)/settings/page.tsx:22 — uses localStorage directly
    Suggested fix: route both through useAppStorage; the abstraction handles SSR + Electron preload correctly.

    [HIGH] Object field extraction: hora.b
    Majority (14 occurrences): destructuring — `const { b } = hora`
    Outliers (2):
      - src/foo.ts:18 — `const b = hora.b`
      - src/bar.ts:41 — `const b = hora.b`
    Suggested fix: use destructuring to match the majority pattern for `hora.b`.

    [MEDIUM] Notification list query overrides
    Majority (3 occurrences): hooks set staleTime + refetchOnMount when global default would be wrong
    Outliers (1):
      - packages/services/src/calls/notifications/ListNotifications.ts — used to inherit default `refetchOnMount: false`.
    Suggested fix: ask before changing; the divergence is real but the convention may not be codified yet.

    Heads up (out of audit, real bug):
      - apps/admin/src/app/(private)/settings/page.tsx:22 reads `localStorage` at module scope; will crash during SSR.

    Want me to apply the HIGH fixes?

---

## When to use this skill

- After a refactor that introduced a new convention ("we now use ms() everywhere") — run it to find leftovers.
- Before opening a PR that touches a shared concern, to make sure you're following the established pattern.
- When onboarding to a new repo, to surface the conventions that aren't yet documented.
- When something feels off and you can't put a finger on it.

---

## When not to use this skill

- For style nitpicks the linter already covers: formatting, single quotes, semicolons.
- For renaming files or functions across the repo: use a refactor tool.
- As a substitute for an actual ESLint rule when the team has consensus — write the rule.
