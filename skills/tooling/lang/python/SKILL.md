---
name: python
description: Python coding standards — type hints, PEP 8, pytest, and packaging conventions.
---

# Python Standards

## Type hints
- Type-annotate all function signatures (PEP 484).
- Use `from __future__ import annotations` for forward references.
- Prefer `X | None` over `Optional[X]` (Python 3.10+).
- Use `TypedDict` or `dataclass` for structured dicts.

## Style (PEP 8)
- Black formatter — run before committing.
- `isort` for import ordering.
- Max line length: 88 (Black default).
- Docstrings: Google style for all public functions/classes.

## Patterns
- f-strings over `.format()` or `%`.
- List/dict/set comprehensions where clear; generator expressions for large sequences.
- Context managers (`with`) for file I/O, DB connections, locks.
- `dataclass` or `pydantic` over raw dicts for structured data.

## Error handling
- Catch specific exceptions, not bare `except:`.
- Custom exceptions inherit from a project-level base exception class.
- Log before re-raising when context is important.

## Testing
- pytest with fixtures.
- `pytest-cov` for coverage.
- One test file per module: `test_<module>.py`.
- Parametrize repetitive cases with `@pytest.mark.parametrize`.

## Validation commands
```
black --check .         # format check
isort --check .         # import order
flake8 .                # lint
mypy .                  # typecheck
pytest                  # tests
```
