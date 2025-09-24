
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	96a78793          	addi	a5,a5,-1686 # 980 <malloc+0x12a>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	92450513          	addi	a0,a0,-1756 # 950 <malloc+0xfa>
  34:	76e000ef          	jal	7a2 <printf>
  memset(data, 'a', sizeof(data));
  38:	20000613          	li	a2,512
  3c:	06100593          	li	a1,97
  40:	dd040513          	addi	a0,s0,-560
  44:	118000ef          	jal	15c <memset>

  for(i = 0; i < 4; i++)
  48:	4481                	li	s1,0
  4a:	4911                	li	s2,4
    if(fork() > 0)
  4c:	31a000ef          	jal	366 <fork>
  50:	00a04563          	bgtz	a0,5a <main+0x5a>
  for(i = 0; i < 4; i++)
  54:	2485                	addiw	s1,s1,1
  56:	ff249be3          	bne	s1,s2,4c <main+0x4c>
      break;

  printf("write %d\n", i);
  5a:	85a6                	mv	a1,s1
  5c:	00001517          	auipc	a0,0x1
  60:	90c50513          	addi	a0,a0,-1780 # 968 <malloc+0x112>
  64:	73e000ef          	jal	7a2 <printf>

  path[8] += i;
  68:	fd844783          	lbu	a5,-40(s0)
  6c:	9fa5                	addw	a5,a5,s1
  6e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  72:	20200593          	li	a1,514
  76:	fd040513          	addi	a0,s0,-48
  7a:	334000ef          	jal	3ae <open>
  7e:	892a                	mv	s2,a0
  80:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  82:	20000613          	li	a2,512
  86:	dd040593          	addi	a1,s0,-560
  8a:	854a                	mv	a0,s2
  8c:	302000ef          	jal	38e <write>
  for(i = 0; i < 20; i++)
  90:	34fd                	addiw	s1,s1,-1
  92:	f8e5                	bnez	s1,82 <main+0x82>
  close(fd);
  94:	854a                	mv	a0,s2
  96:	300000ef          	jal	396 <close>

  printf("read\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	8de50513          	addi	a0,a0,-1826 # 978 <malloc+0x122>
  a2:	700000ef          	jal	7a2 <printf>

  fd = open(path, O_RDONLY);
  a6:	4581                	li	a1,0
  a8:	fd040513          	addi	a0,s0,-48
  ac:	302000ef          	jal	3ae <open>
  b0:	892a                	mv	s2,a0
  b2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  b4:	20000613          	li	a2,512
  b8:	dd040593          	addi	a1,s0,-560
  bc:	854a                	mv	a0,s2
  be:	2c8000ef          	jal	386 <read>
  for (i = 0; i < 20; i++)
  c2:	34fd                	addiw	s1,s1,-1
  c4:	f8e5                	bnez	s1,b4 <main+0xb4>
  close(fd);
  c6:	854a                	mv	a0,s2
  c8:	2ce000ef          	jal	396 <close>

  wait(0);
  cc:	4501                	li	a0,0
  ce:	2a8000ef          	jal	376 <wait>

  exit(0);
  d2:	4501                	li	a0,0
  d4:	29a000ef          	jal	36e <exit>

00000000000000d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  extern int main();
  main();
  e0:	f21ff0ef          	jal	0 <main>
  exit(0);
  e4:	4501                	li	a0,0
  e6:	288000ef          	jal	36e <exit>

00000000000000ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f0:	87aa                	mv	a5,a0
  f2:	0585                	addi	a1,a1,1
  f4:	0785                	addi	a5,a5,1
  f6:	fff5c703          	lbu	a4,-1(a1)
  fa:	fee78fa3          	sb	a4,-1(a5)
  fe:	fb75                	bnez	a4,f2 <strcpy+0x8>
    ;
  return os;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x1e>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x1e>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strlen>:

uint
strlen(const char *s)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf91                	beqz	a5,158 <strlen+0x26>
 13e:	0505                	addi	a0,a0,1
 140:	87aa                	mv	a5,a0
 142:	86be                	mv	a3,a5
 144:	0785                	addi	a5,a5,1
 146:	fff7c703          	lbu	a4,-1(a5)
 14a:	ff65                	bnez	a4,142 <strlen+0x10>
 14c:	40a6853b          	subw	a0,a3,a0
 150:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  for(n = 0; s[n]; n++)
 158:	4501                	li	a0,0
 15a:	bfe5                	j	152 <strlen+0x20>

000000000000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 162:	ca19                	beqz	a2,178 <memset+0x1c>
 164:	87aa                	mv	a5,a0
 166:	1602                	slli	a2,a2,0x20
 168:	9201                	srli	a2,a2,0x20
 16a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 172:	0785                	addi	a5,a5,1
 174:	fee79de3          	bne	a5,a4,16e <memset+0x12>
  }
  return dst;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strchr>:

char*
strchr(const char *s, char c)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  for(; *s; s++)
 184:	00054783          	lbu	a5,0(a0)
 188:	cb99                	beqz	a5,19e <strchr+0x20>
    if(*s == c)
 18a:	00f58763          	beq	a1,a5,198 <strchr+0x1a>
  for(; *s; s++)
 18e:	0505                	addi	a0,a0,1
 190:	00054783          	lbu	a5,0(a0)
 194:	fbfd                	bnez	a5,18a <strchr+0xc>
      return (char*)s;
  return 0;
 196:	4501                	li	a0,0
}
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret
  return 0;
 19e:	4501                	li	a0,0
 1a0:	bfe5                	j	198 <strchr+0x1a>

00000000000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	711d                	addi	sp,sp,-96
 1a4:	ec86                	sd	ra,88(sp)
 1a6:	e8a2                	sd	s0,80(sp)
 1a8:	e4a6                	sd	s1,72(sp)
 1aa:	e0ca                	sd	s2,64(sp)
 1ac:	fc4e                	sd	s3,56(sp)
 1ae:	f852                	sd	s4,48(sp)
 1b0:	f456                	sd	s5,40(sp)
 1b2:	f05a                	sd	s6,32(sp)
 1b4:	ec5e                	sd	s7,24(sp)
 1b6:	1080                	addi	s0,sp,96
 1b8:	8baa                	mv	s7,a0
 1ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bc:	892a                	mv	s2,a0
 1be:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c0:	4aa9                	li	s5,10
 1c2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c4:	89a6                	mv	s3,s1
 1c6:	2485                	addiw	s1,s1,1
 1c8:	0344d663          	bge	s1,s4,1f4 <gets+0x52>
    cc = read(0, &c, 1);
 1cc:	4605                	li	a2,1
 1ce:	faf40593          	addi	a1,s0,-81
 1d2:	4501                	li	a0,0
 1d4:	1b2000ef          	jal	386 <read>
    if(cc < 1)
 1d8:	00a05e63          	blez	a0,1f4 <gets+0x52>
    buf[i++] = c;
 1dc:	faf44783          	lbu	a5,-81(s0)
 1e0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e4:	01578763          	beq	a5,s5,1f2 <gets+0x50>
 1e8:	0905                	addi	s2,s2,1
 1ea:	fd679de3          	bne	a5,s6,1c4 <gets+0x22>
    buf[i++] = c;
 1ee:	89a6                	mv	s3,s1
 1f0:	a011                	j	1f4 <gets+0x52>
 1f2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f4:	99de                	add	s3,s3,s7
 1f6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1fa:	855e                	mv	a0,s7
 1fc:	60e6                	ld	ra,88(sp)
 1fe:	6446                	ld	s0,80(sp)
 200:	64a6                	ld	s1,72(sp)
 202:	6906                	ld	s2,64(sp)
 204:	79e2                	ld	s3,56(sp)
 206:	7a42                	ld	s4,48(sp)
 208:	7aa2                	ld	s5,40(sp)
 20a:	7b02                	ld	s6,32(sp)
 20c:	6be2                	ld	s7,24(sp)
 20e:	6125                	addi	sp,sp,96
 210:	8082                	ret

0000000000000212 <stat>:

int
stat(const char *n, struct stat *st)
{
 212:	1101                	addi	sp,sp,-32
 214:	ec06                	sd	ra,24(sp)
 216:	e822                	sd	s0,16(sp)
 218:	e04a                	sd	s2,0(sp)
 21a:	1000                	addi	s0,sp,32
 21c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21e:	4581                	li	a1,0
 220:	18e000ef          	jal	3ae <open>
  if(fd < 0)
 224:	02054263          	bltz	a0,248 <stat+0x36>
 228:	e426                	sd	s1,8(sp)
 22a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22c:	85ca                	mv	a1,s2
 22e:	198000ef          	jal	3c6 <fstat>
 232:	892a                	mv	s2,a0
  close(fd);
 234:	8526                	mv	a0,s1
 236:	160000ef          	jal	396 <close>
  return r;
 23a:	64a2                	ld	s1,8(sp)
}
 23c:	854a                	mv	a0,s2
 23e:	60e2                	ld	ra,24(sp)
 240:	6442                	ld	s0,16(sp)
 242:	6902                	ld	s2,0(sp)
 244:	6105                	addi	sp,sp,32
 246:	8082                	ret
    return -1;
 248:	597d                	li	s2,-1
 24a:	bfcd                	j	23c <stat+0x2a>

