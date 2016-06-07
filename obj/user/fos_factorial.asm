
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 95 00 00 00       	call   8000cb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 40 1a 80 00       	push   $0x801a40
  800057:	e8 64 09 00 00       	call   8009c0 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 b6 0d 00 00       	call   800e28 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Factorial %d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 57 1a 80 00       	push   $0x801a57
  800097:	e8 d1 01 00 00       	call   80026d <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <factorial>:


int factorial(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	83 ec 08             	sub    $0x8,%esp
	if (n <= 1)
  8000a8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ac:	7f 07                	jg     8000b5 <factorial+0x13>
		return 1 ;
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b3:	eb 14                	jmp    8000c9 <factorial+0x27>
	return n * factorial(n-1) ;
  8000b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b8:	48                   	dec    %eax
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	50                   	push   %eax
  8000bd:	e8 e0 ff ff ff       	call   8000a2 <factorial>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	0f af 45 08          	imul   0x8(%ebp),%eax
}
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000d5:	7e 0a                	jle    8000e1 <libmain+0x16>
		binaryname = argv[0];
  8000d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000da:	8b 00                	mov    (%eax),%eax
  8000dc:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000e1:	83 ec 08             	sub    $0x8,%esp
  8000e4:	ff 75 0c             	pushl  0xc(%ebp)
  8000e7:	ff 75 08             	pushl  0x8(%ebp)
  8000ea:	e8 49 ff ff ff       	call   800038 <_main>
  8000ef:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000f2:	e8 55 11 00 00       	call   80124c <sys_getenvid>
  8000f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8000fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fd:	89 d0                	mov    %edx,%eax
  8000ff:	c1 e0 03             	shl    $0x3,%eax
  800102:	01 d0                	add    %edx,%eax
  800104:	01 c0                	add    %eax,%eax
  800106:	01 d0                	add    %edx,%eax
  800108:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80010f:	01 d0                	add    %edx,%eax
  800111:	c1 e0 03             	shl    $0x3,%eax
  800114:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800119:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  80011c:	e8 79 12 00 00       	call   80139a <sys_disable_interrupt>
		cprintf("**************************************\n");
  800121:	83 ec 0c             	sub    $0xc,%esp
  800124:	68 84 1a 80 00       	push   $0x801a84
  800129:	e8 19 01 00 00       	call   800247 <cprintf>
  80012e:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800134:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	50                   	push   %eax
  80013e:	68 ac 1a 80 00       	push   $0x801aac
  800143:	e8 ff 00 00 00       	call   800247 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	68 84 1a 80 00       	push   $0x801a84
  800153:	e8 ef 00 00 00       	call   800247 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80015b:	e8 54 12 00 00       	call   8013b4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800160:	e8 19 00 00 00       	call   80017e <exit>
}
  800165:	90                   	nop
  800166:	c9                   	leave  
  800167:	c3                   	ret    

00800168 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	6a 00                	push   $0x0
  800173:	e8 b9 10 00 00       	call   801231 <sys_env_destroy>
  800178:	83 c4 10             	add    $0x10,%esp
}
  80017b:	90                   	nop
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    

0080017e <exit>:

void
exit(void)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800184:	e8 dc 10 00 00       	call   801265 <sys_env_exit>
}
  800189:	90                   	nop
  80018a:	c9                   	leave  
  80018b:	c3                   	ret    

0080018c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800192:	8b 45 0c             	mov    0xc(%ebp),%eax
  800195:	8b 00                	mov    (%eax),%eax
  800197:	8d 48 01             	lea    0x1(%eax),%ecx
  80019a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019d:	89 0a                	mov    %ecx,(%edx)
  80019f:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a2:	88 d1                	mov    %dl,%cl
  8001a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b5:	75 23                	jne    8001da <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8001b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ba:	8b 00                	mov    (%eax),%eax
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c1:	83 c0 08             	add    $0x8,%eax
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	52                   	push   %edx
  8001c8:	50                   	push   %eax
  8001c9:	e8 2d 10 00 00       	call   8011fb <sys_cputs>
  8001ce:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001dd:	8b 40 04             	mov    0x4(%eax),%eax
  8001e0:	8d 50 01             	lea    0x1(%eax),%edx
  8001e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001e9:	90                   	nop
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fc:	00 00 00 
	b.cnt = 0;
  8001ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800206:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800209:	ff 75 0c             	pushl  0xc(%ebp)
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	68 8c 01 80 00       	push   $0x80018c
  80021b:	e8 fa 01 00 00       	call   80041a <vprintfmt>
  800220:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800223:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	50                   	push   %eax
  80022d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800233:	83 c0 08             	add    $0x8,%eax
  800236:	50                   	push   %eax
  800237:	e8 bf 0f 00 00       	call   8011fb <sys_cputs>
  80023c:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80023f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <cprintf>:

int cprintf(const char *fmt, ...) {
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80024d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800250:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800253:	8b 45 08             	mov    0x8(%ebp),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	ff 75 f4             	pushl  -0xc(%ebp)
  80025c:	50                   	push   %eax
  80025d:	e8 8a ff ff ff       	call   8001ec <vcprintf>
  800262:	83 c4 10             	add    $0x10,%esp
  800265:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800268:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80026b:	c9                   	leave  
  80026c:	c3                   	ret    

0080026d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800273:	e8 22 11 00 00       	call   80139a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800278:	8d 45 0c             	lea    0xc(%ebp),%eax
  80027b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	83 ec 08             	sub    $0x8,%esp
  800284:	ff 75 f4             	pushl  -0xc(%ebp)
  800287:	50                   	push   %eax
  800288:	e8 5f ff ff ff       	call   8001ec <vcprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
  800290:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800293:	e8 1c 11 00 00       	call   8013b4 <sys_enable_interrupt>
	return cnt;
  800298:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	53                   	push   %ebx
  8002a1:	83 ec 14             	sub    $0x14,%esp
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b0:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002bb:	77 55                	ja     800312 <printnum+0x75>
  8002bd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002c0:	72 05                	jb     8002c7 <printnum+0x2a>
  8002c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002c5:	77 4b                	ja     800312 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002ca:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002cd:	8b 45 18             	mov    0x18(%ebp),%eax
  8002d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d5:	52                   	push   %edx
  8002d6:	50                   	push   %eax
  8002d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8002da:	ff 75 f0             	pushl  -0x10(%ebp)
  8002dd:	e8 f6 14 00 00       	call   8017d8 <__udivdi3>
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	83 ec 04             	sub    $0x4,%esp
  8002e8:	ff 75 20             	pushl  0x20(%ebp)
  8002eb:	53                   	push   %ebx
  8002ec:	ff 75 18             	pushl  0x18(%ebp)
  8002ef:	52                   	push   %edx
  8002f0:	50                   	push   %eax
  8002f1:	ff 75 0c             	pushl  0xc(%ebp)
  8002f4:	ff 75 08             	pushl  0x8(%ebp)
  8002f7:	e8 a1 ff ff ff       	call   80029d <printnum>
  8002fc:	83 c4 20             	add    $0x20,%esp
  8002ff:	eb 1a                	jmp    80031b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 20             	pushl  0x20(%ebp)
  80030a:	8b 45 08             	mov    0x8(%ebp),%eax
  80030d:	ff d0                	call   *%eax
  80030f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800312:	ff 4d 1c             	decl   0x1c(%ebp)
  800315:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800319:	7f e6                	jg     800301 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80031e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800326:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800329:	53                   	push   %ebx
  80032a:	51                   	push   %ecx
  80032b:	52                   	push   %edx
  80032c:	50                   	push   %eax
  80032d:	e8 b6 15 00 00       	call   8018e8 <__umoddi3>
  800332:	83 c4 10             	add    $0x10,%esp
  800335:	05 f4 1c 80 00       	add    $0x801cf4,%eax
  80033a:	8a 00                	mov    (%eax),%al
  80033c:	0f be c0             	movsbl %al,%eax
  80033f:	83 ec 08             	sub    $0x8,%esp
  800342:	ff 75 0c             	pushl  0xc(%ebp)
  800345:	50                   	push   %eax
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	ff d0                	call   *%eax
  80034b:	83 c4 10             	add    $0x10,%esp
}
  80034e:	90                   	nop
  80034f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800357:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80035b:	7e 1c                	jle    800379 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	8b 00                	mov    (%eax),%eax
  800362:	8d 50 08             	lea    0x8(%eax),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	89 10                	mov    %edx,(%eax)
  80036a:	8b 45 08             	mov    0x8(%ebp),%eax
  80036d:	8b 00                	mov    (%eax),%eax
  80036f:	83 e8 08             	sub    $0x8,%eax
  800372:	8b 50 04             	mov    0x4(%eax),%edx
  800375:	8b 00                	mov    (%eax),%eax
  800377:	eb 40                	jmp    8003b9 <getuint+0x65>
	else if (lflag)
  800379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80037d:	74 1e                	je     80039d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80037f:	8b 45 08             	mov    0x8(%ebp),%eax
  800382:	8b 00                	mov    (%eax),%eax
  800384:	8d 50 04             	lea    0x4(%eax),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	89 10                	mov    %edx,(%eax)
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	83 e8 04             	sub    $0x4,%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	ba 00 00 00 00       	mov    $0x0,%edx
  80039b:	eb 1c                	jmp    8003b9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	8d 50 04             	lea    0x4(%eax),%edx
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	89 10                	mov    %edx,(%eax)
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	83 e8 04             	sub    $0x4,%eax
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003b9:	5d                   	pop    %ebp
  8003ba:	c3                   	ret    

