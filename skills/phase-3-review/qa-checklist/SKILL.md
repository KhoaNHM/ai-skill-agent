---
name: qa-checklist
description: QA review — map each acceptance criterion to a test or manual verification, check coverage, and validate the implementation matches the API contract.
---

# QA Checklist

Use to verify implementation completeness against requirements before marking Phase 3 complete.

## Memory — read first

1. **Read** `.ai/memory/INDEX.md` — confirm Phase 2 is ✅ Complete before starting QA.
2. **Read** `.ai/memory/context/requirements.md` — acceptance criteria (count the ACs).
3. If populated: **Read** `.ai/memory/context/domain-language.md` — interpret AC wording against shared terms.
4. **Read** `.ai/memory/handoffs/engineer→qa.md` — what was built.
5. **Read** `.ai/memory/architecture/api-contracts.md` — expected API shape.

If Phase 2 is not ✅ Complete in INDEX.md, stop and alert the human — do not run QA on incomplete work.

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

Write the QA result to `.ai/memory/handoffs/qa-result.md`:

```markdown
---
type: handoff
phase: 3-qa
last-updated: YYYY-MM-DD
updated-by: QA_AGENT
status: active
---

# QA Review Result

## Verdict
go | revise | block

## AC Coverage
| AC | Test / Verification | Status |
|----|---------------------|--------|
| AC-01 | [test name] | ✅ |
| AC-02 | [manual step] | ❌ |

## Contract match
✅ / ❌ [difference if any]

## Regression status
✅ all passing / ❌ [failing test name]

## Blocking items
- [item with citation to requirements.md or api-contracts.md]

## Non-blocking notes
- [note]
```

Then:
1. **Read back** `qa-result.md` — confirm verdict and all ACs are listed.
2. Update `.ai/memory/INDEX.md` Phase 3 status → ✅ Complete (if verdict is `go`) or ⚠️ Revise.
3. **Read back** `INDEX.md` — confirm Phase 3 row is updated.
