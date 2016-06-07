
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 20 17 80 00       	push   $0x801720
  800049:	e8 a8 01 00 00       	call   8001f6 <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	7e 0a                	jle    80006a <libmain+0x16>
		binaryname = argv[0];
  800060:	8b 45 0c             	mov    0xc(%ebp),%eax
  800063:	8b 00                	mov    (%eax),%eax
  800065:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	ff 75 0c             	pushl  0xc(%ebp)
  800070:	ff 75 08             	pushl  0x8(%ebp)
  800073:	e8 c0 ff ff ff       	call   800038 <_main>
  800078:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80007b:	e8 4f 0f 00 00       	call   800fcf <sys_getenvid>
  800080:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800086:	89 d0                	mov    %edx,%eax
  800088:	c1 e0 03             	shl    $0x3,%eax
  80008b:	01 d0                	add    %edx,%eax
  80008d:	01 c0                	add    %eax,%eax
  80008f:	01 d0                	add    %edx,%eax
  800091:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800098:	01 d0                	add    %edx,%eax
  80009a:	c1 e0 03             	shl    $0x3,%eax
  80009d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8000a5:	e8 73 10 00 00       	call   80111d <sys_disable_interrupt>
		cprintf("**************************************\n");
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	68 5c 17 80 00       	push   $0x80175c
  8000b2:	e8 19 01 00 00       	call   8001d0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8000ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000bd:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	50                   	push   %eax
  8000c7:	68 84 17 80 00       	push   $0x801784
  8000cc:	e8 ff 00 00 00       	call   8001d0 <cprintf>
  8000d1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	68 5c 17 80 00       	push   $0x80175c
  8000dc:	e8 ef 00 00 00       	call   8001d0 <cprintf>
  8000e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8000e4:	e8 4e 10 00 00       	call   801137 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8000e9:	e8 19 00 00 00       	call   800107 <exit>
}
  8000ee:	90                   	nop
  8000ef:	c9                   	leave  
  8000f0:	c3                   	ret    

008000f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8000f7:	83 ec 0c             	sub    $0xc,%esp
  8000fa:	6a 00                	push   $0x0
  8000fc:	e8 b3 0e 00 00       	call   800fb4 <sys_env_destroy>
  800101:	83 c4 10             	add    $0x10,%esp
}
  800104:	90                   	nop
  800105:	c9                   	leave  
  800106:	c3                   	ret    

00800107 <exit>:

void
exit(void)
{
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80010d:	e8 d6 0e 00 00       	call   800fe8 <sys_env_exit>
}
  800112:	90                   	nop
  800113:	c9                   	leave  
  800114:	c3                   	ret    

00800115 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80011b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011e:	8b 00                	mov    (%eax),%eax
  800120:	8d 48 01             	lea    0x1(%eax),%ecx
  800123:	8b 55 0c             	mov    0xc(%ebp),%edx
  800126:	89 0a                	mov    %ecx,(%edx)
  800128:	8b 55 08             	mov    0x8(%ebp),%edx
  80012b:	88 d1                	mov    %dl,%cl
  80012d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800130:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800134:	8b 45 0c             	mov    0xc(%ebp),%eax
  800137:	8b 00                	mov    (%eax),%eax
  800139:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013e:	75 23                	jne    800163 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800140:	8b 45 0c             	mov    0xc(%ebp),%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014a:	83 c0 08             	add    $0x8,%eax
  80014d:	83 ec 08             	sub    $0x8,%esp
  800150:	52                   	push   %edx
  800151:	50                   	push   %eax
  800152:	e8 27 0e 00 00       	call   800f7e <sys_cputs>
  800157:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80015a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800163:	8b 45 0c             	mov    0xc(%ebp),%eax
  800166:	8b 40 04             	mov    0x4(%eax),%eax
  800169:	8d 50 01             	lea    0x1(%eax),%edx
  80016c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800172:	90                   	nop
  800173:	c9                   	leave  
  800174:	c3                   	ret    

00800175 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80017e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800185:	00 00 00 
	b.cnt = 0;
  800188:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80018f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800192:	ff 75 0c             	pushl  0xc(%ebp)
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80019e:	50                   	push   %eax
  80019f:	68 15 01 80 00       	push   $0x800115
  8001a4:	e8 fa 01 00 00       	call   8003a3 <vprintfmt>
  8001a9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8001ac:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001b2:	83 ec 08             	sub    $0x8,%esp
  8001b5:	50                   	push   %eax
  8001b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001bc:	83 c0 08             	add    $0x8,%eax
  8001bf:	50                   	push   %eax
  8001c0:	e8 b9 0d 00 00       	call   800f7e <sys_cputs>
  8001c5:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8001c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8001d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8001dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001e5:	50                   	push   %eax
  8001e6:	e8 8a ff ff ff       	call   800175 <vcprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
  8001ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8001f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001fc:	e8 1c 0f 00 00       	call   80111d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800201:	8d 45 0c             	lea    0xc(%ebp),%eax
  800204:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	ff 75 f4             	pushl  -0xc(%ebp)
  800210:	50                   	push   %eax
  800211:	e8 5f ff ff ff       	call   800175 <vcprintf>
  800216:	83 c4 10             	add    $0x10,%esp
  800219:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80021c:	e8 16 0f 00 00       	call   801137 <sys_enable_interrupt>
	return cnt;
  800221:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800224:	c9                   	leave  
  800225:	c3                   	ret    

00800226 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	53                   	push   %ebx
  80022a:	83 ec 14             	sub    $0x14,%esp
  80022d:	8b 45 10             	mov    0x10(%ebp),%eax
  800230:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800233:	8b 45 14             	mov    0x14(%ebp),%eax
  800236:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800239:	8b 45 18             	mov    0x18(%ebp),%eax
  80023c:	ba 00 00 00 00       	mov    $0x0,%edx
  800241:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800244:	77 55                	ja     80029b <printnum+0x75>
  800246:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800249:	72 05                	jb     800250 <printnum+0x2a>
  80024b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80024e:	77 4b                	ja     80029b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800250:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800253:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800256:	8b 45 18             	mov    0x18(%ebp),%eax
  800259:	ba 00 00 00 00       	mov    $0x0,%edx
  80025e:	52                   	push   %edx
  80025f:	50                   	push   %eax
  800260:	ff 75 f4             	pushl  -0xc(%ebp)
  800263:	ff 75 f0             	pushl  -0x10(%ebp)
  800266:	e8 51 12 00 00       	call   8014bc <__udivdi3>
  80026b:	83 c4 10             	add    $0x10,%esp
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	ff 75 20             	pushl  0x20(%ebp)
  800274:	53                   	push   %ebx
  800275:	ff 75 18             	pushl  0x18(%ebp)
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	ff 75 0c             	pushl  0xc(%ebp)
  80027d:	ff 75 08             	pushl  0x8(%ebp)
  800280:	e8 a1 ff ff ff       	call   800226 <printnum>
  800285:	83 c4 20             	add    $0x20,%esp
  800288:	eb 1a                	jmp    8002a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	ff 75 0c             	pushl  0xc(%ebp)
  800290:	ff 75 20             	pushl  0x20(%ebp)
  800293:	8b 45 08             	mov    0x8(%ebp),%eax
  800296:	ff d0                	call   *%eax
  800298:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80029b:	ff 4d 1c             	decl   0x1c(%ebp)
  80029e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8002a2:	7f e6                	jg     80028a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002b2:	53                   	push   %ebx
  8002b3:	51                   	push   %ecx
  8002b4:	52                   	push   %edx
  8002b5:	50                   	push   %eax
  8002b6:	e8 11 13 00 00       	call   8015cc <__umoddi3>
  8002bb:	83 c4 10             	add    $0x10,%esp
  8002be:	05 b4 19 80 00       	add    $0x8019b4,%eax
  8002c3:	8a 00                	mov    (%eax),%al
  8002c5:	0f be c0             	movsbl %al,%eax
  8002c8:	83 ec 08             	sub    $0x8,%esp
  8002cb:	ff 75 0c             	pushl  0xc(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	ff d0                	call   *%eax
  8002d4:	83 c4 10             	add    $0x10,%esp
}
  8002d7:	90                   	nop
  8002d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8002e4:	7e 1c                	jle    800302 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8002e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	8d 50 08             	lea    0x8(%eax),%edx
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 10                	mov    %edx,(%eax)
  8002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f6:	8b 00                	mov    (%eax),%eax
  8002f8:	83 e8 08             	sub    $0x8,%eax
  8002fb:	8b 50 04             	mov    0x4(%eax),%edx
  8002fe:	8b 00                	mov    (%eax),%eax
  800300:	eb 40                	jmp    800342 <getuint+0x65>
	else if (lflag)
  800302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800306:	74 1e                	je     800326 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	8b 00                	mov    (%eax),%eax
  80030d:	8d 50 04             	lea    0x4(%eax),%edx
  800310:	8b 45 08             	mov    0x8(%ebp),%eax
  800313:	89 10                	mov    %edx,(%eax)
  800315:	8b 45 08             	mov    0x8(%ebp),%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	83 e8 04             	sub    $0x4,%eax
  80031d:	8b 00                	mov    (%eax),%eax
  80031f:	ba 00 00 00 00       	mov    $0x0,%edx
  800324:	eb 1c                	jmp    800342 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800326:	8b 45 08             	mov    0x8(%ebp),%eax
  800329:	8b 00                	mov    (%eax),%eax
  80032b:	8d 50 04             	lea    0x4(%eax),%edx
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	89 10                	mov    %edx,(%eax)
  800333:	8b 45 08             	mov    0x8(%ebp),%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	83 e8 04             	sub    $0x4,%eax
  80033b:	8b 00                	mov    (%eax),%eax
  80033d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800342:	5d                   	pop    %ebp
  800343:	c3                   	ret    

