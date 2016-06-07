
obj/user/tst_page_replacement_stack:     file format elf32-i386


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
  800031:	e8 23 01 00 00       	call   800159 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 a0 00 00    	sub    $0xa024,%esp
	char arr[PAGE_SIZE*10];

	uint32 kilo = 1024;
  800042:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

	int envID = sys_getenvid();
  800049:	e8 f6 10 00 00       	call   801144 <sys_getenvid>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
//	cprintf("envID = %d\n",envID);

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800051:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800054:	89 d0                	mov    %edx,%eax
  800056:	c1 e0 03             	shl    $0x3,%eax
  800059:	01 d0                	add    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800066:	01 d0                	add    %edx,%eax
  800068:	c1 e0 03             	shl    $0x3,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int freePages = sys_calculate_free_frames();
  800073:	e8 7e 11 00 00       	call   8011f6 <sys_calculate_free_frames>
  800078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80007b:	e8 f9 11 00 00       	call   801279 <sys_pf_calculate_allocated_pages>
  800080:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800083:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80008a:	eb 15                	jmp    8000a1 <_main+0x69>
		arr[i] = -1 ;
  80008c:	8d 95 e0 5f ff ff    	lea    -0xa020(%ebp),%edx
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	01 d0                	add    %edx,%eax
  800097:	c6 00 ff             	movb   $0xff,(%eax)

	int freePages = sys_calculate_free_frames();
	int usedDiskPages = sys_pf_calculate_allocated_pages();

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80009a:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000a1:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000a8:	7e e2                	jle    80008c <_main+0x54>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	68 a0 18 80 00       	push   $0x8018a0
  8000b2:	e8 8e 02 00 00       	call   800345 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c1:	eb 2c                	jmp    8000ef <_main+0xb7>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");
  8000c3:	8d 95 e0 5f ff ff    	lea    -0xa020(%ebp),%edx
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	01 d0                	add    %edx,%eax
  8000ce:	8a 00                	mov    (%eax),%al
  8000d0:	3c ff                	cmp    $0xff,%al
  8000d2:	74 14                	je     8000e8 <_main+0xb0>
  8000d4:	83 ec 04             	sub    $0x4,%esp
  8000d7:	68 d8 18 80 00       	push   $0x8018d8
  8000dc:	6a 1e                	push   $0x1e
  8000de:	68 08 19 80 00       	push   $0x801908
  8000e3:	e8 32 01 00 00       	call   80021a <_panic>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000e8:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000ef:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000f6:	7e cb                	jle    8000c3 <_main+0x8b>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  9) panic("Unexpected extra/less pages have been added to page file");
  8000f8:	e8 7c 11 00 00       	call   801279 <sys_pf_calculate_allocated_pages>
  8000fd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800100:	83 f8 09             	cmp    $0x9,%eax
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 2c 19 80 00       	push   $0x80192c
  80010d:	6a 20                	push   $0x20
  80010f:	68 08 19 80 00       	push   $0x801908
  800114:	e8 01 01 00 00       	call   80021a <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  800119:	e8 d8 10 00 00       	call   8011f6 <sys_calculate_free_frames>
  80011e:	89 c3                	mov    %eax,%ebx
  800120:	e8 ea 10 00 00       	call   80120f <sys_calculate_modified_frames>
  800125:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012b:	39 c2                	cmp    %eax,%edx
  80012d:	74 14                	je     800143 <_main+0x10b>
  80012f:	83 ec 04             	sub    $0x4,%esp
  800132:	68 68 19 80 00       	push   $0x801968
  800137:	6a 22                	push   $0x22
  800139:	68 08 19 80 00       	push   $0x801908
  80013e:	e8 d7 00 00 00       	call   80021a <_panic>
	}

	cprintf("Congratulations: stack pages created, modified and read successfully!\n\n");
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	68 cc 19 80 00       	push   $0x8019cc
  80014b:	e8 f5 01 00 00       	call   800345 <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp


	return;
  800153:	90                   	nop
}
  800154:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800163:	7e 0a                	jle    80016f <libmain+0x16>
		binaryname = argv[0];
  800165:	8b 45 0c             	mov    0xc(%ebp),%eax
  800168:	8b 00                	mov    (%eax),%eax
  80016a:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 0c             	pushl  0xc(%ebp)
  800175:	ff 75 08             	pushl  0x8(%ebp)
  800178:	e8 bb fe ff ff       	call   800038 <_main>
  80017d:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800180:	e8 bf 0f 00 00       	call   801144 <sys_getenvid>
  800185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 03             	shl    $0x3,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	01 c0                	add    %eax,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019d:	01 d0                	add    %edx,%eax
  80019f:	c1 e0 03             	shl    $0x3,%eax
  8001a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8001aa:	e8 e3 10 00 00       	call   801292 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	68 2c 1a 80 00       	push   $0x801a2c
  8001b7:	e8 89 01 00 00       	call   800345 <cprintf>
  8001bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8001bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001c2:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	50                   	push   %eax
  8001cc:	68 54 1a 80 00       	push   $0x801a54
  8001d1:	e8 6f 01 00 00       	call   800345 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	68 2c 1a 80 00       	push   $0x801a2c
  8001e1:	e8 5f 01 00 00       	call   800345 <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001e9:	e8 be 10 00 00       	call   8012ac <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001ee:	e8 19 00 00 00       	call   80020c <exit>
}
  8001f3:	90                   	nop
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	6a 00                	push   $0x0
  800201:	e8 23 0f 00 00       	call   801129 <sys_env_destroy>
  800206:	83 c4 10             	add    $0x10,%esp
}
  800209:	90                   	nop
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <exit>:

void
exit(void)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800212:	e8 46 0f 00 00       	call   80115d <sys_env_exit>
}
  800217:	90                   	nop
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800220:	8d 45 10             	lea    0x10(%ebp),%eax
  800223:	83 c0 04             	add    $0x4,%eax
  800226:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800229:	a1 10 20 80 00       	mov    0x802010,%eax
  80022e:	85 c0                	test   %eax,%eax
  800230:	74 16                	je     800248 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800232:	a1 10 20 80 00       	mov    0x802010,%eax
  800237:	83 ec 08             	sub    $0x8,%esp
  80023a:	50                   	push   %eax
  80023b:	68 6d 1a 80 00       	push   $0x801a6d
  800240:	e8 00 01 00 00       	call   800345 <cprintf>
  800245:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800248:	a1 00 20 80 00       	mov    0x802000,%eax
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	50                   	push   %eax
  800254:	68 72 1a 80 00       	push   $0x801a72
  800259:	e8 e7 00 00 00       	call   800345 <cprintf>
  80025e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800261:	8b 45 10             	mov    0x10(%ebp),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	ff 75 f4             	pushl  -0xc(%ebp)
  80026a:	50                   	push   %eax
  80026b:	e8 7a 00 00 00       	call   8002ea <vcprintf>
  800270:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	68 8e 1a 80 00       	push   $0x801a8e
  80027b:	e8 c5 00 00 00       	call   800345 <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800283:	e8 84 ff ff ff       	call   80020c <exit>

	// should not return here
	while (1) ;
  800288:	eb fe                	jmp    800288 <_panic+0x6e>

0080028a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800290:	8b 45 0c             	mov    0xc(%ebp),%eax
  800293:	8b 00                	mov    (%eax),%eax
  800295:	8d 48 01             	lea    0x1(%eax),%ecx
  800298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029b:	89 0a                	mov    %ecx,(%edx)
  80029d:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a0:	88 d1                	mov    %dl,%cl
  8002a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ac:	8b 00                	mov    (%eax),%eax
  8002ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b3:	75 23                	jne    8002d8 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8002b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b8:	8b 00                	mov    (%eax),%eax
  8002ba:	89 c2                	mov    %eax,%edx
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bf:	83 c0 08             	add    $0x8,%eax
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	52                   	push   %edx
  8002c6:	50                   	push   %eax
  8002c7:	e8 27 0e 00 00       	call   8010f3 <sys_cputs>
  8002cc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002db:	8b 40 04             	mov    0x4(%eax),%eax
  8002de:	8d 50 01             	lea    0x1(%eax),%edx
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e7:	90                   	nop
  8002e8:	c9                   	leave  
  8002e9:	c3                   	ret    

008002ea <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002fa:	00 00 00 
	b.cnt = 0;
  8002fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800304:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800307:	ff 75 0c             	pushl  0xc(%ebp)
  80030a:	ff 75 08             	pushl  0x8(%ebp)
  80030d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800313:	50                   	push   %eax
  800314:	68 8a 02 80 00       	push   $0x80028a
  800319:	e8 fa 01 00 00       	call   800518 <vprintfmt>
  80031e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800321:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	50                   	push   %eax
  80032b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800331:	83 c0 08             	add    $0x8,%eax
  800334:	50                   	push   %eax
  800335:	e8 b9 0d 00 00       	call   8010f3 <sys_cputs>
  80033a:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80033d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <cprintf>:

int cprintf(const char *fmt, ...) {
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80034e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800351:	8b 45 08             	mov    0x8(%ebp),%eax
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	ff 75 f4             	pushl  -0xc(%ebp)
  80035a:	50                   	push   %eax
  80035b:	e8 8a ff ff ff       	call   8002ea <vcprintf>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800366:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800371:	e8 1c 0f 00 00       	call   801292 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800376:	8d 45 0c             	lea    0xc(%ebp),%eax
  800379:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80037c:	8b 45 08             	mov    0x8(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	e8 5f ff ff ff       	call   8002ea <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800391:	e8 16 0f 00 00       	call   8012ac <sys_enable_interrupt>
	return cnt;
  800396:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800399:	c9                   	leave  
  80039a:	c3                   	ret    

0080039b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	53                   	push   %ebx
  80039f:	83 ec 14             	sub    $0x14,%esp
  8003a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b9:	77 55                	ja     800410 <printnum+0x75>
  8003bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003be:	72 05                	jb     8003c5 <printnum+0x2a>
  8003c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003c3:	77 4b                	ja     800410 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d3:	52                   	push   %edx
  8003d4:	50                   	push   %eax
  8003d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8003db:	e8 50 12 00 00       	call   801630 <__udivdi3>
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	ff 75 20             	pushl  0x20(%ebp)
  8003e9:	53                   	push   %ebx
  8003ea:	ff 75 18             	pushl  0x18(%ebp)
  8003ed:	52                   	push   %edx
  8003ee:	50                   	push   %eax
  8003ef:	ff 75 0c             	pushl  0xc(%ebp)
  8003f2:	ff 75 08             	pushl  0x8(%ebp)
  8003f5:	e8 a1 ff ff ff       	call   80039b <printnum>
  8003fa:	83 c4 20             	add    $0x20,%esp
  8003fd:	eb 1a                	jmp    800419 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ff:	83 ec 08             	sub    $0x8,%esp
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 20             	pushl  0x20(%ebp)
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	ff d0                	call   *%eax
  80040d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800410:	ff 4d 1c             	decl   0x1c(%ebp)
  800413:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800417:	7f e6                	jg     8003ff <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800419:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80041c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800427:	53                   	push   %ebx
  800428:	51                   	push   %ecx
  800429:	52                   	push   %edx
  80042a:	50                   	push   %eax
  80042b:	e8 10 13 00 00       	call   801740 <__umoddi3>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	05 b4 1c 80 00       	add    $0x801cb4,%eax
  800438:	8a 00                	mov    (%eax),%al
  80043a:	0f be c0             	movsbl %al,%eax
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	50                   	push   %eax
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	ff d0                	call   *%eax
  800449:	83 c4 10             	add    $0x10,%esp
}
  80044c:	90                   	nop
  80044d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800450:	c9                   	leave  
  800451:	c3                   	ret    

00800452 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800455:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800459:	7e 1c                	jle    800477 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	8d 50 08             	lea    0x8(%eax),%edx
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	89 10                	mov    %edx,(%eax)
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	83 e8 08             	sub    $0x8,%eax
  800470:	8b 50 04             	mov    0x4(%eax),%edx
  800473:	8b 00                	mov    (%eax),%eax
  800475:	eb 40                	jmp    8004b7 <getuint+0x65>
	else if (lflag)
  800477:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80047b:	74 1e                	je     80049b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	8d 50 04             	lea    0x4(%eax),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	89 10                	mov    %edx,(%eax)
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	83 e8 04             	sub    $0x4,%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	ba 00 00 00 00       	mov    $0x0,%edx
  800499:	eb 1c                	jmp    8004b7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	8d 50 04             	lea    0x4(%eax),%edx
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	89 10                	mov    %edx,(%eax)
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	83 e8 04             	sub    $0x4,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b7:	5d                   	pop    %ebp
  8004b8:	c3                   	ret    

008004b9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004c0:	7e 1c                	jle    8004de <getint+0x25>
		return va_arg(*ap, long long);
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	8d 50 08             	lea    0x8(%eax),%edx
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	89 10                	mov    %edx,(%eax)
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	83 e8 08             	sub    $0x8,%eax
  8004d7:	8b 50 04             	mov    0x4(%eax),%edx
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	eb 38                	jmp    800516 <getint+0x5d>
	else if (lflag)
  8004de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e2:	74 1a                	je     8004fe <getint+0x45>
		return va_arg(*ap, long);
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	8b 00                	mov    (%eax),%eax
  8004e9:	8d 50 04             	lea    0x4(%eax),%edx
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	89 10                	mov    %edx,(%eax)
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	83 e8 04             	sub    $0x4,%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	99                   	cltd   
  8004fc:	eb 18                	jmp    800516 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	8b 00                	mov    (%eax),%eax
  800503:	8d 50 04             	lea    0x4(%eax),%edx
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	89 10                	mov    %edx,(%eax)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	83 e8 04             	sub    $0x4,%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	99                   	cltd   
}
  800516:	5d                   	pop    %ebp
  800517:	c3                   	ret    

