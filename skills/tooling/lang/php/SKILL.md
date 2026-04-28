---
name: php
description: PHP coding standards — strict types, type declarations, PHPUnit, and Composer patterns.
---

# PHP Standards

## Type declarations
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
```
