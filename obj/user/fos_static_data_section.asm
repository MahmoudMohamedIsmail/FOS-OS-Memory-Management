
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 20 17 80 00       	push   $0x801720
  800046:	e8 a8 01 00 00       	call   8001f3 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800057:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005b:	7e 0a                	jle    800067 <libmain+0x16>
		binaryname = argv[0];
  80005d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800060:	8b 00                	mov    (%eax),%eax
  800062:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800067:	83 ec 08             	sub    $0x8,%esp
  80006a:	ff 75 0c             	pushl  0xc(%ebp)
  80006d:	ff 75 08             	pushl  0x8(%ebp)
  800070:	e8 c3 ff ff ff       	call   800038 <_main>
  800075:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800078:	e8 4f 0f 00 00       	call   800fcc <sys_getenvid>
  80007d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800080:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800083:	89 d0                	mov    %edx,%eax
  800085:	c1 e0 03             	shl    $0x3,%eax
  800088:	01 d0                	add    %edx,%eax
  80008a:	01 c0                	add    %eax,%eax
  80008c:	01 d0                	add    %edx,%eax
  80008e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800095:	01 d0                	add    %edx,%eax
  800097:	c1 e0 03             	shl    $0x3,%eax
  80009a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8000a2:	e8 73 10 00 00       	call   80111a <sys_disable_interrupt>
		cprintf("**************************************\n");
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	68 64 17 80 00       	push   $0x801764
  8000af:	e8 19 01 00 00       	call   8001cd <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8000b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000ba:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	50                   	push   %eax
  8000c4:	68 8c 17 80 00       	push   $0x80178c
  8000c9:	e8 ff 00 00 00       	call   8001cd <cprintf>
  8000ce:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	68 64 17 80 00       	push   $0x801764
  8000d9:	e8 ef 00 00 00       	call   8001cd <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8000e1:	e8 4e 10 00 00       	call   801134 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8000e6:	e8 19 00 00 00       	call   800104 <exit>
}
  8000eb:	90                   	nop
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    

008000ee <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8000ee:	55                   	push   %ebp
  8000ef:	89 e5                	mov    %esp,%ebp
  8000f1:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	6a 00                	push   $0x0
  8000f9:	e8 b3 0e 00 00       	call   800fb1 <sys_env_destroy>
  8000fe:	83 c4 10             	add    $0x10,%esp
}
  800101:	90                   	nop
  800102:	c9                   	leave  
  800103:	c3                   	ret    

00800104 <exit>:

void
exit(void)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80010a:	e8 d6 0e 00 00       	call   800fe5 <sys_env_exit>
}
  80010f:	90                   	nop
  800110:	c9                   	leave  
  800111:	c3                   	ret    

00800112 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011b:	8b 00                	mov    (%eax),%eax
  80011d:	8d 48 01             	lea    0x1(%eax),%ecx
  800120:	8b 55 0c             	mov    0xc(%ebp),%edx
  800123:	89 0a                	mov    %ecx,(%edx)
  800125:	8b 55 08             	mov    0x8(%ebp),%edx
  800128:	88 d1                	mov    %dl,%cl
  80012a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80012d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8b 00                	mov    (%eax),%eax
  800136:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013b:	75 23                	jne    800160 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  80013d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800140:	8b 00                	mov    (%eax),%eax
  800142:	89 c2                	mov    %eax,%edx
  800144:	8b 45 0c             	mov    0xc(%ebp),%eax
  800147:	83 c0 08             	add    $0x8,%eax
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	52                   	push   %edx
  80014e:	50                   	push   %eax
  80014f:	e8 27 0e 00 00       	call   800f7b <sys_cputs>
  800154:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800160:	8b 45 0c             	mov    0xc(%ebp),%eax
  800163:	8b 40 04             	mov    0x4(%eax),%eax
  800166:	8d 50 01             	lea    0x1(%eax),%edx
  800169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80016f:	90                   	nop
  800170:	c9                   	leave  
  800171:	c3                   	ret    

00800172 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80017b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800182:	00 00 00 
	b.cnt = 0;
  800185:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80018c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80018f:	ff 75 0c             	pushl  0xc(%ebp)
  800192:	ff 75 08             	pushl  0x8(%ebp)
  800195:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80019b:	50                   	push   %eax
  80019c:	68 12 01 80 00       	push   $0x800112
  8001a1:	e8 fa 01 00 00       	call   8003a0 <vprintfmt>
  8001a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8001a9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	50                   	push   %eax
  8001b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b9:	83 c0 08             	add    $0x8,%eax
  8001bc:	50                   	push   %eax
  8001bd:	e8 b9 0d 00 00       	call   800f7b <sys_cputs>
  8001c2:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8001c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    

008001cd <cprintf>:

