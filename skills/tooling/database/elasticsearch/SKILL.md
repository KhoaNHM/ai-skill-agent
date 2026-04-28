---
name: elasticsearch
description: Elasticsearch standards — mapping design, query context, ILM policies, and best practices.
---

# Elasticsearch Standards

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
