---
name: elasticsearch
<<<<<<< HEAD
description: Elasticsearch standards — mapping design, query patterns, index lifecycle, and bulk operations.
=======
description: Elasticsearch standards — mapping design, query context, ILM policies, and best practices.
>>>>>>> main
---

# Elasticsearch Standards

<<<<<<< HEAD
## Index design
- Define explicit mappings before indexing data — never rely on dynamic mapping in production.
- `keyword` for exact-match/aggregation fields; `text` for full-text search (often both with `fields`).
- Disable `_source` only when storage is critical — it breaks update and reindex operations.
- Use index aliases — code always writes/reads via alias, not index name directly.

## Query patterns
- **Query context** (affects score): `match`, `multi_match`, `query_string`.
- **Filter context** (cached, no score): `term`, `terms`, `range`, `exists`.
- Use filter context for all non-relevance filtering — it's significantly faster.
- Avoid `wildcard` and `regexp` queries on large indices — they are O(n).

## Bulk operations
- `_bulk` API for all large ingest — never single-document indexing in loops.
- Bulk size: ~5–15 MB per request or ~1000 documents — benchmark for your data.
- Handle partial failures: bulk response contains per-item status — check `errors` field.

## Index Lifecycle Management (ILM)
- Define ILM policy for time-series indices (logs, events): hot → warm → cold → delete.
- Use rollover for write indices to keep shard sizes manageable (<50 GB per shard).

## Safety
- Never `DELETE /index` without confirming via alias first.
- Snapshot before any destructive reindex operation.
- Rate-limit ingest in application code — Elasticsearch does not back-pressure gracefully.
=======
## Mapping design
- Define explicit mappings for all indexes — don't rely on dynamic mapping.
- Use appropriate field types: `keyword` for exact matches, `text` for full-text search.
- Use `nested` type for complex objects with multiple fields; use `object` for simple data.
- Set `index: false` for fields that are never searched.
- Store frequently accessed metadata with `_source`.

## Query patterns
- Query context (affects scoring): use for full-text search, relevance ranking.
- Filter context (no scoring): use for exact matches, categorical filtering — wraps in `filter` for caching.
- Combine with `bool` query: `must` (AND), `should` (OR), `must_not` (NOT), `filter`.
- Avoid full-table scans — use filters and aggregations to reduce dataset.

## Performance & indexing
- Use index templates to standardize new indexes.
- Shard count: 1 shard per 10-50GB of data; avoid over-sharding (small shards = slow aggregations).
- Replicas for redundancy; use at least 1 replica in production.
- Use `refresh_interval` conservatively — higher values improve indexing speed.

## Index lifecycle management (ILM)
- Define ILM policies for automatic rollover, shrinking, deletion.
- Archive old indexes to cold storage or delete per retention policy.
- Use time-based index names (`logs-2024-01-15`) for easy lifecycle management.

## Validation commands
```
GET _cat/indices                    # list indexes and sizes
GET my-index/_mapping               # view mapping
GET my-index/_search?q=field:value  # simple search
POST _reindex                       # reindex data
```
>>>>>>> main
