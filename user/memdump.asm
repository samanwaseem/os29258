
user/_memdump:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

void memdump(char *fmt, char *data);

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	21313423          	sd	s3,520(sp)
  18:	1c00                	addi	s0,sp,560
  if(argc == 1){
  1a:	4785                	li	a5,1
  1c:	00f50e63          	beq	a0,a5,38 <main+0x38>
    printf("Example 4:\n");
    memdump("pihcS", (char*) &example);
    
    printf("Example 5:\n");
    memdump("sccccc", (char*) &example);
  } else if(argc == 2){
  20:	4789                	li	a5,2
  22:	08f50863          	beq	a0,a5,b2 <main+0xb2>
        break;
      n += nn;
    }
    memdump(argv[1], data);
  } else {
    printf("Usage: memdump [format]\n");
  26:	00001517          	auipc	a0,0x1
  2a:	9ba50513          	addi	a0,a0,-1606 # 9e0 <malloc+0x164>
  2e:	79a000ef          	jal	7c8 <printf>
    exit(1);
  32:	4505                	li	a0,1
  34:	360000ef          	jal	394 <exit>
    printf("Example 1:\n");
  38:	00001517          	auipc	a0,0x1
  3c:	94850513          	addi	a0,a0,-1720 # 980 <malloc+0x104>
  40:	788000ef          	jal	7c8 <printf>
    printf("Example 2:\n");
  44:	00001517          	auipc	a0,0x1
  48:	94c50513          	addi	a0,a0,-1716 # 990 <malloc+0x114>
  4c:	77c000ef          	jal	7c8 <printf>
    printf("Example 3:\n");
  50:	00001517          	auipc	a0,0x1
  54:	95050513          	addi	a0,a0,-1712 # 9a0 <malloc+0x124>
  58:	770000ef          	jal	7c8 <printf>
    example.ptr = "hello";
  5c:	00001797          	auipc	a5,0x1
  60:	95478793          	addi	a5,a5,-1708 # 9b0 <malloc+0x134>
  64:	dcf43823          	sd	a5,-560(s0)
    example.num1 = 1819438967;
  68:	6c7277b7          	lui	a5,0x6c727
  6c:	f7778793          	addi	a5,a5,-137 # 6c726f77 <base+0x6c725f67>
  70:	dcf42c23          	sw	a5,-552(s0)
    example.num2 = 100;
  74:	06400793          	li	a5,100
  78:	dcf41e23          	sh	a5,-548(s0)
    example.byte = 'z';
  7c:	07a00793          	li	a5,122
  80:	dcf40f23          	sb	a5,-546(s0)
    strcpy(example.bytes, "xyzzy");
  84:	00001597          	auipc	a1,0x1
  88:	93458593          	addi	a1,a1,-1740 # 9b8 <malloc+0x13c>
  8c:	ddf40513          	addi	a0,s0,-545
  90:	080000ef          	jal	110 <strcpy>
    printf("Example 4:\n");
  94:	00001517          	auipc	a0,0x1
  98:	92c50513          	addi	a0,a0,-1748 # 9c0 <malloc+0x144>
  9c:	72c000ef          	jal	7c8 <printf>
    printf("Example 5:\n");
  a0:	00001517          	auipc	a0,0x1
  a4:	93050513          	addi	a0,a0,-1744 # 9d0 <malloc+0x154>
  a8:	720000ef          	jal	7c8 <printf>
  }
  exit(0);
  ac:	4501                	li	a0,0
  ae:	2e6000ef          	jal	394 <exit>
    memset(data, '\0', sizeof(data));
  b2:	20000613          	li	a2,512
  b6:	4581                	li	a1,0
  b8:	dd040513          	addi	a0,s0,-560
  bc:	0c6000ef          	jal	182 <memset>
    int n = 0;
  c0:	4481                	li	s1,0
    while(n < sizeof(data)){
  c2:	4601                	li	a2,0
      int nn = read(0, data + n, sizeof(data) - n);
  c4:	20000913          	li	s2,512
    while(n < sizeof(data)){
  c8:	1ff00993          	li	s3,511
      int nn = read(0, data + n, sizeof(data) - n);
  cc:	40c9063b          	subw	a2,s2,a2
  d0:	dd040793          	addi	a5,s0,-560
  d4:	009785b3          	add	a1,a5,s1
  d8:	4501                	li	a0,0
  da:	2d2000ef          	jal	3ac <read>
      if(nn <= 0)
  de:	fca057e3          	blez	a0,ac <main+0xac>
      n += nn;
  e2:	0095063b          	addw	a2,a0,s1
  e6:	0006049b          	sext.w	s1,a2
    while(n < sizeof(data)){
  ea:	8626                	mv	a2,s1
  ec:	fe99f0e3          	bgeu	s3,s1,cc <main+0xcc>
  f0:	bf75                	j	ac <main+0xac>

00000000000000f2 <memdump>:
}

void
memdump(char *fmt, char *data)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  // Your code here.

}
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret

00000000000000fe <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  fe:	1141                	addi	sp,sp,-16
 100:	e406                	sd	ra,8(sp)
 102:	e022                	sd	s0,0(sp)
 104:	0800                	addi	s0,sp,16
  extern int main();
  main();
 106:	efbff0ef          	jal	0 <main>
  exit(0);
 10a:	4501                	li	a0,0
 10c:	288000ef          	jal	394 <exit>

0000000000000110 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 116:	87aa                	mv	a5,a0
 118:	0585                	addi	a1,a1,1
 11a:	0785                	addi	a5,a5,1
 11c:	fff5c703          	lbu	a4,-1(a1)
 120:	fee78fa3          	sb	a4,-1(a5)
 124:	fb75                	bnez	a4,118 <strcpy+0x8>
    ;
  return os;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb91                	beqz	a5,14a <strcmp+0x1e>
 138:	0005c703          	lbu	a4,0(a1)
 13c:	00f71763          	bne	a4,a5,14a <strcmp+0x1e>
    p++, q++;
 140:	0505                	addi	a0,a0,1
 142:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	fbe5                	bnez	a5,138 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14a:	0005c503          	lbu	a0,0(a1)
}
 14e:	40a7853b          	subw	a0,a5,a0
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x26>
 164:	0505                	addi	a0,a0,1
 166:	87aa                	mv	a5,a0
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x10>
 172:	40a6853b          	subw	a0,a3,a0
 176:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for(n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfe5                	j	178 <strlen+0x20>

0000000000000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 188:	ca19                	beqz	a2,19e <memset+0x1c>
 18a:	87aa                	mv	a5,a0
 18c:	1602                	slli	a2,a2,0x20
 18e:	9201                	srli	a2,a2,0x20
 190:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 194:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 198:	0785                	addi	a5,a5,1
 19a:	fee79de3          	bne	a5,a4,194 <memset+0x12>
  }
  return dst;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb99                	beqz	a5,1c4 <strchr+0x20>
    if(*s == c)
 1b0:	00f58763          	beq	a1,a5,1be <strchr+0x1a>
  for(; *s; s++)
 1b4:	0505                	addi	a0,a0,1
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	fbfd                	bnez	a5,1b0 <strchr+0xc>
      return (char*)s;
  return 0;
 1bc:	4501                	li	a0,0
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret
  return 0;
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strchr+0x1a>

