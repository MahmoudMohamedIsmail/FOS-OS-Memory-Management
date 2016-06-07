
obj/user/tst_invalid_access:     file format elf32-i386


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
  800031:	e8 81 00 00 00       	call   8000b7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp

	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

	int envID = sys_getenvid();
  800045:	e8 58 10 00 00       	call   8010a2 <sys_getenvid>
  80004a:	89 45 ec             	mov    %eax,-0x14(%ebp)
//	cprintf("envID = %d\n",envID);

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800050:	89 d0                	mov    %edx,%eax
  800052:	c1 e0 03             	shl    $0x3,%eax
  800055:	01 d0                	add    %edx,%eax
  800057:	01 c0                	add    %eax,%eax
  800059:	01 d0                	add    %edx,%eax
  80005b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/// testing illegal memory access
	{
		uint32 size = 4*kilo;
  80006f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800072:	c1 e0 02             	shl    $0x2,%eax
  800075:	89 45 e4             	mov    %eax,-0x1c(%ebp)


		unsigned char *x = (unsigned char *)0x80000000;
  800078:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)

		int i=0;
  80007f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  800086:	eb 0e                	jmp    800096 <_main+0x5e>
		{
			x[i]=-1;
  800088:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80008b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80008e:	01 d0                	add    %edx,%eax
  800090:	c6 00 ff             	movb   $0xff,(%eax)


		unsigned char *x = (unsigned char *)0x80000000;

		int i=0;
		for(;i< size+20;i++)
  800093:	ff 45 f4             	incl   -0xc(%ebp)
  800096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800099:	8d 50 14             	lea    0x14(%eax),%edx
  80009c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80009f:	39 c2                	cmp    %eax,%edx
  8000a1:	77 e5                	ja     800088 <_main+0x50>
		{
			x[i]=-1;
		}

		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for new stack pages\n");
  8000a3:	83 ec 04             	sub    $0x4,%esp
  8000a6:	68 00 18 80 00       	push   $0x801800
  8000ab:	6a 1f                	push   $0x1f
  8000ad:	68 09 19 80 00       	push   $0x801909
  8000b2:	e8 c1 00 00 00       	call   800178 <_panic>

008000b7 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c1:	7e 0a                	jle    8000cd <libmain+0x16>
		binaryname = argv[0];
  8000c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c6:	8b 00                	mov    (%eax),%eax
  8000c8:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000cd:	83 ec 08             	sub    $0x8,%esp
  8000d0:	ff 75 0c             	pushl  0xc(%ebp)
  8000d3:	ff 75 08             	pushl  0x8(%ebp)
  8000d6:	e8 5d ff ff ff       	call   800038 <_main>
  8000db:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000de:	e8 bf 0f 00 00       	call   8010a2 <sys_getenvid>
  8000e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8000e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000e9:	89 d0                	mov    %edx,%eax
  8000eb:	c1 e0 03             	shl    $0x3,%eax
  8000ee:	01 d0                	add    %edx,%eax
  8000f0:	01 c0                	add    %eax,%eax
  8000f2:	01 d0                	add    %edx,%eax
  8000f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000fb:	01 d0                	add    %edx,%eax
  8000fd:	c1 e0 03             	shl    $0x3,%eax
  800100:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800105:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800108:	e8 e3 10 00 00       	call   8011f0 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	68 3c 19 80 00       	push   $0x80193c
  800115:	e8 89 01 00 00       	call   8002a3 <cprintf>
  80011a:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80011d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800120:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800126:	83 ec 08             	sub    $0x8,%esp
  800129:	50                   	push   %eax
  80012a:	68 64 19 80 00       	push   $0x801964
  80012f:	e8 6f 01 00 00       	call   8002a3 <cprintf>
  800134:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 3c 19 80 00       	push   $0x80193c
  80013f:	e8 5f 01 00 00       	call   8002a3 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800147:	e8 be 10 00 00       	call   80120a <sys_enable_interrupt>

	// exit gracefully
	exit();
  80014c:	e8 19 00 00 00       	call   80016a <exit>
}
  800151:	90                   	nop
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	6a 00                	push   $0x0
  80015f:	e8 23 0f 00 00       	call   801087 <sys_env_destroy>
  800164:	83 c4 10             	add    $0x10,%esp
}
  800167:	90                   	nop
  800168:	c9                   	leave  
  800169:	c3                   	ret    

0080016a <exit>:

void
exit(void)
{
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800170:	e8 46 0f 00 00       	call   8010bb <sys_env_exit>
}
  800175:	90                   	nop
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80017e:	8d 45 10             	lea    0x10(%ebp),%eax
  800181:	83 c0 04             	add    $0x4,%eax
  800184:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800187:	a1 10 20 80 00       	mov    0x802010,%eax
  80018c:	85 c0                	test   %eax,%eax
  80018e:	74 16                	je     8001a6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800190:	a1 10 20 80 00       	mov    0x802010,%eax
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	50                   	push   %eax
  800199:	68 7d 19 80 00       	push   $0x80197d
  80019e:	e8 00 01 00 00       	call   8002a3 <cprintf>
  8001a3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001a6:	a1 00 20 80 00       	mov    0x802000,%eax
  8001ab:	ff 75 0c             	pushl  0xc(%ebp)
  8001ae:	ff 75 08             	pushl  0x8(%ebp)
  8001b1:	50                   	push   %eax
  8001b2:	68 82 19 80 00       	push   $0x801982
  8001b7:	e8 e7 00 00 00       	call   8002a3 <cprintf>
  8001bc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8001c8:	50                   	push   %eax
  8001c9:	e8 7a 00 00 00       	call   800248 <vcprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	68 9e 19 80 00       	push   $0x80199e
  8001d9:	e8 c5 00 00 00       	call   8002a3 <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8001e1:	e8 84 ff ff ff       	call   80016a <exit>

	// should not return here
	while (1) ;
  8001e6:	eb fe                	jmp    8001e6 <_panic+0x6e>

008001e8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f1:	8b 00                	mov    (%eax),%eax
  8001f3:	8d 48 01             	lea    0x1(%eax),%ecx
  8001f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f9:	89 0a                	mov    %ecx,(%edx)
  8001fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fe:	88 d1                	mov    %dl,%cl
  800200:	8b 55 0c             	mov    0xc(%ebp),%edx
  800203:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800211:	75 23                	jne    800236 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800213:	8b 45 0c             	mov    0xc(%ebp),%eax
  800216:	8b 00                	mov    (%eax),%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021d:	83 c0 08             	add    $0x8,%eax
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	52                   	push   %edx
  800224:	50                   	push   %eax
  800225:	e8 27 0e 00 00       	call   801051 <sys_cputs>
  80022a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80022d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800230:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800236:	8b 45 0c             	mov    0xc(%ebp),%eax
  800239:	8b 40 04             	mov    0x4(%eax),%eax
  80023c:	8d 50 01             	lea    0x1(%eax),%edx
  80023f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800242:	89 50 04             	mov    %edx,0x4(%eax)
}
  800245:	90                   	nop
  800246:	c9                   	leave  
  800247:	c3                   	ret    

00800248 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800251:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800258:	00 00 00 
	b.cnt = 0;
  80025b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800262:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800265:	ff 75 0c             	pushl  0xc(%ebp)
  800268:	ff 75 08             	pushl  0x8(%ebp)
  80026b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800271:	50                   	push   %eax
  800272:	68 e8 01 80 00       	push   $0x8001e8
  800277:	e8 fa 01 00 00       	call   800476 <vprintfmt>
  80027c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80027f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	50                   	push   %eax
  800289:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028f:	83 c0 08             	add    $0x8,%eax
  800292:	50                   	push   %eax
  800293:	e8 b9 0d 00 00       	call   801051 <sys_cputs>
  800298:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80029b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002a1:	c9                   	leave  
  8002a2:	c3                   	ret    

