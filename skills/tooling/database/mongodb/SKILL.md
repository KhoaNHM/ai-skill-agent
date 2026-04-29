---
name: mongodb
description: MongoDB standards — index strategy, query patterns, schema design, and aggregation safety.
---

# MongoDB Standards

## Indexes
- Single-field for hot filters; compound for multi-field queries (leading field order matters).
- Unique, TTL, and sparse indexes where appropriate.
- Verify with `.explain("executionStats")` — COLLSCAN on large collections is a bug.
- Never create a compound index on two or more array fields.

## Query pattern (F-P-S-L)
Filter → Project → Sort → Limit — always in this order:
- Filter first to reduce the working set.
- Project only needed fields (never return full documents when a subset is enough).
- Sort on indexed fields only.
- Always limit/skip for pagination — unbounded queries are a production incident.

## Aggregation
- `$match` as early as possible (before `$group`, `$lookup`).
- `$project` after `$match` to reduce document size.
- Avoid `$where` and JavaScript execution in queries.
- Use `$facet` for parallel aggregations instead of multiple round trips.

## Schema design
- Embed when data is always read together and the subdocument is small and stable.
- Reference when one-to-many, data grows unbounded, or subdocument is updated independently.
- Avoid deep nesting (>2 levels); use proper BSON types; one naming convention (camelCase).
- Arrays must be bounded — document the max size in schema comments.

## Safety
- Tenant/scope filter on every query that returns data — never a query without an owner/tenant field.
- Destructive operations (deleteMany, updateMany) require explicit ownership check.
- Indexes in place before deploying code that uses them.
