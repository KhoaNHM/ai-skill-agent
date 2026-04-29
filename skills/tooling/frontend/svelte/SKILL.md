---
name: svelte
description: Svelte/SvelteKit coding standards — reactivity, stores, and SvelteKit conventions.
---

# Svelte Standards

## Reactivity
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
```
