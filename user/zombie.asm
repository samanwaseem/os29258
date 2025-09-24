
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2a4000ef          	jal	2ac <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2a2000ef          	jal	2b4 <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	32c000ef          	jal	344 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	288000ef          	jal	2b4 <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	86be                	mv	a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	ff65                	bnez	a4,88 <strlen+0x10>
  92:	40a6853b          	subw	a0,a3,a0
  96:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	1b2000ef          	jal	2cc <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	addi	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
    buf[i++] = c;
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	18e000ef          	jal	2f4 <open>
  if(fd < 0)
 16a:	02054263          	bltz	a0,18e <stat+0x36>
 16e:	e426                	sd	s1,8(sp)
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	198000ef          	jal	30c <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	160000ef          	jal	2dc <close>
  return r;
 180:	64a2                	ld	s1,8(sp)
}
 182:	854a                	mv	a0,s2
 184:	60e2                	ld	ra,24(sp)
 186:	6442                	ld	s0,16(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	addi	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfcd                	j	182 <stat+0x2a>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054683          	lbu	a3,0(a0)
 19c:	fd06879b          	addiw	a5,a3,-48
 1a0:	0ff7f793          	zext.b	a5,a5
 1a4:	4625                	li	a2,9
 1a6:	02f66863          	bltu	a2,a5,1d6 <atoi+0x44>
 1aa:	872a                	mv	a4,a0
  n = 0;
 1ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ae:	0705                	addi	a4,a4,1
 1b0:	0025179b          	slliw	a5,a0,0x2
 1b4:	9fa9                	addw	a5,a5,a0
 1b6:	0017979b          	slliw	a5,a5,0x1
 1ba:	9fb5                	addw	a5,a5,a3
 1bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c0:	00074683          	lbu	a3,0(a4)
 1c4:	fd06879b          	addiw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	fef671e3          	bgeu	a2,a5,1ae <atoi+0x1c>
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  n = 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <atoi+0x3e>

00000000000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e0:	02b57463          	bgeu	a0,a1,208 <memmove+0x2e>
    while(n-- > 0)
 1e4:	00c05f63          	blez	a2,202 <memmove+0x28>
 1e8:	1602                	slli	a2,a2,0x20
 1ea:	9201                	srli	a2,a2,0x20
 1ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f2:	0585                	addi	a1,a1,1
 1f4:	0705                	addi	a4,a4,1
 1f6:	fff5c683          	lbu	a3,-1(a1)
 1fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fe:	fef71ae3          	bne	a4,a5,1f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
    dst += n;
 208:	00c50733          	add	a4,a0,a2
    src += n;
 20c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20e:	fec05ae3          	blez	a2,202 <memmove+0x28>
 212:	fff6079b          	addiw	a5,a2,-1
 216:	1782                	slli	a5,a5,0x20
 218:	9381                	srli	a5,a5,0x20
 21a:	fff7c793          	not	a5,a5
 21e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 220:	15fd                	addi	a1,a1,-1
 222:	177d                	addi	a4,a4,-1
 224:	0005c683          	lbu	a3,0(a1)
 228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x46>
 230:	bfc9                	j	202 <memmove+0x28>

0000000000000232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 238:	ca05                	beqz	a2,268 <memcmp+0x36>
 23a:	fff6069b          	addiw	a3,a2,-1
 23e:	1682                	slli	a3,a3,0x20
 240:	9281                	srli	a3,a3,0x20
 242:	0685                	addi	a3,a3,1
 244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 246:	00054783          	lbu	a5,0(a0)
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00e79863          	bne	a5,a4,25e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 252:	0505                	addi	a0,a0,1
    p2++;
 254:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 256:	fed518e3          	bne	a0,a3,246 <memcmp+0x14>
  }
  return 0;
 25a:	4501                	li	a0,0
 25c:	a019                	j	262 <memcmp+0x30>
      return *p1 - *p2;
 25e:	40e7853b          	subw	a0,a5,a4
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <memcmp+0x30>

000000000000026c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 274:	f67ff0ef          	jal	1da <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <sbrk>:

char *
sbrk(int n) {
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 288:	4585                	li	a1,1
 28a:	0b2000ef          	jal	33c <sys_sbrk>
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <sbrklazy>:

char *
sbrklazy(int n) {
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 29e:	4589                	li	a1,2
 2a0:	09c000ef          	jal	33c <sys_sbrk>
}
 2a4:	60a2                	ld	ra,8(sp)
 2a6:	6402                	ld	s0,0(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret

00000000000002ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ac:	4885                	li	a7,1
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b4:	4889                	li	a7,2
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2bc:	488d                	li	a7,3
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c4:	4891                	li	a7,4
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <read>:
.global read
read:
 li a7, SYS_read
 2cc:	4895                	li	a7,5
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <write>:
.global write
write:
 li a7, SYS_write
 2d4:	48c1                	li	a7,16
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <close>:
.global close
close:
 li a7, SYS_close
 2dc:	48d5                	li	a7,21
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e4:	4899                	li	a7,6
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ec:	489d                	li	a7,7
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <open>:
.global open
open:
 li a7, SYS_open
 2f4:	48bd                	li	a7,15
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2fc:	48c5                	li	a7,17
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 304:	48c9                	li	a7,18
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 30c:	48a1                	li	a7,8
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <link>:
.global link
link:
 li a7, SYS_link
 314:	48cd                	li	a7,19
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 31c:	48d1                	li	a7,20
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 324:	48a5                	li	a7,9
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <dup>:
.global dup
dup:
 li a7, SYS_dup
 32c:	48a9                	li	a7,10
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 334:	48ad                	li	a7,11
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 33c:	48b1                	li	a7,12
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <pause>:
.global pause
pause:
 li a7, SYS_pause
 344:	48b5                	li	a7,13
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 34c:	48b9                	li	a7,14
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 354:	1101                	addi	sp,sp,-32
 356:	ec06                	sd	ra,24(sp)
 358:	e822                	sd	s0,16(sp)
 35a:	1000                	addi	s0,sp,32
 35c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 360:	4605                	li	a2,1
 362:	fef40593          	addi	a1,s0,-17
 366:	f6fff0ef          	jal	2d4 <write>
}
 36a:	60e2                	ld	ra,24(sp)
 36c:	6442                	ld	s0,16(sp)
 36e:	6105                	addi	sp,sp,32
 370:	8082                	ret

0000000000000372 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 372:	715d                	addi	sp,sp,-80
 374:	e486                	sd	ra,72(sp)
 376:	e0a2                	sd	s0,64(sp)
 378:	fc26                	sd	s1,56(sp)
 37a:	0880                	addi	s0,sp,80
 37c:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37e:	c299                	beqz	a3,384 <printint+0x12>
 380:	0805c963          	bltz	a1,412 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 384:	2581                	sext.w	a1,a1
  neg = 0;
 386:	4881                	li	a7,0
 388:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 38c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 38e:	2601                	sext.w	a2,a2
 390:	00000517          	auipc	a0,0x0
 394:	51850513          	addi	a0,a0,1304 # 8a8 <digits>
 398:	883a                	mv	a6,a4
 39a:	2705                	addiw	a4,a4,1
 39c:	02c5f7bb          	remuw	a5,a1,a2
 3a0:	1782                	slli	a5,a5,0x20
 3a2:	9381                	srli	a5,a5,0x20
 3a4:	97aa                	add	a5,a5,a0
 3a6:	0007c783          	lbu	a5,0(a5)
 3aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ae:	0005879b          	sext.w	a5,a1
 3b2:	02c5d5bb          	divuw	a1,a1,a2
 3b6:	0685                	addi	a3,a3,1
 3b8:	fec7f0e3          	bgeu	a5,a2,398 <printint+0x26>
  if(neg)
 3bc:	00088c63          	beqz	a7,3d4 <printint+0x62>
    buf[i++] = '-';
 3c0:	fd070793          	addi	a5,a4,-48
 3c4:	00878733          	add	a4,a5,s0
 3c8:	02d00793          	li	a5,45
 3cc:	fef70423          	sb	a5,-24(a4)
 3d0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3d4:	02e05a63          	blez	a4,408 <printint+0x96>
 3d8:	f84a                	sd	s2,48(sp)
 3da:	f44e                	sd	s3,40(sp)
 3dc:	fb840793          	addi	a5,s0,-72
 3e0:	00e78933          	add	s2,a5,a4
 3e4:	fff78993          	addi	s3,a5,-1
 3e8:	99ba                	add	s3,s3,a4
 3ea:	377d                	addiw	a4,a4,-1
 3ec:	1702                	slli	a4,a4,0x20
 3ee:	9301                	srli	a4,a4,0x20
 3f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f4:	fff94583          	lbu	a1,-1(s2)
 3f8:	8526                	mv	a0,s1
 3fa:	f5bff0ef          	jal	354 <putc>
  while(--i >= 0)
 3fe:	197d                	addi	s2,s2,-1
 400:	ff391ae3          	bne	s2,s3,3f4 <printint+0x82>
 404:	7942                	ld	s2,48(sp)
 406:	79a2                	ld	s3,40(sp)
}
 408:	60a6                	ld	ra,72(sp)
 40a:	6406                	ld	s0,64(sp)
 40c:	74e2                	ld	s1,56(sp)
 40e:	6161                	addi	sp,sp,80
 410:	8082                	ret
    x = -xx;
 412:	40b005bb          	negw	a1,a1
    neg = 1;
 416:	4885                	li	a7,1
    x = -xx;
 418:	bf85                	j	388 <printint+0x16>

