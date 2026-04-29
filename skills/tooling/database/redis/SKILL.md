---
name: redis
description: Redis standards — key naming, TTL discipline, data types, memory safety, and cluster-aware patterns.
---

# Redis Standards

## Key naming
- `namespace:entity:id` convention — e.g., `session:user:abc123`, `cache:product:42`.
- Avoid spaces and special characters in key names; keep keys under 100 bytes.
- Document key schema in tech-stack.md or a dedicated `REDIS_KEYS.md`.

## Data types
- Strings for primitives and small objects; hash for larger objects with multiple fields.
- Lists for queues (FIFO) or stacks (LIFO); sets for unique collections.
- Sorted sets for leaderboards, time-ranges, or priority queues.
- Streams (`XADD`/`XREAD`) for durable event logs (Redis 5.0+).

## TTL discipline
- Every key must have a TTL — no unbounded key growth.
- Set TTL at creation: `SET key value EX seconds` or `EXPIRE key seconds` immediately after.
- Review TTLs in code review — missing TTL is a production incident.

## Memory safety
- Avoid storing values >1 MB — consider chunking or object storage instead.
- Use `SCAN` instead of `KEYS *` in production (never `KEYS *` on large keyspaces).
- Monitor memory with `INFO memory`; set `maxmemory` and an eviction policy (`allkeys-lru`).

## Operations
- `MULTI`/`EXEC` transactions for atomic multi-key operations.
- Pipeline batched operations to reduce round trips.
- `SETNX` / `SET NX EX` for distributed locks — never plain `SET` for locks.

## Cluster awareness
- No multi-key operations across different hash slots (use hash tags `{tag}` to co-locate).
- Pub/Sub: messages are not persisted — use Streams for durable queues.

## Validation commands
```
redis-cli SCAN 0
redis-cli --latency
redis-cli MEMORY STATS
redis-cli INFO memory
```
