---
name: respond-discussion
description: Append this agent's perspective to an open discussion thread, then advance the next-responder field to the next role in the round-robin.
---

# Respond to Discussion Thread

Use this skill when a human invokes you as a specific role to contribute to an open discussion thread in `.ai/discussions/`.

## Step 1 — Read the thread

Read the discussion file the human points you to (e.g., `.ai/discussions/2026-04-29-redis-vs-postgres.md`).

If no file is specified and multiple open threads exist, list them and ask the human which one to respond to.

Check the frontmatter:
- `status` must be `open`. If it is `closed`, stop and tell the human to use `close-discussion` instead.
- `next-responder` should match your role. If it does not, warn the human: "This thread expects [next-responder] to respond next, not [your role]. Proceed anyway?"

## Step 2 — Read all prior contributions

Read every existing `## ROLE — Round N` section in the file from top to bottom before writing your response. Your contribution must build on, challenge, or complement what came before — not ignore it.

## Step 3 — Write your response

Append the following block to the end of the file (after the last `---` separator):

```markdown
---
## [ROLE] — Round [N]
_date: YYYY-MM-DD_

[Your response here. See role guidance below.]

→ Next: [NEXT_ROLE]
```

Replace:
- `[ROLE]` with your agent name in caps (e.g., `BA_STRATEGIST`, `ARCHITECT`, `ENGINEER`, `QA_SECURITY`)
- `[N]` with the current round number from the frontmatter
- `[NEXT_ROLE]` with the next role in the sequence (see round-robin below)

## Round-robin order

```
ba-strategist → architect → engineer → qa-security → ba-strategist → ...
```

Next-role mapping:
- If you are `ba-strategist` → next is `architect`
- If you are `architect` → next is `engineer`
- If you are `engineer` → next is `qa-security`
- If you are `qa-security` → next is `ba-strategist` (increment `round` by 1)

## Step 4 — Update the frontmatter

After appending your response, update these two frontmatter fields in place:
- `next-responder:` → set to the next role
- `round:` → increment by 1 only when `qa-security` has just responded (full cycle complete)

Read the file back immediately after writing to confirm the appended section and updated frontmatter are present.

## Step 5 — Tell the human what to do next

Output: "Done. Next: invoke `respond-discussion` as **[NEXT_ROLE]**." (or if `status: closed`, "The thread is closed — use `close-discussion` to generate the summary.")

---

## Role-specific response guidance

### BA_STRATEGIST
Focus on: user needs, acceptance criteria implications, edge cases, stakeholder impact, ambiguity in the problem statement.

### ARCHITECT
Focus on: system design trade-offs, module boundaries, scalability, integration points, reversibility of the decision, ADR candidates.

### ENGINEER
Focus on: implementation complexity, maintainability, testing difficulty, known pitfalls, effort estimate, dependency risks.

### QA_SECURITY
Focus on: how to verify correctness, security surface area, failure modes, what could go wrong in production, observability gaps.

---

## Notes

- Keep your response focused and scannable. Bullet points are fine.
- Do not repeat what prior roles already said — reference and extend.
- If you strongly disagree with a prior position, say so explicitly with reasoning.
- There is no length minimum or maximum, but prioritize signal over volume.
