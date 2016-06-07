
obj/user/fos_add:     file format elf32-i386


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
  800031:	e8 60 00 00 00       	call   800096 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i1=0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800045:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	i1 = strtol("1", NULL, 10);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 0a                	push   $0xa
  800051:	6a 00                	push   $0x0
  800053:	68 60 17 80 00       	push   $0x801760
  800058:	e8 90 0b 00 00       	call   800bed <strtol>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	89 45 f4             	mov    %eax,-0xc(%ebp)
	i2 = strtol("2", NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	68 62 17 80 00       	push   $0x801762
  80006f:	e8 79 0b 00 00       	call   800bed <strtol>
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 64 17 80 00       	push   $0x801764
  80008b:	e8 a8 01 00 00       	call   800238 <atomic_cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
	//cprintf("number 1 + number 2 = \n");
	return;	
  800093:	90                   	nop
}
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a0:	7e 0a                	jle    8000ac <libmain+0x16>
		binaryname = argv[0];
  8000a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a5:	8b 00                	mov    (%eax),%eax
  8000a7:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	ff 75 0c             	pushl  0xc(%ebp)
  8000b2:	ff 75 08             	pushl  0x8(%ebp)
  8000b5:	e8 7e ff ff ff       	call   800038 <_main>
  8000ba:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000bd:	e8 4f 0f 00 00       	call   801011 <sys_getenvid>
  8000c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8000c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c8:	89 d0                	mov    %edx,%eax
  8000ca:	c1 e0 03             	shl    $0x3,%eax
  8000cd:	01 d0                	add    %edx,%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000da:	01 d0                	add    %edx,%eax
  8000dc:	c1 e0 03             	shl    $0x3,%eax
  8000df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8000e7:	e8 73 10 00 00       	call   80115f <sys_disable_interrupt>
		cprintf("**************************************\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 98 17 80 00       	push   $0x801798
  8000f4:	e8 19 01 00 00       	call   800212 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8000fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000ff:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800105:	83 ec 08             	sub    $0x8,%esp
  800108:	50                   	push   %eax
  800109:	68 c0 17 80 00       	push   $0x8017c0
  80010e:	e8 ff 00 00 00       	call   800212 <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	68 98 17 80 00       	push   $0x801798
  80011e:	e8 ef 00 00 00       	call   800212 <cprintf>
  800123:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800126:	e8 4e 10 00 00       	call   801179 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80012b:	e8 19 00 00 00       	call   800149 <exit>
}
  800130:	90                   	nop
  800131:	c9                   	leave  
  800132:	c3                   	ret    

00800133 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 00                	push   $0x0
  80013e:	e8 b3 0e 00 00       	call   800ff6 <sys_env_destroy>
  800143:	83 c4 10             	add    $0x10,%esp
}
  800146:	90                   	nop
  800147:	c9                   	leave  
  800148:	c3                   	ret    

00800149 <exit>:

void
exit(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80014f:	e8 d6 0e 00 00       	call   80102a <sys_env_exit>
}
  800154:	90                   	nop
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80015d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800160:	8b 00                	mov    (%eax),%eax
  800162:	8d 48 01             	lea    0x1(%eax),%ecx
  800165:	8b 55 0c             	mov    0xc(%ebp),%edx
  800168:	89 0a                	mov    %ecx,(%edx)
  80016a:	8b 55 08             	mov    0x8(%ebp),%edx
  80016d:	88 d1                	mov    %dl,%cl
  80016f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800172:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800176:	8b 45 0c             	mov    0xc(%ebp),%eax
  800179:	8b 00                	mov    (%eax),%eax
  80017b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800180:	75 23                	jne    8001a5 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800182:	8b 45 0c             	mov    0xc(%ebp),%eax
  800185:	8b 00                	mov    (%eax),%eax
  800187:	89 c2                	mov    %eax,%edx
  800189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018c:	83 c0 08             	add    $0x8,%eax
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	52                   	push   %edx
  800193:	50                   	push   %eax
  800194:	e8 27 0e 00 00       	call   800fc0 <sys_cputs>
  800199:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a8:	8b 40 04             	mov    0x4(%eax),%eax
  8001ab:	8d 50 01             	lea    0x1(%eax),%edx
  8001ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001b4:	90                   	nop
  8001b5:	c9                   	leave  
  8001b6:	c3                   	ret    

008001b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c7:	00 00 00 
	b.cnt = 0;
  8001ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8001d4:	ff 75 0c             	pushl  0xc(%ebp)
  8001d7:	ff 75 08             	pushl  0x8(%ebp)
  8001da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e0:	50                   	push   %eax
  8001e1:	68 57 01 80 00       	push   $0x800157
  8001e6:	e8 fa 01 00 00       	call   8003e5 <vprintfmt>
  8001eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8001ee:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001f4:	83 ec 08             	sub    $0x8,%esp
  8001f7:	50                   	push   %eax
  8001f8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fe:	83 c0 08             	add    $0x8,%eax
  800201:	50                   	push   %eax
  800202:	e8 b9 0d 00 00       	call   800fc0 <sys_cputs>
  800207:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80020a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <cprintf>:

int cprintf(const char *fmt, ...) {
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800218:	8d 45 0c             	lea    0xc(%ebp),%eax
  80021b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	ff 75 f4             	pushl  -0xc(%ebp)
  800227:	50                   	push   %eax
  800228:	e8 8a ff ff ff       	call   8001b7 <vcprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800233:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800236:	c9                   	leave  
  800237:	c3                   	ret    

00800238 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80023e:	e8 1c 0f 00 00       	call   80115f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800243:	8d 45 0c             	lea    0xc(%ebp),%eax
  800246:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800249:	8b 45 08             	mov    0x8(%ebp),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	ff 75 f4             	pushl  -0xc(%ebp)
  800252:	50                   	push   %eax
  800253:	e8 5f ff ff ff       	call   8001b7 <vcprintf>
  800258:	83 c4 10             	add    $0x10,%esp
  80025b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80025e:	e8 16 0f 00 00       	call   801179 <sys_enable_interrupt>
	return cnt;
  800263:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800266:	c9                   	leave  
  800267:	c3                   	ret    

00800268 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	53                   	push   %ebx
  80026c:	83 ec 14             	sub    $0x14,%esp
  80026f:	8b 45 10             	mov    0x10(%ebp),%eax
  800272:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800275:	8b 45 14             	mov    0x14(%ebp),%eax
  800278:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80027b:	8b 45 18             	mov    0x18(%ebp),%eax
  80027e:	ba 00 00 00 00       	mov    $0x0,%edx
  800283:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800286:	77 55                	ja     8002dd <printnum+0x75>
  800288:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80028b:	72 05                	jb     800292 <printnum+0x2a>
  80028d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800290:	77 4b                	ja     8002dd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800292:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800295:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800298:	8b 45 18             	mov    0x18(%ebp),%eax
  80029b:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a0:	52                   	push   %edx
  8002a1:	50                   	push   %eax
  8002a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8002a8:	e8 4f 12 00 00       	call   8014fc <__udivdi3>
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	ff 75 20             	pushl  0x20(%ebp)
  8002b6:	53                   	push   %ebx
  8002b7:	ff 75 18             	pushl  0x18(%ebp)
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	ff 75 0c             	pushl  0xc(%ebp)
  8002bf:	ff 75 08             	pushl  0x8(%ebp)
  8002c2:	e8 a1 ff ff ff       	call   800268 <printnum>
  8002c7:	83 c4 20             	add    $0x20,%esp
  8002ca:	eb 1a                	jmp    8002e6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 20             	pushl  0x20(%ebp)
  8002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d8:	ff d0                	call   *%eax
  8002da:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002dd:	ff 4d 1c             	decl   0x1c(%ebp)
  8002e0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8002e4:	7f e6                	jg     8002cc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002f4:	53                   	push   %ebx
  8002f5:	51                   	push   %ecx
  8002f6:	52                   	push   %edx
  8002f7:	50                   	push   %eax
  8002f8:	e8 0f 13 00 00       	call   80160c <__umoddi3>
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	05 f4 19 80 00       	add    $0x8019f4,%eax
  800305:	8a 00                	mov    (%eax),%al
  800307:	0f be c0             	movsbl %al,%eax
  80030a:	83 ec 08             	sub    $0x8,%esp
  80030d:	ff 75 0c             	pushl  0xc(%ebp)
  800310:	50                   	push   %eax
  800311:	8b 45 08             	mov    0x8(%ebp),%eax
  800314:	ff d0                	call   *%eax
  800316:	83 c4 10             	add    $0x10,%esp
}
  800319:	90                   	nop
  80031a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800322:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800326:	7e 1c                	jle    800344 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	8b 00                	mov    (%eax),%eax
  80032d:	8d 50 08             	lea    0x8(%eax),%edx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	89 10                	mov    %edx,(%eax)
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	83 e8 08             	sub    $0x8,%eax
  80033d:	8b 50 04             	mov    0x4(%eax),%edx
  800340:	8b 00                	mov    (%eax),%eax
  800342:	eb 40                	jmp    800384 <getuint+0x65>
	else if (lflag)
  800344:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800348:	74 1e                	je     800368 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80034a:	8b 45 08             	mov    0x8(%ebp),%eax
  80034d:	8b 00                	mov    (%eax),%eax
  80034f:	8d 50 04             	lea    0x4(%eax),%edx
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	89 10                	mov    %edx,(%eax)
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	8b 00                	mov    (%eax),%eax
  80035c:	83 e8 04             	sub    $0x4,%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	ba 00 00 00 00       	mov    $0x0,%edx
  800366:	eb 1c                	jmp    800384 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800368:	8b 45 08             	mov    0x8(%ebp),%eax
  80036b:	8b 00                	mov    (%eax),%eax
  80036d:	8d 50 04             	lea    0x4(%eax),%edx
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	89 10                	mov    %edx,(%eax)
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	83 e8 04             	sub    $0x4,%eax
  80037d:	8b 00                	mov    (%eax),%eax
  80037f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800384:	5d                   	pop    %ebp
  800385:	c3                   	ret    