00800344 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800347:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80034b:	7e 1c                	jle    800369 <getint+0x25>
		return va_arg(*ap, long long);
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	8b 00                	mov    (%eax),%eax
  800352:	8d 50 08             	lea    0x8(%eax),%edx
  800355:	8b 45 08             	mov    0x8(%ebp),%eax
  800358:	89 10                	mov    %edx,(%eax)
  80035a:	8b 45 08             	mov    0x8(%ebp),%eax
  80035d:	8b 00                	mov    (%eax),%eax
  80035f:	83 e8 08             	sub    $0x8,%eax
  800362:	8b 50 04             	mov    0x4(%eax),%edx
  800365:	8b 00                	mov    (%eax),%eax
  800367:	eb 38                	jmp    8003a1 <getint+0x5d>
	else if (lflag)
  800369:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80036d:	74 1a                	je     800389 <getint+0x45>
		return va_arg(*ap, long);
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	8b 00                	mov    (%eax),%eax
  800374:	8d 50 04             	lea    0x4(%eax),%edx
  800377:	8b 45 08             	mov    0x8(%ebp),%eax
  80037a:	89 10                	mov    %edx,(%eax)
  80037c:	8b 45 08             	mov    0x8(%ebp),%eax
  80037f:	8b 00                	mov    (%eax),%eax
  800381:	83 e8 04             	sub    $0x4,%eax
  800384:	8b 00                	mov    (%eax),%eax
  800386:	99                   	cltd   
  800387:	eb 18                	jmp    8003a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	8d 50 04             	lea    0x4(%eax),%edx
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	89 10                	mov    %edx,(%eax)
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	8b 00                	mov    (%eax),%eax
  80039b:	83 e8 04             	sub    $0x4,%eax
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	99                   	cltd   
}
  8003a1:	5d                   	pop    %ebp
  8003a2:	c3                   	ret    

008003a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	56                   	push   %esi
  8003a7:	53                   	push   %ebx
  8003a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ab:	eb 17                	jmp    8003c4 <vprintfmt+0x21>
			if (ch == '\0')
  8003ad:	85 db                	test   %ebx,%ebx
  8003af:	0f 84 af 03 00 00    	je     800764 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	ff 75 0c             	pushl  0xc(%ebp)
  8003bb:	53                   	push   %ebx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	ff d0                	call   *%eax
  8003c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8003cd:	8a 00                	mov    (%eax),%al
  8003cf:	0f b6 d8             	movzbl %al,%ebx
  8003d2:	83 fb 25             	cmp    $0x25,%ebx
  8003d5:	75 d6                	jne    8003ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8003d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8003db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8003e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8003f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fa:	8d 50 01             	lea    0x1(%eax),%edx
  8003fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800400:	8a 00                	mov    (%eax),%al
  800402:	0f b6 d8             	movzbl %al,%ebx
  800405:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800408:	83 f8 55             	cmp    $0x55,%eax
  80040b:	0f 87 2b 03 00 00    	ja     80073c <vprintfmt+0x399>
  800411:	8b 04 85 d8 19 80 00 	mov    0x8019d8(,%eax,4),%eax
  800418:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80041a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80041e:	eb d7                	jmp    8003f7 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800420:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800424:	eb d1                	jmp    8003f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800426:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80042d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800430:	89 d0                	mov    %edx,%eax
  800432:	c1 e0 02             	shl    $0x2,%eax
  800435:	01 d0                	add    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d8                	add    %ebx,%eax
  80043b:	83 e8 30             	sub    $0x30,%eax
  80043e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800441:	8b 45 10             	mov    0x10(%ebp),%eax
  800444:	8a 00                	mov    (%eax),%al
  800446:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800449:	83 fb 2f             	cmp    $0x2f,%ebx
  80044c:	7e 3e                	jle    80048c <vprintfmt+0xe9>
  80044e:	83 fb 39             	cmp    $0x39,%ebx
  800451:	7f 39                	jg     80048c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800453:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800456:	eb d5                	jmp    80042d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	83 c0 04             	add    $0x4,%eax
  80045e:	89 45 14             	mov    %eax,0x14(%ebp)
  800461:	8b 45 14             	mov    0x14(%ebp),%eax
  800464:	83 e8 04             	sub    $0x4,%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80046c:	eb 1f                	jmp    80048d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80046e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800472:	79 83                	jns    8003f7 <vprintfmt+0x54>
				width = 0;
  800474:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80047b:	e9 77 ff ff ff       	jmp    8003f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800480:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800487:	e9 6b ff ff ff       	jmp    8003f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80048c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80048d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800491:	0f 89 60 ff ff ff    	jns    8003f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80049a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80049d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8004a4:	e9 4e ff ff ff       	jmp    8003f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8004ac:	e9 46 ff ff ff       	jmp    8003f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	83 c0 04             	add    $0x4,%eax
  8004b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	83 e8 04             	sub    $0x4,%eax
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	ff 75 0c             	pushl  0xc(%ebp)
  8004c8:	50                   	push   %eax
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	ff d0                	call   *%eax
  8004ce:	83 c4 10             	add    $0x10,%esp
			break;
  8004d1:	e9 89 02 00 00       	jmp    80075f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d9:	83 c0 04             	add    $0x4,%eax
  8004dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004df:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e2:	83 e8 04             	sub    $0x4,%eax
  8004e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8004e7:	85 db                	test   %ebx,%ebx
  8004e9:	79 02                	jns    8004ed <vprintfmt+0x14a>
				err = -err;
  8004eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004ed:	83 fb 64             	cmp    $0x64,%ebx
  8004f0:	7f 0b                	jg     8004fd <vprintfmt+0x15a>
  8004f2:	8b 34 9d 20 18 80 00 	mov    0x801820(,%ebx,4),%esi
  8004f9:	85 f6                	test   %esi,%esi
  8004fb:	75 19                	jne    800516 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8004fd:	53                   	push   %ebx
  8004fe:	68 c5 19 80 00       	push   $0x8019c5
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 5e 02 00 00       	call   80076c <printfmt>
  80050e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800511:	e9 49 02 00 00       	jmp    80075f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800516:	56                   	push   %esi
  800517:	68 ce 19 80 00       	push   $0x8019ce
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	e8 45 02 00 00       	call   80076c <printfmt>
  800527:	83 c4 10             	add    $0x10,%esp
			break;
  80052a:	e9 30 02 00 00       	jmp    80075f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	83 c0 04             	add    $0x4,%eax
  800535:	89 45 14             	mov    %eax,0x14(%ebp)
  800538:	8b 45 14             	mov    0x14(%ebp),%eax
  80053b:	83 e8 04             	sub    $0x4,%eax
  80053e:	8b 30                	mov    (%eax),%esi
  800540:	85 f6                	test   %esi,%esi
  800542:	75 05                	jne    800549 <vprintfmt+0x1a6>
				p = "(null)";
  800544:	be d1 19 80 00       	mov    $0x8019d1,%esi
			if (width > 0 && padc != '-')
  800549:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80054d:	7e 6d                	jle    8005bc <vprintfmt+0x219>
  80054f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800553:	74 67                	je     8005bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800555:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	50                   	push   %eax
  80055c:	56                   	push   %esi
  80055d:	e8 0c 03 00 00       	call   80086e <strnlen>
  800562:	83 c4 10             	add    $0x10,%esp
  800565:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800568:	eb 16                	jmp    800580 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80056a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	ff 75 0c             	pushl  0xc(%ebp)
  800574:	50                   	push   %eax
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	ff d0                	call   *%eax
  80057a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80057d:	ff 4d e4             	decl   -0x1c(%ebp)
  800580:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800584:	7f e4                	jg     80056a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800586:	eb 34                	jmp    8005bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800588:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80058c:	74 1c                	je     8005aa <vprintfmt+0x207>
  80058e:	83 fb 1f             	cmp    $0x1f,%ebx
  800591:	7e 05                	jle    800598 <vprintfmt+0x1f5>
  800593:	83 fb 7e             	cmp    $0x7e,%ebx
  800596:	7e 12                	jle    8005aa <vprintfmt+0x207>
					putch('?', putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	6a 3f                	push   $0x3f
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	ff d0                	call   *%eax
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	eb 0f                	jmp    8005b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 0c             	pushl  0xc(%ebp)
  8005b0:	53                   	push   %ebx
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	ff d0                	call   *%eax
  8005b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8005bc:	89 f0                	mov    %esi,%eax
  8005be:	8d 70 01             	lea    0x1(%eax),%esi
  8005c1:	8a 00                	mov    (%eax),%al
  8005c3:	0f be d8             	movsbl %al,%ebx
  8005c6:	85 db                	test   %ebx,%ebx
  8005c8:	74 24                	je     8005ee <vprintfmt+0x24b>
  8005ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ce:	78 b8                	js     800588 <vprintfmt+0x1e5>
  8005d0:	ff 4d e0             	decl   -0x20(%ebp)
  8005d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d7:	79 af                	jns    800588 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d9:	eb 13                	jmp    8005ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	ff 75 0c             	pushl  0xc(%ebp)
  8005e1:	6a 20                	push   $0x20
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	ff d0                	call   *%eax
  8005e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8005ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f2:	7f e7                	jg     8005db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8005f4:	e9 66 01 00 00       	jmp    80075f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8005ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	e8 3c fd ff ff       	call   800344 <getint>
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80060e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800614:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800617:	85 d2                	test   %edx,%edx
  800619:	79 23                	jns    80063e <vprintfmt+0x29b>
				putch('-', putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 0c             	pushl  0xc(%ebp)
  800621:	6a 2d                	push   $0x2d
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	ff d0                	call   *%eax
  800628:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800631:	f7 d8                	neg    %eax
  800633:	83 d2 00             	adc    $0x0,%edx
  800636:	f7 da                	neg    %edx
  800638:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80063e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800645:	e9 bc 00 00 00       	jmp    800706 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 e8             	pushl  -0x18(%ebp)
  800650:	8d 45 14             	lea    0x14(%ebp),%eax
  800653:	50                   	push   %eax
  800654:	e8 84 fc ff ff       	call   8002dd <getuint>
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80065f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800662:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800669:	e9 98 00 00 00       	jmp    800706 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	ff 75 0c             	pushl  0xc(%ebp)
  800674:	6a 58                	push   $0x58
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	ff d0                	call   *%eax
  80067b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	ff 75 0c             	pushl  0xc(%ebp)
  800684:	6a 58                	push   $0x58
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	ff d0                	call   *%eax
  80068b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	6a 58                	push   $0x58
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	ff d0                	call   *%eax
  80069b:	83 c4 10             	add    $0x10,%esp
			break;
  80069e:	e9 bc 00 00 00       	jmp    80075f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 0c             	pushl  0xc(%ebp)
  8006a9:	6a 30                	push   $0x30
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	ff d0                	call   *%eax
  8006b0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	6a 78                	push   $0x78
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	ff d0                	call   *%eax
  8006c0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	83 c0 04             	add    $0x4,%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	83 e8 04             	sub    $0x4,%eax
  8006d2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8006de:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8006e5:	eb 1f                	jmp    800706 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8006ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	e8 e7 fb ff ff       	call   8002dd <getuint>
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8006ff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800706:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80070a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070d:	83 ec 04             	sub    $0x4,%esp
  800710:	52                   	push   %edx
  800711:	ff 75 e4             	pushl  -0x1c(%ebp)
  800714:	50                   	push   %eax
  800715:	ff 75 f4             	pushl  -0xc(%ebp)
  800718:	ff 75 f0             	pushl  -0x10(%ebp)
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	ff 75 08             	pushl  0x8(%ebp)
  800721:	e8 00 fb ff ff       	call   800226 <printnum>
  800726:	83 c4 20             	add    $0x20,%esp
			break;
  800729:	eb 34                	jmp    80075f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	53                   	push   %ebx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
			break;
  80073a:	eb 23                	jmp    80075f <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	ff 75 0c             	pushl  0xc(%ebp)
  800742:	6a 25                	push   $0x25
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	ff d0                	call   *%eax
  800749:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80074c:	ff 4d 10             	decl   0x10(%ebp)
  80074f:	eb 03                	jmp    800754 <vprintfmt+0x3b1>
  800751:	ff 4d 10             	decl   0x10(%ebp)
  800754:	8b 45 10             	mov    0x10(%ebp),%eax
  800757:	48                   	dec    %eax
  800758:	8a 00                	mov    (%eax),%al
  80075a:	3c 25                	cmp    $0x25,%al
  80075c:	75 f3                	jne    800751 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80075e:	90                   	nop
		}
	}
  80075f:	e9 47 fc ff ff       	jmp    8003ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800764:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800765:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800768:	5b                   	pop    %ebx
  800769:	5e                   	pop    %esi
  80076a:	5d                   	pop    %ebp
  80076b:	c3                   	ret    

