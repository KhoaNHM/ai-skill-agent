---
name: prisma
description: Prisma ORM standards — schema design, migrations, type-safe queries, and performance.
---

# Prisma Standards

## Schema
- Schema-first: define `prisma/schema.prisma` before writing application code.
- Explicit `@id`, `@unique`, `@index`, `@@index` — never rely on implicit indexing.
- Use `@map` and `@@map` to keep Prisma model names in PascalCase and DB table names in snake_case.
- Enums for fixed value sets.

## Migrations
- `prisma migrate dev` in development — generates and applies migration.
- `prisma migrate deploy` in production — applies without generating.
- Never edit a migration file after it has been applied — create a new migration instead.
- Review generated SQL before applying to production.

## Queries
- Use `select` to return only needed fields — avoid fetching full records for list endpoints.
- Use `include` sparingly — `N+1` is easy to introduce with nested includes.
- Transactions: `prisma.$transaction([...])` for multi-model mutations.
- `findFirst` vs `findUnique` — use `findUnique` when the field is `@unique` (faster).

## Performance
- `prisma.$queryRaw` or `prisma.$executeRaw` for complex queries that Prisma cannot express efficiently.
- Monitor slow queries with Prisma's `log: ['query']` in development.
- Connection pool: configure `connection_limit` in the datasource URL for serverless.

## Validation commands
```
prisma validate         # schema validation
prisma migrate dev      # apply pending migrations
prisma generate         # regenerate client after schema change
```