008002a3 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002af:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	e8 8a ff ff ff       	call   800248 <vcprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002cf:	e8 1c 0f 00 00       	call   8011f0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002da:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e3:	50                   	push   %eax
  8002e4:	e8 5f ff ff ff       	call   800248 <vcprintf>
  8002e9:	83 c4 10             	add    $0x10,%esp
  8002ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002ef:	e8 16 0f 00 00       	call   80120a <sys_enable_interrupt>
	return cnt;
  8002f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	53                   	push   %ebx
  8002fd:	83 ec 14             	sub    $0x14,%esp
  800300:	8b 45 10             	mov    0x10(%ebp),%eax
  800303:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800306:	8b 45 14             	mov    0x14(%ebp),%eax
  800309:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80030c:	8b 45 18             	mov    0x18(%ebp),%eax
  80030f:	ba 00 00 00 00       	mov    $0x0,%edx
  800314:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800317:	77 55                	ja     80036e <printnum+0x75>
  800319:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80031c:	72 05                	jb     800323 <printnum+0x2a>
  80031e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800321:	77 4b                	ja     80036e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800323:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800326:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800329:	8b 45 18             	mov    0x18(%ebp),%eax
  80032c:	ba 00 00 00 00       	mov    $0x0,%edx
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	ff 75 f4             	pushl  -0xc(%ebp)
  800336:	ff 75 f0             	pushl  -0x10(%ebp)
  800339:	e8 4e 12 00 00       	call   80158c <__udivdi3>
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	ff 75 20             	pushl  0x20(%ebp)
  800347:	53                   	push   %ebx
  800348:	ff 75 18             	pushl  0x18(%ebp)
  80034b:	52                   	push   %edx
  80034c:	50                   	push   %eax
  80034d:	ff 75 0c             	pushl  0xc(%ebp)
  800350:	ff 75 08             	pushl  0x8(%ebp)
  800353:	e8 a1 ff ff ff       	call   8002f9 <printnum>
  800358:	83 c4 20             	add    $0x20,%esp
  80035b:	eb 1a                	jmp    800377 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	ff 75 0c             	pushl  0xc(%ebp)
  800363:	ff 75 20             	pushl  0x20(%ebp)
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	ff d0                	call   *%eax
  80036b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80036e:	ff 4d 1c             	decl   0x1c(%ebp)
  800371:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800375:	7f e6                	jg     80035d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800377:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80037a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80037f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800385:	53                   	push   %ebx
  800386:	51                   	push   %ecx
  800387:	52                   	push   %edx
  800388:	50                   	push   %eax
  800389:	e8 0e 13 00 00       	call   80169c <__umoddi3>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	05 b4 1b 80 00       	add    $0x801bb4,%eax
  800396:	8a 00                	mov    (%eax),%al
  800398:	0f be c0             	movsbl %al,%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	ff 75 0c             	pushl  0xc(%ebp)
  8003a1:	50                   	push   %eax
  8003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a5:	ff d0                	call   *%eax
  8003a7:	83 c4 10             	add    $0x10,%esp
}
  8003aa:	90                   	nop
  8003ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ae:	c9                   	leave  
  8003af:	c3                   	ret    

008003b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003b7:	7e 1c                	jle    8003d5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	8d 50 08             	lea    0x8(%eax),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	89 10                	mov    %edx,(%eax)
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	83 e8 08             	sub    $0x8,%eax
  8003ce:	8b 50 04             	mov    0x4(%eax),%edx
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	eb 40                	jmp    800415 <getuint+0x65>
	else if (lflag)
  8003d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003d9:	74 1e                	je     8003f9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003db:	8b 45 08             	mov    0x8(%ebp),%eax
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	8d 50 04             	lea    0x4(%eax),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	89 10                	mov    %edx,(%eax)
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	83 e8 04             	sub    $0x4,%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f7:	eb 1c                	jmp    800415 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	8d 50 04             	lea    0x4(%eax),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	89 10                	mov    %edx,(%eax)
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	83 e8 04             	sub    $0x4,%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800415:	5d                   	pop    %ebp
  800416:	c3                   	ret    

00800417 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80041a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80041e:	7e 1c                	jle    80043c <getint+0x25>
		return va_arg(*ap, long long);
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	8b 00                	mov    (%eax),%eax
  800425:	8d 50 08             	lea    0x8(%eax),%edx
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	89 10                	mov    %edx,(%eax)
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	83 e8 08             	sub    $0x8,%eax
  800435:	8b 50 04             	mov    0x4(%eax),%edx
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	eb 38                	jmp    800474 <getint+0x5d>
	else if (lflag)
  80043c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800440:	74 1a                	je     80045c <getint+0x45>
		return va_arg(*ap, long);
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	8b 00                	mov    (%eax),%eax
  800447:	8d 50 04             	lea    0x4(%eax),%edx
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	89 10                	mov    %edx,(%eax)
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	83 e8 04             	sub    $0x4,%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	eb 18                	jmp    800474 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	8d 50 04             	lea    0x4(%eax),%edx
  800464:	8b 45 08             	mov    0x8(%ebp),%eax
  800467:	89 10                	mov    %edx,(%eax)
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	83 e8 04             	sub    $0x4,%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	99                   	cltd   
}
  800474:	5d                   	pop    %ebp
  800475:	c3                   	ret    

