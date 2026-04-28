---
name: ruby
description: Ruby coding standards — RuboCop, Enumerable, keyword args, and RSpec patterns.
---

# Ruby Standards

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
```
