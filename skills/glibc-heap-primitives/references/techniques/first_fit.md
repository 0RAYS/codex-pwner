# `first_fit`

## Summary

- Family: `Foundations`
- README summary: Demonstrating glibc malloc's first-fit behavior.
- Core effect: show which freed chunk malloc will preferentially reuse in a simple bin state.

## When To Consider It

- when layout reuse matters more than metadata corruption
- when you need to reason about which freed chunk a later allocation will take first
- when a solve depends on predictable chunk recycling before applying a stronger primitive

## Version Groups

- allocator-agnostic reference helper for basic reuse behavior

## Version Differences

- This is a behavioral reference, not a version-specific attack family.
- Use it to sanity-check allocation reuse assumptions before moving on to tcache, fastbin, or overlap-specific reasoning.

## Related Techniques

- `calc_tcache_idx`