00800476 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	56                   	push   %esi
  80047a:	53                   	push   %ebx
  80047b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80047e:	eb 17                	jmp    800497 <vprintfmt+0x21>
			if (ch == '\0')
  800480:	85 db                	test   %ebx,%ebx
  800482:	0f 84 af 03 00 00    	je     800837 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800488:	83 ec 08             	sub    $0x8,%esp
  80048b:	ff 75 0c             	pushl  0xc(%ebp)
  80048e:	53                   	push   %ebx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	ff d0                	call   *%eax
  800494:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800497:	8b 45 10             	mov    0x10(%ebp),%eax
  80049a:	8d 50 01             	lea    0x1(%eax),%edx
  80049d:	89 55 10             	mov    %edx,0x10(%ebp)
  8004a0:	8a 00                	mov    (%eax),%al
  8004a2:	0f b6 d8             	movzbl %al,%ebx
  8004a5:	83 fb 25             	cmp    $0x25,%ebx
  8004a8:	75 d6                	jne    800480 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cd:	8d 50 01             	lea    0x1(%eax),%edx
  8004d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8004d3:	8a 00                	mov    (%eax),%al
  8004d5:	0f b6 d8             	movzbl %al,%ebx
  8004d8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004db:	83 f8 55             	cmp    $0x55,%eax
  8004de:	0f 87 2b 03 00 00    	ja     80080f <vprintfmt+0x399>
  8004e4:	8b 04 85 d8 1b 80 00 	mov    0x801bd8(,%eax,4),%eax
  8004eb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004ed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004f1:	eb d7                	jmp    8004ca <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004f3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004f7:	eb d1                	jmp    8004ca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800500:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800503:	89 d0                	mov    %edx,%eax
  800505:	c1 e0 02             	shl    $0x2,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	01 c0                	add    %eax,%eax
  80050c:	01 d8                	add    %ebx,%eax
  80050e:	83 e8 30             	sub    $0x30,%eax
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800514:	8b 45 10             	mov    0x10(%ebp),%eax
  800517:	8a 00                	mov    (%eax),%al
  800519:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80051c:	83 fb 2f             	cmp    $0x2f,%ebx
  80051f:	7e 3e                	jle    80055f <vprintfmt+0xe9>
  800521:	83 fb 39             	cmp    $0x39,%ebx
  800524:	7f 39                	jg     80055f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800526:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800529:	eb d5                	jmp    800500 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	83 c0 04             	add    $0x4,%eax
  800531:	89 45 14             	mov    %eax,0x14(%ebp)
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	83 e8 04             	sub    $0x4,%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80053f:	eb 1f                	jmp    800560 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800541:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800545:	79 83                	jns    8004ca <vprintfmt+0x54>
				width = 0;
  800547:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80054e:	e9 77 ff ff ff       	jmp    8004ca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800553:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80055a:	e9 6b ff ff ff       	jmp    8004ca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80055f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800560:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800564:	0f 89 60 ff ff ff    	jns    8004ca <vprintfmt+0x54>
				width = precision, precision = -1;
  80056a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800570:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800577:	e9 4e ff ff ff       	jmp    8004ca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80057c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80057f:	e9 46 ff ff ff       	jmp    8004ca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	83 c0 04             	add    $0x4,%eax
  80058a:	89 45 14             	mov    %eax,0x14(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	83 e8 04             	sub    $0x4,%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	ff 75 0c             	pushl  0xc(%ebp)
  80059b:	50                   	push   %eax
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	ff d0                	call   *%eax
  8005a1:	83 c4 10             	add    $0x10,%esp
			break;
  8005a4:	e9 89 02 00 00       	jmp    800832 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	83 c0 04             	add    $0x4,%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	83 e8 04             	sub    $0x4,%eax
  8005b8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005ba:	85 db                	test   %ebx,%ebx
  8005bc:	79 02                	jns    8005c0 <vprintfmt+0x14a>
				err = -err;
  8005be:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005c0:	83 fb 64             	cmp    $0x64,%ebx
  8005c3:	7f 0b                	jg     8005d0 <vprintfmt+0x15a>
  8005c5:	8b 34 9d 20 1a 80 00 	mov    0x801a20(,%ebx,4),%esi
  8005cc:	85 f6                	test   %esi,%esi
  8005ce:	75 19                	jne    8005e9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005d0:	53                   	push   %ebx
  8005d1:	68 c5 1b 80 00       	push   $0x801bc5
  8005d6:	ff 75 0c             	pushl  0xc(%ebp)
  8005d9:	ff 75 08             	pushl  0x8(%ebp)
  8005dc:	e8 5e 02 00 00       	call   80083f <printfmt>
  8005e1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005e4:	e9 49 02 00 00       	jmp    800832 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005e9:	56                   	push   %esi
  8005ea:	68 ce 1b 80 00       	push   $0x801bce
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 08             	pushl  0x8(%ebp)
  8005f5:	e8 45 02 00 00       	call   80083f <printfmt>
  8005fa:	83 c4 10             	add    $0x10,%esp
			break;
  8005fd:	e9 30 02 00 00       	jmp    800832 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	83 c0 04             	add    $0x4,%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 e8 04             	sub    $0x4,%eax
  800611:	8b 30                	mov    (%eax),%esi
  800613:	85 f6                	test   %esi,%esi
  800615:	75 05                	jne    80061c <vprintfmt+0x1a6>
				p = "(null)";
  800617:	be d1 1b 80 00       	mov    $0x801bd1,%esi
			if (width > 0 && padc != '-')
  80061c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800620:	7e 6d                	jle    80068f <vprintfmt+0x219>
  800622:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800626:	74 67                	je     80068f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800628:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	50                   	push   %eax
  80062f:	56                   	push   %esi
  800630:	e8 0c 03 00 00       	call   800941 <strnlen>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80063b:	eb 16                	jmp    800653 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80063d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	50                   	push   %eax
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800650:	ff 4d e4             	decl   -0x1c(%ebp)
  800653:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800657:	7f e4                	jg     80063d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800659:	eb 34                	jmp    80068f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80065b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80065f:	74 1c                	je     80067d <vprintfmt+0x207>
  800661:	83 fb 1f             	cmp    $0x1f,%ebx
  800664:	7e 05                	jle    80066b <vprintfmt+0x1f5>
  800666:	83 fb 7e             	cmp    $0x7e,%ebx
  800669:	7e 12                	jle    80067d <vprintfmt+0x207>
					putch('?', putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 0c             	pushl  0xc(%ebp)
  800671:	6a 3f                	push   $0x3f
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	ff d0                	call   *%eax
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	eb 0f                	jmp    80068c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	53                   	push   %ebx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	ff d0                	call   *%eax
  800689:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068c:	ff 4d e4             	decl   -0x1c(%ebp)
  80068f:	89 f0                	mov    %esi,%eax
  800691:	8d 70 01             	lea    0x1(%eax),%esi
  800694:	8a 00                	mov    (%eax),%al
  800696:	0f be d8             	movsbl %al,%ebx
  800699:	85 db                	test   %ebx,%ebx
  80069b:	74 24                	je     8006c1 <vprintfmt+0x24b>
  80069d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a1:	78 b8                	js     80065b <vprintfmt+0x1e5>
  8006a3:	ff 4d e0             	decl   -0x20(%ebp)
  8006a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006aa:	79 af                	jns    80065b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ac:	eb 13                	jmp    8006c1 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	ff 75 0c             	pushl  0xc(%ebp)
  8006b4:	6a 20                	push   $0x20
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	ff d0                	call   *%eax
  8006bb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006be:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c5:	7f e7                	jg     8006ae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006c7:	e9 66 01 00 00       	jmp    800832 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8006d2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d5:	50                   	push   %eax
  8006d6:	e8 3c fd ff ff       	call   800417 <getint>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ea:	85 d2                	test   %edx,%edx
  8006ec:	79 23                	jns    800711 <vprintfmt+0x29b>
				putch('-', putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	ff 75 0c             	pushl  0xc(%ebp)
  8006f4:	6a 2d                	push   $0x2d
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	ff d0                	call   *%eax
  8006fb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800704:	f7 d8                	neg    %eax
  800706:	83 d2 00             	adc    $0x0,%edx
  800709:	f7 da                	neg    %edx
  80070b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800711:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800718:	e9 bc 00 00 00       	jmp    8007d9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 e8             	pushl  -0x18(%ebp)
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
  800726:	50                   	push   %eax
  800727:	e8 84 fc ff ff       	call   8003b0 <getuint>
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800732:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800735:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80073c:	e9 98 00 00 00       	jmp    8007d9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	6a 58                	push   $0x58
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	ff d0                	call   *%eax
  80074e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	ff 75 0c             	pushl  0xc(%ebp)
  800757:	6a 58                	push   $0x58
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	6a 58                	push   $0x58
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	ff d0                	call   *%eax
  80076e:	83 c4 10             	add    $0x10,%esp
			break;
  800771:	e9 bc 00 00 00       	jmp    800832 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	6a 30                	push   $0x30
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	ff d0                	call   *%eax
  800783:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	ff 75 0c             	pushl  0xc(%ebp)
  80078c:	6a 78                	push   $0x78
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	ff d0                	call   *%eax
  800793:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	83 c0 04             	add    $0x4,%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	83 e8 04             	sub    $0x4,%eax
  8007a5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007b8:	eb 1f                	jmp    8007d9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c3:	50                   	push   %eax
  8007c4:	e8 e7 fb ff ff       	call   8003b0 <getuint>
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007d2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007d9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e0:	83 ec 04             	sub    $0x4,%esp
  8007e3:	52                   	push   %edx
  8007e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007e7:	50                   	push   %eax
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 00 fb ff ff       	call   8002f9 <printnum>
  8007f9:	83 c4 20             	add    $0x20,%esp
			break;
  8007fc:	eb 34                	jmp    800832 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	53                   	push   %ebx
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			break;
  80080d:	eb 23                	jmp    800832 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	ff 75 0c             	pushl  0xc(%ebp)
  800815:	6a 25                	push   $0x25
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80081f:	ff 4d 10             	decl   0x10(%ebp)
  800822:	eb 03                	jmp    800827 <vprintfmt+0x3b1>
  800824:	ff 4d 10             	decl   0x10(%ebp)
  800827:	8b 45 10             	mov    0x10(%ebp),%eax
  80082a:	48                   	dec    %eax
  80082b:	8a 00                	mov    (%eax),%al
  80082d:	3c 25                	cmp    $0x25,%al
  80082f:	75 f3                	jne    800824 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800831:	90                   	nop
		}
	}
  800832:	e9 47 fc ff ff       	jmp    80047e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800837:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800838:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80083b:	5b                   	pop    %ebx
  80083c:	5e                   	pop    %esi
  80083d:	5d                   	pop    %ebp
  80083e:	c3                   	ret    

0080083f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800845:	8d 45 10             	lea    0x10(%ebp),%eax
  800848:	83 c0 04             	add    $0x4,%eax
  80084b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80084e:	8b 45 10             	mov    0x10(%ebp),%eax
  800851:	ff 75 f4             	pushl  -0xc(%ebp)
  800854:	50                   	push   %eax
  800855:	ff 75 0c             	pushl  0xc(%ebp)
  800858:	ff 75 08             	pushl  0x8(%ebp)
  80085b:	e8 16 fc ff ff       	call   800476 <vprintfmt>
  800860:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800863:	90                   	nop
  800864:	c9                   	leave  
  800865:	c3                   	ret    

00800866 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086c:	8b 40 08             	mov    0x8(%eax),%eax
  80086f:	8d 50 01             	lea    0x1(%eax),%edx
  800872:	8b 45 0c             	mov    0xc(%ebp),%eax
  800875:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087b:	8b 10                	mov    (%eax),%edx
  80087d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800880:	8b 40 04             	mov    0x4(%eax),%eax
  800883:	39 c2                	cmp    %eax,%edx
  800885:	73 12                	jae    800899 <sprintputch+0x33>
		*b->buf++ = ch;
  800887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	8d 48 01             	lea    0x1(%eax),%ecx
  80088f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800892:	89 0a                	mov    %ecx,(%edx)
  800894:	8b 55 08             	mov    0x8(%ebp),%edx
  800897:	88 10                	mov    %dl,(%eax)
}
  800899:	90                   	nop
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    

0080089c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	01 d0                	add    %edx,%eax
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008c1:	74 06                	je     8008c9 <vsnprintf+0x2d>
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	7f 07                	jg     8008d0 <vsnprintf+0x34>
		return -E_INVAL;
  8008c9:	b8 03 00 00 00       	mov    $0x3,%eax
  8008ce:	eb 20                	jmp    8008f0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d0:	ff 75 14             	pushl  0x14(%ebp)
  8008d3:	ff 75 10             	pushl  0x10(%ebp)
  8008d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d9:	50                   	push   %eax
  8008da:	68 66 08 80 00       	push   $0x800866
  8008df:	e8 92 fb ff ff       	call   800476 <vprintfmt>
  8008e4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    

008008f2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fb:	83 c0 04             	add    $0x4,%eax
  8008fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800901:	8b 45 10             	mov    0x10(%ebp),%eax
  800904:	ff 75 f4             	pushl  -0xc(%ebp)
  800907:	50                   	push   %eax
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	ff 75 08             	pushl  0x8(%ebp)
  80090e:	e8 89 ff ff ff       	call   80089c <vsnprintf>
  800913:	83 c4 10             	add    $0x10,%esp
  800916:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800919:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    

0080091e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80092b:	eb 06                	jmp    800933 <strlen+0x15>
		n++;
  80092d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800930:	ff 45 08             	incl   0x8(%ebp)
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8a 00                	mov    (%eax),%al
  800938:	84 c0                	test   %al,%al
  80093a:	75 f1                	jne    80092d <strlen+0xf>
		n++;
	return n;
  80093c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80093f:	c9                   	leave  
  800940:	c3                   	ret    

