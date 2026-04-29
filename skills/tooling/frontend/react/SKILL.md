---
name: react
description: React coding standards — hooks, component design, accessibility, and testing with RTL.
---

# React Standards

## Components
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

## Validation commands
```
npm run lint            # ESLint
npm run typecheck       # tsc --noEmit
npm test                # Jest / Vitest
```
