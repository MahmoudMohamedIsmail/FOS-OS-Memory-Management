
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 e0 1a 80 00       	push   $0x801ae0
  80005e:	e8 6d 09 00 00       	call   8009d0 <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 bf 0d 00 00       	call   800e38 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 ba 16 00 00       	call   801746 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 fc 1a 80 00       	push   $0x801afc
  80009e:	e8 2d 09 00 00       	call   8009d0 <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 7f 0d 00 00       	call   800e38 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 19 1b 80 00       	push   $0x801b19
  8000d0:	e8 a8 01 00 00       	call   80027d <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e5:	7e 0a                	jle    8000f1 <libmain+0x16>
		binaryname = argv[0];
  8000e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000f1:	83 ec 08             	sub    $0x8,%esp
  8000f4:	ff 75 0c             	pushl  0xc(%ebp)
  8000f7:	ff 75 08             	pushl  0x8(%ebp)
  8000fa:	e8 39 ff ff ff       	call   800038 <_main>
  8000ff:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800102:	e8 55 11 00 00       	call   80125c <sys_getenvid>
  800107:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80010a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80010d:	89 d0                	mov    %edx,%eax
  80010f:	c1 e0 03             	shl    $0x3,%eax
  800112:	01 d0                	add    %edx,%eax
  800114:	01 c0                	add    %eax,%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80011f:	01 d0                	add    %edx,%eax
  800121:	c1 e0 03             	shl    $0x3,%eax
  800124:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800129:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  80012c:	e8 79 12 00 00       	call   8013aa <sys_disable_interrupt>
		cprintf("**************************************\n");
  800131:	83 ec 0c             	sub    $0xc,%esp
  800134:	68 4c 1b 80 00       	push   $0x801b4c
  800139:	e8 19 01 00 00       	call   800257 <cprintf>
  80013e:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800144:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	50                   	push   %eax
  80014e:	68 74 1b 80 00       	push   $0x801b74
  800153:	e8 ff 00 00 00       	call   800257 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	68 4c 1b 80 00       	push   $0x801b4c
  800163:	e8 ef 00 00 00       	call   800257 <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80016b:	e8 54 12 00 00       	call   8013c4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800170:	e8 19 00 00 00       	call   80018e <exit>
}
  800175:	90                   	nop
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	6a 00                	push   $0x0
  800183:	e8 b9 10 00 00       	call   801241 <sys_env_destroy>
  800188:	83 c4 10             	add    $0x10,%esp
}
  80018b:	90                   	nop
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    

0080018e <exit>:

void
exit(void)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800194:	e8 dc 10 00 00       	call   801275 <sys_env_exit>
}
  800199:	90                   	nop
  80019a:	c9                   	leave  
  80019b:	c3                   	ret    

0080019c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a5:	8b 00                	mov    (%eax),%eax
  8001a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8001aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ad:	89 0a                	mov    %ecx,(%edx)
  8001af:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b2:	88 d1                	mov    %dl,%cl
  8001b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c5:	75 23                	jne    8001ea <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8001c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 c2                	mov    %eax,%edx
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	83 c0 08             	add    $0x8,%eax
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	e8 2d 10 00 00       	call   80120b <sys_cputs>
  8001de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	8b 40 04             	mov    0x4(%eax),%eax
  8001f0:	8d 50 01             	lea    0x1(%eax),%edx
  8001f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001f9:	90                   	nop
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800205:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020c:	00 00 00 
	b.cnt = 0;
  80020f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800216:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800219:	ff 75 0c             	pushl  0xc(%ebp)
  80021c:	ff 75 08             	pushl  0x8(%ebp)
  80021f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	68 9c 01 80 00       	push   $0x80019c
  80022b:	e8 fa 01 00 00       	call   80042a <vprintfmt>
  800230:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800233:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	50                   	push   %eax
  80023d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800243:	83 c0 08             	add    $0x8,%eax
  800246:	50                   	push   %eax
  800247:	e8 bf 0f 00 00       	call   80120b <sys_cputs>
  80024c:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80024f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <cprintf>:

int cprintf(const char *fmt, ...) {
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80025d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800260:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800263:	8b 45 08             	mov    0x8(%ebp),%eax
  800266:	83 ec 08             	sub    $0x8,%esp
  800269:	ff 75 f4             	pushl  -0xc(%ebp)
  80026c:	50                   	push   %eax
  80026d:	e8 8a ff ff ff       	call   8001fc <vcprintf>
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800278:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800283:	e8 22 11 00 00       	call   8013aa <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800288:	8d 45 0c             	lea    0xc(%ebp),%eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	ff 75 f4             	pushl  -0xc(%ebp)
  800297:	50                   	push   %eax
  800298:	e8 5f ff ff ff       	call   8001fc <vcprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002a3:	e8 1c 11 00 00       	call   8013c4 <sys_enable_interrupt>
	return cnt;
  8002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	53                   	push   %ebx
  8002b1:	83 ec 14             	sub    $0x14,%esp
  8002b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8002bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8002c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002cb:	77 55                	ja     800322 <printnum+0x75>
  8002cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002d0:	72 05                	jb     8002d7 <printnum+0x2a>
  8002d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002d5:	77 4b                	ja     800322 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002da:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002dd:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e5:	52                   	push   %edx
  8002e6:	50                   	push   %eax
  8002e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ed:	e8 8a 15 00 00       	call   80187c <__udivdi3>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	ff 75 20             	pushl  0x20(%ebp)
  8002fb:	53                   	push   %ebx
  8002fc:	ff 75 18             	pushl  0x18(%ebp)
  8002ff:	52                   	push   %edx
  800300:	50                   	push   %eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	e8 a1 ff ff ff       	call   8002ad <printnum>
  80030c:	83 c4 20             	add    $0x20,%esp
  80030f:	eb 1a                	jmp    80032b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 20             	pushl  0x20(%ebp)
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	ff d0                	call   *%eax
  80031f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800322:	ff 4d 1c             	decl   0x1c(%ebp)
  800325:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800329:	7f e6                	jg     800311 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80032e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800339:	53                   	push   %ebx
  80033a:	51                   	push   %ecx
  80033b:	52                   	push   %edx
  80033c:	50                   	push   %eax
  80033d:	e8 4a 16 00 00       	call   80198c <__umoddi3>
  800342:	83 c4 10             	add    $0x10,%esp
  800345:	05 b4 1d 80 00       	add    $0x801db4,%eax
  80034a:	8a 00                	mov    (%eax),%al
  80034c:	0f be c0             	movsbl %al,%eax
  80034f:	83 ec 08             	sub    $0x8,%esp
  800352:	ff 75 0c             	pushl  0xc(%ebp)
  800355:	50                   	push   %eax
  800356:	8b 45 08             	mov    0x8(%ebp),%eax
  800359:	ff d0                	call   *%eax
  80035b:	83 c4 10             	add    $0x10,%esp
}
  80035e:	90                   	nop
  80035f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800362:	c9                   	leave  
  800363:	c3                   	ret    

00800364 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800364:	55                   	push   %ebp
  800365:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800367:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80036b:	7e 1c                	jle    800389 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	8d 50 08             	lea    0x8(%eax),%edx
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	89 10                	mov    %edx,(%eax)
  80037a:	8b 45 08             	mov    0x8(%ebp),%eax
  80037d:	8b 00                	mov    (%eax),%eax
  80037f:	83 e8 08             	sub    $0x8,%eax
  800382:	8b 50 04             	mov    0x4(%eax),%edx
  800385:	8b 00                	mov    (%eax),%eax
  800387:	eb 40                	jmp    8003c9 <getuint+0x65>
	else if (lflag)
  800389:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80038d:	74 1e                	je     8003ad <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	8d 50 04             	lea    0x4(%eax),%edx
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	89 10                	mov    %edx,(%eax)
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	83 e8 04             	sub    $0x4,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ab:	eb 1c                	jmp    8003c9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	8d 50 04             	lea    0x4(%eax),%edx
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	89 10                	mov    %edx,(%eax)
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	83 e8 04             	sub    $0x4,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    

008003cb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003ce:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003d2:	7e 1c                	jle    8003f0 <getint+0x25>
		return va_arg(*ap, long long);
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	8d 50 08             	lea    0x8(%eax),%edx
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	89 10                	mov    %edx,(%eax)
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	83 e8 08             	sub    $0x8,%eax
  8003e9:	8b 50 04             	mov    0x4(%eax),%edx
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	eb 38                	jmp    800428 <getint+0x5d>
	else if (lflag)
  8003f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003f4:	74 1a                	je     800410 <getint+0x45>
		return va_arg(*ap, long);
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	8d 50 04             	lea    0x4(%eax),%edx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	89 10                	mov    %edx,(%eax)
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	83 e8 04             	sub    $0x4,%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	99                   	cltd   
  80040e:	eb 18                	jmp    800428 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	8d 50 04             	lea    0x4(%eax),%edx
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	89 10                	mov    %edx,(%eax)
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	8b 00                	mov    (%eax),%eax
  800422:	83 e8 04             	sub    $0x4,%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	99                   	cltd   
}
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    