00800941 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800947:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80094e:	eb 09                	jmp    800959 <strnlen+0x18>
		n++;
  800950:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800953:	ff 45 08             	incl   0x8(%ebp)
  800956:	ff 4d 0c             	decl   0xc(%ebp)
  800959:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095d:	74 09                	je     800968 <strnlen+0x27>
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8a 00                	mov    (%eax),%al
  800964:	84 c0                	test   %al,%al
  800966:	75 e8                	jne    800950 <strnlen+0xf>
		n++;
	return n;
  800968:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800979:	90                   	nop
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8d 50 01             	lea    0x1(%eax),%edx
  800980:	89 55 08             	mov    %edx,0x8(%ebp)
  800983:	8b 55 0c             	mov    0xc(%ebp),%edx
  800986:	8d 4a 01             	lea    0x1(%edx),%ecx
  800989:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80098c:	8a 12                	mov    (%edx),%dl
  80098e:	88 10                	mov    %dl,(%eax)
  800990:	8a 00                	mov    (%eax),%al
  800992:	84 c0                	test   %al,%al
  800994:	75 e4                	jne    80097a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800996:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800999:	c9                   	leave  
  80099a:	c3                   	ret    

0080099b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ae:	eb 1f                	jmp    8009cf <strncpy+0x34>
		*dst++ = *src;
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8d 50 01             	lea    0x1(%eax),%edx
  8009b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	8a 12                	mov    (%edx),%dl
  8009be:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	8a 00                	mov    (%eax),%al
  8009c5:	84 c0                	test   %al,%al
  8009c7:	74 03                	je     8009cc <strncpy+0x31>
			src++;
  8009c9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009cc:	ff 45 fc             	incl   -0x4(%ebp)
  8009cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009d5:	72 d9                	jb     8009b0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009ec:	74 30                	je     800a1e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009ee:	eb 16                	jmp    800a06 <strlcpy+0x2a>
			*dst++ = *src++;
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	8d 50 01             	lea    0x1(%eax),%edx
  8009f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a02:	8a 12                	mov    (%edx),%dl
  800a04:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a06:	ff 4d 10             	decl   0x10(%ebp)
  800a09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a0d:	74 09                	je     800a18 <strlcpy+0x3c>
  800a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a12:	8a 00                	mov    (%eax),%al
  800a14:	84 c0                	test   %al,%al
  800a16:	75 d8                	jne    8009f0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a24:	29 c2                	sub    %eax,%edx
  800a26:	89 d0                	mov    %edx,%eax
}
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a2d:	eb 06                	jmp    800a35 <strcmp+0xb>
		p++, q++;
  800a2f:	ff 45 08             	incl   0x8(%ebp)
  800a32:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8a 00                	mov    (%eax),%al
  800a3a:	84 c0                	test   %al,%al
  800a3c:	74 0e                	je     800a4c <strcmp+0x22>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 10                	mov    (%eax),%dl
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	8a 00                	mov    (%eax),%al
  800a48:	38 c2                	cmp    %al,%dl
  800a4a:	74 e3                	je     800a2f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8a 00                	mov    (%eax),%al
  800a51:	0f b6 d0             	movzbl %al,%edx
  800a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a57:	8a 00                	mov    (%eax),%al
  800a59:	0f b6 c0             	movzbl %al,%eax
  800a5c:	29 c2                	sub    %eax,%edx
  800a5e:	89 d0                	mov    %edx,%eax
}
  800a60:	5d                   	pop    %ebp
  800a61:	c3                   	ret    

00800a62 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a65:	eb 09                	jmp    800a70 <strncmp+0xe>
		n--, p++, q++;
  800a67:	ff 4d 10             	decl   0x10(%ebp)
  800a6a:	ff 45 08             	incl   0x8(%ebp)
  800a6d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a74:	74 17                	je     800a8d <strncmp+0x2b>
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	84 c0                	test   %al,%al
  800a7d:	74 0e                	je     800a8d <strncmp+0x2b>
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8a 10                	mov    (%eax),%dl
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	8a 00                	mov    (%eax),%al
  800a89:	38 c2                	cmp    %al,%dl
  800a8b:	74 da                	je     800a67 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a91:	75 07                	jne    800a9a <strncmp+0x38>
		return 0;
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
  800a98:	eb 14                	jmp    800aae <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8a 00                	mov    (%eax),%al
  800a9f:	0f b6 d0             	movzbl %al,%edx
  800aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa5:	8a 00                	mov    (%eax),%al
  800aa7:	0f b6 c0             	movzbl %al,%eax
  800aaa:	29 c2                	sub    %eax,%edx
  800aac:	89 d0                	mov    %edx,%eax
}
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800abc:	eb 12                	jmp    800ad0 <strchr+0x20>
		if (*s == c)
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8a 00                	mov    (%eax),%al
  800ac3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ac6:	75 05                	jne    800acd <strchr+0x1d>
			return (char *) s;
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	eb 11                	jmp    800ade <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800acd:	ff 45 08             	incl   0x8(%ebp)
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	84 c0                	test   %al,%al
  800ad7:	75 e5                	jne    800abe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 04             	sub    $0x4,%esp
  800ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aec:	eb 0d                	jmp    800afb <strfind+0x1b>
		if (*s == c)
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800af6:	74 0e                	je     800b06 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800af8:	ff 45 08             	incl   0x8(%ebp)
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8a 00                	mov    (%eax),%al
  800b00:	84 c0                	test   %al,%al
  800b02:	75 ea                	jne    800aee <strfind+0xe>
  800b04:	eb 01                	jmp    800b07 <strfind+0x27>
		if (*s == c)
			break;
  800b06:	90                   	nop
	return (char *) s;
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b0a:	c9                   	leave  
  800b0b:	c3                   	ret    

00800b0c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b18:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b1e:	eb 0e                	jmp    800b2e <memset+0x22>
		*p++ = c;
  800b20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b23:	8d 50 01             	lea    0x1(%eax),%edx
  800b26:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b2e:	ff 4d f8             	decl   -0x8(%ebp)
  800b31:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b35:	79 e9                	jns    800b20 <memset+0x14>
		*p++ = c;

	return v;
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b4e:	eb 16                	jmp    800b66 <memcpy+0x2a>
		*d++ = *s++;
  800b50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b53:	8d 50 01             	lea    0x1(%eax),%edx
  800b56:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b62:	8a 12                	mov    (%edx),%dl
  800b64:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b66:	8b 45 10             	mov    0x10(%ebp),%eax
  800b69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b6c:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6f:	85 c0                	test   %eax,%eax
  800b71:	75 dd                	jne    800b50 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    

