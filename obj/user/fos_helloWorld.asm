
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);		
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 40 17 80 00       	push   $0x801740
  800046:	e8 be 01 00 00       	call   800209 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 2d 17 80 00       	mov    0x80172d,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 68 17 80 00       	push   $0x801768
  80005c:	e8 a8 01 00 00       	call   800209 <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800071:	7e 0a                	jle    80007d <libmain+0x16>
		binaryname = argv[0];
  800073:	8b 45 0c             	mov    0xc(%ebp),%eax
  800076:	8b 00                	mov    (%eax),%eax
  800078:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  80007d:	83 ec 08             	sub    $0x8,%esp
  800080:	ff 75 0c             	pushl  0xc(%ebp)
  800083:	ff 75 08             	pushl  0x8(%ebp)
  800086:	e8 ad ff ff ff       	call   800038 <_main>
  80008b:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80008e:	e8 4f 0f 00 00       	call   800fe2 <sys_getenvid>
  800093:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800099:	89 d0                	mov    %edx,%eax
  80009b:	c1 e0 03             	shl    $0x3,%eax
  80009e:	01 d0                	add    %edx,%eax
  8000a0:	01 c0                	add    %eax,%eax
  8000a2:	01 d0                	add    %edx,%eax
  8000a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	c1 e0 03             	shl    $0x3,%eax
  8000b0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8000b8:	e8 73 10 00 00       	call   801130 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 94 17 80 00       	push   $0x801794
  8000c5:	e8 19 01 00 00       	call   8001e3 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8000cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d0:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	50                   	push   %eax
  8000da:	68 bc 17 80 00       	push   $0x8017bc
  8000df:	e8 ff 00 00 00       	call   8001e3 <cprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 94 17 80 00       	push   $0x801794
  8000ef:	e8 ef 00 00 00       	call   8001e3 <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8000f7:	e8 4e 10 00 00       	call   80114a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8000fc:	e8 19 00 00 00       	call   80011a <exit>
}
  800101:	90                   	nop
  800102:	c9                   	leave  
  800103:	c3                   	ret    

00800104 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 00                	push   $0x0
  80010f:	e8 b3 0e 00 00       	call   800fc7 <sys_env_destroy>
  800114:	83 c4 10             	add    $0x10,%esp
}
  800117:	90                   	nop
  800118:	c9                   	leave  
  800119:	c3                   	ret    

0080011a <exit>:

void
exit(void)
{
  80011a:	55                   	push   %ebp
  80011b:	89 e5                	mov    %esp,%ebp
  80011d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800120:	e8 d6 0e 00 00       	call   800ffb <sys_env_exit>
}
  800125:	90                   	nop
  800126:	c9                   	leave  
  800127:	c3                   	ret    

00800128 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80012e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800131:	8b 00                	mov    (%eax),%eax
  800133:	8d 48 01             	lea    0x1(%eax),%ecx
  800136:	8b 55 0c             	mov    0xc(%ebp),%edx
  800139:	89 0a                	mov    %ecx,(%edx)
  80013b:	8b 55 08             	mov    0x8(%ebp),%edx
  80013e:	88 d1                	mov    %dl,%cl
  800140:	8b 55 0c             	mov    0xc(%ebp),%edx
  800143:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014a:	8b 00                	mov    (%eax),%eax
  80014c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800151:	75 23                	jne    800176 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800153:	8b 45 0c             	mov    0xc(%ebp),%eax
  800156:	8b 00                	mov    (%eax),%eax
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015d:	83 c0 08             	add    $0x8,%eax
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	52                   	push   %edx
  800164:	50                   	push   %eax
  800165:	e8 27 0e 00 00       	call   800f91 <sys_cputs>
  80016a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80016d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800176:	8b 45 0c             	mov    0xc(%ebp),%eax
  800179:	8b 40 04             	mov    0x4(%eax),%eax
  80017c:	8d 50 01             	lea    0x1(%eax),%edx
  80017f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800182:	89 50 04             	mov    %edx,0x4(%eax)
}
  800185:	90                   	nop
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800191:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800198:	00 00 00 
	b.cnt = 0;
  80019b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8001a5:	ff 75 0c             	pushl  0xc(%ebp)
  8001a8:	ff 75 08             	pushl  0x8(%ebp)
  8001ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b1:	50                   	push   %eax
  8001b2:	68 28 01 80 00       	push   $0x800128
  8001b7:	e8 fa 01 00 00       	call   8003b6 <vprintfmt>
  8001bc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8001bf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	50                   	push   %eax
  8001c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cf:	83 c0 08             	add    $0x8,%eax
  8001d2:	50                   	push   %eax
  8001d3:	e8 b9 0d 00 00       	call   800f91 <sys_cputs>
  8001d8:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8001db:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8001e1:	c9                   	leave  
  8001e2:	c3                   	ret    

008001e3 <cprintf>:

