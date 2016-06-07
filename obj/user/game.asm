
obj/user/game:     file format elf32-i386


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
  800031:	e8 79 00 00 00       	call   8000af <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
	
void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	for(;i<128; i++)
  800045:	eb 5f                	jmp    8000a6 <_main+0x6e>
	{
		int c=0;
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  80004e:	eb 16                	jmp    800066 <_main+0x2e>
		{
			cprintf("%c",i);
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	ff 75 f4             	pushl  -0xc(%ebp)
  800056:	68 80 17 80 00       	push   $0x801780
  80005b:	e8 cb 01 00 00       	call   80022b <cprintf>
  800060:	83 c4 10             	add    $0x10,%esp
{	
	int i=28;
	for(;i<128; i++)
	{
		int c=0;
		for(;c<10; c++)
  800063:	ff 45 f0             	incl   -0x10(%ebp)
  800066:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  80006a:	7e e4                	jle    800050 <_main+0x18>
		{
			cprintf("%c",i);
		}
		int d=0;
  80006c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(; d< 500000; d++);	
  800073:	eb 03                	jmp    800078 <_main+0x40>
  800075:	ff 45 ec             	incl   -0x14(%ebp)
  800078:	81 7d ec 1f a1 07 00 	cmpl   $0x7a11f,-0x14(%ebp)
  80007f:	7e f4                	jle    800075 <_main+0x3d>
		c=0;
  800081:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  800088:	eb 13                	jmp    80009d <_main+0x65>
		{
			cprintf("\b");
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	68 83 17 80 00       	push   $0x801783
  800092:	e8 94 01 00 00       	call   80022b <cprintf>
  800097:	83 c4 10             	add    $0x10,%esp
			cprintf("%c",i);
		}
		int d=0;
		for(; d< 500000; d++);	
		c=0;
		for(;c<10; c++)
  80009a:	ff 45 f0             	incl   -0x10(%ebp)
  80009d:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  8000a1:	7e e7                	jle    80008a <_main+0x52>
	
void
_main(void)
{	
	int i=28;
	for(;i<128; i++)
  8000a3:	ff 45 f4             	incl   -0xc(%ebp)
  8000a6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000aa:	7e 9b                	jle    800047 <_main+0xf>
		{
			cprintf("\b");
		}		
	}
	
	return;	
  8000ac:	90                   	nop
}
  8000ad:	c9                   	leave  
  8000ae:	c3                   	ret    

008000af <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b9:	7e 0a                	jle    8000c5 <libmain+0x16>
		binaryname = argv[0];
  8000bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000be:	8b 00                	mov    (%eax),%eax
  8000c0:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000c5:	83 ec 08             	sub    $0x8,%esp
  8000c8:	ff 75 0c             	pushl  0xc(%ebp)
  8000cb:	ff 75 08             	pushl  0x8(%ebp)
  8000ce:	e8 65 ff ff ff       	call   800038 <_main>
  8000d3:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000d6:	e8 4f 0f 00 00       	call   80102a <sys_getenvid>
  8000db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8000de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000e1:	89 d0                	mov    %edx,%eax
  8000e3:	c1 e0 03             	shl    $0x3,%eax
  8000e6:	01 d0                	add    %edx,%eax
  8000e8:	01 c0                	add    %eax,%eax
  8000ea:	01 d0                	add    %edx,%eax
  8000ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000f3:	01 d0                	add    %edx,%eax
  8000f5:	c1 e0 03             	shl    $0x3,%eax
  8000f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800100:	e8 73 10 00 00       	call   801178 <sys_disable_interrupt>
		cprintf("**************************************\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 a0 17 80 00       	push   $0x8017a0
  80010d:	e8 19 01 00 00       	call   80022b <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800118:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  80011e:	83 ec 08             	sub    $0x8,%esp
  800121:	50                   	push   %eax
  800122:	68 c8 17 80 00       	push   $0x8017c8
  800127:	e8 ff 00 00 00       	call   80022b <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 a0 17 80 00       	push   $0x8017a0
  800137:	e8 ef 00 00 00       	call   80022b <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80013f:	e8 4e 10 00 00       	call   801192 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800144:	e8 19 00 00 00       	call   800162 <exit>
}
  800149:	90                   	nop
  80014a:	c9                   	leave  
  80014b:	c3                   	ret    

0080014c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800152:	83 ec 0c             	sub    $0xc,%esp
  800155:	6a 00                	push   $0x0
  800157:	e8 b3 0e 00 00       	call   80100f <sys_env_destroy>
  80015c:	83 c4 10             	add    $0x10,%esp
}
  80015f:	90                   	nop
  800160:	c9                   	leave  
  800161:	c3                   	ret    

00800162 <exit>:

void
exit(void)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800168:	e8 d6 0e 00 00       	call   801043 <sys_env_exit>
}
  80016d:	90                   	nop
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

00800170 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800176:	8b 45 0c             	mov    0xc(%ebp),%eax
  800179:	8b 00                	mov    (%eax),%eax
  80017b:	8d 48 01             	lea    0x1(%eax),%ecx
  80017e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800181:	89 0a                	mov    %ecx,(%edx)
  800183:	8b 55 08             	mov    0x8(%ebp),%edx
  800186:	88 d1                	mov    %dl,%cl
  800188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80018f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800192:	8b 00                	mov    (%eax),%eax
  800194:	3d ff 00 00 00       	cmp    $0xff,%eax
  800199:	75 23                	jne    8001be <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  80019b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019e:	8b 00                	mov    (%eax),%eax
  8001a0:	89 c2                	mov    %eax,%edx
  8001a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a5:	83 c0 08             	add    $0x8,%eax
  8001a8:	83 ec 08             	sub    $0x8,%esp
  8001ab:	52                   	push   %edx
  8001ac:	50                   	push   %eax
  8001ad:	e8 27 0e 00 00       	call   800fd9 <sys_cputs>
  8001b2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c1:	8b 40 04             	mov    0x4(%eax),%eax
  8001c4:	8d 50 01             	lea    0x1(%eax),%edx
  8001c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ca:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001cd:	90                   	nop
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e0:	00 00 00 
	b.cnt = 0;
  8001e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8001ed:	ff 75 0c             	pushl  0xc(%ebp)
  8001f0:	ff 75 08             	pushl  0x8(%ebp)
  8001f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	68 70 01 80 00       	push   $0x800170
  8001ff:	e8 fa 01 00 00       	call   8003fe <vprintfmt>
  800204:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800207:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	50                   	push   %eax
  800211:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800217:	83 c0 08             	add    $0x8,%eax
  80021a:	50                   	push   %eax
  80021b:	e8 b9 0d 00 00       	call   800fd9 <sys_cputs>
  800220:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800223:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <cprintf>:

int cprintf(const char *fmt, ...) {
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800231:	8d 45 0c             	lea    0xc(%ebp),%eax
  800234:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800237:	8b 45 08             	mov    0x8(%ebp),%eax
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	ff 75 f4             	pushl  -0xc(%ebp)
  800240:	50                   	push   %eax
  800241:	e8 8a ff ff ff       	call   8001d0 <vcprintf>
  800246:	83 c4 10             	add    $0x10,%esp
  800249:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80024c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800257:	e8 1c 0f 00 00       	call   801178 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80025c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800262:	8b 45 08             	mov    0x8(%ebp),%eax
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	ff 75 f4             	pushl  -0xc(%ebp)
  80026b:	50                   	push   %eax
  80026c:	e8 5f ff ff ff       	call   8001d0 <vcprintf>
  800271:	83 c4 10             	add    $0x10,%esp
  800274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800277:	e8 16 0f 00 00       	call   801192 <sys_enable_interrupt>
	return cnt;
  80027c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80027f:	c9                   	leave  
  800280:	c3                   	ret    

00800281 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	53                   	push   %ebx
  800285:	83 ec 14             	sub    $0x14,%esp
  800288:	8b 45 10             	mov    0x10(%ebp),%eax
  80028b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800294:	8b 45 18             	mov    0x18(%ebp),%eax
  800297:	ba 00 00 00 00       	mov    $0x0,%edx
  80029c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80029f:	77 55                	ja     8002f6 <printnum+0x75>
  8002a1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002a4:	72 05                	jb     8002ab <printnum+0x2a>
  8002a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002a9:	77 4b                	ja     8002f6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ab:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002ae:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002b1:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b9:	52                   	push   %edx
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002be:	ff 75 f0             	pushl  -0x10(%ebp)
  8002c1:	e8 4e 12 00 00       	call   801514 <__udivdi3>
  8002c6:	83 c4 10             	add    $0x10,%esp
  8002c9:	83 ec 04             	sub    $0x4,%esp
  8002cc:	ff 75 20             	pushl  0x20(%ebp)
  8002cf:	53                   	push   %ebx
  8002d0:	ff 75 18             	pushl  0x18(%ebp)
  8002d3:	52                   	push   %edx
  8002d4:	50                   	push   %eax
  8002d5:	ff 75 0c             	pushl  0xc(%ebp)
  8002d8:	ff 75 08             	pushl  0x8(%ebp)
  8002db:	e8 a1 ff ff ff       	call   800281 <printnum>
  8002e0:	83 c4 20             	add    $0x20,%esp
  8002e3:	eb 1a                	jmp    8002ff <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	ff 75 0c             	pushl  0xc(%ebp)
  8002eb:	ff 75 20             	pushl  0x20(%ebp)
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	ff d0                	call   *%eax
  8002f3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002f6:	ff 4d 1c             	decl   0x1c(%ebp)
  8002f9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8002fd:	7f e6                	jg     8002e5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ff:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800302:	bb 00 00 00 00       	mov    $0x0,%ebx
  800307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80030d:	53                   	push   %ebx
  80030e:	51                   	push   %ecx
  80030f:	52                   	push   %edx
  800310:	50                   	push   %eax
  800311:	e8 0e 13 00 00       	call   801624 <__umoddi3>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	05 14 1a 80 00       	add    $0x801a14,%eax
  80031e:	8a 00                	mov    (%eax),%al
  800320:	0f be c0             	movsbl %al,%eax
  800323:	83 ec 08             	sub    $0x8,%esp
  800326:	ff 75 0c             	pushl  0xc(%ebp)
  800329:	50                   	push   %eax
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	ff d0                	call   *%eax
  80032f:	83 c4 10             	add    $0x10,%esp
}
  800332:	90                   	nop
  800333:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800336:	c9                   	leave  
  800337:	c3                   	ret    

00800338 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80033b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80033f:	7e 1c                	jle    80035d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800341:	8b 45 08             	mov    0x8(%ebp),%eax
  800344:	8b 00                	mov    (%eax),%eax
  800346:	8d 50 08             	lea    0x8(%eax),%edx
  800349:	8b 45 08             	mov    0x8(%ebp),%eax
  80034c:	89 10                	mov    %edx,(%eax)
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	83 e8 08             	sub    $0x8,%eax
  800356:	8b 50 04             	mov    0x4(%eax),%edx
  800359:	8b 00                	mov    (%eax),%eax
  80035b:	eb 40                	jmp    80039d <getuint+0x65>
	else if (lflag)
  80035d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800361:	74 1e                	je     800381 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800363:	8b 45 08             	mov    0x8(%ebp),%eax
  800366:	8b 00                	mov    (%eax),%eax
  800368:	8d 50 04             	lea    0x4(%eax),%edx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	89 10                	mov    %edx,(%eax)
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	83 e8 04             	sub    $0x4,%eax
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	ba 00 00 00 00       	mov    $0x0,%edx
  80037f:	eb 1c                	jmp    80039d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	8b 00                	mov    (%eax),%eax
  800386:	8d 50 04             	lea    0x4(%eax),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	89 10                	mov    %edx,(%eax)
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	8b 00                	mov    (%eax),%eax
  800393:	83 e8 04             	sub    $0x4,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80039d:	5d                   	pop    %ebp
  80039e:	c3                   	ret    

0080039f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003a2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003a6:	7e 1c                	jle    8003c4 <getint+0x25>
		return va_arg(*ap, long long);
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	8d 50 08             	lea    0x8(%eax),%edx
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	89 10                	mov    %edx,(%eax)
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	8b 00                	mov    (%eax),%eax
  8003ba:	83 e8 08             	sub    $0x8,%eax
  8003bd:	8b 50 04             	mov    0x4(%eax),%edx
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	eb 38                	jmp    8003fc <getint+0x5d>
	else if (lflag)
  8003c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003c8:	74 1a                	je     8003e4 <getint+0x45>
		return va_arg(*ap, long);
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	8d 50 04             	lea    0x4(%eax),%edx
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	89 10                	mov    %edx,(%eax)
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	83 e8 04             	sub    $0x4,%eax
  8003df:	8b 00                	mov    (%eax),%eax
  8003e1:	99                   	cltd   
  8003e2:	eb 18                	jmp    8003fc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	8d 50 04             	lea    0x4(%eax),%edx
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ef:	89 10                	mov    %edx,(%eax)
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	83 e8 04             	sub    $0x4,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	99                   	cltd   
}
  8003fc:	5d                   	pop    %ebp
  8003fd:	c3                   	ret    

