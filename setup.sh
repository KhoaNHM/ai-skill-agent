#!/usr/bin/env bash
# setup.sh — one command to set up AI agent workflow for any tool, any env
# Usage (from repo root or any project):
#   bash /path/to/setup.sh           # global install + project init
#   bash /path/to/setup.sh --global  # global install only
#   bash /path/to/setup.sh --project # project init only
#   bash /path/to/setup.sh --dry-run # preview without changes

set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CWD="$(pwd)"
MODE="all"

for arg in "$@"; do
  case $arg in
    --global)   MODE="global" ;;
    --project)  MODE="project" ;;
    --dry-run)  MODE="dry" ;;
  esac
done

# ── colour helpers ────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RESET='\033[0m'
ok()   { echo -e "${GREEN}  ✓${RESET} $*"; }
info() { echo -e "${CYAN}  →${RESET} $*"; }
skip() { echo -e "${YELLOW}  ~${RESET} $*"; }
hdr()  { echo -e "\n${CYAN}── $* ──${RESET}"; }
run()  {
  if [ "$MODE" = "dry" ]; then
    echo "    [dry] $*"
  else
    eval "$@"
  fi
}

# ── tool detection ────────────────────────────────────────────────────────────
detect_tools() {
  TOOLS=()
  [ -d "$HOME/.cursor" ]                   && TOOLS+=("cursor")
  { [ -d "$HOME/.claude" ] || command -v claude &>/dev/null 2>&1; } && TOOLS+=("claude-code")
  [ -d "$HOME/.codeium/windsurf" ]         && TOOLS+=("windsurf")
}

