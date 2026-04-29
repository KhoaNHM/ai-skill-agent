---
name: react
description: React coding standards — functional components, hooks, TypeScript props, and RTL testing.
---

# React Standards

## Components
- Functional components only (no class components).
- One component per file; co-locate styles.
- `PascalCase` naming for components, `camelCase` for exports if needed.
- Extract to subcomponents when render logic exceeds 50 lines.

## Hooks
- Use hooks for all stateful logic (`useState`, `useEffect`, `useContext`).
- Custom hooks for reusable logic (prefix with `use`).
- Define hooks at the top level — never inside conditionals.
- Use `useCallback` for memoized callbacks; `useMemo` sparingly (premature optimization).

## TypeScript & props
- Define all props with TypeScript interfaces/types.
- Avoid `any` — use `unknown` or generics instead.
- Destructure props at function signature.
- Use `React.ReactNode` for children; `React.FC` is optional but clear.

## State management
- Props for simple communication; Context for theme/auth.
- Redux or Zustand only when justified (complex app-wide state).
- Keep state as close to component as possible.

## Testing
- React Testing Library (RTL) — test behavior, not implementation.
- Query by accessible roles (`getByRole`, `getByLabelText`), not test IDs.
- `userEvent` for user interactions; avoid `fireEvent`.

## Validation commands
```
npm run lint            # ESLint
npm run test            # Jest + RTL
npm run build           # production build
```
