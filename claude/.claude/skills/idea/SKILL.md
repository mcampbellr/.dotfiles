---
name: idea
description: "Idea/feature request → refined spec (20-section template) → Sonnet validation. Never implements code."
when_to_use: "When user has a new feature idea, wants to spec something out, or invokes /idea. Not for bugs (/bug) or small tweaks (/quick-win)."
argument-hint: [idea-description]
disable-model-invocation: true
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(git rev-parse *)
  - Bash(date *)
  - Bash(ls *)
  - Bash(find *)
  - Agent
  - AskUserQuestion
  - Skill
  - Write
  - Edit
---

# /idea — Spec authoring workflow

You handle `/idea [description]`. Goal: turn a raw informal idea into a **complete, validated spec** stored in this project's conventional spec location, using the canonical 20-section template at `~/.claude/skills/idea/spec-template.md`. The spec must satisfy the **Perfect Spec Checklist** (Step 6 — the 20 sections of the template) and must reference a separate `api-contract.md` whenever an API surface is involved.

You do **not** implement code in this skill. You stop after the validated spec is written.

## Canonical template

The template lives at `~/.claude/skills/idea/spec-template.md`. It defines 20 mandatory sections in a fixed order. **Read it once at the start of every `/idea` run** and use it as the authoritative skeleton for the spec you write in Step 6. Do not omit sections — if a section does not apply, keep its heading and write `No aplica — <reason>` (or `Not applicable — <reason>` in English mode).

---

## Hard rules

- **Never implement code in this skill.** Stop after the spec (and `api-contract.md` if applicable) are written and validated.
- **Do not install npm packages, do not run migrations, do not edit application code.** Only Read/Grep/Glob/Bash for research; Write/Edit only for spec files.
- **Ask until the checklist is satisfied.** No fixed cap on clarifying questions: keep asking (in batches of ≤5 via `AskUserQuestion`) until every required spec dimension can be filled with concrete content. If the user explicitly tells you to stop, mark unresolved fields as `TBD — see Open questions`.
- **Refuse to write a spec if no project convention or example can be located AND the user can't provide one.** A spec without an anchor in the project's idiom will not be accepted by the rest of the workflow.
- **Spec language follows the project, not the conversation.** Detect the language of existing specs/docs in this project (Step 2.3). If the majority are in Spanish → write the new spec in Spanish; same for any other language. **Default = English** when no existing specs/docs are found or the signal is mixed/inconclusive. The conversation with the user stays in whatever language they use, but the spec body, headings, and `api-contract.md` follow the detected project language. Slugs, file names, and git artifacts always stay in English kebab-case.
- **Never edit a nested `CLAUDE.md` without explicit user approval in chat** (per global feedback `child_claude_md_confirmation`). Reading is fine.

---

## Step 1 — Read the raw idea

- Raw description is in `$ARGUMENTS`.
- If empty/whitespace-only, ask the user (open-ended via `AskUserQuestion`) for the idea. Do not proceed without one.

Hold it as `RAW_IDEA`.

---

## Step 2 — Locate the project's spec convention and an example

Goal: figure out **where this project stores feature specs** and **what an existing spec looks like**. Without both, the new spec has no anchor.

### 2.0 Check `.project-structure` first

Before auto-detecting, look at the repo root for a `.project-structure` file (any of: `.project-structure`, `.project-structure.md`, `.project-structure.yaml`, `.project-structure.yml`, `.project-structure.json`). If present, read it and try to extract an explicit spec-location convention. Look for entries / keys / lines such as:

- `specs:` / `specs_dir:` / `spec_dir:` / `spec_path:`
- `idea_specs:` / `idea_dir:`
- `feature_specs:` / `features_dir:`
- `docs/specs`, `openspec/changes`, `.planning/phases`, `specs/`, or any other path the file names as the spec home.

If `.project-structure` explicitly declares a spec location:

- Set `SPEC_DIR_PATTERN` from that declaration (insert `<slug>` placeholder where appropriate — typically `<declared-path>/<slug>/`).
- Pick `SPEC_FILENAME` from the declaration if specified (`spec.md`, `SPEC.md`, `proposal.md`, …). If not specified, default to `spec.md`.
- Skip the rest of Step 2.1's directory search and only run 2.1 to find a real **example** spec inside `SPEC_DIR_PATTERN` (for tone / depth / frontmatter). If no example exists yet (first spec in the project), still continue — `~/.claude/skills/idea/spec-template.md` becomes the structural reference and `SPEC_EXAMPLE_BODY` is set to the empty string.

If `.project-structure` exists but does **not** explicitly name a spec location, fall through to 2.1 normally (the file is informative but not load-bearing here).

If `.project-structure` does not exist at all, fall through to 2.1, and at the end of Step 2 **ask the user** via `AskUserQuestion` whether to:

- Use the auto-detected location (recommended option).
- Use a different location they will name.
- Add the chosen location to a new `.project-structure` file so future `/idea` runs do not need to ask (offer this as an additional yes/no question only if a location is confirmed).

### 2.1 Auto-detect candidate locations

Run these globs in parallel from the repo root (CWD):

```
openspec/changes/*/proposal.md
openspec/changes/*/spec.md
openspec/changes/*/design.md
.planning/phases/*/SPEC.md
.planning/phases/*/spec.md
.planning/specs/*.md
.planning/changes/*/spec.md
docs/specs/**/*.md
docs/decisions/*.md
docs/adr/*.md
specs/**/*.md
spec/**/*.md
```

Also read, if present (use them as context, do not edit):
- Repo root `CLAUDE.md`, `AGENTS.md`, `README.md`.
- `graphify-out/GRAPH_REPORT.md`.
- Any nested `CLAUDE.md` under app/package directories (read-only).

### 2.2 Pick the convention

- **Clear convention found** (≥1 matching path with ≥1 readable example): record the directory pattern as `SPEC_DIR_PATTERN` (e.g., `openspec/changes/<slug>/`, `.planning/phases/<slug>/`, `docs/specs/<slug>/`) and pick the most recent / most representative existing file as `SPEC_EXAMPLE_PATH`. Read its full content into `SPEC_EXAMPLE_BODY`.
- **Multiple competing conventions** (e.g., both `openspec/changes/` and `.planning/phases/` exist): ask the user via `AskUserQuestion` which one applies to this idea. Default option = the one with the most recent file.
- **No convention detectable**: ask the user where specs live in this project. Offer `docs/specs/<slug>/spec.md` as the default option but **do not write anywhere without confirmation**.
- **User cannot/will not provide one**: stop with this exact message and do not write any files:

  > No encontré un spec de referencia en este proyecto y no me diste uno. Sin un ejemplo no puedo escribir el spec con el estilo correcto. Cuando tengas uno, vuelve a correr `/idea`.

Carry forward:

- `SPEC_DIR_PATTERN` — directory pattern (with `<slug>` placeholder).
- `SPEC_FILENAME` — filename used in the example (`spec.md`, `proposal.md`, `SPEC.md`, etc.). Match the project.
- `SPEC_EXAMPLE_PATH` — absolute path to the reference spec.
- `SPEC_EXAMPLE_BODY` — its full content (tone, headings, depth, frontmatter to mirror).

### 2.3 Detect the spec language

Goal: decide the language for the new spec body. **Default = English.**

1. Take a representative sample of the project's spec corpus: `SPEC_EXAMPLE_BODY` plus, if cheap to read, up to ~5 more files from the same `SPEC_DIR_PATTERN` (most recent first) and the repo root `README.md` / `docs/` index pages if they exist. Skip code blocks, frontmatter, file paths, and identifier-only tokens — only natural-language prose counts as signal.
2. Classify each sampled doc as one of: `english`, `spanish`, or another language (use obvious lexical / orthographic cues — diacritics, function words like `que / para / con / sin / pero` vs. `the / and / with / without`, section headings like `Tecnologías` / `Criterios de éxito` vs. `Technologies` / `Success criteria`). Mark as `mixed` only if a single doc genuinely interleaves languages in prose (not "English code + Spanish prose"; that is still Spanish).
3. Pick `SPEC_LANGUAGE`:
   - **Clear majority (≥60% of sampled docs in one non-English language)** → use that language.
   - **All-English sample, no-sample, or mixed/inconclusive** → `english`.
   - **Tie or near-tie between two non-English languages** → ask the user via `AskUserQuestion` which language to use; offer the two detected options plus English.
