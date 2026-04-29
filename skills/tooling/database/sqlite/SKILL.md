---
name: sqlite
description: SQLite standards — WAL mode, indexes, migration, and appropriate use cases.
---

# SQLite Standards

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