0080076c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800772:	8d 45 10             	lea    0x10(%ebp),%eax
  800775:	83 c0 04             	add    $0x4,%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80077b:	8b 45 10             	mov    0x10(%ebp),%eax
  80077e:	ff 75 f4             	pushl  -0xc(%ebp)
  800781:	50                   	push   %eax
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	ff 75 08             	pushl  0x8(%ebp)
  800788:	e8 16 fc ff ff       	call   8003a3 <vprintfmt>
  80078d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800790:	90                   	nop
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800796:	8b 45 0c             	mov    0xc(%ebp),%eax
  800799:	8b 40 08             	mov    0x8(%eax),%eax
  80079c:	8d 50 01             	lea    0x1(%eax),%edx
  80079f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a8:	8b 10                	mov    (%eax),%edx
  8007aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ad:	8b 40 04             	mov    0x4(%eax),%eax
  8007b0:	39 c2                	cmp    %eax,%edx
  8007b2:	73 12                	jae    8007c6 <sprintputch+0x33>
		*b->buf++ = ch;
  8007b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8007bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bf:	89 0a                	mov    %ecx,(%edx)
  8007c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c4:	88 10                	mov    %dl,(%eax)
}
  8007c6:	90                   	nop
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	01 d0                	add    %edx,%eax
  8007e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ee:	74 06                	je     8007f6 <vsnprintf+0x2d>
  8007f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f4:	7f 07                	jg     8007fd <vsnprintf+0x34>
		return -E_INVAL;
  8007f6:	b8 03 00 00 00       	mov    $0x3,%eax
  8007fb:	eb 20                	jmp    80081d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007fd:	ff 75 14             	pushl  0x14(%ebp)
  800800:	ff 75 10             	pushl  0x10(%ebp)
  800803:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	68 93 07 80 00       	push   $0x800793
  80080c:	e8 92 fb ff ff       	call   8003a3 <vprintfmt>
  800811:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800814:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800817:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80081a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80081d:	c9                   	leave  
  80081e:	c3                   	ret    

0080081f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
  800822:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800825:	8d 45 10             	lea    0x10(%ebp),%eax
  800828:	83 c0 04             	add    $0x4,%eax
  80082b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80082e:	8b 45 10             	mov    0x10(%ebp),%eax
  800831:	ff 75 f4             	pushl  -0xc(%ebp)
  800834:	50                   	push   %eax
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	ff 75 08             	pushl  0x8(%ebp)
  80083b:	e8 89 ff ff ff       	call   8007c9 <vsnprintf>
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800846:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800849:	c9                   	leave  
  80084a:	c3                   	ret    

0080084b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800851:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800858:	eb 06                	jmp    800860 <strlen+0x15>
		n++;
  80085a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80085d:	ff 45 08             	incl   0x8(%ebp)
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	8a 00                	mov    (%eax),%al
  800865:	84 c0                	test   %al,%al
  800867:	75 f1                	jne    80085a <strlen+0xf>
		n++;
	return n;
  800869:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80086c:	c9                   	leave  
  80086d:	c3                   	ret    

0080086e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800874:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80087b:	eb 09                	jmp    800886 <strnlen+0x18>
		n++;
  80087d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800880:	ff 45 08             	incl   0x8(%ebp)
  800883:	ff 4d 0c             	decl   0xc(%ebp)
  800886:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088a:	74 09                	je     800895 <strnlen+0x27>
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8a 00                	mov    (%eax),%al
  800891:	84 c0                	test   %al,%al
  800893:	75 e8                	jne    80087d <strnlen+0xf>
		n++;
	return n;
  800895:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800898:	c9                   	leave  
  800899:	c3                   	ret    

0080089a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8008a6:	90                   	nop
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8d 50 01             	lea    0x1(%eax),%edx
  8008ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8008b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8008b9:	8a 12                	mov    (%edx),%dl
  8008bb:	88 10                	mov    %dl,(%eax)
  8008bd:	8a 00                	mov    (%eax),%al
  8008bf:	84 c0                	test   %al,%al
  8008c1:	75 e4                	jne    8008a7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8008c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008c6:	c9                   	leave  
  8008c7:	c3                   	ret    

