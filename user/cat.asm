
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	378000ef          	jal	398 <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	370000ef          	jal	3a0 <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	92858593          	addi	a1,a1,-1752 # 960 <malloc+0xf8>
  40:	4509                	li	a0,2
  42:	748000ef          	jal	78a <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	338000ef          	jal	380 <exit>
    }
  }
  if(n < 0){
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	addi	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	91a58593          	addi	a1,a1,-1766 # 978 <malloc+0x110>
  66:	4509                	li	a0,2
  68:	722000ef          	jal	78a <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	312000ef          	jal	380 <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	addi	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  7a:	4785                	li	a5,1
  7c:	04a7d263          	bge	a5,a0,c0 <main+0x4e>
  80:	ec26                	sd	s1,24(sp)
  82:	e84a                	sd	s2,16(sp)
  84:	e44e                	sd	s3,8(sp)
  86:	00858913          	addi	s2,a1,8
  8a:	ffe5099b          	addiw	s3,a0,-2
  8e:	02099793          	slli	a5,s3,0x20
  92:	01d7d993          	srli	s3,a5,0x1d
  96:	05c1                	addi	a1,a1,16
  98:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  9a:	4581                	li	a1,0
  9c:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a0:	320000ef          	jal	3c0 <open>
  a4:	84aa                	mv	s1,a0
  a6:	02054663          	bltz	a0,d2 <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  aa:	f57ff0ef          	jal	0 <cat>
    close(fd);
  ae:	8526                	mv	a0,s1
  b0:	2f8000ef          	jal	3a8 <close>
  for(i = 1; i < argc; i++){
  b4:	0921                	addi	s2,s2,8
  b6:	ff3912e3          	bne	s2,s3,9a <main+0x28>
  }
  exit(0);
  ba:	4501                	li	a0,0
  bc:	2c4000ef          	jal	380 <exit>
  c0:	ec26                	sd	s1,24(sp)
  c2:	e84a                	sd	s2,16(sp)
  c4:	e44e                	sd	s3,8(sp)
    cat(0);
  c6:	4501                	li	a0,0
  c8:	f39ff0ef          	jal	0 <cat>
    exit(0);
  cc:	4501                	li	a0,0
  ce:	2b2000ef          	jal	380 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  d2:	00093603          	ld	a2,0(s2)
  d6:	00001597          	auipc	a1,0x1
  da:	8ba58593          	addi	a1,a1,-1862 # 990 <malloc+0x128>
  de:	4509                	li	a0,2
  e0:	6aa000ef          	jal	78a <fprintf>
      exit(1);
  e4:	4505                	li	a0,1
  e6:	29a000ef          	jal	380 <exit>

00000000000000ea <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e406                	sd	ra,8(sp)
  ee:	e022                	sd	s0,0(sp)
  f0:	0800                	addi	s0,sp,16
  extern int main();
  main();
  f2:	f81ff0ef          	jal	72 <main>
  exit(0);
  f6:	4501                	li	a0,0
  f8:	288000ef          	jal	380 <exit>

00000000000000fc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 102:	87aa                	mv	a5,a0
 104:	0585                	addi	a1,a1,1
 106:	0785                	addi	a5,a5,1
 108:	fff5c703          	lbu	a4,-1(a1)
 10c:	fee78fa3          	sb	a4,-1(a5)
 110:	fb75                	bnez	a4,104 <strcpy+0x8>
    ;
  return os;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb91                	beqz	a5,136 <strcmp+0x1e>
 124:	0005c703          	lbu	a4,0(a1)
 128:	00f71763          	bne	a4,a5,136 <strcmp+0x1e>
    p++, q++;
 12c:	0505                	addi	a0,a0,1
 12e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	fbe5                	bnez	a5,124 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 136:	0005c503          	lbu	a0,0(a1)
}
 13a:	40a7853b          	subw	a0,a5,a0
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret

0000000000000144 <strlen>:

uint
strlen(const char *s)
{
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 14a:	00054783          	lbu	a5,0(a0)
 14e:	cf91                	beqz	a5,16a <strlen+0x26>
 150:	0505                	addi	a0,a0,1
 152:	87aa                	mv	a5,a0
 154:	86be                	mv	a3,a5
 156:	0785                	addi	a5,a5,1
 158:	fff7c703          	lbu	a4,-1(a5)
 15c:	ff65                	bnez	a4,154 <strlen+0x10>
 15e:	40a6853b          	subw	a0,a3,a0
 162:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret
  for(n = 0; s[n]; n++)
 16a:	4501                	li	a0,0
 16c:	bfe5                	j	164 <strlen+0x20>

000000000000016e <memset>:

void*
memset(void *dst, int c, uint n)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 174:	ca19                	beqz	a2,18a <memset+0x1c>
 176:	87aa                	mv	a5,a0
 178:	1602                	slli	a2,a2,0x20
 17a:	9201                	srli	a2,a2,0x20
 17c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 180:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 184:	0785                	addi	a5,a5,1
 186:	fee79de3          	bne	a5,a4,180 <memset+0x12>
  }
  return dst;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  for(; *s; s++)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb99                	beqz	a5,1b0 <strchr+0x20>
    if(*s == c)
 19c:	00f58763          	beq	a1,a5,1aa <strchr+0x1a>
  for(; *s; s++)
 1a0:	0505                	addi	a0,a0,1
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbfd                	bnez	a5,19c <strchr+0xc>
      return (char*)s;
  return 0;
 1a8:	4501                	li	a0,0
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
  return 0;
 1b0:	4501                	li	a0,0
 1b2:	bfe5                	j	1aa <strchr+0x1a>

00000000000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	711d                	addi	sp,sp,-96
 1b6:	ec86                	sd	ra,88(sp)
 1b8:	e8a2                	sd	s0,80(sp)
 1ba:	e4a6                	sd	s1,72(sp)
 1bc:	e0ca                	sd	s2,64(sp)
 1be:	fc4e                	sd	s3,56(sp)
 1c0:	f852                	sd	s4,48(sp)
 1c2:	f456                	sd	s5,40(sp)
 1c4:	f05a                	sd	s6,32(sp)
 1c6:	ec5e                	sd	s7,24(sp)
 1c8:	1080                	addi	s0,sp,96
 1ca:	8baa                	mv	s7,a0
 1cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	892a                	mv	s2,a0
 1d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d2:	4aa9                	li	s5,10
 1d4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d6:	89a6                	mv	s3,s1
 1d8:	2485                	addiw	s1,s1,1
 1da:	0344d663          	bge	s1,s4,206 <gets+0x52>
    cc = read(0, &c, 1);
 1de:	4605                	li	a2,1
 1e0:	faf40593          	addi	a1,s0,-81
 1e4:	4501                	li	a0,0
 1e6:	1b2000ef          	jal	398 <read>
    if(cc < 1)
 1ea:	00a05e63          	blez	a0,206 <gets+0x52>
    buf[i++] = c;
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f6:	01578763          	beq	a5,s5,204 <gets+0x50>
 1fa:	0905                	addi	s2,s2,1
 1fc:	fd679de3          	bne	a5,s6,1d6 <gets+0x22>
    buf[i++] = c;
 200:	89a6                	mv	s3,s1
 202:	a011                	j	206 <gets+0x52>
 204:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 206:	99de                	add	s3,s3,s7
 208:	00098023          	sb	zero,0(s3)
  return buf;
}
 20c:	855e                	mv	a0,s7
 20e:	60e6                	ld	ra,88(sp)
 210:	6446                	ld	s0,80(sp)
 212:	64a6                	ld	s1,72(sp)
 214:	6906                	ld	s2,64(sp)
 216:	79e2                	ld	s3,56(sp)
 218:	7a42                	ld	s4,48(sp)
 21a:	7aa2                	ld	s5,40(sp)
 21c:	7b02                	ld	s6,32(sp)
 21e:	6be2                	ld	s7,24(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	1000                	addi	s0,sp,32
 22e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 230:	4581                	li	a1,0
 232:	18e000ef          	jal	3c0 <open>
  if(fd < 0)
 236:	02054263          	bltz	a0,25a <stat+0x36>
 23a:	e426                	sd	s1,8(sp)
 23c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23e:	85ca                	mv	a1,s2
 240:	198000ef          	jal	3d8 <fstat>
 244:	892a                	mv	s2,a0
  close(fd);
 246:	8526                	mv	a0,s1
 248:	160000ef          	jal	3a8 <close>
  return r;
 24c:	64a2                	ld	s1,8(sp)
}
 24e:	854a                	mv	a0,s2
 250:	60e2                	ld	ra,24(sp)
 252:	6442                	ld	s0,16(sp)
 254:	6902                	ld	s2,0(sp)
 256:	6105                	addi	sp,sp,32
 258:	8082                	ret
    return -1;
 25a:	597d                	li	s2,-1
 25c:	bfcd                	j	24e <stat+0x2a>

