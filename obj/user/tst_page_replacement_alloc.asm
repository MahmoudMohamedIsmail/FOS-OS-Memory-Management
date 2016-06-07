
obj/user/tst_page_replacement_alloc:     file format elf32-i386


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
  800031:	e8 ef 02 00 00       	call   800325 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
uint8* ptr = (uint8* )0x0801000 ;
uint8* ptr2 = (uint8* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	int envID = sys_getenvid();
  80003f:	e8 cc 12 00 00       	call   801310 <sys_getenvid>
  800044:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf("envID = %d\n",envID);

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800047:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80004a:	89 d0                	mov    %edx,%eax
  80004c:	c1 e0 03             	shl    $0x3,%eax
  80004f:	01 d0                	add    %edx,%eax
  800051:	01 c0                	add    %eax,%eax
  800053:	01 d0                	add    %edx,%eax
  800055:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005c:	01 d0                	add    %edx,%eax
  80005e:	c1 e0 03             	shl    $0x3,%eax
  800061:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800066:	89 45 ec             	mov    %eax,-0x14(%ebp)

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800069:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006c:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800072:	8b 00                	mov    (%eax),%eax
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80007a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80007f:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800084:	74 14                	je     80009a <_main+0x62>
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	68 60 1a 80 00       	push   $0x801a60
  80008e:	6a 15                	push   $0x15
  800090:	68 a4 1a 80 00       	push   $0x801aa4
  800095:	e8 4c 03 00 00       	call   8003e6 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80009a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009d:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000a3:	83 c0 0c             	add    $0xc,%eax
  8000a6:	8b 00                	mov    (%eax),%eax
  8000a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000b3:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000b8:	74 14                	je     8000ce <_main+0x96>
  8000ba:	83 ec 04             	sub    $0x4,%esp
  8000bd:	68 60 1a 80 00       	push   $0x801a60
  8000c2:	6a 16                	push   $0x16
  8000c4:	68 a4 1a 80 00       	push   $0x801aa4
  8000c9:	e8 18 03 00 00       	call   8003e6 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d1:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000d7:	83 c0 18             	add    $0x18,%eax
  8000da:	8b 00                	mov    (%eax),%eax
  8000dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000e7:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 60 1a 80 00       	push   $0x801a60
  8000f6:	6a 17                	push   $0x17
  8000f8:	68 a4 1a 80 00       	push   $0x801aa4
  8000fd:	e8 e4 02 00 00       	call   8003e6 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800102:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800105:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80010b:	83 c0 24             	add    $0x24,%eax
  80010e:	8b 00                	mov    (%eax),%eax
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800113:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800116:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80011b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800120:	74 14                	je     800136 <_main+0xfe>
  800122:	83 ec 04             	sub    $0x4,%esp
  800125:	68 60 1a 80 00       	push   $0x801a60
  80012a:	6a 18                	push   $0x18
  80012c:	68 a4 1a 80 00       	push   $0x801aa4
  800131:	e8 b0 02 00 00       	call   8003e6 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80013f:	83 c0 30             	add    $0x30,%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800147:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80014a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80014f:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800154:	74 14                	je     80016a <_main+0x132>
  800156:	83 ec 04             	sub    $0x4,%esp
  800159:	68 60 1a 80 00       	push   $0x801a60
  80015e:	6a 19                	push   $0x19
  800160:	68 a4 1a 80 00       	push   $0x801aa4
  800165:	e8 7c 02 00 00       	call   8003e6 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80016a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016d:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800173:	83 c0 3c             	add    $0x3c,%eax
  800176:	8b 00                	mov    (%eax),%eax
  800178:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80017b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80017e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800183:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800188:	74 14                	je     80019e <_main+0x166>
  80018a:	83 ec 04             	sub    $0x4,%esp
  80018d:	68 60 1a 80 00       	push   $0x801a60
  800192:	6a 1a                	push   $0x1a
  800194:	68 a4 1a 80 00       	push   $0x801aa4
  800199:	e8 48 02 00 00       	call   8003e6 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80019e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a1:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001a7:	83 c0 48             	add    $0x48,%eax
  8001aa:	8b 00                	mov    (%eax),%eax
  8001ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b7:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001bc:	74 14                	je     8001d2 <_main+0x19a>
  8001be:	83 ec 04             	sub    $0x4,%esp
  8001c1:	68 60 1a 80 00       	push   $0x801a60
  8001c6:	6a 1b                	push   $0x1b
  8001c8:	68 a4 1a 80 00       	push   $0x801aa4
  8001cd:	e8 14 02 00 00       	call   8003e6 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d5:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001db:	83 c0 54             	add    $0x54,%eax
  8001de:	8b 00                	mov    (%eax),%eax
  8001e0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001eb:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 60 1a 80 00       	push   $0x801a60
  8001fa:	6a 1c                	push   $0x1c
  8001fc:	68 a4 1a 80 00       	push   $0x801aa4
  800201:	e8 e0 01 00 00       	call   8003e6 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800209:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80020f:	83 c0 60             	add    $0x60,%eax
  800212:	8b 00                	mov    (%eax),%eax
  800214:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800217:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80021a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80021f:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800224:	74 14                	je     80023a <_main+0x202>
  800226:	83 ec 04             	sub    $0x4,%esp
  800229:	68 60 1a 80 00       	push   $0x801a60
  80022e:	6a 1d                	push   $0x1d
  800230:	68 a4 1a 80 00       	push   $0x801aa4
  800235:	e8 ac 01 00 00       	call   8003e6 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  80023a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023d:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  800243:	85 c0                	test   %eax,%eax
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 c8 1a 80 00       	push   $0x801ac8
  80024f:	6a 1e                	push   $0x1e
  800251:	68 a4 1a 80 00       	push   $0x801aa4
  800256:	e8 8b 01 00 00       	call   8003e6 <_panic>
	}

	int freePages = sys_calculate_free_frames();
  80025b:	e8 62 11 00 00       	call   8013c2 <sys_calculate_free_frames>
  800260:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	//cprintf("[BEFORE] free frames = %d\n", freePages) ;
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800263:	e8 dd 11 00 00       	call   801445 <sys_pf_calculate_allocated_pages>
  800268:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  80026b:	a0 1f e0 80 00       	mov    0x80e01f,%al
  800270:	88 45 bf             	mov    %al,-0x41(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  800273:	a0 1f f0 80 00       	mov    0x80f01f,%al
  800278:	88 45 be             	mov    %al,-0x42(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80027b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800282:	eb 37                	jmp    8002bb <_main+0x283>
	{
		arr[i] = -1 ;
  800284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800287:	05 20 30 80 00       	add    $0x803020,%eax
  80028c:	c6 00 ff             	movb   $0xff,(%eax)
		*ptr = *ptr2 ;
  80028f:	a1 00 30 80 00       	mov    0x803000,%eax
  800294:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80029a:	8a 12                	mov    (%edx),%dl
  80029c:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  80029e:	a1 00 30 80 00       	mov    0x803000,%eax
  8002a3:	40                   	inc    %eax
  8002a4:	a3 00 30 80 00       	mov    %eax,0x803000
  8002a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ae:	40                   	inc    %eax
  8002af:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002b4:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8002bb:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8002c2:	7e c0                	jle    800284 <_main+0x24c>

	//===================

	//cprintf("Checking Allocation in Mem & Page File... \n");
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8002c4:	e8 7c 11 00 00       	call   801445 <sys_pf_calculate_allocated_pages>
  8002c9:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  8002cc:	74 14                	je     8002e2 <_main+0x2aa>
  8002ce:	83 ec 04             	sub    $0x4,%esp
  8002d1:	68 10 1b 80 00       	push   $0x801b10
  8002d6:	6a 36                	push   $0x36
  8002d8:	68 a4 1a 80 00       	push   $0x801aa4
  8002dd:	e8 04 01 00 00       	call   8003e6 <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8002e2:	e8 db 10 00 00       	call   8013c2 <sys_calculate_free_frames>
  8002e7:	89 c3                	mov    %eax,%ebx
  8002e9:	e8 ed 10 00 00       	call   8013db <sys_calculate_modified_frames>
  8002ee:	01 d8                	add    %ebx,%eax
  8002f0:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  8002f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002f6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8002f9:	74 14                	je     80030f <_main+0x2d7>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	68 7c 1b 80 00       	push   $0x801b7c
  800303:	6a 3a                	push   $0x3a
  800305:	68 a4 1a 80 00       	push   $0x801aa4
  80030a:	e8 d7 00 00 00       	call   8003e6 <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] is completed successfully.\n");
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 e0 1b 80 00       	push   $0x801be0
  800317:	e8 f5 01 00 00       	call   800511 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
	return;
  80031f:	90                   	nop
}
  800320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80032f:	7e 0a                	jle    80033b <libmain+0x16>
		binaryname = argv[0];
  800331:	8b 45 0c             	mov    0xc(%ebp),%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	e8 ef fc ff ff       	call   800038 <_main>
  800349:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80034c:	e8 bf 0f 00 00       	call   801310 <sys_getenvid>
  800351:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800354:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800357:	89 d0                	mov    %edx,%eax
  800359:	c1 e0 03             	shl    $0x3,%eax
  80035c:	01 d0                	add    %edx,%eax
  80035e:	01 c0                	add    %eax,%eax
  800360:	01 d0                	add    %edx,%eax
  800362:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800369:	01 d0                	add    %edx,%eax
  80036b:	c1 e0 03             	shl    $0x3,%eax
  80036e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800373:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800376:	e8 e3 10 00 00       	call   80145e <sys_disable_interrupt>
		cprintf("**************************************\n");
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	68 4c 1c 80 00       	push   $0x801c4c
  800383:	e8 89 01 00 00       	call   800511 <cprintf>
  800388:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80038b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80038e:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	50                   	push   %eax
  800398:	68 74 1c 80 00       	push   $0x801c74
  80039d:	e8 6f 01 00 00       	call   800511 <cprintf>
  8003a2:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003a5:	83 ec 0c             	sub    $0xc,%esp
  8003a8:	68 4c 1c 80 00       	push   $0x801c4c
  8003ad:	e8 5f 01 00 00       	call   800511 <cprintf>
  8003b2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003b5:	e8 be 10 00 00       	call   801478 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003ba:	e8 19 00 00 00       	call   8003d8 <exit>
}
  8003bf:	90                   	nop
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8003c8:	83 ec 0c             	sub    $0xc,%esp
  8003cb:	6a 00                	push   $0x0
  8003cd:	e8 23 0f 00 00       	call   8012f5 <sys_env_destroy>
  8003d2:	83 c4 10             	add    $0x10,%esp
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <exit>:

void
exit(void)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8003de:	e8 46 0f 00 00       	call   801329 <sys_env_exit>
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003ec:	8d 45 10             	lea    0x10(%ebp),%eax
  8003ef:	83 c0 04             	add    $0x4,%eax
  8003f2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8003f5:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  8003fa:	85 c0                	test   %eax,%eax
  8003fc:	74 16                	je     800414 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003fe:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	50                   	push   %eax
  800407:	68 8d 1c 80 00       	push   $0x801c8d
  80040c:	e8 00 01 00 00       	call   800511 <cprintf>
  800411:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800414:	a1 08 30 80 00       	mov    0x803008,%eax
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	50                   	push   %eax
  800420:	68 92 1c 80 00       	push   $0x801c92
  800425:	e8 e7 00 00 00       	call   800511 <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80042d:	8b 45 10             	mov    0x10(%ebp),%eax
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	ff 75 f4             	pushl  -0xc(%ebp)
  800436:	50                   	push   %eax
  800437:	e8 7a 00 00 00       	call   8004b6 <vcprintf>
  80043c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	68 ae 1c 80 00       	push   $0x801cae
  800447:	e8 c5 00 00 00       	call   800511 <cprintf>
  80044c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80044f:	e8 84 ff ff ff       	call   8003d8 <exit>

	// should not return here
	while (1) ;
  800454:	eb fe                	jmp    800454 <_panic+0x6e>