000000000000024c <atoi>:

int
atoi(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	00054683          	lbu	a3,0(a0)
 256:	fd06879b          	addiw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	4625                	li	a2,9
 260:	02f66863          	bltu	a2,a5,290 <atoi+0x44>
 264:	872a                	mv	a4,a0
  n = 0;
 266:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 268:	0705                	addi	a4,a4,1
 26a:	0025179b          	slliw	a5,a0,0x2
 26e:	9fa9                	addw	a5,a5,a0
 270:	0017979b          	slliw	a5,a5,0x1
 274:	9fb5                	addw	a5,a5,a3
 276:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27a:	00074683          	lbu	a3,0(a4)
 27e:	fd06879b          	addiw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	fef671e3          	bgeu	a2,a5,268 <atoi+0x1c>
  return n;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  n = 0;
 290:	4501                	li	a0,0
 292:	bfe5                	j	28a <atoi+0x3e>

0000000000000294 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29a:	02b57463          	bgeu	a0,a1,2c2 <memmove+0x2e>
    while(n-- > 0)
 29e:	00c05f63          	blez	a2,2bc <memmove+0x28>
 2a2:	1602                	slli	a2,a2,0x20
 2a4:	9201                	srli	a2,a2,0x20
 2a6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2aa:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ac:	0585                	addi	a1,a1,1
 2ae:	0705                	addi	a4,a4,1
 2b0:	fff5c683          	lbu	a3,-1(a1)
 2b4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b8:	fef71ae3          	bne	a4,a5,2ac <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
    dst += n;
 2c2:	00c50733          	add	a4,a0,a2
    src += n;
 2c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c8:	fec05ae3          	blez	a2,2bc <memmove+0x28>
 2cc:	fff6079b          	addiw	a5,a2,-1
 2d0:	1782                	slli	a5,a5,0x20
 2d2:	9381                	srli	a5,a5,0x20
 2d4:	fff7c793          	not	a5,a5
 2d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2da:	15fd                	addi	a1,a1,-1
 2dc:	177d                	addi	a4,a4,-1
 2de:	0005c683          	lbu	a3,0(a1)
 2e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e6:	fee79ae3          	bne	a5,a4,2da <memmove+0x46>
 2ea:	bfc9                	j	2bc <memmove+0x28>

00000000000002ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f2:	ca05                	beqz	a2,322 <memcmp+0x36>
 2f4:	fff6069b          	addiw	a3,a2,-1
 2f8:	1682                	slli	a3,a3,0x20
 2fa:	9281                	srli	a3,a3,0x20
 2fc:	0685                	addi	a3,a3,1
 2fe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 300:	00054783          	lbu	a5,0(a0)
 304:	0005c703          	lbu	a4,0(a1)
 308:	00e79863          	bne	a5,a4,318 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 30c:	0505                	addi	a0,a0,1
    p2++;
 30e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 310:	fed518e3          	bne	a0,a3,300 <memcmp+0x14>
  }
  return 0;
 314:	4501                	li	a0,0
 316:	a019                	j	31c <memcmp+0x30>
      return *p1 - *p2;
 318:	40e7853b          	subw	a0,a5,a4
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
  return 0;
 322:	4501                	li	a0,0
 324:	bfe5                	j	31c <memcmp+0x30>

0000000000000326 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32e:	f67ff0ef          	jal	294 <memmove>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <sbrk>:

char *
sbrk(int n) {
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 342:	4585                	li	a1,1
 344:	0b2000ef          	jal	3f6 <sys_sbrk>
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret

0000000000000350 <sbrklazy>:

char *
sbrklazy(int n) {
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 358:	4589                	li	a1,2
 35a:	09c000ef          	jal	3f6 <sys_sbrk>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 366:	4885                	li	a7,1
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exit>:
.global exit
exit:
 li a7, SYS_exit
 36e:	4889                	li	a7,2
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <wait>:
.global wait
wait:
 li a7, SYS_wait
 376:	488d                	li	a7,3
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 37e:	4891                	li	a7,4
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <read>:
.global read
read:
 li a7, SYS_read
 386:	4895                	li	a7,5
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <write>:
.global write
write:
 li a7, SYS_write
 38e:	48c1                	li	a7,16
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <close>:
.global close
close:
 li a7, SYS_close
 396:	48d5                	li	a7,21
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <kill>:
.global kill
kill:
 li a7, SYS_kill
 39e:	4899                	li	a7,6
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a6:	489d                	li	a7,7
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <open>:
.global open
open:
 li a7, SYS_open
 3ae:	48bd                	li	a7,15
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b6:	48c5                	li	a7,17
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3be:	48c9                	li	a7,18
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c6:	48a1                	li	a7,8
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <link>:
.global link
link:
 li a7, SYS_link
 3ce:	48cd                	li	a7,19
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d6:	48d1                	li	a7,20
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3de:	48a5                	li	a7,9
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e6:	48a9                	li	a7,10
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ee:	48ad                	li	a7,11
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3f6:	48b1                	li	a7,12
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <pause>:
.global pause
pause:
 li a7, SYS_pause
 3fe:	48b5                	li	a7,13
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 406:	48b9                	li	a7,14
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40e:	1101                	addi	sp,sp,-32
 410:	ec06                	sd	ra,24(sp)
 412:	e822                	sd	s0,16(sp)
 414:	1000                	addi	s0,sp,32
 416:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41a:	4605                	li	a2,1
 41c:	fef40593          	addi	a1,s0,-17
 420:	f6fff0ef          	jal	38e <write>
}
 424:	60e2                	ld	ra,24(sp)
 426:	6442                	ld	s0,16(sp)
 428:	6105                	addi	sp,sp,32
 42a:	8082                	ret

000000000000042c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 42c:	715d                	addi	sp,sp,-80
 42e:	e486                	sd	ra,72(sp)
 430:	e0a2                	sd	s0,64(sp)
 432:	fc26                	sd	s1,56(sp)
 434:	0880                	addi	s0,sp,80
 436:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 438:	c299                	beqz	a3,43e <printint+0x12>
 43a:	0805c963          	bltz	a1,4cc <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43e:	2581                	sext.w	a1,a1
  neg = 0;
 440:	4881                	li	a7,0
 442:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 446:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 448:	2601                	sext.w	a2,a2
 44a:	00000517          	auipc	a0,0x0
 44e:	54e50513          	addi	a0,a0,1358 # 998 <digits>
 452:	883a                	mv	a6,a4
 454:	2705                	addiw	a4,a4,1
 456:	02c5f7bb          	remuw	a5,a1,a2
 45a:	1782                	slli	a5,a5,0x20
 45c:	9381                	srli	a5,a5,0x20
 45e:	97aa                	add	a5,a5,a0
 460:	0007c783          	lbu	a5,0(a5)
 464:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 468:	0005879b          	sext.w	a5,a1
 46c:	02c5d5bb          	divuw	a1,a1,a2
 470:	0685                	addi	a3,a3,1
 472:	fec7f0e3          	bgeu	a5,a2,452 <printint+0x26>
  if(neg)
 476:	00088c63          	beqz	a7,48e <printint+0x62>
    buf[i++] = '-';
 47a:	fd070793          	addi	a5,a4,-48
 47e:	00878733          	add	a4,a5,s0
 482:	02d00793          	li	a5,45
 486:	fef70423          	sb	a5,-24(a4)
 48a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 48e:	02e05a63          	blez	a4,4c2 <printint+0x96>
 492:	f84a                	sd	s2,48(sp)
 494:	f44e                	sd	s3,40(sp)
 496:	fb840793          	addi	a5,s0,-72
 49a:	00e78933          	add	s2,a5,a4
 49e:	fff78993          	addi	s3,a5,-1
 4a2:	99ba                	add	s3,s3,a4
 4a4:	377d                	addiw	a4,a4,-1
 4a6:	1702                	slli	a4,a4,0x20
 4a8:	9301                	srli	a4,a4,0x20
 4aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ae:	fff94583          	lbu	a1,-1(s2)
 4b2:	8526                	mv	a0,s1
 4b4:	f5bff0ef          	jal	40e <putc>
  while(--i >= 0)
 4b8:	197d                	addi	s2,s2,-1
 4ba:	ff391ae3          	bne	s2,s3,4ae <printint+0x82>
 4be:	7942                	ld	s2,48(sp)
 4c0:	79a2                	ld	s3,40(sp)
}
 4c2:	60a6                	ld	ra,72(sp)
 4c4:	6406                	ld	s0,64(sp)
 4c6:	74e2                	ld	s1,56(sp)
 4c8:	6161                	addi	sp,sp,80
 4ca:	8082                	ret
    x = -xx;
 4cc:	40b005bb          	negw	a1,a1
    neg = 1;
 4d0:	4885                	li	a7,1
    x = -xx;
 4d2:	bf85                	j	442 <printint+0x16>

