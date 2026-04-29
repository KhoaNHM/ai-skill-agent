---
name: vue
<<<<<<< HEAD
description: Vue 3 coding standards — Composition API, script setup, Pinia, and testing with Vitest.
---

# Vue 3 Standards

## Component style
- `<script setup>` with TypeScript for all new components.
- `defineProps<{...}>()` and `defineEmits<{...}>()` with TypeScript generics.
- One component per `.vue` file; PascalCase filename.
- Props: kebab-case in templates, camelCase in script.

## Composition API
- `ref` for primitives; `reactive` for objects (or always `ref` — be consistent per project).
- `computed` for derived state — never compute in template expressions.
- Extract reusable logic into composables (`use<Name>.ts` in `composables/`).
- `watchEffect` for side effects; `watch` when old value comparison matters.

## State management (Pinia)
- One store per domain (`useUserStore`, `useCartStore`).
- Actions for async operations and mutations.
- Getters for derived state.
- No direct state mutation outside actions.

## Templates
- `v-for` always paired with `:key` (never index as key for dynamic lists).
- `v-if` and `v-for` never on the same element — use `<template>` wrapper.
- Event modifiers: `.prevent`, `.stop`, `.once` where appropriate.

## Testing
- Vitest + Vue Test Utils.
- `mount` for component tests with children; `shallowMount` for isolation.

## Validation commands
```
vue-tsc --noEmit        # typecheck
npm run lint            # ESLint + vue plugin
npm run test            # Vitest
=======
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
>>>>>>> main
```
