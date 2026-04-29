---
name: elasticsearch
description: Elasticsearch standards — mapping design, query patterns, index lifecycle, and bulk operations.
---

# Elasticsearch Standards

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
