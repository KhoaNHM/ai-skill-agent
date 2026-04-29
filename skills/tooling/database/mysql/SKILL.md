---
name: mysql
description: MySQL standards — InnoDB, FULLTEXT, composite indexes, transactions, and online schema changes.
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
- FULLTEXT for text search (avoid `LIKE '%term%'` on large tables).
- Composite index column order: equality first, range last.
- Check for unused indexes with `performance_schema` in production.

## Transactions
- Use `BEGIN; ... COMMIT;` for multi-step operations requiring atomicity.
- Set `innodb_lock_wait_timeout` appropriately (default 50s).
- Keep transactions short — no external API calls inside a transaction.

## Migrations
- Sequential numbered migration files.
- Non-blocking `ALTER TABLE` — use `pt-online-schema-change` or `gh-ost` for large tables.
- Backwards-compatible changes only: add columns nullable or with defaults; don't drop until next release.
- Test schema changes on staging before production; create backups beforehand.

## Connection
- Connection pool — never open/close connections per request.
- `max_connections` set appropriately; monitor with `SHOW STATUS LIKE 'Threads_connected'`.

## Validation commands
```
EXPLAIN SELECT ...;
SHOW INDEX FROM table_name;
ANALYZE TABLE table_name;
pt-online-schema-change --alter "MODIFY column type" D=db,t=table
```