00800456 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
  800459:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	8d 48 01             	lea    0x1(%eax),%ecx
  800464:	8b 55 0c             	mov    0xc(%ebp),%edx
  800467:	89 0a                	mov    %ecx,(%edx)
  800469:	8b 55 08             	mov    0x8(%ebp),%edx
  80046c:	88 d1                	mov    %dl,%cl
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800475:	8b 45 0c             	mov    0xc(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047f:	75 23                	jne    8004a4 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	89 c2                	mov    %eax,%edx
  800488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048b:	83 c0 08             	add    $0x8,%eax
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	52                   	push   %edx
  800492:	50                   	push   %eax
  800493:	e8 27 0e 00 00       	call   8012bf <sys_cputs>
  800498:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	8b 40 04             	mov    0x4(%eax),%eax
  8004aa:	8d 50 01             	lea    0x1(%eax),%edx
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b3:	90                   	nop
  8004b4:	c9                   	leave  
  8004b5:	c3                   	ret    

008004b6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c6:	00 00 00 
	b.cnt = 0;
  8004c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d3:	ff 75 0c             	pushl  0xc(%ebp)
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004df:	50                   	push   %eax
  8004e0:	68 56 04 80 00       	push   $0x800456
  8004e5:	e8 fa 01 00 00       	call   8006e4 <vprintfmt>
  8004ea:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8004ed:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	50                   	push   %eax
  8004f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004fd:	83 c0 08             	add    $0x8,%eax
  800500:	50                   	push   %eax
  800501:	e8 b9 0d 00 00       	call   8012bf <sys_cputs>
  800506:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800509:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050f:	c9                   	leave  
  800510:	c3                   	ret    

00800511 <cprintf>:

int cprintf(const char *fmt, ...) {
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800517:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 f4             	pushl  -0xc(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 8a ff ff ff       	call   8004b6 <vcprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800532:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800535:	c9                   	leave  
  800536:	c3                   	ret    

00800537 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800537:	55                   	push   %ebp
  800538:	89 e5                	mov    %esp,%ebp
  80053a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80053d:	e8 1c 0f 00 00       	call   80145e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800542:	8d 45 0c             	lea    0xc(%ebp),%eax
  800545:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	ff 75 f4             	pushl  -0xc(%ebp)
  800551:	50                   	push   %eax
  800552:	e8 5f ff ff ff       	call   8004b6 <vcprintf>
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80055d:	e8 16 0f 00 00       	call   801478 <sys_enable_interrupt>
	return cnt;
  800562:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	53                   	push   %ebx
  80056b:	83 ec 14             	sub    $0x14,%esp
  80056e:	8b 45 10             	mov    0x10(%ebp),%eax
  800571:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057a:	8b 45 18             	mov    0x18(%ebp),%eax
  80057d:	ba 00 00 00 00       	mov    $0x0,%edx
  800582:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800585:	77 55                	ja     8005dc <printnum+0x75>
  800587:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058a:	72 05                	jb     800591 <printnum+0x2a>
  80058c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80058f:	77 4b                	ja     8005dc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800591:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800594:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800597:	8b 45 18             	mov    0x18(%ebp),%eax
  80059a:	ba 00 00 00 00       	mov    $0x0,%edx
  80059f:	52                   	push   %edx
  8005a0:	50                   	push   %eax
  8005a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a7:	e8 50 12 00 00       	call   8017fc <__udivdi3>
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	83 ec 04             	sub    $0x4,%esp
  8005b2:	ff 75 20             	pushl  0x20(%ebp)
  8005b5:	53                   	push   %ebx
  8005b6:	ff 75 18             	pushl  0x18(%ebp)
  8005b9:	52                   	push   %edx
  8005ba:	50                   	push   %eax
  8005bb:	ff 75 0c             	pushl  0xc(%ebp)
  8005be:	ff 75 08             	pushl  0x8(%ebp)
  8005c1:	e8 a1 ff ff ff       	call   800567 <printnum>
  8005c6:	83 c4 20             	add    $0x20,%esp
  8005c9:	eb 1a                	jmp    8005e5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	ff 75 0c             	pushl  0xc(%ebp)
  8005d1:	ff 75 20             	pushl  0x20(%ebp)
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	ff d0                	call   *%eax
  8005d9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005dc:	ff 4d 1c             	decl   0x1c(%ebp)
  8005df:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e3:	7f e6                	jg     8005cb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	53                   	push   %ebx
  8005f4:	51                   	push   %ecx
  8005f5:	52                   	push   %edx
  8005f6:	50                   	push   %eax
  8005f7:	e8 10 13 00 00       	call   80190c <__umoddi3>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	05 d4 1e 80 00       	add    $0x801ed4,%eax
  800604:	8a 00                	mov    (%eax),%al
  800606:	0f be c0             	movsbl %al,%eax
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	ff 75 0c             	pushl  0xc(%ebp)
  80060f:	50                   	push   %eax
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	ff d0                	call   *%eax
  800615:	83 c4 10             	add    $0x10,%esp
}
  800618:	90                   	nop
  800619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800621:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800625:	7e 1c                	jle    800643 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	8d 50 08             	lea    0x8(%eax),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	89 10                	mov    %edx,(%eax)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	8b 00                	mov    (%eax),%eax
  800639:	83 e8 08             	sub    $0x8,%eax
  80063c:	8b 50 04             	mov    0x4(%eax),%edx
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	eb 40                	jmp    800683 <getuint+0x65>
	else if (lflag)
  800643:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800647:	74 1e                	je     800667 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	8d 50 04             	lea    0x4(%eax),%edx
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	89 10                	mov    %edx,(%eax)
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	83 e8 04             	sub    $0x4,%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	ba 00 00 00 00       	mov    $0x0,%edx
  800665:	eb 1c                	jmp    800683 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	8d 50 04             	lea    0x4(%eax),%edx
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	89 10                	mov    %edx,(%eax)
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	83 e8 04             	sub    $0x4,%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800683:	5d                   	pop    %ebp
  800684:	c3                   	ret    

00800685 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068c:	7e 1c                	jle    8006aa <getint+0x25>
		return va_arg(*ap, long long);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 08             	sub    $0x8,%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	eb 38                	jmp    8006e2 <getint+0x5d>
	else if (lflag)
  8006aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ae:	74 1a                	je     8006ca <getint+0x45>
		return va_arg(*ap, long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 04             	lea    0x4(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	99                   	cltd   
  8006c8:	eb 18                	jmp    8006e2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	8d 50 04             	lea    0x4(%eax),%edx
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	89 10                	mov    %edx,(%eax)
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	83 e8 04             	sub    $0x4,%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	99                   	cltd   
}
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	56                   	push   %esi
  8006e8:	53                   	push   %ebx
  8006e9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ec:	eb 17                	jmp    800705 <vprintfmt+0x21>
			if (ch == '\0')
  8006ee:	85 db                	test   %ebx,%ebx
  8006f0:	0f 84 af 03 00 00    	je     800aa5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	53                   	push   %ebx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800705:	8b 45 10             	mov    0x10(%ebp),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	89 55 10             	mov    %edx,0x10(%ebp)
  80070e:	8a 00                	mov    (%eax),%al
  800710:	0f b6 d8             	movzbl %al,%ebx
  800713:	83 fb 25             	cmp    $0x25,%ebx
  800716:	75 d6                	jne    8006ee <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800718:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80071c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800723:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800731:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800738:	8b 45 10             	mov    0x10(%ebp),%eax
  80073b:	8d 50 01             	lea    0x1(%eax),%edx
  80073e:	89 55 10             	mov    %edx,0x10(%ebp)
  800741:	8a 00                	mov    (%eax),%al
  800743:	0f b6 d8             	movzbl %al,%ebx
  800746:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800749:	83 f8 55             	cmp    $0x55,%eax
  80074c:	0f 87 2b 03 00 00    	ja     800a7d <vprintfmt+0x399>
  800752:	8b 04 85 f8 1e 80 00 	mov    0x801ef8(,%eax,4),%eax
  800759:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80075b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80075f:	eb d7                	jmp    800738 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800761:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800765:	eb d1                	jmp    800738 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800767:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80076e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800771:	89 d0                	mov    %edx,%eax
  800773:	c1 e0 02             	shl    $0x2,%eax
  800776:	01 d0                	add    %edx,%eax
  800778:	01 c0                	add    %eax,%eax
  80077a:	01 d8                	add    %ebx,%eax
  80077c:	83 e8 30             	sub    $0x30,%eax
  80077f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800782:	8b 45 10             	mov    0x10(%ebp),%eax
  800785:	8a 00                	mov    (%eax),%al
  800787:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80078a:	83 fb 2f             	cmp    $0x2f,%ebx
  80078d:	7e 3e                	jle    8007cd <vprintfmt+0xe9>
  80078f:	83 fb 39             	cmp    $0x39,%ebx
  800792:	7f 39                	jg     8007cd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800794:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800797:	eb d5                	jmp    80076e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	83 c0 04             	add    $0x4,%eax
  80079f:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	83 e8 04             	sub    $0x4,%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ad:	eb 1f                	jmp    8007ce <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b3:	79 83                	jns    800738 <vprintfmt+0x54>
				width = 0;
  8007b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007bc:	e9 77 ff ff ff       	jmp    800738 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007c1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007c8:	e9 6b ff ff ff       	jmp    800738 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007cd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d2:	0f 89 60 ff ff ff    	jns    800738 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007de:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007e5:	e9 4e ff ff ff       	jmp    800738 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ea:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007ed:	e9 46 ff ff ff       	jmp    800738 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	83 c0 04             	add    $0x4,%eax
  8007f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	83 e8 04             	sub    $0x4,%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	50                   	push   %eax
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	ff d0                	call   *%eax
  80080f:	83 c4 10             	add    $0x10,%esp
			break;
  800812:	e9 89 02 00 00       	jmp    800aa0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	83 c0 04             	add    $0x4,%eax
  80081d:	89 45 14             	mov    %eax,0x14(%ebp)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800828:	85 db                	test   %ebx,%ebx
  80082a:	79 02                	jns    80082e <vprintfmt+0x14a>
				err = -err;
  80082c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80082e:	83 fb 64             	cmp    $0x64,%ebx
  800831:	7f 0b                	jg     80083e <vprintfmt+0x15a>
  800833:	8b 34 9d 40 1d 80 00 	mov    0x801d40(,%ebx,4),%esi
  80083a:	85 f6                	test   %esi,%esi
  80083c:	75 19                	jne    800857 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80083e:	53                   	push   %ebx
  80083f:	68 e5 1e 80 00       	push   $0x801ee5
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	ff 75 08             	pushl  0x8(%ebp)
  80084a:	e8 5e 02 00 00       	call   800aad <printfmt>
  80084f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800852:	e9 49 02 00 00       	jmp    800aa0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800857:	56                   	push   %esi
  800858:	68 ee 1e 80 00       	push   $0x801eee
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	ff 75 08             	pushl  0x8(%ebp)
  800863:	e8 45 02 00 00       	call   800aad <printfmt>
  800868:	83 c4 10             	add    $0x10,%esp
			break;
  80086b:	e9 30 02 00 00       	jmp    800aa0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	83 c0 04             	add    $0x4,%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	83 e8 04             	sub    $0x4,%eax
  80087f:	8b 30                	mov    (%eax),%esi
  800881:	85 f6                	test   %esi,%esi
  800883:	75 05                	jne    80088a <vprintfmt+0x1a6>
				p = "(null)";
  800885:	be f1 1e 80 00       	mov    $0x801ef1,%esi
			if (width > 0 && padc != '-')
  80088a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088e:	7e 6d                	jle    8008fd <vprintfmt+0x219>
  800890:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800894:	74 67                	je     8008fd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800896:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	50                   	push   %eax
  80089d:	56                   	push   %esi
  80089e:	e8 0c 03 00 00       	call   800baf <strnlen>
  8008a3:	83 c4 10             	add    $0x10,%esp
  8008a6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008a9:	eb 16                	jmp    8008c1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008ab:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	50                   	push   %eax
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008be:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c5:	7f e4                	jg     8008ab <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008c7:	eb 34                	jmp    8008fd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008cd:	74 1c                	je     8008eb <vprintfmt+0x207>
  8008cf:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d2:	7e 05                	jle    8008d9 <vprintfmt+0x1f5>
  8008d4:	83 fb 7e             	cmp    $0x7e,%ebx
  8008d7:	7e 12                	jle    8008eb <vprintfmt+0x207>
					putch('?', putdat);
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	ff 75 0c             	pushl  0xc(%ebp)
  8008df:	6a 3f                	push   $0x3f
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	ff d0                	call   *%eax
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	eb 0f                	jmp    8008fa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	53                   	push   %ebx
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	ff d0                	call   *%eax
  8008f7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008fa:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fd:	89 f0                	mov    %esi,%eax
  8008ff:	8d 70 01             	lea    0x1(%eax),%esi
  800902:	8a 00                	mov    (%eax),%al
  800904:	0f be d8             	movsbl %al,%ebx
  800907:	85 db                	test   %ebx,%ebx
  800909:	74 24                	je     80092f <vprintfmt+0x24b>
  80090b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80090f:	78 b8                	js     8008c9 <vprintfmt+0x1e5>
  800911:	ff 4d e0             	decl   -0x20(%ebp)
  800914:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800918:	79 af                	jns    8008c9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091a:	eb 13                	jmp    80092f <vprintfmt+0x24b>
				putch(' ', putdat);
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	6a 20                	push   $0x20
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	ff d0                	call   *%eax
  800929:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092c:	ff 4d e4             	decl   -0x1c(%ebp)
  80092f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800933:	7f e7                	jg     80091c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800935:	e9 66 01 00 00       	jmp    800aa0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	ff 75 e8             	pushl  -0x18(%ebp)
  800940:	8d 45 14             	lea    0x14(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	e8 3c fd ff ff       	call   800685 <getint>
  800949:	83 c4 10             	add    $0x10,%esp
  80094c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80094f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800955:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800958:	85 d2                	test   %edx,%edx
  80095a:	79 23                	jns    80097f <vprintfmt+0x29b>
				putch('-', putdat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	6a 2d                	push   $0x2d
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	ff d0                	call   *%eax
  800969:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80096c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800972:	f7 d8                	neg    %eax
  800974:	83 d2 00             	adc    $0x0,%edx
  800977:	f7 da                	neg    %edx
  800979:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80097f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800986:	e9 bc 00 00 00       	jmp    800a47 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	ff 75 e8             	pushl  -0x18(%ebp)
  800991:	8d 45 14             	lea    0x14(%ebp),%eax
  800994:	50                   	push   %eax
  800995:	e8 84 fc ff ff       	call   80061e <getuint>
  80099a:	83 c4 10             	add    $0x10,%esp
  80099d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009aa:	e9 98 00 00 00       	jmp    800a47 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 58                	push   $0x58
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	6a 58                	push   $0x58
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	6a 58                	push   $0x58
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			break;
  8009df:	e9 bc 00 00 00       	jmp    800aa0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	6a 30                	push   $0x30
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	ff d0                	call   *%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f4:	83 ec 08             	sub    $0x8,%esp
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	6a 78                	push   $0x78
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	ff d0                	call   *%eax
  800a01:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	83 e8 04             	sub    $0x4,%eax
  800a13:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a26:	eb 1f                	jmp    800a47 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a2e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a31:	50                   	push   %eax
  800a32:	e8 e7 fb ff ff       	call   80061e <getuint>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a47:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a4e:	83 ec 04             	sub    $0x4,%esp
  800a51:	52                   	push   %edx
  800a52:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a55:	50                   	push   %eax
  800a56:	ff 75 f4             	pushl  -0xc(%ebp)
  800a59:	ff 75 f0             	pushl  -0x10(%ebp)
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	ff 75 08             	pushl  0x8(%ebp)
  800a62:	e8 00 fb ff ff       	call   800567 <printnum>
  800a67:	83 c4 20             	add    $0x20,%esp
			break;
  800a6a:	eb 34                	jmp    800aa0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	53                   	push   %ebx
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
			break;
  800a7b:	eb 23                	jmp    800aa0 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	6a 25                	push   $0x25
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	ff d0                	call   *%eax
  800a8a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a8d:	ff 4d 10             	decl   0x10(%ebp)
  800a90:	eb 03                	jmp    800a95 <vprintfmt+0x3b1>
  800a92:	ff 4d 10             	decl   0x10(%ebp)
  800a95:	8b 45 10             	mov    0x10(%ebp),%eax
  800a98:	48                   	dec    %eax
  800a99:	8a 00                	mov    (%eax),%al
  800a9b:	3c 25                	cmp    $0x25,%al
  800a9d:	75 f3                	jne    800a92 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a9f:	90                   	nop
		}
	}
  800aa0:	e9 47 fc ff ff       	jmp    8006ec <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aa5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aa9:	5b                   	pop    %ebx
  800aaa:	5e                   	pop    %esi
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ab3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800abc:	8b 45 10             	mov    0x10(%ebp),%eax
  800abf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac2:	50                   	push   %eax
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 16 fc ff ff       	call   8006e4 <vprintfmt>
  800ace:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ad1:	90                   	nop
  800ad2:	c9                   	leave  
  800ad3:	c3                   	ret    

00800ad4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ada:	8b 40 08             	mov    0x8(%eax),%eax
  800add:	8d 50 01             	lea    0x1(%eax),%edx
  800ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae9:	8b 10                	mov    (%eax),%edx
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 40 04             	mov    0x4(%eax),%eax
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	73 12                	jae    800b07 <sprintputch+0x33>
		*b->buf++ = ch;
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	8b 00                	mov    (%eax),%eax
  800afa:	8d 48 01             	lea    0x1(%eax),%ecx
  800afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b00:	89 0a                	mov    %ecx,(%edx)
  800b02:	8b 55 08             	mov    0x8(%ebp),%edx
  800b05:	88 10                	mov    %dl,(%eax)
}
  800b07:	90                   	nop
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	01 d0                	add    %edx,%eax
  800b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2f:	74 06                	je     800b37 <vsnprintf+0x2d>
  800b31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b35:	7f 07                	jg     800b3e <vsnprintf+0x34>
		return -E_INVAL;
  800b37:	b8 03 00 00 00       	mov    $0x3,%eax
  800b3c:	eb 20                	jmp    800b5e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b3e:	ff 75 14             	pushl  0x14(%ebp)
  800b41:	ff 75 10             	pushl  0x10(%ebp)
  800b44:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b47:	50                   	push   %eax
  800b48:	68 d4 0a 80 00       	push   $0x800ad4
  800b4d:	e8 92 fb ff ff       	call   8006e4 <vprintfmt>
  800b52:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b58:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b5e:	c9                   	leave  
  800b5f:	c3                   	ret    

00800b60 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b66:	8d 45 10             	lea    0x10(%ebp),%eax
  800b69:	83 c0 04             	add    $0x4,%eax
  800b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b72:	ff 75 f4             	pushl  -0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	ff 75 08             	pushl  0x8(%ebp)
  800b7c:	e8 89 ff ff ff       	call   800b0a <vsnprintf>
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b99:	eb 06                	jmp    800ba1 <strlen+0x15>
		n++;
  800b9b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b9e:	ff 45 08             	incl   0x8(%ebp)
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	84 c0                	test   %al,%al
  800ba8:	75 f1                	jne    800b9b <strlen+0xf>
		n++;
	return n;
  800baa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bbc:	eb 09                	jmp    800bc7 <strnlen+0x18>
		n++;
  800bbe:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc1:	ff 45 08             	incl   0x8(%ebp)
  800bc4:	ff 4d 0c             	decl   0xc(%ebp)
  800bc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bcb:	74 09                	je     800bd6 <strnlen+0x27>
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 e8                	jne    800bbe <strnlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800be7:	90                   	nop
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8d 50 01             	lea    0x1(%eax),%edx
  800bee:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bfa:	8a 12                	mov    (%edx),%dl
  800bfc:	88 10                	mov    %dl,(%eax)
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	84 c0                	test   %al,%al
  800c02:	75 e4                	jne    800be8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 1f                	jmp    800c3d <strncpy+0x34>
		*dst++ = *src;
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8d 50 01             	lea    0x1(%eax),%edx
  800c24:	89 55 08             	mov    %edx,0x8(%ebp)
  800c27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2a:	8a 12                	mov    (%edx),%dl
  800c2c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	84 c0                	test   %al,%al
  800c35:	74 03                	je     800c3a <strncpy+0x31>
			src++;
  800c37:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3a:	ff 45 fc             	incl   -0x4(%ebp)
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c40:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c43:	72 d9                	jb     800c1e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c45:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5a:	74 30                	je     800c8c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c5c:	eb 16                	jmp    800c74 <strlcpy+0x2a>
			*dst++ = *src++;
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8d 50 01             	lea    0x1(%eax),%edx
  800c64:	89 55 08             	mov    %edx,0x8(%ebp)
  800c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c70:	8a 12                	mov    (%edx),%dl
  800c72:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c74:	ff 4d 10             	decl   0x10(%ebp)
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	74 09                	je     800c86 <strlcpy+0x3c>
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8a 00                	mov    (%eax),%al
  800c82:	84 c0                	test   %al,%al
  800c84:	75 d8                	jne    800c5e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c92:	29 c2                	sub    %eax,%edx
  800c94:	89 d0                	mov    %edx,%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c9b:	eb 06                	jmp    800ca3 <strcmp+0xb>
		p++, q++;
  800c9d:	ff 45 08             	incl   0x8(%ebp)
  800ca0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	84 c0                	test   %al,%al
  800caa:	74 0e                	je     800cba <strcmp+0x22>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 10                	mov    (%eax),%dl
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	38 c2                	cmp    %al,%dl
  800cb8:	74 e3                	je     800c9d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	0f b6 d0             	movzbl %al,%edx
  800cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 c0             	movzbl %al,%eax
  800cca:	29 c2                	sub    %eax,%edx
  800ccc:	89 d0                	mov    %edx,%eax
}
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd3:	eb 09                	jmp    800cde <strncmp+0xe>
		n--, p++, q++;
  800cd5:	ff 4d 10             	decl   0x10(%ebp)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 17                	je     800cfb <strncmp+0x2b>
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	74 0e                	je     800cfb <strncmp+0x2b>
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8a 10                	mov    (%eax),%dl
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	38 c2                	cmp    %al,%dl
  800cf9:	74 da                	je     800cd5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	75 07                	jne    800d08 <strncmp+0x38>
		return 0;
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	eb 14                	jmp    800d1c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	0f b6 d0             	movzbl %al,%edx
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	0f b6 c0             	movzbl %al,%eax
  800d18:	29 c2                	sub    %eax,%edx
  800d1a:	89 d0                	mov    %edx,%eax
}
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 04             	sub    $0x4,%esp
  800d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2a:	eb 12                	jmp    800d3e <strchr+0x20>
		if (*s == c)
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d34:	75 05                	jne    800d3b <strchr+0x1d>
			return (char *) s;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	eb 11                	jmp    800d4c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d3b:	ff 45 08             	incl   0x8(%ebp)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	84 c0                	test   %al,%al
  800d45:	75 e5                	jne    800d2c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 04             	sub    $0x4,%esp
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5a:	eb 0d                	jmp    800d69 <strfind+0x1b>
		if (*s == c)
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d64:	74 0e                	je     800d74 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d66:	ff 45 08             	incl   0x8(%ebp)
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	84 c0                	test   %al,%al
  800d70:	75 ea                	jne    800d5c <strfind+0xe>
  800d72:	eb 01                	jmp    800d75 <strfind+0x27>
		if (*s == c)
			break;
  800d74:	90                   	nop
	return (char *) s;
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d8c:	eb 0e                	jmp    800d9c <memset+0x22>
		*p++ = c;
  800d8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d9c:	ff 4d f8             	decl   -0x8(%ebp)
  800d9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da3:	79 e9                	jns    800d8e <memset+0x14>
		*p++ = c;

	return v;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dbc:	eb 16                	jmp    800dd4 <memcpy+0x2a>
		*d++ = *s++;
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc1:	8d 50 01             	lea    0x1(%eax),%edx
  800dc4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dcd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd0:	8a 12                	mov    (%edx),%dl
  800dd2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dda:	89 55 10             	mov    %edx,0x10(%ebp)
  800ddd:	85 c0                	test   %eax,%eax
  800ddf:	75 dd                	jne    800dbe <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de4:	c9                   	leave  
  800de5:	c3                   	ret    