# ── global install ────────────────────────────────────────────────────────────
install_cursor() {
  local base="$HOME/.cursor"
  run mkdir -p "$base/rules" "$base/agents" "$base/skills"
  run cp "$REPO"/rules/*.mdc "$base/rules/"
  run cp "$REPO"/agents/*.md "$base/agents/"
  run cp -r "$REPO/skills/." "$base/skills/"
  ok "Cursor  → $base/rules/ agents/ skills/"
}

install_claude_code() {
  local base="$HOME/.claude"
  run mkdir -p "$base/commands"

  # Install each skill as a slash command
  local count=0
  while IFS= read -r skill_file; do
    skill_name="$(basename "$(dirname "$skill_file")")"
    run cp "$skill_file" "$base/commands/$skill_name.md"
    count=$((count + 1))
  done < <(find "$REPO/skills" -name "SKILL.md")

  # Append memory protocol to global CLAUDE.md (idempotent — skip if already present)
  local marker="## AI Memory Protocol"
  if [ "$MODE" != "dry" ] && grep -q "$marker" "$base/CLAUDE.md" 2>/dev/null; then
    skip "Claude Code global CLAUDE.md already has memory protocol — skipped"
  else
    run "cat >> '$base/CLAUDE.md'" <<'CLAUDEEOF'

## AI Memory Protocol

Read `.ai/memory/INDEX.md` FIRST at the start of every session — before any other action.
Never assume phase status or file contents from conversation history. Read the actual file.

Memory structure:
- `.ai/memory/INDEX.md` — phase status and links to all memory files
- `.ai/memory/context/` — requirements, tech stack, non-functional
- `.ai/memory/architecture/` — module map, API contracts, ADRs
- `.ai/memory/handoffs/` — phase-to-phase transfer notes
- `.ai/memory/patterns/` — solutions and anti-patterns

Rules:
1. Read INDEX.md first. State the current phase and status before doing any work.
2. After writing any memory file, read it back to confirm correct content.
3. Do not report a phase complete until you have read back the updated INDEX.md.
4. Do not infer file state from conversation — read the file.
CLAUDEEOF
  fi

  ok "Claude Code → $base/commands/ ($count skills)"
}

install_windsurf() {
  local base="$HOME/.codeium/windsurf"
  run mkdir -p "$base/rules" "$base/agents"
  run cp "$REPO"/rules/*.mdc "$base/rules/" 2>/dev/null || true
  run cp "$REPO"/agents/*.md "$base/agents/" 2>/dev/null || true
  ok "Windsurf  → $base/rules/ agents/"
}

global_install() {
  hdr "Global Install"

  detect_tools

  if [ ${#TOOLS[@]} -eq 0 ]; then
    skip "No AI tools detected (Cursor / Claude Code / Windsurf)"
    run mkdir -p "$HOME/.ai-skill-agent"
    run cp -r "$REPO/." "$HOME/.ai-skill-agent/"
    ok "Fallback  → ~/.ai-skill-agent/ (library copy)"
    return
  fi

  for tool in "${TOOLS[@]}"; do
    case $tool in
      cursor)      install_cursor ;;
      claude-code) install_claude_code ;;
      windsurf)    install_windsurf ;;
    esac
  done
}

# ── project init ──────────────────────────────────────────────────────────────
is_project() {
  [ -f "$CWD/.git/config" ] || [ -d "$CWD/.git" ] || \
  [ -f "$CWD/package.json" ] || [ -f "$CWD/pyproject.toml" ] || \
  [ -f "$CWD/go.mod" ] || [ -f "$CWD/Cargo.toml" ]
}

write_entry_files() {
  local content
  content='# AI Memory Protocol

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
    if [ -f "$CWD/$f" ]; then
      skip "$f already exists — skipped"
    else
      if [ "$MODE" = "dry" ]; then
        echo "    [dry] create $f"
      else
        printf '%s\n' "$content" > "$CWD/$f"
        ok "Created $f"
      fi
    fi
  done
}

write_memory() {
  local project_name
  project_name="$(basename "$CWD")"
  local mem="$CWD/.ai/memory"

  run mkdir -p \
    "$mem/context" \
    "$mem/architecture/decisions" \
    "$mem/handoffs" \
    "$mem/patterns"

  # INDEX.md
  if [ "$MODE" != "dry" ]; then
    cat > "$mem/INDEX.md" <<INDEXEOF
# Memory Index — $project_name

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
INDEXEOF
  else
    echo "    [dry] create .ai/memory/INDEX.md"
  fi

  # Placeholder files
  write_placeholder() {
    local file="$1" type="$2" phase="$3" title="$4" skill="$5"
    if [ "$MODE" = "dry" ]; then
      echo "    [dry] create .ai/memory/$file"
      return
    fi
    cat > "$mem/$file" <<PHEOF
---
type: $type
phase: $phase
last-updated: —
updated-by: —
status: draft
---

# $title — not yet written

Run \`$skill\` skill to populate this file.
PHEOF
  }

  write_placeholder "context/requirements.md"           context      0-ba         "Requirements"                   "gather-requirements"
  write_placeholder "context/tech-stack.md"             context      1-architect  "Tech Stack"                     "system-design"
  write_placeholder "context/non-functional.md"         context      0-ba         "Non-Functional Requirements"    "gather-requirements"
  write_placeholder "architecture/module-map.md"        architecture 1-architect  "Module Map"                     "system-design"
  write_placeholder "architecture/api-contracts.md"     architecture 1-architect  "API Contracts"                  "api-design"
  write_placeholder "handoffs/ba→architect.md"          handoff      0-ba         "Handoff: BA → Architect"        "write-requirements-memory"
  write_placeholder "handoffs/architect→engineer.md"    handoff      1-architect  "Handoff: Architect → Engineer"  "system-design"
  write_placeholder "handoffs/engineer→qa.md"           handoff      2-engineer   "Handoff: Engineer → QA"         "(written by Engineer agent)"
  write_placeholder "patterns/solutions.md"             pattern      any          "Solutions"                      "(append during Phase 2)"
  write_placeholder "patterns/anti-patterns.md"         pattern      any          "Anti-patterns"                  "(append during Phase 2/3)"

  run touch "$mem/architecture/decisions/.gitkeep"
  ok ".ai/memory/ created with 11 files"
}

project_init() {
  hdr "Project Init"

  if ! is_project; then
    skip "Not a project directory — skipping project init"
    info "Run from your project root to bootstrap .ai/memory/"
    return
  fi

  if [ -d "$CWD/.ai/memory" ]; then
    skip ".ai/memory/ already exists — skipping"
    return
  fi

  write_entry_files
  write_memory

  echo ""
  info "Git recommendation:"
  echo "    git add CLAUDE.md AGENTS.md WINDSURF.md AI_CONTEXT.md .ai/memory/"
  echo "    git commit -m 'chore: init AI memory'"
}

# ── main ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}AI Skill Agent — Setup${RESET}"
echo "  Repo   : $REPO"
echo "  Project: $CWD"
[ "$MODE" = "dry" ] && echo -e "  ${YELLOW}DRY RUN — no files will be created${RESET}"

case $MODE in
  global)  global_install ;;
  project) project_init ;;
  dry)     global_install; project_init ;;
  all)     global_install; project_init ;;
esac

echo ""
echo -e "${GREEN}Done.${RESET}"
echo ""
echo "Next step: run the gather-requirements skill to begin Phase 0"
echo "  In your AI tool, type: /gather-requirements"
echo "  Or open: agents/00-ba-strategist.md"
echo ""
