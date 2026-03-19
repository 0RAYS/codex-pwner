# `fastbin_dup`

## Summary

- Family: `Duplicate Return Or Chosen Return`
- README summary: Tricking malloc into returning an already-allocated heap pointer by abusing the fastbin freelist.
- Core effect: return the same fastbin chunk twice.
- README applicability: `latest`
- Solver window note: `2.23 -> 2.41`

## When To Consider It

- double free or list reuse after tcache is neutralized.

## Version Groups

- `2.23 -> 2.41`.

## Version Differences

- Pre-tcache variants are direct fastbin double-free demonstrations.
- 2.27+ variants explicitly fill tcache first so the duplicated chunk really returns through fastbin rather than being consumed by tcache.
- The core primitive stays the same across the corpus.

## Representative Source Code

- Representative version: `glibc 2.41`

```c
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main()
{
	setbuf(stdout, NULL);

	printf("This file demonstrates a simple double-free attack with fastbins.\n");

	printf("Allocate buffers to fill up tcache and prep fastbin.\n");
	void *ptrs[7];

	for (int i=0; i<7; i++) {
		ptrs[i] = malloc(8);
	}

	printf("Allocating 3 buffers.\n");
	int *a = calloc(1, 8);
	int *b = calloc(1, 8);
	int *c = calloc(1, 8);
	printf("1st malloc(8): %p\n", a);
	printf("2nd malloc(8): %p\n", b);
	printf("3rd malloc(8): %p\n", c);

	printf("Fill up tcache.\n");
	for (int i=0; i<7; i++) {
		free(ptrs[i]);
	}

	printf("Freeing the first chunk %p...\n", a);
	free(a);

	printf("If we free %p again, things will crash because %p is at the top of the free list.\n", a, a);
	// free(a);

	printf("So, instead, we'll free %p.\n", b);
	free(b);

	printf("Now, we can free %p again, since it's not the head of the free list.\n", a);
	/* VULNERABILITY */
	free(a);
	/* VULNERABILITY */

	printf("In order to use the free list for allocation, we'll need to empty the tcache.\n");
	printf("This is because since glibc-2.41, we can only reach fastbin by exhausting tcache first.");
	printf("Because of this patch: https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=226e3b0a413673c0d6691a0ae6dd001fe05d21cd");
	for (int i = 0; i < 7; i++) {
		ptrs[i] = malloc(8);
	}

	printf("Now the free list has [ %p, %p, %p ]. If we malloc 3 times, we'll get %p twice!\n", a, b, a, a);
	puts("Note that since glibc 2.41, malloc and calloc behave the same in terms of the usage of tcache and fastbin, so it doesn't matter whether we use malloc or calloc here.");
	a = malloc(8);
	b = calloc(1, 8);
	c = calloc(1, 8);
	printf("1st malloc(8): %p\n", a);
	printf("2nd calloc(1, 8): %p\n", b);
	printf("3rd calloc(1, 8): %p\n", c);

	assert(a == c);
}
```

## Related Techniques

- `fastbin_dup_consolidate`
- `fastbin_dup_into_stack`
- `house_of_botcake`
- `house_of_io`
- `house_of_spirit`
- `tcache_house_of_spirit`
- `tcache_metadata_poisoning`
- `tcache_poisoning`
