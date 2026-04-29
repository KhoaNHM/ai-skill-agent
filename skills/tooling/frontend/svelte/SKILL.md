---
name: svelte
description: Svelte/SvelteKit coding standards — reactivity, stores, event handling, and SvelteKit conventions.
---

# Svelte Standards

## Reactivity
- `let` declarations for reactive state — no `useState` or `ref` needed.
- `$:` reactive declarations for derived values — keep them simple.
- Avoid complex side effects in `$:` — use `onMount` or explicit event handlers.
- Keep reactive logic in the script block; templates remain clean.

## Stores
- `writable` stores for component state that spans multiple components.
- `readable` stores for external data sources.
- `derived` stores for computed state.
- `$store` auto-subscription syntax in templates; manually unsubscribe in non-component JS.

## Components
- One component per `.svelte` file; PascalCase filename.
- Props declared with `export let propName` (or `$props()` in Svelte 5).
- Events via `createEventDispatcher` (Svelte 4) or `$emit` pattern (Svelte 5).
- Slots for composable layout.

## Event handling
- Define event handlers inline (`on:click`).
- Use event modifiers (`on:click|once`, `on:click|preventDefault`).

## Bindings
- Use `bind:value`, `bind:checked` for two-way binding (type-safe).
- Avoid over-using `bind:this` — query DOM when needed, not as default.

## SvelteKit (if used)
- `+page.svelte` for routes; `+layout.svelte` for persistent UI.
- `+page.server.ts` for server-only load functions (DB access, auth checks).
- `+page.ts` for shared load functions (runs on server + client).
- Form actions in `+page.server.ts` for mutations.

## Testing
- Vitest for unit tests.
- Testing Library for component testing.

## Validation commands
```
svelte-check            # type + Svelte validation
npm run lint            # ESLint + svelte plugin
npm test                # Vitest / Playwright
```