008003fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	56                   	push   %esi
  800402:	53                   	push   %ebx
  800403:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800406:	eb 17                	jmp    80041f <vprintfmt+0x21>
			if (ch == '\0')
  800408:	85 db                	test   %ebx,%ebx
  80040a:	0f 84 af 03 00 00    	je     8007bf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	ff 75 0c             	pushl  0xc(%ebp)
  800416:	53                   	push   %ebx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	ff d0                	call   *%eax
  80041c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80041f:	8b 45 10             	mov    0x10(%ebp),%eax
  800422:	8d 50 01             	lea    0x1(%eax),%edx
  800425:	89 55 10             	mov    %edx,0x10(%ebp)
  800428:	8a 00                	mov    (%eax),%al
  80042a:	0f b6 d8             	movzbl %al,%ebx
  80042d:	83 fb 25             	cmp    $0x25,%ebx
  800430:	75 d6                	jne    800408 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800432:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800436:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80043d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800444:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80044b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800452:	8b 45 10             	mov    0x10(%ebp),%eax
  800455:	8d 50 01             	lea    0x1(%eax),%edx
  800458:	89 55 10             	mov    %edx,0x10(%ebp)
  80045b:	8a 00                	mov    (%eax),%al
  80045d:	0f b6 d8             	movzbl %al,%ebx
  800460:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800463:	83 f8 55             	cmp    $0x55,%eax
  800466:	0f 87 2b 03 00 00    	ja     800797 <vprintfmt+0x399>
  80046c:	8b 04 85 38 1a 80 00 	mov    0x801a38(,%eax,4),%eax
  800473:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800475:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800479:	eb d7                	jmp    800452 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80047b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80047f:	eb d1                	jmp    800452 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800481:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800488:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	c1 e0 02             	shl    $0x2,%eax
  800490:	01 d0                	add    %edx,%eax
  800492:	01 c0                	add    %eax,%eax
  800494:	01 d8                	add    %ebx,%eax
  800496:	83 e8 30             	sub    $0x30,%eax
  800499:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80049c:	8b 45 10             	mov    0x10(%ebp),%eax
  80049f:	8a 00                	mov    (%eax),%al
  8004a1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004a4:	83 fb 2f             	cmp    $0x2f,%ebx
  8004a7:	7e 3e                	jle    8004e7 <vprintfmt+0xe9>
  8004a9:	83 fb 39             	cmp    $0x39,%ebx
  8004ac:	7f 39                	jg     8004e7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ae:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004b1:	eb d5                	jmp    800488 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b6:	83 c0 04             	add    $0x4,%eax
  8004b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	83 e8 04             	sub    $0x4,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004c7:	eb 1f                	jmp    8004e8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8004c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004cd:	79 83                	jns    800452 <vprintfmt+0x54>
				width = 0;
  8004cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8004d6:	e9 77 ff ff ff       	jmp    800452 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8004db:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004e2:	e9 6b ff ff ff       	jmp    800452 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8004e7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004ec:	0f 89 60 ff ff ff    	jns    800452 <vprintfmt+0x54>
				width = precision, precision = -1;
  8004f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8004ff:	e9 4e ff ff ff       	jmp    800452 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800504:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800507:	e9 46 ff ff ff       	jmp    800452 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80050c:	8b 45 14             	mov    0x14(%ebp),%eax
  80050f:	83 c0 04             	add    $0x4,%eax
  800512:	89 45 14             	mov    %eax,0x14(%ebp)
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	83 e8 04             	sub    $0x4,%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	ff 75 0c             	pushl  0xc(%ebp)
  800523:	50                   	push   %eax
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	ff d0                	call   *%eax
  800529:	83 c4 10             	add    $0x10,%esp
			break;
  80052c:	e9 89 02 00 00       	jmp    8007ba <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	83 c0 04             	add    $0x4,%eax
  800537:	89 45 14             	mov    %eax,0x14(%ebp)
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	83 e8 04             	sub    $0x4,%eax
  800540:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800542:	85 db                	test   %ebx,%ebx
  800544:	79 02                	jns    800548 <vprintfmt+0x14a>
				err = -err;
  800546:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800548:	83 fb 64             	cmp    $0x64,%ebx
  80054b:	7f 0b                	jg     800558 <vprintfmt+0x15a>
  80054d:	8b 34 9d 80 18 80 00 	mov    0x801880(,%ebx,4),%esi
  800554:	85 f6                	test   %esi,%esi
  800556:	75 19                	jne    800571 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800558:	53                   	push   %ebx
  800559:	68 25 1a 80 00       	push   $0x801a25
  80055e:	ff 75 0c             	pushl  0xc(%ebp)
  800561:	ff 75 08             	pushl  0x8(%ebp)
  800564:	e8 5e 02 00 00       	call   8007c7 <printfmt>
  800569:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80056c:	e9 49 02 00 00       	jmp    8007ba <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800571:	56                   	push   %esi
  800572:	68 2e 1a 80 00       	push   $0x801a2e
  800577:	ff 75 0c             	pushl  0xc(%ebp)
  80057a:	ff 75 08             	pushl  0x8(%ebp)
  80057d:	e8 45 02 00 00       	call   8007c7 <printfmt>
  800582:	83 c4 10             	add    $0x10,%esp
			break;
  800585:	e9 30 02 00 00       	jmp    8007ba <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	83 c0 04             	add    $0x4,%eax
  800590:	89 45 14             	mov    %eax,0x14(%ebp)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	83 e8 04             	sub    $0x4,%eax
  800599:	8b 30                	mov    (%eax),%esi
  80059b:	85 f6                	test   %esi,%esi
  80059d:	75 05                	jne    8005a4 <vprintfmt+0x1a6>
				p = "(null)";
  80059f:	be 31 1a 80 00       	mov    $0x801a31,%esi
			if (width > 0 && padc != '-')
  8005a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a8:	7e 6d                	jle    800617 <vprintfmt+0x219>
  8005aa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005ae:	74 67                	je     800617 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	50                   	push   %eax
  8005b7:	56                   	push   %esi
  8005b8:	e8 0c 03 00 00       	call   8008c9 <strnlen>
  8005bd:	83 c4 10             	add    $0x10,%esp
  8005c0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005c3:	eb 16                	jmp    8005db <vprintfmt+0x1dd>
					putch(padc, putdat);
  8005c5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	ff 75 0c             	pushl  0xc(%ebp)
  8005cf:	50                   	push   %eax
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	ff d0                	call   *%eax
  8005d5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d8:	ff 4d e4             	decl   -0x1c(%ebp)
  8005db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005df:	7f e4                	jg     8005c5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e1:	eb 34                	jmp    800617 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005e7:	74 1c                	je     800605 <vprintfmt+0x207>
  8005e9:	83 fb 1f             	cmp    $0x1f,%ebx
  8005ec:	7e 05                	jle    8005f3 <vprintfmt+0x1f5>
  8005ee:	83 fb 7e             	cmp    $0x7e,%ebx
  8005f1:	7e 12                	jle    800605 <vprintfmt+0x207>
					putch('?', putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	6a 3f                	push   $0x3f
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	ff d0                	call   *%eax
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	eb 0f                	jmp    800614 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	53                   	push   %ebx
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	ff d0                	call   *%eax
  800611:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800614:	ff 4d e4             	decl   -0x1c(%ebp)
  800617:	89 f0                	mov    %esi,%eax
  800619:	8d 70 01             	lea    0x1(%eax),%esi
  80061c:	8a 00                	mov    (%eax),%al
  80061e:	0f be d8             	movsbl %al,%ebx
  800621:	85 db                	test   %ebx,%ebx
  800623:	74 24                	je     800649 <vprintfmt+0x24b>
  800625:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800629:	78 b8                	js     8005e3 <vprintfmt+0x1e5>
  80062b:	ff 4d e0             	decl   -0x20(%ebp)
  80062e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800632:	79 af                	jns    8005e3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800634:	eb 13                	jmp    800649 <vprintfmt+0x24b>
				putch(' ', putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	6a 20                	push   $0x20
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	ff d0                	call   *%eax
  800643:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800646:	ff 4d e4             	decl   -0x1c(%ebp)
  800649:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064d:	7f e7                	jg     800636 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80064f:	e9 66 01 00 00       	jmp    8007ba <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 e8             	pushl  -0x18(%ebp)
  80065a:	8d 45 14             	lea    0x14(%ebp),%eax
  80065d:	50                   	push   %eax
  80065e:	e8 3c fd ff ff       	call   80039f <getint>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800669:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800672:	85 d2                	test   %edx,%edx
  800674:	79 23                	jns    800699 <vprintfmt+0x29b>
				putch('-', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	6a 2d                	push   $0x2d
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	ff d0                	call   *%eax
  800683:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800689:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80068c:	f7 d8                	neg    %eax
  80068e:	83 d2 00             	adc    $0x0,%edx
  800691:	f7 da                	neg    %edx
  800693:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800696:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800699:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006a0:	e9 bc 00 00 00       	jmp    800761 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 e8             	pushl  -0x18(%ebp)
  8006ab:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ae:	50                   	push   %eax
  8006af:	e8 84 fc ff ff       	call   800338 <getuint>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006c4:	e9 98 00 00 00       	jmp    800761 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	6a 58                	push   $0x58
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	ff d0                	call   *%eax
  8006d6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	6a 58                	push   $0x58
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	ff d0                	call   *%eax
  8006e6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 0c             	pushl  0xc(%ebp)
  8006ef:	6a 58                	push   $0x58
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	ff d0                	call   *%eax
  8006f6:	83 c4 10             	add    $0x10,%esp
			break;
  8006f9:	e9 bc 00 00 00       	jmp    8007ba <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	ff 75 0c             	pushl  0xc(%ebp)
  800704:	6a 30                	push   $0x30
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	ff d0                	call   *%eax
  80070b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	6a 78                	push   $0x78
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	83 c0 04             	add    $0x4,%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	83 e8 04             	sub    $0x4,%eax
  80072d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80072f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800739:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800740:	eb 1f                	jmp    800761 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	ff 75 e8             	pushl  -0x18(%ebp)
  800748:	8d 45 14             	lea    0x14(%ebp),%eax
  80074b:	50                   	push   %eax
  80074c:	e8 e7 fb ff ff       	call   800338 <getuint>
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800757:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80075a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800761:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	52                   	push   %edx
  80076c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80076f:	50                   	push   %eax
  800770:	ff 75 f4             	pushl  -0xc(%ebp)
  800773:	ff 75 f0             	pushl  -0x10(%ebp)
  800776:	ff 75 0c             	pushl  0xc(%ebp)
  800779:	ff 75 08             	pushl  0x8(%ebp)
  80077c:	e8 00 fb ff ff       	call   800281 <printnum>
  800781:	83 c4 20             	add    $0x20,%esp
			break;
  800784:	eb 34                	jmp    8007ba <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	ff 75 0c             	pushl  0xc(%ebp)
  80078c:	53                   	push   %ebx
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	ff d0                	call   *%eax
  800792:	83 c4 10             	add    $0x10,%esp
			break;
  800795:	eb 23                	jmp    8007ba <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	6a 25                	push   $0x25
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	ff d0                	call   *%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007a7:	ff 4d 10             	decl   0x10(%ebp)
  8007aa:	eb 03                	jmp    8007af <vprintfmt+0x3b1>
  8007ac:	ff 4d 10             	decl   0x10(%ebp)
  8007af:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b2:	48                   	dec    %eax
  8007b3:	8a 00                	mov    (%eax),%al
  8007b5:	3c 25                	cmp    $0x25,%al
  8007b7:	75 f3                	jne    8007ac <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007b9:	90                   	nop
		}
	}
  8007ba:	e9 47 fc ff ff       	jmp    800406 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007bf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007c3:	5b                   	pop    %ebx
  8007c4:	5e                   	pop    %esi
  8007c5:	5d                   	pop    %ebp
  8007c6:	c3                   	ret    

008007c7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8007cd:	8d 45 10             	lea    0x10(%ebp),%eax
  8007d0:	83 c0 04             	add    $0x4,%eax
  8007d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8007d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007dc:	50                   	push   %eax
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	ff 75 08             	pushl  0x8(%ebp)
  8007e3:	e8 16 fc ff ff       	call   8003fe <vprintfmt>
  8007e8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8007eb:	90                   	nop
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    

008007ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	8b 40 08             	mov    0x8(%eax),%eax
  8007f7:	8d 50 01             	lea    0x1(%eax),%edx
  8007fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	8b 10                	mov    (%eax),%edx
  800805:	8b 45 0c             	mov    0xc(%ebp),%eax
  800808:	8b 40 04             	mov    0x4(%eax),%eax
  80080b:	39 c2                	cmp    %eax,%edx
  80080d:	73 12                	jae    800821 <sprintputch+0x33>
		*b->buf++ = ch;
  80080f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	8d 48 01             	lea    0x1(%eax),%ecx
  800817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081a:	89 0a                	mov    %ecx,(%edx)
  80081c:	8b 55 08             	mov    0x8(%ebp),%edx
  80081f:	88 10                	mov    %dl,(%eax)
}
  800821:	90                   	nop
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800830:	8b 45 0c             	mov    0xc(%ebp),%eax
  800833:	8d 50 ff             	lea    -0x1(%eax),%edx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80083e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800845:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800849:	74 06                	je     800851 <vsnprintf+0x2d>
  80084b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084f:	7f 07                	jg     800858 <vsnprintf+0x34>
		return -E_INVAL;
  800851:	b8 03 00 00 00       	mov    $0x3,%eax
  800856:	eb 20                	jmp    800878 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800858:	ff 75 14             	pushl  0x14(%ebp)
  80085b:	ff 75 10             	pushl  0x10(%ebp)
  80085e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800861:	50                   	push   %eax
  800862:	68 ee 07 80 00       	push   $0x8007ee
  800867:	e8 92 fb ff ff       	call   8003fe <vprintfmt>
  80086c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80086f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800872:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800875:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800880:	8d 45 10             	lea    0x10(%ebp),%eax
  800883:	83 c0 04             	add    $0x4,%eax
  800886:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800889:	8b 45 10             	mov    0x10(%ebp),%eax
  80088c:	ff 75 f4             	pushl  -0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	ff 75 0c             	pushl  0xc(%ebp)
  800893:	ff 75 08             	pushl  0x8(%ebp)
  800896:	e8 89 ff ff ff       	call   800824 <vsnprintf>
  80089b:	83 c4 10             	add    $0x10,%esp
  80089e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    