008003bb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003c2:	7e 1c                	jle    8003e0 <getint+0x25>
		return va_arg(*ap, long long);
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	8d 50 08             	lea    0x8(%eax),%edx
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	89 10                	mov    %edx,(%eax)
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	83 e8 08             	sub    $0x8,%eax
  8003d9:	8b 50 04             	mov    0x4(%eax),%edx
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	eb 38                	jmp    800418 <getint+0x5d>
	else if (lflag)
  8003e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003e4:	74 1a                	je     800400 <getint+0x45>
		return va_arg(*ap, long);
  8003e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e9:	8b 00                	mov    (%eax),%eax
  8003eb:	8d 50 04             	lea    0x4(%eax),%edx
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	89 10                	mov    %edx,(%eax)
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	8b 00                	mov    (%eax),%eax
  8003f8:	83 e8 04             	sub    $0x4,%eax
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	99                   	cltd   
  8003fe:	eb 18                	jmp    800418 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	8b 00                	mov    (%eax),%eax
  800405:	8d 50 04             	lea    0x4(%eax),%edx
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	89 10                	mov    %edx,(%eax)
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	83 e8 04             	sub    $0x4,%eax
  800415:	8b 00                	mov    (%eax),%eax
  800417:	99                   	cltd   
}
  800418:	5d                   	pop    %ebp
  800419:	c3                   	ret    

0080041a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	56                   	push   %esi
  80041e:	53                   	push   %ebx
  80041f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800422:	eb 17                	jmp    80043b <vprintfmt+0x21>
			if (ch == '\0')
  800424:	85 db                	test   %ebx,%ebx
  800426:	0f 84 af 03 00 00    	je     8007db <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	53                   	push   %ebx
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	ff d0                	call   *%eax
  800438:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	8d 50 01             	lea    0x1(%eax),%edx
  800441:	89 55 10             	mov    %edx,0x10(%ebp)
  800444:	8a 00                	mov    (%eax),%al
  800446:	0f b6 d8             	movzbl %al,%ebx
  800449:	83 fb 25             	cmp    $0x25,%ebx
  80044c:	75 d6                	jne    800424 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80044e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800452:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800459:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800460:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800467:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046e:	8b 45 10             	mov    0x10(%ebp),%eax
  800471:	8d 50 01             	lea    0x1(%eax),%edx
  800474:	89 55 10             	mov    %edx,0x10(%ebp)
  800477:	8a 00                	mov    (%eax),%al
  800479:	0f b6 d8             	movzbl %al,%ebx
  80047c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80047f:	83 f8 55             	cmp    $0x55,%eax
  800482:	0f 87 2b 03 00 00    	ja     8007b3 <vprintfmt+0x399>
  800488:	8b 04 85 18 1d 80 00 	mov    0x801d18(,%eax,4),%eax
  80048f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800491:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800495:	eb d7                	jmp    80046e <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800497:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80049b:	eb d1                	jmp    80046e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80049d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a7:	89 d0                	mov    %edx,%eax
  8004a9:	c1 e0 02             	shl    $0x2,%eax
  8004ac:	01 d0                	add    %edx,%eax
  8004ae:	01 c0                	add    %eax,%eax
  8004b0:	01 d8                	add    %ebx,%eax
  8004b2:	83 e8 30             	sub    $0x30,%eax
  8004b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bb:	8a 00                	mov    (%eax),%al
  8004bd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004c0:	83 fb 2f             	cmp    $0x2f,%ebx
  8004c3:	7e 3e                	jle    800503 <vprintfmt+0xe9>
  8004c5:	83 fb 39             	cmp    $0x39,%ebx
  8004c8:	7f 39                	jg     800503 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ca:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004cd:	eb d5                	jmp    8004a4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	83 c0 04             	add    $0x4,%eax
  8004d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	83 e8 04             	sub    $0x4,%eax
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004e3:	eb 1f                	jmp    800504 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8004e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004e9:	79 83                	jns    80046e <vprintfmt+0x54>
				width = 0;
  8004eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8004f2:	e9 77 ff ff ff       	jmp    80046e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8004f7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004fe:	e9 6b ff ff ff       	jmp    80046e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800503:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800504:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800508:	0f 89 60 ff ff ff    	jns    80046e <vprintfmt+0x54>
				width = precision, precision = -1;
  80050e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800511:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800514:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80051b:	e9 4e ff ff ff       	jmp    80046e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800520:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800523:	e9 46 ff ff ff       	jmp    80046e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800528:	8b 45 14             	mov    0x14(%ebp),%eax
  80052b:	83 c0 04             	add    $0x4,%eax
  80052e:	89 45 14             	mov    %eax,0x14(%ebp)
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	83 e8 04             	sub    $0x4,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 0c             	pushl  0xc(%ebp)
  80053f:	50                   	push   %eax
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	ff d0                	call   *%eax
  800545:	83 c4 10             	add    $0x10,%esp
			break;
  800548:	e9 89 02 00 00       	jmp    8007d6 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	83 c0 04             	add    $0x4,%eax
  800553:	89 45 14             	mov    %eax,0x14(%ebp)
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	83 e8 04             	sub    $0x4,%eax
  80055c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80055e:	85 db                	test   %ebx,%ebx
  800560:	79 02                	jns    800564 <vprintfmt+0x14a>
				err = -err;
  800562:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800564:	83 fb 64             	cmp    $0x64,%ebx
  800567:	7f 0b                	jg     800574 <vprintfmt+0x15a>
  800569:	8b 34 9d 60 1b 80 00 	mov    0x801b60(,%ebx,4),%esi
  800570:	85 f6                	test   %esi,%esi
  800572:	75 19                	jne    80058d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800574:	53                   	push   %ebx
  800575:	68 05 1d 80 00       	push   $0x801d05
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	e8 5e 02 00 00       	call   8007e3 <printfmt>
  800585:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800588:	e9 49 02 00 00       	jmp    8007d6 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80058d:	56                   	push   %esi
  80058e:	68 0e 1d 80 00       	push   $0x801d0e
  800593:	ff 75 0c             	pushl  0xc(%ebp)
  800596:	ff 75 08             	pushl  0x8(%ebp)
  800599:	e8 45 02 00 00       	call   8007e3 <printfmt>
  80059e:	83 c4 10             	add    $0x10,%esp
			break;
  8005a1:	e9 30 02 00 00       	jmp    8007d6 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	83 c0 04             	add    $0x4,%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	83 e8 04             	sub    $0x4,%eax
  8005b5:	8b 30                	mov    (%eax),%esi
  8005b7:	85 f6                	test   %esi,%esi
  8005b9:	75 05                	jne    8005c0 <vprintfmt+0x1a6>
				p = "(null)";
  8005bb:	be 11 1d 80 00       	mov    $0x801d11,%esi
			if (width > 0 && padc != '-')
  8005c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c4:	7e 6d                	jle    800633 <vprintfmt+0x219>
  8005c6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005ca:	74 67                	je     800633 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	50                   	push   %eax
  8005d3:	56                   	push   %esi
  8005d4:	e8 12 05 00 00       	call   800aeb <strnlen>
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005df:	eb 16                	jmp    8005f7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8005e1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	ff 75 0c             	pushl  0xc(%ebp)
  8005eb:	50                   	push   %eax
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	ff d0                	call   *%eax
  8005f1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f4:	ff 4d e4             	decl   -0x1c(%ebp)
  8005f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fb:	7f e4                	jg     8005e1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fd:	eb 34                	jmp    800633 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800603:	74 1c                	je     800621 <vprintfmt+0x207>
  800605:	83 fb 1f             	cmp    $0x1f,%ebx
  800608:	7e 05                	jle    80060f <vprintfmt+0x1f5>
  80060a:	83 fb 7e             	cmp    $0x7e,%ebx
  80060d:	7e 12                	jle    800621 <vprintfmt+0x207>
					putch('?', putdat);
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	6a 3f                	push   $0x3f
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	ff d0                	call   *%eax
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	eb 0f                	jmp    800630 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	ff 75 0c             	pushl  0xc(%ebp)
  800627:	53                   	push   %ebx
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	ff d0                	call   *%eax
  80062d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800630:	ff 4d e4             	decl   -0x1c(%ebp)
  800633:	89 f0                	mov    %esi,%eax
  800635:	8d 70 01             	lea    0x1(%eax),%esi
  800638:	8a 00                	mov    (%eax),%al
  80063a:	0f be d8             	movsbl %al,%ebx
  80063d:	85 db                	test   %ebx,%ebx
  80063f:	74 24                	je     800665 <vprintfmt+0x24b>
  800641:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800645:	78 b8                	js     8005ff <vprintfmt+0x1e5>
  800647:	ff 4d e0             	decl   -0x20(%ebp)
  80064a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80064e:	79 af                	jns    8005ff <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800650:	eb 13                	jmp    800665 <vprintfmt+0x24b>
				putch(' ', putdat);
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	ff 75 0c             	pushl  0xc(%ebp)
  800658:	6a 20                	push   $0x20
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	ff d0                	call   *%eax
  80065f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800662:	ff 4d e4             	decl   -0x1c(%ebp)
  800665:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800669:	7f e7                	jg     800652 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80066b:	e9 66 01 00 00       	jmp    8007d6 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 e8             	pushl  -0x18(%ebp)
  800676:	8d 45 14             	lea    0x14(%ebp),%eax
  800679:	50                   	push   %eax
  80067a:	e8 3c fd ff ff       	call   8003bb <getint>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800685:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80068b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80068e:	85 d2                	test   %edx,%edx
  800690:	79 23                	jns    8006b5 <vprintfmt+0x29b>
				putch('-', putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	6a 2d                	push   $0x2d
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	ff d0                	call   *%eax
  80069f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a8:	f7 d8                	neg    %eax
  8006aa:	83 d2 00             	adc    $0x0,%edx
  8006ad:	f7 da                	neg    %edx
  8006af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006bc:	e9 bc 00 00 00       	jmp    80077d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8006c7:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ca:	50                   	push   %eax
  8006cb:	e8 84 fc ff ff       	call   800354 <getuint>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006d9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006e0:	e9 98 00 00 00       	jmp    80077d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	ff 75 0c             	pushl  0xc(%ebp)
  8006eb:	6a 58                	push   $0x58
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	ff d0                	call   *%eax
  8006f2:	83 c4 10             	add    $0x10,%esp
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
			break;
  800715:	e9 bc 00 00 00       	jmp    8007d6 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	6a 30                	push   $0x30
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 0c             	pushl  0xc(%ebp)
  800730:	6a 78                	push   $0x78
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	83 c0 04             	add    $0x4,%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	83 e8 04             	sub    $0x4,%eax
  800749:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80074b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800755:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80075c:	eb 1f                	jmp    80077d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 e8             	pushl  -0x18(%ebp)
  800764:	8d 45 14             	lea    0x14(%ebp),%eax
  800767:	50                   	push   %eax
  800768:	e8 e7 fb ff ff       	call   800354 <getuint>
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800773:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800776:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80077d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800784:	83 ec 04             	sub    $0x4,%esp
  800787:	52                   	push   %edx
  800788:	ff 75 e4             	pushl  -0x1c(%ebp)
  80078b:	50                   	push   %eax
  80078c:	ff 75 f4             	pushl  -0xc(%ebp)
  80078f:	ff 75 f0             	pushl  -0x10(%ebp)
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	ff 75 08             	pushl  0x8(%ebp)
  800798:	e8 00 fb ff ff       	call   80029d <printnum>
  80079d:	83 c4 20             	add    $0x20,%esp
			break;
  8007a0:	eb 34                	jmp    8007d6 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	53                   	push   %ebx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
			break;
  8007b1:	eb 23                	jmp    8007d6 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	6a 25                	push   $0x25
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	ff d0                	call   *%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007c3:	ff 4d 10             	decl   0x10(%ebp)
  8007c6:	eb 03                	jmp    8007cb <vprintfmt+0x3b1>
  8007c8:	ff 4d 10             	decl   0x10(%ebp)
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	48                   	dec    %eax
  8007cf:	8a 00                	mov    (%eax),%al
  8007d1:	3c 25                	cmp    $0x25,%al
  8007d3:	75 f3                	jne    8007c8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007d5:	90                   	nop
		}
	}
  8007d6:	e9 47 fc ff ff       	jmp    800422 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007db:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007df:	5b                   	pop    %ebx
  8007e0:	5e                   	pop    %esi
  8007e1:	5d                   	pop    %ebp
  8007e2:	c3                   	ret    

