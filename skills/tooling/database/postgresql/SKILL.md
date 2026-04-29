---
name: postgresql
description: PostgreSQL standards — parameterized queries, EXPLAIN ANALYZE, transactions, and migrations.
---

# PostgreSQL Standards

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
