# Installation Guide — AI Skill Agent Workflow

Three approaches, from fastest to most flexible. Pick one based on your setup.

---

## Approach 1: Symlink (Fastest for Local Dev) ⚡

**Best for:** Single developer, local projects, frequent updates to the workflow

Creates symbolic links from your project to this library. Changes to the library appear instantly in all projects.

### macOS / Linux

```bash
# In your new project root:
ln -s /path/to/ai-skill-agenst/.ai .ai-workflow
ln -s /path/to/ai-skill-agenst/agents .ai-agents
ln -s /path/to/ai-skill-agenst/rules .ai-rules
ln -s /path/to/ai-skill-agenst/skills .ai-skills

# In .cursorrules or .chatgpt-instructions, reference them:
# - Load rules: .ai-rules/*.mdc
# - Load agents: .ai-agents/*.md
# - Load skills: .ai-skills/
```

### Windows (PowerShell, Run as Admin)

```powershell
# In your new project root:
New-Item -ItemType SymbolicLink -Path .ai-agents -Target "D:\AI\ai-skill-agenst\agents" -Force
New-Item -ItemType SymbolicLink -Path .ai-rules -Target "D:\AI\ai-skill-agenst\rules" -Force
New-Item -ItemType SymbolicLink -Path .ai-skills -Target "D:\AI\ai-skill-agenst\skills" -Force
```

**Pros:** Updates instantly, minimal disk space, easy to maintain
**Cons:** Requires admin rights (Windows), symlinks may not work on all systems

---

## Approach 2: Git Submodule (Clean & Collaborative) 🔗

**Best for:** Team projects, git-tracked configuration, pinned versions

Adds the workflow as a submodule so your team uses the same version.

```bash
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
```

**Pros:** Version controlled, team sync, pinned at specific commit
**Cons:** Extra git commands, submodule complexity

---

## Approach 3: Copy & Embed (Most Portable) 📦

**Best for:** Standalone projects, air-gapped environments, no external dependencies

Copy the entire structure into your project.

### PowerShell (Windows)

```powershell
# Set this library's path
$LIB_PATH = "D:\AI\ai-skill-agenst"
$PROJECT_PATH = "C:\path\to\your\new\project"

# Copy structure
Copy-Item "$LIB_PATH\agents" "$PROJECT_PATH\.ai\agents" -Recurse -Force
Copy-Item "$LIB_PATH\rules" "$PROJECT_PATH\.ai\rules" -Recurse -Force
Copy-Item "$LIB_PATH\skills" "$PROJECT_PATH\.ai\skills" -Recurse -Force
Copy-Item "$LIB_PATH\memory-templates" "$PROJECT_PATH\.ai\memory-templates" -Recurse -Force

echo "✓ Workflow embedded at $PROJECT_PATH\.ai\"
```

### Bash (macOS / Linux)

```bash
LIB_PATH="/path/to/ai-skill-agenst"
PROJECT_PATH="/path/to/your/new/project"

mkdir -p "$PROJECT_PATH/.ai"
cp -r "$LIB_PATH/agents" "$PROJECT_PATH/.ai/"
cp -r "$LIB_PATH/rules" "$PROJECT_PATH/.ai/"
cp -r "$LIB_PATH/skills" "$PROJECT_PATH/.ai/"
cp -r "$LIB_PATH/memory-templates" "$PROJECT_PATH/.ai/"

echo "✓ Workflow embedded at $PROJECT_PATH/.ai/"
```

**Pros:** Fully portable, no external dependencies, easy to customize per-project
**Cons:** Updates must be manual, storage duplication

---

## Approach 4: Automated Setup Script (One Command) 🚀

**Best for:** Teams, CI/CD, rapid onboarding

### `setup-workflow.ps1` (PowerShell)

Save this in your project root:

```powershell
param(
    [string]$WorkflowPath = "D:\AI\ai-skill-agenst",
    [string]$Approach = "symlink"  # or "copy"
)

if (-not (Test-Path $WorkflowPath)) {
    Write-Error "Workflow not found at $WorkflowPath"
    exit 1
}

$ProjectPath = Get-Location

switch ($Approach) {
    "symlink" {
        Write-Host "Setting up symlinks..."
        New-Item -ItemType SymbolicLink -Path ".ai-agents" -Target "$WorkflowPath\agents" -Force | Out-Null
        New-Item -ItemType SymbolicLink -Path ".ai-rules" -Target "$WorkflowPath\rules" -Force | Out-Null
        New-Item -ItemType SymbolicLink -Path ".ai-skills" -Target "$WorkflowPath\skills" -Force | Out-Null
        Write-Host "✓ Symlinks created" -ForegroundColor Green
    }
    "copy" {
        Write-Host "Copying workflow..."
        mkdir ".ai" -ErrorAction SilentlyContinue | Out-Null
        Copy-Item "$WorkflowPath\agents" ".ai\agents" -Recurse -Force
        Copy-Item "$WorkflowPath\rules" ".ai\rules" -Recurse -Force
        Copy-Item "$WorkflowPath\skills" ".ai\skills" -Recurse -Force
        Copy-Item "$WorkflowPath\memory-templates" ".ai\memory-templates" -Recurse -Force
        Write-Host "✓ Workflow copied to .ai/" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Configure your AI tool to load:"
Write-Host "     - Rules from: .ai-rules/*.mdc  (or .ai/rules/*.mdc if using copy)"
Write-Host "     - Agents from: .ai-agents/*.md (or .ai/agents/*.md if using copy)"
Write-Host "     - Skills path: .ai-skills/      (or .ai/skills/ if using copy)"
Write-Host "  2. Run the init-memory skill: phase-0-requirements/gather-requirements"
Write-Host "  3. Start with: agents/00-ba-strategist.md"
```

