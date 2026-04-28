# install-global.ps1
# One-time global install for Cursor (Windows)
# Run from any directory: powershell -ExecutionPolicy Bypass -File path\to\install-global.ps1

param(
    [string]$RepoPath = $PSScriptRoot + "\.."
)

$RepoPath = Resolve-Path $RepoPath
$CursorHome = "$env:USERPROFILE\.cursor"

Write-Host ""
Write-Host "AI Skill Agent — Global Install (Cursor / Windows)" -ForegroundColor Cyan
Write-Host "Repo : $RepoPath"
Write-Host "Target: $CursorHome"
Write-Host ""

# --- Rules ---
$rulesTarget = "$CursorHome\rules"
New-Item -ItemType Directory -Force -Path $rulesTarget | Out-Null
$ruleFiles = Get-ChildItem "$RepoPath\rules\*.mdc"
foreach ($f in $ruleFiles) {
    Copy-Item $f.FullName -Destination "$rulesTarget\$($f.Name)" -Force
    Write-Host "  [rules] $($f.Name)" -ForegroundColor Green
}

# --- Skills ---
$skillsTarget = "$CursorHome\skills"
New-Item -ItemType Directory -Force -Path $skillsTarget | Out-Null
Copy-Item "$RepoPath\skills\*" -Destination $skillsTarget -Recurse -Force
Write-Host "  [skills] copied skills/ tree" -ForegroundColor Green

# --- Agents ---
$agentsTarget = "$CursorHome\agents"
New-Item -ItemType Directory -Force -Path $agentsTarget | Out-Null
Copy-Item "$RepoPath\agents\*" -Destination $agentsTarget -Force
Write-Host "  [agents] copied 4 agent files" -ForegroundColor Green

# --- Memory templates ---
$templatesTarget = "$CursorHome\memory-templates"
New-Item -ItemType Directory -Force -Path $templatesTarget | Out-Null
Copy-Item "$RepoPath\memory-templates\*" -Destination $templatesTarget -Force
Write-Host "  [templates] copied memory-templates/" -ForegroundColor Green

Write-Host ""
Write-Host "Done. Rules and skills are now active in all Cursor workspaces." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: run init-project.ps1 inside each new project to bootstrap .ai/memory/" -ForegroundColor Yellow
