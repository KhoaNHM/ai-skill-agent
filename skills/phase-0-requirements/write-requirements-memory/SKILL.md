---
name: write-requirements-memory
description: Write BA output to .ai/memory/context/requirements.md and the ba→architect handoff file using the correct memory format.
---

# Write Requirements Memory

Use at the end of Phase 0 to persist requirements to memory.

## File 1 — requirements.md

Write to `.ai/memory/context/requirements.md`:

```markdown
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

## File 2 — ba→architect.md

Write to `.ai/memory/handoffs/ba→architect.md`:

```markdown
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

In `.ai/memory/INDEX.md`, change Phase 0 row to:
```
| 0 · Requirements | ✅ Complete | BA_AGENT | YYYY-MM-DD |
```

Add to Active Context section:
```
- [Requirements](context/requirements.md) — [one-line summary of what is being built]
- [Domain language](context/domain-language.md) — [one-line summary, or "optional — skipped"]
```
(If `domain-language.md` was not filled during the interview, set the Domain language line to `optional — skipped`.)

Add to Current Handoff section:
```
→ [BA → Architect](handoffs/ba→architect.md) — ready for Phase 1
```

## Verify before finishing

Read back every memory file you wrote or updated and confirm:

| File | Check |
|------|-------|
| `context/requirements.md` | `status: active`, all ACs numbered, no empty sections |
| `context/domain-language.md` | If you updated it: `status: active`, terms table present; otherwise INDEX should mark domain language as skipped |
| `handoffs/ba→architect.md` | `status: active`, open questions listed |
| `INDEX.md` | Phase 0 row shows ✅ Complete; requirements + domain-language lines present (domain language may say skipped) |

Do not report Phase 0 complete until all checks pass.