008008c8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8008d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008db:	eb 1f                	jmp    8008fc <strncpy+0x34>
		*dst++ = *src;
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	8d 50 01             	lea    0x1(%eax),%edx
  8008e3:	89 55 08             	mov    %edx,0x8(%ebp)
  8008e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e9:	8a 12                	mov    (%edx),%dl
  8008eb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8008ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f0:	8a 00                	mov    (%eax),%al
  8008f2:	84 c0                	test   %al,%al
  8008f4:	74 03                	je     8008f9 <strncpy+0x31>
			src++;
  8008f6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f9:	ff 45 fc             	incl   -0x4(%ebp)
  8008fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8008ff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800902:	72 d9                	jb     8008dd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800904:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800915:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800919:	74 30                	je     80094b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80091b:	eb 16                	jmp    800933 <strlcpy+0x2a>
			*dst++ = *src++;
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8d 50 01             	lea    0x1(%eax),%edx
  800923:	89 55 08             	mov    %edx,0x8(%ebp)
  800926:	8b 55 0c             	mov    0xc(%ebp),%edx
  800929:	8d 4a 01             	lea    0x1(%edx),%ecx
  80092c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80092f:	8a 12                	mov    (%edx),%dl
  800931:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800933:	ff 4d 10             	decl   0x10(%ebp)
  800936:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80093a:	74 09                	je     800945 <strlcpy+0x3c>
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093f:	8a 00                	mov    (%eax),%al
  800941:	84 c0                	test   %al,%al
  800943:	75 d8                	jne    80091d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094b:	8b 55 08             	mov    0x8(%ebp),%edx
  80094e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800951:	29 c2                	sub    %eax,%edx
  800953:	89 d0                	mov    %edx,%eax
}
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80095a:	eb 06                	jmp    800962 <strcmp+0xb>
		p++, q++;
  80095c:	ff 45 08             	incl   0x8(%ebp)
  80095f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8a 00                	mov    (%eax),%al
  800967:	84 c0                	test   %al,%al
  800969:	74 0e                	je     800979 <strcmp+0x22>
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8a 10                	mov    (%eax),%dl
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	8a 00                	mov    (%eax),%al
  800975:	38 c2                	cmp    %al,%dl
  800977:	74 e3                	je     80095c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8a 00                	mov    (%eax),%al
  80097e:	0f b6 d0             	movzbl %al,%edx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	8a 00                	mov    (%eax),%al
  800986:	0f b6 c0             	movzbl %al,%eax
  800989:	29 c2                	sub    %eax,%edx
  80098b:	89 d0                	mov    %edx,%eax
}
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800992:	eb 09                	jmp    80099d <strncmp+0xe>
		n--, p++, q++;
  800994:	ff 4d 10             	decl   0x10(%ebp)
  800997:	ff 45 08             	incl   0x8(%ebp)
  80099a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80099d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009a1:	74 17                	je     8009ba <strncmp+0x2b>
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	84 c0                	test   %al,%al
  8009aa:	74 0e                	je     8009ba <strncmp+0x2b>
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8a 10                	mov    (%eax),%dl
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	8a 00                	mov    (%eax),%al
  8009b6:	38 c2                	cmp    %al,%dl
  8009b8:	74 da                	je     800994 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8009ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009be:	75 07                	jne    8009c7 <strncmp+0x38>
		return 0;
  8009c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c5:	eb 14                	jmp    8009db <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	8a 00                	mov    (%eax),%al
  8009cc:	0f b6 d0             	movzbl %al,%edx
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f b6 c0             	movzbl %al,%eax
  8009d7:	29 c2                	sub    %eax,%edx
  8009d9:	89 d0                	mov    %edx,%eax
}
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 04             	sub    $0x4,%esp
  8009e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8009e9:	eb 12                	jmp    8009fd <strchr+0x20>
		if (*s == c)
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8a 00                	mov    (%eax),%al
  8009f0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8009f3:	75 05                	jne    8009fa <strchr+0x1d>
			return (char *) s;
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	eb 11                	jmp    800a0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009fa:	ff 45 08             	incl   0x8(%ebp)
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	84 c0                	test   %al,%al
  800a04:	75 e5                	jne    8009eb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 04             	sub    $0x4,%esp
  800a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a19:	eb 0d                	jmp    800a28 <strfind+0x1b>
		if (*s == c)
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	8a 00                	mov    (%eax),%al
  800a20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a23:	74 0e                	je     800a33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a25:	ff 45 08             	incl   0x8(%ebp)
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	84 c0                	test   %al,%al
  800a2f:	75 ea                	jne    800a1b <strfind+0xe>
  800a31:	eb 01                	jmp    800a34 <strfind+0x27>
		if (*s == c)
			break;
  800a33:	90                   	nop
	return (char *) s;
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800a45:	8b 45 10             	mov    0x10(%ebp),%eax
  800a48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800a4b:	eb 0e                	jmp    800a5b <memset+0x22>
		*p++ = c;
  800a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a50:	8d 50 01             	lea    0x1(%eax),%edx
  800a53:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a59:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800a5b:	ff 4d f8             	decl   -0x8(%ebp)
  800a5e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800a62:	79 e9                	jns    800a4d <memset+0x14>
		*p++ = c;

	return v;
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800a67:	c9                   	leave  
  800a68:	c3                   	ret    

00800a69 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800a7b:	eb 16                	jmp    800a93 <memcpy+0x2a>
		*d++ = *s++;
  800a7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800a80:	8d 50 01             	lea    0x1(%eax),%edx
  800a83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800a86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800a89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a8c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800a8f:	8a 12                	mov    (%edx),%dl
  800a91:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800a93:	8b 45 10             	mov    0x10(%ebp),%eax
  800a96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a99:	89 55 10             	mov    %edx,0x10(%ebp)
  800a9c:	85 c0                	test   %eax,%eax
  800a9e:	75 dd                	jne    800a7d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ab7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800abd:	73 50                	jae    800b0f <memmove+0x6a>
  800abf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ac2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac5:	01 d0                	add    %edx,%eax
  800ac7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800aca:	76 43                	jbe    800b0f <memmove+0x6a>
		s += n;
  800acc:	8b 45 10             	mov    0x10(%ebp),%eax
  800acf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ad8:	eb 10                	jmp    800aea <memmove+0x45>
			*--d = *--s;
  800ada:	ff 4d f8             	decl   -0x8(%ebp)
  800add:	ff 4d fc             	decl   -0x4(%ebp)
  800ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae3:	8a 10                	mov    (%eax),%dl
  800ae5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ae8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800aea:	8b 45 10             	mov    0x10(%ebp),%eax
  800aed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800af0:	89 55 10             	mov    %edx,0x10(%ebp)
  800af3:	85 c0                	test   %eax,%eax
  800af5:	75 e3                	jne    800ada <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af7:	eb 23                	jmp    800b1c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800af9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800afc:	8d 50 01             	lea    0x1(%eax),%edx
  800aff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b08:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b0b:	8a 12                	mov    (%edx),%dl
  800b0d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800b0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b15:	89 55 10             	mov    %edx,0x10(%ebp)
  800b18:	85 c0                	test   %eax,%eax
  800b1a:	75 dd                	jne    800af9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800b33:	eb 2a                	jmp    800b5f <memcmp+0x3e>
		if (*s1 != *s2)
  800b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b38:	8a 10                	mov    (%eax),%dl
  800b3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b3d:	8a 00                	mov    (%eax),%al
  800b3f:	38 c2                	cmp    %al,%dl
  800b41:	74 16                	je     800b59 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b46:	8a 00                	mov    (%eax),%al
  800b48:	0f b6 d0             	movzbl %al,%edx
  800b4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	0f b6 c0             	movzbl %al,%eax
  800b53:	29 c2                	sub    %eax,%edx
  800b55:	89 d0                	mov    %edx,%eax
  800b57:	eb 18                	jmp    800b71 <memcmp+0x50>
		s1++, s2++;
  800b59:	ff 45 fc             	incl   -0x4(%ebp)
  800b5c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b65:	89 55 10             	mov    %edx,0x10(%ebp)
  800b68:	85 c0                	test   %eax,%eax
  800b6a:	75 c9                	jne    800b35 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800b79:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800b84:	eb 15                	jmp    800b9b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8a 00                	mov    (%eax),%al
  800b8b:	0f b6 d0             	movzbl %al,%edx
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	0f b6 c0             	movzbl %al,%eax
  800b94:	39 c2                	cmp    %eax,%edx
  800b96:	74 0d                	je     800ba5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b98:	ff 45 08             	incl   0x8(%ebp)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ba1:	72 e3                	jb     800b86 <memfind+0x13>
  800ba3:	eb 01                	jmp    800ba6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ba5:	90                   	nop
	return (void *) s;
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800bb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800bb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbf:	eb 03                	jmp    800bc4 <strtol+0x19>
		s++;
  800bc1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	3c 20                	cmp    $0x20,%al
  800bcb:	74 f4                	je     800bc1 <strtol+0x16>
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	3c 09                	cmp    $0x9,%al
  800bd4:	74 eb                	je     800bc1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8a 00                	mov    (%eax),%al
  800bdb:	3c 2b                	cmp    $0x2b,%al
  800bdd:	75 05                	jne    800be4 <strtol+0x39>
		s++;
  800bdf:	ff 45 08             	incl   0x8(%ebp)
  800be2:	eb 13                	jmp    800bf7 <strtol+0x4c>
	else if (*s == '-')
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8a 00                	mov    (%eax),%al
  800be9:	3c 2d                	cmp    $0x2d,%al
  800beb:	75 0a                	jne    800bf7 <strtol+0x4c>
		s++, neg = 1;
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bfb:	74 06                	je     800c03 <strtol+0x58>
  800bfd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c01:	75 20                	jne    800c23 <strtol+0x78>
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	3c 30                	cmp    $0x30,%al
  800c0a:	75 17                	jne    800c23 <strtol+0x78>
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	40                   	inc    %eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	3c 78                	cmp    $0x78,%al
  800c14:	75 0d                	jne    800c23 <strtol+0x78>
		s += 2, base = 16;
  800c16:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800c1a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c21:	eb 28                	jmp    800c4b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800c23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c27:	75 15                	jne    800c3e <strtol+0x93>
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	3c 30                	cmp    $0x30,%al
  800c30:	75 0c                	jne    800c3e <strtol+0x93>
		s++, base = 8;
  800c32:	ff 45 08             	incl   0x8(%ebp)
  800c35:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800c3c:	eb 0d                	jmp    800c4b <strtol+0xa0>
	else if (base == 0)
  800c3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c42:	75 07                	jne    800c4b <strtol+0xa0>
		base = 10;
  800c44:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	3c 2f                	cmp    $0x2f,%al
  800c52:	7e 19                	jle    800c6d <strtol+0xc2>
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	3c 39                	cmp    $0x39,%al
  800c5b:	7f 10                	jg     800c6d <strtol+0xc2>
			dig = *s - '0';
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	0f be c0             	movsbl %al,%eax
  800c65:	83 e8 30             	sub    $0x30,%eax
  800c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c6b:	eb 42                	jmp    800caf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	3c 60                	cmp    $0x60,%al
  800c74:	7e 19                	jle    800c8f <strtol+0xe4>
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	3c 7a                	cmp    $0x7a,%al
  800c7d:	7f 10                	jg     800c8f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	0f be c0             	movsbl %al,%eax
  800c87:	83 e8 57             	sub    $0x57,%eax
  800c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c8d:	eb 20                	jmp    800caf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	3c 40                	cmp    $0x40,%al
  800c96:	7e 39                	jle    800cd1 <strtol+0x126>
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	3c 5a                	cmp    $0x5a,%al
  800c9f:	7f 30                	jg     800cd1 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	0f be c0             	movsbl %al,%eax
  800ca9:	83 e8 37             	sub    $0x37,%eax
  800cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cb2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb5:	7d 19                	jge    800cd0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800cb7:	ff 45 08             	incl   0x8(%ebp)
  800cba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cc1:	89 c2                	mov    %eax,%edx
  800cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cc6:	01 d0                	add    %edx,%eax
  800cc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ccb:	e9 7b ff ff ff       	jmp    800c4b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800cd0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800cd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd5:	74 08                	je     800cdf <strtol+0x134>
		*endptr = (char *) s;
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800cdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ce3:	74 07                	je     800cec <strtol+0x141>
  800ce5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce8:	f7 d8                	neg    %eax
  800cea:	eb 03                	jmp    800cef <strtol+0x144>
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <ltostr>:

void
ltostr(long value, char *str)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800cf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800cfe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d09:	79 13                	jns    800d1e <ltostr+0x2d>
	{
		neg = 1;
  800d0b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800d18:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800d1b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800d26:	99                   	cltd   
  800d27:	f7 f9                	idiv   %ecx
  800d29:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800d2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2f:	8d 50 01             	lea    0x1(%eax),%edx
  800d32:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d35:	89 c2                	mov    %eax,%edx
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	01 d0                	add    %edx,%eax
  800d3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d3f:	83 c2 30             	add    $0x30,%edx
  800d42:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800d44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d47:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800d4c:	f7 e9                	imul   %ecx
  800d4e:	c1 fa 02             	sar    $0x2,%edx
  800d51:	89 c8                	mov    %ecx,%eax
  800d53:	c1 f8 1f             	sar    $0x1f,%eax
  800d56:	29 c2                	sub    %eax,%edx
  800d58:	89 d0                	mov    %edx,%eax
  800d5a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800d5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d60:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800d65:	f7 e9                	imul   %ecx
  800d67:	c1 fa 02             	sar    $0x2,%edx
  800d6a:	89 c8                	mov    %ecx,%eax
  800d6c:	c1 f8 1f             	sar    $0x1f,%eax
  800d6f:	29 c2                	sub    %eax,%edx
  800d71:	89 d0                	mov    %edx,%eax
  800d73:	c1 e0 02             	shl    $0x2,%eax
  800d76:	01 d0                	add    %edx,%eax
  800d78:	01 c0                	add    %eax,%eax
  800d7a:	29 c1                	sub    %eax,%ecx
  800d7c:	89 ca                	mov    %ecx,%edx
  800d7e:	85 d2                	test   %edx,%edx
  800d80:	75 9c                	jne    800d1e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800d82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800d89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8c:	48                   	dec    %eax
  800d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800d90:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d94:	74 3d                	je     800dd3 <ltostr+0xe2>
		start = 1 ;
  800d96:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800d9d:	eb 34                	jmp    800dd3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800d9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	01 d0                	add    %edx,%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800dac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	01 c2                	add    %eax,%edx
  800db4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	01 c8                	add    %ecx,%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800dc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc6:	01 c2                	add    %eax,%edx
  800dc8:	8a 45 eb             	mov    -0x15(%ebp),%al
  800dcb:	88 02                	mov    %al,(%edx)
		start++ ;
  800dcd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800dd0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dd9:	7c c4                	jl     800d9f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ddb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	01 d0                	add    %edx,%eax
  800de3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800de6:	90                   	nop
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800def:	ff 75 08             	pushl  0x8(%ebp)
  800df2:	e8 54 fa ff ff       	call   80084b <strlen>
  800df7:	83 c4 04             	add    $0x4,%esp
  800dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	e8 46 fa ff ff       	call   80084b <strlen>
  800e05:	83 c4 04             	add    $0x4,%esp
  800e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 17                	jmp    800e32 <strcconcat+0x49>
		final[s] = str1[s] ;
  800e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	01 c2                	add    %eax,%edx
  800e23:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	01 c8                	add    %ecx,%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800e2f:	ff 45 fc             	incl   -0x4(%ebp)
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e38:	7c e1                	jl     800e1b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800e3a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800e41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800e48:	eb 1f                	jmp    800e69 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4d:	8d 50 01             	lea    0x1(%eax),%edx
  800e50:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e53:	89 c2                	mov    %eax,%edx
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	01 c2                	add    %eax,%edx
  800e5a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	01 c8                	add    %ecx,%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800e66:	ff 45 f8             	incl   -0x8(%ebp)
  800e69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6f:	7c d9                	jl     800e4a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800e71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 d0                	add    %edx,%eax
  800e79:	c6 00 00             	movb   $0x0,(%eax)
}
  800e7c:	90                   	nop
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800e82:	8b 45 14             	mov    0x14(%ebp),%eax
  800e85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800e8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8e:	8b 00                	mov    (%eax),%eax
  800e90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	01 d0                	add    %edx,%eax
  800e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800ea2:	eb 0c                	jmp    800eb0 <strsplit+0x31>
			*string++ = 0;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8d 50 01             	lea    0x1(%eax),%edx
  800eaa:	89 55 08             	mov    %edx,0x8(%ebp)
  800ead:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	74 18                	je     800ed1 <strsplit+0x52>
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	0f be c0             	movsbl %al,%eax
  800ec1:	50                   	push   %eax
  800ec2:	ff 75 0c             	pushl  0xc(%ebp)
  800ec5:	e8 13 fb ff ff       	call   8009dd <strchr>
  800eca:	83 c4 08             	add    $0x8,%esp
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	75 d3                	jne    800ea4 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	84 c0                	test   %al,%al
  800ed8:	74 5a                	je     800f34 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  800eda:	8b 45 14             	mov    0x14(%ebp),%eax
  800edd:	8b 00                	mov    (%eax),%eax
  800edf:	83 f8 0f             	cmp    $0xf,%eax
  800ee2:	75 07                	jne    800eeb <strsplit+0x6c>
		{
			return 0;
  800ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee9:	eb 66                	jmp    800f51 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  800eee:	8b 00                	mov    (%eax),%eax
  800ef0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ef3:	8b 55 14             	mov    0x14(%ebp),%edx
  800ef6:	89 0a                	mov    %ecx,(%edx)
  800ef8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	01 c2                	add    %eax,%edx
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f09:	eb 03                	jmp    800f0e <strsplit+0x8f>
			string++;
  800f0b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	84 c0                	test   %al,%al
  800f15:	74 8b                	je     800ea2 <strsplit+0x23>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f be c0             	movsbl %al,%eax
  800f1f:	50                   	push   %eax
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	e8 b5 fa ff ff       	call   8009dd <strchr>
  800f28:	83 c4 08             	add    $0x8,%esp
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	74 dc                	je     800f0b <strsplit+0x8c>
			string++;
	}
  800f2f:	e9 6e ff ff ff       	jmp    800ea2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800f34:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800f35:	8b 45 14             	mov    0x14(%ebp),%eax
  800f38:	8b 00                	mov    (%eax),%eax
  800f3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 d0                	add    %edx,%eax
  800f46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800f4c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f65:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800f68:	8b 7d 18             	mov    0x18(%ebp),%edi
  800f6b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  800f6e:	cd 30                	int    $0x30
  800f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  800f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f76:	83 c4 10             	add    $0x10,%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    

00800f7e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	6a 00                	push   $0x0
  800f86:	6a 00                	push   $0x0
  800f88:	6a 00                	push   $0x0
  800f8a:	ff 75 0c             	pushl  0xc(%ebp)
  800f8d:	50                   	push   %eax
  800f8e:	6a 00                	push   $0x0
  800f90:	e8 be ff ff ff       	call   800f53 <syscall>
  800f95:	83 c4 18             	add    $0x18,%esp
}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <sys_cgetc>:

int
sys_cgetc(void)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  800f9e:	6a 00                	push   $0x0
  800fa0:	6a 00                	push   $0x0
  800fa2:	6a 00                	push   $0x0
  800fa4:	6a 00                	push   $0x0
  800fa6:	6a 00                	push   $0x0
  800fa8:	6a 01                	push   $0x1
  800faa:	e8 a4 ff ff ff       	call   800f53 <syscall>
  800faf:	83 c4 18             	add    $0x18,%esp
}
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	6a 00                	push   $0x0
  800fbc:	6a 00                	push   $0x0
  800fbe:	6a 00                	push   $0x0
  800fc0:	6a 00                	push   $0x0
  800fc2:	50                   	push   %eax
  800fc3:	6a 03                	push   $0x3
  800fc5:	e8 89 ff ff ff       	call   800f53 <syscall>
  800fca:	83 c4 18             	add    $0x18,%esp
}
  800fcd:	c9                   	leave  
  800fce:	c3                   	ret    

00800fcf <sys_getenvid>:

int32 sys_getenvid(void)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  800fd2:	6a 00                	push   $0x0
  800fd4:	6a 00                	push   $0x0
  800fd6:	6a 00                	push   $0x0
  800fd8:	6a 00                	push   $0x0
  800fda:	6a 00                	push   $0x0
  800fdc:	6a 02                	push   $0x2
  800fde:	e8 70 ff ff ff       	call   800f53 <syscall>
  800fe3:	83 c4 18             	add    $0x18,%esp
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <sys_env_exit>:

void sys_env_exit(void)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  800feb:	6a 00                	push   $0x0
  800fed:	6a 00                	push   $0x0
  800fef:	6a 00                	push   $0x0
  800ff1:	6a 00                	push   $0x0
  800ff3:	6a 00                	push   $0x0
  800ff5:	6a 04                	push   $0x4
  800ff7:	e8 57 ff ff ff       	call   800f53 <syscall>
  800ffc:	83 c4 18             	add    $0x18,%esp
}
  800fff:	90                   	nop
  801000:	c9                   	leave  
  801001:	c3                   	ret    

00801002 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801005:	8b 55 0c             	mov    0xc(%ebp),%edx
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	6a 00                	push   $0x0
  80100d:	6a 00                	push   $0x0
  80100f:	6a 00                	push   $0x0
  801011:	52                   	push   %edx
  801012:	50                   	push   %eax
  801013:	6a 05                	push   $0x5
  801015:	e8 39 ff ff ff       	call   800f53 <syscall>
  80101a:	83 c4 18             	add    $0x18,%esp
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801024:	8b 75 18             	mov    0x18(%ebp),%esi
  801027:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80102a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80102d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	56                   	push   %esi
  801034:	53                   	push   %ebx
  801035:	51                   	push   %ecx
  801036:	52                   	push   %edx
  801037:	50                   	push   %eax
  801038:	6a 06                	push   $0x6
  80103a:	e8 14 ff ff ff       	call   800f53 <syscall>
  80103f:	83 c4 18             	add    $0x18,%esp
}
  801042:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80104c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	6a 00                	push   $0x0
  801054:	6a 00                	push   $0x0
  801056:	6a 00                	push   $0x0
  801058:	52                   	push   %edx
  801059:	50                   	push   %eax
  80105a:	6a 07                	push   $0x7
  80105c:	e8 f2 fe ff ff       	call   800f53 <syscall>
  801061:	83 c4 18             	add    $0x18,%esp
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801069:	6a 00                	push   $0x0
  80106b:	6a 00                	push   $0x0
  80106d:	6a 00                	push   $0x0
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	ff 75 08             	pushl  0x8(%ebp)
  801075:	6a 08                	push   $0x8
  801077:	e8 d7 fe ff ff       	call   800f53 <syscall>
  80107c:	83 c4 18             	add    $0x18,%esp
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801084:	6a 00                	push   $0x0
  801086:	6a 00                	push   $0x0
  801088:	6a 00                	push   $0x0
  80108a:	6a 00                	push   $0x0
  80108c:	6a 00                	push   $0x0
  80108e:	6a 09                	push   $0x9
  801090:	e8 be fe ff ff       	call   800f53 <syscall>
  801095:	83 c4 18             	add    $0x18,%esp
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80109d:	6a 00                	push   $0x0
  80109f:	6a 00                	push   $0x0
  8010a1:	6a 00                	push   $0x0
  8010a3:	6a 00                	push   $0x0
  8010a5:	6a 00                	push   $0x0
  8010a7:	6a 0a                	push   $0xa
  8010a9:	e8 a5 fe ff ff       	call   800f53 <syscall>
  8010ae:	83 c4 18             	add    $0x18,%esp
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8010b6:	6a 00                	push   $0x0
  8010b8:	6a 00                	push   $0x0
  8010ba:	6a 00                	push   $0x0
  8010bc:	6a 00                	push   $0x0
  8010be:	6a 00                	push   $0x0
  8010c0:	6a 0b                	push   $0xb
  8010c2:	e8 8c fe ff ff       	call   800f53 <syscall>
  8010c7:	83 c4 18             	add    $0x18,%esp
}
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    

008010cc <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8010cf:	6a 00                	push   $0x0
  8010d1:	6a 00                	push   $0x0
  8010d3:	6a 00                	push   $0x0
  8010d5:	ff 75 0c             	pushl  0xc(%ebp)
  8010d8:	ff 75 08             	pushl  0x8(%ebp)
  8010db:	6a 0d                	push   $0xd
  8010dd:	e8 71 fe ff ff       	call   800f53 <syscall>
  8010e2:	83 c4 18             	add    $0x18,%esp
	return;
  8010e5:	90                   	nop
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8010eb:	6a 00                	push   $0x0
  8010ed:	6a 00                	push   $0x0
  8010ef:	6a 00                	push   $0x0
  8010f1:	ff 75 0c             	pushl  0xc(%ebp)
  8010f4:	ff 75 08             	pushl  0x8(%ebp)
  8010f7:	6a 0e                	push   $0xe
  8010f9:	e8 55 fe ff ff       	call   800f53 <syscall>
  8010fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801101:	90                   	nop
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801107:	6a 00                	push   $0x0
  801109:	6a 00                	push   $0x0
  80110b:	6a 00                	push   $0x0
  80110d:	6a 00                	push   $0x0
  80110f:	6a 00                	push   $0x0
  801111:	6a 0c                	push   $0xc
  801113:	e8 3b fe ff ff       	call   800f53 <syscall>
  801118:	83 c4 18             	add    $0x18,%esp
}
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    

0080111d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	6a 00                	push   $0x0
  80112a:	6a 10                	push   $0x10
  80112c:	e8 22 fe ff ff       	call   800f53 <syscall>
  801131:	83 c4 18             	add    $0x18,%esp
}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80113a:	6a 00                	push   $0x0
  80113c:	6a 00                	push   $0x0
  80113e:	6a 00                	push   $0x0
  801140:	6a 00                	push   $0x0
  801142:	6a 00                	push   $0x0
  801144:	6a 11                	push   $0x11
  801146:	e8 08 fe ff ff       	call   800f53 <syscall>
  80114b:	83 c4 18             	add    $0x18,%esp
}
  80114e:	90                   	nop
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <sys_cputc>:


void
sys_cputc(const char c)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 04             	sub    $0x4,%esp
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80115d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801161:	6a 00                	push   $0x0
  801163:	6a 00                	push   $0x0
  801165:	6a 00                	push   $0x0
  801167:	6a 00                	push   $0x0
  801169:	50                   	push   %eax
  80116a:	6a 12                	push   $0x12
  80116c:	e8 e2 fd ff ff       	call   800f53 <syscall>
  801171:	83 c4 18             	add    $0x18,%esp
}
  801174:	90                   	nop
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80117a:	6a 00                	push   $0x0
  80117c:	6a 00                	push   $0x0
  80117e:	6a 00                	push   $0x0
  801180:	6a 00                	push   $0x0
  801182:	6a 00                	push   $0x0
  801184:	6a 13                	push   $0x13
  801186:	e8 c8 fd ff ff       	call   800f53 <syscall>
  80118b:	83 c4 18             	add    $0x18,%esp
}
  80118e:	90                   	nop
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	6a 00                	push   $0x0
  801199:	6a 00                	push   $0x0
  80119b:	6a 00                	push   $0x0
  80119d:	ff 75 0c             	pushl  0xc(%ebp)
  8011a0:	50                   	push   %eax
  8011a1:	6a 14                	push   $0x14
  8011a3:	e8 ab fd ff ff       	call   800f53 <syscall>
  8011a8:	83 c4 18             	add    $0x18,%esp
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8011b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b3:	6a 00                	push   $0x0
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	50                   	push   %eax
  8011bc:	6a 17                	push   $0x17
  8011be:	e8 90 fd ff ff       	call   800f53 <syscall>
  8011c3:	83 c4 18             	add    $0x18,%esp
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	50                   	push   %eax
  8011d7:	6a 15                	push   $0x15
  8011d9:	e8 75 fd ff ff       	call   800f53 <syscall>
  8011de:	83 c4 18             	add    $0x18,%esp
}
  8011e1:	90                   	nop
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	50                   	push   %eax
  8011f3:	6a 16                	push   $0x16
  8011f5:	e8 59 fd ff ff       	call   800f53 <syscall>
  8011fa:	83 c4 18             	add    $0x18,%esp
}
  8011fd:	90                   	nop
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 04             	sub    $0x4,%esp
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80120c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80120f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	6a 00                	push   $0x0
  801218:	51                   	push   %ecx
  801219:	52                   	push   %edx
  80121a:	ff 75 0c             	pushl  0xc(%ebp)
  80121d:	50                   	push   %eax
  80121e:	6a 18                	push   $0x18
  801220:	e8 2e fd ff ff       	call   800f53 <syscall>
  801225:	83 c4 18             	add    $0x18,%esp
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  80122d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	52                   	push   %edx
  80123a:	50                   	push   %eax
  80123b:	6a 19                	push   $0x19
  80123d:	e8 11 fd ff ff       	call   800f53 <syscall>
  801242:	83 c4 18             	add    $0x18,%esp
}
  801245:	c9                   	leave  
  801246:	c3                   	ret    

