# Implementation Plan — AI Skill Agent Workflow Reorganization + Memory Layer

> **For the implementing agent:** This document is fully self-contained. Read it completely before touching any file. Every step specifies exactly what to do and what to write. Execute steps in order — they are NOT independent (later steps depend on earlier ones).

---

## Context

This repo (`d:/AI/ai-skill-agenst`) is a library of **agents, rules, and skills** for AI-assisted software development. It is used with Cursor IDE and Claude Code but must remain model-agnostic.

**Two goals:**
1. Reorganize the directory structure into a clear phase-gated workflow (Phase 0 → 1 → 2 → 3 → 4)
2. Add a file-based memory system so any agent or model can share context across sessions and handoffs

---

## Note on file content blocks in this document

File content blocks in this plan use **4-backtick fences** (` ```` `) as the outer delimiter so that inner ` ``` ` blocks inside the file content do not accidentally close the outer fence. Always copy content between the opening ` ````markdown ` and its matching closing ` ```` ` — not between any inner ` ``` ` pairs.

---

## Note on `→` in filenames

Handoff filenames use the `→` character (Unicode U+2192), e.g. `ba→architect.md`. This works on macOS, Linux, and Windows NTFS. If your tool rejects this character, substitute `ba-to-architect.md`, `architect-to-engineer.md`, `engineer-to-qa.md` throughout — use it consistently; never mix the two styles in the same project.

---

## Current State (read before touching anything)

```
ai-skill-agenst/
├── agents/
│   ├── ARCHITECT_AGENT.md
│   ├── ENGINEER_AGENT.md
│   ├── BA_STRATEGIST_AGENT.md
│   └── QA_SECURITY_AGENT.md
├── rules/
│   ├── ai-agent-workflow.mdc
│   ├── agents-first-gate.mdc
│   └── global-rules.md
├── skills/
│   ├── tdd/SKILL.md
│   ├── ai-playbook/SKILL.md
│   ├── change-impact-analysis/SKILL.md
│   ├── clean-code/SKILL.md
│   └── concise-best-answer/SKILL.md
└── skills-cursor/
    ├── .cursor-managed-skills-manifest.json
    ├── .sync-manifest.json
    ├── shell/SKILL.md
    ├── create-skill/SKILL.md
    ├── create-subagent/SKILL.md
    ├── create-rule/SKILL.md
    ├── migrate-to-skills/SKILL.md
    ├── babysit/SKILL.md
    ├── update-cursor-settings/SKILL.md
    ├── statusline/SKILL.md
    ├── create-hook/SKILL.md
    ├── update-cli-config/SKILL.md
    ├── split-to-prs/SKILL.md
    └── canvas/SKILL.md + sdk/
```

---

## Target State

```
ai-skill-agenst/
├── agents/
│   ├── 00-ba-strategist.md          ← new file (replaces BA_STRATEGIST_AGENT.md)
│   ├── 01-architect.md              ← new file (replaces ARCHITECT_AGENT.md)
│   ├── 02-engineer.md               ← new file (replaces ENGINEER_AGENT.md)
│   └── 03-qa-security.md            ← new file (replaces QA_SECURITY_AGENT.md)
├── rules/
│   ├── 00-lifecycle.mdc             ← new (replaces ai-agent-workflow.mdc)
│   ├── 01-plan-before-code.mdc      ← new (replaces agents-first-gate.mdc)
│   ├── 02-coding-standards.mdc      ← new (extracted from global-rules.md §1–6,8,10–12)
│   ├── 03-security-baseline.mdc     ← new (extracted from global-rules.md §7,9,13)
│   └── 04-memory-protocol.mdc       ← new
├── skills/
│   ├── phase-0-requirements/
│   │   ├── gather-requirements/SKILL.md       ← new
│   │   └── write-requirements-memory/SKILL.md ← new
│   ├── phase-1-design/
│   │   ├── system-design/SKILL.md             ← new
│   │   ├── api-design/SKILL.md                ← new
│   │   ├── write-adr/SKILL.md                 ← new
│   │   └── change-impact/SKILL.md             ← moved from skills/change-impact-analysis/
│   ├── phase-2-implement/
│   │   ├── tdd/SKILL.md                       ← moved from skills/tdd/
│   │   ├── clean-code/SKILL.md                ← moved from skills/clean-code/
│   │   └── split-to-prs/SKILL.md              ← moved from skills-cursor/split-to-prs/
│   ├── phase-3-review/
│   │   ├── security-review/SKILL.md           ← new
│   │   └── qa-checklist/SKILL.md              ← new
│   ├── phase-4-ship/
│   │   ├── pr-ship/SKILL.md                   ← new
│   │   └── babysit/SKILL.md                   ← moved from skills-cursor/babysit/
│   └── tooling/
│       ├── init-memory/SKILL.md               ← new
│       ├── canvas/SKILL.md + sdk/             ← moved from skills-cursor/canvas/
│       ├── shell/SKILL.md                     ← moved from skills-cursor/shell/
│       ├── create-skill/SKILL.md              ← moved from skills-cursor/create-skill/
│       ├── create-subagent/SKILL.md           ← moved from skills-cursor/create-subagent/
│       ├── create-rule/SKILL.md               ← moved from skills-cursor/create-rule/
│       ├── migrate-to-skills/SKILL.md         ← moved from skills-cursor/migrate-to-skills/
│       └── ide/
│           ├── update-cursor-settings/SKILL.md ← moved
│           ├── statusline/SKILL.md             ← moved
│           ├── create-hook/SKILL.md            ← moved
│           └── update-cli-config/SKILL.md      ← moved
└── memory-templates/                           ← new directory
    ├── INDEX.md.template
    ├── requirements.md.template
    ├── adr.md.template
    ├── handoff.md.template
    └── patterns.md.template
```

**Files to delete (all deletions happen in Step 11 — do not delete anything before then):**
- `rules/ai-agent-workflow.mdc`
- `rules/agents-first-gate.mdc`
- `rules/global-rules.md`
- `skills/ai-playbook/` (entire directory)
- `skills/concise-best-answer/` (entire directory)
- `skills-cursor/` (entire directory — all content moved in Step 6)
- `agents/ARCHITECT_AGENT.md`, `agents/ENGINEER_AGENT.md`, `agents/BA_STRATEGIST_AGENT.md`, `agents/QA_SECURITY_AGENT.md`

---

## Implementation Steps

Execute steps in this order. Steps 4, 5, 7, 8, 9 can run in parallel with each other but must all complete before Step 11. Step 6 must run after the source files still exist (before Step 11).

---

### STEP 1 — Create new agent files

Create these four files with the exact content below. The old agent files (`ARCHITECT_AGENT.md`, etc.) remain untouched until Step 11.

---

**File: `agents/00-ba-strategist.md`**

````markdown
---
name: BA_STRATEGIST
phase: 0
model: inherit
---

# Phase 0 — Business Analyst / Strategist

Invoke at the start of any task where requirements are ambiguous, acceptance criteria are missing, or the task touches auth, data isolation, or external integrations. Skip for clear, well-scoped tasks.

## Memory — read first

1. Read `.ai/memory/INDEX.md` (always)
2. Read `.ai/memory/patterns/anti-patterns.md` (avoid repeat mistakes)

## Core Skills

- Ambiguity resolution: identify missing acceptance criteria and edge cases before any planning.
- User story engineering: Given / When / Then acceptance criteria.
- Edge case discovery: failure paths, auth edge cases, data isolation edge cases, empty states.

## Responsibilities

1. Convert vague requirements into clear, numbered, testable acceptance criteria.
2. Identify happy path, edge cases, and error scenarios to seed the Architect and QA agents.
3. Flag any requirement touching data isolation, security-sensitive operations, or external integrations — these need explicit AC before planning.
4. Write output to `.ai/memory/context/requirements.md`.
5. Write handoff to `.ai/memory/handoffs/ba→architect.md`.
6. Update `.ai/memory/INDEX.md` Phase 0 status → ✅ Complete.

## Output format

```
### BA Review — Phase 0
**User story:** As a [actor], I want to [action] so that [value].

**Acceptance criteria:**
1. AC-01: [testable criterion]
2. AC-02: [testable criterion]

**Edge cases:**
- [edge case 1]
- [edge case 2]

**Ambiguity flags (need human decision):**
- [ ] [question + options]

**Status:** ready-for-architect | blocked-on-[reason]
```

## Skills to use

- `phase-0-requirements/gather-requirements`
- `phase-0-requirements/write-requirements-memory`

## References

