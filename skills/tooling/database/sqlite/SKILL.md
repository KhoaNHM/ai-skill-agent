---
name: sqlite
<<<<<<< HEAD
description: SQLite standards — WAL mode, indexes, migration, and appropriate use cases.
=======
description: SQLite standards — WAL mode, PRAGMAs, when to use, and best practices.
>>>>>>> main
---

# SQLite Standards

<<<<<<< HEAD
## When to use
- Development and test databases.
- Single-writer production workloads with low concurrency (embedded, CLI tools, small apps).
- Not suitable for high-concurrency multi-writer production services — use PostgreSQL instead.

## Configuration
- WAL mode always: `PRAGMA journal_mode=WAL;` on connection open.
- `PRAGMA foreign_keys=ON;` to enforce FK constraints.
- `PRAGMA synchronous=NORMAL;` for WAL mode (safe and faster than FULL).

## Query safety
- Parameterized queries — never string interpolation.
- `EXPLAIN QUERY PLAN` to verify index usage.
- `LIMIT` on all list queries.

## Migrations
- Sequential numbered SQL migration files.
- Apply via migration tool (Flyway, Liquibase, or a simple script).
- Test migrations against a copy of the production DB before deploying.

## Indexes
- Index foreign key columns (SQLite does not auto-index FKs).
- Partial indexes for filtered queries.
- `ANALYZE` periodically to update query planner statistics.
=======
## Configuration
- Enable WAL mode: `PRAGMA journal_mode=WAL;` (better concurrency).
- Set appropriate cache size: `PRAGMA cache_size=-64000;` (64MB for typical apps).
- Enable foreign keys: `PRAGMA foreign_keys=ON;`.
- Disable syncing for faster writes (at risk of corruption): `PRAGMA synchronous=NORMAL;`.

## Indexes & queries
- Index frequently queried columns and foreign keys.
- Use `EXPLAIN QUERY PLAN` to verify index usage.
- Avoid SELECT * — specify columns.
- Use VACUUM only during maintenance windows (locks database).

## Transactions
- Wrap multi-step operations in transactions: `BEGIN; ... COMMIT;`.
- Default isolation level is serializable — safe for most workloads.
- Use `SAVEPOINT` for nested transactions if needed.

## When to use SQLite
- Development, testing, and small production workloads (< 10GB, < 1000 concurrent reads).
- Single-writer, multiple-reader scenarios (WAL enables this).
- Embedded applications, mobile apps, edge devices.
- **Don't use** for high-concurrency or very large datasets — use PostgreSQL instead.

## Migrations
- Use ORM migrations (SQLAlchemy, Django ORM, or similar).
- Test migrations on copy of production database before applying.

## Validation commands
```
sqlite3 db.sqlite3 "PRAGMA foreign_keys=ON; PRAGMA journal_mode=WAL;"
sqlite3 db.sqlite3 "EXPLAIN QUERY PLAN SELECT ..."
sqlite3 db.sqlite3 "VACUUM;"
sqlite3 db.sqlite3 ".dump" > backup.sql
```
>>>>>>> main
