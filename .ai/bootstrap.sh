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
