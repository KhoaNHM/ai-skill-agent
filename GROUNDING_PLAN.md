# Grounding Implementation Plan

**Goal:** Eliminate agent hallucination and fabricated state by grounding every agent in real, verified file state — regardless of which AI model or tool is being used.

**Root cause:** Agents fill conversation-memory gaps with plausible-sounding fabrications. Without explicit read and read-back steps, an agent can "remember" a file it never actually wrote.

**Principle:** This project is model-agnostic. Every fix must work with Claude, GPT, Gemini, Cursor, Windsurf, or any other tool — no proprietary config files.

**Solution:** Three changes that work everywhere:
1. `init-memory` creates AI-specific entry point files so any tool auto-loads the memory protocol
2. Read-back verification added to every skill output section
3. Explicit verification rule added to `04-memory-protocol.mdc`

---

## Files to create or modify

| # | Action | File |
|---|--------|------|
| 1 | **Update** | `skills/tooling/init-memory/SKILL.md` |
| 2 | **Update** | `rules/04-memory-protocol.mdc` |
| 3 | **Update** | `skills/phase-0-requirements/gather-requirements/SKILL.md` |
| 4 | **Update** | `skills/phase-0-requirements/write-requirements-memory/SKILL.md` |
| 5 | **Update** | `skills/phase-1-design/system-design/SKILL.md` |
| 6 | **Update** | `skills/phase-3-review/qa-checklist/SKILL.md` |

---

## Why NOT `.cursor/mcp.json` or tool-specific configs

MCP filesystem configs (`.cursor/mcp.json`, etc.) are tool-specific — they break model-agnostic design. If the project moves from Cursor to Claude Code, Windsurf, or a raw API agent, the config stops working.

Instead, different AI tools auto-load different filenames at session start. Creating all of them means the memory protocol activates automatically regardless of which tool opens the project:

| File | Auto-loaded by |
|------|----------------|
| `CLAUDE.md` | Claude Code (CLI) |
| `.cursor/rules/` `.mdc` files | Cursor (already covered by existing rules) |
| `WINDSURF.md` | Windsurf IDE |
| `AGENTS.md` | OpenAI Codex, agent frameworks |
| `AI_CONTEXT.md` | Any model when told "read AI_CONTEXT.md first" |

All five files contain the same single instruction: **read `.ai/memory/INDEX.md` first**.

---

## Step 1 — Update `skills/tooling/init-memory/SKILL.md`

**Location:** `skills/tooling/init-memory/SKILL.md`

### Edit A — Replace directory structure block

Find:

````markdown
### Directory structure
```
.ai/
└── memory/
    ├── INDEX.md
    ├── context/
    │   ├── requirements.md
    │   ├── tech-stack.md
    │   └── non-functional.md
    ├── architecture/
    │   ├── module-map.md
    │   ├── api-contracts.md
    │   └── decisions/
    │       └── .gitkeep
    ├── handoffs/
    │   ├── ba→architect.md
    │   ├── architect→engineer.md
    │   └── engineer→qa.md
    └── patterns/
        ├── solutions.md
        └── anti-patterns.md
```
````

Replace with:

````markdown
### Directory structure
```
[project root]/
├── CLAUDE.md          ← Claude Code auto-loads this
├── AGENTS.md          ← OpenAI Codex / agent frameworks auto-load this
├── WINDSURF.md        ← Windsurf IDE auto-loads this
├── AI_CONTEXT.md      ← generic fallback for any model
└── .ai/
    └── memory/
        ├── INDEX.md
        ├── context/
        │   ├── requirements.md
        │   ├── tech-stack.md
        │   └── non-functional.md
        ├── architecture/
        │   ├── module-map.md
        │   ├── api-contracts.md
        │   └── decisions/
        │       └── .gitkeep
        ├── handoffs/
        │   ├── ba→architect.md
        │   ├── architect→engineer.md
        │   └── engineer→qa.md
        └── patterns/
            ├── solutions.md
            └── anti-patterns.md
```
````

