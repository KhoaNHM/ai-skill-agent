# AI Project Context (Portable for Any AI)

This file explains the repository so another AI can quickly understand how to work in it safely and correctly.

## Project Purpose

`ai-skill-agenst` is a model-agnostic workflow library for AI-assisted software development.

It provides:
- phase-based delivery workflow
- enforceable rules
- agent personas
- reusable skills
- a markdown memory protocol

The goal is consistent, reviewable delivery across tools like Cursor, Claude Code, Windsurf, and other AI agents.

## Core Workflow (Phase-Gated)

All work follows this lifecycle:

1. Phase 0 - Requirements (BA Strategist)
2. Phase 1 - Design (Architect)
3. Phase 2 - Implementation (Engineer)
4. Phase 3 - QA/Security Review
5. Phase 4 - Ship

Key control points:
- Human approval is required before Phase 2 (implementation).
- Phase 3 (review) always runs.
- Phases can be skipped only when skip criteria are met, but gates in active phases cannot be skipped.

Primary source: `rules/00-lifecycle.mdc`.

## Rules (Global Behavior Controls)

Main rule files:
- `rules/00-lifecycle.mdc` - phase flow, gates, outputs, and owners
- `rules/01-plan-before-code.mdc` - no source edits before approved plan
- `rules/02-coding-standards.mdc` - implementation standards
- `rules/03-security-baseline.mdc` - security baseline
- `rules/04-memory-protocol.mdc` - read/write/verify memory behavior

Important safety behavior:
- "Revert" is explicitly non-destructive only (no hard reset / force push without human instruction).

## Agents (Role Definitions)

Agent files:
- `agents/00-ba-strategist.md`
- `agents/01-architect.md`
- `agents/02-engineer.md`
- `agents/03-qa-security.md`

Notable enforcement:
- Architect writes handoff with `approved-by:`.
- Engineer must check `approved-by: human` before coding.

## Skills (Operational Playbooks)

Skills are organized by phase and tooling:
- `skills/phase-0-requirements/`
- `skills/phase-1-design/`
- `skills/phase-2-implement/`
- `skills/phase-3-review/`
- `skills/phase-4-ship/`
- `skills/tooling/`

High-value design/review skills include:
- `skills/phase-1-design/system-design/SKILL.md`
- `skills/phase-1-design/api-design/SKILL.md`
- `skills/phase-1-design/write-adr/SKILL.md`
- `skills/phase-3-review/qa-checklist/SKILL.md`
- `skills/phase-3-review/security-review/SKILL.md`
- `skills/phase-4-ship/pr-ship/SKILL.md`

## Memory Protocol (Anti-Hallucination Backbone)

Each target project uses `.ai/memory/` as portable state.

Canonical structure:
- `.ai/memory/INDEX.md` (must read first)
- `.ai/memory/context/`
- `.ai/memory/architecture/`
- `.ai/memory/handoffs/`
- `.ai/memory/patterns/`

Handoff filenames are canonicalized as:
- `ba->architect.md` conceptually represented in repo as `ba→architect.md`
- `architect->engineer.md` conceptually represented in repo as `architect→engineer.md`
- `engineer->qa.md` conceptually represented in repo as `engineer→qa.md`

Required behavior from `rules/04-memory-protocol.mdc`:
1. Read `INDEX.md` first.
2. State current phase/status after reading.
3. After writing any memory file, read it back and verify.
4. Never infer file state from conversation; always read file state.

## Setup and Bootstrap

Setup scripts:
- `setup.sh` for Mac/Linux/WSL
- `setup.ps1` for Windows

Capabilities:
- install rules/agents/skills into detected AI tools
- bootstrap project entry files and `.ai/memory/`
- support `--global`, `--project`, and `--dry-run`

Recent reliability fixes include:
- Windows handoff placeholder naming aligned with canonical handoff names
- `--dry-run` precedence hardened to prevent accidental real install

## Practical Instructions for Another AI

When assigned work in this repo:

1. Read:
   - `README.md`
   - `rules/00-lifecycle.mdc`
   - `rules/01-plan-before-code.mdc`
   - `rules/04-memory-protocol.mdc`
2. Determine current phase and required gate.
3. Follow the corresponding agent and skill set for that phase.
4. If writing to `.ai/memory/`, always perform read-back verification.
5. Before implementation, ensure approval artifact exists (`approved-by: human`).
6. Keep changes minimal, testable, and aligned with phase outputs.

## Discussion System

Agents can collaboratively explore problems and ideas via append-only discussion threads in `.ai/discussions/`.

Directory structure:
```
.ai/
├── memory/           (phase workflow state)
└── discussions/
    ├── YYYY-MM-DD-<slug>.md          (active or closed threads)
    └── summaries/
        └── YYYY-MM-DD-<slug>-summary.md  (synthesized final documents)
```

Three skills govern the system:
- `skills/discuss/open-discussion/SKILL.md` — human creates a thread with a topic and frontmatter
- `skills/discuss/respond-discussion/SKILL.md` — each agent appends their perspective in round-robin order (BA → Architect → Engineer → QA)
- `skills/discuss/close-discussion/SKILL.md` — after human sets `status: closed`, an agent generates a structured summary

The `next-responder` field in each thread's frontmatter tells the human which agent to invoke next. Discussion threads are append-only — never rewrite prior contributions.

Templates: `memory-templates/discussion-thread.md.template` and `memory-templates/discussion-summary.md.template`.

## Quick Entry Prompt for Any AI

Use this starter prompt:

"Read `PROJECT_FOR_AI.md`, then read `rules/00-lifecycle.mdc`, `rules/01-plan-before-code.mdc`, and `rules/04-memory-protocol.mdc`. Identify current phase, required gate, and next valid action. Do not implement code unless approval gates are satisfied."

