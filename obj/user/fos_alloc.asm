
obj/user/fos_alloc:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 e7 0f 00 00       	call   801037 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 20 23 80 00       	push   $0x802320
  800061:	e8 74 02 00 00       	call   8002da <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 33 23 80 00       	push   $0x802333
  8000be:	e8 17 02 00 00       	call   8002da <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 fd 18 00 00       	call   8019d9 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 4d 0f 00 00       	call   801037 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 33 23 80 00       	push   $0x802333
  800114:	e8 c1 01 00 00       	call   8002da <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 a7 18 00 00       	call   8019d9 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800142:	7e 0a                	jle    80014e <libmain+0x16>
		binaryname = argv[0];
  800144:	8b 45 0c             	mov    0xc(%ebp),%eax
  800147:	8b 00                	mov    (%eax),%eax
  800149:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	ff 75 0c             	pushl  0xc(%ebp)
  800154:	ff 75 08             	pushl  0x8(%ebp)
  800157:	e8 dc fe ff ff       	call   800038 <_main>
  80015c:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80015f:	e8 f1 19 00 00       	call   801b55 <sys_getenvid>
  800164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800167:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80016a:	89 d0                	mov    %edx,%eax
  80016c:	c1 e0 03             	shl    $0x3,%eax
  80016f:	01 d0                	add    %edx,%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	01 d0                	add    %edx,%eax
  800175:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80017c:	01 d0                	add    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800186:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800189:	e8 15 1b 00 00       	call   801ca3 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	68 58 23 80 00       	push   $0x802358
  800196:	e8 19 01 00 00       	call   8002b4 <cprintf>
  80019b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80019e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001a1:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	50                   	push   %eax
  8001ab:	68 80 23 80 00       	push   $0x802380
  8001b0:	e8 ff 00 00 00       	call   8002b4 <cprintf>
  8001b5:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 58 23 80 00       	push   $0x802358
  8001c0:	e8 ef 00 00 00       	call   8002b4 <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001c8:	e8 f0 1a 00 00       	call   801cbd <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001cd:	e8 19 00 00 00       	call   8001eb <exit>
}
  8001d2:	90                   	nop
  8001d3:	c9                   	leave  
  8001d4:	c3                   	ret    

008001d5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8001db:	83 ec 0c             	sub    $0xc,%esp
  8001de:	6a 00                	push   $0x0
  8001e0:	e8 55 19 00 00       	call   801b3a <sys_env_destroy>
  8001e5:	83 c4 10             	add    $0x10,%esp
}
  8001e8:	90                   	nop
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <exit>:

void
exit(void)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8001f1:	e8 78 19 00 00       	call   801b6e <sys_env_exit>
}
  8001f6:	90                   	nop
  8001f7:	c9                   	leave  
  8001f8:	c3                   	ret    

008001f9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800202:	8b 00                	mov    (%eax),%eax
  800204:	8d 48 01             	lea    0x1(%eax),%ecx
  800207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020a:	89 0a                	mov    %ecx,(%edx)
  80020c:	8b 55 08             	mov    0x8(%ebp),%edx
  80020f:	88 d1                	mov    %dl,%cl
  800211:	8b 55 0c             	mov    0xc(%ebp),%edx
  800214:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021b:	8b 00                	mov    (%eax),%eax
  80021d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800222:	75 23                	jne    800247 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800224:	8b 45 0c             	mov    0xc(%ebp),%eax
  800227:	8b 00                	mov    (%eax),%eax
  800229:	89 c2                	mov    %eax,%edx
  80022b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022e:	83 c0 08             	add    $0x8,%eax
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	e8 c9 18 00 00       	call   801b04 <sys_cputs>
  80023b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80023e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024a:	8b 40 04             	mov    0x4(%eax),%eax
  80024d:	8d 50 01             	lea    0x1(%eax),%edx
  800250:	8b 45 0c             	mov    0xc(%ebp),%eax
  800253:	89 50 04             	mov    %edx,0x4(%eax)
}
  800256:	90                   	nop
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800262:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800269:	00 00 00 
	b.cnt = 0;
  80026c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800273:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800276:	ff 75 0c             	pushl  0xc(%ebp)
  800279:	ff 75 08             	pushl  0x8(%ebp)
  80027c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800282:	50                   	push   %eax
  800283:	68 f9 01 80 00       	push   $0x8001f9
  800288:	e8 fa 01 00 00       	call   800487 <vprintfmt>
  80028d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800290:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	50                   	push   %eax
  80029a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a0:	83 c0 08             	add    $0x8,%eax
  8002a3:	50                   	push   %eax
  8002a4:	e8 5b 18 00 00       	call   801b04 <sys_cputs>
  8002a9:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8002ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	e8 8a ff ff ff       	call   800259 <vcprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
  8002d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002e0:	e8 be 19 00 00       	call   801ca3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f4:	50                   	push   %eax
  8002f5:	e8 5f ff ff ff       	call   800259 <vcprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800300:	e8 b8 19 00 00       	call   801cbd <sys_enable_interrupt>
	return cnt;
  800305:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800308:	c9                   	leave  
  800309:	c3                   	ret    

0080030a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	53                   	push   %ebx
  80030e:	83 ec 14             	sub    $0x14,%esp
  800311:	8b 45 10             	mov    0x10(%ebp),%eax
  800314:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800317:	8b 45 14             	mov    0x14(%ebp),%eax
  80031a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80031d:	8b 45 18             	mov    0x18(%ebp),%eax
  800320:	ba 00 00 00 00       	mov    $0x0,%edx
  800325:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800328:	77 55                	ja     80037f <printnum+0x75>
  80032a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80032d:	72 05                	jb     800334 <printnum+0x2a>
  80032f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800332:	77 4b                	ja     80037f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800334:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800337:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80033a:	8b 45 18             	mov    0x18(%ebp),%eax
  80033d:	ba 00 00 00 00       	mov    $0x0,%edx
  800342:	52                   	push   %edx
  800343:	50                   	push   %eax
  800344:	ff 75 f4             	pushl  -0xc(%ebp)
  800347:	ff 75 f0             	pushl  -0x10(%ebp)
  80034a:	e8 61 1d 00 00       	call   8020b0 <__udivdi3>
  80034f:	83 c4 10             	add    $0x10,%esp
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	ff 75 20             	pushl  0x20(%ebp)
  800358:	53                   	push   %ebx
  800359:	ff 75 18             	pushl  0x18(%ebp)
  80035c:	52                   	push   %edx
  80035d:	50                   	push   %eax
  80035e:	ff 75 0c             	pushl  0xc(%ebp)
  800361:	ff 75 08             	pushl  0x8(%ebp)
  800364:	e8 a1 ff ff ff       	call   80030a <printnum>
  800369:	83 c4 20             	add    $0x20,%esp
  80036c:	eb 1a                	jmp    800388 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	ff 75 0c             	pushl  0xc(%ebp)
  800374:	ff 75 20             	pushl  0x20(%ebp)
  800377:	8b 45 08             	mov    0x8(%ebp),%eax
  80037a:	ff d0                	call   *%eax
  80037c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80037f:	ff 4d 1c             	decl   0x1c(%ebp)
  800382:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800386:	7f e6                	jg     80036e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800388:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80038b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800396:	53                   	push   %ebx
  800397:	51                   	push   %ecx
  800398:	52                   	push   %edx
  800399:	50                   	push   %eax
  80039a:	e8 21 1e 00 00       	call   8021c0 <__umoddi3>
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	05 b4 25 80 00       	add    $0x8025b4,%eax
  8003a7:	8a 00                	mov    (%eax),%al
  8003a9:	0f be c0             	movsbl %al,%eax
  8003ac:	83 ec 08             	sub    $0x8,%esp
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	50                   	push   %eax
  8003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b6:	ff d0                	call   *%eax
  8003b8:	83 c4 10             	add    $0x10,%esp
}
  8003bb:	90                   	nop
  8003bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003bf:	c9                   	leave  
  8003c0:	c3                   	ret    

008003c1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c1:	55                   	push   %ebp
  8003c2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003c8:	7e 1c                	jle    8003e6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	8d 50 08             	lea    0x8(%eax),%edx
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	89 10                	mov    %edx,(%eax)
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	83 e8 08             	sub    $0x8,%eax
  8003df:	8b 50 04             	mov    0x4(%eax),%edx
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	eb 40                	jmp    800426 <getuint+0x65>
	else if (lflag)
  8003e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003ea:	74 1e                	je     80040a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	8d 50 04             	lea    0x4(%eax),%edx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	89 10                	mov    %edx,(%eax)
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	83 e8 04             	sub    $0x4,%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	ba 00 00 00 00       	mov    $0x0,%edx
  800408:	eb 1c                	jmp    800426 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	8d 50 04             	lea    0x4(%eax),%edx
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	89 10                	mov    %edx,(%eax)
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	83 e8 04             	sub    $0x4,%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800426:	5d                   	pop    %ebp
  800427:	c3                   	ret    

00800428 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80042b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80042f:	7e 1c                	jle    80044d <getint+0x25>
		return va_arg(*ap, long long);
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	8d 50 08             	lea    0x8(%eax),%edx
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	89 10                	mov    %edx,(%eax)
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	83 e8 08             	sub    $0x8,%eax
  800446:	8b 50 04             	mov    0x4(%eax),%edx
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	eb 38                	jmp    800485 <getint+0x5d>
	else if (lflag)
  80044d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800451:	74 1a                	je     80046d <getint+0x45>
		return va_arg(*ap, long);
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 04             	lea    0x4(%eax),%edx
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	83 e8 04             	sub    $0x4,%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	99                   	cltd   
  80046b:	eb 18                	jmp    800485 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	8d 50 04             	lea    0x4(%eax),%edx
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	89 10                	mov    %edx,(%eax)
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	83 e8 04             	sub    $0x4,%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	99                   	cltd   
}
  800485:	5d                   	pop    %ebp
  800486:	c3                   	ret    

