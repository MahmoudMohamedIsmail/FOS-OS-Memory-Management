
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 ab 00 00 00       	call   8000e1 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 60 1a 80 00       	push   $0x801a60
  800057:	e8 7a 09 00 00       	call   8009d6 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 cc 0d 00 00       	call   800e3e <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 7e 1a 80 00       	push   $0x801a7e
  800097:	e8 e7 01 00 00       	call   800283 <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <fibonacci>:


int fibonacci(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	53                   	push   %ebx
  8000a6:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ad:	7f 07                	jg     8000b6 <fibonacci+0x14>
		return 1 ;
  8000af:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b4:	eb 26                	jmp    8000dc <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b9:	48                   	dec    %eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 df ff ff ff       	call   8000a2 <fibonacci>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 c3                	mov    %eax,%ebx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	83 e8 02             	sub    $0x2,%eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 cb ff ff ff       	call   8000a2 <fibonacci>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	01 d8                	add    %ebx,%eax
}
  8000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000eb:	7e 0a                	jle    8000f7 <libmain+0x16>
		binaryname = argv[0];
  8000ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f0:	8b 00                	mov    (%eax),%eax
  8000f2:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	ff 75 0c             	pushl  0xc(%ebp)
  8000fd:	ff 75 08             	pushl  0x8(%ebp)
  800100:	e8 33 ff ff ff       	call   800038 <_main>
  800105:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800108:	e8 55 11 00 00       	call   801262 <sys_getenvid>
  80010d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800113:	89 d0                	mov    %edx,%eax
  800115:	c1 e0 03             	shl    $0x3,%eax
  800118:	01 d0                	add    %edx,%eax
  80011a:	01 c0                	add    %eax,%eax
  80011c:	01 d0                	add    %edx,%eax
  80011e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800125:	01 d0                	add    %edx,%eax
  800127:	c1 e0 03             	shl    $0x3,%eax
  80012a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800132:	e8 79 12 00 00       	call   8013b0 <sys_disable_interrupt>
		cprintf("**************************************\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 ac 1a 80 00       	push   $0x801aac
  80013f:	e8 19 01 00 00       	call   80025d <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80014a:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	50                   	push   %eax
  800154:	68 d4 1a 80 00       	push   $0x801ad4
  800159:	e8 ff 00 00 00       	call   80025d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 ac 1a 80 00       	push   $0x801aac
  800169:	e8 ef 00 00 00       	call   80025d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800171:	e8 54 12 00 00       	call   8013ca <sys_enable_interrupt>

	// exit gracefully
	exit();
  800176:	e8 19 00 00 00       	call   800194 <exit>
}
  80017b:	90                   	nop
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    

0080017e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800184:	83 ec 0c             	sub    $0xc,%esp
  800187:	6a 00                	push   $0x0
  800189:	e8 b9 10 00 00       	call   801247 <sys_env_destroy>
  80018e:	83 c4 10             	add    $0x10,%esp
}
  800191:	90                   	nop
  800192:	c9                   	leave  
  800193:	c3                   	ret    

00800194 <exit>:

void
exit(void)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80019a:	e8 dc 10 00 00       	call   80127b <sys_env_exit>
}
  80019f:	90                   	nop
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ab:	8b 00                	mov    (%eax),%eax
  8001ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8001b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b3:	89 0a                	mov    %ecx,(%edx)
  8001b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b8:	88 d1                	mov    %dl,%cl
  8001ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	8b 00                	mov    (%eax),%eax
  8001c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cb:	75 23                	jne    8001f0 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8001cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d0:	8b 00                	mov    (%eax),%eax
  8001d2:	89 c2                	mov    %eax,%edx
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	83 c0 08             	add    $0x8,%eax
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	52                   	push   %edx
  8001de:	50                   	push   %eax
  8001df:	e8 2d 10 00 00       	call   801211 <sys_cputs>
  8001e4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f3:	8b 40 04             	mov    0x4(%eax),%eax
  8001f6:	8d 50 01             	lea    0x1(%eax),%edx
  8001f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80020b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800212:	00 00 00 
	b.cnt = 0;
  800215:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80021c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80021f:	ff 75 0c             	pushl  0xc(%ebp)
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80022b:	50                   	push   %eax
  80022c:	68 a2 01 80 00       	push   $0x8001a2
  800231:	e8 fa 01 00 00       	call   800430 <vprintfmt>
  800236:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800239:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80023f:	83 ec 08             	sub    $0x8,%esp
  800242:	50                   	push   %eax
  800243:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800249:	83 c0 08             	add    $0x8,%eax
  80024c:	50                   	push   %eax
  80024d:	e8 bf 0f 00 00       	call   801211 <sys_cputs>
  800252:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800255:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <cprintf>:

int cprintf(const char *fmt, ...) {
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800263:	8d 45 0c             	lea    0xc(%ebp),%eax
  800266:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800269:	8b 45 08             	mov    0x8(%ebp),%eax
  80026c:	83 ec 08             	sub    $0x8,%esp
  80026f:	ff 75 f4             	pushl  -0xc(%ebp)
  800272:	50                   	push   %eax
  800273:	e8 8a ff ff ff       	call   800202 <vcprintf>
  800278:	83 c4 10             	add    $0x10,%esp
  80027b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800289:	e8 22 11 00 00       	call   8013b0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800291:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800294:	8b 45 08             	mov    0x8(%ebp),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	ff 75 f4             	pushl  -0xc(%ebp)
  80029d:	50                   	push   %eax
  80029e:	e8 5f ff ff ff       	call   800202 <vcprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002a9:	e8 1c 11 00 00       	call   8013ca <sys_enable_interrupt>
	return cnt;
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 14             	sub    $0x14,%esp
  8002ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c6:	8b 45 18             	mov    0x18(%ebp),%eax
  8002c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002d1:	77 55                	ja     800328 <printnum+0x75>
  8002d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002d6:	72 05                	jb     8002dd <printnum+0x2a>
  8002d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002db:	77 4b                	ja     800328 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002dd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002e0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e3:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002eb:	52                   	push   %edx
  8002ec:	50                   	push   %eax
  8002ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8002f3:	e8 f4 14 00 00       	call   8017ec <__udivdi3>
  8002f8:	83 c4 10             	add    $0x10,%esp
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	ff 75 20             	pushl  0x20(%ebp)
  800301:	53                   	push   %ebx
  800302:	ff 75 18             	pushl  0x18(%ebp)
  800305:	52                   	push   %edx
  800306:	50                   	push   %eax
  800307:	ff 75 0c             	pushl  0xc(%ebp)
  80030a:	ff 75 08             	pushl  0x8(%ebp)
  80030d:	e8 a1 ff ff ff       	call   8002b3 <printnum>
  800312:	83 c4 20             	add    $0x20,%esp
  800315:	eb 1a                	jmp    800331 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	ff 75 0c             	pushl  0xc(%ebp)
  80031d:	ff 75 20             	pushl  0x20(%ebp)
  800320:	8b 45 08             	mov    0x8(%ebp),%eax
  800323:	ff d0                	call   *%eax
  800325:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800328:	ff 4d 1c             	decl   0x1c(%ebp)
  80032b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80032f:	7f e6                	jg     800317 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800331:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800334:	bb 00 00 00 00       	mov    $0x0,%ebx
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80033f:	53                   	push   %ebx
  800340:	51                   	push   %ecx
  800341:	52                   	push   %edx
  800342:	50                   	push   %eax
  800343:	e8 b4 15 00 00       	call   8018fc <__umoddi3>
  800348:	83 c4 10             	add    $0x10,%esp
  80034b:	05 14 1d 80 00       	add    $0x801d14,%eax
  800350:	8a 00                	mov    (%eax),%al
  800352:	0f be c0             	movsbl %al,%eax
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	ff 75 0c             	pushl  0xc(%ebp)
  80035b:	50                   	push   %eax
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	ff d0                	call   *%eax
  800361:	83 c4 10             	add    $0x10,%esp
}
  800364:	90                   	nop
  800365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80036d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800371:	7e 1c                	jle    80038f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	8d 50 08             	lea    0x8(%eax),%edx
  80037b:	8b 45 08             	mov    0x8(%ebp),%eax
  80037e:	89 10                	mov    %edx,(%eax)
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	8b 00                	mov    (%eax),%eax
  800385:	83 e8 08             	sub    $0x8,%eax
  800388:	8b 50 04             	mov    0x4(%eax),%edx
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	eb 40                	jmp    8003cf <getuint+0x65>
	else if (lflag)
  80038f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800393:	74 1e                	je     8003b3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	8d 50 04             	lea    0x4(%eax),%edx
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	89 10                	mov    %edx,(%eax)
  8003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	83 e8 04             	sub    $0x4,%eax
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b1:	eb 1c                	jmp    8003cf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	8d 50 04             	lea    0x4(%eax),%edx
  8003bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	8b 00                	mov    (%eax),%eax
  8003c5:	83 e8 04             	sub    $0x4,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003cf:	5d                   	pop    %ebp
  8003d0:	c3                   	ret    

