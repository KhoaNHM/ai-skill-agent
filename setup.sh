#!/usr/bin/env bash
# setup.sh — one command to set up AI agent workflow for any tool, any env
# Usage:
#   bash /path/to/setup.sh                        # global install + project init
#   bash /path/to/setup.sh --global               # global install only
#   bash /path/to/setup.sh --project              # project init only
#   bash /path/to/setup.sh --dry-run              # preview (combine with --global or --project)
#   bash /path/to/setup.sh --dir <path>           # target a specific project directory
#   bash /path/to/setup.sh --help                 # show usage

set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CWD="$(pwd)"
MODE="all"
DRY_RUN=false
DIR_FLAG=false

# ── help (before arg parse so it exits cleanly) ───────────────────────────────
if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  echo "Usage: bash setup.sh [OPTIONS]"
  echo ""
  echo "  (no flags)          global install + project init"
  echo "  --global            install skills to AI tools only"
  echo "  --project           init .ai/memory/ in project only"
  echo "  --dry-run           preview without making changes (combine with --global or --project)"
  echo "  --dir <path>        target project directory (default: current directory)"
  echo "  -h, --help          show this message"
  echo ""
  echo "  Re-run --global at any time to update installed skills."
  echo "  New team members: run 'bash .ai/bootstrap.sh' after cloning the project."
  exit 0
fi

# ── arg parse ─────────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    --global)   MODE="global" ;;
    --project)  MODE="project" ;;
    --dry-run)  DRY_RUN=true ;;
    --dir)
      shift
      if [ ! -d "$1" ]; then
        echo "Error: --dir path does not exist: $1" >&2
        exit 1
      fi
      CWD="$(cd "$1" && pwd)"
      DIR_FLAG=true
      ;;
    --dir=*)
      _dp="${1#*=}"
      if [ ! -d "$_dp" ]; then
        echo "Error: --dir path does not exist: $_dp" >&2
        exit 1
      fi
      CWD="$(cd "$_dp" && pwd)"
      DIR_FLAG=true
      ;;
  esac
  shift
done

# ── colour helpers ────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RESET='\033[0m'
ok()   { echo -e "${GREEN}  ✓${RESET} $*"; }
info() { echo -e "${CYAN}  →${RESET} $*"; }
skip() { echo -e "${YELLOW}  ~${RESET} $*"; }
hdr()  { echo -e "\n${CYAN}── $* ──${RESET}"; }
run()  {
  if [ "$DRY_RUN" = true ]; then
    echo "    [dry] $*"
  else
    eval "$@"
  fi
}

# Fix 4: warn if --dir has no effect
if [ "$DIR_FLAG" = true ] && [ "$MODE" = "global" ]; then
  skip "--dir has no effect with --global (global install ignores project path)"
fi