00800b78 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b90:	73 50                	jae    800be2 <memmove+0x6a>
  800b92:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	01 d0                	add    %edx,%eax
  800b9a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b9d:	76 43                	jbe    800be2 <memmove+0x6a>
		s += n;
  800b9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bab:	eb 10                	jmp    800bbd <memmove+0x45>
			*--d = *--s;
  800bad:	ff 4d f8             	decl   -0x8(%ebp)
  800bb0:	ff 4d fc             	decl   -0x4(%ebp)
  800bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb6:	8a 10                	mov    (%eax),%dl
  800bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bbb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc6:	85 c0                	test   %eax,%eax
  800bc8:	75 e3                	jne    800bad <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bca:	eb 23                	jmp    800bef <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bcf:	8d 50 01             	lea    0x1(%eax),%edx
  800bd2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bd5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bd8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bdb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bde:	8a 12                	mov    (%edx),%dl
  800be0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800be2:	8b 45 10             	mov    0x10(%ebp),%eax
  800be5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be8:	89 55 10             	mov    %edx,0x10(%ebp)
  800beb:	85 c0                	test   %eax,%eax
  800bed:	75 dd                	jne    800bcc <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c03:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c06:	eb 2a                	jmp    800c32 <memcmp+0x3e>
		if (*s1 != *s2)
  800c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0b:	8a 10                	mov    (%eax),%dl
  800c0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	38 c2                	cmp    %al,%dl
  800c14:	74 16                	je     800c2c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	0f b6 d0             	movzbl %al,%edx
  800c1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	0f b6 c0             	movzbl %al,%eax
  800c26:	29 c2                	sub    %eax,%edx
  800c28:	89 d0                	mov    %edx,%eax
  800c2a:	eb 18                	jmp    800c44 <memcmp+0x50>
		s1++, s2++;
  800c2c:	ff 45 fc             	incl   -0x4(%ebp)
  800c2f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c32:	8b 45 10             	mov    0x10(%ebp),%eax
  800c35:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c38:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3b:	85 c0                	test   %eax,%eax
  800c3d:	75 c9                	jne    800c08 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c57:	eb 15                	jmp    800c6e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8a 00                	mov    (%eax),%al
  800c5e:	0f b6 d0             	movzbl %al,%edx
  800c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c64:	0f b6 c0             	movzbl %al,%eax
  800c67:	39 c2                	cmp    %eax,%edx
  800c69:	74 0d                	je     800c78 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c6b:	ff 45 08             	incl   0x8(%ebp)
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c74:	72 e3                	jb     800c59 <memfind+0x13>
  800c76:	eb 01                	jmp    800c79 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c78:	90                   	nop
	return (void *) s;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c8b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c92:	eb 03                	jmp    800c97 <strtol+0x19>
		s++;
  800c94:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	3c 20                	cmp    $0x20,%al
  800c9e:	74 f4                	je     800c94 <strtol+0x16>
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8a 00                	mov    (%eax),%al
  800ca5:	3c 09                	cmp    $0x9,%al
  800ca7:	74 eb                	je     800c94 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	3c 2b                	cmp    $0x2b,%al
  800cb0:	75 05                	jne    800cb7 <strtol+0x39>
		s++;
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	eb 13                	jmp    800cca <strtol+0x4c>
	else if (*s == '-')
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	3c 2d                	cmp    $0x2d,%al
  800cbe:	75 0a                	jne    800cca <strtol+0x4c>
		s++, neg = 1;
  800cc0:	ff 45 08             	incl   0x8(%ebp)
  800cc3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cce:	74 06                	je     800cd6 <strtol+0x58>
  800cd0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cd4:	75 20                	jne    800cf6 <strtol+0x78>
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	3c 30                	cmp    $0x30,%al
  800cdd:	75 17                	jne    800cf6 <strtol+0x78>
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	40                   	inc    %eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	3c 78                	cmp    $0x78,%al
  800ce7:	75 0d                	jne    800cf6 <strtol+0x78>
		s += 2, base = 16;
  800ce9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ced:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cf4:	eb 28                	jmp    800d1e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cf6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfa:	75 15                	jne    800d11 <strtol+0x93>
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	3c 30                	cmp    $0x30,%al
  800d03:	75 0c                	jne    800d11 <strtol+0x93>
		s++, base = 8;
  800d05:	ff 45 08             	incl   0x8(%ebp)
  800d08:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d0f:	eb 0d                	jmp    800d1e <strtol+0xa0>
	else if (base == 0)
  800d11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d15:	75 07                	jne    800d1e <strtol+0xa0>
		base = 10;
  800d17:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	3c 2f                	cmp    $0x2f,%al
  800d25:	7e 19                	jle    800d40 <strtol+0xc2>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	3c 39                	cmp    $0x39,%al
  800d2e:	7f 10                	jg     800d40 <strtol+0xc2>
			dig = *s - '0';
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	0f be c0             	movsbl %al,%eax
  800d38:	83 e8 30             	sub    $0x30,%eax
  800d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d3e:	eb 42                	jmp    800d82 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	3c 60                	cmp    $0x60,%al
  800d47:	7e 19                	jle    800d62 <strtol+0xe4>
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	3c 7a                	cmp    $0x7a,%al
  800d50:	7f 10                	jg     800d62 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f be c0             	movsbl %al,%eax
  800d5a:	83 e8 57             	sub    $0x57,%eax
  800d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d60:	eb 20                	jmp    800d82 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	3c 40                	cmp    $0x40,%al
  800d69:	7e 39                	jle    800da4 <strtol+0x126>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	3c 5a                	cmp    $0x5a,%al
  800d72:	7f 30                	jg     800da4 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	0f be c0             	movsbl %al,%eax
  800d7c:	83 e8 37             	sub    $0x37,%eax
  800d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d85:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d88:	7d 19                	jge    800da3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d8a:	ff 45 08             	incl   0x8(%ebp)
  800d8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d90:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d94:	89 c2                	mov    %eax,%edx
  800d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d9e:	e9 7b ff ff ff       	jmp    800d1e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800da3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800da4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da8:	74 08                	je     800db2 <strtol+0x134>
		*endptr = (char *) s;
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800db2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800db6:	74 07                	je     800dbf <strtol+0x141>
  800db8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbb:	f7 d8                	neg    %eax
  800dbd:	eb 03                	jmp    800dc2 <strtol+0x144>
  800dbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc2:	c9                   	leave  
  800dc3:	c3                   	ret    

00800dc4 <ltostr>:

void
ltostr(long value, char *str)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dd1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ddc:	79 13                	jns    800df1 <ltostr+0x2d>
	{
		neg = 1;
  800dde:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800deb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dee:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800df9:	99                   	cltd   
  800dfa:	f7 f9                	idiv   %ecx
  800dfc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e02:	8d 50 01             	lea    0x1(%eax),%edx
  800e05:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e08:	89 c2                	mov    %eax,%edx
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	01 d0                	add    %edx,%eax
  800e0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e12:	83 c2 30             	add    $0x30,%edx
  800e15:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e1f:	f7 e9                	imul   %ecx
  800e21:	c1 fa 02             	sar    $0x2,%edx
  800e24:	89 c8                	mov    %ecx,%eax
  800e26:	c1 f8 1f             	sar    $0x1f,%eax
  800e29:	29 c2                	sub    %eax,%edx
  800e2b:	89 d0                	mov    %edx,%eax
  800e2d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e33:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e38:	f7 e9                	imul   %ecx
  800e3a:	c1 fa 02             	sar    $0x2,%edx
  800e3d:	89 c8                	mov    %ecx,%eax
  800e3f:	c1 f8 1f             	sar    $0x1f,%eax
  800e42:	29 c2                	sub    %eax,%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	c1 e0 02             	shl    $0x2,%eax
  800e49:	01 d0                	add    %edx,%eax
  800e4b:	01 c0                	add    %eax,%eax
  800e4d:	29 c1                	sub    %eax,%ecx
  800e4f:	89 ca                	mov    %ecx,%edx
  800e51:	85 d2                	test   %edx,%edx
  800e53:	75 9c                	jne    800df1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5f:	48                   	dec    %eax
  800e60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e63:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e67:	74 3d                	je     800ea6 <ltostr+0xe2>
		start = 1 ;
  800e69:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e70:	eb 34                	jmp    800ea6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	01 c2                	add    %eax,%edx
  800e87:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	01 c8                	add    %ecx,%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e99:	01 c2                	add    %eax,%edx
  800e9b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e9e:	88 02                	mov    %al,(%edx)
		start++ ;
  800ea0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ea3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eac:	7c c4                	jl     800e72 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800eae:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb4:	01 d0                	add    %edx,%eax
  800eb6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800eb9:	90                   	nop
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ec2:	ff 75 08             	pushl  0x8(%ebp)
  800ec5:	e8 54 fa ff ff       	call   80091e <strlen>
  800eca:	83 c4 04             	add    $0x4,%esp
  800ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ed0:	ff 75 0c             	pushl  0xc(%ebp)
  800ed3:	e8 46 fa ff ff       	call   80091e <strlen>
  800ed8:	83 c4 04             	add    $0x4,%esp
  800edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ede:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ee5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eec:	eb 17                	jmp    800f05 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef4:	01 c2                	add    %eax,%edx
  800ef6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	01 c8                	add    %ecx,%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f02:	ff 45 fc             	incl   -0x4(%ebp)
  800f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f0b:	7c e1                	jl     800eee <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f0d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f1b:	eb 1f                	jmp    800f3c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f20:	8d 50 01             	lea    0x1(%eax),%edx
  800f23:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f26:	89 c2                	mov    %eax,%edx
  800f28:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2b:	01 c2                	add    %eax,%edx
  800f2d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	01 c8                	add    %ecx,%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f39:	ff 45 f8             	incl   -0x8(%ebp)
  800f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f42:	7c d9                	jl     800f1d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 d0                	add    %edx,%eax
  800f4c:	c6 00 00             	movb   $0x0,(%eax)
}
  800f4f:	90                   	nop
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    

00800f52 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f55:	8b 45 14             	mov    0x14(%ebp),%eax
  800f58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f61:	8b 00                	mov    (%eax),%eax
  800f63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6d:	01 d0                	add    %edx,%eax
  800f6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f75:	eb 0c                	jmp    800f83 <strsplit+0x31>
			*string++ = 0;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f80:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	84 c0                	test   %al,%al
  800f8a:	74 18                	je     800fa4 <strsplit+0x52>
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	0f be c0             	movsbl %al,%eax
  800f94:	50                   	push   %eax
  800f95:	ff 75 0c             	pushl  0xc(%ebp)
  800f98:	e8 13 fb ff ff       	call   800ab0 <strchr>
  800f9d:	83 c4 08             	add    $0x8,%esp
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 d3                	jne    800f77 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	84 c0                	test   %al,%al
  800fab:	74 5a                	je     801007 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  800fad:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb0:	8b 00                	mov    (%eax),%eax
  800fb2:	83 f8 0f             	cmp    $0xf,%eax
  800fb5:	75 07                	jne    800fbe <strsplit+0x6c>
		{
			return 0;
  800fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbc:	eb 66                	jmp    801024 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc1:	8b 00                	mov    (%eax),%eax
  800fc3:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc6:	8b 55 14             	mov    0x14(%ebp),%edx
  800fc9:	89 0a                	mov    %ecx,(%edx)
  800fcb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	01 c2                	add    %eax,%edx
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fdc:	eb 03                	jmp    800fe1 <strsplit+0x8f>
			string++;
  800fde:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	84 c0                	test   %al,%al
  800fe8:	74 8b                	je     800f75 <strsplit+0x23>
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	0f be c0             	movsbl %al,%eax
  800ff2:	50                   	push   %eax
  800ff3:	ff 75 0c             	pushl  0xc(%ebp)
  800ff6:	e8 b5 fa ff ff       	call   800ab0 <strchr>
  800ffb:	83 c4 08             	add    $0x8,%esp
  800ffe:	85 c0                	test   %eax,%eax
  801000:	74 dc                	je     800fde <strsplit+0x8c>
			string++;
	}
  801002:	e9 6e ff ff ff       	jmp    800f75 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801007:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801008:	8b 45 14             	mov    0x14(%ebp),%eax
  80100b:	8b 00                	mov    (%eax),%eax
  80100d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801014:	8b 45 10             	mov    0x10(%ebp),%eax
  801017:	01 d0                	add    %edx,%eax
  801019:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80101f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	57                   	push   %edi
  80102a:	56                   	push   %esi
  80102b:	53                   	push   %ebx
  80102c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8b 55 0c             	mov    0xc(%ebp),%edx
  801035:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801038:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80103b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80103e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801041:	cd 30                	int    $0x30
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801046:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5f                   	pop    %edi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    

