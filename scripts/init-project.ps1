# init-project.ps1
# Bootstrap .ai/memory/ in the current project (Windows)
# Run from your project root: powershell -ExecutionPolicy Bypass -File path\to\init-project.ps1

param(
    [string]$ProjectRoot = (Get-Location).Path,
    [string]$TemplatesPath = "$env:USERPROFILE\.cursor\memory-templates"
)

# Fallback: look for templates next to this script
if (-not (Test-Path $TemplatesPath)) {
    $TemplatesPath = "$PSScriptRoot\..\memory-templates"
}
$TemplatesPath = Resolve-Path $TemplatesPath

$MemoryRoot = "$ProjectRoot\.ai\memory"

Write-Host ""
Write-Host "AI Skill Agent — Project Memory Init" -ForegroundColor Cyan
Write-Host "Project: $ProjectRoot"
Write-Host "Memory : $MemoryRoot"
Write-Host ""

if (Test-Path $MemoryRoot) {
    Write-Host "  .ai/memory/ already exists — skipping init." -ForegroundColor Yellow
    Write-Host "  Delete .ai/memory/ and re-run to reset."
    exit 0
}

# Create directory structure
$dirs = @(
    "$MemoryRoot\context",
    "$MemoryRoot\architecture\decisions",
    "$MemoryRoot\handoffs",
    "$MemoryRoot\patterns"
)
foreach ($d in $dirs) {
    New-Item -ItemType Directory -Force -Path $d | Out-Null
}

# INDEX.md
@"
# Memory Index — $(Split-Path $ProjectRoot -Leaf)

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
"@ | Set-Content "$MemoryRoot\INDEX.md" -Encoding UTF8

# Placeholder files
$placeholders = @(
    @{ path="context\requirements.md";           type="context";      phase="0-ba";         title="Requirements";                skill="gather-requirements" },
    @{ path="context\tech-stack.md";             type="context";      phase="1-architect";  title="Tech Stack";                  skill="system-design" },
    @{ path="context\non-functional.md";         type="context";      phase="0-ba";         title="Non-Functional Requirements"; skill="gather-requirements" },
    @{ path="architecture\module-map.md";        type="architecture"; phase="1-architect";  title="Module Map";                  skill="system-design" },
    @{ path="architecture\api-contracts.md";     type="architecture"; phase="1-architect";  title="API Contracts";               skill="api-design" },
    @{ path="handoffs\ba-to-architect.md";       type="handoff";      phase="0-ba";         title="Handoff: BA to Architect";    skill="write-requirements-memory" },
    @{ path="handoffs\architect-to-engineer.md"; type="handoff";      phase="1-architect";  title="Handoff: Architect to Engineer"; skill="system-design" },
    @{ path="handoffs\engineer-to-qa.md";        type="handoff";      phase="2-engineer";   title="Handoff: Engineer to QA";     skill="(written by Engineer)" },
    @{ path="patterns\solutions.md";             type="pattern";      phase="any";          title="Solutions";                   skill="(append during Phase 2)" },
    @{ path="patterns\anti-patterns.md";         type="pattern";      phase="any";          title="Anti-patterns";               skill="(append during Phase 2/3)" }
)

foreach ($p in $placeholders) {
    $content = @"
---
type: $($p.type)
phase: $($p.phase)
last-updated: —
updated-by: —
status: draft
---

# $($p.title) — not yet written

Run ``$($p.skill)`` skill to populate this file.
"@
    Set-Content "$MemoryRoot\$($p.path)" -Value $content -Encoding UTF8
    Write-Host "  [created] .ai/memory/$($p.path)" -ForegroundColor Green
}

# .gitkeep for decisions/
"" | Set-Content "$MemoryRoot\architecture\decisions\.gitkeep" -Encoding UTF8

Write-Host ""
Write-Host "Done. .ai/memory/ created with 11 files." -ForegroundColor Cyan
Write-Host ""
Write-Host "Recommended: commit this to git so decisions are version-controlled." -ForegroundColor Yellow
Write-Host "  git add .ai/memory/"
Write-Host "  git commit -m 'chore: init AI memory'"
Write-Host ""
Write-Host "Next step: start Phase 0 with agents/00-ba-strategist.md" -ForegroundColor Yellow