008007e3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8007e9:	8d 45 10             	lea    0x10(%ebp),%eax
  8007ec:	83 c0 04             	add    $0x4,%eax
  8007ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8007f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f8:	50                   	push   %eax
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	ff 75 08             	pushl  0x8(%ebp)
  8007ff:	e8 16 fc ff ff       	call   80041a <vprintfmt>
  800804:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800807:	90                   	nop
  800808:	c9                   	leave  
  800809:	c3                   	ret    

0080080a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	8b 40 08             	mov    0x8(%eax),%eax
  800813:	8d 50 01             	lea    0x1(%eax),%edx
  800816:	8b 45 0c             	mov    0xc(%ebp),%eax
  800819:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80081c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081f:	8b 10                	mov    (%eax),%edx
  800821:	8b 45 0c             	mov    0xc(%ebp),%eax
  800824:	8b 40 04             	mov    0x4(%eax),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	73 12                	jae    80083d <sprintputch+0x33>
		*b->buf++ = ch;
  80082b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	8d 48 01             	lea    0x1(%eax),%ecx
  800833:	8b 55 0c             	mov    0xc(%ebp),%edx
  800836:	89 0a                	mov    %ecx,(%edx)
  800838:	8b 55 08             	mov    0x8(%ebp),%edx
  80083b:	88 10                	mov    %dl,(%eax)
}
  80083d:	90                   	nop
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80084c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800861:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800865:	74 06                	je     80086d <vsnprintf+0x2d>
  800867:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80086b:	7f 07                	jg     800874 <vsnprintf+0x34>
		return -E_INVAL;
  80086d:	b8 03 00 00 00       	mov    $0x3,%eax
  800872:	eb 20                	jmp    800894 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800874:	ff 75 14             	pushl  0x14(%ebp)
  800877:	ff 75 10             	pushl  0x10(%ebp)
  80087a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80087d:	50                   	push   %eax
  80087e:	68 0a 08 80 00       	push   $0x80080a
  800883:	e8 92 fb ff ff       	call   80041a <vprintfmt>
  800888:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80088b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800891:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800894:	c9                   	leave  
  800895:	c3                   	ret    

00800896 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089c:	8d 45 10             	lea    0x10(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	ff 75 08             	pushl  0x8(%ebp)
  8008b2:	e8 89 ff ff ff       	call   800840 <vsnprintf>
  8008b7:	83 c4 10             	add    $0x10,%esp
  8008ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    

008008c2 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8008c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008cc:	74 13                	je     8008e1 <readline+0x1f>
		cprintf("%s", prompt);
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	68 70 1e 80 00       	push   $0x801e70
  8008d9:	e8 69 f9 ff ff       	call   800247 <cprintf>
  8008de:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8008e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8008e8:	83 ec 0c             	sub    $0xc,%esp
  8008eb:	6a 00                	push   $0x0
  8008ed:	e8 da 0e 00 00       	call   8017cc <iscons>
  8008f2:	83 c4 10             	add    $0x10,%esp
  8008f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8008f8:	e8 81 0e 00 00       	call   80177e <getchar>
  8008fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800900:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800904:	79 22                	jns    800928 <readline+0x66>
			if (c != -E_EOF)
  800906:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80090a:	0f 84 ad 00 00 00    	je     8009bd <readline+0xfb>
				cprintf("read error: %e\n", c);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	ff 75 ec             	pushl  -0x14(%ebp)
  800916:	68 73 1e 80 00       	push   $0x801e73
  80091b:	e8 27 f9 ff ff       	call   800247 <cprintf>
  800920:	83 c4 10             	add    $0x10,%esp
			return;
  800923:	e9 95 00 00 00       	jmp    8009bd <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800928:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80092c:	7e 34                	jle    800962 <readline+0xa0>
  80092e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800935:	7f 2b                	jg     800962 <readline+0xa0>
			if (echoing)
  800937:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80093b:	74 0e                	je     80094b <readline+0x89>
				cputchar(c);
  80093d:	83 ec 0c             	sub    $0xc,%esp
  800940:	ff 75 ec             	pushl  -0x14(%ebp)
  800943:	e8 ee 0d 00 00       	call   801736 <cputchar>
  800948:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800954:	89 c2                	mov    %eax,%edx
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	01 d0                	add    %edx,%eax
  80095b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80095e:	88 10                	mov    %dl,(%eax)
  800960:	eb 56                	jmp    8009b8 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800962:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800966:	75 1f                	jne    800987 <readline+0xc5>
  800968:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80096c:	7e 19                	jle    800987 <readline+0xc5>
			if (echoing)
  80096e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800972:	74 0e                	je     800982 <readline+0xc0>
				cputchar(c);
  800974:	83 ec 0c             	sub    $0xc,%esp
  800977:	ff 75 ec             	pushl  -0x14(%ebp)
  80097a:	e8 b7 0d 00 00       	call   801736 <cputchar>
  80097f:	83 c4 10             	add    $0x10,%esp

			i--;
  800982:	ff 4d f4             	decl   -0xc(%ebp)
  800985:	eb 31                	jmp    8009b8 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800987:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80098b:	74 0a                	je     800997 <readline+0xd5>
  80098d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800991:	0f 85 61 ff ff ff    	jne    8008f8 <readline+0x36>
			if (echoing)
  800997:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80099b:	74 0e                	je     8009ab <readline+0xe9>
				cputchar(c);
  80099d:	83 ec 0c             	sub    $0xc,%esp
  8009a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8009a3:	e8 8e 0d 00 00       	call   801736 <cputchar>
  8009a8:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8009ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	01 d0                	add    %edx,%eax
  8009b3:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8009b6:	eb 06                	jmp    8009be <readline+0xfc>
		}
	}
  8009b8:	e9 3b ff ff ff       	jmp    8008f8 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8009bd:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8009be:	c9                   	leave  
  8009bf:	c3                   	ret    