00800386 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800389:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80038d:	7e 1c                	jle    8003ab <getint+0x25>
		return va_arg(*ap, long long);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	8d 50 08             	lea    0x8(%eax),%edx
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	89 10                	mov    %edx,(%eax)
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	83 e8 08             	sub    $0x8,%eax
  8003a4:	8b 50 04             	mov    0x4(%eax),%edx
  8003a7:	8b 00                	mov    (%eax),%eax
  8003a9:	eb 38                	jmp    8003e3 <getint+0x5d>
	else if (lflag)
  8003ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003af:	74 1a                	je     8003cb <getint+0x45>
		return va_arg(*ap, long);
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	8b 00                	mov    (%eax),%eax
  8003b6:	8d 50 04             	lea    0x4(%eax),%edx
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	89 10                	mov    %edx,(%eax)
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	83 e8 04             	sub    $0x4,%eax
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	99                   	cltd   
  8003c9:	eb 18                	jmp    8003e3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8003cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	8d 50 04             	lea    0x4(%eax),%edx
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	89 10                	mov    %edx,(%eax)
  8003d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003db:	8b 00                	mov    (%eax),%eax
  8003dd:	83 e8 04             	sub    $0x4,%eax
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	99                   	cltd   
}
  8003e3:	5d                   	pop    %ebp
  8003e4:	c3                   	ret    

008003e5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	56                   	push   %esi
  8003e9:	53                   	push   %ebx
  8003ea:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ed:	eb 17                	jmp    800406 <vprintfmt+0x21>
			if (ch == '\0')
  8003ef:	85 db                	test   %ebx,%ebx
  8003f1:	0f 84 af 03 00 00    	je     8007a6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8003f7:	83 ec 08             	sub    $0x8,%esp
  8003fa:	ff 75 0c             	pushl  0xc(%ebp)
  8003fd:	53                   	push   %ebx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	ff d0                	call   *%eax
  800403:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800406:	8b 45 10             	mov    0x10(%ebp),%eax
  800409:	8d 50 01             	lea    0x1(%eax),%edx
  80040c:	89 55 10             	mov    %edx,0x10(%ebp)
  80040f:	8a 00                	mov    (%eax),%al
  800411:	0f b6 d8             	movzbl %al,%ebx
  800414:	83 fb 25             	cmp    $0x25,%ebx
  800417:	75 d6                	jne    8003ef <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800419:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80041d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800424:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80042b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800432:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800439:	8b 45 10             	mov    0x10(%ebp),%eax
  80043c:	8d 50 01             	lea    0x1(%eax),%edx
  80043f:	89 55 10             	mov    %edx,0x10(%ebp)
  800442:	8a 00                	mov    (%eax),%al
  800444:	0f b6 d8             	movzbl %al,%ebx
  800447:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80044a:	83 f8 55             	cmp    $0x55,%eax
  80044d:	0f 87 2b 03 00 00    	ja     80077e <vprintfmt+0x399>
  800453:	8b 04 85 18 1a 80 00 	mov    0x801a18(,%eax,4),%eax
  80045a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80045c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800460:	eb d7                	jmp    800439 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800462:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800466:	eb d1                	jmp    800439 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800468:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80046f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800472:	89 d0                	mov    %edx,%eax
  800474:	c1 e0 02             	shl    $0x2,%eax
  800477:	01 d0                	add    %edx,%eax
  800479:	01 c0                	add    %eax,%eax
  80047b:	01 d8                	add    %ebx,%eax
  80047d:	83 e8 30             	sub    $0x30,%eax
  800480:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800483:	8b 45 10             	mov    0x10(%ebp),%eax
  800486:	8a 00                	mov    (%eax),%al
  800488:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80048b:	83 fb 2f             	cmp    $0x2f,%ebx
  80048e:	7e 3e                	jle    8004ce <vprintfmt+0xe9>
  800490:	83 fb 39             	cmp    $0x39,%ebx
  800493:	7f 39                	jg     8004ce <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800495:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800498:	eb d5                	jmp    80046f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	83 c0 04             	add    $0x4,%eax
  8004a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a6:	83 e8 04             	sub    $0x4,%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004ae:	eb 1f                	jmp    8004cf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8004b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004b4:	79 83                	jns    800439 <vprintfmt+0x54>
				width = 0;
  8004b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8004bd:	e9 77 ff ff ff       	jmp    800439 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8004c2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004c9:	e9 6b ff ff ff       	jmp    800439 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8004ce:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004d3:	0f 89 60 ff ff ff    	jns    800439 <vprintfmt+0x54>
				width = precision, precision = -1;
  8004d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8004e6:	e9 4e ff ff ff       	jmp    800439 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004eb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8004ee:	e9 46 ff ff ff       	jmp    800439 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	83 c0 04             	add    $0x4,%eax
  8004f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	83 e8 04             	sub    $0x4,%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	ff 75 0c             	pushl  0xc(%ebp)
  80050a:	50                   	push   %eax
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	ff d0                	call   *%eax
  800510:	83 c4 10             	add    $0x10,%esp
			break;
  800513:	e9 89 02 00 00       	jmp    8007a1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	83 c0 04             	add    $0x4,%eax
  80051e:	89 45 14             	mov    %eax,0x14(%ebp)
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	83 e8 04             	sub    $0x4,%eax
  800527:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800529:	85 db                	test   %ebx,%ebx
  80052b:	79 02                	jns    80052f <vprintfmt+0x14a>
				err = -err;
  80052d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80052f:	83 fb 64             	cmp    $0x64,%ebx
  800532:	7f 0b                	jg     80053f <vprintfmt+0x15a>
  800534:	8b 34 9d 60 18 80 00 	mov    0x801860(,%ebx,4),%esi
  80053b:	85 f6                	test   %esi,%esi
  80053d:	75 19                	jne    800558 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80053f:	53                   	push   %ebx
  800540:	68 05 1a 80 00       	push   $0x801a05
  800545:	ff 75 0c             	pushl  0xc(%ebp)
  800548:	ff 75 08             	pushl  0x8(%ebp)
  80054b:	e8 5e 02 00 00       	call   8007ae <printfmt>
  800550:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800553:	e9 49 02 00 00       	jmp    8007a1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800558:	56                   	push   %esi
  800559:	68 0e 1a 80 00       	push   $0x801a0e
  80055e:	ff 75 0c             	pushl  0xc(%ebp)
  800561:	ff 75 08             	pushl  0x8(%ebp)
  800564:	e8 45 02 00 00       	call   8007ae <printfmt>
  800569:	83 c4 10             	add    $0x10,%esp
			break;
  80056c:	e9 30 02 00 00       	jmp    8007a1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	83 c0 04             	add    $0x4,%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	83 e8 04             	sub    $0x4,%eax
  800580:	8b 30                	mov    (%eax),%esi
  800582:	85 f6                	test   %esi,%esi
  800584:	75 05                	jne    80058b <vprintfmt+0x1a6>
				p = "(null)";
  800586:	be 11 1a 80 00       	mov    $0x801a11,%esi
			if (width > 0 && padc != '-')
  80058b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058f:	7e 6d                	jle    8005fe <vprintfmt+0x219>
  800591:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800595:	74 67                	je     8005fe <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800597:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	50                   	push   %eax
  80059e:	56                   	push   %esi
  80059f:	e8 0c 03 00 00       	call   8008b0 <strnlen>
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005aa:	eb 16                	jmp    8005c2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8005ac:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	ff 75 0c             	pushl  0xc(%ebp)
  8005b6:	50                   	push   %eax
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	ff d0                	call   *%eax
  8005bc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8005c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c6:	7f e4                	jg     8005ac <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c8:	eb 34                	jmp    8005fe <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005ce:	74 1c                	je     8005ec <vprintfmt+0x207>
  8005d0:	83 fb 1f             	cmp    $0x1f,%ebx
  8005d3:	7e 05                	jle    8005da <vprintfmt+0x1f5>
  8005d5:	83 fb 7e             	cmp    $0x7e,%ebx
  8005d8:	7e 12                	jle    8005ec <vprintfmt+0x207>
					putch('?', putdat);
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	ff 75 0c             	pushl  0xc(%ebp)
  8005e0:	6a 3f                	push   $0x3f
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	ff d0                	call   *%eax
  8005e7:	83 c4 10             	add    $0x10,%esp
  8005ea:	eb 0f                	jmp    8005fb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	53                   	push   %ebx
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	ff d0                	call   *%eax
  8005f8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fb:	ff 4d e4             	decl   -0x1c(%ebp)
  8005fe:	89 f0                	mov    %esi,%eax
  800600:	8d 70 01             	lea    0x1(%eax),%esi
  800603:	8a 00                	mov    (%eax),%al
  800605:	0f be d8             	movsbl %al,%ebx
  800608:	85 db                	test   %ebx,%ebx
  80060a:	74 24                	je     800630 <vprintfmt+0x24b>
  80060c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800610:	78 b8                	js     8005ca <vprintfmt+0x1e5>
  800612:	ff 4d e0             	decl   -0x20(%ebp)
  800615:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800619:	79 af                	jns    8005ca <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80061b:	eb 13                	jmp    800630 <vprintfmt+0x24b>
				putch(' ', putdat);
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	ff 75 0c             	pushl  0xc(%ebp)
  800623:	6a 20                	push   $0x20
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	ff d0                	call   *%eax
  80062a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80062d:	ff 4d e4             	decl   -0x1c(%ebp)
  800630:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800634:	7f e7                	jg     80061d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800636:	e9 66 01 00 00       	jmp    8007a1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	ff 75 e8             	pushl  -0x18(%ebp)
  800641:	8d 45 14             	lea    0x14(%ebp),%eax
  800644:	50                   	push   %eax
  800645:	e8 3c fd ff ff       	call   800386 <getint>
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800650:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800659:	85 d2                	test   %edx,%edx
  80065b:	79 23                	jns    800680 <vprintfmt+0x29b>
				putch('-', putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	6a 2d                	push   $0x2d
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	ff d0                	call   *%eax
  80066a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800673:	f7 d8                	neg    %eax
  800675:	83 d2 00             	adc    $0x0,%edx
  800678:	f7 da                	neg    %edx
  80067a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80067d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800680:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800687:	e9 bc 00 00 00       	jmp    800748 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	ff 75 e8             	pushl  -0x18(%ebp)
  800692:	8d 45 14             	lea    0x14(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	e8 84 fc ff ff       	call   80031f <getuint>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006a4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006ab:	e9 98 00 00 00       	jmp    800748 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	ff 75 0c             	pushl  0xc(%ebp)
  8006b6:	6a 58                	push   $0x58
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	ff d0                	call   *%eax
  8006bd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	ff 75 0c             	pushl  0xc(%ebp)
  8006c6:	6a 58                	push   $0x58
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	ff d0                	call   *%eax
  8006cd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	6a 58                	push   $0x58
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	ff d0                	call   *%eax
  8006dd:	83 c4 10             	add    $0x10,%esp
			break;
  8006e0:	e9 bc 00 00 00       	jmp    8007a1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	ff 75 0c             	pushl  0xc(%ebp)
  8006eb:	6a 30                	push   $0x30
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	ff d0                	call   *%eax
  8006f2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	6a 78                	push   $0x78
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	83 c0 04             	add    $0x4,%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	83 e8 04             	sub    $0x4,%eax
  800714:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800716:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800719:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800720:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800727:	eb 1f                	jmp    800748 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 e8             	pushl  -0x18(%ebp)
  80072f:	8d 45 14             	lea    0x14(%ebp),%eax
  800732:	50                   	push   %eax
  800733:	e8 e7 fb ff ff       	call   80031f <getuint>
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800741:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800748:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80074c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	52                   	push   %edx
  800753:	ff 75 e4             	pushl  -0x1c(%ebp)
  800756:	50                   	push   %eax
  800757:	ff 75 f4             	pushl  -0xc(%ebp)
  80075a:	ff 75 f0             	pushl  -0x10(%ebp)
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	ff 75 08             	pushl  0x8(%ebp)
  800763:	e8 00 fb ff ff       	call   800268 <printnum>
  800768:	83 c4 20             	add    $0x20,%esp
			break;
  80076b:	eb 34                	jmp    8007a1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	53                   	push   %ebx
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	ff d0                	call   *%eax
  800779:	83 c4 10             	add    $0x10,%esp
			break;
  80077c:	eb 23                	jmp    8007a1 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 0c             	pushl  0xc(%ebp)
  800784:	6a 25                	push   $0x25
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	ff d0                	call   *%eax
  80078b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80078e:	ff 4d 10             	decl   0x10(%ebp)
  800791:	eb 03                	jmp    800796 <vprintfmt+0x3b1>
  800793:	ff 4d 10             	decl   0x10(%ebp)
  800796:	8b 45 10             	mov    0x10(%ebp),%eax
  800799:	48                   	dec    %eax
  80079a:	8a 00                	mov    (%eax),%al
  80079c:	3c 25                	cmp    $0x25,%al
  80079e:	75 f3                	jne    800793 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007a0:	90                   	nop
		}
	}
  8007a1:	e9 47 fc ff ff       	jmp    8003ed <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007a6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007aa:	5b                   	pop    %ebx
  8007ab:	5e                   	pop    %esi
  8007ac:	5d                   	pop    %ebp
  8007ad:	c3                   	ret    

