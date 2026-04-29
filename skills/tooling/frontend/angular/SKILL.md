---
name: angular
description: Angular coding standards — standalone components, signals, OnPush strategy, RxJS patterns, and testing.
---

# Angular Standards

## Standalone components (Angular 14+)
- Standalone components by default — no `NgModule` for new features.
- Import dependencies directly in the component (`imports: [CommonModule, FormsModule]`).
- `ChangeDetectionStrategy.OnPush` on every component.
- `input()` and `output()` signals API (Angular 17+) over `@Input()`/`@Output()`.

## Signals & change detection
- Signals (`signal`, `computed`, `effect`) for local/shared state — faster than RxJS subjects for local state.
- Pass immutable data to child components.
- Signals automatically trigger efficient re-renders with OnPush.

## RxJS & observables
- RxJS for streams (HTTP, WebSocket, complex async); signals for UI state.
- Always unsubscribe: `takeUntilDestroyed()` over manual `ngOnDestroy`.
- `async` pipe in templates to auto-manage subscriptions.
- Avoid nested subscriptions — use operators like `switchMap`, `mergeMap`, `withLatestFrom`.

## Services & dependency injection
- `providedIn: 'root'` for singletons; `providedIn: 'any'` for per-module instances.
- `inject()` function for standalone components (Angular 14+).
- HttpClient — typed responses (`HttpClient.get<ResponseType>(...)`).

## Templates
- No logic in templates beyond simple ternary or pipe usage.
- `@if`, `@for`, `@switch` (new control flow syntax, Angular 17+).
- Avoid direct DOM access — use `ElementRef` only as a last resort.

## Forms
- Reactive forms (`FormBuilder`, `FormGroup`) for complex forms.
- Template-driven forms only for simple, non-validated input.
- Validators for all form fields — custom validators as needed.

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