008008a6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008b3:	eb 06                	jmp    8008bb <strlen+0x15>
		n++;
  8008b5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b8:	ff 45 08             	incl   0x8(%ebp)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8a 00                	mov    (%eax),%al
  8008c0:	84 c0                	test   %al,%al
  8008c2:	75 f1                	jne    8008b5 <strlen+0xf>
		n++;
	return n;
  8008c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008d6:	eb 09                	jmp    8008e1 <strnlen+0x18>
		n++;
  8008d8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	ff 45 08             	incl   0x8(%ebp)
  8008de:	ff 4d 0c             	decl   0xc(%ebp)
  8008e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e5:	74 09                	je     8008f0 <strnlen+0x27>
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8a 00                	mov    (%eax),%al
  8008ec:	84 c0                	test   %al,%al
  8008ee:	75 e8                	jne    8008d8 <strnlen+0xf>
		n++;
	return n;
  8008f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008f3:	c9                   	leave  
  8008f4:	c3                   	ret    

008008f5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800901:	90                   	nop
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8d 50 01             	lea    0x1(%eax),%edx
  800908:	89 55 08             	mov    %edx,0x8(%ebp)
  80090b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800911:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800914:	8a 12                	mov    (%edx),%dl
  800916:	88 10                	mov    %dl,(%eax)
  800918:	8a 00                	mov    (%eax),%al
  80091a:	84 c0                	test   %al,%al
  80091c:	75 e4                	jne    800902 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80091e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800921:	c9                   	leave  
  800922:	c3                   	ret    