008007ae <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8007b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8007bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c3:	50                   	push   %eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 16 fc ff ff       	call   8003e5 <vprintfmt>
  8007cf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8007d2:	90                   	nop
  8007d3:	c9                   	leave  
  8007d4:	c3                   	ret    

008007d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8007d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007db:	8b 40 08             	mov    0x8(%eax),%eax
  8007de:	8d 50 01             	lea    0x1(%eax),%edx
  8007e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8007e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ea:	8b 10                	mov    (%eax),%edx
  8007ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ef:	8b 40 04             	mov    0x4(%eax),%eax
  8007f2:	39 c2                	cmp    %eax,%edx
  8007f4:	73 12                	jae    800808 <sprintputch+0x33>
		*b->buf++ = ch;
  8007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	8d 48 01             	lea    0x1(%eax),%ecx
  8007fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800801:	89 0a                	mov    %ecx,(%edx)
  800803:	8b 55 08             	mov    0x8(%ebp),%edx
  800806:	88 10                	mov    %dl,(%eax)
}
  800808:	90                   	nop
  800809:	5d                   	pop    %ebp
  80080a:	c3                   	ret    

0080080b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	01 d0                	add    %edx,%eax
  800822:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800825:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800830:	74 06                	je     800838 <vsnprintf+0x2d>
  800832:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800836:	7f 07                	jg     80083f <vsnprintf+0x34>
		return -E_INVAL;
  800838:	b8 03 00 00 00       	mov    $0x3,%eax
  80083d:	eb 20                	jmp    80085f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80083f:	ff 75 14             	pushl  0x14(%ebp)
  800842:	ff 75 10             	pushl  0x10(%ebp)
  800845:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800848:	50                   	push   %eax
  800849:	68 d5 07 80 00       	push   $0x8007d5
  80084e:	e8 92 fb ff ff       	call   8003e5 <vprintfmt>
  800853:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800859:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800867:	8d 45 10             	lea    0x10(%ebp),%eax
  80086a:	83 c0 04             	add    $0x4,%eax
  80086d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800870:	8b 45 10             	mov    0x10(%ebp),%eax
  800873:	ff 75 f4             	pushl  -0xc(%ebp)
  800876:	50                   	push   %eax
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	ff 75 08             	pushl  0x8(%ebp)
  80087d:	e8 89 ff ff ff       	call   80080b <vsnprintf>
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800888:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    

0080088d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800893:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80089a:	eb 06                	jmp    8008a2 <strlen+0x15>
		n++;
  80089c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80089f:	ff 45 08             	incl   0x8(%ebp)
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8a 00                	mov    (%eax),%al
  8008a7:	84 c0                	test   %al,%al
  8008a9:	75 f1                	jne    80089c <strlen+0xf>
		n++;
	return n;
  8008ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008bd:	eb 09                	jmp    8008c8 <strnlen+0x18>
		n++;
  8008bf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c2:	ff 45 08             	incl   0x8(%ebp)
  8008c5:	ff 4d 0c             	decl   0xc(%ebp)
  8008c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008cc:	74 09                	je     8008d7 <strnlen+0x27>
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8a 00                	mov    (%eax),%al
  8008d3:	84 c0                	test   %al,%al
  8008d5:	75 e8                	jne    8008bf <strnlen+0xf>
		n++;
	return n;
  8008d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008da:	c9                   	leave  
  8008db:	c3                   	ret    

008008dc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8008e8:	90                   	nop
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8d 50 01             	lea    0x1(%eax),%edx
  8008ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8008fb:	8a 12                	mov    (%edx),%dl
  8008fd:	88 10                	mov    %dl,(%eax)
  8008ff:	8a 00                	mov    (%eax),%al
  800901:	84 c0                	test   %al,%al
  800903:	75 e4                	jne    8008e9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800905:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800908:	c9                   	leave  
  800909:	c3                   	ret    

0080090a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800916:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80091d:	eb 1f                	jmp    80093e <strncpy+0x34>
		*dst++ = *src;
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8d 50 01             	lea    0x1(%eax),%edx
  800925:	89 55 08             	mov    %edx,0x8(%ebp)
  800928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092b:	8a 12                	mov    (%edx),%dl
  80092d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800932:	8a 00                	mov    (%eax),%al
  800934:	84 c0                	test   %al,%al
  800936:	74 03                	je     80093b <strncpy+0x31>
			src++;
  800938:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093b:	ff 45 fc             	incl   -0x4(%ebp)
  80093e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800941:	3b 45 10             	cmp    0x10(%ebp),%eax
  800944:	72 d9                	jb     80091f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800946:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800949:	c9                   	leave  
  80094a:	c3                   	ret    