00800487 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	56                   	push   %esi
  80048b:	53                   	push   %ebx
  80048c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80048f:	eb 17                	jmp    8004a8 <vprintfmt+0x21>
			if (ch == '\0')
  800491:	85 db                	test   %ebx,%ebx
  800493:	0f 84 af 03 00 00    	je     800848 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	ff 75 0c             	pushl  0xc(%ebp)
  80049f:	53                   	push   %ebx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	ff d0                	call   *%eax
  8004a5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ab:	8d 50 01             	lea    0x1(%eax),%edx
  8004ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8004b1:	8a 00                	mov    (%eax),%al
  8004b3:	0f b6 d8             	movzbl %al,%ebx
  8004b6:	83 fb 25             	cmp    $0x25,%ebx
  8004b9:	75 d6                	jne    800491 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004bb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004bf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004d4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004db:	8b 45 10             	mov    0x10(%ebp),%eax
  8004de:	8d 50 01             	lea    0x1(%eax),%edx
  8004e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8004e4:	8a 00                	mov    (%eax),%al
  8004e6:	0f b6 d8             	movzbl %al,%ebx
  8004e9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004ec:	83 f8 55             	cmp    $0x55,%eax
  8004ef:	0f 87 2b 03 00 00    	ja     800820 <vprintfmt+0x399>
  8004f5:	8b 04 85 d8 25 80 00 	mov    0x8025d8(,%eax,4),%eax
  8004fc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004fe:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800502:	eb d7                	jmp    8004db <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800504:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800508:	eb d1                	jmp    8004db <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80050a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800511:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800514:	89 d0                	mov    %edx,%eax
  800516:	c1 e0 02             	shl    $0x2,%eax
  800519:	01 d0                	add    %edx,%eax
  80051b:	01 c0                	add    %eax,%eax
  80051d:	01 d8                	add    %ebx,%eax
  80051f:	83 e8 30             	sub    $0x30,%eax
  800522:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800525:	8b 45 10             	mov    0x10(%ebp),%eax
  800528:	8a 00                	mov    (%eax),%al
  80052a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80052d:	83 fb 2f             	cmp    $0x2f,%ebx
  800530:	7e 3e                	jle    800570 <vprintfmt+0xe9>
  800532:	83 fb 39             	cmp    $0x39,%ebx
  800535:	7f 39                	jg     800570 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800537:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80053a:	eb d5                	jmp    800511 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	83 c0 04             	add    $0x4,%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	8b 45 14             	mov    0x14(%ebp),%eax
  800548:	83 e8 04             	sub    $0x4,%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800550:	eb 1f                	jmp    800571 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800552:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800556:	79 83                	jns    8004db <vprintfmt+0x54>
				width = 0;
  800558:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80055f:	e9 77 ff ff ff       	jmp    8004db <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800564:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80056b:	e9 6b ff ff ff       	jmp    8004db <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800570:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800571:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800575:	0f 89 60 ff ff ff    	jns    8004db <vprintfmt+0x54>
				width = precision, precision = -1;
  80057b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800581:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800588:	e9 4e ff ff ff       	jmp    8004db <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80058d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800590:	e9 46 ff ff ff       	jmp    8004db <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	83 c0 04             	add    $0x4,%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	83 e8 04             	sub    $0x4,%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ac:	50                   	push   %eax
  8005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b0:	ff d0                	call   *%eax
  8005b2:	83 c4 10             	add    $0x10,%esp
			break;
  8005b5:	e9 89 02 00 00       	jmp    800843 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	83 c0 04             	add    $0x4,%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	83 e8 04             	sub    $0x4,%eax
  8005c9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005cb:	85 db                	test   %ebx,%ebx
  8005cd:	79 02                	jns    8005d1 <vprintfmt+0x14a>
				err = -err;
  8005cf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005d1:	83 fb 64             	cmp    $0x64,%ebx
  8005d4:	7f 0b                	jg     8005e1 <vprintfmt+0x15a>
  8005d6:	8b 34 9d 20 24 80 00 	mov    0x802420(,%ebx,4),%esi
  8005dd:	85 f6                	test   %esi,%esi
  8005df:	75 19                	jne    8005fa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005e1:	53                   	push   %ebx
  8005e2:	68 c5 25 80 00       	push   $0x8025c5
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 5e 02 00 00       	call   800850 <printfmt>
  8005f2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005f5:	e9 49 02 00 00       	jmp    800843 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005fa:	56                   	push   %esi
  8005fb:	68 ce 25 80 00       	push   $0x8025ce
  800600:	ff 75 0c             	pushl  0xc(%ebp)
  800603:	ff 75 08             	pushl  0x8(%ebp)
  800606:	e8 45 02 00 00       	call   800850 <printfmt>
  80060b:	83 c4 10             	add    $0x10,%esp
			break;
  80060e:	e9 30 02 00 00       	jmp    800843 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 c0 04             	add    $0x4,%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	83 e8 04             	sub    $0x4,%eax
  800622:	8b 30                	mov    (%eax),%esi
  800624:	85 f6                	test   %esi,%esi
  800626:	75 05                	jne    80062d <vprintfmt+0x1a6>
				p = "(null)";
  800628:	be d1 25 80 00       	mov    $0x8025d1,%esi
			if (width > 0 && padc != '-')
  80062d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800631:	7e 6d                	jle    8006a0 <vprintfmt+0x219>
  800633:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800637:	74 67                	je     8006a0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800639:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	50                   	push   %eax
  800640:	56                   	push   %esi
  800641:	e8 0c 03 00 00       	call   800952 <strnlen>
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80064c:	eb 16                	jmp    800664 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80064e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	ff 75 0c             	pushl  0xc(%ebp)
  800658:	50                   	push   %eax
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	ff d0                	call   *%eax
  80065e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800661:	ff 4d e4             	decl   -0x1c(%ebp)
  800664:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800668:	7f e4                	jg     80064e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066a:	eb 34                	jmp    8006a0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80066c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800670:	74 1c                	je     80068e <vprintfmt+0x207>
  800672:	83 fb 1f             	cmp    $0x1f,%ebx
  800675:	7e 05                	jle    80067c <vprintfmt+0x1f5>
  800677:	83 fb 7e             	cmp    $0x7e,%ebx
  80067a:	7e 12                	jle    80068e <vprintfmt+0x207>
					putch('?', putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	ff 75 0c             	pushl  0xc(%ebp)
  800682:	6a 3f                	push   $0x3f
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	ff d0                	call   *%eax
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	eb 0f                	jmp    80069d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	53                   	push   %ebx
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	ff d0                	call   *%eax
  80069a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069d:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a0:	89 f0                	mov    %esi,%eax
  8006a2:	8d 70 01             	lea    0x1(%eax),%esi
  8006a5:	8a 00                	mov    (%eax),%al
  8006a7:	0f be d8             	movsbl %al,%ebx
  8006aa:	85 db                	test   %ebx,%ebx
  8006ac:	74 24                	je     8006d2 <vprintfmt+0x24b>
  8006ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b2:	78 b8                	js     80066c <vprintfmt+0x1e5>
  8006b4:	ff 4d e0             	decl   -0x20(%ebp)
  8006b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006bb:	79 af                	jns    80066c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006bd:	eb 13                	jmp    8006d2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	6a 20                	push   $0x20
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	ff d0                	call   *%eax
  8006cc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006cf:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d6:	7f e7                	jg     8006bf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006d8:	e9 66 01 00 00       	jmp    800843 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8006e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e6:	50                   	push   %eax
  8006e7:	e8 3c fd ff ff       	call   800428 <getint>
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006fb:	85 d2                	test   %edx,%edx
  8006fd:	79 23                	jns    800722 <vprintfmt+0x29b>
				putch('-', putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	6a 2d                	push   $0x2d
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	ff d0                	call   *%eax
  80070c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80070f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800712:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800715:	f7 d8                	neg    %eax
  800717:	83 d2 00             	adc    $0x0,%edx
  80071a:	f7 da                	neg    %edx
  80071c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800722:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800729:	e9 bc 00 00 00       	jmp    8007ea <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	ff 75 e8             	pushl  -0x18(%ebp)
  800734:	8d 45 14             	lea    0x14(%ebp),%eax
  800737:	50                   	push   %eax
  800738:	e8 84 fc ff ff       	call   8003c1 <getuint>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800743:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800746:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80074d:	e9 98 00 00 00       	jmp    8007ea <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	6a 58                	push   $0x58
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	ff 75 0c             	pushl  0xc(%ebp)
  800768:	6a 58                	push   $0x58
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	ff d0                	call   *%eax
  80076f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	6a 58                	push   $0x58
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
			break;
  800782:	e9 bc 00 00 00       	jmp    800843 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 0c             	pushl  0xc(%ebp)
  80078d:	6a 30                	push   $0x30
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	ff d0                	call   *%eax
  800794:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	6a 78                	push   $0x78
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	ff d0                	call   *%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 c0 04             	add    $0x4,%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007c2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007c9:	eb 1f                	jmp    8007ea <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d4:	50                   	push   %eax
  8007d5:	e8 e7 fb ff ff       	call   8003c1 <getuint>
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007e3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007ea:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f1:	83 ec 04             	sub    $0x4,%esp
  8007f4:	52                   	push   %edx
  8007f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007f8:	50                   	push   %eax
  8007f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	ff 75 08             	pushl  0x8(%ebp)
  800805:	e8 00 fb ff ff       	call   80030a <printnum>
  80080a:	83 c4 20             	add    $0x20,%esp
			break;
  80080d:	eb 34                	jmp    800843 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	ff 75 0c             	pushl  0xc(%ebp)
  800815:	53                   	push   %ebx
  800816:	8b 45 08             	mov    0x8(%ebp),%eax
  800819:	ff d0                	call   *%eax
  80081b:	83 c4 10             	add    $0x10,%esp
			break;
  80081e:	eb 23                	jmp    800843 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 25                	push   $0x25
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800830:	ff 4d 10             	decl   0x10(%ebp)
  800833:	eb 03                	jmp    800838 <vprintfmt+0x3b1>
  800835:	ff 4d 10             	decl   0x10(%ebp)
  800838:	8b 45 10             	mov    0x10(%ebp),%eax
  80083b:	48                   	dec    %eax
  80083c:	8a 00                	mov    (%eax),%al
  80083e:	3c 25                	cmp    $0x25,%al
  800840:	75 f3                	jne    800835 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800842:	90                   	nop
		}
	}
  800843:	e9 47 fc ff ff       	jmp    80048f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800848:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800849:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80084c:	5b                   	pop    %ebx
  80084d:	5e                   	pop    %esi
  80084e:	5d                   	pop    %ebp
  80084f:	c3                   	ret    

00800850 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800856:	8d 45 10             	lea    0x10(%ebp),%eax
  800859:	83 c0 04             	add    $0x4,%eax
  80085c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80085f:	8b 45 10             	mov    0x10(%ebp),%eax
  800862:	ff 75 f4             	pushl  -0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	ff 75 08             	pushl  0x8(%ebp)
  80086c:	e8 16 fc ff ff       	call   800487 <vprintfmt>
  800871:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800874:	90                   	nop
  800875:	c9                   	leave  
  800876:	c3                   	ret    

00800877 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80087a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087d:	8b 40 08             	mov    0x8(%eax),%eax
  800880:	8d 50 01             	lea    0x1(%eax),%edx
  800883:	8b 45 0c             	mov    0xc(%ebp),%eax
  800886:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088c:	8b 10                	mov    (%eax),%edx
  80088e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800891:	8b 40 04             	mov    0x4(%eax),%eax
  800894:	39 c2                	cmp    %eax,%edx
  800896:	73 12                	jae    8008aa <sprintputch+0x33>
		*b->buf++ = ch;
  800898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a3:	89 0a                	mov    %ecx,(%edx)
  8008a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a8:	88 10                	mov    %dl,(%eax)
}
  8008aa:	90                   	nop
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    

008008ad <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	01 d0                	add    %edx,%eax
  8008c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008d2:	74 06                	je     8008da <vsnprintf+0x2d>
  8008d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d8:	7f 07                	jg     8008e1 <vsnprintf+0x34>
		return -E_INVAL;
  8008da:	b8 03 00 00 00       	mov    $0x3,%eax
  8008df:	eb 20                	jmp    800901 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e1:	ff 75 14             	pushl  0x14(%ebp)
  8008e4:	ff 75 10             	pushl  0x10(%ebp)
  8008e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	68 77 08 80 00       	push   $0x800877
  8008f0:	e8 92 fb ff ff       	call   800487 <vprintfmt>
  8008f5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800901:	c9                   	leave  
  800902:	c3                   	ret    

