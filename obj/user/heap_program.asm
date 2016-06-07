
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 17 02 00 00       	call   80024d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp
	int envID = sys_getenvid();
  800041:	e8 94 1c 00 00       	call   801cda <sys_getenvid>
  800046:	89 45 d8             	mov    %eax,-0x28(%ebp)

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800049:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80004c:	89 d0                	mov    %edx,%eax
  80004e:	c1 e0 03             	shl    $0x3,%eax
  800051:	01 d0                	add    %edx,%eax
  800053:	01 c0                	add    %eax,%eax
  800055:	01 d0                	add    %edx,%eax
  800057:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800068:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int kilo = 1024;
  80006b:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
	int Mega = 1024*1024;
  800072:	c7 45 cc 00 00 10 00 	movl   $0x100000,-0x34(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  800079:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80007c:	89 d0                	mov    %edx,%eax
  80007e:	01 c0                	add    %eax,%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	c1 e0 02             	shl    $0x2,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	89 45 c8             	mov    %eax,-0x38(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	ff 75 c8             	pushl  -0x38(%ebp)
  800090:	e8 27 11 00 00       	call   8011bc <malloc>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	ff 75 c8             	pushl  -0x38(%ebp)
  8000a1:	e8 16 11 00 00       	call   8011bc <malloc>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 c0             	mov    %eax,-0x40(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000ac:	e8 5e 1d 00 00       	call   801e0f <sys_pf_calculate_allocated_pages>
  8000b1:	89 45 bc             	mov    %eax,-0x44(%ebp)

		x[1]=-1;
  8000b4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000b7:	40                   	inc    %eax
  8000b8:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  8000bb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8000be:	89 d0                	mov    %edx,%eax
  8000c0:	c1 e0 02             	shl    $0x2,%eax
  8000c3:	01 d0                	add    %edx,%eax
  8000c5:	89 c2                	mov    %eax,%edx
  8000c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000ca:	01 d0                	add    %edx,%eax
  8000cc:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000d2:	c1 e0 03             	shl    $0x3,%eax
  8000d5:	89 c2                	mov    %eax,%edx
  8000d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000da:	01 d0                	add    %edx,%eax
  8000dc:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000df:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8000e2:	89 d0                	mov    %edx,%eax
  8000e4:	01 c0                	add    %eax,%eax
  8000e6:	01 d0                	add    %edx,%eax
  8000e8:	c1 e0 02             	shl    $0x2,%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000f0:	01 d0                	add    %edx,%eax
  8000f2:	c6 00 ff             	movb   $0xff,(%eax)

		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;

		free(x);
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000fb:	e8 5e 1a 00 00       	call   801b5e <free>
  800100:	83 c4 10             	add    $0x10,%esp
		free(y);
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	ff 75 c0             	pushl  -0x40(%ebp)
  800109:	e8 50 1a 00 00       	call   801b5e <free>
  80010e:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800111:	e8 76 1c 00 00       	call   801d8c <sys_calculate_free_frames>
  800116:	89 45 b8             	mov    %eax,-0x48(%ebp)

		x = malloc(sizeof(char)*size) ;
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 c8             	pushl  -0x38(%ebp)
  80011f:	e8 98 10 00 00       	call   8011bc <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-2;
  80012a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80012d:	40                   	inc    %eax
  80012e:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  800131:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800134:	89 d0                	mov    %edx,%eax
  800136:	c1 e0 02             	shl    $0x2,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	89 c2                	mov    %eax,%edx
  80013d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  800145:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	89 c2                	mov    %eax,%edx
  80014d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800150:	01 d0                	add    %edx,%eax
  800152:	c6 00 fe             	movb   $0xfe,(%eax)

		x[12*Mega]=-2;
  800155:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800158:	89 d0                	mov    %edx,%eax
  80015a:	01 c0                	add    %eax,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	c1 e0 02             	shl    $0x2,%eax
  800161:	89 c2                	mov    %eax,%edx
  800163:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	c6 00 fe             	movb   $0xfe,(%eax)

		uint32 pageWSEntries[8] = {0x802000, 0x80500000, 0x80800000, 0x80c00000, 0x80000000, 0x801000, 0x800000, 0xeebfd000};
  80016b:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80016e:	bb 00 25 80 00       	mov    $0x802500,%ebx
  800173:	ba 08 00 00 00       	mov    $0x8,%edx
  800178:	89 c7                	mov    %eax,%edi
  80017a:	89 de                	mov    %ebx,%esi
  80017c:	89 d1                	mov    %edx,%ecx
  80017e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < (myEnv->page_WS_max_size); i++)
  800187:	eb 75                	jmp    8001fe <_main+0x1c6>
		{
			int found = 0 ;
  800189:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800190:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800197:	eb 3b                	jmp    8001d4 <_main+0x19c>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  800199:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80019c:	8b 4c 85 94          	mov    -0x6c(%ebp,%eax,4),%ecx
  8001a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001a3:	8b 98 f4 02 00 00    	mov    0x2f4(%eax),%ebx
  8001a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001ac:	89 d0                	mov    %edx,%eax
  8001ae:	01 c0                	add    %eax,%eax
  8001b0:	01 d0                	add    %edx,%eax
  8001b2:	c1 e0 02             	shl    $0x2,%eax
  8001b5:	01 d8                	add    %ebx,%eax
  8001b7:	8b 00                	mov    (%eax),%eax
  8001b9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001bc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001c4:	39 c1                	cmp    %eax,%ecx
  8001c6:	75 09                	jne    8001d1 <_main+0x199>
				{
					found = 1 ;
  8001c8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001cf:	eb 10                	jmp    8001e1 <_main+0x1a9>

		int i = 0, j ;
		for (; i < (myEnv->page_WS_max_size); i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001d1:	ff 45 e0             	incl   -0x20(%ebp)
  8001d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001d7:	8b 50 74             	mov    0x74(%eax),%edx
  8001da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001dd:	39 c2                	cmp    %eax,%edx
  8001df:	77 b8                	ja     800199 <_main+0x161>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001e5:	75 14                	jne    8001fb <_main+0x1c3>
				panic("PAGE Placement algorithm failed after applying freeHeap");
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 40 24 80 00       	push   $0x802440
  8001ef:	6a 45                	push   $0x45
  8001f1:	68 78 24 80 00       	push   $0x802478
  8001f6:	e8 13 01 00 00       	call   80030e <_panic>
		x[12*Mega]=-2;

		uint32 pageWSEntries[8] = {0x802000, 0x80500000, 0x80800000, 0x80c00000, 0x80000000, 0x801000, 0x800000, 0xeebfd000};

		int i = 0, j ;
		for (; i < (myEnv->page_WS_max_size); i++)
  8001fb:	ff 45 e4             	incl   -0x1c(%ebp)
  8001fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800201:	8b 50 74             	mov    0x74(%eax),%edx
  800204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800207:	39 c2                	cmp    %eax,%edx
  800209:	0f 87 7a ff ff ff    	ja     800189 <_main+0x151>
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap");
		}


		if( (freePages - sys_calculate_free_frames() ) != 8 ) panic("Extra/Less memory are wrongly allocated");
  80020f:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800212:	e8 75 1b 00 00       	call   801d8c <sys_calculate_free_frames>
  800217:	29 c3                	sub    %eax,%ebx
  800219:	89 d8                	mov    %ebx,%eax
  80021b:	83 f8 08             	cmp    $0x8,%eax
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 8c 24 80 00       	push   $0x80248c
  800228:	6a 49                	push   $0x49
  80022a:	68 78 24 80 00       	push   $0x802478
  80022f:	e8 da 00 00 00       	call   80030e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 b4 24 80 00       	push   $0x8024b4
  80023c:	e8 f8 01 00 00       	call   800439 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp


	return;
  800244:	90                   	nop
}
  800245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5f                   	pop    %edi
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    

0080024d <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800253:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800257:	7e 0a                	jle    800263 <libmain+0x16>
		binaryname = argv[0];
  800259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025c:	8b 00                	mov    (%eax),%eax
  80025e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	ff 75 0c             	pushl  0xc(%ebp)
  800269:	ff 75 08             	pushl  0x8(%ebp)
  80026c:	e8 c7 fd ff ff       	call   800038 <_main>
  800271:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800274:	e8 61 1a 00 00       	call   801cda <sys_getenvid>
  800279:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80027c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80027f:	89 d0                	mov    %edx,%eax
  800281:	c1 e0 03             	shl    $0x3,%eax
  800284:	01 d0                	add    %edx,%eax
  800286:	01 c0                	add    %eax,%eax
  800288:	01 d0                	add    %edx,%eax
  80028a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800291:	01 d0                	add    %edx,%eax
  800293:	c1 e0 03             	shl    $0x3,%eax
  800296:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80029b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  80029e:	e8 85 1b 00 00       	call   801e28 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	68 38 25 80 00       	push   $0x802538
  8002ab:	e8 89 01 00 00       	call   800439 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8002b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b6:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8002bc:	83 ec 08             	sub    $0x8,%esp
  8002bf:	50                   	push   %eax
  8002c0:	68 60 25 80 00       	push   $0x802560
  8002c5:	e8 6f 01 00 00       	call   800439 <cprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002cd:	83 ec 0c             	sub    $0xc,%esp
  8002d0:	68 38 25 80 00       	push   $0x802538
  8002d5:	e8 5f 01 00 00       	call   800439 <cprintf>
  8002da:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002dd:	e8 60 1b 00 00       	call   801e42 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002e2:	e8 19 00 00 00       	call   800300 <exit>
}
  8002e7:	90                   	nop
  8002e8:	c9                   	leave  
  8002e9:	c3                   	ret    

008002ea <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002f0:	83 ec 0c             	sub    $0xc,%esp
  8002f3:	6a 00                	push   $0x0
  8002f5:	e8 c5 19 00 00       	call   801cbf <sys_env_destroy>
  8002fa:	83 c4 10             	add    $0x10,%esp
}
  8002fd:	90                   	nop
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <exit>:

void
exit(void)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800306:	e8 e8 19 00 00       	call   801cf3 <sys_env_exit>
}
  80030b:	90                   	nop
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800314:	8d 45 10             	lea    0x10(%ebp),%eax
  800317:	83 c0 04             	add    $0x4,%eax
  80031a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  80031d:	a1 50 30 98 00       	mov    0x983050,%eax
  800322:	85 c0                	test   %eax,%eax
  800324:	74 16                	je     80033c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800326:	a1 50 30 98 00       	mov    0x983050,%eax
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	50                   	push   %eax
  80032f:	68 79 25 80 00       	push   $0x802579
  800334:	e8 00 01 00 00       	call   800439 <cprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80033c:	a1 00 30 80 00       	mov    0x803000,%eax
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	50                   	push   %eax
  800348:	68 7e 25 80 00       	push   $0x80257e
  80034d:	e8 e7 00 00 00       	call   800439 <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800355:	8b 45 10             	mov    0x10(%ebp),%eax
  800358:	83 ec 08             	sub    $0x8,%esp
  80035b:	ff 75 f4             	pushl  -0xc(%ebp)
  80035e:	50                   	push   %eax
  80035f:	e8 7a 00 00 00       	call   8003de <vcprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	68 9a 25 80 00       	push   $0x80259a
  80036f:	e8 c5 00 00 00       	call   800439 <cprintf>
  800374:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800377:	e8 84 ff ff ff       	call   800300 <exit>

	// should not return here
	while (1) ;
  80037c:	eb fe                	jmp    80037c <_panic+0x6e>

