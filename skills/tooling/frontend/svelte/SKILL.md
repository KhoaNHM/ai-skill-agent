---
name: svelte
description: Svelte coding standards — reactivity stores, SvelteKit routing, and compiler semantics.
---

# Svelte Standards

## Reactivity
- Use `let` declarations for reactive state — no `useState` or `ref` needed.
- Use `$:` label for reactive statements (similar to `useEffect`).
- Keep reactive logic in the script block — templates remain clean.
- Avoid side effects in reactive blocks; use `onMount` or explicit event handlers.

## Stores
- Writable stores for component state that spans multiple components.
- Readable stores for derived state.
- Subscribe in components with `$store` syntax (auto-unsubscribe).
- Use `derived()` for computed store values.

## SvelteKit (if used)
- Organize routes in `src/routes` — nested folders become nested routes.
- Use `+page.svelte` for routes, `+layout.svelte` for layouts.
- Server-side logic in `+page.server.ts` (form actions, data loading).
- `+server.ts` for custom API endpoints.

## Event handling
- Define event handlers inline (`on:click`).
- Use event modifiers (`on:click|once`, `on:click|preventDefault`).
- Prop drilling is acceptable in Svelte (minimal boilerplate).

## Bindings
- Use `bind:value`, `bind:checked` for two-way binding (type-safe).
- Avoid over-using `bind:this` — query DOM when needed, not as default.

## Testing
- Vitest for unit tests.
- Testing Library for component testing.

## Validation commands
```
npm run lint            # ESLint
npm run type-check      # TypeScript check
npm run test            # Vitest
npm run build           # production build
```