000000000000041a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 41a:	711d                	addi	sp,sp,-96
 41c:	ec86                	sd	ra,88(sp)
 41e:	e8a2                	sd	s0,80(sp)
 420:	e0ca                	sd	s2,64(sp)
 422:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 424:	0005c903          	lbu	s2,0(a1)
 428:	28090663          	beqz	s2,6b4 <vprintf+0x29a>
 42c:	e4a6                	sd	s1,72(sp)
 42e:	fc4e                	sd	s3,56(sp)
 430:	f852                	sd	s4,48(sp)
 432:	f456                	sd	s5,40(sp)
 434:	f05a                	sd	s6,32(sp)
 436:	ec5e                	sd	s7,24(sp)
 438:	e862                	sd	s8,16(sp)
 43a:	e466                	sd	s9,8(sp)
 43c:	8b2a                	mv	s6,a0
 43e:	8a2e                	mv	s4,a1
 440:	8bb2                	mv	s7,a2
  state = 0;
 442:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 444:	4481                	li	s1,0
 446:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 448:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 44c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 450:	06c00c93          	li	s9,108
 454:	a005                	j	474 <vprintf+0x5a>
        putc(fd, c0);
 456:	85ca                	mv	a1,s2
 458:	855a                	mv	a0,s6
 45a:	efbff0ef          	jal	354 <putc>
 45e:	a019                	j	464 <vprintf+0x4a>
    } else if(state == '%'){
 460:	03598263          	beq	s3,s5,484 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 464:	2485                	addiw	s1,s1,1
 466:	8726                	mv	a4,s1
 468:	009a07b3          	add	a5,s4,s1
 46c:	0007c903          	lbu	s2,0(a5)
 470:	22090a63          	beqz	s2,6a4 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 474:	0009079b          	sext.w	a5,s2
    if(state == 0){
 478:	fe0994e3          	bnez	s3,460 <vprintf+0x46>
      if(c0 == '%'){
 47c:	fd579de3          	bne	a5,s5,456 <vprintf+0x3c>
        state = '%';
 480:	89be                	mv	s3,a5
 482:	b7cd                	j	464 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 484:	00ea06b3          	add	a3,s4,a4
 488:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 48c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 48e:	c681                	beqz	a3,496 <vprintf+0x7c>
 490:	9752                	add	a4,a4,s4
 492:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 496:	05878363          	beq	a5,s8,4dc <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 49a:	05978d63          	beq	a5,s9,4f4 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 49e:	07500713          	li	a4,117
 4a2:	0ee78763          	beq	a5,a4,590 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4a6:	07800713          	li	a4,120
 4aa:	12e78963          	beq	a5,a4,5dc <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ae:	07000713          	li	a4,112
 4b2:	14e78e63          	beq	a5,a4,60e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4b6:	06300713          	li	a4,99
 4ba:	18e78e63          	beq	a5,a4,656 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4be:	07300713          	li	a4,115
 4c2:	1ae78463          	beq	a5,a4,66a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4c6:	02500713          	li	a4,37
 4ca:	04e79563          	bne	a5,a4,514 <vprintf+0xfa>
        putc(fd, '%');
 4ce:	02500593          	li	a1,37
 4d2:	855a                	mv	a0,s6
 4d4:	e81ff0ef          	jal	354 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4d8:	4981                	li	s3,0
 4da:	b769                	j	464 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4dc:	008b8913          	addi	s2,s7,8
 4e0:	4685                	li	a3,1
 4e2:	4629                	li	a2,10
 4e4:	000ba583          	lw	a1,0(s7)
 4e8:	855a                	mv	a0,s6
 4ea:	e89ff0ef          	jal	372 <printint>
 4ee:	8bca                	mv	s7,s2
      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	bf8d                	j	464 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4f4:	06400793          	li	a5,100
 4f8:	02f68963          	beq	a3,a5,52a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4fc:	06c00793          	li	a5,108
 500:	04f68263          	beq	a3,a5,544 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 504:	07500793          	li	a5,117
 508:	0af68063          	beq	a3,a5,5a8 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 50c:	07800793          	li	a5,120
 510:	0ef68263          	beq	a3,a5,5f4 <vprintf+0x1da>
        putc(fd, '%');
 514:	02500593          	li	a1,37
 518:	855a                	mv	a0,s6
 51a:	e3bff0ef          	jal	354 <putc>
        putc(fd, c0);
 51e:	85ca                	mv	a1,s2
 520:	855a                	mv	a0,s6
 522:	e33ff0ef          	jal	354 <putc>
      state = 0;
 526:	4981                	li	s3,0
 528:	bf35                	j	464 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 52a:	008b8913          	addi	s2,s7,8
 52e:	4685                	li	a3,1
 530:	4629                	li	a2,10
 532:	000bb583          	ld	a1,0(s7)
 536:	855a                	mv	a0,s6
 538:	e3bff0ef          	jal	372 <printint>
        i += 1;
 53c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 53e:	8bca                	mv	s7,s2
      state = 0;
 540:	4981                	li	s3,0
        i += 1;
 542:	b70d                	j	464 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 544:	06400793          	li	a5,100
 548:	02f60763          	beq	a2,a5,576 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 54c:	07500793          	li	a5,117
 550:	06f60963          	beq	a2,a5,5c2 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 554:	07800793          	li	a5,120
 558:	faf61ee3          	bne	a2,a5,514 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 55c:	008b8913          	addi	s2,s7,8
 560:	4681                	li	a3,0
 562:	4641                	li	a2,16
 564:	000bb583          	ld	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	e09ff0ef          	jal	372 <printint>
        i += 2;
 56e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 570:	8bca                	mv	s7,s2
      state = 0;
 572:	4981                	li	s3,0
        i += 2;
 574:	bdc5                	j	464 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 576:	008b8913          	addi	s2,s7,8
 57a:	4685                	li	a3,1
 57c:	4629                	li	a2,10
 57e:	000bb583          	ld	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	defff0ef          	jal	372 <printint>
        i += 2;
 588:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
        i += 2;
 58e:	bdd9                	j	464 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000be583          	lwu	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	dd5ff0ef          	jal	372 <printint>
 5a2:	8bca                	mv	s7,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bd7d                	j	464 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4629                	li	a2,10
 5b0:	000bb583          	ld	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	dbdff0ef          	jal	372 <printint>
        i += 1;
 5ba:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	8bca                	mv	s7,s2
      state = 0;
 5be:	4981                	li	s3,0
        i += 1;
 5c0:	b555                	j	464 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4629                	li	a2,10
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	da3ff0ef          	jal	372 <printint>
        i += 2;
 5d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
        i += 2;
 5da:	b569                	j	464 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4641                	li	a2,16
 5e4:	000be583          	lwu	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	d89ff0ef          	jal	372 <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bd8d                	j	464 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	d71ff0ef          	jal	372 <printint>
        i += 1;
 606:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
        i += 1;
 60c:	bda1                	j	464 <vprintf+0x4a>
 60e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 610:	008b8d13          	addi	s10,s7,8
 614:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 618:	03000593          	li	a1,48
 61c:	855a                	mv	a0,s6
 61e:	d37ff0ef          	jal	354 <putc>
  putc(fd, 'x');
 622:	07800593          	li	a1,120
 626:	855a                	mv	a0,s6
 628:	d2dff0ef          	jal	354 <putc>
 62c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62e:	00000b97          	auipc	s7,0x0
 632:	27ab8b93          	addi	s7,s7,634 # 8a8 <digits>
 636:	03c9d793          	srli	a5,s3,0x3c
 63a:	97de                	add	a5,a5,s7
 63c:	0007c583          	lbu	a1,0(a5)
 640:	855a                	mv	a0,s6
 642:	d13ff0ef          	jal	354 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 646:	0992                	slli	s3,s3,0x4
 648:	397d                	addiw	s2,s2,-1
 64a:	fe0916e3          	bnez	s2,636 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 64e:	8bea                	mv	s7,s10
      state = 0;
 650:	4981                	li	s3,0
 652:	6d02                	ld	s10,0(sp)
 654:	bd01                	j	464 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 656:	008b8913          	addi	s2,s7,8
 65a:	000bc583          	lbu	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	cf5ff0ef          	jal	354 <putc>
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
 668:	bbf5                	j	464 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 66a:	008b8993          	addi	s3,s7,8
 66e:	000bb903          	ld	s2,0(s7)
 672:	00090f63          	beqz	s2,690 <vprintf+0x276>
        for(; *s; s++)
 676:	00094583          	lbu	a1,0(s2)
 67a:	c195                	beqz	a1,69e <vprintf+0x284>
          putc(fd, *s);
 67c:	855a                	mv	a0,s6
 67e:	cd7ff0ef          	jal	354 <putc>
        for(; *s; s++)
 682:	0905                	addi	s2,s2,1
 684:	00094583          	lbu	a1,0(s2)
 688:	f9f5                	bnez	a1,67c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 68a:	8bce                	mv	s7,s3
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bbd9                	j	464 <vprintf+0x4a>
          s = "(null)";
 690:	00000917          	auipc	s2,0x0
 694:	21090913          	addi	s2,s2,528 # 8a0 <malloc+0x104>
        for(; *s; s++)
 698:	02800593          	li	a1,40
 69c:	b7c5                	j	67c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 69e:	8bce                	mv	s7,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b3c9                	j	464 <vprintf+0x4a>
 6a4:	64a6                	ld	s1,72(sp)
 6a6:	79e2                	ld	s3,56(sp)
 6a8:	7a42                	ld	s4,48(sp)
 6aa:	7aa2                	ld	s5,40(sp)
 6ac:	7b02                	ld	s6,32(sp)
 6ae:	6be2                	ld	s7,24(sp)
 6b0:	6c42                	ld	s8,16(sp)
 6b2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6b4:	60e6                	ld	ra,88(sp)
 6b6:	6446                	ld	s0,80(sp)
 6b8:	6906                	ld	s2,64(sp)
 6ba:	6125                	addi	sp,sp,96
 6bc:	8082                	ret

00000000000006be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6be:	715d                	addi	sp,sp,-80
 6c0:	ec06                	sd	ra,24(sp)
 6c2:	e822                	sd	s0,16(sp)
 6c4:	1000                	addi	s0,sp,32
 6c6:	e010                	sd	a2,0(s0)
 6c8:	e414                	sd	a3,8(s0)
 6ca:	e818                	sd	a4,16(s0)
 6cc:	ec1c                	sd	a5,24(s0)
 6ce:	03043023          	sd	a6,32(s0)
 6d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6da:	8622                	mv	a2,s0
 6dc:	d3fff0ef          	jal	41a <vprintf>
}
 6e0:	60e2                	ld	ra,24(sp)
 6e2:	6442                	ld	s0,16(sp)
 6e4:	6161                	addi	sp,sp,80
 6e6:	8082                	ret

00000000000006e8 <printf>:

void
printf(const char *fmt, ...)
{
 6e8:	711d                	addi	sp,sp,-96
 6ea:	ec06                	sd	ra,24(sp)
 6ec:	e822                	sd	s0,16(sp)
 6ee:	1000                	addi	s0,sp,32
 6f0:	e40c                	sd	a1,8(s0)
 6f2:	e810                	sd	a2,16(s0)
 6f4:	ec14                	sd	a3,24(s0)
 6f6:	f018                	sd	a4,32(s0)
 6f8:	f41c                	sd	a5,40(s0)
 6fa:	03043823          	sd	a6,48(s0)
 6fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	00840613          	addi	a2,s0,8
 706:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 70a:	85aa                	mv	a1,a0
 70c:	4505                	li	a0,1
 70e:	d0dff0ef          	jal	41a <vprintf>
}
 712:	60e2                	ld	ra,24(sp)
 714:	6442                	ld	s0,16(sp)
 716:	6125                	addi	sp,sp,96
 718:	8082                	ret

000000000000071a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71a:	1141                	addi	sp,sp,-16
 71c:	e422                	sd	s0,8(sp)
 71e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 720:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 724:	00001797          	auipc	a5,0x1
 728:	8dc7b783          	ld	a5,-1828(a5) # 1000 <freep>
 72c:	a02d                	j	756 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 72e:	4618                	lw	a4,8(a2)
 730:	9f2d                	addw	a4,a4,a1
 732:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 736:	6398                	ld	a4,0(a5)
 738:	6310                	ld	a2,0(a4)
 73a:	a83d                	j	778 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 73c:	ff852703          	lw	a4,-8(a0)
 740:	9f31                	addw	a4,a4,a2
 742:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 744:	ff053683          	ld	a3,-16(a0)
 748:	a091                	j	78c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74a:	6398                	ld	a4,0(a5)
 74c:	00e7e463          	bltu	a5,a4,754 <free+0x3a>
 750:	00e6ea63          	bltu	a3,a4,764 <free+0x4a>
{
 754:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 756:	fed7fae3          	bgeu	a5,a3,74a <free+0x30>
 75a:	6398                	ld	a4,0(a5)
 75c:	00e6e463          	bltu	a3,a4,764 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	fee7eae3          	bltu	a5,a4,754 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 764:	ff852583          	lw	a1,-8(a0)
 768:	6390                	ld	a2,0(a5)
 76a:	02059813          	slli	a6,a1,0x20
 76e:	01c85713          	srli	a4,a6,0x1c
 772:	9736                	add	a4,a4,a3
 774:	fae60de3          	beq	a2,a4,72e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 778:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77c:	4790                	lw	a2,8(a5)
 77e:	02061593          	slli	a1,a2,0x20
 782:	01c5d713          	srli	a4,a1,0x1c
 786:	973e                	add	a4,a4,a5
 788:	fae68ae3          	beq	a3,a4,73c <free+0x22>
    p->s.ptr = bp->s.ptr;
 78c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 78e:	00001717          	auipc	a4,0x1
 792:	86f73923          	sd	a5,-1934(a4) # 1000 <freep>
}
 796:	6422                	ld	s0,8(sp)
 798:	0141                	addi	sp,sp,16
 79a:	8082                	ret

000000000000079c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79c:	7139                	addi	sp,sp,-64
 79e:	fc06                	sd	ra,56(sp)
 7a0:	f822                	sd	s0,48(sp)
 7a2:	f426                	sd	s1,40(sp)
 7a4:	ec4e                	sd	s3,24(sp)
 7a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a8:	02051493          	slli	s1,a0,0x20
 7ac:	9081                	srli	s1,s1,0x20
 7ae:	04bd                	addi	s1,s1,15
 7b0:	8091                	srli	s1,s1,0x4
 7b2:	0014899b          	addiw	s3,s1,1
 7b6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7b8:	00001517          	auipc	a0,0x1
 7bc:	84853503          	ld	a0,-1976(a0) # 1000 <freep>
 7c0:	c915                	beqz	a0,7f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c4:	4798                	lw	a4,8(a5)
 7c6:	08977a63          	bgeu	a4,s1,85a <malloc+0xbe>
 7ca:	f04a                	sd	s2,32(sp)
 7cc:	e852                	sd	s4,16(sp)
 7ce:	e456                	sd	s5,8(sp)
 7d0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7d2:	8a4e                	mv	s4,s3
 7d4:	0009871b          	sext.w	a4,s3
 7d8:	6685                	lui	a3,0x1
 7da:	00d77363          	bgeu	a4,a3,7e0 <malloc+0x44>
 7de:	6a05                	lui	s4,0x1
 7e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e8:	00001917          	auipc	s2,0x1
 7ec:	81890913          	addi	s2,s2,-2024 # 1000 <freep>
  if(p == SBRK_ERROR)
 7f0:	5afd                	li	s5,-1
 7f2:	a081                	j	832 <malloc+0x96>
 7f4:	f04a                	sd	s2,32(sp)
 7f6:	e852                	sd	s4,16(sp)
 7f8:	e456                	sd	s5,8(sp)
 7fa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7fc:	00001797          	auipc	a5,0x1
 800:	81478793          	addi	a5,a5,-2028 # 1010 <base>
 804:	00000717          	auipc	a4,0x0
 808:	7ef73e23          	sd	a5,2044(a4) # 1000 <freep>
 80c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 80e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 812:	b7c1                	j	7d2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 814:	6398                	ld	a4,0(a5)
 816:	e118                	sd	a4,0(a0)
 818:	a8a9                	j	872 <malloc+0xd6>
  hp->s.size = nu;
 81a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 81e:	0541                	addi	a0,a0,16
 820:	efbff0ef          	jal	71a <free>
  return freep;
 824:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 828:	c12d                	beqz	a0,88a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82c:	4798                	lw	a4,8(a5)
 82e:	02977263          	bgeu	a4,s1,852 <malloc+0xb6>
    if(p == freep)
 832:	00093703          	ld	a4,0(s2)
 836:	853e                	mv	a0,a5
 838:	fef719e3          	bne	a4,a5,82a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 83c:	8552                	mv	a0,s4
 83e:	a43ff0ef          	jal	280 <sbrk>
  if(p == SBRK_ERROR)
 842:	fd551ce3          	bne	a0,s5,81a <malloc+0x7e>
        return 0;
 846:	4501                	li	a0,0
 848:	7902                	ld	s2,32(sp)
 84a:	6a42                	ld	s4,16(sp)
 84c:	6aa2                	ld	s5,8(sp)
 84e:	6b02                	ld	s6,0(sp)
 850:	a03d                	j	87e <malloc+0xe2>
 852:	7902                	ld	s2,32(sp)
 854:	6a42                	ld	s4,16(sp)
 856:	6aa2                	ld	s5,8(sp)
 858:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 85a:	fae48de3          	beq	s1,a4,814 <malloc+0x78>
        p->s.size -= nunits;
 85e:	4137073b          	subw	a4,a4,s3
 862:	c798                	sw	a4,8(a5)
        p += p->s.size;
 864:	02071693          	slli	a3,a4,0x20
 868:	01c6d713          	srli	a4,a3,0x1c
 86c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 872:	00000717          	auipc	a4,0x0
 876:	78a73723          	sd	a0,1934(a4) # 1000 <freep>
      return (void*)(p + 1);
 87a:	01078513          	addi	a0,a5,16
  }
}
 87e:	70e2                	ld	ra,56(sp)
 880:	7442                	ld	s0,48(sp)
 882:	74a2                	ld	s1,40(sp)
 884:	69e2                	ld	s3,24(sp)
 886:	6121                	addi	sp,sp,64
 888:	8082                	ret
 88a:	7902                	ld	s2,32(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	b7f5                	j	87e <malloc+0xe2>