00800923 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80092f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800936:	eb 1f                	jmp    800957 <strncpy+0x34>
		*dst++ = *src;
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	8d 50 01             	lea    0x1(%eax),%edx
  80093e:	89 55 08             	mov    %edx,0x8(%ebp)
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
  800944:	8a 12                	mov    (%edx),%dl
  800946:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8a 00                	mov    (%eax),%al
  80094d:	84 c0                	test   %al,%al
  80094f:	74 03                	je     800954 <strncpy+0x31>
			src++;
  800951:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800954:	ff 45 fc             	incl   -0x4(%ebp)
  800957:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80095a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80095d:	72 d9                	jb     800938 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80095f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800970:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800974:	74 30                	je     8009a6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800976:	eb 16                	jmp    80098e <strlcpy+0x2a>
			*dst++ = *src++;
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8d 50 01             	lea    0x1(%eax),%edx
  80097e:	89 55 08             	mov    %edx,0x8(%ebp)
  800981:	8b 55 0c             	mov    0xc(%ebp),%edx
  800984:	8d 4a 01             	lea    0x1(%edx),%ecx
  800987:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80098a:	8a 12                	mov    (%edx),%dl
  80098c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80098e:	ff 4d 10             	decl   0x10(%ebp)
  800991:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800995:	74 09                	je     8009a0 <strlcpy+0x3c>
  800997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099a:	8a 00                	mov    (%eax),%al
  80099c:	84 c0                	test   %al,%al
  80099e:	75 d8                	jne    800978 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8009a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009ac:	29 c2                	sub    %eax,%edx
  8009ae:	89 d0                	mov    %edx,%eax
}
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009b5:	eb 06                	jmp    8009bd <strcmp+0xb>
		p++, q++;
  8009b7:	ff 45 08             	incl   0x8(%ebp)
  8009ba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8a 00                	mov    (%eax),%al
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 0e                	je     8009d4 <strcmp+0x22>
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8a 10                	mov    (%eax),%dl
  8009cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ce:	8a 00                	mov    (%eax),%al
  8009d0:	38 c2                	cmp    %al,%dl
  8009d2:	74 e3                	je     8009b7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	8a 00                	mov    (%eax),%al
  8009d9:	0f b6 d0             	movzbl %al,%edx
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	8a 00                	mov    (%eax),%al
  8009e1:	0f b6 c0             	movzbl %al,%eax
  8009e4:	29 c2                	sub    %eax,%edx
  8009e6:	89 d0                	mov    %edx,%eax
}
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8009ed:	eb 09                	jmp    8009f8 <strncmp+0xe>
		n--, p++, q++;
  8009ef:	ff 4d 10             	decl   0x10(%ebp)
  8009f2:	ff 45 08             	incl   0x8(%ebp)
  8009f5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8009f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009fc:	74 17                	je     800a15 <strncmp+0x2b>
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8a 00                	mov    (%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	74 0e                	je     800a15 <strncmp+0x2b>
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8a 10                	mov    (%eax),%dl
  800a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0f:	8a 00                	mov    (%eax),%al
  800a11:	38 c2                	cmp    %al,%dl
  800a13:	74 da                	je     8009ef <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a19:	75 07                	jne    800a22 <strncmp+0x38>
		return 0;
  800a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a20:	eb 14                	jmp    800a36 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8a 00                	mov    (%eax),%al
  800a27:	0f b6 d0             	movzbl %al,%edx
  800a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2d:	8a 00                	mov    (%eax),%al
  800a2f:	0f b6 c0             	movzbl %al,%eax
  800a32:	29 c2                	sub    %eax,%edx
  800a34:	89 d0                	mov    %edx,%eax
}
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	83 ec 04             	sub    $0x4,%esp
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a44:	eb 12                	jmp    800a58 <strchr+0x20>
		if (*s == c)
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a4e:	75 05                	jne    800a55 <strchr+0x1d>
			return (char *) s;
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	eb 11                	jmp    800a66 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a55:	ff 45 08             	incl   0x8(%ebp)
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8a 00                	mov    (%eax),%al
  800a5d:	84 c0                	test   %al,%al
  800a5f:	75 e5                	jne    800a46 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a66:	c9                   	leave  
  800a67:	c3                   	ret    

00800a68 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	83 ec 04             	sub    $0x4,%esp
  800a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a71:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a74:	eb 0d                	jmp    800a83 <strfind+0x1b>
		if (*s == c)
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a7e:	74 0e                	je     800a8e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a80:	ff 45 08             	incl   0x8(%ebp)
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8a 00                	mov    (%eax),%al
  800a88:	84 c0                	test   %al,%al
  800a8a:	75 ea                	jne    800a76 <strfind+0xe>
  800a8c:	eb 01                	jmp    800a8f <strfind+0x27>
		if (*s == c)
			break;
  800a8e:	90                   	nop
	return (char *) s;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800a92:	c9                   	leave  
  800a93:	c3                   	ret    

00800a94 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800aa6:	eb 0e                	jmp    800ab6 <memset+0x22>
		*p++ = c;
  800aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aab:	8d 50 01             	lea    0x1(%eax),%edx
  800aae:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ab6:	ff 4d f8             	decl   -0x8(%ebp)
  800ab9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800abd:	79 e9                	jns    800aa8 <memset+0x14>
		*p++ = c;

	return v;
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ad6:	eb 16                	jmp    800aee <memcpy+0x2a>
		*d++ = *s++;
  800ad8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800adb:	8d 50 01             	lea    0x1(%eax),%edx
  800ade:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ae1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ae4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ae7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800aea:	8a 12                	mov    (%edx),%dl
  800aec:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800aee:	8b 45 10             	mov    0x10(%ebp),%eax
  800af1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800af4:	89 55 10             	mov    %edx,0x10(%ebp)
  800af7:	85 c0                	test   %eax,%eax
  800af9:	75 dd                	jne    800ad8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b15:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b18:	73 50                	jae    800b6a <memmove+0x6a>
  800b1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b20:	01 d0                	add    %edx,%eax
  800b22:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b25:	76 43                	jbe    800b6a <memmove+0x6a>
		s += n;
  800b27:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b30:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b33:	eb 10                	jmp    800b45 <memmove+0x45>
			*--d = *--s;
  800b35:	ff 4d f8             	decl   -0x8(%ebp)
  800b38:	ff 4d fc             	decl   -0x4(%ebp)
  800b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b3e:	8a 10                	mov    (%eax),%dl
  800b40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b43:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b45:	8b 45 10             	mov    0x10(%ebp),%eax
  800b48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b4e:	85 c0                	test   %eax,%eax
  800b50:	75 e3                	jne    800b35 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b52:	eb 23                	jmp    800b77 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b57:	8d 50 01             	lea    0x1(%eax),%edx
  800b5a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b63:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b66:	8a 12                	mov    (%edx),%dl
  800b68:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b70:	89 55 10             	mov    %edx,0x10(%ebp)
  800b73:	85 c0                	test   %eax,%eax
  800b75:	75 dd                	jne    800b54 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800b8e:	eb 2a                	jmp    800bba <memcmp+0x3e>
		if (*s1 != *s2)
  800b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b93:	8a 10                	mov    (%eax),%dl
  800b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b98:	8a 00                	mov    (%eax),%al
  800b9a:	38 c2                	cmp    %al,%dl
  800b9c:	74 16                	je     800bb4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800b9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba1:	8a 00                	mov    (%eax),%al
  800ba3:	0f b6 d0             	movzbl %al,%edx
  800ba6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	0f b6 c0             	movzbl %al,%eax
  800bae:	29 c2                	sub    %eax,%edx
  800bb0:	89 d0                	mov    %edx,%eax
  800bb2:	eb 18                	jmp    800bcc <memcmp+0x50>
		s1++, s2++;
  800bb4:	ff 45 fc             	incl   -0x4(%ebp)
  800bb7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc3:	85 c0                	test   %eax,%eax
  800bc5:	75 c9                	jne    800b90 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    