0080094b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800957:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80095b:	74 30                	je     80098d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80095d:	eb 16                	jmp    800975 <strlcpy+0x2a>
			*dst++ = *src++;
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8d 50 01             	lea    0x1(%eax),%edx
  800965:	89 55 08             	mov    %edx,0x8(%ebp)
  800968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80096e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800971:	8a 12                	mov    (%edx),%dl
  800973:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800975:	ff 4d 10             	decl   0x10(%ebp)
  800978:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80097c:	74 09                	je     800987 <strlcpy+0x3c>
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	8a 00                	mov    (%eax),%al
  800983:	84 c0                	test   %al,%al
  800985:	75 d8                	jne    80095f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098d:	8b 55 08             	mov    0x8(%ebp),%edx
  800990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800993:	29 c2                	sub    %eax,%edx
  800995:	89 d0                	mov    %edx,%eax
}
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80099c:	eb 06                	jmp    8009a4 <strcmp+0xb>
		p++, q++;
  80099e:	ff 45 08             	incl   0x8(%ebp)
  8009a1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8a 00                	mov    (%eax),%al
  8009a9:	84 c0                	test   %al,%al
  8009ab:	74 0e                	je     8009bb <strcmp+0x22>
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8a 10                	mov    (%eax),%dl
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	8a 00                	mov    (%eax),%al
  8009b7:	38 c2                	cmp    %al,%dl
  8009b9:	74 e3                	je     80099e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8a 00                	mov    (%eax),%al
  8009c0:	0f b6 d0             	movzbl %al,%edx
  8009c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c6:	8a 00                	mov    (%eax),%al
  8009c8:	0f b6 c0             	movzbl %al,%eax
  8009cb:	29 c2                	sub    %eax,%edx
  8009cd:	89 d0                	mov    %edx,%eax
}
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8009d4:	eb 09                	jmp    8009df <strncmp+0xe>
		n--, p++, q++;
  8009d6:	ff 4d 10             	decl   0x10(%ebp)
  8009d9:	ff 45 08             	incl   0x8(%ebp)
  8009dc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8009df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009e3:	74 17                	je     8009fc <strncmp+0x2b>
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8a 00                	mov    (%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	74 0e                	je     8009fc <strncmp+0x2b>
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8a 10                	mov    (%eax),%dl
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8a 00                	mov    (%eax),%al
  8009f8:	38 c2                	cmp    %al,%dl
  8009fa:	74 da                	je     8009d6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8009fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a00:	75 07                	jne    800a09 <strncmp+0x38>
		return 0;
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
  800a07:	eb 14                	jmp    800a1d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8a 00                	mov    (%eax),%al
  800a0e:	0f b6 d0             	movzbl %al,%edx
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	29 c2                	sub    %eax,%edx
  800a1b:	89 d0                	mov    %edx,%eax
}
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 04             	sub    $0x4,%esp
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a2b:	eb 12                	jmp    800a3f <strchr+0x20>
		if (*s == c)
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8a 00                	mov    (%eax),%al
  800a32:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a35:	75 05                	jne    800a3c <strchr+0x1d>
			return (char *) s;
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	eb 11                	jmp    800a4d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a3c:	ff 45 08             	incl   0x8(%ebp)
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e5                	jne    800a2d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 04             	sub    $0x4,%esp
  800a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a58:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a5b:	eb 0d                	jmp    800a6a <strfind+0x1b>
		if (*s == c)
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	8a 00                	mov    (%eax),%al
  800a62:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a65:	74 0e                	je     800a75 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a67:	ff 45 08             	incl   0x8(%ebp)
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8a 00                	mov    (%eax),%al
  800a6f:	84 c0                	test   %al,%al
  800a71:	75 ea                	jne    800a5d <strfind+0xe>
  800a73:	eb 01                	jmp    800a76 <strfind+0x27>
		if (*s == c)
			break;
  800a75:	90                   	nop
	return (char *) s;
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800a87:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800a8d:	eb 0e                	jmp    800a9d <memset+0x22>
		*p++ = c;
  800a8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800a9d:	ff 4d f8             	decl   -0x8(%ebp)
  800aa0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800aa4:	79 e9                	jns    800a8f <memset+0x14>
		*p++ = c;

	return v;
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800abd:	eb 16                	jmp    800ad5 <memcpy+0x2a>
		*d++ = *s++;
  800abf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ac2:	8d 50 01             	lea    0x1(%eax),%edx
  800ac5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ac8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800acb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ace:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ad1:	8a 12                	mov    (%edx),%dl
  800ad3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ad5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800adb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ade:	85 c0                	test   %eax,%eax
  800ae0:	75 dd                	jne    800abf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    

00800ae7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800af9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800afc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800aff:	73 50                	jae    800b51 <memmove+0x6a>
  800b01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b04:	8b 45 10             	mov    0x10(%ebp),%eax
  800b07:	01 d0                	add    %edx,%eax
  800b09:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b0c:	76 43                	jbe    800b51 <memmove+0x6a>
		s += n;
  800b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b11:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b14:	8b 45 10             	mov    0x10(%ebp),%eax
  800b17:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b1a:	eb 10                	jmp    800b2c <memmove+0x45>
			*--d = *--s;
  800b1c:	ff 4d f8             	decl   -0x8(%ebp)
  800b1f:	ff 4d fc             	decl   -0x4(%ebp)
  800b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b25:	8a 10                	mov    (%eax),%dl
  800b27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b2a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b32:	89 55 10             	mov    %edx,0x10(%ebp)
  800b35:	85 c0                	test   %eax,%eax
  800b37:	75 e3                	jne    800b1c <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b39:	eb 23                	jmp    800b5e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b47:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b4d:	8a 12                	mov    (%edx),%dl
  800b4f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800b51:	8b 45 10             	mov    0x10(%ebp),%eax
  800b54:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b57:	89 55 10             	mov    %edx,0x10(%ebp)
  800b5a:	85 c0                	test   %eax,%eax
  800b5c:	75 dd                	jne    800b3b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800b75:	eb 2a                	jmp    800ba1 <memcmp+0x3e>
		if (*s1 != *s2)
  800b77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7a:	8a 10                	mov    (%eax),%dl
  800b7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	38 c2                	cmp    %al,%dl
  800b83:	74 16                	je     800b9b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	0f b6 d0             	movzbl %al,%edx
  800b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b90:	8a 00                	mov    (%eax),%al
  800b92:	0f b6 c0             	movzbl %al,%eax
  800b95:	29 c2                	sub    %eax,%edx
  800b97:	89 d0                	mov    %edx,%eax
  800b99:	eb 18                	jmp    800bb3 <memcmp+0x50>
		s1++, s2++;
  800b9b:	ff 45 fc             	incl   -0x4(%ebp)
  800b9e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ba1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba7:	89 55 10             	mov    %edx,0x10(%ebp)
  800baa:	85 c0                	test   %eax,%eax
  800bac:	75 c9                	jne    800b77 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800bbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc1:	01 d0                	add    %edx,%eax
  800bc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800bc6:	eb 15                	jmp    800bdd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8a 00                	mov    (%eax),%al
  800bcd:	0f b6 d0             	movzbl %al,%edx
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	0f b6 c0             	movzbl %al,%eax
  800bd6:	39 c2                	cmp    %eax,%edx
  800bd8:	74 0d                	je     800be7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bda:	ff 45 08             	incl   0x8(%ebp)
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800be3:	72 e3                	jb     800bc8 <memfind+0x13>
  800be5:	eb 01                	jmp    800be8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800be7:	90                   	nop
	return (void *) s;
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800bf3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800bfa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c01:	eb 03                	jmp    800c06 <strtol+0x19>
		s++;
  800c03:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	3c 20                	cmp    $0x20,%al
  800c0d:	74 f4                	je     800c03 <strtol+0x16>
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	3c 09                	cmp    $0x9,%al
  800c16:	74 eb                	je     800c03 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	3c 2b                	cmp    $0x2b,%al
  800c1f:	75 05                	jne    800c26 <strtol+0x39>
		s++;
  800c21:	ff 45 08             	incl   0x8(%ebp)
  800c24:	eb 13                	jmp    800c39 <strtol+0x4c>
	else if (*s == '-')
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	3c 2d                	cmp    $0x2d,%al
  800c2d:	75 0a                	jne    800c39 <strtol+0x4c>
		s++, neg = 1;
  800c2f:	ff 45 08             	incl   0x8(%ebp)
  800c32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3d:	74 06                	je     800c45 <strtol+0x58>
  800c3f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c43:	75 20                	jne    800c65 <strtol+0x78>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	3c 30                	cmp    $0x30,%al
  800c4c:	75 17                	jne    800c65 <strtol+0x78>
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	40                   	inc    %eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	3c 78                	cmp    $0x78,%al
  800c56:	75 0d                	jne    800c65 <strtol+0x78>
		s += 2, base = 16;
  800c58:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800c5c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c63:	eb 28                	jmp    800c8d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800c65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c69:	75 15                	jne    800c80 <strtol+0x93>
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	3c 30                	cmp    $0x30,%al
  800c72:	75 0c                	jne    800c80 <strtol+0x93>
		s++, base = 8;
  800c74:	ff 45 08             	incl   0x8(%ebp)
  800c77:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800c7e:	eb 0d                	jmp    800c8d <strtol+0xa0>
	else if (base == 0)
  800c80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c84:	75 07                	jne    800c8d <strtol+0xa0>
		base = 10;
  800c86:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	3c 2f                	cmp    $0x2f,%al
  800c94:	7e 19                	jle    800caf <strtol+0xc2>
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	3c 39                	cmp    $0x39,%al
  800c9d:	7f 10                	jg     800caf <strtol+0xc2>
			dig = *s - '0';
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	0f be c0             	movsbl %al,%eax
  800ca7:	83 e8 30             	sub    $0x30,%eax
  800caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800cad:	eb 42                	jmp    800cf1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	3c 60                	cmp    $0x60,%al
  800cb6:	7e 19                	jle    800cd1 <strtol+0xe4>
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	3c 7a                	cmp    $0x7a,%al
  800cbf:	7f 10                	jg     800cd1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	0f be c0             	movsbl %al,%eax
  800cc9:	83 e8 57             	sub    $0x57,%eax
  800ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ccf:	eb 20                	jmp    800cf1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	3c 40                	cmp    $0x40,%al
  800cd8:	7e 39                	jle    800d13 <strtol+0x126>
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	3c 5a                	cmp    $0x5a,%al
  800ce1:	7f 30                	jg     800d13 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f be c0             	movsbl %al,%eax
  800ceb:	83 e8 37             	sub    $0x37,%eax
  800cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cf4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cf7:	7d 19                	jge    800d12 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cff:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d03:	89 c2                	mov    %eax,%edx
  800d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d08:	01 d0                	add    %edx,%eax
  800d0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d0d:	e9 7b ff ff ff       	jmp    800c8d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d12:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d17:	74 08                	je     800d21 <strtol+0x134>
		*endptr = (char *) s;
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d25:	74 07                	je     800d2e <strtol+0x141>
  800d27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2a:	f7 d8                	neg    %eax
  800d2c:	eb 03                	jmp    800d31 <strtol+0x144>
  800d2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d31:	c9                   	leave  
  800d32:	c3                   	ret    

