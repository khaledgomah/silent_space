# Caching Prompt

## Template
Use the /caching-persistence + /architecture-review skills for {feature_name}.

Requirements:
- Add local data source backed by Hive.
- Define cache strategy: {cache_strategy}.
- Define invalidation rules: {invalidation_rules}.
- Keep domain layer independent from cache implementation.
- Add tests for cache hit/miss/expired scenarios.

## Example
Use the /caching-persistence + /architecture-review skills for session history.

- Strategy: stale-while-revalidate
- Invalidate on sign out and account delete
- Return cached sessions when offline

## Checklist
- [ ] Hive adapters registered safely
- [ ] Cache read/write handled in data layer only
- [ ] Domain and presentation are cache-agnostic
- [ ] Invalidation rules documented and tested
- [ ] Offline behavior is deterministic
