---
name: nextjs
description: Next.js coding standards — App Router, Server Components, Server Actions, image optimization, and metadata.
---

# Next.js Standards

## App Router (Next.js 13+)
- Default to React Server Components (RSC) — no `'use client'` unless the component needs browser APIs or interactivity.
- `'use client'` boundary as low in the tree as possible.
- `layout.tsx` for persistent UI; `page.tsx` for route content; `loading.tsx` for suspense fallback.
- `error.tsx` for route-level error boundaries.
- Leverage automatic code splitting — each route is its own bundle.

## Data fetching
- Fetch in Server Components directly — no `useEffect` + fetch in client components for initial data.
- `cache: 'no-store'` for dynamic data; default (force-cache) for static.
- `revalidate` export for ISR: `export const revalidate = 3600`.
- Use `Suspense` boundaries around async Server Components.
- Never leak secrets in client components — use environment variables carefully.

## Server Actions
- Server Actions for all form mutations — no separate API routes for simple CRUD.
- Validate inputs at the server action level (never trust client data).
- `revalidatePath` / `revalidateTag` after mutations.
- For legacy endpoints, use `app/api/route.ts`.

## Images & fonts
- `next/image` for all images — never raw `<img>` for content images.
- `next/font` for fonts — no Google Fonts `<link>` in `<head>`.
- `next/dynamic` for heavy client components with `ssr: false` when appropriate.

## Metadata
- Define metadata in `layout.tsx` or route `page.tsx` via `generateMetadata()`.
- Ensure dynamic routes generate appropriate metadata for SEO.

## Performance
- Analyse bundle with `@next/bundle-analyzer` before shipping.

## Validation commands
```
next build              # production build (catches type + runtime errors)
npm run lint            # next lint
npm test                # Jest / Vitest
```
