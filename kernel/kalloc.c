// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void krcincref(uint64 pa);
int krcdecref(uint64 pa);
void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct {
  struct spinlock lock;
  // One integer counter for every 4KB page up to PHYSTOP
  int counts[PHYSTOP/PGSIZE]; 
} refcounts;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&refcounts.lock, "refcounts");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  if(krcdecref((uint64)pa) > 0){
    return; // Page is still referenced, do NOT free.
  }

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

void
krcincref(uint64 pa)
{
  if(pa >= PHYSTOP || (pa % PGSIZE) != 0)
    panic("krcincref: misaligned or invalid pa");

  int idx = pa / PGSIZE; // Calculate array index

  acquire(&refcounts.lock);
  refcounts.counts[idx]++;
  release(&refcounts.lock);
}

int
krcdecref(uint64 pa)
{
  if(pa >= PHYSTOP || (pa % PGSIZE) != 0)
    panic("krcdecref: misaligned or invalid pa");

  int idx = pa / PGSIZE;
  int count;

  acquire(&refcounts.lock);
  refcounts.counts[idx]--;
  count = refcounts.counts[idx];
  release(&refcounts.lock);

  return count;
}
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r){
    kmem.freelist = r->next;
  }
  release(&kmem.lock);

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    refcounts.counts[(uint64)r / PGSIZE] = 1;
  }
  return (void*)r;
}