int cprintf(const char *fmt, ...) {
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8001d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	ff 75 f4             	pushl  -0xc(%ebp)
  8001e2:	50                   	push   %eax
  8001e3:	e8 8a ff ff ff       	call   800172 <vcprintf>
  8001e8:	83 c4 10             	add    $0x10,%esp
  8001eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8001ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    

008001f3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001f9:	e8 1c 0f 00 00       	call   80111a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fe:	8d 45 0c             	lea    0xc(%ebp),%eax
  800201:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800204:	8b 45 08             	mov    0x8(%ebp),%eax
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 f4             	pushl  -0xc(%ebp)
  80020d:	50                   	push   %eax
  80020e:	e8 5f ff ff ff       	call   800172 <vcprintf>
  800213:	83 c4 10             	add    $0x10,%esp
  800216:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800219:	e8 16 0f 00 00       	call   801134 <sys_enable_interrupt>
	return cnt;
  80021e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	53                   	push   %ebx
  800227:	83 ec 14             	sub    $0x14,%esp
  80022a:	8b 45 10             	mov    0x10(%ebp),%eax
  80022d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800230:	8b 45 14             	mov    0x14(%ebp),%eax
  800233:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800236:	8b 45 18             	mov    0x18(%ebp),%eax
  800239:	ba 00 00 00 00       	mov    $0x0,%edx
  80023e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800241:	77 55                	ja     800298 <printnum+0x75>
  800243:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800246:	72 05                	jb     80024d <printnum+0x2a>
  800248:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80024b:	77 4b                	ja     800298 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80024d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800250:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800253:	8b 45 18             	mov    0x18(%ebp),%eax
  800256:	ba 00 00 00 00       	mov    $0x0,%edx
  80025b:	52                   	push   %edx
  80025c:	50                   	push   %eax
  80025d:	ff 75 f4             	pushl  -0xc(%ebp)
  800260:	ff 75 f0             	pushl  -0x10(%ebp)
  800263:	e8 50 12 00 00       	call   8014b8 <__udivdi3>
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	ff 75 20             	pushl  0x20(%ebp)
  800271:	53                   	push   %ebx
  800272:	ff 75 18             	pushl  0x18(%ebp)
  800275:	52                   	push   %edx
  800276:	50                   	push   %eax
  800277:	ff 75 0c             	pushl  0xc(%ebp)
  80027a:	ff 75 08             	pushl  0x8(%ebp)
  80027d:	e8 a1 ff ff ff       	call   800223 <printnum>
  800282:	83 c4 20             	add    $0x20,%esp
  800285:	eb 1a                	jmp    8002a1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	ff 75 0c             	pushl  0xc(%ebp)
  80028d:	ff 75 20             	pushl  0x20(%ebp)
  800290:	8b 45 08             	mov    0x8(%ebp),%eax
  800293:	ff d0                	call   *%eax
  800295:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800298:	ff 4d 1c             	decl   0x1c(%ebp)
  80029b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80029f:	7f e6                	jg     800287 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002af:	53                   	push   %ebx
  8002b0:	51                   	push   %ecx
  8002b1:	52                   	push   %edx
  8002b2:	50                   	push   %eax
  8002b3:	e8 10 13 00 00       	call   8015c8 <__umoddi3>
  8002b8:	83 c4 10             	add    $0x10,%esp
  8002bb:	05 d4 19 80 00       	add    $0x8019d4,%eax
  8002c0:	8a 00                	mov    (%eax),%al
  8002c2:	0f be c0             	movsbl %al,%eax
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	ff 75 0c             	pushl  0xc(%ebp)
  8002cb:	50                   	push   %eax
  8002cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cf:	ff d0                	call   *%eax
  8002d1:	83 c4 10             	add    $0x10,%esp
}
  8002d4:	90                   	nop
  8002d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002dd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8002e1:	7e 1c                	jle    8002ff <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	8b 00                	mov    (%eax),%eax
  8002e8:	8d 50 08             	lea    0x8(%eax),%edx
  8002eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ee:	89 10                	mov    %edx,(%eax)
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	8b 00                	mov    (%eax),%eax
  8002f5:	83 e8 08             	sub    $0x8,%eax
  8002f8:	8b 50 04             	mov    0x4(%eax),%edx
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	eb 40                	jmp    80033f <getuint+0x65>
	else if (lflag)
  8002ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800303:	74 1e                	je     800323 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800305:	8b 45 08             	mov    0x8(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 50 04             	lea    0x4(%eax),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	89 10                	mov    %edx,(%eax)
  800312:	8b 45 08             	mov    0x8(%ebp),%eax
  800315:	8b 00                	mov    (%eax),%eax
  800317:	83 e8 04             	sub    $0x4,%eax
  80031a:	8b 00                	mov    (%eax),%eax
  80031c:	ba 00 00 00 00       	mov    $0x0,%edx
  800321:	eb 1c                	jmp    80033f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800323:	8b 45 08             	mov    0x8(%ebp),%eax
  800326:	8b 00                	mov    (%eax),%eax
  800328:	8d 50 04             	lea    0x4(%eax),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	89 10                	mov    %edx,(%eax)
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	8b 00                	mov    (%eax),%eax
  800335:	83 e8 04             	sub    $0x4,%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80033f:	5d                   	pop    %ebp
  800340:	c3                   	ret    

00800341 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800344:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800348:	7e 1c                	jle    800366 <getint+0x25>
		return va_arg(*ap, long long);
  80034a:	8b 45 08             	mov    0x8(%ebp),%eax
  80034d:	8b 00                	mov    (%eax),%eax
  80034f:	8d 50 08             	lea    0x8(%eax),%edx
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	89 10                	mov    %edx,(%eax)
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	8b 00                	mov    (%eax),%eax
  80035c:	83 e8 08             	sub    $0x8,%eax
  80035f:	8b 50 04             	mov    0x4(%eax),%edx
  800362:	8b 00                	mov    (%eax),%eax
  800364:	eb 38                	jmp    80039e <getint+0x5d>
	else if (lflag)
  800366:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80036a:	74 1a                	je     800386 <getint+0x45>
		return va_arg(*ap, long);
  80036c:	8b 45 08             	mov    0x8(%ebp),%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	8d 50 04             	lea    0x4(%eax),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	89 10                	mov    %edx,(%eax)
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	8b 00                	mov    (%eax),%eax
  80037e:	83 e8 04             	sub    $0x4,%eax
  800381:	8b 00                	mov    (%eax),%eax
  800383:	99                   	cltd   
  800384:	eb 18                	jmp    80039e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 04             	lea    0x4(%eax),%edx
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
  800393:	8b 45 08             	mov    0x8(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	83 e8 04             	sub    $0x4,%eax
  80039b:	8b 00                	mov    (%eax),%eax
  80039d:	99                   	cltd   
}
  80039e:	5d                   	pop    %ebp
  80039f:	c3                   	ret    

008003a0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
  8003a5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003a8:	eb 17                	jmp    8003c1 <vprintfmt+0x21>
			if (ch == '\0')
  8003aa:	85 db                	test   %ebx,%ebx
  8003ac:	0f 84 af 03 00 00    	je     800761 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	53                   	push   %ebx
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	ff d0                	call   *%eax
  8003be:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c4:	8d 50 01             	lea    0x1(%eax),%edx
  8003c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8003ca:	8a 00                	mov    (%eax),%al
  8003cc:	0f b6 d8             	movzbl %al,%ebx
  8003cf:	83 fb 25             	cmp    $0x25,%ebx
  8003d2:	75 d6                	jne    8003aa <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8003d4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8003d8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8003df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8003ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f7:	8d 50 01             	lea    0x1(%eax),%edx
  8003fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8003fd:	8a 00                	mov    (%eax),%al
  8003ff:	0f b6 d8             	movzbl %al,%ebx
  800402:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800405:	83 f8 55             	cmp    $0x55,%eax
  800408:	0f 87 2b 03 00 00    	ja     800739 <vprintfmt+0x399>
  80040e:	8b 04 85 f8 19 80 00 	mov    0x8019f8(,%eax,4),%eax
  800415:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800417:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80041b:	eb d7                	jmp    8003f4 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80041d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800421:	eb d1                	jmp    8003f4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800423:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80042a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042d:	89 d0                	mov    %edx,%eax
  80042f:	c1 e0 02             	shl    $0x2,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d8                	add    %ebx,%eax
  800438:	83 e8 30             	sub    $0x30,%eax
  80043b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80043e:	8b 45 10             	mov    0x10(%ebp),%eax
  800441:	8a 00                	mov    (%eax),%al
  800443:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800446:	83 fb 2f             	cmp    $0x2f,%ebx
  800449:	7e 3e                	jle    800489 <vprintfmt+0xe9>
  80044b:	83 fb 39             	cmp    $0x39,%ebx
  80044e:	7f 39                	jg     800489 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800450:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800453:	eb d5                	jmp    80042a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800455:	8b 45 14             	mov    0x14(%ebp),%eax
  800458:	83 c0 04             	add    $0x4,%eax
  80045b:	89 45 14             	mov    %eax,0x14(%ebp)
  80045e:	8b 45 14             	mov    0x14(%ebp),%eax
  800461:	83 e8 04             	sub    $0x4,%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800469:	eb 1f                	jmp    80048a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80046b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80046f:	79 83                	jns    8003f4 <vprintfmt+0x54>
				width = 0;
  800471:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800478:	e9 77 ff ff ff       	jmp    8003f4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80047d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800484:	e9 6b ff ff ff       	jmp    8003f4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800489:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80048a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80048e:	0f 89 60 ff ff ff    	jns    8003f4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800497:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80049a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8004a1:	e9 4e ff ff ff       	jmp    8003f4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004a6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8004a9:	e9 46 ff ff ff       	jmp    8003f4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b1:	83 c0 04             	add    $0x4,%eax
  8004b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	83 e8 04             	sub    $0x4,%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	ff 75 0c             	pushl  0xc(%ebp)
  8004c5:	50                   	push   %eax
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	ff d0                	call   *%eax
  8004cb:	83 c4 10             	add    $0x10,%esp
			break;
  8004ce:	e9 89 02 00 00       	jmp    80075c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	83 c0 04             	add    $0x4,%eax
  8004d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	83 e8 04             	sub    $0x4,%eax
  8004e2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8004e4:	85 db                	test   %ebx,%ebx
  8004e6:	79 02                	jns    8004ea <vprintfmt+0x14a>
				err = -err;
  8004e8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004ea:	83 fb 64             	cmp    $0x64,%ebx
  8004ed:	7f 0b                	jg     8004fa <vprintfmt+0x15a>
  8004ef:	8b 34 9d 40 18 80 00 	mov    0x801840(,%ebx,4),%esi
  8004f6:	85 f6                	test   %esi,%esi
  8004f8:	75 19                	jne    800513 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8004fa:	53                   	push   %ebx
  8004fb:	68 e5 19 80 00       	push   $0x8019e5
  800500:	ff 75 0c             	pushl  0xc(%ebp)
  800503:	ff 75 08             	pushl  0x8(%ebp)
  800506:	e8 5e 02 00 00       	call   800769 <printfmt>
  80050b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80050e:	e9 49 02 00 00       	jmp    80075c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800513:	56                   	push   %esi
  800514:	68 ee 19 80 00       	push   $0x8019ee
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 45 02 00 00       	call   800769 <printfmt>
  800524:	83 c4 10             	add    $0x10,%esp
			break;
  800527:	e9 30 02 00 00       	jmp    80075c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	83 c0 04             	add    $0x4,%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
  800535:	8b 45 14             	mov    0x14(%ebp),%eax
  800538:	83 e8 04             	sub    $0x4,%eax
  80053b:	8b 30                	mov    (%eax),%esi
  80053d:	85 f6                	test   %esi,%esi
  80053f:	75 05                	jne    800546 <vprintfmt+0x1a6>
				p = "(null)";
  800541:	be f1 19 80 00       	mov    $0x8019f1,%esi
			if (width > 0 && padc != '-')
  800546:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80054a:	7e 6d                	jle    8005b9 <vprintfmt+0x219>
  80054c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800550:	74 67                	je     8005b9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800552:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	50                   	push   %eax
  800559:	56                   	push   %esi
  80055a:	e8 0c 03 00 00       	call   80086b <strnlen>
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800565:	eb 16                	jmp    80057d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800567:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	50                   	push   %eax
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	ff d0                	call   *%eax
  800577:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80057a:	ff 4d e4             	decl   -0x1c(%ebp)
  80057d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800581:	7f e4                	jg     800567 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800583:	eb 34                	jmp    8005b9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800585:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800589:	74 1c                	je     8005a7 <vprintfmt+0x207>
  80058b:	83 fb 1f             	cmp    $0x1f,%ebx
  80058e:	7e 05                	jle    800595 <vprintfmt+0x1f5>
  800590:	83 fb 7e             	cmp    $0x7e,%ebx
  800593:	7e 12                	jle    8005a7 <vprintfmt+0x207>
					putch('?', putdat);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	ff 75 0c             	pushl  0xc(%ebp)
  80059b:	6a 3f                	push   $0x3f
  80059d:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a0:	ff d0                	call   *%eax
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	eb 0f                	jmp    8005b6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 0c             	pushl  0xc(%ebp)
  8005ad:	53                   	push   %ebx
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	ff d0                	call   *%eax
  8005b3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b6:	ff 4d e4             	decl   -0x1c(%ebp)
  8005b9:	89 f0                	mov    %esi,%eax
  8005bb:	8d 70 01             	lea    0x1(%eax),%esi
  8005be:	8a 00                	mov    (%eax),%al
  8005c0:	0f be d8             	movsbl %al,%ebx
  8005c3:	85 db                	test   %ebx,%ebx
  8005c5:	74 24                	je     8005eb <vprintfmt+0x24b>
  8005c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005cb:	78 b8                	js     800585 <vprintfmt+0x1e5>
  8005cd:	ff 4d e0             	decl   -0x20(%ebp)
  8005d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d4:	79 af                	jns    800585 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d6:	eb 13                	jmp    8005eb <vprintfmt+0x24b>
				putch(' ', putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	ff 75 0c             	pushl  0xc(%ebp)
  8005de:	6a 20                	push   $0x20
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	ff d0                	call   *%eax
  8005e5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8005eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ef:	7f e7                	jg     8005d8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8005f1:	e9 66 01 00 00       	jmp    80075c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	ff 75 e8             	pushl  -0x18(%ebp)
  8005fc:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ff:	50                   	push   %eax
  800600:	e8 3c fd ff ff       	call   800341 <getint>
  800605:	83 c4 10             	add    $0x10,%esp
  800608:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80060b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800614:	85 d2                	test   %edx,%edx
  800616:	79 23                	jns    80063b <vprintfmt+0x29b>
				putch('-', putdat);
  800618:	83 ec 08             	sub    $0x8,%esp
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	6a 2d                	push   $0x2d
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	ff d0                	call   *%eax
  800625:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	f7 d8                	neg    %eax
  800630:	83 d2 00             	adc    $0x0,%edx
  800633:	f7 da                	neg    %edx
  800635:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800638:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80063b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800642:	e9 bc 00 00 00       	jmp    800703 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	ff 75 e8             	pushl  -0x18(%ebp)
  80064d:	8d 45 14             	lea    0x14(%ebp),%eax
  800650:	50                   	push   %eax
  800651:	e8 84 fc ff ff       	call   8002da <getuint>
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80065c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80065f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800666:	e9 98 00 00 00       	jmp    800703 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 0c             	pushl  0xc(%ebp)
  800671:	6a 58                	push   $0x58
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	ff d0                	call   *%eax
  800678:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	6a 58                	push   $0x58
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	ff d0                	call   *%eax
  800688:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 0c             	pushl  0xc(%ebp)
  800691:	6a 58                	push   $0x58
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
			break;
  80069b:	e9 bc 00 00 00       	jmp    80075c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	6a 30                	push   $0x30
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	ff d0                	call   *%eax
  8006ad:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	ff 75 0c             	pushl  0xc(%ebp)
  8006b6:	6a 78                	push   $0x78
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	ff d0                	call   *%eax
  8006bd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	83 c0 04             	add    $0x4,%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	83 e8 04             	sub    $0x4,%eax
  8006cf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8006db:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8006e2:	eb 1f                	jmp    800703 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8006ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ed:	50                   	push   %eax
  8006ee:	e8 e7 fb ff ff       	call   8002da <getuint>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8006fc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800703:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	52                   	push   %edx
  80070e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800711:	50                   	push   %eax
  800712:	ff 75 f4             	pushl  -0xc(%ebp)
  800715:	ff 75 f0             	pushl  -0x10(%ebp)
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	e8 00 fb ff ff       	call   800223 <printnum>
  800723:	83 c4 20             	add    $0x20,%esp
			break;
  800726:	eb 34                	jmp    80075c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 0c             	pushl  0xc(%ebp)
  80072e:	53                   	push   %ebx
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	ff d0                	call   *%eax
  800734:	83 c4 10             	add    $0x10,%esp
			break;
  800737:	eb 23                	jmp    80075c <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	6a 25                	push   $0x25
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	ff d0                	call   *%eax
  800746:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800749:	ff 4d 10             	decl   0x10(%ebp)
  80074c:	eb 03                	jmp    800751 <vprintfmt+0x3b1>
  80074e:	ff 4d 10             	decl   0x10(%ebp)
  800751:	8b 45 10             	mov    0x10(%ebp),%eax
  800754:	48                   	dec    %eax
  800755:	8a 00                	mov    (%eax),%al
  800757:	3c 25                	cmp    $0x25,%al
  800759:	75 f3                	jne    80074e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80075b:	90                   	nop
		}
	}
  80075c:	e9 47 fc ff ff       	jmp    8003a8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800761:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800762:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800765:	5b                   	pop    %ebx
  800766:	5e                   	pop    %esi
  800767:	5d                   	pop    %ebp
  800768:	c3                   	ret    