0080042a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	56                   	push   %esi
  80042e:	53                   	push   %ebx
  80042f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800432:	eb 17                	jmp    80044b <vprintfmt+0x21>
			if (ch == '\0')
  800434:	85 db                	test   %ebx,%ebx
  800436:	0f 84 af 03 00 00    	je     8007eb <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	53                   	push   %ebx
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	ff d0                	call   *%eax
  800448:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80044b:	8b 45 10             	mov    0x10(%ebp),%eax
  80044e:	8d 50 01             	lea    0x1(%eax),%edx
  800451:	89 55 10             	mov    %edx,0x10(%ebp)
  800454:	8a 00                	mov    (%eax),%al
  800456:	0f b6 d8             	movzbl %al,%ebx
  800459:	83 fb 25             	cmp    $0x25,%ebx
  80045c:	75 d6                	jne    800434 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80045e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800462:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800469:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800470:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800477:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	8b 45 10             	mov    0x10(%ebp),%eax
  800481:	8d 50 01             	lea    0x1(%eax),%edx
  800484:	89 55 10             	mov    %edx,0x10(%ebp)
  800487:	8a 00                	mov    (%eax),%al
  800489:	0f b6 d8             	movzbl %al,%ebx
  80048c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80048f:	83 f8 55             	cmp    $0x55,%eax
  800492:	0f 87 2b 03 00 00    	ja     8007c3 <vprintfmt+0x399>
  800498:	8b 04 85 d8 1d 80 00 	mov    0x801dd8(,%eax,4),%eax
  80049f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004a1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004a5:	eb d7                	jmp    80047e <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004a7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004ab:	eb d1                	jmp    80047e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b7:	89 d0                	mov    %edx,%eax
  8004b9:	c1 e0 02             	shl    $0x2,%eax
  8004bc:	01 d0                	add    %edx,%eax
  8004be:	01 c0                	add    %eax,%eax
  8004c0:	01 d8                	add    %ebx,%eax
  8004c2:	83 e8 30             	sub    $0x30,%eax
  8004c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cb:	8a 00                	mov    (%eax),%al
  8004cd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004d0:	83 fb 2f             	cmp    $0x2f,%ebx
  8004d3:	7e 3e                	jle    800513 <vprintfmt+0xe9>
  8004d5:	83 fb 39             	cmp    $0x39,%ebx
  8004d8:	7f 39                	jg     800513 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004da:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004dd:	eb d5                	jmp    8004b4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004df:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e2:	83 c0 04             	add    $0x4,%eax
  8004e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	83 e8 04             	sub    $0x4,%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004f3:	eb 1f                	jmp    800514 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8004f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004f9:	79 83                	jns    80047e <vprintfmt+0x54>
				width = 0;
  8004fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800502:	e9 77 ff ff ff       	jmp    80047e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800507:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80050e:	e9 6b ff ff ff       	jmp    80047e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800513:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800514:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800518:	0f 89 60 ff ff ff    	jns    80047e <vprintfmt+0x54>
				width = precision, precision = -1;
  80051e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800524:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80052b:	e9 4e ff ff ff       	jmp    80047e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800530:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800533:	e9 46 ff ff ff       	jmp    80047e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800538:	8b 45 14             	mov    0x14(%ebp),%eax
  80053b:	83 c0 04             	add    $0x4,%eax
  80053e:	89 45 14             	mov    %eax,0x14(%ebp)
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	83 e8 04             	sub    $0x4,%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 0c             	pushl  0xc(%ebp)
  80054f:	50                   	push   %eax
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	ff d0                	call   *%eax
  800555:	83 c4 10             	add    $0x10,%esp
			break;
  800558:	e9 89 02 00 00       	jmp    8007e6 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	83 c0 04             	add    $0x4,%eax
  800563:	89 45 14             	mov    %eax,0x14(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	83 e8 04             	sub    $0x4,%eax
  80056c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80056e:	85 db                	test   %ebx,%ebx
  800570:	79 02                	jns    800574 <vprintfmt+0x14a>
				err = -err;
  800572:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800574:	83 fb 64             	cmp    $0x64,%ebx
  800577:	7f 0b                	jg     800584 <vprintfmt+0x15a>
  800579:	8b 34 9d 20 1c 80 00 	mov    0x801c20(,%ebx,4),%esi
  800580:	85 f6                	test   %esi,%esi
  800582:	75 19                	jne    80059d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800584:	53                   	push   %ebx
  800585:	68 c5 1d 80 00       	push   $0x801dc5
  80058a:	ff 75 0c             	pushl  0xc(%ebp)
  80058d:	ff 75 08             	pushl  0x8(%ebp)
  800590:	e8 5e 02 00 00       	call   8007f3 <printfmt>
  800595:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800598:	e9 49 02 00 00       	jmp    8007e6 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80059d:	56                   	push   %esi
  80059e:	68 ce 1d 80 00       	push   $0x801dce
  8005a3:	ff 75 0c             	pushl  0xc(%ebp)
  8005a6:	ff 75 08             	pushl  0x8(%ebp)
  8005a9:	e8 45 02 00 00       	call   8007f3 <printfmt>
  8005ae:	83 c4 10             	add    $0x10,%esp
			break;
  8005b1:	e9 30 02 00 00       	jmp    8007e6 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	83 c0 04             	add    $0x4,%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	83 e8 04             	sub    $0x4,%eax
  8005c5:	8b 30                	mov    (%eax),%esi
  8005c7:	85 f6                	test   %esi,%esi
  8005c9:	75 05                	jne    8005d0 <vprintfmt+0x1a6>
				p = "(null)";
  8005cb:	be d1 1d 80 00       	mov    $0x801dd1,%esi
			if (width > 0 && padc != '-')
  8005d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d4:	7e 6d                	jle    800643 <vprintfmt+0x219>
  8005d6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005da:	74 67                	je     800643 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	50                   	push   %eax
  8005e3:	56                   	push   %esi
  8005e4:	e8 12 05 00 00       	call   800afb <strnlen>
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005ef:	eb 16                	jmp    800607 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8005f1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	ff 75 0c             	pushl  0xc(%ebp)
  8005fb:	50                   	push   %eax
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	ff d0                	call   *%eax
  800601:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800604:	ff 4d e4             	decl   -0x1c(%ebp)
  800607:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060b:	7f e4                	jg     8005f1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060d:	eb 34                	jmp    800643 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80060f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800613:	74 1c                	je     800631 <vprintfmt+0x207>
  800615:	83 fb 1f             	cmp    $0x1f,%ebx
  800618:	7e 05                	jle    80061f <vprintfmt+0x1f5>
  80061a:	83 fb 7e             	cmp    $0x7e,%ebx
  80061d:	7e 12                	jle    800631 <vprintfmt+0x207>
					putch('?', putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	6a 3f                	push   $0x3f
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	ff d0                	call   *%eax
  80062c:	83 c4 10             	add    $0x10,%esp
  80062f:	eb 0f                	jmp    800640 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	ff 75 0c             	pushl  0xc(%ebp)
  800637:	53                   	push   %ebx
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	ff d0                	call   *%eax
  80063d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800640:	ff 4d e4             	decl   -0x1c(%ebp)
  800643:	89 f0                	mov    %esi,%eax
  800645:	8d 70 01             	lea    0x1(%eax),%esi
  800648:	8a 00                	mov    (%eax),%al
  80064a:	0f be d8             	movsbl %al,%ebx
  80064d:	85 db                	test   %ebx,%ebx
  80064f:	74 24                	je     800675 <vprintfmt+0x24b>
  800651:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800655:	78 b8                	js     80060f <vprintfmt+0x1e5>
  800657:	ff 4d e0             	decl   -0x20(%ebp)
  80065a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80065e:	79 af                	jns    80060f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800660:	eb 13                	jmp    800675 <vprintfmt+0x24b>
				putch(' ', putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	ff 75 0c             	pushl  0xc(%ebp)
  800668:	6a 20                	push   $0x20
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	ff d0                	call   *%eax
  80066f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800672:	ff 4d e4             	decl   -0x1c(%ebp)
  800675:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800679:	7f e7                	jg     800662 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80067b:	e9 66 01 00 00       	jmp    8007e6 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	ff 75 e8             	pushl  -0x18(%ebp)
  800686:	8d 45 14             	lea    0x14(%ebp),%eax
  800689:	50                   	push   %eax
  80068a:	e8 3c fd ff ff       	call   8003cb <getint>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800695:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80069e:	85 d2                	test   %edx,%edx
  8006a0:	79 23                	jns    8006c5 <vprintfmt+0x29b>
				putch('-', putdat);
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	ff 75 0c             	pushl  0xc(%ebp)
  8006a8:	6a 2d                	push   $0x2d
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	ff d0                	call   *%eax
  8006af:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b8:	f7 d8                	neg    %eax
  8006ba:	83 d2 00             	adc    $0x0,%edx
  8006bd:	f7 da                	neg    %edx
  8006bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006c5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006cc:	e9 bc 00 00 00       	jmp    80078d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 e8             	pushl  -0x18(%ebp)
  8006d7:	8d 45 14             	lea    0x14(%ebp),%eax
  8006da:	50                   	push   %eax
  8006db:	e8 84 fc ff ff       	call   800364 <getuint>
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006e9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006f0:	e9 98 00 00 00       	jmp    80078d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	6a 58                	push   $0x58
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	6a 58                	push   $0x58
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	ff d0                	call   *%eax
  800712:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	6a 58                	push   $0x58
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	ff d0                	call   *%eax
  800722:	83 c4 10             	add    $0x10,%esp
			break;
  800725:	e9 bc 00 00 00       	jmp    8007e6 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 0c             	pushl  0xc(%ebp)
  800730:	6a 30                	push   $0x30
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	ff 75 0c             	pushl  0xc(%ebp)
  800740:	6a 78                	push   $0x78
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	ff d0                	call   *%eax
  800747:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	83 c0 04             	add    $0x4,%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80075b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80075e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800765:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80076c:	eb 1f                	jmp    80078d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 e8             	pushl  -0x18(%ebp)
  800774:	8d 45 14             	lea    0x14(%ebp),%eax
  800777:	50                   	push   %eax
  800778:	e8 e7 fb ff ff       	call   800364 <getuint>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800783:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800786:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80078d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	52                   	push   %edx
  800798:	ff 75 e4             	pushl  -0x1c(%ebp)
  80079b:	50                   	push   %eax
  80079c:	ff 75 f4             	pushl  -0xc(%ebp)
  80079f:	ff 75 f0             	pushl  -0x10(%ebp)
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	ff 75 08             	pushl  0x8(%ebp)
  8007a8:	e8 00 fb ff ff       	call   8002ad <printnum>
  8007ad:	83 c4 20             	add    $0x20,%esp
			break;
  8007b0:	eb 34                	jmp    8007e6 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	53                   	push   %ebx
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	ff d0                	call   *%eax
  8007be:	83 c4 10             	add    $0x10,%esp
			break;
  8007c1:	eb 23                	jmp    8007e6 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	6a 25                	push   $0x25
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	ff d0                	call   *%eax
  8007d0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d3:	ff 4d 10             	decl   0x10(%ebp)
  8007d6:	eb 03                	jmp    8007db <vprintfmt+0x3b1>
  8007d8:	ff 4d 10             	decl   0x10(%ebp)
  8007db:	8b 45 10             	mov    0x10(%ebp),%eax
  8007de:	48                   	dec    %eax
  8007df:	8a 00                	mov    (%eax),%al
  8007e1:	3c 25                	cmp    $0x25,%al
  8007e3:	75 f3                	jne    8007d8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007e5:	90                   	nop
		}
	}
  8007e6:	e9 47 fc ff ff       	jmp    800432 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007eb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007ef:	5b                   	pop    %ebx
  8007f0:	5e                   	pop    %esi
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8007f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800802:	8b 45 10             	mov    0x10(%ebp),%eax
  800805:	ff 75 f4             	pushl  -0xc(%ebp)
  800808:	50                   	push   %eax
  800809:	ff 75 0c             	pushl  0xc(%ebp)
  80080c:	ff 75 08             	pushl  0x8(%ebp)
  80080f:	e8 16 fc ff ff       	call   80042a <vprintfmt>
  800814:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800817:	90                   	nop
  800818:	c9                   	leave  
  800819:	c3                   	ret    

0080081a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80081d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800820:	8b 40 08             	mov    0x8(%eax),%eax
  800823:	8d 50 01             	lea    0x1(%eax),%edx
  800826:	8b 45 0c             	mov    0xc(%ebp),%eax
  800829:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80082c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082f:	8b 10                	mov    (%eax),%edx
  800831:	8b 45 0c             	mov    0xc(%ebp),%eax
  800834:	8b 40 04             	mov    0x4(%eax),%eax
  800837:	39 c2                	cmp    %eax,%edx
  800839:	73 12                	jae    80084d <sprintputch+0x33>
		*b->buf++ = ch;
  80083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	8d 48 01             	lea    0x1(%eax),%ecx
  800843:	8b 55 0c             	mov    0xc(%ebp),%edx
  800846:	89 0a                	mov    %ecx,(%edx)
  800848:	8b 55 08             	mov    0x8(%ebp),%edx
  80084b:	88 10                	mov    %dl,(%eax)
}
  80084d:	90                   	nop
  80084e:	5d                   	pop    %ebp
  80084f:	c3                   	ret    

