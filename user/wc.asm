
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	9a8a0a13          	addi	s4,s4,-1624 # 9e0 <malloc+0x106>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1bc000ef          	jal	202 <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01348d63          	beq	s1,s3,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2c05                	addiw	s8,s8,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0917e3          	bnez	s2,4e <wc+0x4e>
        w++;
  64:	2c85                	addiw	s9,s9,1
        inword = 1;
  66:	4905                	li	s2,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	392000ef          	jal	40a <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
    for(i=0; i<n; i++){
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009509b3          	add	s3,a0,s1
  8e:	b7d9                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86ea                	mv	a3,s10
  9a:	8666                	mv	a2,s9
  9c:	85e2                	mv	a1,s8
  9e:	00001517          	auipc	a0,0x1
  a2:	96250513          	addi	a0,a0,-1694 # a00 <malloc+0x126>
  a6:	780000ef          	jal	826 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	92850513          	addi	a0,a0,-1752 # 9f0 <malloc+0x116>
  d0:	756000ef          	jal	826 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	31c000ef          	jal	3f2 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	32a000ef          	jal	432 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	2fe000ef          	jal	41a <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2ca000ef          	jal	3f2 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8b658593          	addi	a1,a1,-1866 # 9e8 <malloc+0x10e>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2b0000ef          	jal	3f2 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8c650513          	addi	a0,a0,-1850 # a10 <malloc+0x136>
 152:	6d4000ef          	jal	826 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	29a000ef          	jal	3f2 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	288000ef          	jal	3f2 <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0x8>
    ;
  return os;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb91                	beqz	a5,1a8 <strcmp+0x1e>
 196:	0005c703          	lbu	a4,0(a1)
 19a:	00f71763          	bne	a4,a5,1a8 <strcmp+0x1e>
    p++, q++;
 19e:	0505                	addi	a0,a0,1
 1a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbe5                	bnez	a5,196 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a8:	0005c503          	lbu	a0,0(a1)
}
 1ac:	40a7853b          	subw	a0,a5,a0
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strlen>:

uint
strlen(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf91                	beqz	a5,1dc <strlen+0x26>
 1c2:	0505                	addi	a0,a0,1
 1c4:	87aa                	mv	a5,a0
 1c6:	86be                	mv	a3,a5
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff7c703          	lbu	a4,-1(a5)
 1ce:	ff65                	bnez	a4,1c6 <strlen+0x10>
 1d0:	40a6853b          	subw	a0,a3,a0
 1d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  for(n = 0; s[n]; n++)
 1dc:	4501                	li	a0,0
 1de:	bfe5                	j	1d6 <strlen+0x20>

00000000000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e6:	ca19                	beqz	a2,1fc <memset+0x1c>
 1e8:	87aa                	mv	a5,a0
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f6:	0785                	addi	a5,a5,1
 1f8:	fee79de3          	bne	a5,a4,1f2 <memset+0x12>
  }
  return dst;
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  for(; *s; s++)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cb99                	beqz	a5,222 <strchr+0x20>
    if(*s == c)
 20e:	00f58763          	beq	a1,a5,21c <strchr+0x1a>
  for(; *s; s++)
 212:	0505                	addi	a0,a0,1
 214:	00054783          	lbu	a5,0(a0)
 218:	fbfd                	bnez	a5,20e <strchr+0xc>
      return (char*)s;
  return 0;
 21a:	4501                	li	a0,0
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  return 0;
 222:	4501                	li	a0,0
 224:	bfe5                	j	21c <strchr+0x1a>

