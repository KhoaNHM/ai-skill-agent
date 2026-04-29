---
name: nextjs
description: Next.js coding standards — App Router, Server Components, Server Actions, and image optimization.
---

# Next.js Standards

## App Router (Next.js 13+)
- Use App Router exclusively (no Pages Router unless legacy migration).
- Organize routes as nested folders; `page.ts`/`page.tsx` is the route.
- Use `layout.tsx` for shared UI and providers.
- Leverage automatic code splitting — each route is its own bundle.

## Server Components (RSC)
- Mark components with `"use client"` only when necessary (state, hooks, event listeners).
- Keep the tree as server-side as possible for performance.
- Never leak secrets in client components (use environment variables carefully).
- Server Actions for mutations — replace API routes in most cases.

## API & Server Actions
- Define Server Actions in `app/actions.ts` or co-located in route modules.
- Use `"use server"` directive; handle errors gracefully.
- For legacy endpoints, use `app/api/route.ts`.
- Validate all input at the server boundary.

## Images & fonts
- Always use `next/image` for automatic optimization.
- Use `next/font` for web fonts (local or Google).
- Never use bare `<img>` tags in production.

## Metadata
- Define metadata in `layout.tsx` or route `page.tsx` via `generateMetadata()`.
- Ensure dynamic routes generate appropriate metadata for SEO.

## Validation commands
```
npm run lint            # ESLint
npm run type-check      # TypeScript check
npm run build           # build (catches errors)
npm run dev             # development server
```