00000000000001c8 <gets>:

char*
gets(char *buf, int max)
{
 1c8:	711d                	addi	sp,sp,-96
 1ca:	ec86                	sd	ra,88(sp)
 1cc:	e8a2                	sd	s0,80(sp)
 1ce:	e4a6                	sd	s1,72(sp)
 1d0:	e0ca                	sd	s2,64(sp)
 1d2:	fc4e                	sd	s3,56(sp)
 1d4:	f852                	sd	s4,48(sp)
 1d6:	f456                	sd	s5,40(sp)
 1d8:	f05a                	sd	s6,32(sp)
 1da:	ec5e                	sd	s7,24(sp)
 1dc:	1080                	addi	s0,sp,96
 1de:	8baa                	mv	s7,a0
 1e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	892a                	mv	s2,a0
 1e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e6:	4aa9                	li	s5,10
 1e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ea:	89a6                	mv	s3,s1
 1ec:	2485                	addiw	s1,s1,1
 1ee:	0344d663          	bge	s1,s4,21a <gets+0x52>
    cc = read(0, &c, 1);
 1f2:	4605                	li	a2,1
 1f4:	faf40593          	addi	a1,s0,-81
 1f8:	4501                	li	a0,0
 1fa:	1b2000ef          	jal	3ac <read>
    if(cc < 1)
 1fe:	00a05e63          	blez	a0,21a <gets+0x52>
    buf[i++] = c;
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20a:	01578763          	beq	a5,s5,218 <gets+0x50>
 20e:	0905                	addi	s2,s2,1
 210:	fd679de3          	bne	a5,s6,1ea <gets+0x22>
    buf[i++] = c;
 214:	89a6                	mv	s3,s1
 216:	a011                	j	21a <gets+0x52>
 218:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21a:	99de                	add	s3,s3,s7
 21c:	00098023          	sb	zero,0(s3)
  return buf;
}
 220:	855e                	mv	a0,s7
 222:	60e6                	ld	ra,88(sp)
 224:	6446                	ld	s0,80(sp)
 226:	64a6                	ld	s1,72(sp)
 228:	6906                	ld	s2,64(sp)
 22a:	79e2                	ld	s3,56(sp)
 22c:	7a42                	ld	s4,48(sp)
 22e:	7aa2                	ld	s5,40(sp)
 230:	7b02                	ld	s6,32(sp)
 232:	6be2                	ld	s7,24(sp)
 234:	6125                	addi	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	1101                	addi	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e04a                	sd	s2,0(sp)
 240:	1000                	addi	s0,sp,32
 242:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	4581                	li	a1,0
 246:	18e000ef          	jal	3d4 <open>
  if(fd < 0)
 24a:	02054263          	bltz	a0,26e <stat+0x36>
 24e:	e426                	sd	s1,8(sp)
 250:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 252:	85ca                	mv	a1,s2
 254:	198000ef          	jal	3ec <fstat>
 258:	892a                	mv	s2,a0
  close(fd);
 25a:	8526                	mv	a0,s1
 25c:	160000ef          	jal	3bc <close>
  return r;
 260:	64a2                	ld	s1,8(sp)
}
 262:	854a                	mv	a0,s2
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	6902                	ld	s2,0(sp)
 26a:	6105                	addi	sp,sp,32
 26c:	8082                	ret
    return -1;
 26e:	597d                	li	s2,-1
 270:	bfcd                	j	262 <stat+0x2a>