00800518 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800518:	55                   	push   %ebp
  800519:	89 e5                	mov    %esp,%ebp
  80051b:	56                   	push   %esi
  80051c:	53                   	push   %ebx
  80051d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800520:	eb 17                	jmp    800539 <vprintfmt+0x21>
			if (ch == '\0')
  800522:	85 db                	test   %ebx,%ebx
  800524:	0f 84 af 03 00 00    	je     8008d9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	53                   	push   %ebx
  800531:	8b 45 08             	mov    0x8(%ebp),%eax
  800534:	ff d0                	call   *%eax
  800536:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	8d 50 01             	lea    0x1(%eax),%edx
  80053f:	89 55 10             	mov    %edx,0x10(%ebp)
  800542:	8a 00                	mov    (%eax),%al
  800544:	0f b6 d8             	movzbl %al,%ebx
  800547:	83 fb 25             	cmp    $0x25,%ebx
  80054a:	75 d6                	jne    800522 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80054c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800550:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800557:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800565:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056c:	8b 45 10             	mov    0x10(%ebp),%eax
  80056f:	8d 50 01             	lea    0x1(%eax),%edx
  800572:	89 55 10             	mov    %edx,0x10(%ebp)
  800575:	8a 00                	mov    (%eax),%al
  800577:	0f b6 d8             	movzbl %al,%ebx
  80057a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80057d:	83 f8 55             	cmp    $0x55,%eax
  800580:	0f 87 2b 03 00 00    	ja     8008b1 <vprintfmt+0x399>
  800586:	8b 04 85 d8 1c 80 00 	mov    0x801cd8(,%eax,4),%eax
  80058d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80058f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800593:	eb d7                	jmp    80056c <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800595:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800599:	eb d1                	jmp    80056c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80059b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a5:	89 d0                	mov    %edx,%eax
  8005a7:	c1 e0 02             	shl    $0x2,%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	01 c0                	add    %eax,%eax
  8005ae:	01 d8                	add    %ebx,%eax
  8005b0:	83 e8 30             	sub    $0x30,%eax
  8005b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b9:	8a 00                	mov    (%eax),%al
  8005bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005be:	83 fb 2f             	cmp    $0x2f,%ebx
  8005c1:	7e 3e                	jle    800601 <vprintfmt+0xe9>
  8005c3:	83 fb 39             	cmp    $0x39,%ebx
  8005c6:	7f 39                	jg     800601 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005c8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005cb:	eb d5                	jmp    8005a2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	83 c0 04             	add    $0x4,%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	83 e8 04             	sub    $0x4,%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005e1:	eb 1f                	jmp    800602 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e7:	79 83                	jns    80056c <vprintfmt+0x54>
				width = 0;
  8005e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005f0:	e9 77 ff ff ff       	jmp    80056c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005f5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005fc:	e9 6b ff ff ff       	jmp    80056c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800601:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800602:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800606:	0f 89 60 ff ff ff    	jns    80056c <vprintfmt+0x54>
				width = precision, precision = -1;
  80060c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800619:	e9 4e ff ff ff       	jmp    80056c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80061e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800621:	e9 46 ff ff ff       	jmp    80056c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	83 c0 04             	add    $0x4,%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	83 e8 04             	sub    $0x4,%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	ff 75 0c             	pushl  0xc(%ebp)
  80063d:	50                   	push   %eax
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	ff d0                	call   *%eax
  800643:	83 c4 10             	add    $0x10,%esp
			break;
  800646:	e9 89 02 00 00       	jmp    8008d4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	83 c0 04             	add    $0x4,%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	83 e8 04             	sub    $0x4,%eax
  80065a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80065c:	85 db                	test   %ebx,%ebx
  80065e:	79 02                	jns    800662 <vprintfmt+0x14a>
				err = -err;
  800660:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800662:	83 fb 64             	cmp    $0x64,%ebx
  800665:	7f 0b                	jg     800672 <vprintfmt+0x15a>
  800667:	8b 34 9d 20 1b 80 00 	mov    0x801b20(,%ebx,4),%esi
  80066e:	85 f6                	test   %esi,%esi
  800670:	75 19                	jne    80068b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800672:	53                   	push   %ebx
  800673:	68 c5 1c 80 00       	push   $0x801cc5
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	ff 75 08             	pushl  0x8(%ebp)
  80067e:	e8 5e 02 00 00       	call   8008e1 <printfmt>
  800683:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800686:	e9 49 02 00 00       	jmp    8008d4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80068b:	56                   	push   %esi
  80068c:	68 ce 1c 80 00       	push   $0x801cce
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	ff 75 08             	pushl  0x8(%ebp)
  800697:	e8 45 02 00 00       	call   8008e1 <printfmt>
  80069c:	83 c4 10             	add    $0x10,%esp
			break;
  80069f:	e9 30 02 00 00       	jmp    8008d4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	83 c0 04             	add    $0x4,%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	83 e8 04             	sub    $0x4,%eax
  8006b3:	8b 30                	mov    (%eax),%esi
  8006b5:	85 f6                	test   %esi,%esi
  8006b7:	75 05                	jne    8006be <vprintfmt+0x1a6>
				p = "(null)";
  8006b9:	be d1 1c 80 00       	mov    $0x801cd1,%esi
			if (width > 0 && padc != '-')
  8006be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c2:	7e 6d                	jle    800731 <vprintfmt+0x219>
  8006c4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006c8:	74 67                	je     800731 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	50                   	push   %eax
  8006d1:	56                   	push   %esi
  8006d2:	e8 0c 03 00 00       	call   8009e3 <strnlen>
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006dd:	eb 16                	jmp    8006f5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006df:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	50                   	push   %eax
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	ff d0                	call   *%eax
  8006ef:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f9:	7f e4                	jg     8006df <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006fb:	eb 34                	jmp    800731 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800701:	74 1c                	je     80071f <vprintfmt+0x207>
  800703:	83 fb 1f             	cmp    $0x1f,%ebx
  800706:	7e 05                	jle    80070d <vprintfmt+0x1f5>
  800708:	83 fb 7e             	cmp    $0x7e,%ebx
  80070b:	7e 12                	jle    80071f <vprintfmt+0x207>
					putch('?', putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	ff 75 0c             	pushl  0xc(%ebp)
  800713:	6a 3f                	push   $0x3f
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	ff d0                	call   *%eax
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	eb 0f                	jmp    80072e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80072e:	ff 4d e4             	decl   -0x1c(%ebp)
  800731:	89 f0                	mov    %esi,%eax
  800733:	8d 70 01             	lea    0x1(%eax),%esi
  800736:	8a 00                	mov    (%eax),%al
  800738:	0f be d8             	movsbl %al,%ebx
  80073b:	85 db                	test   %ebx,%ebx
  80073d:	74 24                	je     800763 <vprintfmt+0x24b>
  80073f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800743:	78 b8                	js     8006fd <vprintfmt+0x1e5>
  800745:	ff 4d e0             	decl   -0x20(%ebp)
  800748:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074c:	79 af                	jns    8006fd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074e:	eb 13                	jmp    800763 <vprintfmt+0x24b>
				putch(' ', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	6a 20                	push   $0x20
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	ff d0                	call   *%eax
  80075d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800760:	ff 4d e4             	decl   -0x1c(%ebp)
  800763:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800767:	7f e7                	jg     800750 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800769:	e9 66 01 00 00       	jmp    8008d4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 e8             	pushl  -0x18(%ebp)
  800774:	8d 45 14             	lea    0x14(%ebp),%eax
  800777:	50                   	push   %eax
  800778:	e8 3c fd ff ff       	call   8004b9 <getint>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800783:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078c:	85 d2                	test   %edx,%edx
  80078e:	79 23                	jns    8007b3 <vprintfmt+0x29b>
				putch('-', putdat);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 0c             	pushl  0xc(%ebp)
  800796:	6a 2d                	push   $0x2d
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	ff d0                	call   *%eax
  80079d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a6:	f7 d8                	neg    %eax
  8007a8:	83 d2 00             	adc    $0x0,%edx
  8007ab:	f7 da                	neg    %edx
  8007ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ba:	e9 bc 00 00 00       	jmp    80087b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c8:	50                   	push   %eax
  8007c9:	e8 84 fc ff ff       	call   800452 <getuint>
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007d7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007de:	e9 98 00 00 00       	jmp    80087b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 0c             	pushl  0xc(%ebp)
  8007e9:	6a 58                	push   $0x58
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	ff d0                	call   *%eax
  8007f0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	ff 75 0c             	pushl  0xc(%ebp)
  8007f9:	6a 58                	push   $0x58
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	ff d0                	call   *%eax
  800800:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	6a 58                	push   $0x58
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	ff d0                	call   *%eax
  800810:	83 c4 10             	add    $0x10,%esp
			break;
  800813:	e9 bc 00 00 00       	jmp    8008d4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	ff 75 0c             	pushl  0xc(%ebp)
  80081e:	6a 30                	push   $0x30
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	ff d0                	call   *%eax
  800825:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	6a 78                	push   $0x78
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	ff d0                	call   *%eax
  800835:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800849:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800853:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80085a:	eb 1f                	jmp    80087b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	ff 75 e8             	pushl  -0x18(%ebp)
  800862:	8d 45 14             	lea    0x14(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	e8 e7 fb ff ff       	call   800452 <getuint>
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800871:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800874:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80087b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80087f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800882:	83 ec 04             	sub    $0x4,%esp
  800885:	52                   	push   %edx
  800886:	ff 75 e4             	pushl  -0x1c(%ebp)
  800889:	50                   	push   %eax
  80088a:	ff 75 f4             	pushl  -0xc(%ebp)
  80088d:	ff 75 f0             	pushl  -0x10(%ebp)
  800890:	ff 75 0c             	pushl  0xc(%ebp)
  800893:	ff 75 08             	pushl  0x8(%ebp)
  800896:	e8 00 fb ff ff       	call   80039b <printnum>
  80089b:	83 c4 20             	add    $0x20,%esp
			break;
  80089e:	eb 34                	jmp    8008d4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	53                   	push   %ebx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
			break;
  8008af:	eb 23                	jmp    8008d4 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	6a 25                	push   $0x25
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	ff d0                	call   *%eax
  8008be:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c1:	ff 4d 10             	decl   0x10(%ebp)
  8008c4:	eb 03                	jmp    8008c9 <vprintfmt+0x3b1>
  8008c6:	ff 4d 10             	decl   0x10(%ebp)
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	48                   	dec    %eax
  8008cd:	8a 00                	mov    (%eax),%al
  8008cf:	3c 25                	cmp    $0x25,%al
  8008d1:	75 f3                	jne    8008c6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008d3:	90                   	nop
		}
	}
  8008d4:	e9 47 fc ff ff       	jmp    800520 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008d9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008dd:	5b                   	pop    %ebx
  8008de:	5e                   	pop    %esi
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f6:	50                   	push   %eax
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	ff 75 08             	pushl  0x8(%ebp)
  8008fd:	e8 16 fc ff ff       	call   800518 <vprintfmt>
  800902:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800905:	90                   	nop
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80090b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090e:	8b 40 08             	mov    0x8(%eax),%eax
  800911:	8d 50 01             	lea    0x1(%eax),%edx
  800914:	8b 45 0c             	mov    0xc(%ebp),%eax
  800917:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80091a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091d:	8b 10                	mov    (%eax),%edx
  80091f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800922:	8b 40 04             	mov    0x4(%eax),%eax
  800925:	39 c2                	cmp    %eax,%edx
  800927:	73 12                	jae    80093b <sprintputch+0x33>
		*b->buf++ = ch;
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	8d 48 01             	lea    0x1(%eax),%ecx
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	89 0a                	mov    %ecx,(%edx)
  800936:	8b 55 08             	mov    0x8(%ebp),%edx
  800939:	88 10                	mov    %dl,(%eax)
}
  80093b:	90                   	nop
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	01 d0                	add    %edx,%eax
  800955:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800958:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80095f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800963:	74 06                	je     80096b <vsnprintf+0x2d>
  800965:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800969:	7f 07                	jg     800972 <vsnprintf+0x34>
		return -E_INVAL;
  80096b:	b8 03 00 00 00       	mov    $0x3,%eax
  800970:	eb 20                	jmp    800992 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800972:	ff 75 14             	pushl  0x14(%ebp)
  800975:	ff 75 10             	pushl  0x10(%ebp)
  800978:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80097b:	50                   	push   %eax
  80097c:	68 08 09 80 00       	push   $0x800908
  800981:	e8 92 fb ff ff       	call   800518 <vprintfmt>
  800986:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80098c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80098f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80099a:	8d 45 10             	lea    0x10(%ebp),%eax
  80099d:	83 c0 04             	add    $0x4,%eax
  8009a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	ff 75 08             	pushl  0x8(%ebp)
  8009b0:	e8 89 ff ff ff       	call   80093e <vsnprintf>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009be:	c9                   	leave  
  8009bf:	c3                   	ret    