Fill in per project:
- Next agent: `agents/01-architect.md`
- API contracts: `{PROJECT_LLD}`
- Security rules: `rules/03-security-baseline.mdc`
- Memory protocol: `rules/04-memory-protocol.mdc`
````

---

**File: `agents/01-architect.md`**

````markdown
---
name: ARCHITECT
phase: 1
model: inherit
---

# Phase 1 — System Architect

Invoke after Phase 0 is complete and requirements are approved. Always run for new features, new endpoints, schema changes, new modules, or cross-cutting concerns. Skip for bug fixes that don't change structure.

## Memory — read first

1. Read `.ai/memory/INDEX.md` (always)
2. Read `.ai/memory/context/requirements.md`
3. Read `.ai/memory/handoffs/ba→architect.md`
4. Read `.ai/memory/patterns/anti-patterns.md`

## Core Skills

- Module boundaries and dependency injection patterns.
- Database design: schema, index strategy, query safety, tenant/scope isolation.
- API shape: REST conventions, consistent response contracts, DTO and Swagger alignment.
- Separation of concerns: pure helpers vs I/O services, layering, cross-cutting concerns.

## Responsibilities

1. Produce a complete implementation plan (file list, ordered steps, verification).
2. Review plans for module structure, DI correctness, and layering.
3. Validate data-access safety: destructive operations blocked, tenant/scope isolation enforced, query bounds set.
4. Ensure new endpoints follow API conventions and align with LLD / API docs.
5. Create an ADR for each significant architectural decision.
6. Write architecture output to `.ai/memory/architecture/`.
7. Update `.ai/memory/context/tech-stack.md` with any new technology decisions and rationale.
8. Write handoff to `.ai/memory/handoffs/architect→engineer.md`.
9. Present plan to human — **do not proceed to Phase 2 without explicit human approval**.
10. Update `.ai/memory/INDEX.md` Phase 1 status → ✅ Complete after approval.

## Output format

```
### Architect Review — Phase 1
**Verdict:** go | revise | block

**Plan:**
1. [step]
2. [step]

**Files affected:**
- create: [path]
- edit: [path]
- delete: [path]

**Module/DI notes:** [notes]
**DB notes:** [schema, indexes, safety]
**API notes:** [endpoint, DTO, response shape]
**ADRs written:** [list]
**Risks:** [what could go wrong]

**Awaiting human approval before Phase 2.**
```

## Skills to use

- `phase-1-design/system-design`
- `phase-1-design/api-design`
- `phase-1-design/write-adr`
- `phase-1-design/change-impact`

## References

Fill in per project:
- Workflow: `rules/00-lifecycle.mdc`
- Coding standards: `rules/02-coding-standards.mdc`
- Security: `rules/03-security-baseline.mdc`
- Memory protocol: `rules/04-memory-protocol.mdc`
- API truth: `{PROJECT_LLD}`
````

---

**File: `agents/02-engineer.md`**

````markdown
---
name: ENGINEER
phase: 2
model: inherit
---

# Phase 2 — Senior Lead Developer

Invoke only after Phase 1 plan has explicit human approval. Read the approved plan from memory before writing a single line of code.

## Memory — read first

1. Read `.ai/memory/INDEX.md` (always)
2. Read `.ai/memory/handoffs/architect→engineer.md` (the approved plan)
3. Read `.ai/memory/patterns/anti-patterns.md` (prevent repeat mistakes)
4. Read `.ai/memory/architecture/api-contracts.md` (API truth)

## Core Skills

- Framework-level: controllers, services, dependency injection, module patterns.
- Database: query design, tenant-scoped data access, raw connection execution where needed.
- TypeScript: strict types, class-validator DTOs, Swagger decorators.
- Project conventions: pure helpers vs I/O services, consistent response shape, DTO validation patterns.

## Responsibilities

1. Implement the approved plan only — no scope expansion.
2. Apply the **pre-implementation gate** before writing code:
   - DTOs and Swagger decorators defined?
   - Docs sync needed if API changes?
   - Pure helper vs service split respected?
   - Safety validation (input, scope, destructive ops) in place?
   - Response shape matches convention?
3. Run validation loop: lint → typecheck/build → tests. Loop back on any failure.
4. Write new patterns and pitfalls discovered to `.ai/memory/patterns/`.
5. Write handoff to `.ai/memory/handoffs/engineer→qa.md`.
6. Update `.ai/memory/INDEX.md` Phase 2 status → ✅ Complete.

## Output format

```
### Engineer — Phase 2 Complete
**Implemented:** [summary of what was built]
**Files changed:** [list]
**Validation:** lint ✅ | typecheck ✅ | tests ✅
**New patterns logged:** [yes/no — what]
**New anti-patterns logged:** [yes/no — what]
**Handoff written:** .ai/memory/handoffs/engineer→qa.md
```

## Skills to use

- `phase-2-implement/tdd`
- `phase-2-implement/clean-code`
- `phase-2-implement/split-to-prs`

## References

Fill in per project:
- Coding standards: `rules/02-coding-standards.mdc`
- Security: `rules/03-security-baseline.mdc`
- Memory protocol: `rules/04-memory-protocol.mdc`
- Mistakes to avoid: `.ai/memory/patterns/anti-patterns.md`
- API truth: `{PROJECT_LLD}`
````

---

**File: `agents/03-qa-security.md`**

````markdown
---
name: QA_SECURITY
phase: 3
model: inherit
---

# Phase 3 — QA and Security Reviewer

Invoke after Phase 2 is complete. Always run — no exceptions. Block merging until verdict is `go`.

## Memory — read first

1. Read `.ai/memory/INDEX.md` (always)
2. Read `.ai/memory/context/requirements.md` (acceptance criteria to verify)
3. Read `.ai/memory/handoffs/engineer→qa.md` (what was built)
4. Read `.ai/memory/architecture/api-contracts.md` (expected API shape)

## Core Skills

- Unit and integration testing: co-located specs, pure helper testing, service mocks.
- Security review: input validation, data isolation, destructive operation guards, allowlist enforcement.
- Edge case analysis: error contracts, pagination bounds, invalid IDs, empty inputs, cross-tenant access.

## Responsibilities

1. Map each acceptance criterion (AC-01, AC-02, ...) to a passing test or manual verification step.
2. Identify security risks: destructive operations, cross-scope data access, unbounded queries, missing isolation filters.
3. Verify API shape matches contract in `.ai/memory/architecture/api-contracts.md`.
4. Append security findings to `.ai/memory/patterns/anti-patterns.md`.
5. Update `.ai/memory/INDEX.md` Phase 3 status → ✅ Complete (if go) or 🔄 Revise (if revise/block).

## Output format

```
### QA Lead Review — Phase 3
**Verdict:** go | revise | block

**AC Coverage:**
- AC-01: ✅ covered by [test name / manual step]
- AC-02: ❌ missing — [what is needed]

**Security checklist:**
- [ ] Input validation on all user-supplied fields
- [ ] Scope/tenant filter on every DB query
- [ ] Destructive operations guarded
- [ ] No secrets or internals in error responses
- [ ] Auth enforced on endpoint

**Blocking issues:** (if any)
- [issue] — citation: rules/03-security-baseline.mdc §[section]

**Non-blocking notes:** (if any)
- [note]
```

## Skills to use

- `phase-3-review/qa-checklist`
- `phase-3-review/security-review`

## References

- Acceptance criteria: `.ai/memory/context/requirements.md`
- Security rules: `rules/03-security-baseline.mdc`
- Memory protocol: `rules/04-memory-protocol.mdc`
````

---

### STEP 2 — Create new rules files

Create all five files below. Do NOT delete old rule files yet — that happens in Step 11.

> **Token cost note:** `02-coding-standards.mdc` and `03-security-baseline.mdc` are ~100 lines each. `alwaysApply: true` loads them for every file edit. For Cursor users who want to reduce context usage, change these to `alwaysApply: false` and add `globs: ["**/*.ts", "**/*.js"]`. The other three rules are short enough to always apply.

---

**File: `rules/00-lifecycle.mdc`**

````markdown
---
description: Master workflow lifecycle — phase gates, agent sequence, and memory checkpoints for every coding task
alwaysApply: true
---

# Master Workflow Lifecycle

Every coding task follows this sequence. Do not skip phases or gates.

## Flow