0080037e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
  800387:	8b 00                	mov    (%eax),%eax
  800389:	8d 48 01             	lea    0x1(%eax),%ecx
  80038c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038f:	89 0a                	mov    %ecx,(%edx)
  800391:	8b 55 08             	mov    0x8(%ebp),%edx
  800394:	88 d1                	mov    %dl,%cl
  800396:	8b 55 0c             	mov    0xc(%ebp),%edx
  800399:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a7:	75 23                	jne    8003cc <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8003a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b3:	83 c0 08             	add    $0x8,%eax
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	52                   	push   %edx
  8003ba:	50                   	push   %eax
  8003bb:	e8 c9 18 00 00       	call   801c89 <sys_cputs>
  8003c0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cf:	8b 40 04             	mov    0x4(%eax),%eax
  8003d2:	8d 50 01             	lea    0x1(%eax),%edx
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003db:	90                   	nop
  8003dc:	c9                   	leave  
  8003dd:	c3                   	ret    

008003de <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003de:	55                   	push   %ebp
  8003df:	89 e5                	mov    %esp,%ebp
  8003e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ee:	00 00 00 
	b.cnt = 0;
  8003f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003fb:	ff 75 0c             	pushl  0xc(%ebp)
  8003fe:	ff 75 08             	pushl  0x8(%ebp)
  800401:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800407:	50                   	push   %eax
  800408:	68 7e 03 80 00       	push   $0x80037e
  80040d:	e8 fa 01 00 00       	call   80060c <vprintfmt>
  800412:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800415:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	50                   	push   %eax
  80041f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800425:	83 c0 08             	add    $0x8,%eax
  800428:	50                   	push   %eax
  800429:	e8 5b 18 00 00       	call   801c89 <sys_cputs>
  80042e:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800431:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800437:	c9                   	leave  
  800438:	c3                   	ret    

00800439 <cprintf>:

int cprintf(const char *fmt, ...) {
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80043f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800442:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	ff 75 f4             	pushl  -0xc(%ebp)
  80044e:	50                   	push   %eax
  80044f:	e8 8a ff ff ff       	call   8003de <vcprintf>
  800454:	83 c4 10             	add    $0x10,%esp
  800457:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80045a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800465:	e8 be 19 00 00       	call   801e28 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80046a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	ff 75 f4             	pushl  -0xc(%ebp)
  800479:	50                   	push   %eax
  80047a:	e8 5f ff ff ff       	call   8003de <vcprintf>
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800485:	e8 b8 19 00 00       	call   801e42 <sys_enable_interrupt>
	return cnt;
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	53                   	push   %ebx
  800493:	83 ec 14             	sub    $0x14,%esp
  800496:	8b 45 10             	mov    0x10(%ebp),%eax
  800499:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80049c:	8b 45 14             	mov    0x14(%ebp),%eax
  80049f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8004a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004ad:	77 55                	ja     800504 <printnum+0x75>
  8004af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004b2:	72 05                	jb     8004b9 <printnum+0x2a>
  8004b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004b7:	77 4b                	ja     800504 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c7:	52                   	push   %edx
  8004c8:	50                   	push   %eax
  8004c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8004cf:	e8 f0 1c 00 00       	call   8021c4 <__udivdi3>
  8004d4:	83 c4 10             	add    $0x10,%esp
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	ff 75 20             	pushl  0x20(%ebp)
  8004dd:	53                   	push   %ebx
  8004de:	ff 75 18             	pushl  0x18(%ebp)
  8004e1:	52                   	push   %edx
  8004e2:	50                   	push   %eax
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	ff 75 08             	pushl  0x8(%ebp)
  8004e9:	e8 a1 ff ff ff       	call   80048f <printnum>
  8004ee:	83 c4 20             	add    $0x20,%esp
  8004f1:	eb 1a                	jmp    80050d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 20             	pushl  0x20(%ebp)
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	ff d0                	call   *%eax
  800501:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800504:	ff 4d 1c             	decl   0x1c(%ebp)
  800507:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80050b:	7f e6                	jg     8004f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80050d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800510:	bb 00 00 00 00       	mov    $0x0,%ebx
  800515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800518:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80051b:	53                   	push   %ebx
  80051c:	51                   	push   %ecx
  80051d:	52                   	push   %edx
  80051e:	50                   	push   %eax
  80051f:	e8 b0 1d 00 00       	call   8022d4 <__umoddi3>
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	05 b4 27 80 00       	add    $0x8027b4,%eax
  80052c:	8a 00                	mov    (%eax),%al
  80052e:	0f be c0             	movsbl %al,%eax
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	50                   	push   %eax
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	ff d0                	call   *%eax
  80053d:	83 c4 10             	add    $0x10,%esp
}
  800540:	90                   	nop
  800541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800544:	c9                   	leave  
  800545:	c3                   	ret    

00800546 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800549:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80054d:	7e 1c                	jle    80056b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80054f:	8b 45 08             	mov    0x8(%ebp),%eax
  800552:	8b 00                	mov    (%eax),%eax
  800554:	8d 50 08             	lea    0x8(%eax),%edx
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	89 10                	mov    %edx,(%eax)
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	83 e8 08             	sub    $0x8,%eax
  800564:	8b 50 04             	mov    0x4(%eax),%edx
  800567:	8b 00                	mov    (%eax),%eax
  800569:	eb 40                	jmp    8005ab <getuint+0x65>
	else if (lflag)
  80056b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80056f:	74 1e                	je     80058f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	8d 50 04             	lea    0x4(%eax),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	89 10                	mov    %edx,(%eax)
  80057e:	8b 45 08             	mov    0x8(%ebp),%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	83 e8 04             	sub    $0x4,%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	ba 00 00 00 00       	mov    $0x0,%edx
  80058d:	eb 1c                	jmp    8005ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	8d 50 04             	lea    0x4(%eax),%edx
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	89 10                	mov    %edx,(%eax)
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 e8 04             	sub    $0x4,%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ab:	5d                   	pop    %ebp
  8005ac:	c3                   	ret    

008005ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005b4:	7e 1c                	jle    8005d2 <getint+0x25>
		return va_arg(*ap, long long);
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	8d 50 08             	lea    0x8(%eax),%edx
  8005be:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c1:	89 10                	mov    %edx,(%eax)
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	8b 00                	mov    (%eax),%eax
  8005c8:	83 e8 08             	sub    $0x8,%eax
  8005cb:	8b 50 04             	mov    0x4(%eax),%edx
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	eb 38                	jmp    80060a <getint+0x5d>
	else if (lflag)
  8005d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005d6:	74 1a                	je     8005f2 <getint+0x45>
		return va_arg(*ap, long);
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	8d 50 04             	lea    0x4(%eax),%edx
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	89 10                	mov    %edx,(%eax)
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	83 e8 04             	sub    $0x4,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	99                   	cltd   
  8005f0:	eb 18                	jmp    80060a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	8d 50 04             	lea    0x4(%eax),%edx
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	89 10                	mov    %edx,(%eax)
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	83 e8 04             	sub    $0x4,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	99                   	cltd   
}
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    