00800769 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80076f:	8d 45 10             	lea    0x10(%ebp),%eax
  800772:	83 c0 04             	add    $0x4,%eax
  800775:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800778:	8b 45 10             	mov    0x10(%ebp),%eax
  80077b:	ff 75 f4             	pushl  -0xc(%ebp)
  80077e:	50                   	push   %eax
  80077f:	ff 75 0c             	pushl  0xc(%ebp)
  800782:	ff 75 08             	pushl  0x8(%ebp)
  800785:	e8 16 fc ff ff       	call   8003a0 <vprintfmt>
  80078a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80078d:	90                   	nop
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800793:	8b 45 0c             	mov    0xc(%ebp),%eax
  800796:	8b 40 08             	mov    0x8(%eax),%eax
  800799:	8d 50 01             	lea    0x1(%eax),%edx
  80079c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8007a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a5:	8b 10                	mov    (%eax),%edx
  8007a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007aa:	8b 40 04             	mov    0x4(%eax),%eax
  8007ad:	39 c2                	cmp    %eax,%edx
  8007af:	73 12                	jae    8007c3 <sprintputch+0x33>
		*b->buf++ = ch;
  8007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8007b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bc:	89 0a                	mov    %ecx,(%edx)
  8007be:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c1:	88 10                	mov    %dl,(%eax)
}
  8007c3:	90                   	nop
  8007c4:	5d                   	pop    %ebp
  8007c5:	c3                   	ret    

008007c6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007eb:	74 06                	je     8007f3 <vsnprintf+0x2d>
  8007ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f1:	7f 07                	jg     8007fa <vsnprintf+0x34>
		return -E_INVAL;
  8007f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8007f8:	eb 20                	jmp    80081a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007fa:	ff 75 14             	pushl  0x14(%ebp)
  8007fd:	ff 75 10             	pushl  0x10(%ebp)
  800800:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800803:	50                   	push   %eax
  800804:	68 90 07 80 00       	push   $0x800790
  800809:	e8 92 fb ff ff       	call   8003a0 <vprintfmt>
  80080e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800814:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800817:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    

0080081c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800822:	8d 45 10             	lea    0x10(%ebp),%eax
  800825:	83 c0 04             	add    $0x4,%eax
  800828:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80082b:	8b 45 10             	mov    0x10(%ebp),%eax
  80082e:	ff 75 f4             	pushl  -0xc(%ebp)
  800831:	50                   	push   %eax
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	ff 75 08             	pushl  0x8(%ebp)
  800838:	e8 89 ff ff ff       	call   8007c6 <vsnprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800843:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800846:	c9                   	leave  
  800847:	c3                   	ret    

00800848 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80084e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800855:	eb 06                	jmp    80085d <strlen+0x15>
		n++;
  800857:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80085a:	ff 45 08             	incl   0x8(%ebp)
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	8a 00                	mov    (%eax),%al
  800862:	84 c0                	test   %al,%al
  800864:	75 f1                	jne    800857 <strlen+0xf>
		n++;
	return n;
  800866:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800869:	c9                   	leave  
  80086a:	c3                   	ret    

0080086b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800871:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800878:	eb 09                	jmp    800883 <strnlen+0x18>
		n++;
  80087a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087d:	ff 45 08             	incl   0x8(%ebp)
  800880:	ff 4d 0c             	decl   0xc(%ebp)
  800883:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800887:	74 09                	je     800892 <strnlen+0x27>
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8a 00                	mov    (%eax),%al
  80088e:	84 c0                	test   %al,%al
  800890:	75 e8                	jne    80087a <strnlen+0xf>
		n++;
	return n;
  800892:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800895:	c9                   	leave  
  800896:	c3                   	ret    

00800897 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8008a3:	90                   	nop
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	8d 50 01             	lea    0x1(%eax),%edx
  8008aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008b3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8008b6:	8a 12                	mov    (%edx),%dl
  8008b8:	88 10                	mov    %dl,(%eax)
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	84 c0                	test   %al,%al
  8008be:	75 e4                	jne    8008a4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8008c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    