int cprintf(const char *fmt, ...) {
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8001ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8001ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	e8 8a ff ff ff       	call   800188 <vcprintf>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800204:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80020f:	e8 1c 0f 00 00       	call   801130 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800214:	8d 45 0c             	lea    0xc(%ebp),%eax
  800217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80021a:	8b 45 08             	mov    0x8(%ebp),%eax
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	50                   	push   %eax
  800224:	e8 5f ff ff ff       	call   800188 <vcprintf>
  800229:	83 c4 10             	add    $0x10,%esp
  80022c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80022f:	e8 16 0f 00 00       	call   80114a <sys_enable_interrupt>
	return cnt;
  800234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800237:	c9                   	leave  
  800238:	c3                   	ret    

00800239 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	53                   	push   %ebx
  80023d:	83 ec 14             	sub    $0x14,%esp
  800240:	8b 45 10             	mov    0x10(%ebp),%eax
  800243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800246:	8b 45 14             	mov    0x14(%ebp),%eax
  800249:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80024c:	8b 45 18             	mov    0x18(%ebp),%eax
  80024f:	ba 00 00 00 00       	mov    $0x0,%edx
  800254:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800257:	77 55                	ja     8002ae <printnum+0x75>
  800259:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80025c:	72 05                	jb     800263 <printnum+0x2a>
  80025e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800261:	77 4b                	ja     8002ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800263:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800266:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800269:	8b 45 18             	mov    0x18(%ebp),%eax
  80026c:	ba 00 00 00 00       	mov    $0x0,%edx
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	ff 75 f4             	pushl  -0xc(%ebp)
  800276:	ff 75 f0             	pushl  -0x10(%ebp)
  800279:	e8 4e 12 00 00       	call   8014cc <__udivdi3>
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	ff 75 20             	pushl  0x20(%ebp)
  800287:	53                   	push   %ebx
  800288:	ff 75 18             	pushl  0x18(%ebp)
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	ff 75 0c             	pushl  0xc(%ebp)
  800290:	ff 75 08             	pushl  0x8(%ebp)
  800293:	e8 a1 ff ff ff       	call   800239 <printnum>
  800298:	83 c4 20             	add    $0x20,%esp
  80029b:	eb 1a                	jmp    8002b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	ff 75 0c             	pushl  0xc(%ebp)
  8002a3:	ff 75 20             	pushl  0x20(%ebp)
  8002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a9:	ff d0                	call   *%eax
  8002ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8002b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8002b5:	7f e6                	jg     80029d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c5:	53                   	push   %ebx
  8002c6:	51                   	push   %ecx
  8002c7:	52                   	push   %edx
  8002c8:	50                   	push   %eax
  8002c9:	e8 0e 13 00 00       	call   8015dc <__umoddi3>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	05 f4 19 80 00       	add    $0x8019f4,%eax
  8002d6:	8a 00                	mov    (%eax),%al
  8002d8:	0f be c0             	movsbl %al,%eax
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 0c             	pushl  0xc(%ebp)
  8002e1:	50                   	push   %eax
  8002e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e5:	ff d0                	call   *%eax
  8002e7:	83 c4 10             	add    $0x10,%esp
}
  8002ea:	90                   	nop
  8002eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8002f7:	7e 1c                	jle    800315 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	8d 50 08             	lea    0x8(%eax),%edx
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	89 10                	mov    %edx,(%eax)
  800306:	8b 45 08             	mov    0x8(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 e8 08             	sub    $0x8,%eax
  80030e:	8b 50 04             	mov    0x4(%eax),%edx
  800311:	8b 00                	mov    (%eax),%eax
  800313:	eb 40                	jmp    800355 <getuint+0x65>
	else if (lflag)
  800315:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800319:	74 1e                	je     800339 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80031b:	8b 45 08             	mov    0x8(%ebp),%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	8d 50 04             	lea    0x4(%eax),%edx
  800323:	8b 45 08             	mov    0x8(%ebp),%eax
  800326:	89 10                	mov    %edx,(%eax)
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	8b 00                	mov    (%eax),%eax
  80032d:	83 e8 04             	sub    $0x4,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
  800337:	eb 1c                	jmp    800355 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	8d 50 04             	lea    0x4(%eax),%edx
  800341:	8b 45 08             	mov    0x8(%ebp),%eax
  800344:	89 10                	mov    %edx,(%eax)
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	8b 00                	mov    (%eax),%eax
  80034b:	83 e8 04             	sub    $0x4,%eax
  80034e:	8b 00                	mov    (%eax),%eax
  800350:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800355:	5d                   	pop    %ebp
  800356:	c3                   	ret    

00800357 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80035a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80035e:	7e 1c                	jle    80037c <getint+0x25>
		return va_arg(*ap, long long);
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	8b 00                	mov    (%eax),%eax
  800365:	8d 50 08             	lea    0x8(%eax),%edx
  800368:	8b 45 08             	mov    0x8(%ebp),%eax
  80036b:	89 10                	mov    %edx,(%eax)
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	83 e8 08             	sub    $0x8,%eax
  800375:	8b 50 04             	mov    0x4(%eax),%edx
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	eb 38                	jmp    8003b4 <getint+0x5d>
	else if (lflag)
  80037c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800380:	74 1a                	je     80039c <getint+0x45>
		return va_arg(*ap, long);
  800382:	8b 45 08             	mov    0x8(%ebp),%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	8d 50 04             	lea    0x4(%eax),%edx
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	89 10                	mov    %edx,(%eax)
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	83 e8 04             	sub    $0x4,%eax
  800397:	8b 00                	mov    (%eax),%eax
  800399:	99                   	cltd   
  80039a:	eb 18                	jmp    8003b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	8d 50 04             	lea    0x4(%eax),%edx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	89 10                	mov    %edx,(%eax)
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	83 e8 04             	sub    $0x4,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	99                   	cltd   
}
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	56                   	push   %esi
  8003ba:	53                   	push   %ebx
  8003bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003be:	eb 17                	jmp    8003d7 <vprintfmt+0x21>
			if (ch == '\0')
  8003c0:	85 db                	test   %ebx,%ebx
  8003c2:	0f 84 af 03 00 00    	je     800777 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	53                   	push   %ebx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	ff d0                	call   *%eax
  8003d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8003e0:	8a 00                	mov    (%eax),%al
  8003e2:	0f b6 d8             	movzbl %al,%ebx
  8003e5:	83 fb 25             	cmp    $0x25,%ebx
  8003e8:	75 d6                	jne    8003c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8003ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8003ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8003f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800403:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	8b 45 10             	mov    0x10(%ebp),%eax
  80040d:	8d 50 01             	lea    0x1(%eax),%edx
  800410:	89 55 10             	mov    %edx,0x10(%ebp)
  800413:	8a 00                	mov    (%eax),%al
  800415:	0f b6 d8             	movzbl %al,%ebx
  800418:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80041b:	83 f8 55             	cmp    $0x55,%eax
  80041e:	0f 87 2b 03 00 00    	ja     80074f <vprintfmt+0x399>
  800424:	8b 04 85 18 1a 80 00 	mov    0x801a18(,%eax,4),%eax
  80042b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80042d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800431:	eb d7                	jmp    80040a <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800433:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800437:	eb d1                	jmp    80040a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800440:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800443:	89 d0                	mov    %edx,%eax
  800445:	c1 e0 02             	shl    $0x2,%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	01 c0                	add    %eax,%eax
  80044c:	01 d8                	add    %ebx,%eax
  80044e:	83 e8 30             	sub    $0x30,%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8a 00                	mov    (%eax),%al
  800459:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80045c:	83 fb 2f             	cmp    $0x2f,%ebx
  80045f:	7e 3e                	jle    80049f <vprintfmt+0xe9>
  800461:	83 fb 39             	cmp    $0x39,%ebx
  800464:	7f 39                	jg     80049f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800466:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800469:	eb d5                	jmp    800440 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80046b:	8b 45 14             	mov    0x14(%ebp),%eax
  80046e:	83 c0 04             	add    $0x4,%eax
  800471:	89 45 14             	mov    %eax,0x14(%ebp)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	83 e8 04             	sub    $0x4,%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80047f:	eb 1f                	jmp    8004a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800481:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800485:	79 83                	jns    80040a <vprintfmt+0x54>
				width = 0;
  800487:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80048e:	e9 77 ff ff ff       	jmp    80040a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800493:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80049a:	e9 6b ff ff ff       	jmp    80040a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80049f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004a4:	0f 89 60 ff ff ff    	jns    80040a <vprintfmt+0x54>
				width = precision, precision = -1;
  8004aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8004b7:	e9 4e ff ff ff       	jmp    80040a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8004bf:	e9 46 ff ff ff       	jmp    80040a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	83 c0 04             	add    $0x4,%eax
  8004ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	83 e8 04             	sub    $0x4,%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	ff 75 0c             	pushl  0xc(%ebp)
  8004db:	50                   	push   %eax
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	ff d0                	call   *%eax
  8004e1:	83 c4 10             	add    $0x10,%esp
			break;
  8004e4:	e9 89 02 00 00       	jmp    800772 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ec:	83 c0 04             	add    $0x4,%eax
  8004ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f5:	83 e8 04             	sub    $0x4,%eax
  8004f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8004fa:	85 db                	test   %ebx,%ebx
  8004fc:	79 02                	jns    800500 <vprintfmt+0x14a>
				err = -err;
  8004fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800500:	83 fb 64             	cmp    $0x64,%ebx
  800503:	7f 0b                	jg     800510 <vprintfmt+0x15a>
  800505:	8b 34 9d 60 18 80 00 	mov    0x801860(,%ebx,4),%esi
  80050c:	85 f6                	test   %esi,%esi
  80050e:	75 19                	jne    800529 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800510:	53                   	push   %ebx
  800511:	68 05 1a 80 00       	push   $0x801a05
  800516:	ff 75 0c             	pushl  0xc(%ebp)
  800519:	ff 75 08             	pushl  0x8(%ebp)
  80051c:	e8 5e 02 00 00       	call   80077f <printfmt>
  800521:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800524:	e9 49 02 00 00       	jmp    800772 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800529:	56                   	push   %esi
  80052a:	68 0e 1a 80 00       	push   $0x801a0e
  80052f:	ff 75 0c             	pushl  0xc(%ebp)
  800532:	ff 75 08             	pushl  0x8(%ebp)
  800535:	e8 45 02 00 00       	call   80077f <printfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
			break;
  80053d:	e9 30 02 00 00       	jmp    800772 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	83 c0 04             	add    $0x4,%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	83 e8 04             	sub    $0x4,%eax
  800551:	8b 30                	mov    (%eax),%esi
  800553:	85 f6                	test   %esi,%esi
  800555:	75 05                	jne    80055c <vprintfmt+0x1a6>
				p = "(null)";
  800557:	be 11 1a 80 00       	mov    $0x801a11,%esi
			if (width > 0 && padc != '-')
  80055c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800560:	7e 6d                	jle    8005cf <vprintfmt+0x219>
  800562:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800566:	74 67                	je     8005cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	50                   	push   %eax
  80056f:	56                   	push   %esi
  800570:	e8 0c 03 00 00       	call   800881 <strnlen>
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80057b:	eb 16                	jmp    800593 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80057d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	ff 75 0c             	pushl  0xc(%ebp)
  800587:	50                   	push   %eax
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	ff d0                	call   *%eax
  80058d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800590:	ff 4d e4             	decl   -0x1c(%ebp)
  800593:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800597:	7f e4                	jg     80057d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800599:	eb 34                	jmp    8005cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80059b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80059f:	74 1c                	je     8005bd <vprintfmt+0x207>
  8005a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8005a4:	7e 05                	jle    8005ab <vprintfmt+0x1f5>
  8005a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8005a9:	7e 12                	jle    8005bd <vprintfmt+0x207>
					putch('?', putdat);
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 0c             	pushl  0xc(%ebp)
  8005b1:	6a 3f                	push   $0x3f
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	ff d0                	call   *%eax
  8005b8:	83 c4 10             	add    $0x10,%esp
  8005bb:	eb 0f                	jmp    8005cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	53                   	push   %ebx
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	ff d0                	call   *%eax
  8005c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8005cf:	89 f0                	mov    %esi,%eax
  8005d1:	8d 70 01             	lea    0x1(%eax),%esi
  8005d4:	8a 00                	mov    (%eax),%al
  8005d6:	0f be d8             	movsbl %al,%ebx
  8005d9:	85 db                	test   %ebx,%ebx
  8005db:	74 24                	je     800601 <vprintfmt+0x24b>
  8005dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e1:	78 b8                	js     80059b <vprintfmt+0x1e5>
  8005e3:	ff 4d e0             	decl   -0x20(%ebp)
  8005e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ea:	79 af                	jns    80059b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005ec:	eb 13                	jmp    800601 <vprintfmt+0x24b>
				putch(' ', putdat);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	ff 75 0c             	pushl  0xc(%ebp)
  8005f4:	6a 20                	push   $0x20
  8005f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f9:	ff d0                	call   *%eax
  8005fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005fe:	ff 4d e4             	decl   -0x1c(%ebp)
  800601:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800605:	7f e7                	jg     8005ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800607:	e9 66 01 00 00       	jmp    800772 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	ff 75 e8             	pushl  -0x18(%ebp)
  800612:	8d 45 14             	lea    0x14(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 3c fd ff ff       	call   800357 <getint>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800621:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800627:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062a:	85 d2                	test   %edx,%edx
  80062c:	79 23                	jns    800651 <vprintfmt+0x29b>
				putch('-', putdat);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 0c             	pushl  0xc(%ebp)
  800634:	6a 2d                	push   $0x2d
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	ff d0                	call   *%eax
  80063b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80063e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800644:	f7 d8                	neg    %eax
  800646:	83 d2 00             	adc    $0x0,%edx
  800649:	f7 da                	neg    %edx
  80064b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80064e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800651:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800658:	e9 bc 00 00 00       	jmp    800719 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 e8             	pushl  -0x18(%ebp)
  800663:	8d 45 14             	lea    0x14(%ebp),%eax
  800666:	50                   	push   %eax
  800667:	e8 84 fc ff ff       	call   8002f0 <getuint>
  80066c:	83 c4 10             	add    $0x10,%esp
  80066f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800672:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800675:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80067c:	e9 98 00 00 00       	jmp    800719 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	6a 58                	push   $0x58
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	ff d0                	call   *%eax
  80068e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	ff 75 0c             	pushl  0xc(%ebp)
  800697:	6a 58                	push   $0x58
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	ff d0                	call   *%eax
  80069e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	6a 58                	push   $0x58
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	ff d0                	call   *%eax
  8006ae:	83 c4 10             	add    $0x10,%esp
			break;
  8006b1:	e9 bc 00 00 00       	jmp    800772 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	6a 30                	push   $0x30
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	ff d0                	call   *%eax
  8006c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	6a 78                	push   $0x78
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	ff d0                	call   *%eax
  8006d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	83 c0 04             	add    $0x4,%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	83 e8 04             	sub    $0x4,%eax
  8006e5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8006f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8006f8:	eb 1f                	jmp    800719 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	ff 75 e8             	pushl  -0x18(%ebp)
  800700:	8d 45 14             	lea    0x14(%ebp),%eax
  800703:	50                   	push   %eax
  800704:	e8 e7 fb ff ff       	call   8002f0 <getuint>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800712:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800719:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80071d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800720:	83 ec 04             	sub    $0x4,%esp
  800723:	52                   	push   %edx
  800724:	ff 75 e4             	pushl  -0x1c(%ebp)
  800727:	50                   	push   %eax
  800728:	ff 75 f4             	pushl  -0xc(%ebp)
  80072b:	ff 75 f0             	pushl  -0x10(%ebp)
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	ff 75 08             	pushl  0x8(%ebp)
  800734:	e8 00 fb ff ff       	call   800239 <printnum>
  800739:	83 c4 20             	add    $0x20,%esp
			break;
  80073c:	eb 34                	jmp    800772 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	53                   	push   %ebx
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	ff d0                	call   *%eax
  80074a:	83 c4 10             	add    $0x10,%esp
			break;
  80074d:	eb 23                	jmp    800772 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	ff 75 0c             	pushl  0xc(%ebp)
  800755:	6a 25                	push   $0x25
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80075f:	ff 4d 10             	decl   0x10(%ebp)
  800762:	eb 03                	jmp    800767 <vprintfmt+0x3b1>
  800764:	ff 4d 10             	decl   0x10(%ebp)
  800767:	8b 45 10             	mov    0x10(%ebp),%eax
  80076a:	48                   	dec    %eax
  80076b:	8a 00                	mov    (%eax),%al
  80076d:	3c 25                	cmp    $0x25,%al
  80076f:	75 f3                	jne    800764 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800771:	90                   	nop
		}
	}
  800772:	e9 47 fc ff ff       	jmp    8003be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800777:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800778:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80077b:	5b                   	pop    %ebx
  80077c:	5e                   	pop    %esi
  80077d:	5d                   	pop    %ebp
  80077e:	c3                   	ret    

