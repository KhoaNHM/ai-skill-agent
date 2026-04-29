---
name: nextjs
description: Next.js coding standards — App Router, React Server Components, Server Actions, and performance.
---

# Next.js Standards

## App Router (Next.js 13+)
- Default to React Server Components (RSC) — no `'use client'` unless the component needs browser APIs or interactivity.
- `'use client'` boundary as low in the tree as possible.
- `layout.tsx` for persistent UI; `page.tsx` for route content; `loading.tsx` for suspense fallback.
- `error.tsx` for route-level error boundaries.

## Data fetching
- Fetch in Server Components directly — no `useEffect` + fetch in client components for initial data.
- `cache: 'no-store'` for dynamic data; default (force-cache) for static.
- `revalidate` export for ISR: `export const revalidate = 3600`.
- Use `Suspense` boundaries around async Server Components.

## Server Actions
- Server Actions for all form mutations — no separate API routes for simple CRUD.
- Validate inputs at the server action level (never trust client data).
- `revalidatePath` / `revalidateTag` after mutations.

## Performance
- `next/image` for all images — never raw `<img>` for content images.
- `next/font` for fonts — no Google Fonts `<link>` in `<head>`.
- `next/dynamic` for heavy client components with `ssr: false` when appropriate.
- Analyse bundle with `@next/bundle-analyzer` before shipping.

## Validation commands
```
next build              # production build (catches type + runtime errors)
npm run lint            # next lint
npm test                # Jest / Vitest
```
