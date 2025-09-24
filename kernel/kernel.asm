
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	15813103          	ld	sp,344(sp) # 8000a158 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	619040ef          	jal	80004e2e <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	47878793          	addi	a5,a5,1144 # 800234a8 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	15490913          	addi	s2,s2,340 # 8000a1a0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	015050ef          	jal	8000586a <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	09d050ef          	jal	80005902 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	530050ef          	jal	800055ae <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	0c650513          	addi	a0,a0,198 # 8000a1a0 <kmem>
    800000e2:	708050ef          	jal	800057ea <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	3be50513          	addi	a0,a0,958 # 800234a8 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	09848493          	addi	s1,s1,152 # 8000a1a0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	758050ef          	jal	8000586a <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	08450513          	addi	a0,a0,132 # 8000a1a0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	7dc050ef          	jal	80005902 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	06050513          	addi	a0,a0,96 # 8000a1a0 <kmem>
    80000148:	7ba050ef          	jal	80005902 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdbb59>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	25f000ef          	jal	80000d4e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	0000a717          	auipc	a4,0xa
    800002f8:	e7c70713          	addi	a4,a4,-388 # 8000a170 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000308:	247000ef          	jal	80000d4e <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	7b3040ef          	jal	800052c8 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	576010ef          	jal	80001894 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	526040ef          	jal	80004848 <plicinithart>
  }

  scheduler();        
    80000326:	6b5000ef          	jal	800011da <scheduler>
    consoleinit();
    8000032a:	6c9040ef          	jal	800051f2 <consoleinit>
    printfinit();
    8000032e:	2bc050ef          	jal	800055ea <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	78f040ef          	jal	800052c8 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	783040ef          	jal	800052c8 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	777040ef          	jal	800052c8 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	137000ef          	jal	80000c98 <procinit>
    trapinit();      // trap vectors
    80000366:	50a010ef          	jal	80001870 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	52a010ef          	jal	80001894 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	4c0040ef          	jal	8000482e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	4d6040ef          	jal	80004848 <plicinithart>
    binit();         // buffer cache
    80000376:	3a5010ef          	jal	80001f1a <binit>
    iinit();         // inode table
    8000037a:	12a020ef          	jal	800024a4 <iinit>
    fileinit();      // file table
    8000037e:	01c030ef          	jal	8000339a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	5b6040ef          	jal	80004938 <virtio_disk_init>
    userinit();      // first user process
    80000386:	4bb000ef          	jal	80001040 <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	def72023          	sw	a5,-544(a4) # 8000a170 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	0000a797          	auipc	a5,0xa
    800003a8:	dd47b783          	ld	a5,-556(a5) # 8000a178 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	84aa                	mv	s1,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fc63          	bgeu	a5,a1,8000041c <walk+0x5a>
    panic("walk");
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	1be050ef          	jal	800055ae <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8263          	beqz	s5,80000458 <walk+0x96>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	84aa                	mv	s1,a0
    800003fe:	c139                	beqz	a0,80000444 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c4d793          	srli	a5,s1,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdbb4f>
    80000418:	036a0063          	beq	s4,s6,80000438 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041c:	0149d933          	srl	s2,s3,s4
    80000420:	1ff97913          	andi	s2,s2,511
    80000424:	090e                	slli	s2,s2,0x3
    80000426:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000428:	00093483          	ld	s1,0(s2)
    8000042c:	0014f793          	andi	a5,s1,1
    80000430:	d3f1                	beqz	a5,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000432:	80a9                	srli	s1,s1,0xa
    80000434:	04b2                	slli	s1,s1,0xc
    80000436:	b7c5                	j	80000416 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
        return 0;
    80000458:	4501                	li	a0,0
    8000045a:	b7ed                	j	80000444 <walk+0x82>

000000008000045c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000045c:	57fd                	li	a5,-1
    8000045e:	83e9                	srli	a5,a5,0x1a
    80000460:	00b7f463          	bgeu	a5,a1,80000468 <walkaddr+0xc>
    return 0;
    80000464:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000466:	8082                	ret
{
    80000468:	1141                	addi	sp,sp,-16
    8000046a:	e406                	sd	ra,8(sp)
    8000046c:	e022                	sd	s0,0(sp)
    8000046e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000470:	4601                	li	a2,0
    80000472:	f51ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000476:	c105                	beqz	a0,80000496 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000478:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000047a:	0117f693          	andi	a3,a5,17
    8000047e:	4745                	li	a4,17
    return 0;
    80000480:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000482:	00e68663          	beq	a3,a4,8000048e <walkaddr+0x32>
}
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret
  pa = PTE2PA(*pte);
    8000048e:	83a9                	srli	a5,a5,0xa
    80000490:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000494:	bfcd                	j	80000486 <walkaddr+0x2a>
    return 0;
    80000496:	4501                	li	a0,0
    80000498:	b7fd                	j	80000486 <walkaddr+0x2a>

000000008000049a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000049a:	715d                	addi	sp,sp,-80
    8000049c:	e486                	sd	ra,72(sp)
    8000049e:	e0a2                	sd	s0,64(sp)
    800004a0:	fc26                	sd	s1,56(sp)
    800004a2:	f84a                	sd	s2,48(sp)
    800004a4:	f44e                	sd	s3,40(sp)
    800004a6:	f052                	sd	s4,32(sp)
    800004a8:	ec56                	sd	s5,24(sp)
    800004aa:	e85a                	sd	s6,16(sp)
    800004ac:	e45e                	sd	s7,8(sp)
    800004ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b0:	03459793          	slli	a5,a1,0x34
    800004b4:	e7a9                	bnez	a5,800004fe <mappages+0x64>
    800004b6:	8aaa                	mv	s5,a0
    800004b8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004ba:	03461793          	slli	a5,a2,0x34
    800004be:	e7b1                	bnez	a5,8000050a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c0:	ca39                	beqz	a2,80000516 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004c2:	77fd                	lui	a5,0xfffff
    800004c4:	963e                	add	a2,a2,a5
    800004c6:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ca:	892e                	mv	s2,a1
    800004cc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d0:	6b85                	lui	s7,0x1
    800004d2:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004d6:	4605                	li	a2,1
    800004d8:	85ca                	mv	a1,s2
    800004da:	8556                	mv	a0,s5
    800004dc:	ee7ff0ef          	jal	800003c2 <walk>
    800004e0:	c539                	beqz	a0,8000052e <mappages+0x94>
    if(*pte & PTE_V)
    800004e2:	611c                	ld	a5,0(a0)
    800004e4:	8b85                	andi	a5,a5,1
    800004e6:	ef95                	bnez	a5,80000522 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004e8:	80b1                	srli	s1,s1,0xc
    800004ea:	04aa                	slli	s1,s1,0xa
    800004ec:	0164e4b3          	or	s1,s1,s6
    800004f0:	0014e493          	ori	s1,s1,1
    800004f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800004f6:	05390863          	beq	s2,s3,80000546 <mappages+0xac>
    a += PGSIZE;
    800004fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	bfd9                	j	800004d2 <mappages+0x38>
    panic("mappages: va not aligned");
    800004fe:	00007517          	auipc	a0,0x7
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80007058 <etext+0x58>
    80000506:	0a8050ef          	jal	800055ae <panic>
    panic("mappages: size not aligned");
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	09c050ef          	jal	800055ae <panic>
    panic("mappages: size");
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	090050ef          	jal	800055ae <panic>
      panic("mappages: remap");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	084050ef          	jal	800055ae <panic>
      return -1;
    8000052e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000530:	60a6                	ld	ra,72(sp)
    80000532:	6406                	ld	s0,64(sp)
    80000534:	74e2                	ld	s1,56(sp)
    80000536:	7942                	ld	s2,48(sp)
    80000538:	79a2                	ld	s3,40(sp)
    8000053a:	7a02                	ld	s4,32(sp)
    8000053c:	6ae2                	ld	s5,24(sp)
    8000053e:	6b42                	ld	s6,16(sp)
    80000540:	6ba2                	ld	s7,8(sp)
    80000542:	6161                	addi	sp,sp,80
    80000544:	8082                	ret
  return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7e5                	j	80000530 <mappages+0x96>

000000008000054a <kvmmap>:
{
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e406                	sd	ra,8(sp)
    8000054e:	e022                	sd	s0,0(sp)
    80000550:	0800                	addi	s0,sp,16
    80000552:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000554:	86b2                	mv	a3,a2
    80000556:	863e                	mv	a2,a5
    80000558:	f43ff0ef          	jal	8000049a <mappages>
    8000055c:	e509                	bnez	a0,80000566 <kvmmap+0x1c>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
    panic("kvmmap");
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800070b8 <etext+0xb8>
    8000056e:	040050ef          	jal	800055ae <panic>

0000000080000572 <kvmmake>:
{
    80000572:	1101                	addi	sp,sp,-32
    80000574:	ec06                	sd	ra,24(sp)
    80000576:	e822                	sd	s0,16(sp)
    80000578:	e426                	sd	s1,8(sp)
    8000057a:	e04a                	sd	s2,0(sp)
    8000057c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000057e:	b81ff0ef          	jal	800000fe <kalloc>
    80000582:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000584:	6605                	lui	a2,0x1
    80000586:	4581                	li	a1,0
    80000588:	bc7ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000058c:	4719                	li	a4,6
    8000058e:	6685                	lui	a3,0x1
    80000590:	10000637          	lui	a2,0x10000
    80000594:	100005b7          	lui	a1,0x10000
    80000598:	8526                	mv	a0,s1
    8000059a:	fb1ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000059e:	4719                	li	a4,6
    800005a0:	6685                	lui	a3,0x1
    800005a2:	10001637          	lui	a2,0x10001
    800005a6:	100015b7          	lui	a1,0x10001
    800005aa:	8526                	mv	a0,s1
    800005ac:	f9fff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b0:	4719                	li	a4,6
    800005b2:	040006b7          	lui	a3,0x4000
    800005b6:	0c000637          	lui	a2,0xc000
    800005ba:	0c0005b7          	lui	a1,0xc000
    800005be:	8526                	mv	a0,s1
    800005c0:	f8bff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005c4:	00007917          	auipc	s2,0x7
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80007000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80007697          	auipc	a3,0x80007
    800005d2:	a3268693          	addi	a3,a3,-1486 # 7000 <_entry-0x7fff9000>
    800005d6:	4605                	li	a2,1
    800005d8:	067e                	slli	a2,a2,0x1f
    800005da:	85b2                	mv	a1,a2
    800005dc:	8526                	mv	a0,s1
    800005de:	f6dff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e2:	46c5                	li	a3,17
    800005e4:	06ee                	slli	a3,a3,0x1b
    800005e6:	4719                	li	a4,6
    800005e8:	412686b3          	sub	a3,a3,s2
    800005ec:	864a                	mv	a2,s2
    800005ee:	85ca                	mv	a1,s2
    800005f0:	8526                	mv	a0,s1
    800005f2:	f59ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005f6:	4729                	li	a4,10
    800005f8:	6685                	lui	a3,0x1
    800005fa:	00006617          	auipc	a2,0x6
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80006000 <_trampoline>
    80000602:	040005b7          	lui	a1,0x4000
    80000606:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000608:	05b2                	slli	a1,a1,0xc
    8000060a:	8526                	mv	a0,s1
    8000060c:	f3fff0ef          	jal	8000054a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000610:	8526                	mv	a0,s1
    80000612:	5ee000ef          	jal	80000c00 <proc_mapstacks>
}
    80000616:	8526                	mv	a0,s1
    80000618:	60e2                	ld	ra,24(sp)
    8000061a:	6442                	ld	s0,16(sp)
    8000061c:	64a2                	ld	s1,8(sp)
    8000061e:	6902                	ld	s2,0(sp)
    80000620:	6105                	addi	sp,sp,32
    80000622:	8082                	ret

0000000080000624 <kvminit>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000062c:	f47ff0ef          	jal	80000572 <kvmmake>
    80000630:	0000a797          	auipc	a5,0xa
    80000634:	b4a7b423          	sd	a0,-1208(a5) # 8000a178 <kernel_pagetable>
}
    80000638:	60a2                	ld	ra,8(sp)
    8000063a:	6402                	ld	s0,0(sp)
    8000063c:	0141                	addi	sp,sp,16
    8000063e:	8082                	ret

0000000080000640 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000640:	1101                	addi	sp,sp,-32
    80000642:	ec06                	sd	ra,24(sp)
    80000644:	e822                	sd	s0,16(sp)
    80000646:	e426                	sd	s1,8(sp)
    80000648:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000064a:	ab5ff0ef          	jal	800000fe <kalloc>
    8000064e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000650:	c509                	beqz	a0,8000065a <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000652:	6605                	lui	a2,0x1
    80000654:	4581                	li	a1,0
    80000656:	af9ff0ef          	jal	8000014e <memset>
  return pagetable;
}
    8000065a:	8526                	mv	a0,s1
    8000065c:	60e2                	ld	ra,24(sp)
    8000065e:	6442                	ld	s0,16(sp)
    80000660:	64a2                	ld	s1,8(sp)
    80000662:	6105                	addi	sp,sp,32
    80000664:	8082                	ret

0000000080000666 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000666:	7139                	addi	sp,sp,-64
    80000668:	fc06                	sd	ra,56(sp)
    8000066a:	f822                	sd	s0,48(sp)
    8000066c:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000066e:	03459793          	slli	a5,a1,0x34
    80000672:	e38d                	bnez	a5,80000694 <uvmunmap+0x2e>
    80000674:	f04a                	sd	s2,32(sp)
    80000676:	ec4e                	sd	s3,24(sp)
    80000678:	e852                	sd	s4,16(sp)
    8000067a:	e456                	sd	s5,8(sp)
    8000067c:	e05a                	sd	s6,0(sp)
    8000067e:	8a2a                	mv	s4,a0
    80000680:	892e                	mv	s2,a1
    80000682:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000684:	0632                	slli	a2,a2,0xc
    80000686:	00b609b3          	add	s3,a2,a1
    8000068a:	6b05                	lui	s6,0x1
    8000068c:	0535f963          	bgeu	a1,s3,800006de <uvmunmap+0x78>
    80000690:	f426                	sd	s1,40(sp)
    80000692:	a015                	j	800006b6 <uvmunmap+0x50>
    80000694:	f426                	sd	s1,40(sp)
    80000696:	f04a                	sd	s2,32(sp)
    80000698:	ec4e                	sd	s3,24(sp)
    8000069a:	e852                	sd	s4,16(sp)
    8000069c:	e456                	sd	s5,8(sp)
    8000069e:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	707040ef          	jal	800055ae <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006ac:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006b0:	995a                	add	s2,s2,s6
    800006b2:	03397563          	bgeu	s2,s3,800006dc <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006b6:	4601                	li	a2,0
    800006b8:	85ca                	mv	a1,s2
    800006ba:	8552                	mv	a0,s4
    800006bc:	d07ff0ef          	jal	800003c2 <walk>
    800006c0:	84aa                	mv	s1,a0
    800006c2:	d57d                	beqz	a0,800006b0 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006c4:	611c                	ld	a5,0(a0)
    800006c6:	0017f713          	andi	a4,a5,1
    800006ca:	d37d                	beqz	a4,800006b0 <uvmunmap+0x4a>
    if(do_free){
    800006cc:	fe0a80e3          	beqz	s5,800006ac <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    800006d0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800006d2:	00c79513          	slli	a0,a5,0xc
    800006d6:	947ff0ef          	jal	8000001c <kfree>
    800006da:	bfc9                	j	800006ac <uvmunmap+0x46>
    800006dc:	74a2                	ld	s1,40(sp)
    800006de:	7902                	ld	s2,32(sp)
    800006e0:	69e2                	ld	s3,24(sp)
    800006e2:	6a42                	ld	s4,16(sp)
    800006e4:	6aa2                	ld	s5,8(sp)
    800006e6:	6b02                	ld	s6,0(sp)
  }
}
    800006e8:	70e2                	ld	ra,56(sp)
    800006ea:	7442                	ld	s0,48(sp)
    800006ec:	6121                	addi	sp,sp,64
    800006ee:	8082                	ret

00000000800006f0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800006f0:	1101                	addi	sp,sp,-32
    800006f2:	ec06                	sd	ra,24(sp)
    800006f4:	e822                	sd	s0,16(sp)
    800006f6:	e426                	sd	s1,8(sp)
    800006f8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800006fa:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800006fc:	00b67d63          	bgeu	a2,a1,80000716 <uvmdealloc+0x26>
    80000700:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000702:	6785                	lui	a5,0x1
    80000704:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000706:	00f60733          	add	a4,a2,a5
    8000070a:	76fd                	lui	a3,0xfffff
    8000070c:	8f75                	and	a4,a4,a3
    8000070e:	97ae                	add	a5,a5,a1
    80000710:	8ff5                	and	a5,a5,a3
    80000712:	00f76863          	bltu	a4,a5,80000722 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000716:	8526                	mv	a0,s1
    80000718:	60e2                	ld	ra,24(sp)
    8000071a:	6442                	ld	s0,16(sp)
    8000071c:	64a2                	ld	s1,8(sp)
    8000071e:	6105                	addi	sp,sp,32
    80000720:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000722:	8f99                	sub	a5,a5,a4
    80000724:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000726:	4685                	li	a3,1
    80000728:	0007861b          	sext.w	a2,a5
    8000072c:	85ba                	mv	a1,a4
    8000072e:	f39ff0ef          	jal	80000666 <uvmunmap>
    80000732:	b7d5                	j	80000716 <uvmdealloc+0x26>

0000000080000734 <uvmalloc>:
  if(newsz < oldsz)
    80000734:	08b66f63          	bltu	a2,a1,800007d2 <uvmalloc+0x9e>
{
    80000738:	7139                	addi	sp,sp,-64
    8000073a:	fc06                	sd	ra,56(sp)
    8000073c:	f822                	sd	s0,48(sp)
    8000073e:	ec4e                	sd	s3,24(sp)
    80000740:	e852                	sd	s4,16(sp)
    80000742:	e456                	sd	s5,8(sp)
    80000744:	0080                	addi	s0,sp,64
    80000746:	8aaa                	mv	s5,a0
    80000748:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000074a:	6785                	lui	a5,0x1
    8000074c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000074e:	95be                	add	a1,a1,a5
    80000750:	77fd                	lui	a5,0xfffff
    80000752:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000756:	08c9f063          	bgeu	s3,a2,800007d6 <uvmalloc+0xa2>
    8000075a:	f426                	sd	s1,40(sp)
    8000075c:	f04a                	sd	s2,32(sp)
    8000075e:	e05a                	sd	s6,0(sp)
    80000760:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000762:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000766:	999ff0ef          	jal	800000fe <kalloc>
    8000076a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000076c:	c515                	beqz	a0,80000798 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000076e:	6605                	lui	a2,0x1
    80000770:	4581                	li	a1,0
    80000772:	9ddff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000776:	875a                	mv	a4,s6
    80000778:	86a6                	mv	a3,s1
    8000077a:	6605                	lui	a2,0x1
    8000077c:	85ca                	mv	a1,s2
    8000077e:	8556                	mv	a0,s5
    80000780:	d1bff0ef          	jal	8000049a <mappages>
    80000784:	e915                	bnez	a0,800007b8 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000786:	6785                	lui	a5,0x1
    80000788:	993e                	add	s2,s2,a5
    8000078a:	fd496ee3          	bltu	s2,s4,80000766 <uvmalloc+0x32>
  return newsz;
    8000078e:	8552                	mv	a0,s4
    80000790:	74a2                	ld	s1,40(sp)
    80000792:	7902                	ld	s2,32(sp)
    80000794:	6b02                	ld	s6,0(sp)
    80000796:	a811                	j	800007aa <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000798:	864e                	mv	a2,s3
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8556                	mv	a0,s5
    8000079e:	f53ff0ef          	jal	800006f0 <uvmdealloc>
      return 0;
    800007a2:	4501                	li	a0,0
    800007a4:	74a2                	ld	s1,40(sp)
    800007a6:	7902                	ld	s2,32(sp)
    800007a8:	6b02                	ld	s6,0(sp)
}
    800007aa:	70e2                	ld	ra,56(sp)
    800007ac:	7442                	ld	s0,48(sp)
    800007ae:	69e2                	ld	s3,24(sp)
    800007b0:	6a42                	ld	s4,16(sp)
    800007b2:	6aa2                	ld	s5,8(sp)
    800007b4:	6121                	addi	sp,sp,64
    800007b6:	8082                	ret
      kfree(mem);
    800007b8:	8526                	mv	a0,s1
    800007ba:	863ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007be:	864e                	mv	a2,s3
    800007c0:	85ca                	mv	a1,s2
    800007c2:	8556                	mv	a0,s5
    800007c4:	f2dff0ef          	jal	800006f0 <uvmdealloc>
      return 0;
    800007c8:	4501                	li	a0,0
    800007ca:	74a2                	ld	s1,40(sp)
    800007cc:	7902                	ld	s2,32(sp)
    800007ce:	6b02                	ld	s6,0(sp)
    800007d0:	bfe9                	j	800007aa <uvmalloc+0x76>
    return oldsz;
    800007d2:	852e                	mv	a0,a1
}
    800007d4:	8082                	ret
  return newsz;
    800007d6:	8532                	mv	a0,a2
    800007d8:	bfc9                	j	800007aa <uvmalloc+0x76>

00000000800007da <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800007da:	7179                	addi	sp,sp,-48
    800007dc:	f406                	sd	ra,40(sp)
    800007de:	f022                	sd	s0,32(sp)
    800007e0:	ec26                	sd	s1,24(sp)
    800007e2:	e84a                	sd	s2,16(sp)
    800007e4:	e44e                	sd	s3,8(sp)
    800007e6:	e052                	sd	s4,0(sp)
    800007e8:	1800                	addi	s0,sp,48
    800007ea:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800007ec:	84aa                	mv	s1,a0
    800007ee:	6905                	lui	s2,0x1
    800007f0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800007f2:	4985                	li	s3,1
    800007f4:	a819                	j	8000080a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800007f6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800007f8:	00c79513          	slli	a0,a5,0xc
    800007fc:	fdfff0ef          	jal	800007da <freewalk>
      pagetable[i] = 0;
    80000800:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000804:	04a1                	addi	s1,s1,8
    80000806:	01248f63          	beq	s1,s2,80000824 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000080a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000080c:	00f7f713          	andi	a4,a5,15
    80000810:	ff3703e3          	beq	a4,s3,800007f6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000814:	8b85                	andi	a5,a5,1
    80000816:	d7fd                	beqz	a5,80000804 <freewalk+0x2a>
      panic("freewalk: leaf");
    80000818:	00007517          	auipc	a0,0x7
    8000081c:	8c050513          	addi	a0,a0,-1856 # 800070d8 <etext+0xd8>
    80000820:	58f040ef          	jal	800055ae <panic>
    }
  }
  kfree((void*)pagetable);
    80000824:	8552                	mv	a0,s4
    80000826:	ff6ff0ef          	jal	8000001c <kfree>
}
    8000082a:	70a2                	ld	ra,40(sp)
    8000082c:	7402                	ld	s0,32(sp)
    8000082e:	64e2                	ld	s1,24(sp)
    80000830:	6942                	ld	s2,16(sp)
    80000832:	69a2                	ld	s3,8(sp)
    80000834:	6a02                	ld	s4,0(sp)
    80000836:	6145                	addi	sp,sp,48
    80000838:	8082                	ret

000000008000083a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000083a:	1101                	addi	sp,sp,-32
    8000083c:	ec06                	sd	ra,24(sp)
    8000083e:	e822                	sd	s0,16(sp)
    80000840:	e426                	sd	s1,8(sp)
    80000842:	1000                	addi	s0,sp,32
    80000844:	84aa                	mv	s1,a0
  if(sz > 0)
    80000846:	e989                	bnez	a1,80000858 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000848:	8526                	mv	a0,s1
    8000084a:	f91ff0ef          	jal	800007da <freewalk>
}
    8000084e:	60e2                	ld	ra,24(sp)
    80000850:	6442                	ld	s0,16(sp)
    80000852:	64a2                	ld	s1,8(sp)
    80000854:	6105                	addi	sp,sp,32
    80000856:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000858:	6785                	lui	a5,0x1
    8000085a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000085c:	95be                	add	a1,a1,a5
    8000085e:	4685                	li	a3,1
    80000860:	00c5d613          	srli	a2,a1,0xc
    80000864:	4581                	li	a1,0
    80000866:	e01ff0ef          	jal	80000666 <uvmunmap>
    8000086a:	bff9                	j	80000848 <uvmfree+0xe>

000000008000086c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000086c:	ce49                	beqz	a2,80000906 <uvmcopy+0x9a>
{
    8000086e:	715d                	addi	sp,sp,-80
    80000870:	e486                	sd	ra,72(sp)
    80000872:	e0a2                	sd	s0,64(sp)
    80000874:	fc26                	sd	s1,56(sp)
    80000876:	f84a                	sd	s2,48(sp)
    80000878:	f44e                	sd	s3,40(sp)
    8000087a:	f052                	sd	s4,32(sp)
    8000087c:	ec56                	sd	s5,24(sp)
    8000087e:	e85a                	sd	s6,16(sp)
    80000880:	e45e                	sd	s7,8(sp)
    80000882:	0880                	addi	s0,sp,80
    80000884:	8aaa                	mv	s5,a0
    80000886:	8b2e                	mv	s6,a1
    80000888:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000088a:	4481                	li	s1,0
    8000088c:	a029                	j	80000896 <uvmcopy+0x2a>
    8000088e:	6785                	lui	a5,0x1
    80000890:	94be                	add	s1,s1,a5
    80000892:	0544fe63          	bgeu	s1,s4,800008ee <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    80000896:	4601                	li	a2,0
    80000898:	85a6                	mv	a1,s1
    8000089a:	8556                	mv	a0,s5
    8000089c:	b27ff0ef          	jal	800003c2 <walk>
    800008a0:	d57d                	beqz	a0,8000088e <uvmcopy+0x22>
      continue;   // page table entry hasn't been allocated
    if((*pte & PTE_V) == 0)
    800008a2:	6118                	ld	a4,0(a0)
    800008a4:	00177793          	andi	a5,a4,1
    800008a8:	d3fd                	beqz	a5,8000088e <uvmcopy+0x22>
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    800008aa:	00a75593          	srli	a1,a4,0xa
    800008ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800008b2:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    800008b6:	849ff0ef          	jal	800000fe <kalloc>
    800008ba:	89aa                	mv	s3,a0
    800008bc:	c105                	beqz	a0,800008dc <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008be:	6605                	lui	a2,0x1
    800008c0:	85de                	mv	a1,s7
    800008c2:	8e9ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008c6:	874a                	mv	a4,s2
    800008c8:	86ce                	mv	a3,s3
    800008ca:	6605                	lui	a2,0x1
    800008cc:	85a6                	mv	a1,s1
    800008ce:	855a                	mv	a0,s6
    800008d0:	bcbff0ef          	jal	8000049a <mappages>
    800008d4:	dd4d                	beqz	a0,8000088e <uvmcopy+0x22>
      kfree(mem);
    800008d6:	854e                	mv	a0,s3
    800008d8:	f44ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800008dc:	4685                	li	a3,1
    800008de:	00c4d613          	srli	a2,s1,0xc
    800008e2:	4581                	li	a1,0
    800008e4:	855a                	mv	a0,s6
    800008e6:	d81ff0ef          	jal	80000666 <uvmunmap>
  return -1;
    800008ea:	557d                	li	a0,-1
    800008ec:	a011                	j	800008f0 <uvmcopy+0x84>
  return 0;
    800008ee:	4501                	li	a0,0
}
    800008f0:	60a6                	ld	ra,72(sp)
    800008f2:	6406                	ld	s0,64(sp)
    800008f4:	74e2                	ld	s1,56(sp)
    800008f6:	7942                	ld	s2,48(sp)
    800008f8:	79a2                	ld	s3,40(sp)
    800008fa:	7a02                	ld	s4,32(sp)
    800008fc:	6ae2                	ld	s5,24(sp)
    800008fe:	6b42                	ld	s6,16(sp)
    80000900:	6ba2                	ld	s7,8(sp)
    80000902:	6161                	addi	sp,sp,80
    80000904:	8082                	ret
  return 0;
    80000906:	4501                	li	a0,0
}
    80000908:	8082                	ret

000000008000090a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000090a:	1141                	addi	sp,sp,-16
    8000090c:	e406                	sd	ra,8(sp)
    8000090e:	e022                	sd	s0,0(sp)
    80000910:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000912:	4601                	li	a2,0
    80000914:	aafff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000918:	c901                	beqz	a0,80000928 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000091a:	611c                	ld	a5,0(a0)
    8000091c:	9bbd                	andi	a5,a5,-17
    8000091e:	e11c                	sd	a5,0(a0)
}
    80000920:	60a2                	ld	ra,8(sp)
    80000922:	6402                	ld	s0,0(sp)
    80000924:	0141                	addi	sp,sp,16
    80000926:	8082                	ret
    panic("uvmclear");
    80000928:	00006517          	auipc	a0,0x6
    8000092c:	7c050513          	addi	a0,a0,1984 # 800070e8 <etext+0xe8>
    80000930:	47f040ef          	jal	800055ae <panic>

0000000080000934 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000934:	c6dd                	beqz	a3,800009e2 <copyinstr+0xae>
{
    80000936:	715d                	addi	sp,sp,-80
    80000938:	e486                	sd	ra,72(sp)
    8000093a:	e0a2                	sd	s0,64(sp)
    8000093c:	fc26                	sd	s1,56(sp)
    8000093e:	f84a                	sd	s2,48(sp)
    80000940:	f44e                	sd	s3,40(sp)
    80000942:	f052                	sd	s4,32(sp)
    80000944:	ec56                	sd	s5,24(sp)
    80000946:	e85a                	sd	s6,16(sp)
    80000948:	e45e                	sd	s7,8(sp)
    8000094a:	0880                	addi	s0,sp,80
    8000094c:	8a2a                	mv	s4,a0
    8000094e:	8b2e                	mv	s6,a1
    80000950:	8bb2                	mv	s7,a2
    80000952:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000954:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000956:	6985                	lui	s3,0x1
    80000958:	a825                	j	80000990 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000095a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000095e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000960:	37fd                	addiw	a5,a5,-1
    80000962:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000966:	60a6                	ld	ra,72(sp)
    80000968:	6406                	ld	s0,64(sp)
    8000096a:	74e2                	ld	s1,56(sp)
    8000096c:	7942                	ld	s2,48(sp)
    8000096e:	79a2                	ld	s3,40(sp)
    80000970:	7a02                	ld	s4,32(sp)
    80000972:	6ae2                	ld	s5,24(sp)
    80000974:	6b42                	ld	s6,16(sp)
    80000976:	6ba2                	ld	s7,8(sp)
    80000978:	6161                	addi	sp,sp,80
    8000097a:	8082                	ret
    8000097c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000980:	9742                	add	a4,a4,a6
      --max;
    80000982:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000986:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    8000098a:	04e58463          	beq	a1,a4,800009d2 <copyinstr+0x9e>
{
    8000098e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000990:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000994:	85a6                	mv	a1,s1
    80000996:	8552                	mv	a0,s4
    80000998:	ac5ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    8000099c:	cd0d                	beqz	a0,800009d6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000099e:	417486b3          	sub	a3,s1,s7
    800009a2:	96ce                	add	a3,a3,s3
    if(n > max)
    800009a4:	00d97363          	bgeu	s2,a3,800009aa <copyinstr+0x76>
    800009a8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800009aa:	955e                	add	a0,a0,s7
    800009ac:	8d05                	sub	a0,a0,s1
    while(n > 0){
    800009ae:	c695                	beqz	a3,800009da <copyinstr+0xa6>
    800009b0:	87da                	mv	a5,s6
    800009b2:	885a                	mv	a6,s6
      if(*p == '\0'){
    800009b4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800009b8:	96da                	add	a3,a3,s6
    800009ba:	85be                	mv	a1,a5
      if(*p == '\0'){
    800009bc:	00f60733          	add	a4,a2,a5
    800009c0:	00074703          	lbu	a4,0(a4)
    800009c4:	db59                	beqz	a4,8000095a <copyinstr+0x26>
        *dst = *p;
    800009c6:	00e78023          	sb	a4,0(a5)
      dst++;
    800009ca:	0785                	addi	a5,a5,1
    while(n > 0){
    800009cc:	fed797e3          	bne	a5,a3,800009ba <copyinstr+0x86>
    800009d0:	b775                	j	8000097c <copyinstr+0x48>
    800009d2:	4781                	li	a5,0
    800009d4:	b771                	j	80000960 <copyinstr+0x2c>
      return -1;
    800009d6:	557d                	li	a0,-1
    800009d8:	b779                	j	80000966 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800009da:	6b85                	lui	s7,0x1
    800009dc:	9ba6                	add	s7,s7,s1
    800009de:	87da                	mv	a5,s6
    800009e0:	b77d                	j	8000098e <copyinstr+0x5a>
  int got_null = 0;
    800009e2:	4781                	li	a5,0
  if(got_null){
    800009e4:	37fd                	addiw	a5,a5,-1
    800009e6:	0007851b          	sext.w	a0,a5
}
    800009ea:	8082                	ret

00000000800009ec <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800009ec:	1141                	addi	sp,sp,-16
    800009ee:	e406                	sd	ra,8(sp)
    800009f0:	e022                	sd	s0,0(sp)
    800009f2:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800009f4:	4601                	li	a2,0
    800009f6:	9cdff0ef          	jal	800003c2 <walk>
  if (pte == 0) {
    800009fa:	c519                	beqz	a0,80000a08 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    800009fc:	6108                	ld	a0,0(a0)
    800009fe:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a00:	60a2                	ld	ra,8(sp)
    80000a02:	6402                	ld	s0,0(sp)
    80000a04:	0141                	addi	sp,sp,16
    80000a06:	8082                	ret
    return 0;
    80000a08:	4501                	li	a0,0
    80000a0a:	bfdd                	j	80000a00 <ismapped+0x14>

0000000080000a0c <vmfault>:
{
    80000a0c:	7179                	addi	sp,sp,-48
    80000a0e:	f406                	sd	ra,40(sp)
    80000a10:	f022                	sd	s0,32(sp)
    80000a12:	ec26                	sd	s1,24(sp)
    80000a14:	e44e                	sd	s3,8(sp)
    80000a16:	1800                	addi	s0,sp,48
    80000a18:	89aa                	mv	s3,a0
    80000a1a:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80000a1c:	35e000ef          	jal	80000d7a <myproc>
  if (va >= p->sz)
    80000a20:	653c                	ld	a5,72(a0)
    80000a22:	00f4ea63          	bltu	s1,a5,80000a36 <vmfault+0x2a>
    return 0;
    80000a26:	4981                	li	s3,0
}
    80000a28:	854e                	mv	a0,s3
    80000a2a:	70a2                	ld	ra,40(sp)
    80000a2c:	7402                	ld	s0,32(sp)
    80000a2e:	64e2                	ld	s1,24(sp)
    80000a30:	69a2                	ld	s3,8(sp)
    80000a32:	6145                	addi	sp,sp,48
    80000a34:	8082                	ret
    80000a36:	e84a                	sd	s2,16(sp)
    80000a38:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80000a3a:	77fd                	lui	a5,0xfffff
    80000a3c:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    80000a3e:	85a6                	mv	a1,s1
    80000a40:	854e                	mv	a0,s3
    80000a42:	fabff0ef          	jal	800009ec <ismapped>
    return 0;
    80000a46:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a48:	c119                	beqz	a0,80000a4e <vmfault+0x42>
    80000a4a:	6942                	ld	s2,16(sp)
    80000a4c:	bff1                	j	80000a28 <vmfault+0x1c>
    80000a4e:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    80000a50:	eaeff0ef          	jal	800000fe <kalloc>
    80000a54:	8a2a                	mv	s4,a0
  if(mem == 0)
    80000a56:	c90d                	beqz	a0,80000a88 <vmfault+0x7c>
  mem = (uint64) kalloc();
    80000a58:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	4581                	li	a1,0
    80000a5e:	ef0ff0ef          	jal	8000014e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a62:	4759                	li	a4,22
    80000a64:	86d2                	mv	a3,s4
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85a6                	mv	a1,s1
    80000a6a:	05093503          	ld	a0,80(s2)
    80000a6e:	a2dff0ef          	jal	8000049a <mappages>
    80000a72:	e501                	bnez	a0,80000a7a <vmfault+0x6e>
    80000a74:	6942                	ld	s2,16(sp)
    80000a76:	6a02                	ld	s4,0(sp)
    80000a78:	bf45                	j	80000a28 <vmfault+0x1c>
    kfree((void *)mem);
    80000a7a:	8552                	mv	a0,s4
    80000a7c:	da0ff0ef          	jal	8000001c <kfree>
    return 0;
    80000a80:	4981                	li	s3,0
    80000a82:	6942                	ld	s2,16(sp)
    80000a84:	6a02                	ld	s4,0(sp)
    80000a86:	b74d                	j	80000a28 <vmfault+0x1c>
    80000a88:	6942                	ld	s2,16(sp)
    80000a8a:	6a02                	ld	s4,0(sp)
    80000a8c:	bf71                	j	80000a28 <vmfault+0x1c>

0000000080000a8e <copyout>:
  while(len > 0){
    80000a8e:	c2cd                	beqz	a3,80000b30 <copyout+0xa2>
{
    80000a90:	711d                	addi	sp,sp,-96
    80000a92:	ec86                	sd	ra,88(sp)
    80000a94:	e8a2                	sd	s0,80(sp)
    80000a96:	e4a6                	sd	s1,72(sp)
    80000a98:	f852                	sd	s4,48(sp)
    80000a9a:	f05a                	sd	s6,32(sp)
    80000a9c:	ec5e                	sd	s7,24(sp)
    80000a9e:	e862                	sd	s8,16(sp)
    80000aa0:	1080                	addi	s0,sp,96
    80000aa2:	8c2a                	mv	s8,a0
    80000aa4:	8b2e                	mv	s6,a1
    80000aa6:	8bb2                	mv	s7,a2
    80000aa8:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000aaa:	74fd                	lui	s1,0xfffff
    80000aac:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000aae:	57fd                	li	a5,-1
    80000ab0:	83e9                	srli	a5,a5,0x1a
    80000ab2:	0897e163          	bltu	a5,s1,80000b34 <copyout+0xa6>
    80000ab6:	e0ca                	sd	s2,64(sp)
    80000ab8:	fc4e                	sd	s3,56(sp)
    80000aba:	f456                	sd	s5,40(sp)
    80000abc:	e466                	sd	s9,8(sp)
    80000abe:	e06a                	sd	s10,0(sp)
    80000ac0:	6d05                	lui	s10,0x1
    80000ac2:	8cbe                	mv	s9,a5
    80000ac4:	a015                	j	80000ae8 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ac6:	409b0533          	sub	a0,s6,s1
    80000aca:	0009861b          	sext.w	a2,s3
    80000ace:	85de                	mv	a1,s7
    80000ad0:	954a                	add	a0,a0,s2
    80000ad2:	ed8ff0ef          	jal	800001aa <memmove>
    len -= n;
    80000ad6:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000ada:	9bce                	add	s7,s7,s3
  while(len > 0){
    80000adc:	040a0363          	beqz	s4,80000b22 <copyout+0x94>
    if(va0 >= MAXVA)
    80000ae0:	055cec63          	bltu	s9,s5,80000b38 <copyout+0xaa>
    80000ae4:	84d6                	mv	s1,s5
    80000ae6:	8b56                	mv	s6,s5
    pa0 = walkaddr(pagetable, va0);
    80000ae8:	85a6                	mv	a1,s1
    80000aea:	8562                	mv	a0,s8
    80000aec:	971ff0ef          	jal	8000045c <walkaddr>
    80000af0:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80000af2:	e901                	bnez	a0,80000b02 <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000af4:	4601                	li	a2,0
    80000af6:	85a6                	mv	a1,s1
    80000af8:	8562                	mv	a0,s8
    80000afa:	f13ff0ef          	jal	80000a0c <vmfault>
    80000afe:	892a                	mv	s2,a0
    80000b00:	c139                	beqz	a0,80000b46 <copyout+0xb8>
    pte = walk(pagetable, va0, 0);
    80000b02:	4601                	li	a2,0
    80000b04:	85a6                	mv	a1,s1
    80000b06:	8562                	mv	a0,s8
    80000b08:	8bbff0ef          	jal	800003c2 <walk>
    if((*pte & PTE_W) == 0)
    80000b0c:	611c                	ld	a5,0(a0)
    80000b0e:	8b91                	andi	a5,a5,4
    80000b10:	c3b1                	beqz	a5,80000b54 <copyout+0xc6>
    n = PGSIZE - (dstva - va0);
    80000b12:	01a48ab3          	add	s5,s1,s10
    80000b16:	416a89b3          	sub	s3,s5,s6
    if(n > len)
    80000b1a:	fb3a76e3          	bgeu	s4,s3,80000ac6 <copyout+0x38>
    80000b1e:	89d2                	mv	s3,s4
    80000b20:	b75d                	j	80000ac6 <copyout+0x38>
  return 0;
    80000b22:	4501                	li	a0,0
    80000b24:	6906                	ld	s2,64(sp)
    80000b26:	79e2                	ld	s3,56(sp)
    80000b28:	7aa2                	ld	s5,40(sp)
    80000b2a:	6ca2                	ld	s9,8(sp)
    80000b2c:	6d02                	ld	s10,0(sp)
    80000b2e:	a80d                	j	80000b60 <copyout+0xd2>
    80000b30:	4501                	li	a0,0
}
    80000b32:	8082                	ret
      return -1;
    80000b34:	557d                	li	a0,-1
    80000b36:	a02d                	j	80000b60 <copyout+0xd2>
    80000b38:	557d                	li	a0,-1
    80000b3a:	6906                	ld	s2,64(sp)
    80000b3c:	79e2                	ld	s3,56(sp)
    80000b3e:	7aa2                	ld	s5,40(sp)
    80000b40:	6ca2                	ld	s9,8(sp)
    80000b42:	6d02                	ld	s10,0(sp)
    80000b44:	a831                	j	80000b60 <copyout+0xd2>
        return -1;
    80000b46:	557d                	li	a0,-1
    80000b48:	6906                	ld	s2,64(sp)
    80000b4a:	79e2                	ld	s3,56(sp)
    80000b4c:	7aa2                	ld	s5,40(sp)
    80000b4e:	6ca2                	ld	s9,8(sp)
    80000b50:	6d02                	ld	s10,0(sp)
    80000b52:	a039                	j	80000b60 <copyout+0xd2>
      return -1;
    80000b54:	557d                	li	a0,-1
    80000b56:	6906                	ld	s2,64(sp)
    80000b58:	79e2                	ld	s3,56(sp)
    80000b5a:	7aa2                	ld	s5,40(sp)
    80000b5c:	6ca2                	ld	s9,8(sp)
    80000b5e:	6d02                	ld	s10,0(sp)
}
    80000b60:	60e6                	ld	ra,88(sp)
    80000b62:	6446                	ld	s0,80(sp)
    80000b64:	64a6                	ld	s1,72(sp)
    80000b66:	7a42                	ld	s4,48(sp)
    80000b68:	7b02                	ld	s6,32(sp)
    80000b6a:	6be2                	ld	s7,24(sp)
    80000b6c:	6c42                	ld	s8,16(sp)
    80000b6e:	6125                	addi	sp,sp,96
    80000b70:	8082                	ret

0000000080000b72 <copyin>:
  while(len > 0){
    80000b72:	c6c9                	beqz	a3,80000bfc <copyin+0x8a>
{
    80000b74:	715d                	addi	sp,sp,-80
    80000b76:	e486                	sd	ra,72(sp)
    80000b78:	e0a2                	sd	s0,64(sp)
    80000b7a:	fc26                	sd	s1,56(sp)
    80000b7c:	f84a                	sd	s2,48(sp)
    80000b7e:	f44e                	sd	s3,40(sp)
    80000b80:	f052                	sd	s4,32(sp)
    80000b82:	ec56                	sd	s5,24(sp)
    80000b84:	e85a                	sd	s6,16(sp)
    80000b86:	e45e                	sd	s7,8(sp)
    80000b88:	e062                	sd	s8,0(sp)
    80000b8a:	0880                	addi	s0,sp,80
    80000b8c:	8baa                	mv	s7,a0
    80000b8e:	8aae                	mv	s5,a1
    80000b90:	8932                	mv	s2,a2
    80000b92:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000b94:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000b96:	6b05                	lui	s6,0x1
    80000b98:	a035                	j	80000bc4 <copyin+0x52>
    80000b9a:	412984b3          	sub	s1,s3,s2
    80000b9e:	94da                	add	s1,s1,s6
    if(n > len)
    80000ba0:	009a7363          	bgeu	s4,s1,80000ba6 <copyin+0x34>
    80000ba4:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba6:	413905b3          	sub	a1,s2,s3
    80000baa:	0004861b          	sext.w	a2,s1
    80000bae:	95aa                	add	a1,a1,a0
    80000bb0:	8556                	mv	a0,s5
    80000bb2:	df8ff0ef          	jal	800001aa <memmove>
    len -= n;
    80000bb6:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000bba:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000bbc:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000bc0:	020a0163          	beqz	s4,80000be2 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000bc8:	85ce                	mv	a1,s3
    80000bca:	855e                	mv	a0,s7
    80000bcc:	891ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0) {
    80000bd0:	f569                	bnez	a0,80000b9a <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000bd2:	4601                	li	a2,0
    80000bd4:	85ce                	mv	a1,s3
    80000bd6:	855e                	mv	a0,s7
    80000bd8:	e35ff0ef          	jal	80000a0c <vmfault>
    80000bdc:	fd5d                	bnez	a0,80000b9a <copyin+0x28>
        return -1;
    80000bde:	557d                	li	a0,-1
    80000be0:	a011                	j	80000be4 <copyin+0x72>
  return 0;
    80000be2:	4501                	li	a0,0
}
    80000be4:	60a6                	ld	ra,72(sp)
    80000be6:	6406                	ld	s0,64(sp)
    80000be8:	74e2                	ld	s1,56(sp)
    80000bea:	7942                	ld	s2,48(sp)
    80000bec:	79a2                	ld	s3,40(sp)
    80000bee:	7a02                	ld	s4,32(sp)
    80000bf0:	6ae2                	ld	s5,24(sp)
    80000bf2:	6b42                	ld	s6,16(sp)
    80000bf4:	6ba2                	ld	s7,8(sp)
    80000bf6:	6c02                	ld	s8,0(sp)
    80000bf8:	6161                	addi	sp,sp,80
    80000bfa:	8082                	ret
  return 0;
    80000bfc:	4501                	li	a0,0
}
    80000bfe:	8082                	ret

0000000080000c00 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c00:	7139                	addi	sp,sp,-64
    80000c02:	fc06                	sd	ra,56(sp)
    80000c04:	f822                	sd	s0,48(sp)
    80000c06:	f426                	sd	s1,40(sp)
    80000c08:	f04a                	sd	s2,32(sp)
    80000c0a:	ec4e                	sd	s3,24(sp)
    80000c0c:	e852                	sd	s4,16(sp)
    80000c0e:	e456                	sd	s5,8(sp)
    80000c10:	e05a                	sd	s6,0(sp)
    80000c12:	0080                	addi	s0,sp,64
    80000c14:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c16:	0000a497          	auipc	s1,0xa
    80000c1a:	9da48493          	addi	s1,s1,-1574 # 8000a5f0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c1e:	8b26                	mv	s6,s1
    80000c20:	04fa5937          	lui	s2,0x4fa5
    80000c24:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c28:	0932                	slli	s2,s2,0xc
    80000c2a:	fa590913          	addi	s2,s2,-91
    80000c2e:	0932                	slli	s2,s2,0xc
    80000c30:	fa590913          	addi	s2,s2,-91
    80000c34:	0932                	slli	s2,s2,0xc
    80000c36:	fa590913          	addi	s2,s2,-91
    80000c3a:	040009b7          	lui	s3,0x4000
    80000c3e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c40:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c42:	0000fa97          	auipc	s5,0xf
    80000c46:	3aea8a93          	addi	s5,s5,942 # 8000fff0 <tickslock>
    char *pa = kalloc();
    80000c4a:	cb4ff0ef          	jal	800000fe <kalloc>
    80000c4e:	862a                	mv	a2,a0
    if(pa == 0)
    80000c50:	cd15                	beqz	a0,80000c8c <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c52:	416485b3          	sub	a1,s1,s6
    80000c56:	858d                	srai	a1,a1,0x3
    80000c58:	032585b3          	mul	a1,a1,s2
    80000c5c:	2585                	addiw	a1,a1,1
    80000c5e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c62:	4719                	li	a4,6
    80000c64:	6685                	lui	a3,0x1
    80000c66:	40b985b3          	sub	a1,s3,a1
    80000c6a:	8552                	mv	a0,s4
    80000c6c:	8dfff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c70:	16848493          	addi	s1,s1,360
    80000c74:	fd549be3          	bne	s1,s5,80000c4a <proc_mapstacks+0x4a>
  }
}
    80000c78:	70e2                	ld	ra,56(sp)
    80000c7a:	7442                	ld	s0,48(sp)
    80000c7c:	74a2                	ld	s1,40(sp)
    80000c7e:	7902                	ld	s2,32(sp)
    80000c80:	69e2                	ld	s3,24(sp)
    80000c82:	6a42                	ld	s4,16(sp)
    80000c84:	6aa2                	ld	s5,8(sp)
    80000c86:	6b02                	ld	s6,0(sp)
    80000c88:	6121                	addi	sp,sp,64
    80000c8a:	8082                	ret
      panic("kalloc");
    80000c8c:	00006517          	auipc	a0,0x6
    80000c90:	46c50513          	addi	a0,a0,1132 # 800070f8 <etext+0xf8>
    80000c94:	11b040ef          	jal	800055ae <panic>

0000000080000c98 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c98:	7139                	addi	sp,sp,-64
    80000c9a:	fc06                	sd	ra,56(sp)
    80000c9c:	f822                	sd	s0,48(sp)
    80000c9e:	f426                	sd	s1,40(sp)
    80000ca0:	f04a                	sd	s2,32(sp)
    80000ca2:	ec4e                	sd	s3,24(sp)
    80000ca4:	e852                	sd	s4,16(sp)
    80000ca6:	e456                	sd	s5,8(sp)
    80000ca8:	e05a                	sd	s6,0(sp)
    80000caa:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cac:	00006597          	auipc	a1,0x6
    80000cb0:	45458593          	addi	a1,a1,1108 # 80007100 <etext+0x100>
    80000cb4:	00009517          	auipc	a0,0x9
    80000cb8:	50c50513          	addi	a0,a0,1292 # 8000a1c0 <pid_lock>
    80000cbc:	32f040ef          	jal	800057ea <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc0:	00006597          	auipc	a1,0x6
    80000cc4:	44858593          	addi	a1,a1,1096 # 80007108 <etext+0x108>
    80000cc8:	00009517          	auipc	a0,0x9
    80000ccc:	51050513          	addi	a0,a0,1296 # 8000a1d8 <wait_lock>
    80000cd0:	31b040ef          	jal	800057ea <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd4:	0000a497          	auipc	s1,0xa
    80000cd8:	91c48493          	addi	s1,s1,-1764 # 8000a5f0 <proc>
      initlock(&p->lock, "proc");
    80000cdc:	00006b17          	auipc	s6,0x6
    80000ce0:	43cb0b13          	addi	s6,s6,1084 # 80007118 <etext+0x118>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ce4:	8aa6                	mv	s5,s1
    80000ce6:	04fa5937          	lui	s2,0x4fa5
    80000cea:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000cee:	0932                	slli	s2,s2,0xc
    80000cf0:	fa590913          	addi	s2,s2,-91
    80000cf4:	0932                	slli	s2,s2,0xc
    80000cf6:	fa590913          	addi	s2,s2,-91
    80000cfa:	0932                	slli	s2,s2,0xc
    80000cfc:	fa590913          	addi	s2,s2,-91
    80000d00:	040009b7          	lui	s3,0x4000
    80000d04:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d06:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d08:	0000fa17          	auipc	s4,0xf
    80000d0c:	2e8a0a13          	addi	s4,s4,744 # 8000fff0 <tickslock>
      initlock(&p->lock, "proc");
    80000d10:	85da                	mv	a1,s6
    80000d12:	8526                	mv	a0,s1
    80000d14:	2d7040ef          	jal	800057ea <initlock>
      p->state = UNUSED;
    80000d18:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d1c:	415487b3          	sub	a5,s1,s5
    80000d20:	878d                	srai	a5,a5,0x3
    80000d22:	032787b3          	mul	a5,a5,s2
    80000d26:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffdbb59>
    80000d28:	00d7979b          	slliw	a5,a5,0xd
    80000d2c:	40f987b3          	sub	a5,s3,a5
    80000d30:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	16848493          	addi	s1,s1,360
    80000d36:	fd449de3          	bne	s1,s4,80000d10 <procinit+0x78>
  }
}
    80000d3a:	70e2                	ld	ra,56(sp)
    80000d3c:	7442                	ld	s0,48(sp)
    80000d3e:	74a2                	ld	s1,40(sp)
    80000d40:	7902                	ld	s2,32(sp)
    80000d42:	69e2                	ld	s3,24(sp)
    80000d44:	6a42                	ld	s4,16(sp)
    80000d46:	6aa2                	ld	s5,8(sp)
    80000d48:	6b02                	ld	s6,0(sp)
    80000d4a:	6121                	addi	sp,sp,64
    80000d4c:	8082                	ret

0000000080000d4e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d4e:	1141                	addi	sp,sp,-16
    80000d50:	e422                	sd	s0,8(sp)
    80000d52:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d54:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d56:	2501                	sext.w	a0,a0
    80000d58:	6422                	ld	s0,8(sp)
    80000d5a:	0141                	addi	sp,sp,16
    80000d5c:	8082                	ret

0000000080000d5e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d5e:	1141                	addi	sp,sp,-16
    80000d60:	e422                	sd	s0,8(sp)
    80000d62:	0800                	addi	s0,sp,16
    80000d64:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d6a:	00009517          	auipc	a0,0x9
    80000d6e:	48650513          	addi	a0,a0,1158 # 8000a1f0 <cpus>
    80000d72:	953e                	add	a0,a0,a5
    80000d74:	6422                	ld	s0,8(sp)
    80000d76:	0141                	addi	sp,sp,16
    80000d78:	8082                	ret

0000000080000d7a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d7a:	1101                	addi	sp,sp,-32
    80000d7c:	ec06                	sd	ra,24(sp)
    80000d7e:	e822                	sd	s0,16(sp)
    80000d80:	e426                	sd	s1,8(sp)
    80000d82:	1000                	addi	s0,sp,32
  push_off();
    80000d84:	2a7040ef          	jal	8000582a <push_off>
    80000d88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d8a:	2781                	sext.w	a5,a5
    80000d8c:	079e                	slli	a5,a5,0x7
    80000d8e:	00009717          	auipc	a4,0x9
    80000d92:	43270713          	addi	a4,a4,1074 # 8000a1c0 <pid_lock>
    80000d96:	97ba                	add	a5,a5,a4
    80000d98:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d9a:	315040ef          	jal	800058ae <pop_off>
  return p;
}
    80000d9e:	8526                	mv	a0,s1
    80000da0:	60e2                	ld	ra,24(sp)
    80000da2:	6442                	ld	s0,16(sp)
    80000da4:	64a2                	ld	s1,8(sp)
    80000da6:	6105                	addi	sp,sp,32
    80000da8:	8082                	ret

0000000080000daa <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000daa:	7179                	addi	sp,sp,-48
    80000dac:	f406                	sd	ra,40(sp)
    80000dae:	f022                	sd	s0,32(sp)
    80000db0:	ec26                	sd	s1,24(sp)
    80000db2:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000db4:	fc7ff0ef          	jal	80000d7a <myproc>
    80000db8:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000dba:	349040ef          	jal	80005902 <release>

  if (first) {
    80000dbe:	00009797          	auipc	a5,0x9
    80000dc2:	3827a783          	lw	a5,898(a5) # 8000a140 <first.1>
    80000dc6:	cf8d                	beqz	a5,80000e00 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dc8:	4505                	li	a0,1
    80000dca:	397010ef          	jal	80002960 <fsinit>

    first = 0;
    80000dce:	00009797          	auipc	a5,0x9
    80000dd2:	3607a923          	sw	zero,882(a5) # 8000a140 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000dd6:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000dda:	00006517          	auipc	a0,0x6
    80000dde:	34650513          	addi	a0,a0,838 # 80007120 <etext+0x120>
    80000de2:	fca43823          	sd	a0,-48(s0)
    80000de6:	fc043c23          	sd	zero,-40(s0)
    80000dea:	fd040593          	addi	a1,s0,-48
    80000dee:	473020ef          	jal	80003a60 <kexec>
    80000df2:	6cbc                	ld	a5,88(s1)
    80000df4:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000df6:	6cbc                	ld	a5,88(s1)
    80000df8:	7bb8                	ld	a4,112(a5)
    80000dfa:	57fd                	li	a5,-1
    80000dfc:	02f70d63          	beq	a4,a5,80000e36 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e00:	2ad000ef          	jal	800018ac <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e04:	68a8                	ld	a0,80(s1)
    80000e06:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e08:	04000737          	lui	a4,0x4000
    80000e0c:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e0e:	0732                	slli	a4,a4,0xc
    80000e10:	00005797          	auipc	a5,0x5
    80000e14:	28c78793          	addi	a5,a5,652 # 8000609c <userret>
    80000e18:	00005697          	auipc	a3,0x5
    80000e1c:	1e868693          	addi	a3,a3,488 # 80006000 <_trampoline>
    80000e20:	8f95                	sub	a5,a5,a3
    80000e22:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e24:	577d                	li	a4,-1
    80000e26:	177e                	slli	a4,a4,0x3f
    80000e28:	8d59                	or	a0,a0,a4
    80000e2a:	9782                	jalr	a5
}
    80000e2c:	70a2                	ld	ra,40(sp)
    80000e2e:	7402                	ld	s0,32(sp)
    80000e30:	64e2                	ld	s1,24(sp)
    80000e32:	6145                	addi	sp,sp,48
    80000e34:	8082                	ret
      panic("exec");
    80000e36:	00006517          	auipc	a0,0x6
    80000e3a:	2f250513          	addi	a0,a0,754 # 80007128 <etext+0x128>
    80000e3e:	770040ef          	jal	800055ae <panic>

0000000080000e42 <allocpid>:
{
    80000e42:	1101                	addi	sp,sp,-32
    80000e44:	ec06                	sd	ra,24(sp)
    80000e46:	e822                	sd	s0,16(sp)
    80000e48:	e426                	sd	s1,8(sp)
    80000e4a:	e04a                	sd	s2,0(sp)
    80000e4c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e4e:	00009917          	auipc	s2,0x9
    80000e52:	37290913          	addi	s2,s2,882 # 8000a1c0 <pid_lock>
    80000e56:	854a                	mv	a0,s2
    80000e58:	213040ef          	jal	8000586a <acquire>
  pid = nextpid;
    80000e5c:	00009797          	auipc	a5,0x9
    80000e60:	2e878793          	addi	a5,a5,744 # 8000a144 <nextpid>
    80000e64:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e66:	0014871b          	addiw	a4,s1,1
    80000e6a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e6c:	854a                	mv	a0,s2
    80000e6e:	295040ef          	jal	80005902 <release>
}
    80000e72:	8526                	mv	a0,s1
    80000e74:	60e2                	ld	ra,24(sp)
    80000e76:	6442                	ld	s0,16(sp)
    80000e78:	64a2                	ld	s1,8(sp)
    80000e7a:	6902                	ld	s2,0(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <proc_pagetable>:
{
    80000e80:	1101                	addi	sp,sp,-32
    80000e82:	ec06                	sd	ra,24(sp)
    80000e84:	e822                	sd	s0,16(sp)
    80000e86:	e426                	sd	s1,8(sp)
    80000e88:	e04a                	sd	s2,0(sp)
    80000e8a:	1000                	addi	s0,sp,32
    80000e8c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e8e:	fb2ff0ef          	jal	80000640 <uvmcreate>
    80000e92:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e94:	cd05                	beqz	a0,80000ecc <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e96:	4729                	li	a4,10
    80000e98:	00005697          	auipc	a3,0x5
    80000e9c:	16868693          	addi	a3,a3,360 # 80006000 <_trampoline>
    80000ea0:	6605                	lui	a2,0x1
    80000ea2:	040005b7          	lui	a1,0x4000
    80000ea6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea8:	05b2                	slli	a1,a1,0xc
    80000eaa:	df0ff0ef          	jal	8000049a <mappages>
    80000eae:	02054663          	bltz	a0,80000eda <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000eb2:	4719                	li	a4,6
    80000eb4:	05893683          	ld	a3,88(s2)
    80000eb8:	6605                	lui	a2,0x1
    80000eba:	020005b7          	lui	a1,0x2000
    80000ebe:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ec0:	05b6                	slli	a1,a1,0xd
    80000ec2:	8526                	mv	a0,s1
    80000ec4:	dd6ff0ef          	jal	8000049a <mappages>
    80000ec8:	00054f63          	bltz	a0,80000ee6 <proc_pagetable+0x66>
}
    80000ecc:	8526                	mv	a0,s1
    80000ece:	60e2                	ld	ra,24(sp)
    80000ed0:	6442                	ld	s0,16(sp)
    80000ed2:	64a2                	ld	s1,8(sp)
    80000ed4:	6902                	ld	s2,0(sp)
    80000ed6:	6105                	addi	sp,sp,32
    80000ed8:	8082                	ret
    uvmfree(pagetable, 0);
    80000eda:	4581                	li	a1,0
    80000edc:	8526                	mv	a0,s1
    80000ede:	95dff0ef          	jal	8000083a <uvmfree>
    return 0;
    80000ee2:	4481                	li	s1,0
    80000ee4:	b7e5                	j	80000ecc <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ee6:	4681                	li	a3,0
    80000ee8:	4605                	li	a2,1
    80000eea:	040005b7          	lui	a1,0x4000
    80000eee:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ef0:	05b2                	slli	a1,a1,0xc
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	f72ff0ef          	jal	80000666 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ef8:	4581                	li	a1,0
    80000efa:	8526                	mv	a0,s1
    80000efc:	93fff0ef          	jal	8000083a <uvmfree>
    return 0;
    80000f00:	4481                	li	s1,0
    80000f02:	b7e9                	j	80000ecc <proc_pagetable+0x4c>

0000000080000f04 <proc_freepagetable>:
{
    80000f04:	1101                	addi	sp,sp,-32
    80000f06:	ec06                	sd	ra,24(sp)
    80000f08:	e822                	sd	s0,16(sp)
    80000f0a:	e426                	sd	s1,8(sp)
    80000f0c:	e04a                	sd	s2,0(sp)
    80000f0e:	1000                	addi	s0,sp,32
    80000f10:	84aa                	mv	s1,a0
    80000f12:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f14:	4681                	li	a3,0
    80000f16:	4605                	li	a2,1
    80000f18:	040005b7          	lui	a1,0x4000
    80000f1c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f1e:	05b2                	slli	a1,a1,0xc
    80000f20:	f46ff0ef          	jal	80000666 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f24:	4681                	li	a3,0
    80000f26:	4605                	li	a2,1
    80000f28:	020005b7          	lui	a1,0x2000
    80000f2c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f2e:	05b6                	slli	a1,a1,0xd
    80000f30:	8526                	mv	a0,s1
    80000f32:	f34ff0ef          	jal	80000666 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f36:	85ca                	mv	a1,s2
    80000f38:	8526                	mv	a0,s1
    80000f3a:	901ff0ef          	jal	8000083a <uvmfree>
}
    80000f3e:	60e2                	ld	ra,24(sp)
    80000f40:	6442                	ld	s0,16(sp)
    80000f42:	64a2                	ld	s1,8(sp)
    80000f44:	6902                	ld	s2,0(sp)
    80000f46:	6105                	addi	sp,sp,32
    80000f48:	8082                	ret

0000000080000f4a <freeproc>:
{
    80000f4a:	1101                	addi	sp,sp,-32
    80000f4c:	ec06                	sd	ra,24(sp)
    80000f4e:	e822                	sd	s0,16(sp)
    80000f50:	e426                	sd	s1,8(sp)
    80000f52:	1000                	addi	s0,sp,32
    80000f54:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f56:	6d28                	ld	a0,88(a0)
    80000f58:	c119                	beqz	a0,80000f5e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f5a:	8c2ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f5e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f62:	68a8                	ld	a0,80(s1)
    80000f64:	c501                	beqz	a0,80000f6c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f66:	64ac                	ld	a1,72(s1)
    80000f68:	f9dff0ef          	jal	80000f04 <proc_freepagetable>
  p->pagetable = 0;
    80000f6c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f70:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f74:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f78:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f7c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f80:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f84:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f88:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f8c:	0004ac23          	sw	zero,24(s1)
}
    80000f90:	60e2                	ld	ra,24(sp)
    80000f92:	6442                	ld	s0,16(sp)
    80000f94:	64a2                	ld	s1,8(sp)
    80000f96:	6105                	addi	sp,sp,32
    80000f98:	8082                	ret

0000000080000f9a <allocproc>:
{
    80000f9a:	1101                	addi	sp,sp,-32
    80000f9c:	ec06                	sd	ra,24(sp)
    80000f9e:	e822                	sd	s0,16(sp)
    80000fa0:	e426                	sd	s1,8(sp)
    80000fa2:	e04a                	sd	s2,0(sp)
    80000fa4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fa6:	00009497          	auipc	s1,0x9
    80000faa:	64a48493          	addi	s1,s1,1610 # 8000a5f0 <proc>
    80000fae:	0000f917          	auipc	s2,0xf
    80000fb2:	04290913          	addi	s2,s2,66 # 8000fff0 <tickslock>
    acquire(&p->lock);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	0b3040ef          	jal	8000586a <acquire>
    if(p->state == UNUSED) {
    80000fbc:	4c9c                	lw	a5,24(s1)
    80000fbe:	cb91                	beqz	a5,80000fd2 <allocproc+0x38>
      release(&p->lock);
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	141040ef          	jal	80005902 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc6:	16848493          	addi	s1,s1,360
    80000fca:	ff2496e3          	bne	s1,s2,80000fb6 <allocproc+0x1c>
  return 0;
    80000fce:	4481                	li	s1,0
    80000fd0:	a089                	j	80001012 <allocproc+0x78>
  p->pid = allocpid();
    80000fd2:	e71ff0ef          	jal	80000e42 <allocpid>
    80000fd6:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fd8:	4785                	li	a5,1
    80000fda:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fdc:	922ff0ef          	jal	800000fe <kalloc>
    80000fe0:	892a                	mv	s2,a0
    80000fe2:	eca8                	sd	a0,88(s1)
    80000fe4:	cd15                	beqz	a0,80001020 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	e99ff0ef          	jal	80000e80 <proc_pagetable>
    80000fec:	892a                	mv	s2,a0
    80000fee:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000ff0:	c121                	beqz	a0,80001030 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000ff2:	07000613          	li	a2,112
    80000ff6:	4581                	li	a1,0
    80000ff8:	06048513          	addi	a0,s1,96
    80000ffc:	952ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80001000:	00000797          	auipc	a5,0x0
    80001004:	daa78793          	addi	a5,a5,-598 # 80000daa <forkret>
    80001008:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000100a:	60bc                	ld	a5,64(s1)
    8000100c:	6705                	lui	a4,0x1
    8000100e:	97ba                	add	a5,a5,a4
    80001010:	f4bc                	sd	a5,104(s1)
}
    80001012:	8526                	mv	a0,s1
    80001014:	60e2                	ld	ra,24(sp)
    80001016:	6442                	ld	s0,16(sp)
    80001018:	64a2                	ld	s1,8(sp)
    8000101a:	6902                	ld	s2,0(sp)
    8000101c:	6105                	addi	sp,sp,32
    8000101e:	8082                	ret
    freeproc(p);
    80001020:	8526                	mv	a0,s1
    80001022:	f29ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    80001026:	8526                	mv	a0,s1
    80001028:	0db040ef          	jal	80005902 <release>
    return 0;
    8000102c:	84ca                	mv	s1,s2
    8000102e:	b7d5                	j	80001012 <allocproc+0x78>
    freeproc(p);
    80001030:	8526                	mv	a0,s1
    80001032:	f19ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    80001036:	8526                	mv	a0,s1
    80001038:	0cb040ef          	jal	80005902 <release>
    return 0;
    8000103c:	84ca                	mv	s1,s2
    8000103e:	bfd1                	j	80001012 <allocproc+0x78>

0000000080001040 <userinit>:
{
    80001040:	1101                	addi	sp,sp,-32
    80001042:	ec06                	sd	ra,24(sp)
    80001044:	e822                	sd	s0,16(sp)
    80001046:	e426                	sd	s1,8(sp)
    80001048:	1000                	addi	s0,sp,32
  p = allocproc();
    8000104a:	f51ff0ef          	jal	80000f9a <allocproc>
    8000104e:	84aa                	mv	s1,a0
  initproc = p;
    80001050:	00009797          	auipc	a5,0x9
    80001054:	12a7b823          	sd	a0,304(a5) # 8000a180 <initproc>
  p->cwd = namei("/");
    80001058:	00006517          	auipc	a0,0x6
    8000105c:	0d850513          	addi	a0,a0,216 # 80007130 <etext+0x130>
    80001060:	623010ef          	jal	80002e82 <namei>
    80001064:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001068:	478d                	li	a5,3
    8000106a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000106c:	8526                	mv	a0,s1
    8000106e:	095040ef          	jal	80005902 <release>
}
    80001072:	60e2                	ld	ra,24(sp)
    80001074:	6442                	ld	s0,16(sp)
    80001076:	64a2                	ld	s1,8(sp)
    80001078:	6105                	addi	sp,sp,32
    8000107a:	8082                	ret

000000008000107c <growproc>:
{
    8000107c:	1101                	addi	sp,sp,-32
    8000107e:	ec06                	sd	ra,24(sp)
    80001080:	e822                	sd	s0,16(sp)
    80001082:	e426                	sd	s1,8(sp)
    80001084:	e04a                	sd	s2,0(sp)
    80001086:	1000                	addi	s0,sp,32
    80001088:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000108a:	cf1ff0ef          	jal	80000d7a <myproc>
    8000108e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001090:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001092:	01204c63          	bgtz	s2,800010aa <growproc+0x2e>
  } else if(n < 0){
    80001096:	02094463          	bltz	s2,800010be <growproc+0x42>
  p->sz = sz;
    8000109a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000109c:	4501                	li	a0,0
}
    8000109e:	60e2                	ld	ra,24(sp)
    800010a0:	6442                	ld	s0,16(sp)
    800010a2:	64a2                	ld	s1,8(sp)
    800010a4:	6902                	ld	s2,0(sp)
    800010a6:	6105                	addi	sp,sp,32
    800010a8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010aa:	4691                	li	a3,4
    800010ac:	00b90633          	add	a2,s2,a1
    800010b0:	6928                	ld	a0,80(a0)
    800010b2:	e82ff0ef          	jal	80000734 <uvmalloc>
    800010b6:	85aa                	mv	a1,a0
    800010b8:	f16d                	bnez	a0,8000109a <growproc+0x1e>
      return -1;
    800010ba:	557d                	li	a0,-1
    800010bc:	b7cd                	j	8000109e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010be:	00b90633          	add	a2,s2,a1
    800010c2:	6928                	ld	a0,80(a0)
    800010c4:	e2cff0ef          	jal	800006f0 <uvmdealloc>
    800010c8:	85aa                	mv	a1,a0
    800010ca:	bfc1                	j	8000109a <growproc+0x1e>

00000000800010cc <kfork>:
{
    800010cc:	7139                	addi	sp,sp,-64
    800010ce:	fc06                	sd	ra,56(sp)
    800010d0:	f822                	sd	s0,48(sp)
    800010d2:	f04a                	sd	s2,32(sp)
    800010d4:	e456                	sd	s5,8(sp)
    800010d6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010d8:	ca3ff0ef          	jal	80000d7a <myproc>
    800010dc:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010de:	ebdff0ef          	jal	80000f9a <allocproc>
    800010e2:	0e050a63          	beqz	a0,800011d6 <kfork+0x10a>
    800010e6:	e852                	sd	s4,16(sp)
    800010e8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010ea:	048ab603          	ld	a2,72(s5)
    800010ee:	692c                	ld	a1,80(a0)
    800010f0:	050ab503          	ld	a0,80(s5)
    800010f4:	f78ff0ef          	jal	8000086c <uvmcopy>
    800010f8:	04054a63          	bltz	a0,8000114c <kfork+0x80>
    800010fc:	f426                	sd	s1,40(sp)
    800010fe:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001100:	048ab783          	ld	a5,72(s5)
    80001104:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001108:	058ab683          	ld	a3,88(s5)
    8000110c:	87b6                	mv	a5,a3
    8000110e:	058a3703          	ld	a4,88(s4)
    80001112:	12068693          	addi	a3,a3,288
    80001116:	0007b803          	ld	a6,0(a5)
    8000111a:	6788                	ld	a0,8(a5)
    8000111c:	6b8c                	ld	a1,16(a5)
    8000111e:	6f90                	ld	a2,24(a5)
    80001120:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001124:	e708                	sd	a0,8(a4)
    80001126:	eb0c                	sd	a1,16(a4)
    80001128:	ef10                	sd	a2,24(a4)
    8000112a:	02078793          	addi	a5,a5,32
    8000112e:	02070713          	addi	a4,a4,32
    80001132:	fed792e3          	bne	a5,a3,80001116 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001136:	058a3783          	ld	a5,88(s4)
    8000113a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000113e:	0d0a8493          	addi	s1,s5,208
    80001142:	0d0a0913          	addi	s2,s4,208
    80001146:	150a8993          	addi	s3,s5,336
    8000114a:	a831                	j	80001166 <kfork+0x9a>
    freeproc(np);
    8000114c:	8552                	mv	a0,s4
    8000114e:	dfdff0ef          	jal	80000f4a <freeproc>
    release(&np->lock);
    80001152:	8552                	mv	a0,s4
    80001154:	7ae040ef          	jal	80005902 <release>
    return -1;
    80001158:	597d                	li	s2,-1
    8000115a:	6a42                	ld	s4,16(sp)
    8000115c:	a0b5                	j	800011c8 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000115e:	04a1                	addi	s1,s1,8
    80001160:	0921                	addi	s2,s2,8
    80001162:	01348963          	beq	s1,s3,80001174 <kfork+0xa8>
    if(p->ofile[i])
    80001166:	6088                	ld	a0,0(s1)
    80001168:	d97d                	beqz	a0,8000115e <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000116a:	2b2020ef          	jal	8000341c <filedup>
    8000116e:	00a93023          	sd	a0,0(s2)
    80001172:	b7f5                	j	8000115e <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001174:	150ab503          	ld	a0,336(s5)
    80001178:	4be010ef          	jal	80002636 <idup>
    8000117c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001180:	4641                	li	a2,16
    80001182:	158a8593          	addi	a1,s5,344
    80001186:	158a0513          	addi	a0,s4,344
    8000118a:	902ff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    8000118e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001192:	8552                	mv	a0,s4
    80001194:	76e040ef          	jal	80005902 <release>
  acquire(&wait_lock);
    80001198:	00009497          	auipc	s1,0x9
    8000119c:	04048493          	addi	s1,s1,64 # 8000a1d8 <wait_lock>
    800011a0:	8526                	mv	a0,s1
    800011a2:	6c8040ef          	jal	8000586a <acquire>
  np->parent = p;
    800011a6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800011aa:	8526                	mv	a0,s1
    800011ac:	756040ef          	jal	80005902 <release>
  acquire(&np->lock);
    800011b0:	8552                	mv	a0,s4
    800011b2:	6b8040ef          	jal	8000586a <acquire>
  np->state = RUNNABLE;
    800011b6:	478d                	li	a5,3
    800011b8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800011bc:	8552                	mv	a0,s4
    800011be:	744040ef          	jal	80005902 <release>
  return pid;
    800011c2:	74a2                	ld	s1,40(sp)
    800011c4:	69e2                	ld	s3,24(sp)
    800011c6:	6a42                	ld	s4,16(sp)
}
    800011c8:	854a                	mv	a0,s2
    800011ca:	70e2                	ld	ra,56(sp)
    800011cc:	7442                	ld	s0,48(sp)
    800011ce:	7902                	ld	s2,32(sp)
    800011d0:	6aa2                	ld	s5,8(sp)
    800011d2:	6121                	addi	sp,sp,64
    800011d4:	8082                	ret
    return -1;
    800011d6:	597d                	li	s2,-1
    800011d8:	bfc5                	j	800011c8 <kfork+0xfc>

00000000800011da <scheduler>:
{
    800011da:	715d                	addi	sp,sp,-80
    800011dc:	e486                	sd	ra,72(sp)
    800011de:	e0a2                	sd	s0,64(sp)
    800011e0:	fc26                	sd	s1,56(sp)
    800011e2:	f84a                	sd	s2,48(sp)
    800011e4:	f44e                	sd	s3,40(sp)
    800011e6:	f052                	sd	s4,32(sp)
    800011e8:	ec56                	sd	s5,24(sp)
    800011ea:	e85a                	sd	s6,16(sp)
    800011ec:	e45e                	sd	s7,8(sp)
    800011ee:	e062                	sd	s8,0(sp)
    800011f0:	0880                	addi	s0,sp,80
    800011f2:	8792                	mv	a5,tp
  int id = r_tp();
    800011f4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011f6:	00779b13          	slli	s6,a5,0x7
    800011fa:	00009717          	auipc	a4,0x9
    800011fe:	fc670713          	addi	a4,a4,-58 # 8000a1c0 <pid_lock>
    80001202:	975a                	add	a4,a4,s6
    80001204:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001208:	00009717          	auipc	a4,0x9
    8000120c:	ff070713          	addi	a4,a4,-16 # 8000a1f8 <cpus+0x8>
    80001210:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001212:	4c11                	li	s8,4
        c->proc = p;
    80001214:	079e                	slli	a5,a5,0x7
    80001216:	00009a17          	auipc	s4,0x9
    8000121a:	faaa0a13          	addi	s4,s4,-86 # 8000a1c0 <pid_lock>
    8000121e:	9a3e                	add	s4,s4,a5
        found = 1;
    80001220:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001222:	0000f997          	auipc	s3,0xf
    80001226:	dce98993          	addi	s3,s3,-562 # 8000fff0 <tickslock>
    8000122a:	a83d                	j	80001268 <scheduler+0x8e>
      release(&p->lock);
    8000122c:	8526                	mv	a0,s1
    8000122e:	6d4040ef          	jal	80005902 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001232:	16848493          	addi	s1,s1,360
    80001236:	03348563          	beq	s1,s3,80001260 <scheduler+0x86>
      acquire(&p->lock);
    8000123a:	8526                	mv	a0,s1
    8000123c:	62e040ef          	jal	8000586a <acquire>
      if(p->state == RUNNABLE) {
    80001240:	4c9c                	lw	a5,24(s1)
    80001242:	ff2795e3          	bne	a5,s2,8000122c <scheduler+0x52>
        p->state = RUNNING;
    80001246:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000124a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000124e:	06048593          	addi	a1,s1,96
    80001252:	855a                	mv	a0,s6
    80001254:	5b2000ef          	jal	80001806 <swtch>
        c->proc = 0;
    80001258:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000125c:	8ade                	mv	s5,s7
    8000125e:	b7f9                	j	8000122c <scheduler+0x52>
    if(found == 0) {
    80001260:	000a9463          	bnez	s5,80001268 <scheduler+0x8e>
      asm volatile("wfi");
    80001264:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001268:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000126c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001270:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001274:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001278:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000127a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000127e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001280:	00009497          	auipc	s1,0x9
    80001284:	37048493          	addi	s1,s1,880 # 8000a5f0 <proc>
      if(p->state == RUNNABLE) {
    80001288:	490d                	li	s2,3
    8000128a:	bf45                	j	8000123a <scheduler+0x60>

000000008000128c <sched>:
{
    8000128c:	7179                	addi	sp,sp,-48
    8000128e:	f406                	sd	ra,40(sp)
    80001290:	f022                	sd	s0,32(sp)
    80001292:	ec26                	sd	s1,24(sp)
    80001294:	e84a                	sd	s2,16(sp)
    80001296:	e44e                	sd	s3,8(sp)
    80001298:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000129a:	ae1ff0ef          	jal	80000d7a <myproc>
    8000129e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012a0:	560040ef          	jal	80005800 <holding>
    800012a4:	c92d                	beqz	a0,80001316 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012a6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012a8:	2781                	sext.w	a5,a5
    800012aa:	079e                	slli	a5,a5,0x7
    800012ac:	00009717          	auipc	a4,0x9
    800012b0:	f1470713          	addi	a4,a4,-236 # 8000a1c0 <pid_lock>
    800012b4:	97ba                	add	a5,a5,a4
    800012b6:	0a87a703          	lw	a4,168(a5)
    800012ba:	4785                	li	a5,1
    800012bc:	06f71363          	bne	a4,a5,80001322 <sched+0x96>
  if(p->state == RUNNING)
    800012c0:	4c98                	lw	a4,24(s1)
    800012c2:	4791                	li	a5,4
    800012c4:	06f70563          	beq	a4,a5,8000132e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012cc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012ce:	e7b5                	bnez	a5,8000133a <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012d0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012d2:	00009917          	auipc	s2,0x9
    800012d6:	eee90913          	addi	s2,s2,-274 # 8000a1c0 <pid_lock>
    800012da:	2781                	sext.w	a5,a5
    800012dc:	079e                	slli	a5,a5,0x7
    800012de:	97ca                	add	a5,a5,s2
    800012e0:	0ac7a983          	lw	s3,172(a5)
    800012e4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012e6:	2781                	sext.w	a5,a5
    800012e8:	079e                	slli	a5,a5,0x7
    800012ea:	00009597          	auipc	a1,0x9
    800012ee:	f0e58593          	addi	a1,a1,-242 # 8000a1f8 <cpus+0x8>
    800012f2:	95be                	add	a1,a1,a5
    800012f4:	06048513          	addi	a0,s1,96
    800012f8:	50e000ef          	jal	80001806 <swtch>
    800012fc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012fe:	2781                	sext.w	a5,a5
    80001300:	079e                	slli	a5,a5,0x7
    80001302:	993e                	add	s2,s2,a5
    80001304:	0b392623          	sw	s3,172(s2)
}
    80001308:	70a2                	ld	ra,40(sp)
    8000130a:	7402                	ld	s0,32(sp)
    8000130c:	64e2                	ld	s1,24(sp)
    8000130e:	6942                	ld	s2,16(sp)
    80001310:	69a2                	ld	s3,8(sp)
    80001312:	6145                	addi	sp,sp,48
    80001314:	8082                	ret
    panic("sched p->lock");
    80001316:	00006517          	auipc	a0,0x6
    8000131a:	e2250513          	addi	a0,a0,-478 # 80007138 <etext+0x138>
    8000131e:	290040ef          	jal	800055ae <panic>
    panic("sched locks");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	e2650513          	addi	a0,a0,-474 # 80007148 <etext+0x148>
    8000132a:	284040ef          	jal	800055ae <panic>
    panic("sched RUNNING");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	e2a50513          	addi	a0,a0,-470 # 80007158 <etext+0x158>
    80001336:	278040ef          	jal	800055ae <panic>
    panic("sched interruptible");
    8000133a:	00006517          	auipc	a0,0x6
    8000133e:	e2e50513          	addi	a0,a0,-466 # 80007168 <etext+0x168>
    80001342:	26c040ef          	jal	800055ae <panic>

0000000080001346 <yield>:
{
    80001346:	1101                	addi	sp,sp,-32
    80001348:	ec06                	sd	ra,24(sp)
    8000134a:	e822                	sd	s0,16(sp)
    8000134c:	e426                	sd	s1,8(sp)
    8000134e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001350:	a2bff0ef          	jal	80000d7a <myproc>
    80001354:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001356:	514040ef          	jal	8000586a <acquire>
  p->state = RUNNABLE;
    8000135a:	478d                	li	a5,3
    8000135c:	cc9c                	sw	a5,24(s1)
  sched();
    8000135e:	f2fff0ef          	jal	8000128c <sched>
  release(&p->lock);
    80001362:	8526                	mv	a0,s1
    80001364:	59e040ef          	jal	80005902 <release>
}
    80001368:	60e2                	ld	ra,24(sp)
    8000136a:	6442                	ld	s0,16(sp)
    8000136c:	64a2                	ld	s1,8(sp)
    8000136e:	6105                	addi	sp,sp,32
    80001370:	8082                	ret

0000000080001372 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001372:	7179                	addi	sp,sp,-48
    80001374:	f406                	sd	ra,40(sp)
    80001376:	f022                	sd	s0,32(sp)
    80001378:	ec26                	sd	s1,24(sp)
    8000137a:	e84a                	sd	s2,16(sp)
    8000137c:	e44e                	sd	s3,8(sp)
    8000137e:	1800                	addi	s0,sp,48
    80001380:	89aa                	mv	s3,a0
    80001382:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001384:	9f7ff0ef          	jal	80000d7a <myproc>
    80001388:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000138a:	4e0040ef          	jal	8000586a <acquire>
  release(lk);
    8000138e:	854a                	mv	a0,s2
    80001390:	572040ef          	jal	80005902 <release>

  // Go to sleep.
  p->chan = chan;
    80001394:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001398:	4789                	li	a5,2
    8000139a:	cc9c                	sw	a5,24(s1)

  sched();
    8000139c:	ef1ff0ef          	jal	8000128c <sched>

  // Tidy up.
  p->chan = 0;
    800013a0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	55c040ef          	jal	80005902 <release>
  acquire(lk);
    800013aa:	854a                	mv	a0,s2
    800013ac:	4be040ef          	jal	8000586a <acquire>
}
    800013b0:	70a2                	ld	ra,40(sp)
    800013b2:	7402                	ld	s0,32(sp)
    800013b4:	64e2                	ld	s1,24(sp)
    800013b6:	6942                	ld	s2,16(sp)
    800013b8:	69a2                	ld	s3,8(sp)
    800013ba:	6145                	addi	sp,sp,48
    800013bc:	8082                	ret

00000000800013be <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013be:	7139                	addi	sp,sp,-64
    800013c0:	fc06                	sd	ra,56(sp)
    800013c2:	f822                	sd	s0,48(sp)
    800013c4:	f426                	sd	s1,40(sp)
    800013c6:	f04a                	sd	s2,32(sp)
    800013c8:	ec4e                	sd	s3,24(sp)
    800013ca:	e852                	sd	s4,16(sp)
    800013cc:	e456                	sd	s5,8(sp)
    800013ce:	0080                	addi	s0,sp,64
    800013d0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013d2:	00009497          	auipc	s1,0x9
    800013d6:	21e48493          	addi	s1,s1,542 # 8000a5f0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013da:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013dc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013de:	0000f917          	auipc	s2,0xf
    800013e2:	c1290913          	addi	s2,s2,-1006 # 8000fff0 <tickslock>
    800013e6:	a801                	j	800013f6 <wakeup+0x38>
      }
      release(&p->lock);
    800013e8:	8526                	mv	a0,s1
    800013ea:	518040ef          	jal	80005902 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ee:	16848493          	addi	s1,s1,360
    800013f2:	03248263          	beq	s1,s2,80001416 <wakeup+0x58>
    if(p != myproc()){
    800013f6:	985ff0ef          	jal	80000d7a <myproc>
    800013fa:	fea48ae3          	beq	s1,a0,800013ee <wakeup+0x30>
      acquire(&p->lock);
    800013fe:	8526                	mv	a0,s1
    80001400:	46a040ef          	jal	8000586a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001404:	4c9c                	lw	a5,24(s1)
    80001406:	ff3791e3          	bne	a5,s3,800013e8 <wakeup+0x2a>
    8000140a:	709c                	ld	a5,32(s1)
    8000140c:	fd479ee3          	bne	a5,s4,800013e8 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001410:	0154ac23          	sw	s5,24(s1)
    80001414:	bfd1                	j	800013e8 <wakeup+0x2a>
    }
  }
}
    80001416:	70e2                	ld	ra,56(sp)
    80001418:	7442                	ld	s0,48(sp)
    8000141a:	74a2                	ld	s1,40(sp)
    8000141c:	7902                	ld	s2,32(sp)
    8000141e:	69e2                	ld	s3,24(sp)
    80001420:	6a42                	ld	s4,16(sp)
    80001422:	6aa2                	ld	s5,8(sp)
    80001424:	6121                	addi	sp,sp,64
    80001426:	8082                	ret

0000000080001428 <reparent>:
{
    80001428:	7179                	addi	sp,sp,-48
    8000142a:	f406                	sd	ra,40(sp)
    8000142c:	f022                	sd	s0,32(sp)
    8000142e:	ec26                	sd	s1,24(sp)
    80001430:	e84a                	sd	s2,16(sp)
    80001432:	e44e                	sd	s3,8(sp)
    80001434:	e052                	sd	s4,0(sp)
    80001436:	1800                	addi	s0,sp,48
    80001438:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143a:	00009497          	auipc	s1,0x9
    8000143e:	1b648493          	addi	s1,s1,438 # 8000a5f0 <proc>
      pp->parent = initproc;
    80001442:	00009a17          	auipc	s4,0x9
    80001446:	d3ea0a13          	addi	s4,s4,-706 # 8000a180 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000144a:	0000f997          	auipc	s3,0xf
    8000144e:	ba698993          	addi	s3,s3,-1114 # 8000fff0 <tickslock>
    80001452:	a029                	j	8000145c <reparent+0x34>
    80001454:	16848493          	addi	s1,s1,360
    80001458:	01348b63          	beq	s1,s3,8000146e <reparent+0x46>
    if(pp->parent == p){
    8000145c:	7c9c                	ld	a5,56(s1)
    8000145e:	ff279be3          	bne	a5,s2,80001454 <reparent+0x2c>
      pp->parent = initproc;
    80001462:	000a3503          	ld	a0,0(s4)
    80001466:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001468:	f57ff0ef          	jal	800013be <wakeup>
    8000146c:	b7e5                	j	80001454 <reparent+0x2c>
}
    8000146e:	70a2                	ld	ra,40(sp)
    80001470:	7402                	ld	s0,32(sp)
    80001472:	64e2                	ld	s1,24(sp)
    80001474:	6942                	ld	s2,16(sp)
    80001476:	69a2                	ld	s3,8(sp)
    80001478:	6a02                	ld	s4,0(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret

000000008000147e <kexit>:
{
    8000147e:	7179                	addi	sp,sp,-48
    80001480:	f406                	sd	ra,40(sp)
    80001482:	f022                	sd	s0,32(sp)
    80001484:	ec26                	sd	s1,24(sp)
    80001486:	e84a                	sd	s2,16(sp)
    80001488:	e44e                	sd	s3,8(sp)
    8000148a:	e052                	sd	s4,0(sp)
    8000148c:	1800                	addi	s0,sp,48
    8000148e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001490:	8ebff0ef          	jal	80000d7a <myproc>
    80001494:	89aa                	mv	s3,a0
  if(p == initproc)
    80001496:	00009797          	auipc	a5,0x9
    8000149a:	cea7b783          	ld	a5,-790(a5) # 8000a180 <initproc>
    8000149e:	0d050493          	addi	s1,a0,208
    800014a2:	15050913          	addi	s2,a0,336
    800014a6:	00a79f63          	bne	a5,a0,800014c4 <kexit+0x46>
    panic("init exiting");
    800014aa:	00006517          	auipc	a0,0x6
    800014ae:	cd650513          	addi	a0,a0,-810 # 80007180 <etext+0x180>
    800014b2:	0fc040ef          	jal	800055ae <panic>
      fileclose(f);
    800014b6:	7ad010ef          	jal	80003462 <fileclose>
      p->ofile[fd] = 0;
    800014ba:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014be:	04a1                	addi	s1,s1,8
    800014c0:	01248563          	beq	s1,s2,800014ca <kexit+0x4c>
    if(p->ofile[fd]){
    800014c4:	6088                	ld	a0,0(s1)
    800014c6:	f965                	bnez	a0,800014b6 <kexit+0x38>
    800014c8:	bfdd                	j	800014be <kexit+0x40>
  begin_op();
    800014ca:	38d010ef          	jal	80003056 <begin_op>
  iput(p->cwd);
    800014ce:	1509b503          	ld	a0,336(s3)
    800014d2:	31c010ef          	jal	800027ee <iput>
  end_op();
    800014d6:	3eb010ef          	jal	800030c0 <end_op>
  p->cwd = 0;
    800014da:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014de:	00009497          	auipc	s1,0x9
    800014e2:	cfa48493          	addi	s1,s1,-774 # 8000a1d8 <wait_lock>
    800014e6:	8526                	mv	a0,s1
    800014e8:	382040ef          	jal	8000586a <acquire>
  reparent(p);
    800014ec:	854e                	mv	a0,s3
    800014ee:	f3bff0ef          	jal	80001428 <reparent>
  wakeup(p->parent);
    800014f2:	0389b503          	ld	a0,56(s3)
    800014f6:	ec9ff0ef          	jal	800013be <wakeup>
  acquire(&p->lock);
    800014fa:	854e                	mv	a0,s3
    800014fc:	36e040ef          	jal	8000586a <acquire>
  p->xstate = status;
    80001500:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001504:	4795                	li	a5,5
    80001506:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	3f6040ef          	jal	80005902 <release>
  sched();
    80001510:	d7dff0ef          	jal	8000128c <sched>
  panic("zombie exit");
    80001514:	00006517          	auipc	a0,0x6
    80001518:	c7c50513          	addi	a0,a0,-900 # 80007190 <etext+0x190>
    8000151c:	092040ef          	jal	800055ae <panic>

0000000080001520 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001520:	7179                	addi	sp,sp,-48
    80001522:	f406                	sd	ra,40(sp)
    80001524:	f022                	sd	s0,32(sp)
    80001526:	ec26                	sd	s1,24(sp)
    80001528:	e84a                	sd	s2,16(sp)
    8000152a:	e44e                	sd	s3,8(sp)
    8000152c:	1800                	addi	s0,sp,48
    8000152e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001530:	00009497          	auipc	s1,0x9
    80001534:	0c048493          	addi	s1,s1,192 # 8000a5f0 <proc>
    80001538:	0000f997          	auipc	s3,0xf
    8000153c:	ab898993          	addi	s3,s3,-1352 # 8000fff0 <tickslock>
    acquire(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	328040ef          	jal	8000586a <acquire>
    if(p->pid == pid){
    80001546:	589c                	lw	a5,48(s1)
    80001548:	01278b63          	beq	a5,s2,8000155e <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	3b4040ef          	jal	80005902 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001552:	16848493          	addi	s1,s1,360
    80001556:	ff3495e3          	bne	s1,s3,80001540 <kkill+0x20>
  }
  return -1;
    8000155a:	557d                	li	a0,-1
    8000155c:	a819                	j	80001572 <kkill+0x52>
      p->killed = 1;
    8000155e:	4785                	li	a5,1
    80001560:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001562:	4c98                	lw	a4,24(s1)
    80001564:	4789                	li	a5,2
    80001566:	00f70d63          	beq	a4,a5,80001580 <kkill+0x60>
      release(&p->lock);
    8000156a:	8526                	mv	a0,s1
    8000156c:	396040ef          	jal	80005902 <release>
      return 0;
    80001570:	4501                	li	a0,0
}
    80001572:	70a2                	ld	ra,40(sp)
    80001574:	7402                	ld	s0,32(sp)
    80001576:	64e2                	ld	s1,24(sp)
    80001578:	6942                	ld	s2,16(sp)
    8000157a:	69a2                	ld	s3,8(sp)
    8000157c:	6145                	addi	sp,sp,48
    8000157e:	8082                	ret
        p->state = RUNNABLE;
    80001580:	478d                	li	a5,3
    80001582:	cc9c                	sw	a5,24(s1)
    80001584:	b7dd                	j	8000156a <kkill+0x4a>

0000000080001586 <setkilled>:

void
setkilled(struct proc *p)
{
    80001586:	1101                	addi	sp,sp,-32
    80001588:	ec06                	sd	ra,24(sp)
    8000158a:	e822                	sd	s0,16(sp)
    8000158c:	e426                	sd	s1,8(sp)
    8000158e:	1000                	addi	s0,sp,32
    80001590:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001592:	2d8040ef          	jal	8000586a <acquire>
  p->killed = 1;
    80001596:	4785                	li	a5,1
    80001598:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	366040ef          	jal	80005902 <release>
}
    800015a0:	60e2                	ld	ra,24(sp)
    800015a2:	6442                	ld	s0,16(sp)
    800015a4:	64a2                	ld	s1,8(sp)
    800015a6:	6105                	addi	sp,sp,32
    800015a8:	8082                	ret

00000000800015aa <killed>:

int
killed(struct proc *p)
{
    800015aa:	1101                	addi	sp,sp,-32
    800015ac:	ec06                	sd	ra,24(sp)
    800015ae:	e822                	sd	s0,16(sp)
    800015b0:	e426                	sd	s1,8(sp)
    800015b2:	e04a                	sd	s2,0(sp)
    800015b4:	1000                	addi	s0,sp,32
    800015b6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015b8:	2b2040ef          	jal	8000586a <acquire>
  k = p->killed;
    800015bc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015c0:	8526                	mv	a0,s1
    800015c2:	340040ef          	jal	80005902 <release>
  return k;
}
    800015c6:	854a                	mv	a0,s2
    800015c8:	60e2                	ld	ra,24(sp)
    800015ca:	6442                	ld	s0,16(sp)
    800015cc:	64a2                	ld	s1,8(sp)
    800015ce:	6902                	ld	s2,0(sp)
    800015d0:	6105                	addi	sp,sp,32
    800015d2:	8082                	ret

00000000800015d4 <kwait>:
{
    800015d4:	715d                	addi	sp,sp,-80
    800015d6:	e486                	sd	ra,72(sp)
    800015d8:	e0a2                	sd	s0,64(sp)
    800015da:	fc26                	sd	s1,56(sp)
    800015dc:	f84a                	sd	s2,48(sp)
    800015de:	f44e                	sd	s3,40(sp)
    800015e0:	f052                	sd	s4,32(sp)
    800015e2:	ec56                	sd	s5,24(sp)
    800015e4:	e85a                	sd	s6,16(sp)
    800015e6:	e45e                	sd	s7,8(sp)
    800015e8:	e062                	sd	s8,0(sp)
    800015ea:	0880                	addi	s0,sp,80
    800015ec:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015ee:	f8cff0ef          	jal	80000d7a <myproc>
    800015f2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015f4:	00009517          	auipc	a0,0x9
    800015f8:	be450513          	addi	a0,a0,-1052 # 8000a1d8 <wait_lock>
    800015fc:	26e040ef          	jal	8000586a <acquire>
    havekids = 0;
    80001600:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001602:	4a15                	li	s4,5
        havekids = 1;
    80001604:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001606:	0000f997          	auipc	s3,0xf
    8000160a:	9ea98993          	addi	s3,s3,-1558 # 8000fff0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000160e:	00009c17          	auipc	s8,0x9
    80001612:	bcac0c13          	addi	s8,s8,-1078 # 8000a1d8 <wait_lock>
    80001616:	a871                	j	800016b2 <kwait+0xde>
          pid = pp->pid;
    80001618:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000161c:	000b0c63          	beqz	s6,80001634 <kwait+0x60>
    80001620:	4691                	li	a3,4
    80001622:	02c48613          	addi	a2,s1,44
    80001626:	85da                	mv	a1,s6
    80001628:	05093503          	ld	a0,80(s2)
    8000162c:	c62ff0ef          	jal	80000a8e <copyout>
    80001630:	02054b63          	bltz	a0,80001666 <kwait+0x92>
          freeproc(pp);
    80001634:	8526                	mv	a0,s1
    80001636:	915ff0ef          	jal	80000f4a <freeproc>
          release(&pp->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	2c6040ef          	jal	80005902 <release>
          release(&wait_lock);
    80001640:	00009517          	auipc	a0,0x9
    80001644:	b9850513          	addi	a0,a0,-1128 # 8000a1d8 <wait_lock>
    80001648:	2ba040ef          	jal	80005902 <release>
}
    8000164c:	854e                	mv	a0,s3
    8000164e:	60a6                	ld	ra,72(sp)
    80001650:	6406                	ld	s0,64(sp)
    80001652:	74e2                	ld	s1,56(sp)
    80001654:	7942                	ld	s2,48(sp)
    80001656:	79a2                	ld	s3,40(sp)
    80001658:	7a02                	ld	s4,32(sp)
    8000165a:	6ae2                	ld	s5,24(sp)
    8000165c:	6b42                	ld	s6,16(sp)
    8000165e:	6ba2                	ld	s7,8(sp)
    80001660:	6c02                	ld	s8,0(sp)
    80001662:	6161                	addi	sp,sp,80
    80001664:	8082                	ret
            release(&pp->lock);
    80001666:	8526                	mv	a0,s1
    80001668:	29a040ef          	jal	80005902 <release>
            release(&wait_lock);
    8000166c:	00009517          	auipc	a0,0x9
    80001670:	b6c50513          	addi	a0,a0,-1172 # 8000a1d8 <wait_lock>
    80001674:	28e040ef          	jal	80005902 <release>
            return -1;
    80001678:	59fd                	li	s3,-1
    8000167a:	bfc9                	j	8000164c <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000167c:	16848493          	addi	s1,s1,360
    80001680:	03348063          	beq	s1,s3,800016a0 <kwait+0xcc>
      if(pp->parent == p){
    80001684:	7c9c                	ld	a5,56(s1)
    80001686:	ff279be3          	bne	a5,s2,8000167c <kwait+0xa8>
        acquire(&pp->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	1de040ef          	jal	8000586a <acquire>
        if(pp->state == ZOMBIE){
    80001690:	4c9c                	lw	a5,24(s1)
    80001692:	f94783e3          	beq	a5,s4,80001618 <kwait+0x44>
        release(&pp->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	26a040ef          	jal	80005902 <release>
        havekids = 1;
    8000169c:	8756                	mv	a4,s5
    8000169e:	bff9                	j	8000167c <kwait+0xa8>
    if(!havekids || killed(p)){
    800016a0:	cf19                	beqz	a4,800016be <kwait+0xea>
    800016a2:	854a                	mv	a0,s2
    800016a4:	f07ff0ef          	jal	800015aa <killed>
    800016a8:	e919                	bnez	a0,800016be <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016aa:	85e2                	mv	a1,s8
    800016ac:	854a                	mv	a0,s2
    800016ae:	cc5ff0ef          	jal	80001372 <sleep>
    havekids = 0;
    800016b2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b4:	00009497          	auipc	s1,0x9
    800016b8:	f3c48493          	addi	s1,s1,-196 # 8000a5f0 <proc>
    800016bc:	b7e1                	j	80001684 <kwait+0xb0>
      release(&wait_lock);
    800016be:	00009517          	auipc	a0,0x9
    800016c2:	b1a50513          	addi	a0,a0,-1254 # 8000a1d8 <wait_lock>
    800016c6:	23c040ef          	jal	80005902 <release>
      return -1;
    800016ca:	59fd                	li	s3,-1
    800016cc:	b741                	j	8000164c <kwait+0x78>

00000000800016ce <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016ce:	7179                	addi	sp,sp,-48
    800016d0:	f406                	sd	ra,40(sp)
    800016d2:	f022                	sd	s0,32(sp)
    800016d4:	ec26                	sd	s1,24(sp)
    800016d6:	e84a                	sd	s2,16(sp)
    800016d8:	e44e                	sd	s3,8(sp)
    800016da:	e052                	sd	s4,0(sp)
    800016dc:	1800                	addi	s0,sp,48
    800016de:	84aa                	mv	s1,a0
    800016e0:	892e                	mv	s2,a1
    800016e2:	89b2                	mv	s3,a2
    800016e4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016e6:	e94ff0ef          	jal	80000d7a <myproc>
  if(user_dst){
    800016ea:	cc99                	beqz	s1,80001708 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016ec:	86d2                	mv	a3,s4
    800016ee:	864e                	mv	a2,s3
    800016f0:	85ca                	mv	a1,s2
    800016f2:	6928                	ld	a0,80(a0)
    800016f4:	b9aff0ef          	jal	80000a8e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016f8:	70a2                	ld	ra,40(sp)
    800016fa:	7402                	ld	s0,32(sp)
    800016fc:	64e2                	ld	s1,24(sp)
    800016fe:	6942                	ld	s2,16(sp)
    80001700:	69a2                	ld	s3,8(sp)
    80001702:	6a02                	ld	s4,0(sp)
    80001704:	6145                	addi	sp,sp,48
    80001706:	8082                	ret
    memmove((char *)dst, src, len);
    80001708:	000a061b          	sext.w	a2,s4
    8000170c:	85ce                	mv	a1,s3
    8000170e:	854a                	mv	a0,s2
    80001710:	a9bfe0ef          	jal	800001aa <memmove>
    return 0;
    80001714:	8526                	mv	a0,s1
    80001716:	b7cd                	j	800016f8 <either_copyout+0x2a>

0000000080001718 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001718:	7179                	addi	sp,sp,-48
    8000171a:	f406                	sd	ra,40(sp)
    8000171c:	f022                	sd	s0,32(sp)
    8000171e:	ec26                	sd	s1,24(sp)
    80001720:	e84a                	sd	s2,16(sp)
    80001722:	e44e                	sd	s3,8(sp)
    80001724:	e052                	sd	s4,0(sp)
    80001726:	1800                	addi	s0,sp,48
    80001728:	892a                	mv	s2,a0
    8000172a:	84ae                	mv	s1,a1
    8000172c:	89b2                	mv	s3,a2
    8000172e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001730:	e4aff0ef          	jal	80000d7a <myproc>
  if(user_src){
    80001734:	cc99                	beqz	s1,80001752 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001736:	86d2                	mv	a3,s4
    80001738:	864e                	mv	a2,s3
    8000173a:	85ca                	mv	a1,s2
    8000173c:	6928                	ld	a0,80(a0)
    8000173e:	c34ff0ef          	jal	80000b72 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001742:	70a2                	ld	ra,40(sp)
    80001744:	7402                	ld	s0,32(sp)
    80001746:	64e2                	ld	s1,24(sp)
    80001748:	6942                	ld	s2,16(sp)
    8000174a:	69a2                	ld	s3,8(sp)
    8000174c:	6a02                	ld	s4,0(sp)
    8000174e:	6145                	addi	sp,sp,48
    80001750:	8082                	ret
    memmove(dst, (char*)src, len);
    80001752:	000a061b          	sext.w	a2,s4
    80001756:	85ce                	mv	a1,s3
    80001758:	854a                	mv	a0,s2
    8000175a:	a51fe0ef          	jal	800001aa <memmove>
    return 0;
    8000175e:	8526                	mv	a0,s1
    80001760:	b7cd                	j	80001742 <either_copyin+0x2a>

0000000080001762 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001762:	715d                	addi	sp,sp,-80
    80001764:	e486                	sd	ra,72(sp)
    80001766:	e0a2                	sd	s0,64(sp)
    80001768:	fc26                	sd	s1,56(sp)
    8000176a:	f84a                	sd	s2,48(sp)
    8000176c:	f44e                	sd	s3,40(sp)
    8000176e:	f052                	sd	s4,32(sp)
    80001770:	ec56                	sd	s5,24(sp)
    80001772:	e85a                	sd	s6,16(sp)
    80001774:	e45e                	sd	s7,8(sp)
    80001776:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001778:	00006517          	auipc	a0,0x6
    8000177c:	8a050513          	addi	a0,a0,-1888 # 80007018 <etext+0x18>
    80001780:	349030ef          	jal	800052c8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001784:	00009497          	auipc	s1,0x9
    80001788:	fc448493          	addi	s1,s1,-60 # 8000a748 <proc+0x158>
    8000178c:	0000f917          	auipc	s2,0xf
    80001790:	9bc90913          	addi	s2,s2,-1604 # 80010148 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001794:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001796:	00006997          	auipc	s3,0x6
    8000179a:	a0a98993          	addi	s3,s3,-1526 # 800071a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    8000179e:	00006a97          	auipc	s5,0x6
    800017a2:	a0aa8a93          	addi	s5,s5,-1526 # 800071a8 <etext+0x1a8>
    printf("\n");
    800017a6:	00006a17          	auipc	s4,0x6
    800017aa:	872a0a13          	addi	s4,s4,-1934 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ae:	00006b97          	auipc	s7,0x6
    800017b2:	f62b8b93          	addi	s7,s7,-158 # 80007710 <states.0>
    800017b6:	a829                	j	800017d0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017b8:	ed86a583          	lw	a1,-296(a3)
    800017bc:	8556                	mv	a0,s5
    800017be:	30b030ef          	jal	800052c8 <printf>
    printf("\n");
    800017c2:	8552                	mv	a0,s4
    800017c4:	305030ef          	jal	800052c8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017c8:	16848493          	addi	s1,s1,360
    800017cc:	03248263          	beq	s1,s2,800017f0 <procdump+0x8e>
    if(p->state == UNUSED)
    800017d0:	86a6                	mv	a3,s1
    800017d2:	ec04a783          	lw	a5,-320(s1)
    800017d6:	dbed                	beqz	a5,800017c8 <procdump+0x66>
      state = "???";
    800017d8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017da:	fcfb6fe3          	bltu	s6,a5,800017b8 <procdump+0x56>
    800017de:	02079713          	slli	a4,a5,0x20
    800017e2:	01d75793          	srli	a5,a4,0x1d
    800017e6:	97de                	add	a5,a5,s7
    800017e8:	6390                	ld	a2,0(a5)
    800017ea:	f679                	bnez	a2,800017b8 <procdump+0x56>
      state = "???";
    800017ec:	864e                	mv	a2,s3
    800017ee:	b7e9                	j	800017b8 <procdump+0x56>
  }
}
    800017f0:	60a6                	ld	ra,72(sp)
    800017f2:	6406                	ld	s0,64(sp)
    800017f4:	74e2                	ld	s1,56(sp)
    800017f6:	7942                	ld	s2,48(sp)
    800017f8:	79a2                	ld	s3,40(sp)
    800017fa:	7a02                	ld	s4,32(sp)
    800017fc:	6ae2                	ld	s5,24(sp)
    800017fe:	6b42                	ld	s6,16(sp)
    80001800:	6ba2                	ld	s7,8(sp)
    80001802:	6161                	addi	sp,sp,80
    80001804:	8082                	ret

0000000080001806 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001806:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000180a:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000180e:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001810:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001812:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001816:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8000181a:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000181e:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001822:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001826:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000182a:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000182e:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001832:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001836:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000183a:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000183e:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001842:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001844:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001846:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000184a:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000184e:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001852:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001856:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000185a:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000185e:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001862:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001866:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000186a:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000186e:	8082                	ret

0000000080001870 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001870:	1141                	addi	sp,sp,-16
    80001872:	e406                	sd	ra,8(sp)
    80001874:	e022                	sd	s0,0(sp)
    80001876:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001878:	00006597          	auipc	a1,0x6
    8000187c:	97058593          	addi	a1,a1,-1680 # 800071e8 <etext+0x1e8>
    80001880:	0000e517          	auipc	a0,0xe
    80001884:	77050513          	addi	a0,a0,1904 # 8000fff0 <tickslock>
    80001888:	763030ef          	jal	800057ea <initlock>
}
    8000188c:	60a2                	ld	ra,8(sp)
    8000188e:	6402                	ld	s0,0(sp)
    80001890:	0141                	addi	sp,sp,16
    80001892:	8082                	ret

0000000080001894 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001894:	1141                	addi	sp,sp,-16
    80001896:	e422                	sd	s0,8(sp)
    80001898:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000189a:	00003797          	auipc	a5,0x3
    8000189e:	f3678793          	addi	a5,a5,-202 # 800047d0 <kernelvec>
    800018a2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018a6:	6422                	ld	s0,8(sp)
    800018a8:	0141                	addi	sp,sp,16
    800018aa:	8082                	ret

00000000800018ac <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018ac:	1141                	addi	sp,sp,-16
    800018ae:	e406                	sd	ra,8(sp)
    800018b0:	e022                	sd	s0,0(sp)
    800018b2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018b4:	cc6ff0ef          	jal	80000d7a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018bc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018be:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018c2:	04000737          	lui	a4,0x4000
    800018c6:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018c8:	0732                	slli	a4,a4,0xc
    800018ca:	00004797          	auipc	a5,0x4
    800018ce:	73678793          	addi	a5,a5,1846 # 80006000 <_trampoline>
    800018d2:	00004697          	auipc	a3,0x4
    800018d6:	72e68693          	addi	a3,a3,1838 # 80006000 <_trampoline>
    800018da:	8f95                	sub	a5,a5,a3
    800018dc:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018de:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018e2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018e4:	18002773          	csrr	a4,satp
    800018e8:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018ea:	6d38                	ld	a4,88(a0)
    800018ec:	613c                	ld	a5,64(a0)
    800018ee:	6685                	lui	a3,0x1
    800018f0:	97b6                	add	a5,a5,a3
    800018f2:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018f4:	6d3c                	ld	a5,88(a0)
    800018f6:	00000717          	auipc	a4,0x0
    800018fa:	0f870713          	addi	a4,a4,248 # 800019ee <usertrap>
    800018fe:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001900:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001902:	8712                	mv	a4,tp
    80001904:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001906:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000190a:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000190e:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001912:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001916:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001918:	6f9c                	ld	a5,24(a5)
    8000191a:	14179073          	csrw	sepc,a5
}
    8000191e:	60a2                	ld	ra,8(sp)
    80001920:	6402                	ld	s0,0(sp)
    80001922:	0141                	addi	sp,sp,16
    80001924:	8082                	ret

0000000080001926 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001926:	1101                	addi	sp,sp,-32
    80001928:	ec06                	sd	ra,24(sp)
    8000192a:	e822                	sd	s0,16(sp)
    8000192c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000192e:	c20ff0ef          	jal	80000d4e <cpuid>
    80001932:	cd11                	beqz	a0,8000194e <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001934:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001938:	000f4737          	lui	a4,0xf4
    8000193c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001940:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001942:	14d79073          	csrw	stimecmp,a5
}
    80001946:	60e2                	ld	ra,24(sp)
    80001948:	6442                	ld	s0,16(sp)
    8000194a:	6105                	addi	sp,sp,32
    8000194c:	8082                	ret
    8000194e:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001950:	0000e497          	auipc	s1,0xe
    80001954:	6a048493          	addi	s1,s1,1696 # 8000fff0 <tickslock>
    80001958:	8526                	mv	a0,s1
    8000195a:	711030ef          	jal	8000586a <acquire>
    ticks++;
    8000195e:	00009517          	auipc	a0,0x9
    80001962:	82a50513          	addi	a0,a0,-2006 # 8000a188 <ticks>
    80001966:	411c                	lw	a5,0(a0)
    80001968:	2785                	addiw	a5,a5,1
    8000196a:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000196c:	a53ff0ef          	jal	800013be <wakeup>
    release(&tickslock);
    80001970:	8526                	mv	a0,s1
    80001972:	791030ef          	jal	80005902 <release>
    80001976:	64a2                	ld	s1,8(sp)
    80001978:	bf75                	j	80001934 <clockintr+0xe>

000000008000197a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000197a:	1101                	addi	sp,sp,-32
    8000197c:	ec06                	sd	ra,24(sp)
    8000197e:	e822                	sd	s0,16(sp)
    80001980:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001982:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001986:	57fd                	li	a5,-1
    80001988:	17fe                	slli	a5,a5,0x3f
    8000198a:	07a5                	addi	a5,a5,9
    8000198c:	00f70c63          	beq	a4,a5,800019a4 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001990:	57fd                	li	a5,-1
    80001992:	17fe                	slli	a5,a5,0x3f
    80001994:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001996:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001998:	04f70763          	beq	a4,a5,800019e6 <devintr+0x6c>
  }
}
    8000199c:	60e2                	ld	ra,24(sp)
    8000199e:	6442                	ld	s0,16(sp)
    800019a0:	6105                	addi	sp,sp,32
    800019a2:	8082                	ret
    800019a4:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019a6:	6d7020ef          	jal	8000487c <plic_claim>
    800019aa:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019ac:	47a9                	li	a5,10
    800019ae:	00f50963          	beq	a0,a5,800019c0 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019b2:	4785                	li	a5,1
    800019b4:	00f50963          	beq	a0,a5,800019c6 <devintr+0x4c>
    return 1;
    800019b8:	4505                	li	a0,1
    } else if(irq){
    800019ba:	e889                	bnez	s1,800019cc <devintr+0x52>
    800019bc:	64a2                	ld	s1,8(sp)
    800019be:	bff9                	j	8000199c <devintr+0x22>
      uartintr();
    800019c0:	5bf030ef          	jal	8000577e <uartintr>
    if(irq)
    800019c4:	a819                	j	800019da <devintr+0x60>
      virtio_disk_intr();
    800019c6:	37c030ef          	jal	80004d42 <virtio_disk_intr>
    if(irq)
    800019ca:	a801                	j	800019da <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019cc:	85a6                	mv	a1,s1
    800019ce:	00006517          	auipc	a0,0x6
    800019d2:	82250513          	addi	a0,a0,-2014 # 800071f0 <etext+0x1f0>
    800019d6:	0f3030ef          	jal	800052c8 <printf>
      plic_complete(irq);
    800019da:	8526                	mv	a0,s1
    800019dc:	6c1020ef          	jal	8000489c <plic_complete>
    return 1;
    800019e0:	4505                	li	a0,1
    800019e2:	64a2                	ld	s1,8(sp)
    800019e4:	bf65                	j	8000199c <devintr+0x22>
    clockintr();
    800019e6:	f41ff0ef          	jal	80001926 <clockintr>
    return 2;
    800019ea:	4509                	li	a0,2
    800019ec:	bf45                	j	8000199c <devintr+0x22>

00000000800019ee <usertrap>:
{
    800019ee:	1101                	addi	sp,sp,-32
    800019f0:	ec06                	sd	ra,24(sp)
    800019f2:	e822                	sd	s0,16(sp)
    800019f4:	e426                	sd	s1,8(sp)
    800019f6:	e04a                	sd	s2,0(sp)
    800019f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019fa:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019fe:	1007f793          	andi	a5,a5,256
    80001a02:	eba5                	bnez	a5,80001a72 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a04:	00003797          	auipc	a5,0x3
    80001a08:	dcc78793          	addi	a5,a5,-564 # 800047d0 <kernelvec>
    80001a0c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a10:	b6aff0ef          	jal	80000d7a <myproc>
    80001a14:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a16:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a18:	14102773          	csrr	a4,sepc
    80001a1c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a1e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a22:	47a1                	li	a5,8
    80001a24:	04f70d63          	beq	a4,a5,80001a7e <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a28:	f53ff0ef          	jal	8000197a <devintr>
    80001a2c:	892a                	mv	s2,a0
    80001a2e:	e945                	bnez	a0,80001ade <usertrap+0xf0>
    80001a30:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a34:	47bd                	li	a5,15
    80001a36:	08f70863          	beq	a4,a5,80001ac6 <usertrap+0xd8>
    80001a3a:	14202773          	csrr	a4,scause
    80001a3e:	47b5                	li	a5,13
    80001a40:	08f70363          	beq	a4,a5,80001ac6 <usertrap+0xd8>
    80001a44:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a48:	5890                	lw	a2,48(s1)
    80001a4a:	00005517          	auipc	a0,0x5
    80001a4e:	7e650513          	addi	a0,a0,2022 # 80007230 <etext+0x230>
    80001a52:	077030ef          	jal	800052c8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a56:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a5a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a5e:	00006517          	auipc	a0,0x6
    80001a62:	80250513          	addi	a0,a0,-2046 # 80007260 <etext+0x260>
    80001a66:	063030ef          	jal	800052c8 <printf>
    setkilled(p);
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	b1bff0ef          	jal	80001586 <setkilled>
    80001a70:	a035                	j	80001a9c <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a72:	00005517          	auipc	a0,0x5
    80001a76:	79e50513          	addi	a0,a0,1950 # 80007210 <etext+0x210>
    80001a7a:	335030ef          	jal	800055ae <panic>
    if(killed(p))
    80001a7e:	b2dff0ef          	jal	800015aa <killed>
    80001a82:	ed15                	bnez	a0,80001abe <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001a84:	6cb8                	ld	a4,88(s1)
    80001a86:	6f1c                	ld	a5,24(a4)
    80001a88:	0791                	addi	a5,a5,4
    80001a8a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a90:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a94:	10079073          	csrw	sstatus,a5
    syscall();
    80001a98:	246000ef          	jal	80001cde <syscall>
  if(killed(p))
    80001a9c:	8526                	mv	a0,s1
    80001a9e:	b0dff0ef          	jal	800015aa <killed>
    80001aa2:	e139                	bnez	a0,80001ae8 <usertrap+0xfa>
  prepare_return();
    80001aa4:	e09ff0ef          	jal	800018ac <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001aa8:	68a8                	ld	a0,80(s1)
    80001aaa:	8131                	srli	a0,a0,0xc
    80001aac:	57fd                	li	a5,-1
    80001aae:	17fe                	slli	a5,a5,0x3f
    80001ab0:	8d5d                	or	a0,a0,a5
}
    80001ab2:	60e2                	ld	ra,24(sp)
    80001ab4:	6442                	ld	s0,16(sp)
    80001ab6:	64a2                	ld	s1,8(sp)
    80001ab8:	6902                	ld	s2,0(sp)
    80001aba:	6105                	addi	sp,sp,32
    80001abc:	8082                	ret
      kexit(-1);
    80001abe:	557d                	li	a0,-1
    80001ac0:	9bfff0ef          	jal	8000147e <kexit>
    80001ac4:	b7c1                	j	80001a84 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ac6:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aca:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001ace:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001ad0:	00163613          	seqz	a2,a2
    80001ad4:	68a8                	ld	a0,80(s1)
    80001ad6:	f37fe0ef          	jal	80000a0c <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001ada:	f169                	bnez	a0,80001a9c <usertrap+0xae>
    80001adc:	b7a5                	j	80001a44 <usertrap+0x56>
  if(killed(p))
    80001ade:	8526                	mv	a0,s1
    80001ae0:	acbff0ef          	jal	800015aa <killed>
    80001ae4:	c511                	beqz	a0,80001af0 <usertrap+0x102>
    80001ae6:	a011                	j	80001aea <usertrap+0xfc>
    80001ae8:	4901                	li	s2,0
    kexit(-1);
    80001aea:	557d                	li	a0,-1
    80001aec:	993ff0ef          	jal	8000147e <kexit>
  if(which_dev == 2)
    80001af0:	4789                	li	a5,2
    80001af2:	faf919e3          	bne	s2,a5,80001aa4 <usertrap+0xb6>
    yield();
    80001af6:	851ff0ef          	jal	80001346 <yield>
    80001afa:	b76d                	j	80001aa4 <usertrap+0xb6>

0000000080001afc <kerneltrap>:
{
    80001afc:	7179                	addi	sp,sp,-48
    80001afe:	f406                	sd	ra,40(sp)
    80001b00:	f022                	sd	s0,32(sp)
    80001b02:	ec26                	sd	s1,24(sp)
    80001b04:	e84a                	sd	s2,16(sp)
    80001b06:	e44e                	sd	s3,8(sp)
    80001b08:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b0a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b12:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b16:	1004f793          	andi	a5,s1,256
    80001b1a:	c795                	beqz	a5,80001b46 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b20:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b22:	eb85                	bnez	a5,80001b52 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b24:	e57ff0ef          	jal	8000197a <devintr>
    80001b28:	c91d                	beqz	a0,80001b5e <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b2a:	4789                	li	a5,2
    80001b2c:	04f50a63          	beq	a0,a5,80001b80 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b30:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b34:	10049073          	csrw	sstatus,s1
}
    80001b38:	70a2                	ld	ra,40(sp)
    80001b3a:	7402                	ld	s0,32(sp)
    80001b3c:	64e2                	ld	s1,24(sp)
    80001b3e:	6942                	ld	s2,16(sp)
    80001b40:	69a2                	ld	s3,8(sp)
    80001b42:	6145                	addi	sp,sp,48
    80001b44:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b46:	00005517          	auipc	a0,0x5
    80001b4a:	74250513          	addi	a0,a0,1858 # 80007288 <etext+0x288>
    80001b4e:	261030ef          	jal	800055ae <panic>
    panic("kerneltrap: interrupts enabled");
    80001b52:	00005517          	auipc	a0,0x5
    80001b56:	75e50513          	addi	a0,a0,1886 # 800072b0 <etext+0x2b0>
    80001b5a:	255030ef          	jal	800055ae <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b5e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b62:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b66:	85ce                	mv	a1,s3
    80001b68:	00005517          	auipc	a0,0x5
    80001b6c:	76850513          	addi	a0,a0,1896 # 800072d0 <etext+0x2d0>
    80001b70:	758030ef          	jal	800052c8 <printf>
    panic("kerneltrap");
    80001b74:	00005517          	auipc	a0,0x5
    80001b78:	78450513          	addi	a0,a0,1924 # 800072f8 <etext+0x2f8>
    80001b7c:	233030ef          	jal	800055ae <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b80:	9faff0ef          	jal	80000d7a <myproc>
    80001b84:	d555                	beqz	a0,80001b30 <kerneltrap+0x34>
    yield();
    80001b86:	fc0ff0ef          	jal	80001346 <yield>
    80001b8a:	b75d                	j	80001b30 <kerneltrap+0x34>

0000000080001b8c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b8c:	1101                	addi	sp,sp,-32
    80001b8e:	ec06                	sd	ra,24(sp)
    80001b90:	e822                	sd	s0,16(sp)
    80001b92:	e426                	sd	s1,8(sp)
    80001b94:	1000                	addi	s0,sp,32
    80001b96:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b98:	9e2ff0ef          	jal	80000d7a <myproc>
  switch (n) {
    80001b9c:	4795                	li	a5,5
    80001b9e:	0497e163          	bltu	a5,s1,80001be0 <argraw+0x54>
    80001ba2:	048a                	slli	s1,s1,0x2
    80001ba4:	00006717          	auipc	a4,0x6
    80001ba8:	b9c70713          	addi	a4,a4,-1124 # 80007740 <states.0+0x30>
    80001bac:	94ba                	add	s1,s1,a4
    80001bae:	409c                	lw	a5,0(s1)
    80001bb0:	97ba                	add	a5,a5,a4
    80001bb2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bb4:	6d3c                	ld	a5,88(a0)
    80001bb6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bb8:	60e2                	ld	ra,24(sp)
    80001bba:	6442                	ld	s0,16(sp)
    80001bbc:	64a2                	ld	s1,8(sp)
    80001bbe:	6105                	addi	sp,sp,32
    80001bc0:	8082                	ret
    return p->trapframe->a1;
    80001bc2:	6d3c                	ld	a5,88(a0)
    80001bc4:	7fa8                	ld	a0,120(a5)
    80001bc6:	bfcd                	j	80001bb8 <argraw+0x2c>
    return p->trapframe->a2;
    80001bc8:	6d3c                	ld	a5,88(a0)
    80001bca:	63c8                	ld	a0,128(a5)
    80001bcc:	b7f5                	j	80001bb8 <argraw+0x2c>
    return p->trapframe->a3;
    80001bce:	6d3c                	ld	a5,88(a0)
    80001bd0:	67c8                	ld	a0,136(a5)
    80001bd2:	b7dd                	j	80001bb8 <argraw+0x2c>
    return p->trapframe->a4;
    80001bd4:	6d3c                	ld	a5,88(a0)
    80001bd6:	6bc8                	ld	a0,144(a5)
    80001bd8:	b7c5                	j	80001bb8 <argraw+0x2c>
    return p->trapframe->a5;
    80001bda:	6d3c                	ld	a5,88(a0)
    80001bdc:	6fc8                	ld	a0,152(a5)
    80001bde:	bfe9                	j	80001bb8 <argraw+0x2c>
  panic("argraw");
    80001be0:	00005517          	auipc	a0,0x5
    80001be4:	72850513          	addi	a0,a0,1832 # 80007308 <etext+0x308>
    80001be8:	1c7030ef          	jal	800055ae <panic>

0000000080001bec <fetchaddr>:
{
    80001bec:	1101                	addi	sp,sp,-32
    80001bee:	ec06                	sd	ra,24(sp)
    80001bf0:	e822                	sd	s0,16(sp)
    80001bf2:	e426                	sd	s1,8(sp)
    80001bf4:	e04a                	sd	s2,0(sp)
    80001bf6:	1000                	addi	s0,sp,32
    80001bf8:	84aa                	mv	s1,a0
    80001bfa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001bfc:	97eff0ef          	jal	80000d7a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c00:	653c                	ld	a5,72(a0)
    80001c02:	02f4f663          	bgeu	s1,a5,80001c2e <fetchaddr+0x42>
    80001c06:	00848713          	addi	a4,s1,8
    80001c0a:	02e7e463          	bltu	a5,a4,80001c32 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c0e:	46a1                	li	a3,8
    80001c10:	8626                	mv	a2,s1
    80001c12:	85ca                	mv	a1,s2
    80001c14:	6928                	ld	a0,80(a0)
    80001c16:	f5dfe0ef          	jal	80000b72 <copyin>
    80001c1a:	00a03533          	snez	a0,a0
    80001c1e:	40a00533          	neg	a0,a0
}
    80001c22:	60e2                	ld	ra,24(sp)
    80001c24:	6442                	ld	s0,16(sp)
    80001c26:	64a2                	ld	s1,8(sp)
    80001c28:	6902                	ld	s2,0(sp)
    80001c2a:	6105                	addi	sp,sp,32
    80001c2c:	8082                	ret
    return -1;
    80001c2e:	557d                	li	a0,-1
    80001c30:	bfcd                	j	80001c22 <fetchaddr+0x36>
    80001c32:	557d                	li	a0,-1
    80001c34:	b7fd                	j	80001c22 <fetchaddr+0x36>

0000000080001c36 <fetchstr>:
{
    80001c36:	7179                	addi	sp,sp,-48
    80001c38:	f406                	sd	ra,40(sp)
    80001c3a:	f022                	sd	s0,32(sp)
    80001c3c:	ec26                	sd	s1,24(sp)
    80001c3e:	e84a                	sd	s2,16(sp)
    80001c40:	e44e                	sd	s3,8(sp)
    80001c42:	1800                	addi	s0,sp,48
    80001c44:	892a                	mv	s2,a0
    80001c46:	84ae                	mv	s1,a1
    80001c48:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c4a:	930ff0ef          	jal	80000d7a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c4e:	86ce                	mv	a3,s3
    80001c50:	864a                	mv	a2,s2
    80001c52:	85a6                	mv	a1,s1
    80001c54:	6928                	ld	a0,80(a0)
    80001c56:	cdffe0ef          	jal	80000934 <copyinstr>
    80001c5a:	00054c63          	bltz	a0,80001c72 <fetchstr+0x3c>
  return strlen(buf);
    80001c5e:	8526                	mv	a0,s1
    80001c60:	e5efe0ef          	jal	800002be <strlen>
}
    80001c64:	70a2                	ld	ra,40(sp)
    80001c66:	7402                	ld	s0,32(sp)
    80001c68:	64e2                	ld	s1,24(sp)
    80001c6a:	6942                	ld	s2,16(sp)
    80001c6c:	69a2                	ld	s3,8(sp)
    80001c6e:	6145                	addi	sp,sp,48
    80001c70:	8082                	ret
    return -1;
    80001c72:	557d                	li	a0,-1
    80001c74:	bfc5                	j	80001c64 <fetchstr+0x2e>

0000000080001c76 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c76:	1101                	addi	sp,sp,-32
    80001c78:	ec06                	sd	ra,24(sp)
    80001c7a:	e822                	sd	s0,16(sp)
    80001c7c:	e426                	sd	s1,8(sp)
    80001c7e:	1000                	addi	s0,sp,32
    80001c80:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c82:	f0bff0ef          	jal	80001b8c <argraw>
    80001c86:	c088                	sw	a0,0(s1)
}
    80001c88:	60e2                	ld	ra,24(sp)
    80001c8a:	6442                	ld	s0,16(sp)
    80001c8c:	64a2                	ld	s1,8(sp)
    80001c8e:	6105                	addi	sp,sp,32
    80001c90:	8082                	ret

0000000080001c92 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c92:	1101                	addi	sp,sp,-32
    80001c94:	ec06                	sd	ra,24(sp)
    80001c96:	e822                	sd	s0,16(sp)
    80001c98:	e426                	sd	s1,8(sp)
    80001c9a:	1000                	addi	s0,sp,32
    80001c9c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c9e:	eefff0ef          	jal	80001b8c <argraw>
    80001ca2:	e088                	sd	a0,0(s1)
}
    80001ca4:	60e2                	ld	ra,24(sp)
    80001ca6:	6442                	ld	s0,16(sp)
    80001ca8:	64a2                	ld	s1,8(sp)
    80001caa:	6105                	addi	sp,sp,32
    80001cac:	8082                	ret

0000000080001cae <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cae:	7179                	addi	sp,sp,-48
    80001cb0:	f406                	sd	ra,40(sp)
    80001cb2:	f022                	sd	s0,32(sp)
    80001cb4:	ec26                	sd	s1,24(sp)
    80001cb6:	e84a                	sd	s2,16(sp)
    80001cb8:	1800                	addi	s0,sp,48
    80001cba:	84ae                	mv	s1,a1
    80001cbc:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cbe:	fd840593          	addi	a1,s0,-40
    80001cc2:	fd1ff0ef          	jal	80001c92 <argaddr>
  return fetchstr(addr, buf, max);
    80001cc6:	864a                	mv	a2,s2
    80001cc8:	85a6                	mv	a1,s1
    80001cca:	fd843503          	ld	a0,-40(s0)
    80001cce:	f69ff0ef          	jal	80001c36 <fetchstr>
}
    80001cd2:	70a2                	ld	ra,40(sp)
    80001cd4:	7402                	ld	s0,32(sp)
    80001cd6:	64e2                	ld	s1,24(sp)
    80001cd8:	6942                	ld	s2,16(sp)
    80001cda:	6145                	addi	sp,sp,48
    80001cdc:	8082                	ret

0000000080001cde <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001cde:	1101                	addi	sp,sp,-32
    80001ce0:	ec06                	sd	ra,24(sp)
    80001ce2:	e822                	sd	s0,16(sp)
    80001ce4:	e426                	sd	s1,8(sp)
    80001ce6:	e04a                	sd	s2,0(sp)
    80001ce8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001cea:	890ff0ef          	jal	80000d7a <myproc>
    80001cee:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001cf0:	05853903          	ld	s2,88(a0)
    80001cf4:	0a893783          	ld	a5,168(s2)
    80001cf8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001cfc:	37fd                	addiw	a5,a5,-1
    80001cfe:	4751                	li	a4,20
    80001d00:	00f76f63          	bltu	a4,a5,80001d1e <syscall+0x40>
    80001d04:	00369713          	slli	a4,a3,0x3
    80001d08:	00006797          	auipc	a5,0x6
    80001d0c:	a5078793          	addi	a5,a5,-1456 # 80007758 <syscalls>
    80001d10:	97ba                	add	a5,a5,a4
    80001d12:	639c                	ld	a5,0(a5)
    80001d14:	c789                	beqz	a5,80001d1e <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d16:	9782                	jalr	a5
    80001d18:	06a93823          	sd	a0,112(s2)
    80001d1c:	a829                	j	80001d36 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d1e:	15848613          	addi	a2,s1,344
    80001d22:	588c                	lw	a1,48(s1)
    80001d24:	00005517          	auipc	a0,0x5
    80001d28:	5ec50513          	addi	a0,a0,1516 # 80007310 <etext+0x310>
    80001d2c:	59c030ef          	jal	800052c8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d30:	6cbc                	ld	a5,88(s1)
    80001d32:	577d                	li	a4,-1
    80001d34:	fbb8                	sd	a4,112(a5)
  }
}
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	6902                	ld	s2,0(sp)
    80001d3e:	6105                	addi	sp,sp,32
    80001d40:	8082                	ret

0000000080001d42 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001d42:	1101                	addi	sp,sp,-32
    80001d44:	ec06                	sd	ra,24(sp)
    80001d46:	e822                	sd	s0,16(sp)
    80001d48:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d4a:	fec40593          	addi	a1,s0,-20
    80001d4e:	4501                	li	a0,0
    80001d50:	f27ff0ef          	jal	80001c76 <argint>
  kexit(n);
    80001d54:	fec42503          	lw	a0,-20(s0)
    80001d58:	f26ff0ef          	jal	8000147e <kexit>
  return 0;  // not reached
}
    80001d5c:	4501                	li	a0,0
    80001d5e:	60e2                	ld	ra,24(sp)
    80001d60:	6442                	ld	s0,16(sp)
    80001d62:	6105                	addi	sp,sp,32
    80001d64:	8082                	ret

0000000080001d66 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d66:	1141                	addi	sp,sp,-16
    80001d68:	e406                	sd	ra,8(sp)
    80001d6a:	e022                	sd	s0,0(sp)
    80001d6c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d6e:	80cff0ef          	jal	80000d7a <myproc>
}
    80001d72:	5908                	lw	a0,48(a0)
    80001d74:	60a2                	ld	ra,8(sp)
    80001d76:	6402                	ld	s0,0(sp)
    80001d78:	0141                	addi	sp,sp,16
    80001d7a:	8082                	ret

0000000080001d7c <sys_fork>:

uint64
sys_fork(void)
{
    80001d7c:	1141                	addi	sp,sp,-16
    80001d7e:	e406                	sd	ra,8(sp)
    80001d80:	e022                	sd	s0,0(sp)
    80001d82:	0800                	addi	s0,sp,16
  return kfork();
    80001d84:	b48ff0ef          	jal	800010cc <kfork>
}
    80001d88:	60a2                	ld	ra,8(sp)
    80001d8a:	6402                	ld	s0,0(sp)
    80001d8c:	0141                	addi	sp,sp,16
    80001d8e:	8082                	ret

0000000080001d90 <sys_wait>:

uint64
sys_wait(void)
{
    80001d90:	1101                	addi	sp,sp,-32
    80001d92:	ec06                	sd	ra,24(sp)
    80001d94:	e822                	sd	s0,16(sp)
    80001d96:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d98:	fe840593          	addi	a1,s0,-24
    80001d9c:	4501                	li	a0,0
    80001d9e:	ef5ff0ef          	jal	80001c92 <argaddr>
  return kwait(p);
    80001da2:	fe843503          	ld	a0,-24(s0)
    80001da6:	82fff0ef          	jal	800015d4 <kwait>
}
    80001daa:	60e2                	ld	ra,24(sp)
    80001dac:	6442                	ld	s0,16(sp)
    80001dae:	6105                	addi	sp,sp,32
    80001db0:	8082                	ret

0000000080001db2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001db2:	7179                	addi	sp,sp,-48
    80001db4:	f406                	sd	ra,40(sp)
    80001db6:	f022                	sd	s0,32(sp)
    80001db8:	ec26                	sd	s1,24(sp)
    80001dba:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001dbc:	fd840593          	addi	a1,s0,-40
    80001dc0:	4501                	li	a0,0
    80001dc2:	eb5ff0ef          	jal	80001c76 <argint>
  argint(1, &t);
    80001dc6:	fdc40593          	addi	a1,s0,-36
    80001dca:	4505                	li	a0,1
    80001dcc:	eabff0ef          	jal	80001c76 <argint>
  addr = myproc()->sz;
    80001dd0:	fabfe0ef          	jal	80000d7a <myproc>
    80001dd4:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001dd6:	fdc42703          	lw	a4,-36(s0)
    80001dda:	4785                	li	a5,1
    80001ddc:	02f70163          	beq	a4,a5,80001dfe <sys_sbrk+0x4c>
    80001de0:	fd842783          	lw	a5,-40(s0)
    80001de4:	0007cd63          	bltz	a5,80001dfe <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001de8:	97a6                	add	a5,a5,s1
    80001dea:	0297e863          	bltu	a5,s1,80001e1a <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001dee:	f8dfe0ef          	jal	80000d7a <myproc>
    80001df2:	fd842703          	lw	a4,-40(s0)
    80001df6:	653c                	ld	a5,72(a0)
    80001df8:	97ba                	add	a5,a5,a4
    80001dfa:	e53c                	sd	a5,72(a0)
    80001dfc:	a039                	j	80001e0a <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001dfe:	fd842503          	lw	a0,-40(s0)
    80001e02:	a7aff0ef          	jal	8000107c <growproc>
    80001e06:	00054863          	bltz	a0,80001e16 <sys_sbrk+0x64>
  }
  return addr;
}
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	70a2                	ld	ra,40(sp)
    80001e0e:	7402                	ld	s0,32(sp)
    80001e10:	64e2                	ld	s1,24(sp)
    80001e12:	6145                	addi	sp,sp,48
    80001e14:	8082                	ret
      return -1;
    80001e16:	54fd                	li	s1,-1
    80001e18:	bfcd                	j	80001e0a <sys_sbrk+0x58>
      return -1;
    80001e1a:	54fd                	li	s1,-1
    80001e1c:	b7fd                	j	80001e0a <sys_sbrk+0x58>

0000000080001e1e <sys_pause>:

uint64
sys_pause(void)
{
    80001e1e:	7139                	addi	sp,sp,-64
    80001e20:	fc06                	sd	ra,56(sp)
    80001e22:	f822                	sd	s0,48(sp)
    80001e24:	f04a                	sd	s2,32(sp)
    80001e26:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e28:	fcc40593          	addi	a1,s0,-52
    80001e2c:	4501                	li	a0,0
    80001e2e:	e49ff0ef          	jal	80001c76 <argint>
  if(n < 0)
    80001e32:	fcc42783          	lw	a5,-52(s0)
    80001e36:	0607c763          	bltz	a5,80001ea4 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001e3a:	0000e517          	auipc	a0,0xe
    80001e3e:	1b650513          	addi	a0,a0,438 # 8000fff0 <tickslock>
    80001e42:	229030ef          	jal	8000586a <acquire>
  ticks0 = ticks;
    80001e46:	00008917          	auipc	s2,0x8
    80001e4a:	34292903          	lw	s2,834(s2) # 8000a188 <ticks>
  while(ticks - ticks0 < n){
    80001e4e:	fcc42783          	lw	a5,-52(s0)
    80001e52:	cf8d                	beqz	a5,80001e8c <sys_pause+0x6e>
    80001e54:	f426                	sd	s1,40(sp)
    80001e56:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e58:	0000e997          	auipc	s3,0xe
    80001e5c:	19898993          	addi	s3,s3,408 # 8000fff0 <tickslock>
    80001e60:	00008497          	auipc	s1,0x8
    80001e64:	32848493          	addi	s1,s1,808 # 8000a188 <ticks>
    if(killed(myproc())){
    80001e68:	f13fe0ef          	jal	80000d7a <myproc>
    80001e6c:	f3eff0ef          	jal	800015aa <killed>
    80001e70:	ed0d                	bnez	a0,80001eaa <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001e72:	85ce                	mv	a1,s3
    80001e74:	8526                	mv	a0,s1
    80001e76:	cfcff0ef          	jal	80001372 <sleep>
  while(ticks - ticks0 < n){
    80001e7a:	409c                	lw	a5,0(s1)
    80001e7c:	412787bb          	subw	a5,a5,s2
    80001e80:	fcc42703          	lw	a4,-52(s0)
    80001e84:	fee7e2e3          	bltu	a5,a4,80001e68 <sys_pause+0x4a>
    80001e88:	74a2                	ld	s1,40(sp)
    80001e8a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001e8c:	0000e517          	auipc	a0,0xe
    80001e90:	16450513          	addi	a0,a0,356 # 8000fff0 <tickslock>
    80001e94:	26f030ef          	jal	80005902 <release>
  return 0;
    80001e98:	4501                	li	a0,0
}
    80001e9a:	70e2                	ld	ra,56(sp)
    80001e9c:	7442                	ld	s0,48(sp)
    80001e9e:	7902                	ld	s2,32(sp)
    80001ea0:	6121                	addi	sp,sp,64
    80001ea2:	8082                	ret
    n = 0;
    80001ea4:	fc042623          	sw	zero,-52(s0)
    80001ea8:	bf49                	j	80001e3a <sys_pause+0x1c>
      release(&tickslock);
    80001eaa:	0000e517          	auipc	a0,0xe
    80001eae:	14650513          	addi	a0,a0,326 # 8000fff0 <tickslock>
    80001eb2:	251030ef          	jal	80005902 <release>
      return -1;
    80001eb6:	557d                	li	a0,-1
    80001eb8:	74a2                	ld	s1,40(sp)
    80001eba:	69e2                	ld	s3,24(sp)
    80001ebc:	bff9                	j	80001e9a <sys_pause+0x7c>

0000000080001ebe <sys_kill>:

uint64
sys_kill(void)
{
    80001ebe:	1101                	addi	sp,sp,-32
    80001ec0:	ec06                	sd	ra,24(sp)
    80001ec2:	e822                	sd	s0,16(sp)
    80001ec4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ec6:	fec40593          	addi	a1,s0,-20
    80001eca:	4501                	li	a0,0
    80001ecc:	dabff0ef          	jal	80001c76 <argint>
  return kkill(pid);
    80001ed0:	fec42503          	lw	a0,-20(s0)
    80001ed4:	e4cff0ef          	jal	80001520 <kkill>
}
    80001ed8:	60e2                	ld	ra,24(sp)
    80001eda:	6442                	ld	s0,16(sp)
    80001edc:	6105                	addi	sp,sp,32
    80001ede:	8082                	ret

0000000080001ee0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001ee0:	1101                	addi	sp,sp,-32
    80001ee2:	ec06                	sd	ra,24(sp)
    80001ee4:	e822                	sd	s0,16(sp)
    80001ee6:	e426                	sd	s1,8(sp)
    80001ee8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001eea:	0000e517          	auipc	a0,0xe
    80001eee:	10650513          	addi	a0,a0,262 # 8000fff0 <tickslock>
    80001ef2:	179030ef          	jal	8000586a <acquire>
  xticks = ticks;
    80001ef6:	00008497          	auipc	s1,0x8
    80001efa:	2924a483          	lw	s1,658(s1) # 8000a188 <ticks>
  release(&tickslock);
    80001efe:	0000e517          	auipc	a0,0xe
    80001f02:	0f250513          	addi	a0,a0,242 # 8000fff0 <tickslock>
    80001f06:	1fd030ef          	jal	80005902 <release>
  return xticks;
}
    80001f0a:	02049513          	slli	a0,s1,0x20
    80001f0e:	9101                	srli	a0,a0,0x20
    80001f10:	60e2                	ld	ra,24(sp)
    80001f12:	6442                	ld	s0,16(sp)
    80001f14:	64a2                	ld	s1,8(sp)
    80001f16:	6105                	addi	sp,sp,32
    80001f18:	8082                	ret

0000000080001f1a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f1a:	7179                	addi	sp,sp,-48
    80001f1c:	f406                	sd	ra,40(sp)
    80001f1e:	f022                	sd	s0,32(sp)
    80001f20:	ec26                	sd	s1,24(sp)
    80001f22:	e84a                	sd	s2,16(sp)
    80001f24:	e44e                	sd	s3,8(sp)
    80001f26:	e052                	sd	s4,0(sp)
    80001f28:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f2a:	00005597          	auipc	a1,0x5
    80001f2e:	40658593          	addi	a1,a1,1030 # 80007330 <etext+0x330>
    80001f32:	0000e517          	auipc	a0,0xe
    80001f36:	0d650513          	addi	a0,a0,214 # 80010008 <bcache>
    80001f3a:	0b1030ef          	jal	800057ea <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f3e:	00016797          	auipc	a5,0x16
    80001f42:	0ca78793          	addi	a5,a5,202 # 80018008 <bcache+0x8000>
    80001f46:	00016717          	auipc	a4,0x16
    80001f4a:	32a70713          	addi	a4,a4,810 # 80018270 <bcache+0x8268>
    80001f4e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f52:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f56:	0000e497          	auipc	s1,0xe
    80001f5a:	0ca48493          	addi	s1,s1,202 # 80010020 <bcache+0x18>
    b->next = bcache.head.next;
    80001f5e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f60:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f62:	00005a17          	auipc	s4,0x5
    80001f66:	3d6a0a13          	addi	s4,s4,982 # 80007338 <etext+0x338>
    b->next = bcache.head.next;
    80001f6a:	2b893783          	ld	a5,696(s2)
    80001f6e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001f70:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001f74:	85d2                	mv	a1,s4
    80001f76:	01048513          	addi	a0,s1,16
    80001f7a:	322010ef          	jal	8000329c <initsleeplock>
    bcache.head.next->prev = b;
    80001f7e:	2b893783          	ld	a5,696(s2)
    80001f82:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001f84:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f88:	45848493          	addi	s1,s1,1112
    80001f8c:	fd349fe3          	bne	s1,s3,80001f6a <binit+0x50>
  }
}
    80001f90:	70a2                	ld	ra,40(sp)
    80001f92:	7402                	ld	s0,32(sp)
    80001f94:	64e2                	ld	s1,24(sp)
    80001f96:	6942                	ld	s2,16(sp)
    80001f98:	69a2                	ld	s3,8(sp)
    80001f9a:	6a02                	ld	s4,0(sp)
    80001f9c:	6145                	addi	sp,sp,48
    80001f9e:	8082                	ret

0000000080001fa0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001fa0:	7179                	addi	sp,sp,-48
    80001fa2:	f406                	sd	ra,40(sp)
    80001fa4:	f022                	sd	s0,32(sp)
    80001fa6:	ec26                	sd	s1,24(sp)
    80001fa8:	e84a                	sd	s2,16(sp)
    80001faa:	e44e                	sd	s3,8(sp)
    80001fac:	1800                	addi	s0,sp,48
    80001fae:	892a                	mv	s2,a0
    80001fb0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001fb2:	0000e517          	auipc	a0,0xe
    80001fb6:	05650513          	addi	a0,a0,86 # 80010008 <bcache>
    80001fba:	0b1030ef          	jal	8000586a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001fbe:	00016497          	auipc	s1,0x16
    80001fc2:	3024b483          	ld	s1,770(s1) # 800182c0 <bcache+0x82b8>
    80001fc6:	00016797          	auipc	a5,0x16
    80001fca:	2aa78793          	addi	a5,a5,682 # 80018270 <bcache+0x8268>
    80001fce:	02f48b63          	beq	s1,a5,80002004 <bread+0x64>
    80001fd2:	873e                	mv	a4,a5
    80001fd4:	a021                	j	80001fdc <bread+0x3c>
    80001fd6:	68a4                	ld	s1,80(s1)
    80001fd8:	02e48663          	beq	s1,a4,80002004 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001fdc:	449c                	lw	a5,8(s1)
    80001fde:	ff279ce3          	bne	a5,s2,80001fd6 <bread+0x36>
    80001fe2:	44dc                	lw	a5,12(s1)
    80001fe4:	ff3799e3          	bne	a5,s3,80001fd6 <bread+0x36>
      b->refcnt++;
    80001fe8:	40bc                	lw	a5,64(s1)
    80001fea:	2785                	addiw	a5,a5,1
    80001fec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001fee:	0000e517          	auipc	a0,0xe
    80001ff2:	01a50513          	addi	a0,a0,26 # 80010008 <bcache>
    80001ff6:	10d030ef          	jal	80005902 <release>
      acquiresleep(&b->lock);
    80001ffa:	01048513          	addi	a0,s1,16
    80001ffe:	2d4010ef          	jal	800032d2 <acquiresleep>
      return b;
    80002002:	a889                	j	80002054 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002004:	00016497          	auipc	s1,0x16
    80002008:	2b44b483          	ld	s1,692(s1) # 800182b8 <bcache+0x82b0>
    8000200c:	00016797          	auipc	a5,0x16
    80002010:	26478793          	addi	a5,a5,612 # 80018270 <bcache+0x8268>
    80002014:	00f48863          	beq	s1,a5,80002024 <bread+0x84>
    80002018:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000201a:	40bc                	lw	a5,64(s1)
    8000201c:	cb91                	beqz	a5,80002030 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000201e:	64a4                	ld	s1,72(s1)
    80002020:	fee49de3          	bne	s1,a4,8000201a <bread+0x7a>
  panic("bget: no buffers");
    80002024:	00005517          	auipc	a0,0x5
    80002028:	31c50513          	addi	a0,a0,796 # 80007340 <etext+0x340>
    8000202c:	582030ef          	jal	800055ae <panic>
      b->dev = dev;
    80002030:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002034:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002038:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000203c:	4785                	li	a5,1
    8000203e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002040:	0000e517          	auipc	a0,0xe
    80002044:	fc850513          	addi	a0,a0,-56 # 80010008 <bcache>
    80002048:	0bb030ef          	jal	80005902 <release>
      acquiresleep(&b->lock);
    8000204c:	01048513          	addi	a0,s1,16
    80002050:	282010ef          	jal	800032d2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002054:	409c                	lw	a5,0(s1)
    80002056:	cb89                	beqz	a5,80002068 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002058:	8526                	mv	a0,s1
    8000205a:	70a2                	ld	ra,40(sp)
    8000205c:	7402                	ld	s0,32(sp)
    8000205e:	64e2                	ld	s1,24(sp)
    80002060:	6942                	ld	s2,16(sp)
    80002062:	69a2                	ld	s3,8(sp)
    80002064:	6145                	addi	sp,sp,48
    80002066:	8082                	ret
    virtio_disk_rw(b, 0);
    80002068:	4581                	li	a1,0
    8000206a:	8526                	mv	a0,s1
    8000206c:	2c5020ef          	jal	80004b30 <virtio_disk_rw>
    b->valid = 1;
    80002070:	4785                	li	a5,1
    80002072:	c09c                	sw	a5,0(s1)
  return b;
    80002074:	b7d5                	j	80002058 <bread+0xb8>

0000000080002076 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002076:	1101                	addi	sp,sp,-32
    80002078:	ec06                	sd	ra,24(sp)
    8000207a:	e822                	sd	s0,16(sp)
    8000207c:	e426                	sd	s1,8(sp)
    8000207e:	1000                	addi	s0,sp,32
    80002080:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002082:	0541                	addi	a0,a0,16
    80002084:	2cc010ef          	jal	80003350 <holdingsleep>
    80002088:	c911                	beqz	a0,8000209c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000208a:	4585                	li	a1,1
    8000208c:	8526                	mv	a0,s1
    8000208e:	2a3020ef          	jal	80004b30 <virtio_disk_rw>
}
    80002092:	60e2                	ld	ra,24(sp)
    80002094:	6442                	ld	s0,16(sp)
    80002096:	64a2                	ld	s1,8(sp)
    80002098:	6105                	addi	sp,sp,32
    8000209a:	8082                	ret
    panic("bwrite");
    8000209c:	00005517          	auipc	a0,0x5
    800020a0:	2bc50513          	addi	a0,a0,700 # 80007358 <etext+0x358>
    800020a4:	50a030ef          	jal	800055ae <panic>

00000000800020a8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	e426                	sd	s1,8(sp)
    800020b0:	e04a                	sd	s2,0(sp)
    800020b2:	1000                	addi	s0,sp,32
    800020b4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020b6:	01050913          	addi	s2,a0,16
    800020ba:	854a                	mv	a0,s2
    800020bc:	294010ef          	jal	80003350 <holdingsleep>
    800020c0:	c135                	beqz	a0,80002124 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800020c2:	854a                	mv	a0,s2
    800020c4:	254010ef          	jal	80003318 <releasesleep>

  acquire(&bcache.lock);
    800020c8:	0000e517          	auipc	a0,0xe
    800020cc:	f4050513          	addi	a0,a0,-192 # 80010008 <bcache>
    800020d0:	79a030ef          	jal	8000586a <acquire>
  b->refcnt--;
    800020d4:	40bc                	lw	a5,64(s1)
    800020d6:	37fd                	addiw	a5,a5,-1
    800020d8:	0007871b          	sext.w	a4,a5
    800020dc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800020de:	e71d                	bnez	a4,8000210c <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800020e0:	68b8                	ld	a4,80(s1)
    800020e2:	64bc                	ld	a5,72(s1)
    800020e4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800020e6:	68b8                	ld	a4,80(s1)
    800020e8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800020ea:	00016797          	auipc	a5,0x16
    800020ee:	f1e78793          	addi	a5,a5,-226 # 80018008 <bcache+0x8000>
    800020f2:	2b87b703          	ld	a4,696(a5)
    800020f6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800020f8:	00016717          	auipc	a4,0x16
    800020fc:	17870713          	addi	a4,a4,376 # 80018270 <bcache+0x8268>
    80002100:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002102:	2b87b703          	ld	a4,696(a5)
    80002106:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002108:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000210c:	0000e517          	auipc	a0,0xe
    80002110:	efc50513          	addi	a0,a0,-260 # 80010008 <bcache>
    80002114:	7ee030ef          	jal	80005902 <release>
}
    80002118:	60e2                	ld	ra,24(sp)
    8000211a:	6442                	ld	s0,16(sp)
    8000211c:	64a2                	ld	s1,8(sp)
    8000211e:	6902                	ld	s2,0(sp)
    80002120:	6105                	addi	sp,sp,32
    80002122:	8082                	ret
    panic("brelse");
    80002124:	00005517          	auipc	a0,0x5
    80002128:	23c50513          	addi	a0,a0,572 # 80007360 <etext+0x360>
    8000212c:	482030ef          	jal	800055ae <panic>

0000000080002130 <bpin>:

void
bpin(struct buf *b) {
    80002130:	1101                	addi	sp,sp,-32
    80002132:	ec06                	sd	ra,24(sp)
    80002134:	e822                	sd	s0,16(sp)
    80002136:	e426                	sd	s1,8(sp)
    80002138:	1000                	addi	s0,sp,32
    8000213a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000213c:	0000e517          	auipc	a0,0xe
    80002140:	ecc50513          	addi	a0,a0,-308 # 80010008 <bcache>
    80002144:	726030ef          	jal	8000586a <acquire>
  b->refcnt++;
    80002148:	40bc                	lw	a5,64(s1)
    8000214a:	2785                	addiw	a5,a5,1
    8000214c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000214e:	0000e517          	auipc	a0,0xe
    80002152:	eba50513          	addi	a0,a0,-326 # 80010008 <bcache>
    80002156:	7ac030ef          	jal	80005902 <release>
}
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	64a2                	ld	s1,8(sp)
    80002160:	6105                	addi	sp,sp,32
    80002162:	8082                	ret

0000000080002164 <bunpin>:

void
bunpin(struct buf *b) {
    80002164:	1101                	addi	sp,sp,-32
    80002166:	ec06                	sd	ra,24(sp)
    80002168:	e822                	sd	s0,16(sp)
    8000216a:	e426                	sd	s1,8(sp)
    8000216c:	1000                	addi	s0,sp,32
    8000216e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002170:	0000e517          	auipc	a0,0xe
    80002174:	e9850513          	addi	a0,a0,-360 # 80010008 <bcache>
    80002178:	6f2030ef          	jal	8000586a <acquire>
  b->refcnt--;
    8000217c:	40bc                	lw	a5,64(s1)
    8000217e:	37fd                	addiw	a5,a5,-1
    80002180:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002182:	0000e517          	auipc	a0,0xe
    80002186:	e8650513          	addi	a0,a0,-378 # 80010008 <bcache>
    8000218a:	778030ef          	jal	80005902 <release>
}
    8000218e:	60e2                	ld	ra,24(sp)
    80002190:	6442                	ld	s0,16(sp)
    80002192:	64a2                	ld	s1,8(sp)
    80002194:	6105                	addi	sp,sp,32
    80002196:	8082                	ret

0000000080002198 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002198:	1101                	addi	sp,sp,-32
    8000219a:	ec06                	sd	ra,24(sp)
    8000219c:	e822                	sd	s0,16(sp)
    8000219e:	e426                	sd	s1,8(sp)
    800021a0:	e04a                	sd	s2,0(sp)
    800021a2:	1000                	addi	s0,sp,32
    800021a4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021a6:	00d5d59b          	srliw	a1,a1,0xd
    800021aa:	00016797          	auipc	a5,0x16
    800021ae:	53a7a783          	lw	a5,1338(a5) # 800186e4 <sb+0x1c>
    800021b2:	9dbd                	addw	a1,a1,a5
    800021b4:	dedff0ef          	jal	80001fa0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800021b8:	0074f713          	andi	a4,s1,7
    800021bc:	4785                	li	a5,1
    800021be:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800021c2:	14ce                	slli	s1,s1,0x33
    800021c4:	90d9                	srli	s1,s1,0x36
    800021c6:	00950733          	add	a4,a0,s1
    800021ca:	05874703          	lbu	a4,88(a4)
    800021ce:	00e7f6b3          	and	a3,a5,a4
    800021d2:	c29d                	beqz	a3,800021f8 <bfree+0x60>
    800021d4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800021d6:	94aa                	add	s1,s1,a0
    800021d8:	fff7c793          	not	a5,a5
    800021dc:	8f7d                	and	a4,a4,a5
    800021de:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800021e2:	7f9000ef          	jal	800031da <log_write>
  brelse(bp);
    800021e6:	854a                	mv	a0,s2
    800021e8:	ec1ff0ef          	jal	800020a8 <brelse>
}
    800021ec:	60e2                	ld	ra,24(sp)
    800021ee:	6442                	ld	s0,16(sp)
    800021f0:	64a2                	ld	s1,8(sp)
    800021f2:	6902                	ld	s2,0(sp)
    800021f4:	6105                	addi	sp,sp,32
    800021f6:	8082                	ret
    panic("freeing free block");
    800021f8:	00005517          	auipc	a0,0x5
    800021fc:	17050513          	addi	a0,a0,368 # 80007368 <etext+0x368>
    80002200:	3ae030ef          	jal	800055ae <panic>

0000000080002204 <balloc>:
{
    80002204:	711d                	addi	sp,sp,-96
    80002206:	ec86                	sd	ra,88(sp)
    80002208:	e8a2                	sd	s0,80(sp)
    8000220a:	e4a6                	sd	s1,72(sp)
    8000220c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000220e:	00016797          	auipc	a5,0x16
    80002212:	4be7a783          	lw	a5,1214(a5) # 800186cc <sb+0x4>
    80002216:	0e078f63          	beqz	a5,80002314 <balloc+0x110>
    8000221a:	e0ca                	sd	s2,64(sp)
    8000221c:	fc4e                	sd	s3,56(sp)
    8000221e:	f852                	sd	s4,48(sp)
    80002220:	f456                	sd	s5,40(sp)
    80002222:	f05a                	sd	s6,32(sp)
    80002224:	ec5e                	sd	s7,24(sp)
    80002226:	e862                	sd	s8,16(sp)
    80002228:	e466                	sd	s9,8(sp)
    8000222a:	8baa                	mv	s7,a0
    8000222c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000222e:	00016b17          	auipc	s6,0x16
    80002232:	49ab0b13          	addi	s6,s6,1178 # 800186c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002236:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002238:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000223a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000223c:	6c89                	lui	s9,0x2
    8000223e:	a0b5                	j	800022aa <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002240:	97ca                	add	a5,a5,s2
    80002242:	8e55                	or	a2,a2,a3
    80002244:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002248:	854a                	mv	a0,s2
    8000224a:	791000ef          	jal	800031da <log_write>
        brelse(bp);
    8000224e:	854a                	mv	a0,s2
    80002250:	e59ff0ef          	jal	800020a8 <brelse>
  bp = bread(dev, bno);
    80002254:	85a6                	mv	a1,s1
    80002256:	855e                	mv	a0,s7
    80002258:	d49ff0ef          	jal	80001fa0 <bread>
    8000225c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000225e:	40000613          	li	a2,1024
    80002262:	4581                	li	a1,0
    80002264:	05850513          	addi	a0,a0,88
    80002268:	ee7fd0ef          	jal	8000014e <memset>
  log_write(bp);
    8000226c:	854a                	mv	a0,s2
    8000226e:	76d000ef          	jal	800031da <log_write>
  brelse(bp);
    80002272:	854a                	mv	a0,s2
    80002274:	e35ff0ef          	jal	800020a8 <brelse>
}
    80002278:	6906                	ld	s2,64(sp)
    8000227a:	79e2                	ld	s3,56(sp)
    8000227c:	7a42                	ld	s4,48(sp)
    8000227e:	7aa2                	ld	s5,40(sp)
    80002280:	7b02                	ld	s6,32(sp)
    80002282:	6be2                	ld	s7,24(sp)
    80002284:	6c42                	ld	s8,16(sp)
    80002286:	6ca2                	ld	s9,8(sp)
}
    80002288:	8526                	mv	a0,s1
    8000228a:	60e6                	ld	ra,88(sp)
    8000228c:	6446                	ld	s0,80(sp)
    8000228e:	64a6                	ld	s1,72(sp)
    80002290:	6125                	addi	sp,sp,96
    80002292:	8082                	ret
    brelse(bp);
    80002294:	854a                	mv	a0,s2
    80002296:	e13ff0ef          	jal	800020a8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000229a:	015c87bb          	addw	a5,s9,s5
    8000229e:	00078a9b          	sext.w	s5,a5
    800022a2:	004b2703          	lw	a4,4(s6)
    800022a6:	04eaff63          	bgeu	s5,a4,80002304 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800022aa:	41fad79b          	sraiw	a5,s5,0x1f
    800022ae:	0137d79b          	srliw	a5,a5,0x13
    800022b2:	015787bb          	addw	a5,a5,s5
    800022b6:	40d7d79b          	sraiw	a5,a5,0xd
    800022ba:	01cb2583          	lw	a1,28(s6)
    800022be:	9dbd                	addw	a1,a1,a5
    800022c0:	855e                	mv	a0,s7
    800022c2:	cdfff0ef          	jal	80001fa0 <bread>
    800022c6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022c8:	004b2503          	lw	a0,4(s6)
    800022cc:	000a849b          	sext.w	s1,s5
    800022d0:	8762                	mv	a4,s8
    800022d2:	fca4f1e3          	bgeu	s1,a0,80002294 <balloc+0x90>
      m = 1 << (bi % 8);
    800022d6:	00777693          	andi	a3,a4,7
    800022da:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800022de:	41f7579b          	sraiw	a5,a4,0x1f
    800022e2:	01d7d79b          	srliw	a5,a5,0x1d
    800022e6:	9fb9                	addw	a5,a5,a4
    800022e8:	4037d79b          	sraiw	a5,a5,0x3
    800022ec:	00f90633          	add	a2,s2,a5
    800022f0:	05864603          	lbu	a2,88(a2)
    800022f4:	00c6f5b3          	and	a1,a3,a2
    800022f8:	d5a1                	beqz	a1,80002240 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022fa:	2705                	addiw	a4,a4,1
    800022fc:	2485                	addiw	s1,s1,1
    800022fe:	fd471ae3          	bne	a4,s4,800022d2 <balloc+0xce>
    80002302:	bf49                	j	80002294 <balloc+0x90>
    80002304:	6906                	ld	s2,64(sp)
    80002306:	79e2                	ld	s3,56(sp)
    80002308:	7a42                	ld	s4,48(sp)
    8000230a:	7aa2                	ld	s5,40(sp)
    8000230c:	7b02                	ld	s6,32(sp)
    8000230e:	6be2                	ld	s7,24(sp)
    80002310:	6c42                	ld	s8,16(sp)
    80002312:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002314:	00005517          	auipc	a0,0x5
    80002318:	06c50513          	addi	a0,a0,108 # 80007380 <etext+0x380>
    8000231c:	7ad020ef          	jal	800052c8 <printf>
  return 0;
    80002320:	4481                	li	s1,0
    80002322:	b79d                	j	80002288 <balloc+0x84>

0000000080002324 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002324:	7179                	addi	sp,sp,-48
    80002326:	f406                	sd	ra,40(sp)
    80002328:	f022                	sd	s0,32(sp)
    8000232a:	ec26                	sd	s1,24(sp)
    8000232c:	e84a                	sd	s2,16(sp)
    8000232e:	e44e                	sd	s3,8(sp)
    80002330:	1800                	addi	s0,sp,48
    80002332:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002334:	47ad                	li	a5,11
    80002336:	02b7e663          	bltu	a5,a1,80002362 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000233a:	02059793          	slli	a5,a1,0x20
    8000233e:	01e7d593          	srli	a1,a5,0x1e
    80002342:	00b504b3          	add	s1,a0,a1
    80002346:	0504a903          	lw	s2,80(s1)
    8000234a:	06091a63          	bnez	s2,800023be <bmap+0x9a>
      addr = balloc(ip->dev);
    8000234e:	4108                	lw	a0,0(a0)
    80002350:	eb5ff0ef          	jal	80002204 <balloc>
    80002354:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002358:	06090363          	beqz	s2,800023be <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000235c:	0524a823          	sw	s2,80(s1)
    80002360:	a8b9                	j	800023be <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002362:	ff45849b          	addiw	s1,a1,-12
    80002366:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000236a:	0ff00793          	li	a5,255
    8000236e:	06e7ee63          	bltu	a5,a4,800023ea <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002372:	08052903          	lw	s2,128(a0)
    80002376:	00091d63          	bnez	s2,80002390 <bmap+0x6c>
      addr = balloc(ip->dev);
    8000237a:	4108                	lw	a0,0(a0)
    8000237c:	e89ff0ef          	jal	80002204 <balloc>
    80002380:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002384:	02090d63          	beqz	s2,800023be <bmap+0x9a>
    80002388:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000238a:	0929a023          	sw	s2,128(s3)
    8000238e:	a011                	j	80002392 <bmap+0x6e>
    80002390:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002392:	85ca                	mv	a1,s2
    80002394:	0009a503          	lw	a0,0(s3)
    80002398:	c09ff0ef          	jal	80001fa0 <bread>
    8000239c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000239e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023a2:	02049713          	slli	a4,s1,0x20
    800023a6:	01e75593          	srli	a1,a4,0x1e
    800023aa:	00b784b3          	add	s1,a5,a1
    800023ae:	0004a903          	lw	s2,0(s1)
    800023b2:	00090e63          	beqz	s2,800023ce <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800023b6:	8552                	mv	a0,s4
    800023b8:	cf1ff0ef          	jal	800020a8 <brelse>
    return addr;
    800023bc:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800023be:	854a                	mv	a0,s2
    800023c0:	70a2                	ld	ra,40(sp)
    800023c2:	7402                	ld	s0,32(sp)
    800023c4:	64e2                	ld	s1,24(sp)
    800023c6:	6942                	ld	s2,16(sp)
    800023c8:	69a2                	ld	s3,8(sp)
    800023ca:	6145                	addi	sp,sp,48
    800023cc:	8082                	ret
      addr = balloc(ip->dev);
    800023ce:	0009a503          	lw	a0,0(s3)
    800023d2:	e33ff0ef          	jal	80002204 <balloc>
    800023d6:	0005091b          	sext.w	s2,a0
      if(addr){
    800023da:	fc090ee3          	beqz	s2,800023b6 <bmap+0x92>
        a[bn] = addr;
    800023de:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800023e2:	8552                	mv	a0,s4
    800023e4:	5f7000ef          	jal	800031da <log_write>
    800023e8:	b7f9                	j	800023b6 <bmap+0x92>
    800023ea:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800023ec:	00005517          	auipc	a0,0x5
    800023f0:	fac50513          	addi	a0,a0,-84 # 80007398 <etext+0x398>
    800023f4:	1ba030ef          	jal	800055ae <panic>

00000000800023f8 <iget>:
{
    800023f8:	7179                	addi	sp,sp,-48
    800023fa:	f406                	sd	ra,40(sp)
    800023fc:	f022                	sd	s0,32(sp)
    800023fe:	ec26                	sd	s1,24(sp)
    80002400:	e84a                	sd	s2,16(sp)
    80002402:	e44e                	sd	s3,8(sp)
    80002404:	e052                	sd	s4,0(sp)
    80002406:	1800                	addi	s0,sp,48
    80002408:	89aa                	mv	s3,a0
    8000240a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000240c:	00016517          	auipc	a0,0x16
    80002410:	2dc50513          	addi	a0,a0,732 # 800186e8 <itable>
    80002414:	456030ef          	jal	8000586a <acquire>
  empty = 0;
    80002418:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000241a:	00016497          	auipc	s1,0x16
    8000241e:	2e648493          	addi	s1,s1,742 # 80018700 <itable+0x18>
    80002422:	00018697          	auipc	a3,0x18
    80002426:	d6e68693          	addi	a3,a3,-658 # 8001a190 <log>
    8000242a:	a039                	j	80002438 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000242c:	02090963          	beqz	s2,8000245e <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002430:	08848493          	addi	s1,s1,136
    80002434:	02d48863          	beq	s1,a3,80002464 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002438:	449c                	lw	a5,8(s1)
    8000243a:	fef059e3          	blez	a5,8000242c <iget+0x34>
    8000243e:	4098                	lw	a4,0(s1)
    80002440:	ff3716e3          	bne	a4,s3,8000242c <iget+0x34>
    80002444:	40d8                	lw	a4,4(s1)
    80002446:	ff4713e3          	bne	a4,s4,8000242c <iget+0x34>
      ip->ref++;
    8000244a:	2785                	addiw	a5,a5,1
    8000244c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000244e:	00016517          	auipc	a0,0x16
    80002452:	29a50513          	addi	a0,a0,666 # 800186e8 <itable>
    80002456:	4ac030ef          	jal	80005902 <release>
      return ip;
    8000245a:	8926                	mv	s2,s1
    8000245c:	a02d                	j	80002486 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000245e:	fbe9                	bnez	a5,80002430 <iget+0x38>
      empty = ip;
    80002460:	8926                	mv	s2,s1
    80002462:	b7f9                	j	80002430 <iget+0x38>
  if(empty == 0)
    80002464:	02090a63          	beqz	s2,80002498 <iget+0xa0>
  ip->dev = dev;
    80002468:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000246c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002470:	4785                	li	a5,1
    80002472:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002476:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000247a:	00016517          	auipc	a0,0x16
    8000247e:	26e50513          	addi	a0,a0,622 # 800186e8 <itable>
    80002482:	480030ef          	jal	80005902 <release>
}
    80002486:	854a                	mv	a0,s2
    80002488:	70a2                	ld	ra,40(sp)
    8000248a:	7402                	ld	s0,32(sp)
    8000248c:	64e2                	ld	s1,24(sp)
    8000248e:	6942                	ld	s2,16(sp)
    80002490:	69a2                	ld	s3,8(sp)
    80002492:	6a02                	ld	s4,0(sp)
    80002494:	6145                	addi	sp,sp,48
    80002496:	8082                	ret
    panic("iget: no inodes");
    80002498:	00005517          	auipc	a0,0x5
    8000249c:	f1850513          	addi	a0,a0,-232 # 800073b0 <etext+0x3b0>
    800024a0:	10e030ef          	jal	800055ae <panic>

00000000800024a4 <iinit>:
{
    800024a4:	7179                	addi	sp,sp,-48
    800024a6:	f406                	sd	ra,40(sp)
    800024a8:	f022                	sd	s0,32(sp)
    800024aa:	ec26                	sd	s1,24(sp)
    800024ac:	e84a                	sd	s2,16(sp)
    800024ae:	e44e                	sd	s3,8(sp)
    800024b0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800024b2:	00005597          	auipc	a1,0x5
    800024b6:	f0e58593          	addi	a1,a1,-242 # 800073c0 <etext+0x3c0>
    800024ba:	00016517          	auipc	a0,0x16
    800024be:	22e50513          	addi	a0,a0,558 # 800186e8 <itable>
    800024c2:	328030ef          	jal	800057ea <initlock>
  for(i = 0; i < NINODE; i++) {
    800024c6:	00016497          	auipc	s1,0x16
    800024ca:	24a48493          	addi	s1,s1,586 # 80018710 <itable+0x28>
    800024ce:	00018997          	auipc	s3,0x18
    800024d2:	cd298993          	addi	s3,s3,-814 # 8001a1a0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800024d6:	00005917          	auipc	s2,0x5
    800024da:	ef290913          	addi	s2,s2,-270 # 800073c8 <etext+0x3c8>
    800024de:	85ca                	mv	a1,s2
    800024e0:	8526                	mv	a0,s1
    800024e2:	5bb000ef          	jal	8000329c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800024e6:	08848493          	addi	s1,s1,136
    800024ea:	ff349ae3          	bne	s1,s3,800024de <iinit+0x3a>
}
    800024ee:	70a2                	ld	ra,40(sp)
    800024f0:	7402                	ld	s0,32(sp)
    800024f2:	64e2                	ld	s1,24(sp)
    800024f4:	6942                	ld	s2,16(sp)
    800024f6:	69a2                	ld	s3,8(sp)
    800024f8:	6145                	addi	sp,sp,48
    800024fa:	8082                	ret

00000000800024fc <ialloc>:
{
    800024fc:	7139                	addi	sp,sp,-64
    800024fe:	fc06                	sd	ra,56(sp)
    80002500:	f822                	sd	s0,48(sp)
    80002502:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002504:	00016717          	auipc	a4,0x16
    80002508:	1d072703          	lw	a4,464(a4) # 800186d4 <sb+0xc>
    8000250c:	4785                	li	a5,1
    8000250e:	06e7f063          	bgeu	a5,a4,8000256e <ialloc+0x72>
    80002512:	f426                	sd	s1,40(sp)
    80002514:	f04a                	sd	s2,32(sp)
    80002516:	ec4e                	sd	s3,24(sp)
    80002518:	e852                	sd	s4,16(sp)
    8000251a:	e456                	sd	s5,8(sp)
    8000251c:	e05a                	sd	s6,0(sp)
    8000251e:	8aaa                	mv	s5,a0
    80002520:	8b2e                	mv	s6,a1
    80002522:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002524:	00016a17          	auipc	s4,0x16
    80002528:	1a4a0a13          	addi	s4,s4,420 # 800186c8 <sb>
    8000252c:	00495593          	srli	a1,s2,0x4
    80002530:	018a2783          	lw	a5,24(s4)
    80002534:	9dbd                	addw	a1,a1,a5
    80002536:	8556                	mv	a0,s5
    80002538:	a69ff0ef          	jal	80001fa0 <bread>
    8000253c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000253e:	05850993          	addi	s3,a0,88
    80002542:	00f97793          	andi	a5,s2,15
    80002546:	079a                	slli	a5,a5,0x6
    80002548:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000254a:	00099783          	lh	a5,0(s3)
    8000254e:	cb9d                	beqz	a5,80002584 <ialloc+0x88>
    brelse(bp);
    80002550:	b59ff0ef          	jal	800020a8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002554:	0905                	addi	s2,s2,1
    80002556:	00ca2703          	lw	a4,12(s4)
    8000255a:	0009079b          	sext.w	a5,s2
    8000255e:	fce7e7e3          	bltu	a5,a4,8000252c <ialloc+0x30>
    80002562:	74a2                	ld	s1,40(sp)
    80002564:	7902                	ld	s2,32(sp)
    80002566:	69e2                	ld	s3,24(sp)
    80002568:	6a42                	ld	s4,16(sp)
    8000256a:	6aa2                	ld	s5,8(sp)
    8000256c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000256e:	00005517          	auipc	a0,0x5
    80002572:	e6250513          	addi	a0,a0,-414 # 800073d0 <etext+0x3d0>
    80002576:	553020ef          	jal	800052c8 <printf>
  return 0;
    8000257a:	4501                	li	a0,0
}
    8000257c:	70e2                	ld	ra,56(sp)
    8000257e:	7442                	ld	s0,48(sp)
    80002580:	6121                	addi	sp,sp,64
    80002582:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002584:	04000613          	li	a2,64
    80002588:	4581                	li	a1,0
    8000258a:	854e                	mv	a0,s3
    8000258c:	bc3fd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002590:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002594:	8526                	mv	a0,s1
    80002596:	445000ef          	jal	800031da <log_write>
      brelse(bp);
    8000259a:	8526                	mv	a0,s1
    8000259c:	b0dff0ef          	jal	800020a8 <brelse>
      return iget(dev, inum);
    800025a0:	0009059b          	sext.w	a1,s2
    800025a4:	8556                	mv	a0,s5
    800025a6:	e53ff0ef          	jal	800023f8 <iget>
    800025aa:	74a2                	ld	s1,40(sp)
    800025ac:	7902                	ld	s2,32(sp)
    800025ae:	69e2                	ld	s3,24(sp)
    800025b0:	6a42                	ld	s4,16(sp)
    800025b2:	6aa2                	ld	s5,8(sp)
    800025b4:	6b02                	ld	s6,0(sp)
    800025b6:	b7d9                	j	8000257c <ialloc+0x80>

00000000800025b8 <iupdate>:
{
    800025b8:	1101                	addi	sp,sp,-32
    800025ba:	ec06                	sd	ra,24(sp)
    800025bc:	e822                	sd	s0,16(sp)
    800025be:	e426                	sd	s1,8(sp)
    800025c0:	e04a                	sd	s2,0(sp)
    800025c2:	1000                	addi	s0,sp,32
    800025c4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800025c6:	415c                	lw	a5,4(a0)
    800025c8:	0047d79b          	srliw	a5,a5,0x4
    800025cc:	00016597          	auipc	a1,0x16
    800025d0:	1145a583          	lw	a1,276(a1) # 800186e0 <sb+0x18>
    800025d4:	9dbd                	addw	a1,a1,a5
    800025d6:	4108                	lw	a0,0(a0)
    800025d8:	9c9ff0ef          	jal	80001fa0 <bread>
    800025dc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800025de:	05850793          	addi	a5,a0,88
    800025e2:	40d8                	lw	a4,4(s1)
    800025e4:	8b3d                	andi	a4,a4,15
    800025e6:	071a                	slli	a4,a4,0x6
    800025e8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800025ea:	04449703          	lh	a4,68(s1)
    800025ee:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800025f2:	04649703          	lh	a4,70(s1)
    800025f6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800025fa:	04849703          	lh	a4,72(s1)
    800025fe:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002602:	04a49703          	lh	a4,74(s1)
    80002606:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000260a:	44f8                	lw	a4,76(s1)
    8000260c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000260e:	03400613          	li	a2,52
    80002612:	05048593          	addi	a1,s1,80
    80002616:	00c78513          	addi	a0,a5,12
    8000261a:	b91fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    8000261e:	854a                	mv	a0,s2
    80002620:	3bb000ef          	jal	800031da <log_write>
  brelse(bp);
    80002624:	854a                	mv	a0,s2
    80002626:	a83ff0ef          	jal	800020a8 <brelse>
}
    8000262a:	60e2                	ld	ra,24(sp)
    8000262c:	6442                	ld	s0,16(sp)
    8000262e:	64a2                	ld	s1,8(sp)
    80002630:	6902                	ld	s2,0(sp)
    80002632:	6105                	addi	sp,sp,32
    80002634:	8082                	ret

0000000080002636 <idup>:
{
    80002636:	1101                	addi	sp,sp,-32
    80002638:	ec06                	sd	ra,24(sp)
    8000263a:	e822                	sd	s0,16(sp)
    8000263c:	e426                	sd	s1,8(sp)
    8000263e:	1000                	addi	s0,sp,32
    80002640:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002642:	00016517          	auipc	a0,0x16
    80002646:	0a650513          	addi	a0,a0,166 # 800186e8 <itable>
    8000264a:	220030ef          	jal	8000586a <acquire>
  ip->ref++;
    8000264e:	449c                	lw	a5,8(s1)
    80002650:	2785                	addiw	a5,a5,1
    80002652:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002654:	00016517          	auipc	a0,0x16
    80002658:	09450513          	addi	a0,a0,148 # 800186e8 <itable>
    8000265c:	2a6030ef          	jal	80005902 <release>
}
    80002660:	8526                	mv	a0,s1
    80002662:	60e2                	ld	ra,24(sp)
    80002664:	6442                	ld	s0,16(sp)
    80002666:	64a2                	ld	s1,8(sp)
    80002668:	6105                	addi	sp,sp,32
    8000266a:	8082                	ret

000000008000266c <ilock>:
{
    8000266c:	1101                	addi	sp,sp,-32
    8000266e:	ec06                	sd	ra,24(sp)
    80002670:	e822                	sd	s0,16(sp)
    80002672:	e426                	sd	s1,8(sp)
    80002674:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002676:	cd19                	beqz	a0,80002694 <ilock+0x28>
    80002678:	84aa                	mv	s1,a0
    8000267a:	451c                	lw	a5,8(a0)
    8000267c:	00f05c63          	blez	a5,80002694 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002680:	0541                	addi	a0,a0,16
    80002682:	451000ef          	jal	800032d2 <acquiresleep>
  if(ip->valid == 0){
    80002686:	40bc                	lw	a5,64(s1)
    80002688:	cf89                	beqz	a5,800026a2 <ilock+0x36>
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6105                	addi	sp,sp,32
    80002692:	8082                	ret
    80002694:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002696:	00005517          	auipc	a0,0x5
    8000269a:	d5250513          	addi	a0,a0,-686 # 800073e8 <etext+0x3e8>
    8000269e:	711020ef          	jal	800055ae <panic>
    800026a2:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026a4:	40dc                	lw	a5,4(s1)
    800026a6:	0047d79b          	srliw	a5,a5,0x4
    800026aa:	00016597          	auipc	a1,0x16
    800026ae:	0365a583          	lw	a1,54(a1) # 800186e0 <sb+0x18>
    800026b2:	9dbd                	addw	a1,a1,a5
    800026b4:	4088                	lw	a0,0(s1)
    800026b6:	8ebff0ef          	jal	80001fa0 <bread>
    800026ba:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026bc:	05850593          	addi	a1,a0,88
    800026c0:	40dc                	lw	a5,4(s1)
    800026c2:	8bbd                	andi	a5,a5,15
    800026c4:	079a                	slli	a5,a5,0x6
    800026c6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800026c8:	00059783          	lh	a5,0(a1)
    800026cc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800026d0:	00259783          	lh	a5,2(a1)
    800026d4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800026d8:	00459783          	lh	a5,4(a1)
    800026dc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800026e0:	00659783          	lh	a5,6(a1)
    800026e4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800026e8:	459c                	lw	a5,8(a1)
    800026ea:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800026ec:	03400613          	li	a2,52
    800026f0:	05b1                	addi	a1,a1,12
    800026f2:	05048513          	addi	a0,s1,80
    800026f6:	ab5fd0ef          	jal	800001aa <memmove>
    brelse(bp);
    800026fa:	854a                	mv	a0,s2
    800026fc:	9adff0ef          	jal	800020a8 <brelse>
    ip->valid = 1;
    80002700:	4785                	li	a5,1
    80002702:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002704:	04449783          	lh	a5,68(s1)
    80002708:	c399                	beqz	a5,8000270e <ilock+0xa2>
    8000270a:	6902                	ld	s2,0(sp)
    8000270c:	bfbd                	j	8000268a <ilock+0x1e>
      panic("ilock: no type");
    8000270e:	00005517          	auipc	a0,0x5
    80002712:	ce250513          	addi	a0,a0,-798 # 800073f0 <etext+0x3f0>
    80002716:	699020ef          	jal	800055ae <panic>

000000008000271a <iunlock>:
{
    8000271a:	1101                	addi	sp,sp,-32
    8000271c:	ec06                	sd	ra,24(sp)
    8000271e:	e822                	sd	s0,16(sp)
    80002720:	e426                	sd	s1,8(sp)
    80002722:	e04a                	sd	s2,0(sp)
    80002724:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002726:	c505                	beqz	a0,8000274e <iunlock+0x34>
    80002728:	84aa                	mv	s1,a0
    8000272a:	01050913          	addi	s2,a0,16
    8000272e:	854a                	mv	a0,s2
    80002730:	421000ef          	jal	80003350 <holdingsleep>
    80002734:	cd09                	beqz	a0,8000274e <iunlock+0x34>
    80002736:	449c                	lw	a5,8(s1)
    80002738:	00f05b63          	blez	a5,8000274e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000273c:	854a                	mv	a0,s2
    8000273e:	3db000ef          	jal	80003318 <releasesleep>
}
    80002742:	60e2                	ld	ra,24(sp)
    80002744:	6442                	ld	s0,16(sp)
    80002746:	64a2                	ld	s1,8(sp)
    80002748:	6902                	ld	s2,0(sp)
    8000274a:	6105                	addi	sp,sp,32
    8000274c:	8082                	ret
    panic("iunlock");
    8000274e:	00005517          	auipc	a0,0x5
    80002752:	cb250513          	addi	a0,a0,-846 # 80007400 <etext+0x400>
    80002756:	659020ef          	jal	800055ae <panic>

000000008000275a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000275a:	7179                	addi	sp,sp,-48
    8000275c:	f406                	sd	ra,40(sp)
    8000275e:	f022                	sd	s0,32(sp)
    80002760:	ec26                	sd	s1,24(sp)
    80002762:	e84a                	sd	s2,16(sp)
    80002764:	e44e                	sd	s3,8(sp)
    80002766:	1800                	addi	s0,sp,48
    80002768:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000276a:	05050493          	addi	s1,a0,80
    8000276e:	08050913          	addi	s2,a0,128
    80002772:	a021                	j	8000277a <itrunc+0x20>
    80002774:	0491                	addi	s1,s1,4
    80002776:	01248b63          	beq	s1,s2,8000278c <itrunc+0x32>
    if(ip->addrs[i]){
    8000277a:	408c                	lw	a1,0(s1)
    8000277c:	dde5                	beqz	a1,80002774 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000277e:	0009a503          	lw	a0,0(s3)
    80002782:	a17ff0ef          	jal	80002198 <bfree>
      ip->addrs[i] = 0;
    80002786:	0004a023          	sw	zero,0(s1)
    8000278a:	b7ed                	j	80002774 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000278c:	0809a583          	lw	a1,128(s3)
    80002790:	ed89                	bnez	a1,800027aa <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002792:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002796:	854e                	mv	a0,s3
    80002798:	e21ff0ef          	jal	800025b8 <iupdate>
}
    8000279c:	70a2                	ld	ra,40(sp)
    8000279e:	7402                	ld	s0,32(sp)
    800027a0:	64e2                	ld	s1,24(sp)
    800027a2:	6942                	ld	s2,16(sp)
    800027a4:	69a2                	ld	s3,8(sp)
    800027a6:	6145                	addi	sp,sp,48
    800027a8:	8082                	ret
    800027aa:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800027ac:	0009a503          	lw	a0,0(s3)
    800027b0:	ff0ff0ef          	jal	80001fa0 <bread>
    800027b4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800027b6:	05850493          	addi	s1,a0,88
    800027ba:	45850913          	addi	s2,a0,1112
    800027be:	a021                	j	800027c6 <itrunc+0x6c>
    800027c0:	0491                	addi	s1,s1,4
    800027c2:	01248963          	beq	s1,s2,800027d4 <itrunc+0x7a>
      if(a[j])
    800027c6:	408c                	lw	a1,0(s1)
    800027c8:	dde5                	beqz	a1,800027c0 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800027ca:	0009a503          	lw	a0,0(s3)
    800027ce:	9cbff0ef          	jal	80002198 <bfree>
    800027d2:	b7fd                	j	800027c0 <itrunc+0x66>
    brelse(bp);
    800027d4:	8552                	mv	a0,s4
    800027d6:	8d3ff0ef          	jal	800020a8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800027da:	0809a583          	lw	a1,128(s3)
    800027de:	0009a503          	lw	a0,0(s3)
    800027e2:	9b7ff0ef          	jal	80002198 <bfree>
    ip->addrs[NDIRECT] = 0;
    800027e6:	0809a023          	sw	zero,128(s3)
    800027ea:	6a02                	ld	s4,0(sp)
    800027ec:	b75d                	j	80002792 <itrunc+0x38>

00000000800027ee <iput>:
{
    800027ee:	1101                	addi	sp,sp,-32
    800027f0:	ec06                	sd	ra,24(sp)
    800027f2:	e822                	sd	s0,16(sp)
    800027f4:	e426                	sd	s1,8(sp)
    800027f6:	1000                	addi	s0,sp,32
    800027f8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027fa:	00016517          	auipc	a0,0x16
    800027fe:	eee50513          	addi	a0,a0,-274 # 800186e8 <itable>
    80002802:	068030ef          	jal	8000586a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002806:	4498                	lw	a4,8(s1)
    80002808:	4785                	li	a5,1
    8000280a:	02f70063          	beq	a4,a5,8000282a <iput+0x3c>
  ip->ref--;
    8000280e:	449c                	lw	a5,8(s1)
    80002810:	37fd                	addiw	a5,a5,-1
    80002812:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002814:	00016517          	auipc	a0,0x16
    80002818:	ed450513          	addi	a0,a0,-300 # 800186e8 <itable>
    8000281c:	0e6030ef          	jal	80005902 <release>
}
    80002820:	60e2                	ld	ra,24(sp)
    80002822:	6442                	ld	s0,16(sp)
    80002824:	64a2                	ld	s1,8(sp)
    80002826:	6105                	addi	sp,sp,32
    80002828:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000282a:	40bc                	lw	a5,64(s1)
    8000282c:	d3ed                	beqz	a5,8000280e <iput+0x20>
    8000282e:	04a49783          	lh	a5,74(s1)
    80002832:	fff1                	bnez	a5,8000280e <iput+0x20>
    80002834:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002836:	01048913          	addi	s2,s1,16
    8000283a:	854a                	mv	a0,s2
    8000283c:	297000ef          	jal	800032d2 <acquiresleep>
    release(&itable.lock);
    80002840:	00016517          	auipc	a0,0x16
    80002844:	ea850513          	addi	a0,a0,-344 # 800186e8 <itable>
    80002848:	0ba030ef          	jal	80005902 <release>
    itrunc(ip);
    8000284c:	8526                	mv	a0,s1
    8000284e:	f0dff0ef          	jal	8000275a <itrunc>
    ip->type = 0;
    80002852:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002856:	8526                	mv	a0,s1
    80002858:	d61ff0ef          	jal	800025b8 <iupdate>
    ip->valid = 0;
    8000285c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002860:	854a                	mv	a0,s2
    80002862:	2b7000ef          	jal	80003318 <releasesleep>
    acquire(&itable.lock);
    80002866:	00016517          	auipc	a0,0x16
    8000286a:	e8250513          	addi	a0,a0,-382 # 800186e8 <itable>
    8000286e:	7fd020ef          	jal	8000586a <acquire>
    80002872:	6902                	ld	s2,0(sp)
    80002874:	bf69                	j	8000280e <iput+0x20>

0000000080002876 <iunlockput>:
{
    80002876:	1101                	addi	sp,sp,-32
    80002878:	ec06                	sd	ra,24(sp)
    8000287a:	e822                	sd	s0,16(sp)
    8000287c:	e426                	sd	s1,8(sp)
    8000287e:	1000                	addi	s0,sp,32
    80002880:	84aa                	mv	s1,a0
  iunlock(ip);
    80002882:	e99ff0ef          	jal	8000271a <iunlock>
  iput(ip);
    80002886:	8526                	mv	a0,s1
    80002888:	f67ff0ef          	jal	800027ee <iput>
}
    8000288c:	60e2                	ld	ra,24(sp)
    8000288e:	6442                	ld	s0,16(sp)
    80002890:	64a2                	ld	s1,8(sp)
    80002892:	6105                	addi	sp,sp,32
    80002894:	8082                	ret

0000000080002896 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002896:	00016717          	auipc	a4,0x16
    8000289a:	e3e72703          	lw	a4,-450(a4) # 800186d4 <sb+0xc>
    8000289e:	4785                	li	a5,1
    800028a0:	0ae7ff63          	bgeu	a5,a4,8000295e <ireclaim+0xc8>
{
    800028a4:	7139                	addi	sp,sp,-64
    800028a6:	fc06                	sd	ra,56(sp)
    800028a8:	f822                	sd	s0,48(sp)
    800028aa:	f426                	sd	s1,40(sp)
    800028ac:	f04a                	sd	s2,32(sp)
    800028ae:	ec4e                	sd	s3,24(sp)
    800028b0:	e852                	sd	s4,16(sp)
    800028b2:	e456                	sd	s5,8(sp)
    800028b4:	e05a                	sd	s6,0(sp)
    800028b6:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800028b8:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800028ba:	00050a1b          	sext.w	s4,a0
    800028be:	00016a97          	auipc	s5,0x16
    800028c2:	e0aa8a93          	addi	s5,s5,-502 # 800186c8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800028c6:	00005b17          	auipc	s6,0x5
    800028ca:	b42b0b13          	addi	s6,s6,-1214 # 80007408 <etext+0x408>
    800028ce:	a099                	j	80002914 <ireclaim+0x7e>
    800028d0:	85ce                	mv	a1,s3
    800028d2:	855a                	mv	a0,s6
    800028d4:	1f5020ef          	jal	800052c8 <printf>
      ip = iget(dev, inum);
    800028d8:	85ce                	mv	a1,s3
    800028da:	8552                	mv	a0,s4
    800028dc:	b1dff0ef          	jal	800023f8 <iget>
    800028e0:	89aa                	mv	s3,a0
    brelse(bp);
    800028e2:	854a                	mv	a0,s2
    800028e4:	fc4ff0ef          	jal	800020a8 <brelse>
    if (ip) {
    800028e8:	00098f63          	beqz	s3,80002906 <ireclaim+0x70>
      begin_op();
    800028ec:	76a000ef          	jal	80003056 <begin_op>
      ilock(ip);
    800028f0:	854e                	mv	a0,s3
    800028f2:	d7bff0ef          	jal	8000266c <ilock>
      iunlock(ip);
    800028f6:	854e                	mv	a0,s3
    800028f8:	e23ff0ef          	jal	8000271a <iunlock>
      iput(ip);
    800028fc:	854e                	mv	a0,s3
    800028fe:	ef1ff0ef          	jal	800027ee <iput>
      end_op();
    80002902:	7be000ef          	jal	800030c0 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002906:	0485                	addi	s1,s1,1
    80002908:	00caa703          	lw	a4,12(s5)
    8000290c:	0004879b          	sext.w	a5,s1
    80002910:	02e7fd63          	bgeu	a5,a4,8000294a <ireclaim+0xb4>
    80002914:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002918:	0044d593          	srli	a1,s1,0x4
    8000291c:	018aa783          	lw	a5,24(s5)
    80002920:	9dbd                	addw	a1,a1,a5
    80002922:	8552                	mv	a0,s4
    80002924:	e7cff0ef          	jal	80001fa0 <bread>
    80002928:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000292a:	05850793          	addi	a5,a0,88
    8000292e:	00f9f713          	andi	a4,s3,15
    80002932:	071a                	slli	a4,a4,0x6
    80002934:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002936:	00079703          	lh	a4,0(a5)
    8000293a:	c701                	beqz	a4,80002942 <ireclaim+0xac>
    8000293c:	00679783          	lh	a5,6(a5)
    80002940:	dbc1                	beqz	a5,800028d0 <ireclaim+0x3a>
    brelse(bp);
    80002942:	854a                	mv	a0,s2
    80002944:	f64ff0ef          	jal	800020a8 <brelse>
    if (ip) {
    80002948:	bf7d                	j	80002906 <ireclaim+0x70>
}
    8000294a:	70e2                	ld	ra,56(sp)
    8000294c:	7442                	ld	s0,48(sp)
    8000294e:	74a2                	ld	s1,40(sp)
    80002950:	7902                	ld	s2,32(sp)
    80002952:	69e2                	ld	s3,24(sp)
    80002954:	6a42                	ld	s4,16(sp)
    80002956:	6aa2                	ld	s5,8(sp)
    80002958:	6b02                	ld	s6,0(sp)
    8000295a:	6121                	addi	sp,sp,64
    8000295c:	8082                	ret
    8000295e:	8082                	ret

0000000080002960 <fsinit>:
fsinit(int dev) {
    80002960:	7179                	addi	sp,sp,-48
    80002962:	f406                	sd	ra,40(sp)
    80002964:	f022                	sd	s0,32(sp)
    80002966:	ec26                	sd	s1,24(sp)
    80002968:	e84a                	sd	s2,16(sp)
    8000296a:	e44e                	sd	s3,8(sp)
    8000296c:	1800                	addi	s0,sp,48
    8000296e:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    80002970:	4585                	li	a1,1
    80002972:	e2eff0ef          	jal	80001fa0 <bread>
    80002976:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002978:	00016997          	auipc	s3,0x16
    8000297c:	d5098993          	addi	s3,s3,-688 # 800186c8 <sb>
    80002980:	02000613          	li	a2,32
    80002984:	05850593          	addi	a1,a0,88
    80002988:	854e                	mv	a0,s3
    8000298a:	821fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    8000298e:	854a                	mv	a0,s2
    80002990:	f18ff0ef          	jal	800020a8 <brelse>
  if(sb.magic != FSMAGIC)
    80002994:	0009a703          	lw	a4,0(s3)
    80002998:	102037b7          	lui	a5,0x10203
    8000299c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029a0:	02f71363          	bne	a4,a5,800029c6 <fsinit+0x66>
  initlog(dev, &sb);
    800029a4:	00016597          	auipc	a1,0x16
    800029a8:	d2458593          	addi	a1,a1,-732 # 800186c8 <sb>
    800029ac:	8526                	mv	a0,s1
    800029ae:	62a000ef          	jal	80002fd8 <initlog>
  ireclaim(dev);
    800029b2:	8526                	mv	a0,s1
    800029b4:	ee3ff0ef          	jal	80002896 <ireclaim>
}
    800029b8:	70a2                	ld	ra,40(sp)
    800029ba:	7402                	ld	s0,32(sp)
    800029bc:	64e2                	ld	s1,24(sp)
    800029be:	6942                	ld	s2,16(sp)
    800029c0:	69a2                	ld	s3,8(sp)
    800029c2:	6145                	addi	sp,sp,48
    800029c4:	8082                	ret
    panic("invalid file system");
    800029c6:	00005517          	auipc	a0,0x5
    800029ca:	a6250513          	addi	a0,a0,-1438 # 80007428 <etext+0x428>
    800029ce:	3e1020ef          	jal	800055ae <panic>

00000000800029d2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800029d2:	1141                	addi	sp,sp,-16
    800029d4:	e422                	sd	s0,8(sp)
    800029d6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800029d8:	411c                	lw	a5,0(a0)
    800029da:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800029dc:	415c                	lw	a5,4(a0)
    800029de:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800029e0:	04451783          	lh	a5,68(a0)
    800029e4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800029e8:	04a51783          	lh	a5,74(a0)
    800029ec:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029f0:	04c56783          	lwu	a5,76(a0)
    800029f4:	e99c                	sd	a5,16(a1)
}
    800029f6:	6422                	ld	s0,8(sp)
    800029f8:	0141                	addi	sp,sp,16
    800029fa:	8082                	ret

00000000800029fc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029fc:	457c                	lw	a5,76(a0)
    800029fe:	0ed7eb63          	bltu	a5,a3,80002af4 <readi+0xf8>
{
    80002a02:	7159                	addi	sp,sp,-112
    80002a04:	f486                	sd	ra,104(sp)
    80002a06:	f0a2                	sd	s0,96(sp)
    80002a08:	eca6                	sd	s1,88(sp)
    80002a0a:	e0d2                	sd	s4,64(sp)
    80002a0c:	fc56                	sd	s5,56(sp)
    80002a0e:	f85a                	sd	s6,48(sp)
    80002a10:	f45e                	sd	s7,40(sp)
    80002a12:	1880                	addi	s0,sp,112
    80002a14:	8b2a                	mv	s6,a0
    80002a16:	8bae                	mv	s7,a1
    80002a18:	8a32                	mv	s4,a2
    80002a1a:	84b6                	mv	s1,a3
    80002a1c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a1e:	9f35                	addw	a4,a4,a3
    return 0;
    80002a20:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a22:	0cd76063          	bltu	a4,a3,80002ae2 <readi+0xe6>
    80002a26:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a28:	00e7f463          	bgeu	a5,a4,80002a30 <readi+0x34>
    n = ip->size - off;
    80002a2c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a30:	080a8f63          	beqz	s5,80002ace <readi+0xd2>
    80002a34:	e8ca                	sd	s2,80(sp)
    80002a36:	f062                	sd	s8,32(sp)
    80002a38:	ec66                	sd	s9,24(sp)
    80002a3a:	e86a                	sd	s10,16(sp)
    80002a3c:	e46e                	sd	s11,8(sp)
    80002a3e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a40:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a44:	5c7d                	li	s8,-1
    80002a46:	a80d                	j	80002a78 <readi+0x7c>
    80002a48:	020d1d93          	slli	s11,s10,0x20
    80002a4c:	020ddd93          	srli	s11,s11,0x20
    80002a50:	05890613          	addi	a2,s2,88
    80002a54:	86ee                	mv	a3,s11
    80002a56:	963a                	add	a2,a2,a4
    80002a58:	85d2                	mv	a1,s4
    80002a5a:	855e                	mv	a0,s7
    80002a5c:	c73fe0ef          	jal	800016ce <either_copyout>
    80002a60:	05850763          	beq	a0,s8,80002aae <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a64:	854a                	mv	a0,s2
    80002a66:	e42ff0ef          	jal	800020a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a6a:	013d09bb          	addw	s3,s10,s3
    80002a6e:	009d04bb          	addw	s1,s10,s1
    80002a72:	9a6e                	add	s4,s4,s11
    80002a74:	0559f763          	bgeu	s3,s5,80002ac2 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002a78:	00a4d59b          	srliw	a1,s1,0xa
    80002a7c:	855a                	mv	a0,s6
    80002a7e:	8a7ff0ef          	jal	80002324 <bmap>
    80002a82:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a86:	c5b1                	beqz	a1,80002ad2 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002a88:	000b2503          	lw	a0,0(s6)
    80002a8c:	d14ff0ef          	jal	80001fa0 <bread>
    80002a90:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a92:	3ff4f713          	andi	a4,s1,1023
    80002a96:	40ec87bb          	subw	a5,s9,a4
    80002a9a:	413a86bb          	subw	a3,s5,s3
    80002a9e:	8d3e                	mv	s10,a5
    80002aa0:	2781                	sext.w	a5,a5
    80002aa2:	0006861b          	sext.w	a2,a3
    80002aa6:	faf671e3          	bgeu	a2,a5,80002a48 <readi+0x4c>
    80002aaa:	8d36                	mv	s10,a3
    80002aac:	bf71                	j	80002a48 <readi+0x4c>
      brelse(bp);
    80002aae:	854a                	mv	a0,s2
    80002ab0:	df8ff0ef          	jal	800020a8 <brelse>
      tot = -1;
    80002ab4:	59fd                	li	s3,-1
      break;
    80002ab6:	6946                	ld	s2,80(sp)
    80002ab8:	7c02                	ld	s8,32(sp)
    80002aba:	6ce2                	ld	s9,24(sp)
    80002abc:	6d42                	ld	s10,16(sp)
    80002abe:	6da2                	ld	s11,8(sp)
    80002ac0:	a831                	j	80002adc <readi+0xe0>
    80002ac2:	6946                	ld	s2,80(sp)
    80002ac4:	7c02                	ld	s8,32(sp)
    80002ac6:	6ce2                	ld	s9,24(sp)
    80002ac8:	6d42                	ld	s10,16(sp)
    80002aca:	6da2                	ld	s11,8(sp)
    80002acc:	a801                	j	80002adc <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ace:	89d6                	mv	s3,s5
    80002ad0:	a031                	j	80002adc <readi+0xe0>
    80002ad2:	6946                	ld	s2,80(sp)
    80002ad4:	7c02                	ld	s8,32(sp)
    80002ad6:	6ce2                	ld	s9,24(sp)
    80002ad8:	6d42                	ld	s10,16(sp)
    80002ada:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002adc:	0009851b          	sext.w	a0,s3
    80002ae0:	69a6                	ld	s3,72(sp)
}
    80002ae2:	70a6                	ld	ra,104(sp)
    80002ae4:	7406                	ld	s0,96(sp)
    80002ae6:	64e6                	ld	s1,88(sp)
    80002ae8:	6a06                	ld	s4,64(sp)
    80002aea:	7ae2                	ld	s5,56(sp)
    80002aec:	7b42                	ld	s6,48(sp)
    80002aee:	7ba2                	ld	s7,40(sp)
    80002af0:	6165                	addi	sp,sp,112
    80002af2:	8082                	ret
    return 0;
    80002af4:	4501                	li	a0,0
}
    80002af6:	8082                	ret

0000000080002af8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002af8:	457c                	lw	a5,76(a0)
    80002afa:	10d7e063          	bltu	a5,a3,80002bfa <writei+0x102>
{
    80002afe:	7159                	addi	sp,sp,-112
    80002b00:	f486                	sd	ra,104(sp)
    80002b02:	f0a2                	sd	s0,96(sp)
    80002b04:	e8ca                	sd	s2,80(sp)
    80002b06:	e0d2                	sd	s4,64(sp)
    80002b08:	fc56                	sd	s5,56(sp)
    80002b0a:	f85a                	sd	s6,48(sp)
    80002b0c:	f45e                	sd	s7,40(sp)
    80002b0e:	1880                	addi	s0,sp,112
    80002b10:	8aaa                	mv	s5,a0
    80002b12:	8bae                	mv	s7,a1
    80002b14:	8a32                	mv	s4,a2
    80002b16:	8936                	mv	s2,a3
    80002b18:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b1a:	00e687bb          	addw	a5,a3,a4
    80002b1e:	0ed7e063          	bltu	a5,a3,80002bfe <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b22:	00043737          	lui	a4,0x43
    80002b26:	0cf76e63          	bltu	a4,a5,80002c02 <writei+0x10a>
    80002b2a:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b2c:	0a0b0f63          	beqz	s6,80002bea <writei+0xf2>
    80002b30:	eca6                	sd	s1,88(sp)
    80002b32:	f062                	sd	s8,32(sp)
    80002b34:	ec66                	sd	s9,24(sp)
    80002b36:	e86a                	sd	s10,16(sp)
    80002b38:	e46e                	sd	s11,8(sp)
    80002b3a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b3c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b40:	5c7d                	li	s8,-1
    80002b42:	a825                	j	80002b7a <writei+0x82>
    80002b44:	020d1d93          	slli	s11,s10,0x20
    80002b48:	020ddd93          	srli	s11,s11,0x20
    80002b4c:	05848513          	addi	a0,s1,88
    80002b50:	86ee                	mv	a3,s11
    80002b52:	8652                	mv	a2,s4
    80002b54:	85de                	mv	a1,s7
    80002b56:	953a                	add	a0,a0,a4
    80002b58:	bc1fe0ef          	jal	80001718 <either_copyin>
    80002b5c:	05850a63          	beq	a0,s8,80002bb0 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b60:	8526                	mv	a0,s1
    80002b62:	678000ef          	jal	800031da <log_write>
    brelse(bp);
    80002b66:	8526                	mv	a0,s1
    80002b68:	d40ff0ef          	jal	800020a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b6c:	013d09bb          	addw	s3,s10,s3
    80002b70:	012d093b          	addw	s2,s10,s2
    80002b74:	9a6e                	add	s4,s4,s11
    80002b76:	0569f063          	bgeu	s3,s6,80002bb6 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b7a:	00a9559b          	srliw	a1,s2,0xa
    80002b7e:	8556                	mv	a0,s5
    80002b80:	fa4ff0ef          	jal	80002324 <bmap>
    80002b84:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b88:	c59d                	beqz	a1,80002bb6 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002b8a:	000aa503          	lw	a0,0(s5)
    80002b8e:	c12ff0ef          	jal	80001fa0 <bread>
    80002b92:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b94:	3ff97713          	andi	a4,s2,1023
    80002b98:	40ec87bb          	subw	a5,s9,a4
    80002b9c:	413b06bb          	subw	a3,s6,s3
    80002ba0:	8d3e                	mv	s10,a5
    80002ba2:	2781                	sext.w	a5,a5
    80002ba4:	0006861b          	sext.w	a2,a3
    80002ba8:	f8f67ee3          	bgeu	a2,a5,80002b44 <writei+0x4c>
    80002bac:	8d36                	mv	s10,a3
    80002bae:	bf59                	j	80002b44 <writei+0x4c>
      brelse(bp);
    80002bb0:	8526                	mv	a0,s1
    80002bb2:	cf6ff0ef          	jal	800020a8 <brelse>
  }

  if(off > ip->size)
    80002bb6:	04caa783          	lw	a5,76(s5)
    80002bba:	0327fa63          	bgeu	a5,s2,80002bee <writei+0xf6>
    ip->size = off;
    80002bbe:	052aa623          	sw	s2,76(s5)
    80002bc2:	64e6                	ld	s1,88(sp)
    80002bc4:	7c02                	ld	s8,32(sp)
    80002bc6:	6ce2                	ld	s9,24(sp)
    80002bc8:	6d42                	ld	s10,16(sp)
    80002bca:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002bcc:	8556                	mv	a0,s5
    80002bce:	9ebff0ef          	jal	800025b8 <iupdate>

  return tot;
    80002bd2:	0009851b          	sext.w	a0,s3
    80002bd6:	69a6                	ld	s3,72(sp)
}
    80002bd8:	70a6                	ld	ra,104(sp)
    80002bda:	7406                	ld	s0,96(sp)
    80002bdc:	6946                	ld	s2,80(sp)
    80002bde:	6a06                	ld	s4,64(sp)
    80002be0:	7ae2                	ld	s5,56(sp)
    80002be2:	7b42                	ld	s6,48(sp)
    80002be4:	7ba2                	ld	s7,40(sp)
    80002be6:	6165                	addi	sp,sp,112
    80002be8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bea:	89da                	mv	s3,s6
    80002bec:	b7c5                	j	80002bcc <writei+0xd4>
    80002bee:	64e6                	ld	s1,88(sp)
    80002bf0:	7c02                	ld	s8,32(sp)
    80002bf2:	6ce2                	ld	s9,24(sp)
    80002bf4:	6d42                	ld	s10,16(sp)
    80002bf6:	6da2                	ld	s11,8(sp)
    80002bf8:	bfd1                	j	80002bcc <writei+0xd4>
    return -1;
    80002bfa:	557d                	li	a0,-1
}
    80002bfc:	8082                	ret
    return -1;
    80002bfe:	557d                	li	a0,-1
    80002c00:	bfe1                	j	80002bd8 <writei+0xe0>
    return -1;
    80002c02:	557d                	li	a0,-1
    80002c04:	bfd1                	j	80002bd8 <writei+0xe0>

0000000080002c06 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c06:	1141                	addi	sp,sp,-16
    80002c08:	e406                	sd	ra,8(sp)
    80002c0a:	e022                	sd	s0,0(sp)
    80002c0c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c0e:	4639                	li	a2,14
    80002c10:	e0afd0ef          	jal	8000021a <strncmp>
}
    80002c14:	60a2                	ld	ra,8(sp)
    80002c16:	6402                	ld	s0,0(sp)
    80002c18:	0141                	addi	sp,sp,16
    80002c1a:	8082                	ret

0000000080002c1c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c1c:	7139                	addi	sp,sp,-64
    80002c1e:	fc06                	sd	ra,56(sp)
    80002c20:	f822                	sd	s0,48(sp)
    80002c22:	f426                	sd	s1,40(sp)
    80002c24:	f04a                	sd	s2,32(sp)
    80002c26:	ec4e                	sd	s3,24(sp)
    80002c28:	e852                	sd	s4,16(sp)
    80002c2a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c2c:	04451703          	lh	a4,68(a0)
    80002c30:	4785                	li	a5,1
    80002c32:	00f71a63          	bne	a4,a5,80002c46 <dirlookup+0x2a>
    80002c36:	892a                	mv	s2,a0
    80002c38:	89ae                	mv	s3,a1
    80002c3a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c3c:	457c                	lw	a5,76(a0)
    80002c3e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c40:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c42:	e39d                	bnez	a5,80002c68 <dirlookup+0x4c>
    80002c44:	a095                	j	80002ca8 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c46:	00004517          	auipc	a0,0x4
    80002c4a:	7fa50513          	addi	a0,a0,2042 # 80007440 <etext+0x440>
    80002c4e:	161020ef          	jal	800055ae <panic>
      panic("dirlookup read");
    80002c52:	00005517          	auipc	a0,0x5
    80002c56:	80650513          	addi	a0,a0,-2042 # 80007458 <etext+0x458>
    80002c5a:	155020ef          	jal	800055ae <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c5e:	24c1                	addiw	s1,s1,16
    80002c60:	04c92783          	lw	a5,76(s2)
    80002c64:	04f4f163          	bgeu	s1,a5,80002ca6 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c68:	4741                	li	a4,16
    80002c6a:	86a6                	mv	a3,s1
    80002c6c:	fc040613          	addi	a2,s0,-64
    80002c70:	4581                	li	a1,0
    80002c72:	854a                	mv	a0,s2
    80002c74:	d89ff0ef          	jal	800029fc <readi>
    80002c78:	47c1                	li	a5,16
    80002c7a:	fcf51ce3          	bne	a0,a5,80002c52 <dirlookup+0x36>
    if(de.inum == 0)
    80002c7e:	fc045783          	lhu	a5,-64(s0)
    80002c82:	dff1                	beqz	a5,80002c5e <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002c84:	fc240593          	addi	a1,s0,-62
    80002c88:	854e                	mv	a0,s3
    80002c8a:	f7dff0ef          	jal	80002c06 <namecmp>
    80002c8e:	f961                	bnez	a0,80002c5e <dirlookup+0x42>
      if(poff)
    80002c90:	000a0463          	beqz	s4,80002c98 <dirlookup+0x7c>
        *poff = off;
    80002c94:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c98:	fc045583          	lhu	a1,-64(s0)
    80002c9c:	00092503          	lw	a0,0(s2)
    80002ca0:	f58ff0ef          	jal	800023f8 <iget>
    80002ca4:	a011                	j	80002ca8 <dirlookup+0x8c>
  return 0;
    80002ca6:	4501                	li	a0,0
}
    80002ca8:	70e2                	ld	ra,56(sp)
    80002caa:	7442                	ld	s0,48(sp)
    80002cac:	74a2                	ld	s1,40(sp)
    80002cae:	7902                	ld	s2,32(sp)
    80002cb0:	69e2                	ld	s3,24(sp)
    80002cb2:	6a42                	ld	s4,16(sp)
    80002cb4:	6121                	addi	sp,sp,64
    80002cb6:	8082                	ret

0000000080002cb8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002cb8:	711d                	addi	sp,sp,-96
    80002cba:	ec86                	sd	ra,88(sp)
    80002cbc:	e8a2                	sd	s0,80(sp)
    80002cbe:	e4a6                	sd	s1,72(sp)
    80002cc0:	e0ca                	sd	s2,64(sp)
    80002cc2:	fc4e                	sd	s3,56(sp)
    80002cc4:	f852                	sd	s4,48(sp)
    80002cc6:	f456                	sd	s5,40(sp)
    80002cc8:	f05a                	sd	s6,32(sp)
    80002cca:	ec5e                	sd	s7,24(sp)
    80002ccc:	e862                	sd	s8,16(sp)
    80002cce:	e466                	sd	s9,8(sp)
    80002cd0:	1080                	addi	s0,sp,96
    80002cd2:	84aa                	mv	s1,a0
    80002cd4:	8b2e                	mv	s6,a1
    80002cd6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002cd8:	00054703          	lbu	a4,0(a0)
    80002cdc:	02f00793          	li	a5,47
    80002ce0:	00f70e63          	beq	a4,a5,80002cfc <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002ce4:	896fe0ef          	jal	80000d7a <myproc>
    80002ce8:	15053503          	ld	a0,336(a0)
    80002cec:	94bff0ef          	jal	80002636 <idup>
    80002cf0:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002cf2:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002cf6:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002cf8:	4b85                	li	s7,1
    80002cfa:	a871                	j	80002d96 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002cfc:	4585                	li	a1,1
    80002cfe:	4505                	li	a0,1
    80002d00:	ef8ff0ef          	jal	800023f8 <iget>
    80002d04:	8a2a                	mv	s4,a0
    80002d06:	b7f5                	j	80002cf2 <namex+0x3a>
      iunlockput(ip);
    80002d08:	8552                	mv	a0,s4
    80002d0a:	b6dff0ef          	jal	80002876 <iunlockput>
      return 0;
    80002d0e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d10:	8552                	mv	a0,s4
    80002d12:	60e6                	ld	ra,88(sp)
    80002d14:	6446                	ld	s0,80(sp)
    80002d16:	64a6                	ld	s1,72(sp)
    80002d18:	6906                	ld	s2,64(sp)
    80002d1a:	79e2                	ld	s3,56(sp)
    80002d1c:	7a42                	ld	s4,48(sp)
    80002d1e:	7aa2                	ld	s5,40(sp)
    80002d20:	7b02                	ld	s6,32(sp)
    80002d22:	6be2                	ld	s7,24(sp)
    80002d24:	6c42                	ld	s8,16(sp)
    80002d26:	6ca2                	ld	s9,8(sp)
    80002d28:	6125                	addi	sp,sp,96
    80002d2a:	8082                	ret
      iunlock(ip);
    80002d2c:	8552                	mv	a0,s4
    80002d2e:	9edff0ef          	jal	8000271a <iunlock>
      return ip;
    80002d32:	bff9                	j	80002d10 <namex+0x58>
      iunlockput(ip);
    80002d34:	8552                	mv	a0,s4
    80002d36:	b41ff0ef          	jal	80002876 <iunlockput>
      return 0;
    80002d3a:	8a4e                	mv	s4,s3
    80002d3c:	bfd1                	j	80002d10 <namex+0x58>
  len = path - s;
    80002d3e:	40998633          	sub	a2,s3,s1
    80002d42:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d46:	099c5063          	bge	s8,s9,80002dc6 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d4a:	4639                	li	a2,14
    80002d4c:	85a6                	mv	a1,s1
    80002d4e:	8556                	mv	a0,s5
    80002d50:	c5afd0ef          	jal	800001aa <memmove>
    80002d54:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d56:	0004c783          	lbu	a5,0(s1)
    80002d5a:	01279763          	bne	a5,s2,80002d68 <namex+0xb0>
    path++;
    80002d5e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d60:	0004c783          	lbu	a5,0(s1)
    80002d64:	ff278de3          	beq	a5,s2,80002d5e <namex+0xa6>
    ilock(ip);
    80002d68:	8552                	mv	a0,s4
    80002d6a:	903ff0ef          	jal	8000266c <ilock>
    if(ip->type != T_DIR){
    80002d6e:	044a1783          	lh	a5,68(s4)
    80002d72:	f9779be3          	bne	a5,s7,80002d08 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002d76:	000b0563          	beqz	s6,80002d80 <namex+0xc8>
    80002d7a:	0004c783          	lbu	a5,0(s1)
    80002d7e:	d7dd                	beqz	a5,80002d2c <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d80:	4601                	li	a2,0
    80002d82:	85d6                	mv	a1,s5
    80002d84:	8552                	mv	a0,s4
    80002d86:	e97ff0ef          	jal	80002c1c <dirlookup>
    80002d8a:	89aa                	mv	s3,a0
    80002d8c:	d545                	beqz	a0,80002d34 <namex+0x7c>
    iunlockput(ip);
    80002d8e:	8552                	mv	a0,s4
    80002d90:	ae7ff0ef          	jal	80002876 <iunlockput>
    ip = next;
    80002d94:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d96:	0004c783          	lbu	a5,0(s1)
    80002d9a:	01279763          	bne	a5,s2,80002da8 <namex+0xf0>
    path++;
    80002d9e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002da0:	0004c783          	lbu	a5,0(s1)
    80002da4:	ff278de3          	beq	a5,s2,80002d9e <namex+0xe6>
  if(*path == 0)
    80002da8:	cb8d                	beqz	a5,80002dda <namex+0x122>
  while(*path != '/' && *path != 0)
    80002daa:	0004c783          	lbu	a5,0(s1)
    80002dae:	89a6                	mv	s3,s1
  len = path - s;
    80002db0:	4c81                	li	s9,0
    80002db2:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002db4:	01278963          	beq	a5,s2,80002dc6 <namex+0x10e>
    80002db8:	d3d9                	beqz	a5,80002d3e <namex+0x86>
    path++;
    80002dba:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002dbc:	0009c783          	lbu	a5,0(s3)
    80002dc0:	ff279ce3          	bne	a5,s2,80002db8 <namex+0x100>
    80002dc4:	bfad                	j	80002d3e <namex+0x86>
    memmove(name, s, len);
    80002dc6:	2601                	sext.w	a2,a2
    80002dc8:	85a6                	mv	a1,s1
    80002dca:	8556                	mv	a0,s5
    80002dcc:	bdefd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002dd0:	9cd6                	add	s9,s9,s5
    80002dd2:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002dd6:	84ce                	mv	s1,s3
    80002dd8:	bfbd                	j	80002d56 <namex+0x9e>
  if(nameiparent){
    80002dda:	f20b0be3          	beqz	s6,80002d10 <namex+0x58>
    iput(ip);
    80002dde:	8552                	mv	a0,s4
    80002de0:	a0fff0ef          	jal	800027ee <iput>
    return 0;
    80002de4:	4a01                	li	s4,0
    80002de6:	b72d                	j	80002d10 <namex+0x58>

0000000080002de8 <dirlink>:
{
    80002de8:	7139                	addi	sp,sp,-64
    80002dea:	fc06                	sd	ra,56(sp)
    80002dec:	f822                	sd	s0,48(sp)
    80002dee:	f04a                	sd	s2,32(sp)
    80002df0:	ec4e                	sd	s3,24(sp)
    80002df2:	e852                	sd	s4,16(sp)
    80002df4:	0080                	addi	s0,sp,64
    80002df6:	892a                	mv	s2,a0
    80002df8:	8a2e                	mv	s4,a1
    80002dfa:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002dfc:	4601                	li	a2,0
    80002dfe:	e1fff0ef          	jal	80002c1c <dirlookup>
    80002e02:	e535                	bnez	a0,80002e6e <dirlink+0x86>
    80002e04:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e06:	04c92483          	lw	s1,76(s2)
    80002e0a:	c48d                	beqz	s1,80002e34 <dirlink+0x4c>
    80002e0c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e0e:	4741                	li	a4,16
    80002e10:	86a6                	mv	a3,s1
    80002e12:	fc040613          	addi	a2,s0,-64
    80002e16:	4581                	li	a1,0
    80002e18:	854a                	mv	a0,s2
    80002e1a:	be3ff0ef          	jal	800029fc <readi>
    80002e1e:	47c1                	li	a5,16
    80002e20:	04f51b63          	bne	a0,a5,80002e76 <dirlink+0x8e>
    if(de.inum == 0)
    80002e24:	fc045783          	lhu	a5,-64(s0)
    80002e28:	c791                	beqz	a5,80002e34 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e2a:	24c1                	addiw	s1,s1,16
    80002e2c:	04c92783          	lw	a5,76(s2)
    80002e30:	fcf4efe3          	bltu	s1,a5,80002e0e <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e34:	4639                	li	a2,14
    80002e36:	85d2                	mv	a1,s4
    80002e38:	fc240513          	addi	a0,s0,-62
    80002e3c:	c14fd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002e40:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e44:	4741                	li	a4,16
    80002e46:	86a6                	mv	a3,s1
    80002e48:	fc040613          	addi	a2,s0,-64
    80002e4c:	4581                	li	a1,0
    80002e4e:	854a                	mv	a0,s2
    80002e50:	ca9ff0ef          	jal	80002af8 <writei>
    80002e54:	1541                	addi	a0,a0,-16
    80002e56:	00a03533          	snez	a0,a0
    80002e5a:	40a00533          	neg	a0,a0
    80002e5e:	74a2                	ld	s1,40(sp)
}
    80002e60:	70e2                	ld	ra,56(sp)
    80002e62:	7442                	ld	s0,48(sp)
    80002e64:	7902                	ld	s2,32(sp)
    80002e66:	69e2                	ld	s3,24(sp)
    80002e68:	6a42                	ld	s4,16(sp)
    80002e6a:	6121                	addi	sp,sp,64
    80002e6c:	8082                	ret
    iput(ip);
    80002e6e:	981ff0ef          	jal	800027ee <iput>
    return -1;
    80002e72:	557d                	li	a0,-1
    80002e74:	b7f5                	j	80002e60 <dirlink+0x78>
      panic("dirlink read");
    80002e76:	00004517          	auipc	a0,0x4
    80002e7a:	5f250513          	addi	a0,a0,1522 # 80007468 <etext+0x468>
    80002e7e:	730020ef          	jal	800055ae <panic>

0000000080002e82 <namei>:

struct inode*
namei(char *path)
{
    80002e82:	1101                	addi	sp,sp,-32
    80002e84:	ec06                	sd	ra,24(sp)
    80002e86:	e822                	sd	s0,16(sp)
    80002e88:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e8a:	fe040613          	addi	a2,s0,-32
    80002e8e:	4581                	li	a1,0
    80002e90:	e29ff0ef          	jal	80002cb8 <namex>
}
    80002e94:	60e2                	ld	ra,24(sp)
    80002e96:	6442                	ld	s0,16(sp)
    80002e98:	6105                	addi	sp,sp,32
    80002e9a:	8082                	ret

0000000080002e9c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e9c:	1141                	addi	sp,sp,-16
    80002e9e:	e406                	sd	ra,8(sp)
    80002ea0:	e022                	sd	s0,0(sp)
    80002ea2:	0800                	addi	s0,sp,16
    80002ea4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002ea6:	4585                	li	a1,1
    80002ea8:	e11ff0ef          	jal	80002cb8 <namex>
}
    80002eac:	60a2                	ld	ra,8(sp)
    80002eae:	6402                	ld	s0,0(sp)
    80002eb0:	0141                	addi	sp,sp,16
    80002eb2:	8082                	ret

0000000080002eb4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002eb4:	1101                	addi	sp,sp,-32
    80002eb6:	ec06                	sd	ra,24(sp)
    80002eb8:	e822                	sd	s0,16(sp)
    80002eba:	e426                	sd	s1,8(sp)
    80002ebc:	e04a                	sd	s2,0(sp)
    80002ebe:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002ec0:	00017917          	auipc	s2,0x17
    80002ec4:	2d090913          	addi	s2,s2,720 # 8001a190 <log>
    80002ec8:	01892583          	lw	a1,24(s2)
    80002ecc:	02492503          	lw	a0,36(s2)
    80002ed0:	8d0ff0ef          	jal	80001fa0 <bread>
    80002ed4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002ed6:	02892603          	lw	a2,40(s2)
    80002eda:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002edc:	00c05f63          	blez	a2,80002efa <write_head+0x46>
    80002ee0:	00017717          	auipc	a4,0x17
    80002ee4:	2dc70713          	addi	a4,a4,732 # 8001a1bc <log+0x2c>
    80002ee8:	87aa                	mv	a5,a0
    80002eea:	060a                	slli	a2,a2,0x2
    80002eec:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002eee:	4314                	lw	a3,0(a4)
    80002ef0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002ef2:	0711                	addi	a4,a4,4
    80002ef4:	0791                	addi	a5,a5,4
    80002ef6:	fec79ce3          	bne	a5,a2,80002eee <write_head+0x3a>
  }
  bwrite(buf);
    80002efa:	8526                	mv	a0,s1
    80002efc:	97aff0ef          	jal	80002076 <bwrite>
  brelse(buf);
    80002f00:	8526                	mv	a0,s1
    80002f02:	9a6ff0ef          	jal	800020a8 <brelse>
}
    80002f06:	60e2                	ld	ra,24(sp)
    80002f08:	6442                	ld	s0,16(sp)
    80002f0a:	64a2                	ld	s1,8(sp)
    80002f0c:	6902                	ld	s2,0(sp)
    80002f0e:	6105                	addi	sp,sp,32
    80002f10:	8082                	ret

0000000080002f12 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f12:	00017797          	auipc	a5,0x17
    80002f16:	2a67a783          	lw	a5,678(a5) # 8001a1b8 <log+0x28>
    80002f1a:	0af05e63          	blez	a5,80002fd6 <install_trans+0xc4>
{
    80002f1e:	715d                	addi	sp,sp,-80
    80002f20:	e486                	sd	ra,72(sp)
    80002f22:	e0a2                	sd	s0,64(sp)
    80002f24:	fc26                	sd	s1,56(sp)
    80002f26:	f84a                	sd	s2,48(sp)
    80002f28:	f44e                	sd	s3,40(sp)
    80002f2a:	f052                	sd	s4,32(sp)
    80002f2c:	ec56                	sd	s5,24(sp)
    80002f2e:	e85a                	sd	s6,16(sp)
    80002f30:	e45e                	sd	s7,8(sp)
    80002f32:	0880                	addi	s0,sp,80
    80002f34:	8b2a                	mv	s6,a0
    80002f36:	00017a97          	auipc	s5,0x17
    80002f3a:	286a8a93          	addi	s5,s5,646 # 8001a1bc <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f3e:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002f40:	00004b97          	auipc	s7,0x4
    80002f44:	538b8b93          	addi	s7,s7,1336 # 80007478 <etext+0x478>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f48:	00017a17          	auipc	s4,0x17
    80002f4c:	248a0a13          	addi	s4,s4,584 # 8001a190 <log>
    80002f50:	a025                	j	80002f78 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002f52:	000aa603          	lw	a2,0(s5)
    80002f56:	85ce                	mv	a1,s3
    80002f58:	855e                	mv	a0,s7
    80002f5a:	36e020ef          	jal	800052c8 <printf>
    80002f5e:	a839                	j	80002f7c <install_trans+0x6a>
    brelse(lbuf);
    80002f60:	854a                	mv	a0,s2
    80002f62:	946ff0ef          	jal	800020a8 <brelse>
    brelse(dbuf);
    80002f66:	8526                	mv	a0,s1
    80002f68:	940ff0ef          	jal	800020a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f6c:	2985                	addiw	s3,s3,1
    80002f6e:	0a91                	addi	s5,s5,4
    80002f70:	028a2783          	lw	a5,40(s4)
    80002f74:	04f9d663          	bge	s3,a5,80002fc0 <install_trans+0xae>
    if(recovering) {
    80002f78:	fc0b1de3          	bnez	s6,80002f52 <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f7c:	018a2583          	lw	a1,24(s4)
    80002f80:	013585bb          	addw	a1,a1,s3
    80002f84:	2585                	addiw	a1,a1,1
    80002f86:	024a2503          	lw	a0,36(s4)
    80002f8a:	816ff0ef          	jal	80001fa0 <bread>
    80002f8e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f90:	000aa583          	lw	a1,0(s5)
    80002f94:	024a2503          	lw	a0,36(s4)
    80002f98:	808ff0ef          	jal	80001fa0 <bread>
    80002f9c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f9e:	40000613          	li	a2,1024
    80002fa2:	05890593          	addi	a1,s2,88
    80002fa6:	05850513          	addi	a0,a0,88
    80002faa:	a00fd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002fae:	8526                	mv	a0,s1
    80002fb0:	8c6ff0ef          	jal	80002076 <bwrite>
    if(recovering == 0)
    80002fb4:	fa0b16e3          	bnez	s6,80002f60 <install_trans+0x4e>
      bunpin(dbuf);
    80002fb8:	8526                	mv	a0,s1
    80002fba:	9aaff0ef          	jal	80002164 <bunpin>
    80002fbe:	b74d                	j	80002f60 <install_trans+0x4e>
}
    80002fc0:	60a6                	ld	ra,72(sp)
    80002fc2:	6406                	ld	s0,64(sp)
    80002fc4:	74e2                	ld	s1,56(sp)
    80002fc6:	7942                	ld	s2,48(sp)
    80002fc8:	79a2                	ld	s3,40(sp)
    80002fca:	7a02                	ld	s4,32(sp)
    80002fcc:	6ae2                	ld	s5,24(sp)
    80002fce:	6b42                	ld	s6,16(sp)
    80002fd0:	6ba2                	ld	s7,8(sp)
    80002fd2:	6161                	addi	sp,sp,80
    80002fd4:	8082                	ret
    80002fd6:	8082                	ret

0000000080002fd8 <initlog>:
{
    80002fd8:	7179                	addi	sp,sp,-48
    80002fda:	f406                	sd	ra,40(sp)
    80002fdc:	f022                	sd	s0,32(sp)
    80002fde:	ec26                	sd	s1,24(sp)
    80002fe0:	e84a                	sd	s2,16(sp)
    80002fe2:	e44e                	sd	s3,8(sp)
    80002fe4:	1800                	addi	s0,sp,48
    80002fe6:	892a                	mv	s2,a0
    80002fe8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002fea:	00017497          	auipc	s1,0x17
    80002fee:	1a648493          	addi	s1,s1,422 # 8001a190 <log>
    80002ff2:	00004597          	auipc	a1,0x4
    80002ff6:	4a658593          	addi	a1,a1,1190 # 80007498 <etext+0x498>
    80002ffa:	8526                	mv	a0,s1
    80002ffc:	7ee020ef          	jal	800057ea <initlock>
  log.start = sb->logstart;
    80003000:	0149a583          	lw	a1,20(s3)
    80003004:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003006:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000300a:	854a                	mv	a0,s2
    8000300c:	f95fe0ef          	jal	80001fa0 <bread>
  log.lh.n = lh->n;
    80003010:	4d30                	lw	a2,88(a0)
    80003012:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003014:	00c05f63          	blez	a2,80003032 <initlog+0x5a>
    80003018:	87aa                	mv	a5,a0
    8000301a:	00017717          	auipc	a4,0x17
    8000301e:	1a270713          	addi	a4,a4,418 # 8001a1bc <log+0x2c>
    80003022:	060a                	slli	a2,a2,0x2
    80003024:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003026:	4ff4                	lw	a3,92(a5)
    80003028:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000302a:	0791                	addi	a5,a5,4
    8000302c:	0711                	addi	a4,a4,4
    8000302e:	fec79ce3          	bne	a5,a2,80003026 <initlog+0x4e>
  brelse(buf);
    80003032:	876ff0ef          	jal	800020a8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003036:	4505                	li	a0,1
    80003038:	edbff0ef          	jal	80002f12 <install_trans>
  log.lh.n = 0;
    8000303c:	00017797          	auipc	a5,0x17
    80003040:	1607ae23          	sw	zero,380(a5) # 8001a1b8 <log+0x28>
  write_head(); // clear the log
    80003044:	e71ff0ef          	jal	80002eb4 <write_head>
}
    80003048:	70a2                	ld	ra,40(sp)
    8000304a:	7402                	ld	s0,32(sp)
    8000304c:	64e2                	ld	s1,24(sp)
    8000304e:	6942                	ld	s2,16(sp)
    80003050:	69a2                	ld	s3,8(sp)
    80003052:	6145                	addi	sp,sp,48
    80003054:	8082                	ret

0000000080003056 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003056:	1101                	addi	sp,sp,-32
    80003058:	ec06                	sd	ra,24(sp)
    8000305a:	e822                	sd	s0,16(sp)
    8000305c:	e426                	sd	s1,8(sp)
    8000305e:	e04a                	sd	s2,0(sp)
    80003060:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003062:	00017517          	auipc	a0,0x17
    80003066:	12e50513          	addi	a0,a0,302 # 8001a190 <log>
    8000306a:	001020ef          	jal	8000586a <acquire>
  while(1){
    if(log.committing){
    8000306e:	00017497          	auipc	s1,0x17
    80003072:	12248493          	addi	s1,s1,290 # 8001a190 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003076:	4979                	li	s2,30
    80003078:	a029                	j	80003082 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000307a:	85a6                	mv	a1,s1
    8000307c:	8526                	mv	a0,s1
    8000307e:	af4fe0ef          	jal	80001372 <sleep>
    if(log.committing){
    80003082:	509c                	lw	a5,32(s1)
    80003084:	fbfd                	bnez	a5,8000307a <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003086:	4cd8                	lw	a4,28(s1)
    80003088:	2705                	addiw	a4,a4,1
    8000308a:	0027179b          	slliw	a5,a4,0x2
    8000308e:	9fb9                	addw	a5,a5,a4
    80003090:	0017979b          	slliw	a5,a5,0x1
    80003094:	5494                	lw	a3,40(s1)
    80003096:	9fb5                	addw	a5,a5,a3
    80003098:	00f95763          	bge	s2,a5,800030a6 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000309c:	85a6                	mv	a1,s1
    8000309e:	8526                	mv	a0,s1
    800030a0:	ad2fe0ef          	jal	80001372 <sleep>
    800030a4:	bff9                	j	80003082 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800030a6:	00017517          	auipc	a0,0x17
    800030aa:	0ea50513          	addi	a0,a0,234 # 8001a190 <log>
    800030ae:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    800030b0:	053020ef          	jal	80005902 <release>
      break;
    }
  }
}
    800030b4:	60e2                	ld	ra,24(sp)
    800030b6:	6442                	ld	s0,16(sp)
    800030b8:	64a2                	ld	s1,8(sp)
    800030ba:	6902                	ld	s2,0(sp)
    800030bc:	6105                	addi	sp,sp,32
    800030be:	8082                	ret

00000000800030c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800030c0:	7139                	addi	sp,sp,-64
    800030c2:	fc06                	sd	ra,56(sp)
    800030c4:	f822                	sd	s0,48(sp)
    800030c6:	f426                	sd	s1,40(sp)
    800030c8:	f04a                	sd	s2,32(sp)
    800030ca:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800030cc:	00017497          	auipc	s1,0x17
    800030d0:	0c448493          	addi	s1,s1,196 # 8001a190 <log>
    800030d4:	8526                	mv	a0,s1
    800030d6:	794020ef          	jal	8000586a <acquire>
  log.outstanding -= 1;
    800030da:	4cdc                	lw	a5,28(s1)
    800030dc:	37fd                	addiw	a5,a5,-1
    800030de:	0007891b          	sext.w	s2,a5
    800030e2:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800030e4:	509c                	lw	a5,32(s1)
    800030e6:	ef9d                	bnez	a5,80003124 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800030e8:	04091763          	bnez	s2,80003136 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800030ec:	00017497          	auipc	s1,0x17
    800030f0:	0a448493          	addi	s1,s1,164 # 8001a190 <log>
    800030f4:	4785                	li	a5,1
    800030f6:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800030f8:	8526                	mv	a0,s1
    800030fa:	009020ef          	jal	80005902 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800030fe:	549c                	lw	a5,40(s1)
    80003100:	04f04b63          	bgtz	a5,80003156 <end_op+0x96>
    acquire(&log.lock);
    80003104:	00017497          	auipc	s1,0x17
    80003108:	08c48493          	addi	s1,s1,140 # 8001a190 <log>
    8000310c:	8526                	mv	a0,s1
    8000310e:	75c020ef          	jal	8000586a <acquire>
    log.committing = 0;
    80003112:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003116:	8526                	mv	a0,s1
    80003118:	aa6fe0ef          	jal	800013be <wakeup>
    release(&log.lock);
    8000311c:	8526                	mv	a0,s1
    8000311e:	7e4020ef          	jal	80005902 <release>
}
    80003122:	a025                	j	8000314a <end_op+0x8a>
    80003124:	ec4e                	sd	s3,24(sp)
    80003126:	e852                	sd	s4,16(sp)
    80003128:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000312a:	00004517          	auipc	a0,0x4
    8000312e:	37650513          	addi	a0,a0,886 # 800074a0 <etext+0x4a0>
    80003132:	47c020ef          	jal	800055ae <panic>
    wakeup(&log);
    80003136:	00017497          	auipc	s1,0x17
    8000313a:	05a48493          	addi	s1,s1,90 # 8001a190 <log>
    8000313e:	8526                	mv	a0,s1
    80003140:	a7efe0ef          	jal	800013be <wakeup>
  release(&log.lock);
    80003144:	8526                	mv	a0,s1
    80003146:	7bc020ef          	jal	80005902 <release>
}
    8000314a:	70e2                	ld	ra,56(sp)
    8000314c:	7442                	ld	s0,48(sp)
    8000314e:	74a2                	ld	s1,40(sp)
    80003150:	7902                	ld	s2,32(sp)
    80003152:	6121                	addi	sp,sp,64
    80003154:	8082                	ret
    80003156:	ec4e                	sd	s3,24(sp)
    80003158:	e852                	sd	s4,16(sp)
    8000315a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000315c:	00017a97          	auipc	s5,0x17
    80003160:	060a8a93          	addi	s5,s5,96 # 8001a1bc <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003164:	00017a17          	auipc	s4,0x17
    80003168:	02ca0a13          	addi	s4,s4,44 # 8001a190 <log>
    8000316c:	018a2583          	lw	a1,24(s4)
    80003170:	012585bb          	addw	a1,a1,s2
    80003174:	2585                	addiw	a1,a1,1
    80003176:	024a2503          	lw	a0,36(s4)
    8000317a:	e27fe0ef          	jal	80001fa0 <bread>
    8000317e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003180:	000aa583          	lw	a1,0(s5)
    80003184:	024a2503          	lw	a0,36(s4)
    80003188:	e19fe0ef          	jal	80001fa0 <bread>
    8000318c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000318e:	40000613          	li	a2,1024
    80003192:	05850593          	addi	a1,a0,88
    80003196:	05848513          	addi	a0,s1,88
    8000319a:	810fd0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    8000319e:	8526                	mv	a0,s1
    800031a0:	ed7fe0ef          	jal	80002076 <bwrite>
    brelse(from);
    800031a4:	854e                	mv	a0,s3
    800031a6:	f03fe0ef          	jal	800020a8 <brelse>
    brelse(to);
    800031aa:	8526                	mv	a0,s1
    800031ac:	efdfe0ef          	jal	800020a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031b0:	2905                	addiw	s2,s2,1
    800031b2:	0a91                	addi	s5,s5,4
    800031b4:	028a2783          	lw	a5,40(s4)
    800031b8:	faf94ae3          	blt	s2,a5,8000316c <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800031bc:	cf9ff0ef          	jal	80002eb4 <write_head>
    install_trans(0); // Now install writes to home locations
    800031c0:	4501                	li	a0,0
    800031c2:	d51ff0ef          	jal	80002f12 <install_trans>
    log.lh.n = 0;
    800031c6:	00017797          	auipc	a5,0x17
    800031ca:	fe07a923          	sw	zero,-14(a5) # 8001a1b8 <log+0x28>
    write_head();    // Erase the transaction from the log
    800031ce:	ce7ff0ef          	jal	80002eb4 <write_head>
    800031d2:	69e2                	ld	s3,24(sp)
    800031d4:	6a42                	ld	s4,16(sp)
    800031d6:	6aa2                	ld	s5,8(sp)
    800031d8:	b735                	j	80003104 <end_op+0x44>

00000000800031da <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800031da:	1101                	addi	sp,sp,-32
    800031dc:	ec06                	sd	ra,24(sp)
    800031de:	e822                	sd	s0,16(sp)
    800031e0:	e426                	sd	s1,8(sp)
    800031e2:	e04a                	sd	s2,0(sp)
    800031e4:	1000                	addi	s0,sp,32
    800031e6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800031e8:	00017917          	auipc	s2,0x17
    800031ec:	fa890913          	addi	s2,s2,-88 # 8001a190 <log>
    800031f0:	854a                	mv	a0,s2
    800031f2:	678020ef          	jal	8000586a <acquire>
  if (log.lh.n >= LOGBLOCKS)
    800031f6:	02892603          	lw	a2,40(s2)
    800031fa:	47f5                	li	a5,29
    800031fc:	04c7cc63          	blt	a5,a2,80003254 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003200:	00017797          	auipc	a5,0x17
    80003204:	fac7a783          	lw	a5,-84(a5) # 8001a1ac <log+0x1c>
    80003208:	04f05c63          	blez	a5,80003260 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000320c:	4781                	li	a5,0
    8000320e:	04c05f63          	blez	a2,8000326c <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003212:	44cc                	lw	a1,12(s1)
    80003214:	00017717          	auipc	a4,0x17
    80003218:	fa870713          	addi	a4,a4,-88 # 8001a1bc <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    8000321c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000321e:	4314                	lw	a3,0(a4)
    80003220:	04b68663          	beq	a3,a1,8000326c <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003224:	2785                	addiw	a5,a5,1
    80003226:	0711                	addi	a4,a4,4
    80003228:	fef61be3          	bne	a2,a5,8000321e <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000322c:	0621                	addi	a2,a2,8
    8000322e:	060a                	slli	a2,a2,0x2
    80003230:	00017797          	auipc	a5,0x17
    80003234:	f6078793          	addi	a5,a5,-160 # 8001a190 <log>
    80003238:	97b2                	add	a5,a5,a2
    8000323a:	44d8                	lw	a4,12(s1)
    8000323c:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000323e:	8526                	mv	a0,s1
    80003240:	ef1fe0ef          	jal	80002130 <bpin>
    log.lh.n++;
    80003244:	00017717          	auipc	a4,0x17
    80003248:	f4c70713          	addi	a4,a4,-180 # 8001a190 <log>
    8000324c:	571c                	lw	a5,40(a4)
    8000324e:	2785                	addiw	a5,a5,1
    80003250:	d71c                	sw	a5,40(a4)
    80003252:	a80d                	j	80003284 <log_write+0xaa>
    panic("too big a transaction");
    80003254:	00004517          	auipc	a0,0x4
    80003258:	25c50513          	addi	a0,a0,604 # 800074b0 <etext+0x4b0>
    8000325c:	352020ef          	jal	800055ae <panic>
    panic("log_write outside of trans");
    80003260:	00004517          	auipc	a0,0x4
    80003264:	26850513          	addi	a0,a0,616 # 800074c8 <etext+0x4c8>
    80003268:	346020ef          	jal	800055ae <panic>
  log.lh.block[i] = b->blockno;
    8000326c:	00878693          	addi	a3,a5,8
    80003270:	068a                	slli	a3,a3,0x2
    80003272:	00017717          	auipc	a4,0x17
    80003276:	f1e70713          	addi	a4,a4,-226 # 8001a190 <log>
    8000327a:	9736                	add	a4,a4,a3
    8000327c:	44d4                	lw	a3,12(s1)
    8000327e:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003280:	faf60fe3          	beq	a2,a5,8000323e <log_write+0x64>
  }
  release(&log.lock);
    80003284:	00017517          	auipc	a0,0x17
    80003288:	f0c50513          	addi	a0,a0,-244 # 8001a190 <log>
    8000328c:	676020ef          	jal	80005902 <release>
}
    80003290:	60e2                	ld	ra,24(sp)
    80003292:	6442                	ld	s0,16(sp)
    80003294:	64a2                	ld	s1,8(sp)
    80003296:	6902                	ld	s2,0(sp)
    80003298:	6105                	addi	sp,sp,32
    8000329a:	8082                	ret

000000008000329c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000329c:	1101                	addi	sp,sp,-32
    8000329e:	ec06                	sd	ra,24(sp)
    800032a0:	e822                	sd	s0,16(sp)
    800032a2:	e426                	sd	s1,8(sp)
    800032a4:	e04a                	sd	s2,0(sp)
    800032a6:	1000                	addi	s0,sp,32
    800032a8:	84aa                	mv	s1,a0
    800032aa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800032ac:	00004597          	auipc	a1,0x4
    800032b0:	23c58593          	addi	a1,a1,572 # 800074e8 <etext+0x4e8>
    800032b4:	0521                	addi	a0,a0,8
    800032b6:	534020ef          	jal	800057ea <initlock>
  lk->name = name;
    800032ba:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800032be:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032c2:	0204a423          	sw	zero,40(s1)
}
    800032c6:	60e2                	ld	ra,24(sp)
    800032c8:	6442                	ld	s0,16(sp)
    800032ca:	64a2                	ld	s1,8(sp)
    800032cc:	6902                	ld	s2,0(sp)
    800032ce:	6105                	addi	sp,sp,32
    800032d0:	8082                	ret

00000000800032d2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800032d2:	1101                	addi	sp,sp,-32
    800032d4:	ec06                	sd	ra,24(sp)
    800032d6:	e822                	sd	s0,16(sp)
    800032d8:	e426                	sd	s1,8(sp)
    800032da:	e04a                	sd	s2,0(sp)
    800032dc:	1000                	addi	s0,sp,32
    800032de:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032e0:	00850913          	addi	s2,a0,8
    800032e4:	854a                	mv	a0,s2
    800032e6:	584020ef          	jal	8000586a <acquire>
  while (lk->locked) {
    800032ea:	409c                	lw	a5,0(s1)
    800032ec:	c799                	beqz	a5,800032fa <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800032ee:	85ca                	mv	a1,s2
    800032f0:	8526                	mv	a0,s1
    800032f2:	880fe0ef          	jal	80001372 <sleep>
  while (lk->locked) {
    800032f6:	409c                	lw	a5,0(s1)
    800032f8:	fbfd                	bnez	a5,800032ee <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032fa:	4785                	li	a5,1
    800032fc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032fe:	a7dfd0ef          	jal	80000d7a <myproc>
    80003302:	591c                	lw	a5,48(a0)
    80003304:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003306:	854a                	mv	a0,s2
    80003308:	5fa020ef          	jal	80005902 <release>
}
    8000330c:	60e2                	ld	ra,24(sp)
    8000330e:	6442                	ld	s0,16(sp)
    80003310:	64a2                	ld	s1,8(sp)
    80003312:	6902                	ld	s2,0(sp)
    80003314:	6105                	addi	sp,sp,32
    80003316:	8082                	ret

0000000080003318 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003318:	1101                	addi	sp,sp,-32
    8000331a:	ec06                	sd	ra,24(sp)
    8000331c:	e822                	sd	s0,16(sp)
    8000331e:	e426                	sd	s1,8(sp)
    80003320:	e04a                	sd	s2,0(sp)
    80003322:	1000                	addi	s0,sp,32
    80003324:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003326:	00850913          	addi	s2,a0,8
    8000332a:	854a                	mv	a0,s2
    8000332c:	53e020ef          	jal	8000586a <acquire>
  lk->locked = 0;
    80003330:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003334:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003338:	8526                	mv	a0,s1
    8000333a:	884fe0ef          	jal	800013be <wakeup>
  release(&lk->lk);
    8000333e:	854a                	mv	a0,s2
    80003340:	5c2020ef          	jal	80005902 <release>
}
    80003344:	60e2                	ld	ra,24(sp)
    80003346:	6442                	ld	s0,16(sp)
    80003348:	64a2                	ld	s1,8(sp)
    8000334a:	6902                	ld	s2,0(sp)
    8000334c:	6105                	addi	sp,sp,32
    8000334e:	8082                	ret

0000000080003350 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003350:	7179                	addi	sp,sp,-48
    80003352:	f406                	sd	ra,40(sp)
    80003354:	f022                	sd	s0,32(sp)
    80003356:	ec26                	sd	s1,24(sp)
    80003358:	e84a                	sd	s2,16(sp)
    8000335a:	1800                	addi	s0,sp,48
    8000335c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000335e:	00850913          	addi	s2,a0,8
    80003362:	854a                	mv	a0,s2
    80003364:	506020ef          	jal	8000586a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003368:	409c                	lw	a5,0(s1)
    8000336a:	ef81                	bnez	a5,80003382 <holdingsleep+0x32>
    8000336c:	4481                	li	s1,0
  release(&lk->lk);
    8000336e:	854a                	mv	a0,s2
    80003370:	592020ef          	jal	80005902 <release>
  return r;
}
    80003374:	8526                	mv	a0,s1
    80003376:	70a2                	ld	ra,40(sp)
    80003378:	7402                	ld	s0,32(sp)
    8000337a:	64e2                	ld	s1,24(sp)
    8000337c:	6942                	ld	s2,16(sp)
    8000337e:	6145                	addi	sp,sp,48
    80003380:	8082                	ret
    80003382:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003384:	0284a983          	lw	s3,40(s1)
    80003388:	9f3fd0ef          	jal	80000d7a <myproc>
    8000338c:	5904                	lw	s1,48(a0)
    8000338e:	413484b3          	sub	s1,s1,s3
    80003392:	0014b493          	seqz	s1,s1
    80003396:	69a2                	ld	s3,8(sp)
    80003398:	bfd9                	j	8000336e <holdingsleep+0x1e>

000000008000339a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000339a:	1141                	addi	sp,sp,-16
    8000339c:	e406                	sd	ra,8(sp)
    8000339e:	e022                	sd	s0,0(sp)
    800033a0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800033a2:	00004597          	auipc	a1,0x4
    800033a6:	15658593          	addi	a1,a1,342 # 800074f8 <etext+0x4f8>
    800033aa:	00017517          	auipc	a0,0x17
    800033ae:	f2e50513          	addi	a0,a0,-210 # 8001a2d8 <ftable>
    800033b2:	438020ef          	jal	800057ea <initlock>
}
    800033b6:	60a2                	ld	ra,8(sp)
    800033b8:	6402                	ld	s0,0(sp)
    800033ba:	0141                	addi	sp,sp,16
    800033bc:	8082                	ret

00000000800033be <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800033be:	1101                	addi	sp,sp,-32
    800033c0:	ec06                	sd	ra,24(sp)
    800033c2:	e822                	sd	s0,16(sp)
    800033c4:	e426                	sd	s1,8(sp)
    800033c6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800033c8:	00017517          	auipc	a0,0x17
    800033cc:	f1050513          	addi	a0,a0,-240 # 8001a2d8 <ftable>
    800033d0:	49a020ef          	jal	8000586a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033d4:	00017497          	auipc	s1,0x17
    800033d8:	f1c48493          	addi	s1,s1,-228 # 8001a2f0 <ftable+0x18>
    800033dc:	00018717          	auipc	a4,0x18
    800033e0:	eb470713          	addi	a4,a4,-332 # 8001b290 <disk>
    if(f->ref == 0){
    800033e4:	40dc                	lw	a5,4(s1)
    800033e6:	cf89                	beqz	a5,80003400 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033e8:	02848493          	addi	s1,s1,40
    800033ec:	fee49ce3          	bne	s1,a4,800033e4 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800033f0:	00017517          	auipc	a0,0x17
    800033f4:	ee850513          	addi	a0,a0,-280 # 8001a2d8 <ftable>
    800033f8:	50a020ef          	jal	80005902 <release>
  return 0;
    800033fc:	4481                	li	s1,0
    800033fe:	a809                	j	80003410 <filealloc+0x52>
      f->ref = 1;
    80003400:	4785                	li	a5,1
    80003402:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003404:	00017517          	auipc	a0,0x17
    80003408:	ed450513          	addi	a0,a0,-300 # 8001a2d8 <ftable>
    8000340c:	4f6020ef          	jal	80005902 <release>
}
    80003410:	8526                	mv	a0,s1
    80003412:	60e2                	ld	ra,24(sp)
    80003414:	6442                	ld	s0,16(sp)
    80003416:	64a2                	ld	s1,8(sp)
    80003418:	6105                	addi	sp,sp,32
    8000341a:	8082                	ret

000000008000341c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000341c:	1101                	addi	sp,sp,-32
    8000341e:	ec06                	sd	ra,24(sp)
    80003420:	e822                	sd	s0,16(sp)
    80003422:	e426                	sd	s1,8(sp)
    80003424:	1000                	addi	s0,sp,32
    80003426:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003428:	00017517          	auipc	a0,0x17
    8000342c:	eb050513          	addi	a0,a0,-336 # 8001a2d8 <ftable>
    80003430:	43a020ef          	jal	8000586a <acquire>
  if(f->ref < 1)
    80003434:	40dc                	lw	a5,4(s1)
    80003436:	02f05063          	blez	a5,80003456 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000343a:	2785                	addiw	a5,a5,1
    8000343c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000343e:	00017517          	auipc	a0,0x17
    80003442:	e9a50513          	addi	a0,a0,-358 # 8001a2d8 <ftable>
    80003446:	4bc020ef          	jal	80005902 <release>
  return f;
}
    8000344a:	8526                	mv	a0,s1
    8000344c:	60e2                	ld	ra,24(sp)
    8000344e:	6442                	ld	s0,16(sp)
    80003450:	64a2                	ld	s1,8(sp)
    80003452:	6105                	addi	sp,sp,32
    80003454:	8082                	ret
    panic("filedup");
    80003456:	00004517          	auipc	a0,0x4
    8000345a:	0aa50513          	addi	a0,a0,170 # 80007500 <etext+0x500>
    8000345e:	150020ef          	jal	800055ae <panic>

0000000080003462 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003462:	7139                	addi	sp,sp,-64
    80003464:	fc06                	sd	ra,56(sp)
    80003466:	f822                	sd	s0,48(sp)
    80003468:	f426                	sd	s1,40(sp)
    8000346a:	0080                	addi	s0,sp,64
    8000346c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000346e:	00017517          	auipc	a0,0x17
    80003472:	e6a50513          	addi	a0,a0,-406 # 8001a2d8 <ftable>
    80003476:	3f4020ef          	jal	8000586a <acquire>
  if(f->ref < 1)
    8000347a:	40dc                	lw	a5,4(s1)
    8000347c:	04f05a63          	blez	a5,800034d0 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003480:	37fd                	addiw	a5,a5,-1
    80003482:	0007871b          	sext.w	a4,a5
    80003486:	c0dc                	sw	a5,4(s1)
    80003488:	04e04e63          	bgtz	a4,800034e4 <fileclose+0x82>
    8000348c:	f04a                	sd	s2,32(sp)
    8000348e:	ec4e                	sd	s3,24(sp)
    80003490:	e852                	sd	s4,16(sp)
    80003492:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003494:	0004a903          	lw	s2,0(s1)
    80003498:	0094ca83          	lbu	s5,9(s1)
    8000349c:	0104ba03          	ld	s4,16(s1)
    800034a0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800034a4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800034a8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800034ac:	00017517          	auipc	a0,0x17
    800034b0:	e2c50513          	addi	a0,a0,-468 # 8001a2d8 <ftable>
    800034b4:	44e020ef          	jal	80005902 <release>

  if(ff.type == FD_PIPE){
    800034b8:	4785                	li	a5,1
    800034ba:	04f90063          	beq	s2,a5,800034fa <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800034be:	3979                	addiw	s2,s2,-2
    800034c0:	4785                	li	a5,1
    800034c2:	0527f563          	bgeu	a5,s2,8000350c <fileclose+0xaa>
    800034c6:	7902                	ld	s2,32(sp)
    800034c8:	69e2                	ld	s3,24(sp)
    800034ca:	6a42                	ld	s4,16(sp)
    800034cc:	6aa2                	ld	s5,8(sp)
    800034ce:	a00d                	j	800034f0 <fileclose+0x8e>
    800034d0:	f04a                	sd	s2,32(sp)
    800034d2:	ec4e                	sd	s3,24(sp)
    800034d4:	e852                	sd	s4,16(sp)
    800034d6:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800034d8:	00004517          	auipc	a0,0x4
    800034dc:	03050513          	addi	a0,a0,48 # 80007508 <etext+0x508>
    800034e0:	0ce020ef          	jal	800055ae <panic>
    release(&ftable.lock);
    800034e4:	00017517          	auipc	a0,0x17
    800034e8:	df450513          	addi	a0,a0,-524 # 8001a2d8 <ftable>
    800034ec:	416020ef          	jal	80005902 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800034f0:	70e2                	ld	ra,56(sp)
    800034f2:	7442                	ld	s0,48(sp)
    800034f4:	74a2                	ld	s1,40(sp)
    800034f6:	6121                	addi	sp,sp,64
    800034f8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034fa:	85d6                	mv	a1,s5
    800034fc:	8552                	mv	a0,s4
    800034fe:	336000ef          	jal	80003834 <pipeclose>
    80003502:	7902                	ld	s2,32(sp)
    80003504:	69e2                	ld	s3,24(sp)
    80003506:	6a42                	ld	s4,16(sp)
    80003508:	6aa2                	ld	s5,8(sp)
    8000350a:	b7dd                	j	800034f0 <fileclose+0x8e>
    begin_op();
    8000350c:	b4bff0ef          	jal	80003056 <begin_op>
    iput(ff.ip);
    80003510:	854e                	mv	a0,s3
    80003512:	adcff0ef          	jal	800027ee <iput>
    end_op();
    80003516:	babff0ef          	jal	800030c0 <end_op>
    8000351a:	7902                	ld	s2,32(sp)
    8000351c:	69e2                	ld	s3,24(sp)
    8000351e:	6a42                	ld	s4,16(sp)
    80003520:	6aa2                	ld	s5,8(sp)
    80003522:	b7f9                	j	800034f0 <fileclose+0x8e>

0000000080003524 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003524:	715d                	addi	sp,sp,-80
    80003526:	e486                	sd	ra,72(sp)
    80003528:	e0a2                	sd	s0,64(sp)
    8000352a:	fc26                	sd	s1,56(sp)
    8000352c:	f44e                	sd	s3,40(sp)
    8000352e:	0880                	addi	s0,sp,80
    80003530:	84aa                	mv	s1,a0
    80003532:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003534:	847fd0ef          	jal	80000d7a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003538:	409c                	lw	a5,0(s1)
    8000353a:	37f9                	addiw	a5,a5,-2
    8000353c:	4705                	li	a4,1
    8000353e:	04f76063          	bltu	a4,a5,8000357e <filestat+0x5a>
    80003542:	f84a                	sd	s2,48(sp)
    80003544:	892a                	mv	s2,a0
    ilock(f->ip);
    80003546:	6c88                	ld	a0,24(s1)
    80003548:	924ff0ef          	jal	8000266c <ilock>
    stati(f->ip, &st);
    8000354c:	fb840593          	addi	a1,s0,-72
    80003550:	6c88                	ld	a0,24(s1)
    80003552:	c80ff0ef          	jal	800029d2 <stati>
    iunlock(f->ip);
    80003556:	6c88                	ld	a0,24(s1)
    80003558:	9c2ff0ef          	jal	8000271a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000355c:	46e1                	li	a3,24
    8000355e:	fb840613          	addi	a2,s0,-72
    80003562:	85ce                	mv	a1,s3
    80003564:	05093503          	ld	a0,80(s2)
    80003568:	d26fd0ef          	jal	80000a8e <copyout>
    8000356c:	41f5551b          	sraiw	a0,a0,0x1f
    80003570:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003572:	60a6                	ld	ra,72(sp)
    80003574:	6406                	ld	s0,64(sp)
    80003576:	74e2                	ld	s1,56(sp)
    80003578:	79a2                	ld	s3,40(sp)
    8000357a:	6161                	addi	sp,sp,80
    8000357c:	8082                	ret
  return -1;
    8000357e:	557d                	li	a0,-1
    80003580:	bfcd                	j	80003572 <filestat+0x4e>

0000000080003582 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003582:	7179                	addi	sp,sp,-48
    80003584:	f406                	sd	ra,40(sp)
    80003586:	f022                	sd	s0,32(sp)
    80003588:	e84a                	sd	s2,16(sp)
    8000358a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000358c:	00854783          	lbu	a5,8(a0)
    80003590:	cfd1                	beqz	a5,8000362c <fileread+0xaa>
    80003592:	ec26                	sd	s1,24(sp)
    80003594:	e44e                	sd	s3,8(sp)
    80003596:	84aa                	mv	s1,a0
    80003598:	89ae                	mv	s3,a1
    8000359a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000359c:	411c                	lw	a5,0(a0)
    8000359e:	4705                	li	a4,1
    800035a0:	04e78363          	beq	a5,a4,800035e6 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035a4:	470d                	li	a4,3
    800035a6:	04e78763          	beq	a5,a4,800035f4 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800035aa:	4709                	li	a4,2
    800035ac:	06e79a63          	bne	a5,a4,80003620 <fileread+0x9e>
    ilock(f->ip);
    800035b0:	6d08                	ld	a0,24(a0)
    800035b2:	8baff0ef          	jal	8000266c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800035b6:	874a                	mv	a4,s2
    800035b8:	5094                	lw	a3,32(s1)
    800035ba:	864e                	mv	a2,s3
    800035bc:	4585                	li	a1,1
    800035be:	6c88                	ld	a0,24(s1)
    800035c0:	c3cff0ef          	jal	800029fc <readi>
    800035c4:	892a                	mv	s2,a0
    800035c6:	00a05563          	blez	a0,800035d0 <fileread+0x4e>
      f->off += r;
    800035ca:	509c                	lw	a5,32(s1)
    800035cc:	9fa9                	addw	a5,a5,a0
    800035ce:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800035d0:	6c88                	ld	a0,24(s1)
    800035d2:	948ff0ef          	jal	8000271a <iunlock>
    800035d6:	64e2                	ld	s1,24(sp)
    800035d8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800035da:	854a                	mv	a0,s2
    800035dc:	70a2                	ld	ra,40(sp)
    800035de:	7402                	ld	s0,32(sp)
    800035e0:	6942                	ld	s2,16(sp)
    800035e2:	6145                	addi	sp,sp,48
    800035e4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800035e6:	6908                	ld	a0,16(a0)
    800035e8:	388000ef          	jal	80003970 <piperead>
    800035ec:	892a                	mv	s2,a0
    800035ee:	64e2                	ld	s1,24(sp)
    800035f0:	69a2                	ld	s3,8(sp)
    800035f2:	b7e5                	j	800035da <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800035f4:	02451783          	lh	a5,36(a0)
    800035f8:	03079693          	slli	a3,a5,0x30
    800035fc:	92c1                	srli	a3,a3,0x30
    800035fe:	4725                	li	a4,9
    80003600:	02d76863          	bltu	a4,a3,80003630 <fileread+0xae>
    80003604:	0792                	slli	a5,a5,0x4
    80003606:	00017717          	auipc	a4,0x17
    8000360a:	c3270713          	addi	a4,a4,-974 # 8001a238 <devsw>
    8000360e:	97ba                	add	a5,a5,a4
    80003610:	639c                	ld	a5,0(a5)
    80003612:	c39d                	beqz	a5,80003638 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003614:	4505                	li	a0,1
    80003616:	9782                	jalr	a5
    80003618:	892a                	mv	s2,a0
    8000361a:	64e2                	ld	s1,24(sp)
    8000361c:	69a2                	ld	s3,8(sp)
    8000361e:	bf75                	j	800035da <fileread+0x58>
    panic("fileread");
    80003620:	00004517          	auipc	a0,0x4
    80003624:	ef850513          	addi	a0,a0,-264 # 80007518 <etext+0x518>
    80003628:	787010ef          	jal	800055ae <panic>
    return -1;
    8000362c:	597d                	li	s2,-1
    8000362e:	b775                	j	800035da <fileread+0x58>
      return -1;
    80003630:	597d                	li	s2,-1
    80003632:	64e2                	ld	s1,24(sp)
    80003634:	69a2                	ld	s3,8(sp)
    80003636:	b755                	j	800035da <fileread+0x58>
    80003638:	597d                	li	s2,-1
    8000363a:	64e2                	ld	s1,24(sp)
    8000363c:	69a2                	ld	s3,8(sp)
    8000363e:	bf71                	j	800035da <fileread+0x58>

0000000080003640 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003640:	00954783          	lbu	a5,9(a0)
    80003644:	10078b63          	beqz	a5,8000375a <filewrite+0x11a>
{
    80003648:	715d                	addi	sp,sp,-80
    8000364a:	e486                	sd	ra,72(sp)
    8000364c:	e0a2                	sd	s0,64(sp)
    8000364e:	f84a                	sd	s2,48(sp)
    80003650:	f052                	sd	s4,32(sp)
    80003652:	e85a                	sd	s6,16(sp)
    80003654:	0880                	addi	s0,sp,80
    80003656:	892a                	mv	s2,a0
    80003658:	8b2e                	mv	s6,a1
    8000365a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000365c:	411c                	lw	a5,0(a0)
    8000365e:	4705                	li	a4,1
    80003660:	02e78763          	beq	a5,a4,8000368e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003664:	470d                	li	a4,3
    80003666:	02e78863          	beq	a5,a4,80003696 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000366a:	4709                	li	a4,2
    8000366c:	0ce79c63          	bne	a5,a4,80003744 <filewrite+0x104>
    80003670:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003672:	0ac05863          	blez	a2,80003722 <filewrite+0xe2>
    80003676:	fc26                	sd	s1,56(sp)
    80003678:	ec56                	sd	s5,24(sp)
    8000367a:	e45e                	sd	s7,8(sp)
    8000367c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000367e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003680:	6b85                	lui	s7,0x1
    80003682:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003686:	6c05                	lui	s8,0x1
    80003688:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000368c:	a8b5                	j	80003708 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000368e:	6908                	ld	a0,16(a0)
    80003690:	1fc000ef          	jal	8000388c <pipewrite>
    80003694:	a04d                	j	80003736 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003696:	02451783          	lh	a5,36(a0)
    8000369a:	03079693          	slli	a3,a5,0x30
    8000369e:	92c1                	srli	a3,a3,0x30
    800036a0:	4725                	li	a4,9
    800036a2:	0ad76e63          	bltu	a4,a3,8000375e <filewrite+0x11e>
    800036a6:	0792                	slli	a5,a5,0x4
    800036a8:	00017717          	auipc	a4,0x17
    800036ac:	b9070713          	addi	a4,a4,-1136 # 8001a238 <devsw>
    800036b0:	97ba                	add	a5,a5,a4
    800036b2:	679c                	ld	a5,8(a5)
    800036b4:	c7dd                	beqz	a5,80003762 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800036b6:	4505                	li	a0,1
    800036b8:	9782                	jalr	a5
    800036ba:	a8b5                	j	80003736 <filewrite+0xf6>
      if(n1 > max)
    800036bc:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800036c0:	997ff0ef          	jal	80003056 <begin_op>
      ilock(f->ip);
    800036c4:	01893503          	ld	a0,24(s2)
    800036c8:	fa5fe0ef          	jal	8000266c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036cc:	8756                	mv	a4,s5
    800036ce:	02092683          	lw	a3,32(s2)
    800036d2:	01698633          	add	a2,s3,s6
    800036d6:	4585                	li	a1,1
    800036d8:	01893503          	ld	a0,24(s2)
    800036dc:	c1cff0ef          	jal	80002af8 <writei>
    800036e0:	84aa                	mv	s1,a0
    800036e2:	00a05763          	blez	a0,800036f0 <filewrite+0xb0>
        f->off += r;
    800036e6:	02092783          	lw	a5,32(s2)
    800036ea:	9fa9                	addw	a5,a5,a0
    800036ec:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800036f0:	01893503          	ld	a0,24(s2)
    800036f4:	826ff0ef          	jal	8000271a <iunlock>
      end_op();
    800036f8:	9c9ff0ef          	jal	800030c0 <end_op>

      if(r != n1){
    800036fc:	029a9563          	bne	s5,s1,80003726 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003700:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003704:	0149da63          	bge	s3,s4,80003718 <filewrite+0xd8>
      int n1 = n - i;
    80003708:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000370c:	0004879b          	sext.w	a5,s1
    80003710:	fafbd6e3          	bge	s7,a5,800036bc <filewrite+0x7c>
    80003714:	84e2                	mv	s1,s8
    80003716:	b75d                	j	800036bc <filewrite+0x7c>
    80003718:	74e2                	ld	s1,56(sp)
    8000371a:	6ae2                	ld	s5,24(sp)
    8000371c:	6ba2                	ld	s7,8(sp)
    8000371e:	6c02                	ld	s8,0(sp)
    80003720:	a039                	j	8000372e <filewrite+0xee>
    int i = 0;
    80003722:	4981                	li	s3,0
    80003724:	a029                	j	8000372e <filewrite+0xee>
    80003726:	74e2                	ld	s1,56(sp)
    80003728:	6ae2                	ld	s5,24(sp)
    8000372a:	6ba2                	ld	s7,8(sp)
    8000372c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000372e:	033a1c63          	bne	s4,s3,80003766 <filewrite+0x126>
    80003732:	8552                	mv	a0,s4
    80003734:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003736:	60a6                	ld	ra,72(sp)
    80003738:	6406                	ld	s0,64(sp)
    8000373a:	7942                	ld	s2,48(sp)
    8000373c:	7a02                	ld	s4,32(sp)
    8000373e:	6b42                	ld	s6,16(sp)
    80003740:	6161                	addi	sp,sp,80
    80003742:	8082                	ret
    80003744:	fc26                	sd	s1,56(sp)
    80003746:	f44e                	sd	s3,40(sp)
    80003748:	ec56                	sd	s5,24(sp)
    8000374a:	e45e                	sd	s7,8(sp)
    8000374c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000374e:	00004517          	auipc	a0,0x4
    80003752:	dda50513          	addi	a0,a0,-550 # 80007528 <etext+0x528>
    80003756:	659010ef          	jal	800055ae <panic>
    return -1;
    8000375a:	557d                	li	a0,-1
}
    8000375c:	8082                	ret
      return -1;
    8000375e:	557d                	li	a0,-1
    80003760:	bfd9                	j	80003736 <filewrite+0xf6>
    80003762:	557d                	li	a0,-1
    80003764:	bfc9                	j	80003736 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003766:	557d                	li	a0,-1
    80003768:	79a2                	ld	s3,40(sp)
    8000376a:	b7f1                	j	80003736 <filewrite+0xf6>

000000008000376c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000376c:	7179                	addi	sp,sp,-48
    8000376e:	f406                	sd	ra,40(sp)
    80003770:	f022                	sd	s0,32(sp)
    80003772:	ec26                	sd	s1,24(sp)
    80003774:	e052                	sd	s4,0(sp)
    80003776:	1800                	addi	s0,sp,48
    80003778:	84aa                	mv	s1,a0
    8000377a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000377c:	0005b023          	sd	zero,0(a1)
    80003780:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003784:	c3bff0ef          	jal	800033be <filealloc>
    80003788:	e088                	sd	a0,0(s1)
    8000378a:	c549                	beqz	a0,80003814 <pipealloc+0xa8>
    8000378c:	c33ff0ef          	jal	800033be <filealloc>
    80003790:	00aa3023          	sd	a0,0(s4)
    80003794:	cd25                	beqz	a0,8000380c <pipealloc+0xa0>
    80003796:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003798:	967fc0ef          	jal	800000fe <kalloc>
    8000379c:	892a                	mv	s2,a0
    8000379e:	c12d                	beqz	a0,80003800 <pipealloc+0x94>
    800037a0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800037a2:	4985                	li	s3,1
    800037a4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037a8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037ac:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037b0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037b4:	00004597          	auipc	a1,0x4
    800037b8:	d8458593          	addi	a1,a1,-636 # 80007538 <etext+0x538>
    800037bc:	02e020ef          	jal	800057ea <initlock>
  (*f0)->type = FD_PIPE;
    800037c0:	609c                	ld	a5,0(s1)
    800037c2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800037c6:	609c                	ld	a5,0(s1)
    800037c8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800037cc:	609c                	ld	a5,0(s1)
    800037ce:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800037d2:	609c                	ld	a5,0(s1)
    800037d4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800037d8:	000a3783          	ld	a5,0(s4)
    800037dc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800037e0:	000a3783          	ld	a5,0(s4)
    800037e4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800037e8:	000a3783          	ld	a5,0(s4)
    800037ec:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800037f0:	000a3783          	ld	a5,0(s4)
    800037f4:	0127b823          	sd	s2,16(a5)
  return 0;
    800037f8:	4501                	li	a0,0
    800037fa:	6942                	ld	s2,16(sp)
    800037fc:	69a2                	ld	s3,8(sp)
    800037fe:	a01d                	j	80003824 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003800:	6088                	ld	a0,0(s1)
    80003802:	c119                	beqz	a0,80003808 <pipealloc+0x9c>
    80003804:	6942                	ld	s2,16(sp)
    80003806:	a029                	j	80003810 <pipealloc+0xa4>
    80003808:	6942                	ld	s2,16(sp)
    8000380a:	a029                	j	80003814 <pipealloc+0xa8>
    8000380c:	6088                	ld	a0,0(s1)
    8000380e:	c10d                	beqz	a0,80003830 <pipealloc+0xc4>
    fileclose(*f0);
    80003810:	c53ff0ef          	jal	80003462 <fileclose>
  if(*f1)
    80003814:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003818:	557d                	li	a0,-1
  if(*f1)
    8000381a:	c789                	beqz	a5,80003824 <pipealloc+0xb8>
    fileclose(*f1);
    8000381c:	853e                	mv	a0,a5
    8000381e:	c45ff0ef          	jal	80003462 <fileclose>
  return -1;
    80003822:	557d                	li	a0,-1
}
    80003824:	70a2                	ld	ra,40(sp)
    80003826:	7402                	ld	s0,32(sp)
    80003828:	64e2                	ld	s1,24(sp)
    8000382a:	6a02                	ld	s4,0(sp)
    8000382c:	6145                	addi	sp,sp,48
    8000382e:	8082                	ret
  return -1;
    80003830:	557d                	li	a0,-1
    80003832:	bfcd                	j	80003824 <pipealloc+0xb8>

0000000080003834 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003834:	1101                	addi	sp,sp,-32
    80003836:	ec06                	sd	ra,24(sp)
    80003838:	e822                	sd	s0,16(sp)
    8000383a:	e426                	sd	s1,8(sp)
    8000383c:	e04a                	sd	s2,0(sp)
    8000383e:	1000                	addi	s0,sp,32
    80003840:	84aa                	mv	s1,a0
    80003842:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003844:	026020ef          	jal	8000586a <acquire>
  if(writable){
    80003848:	02090763          	beqz	s2,80003876 <pipeclose+0x42>
    pi->writeopen = 0;
    8000384c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003850:	21848513          	addi	a0,s1,536
    80003854:	b6bfd0ef          	jal	800013be <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003858:	2204b783          	ld	a5,544(s1)
    8000385c:	e785                	bnez	a5,80003884 <pipeclose+0x50>
    release(&pi->lock);
    8000385e:	8526                	mv	a0,s1
    80003860:	0a2020ef          	jal	80005902 <release>
    kfree((char*)pi);
    80003864:	8526                	mv	a0,s1
    80003866:	fb6fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000386a:	60e2                	ld	ra,24(sp)
    8000386c:	6442                	ld	s0,16(sp)
    8000386e:	64a2                	ld	s1,8(sp)
    80003870:	6902                	ld	s2,0(sp)
    80003872:	6105                	addi	sp,sp,32
    80003874:	8082                	ret
    pi->readopen = 0;
    80003876:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000387a:	21c48513          	addi	a0,s1,540
    8000387e:	b41fd0ef          	jal	800013be <wakeup>
    80003882:	bfd9                	j	80003858 <pipeclose+0x24>
    release(&pi->lock);
    80003884:	8526                	mv	a0,s1
    80003886:	07c020ef          	jal	80005902 <release>
}
    8000388a:	b7c5                	j	8000386a <pipeclose+0x36>

000000008000388c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000388c:	711d                	addi	sp,sp,-96
    8000388e:	ec86                	sd	ra,88(sp)
    80003890:	e8a2                	sd	s0,80(sp)
    80003892:	e4a6                	sd	s1,72(sp)
    80003894:	e0ca                	sd	s2,64(sp)
    80003896:	fc4e                	sd	s3,56(sp)
    80003898:	f852                	sd	s4,48(sp)
    8000389a:	f456                	sd	s5,40(sp)
    8000389c:	1080                	addi	s0,sp,96
    8000389e:	84aa                	mv	s1,a0
    800038a0:	8aae                	mv	s5,a1
    800038a2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038a4:	cd6fd0ef          	jal	80000d7a <myproc>
    800038a8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038aa:	8526                	mv	a0,s1
    800038ac:	7bf010ef          	jal	8000586a <acquire>
  while(i < n){
    800038b0:	0b405a63          	blez	s4,80003964 <pipewrite+0xd8>
    800038b4:	f05a                	sd	s6,32(sp)
    800038b6:	ec5e                	sd	s7,24(sp)
    800038b8:	e862                	sd	s8,16(sp)
  int i = 0;
    800038ba:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038bc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800038be:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800038c2:	21c48b93          	addi	s7,s1,540
    800038c6:	a81d                	j	800038fc <pipewrite+0x70>
      release(&pi->lock);
    800038c8:	8526                	mv	a0,s1
    800038ca:	038020ef          	jal	80005902 <release>
      return -1;
    800038ce:	597d                	li	s2,-1
    800038d0:	7b02                	ld	s6,32(sp)
    800038d2:	6be2                	ld	s7,24(sp)
    800038d4:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800038d6:	854a                	mv	a0,s2
    800038d8:	60e6                	ld	ra,88(sp)
    800038da:	6446                	ld	s0,80(sp)
    800038dc:	64a6                	ld	s1,72(sp)
    800038de:	6906                	ld	s2,64(sp)
    800038e0:	79e2                	ld	s3,56(sp)
    800038e2:	7a42                	ld	s4,48(sp)
    800038e4:	7aa2                	ld	s5,40(sp)
    800038e6:	6125                	addi	sp,sp,96
    800038e8:	8082                	ret
      wakeup(&pi->nread);
    800038ea:	8562                	mv	a0,s8
    800038ec:	ad3fd0ef          	jal	800013be <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800038f0:	85a6                	mv	a1,s1
    800038f2:	855e                	mv	a0,s7
    800038f4:	a7ffd0ef          	jal	80001372 <sleep>
  while(i < n){
    800038f8:	05495b63          	bge	s2,s4,8000394e <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800038fc:	2204a783          	lw	a5,544(s1)
    80003900:	d7e1                	beqz	a5,800038c8 <pipewrite+0x3c>
    80003902:	854e                	mv	a0,s3
    80003904:	ca7fd0ef          	jal	800015aa <killed>
    80003908:	f161                	bnez	a0,800038c8 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000390a:	2184a783          	lw	a5,536(s1)
    8000390e:	21c4a703          	lw	a4,540(s1)
    80003912:	2007879b          	addiw	a5,a5,512
    80003916:	fcf70ae3          	beq	a4,a5,800038ea <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000391a:	4685                	li	a3,1
    8000391c:	01590633          	add	a2,s2,s5
    80003920:	faf40593          	addi	a1,s0,-81
    80003924:	0509b503          	ld	a0,80(s3)
    80003928:	a4afd0ef          	jal	80000b72 <copyin>
    8000392c:	03650e63          	beq	a0,s6,80003968 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003930:	21c4a783          	lw	a5,540(s1)
    80003934:	0017871b          	addiw	a4,a5,1
    80003938:	20e4ae23          	sw	a4,540(s1)
    8000393c:	1ff7f793          	andi	a5,a5,511
    80003940:	97a6                	add	a5,a5,s1
    80003942:	faf44703          	lbu	a4,-81(s0)
    80003946:	00e78c23          	sb	a4,24(a5)
      i++;
    8000394a:	2905                	addiw	s2,s2,1
    8000394c:	b775                	j	800038f8 <pipewrite+0x6c>
    8000394e:	7b02                	ld	s6,32(sp)
    80003950:	6be2                	ld	s7,24(sp)
    80003952:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003954:	21848513          	addi	a0,s1,536
    80003958:	a67fd0ef          	jal	800013be <wakeup>
  release(&pi->lock);
    8000395c:	8526                	mv	a0,s1
    8000395e:	7a5010ef          	jal	80005902 <release>
  return i;
    80003962:	bf95                	j	800038d6 <pipewrite+0x4a>
  int i = 0;
    80003964:	4901                	li	s2,0
    80003966:	b7fd                	j	80003954 <pipewrite+0xc8>
    80003968:	7b02                	ld	s6,32(sp)
    8000396a:	6be2                	ld	s7,24(sp)
    8000396c:	6c42                	ld	s8,16(sp)
    8000396e:	b7dd                	j	80003954 <pipewrite+0xc8>

0000000080003970 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003970:	715d                	addi	sp,sp,-80
    80003972:	e486                	sd	ra,72(sp)
    80003974:	e0a2                	sd	s0,64(sp)
    80003976:	fc26                	sd	s1,56(sp)
    80003978:	f84a                	sd	s2,48(sp)
    8000397a:	f44e                	sd	s3,40(sp)
    8000397c:	f052                	sd	s4,32(sp)
    8000397e:	ec56                	sd	s5,24(sp)
    80003980:	0880                	addi	s0,sp,80
    80003982:	84aa                	mv	s1,a0
    80003984:	892e                	mv	s2,a1
    80003986:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003988:	bf2fd0ef          	jal	80000d7a <myproc>
    8000398c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000398e:	8526                	mv	a0,s1
    80003990:	6db010ef          	jal	8000586a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003994:	2184a703          	lw	a4,536(s1)
    80003998:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000399c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039a0:	02f71563          	bne	a4,a5,800039ca <piperead+0x5a>
    800039a4:	2244a783          	lw	a5,548(s1)
    800039a8:	cb85                	beqz	a5,800039d8 <piperead+0x68>
    if(killed(pr)){
    800039aa:	8552                	mv	a0,s4
    800039ac:	bfffd0ef          	jal	800015aa <killed>
    800039b0:	ed19                	bnez	a0,800039ce <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039b2:	85a6                	mv	a1,s1
    800039b4:	854e                	mv	a0,s3
    800039b6:	9bdfd0ef          	jal	80001372 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039ba:	2184a703          	lw	a4,536(s1)
    800039be:	21c4a783          	lw	a5,540(s1)
    800039c2:	fef701e3          	beq	a4,a5,800039a4 <piperead+0x34>
    800039c6:	e85a                	sd	s6,16(sp)
    800039c8:	a809                	j	800039da <piperead+0x6a>
    800039ca:	e85a                	sd	s6,16(sp)
    800039cc:	a039                	j	800039da <piperead+0x6a>
      release(&pi->lock);
    800039ce:	8526                	mv	a0,s1
    800039d0:	733010ef          	jal	80005902 <release>
      return -1;
    800039d4:	59fd                	li	s3,-1
    800039d6:	a8b1                	j	80003a32 <piperead+0xc2>
    800039d8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039da:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039dc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039de:	05505263          	blez	s5,80003a22 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800039e2:	2184a783          	lw	a5,536(s1)
    800039e6:	21c4a703          	lw	a4,540(s1)
    800039ea:	02f70c63          	beq	a4,a5,80003a22 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800039ee:	0017871b          	addiw	a4,a5,1
    800039f2:	20e4ac23          	sw	a4,536(s1)
    800039f6:	1ff7f793          	andi	a5,a5,511
    800039fa:	97a6                	add	a5,a5,s1
    800039fc:	0187c783          	lbu	a5,24(a5)
    80003a00:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a04:	4685                	li	a3,1
    80003a06:	fbf40613          	addi	a2,s0,-65
    80003a0a:	85ca                	mv	a1,s2
    80003a0c:	050a3503          	ld	a0,80(s4)
    80003a10:	87efd0ef          	jal	80000a8e <copyout>
    80003a14:	01650763          	beq	a0,s6,80003a22 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a18:	2985                	addiw	s3,s3,1
    80003a1a:	0905                	addi	s2,s2,1
    80003a1c:	fd3a93e3          	bne	s5,s3,800039e2 <piperead+0x72>
    80003a20:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a22:	21c48513          	addi	a0,s1,540
    80003a26:	999fd0ef          	jal	800013be <wakeup>
  release(&pi->lock);
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	6d7010ef          	jal	80005902 <release>
    80003a30:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a32:	854e                	mv	a0,s3
    80003a34:	60a6                	ld	ra,72(sp)
    80003a36:	6406                	ld	s0,64(sp)
    80003a38:	74e2                	ld	s1,56(sp)
    80003a3a:	7942                	ld	s2,48(sp)
    80003a3c:	79a2                	ld	s3,40(sp)
    80003a3e:	7a02                	ld	s4,32(sp)
    80003a40:	6ae2                	ld	s5,24(sp)
    80003a42:	6161                	addi	sp,sp,80
    80003a44:	8082                	ret

0000000080003a46 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003a46:	1141                	addi	sp,sp,-16
    80003a48:	e422                	sd	s0,8(sp)
    80003a4a:	0800                	addi	s0,sp,16
    80003a4c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a4e:	8905                	andi	a0,a0,1
    80003a50:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003a52:	8b89                	andi	a5,a5,2
    80003a54:	c399                	beqz	a5,80003a5a <flags2perm+0x14>
      perm |= PTE_W;
    80003a56:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a5a:	6422                	ld	s0,8(sp)
    80003a5c:	0141                	addi	sp,sp,16
    80003a5e:	8082                	ret

0000000080003a60 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003a60:	df010113          	addi	sp,sp,-528
    80003a64:	20113423          	sd	ra,520(sp)
    80003a68:	20813023          	sd	s0,512(sp)
    80003a6c:	ffa6                	sd	s1,504(sp)
    80003a6e:	fbca                	sd	s2,496(sp)
    80003a70:	0c00                	addi	s0,sp,528
    80003a72:	892a                	mv	s2,a0
    80003a74:	dea43c23          	sd	a0,-520(s0)
    80003a78:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a7c:	afefd0ef          	jal	80000d7a <myproc>
    80003a80:	84aa                	mv	s1,a0

  begin_op();
    80003a82:	dd4ff0ef          	jal	80003056 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003a86:	854a                	mv	a0,s2
    80003a88:	bfaff0ef          	jal	80002e82 <namei>
    80003a8c:	c931                	beqz	a0,80003ae0 <kexec+0x80>
    80003a8e:	f3d2                	sd	s4,480(sp)
    80003a90:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a92:	bdbfe0ef          	jal	8000266c <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a96:	04000713          	li	a4,64
    80003a9a:	4681                	li	a3,0
    80003a9c:	e5040613          	addi	a2,s0,-432
    80003aa0:	4581                	li	a1,0
    80003aa2:	8552                	mv	a0,s4
    80003aa4:	f59fe0ef          	jal	800029fc <readi>
    80003aa8:	04000793          	li	a5,64
    80003aac:	00f51a63          	bne	a0,a5,80003ac0 <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003ab0:	e5042703          	lw	a4,-432(s0)
    80003ab4:	464c47b7          	lui	a5,0x464c4
    80003ab8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003abc:	02f70663          	beq	a4,a5,80003ae8 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003ac0:	8552                	mv	a0,s4
    80003ac2:	db5fe0ef          	jal	80002876 <iunlockput>
    end_op();
    80003ac6:	dfaff0ef          	jal	800030c0 <end_op>
  }
  return -1;
    80003aca:	557d                	li	a0,-1
    80003acc:	7a1e                	ld	s4,480(sp)
}
    80003ace:	20813083          	ld	ra,520(sp)
    80003ad2:	20013403          	ld	s0,512(sp)
    80003ad6:	74fe                	ld	s1,504(sp)
    80003ad8:	795e                	ld	s2,496(sp)
    80003ada:	21010113          	addi	sp,sp,528
    80003ade:	8082                	ret
    end_op();
    80003ae0:	de0ff0ef          	jal	800030c0 <end_op>
    return -1;
    80003ae4:	557d                	li	a0,-1
    80003ae6:	b7e5                	j	80003ace <kexec+0x6e>
    80003ae8:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003aea:	8526                	mv	a0,s1
    80003aec:	b94fd0ef          	jal	80000e80 <proc_pagetable>
    80003af0:	8b2a                	mv	s6,a0
    80003af2:	2c050b63          	beqz	a0,80003dc8 <kexec+0x368>
    80003af6:	f7ce                	sd	s3,488(sp)
    80003af8:	efd6                	sd	s5,472(sp)
    80003afa:	e7de                	sd	s7,456(sp)
    80003afc:	e3e2                	sd	s8,448(sp)
    80003afe:	ff66                	sd	s9,440(sp)
    80003b00:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b02:	e7042d03          	lw	s10,-400(s0)
    80003b06:	e8845783          	lhu	a5,-376(s0)
    80003b0a:	12078963          	beqz	a5,80003c3c <kexec+0x1dc>
    80003b0e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b10:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b12:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b14:	6c85                	lui	s9,0x1
    80003b16:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b1a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b1e:	6a85                	lui	s5,0x1
    80003b20:	a085                	j	80003b80 <kexec+0x120>
      panic("loadseg: address should exist");
    80003b22:	00004517          	auipc	a0,0x4
    80003b26:	a1e50513          	addi	a0,a0,-1506 # 80007540 <etext+0x540>
    80003b2a:	285010ef          	jal	800055ae <panic>
    if(sz - i < PGSIZE)
    80003b2e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b30:	8726                	mv	a4,s1
    80003b32:	012c06bb          	addw	a3,s8,s2
    80003b36:	4581                	li	a1,0
    80003b38:	8552                	mv	a0,s4
    80003b3a:	ec3fe0ef          	jal	800029fc <readi>
    80003b3e:	2501                	sext.w	a0,a0
    80003b40:	24a49a63          	bne	s1,a0,80003d94 <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003b44:	012a893b          	addw	s2,s5,s2
    80003b48:	03397363          	bgeu	s2,s3,80003b6e <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b4c:	02091593          	slli	a1,s2,0x20
    80003b50:	9181                	srli	a1,a1,0x20
    80003b52:	95de                	add	a1,a1,s7
    80003b54:	855a                	mv	a0,s6
    80003b56:	907fc0ef          	jal	8000045c <walkaddr>
    80003b5a:	862a                	mv	a2,a0
    if(pa == 0)
    80003b5c:	d179                	beqz	a0,80003b22 <kexec+0xc2>
    if(sz - i < PGSIZE)
    80003b5e:	412984bb          	subw	s1,s3,s2
    80003b62:	0004879b          	sext.w	a5,s1
    80003b66:	fcfcf4e3          	bgeu	s9,a5,80003b2e <kexec+0xce>
    80003b6a:	84d6                	mv	s1,s5
    80003b6c:	b7c9                	j	80003b2e <kexec+0xce>
    sz = sz1;
    80003b6e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b72:	2d85                	addiw	s11,s11,1
    80003b74:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003b78:	e8845783          	lhu	a5,-376(s0)
    80003b7c:	08fdd063          	bge	s11,a5,80003bfc <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b80:	2d01                	sext.w	s10,s10
    80003b82:	03800713          	li	a4,56
    80003b86:	86ea                	mv	a3,s10
    80003b88:	e1840613          	addi	a2,s0,-488
    80003b8c:	4581                	li	a1,0
    80003b8e:	8552                	mv	a0,s4
    80003b90:	e6dfe0ef          	jal	800029fc <readi>
    80003b94:	03800793          	li	a5,56
    80003b98:	1cf51663          	bne	a0,a5,80003d64 <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003b9c:	e1842783          	lw	a5,-488(s0)
    80003ba0:	4705                	li	a4,1
    80003ba2:	fce798e3          	bne	a5,a4,80003b72 <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80003ba6:	e4043483          	ld	s1,-448(s0)
    80003baa:	e3843783          	ld	a5,-456(s0)
    80003bae:	1af4ef63          	bltu	s1,a5,80003d6c <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003bb2:	e2843783          	ld	a5,-472(s0)
    80003bb6:	94be                	add	s1,s1,a5
    80003bb8:	1af4ee63          	bltu	s1,a5,80003d74 <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003bbc:	df043703          	ld	a4,-528(s0)
    80003bc0:	8ff9                	and	a5,a5,a4
    80003bc2:	1a079d63          	bnez	a5,80003d7c <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003bc6:	e1c42503          	lw	a0,-484(s0)
    80003bca:	e7dff0ef          	jal	80003a46 <flags2perm>
    80003bce:	86aa                	mv	a3,a0
    80003bd0:	8626                	mv	a2,s1
    80003bd2:	85ca                	mv	a1,s2
    80003bd4:	855a                	mv	a0,s6
    80003bd6:	b5ffc0ef          	jal	80000734 <uvmalloc>
    80003bda:	e0a43423          	sd	a0,-504(s0)
    80003bde:	1a050363          	beqz	a0,80003d84 <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003be2:	e2843b83          	ld	s7,-472(s0)
    80003be6:	e2042c03          	lw	s8,-480(s0)
    80003bea:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003bee:	00098463          	beqz	s3,80003bf6 <kexec+0x196>
    80003bf2:	4901                	li	s2,0
    80003bf4:	bfa1                	j	80003b4c <kexec+0xec>
    sz = sz1;
    80003bf6:	e0843903          	ld	s2,-504(s0)
    80003bfa:	bfa5                	j	80003b72 <kexec+0x112>
    80003bfc:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003bfe:	8552                	mv	a0,s4
    80003c00:	c77fe0ef          	jal	80002876 <iunlockput>
  end_op();
    80003c04:	cbcff0ef          	jal	800030c0 <end_op>
  p = myproc();
    80003c08:	972fd0ef          	jal	80000d7a <myproc>
    80003c0c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c0e:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c12:	6985                	lui	s3,0x1
    80003c14:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c16:	99ca                	add	s3,s3,s2
    80003c18:	77fd                	lui	a5,0xfffff
    80003c1a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c1e:	4691                	li	a3,4
    80003c20:	660d                	lui	a2,0x3
    80003c22:	964e                	add	a2,a2,s3
    80003c24:	85ce                	mv	a1,s3
    80003c26:	855a                	mv	a0,s6
    80003c28:	b0dfc0ef          	jal	80000734 <uvmalloc>
    80003c2c:	892a                	mv	s2,a0
    80003c2e:	e0a43423          	sd	a0,-504(s0)
    80003c32:	e519                	bnez	a0,80003c40 <kexec+0x1e0>
  if(pagetable)
    80003c34:	e1343423          	sd	s3,-504(s0)
    80003c38:	4a01                	li	s4,0
    80003c3a:	aab1                	j	80003d96 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c3c:	4901                	li	s2,0
    80003c3e:	b7c1                	j	80003bfe <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c40:	75f5                	lui	a1,0xffffd
    80003c42:	95aa                	add	a1,a1,a0
    80003c44:	855a                	mv	a0,s6
    80003c46:	cc5fc0ef          	jal	8000090a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c4a:	7bf9                	lui	s7,0xffffe
    80003c4c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c4e:	e0043783          	ld	a5,-512(s0)
    80003c52:	6388                	ld	a0,0(a5)
    80003c54:	cd39                	beqz	a0,80003cb2 <kexec+0x252>
    80003c56:	e9040993          	addi	s3,s0,-368
    80003c5a:	f9040c13          	addi	s8,s0,-112
    80003c5e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c60:	e5efc0ef          	jal	800002be <strlen>
    80003c64:	0015079b          	addiw	a5,a0,1
    80003c68:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c6c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c70:	11796e63          	bltu	s2,s7,80003d8c <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c74:	e0043d03          	ld	s10,-512(s0)
    80003c78:	000d3a03          	ld	s4,0(s10)
    80003c7c:	8552                	mv	a0,s4
    80003c7e:	e40fc0ef          	jal	800002be <strlen>
    80003c82:	0015069b          	addiw	a3,a0,1
    80003c86:	8652                	mv	a2,s4
    80003c88:	85ca                	mv	a1,s2
    80003c8a:	855a                	mv	a0,s6
    80003c8c:	e03fc0ef          	jal	80000a8e <copyout>
    80003c90:	10054063          	bltz	a0,80003d90 <kexec+0x330>
    ustack[argc] = sp;
    80003c94:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003c98:	0485                	addi	s1,s1,1
    80003c9a:	008d0793          	addi	a5,s10,8
    80003c9e:	e0f43023          	sd	a5,-512(s0)
    80003ca2:	008d3503          	ld	a0,8(s10)
    80003ca6:	c909                	beqz	a0,80003cb8 <kexec+0x258>
    if(argc >= MAXARG)
    80003ca8:	09a1                	addi	s3,s3,8
    80003caa:	fb899be3          	bne	s3,s8,80003c60 <kexec+0x200>
  ip = 0;
    80003cae:	4a01                	li	s4,0
    80003cb0:	a0dd                	j	80003d96 <kexec+0x336>
  sp = sz;
    80003cb2:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003cb6:	4481                	li	s1,0
  ustack[argc] = 0;
    80003cb8:	00349793          	slli	a5,s1,0x3
    80003cbc:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdbae8>
    80003cc0:	97a2                	add	a5,a5,s0
    80003cc2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003cc6:	00148693          	addi	a3,s1,1
    80003cca:	068e                	slli	a3,a3,0x3
    80003ccc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003cd0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003cd4:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003cd8:	f5796ee3          	bltu	s2,s7,80003c34 <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003cdc:	e9040613          	addi	a2,s0,-368
    80003ce0:	85ca                	mv	a1,s2
    80003ce2:	855a                	mv	a0,s6
    80003ce4:	dabfc0ef          	jal	80000a8e <copyout>
    80003ce8:	0e054263          	bltz	a0,80003dcc <kexec+0x36c>
  p->trapframe->a1 = sp;
    80003cec:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003cf0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003cf4:	df843783          	ld	a5,-520(s0)
    80003cf8:	0007c703          	lbu	a4,0(a5)
    80003cfc:	cf11                	beqz	a4,80003d18 <kexec+0x2b8>
    80003cfe:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d00:	02f00693          	li	a3,47
    80003d04:	a039                	j	80003d12 <kexec+0x2b2>
      last = s+1;
    80003d06:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d0a:	0785                	addi	a5,a5,1
    80003d0c:	fff7c703          	lbu	a4,-1(a5)
    80003d10:	c701                	beqz	a4,80003d18 <kexec+0x2b8>
    if(*s == '/')
    80003d12:	fed71ce3          	bne	a4,a3,80003d0a <kexec+0x2aa>
    80003d16:	bfc5                	j	80003d06 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d18:	4641                	li	a2,16
    80003d1a:	df843583          	ld	a1,-520(s0)
    80003d1e:	158a8513          	addi	a0,s5,344
    80003d22:	d6afc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003d26:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d2a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d2e:	e0843783          	ld	a5,-504(s0)
    80003d32:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d36:	058ab783          	ld	a5,88(s5)
    80003d3a:	e6843703          	ld	a4,-408(s0)
    80003d3e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d40:	058ab783          	ld	a5,88(s5)
    80003d44:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d48:	85e6                	mv	a1,s9
    80003d4a:	9bafd0ef          	jal	80000f04 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d4e:	0004851b          	sext.w	a0,s1
    80003d52:	79be                	ld	s3,488(sp)
    80003d54:	7a1e                	ld	s4,480(sp)
    80003d56:	6afe                	ld	s5,472(sp)
    80003d58:	6b5e                	ld	s6,464(sp)
    80003d5a:	6bbe                	ld	s7,456(sp)
    80003d5c:	6c1e                	ld	s8,448(sp)
    80003d5e:	7cfa                	ld	s9,440(sp)
    80003d60:	7d5a                	ld	s10,432(sp)
    80003d62:	b3b5                	j	80003ace <kexec+0x6e>
    80003d64:	e1243423          	sd	s2,-504(s0)
    80003d68:	7dba                	ld	s11,424(sp)
    80003d6a:	a035                	j	80003d96 <kexec+0x336>
    80003d6c:	e1243423          	sd	s2,-504(s0)
    80003d70:	7dba                	ld	s11,424(sp)
    80003d72:	a015                	j	80003d96 <kexec+0x336>
    80003d74:	e1243423          	sd	s2,-504(s0)
    80003d78:	7dba                	ld	s11,424(sp)
    80003d7a:	a831                	j	80003d96 <kexec+0x336>
    80003d7c:	e1243423          	sd	s2,-504(s0)
    80003d80:	7dba                	ld	s11,424(sp)
    80003d82:	a811                	j	80003d96 <kexec+0x336>
    80003d84:	e1243423          	sd	s2,-504(s0)
    80003d88:	7dba                	ld	s11,424(sp)
    80003d8a:	a031                	j	80003d96 <kexec+0x336>
  ip = 0;
    80003d8c:	4a01                	li	s4,0
    80003d8e:	a021                	j	80003d96 <kexec+0x336>
    80003d90:	4a01                	li	s4,0
  if(pagetable)
    80003d92:	a011                	j	80003d96 <kexec+0x336>
    80003d94:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003d96:	e0843583          	ld	a1,-504(s0)
    80003d9a:	855a                	mv	a0,s6
    80003d9c:	968fd0ef          	jal	80000f04 <proc_freepagetable>
  return -1;
    80003da0:	557d                	li	a0,-1
  if(ip){
    80003da2:	000a1b63          	bnez	s4,80003db8 <kexec+0x358>
    80003da6:	79be                	ld	s3,488(sp)
    80003da8:	7a1e                	ld	s4,480(sp)
    80003daa:	6afe                	ld	s5,472(sp)
    80003dac:	6b5e                	ld	s6,464(sp)
    80003dae:	6bbe                	ld	s7,456(sp)
    80003db0:	6c1e                	ld	s8,448(sp)
    80003db2:	7cfa                	ld	s9,440(sp)
    80003db4:	7d5a                	ld	s10,432(sp)
    80003db6:	bb21                	j	80003ace <kexec+0x6e>
    80003db8:	79be                	ld	s3,488(sp)
    80003dba:	6afe                	ld	s5,472(sp)
    80003dbc:	6b5e                	ld	s6,464(sp)
    80003dbe:	6bbe                	ld	s7,456(sp)
    80003dc0:	6c1e                	ld	s8,448(sp)
    80003dc2:	7cfa                	ld	s9,440(sp)
    80003dc4:	7d5a                	ld	s10,432(sp)
    80003dc6:	b9ed                	j	80003ac0 <kexec+0x60>
    80003dc8:	6b5e                	ld	s6,464(sp)
    80003dca:	b9dd                	j	80003ac0 <kexec+0x60>
  sz = sz1;
    80003dcc:	e0843983          	ld	s3,-504(s0)
    80003dd0:	b595                	j	80003c34 <kexec+0x1d4>

0000000080003dd2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003dd2:	7179                	addi	sp,sp,-48
    80003dd4:	f406                	sd	ra,40(sp)
    80003dd6:	f022                	sd	s0,32(sp)
    80003dd8:	ec26                	sd	s1,24(sp)
    80003dda:	e84a                	sd	s2,16(sp)
    80003ddc:	1800                	addi	s0,sp,48
    80003dde:	892e                	mv	s2,a1
    80003de0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003de2:	fdc40593          	addi	a1,s0,-36
    80003de6:	e91fd0ef          	jal	80001c76 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003dea:	fdc42703          	lw	a4,-36(s0)
    80003dee:	47bd                	li	a5,15
    80003df0:	02e7e963          	bltu	a5,a4,80003e22 <argfd+0x50>
    80003df4:	f87fc0ef          	jal	80000d7a <myproc>
    80003df8:	fdc42703          	lw	a4,-36(s0)
    80003dfc:	01a70793          	addi	a5,a4,26
    80003e00:	078e                	slli	a5,a5,0x3
    80003e02:	953e                	add	a0,a0,a5
    80003e04:	611c                	ld	a5,0(a0)
    80003e06:	c385                	beqz	a5,80003e26 <argfd+0x54>
    return -1;
  if(pfd)
    80003e08:	00090463          	beqz	s2,80003e10 <argfd+0x3e>
    *pfd = fd;
    80003e0c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e10:	4501                	li	a0,0
  if(pf)
    80003e12:	c091                	beqz	s1,80003e16 <argfd+0x44>
    *pf = f;
    80003e14:	e09c                	sd	a5,0(s1)
}
    80003e16:	70a2                	ld	ra,40(sp)
    80003e18:	7402                	ld	s0,32(sp)
    80003e1a:	64e2                	ld	s1,24(sp)
    80003e1c:	6942                	ld	s2,16(sp)
    80003e1e:	6145                	addi	sp,sp,48
    80003e20:	8082                	ret
    return -1;
    80003e22:	557d                	li	a0,-1
    80003e24:	bfcd                	j	80003e16 <argfd+0x44>
    80003e26:	557d                	li	a0,-1
    80003e28:	b7fd                	j	80003e16 <argfd+0x44>

0000000080003e2a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e2a:	1101                	addi	sp,sp,-32
    80003e2c:	ec06                	sd	ra,24(sp)
    80003e2e:	e822                	sd	s0,16(sp)
    80003e30:	e426                	sd	s1,8(sp)
    80003e32:	1000                	addi	s0,sp,32
    80003e34:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e36:	f45fc0ef          	jal	80000d7a <myproc>
    80003e3a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e3c:	0d050793          	addi	a5,a0,208
    80003e40:	4501                	li	a0,0
    80003e42:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e44:	6398                	ld	a4,0(a5)
    80003e46:	cb19                	beqz	a4,80003e5c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e48:	2505                	addiw	a0,a0,1
    80003e4a:	07a1                	addi	a5,a5,8
    80003e4c:	fed51ce3          	bne	a0,a3,80003e44 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e50:	557d                	li	a0,-1
}
    80003e52:	60e2                	ld	ra,24(sp)
    80003e54:	6442                	ld	s0,16(sp)
    80003e56:	64a2                	ld	s1,8(sp)
    80003e58:	6105                	addi	sp,sp,32
    80003e5a:	8082                	ret
      p->ofile[fd] = f;
    80003e5c:	01a50793          	addi	a5,a0,26
    80003e60:	078e                	slli	a5,a5,0x3
    80003e62:	963e                	add	a2,a2,a5
    80003e64:	e204                	sd	s1,0(a2)
      return fd;
    80003e66:	b7f5                	j	80003e52 <fdalloc+0x28>

0000000080003e68 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e68:	715d                	addi	sp,sp,-80
    80003e6a:	e486                	sd	ra,72(sp)
    80003e6c:	e0a2                	sd	s0,64(sp)
    80003e6e:	fc26                	sd	s1,56(sp)
    80003e70:	f84a                	sd	s2,48(sp)
    80003e72:	f44e                	sd	s3,40(sp)
    80003e74:	ec56                	sd	s5,24(sp)
    80003e76:	e85a                	sd	s6,16(sp)
    80003e78:	0880                	addi	s0,sp,80
    80003e7a:	8b2e                	mv	s6,a1
    80003e7c:	89b2                	mv	s3,a2
    80003e7e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e80:	fb040593          	addi	a1,s0,-80
    80003e84:	818ff0ef          	jal	80002e9c <nameiparent>
    80003e88:	84aa                	mv	s1,a0
    80003e8a:	10050a63          	beqz	a0,80003f9e <create+0x136>
    return 0;

  ilock(dp);
    80003e8e:	fdefe0ef          	jal	8000266c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e92:	4601                	li	a2,0
    80003e94:	fb040593          	addi	a1,s0,-80
    80003e98:	8526                	mv	a0,s1
    80003e9a:	d83fe0ef          	jal	80002c1c <dirlookup>
    80003e9e:	8aaa                	mv	s5,a0
    80003ea0:	c129                	beqz	a0,80003ee2 <create+0x7a>
    iunlockput(dp);
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	9d3fe0ef          	jal	80002876 <iunlockput>
    ilock(ip);
    80003ea8:	8556                	mv	a0,s5
    80003eaa:	fc2fe0ef          	jal	8000266c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003eae:	4789                	li	a5,2
    80003eb0:	02fb1463          	bne	s6,a5,80003ed8 <create+0x70>
    80003eb4:	044ad783          	lhu	a5,68(s5)
    80003eb8:	37f9                	addiw	a5,a5,-2
    80003eba:	17c2                	slli	a5,a5,0x30
    80003ebc:	93c1                	srli	a5,a5,0x30
    80003ebe:	4705                	li	a4,1
    80003ec0:	00f76c63          	bltu	a4,a5,80003ed8 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003ec4:	8556                	mv	a0,s5
    80003ec6:	60a6                	ld	ra,72(sp)
    80003ec8:	6406                	ld	s0,64(sp)
    80003eca:	74e2                	ld	s1,56(sp)
    80003ecc:	7942                	ld	s2,48(sp)
    80003ece:	79a2                	ld	s3,40(sp)
    80003ed0:	6ae2                	ld	s5,24(sp)
    80003ed2:	6b42                	ld	s6,16(sp)
    80003ed4:	6161                	addi	sp,sp,80
    80003ed6:	8082                	ret
    iunlockput(ip);
    80003ed8:	8556                	mv	a0,s5
    80003eda:	99dfe0ef          	jal	80002876 <iunlockput>
    return 0;
    80003ede:	4a81                	li	s5,0
    80003ee0:	b7d5                	j	80003ec4 <create+0x5c>
    80003ee2:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003ee4:	85da                	mv	a1,s6
    80003ee6:	4088                	lw	a0,0(s1)
    80003ee8:	e14fe0ef          	jal	800024fc <ialloc>
    80003eec:	8a2a                	mv	s4,a0
    80003eee:	cd15                	beqz	a0,80003f2a <create+0xc2>
  ilock(ip);
    80003ef0:	f7cfe0ef          	jal	8000266c <ilock>
  ip->major = major;
    80003ef4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003ef8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003efc:	4905                	li	s2,1
    80003efe:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f02:	8552                	mv	a0,s4
    80003f04:	eb4fe0ef          	jal	800025b8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f08:	032b0763          	beq	s6,s2,80003f36 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f0c:	004a2603          	lw	a2,4(s4)
    80003f10:	fb040593          	addi	a1,s0,-80
    80003f14:	8526                	mv	a0,s1
    80003f16:	ed3fe0ef          	jal	80002de8 <dirlink>
    80003f1a:	06054563          	bltz	a0,80003f84 <create+0x11c>
  iunlockput(dp);
    80003f1e:	8526                	mv	a0,s1
    80003f20:	957fe0ef          	jal	80002876 <iunlockput>
  return ip;
    80003f24:	8ad2                	mv	s5,s4
    80003f26:	7a02                	ld	s4,32(sp)
    80003f28:	bf71                	j	80003ec4 <create+0x5c>
    iunlockput(dp);
    80003f2a:	8526                	mv	a0,s1
    80003f2c:	94bfe0ef          	jal	80002876 <iunlockput>
    return 0;
    80003f30:	8ad2                	mv	s5,s4
    80003f32:	7a02                	ld	s4,32(sp)
    80003f34:	bf41                	j	80003ec4 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f36:	004a2603          	lw	a2,4(s4)
    80003f3a:	00003597          	auipc	a1,0x3
    80003f3e:	62658593          	addi	a1,a1,1574 # 80007560 <etext+0x560>
    80003f42:	8552                	mv	a0,s4
    80003f44:	ea5fe0ef          	jal	80002de8 <dirlink>
    80003f48:	02054e63          	bltz	a0,80003f84 <create+0x11c>
    80003f4c:	40d0                	lw	a2,4(s1)
    80003f4e:	00003597          	auipc	a1,0x3
    80003f52:	61a58593          	addi	a1,a1,1562 # 80007568 <etext+0x568>
    80003f56:	8552                	mv	a0,s4
    80003f58:	e91fe0ef          	jal	80002de8 <dirlink>
    80003f5c:	02054463          	bltz	a0,80003f84 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f60:	004a2603          	lw	a2,4(s4)
    80003f64:	fb040593          	addi	a1,s0,-80
    80003f68:	8526                	mv	a0,s1
    80003f6a:	e7ffe0ef          	jal	80002de8 <dirlink>
    80003f6e:	00054b63          	bltz	a0,80003f84 <create+0x11c>
    dp->nlink++;  // for ".."
    80003f72:	04a4d783          	lhu	a5,74(s1)
    80003f76:	2785                	addiw	a5,a5,1
    80003f78:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	e3afe0ef          	jal	800025b8 <iupdate>
    80003f82:	bf71                	j	80003f1e <create+0xb6>
  ip->nlink = 0;
    80003f84:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f88:	8552                	mv	a0,s4
    80003f8a:	e2efe0ef          	jal	800025b8 <iupdate>
  iunlockput(ip);
    80003f8e:	8552                	mv	a0,s4
    80003f90:	8e7fe0ef          	jal	80002876 <iunlockput>
  iunlockput(dp);
    80003f94:	8526                	mv	a0,s1
    80003f96:	8e1fe0ef          	jal	80002876 <iunlockput>
  return 0;
    80003f9a:	7a02                	ld	s4,32(sp)
    80003f9c:	b725                	j	80003ec4 <create+0x5c>
    return 0;
    80003f9e:	8aaa                	mv	s5,a0
    80003fa0:	b715                	j	80003ec4 <create+0x5c>

0000000080003fa2 <sys_dup>:
{
    80003fa2:	7179                	addi	sp,sp,-48
    80003fa4:	f406                	sd	ra,40(sp)
    80003fa6:	f022                	sd	s0,32(sp)
    80003fa8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003faa:	fd840613          	addi	a2,s0,-40
    80003fae:	4581                	li	a1,0
    80003fb0:	4501                	li	a0,0
    80003fb2:	e21ff0ef          	jal	80003dd2 <argfd>
    return -1;
    80003fb6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003fb8:	02054363          	bltz	a0,80003fde <sys_dup+0x3c>
    80003fbc:	ec26                	sd	s1,24(sp)
    80003fbe:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003fc0:	fd843903          	ld	s2,-40(s0)
    80003fc4:	854a                	mv	a0,s2
    80003fc6:	e65ff0ef          	jal	80003e2a <fdalloc>
    80003fca:	84aa                	mv	s1,a0
    return -1;
    80003fcc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003fce:	00054d63          	bltz	a0,80003fe8 <sys_dup+0x46>
  filedup(f);
    80003fd2:	854a                	mv	a0,s2
    80003fd4:	c48ff0ef          	jal	8000341c <filedup>
  return fd;
    80003fd8:	87a6                	mv	a5,s1
    80003fda:	64e2                	ld	s1,24(sp)
    80003fdc:	6942                	ld	s2,16(sp)
}
    80003fde:	853e                	mv	a0,a5
    80003fe0:	70a2                	ld	ra,40(sp)
    80003fe2:	7402                	ld	s0,32(sp)
    80003fe4:	6145                	addi	sp,sp,48
    80003fe6:	8082                	ret
    80003fe8:	64e2                	ld	s1,24(sp)
    80003fea:	6942                	ld	s2,16(sp)
    80003fec:	bfcd                	j	80003fde <sys_dup+0x3c>

0000000080003fee <sys_read>:
{
    80003fee:	7179                	addi	sp,sp,-48
    80003ff0:	f406                	sd	ra,40(sp)
    80003ff2:	f022                	sd	s0,32(sp)
    80003ff4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ff6:	fd840593          	addi	a1,s0,-40
    80003ffa:	4505                	li	a0,1
    80003ffc:	c97fd0ef          	jal	80001c92 <argaddr>
  argint(2, &n);
    80004000:	fe440593          	addi	a1,s0,-28
    80004004:	4509                	li	a0,2
    80004006:	c71fd0ef          	jal	80001c76 <argint>
  if(argfd(0, 0, &f) < 0)
    8000400a:	fe840613          	addi	a2,s0,-24
    8000400e:	4581                	li	a1,0
    80004010:	4501                	li	a0,0
    80004012:	dc1ff0ef          	jal	80003dd2 <argfd>
    80004016:	87aa                	mv	a5,a0
    return -1;
    80004018:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000401a:	0007ca63          	bltz	a5,8000402e <sys_read+0x40>
  return fileread(f, p, n);
    8000401e:	fe442603          	lw	a2,-28(s0)
    80004022:	fd843583          	ld	a1,-40(s0)
    80004026:	fe843503          	ld	a0,-24(s0)
    8000402a:	d58ff0ef          	jal	80003582 <fileread>
}
    8000402e:	70a2                	ld	ra,40(sp)
    80004030:	7402                	ld	s0,32(sp)
    80004032:	6145                	addi	sp,sp,48
    80004034:	8082                	ret

0000000080004036 <sys_write>:
{
    80004036:	7179                	addi	sp,sp,-48
    80004038:	f406                	sd	ra,40(sp)
    8000403a:	f022                	sd	s0,32(sp)
    8000403c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000403e:	fd840593          	addi	a1,s0,-40
    80004042:	4505                	li	a0,1
    80004044:	c4ffd0ef          	jal	80001c92 <argaddr>
  argint(2, &n);
    80004048:	fe440593          	addi	a1,s0,-28
    8000404c:	4509                	li	a0,2
    8000404e:	c29fd0ef          	jal	80001c76 <argint>
  if(argfd(0, 0, &f) < 0)
    80004052:	fe840613          	addi	a2,s0,-24
    80004056:	4581                	li	a1,0
    80004058:	4501                	li	a0,0
    8000405a:	d79ff0ef          	jal	80003dd2 <argfd>
    8000405e:	87aa                	mv	a5,a0
    return -1;
    80004060:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004062:	0007ca63          	bltz	a5,80004076 <sys_write+0x40>
  return filewrite(f, p, n);
    80004066:	fe442603          	lw	a2,-28(s0)
    8000406a:	fd843583          	ld	a1,-40(s0)
    8000406e:	fe843503          	ld	a0,-24(s0)
    80004072:	dceff0ef          	jal	80003640 <filewrite>
}
    80004076:	70a2                	ld	ra,40(sp)
    80004078:	7402                	ld	s0,32(sp)
    8000407a:	6145                	addi	sp,sp,48
    8000407c:	8082                	ret

000000008000407e <sys_close>:
{
    8000407e:	1101                	addi	sp,sp,-32
    80004080:	ec06                	sd	ra,24(sp)
    80004082:	e822                	sd	s0,16(sp)
    80004084:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004086:	fe040613          	addi	a2,s0,-32
    8000408a:	fec40593          	addi	a1,s0,-20
    8000408e:	4501                	li	a0,0
    80004090:	d43ff0ef          	jal	80003dd2 <argfd>
    return -1;
    80004094:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004096:	02054063          	bltz	a0,800040b6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000409a:	ce1fc0ef          	jal	80000d7a <myproc>
    8000409e:	fec42783          	lw	a5,-20(s0)
    800040a2:	07e9                	addi	a5,a5,26
    800040a4:	078e                	slli	a5,a5,0x3
    800040a6:	953e                	add	a0,a0,a5
    800040a8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800040ac:	fe043503          	ld	a0,-32(s0)
    800040b0:	bb2ff0ef          	jal	80003462 <fileclose>
  return 0;
    800040b4:	4781                	li	a5,0
}
    800040b6:	853e                	mv	a0,a5
    800040b8:	60e2                	ld	ra,24(sp)
    800040ba:	6442                	ld	s0,16(sp)
    800040bc:	6105                	addi	sp,sp,32
    800040be:	8082                	ret

00000000800040c0 <sys_fstat>:
{
    800040c0:	1101                	addi	sp,sp,-32
    800040c2:	ec06                	sd	ra,24(sp)
    800040c4:	e822                	sd	s0,16(sp)
    800040c6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800040c8:	fe040593          	addi	a1,s0,-32
    800040cc:	4505                	li	a0,1
    800040ce:	bc5fd0ef          	jal	80001c92 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800040d2:	fe840613          	addi	a2,s0,-24
    800040d6:	4581                	li	a1,0
    800040d8:	4501                	li	a0,0
    800040da:	cf9ff0ef          	jal	80003dd2 <argfd>
    800040de:	87aa                	mv	a5,a0
    return -1;
    800040e0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040e2:	0007c863          	bltz	a5,800040f2 <sys_fstat+0x32>
  return filestat(f, st);
    800040e6:	fe043583          	ld	a1,-32(s0)
    800040ea:	fe843503          	ld	a0,-24(s0)
    800040ee:	c36ff0ef          	jal	80003524 <filestat>
}
    800040f2:	60e2                	ld	ra,24(sp)
    800040f4:	6442                	ld	s0,16(sp)
    800040f6:	6105                	addi	sp,sp,32
    800040f8:	8082                	ret

00000000800040fa <sys_link>:
{
    800040fa:	7169                	addi	sp,sp,-304
    800040fc:	f606                	sd	ra,296(sp)
    800040fe:	f222                	sd	s0,288(sp)
    80004100:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004102:	08000613          	li	a2,128
    80004106:	ed040593          	addi	a1,s0,-304
    8000410a:	4501                	li	a0,0
    8000410c:	ba3fd0ef          	jal	80001cae <argstr>
    return -1;
    80004110:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004112:	0c054e63          	bltz	a0,800041ee <sys_link+0xf4>
    80004116:	08000613          	li	a2,128
    8000411a:	f5040593          	addi	a1,s0,-176
    8000411e:	4505                	li	a0,1
    80004120:	b8ffd0ef          	jal	80001cae <argstr>
    return -1;
    80004124:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004126:	0c054463          	bltz	a0,800041ee <sys_link+0xf4>
    8000412a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000412c:	f2bfe0ef          	jal	80003056 <begin_op>
  if((ip = namei(old)) == 0){
    80004130:	ed040513          	addi	a0,s0,-304
    80004134:	d4ffe0ef          	jal	80002e82 <namei>
    80004138:	84aa                	mv	s1,a0
    8000413a:	c53d                	beqz	a0,800041a8 <sys_link+0xae>
  ilock(ip);
    8000413c:	d30fe0ef          	jal	8000266c <ilock>
  if(ip->type == T_DIR){
    80004140:	04449703          	lh	a4,68(s1)
    80004144:	4785                	li	a5,1
    80004146:	06f70663          	beq	a4,a5,800041b2 <sys_link+0xb8>
    8000414a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000414c:	04a4d783          	lhu	a5,74(s1)
    80004150:	2785                	addiw	a5,a5,1
    80004152:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004156:	8526                	mv	a0,s1
    80004158:	c60fe0ef          	jal	800025b8 <iupdate>
  iunlock(ip);
    8000415c:	8526                	mv	a0,s1
    8000415e:	dbcfe0ef          	jal	8000271a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004162:	fd040593          	addi	a1,s0,-48
    80004166:	f5040513          	addi	a0,s0,-176
    8000416a:	d33fe0ef          	jal	80002e9c <nameiparent>
    8000416e:	892a                	mv	s2,a0
    80004170:	cd21                	beqz	a0,800041c8 <sys_link+0xce>
  ilock(dp);
    80004172:	cfafe0ef          	jal	8000266c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004176:	00092703          	lw	a4,0(s2)
    8000417a:	409c                	lw	a5,0(s1)
    8000417c:	04f71363          	bne	a4,a5,800041c2 <sys_link+0xc8>
    80004180:	40d0                	lw	a2,4(s1)
    80004182:	fd040593          	addi	a1,s0,-48
    80004186:	854a                	mv	a0,s2
    80004188:	c61fe0ef          	jal	80002de8 <dirlink>
    8000418c:	02054b63          	bltz	a0,800041c2 <sys_link+0xc8>
  iunlockput(dp);
    80004190:	854a                	mv	a0,s2
    80004192:	ee4fe0ef          	jal	80002876 <iunlockput>
  iput(ip);
    80004196:	8526                	mv	a0,s1
    80004198:	e56fe0ef          	jal	800027ee <iput>
  end_op();
    8000419c:	f25fe0ef          	jal	800030c0 <end_op>
  return 0;
    800041a0:	4781                	li	a5,0
    800041a2:	64f2                	ld	s1,280(sp)
    800041a4:	6952                	ld	s2,272(sp)
    800041a6:	a0a1                	j	800041ee <sys_link+0xf4>
    end_op();
    800041a8:	f19fe0ef          	jal	800030c0 <end_op>
    return -1;
    800041ac:	57fd                	li	a5,-1
    800041ae:	64f2                	ld	s1,280(sp)
    800041b0:	a83d                	j	800041ee <sys_link+0xf4>
    iunlockput(ip);
    800041b2:	8526                	mv	a0,s1
    800041b4:	ec2fe0ef          	jal	80002876 <iunlockput>
    end_op();
    800041b8:	f09fe0ef          	jal	800030c0 <end_op>
    return -1;
    800041bc:	57fd                	li	a5,-1
    800041be:	64f2                	ld	s1,280(sp)
    800041c0:	a03d                	j	800041ee <sys_link+0xf4>
    iunlockput(dp);
    800041c2:	854a                	mv	a0,s2
    800041c4:	eb2fe0ef          	jal	80002876 <iunlockput>
  ilock(ip);
    800041c8:	8526                	mv	a0,s1
    800041ca:	ca2fe0ef          	jal	8000266c <ilock>
  ip->nlink--;
    800041ce:	04a4d783          	lhu	a5,74(s1)
    800041d2:	37fd                	addiw	a5,a5,-1
    800041d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041d8:	8526                	mv	a0,s1
    800041da:	bdefe0ef          	jal	800025b8 <iupdate>
  iunlockput(ip);
    800041de:	8526                	mv	a0,s1
    800041e0:	e96fe0ef          	jal	80002876 <iunlockput>
  end_op();
    800041e4:	eddfe0ef          	jal	800030c0 <end_op>
  return -1;
    800041e8:	57fd                	li	a5,-1
    800041ea:	64f2                	ld	s1,280(sp)
    800041ec:	6952                	ld	s2,272(sp)
}
    800041ee:	853e                	mv	a0,a5
    800041f0:	70b2                	ld	ra,296(sp)
    800041f2:	7412                	ld	s0,288(sp)
    800041f4:	6155                	addi	sp,sp,304
    800041f6:	8082                	ret

00000000800041f8 <sys_unlink>:
{
    800041f8:	7151                	addi	sp,sp,-240
    800041fa:	f586                	sd	ra,232(sp)
    800041fc:	f1a2                	sd	s0,224(sp)
    800041fe:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004200:	08000613          	li	a2,128
    80004204:	f3040593          	addi	a1,s0,-208
    80004208:	4501                	li	a0,0
    8000420a:	aa5fd0ef          	jal	80001cae <argstr>
    8000420e:	16054063          	bltz	a0,8000436e <sys_unlink+0x176>
    80004212:	eda6                	sd	s1,216(sp)
  begin_op();
    80004214:	e43fe0ef          	jal	80003056 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004218:	fb040593          	addi	a1,s0,-80
    8000421c:	f3040513          	addi	a0,s0,-208
    80004220:	c7dfe0ef          	jal	80002e9c <nameiparent>
    80004224:	84aa                	mv	s1,a0
    80004226:	c945                	beqz	a0,800042d6 <sys_unlink+0xde>
  ilock(dp);
    80004228:	c44fe0ef          	jal	8000266c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000422c:	00003597          	auipc	a1,0x3
    80004230:	33458593          	addi	a1,a1,820 # 80007560 <etext+0x560>
    80004234:	fb040513          	addi	a0,s0,-80
    80004238:	9cffe0ef          	jal	80002c06 <namecmp>
    8000423c:	10050e63          	beqz	a0,80004358 <sys_unlink+0x160>
    80004240:	00003597          	auipc	a1,0x3
    80004244:	32858593          	addi	a1,a1,808 # 80007568 <etext+0x568>
    80004248:	fb040513          	addi	a0,s0,-80
    8000424c:	9bbfe0ef          	jal	80002c06 <namecmp>
    80004250:	10050463          	beqz	a0,80004358 <sys_unlink+0x160>
    80004254:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004256:	f2c40613          	addi	a2,s0,-212
    8000425a:	fb040593          	addi	a1,s0,-80
    8000425e:	8526                	mv	a0,s1
    80004260:	9bdfe0ef          	jal	80002c1c <dirlookup>
    80004264:	892a                	mv	s2,a0
    80004266:	0e050863          	beqz	a0,80004356 <sys_unlink+0x15e>
  ilock(ip);
    8000426a:	c02fe0ef          	jal	8000266c <ilock>
  if(ip->nlink < 1)
    8000426e:	04a91783          	lh	a5,74(s2)
    80004272:	06f05763          	blez	a5,800042e0 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004276:	04491703          	lh	a4,68(s2)
    8000427a:	4785                	li	a5,1
    8000427c:	06f70963          	beq	a4,a5,800042ee <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004280:	4641                	li	a2,16
    80004282:	4581                	li	a1,0
    80004284:	fc040513          	addi	a0,s0,-64
    80004288:	ec7fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000428c:	4741                	li	a4,16
    8000428e:	f2c42683          	lw	a3,-212(s0)
    80004292:	fc040613          	addi	a2,s0,-64
    80004296:	4581                	li	a1,0
    80004298:	8526                	mv	a0,s1
    8000429a:	85ffe0ef          	jal	80002af8 <writei>
    8000429e:	47c1                	li	a5,16
    800042a0:	08f51b63          	bne	a0,a5,80004336 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800042a4:	04491703          	lh	a4,68(s2)
    800042a8:	4785                	li	a5,1
    800042aa:	08f70d63          	beq	a4,a5,80004344 <sys_unlink+0x14c>
  iunlockput(dp);
    800042ae:	8526                	mv	a0,s1
    800042b0:	dc6fe0ef          	jal	80002876 <iunlockput>
  ip->nlink--;
    800042b4:	04a95783          	lhu	a5,74(s2)
    800042b8:	37fd                	addiw	a5,a5,-1
    800042ba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800042be:	854a                	mv	a0,s2
    800042c0:	af8fe0ef          	jal	800025b8 <iupdate>
  iunlockput(ip);
    800042c4:	854a                	mv	a0,s2
    800042c6:	db0fe0ef          	jal	80002876 <iunlockput>
  end_op();
    800042ca:	df7fe0ef          	jal	800030c0 <end_op>
  return 0;
    800042ce:	4501                	li	a0,0
    800042d0:	64ee                	ld	s1,216(sp)
    800042d2:	694e                	ld	s2,208(sp)
    800042d4:	a849                	j	80004366 <sys_unlink+0x16e>
    end_op();
    800042d6:	debfe0ef          	jal	800030c0 <end_op>
    return -1;
    800042da:	557d                	li	a0,-1
    800042dc:	64ee                	ld	s1,216(sp)
    800042de:	a061                	j	80004366 <sys_unlink+0x16e>
    800042e0:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800042e2:	00003517          	auipc	a0,0x3
    800042e6:	28e50513          	addi	a0,a0,654 # 80007570 <etext+0x570>
    800042ea:	2c4010ef          	jal	800055ae <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042ee:	04c92703          	lw	a4,76(s2)
    800042f2:	02000793          	li	a5,32
    800042f6:	f8e7f5e3          	bgeu	a5,a4,80004280 <sys_unlink+0x88>
    800042fa:	e5ce                	sd	s3,200(sp)
    800042fc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004300:	4741                	li	a4,16
    80004302:	86ce                	mv	a3,s3
    80004304:	f1840613          	addi	a2,s0,-232
    80004308:	4581                	li	a1,0
    8000430a:	854a                	mv	a0,s2
    8000430c:	ef0fe0ef          	jal	800029fc <readi>
    80004310:	47c1                	li	a5,16
    80004312:	00f51c63          	bne	a0,a5,8000432a <sys_unlink+0x132>
    if(de.inum != 0)
    80004316:	f1845783          	lhu	a5,-232(s0)
    8000431a:	efa1                	bnez	a5,80004372 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000431c:	29c1                	addiw	s3,s3,16
    8000431e:	04c92783          	lw	a5,76(s2)
    80004322:	fcf9efe3          	bltu	s3,a5,80004300 <sys_unlink+0x108>
    80004326:	69ae                	ld	s3,200(sp)
    80004328:	bfa1                	j	80004280 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000432a:	00003517          	auipc	a0,0x3
    8000432e:	25e50513          	addi	a0,a0,606 # 80007588 <etext+0x588>
    80004332:	27c010ef          	jal	800055ae <panic>
    80004336:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004338:	00003517          	auipc	a0,0x3
    8000433c:	26850513          	addi	a0,a0,616 # 800075a0 <etext+0x5a0>
    80004340:	26e010ef          	jal	800055ae <panic>
    dp->nlink--;
    80004344:	04a4d783          	lhu	a5,74(s1)
    80004348:	37fd                	addiw	a5,a5,-1
    8000434a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000434e:	8526                	mv	a0,s1
    80004350:	a68fe0ef          	jal	800025b8 <iupdate>
    80004354:	bfa9                	j	800042ae <sys_unlink+0xb6>
    80004356:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004358:	8526                	mv	a0,s1
    8000435a:	d1cfe0ef          	jal	80002876 <iunlockput>
  end_op();
    8000435e:	d63fe0ef          	jal	800030c0 <end_op>
  return -1;
    80004362:	557d                	li	a0,-1
    80004364:	64ee                	ld	s1,216(sp)
}
    80004366:	70ae                	ld	ra,232(sp)
    80004368:	740e                	ld	s0,224(sp)
    8000436a:	616d                	addi	sp,sp,240
    8000436c:	8082                	ret
    return -1;
    8000436e:	557d                	li	a0,-1
    80004370:	bfdd                	j	80004366 <sys_unlink+0x16e>
    iunlockput(ip);
    80004372:	854a                	mv	a0,s2
    80004374:	d02fe0ef          	jal	80002876 <iunlockput>
    goto bad;
    80004378:	694e                	ld	s2,208(sp)
    8000437a:	69ae                	ld	s3,200(sp)
    8000437c:	bff1                	j	80004358 <sys_unlink+0x160>

000000008000437e <sys_open>:

uint64
sys_open(void)
{
    8000437e:	7131                	addi	sp,sp,-192
    80004380:	fd06                	sd	ra,184(sp)
    80004382:	f922                	sd	s0,176(sp)
    80004384:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004386:	f4c40593          	addi	a1,s0,-180
    8000438a:	4505                	li	a0,1
    8000438c:	8ebfd0ef          	jal	80001c76 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004390:	08000613          	li	a2,128
    80004394:	f5040593          	addi	a1,s0,-176
    80004398:	4501                	li	a0,0
    8000439a:	915fd0ef          	jal	80001cae <argstr>
    8000439e:	87aa                	mv	a5,a0
    return -1;
    800043a0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043a2:	0a07c263          	bltz	a5,80004446 <sys_open+0xc8>
    800043a6:	f526                	sd	s1,168(sp)

  begin_op();
    800043a8:	caffe0ef          	jal	80003056 <begin_op>

  if(omode & O_CREATE){
    800043ac:	f4c42783          	lw	a5,-180(s0)
    800043b0:	2007f793          	andi	a5,a5,512
    800043b4:	c3d5                	beqz	a5,80004458 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800043b6:	4681                	li	a3,0
    800043b8:	4601                	li	a2,0
    800043ba:	4589                	li	a1,2
    800043bc:	f5040513          	addi	a0,s0,-176
    800043c0:	aa9ff0ef          	jal	80003e68 <create>
    800043c4:	84aa                	mv	s1,a0
    if(ip == 0){
    800043c6:	c541                	beqz	a0,8000444e <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800043c8:	04449703          	lh	a4,68(s1)
    800043cc:	478d                	li	a5,3
    800043ce:	00f71763          	bne	a4,a5,800043dc <sys_open+0x5e>
    800043d2:	0464d703          	lhu	a4,70(s1)
    800043d6:	47a5                	li	a5,9
    800043d8:	0ae7ed63          	bltu	a5,a4,80004492 <sys_open+0x114>
    800043dc:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800043de:	fe1fe0ef          	jal	800033be <filealloc>
    800043e2:	892a                	mv	s2,a0
    800043e4:	c179                	beqz	a0,800044aa <sys_open+0x12c>
    800043e6:	ed4e                	sd	s3,152(sp)
    800043e8:	a43ff0ef          	jal	80003e2a <fdalloc>
    800043ec:	89aa                	mv	s3,a0
    800043ee:	0a054a63          	bltz	a0,800044a2 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800043f2:	04449703          	lh	a4,68(s1)
    800043f6:	478d                	li	a5,3
    800043f8:	0cf70263          	beq	a4,a5,800044bc <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800043fc:	4789                	li	a5,2
    800043fe:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004402:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004406:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000440a:	f4c42783          	lw	a5,-180(s0)
    8000440e:	0017c713          	xori	a4,a5,1
    80004412:	8b05                	andi	a4,a4,1
    80004414:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004418:	0037f713          	andi	a4,a5,3
    8000441c:	00e03733          	snez	a4,a4
    80004420:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004424:	4007f793          	andi	a5,a5,1024
    80004428:	c791                	beqz	a5,80004434 <sys_open+0xb6>
    8000442a:	04449703          	lh	a4,68(s1)
    8000442e:	4789                	li	a5,2
    80004430:	08f70d63          	beq	a4,a5,800044ca <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004434:	8526                	mv	a0,s1
    80004436:	ae4fe0ef          	jal	8000271a <iunlock>
  end_op();
    8000443a:	c87fe0ef          	jal	800030c0 <end_op>

  return fd;
    8000443e:	854e                	mv	a0,s3
    80004440:	74aa                	ld	s1,168(sp)
    80004442:	790a                	ld	s2,160(sp)
    80004444:	69ea                	ld	s3,152(sp)
}
    80004446:	70ea                	ld	ra,184(sp)
    80004448:	744a                	ld	s0,176(sp)
    8000444a:	6129                	addi	sp,sp,192
    8000444c:	8082                	ret
      end_op();
    8000444e:	c73fe0ef          	jal	800030c0 <end_op>
      return -1;
    80004452:	557d                	li	a0,-1
    80004454:	74aa                	ld	s1,168(sp)
    80004456:	bfc5                	j	80004446 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004458:	f5040513          	addi	a0,s0,-176
    8000445c:	a27fe0ef          	jal	80002e82 <namei>
    80004460:	84aa                	mv	s1,a0
    80004462:	c11d                	beqz	a0,80004488 <sys_open+0x10a>
    ilock(ip);
    80004464:	a08fe0ef          	jal	8000266c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004468:	04449703          	lh	a4,68(s1)
    8000446c:	4785                	li	a5,1
    8000446e:	f4f71de3          	bne	a4,a5,800043c8 <sys_open+0x4a>
    80004472:	f4c42783          	lw	a5,-180(s0)
    80004476:	d3bd                	beqz	a5,800043dc <sys_open+0x5e>
      iunlockput(ip);
    80004478:	8526                	mv	a0,s1
    8000447a:	bfcfe0ef          	jal	80002876 <iunlockput>
      end_op();
    8000447e:	c43fe0ef          	jal	800030c0 <end_op>
      return -1;
    80004482:	557d                	li	a0,-1
    80004484:	74aa                	ld	s1,168(sp)
    80004486:	b7c1                	j	80004446 <sys_open+0xc8>
      end_op();
    80004488:	c39fe0ef          	jal	800030c0 <end_op>
      return -1;
    8000448c:	557d                	li	a0,-1
    8000448e:	74aa                	ld	s1,168(sp)
    80004490:	bf5d                	j	80004446 <sys_open+0xc8>
    iunlockput(ip);
    80004492:	8526                	mv	a0,s1
    80004494:	be2fe0ef          	jal	80002876 <iunlockput>
    end_op();
    80004498:	c29fe0ef          	jal	800030c0 <end_op>
    return -1;
    8000449c:	557d                	li	a0,-1
    8000449e:	74aa                	ld	s1,168(sp)
    800044a0:	b75d                	j	80004446 <sys_open+0xc8>
      fileclose(f);
    800044a2:	854a                	mv	a0,s2
    800044a4:	fbffe0ef          	jal	80003462 <fileclose>
    800044a8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044aa:	8526                	mv	a0,s1
    800044ac:	bcafe0ef          	jal	80002876 <iunlockput>
    end_op();
    800044b0:	c11fe0ef          	jal	800030c0 <end_op>
    return -1;
    800044b4:	557d                	li	a0,-1
    800044b6:	74aa                	ld	s1,168(sp)
    800044b8:	790a                	ld	s2,160(sp)
    800044ba:	b771                	j	80004446 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800044bc:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800044c0:	04649783          	lh	a5,70(s1)
    800044c4:	02f91223          	sh	a5,36(s2)
    800044c8:	bf3d                	j	80004406 <sys_open+0x88>
    itrunc(ip);
    800044ca:	8526                	mv	a0,s1
    800044cc:	a8efe0ef          	jal	8000275a <itrunc>
    800044d0:	b795                	j	80004434 <sys_open+0xb6>

00000000800044d2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800044d2:	7175                	addi	sp,sp,-144
    800044d4:	e506                	sd	ra,136(sp)
    800044d6:	e122                	sd	s0,128(sp)
    800044d8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800044da:	b7dfe0ef          	jal	80003056 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800044de:	08000613          	li	a2,128
    800044e2:	f7040593          	addi	a1,s0,-144
    800044e6:	4501                	li	a0,0
    800044e8:	fc6fd0ef          	jal	80001cae <argstr>
    800044ec:	02054363          	bltz	a0,80004512 <sys_mkdir+0x40>
    800044f0:	4681                	li	a3,0
    800044f2:	4601                	li	a2,0
    800044f4:	4585                	li	a1,1
    800044f6:	f7040513          	addi	a0,s0,-144
    800044fa:	96fff0ef          	jal	80003e68 <create>
    800044fe:	c911                	beqz	a0,80004512 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004500:	b76fe0ef          	jal	80002876 <iunlockput>
  end_op();
    80004504:	bbdfe0ef          	jal	800030c0 <end_op>
  return 0;
    80004508:	4501                	li	a0,0
}
    8000450a:	60aa                	ld	ra,136(sp)
    8000450c:	640a                	ld	s0,128(sp)
    8000450e:	6149                	addi	sp,sp,144
    80004510:	8082                	ret
    end_op();
    80004512:	baffe0ef          	jal	800030c0 <end_op>
    return -1;
    80004516:	557d                	li	a0,-1
    80004518:	bfcd                	j	8000450a <sys_mkdir+0x38>

000000008000451a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000451a:	7135                	addi	sp,sp,-160
    8000451c:	ed06                	sd	ra,152(sp)
    8000451e:	e922                	sd	s0,144(sp)
    80004520:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004522:	b35fe0ef          	jal	80003056 <begin_op>
  argint(1, &major);
    80004526:	f6c40593          	addi	a1,s0,-148
    8000452a:	4505                	li	a0,1
    8000452c:	f4afd0ef          	jal	80001c76 <argint>
  argint(2, &minor);
    80004530:	f6840593          	addi	a1,s0,-152
    80004534:	4509                	li	a0,2
    80004536:	f40fd0ef          	jal	80001c76 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000453a:	08000613          	li	a2,128
    8000453e:	f7040593          	addi	a1,s0,-144
    80004542:	4501                	li	a0,0
    80004544:	f6afd0ef          	jal	80001cae <argstr>
    80004548:	02054563          	bltz	a0,80004572 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000454c:	f6841683          	lh	a3,-152(s0)
    80004550:	f6c41603          	lh	a2,-148(s0)
    80004554:	458d                	li	a1,3
    80004556:	f7040513          	addi	a0,s0,-144
    8000455a:	90fff0ef          	jal	80003e68 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000455e:	c911                	beqz	a0,80004572 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004560:	b16fe0ef          	jal	80002876 <iunlockput>
  end_op();
    80004564:	b5dfe0ef          	jal	800030c0 <end_op>
  return 0;
    80004568:	4501                	li	a0,0
}
    8000456a:	60ea                	ld	ra,152(sp)
    8000456c:	644a                	ld	s0,144(sp)
    8000456e:	610d                	addi	sp,sp,160
    80004570:	8082                	ret
    end_op();
    80004572:	b4ffe0ef          	jal	800030c0 <end_op>
    return -1;
    80004576:	557d                	li	a0,-1
    80004578:	bfcd                	j	8000456a <sys_mknod+0x50>

000000008000457a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000457a:	7135                	addi	sp,sp,-160
    8000457c:	ed06                	sd	ra,152(sp)
    8000457e:	e922                	sd	s0,144(sp)
    80004580:	e14a                	sd	s2,128(sp)
    80004582:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004584:	ff6fc0ef          	jal	80000d7a <myproc>
    80004588:	892a                	mv	s2,a0
  
  begin_op();
    8000458a:	acdfe0ef          	jal	80003056 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000458e:	08000613          	li	a2,128
    80004592:	f6040593          	addi	a1,s0,-160
    80004596:	4501                	li	a0,0
    80004598:	f16fd0ef          	jal	80001cae <argstr>
    8000459c:	04054363          	bltz	a0,800045e2 <sys_chdir+0x68>
    800045a0:	e526                	sd	s1,136(sp)
    800045a2:	f6040513          	addi	a0,s0,-160
    800045a6:	8ddfe0ef          	jal	80002e82 <namei>
    800045aa:	84aa                	mv	s1,a0
    800045ac:	c915                	beqz	a0,800045e0 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800045ae:	8befe0ef          	jal	8000266c <ilock>
  if(ip->type != T_DIR){
    800045b2:	04449703          	lh	a4,68(s1)
    800045b6:	4785                	li	a5,1
    800045b8:	02f71963          	bne	a4,a5,800045ea <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800045bc:	8526                	mv	a0,s1
    800045be:	95cfe0ef          	jal	8000271a <iunlock>
  iput(p->cwd);
    800045c2:	15093503          	ld	a0,336(s2)
    800045c6:	a28fe0ef          	jal	800027ee <iput>
  end_op();
    800045ca:	af7fe0ef          	jal	800030c0 <end_op>
  p->cwd = ip;
    800045ce:	14993823          	sd	s1,336(s2)
  return 0;
    800045d2:	4501                	li	a0,0
    800045d4:	64aa                	ld	s1,136(sp)
}
    800045d6:	60ea                	ld	ra,152(sp)
    800045d8:	644a                	ld	s0,144(sp)
    800045da:	690a                	ld	s2,128(sp)
    800045dc:	610d                	addi	sp,sp,160
    800045de:	8082                	ret
    800045e0:	64aa                	ld	s1,136(sp)
    end_op();
    800045e2:	adffe0ef          	jal	800030c0 <end_op>
    return -1;
    800045e6:	557d                	li	a0,-1
    800045e8:	b7fd                	j	800045d6 <sys_chdir+0x5c>
    iunlockput(ip);
    800045ea:	8526                	mv	a0,s1
    800045ec:	a8afe0ef          	jal	80002876 <iunlockput>
    end_op();
    800045f0:	ad1fe0ef          	jal	800030c0 <end_op>
    return -1;
    800045f4:	557d                	li	a0,-1
    800045f6:	64aa                	ld	s1,136(sp)
    800045f8:	bff9                	j	800045d6 <sys_chdir+0x5c>

00000000800045fa <sys_exec>:

uint64
sys_exec(void)
{
    800045fa:	7121                	addi	sp,sp,-448
    800045fc:	ff06                	sd	ra,440(sp)
    800045fe:	fb22                	sd	s0,432(sp)
    80004600:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004602:	e4840593          	addi	a1,s0,-440
    80004606:	4505                	li	a0,1
    80004608:	e8afd0ef          	jal	80001c92 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000460c:	08000613          	li	a2,128
    80004610:	f5040593          	addi	a1,s0,-176
    80004614:	4501                	li	a0,0
    80004616:	e98fd0ef          	jal	80001cae <argstr>
    8000461a:	87aa                	mv	a5,a0
    return -1;
    8000461c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000461e:	0c07c463          	bltz	a5,800046e6 <sys_exec+0xec>
    80004622:	f726                	sd	s1,424(sp)
    80004624:	f34a                	sd	s2,416(sp)
    80004626:	ef4e                	sd	s3,408(sp)
    80004628:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000462a:	10000613          	li	a2,256
    8000462e:	4581                	li	a1,0
    80004630:	e5040513          	addi	a0,s0,-432
    80004634:	b1bfb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004638:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000463c:	89a6                	mv	s3,s1
    8000463e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004640:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004644:	00391513          	slli	a0,s2,0x3
    80004648:	e4040593          	addi	a1,s0,-448
    8000464c:	e4843783          	ld	a5,-440(s0)
    80004650:	953e                	add	a0,a0,a5
    80004652:	d9afd0ef          	jal	80001bec <fetchaddr>
    80004656:	02054663          	bltz	a0,80004682 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000465a:	e4043783          	ld	a5,-448(s0)
    8000465e:	c3a9                	beqz	a5,800046a0 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004660:	a9ffb0ef          	jal	800000fe <kalloc>
    80004664:	85aa                	mv	a1,a0
    80004666:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000466a:	cd01                	beqz	a0,80004682 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000466c:	6605                	lui	a2,0x1
    8000466e:	e4043503          	ld	a0,-448(s0)
    80004672:	dc4fd0ef          	jal	80001c36 <fetchstr>
    80004676:	00054663          	bltz	a0,80004682 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000467a:	0905                	addi	s2,s2,1
    8000467c:	09a1                	addi	s3,s3,8
    8000467e:	fd4913e3          	bne	s2,s4,80004644 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004682:	f5040913          	addi	s2,s0,-176
    80004686:	6088                	ld	a0,0(s1)
    80004688:	c931                	beqz	a0,800046dc <sys_exec+0xe2>
    kfree(argv[i]);
    8000468a:	993fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000468e:	04a1                	addi	s1,s1,8
    80004690:	ff249be3          	bne	s1,s2,80004686 <sys_exec+0x8c>
  return -1;
    80004694:	557d                	li	a0,-1
    80004696:	74ba                	ld	s1,424(sp)
    80004698:	791a                	ld	s2,416(sp)
    8000469a:	69fa                	ld	s3,408(sp)
    8000469c:	6a5a                	ld	s4,400(sp)
    8000469e:	a0a1                	j	800046e6 <sys_exec+0xec>
      argv[i] = 0;
    800046a0:	0009079b          	sext.w	a5,s2
    800046a4:	078e                	slli	a5,a5,0x3
    800046a6:	fd078793          	addi	a5,a5,-48
    800046aa:	97a2                	add	a5,a5,s0
    800046ac:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    800046b0:	e5040593          	addi	a1,s0,-432
    800046b4:	f5040513          	addi	a0,s0,-176
    800046b8:	ba8ff0ef          	jal	80003a60 <kexec>
    800046bc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046be:	f5040993          	addi	s3,s0,-176
    800046c2:	6088                	ld	a0,0(s1)
    800046c4:	c511                	beqz	a0,800046d0 <sys_exec+0xd6>
    kfree(argv[i]);
    800046c6:	957fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ca:	04a1                	addi	s1,s1,8
    800046cc:	ff349be3          	bne	s1,s3,800046c2 <sys_exec+0xc8>
  return ret;
    800046d0:	854a                	mv	a0,s2
    800046d2:	74ba                	ld	s1,424(sp)
    800046d4:	791a                	ld	s2,416(sp)
    800046d6:	69fa                	ld	s3,408(sp)
    800046d8:	6a5a                	ld	s4,400(sp)
    800046da:	a031                	j	800046e6 <sys_exec+0xec>
  return -1;
    800046dc:	557d                	li	a0,-1
    800046de:	74ba                	ld	s1,424(sp)
    800046e0:	791a                	ld	s2,416(sp)
    800046e2:	69fa                	ld	s3,408(sp)
    800046e4:	6a5a                	ld	s4,400(sp)
}
    800046e6:	70fa                	ld	ra,440(sp)
    800046e8:	745a                	ld	s0,432(sp)
    800046ea:	6139                	addi	sp,sp,448
    800046ec:	8082                	ret

00000000800046ee <sys_pipe>:

uint64
sys_pipe(void)
{
    800046ee:	7139                	addi	sp,sp,-64
    800046f0:	fc06                	sd	ra,56(sp)
    800046f2:	f822                	sd	s0,48(sp)
    800046f4:	f426                	sd	s1,40(sp)
    800046f6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800046f8:	e82fc0ef          	jal	80000d7a <myproc>
    800046fc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046fe:	fd840593          	addi	a1,s0,-40
    80004702:	4501                	li	a0,0
    80004704:	d8efd0ef          	jal	80001c92 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004708:	fc840593          	addi	a1,s0,-56
    8000470c:	fd040513          	addi	a0,s0,-48
    80004710:	85cff0ef          	jal	8000376c <pipealloc>
    return -1;
    80004714:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004716:	0a054463          	bltz	a0,800047be <sys_pipe+0xd0>
  fd0 = -1;
    8000471a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000471e:	fd043503          	ld	a0,-48(s0)
    80004722:	f08ff0ef          	jal	80003e2a <fdalloc>
    80004726:	fca42223          	sw	a0,-60(s0)
    8000472a:	08054163          	bltz	a0,800047ac <sys_pipe+0xbe>
    8000472e:	fc843503          	ld	a0,-56(s0)
    80004732:	ef8ff0ef          	jal	80003e2a <fdalloc>
    80004736:	fca42023          	sw	a0,-64(s0)
    8000473a:	06054063          	bltz	a0,8000479a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000473e:	4691                	li	a3,4
    80004740:	fc440613          	addi	a2,s0,-60
    80004744:	fd843583          	ld	a1,-40(s0)
    80004748:	68a8                	ld	a0,80(s1)
    8000474a:	b44fc0ef          	jal	80000a8e <copyout>
    8000474e:	00054e63          	bltz	a0,8000476a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004752:	4691                	li	a3,4
    80004754:	fc040613          	addi	a2,s0,-64
    80004758:	fd843583          	ld	a1,-40(s0)
    8000475c:	0591                	addi	a1,a1,4
    8000475e:	68a8                	ld	a0,80(s1)
    80004760:	b2efc0ef          	jal	80000a8e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004764:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004766:	04055c63          	bgez	a0,800047be <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000476a:	fc442783          	lw	a5,-60(s0)
    8000476e:	07e9                	addi	a5,a5,26
    80004770:	078e                	slli	a5,a5,0x3
    80004772:	97a6                	add	a5,a5,s1
    80004774:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004778:	fc042783          	lw	a5,-64(s0)
    8000477c:	07e9                	addi	a5,a5,26
    8000477e:	078e                	slli	a5,a5,0x3
    80004780:	94be                	add	s1,s1,a5
    80004782:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004786:	fd043503          	ld	a0,-48(s0)
    8000478a:	cd9fe0ef          	jal	80003462 <fileclose>
    fileclose(wf);
    8000478e:	fc843503          	ld	a0,-56(s0)
    80004792:	cd1fe0ef          	jal	80003462 <fileclose>
    return -1;
    80004796:	57fd                	li	a5,-1
    80004798:	a01d                	j	800047be <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000479a:	fc442783          	lw	a5,-60(s0)
    8000479e:	0007c763          	bltz	a5,800047ac <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800047a2:	07e9                	addi	a5,a5,26
    800047a4:	078e                	slli	a5,a5,0x3
    800047a6:	97a6                	add	a5,a5,s1
    800047a8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047ac:	fd043503          	ld	a0,-48(s0)
    800047b0:	cb3fe0ef          	jal	80003462 <fileclose>
    fileclose(wf);
    800047b4:	fc843503          	ld	a0,-56(s0)
    800047b8:	cabfe0ef          	jal	80003462 <fileclose>
    return -1;
    800047bc:	57fd                	li	a5,-1
}
    800047be:	853e                	mv	a0,a5
    800047c0:	70e2                	ld	ra,56(sp)
    800047c2:	7442                	ld	s0,48(sp)
    800047c4:	74a2                	ld	s1,40(sp)
    800047c6:	6121                	addi	sp,sp,64
    800047c8:	8082                	ret
    800047ca:	0000                	unimp
    800047cc:	0000                	unimp
	...

00000000800047d0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800047d0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800047d2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800047d4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    800047d6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    800047d8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800047da:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800047dc:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800047de:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800047e0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800047e2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800047e4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800047e6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800047e8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800047ea:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800047ec:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800047ee:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800047f0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800047f2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800047f4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800047f6:	b06fd0ef          	jal	80001afc <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800047fa:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800047fc:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800047fe:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004800:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004802:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004804:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004806:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004808:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000480a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000480c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000480e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004810:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004812:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004814:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004816:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004818:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000481a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000481c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000481e:	10200073          	sret
	...

000000008000482e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000482e:	1141                	addi	sp,sp,-16
    80004830:	e422                	sd	s0,8(sp)
    80004832:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004834:	0c0007b7          	lui	a5,0xc000
    80004838:	4705                	li	a4,1
    8000483a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000483c:	0c0007b7          	lui	a5,0xc000
    80004840:	c3d8                	sw	a4,4(a5)
}
    80004842:	6422                	ld	s0,8(sp)
    80004844:	0141                	addi	sp,sp,16
    80004846:	8082                	ret

0000000080004848 <plicinithart>:

void
plicinithart(void)
{
    80004848:	1141                	addi	sp,sp,-16
    8000484a:	e406                	sd	ra,8(sp)
    8000484c:	e022                	sd	s0,0(sp)
    8000484e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004850:	cfefc0ef          	jal	80000d4e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004854:	0085171b          	slliw	a4,a0,0x8
    80004858:	0c0027b7          	lui	a5,0xc002
    8000485c:	97ba                	add	a5,a5,a4
    8000485e:	40200713          	li	a4,1026
    80004862:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004866:	00d5151b          	slliw	a0,a0,0xd
    8000486a:	0c2017b7          	lui	a5,0xc201
    8000486e:	97aa                	add	a5,a5,a0
    80004870:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004874:	60a2                	ld	ra,8(sp)
    80004876:	6402                	ld	s0,0(sp)
    80004878:	0141                	addi	sp,sp,16
    8000487a:	8082                	ret

000000008000487c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000487c:	1141                	addi	sp,sp,-16
    8000487e:	e406                	sd	ra,8(sp)
    80004880:	e022                	sd	s0,0(sp)
    80004882:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004884:	ccafc0ef          	jal	80000d4e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004888:	00d5151b          	slliw	a0,a0,0xd
    8000488c:	0c2017b7          	lui	a5,0xc201
    80004890:	97aa                	add	a5,a5,a0
  return irq;
}
    80004892:	43c8                	lw	a0,4(a5)
    80004894:	60a2                	ld	ra,8(sp)
    80004896:	6402                	ld	s0,0(sp)
    80004898:	0141                	addi	sp,sp,16
    8000489a:	8082                	ret

000000008000489c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000489c:	1101                	addi	sp,sp,-32
    8000489e:	ec06                	sd	ra,24(sp)
    800048a0:	e822                	sd	s0,16(sp)
    800048a2:	e426                	sd	s1,8(sp)
    800048a4:	1000                	addi	s0,sp,32
    800048a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800048a8:	ca6fc0ef          	jal	80000d4e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800048ac:	00d5151b          	slliw	a0,a0,0xd
    800048b0:	0c2017b7          	lui	a5,0xc201
    800048b4:	97aa                	add	a5,a5,a0
    800048b6:	c3c4                	sw	s1,4(a5)
}
    800048b8:	60e2                	ld	ra,24(sp)
    800048ba:	6442                	ld	s0,16(sp)
    800048bc:	64a2                	ld	s1,8(sp)
    800048be:	6105                	addi	sp,sp,32
    800048c0:	8082                	ret

00000000800048c2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800048c2:	1141                	addi	sp,sp,-16
    800048c4:	e406                	sd	ra,8(sp)
    800048c6:	e022                	sd	s0,0(sp)
    800048c8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800048ca:	479d                	li	a5,7
    800048cc:	04a7ca63          	blt	a5,a0,80004920 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800048d0:	00017797          	auipc	a5,0x17
    800048d4:	9c078793          	addi	a5,a5,-1600 # 8001b290 <disk>
    800048d8:	97aa                	add	a5,a5,a0
    800048da:	0187c783          	lbu	a5,24(a5)
    800048de:	e7b9                	bnez	a5,8000492c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800048e0:	00451693          	slli	a3,a0,0x4
    800048e4:	00017797          	auipc	a5,0x17
    800048e8:	9ac78793          	addi	a5,a5,-1620 # 8001b290 <disk>
    800048ec:	6398                	ld	a4,0(a5)
    800048ee:	9736                	add	a4,a4,a3
    800048f0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800048f4:	6398                	ld	a4,0(a5)
    800048f6:	9736                	add	a4,a4,a3
    800048f8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800048fc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004900:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004904:	97aa                	add	a5,a5,a0
    80004906:	4705                	li	a4,1
    80004908:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000490c:	00017517          	auipc	a0,0x17
    80004910:	99c50513          	addi	a0,a0,-1636 # 8001b2a8 <disk+0x18>
    80004914:	aabfc0ef          	jal	800013be <wakeup>
}
    80004918:	60a2                	ld	ra,8(sp)
    8000491a:	6402                	ld	s0,0(sp)
    8000491c:	0141                	addi	sp,sp,16
    8000491e:	8082                	ret
    panic("free_desc 1");
    80004920:	00003517          	auipc	a0,0x3
    80004924:	c9050513          	addi	a0,a0,-880 # 800075b0 <etext+0x5b0>
    80004928:	487000ef          	jal	800055ae <panic>
    panic("free_desc 2");
    8000492c:	00003517          	auipc	a0,0x3
    80004930:	c9450513          	addi	a0,a0,-876 # 800075c0 <etext+0x5c0>
    80004934:	47b000ef          	jal	800055ae <panic>

0000000080004938 <virtio_disk_init>:
{
    80004938:	1101                	addi	sp,sp,-32
    8000493a:	ec06                	sd	ra,24(sp)
    8000493c:	e822                	sd	s0,16(sp)
    8000493e:	e426                	sd	s1,8(sp)
    80004940:	e04a                	sd	s2,0(sp)
    80004942:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004944:	00003597          	auipc	a1,0x3
    80004948:	c8c58593          	addi	a1,a1,-884 # 800075d0 <etext+0x5d0>
    8000494c:	00017517          	auipc	a0,0x17
    80004950:	a6c50513          	addi	a0,a0,-1428 # 8001b3b8 <disk+0x128>
    80004954:	697000ef          	jal	800057ea <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004958:	100017b7          	lui	a5,0x10001
    8000495c:	4398                	lw	a4,0(a5)
    8000495e:	2701                	sext.w	a4,a4
    80004960:	747277b7          	lui	a5,0x74727
    80004964:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004968:	18f71063          	bne	a4,a5,80004ae8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000496c:	100017b7          	lui	a5,0x10001
    80004970:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004972:	439c                	lw	a5,0(a5)
    80004974:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004976:	4709                	li	a4,2
    80004978:	16e79863          	bne	a5,a4,80004ae8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000497c:	100017b7          	lui	a5,0x10001
    80004980:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004982:	439c                	lw	a5,0(a5)
    80004984:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004986:	16e79163          	bne	a5,a4,80004ae8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000498a:	100017b7          	lui	a5,0x10001
    8000498e:	47d8                	lw	a4,12(a5)
    80004990:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004992:	554d47b7          	lui	a5,0x554d4
    80004996:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000499a:	14f71763          	bne	a4,a5,80004ae8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000499e:	100017b7          	lui	a5,0x10001
    800049a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049a6:	4705                	li	a4,1
    800049a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049aa:	470d                	li	a4,3
    800049ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800049ae:	10001737          	lui	a4,0x10001
    800049b2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800049b4:	c7ffe737          	lui	a4,0xc7ffe
    800049b8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb2b7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800049bc:	8ef9                	and	a3,a3,a4
    800049be:	10001737          	lui	a4,0x10001
    800049c2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049c4:	472d                	li	a4,11
    800049c6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049c8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800049cc:	439c                	lw	a5,0(a5)
    800049ce:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800049d2:	8ba1                	andi	a5,a5,8
    800049d4:	12078063          	beqz	a5,80004af4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800049d8:	100017b7          	lui	a5,0x10001
    800049dc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800049e0:	100017b7          	lui	a5,0x10001
    800049e4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800049e8:	439c                	lw	a5,0(a5)
    800049ea:	2781                	sext.w	a5,a5
    800049ec:	10079a63          	bnez	a5,80004b00 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800049f0:	100017b7          	lui	a5,0x10001
    800049f4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800049f8:	439c                	lw	a5,0(a5)
    800049fa:	2781                	sext.w	a5,a5
  if(max == 0)
    800049fc:	10078863          	beqz	a5,80004b0c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a00:	471d                	li	a4,7
    80004a02:	10f77b63          	bgeu	a4,a5,80004b18 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a06:	ef8fb0ef          	jal	800000fe <kalloc>
    80004a0a:	00017497          	auipc	s1,0x17
    80004a0e:	88648493          	addi	s1,s1,-1914 # 8001b290 <disk>
    80004a12:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a14:	eeafb0ef          	jal	800000fe <kalloc>
    80004a18:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a1a:	ee4fb0ef          	jal	800000fe <kalloc>
    80004a1e:	87aa                	mv	a5,a0
    80004a20:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004a22:	6088                	ld	a0,0(s1)
    80004a24:	10050063          	beqz	a0,80004b24 <virtio_disk_init+0x1ec>
    80004a28:	00017717          	auipc	a4,0x17
    80004a2c:	87073703          	ld	a4,-1936(a4) # 8001b298 <disk+0x8>
    80004a30:	0e070a63          	beqz	a4,80004b24 <virtio_disk_init+0x1ec>
    80004a34:	0e078863          	beqz	a5,80004b24 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004a38:	6605                	lui	a2,0x1
    80004a3a:	4581                	li	a1,0
    80004a3c:	f12fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a40:	00017497          	auipc	s1,0x17
    80004a44:	85048493          	addi	s1,s1,-1968 # 8001b290 <disk>
    80004a48:	6605                	lui	a2,0x1
    80004a4a:	4581                	li	a1,0
    80004a4c:	6488                	ld	a0,8(s1)
    80004a4e:	f00fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004a52:	6605                	lui	a2,0x1
    80004a54:	4581                	li	a1,0
    80004a56:	6888                	ld	a0,16(s1)
    80004a58:	ef6fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a5c:	100017b7          	lui	a5,0x10001
    80004a60:	4721                	li	a4,8
    80004a62:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004a64:	4098                	lw	a4,0(s1)
    80004a66:	100017b7          	lui	a5,0x10001
    80004a6a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004a6e:	40d8                	lw	a4,4(s1)
    80004a70:	100017b7          	lui	a5,0x10001
    80004a74:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004a78:	649c                	ld	a5,8(s1)
    80004a7a:	0007869b          	sext.w	a3,a5
    80004a7e:	10001737          	lui	a4,0x10001
    80004a82:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004a86:	9781                	srai	a5,a5,0x20
    80004a88:	10001737          	lui	a4,0x10001
    80004a8c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004a90:	689c                	ld	a5,16(s1)
    80004a92:	0007869b          	sext.w	a3,a5
    80004a96:	10001737          	lui	a4,0x10001
    80004a9a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004a9e:	9781                	srai	a5,a5,0x20
    80004aa0:	10001737          	lui	a4,0x10001
    80004aa4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004aa8:	10001737          	lui	a4,0x10001
    80004aac:	4785                	li	a5,1
    80004aae:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004ab0:	00f48c23          	sb	a5,24(s1)
    80004ab4:	00f48ca3          	sb	a5,25(s1)
    80004ab8:	00f48d23          	sb	a5,26(s1)
    80004abc:	00f48da3          	sb	a5,27(s1)
    80004ac0:	00f48e23          	sb	a5,28(s1)
    80004ac4:	00f48ea3          	sb	a5,29(s1)
    80004ac8:	00f48f23          	sb	a5,30(s1)
    80004acc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004ad0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ad4:	100017b7          	lui	a5,0x10001
    80004ad8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004adc:	60e2                	ld	ra,24(sp)
    80004ade:	6442                	ld	s0,16(sp)
    80004ae0:	64a2                	ld	s1,8(sp)
    80004ae2:	6902                	ld	s2,0(sp)
    80004ae4:	6105                	addi	sp,sp,32
    80004ae6:	8082                	ret
    panic("could not find virtio disk");
    80004ae8:	00003517          	auipc	a0,0x3
    80004aec:	af850513          	addi	a0,a0,-1288 # 800075e0 <etext+0x5e0>
    80004af0:	2bf000ef          	jal	800055ae <panic>
    panic("virtio disk FEATURES_OK unset");
    80004af4:	00003517          	auipc	a0,0x3
    80004af8:	b0c50513          	addi	a0,a0,-1268 # 80007600 <etext+0x600>
    80004afc:	2b3000ef          	jal	800055ae <panic>
    panic("virtio disk should not be ready");
    80004b00:	00003517          	auipc	a0,0x3
    80004b04:	b2050513          	addi	a0,a0,-1248 # 80007620 <etext+0x620>
    80004b08:	2a7000ef          	jal	800055ae <panic>
    panic("virtio disk has no queue 0");
    80004b0c:	00003517          	auipc	a0,0x3
    80004b10:	b3450513          	addi	a0,a0,-1228 # 80007640 <etext+0x640>
    80004b14:	29b000ef          	jal	800055ae <panic>
    panic("virtio disk max queue too short");
    80004b18:	00003517          	auipc	a0,0x3
    80004b1c:	b4850513          	addi	a0,a0,-1208 # 80007660 <etext+0x660>
    80004b20:	28f000ef          	jal	800055ae <panic>
    panic("virtio disk kalloc");
    80004b24:	00003517          	auipc	a0,0x3
    80004b28:	b5c50513          	addi	a0,a0,-1188 # 80007680 <etext+0x680>
    80004b2c:	283000ef          	jal	800055ae <panic>

0000000080004b30 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004b30:	7159                	addi	sp,sp,-112
    80004b32:	f486                	sd	ra,104(sp)
    80004b34:	f0a2                	sd	s0,96(sp)
    80004b36:	eca6                	sd	s1,88(sp)
    80004b38:	e8ca                	sd	s2,80(sp)
    80004b3a:	e4ce                	sd	s3,72(sp)
    80004b3c:	e0d2                	sd	s4,64(sp)
    80004b3e:	fc56                	sd	s5,56(sp)
    80004b40:	f85a                	sd	s6,48(sp)
    80004b42:	f45e                	sd	s7,40(sp)
    80004b44:	f062                	sd	s8,32(sp)
    80004b46:	ec66                	sd	s9,24(sp)
    80004b48:	1880                	addi	s0,sp,112
    80004b4a:	8a2a                	mv	s4,a0
    80004b4c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004b4e:	00c52c83          	lw	s9,12(a0)
    80004b52:	001c9c9b          	slliw	s9,s9,0x1
    80004b56:	1c82                	slli	s9,s9,0x20
    80004b58:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004b5c:	00017517          	auipc	a0,0x17
    80004b60:	85c50513          	addi	a0,a0,-1956 # 8001b3b8 <disk+0x128>
    80004b64:	507000ef          	jal	8000586a <acquire>
  for(int i = 0; i < 3; i++){
    80004b68:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004b6a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004b6c:	00016b17          	auipc	s6,0x16
    80004b70:	724b0b13          	addi	s6,s6,1828 # 8001b290 <disk>
  for(int i = 0; i < 3; i++){
    80004b74:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b76:	00017c17          	auipc	s8,0x17
    80004b7a:	842c0c13          	addi	s8,s8,-1982 # 8001b3b8 <disk+0x128>
    80004b7e:	a8b9                	j	80004bdc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004b80:	00fb0733          	add	a4,s6,a5
    80004b84:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004b88:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004b8a:	0207c563          	bltz	a5,80004bb4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004b8e:	2905                	addiw	s2,s2,1
    80004b90:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004b92:	05590963          	beq	s2,s5,80004be4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004b96:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004b98:	00016717          	auipc	a4,0x16
    80004b9c:	6f870713          	addi	a4,a4,1784 # 8001b290 <disk>
    80004ba0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004ba2:	01874683          	lbu	a3,24(a4)
    80004ba6:	fee9                	bnez	a3,80004b80 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004ba8:	2785                	addiw	a5,a5,1
    80004baa:	0705                	addi	a4,a4,1
    80004bac:	fe979be3          	bne	a5,s1,80004ba2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004bb0:	57fd                	li	a5,-1
    80004bb2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004bb4:	01205d63          	blez	s2,80004bce <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004bb8:	f9042503          	lw	a0,-112(s0)
    80004bbc:	d07ff0ef          	jal	800048c2 <free_desc>
      for(int j = 0; j < i; j++)
    80004bc0:	4785                	li	a5,1
    80004bc2:	0127d663          	bge	a5,s2,80004bce <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004bc6:	f9442503          	lw	a0,-108(s0)
    80004bca:	cf9ff0ef          	jal	800048c2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004bce:	85e2                	mv	a1,s8
    80004bd0:	00016517          	auipc	a0,0x16
    80004bd4:	6d850513          	addi	a0,a0,1752 # 8001b2a8 <disk+0x18>
    80004bd8:	f9afc0ef          	jal	80001372 <sleep>
  for(int i = 0; i < 3; i++){
    80004bdc:	f9040613          	addi	a2,s0,-112
    80004be0:	894e                	mv	s2,s3
    80004be2:	bf55                	j	80004b96 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004be4:	f9042503          	lw	a0,-112(s0)
    80004be8:	00451693          	slli	a3,a0,0x4

  if(write)
    80004bec:	00016797          	auipc	a5,0x16
    80004bf0:	6a478793          	addi	a5,a5,1700 # 8001b290 <disk>
    80004bf4:	00a50713          	addi	a4,a0,10
    80004bf8:	0712                	slli	a4,a4,0x4
    80004bfa:	973e                	add	a4,a4,a5
    80004bfc:	01703633          	snez	a2,s7
    80004c00:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c02:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c06:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c0a:	6398                	ld	a4,0(a5)
    80004c0c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c0e:	0a868613          	addi	a2,a3,168
    80004c12:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c14:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c16:	6390                	ld	a2,0(a5)
    80004c18:	00d605b3          	add	a1,a2,a3
    80004c1c:	4741                	li	a4,16
    80004c1e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004c20:	4805                	li	a6,1
    80004c22:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004c26:	f9442703          	lw	a4,-108(s0)
    80004c2a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004c2e:	0712                	slli	a4,a4,0x4
    80004c30:	963a                	add	a2,a2,a4
    80004c32:	058a0593          	addi	a1,s4,88
    80004c36:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004c38:	0007b883          	ld	a7,0(a5)
    80004c3c:	9746                	add	a4,a4,a7
    80004c3e:	40000613          	li	a2,1024
    80004c42:	c710                	sw	a2,8(a4)
  if(write)
    80004c44:	001bb613          	seqz	a2,s7
    80004c48:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004c4c:	00166613          	ori	a2,a2,1
    80004c50:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004c54:	f9842583          	lw	a1,-104(s0)
    80004c58:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004c5c:	00250613          	addi	a2,a0,2
    80004c60:	0612                	slli	a2,a2,0x4
    80004c62:	963e                	add	a2,a2,a5
    80004c64:	577d                	li	a4,-1
    80004c66:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004c6a:	0592                	slli	a1,a1,0x4
    80004c6c:	98ae                	add	a7,a7,a1
    80004c6e:	03068713          	addi	a4,a3,48
    80004c72:	973e                	add	a4,a4,a5
    80004c74:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004c78:	6398                	ld	a4,0(a5)
    80004c7a:	972e                	add	a4,a4,a1
    80004c7c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004c80:	4689                	li	a3,2
    80004c82:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004c86:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004c8a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004c8e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004c92:	6794                	ld	a3,8(a5)
    80004c94:	0026d703          	lhu	a4,2(a3)
    80004c98:	8b1d                	andi	a4,a4,7
    80004c9a:	0706                	slli	a4,a4,0x1
    80004c9c:	96ba                	add	a3,a3,a4
    80004c9e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004ca2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004ca6:	6798                	ld	a4,8(a5)
    80004ca8:	00275783          	lhu	a5,2(a4)
    80004cac:	2785                	addiw	a5,a5,1
    80004cae:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004cb2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004cb6:	100017b7          	lui	a5,0x10001
    80004cba:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004cbe:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004cc2:	00016917          	auipc	s2,0x16
    80004cc6:	6f690913          	addi	s2,s2,1782 # 8001b3b8 <disk+0x128>
  while(b->disk == 1) {
    80004cca:	4485                	li	s1,1
    80004ccc:	01079a63          	bne	a5,a6,80004ce0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004cd0:	85ca                	mv	a1,s2
    80004cd2:	8552                	mv	a0,s4
    80004cd4:	e9efc0ef          	jal	80001372 <sleep>
  while(b->disk == 1) {
    80004cd8:	004a2783          	lw	a5,4(s4)
    80004cdc:	fe978ae3          	beq	a5,s1,80004cd0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004ce0:	f9042903          	lw	s2,-112(s0)
    80004ce4:	00290713          	addi	a4,s2,2
    80004ce8:	0712                	slli	a4,a4,0x4
    80004cea:	00016797          	auipc	a5,0x16
    80004cee:	5a678793          	addi	a5,a5,1446 # 8001b290 <disk>
    80004cf2:	97ba                	add	a5,a5,a4
    80004cf4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004cf8:	00016997          	auipc	s3,0x16
    80004cfc:	59898993          	addi	s3,s3,1432 # 8001b290 <disk>
    80004d00:	00491713          	slli	a4,s2,0x4
    80004d04:	0009b783          	ld	a5,0(s3)
    80004d08:	97ba                	add	a5,a5,a4
    80004d0a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d0e:	854a                	mv	a0,s2
    80004d10:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d14:	bafff0ef          	jal	800048c2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d18:	8885                	andi	s1,s1,1
    80004d1a:	f0fd                	bnez	s1,80004d00 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d1c:	00016517          	auipc	a0,0x16
    80004d20:	69c50513          	addi	a0,a0,1692 # 8001b3b8 <disk+0x128>
    80004d24:	3df000ef          	jal	80005902 <release>
}
    80004d28:	70a6                	ld	ra,104(sp)
    80004d2a:	7406                	ld	s0,96(sp)
    80004d2c:	64e6                	ld	s1,88(sp)
    80004d2e:	6946                	ld	s2,80(sp)
    80004d30:	69a6                	ld	s3,72(sp)
    80004d32:	6a06                	ld	s4,64(sp)
    80004d34:	7ae2                	ld	s5,56(sp)
    80004d36:	7b42                	ld	s6,48(sp)
    80004d38:	7ba2                	ld	s7,40(sp)
    80004d3a:	7c02                	ld	s8,32(sp)
    80004d3c:	6ce2                	ld	s9,24(sp)
    80004d3e:	6165                	addi	sp,sp,112
    80004d40:	8082                	ret

0000000080004d42 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004d42:	1101                	addi	sp,sp,-32
    80004d44:	ec06                	sd	ra,24(sp)
    80004d46:	e822                	sd	s0,16(sp)
    80004d48:	e426                	sd	s1,8(sp)
    80004d4a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004d4c:	00016497          	auipc	s1,0x16
    80004d50:	54448493          	addi	s1,s1,1348 # 8001b290 <disk>
    80004d54:	00016517          	auipc	a0,0x16
    80004d58:	66450513          	addi	a0,a0,1636 # 8001b3b8 <disk+0x128>
    80004d5c:	30f000ef          	jal	8000586a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004d60:	100017b7          	lui	a5,0x10001
    80004d64:	53b8                	lw	a4,96(a5)
    80004d66:	8b0d                	andi	a4,a4,3
    80004d68:	100017b7          	lui	a5,0x10001
    80004d6c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004d6e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004d72:	689c                	ld	a5,16(s1)
    80004d74:	0204d703          	lhu	a4,32(s1)
    80004d78:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004d7c:	04f70663          	beq	a4,a5,80004dc8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004d80:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004d84:	6898                	ld	a4,16(s1)
    80004d86:	0204d783          	lhu	a5,32(s1)
    80004d8a:	8b9d                	andi	a5,a5,7
    80004d8c:	078e                	slli	a5,a5,0x3
    80004d8e:	97ba                	add	a5,a5,a4
    80004d90:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004d92:	00278713          	addi	a4,a5,2
    80004d96:	0712                	slli	a4,a4,0x4
    80004d98:	9726                	add	a4,a4,s1
    80004d9a:	01074703          	lbu	a4,16(a4)
    80004d9e:	e321                	bnez	a4,80004dde <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004da0:	0789                	addi	a5,a5,2
    80004da2:	0792                	slli	a5,a5,0x4
    80004da4:	97a6                	add	a5,a5,s1
    80004da6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004da8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004dac:	e12fc0ef          	jal	800013be <wakeup>

    disk.used_idx += 1;
    80004db0:	0204d783          	lhu	a5,32(s1)
    80004db4:	2785                	addiw	a5,a5,1
    80004db6:	17c2                	slli	a5,a5,0x30
    80004db8:	93c1                	srli	a5,a5,0x30
    80004dba:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004dbe:	6898                	ld	a4,16(s1)
    80004dc0:	00275703          	lhu	a4,2(a4)
    80004dc4:	faf71ee3          	bne	a4,a5,80004d80 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004dc8:	00016517          	auipc	a0,0x16
    80004dcc:	5f050513          	addi	a0,a0,1520 # 8001b3b8 <disk+0x128>
    80004dd0:	333000ef          	jal	80005902 <release>
}
    80004dd4:	60e2                	ld	ra,24(sp)
    80004dd6:	6442                	ld	s0,16(sp)
    80004dd8:	64a2                	ld	s1,8(sp)
    80004dda:	6105                	addi	sp,sp,32
    80004ddc:	8082                	ret
      panic("virtio_disk_intr status");
    80004dde:	00003517          	auipc	a0,0x3
    80004de2:	8ba50513          	addi	a0,a0,-1862 # 80007698 <etext+0x698>
    80004de6:	7c8000ef          	jal	800055ae <panic>

0000000080004dea <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004dea:	1141                	addi	sp,sp,-16
    80004dec:	e422                	sd	s0,8(sp)
    80004dee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004df0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004df4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004df8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004dfc:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e00:	577d                	li	a4,-1
    80004e02:	177e                	slli	a4,a4,0x3f
    80004e04:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e06:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e0a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e0e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e12:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e16:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e1a:	000f4737          	lui	a4,0xf4
    80004e1e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e22:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e24:	14d79073          	csrw	stimecmp,a5
}
    80004e28:	6422                	ld	s0,8(sp)
    80004e2a:	0141                	addi	sp,sp,16
    80004e2c:	8082                	ret

0000000080004e2e <start>:
{
    80004e2e:	1141                	addi	sp,sp,-16
    80004e30:	e406                	sd	ra,8(sp)
    80004e32:	e022                	sd	s0,0(sp)
    80004e34:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004e36:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004e3a:	7779                	lui	a4,0xffffe
    80004e3c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb357>
    80004e40:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e42:	6705                	lui	a4,0x1
    80004e44:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e48:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e4a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e4e:	ffffb797          	auipc	a5,0xffffb
    80004e52:	49a78793          	addi	a5,a5,1178 # 800002e8 <main>
    80004e56:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e5a:	4781                	li	a5,0
    80004e5c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004e60:	67c1                	lui	a5,0x10
    80004e62:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004e64:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004e68:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004e6c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004e70:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e74:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e78:	57fd                	li	a5,-1
    80004e7a:	83a9                	srli	a5,a5,0xa
    80004e7c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e80:	47bd                	li	a5,15
    80004e82:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e86:	f65ff0ef          	jal	80004dea <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e8a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e8e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004e90:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e92:	30200073          	mret
}
    80004e96:	60a2                	ld	ra,8(sp)
    80004e98:	6402                	ld	s0,0(sp)
    80004e9a:	0141                	addi	sp,sp,16
    80004e9c:	8082                	ret

0000000080004e9e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e9e:	7119                	addi	sp,sp,-128
    80004ea0:	fc86                	sd	ra,120(sp)
    80004ea2:	f8a2                	sd	s0,112(sp)
    80004ea4:	f4a6                	sd	s1,104(sp)
    80004ea6:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80004ea8:	06c05a63          	blez	a2,80004f1c <consolewrite+0x7e>
    80004eac:	f0ca                	sd	s2,96(sp)
    80004eae:	ecce                	sd	s3,88(sp)
    80004eb0:	e8d2                	sd	s4,80(sp)
    80004eb2:	e4d6                	sd	s5,72(sp)
    80004eb4:	e0da                	sd	s6,64(sp)
    80004eb6:	fc5e                	sd	s7,56(sp)
    80004eb8:	f862                	sd	s8,48(sp)
    80004eba:	f466                	sd	s9,40(sp)
    80004ebc:	8aaa                	mv	s5,a0
    80004ebe:	8b2e                	mv	s6,a1
    80004ec0:	8a32                	mv	s4,a2
  int i = 0;
    80004ec2:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80004ec4:	02000c13          	li	s8,32
    80004ec8:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004ecc:	5bfd                	li	s7,-1
    80004ece:	a035                	j	80004efa <consolewrite+0x5c>
    if(nn > n - i)
    80004ed0:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004ed4:	86ce                	mv	a3,s3
    80004ed6:	01648633          	add	a2,s1,s6
    80004eda:	85d6                	mv	a1,s5
    80004edc:	f8040513          	addi	a0,s0,-128
    80004ee0:	839fc0ef          	jal	80001718 <either_copyin>
    80004ee4:	03750e63          	beq	a0,s7,80004f20 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    80004ee8:	85ce                	mv	a1,s3
    80004eea:	f8040513          	addi	a0,s0,-128
    80004eee:	778000ef          	jal	80005666 <uartwrite>
    i += nn;
    80004ef2:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80004ef6:	0144da63          	bge	s1,s4,80004f0a <consolewrite+0x6c>
    if(nn > n - i)
    80004efa:	409a093b          	subw	s2,s4,s1
    80004efe:	0009079b          	sext.w	a5,s2
    80004f02:	fcfc57e3          	bge	s8,a5,80004ed0 <consolewrite+0x32>
    80004f06:	8966                	mv	s2,s9
    80004f08:	b7e1                	j	80004ed0 <consolewrite+0x32>
    80004f0a:	7906                	ld	s2,96(sp)
    80004f0c:	69e6                	ld	s3,88(sp)
    80004f0e:	6a46                	ld	s4,80(sp)
    80004f10:	6aa6                	ld	s5,72(sp)
    80004f12:	6b06                	ld	s6,64(sp)
    80004f14:	7be2                	ld	s7,56(sp)
    80004f16:	7c42                	ld	s8,48(sp)
    80004f18:	7ca2                	ld	s9,40(sp)
    80004f1a:	a819                	j	80004f30 <consolewrite+0x92>
  int i = 0;
    80004f1c:	4481                	li	s1,0
    80004f1e:	a809                	j	80004f30 <consolewrite+0x92>
    80004f20:	7906                	ld	s2,96(sp)
    80004f22:	69e6                	ld	s3,88(sp)
    80004f24:	6a46                	ld	s4,80(sp)
    80004f26:	6aa6                	ld	s5,72(sp)
    80004f28:	6b06                	ld	s6,64(sp)
    80004f2a:	7be2                	ld	s7,56(sp)
    80004f2c:	7c42                	ld	s8,48(sp)
    80004f2e:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80004f30:	8526                	mv	a0,s1
    80004f32:	70e6                	ld	ra,120(sp)
    80004f34:	7446                	ld	s0,112(sp)
    80004f36:	74a6                	ld	s1,104(sp)
    80004f38:	6109                	addi	sp,sp,128
    80004f3a:	8082                	ret

0000000080004f3c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f3c:	711d                	addi	sp,sp,-96
    80004f3e:	ec86                	sd	ra,88(sp)
    80004f40:	e8a2                	sd	s0,80(sp)
    80004f42:	e4a6                	sd	s1,72(sp)
    80004f44:	e0ca                	sd	s2,64(sp)
    80004f46:	fc4e                	sd	s3,56(sp)
    80004f48:	f852                	sd	s4,48(sp)
    80004f4a:	f456                	sd	s5,40(sp)
    80004f4c:	f05a                	sd	s6,32(sp)
    80004f4e:	1080                	addi	s0,sp,96
    80004f50:	8aaa                	mv	s5,a0
    80004f52:	8a2e                	mv	s4,a1
    80004f54:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004f56:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004f5a:	0001e517          	auipc	a0,0x1e
    80004f5e:	47650513          	addi	a0,a0,1142 # 800233d0 <cons>
    80004f62:	109000ef          	jal	8000586a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004f66:	0001e497          	auipc	s1,0x1e
    80004f6a:	46a48493          	addi	s1,s1,1130 # 800233d0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004f6e:	0001e917          	auipc	s2,0x1e
    80004f72:	4fa90913          	addi	s2,s2,1274 # 80023468 <cons+0x98>
  while(n > 0){
    80004f76:	0b305d63          	blez	s3,80005030 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004f7a:	0984a783          	lw	a5,152(s1)
    80004f7e:	09c4a703          	lw	a4,156(s1)
    80004f82:	0af71263          	bne	a4,a5,80005026 <consoleread+0xea>
      if(killed(myproc())){
    80004f86:	df5fb0ef          	jal	80000d7a <myproc>
    80004f8a:	e20fc0ef          	jal	800015aa <killed>
    80004f8e:	e12d                	bnez	a0,80004ff0 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004f90:	85a6                	mv	a1,s1
    80004f92:	854a                	mv	a0,s2
    80004f94:	bdefc0ef          	jal	80001372 <sleep>
    while(cons.r == cons.w){
    80004f98:	0984a783          	lw	a5,152(s1)
    80004f9c:	09c4a703          	lw	a4,156(s1)
    80004fa0:	fef703e3          	beq	a4,a5,80004f86 <consoleread+0x4a>
    80004fa4:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004fa6:	0001e717          	auipc	a4,0x1e
    80004faa:	42a70713          	addi	a4,a4,1066 # 800233d0 <cons>
    80004fae:	0017869b          	addiw	a3,a5,1
    80004fb2:	08d72c23          	sw	a3,152(a4)
    80004fb6:	07f7f693          	andi	a3,a5,127
    80004fba:	9736                	add	a4,a4,a3
    80004fbc:	01874703          	lbu	a4,24(a4)
    80004fc0:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004fc4:	4691                	li	a3,4
    80004fc6:	04db8663          	beq	s7,a3,80005012 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004fca:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004fce:	4685                	li	a3,1
    80004fd0:	faf40613          	addi	a2,s0,-81
    80004fd4:	85d2                	mv	a1,s4
    80004fd6:	8556                	mv	a0,s5
    80004fd8:	ef6fc0ef          	jal	800016ce <either_copyout>
    80004fdc:	57fd                	li	a5,-1
    80004fde:	04f50863          	beq	a0,a5,8000502e <consoleread+0xf2>
      break;

    dst++;
    80004fe2:	0a05                	addi	s4,s4,1
    --n;
    80004fe4:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004fe6:	47a9                	li	a5,10
    80004fe8:	04fb8d63          	beq	s7,a5,80005042 <consoleread+0x106>
    80004fec:	6be2                	ld	s7,24(sp)
    80004fee:	b761                	j	80004f76 <consoleread+0x3a>
        release(&cons.lock);
    80004ff0:	0001e517          	auipc	a0,0x1e
    80004ff4:	3e050513          	addi	a0,a0,992 # 800233d0 <cons>
    80004ff8:	10b000ef          	jal	80005902 <release>
        return -1;
    80004ffc:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004ffe:	60e6                	ld	ra,88(sp)
    80005000:	6446                	ld	s0,80(sp)
    80005002:	64a6                	ld	s1,72(sp)
    80005004:	6906                	ld	s2,64(sp)
    80005006:	79e2                	ld	s3,56(sp)
    80005008:	7a42                	ld	s4,48(sp)
    8000500a:	7aa2                	ld	s5,40(sp)
    8000500c:	7b02                	ld	s6,32(sp)
    8000500e:	6125                	addi	sp,sp,96
    80005010:	8082                	ret
      if(n < target){
    80005012:	0009871b          	sext.w	a4,s3
    80005016:	01677a63          	bgeu	a4,s6,8000502a <consoleread+0xee>
        cons.r--;
    8000501a:	0001e717          	auipc	a4,0x1e
    8000501e:	44f72723          	sw	a5,1102(a4) # 80023468 <cons+0x98>
    80005022:	6be2                	ld	s7,24(sp)
    80005024:	a031                	j	80005030 <consoleread+0xf4>
    80005026:	ec5e                	sd	s7,24(sp)
    80005028:	bfbd                	j	80004fa6 <consoleread+0x6a>
    8000502a:	6be2                	ld	s7,24(sp)
    8000502c:	a011                	j	80005030 <consoleread+0xf4>
    8000502e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005030:	0001e517          	auipc	a0,0x1e
    80005034:	3a050513          	addi	a0,a0,928 # 800233d0 <cons>
    80005038:	0cb000ef          	jal	80005902 <release>
  return target - n;
    8000503c:	413b053b          	subw	a0,s6,s3
    80005040:	bf7d                	j	80004ffe <consoleread+0xc2>
    80005042:	6be2                	ld	s7,24(sp)
    80005044:	b7f5                	j	80005030 <consoleread+0xf4>

0000000080005046 <consputc>:
{
    80005046:	1141                	addi	sp,sp,-16
    80005048:	e406                	sd	ra,8(sp)
    8000504a:	e022                	sd	s0,0(sp)
    8000504c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000504e:	10000793          	li	a5,256
    80005052:	00f50863          	beq	a0,a5,80005062 <consputc+0x1c>
    uartputc_sync(c);
    80005056:	6a4000ef          	jal	800056fa <uartputc_sync>
}
    8000505a:	60a2                	ld	ra,8(sp)
    8000505c:	6402                	ld	s0,0(sp)
    8000505e:	0141                	addi	sp,sp,16
    80005060:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005062:	4521                	li	a0,8
    80005064:	696000ef          	jal	800056fa <uartputc_sync>
    80005068:	02000513          	li	a0,32
    8000506c:	68e000ef          	jal	800056fa <uartputc_sync>
    80005070:	4521                	li	a0,8
    80005072:	688000ef          	jal	800056fa <uartputc_sync>
    80005076:	b7d5                	j	8000505a <consputc+0x14>

0000000080005078 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005078:	1101                	addi	sp,sp,-32
    8000507a:	ec06                	sd	ra,24(sp)
    8000507c:	e822                	sd	s0,16(sp)
    8000507e:	e426                	sd	s1,8(sp)
    80005080:	1000                	addi	s0,sp,32
    80005082:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005084:	0001e517          	auipc	a0,0x1e
    80005088:	34c50513          	addi	a0,a0,844 # 800233d0 <cons>
    8000508c:	7de000ef          	jal	8000586a <acquire>

  switch(c){
    80005090:	47d5                	li	a5,21
    80005092:	08f48f63          	beq	s1,a5,80005130 <consoleintr+0xb8>
    80005096:	0297c563          	blt	a5,s1,800050c0 <consoleintr+0x48>
    8000509a:	47a1                	li	a5,8
    8000509c:	0ef48463          	beq	s1,a5,80005184 <consoleintr+0x10c>
    800050a0:	47c1                	li	a5,16
    800050a2:	10f49563          	bne	s1,a5,800051ac <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800050a6:	ebcfc0ef          	jal	80001762 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800050aa:	0001e517          	auipc	a0,0x1e
    800050ae:	32650513          	addi	a0,a0,806 # 800233d0 <cons>
    800050b2:	051000ef          	jal	80005902 <release>
}
    800050b6:	60e2                	ld	ra,24(sp)
    800050b8:	6442                	ld	s0,16(sp)
    800050ba:	64a2                	ld	s1,8(sp)
    800050bc:	6105                	addi	sp,sp,32
    800050be:	8082                	ret
  switch(c){
    800050c0:	07f00793          	li	a5,127
    800050c4:	0cf48063          	beq	s1,a5,80005184 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800050c8:	0001e717          	auipc	a4,0x1e
    800050cc:	30870713          	addi	a4,a4,776 # 800233d0 <cons>
    800050d0:	0a072783          	lw	a5,160(a4)
    800050d4:	09872703          	lw	a4,152(a4)
    800050d8:	9f99                	subw	a5,a5,a4
    800050da:	07f00713          	li	a4,127
    800050de:	fcf766e3          	bltu	a4,a5,800050aa <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800050e2:	47b5                	li	a5,13
    800050e4:	0cf48763          	beq	s1,a5,800051b2 <consoleintr+0x13a>
      consputc(c);
    800050e8:	8526                	mv	a0,s1
    800050ea:	f5dff0ef          	jal	80005046 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050ee:	0001e797          	auipc	a5,0x1e
    800050f2:	2e278793          	addi	a5,a5,738 # 800233d0 <cons>
    800050f6:	0a07a683          	lw	a3,160(a5)
    800050fa:	0016871b          	addiw	a4,a3,1
    800050fe:	0007061b          	sext.w	a2,a4
    80005102:	0ae7a023          	sw	a4,160(a5)
    80005106:	07f6f693          	andi	a3,a3,127
    8000510a:	97b6                	add	a5,a5,a3
    8000510c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005110:	47a9                	li	a5,10
    80005112:	0cf48563          	beq	s1,a5,800051dc <consoleintr+0x164>
    80005116:	4791                	li	a5,4
    80005118:	0cf48263          	beq	s1,a5,800051dc <consoleintr+0x164>
    8000511c:	0001e797          	auipc	a5,0x1e
    80005120:	34c7a783          	lw	a5,844(a5) # 80023468 <cons+0x98>
    80005124:	9f1d                	subw	a4,a4,a5
    80005126:	08000793          	li	a5,128
    8000512a:	f8f710e3          	bne	a4,a5,800050aa <consoleintr+0x32>
    8000512e:	a07d                	j	800051dc <consoleintr+0x164>
    80005130:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005132:	0001e717          	auipc	a4,0x1e
    80005136:	29e70713          	addi	a4,a4,670 # 800233d0 <cons>
    8000513a:	0a072783          	lw	a5,160(a4)
    8000513e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005142:	0001e497          	auipc	s1,0x1e
    80005146:	28e48493          	addi	s1,s1,654 # 800233d0 <cons>
    while(cons.e != cons.w &&
    8000514a:	4929                	li	s2,10
    8000514c:	02f70863          	beq	a4,a5,8000517c <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005150:	37fd                	addiw	a5,a5,-1
    80005152:	07f7f713          	andi	a4,a5,127
    80005156:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005158:	01874703          	lbu	a4,24(a4)
    8000515c:	03270263          	beq	a4,s2,80005180 <consoleintr+0x108>
      cons.e--;
    80005160:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005164:	10000513          	li	a0,256
    80005168:	edfff0ef          	jal	80005046 <consputc>
    while(cons.e != cons.w &&
    8000516c:	0a04a783          	lw	a5,160(s1)
    80005170:	09c4a703          	lw	a4,156(s1)
    80005174:	fcf71ee3          	bne	a4,a5,80005150 <consoleintr+0xd8>
    80005178:	6902                	ld	s2,0(sp)
    8000517a:	bf05                	j	800050aa <consoleintr+0x32>
    8000517c:	6902                	ld	s2,0(sp)
    8000517e:	b735                	j	800050aa <consoleintr+0x32>
    80005180:	6902                	ld	s2,0(sp)
    80005182:	b725                	j	800050aa <consoleintr+0x32>
    if(cons.e != cons.w){
    80005184:	0001e717          	auipc	a4,0x1e
    80005188:	24c70713          	addi	a4,a4,588 # 800233d0 <cons>
    8000518c:	0a072783          	lw	a5,160(a4)
    80005190:	09c72703          	lw	a4,156(a4)
    80005194:	f0f70be3          	beq	a4,a5,800050aa <consoleintr+0x32>
      cons.e--;
    80005198:	37fd                	addiw	a5,a5,-1
    8000519a:	0001e717          	auipc	a4,0x1e
    8000519e:	2cf72b23          	sw	a5,726(a4) # 80023470 <cons+0xa0>
      consputc(BACKSPACE);
    800051a2:	10000513          	li	a0,256
    800051a6:	ea1ff0ef          	jal	80005046 <consputc>
    800051aa:	b701                	j	800050aa <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051ac:	ee048fe3          	beqz	s1,800050aa <consoleintr+0x32>
    800051b0:	bf21                	j	800050c8 <consoleintr+0x50>
      consputc(c);
    800051b2:	4529                	li	a0,10
    800051b4:	e93ff0ef          	jal	80005046 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800051b8:	0001e797          	auipc	a5,0x1e
    800051bc:	21878793          	addi	a5,a5,536 # 800233d0 <cons>
    800051c0:	0a07a703          	lw	a4,160(a5)
    800051c4:	0017069b          	addiw	a3,a4,1
    800051c8:	0006861b          	sext.w	a2,a3
    800051cc:	0ad7a023          	sw	a3,160(a5)
    800051d0:	07f77713          	andi	a4,a4,127
    800051d4:	97ba                	add	a5,a5,a4
    800051d6:	4729                	li	a4,10
    800051d8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800051dc:	0001e797          	auipc	a5,0x1e
    800051e0:	28c7a823          	sw	a2,656(a5) # 8002346c <cons+0x9c>
        wakeup(&cons.r);
    800051e4:	0001e517          	auipc	a0,0x1e
    800051e8:	28450513          	addi	a0,a0,644 # 80023468 <cons+0x98>
    800051ec:	9d2fc0ef          	jal	800013be <wakeup>
    800051f0:	bd6d                	j	800050aa <consoleintr+0x32>

00000000800051f2 <consoleinit>:

void
consoleinit(void)
{
    800051f2:	1141                	addi	sp,sp,-16
    800051f4:	e406                	sd	ra,8(sp)
    800051f6:	e022                	sd	s0,0(sp)
    800051f8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800051fa:	00002597          	auipc	a1,0x2
    800051fe:	4b658593          	addi	a1,a1,1206 # 800076b0 <etext+0x6b0>
    80005202:	0001e517          	auipc	a0,0x1e
    80005206:	1ce50513          	addi	a0,a0,462 # 800233d0 <cons>
    8000520a:	5e0000ef          	jal	800057ea <initlock>

  uartinit();
    8000520e:	400000ef          	jal	8000560e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005212:	00015797          	auipc	a5,0x15
    80005216:	02678793          	addi	a5,a5,38 # 8001a238 <devsw>
    8000521a:	00000717          	auipc	a4,0x0
    8000521e:	d2270713          	addi	a4,a4,-734 # 80004f3c <consoleread>
    80005222:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005224:	00000717          	auipc	a4,0x0
    80005228:	c7a70713          	addi	a4,a4,-902 # 80004e9e <consolewrite>
    8000522c:	ef98                	sd	a4,24(a5)
}
    8000522e:	60a2                	ld	ra,8(sp)
    80005230:	6402                	ld	s0,0(sp)
    80005232:	0141                	addi	sp,sp,16
    80005234:	8082                	ret

0000000080005236 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005236:	7139                	addi	sp,sp,-64
    80005238:	fc06                	sd	ra,56(sp)
    8000523a:	f822                	sd	s0,48(sp)
    8000523c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000523e:	c219                	beqz	a2,80005244 <printint+0xe>
    80005240:	08054063          	bltz	a0,800052c0 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005244:	4881                	li	a7,0
    80005246:	fc840693          	addi	a3,s0,-56

  i = 0;
    8000524a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000524c:	00002617          	auipc	a2,0x2
    80005250:	5bc60613          	addi	a2,a2,1468 # 80007808 <digits>
    80005254:	883e                	mv	a6,a5
    80005256:	2785                	addiw	a5,a5,1
    80005258:	02b57733          	remu	a4,a0,a1
    8000525c:	9732                	add	a4,a4,a2
    8000525e:	00074703          	lbu	a4,0(a4)
    80005262:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005266:	872a                	mv	a4,a0
    80005268:	02b55533          	divu	a0,a0,a1
    8000526c:	0685                	addi	a3,a3,1
    8000526e:	feb773e3          	bgeu	a4,a1,80005254 <printint+0x1e>

  if(sign)
    80005272:	00088a63          	beqz	a7,80005286 <printint+0x50>
    buf[i++] = '-';
    80005276:	1781                	addi	a5,a5,-32
    80005278:	97a2                	add	a5,a5,s0
    8000527a:	02d00713          	li	a4,45
    8000527e:	fee78423          	sb	a4,-24(a5)
    80005282:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80005286:	02f05963          	blez	a5,800052b8 <printint+0x82>
    8000528a:	f426                	sd	s1,40(sp)
    8000528c:	f04a                	sd	s2,32(sp)
    8000528e:	fc840713          	addi	a4,s0,-56
    80005292:	00f704b3          	add	s1,a4,a5
    80005296:	fff70913          	addi	s2,a4,-1
    8000529a:	993e                	add	s2,s2,a5
    8000529c:	37fd                	addiw	a5,a5,-1
    8000529e:	1782                	slli	a5,a5,0x20
    800052a0:	9381                	srli	a5,a5,0x20
    800052a2:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800052a6:	fff4c503          	lbu	a0,-1(s1)
    800052aa:	d9dff0ef          	jal	80005046 <consputc>
  while(--i >= 0)
    800052ae:	14fd                	addi	s1,s1,-1
    800052b0:	ff249be3          	bne	s1,s2,800052a6 <printint+0x70>
    800052b4:	74a2                	ld	s1,40(sp)
    800052b6:	7902                	ld	s2,32(sp)
}
    800052b8:	70e2                	ld	ra,56(sp)
    800052ba:	7442                	ld	s0,48(sp)
    800052bc:	6121                	addi	sp,sp,64
    800052be:	8082                	ret
    x = -xx;
    800052c0:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800052c4:	4885                	li	a7,1
    x = -xx;
    800052c6:	b741                	j	80005246 <printint+0x10>

00000000800052c8 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800052c8:	7131                	addi	sp,sp,-192
    800052ca:	fc86                	sd	ra,120(sp)
    800052cc:	f8a2                	sd	s0,112(sp)
    800052ce:	e8d2                	sd	s4,80(sp)
    800052d0:	0100                	addi	s0,sp,128
    800052d2:	8a2a                	mv	s4,a0
    800052d4:	e40c                	sd	a1,8(s0)
    800052d6:	e810                	sd	a2,16(s0)
    800052d8:	ec14                	sd	a3,24(s0)
    800052da:	f018                	sd	a4,32(s0)
    800052dc:	f41c                	sd	a5,40(s0)
    800052de:	03043823          	sd	a6,48(s0)
    800052e2:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    800052e6:	00005797          	auipc	a5,0x5
    800052ea:	eaa7a783          	lw	a5,-342(a5) # 8000a190 <panicking>
    800052ee:	c3a1                	beqz	a5,8000532e <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800052f0:	00840793          	addi	a5,s0,8
    800052f4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052f8:	000a4503          	lbu	a0,0(s4)
    800052fc:	28050763          	beqz	a0,8000558a <printf+0x2c2>
    80005300:	f4a6                	sd	s1,104(sp)
    80005302:	f0ca                	sd	s2,96(sp)
    80005304:	ecce                	sd	s3,88(sp)
    80005306:	e4d6                	sd	s5,72(sp)
    80005308:	e0da                	sd	s6,64(sp)
    8000530a:	f862                	sd	s8,48(sp)
    8000530c:	f466                	sd	s9,40(sp)
    8000530e:	f06a                	sd	s10,32(sp)
    80005310:	ec6e                	sd	s11,24(sp)
    80005312:	4981                	li	s3,0
    if(cx != '%'){
    80005314:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005318:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000531c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005320:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005324:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005328:	07000d93          	li	s11,112
    8000532c:	a01d                	j	80005352 <printf+0x8a>
    acquire(&pr.lock);
    8000532e:	0001e517          	auipc	a0,0x1e
    80005332:	14a50513          	addi	a0,a0,330 # 80023478 <pr>
    80005336:	534000ef          	jal	8000586a <acquire>
    8000533a:	bf5d                	j	800052f0 <printf+0x28>
      consputc(cx);
    8000533c:	d0bff0ef          	jal	80005046 <consputc>
      continue;
    80005340:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005342:	0014899b          	addiw	s3,s1,1
    80005346:	013a07b3          	add	a5,s4,s3
    8000534a:	0007c503          	lbu	a0,0(a5)
    8000534e:	20050b63          	beqz	a0,80005564 <printf+0x29c>
    if(cx != '%'){
    80005352:	ff5515e3          	bne	a0,s5,8000533c <printf+0x74>
    i++;
    80005356:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000535a:	009a07b3          	add	a5,s4,s1
    8000535e:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005362:	20090b63          	beqz	s2,80005578 <printf+0x2b0>
    80005366:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000536a:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000536c:	c789                	beqz	a5,80005376 <printf+0xae>
    8000536e:	009a0733          	add	a4,s4,s1
    80005372:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005376:	03690963          	beq	s2,s6,800053a8 <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    8000537a:	05890363          	beq	s2,s8,800053c0 <printf+0xf8>
    } else if(c0 == 'u'){
    8000537e:	0d990663          	beq	s2,s9,8000544a <printf+0x182>
    } else if(c0 == 'x'){
    80005382:	11a90d63          	beq	s2,s10,8000549c <printf+0x1d4>
    } else if(c0 == 'p'){
    80005386:	15b90663          	beq	s2,s11,800054d2 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    8000538a:	06300793          	li	a5,99
    8000538e:	18f90563          	beq	s2,a5,80005518 <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80005392:	07300793          	li	a5,115
    80005396:	18f90b63          	beq	s2,a5,8000552c <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000539a:	03591b63          	bne	s2,s5,800053d0 <printf+0x108>
      consputc('%');
    8000539e:	02500513          	li	a0,37
    800053a2:	ca5ff0ef          	jal	80005046 <consputc>
    800053a6:	bf71                	j	80005342 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800053a8:	f8843783          	ld	a5,-120(s0)
    800053ac:	00878713          	addi	a4,a5,8
    800053b0:	f8e43423          	sd	a4,-120(s0)
    800053b4:	4605                	li	a2,1
    800053b6:	45a9                	li	a1,10
    800053b8:	4388                	lw	a0,0(a5)
    800053ba:	e7dff0ef          	jal	80005236 <printint>
    800053be:	b751                	j	80005342 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    800053c0:	01678f63          	beq	a5,s6,800053de <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800053c4:	03878b63          	beq	a5,s8,800053fa <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    800053c8:	09978e63          	beq	a5,s9,80005464 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    800053cc:	0fa78563          	beq	a5,s10,800054b6 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800053d0:	8556                	mv	a0,s5
    800053d2:	c75ff0ef          	jal	80005046 <consputc>
      consputc(c0);
    800053d6:	854a                	mv	a0,s2
    800053d8:	c6fff0ef          	jal	80005046 <consputc>
    800053dc:	b79d                	j	80005342 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    800053de:	f8843783          	ld	a5,-120(s0)
    800053e2:	00878713          	addi	a4,a5,8
    800053e6:	f8e43423          	sd	a4,-120(s0)
    800053ea:	4605                	li	a2,1
    800053ec:	45a9                	li	a1,10
    800053ee:	6388                	ld	a0,0(a5)
    800053f0:	e47ff0ef          	jal	80005236 <printint>
      i += 1;
    800053f4:	0029849b          	addiw	s1,s3,2
    800053f8:	b7a9                	j	80005342 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800053fa:	06400793          	li	a5,100
    800053fe:	02f68863          	beq	a3,a5,8000542e <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005402:	07500793          	li	a5,117
    80005406:	06f68d63          	beq	a3,a5,80005480 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000540a:	07800793          	li	a5,120
    8000540e:	fcf691e3          	bne	a3,a5,800053d0 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80005412:	f8843783          	ld	a5,-120(s0)
    80005416:	00878713          	addi	a4,a5,8
    8000541a:	f8e43423          	sd	a4,-120(s0)
    8000541e:	4601                	li	a2,0
    80005420:	45c1                	li	a1,16
    80005422:	6388                	ld	a0,0(a5)
    80005424:	e13ff0ef          	jal	80005236 <printint>
      i += 2;
    80005428:	0039849b          	addiw	s1,s3,3
    8000542c:	bf19                	j	80005342 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000542e:	f8843783          	ld	a5,-120(s0)
    80005432:	00878713          	addi	a4,a5,8
    80005436:	f8e43423          	sd	a4,-120(s0)
    8000543a:	4605                	li	a2,1
    8000543c:	45a9                	li	a1,10
    8000543e:	6388                	ld	a0,0(a5)
    80005440:	df7ff0ef          	jal	80005236 <printint>
      i += 2;
    80005444:	0039849b          	addiw	s1,s3,3
    80005448:	bded                	j	80005342 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    8000544a:	f8843783          	ld	a5,-120(s0)
    8000544e:	00878713          	addi	a4,a5,8
    80005452:	f8e43423          	sd	a4,-120(s0)
    80005456:	4601                	li	a2,0
    80005458:	45a9                	li	a1,10
    8000545a:	0007e503          	lwu	a0,0(a5)
    8000545e:	dd9ff0ef          	jal	80005236 <printint>
    80005462:	b5c5                	j	80005342 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005464:	f8843783          	ld	a5,-120(s0)
    80005468:	00878713          	addi	a4,a5,8
    8000546c:	f8e43423          	sd	a4,-120(s0)
    80005470:	4601                	li	a2,0
    80005472:	45a9                	li	a1,10
    80005474:	6388                	ld	a0,0(a5)
    80005476:	dc1ff0ef          	jal	80005236 <printint>
      i += 1;
    8000547a:	0029849b          	addiw	s1,s3,2
    8000547e:	b5d1                	j	80005342 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005480:	f8843783          	ld	a5,-120(s0)
    80005484:	00878713          	addi	a4,a5,8
    80005488:	f8e43423          	sd	a4,-120(s0)
    8000548c:	4601                	li	a2,0
    8000548e:	45a9                	li	a1,10
    80005490:	6388                	ld	a0,0(a5)
    80005492:	da5ff0ef          	jal	80005236 <printint>
      i += 2;
    80005496:	0039849b          	addiw	s1,s3,3
    8000549a:	b565                	j	80005342 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    8000549c:	f8843783          	ld	a5,-120(s0)
    800054a0:	00878713          	addi	a4,a5,8
    800054a4:	f8e43423          	sd	a4,-120(s0)
    800054a8:	4601                	li	a2,0
    800054aa:	45c1                	li	a1,16
    800054ac:	0007e503          	lwu	a0,0(a5)
    800054b0:	d87ff0ef          	jal	80005236 <printint>
    800054b4:	b579                	j	80005342 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800054b6:	f8843783          	ld	a5,-120(s0)
    800054ba:	00878713          	addi	a4,a5,8
    800054be:	f8e43423          	sd	a4,-120(s0)
    800054c2:	4601                	li	a2,0
    800054c4:	45c1                	li	a1,16
    800054c6:	6388                	ld	a0,0(a5)
    800054c8:	d6fff0ef          	jal	80005236 <printint>
      i += 1;
    800054cc:	0029849b          	addiw	s1,s3,2
    800054d0:	bd8d                	j	80005342 <printf+0x7a>
    800054d2:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    800054d4:	f8843783          	ld	a5,-120(s0)
    800054d8:	00878713          	addi	a4,a5,8
    800054dc:	f8e43423          	sd	a4,-120(s0)
    800054e0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800054e4:	03000513          	li	a0,48
    800054e8:	b5fff0ef          	jal	80005046 <consputc>
  consputc('x');
    800054ec:	07800513          	li	a0,120
    800054f0:	b57ff0ef          	jal	80005046 <consputc>
    800054f4:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800054f6:	00002b97          	auipc	s7,0x2
    800054fa:	312b8b93          	addi	s7,s7,786 # 80007808 <digits>
    800054fe:	03c9d793          	srli	a5,s3,0x3c
    80005502:	97de                	add	a5,a5,s7
    80005504:	0007c503          	lbu	a0,0(a5)
    80005508:	b3fff0ef          	jal	80005046 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000550c:	0992                	slli	s3,s3,0x4
    8000550e:	397d                	addiw	s2,s2,-1
    80005510:	fe0917e3          	bnez	s2,800054fe <printf+0x236>
    80005514:	7be2                	ld	s7,56(sp)
    80005516:	b535                	j	80005342 <printf+0x7a>
      consputc(va_arg(ap, uint));
    80005518:	f8843783          	ld	a5,-120(s0)
    8000551c:	00878713          	addi	a4,a5,8
    80005520:	f8e43423          	sd	a4,-120(s0)
    80005524:	4388                	lw	a0,0(a5)
    80005526:	b21ff0ef          	jal	80005046 <consputc>
    8000552a:	bd21                	j	80005342 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    8000552c:	f8843783          	ld	a5,-120(s0)
    80005530:	00878713          	addi	a4,a5,8
    80005534:	f8e43423          	sd	a4,-120(s0)
    80005538:	0007b903          	ld	s2,0(a5)
    8000553c:	00090d63          	beqz	s2,80005556 <printf+0x28e>
      for(; *s; s++)
    80005540:	00094503          	lbu	a0,0(s2)
    80005544:	de050fe3          	beqz	a0,80005342 <printf+0x7a>
        consputc(*s);
    80005548:	affff0ef          	jal	80005046 <consputc>
      for(; *s; s++)
    8000554c:	0905                	addi	s2,s2,1
    8000554e:	00094503          	lbu	a0,0(s2)
    80005552:	f97d                	bnez	a0,80005548 <printf+0x280>
    80005554:	b3fd                	j	80005342 <printf+0x7a>
        s = "(null)";
    80005556:	00002917          	auipc	s2,0x2
    8000555a:	16290913          	addi	s2,s2,354 # 800076b8 <etext+0x6b8>
      for(; *s; s++)
    8000555e:	02800513          	li	a0,40
    80005562:	b7dd                	j	80005548 <printf+0x280>
    80005564:	74a6                	ld	s1,104(sp)
    80005566:	7906                	ld	s2,96(sp)
    80005568:	69e6                	ld	s3,88(sp)
    8000556a:	6aa6                	ld	s5,72(sp)
    8000556c:	6b06                	ld	s6,64(sp)
    8000556e:	7c42                	ld	s8,48(sp)
    80005570:	7ca2                	ld	s9,40(sp)
    80005572:	7d02                	ld	s10,32(sp)
    80005574:	6de2                	ld	s11,24(sp)
    80005576:	a811                	j	8000558a <printf+0x2c2>
    80005578:	74a6                	ld	s1,104(sp)
    8000557a:	7906                	ld	s2,96(sp)
    8000557c:	69e6                	ld	s3,88(sp)
    8000557e:	6aa6                	ld	s5,72(sp)
    80005580:	6b06                	ld	s6,64(sp)
    80005582:	7c42                	ld	s8,48(sp)
    80005584:	7ca2                	ld	s9,40(sp)
    80005586:	7d02                	ld	s10,32(sp)
    80005588:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000558a:	00005797          	auipc	a5,0x5
    8000558e:	c067a783          	lw	a5,-1018(a5) # 8000a190 <panicking>
    80005592:	c799                	beqz	a5,800055a0 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    80005594:	4501                	li	a0,0
    80005596:	70e6                	ld	ra,120(sp)
    80005598:	7446                	ld	s0,112(sp)
    8000559a:	6a46                	ld	s4,80(sp)
    8000559c:	6129                	addi	sp,sp,192
    8000559e:	8082                	ret
    release(&pr.lock);
    800055a0:	0001e517          	auipc	a0,0x1e
    800055a4:	ed850513          	addi	a0,a0,-296 # 80023478 <pr>
    800055a8:	35a000ef          	jal	80005902 <release>
  return 0;
    800055ac:	b7e5                	j	80005594 <printf+0x2cc>

00000000800055ae <panic>:

void
panic(char *s)
{
    800055ae:	1101                	addi	sp,sp,-32
    800055b0:	ec06                	sd	ra,24(sp)
    800055b2:	e822                	sd	s0,16(sp)
    800055b4:	e426                	sd	s1,8(sp)
    800055b6:	e04a                	sd	s2,0(sp)
    800055b8:	1000                	addi	s0,sp,32
    800055ba:	84aa                	mv	s1,a0
  panicking = 1;
    800055bc:	4905                	li	s2,1
    800055be:	00005797          	auipc	a5,0x5
    800055c2:	bd27a923          	sw	s2,-1070(a5) # 8000a190 <panicking>
  printf("panic: ");
    800055c6:	00002517          	auipc	a0,0x2
    800055ca:	0fa50513          	addi	a0,a0,250 # 800076c0 <etext+0x6c0>
    800055ce:	cfbff0ef          	jal	800052c8 <printf>
  printf("%s\n", s);
    800055d2:	85a6                	mv	a1,s1
    800055d4:	00002517          	auipc	a0,0x2
    800055d8:	0f450513          	addi	a0,a0,244 # 800076c8 <etext+0x6c8>
    800055dc:	cedff0ef          	jal	800052c8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800055e0:	00005797          	auipc	a5,0x5
    800055e4:	bb27a623          	sw	s2,-1108(a5) # 8000a18c <panicked>
  for(;;)
    800055e8:	a001                	j	800055e8 <panic+0x3a>

00000000800055ea <printfinit>:
    ;
}

void
printfinit(void)
{
    800055ea:	1141                	addi	sp,sp,-16
    800055ec:	e406                	sd	ra,8(sp)
    800055ee:	e022                	sd	s0,0(sp)
    800055f0:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    800055f2:	00002597          	auipc	a1,0x2
    800055f6:	0de58593          	addi	a1,a1,222 # 800076d0 <etext+0x6d0>
    800055fa:	0001e517          	auipc	a0,0x1e
    800055fe:	e7e50513          	addi	a0,a0,-386 # 80023478 <pr>
    80005602:	1e8000ef          	jal	800057ea <initlock>
}
    80005606:	60a2                	ld	ra,8(sp)
    80005608:	6402                	ld	s0,0(sp)
    8000560a:	0141                	addi	sp,sp,16
    8000560c:	8082                	ret

000000008000560e <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    8000560e:	1141                	addi	sp,sp,-16
    80005610:	e406                	sd	ra,8(sp)
    80005612:	e022                	sd	s0,0(sp)
    80005614:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005616:	100007b7          	lui	a5,0x10000
    8000561a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000561e:	10000737          	lui	a4,0x10000
    80005622:	f8000693          	li	a3,-128
    80005626:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000562a:	468d                	li	a3,3
    8000562c:	10000637          	lui	a2,0x10000
    80005630:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005634:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005638:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000563c:	10000737          	lui	a4,0x10000
    80005640:	461d                	li	a2,7
    80005642:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005646:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    8000564a:	00002597          	auipc	a1,0x2
    8000564e:	08e58593          	addi	a1,a1,142 # 800076d8 <etext+0x6d8>
    80005652:	0001e517          	auipc	a0,0x1e
    80005656:	e3e50513          	addi	a0,a0,-450 # 80023490 <tx_lock>
    8000565a:	190000ef          	jal	800057ea <initlock>
}
    8000565e:	60a2                	ld	ra,8(sp)
    80005660:	6402                	ld	s0,0(sp)
    80005662:	0141                	addi	sp,sp,16
    80005664:	8082                	ret

0000000080005666 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005666:	715d                	addi	sp,sp,-80
    80005668:	e486                	sd	ra,72(sp)
    8000566a:	e0a2                	sd	s0,64(sp)
    8000566c:	fc26                	sd	s1,56(sp)
    8000566e:	ec56                	sd	s5,24(sp)
    80005670:	0880                	addi	s0,sp,80
    80005672:	8aaa                	mv	s5,a0
    80005674:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005676:	0001e517          	auipc	a0,0x1e
    8000567a:	e1a50513          	addi	a0,a0,-486 # 80023490 <tx_lock>
    8000567e:	1ec000ef          	jal	8000586a <acquire>

  int i = 0;
  while(i < n){ 
    80005682:	06905063          	blez	s1,800056e2 <uartwrite+0x7c>
    80005686:	f84a                	sd	s2,48(sp)
    80005688:	f44e                	sd	s3,40(sp)
    8000568a:	f052                	sd	s4,32(sp)
    8000568c:	e85a                	sd	s6,16(sp)
    8000568e:	e45e                	sd	s7,8(sp)
    80005690:	8a56                	mv	s4,s5
    80005692:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005694:	00005497          	auipc	s1,0x5
    80005698:	b0448493          	addi	s1,s1,-1276 # 8000a198 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    8000569c:	0001e997          	auipc	s3,0x1e
    800056a0:	df498993          	addi	s3,s3,-524 # 80023490 <tx_lock>
    800056a4:	00005917          	auipc	s2,0x5
    800056a8:	af090913          	addi	s2,s2,-1296 # 8000a194 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    800056ac:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    800056b0:	4b05                	li	s6,1
    800056b2:	a005                	j	800056d2 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    800056b4:	85ce                	mv	a1,s3
    800056b6:	854a                	mv	a0,s2
    800056b8:	cbbfb0ef          	jal	80001372 <sleep>
    while(tx_busy != 0){
    800056bc:	409c                	lw	a5,0(s1)
    800056be:	fbfd                	bnez	a5,800056b4 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800056c0:	000a4783          	lbu	a5,0(s4)
    800056c4:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800056c8:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800056cc:	0a05                	addi	s4,s4,1
    800056ce:	015a0563          	beq	s4,s5,800056d8 <uartwrite+0x72>
    while(tx_busy != 0){
    800056d2:	409c                	lw	a5,0(s1)
    800056d4:	f3e5                	bnez	a5,800056b4 <uartwrite+0x4e>
    800056d6:	b7ed                	j	800056c0 <uartwrite+0x5a>
    800056d8:	7942                	ld	s2,48(sp)
    800056da:	79a2                	ld	s3,40(sp)
    800056dc:	7a02                	ld	s4,32(sp)
    800056de:	6b42                	ld	s6,16(sp)
    800056e0:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    800056e2:	0001e517          	auipc	a0,0x1e
    800056e6:	dae50513          	addi	a0,a0,-594 # 80023490 <tx_lock>
    800056ea:	218000ef          	jal	80005902 <release>
}
    800056ee:	60a6                	ld	ra,72(sp)
    800056f0:	6406                	ld	s0,64(sp)
    800056f2:	74e2                	ld	s1,56(sp)
    800056f4:	6ae2                	ld	s5,24(sp)
    800056f6:	6161                	addi	sp,sp,80
    800056f8:	8082                	ret

00000000800056fa <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800056fa:	1101                	addi	sp,sp,-32
    800056fc:	ec06                	sd	ra,24(sp)
    800056fe:	e822                	sd	s0,16(sp)
    80005700:	e426                	sd	s1,8(sp)
    80005702:	1000                	addi	s0,sp,32
    80005704:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005706:	00005797          	auipc	a5,0x5
    8000570a:	a8a7a783          	lw	a5,-1398(a5) # 8000a190 <panicking>
    8000570e:	cf95                	beqz	a5,8000574a <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005710:	00005797          	auipc	a5,0x5
    80005714:	a7c7a783          	lw	a5,-1412(a5) # 8000a18c <panicked>
    80005718:	ef85                	bnez	a5,80005750 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000571a:	10000737          	lui	a4,0x10000
    8000571e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005720:	00074783          	lbu	a5,0(a4)
    80005724:	0207f793          	andi	a5,a5,32
    80005728:	dfe5                	beqz	a5,80005720 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000572a:	0ff4f513          	zext.b	a0,s1
    8000572e:	100007b7          	lui	a5,0x10000
    80005732:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005736:	00005797          	auipc	a5,0x5
    8000573a:	a5a7a783          	lw	a5,-1446(a5) # 8000a190 <panicking>
    8000573e:	cb91                	beqz	a5,80005752 <uartputc_sync+0x58>
    pop_off();
}
    80005740:	60e2                	ld	ra,24(sp)
    80005742:	6442                	ld	s0,16(sp)
    80005744:	64a2                	ld	s1,8(sp)
    80005746:	6105                	addi	sp,sp,32
    80005748:	8082                	ret
    push_off();
    8000574a:	0e0000ef          	jal	8000582a <push_off>
    8000574e:	b7c9                	j	80005710 <uartputc_sync+0x16>
    for(;;)
    80005750:	a001                	j	80005750 <uartputc_sync+0x56>
    pop_off();
    80005752:	15c000ef          	jal	800058ae <pop_off>
}
    80005756:	b7ed                	j	80005740 <uartputc_sync+0x46>

0000000080005758 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005758:	1141                	addi	sp,sp,-16
    8000575a:	e422                	sd	s0,8(sp)
    8000575c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    8000575e:	100007b7          	lui	a5,0x10000
    80005762:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005764:	0007c783          	lbu	a5,0(a5)
    80005768:	8b85                	andi	a5,a5,1
    8000576a:	cb81                	beqz	a5,8000577a <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000576c:	100007b7          	lui	a5,0x10000
    80005770:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005774:	6422                	ld	s0,8(sp)
    80005776:	0141                	addi	sp,sp,16
    80005778:	8082                	ret
    return -1;
    8000577a:	557d                	li	a0,-1
    8000577c:	bfe5                	j	80005774 <uartgetc+0x1c>

000000008000577e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000577e:	1101                	addi	sp,sp,-32
    80005780:	ec06                	sd	ra,24(sp)
    80005782:	e822                	sd	s0,16(sp)
    80005784:	e426                	sd	s1,8(sp)
    80005786:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005788:	100007b7          	lui	a5,0x10000
    8000578c:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    8000578e:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    80005792:	0001e517          	auipc	a0,0x1e
    80005796:	cfe50513          	addi	a0,a0,-770 # 80023490 <tx_lock>
    8000579a:	0d0000ef          	jal	8000586a <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    8000579e:	100007b7          	lui	a5,0x10000
    800057a2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800057a4:	0007c783          	lbu	a5,0(a5)
    800057a8:	0207f793          	andi	a5,a5,32
    800057ac:	eb89                	bnez	a5,800057be <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800057ae:	0001e517          	auipc	a0,0x1e
    800057b2:	ce250513          	addi	a0,a0,-798 # 80023490 <tx_lock>
    800057b6:	14c000ef          	jal	80005902 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800057ba:	54fd                	li	s1,-1
    800057bc:	a831                	j	800057d8 <uartintr+0x5a>
    tx_busy = 0;
    800057be:	00005797          	auipc	a5,0x5
    800057c2:	9c07ad23          	sw	zero,-1574(a5) # 8000a198 <tx_busy>
    wakeup(&tx_chan);
    800057c6:	00005517          	auipc	a0,0x5
    800057ca:	9ce50513          	addi	a0,a0,-1586 # 8000a194 <tx_chan>
    800057ce:	bf1fb0ef          	jal	800013be <wakeup>
    800057d2:	bff1                	j	800057ae <uartintr+0x30>
      break;
    consoleintr(c);
    800057d4:	8a5ff0ef          	jal	80005078 <consoleintr>
    int c = uartgetc();
    800057d8:	f81ff0ef          	jal	80005758 <uartgetc>
    if(c == -1)
    800057dc:	fe951ce3          	bne	a0,s1,800057d4 <uartintr+0x56>
  }
}
    800057e0:	60e2                	ld	ra,24(sp)
    800057e2:	6442                	ld	s0,16(sp)
    800057e4:	64a2                	ld	s1,8(sp)
    800057e6:	6105                	addi	sp,sp,32
    800057e8:	8082                	ret

00000000800057ea <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800057ea:	1141                	addi	sp,sp,-16
    800057ec:	e422                	sd	s0,8(sp)
    800057ee:	0800                	addi	s0,sp,16
  lk->name = name;
    800057f0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800057f2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800057f6:	00053823          	sd	zero,16(a0)
}
    800057fa:	6422                	ld	s0,8(sp)
    800057fc:	0141                	addi	sp,sp,16
    800057fe:	8082                	ret

0000000080005800 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005800:	411c                	lw	a5,0(a0)
    80005802:	e399                	bnez	a5,80005808 <holding+0x8>
    80005804:	4501                	li	a0,0
  return r;
}
    80005806:	8082                	ret
{
    80005808:	1101                	addi	sp,sp,-32
    8000580a:	ec06                	sd	ra,24(sp)
    8000580c:	e822                	sd	s0,16(sp)
    8000580e:	e426                	sd	s1,8(sp)
    80005810:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005812:	6904                	ld	s1,16(a0)
    80005814:	d4afb0ef          	jal	80000d5e <mycpu>
    80005818:	40a48533          	sub	a0,s1,a0
    8000581c:	00153513          	seqz	a0,a0
}
    80005820:	60e2                	ld	ra,24(sp)
    80005822:	6442                	ld	s0,16(sp)
    80005824:	64a2                	ld	s1,8(sp)
    80005826:	6105                	addi	sp,sp,32
    80005828:	8082                	ret

000000008000582a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000582a:	1101                	addi	sp,sp,-32
    8000582c:	ec06                	sd	ra,24(sp)
    8000582e:	e822                	sd	s0,16(sp)
    80005830:	e426                	sd	s1,8(sp)
    80005832:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005834:	100024f3          	csrr	s1,sstatus
    80005838:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000583c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000583e:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005842:	d1cfb0ef          	jal	80000d5e <mycpu>
    80005846:	5d3c                	lw	a5,120(a0)
    80005848:	cb99                	beqz	a5,8000585e <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000584a:	d14fb0ef          	jal	80000d5e <mycpu>
    8000584e:	5d3c                	lw	a5,120(a0)
    80005850:	2785                	addiw	a5,a5,1
    80005852:	dd3c                	sw	a5,120(a0)
}
    80005854:	60e2                	ld	ra,24(sp)
    80005856:	6442                	ld	s0,16(sp)
    80005858:	64a2                	ld	s1,8(sp)
    8000585a:	6105                	addi	sp,sp,32
    8000585c:	8082                	ret
    mycpu()->intena = old;
    8000585e:	d00fb0ef          	jal	80000d5e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005862:	8085                	srli	s1,s1,0x1
    80005864:	8885                	andi	s1,s1,1
    80005866:	dd64                	sw	s1,124(a0)
    80005868:	b7cd                	j	8000584a <push_off+0x20>

000000008000586a <acquire>:
{
    8000586a:	1101                	addi	sp,sp,-32
    8000586c:	ec06                	sd	ra,24(sp)
    8000586e:	e822                	sd	s0,16(sp)
    80005870:	e426                	sd	s1,8(sp)
    80005872:	1000                	addi	s0,sp,32
    80005874:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005876:	fb5ff0ef          	jal	8000582a <push_off>
  if(holding(lk))
    8000587a:	8526                	mv	a0,s1
    8000587c:	f85ff0ef          	jal	80005800 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005880:	4705                	li	a4,1
  if(holding(lk))
    80005882:	e105                	bnez	a0,800058a2 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005884:	87ba                	mv	a5,a4
    80005886:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000588a:	2781                	sext.w	a5,a5
    8000588c:	ffe5                	bnez	a5,80005884 <acquire+0x1a>
  __sync_synchronize();
    8000588e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005892:	cccfb0ef          	jal	80000d5e <mycpu>
    80005896:	e888                	sd	a0,16(s1)
}
    80005898:	60e2                	ld	ra,24(sp)
    8000589a:	6442                	ld	s0,16(sp)
    8000589c:	64a2                	ld	s1,8(sp)
    8000589e:	6105                	addi	sp,sp,32
    800058a0:	8082                	ret
    panic("acquire");
    800058a2:	00002517          	auipc	a0,0x2
    800058a6:	e3e50513          	addi	a0,a0,-450 # 800076e0 <etext+0x6e0>
    800058aa:	d05ff0ef          	jal	800055ae <panic>

00000000800058ae <pop_off>:

void
pop_off(void)
{
    800058ae:	1141                	addi	sp,sp,-16
    800058b0:	e406                	sd	ra,8(sp)
    800058b2:	e022                	sd	s0,0(sp)
    800058b4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800058b6:	ca8fb0ef          	jal	80000d5e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058ba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800058be:	8b89                	andi	a5,a5,2
  if(intr_get())
    800058c0:	e78d                	bnez	a5,800058ea <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800058c2:	5d3c                	lw	a5,120(a0)
    800058c4:	02f05963          	blez	a5,800058f6 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    800058c8:	37fd                	addiw	a5,a5,-1
    800058ca:	0007871b          	sext.w	a4,a5
    800058ce:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800058d0:	eb09                	bnez	a4,800058e2 <pop_off+0x34>
    800058d2:	5d7c                	lw	a5,124(a0)
    800058d4:	c799                	beqz	a5,800058e2 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058d6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800058da:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058de:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800058e2:	60a2                	ld	ra,8(sp)
    800058e4:	6402                	ld	s0,0(sp)
    800058e6:	0141                	addi	sp,sp,16
    800058e8:	8082                	ret
    panic("pop_off - interruptible");
    800058ea:	00002517          	auipc	a0,0x2
    800058ee:	dfe50513          	addi	a0,a0,-514 # 800076e8 <etext+0x6e8>
    800058f2:	cbdff0ef          	jal	800055ae <panic>
    panic("pop_off");
    800058f6:	00002517          	auipc	a0,0x2
    800058fa:	e0a50513          	addi	a0,a0,-502 # 80007700 <etext+0x700>
    800058fe:	cb1ff0ef          	jal	800055ae <panic>

0000000080005902 <release>:
{
    80005902:	1101                	addi	sp,sp,-32
    80005904:	ec06                	sd	ra,24(sp)
    80005906:	e822                	sd	s0,16(sp)
    80005908:	e426                	sd	s1,8(sp)
    8000590a:	1000                	addi	s0,sp,32
    8000590c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000590e:	ef3ff0ef          	jal	80005800 <holding>
    80005912:	c105                	beqz	a0,80005932 <release+0x30>
  lk->cpu = 0;
    80005914:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005918:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000591c:	0310000f          	fence	rw,w
    80005920:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005924:	f8bff0ef          	jal	800058ae <pop_off>
}
    80005928:	60e2                	ld	ra,24(sp)
    8000592a:	6442                	ld	s0,16(sp)
    8000592c:	64a2                	ld	s1,8(sp)
    8000592e:	6105                	addi	sp,sp,32
    80005930:	8082                	ret
    panic("release");
    80005932:	00002517          	auipc	a0,0x2
    80005936:	dd650513          	addi	a0,a0,-554 # 80007708 <etext+0x708>
    8000593a:	c75ff0ef          	jal	800055ae <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