008003d1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003d8:	7e 1c                	jle    8003f6 <getint+0x25>
		return va_arg(*ap, long long);
  8003da:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	8d 50 08             	lea    0x8(%eax),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	89 10                	mov    %edx,(%eax)
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	8b 00                	mov    (%eax),%eax
  8003ec:	83 e8 08             	sub    $0x8,%eax
  8003ef:	8b 50 04             	mov    0x4(%eax),%edx
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	eb 38                	jmp    80042e <getint+0x5d>
	else if (lflag)
  8003f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003fa:	74 1a                	je     800416 <getint+0x45>
		return va_arg(*ap, long);
  8003fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ff:	8b 00                	mov    (%eax),%eax
  800401:	8d 50 04             	lea    0x4(%eax),%edx
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	89 10                	mov    %edx,(%eax)
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	83 e8 04             	sub    $0x4,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	99                   	cltd   
  800414:	eb 18                	jmp    80042e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	8d 50 04             	lea    0x4(%eax),%edx
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	89 10                	mov    %edx,(%eax)
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	8b 00                	mov    (%eax),%eax
  800428:	83 e8 04             	sub    $0x4,%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	99                   	cltd   
}
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    

00800430 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	56                   	push   %esi
  800434:	53                   	push   %ebx
  800435:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800438:	eb 17                	jmp    800451 <vprintfmt+0x21>
			if (ch == '\0')
  80043a:	85 db                	test   %ebx,%ebx
  80043c:	0f 84 af 03 00 00    	je     8007f1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	ff 75 0c             	pushl  0xc(%ebp)
  800448:	53                   	push   %ebx
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	ff d0                	call   *%eax
  80044e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800451:	8b 45 10             	mov    0x10(%ebp),%eax
  800454:	8d 50 01             	lea    0x1(%eax),%edx
  800457:	89 55 10             	mov    %edx,0x10(%ebp)
  80045a:	8a 00                	mov    (%eax),%al
  80045c:	0f b6 d8             	movzbl %al,%ebx
  80045f:	83 fb 25             	cmp    $0x25,%ebx
  800462:	75 d6                	jne    80043a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800464:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800468:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80046f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800476:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80047d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8b 45 10             	mov    0x10(%ebp),%eax
  800487:	8d 50 01             	lea    0x1(%eax),%edx
  80048a:	89 55 10             	mov    %edx,0x10(%ebp)
  80048d:	8a 00                	mov    (%eax),%al
  80048f:	0f b6 d8             	movzbl %al,%ebx
  800492:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800495:	83 f8 55             	cmp    $0x55,%eax
  800498:	0f 87 2b 03 00 00    	ja     8007c9 <vprintfmt+0x399>
  80049e:	8b 04 85 38 1d 80 00 	mov    0x801d38(,%eax,4),%eax
  8004a5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004a7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004ab:	eb d7                	jmp    800484 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004ad:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004b1:	eb d1                	jmp    800484 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004b3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004bd:	89 d0                	mov    %edx,%eax
  8004bf:	c1 e0 02             	shl    $0x2,%eax
  8004c2:	01 d0                	add    %edx,%eax
  8004c4:	01 c0                	add    %eax,%eax
  8004c6:	01 d8                	add    %ebx,%eax
  8004c8:	83 e8 30             	sub    $0x30,%eax
  8004cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d1:	8a 00                	mov    (%eax),%al
  8004d3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004d6:	83 fb 2f             	cmp    $0x2f,%ebx
  8004d9:	7e 3e                	jle    800519 <vprintfmt+0xe9>
  8004db:	83 fb 39             	cmp    $0x39,%ebx
  8004de:	7f 39                	jg     800519 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004e3:	eb d5                	jmp    8004ba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e8:	83 c0 04             	add    $0x4,%eax
  8004eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f1:	83 e8 04             	sub    $0x4,%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004f9:	eb 1f                	jmp    80051a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8004fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004ff:	79 83                	jns    800484 <vprintfmt+0x54>
				width = 0;
  800501:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800508:	e9 77 ff ff ff       	jmp    800484 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80050d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800514:	e9 6b ff ff ff       	jmp    800484 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800519:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80051a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80051e:	0f 89 60 ff ff ff    	jns    800484 <vprintfmt+0x54>
				width = precision, precision = -1;
  800524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800527:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80052a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800531:	e9 4e ff ff ff       	jmp    800484 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800536:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800539:	e9 46 ff ff ff       	jmp    800484 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	83 c0 04             	add    $0x4,%eax
  800544:	89 45 14             	mov    %eax,0x14(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	83 e8 04             	sub    $0x4,%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	ff 75 0c             	pushl  0xc(%ebp)
  800555:	50                   	push   %eax
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	ff d0                	call   *%eax
  80055b:	83 c4 10             	add    $0x10,%esp
			break;
  80055e:	e9 89 02 00 00       	jmp    8007ec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	83 c0 04             	add    $0x4,%eax
  800569:	89 45 14             	mov    %eax,0x14(%ebp)
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	83 e8 04             	sub    $0x4,%eax
  800572:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800574:	85 db                	test   %ebx,%ebx
  800576:	79 02                	jns    80057a <vprintfmt+0x14a>
				err = -err;
  800578:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80057a:	83 fb 64             	cmp    $0x64,%ebx
  80057d:	7f 0b                	jg     80058a <vprintfmt+0x15a>
  80057f:	8b 34 9d 80 1b 80 00 	mov    0x801b80(,%ebx,4),%esi
  800586:	85 f6                	test   %esi,%esi
  800588:	75 19                	jne    8005a3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80058a:	53                   	push   %ebx
  80058b:	68 25 1d 80 00       	push   $0x801d25
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 5e 02 00 00       	call   8007f9 <printfmt>
  80059b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80059e:	e9 49 02 00 00       	jmp    8007ec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005a3:	56                   	push   %esi
  8005a4:	68 2e 1d 80 00       	push   $0x801d2e
  8005a9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ac:	ff 75 08             	pushl  0x8(%ebp)
  8005af:	e8 45 02 00 00       	call   8007f9 <printfmt>
  8005b4:	83 c4 10             	add    $0x10,%esp
			break;
  8005b7:	e9 30 02 00 00       	jmp    8007ec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	83 c0 04             	add    $0x4,%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	83 e8 04             	sub    $0x4,%eax
  8005cb:	8b 30                	mov    (%eax),%esi
  8005cd:	85 f6                	test   %esi,%esi
  8005cf:	75 05                	jne    8005d6 <vprintfmt+0x1a6>
				p = "(null)";
  8005d1:	be 31 1d 80 00       	mov    $0x801d31,%esi
			if (width > 0 && padc != '-')
  8005d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005da:	7e 6d                	jle    800649 <vprintfmt+0x219>
  8005dc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005e0:	74 67                	je     800649 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	50                   	push   %eax
  8005e9:	56                   	push   %esi
  8005ea:	e8 12 05 00 00       	call   800b01 <strnlen>
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005f5:	eb 16                	jmp    80060d <vprintfmt+0x1dd>
					putch(padc, putdat);
  8005f7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	ff 75 0c             	pushl  0xc(%ebp)
  800601:	50                   	push   %eax
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	ff d0                	call   *%eax
  800607:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80060a:	ff 4d e4             	decl   -0x1c(%ebp)
  80060d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800611:	7f e4                	jg     8005f7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800613:	eb 34                	jmp    800649 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800615:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800619:	74 1c                	je     800637 <vprintfmt+0x207>
  80061b:	83 fb 1f             	cmp    $0x1f,%ebx
  80061e:	7e 05                	jle    800625 <vprintfmt+0x1f5>
  800620:	83 fb 7e             	cmp    $0x7e,%ebx
  800623:	7e 12                	jle    800637 <vprintfmt+0x207>
					putch('?', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	6a 3f                	push   $0x3f
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	ff d0                	call   *%eax
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	eb 0f                	jmp    800646 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	ff 75 0c             	pushl  0xc(%ebp)
  80063d:	53                   	push   %ebx
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	ff d0                	call   *%eax
  800643:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800646:	ff 4d e4             	decl   -0x1c(%ebp)
  800649:	89 f0                	mov    %esi,%eax
  80064b:	8d 70 01             	lea    0x1(%eax),%esi
  80064e:	8a 00                	mov    (%eax),%al
  800650:	0f be d8             	movsbl %al,%ebx
  800653:	85 db                	test   %ebx,%ebx
  800655:	74 24                	je     80067b <vprintfmt+0x24b>
  800657:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80065b:	78 b8                	js     800615 <vprintfmt+0x1e5>
  80065d:	ff 4d e0             	decl   -0x20(%ebp)
  800660:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800664:	79 af                	jns    800615 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800666:	eb 13                	jmp    80067b <vprintfmt+0x24b>
				putch(' ', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	6a 20                	push   $0x20
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800678:	ff 4d e4             	decl   -0x1c(%ebp)
  80067b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067f:	7f e7                	jg     800668 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800681:	e9 66 01 00 00       	jmp    8007ec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	ff 75 e8             	pushl  -0x18(%ebp)
  80068c:	8d 45 14             	lea    0x14(%ebp),%eax
  80068f:	50                   	push   %eax
  800690:	e8 3c fd ff ff       	call   8003d1 <getint>
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80069e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a4:	85 d2                	test   %edx,%edx
  8006a6:	79 23                	jns    8006cb <vprintfmt+0x29b>
				putch('-', putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	6a 2d                	push   $0x2d
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	ff d0                	call   *%eax
  8006b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006be:	f7 d8                	neg    %eax
  8006c0:	83 d2 00             	adc    $0x0,%edx
  8006c3:	f7 da                	neg    %edx
  8006c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006d2:	e9 bc 00 00 00       	jmp    800793 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 e8             	pushl  -0x18(%ebp)
  8006dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e0:	50                   	push   %eax
  8006e1:	e8 84 fc ff ff       	call   80036a <getuint>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006f6:	e9 98 00 00 00       	jmp    800793 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	6a 58                	push   $0x58
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	ff d0                	call   *%eax
  800708:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	6a 58                	push   $0x58
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	ff d0                	call   *%eax
  800718:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	6a 58                	push   $0x58
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	ff d0                	call   *%eax
  800728:	83 c4 10             	add    $0x10,%esp
			break;
  80072b:	e9 bc 00 00 00       	jmp    8007ec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	6a 30                	push   $0x30
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	ff 75 0c             	pushl  0xc(%ebp)
  800746:	6a 78                	push   $0x78
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	83 c0 04             	add    $0x4,%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 e8 04             	sub    $0x4,%eax
  80075f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800761:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80076b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800772:	eb 1f                	jmp    800793 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 e8             	pushl  -0x18(%ebp)
  80077a:	8d 45 14             	lea    0x14(%ebp),%eax
  80077d:	50                   	push   %eax
  80077e:	e8 e7 fb ff ff       	call   80036a <getuint>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800789:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80078c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800793:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079a:	83 ec 04             	sub    $0x4,%esp
  80079d:	52                   	push   %edx
  80079e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007a1:	50                   	push   %eax
  8007a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	e8 00 fb ff ff       	call   8002b3 <printnum>
  8007b3:	83 c4 20             	add    $0x20,%esp
			break;
  8007b6:	eb 34                	jmp    8007ec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	53                   	push   %ebx
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	ff d0                	call   *%eax
  8007c4:	83 c4 10             	add    $0x10,%esp
			break;
  8007c7:	eb 23                	jmp    8007ec <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	6a 25                	push   $0x25
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	ff d0                	call   *%eax
  8007d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d9:	ff 4d 10             	decl   0x10(%ebp)
  8007dc:	eb 03                	jmp    8007e1 <vprintfmt+0x3b1>
  8007de:	ff 4d 10             	decl   0x10(%ebp)
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	48                   	dec    %eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	3c 25                	cmp    $0x25,%al
  8007e9:	75 f3                	jne    8007de <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007eb:	90                   	nop
		}
	}
  8007ec:	e9 47 fc ff ff       	jmp    800438 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007f5:	5b                   	pop    %ebx
  8007f6:	5e                   	pop    %esi
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8007ff:	8d 45 10             	lea    0x10(%ebp),%eax
  800802:	83 c0 04             	add    $0x4,%eax
  800805:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	ff 75 f4             	pushl  -0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	ff 75 08             	pushl  0x8(%ebp)
  800815:	e8 16 fc ff ff       	call   800430 <vprintfmt>
  80081a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80081d:	90                   	nop
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800823:	8b 45 0c             	mov    0xc(%ebp),%eax
  800826:	8b 40 08             	mov    0x8(%eax),%eax
  800829:	8d 50 01             	lea    0x1(%eax),%edx
  80082c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800832:	8b 45 0c             	mov    0xc(%ebp),%eax
  800835:	8b 10                	mov    (%eax),%edx
  800837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083a:	8b 40 04             	mov    0x4(%eax),%eax
  80083d:	39 c2                	cmp    %eax,%edx
  80083f:	73 12                	jae    800853 <sprintputch+0x33>
		*b->buf++ = ch;
  800841:	8b 45 0c             	mov    0xc(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	8d 48 01             	lea    0x1(%eax),%ecx
  800849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084c:	89 0a                	mov    %ecx,(%edx)
  80084e:	8b 55 08             	mov    0x8(%ebp),%edx
  800851:	88 10                	mov    %dl,(%eax)
}
  800853:	90                   	nop
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800862:	8b 45 0c             	mov    0xc(%ebp),%eax
  800865:	8d 50 ff             	lea    -0x1(%eax),%edx
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	01 d0                	add    %edx,%eax
  80086d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800870:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800877:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80087b:	74 06                	je     800883 <vsnprintf+0x2d>
  80087d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800881:	7f 07                	jg     80088a <vsnprintf+0x34>
		return -E_INVAL;
  800883:	b8 03 00 00 00       	mov    $0x3,%eax
  800888:	eb 20                	jmp    8008aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80088a:	ff 75 14             	pushl  0x14(%ebp)
  80088d:	ff 75 10             	pushl  0x10(%ebp)
  800890:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	68 20 08 80 00       	push   $0x800820
  800899:	e8 92 fb ff ff       	call   800430 <vprintfmt>
  80089e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008aa:	c9                   	leave  
  8008ab:	c3                   	ret    

008008ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b5:	83 c0 04             	add    $0x4,%eax
  8008b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008be:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c1:	50                   	push   %eax
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	ff 75 08             	pushl  0x8(%ebp)
  8008c8:	e8 89 ff ff ff       	call   800856 <vsnprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    

008008d8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8008de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008e2:	74 13                	je     8008f7 <readline+0x1f>
		cprintf("%s", prompt);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 08             	pushl  0x8(%ebp)
  8008ea:	68 90 1e 80 00       	push   $0x801e90
  8008ef:	e8 69 f9 ff ff       	call   80025d <cprintf>
  8008f4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8008f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8008fe:	83 ec 0c             	sub    $0xc,%esp
  800901:	6a 00                	push   $0x0
  800903:	e8 da 0e 00 00       	call   8017e2 <iscons>
  800908:	83 c4 10             	add    $0x10,%esp
  80090b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80090e:	e8 81 0e 00 00       	call   801794 <getchar>
  800913:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800916:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80091a:	79 22                	jns    80093e <readline+0x66>
			if (c != -E_EOF)
  80091c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800920:	0f 84 ad 00 00 00    	je     8009d3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 ec             	pushl  -0x14(%ebp)
  80092c:	68 93 1e 80 00       	push   $0x801e93
  800931:	e8 27 f9 ff ff       	call   80025d <cprintf>
  800936:	83 c4 10             	add    $0x10,%esp
			return;
  800939:	e9 95 00 00 00       	jmp    8009d3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80093e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800942:	7e 34                	jle    800978 <readline+0xa0>
  800944:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80094b:	7f 2b                	jg     800978 <readline+0xa0>
			if (echoing)
  80094d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800951:	74 0e                	je     800961 <readline+0x89>
				cputchar(c);
  800953:	83 ec 0c             	sub    $0xc,%esp
  800956:	ff 75 ec             	pushl  -0x14(%ebp)
  800959:	e8 ee 0d 00 00       	call   80174c <cputchar>
  80095e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800964:	8d 50 01             	lea    0x1(%eax),%edx
  800967:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80096a:	89 c2                	mov    %eax,%edx
  80096c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096f:	01 d0                	add    %edx,%eax
  800971:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800974:	88 10                	mov    %dl,(%eax)
  800976:	eb 56                	jmp    8009ce <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800978:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80097c:	75 1f                	jne    80099d <readline+0xc5>
  80097e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800982:	7e 19                	jle    80099d <readline+0xc5>
			if (echoing)
  800984:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800988:	74 0e                	je     800998 <readline+0xc0>
				cputchar(c);
  80098a:	83 ec 0c             	sub    $0xc,%esp
  80098d:	ff 75 ec             	pushl  -0x14(%ebp)
  800990:	e8 b7 0d 00 00       	call   80174c <cputchar>
  800995:	83 c4 10             	add    $0x10,%esp

			i--;
  800998:	ff 4d f4             	decl   -0xc(%ebp)
  80099b:	eb 31                	jmp    8009ce <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80099d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8009a1:	74 0a                	je     8009ad <readline+0xd5>
  8009a3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8009a7:	0f 85 61 ff ff ff    	jne    80090e <readline+0x36>
			if (echoing)
  8009ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009b1:	74 0e                	je     8009c1 <readline+0xe9>
				cputchar(c);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8009b9:	e8 8e 0d 00 00       	call   80174c <cputchar>
  8009be:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8009c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8009cc:	eb 06                	jmp    8009d4 <readline+0xfc>
		}
	}
  8009ce:	e9 3b ff ff ff       	jmp    80090e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8009d3:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8009d4:	c9                   	leave  
  8009d5:	c3                   	ret    

