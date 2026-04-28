#!/usr/bin/env bash
# install-global.sh
# One-time global install for Cursor (macOS / Linux)
# Usage: bash path/to/install-global.sh
# Or from repo root: bash scripts/install-global.sh

set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURSOR_HOME="$HOME/.cursor"

echo ""
echo "AI Skill Agent — Global Install (Cursor / macOS/Linux)"
echo "Repo  : $REPO"
echo "Target: $CURSOR_HOME"
echo ""

# Rules
mkdir -p "$CURSOR_HOME/rules"
cp "$REPO"/rules/*.mdc "$CURSOR_HOME/rules/"
echo "  [rules] copied $(ls "$REPO/rules/"*.mdc | wc -l | tr -d ' ') .mdc files"

# Skills
mkdir -p "$CURSOR_HOME/skills"
cp -r "$REPO/skills/." "$CURSOR_HOME/skills/"
echo "  [skills] copied skills/ tree"

# Agents
mkdir -p "$CURSOR_HOME/agents"
cp "$REPO"/agents/*.md "$CURSOR_HOME/agents/"
echo "  [agents] copied 4 agent files"

# Memory templates
mkdir -p "$CURSOR_HOME/memory-templates"
cp "$REPO"/memory-templates/* "$CURSOR_HOME/memory-templates/"
echo "  [templates] copied memory-templates/"

echo ""
echo "Done. Rules and skills are now active in all Cursor workspaces."
echo ""
echo "Next: run scripts/init-project.sh inside each new project to bootstrap .ai/memory/"