00800903 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800909:	8d 45 10             	lea    0x10(%ebp),%eax
  80090c:	83 c0 04             	add    $0x4,%eax
  80090f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800912:	8b 45 10             	mov    0x10(%ebp),%eax
  800915:	ff 75 f4             	pushl  -0xc(%ebp)
  800918:	50                   	push   %eax
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	e8 89 ff ff ff       	call   8008ad <vsnprintf>
  800924:	83 c4 10             	add    $0x10,%esp
  800927:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80092a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    

0080092f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800935:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80093c:	eb 06                	jmp    800944 <strlen+0x15>
		n++;
  80093e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800941:	ff 45 08             	incl   0x8(%ebp)
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8a 00                	mov    (%eax),%al
  800949:	84 c0                	test   %al,%al
  80094b:	75 f1                	jne    80093e <strlen+0xf>
		n++;
	return n;
  80094d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800950:	c9                   	leave  
  800951:	c3                   	ret    

00800952 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800958:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80095f:	eb 09                	jmp    80096a <strnlen+0x18>
		n++;
  800961:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800964:	ff 45 08             	incl   0x8(%ebp)
  800967:	ff 4d 0c             	decl   0xc(%ebp)
  80096a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80096e:	74 09                	je     800979 <strnlen+0x27>
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8a 00                	mov    (%eax),%al
  800975:	84 c0                	test   %al,%al
  800977:	75 e8                	jne    800961 <strnlen+0xf>
		n++;
	return n;
  800979:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80098a:	90                   	nop
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8d 50 01             	lea    0x1(%eax),%edx
  800991:	89 55 08             	mov    %edx,0x8(%ebp)
  800994:	8b 55 0c             	mov    0xc(%ebp),%edx
  800997:	8d 4a 01             	lea    0x1(%edx),%ecx
  80099a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80099d:	8a 12                	mov    (%edx),%dl
  80099f:	88 10                	mov    %dl,(%eax)
  8009a1:	8a 00                	mov    (%eax),%al
  8009a3:	84 c0                	test   %al,%al
  8009a5:	75 e4                	jne    80098b <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009aa:	c9                   	leave  
  8009ab:	c3                   	ret    

008009ac <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009bf:	eb 1f                	jmp    8009e0 <strncpy+0x34>
		*dst++ = *src;
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8d 50 01             	lea    0x1(%eax),%edx
  8009c7:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cd:	8a 12                	mov    (%edx),%dl
  8009cf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	8a 00                	mov    (%eax),%al
  8009d6:	84 c0                	test   %al,%al
  8009d8:	74 03                	je     8009dd <strncpy+0x31>
			src++;
  8009da:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009dd:	ff 45 fc             	incl   -0x4(%ebp)
  8009e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009e3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009e6:	72 d9                	jb     8009c1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009fd:	74 30                	je     800a2f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009ff:	eb 16                	jmp    800a17 <strlcpy+0x2a>
			*dst++ = *src++;
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8d 50 01             	lea    0x1(%eax),%edx
  800a07:	89 55 08             	mov    %edx,0x8(%ebp)
  800a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a10:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a13:	8a 12                	mov    (%edx),%dl
  800a15:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a17:	ff 4d 10             	decl   0x10(%ebp)
  800a1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a1e:	74 09                	je     800a29 <strlcpy+0x3c>
  800a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a23:	8a 00                	mov    (%eax),%al
  800a25:	84 c0                	test   %al,%al
  800a27:	75 d8                	jne    800a01 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a35:	29 c2                	sub    %eax,%edx
  800a37:	89 d0                	mov    %edx,%eax
}
  800a39:	c9                   	leave  
  800a3a:	c3                   	ret    

00800a3b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a3e:	eb 06                	jmp    800a46 <strcmp+0xb>
		p++, q++;
  800a40:	ff 45 08             	incl   0x8(%ebp)
  800a43:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	84 c0                	test   %al,%al
  800a4d:	74 0e                	je     800a5d <strcmp+0x22>
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8a 10                	mov    (%eax),%dl
  800a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a57:	8a 00                	mov    (%eax),%al
  800a59:	38 c2                	cmp    %al,%dl
  800a5b:	74 e3                	je     800a40 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	8a 00                	mov    (%eax),%al
  800a62:	0f b6 d0             	movzbl %al,%edx
  800a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a68:	8a 00                	mov    (%eax),%al
  800a6a:	0f b6 c0             	movzbl %al,%eax
  800a6d:	29 c2                	sub    %eax,%edx
  800a6f:	89 d0                	mov    %edx,%eax
}
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a76:	eb 09                	jmp    800a81 <strncmp+0xe>
		n--, p++, q++;
  800a78:	ff 4d 10             	decl   0x10(%ebp)
  800a7b:	ff 45 08             	incl   0x8(%ebp)
  800a7e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a85:	74 17                	je     800a9e <strncmp+0x2b>
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8a 00                	mov    (%eax),%al
  800a8c:	84 c0                	test   %al,%al
  800a8e:	74 0e                	je     800a9e <strncmp+0x2b>
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8a 10                	mov    (%eax),%dl
  800a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a98:	8a 00                	mov    (%eax),%al
  800a9a:	38 c2                	cmp    %al,%dl
  800a9c:	74 da                	je     800a78 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa2:	75 07                	jne    800aab <strncmp+0x38>
		return 0;
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa9:	eb 14                	jmp    800abf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8a 00                	mov    (%eax),%al
  800ab0:	0f b6 d0             	movzbl %al,%edx
  800ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab6:	8a 00                	mov    (%eax),%al
  800ab8:	0f b6 c0             	movzbl %al,%eax
  800abb:	29 c2                	sub    %eax,%edx
  800abd:	89 d0                	mov    %edx,%eax
}
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	83 ec 04             	sub    $0x4,%esp
  800ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aca:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800acd:	eb 12                	jmp    800ae1 <strchr+0x20>
		if (*s == c)
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8a 00                	mov    (%eax),%al
  800ad4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ad7:	75 05                	jne    800ade <strchr+0x1d>
			return (char *) s;
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	eb 11                	jmp    800aef <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ade:	ff 45 08             	incl   0x8(%ebp)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	84 c0                	test   %al,%al
  800ae8:	75 e5                	jne    800acf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aef:	c9                   	leave  
  800af0:	c3                   	ret    

00800af1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	83 ec 04             	sub    $0x4,%esp
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800afd:	eb 0d                	jmp    800b0c <strfind+0x1b>
		if (*s == c)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8a 00                	mov    (%eax),%al
  800b04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b07:	74 0e                	je     800b17 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b09:	ff 45 08             	incl   0x8(%ebp)
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8a 00                	mov    (%eax),%al
  800b11:	84 c0                	test   %al,%al
  800b13:	75 ea                	jne    800aff <strfind+0xe>
  800b15:	eb 01                	jmp    800b18 <strfind+0x27>
		if (*s == c)
			break;
  800b17:	90                   	nop
	return (char *) s;
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b1b:	c9                   	leave  
  800b1c:	c3                   	ret    

00800b1d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b29:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b2f:	eb 0e                	jmp    800b3f <memset+0x22>
		*p++ = c;
  800b31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b34:	8d 50 01             	lea    0x1(%eax),%edx
  800b37:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b3f:	ff 4d f8             	decl   -0x8(%ebp)
  800b42:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b46:	79 e9                	jns    800b31 <memset+0x14>
		*p++ = c;

	return v;
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b4b:	c9                   	leave  
  800b4c:	c3                   	ret    

00800b4d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b5f:	eb 16                	jmp    800b77 <memcpy+0x2a>
		*d++ = *s++;
  800b61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b64:	8d 50 01             	lea    0x1(%eax),%edx
  800b67:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b70:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b73:	8a 12                	mov    (%edx),%dl
  800b75:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b77:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7d:	89 55 10             	mov    %edx,0x10(%ebp)
  800b80:	85 c0                	test   %eax,%eax
  800b82:	75 dd                	jne    800b61 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b9e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ba1:	73 50                	jae    800bf3 <memmove+0x6a>
  800ba3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ba6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba9:	01 d0                	add    %edx,%eax
  800bab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bae:	76 43                	jbe    800bf3 <memmove+0x6a>
		s += n;
  800bb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bbc:	eb 10                	jmp    800bce <memmove+0x45>
			*--d = *--s;
  800bbe:	ff 4d f8             	decl   -0x8(%ebp)
  800bc1:	ff 4d fc             	decl   -0x4(%ebp)
  800bc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc7:	8a 10                	mov    (%eax),%dl
  800bc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bcc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bce:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd4:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	75 e3                	jne    800bbe <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bdb:	eb 23                	jmp    800c00 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be0:	8d 50 01             	lea    0x1(%eax),%edx
  800be3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800be6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800be9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bec:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bef:	8a 12                	mov    (%edx),%dl
  800bf1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bfc:	85 c0                	test   %eax,%eax
  800bfe:	75 dd                	jne    800bdd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    