0080077f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800785:	8d 45 10             	lea    0x10(%ebp),%eax
  800788:	83 c0 04             	add    $0x4,%eax
  80078b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80078e:	8b 45 10             	mov    0x10(%ebp),%eax
  800791:	ff 75 f4             	pushl  -0xc(%ebp)
  800794:	50                   	push   %eax
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	ff 75 08             	pushl  0x8(%ebp)
  80079b:	e8 16 fc ff ff       	call   8003b6 <vprintfmt>
  8007a0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8007a3:	90                   	nop
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ac:	8b 40 08             	mov    0x8(%eax),%eax
  8007af:	8d 50 01             	lea    0x1(%eax),%edx
  8007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bb:	8b 10                	mov    (%eax),%edx
  8007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c0:	8b 40 04             	mov    0x4(%eax),%eax
  8007c3:	39 c2                	cmp    %eax,%edx
  8007c5:	73 12                	jae    8007d9 <sprintputch+0x33>
		*b->buf++ = ch;
  8007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8007cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d2:	89 0a                	mov    %ecx,(%edx)
  8007d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d7:	88 10                	mov    %dl,(%eax)
}
  8007d9:	90                   	nop
  8007da:	5d                   	pop    %ebp
  8007db:	c3                   	ret    

008007dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	01 d0                	add    %edx,%eax
  8007f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800801:	74 06                	je     800809 <vsnprintf+0x2d>
  800803:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800807:	7f 07                	jg     800810 <vsnprintf+0x34>
		return -E_INVAL;
  800809:	b8 03 00 00 00       	mov    $0x3,%eax
  80080e:	eb 20                	jmp    800830 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800810:	ff 75 14             	pushl  0x14(%ebp)
  800813:	ff 75 10             	pushl  0x10(%ebp)
  800816:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800819:	50                   	push   %eax
  80081a:	68 a6 07 80 00       	push   $0x8007a6
  80081f:	e8 92 fb ff ff       	call   8003b6 <vprintfmt>
  800824:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80082d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800830:	c9                   	leave  
  800831:	c3                   	ret    

00800832 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800838:	8d 45 10             	lea    0x10(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	ff 75 f4             	pushl  -0xc(%ebp)
  800847:	50                   	push   %eax
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	ff 75 08             	pushl  0x8(%ebp)
  80084e:	e8 89 ff ff ff       	call   8007dc <vsnprintf>
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800859:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80085c:	c9                   	leave  
  80085d:	c3                   	ret    

0080085e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800864:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80086b:	eb 06                	jmp    800873 <strlen+0x15>
		n++;
  80086d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800870:	ff 45 08             	incl   0x8(%ebp)
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8a 00                	mov    (%eax),%al
  800878:	84 c0                	test   %al,%al
  80087a:	75 f1                	jne    80086d <strlen+0xf>
		n++;
	return n;
  80087c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80087f:	c9                   	leave  
  800880:	c3                   	ret    

00800881 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800887:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80088e:	eb 09                	jmp    800899 <strnlen+0x18>
		n++;
  800890:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800893:	ff 45 08             	incl   0x8(%ebp)
  800896:	ff 4d 0c             	decl   0xc(%ebp)
  800899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80089d:	74 09                	je     8008a8 <strnlen+0x27>
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8a 00                	mov    (%eax),%al
  8008a4:	84 c0                	test   %al,%al
  8008a6:	75 e8                	jne    800890 <strnlen+0xf>
		n++;
	return n;
  8008a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    

008008ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8008b9:	90                   	nop
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8d 50 01             	lea    0x1(%eax),%edx
  8008c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8008cc:	8a 12                	mov    (%edx),%dl
  8008ce:	88 10                	mov    %dl,(%eax)
  8008d0:	8a 00                	mov    (%eax),%al
  8008d2:	84 c0                	test   %al,%al
  8008d4:	75 e4                	jne    8008ba <strcpy+0xd>
		/* do nothing */;
	return ret;
  8008d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008d9:	c9                   	leave  
  8008da:	c3                   	ret    

008008db <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8008e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008ee:	eb 1f                	jmp    80090f <strncpy+0x34>
		*dst++ = *src;
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8d 50 01             	lea    0x1(%eax),%edx
  8008f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	8a 12                	mov    (%edx),%dl
  8008fe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	8a 00                	mov    (%eax),%al
  800905:	84 c0                	test   %al,%al
  800907:	74 03                	je     80090c <strncpy+0x31>
			src++;
  800909:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80090c:	ff 45 fc             	incl   -0x4(%ebp)
  80090f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800912:	3b 45 10             	cmp    0x10(%ebp),%eax
  800915:	72 d9                	jb     8008f0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800917:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800928:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80092c:	74 30                	je     80095e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80092e:	eb 16                	jmp    800946 <strlcpy+0x2a>
			*dst++ = *src++;
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8d 50 01             	lea    0x1(%eax),%edx
  800936:	89 55 08             	mov    %edx,0x8(%ebp)
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80093f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800942:	8a 12                	mov    (%edx),%dl
  800944:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800946:	ff 4d 10             	decl   0x10(%ebp)
  800949:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80094d:	74 09                	je     800958 <strlcpy+0x3c>
  80094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800952:	8a 00                	mov    (%eax),%al
  800954:	84 c0                	test   %al,%al
  800956:	75 d8                	jne    800930 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80095e:	8b 55 08             	mov    0x8(%ebp),%edx
  800961:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800964:	29 c2                	sub    %eax,%edx
  800966:	89 d0                	mov    %edx,%eax
}
  800968:	c9                   	leave  
  800969:	c3                   	ret    

