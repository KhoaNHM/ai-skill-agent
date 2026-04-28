---
name: init-memory
description: Bootstrap .ai/memory/ in any project — creates the full directory structure with blank template files ready for agents to fill in.
---

# Init Memory

Run once per project before any Phase 0 work begins. Creates the complete `.ai/memory/` structure.

## What to create

Create all of the following directories and files in the **project being worked on** (not in this skills repo):

### Directory structure
```
[project root]/
├── CLAUDE.md          ← Claude Code auto-loads this
├── AGENTS.md          ← OpenAI Codex / agent frameworks auto-load this
├── WINDSURF.md        ← Windsurf IDE auto-loads this
├── AI_CONTEXT.md      ← generic fallback for any model
└── .ai/
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

## File contents to write

### `.ai/memory/INDEX.md`
```markdown
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

### Entry point files — `CLAUDE.md`, `AGENTS.md`, `WINDSURF.md`, `AI_CONTEXT.md`

All four files go at the **project root** and contain identical content. Each AI tool auto-loads the filename it recognizes — no tool-specific config needed.

```markdown
# AI Memory Protocol

Read `.ai/memory/INDEX.md` FIRST at the start of every session — before any other action.

Never assume phase status or file contents from conversation history. Read the actual file.

## Memory structure
- `.ai/memory/INDEX.md` — phase status and links to all memory files
- `.ai/memory/context/` — requirements, tech stack, non-functional
- `.ai/memory/architecture/` — module map, API contracts, ADRs
- `.ai/memory/handoffs/` — phase-to-phase transfer notes
- `.ai/memory/patterns/` — solutions and anti-patterns

## Rules
1. Read INDEX.md first. State the current phase and status before doing any work.
2. After writing any memory file, read it back immediately to confirm correct content.
3. Do not report a phase complete until you have read back the updated INDEX.md.
4. Do not infer file state from conversation — read the file.
```

### All other files — placeholder table

Each file gets frontmatter + heading `# [Title] — not yet written` + one line: `Run [skill] skill to populate this file.`

| File | type | phase | Heading | Populate with skill |
|------|------|-------|---------|---------------------|
| `context/requirements.md` | context | 0-ba | Requirements | `gather-requirements` |
| `context/tech-stack.md` | context | 1-architect | Tech Stack | `system-design` |
| `context/non-functional.md` | context | 0-ba | Non-Functional Requirements | `gather-requirements` |
| `architecture/module-map.md` | architecture | 1-architect | Module Map | `system-design` |
| `architecture/api-contracts.md` | architecture | 1-architect | API Contracts | `api-design` |
| `handoffs/ba→architect.md` | handoff | 0-ba | Handoff: BA → Architect | `write-requirements-memory` |
| `handoffs/architect→engineer.md` | handoff | 1-architect | Handoff: Architect → Engineer | `system-design` |
| `handoffs/engineer→qa.md` | handoff | 2-engineer | Handoff: Engineer → QA | (written by Engineer agent) |
| `patterns/solutions.md` | pattern | any | Solutions | (append during Phase 2) |
| `patterns/anti-patterns.md` | pattern | any | Anti-patterns | (append during Phase 2/3) |

Example placeholder file content:

```
---
type: context
phase: 0-ba
last-updated: —
updated-by: —
status: draft
---

# Requirements — not yet written

Run `phase-0-requirements/gather-requirements` skill to populate this file.
```

## After running

Tell the user:
- `CLAUDE.md`, `AGENTS.md`, `WINDSURF.md`, `AI_CONTEXT.md` created at project root — any AI tool will auto-load the memory protocol on session start
- `.ai/memory/` created with 11 files across 4 subdirectories
- Next step: run `phase-0-requirements/gather-requirements` to begin Phase 0

**Git recommendation:** Commit everything to the project repo:
```
git add CLAUDE.md AGENTS.md WINDSURF.md AI_CONTEXT.md .ai/memory/
git commit -m "chore: init AI memory"
```
