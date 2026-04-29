---
name: csharp
description: C# coding standards — nullable types, async/await, LINQ, and .NET conventions.
---

# C# Standards

## Type safety
- Enable nullable reference types: `<Nullable>enable</Nullable>` in csproj.
- Annotate nullability explicitly (`string?` vs `string`).
- Use `record` for immutable value objects (C# 9+).
- Pattern matching over type casting.

## Async
- `async`/`await` all the way up — never block with `.Result` or `.Wait()`.
- `ConfigureAwait(false)` in library code; not needed in ASP.NET Core controllers.
- `CancellationToken` parameter on all async public methods.

## Style
- `dotnet format` on save.
- PascalCase for public members; camelCase with `_` prefix for private fields.
- `var` when type is obvious from the right side; explicit type otherwise.
- XML doc comments (`///`) for all public API members.

## LINQ
- Use LINQ for collection transformations — readable over optimized unless proven hot path.
- Avoid multiple enumeration — materialize with `.ToList()` / `.ToArray()` when reused.
- Prefer method syntax over query syntax for simple operations.

## Dependency injection
- Register services in `Program.cs` / `Startup.cs` — not inside other services.
- Scoped for request-level state, Singleton for stateless services, Transient for lightweight.

## Testing
- xUnit with FluentAssertions.
- Moq for mocking.
- `WebApplicationFactory<T>` for integration tests.

## Validation commands
```
dotnet format --verify-no-changes   # format check
dotnet build                        # build
dotnet test                         # tests
```
