# How2heap Technique Index

This reference condenses the useful solving information from the `how2heap` technique catalog into a self-contained lookup. Match on allocator effect and prerequisites, not on cosmetic similarity to a challenge.

## 1. Foundations

- `first_fit`
  - Use when the solve depends on which freed chunk a new allocation reuses.

- `calc_tcache_idx`
  - Use when the solve depends on filling, draining, or steering one exact tcache bin.

## 2. Duplicate Return Or Chosen Return

- `fastbin_dup`
  - Effect: return the same fastbin chunk twice.
  - Window: `2.23 -> 2.41`.
  - Look for: double free or list reuse after tcache is neutralized.

- `fastbin_dup_into_stack`
  - Effect: steer `malloc` to a near-arbitrary address via fastbin freelist abuse.
  - Window: `2.23 -> 2.41`.
  - Look for: writable fastbin `fd` and a valid target region.

- `fastbin_dup_consolidate`
  - Effect: reclaim a chunk through fastbin plus top-chunk interaction.
  - Window: `2.23 -> 2.41`.
  - Look for: fastbin corruption that survives consolidation.

- `house_of_spirit`
  - Effect: free a fake fastbin chunk to get a chosen return.
  - Window: `2.23 -> 2.41`.
  - Look for: ability to place a fake chunk header in a writable region.

- `tcache_house_of_spirit`
  - Effect: same idea in tcache era.
  - Window: `2.27 -> 2.41`.
  - Look for: fake chunk acceptance under tcache rules.

- `tcache_poisoning`
  - Effect: chosen return through tcache freelist corruption.
  - Window: `2.27 -> 2.41`.
  - Look for: UAF or stale edit on a freed tcache chunk.
  - Extra note: from `2.32+`, the corpus explicitly requires a heap leak and alignment handling.

- `house_of_botcake`
  - Effect: bypass tcache double-free restrictions and recover a chosen-return primitive.
  - Window: `2.27 -> 2.41`.
  - Look for: tcache-era double free where naive duplication is blocked.

- `tcache_metadata_poisoning`
  - Effect: obtain arbitrary pointers by corrupting the tcache metadata structure itself.
  - Window: `2.27 -> 2.41`.
  - Look for: writes that can reach tcache metadata rather than only individual freed chunks.

- `house_of_io`
  - Effect: chosen return via corruption of tcache management state.
  - Window: `2.31 -> 2.33`.
  - Look for: UAF on freed tcache chunks in the narrow version window where this pattern applies.

## 3. Overlap And Consolidation

- `poison_null_byte`
  - Effect: use a single null byte to alter chunk state and drive overlap or consolidation.
  - Window: `2.23 -> 2.41`.
  - Look for: off-by-one null overwrite into next chunk metadata.

- `house_of_einherjar`
  - Effect: clear `prev_inuse`, consolidate backward into a fake chunk, then build overlap or chosen return.
  - Window: `2.23 -> 2.41`.
  - Look for: null-byte overflow plus a known heap address.

- `overlapping_chunks`
  - Effect: overlap through freed-chunk size corruption.
  - Window: `2.23 -> 2.41`, but the README marks the classic form as `< 2.29`.
  - Look for: size corruption on a freed chunk that can still be reallocated across a live neighbor.

- `overlapping_chunks_2`
  - Effect: overlap through in-use chunk size corruption.
  - Window: `2.23 -> 2.24`.
  - Look for: historical targets where a live chunk header is directly reachable.

- `mmap_overlapping_chunks`
  - Effect: overlap involving `mmap` chunks.
  - Window: `2.23 -> 2.41`.
  - Look for: large allocations that bypass the normal heap arena.

## 4. Bin Metadata Abuse And Allocator Writes

- `unsafe_unlink`
  - Effect: arbitrary write by freeing a corrupted chunk that passes unlink checks.
  - Window: `2.23 -> 2.41`.
  - Look for: controllable `fd` and `bk` plus a free path on the corrupted chunk.

- `unsorted_bin_into_stack`
  - Effect: chosen return by corrupting unsorted-bin links.
  - Window: `2.23 -> 2.27`.
  - Look for: historical unsorted-bin corruption with no tcache interference.

- `unsorted_bin_attack`
  - Effect: write a large allocator value to an arbitrary address.
  - Window: `2.23 -> 2.27`.
  - Look for: historical unsorted-bin metadata overwrite.

- `large_bin_attack`
  - Effect: write a large value into a chosen address via large-bin metadata.
  - Window: `2.23 -> 2.41`.
  - Look for: a chunk that really reaches largebin and a writable target.

