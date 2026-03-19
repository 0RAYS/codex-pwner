---
name: glibc-heap-primitives
description: Use this skill for GLIBC heap CTF solving when you need to identify a heap primitive, map it to the right how2heap-style technique family, account for version-specific hardening, and turn local allocator behavior into a working exploit chain.
---

# GLIBC Heap Primitives

Use this skill when solving GLIBC heap binaries. The `references/` directory contains extracted technique summaries and version-difference notes, so the original `how2heap` repository is not required.

## Trigger

- The target is a GLIBC heap binary with primitives such as `alloc`, `free`, `edit`, `show`, `merge`, `copy`, or `view`.
- You have identified or suspect a heap bug such as `UAF`, double free, off-by-one, null-byte overflow, bounded `OOB`, or stale metadata writes.
- You need to map an observed allocator effect to a known technique family without copying a concrete challenge writeup.
- You want help deciding what leak, overlap, freelist corruption, or endgame should come next for the current `glibc` version.

Do not use this skill for:

- musl, jemalloc, kernel, or Windows heap targets
- pure static reverse engineering with no meaningful heap behavior yet
- full remediation or allocator patch analysis

## Workflow

1. Model the runtime.
   Read [how2heap-version-notes.md](./references/how2heap-version-notes.md) and place the target in one of three eras:
   - pre-tcache
   - tcache without safe-linking
   - safe-linking era

2. Name the current allocator primitive.
   Reduce the bug to what allocator state you actually control:
   - chunk size or `prev_inuse`
   - freelist pointer
   - top chunk or arena state
   - tcache metadata
   - resulting effect: overlap, duplicate return, chosen return, leak, relative write, large allocator write

3. Map to a technique family.
   Read [how2heap-technique-index.md](./references/how2heap-technique-index.md) and match on effect plus prerequisites, not on challenge aesthetics.

4. Verify prerequisites before payload work.
   Use [exploit-checklist.md](./references/exploit-checklist.md) to confirm:
   - real chunk sizes after rounding
   - adjacency
   - target bin path
   - tcache saturation
   - leak requirements
   - alignment and metadata restoration

5. Advance one phase at a time.
   Solve in order:
   - layout
   - corruption
   - primitive
   - leak or write
   - final control target

6. When stuck, debug allocator state instead of changing payload syntax.
   Most failures come from wrong size classes, wrong bins, hidden tcache absorption, or ignored safe-linking constraints.

## High-Value Rules

- Name the primitive before naming the technique.
- A freed `show` is usually a leak opportunity before it is a code-exec opportunity.
- On `glibc >= 2.32`, raw tcache pointer writes usually mean you are missing a heap leak or a bypass.
- If a chain is fragile, rebuild the allocator behavior in a minimal harness first.

## References

- Read [how2heap-version-notes.md](./references/how2heap-version-notes.md) for era boundaries and major compatibility shifts extracted from the corpus.
- Read [how2heap-technique-index.md](./references/how2heap-technique-index.md) for technique families, version windows, and solver-oriented prerequisites.
- Read [techniques-index.md](./references/techniques-index.md) for one-markdown-per-technique lookup pages.
- Read [exploit-checklist.md](./references/exploit-checklist.md) while advancing from primitive confirmation to a stable end-to-end exploit.