00800bce <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bda:	01 d0                	add    %edx,%eax
  800bdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800bdf:	eb 15                	jmp    800bf6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	8a 00                	mov    (%eax),%al
  800be6:	0f b6 d0             	movzbl %al,%edx
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bec:	0f b6 c0             	movzbl %al,%eax
  800bef:	39 c2                	cmp    %eax,%edx
  800bf1:	74 0d                	je     800c00 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bf3:	ff 45 08             	incl   0x8(%ebp)
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800bfc:	72 e3                	jb     800be1 <memfind+0x13>
  800bfe:	eb 01                	jmp    800c01 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c00:	90                   	nop
	return (void *) s;
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c1a:	eb 03                	jmp    800c1f <strtol+0x19>
		s++;
  800c1c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8a 00                	mov    (%eax),%al
  800c24:	3c 20                	cmp    $0x20,%al
  800c26:	74 f4                	je     800c1c <strtol+0x16>
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8a 00                	mov    (%eax),%al
  800c2d:	3c 09                	cmp    $0x9,%al
  800c2f:	74 eb                	je     800c1c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	8a 00                	mov    (%eax),%al
  800c36:	3c 2b                	cmp    $0x2b,%al
  800c38:	75 05                	jne    800c3f <strtol+0x39>
		s++;
  800c3a:	ff 45 08             	incl   0x8(%ebp)
  800c3d:	eb 13                	jmp    800c52 <strtol+0x4c>
	else if (*s == '-')
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	3c 2d                	cmp    $0x2d,%al
  800c46:	75 0a                	jne    800c52 <strtol+0x4c>
		s++, neg = 1;
  800c48:	ff 45 08             	incl   0x8(%ebp)
  800c4b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c56:	74 06                	je     800c5e <strtol+0x58>
  800c58:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c5c:	75 20                	jne    800c7e <strtol+0x78>
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	3c 30                	cmp    $0x30,%al
  800c65:	75 17                	jne    800c7e <strtol+0x78>
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	40                   	inc    %eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	3c 78                	cmp    $0x78,%al
  800c6f:	75 0d                	jne    800c7e <strtol+0x78>
		s += 2, base = 16;
  800c71:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800c75:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c7c:	eb 28                	jmp    800ca6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800c7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c82:	75 15                	jne    800c99 <strtol+0x93>
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	3c 30                	cmp    $0x30,%al
  800c8b:	75 0c                	jne    800c99 <strtol+0x93>
		s++, base = 8;
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800c97:	eb 0d                	jmp    800ca6 <strtol+0xa0>
	else if (base == 0)
  800c99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9d:	75 07                	jne    800ca6 <strtol+0xa0>
		base = 10;
  800c9f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	3c 2f                	cmp    $0x2f,%al
  800cad:	7e 19                	jle    800cc8 <strtol+0xc2>
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	3c 39                	cmp    $0x39,%al
  800cb6:	7f 10                	jg     800cc8 <strtol+0xc2>
			dig = *s - '0';
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	0f be c0             	movsbl %al,%eax
  800cc0:	83 e8 30             	sub    $0x30,%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800cc6:	eb 42                	jmp    800d0a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	3c 60                	cmp    $0x60,%al
  800ccf:	7e 19                	jle    800cea <strtol+0xe4>
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	3c 7a                	cmp    $0x7a,%al
  800cd8:	7f 10                	jg     800cea <strtol+0xe4>
			dig = *s - 'a' + 10;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f be c0             	movsbl %al,%eax
  800ce2:	83 e8 57             	sub    $0x57,%eax
  800ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ce8:	eb 20                	jmp    800d0a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	3c 40                	cmp    $0x40,%al
  800cf1:	7e 39                	jle    800d2c <strtol+0x126>
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	3c 5a                	cmp    $0x5a,%al
  800cfa:	7f 30                	jg     800d2c <strtol+0x126>
			dig = *s - 'A' + 10;
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f be c0             	movsbl %al,%eax
  800d04:	83 e8 37             	sub    $0x37,%eax
  800d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d0d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d10:	7d 19                	jge    800d2b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d18:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d1c:	89 c2                	mov    %eax,%edx
  800d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d21:	01 d0                	add    %edx,%eax
  800d23:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d26:	e9 7b ff ff ff       	jmp    800ca6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d2b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d30:	74 08                	je     800d3a <strtol+0x134>
		*endptr = (char *) s;
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d3e:	74 07                	je     800d47 <strtol+0x141>
  800d40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d43:	f7 d8                	neg    %eax
  800d45:	eb 03                	jmp    800d4a <strtol+0x144>
  800d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <ltostr>:

void
ltostr(long value, char *str)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d64:	79 13                	jns    800d79 <ltostr+0x2d>
	{
		neg = 1;
  800d66:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800d73:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800d76:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800d81:	99                   	cltd   
  800d82:	f7 f9                	idiv   %ecx
  800d84:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d90:	89 c2                	mov    %eax,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	01 d0                	add    %edx,%eax
  800d97:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d9a:	83 c2 30             	add    $0x30,%edx
  800d9d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800d9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800da7:	f7 e9                	imul   %ecx
  800da9:	c1 fa 02             	sar    $0x2,%edx
  800dac:	89 c8                	mov    %ecx,%eax
  800dae:	c1 f8 1f             	sar    $0x1f,%eax
  800db1:	29 c2                	sub    %eax,%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800db8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dc0:	f7 e9                	imul   %ecx
  800dc2:	c1 fa 02             	sar    $0x2,%edx
  800dc5:	89 c8                	mov    %ecx,%eax
  800dc7:	c1 f8 1f             	sar    $0x1f,%eax
  800dca:	29 c2                	sub    %eax,%edx
  800dcc:	89 d0                	mov    %edx,%eax
  800dce:	c1 e0 02             	shl    $0x2,%eax
  800dd1:	01 d0                	add    %edx,%eax
  800dd3:	01 c0                	add    %eax,%eax
  800dd5:	29 c1                	sub    %eax,%ecx
  800dd7:	89 ca                	mov    %ecx,%edx
  800dd9:	85 d2                	test   %edx,%edx
  800ddb:	75 9c                	jne    800d79 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ddd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800de4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de7:	48                   	dec    %eax
  800de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800deb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800def:	74 3d                	je     800e2e <ltostr+0xe2>
		start = 1 ;
  800df1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800df8:	eb 34                	jmp    800e2e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	01 d0                	add    %edx,%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	01 c2                	add    %eax,%edx
  800e0f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	01 c8                	add    %ecx,%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	01 c2                	add    %eax,%edx
  800e23:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e26:	88 02                	mov    %al,(%edx)
		start++ ;
  800e28:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e2b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e31:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e34:	7c c4                	jl     800dfa <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e36:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	01 d0                	add    %edx,%eax
  800e3e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e41:	90                   	nop
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e4a:	ff 75 08             	pushl  0x8(%ebp)
  800e4d:	e8 54 fa ff ff       	call   8008a6 <strlen>
  800e52:	83 c4 04             	add    $0x4,%esp
  800e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	e8 46 fa ff ff       	call   8008a6 <strlen>
  800e60:	83 c4 04             	add    $0x4,%esp
  800e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800e6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e74:	eb 17                	jmp    800e8d <strcconcat+0x49>
		final[s] = str1[s] ;
  800e76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	01 c2                	add    %eax,%edx
  800e7e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	01 c8                	add    %ecx,%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800e8a:	ff 45 fc             	incl   -0x4(%ebp)
  800e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e90:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e93:	7c e1                	jl     800e76 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800e95:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800e9c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ea3:	eb 1f                	jmp    800ec4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8d 50 01             	lea    0x1(%eax),%edx
  800eab:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eae:	89 c2                	mov    %eax,%edx
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	01 c2                	add    %eax,%edx
  800eb5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	01 c8                	add    %ecx,%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ec1:	ff 45 f8             	incl   -0x8(%ebp)
  800ec4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eca:	7c d9                	jl     800ea5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ecc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed2:	01 d0                	add    %edx,%eax
  800ed4:	c6 00 00             	movb   $0x0,(%eax)
}
  800ed7:	90                   	nop
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800ee6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee9:	8b 00                	mov    (%eax),%eax
  800eeb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800efd:	eb 0c                	jmp    800f0b <strsplit+0x31>
			*string++ = 0;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8d 50 01             	lea    0x1(%eax),%edx
  800f05:	89 55 08             	mov    %edx,0x8(%ebp)
  800f08:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	84 c0                	test   %al,%al
  800f12:	74 18                	je     800f2c <strsplit+0x52>
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	0f be c0             	movsbl %al,%eax
  800f1c:	50                   	push   %eax
  800f1d:	ff 75 0c             	pushl  0xc(%ebp)
  800f20:	e8 13 fb ff ff       	call   800a38 <strchr>
  800f25:	83 c4 08             	add    $0x8,%esp
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	75 d3                	jne    800eff <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	84 c0                	test   %al,%al
  800f33:	74 5a                	je     800f8f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  800f35:	8b 45 14             	mov    0x14(%ebp),%eax
  800f38:	8b 00                	mov    (%eax),%eax
  800f3a:	83 f8 0f             	cmp    $0xf,%eax
  800f3d:	75 07                	jne    800f46 <strsplit+0x6c>
		{
			return 0;
  800f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f44:	eb 66                	jmp    800fac <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f46:	8b 45 14             	mov    0x14(%ebp),%eax
  800f49:	8b 00                	mov    (%eax),%eax
  800f4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800f4e:	8b 55 14             	mov    0x14(%ebp),%edx
  800f51:	89 0a                	mov    %ecx,(%edx)
  800f53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 c2                	add    %eax,%edx
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f64:	eb 03                	jmp    800f69 <strsplit+0x8f>
			string++;
  800f66:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	84 c0                	test   %al,%al
  800f70:	74 8b                	je     800efd <strsplit+0x23>
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	0f be c0             	movsbl %al,%eax
  800f7a:	50                   	push   %eax
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	e8 b5 fa ff ff       	call   800a38 <strchr>
  800f83:	83 c4 08             	add    $0x8,%esp
  800f86:	85 c0                	test   %eax,%eax
  800f88:	74 dc                	je     800f66 <strsplit+0x8c>
			string++;
	}
  800f8a:	e9 6e ff ff ff       	jmp    800efd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800f8f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800f90:	8b 45 14             	mov    0x14(%ebp),%eax
  800f93:	8b 00                	mov    (%eax),%eax
  800f95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
  800fa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fa7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fac:	c9                   	leave  
  800fad:	c3                   	ret    