008009c0 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c6:	e8 cf 09 00 00       	call   80139a <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8009cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cf:	74 13                	je     8009e4 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 08             	pushl  0x8(%ebp)
  8009d7:	68 70 1e 80 00       	push   $0x801e70
  8009dc:	e8 66 f8 ff ff       	call   800247 <cprintf>
  8009e1:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009eb:	83 ec 0c             	sub    $0xc,%esp
  8009ee:	6a 00                	push   $0x0
  8009f0:	e8 d7 0d 00 00       	call   8017cc <iscons>
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009fb:	e8 7e 0d 00 00       	call   80177e <getchar>
  800a00:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a07:	79 23                	jns    800a2c <atomic_readline+0x6c>
			if (c != -E_EOF)
  800a09:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a0d:	74 13                	je     800a22 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 ec             	pushl  -0x14(%ebp)
  800a15:	68 73 1e 80 00       	push   $0x801e73
  800a1a:	e8 28 f8 ff ff       	call   800247 <cprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800a22:	e8 8d 09 00 00       	call   8013b4 <sys_enable_interrupt>
			return;
  800a27:	e9 9a 00 00 00       	jmp    800ac6 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a2c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a30:	7e 34                	jle    800a66 <atomic_readline+0xa6>
  800a32:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a39:	7f 2b                	jg     800a66 <atomic_readline+0xa6>
			if (echoing)
  800a3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a3f:	74 0e                	je     800a4f <atomic_readline+0x8f>
				cputchar(c);
  800a41:	83 ec 0c             	sub    $0xc,%esp
  800a44:	ff 75 ec             	pushl  -0x14(%ebp)
  800a47:	e8 ea 0c 00 00       	call   801736 <cputchar>
  800a4c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a52:	8d 50 01             	lea    0x1(%eax),%edx
  800a55:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a58:	89 c2                	mov    %eax,%edx
  800a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a62:	88 10                	mov    %dl,(%eax)
  800a64:	eb 5b                	jmp    800ac1 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800a66:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a6a:	75 1f                	jne    800a8b <atomic_readline+0xcb>
  800a6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a70:	7e 19                	jle    800a8b <atomic_readline+0xcb>
			if (echoing)
  800a72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a76:	74 0e                	je     800a86 <atomic_readline+0xc6>
				cputchar(c);
  800a78:	83 ec 0c             	sub    $0xc,%esp
  800a7b:	ff 75 ec             	pushl  -0x14(%ebp)
  800a7e:	e8 b3 0c 00 00       	call   801736 <cputchar>
  800a83:	83 c4 10             	add    $0x10,%esp
			i--;
  800a86:	ff 4d f4             	decl   -0xc(%ebp)
  800a89:	eb 36                	jmp    800ac1 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800a8b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a8f:	74 0a                	je     800a9b <atomic_readline+0xdb>
  800a91:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a95:	0f 85 60 ff ff ff    	jne    8009fb <atomic_readline+0x3b>
			if (echoing)
  800a9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a9f:	74 0e                	je     800aaf <atomic_readline+0xef>
				cputchar(c);
  800aa1:	83 ec 0c             	sub    $0xc,%esp
  800aa4:	ff 75 ec             	pushl  -0x14(%ebp)
  800aa7:	e8 8a 0c 00 00       	call   801736 <cputchar>
  800aac:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab5:	01 d0                	add    %edx,%eax
  800ab7:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800aba:	e8 f5 08 00 00       	call   8013b4 <sys_enable_interrupt>
			return;
  800abf:	eb 05                	jmp    800ac6 <atomic_readline+0x106>
		}
	}
  800ac1:	e9 35 ff ff ff       	jmp    8009fb <atomic_readline+0x3b>
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ace:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ad5:	eb 06                	jmp    800add <strlen+0x15>
		n++;
  800ad7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ada:	ff 45 08             	incl   0x8(%ebp)
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	8a 00                	mov    (%eax),%al
  800ae2:	84 c0                	test   %al,%al
  800ae4:	75 f1                	jne    800ad7 <strlen+0xf>
		n++;
	return n;
  800ae6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ae9:	c9                   	leave  
  800aea:	c3                   	ret    

00800aeb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800af1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800af8:	eb 09                	jmp    800b03 <strnlen+0x18>
		n++;
  800afa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800afd:	ff 45 08             	incl   0x8(%ebp)
  800b00:	ff 4d 0c             	decl   0xc(%ebp)
  800b03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b07:	74 09                	je     800b12 <strnlen+0x27>
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8a 00                	mov    (%eax),%al
  800b0e:	84 c0                	test   %al,%al
  800b10:	75 e8                	jne    800afa <strnlen+0xf>
		n++;
	return n;
  800b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b15:	c9                   	leave  
  800b16:	c3                   	ret    

00800b17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b23:	90                   	nop
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8d 50 01             	lea    0x1(%eax),%edx
  800b2a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b33:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b36:	8a 12                	mov    (%edx),%dl
  800b38:	88 10                	mov    %dl,(%eax)
  800b3a:	8a 00                	mov    (%eax),%al
  800b3c:	84 c0                	test   %al,%al
  800b3e:	75 e4                	jne    800b24 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b40:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b58:	eb 1f                	jmp    800b79 <strncpy+0x34>
		*dst++ = *src;
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8d 50 01             	lea    0x1(%eax),%edx
  800b60:	89 55 08             	mov    %edx,0x8(%ebp)
  800b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b66:	8a 12                	mov    (%edx),%dl
  800b68:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	84 c0                	test   %al,%al
  800b71:	74 03                	je     800b76 <strncpy+0x31>
			src++;
  800b73:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b76:	ff 45 fc             	incl   -0x4(%ebp)
  800b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b7f:	72 d9                	jb     800b5a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b96:	74 30                	je     800bc8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b98:	eb 16                	jmp    800bb0 <strlcpy+0x2a>
			*dst++ = *src++;
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ba0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ba9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bac:	8a 12                	mov    (%edx),%dl
  800bae:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bb0:	ff 4d 10             	decl   0x10(%ebp)
  800bb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb7:	74 09                	je     800bc2 <strlcpy+0x3c>
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	8a 00                	mov    (%eax),%al
  800bbe:	84 c0                	test   %al,%al
  800bc0:	75 d8                	jne    800b9a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bce:	29 c2                	sub    %eax,%edx
  800bd0:	89 d0                	mov    %edx,%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bd7:	eb 06                	jmp    800bdf <strcmp+0xb>
		p++, q++;
  800bd9:	ff 45 08             	incl   0x8(%ebp)
  800bdc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	84 c0                	test   %al,%al
  800be6:	74 0e                	je     800bf6 <strcmp+0x22>
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 10                	mov    (%eax),%dl
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	38 c2                	cmp    %al,%dl
  800bf4:	74 e3                	je     800bd9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	0f b6 d0             	movzbl %al,%edx
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	0f b6 c0             	movzbl %al,%eax
  800c06:	29 c2                	sub    %eax,%edx
  800c08:	89 d0                	mov    %edx,%eax
}
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c0f:	eb 09                	jmp    800c1a <strncmp+0xe>
		n--, p++, q++;
  800c11:	ff 4d 10             	decl   0x10(%ebp)
  800c14:	ff 45 08             	incl   0x8(%ebp)
  800c17:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c1e:	74 17                	je     800c37 <strncmp+0x2b>
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8a 00                	mov    (%eax),%al
  800c25:	84 c0                	test   %al,%al
  800c27:	74 0e                	je     800c37 <strncmp+0x2b>
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 10                	mov    (%eax),%dl
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	38 c2                	cmp    %al,%dl
  800c35:	74 da                	je     800c11 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3b:	75 07                	jne    800c44 <strncmp+0x38>
		return 0;
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c42:	eb 14                	jmp    800c58 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	0f b6 d0             	movzbl %al,%edx
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	0f b6 c0             	movzbl %al,%eax
  800c54:	29 c2                	sub    %eax,%edx
  800c56:	89 d0                	mov    %edx,%eax
}
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 04             	sub    $0x4,%esp
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c66:	eb 12                	jmp    800c7a <strchr+0x20>
		if (*s == c)
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c70:	75 05                	jne    800c77 <strchr+0x1d>
			return (char *) s;
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	eb 11                	jmp    800c88 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c77:	ff 45 08             	incl   0x8(%ebp)
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	84 c0                	test   %al,%al
  800c81:	75 e5                	jne    800c68 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	83 ec 04             	sub    $0x4,%esp
  800c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c93:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c96:	eb 0d                	jmp    800ca5 <strfind+0x1b>
		if (*s == c)
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca0:	74 0e                	je     800cb0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	84 c0                	test   %al,%al
  800cac:	75 ea                	jne    800c98 <strfind+0xe>
  800cae:	eb 01                	jmp    800cb1 <strfind+0x27>
		if (*s == c)
			break;
  800cb0:	90                   	nop
	return (char *) s;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb4:	c9                   	leave  
  800cb5:	c3                   	ret    