008009c0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009cd:	eb 06                	jmp    8009d5 <strlen+0x15>
		n++;
  8009cf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d2:	ff 45 08             	incl   0x8(%ebp)
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8a 00                	mov    (%eax),%al
  8009da:	84 c0                	test   %al,%al
  8009dc:	75 f1                	jne    8009cf <strlen+0xf>
		n++;
	return n;
  8009de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f0:	eb 09                	jmp    8009fb <strnlen+0x18>
		n++;
  8009f2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f5:	ff 45 08             	incl   0x8(%ebp)
  8009f8:	ff 4d 0c             	decl   0xc(%ebp)
  8009fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009ff:	74 09                	je     800a0a <strnlen+0x27>
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8a 00                	mov    (%eax),%al
  800a06:	84 c0                	test   %al,%al
  800a08:	75 e8                	jne    8009f2 <strnlen+0xf>
		n++;
	return n;
  800a0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a0d:	c9                   	leave  
  800a0e:	c3                   	ret    

00800a0f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a1b:	90                   	nop
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8d 50 01             	lea    0x1(%eax),%edx
  800a22:	89 55 08             	mov    %edx,0x8(%ebp)
  800a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a2b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a2e:	8a 12                	mov    (%edx),%dl
  800a30:	88 10                	mov    %dl,(%eax)
  800a32:	8a 00                	mov    (%eax),%al
  800a34:	84 c0                	test   %al,%al
  800a36:	75 e4                	jne    800a1c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a50:	eb 1f                	jmp    800a71 <strncpy+0x34>
		*dst++ = *src;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8d 50 01             	lea    0x1(%eax),%edx
  800a58:	89 55 08             	mov    %edx,0x8(%ebp)
  800a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5e:	8a 12                	mov    (%edx),%dl
  800a60:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	8a 00                	mov    (%eax),%al
  800a67:	84 c0                	test   %al,%al
  800a69:	74 03                	je     800a6e <strncpy+0x31>
			src++;
  800a6b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6e:	ff 45 fc             	incl   -0x4(%ebp)
  800a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a74:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a77:	72 d9                	jb     800a52 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a79:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a8e:	74 30                	je     800ac0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a90:	eb 16                	jmp    800aa8 <strlcpy+0x2a>
			*dst++ = *src++;
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	8d 50 01             	lea    0x1(%eax),%edx
  800a98:	89 55 08             	mov    %edx,0x8(%ebp)
  800a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aa1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa4:	8a 12                	mov    (%edx),%dl
  800aa6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aa8:	ff 4d 10             	decl   0x10(%ebp)
  800aab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aaf:	74 09                	je     800aba <strlcpy+0x3c>
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	84 c0                	test   %al,%al
  800ab8:	75 d8                	jne    800a92 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ac0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ac6:	29 c2                	sub    %eax,%edx
  800ac8:	89 d0                	mov    %edx,%eax
}
  800aca:	c9                   	leave  
  800acb:	c3                   	ret    

00800acc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800acf:	eb 06                	jmp    800ad7 <strcmp+0xb>
		p++, q++;
  800ad1:	ff 45 08             	incl   0x8(%ebp)
  800ad4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	8a 00                	mov    (%eax),%al
  800adc:	84 c0                	test   %al,%al
  800ade:	74 0e                	je     800aee <strcmp+0x22>
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8a 10                	mov    (%eax),%dl
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	8a 00                	mov    (%eax),%al
  800aea:	38 c2                	cmp    %al,%dl
  800aec:	74 e3                	je     800ad1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	0f b6 d0             	movzbl %al,%edx
  800af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	0f b6 c0             	movzbl %al,%eax
  800afe:	29 c2                	sub    %eax,%edx
  800b00:	89 d0                	mov    %edx,%eax
}
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b07:	eb 09                	jmp    800b12 <strncmp+0xe>
		n--, p++, q++;
  800b09:	ff 4d 10             	decl   0x10(%ebp)
  800b0c:	ff 45 08             	incl   0x8(%ebp)
  800b0f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b16:	74 17                	je     800b2f <strncmp+0x2b>
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	8a 00                	mov    (%eax),%al
  800b1d:	84 c0                	test   %al,%al
  800b1f:	74 0e                	je     800b2f <strncmp+0x2b>
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8a 10                	mov    (%eax),%dl
  800b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b29:	8a 00                	mov    (%eax),%al
  800b2b:	38 c2                	cmp    %al,%dl
  800b2d:	74 da                	je     800b09 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b33:	75 07                	jne    800b3c <strncmp+0x38>
		return 0;
  800b35:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3a:	eb 14                	jmp    800b50 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f b6 d0             	movzbl %al,%edx
  800b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b47:	8a 00                	mov    (%eax),%al
  800b49:	0f b6 c0             	movzbl %al,%eax
  800b4c:	29 c2                	sub    %eax,%edx
  800b4e:	89 d0                	mov    %edx,%eax
}
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 04             	sub    $0x4,%esp
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b5e:	eb 12                	jmp    800b72 <strchr+0x20>
		if (*s == c)
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8a 00                	mov    (%eax),%al
  800b65:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b68:	75 05                	jne    800b6f <strchr+0x1d>
			return (char *) s;
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	eb 11                	jmp    800b80 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b6f:	ff 45 08             	incl   0x8(%ebp)
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8a 00                	mov    (%eax),%al
  800b77:	84 c0                	test   %al,%al
  800b79:	75 e5                	jne    800b60 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 04             	sub    $0x4,%esp
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b8e:	eb 0d                	jmp    800b9d <strfind+0x1b>
		if (*s == c)
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	8a 00                	mov    (%eax),%al
  800b95:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b98:	74 0e                	je     800ba8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b9a:	ff 45 08             	incl   0x8(%ebp)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	84 c0                	test   %al,%al
  800ba4:	75 ea                	jne    800b90 <strfind+0xe>
  800ba6:	eb 01                	jmp    800ba9 <strfind+0x27>
		if (*s == c)
			break;
  800ba8:	90                   	nop
	return (char *) s;
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bc0:	eb 0e                	jmp    800bd0 <memset+0x22>
		*p++ = c;
  800bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc5:	8d 50 01             	lea    0x1(%eax),%edx
  800bc8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bce:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bd0:	ff 4d f8             	decl   -0x8(%ebp)
  800bd3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bd7:	79 e9                	jns    800bc2 <memset+0x14>
		*p++ = c;

	return v;
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bdc:	c9                   	leave  
  800bdd:	c3                   	ret    

00800bde <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bf0:	eb 16                	jmp    800c08 <memcpy+0x2a>
		*d++ = *s++;
  800bf2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bfb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bfe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c01:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c04:	8a 12                	mov    (%edx),%dl
  800c06:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	75 dd                	jne    800bf2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c32:	73 50                	jae    800c84 <memmove+0x6a>
  800c34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3a:	01 d0                	add    %edx,%eax
  800c3c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c3f:	76 43                	jbe    800c84 <memmove+0x6a>
		s += n;
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c47:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c4d:	eb 10                	jmp    800c5f <memmove+0x45>
			*--d = *--s;
  800c4f:	ff 4d f8             	decl   -0x8(%ebp)
  800c52:	ff 4d fc             	decl   -0x4(%ebp)
  800c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c58:	8a 10                	mov    (%eax),%dl
  800c5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c5d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c65:	89 55 10             	mov    %edx,0x10(%ebp)
  800c68:	85 c0                	test   %eax,%eax
  800c6a:	75 e3                	jne    800c4f <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c6c:	eb 23                	jmp    800c91 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c71:	8d 50 01             	lea    0x1(%eax),%edx
  800c74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c80:	8a 12                	mov    (%edx),%dl
  800c82:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	75 dd                	jne    800c6e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ca8:	eb 2a                	jmp    800cd4 <memcmp+0x3e>
		if (*s1 != *s2)
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	8a 10                	mov    (%eax),%dl
  800caf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	38 c2                	cmp    %al,%dl
  800cb6:	74 16                	je     800cce <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	0f b6 d0             	movzbl %al,%edx
  800cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	29 c2                	sub    %eax,%edx
  800cca:	89 d0                	mov    %edx,%eax
  800ccc:	eb 18                	jmp    800ce6 <memcmp+0x50>
		s1++, s2++;
  800cce:	ff 45 fc             	incl   -0x4(%ebp)
  800cd1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cda:	89 55 10             	mov    %edx,0x10(%ebp)
  800cdd:	85 c0                	test   %eax,%eax
  800cdf:	75 c9                	jne    800caa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cee:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	01 d0                	add    %edx,%eax
  800cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800cf9:	eb 15                	jmp    800d10 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	0f b6 d0             	movzbl %al,%edx
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	0f b6 c0             	movzbl %al,%eax
  800d09:	39 c2                	cmp    %eax,%edx
  800d0b:	74 0d                	je     800d1a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d0d:	ff 45 08             	incl   0x8(%ebp)
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d16:	72 e3                	jb     800cfb <memfind+0x13>
  800d18:	eb 01                	jmp    800d1b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d1a:	90                   	nop
	return (void *) s;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1e:	c9                   	leave  
  800d1f:	c3                   	ret    

