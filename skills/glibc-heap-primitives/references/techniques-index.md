# Techniques Index

Each file in `references/techniques/` is a standalone note for one retained heap exploitation technique. Technique pages include solver-oriented summaries and version-difference notes; `house_of_*` pages and other retained exploitation pages also keep one representative source block for quick reference.

## Foundations

- [calc_tcache_idx](./techniques/calc_tcache_idx.md)
  Demonstrating glibc's tcache index calculation.
- [first_fit](./techniques/first_fit.md)
  Demonstrating glibc malloc's first-fit behavior.

## Duplicate Return Or Chosen Return

- [fastbin_dup](./techniques/fastbin_dup.md)
  Tricking malloc into returning an already-allocated heap pointer by abusing the fastbin freelist.
- [fastbin_dup_consolidate](./techniques/fastbin_dup_consolidate.md)
  Tricking malloc into returning an already-allocated heap pointer by putting a pointer on both fastbin freelist and the top chunk.
- [fastbin_dup_into_stack](./techniques/fastbin_dup_into_stack.md)
  Tricking malloc into returning a nearly-arbitrary pointer by abusing the fastbin freelist.
- [house_of_botcake](./techniques/house_of_botcake.md)
  Bypass double free restriction on tcache. Make `tcache_dup` great again.
- [house_of_io](./techniques/house_of_io.md)
  Tricking malloc into return a pointer to arbitrary memory by manipulating the tcache management struct by UAF in a free'd tcache chunk.
- [house_of_spirit](./techniques/house_of_spirit.md)
  Frees a fake fastbin chunk to get malloc to return a nearly-arbitrary pointer.
- [tcache_house_of_spirit](./techniques/tcache_house_of_spirit.md)
  Frees a fake chunk to get malloc to return a nearly-arbitrary pointer.
- [tcache_metadata_poisoning](./techniques/tcache_metadata_poisoning.md)
  Trick the tcache into providing arbitrary pointers by manipulating the tcache metadata struct
- [tcache_poisoning](./techniques/tcache_poisoning.md)
  Tricking malloc into returning a completely arbitrary pointer by abusing the tcache freelist. (requires heap leak on and after 2.32)

## Overlap And Consolidation

- [house_of_einherjar](./techniques/house_of_einherjar.md)
  Exploiting a single null byte overflow to trick malloc into returning a controlled pointer
- [mmap_overlapping_chunks](./techniques/mmap_overlapping_chunks.md)
  Exploit an in use mmap chunk in order to make a new allocation overlap with a current mmap chunk
- [overlapping_chunks](./techniques/overlapping_chunks.md)
  Exploit the overwrite of a freed chunk size in the unsorted bin in order to make a new allocation overlap with an existing chunk
- [overlapping_chunks_2](./techniques/overlapping_chunks_2.md)
  Exploit the overwrite of an in use chunk size in order to make a new allocation overlap with an existing chunk
- [poison_null_byte](./techniques/poison_null_byte.md)
  Exploiting a single null byte overflow.

## Bin Metadata Abuse And Allocator Writes

- [fastbin_reverse_into_tcache](./techniques/fastbin_reverse_into_tcache.md)
  Exploiting the overwrite of a freed chunk in the fastbin to write a large value into an arbitrary address.
- [house_of_lore](./techniques/house_of_lore.md)
  Tricking malloc into returning a nearly-arbitrary pointer by abusing the smallbin freelist.
- [house_of_mind_fastbin](./techniques/house_of_mind_fastbin.md)
  Exploiting a single byte overwrite with arena handling to write a large value (heap pointer) to an arbitrary address
- [large_bin_attack](./techniques/large_bin_attack.md)
  Exploiting the overwrite of a freed chunk on large bin freelist to write a large value into arbitrary address
- [tcache_stashing_unlink_attack](./techniques/tcache_stashing_unlink_attack.md)
  Exploiting the overwrite of a freed chunk on small bin freelist to trick malloc into returning an arbitrary pointer and write a large value into arbitraty address with the help of calloc.
- [unsafe_unlink](./techniques/unsafe_unlink.md)
  Exploiting free on a corrupted chunk to get arbitrary write.
- [unsorted_bin_attack](./techniques/unsorted_bin_attack.md)
  Exploiting the overwrite of a freed chunk on unsorted bin freelist to write a large value into arbitrary address
- [unsorted_bin_into_stack](./techniques/unsorted_bin_into_stack.md)
  Exploiting the overwrite of a freed chunk on unsorted bin freelist to return a nearly-arbitrary pointer.

## Wilderness, Arena, And Hybrid Paths

- [house_of_force](./techniques/house_of_force.md)
  Exploiting the Top Chunk (Wilderness) header in order to get malloc to return a nearly-arbitrary pointer
- [house_of_gods](./techniques/house_of_gods.md)
  A technique to hijack a thread's arena within 8 allocations
- [house_of_orange](./techniques/house_of_orange.md)
  Exploiting the Top Chunk (Wilderness) in order to gain arbitrary code execution
- [house_of_roman](./techniques/house_of_roman.md)
  Leakless technique in order to gain remote code execution via fake fastbins, the unsorted\_bin attack and relative overwrites.
- [house_of_storm](./techniques/house_of_storm.md)
  Exploiting a use after free on both a large and unsorted bin chunk to return an arbitrary chunk from malloc
- [house_of_tangerine](./techniques/house_of_tangerine.md)
  Exploiting the Top Chunk (Wilderness) in order to trick malloc into returning a completely arbitrary pointer by abusing the tcache freelist
- [sysmalloc_int_free](./techniques/sysmalloc_int_free.md)
  Demonstrating freeing the nearly arbitrary sized Top Chunk (Wilderness) using malloc (sysmalloc  `_int_free()` )

## Safe-Linking And Modern Tcache

- [decrypt_safe_linking](./techniques/decrypt_safe_linking.md)
  Decrypt the poisoned value in linked list to recover the actual pointer
- [house_of_water](./techniques/house_of_water.md)
  Exploit a UAF or double free to gain leakless control of the t-cache metadata and a leakless way to link libc in t-cache
- [safe_link_double_protect](./techniques/safe_link_double_protect.md)
  Leakless bypass for PROTECT_PTR by protecting a pointer twice, allowing for arbitrary pointer linking in t-cache
- [tcache_relative_write](./techniques/tcache_relative_write.md)
  Arbitrary decimal value and chunk pointer writing in heap by out-of-bounds tcache metadata writing
