# Installation Guide — AI Skill Agent Workflow

Three approaches, from fastest to most flexible. Pick one based on your setup.

---

## Approach 1: Symlink (Fastest for Local Dev) ⚡

**Best for:** Single developer, local projects, frequent updates to the workflow

Creates symbolic links from your project to this library. Changes to the library appear instantly in all projects.

### macOS / Linux

\\\ash
# In your new project root:
ln -s /path/to/ai-skill-agenst/.ai .ai-workflow
ln -s /path/to/ai-skill-agenst/agents .ai-agents
ln -s /path/to/ai-skill-agenst/rules .ai-rules
ln -s /path/to/ai-skill-agenst/skills .ai-skills

# In .cursorrules or .chatgpt-instructions, reference them:
# - Load rules: .ai-rules/*.mdc
# - Load agents: .ai-agents/*.md
# - Load skills: .ai-skills/
\\\

### Windows (PowerShell, Run as Admin)

\\\powershell
# In your new project root:
New-Item -ItemType SymbolicLink -Path .ai-agents -Target "D:\AI\ai-skill-agenst\agents" -Force
New-Item -ItemType SymbolicLink -Path .ai-rules -Target "D:\AI\ai-skill-agenst\rules" -Force
New-Item -ItemType SymbolicLink -Path .ai-skills -Target "D:\AI\ai-skill-agenst\skills" -Force
\\\

**Pros:** Updates instantly, minimal disk space, easy to maintain
**Cons:** Requires admin rights (Windows), symlinks may not work on all systems

---

## Approach 2: Git Submodule (Clean & Collaborative) 🔗

**Best for:** Team projects, git-tracked configuration, pinned versions

Adds the workflow as a submodule so your team uses the same version.

\\\ash
# In your project root:
git submodule add https://github.com/YOUR_ORG/ai-skill-agenst .ai-workflow
git commit -m "feat: add AI skill agent workflow as submodule"

# Team members run (after clone):
git submodule update --init --recursive

# Update to latest workflow:
cd .ai-workflow
git pull origin main
cd ..
git add .ai-workflow
git commit -m "chore: update AI workflow to latest"
\\\

**Pros:** Version controlled, team sync, pinned at specific commit
**Cons:** Extra git commands, submodule complexity

---

## Approach 3: Copy & Embed (Most Portable) 📦

**Best for:** Standalone projects, air-gapped environments, no external dependencies

Copy the entire structure into your project.

### PowerShell (Windows)

\\\powershell
# Set this library's path
\ = "D:\AI\ai-skill-agenst"
\ = "C:\path\to\your\new\project"

# Copy structure
Copy-Item "\\agents" "\\.ai\agents" -Recurse -Force
Copy-Item "\\rules" "\\.ai\rules" -Recurse -Force
Copy-Item "\\skills" "\\.ai\skills" -Recurse -Force
Copy-Item "\\memory-templates" "\\.ai\memory-templates" -Recurse -Force

echo "✓ Workflow embedded at \\.ai\"
\\\

### Bash (macOS / Linux)

\\\ash
LIB_PATH="/path/to/ai-skill-agenst"
PROJECT_PATH="/path/to/your/new/project"

mkdir -p "\/.ai"
cp -r "\/agents" "\/.ai/"
cp -r "\/rules" "\/.ai/"
cp -r "\/skills" "\/.ai/"
cp -r "\/memory-templates" "\/.ai/"

echo "✓ Workflow embedded at \/.ai/"
\\\

**Pros:** Fully portable, no external dependencies, easy to customize per-project
**Cons:** Updates must be manual, storage duplication

---

## Approach 4: Automated Setup Script (One Command) 🚀

**Best for:** Teams, CI/CD, rapid onboarding

The \setup.ps1\ and \setup.sh\ scripts in this repo automate installation.

### Quick Usage

**Windows:**
\\\powershell
.\setup.ps1 -Approach symlink
# or
.\setup.ps1 -Approach copy
\\\

**macOS/Linux:**
\\\ash
./setup.sh --approach symlink
# or
./setup.sh --approach copy
\\\

---

## Integration with AI Tools

### Cursor IDE

Configure in \.cursor/rules\:

\\\markdown
# Load the AI workflow rules and agents

## Rules
- \.ai-rules/00-lifecycle.mdc\
- \.ai-rules/01-plan-before-code.mdc\
- \.ai-rules/02-coding-standards.mdc\
- \.ai-rules/03-security-baseline.mdc\
- \.ai-rules/04-memory-protocol.mdc\

## Agents
- \@agent .ai-agents/00-ba-strategist.md\ — for requirements
- \@agent .ai-agents/01-architect.md\ — for design
- \@agent .ai-agents/02-engineer.md\ — for implementation
- \@agent .ai-agents/03-qa-security.md\ — for review
\\\

---

## Post-Installation

After installing, initialize project memory:

\\\
Ask your AI agent: "Run the tooling/init-memory skill to bootstrap this project's .ai/memory/ directory"
\\\

Then start Phase 0:

\\\
@agent .ai-agents/00-ba-strategist.md
\\\

---

## Recommended Setup for Teams

1. Add as git submodule (once, by team lead):
   \\\ash
   git submodule add <url> .ai-workflow
   \\\

2. Each team member:
   \\\ash
   git clone <project-url>
   git submodule update --init --recursive
   \\\

3. Initialize memory and start working with the agents

See setup.ps1 and setup.sh for automated one-command installation.
