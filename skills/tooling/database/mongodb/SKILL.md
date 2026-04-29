---
name: mongodb
description: MongoDB standards — indexing, F-P-S-L queries, aggregation pipelines, and schema design.
---

# MongoDB Standards

## Indexes
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