0080096a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80096d:	eb 06                	jmp    800975 <strcmp+0xb>
		p++, q++;
  80096f:	ff 45 08             	incl   0x8(%ebp)
  800972:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8a 00                	mov    (%eax),%al
  80097a:	84 c0                	test   %al,%al
  80097c:	74 0e                	je     80098c <strcmp+0x22>
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8a 10                	mov    (%eax),%dl
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8a 00                	mov    (%eax),%al
  800988:	38 c2                	cmp    %al,%dl
  80098a:	74 e3                	je     80096f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8a 00                	mov    (%eax),%al
  800991:	0f b6 d0             	movzbl %al,%edx
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	8a 00                	mov    (%eax),%al
  800999:	0f b6 c0             	movzbl %al,%eax
  80099c:	29 c2                	sub    %eax,%edx
  80099e:	89 d0                	mov    %edx,%eax
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8009a5:	eb 09                	jmp    8009b0 <strncmp+0xe>
		n--, p++, q++;
  8009a7:	ff 4d 10             	decl   0x10(%ebp)
  8009aa:	ff 45 08             	incl   0x8(%ebp)
  8009ad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8009b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009b4:	74 17                	je     8009cd <strncmp+0x2b>
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8a 00                	mov    (%eax),%al
  8009bb:	84 c0                	test   %al,%al
  8009bd:	74 0e                	je     8009cd <strncmp+0x2b>
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8a 10                	mov    (%eax),%dl
  8009c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c7:	8a 00                	mov    (%eax),%al
  8009c9:	38 c2                	cmp    %al,%dl
  8009cb:	74 da                	je     8009a7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8009cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009d1:	75 07                	jne    8009da <strncmp+0x38>
		return 0;
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	eb 14                	jmp    8009ee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d0             	movzbl %al,%edx
  8009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e5:	8a 00                	mov    (%eax),%al
  8009e7:	0f b6 c0             	movzbl %al,%eax
  8009ea:	29 c2                	sub    %eax,%edx
  8009ec:	89 d0                	mov    %edx,%eax
}
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	83 ec 04             	sub    $0x4,%esp
  8009f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8009fc:	eb 12                	jmp    800a10 <strchr+0x20>
		if (*s == c)
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8a 00                	mov    (%eax),%al
  800a03:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a06:	75 05                	jne    800a0d <strchr+0x1d>
			return (char *) s;
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	eb 11                	jmp    800a1e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a0d:	ff 45 08             	incl   0x8(%ebp)
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8a 00                	mov    (%eax),%al
  800a15:	84 c0                	test   %al,%al
  800a17:	75 e5                	jne    8009fe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 04             	sub    $0x4,%esp
  800a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a29:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a2c:	eb 0d                	jmp    800a3b <strfind+0x1b>
		if (*s == c)
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8a 00                	mov    (%eax),%al
  800a33:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a36:	74 0e                	je     800a46 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a38:	ff 45 08             	incl   0x8(%ebp)
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	8a 00                	mov    (%eax),%al
  800a40:	84 c0                	test   %al,%al
  800a42:	75 ea                	jne    800a2e <strfind+0xe>
  800a44:	eb 01                	jmp    800a47 <strfind+0x27>
		if (*s == c)
			break;
  800a46:	90                   	nop
	return (char *) s;
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800a58:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800a5e:	eb 0e                	jmp    800a6e <memset+0x22>
		*p++ = c;
  800a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a63:	8d 50 01             	lea    0x1(%eax),%edx
  800a66:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800a6e:	ff 4d f8             	decl   -0x8(%ebp)
  800a71:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800a75:	79 e9                	jns    800a60 <memset+0x14>
		*p++ = c;

	return v;
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800a8e:	eb 16                	jmp    800aa6 <memcpy+0x2a>
		*d++ = *s++;
  800a90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800a93:	8d 50 01             	lea    0x1(%eax),%edx
  800a96:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800a99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800a9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a9f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800aa2:	8a 12                	mov    (%edx),%dl
  800aa4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800aa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800aac:	89 55 10             	mov    %edx,0x10(%ebp)
  800aaf:	85 c0                	test   %eax,%eax
  800ab1:	75 dd                	jne    800a90 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ab6:	c9                   	leave  
  800ab7:	c3                   	ret    

00800ab8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800acd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ad0:	73 50                	jae    800b22 <memmove+0x6a>
  800ad2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ad5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800add:	76 43                	jbe    800b22 <memmove+0x6a>
		s += n;
  800adf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800aeb:	eb 10                	jmp    800afd <memmove+0x45>
			*--d = *--s;
  800aed:	ff 4d f8             	decl   -0x8(%ebp)
  800af0:	ff 4d fc             	decl   -0x4(%ebp)
  800af3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800af6:	8a 10                	mov    (%eax),%dl
  800af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800afb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800afd:	8b 45 10             	mov    0x10(%ebp),%eax
  800b00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b03:	89 55 10             	mov    %edx,0x10(%ebp)
  800b06:	85 c0                	test   %eax,%eax
  800b08:	75 e3                	jne    800aed <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b0a:	eb 23                	jmp    800b2f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b0f:	8d 50 01             	lea    0x1(%eax),%edx
  800b12:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b1b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b1e:	8a 12                	mov    (%edx),%dl
  800b20:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800b22:	8b 45 10             	mov    0x10(%ebp),%eax
  800b25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b28:	89 55 10             	mov    %edx,0x10(%ebp)
  800b2b:	85 c0                	test   %eax,%eax
  800b2d:	75 dd                	jne    800b0c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800b46:	eb 2a                	jmp    800b72 <memcmp+0x3e>
		if (*s1 != *s2)
  800b48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b4b:	8a 10                	mov    (%eax),%dl
  800b4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b50:	8a 00                	mov    (%eax),%al
  800b52:	38 c2                	cmp    %al,%dl
  800b54:	74 16                	je     800b6c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	0f b6 d0             	movzbl %al,%edx
  800b5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b61:	8a 00                	mov    (%eax),%al
  800b63:	0f b6 c0             	movzbl %al,%eax
  800b66:	29 c2                	sub    %eax,%edx
  800b68:	89 d0                	mov    %edx,%eax
  800b6a:	eb 18                	jmp    800b84 <memcmp+0x50>
		s1++, s2++;
  800b6c:	ff 45 fc             	incl   -0x4(%ebp)
  800b6f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800b72:	8b 45 10             	mov    0x10(%ebp),%eax
  800b75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b78:	89 55 10             	mov    %edx,0x10(%ebp)
  800b7b:	85 c0                	test   %eax,%eax
  800b7d:	75 c9                	jne    800b48 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800b8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b92:	01 d0                	add    %edx,%eax
  800b94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800b97:	eb 15                	jmp    800bae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	0f b6 d0             	movzbl %al,%edx
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	0f b6 c0             	movzbl %al,%eax
  800ba7:	39 c2                	cmp    %eax,%edx
  800ba9:	74 0d                	je     800bb8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bab:	ff 45 08             	incl   0x8(%ebp)
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800bb4:	72 e3                	jb     800b99 <memfind+0x13>
  800bb6:	eb 01                	jmp    800bb9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800bb8:	90                   	nop
	return (void *) s;
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800bc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800bcb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd2:	eb 03                	jmp    800bd7 <strtol+0x19>
		s++;
  800bd4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	8a 00                	mov    (%eax),%al
  800bdc:	3c 20                	cmp    $0x20,%al
  800bde:	74 f4                	je     800bd4 <strtol+0x16>
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8a 00                	mov    (%eax),%al
  800be5:	3c 09                	cmp    $0x9,%al
  800be7:	74 eb                	je     800bd4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8a 00                	mov    (%eax),%al
  800bee:	3c 2b                	cmp    $0x2b,%al
  800bf0:	75 05                	jne    800bf7 <strtol+0x39>
		s++;
  800bf2:	ff 45 08             	incl   0x8(%ebp)
  800bf5:	eb 13                	jmp    800c0a <strtol+0x4c>
	else if (*s == '-')
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	3c 2d                	cmp    $0x2d,%al
  800bfe:	75 0a                	jne    800c0a <strtol+0x4c>
		s++, neg = 1;
  800c00:	ff 45 08             	incl   0x8(%ebp)
  800c03:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c0e:	74 06                	je     800c16 <strtol+0x58>
  800c10:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c14:	75 20                	jne    800c36 <strtol+0x78>
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	3c 30                	cmp    $0x30,%al
  800c1d:	75 17                	jne    800c36 <strtol+0x78>
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	40                   	inc    %eax
  800c23:	8a 00                	mov    (%eax),%al
  800c25:	3c 78                	cmp    $0x78,%al
  800c27:	75 0d                	jne    800c36 <strtol+0x78>
		s += 2, base = 16;
  800c29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800c2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c34:	eb 28                	jmp    800c5e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800c36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3a:	75 15                	jne    800c51 <strtol+0x93>
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	3c 30                	cmp    $0x30,%al
  800c43:	75 0c                	jne    800c51 <strtol+0x93>
		s++, base = 8;
  800c45:	ff 45 08             	incl   0x8(%ebp)
  800c48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800c4f:	eb 0d                	jmp    800c5e <strtol+0xa0>
	else if (base == 0)
  800c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c55:	75 07                	jne    800c5e <strtol+0xa0>
		base = 10;
  800c57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	3c 2f                	cmp    $0x2f,%al
  800c65:	7e 19                	jle    800c80 <strtol+0xc2>
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8a 00                	mov    (%eax),%al
  800c6c:	3c 39                	cmp    $0x39,%al
  800c6e:	7f 10                	jg     800c80 <strtol+0xc2>
			dig = *s - '0';
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	8a 00                	mov    (%eax),%al
  800c75:	0f be c0             	movsbl %al,%eax
  800c78:	83 e8 30             	sub    $0x30,%eax
  800c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c7e:	eb 42                	jmp    800cc2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	3c 60                	cmp    $0x60,%al
  800c87:	7e 19                	jle    800ca2 <strtol+0xe4>
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	3c 7a                	cmp    $0x7a,%al
  800c90:	7f 10                	jg     800ca2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8a 00                	mov    (%eax),%al
  800c97:	0f be c0             	movsbl %al,%eax
  800c9a:	83 e8 57             	sub    $0x57,%eax
  800c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ca0:	eb 20                	jmp    800cc2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	3c 40                	cmp    $0x40,%al
  800ca9:	7e 39                	jle    800ce4 <strtol+0x126>
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	3c 5a                	cmp    $0x5a,%al
  800cb2:	7f 30                	jg     800ce4 <strtol+0x126>
			dig = *s - 'A' + 10;
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	0f be c0             	movsbl %al,%eax
  800cbc:	83 e8 37             	sub    $0x37,%eax
  800cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cc5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cc8:	7d 19                	jge    800ce3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800cca:	ff 45 08             	incl   0x8(%ebp)
  800ccd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cd9:	01 d0                	add    %edx,%eax
  800cdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800cde:	e9 7b ff ff ff       	jmp    800c5e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ce3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ce4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce8:	74 08                	je     800cf2 <strtol+0x134>
		*endptr = (char *) s;
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800cf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800cf6:	74 07                	je     800cff <strtol+0x141>
  800cf8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cfb:	f7 d8                	neg    %eax
  800cfd:	eb 03                	jmp    800d02 <strtol+0x144>
  800cff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <ltostr>:

void
ltostr(long value, char *str)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d1c:	79 13                	jns    800d31 <ltostr+0x2d>
	{
		neg = 1;
  800d1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800d2b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800d2e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800d39:	99                   	cltd   
  800d3a:	f7 f9                	idiv   %ecx
  800d3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d48:	89 c2                	mov    %eax,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d52:	83 c2 30             	add    $0x30,%edx
  800d55:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800d57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800d5f:	f7 e9                	imul   %ecx
  800d61:	c1 fa 02             	sar    $0x2,%edx
  800d64:	89 c8                	mov    %ecx,%eax
  800d66:	c1 f8 1f             	sar    $0x1f,%eax
  800d69:	29 c2                	sub    %eax,%edx
  800d6b:	89 d0                	mov    %edx,%eax
  800d6d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800d70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d73:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800d78:	f7 e9                	imul   %ecx
  800d7a:	c1 fa 02             	sar    $0x2,%edx
  800d7d:	89 c8                	mov    %ecx,%eax
  800d7f:	c1 f8 1f             	sar    $0x1f,%eax
  800d82:	29 c2                	sub    %eax,%edx
  800d84:	89 d0                	mov    %edx,%eax
  800d86:	c1 e0 02             	shl    $0x2,%eax
  800d89:	01 d0                	add    %edx,%eax
  800d8b:	01 c0                	add    %eax,%eax
  800d8d:	29 c1                	sub    %eax,%ecx
  800d8f:	89 ca                	mov    %ecx,%edx
  800d91:	85 d2                	test   %edx,%edx
  800d93:	75 9c                	jne    800d31 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800d95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800d9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9f:	48                   	dec    %eax
  800da0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800da3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800da7:	74 3d                	je     800de6 <ltostr+0xe2>
		start = 1 ;
  800da9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800db0:	eb 34                	jmp    800de6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	01 d0                	add    %edx,%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800dbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	01 c2                	add    %eax,%edx
  800dc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	01 c8                	add    %ecx,%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800dd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	01 c2                	add    %eax,%edx
  800ddb:	8a 45 eb             	mov    -0x15(%ebp),%al
  800dde:	88 02                	mov    %al,(%edx)
		start++ ;
  800de0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800de3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dec:	7c c4                	jl     800db2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800dee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	01 d0                	add    %edx,%eax
  800df6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800df9:	90                   	nop
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e02:	ff 75 08             	pushl  0x8(%ebp)
  800e05:	e8 54 fa ff ff       	call   80085e <strlen>
  800e0a:	83 c4 04             	add    $0x4,%esp
  800e0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e10:	ff 75 0c             	pushl  0xc(%ebp)
  800e13:	e8 46 fa ff ff       	call   80085e <strlen>
  800e18:	83 c4 04             	add    $0x4,%esp
  800e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800e25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2c:	eb 17                	jmp    800e45 <strcconcat+0x49>
		final[s] = str1[s] ;
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	01 c2                	add    %eax,%edx
  800e36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	01 c8                	add    %ecx,%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800e42:	ff 45 fc             	incl   -0x4(%ebp)
  800e45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e4b:	7c e1                	jl     800e2e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800e4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800e54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800e5b:	eb 1f                	jmp    800e7c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e60:	8d 50 01             	lea    0x1(%eax),%edx
  800e63:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e66:	89 c2                	mov    %eax,%edx
  800e68:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6b:	01 c2                	add    %eax,%edx
  800e6d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	01 c8                	add    %ecx,%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800e79:	ff 45 f8             	incl   -0x8(%ebp)
  800e7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e82:	7c d9                	jl     800e5d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800e84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	01 d0                	add    %edx,%eax
  800e8c:	c6 00 00             	movb   $0x0,(%eax)
}
  800e8f:	90                   	nop
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800e95:	8b 45 14             	mov    0x14(%ebp),%eax
  800e98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800e9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea1:	8b 00                	mov    (%eax),%eax
  800ea3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800eb5:	eb 0c                	jmp    800ec3 <strsplit+0x31>
			*string++ = 0;
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8d 50 01             	lea    0x1(%eax),%edx
  800ebd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	74 18                	je     800ee4 <strsplit+0x52>
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f be c0             	movsbl %al,%eax
  800ed4:	50                   	push   %eax
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	e8 13 fb ff ff       	call   8009f0 <strchr>
  800edd:	83 c4 08             	add    $0x8,%esp
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	75 d3                	jne    800eb7 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	74 5a                	je     800f47 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  800eed:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef0:	8b 00                	mov    (%eax),%eax
  800ef2:	83 f8 0f             	cmp    $0xf,%eax
  800ef5:	75 07                	jne    800efe <strsplit+0x6c>
		{
			return 0;
  800ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  800efc:	eb 66                	jmp    800f64 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800efe:	8b 45 14             	mov    0x14(%ebp),%eax
  800f01:	8b 00                	mov    (%eax),%eax
  800f03:	8d 48 01             	lea    0x1(%eax),%ecx
  800f06:	8b 55 14             	mov    0x14(%ebp),%edx
  800f09:	89 0a                	mov    %ecx,(%edx)
  800f0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f12:	8b 45 10             	mov    0x10(%ebp),%eax
  800f15:	01 c2                	add    %eax,%edx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f1c:	eb 03                	jmp    800f21 <strsplit+0x8f>
			string++;
  800f1e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	84 c0                	test   %al,%al
  800f28:	74 8b                	je     800eb5 <strsplit+0x23>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	0f be c0             	movsbl %al,%eax
  800f32:	50                   	push   %eax
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	e8 b5 fa ff ff       	call   8009f0 <strchr>
  800f3b:	83 c4 08             	add    $0x8,%esp
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	74 dc                	je     800f1e <strsplit+0x8c>
			string++;
	}
  800f42:	e9 6e ff ff ff       	jmp    800eb5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800f47:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	8b 00                	mov    (%eax),%eax
  800f4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800f5f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
  800f6c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800f7b:	8b 7d 18             	mov    0x18(%ebp),%edi
  800f7e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  800f81:	cd 30                	int    $0x30
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  800f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f89:	83 c4 10             	add    $0x10,%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    

00800f91 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	6a 00                	push   $0x0
  800f99:	6a 00                	push   $0x0
  800f9b:	6a 00                	push   $0x0
  800f9d:	ff 75 0c             	pushl  0xc(%ebp)
  800fa0:	50                   	push   %eax
  800fa1:	6a 00                	push   $0x0
  800fa3:	e8 be ff ff ff       	call   800f66 <syscall>
  800fa8:	83 c4 18             	add    $0x18,%esp
}
  800fab:	90                   	nop
  800fac:	c9                   	leave  
  800fad:	c3                   	ret    

00800fae <sys_cgetc>:

int
sys_cgetc(void)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  800fb1:	6a 00                	push   $0x0
  800fb3:	6a 00                	push   $0x0
  800fb5:	6a 00                	push   $0x0
  800fb7:	6a 00                	push   $0x0
  800fb9:	6a 00                	push   $0x0
  800fbb:	6a 01                	push   $0x1
  800fbd:	e8 a4 ff ff ff       	call   800f66 <syscall>
  800fc2:	83 c4 18             	add    $0x18,%esp
}
  800fc5:	c9                   	leave  
  800fc6:	c3                   	ret    

00800fc7 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	6a 00                	push   $0x0
  800fcf:	6a 00                	push   $0x0
  800fd1:	6a 00                	push   $0x0
  800fd3:	6a 00                	push   $0x0
  800fd5:	50                   	push   %eax
  800fd6:	6a 03                	push   $0x3
  800fd8:	e8 89 ff ff ff       	call   800f66 <syscall>
  800fdd:	83 c4 18             	add    $0x18,%esp
}
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    

