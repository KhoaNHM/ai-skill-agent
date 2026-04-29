---
name: angular
description: Angular coding standards — standalone components, signals, RxJS patterns, and testing.
---

# Angular Standards

## Components (Angular 17+)
- Standalone components by default — no `NgModule` for new features.
- `ChangeDetectionStrategy.OnPush` on every component.
- `input()` and `output()` signals API (Angular 17+) over `@Input()`/`@Output()`.

## Reactivity
- Signals (`signal`, `computed`, `effect`) for local/shared state.
- RxJS for streams (HTTP, WebSocket, complex async); signals for UI state.
- Always unsubscribe: `takeUntilDestroyed()` over manual `ngOnDestroy`.
- `async` pipe in templates to auto-manage subscriptions.

## Services
- `providedIn: 'root'` for singletons; `providedIn: 'any'` for per-module instances.
- Constructor injection with `inject()` function (Angular 14+).
- HttpClient — typed responses (`HttpClient.get<ResponseType>(...)`).

## Templates
- No logic in templates beyond simple ternary or pipe usage.
- `@if`, `@for`, `@switch` (new control flow syntax, Angular 17+).
- Avoid direct DOM access — use `ElementRef` only as a last resort.

## Testing
- Jest (preferred) or Karma + Jasmine.
- `TestBed` for component/service integration tests.
- Spectator for reduced boilerplate.

## Validation commands
```
ng build                # AOT compile check
ng lint                 # ESLint
ng test --watch=false   # tests
```
