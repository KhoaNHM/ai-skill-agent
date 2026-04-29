---
name: go
description: Go coding standards — error handling, interfaces, gofmt, and idiomatic patterns.
---

# Go Standards

## Error handling
- Always handle errors — never assign to `_` unless intentionally discarding.
- Wrap errors with context: `fmt.Errorf("doing X: %w", err)`.
- Return errors up; handle (log + decide) at the boundary.
- Use `errors.Is` / `errors.As` for error type checks, not string comparison.

## Style
- `gofmt` / `goimports` on save — no exceptions.
- Short, idiomatic variable names in small scopes (`i`, `v`, `k`); descriptive in larger scopes.
- Avoid stuttering: `user.UserID` → `user.ID`.
- Comment exported identifiers with a sentence starting with the identifier name.

## Interfaces
- Define interfaces at the consumer, not the producer.
- Keep interfaces small (1–3 methods); compose larger ones.
- Accept interfaces, return structs.

## Concurrency
- Use channels for communication, mutexes for state protection — not both for the same value.
- Always handle goroutine lifecycle (context cancellation, WaitGroup, errgroup).
- Race detector in CI: `go test -race ./...`.

## Packages
- One package per directory; package name = directory name (lowercase, no underscores).
- `internal/` for packages not intended as public API.

## Validation commands
```
gofmt -l .              # format check (should print nothing)
go vet ./...            # static analysis
golangci-lint run       # lint (if installed)
go test ./...           # tests
go test -race ./...     # race detector
```
