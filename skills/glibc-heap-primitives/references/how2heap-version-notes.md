# How2heap Version Notes

This reference extracts the version-relevant information that is most useful during solving.

## 1. Major Era Boundaries

- `glibc < 2.26`
  - No tcache.
  - Classic fastbin, unsorted-bin, smallbin, largebin, and wilderness techniques dominate.
  - Many historical techniques in the corpus are limited to this era or disappear after `2.27` or `2.28`.

- `glibc 2.26`
  - Tcache is introduced.
  - `unlink` gains a size-consistency check: corrupted `size` and `prev_size` must still agree.

- `glibc 2.27`
  - Ubuntu builds enable tcache in practice.
  - `malloc_consolidate` adds a fastbin size check, which makes sloppy fastbin corruption easier to catch.
  - Treat `2.27+` as the point where many old “just use fastbin/unsorted” intuitions must be re-checked against tcache behavior.

- `glibc 2.32+`
  - Safe-linking becomes a first-class concern in the corpus.
  - Plain `tcache_poisoning` now needs a heap leak and proper alignment.
  - Dedicated techniques such as `decrypt_safe_linking`, `safe_link_double_protect`, and `house_of_water` appear for this era.

## 2. Technique Windows That Matter

- Broadly portable across the corpus, `2.23 -> 2.41`
  - `fastbin_dup`
  - `fastbin_dup_into_stack`
  - `fastbin_dup_consolidate`
  - `unsafe_unlink`
  - `house_of_spirit`
  - `poison_null_byte`
  - `house_of_lore`
  - `overlapping_chunks`
  - `mmap_overlapping_chunks`
  - `large_bin_attack`
  - `house_of_einherjar`
  - `house_of_mind_fastbin`
  - `sysmalloc_int_free`

- Tcache-era staples, `2.27 -> 2.41`
  - `tcache_poisoning`
  - `tcache_house_of_spirit`
  - `house_of_botcake`
  - `tcache_metadata_poisoning`
  - `fastbin_reverse_into_tcache`
  - `house_of_tangerine`
  - `tcache_stashing_unlink_attack`

- Safe-linking-era additions, `2.32 -> 2.41`
  - `decrypt_safe_linking`
  - `safe_link_double_protect`
  - `house_of_water`
  - `tcache_relative_write` is listed in the README for `>= 2.30`, and local examples are shipped from `2.31` onward

- Narrow-window techniques
  - `house_of_io`: `2.31 -> 2.33`
  - `tcache_dup` obsolete demo: `2.26 -> 2.28`

- Historical-only techniques
  - `house_of_force`: `2.23 -> 2.27`
  - `unsorted_bin_attack`: `2.23 -> 2.27`
  - `unsorted_bin_into_stack`: `2.23 -> 2.27`
  - `house_of_storm`: `2.23 -> 2.27`
  - `house_of_orange`: only `2.23`
  - `house_of_roman`: `2.23 -> 2.24`
  - `house_of_gods`: `2.23 -> 2.24`
  - `overlapping_chunks_2`: `2.23 -> 2.24`

## 3. Practical Solver Takeaways

- If a writeup idea depends on old unsorted-bin or top-chunk behavior, verify that the target is actually in the historical window first.
- On `2.27+`, always ask whether tcache is intercepting the chunk you wanted in fastbin or unsorted bin.
- On `2.32+`, treat a heap leak, alignment, or a safe-linking bypass as a likely prerequisite for any singly-linked freelist attack.
- When a technique exists across many versions, the primitive family may still be stable even if the exact setup sequence changes.