0000000000000272 <atoi>:

int
atoi(const char *s)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 278:	00054683          	lbu	a3,0(a0)
 27c:	fd06879b          	addiw	a5,a3,-48
 280:	0ff7f793          	zext.b	a5,a5
 284:	4625                	li	a2,9
 286:	02f66863          	bltu	a2,a5,2b6 <atoi+0x44>
 28a:	872a                	mv	a4,a0
  n = 0;
 28c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 28e:	0705                	addi	a4,a4,1
 290:	0025179b          	slliw	a5,a0,0x2
 294:	9fa9                	addw	a5,a5,a0
 296:	0017979b          	slliw	a5,a5,0x1
 29a:	9fb5                	addw	a5,a5,a3
 29c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a0:	00074683          	lbu	a3,0(a4)
 2a4:	fd06879b          	addiw	a5,a3,-48
 2a8:	0ff7f793          	zext.b	a5,a5
 2ac:	fef671e3          	bgeu	a2,a5,28e <atoi+0x1c>
  return n;
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  n = 0;
 2b6:	4501                	li	a0,0
 2b8:	bfe5                	j	2b0 <atoi+0x3e>

00000000000002ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c0:	02b57463          	bgeu	a0,a1,2e8 <memmove+0x2e>
    while(n-- > 0)
 2c4:	00c05f63          	blez	a2,2e2 <memmove+0x28>
 2c8:	1602                	slli	a2,a2,0x20
 2ca:	9201                	srli	a2,a2,0x20
 2cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d2:	0585                	addi	a1,a1,1
 2d4:	0705                	addi	a4,a4,1
 2d6:	fff5c683          	lbu	a3,-1(a1)
 2da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2de:	fef71ae3          	bne	a4,a5,2d2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
    dst += n;
 2e8:	00c50733          	add	a4,a0,a2
    src += n;
 2ec:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ee:	fec05ae3          	blez	a2,2e2 <memmove+0x28>
 2f2:	fff6079b          	addiw	a5,a2,-1
 2f6:	1782                	slli	a5,a5,0x20
 2f8:	9381                	srli	a5,a5,0x20
 2fa:	fff7c793          	not	a5,a5
 2fe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 300:	15fd                	addi	a1,a1,-1
 302:	177d                	addi	a4,a4,-1
 304:	0005c683          	lbu	a3,0(a1)
 308:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 30c:	fee79ae3          	bne	a5,a4,300 <memmove+0x46>
 310:	bfc9                	j	2e2 <memmove+0x28>

0000000000000312 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 318:	ca05                	beqz	a2,348 <memcmp+0x36>
 31a:	fff6069b          	addiw	a3,a2,-1
 31e:	1682                	slli	a3,a3,0x20
 320:	9281                	srli	a3,a3,0x20
 322:	0685                	addi	a3,a3,1
 324:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 326:	00054783          	lbu	a5,0(a0)
 32a:	0005c703          	lbu	a4,0(a1)
 32e:	00e79863          	bne	a5,a4,33e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 332:	0505                	addi	a0,a0,1
    p2++;
 334:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 336:	fed518e3          	bne	a0,a3,326 <memcmp+0x14>
  }
  return 0;
 33a:	4501                	li	a0,0
 33c:	a019                	j	342 <memcmp+0x30>
      return *p1 - *p2;
 33e:	40e7853b          	subw	a0,a5,a4
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
  return 0;
 348:	4501                	li	a0,0
 34a:	bfe5                	j	342 <memcmp+0x30>

000000000000034c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e406                	sd	ra,8(sp)
 350:	e022                	sd	s0,0(sp)
 352:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 354:	f67ff0ef          	jal	2ba <memmove>
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <sbrk>:

