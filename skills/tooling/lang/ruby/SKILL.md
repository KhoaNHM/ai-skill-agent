---
name: ruby
description: Ruby coding standards — RuboCop, YARD, RSpec, and idiomatic Ruby patterns.
---

# Ruby Standards

## Style (RuboCop)
- RuboCop with project `.rubocop.yml` — no inline `rubocop:disable` without a comment explaining why.
- Two-space indentation; no trailing whitespace.
- `frozen_string_literal: true` magic comment at top of every file.
- Predicate methods end in `?`; dangerous/mutating methods end in `!`.

## Patterns
- Prefer `Enumerable` methods over manual loops (`map`, `select`, `reduce`, `each_with_object`).
- Use keyword arguments for methods with 3+ parameters.
- `Struct` or `Data` (Ruby 3.2+) for simple value objects.
- Avoid `method_missing` unless implementing a DSL — prefer explicit delegation.

## Error handling
- Rescue specific exception classes, not bare `rescue`.
- Custom exceptions inherit from `StandardError` (not `Exception`).
- `ensure` for cleanup (files, connections).

## Testing
- RSpec with `let`, `subject`, `shared_examples`.
- FactoryBot for test data.
- `bundle exec rspec --format documentation` for readable output.

## Validation commands
```
bundle exec rubocop     # lint
bundle exec rspec       # tests
bundle exec rake        # default task (usually test + lint)
```
