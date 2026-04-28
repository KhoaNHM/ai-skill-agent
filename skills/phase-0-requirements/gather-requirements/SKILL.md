---
name: gather-requirements
description: BA interview template — elicit user stories, acceptance criteria, edge cases, and non-functional requirements before any planning begins.
---

# Gather Requirements

Use when requirements are ambiguous, acceptance criteria are missing, or the task touches auth, data isolation, or external integrations.

## Memory — read first

1. `.ai/memory/INDEX.md`
2. `.ai/memory/patterns/anti-patterns.md`

## Interview process

### Step 1 — Core user story

Ask and answer:
- Who is the actor? (user role, service, external system)
- What do they want to do?
- What value do they get?

Format: **As a [actor], I want to [action] so that [value].**

### Step 2 — Acceptance criteria

Write one numbered AC per distinct behavior. Each must be:
- **Testable** — has a clear pass/fail condition
- **Specific** — names fields, status codes, error messages
- **Independent** — does not assume another AC passed

Template:
```
AC-01: Given [precondition], when [action], then [expected result].
AC-02: Given [precondition], when [action], then [expected result].
```

### Step 3 — Edge case checklist

Work through each:
- [ ] Empty input / zero records
- [ ] Invalid format or type
- [ ] Missing required field
- [ ] Unauthorized access attempt
- [ ] Concurrent modification
- [ ] Cross-tenant / cross-scope access attempt
- [ ] External service unavailable
- [ ] Partial failure (some items succeed, some fail)
- [ ] First page / last page / empty page (pagination)
- [ ] Maximum allowed value
- [ ] Duplicate submission

### Step 4 — Non-functional requirements

- **Performance:** Acceptable p99 response time? Record volume?
- **Security:** Who can call this endpoint? What data is returned?
- **Scale:** Concurrent users? Table size in 1 year?
- **Availability:** Is downtime acceptable during deployment?

### Step 5 — Ambiguity flags

List anything needing a human decision before planning can begin:
- [ ] [Question] — Option A vs Option B

## Output

After completing the interview:

1. Write to `.ai/memory/context/requirements.md` (use memory file template)
2. Write to `.ai/memory/handoffs/ba→architect.md`
3. Update `.ai/memory/INDEX.md`:
   - Phase 0 status → ✅ Complete
   - Add link to requirements.md with one-line summary
4. Present to human for review before handing off to Architect