0000000000000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	711d                	addi	sp,sp,-96
 228:	ec86                	sd	ra,88(sp)
 22a:	e8a2                	sd	s0,80(sp)
 22c:	e4a6                	sd	s1,72(sp)
 22e:	e0ca                	sd	s2,64(sp)
 230:	fc4e                	sd	s3,56(sp)
 232:	f852                	sd	s4,48(sp)
 234:	f456                	sd	s5,40(sp)
 236:	f05a                	sd	s6,32(sp)
 238:	ec5e                	sd	s7,24(sp)
 23a:	1080                	addi	s0,sp,96
 23c:	8baa                	mv	s7,a0
 23e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 240:	892a                	mv	s2,a0
 242:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 244:	4aa9                	li	s5,10
 246:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 248:	89a6                	mv	s3,s1
 24a:	2485                	addiw	s1,s1,1
 24c:	0344d663          	bge	s1,s4,278 <gets+0x52>
    cc = read(0, &c, 1);
 250:	4605                	li	a2,1
 252:	faf40593          	addi	a1,s0,-81
 256:	4501                	li	a0,0
 258:	1b2000ef          	jal	40a <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x52>
    buf[i++] = c;
 260:	faf44783          	lbu	a5,-81(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01578763          	beq	a5,s5,276 <gets+0x50>
 26c:	0905                	addi	s2,s2,1
 26e:	fd679de3          	bne	a5,s6,248 <gets+0x22>
    buf[i++] = c;
 272:	89a6                	mv	s3,s1
 274:	a011                	j	278 <gets+0x52>
 276:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 278:	99de                	add	s3,s3,s7
 27a:	00098023          	sb	zero,0(s3)
  return buf;
}
 27e:	855e                	mv	a0,s7
 280:	60e6                	ld	ra,88(sp)
 282:	6446                	ld	s0,80(sp)
 284:	64a6                	ld	s1,72(sp)
 286:	6906                	ld	s2,64(sp)
 288:	79e2                	ld	s3,56(sp)
 28a:	7a42                	ld	s4,48(sp)
 28c:	7aa2                	ld	s5,40(sp)
 28e:	7b02                	ld	s6,32(sp)
 290:	6be2                	ld	s7,24(sp)
 292:	6125                	addi	sp,sp,96
 294:	8082                	ret

0000000000000296 <stat>:

int
stat(const char *n, struct stat *st)
{
 296:	1101                	addi	sp,sp,-32
 298:	ec06                	sd	ra,24(sp)
 29a:	e822                	sd	s0,16(sp)
 29c:	e04a                	sd	s2,0(sp)
 29e:	1000                	addi	s0,sp,32
 2a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	4581                	li	a1,0
 2a4:	18e000ef          	jal	432 <open>
  if(fd < 0)
 2a8:	02054263          	bltz	a0,2cc <stat+0x36>
 2ac:	e426                	sd	s1,8(sp)
 2ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b0:	85ca                	mv	a1,s2
 2b2:	198000ef          	jal	44a <fstat>
 2b6:	892a                	mv	s2,a0
  close(fd);
 2b8:	8526                	mv	a0,s1
 2ba:	160000ef          	jal	41a <close>
  return r;
 2be:	64a2                	ld	s1,8(sp)
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	6902                	ld	s2,0(sp)
 2c8:	6105                	addi	sp,sp,32
 2ca:	8082                	ret
    return -1;
 2cc:	597d                	li	s2,-1
 2ce:	bfcd                	j	2c0 <stat+0x2a>

00000000000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d6:	00054683          	lbu	a3,0(a0)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	4625                	li	a2,9
 2e4:	02f66863          	bltu	a2,a5,314 <atoi+0x44>
 2e8:	872a                	mv	a4,a0
  n = 0;
 2ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ec:	0705                	addi	a4,a4,1
 2ee:	0025179b          	slliw	a5,a0,0x2
 2f2:	9fa9                	addw	a5,a5,a0
 2f4:	0017979b          	slliw	a5,a5,0x1
 2f8:	9fb5                	addw	a5,a5,a3
 2fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fe:	00074683          	lbu	a3,0(a4)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	fef671e3          	bgeu	a2,a5,2ec <atoi+0x1c>
  return n;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  n = 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <atoi+0x3e>

0000000000000318 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31e:	02b57463          	bgeu	a0,a1,346 <memmove+0x2e>
    while(n-- > 0)
 322:	00c05f63          	blez	a2,340 <memmove+0x28>
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32e:	872a                	mv	a4,a0
      *dst++ = *src++;
 330:	0585                	addi	a1,a1,1
 332:	0705                	addi	a4,a4,1
 334:	fff5c683          	lbu	a3,-1(a1)
 338:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33c:	fef71ae3          	bne	a4,a5,330 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
    dst += n;
 346:	00c50733          	add	a4,a0,a2
    src += n;
 34a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34c:	fec05ae3          	blez	a2,340 <memmove+0x28>
 350:	fff6079b          	addiw	a5,a2,-1
 354:	1782                	slli	a5,a5,0x20
 356:	9381                	srli	a5,a5,0x20
 358:	fff7c793          	not	a5,a5
 35c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35e:	15fd                	addi	a1,a1,-1
 360:	177d                	addi	a4,a4,-1
 362:	0005c683          	lbu	a3,0(a1)
 366:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x46>
 36e:	bfc9                	j	340 <memmove+0x28>

0000000000000370 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 376:	ca05                	beqz	a2,3a6 <memcmp+0x36>
 378:	fff6069b          	addiw	a3,a2,-1
 37c:	1682                	slli	a3,a3,0x20
 37e:	9281                	srli	a3,a3,0x20
 380:	0685                	addi	a3,a3,1
 382:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 384:	00054783          	lbu	a5,0(a0)
 388:	0005c703          	lbu	a4,0(a1)
 38c:	00e79863          	bne	a5,a4,39c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 390:	0505                	addi	a0,a0,1
    p2++;
 392:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 394:	fed518e3          	bne	a0,a3,384 <memcmp+0x14>
  }
  return 0;
 398:	4501                	li	a0,0
 39a:	a019                	j	3a0 <memcmp+0x30>
      return *p1 - *p2;
 39c:	40e7853b          	subw	a0,a5,a4
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
  return 0;
 3a6:	4501                	li	a0,0
 3a8:	bfe5                	j	3a0 <memcmp+0x30>

