---
name: vue
description: Vue coding standards — script setup, defineProps, Composition API, and Pinia state management.
---

# Vue Standards

## Single-file components (SFC)
- Use `<script setup>` (Vue 3+ default).
- Organize: template → script → style (top-down).
- Keep template logic minimal; extract complex computed values or methods.
- Use scoped styles (`<style scoped>`) — never global styles in components.

## Props & events
- Define props with `defineProps<{ propName: Type }>()`; use `withDefaults` for defaults.
- Emit events with `defineEmits<{ eventName: [payload] }>()`.
- Validate prop types at the component boundary.
- Prefer props over direct parent access (`$parent` is a code smell).

## Reactivity (Composition API)
- Use `ref()` for primitives; `reactive()` for objects (sparingly).
- Use `computed()` for derived state.
- `watch()` only for side effects (logging, API calls) — not for derived state.
- Extract reusable logic into composables (functions starting with `use`).

## State management (Pinia)
- Stores for shared, persistent state.
- Actions for mutations; avoid directly modifying store state outside actions.
- Keep store logic simple — move business logic to composables or services.

## Testing
- Vitest for unit tests.
- Vue Test Utils for component testing.
- RTL principles — test behavior, not implementation.

## Validation commands
```
npm run lint            # ESLint
npm run type-check      # TypeScript check
npm run test            # Vitest
npm run build           # production build
```