008009d6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009dc:	e8 cf 09 00 00       	call   8013b0 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8009e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009e5:	74 13                	je     8009fa <atomic_readline+0x24>
		cprintf("%s", prompt);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	68 90 1e 80 00       	push   $0x801e90
  8009f2:	e8 66 f8 ff ff       	call   80025d <cprintf>
  8009f7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a01:	83 ec 0c             	sub    $0xc,%esp
  800a04:	6a 00                	push   $0x0
  800a06:	e8 d7 0d 00 00       	call   8017e2 <iscons>
  800a0b:	83 c4 10             	add    $0x10,%esp
  800a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a11:	e8 7e 0d 00 00       	call   801794 <getchar>
  800a16:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a19:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a1d:	79 23                	jns    800a42 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800a1f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a23:	74 13                	je     800a38 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 ec             	pushl  -0x14(%ebp)
  800a2b:	68 93 1e 80 00       	push   $0x801e93
  800a30:	e8 28 f8 ff ff       	call   80025d <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800a38:	e8 8d 09 00 00       	call   8013ca <sys_enable_interrupt>
			return;
  800a3d:	e9 9a 00 00 00       	jmp    800adc <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a42:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a46:	7e 34                	jle    800a7c <atomic_readline+0xa6>
  800a48:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a4f:	7f 2b                	jg     800a7c <atomic_readline+0xa6>
			if (echoing)
  800a51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a55:	74 0e                	je     800a65 <atomic_readline+0x8f>
				cputchar(c);
  800a57:	83 ec 0c             	sub    $0xc,%esp
  800a5a:	ff 75 ec             	pushl  -0x14(%ebp)
  800a5d:	e8 ea 0c 00 00       	call   80174c <cputchar>
  800a62:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	8d 50 01             	lea    0x1(%eax),%edx
  800a6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a6e:	89 c2                	mov    %eax,%edx
  800a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a73:	01 d0                	add    %edx,%eax
  800a75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a78:	88 10                	mov    %dl,(%eax)
  800a7a:	eb 5b                	jmp    800ad7 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800a7c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a80:	75 1f                	jne    800aa1 <atomic_readline+0xcb>
  800a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a86:	7e 19                	jle    800aa1 <atomic_readline+0xcb>
			if (echoing)
  800a88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a8c:	74 0e                	je     800a9c <atomic_readline+0xc6>
				cputchar(c);
  800a8e:	83 ec 0c             	sub    $0xc,%esp
  800a91:	ff 75 ec             	pushl  -0x14(%ebp)
  800a94:	e8 b3 0c 00 00       	call   80174c <cputchar>
  800a99:	83 c4 10             	add    $0x10,%esp
			i--;
  800a9c:	ff 4d f4             	decl   -0xc(%ebp)
  800a9f:	eb 36                	jmp    800ad7 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800aa1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800aa5:	74 0a                	je     800ab1 <atomic_readline+0xdb>
  800aa7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800aab:	0f 85 60 ff ff ff    	jne    800a11 <atomic_readline+0x3b>
			if (echoing)
  800ab1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ab5:	74 0e                	je     800ac5 <atomic_readline+0xef>
				cputchar(c);
  800ab7:	83 ec 0c             	sub    $0xc,%esp
  800aba:	ff 75 ec             	pushl  -0x14(%ebp)
  800abd:	e8 8a 0c 00 00       	call   80174c <cputchar>
  800ac2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acb:	01 d0                	add    %edx,%eax
  800acd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800ad0:	e8 f5 08 00 00       	call   8013ca <sys_enable_interrupt>
			return;
  800ad5:	eb 05                	jmp    800adc <atomic_readline+0x106>
		}
	}
  800ad7:	e9 35 ff ff ff       	jmp    800a11 <atomic_readline+0x3b>
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    

