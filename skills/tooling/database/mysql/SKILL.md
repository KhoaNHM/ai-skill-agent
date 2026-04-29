---
name: mysql
description: MySQL standards — InnoDB, indexes, query safety, and migration practices.
---

# MySQL Standards

## Engine
- InnoDB always — never MyISAM for new tables.
- Explicit `ENGINE=InnoDB` and `DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci` in DDL.

## Query safety
- Prepared statements always — no string concatenation in queries.
- `EXPLAIN` before shipping non-trivial queries.
- `LIMIT` on all list queries.
- Avoid `SELECT *` — name columns explicitly.

## Indexes
- B-tree for equality, range, and ORDER BY.
- FULLTEXT for text search (avoid LIKE `%term%` on large tables).
- Composite index column order: equality first, range last.
- Check for unused indexes with `performance_schema` in production.

## Migrations
- Sequential numbered migration files.
- Non-blocking `ALTER TABLE` — use `pt-online-schema-change` or `gh-ost` for large tables.
- Backwards-compatible changes only: add columns nullable or with defaults; don't drop until next release.

## Connection
- Connection pool — never open/close connections per request.
- `max_connections` set appropriately; monitor with `SHOW STATUS LIKE 'Threads_connected'`.
