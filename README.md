# AI Skill Agent Workflow

A model-agnostic library of **agents, rules, skills, and memory** for AI-assisted software development. Works with Claude Code, Cursor, Windsurf, GPT, Gemini, or any agent that can read markdown.

## How it works

Every coding task follows a five-phase lifecycle enforced by rules and agent personas:

```
Phase 0 — Requirements  →  BA Strategist agent
Phase 1 — Design        →  Architect agent       ← human approves before any code
Phase 2 — Implement     →  Engineer agent
Phase 3 — Review        →  QA / Security agent
Phase 4 — Ship          →  PR creation + babysit
```

Between phases, agents write to `.ai/memory/` — plain markdown files any model can read and write.

---

## Installation

### One command

**Mac / Linux / WSL / Windows (Git Bash):**
```bash
bash setup.sh
```

That's it. The script auto-detects which AI tools you have installed and sets everything up.

> **Windows users:** Run this in Git Bash (ships with Git for Windows) or WSL. Not PowerShell.

### What it does

| Step | What happens |
|------|-------------|
| Detect tools | Finds Cursor, Claude Code, Windsurf from their config dirs |
| Cursor found | Copies rules → `~/.cursor/rules/`, agents + skills → `~/.cursor/` |
| Claude Code found | Installs skills as slash commands in `~/.claude/commands/`, appends memory protocol to `~/.claude/CLAUDE.md` |
| Windsurf found | Copies rules and agents → `~/.codeium/windsurf/` |
| No tools found | Copies library to `~/.ai-skill-agent/` as fallback |
| In a project dir | Creates entry point files + `.ai/memory/` structure |

### Flags

```bash
bash setup.sh --global              # install to AI tools only (skip project init)
bash setup.sh --project             # init project memory only (skip tool install)
bash setup.sh --dry-run             # preview without changes (combine with --global or --project)
bash setup.sh --dir /path/to/proj   # target a specific project directory
bash setup.sh --help                # show all options
```

### Per-project bootstrap

Run from your project root, or use `--dir` to point at it from anywhere:

```bash
# option 1 — cd into your project first
cd /your/existing/project
bash /path/to/ai-skill-agent/setup.sh --project

# option 2 — stay anywhere, pass the path
bash /path/to/ai-skill-agent/setup.sh --project --dir /your/existing/project
```

Creates at project root:
- `CLAUDE.md` — Claude Code auto-loads this
- `AGENTS.md` — OpenAI Codex / agent frameworks auto-load this
- `WINDSURF.md` — Windsurf auto-loads this
- `AI_CONTEXT.md` — generic fallback for any model
- `.ai/memory/` — full memory structure (see below)
- `.ai/discussions/` — multi-agent discussion threads (see below)
- `.ai/bootstrap.sh` — one-command setup for new team members

Commit everything to git:
```bash
git add CLAUDE.md AGENTS.md WINDSURF.md AI_CONTEXT.md .ai/
git commit -m "chore: init AI memory"
```

### New team member setup

When a developer clones a project that already has `.ai/` committed, they run one command to install skills on their machine:

```bash
bash .ai/bootstrap.sh
```

The script auto-detects the skill agent repo in common locations (`~/.ai-skill-agent`, `~/ai-skill-agent`). If not found, it prints step-by-step instructions. To point it at a custom location:

```bash
SKILL_AGENT_DIR=/path/to/ai-skill-agent bash .ai/bootstrap.sh
```

---

## Repository structure

```
agents/          Phase-tagged agent personas (00–03)
rules/           Always-active rules (.mdc) loaded into the AI context
skills/          Reusable skills organized by workflow phase
memory-templates/ Markdown templates for .ai/memory/ and .ai/discussions/
setup.sh         Universal setup — Mac / Linux / WSL / Windows (Git Bash)
```

---

## Skills by phase

| Phase | Skills |
|-------|--------|
| 0 · Requirements | `gather-requirements`, `write-requirements-memory` |
| 1 · Design | `system-design`, `api-design`, `write-adr`, `change-impact` |
| 2 · Implement | `incremental-implementation`, `tdd`, `diagnose`, `clean-code`, `split-to-prs` |
| 3 · Review | `security-review`, `qa-checklist` |
| 4 · Ship | `pr-ship`, `babysit` |
| Discussion | `open-discussion`, `respond-discussion`, `close-discussion` |
| Tooling | `init-memory`, `canvas`, `shell`, `create-skill`, `create-rule`, `create-subagent` |

---

## Rules

| File | Purpose |
|------|---------|
| `00-lifecycle.mdc` | Master phase gate and agent sequence |
| `01-plan-before-code.mdc` | Block implementation without approved plan |
| `02-coding-standards.mdc` | SOLID, DRY, TypeScript, MongoDB, API design |
| `03-security-baseline.mdc` | Auth, input validation, secrets, OWASP |
| `04-memory-protocol.mdc` | When and what every agent reads and writes |

---

## Memory system

Each project gets a `.ai/memory/` directory:

```
.ai/memory/
├── INDEX.md                          ← always read first — phase status + links
├── context/
│   ├── requirements.md               ← BA output (Phase 0)
│   ├── domain-language.md            ← optional BA — ubiquitous terms (Phase 0)
│   ├── tech-stack.md                 ← Architect output (Phase 1)
│   └── non-functional.md             ← BA output (Phase 0)
├── architecture/
│   ├── module-map.md                 ← Architect output (Phase 1)
│   ├── api-contracts.md              ← Architect output (Phase 1)
│   └── decisions/                    ← ADRs (one per significant decision)
├── handoffs/
│   ├── ba→architect.md               ← Phase 0 → 1 transfer
│   ├── architect→engineer.md         ← Phase 1 → 2 transfer (approved plan)
│   └── engineer→qa.md                ← Phase 2 → 3 transfer
└── patterns/
    ├── solutions.md                   ← reusable approaches
    └── anti-patterns.md              ← pitfalls to avoid
```

Memory is plain markdown with YAML frontmatter — any AI model can read and write it without proprietary tools.

### Anti-hallucination protocol

Every agent must:
1. **Read** `.ai/memory/INDEX.md` first — never assume phase status from conversation history
2. **State the current phase out loud** before doing any work
3. **Read back** every file after writing — do not report success without verifying
4. **Never infer** file state from conversation — read the actual file

---

## Discussion system

When a decision needs debate before committing to a design, use the discussion system to get structured input from all 4 agent roles.

```
.ai/discussions/
├── 2026-04-29-your-topic.md          ← append-only thread (BA → Architect → Engineer → QA)
└── summaries/
    └── 2026-04-29-your-topic-summary.md  ← synthesized output
```

| Step | Command | What happens |
|------|---------|-------------|
| 1 | `/open-discussion` | Human creates a thread with the topic |
| 2 | `/respond-discussion` (×4) | Each agent appends their perspective in round-robin |
| 3 | Set `status: closed`, run `/close-discussion` | Generates a structured summary |

The summary can be referenced from ADRs or phase handoffs.

---

## Starting a new feature

1. Open your project in any AI tool
2. The AI reads `CLAUDE.md` / `AGENTS.md` / `WINDSURF.md` automatically
3. Ask: **"Start Phase 0 for [feature name]"** — or run `/gather-requirements`
4. The BA agent interviews you and writes to `.ai/memory/context/requirements.md`
5. Architect designs the plan → human approves → Engineer implements → QA reviews → Ship

Human approval is required between Phase 1 and Phase 2. The AI cannot start writing code until the architecture plan is explicitly approved.