00801247 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	50                   	push   %eax
  801256:	6a 1a                	push   $0x1a
  801258:	e8 f6 fc ff ff       	call   800f53 <syscall>
  80125d:	83 c4 18             	add    $0x18,%esp
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 1b                	push   $0x1b
  801271:	e8 dd fc ff ff       	call   800f53 <syscall>
  801276:	83 c4 18             	add    $0x18,%esp
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 1c                	push   $0x1c
  80128a:	e8 c4 fc ff ff       	call   800f53 <syscall>
  80128f:	83 c4 18             	add    $0x18,%esp
}
  801292:	c9                   	leave  
  801293:	c3                   	ret    

00801294 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	6a 00                	push   $0x0
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	50                   	push   %eax
  8012a4:	6a 1d                	push   $0x1d
  8012a6:	e8 a8 fc ff ff       	call   800f53 <syscall>
  8012ab:	83 c4 18             	add    $0x18,%esp
}
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	50                   	push   %eax
  8012bf:	6a 1e                	push   $0x1e
  8012c1:	e8 8d fc ff ff       	call   800f53 <syscall>
  8012c6:	83 c4 18             	add    $0x18,%esp
}
  8012c9:	90                   	nop
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	50                   	push   %eax
  8012db:	6a 1f                	push   $0x1f
  8012dd:	e8 71 fc ff ff       	call   800f53 <syscall>
  8012e2:	83 c4 18             	add    $0x18,%esp
}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8012ee:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8012f1:	8d 50 04             	lea    0x4(%eax),%edx
  8012f4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	52                   	push   %edx
  8012fe:	50                   	push   %eax
  8012ff:	6a 20                	push   $0x20
  801301:	e8 4d fc ff ff       	call   800f53 <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
	return result;
  801309:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801312:	89 01                	mov    %eax,(%ecx)
  801314:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	c9                   	leave  
  80131b:	c2 04 00             	ret    $0x4

0080131e <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	ff 75 10             	pushl  0x10(%ebp)
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	ff 75 08             	pushl  0x8(%ebp)
  80132e:	6a 0f                	push   $0xf
  801330:	e8 1e fc ff ff       	call   800f53 <syscall>
  801335:	83 c4 18             	add    $0x18,%esp
	return ;
  801338:	90                   	nop
}
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <sys_rcr2>:
uint32 sys_rcr2()
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 21                	push   $0x21
  80134a:	e8 04 fc ff ff       	call   800f53 <syscall>
  80134f:	83 c4 18             	add    $0x18,%esp
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 04             	sub    $0x4,%esp
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801360:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	50                   	push   %eax
  80136d:	6a 22                	push   $0x22
  80136f:	e8 df fb ff ff       	call   800f53 <syscall>
  801374:	83 c4 18             	add    $0x18,%esp
	return ;
  801377:	90                   	nop
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <rsttst>:
void rsttst()
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 24                	push   $0x24
  801389:	e8 c5 fb ff ff       	call   800f53 <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
	return ;
  801391:	90                   	nop
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	8b 45 14             	mov    0x14(%ebp),%eax
  80139d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013a0:	8b 55 18             	mov    0x18(%ebp),%edx
  8013a3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013a7:	52                   	push   %edx
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 10             	pushl  0x10(%ebp)
  8013ac:	ff 75 0c             	pushl  0xc(%ebp)
  8013af:	ff 75 08             	pushl  0x8(%ebp)
  8013b2:	6a 23                	push   $0x23
  8013b4:	e8 9a fb ff ff       	call   800f53 <syscall>
  8013b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8013bc:	90                   	nop
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <chktst>:
void chktst(uint32 n)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	ff 75 08             	pushl  0x8(%ebp)
  8013cd:	6a 25                	push   $0x25
  8013cf:	e8 7f fb ff ff       	call   800f53 <syscall>
  8013d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d7:	90                   	nop
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 26                	push   $0x26
  8013ec:	e8 62 fb ff ff       	call   800f53 <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
  8013f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8013f7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8013fb:	75 07                	jne    801404 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8013fd:	b8 01 00 00 00       	mov    $0x1,%eax
  801402:	eb 05                	jmp    801409 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801404:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 26                	push   $0x26
  80141d:	e8 31 fb ff ff       	call   800f53 <syscall>
  801422:	83 c4 18             	add    $0x18,%esp
  801425:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801428:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80142c:	75 07                	jne    801435 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80142e:	b8 01 00 00 00       	mov    $0x1,%eax
  801433:	eb 05                	jmp    80143a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 26                	push   $0x26
  80144e:	e8 00 fb ff ff       	call   800f53 <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
  801456:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801459:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80145d:	75 07                	jne    801466 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80145f:	b8 01 00 00 00       	mov    $0x1,%eax
  801464:	eb 05                	jmp    80146b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 26                	push   $0x26
  80147f:	e8 cf fa ff ff       	call   800f53 <syscall>
  801484:	83 c4 18             	add    $0x18,%esp
  801487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80148a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80148e:	75 07                	jne    801497 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801490:	b8 01 00 00 00       	mov    $0x1,%eax
  801495:	eb 05                	jmp    80149c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801497:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	ff 75 08             	pushl  0x8(%ebp)
  8014ac:	6a 27                	push   $0x27
  8014ae:	e8 a0 fa ff ff       	call   800f53 <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b6:	90                   	nop
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    
  8014b9:	66 90                	xchg   %ax,%ax
  8014bb:	90                   	nop

008014bc <__udivdi3>:
  8014bc:	55                   	push   %ebp
  8014bd:	57                   	push   %edi
  8014be:	56                   	push   %esi
  8014bf:	53                   	push   %ebx
  8014c0:	83 ec 1c             	sub    $0x1c,%esp
  8014c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8014c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8014cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8014cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014d3:	89 ca                	mov    %ecx,%edx
  8014d5:	89 f8                	mov    %edi,%eax
  8014d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8014db:	85 f6                	test   %esi,%esi
  8014dd:	75 2d                	jne    80150c <__udivdi3+0x50>
  8014df:	39 cf                	cmp    %ecx,%edi
  8014e1:	77 65                	ja     801548 <__udivdi3+0x8c>
  8014e3:	89 fd                	mov    %edi,%ebp
  8014e5:	85 ff                	test   %edi,%edi
  8014e7:	75 0b                	jne    8014f4 <__udivdi3+0x38>
  8014e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8014ee:	31 d2                	xor    %edx,%edx
  8014f0:	f7 f7                	div    %edi
  8014f2:	89 c5                	mov    %eax,%ebp
  8014f4:	31 d2                	xor    %edx,%edx
  8014f6:	89 c8                	mov    %ecx,%eax
  8014f8:	f7 f5                	div    %ebp
  8014fa:	89 c1                	mov    %eax,%ecx
  8014fc:	89 d8                	mov    %ebx,%eax
  8014fe:	f7 f5                	div    %ebp
  801500:	89 cf                	mov    %ecx,%edi
  801502:	89 fa                	mov    %edi,%edx
  801504:	83 c4 1c             	add    $0x1c,%esp
  801507:	5b                   	pop    %ebx
  801508:	5e                   	pop    %esi
  801509:	5f                   	pop    %edi
  80150a:	5d                   	pop    %ebp
  80150b:	c3                   	ret    
  80150c:	39 ce                	cmp    %ecx,%esi
  80150e:	77 28                	ja     801538 <__udivdi3+0x7c>
  801510:	0f bd fe             	bsr    %esi,%edi
  801513:	83 f7 1f             	xor    $0x1f,%edi
  801516:	75 40                	jne    801558 <__udivdi3+0x9c>
  801518:	39 ce                	cmp    %ecx,%esi
  80151a:	72 0a                	jb     801526 <__udivdi3+0x6a>
  80151c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801520:	0f 87 9e 00 00 00    	ja     8015c4 <__udivdi3+0x108>
  801526:	b8 01 00 00 00       	mov    $0x1,%eax
  80152b:	89 fa                	mov    %edi,%edx
  80152d:	83 c4 1c             	add    $0x1c,%esp
  801530:	5b                   	pop    %ebx
  801531:	5e                   	pop    %esi
  801532:	5f                   	pop    %edi
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    
  801535:	8d 76 00             	lea    0x0(%esi),%esi
  801538:	31 ff                	xor    %edi,%edi
  80153a:	31 c0                	xor    %eax,%eax
  80153c:	89 fa                	mov    %edi,%edx
  80153e:	83 c4 1c             	add    $0x1c,%esp
  801541:	5b                   	pop    %ebx
  801542:	5e                   	pop    %esi
  801543:	5f                   	pop    %edi
  801544:	5d                   	pop    %ebp
  801545:	c3                   	ret    
  801546:	66 90                	xchg   %ax,%ax
  801548:	89 d8                	mov    %ebx,%eax
  80154a:	f7 f7                	div    %edi
  80154c:	31 ff                	xor    %edi,%edi
  80154e:	89 fa                	mov    %edi,%edx
  801550:	83 c4 1c             	add    $0x1c,%esp
  801553:	5b                   	pop    %ebx
  801554:	5e                   	pop    %esi
  801555:	5f                   	pop    %edi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    
  801558:	bd 20 00 00 00       	mov    $0x20,%ebp
  80155d:	89 eb                	mov    %ebp,%ebx
  80155f:	29 fb                	sub    %edi,%ebx
  801561:	89 f9                	mov    %edi,%ecx
  801563:	d3 e6                	shl    %cl,%esi
  801565:	89 c5                	mov    %eax,%ebp
  801567:	88 d9                	mov    %bl,%cl
  801569:	d3 ed                	shr    %cl,%ebp
  80156b:	89 e9                	mov    %ebp,%ecx
  80156d:	09 f1                	or     %esi,%ecx
  80156f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801573:	89 f9                	mov    %edi,%ecx
  801575:	d3 e0                	shl    %cl,%eax
  801577:	89 c5                	mov    %eax,%ebp
  801579:	89 d6                	mov    %edx,%esi
  80157b:	88 d9                	mov    %bl,%cl
  80157d:	d3 ee                	shr    %cl,%esi
  80157f:	89 f9                	mov    %edi,%ecx
  801581:	d3 e2                	shl    %cl,%edx
  801583:	8b 44 24 08          	mov    0x8(%esp),%eax
  801587:	88 d9                	mov    %bl,%cl
  801589:	d3 e8                	shr    %cl,%eax
  80158b:	09 c2                	or     %eax,%edx
  80158d:	89 d0                	mov    %edx,%eax
  80158f:	89 f2                	mov    %esi,%edx
  801591:	f7 74 24 0c          	divl   0xc(%esp)
  801595:	89 d6                	mov    %edx,%esi
  801597:	89 c3                	mov    %eax,%ebx
  801599:	f7 e5                	mul    %ebp
  80159b:	39 d6                	cmp    %edx,%esi
  80159d:	72 19                	jb     8015b8 <__udivdi3+0xfc>
  80159f:	74 0b                	je     8015ac <__udivdi3+0xf0>
  8015a1:	89 d8                	mov    %ebx,%eax
  8015a3:	31 ff                	xor    %edi,%edi
  8015a5:	e9 58 ff ff ff       	jmp    801502 <__udivdi3+0x46>
  8015aa:	66 90                	xchg   %ax,%ax
  8015ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8015b0:	89 f9                	mov    %edi,%ecx
  8015b2:	d3 e2                	shl    %cl,%edx
  8015b4:	39 c2                	cmp    %eax,%edx
  8015b6:	73 e9                	jae    8015a1 <__udivdi3+0xe5>
  8015b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8015bb:	31 ff                	xor    %edi,%edi
  8015bd:	e9 40 ff ff ff       	jmp    801502 <__udivdi3+0x46>
  8015c2:	66 90                	xchg   %ax,%ax
  8015c4:	31 c0                	xor    %eax,%eax
  8015c6:	e9 37 ff ff ff       	jmp    801502 <__udivdi3+0x46>
  8015cb:	90                   	nop

