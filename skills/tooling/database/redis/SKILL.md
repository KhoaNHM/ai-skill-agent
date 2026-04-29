---
name: redis
<<<<<<< HEAD
description: Redis standards — key naming, TTL discipline, memory safety, and cluster-aware patterns.
=======
description: Redis standards — key naming, TTL discipline, SCAN operations, and best practices.
>>>>>>> main
---

# Redis Standards

<<<<<<< HEAD
## Key naming
- `namespace:entity:id` convention — e.g., `session:user:abc123`, `cache:product:42`.
- Document key schema in tech-stack.md or a dedicated `REDIS_KEYS.md`.
- Avoid spaces and special characters in key names.

## TTL discipline
- Every key must have a TTL — no unbounded key growth.
- Set TTL at creation: `SET key value EX seconds` or `EXPIRE key seconds` immediately after.
- Review TTLs in code review — missing TTL is a production incident.

## Memory safety
- Avoid storing values >1 MB — consider chunking or using object storage instead.
- Use `SCAN` instead of `KEYS *` in production (never `KEYS *` on large keyspaces).
- Monitor memory with `INFO memory`; set `maxmemory` and an eviction policy (`allkeys-lru`).

## Operations
- `MULTI`/`EXEC` transactions for atomic multi-key operations.
- Pipeline batched operations to reduce round trips.
- `SETNX` / `SET NX EX` for distributed locks — never plain `SET` for locks.

## Cluster awareness
- No multi-key operations across different hash slots (use hash tags `{tag}` to co-locate).
- Pub/Sub: messages are not persisted — use Streams (`XADD`/`XREAD`) for durable queues.
=======
## Key naming & structure
- Use namespace:entity:id pattern: `user:123`, `session:abc123`, `cache:query:user_list`.
- Avoid special characters — use colons for hierarchy, hyphens for spaces.
- Keep keys under 100 bytes for efficiency.
- Document key expiration policy upfront.

## Data types
- Strings for primitives and small objects; hash for larger objects.
- Lists for queues (FIFO) or stacks (LIFO); sets for unique collections.
- Sorted sets for leaderboards, timeranges, or priority queues.
- Streams for event logs (Redis 5.0+).

## TTL discipline
- Set TTL on all cache keys — never permanent cache without review.
- Use `EXPIRE`, `PEXPIRE`, `EXPIREAT` consistently.
- Monitor key eviction policy; use `MAXMEMORY_POLICY`.
- Avoid keys without TTL accumulating over time (memory leak).

## Operations
- Use `SCAN` for large key iteration, never `KEYS` in production.
- Use `PIPELINE` for batching multiple commands.
- Use `EVAL` or Lua scripts for atomic multi-step operations.
- Avoid large values — keep individual values under 512MB.

## Persistence & replication
- Enable RDB snapshots and AOF for durability.
- Configure replication for high availability.
- Use Redis Cluster for horizontal scaling.

## Validation commands
```
redis-cli SCAN 0                    # iterate keys without blocking
redis-cli --latency                 # measure connection latency
redis-cli --stat                    # monitor statistics
redis-cli MEMORY STATS              # memory usage breakdown
```
>>>>>>> main
