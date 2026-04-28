---
name: prisma
description: Prisma standards — schema-first design, migrations, relations, and best practices.
---

# Prisma Standards

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
```