00800d33 <ltostr>:

void
ltostr(long value, char *str)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d40:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d4b:	79 13                	jns    800d60 <ltostr+0x2d>
	{
		neg = 1;
  800d4d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800d5a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800d5d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800d68:	99                   	cltd   
  800d69:	f7 f9                	idiv   %ecx
  800d6b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800d6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d71:	8d 50 01             	lea    0x1(%eax),%edx
  800d74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d77:	89 c2                	mov    %eax,%edx
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	01 d0                	add    %edx,%eax
  800d7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d81:	83 c2 30             	add    $0x30,%edx
  800d84:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800d86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d89:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800d8e:	f7 e9                	imul   %ecx
  800d90:	c1 fa 02             	sar    $0x2,%edx
  800d93:	89 c8                	mov    %ecx,%eax
  800d95:	c1 f8 1f             	sar    $0x1f,%eax
  800d98:	29 c2                	sub    %eax,%edx
  800d9a:	89 d0                	mov    %edx,%eax
  800d9c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800d9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800da7:	f7 e9                	imul   %ecx
  800da9:	c1 fa 02             	sar    $0x2,%edx
  800dac:	89 c8                	mov    %ecx,%eax
  800dae:	c1 f8 1f             	sar    $0x1f,%eax
  800db1:	29 c2                	sub    %eax,%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	c1 e0 02             	shl    $0x2,%eax
  800db8:	01 d0                	add    %edx,%eax
  800dba:	01 c0                	add    %eax,%eax
  800dbc:	29 c1                	sub    %eax,%ecx
  800dbe:	89 ca                	mov    %ecx,%edx
  800dc0:	85 d2                	test   %edx,%edx
  800dc2:	75 9c                	jne    800d60 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800dc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	48                   	dec    %eax
  800dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800dd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dd6:	74 3d                	je     800e15 <ltostr+0xe2>
		start = 1 ;
  800dd8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ddf:	eb 34                	jmp    800e15 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	01 d0                	add    %edx,%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800dee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	01 c2                	add    %eax,%edx
  800df6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	01 c8                	add    %ecx,%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e08:	01 c2                	add    %eax,%edx
  800e0a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e0d:	88 02                	mov    %al,(%edx)
		start++ ;
  800e0f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e12:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e18:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e1b:	7c c4                	jl     800de1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e1d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	01 d0                	add    %edx,%eax
  800e25:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e28:	90                   	nop
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e31:	ff 75 08             	pushl  0x8(%ebp)
  800e34:	e8 54 fa ff ff       	call   80088d <strlen>
  800e39:	83 c4 04             	add    $0x4,%esp
  800e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e3f:	ff 75 0c             	pushl  0xc(%ebp)
  800e42:	e8 46 fa ff ff       	call   80088d <strlen>
  800e47:	83 c4 04             	add    $0x4,%esp
  800e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800e54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5b:	eb 17                	jmp    800e74 <strcconcat+0x49>
		final[s] = str1[s] ;
  800e5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e60:	8b 45 10             	mov    0x10(%ebp),%eax
  800e63:	01 c2                	add    %eax,%edx
  800e65:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	01 c8                	add    %ecx,%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800e71:	ff 45 fc             	incl   -0x4(%ebp)
  800e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e77:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e7a:	7c e1                	jl     800e5d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800e7c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800e83:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800e8a:	eb 1f                	jmp    800eab <strcconcat+0x80>
		final[s++] = str2[i] ;
  800e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8f:	8d 50 01             	lea    0x1(%eax),%edx
  800e92:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e95:	89 c2                	mov    %eax,%edx
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	01 c2                	add    %eax,%edx
  800e9c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	01 c8                	add    %ecx,%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ea8:	ff 45 f8             	incl   -0x8(%ebp)
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eb1:	7c d9                	jl     800e8c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800eb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	c6 00 00             	movb   $0x0,(%eax)
}
  800ebe:	90                   	nop
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800ec4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	8b 00                	mov    (%eax),%eax
  800ed2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	01 d0                	add    %edx,%eax
  800ede:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800ee4:	eb 0c                	jmp    800ef2 <strsplit+0x31>
			*string++ = 0;
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 08             	mov    %edx,0x8(%ebp)
  800eef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	84 c0                	test   %al,%al
  800ef9:	74 18                	je     800f13 <strsplit+0x52>
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	0f be c0             	movsbl %al,%eax
  800f03:	50                   	push   %eax
  800f04:	ff 75 0c             	pushl  0xc(%ebp)
  800f07:	e8 13 fb ff ff       	call   800a1f <strchr>
  800f0c:	83 c4 08             	add    $0x8,%esp
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	75 d3                	jne    800ee6 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	84 c0                	test   %al,%al
  800f1a:	74 5a                	je     800f76 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  800f1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 f8 0f             	cmp    $0xf,%eax
  800f24:	75 07                	jne    800f2d <strsplit+0x6c>
		{
			return 0;
  800f26:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2b:	eb 66                	jmp    800f93 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f30:	8b 00                	mov    (%eax),%eax
  800f32:	8d 48 01             	lea    0x1(%eax),%ecx
  800f35:	8b 55 14             	mov    0x14(%ebp),%edx
  800f38:	89 0a                	mov    %ecx,(%edx)
  800f3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 c2                	add    %eax,%edx
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f4b:	eb 03                	jmp    800f50 <strsplit+0x8f>
			string++;
  800f4d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	84 c0                	test   %al,%al
  800f57:	74 8b                	je     800ee4 <strsplit+0x23>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f be c0             	movsbl %al,%eax
  800f61:	50                   	push   %eax
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	e8 b5 fa ff ff       	call   800a1f <strchr>
  800f6a:	83 c4 08             	add    $0x8,%esp
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	74 dc                	je     800f4d <strsplit+0x8c>
			string++;
	}
  800f71:	e9 6e ff ff ff       	jmp    800ee4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800f76:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800f77:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7a:	8b 00                	mov    (%eax),%eax
  800f7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f83:	8b 45 10             	mov    0x10(%ebp),%eax
  800f86:	01 d0                	add    %edx,%eax
  800f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800f8e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
  800f9b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800fa7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800faa:	8b 7d 18             	mov    0x18(%ebp),%edi
  800fad:	8b 75 1c             	mov    0x1c(%ebp),%esi
  800fb0:	cd 30                	int    $0x30
  800fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  800fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fb8:	83 c4 10             	add    $0x10,%esp
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	6a 00                	push   $0x0
  800fc8:	6a 00                	push   $0x0
  800fca:	6a 00                	push   $0x0
  800fcc:	ff 75 0c             	pushl  0xc(%ebp)
  800fcf:	50                   	push   %eax
  800fd0:	6a 00                	push   $0x0
  800fd2:	e8 be ff ff ff       	call   800f95 <syscall>
  800fd7:	83 c4 18             	add    $0x18,%esp
}
  800fda:	90                   	nop
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <sys_cgetc>:

int
sys_cgetc(void)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  800fe0:	6a 00                	push   $0x0
  800fe2:	6a 00                	push   $0x0
  800fe4:	6a 00                	push   $0x0
  800fe6:	6a 00                	push   $0x0
  800fe8:	6a 00                	push   $0x0
  800fea:	6a 01                	push   $0x1
  800fec:	e8 a4 ff ff ff       	call   800f95 <syscall>
  800ff1:	83 c4 18             	add    $0x18,%esp
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	6a 00                	push   $0x0
  800ffe:	6a 00                	push   $0x0
  801000:	6a 00                	push   $0x0
  801002:	6a 00                	push   $0x0
  801004:	50                   	push   %eax
  801005:	6a 03                	push   $0x3
  801007:	e8 89 ff ff ff       	call   800f95 <syscall>
  80100c:	83 c4 18             	add    $0x18,%esp
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801014:	6a 00                	push   $0x0
  801016:	6a 00                	push   $0x0
  801018:	6a 00                	push   $0x0
  80101a:	6a 00                	push   $0x0
  80101c:	6a 00                	push   $0x0
  80101e:	6a 02                	push   $0x2
  801020:	e8 70 ff ff ff       	call   800f95 <syscall>
  801025:	83 c4 18             	add    $0x18,%esp
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <sys_env_exit>:

void sys_env_exit(void)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80102d:	6a 00                	push   $0x0
  80102f:	6a 00                	push   $0x0
  801031:	6a 00                	push   $0x0
  801033:	6a 00                	push   $0x0
  801035:	6a 00                	push   $0x0
  801037:	6a 04                	push   $0x4
  801039:	e8 57 ff ff ff       	call   800f95 <syscall>
  80103e:	83 c4 18             	add    $0x18,%esp
}
  801041:	90                   	nop
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801047:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	6a 00                	push   $0x0
  80104f:	6a 00                	push   $0x0
  801051:	6a 00                	push   $0x0
  801053:	52                   	push   %edx
  801054:	50                   	push   %eax
  801055:	6a 05                	push   $0x5
  801057:	e8 39 ff ff ff       	call   800f95 <syscall>
  80105c:	83 c4 18             	add    $0x18,%esp
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801066:	8b 75 18             	mov    0x18(%ebp),%esi
  801069:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80106c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80106f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	56                   	push   %esi
  801076:	53                   	push   %ebx
  801077:	51                   	push   %ecx
  801078:	52                   	push   %edx
  801079:	50                   	push   %eax
  80107a:	6a 06                	push   $0x6
  80107c:	e8 14 ff ff ff       	call   800f95 <syscall>
  801081:	83 c4 18             	add    $0x18,%esp
}
  801084:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801087:	5b                   	pop    %ebx
  801088:	5e                   	pop    %esi
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80108e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	6a 00                	push   $0x0
  801096:	6a 00                	push   $0x0
  801098:	6a 00                	push   $0x0
  80109a:	52                   	push   %edx
  80109b:	50                   	push   %eax
  80109c:	6a 07                	push   $0x7
  80109e:	e8 f2 fe ff ff       	call   800f95 <syscall>
  8010a3:	83 c4 18             	add    $0x18,%esp
}
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8010ab:	6a 00                	push   $0x0
  8010ad:	6a 00                	push   $0x0
  8010af:	6a 00                	push   $0x0
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	6a 08                	push   $0x8
  8010b9:	e8 d7 fe ff ff       	call   800f95 <syscall>
  8010be:	83 c4 18             	add    $0x18,%esp
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8010c6:	6a 00                	push   $0x0
  8010c8:	6a 00                	push   $0x0
  8010ca:	6a 00                	push   $0x0
  8010cc:	6a 00                	push   $0x0
  8010ce:	6a 00                	push   $0x0
  8010d0:	6a 09                	push   $0x9
  8010d2:	e8 be fe ff ff       	call   800f95 <syscall>
  8010d7:	83 c4 18             	add    $0x18,%esp
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8010df:	6a 00                	push   $0x0
  8010e1:	6a 00                	push   $0x0
  8010e3:	6a 00                	push   $0x0
  8010e5:	6a 00                	push   $0x0
  8010e7:	6a 00                	push   $0x0
  8010e9:	6a 0a                	push   $0xa
  8010eb:	e8 a5 fe ff ff       	call   800f95 <syscall>
  8010f0:	83 c4 18             	add    $0x18,%esp
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 00                	push   $0x0
  8010fc:	6a 00                	push   $0x0
  8010fe:	6a 00                	push   $0x0
  801100:	6a 00                	push   $0x0
  801102:	6a 0b                	push   $0xb
  801104:	e8 8c fe ff ff       	call   800f95 <syscall>
  801109:	83 c4 18             	add    $0x18,%esp
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801111:	6a 00                	push   $0x0
  801113:	6a 00                	push   $0x0
  801115:	6a 00                	push   $0x0
  801117:	ff 75 0c             	pushl  0xc(%ebp)
  80111a:	ff 75 08             	pushl  0x8(%ebp)
  80111d:	6a 0d                	push   $0xd
  80111f:	e8 71 fe ff ff       	call   800f95 <syscall>
  801124:	83 c4 18             	add    $0x18,%esp
	return;
  801127:	90                   	nop
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80112d:	6a 00                	push   $0x0
  80112f:	6a 00                	push   $0x0
  801131:	6a 00                	push   $0x0
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	ff 75 08             	pushl  0x8(%ebp)
  801139:	6a 0e                	push   $0xe
  80113b:	e8 55 fe ff ff       	call   800f95 <syscall>
  801140:	83 c4 18             	add    $0x18,%esp
	return ;
  801143:	90                   	nop
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801149:	6a 00                	push   $0x0
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	6a 0c                	push   $0xc
  801155:	e8 3b fe ff ff       	call   800f95 <syscall>
  80115a:	83 c4 18             	add    $0x18,%esp
}
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    

0080115f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801162:	6a 00                	push   $0x0
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 10                	push   $0x10
  80116e:	e8 22 fe ff ff       	call   800f95 <syscall>
  801173:	83 c4 18             	add    $0x18,%esp
}
  801176:	90                   	nop
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80117c:	6a 00                	push   $0x0
  80117e:	6a 00                	push   $0x0
  801180:	6a 00                	push   $0x0
  801182:	6a 00                	push   $0x0
  801184:	6a 00                	push   $0x0
  801186:	6a 11                	push   $0x11
  801188:	e8 08 fe ff ff       	call   800f95 <syscall>
  80118d:	83 c4 18             	add    $0x18,%esp
}
  801190:	90                   	nop
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <sys_cputc>:


void
sys_cputc(const char c)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	83 ec 04             	sub    $0x4,%esp
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80119f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011a3:	6a 00                	push   $0x0
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	50                   	push   %eax
  8011ac:	6a 12                	push   $0x12
  8011ae:	e8 e2 fd ff ff       	call   800f95 <syscall>
  8011b3:	83 c4 18             	add    $0x18,%esp
}
  8011b6:	90                   	nop
  8011b7:	c9                   	leave  
  8011b8:	c3                   	ret    

008011b9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 00                	push   $0x0
  8011c6:	6a 13                	push   $0x13
  8011c8:	e8 c8 fd ff ff       	call   800f95 <syscall>
  8011cd:	83 c4 18             	add    $0x18,%esp
}
  8011d0:	90                   	nop
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	ff 75 0c             	pushl  0xc(%ebp)
  8011e2:	50                   	push   %eax
  8011e3:	6a 14                	push   $0x14
  8011e5:	e8 ab fd ff ff       	call   800f95 <syscall>
  8011ea:	83 c4 18             	add    $0x18,%esp
}
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	50                   	push   %eax
  8011fe:	6a 17                	push   $0x17
  801200:	e8 90 fd ff ff       	call   800f95 <syscall>
  801205:	83 c4 18             	add    $0x18,%esp
}
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	6a 00                	push   $0x0
  801212:	6a 00                	push   $0x0
  801214:	6a 00                	push   $0x0
  801216:	6a 00                	push   $0x0
  801218:	50                   	push   %eax
  801219:	6a 15                	push   $0x15
  80121b:	e8 75 fd ff ff       	call   800f95 <syscall>
  801220:	83 c4 18             	add    $0x18,%esp
}
  801223:	90                   	nop
  801224:	c9                   	leave  
  801225:	c3                   	ret    

00801226 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	6a 00                	push   $0x0
  80122e:	6a 00                	push   $0x0
  801230:	6a 00                	push   $0x0
  801232:	6a 00                	push   $0x0
  801234:	50                   	push   %eax
  801235:	6a 16                	push   $0x16
  801237:	e8 59 fd ff ff       	call   800f95 <syscall>
  80123c:	83 c4 18             	add    $0x18,%esp
}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 04             	sub    $0x4,%esp
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80124e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801251:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	6a 00                	push   $0x0
  80125a:	51                   	push   %ecx
  80125b:	52                   	push   %edx
  80125c:	ff 75 0c             	pushl  0xc(%ebp)
  80125f:	50                   	push   %eax
  801260:	6a 18                	push   $0x18
  801262:	e8 2e fd ff ff       	call   800f95 <syscall>
  801267:	83 c4 18             	add    $0x18,%esp
}
  80126a:	c9                   	leave  
  80126b:	c3                   	ret    

0080126c <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  80126f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	52                   	push   %edx
  80127c:	50                   	push   %eax
  80127d:	6a 19                	push   $0x19
  80127f:	e8 11 fd ff ff       	call   800f95 <syscall>
  801284:	83 c4 18             	add    $0x18,%esp
}
  801287:	c9                   	leave  
  801288:	c3                   	ret    

