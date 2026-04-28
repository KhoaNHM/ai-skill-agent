# AI Skill Agent Workflow

A model-agnostic library of **agents, rules, skills, and memory templates** for AI-assisted software development. Works with Claude Code, Cursor, GPT, Gemini, or any agent that can read markdown.

## How it works

Every coding task follows a five-phase lifecycle enforced by rules and agent personas:

```
Phase 0 — Requirements  →  BA Strategist agent
Phase 1 — Design        →  Architect agent       (human approves before any code)
Phase 2 — Implement     →  Engineer agent
Phase 3 — Review        →  QA / Security agent
Phase 4 — Ship          →  PR creation + merge
```

Between phases, agents write to `.ai/memory/` in the project — plain markdown files any model can read.

## Directory structure

```
agents/          Phase-tagged agent personas (00–03)
rules/           Always-active rules loaded into the AI context
skills/          Reusable skills organized by workflow phase
memory-templates/ Blank templates for project .ai/memory/ setup
```

## Quick start

1. Copy the `agents/`, `rules/`, and `skills/` directories into your AI tool's config location.
2. For each new project, run the `tooling/init-memory` skill to create `.ai/memory/`.
3. Start with `agents/00-ba-strategist.md` for any new feature.

## Skills by phase

| Phase | Skills |
|-------|--------|
| 0 · Requirements | `gather-requirements`, `write-requirements-memory` |
| 1 · Design | `system-design`, `api-design`, `write-adr`, `change-impact` |
| 2 · Implement | `tdd`, `clean-code`, `split-to-prs` |
| 3 · Review | `security-review`, `qa-checklist` |
| 4 · Ship | `pr-ship`, `babysit` |
| Tooling | `init-memory`, `canvas`, `shell`, `create-skill`, `create-rule` |

## Rules

| File | Purpose |
|------|---------|
| `00-lifecycle.mdc` | Master phase gate and agent sequence |
| `01-plan-before-code.mdc` | Block implementation without approved plan |
| `02-coding-standards.mdc` | SOLID, DRY, TypeScript, MongoDB, API design |
| `03-security-baseline.mdc` | Auth, input validation, secrets, OWASP |
| `04-memory-protocol.mdc` | When and what every agent reads and writes |

## Memory system

Each project gets a `.ai/memory/` directory with:

```
.ai/memory/
├── INDEX.md                     ← always read first
├── context/requirements.md      ← BA output
├── architecture/api-contracts.md ← Architect output
├── architecture/decisions/       ← ADRs
├── handoffs/                     ← phase-to-phase notes
└── patterns/                     ← solutions and anti-patterns
```

Run `tooling/init-memory` to bootstrap it. Any AI model can then read and write to the same memory.