00800cb6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cc8:	eb 0e                	jmp    800cd8 <memset+0x22>
		*p++ = c;
  800cca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccd:	8d 50 01             	lea    0x1(%eax),%edx
  800cd0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cd8:	ff 4d f8             	decl   -0x8(%ebp)
  800cdb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cdf:	79 e9                	jns    800cca <memset+0x14>
		*p++ = c;

	return v;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800cf8:	eb 16                	jmp    800d10 <memcpy+0x2a>
		*d++ = *s++;
  800cfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cfd:	8d 50 01             	lea    0x1(%eax),%edx
  800d00:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d09:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d0c:	8a 12                	mov    (%edx),%dl
  800d0e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d10:	8b 45 10             	mov    0x10(%ebp),%eax
  800d13:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d16:	89 55 10             	mov    %edx,0x10(%ebp)
  800d19:	85 c0                	test   %eax,%eax
  800d1b:	75 dd                	jne    800cfa <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d37:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d3a:	73 50                	jae    800d8c <memmove+0x6a>
  800d3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	01 d0                	add    %edx,%eax
  800d44:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d47:	76 43                	jbe    800d8c <memmove+0x6a>
		s += n;
  800d49:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d52:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d55:	eb 10                	jmp    800d67 <memmove+0x45>
			*--d = *--s;
  800d57:	ff 4d f8             	decl   -0x8(%ebp)
  800d5a:	ff 4d fc             	decl   -0x4(%ebp)
  800d5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d60:	8a 10                	mov    (%eax),%dl
  800d62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d65:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d70:	85 c0                	test   %eax,%eax
  800d72:	75 e3                	jne    800d57 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d74:	eb 23                	jmp    800d99 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d92:	89 55 10             	mov    %edx,0x10(%ebp)
  800d95:	85 c0                	test   %eax,%eax
  800d97:	75 dd                	jne    800d76 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800db0:	eb 2a                	jmp    800ddc <memcmp+0x3e>
		if (*s1 != *s2)
  800db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db5:	8a 10                	mov    (%eax),%dl
  800db7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	38 c2                	cmp    %al,%dl
  800dbe:	74 16                	je     800dd6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	0f b6 d0             	movzbl %al,%edx
  800dc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	0f b6 c0             	movzbl %al,%eax
  800dd0:	29 c2                	sub    %eax,%edx
  800dd2:	89 d0                	mov    %edx,%eax
  800dd4:	eb 18                	jmp    800dee <memcmp+0x50>
		s1++, s2++;
  800dd6:	ff 45 fc             	incl   -0x4(%ebp)
  800dd9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de2:	89 55 10             	mov    %edx,0x10(%ebp)
  800de5:	85 c0                	test   %eax,%eax
  800de7:	75 c9                	jne    800db2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfc:	01 d0                	add    %edx,%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e01:	eb 15                	jmp    800e18 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f b6 d0             	movzbl %al,%edx
  800e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0e:	0f b6 c0             	movzbl %al,%eax
  800e11:	39 c2                	cmp    %eax,%edx
  800e13:	74 0d                	je     800e22 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e15:	ff 45 08             	incl   0x8(%ebp)
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e1e:	72 e3                	jb     800e03 <memfind+0x13>
  800e20:	eb 01                	jmp    800e23 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e22:	90                   	nop
	return (void *) s;
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e35:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e3c:	eb 03                	jmp    800e41 <strtol+0x19>
		s++;
  800e3e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 20                	cmp    $0x20,%al
  800e48:	74 f4                	je     800e3e <strtol+0x16>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 09                	cmp    $0x9,%al
  800e51:	74 eb                	je     800e3e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	3c 2b                	cmp    $0x2b,%al
  800e5a:	75 05                	jne    800e61 <strtol+0x39>
		s++;
  800e5c:	ff 45 08             	incl   0x8(%ebp)
  800e5f:	eb 13                	jmp    800e74 <strtol+0x4c>
	else if (*s == '-')
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	3c 2d                	cmp    $0x2d,%al
  800e68:	75 0a                	jne    800e74 <strtol+0x4c>
		s++, neg = 1;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	74 06                	je     800e80 <strtol+0x58>
  800e7a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e7e:	75 20                	jne    800ea0 <strtol+0x78>
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	3c 30                	cmp    $0x30,%al
  800e87:	75 17                	jne    800ea0 <strtol+0x78>
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	40                   	inc    %eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3c 78                	cmp    $0x78,%al
  800e91:	75 0d                	jne    800ea0 <strtol+0x78>
		s += 2, base = 16;
  800e93:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e97:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e9e:	eb 28                	jmp    800ec8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ea0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea4:	75 15                	jne    800ebb <strtol+0x93>
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	3c 30                	cmp    $0x30,%al
  800ead:	75 0c                	jne    800ebb <strtol+0x93>
		s++, base = 8;
  800eaf:	ff 45 08             	incl   0x8(%ebp)
  800eb2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800eb9:	eb 0d                	jmp    800ec8 <strtol+0xa0>
	else if (base == 0)
  800ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebf:	75 07                	jne    800ec8 <strtol+0xa0>
		base = 10;
  800ec1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	3c 2f                	cmp    $0x2f,%al
  800ecf:	7e 19                	jle    800eea <strtol+0xc2>
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	3c 39                	cmp    $0x39,%al
  800ed8:	7f 10                	jg     800eea <strtol+0xc2>
			dig = *s - '0';
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	0f be c0             	movsbl %al,%eax
  800ee2:	83 e8 30             	sub    $0x30,%eax
  800ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ee8:	eb 42                	jmp    800f2c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	3c 60                	cmp    $0x60,%al
  800ef1:	7e 19                	jle    800f0c <strtol+0xe4>
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 7a                	cmp    $0x7a,%al
  800efa:	7f 10                	jg     800f0c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f be c0             	movsbl %al,%eax
  800f04:	83 e8 57             	sub    $0x57,%eax
  800f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f0a:	eb 20                	jmp    800f2c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	3c 40                	cmp    $0x40,%al
  800f13:	7e 39                	jle    800f4e <strtol+0x126>
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	3c 5a                	cmp    $0x5a,%al
  800f1c:	7f 30                	jg     800f4e <strtol+0x126>
			dig = *s - 'A' + 10;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	0f be c0             	movsbl %al,%eax
  800f26:	83 e8 37             	sub    $0x37,%eax
  800f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f2f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f32:	7d 19                	jge    800f4d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f34:	ff 45 08             	incl   0x8(%ebp)
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f3e:	89 c2                	mov    %eax,%edx
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	01 d0                	add    %edx,%eax
  800f45:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f48:	e9 7b ff ff ff       	jmp    800ec8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f4d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f52:	74 08                	je     800f5c <strtol+0x134>
		*endptr = (char *) s;
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f60:	74 07                	je     800f69 <strtol+0x141>
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	f7 d8                	neg    %eax
  800f67:	eb 03                	jmp    800f6c <strtol+0x144>
  800f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f6c:	c9                   	leave  
  800f6d:	c3                   	ret    

00800f6e <ltostr>:

void
ltostr(long value, char *str)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f7b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f86:	79 13                	jns    800f9b <ltostr+0x2d>
	{
		neg = 1;
  800f88:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f95:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f98:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fa3:	99                   	cltd   
  800fa4:	f7 f9                	idiv   %ecx
  800fa6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fac:	8d 50 01             	lea    0x1(%eax),%edx
  800faf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb2:	89 c2                	mov    %eax,%edx
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	01 d0                	add    %edx,%eax
  800fb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fbc:	83 c2 30             	add    $0x30,%edx
  800fbf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fc9:	f7 e9                	imul   %ecx
  800fcb:	c1 fa 02             	sar    $0x2,%edx
  800fce:	89 c8                	mov    %ecx,%eax
  800fd0:	c1 f8 1f             	sar    $0x1f,%eax
  800fd3:	29 c2                	sub    %eax,%edx
  800fd5:	89 d0                	mov    %edx,%eax
  800fd7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fdd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fe2:	f7 e9                	imul   %ecx
  800fe4:	c1 fa 02             	sar    $0x2,%edx
  800fe7:	89 c8                	mov    %ecx,%eax
  800fe9:	c1 f8 1f             	sar    $0x1f,%eax
  800fec:	29 c2                	sub    %eax,%edx
  800fee:	89 d0                	mov    %edx,%eax
  800ff0:	c1 e0 02             	shl    $0x2,%eax
  800ff3:	01 d0                	add    %edx,%eax
  800ff5:	01 c0                	add    %eax,%eax
  800ff7:	29 c1                	sub    %eax,%ecx
  800ff9:	89 ca                	mov    %ecx,%edx
  800ffb:	85 d2                	test   %edx,%edx
  800ffd:	75 9c                	jne    800f9b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801006:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801009:	48                   	dec    %eax
  80100a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80100d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801011:	74 3d                	je     801050 <ltostr+0xe2>
		start = 1 ;
  801013:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80101a:	eb 34                	jmp    801050 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80101c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	01 c2                	add    %eax,%edx
  801031:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	01 c8                	add    %ecx,%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80103d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c2                	add    %eax,%edx
  801045:	8a 45 eb             	mov    -0x15(%ebp),%al
  801048:	88 02                	mov    %al,(%edx)
		start++ ;
  80104a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80104d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801056:	7c c4                	jl     80101c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801058:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801063:	90                   	nop
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80106c:	ff 75 08             	pushl  0x8(%ebp)
  80106f:	e8 54 fa ff ff       	call   800ac8 <strlen>
  801074:	83 c4 04             	add    $0x4,%esp
  801077:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80107a:	ff 75 0c             	pushl  0xc(%ebp)
  80107d:	e8 46 fa ff ff       	call   800ac8 <strlen>
  801082:	83 c4 04             	add    $0x4,%esp
  801085:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801088:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80108f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801096:	eb 17                	jmp    8010af <strcconcat+0x49>
		final[s] = str1[s] ;
  801098:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109b:	8b 45 10             	mov    0x10(%ebp),%eax
  80109e:	01 c2                	add    %eax,%edx
  8010a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	01 c8                	add    %ecx,%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010ac:	ff 45 fc             	incl   -0x4(%ebp)
  8010af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b5:	7c e1                	jl     801098 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010c5:	eb 1f                	jmp    8010e6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8d 50 01             	lea    0x1(%eax),%edx
  8010cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010d0:	89 c2                	mov    %eax,%edx
  8010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d5:	01 c2                	add    %eax,%edx
  8010d7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	01 c8                	add    %ecx,%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010e3:	ff 45 f8             	incl   -0x8(%ebp)
  8010e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010ec:	7c d9                	jl     8010c7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	01 d0                	add    %edx,%eax
  8010f6:	c6 00 00             	movb   $0x0,(%eax)
}
  8010f9:	90                   	nop
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801108:	8b 45 14             	mov    0x14(%ebp),%eax
  80110b:	8b 00                	mov    (%eax),%eax
  80110d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80111f:	eb 0c                	jmp    80112d <strsplit+0x31>
			*string++ = 0;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	89 55 08             	mov    %edx,0x8(%ebp)
  80112a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	84 c0                	test   %al,%al
  801134:	74 18                	je     80114e <strsplit+0x52>
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	0f be c0             	movsbl %al,%eax
  80113e:	50                   	push   %eax
  80113f:	ff 75 0c             	pushl  0xc(%ebp)
  801142:	e8 13 fb ff ff       	call   800c5a <strchr>
  801147:	83 c4 08             	add    $0x8,%esp
  80114a:	85 c0                	test   %eax,%eax
  80114c:	75 d3                	jne    801121 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	84 c0                	test   %al,%al
  801155:	74 5a                	je     8011b1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801157:	8b 45 14             	mov    0x14(%ebp),%eax
  80115a:	8b 00                	mov    (%eax),%eax
  80115c:	83 f8 0f             	cmp    $0xf,%eax
  80115f:	75 07                	jne    801168 <strsplit+0x6c>
		{
			return 0;
  801161:	b8 00 00 00 00       	mov    $0x0,%eax
  801166:	eb 66                	jmp    8011ce <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	8b 00                	mov    (%eax),%eax
  80116d:	8d 48 01             	lea    0x1(%eax),%ecx
  801170:	8b 55 14             	mov    0x14(%ebp),%edx
  801173:	89 0a                	mov    %ecx,(%edx)
  801175:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	01 c2                	add    %eax,%edx
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801186:	eb 03                	jmp    80118b <strsplit+0x8f>
			string++;
  801188:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	84 c0                	test   %al,%al
  801192:	74 8b                	je     80111f <strsplit+0x23>
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f be c0             	movsbl %al,%eax
  80119c:	50                   	push   %eax
  80119d:	ff 75 0c             	pushl  0xc(%ebp)
  8011a0:	e8 b5 fa ff ff       	call   800c5a <strchr>
  8011a5:	83 c4 08             	add    $0x8,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	74 dc                	je     801188 <strsplit+0x8c>
			string++;
	}
  8011ac:	e9 6e ff ff ff       	jmp    80111f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011b1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b5:	8b 00                	mov    (%eax),%eax
  8011b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	01 d0                	add    %edx,%eax
  8011c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	57                   	push   %edi
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011e5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011e8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011eb:	cd 30                	int    $0x30
  8011ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8011f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	5b                   	pop    %ebx
  8011f7:	5e                   	pop    %esi
  8011f8:	5f                   	pop    %edi
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    