00800850 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80085c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	01 d0                	add    %edx,%eax
  800867:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800871:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800875:	74 06                	je     80087d <vsnprintf+0x2d>
  800877:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087b:	7f 07                	jg     800884 <vsnprintf+0x34>
		return -E_INVAL;
  80087d:	b8 03 00 00 00       	mov    $0x3,%eax
  800882:	eb 20                	jmp    8008a4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800884:	ff 75 14             	pushl  0x14(%ebp)
  800887:	ff 75 10             	pushl  0x10(%ebp)
  80088a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80088d:	50                   	push   %eax
  80088e:	68 1a 08 80 00       	push   $0x80081a
  800893:	e8 92 fb ff ff       	call   80042a <vprintfmt>
  800898:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80089b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    

008008a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8008af:	83 c0 04             	add    $0x4,%eax
  8008b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008bb:	50                   	push   %eax
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 89 ff ff ff       	call   800850 <vsnprintf>
  8008c7:	83 c4 10             	add    $0x10,%esp
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8008d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008dc:	74 13                	je     8008f1 <readline+0x1f>
		cprintf("%s", prompt);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 08             	pushl  0x8(%ebp)
  8008e4:	68 30 1f 80 00       	push   $0x801f30
  8008e9:	e8 69 f9 ff ff       	call   800257 <cprintf>
  8008ee:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8008f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8008f8:	83 ec 0c             	sub    $0xc,%esp
  8008fb:	6a 00                	push   $0x0
  8008fd:	e8 6f 0f 00 00       	call   801871 <iscons>
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800908:	e8 16 0f 00 00       	call   801823 <getchar>
  80090d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800910:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800914:	79 22                	jns    800938 <readline+0x66>
			if (c != -E_EOF)
  800916:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80091a:	0f 84 ad 00 00 00    	je     8009cd <readline+0xfb>
				cprintf("read error: %e\n", c);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 ec             	pushl  -0x14(%ebp)
  800926:	68 33 1f 80 00       	push   $0x801f33
  80092b:	e8 27 f9 ff ff       	call   800257 <cprintf>
  800930:	83 c4 10             	add    $0x10,%esp
			return;
  800933:	e9 95 00 00 00       	jmp    8009cd <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800938:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80093c:	7e 34                	jle    800972 <readline+0xa0>
  80093e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800945:	7f 2b                	jg     800972 <readline+0xa0>
			if (echoing)
  800947:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80094b:	74 0e                	je     80095b <readline+0x89>
				cputchar(c);
  80094d:	83 ec 0c             	sub    $0xc,%esp
  800950:	ff 75 ec             	pushl  -0x14(%ebp)
  800953:	e8 83 0e 00 00       	call   8017db <cputchar>
  800958:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095e:	8d 50 01             	lea    0x1(%eax),%edx
  800961:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800964:	89 c2                	mov    %eax,%edx
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	01 d0                	add    %edx,%eax
  80096b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80096e:	88 10                	mov    %dl,(%eax)
  800970:	eb 56                	jmp    8009c8 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800972:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800976:	75 1f                	jne    800997 <readline+0xc5>
  800978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80097c:	7e 19                	jle    800997 <readline+0xc5>
			if (echoing)
  80097e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800982:	74 0e                	je     800992 <readline+0xc0>
				cputchar(c);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff 75 ec             	pushl  -0x14(%ebp)
  80098a:	e8 4c 0e 00 00       	call   8017db <cputchar>
  80098f:	83 c4 10             	add    $0x10,%esp

			i--;
  800992:	ff 4d f4             	decl   -0xc(%ebp)
  800995:	eb 31                	jmp    8009c8 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800997:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80099b:	74 0a                	je     8009a7 <readline+0xd5>
  80099d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8009a1:	0f 85 61 ff ff ff    	jne    800908 <readline+0x36>
			if (echoing)
  8009a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009ab:	74 0e                	je     8009bb <readline+0xe9>
				cputchar(c);
  8009ad:	83 ec 0c             	sub    $0xc,%esp
  8009b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8009b3:	e8 23 0e 00 00       	call   8017db <cputchar>
  8009b8:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8009bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c1:	01 d0                	add    %edx,%eax
  8009c3:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8009c6:	eb 06                	jmp    8009ce <readline+0xfc>
		}
	}
  8009c8:	e9 3b ff ff ff       	jmp    800908 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8009cd:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009d6:	e8 cf 09 00 00       	call   8013aa <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8009db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009df:	74 13                	je     8009f4 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 08             	pushl  0x8(%ebp)
  8009e7:	68 30 1f 80 00       	push   $0x801f30
  8009ec:	e8 66 f8 ff ff       	call   800257 <cprintf>
  8009f1:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009fb:	83 ec 0c             	sub    $0xc,%esp
  8009fe:	6a 00                	push   $0x0
  800a00:	e8 6c 0e 00 00       	call   801871 <iscons>
  800a05:	83 c4 10             	add    $0x10,%esp
  800a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a0b:	e8 13 0e 00 00       	call   801823 <getchar>
  800a10:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a17:	79 23                	jns    800a3c <atomic_readline+0x6c>
			if (c != -E_EOF)
  800a19:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a1d:	74 13                	je     800a32 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 ec             	pushl  -0x14(%ebp)
  800a25:	68 33 1f 80 00       	push   $0x801f33
  800a2a:	e8 28 f8 ff ff       	call   800257 <cprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800a32:	e8 8d 09 00 00       	call   8013c4 <sys_enable_interrupt>
			return;
  800a37:	e9 9a 00 00 00       	jmp    800ad6 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a3c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a40:	7e 34                	jle    800a76 <atomic_readline+0xa6>
  800a42:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a49:	7f 2b                	jg     800a76 <atomic_readline+0xa6>
			if (echoing)
  800a4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a4f:	74 0e                	je     800a5f <atomic_readline+0x8f>
				cputchar(c);
  800a51:	83 ec 0c             	sub    $0xc,%esp
  800a54:	ff 75 ec             	pushl  -0x14(%ebp)
  800a57:	e8 7f 0d 00 00       	call   8017db <cputchar>
  800a5c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a62:	8d 50 01             	lea    0x1(%eax),%edx
  800a65:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a68:	89 c2                	mov    %eax,%edx
  800a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6d:	01 d0                	add    %edx,%eax
  800a6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a72:	88 10                	mov    %dl,(%eax)
  800a74:	eb 5b                	jmp    800ad1 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800a76:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a7a:	75 1f                	jne    800a9b <atomic_readline+0xcb>
  800a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a80:	7e 19                	jle    800a9b <atomic_readline+0xcb>
			if (echoing)
  800a82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a86:	74 0e                	je     800a96 <atomic_readline+0xc6>
				cputchar(c);
  800a88:	83 ec 0c             	sub    $0xc,%esp
  800a8b:	ff 75 ec             	pushl  -0x14(%ebp)
  800a8e:	e8 48 0d 00 00       	call   8017db <cputchar>
  800a93:	83 c4 10             	add    $0x10,%esp
			i--;
  800a96:	ff 4d f4             	decl   -0xc(%ebp)
  800a99:	eb 36                	jmp    800ad1 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800a9b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a9f:	74 0a                	je     800aab <atomic_readline+0xdb>
  800aa1:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800aa5:	0f 85 60 ff ff ff    	jne    800a0b <atomic_readline+0x3b>
			if (echoing)
  800aab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aaf:	74 0e                	je     800abf <atomic_readline+0xef>
				cputchar(c);
  800ab1:	83 ec 0c             	sub    $0xc,%esp
  800ab4:	ff 75 ec             	pushl  -0x14(%ebp)
  800ab7:	e8 1f 0d 00 00       	call   8017db <cputchar>
  800abc:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac5:	01 d0                	add    %edx,%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800aca:	e8 f5 08 00 00       	call   8013c4 <sys_enable_interrupt>
			return;
  800acf:	eb 05                	jmp    800ad6 <atomic_readline+0x106>
		}
	}
  800ad1:	e9 35 ff ff ff       	jmp    800a0b <atomic_readline+0x3b>
}
  800ad6:	c9                   	leave  
  800ad7:	c3                   	ret    