00800de6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800def:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dfe:	73 50                	jae    800e50 <memmove+0x6a>
  800e00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	01 d0                	add    %edx,%eax
  800e08:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e0b:	76 43                	jbe    800e50 <memmove+0x6a>
		s += n;
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e19:	eb 10                	jmp    800e2b <memmove+0x45>
			*--d = *--s;
  800e1b:	ff 4d f8             	decl   -0x8(%ebp)
  800e1e:	ff 4d fc             	decl   -0x4(%ebp)
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8a 10                	mov    (%eax),%dl
  800e26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e29:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e31:	89 55 10             	mov    %edx,0x10(%ebp)
  800e34:	85 c0                	test   %eax,%eax
  800e36:	75 e3                	jne    800e1b <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e38:	eb 23                	jmp    800e5d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3d:	8d 50 01             	lea    0x1(%eax),%edx
  800e40:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e49:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4c:	8a 12                	mov    (%edx),%dl
  800e4e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e50:	8b 45 10             	mov    0x10(%ebp),%eax
  800e53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e56:	89 55 10             	mov    %edx,0x10(%ebp)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	75 dd                	jne    800e3a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e74:	eb 2a                	jmp    800ea0 <memcmp+0x3e>
		if (*s1 != *s2)
  800e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e79:	8a 10                	mov    (%eax),%dl
  800e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	38 c2                	cmp    %al,%dl
  800e82:	74 16                	je     800e9a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	0f b6 d0             	movzbl %al,%edx
  800e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	0f b6 c0             	movzbl %al,%eax
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	eb 18                	jmp    800eb2 <memcmp+0x50>
		s1++, s2++;
  800e9a:	ff 45 fc             	incl   -0x4(%ebp)
  800e9d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	75 c9                	jne    800e76 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec0:	01 d0                	add    %edx,%eax
  800ec2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec5:	eb 15                	jmp    800edc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	0f b6 d0             	movzbl %al,%edx
  800ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed2:	0f b6 c0             	movzbl %al,%eax
  800ed5:	39 c2                	cmp    %eax,%edx
  800ed7:	74 0d                	je     800ee6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee2:	72 e3                	jb     800ec7 <memfind+0x13>
  800ee4:	eb 01                	jmp    800ee7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee6:	90                   	nop
	return (void *) s;
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ef9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f00:	eb 03                	jmp    800f05 <strtol+0x19>
		s++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	3c 20                	cmp    $0x20,%al
  800f0c:	74 f4                	je     800f02 <strtol+0x16>
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	3c 09                	cmp    $0x9,%al
  800f15:	74 eb                	je     800f02 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	3c 2b                	cmp    $0x2b,%al
  800f1e:	75 05                	jne    800f25 <strtol+0x39>
		s++;
  800f20:	ff 45 08             	incl   0x8(%ebp)
  800f23:	eb 13                	jmp    800f38 <strtol+0x4c>
	else if (*s == '-')
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	3c 2d                	cmp    $0x2d,%al
  800f2c:	75 0a                	jne    800f38 <strtol+0x4c>
		s++, neg = 1;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
  800f31:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3c:	74 06                	je     800f44 <strtol+0x58>
  800f3e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f42:	75 20                	jne    800f64 <strtol+0x78>
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 30                	cmp    $0x30,%al
  800f4b:	75 17                	jne    800f64 <strtol+0x78>
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	40                   	inc    %eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 78                	cmp    $0x78,%al
  800f55:	75 0d                	jne    800f64 <strtol+0x78>
		s += 2, base = 16;
  800f57:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f5b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f62:	eb 28                	jmp    800f8c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	75 15                	jne    800f7f <strtol+0x93>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 30                	cmp    $0x30,%al
  800f71:	75 0c                	jne    800f7f <strtol+0x93>
		s++, base = 8;
  800f73:	ff 45 08             	incl   0x8(%ebp)
  800f76:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f7d:	eb 0d                	jmp    800f8c <strtol+0xa0>
	else if (base == 0)
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 07                	jne    800f8c <strtol+0xa0>
		base = 10;
  800f85:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2f                	cmp    $0x2f,%al
  800f93:	7e 19                	jle    800fae <strtol+0xc2>
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	3c 39                	cmp    $0x39,%al
  800f9c:	7f 10                	jg     800fae <strtol+0xc2>
			dig = *s - '0';
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	0f be c0             	movsbl %al,%eax
  800fa6:	83 e8 30             	sub    $0x30,%eax
  800fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fac:	eb 42                	jmp    800ff0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 60                	cmp    $0x60,%al
  800fb5:	7e 19                	jle    800fd0 <strtol+0xe4>
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 7a                	cmp    $0x7a,%al
  800fbe:	7f 10                	jg     800fd0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	0f be c0             	movsbl %al,%eax
  800fc8:	83 e8 57             	sub    $0x57,%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 20                	jmp    800ff0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	3c 40                	cmp    $0x40,%al
  800fd7:	7e 39                	jle    801012 <strtol+0x126>
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	3c 5a                	cmp    $0x5a,%al
  800fe0:	7f 30                	jg     801012 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	0f be c0             	movsbl %al,%eax
  800fea:	83 e8 37             	sub    $0x37,%eax
  800fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff6:	7d 19                	jge    801011 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ff8:	ff 45 08             	incl   0x8(%ebp)
  800ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffe:	0f af 45 10          	imul   0x10(%ebp),%eax
  801002:	89 c2                	mov    %eax,%edx
  801004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80100c:	e9 7b ff ff ff       	jmp    800f8c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801011:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801012:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801016:	74 08                	je     801020 <strtol+0x134>
		*endptr = (char *) s;
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	8b 55 08             	mov    0x8(%ebp),%edx
  80101e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801020:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801024:	74 07                	je     80102d <strtol+0x141>
  801026:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801029:	f7 d8                	neg    %eax
  80102b:	eb 03                	jmp    801030 <strtol+0x144>
  80102d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <ltostr>:

void
ltostr(long value, char *str)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80103f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801046:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104a:	79 13                	jns    80105f <ltostr+0x2d>
	{
		neg = 1;
  80104c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801059:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80105c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801067:	99                   	cltd   
  801068:	f7 f9                	idiv   %ecx
  80106a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	89 c2                	mov    %eax,%edx
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	01 d0                	add    %edx,%eax
  80107d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801080:	83 c2 30             	add    $0x30,%edx
  801083:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801085:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801088:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80108d:	f7 e9                	imul   %ecx
  80108f:	c1 fa 02             	sar    $0x2,%edx
  801092:	89 c8                	mov    %ecx,%eax
  801094:	c1 f8 1f             	sar    $0x1f,%eax
  801097:	29 c2                	sub    %eax,%edx
  801099:	89 d0                	mov    %edx,%eax
  80109b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80109e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a6:	f7 e9                	imul   %ecx
  8010a8:	c1 fa 02             	sar    $0x2,%edx
  8010ab:	89 c8                	mov    %ecx,%eax
  8010ad:	c1 f8 1f             	sar    $0x1f,%eax
  8010b0:	29 c2                	sub    %eax,%edx
  8010b2:	89 d0                	mov    %edx,%eax
  8010b4:	c1 e0 02             	shl    $0x2,%eax
  8010b7:	01 d0                	add    %edx,%eax
  8010b9:	01 c0                	add    %eax,%eax
  8010bb:	29 c1                	sub    %eax,%ecx
  8010bd:	89 ca                	mov    %ecx,%edx
  8010bf:	85 d2                	test   %edx,%edx
  8010c1:	75 9c                	jne    80105f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cd:	48                   	dec    %eax
  8010ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d5:	74 3d                	je     801114 <ltostr+0xe2>
		start = 1 ;
  8010d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010de:	eb 34                	jmp    801114 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	01 d0                	add    %edx,%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 c2                	add    %eax,%edx
  8010f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	01 c8                	add    %ecx,%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801101:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 c2                	add    %eax,%edx
  801109:	8a 45 eb             	mov    -0x15(%ebp),%al
  80110c:	88 02                	mov    %al,(%edx)
		start++ ;
  80110e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801111:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801117:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111a:	7c c4                	jl     8010e0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80111c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 d0                	add    %edx,%eax
  801124:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801127:	90                   	nop
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801130:	ff 75 08             	pushl  0x8(%ebp)
  801133:	e8 54 fa ff ff       	call   800b8c <strlen>
  801138:	83 c4 04             	add    $0x4,%esp
  80113b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	e8 46 fa ff ff       	call   800b8c <strlen>
  801146:	83 c4 04             	add    $0x4,%esp
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801153:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115a:	eb 17                	jmp    801173 <strcconcat+0x49>
		final[s] = str1[s] ;
  80115c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	01 c2                	add    %eax,%edx
  801164:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	01 c8                	add    %ecx,%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801170:	ff 45 fc             	incl   -0x4(%ebp)
  801173:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801176:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801179:	7c e1                	jl     80115c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80117b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801182:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801189:	eb 1f                	jmp    8011aa <strcconcat+0x80>
		final[s++] = str2[i] ;
  80118b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118e:	8d 50 01             	lea    0x1(%eax),%edx
  801191:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801194:	89 c2                	mov    %eax,%edx
  801196:	8b 45 10             	mov    0x10(%ebp),%eax
  801199:	01 c2                	add    %eax,%edx
  80119b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	01 c8                	add    %ecx,%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a7:	ff 45 f8             	incl   -0x8(%ebp)
  8011aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b0:	7c d9                	jl     80118b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b8:	01 d0                	add    %edx,%eax
  8011ba:	c6 00 00             	movb   $0x0,(%eax)
}
  8011bd:	90                   	nop
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cf:	8b 00                	mov    (%eax),%eax
  8011d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	01 d0                	add    %edx,%eax
  8011dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e3:	eb 0c                	jmp    8011f1 <strsplit+0x31>
			*string++ = 0;
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	8d 50 01             	lea    0x1(%eax),%edx
  8011eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ee:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	84 c0                	test   %al,%al
  8011f8:	74 18                	je     801212 <strsplit+0x52>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	0f be c0             	movsbl %al,%eax
  801202:	50                   	push   %eax
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	e8 13 fb ff ff       	call   800d1e <strchr>
  80120b:	83 c4 08             	add    $0x8,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	75 d3                	jne    8011e5 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 5a                	je     801275 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  80121b:	8b 45 14             	mov    0x14(%ebp),%eax
  80121e:	8b 00                	mov    (%eax),%eax
  801220:	83 f8 0f             	cmp    $0xf,%eax
  801223:	75 07                	jne    80122c <strsplit+0x6c>
		{
			return 0;
  801225:	b8 00 00 00 00       	mov    $0x0,%eax
  80122a:	eb 66                	jmp    801292 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 48 01             	lea    0x1(%eax),%ecx
  801234:	8b 55 14             	mov    0x14(%ebp),%edx
  801237:	89 0a                	mov    %ecx,(%edx)
  801239:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801240:	8b 45 10             	mov    0x10(%ebp),%eax
  801243:	01 c2                	add    %eax,%edx
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124a:	eb 03                	jmp    80124f <strsplit+0x8f>
			string++;
  80124c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	84 c0                	test   %al,%al
  801256:	74 8b                	je     8011e3 <strsplit+0x23>
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	0f be c0             	movsbl %al,%eax
  801260:	50                   	push   %eax
  801261:	ff 75 0c             	pushl  0xc(%ebp)
  801264:	e8 b5 fa ff ff       	call   800d1e <strchr>
  801269:	83 c4 08             	add    $0x8,%esp
  80126c:	85 c0                	test   %eax,%eax
  80126e:	74 dc                	je     80124c <strsplit+0x8c>
			string++;
	}
  801270:	e9 6e ff ff ff       	jmp    8011e3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801275:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801276:	8b 45 14             	mov    0x14(%ebp),%eax
  801279:	8b 00                	mov    (%eax),%eax
  80127b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801282:	8b 45 10             	mov    0x10(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80128d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801292:	c9                   	leave  
  801293:	c3                   	ret    

00801294 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	57                   	push   %edi
  801298:	56                   	push   %esi
  801299:	53                   	push   %ebx
  80129a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012ac:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012af:	cd 30                	int    $0x30
  8012b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	5b                   	pop    %ebx
  8012bb:	5e                   	pop    %esi
  8012bc:	5f                   	pop    %edi
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    

008012bf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	6a 00                	push   $0x0
  8012cb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ce:	50                   	push   %eax
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 be ff ff ff       	call   801294 <syscall>
  8012d6:	83 c4 18             	add    $0x18,%esp
}
  8012d9:	90                   	nop
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