008011fb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	6a 00                	push   $0x0
  801207:	ff 75 0c             	pushl  0xc(%ebp)
  80120a:	50                   	push   %eax
  80120b:	6a 00                	push   $0x0
  80120d:	e8 be ff ff ff       	call   8011d0 <syscall>
  801212:	83 c4 18             	add    $0x18,%esp
}
  801215:	90                   	nop
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <sys_cgetc>:

int
sys_cgetc(void)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80121b:	6a 00                	push   $0x0
  80121d:	6a 00                	push   $0x0
  80121f:	6a 00                	push   $0x0
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 01                	push   $0x1
  801227:	e8 a4 ff ff ff       	call   8011d0 <syscall>
  80122c:	83 c4 18             	add    $0x18,%esp
}
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	50                   	push   %eax
  801240:	6a 03                	push   $0x3
  801242:	e8 89 ff ff ff       	call   8011d0 <syscall>
  801247:	83 c4 18             	add    $0x18,%esp
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	6a 00                	push   $0x0
  801259:	6a 02                	push   $0x2
  80125b:	e8 70 ff ff ff       	call   8011d0 <syscall>
  801260:	83 c4 18             	add    $0x18,%esp
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <sys_env_exit>:

void sys_env_exit(void)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 04                	push   $0x4
  801274:	e8 57 ff ff ff       	call   8011d0 <syscall>
  801279:	83 c4 18             	add    $0x18,%esp
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801282:	8b 55 0c             	mov    0xc(%ebp),%edx
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	6a 00                	push   $0x0
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	52                   	push   %edx
  80128f:	50                   	push   %eax
  801290:	6a 05                	push   $0x5
  801292:	e8 39 ff ff ff       	call   8011d0 <syscall>
  801297:	83 c4 18             	add    $0x18,%esp
}
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	56                   	push   %esi
  8012a0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8012a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
  8012b2:	51                   	push   %ecx
  8012b3:	52                   	push   %edx
  8012b4:	50                   	push   %eax
  8012b5:	6a 06                	push   $0x6
  8012b7:	e8 14 ff ff ff       	call   8011d0 <syscall>
  8012bc:	83 c4 18             	add    $0x18,%esp
}
  8012bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    

008012c6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	52                   	push   %edx
  8012d6:	50                   	push   %eax
  8012d7:	6a 07                	push   $0x7
  8012d9:	e8 f2 fe ff ff       	call   8011d0 <syscall>
  8012de:	83 c4 18             	add    $0x18,%esp
}
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	ff 75 0c             	pushl  0xc(%ebp)
  8012ef:	ff 75 08             	pushl  0x8(%ebp)
  8012f2:	6a 08                	push   $0x8
  8012f4:	e8 d7 fe ff ff       	call   8011d0 <syscall>
  8012f9:	83 c4 18             	add    $0x18,%esp
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 09                	push   $0x9
  80130d:	e8 be fe ff ff       	call   8011d0 <syscall>
  801312:	83 c4 18             	add    $0x18,%esp
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 0a                	push   $0xa
  801326:	e8 a5 fe ff ff       	call   8011d0 <syscall>
  80132b:	83 c4 18             	add    $0x18,%esp
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 0b                	push   $0xb
  80133f:	e8 8c fe ff ff       	call   8011d0 <syscall>
  801344:	83 c4 18             	add    $0x18,%esp
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	ff 75 0c             	pushl  0xc(%ebp)
  801355:	ff 75 08             	pushl  0x8(%ebp)
  801358:	6a 0d                	push   $0xd
  80135a:	e8 71 fe ff ff       	call   8011d0 <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
	return;
  801362:	90                   	nop
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	ff 75 0c             	pushl  0xc(%ebp)
  801371:	ff 75 08             	pushl  0x8(%ebp)
  801374:	6a 0e                	push   $0xe
  801376:	e8 55 fe ff ff       	call   8011d0 <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
	return ;
  80137e:	90                   	nop
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 0c                	push   $0xc
  801390:	e8 3b fe ff ff       	call   8011d0 <syscall>
  801395:	83 c4 18             	add    $0x18,%esp
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 10                	push   $0x10
  8013a9:	e8 22 fe ff ff       	call   8011d0 <syscall>
  8013ae:	83 c4 18             	add    $0x18,%esp
}
  8013b1:	90                   	nop
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 11                	push   $0x11
  8013c3:	e8 08 fe ff ff       	call   8011d0 <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
}
  8013cb:	90                   	nop
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <sys_cputc>:


void
sys_cputc(const char c)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 04             	sub    $0x4,%esp
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013da:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	50                   	push   %eax
  8013e7:	6a 12                	push   $0x12
  8013e9:	e8 e2 fd ff ff       	call   8011d0 <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
}
  8013f1:	90                   	nop
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 13                	push   $0x13
  801403:	e8 c8 fd ff ff       	call   8011d0 <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	90                   	nop
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	ff 75 0c             	pushl  0xc(%ebp)
  80141d:	50                   	push   %eax
  80141e:	6a 14                	push   $0x14
  801420:	e8 ab fd ff ff       	call   8011d0 <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	50                   	push   %eax
  801439:	6a 17                	push   $0x17
  80143b:	e8 90 fd ff ff       	call   8011d0 <syscall>
  801440:	83 c4 18             	add    $0x18,%esp
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	50                   	push   %eax
  801454:	6a 15                	push   $0x15
  801456:	e8 75 fd ff ff       	call   8011d0 <syscall>
  80145b:	83 c4 18             	add    $0x18,%esp
}
  80145e:	90                   	nop
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	50                   	push   %eax
  801470:	6a 16                	push   $0x16
  801472:	e8 59 fd ff ff       	call   8011d0 <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
}
  80147a:	90                   	nop
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801489:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80148c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	6a 00                	push   $0x0
  801495:	51                   	push   %ecx
  801496:	52                   	push   %edx
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	50                   	push   %eax
  80149b:	6a 18                	push   $0x18
  80149d:	e8 2e fd ff ff       	call   8011d0 <syscall>
  8014a2:	83 c4 18             	add    $0x18,%esp
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8014aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	52                   	push   %edx
  8014b7:	50                   	push   %eax
  8014b8:	6a 19                	push   $0x19
  8014ba:	e8 11 fd ff ff       	call   8011d0 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	50                   	push   %eax
  8014d3:	6a 1a                	push   $0x1a
  8014d5:	e8 f6 fc ff ff       	call   8011d0 <syscall>
  8014da:	83 c4 18             	add    $0x18,%esp
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 1b                	push   $0x1b
  8014ee:	e8 dd fc ff ff       	call   8011d0 <syscall>
  8014f3:	83 c4 18             	add    $0x18,%esp
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 1c                	push   $0x1c
  801507:	e8 c4 fc ff ff       	call   8011d0 <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	50                   	push   %eax
  801521:	6a 1d                	push   $0x1d
  801523:	e8 a8 fc ff ff       	call   8011d0 <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	50                   	push   %eax
  80153c:	6a 1e                	push   $0x1e
  80153e:	e8 8d fc ff ff       	call   8011d0 <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
}
  801546:	90                   	nop
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	50                   	push   %eax
  801558:	6a 1f                	push   $0x1f
  80155a:	e8 71 fc ff ff       	call   8011d0 <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	90                   	nop
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80156b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80156e:	8d 50 04             	lea    0x4(%eax),%edx
  801571:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	52                   	push   %edx
  80157b:	50                   	push   %eax
  80157c:	6a 20                	push   $0x20
  80157e:	e8 4d fc ff ff       	call   8011d0 <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
	return result;
  801586:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801589:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158f:	89 01                	mov    %eax,(%ecx)
  801591:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	c9                   	leave  
  801598:	c2 04 00             	ret    $0x4