00800d20 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d34:	eb 03                	jmp    800d39 <strtol+0x19>
		s++;
  800d36:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	3c 20                	cmp    $0x20,%al
  800d40:	74 f4                	je     800d36 <strtol+0x16>
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	3c 09                	cmp    $0x9,%al
  800d49:	74 eb                	je     800d36 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	3c 2b                	cmp    $0x2b,%al
  800d52:	75 05                	jne    800d59 <strtol+0x39>
		s++;
  800d54:	ff 45 08             	incl   0x8(%ebp)
  800d57:	eb 13                	jmp    800d6c <strtol+0x4c>
	else if (*s == '-')
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	3c 2d                	cmp    $0x2d,%al
  800d60:	75 0a                	jne    800d6c <strtol+0x4c>
		s++, neg = 1;
  800d62:	ff 45 08             	incl   0x8(%ebp)
  800d65:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d70:	74 06                	je     800d78 <strtol+0x58>
  800d72:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d76:	75 20                	jne    800d98 <strtol+0x78>
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	3c 30                	cmp    $0x30,%al
  800d7f:	75 17                	jne    800d98 <strtol+0x78>
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	40                   	inc    %eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	3c 78                	cmp    $0x78,%al
  800d89:	75 0d                	jne    800d98 <strtol+0x78>
		s += 2, base = 16;
  800d8b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d8f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d96:	eb 28                	jmp    800dc0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9c:	75 15                	jne    800db3 <strtol+0x93>
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	3c 30                	cmp    $0x30,%al
  800da5:	75 0c                	jne    800db3 <strtol+0x93>
		s++, base = 8;
  800da7:	ff 45 08             	incl   0x8(%ebp)
  800daa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800db1:	eb 0d                	jmp    800dc0 <strtol+0xa0>
	else if (base == 0)
  800db3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db7:	75 07                	jne    800dc0 <strtol+0xa0>
		base = 10;
  800db9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	3c 2f                	cmp    $0x2f,%al
  800dc7:	7e 19                	jle    800de2 <strtol+0xc2>
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	3c 39                	cmp    $0x39,%al
  800dd0:	7f 10                	jg     800de2 <strtol+0xc2>
			dig = *s - '0';
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f be c0             	movsbl %al,%eax
  800dda:	83 e8 30             	sub    $0x30,%eax
  800ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800de0:	eb 42                	jmp    800e24 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	3c 60                	cmp    $0x60,%al
  800de9:	7e 19                	jle    800e04 <strtol+0xe4>
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3c 7a                	cmp    $0x7a,%al
  800df2:	7f 10                	jg     800e04 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f be c0             	movsbl %al,%eax
  800dfc:	83 e8 57             	sub    $0x57,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e02:	eb 20                	jmp    800e24 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	3c 40                	cmp    $0x40,%al
  800e0b:	7e 39                	jle    800e46 <strtol+0x126>
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	3c 5a                	cmp    $0x5a,%al
  800e14:	7f 30                	jg     800e46 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	0f be c0             	movsbl %al,%eax
  800e1e:	83 e8 37             	sub    $0x37,%eax
  800e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e27:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e2a:	7d 19                	jge    800e45 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e2c:	ff 45 08             	incl   0x8(%ebp)
  800e2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e32:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e36:	89 c2                	mov    %eax,%edx
  800e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3b:	01 d0                	add    %edx,%eax
  800e3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e40:	e9 7b ff ff ff       	jmp    800dc0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e45:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4a:	74 08                	je     800e54 <strtol+0x134>
		*endptr = (char *) s;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e54:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e58:	74 07                	je     800e61 <strtol+0x141>
  800e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5d:	f7 d8                	neg    %eax
  800e5f:	eb 03                	jmp    800e64 <strtol+0x144>
  800e61:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <ltostr>:

void
ltostr(long value, char *str)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e73:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e7e:	79 13                	jns    800e93 <ltostr+0x2d>
	{
		neg = 1;
  800e80:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e8d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e90:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e9b:	99                   	cltd   
  800e9c:	f7 f9                	idiv   %ecx
  800e9e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaa:	89 c2                	mov    %eax,%edx
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	01 d0                	add    %edx,%eax
  800eb1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800eb4:	83 c2 30             	add    $0x30,%edx
  800eb7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800eb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ec1:	f7 e9                	imul   %ecx
  800ec3:	c1 fa 02             	sar    $0x2,%edx
  800ec6:	89 c8                	mov    %ecx,%eax
  800ec8:	c1 f8 1f             	sar    $0x1f,%eax
  800ecb:	29 c2                	sub    %eax,%edx
  800ecd:	89 d0                	mov    %edx,%eax
  800ecf:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ed2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eda:	f7 e9                	imul   %ecx
  800edc:	c1 fa 02             	sar    $0x2,%edx
  800edf:	89 c8                	mov    %ecx,%eax
  800ee1:	c1 f8 1f             	sar    $0x1f,%eax
  800ee4:	29 c2                	sub    %eax,%edx
  800ee6:	89 d0                	mov    %edx,%eax
  800ee8:	c1 e0 02             	shl    $0x2,%eax
  800eeb:	01 d0                	add    %edx,%eax
  800eed:	01 c0                	add    %eax,%eax
  800eef:	29 c1                	sub    %eax,%ecx
  800ef1:	89 ca                	mov    %ecx,%edx
  800ef3:	85 d2                	test   %edx,%edx
  800ef5:	75 9c                	jne    800e93 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ef7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f01:	48                   	dec    %eax
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f05:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f09:	74 3d                	je     800f48 <ltostr+0xe2>
		start = 1 ;
  800f0b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f12:	eb 34                	jmp    800f48 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	01 c2                	add    %eax,%edx
  800f29:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	01 c8                	add    %ecx,%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	01 c2                	add    %eax,%edx
  800f3d:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f40:	88 02                	mov    %al,(%edx)
		start++ ;
  800f42:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f45:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f4e:	7c c4                	jl     800f14 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f50:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	01 d0                	add    %edx,%eax
  800f58:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f5b:	90                   	nop
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f64:	ff 75 08             	pushl  0x8(%ebp)
  800f67:	e8 54 fa ff ff       	call   8009c0 <strlen>
  800f6c:	83 c4 04             	add    $0x4,%esp
  800f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	e8 46 fa ff ff       	call   8009c0 <strlen>
  800f7a:	83 c4 04             	add    $0x4,%esp
  800f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f8e:	eb 17                	jmp    800fa7 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	01 c2                	add    %eax,%edx
  800f98:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	01 c8                	add    %ecx,%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fa4:	ff 45 fc             	incl   -0x4(%ebp)
  800fa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fad:	7c e1                	jl     800f90 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800faf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fb6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fbd:	eb 1f                	jmp    800fde <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8d 50 01             	lea    0x1(%eax),%edx
  800fc5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	01 c2                	add    %eax,%edx
  800fcf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	01 c8                	add    %ecx,%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fdb:	ff 45 f8             	incl   -0x8(%ebp)
  800fde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe4:	7c d9                	jl     800fbf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fe6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fec:	01 d0                	add    %edx,%eax
  800fee:	c6 00 00             	movb   $0x0,(%eax)
}
  800ff1:	90                   	nop
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800ff7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801000:	8b 45 14             	mov    0x14(%ebp),%eax
  801003:	8b 00                	mov    (%eax),%eax
  801005:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	01 d0                	add    %edx,%eax
  801011:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801017:	eb 0c                	jmp    801025 <strsplit+0x31>
			*string++ = 0;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8d 50 01             	lea    0x1(%eax),%edx
  80101f:	89 55 08             	mov    %edx,0x8(%ebp)
  801022:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	84 c0                	test   %al,%al
  80102c:	74 18                	je     801046 <strsplit+0x52>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	0f be c0             	movsbl %al,%eax
  801036:	50                   	push   %eax
  801037:	ff 75 0c             	pushl  0xc(%ebp)
  80103a:	e8 13 fb ff ff       	call   800b52 <strchr>
  80103f:	83 c4 08             	add    $0x8,%esp
  801042:	85 c0                	test   %eax,%eax
  801044:	75 d3                	jne    801019 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	74 5a                	je     8010a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  80104f:	8b 45 14             	mov    0x14(%ebp),%eax
  801052:	8b 00                	mov    (%eax),%eax
  801054:	83 f8 0f             	cmp    $0xf,%eax
  801057:	75 07                	jne    801060 <strsplit+0x6c>
		{
			return 0;
  801059:	b8 00 00 00 00       	mov    $0x0,%eax
  80105e:	eb 66                	jmp    8010c6 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801060:	8b 45 14             	mov    0x14(%ebp),%eax
  801063:	8b 00                	mov    (%eax),%eax
  801065:	8d 48 01             	lea    0x1(%eax),%ecx
  801068:	8b 55 14             	mov    0x14(%ebp),%edx
  80106b:	89 0a                	mov    %ecx,(%edx)
  80106d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801074:	8b 45 10             	mov    0x10(%ebp),%eax
  801077:	01 c2                	add    %eax,%edx
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80107e:	eb 03                	jmp    801083 <strsplit+0x8f>
			string++;
  801080:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 8b                	je     801017 <strsplit+0x23>
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	0f be c0             	movsbl %al,%eax
  801094:	50                   	push   %eax
  801095:	ff 75 0c             	pushl  0xc(%ebp)
  801098:	e8 b5 fa ff ff       	call   800b52 <strchr>
  80109d:	83 c4 08             	add    $0x8,%esp
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	74 dc                	je     801080 <strsplit+0x8c>
			string++;
	}
  8010a4:	e9 6e ff ff ff       	jmp    801017 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b9:	01 d0                	add    %edx,%eax
  8010bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	57                   	push   %edi
  8010cc:	56                   	push   %esi
  8010cd:	53                   	push   %ebx
  8010ce:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010dd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010e0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010e3:	cd 30                	int    $0x30
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010eb:	83 c4 10             	add    $0x10,%esp
  8010ee:	5b                   	pop    %ebx
  8010ef:	5e                   	pop    %esi
  8010f0:	5f                   	pop    %edi
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	6a 00                	push   $0x0
  8010fb:	6a 00                	push   $0x0
  8010fd:	6a 00                	push   $0x0
  8010ff:	ff 75 0c             	pushl  0xc(%ebp)
  801102:	50                   	push   %eax
  801103:	6a 00                	push   $0x0
  801105:	e8 be ff ff ff       	call   8010c8 <syscall>
  80110a:	83 c4 18             	add    $0x18,%esp
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <sys_cgetc>:

