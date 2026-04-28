---
name: tdd
description: Test-driven development — red-green-refactor, iron law, verification checklist, and common rationalizations to avoid.
---

# TDD (test-driven development)

Use this skill when implementing features, fixing bugs with regression risk, or when the user asks for tests-first workflow.

## Iron law

**No production code without a failing test first** (red) that expresses the desired behavior. Then make it pass (green), then refactor with tests still green.

## Red → green → refactor

1. **Red:** Write one small failing test that describes one behavior (clear name, minimal assertion).
2. **Green:** Write the smallest amount of production code to pass the test — no speculative extras.
3. **Refactor:** Clean up names and structure; keep tests green. Repeat for the next behavior.

## Verification checklist

- [ ] A test failed before the new/changed production code existed (or before the fix).
- [ ] All tests pass after the change.
- [ ] New behavior has at least one test that would fail if the behavior regressed.
- [ ] Tests read as documentation (arrange–act–assert, obvious names).

## Common rationalizations (don’t skip the test)

| Excuse | Reality |
|--------|---------|
| “Too small to test” | Small bugs still ship; one test often pays off immediately. |
| “I’ll test after” | “After” rarely happens; design without tests drifts. |
| “Hard to test” | Usually a signal to improve seams (inject deps, pure helpers). |
| “Only a one-line fix” | One-line fixes are classic regression sources — add or adjust a test. |
| “No time” | Red-green in small steps is often faster than debug-after integration. |

## Scope

- Prefer **unit tests** for pure logic and **narrow integration tests** for boundaries (DB, HTTP) as the project allows.
- Match the project’s test runner and file layout (`*.spec.ts`, `__tests__/`, etc.).
