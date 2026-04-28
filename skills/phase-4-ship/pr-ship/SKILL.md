---
name: pr-ship
description: PR creation checklist — title, body template, CI gate verification, and merge safety check before pushing.
---

# PR Ship

Use when Phase 3 verdict is `go` and the implementation is ready to merge.

## Pre-push checklist

- [ ] Phase 3 verdict is explicitly `go`
- [ ] All CI checks pass locally (lint, typecheck, tests)
- [ ] No `console.log`, debug breakpoints, or `TODO: remove` comments left in
- [ ] No secrets, tokens, or credentials in diff
- [ ] API docs (Swagger) updated if endpoints changed
- [ ] `.ai/memory/INDEX.md` phase status up to date

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

```markdown
## Summary
[2–3 bullet points: what changed and why]

## Acceptance criteria
- AC-01: ✅ [test or manual verification]
- AC-02: ✅ [test or manual verification]

## Changes
- `path/to/file.ts` — [what changed]
- `path/to/file.spec.ts` — [what tests added]

## Testing
[How to test this manually if needed: exact steps, example request]

## Screenshots / examples
[If UI or API response changed, include before/after]

## Notes
[Anything a reviewer should know: trade-offs, follow-up tickets, known limitations]
```

## After PR created

1. Update `.ai/memory/INDEX.md` Phase 4 status → ✅ Complete.
2. **Read back** `INDEX.md` — confirm Phase 4 row shows ✅ Complete.