00800ade <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aeb:	eb 06                	jmp    800af3 <strlen+0x15>
		n++;
  800aed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800af0:	ff 45 08             	incl   0x8(%ebp)
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8a 00                	mov    (%eax),%al
  800af8:	84 c0                	test   %al,%al
  800afa:	75 f1                	jne    800aed <strlen+0xf>
		n++;
	return n;
  800afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0e:	eb 09                	jmp    800b19 <strnlen+0x18>
		n++;
  800b10:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b13:	ff 45 08             	incl   0x8(%ebp)
  800b16:	ff 4d 0c             	decl   0xc(%ebp)
  800b19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1d:	74 09                	je     800b28 <strnlen+0x27>
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8a 00                	mov    (%eax),%al
  800b24:	84 c0                	test   %al,%al
  800b26:	75 e8                	jne    800b10 <strnlen+0xf>
		n++;
	return n;
  800b28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2b:	c9                   	leave  
  800b2c:	c3                   	ret    

00800b2d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b39:	90                   	nop
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	89 55 08             	mov    %edx,0x8(%ebp)
  800b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b49:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4c:	8a 12                	mov    (%edx),%dl
  800b4e:	88 10                	mov    %dl,(%eax)
  800b50:	8a 00                	mov    (%eax),%al
  800b52:	84 c0                	test   %al,%al
  800b54:	75 e4                	jne    800b3a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6e:	eb 1f                	jmp    800b8f <strncpy+0x34>
		*dst++ = *src;
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8d 50 01             	lea    0x1(%eax),%edx
  800b76:	89 55 08             	mov    %edx,0x8(%ebp)
  800b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7c:	8a 12                	mov    (%edx),%dl
  800b7e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b83:	8a 00                	mov    (%eax),%al
  800b85:	84 c0                	test   %al,%al
  800b87:	74 03                	je     800b8c <strncpy+0x31>
			src++;
  800b89:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8c:	ff 45 fc             	incl   -0x4(%ebp)
  800b8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b92:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b95:	72 d9                	jb     800b70 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b97:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bac:	74 30                	je     800bde <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bae:	eb 16                	jmp    800bc6 <strlcpy+0x2a>
			*dst++ = *src++;
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8d 50 01             	lea    0x1(%eax),%edx
  800bb6:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc2:	8a 12                	mov    (%edx),%dl
  800bc4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc6:	ff 4d 10             	decl   0x10(%ebp)
  800bc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcd:	74 09                	je     800bd8 <strlcpy+0x3c>
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	84 c0                	test   %al,%al
  800bd6:	75 d8                	jne    800bb0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bde:	8b 55 08             	mov    0x8(%ebp),%edx
  800be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be4:	29 c2                	sub    %eax,%edx
  800be6:	89 d0                	mov    %edx,%eax
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bed:	eb 06                	jmp    800bf5 <strcmp+0xb>
		p++, q++;
  800bef:	ff 45 08             	incl   0x8(%ebp)
  800bf2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	84 c0                	test   %al,%al
  800bfc:	74 0e                	je     800c0c <strcmp+0x22>
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8a 10                	mov    (%eax),%dl
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	38 c2                	cmp    %al,%dl
  800c0a:	74 e3                	je     800bef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8a 00                	mov    (%eax),%al
  800c11:	0f b6 d0             	movzbl %al,%edx
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	0f b6 c0             	movzbl %al,%eax
  800c1c:	29 c2                	sub    %eax,%edx
  800c1e:	89 d0                	mov    %edx,%eax
}
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c25:	eb 09                	jmp    800c30 <strncmp+0xe>
		n--, p++, q++;
  800c27:	ff 4d 10             	decl   0x10(%ebp)
  800c2a:	ff 45 08             	incl   0x8(%ebp)
  800c2d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c34:	74 17                	je     800c4d <strncmp+0x2b>
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	8a 00                	mov    (%eax),%al
  800c3b:	84 c0                	test   %al,%al
  800c3d:	74 0e                	je     800c4d <strncmp+0x2b>
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8a 10                	mov    (%eax),%dl
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	38 c2                	cmp    %al,%dl
  800c4b:	74 da                	je     800c27 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c51:	75 07                	jne    800c5a <strncmp+0x38>
		return 0;
  800c53:	b8 00 00 00 00       	mov    $0x0,%eax
  800c58:	eb 14                	jmp    800c6e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	0f b6 d0             	movzbl %al,%edx
  800c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	0f b6 c0             	movzbl %al,%eax
  800c6a:	29 c2                	sub    %eax,%edx
  800c6c:	89 d0                	mov    %edx,%eax
}
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 04             	sub    $0x4,%esp
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7c:	eb 12                	jmp    800c90 <strchr+0x20>
		if (*s == c)
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c86:	75 05                	jne    800c8d <strchr+0x1d>
			return (char *) s;
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	eb 11                	jmp    800c9e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	84 c0                	test   %al,%al
  800c97:	75 e5                	jne    800c7e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 04             	sub    $0x4,%esp
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cac:	eb 0d                	jmp    800cbb <strfind+0x1b>
		if (*s == c)
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8a 00                	mov    (%eax),%al
  800cb3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb6:	74 0e                	je     800cc6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8a 00                	mov    (%eax),%al
  800cc0:	84 c0                	test   %al,%al
  800cc2:	75 ea                	jne    800cae <strfind+0xe>
  800cc4:	eb 01                	jmp    800cc7 <strfind+0x27>
		if (*s == c)
			break;
  800cc6:	90                   	nop
	return (char *) s;
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cde:	eb 0e                	jmp    800cee <memset+0x22>
		*p++ = c;
  800ce0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce3:	8d 50 01             	lea    0x1(%eax),%edx
  800ce6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cee:	ff 4d f8             	decl   -0x8(%ebp)
  800cf1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf5:	79 e9                	jns    800ce0 <memset+0x14>
		*p++ = c;

	return v;
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0e:	eb 16                	jmp    800d26 <memcpy+0x2a>
		*d++ = *s++;
  800d10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d13:	8d 50 01             	lea    0x1(%eax),%edx
  800d16:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d22:	8a 12                	mov    (%edx),%dl
  800d24:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	75 dd                	jne    800d10 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d50:	73 50                	jae    800da2 <memmove+0x6a>
  800d52:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d55:	8b 45 10             	mov    0x10(%ebp),%eax
  800d58:	01 d0                	add    %edx,%eax
  800d5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5d:	76 43                	jbe    800da2 <memmove+0x6a>
		s += n;
  800d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d62:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d65:	8b 45 10             	mov    0x10(%ebp),%eax
  800d68:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d6b:	eb 10                	jmp    800d7d <memmove+0x45>
			*--d = *--s;
  800d6d:	ff 4d f8             	decl   -0x8(%ebp)
  800d70:	ff 4d fc             	decl   -0x4(%ebp)
  800d73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d76:	8a 10                	mov    (%eax),%dl
  800d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d83:	89 55 10             	mov    %edx,0x10(%ebp)
  800d86:	85 c0                	test   %eax,%eax
  800d88:	75 e3                	jne    800d6d <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d8a:	eb 23                	jmp    800daf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8f:	8d 50 01             	lea    0x1(%eax),%edx
  800d92:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9e:	8a 12                	mov    (%edx),%dl
  800da0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dab:	85 c0                	test   %eax,%eax
  800dad:	75 dd                	jne    800d8c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc6:	eb 2a                	jmp    800df2 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	8a 10                	mov    (%eax),%dl
  800dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	38 c2                	cmp    %al,%dl
  800dd4:	74 16                	je     800dec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	0f b6 d0             	movzbl %al,%edx
  800dde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	0f b6 c0             	movzbl %al,%eax
  800de6:	29 c2                	sub    %eax,%edx
  800de8:	89 d0                	mov    %edx,%eax
  800dea:	eb 18                	jmp    800e04 <memcmp+0x50>
		s1++, s2++;
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
  800def:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df2:	8b 45 10             	mov    0x10(%ebp),%eax
  800df5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	75 c9                	jne    800dc8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e17:	eb 15                	jmp    800e2e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8a 00                	mov    (%eax),%al
  800e1e:	0f b6 d0             	movzbl %al,%edx
  800e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e24:	0f b6 c0             	movzbl %al,%eax
  800e27:	39 c2                	cmp    %eax,%edx
  800e29:	74 0d                	je     800e38 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e2b:	ff 45 08             	incl   0x8(%ebp)
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e34:	72 e3                	jb     800e19 <memfind+0x13>
  800e36:	eb 01                	jmp    800e39 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e38:	90                   	nop
	return (void *) s;
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e4b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e52:	eb 03                	jmp    800e57 <strtol+0x19>
		s++;
  800e54:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	3c 20                	cmp    $0x20,%al
  800e5e:	74 f4                	je     800e54 <strtol+0x16>
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	3c 09                	cmp    $0x9,%al
  800e67:	74 eb                	je     800e54 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	3c 2b                	cmp    $0x2b,%al
  800e70:	75 05                	jne    800e77 <strtol+0x39>
		s++;
  800e72:	ff 45 08             	incl   0x8(%ebp)
  800e75:	eb 13                	jmp    800e8a <strtol+0x4c>
	else if (*s == '-')
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	3c 2d                	cmp    $0x2d,%al
  800e7e:	75 0a                	jne    800e8a <strtol+0x4c>
		s++, neg = 1;
  800e80:	ff 45 08             	incl   0x8(%ebp)
  800e83:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8e:	74 06                	je     800e96 <strtol+0x58>
  800e90:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e94:	75 20                	jne    800eb6 <strtol+0x78>
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3c 30                	cmp    $0x30,%al
  800e9d:	75 17                	jne    800eb6 <strtol+0x78>
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	40                   	inc    %eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	3c 78                	cmp    $0x78,%al
  800ea7:	75 0d                	jne    800eb6 <strtol+0x78>
		s += 2, base = 16;
  800ea9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ead:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb4:	eb 28                	jmp    800ede <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eba:	75 15                	jne    800ed1 <strtol+0x93>
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	3c 30                	cmp    $0x30,%al
  800ec3:	75 0c                	jne    800ed1 <strtol+0x93>
		s++, base = 8;
  800ec5:	ff 45 08             	incl   0x8(%ebp)
  800ec8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ecf:	eb 0d                	jmp    800ede <strtol+0xa0>
	else if (base == 0)
  800ed1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed5:	75 07                	jne    800ede <strtol+0xa0>
		base = 10;
  800ed7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	3c 2f                	cmp    $0x2f,%al
  800ee5:	7e 19                	jle    800f00 <strtol+0xc2>
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	3c 39                	cmp    $0x39,%al
  800eee:	7f 10                	jg     800f00 <strtol+0xc2>
			dig = *s - '0';
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f be c0             	movsbl %al,%eax
  800ef8:	83 e8 30             	sub    $0x30,%eax
  800efb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efe:	eb 42                	jmp    800f42 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	3c 60                	cmp    $0x60,%al
  800f07:	7e 19                	jle    800f22 <strtol+0xe4>
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	3c 7a                	cmp    $0x7a,%al
  800f10:	7f 10                	jg     800f22 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	0f be c0             	movsbl %al,%eax
  800f1a:	83 e8 57             	sub    $0x57,%eax
  800f1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f20:	eb 20                	jmp    800f42 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	3c 40                	cmp    $0x40,%al
  800f29:	7e 39                	jle    800f64 <strtol+0x126>
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	3c 5a                	cmp    $0x5a,%al
  800f32:	7f 30                	jg     800f64 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	0f be c0             	movsbl %al,%eax
  800f3c:	83 e8 37             	sub    $0x37,%eax
  800f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f48:	7d 19                	jge    800f63 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f4a:	ff 45 08             	incl   0x8(%ebp)
  800f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f50:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f54:	89 c2                	mov    %eax,%edx
  800f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f59:	01 d0                	add    %edx,%eax
  800f5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5e:	e9 7b ff ff ff       	jmp    800ede <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f63:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f68:	74 08                	je     800f72 <strtol+0x134>
		*endptr = (char *) s;
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f70:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f72:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f76:	74 07                	je     800f7f <strtol+0x141>
  800f78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7b:	f7 d8                	neg    %eax
  800f7d:	eb 03                	jmp    800f82 <strtol+0x144>
  800f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <ltostr>:

