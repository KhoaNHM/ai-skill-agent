---
name: qa-checklist
description: QA review — map each acceptance criterion to a test or manual verification, check coverage, and validate the implementation matches the API contract.
---

# QA Checklist

Use to verify implementation completeness against requirements before marking Phase 3 complete.

## Memory — read first

1. `.ai/memory/context/requirements.md` — acceptance criteria
2. `.ai/memory/handoffs/engineer→qa.md` — what was built
3. `.ai/memory/architecture/api-contracts.md` — expected API shape

## AC coverage mapping

For each acceptance criteria in `requirements.md`, record:

| AC | Test / Verification | Status |
|----|---------------------|--------|
| AC-01 | [test name or manual step] | ✅ / ❌ |
| AC-02 | [test name or manual step] | ✅ / ❌ |

Every AC must have either:
- An automated test that would fail if the behavior regressed, OR
- A documented manual verification step with exact inputs and expected outputs

## Test quality check

- [ ] Tests use Arrange / Act / Assert structure
- [ ] Test names describe the behavior, not the implementation
- [ ] No test modifies another test's state (isolated)
- [ ] No test relies on a specific record ID or external state
- [ ] Edge cases from requirements.md have corresponding tests

## API contract verification

Compare the implementation against `.ai/memory/architecture/api-contracts.md`:
- [ ] Route method and path match
- [ ] Request DTO fields and validation match
- [ ] Response shape matches (field names, types, nesting)
- [ ] All documented status codes reachable
- [ ] Error messages match documented format

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

**Contract match:** ✅ / ❌ [difference if any]
**Regression status:** ✅ all passing / ❌ [failing test]

**Blocking:** [list blocking items with citations]
**Non-blocking:** [list non-blocking notes]
```
