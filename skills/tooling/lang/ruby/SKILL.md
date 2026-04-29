---
name: ruby
description: Ruby coding standards — RuboCop, Enumerable, keyword args, RSpec, and ActiveRecord patterns.
---

# Ruby Standards

## Style (RuboCop)
- RuboCop with project `.rubocop.yml` — no inline `rubocop:disable` without a comment explaining why.
- Two-space indentation; no trailing whitespace.
- `frozen_string_literal: true` magic comment at top of every file.
- Predicate methods end in `?`; dangerous/mutating methods end in `!`.
- Line length: 100 characters or project standard.

## Method design
- Prefer keyword arguments for methods with 3+ parameters.
- Default values only for optional parameters; make required explicit.
- Prefer immutable return values; avoid modifying receivers.

## Enumerable & functional
- Prefer `Enumerable` methods over manual loops (`map`, `select`, `reduce`, `each_with_object`).
- Chain enumerables for clarity; avoid nested loops.
- Use `Struct` or `Data` (Ruby 3.2+) for simple value objects.
- Avoid `method_missing` unless implementing a DSL — prefer explicit delegation.

## Error handling
- Rescue specific exception classes, not bare `rescue`.
- Custom exceptions inherit from `StandardError` (not `Exception`).
- `ensure` for cleanup (files, connections).

## Testing
- RSpec with `let`, `subject`, `shared_examples`.
- FactoryBot for test data — factories over fixtures.
- `bundle exec rspec --format documentation` for readable output.
- Stub external services; avoid test interdependencies.

## Database & ActiveRecord (if used)
- Define associations and validations in the model.
- Use scopes for query clarity.
- Migrations are immutable once deployed — never modify old migrations.

## Validation commands
```
bundle exec rubocop     # lint
bundle exec rspec       # tests
bundle exec rake        # default task (usually test + lint)
```