```
START
  ↓
[Phase 0] BA Strategist — Requirements & Acceptance Criteria
  Gate: requirements.md written, human has seen it
  ↓
[Phase 1] Architect — System Design & API Contracts
  Gate: plan written, human approves before any code
  ↓
[Phase 2] Engineer — Implementation
  Gate: lint + typecheck + tests all pass
  ↓
[Phase 3] QA / Security — Review & Validation
  Gate: all AC covered, verdict is "go"
  ↓
[Phase 4] Ship — PR creation & merge checklist
  ↓
DONE
```

## Phase 0 — Requirements

**When:** Requirements are ambiguous, AC are missing, task touches auth/data-isolation/external integrations.
**Skip when:** Task is clear, small, and well-scoped.

**Produces:**
- `.ai/memory/context/requirements.md` — user story, numbered AC, edge cases
- `.ai/memory/handoffs/ba→architect.md` — summary for Architect

**Agent:** `agents/00-ba-strategist.md`
**Skill:** `phase-0-requirements/gather-requirements`

## Phase 1 — Architecture

**When:** New features, new endpoints, schema changes, new modules, cross-cutting concerns.
**Skip for:** Bug fixes in existing code that don't change structure or APIs.

**Produces:**
- `.ai/memory/architecture/module-map.md`
- `.ai/memory/architecture/api-contracts.md`
- `.ai/memory/architecture/decisions/NNN-[name].md` (one ADR per significant decision)
- `.ai/memory/context/tech-stack.md` (updated with new technology decisions)
- `.ai/memory/handoffs/architect→engineer.md`

**Gate: Human must explicitly approve the plan before Phase 2 begins.**

**Agent:** `agents/01-architect.md`
**Skills:** `phase-1-design/system-design`, `phase-1-design/api-design`, `phase-1-design/write-adr`

## Phase 2 — Implementation

**Precondition:** Phase 1 approved. Read `.ai/memory/handoffs/architect→engineer.md` first.

**Rules:**
- Implement the approved plan only — zero scope expansion.
- Pre-implementation gate: DTOs/Swagger, docs sync, pure vs service split, safety validation, response shape.
- Validation loop: lint → typecheck/build → tests. Loop on any failure.
- Write new patterns and pitfalls to `.ai/memory/patterns/` during implementation.

**Agent:** `agents/02-engineer.md`
**Skills:** `phase-2-implement/tdd`, `phase-2-implement/clean-code`

## Phase 3 — Review

**Always run. No exceptions.**

**Produces:**
- QA verdict: `go | revise | block`
- Each AC mapped to a test or manual verification
- Security checklist result
- Findings appended to `.ai/memory/patterns/anti-patterns.md`

**Agent:** `agents/03-qa-security.md`
**Skills:** `phase-3-review/qa-checklist`, `phase-3-review/security-review`

## Phase 4 — Ship

**Precondition:** Phase 3 verdict is `go`.

**Skills:** `phase-4-ship/pr-ship`, `phase-4-ship/babysit`

## Continuous improvement

After every implementation:
1. Append pitfalls to `.ai/memory/patterns/anti-patterns.md`
2. Append solutions to `.ai/memory/patterns/solutions.md`
3. Update `.ai/memory/INDEX.md` phase status table
````

---

**File: `rules/01-plan-before-code.mdc`**

````markdown
---
description: Block source file edits until a written plan exists and has explicit human approval
alwaysApply: true
---

# Plan-Before-Code Gate

## Rule

Do not write, edit, or delete production source files until a written plan exists and has been explicitly approved by the human.

## What counts as a plan

A valid plan must contain all five:

1. **Goal** — one sentence: what changes and why.
2. **Files affected** — list of files to create, edit, or delete with paths.
3. **Steps** — numbered, ordered, specific (not "update the service" — name the method and what it does).
4. **Verification** — how to confirm correctness: lint command, typecheck command, test command, manual check steps.
5. **Risks** — what could go wrong and the mitigation.

## When to always plan

- Task is 3 or more steps
- Task touches a public API, shared module, database schema, auth, or cross-cutting concern
- Scope is unclear or involves a new pattern

## How to get approval

1. Output the plan.
2. Stop. Wait for the human to say "approved", "go", "looks good", or equivalent affirmative.
3. Only then begin implementation.
4. If implementation diverges from the approved plan: stop, state the divergence explicitly, get re-approval before continuing.

## Exceptions (no plan needed)

- Typo fixes or comment-only edits
- Fixing lint/typecheck errors introduced in the same session
- Human explicitly says "skip plan" or "just do it"

## On broken code

If the implementation is going wrong: **stop and revert**. Do not layer fixes on top of broken code. Refine the plan and re-implement from scratch — this is faster and cleaner than fix-on-fix.
````

---

**File: `rules/02-coding-standards.mdc`**

````markdown
---
description: Coding standards — MongoDB, TypeScript, functions, SOLID, performance, DRY/YAGNI/KISS, API design, design patterns, context efficiency
alwaysApply: true
---

# Coding Standards

## Git policy

Never push code unless the user explicitly requests it. Commit locally when asked; wait for an explicit "push" instruction before running `git push`.

## Request format

For every non-trivial request, first output a short JSON spec, then execute it:

```json
{
  "intent": "one-line goal",
  "context": { "project": "", "filesOrArea": "", "relevantRules": [], "relevantSkills": [] },
  "constraints": [],
  "expectedOutput": ""
}
```

Skip the JSON only for pure acknowledgments ("ok", "thanks"). Any code/docs/planning change → JSON first.

## MongoDB

**Indexes:** Single-field for hot filters; compound for multiple fields (leading fields matter). Unique / TTL / sparse as needed. Verify with `.explain("executionStats")`. Never index two or more array fields in a compound index.

**Queries (F-P-S-L):** Filter → Project → Sort → Limit. Filter first; project only needed fields; sort on indexed fields; always limit/skip for pagination. Use `$match` → `$group` → `$sort` in aggregations. Avoid `$where` / JavaScript execution.

**Schema:** Embed when read together and small/stable; reference when one-to-many or data grows. Avoid deep nesting; use proper types; don't let arrays grow unbounded; one naming convention (e.g. `camelCase`).

## Functions

- **Document every function:** JSDoc with `@param` / `@returns` for public or non-obvious APIs.
- **Prefer pure:** Same inputs → same output, no side effects. Keep I/O (DB, HTTP) in a thin layer.
- **Keep functions small:** One task per function, ~20–30 lines. If it validates + fetches + transforms, split into named steps.

## TypeScript