0080060c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	56                   	push   %esi
  800610:	53                   	push   %ebx
  800611:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800614:	eb 17                	jmp    80062d <vprintfmt+0x21>
			if (ch == '\0')
  800616:	85 db                	test   %ebx,%ebx
  800618:	0f 84 af 03 00 00    	je     8009cd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	ff 75 0c             	pushl  0xc(%ebp)
  800624:	53                   	push   %ebx
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	ff d0                	call   *%eax
  80062a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062d:	8b 45 10             	mov    0x10(%ebp),%eax
  800630:	8d 50 01             	lea    0x1(%eax),%edx
  800633:	89 55 10             	mov    %edx,0x10(%ebp)
  800636:	8a 00                	mov    (%eax),%al
  800638:	0f b6 d8             	movzbl %al,%ebx
  80063b:	83 fb 25             	cmp    $0x25,%ebx
  80063e:	75 d6                	jne    800616 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800640:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800644:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80064b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800652:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800659:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800660:	8b 45 10             	mov    0x10(%ebp),%eax
  800663:	8d 50 01             	lea    0x1(%eax),%edx
  800666:	89 55 10             	mov    %edx,0x10(%ebp)
  800669:	8a 00                	mov    (%eax),%al
  80066b:	0f b6 d8             	movzbl %al,%ebx
  80066e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800671:	83 f8 55             	cmp    $0x55,%eax
  800674:	0f 87 2b 03 00 00    	ja     8009a5 <vprintfmt+0x399>
  80067a:	8b 04 85 d8 27 80 00 	mov    0x8027d8(,%eax,4),%eax
  800681:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800683:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800687:	eb d7                	jmp    800660 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800689:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80068d:	eb d1                	jmp    800660 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80068f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800696:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800699:	89 d0                	mov    %edx,%eax
  80069b:	c1 e0 02             	shl    $0x2,%eax
  80069e:	01 d0                	add    %edx,%eax
  8006a0:	01 c0                	add    %eax,%eax
  8006a2:	01 d8                	add    %ebx,%eax
  8006a4:	83 e8 30             	sub    $0x30,%eax
  8006a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ad:	8a 00                	mov    (%eax),%al
  8006af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8006b5:	7e 3e                	jle    8006f5 <vprintfmt+0xe9>
  8006b7:	83 fb 39             	cmp    $0x39,%ebx
  8006ba:	7f 39                	jg     8006f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006bf:	eb d5                	jmp    800696 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	83 c0 04             	add    $0x4,%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	83 e8 04             	sub    $0x4,%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006d5:	eb 1f                	jmp    8006f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006db:	79 83                	jns    800660 <vprintfmt+0x54>
				width = 0;
  8006dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006e4:	e9 77 ff ff ff       	jmp    800660 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006f0:	e9 6b ff ff ff       	jmp    800660 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fa:	0f 89 60 ff ff ff    	jns    800660 <vprintfmt+0x54>
				width = precision, precision = -1;
  800700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800703:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800706:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80070d:	e9 4e ff ff ff       	jmp    800660 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800712:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800715:	e9 46 ff ff ff       	jmp    800660 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	83 c0 04             	add    $0x4,%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	83 e8 04             	sub    $0x4,%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	50                   	push   %eax
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
			break;
  80073a:	e9 89 02 00 00       	jmp    8009c8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	83 c0 04             	add    $0x4,%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	83 e8 04             	sub    $0x4,%eax
  80074e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800750:	85 db                	test   %ebx,%ebx
  800752:	79 02                	jns    800756 <vprintfmt+0x14a>
				err = -err;
  800754:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800756:	83 fb 64             	cmp    $0x64,%ebx
  800759:	7f 0b                	jg     800766 <vprintfmt+0x15a>
  80075b:	8b 34 9d 20 26 80 00 	mov    0x802620(,%ebx,4),%esi
  800762:	85 f6                	test   %esi,%esi
  800764:	75 19                	jne    80077f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800766:	53                   	push   %ebx
  800767:	68 c5 27 80 00       	push   $0x8027c5
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 08             	pushl  0x8(%ebp)
  800772:	e8 5e 02 00 00       	call   8009d5 <printfmt>
  800777:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80077a:	e9 49 02 00 00       	jmp    8009c8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80077f:	56                   	push   %esi
  800780:	68 ce 27 80 00       	push   $0x8027ce
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	ff 75 08             	pushl  0x8(%ebp)
  80078b:	e8 45 02 00 00       	call   8009d5 <printfmt>
  800790:	83 c4 10             	add    $0x10,%esp
			break;
  800793:	e9 30 02 00 00       	jmp    8009c8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	83 c0 04             	add    $0x4,%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	83 e8 04             	sub    $0x4,%eax
  8007a7:	8b 30                	mov    (%eax),%esi
  8007a9:	85 f6                	test   %esi,%esi
  8007ab:	75 05                	jne    8007b2 <vprintfmt+0x1a6>
				p = "(null)";
  8007ad:	be d1 27 80 00       	mov    $0x8027d1,%esi
			if (width > 0 && padc != '-')
  8007b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b6:	7e 6d                	jle    800825 <vprintfmt+0x219>
  8007b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007bc:	74 67                	je     800825 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	50                   	push   %eax
  8007c5:	56                   	push   %esi
  8007c6:	e8 0c 03 00 00       	call   800ad7 <strnlen>
  8007cb:	83 c4 10             	add    $0x10,%esp
  8007ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007d1:	eb 16                	jmp    8007e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	50                   	push   %eax
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	ff d0                	call   *%eax
  8007e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	7f e4                	jg     8007d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ef:	eb 34                	jmp    800825 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007f5:	74 1c                	je     800813 <vprintfmt+0x207>
  8007f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8007fa:	7e 05                	jle    800801 <vprintfmt+0x1f5>
  8007fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8007ff:	7e 12                	jle    800813 <vprintfmt+0x207>
					putch('?', putdat);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	6a 3f                	push   $0x3f
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	ff d0                	call   *%eax
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	eb 0f                	jmp    800822 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	53                   	push   %ebx
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800822:	ff 4d e4             	decl   -0x1c(%ebp)
  800825:	89 f0                	mov    %esi,%eax
  800827:	8d 70 01             	lea    0x1(%eax),%esi
  80082a:	8a 00                	mov    (%eax),%al
  80082c:	0f be d8             	movsbl %al,%ebx
  80082f:	85 db                	test   %ebx,%ebx
  800831:	74 24                	je     800857 <vprintfmt+0x24b>
  800833:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800837:	78 b8                	js     8007f1 <vprintfmt+0x1e5>
  800839:	ff 4d e0             	decl   -0x20(%ebp)
  80083c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800840:	79 af                	jns    8007f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800842:	eb 13                	jmp    800857 <vprintfmt+0x24b>
				putch(' ', putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	6a 20                	push   $0x20
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800854:	ff 4d e4             	decl   -0x1c(%ebp)
  800857:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80085b:	7f e7                	jg     800844 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80085d:	e9 66 01 00 00       	jmp    8009c8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 e8             	pushl  -0x18(%ebp)
  800868:	8d 45 14             	lea    0x14(%ebp),%eax
  80086b:	50                   	push   %eax
  80086c:	e8 3c fd ff ff       	call   8005ad <getint>
  800871:	83 c4 10             	add    $0x10,%esp
  800874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800877:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80087a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800880:	85 d2                	test   %edx,%edx
  800882:	79 23                	jns    8008a7 <vprintfmt+0x29b>
				putch('-', putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	ff 75 0c             	pushl  0xc(%ebp)
  80088a:	6a 2d                	push   $0x2d
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	ff d0                	call   *%eax
  800891:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089a:	f7 d8                	neg    %eax
  80089c:	83 d2 00             	adc    $0x0,%edx
  80089f:	f7 da                	neg    %edx
  8008a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ae:	e9 bc 00 00 00       	jmp    80096f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8008b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008bc:	50                   	push   %eax
  8008bd:	e8 84 fc ff ff       	call   800546 <getuint>
  8008c2:	83 c4 10             	add    $0x10,%esp
  8008c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d2:	e9 98 00 00 00       	jmp    80096f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	6a 58                	push   $0x58
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	6a 58                	push   $0x58
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	6a 58                	push   $0x58
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	ff d0                	call   *%eax
  800904:	83 c4 10             	add    $0x10,%esp
			break;
  800907:	e9 bc 00 00 00       	jmp    8009c8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	6a 30                	push   $0x30
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	6a 78                	push   $0x78
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	ff d0                	call   *%eax
  800929:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80093d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800940:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800947:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80094e:	eb 1f                	jmp    80096f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	ff 75 e8             	pushl  -0x18(%ebp)
  800956:	8d 45 14             	lea    0x14(%ebp),%eax
  800959:	50                   	push   %eax
  80095a:	e8 e7 fb ff ff       	call   800546 <getuint>
  80095f:	83 c4 10             	add    $0x10,%esp
  800962:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800965:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800968:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80096f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800973:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800976:	83 ec 04             	sub    $0x4,%esp
  800979:	52                   	push   %edx
  80097a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80097d:	50                   	push   %eax
  80097e:	ff 75 f4             	pushl  -0xc(%ebp)
  800981:	ff 75 f0             	pushl  -0x10(%ebp)
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	e8 00 fb ff ff       	call   80048f <printnum>
  80098f:	83 c4 20             	add    $0x20,%esp
			break;
  800992:	eb 34                	jmp    8009c8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	53                   	push   %ebx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	ff d0                	call   *%eax
  8009a0:	83 c4 10             	add    $0x10,%esp
			break;
  8009a3:	eb 23                	jmp    8009c8 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	6a 25                	push   $0x25
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	ff d0                	call   *%eax
  8009b2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b5:	ff 4d 10             	decl   0x10(%ebp)
  8009b8:	eb 03                	jmp    8009bd <vprintfmt+0x3b1>
  8009ba:	ff 4d 10             	decl   0x10(%ebp)
  8009bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c0:	48                   	dec    %eax
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	3c 25                	cmp    $0x25,%al
  8009c5:	75 f3                	jne    8009ba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009c7:	90                   	nop
		}
	}
  8009c8:	e9 47 fc ff ff       	jmp    800614 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009cd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009d1:	5b                   	pop    %ebx
  8009d2:	5e                   	pop    %esi
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009db:	8d 45 10             	lea    0x10(%ebp),%eax
  8009de:	83 c0 04             	add    $0x4,%eax
  8009e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ea:	50                   	push   %eax
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	ff 75 08             	pushl  0x8(%ebp)
  8009f1:	e8 16 fc ff ff       	call   80060c <vprintfmt>
  8009f6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009f9:	90                   	nop
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a02:	8b 40 08             	mov    0x8(%eax),%eax
  800a05:	8d 50 01             	lea    0x1(%eax),%edx
  800a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a11:	8b 10                	mov    (%eax),%edx
  800a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a16:	8b 40 04             	mov    0x4(%eax),%eax
  800a19:	39 c2                	cmp    %eax,%edx
  800a1b:	73 12                	jae    800a2f <sprintputch+0x33>
		*b->buf++ = ch;
  800a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	8d 48 01             	lea    0x1(%eax),%ecx
  800a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a28:	89 0a                	mov    %ecx,(%edx)
  800a2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a2d:	88 10                	mov    %dl,(%eax)
}
  800a2f:	90                   	nop
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	01 d0                	add    %edx,%eax
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a57:	74 06                	je     800a5f <vsnprintf+0x2d>
  800a59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a5d:	7f 07                	jg     800a66 <vsnprintf+0x34>
		return -E_INVAL;
  800a5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800a64:	eb 20                	jmp    800a86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a66:	ff 75 14             	pushl  0x14(%ebp)
  800a69:	ff 75 10             	pushl  0x10(%ebp)
  800a6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a6f:	50                   	push   %eax
  800a70:	68 fc 09 80 00       	push   $0x8009fc
  800a75:	e8 92 fb ff ff       	call   80060c <vprintfmt>
  800a7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a97:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9d:	50                   	push   %eax
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 08             	pushl  0x8(%ebp)
  800aa4:	e8 89 ff ff ff       	call   800a32 <vsnprintf>
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab2:	c9                   	leave  
  800ab3:	c3                   	ret    

00800ab4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ac1:	eb 06                	jmp    800ac9 <strlen+0x15>
		n++;
  800ac3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac6:	ff 45 08             	incl   0x8(%ebp)
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	84 c0                	test   %al,%al
  800ad0:	75 f1                	jne    800ac3 <strlen+0xf>
		n++;
	return n;
  800ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    

00800ad7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800add:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae4:	eb 09                	jmp    800aef <strnlen+0x18>
		n++;
  800ae6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae9:	ff 45 08             	incl   0x8(%ebp)
  800aec:	ff 4d 0c             	decl   0xc(%ebp)
  800aef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af3:	74 09                	je     800afe <strnlen+0x27>
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8a 00                	mov    (%eax),%al
  800afa:	84 c0                	test   %al,%al
  800afc:	75 e8                	jne    800ae6 <strnlen+0xf>
		n++;
	return n;
  800afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b0f:	90                   	nop
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8d 50 01             	lea    0x1(%eax),%edx
  800b16:	89 55 08             	mov    %edx,0x8(%ebp)
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b22:	8a 12                	mov    (%edx),%dl
  800b24:	88 10                	mov    %dl,(%eax)
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	84 c0                	test   %al,%al
  800b2a:	75 e4                	jne    800b10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b44:	eb 1f                	jmp    800b65 <strncpy+0x34>
		*dst++ = *src;
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b52:	8a 12                	mov    (%edx),%dl
  800b54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	84 c0                	test   %al,%al
  800b5d:	74 03                	je     800b62 <strncpy+0x31>
			src++;
  800b5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b62:	ff 45 fc             	incl   -0x4(%ebp)
  800b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b6b:	72 d9                	jb     800b46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b70:	c9                   	leave  
  800b71:	c3                   	ret    

00800b72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b82:	74 30                	je     800bb4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b84:	eb 16                	jmp    800b9c <strlcpy+0x2a>
			*dst++ = *src++;
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8d 50 01             	lea    0x1(%eax),%edx
  800b8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b98:	8a 12                	mov    (%edx),%dl
  800b9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b9c:	ff 4d 10             	decl   0x10(%ebp)
  800b9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba3:	74 09                	je     800bae <strlcpy+0x3c>
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	84 c0                	test   %al,%al
  800bac:	75 d8                	jne    800b86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bba:	29 c2                	sub    %eax,%edx
  800bbc:	89 d0                	mov    %edx,%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bc3:	eb 06                	jmp    800bcb <strcmp+0xb>
		p++, q++;
  800bc5:	ff 45 08             	incl   0x8(%ebp)
  800bc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8a 00                	mov    (%eax),%al
  800bd0:	84 c0                	test   %al,%al
  800bd2:	74 0e                	je     800be2 <strcmp+0x22>
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8a 10                	mov    (%eax),%dl
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8a 00                	mov    (%eax),%al
  800bde:	38 c2                	cmp    %al,%dl
  800be0:	74 e3                	je     800bc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8a 00                	mov    (%eax),%al
  800be7:	0f b6 d0             	movzbl %al,%edx
  800bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bed:	8a 00                	mov    (%eax),%al
  800bef:	0f b6 c0             	movzbl %al,%eax
  800bf2:	29 c2                	sub    %eax,%edx
  800bf4:	89 d0                	mov    %edx,%eax
}
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bfb:	eb 09                	jmp    800c06 <strncmp+0xe>
		n--, p++, q++;
  800bfd:	ff 4d 10             	decl   0x10(%ebp)
  800c00:	ff 45 08             	incl   0x8(%ebp)
  800c03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c0a:	74 17                	je     800c23 <strncmp+0x2b>
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8a 00                	mov    (%eax),%al
  800c11:	84 c0                	test   %al,%al
  800c13:	74 0e                	je     800c23 <strncmp+0x2b>
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	8a 10                	mov    (%eax),%dl
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	8a 00                	mov    (%eax),%al
  800c1f:	38 c2                	cmp    %al,%dl
  800c21:	74 da                	je     800bfd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c27:	75 07                	jne    800c30 <strncmp+0x38>
		return 0;
  800c29:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2e:	eb 14                	jmp    800c44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	0f b6 d0             	movzbl %al,%edx
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	8a 00                	mov    (%eax),%al
  800c3d:	0f b6 c0             	movzbl %al,%eax
  800c40:	29 c2                	sub    %eax,%edx
  800c42:	89 d0                	mov    %edx,%eax
}
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 04             	sub    $0x4,%esp
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c52:	eb 12                	jmp    800c66 <strchr+0x20>
		if (*s == c)
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c5c:	75 05                	jne    800c63 <strchr+0x1d>
			return (char *) s;
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	eb 11                	jmp    800c74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c63:	ff 45 08             	incl   0x8(%ebp)
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8a 00                	mov    (%eax),%al
  800c6b:	84 c0                	test   %al,%al
  800c6d:	75 e5                	jne    800c54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 04             	sub    $0x4,%esp
  800c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c82:	eb 0d                	jmp    800c91 <strfind+0x1b>
		if (*s == c)
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c8c:	74 0e                	je     800c9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c8e:	ff 45 08             	incl   0x8(%ebp)
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	84 c0                	test   %al,%al
  800c98:	75 ea                	jne    800c84 <strfind+0xe>
  800c9a:	eb 01                	jmp    800c9d <strfind+0x27>
		if (*s == c)
			break;
  800c9c:	90                   	nop
	return (char *) s;
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca0:	c9                   	leave  
  800ca1:	c3                   	ret    

