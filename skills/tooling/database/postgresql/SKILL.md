---
name: postgresql
description: PostgreSQL standards — query performance, indexes, transactions, and migration safety.
---

# PostgreSQL Standards

## Query safety
- Parameterized queries always — no string interpolation in SQL.
- `EXPLAIN ANALYZE` before shipping any non-trivial query.
- `LIMIT` on all list queries — no unbounded result sets.
- Avoid `SELECT *` in application code — name the columns.

## Indexes
- B-tree for equality and range queries (default).
- GIN for JSONB columns, arrays, and full-text search.
- Partial indexes (`WHERE active = true`) for filtered hot paths.
- `CREATE INDEX CONCURRENTLY` in production to avoid table lock.

## Transactions
- Use transactions for any operation that modifies more than one row or table.
- Keep transactions short — no external API calls inside a transaction.
- `SERIALIZABLE` isolation only when explicitly needed; prefer `READ COMMITTED` default.

## Migrations
- Sequential, numbered migration files (`001_add_users_table.sql`).
- Each migration must be backwards-compatible with the previous version of the application.
- Never rename a column in one migration — add the new column, backfill, then drop in a future migration.
- Test rollback (`DOWN` migration) before shipping.

## Connection
- Use a connection pool (pgBouncer, PgPool, or driver-level pooling).
- Validate required env vars at startup; never hardcode connection strings.
