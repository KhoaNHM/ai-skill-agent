---
name: vue
description: Vue 3 coding standards — script setup, defineProps, Composition API, Pinia state management, and Vitest.
---

# Vue 3 Standards

## Single-file components
- `<script setup>` with TypeScript for all new components.
- Organize: template → script → style (top-down).
- Use scoped styles (`<style scoped>`) — never global styles in components.
- One component per `.vue` file; PascalCase filename.

## Props & events
- `defineProps<{...}>()` and `defineEmits<{...}>()` with TypeScript generics.
- Use `withDefaults` for default values.
- Props: kebab-case in templates, camelCase in script.
- Prefer props over direct parent access (`$parent` is a code smell).

## Composition API
- `ref` for primitives; `reactive` for objects (or always `ref` — be consistent per project).
- `computed` for derived state — never compute in template expressions.
- `watch` only for side effects (logging, API calls) — not for derived state.
- Extract reusable logic into composables (`use<Name>.ts` in `composables/`).

## State management (Pinia)
- One store per domain (`useUserStore`, `useCartStore`).
- Actions for async operations and mutations; avoid directly modifying store state outside actions.
- Getters for derived state.
- Keep store logic simple — move business logic to composables or services.

## Templates
- `v-for` always paired with `:key` (never index as key for dynamic lists).
- `v-if` and `v-for` never on the same element — use `<template>` wrapper.
- Event modifiers: `.prevent`, `.stop`, `.once` where appropriate.

## Testing
- Vitest + Vue Test Utils.
- `mount` for component tests with children; `shallowMount` for isolation.
- Test behaviour, not implementation details.

## Validation commands
```
vue-tsc --noEmit        # typecheck
npm run lint            # ESLint + vue plugin
npm run test            # Vitest
```
