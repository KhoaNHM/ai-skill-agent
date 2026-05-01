---
name: gather-requirements
description: BA interview template — elicit user stories, acceptance criteria, edge cases, and non-functional requirements before any planning begins.
---

# Gather Requirements

Use when requirements are ambiguous, acceptance criteria are missing, or the task touches auth, data isolation, or external integrations.

## Memory — read first

1. `.ai/memory/INDEX.md`
2. `.ai/memory/patterns/anti-patterns.md`
3. If present: `.ai/memory/context/domain-language.md` (shared vocabulary for interviews and AC wording)

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

### Step 6 — Optional domain language (ubiquitous language)

If the product or codebase has **jargon, overloaded words, or long phrases agents should shorten**, capture them in **`.ai/memory/context/domain-language.md`**:

- Use the [domain-language template](../../../memory-templates/domain-language.md.template) (or mirror its sections: Summary, Ubiquitous terms table, Boundaries, Open questions).
- Each row: **term** → **definition** → **avoid saying** (the verbose way agents should replace).
- Keep it **short**; link to `requirements.md` for behavior detail and to ADRs for decisions — do not duplicate full specs here.
- If not needed for this feature, leave the placeholder or skip; still update **INDEX.md** Active Context to say "optional; skipped" or a one-line summary when populated.

## Output

After completing the interview:

1. Write to `.ai/memory/context/requirements.md` (use memory file template)
2. **Read back** `.ai/memory/context/requirements.md` — confirm frontmatter `status: active` and all ACs are present.
3. If Step 6 was used: write to `.ai/memory/context/domain-language.md`, then **read it back** — confirm terms table and `status: active`.
4. Write to `.ai/memory/handoffs/ba→architect.md`
5. **Read back** `.ai/memory/handoffs/ba→architect.md` — confirm it was saved correctly.
6. Update `.ai/memory/INDEX.md`:
   - Phase 0 status → ✅ Complete
   - Add link to requirements.md with one-line summary
   - Active Context: set [Domain language](context/domain-language.md) to a one-line summary, or `optional — skipped` if Step 6 was not used
7. **Read back** `.ai/memory/INDEX.md` — confirm Phase 0 row shows ✅ Complete.
8. Present to human for review before handing off to Architect.

If any read-back fails (file missing or content wrong), fix and retry before presenting to human.
