#!/bin/bash
# setup-workflow.sh
# Fast installation for AI Skill Agent Workflow (macOS/Linux)
# Usage: ./setup-workflow.sh [--approach symlink|copy] [--workflow-path <path>]

set -e

APPROACH="symlink"
WORKFLOW_PATH=""
NO_MEMORY=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --approach)
            APPROACH="$2"
            shift 2
            ;;
        --workflow-path)
            WORKFLOW_PATH="$2"
            shift 2
            ;;
        --no-memory)
            NO_MEMORY=1
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Auto-detect workflow path
if [ -z "$WORKFLOW_PATH" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -d "$SCRIPT_DIR/agents" ]; then
        WORKFLOW_PATH="$SCRIPT_DIR"
    elif [ -d "$SCRIPT_DIR/../agents" ]; then
        WORKFLOW_PATH="$(cd "$SCRIPT_DIR/.." && pwd)"
    else
        echo "❌ Workflow path not found. Specify with --workflow-path" >&2
        exit 1
    fi
fi

WORKFLOW_PATH="$(cd "$WORKFLOW_PATH" && pwd)"
PROJECT_PATH="$(pwd)"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  AI Skill Agent Workflow — Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Workflow path: $WORKFLOW_PATH"
echo "Project path:  $PROJECT_PATH"
echo "Approach:      $APPROACH"
echo ""

# Validate workflow structure
for dir in agents rules skills; do
    if [ ! -d "$WORKFLOW_PATH/$dir" ]; then
        echo "❌ Missing: $WORKFLOW_PATH/$dir" >&2
        exit 1
    fi
done

echo "✓ Workflow structure valid"
echo ""

# Setup based on approach
case $APPROACH in
    symlink)
        echo "Setting up symbolic links..."
        echo ""
        
        ln -sf "$WORKFLOW_PATH/agents" ".ai-agents"
        echo "  ✓ .ai-agents → $WORKFLOW_PATH/agents"
        
        ln -sf "$WORKFLOW_PATH/rules" ".ai-rules"
        echo "  ✓ .ai-rules → $WORKFLOW_PATH/rules"
        
        ln -sf "$WORKFLOW_PATH/skills" ".ai-skills"
        echo "  ✓ .ai-skills → $WORKFLOW_PATH/skills"
        
        echo ""
        echo "✓ Symlinks created successfully"
        LOAD_PREFIX=".ai"
        ;;
    
    copy)
        echo "Copying workflow files..."
        echo ""
        
        mkdir -p .ai
        
        cp -r "$WORKFLOW_PATH/agents" .ai/agents
        echo "  ✓ agents/ copied"
        
        cp -r "$WORKFLOW_PATH/rules" .ai/rules
        echo "  ✓ rules/ copied"
        
        cp -r "$WORKFLOW_PATH/skills" .ai/skills
        echo "  ✓ skills/ copied"
        
        cp -r "$WORKFLOW_PATH/memory-templates" .ai/memory-templates
        echo "  ✓ memory-templates/ copied"
        
        echo ""
        echo "✓ Workflow copied to .ai/"
        LOAD_PREFIX=".ai"
        ;;
    
    *)
        echo "❌ Invalid approach: $APPROACH (use: symlink or copy)" >&2
        exit 1
        ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Quick start:"
echo ""
echo "  1. Configure your AI tool to load from:"
echo "     • Rules: $LOAD_PREFIX-rules/*.mdc"
echo "     • Agents: $LOAD_PREFIX-agents/*.md"
echo "     • Skills: $LOAD_PREFIX-skills/"
echo ""

if [ $NO_MEMORY -eq 0 ]; then
    echo "  2. Initialize memory:"
    echo "     > Ask AI: 'run tooling/init-memory'"
    echo ""
    echo "  3. Start Phase 0:"
    echo "     > @agent $LOAD_PREFIX-agents/00-ba-strategist.md"
else
    echo "  2. Start Phase 0:"
    echo "     > @agent $LOAD_PREFIX-agents/00-ba-strategist.md"
fi

echo ""
echo "Docs: See INSTALLATION.md for more options"
echo ""