00800fe2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  800fe5:	6a 00                	push   $0x0
  800fe7:	6a 00                	push   $0x0
  800fe9:	6a 00                	push   $0x0
  800feb:	6a 00                	push   $0x0
  800fed:	6a 00                	push   $0x0
  800fef:	6a 02                	push   $0x2
  800ff1:	e8 70 ff ff ff       	call   800f66 <syscall>
  800ff6:	83 c4 18             	add    $0x18,%esp
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <sys_env_exit>:

void sys_env_exit(void)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  800ffe:	6a 00                	push   $0x0
  801000:	6a 00                	push   $0x0
  801002:	6a 00                	push   $0x0
  801004:	6a 00                	push   $0x0
  801006:	6a 00                	push   $0x0
  801008:	6a 04                	push   $0x4
  80100a:	e8 57 ff ff ff       	call   800f66 <syscall>
  80100f:	83 c4 18             	add    $0x18,%esp
}
  801012:	90                   	nop
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	6a 00                	push   $0x0
  801020:	6a 00                	push   $0x0
  801022:	6a 00                	push   $0x0
  801024:	52                   	push   %edx
  801025:	50                   	push   %eax
  801026:	6a 05                	push   $0x5
  801028:	e8 39 ff ff ff       	call   800f66 <syscall>
  80102d:	83 c4 18             	add    $0x18,%esp
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	56                   	push   %esi
  801036:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801037:	8b 75 18             	mov    0x18(%ebp),%esi
  80103a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80103d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801040:	8b 55 0c             	mov    0xc(%ebp),%edx
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
  801048:	51                   	push   %ecx
  801049:	52                   	push   %edx
  80104a:	50                   	push   %eax
  80104b:	6a 06                	push   $0x6
  80104d:	e8 14 ff ff ff       	call   800f66 <syscall>
  801052:	83 c4 18             	add    $0x18,%esp
}
  801055:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801058:	5b                   	pop    %ebx
  801059:	5e                   	pop    %esi
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    

0080105c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80105f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	6a 00                	push   $0x0
  801067:	6a 00                	push   $0x0
  801069:	6a 00                	push   $0x0
  80106b:	52                   	push   %edx
  80106c:	50                   	push   %eax
  80106d:	6a 07                	push   $0x7
  80106f:	e8 f2 fe ff ff       	call   800f66 <syscall>
  801074:	83 c4 18             	add    $0x18,%esp
}
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80107c:	6a 00                	push   $0x0
  80107e:	6a 00                	push   $0x0
  801080:	6a 00                	push   $0x0
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	ff 75 08             	pushl  0x8(%ebp)
  801088:	6a 08                	push   $0x8
  80108a:	e8 d7 fe ff ff       	call   800f66 <syscall>
  80108f:	83 c4 18             	add    $0x18,%esp
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801097:	6a 00                	push   $0x0
  801099:	6a 00                	push   $0x0
  80109b:	6a 00                	push   $0x0
  80109d:	6a 00                	push   $0x0
  80109f:	6a 00                	push   $0x0
  8010a1:	6a 09                	push   $0x9
  8010a3:	e8 be fe ff ff       	call   800f66 <syscall>
  8010a8:	83 c4 18             	add    $0x18,%esp
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8010b0:	6a 00                	push   $0x0
  8010b2:	6a 00                	push   $0x0
  8010b4:	6a 00                	push   $0x0
  8010b6:	6a 00                	push   $0x0
  8010b8:	6a 00                	push   $0x0
  8010ba:	6a 0a                	push   $0xa
  8010bc:	e8 a5 fe ff ff       	call   800f66 <syscall>
  8010c1:	83 c4 18             	add    $0x18,%esp
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8010c9:	6a 00                	push   $0x0
  8010cb:	6a 00                	push   $0x0
  8010cd:	6a 00                	push   $0x0
  8010cf:	6a 00                	push   $0x0
  8010d1:	6a 00                	push   $0x0
  8010d3:	6a 0b                	push   $0xb
  8010d5:	e8 8c fe ff ff       	call   800f66 <syscall>
  8010da:	83 c4 18             	add    $0x18,%esp
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8010e2:	6a 00                	push   $0x0
  8010e4:	6a 00                	push   $0x0
  8010e6:	6a 00                	push   $0x0
  8010e8:	ff 75 0c             	pushl  0xc(%ebp)
  8010eb:	ff 75 08             	pushl  0x8(%ebp)
  8010ee:	6a 0d                	push   $0xd
  8010f0:	e8 71 fe ff ff       	call   800f66 <syscall>
  8010f5:	83 c4 18             	add    $0x18,%esp
	return;
  8010f8:	90                   	nop
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8010fe:	6a 00                	push   $0x0
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	ff 75 0c             	pushl  0xc(%ebp)
  801107:	ff 75 08             	pushl  0x8(%ebp)
  80110a:	6a 0e                	push   $0xe
  80110c:	e8 55 fe ff ff       	call   800f66 <syscall>
  801111:	83 c4 18             	add    $0x18,%esp
	return ;
  801114:	90                   	nop
}
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80111a:	6a 00                	push   $0x0
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	6a 0c                	push   $0xc
  801126:	e8 3b fe ff ff       	call   800f66 <syscall>
  80112b:	83 c4 18             	add    $0x18,%esp
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801133:	6a 00                	push   $0x0
  801135:	6a 00                	push   $0x0
  801137:	6a 00                	push   $0x0
  801139:	6a 00                	push   $0x0
  80113b:	6a 00                	push   $0x0
  80113d:	6a 10                	push   $0x10
  80113f:	e8 22 fe ff ff       	call   800f66 <syscall>
  801144:	83 c4 18             	add    $0x18,%esp
}
  801147:	90                   	nop
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	6a 00                	push   $0x0
  801155:	6a 00                	push   $0x0
  801157:	6a 11                	push   $0x11
  801159:	e8 08 fe ff ff       	call   800f66 <syscall>
  80115e:	83 c4 18             	add    $0x18,%esp
}
  801161:	90                   	nop
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <sys_cputc>:


void
sys_cputc(const char c)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801170:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801174:	6a 00                	push   $0x0
  801176:	6a 00                	push   $0x0
  801178:	6a 00                	push   $0x0
  80117a:	6a 00                	push   $0x0
  80117c:	50                   	push   %eax
  80117d:	6a 12                	push   $0x12
  80117f:	e8 e2 fd ff ff       	call   800f66 <syscall>
  801184:	83 c4 18             	add    $0x18,%esp
}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80118d:	6a 00                	push   $0x0
  80118f:	6a 00                	push   $0x0
  801191:	6a 00                	push   $0x0
  801193:	6a 00                	push   $0x0
  801195:	6a 00                	push   $0x0
  801197:	6a 13                	push   $0x13
  801199:	e8 c8 fd ff ff       	call   800f66 <syscall>
  80119e:	83 c4 18             	add    $0x18,%esp
}
  8011a1:	90                   	nop
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	6a 00                	push   $0x0
  8011ac:	6a 00                	push   $0x0
  8011ae:	6a 00                	push   $0x0
  8011b0:	ff 75 0c             	pushl  0xc(%ebp)
  8011b3:	50                   	push   %eax
  8011b4:	6a 14                	push   $0x14
  8011b6:	e8 ab fd ff ff       	call   800f66 <syscall>
  8011bb:	83 c4 18             	add    $0x18,%esp
}
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	6a 00                	push   $0x0
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 00                	push   $0x0
  8011cc:	6a 00                	push   $0x0
  8011ce:	50                   	push   %eax
  8011cf:	6a 17                	push   $0x17
  8011d1:	e8 90 fd ff ff       	call   800f66 <syscall>
  8011d6:	83 c4 18             	add    $0x18,%esp
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 00                	push   $0x0
  8011e5:	6a 00                	push   $0x0
  8011e7:	6a 00                	push   $0x0
  8011e9:	50                   	push   %eax
  8011ea:	6a 15                	push   $0x15
  8011ec:	e8 75 fd ff ff       	call   800f66 <syscall>
  8011f1:	83 c4 18             	add    $0x18,%esp
}
  8011f4:	90                   	nop
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	50                   	push   %eax
  801206:	6a 16                	push   $0x16
  801208:	e8 59 fd ff ff       	call   800f66 <syscall>
  80120d:	83 c4 18             	add    $0x18,%esp
}
  801210:	90                   	nop
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 04             	sub    $0x4,%esp
  801219:	8b 45 10             	mov    0x10(%ebp),%eax
  80121c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80121f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801222:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	6a 00                	push   $0x0
  80122b:	51                   	push   %ecx
  80122c:	52                   	push   %edx
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	50                   	push   %eax
  801231:	6a 18                	push   $0x18
  801233:	e8 2e fd ff ff       	call   800f66 <syscall>
  801238:	83 c4 18             	add    $0x18,%esp
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801240:	8b 55 0c             	mov    0xc(%ebp),%edx
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	6a 00                	push   $0x0
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	52                   	push   %edx
  80124d:	50                   	push   %eax
  80124e:	6a 19                	push   $0x19
  801250:	e8 11 fd ff ff       	call   800f66 <syscall>
  801255:	83 c4 18             	add    $0x18,%esp
}
  801258:	c9                   	leave  
  801259:	c3                   	ret    

