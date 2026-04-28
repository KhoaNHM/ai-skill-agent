---
name: mysql
description: MySQL standards — InnoDB, FULLTEXT, composite indexes, and online schema changes.
---

# MySQL Standards

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
