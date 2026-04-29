---
name: rust
description: Rust coding standards — ownership, error handling, clippy, and cargo conventions.
---

# Rust Standards

## Ownership & borrowing
- Prefer borrowing (`&T`, `&mut T`) over cloning.
- `.clone()` is a code smell — comment why it's necessary when used.
- Use `Cow<str>` for functions that may or may not own their string input.

## Error handling
- `Result<T, E>` for all fallible operations; `?` operator for propagation.
- No `.unwrap()` or `.expect()` in production code — only in tests or `main`.
- Define a project-level error enum with `thiserror`.
- Use `anyhow` for application-level error context; `thiserror` for library errors.

## Style
- `cargo fmt` before committing.
- `cargo clippy -- -D warnings` — treat all warnings as errors.
- Descriptive names; follow Rust naming conventions (`snake_case` for vars/fns, `PascalCase` for types).
- Prefer iterators over manual loops.

## Async (if used)
- `tokio` or `async-std` — pick one per project.
- Never block in async context (no `std::thread::sleep`, no sync I/O).
- Use `tokio::spawn` for fire-and-forget; `JoinHandle` to await completion.

## Testing
- Unit tests in the same file as the code (`#[cfg(test)]` module).
- Integration tests in `tests/`.
- Use `proptest` or `quickcheck` for property-based testing where appropriate.

## Validation commands
```
cargo fmt --check       # format check
cargo clippy -- -D warnings  # lint
cargo test              # tests
cargo build --release   # release build check
```