char *
sbrk(int n) {
 360:	1141                	addi	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 368:	4585                	li	a1,1
 36a:	0b2000ef          	jal	41c <sys_sbrk>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <sbrklazy>:

char *
sbrklazy(int n) {
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 37e:	4589                	li	a1,2
 380:	09c000ef          	jal	41c <sys_sbrk>
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38c:	4885                	li	a7,1
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <exit>:
.global exit
exit:
 li a7, SYS_exit
 394:	4889                	li	a7,2
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <wait>:
.global wait
wait:
 li a7, SYS_wait
 39c:	488d                	li	a7,3
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a4:	4891                	li	a7,4
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <read>:
.global read
read:
 li a7, SYS_read
 3ac:	4895                	li	a7,5
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <write>:
.global write
write:
 li a7, SYS_write
 3b4:	48c1                	li	a7,16
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <close>:
.global close
close:
 li a7, SYS_close
 3bc:	48d5                	li	a7,21
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c4:	4899                	li	a7,6
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3cc:	489d                	li	a7,7
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <open>:
.global open
open:
 li a7, SYS_open
 3d4:	48bd                	li	a7,15
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3dc:	48c5                	li	a7,17
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e4:	48c9                	li	a7,18
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ec:	48a1                	li	a7,8
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <link>:
.global link
link:
 li a7, SYS_link
 3f4:	48cd                	li	a7,19
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fc:	48d1                	li	a7,20
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 404:	48a5                	li	a7,9
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <dup>:
.global dup
dup:
 li a7, SYS_dup
 40c:	48a9                	li	a7,10
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 414:	48ad                	li	a7,11
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 41c:	48b1                	li	a7,12
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <pause>:
.global pause
pause:
 li a7, SYS_pause
 424:	48b5                	li	a7,13
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42c:	48b9                	li	a7,14
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 434:	1101                	addi	sp,sp,-32
 436:	ec06                	sd	ra,24(sp)
 438:	e822                	sd	s0,16(sp)
 43a:	1000                	addi	s0,sp,32
 43c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 440:	4605                	li	a2,1
 442:	fef40593          	addi	a1,s0,-17
 446:	f6fff0ef          	jal	3b4 <write>
}
 44a:	60e2                	ld	ra,24(sp)
 44c:	6442                	ld	s0,16(sp)
 44e:	6105                	addi	sp,sp,32
 450:	8082                	ret

0000000000000452 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 452:	715d                	addi	sp,sp,-80
 454:	e486                	sd	ra,72(sp)
 456:	e0a2                	sd	s0,64(sp)
 458:	fc26                	sd	s1,56(sp)
 45a:	0880                	addi	s0,sp,80
 45c:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45e:	c299                	beqz	a3,464 <printint+0x12>
 460:	0805c963          	bltz	a1,4f2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 464:	2581                	sext.w	a1,a1
  neg = 0;
 466:	4881                	li	a7,0
 468:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 46c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 46e:	2601                	sext.w	a2,a2
 470:	00000517          	auipc	a0,0x0
 474:	59850513          	addi	a0,a0,1432 # a08 <digits>
 478:	883a                	mv	a6,a4
 47a:	2705                	addiw	a4,a4,1
 47c:	02c5f7bb          	remuw	a5,a1,a2
 480:	1782                	slli	a5,a5,0x20
 482:	9381                	srli	a5,a5,0x20
 484:	97aa                	add	a5,a5,a0
 486:	0007c783          	lbu	a5,0(a5)
 48a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 48e:	0005879b          	sext.w	a5,a1
 492:	02c5d5bb          	divuw	a1,a1,a2
 496:	0685                	addi	a3,a3,1
 498:	fec7f0e3          	bgeu	a5,a2,478 <printint+0x26>
  if(neg)
 49c:	00088c63          	beqz	a7,4b4 <printint+0x62>
    buf[i++] = '-';
 4a0:	fd070793          	addi	a5,a4,-48
 4a4:	00878733          	add	a4,a5,s0
 4a8:	02d00793          	li	a5,45
 4ac:	fef70423          	sb	a5,-24(a4)
 4b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4b4:	02e05a63          	blez	a4,4e8 <printint+0x96>
 4b8:	f84a                	sd	s2,48(sp)
 4ba:	f44e                	sd	s3,40(sp)
 4bc:	fb840793          	addi	a5,s0,-72
 4c0:	00e78933          	add	s2,a5,a4
 4c4:	fff78993          	addi	s3,a5,-1
 4c8:	99ba                	add	s3,s3,a4
 4ca:	377d                	addiw	a4,a4,-1
 4cc:	1702                	slli	a4,a4,0x20
 4ce:	9301                	srli	a4,a4,0x20
 4d0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d4:	fff94583          	lbu	a1,-1(s2)
 4d8:	8526                	mv	a0,s1
 4da:	f5bff0ef          	jal	434 <putc>
  while(--i >= 0)
 4de:	197d                	addi	s2,s2,-1
 4e0:	ff391ae3          	bne	s2,s3,4d4 <printint+0x82>
 4e4:	7942                	ld	s2,48(sp)
 4e6:	79a2                	ld	s3,40(sp)
}
 4e8:	60a6                	ld	ra,72(sp)
 4ea:	6406                	ld	s0,64(sp)
 4ec:	74e2                	ld	s1,56(sp)
 4ee:	6161                	addi	sp,sp,80
 4f0:	8082                	ret
    x = -xx;
 4f2:	40b005bb          	negw	a1,a1
    neg = 1;
 4f6:	4885                	li	a7,1
    x = -xx;
 4f8:	bf85                	j	468 <printint+0x16>