00000000000004d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d4:	711d                	addi	sp,sp,-96
 4d6:	ec86                	sd	ra,88(sp)
 4d8:	e8a2                	sd	s0,80(sp)
 4da:	e0ca                	sd	s2,64(sp)
 4dc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4de:	0005c903          	lbu	s2,0(a1)
 4e2:	28090663          	beqz	s2,76e <vprintf+0x29a>
 4e6:	e4a6                	sd	s1,72(sp)
 4e8:	fc4e                	sd	s3,56(sp)
 4ea:	f852                	sd	s4,48(sp)
 4ec:	f456                	sd	s5,40(sp)
 4ee:	f05a                	sd	s6,32(sp)
 4f0:	ec5e                	sd	s7,24(sp)
 4f2:	e862                	sd	s8,16(sp)
 4f4:	e466                	sd	s9,8(sp)
 4f6:	8b2a                	mv	s6,a0
 4f8:	8a2e                	mv	s4,a1
 4fa:	8bb2                	mv	s7,a2
  state = 0;
 4fc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4fe:	4481                	li	s1,0
 500:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 502:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 506:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50a:	06c00c93          	li	s9,108
 50e:	a005                	j	52e <vprintf+0x5a>
        putc(fd, c0);
 510:	85ca                	mv	a1,s2
 512:	855a                	mv	a0,s6
 514:	efbff0ef          	jal	40e <putc>
 518:	a019                	j	51e <vprintf+0x4a>
    } else if(state == '%'){
 51a:	03598263          	beq	s3,s5,53e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 51e:	2485                	addiw	s1,s1,1
 520:	8726                	mv	a4,s1
 522:	009a07b3          	add	a5,s4,s1
 526:	0007c903          	lbu	s2,0(a5)
 52a:	22090a63          	beqz	s2,75e <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 52e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 532:	fe0994e3          	bnez	s3,51a <vprintf+0x46>
      if(c0 == '%'){
 536:	fd579de3          	bne	a5,s5,510 <vprintf+0x3c>
        state = '%';
 53a:	89be                	mv	s3,a5
 53c:	b7cd                	j	51e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 53e:	00ea06b3          	add	a3,s4,a4
 542:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 546:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 548:	c681                	beqz	a3,550 <vprintf+0x7c>
 54a:	9752                	add	a4,a4,s4
 54c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 550:	05878363          	beq	a5,s8,596 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 554:	05978d63          	beq	a5,s9,5ae <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 558:	07500713          	li	a4,117
 55c:	0ee78763          	beq	a5,a4,64a <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 560:	07800713          	li	a4,120
 564:	12e78963          	beq	a5,a4,696 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 568:	07000713          	li	a4,112
 56c:	14e78e63          	beq	a5,a4,6c8 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 570:	06300713          	li	a4,99
 574:	18e78e63          	beq	a5,a4,710 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 578:	07300713          	li	a4,115
 57c:	1ae78463          	beq	a5,a4,724 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 580:	02500713          	li	a4,37
 584:	04e79563          	bne	a5,a4,5ce <vprintf+0xfa>
        putc(fd, '%');
 588:	02500593          	li	a1,37
 58c:	855a                	mv	a0,s6
 58e:	e81ff0ef          	jal	40e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 592:	4981                	li	s3,0
 594:	b769                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 596:	008b8913          	addi	s2,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	e89ff0ef          	jal	42c <printint>
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bf8d                	j	51e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5ae:	06400793          	li	a5,100
 5b2:	02f68963          	beq	a3,a5,5e4 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b6:	06c00793          	li	a5,108
 5ba:	04f68263          	beq	a3,a5,5fe <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5be:	07500793          	li	a5,117
 5c2:	0af68063          	beq	a3,a5,662 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5c6:	07800793          	li	a5,120
 5ca:	0ef68263          	beq	a3,a5,6ae <vprintf+0x1da>
        putc(fd, '%');
 5ce:	02500593          	li	a1,37
 5d2:	855a                	mv	a0,s6
 5d4:	e3bff0ef          	jal	40e <putc>
        putc(fd, c0);
 5d8:	85ca                	mv	a1,s2
 5da:	855a                	mv	a0,s6
 5dc:	e33ff0ef          	jal	40e <putc>
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bf35                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000bb583          	ld	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e3bff0ef          	jal	42c <printint>
        i += 1;
 5f6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
        i += 1;
 5fc:	b70d                	j	51e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fe:	06400793          	li	a5,100
 602:	02f60763          	beq	a2,a5,630 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 606:	07500793          	li	a5,117
 60a:	06f60963          	beq	a2,a5,67c <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 60e:	07800793          	li	a5,120
 612:	faf61ee3          	bne	a2,a5,5ce <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	008b8913          	addi	s2,s7,8
 61a:	4681                	li	a3,0
 61c:	4641                	li	a2,16
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e09ff0ef          	jal	42c <printint>
        i += 2;
 628:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
        i += 2;
 62e:	bdc5                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	008b8913          	addi	s2,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	defff0ef          	jal	42c <printint>
        i += 2;
 642:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	bdd9                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 64a:	008b8913          	addi	s2,s7,8
 64e:	4681                	li	a3,0
 650:	4629                	li	a2,10
 652:	000be583          	lwu	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	dd5ff0ef          	jal	42c <printint>
 65c:	8bca                	mv	s7,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	bd7d                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	008b8913          	addi	s2,s7,8
 666:	4681                	li	a3,0
 668:	4629                	li	a2,10
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	dbdff0ef          	jal	42c <printint>
        i += 1;
 674:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
        i += 1;
 67a:	b555                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b8913          	addi	s2,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	da3ff0ef          	jal	42c <printint>
        i += 2;
 68e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 2;
 694:	b569                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000be583          	lwu	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	d89ff0ef          	jal	42c <printint>
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bd8d                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4641                	li	a2,16
 6b6:	000bb583          	ld	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	d71ff0ef          	jal	42c <printint>
        i += 1;
 6c0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
        i += 1;
 6c6:	bda1                	j	51e <vprintf+0x4a>
 6c8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ca:	008b8d13          	addi	s10,s7,8
 6ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6d2:	03000593          	li	a1,48
 6d6:	855a                	mv	a0,s6
 6d8:	d37ff0ef          	jal	40e <putc>
  putc(fd, 'x');
 6dc:	07800593          	li	a1,120
 6e0:	855a                	mv	a0,s6
 6e2:	d2dff0ef          	jal	40e <putc>
 6e6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e8:	00000b97          	auipc	s7,0x0
 6ec:	2b0b8b93          	addi	s7,s7,688 # 998 <digits>
 6f0:	03c9d793          	srli	a5,s3,0x3c
 6f4:	97de                	add	a5,a5,s7
 6f6:	0007c583          	lbu	a1,0(a5)
 6fa:	855a                	mv	a0,s6
 6fc:	d13ff0ef          	jal	40e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 700:	0992                	slli	s3,s3,0x4
 702:	397d                	addiw	s2,s2,-1
 704:	fe0916e3          	bnez	s2,6f0 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 708:	8bea                	mv	s7,s10
      state = 0;
 70a:	4981                	li	s3,0
 70c:	6d02                	ld	s10,0(sp)
 70e:	bd01                	j	51e <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 710:	008b8913          	addi	s2,s7,8
 714:	000bc583          	lbu	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	cf5ff0ef          	jal	40e <putc>
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
 722:	bbf5                	j	51e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 724:	008b8993          	addi	s3,s7,8
 728:	000bb903          	ld	s2,0(s7)
 72c:	00090f63          	beqz	s2,74a <vprintf+0x276>
        for(; *s; s++)
 730:	00094583          	lbu	a1,0(s2)
 734:	c195                	beqz	a1,758 <vprintf+0x284>
          putc(fd, *s);
 736:	855a                	mv	a0,s6
 738:	cd7ff0ef          	jal	40e <putc>
        for(; *s; s++)
 73c:	0905                	addi	s2,s2,1
 73e:	00094583          	lbu	a1,0(s2)
 742:	f9f5                	bnez	a1,736 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 744:	8bce                	mv	s7,s3
      state = 0;
 746:	4981                	li	s3,0
 748:	bbd9                	j	51e <vprintf+0x4a>
          s = "(null)";
 74a:	00000917          	auipc	s2,0x0
 74e:	24690913          	addi	s2,s2,582 # 990 <malloc+0x13a>
        for(; *s; s++)
 752:	02800593          	li	a1,40
 756:	b7c5                	j	736 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 758:	8bce                	mv	s7,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b3c9                	j	51e <vprintf+0x4a>
 75e:	64a6                	ld	s1,72(sp)
 760:	79e2                	ld	s3,56(sp)
 762:	7a42                	ld	s4,48(sp)
 764:	7aa2                	ld	s5,40(sp)
 766:	7b02                	ld	s6,32(sp)
 768:	6be2                	ld	s7,24(sp)
 76a:	6c42                	ld	s8,16(sp)
 76c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 76e:	60e6                	ld	ra,88(sp)
 770:	6446                	ld	s0,80(sp)
 772:	6906                	ld	s2,64(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret

0000000000000778 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 778:	715d                	addi	sp,sp,-80
 77a:	ec06                	sd	ra,24(sp)
 77c:	e822                	sd	s0,16(sp)
 77e:	1000                	addi	s0,sp,32
 780:	e010                	sd	a2,0(s0)
 782:	e414                	sd	a3,8(s0)
 784:	e818                	sd	a4,16(s0)
 786:	ec1c                	sd	a5,24(s0)
 788:	03043023          	sd	a6,32(s0)
 78c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 794:	8622                	mv	a2,s0
 796:	d3fff0ef          	jal	4d4 <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6161                	addi	sp,sp,80
 7a0:	8082                	ret

00000000000007a2 <printf>:

void
printf(const char *fmt, ...)
{
 7a2:	711d                	addi	sp,sp,-96
 7a4:	ec06                	sd	ra,24(sp)
 7a6:	e822                	sd	s0,16(sp)
 7a8:	1000                	addi	s0,sp,32
 7aa:	e40c                	sd	a1,8(s0)
 7ac:	e810                	sd	a2,16(s0)
 7ae:	ec14                	sd	a3,24(s0)
 7b0:	f018                	sd	a4,32(s0)
 7b2:	f41c                	sd	a5,40(s0)
 7b4:	03043823          	sd	a6,48(s0)
 7b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7bc:	00840613          	addi	a2,s0,8
 7c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c4:	85aa                	mv	a1,a0
 7c6:	4505                	li	a0,1
 7c8:	d0dff0ef          	jal	4d4 <vprintf>
}
 7cc:	60e2                	ld	ra,24(sp)
 7ce:	6442                	ld	s0,16(sp)
 7d0:	6125                	addi	sp,sp,96
 7d2:	8082                	ret

00000000000007d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d4:	1141                	addi	sp,sp,-16
 7d6:	e422                	sd	s0,8(sp)
 7d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	00001797          	auipc	a5,0x1
 7e2:	8227b783          	ld	a5,-2014(a5) # 1000 <freep>
 7e6:	a02d                	j	810 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e8:	4618                	lw	a4,8(a2)
 7ea:	9f2d                	addw	a4,a4,a1
 7ec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f0:	6398                	ld	a4,0(a5)
 7f2:	6310                	ld	a2,0(a4)
 7f4:	a83d                	j	832 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f6:	ff852703          	lw	a4,-8(a0)
 7fa:	9f31                	addw	a4,a4,a2
 7fc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7fe:	ff053683          	ld	a3,-16(a0)
 802:	a091                	j	846 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	6398                	ld	a4,0(a5)
 806:	00e7e463          	bltu	a5,a4,80e <free+0x3a>
 80a:	00e6ea63          	bltu	a3,a4,81e <free+0x4a>
{
 80e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	fed7fae3          	bgeu	a5,a3,804 <free+0x30>
 814:	6398                	ld	a4,0(a5)
 816:	00e6e463          	bltu	a3,a4,81e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	fee7eae3          	bltu	a5,a4,80e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 81e:	ff852583          	lw	a1,-8(a0)
 822:	6390                	ld	a2,0(a5)
 824:	02059813          	slli	a6,a1,0x20
 828:	01c85713          	srli	a4,a6,0x1c
 82c:	9736                	add	a4,a4,a3
 82e:	fae60de3          	beq	a2,a4,7e8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 832:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 836:	4790                	lw	a2,8(a5)
 838:	02061593          	slli	a1,a2,0x20
 83c:	01c5d713          	srli	a4,a1,0x1c
 840:	973e                	add	a4,a4,a5
 842:	fae68ae3          	beq	a3,a4,7f6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 846:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 848:	00000717          	auipc	a4,0x0
 84c:	7af73c23          	sd	a5,1976(a4) # 1000 <freep>
}
 850:	6422                	ld	s0,8(sp)
 852:	0141                	addi	sp,sp,16
 854:	8082                	ret

0000000000000856 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 856:	7139                	addi	sp,sp,-64
 858:	fc06                	sd	ra,56(sp)
 85a:	f822                	sd	s0,48(sp)
 85c:	f426                	sd	s1,40(sp)
 85e:	ec4e                	sd	s3,24(sp)
 860:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	02051493          	slli	s1,a0,0x20
 866:	9081                	srli	s1,s1,0x20
 868:	04bd                	addi	s1,s1,15
 86a:	8091                	srli	s1,s1,0x4
 86c:	0014899b          	addiw	s3,s1,1
 870:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 872:	00000517          	auipc	a0,0x0
 876:	78e53503          	ld	a0,1934(a0) # 1000 <freep>
 87a:	c915                	beqz	a0,8ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87e:	4798                	lw	a4,8(a5)
 880:	08977a63          	bgeu	a4,s1,914 <malloc+0xbe>
 884:	f04a                	sd	s2,32(sp)
 886:	e852                	sd	s4,16(sp)
 888:	e456                	sd	s5,8(sp)
 88a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 88c:	8a4e                	mv	s4,s3
 88e:	0009871b          	sext.w	a4,s3
 892:	6685                	lui	a3,0x1
 894:	00d77363          	bgeu	a4,a3,89a <malloc+0x44>
 898:	6a05                	lui	s4,0x1
 89a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a2:	00000917          	auipc	s2,0x0
 8a6:	75e90913          	addi	s2,s2,1886 # 1000 <freep>
  if(p == SBRK_ERROR)
 8aa:	5afd                	li	s5,-1
 8ac:	a081                	j	8ec <malloc+0x96>
 8ae:	f04a                	sd	s2,32(sp)
 8b0:	e852                	sd	s4,16(sp)
 8b2:	e456                	sd	s5,8(sp)
 8b4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b6:	00000797          	auipc	a5,0x0
 8ba:	75a78793          	addi	a5,a5,1882 # 1010 <base>
 8be:	00000717          	auipc	a4,0x0
 8c2:	74f73123          	sd	a5,1858(a4) # 1000 <freep>
 8c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8cc:	b7c1                	j	88c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ce:	6398                	ld	a4,0(a5)
 8d0:	e118                	sd	a4,0(a0)
 8d2:	a8a9                	j	92c <malloc+0xd6>
  hp->s.size = nu;
 8d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d8:	0541                	addi	a0,a0,16
 8da:	efbff0ef          	jal	7d4 <free>
  return freep;
 8de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e2:	c12d                	beqz	a0,944 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e6:	4798                	lw	a4,8(a5)
 8e8:	02977263          	bgeu	a4,s1,90c <malloc+0xb6>
    if(p == freep)
 8ec:	00093703          	ld	a4,0(s2)
 8f0:	853e                	mv	a0,a5
 8f2:	fef719e3          	bne	a4,a5,8e4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8f6:	8552                	mv	a0,s4
 8f8:	a43ff0ef          	jal	33a <sbrk>
  if(p == SBRK_ERROR)
 8fc:	fd551ce3          	bne	a0,s5,8d4 <malloc+0x7e>
        return 0;
 900:	4501                	li	a0,0
 902:	7902                	ld	s2,32(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	a03d                	j	938 <malloc+0xe2>
 90c:	7902                	ld	s2,32(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 914:	fae48de3          	beq	s1,a4,8ce <malloc+0x78>
        p->s.size -= nunits;
 918:	4137073b          	subw	a4,a4,s3
 91c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91e:	02071693          	slli	a3,a4,0x20
 922:	01c6d713          	srli	a4,a3,0x1c
 926:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 928:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92c:	00000717          	auipc	a4,0x0
 930:	6ca73a23          	sd	a0,1748(a4) # 1000 <freep>
      return (void*)(p + 1);
 934:	01078513          	addi	a0,a5,16
  }
}
 938:	70e2                	ld	ra,56(sp)
 93a:	7442                	ld	s0,48(sp)
 93c:	74a2                	ld	s1,40(sp)
 93e:	69e2                	ld	s3,24(sp)
 940:	6121                	addi	sp,sp,64
 942:	8082                	ret
 944:	7902                	ld	s2,32(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
 94c:	b7f5                	j	938 <malloc+0xe2>