008008c5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8008d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008d8:	eb 1f                	jmp    8008f9 <strncpy+0x34>
		*dst++ = *src;
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8d 50 01             	lea    0x1(%eax),%edx
  8008e0:	89 55 08             	mov    %edx,0x8(%ebp)
  8008e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e6:	8a 12                	mov    (%edx),%dl
  8008e8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8a 00                	mov    (%eax),%al
  8008ef:	84 c0                	test   %al,%al
  8008f1:	74 03                	je     8008f6 <strncpy+0x31>
			src++;
  8008f3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f6:	ff 45 fc             	incl   -0x4(%ebp)
  8008f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8008fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8008ff:	72 d9                	jb     8008da <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800901:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800912:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800916:	74 30                	je     800948 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800918:	eb 16                	jmp    800930 <strlcpy+0x2a>
			*dst++ = *src++;
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8d 50 01             	lea    0x1(%eax),%edx
  800920:	89 55 08             	mov    %edx,0x8(%ebp)
  800923:	8b 55 0c             	mov    0xc(%ebp),%edx
  800926:	8d 4a 01             	lea    0x1(%edx),%ecx
  800929:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80092c:	8a 12                	mov    (%edx),%dl
  80092e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800930:	ff 4d 10             	decl   0x10(%ebp)
  800933:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800937:	74 09                	je     800942 <strlcpy+0x3c>
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	84 c0                	test   %al,%al
  800940:	75 d8                	jne    80091a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800948:	8b 55 08             	mov    0x8(%ebp),%edx
  80094b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80094e:	29 c2                	sub    %eax,%edx
  800950:	89 d0                	mov    %edx,%eax
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800957:	eb 06                	jmp    80095f <strcmp+0xb>
		p++, q++;
  800959:	ff 45 08             	incl   0x8(%ebp)
  80095c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8a 00                	mov    (%eax),%al
  800964:	84 c0                	test   %al,%al
  800966:	74 0e                	je     800976 <strcmp+0x22>
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8a 10                	mov    (%eax),%dl
  80096d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800970:	8a 00                	mov    (%eax),%al
  800972:	38 c2                	cmp    %al,%dl
  800974:	74 e3                	je     800959 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8a 00                	mov    (%eax),%al
  80097b:	0f b6 d0             	movzbl %al,%edx
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	8a 00                	mov    (%eax),%al
  800983:	0f b6 c0             	movzbl %al,%eax
  800986:	29 c2                	sub    %eax,%edx
  800988:	89 d0                	mov    %edx,%eax
}
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80098f:	eb 09                	jmp    80099a <strncmp+0xe>
		n--, p++, q++;
  800991:	ff 4d 10             	decl   0x10(%ebp)
  800994:	ff 45 08             	incl   0x8(%ebp)
  800997:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80099a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80099e:	74 17                	je     8009b7 <strncmp+0x2b>
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8a 00                	mov    (%eax),%al
  8009a5:	84 c0                	test   %al,%al
  8009a7:	74 0e                	je     8009b7 <strncmp+0x2b>
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	8a 10                	mov    (%eax),%dl
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	8a 00                	mov    (%eax),%al
  8009b3:	38 c2                	cmp    %al,%dl
  8009b5:	74 da                	je     800991 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8009b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009bb:	75 07                	jne    8009c4 <strncmp+0x38>
		return 0;
  8009bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c2:	eb 14                	jmp    8009d8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	8a 00                	mov    (%eax),%al
  8009c9:	0f b6 d0             	movzbl %al,%edx
  8009cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cf:	8a 00                	mov    (%eax),%al
  8009d1:	0f b6 c0             	movzbl %al,%eax
  8009d4:	29 c2                	sub    %eax,%edx
  8009d6:	89 d0                	mov    %edx,%eax
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 04             	sub    $0x4,%esp
  8009e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8009e6:	eb 12                	jmp    8009fa <strchr+0x20>
		if (*s == c)
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8a 00                	mov    (%eax),%al
  8009ed:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8009f0:	75 05                	jne    8009f7 <strchr+0x1d>
			return (char *) s;
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	eb 11                	jmp    800a08 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009f7:	ff 45 08             	incl   0x8(%ebp)
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	84 c0                	test   %al,%al
  800a01:	75 e5                	jne    8009e8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 04             	sub    $0x4,%esp
  800a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a16:	eb 0d                	jmp    800a25 <strfind+0x1b>
		if (*s == c)
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8a 00                	mov    (%eax),%al
  800a1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a20:	74 0e                	je     800a30 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a22:	ff 45 08             	incl   0x8(%ebp)
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8a 00                	mov    (%eax),%al
  800a2a:	84 c0                	test   %al,%al
  800a2c:	75 ea                	jne    800a18 <strfind+0xe>
  800a2e:	eb 01                	jmp    800a31 <strfind+0x27>
		if (*s == c)
			break;
  800a30:	90                   	nop
	return (char *) s;
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    

00800a36 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800a42:	8b 45 10             	mov    0x10(%ebp),%eax
  800a45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800a48:	eb 0e                	jmp    800a58 <memset+0x22>
		*p++ = c;
  800a4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a4d:	8d 50 01             	lea    0x1(%eax),%edx
  800a50:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a56:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800a58:	ff 4d f8             	decl   -0x8(%ebp)
  800a5b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800a5f:	79 e9                	jns    800a4a <memset+0x14>
		*p++ = c;

	return v;
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800a64:	c9                   	leave  
  800a65:	c3                   	ret    

00800a66 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800a78:	eb 16                	jmp    800a90 <memcpy+0x2a>
		*d++ = *s++;
  800a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800a7d:	8d 50 01             	lea    0x1(%eax),%edx
  800a80:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800a83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800a86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a89:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800a8c:	8a 12                	mov    (%edx),%dl
  800a8e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800a90:	8b 45 10             	mov    0x10(%ebp),%eax
  800a93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a96:	89 55 10             	mov    %edx,0x10(%ebp)
  800a99:	85 c0                	test   %eax,%eax
  800a9b:	75 dd                	jne    800a7a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800aba:	73 50                	jae    800b0c <memmove+0x6a>
  800abc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800abf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac2:	01 d0                	add    %edx,%eax
  800ac4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ac7:	76 43                	jbe    800b0c <memmove+0x6a>
		s += n;
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  800acc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ad5:	eb 10                	jmp    800ae7 <memmove+0x45>
			*--d = *--s;
  800ad7:	ff 4d f8             	decl   -0x8(%ebp)
  800ada:	ff 4d fc             	decl   -0x4(%ebp)
  800add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae0:	8a 10                	mov    (%eax),%dl
  800ae2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ae5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800aed:	89 55 10             	mov    %edx,0x10(%ebp)
  800af0:	85 c0                	test   %eax,%eax
  800af2:	75 e3                	jne    800ad7 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af4:	eb 23                	jmp    800b19 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800af6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800af9:	8d 50 01             	lea    0x1(%eax),%edx
  800afc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800aff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b02:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b05:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b08:	8a 12                	mov    (%edx),%dl
  800b0a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b12:	89 55 10             	mov    %edx,0x10(%ebp)
  800b15:	85 c0                	test   %eax,%eax
  800b17:	75 dd                	jne    800af6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800b30:	eb 2a                	jmp    800b5c <memcmp+0x3e>
		if (*s1 != *s2)
  800b32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b35:	8a 10                	mov    (%eax),%dl
  800b37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b3a:	8a 00                	mov    (%eax),%al
  800b3c:	38 c2                	cmp    %al,%dl
  800b3e:	74 16                	je     800b56 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800b40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	0f b6 d0             	movzbl %al,%edx
  800b48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b4b:	8a 00                	mov    (%eax),%al
  800b4d:	0f b6 c0             	movzbl %al,%eax
  800b50:	29 c2                	sub    %eax,%edx
  800b52:	89 d0                	mov    %edx,%eax
  800b54:	eb 18                	jmp    800b6e <memcmp+0x50>
		s1++, s2++;
  800b56:	ff 45 fc             	incl   -0x4(%ebp)
  800b59:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b62:	89 55 10             	mov    %edx,0x10(%ebp)
  800b65:	85 c0                	test   %eax,%eax
  800b67:	75 c9                	jne    800b32 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800b76:	8b 55 08             	mov    0x8(%ebp),%edx
  800b79:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7c:	01 d0                	add    %edx,%eax
  800b7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800b81:	eb 15                	jmp    800b98 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8a 00                	mov    (%eax),%al
  800b88:	0f b6 d0             	movzbl %al,%edx
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	0f b6 c0             	movzbl %al,%eax
  800b91:	39 c2                	cmp    %eax,%edx
  800b93:	74 0d                	je     800ba2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b95:	ff 45 08             	incl   0x8(%ebp)
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800b9e:	72 e3                	jb     800b83 <memfind+0x13>
  800ba0:	eb 01                	jmp    800ba3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ba2:	90                   	nop
	return (void *) s;
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800bae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800bb5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbc:	eb 03                	jmp    800bc1 <strtol+0x19>
		s++;
  800bbe:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8a 00                	mov    (%eax),%al
  800bc6:	3c 20                	cmp    $0x20,%al
  800bc8:	74 f4                	je     800bbe <strtol+0x16>
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	3c 09                	cmp    $0x9,%al
  800bd1:	74 eb                	je     800bbe <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	3c 2b                	cmp    $0x2b,%al
  800bda:	75 05                	jne    800be1 <strtol+0x39>
		s++;
  800bdc:	ff 45 08             	incl   0x8(%ebp)
  800bdf:	eb 13                	jmp    800bf4 <strtol+0x4c>
	else if (*s == '-')
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	8a 00                	mov    (%eax),%al
  800be6:	3c 2d                	cmp    $0x2d,%al
  800be8:	75 0a                	jne    800bf4 <strtol+0x4c>
		s++, neg = 1;
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf8:	74 06                	je     800c00 <strtol+0x58>
  800bfa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800bfe:	75 20                	jne    800c20 <strtol+0x78>
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	3c 30                	cmp    $0x30,%al
  800c07:	75 17                	jne    800c20 <strtol+0x78>
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	40                   	inc    %eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	3c 78                	cmp    $0x78,%al
  800c11:	75 0d                	jne    800c20 <strtol+0x78>
		s += 2, base = 16;
  800c13:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800c17:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c1e:	eb 28                	jmp    800c48 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800c20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c24:	75 15                	jne    800c3b <strtol+0x93>
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	3c 30                	cmp    $0x30,%al
  800c2d:	75 0c                	jne    800c3b <strtol+0x93>
		s++, base = 8;
  800c2f:	ff 45 08             	incl   0x8(%ebp)
  800c32:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800c39:	eb 0d                	jmp    800c48 <strtol+0xa0>
	else if (base == 0)
  800c3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3f:	75 07                	jne    800c48 <strtol+0xa0>
		base = 10;
  800c41:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	3c 2f                	cmp    $0x2f,%al
  800c4f:	7e 19                	jle    800c6a <strtol+0xc2>
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8a 00                	mov    (%eax),%al
  800c56:	3c 39                	cmp    $0x39,%al
  800c58:	7f 10                	jg     800c6a <strtol+0xc2>
			dig = *s - '0';
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	0f be c0             	movsbl %al,%eax
  800c62:	83 e8 30             	sub    $0x30,%eax
  800c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c68:	eb 42                	jmp    800cac <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	3c 60                	cmp    $0x60,%al
  800c71:	7e 19                	jle    800c8c <strtol+0xe4>
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	3c 7a                	cmp    $0x7a,%al
  800c7a:	7f 10                	jg     800c8c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	0f be c0             	movsbl %al,%eax
  800c84:	83 e8 57             	sub    $0x57,%eax
  800c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c8a:	eb 20                	jmp    800cac <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	3c 40                	cmp    $0x40,%al
  800c93:	7e 39                	jle    800cce <strtol+0x126>
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	3c 5a                	cmp    $0x5a,%al
  800c9c:	7f 30                	jg     800cce <strtol+0x126>
			dig = *s - 'A' + 10;
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f be c0             	movsbl %al,%eax
  800ca6:	83 e8 37             	sub    $0x37,%eax
  800ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800caf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb2:	7d 19                	jge    800ccd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800cb4:	ff 45 08             	incl   0x8(%ebp)
  800cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cba:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cbe:	89 c2                	mov    %eax,%edx
  800cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cc3:	01 d0                	add    %edx,%eax
  800cc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800cc8:	e9 7b ff ff ff       	jmp    800c48 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ccd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800cce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd2:	74 08                	je     800cdc <strtol+0x134>
		*endptr = (char *) s;
  800cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800cdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ce0:	74 07                	je     800ce9 <strtol+0x141>
  800ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce5:	f7 d8                	neg    %eax
  800ce7:	eb 03                	jmp    800cec <strtol+0x144>
  800ce9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cec:	c9                   	leave  
  800ced:	c3                   	ret    