0080125a <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	50                   	push   %eax
  801269:	6a 1a                	push   $0x1a
  80126b:	e8 f6 fc ff ff       	call   800f66 <syscall>
  801270:	83 c4 18             	add    $0x18,%esp
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 1b                	push   $0x1b
  801284:	e8 dd fc ff ff       	call   800f66 <syscall>
  801289:	83 c4 18             	add    $0x18,%esp
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 1c                	push   $0x1c
  80129d:	e8 c4 fc ff ff       	call   800f66 <syscall>
  8012a2:	83 c4 18             	add    $0x18,%esp
}
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

008012a7 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	50                   	push   %eax
  8012b7:	6a 1d                	push   $0x1d
  8012b9:	e8 a8 fc ff ff       	call   800f66 <syscall>
  8012be:	83 c4 18             	add    $0x18,%esp
}
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	50                   	push   %eax
  8012d2:	6a 1e                	push   $0x1e
  8012d4:	e8 8d fc ff ff       	call   800f66 <syscall>
  8012d9:	83 c4 18             	add    $0x18,%esp
}
  8012dc:	90                   	nop
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	50                   	push   %eax
  8012ee:	6a 1f                	push   $0x1f
  8012f0:	e8 71 fc ff ff       	call   800f66 <syscall>
  8012f5:	83 c4 18             	add    $0x18,%esp
}
  8012f8:	90                   	nop
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801301:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801304:	8d 50 04             	lea    0x4(%eax),%edx
  801307:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	52                   	push   %edx
  801311:	50                   	push   %eax
  801312:	6a 20                	push   $0x20
  801314:	e8 4d fc ff ff       	call   800f66 <syscall>
  801319:	83 c4 18             	add    $0x18,%esp
	return result;
  80131c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801322:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801325:	89 01                	mov    %eax,(%ecx)
  801327:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	c9                   	leave  
  80132e:	c2 04 00             	ret    $0x4

00801331 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	ff 75 10             	pushl  0x10(%ebp)
  80133b:	ff 75 0c             	pushl  0xc(%ebp)
  80133e:	ff 75 08             	pushl  0x8(%ebp)
  801341:	6a 0f                	push   $0xf
  801343:	e8 1e fc ff ff       	call   800f66 <syscall>
  801348:	83 c4 18             	add    $0x18,%esp
	return ;
  80134b:	90                   	nop
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <sys_rcr2>:
uint32 sys_rcr2()
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 21                	push   $0x21
  80135d:	e8 04 fc ff ff       	call   800f66 <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	83 ec 04             	sub    $0x4,%esp
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801373:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	50                   	push   %eax
  801380:	6a 22                	push   $0x22
  801382:	e8 df fb ff ff       	call   800f66 <syscall>
  801387:	83 c4 18             	add    $0x18,%esp
	return ;
  80138a:	90                   	nop
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <rsttst>:
void rsttst()
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 24                	push   $0x24
  80139c:	e8 c5 fb ff ff       	call   800f66 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8013a4:	90                   	nop
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 04             	sub    $0x4,%esp
  8013ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013b3:	8b 55 18             	mov    0x18(%ebp),%edx
  8013b6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013ba:	52                   	push   %edx
  8013bb:	50                   	push   %eax
  8013bc:	ff 75 10             	pushl  0x10(%ebp)
  8013bf:	ff 75 0c             	pushl  0xc(%ebp)
  8013c2:	ff 75 08             	pushl  0x8(%ebp)
  8013c5:	6a 23                	push   $0x23
  8013c7:	e8 9a fb ff ff       	call   800f66 <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8013cf:	90                   	nop
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <chktst>:
void chktst(uint32 n)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	ff 75 08             	pushl  0x8(%ebp)
  8013e0:	6a 25                	push   $0x25
  8013e2:	e8 7f fb ff ff       	call   800f66 <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ea:	90                   	nop
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 26                	push   $0x26
  8013ff:	e8 62 fb ff ff       	call   800f66 <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
  801407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80140a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80140e:	75 07                	jne    801417 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801410:	b8 01 00 00 00       	mov    $0x1,%eax
  801415:	eb 05                	jmp    80141c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801417:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 26                	push   $0x26
  801430:	e8 31 fb ff ff       	call   800f66 <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
  801438:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80143b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80143f:	75 07                	jne    801448 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801441:	b8 01 00 00 00       	mov    $0x1,%eax
  801446:	eb 05                	jmp    80144d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 26                	push   $0x26
  801461:	e8 00 fb ff ff       	call   800f66 <syscall>
  801466:	83 c4 18             	add    $0x18,%esp
  801469:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80146c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801470:	75 07                	jne    801479 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801472:	b8 01 00 00 00       	mov    $0x1,%eax
  801477:	eb 05                	jmp    80147e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 26                	push   $0x26
  801492:	e8 cf fa ff ff       	call   800f66 <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
  80149a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80149d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8014a1:	75 07                	jne    8014aa <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8014a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8014a8:	eb 05                	jmp    8014af <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8014aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	ff 75 08             	pushl  0x8(%ebp)
  8014bf:	6a 27                	push   $0x27
  8014c1:	e8 a0 fa ff ff       	call   800f66 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8014c9:	90                   	nop
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <__udivdi3>:
  8014cc:	55                   	push   %ebp
  8014cd:	57                   	push   %edi
  8014ce:	56                   	push   %esi
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 1c             	sub    $0x1c,%esp
  8014d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8014d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8014db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8014df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014e3:	89 ca                	mov    %ecx,%edx
  8014e5:	89 f8                	mov    %edi,%eax
  8014e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8014eb:	85 f6                	test   %esi,%esi
  8014ed:	75 2d                	jne    80151c <__udivdi3+0x50>
  8014ef:	39 cf                	cmp    %ecx,%edi
  8014f1:	77 65                	ja     801558 <__udivdi3+0x8c>
  8014f3:	89 fd                	mov    %edi,%ebp
  8014f5:	85 ff                	test   %edi,%edi
  8014f7:	75 0b                	jne    801504 <__udivdi3+0x38>
  8014f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8014fe:	31 d2                	xor    %edx,%edx
  801500:	f7 f7                	div    %edi
  801502:	89 c5                	mov    %eax,%ebp
  801504:	31 d2                	xor    %edx,%edx
  801506:	89 c8                	mov    %ecx,%eax
  801508:	f7 f5                	div    %ebp
  80150a:	89 c1                	mov    %eax,%ecx
  80150c:	89 d8                	mov    %ebx,%eax
  80150e:	f7 f5                	div    %ebp
  801510:	89 cf                	mov    %ecx,%edi
  801512:	89 fa                	mov    %edi,%edx
  801514:	83 c4 1c             	add    $0x1c,%esp
  801517:	5b                   	pop    %ebx
  801518:	5e                   	pop    %esi
  801519:	5f                   	pop    %edi
  80151a:	5d                   	pop    %ebp
  80151b:	c3                   	ret    
  80151c:	39 ce                	cmp    %ecx,%esi
  80151e:	77 28                	ja     801548 <__udivdi3+0x7c>
  801520:	0f bd fe             	bsr    %esi,%edi
  801523:	83 f7 1f             	xor    $0x1f,%edi
  801526:	75 40                	jne    801568 <__udivdi3+0x9c>
  801528:	39 ce                	cmp    %ecx,%esi
  80152a:	72 0a                	jb     801536 <__udivdi3+0x6a>
  80152c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801530:	0f 87 9e 00 00 00    	ja     8015d4 <__udivdi3+0x108>
  801536:	b8 01 00 00 00       	mov    $0x1,%eax
  80153b:	89 fa                	mov    %edi,%edx
  80153d:	83 c4 1c             	add    $0x1c,%esp
  801540:	5b                   	pop    %ebx
  801541:	5e                   	pop    %esi
  801542:	5f                   	pop    %edi
  801543:	5d                   	pop    %ebp
  801544:	c3                   	ret    
  801545:	8d 76 00             	lea    0x0(%esi),%esi
  801548:	31 ff                	xor    %edi,%edi
  80154a:	31 c0                	xor    %eax,%eax
  80154c:	89 fa                	mov    %edi,%edx
  80154e:	83 c4 1c             	add    $0x1c,%esp
  801551:	5b                   	pop    %ebx
  801552:	5e                   	pop    %esi
  801553:	5f                   	pop    %edi
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    
  801556:	66 90                	xchg   %ax,%ax
  801558:	89 d8                	mov    %ebx,%eax
  80155a:	f7 f7                	div    %edi
  80155c:	31 ff                	xor    %edi,%edi
  80155e:	89 fa                	mov    %edi,%edx
  801560:	83 c4 1c             	add    $0x1c,%esp
  801563:	5b                   	pop    %ebx
  801564:	5e                   	pop    %esi
  801565:	5f                   	pop    %edi
  801566:	5d                   	pop    %ebp
  801567:	c3                   	ret    
  801568:	bd 20 00 00 00       	mov    $0x20,%ebp
  80156d:	89 eb                	mov    %ebp,%ebx
  80156f:	29 fb                	sub    %edi,%ebx
  801571:	89 f9                	mov    %edi,%ecx
  801573:	d3 e6                	shl    %cl,%esi
  801575:	89 c5                	mov    %eax,%ebp
  801577:	88 d9                	mov    %bl,%cl
  801579:	d3 ed                	shr    %cl,%ebp
  80157b:	89 e9                	mov    %ebp,%ecx
  80157d:	09 f1                	or     %esi,%ecx
  80157f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801583:	89 f9                	mov    %edi,%ecx
  801585:	d3 e0                	shl    %cl,%eax
  801587:	89 c5                	mov    %eax,%ebp
  801589:	89 d6                	mov    %edx,%esi
  80158b:	88 d9                	mov    %bl,%cl
  80158d:	d3 ee                	shr    %cl,%esi
  80158f:	89 f9                	mov    %edi,%ecx
  801591:	d3 e2                	shl    %cl,%edx
  801593:	8b 44 24 08          	mov    0x8(%esp),%eax
  801597:	88 d9                	mov    %bl,%cl
  801599:	d3 e8                	shr    %cl,%eax
  80159b:	09 c2                	or     %eax,%edx
  80159d:	89 d0                	mov    %edx,%eax
  80159f:	89 f2                	mov    %esi,%edx
  8015a1:	f7 74 24 0c          	divl   0xc(%esp)
  8015a5:	89 d6                	mov    %edx,%esi
  8015a7:	89 c3                	mov    %eax,%ebx
  8015a9:	f7 e5                	mul    %ebp
  8015ab:	39 d6                	cmp    %edx,%esi
  8015ad:	72 19                	jb     8015c8 <__udivdi3+0xfc>
  8015af:	74 0b                	je     8015bc <__udivdi3+0xf0>
  8015b1:	89 d8                	mov    %ebx,%eax
  8015b3:	31 ff                	xor    %edi,%edi
  8015b5:	e9 58 ff ff ff       	jmp    801512 <__udivdi3+0x46>
  8015ba:	66 90                	xchg   %ax,%ax
  8015bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8015c0:	89 f9                	mov    %edi,%ecx
  8015c2:	d3 e2                	shl    %cl,%edx
  8015c4:	39 c2                	cmp    %eax,%edx
  8015c6:	73 e9                	jae    8015b1 <__udivdi3+0xe5>
  8015c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8015cb:	31 ff                	xor    %edi,%edi
  8015cd:	e9 40 ff ff ff       	jmp    801512 <__udivdi3+0x46>
  8015d2:	66 90                	xchg   %ax,%ax
  8015d4:	31 c0                	xor    %eax,%eax
  8015d6:	e9 37 ff ff ff       	jmp    801512 <__udivdi3+0x46>
  8015db:	90                   	nop

