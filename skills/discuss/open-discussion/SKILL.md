---
name: open-discussion
description: Open a new multi-agent discussion thread — human writes the topic, agents respond in round-robin order (BA → Architect → Engineer → QA).
---

# Open Discussion Thread

Use this skill when you want the 4 agent roles to collaboratively explore a problem, idea, or decision before committing to a direction.

## When to use

- You have a cross-cutting question that benefits from multiple perspectives (requirements, design, implementation, quality)
- A significant technical or product decision needs to be debated before an ADR is written
- You want structured agent input without running the full 5-phase workflow

## How to open a thread

### Step 1 — Prepare the topic

Write a clear opening statement. It should answer:
- What is the problem, question, or idea?
- What constraints exist (time, tech, team size)?
- What outcome do you want from this discussion?

### Step 2 — Create the discussion file

Create a file at `.ai/discussions/YYYY-MM-DD-<short-slug>.md` using this template:

```markdown
---
topic: "[One sentence describing the question or idea]"
status: open
opened-by: human
opened-date: YYYY-MM-DD
participants: [ba-strategist, architect, engineer, qa-security]
next-responder: ba-strategist
round: 1
---

## Opening Topic

[Write the full topic here. Include context, constraints, and what a good outcome looks like.]
```

Replace `YYYY-MM-DD` with today's date and `<short-slug>` with 2–4 words from the topic (e.g., `2026-04-29-redis-vs-postgres.md`).

### Step 3 — Invoke the first agent

Tell your AI: "You are BA_STRATEGIST. Use the `respond-discussion` skill on `.ai/discussions/YYYY-MM-DD-<slug>.md`."

## Round-robin order

```
ba-strategist → architect → engineer → qa-security → (repeat if needed)
```

The `next-responder` field in the file always tells you which agent to invoke next.

## Closing the discussion

When you have enough input:
1. Set `status: closed` in the file's frontmatter.
2. Invoke the `close-discussion` skill to generate a final summary.

## Notes

- Keep one topic per file. For a new question, open a new thread.
- All `.ai/discussions/` files are append-only — never delete or rewrite existing agent contributions.
- Summaries are saved to `.ai/discussions/summaries/` and can be referenced from ADRs or handoffs.
