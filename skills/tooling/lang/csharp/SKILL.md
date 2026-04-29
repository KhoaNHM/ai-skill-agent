---
name: csharp
description: C# coding standards — nullable annotations, async/await, LINQ, and dotnet conventions.
---

# C# Standards

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
```