008015dc <__umoddi3>:
  8015dc:	55                   	push   %ebp
  8015dd:	57                   	push   %edi
  8015de:	56                   	push   %esi
  8015df:	53                   	push   %ebx
  8015e0:	83 ec 1c             	sub    $0x1c,%esp
  8015e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8015e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8015eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8015ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8015f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015fb:	89 f3                	mov    %esi,%ebx
  8015fd:	89 fa                	mov    %edi,%edx
  8015ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801603:	89 34 24             	mov    %esi,(%esp)
  801606:	85 c0                	test   %eax,%eax
  801608:	75 1a                	jne    801624 <__umoddi3+0x48>
  80160a:	39 f7                	cmp    %esi,%edi
  80160c:	0f 86 a2 00 00 00    	jbe    8016b4 <__umoddi3+0xd8>
  801612:	89 c8                	mov    %ecx,%eax
  801614:	89 f2                	mov    %esi,%edx
  801616:	f7 f7                	div    %edi
  801618:	89 d0                	mov    %edx,%eax
  80161a:	31 d2                	xor    %edx,%edx
  80161c:	83 c4 1c             	add    $0x1c,%esp
  80161f:	5b                   	pop    %ebx
  801620:	5e                   	pop    %esi
  801621:	5f                   	pop    %edi
  801622:	5d                   	pop    %ebp
  801623:	c3                   	ret    
  801624:	39 f0                	cmp    %esi,%eax
  801626:	0f 87 ac 00 00 00    	ja     8016d8 <__umoddi3+0xfc>
  80162c:	0f bd e8             	bsr    %eax,%ebp
  80162f:	83 f5 1f             	xor    $0x1f,%ebp
  801632:	0f 84 ac 00 00 00    	je     8016e4 <__umoddi3+0x108>
  801638:	bf 20 00 00 00       	mov    $0x20,%edi
  80163d:	29 ef                	sub    %ebp,%edi
  80163f:	89 fe                	mov    %edi,%esi
  801641:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801645:	89 e9                	mov    %ebp,%ecx
  801647:	d3 e0                	shl    %cl,%eax
  801649:	89 d7                	mov    %edx,%edi
  80164b:	89 f1                	mov    %esi,%ecx
  80164d:	d3 ef                	shr    %cl,%edi
  80164f:	09 c7                	or     %eax,%edi
  801651:	89 e9                	mov    %ebp,%ecx
  801653:	d3 e2                	shl    %cl,%edx
  801655:	89 14 24             	mov    %edx,(%esp)
  801658:	89 d8                	mov    %ebx,%eax
  80165a:	d3 e0                	shl    %cl,%eax
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801662:	d3 e0                	shl    %cl,%eax
  801664:	89 44 24 04          	mov    %eax,0x4(%esp)
  801668:	8b 44 24 08          	mov    0x8(%esp),%eax
  80166c:	89 f1                	mov    %esi,%ecx
  80166e:	d3 e8                	shr    %cl,%eax
  801670:	09 d0                	or     %edx,%eax
  801672:	d3 eb                	shr    %cl,%ebx
  801674:	89 da                	mov    %ebx,%edx
  801676:	f7 f7                	div    %edi
  801678:	89 d3                	mov    %edx,%ebx
  80167a:	f7 24 24             	mull   (%esp)
  80167d:	89 c6                	mov    %eax,%esi
  80167f:	89 d1                	mov    %edx,%ecx
  801681:	39 d3                	cmp    %edx,%ebx
  801683:	0f 82 87 00 00 00    	jb     801710 <__umoddi3+0x134>
  801689:	0f 84 91 00 00 00    	je     801720 <__umoddi3+0x144>
  80168f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801693:	29 f2                	sub    %esi,%edx
  801695:	19 cb                	sbb    %ecx,%ebx
  801697:	89 d8                	mov    %ebx,%eax
  801699:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80169d:	d3 e0                	shl    %cl,%eax
  80169f:	89 e9                	mov    %ebp,%ecx
  8016a1:	d3 ea                	shr    %cl,%edx
  8016a3:	09 d0                	or     %edx,%eax
  8016a5:	89 e9                	mov    %ebp,%ecx
  8016a7:	d3 eb                	shr    %cl,%ebx
  8016a9:	89 da                	mov    %ebx,%edx
  8016ab:	83 c4 1c             	add    $0x1c,%esp
  8016ae:	5b                   	pop    %ebx
  8016af:	5e                   	pop    %esi
  8016b0:	5f                   	pop    %edi
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    
  8016b3:	90                   	nop
  8016b4:	89 fd                	mov    %edi,%ebp
  8016b6:	85 ff                	test   %edi,%edi
  8016b8:	75 0b                	jne    8016c5 <__umoddi3+0xe9>
  8016ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8016bf:	31 d2                	xor    %edx,%edx
  8016c1:	f7 f7                	div    %edi
  8016c3:	89 c5                	mov    %eax,%ebp
  8016c5:	89 f0                	mov    %esi,%eax
  8016c7:	31 d2                	xor    %edx,%edx
  8016c9:	f7 f5                	div    %ebp
  8016cb:	89 c8                	mov    %ecx,%eax
  8016cd:	f7 f5                	div    %ebp
  8016cf:	89 d0                	mov    %edx,%eax
  8016d1:	e9 44 ff ff ff       	jmp    80161a <__umoddi3+0x3e>
  8016d6:	66 90                	xchg   %ax,%ax
  8016d8:	89 c8                	mov    %ecx,%eax
  8016da:	89 f2                	mov    %esi,%edx
  8016dc:	83 c4 1c             	add    $0x1c,%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	5f                   	pop    %edi
  8016e2:	5d                   	pop    %ebp
  8016e3:	c3                   	ret    
  8016e4:	3b 04 24             	cmp    (%esp),%eax
  8016e7:	72 06                	jb     8016ef <__umoddi3+0x113>
  8016e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8016ed:	77 0f                	ja     8016fe <__umoddi3+0x122>
  8016ef:	89 f2                	mov    %esi,%edx
  8016f1:	29 f9                	sub    %edi,%ecx
  8016f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8016f7:	89 14 24             	mov    %edx,(%esp)
  8016fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801702:	8b 14 24             	mov    (%esp),%edx
  801705:	83 c4 1c             	add    $0x1c,%esp
  801708:	5b                   	pop    %ebx
  801709:	5e                   	pop    %esi
  80170a:	5f                   	pop    %edi
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    
  80170d:	8d 76 00             	lea    0x0(%esi),%esi
  801710:	2b 04 24             	sub    (%esp),%eax
  801713:	19 fa                	sbb    %edi,%edx
  801715:	89 d1                	mov    %edx,%ecx
  801717:	89 c6                	mov    %eax,%esi
  801719:	e9 71 ff ff ff       	jmp    80168f <__umoddi3+0xb3>
  80171e:	66 90                	xchg   %ax,%ax
  801720:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801724:	72 ea                	jb     801710 <__umoddi3+0x134>
  801726:	89 d9                	mov    %ebx,%ecx
  801728:	e9 62 ff ff ff       	jmp    80168f <__umoddi3+0xb3>
