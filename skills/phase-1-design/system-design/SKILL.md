---
name: system-design
description: Architecture planning template — module boundaries, DI, database schema, query safety, and layering before implementation.
---

# System Design

Use to produce the architecture plan for a new feature or significant change.

## Memory — read first

1. `.ai/memory/INDEX.md`
2. `.ai/memory/context/requirements.md`
3. If populated: `.ai/memory/context/domain-language.md` (align module and type names with ubiquitous terms)
4. `.ai/memory/handoffs/ba→architect.md`
5. `.ai/memory/patterns/anti-patterns.md`

## Design checklist

### 1. Module boundaries
- [ ] Which module owns this feature?
- [ ] New module or extend existing?
- [ ] Dependencies: what does it import? What imports it?
- [ ] No circular dependencies introduced?

### 2. Dependency injection
- [ ] New services declared as providers?
- [ ] All dependencies injected, not instantiated directly?
- [ ] Testable in isolation (deps can be mocked)?

### 3. Database
- [ ] New collection or extension of existing?
- [ ] Schema: field names, types, required vs optional, defaults
- [ ] Indexes: which fields are filtered/sorted?
- [ ] Scope/tenant filter on every query?
- [ ] Destructive operations guarded?
- [ ] Migration backwards-compatible?

### 4. API shape
- [ ] Endpoint: METHOD /resource (plural noun, matches existing pattern)
- [ ] Request DTO: fields, types, validation rules, Swagger decorators
- [ ] Response: shape, status codes (success + each error case)
- [ ] Error messages: consistent with project convention

### 5. Separation of concerns
- [ ] Business logic in service, not controller
- [ ] DB access in repository or data service, not business service
- [ ] Pure helpers separated from I/O services

### 6. Cross-cutting concerns
- [ ] Auth: who can call this?
- [ ] Logging: what events need logging?
- [ ] Error handling: which exceptions, what messages?
- [ ] Rate limiting needed?

## Output

1. Write to `.ai/memory/architecture/module-map.md`
2. **Read back** `module-map.md` — confirm module boundaries and layer diagram are present.
3. Write to `.ai/memory/architecture/api-contracts.md` (or use `api-design` skill)
4. **Read back** `api-contracts.md` — confirm all endpoints, DTOs, and status codes are present.
5. Update `.ai/memory/context/tech-stack.md` with any new technology decisions and rationale
6. Run `phase-1-design/write-adr` for each significant decision
7. Write to `.ai/memory/handoffs/architect→engineer.md` — include `approved-by: —` in the frontmatter.
8. **Read back** `architect→engineer.md` — confirm plan, file list, and `approved-by: —` are present.
9. Update `.ai/memory/INDEX.md` Phase 1 status and Current Handoff section
10. **Read back** `INDEX.md` — confirm Phase 1 row and Current Handoff point to correct files.
11. Present plan to human — **wait for explicit approval before any code**
12. After human approves: update `approved-by: —` → `approved-by: human` in `architect→engineer.md`.