### Edit B — Add entry point file contents after the INDEX.md section

After the `### \`.ai/memory/INDEX.md\`` content block and before the `### All other files` section, insert:

````markdown
### Entry point files (all four have the same content)

Create all four at the **project root**. Each tool picks up the filename it recognizes. Content is identical:

```markdown
# AI Memory Protocol

Read `.ai/memory/INDEX.md` FIRST at the start of every session — before any other action.

Never assume phase status or file contents from conversation history. Read the actual file.

## Memory structure
- `.ai/memory/INDEX.md` — phase status and links to all memory files
- `.ai/memory/context/` — requirements, tech stack, non-functional
- `.ai/memory/architecture/` — module map, API contracts, ADRs
- `.ai/memory/handoffs/` — phase-to-phase transfer notes
- `.ai/memory/patterns/` — solutions and anti-patterns

## Rules
1. Read INDEX.md first. State the current phase and status before doing any work.
2. After writing any memory file, read it back immediately to confirm correct content.
3. Do not report a phase complete until you have read back the updated INDEX.md.
4. Do not infer file state from conversation — read the file.
```

Files to create:
- `CLAUDE.md` — same content as above
- `AGENTS.md` — same content as above
- `WINDSURF.md` — same content as above
- `AI_CONTEXT.md` — same content as above
````

### Edit C — Update the "After running" section

Find:

```markdown
## After running

Tell the user:
- `.ai/memory/` created with 11 files across 4 subdirectories
- Next step: run `phase-0-requirements/gather-requirements` to begin Phase 0

**Git recommendation:** Commit `.ai/memory/` to the project repo so architecture decisions, handoffs, and patterns are version-controlled alongside the code.
```

Replace with:

```markdown
## After running

Tell the user:
- `CLAUDE.md`, `AGENTS.md`, `WINDSURF.md`, `AI_CONTEXT.md` created at project root — any AI tool will auto-load the memory protocol on session start
- `.ai/memory/` created with 11 files across 4 subdirectories
- Next step: run `phase-0-requirements/gather-requirements` to begin Phase 0

**Git recommendation:** Commit everything to the project repo:
```
git add CLAUDE.md AGENTS.md WINDSURF.md AI_CONTEXT.md .ai/memory/
git commit -m "chore: init AI memory"
```
```

---

## Step 2 — Update `rules/04-memory-protocol.mdc`

**Location:** `rules/04-memory-protocol.mdc`

### Edit A — Strengthen session start steps

Find:

```markdown
## Start of every session

1. Check if `.ai/memory/` exists in the project.
   - If not: run `tooling/init-memory` skill to create it.
2. Read `.ai/memory/INDEX.md` — always, before any other action.
3. Read the handoff file for your current phase (listed in INDEX.md).
4. Read `.ai/memory/patterns/anti-patterns.md` — prevent repeat mistakes.
```

Replace with:

```markdown
## Start of every session

1. Check if `.ai/memory/` exists in the project.
   - If not: run `tooling/init-memory` skill to create it.
2. **Read** `.ai/memory/INDEX.md` — always, before any other action. Do not infer phase status from conversation history.
3. **State the current phase out loud** — e.g. "Phase 1 is ✅ Complete, Phase 2 is ⏳ Pending." This lets the human catch stale assumptions immediately.
4. **Read** the handoff file for your current phase (path listed in INDEX.md Current Handoff section).
5. **Read** `.ai/memory/patterns/anti-patterns.md` — prevent repeat mistakes.
```

### Edit B — Add verification rules to "Rules for writing to memory"

Find:

```markdown
## Rules for writing to memory

1. Never overwrite — always append to patterns files.
2. Always update the `last-updated` and `updated-by` frontmatter fields.
3. Always update `INDEX.md` after writing a file (add/update the link and phase status).
4. Keep the Summary section scannable — the next agent should understand it in 10 seconds.
5. Archive superseded decisions by setting `status: superseded` and linking the replacement ADR.
```

Replace with:

```markdown
## Rules for writing to memory

1. Never overwrite — always append to patterns files.
2. Always update the `last-updated` and `updated-by` frontmatter fields.
3. Always update `INDEX.md` after writing a file (add/update the link and phase status).
4. Keep the Summary section scannable — the next agent should understand it in 10 seconds.
5. Archive superseded decisions by setting `status: superseded` and linking the replacement ADR.
6. **Read back after writing.** After writing any memory file, read it back to confirm correct content and updated frontmatter. Do not report success until the read-back passes.
7. **Never infer file state from conversation.** Always read the actual file. If unsure whether a file exists, check — do not assume.
```

---

## Step 3 — Update `skills/phase-0-requirements/gather-requirements/SKILL.md`

**Location:** `skills/phase-0-requirements/gather-requirements/SKILL.md`

Find:

```markdown
## Output

After completing the interview:

1. Write to `.ai/memory/context/requirements.md` (use memory file template)
2. Write to `.ai/memory/handoffs/ba→architect.md`
3. Update `.ai/memory/INDEX.md`:
   - Phase 0 status → ✅ Complete
   - Add link to requirements.md with one-line summary
4. Present to human for review before handing off to Architect
```

Replace with:

```markdown
## Output

After completing the interview:

1. Write to `.ai/memory/context/requirements.md` (use memory file template)
2. **Read back** `requirements.md` — confirm `status: active` and all ACs are present and numbered.
3. Write to `.ai/memory/handoffs/ba→architect.md`
4. **Read back** `ba→architect.md` — confirm it was saved correctly.
5. Update `.ai/memory/INDEX.md`:
   - Phase 0 status → ✅ Complete
   - Add link to requirements.md with one-line summary
6. **Read back** `INDEX.md` — confirm Phase 0 row shows ✅ Complete.
7. Present to human for review before handing off to Architect.

If any read-back fails (file missing or content wrong), fix and retry before presenting to human.
```

---

## Step 4 — Update `skills/phase-0-requirements/write-requirements-memory/SKILL.md`

**Location:** `skills/phase-0-requirements/write-requirements-memory/SKILL.md`

Find the `## Update INDEX.md` section at the end of the file:

```markdown
## Update INDEX.md

In `.ai/memory/INDEX.md`, change Phase 0 row to:
```
| 0 · Requirements | ✅ Complete | BA_AGENT | YYYY-MM-DD |
```

Add to Active Context section:
```
- [Requirements](context/requirements.md) — [one-line summary of what is being built]
```

Add to Current Handoff section:
```
→ [BA → Architect](handoffs/ba→architect.md) — ready for Phase 1
```
```

Replace with:

```markdown
## Update INDEX.md

In `.ai/memory/INDEX.md`, change Phase 0 row to:
```
| 0 · Requirements | ✅ Complete | BA_AGENT | YYYY-MM-DD |
```

Add to Active Context section:
```
- [Requirements](context/requirements.md) — [one-line summary of what is being built]
```

Add to Current Handoff section:
```
→ [BA → Architect](handoffs/ba→architect.md) — ready for Phase 1
```

## Verify before finishing

Read back all three files and confirm:

| File | Check |
|------|-------|
| `context/requirements.md` | `status: active`, all ACs numbered, no empty sections |
| `handoffs/ba→architect.md` | `status: active`, open questions listed |
| `INDEX.md` | Phase 0 row shows ✅ Complete, requirements link present |

Do not report Phase 0 complete until all three checks pass.
```

---

## Step 5 — Update `skills/phase-1-design/system-design/SKILL.md`

**Location:** `skills/phase-1-design/system-design/SKILL.md`

Find:

```markdown
## Output

1. Write to `.ai/memory/architecture/module-map.md`
2. Write to `.ai/memory/architecture/api-contracts.md` (or use `api-design` skill)
3. Update `.ai/memory/context/tech-stack.md` with any new technology decisions and rationale
4. Run `phase-1-design/write-adr` for each significant decision
5. Write to `.ai/memory/handoffs/architect→engineer.md`
6. Update `.ai/memory/INDEX.md` Phase 1 status and Current Handoff section
7. Present plan to human — **wait for explicit approval before any code**
```

