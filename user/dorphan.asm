
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	8f450513          	addi	a0,a0,-1804 # 900 <malloc+0xf8>
  14:	374000ef          	jal	388 <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	8ec50513          	addi	a0,a0,-1812 # 908 <malloc+0x100>
  24:	730000ef          	jal	754 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	2f6000ef          	jal	320 <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	8d250513          	addi	a0,a0,-1838 # 900 <malloc+0xf8>
  36:	35a000ef          	jal	390 <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	8e250513          	addi	a0,a0,-1822 # 920 <malloc+0x118>
  46:	70e000ef          	jal	754 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2d4000ef          	jal	320 <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	8e850513          	addi	a0,a0,-1816 # 938 <malloc+0x130>
  58:	318000ef          	jal	370 <unlink>
  5c:	00054d63          	bltz	a0,76 <main+0x76>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	8f850513          	addi	a0,a0,-1800 # 958 <malloc+0x150>
  68:	6ec000ef          	jal	754 <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800513          	li	a0,1000
  70:	340000ef          	jal	3b0 <pause>
  74:	bfe5                	j	6c <main+0x6c>
    printf("%s: unlink failed\n", s);
  76:	85a6                	mv	a1,s1
  78:	00001517          	auipc	a0,0x1
  7c:	8c850513          	addi	a0,a0,-1848 # 940 <malloc+0x138>
  80:	6d4000ef          	jal	754 <printf>
    exit(1);
  84:	4505                	li	a0,1
  86:	29a000ef          	jal	320 <exit>

000000000000008a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	addi	s0,sp,16
  extern int main();
  main();
  92:	f6fff0ef          	jal	0 <main>
  exit(0);
  96:	4501                	li	a0,0
  98:	288000ef          	jal	320 <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a2:	87aa                	mv	a5,a0
  a4:	0585                	addi	a1,a1,1
  a6:	0785                	addi	a5,a5,1
  a8:	fff5c703          	lbu	a4,-1(a1)
  ac:	fee78fa3          	sb	a4,-1(a5)
  b0:	fb75                	bnez	a4,a4 <strcpy+0x8>
    ;
  return os;
}
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cb91                	beqz	a5,d6 <strcmp+0x1e>
  c4:	0005c703          	lbu	a4,0(a1)
  c8:	00f71763          	bne	a4,a5,d6 <strcmp+0x1e>
    p++, q++;
  cc:	0505                	addi	a0,a0,1
  ce:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbe5                	bnez	a5,c4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d6:	0005c503          	lbu	a0,0(a1)
}
  da:	40a7853b          	subw	a0,a5,a0
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cf91                	beqz	a5,10a <strlen+0x26>
  f0:	0505                	addi	a0,a0,1
  f2:	87aa                	mv	a5,a0
  f4:	86be                	mv	a3,a5
  f6:	0785                	addi	a5,a5,1
  f8:	fff7c703          	lbu	a4,-1(a5)
  fc:	ff65                	bnez	a4,f4 <strlen+0x10>
  fe:	40a6853b          	subw	a0,a3,a0
 102:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  for(n = 0; s[n]; n++)
 10a:	4501                	li	a0,0
 10c:	bfe5                	j	104 <strlen+0x20>

