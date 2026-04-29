---
name: mongodb
<<<<<<< HEAD
description: MongoDB standards — index strategy, query patterns, schema design, and aggregation safety.
=======
description: MongoDB standards — indexing, F-P-S-L queries, aggregation pipelines, and schema design.
>>>>>>> main
---

# MongoDB Standards

## Indexes
<<<<<<< HEAD
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
=======
- Index frequently queried fields and sort keys.
- Compound indexes follow F-P-S-L order: Equality (Fields) → Range (Predicates) → Sorting (Sort) → Limit.
- Use `sparse: true` for optional fields; avoid indexing sparse fields unnecessarily.
- Regular index maintenance — use `explain()` to verify index usage.

## Query patterns
- Avoid `$not` with high selectivity — use positive queries instead.
- Use `$regex` sparingly — index with text search if available.
- Lean projections: always exclude `_id` if not needed, to reduce network overhead.
- Use `updateOne` / `updateMany` with operators, not full document replacement.

## Aggregation pipelines
- Build pipelines stage-by-stage: `$match` early for filtering, then `$project`, `$group`, `$lookup`.
- Use `$facet` for multiple aggregations in one pass.
- Index the initial `$match` stage to minimize documents in downstream stages.

## Schema design
- Embed documents when frequently accessed together (1:1, weak 1:N).
- Reference documents when shared across collections or when relationships are sparse.
- Avoid very deep nesting (> 3 levels) — consider normalization.
- Use schema validation with `$jsonSchema` in collection creation.

## Validation commands
```
db.collection.explain("executionStats").find({query})  # verify index usage
db.collection.find().hint({field: 1}).explain("executionStats")
use admin; db.validateCollection("myCollection")
```
>>>>>>> main