00800cee <ltostr>:

void
ltostr(long value, char *str)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800cfb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d06:	79 13                	jns    800d1b <ltostr+0x2d>
	{
		neg = 1;
  800d08:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800d15:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800d18:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800d23:	99                   	cltd   
  800d24:	f7 f9                	idiv   %ecx
  800d26:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800d29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2c:	8d 50 01             	lea    0x1(%eax),%edx
  800d2f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d32:	89 c2                	mov    %eax,%edx
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	01 d0                	add    %edx,%eax
  800d39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d3c:	83 c2 30             	add    $0x30,%edx
  800d3f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800d41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d44:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800d49:	f7 e9                	imul   %ecx
  800d4b:	c1 fa 02             	sar    $0x2,%edx
  800d4e:	89 c8                	mov    %ecx,%eax
  800d50:	c1 f8 1f             	sar    $0x1f,%eax
  800d53:	29 c2                	sub    %eax,%edx
  800d55:	89 d0                	mov    %edx,%eax
  800d57:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800d5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800d62:	f7 e9                	imul   %ecx
  800d64:	c1 fa 02             	sar    $0x2,%edx
  800d67:	89 c8                	mov    %ecx,%eax
  800d69:	c1 f8 1f             	sar    $0x1f,%eax
  800d6c:	29 c2                	sub    %eax,%edx
  800d6e:	89 d0                	mov    %edx,%eax
  800d70:	c1 e0 02             	shl    $0x2,%eax
  800d73:	01 d0                	add    %edx,%eax
  800d75:	01 c0                	add    %eax,%eax
  800d77:	29 c1                	sub    %eax,%ecx
  800d79:	89 ca                	mov    %ecx,%edx
  800d7b:	85 d2                	test   %edx,%edx
  800d7d:	75 9c                	jne    800d1b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800d7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800d86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d89:	48                   	dec    %eax
  800d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800d8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d91:	74 3d                	je     800dd0 <ltostr+0xe2>
		start = 1 ;
  800d93:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800d9a:	eb 34                	jmp    800dd0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	01 d0                	add    %edx,%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	01 c2                	add    %eax,%edx
  800db1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	01 c8                	add    %ecx,%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800dbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	01 c2                	add    %eax,%edx
  800dc5:	8a 45 eb             	mov    -0x15(%ebp),%al
  800dc8:	88 02                	mov    %al,(%edx)
		start++ ;
  800dca:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800dcd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dd6:	7c c4                	jl     800d9c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800dd8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dde:	01 d0                	add    %edx,%eax
  800de0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800de3:	90                   	nop
  800de4:	c9                   	leave  
  800de5:	c3                   	ret    

00800de6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800dec:	ff 75 08             	pushl  0x8(%ebp)
  800def:	e8 54 fa ff ff       	call   800848 <strlen>
  800df4:	83 c4 04             	add    $0x4,%esp
  800df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800dfa:	ff 75 0c             	pushl  0xc(%ebp)
  800dfd:	e8 46 fa ff ff       	call   800848 <strlen>
  800e02:	83 c4 04             	add    $0x4,%esp
  800e05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800e0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e16:	eb 17                	jmp    800e2f <strcconcat+0x49>
		final[s] = str1[s] ;
  800e18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	01 c2                	add    %eax,%edx
  800e20:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	01 c8                	add    %ecx,%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800e2c:	ff 45 fc             	incl   -0x4(%ebp)
  800e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e35:	7c e1                	jl     800e18 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800e37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800e3e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800e45:	eb 1f                	jmp    800e66 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4a:	8d 50 01             	lea    0x1(%eax),%edx
  800e4d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e50:	89 c2                	mov    %eax,%edx
  800e52:	8b 45 10             	mov    0x10(%ebp),%eax
  800e55:	01 c2                	add    %eax,%edx
  800e57:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5d:	01 c8                	add    %ecx,%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800e63:	ff 45 f8             	incl   -0x8(%ebp)
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c d9                	jl     800e47 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	01 d0                	add    %edx,%eax
  800e76:	c6 00 00             	movb   $0x0,(%eax)
}
  800e79:	90                   	nop
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800e7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800e88:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8b:	8b 00                	mov    (%eax),%eax
  800e8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e94:	8b 45 10             	mov    0x10(%ebp),%eax
  800e97:	01 d0                	add    %edx,%eax
  800e99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800e9f:	eb 0c                	jmp    800ead <strsplit+0x31>
			*string++ = 0;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eaa:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	84 c0                	test   %al,%al
  800eb4:	74 18                	je     800ece <strsplit+0x52>
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f be c0             	movsbl %al,%eax
  800ebe:	50                   	push   %eax
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	e8 13 fb ff ff       	call   8009da <strchr>
  800ec7:	83 c4 08             	add    $0x8,%esp
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 d3                	jne    800ea1 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	74 5a                	je     800f31 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  800ed7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eda:	8b 00                	mov    (%eax),%eax
  800edc:	83 f8 0f             	cmp    $0xf,%eax
  800edf:	75 07                	jne    800ee8 <strsplit+0x6c>
		{
			return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee6:	eb 66                	jmp    800f4e <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800ee8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eeb:	8b 00                	mov    (%eax),%eax
  800eed:	8d 48 01             	lea    0x1(%eax),%ecx
  800ef0:	8b 55 14             	mov    0x14(%ebp),%edx
  800ef3:	89 0a                	mov    %ecx,(%edx)
  800ef5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	01 c2                	add    %eax,%edx
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f06:	eb 03                	jmp    800f0b <strsplit+0x8f>
			string++;
  800f08:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	84 c0                	test   %al,%al
  800f12:	74 8b                	je     800e9f <strsplit+0x23>
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	0f be c0             	movsbl %al,%eax
  800f1c:	50                   	push   %eax
  800f1d:	ff 75 0c             	pushl  0xc(%ebp)
  800f20:	e8 b5 fa ff ff       	call   8009da <strchr>
  800f25:	83 c4 08             	add    $0x8,%esp
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	74 dc                	je     800f08 <strsplit+0x8c>
			string++;
	}
  800f2c:	e9 6e ff ff ff       	jmp    800e9f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800f31:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800f32:	8b 45 14             	mov    0x14(%ebp),%eax
  800f35:	8b 00                	mov    (%eax),%eax
  800f37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f41:	01 d0                	add    %edx,%eax
  800f43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800f49:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	57                   	push   %edi
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f62:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800f65:	8b 7d 18             	mov    0x18(%ebp),%edi
  800f68:	8b 75 1c             	mov    0x1c(%ebp),%esi
  800f6b:	cd 30                	int    $0x30
  800f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f73:	83 c4 10             	add    $0x10,%esp
  800f76:	5b                   	pop    %ebx
  800f77:	5e                   	pop    %esi
  800f78:	5f                   	pop    %edi
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	6a 00                	push   $0x0
  800f83:	6a 00                	push   $0x0
  800f85:	6a 00                	push   $0x0
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	6a 00                	push   $0x0
  800f8d:	e8 be ff ff ff       	call   800f50 <syscall>
  800f92:	83 c4 18             	add    $0x18,%esp
}
  800f95:	90                   	nop
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  800f9b:	6a 00                	push   $0x0
  800f9d:	6a 00                	push   $0x0
  800f9f:	6a 00                	push   $0x0
  800fa1:	6a 00                	push   $0x0
  800fa3:	6a 00                	push   $0x0
  800fa5:	6a 01                	push   $0x1
  800fa7:	e8 a4 ff ff ff       	call   800f50 <syscall>
  800fac:	83 c4 18             	add    $0x18,%esp
}
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    