008012dc <sys_cgetc>:

int
sys_cgetc(void)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 01                	push   $0x1
  8012eb:	e8 a4 ff ff ff       	call   801294 <syscall>
  8012f0:	83 c4 18             	add    $0x18,%esp
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	50                   	push   %eax
  801304:	6a 03                	push   $0x3
  801306:	e8 89 ff ff ff       	call   801294 <syscall>
  80130b:	83 c4 18             	add    $0x18,%esp
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 02                	push   $0x2
  80131f:	e8 70 ff ff ff       	call   801294 <syscall>
  801324:	83 c4 18             	add    $0x18,%esp
}
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <sys_env_exit>:

void sys_env_exit(void)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 04                	push   $0x4
  801338:	e8 57 ff ff ff       	call   801294 <syscall>
  80133d:	83 c4 18             	add    $0x18,%esp
}
  801340:	90                   	nop
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801346:	8b 55 0c             	mov    0xc(%ebp),%edx
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	52                   	push   %edx
  801353:	50                   	push   %eax
  801354:	6a 05                	push   $0x5
  801356:	e8 39 ff ff ff       	call   801294 <syscall>
  80135b:	83 c4 18             	add    $0x18,%esp
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	56                   	push   %esi
  801364:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801365:	8b 75 18             	mov    0x18(%ebp),%esi
  801368:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80136b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80136e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	51                   	push   %ecx
  801377:	52                   	push   %edx
  801378:	50                   	push   %eax
  801379:	6a 06                	push   $0x6
  80137b:	e8 14 ff ff ff       	call   801294 <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801386:	5b                   	pop    %ebx
  801387:	5e                   	pop    %esi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80138d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	52                   	push   %edx
  80139a:	50                   	push   %eax
  80139b:	6a 07                	push   $0x7
  80139d:	e8 f2 fe ff ff       	call   801294 <syscall>
  8013a2:	83 c4 18             	add    $0x18,%esp
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	ff 75 08             	pushl  0x8(%ebp)
  8013b6:	6a 08                	push   $0x8
  8013b8:	e8 d7 fe ff ff       	call   801294 <syscall>
  8013bd:	83 c4 18             	add    $0x18,%esp
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 09                	push   $0x9
  8013d1:	e8 be fe ff ff       	call   801294 <syscall>
  8013d6:	83 c4 18             	add    $0x18,%esp
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 0a                	push   $0xa
  8013ea:	e8 a5 fe ff ff       	call   801294 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 0b                	push   $0xb
  801403:	e8 8c fe ff ff       	call   801294 <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	ff 75 08             	pushl  0x8(%ebp)
  80141c:	6a 0d                	push   $0xd
  80141e:	e8 71 fe ff ff       	call   801294 <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
	return;
  801426:	90                   	nop
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	ff 75 08             	pushl  0x8(%ebp)
  801438:	6a 0e                	push   $0xe
  80143a:	e8 55 fe ff ff       	call   801294 <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
	return ;
  801442:	90                   	nop
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 0c                	push   $0xc
  801454:	e8 3b fe ff ff       	call   801294 <syscall>
  801459:	83 c4 18             	add    $0x18,%esp
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 10                	push   $0x10
  80146d:	e8 22 fe ff ff       	call   801294 <syscall>
  801472:	83 c4 18             	add    $0x18,%esp
}
  801475:	90                   	nop
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 11                	push   $0x11
  801487:	e8 08 fe ff ff       	call   801294 <syscall>
  80148c:	83 c4 18             	add    $0x18,%esp
}
  80148f:	90                   	nop
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_cputc>:


void
sys_cputc(const char c)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 04             	sub    $0x4,%esp
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80149e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	50                   	push   %eax
  8014ab:	6a 12                	push   $0x12
  8014ad:	e8 e2 fd ff ff       	call   801294 <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	90                   	nop
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 13                	push   $0x13
  8014c7:	e8 c8 fd ff ff       	call   801294 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	50                   	push   %eax
  8014e2:	6a 14                	push   $0x14
  8014e4:	e8 ab fd ff ff       	call   801294 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	50                   	push   %eax
  8014fd:	6a 17                	push   $0x17
  8014ff:	e8 90 fd ff ff       	call   801294 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	50                   	push   %eax
  801518:	6a 15                	push   $0x15
  80151a:	e8 75 fd ff ff       	call   801294 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	90                   	nop
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	50                   	push   %eax
  801534:	6a 16                	push   $0x16
  801536:	e8 59 fd ff ff       	call   801294 <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
}
  80153e:	90                   	nop
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80154d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801550:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	6a 00                	push   $0x0
  801559:	51                   	push   %ecx
  80155a:	52                   	push   %edx
  80155b:	ff 75 0c             	pushl  0xc(%ebp)
  80155e:	50                   	push   %eax
  80155f:	6a 18                	push   $0x18
  801561:	e8 2e fd ff ff       	call   801294 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  80156e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	52                   	push   %edx
  80157b:	50                   	push   %eax
  80157c:	6a 19                	push   $0x19
  80157e:	e8 11 fd ff ff       	call   801294 <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	50                   	push   %eax
  801597:	6a 1a                	push   $0x1a
  801599:	e8 f6 fc ff ff       	call   801294 <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 1b                	push   $0x1b
  8015b2:	e8 dd fc ff ff       	call   801294 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 1c                	push   $0x1c
  8015cb:	e8 c4 fc ff ff       	call   801294 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	ff 75 0c             	pushl  0xc(%ebp)
  8015e4:	50                   	push   %eax
  8015e5:	6a 1d                	push   $0x1d
  8015e7:	e8 a8 fc ff ff       	call   801294 <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	50                   	push   %eax
  801600:	6a 1e                	push   $0x1e
  801602:	e8 8d fc ff ff       	call   801294 <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
}
  80160a:	90                   	nop
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	50                   	push   %eax
  80161c:	6a 1f                	push   $0x1f
  80161e:	e8 71 fc ff ff       	call   801294 <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
}
  801626:	90                   	nop
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80162f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801632:	8d 50 04             	lea    0x4(%eax),%edx
  801635:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	52                   	push   %edx
  80163f:	50                   	push   %eax
  801640:	6a 20                	push   $0x20
  801642:	e8 4d fc ff ff       	call   801294 <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
	return result;
  80164a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80164d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801650:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801653:	89 01                	mov    %eax,(%ecx)
  801655:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	c9                   	leave  
  80165c:	c2 04 00             	ret    $0x4

0080165f <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	ff 75 10             	pushl  0x10(%ebp)
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	6a 0f                	push   $0xf
  801671:	e8 1e fc ff ff       	call   801294 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
	return ;
  801679:	90                   	nop
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_rcr2>:
uint32 sys_rcr2()
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 21                	push   $0x21
  80168b:	e8 04 fc ff ff       	call   801294 <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 04             	sub    $0x4,%esp
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016a1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	50                   	push   %eax
  8016ae:	6a 22                	push   $0x22
  8016b0:	e8 df fb ff ff       	call   801294 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b8:	90                   	nop
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <rsttst>:
void rsttst()
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 24                	push   $0x24
  8016ca:	e8 c5 fb ff ff       	call   801294 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d2:	90                   	nop
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 04             	sub    $0x4,%esp
  8016db:	8b 45 14             	mov    0x14(%ebp),%eax
  8016de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016e1:	8b 55 18             	mov    0x18(%ebp),%edx
  8016e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016e8:	52                   	push   %edx
  8016e9:	50                   	push   %eax
  8016ea:	ff 75 10             	pushl  0x10(%ebp)
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	ff 75 08             	pushl  0x8(%ebp)
  8016f3:	6a 23                	push   $0x23
  8016f5:	e8 9a fb ff ff       	call   801294 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8016fd:	90                   	nop
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <chktst>:
void chktst(uint32 n)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	6a 25                	push   $0x25
  801710:	e8 7f fb ff ff       	call   801294 <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
	return ;
  801718:	90                   	nop
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 26                	push   $0x26
  80172d:	e8 62 fb ff ff       	call   801294 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
  801735:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801738:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80173c:	75 07                	jne    801745 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80173e:	b8 01 00 00 00       	mov    $0x1,%eax
  801743:	eb 05                	jmp    80174a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 26                	push   $0x26
  80175e:	e8 31 fb ff ff       	call   801294 <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
  801766:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801769:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80176d:	75 07                	jne    801776 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80176f:	b8 01 00 00 00       	mov    $0x1,%eax
  801774:	eb 05                	jmp    80177b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801776:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 26                	push   $0x26
  80178f:	e8 00 fb ff ff       	call   801294 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
  801797:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80179a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80179e:	75 07                	jne    8017a7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a5:	eb 05                	jmp    8017ac <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 26                	push   $0x26
  8017c0:	e8 cf fa ff ff       	call   801294 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
  8017c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017cb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017cf:	75 07                	jne    8017d8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d6:	eb 05                	jmp    8017dd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	6a 27                	push   $0x27
  8017ef:	e8 a0 fa ff ff       	call   801294 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f7:	90                   	nop
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    
  8017fa:	66 90                	xchg   %ax,%ax

008017fc <__udivdi3>:
  8017fc:	55                   	push   %ebp
  8017fd:	57                   	push   %edi
  8017fe:	56                   	push   %esi
  8017ff:	53                   	push   %ebx
  801800:	83 ec 1c             	sub    $0x1c,%esp
  801803:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801807:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80180b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80180f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801813:	89 ca                	mov    %ecx,%edx
  801815:	89 f8                	mov    %edi,%eax
  801817:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80181b:	85 f6                	test   %esi,%esi
  80181d:	75 2d                	jne    80184c <__udivdi3+0x50>
  80181f:	39 cf                	cmp    %ecx,%edi
  801821:	77 65                	ja     801888 <__udivdi3+0x8c>
  801823:	89 fd                	mov    %edi,%ebp
  801825:	85 ff                	test   %edi,%edi
  801827:	75 0b                	jne    801834 <__udivdi3+0x38>
  801829:	b8 01 00 00 00       	mov    $0x1,%eax
  80182e:	31 d2                	xor    %edx,%edx
  801830:	f7 f7                	div    %edi
  801832:	89 c5                	mov    %eax,%ebp
  801834:	31 d2                	xor    %edx,%edx
  801836:	89 c8                	mov    %ecx,%eax
  801838:	f7 f5                	div    %ebp
  80183a:	89 c1                	mov    %eax,%ecx
  80183c:	89 d8                	mov    %ebx,%eax
  80183e:	f7 f5                	div    %ebp
  801840:	89 cf                	mov    %ecx,%edi
  801842:	89 fa                	mov    %edi,%edx
  801844:	83 c4 1c             	add    $0x1c,%esp
  801847:	5b                   	pop    %ebx
  801848:	5e                   	pop    %esi
  801849:	5f                   	pop    %edi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    
  80184c:	39 ce                	cmp    %ecx,%esi
  80184e:	77 28                	ja     801878 <__udivdi3+0x7c>
  801850:	0f bd fe             	bsr    %esi,%edi
  801853:	83 f7 1f             	xor    $0x1f,%edi
  801856:	75 40                	jne    801898 <__udivdi3+0x9c>
  801858:	39 ce                	cmp    %ecx,%esi
  80185a:	72 0a                	jb     801866 <__udivdi3+0x6a>
  80185c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801860:	0f 87 9e 00 00 00    	ja     801904 <__udivdi3+0x108>
  801866:	b8 01 00 00 00       	mov    $0x1,%eax
  80186b:	89 fa                	mov    %edi,%edx
  80186d:	83 c4 1c             	add    $0x1c,%esp
  801870:	5b                   	pop    %ebx
  801871:	5e                   	pop    %esi
  801872:	5f                   	pop    %edi
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    
  801875:	8d 76 00             	lea    0x0(%esi),%esi
  801878:	31 ff                	xor    %edi,%edi
  80187a:	31 c0                	xor    %eax,%eax
  80187c:	89 fa                	mov    %edi,%edx
  80187e:	83 c4 1c             	add    $0x1c,%esp
  801881:	5b                   	pop    %ebx
  801882:	5e                   	pop    %esi
  801883:	5f                   	pop    %edi
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    
  801886:	66 90                	xchg   %ax,%ax
  801888:	89 d8                	mov    %ebx,%eax
  80188a:	f7 f7                	div    %edi
  80188c:	31 ff                	xor    %edi,%edi
  80188e:	89 fa                	mov    %edi,%edx
  801890:	83 c4 1c             	add    $0x1c,%esp
  801893:	5b                   	pop    %ebx
  801894:	5e                   	pop    %esi
  801895:	5f                   	pop    %edi
  801896:	5d                   	pop    %ebp
  801897:	c3                   	ret    
  801898:	bd 20 00 00 00       	mov    $0x20,%ebp
  80189d:	89 eb                	mov    %ebp,%ebx
  80189f:	29 fb                	sub    %edi,%ebx
  8018a1:	89 f9                	mov    %edi,%ecx
  8018a3:	d3 e6                	shl    %cl,%esi
  8018a5:	89 c5                	mov    %eax,%ebp
  8018a7:	88 d9                	mov    %bl,%cl
  8018a9:	d3 ed                	shr    %cl,%ebp
  8018ab:	89 e9                	mov    %ebp,%ecx
  8018ad:	09 f1                	or     %esi,%ecx
  8018af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018b3:	89 f9                	mov    %edi,%ecx
  8018b5:	d3 e0                	shl    %cl,%eax
  8018b7:	89 c5                	mov    %eax,%ebp
  8018b9:	89 d6                	mov    %edx,%esi
  8018bb:	88 d9                	mov    %bl,%cl
  8018bd:	d3 ee                	shr    %cl,%esi
  8018bf:	89 f9                	mov    %edi,%ecx
  8018c1:	d3 e2                	shl    %cl,%edx
  8018c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018c7:	88 d9                	mov    %bl,%cl
  8018c9:	d3 e8                	shr    %cl,%eax
  8018cb:	09 c2                	or     %eax,%edx
  8018cd:	89 d0                	mov    %edx,%eax
  8018cf:	89 f2                	mov    %esi,%edx
  8018d1:	f7 74 24 0c          	divl   0xc(%esp)
  8018d5:	89 d6                	mov    %edx,%esi
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	f7 e5                	mul    %ebp
  8018db:	39 d6                	cmp    %edx,%esi
  8018dd:	72 19                	jb     8018f8 <__udivdi3+0xfc>
  8018df:	74 0b                	je     8018ec <__udivdi3+0xf0>
  8018e1:	89 d8                	mov    %ebx,%eax
  8018e3:	31 ff                	xor    %edi,%edi
  8018e5:	e9 58 ff ff ff       	jmp    801842 <__udivdi3+0x46>
  8018ea:	66 90                	xchg   %ax,%ax
  8018ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8018f0:	89 f9                	mov    %edi,%ecx
  8018f2:	d3 e2                	shl    %cl,%edx
  8018f4:	39 c2                	cmp    %eax,%edx
  8018f6:	73 e9                	jae    8018e1 <__udivdi3+0xe5>
  8018f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8018fb:	31 ff                	xor    %edi,%edi
  8018fd:	e9 40 ff ff ff       	jmp    801842 <__udivdi3+0x46>
  801902:	66 90                	xchg   %ax,%ax
  801904:	31 c0                	xor    %eax,%eax
  801906:	e9 37 ff ff ff       	jmp    801842 <__udivdi3+0x46>
  80190b:	90                   	nop