**Usage:**

```powershell
# Default (symlink):
.\setup-workflow.ps1

# Copy instead:
.\setup-workflow.ps1 -Approach copy

# Custom library path:
.\setup-workflow.ps1 -WorkflowPath "C:\custom\path\ai-skill-agenst"
```

---

## Integration with AI Tools

### Cursor IDE

Add to `.cursor/rules` (in your project):

```markdown
# Load the AI workflow rules and agents

## Rules
- `.ai-rules/00-lifecycle.mdc`
- `.ai-rules/01-plan-before-code.mdc`
- `.ai-rules/02-coding-standards.mdc`
- `.ai-rules/03-security-baseline.mdc`
- `.ai-rules/04-memory-protocol.mdc`

## Agents
Start any request with: `@agent <agent-file>`
- `@agent .ai-agents/00-ba-strategist.md` — for requirements
- `@agent .ai-agents/01-architect.md` — for design
- `@agent .ai-agents/02-engineer.md` — for implementation
- `@agent .ai-agents/03-qa-security.md` — for review

## Skills Location
- `.ai-skills/` — all reusable skills organized by phase
```

### Claude Code (in `.cursorignore` / `.claude-ignore`)

Exclude memory and template dirs from Claude's initial scan (to save tokens):

```
.ai/memory/
memory-templates/
.ai-skills/**/*.md  # Optional: exclude if you prefer to load manually
```

### VS Code with Copilot

Create `.vscode/settings.json`:

```json
{
  "copilot.advanced": {
    "systemPrompt": "Use the agents, rules, and skills in .ai-agents/, .ai-rules/, .ai-skills/ directories for all coding tasks. Start with .ai-agents/00-ba-strategist.md for requirements."
  }
}
```

---

## Post-Installation Checklist

After installing, verify the setup:

```powershell
# Verify structure exists
dir .ai-agents, .ai-rules, .ai-skills

# Or if using copy approach:
# dir .ai\agents, .ai\rules, .ai\skills

# Initialize project memory
# (Ask your AI agent to run: tooling/init-memory)
```

### Initialize Project Memory

In your AI tool, ask:

> **Run the `tooling/init-memory` skill to bootstrap this project's `.ai/memory/` directory.**

This creates the complete memory structure where agents will store requirements, architecture, and decisions.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Symlink permission denied (Windows) | Run PowerShell as Administrator |
| Rules not loading in Cursor | Check `.cursor/rules` file path is correct |
| Skills not found | Verify `.ai-skills/` exists and contains subdirectories |
| Memory not initializing | Manually create `.ai/memory/` and run `tooling/init-memory` |
| Submodule not updating | Run `git submodule update --init --recursive` |

---

## Recommended Setup for Teams

For the smoothest team experience:

```bash
# 1. Add as git submodule (once, by team lead)
git submodule add <url> .ai-workflow

# 2. Each team member:
git clone <project-url>
git submodule update --init --recursive

# 3. Configure AI tool (`.cursor/rules` or equivalent):
# Point to: .ai-workflow/agents/, .ai-workflow/rules/, .ai-workflow/skills/

# 4. Initialize memory:
# Ask AI: "Run tooling/init-memory"

# Then start Phase 0:
# Ask AI: "@agent .ai-workflow/agents/00-ba-strategist.md"
```

---

## File Placement Reference

**If using symlinks or `.ai-workflow/` submodule:**
```
project-root/
├── .ai-workflow/          ← This entire library
│   ├── agents/
│   ├── rules/
│   ├── skills/
│   └── memory-templates/
├── .ai/memory/            ← Created by tooling/init-memory
├── src/
└── package.json
```

**If using embedded copy:**
```
project-root/
├── .ai/
│   ├── agents/            ← Copied from library
│   ├── rules/             ← Copied from library
│   ├── skills/            ← Copied from library
│   ├── memory-templates/  ← Copied from library
│   └── memory/            ← Created by tooling/init-memory
├── src/
└── package.json
```

---

## Updates & Maintenance

### With Symlinks
```bash
cd /path/to/ai-skill-agenst
git pull origin main
# Changes appear instantly in all projects
```

### With Submodule
```bash
git submodule update --remote --merge
git commit -m "chore: update workflow submodule"
```

### With Embedded Copy
```bash
# Re-run setup script to pull latest:
.\setup-workflow.ps1 -Approach copy -WorkflowPath <path-to-latest>
```

---

## Next Steps

1. **Pick an installation approach** (symlink recommended for speed)
2. **Run setup** (setup script or manual commands)
3. **Initialize memory** (ask AI: `tooling/init-memory`)
4. **Start Phase 0** (ask AI: `@agent agents/00-ba-strategist.md`)

Happy building! 🚀