Replace with:

```markdown
## Output

1. Write to `.ai/memory/architecture/module-map.md`
2. **Read back** `module-map.md` — confirm module boundaries and layer diagram are present.
3. Write to `.ai/memory/architecture/api-contracts.md` (or use `api-design` skill)
4. **Read back** `api-contracts.md` — confirm all endpoints, DTOs, and status codes are present.
5. Update `.ai/memory/context/tech-stack.md` with any new technology decisions and rationale
6. Run `phase-1-design/write-adr` for each significant decision
7. Write to `.ai/memory/handoffs/architect→engineer.md`
8. **Read back** `architect→engineer.md` — confirm approved plan, file list, and verification steps are present.
9. Update `.ai/memory/INDEX.md` Phase 1 status and Current Handoff section
10. **Read back** `INDEX.md` — confirm Phase 1 row and Current Handoff point to correct files.
11. Present plan to human — **wait for explicit approval before any code**
```

---

## Step 6 — Update `skills/phase-3-review/qa-checklist/SKILL.md`

**Location:** `skills/phase-3-review/qa-checklist/SKILL.md`

Find:

```markdown
## Memory — read first

1. `.ai/memory/context/requirements.md` — acceptance criteria
2. `.ai/memory/handoffs/engineer→qa.md` — what was built
3. `.ai/memory/architecture/api-contracts.md` — expected API shape
```

Replace with:

```markdown
## Memory — read first

1. **Read** `.ai/memory/INDEX.md` — confirm Phase 2 is ✅ Complete before starting QA.
   - If Phase 2 is not ✅ Complete, stop and alert the human. Do not run QA on incomplete work.
2. **Read** `.ai/memory/context/requirements.md` — count the ACs before reviewing.
3. **Read** `.ai/memory/handoffs/engineer→qa.md` — what was built.
4. **Read** `.ai/memory/architecture/api-contracts.md` — expected API shape.
```

Find the `## Output` section (the code block at the end):

````markdown
## Output

```
### QA Review Result
**Verdict:** go | revise | block
...
```
````

Replace with:

````markdown
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
- [item with citation]

## Non-blocking notes
- [note]
```

Then:
1. **Read back** `qa-result.md` — confirm verdict and all ACs are listed.
2. Update `.ai/memory/INDEX.md` Phase 3 status → ✅ Complete (verdict `go`) or ⚠️ Revise.
3. **Read back** `INDEX.md` — confirm Phase 3 row is updated.
````

---

## Verification

After implementing all steps, test end-to-end:

1. **Entry point files:** Open the test project in any AI tool (Claude Code, Cursor, Windsurf, or a raw API call). The AI should start by reading `.ai/memory/INDEX.md` because the entry point file told it to. Works without any tool-specific config.

2. **Read-back:** Run `tooling/init-memory` on a test project. After completion, ask the agent: "Read back INDEX.md and confirm Phase 0 status." It should read the actual file, not report from memory.

3. **Phase gate:** Start Phase 3 (QA) without completing Phase 2. The qa-checklist skill should read INDEX.md, see Phase 2 is not ✅ Complete, and stop.

4. **Any model:** Copy the four entry point file contents into a system prompt for any model (GPT, Gemini, etc.). It will follow the same protocol because the instructions are in plain text — no tool-specific features needed.

---

## Summary

| Change | Works with | Prevents |
|--------|-----------|----------|
| `CLAUDE.md` / `AGENTS.md` / `WINDSURF.md` / `AI_CONTEXT.md` | Any AI tool that auto-loads these filenames | Agent starting work without reading INDEX.md |
| Read-back steps in skills | Any model, any tool | Agent claiming success without verifying write |
| Verification rule in `04-memory-protocol.mdc` | Any model, any tool | Agent inferring state from conversation history |
