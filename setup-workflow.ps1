#!/usr/bin/env pwsh
# setup-workflow.ps1
# Fast installation for AI Skill Agent Workflow
# Usage: .\setup-workflow.ps1 [-Approach symlink|copy] [-WorkflowPath <path>]

param(
    [ValidateSet("symlink", "copy")]
    [string]$Approach = "symlink",
    
    [string]$WorkflowPath = $null,
    
    [switch]$NoMemory
)

$ErrorActionPreference = "Stop"

# Auto-detect workflow path if not provided
if (-not $WorkflowPath) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    if (Test-Path "$scriptDir\agents") {
        $WorkflowPath = $scriptDir
    } elseif (Test-Path "$scriptDir\..\agents") {
        $WorkflowPath = Resolve-Path "$scriptDir\.."
    } else {
        Write-Host "❌ Workflow path not found. Specify with -WorkflowPath" -ForegroundColor Red
        exit 1
    }
}

$WorkflowPath = Resolve-Path $WorkflowPath
$ProjectPath = Get-Location

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  AI Skill Agent Workflow — Setup" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "Workflow path: $WorkflowPath" -ForegroundColor Gray
Write-Host "Project path:  $ProjectPath" -ForegroundColor Gray
Write-Host "Approach:      $Approach" -ForegroundColor Gray
Write-Host ""

# Validate workflow structure
$requiredDirs = @("agents", "rules", "skills")
foreach ($dir in $requiredDirs) {
    if (-not (Test-Path "$WorkflowPath\$dir")) {
        Write-Host "❌ Missing: $WorkflowPath\$dir" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✓ Workflow structure valid" -ForegroundColor Green
Write-Host ""

# Setup based on approach
switch ($Approach) {
    "symlink" {
        Write-Host "Setting up symbolic links..." -ForegroundColor Cyan
        Write-Host ""
        
        # Check admin rights
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [Security.Principal.WindowsPrincipal]$identity
        if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Host "⚠️  Admin rights recommended for symlinks (Windows)" -ForegroundColor Yellow
            Write-Host "   Rerun as Administrator for best results, or use -Approach copy" -ForegroundColor Yellow
            Write-Host ""
        }
        
        try {
            New-Item -ItemType SymbolicLink -Path ".ai-agents" -Target "$WorkflowPath\agents" -Force -ErrorAction Stop | Out-Null
            Write-Host "  ✓ .ai-agents → $WorkflowPath\agents" -ForegroundColor Green
            
            New-Item -ItemType SymbolicLink -Path ".ai-rules" -Target "$WorkflowPath\rules" -Force -ErrorAction Stop | Out-Null
            Write-Host "  ✓ .ai-rules → $WorkflowPath\rules" -ForegroundColor Green
            
            New-Item -ItemType SymbolicLink -Path ".ai-skills" -Target "$WorkflowPath\skills" -Force -ErrorAction Stop | Out-Null
            Write-Host "  ✓ .ai-skills → $WorkflowPath\skills" -ForegroundColor Green
            
            Write-Host ""
            Write-Host "✓ Symlinks created successfully" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to create symlinks: $_" -ForegroundColor Red
            Write-Host "   Try: Run PowerShell as Administrator" -ForegroundColor Yellow
            exit 1
        }
    }
    
    "copy" {
        Write-Host "Copying workflow files..." -ForegroundColor Cyan
        Write-Host ""
        
        $targetDir = ".ai"
        
        try {
            New-Item -ItemType Directory -Path $targetDir -Force -ErrorAction Stop | Out-Null
            
            Copy-Item "$WorkflowPath\agents" "$targetDir\agents" -Recurse -Force
            Write-Host "  ✓ agents/ copied" -ForegroundColor Green
            
            Copy-Item "$WorkflowPath\rules" "$targetDir\rules" -Recurse -Force
            Write-Host "  ✓ rules/ copied" -ForegroundColor Green
            
            Copy-Item "$WorkflowPath\skills" "$targetDir\skills" -Recurse -Force
            Write-Host "  ✓ skills/ copied" -ForegroundColor Green
            
            Copy-Item "$WorkflowPath\memory-templates" "$targetDir\memory-templates" -Recurse -Force
            Write-Host "  ✓ memory-templates/ copied" -ForegroundColor Green
            
            Write-Host ""
            Write-Host "✓ Workflow copied to .ai/" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to copy: $_" -ForegroundColor Red
            exit 1
        }
    }
}

# Create .ai/memory if init-memory should be run
if (-not $NoMemory) {
    Write-Host ""
    Write-Host "Next: Initialize project memory" -ForegroundColor Cyan
    Write-Host "  Ask your AI agent:" -ForegroundColor Gray
    Write-Host "  > run tooling/init-memory" -ForegroundColor Gray
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "  ✓ Setup complete!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Cyan
Write-Host ""

if ($Approach -eq "symlink") {
    Write-Host "  1. Configure your AI tool to load from:" -ForegroundColor Gray
    Write-Host "     • Rules: .ai-rules/*.mdc" -ForegroundColor Gray
    Write-Host "     • Agents: .ai-agents/*.md" -ForegroundColor Gray
    Write-Host "     • Skills: .ai-skills/" -ForegroundColor Gray
} else {
    Write-Host "  1. Configure your AI tool to load from:" -ForegroundColor Gray
    Write-Host "     • Rules: .ai/rules/*.mdc" -ForegroundColor Gray
    Write-Host "     • Agents: .ai/agents/*.md" -ForegroundColor Gray
    Write-Host "     • Skills: .ai/skills/" -ForegroundColor Gray
}

Write-Host ""
Write-Host "  2. Initialize memory:" -ForegroundColor Gray
Write-Host "     > Ask AI: 'run tooling/init-memory'" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Start Phase 0:" -ForegroundColor Gray
if ($Approach -eq "symlink") {
    Write-Host "     > @agent .ai-agents/00-ba-strategist.md" -ForegroundColor Gray
} else {
    Write-Host "     > @agent .ai/agents/00-ba-strategist.md" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Docs: See INSTALLATION.md for more options" -ForegroundColor Cyan
Write-Host ""