- Explicit return types; no `any` (use `unknown` or concrete types); `const` over `let`.
- Early returns over deep nesting; `?.` and `??`; descriptive names (verbs for functions, nouns for variables).
- Performance: cache `arr.length` in loops; Map/Set for lookups; `for`/`for-of` in tight loops.
- Always run `npx tsc --noEmit` (or the project's build script) before marking work done.
- Match existing import style (aliases vs relative); respect `tsconfig` `baseUrl` / `paths`.

## SOLID

- **S** — One class/module, one reason to change.
- **O** — Open for extension, closed for modification; prefer composition/DI over growing switch chains.
- **L** — Subtypes substitutable for base; don't break contracts.
- **I** — Small, role-specific interfaces; clients don't depend on unused methods.
- **D** — Depend on abstractions; inject dependencies for swappability.

**Code smells reference:**

| Smell | Symptom | Direction |
|-------|---------|-----------|
| Rigidity | Small change forces many edits | Loosen coupling |
| Fragility | Change breaks unrelated code | Stabilize boundaries |
| Immobility | Hard to reuse | Extract shared pieces |
| Viscosity | Wrong thing is easier than right thing | Templates, clear APIs |
| Needless complexity | Abstraction without payoff | KISS |
| Needless repetition | Same logic copied | DRY |
| Opacity | Hard to read intent | Names, structure, small functions |

## Performance

- **Before coding:** Is this a hot path? Does it scale with data/traffic? N+1 risk?
- **While coding:** Batch over per-item; cache lookups (Map/Set); paginate; index filters/sorts.
- **Trade-off:** Correctness and clarity first; then optimize. Document when choosing simplicity over speed.

## DRY, YAGNI, KISS

- **DRY:** One place per logic; extract helpers/modules; no copy-paste.
- **YAGNI:** Build only what's needed now; skip speculative features.
- **KISS:** Simplest solution that works; clarity over cleverness.

## API Design (REST)

- **Design-first:** Clarify consumer, use cases, and constraints before coding; validate with request/response examples.
- **Resources:** Plural nouns (`/users`); stateless requests.
- **Verbs:** GET read, POST create, PUT/PATCH update, DELETE remove.
- **Status codes:** 200, 201, 400, 401, 403, 404, 409, 500.
- **Docs:** OpenAPI/Swagger; document all params, responses, and errors; keep in sync with code.
- **Versioning:** URL or header versioning; never break existing consumers without a new version.

## Design Patterns

Apply when a pattern clearly solves a recurring problem. Don't apply speculatively.

- **Repository** — abstract data access
- **Factory** — complex or conditional creation
- **Strategy** — interchangeable algorithms
- **Dependency Injection** — inversion of control
- **Adapter** — integrate external APIs
- **Template Method** — shared algorithm, varying steps

Introduce a named pattern on the **third** clear repetition, not the first. Always add a short comment naming the pattern when you use one.

## Context Efficiency

- Search before read: use grep/semantic search to find relevant lines before opening full files.
- Minimal context: only pull in files and sections directly relevant to the task.
- Progressive disclosure: start with signatures and summaries; read full implementations only when needed.
- Diff-first reviews: read `git diff` before reading entire files.

## Validation Loop

Implement → lint → typecheck (`tsc --noEmit`) → tests → fix → repeat until clean. Do not commit while lint or typecheck fails.
````

---

**File: `rules/03-security-baseline.mdc`**

````markdown
---
description: Security baseline — auth, input validation, error handling, secrets, observability, CTO threat model
alwaysApply: true
---

# Security Baseline

## Auth

- Use short-lived tokens (e.g. JWT), least privilege, secure refresh flow.
- Never log or expose secrets, tokens, or credentials.
- Every endpoint accepting user input is an attack surface.
- Validate scope/tenant on every authenticated request — auth checks identity, not intent.

## Input Validation

- Validate and sanitize all user-supplied inputs at the DTO/controller boundary.
- Allowlist over blocklist: explicitly permit known-safe values.
- Reject early: don't let invalid data reach the service or DB layer.
- Limit length, format, and type; use parameterized queries (never string-concatenated queries).

## Error Handling

- Log full detail server-side with context (path, method, request ID).
- Return generic, safe messages to clients — no stack traces, no internals, no field names that reveal schema.
- Use framework HTTP exception types (e.g. `NotFoundException`, `BadRequestException`) for consistent status codes.
- Prefer a global exception filter to normalize error shape and log centrally.

## Observability

- Structured logs (JSON); configurable levels (log, error, warn, debug).
- Include request / correlation ID in every log entry for tracing.
- Categorize: client errors (4xx), server errors (5xx), third-party/timeouts.
- For external I/O: retries with backoff and circuit breakers to prevent cascade failures.

## Secrets

- No secrets in code or version control.
- Use env vars or a vault; document required vars in `.env.example`.
- Validate required env vars at startup; fail fast if missing.
- Rotate keys periodically.

## Transport

- HTTPS only.
- Rate limiting and CORS for public APIs.

## CTO Threat Model

Before writing or approving any code, ask three questions:

1. **What can go wrong?** — Edge cases, invalid input, partial failures.
2. **Who can abuse this?** — Untrusted callers, tenant boundary violations, destructive payloads.
3. **Does it scale?** — Data growth, traffic spikes, N+1 queries, unbounded loops.

**Blast-radius gate:**

| If a bug causes... | Required guard |
|--------------------|----------------|
| Data loss / mutation | Input validation + allowlist + integration test |
| Cross-tenant data leak | Tenant-prefix enforcement + ownership check |
| Unbounded cost (CPU / memory) | Pagination, limit, timeout, or circuit breaker |
| Service downtime | Graceful degradation, retry with backoff, alerting |

**Common rationalizations — never accept these:**

| Excuse | Reality |
|--------|---------|
| "It's internal only" | Internal APIs get exposed; least-privilege still applies |
| "We'll optimize later" | "Later" rarely arrives; add a limit now |
| "Auth already protects this" | Auth checks identity, not intent |
| "Nobody would send that" | Attackers send exactly what you don't expect |
| "It's just a read query" | `$merge`, `$out`, `$lookup` into system collections are not reads |
````

---

**File: `rules/04-memory-protocol.mdc`**

````markdown
---
description: Memory protocol — when and what every agent reads from and writes to .ai/memory/ at each phase
alwaysApply: true
---

# Memory Protocol

Every agent reads and writes to `.ai/memory/` in the project being worked on. Memory is plain markdown — any AI model or human can read and write it.

## Start of every session

1. Check if `.ai/memory/` exists in the project.
   - If not: run `tooling/init-memory` skill to create it.
2. Read `.ai/memory/INDEX.md` — always, before any other action.
3. Read the handoff file for your current phase (listed in INDEX.md under "Current Handoff").
4. Read `.ai/memory/patterns/anti-patterns.md` — prevent repeat mistakes.

## Memory file format

Every file in `.ai/memory/` uses this frontmatter:

```
---
type: context | architecture | handoff | pattern | adr
phase: 0-ba | 1-architect | 2-engineer | 3-qa | any
last-updated: YYYY-MM-DD
updated-by: BA_AGENT | ARCHITECT_AGENT | ENGINEER_AGENT | QA_AGENT | human
status: draft | active | superseded
---

# Title

## Summary
One paragraph — readable without opening full details.

## Details
[full content]

## Open Questions
- [ ] [question the next phase must resolve]

## References
- [related file](../relative/path.md)
```

## Phase write responsibilities

### Phase 0 (BA) writes:
- `.ai/memory/context/requirements.md` — user story, numbered AC, edge cases, non-functional reqs
- `.ai/memory/context/non-functional.md` — performance, scale, security constraints
- `.ai/memory/handoffs/ba→architect.md` — what BA produced, what Architect needs, open questions

### Phase 1 (Architect) writes:
- `.ai/memory/architecture/module-map.md` — module boundaries, DI, layer diagram
- `.ai/memory/architecture/api-contracts.md` — endpoint, DTOs, request/response shapes, status codes
- `.ai/memory/architecture/decisions/NNN-[decision-name].md` — one ADR per significant decision
- `.ai/memory/context/tech-stack.md` — technology choices and rationale for the feature
- `.ai/memory/handoffs/architect→engineer.md` — approved plan with file list, steps, verification

### Phase 2 (Engineer) writes:
- `.ai/memory/patterns/solutions.md` — append any reusable approach discovered
- `.ai/memory/patterns/anti-patterns.md` — append any pitfall hit
- `.ai/memory/handoffs/engineer→qa.md` — what was built, test entry points, known edge cases

### Phase 3 (QA/Security) writes:
- `.ai/memory/patterns/anti-patterns.md` — append security/quality findings
- Updates `.ai/memory/INDEX.md` Phase 3 status

## INDEX.md structure

Keep INDEX.md up to date after each phase completes. This is the map — every agent starts here.

```
# Memory Index — [Project Name]

> Read this first. Load only files relevant to your current phase.

## Phase Status
| Phase | Status | Owner | Last Updated |
|-------|--------|-------|--------------|
| 0 · Requirements | ⏳ Pending | BA_AGENT | — |
| 1 · Architecture | ⏳ Pending | ARCHITECT_AGENT | — |
| 2 · Implementation | ⏳ Pending | ENGINEER_AGENT | — |
| 3 · QA / Review | ⏳ Pending | QA_AGENT | — |
| 4 · Ship | ⏳ Pending | — | — |

## Active Context
- [Requirements](context/requirements.md) — [one-line summary or "not yet written"]
- [Tech Stack](context/tech-stack.md) — [one-line summary or "not yet written"]
- [Non-functional](context/non-functional.md) — [one-line summary or "not yet written"]

## Architecture
- [Module Map](architecture/module-map.md)
- [API Contracts](architecture/api-contracts.md)
- ADRs: (list links as written)

## Current Handoff
→ [Phase N handoff file](handoffs/x→y.md) — [status]

## Patterns
- [Solutions](patterns/solutions.md)
- [Anti-patterns](patterns/anti-patterns.md)
```

## Rules for writing to memory

1. **Never overwrite** — always append to patterns files (solutions.md, anti-patterns.md).
2. **Update frontmatter** — always set `last-updated` and `updated-by` when editing a file.
3. **Update INDEX.md** — after writing any file, add or update its link and the phase status row.
4. **Keep Summary scannable** — the next agent should understand the file in 10 seconds from the Summary alone.
5. **Archive superseded decisions** — set `status: superseded` and link the replacement ADR; never delete.
````

---

### STEP 3 — Create new skills: phase-0-requirements

---

**File: `skills/phase-0-requirements/gather-requirements/SKILL.md`**

````markdown
---
name: gather-requirements
description: BA interview template — elicit user stories, acceptance criteria, edge cases, and non-functional requirements before any planning begins.
---

# Gather Requirements

Use when requirements are ambiguous, acceptance criteria are missing, or the task touches auth, data isolation, or external integrations.

## Memory — read first

1. `.ai/memory/INDEX.md`
2. `.ai/memory/patterns/anti-patterns.md`

## Interview process

### Step 1 — Core user story

Ask and answer:
- Who is the actor? (user role, service, external system)
- What do they want to do?
- What value do they get?

Format: **As a [actor], I want to [action] so that [value].**

### Step 2 — Acceptance criteria

Write one numbered AC per distinct behavior. Each must be:
- **Testable** — has a clear pass/fail condition
- **Specific** — names fields, status codes, error messages
- **Independent** — does not assume another AC passed

Template:

```
AC-01: Given [precondition], when [action], then [expected result].
AC-02: Given [precondition], when [action], then [expected result].
```

### Step 3 — Edge case checklist

Work through each:
- [ ] Empty input / zero records
- [ ] Invalid format or type
- [ ] Missing required field
- [ ] Unauthorized access attempt
- [ ] Concurrent modification
- [ ] Cross-tenant / cross-scope access attempt
- [ ] External service unavailable
- [ ] Partial failure (some items succeed, some fail)
- [ ] First page / last page / empty page (pagination)
- [ ] Maximum allowed value
- [ ] Duplicate submission

### Step 4 — Non-functional requirements

- **Performance:** Acceptable p99 response time? Record volume?
- **Security:** Who can call this endpoint? What data is returned?
- **Scale:** Concurrent users? Table size in 1 year?
- **Availability:** Is downtime acceptable during deployment?

### Step 5 — Ambiguity flags

List anything needing a human decision before planning can begin:
- [ ] [Question] — Option A vs Option B

## Output

After completing the interview:

1. Write to `.ai/memory/context/requirements.md` using the `write-requirements-memory` skill
2. Write to `.ai/memory/handoffs/ba→architect.md`
3. Update `.ai/memory/INDEX.md`:
   - Phase 0 status → ✅ Complete
   - Add link to requirements.md with one-line summary
   - Update Current Handoff → BA → Architect
4. Present to human for review before handing off to Architect
````

---

**File: `skills/phase-0-requirements/write-requirements-memory/SKILL.md`**

````markdown
---
name: write-requirements-memory
description: Write BA output to .ai/memory/context/requirements.md and the ba→architect handoff file using the correct memory format.
---

# Write Requirements Memory

Use at the end of Phase 0 to persist requirements to memory.

## File 1 — Write to `.ai/memory/context/requirements.md`

```
---
type: context
phase: 0-ba
last-updated: YYYY-MM-DD
updated-by: BA_AGENT
status: active
---

# Requirements — [Feature Name]

## Summary
[One paragraph: what is being built, for whom, and why.]

## User Story
As a [actor], I want to [action] so that [value].

## Acceptance Criteria
- AC-01: Given [precondition], when [action], then [result].
- AC-02: Given [precondition], when [action], then [result].

## Edge Cases
- [edge case 1]
- [edge case 2]

## Non-Functional Requirements
- Performance: [requirement]
- Security: [requirement]
- Scale: [requirement]

## Open Questions
- [ ] [question — needs decision before Architect starts]

## References
- Handoff: [ba→architect.md](../handoffs/ba→architect.md)
```

## File 2 — Write to `.ai/memory/handoffs/ba→architect.md`

```
---
type: handoff
phase: 0-ba
last-updated: YYYY-MM-DD
updated-by: BA_AGENT
status: active
---

# Handoff: BA → Architect

## Summary
Phase 0 complete. Requirements documented. Architect can begin system design.

## What the Architect needs to know
- [key constraint 1]
- [key constraint 2]
- [security or isolation requirement]

## Acceptance criteria count
[N] ACs defined in requirements.md. Each must be traceable to a test in Phase 3.

## Open questions for Architect
- [ ] [question]

## References
- [requirements.md](../context/requirements.md)
```

## Update INDEX.md

In `.ai/memory/INDEX.md`, apply these three changes:

1. Change Phase 0 row: `| 0 · Requirements | ✅ Complete | BA_AGENT | YYYY-MM-DD |`
2. Update Active Context: `- [Requirements](context/requirements.md) — [one-line summary]`
3. Update Current Handoff: `→ [BA → Architect](handoffs/ba→architect.md) — ready for Phase 1`
````

---

### STEP 4 — Create new skills: phase-1-design

---

**File: `skills/phase-1-design/system-design/SKILL.md`**

````markdown
---
name: system-design
description: Architecture planning template — module boundaries, DI, database schema, query safety, and layering before implementation.
---

# System Design

Use to produce the architecture plan for a new feature or significant change.

## Memory — read first

1. `.ai/memory/INDEX.md`
2. `.ai/memory/context/requirements.md`
3. `.ai/memory/handoffs/ba→architect.md`
4. `.ai/memory/patterns/anti-patterns.md`

## Design checklist

### 1. Module boundaries
- [ ] Which module owns this feature?
- [ ] New module or extend existing?
- [ ] Dependencies: what does it import? What imports it?
- [ ] No circular dependencies introduced?

### 2. Dependency injection
- [ ] New services declared as providers?
- [ ] All dependencies injected, not instantiated directly?
- [ ] Testable in isolation (deps can be mocked)?

### 3. Database
- [ ] New collection or extension of existing?
- [ ] Schema: field names, types, required vs optional, defaults
- [ ] Indexes: which fields are filtered/sorted?
- [ ] Scope/tenant filter on every query?
- [ ] Destructive operations guarded?
- [ ] Migration backwards-compatible?

### 4. API shape
- [ ] Endpoint: METHOD /resource (plural noun, matches existing pattern)
- [ ] Request DTO: fields, types, validation rules, Swagger decorators
- [ ] Response: shape, status codes (success + each error case)
- [ ] Error messages: consistent with project convention

### 5. Separation of concerns
- [ ] Business logic in service, not controller
- [ ] DB access in repository or data service, not business service
- [ ] Pure helpers separated from I/O services

### 6. Cross-cutting concerns
- [ ] Auth: who can call this?
- [ ] Logging: what events need logging?
- [ ] Error handling: which exceptions, what messages?
- [ ] Rate limiting needed?

## Output

1. Write to `.ai/memory/architecture/module-map.md`
2. Write to `.ai/memory/architecture/api-contracts.md` (or use `api-design` skill)
3. Update `.ai/memory/context/tech-stack.md` with any new technology decisions
4. Run `phase-1-design/write-adr` for each significant decision
5. Write to `.ai/memory/handoffs/architect→engineer.md`
6. Update INDEX.md Phase 1 status and Current Handoff
7. Present plan to human — **wait for explicit approval before any code**
````

---

**File: `skills/phase-1-design/api-design/SKILL.md`**

````markdown
---
name: api-design
description: Contract-first API design — endpoint definition, DTO spec, response shape, status codes, and Swagger alignment before any implementation.
---

# API Design

Use before writing any controller, service, or DTO code. Design the contract first; implement second.

## Memory — read first

1. `.ai/memory/context/requirements.md` — acceptance criteria drive the API shape
2. `.ai/memory/architecture/api-contracts.md` — existing contracts to stay consistent with

## Contract-first process

### Step 1 — Identify consumers and use cases

- Who calls this endpoint? (frontend, mobile, another service, external partner)
- What do they send? What do they expect back?
- What errors do they need to handle?

### Step 2 — Define the endpoint

```
METHOD /resource[/:id][/sub-resource]
```

- Method: GET (read), POST (create), PUT (full replace), PATCH (partial update), DELETE (remove)
- Path: plural noun, no verbs, consistent with existing routes
- Auth: required? which roles?

### Step 3 — Request specification

```
Headers:
  Authorization: Bearer <token>    (if auth required)
  Content-Type: application/json   (for POST/PUT/PATCH)

Path params:
  :id  — type, validation rule

Query params:
  page    — number, default 1
  limit   — number, max 100, default 20
  [filter] — type, allowed values

Body (POST/PUT/PATCH):
  {
    "fieldName": type,   // required | optional — validation rule
  }
```

### Step 4 — Response specification

```
Success:
  Status: 200 | 201
  Body: {
    "data": { ... },
    "meta": { "total": number, "page": number, "limit": number }
  }

Errors:
  400: { "message": "validation error detail" }
  401: { "message": "Unauthorized" }
  403: { "message": "Forbidden" }
  404: { "message": "[Resource] not found" }
  409: { "message": "[conflict reason]" }
  500: { "message": "Internal server error" }
```

### Step 5 — Validate the contract

- Does every AC from requirements.md map to a response case?
- Is the shape consistent with existing endpoints?
- Are all error paths documented?

## Output

Append to `.ai/memory/architecture/api-contracts.md`:

```
---
type: architecture
phase: 1-architect
last-updated: YYYY-MM-DD
updated-by: ARCHITECT_AGENT
status: active
---

# API Contracts — [Feature Name]

## [Endpoint Name]

**Route:** `METHOD /path`
**Auth:** required / public / role: [role]

**Request:**
[spec from Step 3]

**Response:**
[spec from Step 4]
```
````

---

**File: `skills/phase-1-design/write-adr/SKILL.md`**

````markdown
---
name: write-adr
description: Architecture Decision Record template — document significant design choices with context, options considered, and rationale.
---

# Write Architecture Decision Record (ADR)

Use whenever a significant, non-obvious architectural decision is made. One ADR per decision.

## When to write an ADR

- Choosing between two or more viable approaches
- Departing from the project's established pattern
- Introducing a new dependency or technology
- Making a decision that will be expensive to reverse

## Numbering

Find the highest existing NNN in `.ai/memory/architecture/decisions/` and increment by 1.
Start at 001 if no ADRs exist yet.

## Write to `.ai/memory/architecture/decisions/NNN-[short-name].md`

```
---
type: adr
phase: 1-architect
last-updated: YYYY-MM-DD
updated-by: ARCHITECT_AGENT
status: active
---

# ADR-NNN — [Decision Title]

## Status
Accepted | Proposed | Superseded by ADR-NNN

## Context
[What is the situation requiring a decision? What constraints exist?
What forces are at play — performance, security, team conventions, deadlines?]

## Options Considered

### Option A — [Name]
[Description]
- Pro: [advantage]
- Con: [disadvantage]

### Option B — [Name]
[Description]
- Pro: [advantage]
- Con: [disadvantage]

## Decision
[Which option was chosen and the single most important reason.]

## Consequences
- [What becomes easier]
- [What becomes harder]
- [What must be done next because of this decision]

## References
- [requirements.md](../context/requirements.md)
- [Related ADR](./NNN-related.md)
```

## After writing

Add the ADR link to `.ai/memory/INDEX.md` under the Architecture section:

```
- ADR-NNN: [Decision Title](architecture/decisions/NNN-short-name.md)
```
````

---

### STEP 5 — Move existing skills to new locations

For each row below: read the source file exactly as-is and write its content to the destination path. Create the destination directory if it does not exist. Do not rewrite or edit the content.

| Source | Destination |
|--------|-------------|
| `skills/tdd/SKILL.md` | `skills/phase-2-implement/tdd/SKILL.md` |
| `skills/clean-code/SKILL.md` | `skills/phase-2-implement/clean-code/SKILL.md` |
| `skills/change-impact-analysis/SKILL.md` | `skills/phase-1-design/change-impact/SKILL.md` |
| `skills-cursor/split-to-prs/SKILL.md` | `skills/phase-2-implement/split-to-prs/SKILL.md` |
| `skills-cursor/babysit/SKILL.md` | `skills/phase-4-ship/babysit/SKILL.md` |
| `skills-cursor/shell/SKILL.md` | `skills/tooling/shell/SKILL.md` |
| `skills-cursor/create-skill/SKILL.md` | `skills/tooling/create-skill/SKILL.md` |
| `skills-cursor/create-subagent/SKILL.md` | `skills/tooling/create-subagent/SKILL.md` |
| `skills-cursor/create-rule/SKILL.md` | `skills/tooling/create-rule/SKILL.md` |
| `skills-cursor/migrate-to-skills/SKILL.md` | `skills/tooling/migrate-to-skills/SKILL.md` |
| `skills-cursor/update-cursor-settings/SKILL.md` | `skills/tooling/ide/update-cursor-settings/SKILL.md` |
| `skills-cursor/statusline/SKILL.md` | `skills/tooling/ide/statusline/SKILL.md` |
| `skills-cursor/create-hook/SKILL.md` | `skills/tooling/ide/create-hook/SKILL.md` |
| `skills-cursor/update-cli-config/SKILL.md` | `skills/tooling/ide/update-cli-config/SKILL.md` |
| `skills-cursor/canvas/SKILL.md` | `skills/tooling/canvas/SKILL.md` |

**SDK directory — copy entire folder tree:**
Copy `skills-cursor/canvas/sdk/` → `skills/tooling/canvas/sdk/` (preserves all `.d.ts` files inside it).

---

### STEP 6 — Create new skills: phase-3-review

---

**File: `skills/phase-3-review/security-review/SKILL.md`**

````markdown
---
name: security-review
description: Security review checklist — input validation, auth enforcement, data isolation, secrets, error handling, and common vulnerabilities for each changed file.
---

# Security Review

Run on every implementation before marking Phase 3 complete.

## Memory — read first

1. `.ai/memory/handoffs/engineer→qa.md`
2. `.ai/memory/architecture/api-contracts.md`
3. `.ai/memory/patterns/anti-patterns.md`

## Review checklist

### Authentication & authorization
- [ ] Every endpoint has an auth guard (no accidental public exposure)
- [ ] Role/permission checked, not just identity
- [ ] Tenant/scope filter applied on every DB query that returns data

### Input validation
- [ ] All user-supplied fields validated at DTO/controller boundary
- [ ] Field types, lengths, and formats enforced
- [ ] No raw user input in DB queries, shell commands, or template strings
- [ ] Allowlist used where possible (not blocklist)

### Data exposure
- [ ] Response does not include sensitive fields (passwords, tokens, internal IDs)
- [ ] Error messages don't reveal schema, stack traces, or implementation details
- [ ] Pagination applied to list endpoints (no unbounded result sets)

### Destructive operations
- [ ] DELETE / bulk-update guarded with explicit ownership check
- [ ] No cascade delete without intentional design
- [ ] Soft delete used where data recovery may be needed

### Secrets & configuration
- [ ] No secrets hardcoded in source
- [ ] No secrets in logs
- [ ] Required env vars validated at startup

### Dependency safety
- [ ] No new dependencies added without review
- [ ] Third-party libraries not called with unsanitized user data

### Common vulnerabilities
- [ ] NoSQL injection: no string-concatenated queries; use parameterized or ORM methods
- [ ] XSS: API returns data, not HTML; output encoding applied in frontend
- [ ] CSRF: state-changing operations use POST/PUT/PATCH/DELETE, not GET
- [ ] Mass assignment: DTO explicitly whitelists accepted fields (no `...body` spread)

## Output

```
### Security Review Result
**Verdict:** go | revise | block

**Findings:**
- [CRITICAL] [finding] — must fix before ship
- [HIGH] [finding] — should fix before ship
- [LOW] [finding] — can track as tech debt

**Cleared:** [N] / [total] checklist items passed
```

Append any new findings to `.ai/memory/patterns/anti-patterns.md`.
````

---

**File: `skills/phase-3-review/qa-checklist/SKILL.md`**

````markdown
---
name: qa-checklist
description: QA review — map each acceptance criterion to a test or manual verification, check coverage, and validate the implementation matches the API contract.
---

# QA Checklist

Use to verify implementation completeness against requirements before marking Phase 3 complete.

## Memory — read first

1. `.ai/memory/context/requirements.md` — acceptance criteria to verify
2. `.ai/memory/handoffs/engineer→qa.md` — what was built and where tests are
3. `.ai/memory/architecture/api-contracts.md` — expected API shape

## AC coverage mapping

For each acceptance criterion in `requirements.md`, record:

| AC | Test / Verification | Status |
|----|---------------------|--------|
| AC-01 | [test name or manual step] | ✅ / ❌ |
| AC-02 | [test name or manual step] | ✅ / ❌ |

Every AC must have either:
- An automated test that fails if the behavior regresses, OR
- A documented manual verification step with exact inputs and expected outputs

## Test quality check

- [ ] Tests use Arrange / Act / Assert structure
- [ ] Test names describe the behavior, not the implementation
- [ ] No test modifies another test's state (tests are isolated)
- [ ] No test relies on a specific record ID or external state
- [ ] Edge cases from requirements.md have corresponding tests

## API contract verification

Compare the implementation against `.ai/memory/architecture/api-contracts.md`:
- [ ] Route method and path match exactly
- [ ] Request DTO fields and validation rules match
- [ ] Response shape matches (field names, types, nesting)
- [ ] All documented status codes are reachable
- [ ] Error messages match the documented format

## Regression check

- [ ] Existing tests still pass (no regressions introduced)
- [ ] Any test that was changed: was the change justified and approved?

## Output

```
### QA Review Result
**Verdict:** go | revise | block

**AC Coverage:**
- AC-01: ✅ [test-name]
- AC-02: ❌ missing — needs: [what]

**Contract match:** ✅ matches / ❌ [difference]
**Regression status:** ✅ all passing / ❌ [failing test name]

**Blocking:** [list items with rule citations]
**Non-blocking:** [list notes]
```

Update `.ai/memory/INDEX.md` Phase 3 status after verdict is determined.
````

---

### STEP 7 — Create new skills: phase-4-ship

---

**File: `skills/phase-4-ship/pr-ship/SKILL.md`**

````markdown
---
name: pr-ship
description: PR creation checklist — title, body template, CI gate verification, and merge safety check before pushing.
---

# PR Ship

Use when Phase 3 verdict is `go` and the implementation is ready to merge.

## Pre-push checklist

- [ ] Phase 3 verdict is explicitly `go`
- [ ] All CI checks pass locally: lint, typecheck, tests
- [ ] No `console.log`, debug breakpoints, or `TODO: remove` comments in the diff
- [ ] No secrets, tokens, or credentials in the diff
- [ ] API docs (Swagger) updated if endpoints changed
- [ ] `.ai/memory/INDEX.md` phase status rows are all up to date

## Branch naming

```
[type]/[short-description]

type: feat | fix | refactor | chore | docs | test
example: feat/user-export-csv
```

## PR title

```
[type]: [imperative verb] [what changed]

Good: feat: add CSV export to user report endpoint
Bad:  fixed the export thing / working on export
```

## PR body template

```
## Summary
- [bullet: what changed]
- [bullet: why]

## Acceptance criteria
- AC-01: ✅ [test or manual verification]
- AC-02: ✅ [test or manual verification]

## Changes
- path/to/file.ts — [what changed]
- path/to/file.spec.ts — [tests added]

## Testing
[How to test manually: exact steps, example request/response]

## Screenshots / examples
[If UI or API response changed, include before/after]

## Notes
[Trade-offs, follow-up tickets, known limitations]
```

## After PR created

Update `.ai/memory/INDEX.md` Phase 4 status → ✅ Complete.
````

---

### STEP 8 — Create tooling/init-memory skill

---

**File: `skills/tooling/init-memory/SKILL.md`**

````markdown
---
name: init-memory
description: Bootstrap .ai/memory/ in any project — creates the full directory structure with blank placeholder files ready for agents to populate.
---

# Init Memory

Run once per project before Phase 0 begins. Creates `.ai/memory/` in the **project being worked on** — not in this skills repo.

## Directory structure to create

```
.ai/
└── memory/
    ├── INDEX.md
    ├── context/
    │   ├── requirements.md
    │   ├── tech-stack.md
    │   └── non-functional.md
    ├── architecture/
    │   ├── module-map.md
    │   ├── api-contracts.md
    │   └── decisions/
    │       └── .gitkeep
    ├── handoffs/
    │   ├── ba→architect.md
    │   ├── architect→engineer.md
    │   └── engineer→qa.md
    └── patterns/
        ├── solutions.md
        └── anti-patterns.md
```

## Write `.ai/memory/INDEX.md` with this content

```
# Memory Index — [Project Name]

> Read this first. Load only files relevant to your current phase.

## Phase Status
| Phase | Status | Owner | Last Updated |
|-------|--------|-------|--------------|
| 0 · Requirements | ⏳ Pending | BA_AGENT | — |
| 1 · Architecture | ⏳ Pending | ARCHITECT_AGENT | — |
| 2 · Implementation | ⏳ Pending | ENGINEER_AGENT | — |
| 3 · QA / Review | ⏳ Pending | QA_AGENT | — |
| 4 · Ship | ⏳ Pending | — | — |

## Active Context
- [Requirements](context/requirements.md) — not yet written
- [Tech Stack](context/tech-stack.md) — not yet written
- [Non-functional](context/non-functional.md) — not yet written

## Architecture
- [Module Map](architecture/module-map.md) — not yet written
- [API Contracts](architecture/api-contracts.md) — not yet written
- ADRs: none yet

## Current Handoff
→ none yet — start with Phase 0

## Patterns
- [Solutions](patterns/solutions.md)
- [Anti-patterns](patterns/anti-patterns.md)
```

## Write placeholder content for all other files

Use the table below. Each file gets the frontmatter shown plus the heading `# [Title] — not yet written` and one line: `Run [skill-name] skill to populate this file.`

| File | type | phase | Heading | Populate with skill |
|------|------|-------|---------|---------------------|
| `context/requirements.md` | context | 0-ba | Requirements | `gather-requirements` |
| `context/tech-stack.md` | context | 1-architect | Tech Stack | `system-design` |
| `context/non-functional.md` | context | 0-ba | Non-Functional Requirements | `gather-requirements` |
| `architecture/module-map.md` | architecture | 1-architect | Module Map | `system-design` |
| `architecture/api-contracts.md` | architecture | 1-architect | API Contracts | `api-design` |
| `handoffs/ba→architect.md` | handoff | 0-ba | Handoff: BA → Architect | `write-requirements-memory` |
| `handoffs/architect→engineer.md` | handoff | 1-architect | Handoff: Architect → Engineer | `system-design` |
| `handoffs/engineer→qa.md` | handoff | 2-engineer | Handoff: Engineer → QA | (written by Engineer) |
| `patterns/solutions.md` | pattern | any | Solutions | (append during Phase 2) |
| `patterns/anti-patterns.md` | pattern | any | Anti-patterns | (append during Phase 2/3) |

Each file's frontmatter:

```
---
type: [from table]
phase: [from table]
last-updated: —
updated-by: —
status: draft
---
```

## After running

Tell the user:
- `.ai/memory/` created with 11 files across 4 subdirectories
- Next step: run `phase-0-requirements/gather-requirements` to begin Phase 0

**Git recommendation:** Commit `.ai/memory/` to the project repo so architecture decisions, handoffs, and patterns are version-controlled alongside the code.
````

---

### STEP 9 — Create memory-templates directory

Create `memory-templates/` in the root of **this repo** (not a project). These are reference templates for humans — not for agents to execute.

---

**File: `memory-templates/INDEX.md.template`**

````markdown
# Memory Index — [Project Name]

> Read this first. Load only files relevant to your current phase.

## Phase Status
| Phase | Status | Owner | Last Updated |
|-------|--------|-------|--------------|
| 0 · Requirements | ⏳ Pending | BA_AGENT | — |
| 1 · Architecture | ⏳ Pending | ARCHITECT_AGENT | — |
| 2 · Implementation | ⏳ Pending | ENGINEER_AGENT | — |
| 3 · QA / Review | ⏳ Pending | QA_AGENT | — |
| 4 · Ship | ⏳ Pending | — | — |

## Active Context
- [Requirements](context/requirements.md) — not yet written
- [Tech Stack](context/tech-stack.md) — not yet written
- [Non-functional](context/non-functional.md) — not yet written

## Architecture
- [Module Map](architecture/module-map.md) — not yet written
- [API Contracts](architecture/api-contracts.md) — not yet written
- ADRs: none yet

## Current Handoff
→ none yet — start with Phase 0

## Patterns
- [Solutions](patterns/solutions.md)
- [Anti-patterns](patterns/anti-patterns.md)
````

---

**File: `memory-templates/requirements.md.template`**

````markdown
---
type: context
phase: 0-ba
last-updated: YYYY-MM-DD
updated-by: BA_AGENT
status: active
---

# Requirements — [Feature Name]

## Summary
[One paragraph: what is being built, for whom, and why.]

## User Story
As a [actor], I want to [action] so that [value].

## Acceptance Criteria
- AC-01: Given [precondition], when [action], then [result].
- AC-02: Given [precondition], when [action], then [result].

## Edge Cases
- [edge case 1]
- [edge case 2]

## Non-Functional Requirements
- Performance: [requirement]
- Security: [requirement]
- Scale: [requirement]

## Open Questions
- [ ] [question — needs decision before Architect starts]

## References
- Handoff: [ba→architect.md](../handoffs/ba→architect.md)
````

---

**File: `memory-templates/adr.md.template`**

````markdown
---
type: adr
phase: 1-architect
last-updated: YYYY-MM-DD
updated-by: ARCHITECT_AGENT
status: active
---

# ADR-NNN — [Decision Title]

## Status
Accepted | Proposed | Superseded by ADR-NNN

## Context
[What situation requires a decision? What constraints exist?]

## Options Considered

### Option A — [Name]
- Pro: [advantage]
- Con: [disadvantage]

### Option B — [Name]
- Pro: [advantage]
- Con: [disadvantage]

## Decision
[Which option and the single most important reason.]

## Consequences
- [What becomes easier]
- [What becomes harder]
- [What must be done next]

## References
- [requirements.md](../context/requirements.md)
````

---

**File: `memory-templates/handoff.md.template`**

````markdown
---
type: handoff
phase: [N]-[agent]
last-updated: YYYY-MM-DD
updated-by: [AGENT_NAME]
status: active
---

# Handoff: [From Agent] → [To Agent]

## Summary
[One sentence: what was completed and what the next agent should do.]

## What was produced
- [output 1]
- [output 2]

## What the next agent needs to know
- [key fact 1]
- [key constraint]
- [security or isolation requirement]

## Open questions for next phase
- [ ] [question]

## References
- [relevant memory file](../context/file.md)
````

---

**File: `memory-templates/patterns.md.template`**

````markdown
---
type: pattern
phase: any
last-updated: YYYY-MM-DD
updated-by: [AGENT_NAME]
status: active
---

# [Solutions | Anti-patterns] — [Project Name]

<!-- Append entries below. Never delete existing entries — add [SUPERSEDED] tag if outdated. -->

## Entry 001 — [Short title]

**Date:** YYYY-MM-DD
**Phase found:** 0-ba | 1-architect | 2-engineer | 3-qa
**Added by:** [agent name]

**Situation:** [When does this apply?]

**[What worked / What went wrong]:**
[Description]

**[Do this / Avoid this]:**
[Concrete instruction]

**Why:** [Root cause or reason]

---
````

---

### STEP 10 — Delete obsolete files

Run all deletions only after Steps 1–9 are fully complete.

**Files and directories to delete:**

```
rules/ai-agent-workflow.mdc
rules/agents-first-gate.mdc
rules/global-rules.md

skills/ai-playbook/                  (entire directory)
skills/concise-best-answer/          (entire directory)

skills-cursor/                       (entire directory — all content moved in Step 5)
  includes: .cursor-managed-skills-manifest.json
  includes: .sync-manifest.json

agents/ARCHITECT_AGENT.md
agents/ENGINEER_AGENT.md
agents/BA_STRATEGIST_AGENT.md
agents/QA_SECURITY_AGENT.md
```

> If your tool cannot delete directories, create a file named `DELETED.md` inside each directory with the content `This directory has been replaced. Safe to delete.` — a human can remove it.

---

### STEP 11 — Update README.md

Replace the entire content of `README.md` with:

````markdown
# AI Skill Agent Workflow

A model-agnostic library of **agents, rules, skills, and memory templates** for AI-assisted software development. Works with Claude Code, Cursor, GPT, Gemini, or any agent that can read markdown.

## How it works

Every coding task follows a five-phase lifecycle enforced by rules and agent personas:

```
Phase 0 — Requirements  →  BA Strategist agent
Phase 1 — Design        →  Architect agent       ← human approves before any code
Phase 2 — Implement     →  Engineer agent
Phase 3 — Review        →  QA / Security agent
Phase 4 — Ship          →  PR creation + merge
```

Between phases, agents write to `.ai/memory/` in the project — plain markdown files any model can read.

## Directory structure

```
agents/           Phase-tagged agent personas (00–03)
rules/            Always-active rules loaded into the AI context
skills/           Reusable skills organized by workflow phase
memory-templates/ Blank templates for project .ai/memory/ setup
```

## Quick start

1. Copy `agents/`, `rules/`, and `skills/` into your AI tool's config location.
2. In each new project, run the `tooling/init-memory` skill to create `.ai/memory/`.
3. Start every new feature with `agents/00-ba-strategist.md`.

## Skills by phase

| Phase | Skills |
|-------|--------|
| 0 · Requirements | `gather-requirements`, `write-requirements-memory` |
| 1 · Design | `system-design`, `api-design`, `write-adr`, `change-impact` |
| 2 · Implement | `tdd`, `clean-code`, `split-to-prs` |
| 3 · Review | `security-review`, `qa-checklist` |
| 4 · Ship | `pr-ship`, `babysit` |
| Tooling | `init-memory`, `canvas`, `shell`, `create-skill`, `create-rule`, `create-subagent` |
| Tooling / IDE | `update-cursor-settings`, `statusline`, `create-hook`, `update-cli-config` |

## Rules

| File | Purpose |
|------|---------|
| `00-lifecycle.mdc` | Master phase gate and agent sequence |
| `01-plan-before-code.mdc` | Block implementation without approved plan |
| `02-coding-standards.mdc` | SOLID, DRY, TypeScript, MongoDB, API design |
| `03-security-baseline.mdc` | Auth, input validation, secrets, OWASP |
| `04-memory-protocol.mdc` | When and what every agent reads and writes |

## Memory system

Each project gets a `.ai/memory/` directory:

```
.ai/memory/
├── INDEX.md                          ← always read first
├── context/
│   ├── requirements.md               ← BA output: user story, AC, edge cases
│   ├── tech-stack.md                 ← Architect output: technology decisions
│   └── non-functional.md             ← BA output: perf, scale, security
├── architecture/
│   ├── module-map.md                 ← Architect output: module boundaries, DI
│   ├── api-contracts.md              ← Architect output: endpoint contracts
│   └── decisions/                    ← ADRs (one file per decision)
├── handoffs/
│   ├── ba→architect.md
│   ├── architect→engineer.md
│   └── engineer→qa.md
└── patterns/
    ├── solutions.md                  ← approaches that worked
    └── anti-patterns.md              ← pitfalls to avoid
```

Run `tooling/init-memory` to bootstrap it. Commit `.ai/memory/` to the project repo so decisions are version-controlled alongside code.
````

---

## Verification Checklist

Run after all steps are complete.

### Structure

- [ ] `agents/` has exactly 4 files: `00-ba-strategist.md`, `01-architect.md`, `02-engineer.md`, `03-qa-security.md`
- [ ] `agents/` has NO files named `ARCHITECT_AGENT.md`, `ENGINEER_AGENT.md`, `BA_STRATEGIST_AGENT.md`, `QA_SECURITY_AGENT.md`
- [ ] `rules/` has exactly 5 `.mdc` files: `00-lifecycle.mdc` through `04-memory-protocol.mdc`
- [ ] `rules/` has NO files named `ai-agent-workflow.mdc`, `agents-first-gate.mdc`, `global-rules.md`
- [ ] `skills/` has exactly 6 subdirectories: `phase-0-requirements/`, `phase-1-design/`, `phase-2-implement/`, `phase-3-review/`, `phase-4-ship/`, `tooling/`
- [ ] `skills/tooling/ide/` exists with 4 skills inside
- [ ] `skills/tooling/canvas/sdk/` exists and contains `.d.ts` files
- [ ] `memory-templates/` has exactly 5 files: `INDEX.md.template`, `requirements.md.template`, `adr.md.template`, `handoff.md.template`, `patterns.md.template`
- [ ] `skills-cursor/` directory no longer exists
- [ ] `skills/ai-playbook/` no longer exists
- [ ] `skills/concise-best-answer/` no longer exists

### Content

- [ ] Each agent file has `phase:` in its YAML frontmatter
- [ ] Each agent file has a `## Memory — read first` section
- [ ] Each rule file has `alwaysApply: true` in its YAML frontmatter
- [ ] Each skill file has a `name:` and `description:` in its YAML frontmatter
- [ ] `agents/01-architect.md` Responsibility #7 mentions `tech-stack.md`
- [ ] `rules/04-memory-protocol.mdc` Phase 1 write list includes `tech-stack.md`

### Cross-references

- [ ] `rules/00-lifecycle.mdc` references `phase-0-requirements/gather-requirements` (not old path)
- [ ] `rules/00-lifecycle.mdc` Phase 1 produces list includes `tech-stack.md`
- [ ] `agents/00-ba-strategist.md` Skills to use references `phase-0-requirements/gather-requirements`
- [ ] `agents/01-architect.md` Skills to use references `phase-1-design/system-design`
- [ ] `skills/tooling/init-memory/SKILL.md` placeholder table includes `tech-stack.md` row

### Commit

- [ ] Commit all changes with message: `refactor: reorganize workflow into phase-gated structure with memory layer`
