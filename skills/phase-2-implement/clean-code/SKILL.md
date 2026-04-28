---
name: clean-code
description: Code smells, SOLID in practice, design pattern use vs misuse, and a short code-review prompt template.
---

# Clean code & architecture (practical)

Use this skill during **review**, **refactoring**, and when choosing **patterns**. Complements global rules on SOLID and patterns.

## Code smells (quick reference)

| Smell | What you notice | Lean response |
|-------|-----------------|---------------|
| **Rigidity** | Every change touches many files | Reduce coupling; smaller modules |
| **Fragility** | Unrelated areas break | Clear boundaries; tests at seams |
| **Immobility** | Can’t reuse without dragging half the app | Extract shared core; invert dependencies |
| **Viscosity** | Hacks are easier than the “right” change | Improve DX, docs, scaffolding |
| **Needless complexity** | Abstraction with no clear benefit | Delete or inline (YAGNI) |
| **Needless repetition** | Copy-paste logic | DRY — single source of truth |
| **Opacity** | Unclear intent | Rename, split functions, document *why* |

## SOLID in practice

- **Writing:** Prefer small, single-purpose units; depend on interfaces or narrow types at boundaries.
- **Reviewing:** Ask “would a substitute implementation break callers?” (LSP), “does this type force unused methods?” (ISP).
- **Refactoring:** When a smell appears twice, note it; when it appears **three** times with the same shape, consider extraction or a small pattern — not on the first copy.

## Design patterns: use vs misuse

- **Use** when the same structural problem recurs and a pattern **names** the solution for the team.
- **Misuse** when the pattern is adopted for fashion or “might need later” — that’s cargo cult.
- **Document** non-obvious pattern usage in a one-line comment (e.g. “Strategy: swap export format without touching orchestration”).

## Code review prompt (paste / adapt)

Answer briefly for the changed code:

1. What is the **single responsibility** of each new or changed unit?
2. Any smell from the table above? Which, and what’s the smallest fix?
3. Is duplication **real** (same rule, same reason to change) or accidental?
4. Are errors handled at the **right layer** (validate early, log server-side, safe client message)?
5. Would a **test** (existing or missing) catch a regression from this diff?