int
sys_cgetc(void)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801113:	6a 00                	push   $0x0
  801115:	6a 00                	push   $0x0
  801117:	6a 00                	push   $0x0
  801119:	6a 00                	push   $0x0
  80111b:	6a 00                	push   $0x0
  80111d:	6a 01                	push   $0x1
  80111f:	e8 a4 ff ff ff       	call   8010c8 <syscall>
  801124:	83 c4 18             	add    $0x18,%esp
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    

00801129 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	6a 00                	push   $0x0
  801131:	6a 00                	push   $0x0
  801133:	6a 00                	push   $0x0
  801135:	6a 00                	push   $0x0
  801137:	50                   	push   %eax
  801138:	6a 03                	push   $0x3
  80113a:	e8 89 ff ff ff       	call   8010c8 <syscall>
  80113f:	83 c4 18             	add    $0x18,%esp
}
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801147:	6a 00                	push   $0x0
  801149:	6a 00                	push   $0x0
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 02                	push   $0x2
  801153:	e8 70 ff ff ff       	call   8010c8 <syscall>
  801158:	83 c4 18             	add    $0x18,%esp
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <sys_env_exit>:

void sys_env_exit(void)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 04                	push   $0x4
  80116c:	e8 57 ff ff ff       	call   8010c8 <syscall>
  801171:	83 c4 18             	add    $0x18,%esp
}
  801174:	90                   	nop
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80117a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	6a 00                	push   $0x0
  801182:	6a 00                	push   $0x0
  801184:	6a 00                	push   $0x0
  801186:	52                   	push   %edx
  801187:	50                   	push   %eax
  801188:	6a 05                	push   $0x5
  80118a:	e8 39 ff ff ff       	call   8010c8 <syscall>
  80118f:	83 c4 18             	add    $0x18,%esp
}
  801192:	c9                   	leave  
  801193:	c3                   	ret    

00801194 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	56                   	push   %esi
  801198:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801199:	8b 75 18             	mov    0x18(%ebp),%esi
  80119c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80119f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	56                   	push   %esi
  8011a9:	53                   	push   %ebx
  8011aa:	51                   	push   %ecx
  8011ab:	52                   	push   %edx
  8011ac:	50                   	push   %eax
  8011ad:	6a 06                	push   $0x6
  8011af:	e8 14 ff ff ff       	call   8010c8 <syscall>
  8011b4:	83 c4 18             	add    $0x18,%esp
}
  8011b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011ba:	5b                   	pop    %ebx
  8011bb:	5e                   	pop    %esi
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8011c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	52                   	push   %edx
  8011ce:	50                   	push   %eax
  8011cf:	6a 07                	push   $0x7
  8011d1:	e8 f2 fe ff ff       	call   8010c8 <syscall>
  8011d6:	83 c4 18             	add    $0x18,%esp
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	ff 75 08             	pushl  0x8(%ebp)
  8011ea:	6a 08                	push   $0x8
  8011ec:	e8 d7 fe ff ff       	call   8010c8 <syscall>
  8011f1:	83 c4 18             	add    $0x18,%esp
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 09                	push   $0x9
  801205:	e8 be fe ff ff       	call   8010c8 <syscall>
  80120a:	83 c4 18             	add    $0x18,%esp
}
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801212:	6a 00                	push   $0x0
  801214:	6a 00                	push   $0x0
  801216:	6a 00                	push   $0x0
  801218:	6a 00                	push   $0x0
  80121a:	6a 00                	push   $0x0
  80121c:	6a 0a                	push   $0xa
  80121e:	e8 a5 fe ff ff       	call   8010c8 <syscall>
  801223:	83 c4 18             	add    $0x18,%esp
}
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 0b                	push   $0xb
  801237:	e8 8c fe ff ff       	call   8010c8 <syscall>
  80123c:	83 c4 18             	add    $0x18,%esp
}
  80123f:	c9                   	leave  
  801240:	c3                   	ret    

00801241 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801244:	6a 00                	push   $0x0
  801246:	6a 00                	push   $0x0
  801248:	6a 00                	push   $0x0
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	ff 75 08             	pushl  0x8(%ebp)
  801250:	6a 0d                	push   $0xd
  801252:	e8 71 fe ff ff       	call   8010c8 <syscall>
  801257:	83 c4 18             	add    $0x18,%esp
	return;
  80125a:	90                   	nop
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	ff 75 08             	pushl  0x8(%ebp)
  80126c:	6a 0e                	push   $0xe
  80126e:	e8 55 fe ff ff       	call   8010c8 <syscall>
  801273:	83 c4 18             	add    $0x18,%esp
	return ;
  801276:	90                   	nop
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 0c                	push   $0xc
  801288:	e8 3b fe ff ff       	call   8010c8 <syscall>
  80128d:	83 c4 18             	add    $0x18,%esp
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 10                	push   $0x10
  8012a1:	e8 22 fe ff ff       	call   8010c8 <syscall>
  8012a6:	83 c4 18             	add    $0x18,%esp
}
  8012a9:	90                   	nop
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 11                	push   $0x11
  8012bb:	e8 08 fe ff ff       	call   8010c8 <syscall>
  8012c0:	83 c4 18             	add    $0x18,%esp
}
  8012c3:	90                   	nop
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	83 ec 04             	sub    $0x4,%esp
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8012d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	50                   	push   %eax
  8012df:	6a 12                	push   $0x12
  8012e1:	e8 e2 fd ff ff       	call   8010c8 <syscall>
  8012e6:	83 c4 18             	add    $0x18,%esp
}
  8012e9:	90                   	nop
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 13                	push   $0x13
  8012fb:	e8 c8 fd ff ff       	call   8010c8 <syscall>
  801300:	83 c4 18             	add    $0x18,%esp
}
  801303:	90                   	nop
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	ff 75 0c             	pushl  0xc(%ebp)
  801315:	50                   	push   %eax
  801316:	6a 14                	push   $0x14
  801318:	e8 ab fd ff ff       	call   8010c8 <syscall>
  80131d:	83 c4 18             	add    $0x18,%esp
}
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	50                   	push   %eax
  801331:	6a 17                	push   $0x17
  801333:	e8 90 fd ff ff       	call   8010c8 <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	50                   	push   %eax
  80134c:	6a 15                	push   $0x15
  80134e:	e8 75 fd ff ff       	call   8010c8 <syscall>
  801353:	83 c4 18             	add    $0x18,%esp
}
  801356:	90                   	nop
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	50                   	push   %eax
  801368:	6a 16                	push   $0x16
  80136a:	e8 59 fd ff ff       	call   8010c8 <syscall>
  80136f:	83 c4 18             	add    $0x18,%esp
}
  801372:	90                   	nop
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 04             	sub    $0x4,%esp
  80137b:	8b 45 10             	mov    0x10(%ebp),%eax
  80137e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801381:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801384:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	6a 00                	push   $0x0
  80138d:	51                   	push   %ecx
  80138e:	52                   	push   %edx
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	50                   	push   %eax
  801393:	6a 18                	push   $0x18
  801395:	e8 2e fd ff ff       	call   8010c8 <syscall>
  80139a:	83 c4 18             	add    $0x18,%esp
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8013a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	52                   	push   %edx
  8013af:	50                   	push   %eax
  8013b0:	6a 19                	push   $0x19
  8013b2:	e8 11 fd ff ff       	call   8010c8 <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	50                   	push   %eax
  8013cb:	6a 1a                	push   $0x1a
  8013cd:	e8 f6 fc ff ff       	call   8010c8 <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 1b                	push   $0x1b
  8013e6:	e8 dd fc ff ff       	call   8010c8 <syscall>
  8013eb:	83 c4 18             	add    $0x18,%esp
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 1c                	push   $0x1c
  8013ff:	e8 c4 fc ff ff       	call   8010c8 <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	50                   	push   %eax
  801419:	6a 1d                	push   $0x1d
  80141b:	e8 a8 fc ff ff       	call   8010c8 <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	50                   	push   %eax
  801434:	6a 1e                	push   $0x1e
  801436:	e8 8d fc ff ff       	call   8010c8 <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	90                   	nop
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	50                   	push   %eax
  801450:	6a 1f                	push   $0x1f
  801452:	e8 71 fc ff ff       	call   8010c8 <syscall>
  801457:	83 c4 18             	add    $0x18,%esp
}
  80145a:	90                   	nop
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801463:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801466:	8d 50 04             	lea    0x4(%eax),%edx
  801469:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	52                   	push   %edx
  801473:	50                   	push   %eax
  801474:	6a 20                	push   $0x20
  801476:	e8 4d fc ff ff       	call   8010c8 <syscall>
  80147b:	83 c4 18             	add    $0x18,%esp
	return result;
  80147e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801481:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801484:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801487:	89 01                	mov    %eax,(%ecx)
  801489:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	c9                   	leave  
  801490:	c2 04 00             	ret    $0x4

