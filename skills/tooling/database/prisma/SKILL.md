---
name: prisma
description: Prisma standards — schema-first design, relations, migrations, type-safe queries, and performance.
---

# Prisma Standards

## Schema
- Schema-first: define `prisma/schema.prisma` before writing application code.
- Explicit `@id`, `@unique`, `@index`, `@@index` — never rely on implicit indexing.
- Use `@map` and `@@map` to keep Prisma model names in PascalCase and DB table names in snake_case.
- Enums for fixed value sets.
- Timestamp fields: `createdAt DateTime @default(now())` and `updatedAt DateTime @updatedAt`.

## Relations
- Explicit foreign key columns (e.g., `authorId Int`).
- Use relation names for clarity on both sides of the relation.
- Avoid circular references without explicit handling.

## Migrations
- `prisma migrate dev` in development — generates and applies migration.
- `prisma migrate deploy` in production — applies without generating.
- Never edit a migration file after it has been applied — create a new migration instead.
- Review generated SQL before applying to production.
- Keep migrations in source control.

## Queries
- Use `select` to return only needed fields — avoid fetching full records for list endpoints.
- Use `include` sparingly — N+1 is easy to introduce with nested includes.
- `findUnique` when the field is `@unique` (faster than `findFirst`).
- Batch with `createMany`, `updateMany` when possible.
- Transactions: `prisma.$transaction([...])` for multi-model mutations.

## Performance & client
- `prisma.$queryRaw` / `prisma.$executeRaw` for complex queries Prisma cannot express efficiently — always parameterize inputs.
- Monitor slow queries with `log: ['query']` in development.
- Handle `PrismaClientKnownRequestError` for constraint violations.
- Connection pool: configure `connection_limit` in the datasource URL for serverless.

## Validation commands
```
prisma validate         # schema validation
prisma migrate dev      # apply pending migrations
prisma generate         # regenerate client after schema change
prisma studio           # visual database browser
```