000000000000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 114:	ca19                	beqz	a2,12a <memset+0x1c>
 116:	87aa                	mv	a5,a0
 118:	1602                	slli	a2,a2,0x20
 11a:	9201                	srli	a2,a2,0x20
 11c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 120:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 124:	0785                	addi	a5,a5,1
 126:	fee79de3          	bne	a5,a4,120 <memset+0x12>
  }
  return dst;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  for(; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb99                	beqz	a5,150 <strchr+0x20>
    if(*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1a>
  for(; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xc>
      return (char*)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  return 0;
 150:	4501                	li	a0,0
 152:	bfe5                	j	14a <strchr+0x1a>

0000000000000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	711d                	addi	sp,sp,-96
 156:	ec86                	sd	ra,88(sp)
 158:	e8a2                	sd	s0,80(sp)
 15a:	e4a6                	sd	s1,72(sp)
 15c:	e0ca                	sd	s2,64(sp)
 15e:	fc4e                	sd	s3,56(sp)
 160:	f852                	sd	s4,48(sp)
 162:	f456                	sd	s5,40(sp)
 164:	f05a                	sd	s6,32(sp)
 166:	ec5e                	sd	s7,24(sp)
 168:	1080                	addi	s0,sp,96
 16a:	8baa                	mv	s7,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 172:	4aa9                	li	s5,10
 174:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 176:	89a6                	mv	s3,s1
 178:	2485                	addiw	s1,s1,1
 17a:	0344d663          	bge	s1,s4,1a6 <gets+0x52>
    cc = read(0, &c, 1);
 17e:	4605                	li	a2,1
 180:	faf40593          	addi	a1,s0,-81
 184:	4501                	li	a0,0
 186:	1b2000ef          	jal	338 <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x52>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x50>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679de3          	bne	a5,s6,176 <gets+0x22>
    buf[i++] = c;
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x52>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	18e000ef          	jal	360 <open>
  if(fd < 0)
 1d6:	02054263          	bltz	a0,1fa <stat+0x36>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	198000ef          	jal	378 <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	160000ef          	jal	348 <close>
  return r;
 1ec:	64a2                	ld	s1,8(sp)
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	6902                	ld	s2,0(sp)
 1f6:	6105                	addi	sp,sp,32
 1f8:	8082                	ret
    return -1;
 1fa:	597d                	li	s2,-1
 1fc:	bfcd                	j	1ee <stat+0x2a>

00000000000001fe <atoi>:

int
atoi(const char *s)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 204:	00054683          	lbu	a3,0(a0)
 208:	fd06879b          	addiw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	4625                	li	a2,9
 212:	02f66863          	bltu	a2,a5,242 <atoi+0x44>
 216:	872a                	mv	a4,a0
  n = 0;
 218:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21a:	0705                	addi	a4,a4,1
 21c:	0025179b          	slliw	a5,a0,0x2
 220:	9fa9                	addw	a5,a5,a0
 222:	0017979b          	slliw	a5,a5,0x1
 226:	9fb5                	addw	a5,a5,a3
 228:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22c:	00074683          	lbu	a3,0(a4)
 230:	fd06879b          	addiw	a5,a3,-48
 234:	0ff7f793          	zext.b	a5,a5
 238:	fef671e3          	bgeu	a2,a5,21a <atoi+0x1c>
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  n = 0;
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <atoi+0x3e>

0000000000000246 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57463          	bgeu	a0,a1,274 <memmove+0x2e>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x28>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	addi	a1,a1,1
 260:	0705                	addi	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fef71ae3          	bne	a4,a5,25e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
    dst += n;
 274:	00c50733          	add	a4,a0,a2
    src += n;
 278:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27a:	fec05ae3          	blez	a2,26e <memmove+0x28>
 27e:	fff6079b          	addiw	a5,a2,-1
 282:	1782                	slli	a5,a5,0x20
 284:	9381                	srli	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	addi	a1,a1,-1
 28e:	177d                	addi	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x46>
 29c:	bfc9                	j	26e <memmove+0x28>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a4:	ca05                	beqz	a2,2d4 <memcmp+0x36>
 2a6:	fff6069b          	addiw	a3,a2,-1
 2aa:	1682                	slli	a3,a3,0x20
 2ac:	9281                	srli	a3,a3,0x20
 2ae:	0685                	addi	a3,a3,1
 2b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	0005c703          	lbu	a4,0(a1)
 2ba:	00e79863          	bne	a5,a4,2ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2be:	0505                	addi	a0,a0,1
    p2++;
 2c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c2:	fed518e3          	bne	a0,a3,2b2 <memcmp+0x14>
  }
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	a019                	j	2ce <memcmp+0x30>
      return *p1 - *p2;
 2ca:	40e7853b          	subw	a0,a5,a4
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <memcmp+0x30>

00000000000002d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e0:	f67ff0ef          	jal	246 <memmove>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <sbrk>:

char *
sbrk(int n) {
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f4:	4585                	li	a1,1
 2f6:	0b2000ef          	jal	3a8 <sys_sbrk>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <sbrklazy>:

char *
sbrklazy(int n) {
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 30a:	4589                	li	a1,2
 30c:	09c000ef          	jal	3a8 <sys_sbrk>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 318:	4885                	li	a7,1
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exit>:
.global exit
exit:
 li a7, SYS_exit
 320:	4889                	li	a7,2
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <wait>:
.global wait
wait:
 li a7, SYS_wait
 328:	488d                	li	a7,3
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 330:	4891                	li	a7,4
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <read>:
.global read
read:
 li a7, SYS_read
 338:	4895                	li	a7,5
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <write>:
.global write
write:
 li a7, SYS_write
 340:	48c1                	li	a7,16
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <close>:
.global close
close:
 li a7, SYS_close
 348:	48d5                	li	a7,21
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <kill>:
.global kill
kill:
 li a7, SYS_kill
 350:	4899                	li	a7,6
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exec>:
.global exec
exec:
 li a7, SYS_exec
 358:	489d                	li	a7,7
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <open>:
.global open
open:
 li a7, SYS_open
 360:	48bd                	li	a7,15
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 368:	48c5                	li	a7,17
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 370:	48c9                	li	a7,18
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 378:	48a1                	li	a7,8
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <link>:
.global link
link:
 li a7, SYS_link
 380:	48cd                	li	a7,19
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 388:	48d1                	li	a7,20
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 390:	48a5                	li	a7,9
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <dup>:
.global dup
dup:
 li a7, SYS_dup
 398:	48a9                	li	a7,10
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a0:	48ad                	li	a7,11
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a8:	48b1                	li	a7,12
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3b0:	48b5                	li	a7,13
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b8:	48b9                	li	a7,14
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c0:	1101                	addi	sp,sp,-32
 3c2:	ec06                	sd	ra,24(sp)
 3c4:	e822                	sd	s0,16(sp)
 3c6:	1000                	addi	s0,sp,32
 3c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3cc:	4605                	li	a2,1
 3ce:	fef40593          	addi	a1,s0,-17
 3d2:	f6fff0ef          	jal	340 <write>
}
 3d6:	60e2                	ld	ra,24(sp)
 3d8:	6442                	ld	s0,16(sp)
 3da:	6105                	addi	sp,sp,32
 3dc:	8082                	ret

00000000000003de <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3de:	715d                	addi	sp,sp,-80
 3e0:	e486                	sd	ra,72(sp)
 3e2:	e0a2                	sd	s0,64(sp)
 3e4:	fc26                	sd	s1,56(sp)
 3e6:	0880                	addi	s0,sp,80
 3e8:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ea:	c299                	beqz	a3,3f0 <printint+0x12>
 3ec:	0805c963          	bltz	a1,47e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f0:	2581                	sext.w	a1,a1
  neg = 0;
 3f2:	4881                	li	a7,0
 3f4:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3f8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fa:	2601                	sext.w	a2,a2
 3fc:	00000517          	auipc	a0,0x0
 400:	58450513          	addi	a0,a0,1412 # 980 <digits>
 404:	883a                	mv	a6,a4
 406:	2705                	addiw	a4,a4,1
 408:	02c5f7bb          	remuw	a5,a1,a2
 40c:	1782                	slli	a5,a5,0x20
 40e:	9381                	srli	a5,a5,0x20
 410:	97aa                	add	a5,a5,a0
 412:	0007c783          	lbu	a5,0(a5)
 416:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41a:	0005879b          	sext.w	a5,a1
 41e:	02c5d5bb          	divuw	a1,a1,a2
 422:	0685                	addi	a3,a3,1
 424:	fec7f0e3          	bgeu	a5,a2,404 <printint+0x26>
  if(neg)
 428:	00088c63          	beqz	a7,440 <printint+0x62>
    buf[i++] = '-';
 42c:	fd070793          	addi	a5,a4,-48
 430:	00878733          	add	a4,a5,s0
 434:	02d00793          	li	a5,45
 438:	fef70423          	sb	a5,-24(a4)
 43c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 440:	02e05a63          	blez	a4,474 <printint+0x96>
 444:	f84a                	sd	s2,48(sp)
 446:	f44e                	sd	s3,40(sp)
 448:	fb840793          	addi	a5,s0,-72
 44c:	00e78933          	add	s2,a5,a4
 450:	fff78993          	addi	s3,a5,-1
 454:	99ba                	add	s3,s3,a4
 456:	377d                	addiw	a4,a4,-1
 458:	1702                	slli	a4,a4,0x20
 45a:	9301                	srli	a4,a4,0x20
 45c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 460:	fff94583          	lbu	a1,-1(s2)
 464:	8526                	mv	a0,s1
 466:	f5bff0ef          	jal	3c0 <putc>
  while(--i >= 0)
 46a:	197d                	addi	s2,s2,-1
 46c:	ff391ae3          	bne	s2,s3,460 <printint+0x82>
 470:	7942                	ld	s2,48(sp)
 472:	79a2                	ld	s3,40(sp)
}
 474:	60a6                	ld	ra,72(sp)
 476:	6406                	ld	s0,64(sp)
 478:	74e2                	ld	s1,56(sp)
 47a:	6161                	addi	sp,sp,80
 47c:	8082                	ret
    x = -xx;
 47e:	40b005bb          	negw	a1,a1
    neg = 1;
 482:	4885                	li	a7,1
    x = -xx;
 484:	bf85                	j	3f4 <printint+0x16>

0000000000000486 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 486:	711d                	addi	sp,sp,-96
 488:	ec86                	sd	ra,88(sp)
 48a:	e8a2                	sd	s0,80(sp)
 48c:	e0ca                	sd	s2,64(sp)
 48e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 490:	0005c903          	lbu	s2,0(a1)
 494:	28090663          	beqz	s2,720 <vprintf+0x29a>
 498:	e4a6                	sd	s1,72(sp)
 49a:	fc4e                	sd	s3,56(sp)
 49c:	f852                	sd	s4,48(sp)
 49e:	f456                	sd	s5,40(sp)
 4a0:	f05a                	sd	s6,32(sp)
 4a2:	ec5e                	sd	s7,24(sp)
 4a4:	e862                	sd	s8,16(sp)
 4a6:	e466                	sd	s9,8(sp)
 4a8:	8b2a                	mv	s6,a0
 4aa:	8a2e                	mv	s4,a1
 4ac:	8bb2                	mv	s7,a2
  state = 0;
 4ae:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4b0:	4481                	li	s1,0
 4b2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4bc:	06c00c93          	li	s9,108
 4c0:	a005                	j	4e0 <vprintf+0x5a>
        putc(fd, c0);
 4c2:	85ca                	mv	a1,s2
 4c4:	855a                	mv	a0,s6
 4c6:	efbff0ef          	jal	3c0 <putc>
 4ca:	a019                	j	4d0 <vprintf+0x4a>
    } else if(state == '%'){
 4cc:	03598263          	beq	s3,s5,4f0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4d0:	2485                	addiw	s1,s1,1
 4d2:	8726                	mv	a4,s1
 4d4:	009a07b3          	add	a5,s4,s1
 4d8:	0007c903          	lbu	s2,0(a5)
 4dc:	22090a63          	beqz	s2,710 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4e0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4e4:	fe0994e3          	bnez	s3,4cc <vprintf+0x46>
      if(c0 == '%'){
 4e8:	fd579de3          	bne	a5,s5,4c2 <vprintf+0x3c>
        state = '%';
 4ec:	89be                	mv	s3,a5
 4ee:	b7cd                	j	4d0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4f0:	00ea06b3          	add	a3,s4,a4
 4f4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4f8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4fa:	c681                	beqz	a3,502 <vprintf+0x7c>
 4fc:	9752                	add	a4,a4,s4
 4fe:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 502:	05878363          	beq	a5,s8,548 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 506:	05978d63          	beq	a5,s9,560 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 50a:	07500713          	li	a4,117
 50e:	0ee78763          	beq	a5,a4,5fc <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 512:	07800713          	li	a4,120
 516:	12e78963          	beq	a5,a4,648 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 51a:	07000713          	li	a4,112
 51e:	14e78e63          	beq	a5,a4,67a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 522:	06300713          	li	a4,99
 526:	18e78e63          	beq	a5,a4,6c2 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 52a:	07300713          	li	a4,115
 52e:	1ae78463          	beq	a5,a4,6d6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 532:	02500713          	li	a4,37
 536:	04e79563          	bne	a5,a4,580 <vprintf+0xfa>
        putc(fd, '%');
 53a:	02500593          	li	a1,37
 53e:	855a                	mv	a0,s6
 540:	e81ff0ef          	jal	3c0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 544:	4981                	li	s3,0
 546:	b769                	j	4d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 548:	008b8913          	addi	s2,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000ba583          	lw	a1,0(s7)
 554:	855a                	mv	a0,s6
 556:	e89ff0ef          	jal	3de <printint>
 55a:	8bca                	mv	s7,s2
      state = 0;
 55c:	4981                	li	s3,0
 55e:	bf8d                	j	4d0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 560:	06400793          	li	a5,100
 564:	02f68963          	beq	a3,a5,596 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 568:	06c00793          	li	a5,108
 56c:	04f68263          	beq	a3,a5,5b0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 570:	07500793          	li	a5,117
 574:	0af68063          	beq	a3,a5,614 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 578:	07800793          	li	a5,120
 57c:	0ef68263          	beq	a3,a5,660 <vprintf+0x1da>
        putc(fd, '%');
 580:	02500593          	li	a1,37
 584:	855a                	mv	a0,s6
 586:	e3bff0ef          	jal	3c0 <putc>
        putc(fd, c0);
 58a:	85ca                	mv	a1,s2
 58c:	855a                	mv	a0,s6
 58e:	e33ff0ef          	jal	3c0 <putc>
      state = 0;
 592:	4981                	li	s3,0
 594:	bf35                	j	4d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	008b8913          	addi	s2,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000bb583          	ld	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	e3bff0ef          	jal	3de <printint>
        i += 1;
 5a8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
        i += 1;
 5ae:	b70d                	j	4d0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b0:	06400793          	li	a5,100
 5b4:	02f60763          	beq	a2,a5,5e2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5b8:	07500793          	li	a5,117
 5bc:	06f60963          	beq	a2,a5,62e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5c0:	07800793          	li	a5,120
 5c4:	faf61ee3          	bne	a2,a5,580 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4641                	li	a2,16
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e09ff0ef          	jal	3de <printint>
        i += 2;
 5da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
        i += 2;
 5e0:	bdc5                	j	4d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000bb583          	ld	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	defff0ef          	jal	3de <printint>
        i += 2;
 5f4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f6:	8bca                	mv	s7,s2
      state = 0;
 5f8:	4981                	li	s3,0
        i += 2;
 5fa:	bdd9                	j	4d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5fc:	008b8913          	addi	s2,s7,8
 600:	4681                	li	a3,0
 602:	4629                	li	a2,10
 604:	000be583          	lwu	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	dd5ff0ef          	jal	3de <printint>
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	bd7d                	j	4d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b8913          	addi	s2,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000bb583          	ld	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	dbdff0ef          	jal	3de <printint>
        i += 1;
 626:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
        i += 1;
 62c:	b555                	j	4d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	008b8913          	addi	s2,s7,8
 632:	4681                	li	a3,0
 634:	4629                	li	a2,10
 636:	000bb583          	ld	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	da3ff0ef          	jal	3de <printint>
        i += 2;
 640:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 642:	8bca                	mv	s7,s2
      state = 0;
 644:	4981                	li	s3,0
        i += 2;
 646:	b569                	j	4d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 648:	008b8913          	addi	s2,s7,8
 64c:	4681                	li	a3,0
 64e:	4641                	li	a2,16
 650:	000be583          	lwu	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	d89ff0ef          	jal	3de <printint>
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bd8d                	j	4d0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	008b8913          	addi	s2,s7,8
 664:	4681                	li	a3,0
 666:	4641                	li	a2,16
 668:	000bb583          	ld	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	d71ff0ef          	jal	3de <printint>
        i += 1;
 672:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 674:	8bca                	mv	s7,s2
      state = 0;
 676:	4981                	li	s3,0
        i += 1;
 678:	bda1                	j	4d0 <vprintf+0x4a>
 67a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 67c:	008b8d13          	addi	s10,s7,8
 680:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 684:	03000593          	li	a1,48
 688:	855a                	mv	a0,s6
 68a:	d37ff0ef          	jal	3c0 <putc>
  putc(fd, 'x');
 68e:	07800593          	li	a1,120
 692:	855a                	mv	a0,s6
 694:	d2dff0ef          	jal	3c0 <putc>
 698:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69a:	00000b97          	auipc	s7,0x0
 69e:	2e6b8b93          	addi	s7,s7,742 # 980 <digits>
 6a2:	03c9d793          	srli	a5,s3,0x3c
 6a6:	97de                	add	a5,a5,s7
 6a8:	0007c583          	lbu	a1,0(a5)
 6ac:	855a                	mv	a0,s6
 6ae:	d13ff0ef          	jal	3c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b2:	0992                	slli	s3,s3,0x4
 6b4:	397d                	addiw	s2,s2,-1
 6b6:	fe0916e3          	bnez	s2,6a2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6ba:	8bea                	mv	s7,s10
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	6d02                	ld	s10,0(sp)
 6c0:	bd01                	j	4d0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	000bc583          	lbu	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	cf5ff0ef          	jal	3c0 <putc>
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bbf5                	j	4d0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6d6:	008b8993          	addi	s3,s7,8
 6da:	000bb903          	ld	s2,0(s7)
 6de:	00090f63          	beqz	s2,6fc <vprintf+0x276>
        for(; *s; s++)
 6e2:	00094583          	lbu	a1,0(s2)
 6e6:	c195                	beqz	a1,70a <vprintf+0x284>
          putc(fd, *s);
 6e8:	855a                	mv	a0,s6
 6ea:	cd7ff0ef          	jal	3c0 <putc>
        for(; *s; s++)
 6ee:	0905                	addi	s2,s2,1
 6f0:	00094583          	lbu	a1,0(s2)
 6f4:	f9f5                	bnez	a1,6e8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6f6:	8bce                	mv	s7,s3
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	bbd9                	j	4d0 <vprintf+0x4a>
          s = "(null)";
 6fc:	00000917          	auipc	s2,0x0
 700:	27c90913          	addi	s2,s2,636 # 978 <malloc+0x170>
        for(; *s; s++)
 704:	02800593          	li	a1,40
 708:	b7c5                	j	6e8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 70a:	8bce                	mv	s7,s3
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b3c9                	j	4d0 <vprintf+0x4a>
 710:	64a6                	ld	s1,72(sp)
 712:	79e2                	ld	s3,56(sp)
 714:	7a42                	ld	s4,48(sp)
 716:	7aa2                	ld	s5,40(sp)
 718:	7b02                	ld	s6,32(sp)
 71a:	6be2                	ld	s7,24(sp)
 71c:	6c42                	ld	s8,16(sp)
 71e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 720:	60e6                	ld	ra,88(sp)
 722:	6446                	ld	s0,80(sp)
 724:	6906                	ld	s2,64(sp)
 726:	6125                	addi	sp,sp,96
 728:	8082                	ret

000000000000072a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 72a:	715d                	addi	sp,sp,-80
 72c:	ec06                	sd	ra,24(sp)
 72e:	e822                	sd	s0,16(sp)
 730:	1000                	addi	s0,sp,32
 732:	e010                	sd	a2,0(s0)
 734:	e414                	sd	a3,8(s0)
 736:	e818                	sd	a4,16(s0)
 738:	ec1c                	sd	a5,24(s0)
 73a:	03043023          	sd	a6,32(s0)
 73e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 742:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 746:	8622                	mv	a2,s0
 748:	d3fff0ef          	jal	486 <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6161                	addi	sp,sp,80
 752:	8082                	ret

0000000000000754 <printf>:

void
printf(const char *fmt, ...)
{
 754:	711d                	addi	sp,sp,-96
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e40c                	sd	a1,8(s0)
 75e:	e810                	sd	a2,16(s0)
 760:	ec14                	sd	a3,24(s0)
 762:	f018                	sd	a4,32(s0)
 764:	f41c                	sd	a5,40(s0)
 766:	03043823          	sd	a6,48(s0)
 76a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	00840613          	addi	a2,s0,8
 772:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 776:	85aa                	mv	a1,a0
 778:	4505                	li	a0,1
 77a:	d0dff0ef          	jal	486 <vprintf>
}
 77e:	60e2                	ld	ra,24(sp)
 780:	6442                	ld	s0,16(sp)
 782:	6125                	addi	sp,sp,96
 784:	8082                	ret

0000000000000786 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 786:	1141                	addi	sp,sp,-16
 788:	e422                	sd	s0,8(sp)
 78a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	00001797          	auipc	a5,0x1
 794:	8707b783          	ld	a5,-1936(a5) # 1000 <freep>
 798:	a02d                	j	7c2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 79a:	4618                	lw	a4,8(a2)
 79c:	9f2d                	addw	a4,a4,a1
 79e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a2:	6398                	ld	a4,0(a5)
 7a4:	6310                	ld	a2,0(a4)
 7a6:	a83d                	j	7e4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a8:	ff852703          	lw	a4,-8(a0)
 7ac:	9f31                	addw	a4,a4,a2
 7ae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7b0:	ff053683          	ld	a3,-16(a0)
 7b4:	a091                	j	7f8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b6:	6398                	ld	a4,0(a5)
 7b8:	00e7e463          	bltu	a5,a4,7c0 <free+0x3a>
 7bc:	00e6ea63          	bltu	a3,a4,7d0 <free+0x4a>
{
 7c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c2:	fed7fae3          	bgeu	a5,a3,7b6 <free+0x30>
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e6e463          	bltu	a3,a4,7d0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	fee7eae3          	bltu	a5,a4,7c0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7d0:	ff852583          	lw	a1,-8(a0)
 7d4:	6390                	ld	a2,0(a5)
 7d6:	02059813          	slli	a6,a1,0x20
 7da:	01c85713          	srli	a4,a6,0x1c
 7de:	9736                	add	a4,a4,a3
 7e0:	fae60de3          	beq	a2,a4,79a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7e8:	4790                	lw	a2,8(a5)
 7ea:	02061593          	slli	a1,a2,0x20
 7ee:	01c5d713          	srli	a4,a1,0x1c
 7f2:	973e                	add	a4,a4,a5
 7f4:	fae68ae3          	beq	a3,a4,7a8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7f8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fa:	00001717          	auipc	a4,0x1
 7fe:	80f73323          	sd	a5,-2042(a4) # 1000 <freep>
}
 802:	6422                	ld	s0,8(sp)
 804:	0141                	addi	sp,sp,16
 806:	8082                	ret

0000000000000808 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 808:	7139                	addi	sp,sp,-64
 80a:	fc06                	sd	ra,56(sp)
 80c:	f822                	sd	s0,48(sp)
 80e:	f426                	sd	s1,40(sp)
 810:	ec4e                	sd	s3,24(sp)
 812:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 814:	02051493          	slli	s1,a0,0x20
 818:	9081                	srli	s1,s1,0x20
 81a:	04bd                	addi	s1,s1,15
 81c:	8091                	srli	s1,s1,0x4
 81e:	0014899b          	addiw	s3,s1,1
 822:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 824:	00000517          	auipc	a0,0x0
 828:	7dc53503          	ld	a0,2012(a0) # 1000 <freep>
 82c:	c915                	beqz	a0,860 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 830:	4798                	lw	a4,8(a5)
 832:	08977a63          	bgeu	a4,s1,8c6 <malloc+0xbe>
 836:	f04a                	sd	s2,32(sp)
 838:	e852                	sd	s4,16(sp)
 83a:	e456                	sd	s5,8(sp)
 83c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 83e:	8a4e                	mv	s4,s3
 840:	0009871b          	sext.w	a4,s3
 844:	6685                	lui	a3,0x1
 846:	00d77363          	bgeu	a4,a3,84c <malloc+0x44>
 84a:	6a05                	lui	s4,0x1
 84c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 850:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 854:	00000917          	auipc	s2,0x0
 858:	7ac90913          	addi	s2,s2,1964 # 1000 <freep>
  if(p == SBRK_ERROR)
 85c:	5afd                	li	s5,-1
 85e:	a081                	j	89e <malloc+0x96>
 860:	f04a                	sd	s2,32(sp)
 862:	e852                	sd	s4,16(sp)
 864:	e456                	sd	s5,8(sp)
 866:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 868:	00001797          	auipc	a5,0x1
 86c:	9a078793          	addi	a5,a5,-1632 # 1208 <base>
 870:	00000717          	auipc	a4,0x0
 874:	78f73823          	sd	a5,1936(a4) # 1000 <freep>
 878:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87e:	b7c1                	j	83e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	e118                	sd	a4,0(a0)
 884:	a8a9                	j	8de <malloc+0xd6>
  hp->s.size = nu;
 886:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88a:	0541                	addi	a0,a0,16
 88c:	efbff0ef          	jal	786 <free>
  return freep;
 890:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 894:	c12d                	beqz	a0,8f6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 896:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 898:	4798                	lw	a4,8(a5)
 89a:	02977263          	bgeu	a4,s1,8be <malloc+0xb6>
    if(p == freep)
 89e:	00093703          	ld	a4,0(s2)
 8a2:	853e                	mv	a0,a5
 8a4:	fef719e3          	bne	a4,a5,896 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8a8:	8552                	mv	a0,s4
 8aa:	a43ff0ef          	jal	2ec <sbrk>
  if(p == SBRK_ERROR)
 8ae:	fd551ce3          	bne	a0,s5,886 <malloc+0x7e>
        return 0;
 8b2:	4501                	li	a0,0
 8b4:	7902                	ld	s2,32(sp)
 8b6:	6a42                	ld	s4,16(sp)
 8b8:	6aa2                	ld	s5,8(sp)
 8ba:	6b02                	ld	s6,0(sp)
 8bc:	a03d                	j	8ea <malloc+0xe2>
 8be:	7902                	ld	s2,32(sp)
 8c0:	6a42                	ld	s4,16(sp)
 8c2:	6aa2                	ld	s5,8(sp)
 8c4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c6:	fae48de3          	beq	s1,a4,880 <malloc+0x78>
        p->s.size -= nunits;
 8ca:	4137073b          	subw	a4,a4,s3
 8ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d0:	02071693          	slli	a3,a4,0x20
 8d4:	01c6d713          	srli	a4,a3,0x1c
 8d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8de:	00000717          	auipc	a4,0x0
 8e2:	72a73123          	sd	a0,1826(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e6:	01078513          	addi	a0,a5,16
  }
}
 8ea:	70e2                	ld	ra,56(sp)
 8ec:	7442                	ld	s0,48(sp)
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	69e2                	ld	s3,24(sp)
 8f2:	6121                	addi	sp,sp,64
 8f4:	8082                	ret
 8f6:	7902                	ld	s2,32(sp)
 8f8:	6a42                	ld	s4,16(sp)
 8fa:	6aa2                	ld	s5,8(sp)
 8fc:	6b02                	ld	s6,0(sp)
 8fe:	b7f5                	j	8ea <malloc+0xe2>