000000000000025e <atoi>:

int
atoi(const char *s)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 264:	00054683          	lbu	a3,0(a0)
 268:	fd06879b          	addiw	a5,a3,-48
 26c:	0ff7f793          	zext.b	a5,a5
 270:	4625                	li	a2,9
 272:	02f66863          	bltu	a2,a5,2a2 <atoi+0x44>
 276:	872a                	mv	a4,a0
  n = 0;
 278:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 27a:	0705                	addi	a4,a4,1
 27c:	0025179b          	slliw	a5,a0,0x2
 280:	9fa9                	addw	a5,a5,a0
 282:	0017979b          	slliw	a5,a5,0x1
 286:	9fb5                	addw	a5,a5,a3
 288:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28c:	00074683          	lbu	a3,0(a4)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	fef671e3          	bgeu	a2,a5,27a <atoi+0x1c>
  return n;
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
  n = 0;
 2a2:	4501                	li	a0,0
 2a4:	bfe5                	j	29c <atoi+0x3e>

00000000000002a6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ac:	02b57463          	bgeu	a0,a1,2d4 <memmove+0x2e>
    while(n-- > 0)
 2b0:	00c05f63          	blez	a2,2ce <memmove+0x28>
 2b4:	1602                	slli	a2,a2,0x20
 2b6:	9201                	srli	a2,a2,0x20
 2b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2bc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2be:	0585                	addi	a1,a1,1
 2c0:	0705                	addi	a4,a4,1
 2c2:	fff5c683          	lbu	a3,-1(a1)
 2c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ca:	fef71ae3          	bne	a4,a5,2be <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
    dst += n;
 2d4:	00c50733          	add	a4,a0,a2
    src += n;
 2d8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2da:	fec05ae3          	blez	a2,2ce <memmove+0x28>
 2de:	fff6079b          	addiw	a5,a2,-1
 2e2:	1782                	slli	a5,a5,0x20
 2e4:	9381                	srli	a5,a5,0x20
 2e6:	fff7c793          	not	a5,a5
 2ea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ec:	15fd                	addi	a1,a1,-1
 2ee:	177d                	addi	a4,a4,-1
 2f0:	0005c683          	lbu	a3,0(a1)
 2f4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f8:	fee79ae3          	bne	a5,a4,2ec <memmove+0x46>
 2fc:	bfc9                	j	2ce <memmove+0x28>

00000000000002fe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 304:	ca05                	beqz	a2,334 <memcmp+0x36>
 306:	fff6069b          	addiw	a3,a2,-1
 30a:	1682                	slli	a3,a3,0x20
 30c:	9281                	srli	a3,a3,0x20
 30e:	0685                	addi	a3,a3,1
 310:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 312:	00054783          	lbu	a5,0(a0)
 316:	0005c703          	lbu	a4,0(a1)
 31a:	00e79863          	bne	a5,a4,32a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 31e:	0505                	addi	a0,a0,1
    p2++;
 320:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 322:	fed518e3          	bne	a0,a3,312 <memcmp+0x14>
  }
  return 0;
 326:	4501                	li	a0,0
 328:	a019                	j	32e <memcmp+0x30>
      return *p1 - *p2;
 32a:	40e7853b          	subw	a0,a5,a4
}
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret
  return 0;
 334:	4501                	li	a0,0
 336:	bfe5                	j	32e <memcmp+0x30>