00000000000003aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e406                	sd	ra,8(sp)
 3ae:	e022                	sd	s0,0(sp)
 3b0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b2:	f67ff0ef          	jal	318 <memmove>
}
 3b6:	60a2                	ld	ra,8(sp)
 3b8:	6402                	ld	s0,0(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <sbrk>:

char *
sbrk(int n) {
 3be:	1141                	addi	sp,sp,-16
 3c0:	e406                	sd	ra,8(sp)
 3c2:	e022                	sd	s0,0(sp)
 3c4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3c6:	4585                	li	a1,1
 3c8:	0b2000ef          	jal	47a <sys_sbrk>
}
 3cc:	60a2                	ld	ra,8(sp)
 3ce:	6402                	ld	s0,0(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <sbrklazy>:

char *
sbrklazy(int n) {
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e406                	sd	ra,8(sp)
 3d8:	e022                	sd	s0,0(sp)
 3da:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3dc:	4589                	li	a1,2
 3de:	09c000ef          	jal	47a <sys_sbrk>
}
 3e2:	60a2                	ld	ra,8(sp)
 3e4:	6402                	ld	s0,0(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret

00000000000003ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ea:	4885                	li	a7,1
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f2:	4889                	li	a7,2
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fa:	488d                	li	a7,3
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 402:	4891                	li	a7,4
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <read>:
.global read
read:
 li a7, SYS_read
 40a:	4895                	li	a7,5
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <write>:
.global write
write:
 li a7, SYS_write
 412:	48c1                	li	a7,16
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <close>:
.global close
close:
 li a7, SYS_close
 41a:	48d5                	li	a7,21
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <kill>:
.global kill
kill:
 li a7, SYS_kill
 422:	4899                	li	a7,6
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <exec>:
.global exec
exec:
 li a7, SYS_exec
 42a:	489d                	li	a7,7
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <open>:
.global open
open:
 li a7, SYS_open
 432:	48bd                	li	a7,15
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43a:	48c5                	li	a7,17
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 442:	48c9                	li	a7,18
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44a:	48a1                	li	a7,8
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <link>:
.global link
link:
 li a7, SYS_link
 452:	48cd                	li	a7,19
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45a:	48d1                	li	a7,20
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 462:	48a5                	li	a7,9
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <dup>:
.global dup
dup:
 li a7, SYS_dup
 46a:	48a9                	li	a7,10
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 472:	48ad                	li	a7,11
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 47a:	48b1                	li	a7,12
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <pause>:
.global pause
pause:
 li a7, SYS_pause
 482:	48b5                	li	a7,13
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48a:	48b9                	li	a7,14
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 492:	1101                	addi	sp,sp,-32
 494:	ec06                	sd	ra,24(sp)
 496:	e822                	sd	s0,16(sp)
 498:	1000                	addi	s0,sp,32
 49a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 49e:	4605                	li	a2,1
 4a0:	fef40593          	addi	a1,s0,-17
 4a4:	f6fff0ef          	jal	412 <write>
}
 4a8:	60e2                	ld	ra,24(sp)
 4aa:	6442                	ld	s0,16(sp)
 4ac:	6105                	addi	sp,sp,32
 4ae:	8082                	ret

00000000000004b0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4b0:	715d                	addi	sp,sp,-80
 4b2:	e486                	sd	ra,72(sp)
 4b4:	e0a2                	sd	s0,64(sp)
 4b6:	fc26                	sd	s1,56(sp)
 4b8:	0880                	addi	s0,sp,80
 4ba:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4bc:	c299                	beqz	a3,4c2 <printint+0x12>
 4be:	0805c963          	bltz	a1,550 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c2:	2581                	sext.w	a1,a1
  neg = 0;
 4c4:	4881                	li	a7,0
 4c6:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 4ca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4cc:	2601                	sext.w	a2,a2
 4ce:	00000517          	auipc	a0,0x0
 4d2:	56250513          	addi	a0,a0,1378 # a30 <digits>
 4d6:	883a                	mv	a6,a4
 4d8:	2705                	addiw	a4,a4,1
 4da:	02c5f7bb          	remuw	a5,a1,a2
 4de:	1782                	slli	a5,a5,0x20
 4e0:	9381                	srli	a5,a5,0x20
 4e2:	97aa                	add	a5,a5,a0
 4e4:	0007c783          	lbu	a5,0(a5)
 4e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ec:	0005879b          	sext.w	a5,a1
 4f0:	02c5d5bb          	divuw	a1,a1,a2
 4f4:	0685                	addi	a3,a3,1
 4f6:	fec7f0e3          	bgeu	a5,a2,4d6 <printint+0x26>
  if(neg)
 4fa:	00088c63          	beqz	a7,512 <printint+0x62>
    buf[i++] = '-';
 4fe:	fd070793          	addi	a5,a4,-48
 502:	00878733          	add	a4,a5,s0
 506:	02d00793          	li	a5,45
 50a:	fef70423          	sb	a5,-24(a4)
 50e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 512:	02e05a63          	blez	a4,546 <printint+0x96>
 516:	f84a                	sd	s2,48(sp)
 518:	f44e                	sd	s3,40(sp)
 51a:	fb840793          	addi	a5,s0,-72
 51e:	00e78933          	add	s2,a5,a4
 522:	fff78993          	addi	s3,a5,-1
 526:	99ba                	add	s3,s3,a4
 528:	377d                	addiw	a4,a4,-1
 52a:	1702                	slli	a4,a4,0x20
 52c:	9301                	srli	a4,a4,0x20
 52e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 532:	fff94583          	lbu	a1,-1(s2)
 536:	8526                	mv	a0,s1
 538:	f5bff0ef          	jal	492 <putc>
  while(--i >= 0)
 53c:	197d                	addi	s2,s2,-1
 53e:	ff391ae3          	bne	s2,s3,532 <printint+0x82>
 542:	7942                	ld	s2,48(sp)
 544:	79a2                	ld	s3,40(sp)
}
 546:	60a6                	ld	ra,72(sp)
 548:	6406                	ld	s0,64(sp)
 54a:	74e2                	ld	s1,56(sp)
 54c:	6161                	addi	sp,sp,80
 54e:	8082                	ret
    x = -xx;
 550:	40b005bb          	negw	a1,a1
    neg = 1;
 554:	4885                	li	a7,1
    x = -xx;
 556:	bf85                	j	4c6 <printint+0x16>

0000000000000558 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 558:	711d                	addi	sp,sp,-96
 55a:	ec86                	sd	ra,88(sp)
 55c:	e8a2                	sd	s0,80(sp)
 55e:	e0ca                	sd	s2,64(sp)
 560:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 562:	0005c903          	lbu	s2,0(a1)
 566:	28090663          	beqz	s2,7f2 <vprintf+0x29a>
 56a:	e4a6                	sd	s1,72(sp)
 56c:	fc4e                	sd	s3,56(sp)
 56e:	f852                	sd	s4,48(sp)
 570:	f456                	sd	s5,40(sp)
 572:	f05a                	sd	s6,32(sp)
 574:	ec5e                	sd	s7,24(sp)
 576:	e862                	sd	s8,16(sp)
 578:	e466                	sd	s9,8(sp)
 57a:	8b2a                	mv	s6,a0
 57c:	8a2e                	mv	s4,a1
 57e:	8bb2                	mv	s7,a2
  state = 0;
 580:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 582:	4481                	li	s1,0
 584:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 586:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 58a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 58e:	06c00c93          	li	s9,108
 592:	a005                	j	5b2 <vprintf+0x5a>
        putc(fd, c0);
 594:	85ca                	mv	a1,s2
 596:	855a                	mv	a0,s6
 598:	efbff0ef          	jal	492 <putc>
 59c:	a019                	j	5a2 <vprintf+0x4a>
    } else if(state == '%'){
 59e:	03598263          	beq	s3,s5,5c2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5a2:	2485                	addiw	s1,s1,1
 5a4:	8726                	mv	a4,s1
 5a6:	009a07b3          	add	a5,s4,s1
 5aa:	0007c903          	lbu	s2,0(a5)
 5ae:	22090a63          	beqz	s2,7e2 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5b2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5b6:	fe0994e3          	bnez	s3,59e <vprintf+0x46>
      if(c0 == '%'){
 5ba:	fd579de3          	bne	a5,s5,594 <vprintf+0x3c>
        state = '%';
 5be:	89be                	mv	s3,a5
 5c0:	b7cd                	j	5a2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5c2:	00ea06b3          	add	a3,s4,a4
 5c6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ca:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5cc:	c681                	beqz	a3,5d4 <vprintf+0x7c>
 5ce:	9752                	add	a4,a4,s4
 5d0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5d4:	05878363          	beq	a5,s8,61a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5d8:	05978d63          	beq	a5,s9,632 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5dc:	07500713          	li	a4,117
 5e0:	0ee78763          	beq	a5,a4,6ce <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5e4:	07800713          	li	a4,120
 5e8:	12e78963          	beq	a5,a4,71a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ec:	07000713          	li	a4,112
 5f0:	14e78e63          	beq	a5,a4,74c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5f4:	06300713          	li	a4,99
 5f8:	18e78e63          	beq	a5,a4,794 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5fc:	07300713          	li	a4,115
 600:	1ae78463          	beq	a5,a4,7a8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 604:	02500713          	li	a4,37
 608:	04e79563          	bne	a5,a4,652 <vprintf+0xfa>
        putc(fd, '%');
 60c:	02500593          	li	a1,37
 610:	855a                	mv	a0,s6
 612:	e81ff0ef          	jal	492 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 616:	4981                	li	s3,0
 618:	b769                	j	5a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4685                	li	a3,1
 620:	4629                	li	a2,10
 622:	000ba583          	lw	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	e89ff0ef          	jal	4b0 <printint>
 62c:	8bca                	mv	s7,s2
      state = 0;
 62e:	4981                	li	s3,0
 630:	bf8d                	j	5a2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 632:	06400793          	li	a5,100
 636:	02f68963          	beq	a3,a5,668 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63a:	06c00793          	li	a5,108
 63e:	04f68263          	beq	a3,a5,682 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 642:	07500793          	li	a5,117
 646:	0af68063          	beq	a3,a5,6e6 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 64a:	07800793          	li	a5,120
 64e:	0ef68263          	beq	a3,a5,732 <vprintf+0x1da>
        putc(fd, '%');
 652:	02500593          	li	a1,37
 656:	855a                	mv	a0,s6
 658:	e3bff0ef          	jal	492 <putc>
        putc(fd, c0);
 65c:	85ca                	mv	a1,s2
 65e:	855a                	mv	a0,s6
 660:	e33ff0ef          	jal	492 <putc>
      state = 0;
 664:	4981                	li	s3,0
 666:	bf35                	j	5a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 668:	008b8913          	addi	s2,s7,8
 66c:	4685                	li	a3,1
 66e:	4629                	li	a2,10
 670:	000bb583          	ld	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e3bff0ef          	jal	4b0 <printint>
        i += 1;
 67a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 1;
 680:	b70d                	j	5a2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 682:	06400793          	li	a5,100
 686:	02f60763          	beq	a2,a5,6b4 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 68a:	07500793          	li	a5,117
 68e:	06f60963          	beq	a2,a5,700 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 692:	07800793          	li	a5,120
 696:	faf61ee3          	bne	a2,a5,652 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69a:	008b8913          	addi	s2,s7,8
 69e:	4681                	li	a3,0
 6a0:	4641                	li	a2,16
 6a2:	000bb583          	ld	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	e09ff0ef          	jal	4b0 <printint>
        i += 2;
 6ac:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
        i += 2;
 6b2:	bdc5                	j	5a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4685                	li	a3,1
 6ba:	4629                	li	a2,10
 6bc:	000bb583          	ld	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	defff0ef          	jal	4b0 <printint>
        i += 2;
 6c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 2;
 6cc:	bdd9                	j	5a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4629                	li	a2,10
 6d6:	000be583          	lwu	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	dd5ff0ef          	jal	4b0 <printint>
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bd7d                	j	5a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e6:	008b8913          	addi	s2,s7,8
 6ea:	4681                	li	a3,0
 6ec:	4629                	li	a2,10
 6ee:	000bb583          	ld	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	dbdff0ef          	jal	4b0 <printint>
        i += 1;
 6f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
        i += 1;
 6fe:	b555                	j	5a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 700:	008b8913          	addi	s2,s7,8
 704:	4681                	li	a3,0
 706:	4629                	li	a2,10
 708:	000bb583          	ld	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	da3ff0ef          	jal	4b0 <printint>
        i += 2;
 712:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
        i += 2;
 718:	b569                	j	5a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 71a:	008b8913          	addi	s2,s7,8
 71e:	4681                	li	a3,0
 720:	4641                	li	a2,16
 722:	000be583          	lwu	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	d89ff0ef          	jal	4b0 <printint>
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	bd8d                	j	5a2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 732:	008b8913          	addi	s2,s7,8
 736:	4681                	li	a3,0
 738:	4641                	li	a2,16
 73a:	000bb583          	ld	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	d71ff0ef          	jal	4b0 <printint>
        i += 1;
 744:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 746:	8bca                	mv	s7,s2
      state = 0;
 748:	4981                	li	s3,0
        i += 1;
 74a:	bda1                	j	5a2 <vprintf+0x4a>
 74c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 74e:	008b8d13          	addi	s10,s7,8
 752:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 756:	03000593          	li	a1,48
 75a:	855a                	mv	a0,s6
 75c:	d37ff0ef          	jal	492 <putc>
  putc(fd, 'x');
 760:	07800593          	li	a1,120
 764:	855a                	mv	a0,s6
 766:	d2dff0ef          	jal	492 <putc>
 76a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76c:	00000b97          	auipc	s7,0x0
 770:	2c4b8b93          	addi	s7,s7,708 # a30 <digits>
 774:	03c9d793          	srli	a5,s3,0x3c
 778:	97de                	add	a5,a5,s7
 77a:	0007c583          	lbu	a1,0(a5)
 77e:	855a                	mv	a0,s6
 780:	d13ff0ef          	jal	492 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 784:	0992                	slli	s3,s3,0x4
 786:	397d                	addiw	s2,s2,-1
 788:	fe0916e3          	bnez	s2,774 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 78c:	8bea                	mv	s7,s10
      state = 0;
 78e:	4981                	li	s3,0
 790:	6d02                	ld	s10,0(sp)
 792:	bd01                	j	5a2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 794:	008b8913          	addi	s2,s7,8
 798:	000bc583          	lbu	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	cf5ff0ef          	jal	492 <putc>
 7a2:	8bca                	mv	s7,s2
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	bbf5                	j	5a2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7a8:	008b8993          	addi	s3,s7,8
 7ac:	000bb903          	ld	s2,0(s7)
 7b0:	00090f63          	beqz	s2,7ce <vprintf+0x276>
        for(; *s; s++)
 7b4:	00094583          	lbu	a1,0(s2)
 7b8:	c195                	beqz	a1,7dc <vprintf+0x284>
          putc(fd, *s);
 7ba:	855a                	mv	a0,s6
 7bc:	cd7ff0ef          	jal	492 <putc>
        for(; *s; s++)
 7c0:	0905                	addi	s2,s2,1
 7c2:	00094583          	lbu	a1,0(s2)
 7c6:	f9f5                	bnez	a1,7ba <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7c8:	8bce                	mv	s7,s3
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bbd9                	j	5a2 <vprintf+0x4a>
          s = "(null)";
 7ce:	00000917          	auipc	s2,0x0
 7d2:	25a90913          	addi	s2,s2,602 # a28 <malloc+0x14e>
        for(; *s; s++)
 7d6:	02800593          	li	a1,40
 7da:	b7c5                	j	7ba <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7dc:	8bce                	mv	s7,s3
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b3c9                	j	5a2 <vprintf+0x4a>
 7e2:	64a6                	ld	s1,72(sp)
 7e4:	79e2                	ld	s3,56(sp)
 7e6:	7a42                	ld	s4,48(sp)
 7e8:	7aa2                	ld	s5,40(sp)
 7ea:	7b02                	ld	s6,32(sp)
 7ec:	6be2                	ld	s7,24(sp)
 7ee:	6c42                	ld	s8,16(sp)
 7f0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7f2:	60e6                	ld	ra,88(sp)
 7f4:	6446                	ld	s0,80(sp)
 7f6:	6906                	ld	s2,64(sp)
 7f8:	6125                	addi	sp,sp,96
 7fa:	8082                	ret

00000000000007fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fc:	715d                	addi	sp,sp,-80
 7fe:	ec06                	sd	ra,24(sp)
 800:	e822                	sd	s0,16(sp)
 802:	1000                	addi	s0,sp,32
 804:	e010                	sd	a2,0(s0)
 806:	e414                	sd	a3,8(s0)
 808:	e818                	sd	a4,16(s0)
 80a:	ec1c                	sd	a5,24(s0)
 80c:	03043023          	sd	a6,32(s0)
 810:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 814:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 818:	8622                	mv	a2,s0
 81a:	d3fff0ef          	jal	558 <vprintf>
}
 81e:	60e2                	ld	ra,24(sp)
 820:	6442                	ld	s0,16(sp)
 822:	6161                	addi	sp,sp,80
 824:	8082                	ret

0000000000000826 <printf>:

void
printf(const char *fmt, ...)
{
 826:	711d                	addi	sp,sp,-96
 828:	ec06                	sd	ra,24(sp)
 82a:	e822                	sd	s0,16(sp)
 82c:	1000                	addi	s0,sp,32
 82e:	e40c                	sd	a1,8(s0)
 830:	e810                	sd	a2,16(s0)
 832:	ec14                	sd	a3,24(s0)
 834:	f018                	sd	a4,32(s0)
 836:	f41c                	sd	a5,40(s0)
 838:	03043823          	sd	a6,48(s0)
 83c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 840:	00840613          	addi	a2,s0,8
 844:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 848:	85aa                	mv	a1,a0
 84a:	4505                	li	a0,1
 84c:	d0dff0ef          	jal	558 <vprintf>
}
 850:	60e2                	ld	ra,24(sp)
 852:	6442                	ld	s0,16(sp)
 854:	6125                	addi	sp,sp,96
 856:	8082                	ret

0000000000000858 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 858:	1141                	addi	sp,sp,-16
 85a:	e422                	sd	s0,8(sp)
 85c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 85e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	00000797          	auipc	a5,0x0
 866:	79e7b783          	ld	a5,1950(a5) # 1000 <freep>
 86a:	a02d                	j	894 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 86c:	4618                	lw	a4,8(a2)
 86e:	9f2d                	addw	a4,a4,a1
 870:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 874:	6398                	ld	a4,0(a5)
 876:	6310                	ld	a2,0(a4)
 878:	a83d                	j	8b6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 87a:	ff852703          	lw	a4,-8(a0)
 87e:	9f31                	addw	a4,a4,a2
 880:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 882:	ff053683          	ld	a3,-16(a0)
 886:	a091                	j	8ca <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 888:	6398                	ld	a4,0(a5)
 88a:	00e7e463          	bltu	a5,a4,892 <free+0x3a>
 88e:	00e6ea63          	bltu	a3,a4,8a2 <free+0x4a>
{
 892:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 894:	fed7fae3          	bgeu	a5,a3,888 <free+0x30>
 898:	6398                	ld	a4,0(a5)
 89a:	00e6e463          	bltu	a3,a4,8a2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	fee7eae3          	bltu	a5,a4,892 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8a2:	ff852583          	lw	a1,-8(a0)
 8a6:	6390                	ld	a2,0(a5)
 8a8:	02059813          	slli	a6,a1,0x20
 8ac:	01c85713          	srli	a4,a6,0x1c
 8b0:	9736                	add	a4,a4,a3
 8b2:	fae60de3          	beq	a2,a4,86c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ba:	4790                	lw	a2,8(a5)
 8bc:	02061593          	slli	a1,a2,0x20
 8c0:	01c5d713          	srli	a4,a1,0x1c
 8c4:	973e                	add	a4,a4,a5
 8c6:	fae68ae3          	beq	a3,a4,87a <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8cc:	00000717          	auipc	a4,0x0
 8d0:	72f73a23          	sd	a5,1844(a4) # 1000 <freep>
}
 8d4:	6422                	ld	s0,8(sp)
 8d6:	0141                	addi	sp,sp,16
 8d8:	8082                	ret

00000000000008da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8da:	7139                	addi	sp,sp,-64
 8dc:	fc06                	sd	ra,56(sp)
 8de:	f822                	sd	s0,48(sp)
 8e0:	f426                	sd	s1,40(sp)
 8e2:	ec4e                	sd	s3,24(sp)
 8e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e6:	02051493          	slli	s1,a0,0x20
 8ea:	9081                	srli	s1,s1,0x20
 8ec:	04bd                	addi	s1,s1,15
 8ee:	8091                	srli	s1,s1,0x4
 8f0:	0014899b          	addiw	s3,s1,1
 8f4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8f6:	00000517          	auipc	a0,0x0
 8fa:	70a53503          	ld	a0,1802(a0) # 1000 <freep>
 8fe:	c915                	beqz	a0,932 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 900:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 902:	4798                	lw	a4,8(a5)
 904:	08977a63          	bgeu	a4,s1,998 <malloc+0xbe>
 908:	f04a                	sd	s2,32(sp)
 90a:	e852                	sd	s4,16(sp)
 90c:	e456                	sd	s5,8(sp)
 90e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 910:	8a4e                	mv	s4,s3
 912:	0009871b          	sext.w	a4,s3
 916:	6685                	lui	a3,0x1
 918:	00d77363          	bgeu	a4,a3,91e <malloc+0x44>
 91c:	6a05                	lui	s4,0x1
 91e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 922:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 926:	00000917          	auipc	s2,0x0
 92a:	6da90913          	addi	s2,s2,1754 # 1000 <freep>
  if(p == SBRK_ERROR)
 92e:	5afd                	li	s5,-1
 930:	a081                	j	970 <malloc+0x96>
 932:	f04a                	sd	s2,32(sp)
 934:	e852                	sd	s4,16(sp)
 936:	e456                	sd	s5,8(sp)
 938:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 93a:	00001797          	auipc	a5,0x1
 93e:	8d678793          	addi	a5,a5,-1834 # 1210 <base>
 942:	00000717          	auipc	a4,0x0
 946:	6af73f23          	sd	a5,1726(a4) # 1000 <freep>
 94a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 950:	b7c1                	j	910 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 952:	6398                	ld	a4,0(a5)
 954:	e118                	sd	a4,0(a0)
 956:	a8a9                	j	9b0 <malloc+0xd6>
  hp->s.size = nu;
 958:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 95c:	0541                	addi	a0,a0,16
 95e:	efbff0ef          	jal	858 <free>
  return freep;
 962:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 966:	c12d                	beqz	a0,9c8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96a:	4798                	lw	a4,8(a5)
 96c:	02977263          	bgeu	a4,s1,990 <malloc+0xb6>
    if(p == freep)
 970:	00093703          	ld	a4,0(s2)
 974:	853e                	mv	a0,a5
 976:	fef719e3          	bne	a4,a5,968 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 97a:	8552                	mv	a0,s4
 97c:	a43ff0ef          	jal	3be <sbrk>
  if(p == SBRK_ERROR)
 980:	fd551ce3          	bne	a0,s5,958 <malloc+0x7e>
        return 0;
 984:	4501                	li	a0,0
 986:	7902                	ld	s2,32(sp)
 988:	6a42                	ld	s4,16(sp)
 98a:	6aa2                	ld	s5,8(sp)
 98c:	6b02                	ld	s6,0(sp)
 98e:	a03d                	j	9bc <malloc+0xe2>
 990:	7902                	ld	s2,32(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 998:	fae48de3          	beq	s1,a4,952 <malloc+0x78>
        p->s.size -= nunits;
 99c:	4137073b          	subw	a4,a4,s3
 9a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a2:	02071693          	slli	a3,a4,0x20
 9a6:	01c6d713          	srli	a4,a3,0x1c
 9aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b0:	00000717          	auipc	a4,0x0
 9b4:	64a73823          	sd	a0,1616(a4) # 1000 <freep>
      return (void*)(p + 1);
 9b8:	01078513          	addi	a0,a5,16
  }
}
 9bc:	70e2                	ld	ra,56(sp)
 9be:	7442                	ld	s0,48(sp)
 9c0:	74a2                	ld	s1,40(sp)
 9c2:	69e2                	ld	s3,24(sp)
 9c4:	6121                	addi	sp,sp,64
 9c6:	8082                	ret
 9c8:	7902                	ld	s2,32(sp)
 9ca:	6a42                	ld	s4,16(sp)
 9cc:	6aa2                	ld	s5,8(sp)
 9ce:	6b02                	ld	s6,0(sp)
 9d0:	b7f5                	j	9bc <malloc+0xe2>