00801051 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	6a 00                	push   $0x0
  801059:	6a 00                	push   $0x0
  80105b:	6a 00                	push   $0x0
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	50                   	push   %eax
  801061:	6a 00                	push   $0x0
  801063:	e8 be ff ff ff       	call   801026 <syscall>
  801068:	83 c4 18             	add    $0x18,%esp
}
  80106b:	90                   	nop
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <sys_cgetc>:

int
sys_cgetc(void)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801071:	6a 00                	push   $0x0
  801073:	6a 00                	push   $0x0
  801075:	6a 00                	push   $0x0
  801077:	6a 00                	push   $0x0
  801079:	6a 00                	push   $0x0
  80107b:	6a 01                	push   $0x1
  80107d:	e8 a4 ff ff ff       	call   801026 <syscall>
  801082:	83 c4 18             	add    $0x18,%esp
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	6a 00                	push   $0x0
  80108f:	6a 00                	push   $0x0
  801091:	6a 00                	push   $0x0
  801093:	6a 00                	push   $0x0
  801095:	50                   	push   %eax
  801096:	6a 03                	push   $0x3
  801098:	e8 89 ff ff ff       	call   801026 <syscall>
  80109d:	83 c4 18             	add    $0x18,%esp
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8010a5:	6a 00                	push   $0x0
  8010a7:	6a 00                	push   $0x0
  8010a9:	6a 00                	push   $0x0
  8010ab:	6a 00                	push   $0x0
  8010ad:	6a 00                	push   $0x0
  8010af:	6a 02                	push   $0x2
  8010b1:	e8 70 ff ff ff       	call   801026 <syscall>
  8010b6:	83 c4 18             	add    $0x18,%esp
}
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <sys_env_exit>:

void sys_env_exit(void)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8010be:	6a 00                	push   $0x0
  8010c0:	6a 00                	push   $0x0
  8010c2:	6a 00                	push   $0x0
  8010c4:	6a 00                	push   $0x0
  8010c6:	6a 00                	push   $0x0
  8010c8:	6a 04                	push   $0x4
  8010ca:	e8 57 ff ff ff       	call   801026 <syscall>
  8010cf:	83 c4 18             	add    $0x18,%esp
}
  8010d2:	90                   	nop
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	6a 00                	push   $0x0
  8010e0:	6a 00                	push   $0x0
  8010e2:	6a 00                	push   $0x0
  8010e4:	52                   	push   %edx
  8010e5:	50                   	push   %eax
  8010e6:	6a 05                	push   $0x5
  8010e8:	e8 39 ff ff ff       	call   801026 <syscall>
  8010ed:	83 c4 18             	add    $0x18,%esp
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	56                   	push   %esi
  8010f6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010f7:	8b 75 18             	mov    0x18(%ebp),%esi
  8010fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801100:	8b 55 0c             	mov    0xc(%ebp),%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	56                   	push   %esi
  801107:	53                   	push   %ebx
  801108:	51                   	push   %ecx
  801109:	52                   	push   %edx
  80110a:	50                   	push   %eax
  80110b:	6a 06                	push   $0x6
  80110d:	e8 14 ff ff ff       	call   801026 <syscall>
  801112:	83 c4 18             	add    $0x18,%esp
}
  801115:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801118:	5b                   	pop    %ebx
  801119:	5e                   	pop    %esi
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80111f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	6a 00                	push   $0x0
  801127:	6a 00                	push   $0x0
  801129:	6a 00                	push   $0x0
  80112b:	52                   	push   %edx
  80112c:	50                   	push   %eax
  80112d:	6a 07                	push   $0x7
  80112f:	e8 f2 fe ff ff       	call   801026 <syscall>
  801134:	83 c4 18             	add    $0x18,%esp
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80113c:	6a 00                	push   $0x0
  80113e:	6a 00                	push   $0x0
  801140:	6a 00                	push   $0x0
  801142:	ff 75 0c             	pushl  0xc(%ebp)
  801145:	ff 75 08             	pushl  0x8(%ebp)
  801148:	6a 08                	push   $0x8
  80114a:	e8 d7 fe ff ff       	call   801026 <syscall>
  80114f:	83 c4 18             	add    $0x18,%esp
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    

00801154 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801157:	6a 00                	push   $0x0
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	6a 00                	push   $0x0
  80115f:	6a 00                	push   $0x0
  801161:	6a 09                	push   $0x9
  801163:	e8 be fe ff ff       	call   801026 <syscall>
  801168:	83 c4 18             	add    $0x18,%esp
}
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    

0080116d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 00                	push   $0x0
  801178:	6a 00                	push   $0x0
  80117a:	6a 0a                	push   $0xa
  80117c:	e8 a5 fe ff ff       	call   801026 <syscall>
  801181:	83 c4 18             	add    $0x18,%esp
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	6a 00                	push   $0x0
  801191:	6a 00                	push   $0x0
  801193:	6a 0b                	push   $0xb
  801195:	e8 8c fe ff ff       	call   801026 <syscall>
  80119a:	83 c4 18             	add    $0x18,%esp
}
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	6a 0d                	push   $0xd
  8011b0:	e8 71 fe ff ff       	call   801026 <syscall>
  8011b5:	83 c4 18             	add    $0x18,%esp
	return;
  8011b8:	90                   	nop
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	ff 75 0c             	pushl  0xc(%ebp)
  8011c7:	ff 75 08             	pushl  0x8(%ebp)
  8011ca:	6a 0e                	push   $0xe
  8011cc:	e8 55 fe ff ff       	call   801026 <syscall>
  8011d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8011d4:	90                   	nop
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 0c                	push   $0xc
  8011e6:	e8 3b fe ff ff       	call   801026 <syscall>
  8011eb:	83 c4 18             	add    $0x18,%esp
}
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 10                	push   $0x10
  8011ff:	e8 22 fe ff ff       	call   801026 <syscall>
  801204:	83 c4 18             	add    $0x18,%esp
}
  801207:	90                   	nop
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 00                	push   $0x0
  801213:	6a 00                	push   $0x0
  801215:	6a 00                	push   $0x0
  801217:	6a 11                	push   $0x11
  801219:	e8 08 fe ff ff       	call   801026 <syscall>
  80121e:	83 c4 18             	add    $0x18,%esp
}
  801221:	90                   	nop
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <sys_cputc>:


void
sys_cputc(const char c)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801230:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	50                   	push   %eax
  80123d:	6a 12                	push   $0x12
  80123f:	e8 e2 fd ff ff       	call   801026 <syscall>
  801244:	83 c4 18             	add    $0x18,%esp
}
  801247:	90                   	nop
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	6a 13                	push   $0x13
  801259:	e8 c8 fd ff ff       	call   801026 <syscall>
  80125e:	83 c4 18             	add    $0x18,%esp
}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	ff 75 0c             	pushl  0xc(%ebp)
  801273:	50                   	push   %eax
  801274:	6a 14                	push   $0x14
  801276:	e8 ab fd ff ff       	call   801026 <syscall>
  80127b:	83 c4 18             	add    $0x18,%esp
}
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	50                   	push   %eax
  80128f:	6a 17                	push   $0x17
  801291:	e8 90 fd ff ff       	call   801026 <syscall>
  801296:	83 c4 18             	add    $0x18,%esp
}
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

0080129b <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	50                   	push   %eax
  8012aa:	6a 15                	push   $0x15
  8012ac:	e8 75 fd ff ff       	call   801026 <syscall>
  8012b1:	83 c4 18             	add    $0x18,%esp
}
  8012b4:	90                   	nop
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	50                   	push   %eax
  8012c6:	6a 16                	push   $0x16
  8012c8:	e8 59 fd ff ff       	call   801026 <syscall>
  8012cd:	83 c4 18             	add    $0x18,%esp
}
  8012d0:	90                   	nop
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    