0000000000000338 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 340:	f67ff0ef          	jal	2a6 <memmove>
}
 344:	60a2                	ld	ra,8(sp)
 346:	6402                	ld	s0,0(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <sbrk>:

char *
sbrk(int n) {
 34c:	1141                	addi	sp,sp,-16
 34e:	e406                	sd	ra,8(sp)
 350:	e022                	sd	s0,0(sp)
 352:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 354:	4585                	li	a1,1
 356:	0b2000ef          	jal	408 <sys_sbrk>
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret

0000000000000362 <sbrklazy>:

char *
sbrklazy(int n) {
 362:	1141                	addi	sp,sp,-16
 364:	e406                	sd	ra,8(sp)
 366:	e022                	sd	s0,0(sp)
 368:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 36a:	4589                	li	a1,2
 36c:	09c000ef          	jal	408 <sys_sbrk>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 378:	4885                	li	a7,1
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <exit>:
.global exit
exit:
 li a7, SYS_exit
 380:	4889                	li	a7,2
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <wait>:
.global wait
wait:
 li a7, SYS_wait
 388:	488d                	li	a7,3
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 390:	4891                	li	a7,4
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <read>:
.global read
read:
 li a7, SYS_read
 398:	4895                	li	a7,5
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <write>:
.global write
write:
 li a7, SYS_write
 3a0:	48c1                	li	a7,16
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <close>:
.global close
close:
 li a7, SYS_close
 3a8:	48d5                	li	a7,21
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b0:	4899                	li	a7,6
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b8:	489d                	li	a7,7
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <open>:
.global open
open:
 li a7, SYS_open
 3c0:	48bd                	li	a7,15
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c8:	48c5                	li	a7,17
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d0:	48c9                	li	a7,18
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d8:	48a1                	li	a7,8
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <link>:
.global link
link:
 li a7, SYS_link
 3e0:	48cd                	li	a7,19
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e8:	48d1                	li	a7,20
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f0:	48a5                	li	a7,9
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f8:	48a9                	li	a7,10
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 400:	48ad                	li	a7,11
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 408:	48b1                	li	a7,12
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <pause>:
.global pause
pause:
 li a7, SYS_pause
 410:	48b5                	li	a7,13
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 418:	48b9                	li	a7,14
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 420:	1101                	addi	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	1000                	addi	s0,sp,32
 428:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42c:	4605                	li	a2,1
 42e:	fef40593          	addi	a1,s0,-17
 432:	f6fff0ef          	jal	3a0 <write>
}
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	6105                	addi	sp,sp,32
 43c:	8082                	ret

000000000000043e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 43e:	715d                	addi	sp,sp,-80
 440:	e486                	sd	ra,72(sp)
 442:	e0a2                	sd	s0,64(sp)
 444:	fc26                	sd	s1,56(sp)
 446:	0880                	addi	s0,sp,80
 448:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44a:	c299                	beqz	a3,450 <printint+0x12>
 44c:	0805c963          	bltz	a1,4de <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 450:	2581                	sext.w	a1,a1
  neg = 0;
 452:	4881                	li	a7,0
 454:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 458:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45a:	2601                	sext.w	a2,a2
 45c:	00000517          	auipc	a0,0x0
 460:	55450513          	addi	a0,a0,1364 # 9b0 <digits>
 464:	883a                	mv	a6,a4
 466:	2705                	addiw	a4,a4,1
 468:	02c5f7bb          	remuw	a5,a1,a2
 46c:	1782                	slli	a5,a5,0x20
 46e:	9381                	srli	a5,a5,0x20
 470:	97aa                	add	a5,a5,a0
 472:	0007c783          	lbu	a5,0(a5)
 476:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47a:	0005879b          	sext.w	a5,a1
 47e:	02c5d5bb          	divuw	a1,a1,a2
 482:	0685                	addi	a3,a3,1
 484:	fec7f0e3          	bgeu	a5,a2,464 <printint+0x26>
  if(neg)
 488:	00088c63          	beqz	a7,4a0 <printint+0x62>
    buf[i++] = '-';
 48c:	fd070793          	addi	a5,a4,-48
 490:	00878733          	add	a4,a5,s0
 494:	02d00793          	li	a5,45
 498:	fef70423          	sb	a5,-24(a4)
 49c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a0:	02e05a63          	blez	a4,4d4 <printint+0x96>
 4a4:	f84a                	sd	s2,48(sp)
 4a6:	f44e                	sd	s3,40(sp)
 4a8:	fb840793          	addi	a5,s0,-72
 4ac:	00e78933          	add	s2,a5,a4
 4b0:	fff78993          	addi	s3,a5,-1
 4b4:	99ba                	add	s3,s3,a4
 4b6:	377d                	addiw	a4,a4,-1
 4b8:	1702                	slli	a4,a4,0x20
 4ba:	9301                	srli	a4,a4,0x20
 4bc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c0:	fff94583          	lbu	a1,-1(s2)
 4c4:	8526                	mv	a0,s1
 4c6:	f5bff0ef          	jal	420 <putc>
  while(--i >= 0)
 4ca:	197d                	addi	s2,s2,-1
 4cc:	ff391ae3          	bne	s2,s3,4c0 <printint+0x82>
 4d0:	7942                	ld	s2,48(sp)
 4d2:	79a2                	ld	s3,40(sp)
}
 4d4:	60a6                	ld	ra,72(sp)
 4d6:	6406                	ld	s0,64(sp)
 4d8:	74e2                	ld	s1,56(sp)
 4da:	6161                	addi	sp,sp,80
 4dc:	8082                	ret
    x = -xx;
 4de:	40b005bb          	negw	a1,a1
    neg = 1;
 4e2:	4885                	li	a7,1
    x = -xx;
 4e4:	bf85                	j	454 <printint+0x16>

00000000000004e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e6:	711d                	addi	sp,sp,-96
 4e8:	ec86                	sd	ra,88(sp)
 4ea:	e8a2                	sd	s0,80(sp)
 4ec:	e0ca                	sd	s2,64(sp)
 4ee:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f0:	0005c903          	lbu	s2,0(a1)
 4f4:	28090663          	beqz	s2,780 <vprintf+0x29a>
 4f8:	e4a6                	sd	s1,72(sp)
 4fa:	fc4e                	sd	s3,56(sp)
 4fc:	f852                	sd	s4,48(sp)
 4fe:	f456                	sd	s5,40(sp)
 500:	f05a                	sd	s6,32(sp)
 502:	ec5e                	sd	s7,24(sp)
 504:	e862                	sd	s8,16(sp)
 506:	e466                	sd	s9,8(sp)
 508:	8b2a                	mv	s6,a0
 50a:	8a2e                	mv	s4,a1
 50c:	8bb2                	mv	s7,a2
  state = 0;
 50e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 510:	4481                	li	s1,0
 512:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 514:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 518:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 51c:	06c00c93          	li	s9,108
 520:	a005                	j	540 <vprintf+0x5a>
        putc(fd, c0);
 522:	85ca                	mv	a1,s2
 524:	855a                	mv	a0,s6
 526:	efbff0ef          	jal	420 <putc>
 52a:	a019                	j	530 <vprintf+0x4a>
    } else if(state == '%'){
 52c:	03598263          	beq	s3,s5,550 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 530:	2485                	addiw	s1,s1,1
 532:	8726                	mv	a4,s1
 534:	009a07b3          	add	a5,s4,s1
 538:	0007c903          	lbu	s2,0(a5)
 53c:	22090a63          	beqz	s2,770 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 540:	0009079b          	sext.w	a5,s2
    if(state == 0){
 544:	fe0994e3          	bnez	s3,52c <vprintf+0x46>
      if(c0 == '%'){
 548:	fd579de3          	bne	a5,s5,522 <vprintf+0x3c>
        state = '%';
 54c:	89be                	mv	s3,a5
 54e:	b7cd                	j	530 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 550:	00ea06b3          	add	a3,s4,a4
 554:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 558:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 55a:	c681                	beqz	a3,562 <vprintf+0x7c>
 55c:	9752                	add	a4,a4,s4
 55e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 562:	05878363          	beq	a5,s8,5a8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 566:	05978d63          	beq	a5,s9,5c0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 56a:	07500713          	li	a4,117
 56e:	0ee78763          	beq	a5,a4,65c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 572:	07800713          	li	a4,120
 576:	12e78963          	beq	a5,a4,6a8 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 57a:	07000713          	li	a4,112
 57e:	14e78e63          	beq	a5,a4,6da <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 582:	06300713          	li	a4,99
 586:	18e78e63          	beq	a5,a4,722 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 58a:	07300713          	li	a4,115
 58e:	1ae78463          	beq	a5,a4,736 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 592:	02500713          	li	a4,37
 596:	04e79563          	bne	a5,a4,5e0 <vprintf+0xfa>
        putc(fd, '%');
 59a:	02500593          	li	a1,37
 59e:	855a                	mv	a0,s6
 5a0:	e81ff0ef          	jal	420 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b769                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4685                	li	a3,1
 5ae:	4629                	li	a2,10
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e89ff0ef          	jal	43e <printint>
 5ba:	8bca                	mv	s7,s2
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bf8d                	j	530 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5c0:	06400793          	li	a5,100
 5c4:	02f68963          	beq	a3,a5,5f6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c8:	06c00793          	li	a5,108
 5cc:	04f68263          	beq	a3,a5,610 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5d0:	07500793          	li	a5,117
 5d4:	0af68063          	beq	a3,a5,674 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5d8:	07800793          	li	a5,120
 5dc:	0ef68263          	beq	a3,a5,6c0 <vprintf+0x1da>
        putc(fd, '%');
 5e0:	02500593          	li	a1,37
 5e4:	855a                	mv	a0,s6
 5e6:	e3bff0ef          	jal	420 <putc>
        putc(fd, c0);
 5ea:	85ca                	mv	a1,s2
 5ec:	855a                	mv	a0,s6
 5ee:	e33ff0ef          	jal	420 <putc>
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	bf35                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4685                	li	a3,1
 5fc:	4629                	li	a2,10
 5fe:	000bb583          	ld	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	e3bff0ef          	jal	43e <printint>
        i += 1;
 608:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
        i += 1;
 60e:	b70d                	j	530 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 610:	06400793          	li	a5,100
 614:	02f60763          	beq	a2,a5,642 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 618:	07500793          	li	a5,117
 61c:	06f60963          	beq	a2,a5,68e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 620:	07800793          	li	a5,120
 624:	faf61ee3          	bne	a2,a5,5e0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e09ff0ef          	jal	43e <printint>
        i += 2;
 63a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 2;
 640:	bdc5                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 642:	008b8913          	addi	s2,s7,8
 646:	4685                	li	a3,1
 648:	4629                	li	a2,10
 64a:	000bb583          	ld	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	defff0ef          	jal	43e <printint>
        i += 2;
 654:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
        i += 2;
 65a:	bdd9                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000be583          	lwu	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dd5ff0ef          	jal	43e <printint>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	bd7d                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000bb583          	ld	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	dbdff0ef          	jal	43e <printint>
        i += 1;
 686:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
        i += 1;
 68c:	b555                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68e:	008b8913          	addi	s2,s7,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000bb583          	ld	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	da3ff0ef          	jal	43e <printint>
        i += 2;
 6a0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
        i += 2;
 6a6:	b569                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000be583          	lwu	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	d89ff0ef          	jal	43e <printint>
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bd8d                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4641                	li	a2,16
 6c8:	000bb583          	ld	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	d71ff0ef          	jal	43e <printint>
        i += 1;
 6d2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
        i += 1;
 6d8:	bda1                	j	530 <vprintf+0x4a>
 6da:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6dc:	008b8d13          	addi	s10,s7,8
 6e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e4:	03000593          	li	a1,48
 6e8:	855a                	mv	a0,s6
 6ea:	d37ff0ef          	jal	420 <putc>
  putc(fd, 'x');
 6ee:	07800593          	li	a1,120
 6f2:	855a                	mv	a0,s6
 6f4:	d2dff0ef          	jal	420 <putc>
 6f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fa:	00000b97          	auipc	s7,0x0
 6fe:	2b6b8b93          	addi	s7,s7,694 # 9b0 <digits>
 702:	03c9d793          	srli	a5,s3,0x3c
 706:	97de                	add	a5,a5,s7
 708:	0007c583          	lbu	a1,0(a5)
 70c:	855a                	mv	a0,s6
 70e:	d13ff0ef          	jal	420 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 712:	0992                	slli	s3,s3,0x4
 714:	397d                	addiw	s2,s2,-1
 716:	fe0916e3          	bnez	s2,702 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 71a:	8bea                	mv	s7,s10
      state = 0;
 71c:	4981                	li	s3,0
 71e:	6d02                	ld	s10,0(sp)
 720:	bd01                	j	530 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 722:	008b8913          	addi	s2,s7,8
 726:	000bc583          	lbu	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	cf5ff0ef          	jal	420 <putc>
 730:	8bca                	mv	s7,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	bbf5                	j	530 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 736:	008b8993          	addi	s3,s7,8
 73a:	000bb903          	ld	s2,0(s7)
 73e:	00090f63          	beqz	s2,75c <vprintf+0x276>
        for(; *s; s++)
 742:	00094583          	lbu	a1,0(s2)
 746:	c195                	beqz	a1,76a <vprintf+0x284>
          putc(fd, *s);
 748:	855a                	mv	a0,s6
 74a:	cd7ff0ef          	jal	420 <putc>
        for(; *s; s++)
 74e:	0905                	addi	s2,s2,1
 750:	00094583          	lbu	a1,0(s2)
 754:	f9f5                	bnez	a1,748 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 756:	8bce                	mv	s7,s3
      state = 0;
 758:	4981                	li	s3,0
 75a:	bbd9                	j	530 <vprintf+0x4a>
          s = "(null)";
 75c:	00000917          	auipc	s2,0x0
 760:	24c90913          	addi	s2,s2,588 # 9a8 <malloc+0x140>
        for(; *s; s++)
 764:	02800593          	li	a1,40
 768:	b7c5                	j	748 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 76a:	8bce                	mv	s7,s3
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b3c9                	j	530 <vprintf+0x4a>
 770:	64a6                	ld	s1,72(sp)
 772:	79e2                	ld	s3,56(sp)
 774:	7a42                	ld	s4,48(sp)
 776:	7aa2                	ld	s5,40(sp)
 778:	7b02                	ld	s6,32(sp)
 77a:	6be2                	ld	s7,24(sp)
 77c:	6c42                	ld	s8,16(sp)
 77e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 780:	60e6                	ld	ra,88(sp)
 782:	6446                	ld	s0,80(sp)
 784:	6906                	ld	s2,64(sp)
 786:	6125                	addi	sp,sp,96
 788:	8082                	ret

000000000000078a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78a:	715d                	addi	sp,sp,-80
 78c:	ec06                	sd	ra,24(sp)
 78e:	e822                	sd	s0,16(sp)
 790:	1000                	addi	s0,sp,32
 792:	e010                	sd	a2,0(s0)
 794:	e414                	sd	a3,8(s0)
 796:	e818                	sd	a4,16(s0)
 798:	ec1c                	sd	a5,24(s0)
 79a:	03043023          	sd	a6,32(s0)
 79e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a6:	8622                	mv	a2,s0
 7a8:	d3fff0ef          	jal	4e6 <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6161                	addi	sp,sp,80
 7b2:	8082                	ret

00000000000007b4 <printf>:

void
printf(const char *fmt, ...)
{
 7b4:	711d                	addi	sp,sp,-96
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e40c                	sd	a1,8(s0)
 7be:	e810                	sd	a2,16(s0)
 7c0:	ec14                	sd	a3,24(s0)
 7c2:	f018                	sd	a4,32(s0)
 7c4:	f41c                	sd	a5,40(s0)
 7c6:	03043823          	sd	a6,48(s0)
 7ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ce:	00840613          	addi	a2,s0,8
 7d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d6:	85aa                	mv	a1,a0
 7d8:	4505                	li	a0,1
 7da:	d0dff0ef          	jal	4e6 <vprintf>
}
 7de:	60e2                	ld	ra,24(sp)
 7e0:	6442                	ld	s0,16(sp)
 7e2:	6125                	addi	sp,sp,96
 7e4:	8082                	ret

00000000000007e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e6:	1141                	addi	sp,sp,-16
 7e8:	e422                	sd	s0,8(sp)
 7ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	00001797          	auipc	a5,0x1
 7f4:	8107b783          	ld	a5,-2032(a5) # 1000 <freep>
 7f8:	a02d                	j	822 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fa:	4618                	lw	a4,8(a2)
 7fc:	9f2d                	addw	a4,a4,a1
 7fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	6310                	ld	a2,0(a4)
 806:	a83d                	j	844 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 808:	ff852703          	lw	a4,-8(a0)
 80c:	9f31                	addw	a4,a4,a2
 80e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 810:	ff053683          	ld	a3,-16(a0)
 814:	a091                	j	858 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 816:	6398                	ld	a4,0(a5)
 818:	00e7e463          	bltu	a5,a4,820 <free+0x3a>
 81c:	00e6ea63          	bltu	a3,a4,830 <free+0x4a>
{
 820:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	fed7fae3          	bgeu	a5,a3,816 <free+0x30>
 826:	6398                	ld	a4,0(a5)
 828:	00e6e463          	bltu	a3,a4,830 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82c:	fee7eae3          	bltu	a5,a4,820 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 830:	ff852583          	lw	a1,-8(a0)
 834:	6390                	ld	a2,0(a5)
 836:	02059813          	slli	a6,a1,0x20
 83a:	01c85713          	srli	a4,a6,0x1c
 83e:	9736                	add	a4,a4,a3
 840:	fae60de3          	beq	a2,a4,7fa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 844:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 848:	4790                	lw	a2,8(a5)
 84a:	02061593          	slli	a1,a2,0x20
 84e:	01c5d713          	srli	a4,a1,0x1c
 852:	973e                	add	a4,a4,a5
 854:	fae68ae3          	beq	a3,a4,808 <free+0x22>
    p->s.ptr = bp->s.ptr;
 858:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85a:	00000717          	auipc	a4,0x0
 85e:	7af73323          	sd	a5,1958(a4) # 1000 <freep>
}
 862:	6422                	ld	s0,8(sp)
 864:	0141                	addi	sp,sp,16
 866:	8082                	ret

0000000000000868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f426                	sd	s1,40(sp)
 870:	ec4e                	sd	s3,24(sp)
 872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 874:	02051493          	slli	s1,a0,0x20
 878:	9081                	srli	s1,s1,0x20
 87a:	04bd                	addi	s1,s1,15
 87c:	8091                	srli	s1,s1,0x4
 87e:	0014899b          	addiw	s3,s1,1
 882:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 884:	00000517          	auipc	a0,0x0
 888:	77c53503          	ld	a0,1916(a0) # 1000 <freep>
 88c:	c915                	beqz	a0,8c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 890:	4798                	lw	a4,8(a5)
 892:	08977a63          	bgeu	a4,s1,926 <malloc+0xbe>
 896:	f04a                	sd	s2,32(sp)
 898:	e852                	sd	s4,16(sp)
 89a:	e456                	sd	s5,8(sp)
 89c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 89e:	8a4e                	mv	s4,s3
 8a0:	0009871b          	sext.w	a4,s3
 8a4:	6685                	lui	a3,0x1
 8a6:	00d77363          	bgeu	a4,a3,8ac <malloc+0x44>
 8aa:	6a05                	lui	s4,0x1
 8ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b4:	00000917          	auipc	s2,0x0
 8b8:	74c90913          	addi	s2,s2,1868 # 1000 <freep>
  if(p == SBRK_ERROR)
 8bc:	5afd                	li	s5,-1
 8be:	a081                	j	8fe <malloc+0x96>
 8c0:	f04a                	sd	s2,32(sp)
 8c2:	e852                	sd	s4,16(sp)
 8c4:	e456                	sd	s5,8(sp)
 8c6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c8:	00001797          	auipc	a5,0x1
 8cc:	94878793          	addi	a5,a5,-1720 # 1210 <base>
 8d0:	00000717          	auipc	a4,0x0
 8d4:	72f73823          	sd	a5,1840(a4) # 1000 <freep>
 8d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8de:	b7c1                	j	89e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8e0:	6398                	ld	a4,0(a5)
 8e2:	e118                	sd	a4,0(a0)
 8e4:	a8a9                	j	93e <malloc+0xd6>
  hp->s.size = nu;
 8e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ea:	0541                	addi	a0,a0,16
 8ec:	efbff0ef          	jal	7e6 <free>
  return freep;
 8f0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f4:	c12d                	beqz	a0,956 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f8:	4798                	lw	a4,8(a5)
 8fa:	02977263          	bgeu	a4,s1,91e <malloc+0xb6>
    if(p == freep)
 8fe:	00093703          	ld	a4,0(s2)
 902:	853e                	mv	a0,a5
 904:	fef719e3          	bne	a4,a5,8f6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 908:	8552                	mv	a0,s4
 90a:	a43ff0ef          	jal	34c <sbrk>
  if(p == SBRK_ERROR)
 90e:	fd551ce3          	bne	a0,s5,8e6 <malloc+0x7e>
        return 0;
 912:	4501                	li	a0,0
 914:	7902                	ld	s2,32(sp)
 916:	6a42                	ld	s4,16(sp)
 918:	6aa2                	ld	s5,8(sp)
 91a:	6b02                	ld	s6,0(sp)
 91c:	a03d                	j	94a <malloc+0xe2>
 91e:	7902                	ld	s2,32(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 926:	fae48de3          	beq	s1,a4,8e0 <malloc+0x78>
        p->s.size -= nunits;
 92a:	4137073b          	subw	a4,a4,s3
 92e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 930:	02071693          	slli	a3,a4,0x20
 934:	01c6d713          	srli	a4,a3,0x1c
 938:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 93e:	00000717          	auipc	a4,0x0
 942:	6ca73123          	sd	a0,1730(a4) # 1000 <freep>
      return (void*)(p + 1);
 946:	01078513          	addi	a0,a5,16
  }
}
 94a:	70e2                	ld	ra,56(sp)
 94c:	7442                	ld	s0,48(sp)
 94e:	74a2                	ld	s1,40(sp)
 950:	69e2                	ld	s3,24(sp)
 952:	6121                	addi	sp,sp,64
 954:	8082                	ret
 956:	7902                	ld	s2,32(sp)
 958:	6a42                	ld	s4,16(sp)
 95a:	6aa2                	ld	s5,8(sp)
 95c:	6b02                	ld	s6,0(sp)
 95e:	b7f5                	j	94a <malloc+0xe2>