00800ad8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ade:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae5:	eb 06                	jmp    800aed <strlen+0x15>
		n++;
  800ae7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aea:	ff 45 08             	incl   0x8(%ebp)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8a 00                	mov    (%eax),%al
  800af2:	84 c0                	test   %al,%al
  800af4:	75 f1                	jne    800ae7 <strlen+0xf>
		n++;
	return n;
  800af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af9:	c9                   	leave  
  800afa:	c3                   	ret    

00800afb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b08:	eb 09                	jmp    800b13 <strnlen+0x18>
		n++;
  800b0a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0d:	ff 45 08             	incl   0x8(%ebp)
  800b10:	ff 4d 0c             	decl   0xc(%ebp)
  800b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b17:	74 09                	je     800b22 <strnlen+0x27>
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8a 00                	mov    (%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 e8                	jne    800b0a <strnlen+0xf>
		n++;
	return n;
  800b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b33:	90                   	nop
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8d 50 01             	lea    0x1(%eax),%edx
  800b3a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b43:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b46:	8a 12                	mov    (%edx),%dl
  800b48:	88 10                	mov    %dl,(%eax)
  800b4a:	8a 00                	mov    (%eax),%al
  800b4c:	84 c0                	test   %al,%al
  800b4e:	75 e4                	jne    800b34 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b68:	eb 1f                	jmp    800b89 <strncpy+0x34>
		*dst++ = *src;
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8d 50 01             	lea    0x1(%eax),%edx
  800b70:	89 55 08             	mov    %edx,0x8(%ebp)
  800b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b76:	8a 12                	mov    (%edx),%dl
  800b78:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	84 c0                	test   %al,%al
  800b81:	74 03                	je     800b86 <strncpy+0x31>
			src++;
  800b83:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b86:	ff 45 fc             	incl   -0x4(%ebp)
  800b89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b8f:	72 d9                	jb     800b6a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b94:	c9                   	leave  
  800b95:	c3                   	ret    

00800b96 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba6:	74 30                	je     800bd8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ba8:	eb 16                	jmp    800bc0 <strlcpy+0x2a>
			*dst++ = *src++;
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bbc:	8a 12                	mov    (%edx),%dl
  800bbe:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc0:	ff 4d 10             	decl   0x10(%ebp)
  800bc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc7:	74 09                	je     800bd2 <strlcpy+0x3c>
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	84 c0                	test   %al,%al
  800bd0:	75 d8                	jne    800baa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bde:	29 c2                	sub    %eax,%edx
  800be0:	89 d0                	mov    %edx,%eax
}
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800be7:	eb 06                	jmp    800bef <strcmp+0xb>
		p++, q++;
  800be9:	ff 45 08             	incl   0x8(%ebp)
  800bec:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8a 00                	mov    (%eax),%al
  800bf4:	84 c0                	test   %al,%al
  800bf6:	74 0e                	je     800c06 <strcmp+0x22>
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8a 10                	mov    (%eax),%dl
  800bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	38 c2                	cmp    %al,%dl
  800c04:	74 e3                	je     800be9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d0             	movzbl %al,%edx
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 c0             	movzbl %al,%eax
  800c16:	29 c2                	sub    %eax,%edx
  800c18:	89 d0                	mov    %edx,%eax
}
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c1f:	eb 09                	jmp    800c2a <strncmp+0xe>
		n--, p++, q++;
  800c21:	ff 4d 10             	decl   0x10(%ebp)
  800c24:	ff 45 08             	incl   0x8(%ebp)
  800c27:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c2e:	74 17                	je     800c47 <strncmp+0x2b>
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	84 c0                	test   %al,%al
  800c37:	74 0e                	je     800c47 <strncmp+0x2b>
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8a 10                	mov    (%eax),%dl
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8a 00                	mov    (%eax),%al
  800c43:	38 c2                	cmp    %al,%dl
  800c45:	74 da                	je     800c21 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4b:	75 07                	jne    800c54 <strncmp+0x38>
		return 0;
  800c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c52:	eb 14                	jmp    800c68 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	0f b6 d0             	movzbl %al,%edx
  800c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5f:	8a 00                	mov    (%eax),%al
  800c61:	0f b6 c0             	movzbl %al,%eax
  800c64:	29 c2                	sub    %eax,%edx
  800c66:	89 d0                	mov    %edx,%eax
}
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 04             	sub    $0x4,%esp
  800c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c73:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c76:	eb 12                	jmp    800c8a <strchr+0x20>
		if (*s == c)
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c80:	75 05                	jne    800c87 <strchr+0x1d>
			return (char *) s;
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	eb 11                	jmp    800c98 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c87:	ff 45 08             	incl   0x8(%ebp)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	75 e5                	jne    800c78 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 04             	sub    $0x4,%esp
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca6:	eb 0d                	jmp    800cb5 <strfind+0x1b>
		if (*s == c)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb0:	74 0e                	je     800cc0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 ea                	jne    800ca8 <strfind+0xe>
  800cbe:	eb 01                	jmp    800cc1 <strfind+0x27>
		if (*s == c)
			break;
  800cc0:	90                   	nop
	return (char *) s;
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cd8:	eb 0e                	jmp    800ce8 <memset+0x22>
		*p++ = c;
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdd:	8d 50 01             	lea    0x1(%eax),%edx
  800ce0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ce8:	ff 4d f8             	decl   -0x8(%ebp)
  800ceb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cef:	79 e9                	jns    800cda <memset+0x14>
		*p++ = c;

	return v;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d08:	eb 16                	jmp    800d20 <memcpy+0x2a>
		*d++ = *s++;
  800d0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d0d:	8d 50 01             	lea    0x1(%eax),%edx
  800d10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d1c:	8a 12                	mov    (%edx),%dl
  800d1e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d20:	8b 45 10             	mov    0x10(%ebp),%eax
  800d23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d26:	89 55 10             	mov    %edx,0x10(%ebp)
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	75 dd                	jne    800d0a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d47:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4a:	73 50                	jae    800d9c <memmove+0x6a>
  800d4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d52:	01 d0                	add    %edx,%eax
  800d54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d57:	76 43                	jbe    800d9c <memmove+0x6a>
		s += n;
  800d59:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d62:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d65:	eb 10                	jmp    800d77 <memmove+0x45>
			*--d = *--s;
  800d67:	ff 4d f8             	decl   -0x8(%ebp)
  800d6a:	ff 4d fc             	decl   -0x4(%ebp)
  800d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d70:	8a 10                	mov    (%eax),%dl
  800d72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d75:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d77:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d80:	85 c0                	test   %eax,%eax
  800d82:	75 e3                	jne    800d67 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d84:	eb 23                	jmp    800da9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da2:	89 55 10             	mov    %edx,0x10(%ebp)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	75 dd                	jne    800d86 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc0:	eb 2a                	jmp    800dec <memcmp+0x3e>
		if (*s1 != *s2)
  800dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc5:	8a 10                	mov    (%eax),%dl
  800dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	38 c2                	cmp    %al,%dl
  800dce:	74 16                	je     800de6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	0f b6 d0             	movzbl %al,%edx
  800dd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 c0             	movzbl %al,%eax
  800de0:	29 c2                	sub    %eax,%edx
  800de2:	89 d0                	mov    %edx,%eax
  800de4:	eb 18                	jmp    800dfe <memcmp+0x50>
		s1++, s2++;
  800de6:	ff 45 fc             	incl   -0x4(%ebp)
  800de9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df2:	89 55 10             	mov    %edx,0x10(%ebp)
  800df5:	85 c0                	test   %eax,%eax
  800df7:	75 c9                	jne    800dc2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	01 d0                	add    %edx,%eax
  800e0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e11:	eb 15                	jmp    800e28 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	0f b6 d0             	movzbl %al,%edx
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	0f b6 c0             	movzbl %al,%eax
  800e21:	39 c2                	cmp    %eax,%edx
  800e23:	74 0d                	je     800e32 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e25:	ff 45 08             	incl   0x8(%ebp)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e2e:	72 e3                	jb     800e13 <memfind+0x13>
  800e30:	eb 01                	jmp    800e33 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e32:	90                   	nop
	return (void *) s;
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e36:	c9                   	leave  
  800e37:	c3                   	ret    

