---
name: angular
<<<<<<< HEAD
description: Angular coding standards — standalone components, signals, RxJS patterns, and testing.
=======
description: Angular coding standards — standalone components, signals, OnPush strategy, and RxJS patterns.
>>>>>>> main
---

# Angular Standards

<<<<<<< HEAD
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
=======
## Standalone components (Angular 14+)
- Use `standalone: true` by default — no need for NgModules in new projects.
- Import dependencies directly in component (`imports: [CommonModule, FormsModule]`).
- Define local directives/pipes in the component `imports`.

## Signals
- Use signals for component state (faster than RxJS subjects for local state).
- Leverage computed signals for derived state.
- Avoid overusing RxJS; prefer signals for reactive dependencies.

## Change detection
- Use `ChangeDetectionStrategy.OnPush` in all components.
- Pass immutable data to child components.
- Signals automatically trigger efficient re-renders with OnPush.

## RxJS & observables
- Use observables for streams of external events (HTTP, subscriptions).
- Unsubscribe automatically: use `async` pipe in templates or `takeUntilDestroyed()`.
- Avoid nested subscriptions — use operators like `switchMap`, `mergeMap`, `withLatestFrom`.

## Dependency injection
- Constructor injection for all dependencies.
- Use `inject()` function for standalone components (cleaner than constructor params).
- Provide services at the appropriate level (root, component, or feature module).

## Forms
- Reactive forms (`FormBuilder`, `FormGroup`) for complex forms.
- Template-driven forms only for simple, non-validated input.
- Validators for all form fields — custom validators as needed.

## Testing
- Jasmine + Karma, or Jest (if configured).
- TestBed for component testing.
- Spy on dependencies; avoid full integration tests until necessary.

## Validation commands
```
ng lint                 # ESLint
ng test                 # Jasmine/Karma
ng build                # production build
>>>>>>> main
```