void
ltostr(long value, char *str)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f91:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9c:	79 13                	jns    800fb1 <ltostr+0x2d>
	{
		neg = 1;
  800f9e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb9:	99                   	cltd   
  800fba:	f7 f9                	idiv   %ecx
  800fbc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc2:	8d 50 01             	lea    0x1(%eax),%edx
  800fc5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	01 d0                	add    %edx,%eax
  800fcf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd2:	83 c2 30             	add    $0x30,%edx
  800fd5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fda:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fdf:	f7 e9                	imul   %ecx
  800fe1:	c1 fa 02             	sar    $0x2,%edx
  800fe4:	89 c8                	mov    %ecx,%eax
  800fe6:	c1 f8 1f             	sar    $0x1f,%eax
  800fe9:	29 c2                	sub    %eax,%edx
  800feb:	89 d0                	mov    %edx,%eax
  800fed:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ff0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff8:	f7 e9                	imul   %ecx
  800ffa:	c1 fa 02             	sar    $0x2,%edx
  800ffd:	89 c8                	mov    %ecx,%eax
  800fff:	c1 f8 1f             	sar    $0x1f,%eax
  801002:	29 c2                	sub    %eax,%edx
  801004:	89 d0                	mov    %edx,%eax
  801006:	c1 e0 02             	shl    $0x2,%eax
  801009:	01 d0                	add    %edx,%eax
  80100b:	01 c0                	add    %eax,%eax
  80100d:	29 c1                	sub    %eax,%ecx
  80100f:	89 ca                	mov    %ecx,%edx
  801011:	85 d2                	test   %edx,%edx
  801013:	75 9c                	jne    800fb1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801015:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	48                   	dec    %eax
  801020:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801023:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801027:	74 3d                	je     801066 <ltostr+0xe2>
		start = 1 ;
  801029:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801030:	eb 34                	jmp    801066 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	01 d0                	add    %edx,%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	01 c2                	add    %eax,%edx
  801047:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	01 c8                	add    %ecx,%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801053:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	01 c2                	add    %eax,%edx
  80105b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105e:	88 02                	mov    %al,(%edx)
		start++ ;
  801060:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801063:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801069:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106c:	7c c4                	jl     801032 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801071:	8b 45 0c             	mov    0xc(%ebp),%eax
  801074:	01 d0                	add    %edx,%eax
  801076:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801079:	90                   	nop
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

0080107c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801082:	ff 75 08             	pushl  0x8(%ebp)
  801085:	e8 54 fa ff ff       	call   800ade <strlen>
  80108a:	83 c4 04             	add    $0x4,%esp
  80108d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	e8 46 fa ff ff       	call   800ade <strlen>
  801098:	83 c4 04             	add    $0x4,%esp
  80109b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ac:	eb 17                	jmp    8010c5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	01 c8                	add    %ecx,%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c2:	ff 45 fc             	incl   -0x4(%ebp)
  8010c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010cb:	7c e1                	jl     8010ae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010db:	eb 1f                	jmp    8010fc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e0:	8d 50 01             	lea    0x1(%eax),%edx
  8010e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e6:	89 c2                	mov    %eax,%edx
  8010e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010eb:	01 c2                	add    %eax,%edx
  8010ed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 c8                	add    %ecx,%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f9:	ff 45 f8             	incl   -0x8(%ebp)
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801102:	7c d9                	jl     8010dd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801104:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 d0                	add    %edx,%eax
  80110c:	c6 00 00             	movb   $0x0,(%eax)
}
  80110f:	90                   	nop
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801115:	8b 45 14             	mov    0x14(%ebp),%eax
  801118:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111e:	8b 45 14             	mov    0x14(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80112a:	8b 45 10             	mov    0x10(%ebp),%eax
  80112d:	01 d0                	add    %edx,%eax
  80112f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801135:	eb 0c                	jmp    801143 <strsplit+0x31>
			*string++ = 0;
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8d 50 01             	lea    0x1(%eax),%edx
  80113d:	89 55 08             	mov    %edx,0x8(%ebp)
  801140:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	84 c0                	test   %al,%al
  80114a:	74 18                	je     801164 <strsplit+0x52>
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f be c0             	movsbl %al,%eax
  801154:	50                   	push   %eax
  801155:	ff 75 0c             	pushl  0xc(%ebp)
  801158:	e8 13 fb ff ff       	call   800c70 <strchr>
  80115d:	83 c4 08             	add    $0x8,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	75 d3                	jne    801137 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	84 c0                	test   %al,%al
  80116b:	74 5a                	je     8011c7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  80116d:	8b 45 14             	mov    0x14(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	83 f8 0f             	cmp    $0xf,%eax
  801175:	75 07                	jne    80117e <strsplit+0x6c>
		{
			return 0;
  801177:	b8 00 00 00 00       	mov    $0x0,%eax
  80117c:	eb 66                	jmp    8011e4 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117e:	8b 45 14             	mov    0x14(%ebp),%eax
  801181:	8b 00                	mov    (%eax),%eax
  801183:	8d 48 01             	lea    0x1(%eax),%ecx
  801186:	8b 55 14             	mov    0x14(%ebp),%edx
  801189:	89 0a                	mov    %ecx,(%edx)
  80118b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	01 c2                	add    %eax,%edx
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119c:	eb 03                	jmp    8011a1 <strsplit+0x8f>
			string++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	84 c0                	test   %al,%al
  8011a8:	74 8b                	je     801135 <strsplit+0x23>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	0f be c0             	movsbl %al,%eax
  8011b2:	50                   	push   %eax
  8011b3:	ff 75 0c             	pushl  0xc(%ebp)
  8011b6:	e8 b5 fa ff ff       	call   800c70 <strchr>
  8011bb:	83 c4 08             	add    $0x8,%esp
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	74 dc                	je     80119e <strsplit+0x8c>
			string++;
	}
  8011c2:	e9 6e ff ff ff       	jmp    801135 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	8b 00                	mov    (%eax),%eax
  8011cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	01 d0                	add    %edx,%eax
  8011d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	57                   	push   %edi
  8011ea:	56                   	push   %esi
  8011eb:	53                   	push   %ebx
  8011ec:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011fb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011fe:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801201:	cd 30                	int    $0x30
  801203:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801206:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5f                   	pop    %edi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	6a 00                	push   $0x0
  801219:	6a 00                	push   $0x0
  80121b:	6a 00                	push   $0x0
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	50                   	push   %eax
  801221:	6a 00                	push   $0x0
  801223:	e8 be ff ff ff       	call   8011e6 <syscall>
  801228:	83 c4 18             	add    $0x18,%esp
}
  80122b:	90                   	nop
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <sys_cgetc>:

int
sys_cgetc(void)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 01                	push   $0x1
  80123d:	e8 a4 ff ff ff       	call   8011e6 <syscall>
  801242:	83 c4 18             	add    $0x18,%esp
}
  801245:	c9                   	leave  
  801246:	c3                   	ret    

