---
name: ruby
<<<<<<< HEAD
description: Ruby coding standards — RuboCop, YARD, RSpec, and idiomatic Ruby patterns.
=======
description: Ruby coding standards — RuboCop, Enumerable, keyword args, and RSpec patterns.
>>>>>>> main
---

# Ruby Standards

<<<<<<< HEAD
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
=======
## Style
- RuboCop enforced (standard or Airbnb config).
- `snake_case` for methods, variables, files.
- `PascalCase` for classes, modules, constants.
- 2-space indentation (never tabs).
- Line length: 100 characters or project standard.

## Method design
- Prefer keyword arguments for methods with > 2 parameters.
- Default values only for optional parameters; make required explicit.
- Use `**kwargs` for flexible options; document expected keys.
- Prefer immutable return values; avoid modifying receivers.

## Enumerable & functional
- Prefer `.map`, `.select`, `.reduce` over `.each` with side effects.
- Chain enumerables for clarity; avoid nested loops.
- Use `Proc` or lambdas sparingly; extract to methods when logic is complex.

## Error handling
- Raise custom exceptions; inherit from `StandardError`.
- Use `ensure` for cleanup, not exception handling.
- Never rescue `Exception` — rescue specific errors.

## Testing
- RSpec for unit & integration tests.
- Factories (Factory Bot) over fixtures.
- Stub external services; avoid test interdependencies.

## Database & ActiveRecord (if used)
- Define associations and validations in the model.
- Use scopes for query clarity.
- Migrations are locked once deployed — never modify old migrations.

## Validation commands
```
rubocop --auto-correct              # auto-fix violations
bundle exec rspec                   # run tests
bundle audit                        # check dependencies
>>>>>>> main
```