008012d3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	83 ec 04             	sub    $0x4,%esp
  8012d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8012df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	6a 00                	push   $0x0
  8012eb:	51                   	push   %ecx
  8012ec:	52                   	push   %edx
  8012ed:	ff 75 0c             	pushl  0xc(%ebp)
  8012f0:	50                   	push   %eax
  8012f1:	6a 18                	push   $0x18
  8012f3:	e8 2e fd ff ff       	call   801026 <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801300:	8b 55 0c             	mov    0xc(%ebp),%edx
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	52                   	push   %edx
  80130d:	50                   	push   %eax
  80130e:	6a 19                	push   $0x19
  801310:	e8 11 fd ff ff       	call   801026 <syscall>
  801315:	83 c4 18             	add    $0x18,%esp
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	50                   	push   %eax
  801329:	6a 1a                	push   $0x1a
  80132b:	e8 f6 fc ff ff       	call   801026 <syscall>
  801330:	83 c4 18             	add    $0x18,%esp
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 1b                	push   $0x1b
  801344:	e8 dd fc ff ff       	call   801026 <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 1c                	push   $0x1c
  80135d:	e8 c4 fc ff ff       	call   801026 <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	50                   	push   %eax
  801377:	6a 1d                	push   $0x1d
  801379:	e8 a8 fc ff ff       	call   801026 <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	50                   	push   %eax
  801392:	6a 1e                	push   $0x1e
  801394:	e8 8d fc ff ff       	call   801026 <syscall>
  801399:	83 c4 18             	add    $0x18,%esp
}
  80139c:	90                   	nop
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	50                   	push   %eax
  8013ae:	6a 1f                	push   $0x1f
  8013b0:	e8 71 fc ff ff       	call   801026 <syscall>
  8013b5:	83 c4 18             	add    $0x18,%esp
}
  8013b8:	90                   	nop
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8013c1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013c4:	8d 50 04             	lea    0x4(%eax),%edx
  8013c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	52                   	push   %edx
  8013d1:	50                   	push   %eax
  8013d2:	6a 20                	push   $0x20
  8013d4:	e8 4d fc ff ff       	call   801026 <syscall>
  8013d9:	83 c4 18             	add    $0x18,%esp
	return result;
  8013dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e5:	89 01                	mov    %eax,(%ecx)
  8013e7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	c9                   	leave  
  8013ee:	c2 04 00             	ret    $0x4

008013f1 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	ff 75 10             	pushl  0x10(%ebp)
  8013fb:	ff 75 0c             	pushl  0xc(%ebp)
  8013fe:	ff 75 08             	pushl  0x8(%ebp)
  801401:	6a 0f                	push   $0xf
  801403:	e8 1e fc ff ff       	call   801026 <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
	return ;
  80140b:	90                   	nop
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <sys_rcr2>:
uint32 sys_rcr2()
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 21                	push   $0x21
  80141d:	e8 04 fc ff ff       	call   801026 <syscall>
  801422:	83 c4 18             	add    $0x18,%esp
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801433:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	50                   	push   %eax
  801440:	6a 22                	push   $0x22
  801442:	e8 df fb ff ff       	call   801026 <syscall>
  801447:	83 c4 18             	add    $0x18,%esp
	return ;
  80144a:	90                   	nop
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <rsttst>:
void rsttst()
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 24                	push   $0x24
  80145c:	e8 c5 fb ff ff       	call   801026 <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
	return ;
  801464:	90                   	nop
}
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	83 ec 04             	sub    $0x4,%esp
  80146d:	8b 45 14             	mov    0x14(%ebp),%eax
  801470:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801473:	8b 55 18             	mov    0x18(%ebp),%edx
  801476:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80147a:	52                   	push   %edx
  80147b:	50                   	push   %eax
  80147c:	ff 75 10             	pushl  0x10(%ebp)
  80147f:	ff 75 0c             	pushl  0xc(%ebp)
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	6a 23                	push   $0x23
  801487:	e8 9a fb ff ff       	call   801026 <syscall>
  80148c:	83 c4 18             	add    $0x18,%esp
	return ;
  80148f:	90                   	nop
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <chktst>:
void chktst(uint32 n)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	ff 75 08             	pushl  0x8(%ebp)
  8014a0:	6a 25                	push   $0x25
  8014a2:	e8 7f fb ff ff       	call   801026 <syscall>
  8014a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8014aa:	90                   	nop
}
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 26                	push   $0x26
  8014bf:	e8 62 fb ff ff       	call   801026 <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
  8014c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014ca:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014ce:	75 07                	jne    8014d7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8014d5:	eb 05                	jmp    8014dc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 26                	push   $0x26
  8014f0:	e8 31 fb ff ff       	call   801026 <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
  8014f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014fb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014ff:	75 07                	jne    801508 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801501:	b8 01 00 00 00       	mov    $0x1,%eax
  801506:	eb 05                	jmp    80150d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 26                	push   $0x26
  801521:	e8 00 fb ff ff       	call   801026 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
  801529:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80152c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801530:	75 07                	jne    801539 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801532:	b8 01 00 00 00       	mov    $0x1,%eax
  801537:	eb 05                	jmp    80153e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 26                	push   $0x26
  801552:	e8 cf fa ff ff       	call   801026 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
  80155a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80155d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801561:	75 07                	jne    80156a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801563:	b8 01 00 00 00       	mov    $0x1,%eax
  801568:	eb 05                	jmp    80156f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80156a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	ff 75 08             	pushl  0x8(%ebp)
  80157f:	6a 27                	push   $0x27
  801581:	e8 a0 fa ff ff       	call   801026 <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
	return ;
  801589:	90                   	nop
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <__udivdi3>:
  80158c:	55                   	push   %ebp
  80158d:	57                   	push   %edi
  80158e:	56                   	push   %esi
  80158f:	53                   	push   %ebx
  801590:	83 ec 1c             	sub    $0x1c,%esp
  801593:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801597:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80159b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80159f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015a3:	89 ca                	mov    %ecx,%edx
  8015a5:	89 f8                	mov    %edi,%eax
  8015a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8015ab:	85 f6                	test   %esi,%esi
  8015ad:	75 2d                	jne    8015dc <__udivdi3+0x50>
  8015af:	39 cf                	cmp    %ecx,%edi
  8015b1:	77 65                	ja     801618 <__udivdi3+0x8c>
  8015b3:	89 fd                	mov    %edi,%ebp
  8015b5:	85 ff                	test   %edi,%edi
  8015b7:	75 0b                	jne    8015c4 <__udivdi3+0x38>
  8015b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8015be:	31 d2                	xor    %edx,%edx
  8015c0:	f7 f7                	div    %edi
  8015c2:	89 c5                	mov    %eax,%ebp
  8015c4:	31 d2                	xor    %edx,%edx
  8015c6:	89 c8                	mov    %ecx,%eax
  8015c8:	f7 f5                	div    %ebp
  8015ca:	89 c1                	mov    %eax,%ecx
  8015cc:	89 d8                	mov    %ebx,%eax
  8015ce:	f7 f5                	div    %ebp
  8015d0:	89 cf                	mov    %ecx,%edi
  8015d2:	89 fa                	mov    %edi,%edx
  8015d4:	83 c4 1c             	add    $0x1c,%esp
  8015d7:	5b                   	pop    %ebx
  8015d8:	5e                   	pop    %esi
  8015d9:	5f                   	pop    %edi
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    
  8015dc:	39 ce                	cmp    %ecx,%esi
  8015de:	77 28                	ja     801608 <__udivdi3+0x7c>
  8015e0:	0f bd fe             	bsr    %esi,%edi
  8015e3:	83 f7 1f             	xor    $0x1f,%edi
  8015e6:	75 40                	jne    801628 <__udivdi3+0x9c>
  8015e8:	39 ce                	cmp    %ecx,%esi
  8015ea:	72 0a                	jb     8015f6 <__udivdi3+0x6a>
  8015ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8015f0:	0f 87 9e 00 00 00    	ja     801694 <__udivdi3+0x108>
  8015f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015fb:	89 fa                	mov    %edi,%edx
  8015fd:	83 c4 1c             	add    $0x1c,%esp
  801600:	5b                   	pop    %ebx
  801601:	5e                   	pop    %esi
  801602:	5f                   	pop    %edi
  801603:	5d                   	pop    %ebp
  801604:	c3                   	ret    
  801605:	8d 76 00             	lea    0x0(%esi),%esi
  801608:	31 ff                	xor    %edi,%edi
  80160a:	31 c0                	xor    %eax,%eax
  80160c:	89 fa                	mov    %edi,%edx
  80160e:	83 c4 1c             	add    $0x1c,%esp
  801611:	5b                   	pop    %ebx
  801612:	5e                   	pop    %esi
  801613:	5f                   	pop    %edi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    
  801616:	66 90                	xchg   %ax,%ax
  801618:	89 d8                	mov    %ebx,%eax
  80161a:	f7 f7                	div    %edi
  80161c:	31 ff                	xor    %edi,%edi
  80161e:	89 fa                	mov    %edi,%edx
  801620:	83 c4 1c             	add    $0x1c,%esp
  801623:	5b                   	pop    %ebx
  801624:	5e                   	pop    %esi
  801625:	5f                   	pop    %edi
  801626:	5d                   	pop    %ebp
  801627:	c3                   	ret    
  801628:	bd 20 00 00 00       	mov    $0x20,%ebp
  80162d:	89 eb                	mov    %ebp,%ebx
  80162f:	29 fb                	sub    %edi,%ebx
  801631:	89 f9                	mov    %edi,%ecx
  801633:	d3 e6                	shl    %cl,%esi
  801635:	89 c5                	mov    %eax,%ebp
  801637:	88 d9                	mov    %bl,%cl
  801639:	d3 ed                	shr    %cl,%ebp
  80163b:	89 e9                	mov    %ebp,%ecx
  80163d:	09 f1                	or     %esi,%ecx
  80163f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801643:	89 f9                	mov    %edi,%ecx
  801645:	d3 e0                	shl    %cl,%eax
  801647:	89 c5                	mov    %eax,%ebp
  801649:	89 d6                	mov    %edx,%esi
  80164b:	88 d9                	mov    %bl,%cl
  80164d:	d3 ee                	shr    %cl,%esi
  80164f:	89 f9                	mov    %edi,%ecx
  801651:	d3 e2                	shl    %cl,%edx
  801653:	8b 44 24 08          	mov    0x8(%esp),%eax
  801657:	88 d9                	mov    %bl,%cl
  801659:	d3 e8                	shr    %cl,%eax
  80165b:	09 c2                	or     %eax,%edx
  80165d:	89 d0                	mov    %edx,%eax
  80165f:	89 f2                	mov    %esi,%edx
  801661:	f7 74 24 0c          	divl   0xc(%esp)
  801665:	89 d6                	mov    %edx,%esi
  801667:	89 c3                	mov    %eax,%ebx
  801669:	f7 e5                	mul    %ebp
  80166b:	39 d6                	cmp    %edx,%esi
  80166d:	72 19                	jb     801688 <__udivdi3+0xfc>
  80166f:	74 0b                	je     80167c <__udivdi3+0xf0>
  801671:	89 d8                	mov    %ebx,%eax
  801673:	31 ff                	xor    %edi,%edi
  801675:	e9 58 ff ff ff       	jmp    8015d2 <__udivdi3+0x46>
  80167a:	66 90                	xchg   %ax,%ax
  80167c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801680:	89 f9                	mov    %edi,%ecx
  801682:	d3 e2                	shl    %cl,%edx
  801684:	39 c2                	cmp    %eax,%edx
  801686:	73 e9                	jae    801671 <__udivdi3+0xe5>
  801688:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80168b:	31 ff                	xor    %edi,%edi
  80168d:	e9 40 ff ff ff       	jmp    8015d2 <__udivdi3+0x46>
  801692:	66 90                	xchg   %ax,%ax
  801694:	31 c0                	xor    %eax,%eax
  801696:	e9 37 ff ff ff       	jmp    8015d2 <__udivdi3+0x46>
  80169b:	90                   	nop

