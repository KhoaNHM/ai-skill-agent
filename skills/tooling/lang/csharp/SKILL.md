---
name: csharp
<<<<<<< HEAD
description: C# coding standards — nullable types, async/await, LINQ, and .NET conventions.
=======
description: C# coding standards — nullable annotations, async/await, LINQ, and dotnet conventions.
>>>>>>> main
---

# C# Standards

<<<<<<< HEAD
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
=======
## Nullable types & annotations
- Enable `#nullable enable` at the file level (or project-wide via `.csproj`).
- Use `T?` for nullable reference types; `string!` for asserting non-null.
- Check for null before dereferencing; use `?.` operator liberally.
- Initialize properties or use `[Required]` attribute from `System.ComponentModel.DataAnnotations`.

## Async/await
- All I/O operations async by default.
- `ConfigureAwait(false)` in library code to avoid deadlocks.
- Never `.Wait()` or `.Result` on `Task` — use `async all the way`.
- Use `TaskCompletionSource` or `ValueTask` only when necessary.

## LINQ & collections
- Prefer LINQ methods over foreach loops where readable.
- `IEnumerable<T>` for query methods; materialize with `.ToList()` or `.ToArray()` only when needed.
- Use `System.Collections.Immutable` for thread-safe collections.

## Style
- `dotnet format` before committing (C# 10+).
- PascalCase for public members; `_camelCase` for private fields.
- Use records for immutable DTOs.
- Prefer properties over public fields.

## Validation & testing
- xUnit or NUnit for tests.
- Moq for mocking.
- Use `[Fact]` for deterministic tests, `[Theory]` for parameterized tests.

## Validation commands
```
dotnet format --verify-no-changes  # format check
dotnet build                        # build
dotnet test                         # run tests
>>>>>>> main
```