00000000000004fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fa:	711d                	addi	sp,sp,-96
 4fc:	ec86                	sd	ra,88(sp)
 4fe:	e8a2                	sd	s0,80(sp)
 500:	e0ca                	sd	s2,64(sp)
 502:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 504:	0005c903          	lbu	s2,0(a1)
 508:	28090663          	beqz	s2,794 <vprintf+0x29a>
 50c:	e4a6                	sd	s1,72(sp)
 50e:	fc4e                	sd	s3,56(sp)
 510:	f852                	sd	s4,48(sp)
 512:	f456                	sd	s5,40(sp)
 514:	f05a                	sd	s6,32(sp)
 516:	ec5e                	sd	s7,24(sp)
 518:	e862                	sd	s8,16(sp)
 51a:	e466                	sd	s9,8(sp)
 51c:	8b2a                	mv	s6,a0
 51e:	8a2e                	mv	s4,a1
 520:	8bb2                	mv	s7,a2
  state = 0;
 522:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 524:	4481                	li	s1,0
 526:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 528:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 52c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 530:	06c00c93          	li	s9,108
 534:	a005                	j	554 <vprintf+0x5a>
        putc(fd, c0);
 536:	85ca                	mv	a1,s2
 538:	855a                	mv	a0,s6
 53a:	efbff0ef          	jal	434 <putc>
 53e:	a019                	j	544 <vprintf+0x4a>
    } else if(state == '%'){
 540:	03598263          	beq	s3,s5,564 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 544:	2485                	addiw	s1,s1,1
 546:	8726                	mv	a4,s1
 548:	009a07b3          	add	a5,s4,s1
 54c:	0007c903          	lbu	s2,0(a5)
 550:	22090a63          	beqz	s2,784 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 554:	0009079b          	sext.w	a5,s2
    if(state == 0){
 558:	fe0994e3          	bnez	s3,540 <vprintf+0x46>
      if(c0 == '%'){
 55c:	fd579de3          	bne	a5,s5,536 <vprintf+0x3c>
        state = '%';
 560:	89be                	mv	s3,a5
 562:	b7cd                	j	544 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 564:	00ea06b3          	add	a3,s4,a4
 568:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 56c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 56e:	c681                	beqz	a3,576 <vprintf+0x7c>
 570:	9752                	add	a4,a4,s4
 572:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 576:	05878363          	beq	a5,s8,5bc <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 57a:	05978d63          	beq	a5,s9,5d4 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 57e:	07500713          	li	a4,117
 582:	0ee78763          	beq	a5,a4,670 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 586:	07800713          	li	a4,120
 58a:	12e78963          	beq	a5,a4,6bc <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 58e:	07000713          	li	a4,112
 592:	14e78e63          	beq	a5,a4,6ee <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 596:	06300713          	li	a4,99
 59a:	18e78e63          	beq	a5,a4,736 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 59e:	07300713          	li	a4,115
 5a2:	1ae78463          	beq	a5,a4,74a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5a6:	02500713          	li	a4,37
 5aa:	04e79563          	bne	a5,a4,5f4 <vprintf+0xfa>
        putc(fd, '%');
 5ae:	02500593          	li	a1,37
 5b2:	855a                	mv	a0,s6
 5b4:	e81ff0ef          	jal	434 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b769                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e89ff0ef          	jal	452 <printint>
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bf8d                	j	544 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5d4:	06400793          	li	a5,100
 5d8:	02f68963          	beq	a3,a5,60a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5dc:	06c00793          	li	a5,108
 5e0:	04f68263          	beq	a3,a5,624 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5e4:	07500793          	li	a5,117
 5e8:	0af68063          	beq	a3,a5,688 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5ec:	07800793          	li	a5,120
 5f0:	0ef68263          	beq	a3,a5,6d4 <vprintf+0x1da>
        putc(fd, '%');
 5f4:	02500593          	li	a1,37
 5f8:	855a                	mv	a0,s6
 5fa:	e3bff0ef          	jal	434 <putc>
        putc(fd, c0);
 5fe:	85ca                	mv	a1,s2
 600:	855a                	mv	a0,s6
 602:	e33ff0ef          	jal	434 <putc>
      state = 0;
 606:	4981                	li	s3,0
 608:	bf35                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60a:	008b8913          	addi	s2,s7,8
 60e:	4685                	li	a3,1
 610:	4629                	li	a2,10
 612:	000bb583          	ld	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e3bff0ef          	jal	452 <printint>
        i += 1;
 61c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
        i += 1;
 622:	b70d                	j	544 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 624:	06400793          	li	a5,100
 628:	02f60763          	beq	a2,a5,656 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 62c:	07500793          	li	a5,117
 630:	06f60963          	beq	a2,a5,6a2 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 634:	07800793          	li	a5,120
 638:	faf61ee3          	bne	a2,a5,5f4 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4641                	li	a2,16
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e09ff0ef          	jal	452 <printint>
        i += 2;
 64e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	bdc5                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 656:	008b8913          	addi	s2,s7,8
 65a:	4685                	li	a3,1
 65c:	4629                	li	a2,10
 65e:	000bb583          	ld	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	defff0ef          	jal	452 <printint>
        i += 2;
 668:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66a:	8bca                	mv	s7,s2
      state = 0;
 66c:	4981                	li	s3,0
        i += 2;
 66e:	bdd9                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 670:	008b8913          	addi	s2,s7,8
 674:	4681                	li	a3,0
 676:	4629                	li	a2,10
 678:	000be583          	lwu	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	dd5ff0ef          	jal	452 <printint>
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	bd7d                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	008b8913          	addi	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	dbdff0ef          	jal	452 <printint>
        i += 1;
 69a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
        i += 1;
 6a0:	b555                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a2:	008b8913          	addi	s2,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4629                	li	a2,10
 6aa:	000bb583          	ld	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	da3ff0ef          	jal	452 <printint>
        i += 2;
 6b4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
        i += 2;
 6ba:	b569                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6bc:	008b8913          	addi	s2,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000be583          	lwu	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	d89ff0ef          	jal	452 <printint>
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bd8d                	j	544 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000bb583          	ld	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	d71ff0ef          	jal	452 <printint>
        i += 1;
 6e6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
        i += 1;
 6ec:	bda1                	j	544 <vprintf+0x4a>
 6ee:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f0:	008b8d13          	addi	s10,s7,8
 6f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f8:	03000593          	li	a1,48
 6fc:	855a                	mv	a0,s6
 6fe:	d37ff0ef          	jal	434 <putc>
  putc(fd, 'x');
 702:	07800593          	li	a1,120
 706:	855a                	mv	a0,s6
 708:	d2dff0ef          	jal	434 <putc>
 70c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70e:	00000b97          	auipc	s7,0x0
 712:	2fab8b93          	addi	s7,s7,762 # a08 <digits>
 716:	03c9d793          	srli	a5,s3,0x3c
 71a:	97de                	add	a5,a5,s7
 71c:	0007c583          	lbu	a1,0(a5)
 720:	855a                	mv	a0,s6
 722:	d13ff0ef          	jal	434 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 726:	0992                	slli	s3,s3,0x4
 728:	397d                	addiw	s2,s2,-1
 72a:	fe0916e3          	bnez	s2,716 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 72e:	8bea                	mv	s7,s10
      state = 0;
 730:	4981                	li	s3,0
 732:	6d02                	ld	s10,0(sp)
 734:	bd01                	j	544 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 736:	008b8913          	addi	s2,s7,8
 73a:	000bc583          	lbu	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	cf5ff0ef          	jal	434 <putc>
 744:	8bca                	mv	s7,s2
      state = 0;
 746:	4981                	li	s3,0
 748:	bbf5                	j	544 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 74a:	008b8993          	addi	s3,s7,8
 74e:	000bb903          	ld	s2,0(s7)
 752:	00090f63          	beqz	s2,770 <vprintf+0x276>
        for(; *s; s++)
 756:	00094583          	lbu	a1,0(s2)
 75a:	c195                	beqz	a1,77e <vprintf+0x284>
          putc(fd, *s);
 75c:	855a                	mv	a0,s6
 75e:	cd7ff0ef          	jal	434 <putc>
        for(; *s; s++)
 762:	0905                	addi	s2,s2,1
 764:	00094583          	lbu	a1,0(s2)
 768:	f9f5                	bnez	a1,75c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 76a:	8bce                	mv	s7,s3
      state = 0;
 76c:	4981                	li	s3,0
 76e:	bbd9                	j	544 <vprintf+0x4a>
          s = "(null)";
 770:	00000917          	auipc	s2,0x0
 774:	29090913          	addi	s2,s2,656 # a00 <malloc+0x184>
        for(; *s; s++)
 778:	02800593          	li	a1,40
 77c:	b7c5                	j	75c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 77e:	8bce                	mv	s7,s3
      state = 0;
 780:	4981                	li	s3,0
 782:	b3c9                	j	544 <vprintf+0x4a>
 784:	64a6                	ld	s1,72(sp)
 786:	79e2                	ld	s3,56(sp)
 788:	7a42                	ld	s4,48(sp)
 78a:	7aa2                	ld	s5,40(sp)
 78c:	7b02                	ld	s6,32(sp)
 78e:	6be2                	ld	s7,24(sp)
 790:	6c42                	ld	s8,16(sp)
 792:	6ca2                	ld	s9,8(sp)
    }
  }
}
 794:	60e6                	ld	ra,88(sp)
 796:	6446                	ld	s0,80(sp)
 798:	6906                	ld	s2,64(sp)
 79a:	6125                	addi	sp,sp,96
 79c:	8082                	ret

