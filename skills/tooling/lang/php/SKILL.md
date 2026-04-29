---
name: php
<<<<<<< HEAD
description: PHP coding standards — PSR-12, type declarations, PHPStan, and Composer conventions.
=======
description: PHP coding standards — strict types, type declarations, PHPUnit, and Composer patterns.
>>>>>>> main
---

# PHP Standards

## Type declarations
<<<<<<< HEAD
- Declare `strict_types=1` at the top of every file.
- Type-hint all function parameters and return types (PHP 8+).
- Use union types (`int|string`) and nullable types (`?string`) correctly.
- No implicit type coercion.

## Style (PSR-12)
- PHP_CodeSniffer with PSR-12 ruleset.
- `declare(strict_types=1);` as first statement after `<?php`.
- Class, method, property visibility always declared.
- No closing `?>` tag.

## Modern PHP
- Named arguments for clarity on multi-param function calls.
- Match expressions over switch where possible.
- Enum for fixed value sets (PHP 8.1+).
- Constructor property promotion for DTOs (PHP 8+).

## Error handling
- Use exceptions, not error codes.
- Custom exceptions extend a project base exception.
- Log before re-throwing with context.

## Testing
- PHPUnit with data providers for repetitive cases.
- No database calls in unit tests — use in-memory fakes or Mockery.

## Validation commands
```
composer phpcs          # PSR-12 check
composer phpstan        # static analysis
composer test           # PHPUnit
=======
- Enable `declare(strict_types=1);` in every file.
- All parameters and return types must be declared.
- Use nullable types (`?Type`) instead of `null` defaults.
- Use union types (`Type1|Type2`) for clarity (PHP 8+).

## Style
- PSR-12 standard (via PHP CodeSniffer or Rector).
- PascalCase for class names; `camelCase` for methods/properties; `UPPER_SNAKE_CASE` for constants.
- No trailing whitespace; 4-space indentation (no tabs).
- Use `final` on classes by default; extend only when intentional.

## Objects & design
- Dependency injection via constructor.
- Immutable data transfer objects (DTOs) with typed properties.
- Services layer for business logic; avoid procedural code.
- Type-hint everything — arrays as `Collection<Item>` or typed arrays.

## Error handling
- Exceptions for all exceptional conditions.
- Define custom exception hierarchy.
- Never suppress errors with `@` — fix the root cause.
- Validate and throw `\InvalidArgumentException` for bad input.

## Testing
- PHPUnit for unit & integration tests.
- Mockery or PHPUnit mocks for dependencies.
- Arrange-Act-Assert pattern.

## Validation commands
```
composer install --validate     # validate composer.json
vendor/bin/phpcs --standard=PSR12 src/
vendor/bin/phpunit
>>>>>>> main
```