- `house_of_lore`
  - Effect: chosen return through smallbin freelist abuse.
  - Window: `2.23 -> 2.41`.
  - Look for: controlled smallbin links and a path that keeps the chunk out of tcache.

- `tcache_stashing_unlink_attack`
  - Effect: combine smallbin metadata abuse with tcache stashing to gain chosen return and allocator write effects.
  - Window: `2.27 -> 2.40`.
  - Look for: smallbin corruption in tcache era plus `calloc`-driven stash behavior.

- `fastbin_reverse_into_tcache`
  - Effect: turn fastbin corruption into a large write via tcache refill behavior.
  - Window: `2.27 -> 2.41`.
  - Look for: fastbin corruption on a size that later refills tcache.

- `house_of_mind_fastbin`
  - Effect: use arena handling and limited overwrite to place a heap pointer at an arbitrary address.
  - Window: `2.23 -> 2.41`.
  - Look for: single-byte or partial overwrite where arena-side effects matter more than plain freelist poisoning.

## 5. Wilderness, Arena, And Hybrid Paths

- `house_of_force`
  - Effect: top-chunk steering to force an allocation at a near-arbitrary address.
  - Window: `2.23 -> 2.27`.
  - Look for: historical top-size corruption.

- `house_of_orange`
  - Effect: top-chunk abuse leading to code execution through old allocator internals.
  - Window: `2.23` only in the corpus.
  - Look for: strictly historical targets.

- `house_of_tangerine`
  - Effect: arbitrary return through top-chunk and tcache interaction.
  - Window: `2.27 -> 2.41`.
  - Look for: modern wilderness steering where tcache is part of the finish.

- `house_of_storm`
  - Effect: arbitrary chunk return using UAF on largebin and unsorted-bin chunks.
  - Window: `2.23 -> 2.27`.
  - Look for: historical mixed-bin UAF with both bins in play.

- `house_of_gods`
  - Effect: arena hijack within a small number of allocations.
  - Window: `2.23 -> 2.24`.
  - Look for: old allocator targets where thread arena control is plausible.

- `house_of_roman`
  - Effect: leakless chain using fake fastbins, unsorted-bin attack, and relative overwrites.
  - Window: `2.23 -> 2.24`.
  - Look for: historical leakless exploitation with several primitives chained together.

- `sysmalloc_int_free`
  - Effect: free or recycle an almost arbitrary-sized top chunk through allocator path confusion.
  - Window: `2.23 -> 2.41`.
  - Look for: top-chunk behavior during large allocation growth.

## 6. Safe-Linking And Modern Tcache

- `decrypt_safe_linking`
  - Effect: recover the real pointer from a protected singly linked list entry.
  - Window: `2.32 -> 2.41`.
  - Look for: leaked mangled tcache or fastbin pointers.

- `safe_link_double_protect`
  - Effect: bypass `PROTECT_PTR` by protecting a pointer twice.
  - Window: `2.32 -> 2.41`.
  - Look for: a path that lets you re-encode controlled pointers rather than only decode them.

- `house_of_water`
  - Effect: leakless control of tcache metadata and leakless libc linking in tcache era.
  - Window: `2.32 -> 2.41`.
  - Look for: UAF or double free with reach into modern tcache metadata.

- `tcache_relative_write`
  - Effect: relative write into heap and tcache metadata, including controlled numeric writes and chunk-pointer writes.
  - Window: README marks `>= 2.30`; local examples are present from `2.31 -> 2.41`.
  - Look for: bounded out-of-bounds writes near tcache metadata.

## 7. Fast Bug-Class Mapping

- `UAF`
  - First ask whether it gives a leak from freed metadata.
  - Common next families: `tcache_poisoning`, `fastbin_dup`, `house_of_water`, `unsorted_bin_attack`, `house_of_lore`.

- double free
  - First ask whether tcache blocks the obvious path.
  - Common next families: `fastbin_dup`, `house_of_botcake`, `tcache_poisoning`.

- off-by-one or null-byte overflow
  - First ask whether you can reach next chunk `size` or `prev_inuse`.
  - Common next families: `poison_null_byte`, `house_of_einherjar`, `overlapping_chunks`.

- bounded `OOB`
  - First ask whether the reachable field is a header, a tcache pointer, or metadata near tcache state.
  - Common next families: `tcache_relative_write`, `tcache_metadata_poisoning`, `fastbin_reverse_into_tcache`.

## 8. Common Misclassifications

- Assuming `fastbin_dup` when tcache actually catches the chunk first.
- Assuming plain `tcache_poisoning` on `2.32+` without a heap leak.
- Assuming overlap from an off-by-one before checking real rounded sizes.
- Importing a historical unsorted-bin or top-chunk idea into a target that is outside its viable window.
