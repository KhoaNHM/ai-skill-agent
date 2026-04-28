#!/usr/bin/env bash
# init-project.sh
# Bootstrap .ai/memory/ in the current project (macOS / Linux)
# Run from your project root: bash path/to/init-project.sh

set -e

PROJECT_ROOT="$(pwd)"
MEMORY_ROOT="$PROJECT_ROOT/.ai/memory"
PROJECT_NAME="$(basename "$PROJECT_ROOT")"

echo ""
echo "AI Skill Agent — Project Memory Init"
echo "Project: $PROJECT_ROOT"
echo "Memory : $MEMORY_ROOT"
echo ""

if [ -d "$MEMORY_ROOT" ]; then
    echo "  .ai/memory/ already exists — skipping init."
    echo "  Delete .ai/memory/ and re-run to reset."
    exit 0
fi

# Create directory structure
mkdir -p \
    "$MEMORY_ROOT/context" \
    "$MEMORY_ROOT/architecture/decisions" \
    "$MEMORY_ROOT/handoffs" \
    "$MEMORY_ROOT/patterns"

# INDEX.md
cat > "$MEMORY_ROOT/INDEX.md" <<EOF
# Memory Index — $PROJECT_NAME

> Read this first. Load only files relevant to your current phase.

## Phase Status
| Phase | Status | Owner | Last Updated |
|-------|--------|-------|--------------|
| 0 · Requirements | ⏳ Pending | BA_AGENT | — |
| 1 · Architecture | ⏳ Pending | ARCHITECT_AGENT | — |
| 2 · Implementation | ⏳ Pending | ENGINEER_AGENT | — |
| 3 · QA / Review | ⏳ Pending | QA_AGENT | — |
| 4 · Ship | ⏳ Pending | — | — |

## Active Context
- [Requirements](context/requirements.md) — not yet written
- [Tech Stack](context/tech-stack.md) — not yet written
- [Non-functional](context/non-functional.md) — not yet written

## Architecture
- [Module Map](architecture/module-map.md) — not yet written
- [API Contracts](architecture/api-contracts.md) — not yet written
- ADRs: none yet

## Current Handoff
→ none yet — start with Phase 0

## Patterns
- [Solutions](patterns/solutions.md)
- [Anti-patterns](patterns/anti-patterns.md)
EOF

# Helper: write placeholder file
write_placeholder() {
    local file="$1" type="$2" phase="$3" title="$4" skill="$5"
    cat > "$MEMORY_ROOT/$file" <<EOF
---
type: $type
phase: $phase
last-updated: —
updated-by: —
status: draft
---

# $title — not yet written

Run \`$skill\` skill to populate this file.
EOF
    echo "  [created] .ai/memory/$file"
}

write_placeholder "context/requirements.md"           context      0-ba          "Requirements"                "gather-requirements"
write_placeholder "context/tech-stack.md"             context      1-architect   "Tech Stack"                  "system-design"
write_placeholder "context/non-functional.md"         context      0-ba          "Non-Functional Requirements" "gather-requirements"
write_placeholder "architecture/module-map.md"        architecture 1-architect   "Module Map"                  "system-design"
write_placeholder "architecture/api-contracts.md"     architecture 1-architect   "API Contracts"               "api-design"
write_placeholder "handoffs/ba-to-architect.md"       handoff      0-ba          "Handoff: BA to Architect"    "write-requirements-memory"
write_placeholder "handoffs/architect-to-engineer.md" handoff      1-architect   "Handoff: Architect to Engineer" "system-design"
write_placeholder "handoffs/engineer-to-qa.md"        handoff      2-engineer    "Handoff: Engineer to QA"     "(written by Engineer)"
write_placeholder "patterns/solutions.md"             pattern      any           "Solutions"                   "(append during Phase 2)"
write_placeholder "patterns/anti-patterns.md"         pattern      any           "Anti-patterns"               "(append during Phase 2/3)"

touch "$MEMORY_ROOT/architecture/decisions/.gitkeep"

# Entry point files — one per AI tool, all identical content
ENTRY_CONTENT='# AI Memory Protocol

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
4. Do not infer file state from conversation — read the file.'

for f in CLAUDE.md AGENTS.md WINDSURF.md AI_CONTEXT.md; do
    echo "$ENTRY_CONTENT" > "$PROJECT_ROOT/$f"
    echo "  [created] $f"
done

echo ""
echo "Done. .ai/memory/ created with 11 files."
echo ""
echo "Recommended: commit this to git so decisions are version-controlled."
echo "  git add CLAUDE.md AGENTS.md WINDSURF.md AI_CONTEXT.md .ai/memory/"
echo "  git commit -m 'chore: init AI memory'"
echo ""
echo "Next step: start Phase 0 with agents/00-ba-strategist.md"