00801247 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	50                   	push   %eax
  801256:	6a 03                	push   $0x3
  801258:	e8 89 ff ff ff       	call   8011e6 <syscall>
  80125d:	83 c4 18             	add    $0x18,%esp
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 02                	push   $0x2
  801271:	e8 70 ff ff ff       	call   8011e6 <syscall>
  801276:	83 c4 18             	add    $0x18,%esp
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <sys_env_exit>:

void sys_env_exit(void)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 04                	push   $0x4
  80128a:	e8 57 ff ff ff       	call   8011e6 <syscall>
  80128f:	83 c4 18             	add    $0x18,%esp
}
  801292:	90                   	nop
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	52                   	push   %edx
  8012a5:	50                   	push   %eax
  8012a6:	6a 05                	push   $0x5
  8012a8:	e8 39 ff ff ff       	call   8011e6 <syscall>
  8012ad:	83 c4 18             	add    $0x18,%esp
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	56                   	push   %esi
  8012b6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8012ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	56                   	push   %esi
  8012c7:	53                   	push   %ebx
  8012c8:	51                   	push   %ecx
  8012c9:	52                   	push   %edx
  8012ca:	50                   	push   %eax
  8012cb:	6a 06                	push   $0x6
  8012cd:	e8 14 ff ff ff       	call   8011e6 <syscall>
  8012d2:	83 c4 18             	add    $0x18,%esp
}
  8012d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d8:	5b                   	pop    %ebx
  8012d9:	5e                   	pop    %esi
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    

008012dc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	52                   	push   %edx
  8012ec:	50                   	push   %eax
  8012ed:	6a 07                	push   $0x7
  8012ef:	e8 f2 fe ff ff       	call   8011e6 <syscall>
  8012f4:	83 c4 18             	add    $0x18,%esp
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    

008012f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	ff 75 08             	pushl  0x8(%ebp)
  801308:	6a 08                	push   $0x8
  80130a:	e8 d7 fe ff ff       	call   8011e6 <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 09                	push   $0x9
  801323:	e8 be fe ff ff       	call   8011e6 <syscall>
  801328:	83 c4 18             	add    $0x18,%esp
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 0a                	push   $0xa
  80133c:	e8 a5 fe ff ff       	call   8011e6 <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 0b                	push   $0xb
  801355:	e8 8c fe ff ff       	call   8011e6 <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	ff 75 08             	pushl  0x8(%ebp)
  80136e:	6a 0d                	push   $0xd
  801370:	e8 71 fe ff ff       	call   8011e6 <syscall>
  801375:	83 c4 18             	add    $0x18,%esp
	return;
  801378:	90                   	nop
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	ff 75 08             	pushl  0x8(%ebp)
  80138a:	6a 0e                	push   $0xe
  80138c:	e8 55 fe ff ff       	call   8011e6 <syscall>
  801391:	83 c4 18             	add    $0x18,%esp
	return ;
  801394:	90                   	nop
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 0c                	push   $0xc
  8013a6:	e8 3b fe ff ff       	call   8011e6 <syscall>
  8013ab:	83 c4 18             	add    $0x18,%esp
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 10                	push   $0x10
  8013bf:	e8 22 fe ff ff       	call   8011e6 <syscall>
  8013c4:	83 c4 18             	add    $0x18,%esp
}
  8013c7:	90                   	nop
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    

008013ca <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 11                	push   $0x11
  8013d9:	e8 08 fe ff ff       	call   8011e6 <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
}
  8013e1:	90                   	nop
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    

008013e4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	83 ec 04             	sub    $0x4,%esp
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013f0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	50                   	push   %eax
  8013fd:	6a 12                	push   $0x12
  8013ff:	e8 e2 fd ff ff       	call   8011e6 <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
}
  801407:	90                   	nop
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 13                	push   $0x13
  801419:	e8 c8 fd ff ff       	call   8011e6 <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	90                   	nop
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	ff 75 0c             	pushl  0xc(%ebp)
  801433:	50                   	push   %eax
  801434:	6a 14                	push   $0x14
  801436:	e8 ab fd ff ff       	call   8011e6 <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	50                   	push   %eax
  80144f:	6a 17                	push   $0x17
  801451:	e8 90 fd ff ff       	call   8011e6 <syscall>
  801456:	83 c4 18             	add    $0x18,%esp
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	50                   	push   %eax
  80146a:	6a 15                	push   $0x15
  80146c:	e8 75 fd ff ff       	call   8011e6 <syscall>
  801471:	83 c4 18             	add    $0x18,%esp
}
  801474:	90                   	nop
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	50                   	push   %eax
  801486:	6a 16                	push   $0x16
  801488:	e8 59 fd ff ff       	call   8011e6 <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
}
  801490:	90                   	nop
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 04             	sub    $0x4,%esp
  801499:	8b 45 10             	mov    0x10(%ebp),%eax
  80149c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80149f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	51                   	push   %ecx
  8014ac:	52                   	push   %edx
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	6a 18                	push   $0x18
  8014b3:	e8 2e fd ff ff       	call   8011e6 <syscall>
  8014b8:	83 c4 18             	add    $0x18,%esp
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8014c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	52                   	push   %edx
  8014cd:	50                   	push   %eax
  8014ce:	6a 19                	push   $0x19
  8014d0:	e8 11 fd ff ff       	call   8011e6 <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	50                   	push   %eax
  8014e9:	6a 1a                	push   $0x1a
  8014eb:	e8 f6 fc ff ff       	call   8011e6 <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 1b                	push   $0x1b
  801504:	e8 dd fc ff ff       	call   8011e6 <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 1c                	push   $0x1c
  80151d:	e8 c4 fc ff ff       	call   8011e6 <syscall>
  801522:	83 c4 18             	add    $0x18,%esp
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	50                   	push   %eax
  801537:	6a 1d                	push   $0x1d
  801539:	e8 a8 fc ff ff       	call   8011e6 <syscall>
  80153e:	83 c4 18             	add    $0x18,%esp
}
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	50                   	push   %eax
  801552:	6a 1e                	push   $0x1e
  801554:	e8 8d fc ff ff       	call   8011e6 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	90                   	nop
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	50                   	push   %eax
  80156e:	6a 1f                	push   $0x1f
  801570:	e8 71 fc ff ff       	call   8011e6 <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
}
  801578:	90                   	nop
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801581:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801584:	8d 50 04             	lea    0x4(%eax),%edx
  801587:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	52                   	push   %edx
  801591:	50                   	push   %eax
  801592:	6a 20                	push   $0x20
  801594:	e8 4d fc ff ff       	call   8011e6 <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
	return result;
  80159c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a5:	89 01                	mov    %eax,(%ecx)
  8015a7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	c9                   	leave  
  8015ae:	c2 04 00             	ret    $0x4

