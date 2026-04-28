# setup.ps1 — one command to set up AI agent workflow for any tool, any env (Windows)
# Usage (from repo root or any project):
#   .\setup.ps1            # global install + project init
#   .\setup.ps1 --global   # global install only
#   .\setup.ps1 --project  # project init only
#   .\setup.ps1 --dry-run  # preview without changes

param(
    [switch]$Global,
    [switch]$Project,
    [switch]$DryRun
)

$RepoPath  = $PSScriptRoot
$CWD       = (Get-Location).Path
$Mode      = "all"
if ($Global)  { $Mode = "global" }
if ($Project) { $Mode = "project" }
if ($DryRun)  { $Mode = "dry" }

# ── helpers ───────────────────────────────────────────────────────────────────
function Ok($msg)   { Write-Host "  [+] $msg" -ForegroundColor Green }
function Info($msg) { Write-Host "  --> $msg" -ForegroundColor Cyan }
function Skip($msg) { Write-Host "  [~] $msg" -ForegroundColor Yellow }
function Hdr($msg)  { Write-Host "`n-- $msg --" -ForegroundColor Cyan }
function Run($block) {
    if ($Mode -eq "dry") { Write-Host "    [dry] $block" }
    else { Invoke-Expression $block }
}

# ── tool detection ────────────────────────────────────────────────────────────
function Detect-Tools {
    $tools = @()
    if (Test-Path "$env:USERPROFILE\.cursor")              { $tools += "cursor" }
    if ((Test-Path "$env:USERPROFILE\.claude") -or (Get-Command "claude" -ErrorAction SilentlyContinue)) {
        $tools += "claude-code"
    }
    if (Test-Path "$env:USERPROFILE\.codeium\windsurf")    { $tools += "windsurf" }
    return $tools
}

# ── global install ────────────────────────────────────────────────────────────
function Install-Cursor {
    $base = "$env:USERPROFILE\.cursor"
    Run "New-Item -ItemType Directory -Force -Path '$base\rules','$base\agents','$base\skills' | Out-Null"
    Run "Copy-Item '$RepoPath\rules\*.mdc' -Destination '$base\rules\' -Force"
    Run "Copy-Item '$RepoPath\agents\*.md' -Destination '$base\agents\' -Force"
    Run "Copy-Item '$RepoPath\skills\*' -Destination '$base\skills\' -Recurse -Force"
    Ok "Cursor  -> $base\rules\ agents\ skills\"
}

function Install-ClaudeCode {
    $base    = "$env:USERPROFILE\.claude"
    $cmds    = "$base\commands"
    Run "New-Item -ItemType Directory -Force -Path '$cmds' | Out-Null"

    $skillFiles = Get-ChildItem "$RepoPath\skills" -Recurse -Filter "SKILL.md"
    foreach ($f in $skillFiles) {
        $skillName = $f.Directory.Name
        Run "Copy-Item '$($f.FullName)' -Destination '$cmds\$skillName.md' -Force"
    }

    $globalClaude = "$base\CLAUDE.md"
    $marker       = "## AI Memory Protocol"
    $alreadyHas   = (Test-Path $globalClaude) -and (Select-String -Path $globalClaude -Pattern $marker -Quiet)
    if ($alreadyHas) {
        Skip "Claude Code global CLAUDE.md already has memory protocol -- skipped"
    } else {
        $protocol = @'

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
'@
        if ($Mode -ne "dry") {
            Add-Content -Path $globalClaude -Value $protocol -Encoding UTF8
        } else {
            Write-Host "    [dry] append memory protocol to $globalClaude"
        }
    }

    Ok "Claude Code -> $cmds\ ($($skillFiles.Count) skills)"
}

function Install-Windsurf {
    $base = "$env:USERPROFILE\.codeium\windsurf"
    Run "New-Item -ItemType Directory -Force -Path '$base\rules','$base\agents' | Out-Null"
    if (Test-Path "$RepoPath\rules\*.mdc") {
        Run "Copy-Item '$RepoPath\rules\*.mdc' -Destination '$base\rules\' -Force"
    }
    if (Test-Path "$RepoPath\agents\*.md") {
        Run "Copy-Item '$RepoPath\agents\*.md' -Destination '$base\agents\' -Force"
    }
    Ok "Windsurf  -> $base\rules\ agents\"
}

function Global-Install {
    Hdr "Global Install"
    $tools = Detect-Tools

    if ($tools.Count -eq 0) {
        Skip "No AI tools detected (Cursor / Claude Code / Windsurf)"
        Run "New-Item -ItemType Directory -Force -Path '$env:USERPROFILE\.ai-skill-agent' | Out-Null"
        Run "Copy-Item '$RepoPath\*' -Destination '$env:USERPROFILE\.ai-skill-agent\' -Recurse -Force"
        Ok "Fallback  -> ~/.ai-skill-agent\ (library copy)"
        return
    }

    foreach ($tool in $tools) {
        switch ($tool) {
            "cursor"      { Install-Cursor }
            "claude-code" { Install-ClaudeCode }
            "windsurf"    { Install-Windsurf }
        }
    }
}