000000000000079e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79e:	715d                	addi	sp,sp,-80
 7a0:	ec06                	sd	ra,24(sp)
 7a2:	e822                	sd	s0,16(sp)
 7a4:	1000                	addi	s0,sp,32
 7a6:	e010                	sd	a2,0(s0)
 7a8:	e414                	sd	a3,8(s0)
 7aa:	e818                	sd	a4,16(s0)
 7ac:	ec1c                	sd	a5,24(s0)
 7ae:	03043023          	sd	a6,32(s0)
 7b2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ba:	8622                	mv	a2,s0
 7bc:	d3fff0ef          	jal	4fa <vprintf>
}
 7c0:	60e2                	ld	ra,24(sp)
 7c2:	6442                	ld	s0,16(sp)
 7c4:	6161                	addi	sp,sp,80
 7c6:	8082                	ret

00000000000007c8 <printf>:

void
printf(const char *fmt, ...)
{
 7c8:	711d                	addi	sp,sp,-96
 7ca:	ec06                	sd	ra,24(sp)
 7cc:	e822                	sd	s0,16(sp)
 7ce:	1000                	addi	s0,sp,32
 7d0:	e40c                	sd	a1,8(s0)
 7d2:	e810                	sd	a2,16(s0)
 7d4:	ec14                	sd	a3,24(s0)
 7d6:	f018                	sd	a4,32(s0)
 7d8:	f41c                	sd	a5,40(s0)
 7da:	03043823          	sd	a6,48(s0)
 7de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e2:	00840613          	addi	a2,s0,8
 7e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ea:	85aa                	mv	a1,a0
 7ec:	4505                	li	a0,1
 7ee:	d0dff0ef          	jal	4fa <vprintf>
}
 7f2:	60e2                	ld	ra,24(sp)
 7f4:	6442                	ld	s0,16(sp)
 7f6:	6125                	addi	sp,sp,96
 7f8:	8082                	ret