00800fb1 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	6a 00                	push   $0x0
  800fb9:	6a 00                	push   $0x0
  800fbb:	6a 00                	push   $0x0
  800fbd:	6a 00                	push   $0x0
  800fbf:	50                   	push   %eax
  800fc0:	6a 03                	push   $0x3
  800fc2:	e8 89 ff ff ff       	call   800f50 <syscall>
  800fc7:	83 c4 18             	add    $0x18,%esp
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <sys_getenvid>:

int32 sys_getenvid(void)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  800fcf:	6a 00                	push   $0x0
  800fd1:	6a 00                	push   $0x0
  800fd3:	6a 00                	push   $0x0
  800fd5:	6a 00                	push   $0x0
  800fd7:	6a 00                	push   $0x0
  800fd9:	6a 02                	push   $0x2
  800fdb:	e8 70 ff ff ff       	call   800f50 <syscall>
  800fe0:	83 c4 18             	add    $0x18,%esp
}
  800fe3:	c9                   	leave  
  800fe4:	c3                   	ret    

00800fe5 <sys_env_exit>:

void sys_env_exit(void)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  800fe8:	6a 00                	push   $0x0
  800fea:	6a 00                	push   $0x0
  800fec:	6a 00                	push   $0x0
  800fee:	6a 00                	push   $0x0
  800ff0:	6a 00                	push   $0x0
  800ff2:	6a 04                	push   $0x4
  800ff4:	e8 57 ff ff ff       	call   800f50 <syscall>
  800ff9:	83 c4 18             	add    $0x18,%esp
}
  800ffc:	90                   	nop
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801002:	8b 55 0c             	mov    0xc(%ebp),%edx
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	6a 00                	push   $0x0
  80100a:	6a 00                	push   $0x0
  80100c:	6a 00                	push   $0x0
  80100e:	52                   	push   %edx
  80100f:	50                   	push   %eax
  801010:	6a 05                	push   $0x5
  801012:	e8 39 ff ff ff       	call   800f50 <syscall>
  801017:	83 c4 18             	add    $0x18,%esp
}
  80101a:	c9                   	leave  
  80101b:	c3                   	ret    

0080101c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801021:	8b 75 18             	mov    0x18(%ebp),%esi
  801024:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801027:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80102a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
  801032:	51                   	push   %ecx
  801033:	52                   	push   %edx
  801034:	50                   	push   %eax
  801035:	6a 06                	push   $0x6
  801037:	e8 14 ff ff ff       	call   800f50 <syscall>
  80103c:	83 c4 18             	add    $0x18,%esp
}
  80103f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801042:	5b                   	pop    %ebx
  801043:	5e                   	pop    %esi
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	6a 00                	push   $0x0
  801051:	6a 00                	push   $0x0
  801053:	6a 00                	push   $0x0
  801055:	52                   	push   %edx
  801056:	50                   	push   %eax
  801057:	6a 07                	push   $0x7
  801059:	e8 f2 fe ff ff       	call   800f50 <syscall>
  80105e:	83 c4 18             	add    $0x18,%esp
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801066:	6a 00                	push   $0x0
  801068:	6a 00                	push   $0x0
  80106a:	6a 00                	push   $0x0
  80106c:	ff 75 0c             	pushl  0xc(%ebp)
  80106f:	ff 75 08             	pushl  0x8(%ebp)
  801072:	6a 08                	push   $0x8
  801074:	e8 d7 fe ff ff       	call   800f50 <syscall>
  801079:	83 c4 18             	add    $0x18,%esp
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801081:	6a 00                	push   $0x0
  801083:	6a 00                	push   $0x0
  801085:	6a 00                	push   $0x0
  801087:	6a 00                	push   $0x0
  801089:	6a 00                	push   $0x0
  80108b:	6a 09                	push   $0x9
  80108d:	e8 be fe ff ff       	call   800f50 <syscall>
  801092:	83 c4 18             	add    $0x18,%esp
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80109a:	6a 00                	push   $0x0
  80109c:	6a 00                	push   $0x0
  80109e:	6a 00                	push   $0x0
  8010a0:	6a 00                	push   $0x0
  8010a2:	6a 00                	push   $0x0
  8010a4:	6a 0a                	push   $0xa
  8010a6:	e8 a5 fe ff ff       	call   800f50 <syscall>
  8010ab:	83 c4 18             	add    $0x18,%esp
}
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8010b3:	6a 00                	push   $0x0
  8010b5:	6a 00                	push   $0x0
  8010b7:	6a 00                	push   $0x0
  8010b9:	6a 00                	push   $0x0
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 0b                	push   $0xb
  8010bf:	e8 8c fe ff ff       	call   800f50 <syscall>
  8010c4:	83 c4 18             	add    $0x18,%esp
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8010cc:	6a 00                	push   $0x0
  8010ce:	6a 00                	push   $0x0
  8010d0:	6a 00                	push   $0x0
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	ff 75 08             	pushl  0x8(%ebp)
  8010d8:	6a 0d                	push   $0xd
  8010da:	e8 71 fe ff ff       	call   800f50 <syscall>
  8010df:	83 c4 18             	add    $0x18,%esp
	return;
  8010e2:	90                   	nop
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8010e8:	6a 00                	push   $0x0
  8010ea:	6a 00                	push   $0x0
  8010ec:	6a 00                	push   $0x0
  8010ee:	ff 75 0c             	pushl  0xc(%ebp)
  8010f1:	ff 75 08             	pushl  0x8(%ebp)
  8010f4:	6a 0e                	push   $0xe
  8010f6:	e8 55 fe ff ff       	call   800f50 <syscall>
  8010fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8010fe:	90                   	nop
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801104:	6a 00                	push   $0x0
  801106:	6a 00                	push   $0x0
  801108:	6a 00                	push   $0x0
  80110a:	6a 00                	push   $0x0
  80110c:	6a 00                	push   $0x0
  80110e:	6a 0c                	push   $0xc
  801110:	e8 3b fe ff ff       	call   800f50 <syscall>
  801115:	83 c4 18             	add    $0x18,%esp
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80111d:	6a 00                	push   $0x0
  80111f:	6a 00                	push   $0x0
  801121:	6a 00                	push   $0x0
  801123:	6a 00                	push   $0x0
  801125:	6a 00                	push   $0x0
  801127:	6a 10                	push   $0x10
  801129:	e8 22 fe ff ff       	call   800f50 <syscall>
  80112e:	83 c4 18             	add    $0x18,%esp
}
  801131:	90                   	nop
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801137:	6a 00                	push   $0x0
  801139:	6a 00                	push   $0x0
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	6a 00                	push   $0x0
  801141:	6a 11                	push   $0x11
  801143:	e8 08 fe ff ff       	call   800f50 <syscall>
  801148:	83 c4 18             	add    $0x18,%esp
}
  80114b:	90                   	nop
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <sys_cputc>:


void
sys_cputc(const char c)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 04             	sub    $0x4,%esp
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80115a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80115e:	6a 00                	push   $0x0
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	6a 00                	push   $0x0
  801166:	50                   	push   %eax
  801167:	6a 12                	push   $0x12
  801169:	e8 e2 fd ff ff       	call   800f50 <syscall>
  80116e:	83 c4 18             	add    $0x18,%esp
}
  801171:	90                   	nop
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801177:	6a 00                	push   $0x0
  801179:	6a 00                	push   $0x0
  80117b:	6a 00                	push   $0x0
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 13                	push   $0x13
  801183:	e8 c8 fd ff ff       	call   800f50 <syscall>
  801188:	83 c4 18             	add    $0x18,%esp
}
  80118b:	90                   	nop
  80118c:	c9                   	leave  
  80118d:	c3                   	ret    

0080118e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	50                   	push   %eax
  80119e:	6a 14                	push   $0x14
  8011a0:	e8 ab fd ff ff       	call   800f50 <syscall>
  8011a5:	83 c4 18             	add    $0x18,%esp
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	50                   	push   %eax
  8011b9:	6a 17                	push   $0x17
  8011bb:	e8 90 fd ff ff       	call   800f50 <syscall>
  8011c0:	83 c4 18             	add    $0x18,%esp
}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 00                	push   $0x0
  8011d3:	50                   	push   %eax
  8011d4:	6a 15                	push   $0x15
  8011d6:	e8 75 fd ff ff       	call   800f50 <syscall>
  8011db:	83 c4 18             	add    $0x18,%esp
}
  8011de:	90                   	nop
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	6a 00                	push   $0x0
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	50                   	push   %eax
  8011f0:	6a 16                	push   $0x16
  8011f2:	e8 59 fd ff ff       	call   800f50 <syscall>
  8011f7:	83 c4 18             	add    $0x18,%esp
}
  8011fa:	90                   	nop
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	8b 45 10             	mov    0x10(%ebp),%eax
  801206:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801209:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80120c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	6a 00                	push   $0x0
  801215:	51                   	push   %ecx
  801216:	52                   	push   %edx
  801217:	ff 75 0c             	pushl  0xc(%ebp)
  80121a:	50                   	push   %eax
  80121b:	6a 18                	push   $0x18
  80121d:	e8 2e fd ff ff       	call   800f50 <syscall>
  801222:	83 c4 18             	add    $0x18,%esp
}
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  80122a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	6a 00                	push   $0x0
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	52                   	push   %edx
  801237:	50                   	push   %eax
  801238:	6a 19                	push   $0x19
  80123a:	e8 11 fd ff ff       	call   800f50 <syscall>
  80123f:	83 c4 18             	add    $0x18,%esp
}
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	50                   	push   %eax
  801253:	6a 1a                	push   $0x1a
  801255:	e8 f6 fc ff ff       	call   800f50 <syscall>
  80125a:	83 c4 18             	add    $0x18,%esp
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 1b                	push   $0x1b
  80126e:	e8 dd fc ff ff       	call   800f50 <syscall>
  801273:	83 c4 18             	add    $0x18,%esp
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 1c                	push   $0x1c
  801287:	e8 c4 fc ff ff       	call   800f50 <syscall>
  80128c:	83 c4 18             	add    $0x18,%esp
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 00                	push   $0x0
  80129d:	ff 75 0c             	pushl  0xc(%ebp)
  8012a0:	50                   	push   %eax
  8012a1:	6a 1d                	push   $0x1d
  8012a3:	e8 a8 fc ff ff       	call   800f50 <syscall>
  8012a8:	83 c4 18             	add    $0x18,%esp
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	50                   	push   %eax
  8012bc:	6a 1e                	push   $0x1e
  8012be:	e8 8d fc ff ff       	call   800f50 <syscall>
  8012c3:	83 c4 18             	add    $0x18,%esp
}
  8012c6:	90                   	nop
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	50                   	push   %eax
  8012d8:	6a 1f                	push   $0x1f
  8012da:	e8 71 fc ff ff       	call   800f50 <syscall>
  8012df:	83 c4 18             	add    $0x18,%esp
}
  8012e2:	90                   	nop
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8012eb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8012ee:	8d 50 04             	lea    0x4(%eax),%edx
  8012f1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	52                   	push   %edx
  8012fb:	50                   	push   %eax
  8012fc:	6a 20                	push   $0x20
  8012fe:	e8 4d fc ff ff       	call   800f50 <syscall>
  801303:	83 c4 18             	add    $0x18,%esp
	return result;
  801306:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	89 01                	mov    %eax,(%ecx)
  801311:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	c9                   	leave  
  801318:	c2 04 00             	ret    $0x4