# ── tool detection ────────────────────────────────────────────────────────────
detect_tools() {
  TOOLS=()
  if [ -d "$HOME/.cursor" ]; then TOOLS+=("cursor"); fi
  if [ -d "$HOME/.claude" ] || command -v claude &>/dev/null 2>&1; then TOOLS+=("claude-code"); fi
  if [ -d "$HOME/.codeium/windsurf" ]; then TOOLS+=("windsurf"); fi
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

  local count=0
  while IFS= read -r skill_file; do
    skill_name="$(basename "$(dirname "$skill_file")")"
    run cp "$skill_file" "$base/commands/$skill_name.md"
    count=$((count + 1))
  done < <(find "$REPO/skills" -name "SKILL.md")

  # Append memory protocol to global CLAUDE.md (idempotent)
  local marker="## AI Memory Protocol"
  if [ "$DRY_RUN" != true ] && grep -q "$marker" "$base/CLAUDE.md" 2>/dev/null; then
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

  # Always mirror repo to ~/.ai-skill-agent/ so bootstrap.sh has a stable path to call back
  run mkdir -p "$HOME/.ai-skill-agent"
  run cp -r "$REPO/." "$HOME/.ai-skill-agent/"
  ok "Mirrored  → ~/.ai-skill-agent/ (bootstrap target)"

  detect_tools

  if [ ${#TOOLS[@]} -eq 0 ]; then
    skip "No AI tools detected (Cursor / Claude Code / Windsurf) — library copy only"
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
  [ -f "$CWD/go.mod" ]       || [ -f "$CWD/Cargo.toml" ]     || \
  [ -f "$CWD/build.sbt" ]    || [ -f "$CWD/pom.xml" ]        || \
  [ -f "$CWD/build.gradle" ] || [ -f "$CWD/build.gradle.kts" ] || \
  [ -f "$CWD/Makefile" ]     || [ -f "$CWD/CMakeLists.txt" ] || \
  [ -f "$CWD/Dockerfile" ]
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

  # marker used in project entry files (single # — different from global CLAUDE.md)
  local marker="# AI Memory Protocol"

  for f in CLAUDE.md AGENTS.md WINDSURF.md AI_CONTEXT.md; do
    if [ -f "$CWD/$f" ]; then
      # file exists — check if protocol is already present
      if [ "$DRY_RUN" != true ] && grep -q "$marker" "$CWD/$f" 2>/dev/null; then
        skip "$f already has memory protocol — skipped"
      else
        if [ "$DRY_RUN" = true ]; then
          echo "    [dry] append memory protocol to existing $f"
        else
          printf '\n%s\n' "$content" >> "$CWD/$f"
          ok "Appended memory protocol to $f"
        fi
      fi
    else
      if [ "$DRY_RUN" = true ]; then
        echo "    [dry] create $f"
      else
        printf '%s\n' "$content" > "$CWD/$f"
        ok "Created $f"
      fi
    fi
  done
}

write_bootstrap() {
  local dest="$CWD/.ai/bootstrap.sh"
  if [ -f "$dest" ]; then
    skip ".ai/bootstrap.sh already exists — skipped"
    return
  fi
  if [ "$DRY_RUN" = true ]; then
    echo "    [dry] create .ai/bootstrap.sh"
    return
  fi
  cat > "$dest" <<'BOOTEOF'
#!/usr/bin/env bash
# Run this once after cloning this project to install AI skill agents on your machine.
# Usage: bash .ai/bootstrap.sh

set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RESET='\033[0m'
ok()   { echo -e "${GREEN}  ✓${RESET} $*"; }
info() { echo -e "${CYAN}  →${RESET} $*"; }
skip() { echo -e "${YELLOW}  ~${RESET} $*"; }

echo ""
echo -e "${CYAN}AI Skill Agent — Bootstrap${RESET}"
echo ""

# Already installed?
if [ -f "$HOME/.claude/commands/gather-requirements.md" ]; then
  ok "Skills already installed in ~/.claude/commands/"
  echo ""
  info "To update skills, re-run: bash ~/.ai-skill-agent/setup.sh --global"
  exit 0
fi

# setup.sh --global always mirrors itself to ~/.ai-skill-agent/ — check there first
SETUP="$HOME/.ai-skill-agent/setup.sh"

if [ ! -f "$SETUP" ] && [ -n "${SKILL_AGENT_DIR:-}" ]; then
  SETUP="$SKILL_AGENT_DIR/setup.sh"
fi

if [ -f "$SETUP" ]; then
  info "Running: bash $SETUP --global"
  bash "$SETUP" --global
  ok "Done. Skills installed globally."
else
  echo "Could not find setup.sh at ~/.ai-skill-agent/setup.sh"
  echo ""
  echo "Steps to install:"
  echo "  1. Clone the repo:"
  echo "       git clone <ai-skill-agenst-url> ~/ai-skill-agenst"
  echo ""
  echo "  2. Run global install (this also sets up ~/.ai-skill-agent/ for future bootstraps):"
  echo "       bash ~/ai-skill-agenst/setup.sh --global"
  echo ""
  echo "  Or point directly to an existing clone:"
  echo "       SKILL_AGENT_DIR=/path/to/ai-skill-agenst bash .ai/bootstrap.sh"
fi
BOOTEOF
  chmod +x "$dest"
  ok ".ai/bootstrap.sh created (commit this for new team members)"
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

  if [ "$DRY_RUN" != true ]; then
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

  write_placeholder() {
    local file="$1" type="$2" phase="$3" title="$4" skill="$5"
    if [ "$DRY_RUN" = true ]; then
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

  # Always ensure discussions dir exists (even if memory already set up)
  if [ ! -d "$CWD/.ai/discussions" ] || [ "$DRY_RUN" = true ]; then
    run mkdir -p "$CWD/.ai/discussions/summaries"
    if [ "$DRY_RUN" != true ] && [ -d "$CWD/.ai/discussions" ]; then
      ok ".ai/discussions/ created"
    fi
  fi

  if [ -d "$CWD/.ai/memory" ]; then
    skip ".ai/memory/ already exists — skipping memory init"
    write_entry_files
    write_bootstrap
    return
  fi

  write_entry_files
  write_memory
  write_bootstrap

  echo ""
  info "Git recommendation:"
  echo "    git add CLAUDE.md AGENTS.md WINDSURF.md AI_CONTEXT.md .ai/"
  echo "    git commit -m 'chore: init AI memory'"
}

# ── main ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}AI Skill Agent — Setup${RESET}"
echo "  Repo   : $REPO"
echo "  Project: $CWD"
[ "$DIR_FLAG" = true ]   && echo -e "  ${CYAN}(--dir flag used)${RESET}"
[ "$DRY_RUN" = true ]    && echo -e "  ${YELLOW}DRY RUN — no files will be created${RESET}"

case $MODE in
  global)  global_install ;;
  project) project_init ;;
  all)     global_install; project_init ;;
esac

echo ""
echo -e "${GREEN}Done.${RESET}"
echo ""
echo "Next step: run the gather-requirements skill to begin Phase 0"
echo "  In your AI tool, type: /gather-requirements"
echo "  Or open: agents/00-ba-strategist.md"
echo ""
