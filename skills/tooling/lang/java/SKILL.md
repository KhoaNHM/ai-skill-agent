---
name: java
description: Java coding standards — Checkstyle, SOLID, Spring conventions, and Maven/Gradle patterns.
---

# Java Standards

## Style
- Checkstyle (Google or Sun style) — enforced in CI.
- Class names: `PascalCase`. Methods/variables: `camelCase`. Constants: `UPPER_SNAKE_CASE`.
- Javadoc for all `public` and `protected` members.
- No wildcard imports (`import java.util.*`).

## Design
- Prefer interfaces over abstract classes for API contracts.
- Immutable value objects where possible (`final` fields, no setters).
- Dependency injection — never `new` a service inside another service.
- `Optional<T>` for nullable return values; never return `null` from public methods.

## Spring (if used)
- Constructor injection only (no `@Autowired` on fields).
- `@Service`, `@Repository`, `@Controller` semantics — don't mix concerns.
- `@Transactional` at the service layer, not the controller.
- Validate inputs at controller boundary with Bean Validation (`@Valid`, `@NotNull`).

## Error handling
- Custom exceptions extend a project base exception.
- `@ExceptionHandler` or `@ControllerAdvice` for consistent HTTP error responses.
- Never swallow exceptions with empty catch blocks.

## Testing
- JUnit 5 with AssertJ assertions.
- Mockito for mocking dependencies.
- Integration tests with `@SpringBootTest` only for boundary tests.

## Validation commands
```
mvn verify              # build + test + checkstyle
./gradlew check         # Gradle equivalent
mvn test                # tests only
```