0080131b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	ff 75 10             	pushl  0x10(%ebp)
  801325:	ff 75 0c             	pushl  0xc(%ebp)
  801328:	ff 75 08             	pushl  0x8(%ebp)
  80132b:	6a 0f                	push   $0xf
  80132d:	e8 1e fc ff ff       	call   800f50 <syscall>
  801332:	83 c4 18             	add    $0x18,%esp
	return ;
  801335:	90                   	nop
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <sys_rcr2>:
uint32 sys_rcr2()
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 21                	push   $0x21
  801347:	e8 04 fc ff ff       	call   800f50 <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 04             	sub    $0x4,%esp
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80135d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	50                   	push   %eax
  80136a:	6a 22                	push   $0x22
  80136c:	e8 df fb ff ff       	call   800f50 <syscall>
  801371:	83 c4 18             	add    $0x18,%esp
	return ;
  801374:	90                   	nop
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <rsttst>:
void rsttst()
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 24                	push   $0x24
  801386:	e8 c5 fb ff ff       	call   800f50 <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
	return ;
  80138e:	90                   	nop
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 04             	sub    $0x4,%esp
  801397:	8b 45 14             	mov    0x14(%ebp),%eax
  80139a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80139d:	8b 55 18             	mov    0x18(%ebp),%edx
  8013a0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013a4:	52                   	push   %edx
  8013a5:	50                   	push   %eax
  8013a6:	ff 75 10             	pushl  0x10(%ebp)
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	ff 75 08             	pushl  0x8(%ebp)
  8013af:	6a 23                	push   $0x23
  8013b1:	e8 9a fb ff ff       	call   800f50 <syscall>
  8013b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8013b9:	90                   	nop
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <chktst>:
void chktst(uint32 n)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	ff 75 08             	pushl  0x8(%ebp)
  8013ca:	6a 25                	push   $0x25
  8013cc:	e8 7f fb ff ff       	call   800f50 <syscall>
  8013d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d4:	90                   	nop
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 26                	push   $0x26
  8013e9:	e8 62 fb ff ff       	call   800f50 <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
  8013f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8013f4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8013f8:	75 07                	jne    801401 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8013fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8013ff:	eb 05                	jmp    801406 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801401:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 26                	push   $0x26
  80141a:	e8 31 fb ff ff       	call   800f50 <syscall>
  80141f:	83 c4 18             	add    $0x18,%esp
  801422:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801425:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801429:	75 07                	jne    801432 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80142b:	b8 01 00 00 00       	mov    $0x1,%eax
  801430:	eb 05                	jmp    801437 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 26                	push   $0x26
  80144b:	e8 00 fb ff ff       	call   800f50 <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
  801453:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801456:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80145a:	75 07                	jne    801463 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80145c:	b8 01 00 00 00       	mov    $0x1,%eax
  801461:	eb 05                	jmp    801468 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 26                	push   $0x26
  80147c:	e8 cf fa ff ff       	call   800f50 <syscall>
  801481:	83 c4 18             	add    $0x18,%esp
  801484:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801487:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80148b:	75 07                	jne    801494 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80148d:	b8 01 00 00 00       	mov    $0x1,%eax
  801492:	eb 05                	jmp    801499 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801494:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	ff 75 08             	pushl  0x8(%ebp)
  8014a9:	6a 27                	push   $0x27
  8014ab:	e8 a0 fa ff ff       	call   800f50 <syscall>
  8014b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b3:	90                   	nop
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    
  8014b6:	66 90                	xchg   %ax,%ax

008014b8 <__udivdi3>:
  8014b8:	55                   	push   %ebp
  8014b9:	57                   	push   %edi
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
  8014bc:	83 ec 1c             	sub    $0x1c,%esp
  8014bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8014c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8014c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8014cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014cf:	89 ca                	mov    %ecx,%edx
  8014d1:	89 f8                	mov    %edi,%eax
  8014d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8014d7:	85 f6                	test   %esi,%esi
  8014d9:	75 2d                	jne    801508 <__udivdi3+0x50>
  8014db:	39 cf                	cmp    %ecx,%edi
  8014dd:	77 65                	ja     801544 <__udivdi3+0x8c>
  8014df:	89 fd                	mov    %edi,%ebp
  8014e1:	85 ff                	test   %edi,%edi
  8014e3:	75 0b                	jne    8014f0 <__udivdi3+0x38>
  8014e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8014ea:	31 d2                	xor    %edx,%edx
  8014ec:	f7 f7                	div    %edi
  8014ee:	89 c5                	mov    %eax,%ebp
  8014f0:	31 d2                	xor    %edx,%edx
  8014f2:	89 c8                	mov    %ecx,%eax
  8014f4:	f7 f5                	div    %ebp
  8014f6:	89 c1                	mov    %eax,%ecx
  8014f8:	89 d8                	mov    %ebx,%eax
  8014fa:	f7 f5                	div    %ebp
  8014fc:	89 cf                	mov    %ecx,%edi
  8014fe:	89 fa                	mov    %edi,%edx
  801500:	83 c4 1c             	add    $0x1c,%esp
  801503:	5b                   	pop    %ebx
  801504:	5e                   	pop    %esi
  801505:	5f                   	pop    %edi
  801506:	5d                   	pop    %ebp
  801507:	c3                   	ret    
  801508:	39 ce                	cmp    %ecx,%esi
  80150a:	77 28                	ja     801534 <__udivdi3+0x7c>
  80150c:	0f bd fe             	bsr    %esi,%edi
  80150f:	83 f7 1f             	xor    $0x1f,%edi
  801512:	75 40                	jne    801554 <__udivdi3+0x9c>
  801514:	39 ce                	cmp    %ecx,%esi
  801516:	72 0a                	jb     801522 <__udivdi3+0x6a>
  801518:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80151c:	0f 87 9e 00 00 00    	ja     8015c0 <__udivdi3+0x108>
  801522:	b8 01 00 00 00       	mov    $0x1,%eax
  801527:	89 fa                	mov    %edi,%edx
  801529:	83 c4 1c             	add    $0x1c,%esp
  80152c:	5b                   	pop    %ebx
  80152d:	5e                   	pop    %esi
  80152e:	5f                   	pop    %edi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    
  801531:	8d 76 00             	lea    0x0(%esi),%esi
  801534:	31 ff                	xor    %edi,%edi
  801536:	31 c0                	xor    %eax,%eax
  801538:	89 fa                	mov    %edi,%edx
  80153a:	83 c4 1c             	add    $0x1c,%esp
  80153d:	5b                   	pop    %ebx
  80153e:	5e                   	pop    %esi
  80153f:	5f                   	pop    %edi
  801540:	5d                   	pop    %ebp
  801541:	c3                   	ret    
  801542:	66 90                	xchg   %ax,%ax
  801544:	89 d8                	mov    %ebx,%eax
  801546:	f7 f7                	div    %edi
  801548:	31 ff                	xor    %edi,%edi
  80154a:	89 fa                	mov    %edi,%edx
  80154c:	83 c4 1c             	add    $0x1c,%esp
  80154f:	5b                   	pop    %ebx
  801550:	5e                   	pop    %esi
  801551:	5f                   	pop    %edi
  801552:	5d                   	pop    %ebp
  801553:	c3                   	ret    
  801554:	bd 20 00 00 00       	mov    $0x20,%ebp
  801559:	89 eb                	mov    %ebp,%ebx
  80155b:	29 fb                	sub    %edi,%ebx
  80155d:	89 f9                	mov    %edi,%ecx
  80155f:	d3 e6                	shl    %cl,%esi
  801561:	89 c5                	mov    %eax,%ebp
  801563:	88 d9                	mov    %bl,%cl
  801565:	d3 ed                	shr    %cl,%ebp
  801567:	89 e9                	mov    %ebp,%ecx
  801569:	09 f1                	or     %esi,%ecx
  80156b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80156f:	89 f9                	mov    %edi,%ecx
  801571:	d3 e0                	shl    %cl,%eax
  801573:	89 c5                	mov    %eax,%ebp
  801575:	89 d6                	mov    %edx,%esi
  801577:	88 d9                	mov    %bl,%cl
  801579:	d3 ee                	shr    %cl,%esi
  80157b:	89 f9                	mov    %edi,%ecx
  80157d:	d3 e2                	shl    %cl,%edx
  80157f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801583:	88 d9                	mov    %bl,%cl
  801585:	d3 e8                	shr    %cl,%eax
  801587:	09 c2                	or     %eax,%edx
  801589:	89 d0                	mov    %edx,%eax
  80158b:	89 f2                	mov    %esi,%edx
  80158d:	f7 74 24 0c          	divl   0xc(%esp)
  801591:	89 d6                	mov    %edx,%esi
  801593:	89 c3                	mov    %eax,%ebx
  801595:	f7 e5                	mul    %ebp
  801597:	39 d6                	cmp    %edx,%esi
  801599:	72 19                	jb     8015b4 <__udivdi3+0xfc>
  80159b:	74 0b                	je     8015a8 <__udivdi3+0xf0>
  80159d:	89 d8                	mov    %ebx,%eax
  80159f:	31 ff                	xor    %edi,%edi
  8015a1:	e9 58 ff ff ff       	jmp    8014fe <__udivdi3+0x46>
  8015a6:	66 90                	xchg   %ax,%ax
  8015a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8015ac:	89 f9                	mov    %edi,%ecx
  8015ae:	d3 e2                	shl    %cl,%edx
  8015b0:	39 c2                	cmp    %eax,%edx
  8015b2:	73 e9                	jae    80159d <__udivdi3+0xe5>
  8015b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8015b7:	31 ff                	xor    %edi,%edi
  8015b9:	e9 40 ff ff ff       	jmp    8014fe <__udivdi3+0x46>
  8015be:	66 90                	xchg   %ax,%ax
  8015c0:	31 c0                	xor    %eax,%eax
  8015c2:	e9 37 ff ff ff       	jmp    8014fe <__udivdi3+0x46>
  8015c7:	90                   	nop

