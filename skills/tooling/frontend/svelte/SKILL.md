---
name: svelte
<<<<<<< HEAD
description: Svelte/SvelteKit coding standards — reactivity, stores, and SvelteKit conventions.
=======
description: Svelte coding standards — reactivity stores, SvelteKit routing, and compiler semantics.
>>>>>>> main
---

# Svelte Standards

## Reactivity
<<<<<<< HEAD
- Reactive declarations (`$:`) for derived values — keep them simple.
- Avoid complex side effects in `$:` — use `onMount` or explicit functions.
- Stores (`writable`, `readable`, `derived`) for cross-component state.
- `$store` auto-subscription syntax in templates; manually unsubscribe in non-component JS.

## Components
- One component per `.svelte` file; PascalCase filename.
- Props declared with `export let propName` (or `$props()` in Svelte 5).
- Events via `createEventDispatcher` (Svelte 4) or `$emit` pattern (Svelte 5).
- Slots for composable layout.

## SvelteKit (if used)
- `+page.svelte` for routes; `+layout.svelte` for persistent UI.
- `+page.server.ts` for server-only load functions (DB access, auth checks).
- `+page.ts` for shared load functions (runs on server + client).
- Form actions in `+page.server.ts` for mutations.

## Validation commands
```
svelte-check            # type + Svelte validation
npm run lint            # ESLint + svelte plugin
npm test                # Vitest / Playwright
=======
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
>>>>>>> main
```