00801289 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	50                   	push   %eax
  801298:	6a 1a                	push   $0x1a
  80129a:	e8 f6 fc ff ff       	call   800f95 <syscall>
  80129f:	83 c4 18             	add    $0x18,%esp
}
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 1b                	push   $0x1b
  8012b3:	e8 dd fc ff ff       	call   800f95 <syscall>
  8012b8:	83 c4 18             	add    $0x18,%esp
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 1c                	push   $0x1c
  8012cc:	e8 c4 fc ff ff       	call   800f95 <syscall>
  8012d1:	83 c4 18             	add    $0x18,%esp
}
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	50                   	push   %eax
  8012e6:	6a 1d                	push   $0x1d
  8012e8:	e8 a8 fc ff ff       	call   800f95 <syscall>
  8012ed:	83 c4 18             	add    $0x18,%esp
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	50                   	push   %eax
  801301:	6a 1e                	push   $0x1e
  801303:	e8 8d fc ff ff       	call   800f95 <syscall>
  801308:	83 c4 18             	add    $0x18,%esp
}
  80130b:	90                   	nop
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	50                   	push   %eax
  80131d:	6a 1f                	push   $0x1f
  80131f:	e8 71 fc ff ff       	call   800f95 <syscall>
  801324:	83 c4 18             	add    $0x18,%esp
}
  801327:	90                   	nop
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801330:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801333:	8d 50 04             	lea    0x4(%eax),%edx
  801336:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	52                   	push   %edx
  801340:	50                   	push   %eax
  801341:	6a 20                	push   $0x20
  801343:	e8 4d fc ff ff       	call   800f95 <syscall>
  801348:	83 c4 18             	add    $0x18,%esp
	return result;
  80134b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801354:	89 01                	mov    %eax,(%ecx)
  801356:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	c9                   	leave  
  80135d:	c2 04 00             	ret    $0x4

00801360 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	ff 75 10             	pushl  0x10(%ebp)
  80136a:	ff 75 0c             	pushl  0xc(%ebp)
  80136d:	ff 75 08             	pushl  0x8(%ebp)
  801370:	6a 0f                	push   $0xf
  801372:	e8 1e fc ff ff       	call   800f95 <syscall>
  801377:	83 c4 18             	add    $0x18,%esp
	return ;
  80137a:	90                   	nop
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <sys_rcr2>:
uint32 sys_rcr2()
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 21                	push   $0x21
  80138c:	e8 04 fc ff ff       	call   800f95 <syscall>
  801391:	83 c4 18             	add    $0x18,%esp
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013a2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	50                   	push   %eax
  8013af:	6a 22                	push   $0x22
  8013b1:	e8 df fb ff ff       	call   800f95 <syscall>
  8013b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8013b9:	90                   	nop
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <rsttst>:
void rsttst()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 24                	push   $0x24
  8013cb:	e8 c5 fb ff ff       	call   800f95 <syscall>
  8013d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d3:	90                   	nop
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013e2:	8b 55 18             	mov    0x18(%ebp),%edx
  8013e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013e9:	52                   	push   %edx
  8013ea:	50                   	push   %eax
  8013eb:	ff 75 10             	pushl  0x10(%ebp)
  8013ee:	ff 75 0c             	pushl  0xc(%ebp)
  8013f1:	ff 75 08             	pushl  0x8(%ebp)
  8013f4:	6a 23                	push   $0x23
  8013f6:	e8 9a fb ff ff       	call   800f95 <syscall>
  8013fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8013fe:	90                   	nop
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <chktst>:
void chktst(uint32 n)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	ff 75 08             	pushl  0x8(%ebp)
  80140f:	6a 25                	push   $0x25
  801411:	e8 7f fb ff ff       	call   800f95 <syscall>
  801416:	83 c4 18             	add    $0x18,%esp
	return ;
  801419:	90                   	nop
}
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 26                	push   $0x26
  80142e:	e8 62 fb ff ff       	call   800f95 <syscall>
  801433:	83 c4 18             	add    $0x18,%esp
  801436:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801439:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80143d:	75 07                	jne    801446 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80143f:	b8 01 00 00 00       	mov    $0x1,%eax
  801444:	eb 05                	jmp    80144b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801446:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 26                	push   $0x26
  80145f:	e8 31 fb ff ff       	call   800f95 <syscall>
  801464:	83 c4 18             	add    $0x18,%esp
  801467:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80146a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80146e:	75 07                	jne    801477 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801470:	b8 01 00 00 00       	mov    $0x1,%eax
  801475:	eb 05                	jmp    80147c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 26                	push   $0x26
  801490:	e8 00 fb ff ff       	call   800f95 <syscall>
  801495:	83 c4 18             	add    $0x18,%esp
  801498:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80149b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80149f:	75 07                	jne    8014a8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8014a6:	eb 05                	jmp    8014ad <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 26                	push   $0x26
  8014c1:	e8 cf fa ff ff       	call   800f95 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
  8014c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8014cc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8014d0:	75 07                	jne    8014d9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8014d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8014d7:	eb 05                	jmp    8014de <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	ff 75 08             	pushl  0x8(%ebp)
  8014ee:	6a 27                	push   $0x27
  8014f0:	e8 a0 fa ff ff       	call   800f95 <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f8:	90                   	nop
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    
  8014fb:	90                   	nop

008014fc <__udivdi3>:
  8014fc:	55                   	push   %ebp
  8014fd:	57                   	push   %edi
  8014fe:	56                   	push   %esi
  8014ff:	53                   	push   %ebx
  801500:	83 ec 1c             	sub    $0x1c,%esp
  801503:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801507:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80150b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80150f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801513:	89 ca                	mov    %ecx,%edx
  801515:	89 f8                	mov    %edi,%eax
  801517:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80151b:	85 f6                	test   %esi,%esi
  80151d:	75 2d                	jne    80154c <__udivdi3+0x50>
  80151f:	39 cf                	cmp    %ecx,%edi
  801521:	77 65                	ja     801588 <__udivdi3+0x8c>
  801523:	89 fd                	mov    %edi,%ebp
  801525:	85 ff                	test   %edi,%edi
  801527:	75 0b                	jne    801534 <__udivdi3+0x38>
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
  80152e:	31 d2                	xor    %edx,%edx
  801530:	f7 f7                	div    %edi
  801532:	89 c5                	mov    %eax,%ebp
  801534:	31 d2                	xor    %edx,%edx
  801536:	89 c8                	mov    %ecx,%eax
  801538:	f7 f5                	div    %ebp
  80153a:	89 c1                	mov    %eax,%ecx
  80153c:	89 d8                	mov    %ebx,%eax
  80153e:	f7 f5                	div    %ebp
  801540:	89 cf                	mov    %ecx,%edi
  801542:	89 fa                	mov    %edi,%edx
  801544:	83 c4 1c             	add    $0x1c,%esp
  801547:	5b                   	pop    %ebx
  801548:	5e                   	pop    %esi
  801549:	5f                   	pop    %edi
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    
  80154c:	39 ce                	cmp    %ecx,%esi
  80154e:	77 28                	ja     801578 <__udivdi3+0x7c>
  801550:	0f bd fe             	bsr    %esi,%edi
  801553:	83 f7 1f             	xor    $0x1f,%edi
  801556:	75 40                	jne    801598 <__udivdi3+0x9c>
  801558:	39 ce                	cmp    %ecx,%esi
  80155a:	72 0a                	jb     801566 <__udivdi3+0x6a>
  80155c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801560:	0f 87 9e 00 00 00    	ja     801604 <__udivdi3+0x108>
  801566:	b8 01 00 00 00       	mov    $0x1,%eax
  80156b:	89 fa                	mov    %edi,%edx
  80156d:	83 c4 1c             	add    $0x1c,%esp
  801570:	5b                   	pop    %ebx
  801571:	5e                   	pop    %esi
  801572:	5f                   	pop    %edi
  801573:	5d                   	pop    %ebp
  801574:	c3                   	ret    
  801575:	8d 76 00             	lea    0x0(%esi),%esi
  801578:	31 ff                	xor    %edi,%edi
  80157a:	31 c0                	xor    %eax,%eax
  80157c:	89 fa                	mov    %edi,%edx
  80157e:	83 c4 1c             	add    $0x1c,%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    
  801586:	66 90                	xchg   %ax,%ax
  801588:	89 d8                	mov    %ebx,%eax
  80158a:	f7 f7                	div    %edi
  80158c:	31 ff                	xor    %edi,%edi
  80158e:	89 fa                	mov    %edi,%edx
  801590:	83 c4 1c             	add    $0x1c,%esp
  801593:	5b                   	pop    %ebx
  801594:	5e                   	pop    %esi
  801595:	5f                   	pop    %edi
  801596:	5d                   	pop    %ebp
  801597:	c3                   	ret    
  801598:	bd 20 00 00 00       	mov    $0x20,%ebp
  80159d:	89 eb                	mov    %ebp,%ebx
  80159f:	29 fb                	sub    %edi,%ebx
  8015a1:	89 f9                	mov    %edi,%ecx
  8015a3:	d3 e6                	shl    %cl,%esi
  8015a5:	89 c5                	mov    %eax,%ebp
  8015a7:	88 d9                	mov    %bl,%cl
  8015a9:	d3 ed                	shr    %cl,%ebp
  8015ab:	89 e9                	mov    %ebp,%ecx
  8015ad:	09 f1                	or     %esi,%ecx
  8015af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8015b3:	89 f9                	mov    %edi,%ecx
  8015b5:	d3 e0                	shl    %cl,%eax
  8015b7:	89 c5                	mov    %eax,%ebp
  8015b9:	89 d6                	mov    %edx,%esi
  8015bb:	88 d9                	mov    %bl,%cl
  8015bd:	d3 ee                	shr    %cl,%esi
  8015bf:	89 f9                	mov    %edi,%ecx
  8015c1:	d3 e2                	shl    %cl,%edx
  8015c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8015c7:	88 d9                	mov    %bl,%cl
  8015c9:	d3 e8                	shr    %cl,%eax
  8015cb:	09 c2                	or     %eax,%edx
  8015cd:	89 d0                	mov    %edx,%eax
  8015cf:	89 f2                	mov    %esi,%edx
  8015d1:	f7 74 24 0c          	divl   0xc(%esp)
  8015d5:	89 d6                	mov    %edx,%esi
  8015d7:	89 c3                	mov    %eax,%ebx
  8015d9:	f7 e5                	mul    %ebp
  8015db:	39 d6                	cmp    %edx,%esi
  8015dd:	72 19                	jb     8015f8 <__udivdi3+0xfc>
  8015df:	74 0b                	je     8015ec <__udivdi3+0xf0>
  8015e1:	89 d8                	mov    %ebx,%eax
  8015e3:	31 ff                	xor    %edi,%edi
  8015e5:	e9 58 ff ff ff       	jmp    801542 <__udivdi3+0x46>
  8015ea:	66 90                	xchg   %ax,%ax
  8015ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8015f0:	89 f9                	mov    %edi,%ecx
  8015f2:	d3 e2                	shl    %cl,%edx
  8015f4:	39 c2                	cmp    %eax,%edx
  8015f6:	73 e9                	jae    8015e1 <__udivdi3+0xe5>
  8015f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8015fb:	31 ff                	xor    %edi,%edi
  8015fd:	e9 40 ff ff ff       	jmp    801542 <__udivdi3+0x46>
  801602:	66 90                	xchg   %ax,%ax
  801604:	31 c0                	xor    %eax,%eax
  801606:	e9 37 ff ff ff       	jmp    801542 <__udivdi3+0x46>
  80160b:	90                   	nop

