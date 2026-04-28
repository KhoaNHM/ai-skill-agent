---
name: security-review
description: Security review checklist — input validation, auth enforcement, data isolation, secrets, error handling, and OWASP top-10 for each changed file.
---

# Security Review

Run on every implementation before marking Phase 3 complete.

## Memory — read first

1. `.ai/memory/handoffs/engineer→qa.md`
2. `.ai/memory/architecture/api-contracts.md`
3. `.ai/memory/patterns/anti-patterns.md`

## Review checklist

### Authentication & authorization
- [ ] Every endpoint has auth guard (no accidental public exposure)
- [ ] Role/permission checked, not just identity
- [ ] Tenant/scope filter applied on every DB query that returns data

### Input validation
- [ ] All user-supplied fields validated at DTO/controller boundary
- [ ] Field types, lengths, and formats enforced
- [ ] No raw user input in DB queries, shell commands, or template strings
- [ ] Allowlist used where possible (not blocklist)

### Data exposure
- [ ] Response does not include sensitive fields (passwords, tokens, internal IDs)
- [ ] Error messages don't reveal schema, stack traces, or implementation details
- [ ] Pagination applied to list endpoints (no unbounded result sets)

### Destructive operations
- [ ] DELETE / bulk-update guarded with explicit ownership check
- [ ] No cascade delete without intentional design
- [ ] Soft delete used where data recovery may be needed

### Secrets & configuration
- [ ] No secrets hardcoded in source
- [ ] No secrets in logs
- [ ] Required env vars validated at startup

### Dependency safety
- [ ] No new dependencies added without review
- [ ] Third-party libraries are not called with unsanitized user data

### Common vulnerabilities
- [ ] SQL / NoSQL injection: parameterized queries only
- [ ] XSS: output encoded in frontend; API returns data not HTML
- [ ] CSRF: state-changing operations use POST/PUT/PATCH/DELETE, not GET
- [ ] Mass assignment: DTO whitelists accepted fields (no `...body` spread)

## Output

```
### Security Review Result
**Verdict:** go | revise | block

**Findings:**
- [CRITICAL] [finding] — must fix before ship
- [HIGH] [finding] — should fix before ship
- [LOW] [finding] — can track as tech debt

**Cleared items:** [count] / [total] checklist items passed
```

Append any new findings to `.ai/memory/patterns/anti-patterns.md`.