008015c8 <__umoddi3>:
  8015c8:	55                   	push   %ebp
  8015c9:	57                   	push   %edi
  8015ca:	56                   	push   %esi
  8015cb:	53                   	push   %ebx
  8015cc:	83 ec 1c             	sub    $0x1c,%esp
  8015cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8015d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8015d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8015db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8015df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015e7:	89 f3                	mov    %esi,%ebx
  8015e9:	89 fa                	mov    %edi,%edx
  8015eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015ef:	89 34 24             	mov    %esi,(%esp)
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	75 1a                	jne    801610 <__umoddi3+0x48>
  8015f6:	39 f7                	cmp    %esi,%edi
  8015f8:	0f 86 a2 00 00 00    	jbe    8016a0 <__umoddi3+0xd8>
  8015fe:	89 c8                	mov    %ecx,%eax
  801600:	89 f2                	mov    %esi,%edx
  801602:	f7 f7                	div    %edi
  801604:	89 d0                	mov    %edx,%eax
  801606:	31 d2                	xor    %edx,%edx
  801608:	83 c4 1c             	add    $0x1c,%esp
  80160b:	5b                   	pop    %ebx
  80160c:	5e                   	pop    %esi
  80160d:	5f                   	pop    %edi
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    
  801610:	39 f0                	cmp    %esi,%eax
  801612:	0f 87 ac 00 00 00    	ja     8016c4 <__umoddi3+0xfc>
  801618:	0f bd e8             	bsr    %eax,%ebp
  80161b:	83 f5 1f             	xor    $0x1f,%ebp
  80161e:	0f 84 ac 00 00 00    	je     8016d0 <__umoddi3+0x108>
  801624:	bf 20 00 00 00       	mov    $0x20,%edi
  801629:	29 ef                	sub    %ebp,%edi
  80162b:	89 fe                	mov    %edi,%esi
  80162d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801631:	89 e9                	mov    %ebp,%ecx
  801633:	d3 e0                	shl    %cl,%eax
  801635:	89 d7                	mov    %edx,%edi
  801637:	89 f1                	mov    %esi,%ecx
  801639:	d3 ef                	shr    %cl,%edi
  80163b:	09 c7                	or     %eax,%edi
  80163d:	89 e9                	mov    %ebp,%ecx
  80163f:	d3 e2                	shl    %cl,%edx
  801641:	89 14 24             	mov    %edx,(%esp)
  801644:	89 d8                	mov    %ebx,%eax
  801646:	d3 e0                	shl    %cl,%eax
  801648:	89 c2                	mov    %eax,%edx
  80164a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80164e:	d3 e0                	shl    %cl,%eax
  801650:	89 44 24 04          	mov    %eax,0x4(%esp)
  801654:	8b 44 24 08          	mov    0x8(%esp),%eax
  801658:	89 f1                	mov    %esi,%ecx
  80165a:	d3 e8                	shr    %cl,%eax
  80165c:	09 d0                	or     %edx,%eax
  80165e:	d3 eb                	shr    %cl,%ebx
  801660:	89 da                	mov    %ebx,%edx
  801662:	f7 f7                	div    %edi
  801664:	89 d3                	mov    %edx,%ebx
  801666:	f7 24 24             	mull   (%esp)
  801669:	89 c6                	mov    %eax,%esi
  80166b:	89 d1                	mov    %edx,%ecx
  80166d:	39 d3                	cmp    %edx,%ebx
  80166f:	0f 82 87 00 00 00    	jb     8016fc <__umoddi3+0x134>
  801675:	0f 84 91 00 00 00    	je     80170c <__umoddi3+0x144>
  80167b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80167f:	29 f2                	sub    %esi,%edx
  801681:	19 cb                	sbb    %ecx,%ebx
  801683:	89 d8                	mov    %ebx,%eax
  801685:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801689:	d3 e0                	shl    %cl,%eax
  80168b:	89 e9                	mov    %ebp,%ecx
  80168d:	d3 ea                	shr    %cl,%edx
  80168f:	09 d0                	or     %edx,%eax
  801691:	89 e9                	mov    %ebp,%ecx
  801693:	d3 eb                	shr    %cl,%ebx
  801695:	89 da                	mov    %ebx,%edx
  801697:	83 c4 1c             	add    $0x1c,%esp
  80169a:	5b                   	pop    %ebx
  80169b:	5e                   	pop    %esi
  80169c:	5f                   	pop    %edi
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    
  80169f:	90                   	nop
  8016a0:	89 fd                	mov    %edi,%ebp
  8016a2:	85 ff                	test   %edi,%edi
  8016a4:	75 0b                	jne    8016b1 <__umoddi3+0xe9>
  8016a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ab:	31 d2                	xor    %edx,%edx
  8016ad:	f7 f7                	div    %edi
  8016af:	89 c5                	mov    %eax,%ebp
  8016b1:	89 f0                	mov    %esi,%eax
  8016b3:	31 d2                	xor    %edx,%edx
  8016b5:	f7 f5                	div    %ebp
  8016b7:	89 c8                	mov    %ecx,%eax
  8016b9:	f7 f5                	div    %ebp
  8016bb:	89 d0                	mov    %edx,%eax
  8016bd:	e9 44 ff ff ff       	jmp    801606 <__umoddi3+0x3e>
  8016c2:	66 90                	xchg   %ax,%ax
  8016c4:	89 c8                	mov    %ecx,%eax
  8016c6:	89 f2                	mov    %esi,%edx
  8016c8:	83 c4 1c             	add    $0x1c,%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5e                   	pop    %esi
  8016cd:	5f                   	pop    %edi
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    
  8016d0:	3b 04 24             	cmp    (%esp),%eax
  8016d3:	72 06                	jb     8016db <__umoddi3+0x113>
  8016d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8016d9:	77 0f                	ja     8016ea <__umoddi3+0x122>
  8016db:	89 f2                	mov    %esi,%edx
  8016dd:	29 f9                	sub    %edi,%ecx
  8016df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8016e3:	89 14 24             	mov    %edx,(%esp)
  8016e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8016ee:	8b 14 24             	mov    (%esp),%edx
  8016f1:	83 c4 1c             	add    $0x1c,%esp
  8016f4:	5b                   	pop    %ebx
  8016f5:	5e                   	pop    %esi
  8016f6:	5f                   	pop    %edi
  8016f7:	5d                   	pop    %ebp
  8016f8:	c3                   	ret    
  8016f9:	8d 76 00             	lea    0x0(%esi),%esi
  8016fc:	2b 04 24             	sub    (%esp),%eax
  8016ff:	19 fa                	sbb    %edi,%edx
  801701:	89 d1                	mov    %edx,%ecx
  801703:	89 c6                	mov    %eax,%esi
  801705:	e9 71 ff ff ff       	jmp    80167b <__umoddi3+0xb3>
  80170a:	66 90                	xchg   %ax,%ax
  80170c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801710:	72 ea                	jb     8016fc <__umoddi3+0x134>
  801712:	89 d9                	mov    %ebx,%ecx
  801714:	e9 62 ff ff ff       	jmp    80167b <__umoddi3+0xb3>