00800fae <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	57                   	push   %edi
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
  800fb4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800fc0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800fc3:	8b 7d 18             	mov    0x18(%ebp),%edi
  800fc6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  800fc9:	cd 30                	int    $0x30
  800fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  800fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	5b                   	pop    %ebx
  800fd5:	5e                   	pop    %esi
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	6a 00                	push   $0x0
  800fe1:	6a 00                	push   $0x0
  800fe3:	6a 00                	push   $0x0
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	50                   	push   %eax
  800fe9:	6a 00                	push   $0x0
  800feb:	e8 be ff ff ff       	call   800fae <syscall>
  800ff0:	83 c4 18             	add    $0x18,%esp
}
  800ff3:	90                   	nop
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  800ff9:	6a 00                	push   $0x0
  800ffb:	6a 00                	push   $0x0
  800ffd:	6a 00                	push   $0x0
  800fff:	6a 00                	push   $0x0
  801001:	6a 00                	push   $0x0
  801003:	6a 01                	push   $0x1
  801005:	e8 a4 ff ff ff       	call   800fae <syscall>
  80100a:	83 c4 18             	add    $0x18,%esp
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	6a 00                	push   $0x0
  801017:	6a 00                	push   $0x0
  801019:	6a 00                	push   $0x0
  80101b:	6a 00                	push   $0x0
  80101d:	50                   	push   %eax
  80101e:	6a 03                	push   $0x3
  801020:	e8 89 ff ff ff       	call   800fae <syscall>
  801025:	83 c4 18             	add    $0x18,%esp
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80102d:	6a 00                	push   $0x0
  80102f:	6a 00                	push   $0x0
  801031:	6a 00                	push   $0x0
  801033:	6a 00                	push   $0x0
  801035:	6a 00                	push   $0x0
  801037:	6a 02                	push   $0x2
  801039:	e8 70 ff ff ff       	call   800fae <syscall>
  80103e:	83 c4 18             	add    $0x18,%esp
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <sys_env_exit>:

void sys_env_exit(void)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801046:	6a 00                	push   $0x0
  801048:	6a 00                	push   $0x0
  80104a:	6a 00                	push   $0x0
  80104c:	6a 00                	push   $0x0
  80104e:	6a 00                	push   $0x0
  801050:	6a 04                	push   $0x4
  801052:	e8 57 ff ff ff       	call   800fae <syscall>
  801057:	83 c4 18             	add    $0x18,%esp
}
  80105a:	90                   	nop
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801060:	8b 55 0c             	mov    0xc(%ebp),%edx
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	6a 00                	push   $0x0
  801068:	6a 00                	push   $0x0
  80106a:	6a 00                	push   $0x0
  80106c:	52                   	push   %edx
  80106d:	50                   	push   %eax
  80106e:	6a 05                	push   $0x5
  801070:	e8 39 ff ff ff       	call   800fae <syscall>
  801075:	83 c4 18             	add    $0x18,%esp
}
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	56                   	push   %esi
  80107e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80107f:	8b 75 18             	mov    0x18(%ebp),%esi
  801082:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801085:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
  801090:	51                   	push   %ecx
  801091:	52                   	push   %edx
  801092:	50                   	push   %eax
  801093:	6a 06                	push   $0x6
  801095:	e8 14 ff ff ff       	call   800fae <syscall>
  80109a:	83 c4 18             	add    $0x18,%esp
}
  80109d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5d                   	pop    %ebp
  8010a3:	c3                   	ret    

008010a4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	6a 00                	push   $0x0
  8010af:	6a 00                	push   $0x0
  8010b1:	6a 00                	push   $0x0
  8010b3:	52                   	push   %edx
  8010b4:	50                   	push   %eax
  8010b5:	6a 07                	push   $0x7
  8010b7:	e8 f2 fe ff ff       	call   800fae <syscall>
  8010bc:	83 c4 18             	add    $0x18,%esp
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8010c4:	6a 00                	push   $0x0
  8010c6:	6a 00                	push   $0x0
  8010c8:	6a 00                	push   $0x0
  8010ca:	ff 75 0c             	pushl  0xc(%ebp)
  8010cd:	ff 75 08             	pushl  0x8(%ebp)
  8010d0:	6a 08                	push   $0x8
  8010d2:	e8 d7 fe ff ff       	call   800fae <syscall>
  8010d7:	83 c4 18             	add    $0x18,%esp
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8010df:	6a 00                	push   $0x0
  8010e1:	6a 00                	push   $0x0
  8010e3:	6a 00                	push   $0x0
  8010e5:	6a 00                	push   $0x0
  8010e7:	6a 00                	push   $0x0
  8010e9:	6a 09                	push   $0x9
  8010eb:	e8 be fe ff ff       	call   800fae <syscall>
  8010f0:	83 c4 18             	add    $0x18,%esp
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 00                	push   $0x0
  8010fc:	6a 00                	push   $0x0
  8010fe:	6a 00                	push   $0x0
  801100:	6a 00                	push   $0x0
  801102:	6a 0a                	push   $0xa
  801104:	e8 a5 fe ff ff       	call   800fae <syscall>
  801109:	83 c4 18             	add    $0x18,%esp
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801111:	6a 00                	push   $0x0
  801113:	6a 00                	push   $0x0
  801115:	6a 00                	push   $0x0
  801117:	6a 00                	push   $0x0
  801119:	6a 00                	push   $0x0
  80111b:	6a 0b                	push   $0xb
  80111d:	e8 8c fe ff ff       	call   800fae <syscall>
  801122:	83 c4 18             	add    $0x18,%esp
}
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80112a:	6a 00                	push   $0x0
  80112c:	6a 00                	push   $0x0
  80112e:	6a 00                	push   $0x0
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	ff 75 08             	pushl  0x8(%ebp)
  801136:	6a 0d                	push   $0xd
  801138:	e8 71 fe ff ff       	call   800fae <syscall>
  80113d:	83 c4 18             	add    $0x18,%esp
	return;
  801140:	90                   	nop
}
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801146:	6a 00                	push   $0x0
  801148:	6a 00                	push   $0x0
  80114a:	6a 00                	push   $0x0
  80114c:	ff 75 0c             	pushl  0xc(%ebp)
  80114f:	ff 75 08             	pushl  0x8(%ebp)
  801152:	6a 0e                	push   $0xe
  801154:	e8 55 fe ff ff       	call   800fae <syscall>
  801159:	83 c4 18             	add    $0x18,%esp
	return ;
  80115c:	90                   	nop
}
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    

0080115f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801162:	6a 00                	push   $0x0
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 0c                	push   $0xc
  80116e:	e8 3b fe ff ff       	call   800fae <syscall>
  801173:	83 c4 18             	add    $0x18,%esp
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80117b:	6a 00                	push   $0x0
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	6a 10                	push   $0x10
  801187:	e8 22 fe ff ff       	call   800fae <syscall>
  80118c:	83 c4 18             	add    $0x18,%esp
}
  80118f:	90                   	nop
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801195:	6a 00                	push   $0x0
  801197:	6a 00                	push   $0x0
  801199:	6a 00                	push   $0x0
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	6a 11                	push   $0x11
  8011a1:	e8 08 fe ff ff       	call   800fae <syscall>
  8011a6:	83 c4 18             	add    $0x18,%esp
}
  8011a9:	90                   	nop
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <sys_cputc>:


void
sys_cputc(const char c)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 04             	sub    $0x4,%esp
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011b8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	50                   	push   %eax
  8011c5:	6a 12                	push   $0x12
  8011c7:	e8 e2 fd ff ff       	call   800fae <syscall>
  8011cc:	83 c4 18             	add    $0x18,%esp
}
  8011cf:	90                   	nop
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8011d5:	6a 00                	push   $0x0
  8011d7:	6a 00                	push   $0x0
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 13                	push   $0x13
  8011e1:	e8 c8 fd ff ff       	call   800fae <syscall>
  8011e6:	83 c4 18             	add    $0x18,%esp
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	ff 75 0c             	pushl  0xc(%ebp)
  8011fb:	50                   	push   %eax
  8011fc:	6a 14                	push   $0x14
  8011fe:	e8 ab fd ff ff       	call   800fae <syscall>
  801203:	83 c4 18             	add    $0x18,%esp
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	6a 00                	push   $0x0
  801210:	6a 00                	push   $0x0
  801212:	6a 00                	push   $0x0
  801214:	6a 00                	push   $0x0
  801216:	50                   	push   %eax
  801217:	6a 17                	push   $0x17
  801219:	e8 90 fd ff ff       	call   800fae <syscall>
  80121e:	83 c4 18             	add    $0x18,%esp
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	6a 00                	push   $0x0
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	50                   	push   %eax
  801232:	6a 15                	push   $0x15
  801234:	e8 75 fd ff ff       	call   800fae <syscall>
  801239:	83 c4 18             	add    $0x18,%esp
}
  80123c:	90                   	nop
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	50                   	push   %eax
  80124e:	6a 16                	push   $0x16
  801250:	e8 59 fd ff ff       	call   800fae <syscall>
  801255:	83 c4 18             	add    $0x18,%esp
}
  801258:	90                   	nop
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	83 ec 04             	sub    $0x4,%esp
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801267:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80126a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	6a 00                	push   $0x0
  801273:	51                   	push   %ecx
  801274:	52                   	push   %edx
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	50                   	push   %eax
  801279:	6a 18                	push   $0x18
  80127b:	e8 2e fd ff ff       	call   800fae <syscall>
  801280:	83 c4 18             	add    $0x18,%esp
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	6a 00                	push   $0x0
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	52                   	push   %edx
  801295:	50                   	push   %eax
  801296:	6a 19                	push   $0x19
  801298:	e8 11 fd ff ff       	call   800fae <syscall>
  80129d:	83 c4 18             	add    $0x18,%esp
}
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 00                	push   $0x0
  8012b0:	50                   	push   %eax
  8012b1:	6a 1a                	push   $0x1a
  8012b3:	e8 f6 fc ff ff       	call   800fae <syscall>
  8012b8:	83 c4 18             	add    $0x18,%esp
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 1b                	push   $0x1b
  8012cc:	e8 dd fc ff ff       	call   800fae <syscall>
  8012d1:	83 c4 18             	add    $0x18,%esp
}
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 1c                	push   $0x1c
  8012e5:	e8 c4 fc ff ff       	call   800fae <syscall>
  8012ea:	83 c4 18             	add    $0x18,%esp
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	ff 75 0c             	pushl  0xc(%ebp)
  8012fe:	50                   	push   %eax
  8012ff:	6a 1d                	push   $0x1d
  801301:	e8 a8 fc ff ff       	call   800fae <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	50                   	push   %eax
  80131a:	6a 1e                	push   $0x1e
  80131c:	e8 8d fc ff ff       	call   800fae <syscall>
  801321:	83 c4 18             	add    $0x18,%esp
}
  801324:	90                   	nop
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	50                   	push   %eax
  801336:	6a 1f                	push   $0x1f
  801338:	e8 71 fc ff ff       	call   800fae <syscall>
  80133d:	83 c4 18             	add    $0x18,%esp
}
  801340:	90                   	nop
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801349:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80134c:	8d 50 04             	lea    0x4(%eax),%edx
  80134f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	52                   	push   %edx
  801359:	50                   	push   %eax
  80135a:	6a 20                	push   $0x20
  80135c:	e8 4d fc ff ff       	call   800fae <syscall>
  801361:	83 c4 18             	add    $0x18,%esp
	return result;
  801364:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136d:	89 01                	mov    %eax,(%ecx)
  80136f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	c9                   	leave  
  801376:	c2 04 00             	ret    $0x4