0080169c <__umoddi3>:
  80169c:	55                   	push   %ebp
  80169d:	57                   	push   %edi
  80169e:	56                   	push   %esi
  80169f:	53                   	push   %ebx
  8016a0:	83 ec 1c             	sub    $0x1c,%esp
  8016a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8016a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8016ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8016af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8016b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016bb:	89 f3                	mov    %esi,%ebx
  8016bd:	89 fa                	mov    %edi,%edx
  8016bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016c3:	89 34 24             	mov    %esi,(%esp)
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	75 1a                	jne    8016e4 <__umoddi3+0x48>
  8016ca:	39 f7                	cmp    %esi,%edi
  8016cc:	0f 86 a2 00 00 00    	jbe    801774 <__umoddi3+0xd8>
  8016d2:	89 c8                	mov    %ecx,%eax
  8016d4:	89 f2                	mov    %esi,%edx
  8016d6:	f7 f7                	div    %edi
  8016d8:	89 d0                	mov    %edx,%eax
  8016da:	31 d2                	xor    %edx,%edx
  8016dc:	83 c4 1c             	add    $0x1c,%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	5f                   	pop    %edi
  8016e2:	5d                   	pop    %ebp
  8016e3:	c3                   	ret    
  8016e4:	39 f0                	cmp    %esi,%eax
  8016e6:	0f 87 ac 00 00 00    	ja     801798 <__umoddi3+0xfc>
  8016ec:	0f bd e8             	bsr    %eax,%ebp
  8016ef:	83 f5 1f             	xor    $0x1f,%ebp
  8016f2:	0f 84 ac 00 00 00    	je     8017a4 <__umoddi3+0x108>
  8016f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8016fd:	29 ef                	sub    %ebp,%edi
  8016ff:	89 fe                	mov    %edi,%esi
  801701:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801705:	89 e9                	mov    %ebp,%ecx
  801707:	d3 e0                	shl    %cl,%eax
  801709:	89 d7                	mov    %edx,%edi
  80170b:	89 f1                	mov    %esi,%ecx
  80170d:	d3 ef                	shr    %cl,%edi
  80170f:	09 c7                	or     %eax,%edi
  801711:	89 e9                	mov    %ebp,%ecx
  801713:	d3 e2                	shl    %cl,%edx
  801715:	89 14 24             	mov    %edx,(%esp)
  801718:	89 d8                	mov    %ebx,%eax
  80171a:	d3 e0                	shl    %cl,%eax
  80171c:	89 c2                	mov    %eax,%edx
  80171e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801722:	d3 e0                	shl    %cl,%eax
  801724:	89 44 24 04          	mov    %eax,0x4(%esp)
  801728:	8b 44 24 08          	mov    0x8(%esp),%eax
  80172c:	89 f1                	mov    %esi,%ecx
  80172e:	d3 e8                	shr    %cl,%eax
  801730:	09 d0                	or     %edx,%eax
  801732:	d3 eb                	shr    %cl,%ebx
  801734:	89 da                	mov    %ebx,%edx
  801736:	f7 f7                	div    %edi
  801738:	89 d3                	mov    %edx,%ebx
  80173a:	f7 24 24             	mull   (%esp)
  80173d:	89 c6                	mov    %eax,%esi
  80173f:	89 d1                	mov    %edx,%ecx
  801741:	39 d3                	cmp    %edx,%ebx
  801743:	0f 82 87 00 00 00    	jb     8017d0 <__umoddi3+0x134>
  801749:	0f 84 91 00 00 00    	je     8017e0 <__umoddi3+0x144>
  80174f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801753:	29 f2                	sub    %esi,%edx
  801755:	19 cb                	sbb    %ecx,%ebx
  801757:	89 d8                	mov    %ebx,%eax
  801759:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80175d:	d3 e0                	shl    %cl,%eax
  80175f:	89 e9                	mov    %ebp,%ecx
  801761:	d3 ea                	shr    %cl,%edx
  801763:	09 d0                	or     %edx,%eax
  801765:	89 e9                	mov    %ebp,%ecx
  801767:	d3 eb                	shr    %cl,%ebx
  801769:	89 da                	mov    %ebx,%edx
  80176b:	83 c4 1c             	add    $0x1c,%esp
  80176e:	5b                   	pop    %ebx
  80176f:	5e                   	pop    %esi
  801770:	5f                   	pop    %edi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    
  801773:	90                   	nop
  801774:	89 fd                	mov    %edi,%ebp
  801776:	85 ff                	test   %edi,%edi
  801778:	75 0b                	jne    801785 <__umoddi3+0xe9>
  80177a:	b8 01 00 00 00       	mov    $0x1,%eax
  80177f:	31 d2                	xor    %edx,%edx
  801781:	f7 f7                	div    %edi
  801783:	89 c5                	mov    %eax,%ebp
  801785:	89 f0                	mov    %esi,%eax
  801787:	31 d2                	xor    %edx,%edx
  801789:	f7 f5                	div    %ebp
  80178b:	89 c8                	mov    %ecx,%eax
  80178d:	f7 f5                	div    %ebp
  80178f:	89 d0                	mov    %edx,%eax
  801791:	e9 44 ff ff ff       	jmp    8016da <__umoddi3+0x3e>
  801796:	66 90                	xchg   %ax,%ax
  801798:	89 c8                	mov    %ecx,%eax
  80179a:	89 f2                	mov    %esi,%edx
  80179c:	83 c4 1c             	add    $0x1c,%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5f                   	pop    %edi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    
  8017a4:	3b 04 24             	cmp    (%esp),%eax
  8017a7:	72 06                	jb     8017af <__umoddi3+0x113>
  8017a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8017ad:	77 0f                	ja     8017be <__umoddi3+0x122>
  8017af:	89 f2                	mov    %esi,%edx
  8017b1:	29 f9                	sub    %edi,%ecx
  8017b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8017b7:	89 14 24             	mov    %edx,(%esp)
  8017ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8017c2:	8b 14 24             	mov    (%esp),%edx
  8017c5:	83 c4 1c             	add    $0x1c,%esp
  8017c8:	5b                   	pop    %ebx
  8017c9:	5e                   	pop    %esi
  8017ca:	5f                   	pop    %edi
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    
  8017cd:	8d 76 00             	lea    0x0(%esi),%esi
  8017d0:	2b 04 24             	sub    (%esp),%eax
  8017d3:	19 fa                	sbb    %edi,%edx
  8017d5:	89 d1                	mov    %edx,%ecx
  8017d7:	89 c6                	mov    %eax,%esi
  8017d9:	e9 71 ff ff ff       	jmp    80174f <__umoddi3+0xb3>
  8017de:	66 90                	xchg   %ax,%ax
  8017e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8017e4:	72 ea                	jb     8017d0 <__umoddi3+0x134>
  8017e6:	89 d9                	mov    %ebx,%ecx
  8017e8:	e9 62 ff ff ff       	jmp    80174f <__umoddi3+0xb3>