00800ca2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cae:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cb4:	eb 0e                	jmp    800cc4 <memset+0x22>
		*p++ = c;
  800cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb9:	8d 50 01             	lea    0x1(%eax),%edx
  800cbc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cc4:	ff 4d f8             	decl   -0x8(%ebp)
  800cc7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ccb:	79 e9                	jns    800cb6 <memset+0x14>
		*p++ = c;

	return v;
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ce4:	eb 16                	jmp    800cfc <memcpy+0x2a>
		*d++ = *s++;
  800ce6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce9:	8d 50 01             	lea    0x1(%eax),%edx
  800cec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cf2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cf8:	8a 12                	mov    (%edx),%dl
  800cfa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d02:	89 55 10             	mov    %edx,0x10(%ebp)
  800d05:	85 c0                	test   %eax,%eax
  800d07:	75 dd                	jne    800ce6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d26:	73 50                	jae    800d78 <memmove+0x6a>
  800d28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2e:	01 d0                	add    %edx,%eax
  800d30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d33:	76 43                	jbe    800d78 <memmove+0x6a>
		s += n;
  800d35:	8b 45 10             	mov    0x10(%ebp),%eax
  800d38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d41:	eb 10                	jmp    800d53 <memmove+0x45>
			*--d = *--s;
  800d43:	ff 4d f8             	decl   -0x8(%ebp)
  800d46:	ff 4d fc             	decl   -0x4(%ebp)
  800d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4c:	8a 10                	mov    (%eax),%dl
  800d4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d59:	89 55 10             	mov    %edx,0x10(%ebp)
  800d5c:	85 c0                	test   %eax,%eax
  800d5e:	75 e3                	jne    800d43 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d60:	eb 23                	jmp    800d85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d65:	8d 50 01             	lea    0x1(%eax),%edx
  800d68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d74:	8a 12                	mov    (%edx),%dl
  800d76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d78:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d81:	85 c0                	test   %eax,%eax
  800d83:	75 dd                	jne    800d62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d9c:	eb 2a                	jmp    800dc8 <memcmp+0x3e>
		if (*s1 != *s2)
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da1:	8a 10                	mov    (%eax),%dl
  800da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	38 c2                	cmp    %al,%dl
  800daa:	74 16                	je     800dc2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	0f b6 d0             	movzbl %al,%edx
  800db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	0f b6 c0             	movzbl %al,%eax
  800dbc:	29 c2                	sub    %eax,%edx
  800dbe:	89 d0                	mov    %edx,%eax
  800dc0:	eb 18                	jmp    800dda <memcmp+0x50>
		s1++, s2++;
  800dc2:	ff 45 fc             	incl   -0x4(%ebp)
  800dc5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dce:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	75 c9                	jne    800d9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	8b 45 10             	mov    0x10(%ebp),%eax
  800de8:	01 d0                	add    %edx,%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ded:	eb 15                	jmp    800e04 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 d0             	movzbl %al,%edx
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	0f b6 c0             	movzbl %al,%eax
  800dfd:	39 c2                	cmp    %eax,%edx
  800dff:	74 0d                	je     800e0e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e01:	ff 45 08             	incl   0x8(%ebp)
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e0a:	72 e3                	jb     800def <memfind+0x13>
  800e0c:	eb 01                	jmp    800e0f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e0e:	90                   	nop
	return (void *) s;
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e21:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e28:	eb 03                	jmp    800e2d <strtol+0x19>
		s++;
  800e2a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	3c 20                	cmp    $0x20,%al
  800e34:	74 f4                	je     800e2a <strtol+0x16>
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	3c 09                	cmp    $0x9,%al
  800e3d:	74 eb                	je     800e2a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	3c 2b                	cmp    $0x2b,%al
  800e46:	75 05                	jne    800e4d <strtol+0x39>
		s++;
  800e48:	ff 45 08             	incl   0x8(%ebp)
  800e4b:	eb 13                	jmp    800e60 <strtol+0x4c>
	else if (*s == '-')
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	3c 2d                	cmp    $0x2d,%al
  800e54:	75 0a                	jne    800e60 <strtol+0x4c>
		s++, neg = 1;
  800e56:	ff 45 08             	incl   0x8(%ebp)
  800e59:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e64:	74 06                	je     800e6c <strtol+0x58>
  800e66:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e6a:	75 20                	jne    800e8c <strtol+0x78>
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	3c 30                	cmp    $0x30,%al
  800e73:	75 17                	jne    800e8c <strtol+0x78>
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	40                   	inc    %eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	3c 78                	cmp    $0x78,%al
  800e7d:	75 0d                	jne    800e8c <strtol+0x78>
		s += 2, base = 16;
  800e7f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e83:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e8a:	eb 28                	jmp    800eb4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e90:	75 15                	jne    800ea7 <strtol+0x93>
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	3c 30                	cmp    $0x30,%al
  800e99:	75 0c                	jne    800ea7 <strtol+0x93>
		s++, base = 8;
  800e9b:	ff 45 08             	incl   0x8(%ebp)
  800e9e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ea5:	eb 0d                	jmp    800eb4 <strtol+0xa0>
	else if (base == 0)
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	75 07                	jne    800eb4 <strtol+0xa0>
		base = 10;
  800ead:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	3c 2f                	cmp    $0x2f,%al
  800ebb:	7e 19                	jle    800ed6 <strtol+0xc2>
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	3c 39                	cmp    $0x39,%al
  800ec4:	7f 10                	jg     800ed6 <strtol+0xc2>
			dig = *s - '0';
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f be c0             	movsbl %al,%eax
  800ece:	83 e8 30             	sub    $0x30,%eax
  800ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ed4:	eb 42                	jmp    800f18 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	3c 60                	cmp    $0x60,%al
  800edd:	7e 19                	jle    800ef8 <strtol+0xe4>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	3c 7a                	cmp    $0x7a,%al
  800ee6:	7f 10                	jg     800ef8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f be c0             	movsbl %al,%eax
  800ef0:	83 e8 57             	sub    $0x57,%eax
  800ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef6:	eb 20                	jmp    800f18 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3c 40                	cmp    $0x40,%al
  800eff:	7e 39                	jle    800f3a <strtol+0x126>
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	3c 5a                	cmp    $0x5a,%al
  800f08:	7f 30                	jg     800f3a <strtol+0x126>
			dig = *s - 'A' + 10;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	0f be c0             	movsbl %al,%eax
  800f12:	83 e8 37             	sub    $0x37,%eax
  800f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f1b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f1e:	7d 19                	jge    800f39 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f20:	ff 45 08             	incl   0x8(%ebp)
  800f23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f26:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f2a:	89 c2                	mov    %eax,%edx
  800f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f2f:	01 d0                	add    %edx,%eax
  800f31:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f34:	e9 7b ff ff ff       	jmp    800eb4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f39:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f3e:	74 08                	je     800f48 <strtol+0x134>
		*endptr = (char *) s;
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f48:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f4c:	74 07                	je     800f55 <strtol+0x141>
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	f7 d8                	neg    %eax
  800f53:	eb 03                	jmp    800f58 <strtol+0x144>
  800f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <ltostr>:

