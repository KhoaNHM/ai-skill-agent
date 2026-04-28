---
name: change-impact
description: Analyze git diff to find blast radius of code changes. Use when reviewing changes before commit, creating PRs, or when the user asks what is affected by their edits.
---

# Change Impact Analysis

Trace changed files through imports and dependents to produce a structured impact report. Works for any project.

## When to use

- Before committing or creating a PR
- When the user asks "what did I break?" or "what else needs updating?"
- After a large refactor to verify nothing was missed

## Instructions

### 1. Collect changed files

Determine the diff scope:

- **Uncommitted changes**: `git diff --name-only` (unstaged) + `git diff --cached --name-only` (staged)
- **Branch vs base**: `git diff main...HEAD --name-only` (adjust base branch as needed)
- **Specific commits**: `git diff <commit>..HEAD --name-only`

Filter out non-source files (lock files, generated assets) unless they are relevant.

### 2. Find dependents (1-hop blast radius)

For each changed source file, search the codebase for **what imports or references it**:

- Use Grep to find import/require statements that reference the changed file's module path.
- Use Grep to find direct references to exported symbols (class names, function names) from that file.
- Collect the set of **affected files** (files that depend on at least one changed file).

Skip `node_modules`, `dist`, and other generated directories.

### 3. Categorize affected areas

Group findings into:

| Category | What to check |
|----------|---------------|
| **Source** | Services, controllers, helpers that import changed code |
| **Tests** | Test files for changed or affected modules |
| **Docs** | LLD, README, API docs, Swagger examples that describe changed behavior |
| **Config** | DTOs, schemas, enums, module registrations touched by changes |

### 4. Assess risk

Rate each changed file:

- **High**: Public API signature changed, schema/DTO modified, shared helper altered (many dependents)
- **Medium**: Internal service logic changed with 2+ dependents
- **Low**: Leaf file with 0-1 dependents, docs-only, test-only

### 5. Output the impact report

Present a structured summary:

```
## Impact Report

### Changed files (N)
- path/to/file.ts — [brief what changed]

### Directly affected (M files)
- path/to/dependent.ts — imports [symbol] from [changed file]

### Areas to review
- [ ] Tests: [list test files or "no tests found for X"]
- [ ] Docs: [LLD section, README, Swagger if API changed]
- [ ] Config: [DTOs, schemas, module registration if applicable]

### Risk: High / Medium / Low
[One-line justification]
```

### 6. Suggest next steps

Based on findings:
- Missing tests for changed code? Suggest writing them.
- API signature changed but docs not updated? Flag it.
- Schema changed but no migration? Flag it.
- High blast radius? Suggest incremental commits or a review checklist.

## Tips

- Start broad (grep for filename), then narrow (grep for exported symbols).
- For monorepos, scope grep to the relevant package/module directory.
- If the project has an LLD or architecture doc, check whether changed areas are documented there.
- Combine with `git diff` (content) to understand *what* changed, not just *which files*.
