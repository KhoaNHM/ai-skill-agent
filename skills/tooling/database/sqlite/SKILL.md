---
name: sqlite
description: SQLite standards — WAL mode, PRAGMAs, when to use, transactions, and best practices.
---

# SQLite Standards

## When to use
- Development and test databases.
- Single-writer production workloads with low concurrency (embedded, CLI tools, small apps < 10GB).
- WAL mode enables single-writer + multiple-reader concurrency.
- Not suitable for high-concurrency multi-writer production services — use PostgreSQL instead.

## Configuration
- WAL mode always: `PRAGMA journal_mode=WAL;` on connection open.
- `PRAGMA foreign_keys=ON;` to enforce FK constraints.
- `PRAGMA synchronous=NORMAL;` for WAL mode (safe and faster than FULL).
- `PRAGMA cache_size=-64000;` for typical apps (64MB cache).

## Query safety
- Parameterized queries — never string interpolation.
- `EXPLAIN QUERY PLAN` to verify index usage.
- `LIMIT` on all list queries.
- Avoid `SELECT *` — specify columns.

## Transactions
- Wrap multi-step operations in transactions: `BEGIN; ... COMMIT;`.
- Default isolation is serializable — safe for most workloads.
- Use `SAVEPOINT` for nested transactions if needed.

## Migrations
- Sequential numbered SQL migration files.
- Apply via migration tool (Flyway, Liquibase, or a simple script).
- Test migrations against a copy of the production DB before deploying.

## Indexes
- Index foreign key columns (SQLite does not auto-index FKs).
- Partial indexes for filtered queries.
- `ANALYZE` periodically to update query planner statistics.

## Validation commands
```
sqlite3 db.sqlite3 "PRAGMA foreign_keys=ON; PRAGMA journal_mode=WAL;"
sqlite3 db.sqlite3 "EXPLAIN QUERY PLAN SELECT ..."
sqlite3 db.sqlite3 ".dump" > backup.sql
```
