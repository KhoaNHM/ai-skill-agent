---
name: api-design
description: Contract-first API design — endpoint definition, DTO spec, response shape, status codes, and Swagger alignment before any implementation.
---

# API Design

Use before writing any controller, service, or DTO code. Design the contract first; implement second.

## Memory — read first

1. `.ai/memory/context/requirements.md` — acceptance criteria drive the API
2. `.ai/memory/architecture/api-contracts.md` — existing contracts to stay consistent with

## Contract-first process

### Step 1 — Identify consumers and use cases

- Who calls this endpoint? (frontend, mobile, another service, external partner)
- What do they send? What do they expect back?
- What errors do they need to handle?

### Step 2 — Define the endpoint

```
METHOD /resource[/:id][/sub-resource]
```

- Method: GET (read), POST (create), PUT (full replace), PATCH (partial update), DELETE (remove)
- Path: plural noun, no verbs, consistent with existing routes
- Auth: required? which roles?

### Step 3 — Request specification

```
Headers:
  Authorization: Bearer <token>    (if auth required)
  Content-Type: application/json   (for POST/PUT/PATCH)

Path params:
  :id  — type, validation rule

Query params:
  page    — number, default 1
  limit   — number, max 100, default 20
  [filter] — type, allowed values

Body (POST/PUT/PATCH):
  {
    "fieldName": type,   // required | optional — validation rule
  }
```

### Step 4 — Response specification

```
Success:
  Status: 200 | 201
  Body: {
    "data": { ... },      // resource or list
    "meta": {             // pagination if list
      "total": number,
      "page": number,
      "limit": number
    }
  }

Error responses:
  400 Bad Request:     { "message": "validation error detail" }
  401 Unauthorized:    { "message": "Unauthorized" }
  403 Forbidden:       { "message": "Forbidden" }
  404 Not Found:       { "message": "[Resource] not found" }
  409 Conflict:        { "message": "[conflict reason]" }
  500 Internal:        { "message": "Internal server error" }
```

### Step 5 — Validate the contract

- Does every AC from requirements.md map to a response case?
- Is the shape consistent with existing endpoints?
- Are all error paths documented?

## Output

Write the full contract to `.ai/memory/architecture/api-contracts.md`.
**Read back** `api-contracts.md` after writing — confirm all endpoints, request/response shapes, and status codes are present before handing off to Engineer.

Template:

```markdown
---
type: architecture
phase: 1-architect
last-updated: YYYY-MM-DD
updated-by: ARCHITECT_AGENT
status: active
---

# API Contracts — [Feature Name]

## [Endpoint Name]

**Route:** `METHOD /path`
**Auth:** required / public / role: [role]

**Request:**
[spec from Step 3]

**Response:**
[spec from Step 4]
```
