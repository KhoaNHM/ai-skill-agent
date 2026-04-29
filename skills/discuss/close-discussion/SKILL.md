---
name: close-discussion
description: Close an open discussion thread and produce a structured final-summary.md synthesizing all agent contributions.
---

# Close Discussion Thread

Use this skill when the human has decided the discussion is complete and wants a synthesized summary document.

## Prerequisites

Before invoking this skill, the human must:
1. Set `status: closed` in the discussion file's frontmatter.
2. Optionally add a closing note below the last agent response:

```markdown
---
## Human — Closing Note
[Optional: any final direction or context for the summarizing agent.]
```

## Step 1 — Verify the thread is closed

Read the discussion file. Check frontmatter `status`:
- If `open` → stop. Tell the human: "Set `status: closed` in the frontmatter first, then re-invoke this skill."
- If `closed` → proceed.

## Step 2 — Read all contributions

Read the full file top to bottom:
- Opening Topic (human)
- Every `## ROLE — Round N` section
- Human closing note (if present)

## Step 3 — Write the summary file

Create `.ai/discussions/summaries/YYYY-MM-DD-<slug>-summary.md` where the date and slug match the source thread filename.

Use this structure:

```markdown
---
type: discussion-summary
topic: "[copy from thread frontmatter]"
source-thread: "../YYYY-MM-DD-<slug>.md"
closed-date: YYYY-MM-DD
participants: [ba-strategist, architect, engineer, qa-security]
rounds-completed: N
summarized-by: [your role]
---

# Discussion Summary: [topic]

## Opening Topic
[One-paragraph restatement of the original question or idea.]

## Key Points by Role

### BA / Requirements Perspective
- [point]
- [point]

### Architecture Perspective
- [point]
- [point]

### Engineering Perspective
- [point]
- [point]

### QA / Security Perspective
- [point]
- [point]

## Areas of Agreement
[What all (or most) roles converged on.]

## Areas of Disagreement
[Where roles diverged and why — do not hide conflicts, they are valuable.]

## Consensus / Decision
[The clearest conclusion the discussion reached. If no consensus, say so explicitly and state the open fork.]

## Open Questions
- [ ] [question that was raised but not resolved]

## Recommended Next Steps
- [ ] [action item with suggested owner]
```

## Step 4 — Read back the summary file

After writing, read the file back immediately to confirm all sections are present and the frontmatter is correct.

## Step 5 — Tell the human what was produced

Output:
- The path of the summary file
- The single most important takeaway from the discussion in one sentence
- Any open questions that need a decision

## Optional: link to ADR or handoff

If the discussion resolved a significant architectural decision, suggest:
- Using `write-adr` to formally record it in `.ai/memory/architecture/decisions/`
- Referencing the summary in the relevant handoff file

## Notes

- The summary is a synthesis, not a transcript. Do not paste raw agent responses — distill them.
- Disagreements are first-class content. If roles clashed, the summary must say so.
- The summary file is the permanent artifact. The thread file is the raw record.
- Both files are kept — the thread for audit, the summary for action.