void
ltostr(long value, char *str)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f72:	79 13                	jns    800f87 <ltostr+0x2d>
	{
		neg = 1;
  800f74:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f81:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f84:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f8f:	99                   	cltd   
  800f90:	f7 f9                	idiv   %ecx
  800f92:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f98:	8d 50 01             	lea    0x1(%eax),%edx
  800f9b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f9e:	89 c2                	mov    %eax,%edx
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	01 d0                	add    %edx,%eax
  800fa5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fa8:	83 c2 30             	add    $0x30,%edx
  800fab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fb5:	f7 e9                	imul   %ecx
  800fb7:	c1 fa 02             	sar    $0x2,%edx
  800fba:	89 c8                	mov    %ecx,%eax
  800fbc:	c1 f8 1f             	sar    $0x1f,%eax
  800fbf:	29 c2                	sub    %eax,%edx
  800fc1:	89 d0                	mov    %edx,%eax
  800fc3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fce:	f7 e9                	imul   %ecx
  800fd0:	c1 fa 02             	sar    $0x2,%edx
  800fd3:	89 c8                	mov    %ecx,%eax
  800fd5:	c1 f8 1f             	sar    $0x1f,%eax
  800fd8:	29 c2                	sub    %eax,%edx
  800fda:	89 d0                	mov    %edx,%eax
  800fdc:	c1 e0 02             	shl    $0x2,%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	01 c0                	add    %eax,%eax
  800fe3:	29 c1                	sub    %eax,%ecx
  800fe5:	89 ca                	mov    %ecx,%edx
  800fe7:	85 d2                	test   %edx,%edx
  800fe9:	75 9c                	jne    800f87 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800feb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800ff2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff5:	48                   	dec    %eax
  800ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ff9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ffd:	74 3d                	je     80103c <ltostr+0xe2>
		start = 1 ;
  800fff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801006:	eb 34                	jmp    80103c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801008:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100e:	01 d0                	add    %edx,%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	01 c2                	add    %eax,%edx
  80101d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	01 c8                	add    %ecx,%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801029:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	01 c2                	add    %eax,%edx
  801031:	8a 45 eb             	mov    -0x15(%ebp),%al
  801034:	88 02                	mov    %al,(%edx)
		start++ ;
  801036:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801039:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80103c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801042:	7c c4                	jl     801008 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801044:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	01 d0                	add    %edx,%eax
  80104c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80104f:	90                   	nop
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801058:	ff 75 08             	pushl  0x8(%ebp)
  80105b:	e8 54 fa ff ff       	call   800ab4 <strlen>
  801060:	83 c4 04             	add    $0x4,%esp
  801063:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801066:	ff 75 0c             	pushl  0xc(%ebp)
  801069:	e8 46 fa ff ff       	call   800ab4 <strlen>
  80106e:	83 c4 04             	add    $0x4,%esp
  801071:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801074:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80107b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801082:	eb 17                	jmp    80109b <strcconcat+0x49>
		final[s] = str1[s] ;
  801084:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	01 c2                	add    %eax,%edx
  80108c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	01 c8                	add    %ecx,%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801098:	ff 45 fc             	incl   -0x4(%ebp)
  80109b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010a1:	7c e1                	jl     801084 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010b1:	eb 1f                	jmp    8010d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b6:	8d 50 01             	lea    0x1(%eax),%edx
  8010b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010bc:	89 c2                	mov    %eax,%edx
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	01 c2                	add    %eax,%edx
  8010c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	01 c8                	add    %ecx,%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010cf:	ff 45 f8             	incl   -0x8(%ebp)
  8010d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010d8:	7c d9                	jl     8010b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8010e5:	90                   	nop
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f7:	8b 00                	mov    (%eax),%eax
  8010f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 d0                	add    %edx,%eax
  801105:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80110b:	eb 0c                	jmp    801119 <strsplit+0x31>
			*string++ = 0;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8d 50 01             	lea    0x1(%eax),%edx
  801113:	89 55 08             	mov    %edx,0x8(%ebp)
  801116:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	84 c0                	test   %al,%al
  801120:	74 18                	je     80113a <strsplit+0x52>
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	0f be c0             	movsbl %al,%eax
  80112a:	50                   	push   %eax
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	e8 13 fb ff ff       	call   800c46 <strchr>
  801133:	83 c4 08             	add    $0x8,%esp
  801136:	85 c0                	test   %eax,%eax
  801138:	75 d3                	jne    80110d <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	84 c0                	test   %al,%al
  801141:	74 5a                	je     80119d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801143:	8b 45 14             	mov    0x14(%ebp),%eax
  801146:	8b 00                	mov    (%eax),%eax
  801148:	83 f8 0f             	cmp    $0xf,%eax
  80114b:	75 07                	jne    801154 <strsplit+0x6c>
		{
			return 0;
  80114d:	b8 00 00 00 00       	mov    $0x0,%eax
  801152:	eb 66                	jmp    8011ba <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801154:	8b 45 14             	mov    0x14(%ebp),%eax
  801157:	8b 00                	mov    (%eax),%eax
  801159:	8d 48 01             	lea    0x1(%eax),%ecx
  80115c:	8b 55 14             	mov    0x14(%ebp),%edx
  80115f:	89 0a                	mov    %ecx,(%edx)
  801161:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801168:	8b 45 10             	mov    0x10(%ebp),%eax
  80116b:	01 c2                	add    %eax,%edx
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801172:	eb 03                	jmp    801177 <strsplit+0x8f>
			string++;
  801174:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	84 c0                	test   %al,%al
  80117e:	74 8b                	je     80110b <strsplit+0x23>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	50                   	push   %eax
  801189:	ff 75 0c             	pushl  0xc(%ebp)
  80118c:	e8 b5 fa ff ff       	call   800c46 <strchr>
  801191:	83 c4 08             	add    $0x8,%esp
  801194:	85 c0                	test   %eax,%eax
  801196:	74 dc                	je     801174 <strsplit+0x8c>
			string++;
	}
  801198:	e9 6e ff ff ff       	jmp    80110b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80119d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80119e:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a1:	8b 00                	mov    (%eax),%eax
  8011a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  8011c5:	e8 7d 0f 00 00       	call   802147 <sys_isUHeapPlacementStrategyNEXTFIT>
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	0f 84 6f 03 00 00    	je     801541 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  8011d2:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  8011d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011dc:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	48                   	dec    %eax
  8011e2:	89 45 80             	mov    %eax,-0x80(%ebp)
  8011e5:	8b 45 80             	mov    -0x80(%ebp),%eax
  8011e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ed:	f7 75 84             	divl   -0x7c(%ebp)
  8011f0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8011f3:	29 d0                	sub    %edx,%eax
  8011f5:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8011f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fc:	74 09                	je     801207 <malloc+0x4b>
  8011fe:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801205:	76 0a                	jbe    801211 <malloc+0x55>
			return NULL;
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
  80120c:	e9 4b 09 00 00       	jmp    801b5c <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801211:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	01 d0                	add    %edx,%eax
  80121c:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801221:	0f 87 a2 00 00 00    	ja     8012c9 <malloc+0x10d>
  801227:	a1 40 30 98 00       	mov    0x983040,%eax
  80122c:	85 c0                	test   %eax,%eax
  80122e:	0f 85 95 00 00 00    	jne    8012c9 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801234:	a1 04 30 80 00       	mov    0x803004,%eax
  801239:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  80123f:	a1 04 30 80 00       	mov    0x803004,%eax
  801244:	83 ec 08             	sub    $0x8,%esp
  801247:	ff 75 08             	pushl  0x8(%ebp)
  80124a:	50                   	push   %eax
  80124b:	e8 a3 0b 00 00       	call   801df3 <sys_allocateMem>
  801250:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801253:	a1 20 30 80 00       	mov    0x803020,%eax
  801258:	8b 55 08             	mov    0x8(%ebp),%edx
  80125b:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801262:	a1 20 30 80 00       	mov    0x803020,%eax
  801267:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80126d:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
			cnt_mem++;
  801274:	a1 20 30 80 00       	mov    0x803020,%eax
  801279:	40                   	inc    %eax
  80127a:	a3 20 30 80 00       	mov    %eax,0x803020
			int i = 0;
  80127f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801286:	eb 2e                	jmp    8012b6 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801288:	a1 04 30 80 00       	mov    0x803004,%eax
  80128d:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801292:	c1 e8 0c             	shr    $0xc,%eax
  801295:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  80129c:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8012a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8012a5:	05 00 10 00 00       	add    $0x1000,%eax
  8012aa:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8012af:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8012b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8012bc:	72 ca                	jb     801288 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  8012be:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8012c4:	e9 93 08 00 00       	jmp    801b5c <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  8012c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  8012d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  8012d7:	a1 40 30 98 00       	mov    0x983040,%eax
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	75 1d                	jne    8012fd <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  8012e0:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  8012e7:	00 00 80 
				check = 1;
  8012ea:	c7 05 40 30 98 00 01 	movl   $0x1,0x983040
  8012f1:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  8012f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  8012fb:	eb 08                	jmp    801305 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  8012fd:	a1 04 30 80 00       	mov    0x803004,%eax
  801302:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801305:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  80130c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801313:	a1 04 30 80 00       	mov    0x803004,%eax
  801318:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80131b:	eb 4d                	jmp    80136a <malloc+0x1ae>
				if (sz == size) {
  80131d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801320:	3b 45 08             	cmp    0x8(%ebp),%eax
  801323:	75 09                	jne    80132e <malloc+0x172>
					f = 1;
  801325:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80132c:	eb 45                	jmp    801373 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80132e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801331:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801336:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801339:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801340:	85 c0                	test   %eax,%eax
  801342:	75 10                	jne    801354 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801344:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80134b:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801352:	eb 16                	jmp    80136a <malloc+0x1ae>
				} else {
					sz = 0;
  801354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80135b:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801365:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  80136a:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801371:	76 aa                	jbe    80131d <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801373:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801377:	0f 84 95 00 00 00    	je     801412 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  80137d:	a1 04 30 80 00       	mov    0x803004,%eax
  801382:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801388:	a1 04 30 80 00       	mov    0x803004,%eax
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 08             	pushl  0x8(%ebp)
  801393:	50                   	push   %eax
  801394:	e8 5a 0a 00 00       	call   801df3 <sys_allocateMem>
  801399:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  80139c:	a1 20 30 80 00       	mov    0x803020,%eax
  8013a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a4:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8013ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8013b0:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8013b6:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  8013bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8013c2:	40                   	inc    %eax
  8013c3:	a3 20 30 80 00       	mov    %eax,0x803020
				int i = 0;
  8013c8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8013cf:	eb 2e                	jmp    8013ff <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8013d1:	a1 04 30 80 00       	mov    0x803004,%eax
  8013d6:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8013db:	c1 e8 0c             	shr    $0xc,%eax
  8013de:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8013e5:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  8013e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8013ee:	05 00 10 00 00       	add    $0x1000,%eax
  8013f3:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8013f8:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8013ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801402:	3b 45 08             	cmp    0x8(%ebp),%eax
  801405:	72 ca                	jb     8013d1 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801407:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80140d:	e9 4a 07 00 00       	jmp    801b5c <malloc+0x9a0>

			} else {

				if (check_start) {
  801412:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801416:	74 0a                	je     801422 <malloc+0x266>

					return NULL;
  801418:	b8 00 00 00 00       	mov    $0x0,%eax
  80141d:	e9 3a 07 00 00       	jmp    801b5c <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801422:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801429:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801430:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801437:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  80143e:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801441:	eb 4d                	jmp    801490 <malloc+0x2d4>
					if (sz == size) {
  801443:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801446:	3b 45 08             	cmp    0x8(%ebp),%eax
  801449:	75 09                	jne    801454 <malloc+0x298>
						f = 1;
  80144b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801452:	eb 44                	jmp    801498 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801454:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801457:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  80145c:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80145f:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801466:	85 c0                	test   %eax,%eax
  801468:	75 10                	jne    80147a <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  80146a:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801471:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801478:	eb 16                	jmp    801490 <malloc+0x2d4>
					} else {
						sz = 0;
  80147a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801481:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801488:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80148b:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801493:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801496:	72 ab                	jb     801443 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801498:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80149c:	0f 84 95 00 00 00    	je     801537 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  8014a2:	a1 04 30 80 00       	mov    0x803004,%eax
  8014a7:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  8014ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	ff 75 08             	pushl  0x8(%ebp)
  8014b8:	50                   	push   %eax
  8014b9:	e8 35 09 00 00       	call   801df3 <sys_allocateMem>
  8014be:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  8014c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8014c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c9:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8014d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8014d5:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8014db:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
					cnt_mem++;
  8014e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8014e7:	40                   	inc    %eax
  8014e8:	a3 20 30 80 00       	mov    %eax,0x803020
					int i = 0;
  8014ed:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  8014f4:	eb 2e                	jmp    801524 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8014f6:	a1 04 30 80 00       	mov    0x803004,%eax
  8014fb:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801500:	c1 e8 0c             	shr    $0xc,%eax
  801503:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  80150a:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  80150e:	a1 04 30 80 00       	mov    0x803004,%eax
  801513:	05 00 10 00 00       	add    $0x1000,%eax
  801518:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  80151d:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801524:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801527:	3b 45 08             	cmp    0x8(%ebp),%eax
  80152a:	72 ca                	jb     8014f6 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  80152c:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801532:	e9 25 06 00 00       	jmp    801b5c <malloc+0x9a0>

				} else {

					return NULL;
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
  80153c:	e9 1b 06 00 00       	jmp    801b5c <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801541:	e8 d0 0b 00 00       	call   802116 <sys_isUHeapPlacementStrategyBESTFIT>
  801546:	85 c0                	test   %eax,%eax
  801548:	0f 84 ba 01 00 00    	je     801708 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  80154e:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801555:	10 00 00 
  801558:	8b 55 08             	mov    0x8(%ebp),%edx
  80155b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801561:	01 d0                	add    %edx,%eax
  801563:	48                   	dec    %eax
  801564:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80156a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801570:	ba 00 00 00 00       	mov    $0x0,%edx
  801575:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  80157b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801581:	29 d0                	sub    %edx,%eax
  801583:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801586:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158a:	74 09                	je     801595 <malloc+0x3d9>
  80158c:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801593:	76 0a                	jbe    80159f <malloc+0x3e3>
			return NULL;
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
  80159a:	e9 bd 05 00 00       	jmp    801b5c <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  80159f:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  8015a6:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  8015ad:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  8015b4:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  8015bb:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	c1 e8 0c             	shr    $0xc,%eax
  8015c8:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  8015ce:	e9 80 00 00 00       	jmp    801653 <malloc+0x497>

			if (heap_mem[i] == 0) {
  8015d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8015d6:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	75 0c                	jne    8015ed <malloc+0x431>

				count++;
  8015e1:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  8015e4:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8015eb:	eb 2d                	jmp    80161a <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  8015ed:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8015f3:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8015f6:	77 14                	ja     80160c <malloc+0x450>
  8015f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015fb:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8015fe:	76 0c                	jbe    80160c <malloc+0x450>

					min_sz = count;
  801600:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801603:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801606:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801609:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  80160c:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801613:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  80161a:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801621:	75 2d                	jne    801650 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801623:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801629:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80162c:	77 22                	ja     801650 <malloc+0x494>
  80162e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801631:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801634:	76 1a                	jbe    801650 <malloc+0x494>

					min_sz = count;
  801636:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801639:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  80163c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80163f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801642:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801649:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801650:	ff 45 b8             	incl   -0x48(%ebp)
  801653:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801656:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  80165b:	0f 86 72 ff ff ff    	jbe    8015d3 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801661:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801667:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  80166a:	77 06                	ja     801672 <malloc+0x4b6>
  80166c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801670:	75 0a                	jne    80167c <malloc+0x4c0>
			return NULL;
  801672:	b8 00 00 00 00       	mov    $0x0,%eax
  801677:	e9 e0 04 00 00       	jmp    801b5c <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  80167c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80167f:	c1 e0 0c             	shl    $0xc,%eax
  801682:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801685:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801688:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  80168e:	83 ec 08             	sub    $0x8,%esp
  801691:	ff 75 08             	pushl  0x8(%ebp)
  801694:	ff 75 c4             	pushl  -0x3c(%ebp)
  801697:	e8 57 07 00 00       	call   801df3 <sys_allocateMem>
  80169c:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80169f:	a1 20 30 80 00       	mov    0x803020,%eax
  8016a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a7:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8016ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8016b3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8016b6:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  8016bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8016c2:	40                   	inc    %eax
  8016c3:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  8016c8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8016cf:	eb 24                	jmp    8016f5 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8016d1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016d4:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8016d9:	c1 e8 0c             	shr    $0xc,%eax
  8016dc:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8016e3:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  8016e7:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8016ee:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  8016f5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8016fb:	72 d4                	jb     8016d1 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8016fd:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801703:	e9 54 04 00 00       	jmp    801b5c <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801708:	e8 d8 09 00 00       	call   8020e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170d:	85 c0                	test   %eax,%eax
  80170f:	0f 84 88 01 00 00    	je     80189d <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801715:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  80171c:	10 00 00 
  80171f:	8b 55 08             	mov    0x8(%ebp),%edx
  801722:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801728:	01 d0                	add    %edx,%eax
  80172a:	48                   	dec    %eax
  80172b:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801731:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801737:	ba 00 00 00 00       	mov    $0x0,%edx
  80173c:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801742:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801748:	29 d0                	sub    %edx,%eax
  80174a:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80174d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801751:	74 09                	je     80175c <malloc+0x5a0>
  801753:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80175a:	76 0a                	jbe    801766 <malloc+0x5aa>
			return NULL;
  80175c:	b8 00 00 00 00       	mov    $0x0,%eax
  801761:	e9 f6 03 00 00       	jmp    801b5c <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801766:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  80176d:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801774:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  80177b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801782:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	c1 e8 0c             	shr    $0xc,%eax
  80178f:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801795:	eb 5a                	jmp    8017f1 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801797:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80179a:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	75 0c                	jne    8017b1 <malloc+0x5f5>

				count++;
  8017a5:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  8017a8:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  8017af:	eb 22                	jmp    8017d3 <malloc+0x617>
			} else {
				if (num_p <= count) {
  8017b1:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8017b7:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  8017ba:	77 09                	ja     8017c5 <malloc+0x609>

					found = 1;
  8017bc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  8017c3:	eb 36                	jmp    8017fb <malloc+0x63f>
				}
				count = 0;
  8017c5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  8017cc:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  8017d3:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  8017da:	75 12                	jne    8017ee <malloc+0x632>

				if (num_p <= count) {
  8017dc:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8017e2:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  8017e5:	77 07                	ja     8017ee <malloc+0x632>

					found = 1;
  8017e7:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  8017ee:	ff 45 a4             	incl   -0x5c(%ebp)
  8017f1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8017f4:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8017f9:	76 9c                	jbe    801797 <malloc+0x5db>

			}

		}

		if (!found) {
  8017fb:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  8017ff:	75 0a                	jne    80180b <malloc+0x64f>
			return NULL;
  801801:	b8 00 00 00 00       	mov    $0x0,%eax
  801806:	e9 51 03 00 00       	jmp    801b5c <malloc+0x9a0>

		}

		temp = ptr;
  80180b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80180e:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801811:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801814:	c1 e0 0c             	shl    $0xc,%eax
  801817:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  80181a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80181d:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801823:	83 ec 08             	sub    $0x8,%esp
  801826:	ff 75 08             	pushl  0x8(%ebp)
  801829:	ff 75 b0             	pushl  -0x50(%ebp)
  80182c:	e8 c2 05 00 00       	call   801df3 <sys_allocateMem>
  801831:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801834:	a1 20 30 80 00       	mov    0x803020,%eax
  801839:	8b 55 08             	mov    0x8(%ebp),%edx
  80183c:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801843:	a1 20 30 80 00       	mov    0x803020,%eax
  801848:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80184b:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801852:	a1 20 30 80 00       	mov    0x803020,%eax
  801857:	40                   	inc    %eax
  801858:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  80185d:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801864:	eb 24                	jmp    80188a <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801866:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801869:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80186e:	c1 e8 0c             	shr    $0xc,%eax
  801871:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801878:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  80187c:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801883:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  80188a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80188d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801890:	72 d4                	jb     801866 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801892:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801898:	e9 bf 02 00 00       	jmp    801b5c <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  80189d:	e8 d6 08 00 00       	call   802178 <sys_isUHeapPlacementStrategyWORSTFIT>
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	0f 84 ba 01 00 00    	je     801a64 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  8018aa:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  8018b1:	10 00 00 
  8018b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b7:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8018bd:	01 d0                	add    %edx,%eax
  8018bf:	48                   	dec    %eax
  8018c0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  8018c6:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8018cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d1:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  8018d7:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8018dd:	29 d0                	sub    %edx,%eax
  8018df:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8018e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018e6:	74 09                	je     8018f1 <malloc+0x735>
  8018e8:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8018ef:	76 0a                	jbe    8018fb <malloc+0x73f>
					return NULL;
  8018f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f6:	e9 61 02 00 00       	jmp    801b5c <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  8018fb:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801902:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801909:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801910:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801917:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	c1 e8 0c             	shr    $0xc,%eax
  801924:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  80192a:	e9 80 00 00 00       	jmp    8019af <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  80192f:	8b 45 90             	mov    -0x70(%ebp),%eax
  801932:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801939:	85 c0                	test   %eax,%eax
  80193b:	75 0c                	jne    801949 <malloc+0x78d>

						count++;
  80193d:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801940:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801947:	eb 2d                	jmp    801976 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801949:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80194f:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801952:	77 14                	ja     801968 <malloc+0x7ac>
  801954:	8b 45 98             	mov    -0x68(%ebp),%eax
  801957:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80195a:	73 0c                	jae    801968 <malloc+0x7ac>

							max_sz = count;
  80195c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80195f:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801962:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801965:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801968:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  80196f:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801976:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  80197d:	75 2d                	jne    8019ac <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  80197f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801985:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801988:	77 22                	ja     8019ac <malloc+0x7f0>
  80198a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80198d:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801990:	76 1a                	jbe    8019ac <malloc+0x7f0>

							max_sz = count;
  801992:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801995:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801998:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80199b:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  80199e:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  8019a5:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8019ac:	ff 45 90             	incl   -0x70(%ebp)
  8019af:	8b 45 90             	mov    -0x70(%ebp),%eax
  8019b2:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8019b7:	0f 86 72 ff ff ff    	jbe    80192f <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  8019bd:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8019c3:	3b 45 98             	cmp    -0x68(%ebp),%eax
  8019c6:	77 06                	ja     8019ce <malloc+0x812>
  8019c8:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8019cc:	75 0a                	jne    8019d8 <malloc+0x81c>
					return NULL;
  8019ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d3:	e9 84 01 00 00       	jmp    801b5c <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  8019d8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8019db:	c1 e0 0c             	shl    $0xc,%eax
  8019de:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  8019e1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8019e4:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  8019ea:	83 ec 08             	sub    $0x8,%esp
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	ff 75 9c             	pushl  -0x64(%ebp)
  8019f3:	e8 fb 03 00 00       	call   801df3 <sys_allocateMem>
  8019f8:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8019fb:	a1 20 30 80 00       	mov    0x803020,%eax
  801a00:	8b 55 08             	mov    0x8(%ebp),%edx
  801a03:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801a0a:	a1 20 30 80 00       	mov    0x803020,%eax
  801a0f:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801a12:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801a19:	a1 20 30 80 00       	mov    0x803020,%eax
  801a1e:	40                   	inc    %eax
  801a1f:	a3 20 30 80 00       	mov    %eax,0x803020
				i = 0;
  801a24:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801a2b:	eb 24                	jmp    801a51 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801a2d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801a30:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801a35:	c1 e8 0c             	shr    $0xc,%eax
  801a38:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801a3f:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801a43:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801a4a:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801a51:	8b 45 90             	mov    -0x70(%ebp),%eax
  801a54:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a57:	72 d4                	jb     801a2d <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801a59:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801a5f:	e9 f8 00 00 00       	jmp    801b5c <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801a64:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801a6b:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  801a72:	10 00 00 
  801a75:	8b 55 08             	mov    0x8(%ebp),%edx
  801a78:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801a7e:	01 d0                	add    %edx,%eax
  801a80:	48                   	dec    %eax
  801a81:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  801a87:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a92:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  801a98:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801a9e:	29 d0                	sub    %edx,%eax
  801aa0:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801aa3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aa7:	74 09                	je     801ab2 <malloc+0x8f6>
  801aa9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ab0:	76 0a                	jbe    801abc <malloc+0x900>
		return NULL;
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab7:	e9 a0 00 00 00       	jmp    801b5c <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  801abc:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	01 d0                	add    %edx,%eax
  801ac7:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801acc:	0f 87 87 00 00 00    	ja     801b59 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  801ad2:	a1 04 30 80 00       	mov    0x803004,%eax
  801ad7:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  801ada:	a1 04 30 80 00       	mov    0x803004,%eax
  801adf:	83 ec 08             	sub    $0x8,%esp
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	50                   	push   %eax
  801ae6:	e8 08 03 00 00       	call   801df3 <sys_allocateMem>
  801aeb:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801aee:	a1 20 30 80 00       	mov    0x803020,%eax
  801af3:	8b 55 08             	mov    0x8(%ebp),%edx
  801af6:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801afd:	a1 20 30 80 00       	mov    0x803020,%eax
  801b02:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801b08:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801b0f:	a1 20 30 80 00       	mov    0x803020,%eax
  801b14:	40                   	inc    %eax
  801b15:	a3 20 30 80 00       	mov    %eax,0x803020
		int i = 0;
  801b1a:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  801b21:	eb 2e                	jmp    801b51 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801b23:	a1 04 30 80 00       	mov    0x803004,%eax
  801b28:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801b2d:	c1 e8 0c             	shr    $0xc,%eax
  801b30:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801b37:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  801b3b:	a1 04 30 80 00       	mov    0x803004,%eax
  801b40:	05 00 10 00 00       	add    $0x1000,%eax
  801b45:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  801b4a:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  801b51:	8b 45 88             	mov    -0x78(%ebp),%eax
  801b54:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b57:	72 ca                	jb     801b23 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  801b59:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  801b64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  801b6b:	e9 c1 00 00 00       	jmp    801c31 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	8b 04 c5 40 30 88 00 	mov    0x883040(,%eax,8),%eax
  801b7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b7d:	0f 85 ab 00 00 00    	jne    801c2e <free+0xd0>

			if (heap_size[inx].size == 0) {
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	8b 04 c5 44 30 88 00 	mov    0x883044(,%eax,8),%eax
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	75 21                	jne    801bb2 <free+0x54>
				heap_size[inx].size = 0;
  801b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b94:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801b9b:	00 00 00 00 
				heap_size[inx].vir = NULL;
  801b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba2:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801ba9:	00 00 00 00 
				return;
  801bad:	e9 8d 00 00 00       	jmp    801c3f <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  801bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb5:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	83 ec 08             	sub    $0x8,%esp
  801bc2:	52                   	push   %edx
  801bc3:	50                   	push   %eax
  801bc4:	e8 0e 02 00 00       	call   801dd7 <sys_freeMem>
  801bc9:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  801bcc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801bd9:	eb 24                	jmp    801bff <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  801bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bde:	05 00 00 00 80       	add    $0x80000000,%eax
  801be3:	c1 e8 0c             	shr    $0xc,%eax
  801be6:	c7 04 85 40 30 80 00 	movl   $0x0,0x803040(,%eax,4)
  801bed:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  801bf1:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801bf8:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c02:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0c:	39 c2                	cmp    %eax,%edx
  801c0e:	77 cb                	ja     801bdb <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  801c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c13:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801c1a:	00 00 00 00 
			heap_size[inx].vir = NULL;
  801c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c21:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801c28:	00 00 00 00 
			break;
  801c2c:	eb 11                	jmp    801c3f <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  801c2e:	ff 45 f4             	incl   -0xc(%ebp)
  801c31:	a1 20 30 80 00       	mov    0x803020,%eax
  801c36:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801c39:	0f 8c 31 ff ff ff    	jl     801b70 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c47:	83 ec 04             	sub    $0x4,%esp
  801c4a:	68 30 29 80 00       	push   $0x802930
  801c4f:	68 1c 02 00 00       	push   $0x21c
  801c54:	68 56 29 80 00       	push   $0x802956
  801c59:	e8 b0 e6 ff ff       	call   80030e <_panic>

00801c5e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	57                   	push   %edi
  801c62:	56                   	push   %esi
  801c63:	53                   	push   %ebx
  801c64:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c73:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c76:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c79:	cd 30                	int    $0x30
  801c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5f                   	pop    %edi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    

00801c89 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	50                   	push   %eax
  801c99:	6a 00                	push   $0x0
  801c9b:	e8 be ff ff ff       	call   801c5e <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	90                   	nop
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 01                	push   $0x1
  801cb5:	e8 a4 ff ff ff       	call   801c5e <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	50                   	push   %eax
  801cce:	6a 03                	push   $0x3
  801cd0:	e8 89 ff ff ff       	call   801c5e <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 02                	push   $0x2
  801ce9:	e8 70 ff ff ff       	call   801c5e <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_env_exit>:

void sys_env_exit(void)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 04                	push   $0x4
  801d02:	e8 57 ff ff ff       	call   801c5e <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	90                   	nop
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	52                   	push   %edx
  801d1d:	50                   	push   %eax
  801d1e:	6a 05                	push   $0x5
  801d20:	e8 39 ff ff ff       	call   801c5e <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	56                   	push   %esi
  801d2e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d2f:	8b 75 18             	mov    0x18(%ebp),%esi
  801d32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	56                   	push   %esi
  801d3f:	53                   	push   %ebx
  801d40:	51                   	push   %ecx
  801d41:	52                   	push   %edx
  801d42:	50                   	push   %eax
  801d43:	6a 06                	push   $0x6
  801d45:	e8 14 ff ff ff       	call   801c5e <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d50:	5b                   	pop    %ebx
  801d51:	5e                   	pop    %esi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    

00801d54 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	52                   	push   %edx
  801d64:	50                   	push   %eax
  801d65:	6a 07                	push   $0x7
  801d67:	e8 f2 fe ff ff       	call   801c5e <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	ff 75 08             	pushl  0x8(%ebp)
  801d80:	6a 08                	push   $0x8
  801d82:	e8 d7 fe ff ff       	call   801c5e <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 09                	push   $0x9
  801d9b:	e8 be fe ff ff       	call   801c5e <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 0a                	push   $0xa
  801db4:	e8 a5 fe ff ff       	call   801c5e <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 0b                	push   $0xb
  801dcd:	e8 8c fe ff ff       	call   801c5e <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 0c             	pushl  0xc(%ebp)
  801de3:	ff 75 08             	pushl  0x8(%ebp)
  801de6:	6a 0d                	push   $0xd
  801de8:	e8 71 fe ff ff       	call   801c5e <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
	return;
  801df0:	90                   	nop
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	6a 0e                	push   $0xe
  801e04:	e8 55 fe ff ff       	call   801c5e <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0c:	90                   	nop
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 0c                	push   $0xc
  801e1e:	e8 3b fe ff ff       	call   801c5e <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 10                	push   $0x10
  801e37:	e8 22 fe ff ff       	call   801c5e <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	90                   	nop
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 11                	push   $0x11
  801e51:	e8 08 fe ff ff       	call   801c5e <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	90                   	nop
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_cputc>:


void
sys_cputc(const char c)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 04             	sub    $0x4,%esp
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	50                   	push   %eax
  801e75:	6a 12                	push   $0x12
  801e77:	e8 e2 fd ff ff       	call   801c5e <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	90                   	nop
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 13                	push   $0x13
  801e91:	e8 c8 fd ff ff       	call   801c5e <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	90                   	nop
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	ff 75 0c             	pushl  0xc(%ebp)
  801eab:	50                   	push   %eax
  801eac:	6a 14                	push   $0x14
  801eae:	e8 ab fd ff ff       	call   801c5e <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	50                   	push   %eax
  801ec7:	6a 17                	push   $0x17
  801ec9:	e8 90 fd ff ff       	call   801c5e <syscall>
  801ece:	83 c4 18             	add    $0x18,%esp
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	50                   	push   %eax
  801ee2:	6a 15                	push   $0x15
  801ee4:	e8 75 fd ff ff       	call   801c5e <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
}
  801eec:	90                   	nop
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	50                   	push   %eax
  801efe:	6a 16                	push   $0x16
  801f00:	e8 59 fd ff ff       	call   801c5e <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	90                   	nop
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 04             	sub    $0x4,%esp
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801f17:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f1a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	6a 00                	push   $0x0
  801f23:	51                   	push   %ecx
  801f24:	52                   	push   %edx
  801f25:	ff 75 0c             	pushl  0xc(%ebp)
  801f28:	50                   	push   %eax
  801f29:	6a 18                	push   $0x18
  801f2b:	e8 2e fd ff ff       	call   801c5e <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801f38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	52                   	push   %edx
  801f45:	50                   	push   %eax
  801f46:	6a 19                	push   $0x19
  801f48:	e8 11 fd ff ff       	call   801c5e <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	50                   	push   %eax
  801f61:	6a 1a                	push   $0x1a
  801f63:	e8 f6 fc ff ff       	call   801c5e <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 1b                	push   $0x1b
  801f7c:	e8 dd fc ff ff       	call   801c5e <syscall>
  801f81:	83 c4 18             	add    $0x18,%esp
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 1c                	push   $0x1c
  801f95:	e8 c4 fc ff ff       	call   801c5e <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	ff 75 0c             	pushl  0xc(%ebp)
  801fae:	50                   	push   %eax
  801faf:	6a 1d                	push   $0x1d
  801fb1:	e8 a8 fc ff ff       	call   801c5e <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	50                   	push   %eax
  801fca:	6a 1e                	push   $0x1e
  801fcc:	e8 8d fc ff ff       	call   801c5e <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
}
  801fd4:	90                   	nop
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	50                   	push   %eax
  801fe6:	6a 1f                	push   $0x1f
  801fe8:	e8 71 fc ff ff       	call   801c5e <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
}
  801ff0:	90                   	nop
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ff9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ffc:	8d 50 04             	lea    0x4(%eax),%edx
  801fff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	52                   	push   %edx
  802009:	50                   	push   %eax
  80200a:	6a 20                	push   $0x20
  80200c:	e8 4d fc ff ff       	call   801c5e <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
	return result;
  802014:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802017:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80201a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80201d:	89 01                	mov    %eax,(%ecx)
  80201f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	c9                   	leave  
  802026:	c2 04 00             	ret    $0x4

00802029 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	ff 75 10             	pushl  0x10(%ebp)
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	ff 75 08             	pushl  0x8(%ebp)
  802039:	6a 0f                	push   $0xf
  80203b:	e8 1e fc ff ff       	call   801c5e <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
	return ;
  802043:	90                   	nop
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_rcr2>:
uint32 sys_rcr2()
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 21                	push   $0x21
  802055:	e8 04 fc ff ff       	call   801c5e <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 04             	sub    $0x4,%esp
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80206b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	50                   	push   %eax
  802078:	6a 22                	push   $0x22
  80207a:	e8 df fb ff ff       	call   801c5e <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
	return ;
  802082:	90                   	nop
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <rsttst>:
void rsttst()
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 24                	push   $0x24
  802094:	e8 c5 fb ff ff       	call   801c5e <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
	return ;
  80209c:	90                   	nop
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020ab:	8b 55 18             	mov    0x18(%ebp),%edx
  8020ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020b2:	52                   	push   %edx
  8020b3:	50                   	push   %eax
  8020b4:	ff 75 10             	pushl  0x10(%ebp)
  8020b7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ba:	ff 75 08             	pushl  0x8(%ebp)
  8020bd:	6a 23                	push   $0x23
  8020bf:	e8 9a fb ff ff       	call   801c5e <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c7:	90                   	nop
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <chktst>:
void chktst(uint32 n)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	ff 75 08             	pushl  0x8(%ebp)
  8020d8:	6a 25                	push   $0x25
  8020da:	e8 7f fb ff ff       	call   801c5e <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e2:	90                   	nop
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 26                	push   $0x26
  8020f7:	e8 62 fb ff ff       	call   801c5e <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
  8020ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802102:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802106:	75 07                	jne    80210f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802108:	b8 01 00 00 00       	mov    $0x1,%eax
  80210d:	eb 05                	jmp    802114 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 26                	push   $0x26
  802128:	e8 31 fb ff ff       	call   801c5e <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
  802130:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802133:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802137:	75 07                	jne    802140 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802139:	b8 01 00 00 00       	mov    $0x1,%eax
  80213e:	eb 05                	jmp    802145 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 26                	push   $0x26
  802159:	e8 00 fb ff ff       	call   801c5e <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
  802161:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802164:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802168:	75 07                	jne    802171 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80216a:	b8 01 00 00 00       	mov    $0x1,%eax
  80216f:	eb 05                	jmp    802176 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 26                	push   $0x26
  80218a:	e8 cf fa ff ff       	call   801c5e <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
  802192:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802195:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802199:	75 07                	jne    8021a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80219b:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a0:	eb 05                	jmp    8021a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	ff 75 08             	pushl  0x8(%ebp)
  8021b7:	6a 27                	push   $0x27
  8021b9:	e8 a0 fa ff ff       	call   801c5e <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c1:	90                   	nop
}
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <__udivdi3>:
  8021c4:	55                   	push   %ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 1c             	sub    $0x1c,%esp
  8021cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021db:	89 ca                	mov    %ecx,%edx
  8021dd:	89 f8                	mov    %edi,%eax
  8021df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021e3:	85 f6                	test   %esi,%esi
  8021e5:	75 2d                	jne    802214 <__udivdi3+0x50>
  8021e7:	39 cf                	cmp    %ecx,%edi
  8021e9:	77 65                	ja     802250 <__udivdi3+0x8c>
  8021eb:	89 fd                	mov    %edi,%ebp
  8021ed:	85 ff                	test   %edi,%edi
  8021ef:	75 0b                	jne    8021fc <__udivdi3+0x38>
  8021f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f6:	31 d2                	xor    %edx,%edx
  8021f8:	f7 f7                	div    %edi
  8021fa:	89 c5                	mov    %eax,%ebp
  8021fc:	31 d2                	xor    %edx,%edx
  8021fe:	89 c8                	mov    %ecx,%eax
  802200:	f7 f5                	div    %ebp
  802202:	89 c1                	mov    %eax,%ecx
  802204:	89 d8                	mov    %ebx,%eax
  802206:	f7 f5                	div    %ebp
  802208:	89 cf                	mov    %ecx,%edi
  80220a:	89 fa                	mov    %edi,%edx
  80220c:	83 c4 1c             	add    $0x1c,%esp
  80220f:	5b                   	pop    %ebx
  802210:	5e                   	pop    %esi
  802211:	5f                   	pop    %edi
  802212:	5d                   	pop    %ebp
  802213:	c3                   	ret    
  802214:	39 ce                	cmp    %ecx,%esi
  802216:	77 28                	ja     802240 <__udivdi3+0x7c>
  802218:	0f bd fe             	bsr    %esi,%edi
  80221b:	83 f7 1f             	xor    $0x1f,%edi
  80221e:	75 40                	jne    802260 <__udivdi3+0x9c>
  802220:	39 ce                	cmp    %ecx,%esi
  802222:	72 0a                	jb     80222e <__udivdi3+0x6a>
  802224:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802228:	0f 87 9e 00 00 00    	ja     8022cc <__udivdi3+0x108>
  80222e:	b8 01 00 00 00       	mov    $0x1,%eax
  802233:	89 fa                	mov    %edi,%edx
  802235:	83 c4 1c             	add    $0x1c,%esp
  802238:	5b                   	pop    %ebx
  802239:	5e                   	pop    %esi
  80223a:	5f                   	pop    %edi
  80223b:	5d                   	pop    %ebp
  80223c:	c3                   	ret    
  80223d:	8d 76 00             	lea    0x0(%esi),%esi
  802240:	31 ff                	xor    %edi,%edi
  802242:	31 c0                	xor    %eax,%eax
  802244:	89 fa                	mov    %edi,%edx
  802246:	83 c4 1c             	add    $0x1c,%esp
  802249:	5b                   	pop    %ebx
  80224a:	5e                   	pop    %esi
  80224b:	5f                   	pop    %edi
  80224c:	5d                   	pop    %ebp
  80224d:	c3                   	ret    
  80224e:	66 90                	xchg   %ax,%ax
  802250:	89 d8                	mov    %ebx,%eax
  802252:	f7 f7                	div    %edi
  802254:	31 ff                	xor    %edi,%edi
  802256:	89 fa                	mov    %edi,%edx
  802258:	83 c4 1c             	add    $0x1c,%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5e                   	pop    %esi
  80225d:	5f                   	pop    %edi
  80225e:	5d                   	pop    %ebp
  80225f:	c3                   	ret    
  802260:	bd 20 00 00 00       	mov    $0x20,%ebp
  802265:	89 eb                	mov    %ebp,%ebx
  802267:	29 fb                	sub    %edi,%ebx
  802269:	89 f9                	mov    %edi,%ecx
  80226b:	d3 e6                	shl    %cl,%esi
  80226d:	89 c5                	mov    %eax,%ebp
  80226f:	88 d9                	mov    %bl,%cl
  802271:	d3 ed                	shr    %cl,%ebp
  802273:	89 e9                	mov    %ebp,%ecx
  802275:	09 f1                	or     %esi,%ecx
  802277:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80227b:	89 f9                	mov    %edi,%ecx
  80227d:	d3 e0                	shl    %cl,%eax
  80227f:	89 c5                	mov    %eax,%ebp
  802281:	89 d6                	mov    %edx,%esi
  802283:	88 d9                	mov    %bl,%cl
  802285:	d3 ee                	shr    %cl,%esi
  802287:	89 f9                	mov    %edi,%ecx
  802289:	d3 e2                	shl    %cl,%edx
  80228b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80228f:	88 d9                	mov    %bl,%cl
  802291:	d3 e8                	shr    %cl,%eax
  802293:	09 c2                	or     %eax,%edx
  802295:	89 d0                	mov    %edx,%eax
  802297:	89 f2                	mov    %esi,%edx
  802299:	f7 74 24 0c          	divl   0xc(%esp)
  80229d:	89 d6                	mov    %edx,%esi
  80229f:	89 c3                	mov    %eax,%ebx
  8022a1:	f7 e5                	mul    %ebp
  8022a3:	39 d6                	cmp    %edx,%esi
  8022a5:	72 19                	jb     8022c0 <__udivdi3+0xfc>
  8022a7:	74 0b                	je     8022b4 <__udivdi3+0xf0>
  8022a9:	89 d8                	mov    %ebx,%eax
  8022ab:	31 ff                	xor    %edi,%edi
  8022ad:	e9 58 ff ff ff       	jmp    80220a <__udivdi3+0x46>
  8022b2:	66 90                	xchg   %ax,%ax
  8022b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022b8:	89 f9                	mov    %edi,%ecx
  8022ba:	d3 e2                	shl    %cl,%edx
  8022bc:	39 c2                	cmp    %eax,%edx
  8022be:	73 e9                	jae    8022a9 <__udivdi3+0xe5>
  8022c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022c3:	31 ff                	xor    %edi,%edi
  8022c5:	e9 40 ff ff ff       	jmp    80220a <__udivdi3+0x46>
  8022ca:	66 90                	xchg   %ax,%ax
  8022cc:	31 c0                	xor    %eax,%eax
  8022ce:	e9 37 ff ff ff       	jmp    80220a <__udivdi3+0x46>
  8022d3:	90                   	nop

008022d4 <__umoddi3>:
  8022d4:	55                   	push   %ebp
  8022d5:	57                   	push   %edi
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
  8022d8:	83 ec 1c             	sub    $0x1c,%esp
  8022db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022f3:	89 f3                	mov    %esi,%ebx
  8022f5:	89 fa                	mov    %edi,%edx
  8022f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022fb:	89 34 24             	mov    %esi,(%esp)
  8022fe:	85 c0                	test   %eax,%eax
  802300:	75 1a                	jne    80231c <__umoddi3+0x48>
  802302:	39 f7                	cmp    %esi,%edi
  802304:	0f 86 a2 00 00 00    	jbe    8023ac <__umoddi3+0xd8>
  80230a:	89 c8                	mov    %ecx,%eax
  80230c:	89 f2                	mov    %esi,%edx
  80230e:	f7 f7                	div    %edi
  802310:	89 d0                	mov    %edx,%eax
  802312:	31 d2                	xor    %edx,%edx
  802314:	83 c4 1c             	add    $0x1c,%esp
  802317:	5b                   	pop    %ebx
  802318:	5e                   	pop    %esi
  802319:	5f                   	pop    %edi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    
  80231c:	39 f0                	cmp    %esi,%eax
  80231e:	0f 87 ac 00 00 00    	ja     8023d0 <__umoddi3+0xfc>
  802324:	0f bd e8             	bsr    %eax,%ebp
  802327:	83 f5 1f             	xor    $0x1f,%ebp
  80232a:	0f 84 ac 00 00 00    	je     8023dc <__umoddi3+0x108>
  802330:	bf 20 00 00 00       	mov    $0x20,%edi
  802335:	29 ef                	sub    %ebp,%edi
  802337:	89 fe                	mov    %edi,%esi
  802339:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80233d:	89 e9                	mov    %ebp,%ecx
  80233f:	d3 e0                	shl    %cl,%eax
  802341:	89 d7                	mov    %edx,%edi
  802343:	89 f1                	mov    %esi,%ecx
  802345:	d3 ef                	shr    %cl,%edi
  802347:	09 c7                	or     %eax,%edi
  802349:	89 e9                	mov    %ebp,%ecx
  80234b:	d3 e2                	shl    %cl,%edx
  80234d:	89 14 24             	mov    %edx,(%esp)
  802350:	89 d8                	mov    %ebx,%eax
  802352:	d3 e0                	shl    %cl,%eax
  802354:	89 c2                	mov    %eax,%edx
  802356:	8b 44 24 08          	mov    0x8(%esp),%eax
  80235a:	d3 e0                	shl    %cl,%eax
  80235c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802360:	8b 44 24 08          	mov    0x8(%esp),%eax
  802364:	89 f1                	mov    %esi,%ecx
  802366:	d3 e8                	shr    %cl,%eax
  802368:	09 d0                	or     %edx,%eax
  80236a:	d3 eb                	shr    %cl,%ebx
  80236c:	89 da                	mov    %ebx,%edx
  80236e:	f7 f7                	div    %edi
  802370:	89 d3                	mov    %edx,%ebx
  802372:	f7 24 24             	mull   (%esp)
  802375:	89 c6                	mov    %eax,%esi
  802377:	89 d1                	mov    %edx,%ecx
  802379:	39 d3                	cmp    %edx,%ebx
  80237b:	0f 82 87 00 00 00    	jb     802408 <__umoddi3+0x134>
  802381:	0f 84 91 00 00 00    	je     802418 <__umoddi3+0x144>
  802387:	8b 54 24 04          	mov    0x4(%esp),%edx
  80238b:	29 f2                	sub    %esi,%edx
  80238d:	19 cb                	sbb    %ecx,%ebx
  80238f:	89 d8                	mov    %ebx,%eax
  802391:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802395:	d3 e0                	shl    %cl,%eax
  802397:	89 e9                	mov    %ebp,%ecx
  802399:	d3 ea                	shr    %cl,%edx
  80239b:	09 d0                	or     %edx,%eax
  80239d:	89 e9                	mov    %ebp,%ecx
  80239f:	d3 eb                	shr    %cl,%ebx
  8023a1:	89 da                	mov    %ebx,%edx
  8023a3:	83 c4 1c             	add    $0x1c,%esp
  8023a6:	5b                   	pop    %ebx
  8023a7:	5e                   	pop    %esi
  8023a8:	5f                   	pop    %edi
  8023a9:	5d                   	pop    %ebp
  8023aa:	c3                   	ret    
  8023ab:	90                   	nop
  8023ac:	89 fd                	mov    %edi,%ebp
  8023ae:	85 ff                	test   %edi,%edi
  8023b0:	75 0b                	jne    8023bd <__umoddi3+0xe9>
  8023b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b7:	31 d2                	xor    %edx,%edx
  8023b9:	f7 f7                	div    %edi
  8023bb:	89 c5                	mov    %eax,%ebp
  8023bd:	89 f0                	mov    %esi,%eax
  8023bf:	31 d2                	xor    %edx,%edx
  8023c1:	f7 f5                	div    %ebp
  8023c3:	89 c8                	mov    %ecx,%eax
  8023c5:	f7 f5                	div    %ebp
  8023c7:	89 d0                	mov    %edx,%eax
  8023c9:	e9 44 ff ff ff       	jmp    802312 <__umoddi3+0x3e>
  8023ce:	66 90                	xchg   %ax,%ax
  8023d0:	89 c8                	mov    %ecx,%eax
  8023d2:	89 f2                	mov    %esi,%edx
  8023d4:	83 c4 1c             	add    $0x1c,%esp
  8023d7:	5b                   	pop    %ebx
  8023d8:	5e                   	pop    %esi
  8023d9:	5f                   	pop    %edi
  8023da:	5d                   	pop    %ebp
  8023db:	c3                   	ret    
  8023dc:	3b 04 24             	cmp    (%esp),%eax
  8023df:	72 06                	jb     8023e7 <__umoddi3+0x113>
  8023e1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8023e5:	77 0f                	ja     8023f6 <__umoddi3+0x122>
  8023e7:	89 f2                	mov    %esi,%edx
  8023e9:	29 f9                	sub    %edi,%ecx
  8023eb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8023ef:	89 14 24             	mov    %edx,(%esp)
  8023f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023f6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023fa:	8b 14 24             	mov    (%esp),%edx
  8023fd:	83 c4 1c             	add    $0x1c,%esp
  802400:	5b                   	pop    %ebx
  802401:	5e                   	pop    %esi
  802402:	5f                   	pop    %edi
  802403:	5d                   	pop    %ebp
  802404:	c3                   	ret    
  802405:	8d 76 00             	lea    0x0(%esi),%esi
  802408:	2b 04 24             	sub    (%esp),%eax
  80240b:	19 fa                	sbb    %edi,%edx
  80240d:	89 d1                	mov    %edx,%ecx
  80240f:	89 c6                	mov    %eax,%esi
  802411:	e9 71 ff ff ff       	jmp    802387 <__umoddi3+0xb3>
  802416:	66 90                	xchg   %ax,%ax
  802418:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80241c:	72 ea                	jb     802408 <__umoddi3+0x134>
  80241e:	89 d9                	mov    %ebx,%ecx
  802420:	e9 62 ff ff ff       	jmp    802387 <__umoddi3+0xb3>
