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

## ADR template

Write to `.ai/memory/architecture/decisions/NNN-[short-name].md`

Where NNN is a zero-padded sequence number (001, 002, ...).

```markdown
---
type: adr
phase: 1-architect
last-updated: YYYY-MM-DD
updated-by: ARCHITECT_AGENT
status: active
---

# ADR-NNN — [Decision Title]

## Status
Accepted | Proposed | Superseded by [ADR-NNN]

## Context
[What is the situation that requires a decision? What constraints exist?
What forces are at play (performance, security, team conventions, deadlines)?]

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