008015cc <__umoddi3>:
  8015cc:	55                   	push   %ebp
  8015cd:	57                   	push   %edi
  8015ce:	56                   	push   %esi
  8015cf:	53                   	push   %ebx
  8015d0:	83 ec 1c             	sub    $0x1c,%esp
  8015d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8015d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8015db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8015df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8015e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015eb:	89 f3                	mov    %esi,%ebx
  8015ed:	89 fa                	mov    %edi,%edx
  8015ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015f3:	89 34 24             	mov    %esi,(%esp)
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	75 1a                	jne    801614 <__umoddi3+0x48>
  8015fa:	39 f7                	cmp    %esi,%edi
  8015fc:	0f 86 a2 00 00 00    	jbe    8016a4 <__umoddi3+0xd8>
  801602:	89 c8                	mov    %ecx,%eax
  801604:	89 f2                	mov    %esi,%edx
  801606:	f7 f7                	div    %edi
  801608:	89 d0                	mov    %edx,%eax
  80160a:	31 d2                	xor    %edx,%edx
  80160c:	83 c4 1c             	add    $0x1c,%esp
  80160f:	5b                   	pop    %ebx
  801610:	5e                   	pop    %esi
  801611:	5f                   	pop    %edi
  801612:	5d                   	pop    %ebp
  801613:	c3                   	ret    
  801614:	39 f0                	cmp    %esi,%eax
  801616:	0f 87 ac 00 00 00    	ja     8016c8 <__umoddi3+0xfc>
  80161c:	0f bd e8             	bsr    %eax,%ebp
  80161f:	83 f5 1f             	xor    $0x1f,%ebp
  801622:	0f 84 ac 00 00 00    	je     8016d4 <__umoddi3+0x108>
  801628:	bf 20 00 00 00       	mov    $0x20,%edi
  80162d:	29 ef                	sub    %ebp,%edi
  80162f:	89 fe                	mov    %edi,%esi
  801631:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801635:	89 e9                	mov    %ebp,%ecx
  801637:	d3 e0                	shl    %cl,%eax
  801639:	89 d7                	mov    %edx,%edi
  80163b:	89 f1                	mov    %esi,%ecx
  80163d:	d3 ef                	shr    %cl,%edi
  80163f:	09 c7                	or     %eax,%edi
  801641:	89 e9                	mov    %ebp,%ecx
  801643:	d3 e2                	shl    %cl,%edx
  801645:	89 14 24             	mov    %edx,(%esp)
  801648:	89 d8                	mov    %ebx,%eax
  80164a:	d3 e0                	shl    %cl,%eax
  80164c:	89 c2                	mov    %eax,%edx
  80164e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801652:	d3 e0                	shl    %cl,%eax
  801654:	89 44 24 04          	mov    %eax,0x4(%esp)
  801658:	8b 44 24 08          	mov    0x8(%esp),%eax
  80165c:	89 f1                	mov    %esi,%ecx
  80165e:	d3 e8                	shr    %cl,%eax
  801660:	09 d0                	or     %edx,%eax
  801662:	d3 eb                	shr    %cl,%ebx
  801664:	89 da                	mov    %ebx,%edx
  801666:	f7 f7                	div    %edi
  801668:	89 d3                	mov    %edx,%ebx
  80166a:	f7 24 24             	mull   (%esp)
  80166d:	89 c6                	mov    %eax,%esi
  80166f:	89 d1                	mov    %edx,%ecx
  801671:	39 d3                	cmp    %edx,%ebx
  801673:	0f 82 87 00 00 00    	jb     801700 <__umoddi3+0x134>
  801679:	0f 84 91 00 00 00    	je     801710 <__umoddi3+0x144>
  80167f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801683:	29 f2                	sub    %esi,%edx
  801685:	19 cb                	sbb    %ecx,%ebx
  801687:	89 d8                	mov    %ebx,%eax
  801689:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80168d:	d3 e0                	shl    %cl,%eax
  80168f:	89 e9                	mov    %ebp,%ecx
  801691:	d3 ea                	shr    %cl,%edx
  801693:	09 d0                	or     %edx,%eax
  801695:	89 e9                	mov    %ebp,%ecx
  801697:	d3 eb                	shr    %cl,%ebx
  801699:	89 da                	mov    %ebx,%edx
  80169b:	83 c4 1c             	add    $0x1c,%esp
  80169e:	5b                   	pop    %ebx
  80169f:	5e                   	pop    %esi
  8016a0:	5f                   	pop    %edi
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    
  8016a3:	90                   	nop
  8016a4:	89 fd                	mov    %edi,%ebp
  8016a6:	85 ff                	test   %edi,%edi
  8016a8:	75 0b                	jne    8016b5 <__umoddi3+0xe9>
  8016aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8016af:	31 d2                	xor    %edx,%edx
  8016b1:	f7 f7                	div    %edi
  8016b3:	89 c5                	mov    %eax,%ebp
  8016b5:	89 f0                	mov    %esi,%eax
  8016b7:	31 d2                	xor    %edx,%edx
  8016b9:	f7 f5                	div    %ebp
  8016bb:	89 c8                	mov    %ecx,%eax
  8016bd:	f7 f5                	div    %ebp
  8016bf:	89 d0                	mov    %edx,%eax
  8016c1:	e9 44 ff ff ff       	jmp    80160a <__umoddi3+0x3e>
  8016c6:	66 90                	xchg   %ax,%ax
  8016c8:	89 c8                	mov    %ecx,%eax
  8016ca:	89 f2                	mov    %esi,%edx
  8016cc:	83 c4 1c             	add    $0x1c,%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5e                   	pop    %esi
  8016d1:	5f                   	pop    %edi
  8016d2:	5d                   	pop    %ebp
  8016d3:	c3                   	ret    
  8016d4:	3b 04 24             	cmp    (%esp),%eax
  8016d7:	72 06                	jb     8016df <__umoddi3+0x113>
  8016d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8016dd:	77 0f                	ja     8016ee <__umoddi3+0x122>
  8016df:	89 f2                	mov    %esi,%edx
  8016e1:	29 f9                	sub    %edi,%ecx
  8016e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8016e7:	89 14 24             	mov    %edx,(%esp)
  8016ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8016f2:	8b 14 24             	mov    (%esp),%edx
  8016f5:	83 c4 1c             	add    $0x1c,%esp
  8016f8:	5b                   	pop    %ebx
  8016f9:	5e                   	pop    %esi
  8016fa:	5f                   	pop    %edi
  8016fb:	5d                   	pop    %ebp
  8016fc:	c3                   	ret    
  8016fd:	8d 76 00             	lea    0x0(%esi),%esi
  801700:	2b 04 24             	sub    (%esp),%eax
  801703:	19 fa                	sbb    %edi,%edx
  801705:	89 d1                	mov    %edx,%ecx
  801707:	89 c6                	mov    %eax,%esi
  801709:	e9 71 ff ff ff       	jmp    80167f <__umoddi3+0xb3>
  80170e:	66 90                	xchg   %ax,%ax
  801710:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801714:	72 ea                	jb     801700 <__umoddi3+0x134>
  801716:	89 d9                	mov    %ebx,%ecx
  801718:	e9 62 ff ff ff       	jmp    80167f <__umoddi3+0xb3>