00800c05 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c17:	eb 2a                	jmp    800c43 <memcmp+0x3e>
		if (*s1 != *s2)
  800c19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c1c:	8a 10                	mov    (%eax),%dl
  800c1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	38 c2                	cmp    %al,%dl
  800c25:	74 16                	je     800c3d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	0f b6 d0             	movzbl %al,%edx
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	0f b6 c0             	movzbl %al,%eax
  800c37:	29 c2                	sub    %eax,%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	eb 18                	jmp    800c55 <memcmp+0x50>
		s1++, s2++;
  800c3d:	ff 45 fc             	incl   -0x4(%ebp)
  800c40:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c43:	8b 45 10             	mov    0x10(%ebp),%eax
  800c46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c49:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4c:	85 c0                	test   %eax,%eax
  800c4e:	75 c9                	jne    800c19 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c60:	8b 45 10             	mov    0x10(%ebp),%eax
  800c63:	01 d0                	add    %edx,%eax
  800c65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c68:	eb 15                	jmp    800c7f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	0f b6 d0             	movzbl %al,%edx
  800c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c75:	0f b6 c0             	movzbl %al,%eax
  800c78:	39 c2                	cmp    %eax,%edx
  800c7a:	74 0d                	je     800c89 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c7c:	ff 45 08             	incl   0x8(%ebp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c85:	72 e3                	jb     800c6a <memfind+0x13>
  800c87:	eb 01                	jmp    800c8a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c89:	90                   	nop
	return (void *) s;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c9c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca3:	eb 03                	jmp    800ca8 <strtol+0x19>
		s++;
  800ca5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	3c 20                	cmp    $0x20,%al
  800caf:	74 f4                	je     800ca5 <strtol+0x16>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	3c 09                	cmp    $0x9,%al
  800cb8:	74 eb                	je     800ca5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	3c 2b                	cmp    $0x2b,%al
  800cc1:	75 05                	jne    800cc8 <strtol+0x39>
		s++;
  800cc3:	ff 45 08             	incl   0x8(%ebp)
  800cc6:	eb 13                	jmp    800cdb <strtol+0x4c>
	else if (*s == '-')
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	3c 2d                	cmp    $0x2d,%al
  800ccf:	75 0a                	jne    800cdb <strtol+0x4c>
		s++, neg = 1;
  800cd1:	ff 45 08             	incl   0x8(%ebp)
  800cd4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdf:	74 06                	je     800ce7 <strtol+0x58>
  800ce1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ce5:	75 20                	jne    800d07 <strtol+0x78>
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 30                	cmp    $0x30,%al
  800cee:	75 17                	jne    800d07 <strtol+0x78>
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	40                   	inc    %eax
  800cf4:	8a 00                	mov    (%eax),%al
  800cf6:	3c 78                	cmp    $0x78,%al
  800cf8:	75 0d                	jne    800d07 <strtol+0x78>
		s += 2, base = 16;
  800cfa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cfe:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d05:	eb 28                	jmp    800d2f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	75 15                	jne    800d22 <strtol+0x93>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	3c 30                	cmp    $0x30,%al
  800d14:	75 0c                	jne    800d22 <strtol+0x93>
		s++, base = 8;
  800d16:	ff 45 08             	incl   0x8(%ebp)
  800d19:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d20:	eb 0d                	jmp    800d2f <strtol+0xa0>
	else if (base == 0)
  800d22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d26:	75 07                	jne    800d2f <strtol+0xa0>
		base = 10;
  800d28:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	3c 2f                	cmp    $0x2f,%al
  800d36:	7e 19                	jle    800d51 <strtol+0xc2>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	3c 39                	cmp    $0x39,%al
  800d3f:	7f 10                	jg     800d51 <strtol+0xc2>
			dig = *s - '0';
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f be c0             	movsbl %al,%eax
  800d49:	83 e8 30             	sub    $0x30,%eax
  800d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d4f:	eb 42                	jmp    800d93 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	3c 60                	cmp    $0x60,%al
  800d58:	7e 19                	jle    800d73 <strtol+0xe4>
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	3c 7a                	cmp    $0x7a,%al
  800d61:	7f 10                	jg     800d73 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	0f be c0             	movsbl %al,%eax
  800d6b:	83 e8 57             	sub    $0x57,%eax
  800d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d71:	eb 20                	jmp    800d93 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	3c 40                	cmp    $0x40,%al
  800d7a:	7e 39                	jle    800db5 <strtol+0x126>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	3c 5a                	cmp    $0x5a,%al
  800d83:	7f 30                	jg     800db5 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f be c0             	movsbl %al,%eax
  800d8d:	83 e8 37             	sub    $0x37,%eax
  800d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d96:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d99:	7d 19                	jge    800db4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800daa:	01 d0                	add    %edx,%eax
  800dac:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800daf:	e9 7b ff ff ff       	jmp    800d2f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800db4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800db5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db9:	74 08                	je     800dc3 <strtol+0x134>
		*endptr = (char *) s;
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dc7:	74 07                	je     800dd0 <strtol+0x141>
  800dc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcc:	f7 d8                	neg    %eax
  800dce:	eb 03                	jmp    800dd3 <strtol+0x144>
  800dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dd3:	c9                   	leave  
  800dd4:	c3                   	ret    

00800dd5 <ltostr>:

void
ltostr(long value, char *str)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ddb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800de2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ded:	79 13                	jns    800e02 <ltostr+0x2d>
	{
		neg = 1;
  800def:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dfc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dff:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e0a:	99                   	cltd   
  800e0b:	f7 f9                	idiv   %ecx
  800e0d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e13:	8d 50 01             	lea    0x1(%eax),%edx
  800e16:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e19:	89 c2                	mov    %eax,%edx
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	01 d0                	add    %edx,%eax
  800e20:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e23:	83 c2 30             	add    $0x30,%edx
  800e26:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e2b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e30:	f7 e9                	imul   %ecx
  800e32:	c1 fa 02             	sar    $0x2,%edx
  800e35:	89 c8                	mov    %ecx,%eax
  800e37:	c1 f8 1f             	sar    $0x1f,%eax
  800e3a:	29 c2                	sub    %eax,%edx
  800e3c:	89 d0                	mov    %edx,%eax
  800e3e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e44:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e49:	f7 e9                	imul   %ecx
  800e4b:	c1 fa 02             	sar    $0x2,%edx
  800e4e:	89 c8                	mov    %ecx,%eax
  800e50:	c1 f8 1f             	sar    $0x1f,%eax
  800e53:	29 c2                	sub    %eax,%edx
  800e55:	89 d0                	mov    %edx,%eax
  800e57:	c1 e0 02             	shl    $0x2,%eax
  800e5a:	01 d0                	add    %edx,%eax
  800e5c:	01 c0                	add    %eax,%eax
  800e5e:	29 c1                	sub    %eax,%ecx
  800e60:	89 ca                	mov    %ecx,%edx
  800e62:	85 d2                	test   %edx,%edx
  800e64:	75 9c                	jne    800e02 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	48                   	dec    %eax
  800e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e78:	74 3d                	je     800eb7 <ltostr+0xe2>
		start = 1 ;
  800e7a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e81:	eb 34                	jmp    800eb7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	01 d0                	add    %edx,%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	01 c2                	add    %eax,%edx
  800e98:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	01 c8                	add    %ecx,%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ea4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	01 c2                	add    %eax,%edx
  800eac:	8a 45 eb             	mov    -0x15(%ebp),%al
  800eaf:	88 02                	mov    %al,(%edx)
		start++ ;
  800eb1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800eb4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ebd:	7c c4                	jl     800e83 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ebf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800eca:	90                   	nop
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ed3:	ff 75 08             	pushl  0x8(%ebp)
  800ed6:	e8 54 fa ff ff       	call   80092f <strlen>
  800edb:	83 c4 04             	add    $0x4,%esp
  800ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	e8 46 fa ff ff       	call   80092f <strlen>
  800ee9:	83 c4 04             	add    $0x4,%esp
  800eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ef6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800efd:	eb 17                	jmp    800f16 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f02:	8b 45 10             	mov    0x10(%ebp),%eax
  800f05:	01 c2                	add    %eax,%edx
  800f07:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	01 c8                	add    %ecx,%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f13:	ff 45 fc             	incl   -0x4(%ebp)
  800f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f19:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f1c:	7c e1                	jl     800eff <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f1e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f2c:	eb 1f                	jmp    800f4d <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f31:	8d 50 01             	lea    0x1(%eax),%edx
  800f34:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f37:	89 c2                	mov    %eax,%edx
  800f39:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3c:	01 c2                	add    %eax,%edx
  800f3e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	01 c8                	add    %ecx,%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f4a:	ff 45 f8             	incl   -0x8(%ebp)
  800f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f53:	7c d9                	jl     800f2e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f58:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5b:	01 d0                	add    %edx,%eax
  800f5d:	c6 00 00             	movb   $0x0,(%eax)
}
  800f60:	90                   	nop
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    

00800f63 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f66:	8b 45 14             	mov    0x14(%ebp),%eax
  800f69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f72:	8b 00                	mov    (%eax),%eax
  800f74:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f86:	eb 0c                	jmp    800f94 <strsplit+0x31>
			*string++ = 0;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8d 50 01             	lea    0x1(%eax),%edx
  800f8e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f91:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	84 c0                	test   %al,%al
  800f9b:	74 18                	je     800fb5 <strsplit+0x52>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f be c0             	movsbl %al,%eax
  800fa5:	50                   	push   %eax
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	e8 13 fb ff ff       	call   800ac1 <strchr>
  800fae:	83 c4 08             	add    $0x8,%esp
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	75 d3                	jne    800f88 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	84 c0                	test   %al,%al
  800fbc:	74 5a                	je     801018 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  800fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc1:	8b 00                	mov    (%eax),%eax
  800fc3:	83 f8 0f             	cmp    $0xf,%eax
  800fc6:	75 07                	jne    800fcf <strsplit+0x6c>
		{
			return 0;
  800fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcd:	eb 66                	jmp    801035 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fcf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	8d 48 01             	lea    0x1(%eax),%ecx
  800fd7:	8b 55 14             	mov    0x14(%ebp),%edx
  800fda:	89 0a                	mov    %ecx,(%edx)
  800fdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe6:	01 c2                	add    %eax,%edx
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fed:	eb 03                	jmp    800ff2 <strsplit+0x8f>
			string++;
  800fef:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	84 c0                	test   %al,%al
  800ff9:	74 8b                	je     800f86 <strsplit+0x23>
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f be c0             	movsbl %al,%eax
  801003:	50                   	push   %eax
  801004:	ff 75 0c             	pushl  0xc(%ebp)
  801007:	e8 b5 fa ff ff       	call   800ac1 <strchr>
  80100c:	83 c4 08             	add    $0x8,%esp
  80100f:	85 c0                	test   %eax,%eax
  801011:	74 dc                	je     800fef <strsplit+0x8c>
			string++;
	}
  801013:	e9 6e ff ff ff       	jmp    800f86 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801018:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801019:	8b 45 14             	mov    0x14(%ebp),%eax
  80101c:	8b 00                	mov    (%eax),%eax
  80101e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801030:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801040:	e8 7d 0f 00 00       	call   801fc2 <sys_isUHeapPlacementStrategyNEXTFIT>
  801045:	85 c0                	test   %eax,%eax
  801047:	0f 84 6f 03 00 00    	je     8013bc <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  80104d:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	48                   	dec    %eax
  80105d:	89 45 80             	mov    %eax,-0x80(%ebp)
  801060:	8b 45 80             	mov    -0x80(%ebp),%eax
  801063:	ba 00 00 00 00       	mov    $0x0,%edx
  801068:	f7 75 84             	divl   -0x7c(%ebp)
  80106b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80106e:	29 d0                	sub    %edx,%eax
  801070:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801073:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801077:	74 09                	je     801082 <malloc+0x4b>
  801079:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801080:	76 0a                	jbe    80108c <malloc+0x55>
			return NULL;
  801082:	b8 00 00 00 00       	mov    $0x0,%eax
  801087:	e9 4b 09 00 00       	jmp    8019d7 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  80108c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	01 d0                	add    %edx,%eax
  801097:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80109c:	0f 87 a2 00 00 00    	ja     801144 <malloc+0x10d>
  8010a2:	a1 40 30 98 00       	mov    0x983040,%eax
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	0f 85 95 00 00 00    	jne    801144 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  8010af:	a1 04 30 80 00       	mov    0x803004,%eax
  8010b4:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8010ba:	a1 04 30 80 00       	mov    0x803004,%eax
  8010bf:	83 ec 08             	sub    $0x8,%esp
  8010c2:	ff 75 08             	pushl  0x8(%ebp)
  8010c5:	50                   	push   %eax
  8010c6:	e8 a3 0b 00 00       	call   801c6e <sys_allocateMem>
  8010cb:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  8010ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8010d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d6:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8010dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8010e2:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8010e8:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
			cnt_mem++;
  8010ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8010f4:	40                   	inc    %eax
  8010f5:	a3 20 30 80 00       	mov    %eax,0x803020
			int i = 0;
  8010fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801101:	eb 2e                	jmp    801131 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801103:	a1 04 30 80 00       	mov    0x803004,%eax
  801108:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  80110d:	c1 e8 0c             	shr    $0xc,%eax
  801110:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801117:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  80111b:	a1 04 30 80 00       	mov    0x803004,%eax
  801120:	05 00 10 00 00       	add    $0x1000,%eax
  801125:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  80112a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801134:	3b 45 08             	cmp    0x8(%ebp),%eax
  801137:	72 ca                	jb     801103 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801139:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80113f:	e9 93 08 00 00       	jmp    8019d7 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801144:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  80114b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801152:	a1 40 30 98 00       	mov    0x983040,%eax
  801157:	85 c0                	test   %eax,%eax
  801159:	75 1d                	jne    801178 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  80115b:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801162:	00 00 80 
				check = 1;
  801165:	c7 05 40 30 98 00 01 	movl   $0x1,0x983040
  80116c:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  80116f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801176:	eb 08                	jmp    801180 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801178:	a1 04 30 80 00       	mov    0x803004,%eax
  80117d:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801180:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801187:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  80118e:	a1 04 30 80 00       	mov    0x803004,%eax
  801193:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801196:	eb 4d                	jmp    8011e5 <malloc+0x1ae>
				if (sz == size) {
  801198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80119b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80119e:	75 09                	jne    8011a9 <malloc+0x172>
					f = 1;
  8011a0:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8011a7:	eb 45                	jmp    8011ee <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8011a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ac:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  8011b1:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8011b4:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	75 10                	jne    8011cf <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  8011bf:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8011c6:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  8011cd:	eb 16                	jmp    8011e5 <malloc+0x1ae>
				} else {
					sz = 0;
  8011cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8011d6:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  8011dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e0:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8011e5:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8011ec:	76 aa                	jbe    801198 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  8011ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011f2:	0f 84 95 00 00 00    	je     80128d <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8011f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8011fd:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801203:	a1 04 30 80 00       	mov    0x803004,%eax
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	ff 75 08             	pushl  0x8(%ebp)
  80120e:	50                   	push   %eax
  80120f:	e8 5a 0a 00 00       	call   801c6e <sys_allocateMem>
  801214:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801217:	a1 20 30 80 00       	mov    0x803020,%eax
  80121c:	8b 55 08             	mov    0x8(%ebp),%edx
  80121f:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801226:	a1 20 30 80 00       	mov    0x803020,%eax
  80122b:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801231:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801238:	a1 20 30 80 00       	mov    0x803020,%eax
  80123d:	40                   	inc    %eax
  80123e:	a3 20 30 80 00       	mov    %eax,0x803020
				int i = 0;
  801243:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80124a:	eb 2e                	jmp    80127a <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80124c:	a1 04 30 80 00       	mov    0x803004,%eax
  801251:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801256:	c1 e8 0c             	shr    $0xc,%eax
  801259:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801260:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801264:	a1 04 30 80 00       	mov    0x803004,%eax
  801269:	05 00 10 00 00       	add    $0x1000,%eax
  80126e:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801273:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80127a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80127d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801280:	72 ca                	jb     80124c <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801282:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801288:	e9 4a 07 00 00       	jmp    8019d7 <malloc+0x9a0>

			} else {

				if (check_start) {
  80128d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801291:	74 0a                	je     80129d <malloc+0x266>

					return NULL;
  801293:	b8 00 00 00 00       	mov    $0x0,%eax
  801298:	e9 3a 07 00 00       	jmp    8019d7 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  80129d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  8012a4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  8012ab:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  8012b2:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  8012b9:	00 00 80 
				while (ptr < (uint32) temp_end) {
  8012bc:	eb 4d                	jmp    80130b <malloc+0x2d4>
					if (sz == size) {
  8012be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8012c4:	75 09                	jne    8012cf <malloc+0x298>
						f = 1;
  8012c6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  8012cd:	eb 44                	jmp    801313 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8012cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012d2:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  8012d7:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8012da:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	75 10                	jne    8012f5 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  8012e5:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8012ec:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  8012f3:	eb 16                	jmp    80130b <malloc+0x2d4>
					} else {
						sz = 0;
  8012f5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8012fc:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801303:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801306:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  80130b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801311:	72 ab                	jb     8012be <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801313:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801317:	0f 84 95 00 00 00    	je     8013b2 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  80131d:	a1 04 30 80 00       	mov    0x803004,%eax
  801322:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801328:	a1 04 30 80 00       	mov    0x803004,%eax
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 08             	pushl  0x8(%ebp)
  801333:	50                   	push   %eax
  801334:	e8 35 09 00 00       	call   801c6e <sys_allocateMem>
  801339:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  80133c:	a1 20 30 80 00       	mov    0x803020,%eax
  801341:	8b 55 08             	mov    0x8(%ebp),%edx
  801344:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80134b:	a1 20 30 80 00       	mov    0x803020,%eax
  801350:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801356:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
					cnt_mem++;
  80135d:	a1 20 30 80 00       	mov    0x803020,%eax
  801362:	40                   	inc    %eax
  801363:	a3 20 30 80 00       	mov    %eax,0x803020
					int i = 0;
  801368:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  80136f:	eb 2e                	jmp    80139f <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801371:	a1 04 30 80 00       	mov    0x803004,%eax
  801376:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  80137b:	c1 e8 0c             	shr    $0xc,%eax
  80137e:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801385:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801389:	a1 04 30 80 00       	mov    0x803004,%eax
  80138e:	05 00 10 00 00       	add    $0x1000,%eax
  801393:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801398:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  80139f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8013a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8013a5:	72 ca                	jb     801371 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  8013a7:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013ad:	e9 25 06 00 00       	jmp    8019d7 <malloc+0x9a0>

				} else {

					return NULL;
  8013b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b7:	e9 1b 06 00 00       	jmp    8019d7 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  8013bc:	e8 d0 0b 00 00       	call   801f91 <sys_isUHeapPlacementStrategyBESTFIT>
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	0f 84 ba 01 00 00    	je     801583 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  8013c9:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  8013d0:	10 00 00 
  8013d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d6:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8013dc:	01 d0                	add    %edx,%eax
  8013de:	48                   	dec    %eax
  8013df:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8013e5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8013eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f0:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  8013f6:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8013fc:	29 d0                	sub    %edx,%eax
  8013fe:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801401:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801405:	74 09                	je     801410 <malloc+0x3d9>
  801407:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80140e:	76 0a                	jbe    80141a <malloc+0x3e3>
			return NULL;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	e9 bd 05 00 00       	jmp    8019d7 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  80141a:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801421:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801428:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  80142f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801436:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	c1 e8 0c             	shr    $0xc,%eax
  801443:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801449:	e9 80 00 00 00       	jmp    8014ce <malloc+0x497>

			if (heap_mem[i] == 0) {
  80144e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801451:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801458:	85 c0                	test   %eax,%eax
  80145a:	75 0c                	jne    801468 <malloc+0x431>

				count++;
  80145c:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  80145f:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801466:	eb 2d                	jmp    801495 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801468:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80146e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801471:	77 14                	ja     801487 <malloc+0x450>
  801473:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801476:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801479:	76 0c                	jbe    801487 <malloc+0x450>

					min_sz = count;
  80147b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80147e:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801481:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801484:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801487:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  80148e:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801495:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  80149c:	75 2d                	jne    8014cb <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  80149e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8014a4:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8014a7:	77 22                	ja     8014cb <malloc+0x494>
  8014a9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8014ac:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8014af:	76 1a                	jbe    8014cb <malloc+0x494>

					min_sz = count;
  8014b1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8014b4:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  8014b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  8014bd:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  8014c4:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  8014cb:	ff 45 b8             	incl   -0x48(%ebp)
  8014ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8014d1:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8014d6:	0f 86 72 ff ff ff    	jbe    80144e <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  8014dc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8014e2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  8014e5:	77 06                	ja     8014ed <malloc+0x4b6>
  8014e7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8014eb:	75 0a                	jne    8014f7 <malloc+0x4c0>
			return NULL;
  8014ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f2:	e9 e0 04 00 00       	jmp    8019d7 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  8014f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8014fa:	c1 e0 0c             	shl    $0xc,%eax
  8014fd:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801500:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801503:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	ff 75 c4             	pushl  -0x3c(%ebp)
  801512:	e8 57 07 00 00       	call   801c6e <sys_allocateMem>
  801517:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80151a:	a1 20 30 80 00       	mov    0x803020,%eax
  80151f:	8b 55 08             	mov    0x8(%ebp),%edx
  801522:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801529:	a1 20 30 80 00       	mov    0x803020,%eax
  80152e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801531:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801538:	a1 20 30 80 00       	mov    0x803020,%eax
  80153d:	40                   	inc    %eax
  80153e:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801543:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  80154a:	eb 24                	jmp    801570 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  80154c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80154f:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801554:	c1 e8 0c             	shr    $0xc,%eax
  801557:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  80155e:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801562:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801569:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801570:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801573:	3b 45 08             	cmp    0x8(%ebp),%eax
  801576:	72 d4                	jb     80154c <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801578:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80157e:	e9 54 04 00 00       	jmp    8019d7 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801583:	e8 d8 09 00 00       	call   801f60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801588:	85 c0                	test   %eax,%eax
  80158a:	0f 84 88 01 00 00    	je     801718 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801590:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801597:	10 00 00 
  80159a:	8b 55 08             	mov    0x8(%ebp),%edx
  80159d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8015a3:	01 d0                	add    %edx,%eax
  8015a5:	48                   	dec    %eax
  8015a6:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  8015ac:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8015b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b7:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  8015bd:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8015c3:	29 d0                	sub    %edx,%eax
  8015c5:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8015c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015cc:	74 09                	je     8015d7 <malloc+0x5a0>
  8015ce:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8015d5:	76 0a                	jbe    8015e1 <malloc+0x5aa>
			return NULL;
  8015d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dc:	e9 f6 03 00 00       	jmp    8019d7 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  8015e1:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  8015e8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  8015ef:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  8015f6:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  8015fd:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	c1 e8 0c             	shr    $0xc,%eax
  80160a:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801610:	eb 5a                	jmp    80166c <malloc+0x635>

			if (heap_mem[i] == 0) {
  801612:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801615:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  80161c:	85 c0                	test   %eax,%eax
  80161e:	75 0c                	jne    80162c <malloc+0x5f5>

				count++;
  801620:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801623:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  80162a:	eb 22                	jmp    80164e <malloc+0x617>
			} else {
				if (num_p <= count) {
  80162c:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801632:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801635:	77 09                	ja     801640 <malloc+0x609>

					found = 1;
  801637:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  80163e:	eb 36                	jmp    801676 <malloc+0x63f>
				}
				count = 0;
  801640:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801647:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  80164e:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801655:	75 12                	jne    801669 <malloc+0x632>

				if (num_p <= count) {
  801657:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80165d:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801660:	77 07                	ja     801669 <malloc+0x632>

					found = 1;
  801662:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801669:	ff 45 a4             	incl   -0x5c(%ebp)
  80166c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80166f:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801674:	76 9c                	jbe    801612 <malloc+0x5db>

			}

		}

		if (!found) {
  801676:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  80167a:	75 0a                	jne    801686 <malloc+0x64f>
			return NULL;
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
  801681:	e9 51 03 00 00       	jmp    8019d7 <malloc+0x9a0>

		}

		temp = ptr;
  801686:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801689:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  80168c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80168f:	c1 e0 0c             	shl    $0xc,%eax
  801692:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801695:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801698:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  80169e:	83 ec 08             	sub    $0x8,%esp
  8016a1:	ff 75 08             	pushl  0x8(%ebp)
  8016a4:	ff 75 b0             	pushl  -0x50(%ebp)
  8016a7:	e8 c2 05 00 00       	call   801c6e <sys_allocateMem>
  8016ac:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8016af:	a1 20 30 80 00       	mov    0x803020,%eax
  8016b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b7:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8016be:	a1 20 30 80 00       	mov    0x803020,%eax
  8016c3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8016c6:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  8016cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8016d2:	40                   	inc    %eax
  8016d3:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  8016d8:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8016df:	eb 24                	jmp    801705 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8016e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8016e4:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8016e9:	c1 e8 0c             	shr    $0xc,%eax
  8016ec:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8016f3:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  8016f7:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8016fe:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801705:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801708:	3b 45 08             	cmp    0x8(%ebp),%eax
  80170b:	72 d4                	jb     8016e1 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  80170d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801713:	e9 bf 02 00 00       	jmp    8019d7 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801718:	e8 d6 08 00 00       	call   801ff3 <sys_isUHeapPlacementStrategyWORSTFIT>
  80171d:	85 c0                	test   %eax,%eax
  80171f:	0f 84 ba 01 00 00    	je     8018df <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801725:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  80172c:	10 00 00 
  80172f:	8b 55 08             	mov    0x8(%ebp),%edx
  801732:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801738:	01 d0                	add    %edx,%eax
  80173a:	48                   	dec    %eax
  80173b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801741:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801747:	ba 00 00 00 00       	mov    $0x0,%edx
  80174c:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801752:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801758:	29 d0                	sub    %edx,%eax
  80175a:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80175d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801761:	74 09                	je     80176c <malloc+0x735>
  801763:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80176a:	76 0a                	jbe    801776 <malloc+0x73f>
					return NULL;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
  801771:	e9 61 02 00 00       	jmp    8019d7 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801776:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  80177d:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801784:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  80178b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801792:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	c1 e8 0c             	shr    $0xc,%eax
  80179f:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8017a5:	e9 80 00 00 00       	jmp    80182a <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  8017aa:	8b 45 90             	mov    -0x70(%ebp),%eax
  8017ad:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	75 0c                	jne    8017c4 <malloc+0x78d>

						count++;
  8017b8:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  8017bb:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  8017c2:	eb 2d                	jmp    8017f1 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  8017c4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8017ca:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8017cd:	77 14                	ja     8017e3 <malloc+0x7ac>
  8017cf:	8b 45 98             	mov    -0x68(%ebp),%eax
  8017d2:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8017d5:	73 0c                	jae    8017e3 <malloc+0x7ac>

							max_sz = count;
  8017d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8017da:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8017dd:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8017e0:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  8017e3:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  8017ea:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  8017f1:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  8017f8:	75 2d                	jne    801827 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  8017fa:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801800:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801803:	77 22                	ja     801827 <malloc+0x7f0>
  801805:	8b 45 98             	mov    -0x68(%ebp),%eax
  801808:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80180b:	76 1a                	jbe    801827 <malloc+0x7f0>

							max_sz = count;
  80180d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801810:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801813:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801816:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801819:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801820:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801827:	ff 45 90             	incl   -0x70(%ebp)
  80182a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80182d:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801832:	0f 86 72 ff ff ff    	jbe    8017aa <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801838:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80183e:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801841:	77 06                	ja     801849 <malloc+0x812>
  801843:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801847:	75 0a                	jne    801853 <malloc+0x81c>
					return NULL;
  801849:	b8 00 00 00 00       	mov    $0x0,%eax
  80184e:	e9 84 01 00 00       	jmp    8019d7 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801853:	8b 45 98             	mov    -0x68(%ebp),%eax
  801856:	c1 e0 0c             	shl    $0xc,%eax
  801859:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  80185c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80185f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801865:	83 ec 08             	sub    $0x8,%esp
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	ff 75 9c             	pushl  -0x64(%ebp)
  80186e:	e8 fb 03 00 00       	call   801c6e <sys_allocateMem>
  801873:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801876:	a1 20 30 80 00       	mov    0x803020,%eax
  80187b:	8b 55 08             	mov    0x8(%ebp),%edx
  80187e:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801885:	a1 20 30 80 00       	mov    0x803020,%eax
  80188a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80188d:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801894:	a1 20 30 80 00       	mov    0x803020,%eax
  801899:	40                   	inc    %eax
  80189a:	a3 20 30 80 00       	mov    %eax,0x803020
				i = 0;
  80189f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8018a6:	eb 24                	jmp    8018cc <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8018a8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8018ab:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8018b0:	c1 e8 0c             	shr    $0xc,%eax
  8018b3:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8018ba:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  8018be:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8018c5:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  8018cc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8018cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018d2:	72 d4                	jb     8018a8 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  8018d4:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8018da:	e9 f8 00 00 00       	jmp    8019d7 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  8018df:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  8018e6:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  8018ed:	10 00 00 
  8018f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	48                   	dec    %eax
  8018fc:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  801902:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801908:	ba 00 00 00 00       	mov    $0x0,%edx
  80190d:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  801913:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801919:	29 d0                	sub    %edx,%eax
  80191b:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80191e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801922:	74 09                	je     80192d <malloc+0x8f6>
  801924:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80192b:	76 0a                	jbe    801937 <malloc+0x900>
		return NULL;
  80192d:	b8 00 00 00 00       	mov    $0x0,%eax
  801932:	e9 a0 00 00 00       	jmp    8019d7 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  801937:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	01 d0                	add    %edx,%eax
  801942:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801947:	0f 87 87 00 00 00    	ja     8019d4 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80194d:	a1 04 30 80 00       	mov    0x803004,%eax
  801952:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  801955:	a1 04 30 80 00       	mov    0x803004,%eax
  80195a:	83 ec 08             	sub    $0x8,%esp
  80195d:	ff 75 08             	pushl  0x8(%ebp)
  801960:	50                   	push   %eax
  801961:	e8 08 03 00 00       	call   801c6e <sys_allocateMem>
  801966:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801969:	a1 20 30 80 00       	mov    0x803020,%eax
  80196e:	8b 55 08             	mov    0x8(%ebp),%edx
  801971:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801978:	a1 20 30 80 00       	mov    0x803020,%eax
  80197d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801983:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  80198a:	a1 20 30 80 00       	mov    0x803020,%eax
  80198f:	40                   	inc    %eax
  801990:	a3 20 30 80 00       	mov    %eax,0x803020
		int i = 0;
  801995:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  80199c:	eb 2e                	jmp    8019cc <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80199e:	a1 04 30 80 00       	mov    0x803004,%eax
  8019a3:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8019a8:	c1 e8 0c             	shr    $0xc,%eax
  8019ab:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8019b2:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8019b6:	a1 04 30 80 00       	mov    0x803004,%eax
  8019bb:	05 00 10 00 00       	add    $0x1000,%eax
  8019c0:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8019c5:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  8019cc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8019cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019d2:	72 ca                	jb     80199e <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  8019d4:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  8019df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  8019e6:	e9 c1 00 00 00       	jmp    801aac <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ee:	8b 04 c5 40 30 88 00 	mov    0x883040(,%eax,8),%eax
  8019f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019f8:	0f 85 ab 00 00 00    	jne    801aa9 <free+0xd0>

			if (heap_size[inx].size == 0) {
  8019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a01:	8b 04 c5 44 30 88 00 	mov    0x883044(,%eax,8),%eax
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	75 21                	jne    801a2d <free+0x54>
				heap_size[inx].size = 0;
  801a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0f:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801a16:	00 00 00 00 
				heap_size[inx].vir = NULL;
  801a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1d:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801a24:	00 00 00 00 
				return;
  801a28:	e9 8d 00 00 00       	jmp    801aba <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  801a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a30:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	83 ec 08             	sub    $0x8,%esp
  801a3d:	52                   	push   %edx
  801a3e:	50                   	push   %eax
  801a3f:	e8 0e 02 00 00       	call   801c52 <sys_freeMem>
  801a44:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  801a47:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801a54:	eb 24                	jmp    801a7a <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  801a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a59:	05 00 00 00 80       	add    $0x80000000,%eax
  801a5e:	c1 e8 0c             	shr    $0xc,%eax
  801a61:	c7 04 85 40 30 80 00 	movl   $0x0,0x803040(,%eax,4)
  801a68:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  801a6c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801a73:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7d:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a87:	39 c2                	cmp    %eax,%edx
  801a89:	77 cb                	ja     801a56 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  801a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8e:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801a95:	00 00 00 00 
			heap_size[inx].vir = NULL;
  801a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9c:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801aa3:	00 00 00 00 
			break;
  801aa7:	eb 11                	jmp    801aba <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  801aa9:	ff 45 f4             	incl   -0xc(%ebp)
  801aac:	a1 20 30 80 00       	mov    0x803020,%eax
  801ab1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801ab4:	0f 8c 31 ff ff ff    	jl     8019eb <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ac2:	83 ec 04             	sub    $0x4,%esp
  801ac5:	68 30 27 80 00       	push   $0x802730
  801aca:	68 1c 02 00 00       	push   $0x21c
  801acf:	68 56 27 80 00       	push   $0x802756
  801ad4:	e8 66 05 00 00       	call   80203f <_panic>

00801ad9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	57                   	push   %edi
  801add:	56                   	push   %esi
  801ade:	53                   	push   %ebx
  801adf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aeb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aee:	8b 7d 18             	mov    0x18(%ebp),%edi
  801af1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801af4:	cd 30                	int    $0x30
  801af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5f                   	pop    %edi
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    

00801b04 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	50                   	push   %eax
  801b14:	6a 00                	push   $0x0
  801b16:	e8 be ff ff ff       	call   801ad9 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	90                   	nop
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 01                	push   $0x1
  801b30:	e8 a4 ff ff ff       	call   801ad9 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	50                   	push   %eax
  801b49:	6a 03                	push   $0x3
  801b4b:	e8 89 ff ff ff       	call   801ad9 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 02                	push   $0x2
  801b64:	e8 70 ff ff ff       	call   801ad9 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_env_exit>:

void sys_env_exit(void)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 04                	push   $0x4
  801b7d:	e8 57 ff ff ff       	call   801ad9 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	90                   	nop
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 05                	push   $0x5
  801b9b:	e8 39 ff ff ff       	call   801ad9 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	56                   	push   %esi
  801ba9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801baa:	8b 75 18             	mov    0x18(%ebp),%esi
  801bad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	56                   	push   %esi
  801bba:	53                   	push   %ebx
  801bbb:	51                   	push   %ecx
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 06                	push   $0x6
  801bc0:	e8 14 ff ff ff       	call   801ad9 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcb:	5b                   	pop    %ebx
  801bcc:	5e                   	pop    %esi
  801bcd:	5d                   	pop    %ebp
  801bce:	c3                   	ret    

00801bcf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	52                   	push   %edx
  801bdf:	50                   	push   %eax
  801be0:	6a 07                	push   $0x7
  801be2:	e8 f2 fe ff ff       	call   801ad9 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	6a 08                	push   $0x8
  801bfd:	e8 d7 fe ff ff       	call   801ad9 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 09                	push   $0x9
  801c16:	e8 be fe ff ff       	call   801ad9 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 0a                	push   $0xa
  801c2f:	e8 a5 fe ff ff       	call   801ad9 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 0b                	push   $0xb
  801c48:	e8 8c fe ff ff       	call   801ad9 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	ff 75 08             	pushl  0x8(%ebp)
  801c61:	6a 0d                	push   $0xd
  801c63:	e8 71 fe ff ff       	call   801ad9 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
	return;
  801c6b:	90                   	nop
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	ff 75 0c             	pushl  0xc(%ebp)
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	6a 0e                	push   $0xe
  801c7f:	e8 55 fe ff ff       	call   801ad9 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
	return ;
  801c87:	90                   	nop
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 0c                	push   $0xc
  801c99:	e8 3b fe ff ff       	call   801ad9 <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 10                	push   $0x10
  801cb2:	e8 22 fe ff ff       	call   801ad9 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	90                   	nop
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 11                	push   $0x11
  801ccc:	e8 08 fe ff ff       	call   801ad9 <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	90                   	nop
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 04             	sub    $0x4,%esp
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ce3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	50                   	push   %eax
  801cf0:	6a 12                	push   $0x12
  801cf2:	e8 e2 fd ff ff       	call   801ad9 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	90                   	nop
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 13                	push   $0x13
  801d0c:	e8 c8 fd ff ff       	call   801ad9 <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
}
  801d14:	90                   	nop
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	50                   	push   %eax
  801d27:	6a 14                	push   $0x14
  801d29:	e8 ab fd ff ff       	call   801ad9 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	50                   	push   %eax
  801d42:	6a 17                	push   $0x17
  801d44:	e8 90 fd ff ff       	call   801ad9 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	50                   	push   %eax
  801d5d:	6a 15                	push   $0x15
  801d5f:	e8 75 fd ff ff       	call   801ad9 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	90                   	nop
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	50                   	push   %eax
  801d79:	6a 16                	push   $0x16
  801d7b:	e8 59 fd ff ff       	call   801ad9 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	90                   	nop
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801d92:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d95:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	6a 00                	push   $0x0
  801d9e:	51                   	push   %ecx
  801d9f:	52                   	push   %edx
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	50                   	push   %eax
  801da4:	6a 18                	push   $0x18
  801da6:	e8 2e fd ff ff       	call   801ad9 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	52                   	push   %edx
  801dc0:	50                   	push   %eax
  801dc1:	6a 19                	push   $0x19
  801dc3:	e8 11 fd ff ff       	call   801ad9 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	50                   	push   %eax
  801ddc:	6a 1a                	push   $0x1a
  801dde:	e8 f6 fc ff ff       	call   801ad9 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 1b                	push   $0x1b
  801df7:	e8 dd fc ff ff       	call   801ad9 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 1c                	push   $0x1c
  801e10:	e8 c4 fc ff ff       	call   801ad9 <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	50                   	push   %eax
  801e2a:	6a 1d                	push   $0x1d
  801e2c:	e8 a8 fc ff ff       	call   801ad9 <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	50                   	push   %eax
  801e45:	6a 1e                	push   $0x1e
  801e47:	e8 8d fc ff ff       	call   801ad9 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	90                   	nop
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	50                   	push   %eax
  801e61:	6a 1f                	push   $0x1f
  801e63:	e8 71 fc ff ff       	call   801ad9 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e77:	8d 50 04             	lea    0x4(%eax),%edx
  801e7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	52                   	push   %edx
  801e84:	50                   	push   %eax
  801e85:	6a 20                	push   $0x20
  801e87:	e8 4d fc ff ff       	call   801ad9 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return result;
  801e8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e98:	89 01                	mov    %eax,(%ecx)
  801e9a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	c9                   	leave  
  801ea1:	c2 04 00             	ret    $0x4

00801ea4 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	ff 75 10             	pushl  0x10(%ebp)
  801eae:	ff 75 0c             	pushl  0xc(%ebp)
  801eb1:	ff 75 08             	pushl  0x8(%ebp)
  801eb4:	6a 0f                	push   $0xf
  801eb6:	e8 1e fc ff ff       	call   801ad9 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebe:	90                   	nop
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 21                	push   $0x21
  801ed0:	e8 04 fc ff ff       	call   801ad9 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ee6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	50                   	push   %eax
  801ef3:	6a 22                	push   $0x22
  801ef5:	e8 df fb ff ff       	call   801ad9 <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
	return ;
  801efd:	90                   	nop
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <rsttst>:
void rsttst()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 24                	push   $0x24
  801f0f:	e8 c5 fb ff ff       	call   801ad9 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
	return ;
  801f17:	90                   	nop
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	8b 45 14             	mov    0x14(%ebp),%eax
  801f23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f26:	8b 55 18             	mov    0x18(%ebp),%edx
  801f29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f2d:	52                   	push   %edx
  801f2e:	50                   	push   %eax
  801f2f:	ff 75 10             	pushl  0x10(%ebp)
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	ff 75 08             	pushl  0x8(%ebp)
  801f38:	6a 23                	push   $0x23
  801f3a:	e8 9a fb ff ff       	call   801ad9 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f42:	90                   	nop
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <chktst>:
void chktst(uint32 n)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	ff 75 08             	pushl  0x8(%ebp)
  801f53:	6a 25                	push   $0x25
  801f55:	e8 7f fb ff ff       	call   801ad9 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5d:	90                   	nop
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 26                	push   $0x26
  801f72:	e8 62 fb ff ff       	call   801ad9 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
  801f7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f7d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f81:	75 07                	jne    801f8a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f83:	b8 01 00 00 00       	mov    $0x1,%eax
  801f88:	eb 05                	jmp    801f8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 26                	push   $0x26
  801fa3:	e8 31 fb ff ff       	call   801ad9 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
  801fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fae:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fb2:	75 07                	jne    801fbb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fb4:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb9:	eb 05                	jmp    801fc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 26                	push   $0x26
  801fd4:	e8 00 fb ff ff       	call   801ad9 <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
  801fdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fdf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fe3:	75 07                	jne    801fec <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fe5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fea:	eb 05                	jmp    801ff1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 26                	push   $0x26
  802005:	e8 cf fa ff ff       	call   801ad9 <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
  80200d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802010:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802014:	75 07                	jne    80201d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802016:	b8 01 00 00 00       	mov    $0x1,%eax
  80201b:	eb 05                	jmp    802022 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80201d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	ff 75 08             	pushl  0x8(%ebp)
  802032:	6a 27                	push   $0x27
  802034:	e8 a0 fa ff ff       	call   801ad9 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
	return ;
  80203c:	90                   	nop
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802045:	8d 45 10             	lea    0x10(%ebp),%eax
  802048:	83 c0 04             	add    $0x4,%eax
  80204b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  80204e:	a1 50 30 98 00       	mov    0x983050,%eax
  802053:	85 c0                	test   %eax,%eax
  802055:	74 16                	je     80206d <_panic+0x2e>
		cprintf("%s: ", argv0);
  802057:	a1 50 30 98 00       	mov    0x983050,%eax
  80205c:	83 ec 08             	sub    $0x8,%esp
  80205f:	50                   	push   %eax
  802060:	68 62 27 80 00       	push   $0x802762
  802065:	e8 4a e2 ff ff       	call   8002b4 <cprintf>
  80206a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80206d:	a1 00 30 80 00       	mov    0x803000,%eax
  802072:	ff 75 0c             	pushl  0xc(%ebp)
  802075:	ff 75 08             	pushl  0x8(%ebp)
  802078:	50                   	push   %eax
  802079:	68 67 27 80 00       	push   $0x802767
  80207e:	e8 31 e2 ff ff       	call   8002b4 <cprintf>
  802083:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802086:	8b 45 10             	mov    0x10(%ebp),%eax
  802089:	83 ec 08             	sub    $0x8,%esp
  80208c:	ff 75 f4             	pushl  -0xc(%ebp)
  80208f:	50                   	push   %eax
  802090:	e8 c4 e1 ff ff       	call   800259 <vcprintf>
  802095:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  802098:	83 ec 0c             	sub    $0xc,%esp
  80209b:	68 83 27 80 00       	push   $0x802783
  8020a0:	e8 0f e2 ff ff       	call   8002b4 <cprintf>
  8020a5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8020a8:	e8 3e e1 ff ff       	call   8001eb <exit>

	// should not return here
	while (1) ;
  8020ad:	eb fe                	jmp    8020ad <_panic+0x6e>
  8020af:	90                   	nop

008020b0 <__udivdi3>:
  8020b0:	55                   	push   %ebp
  8020b1:	57                   	push   %edi
  8020b2:	56                   	push   %esi
  8020b3:	53                   	push   %ebx
  8020b4:	83 ec 1c             	sub    $0x1c,%esp
  8020b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020c7:	89 ca                	mov    %ecx,%edx
  8020c9:	89 f8                	mov    %edi,%eax
  8020cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020cf:	85 f6                	test   %esi,%esi
  8020d1:	75 2d                	jne    802100 <__udivdi3+0x50>
  8020d3:	39 cf                	cmp    %ecx,%edi
  8020d5:	77 65                	ja     80213c <__udivdi3+0x8c>
  8020d7:	89 fd                	mov    %edi,%ebp
  8020d9:	85 ff                	test   %edi,%edi
  8020db:	75 0b                	jne    8020e8 <__udivdi3+0x38>
  8020dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e2:	31 d2                	xor    %edx,%edx
  8020e4:	f7 f7                	div    %edi
  8020e6:	89 c5                	mov    %eax,%ebp
  8020e8:	31 d2                	xor    %edx,%edx
  8020ea:	89 c8                	mov    %ecx,%eax
  8020ec:	f7 f5                	div    %ebp
  8020ee:	89 c1                	mov    %eax,%ecx
  8020f0:	89 d8                	mov    %ebx,%eax
  8020f2:	f7 f5                	div    %ebp
  8020f4:	89 cf                	mov    %ecx,%edi
  8020f6:	89 fa                	mov    %edi,%edx
  8020f8:	83 c4 1c             	add    $0x1c,%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5e                   	pop    %esi
  8020fd:	5f                   	pop    %edi
  8020fe:	5d                   	pop    %ebp
  8020ff:	c3                   	ret    
  802100:	39 ce                	cmp    %ecx,%esi
  802102:	77 28                	ja     80212c <__udivdi3+0x7c>
  802104:	0f bd fe             	bsr    %esi,%edi
  802107:	83 f7 1f             	xor    $0x1f,%edi
  80210a:	75 40                	jne    80214c <__udivdi3+0x9c>
  80210c:	39 ce                	cmp    %ecx,%esi
  80210e:	72 0a                	jb     80211a <__udivdi3+0x6a>
  802110:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802114:	0f 87 9e 00 00 00    	ja     8021b8 <__udivdi3+0x108>
  80211a:	b8 01 00 00 00       	mov    $0x1,%eax
  80211f:	89 fa                	mov    %edi,%edx
  802121:	83 c4 1c             	add    $0x1c,%esp
  802124:	5b                   	pop    %ebx
  802125:	5e                   	pop    %esi
  802126:	5f                   	pop    %edi
  802127:	5d                   	pop    %ebp
  802128:	c3                   	ret    
  802129:	8d 76 00             	lea    0x0(%esi),%esi
  80212c:	31 ff                	xor    %edi,%edi
  80212e:	31 c0                	xor    %eax,%eax
  802130:	89 fa                	mov    %edi,%edx
  802132:	83 c4 1c             	add    $0x1c,%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5f                   	pop    %edi
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    
  80213a:	66 90                	xchg   %ax,%ax
  80213c:	89 d8                	mov    %ebx,%eax
  80213e:	f7 f7                	div    %edi
  802140:	31 ff                	xor    %edi,%edi
  802142:	89 fa                	mov    %edi,%edx
  802144:	83 c4 1c             	add    $0x1c,%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5f                   	pop    %edi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    
  80214c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802151:	89 eb                	mov    %ebp,%ebx
  802153:	29 fb                	sub    %edi,%ebx
  802155:	89 f9                	mov    %edi,%ecx
  802157:	d3 e6                	shl    %cl,%esi
  802159:	89 c5                	mov    %eax,%ebp
  80215b:	88 d9                	mov    %bl,%cl
  80215d:	d3 ed                	shr    %cl,%ebp
  80215f:	89 e9                	mov    %ebp,%ecx
  802161:	09 f1                	or     %esi,%ecx
  802163:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802167:	89 f9                	mov    %edi,%ecx
  802169:	d3 e0                	shl    %cl,%eax
  80216b:	89 c5                	mov    %eax,%ebp
  80216d:	89 d6                	mov    %edx,%esi
  80216f:	88 d9                	mov    %bl,%cl
  802171:	d3 ee                	shr    %cl,%esi
  802173:	89 f9                	mov    %edi,%ecx
  802175:	d3 e2                	shl    %cl,%edx
  802177:	8b 44 24 08          	mov    0x8(%esp),%eax
  80217b:	88 d9                	mov    %bl,%cl
  80217d:	d3 e8                	shr    %cl,%eax
  80217f:	09 c2                	or     %eax,%edx
  802181:	89 d0                	mov    %edx,%eax
  802183:	89 f2                	mov    %esi,%edx
  802185:	f7 74 24 0c          	divl   0xc(%esp)
  802189:	89 d6                	mov    %edx,%esi
  80218b:	89 c3                	mov    %eax,%ebx
  80218d:	f7 e5                	mul    %ebp
  80218f:	39 d6                	cmp    %edx,%esi
  802191:	72 19                	jb     8021ac <__udivdi3+0xfc>
  802193:	74 0b                	je     8021a0 <__udivdi3+0xf0>
  802195:	89 d8                	mov    %ebx,%eax
  802197:	31 ff                	xor    %edi,%edi
  802199:	e9 58 ff ff ff       	jmp    8020f6 <__udivdi3+0x46>
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021a4:	89 f9                	mov    %edi,%ecx
  8021a6:	d3 e2                	shl    %cl,%edx
  8021a8:	39 c2                	cmp    %eax,%edx
  8021aa:	73 e9                	jae    802195 <__udivdi3+0xe5>
  8021ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021af:	31 ff                	xor    %edi,%edi
  8021b1:	e9 40 ff ff ff       	jmp    8020f6 <__udivdi3+0x46>
  8021b6:	66 90                	xchg   %ax,%ax
  8021b8:	31 c0                	xor    %eax,%eax
  8021ba:	e9 37 ff ff ff       	jmp    8020f6 <__udivdi3+0x46>
  8021bf:	90                   	nop

008021c0 <__umoddi3>:
  8021c0:	55                   	push   %ebp
  8021c1:	57                   	push   %edi
  8021c2:	56                   	push   %esi
  8021c3:	53                   	push   %ebx
  8021c4:	83 ec 1c             	sub    $0x1c,%esp
  8021c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021df:	89 f3                	mov    %esi,%ebx
  8021e1:	89 fa                	mov    %edi,%edx
  8021e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021e7:	89 34 24             	mov    %esi,(%esp)
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	75 1a                	jne    802208 <__umoddi3+0x48>
  8021ee:	39 f7                	cmp    %esi,%edi
  8021f0:	0f 86 a2 00 00 00    	jbe    802298 <__umoddi3+0xd8>
  8021f6:	89 c8                	mov    %ecx,%eax
  8021f8:	89 f2                	mov    %esi,%edx
  8021fa:	f7 f7                	div    %edi
  8021fc:	89 d0                	mov    %edx,%eax
  8021fe:	31 d2                	xor    %edx,%edx
  802200:	83 c4 1c             	add    $0x1c,%esp
  802203:	5b                   	pop    %ebx
  802204:	5e                   	pop    %esi
  802205:	5f                   	pop    %edi
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    
  802208:	39 f0                	cmp    %esi,%eax
  80220a:	0f 87 ac 00 00 00    	ja     8022bc <__umoddi3+0xfc>
  802210:	0f bd e8             	bsr    %eax,%ebp
  802213:	83 f5 1f             	xor    $0x1f,%ebp
  802216:	0f 84 ac 00 00 00    	je     8022c8 <__umoddi3+0x108>
  80221c:	bf 20 00 00 00       	mov    $0x20,%edi
  802221:	29 ef                	sub    %ebp,%edi
  802223:	89 fe                	mov    %edi,%esi
  802225:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802229:	89 e9                	mov    %ebp,%ecx
  80222b:	d3 e0                	shl    %cl,%eax
  80222d:	89 d7                	mov    %edx,%edi
  80222f:	89 f1                	mov    %esi,%ecx
  802231:	d3 ef                	shr    %cl,%edi
  802233:	09 c7                	or     %eax,%edi
  802235:	89 e9                	mov    %ebp,%ecx
  802237:	d3 e2                	shl    %cl,%edx
  802239:	89 14 24             	mov    %edx,(%esp)
  80223c:	89 d8                	mov    %ebx,%eax
  80223e:	d3 e0                	shl    %cl,%eax
  802240:	89 c2                	mov    %eax,%edx
  802242:	8b 44 24 08          	mov    0x8(%esp),%eax
  802246:	d3 e0                	shl    %cl,%eax
  802248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802250:	89 f1                	mov    %esi,%ecx
  802252:	d3 e8                	shr    %cl,%eax
  802254:	09 d0                	or     %edx,%eax
  802256:	d3 eb                	shr    %cl,%ebx
  802258:	89 da                	mov    %ebx,%edx
  80225a:	f7 f7                	div    %edi
  80225c:	89 d3                	mov    %edx,%ebx
  80225e:	f7 24 24             	mull   (%esp)
  802261:	89 c6                	mov    %eax,%esi
  802263:	89 d1                	mov    %edx,%ecx
  802265:	39 d3                	cmp    %edx,%ebx
  802267:	0f 82 87 00 00 00    	jb     8022f4 <__umoddi3+0x134>
  80226d:	0f 84 91 00 00 00    	je     802304 <__umoddi3+0x144>
  802273:	8b 54 24 04          	mov    0x4(%esp),%edx
  802277:	29 f2                	sub    %esi,%edx
  802279:	19 cb                	sbb    %ecx,%ebx
  80227b:	89 d8                	mov    %ebx,%eax
  80227d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802281:	d3 e0                	shl    %cl,%eax
  802283:	89 e9                	mov    %ebp,%ecx
  802285:	d3 ea                	shr    %cl,%edx
  802287:	09 d0                	or     %edx,%eax
  802289:	89 e9                	mov    %ebp,%ecx
  80228b:	d3 eb                	shr    %cl,%ebx
  80228d:	89 da                	mov    %ebx,%edx
  80228f:	83 c4 1c             	add    $0x1c,%esp
  802292:	5b                   	pop    %ebx
  802293:	5e                   	pop    %esi
  802294:	5f                   	pop    %edi
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    
  802297:	90                   	nop
  802298:	89 fd                	mov    %edi,%ebp
  80229a:	85 ff                	test   %edi,%edi
  80229c:	75 0b                	jne    8022a9 <__umoddi3+0xe9>
  80229e:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a3:	31 d2                	xor    %edx,%edx
  8022a5:	f7 f7                	div    %edi
  8022a7:	89 c5                	mov    %eax,%ebp
  8022a9:	89 f0                	mov    %esi,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	f7 f5                	div    %ebp
  8022af:	89 c8                	mov    %ecx,%eax
  8022b1:	f7 f5                	div    %ebp
  8022b3:	89 d0                	mov    %edx,%eax
  8022b5:	e9 44 ff ff ff       	jmp    8021fe <__umoddi3+0x3e>
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	89 c8                	mov    %ecx,%eax
  8022be:	89 f2                	mov    %esi,%edx
  8022c0:	83 c4 1c             	add    $0x1c,%esp
  8022c3:	5b                   	pop    %ebx
  8022c4:	5e                   	pop    %esi
  8022c5:	5f                   	pop    %edi
  8022c6:	5d                   	pop    %ebp
  8022c7:	c3                   	ret    
  8022c8:	3b 04 24             	cmp    (%esp),%eax
  8022cb:	72 06                	jb     8022d3 <__umoddi3+0x113>
  8022cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022d1:	77 0f                	ja     8022e2 <__umoddi3+0x122>
  8022d3:	89 f2                	mov    %esi,%edx
  8022d5:	29 f9                	sub    %edi,%ecx
  8022d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8022db:	89 14 24             	mov    %edx,(%esp)
  8022de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022e6:	8b 14 24             	mov    (%esp),%edx
  8022e9:	83 c4 1c             	add    $0x1c,%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5f                   	pop    %edi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    
  8022f1:	8d 76 00             	lea    0x0(%esi),%esi
  8022f4:	2b 04 24             	sub    (%esp),%eax
  8022f7:	19 fa                	sbb    %edi,%edx
  8022f9:	89 d1                	mov    %edx,%ecx
  8022fb:	89 c6                	mov    %eax,%esi
  8022fd:	e9 71 ff ff ff       	jmp    802273 <__umoddi3+0xb3>
  802302:	66 90                	xchg   %ax,%ax
  802304:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802308:	72 ea                	jb     8022f4 <__umoddi3+0x134>
  80230a:	89 d9                	mov    %ebx,%ecx
  80230c:	e9 62 ff ff ff       	jmp    802273 <__umoddi3+0xb3>