00000000000007fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fa:	1141                	addi	sp,sp,-16
 7fc:	e422                	sd	s0,8(sp)
 7fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 800:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 804:	00000797          	auipc	a5,0x0
 808:	7fc7b783          	ld	a5,2044(a5) # 1000 <freep>
 80c:	a02d                	j	836 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 80e:	4618                	lw	a4,8(a2)
 810:	9f2d                	addw	a4,a4,a1
 812:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	6398                	ld	a4,0(a5)
 818:	6310                	ld	a2,0(a4)
 81a:	a83d                	j	858 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 81c:	ff852703          	lw	a4,-8(a0)
 820:	9f31                	addw	a4,a4,a2
 822:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 824:	ff053683          	ld	a3,-16(a0)
 828:	a091                	j	86c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82a:	6398                	ld	a4,0(a5)
 82c:	00e7e463          	bltu	a5,a4,834 <free+0x3a>
 830:	00e6ea63          	bltu	a3,a4,844 <free+0x4a>
{
 834:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	fed7fae3          	bgeu	a5,a3,82a <free+0x30>
 83a:	6398                	ld	a4,0(a5)
 83c:	00e6e463          	bltu	a3,a4,844 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	fee7eae3          	bltu	a5,a4,834 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 844:	ff852583          	lw	a1,-8(a0)
 848:	6390                	ld	a2,0(a5)
 84a:	02059813          	slli	a6,a1,0x20
 84e:	01c85713          	srli	a4,a6,0x1c
 852:	9736                	add	a4,a4,a3
 854:	fae60de3          	beq	a2,a4,80e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 85c:	4790                	lw	a2,8(a5)
 85e:	02061593          	slli	a1,a2,0x20
 862:	01c5d713          	srli	a4,a1,0x1c
 866:	973e                	add	a4,a4,a5
 868:	fae68ae3          	beq	a3,a4,81c <free+0x22>
    p->s.ptr = bp->s.ptr;
 86c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86e:	00000717          	auipc	a4,0x0
 872:	78f73923          	sd	a5,1938(a4) # 1000 <freep>
}
 876:	6422                	ld	s0,8(sp)
 878:	0141                	addi	sp,sp,16
 87a:	8082                	ret