008015b1 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	ff 75 10             	pushl  0x10(%ebp)
  8015bb:	ff 75 0c             	pushl  0xc(%ebp)
  8015be:	ff 75 08             	pushl  0x8(%ebp)
  8015c1:	6a 0f                	push   $0xf
  8015c3:	e8 1e fc ff ff       	call   8011e6 <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015cb:	90                   	nop
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_rcr2>:
uint32 sys_rcr2()
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 21                	push   $0x21
  8015dd:	e8 04 fc ff ff       	call   8011e6 <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015f3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	50                   	push   %eax
  801600:	6a 22                	push   $0x22
  801602:	e8 df fb ff ff       	call   8011e6 <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
	return ;
  80160a:	90                   	nop
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <rsttst>:
void rsttst()
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 24                	push   $0x24
  80161c:	e8 c5 fb ff ff       	call   8011e6 <syscall>
  801621:	83 c4 18             	add    $0x18,%esp
	return ;
  801624:	90                   	nop
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	8b 45 14             	mov    0x14(%ebp),%eax
  801630:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801633:	8b 55 18             	mov    0x18(%ebp),%edx
  801636:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80163a:	52                   	push   %edx
  80163b:	50                   	push   %eax
  80163c:	ff 75 10             	pushl  0x10(%ebp)
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	ff 75 08             	pushl  0x8(%ebp)
  801645:	6a 23                	push   $0x23
  801647:	e8 9a fb ff ff       	call   8011e6 <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
	return ;
  80164f:	90                   	nop
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <chktst>:
void chktst(uint32 n)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	ff 75 08             	pushl  0x8(%ebp)
  801660:	6a 25                	push   $0x25
  801662:	e8 7f fb ff ff       	call   8011e6 <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
	return ;
  80166a:	90                   	nop
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 26                	push   $0x26
  80167f:	e8 62 fb ff ff       	call   8011e6 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
  801687:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80168a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80168e:	75 07                	jne    801697 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801690:	b8 01 00 00 00       	mov    $0x1,%eax
  801695:	eb 05                	jmp    80169c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 26                	push   $0x26
  8016b0:	e8 31 fb ff ff       	call   8011e6 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
  8016b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016bb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016bf:	75 07                	jne    8016c8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8016c6:	eb 05                	jmp    8016cd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 26                	push   $0x26
  8016e1:	e8 00 fb ff ff       	call   8011e6 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
  8016e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016ec:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016f0:	75 07                	jne    8016f9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f7:	eb 05                	jmp    8016fe <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 26                	push   $0x26
  801712:	e8 cf fa ff ff       	call   8011e6 <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
  80171a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80171d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801721:	75 07                	jne    80172a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801723:	b8 01 00 00 00       	mov    $0x1,%eax
  801728:	eb 05                	jmp    80172f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	ff 75 08             	pushl  0x8(%ebp)
  80173f:	6a 27                	push   $0x27
  801741:	e8 a0 fa ff ff       	call   8011e6 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
	return ;
  801749:	90                   	nop
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801758:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80175c:	83 ec 0c             	sub    $0xc,%esp
  80175f:	50                   	push   %eax
  801760:	e8 7f fc ff ff       	call   8013e4 <sys_cputc>
  801765:	83 c4 10             	add    $0x10,%esp
}
  801768:	90                   	nop
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801771:	e8 3a fc ff ff       	call   8013b0 <sys_disable_interrupt>
	char c = ch;
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80177c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801780:	83 ec 0c             	sub    $0xc,%esp
  801783:	50                   	push   %eax
  801784:	e8 5b fc ff ff       	call   8013e4 <sys_cputc>
  801789:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80178c:	e8 39 fc ff ff       	call   8013ca <sys_enable_interrupt>
}
  801791:	90                   	nop
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <getchar>:

int
getchar(void)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80179a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8017a1:	eb 08                	jmp    8017ab <getchar+0x17>
	{
		c = sys_cgetc();
  8017a3:	e8 86 fa ff ff       	call   80122e <sys_cgetc>
  8017a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8017ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017af:	74 f2                	je     8017a3 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <atomic_getchar>:

int
atomic_getchar(void)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8017bc:	e8 ef fb ff ff       	call   8013b0 <sys_disable_interrupt>
	int c=0;
  8017c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8017c8:	eb 08                	jmp    8017d2 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8017ca:	e8 5f fa ff ff       	call   80122e <sys_cgetc>
  8017cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8017d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017d6:	74 f2                	je     8017ca <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8017d8:	e8 ed fb ff ff       	call   8013ca <sys_enable_interrupt>
	return c;
  8017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <iscons>:

int iscons(int fdnum)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8017e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017ea:	5d                   	pop    %ebp
  8017eb:	c3                   	ret    

008017ec <__udivdi3>:
  8017ec:	55                   	push   %ebp
  8017ed:	57                   	push   %edi
  8017ee:	56                   	push   %esi
  8017ef:	53                   	push   %ebx
  8017f0:	83 ec 1c             	sub    $0x1c,%esp
  8017f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8017f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8017fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801803:	89 ca                	mov    %ecx,%edx
  801805:	89 f8                	mov    %edi,%eax
  801807:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80180b:	85 f6                	test   %esi,%esi
  80180d:	75 2d                	jne    80183c <__udivdi3+0x50>
  80180f:	39 cf                	cmp    %ecx,%edi
  801811:	77 65                	ja     801878 <__udivdi3+0x8c>
  801813:	89 fd                	mov    %edi,%ebp
  801815:	85 ff                	test   %edi,%edi
  801817:	75 0b                	jne    801824 <__udivdi3+0x38>
  801819:	b8 01 00 00 00       	mov    $0x1,%eax
  80181e:	31 d2                	xor    %edx,%edx
  801820:	f7 f7                	div    %edi
  801822:	89 c5                	mov    %eax,%ebp
  801824:	31 d2                	xor    %edx,%edx
  801826:	89 c8                	mov    %ecx,%eax
  801828:	f7 f5                	div    %ebp
  80182a:	89 c1                	mov    %eax,%ecx
  80182c:	89 d8                	mov    %ebx,%eax
  80182e:	f7 f5                	div    %ebp
  801830:	89 cf                	mov    %ecx,%edi
  801832:	89 fa                	mov    %edi,%edx
  801834:	83 c4 1c             	add    $0x1c,%esp
  801837:	5b                   	pop    %ebx
  801838:	5e                   	pop    %esi
  801839:	5f                   	pop    %edi
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    
  80183c:	39 ce                	cmp    %ecx,%esi
  80183e:	77 28                	ja     801868 <__udivdi3+0x7c>
  801840:	0f bd fe             	bsr    %esi,%edi
  801843:	83 f7 1f             	xor    $0x1f,%edi
  801846:	75 40                	jne    801888 <__udivdi3+0x9c>
  801848:	39 ce                	cmp    %ecx,%esi
  80184a:	72 0a                	jb     801856 <__udivdi3+0x6a>
  80184c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801850:	0f 87 9e 00 00 00    	ja     8018f4 <__udivdi3+0x108>
  801856:	b8 01 00 00 00       	mov    $0x1,%eax
  80185b:	89 fa                	mov    %edi,%edx
  80185d:	83 c4 1c             	add    $0x1c,%esp
  801860:	5b                   	pop    %ebx
  801861:	5e                   	pop    %esi
  801862:	5f                   	pop    %edi
  801863:	5d                   	pop    %ebp
  801864:	c3                   	ret    
  801865:	8d 76 00             	lea    0x0(%esi),%esi
  801868:	31 ff                	xor    %edi,%edi
  80186a:	31 c0                	xor    %eax,%eax
  80186c:	89 fa                	mov    %edi,%edx
  80186e:	83 c4 1c             	add    $0x1c,%esp
  801871:	5b                   	pop    %ebx
  801872:	5e                   	pop    %esi
  801873:	5f                   	pop    %edi
  801874:	5d                   	pop    %ebp
  801875:	c3                   	ret    
  801876:	66 90                	xchg   %ax,%ax
  801878:	89 d8                	mov    %ebx,%eax
  80187a:	f7 f7                	div    %edi
  80187c:	31 ff                	xor    %edi,%edi
  80187e:	89 fa                	mov    %edi,%edx
  801880:	83 c4 1c             	add    $0x1c,%esp
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5f                   	pop    %edi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    
  801888:	bd 20 00 00 00       	mov    $0x20,%ebp
  80188d:	89 eb                	mov    %ebp,%ebx
  80188f:	29 fb                	sub    %edi,%ebx
  801891:	89 f9                	mov    %edi,%ecx
  801893:	d3 e6                	shl    %cl,%esi
  801895:	89 c5                	mov    %eax,%ebp
  801897:	88 d9                	mov    %bl,%cl
  801899:	d3 ed                	shr    %cl,%ebp
  80189b:	89 e9                	mov    %ebp,%ecx
  80189d:	09 f1                	or     %esi,%ecx
  80189f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018a3:	89 f9                	mov    %edi,%ecx
  8018a5:	d3 e0                	shl    %cl,%eax
  8018a7:	89 c5                	mov    %eax,%ebp
  8018a9:	89 d6                	mov    %edx,%esi
  8018ab:	88 d9                	mov    %bl,%cl
  8018ad:	d3 ee                	shr    %cl,%esi
  8018af:	89 f9                	mov    %edi,%ecx
  8018b1:	d3 e2                	shl    %cl,%edx
  8018b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018b7:	88 d9                	mov    %bl,%cl
  8018b9:	d3 e8                	shr    %cl,%eax
  8018bb:	09 c2                	or     %eax,%edx
  8018bd:	89 d0                	mov    %edx,%eax
  8018bf:	89 f2                	mov    %esi,%edx
  8018c1:	f7 74 24 0c          	divl   0xc(%esp)
  8018c5:	89 d6                	mov    %edx,%esi
  8018c7:	89 c3                	mov    %eax,%ebx
  8018c9:	f7 e5                	mul    %ebp
  8018cb:	39 d6                	cmp    %edx,%esi
  8018cd:	72 19                	jb     8018e8 <__udivdi3+0xfc>
  8018cf:	74 0b                	je     8018dc <__udivdi3+0xf0>
  8018d1:	89 d8                	mov    %ebx,%eax
  8018d3:	31 ff                	xor    %edi,%edi
  8018d5:	e9 58 ff ff ff       	jmp    801832 <__udivdi3+0x46>
  8018da:	66 90                	xchg   %ax,%ax
  8018dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8018e0:	89 f9                	mov    %edi,%ecx
  8018e2:	d3 e2                	shl    %cl,%edx
  8018e4:	39 c2                	cmp    %eax,%edx
  8018e6:	73 e9                	jae    8018d1 <__udivdi3+0xe5>
  8018e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8018eb:	31 ff                	xor    %edi,%edi
  8018ed:	e9 40 ff ff ff       	jmp    801832 <__udivdi3+0x46>
  8018f2:	66 90                	xchg   %ax,%ax
  8018f4:	31 c0                	xor    %eax,%eax
  8018f6:	e9 37 ff ff ff       	jmp    801832 <__udivdi3+0x46>
  8018fb:	90                   	nop

008018fc <__umoddi3>:
  8018fc:	55                   	push   %ebp
  8018fd:	57                   	push   %edi
  8018fe:	56                   	push   %esi
  8018ff:	53                   	push   %ebx
  801900:	83 ec 1c             	sub    $0x1c,%esp
  801903:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801907:	8b 74 24 34          	mov    0x34(%esp),%esi
  80190b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80190f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801913:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801917:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80191b:	89 f3                	mov    %esi,%ebx
  80191d:	89 fa                	mov    %edi,%edx
  80191f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801923:	89 34 24             	mov    %esi,(%esp)
  801926:	85 c0                	test   %eax,%eax
  801928:	75 1a                	jne    801944 <__umoddi3+0x48>
  80192a:	39 f7                	cmp    %esi,%edi
  80192c:	0f 86 a2 00 00 00    	jbe    8019d4 <__umoddi3+0xd8>
  801932:	89 c8                	mov    %ecx,%eax
  801934:	89 f2                	mov    %esi,%edx
  801936:	f7 f7                	div    %edi
  801938:	89 d0                	mov    %edx,%eax
  80193a:	31 d2                	xor    %edx,%edx
  80193c:	83 c4 1c             	add    $0x1c,%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5f                   	pop    %edi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    
  801944:	39 f0                	cmp    %esi,%eax
  801946:	0f 87 ac 00 00 00    	ja     8019f8 <__umoddi3+0xfc>
  80194c:	0f bd e8             	bsr    %eax,%ebp
  80194f:	83 f5 1f             	xor    $0x1f,%ebp
  801952:	0f 84 ac 00 00 00    	je     801a04 <__umoddi3+0x108>
  801958:	bf 20 00 00 00       	mov    $0x20,%edi
  80195d:	29 ef                	sub    %ebp,%edi
  80195f:	89 fe                	mov    %edi,%esi
  801961:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801965:	89 e9                	mov    %ebp,%ecx
  801967:	d3 e0                	shl    %cl,%eax
  801969:	89 d7                	mov    %edx,%edi
  80196b:	89 f1                	mov    %esi,%ecx
  80196d:	d3 ef                	shr    %cl,%edi
  80196f:	09 c7                	or     %eax,%edi
  801971:	89 e9                	mov    %ebp,%ecx
  801973:	d3 e2                	shl    %cl,%edx
  801975:	89 14 24             	mov    %edx,(%esp)
  801978:	89 d8                	mov    %ebx,%eax
  80197a:	d3 e0                	shl    %cl,%eax
  80197c:	89 c2                	mov    %eax,%edx
  80197e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801982:	d3 e0                	shl    %cl,%eax
  801984:	89 44 24 04          	mov    %eax,0x4(%esp)
  801988:	8b 44 24 08          	mov    0x8(%esp),%eax
  80198c:	89 f1                	mov    %esi,%ecx
  80198e:	d3 e8                	shr    %cl,%eax
  801990:	09 d0                	or     %edx,%eax
  801992:	d3 eb                	shr    %cl,%ebx
  801994:	89 da                	mov    %ebx,%edx
  801996:	f7 f7                	div    %edi
  801998:	89 d3                	mov    %edx,%ebx
  80199a:	f7 24 24             	mull   (%esp)
  80199d:	89 c6                	mov    %eax,%esi
  80199f:	89 d1                	mov    %edx,%ecx
  8019a1:	39 d3                	cmp    %edx,%ebx
  8019a3:	0f 82 87 00 00 00    	jb     801a30 <__umoddi3+0x134>
  8019a9:	0f 84 91 00 00 00    	je     801a40 <__umoddi3+0x144>
  8019af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019b3:	29 f2                	sub    %esi,%edx
  8019b5:	19 cb                	sbb    %ecx,%ebx
  8019b7:	89 d8                	mov    %ebx,%eax
  8019b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019bd:	d3 e0                	shl    %cl,%eax
  8019bf:	89 e9                	mov    %ebp,%ecx
  8019c1:	d3 ea                	shr    %cl,%edx
  8019c3:	09 d0                	or     %edx,%eax
  8019c5:	89 e9                	mov    %ebp,%ecx
  8019c7:	d3 eb                	shr    %cl,%ebx
  8019c9:	89 da                	mov    %ebx,%edx
  8019cb:	83 c4 1c             	add    $0x1c,%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5e                   	pop    %esi
  8019d0:	5f                   	pop    %edi
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    
  8019d3:	90                   	nop
  8019d4:	89 fd                	mov    %edi,%ebp
  8019d6:	85 ff                	test   %edi,%edi
  8019d8:	75 0b                	jne    8019e5 <__umoddi3+0xe9>
  8019da:	b8 01 00 00 00       	mov    $0x1,%eax
  8019df:	31 d2                	xor    %edx,%edx
  8019e1:	f7 f7                	div    %edi
  8019e3:	89 c5                	mov    %eax,%ebp
  8019e5:	89 f0                	mov    %esi,%eax
  8019e7:	31 d2                	xor    %edx,%edx
  8019e9:	f7 f5                	div    %ebp
  8019eb:	89 c8                	mov    %ecx,%eax
  8019ed:	f7 f5                	div    %ebp
  8019ef:	89 d0                	mov    %edx,%eax
  8019f1:	e9 44 ff ff ff       	jmp    80193a <__umoddi3+0x3e>
  8019f6:	66 90                	xchg   %ax,%ax
  8019f8:	89 c8                	mov    %ecx,%eax
  8019fa:	89 f2                	mov    %esi,%edx
  8019fc:	83 c4 1c             	add    $0x1c,%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5f                   	pop    %edi
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    
  801a04:	3b 04 24             	cmp    (%esp),%eax
  801a07:	72 06                	jb     801a0f <__umoddi3+0x113>
  801a09:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a0d:	77 0f                	ja     801a1e <__umoddi3+0x122>
  801a0f:	89 f2                	mov    %esi,%edx
  801a11:	29 f9                	sub    %edi,%ecx
  801a13:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a17:	89 14 24             	mov    %edx,(%esp)
  801a1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a1e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a22:	8b 14 24             	mov    (%esp),%edx
  801a25:	83 c4 1c             	add    $0x1c,%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5f                   	pop    %edi
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    
  801a2d:	8d 76 00             	lea    0x0(%esi),%esi
  801a30:	2b 04 24             	sub    (%esp),%eax
  801a33:	19 fa                	sbb    %edi,%edx
  801a35:	89 d1                	mov    %edx,%ecx
  801a37:	89 c6                	mov    %eax,%esi
  801a39:	e9 71 ff ff ff       	jmp    8019af <__umoddi3+0xb3>
  801a3e:	66 90                	xchg   %ax,%ax
  801a40:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a44:	72 ea                	jb     801a30 <__umoddi3+0x134>
  801a46:	89 d9                	mov    %ebx,%ecx
  801a48:	e9 62 ff ff ff       	jmp    8019af <__umoddi3+0xb3>