4. State the detected language and the evidence in one short line to the user before continuing (e.g., `Spec language: Spanish (4/5 sampled specs in Spanish, incl. .planning/phases/auth/SPEC.md).`). Do not ask the user to confirm if the majority is clear — only ask on ties or when overriding feels load-bearing.

Carry forward:

- `SPEC_LANGUAGE` — `english` (default), `spanish`, or other ISO-style tag. Used for the spec body, headings, and `api-contract.md` prose in Step 6 and Step 7. The conversation language with the user is independent of this.

---

## Step 3 — Detect skill mentions in the raw idea

Scan `RAW_IDEA` for `/<skill-name>` tokens or imperative mentions of other skills ("usemos X", "via X", "con /X", etc.). Classify each:

- **Planning-route** (informs *what* to build): `/biz`, `/marketing-skills:pricing-strategy`, `/marketing-skills:customer-research`, `/marketing-skills:content-strategy`, `/marketing-skills:competitor-alternatives`, `/stakeholders`, `/gsd-explore`, `/consistency-audit`, `/visual-consistency-audit`.
- **Implementation-route** (informs *how* to build): `/ui-ux-pro-max`, `/impeccable`, `/gsap-core`, `/gsap-react`, `/gsap-scrolltrigger`, `/expo:use-dom`, `/expo:expo-ui-swift-ui`, `/banana-claude:banana`, `/generate-image`, `/excalidraw`.

For each mention:

1. **Verify the skill exists** in the available-skills list. If not, one-line warning and skip.
2. **Planning-route** → invoke via the `Skill` tool BEFORE the refiner; capture output into `PRELIMINARY_ANALYSES[<skill>]`.
3. **Implementation-route** → do NOT invoke here. Record `{ skill, rationale }` into `IMPLEMENTATION_HINTS`. The spec will embed these as an "Implementation hints" section.
4. **Ambiguous route** → ask the user via `AskUserQuestion` whether to run now or defer.

Hard rule: **never invoke an implementation-route skill from `/idea`.** Even if the user mentioned it, this phase is research only.

---

## Step 4 — Refine the idea with `idea-spec-refiner` (Haiku)

Invoke the subagent via `Agent`:

- `subagent_type: "idea-spec-refiner"`
- `model: "haiku"`
- Read-only.
- Prompt must include: `RAW_IDEA`, `PRELIMINARY_ANALYSES` (if any), the absolute path `SPEC_EXAMPLE_PATH` (or `no example yet` if this is the project's first spec), the absolute path of the canonical template `~/.claude/skills/idea/spec-template.md`, and the explicit instruction that the brief must surface ambiguity **per section of the 20-section Perfect Spec Checklist** so the calling skill knows what to ask.

The refiner returns a structured brief per its agent definition. Call it `BRIEF`.

---

## Step 5 — Clarify with the user until the checklist is satisfied

Walk every dimension in the **Perfect Spec Checklist** (Step 6). For each:

- **Resolved** — the brief has concrete content (specific paths, specific versions, specific behaviors, not generic phrasing).
- **Unresolved** — ambiguity, TBD, generic phrases like "follow existing patterns" / "handle errors gracefully" without enumeration, or insufficient detail.

For unresolved dimensions, batch up to 5 questions per `AskUserQuestion` call. **No total cap.** Keep iterating in batches until every dimension is resolved, or the user tells you to stop (then mark remaining as `TBD — see Open questions`).

After each batch, fold answers back into the brief (Scope, Architecture, Files, API Contract, Edge Cases, etc.), then re-evaluate the checklist. Repeat.

Prefer single-select / multi-select options for `AskUserQuestion` when the answer space is small and known. Open-ended only when truly free-form.

---

## Step 6 — Compose the spec using the canonical 20-section template

The canonical template lives at `~/.claude/skills/idea/spec-template.md`. Read it once at the start of this run if you have not already (its content does not change between runs, but the placeholders `[...]` are the only parts you replace). Use it as the **structural source of truth**: every section heading, in the exact order, must appear in the spec you write.

### Language adaptation

Write everything (headings, prose, bullets, tables, `api-contract.md`) in `SPEC_LANGUAGE` from Step 2.3 — **default English**, Spanish only when the project's existing specs/docs are predominantly Spanish (the template ships in Spanish; canonical English headings are shown in parentheses below for reference). Mirror the tone, heading depth, bullet style, frontmatter, and any project-specific patterns from `SPEC_EXAMPLE_BODY`. Slugs, file names, code identifiers, and git artifacts always stay in English kebab-case regardless of `SPEC_LANGUAGE`.

### Required sections — the 20-section Perfect Spec Checklist

Every section is mandatory and appears in this order. If a section legitimately does not apply (e.g. no API surface), keep the heading and write `No aplica — <razón>` / `Not applicable — <reason>`. Do not silently drop sections.

1. **Objetivo** *(Goal)* — Functional description of what is being built and what user outcome it enables. No ambiguity.
2. **Alcance** *(Scope)* — Two explicit subsections: `Incluido en esta fase` (Included) and `Fuera de scope` (Out of scope). Out-of-scope is load-bearing — be exhaustive.
3. **Tecnologías y convenciones del proyecto** *(Technologies & project conventions)* — Stack, language, package manager, UI library, state management, API client, forms, validation, testing. Pinned versions cited from the project's `package.json` / `pubspec.yaml` / `go.mod` / `Cargo.toml` with the path. **Do not guess versions.** Include subsections: `Stack`, `Versiones relevantes`, `Patrones existentes a respetar`.
4. **Dependencias previas** *(Prerequisites)* — Concrete checkboxes for everything that must already exist or be completed: modules, endpoints, screens, API contract files, env vars, designs, existing types/interfaces, base services, feature flags. If any is missing, the implementer must stop and report.
5. **Arquitectura** *(Architecture)* — Pattern (BLoC / MVVM / Clean / Feature-first / Hexagonal / CQRS / etc.), affected layers (presentation / application / domain / data / shared) each marked sí/no with description, the expected flow (numbered steps from user action to UI result), and the file layout for new files.
6. **Archivos a crear o modificar** *(Files to create / modify)* — Exact list of full paths in a table (Ruta | Acción | Propósito | Ejemplo del proyecto a seguir), each `NUEVO` or `MODIFICAR`. Then a `Detalle por archivo` subsection per file with responsibilities, the existing project file to follow as a template, and what must NOT be mixed in. The example file must be a real path verifiable with Glob/Read.
7. **API Contract** — Reference the separate `api-contract.md` (next to the spec) as the single source of truth. Inline a one-paragraph summary plus the list of involved endpoints. If the change has zero API surface, write `Sin API surface — no aplica.` and skip creating `api-contract.md`.
8. **Criterios de éxito** *(Success criteria)* — Checkboxes for verifiable behaviors. Subsections: `Tests requeridos` (which test files and scenarios to add) and `Comandos de verificación` (the exact lint / typecheck / test / build commands from this project). Each criterion must be checkable.
9. **Criterios de UX** *(UX criteria)* — Exhaustive enumeration of non-obvious interface behaviors. Required subsections: `Loading`, `Formularios`, `Passwords` (if applicable), `Errores`, `Navegación`, `Accesibilidad`. Be specific — if it's not written, it won't happen.
10. **Decisiones tomadas** *(Decisions made — locked)* — Design choices that are locked. The implementer must not question or change these. Include the *why* for each so future readers understand rationale.
11. **Edge cases** — Expected behavior under: `Datos inválidos`, `API errors` (one bullet per status code: 400, 401, 403, 404, 409, 422, 429, 500), `Sin conexión`, `Timeout`, `Respuesta vacía o inesperada`, `Doble submit`. Minimum coverage is mandatory.
12. **Estados de UI requeridos** *(Required UI states)* — Table of `idle / loading / success / error / empty / disabled / offline` with what is shown and what the user can do in each.
13. **Validaciones** *(Validations)* — Subsections: `Validaciones de cliente` (table: Campo | Regla | Mensaje) and `Validaciones de servidor` (defer to `api-contract.md`, define server-error-to-field mapping).
14. **Seguridad y permisos** *(Security & permissions)* — Secret handling, sensitive payloads, permission checks, 401/403 flow.
15. **Observabilidad y logging** *(Observability & logging)* — What to log and what to never log. Use the project's existing logging mechanism (cite it).
16. **i18n / textos visibles** *(i18n / user-facing copy)* — All user-facing strings must come from the project's translation system. Table of required keys (Key | Texto). Do not hardcode strings.
17. **Performance** — Renders, repeated API calls, debouncing/cancellation, main-thread work, caching patterns.
18. **Restricciones** *(Restrictions / hard "do not" rules)* — Hard rules the implementer must not violate: API contract changes, new global abstractions, new dependencies, unrelated refactors, global style/navigation changes, undocumented APIs.
19. **Entregables** *(Deliverables)* — Final checkboxes: code, tests, translations, types/interfaces, API integration, UX states, edge cases, docs.
20. **Checklist final para el agente** *(Final agent checklist)* — Pre-delivery verification checkboxes the implementer must tick before reporting completion: read spec end-to-end, reviewed api-contract.md, confirmed prerequisites exist, modified only listed files, followed real project examples, implemented all UI states and edge cases, no unauthorized deps, no changed decisions, ran lint/typecheck/tests/build, no temporary logs, no unjustified TODOs.

If `IMPLEMENTATION_HINTS` is non-empty, append an **Implementation hints** section between section 20 and the end of the file, with one bullet per hint: `` `/<skill-name>` — <rationale> ``.

### Writing the files

- Spec file: `<SPEC_DIR_PATTERN with <slug> filled in>/<SPEC_FILENAME>` (the resolved path from Step 2). Use `Write`. Materialize **all 20 sections** in the order above, replacing every `[...]` placeholder from the template with content verified against the repo. Never leave a raw `[...]` placeholder in the final file — replace it, or write `TBD — ver Open questions` and log the question.
- API contract: when section 7 has a real API surface, also write `<SPEC_DIR_PATTERN with <slug>>/api-contract.md` containing:
  - One section per endpoint.
  - Per endpoint: HTTP method, URL, auth requirements, request body schema (or query params), success response schema with status code, error response schemas with status codes and error codes. Follow the project's existing error convention if discoverable from the codebase (cite where you found it).
  - A short "Conventions" preamble only if verified from the project's existing API code (e.g., RFC 9457 problem+json); otherwise mark each convention as `TBD — confirmar con usuario`.
- If there is no API surface, do not create `api-contract.md` and write `Sin API surface — no aplica.` inside section 7.
- If `.project-structure` did not exist at the start of the run and the user opted in (Step 2.0) to persist the chosen spec location, write/update `.project-structure` at the repo root with the convention used. Use the simplest format that fits the repo (a 2-line YAML file with `specs_dir:` and `spec_filename:` is the default). Do not modify `.project-structure` if it already existed.

---

## Step 7 — Validate the spec with `idea-spec-validator` (Sonnet)

Invoke the subagent via `Agent`:

- `subagent_type: "idea-spec-validator"`
- `model: "sonnet"`
- Read-only.
- Prompt must include: absolute path to the new spec, absolute path to `api-contract.md` (or `no aplica`), absolute path to `SPEC_EXAMPLE_PATH` (or `no example yet` if this is the project's first spec), the absolute path of the canonical template `~/.claude/skills/idea/spec-template.md`, and the **20-section Perfect Spec Checklist** verbatim from Step 6. Instruct the validator to **challenge** vague content (e.g., "follow existing patterns" without naming them, "handle errors gracefully" without listing edge cases, missing version pins, file paths that don't exist, unreplaced `[...]` placeholders from the template).

The validator returns:

- **Verdict** — `PASS`, `PASS_WITH_WARNINGS`, or `BLOCK`.
- **Per-dimension scores** — `PASS` / `WEAK` / `MISSING` per dimension.
- **Required fixes** — items that must change for `PASS`.
- **Suggested improvements** — quality bumps, non-blocking.
- **Spec example divergences** — where the new spec departs from the project's style.

### Reacting to the verdict

- **PASS** → go to Step 8.
- **PASS_WITH_WARNINGS** → show warnings to user, ask via `AskUserQuestion`: `Address now` / `Keep as-is`. If addressed, fix and re-run the validator.
- **BLOCK** → fix the required items:
  - If a fix needs more user info, batch more clarifying questions.
  - If a fix is just rewriting for precision, do it directly.
  - Re-run the validator. **Cap re-validation at 3 cycles.** If still blocked after 3, surface the final validator report verbatim and stop.

---

## Step 8 — Summarize

Output a short summary to the user before the proposal decision in Step 9:

- Optimized change title.
- Kebab-case change name (slug).
- Absolute path to the spec file.
- Absolute path to `api-contract.md` (or `no aplica`).
- Validator verdict and any remaining warnings / open questions.

Do not implement. Do not edit application code. Continue to Step 9.

---

## Step 9 — Offer the OpenSpec proposal

After the spec is validated and the summary is shown, ask the user whether to generate the OpenSpec proposal artifacts (`proposal.md` / `design.md` / `tasks.md`) **now** using the just-written spec as input.

Use `AskUserQuestion` with these options (single-select):

- **Sí, generar el OpenSpec proposal ahora** *(Recommended)* — Invoke the `openspec-propose` skill (or `opsx:propose` if that's the variant available in this project) to create the change directory at `openspec/changes/<slug>/` with all artifacts.
- **No, dejarlo pendiente** — Mark the spec as `PENDING PROPOSAL/CHANGE` and stop.

Phrase the question in the conversation language (the language the user is using), not `SPEC_LANGUAGE`.

### 9.a — User chose "Sí"

1. Verify which OpenSpec proposal skill is available in this project (`openspec-propose` or `opsx:propose`). Prefer `openspec-propose` if both exist. If neither is available, fall through to 9.b and explain why.
2. Invoke the chosen skill via the `Skill` tool. Pass an `args` string that includes:
   - The kebab-case `<slug>`.
   - One short sentence with the change description (taken from the spec's section 1 — Objetivo / Goal).
   - The absolute path to the just-written spec so the proposal skill can read it as authoritative context.
   - The absolute path to `api-contract.md` (or `no aplica`).
3. After the proposal skill returns, output one line to the user confirming the OpenSpec change directory location and pointing to the next implementation step (`/opsx:apply <slug>` or the project's equivalent). Stop.

### 9.b — User chose "No"

1. Write a status marker at the top of the spec file (right after the H1 `# Spec: …` title, before any other content) using `Edit`. Use the language matching `SPEC_LANGUAGE`:
   - **English**: `> **Status:** PENDING PROPOSAL/CHANGE — no OpenSpec change has been generated yet. Run \`/openspec-propose\` (or \`/opsx:propose\`) using this spec as input to create the proposal/design/tasks artifacts.`
   - **Spanish**: `> **Estado:** PENDIENTE PROPOSAL/CHANGE — todavía no se generó el OpenSpec change. Ejecuta \`/openspec-propose\` (o \`/opsx:propose\`) usando este spec como input para crear proposal/design/tasks.`
2. Output one line to the user confirming the marker was added and telling them they can run `/openspec-propose` (or `/opsx:propose`) later to generate the proposal. Stop.

Do not implement application code in either branch. The proposal skill only writes OpenSpec change artifacts, not feature code.
