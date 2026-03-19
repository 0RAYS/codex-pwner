# `calc_tcache_idx`

## Summary

- Family: `Foundations`
- README summary: Demonstrating glibc's tcache index calculation.
- Core effect: map request sizes to the tcache bin index that will actually be used.

## When To Consider It

- when the exploit depends on filling, draining, or targeting one exact tcache size class
- when a poisoning plan fails because the chunk is landing in a different tcache bin than expected

## Version Groups

- allocator-agnostic reference helper for tcache-era targets

## Version Differences

- This is a calculation aid rather than a version-sensitive exploitation chain.
- The important solver question is not cross-version code drift but whether the target runtime actually has tcache enabled for the size class you care about.

## Related Techniques

- `first_fit`