00800e38 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e45:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4c:	eb 03                	jmp    800e51 <strtol+0x19>
		s++;
  800e4e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	3c 20                	cmp    $0x20,%al
  800e58:	74 f4                	je     800e4e <strtol+0x16>
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8a 00                	mov    (%eax),%al
  800e5f:	3c 09                	cmp    $0x9,%al
  800e61:	74 eb                	je     800e4e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	3c 2b                	cmp    $0x2b,%al
  800e6a:	75 05                	jne    800e71 <strtol+0x39>
		s++;
  800e6c:	ff 45 08             	incl   0x8(%ebp)
  800e6f:	eb 13                	jmp    800e84 <strtol+0x4c>
	else if (*s == '-')
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	3c 2d                	cmp    $0x2d,%al
  800e78:	75 0a                	jne    800e84 <strtol+0x4c>
		s++, neg = 1;
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e88:	74 06                	je     800e90 <strtol+0x58>
  800e8a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e8e:	75 20                	jne    800eb0 <strtol+0x78>
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	3c 30                	cmp    $0x30,%al
  800e97:	75 17                	jne    800eb0 <strtol+0x78>
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	40                   	inc    %eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	3c 78                	cmp    $0x78,%al
  800ea1:	75 0d                	jne    800eb0 <strtol+0x78>
		s += 2, base = 16;
  800ea3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ea7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eae:	eb 28                	jmp    800ed8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb4:	75 15                	jne    800ecb <strtol+0x93>
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	3c 30                	cmp    $0x30,%al
  800ebd:	75 0c                	jne    800ecb <strtol+0x93>
		s++, base = 8;
  800ebf:	ff 45 08             	incl   0x8(%ebp)
  800ec2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ec9:	eb 0d                	jmp    800ed8 <strtol+0xa0>
	else if (base == 0)
  800ecb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecf:	75 07                	jne    800ed8 <strtol+0xa0>
		base = 10;
  800ed1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	3c 2f                	cmp    $0x2f,%al
  800edf:	7e 19                	jle    800efa <strtol+0xc2>
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	3c 39                	cmp    $0x39,%al
  800ee8:	7f 10                	jg     800efa <strtol+0xc2>
			dig = *s - '0';
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	0f be c0             	movsbl %al,%eax
  800ef2:	83 e8 30             	sub    $0x30,%eax
  800ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef8:	eb 42                	jmp    800f3c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3c 60                	cmp    $0x60,%al
  800f01:	7e 19                	jle    800f1c <strtol+0xe4>
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	3c 7a                	cmp    $0x7a,%al
  800f0a:	7f 10                	jg     800f1c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	0f be c0             	movsbl %al,%eax
  800f14:	83 e8 57             	sub    $0x57,%eax
  800f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1a:	eb 20                	jmp    800f3c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 40                	cmp    $0x40,%al
  800f23:	7e 39                	jle    800f5e <strtol+0x126>
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	3c 5a                	cmp    $0x5a,%al
  800f2c:	7f 30                	jg     800f5e <strtol+0x126>
			dig = *s - 'A' + 10;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f be c0             	movsbl %al,%eax
  800f36:	83 e8 37             	sub    $0x37,%eax
  800f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f42:	7d 19                	jge    800f5d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f44:	ff 45 08             	incl   0x8(%ebp)
  800f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f4e:	89 c2                	mov    %eax,%edx
  800f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f58:	e9 7b ff ff ff       	jmp    800ed8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f5d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f62:	74 08                	je     800f6c <strtol+0x134>
		*endptr = (char *) s;
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f70:	74 07                	je     800f79 <strtol+0x141>
  800f72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f75:	f7 d8                	neg    %eax
  800f77:	eb 03                	jmp    800f7c <strtol+0x144>
  800f79:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <ltostr>:

void
ltostr(long value, char *str)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f96:	79 13                	jns    800fab <ltostr+0x2d>
	{
		neg = 1;
  800f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fa8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb3:	99                   	cltd   
  800fb4:	f7 f9                	idiv   %ecx
  800fb6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbc:	8d 50 01             	lea    0x1(%eax),%edx
  800fbf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc2:	89 c2                	mov    %eax,%edx
  800fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc7:	01 d0                	add    %edx,%eax
  800fc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fcc:	83 c2 30             	add    $0x30,%edx
  800fcf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fd9:	f7 e9                	imul   %ecx
  800fdb:	c1 fa 02             	sar    $0x2,%edx
  800fde:	89 c8                	mov    %ecx,%eax
  800fe0:	c1 f8 1f             	sar    $0x1f,%eax
  800fe3:	29 c2                	sub    %eax,%edx
  800fe5:	89 d0                	mov    %edx,%eax
  800fe7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff2:	f7 e9                	imul   %ecx
  800ff4:	c1 fa 02             	sar    $0x2,%edx
  800ff7:	89 c8                	mov    %ecx,%eax
  800ff9:	c1 f8 1f             	sar    $0x1f,%eax
  800ffc:	29 c2                	sub    %eax,%edx
  800ffe:	89 d0                	mov    %edx,%eax
  801000:	c1 e0 02             	shl    $0x2,%eax
  801003:	01 d0                	add    %edx,%eax
  801005:	01 c0                	add    %eax,%eax
  801007:	29 c1                	sub    %eax,%ecx
  801009:	89 ca                	mov    %ecx,%edx
  80100b:	85 d2                	test   %edx,%edx
  80100d:	75 9c                	jne    800fab <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80100f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	48                   	dec    %eax
  80101a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80101d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801021:	74 3d                	je     801060 <ltostr+0xe2>
		start = 1 ;
  801023:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102a:	eb 34                	jmp    801060 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80102c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	01 d0                	add    %edx,%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	01 c2                	add    %eax,%edx
  801041:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	01 c8                	add    %ecx,%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80104d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801050:	8b 45 0c             	mov    0xc(%ebp),%eax
  801053:	01 c2                	add    %eax,%edx
  801055:	8a 45 eb             	mov    -0x15(%ebp),%al
  801058:	88 02                	mov    %al,(%edx)
		start++ ;
  80105a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80105d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801066:	7c c4                	jl     80102c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801068:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801073:	90                   	nop
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 54 fa ff ff       	call   800ad8 <strlen>
  801084:	83 c4 04             	add    $0x4,%esp
  801087:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108a:	ff 75 0c             	pushl  0xc(%ebp)
  80108d:	e8 46 fa ff ff       	call   800ad8 <strlen>
  801092:	83 c4 04             	add    $0x4,%esp
  801095:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a6:	eb 17                	jmp    8010bf <strcconcat+0x49>
		final[s] = str1[s] ;
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	01 c2                	add    %eax,%edx
  8010b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	01 c8                	add    %ecx,%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010bc:	ff 45 fc             	incl   -0x4(%ebp)
  8010bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c5:	7c e1                	jl     8010a8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d5:	eb 1f                	jmp    8010f6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e0:	89 c2                	mov    %eax,%edx
  8010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e5:	01 c2                	add    %eax,%edx
  8010e7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	01 c8                	add    %ecx,%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f3:	ff 45 f8             	incl   -0x8(%ebp)
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010fc:	7c d9                	jl     8010d7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 d0                	add    %edx,%eax
  801106:	c6 00 00             	movb   $0x0,(%eax)
}
  801109:	90                   	nop
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80110f:	8b 45 14             	mov    0x14(%ebp),%eax
  801112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801118:	8b 45 14             	mov    0x14(%ebp),%eax
  80111b:	8b 00                	mov    (%eax),%eax
  80111d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112f:	eb 0c                	jmp    80113d <strsplit+0x31>
			*string++ = 0;
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8d 50 01             	lea    0x1(%eax),%edx
  801137:	89 55 08             	mov    %edx,0x8(%ebp)
  80113a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	84 c0                	test   %al,%al
  801144:	74 18                	je     80115e <strsplit+0x52>
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	0f be c0             	movsbl %al,%eax
  80114e:	50                   	push   %eax
  80114f:	ff 75 0c             	pushl  0xc(%ebp)
  801152:	e8 13 fb ff ff       	call   800c6a <strchr>
  801157:	83 c4 08             	add    $0x8,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	75 d3                	jne    801131 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	84 c0                	test   %al,%al
  801165:	74 5a                	je     8011c1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801167:	8b 45 14             	mov    0x14(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	83 f8 0f             	cmp    $0xf,%eax
  80116f:	75 07                	jne    801178 <strsplit+0x6c>
		{
			return 0;
  801171:	b8 00 00 00 00       	mov    $0x0,%eax
  801176:	eb 66                	jmp    8011de <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801178:	8b 45 14             	mov    0x14(%ebp),%eax
  80117b:	8b 00                	mov    (%eax),%eax
  80117d:	8d 48 01             	lea    0x1(%eax),%ecx
  801180:	8b 55 14             	mov    0x14(%ebp),%edx
  801183:	89 0a                	mov    %ecx,(%edx)
  801185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 c2                	add    %eax,%edx
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801196:	eb 03                	jmp    80119b <strsplit+0x8f>
			string++;
  801198:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	74 8b                	je     80112f <strsplit+0x23>
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	0f be c0             	movsbl %al,%eax
  8011ac:	50                   	push   %eax
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	e8 b5 fa ff ff       	call   800c6a <strchr>
  8011b5:	83 c4 08             	add    $0x8,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	74 dc                	je     801198 <strsplit+0x8c>
			string++;
	}
  8011bc:	e9 6e ff ff ff       	jmp    80112f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	8b 00                	mov    (%eax),%eax
  8011c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	57                   	push   %edi
  8011e4:	56                   	push   %esi
  8011e5:	53                   	push   %ebx
  8011e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011fb:	cd 30                	int    $0x30
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801200:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	5b                   	pop    %ebx
  801207:	5e                   	pop    %esi
  801208:	5f                   	pop    %edi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    

0080120b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	6a 00                	push   $0x0
  801213:	6a 00                	push   $0x0
  801215:	6a 00                	push   $0x0
  801217:	ff 75 0c             	pushl  0xc(%ebp)
  80121a:	50                   	push   %eax
  80121b:	6a 00                	push   $0x0
  80121d:	e8 be ff ff ff       	call   8011e0 <syscall>
  801222:	83 c4 18             	add    $0x18,%esp
}
  801225:	90                   	nop
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <sys_cgetc>:

int
sys_cgetc(void)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 01                	push   $0x1
  801237:	e8 a4 ff ff ff       	call   8011e0 <syscall>
  80123c:	83 c4 18             	add    $0x18,%esp
}
  80123f:	c9                   	leave  
  801240:	c3                   	ret    

00801241 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	50                   	push   %eax
  801250:	6a 03                	push   $0x3
  801252:	e8 89 ff ff ff       	call   8011e0 <syscall>
  801257:	83 c4 18             	add    $0x18,%esp
}
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 02                	push   $0x2
  80126b:	e8 70 ff ff ff       	call   8011e0 <syscall>
  801270:	83 c4 18             	add    $0x18,%esp
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <sys_env_exit>:

void sys_env_exit(void)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 04                	push   $0x4
  801284:	e8 57 ff ff ff       	call   8011e0 <syscall>
  801289:	83 c4 18             	add    $0x18,%esp
}
  80128c:	90                   	nop
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801292:	8b 55 0c             	mov    0xc(%ebp),%edx
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	52                   	push   %edx
  80129f:	50                   	push   %eax
  8012a0:	6a 05                	push   $0x5
  8012a2:	e8 39 ff ff ff       	call   8011e0 <syscall>
  8012a7:	83 c4 18             	add    $0x18,%esp
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	56                   	push   %esi
  8012b0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8012b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	51                   	push   %ecx
  8012c3:	52                   	push   %edx
  8012c4:	50                   	push   %eax
  8012c5:	6a 06                	push   $0x6
  8012c7:	e8 14 ff ff ff       	call   8011e0 <syscall>
  8012cc:	83 c4 18             	add    $0x18,%esp
}
  8012cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    

008012d6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	52                   	push   %edx
  8012e6:	50                   	push   %eax
  8012e7:	6a 07                	push   $0x7
  8012e9:	e8 f2 fe ff ff       	call   8011e0 <syscall>
  8012ee:	83 c4 18             	add    $0x18,%esp
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	ff 75 0c             	pushl  0xc(%ebp)
  8012ff:	ff 75 08             	pushl  0x8(%ebp)
  801302:	6a 08                	push   $0x8
  801304:	e8 d7 fe ff ff       	call   8011e0 <syscall>
  801309:	83 c4 18             	add    $0x18,%esp
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 09                	push   $0x9
  80131d:	e8 be fe ff ff       	call   8011e0 <syscall>
  801322:	83 c4 18             	add    $0x18,%esp
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 0a                	push   $0xa
  801336:	e8 a5 fe ff ff       	call   8011e0 <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 0b                	push   $0xb
  80134f:	e8 8c fe ff ff       	call   8011e0 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	ff 75 08             	pushl  0x8(%ebp)
  801368:	6a 0d                	push   $0xd
  80136a:	e8 71 fe ff ff       	call   8011e0 <syscall>
  80136f:	83 c4 18             	add    $0x18,%esp
	return;
  801372:	90                   	nop
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	ff 75 0c             	pushl  0xc(%ebp)
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	6a 0e                	push   $0xe
  801386:	e8 55 fe ff ff       	call   8011e0 <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
	return ;
  80138e:	90                   	nop
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 0c                	push   $0xc
  8013a0:	e8 3b fe ff ff       	call   8011e0 <syscall>
  8013a5:	83 c4 18             	add    $0x18,%esp
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 10                	push   $0x10
  8013b9:	e8 22 fe ff ff       	call   8011e0 <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	90                   	nop
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 11                	push   $0x11
  8013d3:	e8 08 fe ff ff       	call   8011e0 <syscall>
  8013d8:	83 c4 18             	add    $0x18,%esp
}
  8013db:	90                   	nop
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <sys_cputc>:


void
sys_cputc(const char c)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	83 ec 04             	sub    $0x4,%esp
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013ea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	50                   	push   %eax
  8013f7:	6a 12                	push   $0x12
  8013f9:	e8 e2 fd ff ff       	call   8011e0 <syscall>
  8013fe:	83 c4 18             	add    $0x18,%esp
}
  801401:	90                   	nop
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 13                	push   $0x13
  801413:	e8 c8 fd ff ff       	call   8011e0 <syscall>
  801418:	83 c4 18             	add    $0x18,%esp
}
  80141b:	90                   	nop
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	ff 75 0c             	pushl  0xc(%ebp)
  80142d:	50                   	push   %eax
  80142e:	6a 14                	push   $0x14
  801430:	e8 ab fd ff ff       	call   8011e0 <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	50                   	push   %eax
  801449:	6a 17                	push   $0x17
  80144b:	e8 90 fd ff ff       	call   8011e0 <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	50                   	push   %eax
  801464:	6a 15                	push   $0x15
  801466:	e8 75 fd ff ff       	call   8011e0 <syscall>
  80146b:	83 c4 18             	add    $0x18,%esp
}
  80146e:	90                   	nop
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	50                   	push   %eax
  801480:	6a 16                	push   $0x16
  801482:	e8 59 fd ff ff       	call   8011e0 <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
}
  80148a:	90                   	nop
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	8b 45 10             	mov    0x10(%ebp),%eax
  801496:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801499:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80149c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	6a 00                	push   $0x0
  8014a5:	51                   	push   %ecx
  8014a6:	52                   	push   %edx
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	50                   	push   %eax
  8014ab:	6a 18                	push   $0x18
  8014ad:	e8 2e fd ff ff       	call   8011e0 <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8014ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	52                   	push   %edx
  8014c7:	50                   	push   %eax
  8014c8:	6a 19                	push   $0x19
  8014ca:	e8 11 fd ff ff       	call   8011e0 <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	50                   	push   %eax
  8014e3:	6a 1a                	push   $0x1a
  8014e5:	e8 f6 fc ff ff       	call   8011e0 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 1b                	push   $0x1b
  8014fe:	e8 dd fc ff ff       	call   8011e0 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 1c                	push   $0x1c
  801517:	e8 c4 fc ff ff       	call   8011e0 <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	50                   	push   %eax
  801531:	6a 1d                	push   $0x1d
  801533:	e8 a8 fc ff ff       	call   8011e0 <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	50                   	push   %eax
  80154c:	6a 1e                	push   $0x1e
  80154e:	e8 8d fc ff ff       	call   8011e0 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	90                   	nop
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	50                   	push   %eax
  801568:	6a 1f                	push   $0x1f
  80156a:	e8 71 fc ff ff       	call   8011e0 <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	90                   	nop
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80157b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80157e:	8d 50 04             	lea    0x4(%eax),%edx
  801581:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	52                   	push   %edx
  80158b:	50                   	push   %eax
  80158c:	6a 20                	push   $0x20
  80158e:	e8 4d fc ff ff       	call   8011e0 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
	return result;
  801596:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801599:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159f:	89 01                	mov    %eax,(%ecx)
  8015a1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	c9                   	leave  
  8015a8:	c2 04 00             	ret    $0x4