0080190c <__umoddi3>:
  80190c:	55                   	push   %ebp
  80190d:	57                   	push   %edi
  80190e:	56                   	push   %esi
  80190f:	53                   	push   %ebx
  801910:	83 ec 1c             	sub    $0x1c,%esp
  801913:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801917:	8b 74 24 34          	mov    0x34(%esp),%esi
  80191b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80191f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801923:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801927:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80192b:	89 f3                	mov    %esi,%ebx
  80192d:	89 fa                	mov    %edi,%edx
  80192f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801933:	89 34 24             	mov    %esi,(%esp)
  801936:	85 c0                	test   %eax,%eax
  801938:	75 1a                	jne    801954 <__umoddi3+0x48>
  80193a:	39 f7                	cmp    %esi,%edi
  80193c:	0f 86 a2 00 00 00    	jbe    8019e4 <__umoddi3+0xd8>
  801942:	89 c8                	mov    %ecx,%eax
  801944:	89 f2                	mov    %esi,%edx
  801946:	f7 f7                	div    %edi
  801948:	89 d0                	mov    %edx,%eax
  80194a:	31 d2                	xor    %edx,%edx
  80194c:	83 c4 1c             	add    $0x1c,%esp
  80194f:	5b                   	pop    %ebx
  801950:	5e                   	pop    %esi
  801951:	5f                   	pop    %edi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    
  801954:	39 f0                	cmp    %esi,%eax
  801956:	0f 87 ac 00 00 00    	ja     801a08 <__umoddi3+0xfc>
  80195c:	0f bd e8             	bsr    %eax,%ebp
  80195f:	83 f5 1f             	xor    $0x1f,%ebp
  801962:	0f 84 ac 00 00 00    	je     801a14 <__umoddi3+0x108>
  801968:	bf 20 00 00 00       	mov    $0x20,%edi
  80196d:	29 ef                	sub    %ebp,%edi
  80196f:	89 fe                	mov    %edi,%esi
  801971:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801975:	89 e9                	mov    %ebp,%ecx
  801977:	d3 e0                	shl    %cl,%eax
  801979:	89 d7                	mov    %edx,%edi
  80197b:	89 f1                	mov    %esi,%ecx
  80197d:	d3 ef                	shr    %cl,%edi
  80197f:	09 c7                	or     %eax,%edi
  801981:	89 e9                	mov    %ebp,%ecx
  801983:	d3 e2                	shl    %cl,%edx
  801985:	89 14 24             	mov    %edx,(%esp)
  801988:	89 d8                	mov    %ebx,%eax
  80198a:	d3 e0                	shl    %cl,%eax
  80198c:	89 c2                	mov    %eax,%edx
  80198e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801992:	d3 e0                	shl    %cl,%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	8b 44 24 08          	mov    0x8(%esp),%eax
  80199c:	89 f1                	mov    %esi,%ecx
  80199e:	d3 e8                	shr    %cl,%eax
  8019a0:	09 d0                	or     %edx,%eax
  8019a2:	d3 eb                	shr    %cl,%ebx
  8019a4:	89 da                	mov    %ebx,%edx
  8019a6:	f7 f7                	div    %edi
  8019a8:	89 d3                	mov    %edx,%ebx
  8019aa:	f7 24 24             	mull   (%esp)
  8019ad:	89 c6                	mov    %eax,%esi
  8019af:	89 d1                	mov    %edx,%ecx
  8019b1:	39 d3                	cmp    %edx,%ebx
  8019b3:	0f 82 87 00 00 00    	jb     801a40 <__umoddi3+0x134>
  8019b9:	0f 84 91 00 00 00    	je     801a50 <__umoddi3+0x144>
  8019bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019c3:	29 f2                	sub    %esi,%edx
  8019c5:	19 cb                	sbb    %ecx,%ebx
  8019c7:	89 d8                	mov    %ebx,%eax
  8019c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019cd:	d3 e0                	shl    %cl,%eax
  8019cf:	89 e9                	mov    %ebp,%ecx
  8019d1:	d3 ea                	shr    %cl,%edx
  8019d3:	09 d0                	or     %edx,%eax
  8019d5:	89 e9                	mov    %ebp,%ecx
  8019d7:	d3 eb                	shr    %cl,%ebx
  8019d9:	89 da                	mov    %ebx,%edx
  8019db:	83 c4 1c             	add    $0x1c,%esp
  8019de:	5b                   	pop    %ebx
  8019df:	5e                   	pop    %esi
  8019e0:	5f                   	pop    %edi
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    
  8019e3:	90                   	nop
  8019e4:	89 fd                	mov    %edi,%ebp
  8019e6:	85 ff                	test   %edi,%edi
  8019e8:	75 0b                	jne    8019f5 <__umoddi3+0xe9>
  8019ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ef:	31 d2                	xor    %edx,%edx
  8019f1:	f7 f7                	div    %edi
  8019f3:	89 c5                	mov    %eax,%ebp
  8019f5:	89 f0                	mov    %esi,%eax
  8019f7:	31 d2                	xor    %edx,%edx
  8019f9:	f7 f5                	div    %ebp
  8019fb:	89 c8                	mov    %ecx,%eax
  8019fd:	f7 f5                	div    %ebp
  8019ff:	89 d0                	mov    %edx,%eax
  801a01:	e9 44 ff ff ff       	jmp    80194a <__umoddi3+0x3e>
  801a06:	66 90                	xchg   %ax,%ax
  801a08:	89 c8                	mov    %ecx,%eax
  801a0a:	89 f2                	mov    %esi,%edx
  801a0c:	83 c4 1c             	add    $0x1c,%esp
  801a0f:	5b                   	pop    %ebx
  801a10:	5e                   	pop    %esi
  801a11:	5f                   	pop    %edi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    
  801a14:	3b 04 24             	cmp    (%esp),%eax
  801a17:	72 06                	jb     801a1f <__umoddi3+0x113>
  801a19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a1d:	77 0f                	ja     801a2e <__umoddi3+0x122>
  801a1f:	89 f2                	mov    %esi,%edx
  801a21:	29 f9                	sub    %edi,%ecx
  801a23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a27:	89 14 24             	mov    %edx,(%esp)
  801a2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a32:	8b 14 24             	mov    (%esp),%edx
  801a35:	83 c4 1c             	add    $0x1c,%esp
  801a38:	5b                   	pop    %ebx
  801a39:	5e                   	pop    %esi
  801a3a:	5f                   	pop    %edi
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    
  801a3d:	8d 76 00             	lea    0x0(%esi),%esi
  801a40:	2b 04 24             	sub    (%esp),%eax
  801a43:	19 fa                	sbb    %edi,%edx
  801a45:	89 d1                	mov    %edx,%ecx
  801a47:	89 c6                	mov    %eax,%esi
  801a49:	e9 71 ff ff ff       	jmp    8019bf <__umoddi3+0xb3>
  801a4e:	66 90                	xchg   %ax,%ax
  801a50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a54:	72 ea                	jb     801a40 <__umoddi3+0x134>
  801a56:	89 d9                	mov    %ebx,%ecx
  801a58:	e9 62 ff ff ff       	jmp    8019bf <__umoddi3+0xb3>