0080160c <__umoddi3>:
  80160c:	55                   	push   %ebp
  80160d:	57                   	push   %edi
  80160e:	56                   	push   %esi
  80160f:	53                   	push   %ebx
  801610:	83 ec 1c             	sub    $0x1c,%esp
  801613:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801617:	8b 74 24 34          	mov    0x34(%esp),%esi
  80161b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80161f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801623:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801627:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80162b:	89 f3                	mov    %esi,%ebx
  80162d:	89 fa                	mov    %edi,%edx
  80162f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801633:	89 34 24             	mov    %esi,(%esp)
  801636:	85 c0                	test   %eax,%eax
  801638:	75 1a                	jne    801654 <__umoddi3+0x48>
  80163a:	39 f7                	cmp    %esi,%edi
  80163c:	0f 86 a2 00 00 00    	jbe    8016e4 <__umoddi3+0xd8>
  801642:	89 c8                	mov    %ecx,%eax
  801644:	89 f2                	mov    %esi,%edx
  801646:	f7 f7                	div    %edi
  801648:	89 d0                	mov    %edx,%eax
  80164a:	31 d2                	xor    %edx,%edx
  80164c:	83 c4 1c             	add    $0x1c,%esp
  80164f:	5b                   	pop    %ebx
  801650:	5e                   	pop    %esi
  801651:	5f                   	pop    %edi
  801652:	5d                   	pop    %ebp
  801653:	c3                   	ret    
  801654:	39 f0                	cmp    %esi,%eax
  801656:	0f 87 ac 00 00 00    	ja     801708 <__umoddi3+0xfc>
  80165c:	0f bd e8             	bsr    %eax,%ebp
  80165f:	83 f5 1f             	xor    $0x1f,%ebp
  801662:	0f 84 ac 00 00 00    	je     801714 <__umoddi3+0x108>
  801668:	bf 20 00 00 00       	mov    $0x20,%edi
  80166d:	29 ef                	sub    %ebp,%edi
  80166f:	89 fe                	mov    %edi,%esi
  801671:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801675:	89 e9                	mov    %ebp,%ecx
  801677:	d3 e0                	shl    %cl,%eax
  801679:	89 d7                	mov    %edx,%edi
  80167b:	89 f1                	mov    %esi,%ecx
  80167d:	d3 ef                	shr    %cl,%edi
  80167f:	09 c7                	or     %eax,%edi
  801681:	89 e9                	mov    %ebp,%ecx
  801683:	d3 e2                	shl    %cl,%edx
  801685:	89 14 24             	mov    %edx,(%esp)
  801688:	89 d8                	mov    %ebx,%eax
  80168a:	d3 e0                	shl    %cl,%eax
  80168c:	89 c2                	mov    %eax,%edx
  80168e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801692:	d3 e0                	shl    %cl,%eax
  801694:	89 44 24 04          	mov    %eax,0x4(%esp)
  801698:	8b 44 24 08          	mov    0x8(%esp),%eax
  80169c:	89 f1                	mov    %esi,%ecx
  80169e:	d3 e8                	shr    %cl,%eax
  8016a0:	09 d0                	or     %edx,%eax
  8016a2:	d3 eb                	shr    %cl,%ebx
  8016a4:	89 da                	mov    %ebx,%edx
  8016a6:	f7 f7                	div    %edi
  8016a8:	89 d3                	mov    %edx,%ebx
  8016aa:	f7 24 24             	mull   (%esp)
  8016ad:	89 c6                	mov    %eax,%esi
  8016af:	89 d1                	mov    %edx,%ecx
  8016b1:	39 d3                	cmp    %edx,%ebx
  8016b3:	0f 82 87 00 00 00    	jb     801740 <__umoddi3+0x134>
  8016b9:	0f 84 91 00 00 00    	je     801750 <__umoddi3+0x144>
  8016bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8016c3:	29 f2                	sub    %esi,%edx
  8016c5:	19 cb                	sbb    %ecx,%ebx
  8016c7:	89 d8                	mov    %ebx,%eax
  8016c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8016cd:	d3 e0                	shl    %cl,%eax
  8016cf:	89 e9                	mov    %ebp,%ecx
  8016d1:	d3 ea                	shr    %cl,%edx
  8016d3:	09 d0                	or     %edx,%eax
  8016d5:	89 e9                	mov    %ebp,%ecx
  8016d7:	d3 eb                	shr    %cl,%ebx
  8016d9:	89 da                	mov    %ebx,%edx
  8016db:	83 c4 1c             	add    $0x1c,%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5f                   	pop    %edi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    
  8016e3:	90                   	nop
  8016e4:	89 fd                	mov    %edi,%ebp
  8016e6:	85 ff                	test   %edi,%edi
  8016e8:	75 0b                	jne    8016f5 <__umoddi3+0xe9>
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ef:	31 d2                	xor    %edx,%edx
  8016f1:	f7 f7                	div    %edi
  8016f3:	89 c5                	mov    %eax,%ebp
  8016f5:	89 f0                	mov    %esi,%eax
  8016f7:	31 d2                	xor    %edx,%edx
  8016f9:	f7 f5                	div    %ebp
  8016fb:	89 c8                	mov    %ecx,%eax
  8016fd:	f7 f5                	div    %ebp
  8016ff:	89 d0                	mov    %edx,%eax
  801701:	e9 44 ff ff ff       	jmp    80164a <__umoddi3+0x3e>
  801706:	66 90                	xchg   %ax,%ax
  801708:	89 c8                	mov    %ecx,%eax
  80170a:	89 f2                	mov    %esi,%edx
  80170c:	83 c4 1c             	add    $0x1c,%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5f                   	pop    %edi
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    
  801714:	3b 04 24             	cmp    (%esp),%eax
  801717:	72 06                	jb     80171f <__umoddi3+0x113>
  801719:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80171d:	77 0f                	ja     80172e <__umoddi3+0x122>
  80171f:	89 f2                	mov    %esi,%edx
  801721:	29 f9                	sub    %edi,%ecx
  801723:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801727:	89 14 24             	mov    %edx,(%esp)
  80172a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80172e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801732:	8b 14 24             	mov    (%esp),%edx
  801735:	83 c4 1c             	add    $0x1c,%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5f                   	pop    %edi
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    
  80173d:	8d 76 00             	lea    0x0(%esi),%esi
  801740:	2b 04 24             	sub    (%esp),%eax
  801743:	19 fa                	sbb    %edi,%edx
  801745:	89 d1                	mov    %edx,%ecx
  801747:	89 c6                	mov    %eax,%esi
  801749:	e9 71 ff ff ff       	jmp    8016bf <__umoddi3+0xb3>
  80174e:	66 90                	xchg   %ax,%ax
  801750:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801754:	72 ea                	jb     801740 <__umoddi3+0x134>
  801756:	89 d9                	mov    %ebx,%ecx
  801758:	e9 62 ff ff ff       	jmp    8016bf <__umoddi3+0xb3>
