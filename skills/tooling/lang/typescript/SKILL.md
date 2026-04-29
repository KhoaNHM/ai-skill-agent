---
name: typescript
description: TypeScript coding standards — strict types, tsc, imports, async patterns, and Node.js conventions.
---

# TypeScript Standards

## Type safety
- Explicit return types on all exported functions.
- No `any` — use `unknown` + type guard, or a concrete type.
- `const` over `let`; never `var`.
- Enable `strict: true` in tsconfig; never disable strict checks per-file.

## Style
- Early returns over deep nesting.
- Optional chaining `?.` and nullish coalescing `??` over manual null checks.
- Descriptive names: verbs for functions (`getUserById`), nouns for variables (`userId`).
- Prefer `interface` for object shapes; `type` for unions/intersections.

## Imports
- Match existing import style (path aliases vs relative).
- Respect `tsconfig` `baseUrl` / `paths`.
- No barrel re-exports that cause circular dependencies.

## Performance
- Cache `arr.length` in tight loops.
- `Map`/`Set` for O(1) lookups over `Array.find`/`Array.includes`.
- `for`/`for-of` in hot paths over `forEach`.

## Async
- `async`/`await` over raw Promises.
- Always handle rejections — no floating Promises.
- Wrap external calls in try/catch at the boundary layer; don't catch internally unless recovering.

## Documentation
- JSDoc for every exported function: one-line summary + `@param` + `@returns`.
- Skip JSDoc for private/internal helpers unless the logic is non-obvious.

## Validation commands
```
npx tsc --noEmit        # typecheck
npx eslint src          # lint
npm test                # or: npx jest / npx vitest
```