00801379 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	ff 75 10             	pushl  0x10(%ebp)
  801383:	ff 75 0c             	pushl  0xc(%ebp)
  801386:	ff 75 08             	pushl  0x8(%ebp)
  801389:	6a 0f                	push   $0xf
  80138b:	e8 1e fc ff ff       	call   800fae <syscall>
  801390:	83 c4 18             	add    $0x18,%esp
	return ;
  801393:	90                   	nop
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <sys_rcr2>:
uint32 sys_rcr2()
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 21                	push   $0x21
  8013a5:	e8 04 fc ff ff       	call   800fae <syscall>
  8013aa:	83 c4 18             	add    $0x18,%esp
}
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013bb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	50                   	push   %eax
  8013c8:	6a 22                	push   $0x22
  8013ca:	e8 df fb ff ff       	call   800fae <syscall>
  8013cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d2:	90                   	nop
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <rsttst>:
void rsttst()
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 24                	push   $0x24
  8013e4:	e8 c5 fb ff ff       	call   800fae <syscall>
  8013e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ec:	90                   	nop
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013fb:	8b 55 18             	mov    0x18(%ebp),%edx
  8013fe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801402:	52                   	push   %edx
  801403:	50                   	push   %eax
  801404:	ff 75 10             	pushl  0x10(%ebp)
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	ff 75 08             	pushl  0x8(%ebp)
  80140d:	6a 23                	push   $0x23
  80140f:	e8 9a fb ff ff       	call   800fae <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
	return ;
  801417:	90                   	nop
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <chktst>:
void chktst(uint32 n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	ff 75 08             	pushl  0x8(%ebp)
  801428:	6a 25                	push   $0x25
  80142a:	e8 7f fb ff ff       	call   800fae <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
	return ;
  801432:	90                   	nop
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 26                	push   $0x26
  801447:	e8 62 fb ff ff       	call   800fae <syscall>
  80144c:	83 c4 18             	add    $0x18,%esp
  80144f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801452:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801456:	75 07                	jne    80145f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801458:	b8 01 00 00 00       	mov    $0x1,%eax
  80145d:	eb 05                	jmp    801464 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 26                	push   $0x26
  801478:	e8 31 fb ff ff       	call   800fae <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
  801480:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801483:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801487:	75 07                	jne    801490 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801489:	b8 01 00 00 00       	mov    $0x1,%eax
  80148e:	eb 05                	jmp    801495 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 26                	push   $0x26
  8014a9:	e8 00 fb ff ff       	call   800fae <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
  8014b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014b4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014b8:	75 07                	jne    8014c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8014bf:	eb 05                	jmp    8014c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 26                	push   $0x26
  8014da:	e8 cf fa ff ff       	call   800fae <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
  8014e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8014e5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8014e9:	75 07                	jne    8014f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8014eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8014f0:	eb 05                	jmp    8014f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	ff 75 08             	pushl  0x8(%ebp)
  801507:	6a 27                	push   $0x27
  801509:	e8 a0 fa ff ff       	call   800fae <syscall>
  80150e:	83 c4 18             	add    $0x18,%esp
	return ;
  801511:	90                   	nop
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <__udivdi3>:
  801514:	55                   	push   %ebp
  801515:	57                   	push   %edi
  801516:	56                   	push   %esi
  801517:	53                   	push   %ebx
  801518:	83 ec 1c             	sub    $0x1c,%esp
  80151b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80151f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801527:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80152b:	89 ca                	mov    %ecx,%edx
  80152d:	89 f8                	mov    %edi,%eax
  80152f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801533:	85 f6                	test   %esi,%esi
  801535:	75 2d                	jne    801564 <__udivdi3+0x50>
  801537:	39 cf                	cmp    %ecx,%edi
  801539:	77 65                	ja     8015a0 <__udivdi3+0x8c>
  80153b:	89 fd                	mov    %edi,%ebp
  80153d:	85 ff                	test   %edi,%edi
  80153f:	75 0b                	jne    80154c <__udivdi3+0x38>
  801541:	b8 01 00 00 00       	mov    $0x1,%eax
  801546:	31 d2                	xor    %edx,%edx
  801548:	f7 f7                	div    %edi
  80154a:	89 c5                	mov    %eax,%ebp
  80154c:	31 d2                	xor    %edx,%edx
  80154e:	89 c8                	mov    %ecx,%eax
  801550:	f7 f5                	div    %ebp
  801552:	89 c1                	mov    %eax,%ecx
  801554:	89 d8                	mov    %ebx,%eax
  801556:	f7 f5                	div    %ebp
  801558:	89 cf                	mov    %ecx,%edi
  80155a:	89 fa                	mov    %edi,%edx
  80155c:	83 c4 1c             	add    $0x1c,%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5f                   	pop    %edi
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    
  801564:	39 ce                	cmp    %ecx,%esi
  801566:	77 28                	ja     801590 <__udivdi3+0x7c>
  801568:	0f bd fe             	bsr    %esi,%edi
  80156b:	83 f7 1f             	xor    $0x1f,%edi
  80156e:	75 40                	jne    8015b0 <__udivdi3+0x9c>
  801570:	39 ce                	cmp    %ecx,%esi
  801572:	72 0a                	jb     80157e <__udivdi3+0x6a>
  801574:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801578:	0f 87 9e 00 00 00    	ja     80161c <__udivdi3+0x108>
  80157e:	b8 01 00 00 00       	mov    $0x1,%eax
  801583:	89 fa                	mov    %edi,%edx
  801585:	83 c4 1c             	add    $0x1c,%esp
  801588:	5b                   	pop    %ebx
  801589:	5e                   	pop    %esi
  80158a:	5f                   	pop    %edi
  80158b:	5d                   	pop    %ebp
  80158c:	c3                   	ret    
  80158d:	8d 76 00             	lea    0x0(%esi),%esi
  801590:	31 ff                	xor    %edi,%edi
  801592:	31 c0                	xor    %eax,%eax
  801594:	89 fa                	mov    %edi,%edx
  801596:	83 c4 1c             	add    $0x1c,%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5f                   	pop    %edi
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    
  80159e:	66 90                	xchg   %ax,%ax
  8015a0:	89 d8                	mov    %ebx,%eax
  8015a2:	f7 f7                	div    %edi
  8015a4:	31 ff                	xor    %edi,%edi
  8015a6:	89 fa                	mov    %edi,%edx
  8015a8:	83 c4 1c             	add    $0x1c,%esp
  8015ab:	5b                   	pop    %ebx
  8015ac:	5e                   	pop    %esi
  8015ad:	5f                   	pop    %edi
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    
  8015b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8015b5:	89 eb                	mov    %ebp,%ebx
  8015b7:	29 fb                	sub    %edi,%ebx
  8015b9:	89 f9                	mov    %edi,%ecx
  8015bb:	d3 e6                	shl    %cl,%esi
  8015bd:	89 c5                	mov    %eax,%ebp
  8015bf:	88 d9                	mov    %bl,%cl
  8015c1:	d3 ed                	shr    %cl,%ebp
  8015c3:	89 e9                	mov    %ebp,%ecx
  8015c5:	09 f1                	or     %esi,%ecx
  8015c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8015cb:	89 f9                	mov    %edi,%ecx
  8015cd:	d3 e0                	shl    %cl,%eax
  8015cf:	89 c5                	mov    %eax,%ebp
  8015d1:	89 d6                	mov    %edx,%esi
  8015d3:	88 d9                	mov    %bl,%cl
  8015d5:	d3 ee                	shr    %cl,%esi
  8015d7:	89 f9                	mov    %edi,%ecx
  8015d9:	d3 e2                	shl    %cl,%edx
  8015db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8015df:	88 d9                	mov    %bl,%cl
  8015e1:	d3 e8                	shr    %cl,%eax
  8015e3:	09 c2                	or     %eax,%edx
  8015e5:	89 d0                	mov    %edx,%eax
  8015e7:	89 f2                	mov    %esi,%edx
  8015e9:	f7 74 24 0c          	divl   0xc(%esp)
  8015ed:	89 d6                	mov    %edx,%esi
  8015ef:	89 c3                	mov    %eax,%ebx
  8015f1:	f7 e5                	mul    %ebp
  8015f3:	39 d6                	cmp    %edx,%esi
  8015f5:	72 19                	jb     801610 <__udivdi3+0xfc>
  8015f7:	74 0b                	je     801604 <__udivdi3+0xf0>
  8015f9:	89 d8                	mov    %ebx,%eax
  8015fb:	31 ff                	xor    %edi,%edi
  8015fd:	e9 58 ff ff ff       	jmp    80155a <__udivdi3+0x46>
  801602:	66 90                	xchg   %ax,%ax
  801604:	8b 54 24 08          	mov    0x8(%esp),%edx
  801608:	89 f9                	mov    %edi,%ecx
  80160a:	d3 e2                	shl    %cl,%edx
  80160c:	39 c2                	cmp    %eax,%edx
  80160e:	73 e9                	jae    8015f9 <__udivdi3+0xe5>
  801610:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801613:	31 ff                	xor    %edi,%edi
  801615:	e9 40 ff ff ff       	jmp    80155a <__udivdi3+0x46>
  80161a:	66 90                	xchg   %ax,%ax
  80161c:	31 c0                	xor    %eax,%eax
  80161e:	e9 37 ff ff ff       	jmp    80155a <__udivdi3+0x46>
  801623:	90                   	nop

00801624 <__umoddi3>:
  801624:	55                   	push   %ebp
  801625:	57                   	push   %edi
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
  801628:	83 ec 1c             	sub    $0x1c,%esp
  80162b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80162f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801633:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801637:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80163b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80163f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801643:	89 f3                	mov    %esi,%ebx
  801645:	89 fa                	mov    %edi,%edx
  801647:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80164b:	89 34 24             	mov    %esi,(%esp)
  80164e:	85 c0                	test   %eax,%eax
  801650:	75 1a                	jne    80166c <__umoddi3+0x48>
  801652:	39 f7                	cmp    %esi,%edi
  801654:	0f 86 a2 00 00 00    	jbe    8016fc <__umoddi3+0xd8>
  80165a:	89 c8                	mov    %ecx,%eax
  80165c:	89 f2                	mov    %esi,%edx
  80165e:	f7 f7                	div    %edi
  801660:	89 d0                	mov    %edx,%eax
  801662:	31 d2                	xor    %edx,%edx
  801664:	83 c4 1c             	add    $0x1c,%esp
  801667:	5b                   	pop    %ebx
  801668:	5e                   	pop    %esi
  801669:	5f                   	pop    %edi
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    
  80166c:	39 f0                	cmp    %esi,%eax
  80166e:	0f 87 ac 00 00 00    	ja     801720 <__umoddi3+0xfc>
  801674:	0f bd e8             	bsr    %eax,%ebp
  801677:	83 f5 1f             	xor    $0x1f,%ebp
  80167a:	0f 84 ac 00 00 00    	je     80172c <__umoddi3+0x108>
  801680:	bf 20 00 00 00       	mov    $0x20,%edi
  801685:	29 ef                	sub    %ebp,%edi
  801687:	89 fe                	mov    %edi,%esi
  801689:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80168d:	89 e9                	mov    %ebp,%ecx
  80168f:	d3 e0                	shl    %cl,%eax
  801691:	89 d7                	mov    %edx,%edi
  801693:	89 f1                	mov    %esi,%ecx
  801695:	d3 ef                	shr    %cl,%edi
  801697:	09 c7                	or     %eax,%edi
  801699:	89 e9                	mov    %ebp,%ecx
  80169b:	d3 e2                	shl    %cl,%edx
  80169d:	89 14 24             	mov    %edx,(%esp)
  8016a0:	89 d8                	mov    %ebx,%eax
  8016a2:	d3 e0                	shl    %cl,%eax
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8016aa:	d3 e0                	shl    %cl,%eax
  8016ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8016b4:	89 f1                	mov    %esi,%ecx
  8016b6:	d3 e8                	shr    %cl,%eax
  8016b8:	09 d0                	or     %edx,%eax
  8016ba:	d3 eb                	shr    %cl,%ebx
  8016bc:	89 da                	mov    %ebx,%edx
  8016be:	f7 f7                	div    %edi
  8016c0:	89 d3                	mov    %edx,%ebx
  8016c2:	f7 24 24             	mull   (%esp)
  8016c5:	89 c6                	mov    %eax,%esi
  8016c7:	89 d1                	mov    %edx,%ecx
  8016c9:	39 d3                	cmp    %edx,%ebx
  8016cb:	0f 82 87 00 00 00    	jb     801758 <__umoddi3+0x134>
  8016d1:	0f 84 91 00 00 00    	je     801768 <__umoddi3+0x144>
  8016d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8016db:	29 f2                	sub    %esi,%edx
  8016dd:	19 cb                	sbb    %ecx,%ebx
  8016df:	89 d8                	mov    %ebx,%eax
  8016e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8016e5:	d3 e0                	shl    %cl,%eax
  8016e7:	89 e9                	mov    %ebp,%ecx
  8016e9:	d3 ea                	shr    %cl,%edx
  8016eb:	09 d0                	or     %edx,%eax
  8016ed:	89 e9                	mov    %ebp,%ecx
  8016ef:	d3 eb                	shr    %cl,%ebx
  8016f1:	89 da                	mov    %ebx,%edx
  8016f3:	83 c4 1c             	add    $0x1c,%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5f                   	pop    %edi
  8016f9:	5d                   	pop    %ebp
  8016fa:	c3                   	ret    
  8016fb:	90                   	nop
  8016fc:	89 fd                	mov    %edi,%ebp
  8016fe:	85 ff                	test   %edi,%edi
  801700:	75 0b                	jne    80170d <__umoddi3+0xe9>
  801702:	b8 01 00 00 00       	mov    $0x1,%eax
  801707:	31 d2                	xor    %edx,%edx
  801709:	f7 f7                	div    %edi
  80170b:	89 c5                	mov    %eax,%ebp
  80170d:	89 f0                	mov    %esi,%eax
  80170f:	31 d2                	xor    %edx,%edx
  801711:	f7 f5                	div    %ebp
  801713:	89 c8                	mov    %ecx,%eax
  801715:	f7 f5                	div    %ebp
  801717:	89 d0                	mov    %edx,%eax
  801719:	e9 44 ff ff ff       	jmp    801662 <__umoddi3+0x3e>
  80171e:	66 90                	xchg   %ax,%ax
  801720:	89 c8                	mov    %ecx,%eax
  801722:	89 f2                	mov    %esi,%edx
  801724:	83 c4 1c             	add    $0x1c,%esp
  801727:	5b                   	pop    %ebx
  801728:	5e                   	pop    %esi
  801729:	5f                   	pop    %edi
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    
  80172c:	3b 04 24             	cmp    (%esp),%eax
  80172f:	72 06                	jb     801737 <__umoddi3+0x113>
  801731:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801735:	77 0f                	ja     801746 <__umoddi3+0x122>
  801737:	89 f2                	mov    %esi,%edx
  801739:	29 f9                	sub    %edi,%ecx
  80173b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80173f:	89 14 24             	mov    %edx,(%esp)
  801742:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801746:	8b 44 24 04          	mov    0x4(%esp),%eax
  80174a:	8b 14 24             	mov    (%esp),%edx
  80174d:	83 c4 1c             	add    $0x1c,%esp
  801750:	5b                   	pop    %ebx
  801751:	5e                   	pop    %esi
  801752:	5f                   	pop    %edi
  801753:	5d                   	pop    %ebp
  801754:	c3                   	ret    
  801755:	8d 76 00             	lea    0x0(%esi),%esi
  801758:	2b 04 24             	sub    (%esp),%eax
  80175b:	19 fa                	sbb    %edi,%edx
  80175d:	89 d1                	mov    %edx,%ecx
  80175f:	89 c6                	mov    %eax,%esi
  801761:	e9 71 ff ff ff       	jmp    8016d7 <__umoddi3+0xb3>
  801766:	66 90                	xchg   %ax,%ax
  801768:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80176c:	72 ea                	jb     801758 <__umoddi3+0x134>
  80176e:	89 d9                	mov    %ebx,%ecx
  801770:	e9 62 ff ff ff       	jmp    8016d7 <__umoddi3+0xb3>