00801493 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	ff 75 10             	pushl  0x10(%ebp)
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	ff 75 08             	pushl  0x8(%ebp)
  8014a3:	6a 0f                	push   $0xf
  8014a5:	e8 1e fc ff ff       	call   8010c8 <syscall>
  8014aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ad:	90                   	nop
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 21                	push   $0x21
  8014bf:	e8 04 fc ff ff       	call   8010c8 <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 04             	sub    $0x4,%esp
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014d5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	50                   	push   %eax
  8014e2:	6a 22                	push   $0x22
  8014e4:	e8 df fb ff ff       	call   8010c8 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ec:	90                   	nop
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <rsttst>:
void rsttst()
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 24                	push   $0x24
  8014fe:	e8 c5 fb ff ff       	call   8010c8 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
	return ;
  801506:	90                   	nop
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 04             	sub    $0x4,%esp
  80150f:	8b 45 14             	mov    0x14(%ebp),%eax
  801512:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801515:	8b 55 18             	mov    0x18(%ebp),%edx
  801518:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80151c:	52                   	push   %edx
  80151d:	50                   	push   %eax
  80151e:	ff 75 10             	pushl  0x10(%ebp)
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	ff 75 08             	pushl  0x8(%ebp)
  801527:	6a 23                	push   $0x23
  801529:	e8 9a fb ff ff       	call   8010c8 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
	return ;
  801531:	90                   	nop
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <chktst>:
void chktst(uint32 n)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	ff 75 08             	pushl  0x8(%ebp)
  801542:	6a 25                	push   $0x25
  801544:	e8 7f fb ff ff       	call   8010c8 <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
	return ;
  80154c:	90                   	nop
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 26                	push   $0x26
  801561:	e8 62 fb ff ff       	call   8010c8 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
  801569:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80156c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801570:	75 07                	jne    801579 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801572:	b8 01 00 00 00       	mov    $0x1,%eax
  801577:	eb 05                	jmp    80157e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801579:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 26                	push   $0x26
  801592:	e8 31 fb ff ff       	call   8010c8 <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
  80159a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80159d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015a1:	75 07                	jne    8015aa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a8:	eb 05                	jmp    8015af <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 26                	push   $0x26
  8015c3:	e8 00 fb ff ff       	call   8010c8 <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
  8015cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015ce:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015d2:	75 07                	jne    8015db <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d9:	eb 05                	jmp    8015e0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 26                	push   $0x26
  8015f4:	e8 cf fa ff ff       	call   8010c8 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
  8015fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015ff:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801603:	75 07                	jne    80160c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801605:	b8 01 00 00 00       	mov    $0x1,%eax
  80160a:	eb 05                	jmp    801611 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	6a 27                	push   $0x27
  801623:	e8 a0 fa ff ff       	call   8010c8 <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
	return ;
  80162b:	90                   	nop
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    
  80162e:	66 90                	xchg   %ax,%ax

00801630 <__udivdi3>:
  801630:	55                   	push   %ebp
  801631:	57                   	push   %edi
  801632:	56                   	push   %esi
  801633:	53                   	push   %ebx
  801634:	83 ec 1c             	sub    $0x1c,%esp
  801637:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80163b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80163f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801643:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801647:	89 ca                	mov    %ecx,%edx
  801649:	89 f8                	mov    %edi,%eax
  80164b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80164f:	85 f6                	test   %esi,%esi
  801651:	75 2d                	jne    801680 <__udivdi3+0x50>
  801653:	39 cf                	cmp    %ecx,%edi
  801655:	77 65                	ja     8016bc <__udivdi3+0x8c>
  801657:	89 fd                	mov    %edi,%ebp
  801659:	85 ff                	test   %edi,%edi
  80165b:	75 0b                	jne    801668 <__udivdi3+0x38>
  80165d:	b8 01 00 00 00       	mov    $0x1,%eax
  801662:	31 d2                	xor    %edx,%edx
  801664:	f7 f7                	div    %edi
  801666:	89 c5                	mov    %eax,%ebp
  801668:	31 d2                	xor    %edx,%edx
  80166a:	89 c8                	mov    %ecx,%eax
  80166c:	f7 f5                	div    %ebp
  80166e:	89 c1                	mov    %eax,%ecx
  801670:	89 d8                	mov    %ebx,%eax
  801672:	f7 f5                	div    %ebp
  801674:	89 cf                	mov    %ecx,%edi
  801676:	89 fa                	mov    %edi,%edx
  801678:	83 c4 1c             	add    $0x1c,%esp
  80167b:	5b                   	pop    %ebx
  80167c:	5e                   	pop    %esi
  80167d:	5f                   	pop    %edi
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    
  801680:	39 ce                	cmp    %ecx,%esi
  801682:	77 28                	ja     8016ac <__udivdi3+0x7c>
  801684:	0f bd fe             	bsr    %esi,%edi
  801687:	83 f7 1f             	xor    $0x1f,%edi
  80168a:	75 40                	jne    8016cc <__udivdi3+0x9c>
  80168c:	39 ce                	cmp    %ecx,%esi
  80168e:	72 0a                	jb     80169a <__udivdi3+0x6a>
  801690:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801694:	0f 87 9e 00 00 00    	ja     801738 <__udivdi3+0x108>
  80169a:	b8 01 00 00 00       	mov    $0x1,%eax
  80169f:	89 fa                	mov    %edi,%edx
  8016a1:	83 c4 1c             	add    $0x1c,%esp
  8016a4:	5b                   	pop    %ebx
  8016a5:	5e                   	pop    %esi
  8016a6:	5f                   	pop    %edi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    
  8016a9:	8d 76 00             	lea    0x0(%esi),%esi
  8016ac:	31 ff                	xor    %edi,%edi
  8016ae:	31 c0                	xor    %eax,%eax
  8016b0:	89 fa                	mov    %edi,%edx
  8016b2:	83 c4 1c             	add    $0x1c,%esp
  8016b5:	5b                   	pop    %ebx
  8016b6:	5e                   	pop    %esi
  8016b7:	5f                   	pop    %edi
  8016b8:	5d                   	pop    %ebp
  8016b9:	c3                   	ret    
  8016ba:	66 90                	xchg   %ax,%ax
  8016bc:	89 d8                	mov    %ebx,%eax
  8016be:	f7 f7                	div    %edi
  8016c0:	31 ff                	xor    %edi,%edi
  8016c2:	89 fa                	mov    %edi,%edx
  8016c4:	83 c4 1c             	add    $0x1c,%esp
  8016c7:	5b                   	pop    %ebx
  8016c8:	5e                   	pop    %esi
  8016c9:	5f                   	pop    %edi
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    
  8016cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8016d1:	89 eb                	mov    %ebp,%ebx
  8016d3:	29 fb                	sub    %edi,%ebx
  8016d5:	89 f9                	mov    %edi,%ecx
  8016d7:	d3 e6                	shl    %cl,%esi
  8016d9:	89 c5                	mov    %eax,%ebp
  8016db:	88 d9                	mov    %bl,%cl
  8016dd:	d3 ed                	shr    %cl,%ebp
  8016df:	89 e9                	mov    %ebp,%ecx
  8016e1:	09 f1                	or     %esi,%ecx
  8016e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8016e7:	89 f9                	mov    %edi,%ecx
  8016e9:	d3 e0                	shl    %cl,%eax
  8016eb:	89 c5                	mov    %eax,%ebp
  8016ed:	89 d6                	mov    %edx,%esi
  8016ef:	88 d9                	mov    %bl,%cl
  8016f1:	d3 ee                	shr    %cl,%esi
  8016f3:	89 f9                	mov    %edi,%ecx
  8016f5:	d3 e2                	shl    %cl,%edx
  8016f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8016fb:	88 d9                	mov    %bl,%cl
  8016fd:	d3 e8                	shr    %cl,%eax
  8016ff:	09 c2                	or     %eax,%edx
  801701:	89 d0                	mov    %edx,%eax
  801703:	89 f2                	mov    %esi,%edx
  801705:	f7 74 24 0c          	divl   0xc(%esp)
  801709:	89 d6                	mov    %edx,%esi
  80170b:	89 c3                	mov    %eax,%ebx
  80170d:	f7 e5                	mul    %ebp
  80170f:	39 d6                	cmp    %edx,%esi
  801711:	72 19                	jb     80172c <__udivdi3+0xfc>
  801713:	74 0b                	je     801720 <__udivdi3+0xf0>
  801715:	89 d8                	mov    %ebx,%eax
  801717:	31 ff                	xor    %edi,%edi
  801719:	e9 58 ff ff ff       	jmp    801676 <__udivdi3+0x46>
  80171e:	66 90                	xchg   %ax,%ax
  801720:	8b 54 24 08          	mov    0x8(%esp),%edx
  801724:	89 f9                	mov    %edi,%ecx
  801726:	d3 e2                	shl    %cl,%edx
  801728:	39 c2                	cmp    %eax,%edx
  80172a:	73 e9                	jae    801715 <__udivdi3+0xe5>
  80172c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80172f:	31 ff                	xor    %edi,%edi
  801731:	e9 40 ff ff ff       	jmp    801676 <__udivdi3+0x46>
  801736:	66 90                	xchg   %ax,%ax
  801738:	31 c0                	xor    %eax,%eax
  80173a:	e9 37 ff ff ff       	jmp    801676 <__udivdi3+0x46>
  80173f:	90                   	nop

