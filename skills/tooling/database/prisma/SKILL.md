---
name: prisma
<<<<<<< HEAD
description: Prisma ORM standards — schema design, migrations, type-safe queries, and performance.
=======
description: Prisma standards — schema-first design, migrations, relations, and best practices.
>>>>>>> main
---

# Prisma Standards

<<<<<<< HEAD
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
=======
## Schema design
- Use `@id` for primary keys; `@unique` for unique constraints.
- Define indexes with `@@index()` and `@@unique()` at the model level.
- Use enum types for fixed value sets.
- Timestamp fields: `createdAt DateTime @default(now())` and `updatedAt DateTime @updatedAt`.

## Relations
- Explicit foreign key columns (e.g., `authorId Int`).
- Use relation names for clarity: `posts  Post[]` on User, `author User @relation(fields: [authorId])` on Post.
- Avoid circular references without explicit handling.

## Migrations
- Generate migrations after schema changes: `npx prisma migrate dev`.
- Review generated SQL before applying to production: `npx prisma migrate deploy`.
- Keep migrations in source control.
- Test migrations locally and on staging before production.

## Queries
- Use `include` or `select` to load relations — avoid N+1 queries.
- Use `findUnique` with `@unique` or `@id` fields.
- Use `where` conditions to filter before loading data.
- Batch operations with `createMany`, `updateMany` when possible.

## Client best practices
- Use `prisma.$queryRaw` only for unsupported queries; parameterize inputs.
- Handle `PrismaClientKnownRequestError` for constraint violations.
- Use `prisma.$transaction` for atomic multi-statement operations.

## Validation commands
```
npx prisma migrate status           # show pending migrations
npx prisma db push                  # sync schema to database
npx prisma generate                 # regenerate client
npx prisma studio                   # visual database browser
>>>>>>> main
```