008015ab <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	ff 75 10             	pushl  0x10(%ebp)
  8015b5:	ff 75 0c             	pushl  0xc(%ebp)
  8015b8:	ff 75 08             	pushl  0x8(%ebp)
  8015bb:	6a 0f                	push   $0xf
  8015bd:	e8 1e fc ff ff       	call   8011e0 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c5:	90                   	nop
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 21                	push   $0x21
  8015d7:	e8 04 fc ff ff       	call   8011e0 <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015ed:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	50                   	push   %eax
  8015fa:	6a 22                	push   $0x22
  8015fc:	e8 df fb ff ff       	call   8011e0 <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
	return ;
  801604:	90                   	nop
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <rsttst>:
void rsttst()
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 24                	push   $0x24
  801616:	e8 c5 fb ff ff       	call   8011e0 <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
	return ;
  80161e:	90                   	nop
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	8b 45 14             	mov    0x14(%ebp),%eax
  80162a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80162d:	8b 55 18             	mov    0x18(%ebp),%edx
  801630:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801634:	52                   	push   %edx
  801635:	50                   	push   %eax
  801636:	ff 75 10             	pushl  0x10(%ebp)
  801639:	ff 75 0c             	pushl  0xc(%ebp)
  80163c:	ff 75 08             	pushl  0x8(%ebp)
  80163f:	6a 23                	push   $0x23
  801641:	e8 9a fb ff ff       	call   8011e0 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
	return ;
  801649:	90                   	nop
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <chktst>:
void chktst(uint32 n)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	ff 75 08             	pushl  0x8(%ebp)
  80165a:	6a 25                	push   $0x25
  80165c:	e8 7f fb ff ff       	call   8011e0 <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
	return ;
  801664:	90                   	nop
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 26                	push   $0x26
  801679:	e8 62 fb ff ff       	call   8011e0 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
  801681:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801684:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801688:	75 07                	jne    801691 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80168a:	b8 01 00 00 00       	mov    $0x1,%eax
  80168f:	eb 05                	jmp    801696 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801691:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 26                	push   $0x26
  8016aa:	e8 31 fb ff ff       	call   8011e0 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
  8016b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016b5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016b9:	75 07                	jne    8016c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8016c0:	eb 05                	jmp    8016c7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 26                	push   $0x26
  8016db:	e8 00 fb ff ff       	call   8011e0 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
  8016e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016e6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016ea:	75 07                	jne    8016f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f1:	eb 05                	jmp    8016f8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 26                	push   $0x26
  80170c:	e8 cf fa ff ff       	call   8011e0 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
  801714:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801717:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80171b:	75 07                	jne    801724 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80171d:	b8 01 00 00 00       	mov    $0x1,%eax
  801722:	eb 05                	jmp    801729 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	6a 27                	push   $0x27
  80173b:	e8 a0 fa ff ff       	call   8011e0 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
	return ;
  801743:	90                   	nop
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 28             	sub    $0x28,%esp
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80174c:	8b 55 08             	mov    0x8(%ebp),%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	c1 e0 02             	shl    $0x2,%eax
  801754:	01 d0                	add    %edx,%eax
  801756:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175d:	01 d0                	add    %edx,%eax
  80175f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801766:	01 d0                	add    %edx,%eax
  801768:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80176f:	01 d0                	add    %edx,%eax
  801771:	c1 e0 04             	shl    $0x4,%eax
  801774:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80177e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801781:	83 ec 0c             	sub    $0xc,%esp
  801784:	50                   	push   %eax
  801785:	e8 eb fd ff ff       	call   801575 <sys_get_virtual_time>
  80178a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80178d:	eb 41                	jmp    8017d0 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80178f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801792:	83 ec 0c             	sub    $0xc,%esp
  801795:	50                   	push   %eax
  801796:	e8 da fd ff ff       	call   801575 <sys_get_virtual_time>
  80179b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80179e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a4:	29 c2                	sub    %eax,%edx
  8017a6:	89 d0                	mov    %edx,%eax
  8017a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8017ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b1:	89 d1                	mov    %edx,%ecx
  8017b3:	29 c1                	sub    %eax,%ecx
  8017b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8017b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	0f 97 c0             	seta   %al
  8017c0:	0f b6 c0             	movzbl %al,%eax
  8017c3:	29 c1                	sub    %eax,%ecx
  8017c5:	89 c8                	mov    %ecx,%eax
  8017c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8017ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017d6:	72 b7                	jb     80178f <env_sleep+0x49>
//				,currentTime.hi, currentTime.low
//				,res.hi, res.low
//				,cycles_counter
//				);
	}
}
  8017d8:	90                   	nop
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8017e7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8017eb:	83 ec 0c             	sub    $0xc,%esp
  8017ee:	50                   	push   %eax
  8017ef:	e8 ea fb ff ff       	call   8013de <sys_cputc>
  8017f4:	83 c4 10             	add    $0x10,%esp
}
  8017f7:	90                   	nop
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801800:	e8 a5 fb ff ff       	call   8013aa <sys_disable_interrupt>
	char c = ch;
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80180b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	50                   	push   %eax
  801813:	e8 c6 fb ff ff       	call   8013de <sys_cputc>
  801818:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80181b:	e8 a4 fb ff ff       	call   8013c4 <sys_enable_interrupt>
}
  801820:	90                   	nop
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <getchar>:

int
getchar(void)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801829:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801830:	eb 08                	jmp    80183a <getchar+0x17>
	{
		c = sys_cgetc();
  801832:	e8 f1 f9 ff ff       	call   801228 <sys_cgetc>
  801837:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80183a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80183e:	74 f2                	je     801832 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801840:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <atomic_getchar>:

int
atomic_getchar(void)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80184b:	e8 5a fb ff ff       	call   8013aa <sys_disable_interrupt>
	int c=0;
  801850:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801857:	eb 08                	jmp    801861 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801859:	e8 ca f9 ff ff       	call   801228 <sys_cgetc>
  80185e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801865:	74 f2                	je     801859 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801867:	e8 58 fb ff ff       	call   8013c4 <sys_enable_interrupt>
	return c;
  80186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <iscons>:

int iscons(int fdnum)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801874:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801879:	5d                   	pop    %ebp
  80187a:	c3                   	ret    
  80187b:	90                   	nop

0080187c <__udivdi3>:
  80187c:	55                   	push   %ebp
  80187d:	57                   	push   %edi
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
  801880:	83 ec 1c             	sub    $0x1c,%esp
  801883:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801887:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80188b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80188f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801893:	89 ca                	mov    %ecx,%edx
  801895:	89 f8                	mov    %edi,%eax
  801897:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80189b:	85 f6                	test   %esi,%esi
  80189d:	75 2d                	jne    8018cc <__udivdi3+0x50>
  80189f:	39 cf                	cmp    %ecx,%edi
  8018a1:	77 65                	ja     801908 <__udivdi3+0x8c>
  8018a3:	89 fd                	mov    %edi,%ebp
  8018a5:	85 ff                	test   %edi,%edi
  8018a7:	75 0b                	jne    8018b4 <__udivdi3+0x38>
  8018a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ae:	31 d2                	xor    %edx,%edx
  8018b0:	f7 f7                	div    %edi
  8018b2:	89 c5                	mov    %eax,%ebp
  8018b4:	31 d2                	xor    %edx,%edx
  8018b6:	89 c8                	mov    %ecx,%eax
  8018b8:	f7 f5                	div    %ebp
  8018ba:	89 c1                	mov    %eax,%ecx
  8018bc:	89 d8                	mov    %ebx,%eax
  8018be:	f7 f5                	div    %ebp
  8018c0:	89 cf                	mov    %ecx,%edi
  8018c2:	89 fa                	mov    %edi,%edx
  8018c4:	83 c4 1c             	add    $0x1c,%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5f                   	pop    %edi
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    
  8018cc:	39 ce                	cmp    %ecx,%esi
  8018ce:	77 28                	ja     8018f8 <__udivdi3+0x7c>
  8018d0:	0f bd fe             	bsr    %esi,%edi
  8018d3:	83 f7 1f             	xor    $0x1f,%edi
  8018d6:	75 40                	jne    801918 <__udivdi3+0x9c>
  8018d8:	39 ce                	cmp    %ecx,%esi
  8018da:	72 0a                	jb     8018e6 <__udivdi3+0x6a>
  8018dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018e0:	0f 87 9e 00 00 00    	ja     801984 <__udivdi3+0x108>
  8018e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018eb:	89 fa                	mov    %edi,%edx
  8018ed:	83 c4 1c             	add    $0x1c,%esp
  8018f0:	5b                   	pop    %ebx
  8018f1:	5e                   	pop    %esi
  8018f2:	5f                   	pop    %edi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    
  8018f5:	8d 76 00             	lea    0x0(%esi),%esi
  8018f8:	31 ff                	xor    %edi,%edi
  8018fa:	31 c0                	xor    %eax,%eax
  8018fc:	89 fa                	mov    %edi,%edx
  8018fe:	83 c4 1c             	add    $0x1c,%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5f                   	pop    %edi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    
  801906:	66 90                	xchg   %ax,%ax
  801908:	89 d8                	mov    %ebx,%eax
  80190a:	f7 f7                	div    %edi
  80190c:	31 ff                	xor    %edi,%edi
  80190e:	89 fa                	mov    %edi,%edx
  801910:	83 c4 1c             	add    $0x1c,%esp
  801913:	5b                   	pop    %ebx
  801914:	5e                   	pop    %esi
  801915:	5f                   	pop    %edi
  801916:	5d                   	pop    %ebp
  801917:	c3                   	ret    
  801918:	bd 20 00 00 00       	mov    $0x20,%ebp
  80191d:	89 eb                	mov    %ebp,%ebx
  80191f:	29 fb                	sub    %edi,%ebx
  801921:	89 f9                	mov    %edi,%ecx
  801923:	d3 e6                	shl    %cl,%esi
  801925:	89 c5                	mov    %eax,%ebp
  801927:	88 d9                	mov    %bl,%cl
  801929:	d3 ed                	shr    %cl,%ebp
  80192b:	89 e9                	mov    %ebp,%ecx
  80192d:	09 f1                	or     %esi,%ecx
  80192f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801933:	89 f9                	mov    %edi,%ecx
  801935:	d3 e0                	shl    %cl,%eax
  801937:	89 c5                	mov    %eax,%ebp
  801939:	89 d6                	mov    %edx,%esi
  80193b:	88 d9                	mov    %bl,%cl
  80193d:	d3 ee                	shr    %cl,%esi
  80193f:	89 f9                	mov    %edi,%ecx
  801941:	d3 e2                	shl    %cl,%edx
  801943:	8b 44 24 08          	mov    0x8(%esp),%eax
  801947:	88 d9                	mov    %bl,%cl
  801949:	d3 e8                	shr    %cl,%eax
  80194b:	09 c2                	or     %eax,%edx
  80194d:	89 d0                	mov    %edx,%eax
  80194f:	89 f2                	mov    %esi,%edx
  801951:	f7 74 24 0c          	divl   0xc(%esp)
  801955:	89 d6                	mov    %edx,%esi
  801957:	89 c3                	mov    %eax,%ebx
  801959:	f7 e5                	mul    %ebp
  80195b:	39 d6                	cmp    %edx,%esi
  80195d:	72 19                	jb     801978 <__udivdi3+0xfc>
  80195f:	74 0b                	je     80196c <__udivdi3+0xf0>
  801961:	89 d8                	mov    %ebx,%eax
  801963:	31 ff                	xor    %edi,%edi
  801965:	e9 58 ff ff ff       	jmp    8018c2 <__udivdi3+0x46>
  80196a:	66 90                	xchg   %ax,%ax
  80196c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801970:	89 f9                	mov    %edi,%ecx
  801972:	d3 e2                	shl    %cl,%edx
  801974:	39 c2                	cmp    %eax,%edx
  801976:	73 e9                	jae    801961 <__udivdi3+0xe5>
  801978:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80197b:	31 ff                	xor    %edi,%edi
  80197d:	e9 40 ff ff ff       	jmp    8018c2 <__udivdi3+0x46>
  801982:	66 90                	xchg   %ax,%ax
  801984:	31 c0                	xor    %eax,%eax
  801986:	e9 37 ff ff ff       	jmp    8018c2 <__udivdi3+0x46>
  80198b:	90                   	nop

0080198c <__umoddi3>:
  80198c:	55                   	push   %ebp
  80198d:	57                   	push   %edi
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 1c             	sub    $0x1c,%esp
  801993:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801997:	8b 74 24 34          	mov    0x34(%esp),%esi
  80199b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80199f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ab:	89 f3                	mov    %esi,%ebx
  8019ad:	89 fa                	mov    %edi,%edx
  8019af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019b3:	89 34 24             	mov    %esi,(%esp)
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	75 1a                	jne    8019d4 <__umoddi3+0x48>
  8019ba:	39 f7                	cmp    %esi,%edi
  8019bc:	0f 86 a2 00 00 00    	jbe    801a64 <__umoddi3+0xd8>
  8019c2:	89 c8                	mov    %ecx,%eax
  8019c4:	89 f2                	mov    %esi,%edx
  8019c6:	f7 f7                	div    %edi
  8019c8:	89 d0                	mov    %edx,%eax
  8019ca:	31 d2                	xor    %edx,%edx
  8019cc:	83 c4 1c             	add    $0x1c,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5e                   	pop    %esi
  8019d1:	5f                   	pop    %edi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    
  8019d4:	39 f0                	cmp    %esi,%eax
  8019d6:	0f 87 ac 00 00 00    	ja     801a88 <__umoddi3+0xfc>
  8019dc:	0f bd e8             	bsr    %eax,%ebp
  8019df:	83 f5 1f             	xor    $0x1f,%ebp
  8019e2:	0f 84 ac 00 00 00    	je     801a94 <__umoddi3+0x108>
  8019e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8019ed:	29 ef                	sub    %ebp,%edi
  8019ef:	89 fe                	mov    %edi,%esi
  8019f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019f5:	89 e9                	mov    %ebp,%ecx
  8019f7:	d3 e0                	shl    %cl,%eax
  8019f9:	89 d7                	mov    %edx,%edi
  8019fb:	89 f1                	mov    %esi,%ecx
  8019fd:	d3 ef                	shr    %cl,%edi
  8019ff:	09 c7                	or     %eax,%edi
  801a01:	89 e9                	mov    %ebp,%ecx
  801a03:	d3 e2                	shl    %cl,%edx
  801a05:	89 14 24             	mov    %edx,(%esp)
  801a08:	89 d8                	mov    %ebx,%eax
  801a0a:	d3 e0                	shl    %cl,%eax
  801a0c:	89 c2                	mov    %eax,%edx
  801a0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a12:	d3 e0                	shl    %cl,%eax
  801a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a18:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a1c:	89 f1                	mov    %esi,%ecx
  801a1e:	d3 e8                	shr    %cl,%eax
  801a20:	09 d0                	or     %edx,%eax
  801a22:	d3 eb                	shr    %cl,%ebx
  801a24:	89 da                	mov    %ebx,%edx
  801a26:	f7 f7                	div    %edi
  801a28:	89 d3                	mov    %edx,%ebx
  801a2a:	f7 24 24             	mull   (%esp)
  801a2d:	89 c6                	mov    %eax,%esi
  801a2f:	89 d1                	mov    %edx,%ecx
  801a31:	39 d3                	cmp    %edx,%ebx
  801a33:	0f 82 87 00 00 00    	jb     801ac0 <__umoddi3+0x134>
  801a39:	0f 84 91 00 00 00    	je     801ad0 <__umoddi3+0x144>
  801a3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a43:	29 f2                	sub    %esi,%edx
  801a45:	19 cb                	sbb    %ecx,%ebx
  801a47:	89 d8                	mov    %ebx,%eax
  801a49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a4d:	d3 e0                	shl    %cl,%eax
  801a4f:	89 e9                	mov    %ebp,%ecx
  801a51:	d3 ea                	shr    %cl,%edx
  801a53:	09 d0                	or     %edx,%eax
  801a55:	89 e9                	mov    %ebp,%ecx
  801a57:	d3 eb                	shr    %cl,%ebx
  801a59:	89 da                	mov    %ebx,%edx
  801a5b:	83 c4 1c             	add    $0x1c,%esp
  801a5e:	5b                   	pop    %ebx
  801a5f:	5e                   	pop    %esi
  801a60:	5f                   	pop    %edi
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    
  801a63:	90                   	nop
  801a64:	89 fd                	mov    %edi,%ebp
  801a66:	85 ff                	test   %edi,%edi
  801a68:	75 0b                	jne    801a75 <__umoddi3+0xe9>
  801a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6f:	31 d2                	xor    %edx,%edx
  801a71:	f7 f7                	div    %edi
  801a73:	89 c5                	mov    %eax,%ebp
  801a75:	89 f0                	mov    %esi,%eax
  801a77:	31 d2                	xor    %edx,%edx
  801a79:	f7 f5                	div    %ebp
  801a7b:	89 c8                	mov    %ecx,%eax
  801a7d:	f7 f5                	div    %ebp
  801a7f:	89 d0                	mov    %edx,%eax
  801a81:	e9 44 ff ff ff       	jmp    8019ca <__umoddi3+0x3e>
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	89 c8                	mov    %ecx,%eax
  801a8a:	89 f2                	mov    %esi,%edx
  801a8c:	83 c4 1c             	add    $0x1c,%esp
  801a8f:	5b                   	pop    %ebx
  801a90:	5e                   	pop    %esi
  801a91:	5f                   	pop    %edi
  801a92:	5d                   	pop    %ebp
  801a93:	c3                   	ret    
  801a94:	3b 04 24             	cmp    (%esp),%eax
  801a97:	72 06                	jb     801a9f <__umoddi3+0x113>
  801a99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a9d:	77 0f                	ja     801aae <__umoddi3+0x122>
  801a9f:	89 f2                	mov    %esi,%edx
  801aa1:	29 f9                	sub    %edi,%ecx
  801aa3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801aa7:	89 14 24             	mov    %edx,(%esp)
  801aaa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aae:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ab2:	8b 14 24             	mov    (%esp),%edx
  801ab5:	83 c4 1c             	add    $0x1c,%esp
  801ab8:	5b                   	pop    %ebx
  801ab9:	5e                   	pop    %esi
  801aba:	5f                   	pop    %edi
  801abb:	5d                   	pop    %ebp
  801abc:	c3                   	ret    
  801abd:	8d 76 00             	lea    0x0(%esi),%esi
  801ac0:	2b 04 24             	sub    (%esp),%eax
  801ac3:	19 fa                	sbb    %edi,%edx
  801ac5:	89 d1                	mov    %edx,%ecx
  801ac7:	89 c6                	mov    %eax,%esi
  801ac9:	e9 71 ff ff ff       	jmp    801a3f <__umoddi3+0xb3>
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ad4:	72 ea                	jb     801ac0 <__umoddi3+0x134>
  801ad6:	89 d9                	mov    %ebx,%ecx
  801ad8:	e9 62 ff ff ff       	jmp    801a3f <__umoddi3+0xb3>