00801740 <__umoddi3>:
  801740:	55                   	push   %ebp
  801741:	57                   	push   %edi
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	83 ec 1c             	sub    $0x1c,%esp
  801747:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80174b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80174f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801753:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801757:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80175b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80175f:	89 f3                	mov    %esi,%ebx
  801761:	89 fa                	mov    %edi,%edx
  801763:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801767:	89 34 24             	mov    %esi,(%esp)
  80176a:	85 c0                	test   %eax,%eax
  80176c:	75 1a                	jne    801788 <__umoddi3+0x48>
  80176e:	39 f7                	cmp    %esi,%edi
  801770:	0f 86 a2 00 00 00    	jbe    801818 <__umoddi3+0xd8>
  801776:	89 c8                	mov    %ecx,%eax
  801778:	89 f2                	mov    %esi,%edx
  80177a:	f7 f7                	div    %edi
  80177c:	89 d0                	mov    %edx,%eax
  80177e:	31 d2                	xor    %edx,%edx
  801780:	83 c4 1c             	add    $0x1c,%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5f                   	pop    %edi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    
  801788:	39 f0                	cmp    %esi,%eax
  80178a:	0f 87 ac 00 00 00    	ja     80183c <__umoddi3+0xfc>
  801790:	0f bd e8             	bsr    %eax,%ebp
  801793:	83 f5 1f             	xor    $0x1f,%ebp
  801796:	0f 84 ac 00 00 00    	je     801848 <__umoddi3+0x108>
  80179c:	bf 20 00 00 00       	mov    $0x20,%edi
  8017a1:	29 ef                	sub    %ebp,%edi
  8017a3:	89 fe                	mov    %edi,%esi
  8017a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017a9:	89 e9                	mov    %ebp,%ecx
  8017ab:	d3 e0                	shl    %cl,%eax
  8017ad:	89 d7                	mov    %edx,%edi
  8017af:	89 f1                	mov    %esi,%ecx
  8017b1:	d3 ef                	shr    %cl,%edi
  8017b3:	09 c7                	or     %eax,%edi
  8017b5:	89 e9                	mov    %ebp,%ecx
  8017b7:	d3 e2                	shl    %cl,%edx
  8017b9:	89 14 24             	mov    %edx,(%esp)
  8017bc:	89 d8                	mov    %ebx,%eax
  8017be:	d3 e0                	shl    %cl,%eax
  8017c0:	89 c2                	mov    %eax,%edx
  8017c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017c6:	d3 e0                	shl    %cl,%eax
  8017c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017d0:	89 f1                	mov    %esi,%ecx
  8017d2:	d3 e8                	shr    %cl,%eax
  8017d4:	09 d0                	or     %edx,%eax
  8017d6:	d3 eb                	shr    %cl,%ebx
  8017d8:	89 da                	mov    %ebx,%edx
  8017da:	f7 f7                	div    %edi
  8017dc:	89 d3                	mov    %edx,%ebx
  8017de:	f7 24 24             	mull   (%esp)
  8017e1:	89 c6                	mov    %eax,%esi
  8017e3:	89 d1                	mov    %edx,%ecx
  8017e5:	39 d3                	cmp    %edx,%ebx
  8017e7:	0f 82 87 00 00 00    	jb     801874 <__umoddi3+0x134>
  8017ed:	0f 84 91 00 00 00    	je     801884 <__umoddi3+0x144>
  8017f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8017f7:	29 f2                	sub    %esi,%edx
  8017f9:	19 cb                	sbb    %ecx,%ebx
  8017fb:	89 d8                	mov    %ebx,%eax
  8017fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801801:	d3 e0                	shl    %cl,%eax
  801803:	89 e9                	mov    %ebp,%ecx
  801805:	d3 ea                	shr    %cl,%edx
  801807:	09 d0                	or     %edx,%eax
  801809:	89 e9                	mov    %ebp,%ecx
  80180b:	d3 eb                	shr    %cl,%ebx
  80180d:	89 da                	mov    %ebx,%edx
  80180f:	83 c4 1c             	add    $0x1c,%esp
  801812:	5b                   	pop    %ebx
  801813:	5e                   	pop    %esi
  801814:	5f                   	pop    %edi
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    
  801817:	90                   	nop
  801818:	89 fd                	mov    %edi,%ebp
  80181a:	85 ff                	test   %edi,%edi
  80181c:	75 0b                	jne    801829 <__umoddi3+0xe9>
  80181e:	b8 01 00 00 00       	mov    $0x1,%eax
  801823:	31 d2                	xor    %edx,%edx
  801825:	f7 f7                	div    %edi
  801827:	89 c5                	mov    %eax,%ebp
  801829:	89 f0                	mov    %esi,%eax
  80182b:	31 d2                	xor    %edx,%edx
  80182d:	f7 f5                	div    %ebp
  80182f:	89 c8                	mov    %ecx,%eax
  801831:	f7 f5                	div    %ebp
  801833:	89 d0                	mov    %edx,%eax
  801835:	e9 44 ff ff ff       	jmp    80177e <__umoddi3+0x3e>
  80183a:	66 90                	xchg   %ax,%ax
  80183c:	89 c8                	mov    %ecx,%eax
  80183e:	89 f2                	mov    %esi,%edx
  801840:	83 c4 1c             	add    $0x1c,%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5f                   	pop    %edi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    
  801848:	3b 04 24             	cmp    (%esp),%eax
  80184b:	72 06                	jb     801853 <__umoddi3+0x113>
  80184d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801851:	77 0f                	ja     801862 <__umoddi3+0x122>
  801853:	89 f2                	mov    %esi,%edx
  801855:	29 f9                	sub    %edi,%ecx
  801857:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80185b:	89 14 24             	mov    %edx,(%esp)
  80185e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801862:	8b 44 24 04          	mov    0x4(%esp),%eax
  801866:	8b 14 24             	mov    (%esp),%edx
  801869:	83 c4 1c             	add    $0x1c,%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5f                   	pop    %edi
  80186f:	5d                   	pop    %ebp
  801870:	c3                   	ret    
  801871:	8d 76 00             	lea    0x0(%esi),%esi
  801874:	2b 04 24             	sub    (%esp),%eax
  801877:	19 fa                	sbb    %edi,%edx
  801879:	89 d1                	mov    %edx,%ecx
  80187b:	89 c6                	mov    %eax,%esi
  80187d:	e9 71 ff ff ff       	jmp    8017f3 <__umoddi3+0xb3>
  801882:	66 90                	xchg   %ax,%ax
  801884:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801888:	72 ea                	jb     801874 <__umoddi3+0x134>
  80188a:	89 d9                	mov    %ebx,%ecx
  80188c:	e9 62 ff ff ff       	jmp    8017f3 <__umoddi3+0xb3>