# ── project init ──────────────────────────────────────────────────────────────
function Is-Project {
    return (Test-Path "$CWD\.git") -or
           (Test-Path "$CWD\package.json") -or
           (Test-Path "$CWD\pyproject.toml") -or
           (Test-Path "$CWD\go.mod") -or
           (Test-Path "$CWD\Cargo.toml")
}

$EntryContent = @'
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
'@

function Write-EntryFiles {
    foreach ($name in @("CLAUDE.md", "AGENTS.md", "WINDSURF.md", "AI_CONTEXT.md")) {
        $path = "$CWD\$name"
        if (Test-Path $path) {
            Skip "$name already exists -- skipped"
        } elseif ($Mode -eq "dry") {
            Write-Host "    [dry] create $name"
        } else {
            Set-Content $path -Value $EntryContent -Encoding UTF8
            Ok "Created $name"
        }
    }
}

function Write-Placeholder($file, $type, $phase, $title, $skill) {
    $content = @"
---
type: $type
phase: $phase
last-updated: —
updated-by: —
status: draft
---

# $title — not yet written

Run ``$skill`` skill to populate this file.
"@
    if ($Mode -eq "dry") {
        Write-Host "    [dry] create .ai\memory\$file"
    } else {
        Set-Content "$MemRoot\$file" -Value $content -Encoding UTF8
    }
}

function Write-Memory {
    $projectName = Split-Path $CWD -Leaf
    $script:MemRoot = "$CWD\.ai\memory"

    $dirs = @("$MemRoot\context", "$MemRoot\architecture\decisions", "$MemRoot\handoffs", "$MemRoot\patterns")
    foreach ($d in $dirs) { Run "New-Item -ItemType Directory -Force -Path '$d' | Out-Null" }

    $indexContent = @"
# Memory Index — $projectName

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
"@

    if ($Mode -eq "dry") {
        Write-Host "    [dry] create .ai\memory\INDEX.md"
    } else {
        Set-Content "$MemRoot\INDEX.md" -Value $indexContent -Encoding UTF8
    }

    Write-Placeholder "context\requirements.md"           "context"      "0-ba"        "Requirements"                   "gather-requirements"
    Write-Placeholder "context\tech-stack.md"             "context"      "1-architect" "Tech Stack"                     "system-design"
    Write-Placeholder "context\non-functional.md"         "context"      "0-ba"        "Non-Functional Requirements"    "gather-requirements"
    Write-Placeholder "architecture\module-map.md"        "architecture" "1-architect" "Module Map"                     "system-design"
    Write-Placeholder "architecture\api-contracts.md"     "architecture" "1-architect" "API Contracts"                  "api-design"
    Write-Placeholder "handoffs\ba-to-architect.md"       "handoff"      "0-ba"        "Handoff: BA to Architect"       "write-requirements-memory"
    Write-Placeholder "handoffs\architect-to-engineer.md" "handoff"      "1-architect" "Handoff: Architect to Engineer" "system-design"
    Write-Placeholder "handoffs\engineer-to-qa.md"        "handoff"      "2-engineer"  "Handoff: Engineer to QA"        "(written by Engineer agent)"
    Write-Placeholder "patterns\solutions.md"             "pattern"      "any"         "Solutions"                      "(append during Phase 2)"
    Write-Placeholder "patterns\anti-patterns.md"         "pattern"      "any"         "Anti-patterns"                  "(append during Phase 2/3)"

    if ($Mode -ne "dry") {
        "" | Set-Content "$MemRoot\architecture\decisions\.gitkeep" -Encoding UTF8
    }
    Ok ".ai\memory\ created with 11 files"
}

function Project-Init {
    Hdr "Project Init"

    if (-not (Is-Project)) {
        Skip "Not a project directory -- skipping project init"
        Info "Run from your project root to bootstrap .ai\memory\"
        return
    }

    if (Test-Path "$CWD\.ai\memory") {
        Skip ".ai\memory\ already exists -- skipping"
        return
    }

    Write-EntryFiles
    Write-Memory

    Write-Host ""
    Info "Git recommendation:"
    Write-Host "    git add CLAUDE.md AGENTS.md WINDSURF.md AI_CONTEXT.md .ai/memory/"
    Write-Host "    git commit -m 'chore: init AI memory'"
}

# ── main ──────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "AI Skill Agent — Setup" -ForegroundColor Cyan
Write-Host "  Repo   : $RepoPath"
Write-Host "  Project: $CWD"
if ($Mode -eq "dry") { Write-Host "  DRY RUN -- no files will be created" -ForegroundColor Yellow }

switch ($Mode) {
    "global"  { Global-Install }
    "project" { Project-Init }
    default   { Global-Install; Project-Init }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host ""
Write-Host "Next step: run the gather-requirements skill to begin Phase 0"
Write-Host "  In your AI tool, type: /gather-requirements"
Write-Host "  Or open: agents/00-ba-strategist.md"
Write-Host ""