0080159b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	ff 75 10             	pushl  0x10(%ebp)
  8015a5:	ff 75 0c             	pushl  0xc(%ebp)
  8015a8:	ff 75 08             	pushl  0x8(%ebp)
  8015ab:	6a 0f                	push   $0xf
  8015ad:	e8 1e fc ff ff       	call   8011d0 <syscall>
  8015b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b5:	90                   	nop
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 21                	push   $0x21
  8015c7:	e8 04 fc ff ff       	call   8011d0 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015dd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	50                   	push   %eax
  8015ea:	6a 22                	push   $0x22
  8015ec:	e8 df fb ff ff       	call   8011d0 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f4:	90                   	nop
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <rsttst>:
void rsttst()
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 24                	push   $0x24
  801606:	e8 c5 fb ff ff       	call   8011d0 <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
	return ;
  80160e:	90                   	nop
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	8b 45 14             	mov    0x14(%ebp),%eax
  80161a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80161d:	8b 55 18             	mov    0x18(%ebp),%edx
  801620:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801624:	52                   	push   %edx
  801625:	50                   	push   %eax
  801626:	ff 75 10             	pushl  0x10(%ebp)
  801629:	ff 75 0c             	pushl  0xc(%ebp)
  80162c:	ff 75 08             	pushl  0x8(%ebp)
  80162f:	6a 23                	push   $0x23
  801631:	e8 9a fb ff ff       	call   8011d0 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
	return ;
  801639:	90                   	nop
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <chktst>:
void chktst(uint32 n)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	ff 75 08             	pushl  0x8(%ebp)
  80164a:	6a 25                	push   $0x25
  80164c:	e8 7f fb ff ff       	call   8011d0 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
	return ;
  801654:	90                   	nop
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 26                	push   $0x26
  801669:	e8 62 fb ff ff       	call   8011d0 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
  801671:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801674:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801678:	75 07                	jne    801681 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80167a:	b8 01 00 00 00       	mov    $0x1,%eax
  80167f:	eb 05                	jmp    801686 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801681:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 26                	push   $0x26
  80169a:	e8 31 fb ff ff       	call   8011d0 <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
  8016a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016a5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016a9:	75 07                	jne    8016b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b0:	eb 05                	jmp    8016b7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 26                	push   $0x26
  8016cb:	e8 00 fb ff ff       	call   8011d0 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
  8016d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016d6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016da:	75 07                	jne    8016e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e1:	eb 05                	jmp    8016e8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 26                	push   $0x26
  8016fc:	e8 cf fa ff ff       	call   8011d0 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
  801704:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801707:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80170b:	75 07                	jne    801714 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80170d:	b8 01 00 00 00       	mov    $0x1,%eax
  801712:	eb 05                	jmp    801719 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	ff 75 08             	pushl  0x8(%ebp)
  801729:	6a 27                	push   $0x27
  80172b:	e8 a0 fa ff ff       	call   8011d0 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
	return ;
  801733:	90                   	nop
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801742:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	50                   	push   %eax
  80174a:	e8 7f fc ff ff       	call   8013ce <sys_cputc>
  80174f:	83 c4 10             	add    $0x10,%esp
}
  801752:	90                   	nop
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80175b:	e8 3a fc ff ff       	call   80139a <sys_disable_interrupt>
	char c = ch;
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801766:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80176a:	83 ec 0c             	sub    $0xc,%esp
  80176d:	50                   	push   %eax
  80176e:	e8 5b fc ff ff       	call   8013ce <sys_cputc>
  801773:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801776:	e8 39 fc ff ff       	call   8013b4 <sys_enable_interrupt>
}
  80177b:	90                   	nop
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <getchar>:

int
getchar(void)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801784:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80178b:	eb 08                	jmp    801795 <getchar+0x17>
	{
		c = sys_cgetc();
  80178d:	e8 86 fa ff ff       	call   801218 <sys_cgetc>
  801792:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801799:	74 f2                	je     80178d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <atomic_getchar>:

int
atomic_getchar(void)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8017a6:	e8 ef fb ff ff       	call   80139a <sys_disable_interrupt>
	int c=0;
  8017ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8017b2:	eb 08                	jmp    8017bc <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8017b4:	e8 5f fa ff ff       	call   801218 <sys_cgetc>
  8017b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8017bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c0:	74 f2                	je     8017b4 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8017c2:	e8 ed fb ff ff       	call   8013b4 <sys_enable_interrupt>
	return c;
  8017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <iscons>:

int iscons(int fdnum)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8017cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    
  8017d6:	66 90                	xchg   %ax,%ax

008017d8 <__udivdi3>:
  8017d8:	55                   	push   %ebp
  8017d9:	57                   	push   %edi
  8017da:	56                   	push   %esi
  8017db:	53                   	push   %ebx
  8017dc:	83 ec 1c             	sub    $0x1c,%esp
  8017df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8017e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8017e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ef:	89 ca                	mov    %ecx,%edx
  8017f1:	89 f8                	mov    %edi,%eax
  8017f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8017f7:	85 f6                	test   %esi,%esi
  8017f9:	75 2d                	jne    801828 <__udivdi3+0x50>
  8017fb:	39 cf                	cmp    %ecx,%edi
  8017fd:	77 65                	ja     801864 <__udivdi3+0x8c>
  8017ff:	89 fd                	mov    %edi,%ebp
  801801:	85 ff                	test   %edi,%edi
  801803:	75 0b                	jne    801810 <__udivdi3+0x38>
  801805:	b8 01 00 00 00       	mov    $0x1,%eax
  80180a:	31 d2                	xor    %edx,%edx
  80180c:	f7 f7                	div    %edi
  80180e:	89 c5                	mov    %eax,%ebp
  801810:	31 d2                	xor    %edx,%edx
  801812:	89 c8                	mov    %ecx,%eax
  801814:	f7 f5                	div    %ebp
  801816:	89 c1                	mov    %eax,%ecx
  801818:	89 d8                	mov    %ebx,%eax
  80181a:	f7 f5                	div    %ebp
  80181c:	89 cf                	mov    %ecx,%edi
  80181e:	89 fa                	mov    %edi,%edx
  801820:	83 c4 1c             	add    $0x1c,%esp
  801823:	5b                   	pop    %ebx
  801824:	5e                   	pop    %esi
  801825:	5f                   	pop    %edi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    
  801828:	39 ce                	cmp    %ecx,%esi
  80182a:	77 28                	ja     801854 <__udivdi3+0x7c>
  80182c:	0f bd fe             	bsr    %esi,%edi
  80182f:	83 f7 1f             	xor    $0x1f,%edi
  801832:	75 40                	jne    801874 <__udivdi3+0x9c>
  801834:	39 ce                	cmp    %ecx,%esi
  801836:	72 0a                	jb     801842 <__udivdi3+0x6a>
  801838:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80183c:	0f 87 9e 00 00 00    	ja     8018e0 <__udivdi3+0x108>
  801842:	b8 01 00 00 00       	mov    $0x1,%eax
  801847:	89 fa                	mov    %edi,%edx
  801849:	83 c4 1c             	add    $0x1c,%esp
  80184c:	5b                   	pop    %ebx
  80184d:	5e                   	pop    %esi
  80184e:	5f                   	pop    %edi
  80184f:	5d                   	pop    %ebp
  801850:	c3                   	ret    
  801851:	8d 76 00             	lea    0x0(%esi),%esi
  801854:	31 ff                	xor    %edi,%edi
  801856:	31 c0                	xor    %eax,%eax
  801858:	89 fa                	mov    %edi,%edx
  80185a:	83 c4 1c             	add    $0x1c,%esp
  80185d:	5b                   	pop    %ebx
  80185e:	5e                   	pop    %esi
  80185f:	5f                   	pop    %edi
  801860:	5d                   	pop    %ebp
  801861:	c3                   	ret    
  801862:	66 90                	xchg   %ax,%ax
  801864:	89 d8                	mov    %ebx,%eax
  801866:	f7 f7                	div    %edi
  801868:	31 ff                	xor    %edi,%edi
  80186a:	89 fa                	mov    %edi,%edx
  80186c:	83 c4 1c             	add    $0x1c,%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5f                   	pop    %edi
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    
  801874:	bd 20 00 00 00       	mov    $0x20,%ebp
  801879:	89 eb                	mov    %ebp,%ebx
  80187b:	29 fb                	sub    %edi,%ebx
  80187d:	89 f9                	mov    %edi,%ecx
  80187f:	d3 e6                	shl    %cl,%esi
  801881:	89 c5                	mov    %eax,%ebp
  801883:	88 d9                	mov    %bl,%cl
  801885:	d3 ed                	shr    %cl,%ebp
  801887:	89 e9                	mov    %ebp,%ecx
  801889:	09 f1                	or     %esi,%ecx
  80188b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80188f:	89 f9                	mov    %edi,%ecx
  801891:	d3 e0                	shl    %cl,%eax
  801893:	89 c5                	mov    %eax,%ebp
  801895:	89 d6                	mov    %edx,%esi
  801897:	88 d9                	mov    %bl,%cl
  801899:	d3 ee                	shr    %cl,%esi
  80189b:	89 f9                	mov    %edi,%ecx
  80189d:	d3 e2                	shl    %cl,%edx
  80189f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018a3:	88 d9                	mov    %bl,%cl
  8018a5:	d3 e8                	shr    %cl,%eax
  8018a7:	09 c2                	or     %eax,%edx
  8018a9:	89 d0                	mov    %edx,%eax
  8018ab:	89 f2                	mov    %esi,%edx
  8018ad:	f7 74 24 0c          	divl   0xc(%esp)
  8018b1:	89 d6                	mov    %edx,%esi
  8018b3:	89 c3                	mov    %eax,%ebx
  8018b5:	f7 e5                	mul    %ebp
  8018b7:	39 d6                	cmp    %edx,%esi
  8018b9:	72 19                	jb     8018d4 <__udivdi3+0xfc>
  8018bb:	74 0b                	je     8018c8 <__udivdi3+0xf0>
  8018bd:	89 d8                	mov    %ebx,%eax
  8018bf:	31 ff                	xor    %edi,%edi
  8018c1:	e9 58 ff ff ff       	jmp    80181e <__udivdi3+0x46>
  8018c6:	66 90                	xchg   %ax,%ax
  8018c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8018cc:	89 f9                	mov    %edi,%ecx
  8018ce:	d3 e2                	shl    %cl,%edx
  8018d0:	39 c2                	cmp    %eax,%edx
  8018d2:	73 e9                	jae    8018bd <__udivdi3+0xe5>
  8018d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8018d7:	31 ff                	xor    %edi,%edi
  8018d9:	e9 40 ff ff ff       	jmp    80181e <__udivdi3+0x46>
  8018de:	66 90                	xchg   %ax,%ax
  8018e0:	31 c0                	xor    %eax,%eax
  8018e2:	e9 37 ff ff ff       	jmp    80181e <__udivdi3+0x46>
  8018e7:	90                   	nop

008018e8 <__umoddi3>:
  8018e8:	55                   	push   %ebp
  8018e9:	57                   	push   %edi
  8018ea:	56                   	push   %esi
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 1c             	sub    $0x1c,%esp
  8018ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8018f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8018f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8018ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801903:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801907:	89 f3                	mov    %esi,%ebx
  801909:	89 fa                	mov    %edi,%edx
  80190b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80190f:	89 34 24             	mov    %esi,(%esp)
  801912:	85 c0                	test   %eax,%eax
  801914:	75 1a                	jne    801930 <__umoddi3+0x48>
  801916:	39 f7                	cmp    %esi,%edi
  801918:	0f 86 a2 00 00 00    	jbe    8019c0 <__umoddi3+0xd8>
  80191e:	89 c8                	mov    %ecx,%eax
  801920:	89 f2                	mov    %esi,%edx
  801922:	f7 f7                	div    %edi
  801924:	89 d0                	mov    %edx,%eax
  801926:	31 d2                	xor    %edx,%edx
  801928:	83 c4 1c             	add    $0x1c,%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5e                   	pop    %esi
  80192d:	5f                   	pop    %edi
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    
  801930:	39 f0                	cmp    %esi,%eax
  801932:	0f 87 ac 00 00 00    	ja     8019e4 <__umoddi3+0xfc>
  801938:	0f bd e8             	bsr    %eax,%ebp
  80193b:	83 f5 1f             	xor    $0x1f,%ebp
  80193e:	0f 84 ac 00 00 00    	je     8019f0 <__umoddi3+0x108>
  801944:	bf 20 00 00 00       	mov    $0x20,%edi
  801949:	29 ef                	sub    %ebp,%edi
  80194b:	89 fe                	mov    %edi,%esi
  80194d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801951:	89 e9                	mov    %ebp,%ecx
  801953:	d3 e0                	shl    %cl,%eax
  801955:	89 d7                	mov    %edx,%edi
  801957:	89 f1                	mov    %esi,%ecx
  801959:	d3 ef                	shr    %cl,%edi
  80195b:	09 c7                	or     %eax,%edi
  80195d:	89 e9                	mov    %ebp,%ecx
  80195f:	d3 e2                	shl    %cl,%edx
  801961:	89 14 24             	mov    %edx,(%esp)
  801964:	89 d8                	mov    %ebx,%eax
  801966:	d3 e0                	shl    %cl,%eax
  801968:	89 c2                	mov    %eax,%edx
  80196a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80196e:	d3 e0                	shl    %cl,%eax
  801970:	89 44 24 04          	mov    %eax,0x4(%esp)
  801974:	8b 44 24 08          	mov    0x8(%esp),%eax
  801978:	89 f1                	mov    %esi,%ecx
  80197a:	d3 e8                	shr    %cl,%eax
  80197c:	09 d0                	or     %edx,%eax
  80197e:	d3 eb                	shr    %cl,%ebx
  801980:	89 da                	mov    %ebx,%edx
  801982:	f7 f7                	div    %edi
  801984:	89 d3                	mov    %edx,%ebx
  801986:	f7 24 24             	mull   (%esp)
  801989:	89 c6                	mov    %eax,%esi
  80198b:	89 d1                	mov    %edx,%ecx
  80198d:	39 d3                	cmp    %edx,%ebx
  80198f:	0f 82 87 00 00 00    	jb     801a1c <__umoddi3+0x134>
  801995:	0f 84 91 00 00 00    	je     801a2c <__umoddi3+0x144>
  80199b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80199f:	29 f2                	sub    %esi,%edx
  8019a1:	19 cb                	sbb    %ecx,%ebx
  8019a3:	89 d8                	mov    %ebx,%eax
  8019a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019a9:	d3 e0                	shl    %cl,%eax
  8019ab:	89 e9                	mov    %ebp,%ecx
  8019ad:	d3 ea                	shr    %cl,%edx
  8019af:	09 d0                	or     %edx,%eax
  8019b1:	89 e9                	mov    %ebp,%ecx
  8019b3:	d3 eb                	shr    %cl,%ebx
  8019b5:	89 da                	mov    %ebx,%edx
  8019b7:	83 c4 1c             	add    $0x1c,%esp
  8019ba:	5b                   	pop    %ebx
  8019bb:	5e                   	pop    %esi
  8019bc:	5f                   	pop    %edi
  8019bd:	5d                   	pop    %ebp
  8019be:	c3                   	ret    
  8019bf:	90                   	nop
  8019c0:	89 fd                	mov    %edi,%ebp
  8019c2:	85 ff                	test   %edi,%edi
  8019c4:	75 0b                	jne    8019d1 <__umoddi3+0xe9>
  8019c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cb:	31 d2                	xor    %edx,%edx
  8019cd:	f7 f7                	div    %edi
  8019cf:	89 c5                	mov    %eax,%ebp
  8019d1:	89 f0                	mov    %esi,%eax
  8019d3:	31 d2                	xor    %edx,%edx
  8019d5:	f7 f5                	div    %ebp
  8019d7:	89 c8                	mov    %ecx,%eax
  8019d9:	f7 f5                	div    %ebp
  8019db:	89 d0                	mov    %edx,%eax
  8019dd:	e9 44 ff ff ff       	jmp    801926 <__umoddi3+0x3e>
  8019e2:	66 90                	xchg   %ax,%ax
  8019e4:	89 c8                	mov    %ecx,%eax
  8019e6:	89 f2                	mov    %esi,%edx
  8019e8:	83 c4 1c             	add    $0x1c,%esp
  8019eb:	5b                   	pop    %ebx
  8019ec:	5e                   	pop    %esi
  8019ed:	5f                   	pop    %edi
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    
  8019f0:	3b 04 24             	cmp    (%esp),%eax
  8019f3:	72 06                	jb     8019fb <__umoddi3+0x113>
  8019f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8019f9:	77 0f                	ja     801a0a <__umoddi3+0x122>
  8019fb:	89 f2                	mov    %esi,%edx
  8019fd:	29 f9                	sub    %edi,%ecx
  8019ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a03:	89 14 24             	mov    %edx,(%esp)
  801a06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a0e:	8b 14 24             	mov    (%esp),%edx
  801a11:	83 c4 1c             	add    $0x1c,%esp
  801a14:	5b                   	pop    %ebx
  801a15:	5e                   	pop    %esi
  801a16:	5f                   	pop    %edi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    
  801a19:	8d 76 00             	lea    0x0(%esi),%esi
  801a1c:	2b 04 24             	sub    (%esp),%eax
  801a1f:	19 fa                	sbb    %edi,%edx
  801a21:	89 d1                	mov    %edx,%ecx
  801a23:	89 c6                	mov    %eax,%esi
  801a25:	e9 71 ff ff ff       	jmp    80199b <__umoddi3+0xb3>
  801a2a:	66 90                	xchg   %ax,%ax
  801a2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a30:	72 ea                	jb     801a1c <__umoddi3+0x134>
  801a32:	89 d9                	mov    %ebx,%ecx
  801a34:	e9 62 ff ff ff       	jmp    80199b <__umoddi3+0xb3>
