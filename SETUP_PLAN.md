# One-Command Setup Plan

## Goal
One command handles everything: global install to all detected AI tools + project memory init.
Works on any OS, any AI tool, no manual sequencing.

## Command interface

```bash
# Mac / Linux / WSL
bash setup.sh

# Windows (native PowerShell)
.\setup.ps1
```

Optional flags (same for both):
```
--global    install to AI tool config dirs only (skip project init)
--project   init project memory only (skip global install)
--dry-run   print what would happen, make no changes
```

## What the script does (in order)

### Step 1 — Detect installed AI tools
| Tool | Detection | Global config target |
|------|-----------|---------------------|
| Cursor | `~/.cursor/` exists | `~/.cursor/rules/`, `agents/`, `skills/` |
| Claude Code | `~/.claude/` exists OR `claude` in PATH | `~/.claude/commands/` (skills as slash commands) |
| Windsurf | `~/.codeium/windsurf/` exists | `~/.codeium/windsurf/rules/` |
| Fallback | always | `~/.ai-skill-agent/` (library copy) |

### Step 2 — Global install (per detected tool)

**Cursor:**
- Copy `rules/*.mdc` → `~/.cursor/rules/`
- Copy `agents/*.md` → `~/.cursor/agents/`
- Copy `skills/` tree → `~/.cursor/skills/`

**Claude Code:**
- Copy each `skills/**/SKILL.md` → `~/.claude/commands/<skill-name>.md`
- Write memory protocol to `~/.claude/CLAUDE.md` (append if exists)

**Windsurf:**
- Copy `rules/*.mdc` → `~/.codeium/windsurf/rules/`
- Copy `agents/*.md` → `~/.codeium/windsurf/agents/`

**Fallback (no tool detected):**
- Copy repo to `~/.ai-skill-agent/` as a library for future use

### Step 3 — Project init (if in a project directory)
Detected by presence of: `.git`, `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`

- Skip if `.ai/memory/` already exists
- Create `CLAUDE.md`, `AGENTS.md`, `WINDSURF.md`, `AI_CONTEXT.md` at project root
- Create full `.ai/memory/` structure with placeholder files

### Step 4 — Report
Print a table: which tools were found, what was installed, what was skipped.
End with: "Next step: run gather-requirements to begin Phase 0"

## Files created / modified

| New file | Replaces |
|----------|---------|
| `setup.sh` | `scripts/install-global.sh` + `scripts/init-project.sh` + `setup-workflow.sh` |
| `setup.ps1` | `scripts/install-global.ps1` + `scripts/init-project.ps1` + `setup-workflow.ps1` |

Old scripts kept for backwards compatibility — not deleted.