000000000000087c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 87c:	7139                	addi	sp,sp,-64
 87e:	fc06                	sd	ra,56(sp)
 880:	f822                	sd	s0,48(sp)
 882:	f426                	sd	s1,40(sp)
 884:	ec4e                	sd	s3,24(sp)
 886:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 888:	02051493          	slli	s1,a0,0x20
 88c:	9081                	srli	s1,s1,0x20
 88e:	04bd                	addi	s1,s1,15
 890:	8091                	srli	s1,s1,0x4
 892:	0014899b          	addiw	s3,s1,1
 896:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 898:	00000517          	auipc	a0,0x0
 89c:	76853503          	ld	a0,1896(a0) # 1000 <freep>
 8a0:	c915                	beqz	a0,8d4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a4:	4798                	lw	a4,8(a5)
 8a6:	08977a63          	bgeu	a4,s1,93a <malloc+0xbe>
 8aa:	f04a                	sd	s2,32(sp)
 8ac:	e852                	sd	s4,16(sp)
 8ae:	e456                	sd	s5,8(sp)
 8b0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8b2:	8a4e                	mv	s4,s3
 8b4:	0009871b          	sext.w	a4,s3
 8b8:	6685                	lui	a3,0x1
 8ba:	00d77363          	bgeu	a4,a3,8c0 <malloc+0x44>
 8be:	6a05                	lui	s4,0x1
 8c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c8:	00000917          	auipc	s2,0x0
 8cc:	73890913          	addi	s2,s2,1848 # 1000 <freep>
  if(p == SBRK_ERROR)
 8d0:	5afd                	li	s5,-1
 8d2:	a081                	j	912 <malloc+0x96>
 8d4:	f04a                	sd	s2,32(sp)
 8d6:	e852                	sd	s4,16(sp)
 8d8:	e456                	sd	s5,8(sp)
 8da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8dc:	00000797          	auipc	a5,0x0
 8e0:	73478793          	addi	a5,a5,1844 # 1010 <base>
 8e4:	00000717          	auipc	a4,0x0
 8e8:	70f73e23          	sd	a5,1820(a4) # 1000 <freep>
 8ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f2:	b7c1                	j	8b2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8f4:	6398                	ld	a4,0(a5)
 8f6:	e118                	sd	a4,0(a0)
 8f8:	a8a9                	j	952 <malloc+0xd6>
  hp->s.size = nu;
 8fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8fe:	0541                	addi	a0,a0,16
 900:	efbff0ef          	jal	7fa <free>
  return freep;
 904:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 908:	c12d                	beqz	a0,96a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90c:	4798                	lw	a4,8(a5)
 90e:	02977263          	bgeu	a4,s1,932 <malloc+0xb6>
    if(p == freep)
 912:	00093703          	ld	a4,0(s2)
 916:	853e                	mv	a0,a5
 918:	fef719e3          	bne	a4,a5,90a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 91c:	8552                	mv	a0,s4
 91e:	a43ff0ef          	jal	360 <sbrk>
  if(p == SBRK_ERROR)
 922:	fd551ce3          	bne	a0,s5,8fa <malloc+0x7e>
        return 0;
 926:	4501                	li	a0,0
 928:	7902                	ld	s2,32(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
 930:	a03d                	j	95e <malloc+0xe2>
 932:	7902                	ld	s2,32(sp)
 934:	6a42                	ld	s4,16(sp)
 936:	6aa2                	ld	s5,8(sp)
 938:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 93a:	fae48de3          	beq	s1,a4,8f4 <malloc+0x78>
        p->s.size -= nunits;
 93e:	4137073b          	subw	a4,a4,s3
 942:	c798                	sw	a4,8(a5)
        p += p->s.size;
 944:	02071693          	slli	a3,a4,0x20
 948:	01c6d713          	srli	a4,a3,0x1c
 94c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 952:	00000717          	auipc	a4,0x0
 956:	6aa73723          	sd	a0,1710(a4) # 1000 <freep>
      return (void*)(p + 1);
 95a:	01078513          	addi	a0,a5,16
  }
}
 95e:	70e2                	ld	ra,56(sp)
 960:	7442                	ld	s0,48(sp)
 962:	74a2                	ld	s1,40(sp)
 964:	69e2                	ld	s3,24(sp)
 966:	6121                	addi	sp,sp,64
 968:	8082                	ret
 96a:	7902                	ld	s2,32(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
 972:	b7f5                	j	95e <malloc+0xe2>
