---
name: mysql
<<<<<<< HEAD
description: MySQL standards — InnoDB, indexes, query safety, and migration practices.
=======
description: MySQL standards — InnoDB, FULLTEXT, composite indexes, and online schema changes.
>>>>>>> main
---

# MySQL Standards

<<<<<<< HEAD
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
=======
## Engine & storage
- Use InnoDB for all tables (default, ACID-compliant).
- Set `innodb_file_per_table=1` to manage storage efficiently.
- Use `ROW_FORMAT=COMPRESSED` only for very large tables; benchmark first.

## Indexes
- Primary key on all tables (clustered index).
- Index columns used in WHERE, JOIN, and ORDER BY.
- Composite indexes: equality fields first, then range, then sort.
- Use FULLTEXT indexes for text search; avoid LIKE '%pattern%'.
- Regular index maintenance: `OPTIMIZE TABLE` after large deletions.

## Queries
- Use `EXPLAIN` to verify index usage.
- Avoid SELECT * — specify columns.
- Use LIMIT for pagination; avoid large OFFSET (scan overhead).
- Normalize queries: one statement per data requirement, no N+1 queries.

## Transactions
- Enable `autocommit=0` for multi-statement transactions.
- Use `BEGIN; ... COMMIT;` for data consistency.
- Set `innodb_lock_wait_timeout` appropriately (default 50s).

## Online schema changes
- Use `pt-online-schema-change` (from Percona) for large tables without downtime.
- Test schema changes on staging first.
- Create backups before running schema changes.

## Validation commands
```
EXPLAIN SELECT ...;                 # query plan
SHOW INDEX FROM table_name;         # list indexes
ANALYZE TABLE table_name;           # update statistics
OPTIMIZE TABLE table_name;          # defragment
pt-online-schema-change --alter "MODIFY column type" D=db,t=table
```
>>>>>>> main
