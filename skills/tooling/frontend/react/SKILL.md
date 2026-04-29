---
name: react
<<<<<<< HEAD
description: React coding standards — hooks, component design, accessibility, and testing with RTL.
=======
description: React coding standards — functional components, hooks, TypeScript props, and RTL testing.
>>>>>>> main
---

# React Standards

## Components
<<<<<<< HEAD
- Functional components + hooks only — no class components.
- One component per file; filename matches component name (PascalCase).
- Single responsibility: if a component fetches AND renders AND handles form state, split it.
- Extract custom hooks (`useXxx`) for reusable stateful logic.

## Props
- TypeScript interface for every component's props — no untyped prop objects.
- Destructure props at the function signature level.
- `children` typed as `React.ReactNode`.
- Default props via default parameter values, not `defaultProps`.

## Hooks
- `useCallback` for event handlers passed to child components.
- `useMemo` for expensive derived values — not for every calculation.
- `useEffect` cleanup: always return cleanup function for subscriptions/timers.
- No async function directly inside `useEffect` — use an inner async function.

## State
- Local state (`useState`) for component-only state.
- Lift state up to the nearest common ancestor.
- Context for cross-tree state that doesn't change frequently.
- External store (Zustand, Jotai, Redux) for global or high-frequency state.

## Accessibility
- Semantic HTML first (`<button>`, `<nav>`, `<main>`) over `<div>` with `onClick`.
- `aria-*` attributes for custom interactive elements.
- Keyboard navigation: all interactive elements reachable via Tab, activatable via Enter/Space.
- Images: always meaningful `alt` text or `alt=""` for decorative images.

## Testing
- React Testing Library — test behaviour, not implementation.
- Query by accessible role/label, not by test ID where possible.
- `userEvent` over `fireEvent` for realistic interaction simulation.
=======
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
>>>>>>> main

## Validation commands
```
npm run lint            # ESLint
<<<<<<< HEAD
npm run typecheck       # tsc --noEmit
npm test                # Jest / Vitest
=======
npm run test            # Jest + RTL
npm run build           # production build
>>>>>>> main
```
