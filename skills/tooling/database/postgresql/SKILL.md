---
name: postgresql
<<<<<<< HEAD
description: PostgreSQL standards — query performance, indexes, transactions, and migration safety.
=======
description: PostgreSQL standards — parameterized queries, EXPLAIN ANALYZE, transactions, and migrations.
>>>>>>> main
---

# PostgreSQL Standards

<<<<<<< HEAD
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
=======
## Parameterized queries
- Always use parameterized queries or ORM — never string concatenation.
- Bind values via prepared statements (prevents SQL injection).
- Use ORM features like SQLAlchemy, TypeORM, or Sequelize whenever possible.

## Indexes
- Index columns in WHERE, JOIN, and ORDER BY clauses.
- Use `EXPLAIN ANALYZE` to verify index usage before and after changes.
- Composite indexes for frequent multi-column filters (order: equality, range, sort).
- Partial indexes for sparse data: `CREATE INDEX ON table (col) WHERE status = 'active'`.

## Queries & performance
- Use `EXPLAIN ANALYZE` for any query taking > 1ms.
- Avoid SELECT * — specify needed columns.
- Use UNION for combining result sets; avoid multiple queries.
- Leverage window functions for row-relative calculations.

## Transactions
- Wrap multi-step operations in transactions for atomicity.
- Use `BEGIN; ... COMMIT;` for DDL safety.
- Set appropriate isolation levels (`READ COMMITTED` default; `SERIALIZABLE` for high consistency).

## Migrations
- Use a migration tool (Flyway, Liquibase, or ORM built-in).
- Migrations are immutable once deployed — never modify old migrations.
- Write forward and rollback migrations.
- Test migrations locally before production.

## Validation commands
```
EXPLAIN ANALYZE SELECT ...;         # query plan
ANALYZE table_name;                 # update statistics
psql -d dbname -f migration.sql      # run migration
pg_dump -h host -U user dbname > backup.sql
```
>>>>>>> main
