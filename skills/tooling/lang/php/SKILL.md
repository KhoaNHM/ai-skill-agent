---
name: php
description: PHP coding standards — PSR-12, type declarations, PHPStan, and Composer conventions.
---

# PHP Standards

## Type declarations
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
```
