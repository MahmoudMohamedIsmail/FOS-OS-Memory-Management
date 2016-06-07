
obj/user/tst_realloc_1:     file format elf32-i386


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
  800031:	e8 e6 0f 00 00       	call   80101c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* ALLOCATION STRATEGY = FIRST FIT */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 90 00 00 00    	sub    $0x90,%esp
	int envID = sys_getenvid();
  800043:	e8 61 2a 00 00       	call   802aa9 <sys_getenvid>
  800048:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80004e:	89 d0                	mov    %edx,%eax
  800050:	c1 e0 03             	shl    $0x3,%eax
  800053:	01 d0                	add    %edx,%eax
  800055:	01 c0                	add    %eax,%eax
  800057:	01 d0                	add    %edx,%eax
  800059:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800060:	01 d0                	add    %edx,%eax
  800062:	c1 e0 03             	shl    $0x3,%eax
  800065:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int Mega = 1024*1024;
  80006d:	c7 45 dc 00 00 10 00 	movl   $0x100000,-0x24(%ebp)
	int kilo = 1024;
  800074:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	void* ptr_allocations[20] = {0};
  80007b:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  800081:	b9 14 00 00 00       	mov    $0x14,%ecx
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	89 d7                	mov    %edx,%edi
  80008d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[0] Make sure there're available places in the WS (1030)
	int w = 0 ;
  80008f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int requiredNumOfEmptyWSLocs = 1030;
  800096:	c7 45 d4 06 04 00 00 	movl   $0x406,-0x2c(%ebp)
	int numOfEmptyWSLocs = 0;
  80009d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8000a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ab:	eb 24                	jmp    8000d1 <_main+0x99>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8000ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000b0:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8000b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000b9:	89 d0                	mov    %edx,%eax
  8000bb:	01 c0                	add    %eax,%eax
  8000bd:	01 d0                	add    %edx,%eax
  8000bf:	c1 e0 02             	shl    $0x2,%eax
  8000c2:	01 c8                	add    %ecx,%eax
  8000c4:	8a 40 04             	mov    0x4(%eax),%al
  8000c7:	3c 01                	cmp    $0x1,%al
  8000c9:	75 03                	jne    8000ce <_main+0x96>
			numOfEmptyWSLocs++;
  8000cb:	ff 45 f0             	incl   -0x10(%ebp)
	int usedDiskPages;
	//[0] Make sure there're available places in the WS (1030)
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 1030;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8000ce:	ff 45 f4             	incl   -0xc(%ebp)
  8000d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d4:	8b 50 74             	mov    0x74(%eax),%edx
  8000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000da:	39 c2                	cmp    %eax,%edx
  8000dc:	77 cf                	ja     8000ad <_main+0x75>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8000de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8000e4:	7d 14                	jge    8000fa <_main+0xc2>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 00 32 80 00       	push   $0x803200
  8000ee:	6a 1c                	push   $0x1c
  8000f0:	68 50 32 80 00       	push   $0x803250
  8000f5:	e8 e3 0f 00 00       	call   8010dd <_panic>

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	68 68 32 80 00       	push   $0x803268
  800102:	e8 01 11 00 00       	call   801208 <cprintf>
  800107:	83 c4 10             	add    $0x10,%esp

	//[1] Allocate all
	{
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80010a:	e8 cf 2a 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  80010f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800112:	e8 44 2a 00 00       	call   802b5b <sys_calculate_free_frames>
  800117:	89 45 cc             	mov    %eax,-0x34(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80011a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80011d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 62 1e 00 00       	call   801f8b <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800132:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800138:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 b8 32 80 00       	push   $0x8032b8
  800147:	6a 27                	push   $0x27
  800149:	68 50 32 80 00       	push   $0x803250
  80014e:	e8 8a 0f 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800156:	e8 00 2a 00 00       	call   802b5b <sys_calculate_free_frames>
  80015b:	29 c3                	sub    %eax,%ebx
  80015d:	89 d8                	mov    %ebx,%eax
  80015f:	83 f8 01             	cmp    $0x1,%eax
  800162:	74 14                	je     800178 <_main+0x140>
  800164:	83 ec 04             	sub    $0x4,%esp
  800167:	68 e8 32 80 00       	push   $0x8032e8
  80016c:	6a 29                	push   $0x29
  80016e:	68 50 32 80 00       	push   $0x803250
  800173:	e8 65 0f 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800178:	e8 61 2a 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  80017d:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800180:	3d 00 01 00 00       	cmp    $0x100,%eax
  800185:	74 14                	je     80019b <_main+0x163>
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	68 54 33 80 00       	push   $0x803354
  80018f:	6a 2a                	push   $0x2a
  800191:	68 50 32 80 00       	push   $0x803250
  800196:	e8 42 0f 00 00       	call   8010dd <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80019b:	e8 bb 29 00 00       	call   802b5b <sys_calculate_free_frames>
  8001a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001a3:	e8 36 2a 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8001a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  8001ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ae:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	50                   	push   %eax
  8001b5:	e8 d1 1d 00 00       	call   801f8b <malloc>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8001c3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001c9:	89 c2                	mov    %eax,%edx
  8001cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ce:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d3:	39 c2                	cmp    %eax,%edx
  8001d5:	74 14                	je     8001eb <_main+0x1b3>
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	68 b8 32 80 00       	push   $0x8032b8
  8001df:	6a 30                	push   $0x30
  8001e1:	68 50 32 80 00       	push   $0x803250
  8001e6:	e8 f2 0e 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001eb:	e8 6b 29 00 00       	call   802b5b <sys_calculate_free_frames>
  8001f0:	89 c2                	mov    %eax,%edx
  8001f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001f5:	39 c2                	cmp    %eax,%edx
  8001f7:	74 14                	je     80020d <_main+0x1d5>
  8001f9:	83 ec 04             	sub    $0x4,%esp
  8001fc:	68 e8 32 80 00       	push   $0x8032e8
  800201:	6a 32                	push   $0x32
  800203:	68 50 32 80 00       	push   $0x803250
  800208:	e8 d0 0e 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80020d:	e8 cc 29 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800212:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800215:	3d 00 01 00 00       	cmp    $0x100,%eax
  80021a:	74 14                	je     800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 54 33 80 00       	push   $0x803354
  800224:	6a 33                	push   $0x33
  800226:	68 50 32 80 00       	push   $0x803250
  80022b:	e8 ad 0e 00 00       	call   8010dd <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800230:	e8 26 29 00 00       	call   802b5b <sys_calculate_free_frames>
  800235:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800238:	e8 a1 29 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  80023d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800240:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800243:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	50                   	push   %eax
  80024a:	e8 3c 1d 00 00       	call   801f8b <malloc>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800258:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80025e:	89 c2                	mov    %eax,%edx
  800260:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800263:	01 c0                	add    %eax,%eax
  800265:	05 00 00 00 80       	add    $0x80000000,%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 b8 32 80 00       	push   $0x8032b8
  800276:	6a 39                	push   $0x39
  800278:	68 50 32 80 00       	push   $0x803250
  80027d:	e8 5b 0e 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800282:	e8 d4 28 00 00       	call   802b5b <sys_calculate_free_frames>
  800287:	89 c2                	mov    %eax,%edx
  800289:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80028c:	39 c2                	cmp    %eax,%edx
  80028e:	74 14                	je     8002a4 <_main+0x26c>
  800290:	83 ec 04             	sub    $0x4,%esp
  800293:	68 e8 32 80 00       	push   $0x8032e8
  800298:	6a 3b                	push   $0x3b
  80029a:	68 50 32 80 00       	push   $0x803250
  80029f:	e8 39 0e 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8002a4:	e8 35 29 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8002a9:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002ac:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002b1:	74 14                	je     8002c7 <_main+0x28f>
  8002b3:	83 ec 04             	sub    $0x4,%esp
  8002b6:	68 54 33 80 00       	push   $0x803354
  8002bb:	6a 3c                	push   $0x3c
  8002bd:	68 50 32 80 00       	push   $0x803250
  8002c2:	e8 16 0e 00 00       	call   8010dd <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8002c7:	e8 8f 28 00 00       	call   802b5b <sys_calculate_free_frames>
  8002cc:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cf:	e8 0a 29 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8002d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8002d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002da:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	50                   	push   %eax
  8002e1:	e8 a5 1c 00 00       	call   801f8b <malloc>
  8002e6:	83 c4 10             	add    $0x10,%esp
  8002e9:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  8002ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8002f5:	89 c1                	mov    %eax,%ecx
  8002f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fa:	89 c2                	mov    %eax,%edx
  8002fc:	01 d2                	add    %edx,%edx
  8002fe:	01 d0                	add    %edx,%eax
  800300:	05 00 00 00 80       	add    $0x80000000,%eax
  800305:	39 c1                	cmp    %eax,%ecx
  800307:	74 14                	je     80031d <_main+0x2e5>
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 b8 32 80 00       	push   $0x8032b8
  800311:	6a 42                	push   $0x42
  800313:	68 50 32 80 00       	push   $0x803250
  800318:	e8 c0 0d 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80031d:	e8 39 28 00 00       	call   802b5b <sys_calculate_free_frames>
  800322:	89 c2                	mov    %eax,%edx
  800324:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800327:	39 c2                	cmp    %eax,%edx
  800329:	74 14                	je     80033f <_main+0x307>
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	68 e8 32 80 00       	push   $0x8032e8
  800333:	6a 44                	push   $0x44
  800335:	68 50 32 80 00       	push   $0x803250
  80033a:	e8 9e 0d 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80033f:	e8 9a 28 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800344:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800347:	3d 00 01 00 00       	cmp    $0x100,%eax
  80034c:	74 14                	je     800362 <_main+0x32a>
  80034e:	83 ec 04             	sub    $0x4,%esp
  800351:	68 54 33 80 00       	push   $0x803354
  800356:	6a 45                	push   $0x45
  800358:	68 50 32 80 00       	push   $0x803250
  80035d:	e8 7b 0d 00 00       	call   8010dd <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800362:	e8 f4 27 00 00       	call   802b5b <sys_calculate_free_frames>
  800367:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80036a:	e8 6f 28 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  80036f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800372:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	50                   	push   %eax
  80037e:	e8 08 1c 00 00       	call   801f8b <malloc>
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800389:	8b 45 80             	mov    -0x80(%ebp),%eax
  80038c:	89 c2                	mov    %eax,%edx
  80038e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800391:	c1 e0 02             	shl    $0x2,%eax
  800394:	05 00 00 00 80       	add    $0x80000000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 b8 32 80 00       	push   $0x8032b8
  8003a5:	6a 4b                	push   $0x4b
  8003a7:	68 50 32 80 00       	push   $0x803250
  8003ac:	e8 2c 0d 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003b1:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003b4:	e8 a2 27 00 00       	call   802b5b <sys_calculate_free_frames>
  8003b9:	29 c3                	sub    %eax,%ebx
  8003bb:	89 d8                	mov    %ebx,%eax
  8003bd:	83 f8 01             	cmp    $0x1,%eax
  8003c0:	74 14                	je     8003d6 <_main+0x39e>
  8003c2:	83 ec 04             	sub    $0x4,%esp
  8003c5:	68 e8 32 80 00       	push   $0x8032e8
  8003ca:	6a 4d                	push   $0x4d
  8003cc:	68 50 32 80 00       	push   $0x803250
  8003d1:	e8 07 0d 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003d6:	e8 03 28 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8003db:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003de:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003e3:	74 14                	je     8003f9 <_main+0x3c1>
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	68 54 33 80 00       	push   $0x803354
  8003ed:	6a 4e                	push   $0x4e
  8003ef:	68 50 32 80 00       	push   $0x803250
  8003f4:	e8 e4 0c 00 00       	call   8010dd <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003f9:	e8 5d 27 00 00       	call   802b5b <sys_calculate_free_frames>
  8003fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800401:	e8 d8 27 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800406:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800409:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040c:	01 c0                	add    %eax,%eax
  80040e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800411:	83 ec 0c             	sub    $0xc,%esp
  800414:	50                   	push   %eax
  800415:	e8 71 1b 00 00       	call   801f8b <malloc>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  800420:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800423:	89 c1                	mov    %eax,%ecx
  800425:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800428:	89 d0                	mov    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	01 c0                	add    %eax,%eax
  800430:	05 00 00 00 80       	add    $0x80000000,%eax
  800435:	39 c1                	cmp    %eax,%ecx
  800437:	74 14                	je     80044d <_main+0x415>
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	68 b8 32 80 00       	push   $0x8032b8
  800441:	6a 54                	push   $0x54
  800443:	68 50 32 80 00       	push   $0x803250
  800448:	e8 90 0c 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80044d:	e8 09 27 00 00       	call   802b5b <sys_calculate_free_frames>
  800452:	89 c2                	mov    %eax,%edx
  800454:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800457:	39 c2                	cmp    %eax,%edx
  800459:	74 14                	je     80046f <_main+0x437>
  80045b:	83 ec 04             	sub    $0x4,%esp
  80045e:	68 e8 32 80 00       	push   $0x8032e8
  800463:	6a 56                	push   $0x56
  800465:	68 50 32 80 00       	push   $0x803250
  80046a:	e8 6e 0c 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80046f:	e8 6a 27 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800474:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800477:	3d 00 02 00 00       	cmp    $0x200,%eax
  80047c:	74 14                	je     800492 <_main+0x45a>
  80047e:	83 ec 04             	sub    $0x4,%esp
  800481:	68 54 33 80 00       	push   $0x803354
  800486:	6a 57                	push   $0x57
  800488:	68 50 32 80 00       	push   $0x803250
  80048d:	e8 4b 0c 00 00       	call   8010dd <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800492:	e8 c4 26 00 00       	call   802b5b <sys_calculate_free_frames>
  800497:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80049a:	e8 3f 27 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  80049f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8004a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a5:	89 c2                	mov    %eax,%edx
  8004a7:	01 d2                	add    %edx,%edx
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8004ae:	83 ec 0c             	sub    $0xc,%esp
  8004b1:	50                   	push   %eax
  8004b2:	e8 d4 1a 00 00       	call   801f8b <malloc>
  8004b7:	83 c4 10             	add    $0x10,%esp
  8004ba:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8004bd:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004c0:	89 c2                	mov    %eax,%edx
  8004c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c5:	c1 e0 03             	shl    $0x3,%eax
  8004c8:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	74 14                	je     8004e5 <_main+0x4ad>
  8004d1:	83 ec 04             	sub    $0x4,%esp
  8004d4:	68 b8 32 80 00       	push   $0x8032b8
  8004d9:	6a 5d                	push   $0x5d
  8004db:	68 50 32 80 00       	push   $0x803250
  8004e0:	e8 f8 0b 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e8:	e8 6e 26 00 00       	call   802b5b <sys_calculate_free_frames>
  8004ed:	29 c3                	sub    %eax,%ebx
  8004ef:	89 d8                	mov    %ebx,%eax
  8004f1:	83 f8 01             	cmp    $0x1,%eax
  8004f4:	74 14                	je     80050a <_main+0x4d2>
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	68 e8 32 80 00       	push   $0x8032e8
  8004fe:	6a 5f                	push   $0x5f
  800500:	68 50 32 80 00       	push   $0x803250
  800505:	e8 d3 0b 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  80050a:	e8 cf 26 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  80050f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800512:	3d 00 03 00 00       	cmp    $0x300,%eax
  800517:	74 14                	je     80052d <_main+0x4f5>
  800519:	83 ec 04             	sub    $0x4,%esp
  80051c:	68 54 33 80 00       	push   $0x803354
  800521:	6a 60                	push   $0x60
  800523:	68 50 32 80 00       	push   $0x803250
  800528:	e8 b0 0b 00 00       	call   8010dd <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80052d:	e8 29 26 00 00       	call   802b5b <sys_calculate_free_frames>
  800532:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800535:	e8 a4 26 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  80053a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80053d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800540:	89 c2                	mov    %eax,%edx
  800542:	01 d2                	add    %edx,%edx
  800544:	01 d0                	add    %edx,%eax
  800546:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	50                   	push   %eax
  80054d:	e8 39 1a 00 00       	call   801f8b <malloc>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800558:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 02             	shl    $0x2,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	01 c0                	add    %eax,%eax
  800569:	01 d0                	add    %edx,%eax
  80056b:	05 00 00 00 80       	add    $0x80000000,%eax
  800570:	39 c1                	cmp    %eax,%ecx
  800572:	74 14                	je     800588 <_main+0x550>
  800574:	83 ec 04             	sub    $0x4,%esp
  800577:	68 b8 32 80 00       	push   $0x8032b8
  80057c:	6a 66                	push   $0x66
  80057e:	68 50 32 80 00       	push   $0x803250
  800583:	e8 55 0b 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800588:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80058b:	e8 cb 25 00 00       	call   802b5b <sys_calculate_free_frames>
  800590:	29 c3                	sub    %eax,%ebx
  800592:	89 d8                	mov    %ebx,%eax
  800594:	83 f8 01             	cmp    $0x1,%eax
  800597:	74 14                	je     8005ad <_main+0x575>
  800599:	83 ec 04             	sub    $0x4,%esp
  80059c:	68 e8 32 80 00       	push   $0x8032e8
  8005a1:	6a 68                	push   $0x68
  8005a3:	68 50 32 80 00       	push   $0x803250
  8005a8:	e8 30 0b 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8005ad:	e8 2c 26 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8005b2:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8005b5:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 54 33 80 00       	push   $0x803354
  8005c4:	6a 69                	push   $0x69
  8005c6:	68 50 32 80 00       	push   $0x803250
  8005cb:	e8 0d 0b 00 00       	call   8010dd <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d0:	e8 09 26 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8005d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 7e 25 00 00       	call   802b5b <sys_calculate_free_frames>
  8005dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		free(ptr_allocations[1]);
  8005e0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e6:	83 ec 0c             	sub    $0xc,%esp
  8005e9:	50                   	push   %eax
  8005ea:	e8 3e 23 00 00       	call   80292d <free>
  8005ef:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: table is not removed correctly");
  8005f2:	e8 64 25 00 00       	call   802b5b <sys_calculate_free_frames>
  8005f7:	89 c2                	mov    %eax,%edx
  8005f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005fc:	39 c2                	cmp    %eax,%edx
  8005fe:	74 14                	je     800614 <_main+0x5dc>
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 84 33 80 00       	push   $0x803384
  800608:	6a 72                	push   $0x72
  80060a:	68 50 32 80 00       	push   $0x803250
  80060f:	e8 c9 0a 00 00       	call   8010dd <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800614:	e8 c5 25 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800619:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80061c:	29 c2                	sub    %eax,%edx
  80061e:	89 d0                	mov    %edx,%eax
  800620:	3d 00 01 00 00       	cmp    $0x100,%eax
  800625:	74 14                	je     80063b <_main+0x603>
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	68 b0 33 80 00       	push   $0x8033b0
  80062f:	6a 73                	push   $0x73
  800631:	68 50 32 80 00       	push   $0x803250
  800636:	e8 a2 0a 00 00       	call   8010dd <_panic>

		usedDiskPages = sys_pf_calculate_allocated_pages();
  80063b:	e8 9e 25 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800640:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800643:	e8 13 25 00 00       	call   802b5b <sys_calculate_free_frames>
  800648:	89 45 cc             	mov    %eax,-0x34(%ebp)
		free(ptr_allocations[4]);
  80064b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	50                   	push   %eax
  800652:	e8 d6 22 00 00       	call   80292d <free>
  800657:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: table is not removed correctly");
  80065a:	e8 fc 24 00 00       	call   802b5b <sys_calculate_free_frames>
  80065f:	89 c2                	mov    %eax,%edx
  800661:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800664:	39 c2                	cmp    %eax,%edx
  800666:	74 14                	je     80067c <_main+0x644>
  800668:	83 ec 04             	sub    $0x4,%esp
  80066b:	68 84 33 80 00       	push   $0x803384
  800670:	6a 79                	push   $0x79
  800672:	68 50 32 80 00       	push   $0x803250
  800677:	e8 61 0a 00 00       	call   8010dd <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80067c:	e8 5d 25 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800681:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800684:	29 c2                	sub    %eax,%edx
  800686:	89 d0                	mov    %edx,%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 14                	je     8006a3 <_main+0x66b>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 b0 33 80 00       	push   $0x8033b0
  800697:	6a 7a                	push   $0x7a
  800699:	68 50 32 80 00       	push   $0x803250
  80069e:	e8 3a 0a 00 00       	call   8010dd <_panic>

		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006a3:	e8 36 25 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8006a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006ab:	e8 ab 24 00 00       	call   802b5b <sys_calculate_free_frames>
  8006b0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		free(ptr_allocations[6]);
  8006b3:	8b 45 88             	mov    -0x78(%ebp),%eax
  8006b6:	83 ec 0c             	sub    $0xc,%esp
  8006b9:	50                   	push   %eax
  8006ba:	e8 6e 22 00 00       	call   80292d <free>
  8006bf:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: table is not removed correctly");
  8006c2:	e8 94 24 00 00       	call   802b5b <sys_calculate_free_frames>
  8006c7:	89 c2                	mov    %eax,%edx
  8006c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006cc:	39 c2                	cmp    %eax,%edx
  8006ce:	74 17                	je     8006e7 <_main+0x6af>
  8006d0:	83 ec 04             	sub    $0x4,%esp
  8006d3:	68 84 33 80 00       	push   $0x803384
  8006d8:	68 80 00 00 00       	push   $0x80
  8006dd:	68 50 32 80 00       	push   $0x803250
  8006e2:	e8 f6 09 00 00       	call   8010dd <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e7:	e8 f2 24 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8006ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006ef:	29 c2                	sub    %eax,%edx
  8006f1:	89 d0                	mov    %edx,%eax
  8006f3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006f8:	74 17                	je     800711 <_main+0x6d9>
  8006fa:	83 ec 04             	sub    $0x4,%esp
  8006fd:	68 b0 33 80 00       	push   $0x8033b0
  800702:	68 81 00 00 00       	push   $0x81
  800707:	68 50 32 80 00       	push   $0x803250
  80070c:	e8 cc 09 00 00       	call   8010dd <_panic>
	}
	int cnt = 0;
  800711:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800718:	e8 3e 24 00 00       	call   802b5b <sys_calculate_free_frames>
  80071d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800720:	e8 b9 24 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800725:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800728:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80072b:	89 d0                	mov    %edx,%eax
  80072d:	c1 e0 09             	shl    $0x9,%eax
  800730:	29 d0                	sub    %edx,%eax
  800732:	83 ec 0c             	sub    $0xc,%esp
  800735:	50                   	push   %eax
  800736:	e8 50 18 00 00       	call   801f8b <malloc>
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800741:	8b 45 90             	mov    -0x70(%ebp),%eax
  800744:	89 c2                	mov    %eax,%edx
  800746:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800749:	05 00 00 00 80       	add    $0x80000000,%eax
  80074e:	39 c2                	cmp    %eax,%edx
  800750:	74 17                	je     800769 <_main+0x731>
  800752:	83 ec 04             	sub    $0x4,%esp
  800755:	68 b8 32 80 00       	push   $0x8032b8
  80075a:	68 8d 00 00 00       	push   $0x8d
  80075f:	68 50 32 80 00       	push   $0x803250
  800764:	e8 74 09 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800769:	e8 ed 23 00 00       	call   802b5b <sys_calculate_free_frames>
  80076e:	89 c2                	mov    %eax,%edx
  800770:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800773:	39 c2                	cmp    %eax,%edx
  800775:	74 17                	je     80078e <_main+0x756>
  800777:	83 ec 04             	sub    $0x4,%esp
  80077a:	68 e8 32 80 00       	push   $0x8032e8
  80077f:	68 8f 00 00 00       	push   $0x8f
  800784:	68 50 32 80 00       	push   $0x803250
  800789:	e8 4f 09 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  80078e:	e8 4b 24 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800793:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800796:	3d 80 00 00 00       	cmp    $0x80,%eax
  80079b:	74 17                	je     8007b4 <_main+0x77c>
  80079d:	83 ec 04             	sub    $0x4,%esp
  8007a0:	68 54 33 80 00       	push   $0x803354
  8007a5:	68 90 00 00 00       	push   $0x90
  8007aa:	68 50 32 80 00       	push   $0x803250
  8007af:	e8 29 09 00 00       	call   8010dd <_panic>

		//Fill it with data
		freeFrames = sys_calculate_free_frames() ;
  8007b4:	e8 a2 23 00 00       	call   802b5b <sys_calculate_free_frames>
  8007b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int *intArr = (int*) ptr_allocations[8];
  8007bc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8007bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;
  8007c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c5:	c1 e0 09             	shl    $0x9,%eax
  8007c8:	c1 e8 02             	shr    $0x2,%eax
  8007cb:	48                   	dec    %eax
  8007cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		int i = 0;
  8007cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (i=0; i <= lastIndexOfInt1 ; i++)
  8007d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007dd:	eb 17                	jmp    8007f6 <_main+0x7be>
		{
			intArr[i] = i ;
  8007df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007ec:	01 c2                	add    %eax,%edx
  8007ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007f1:	89 02                	mov    %eax,(%edx)
		freeFrames = sys_calculate_free_frames() ;
		int *intArr = (int*) ptr_allocations[8];
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i <= lastIndexOfInt1 ; i++)
  8007f3:	ff 45 e8             	incl   -0x18(%ebp)
  8007f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007f9:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8007fc:	7e e1                	jle    8007df <_main+0x7a7>
		{
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 128 + 1 ) panic("Wrong placement when accessing the allocated space");
  8007fe:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800801:	e8 55 23 00 00       	call   802b5b <sys_calculate_free_frames>
  800806:	29 c3                	sub    %eax,%ebx
  800808:	89 d8                	mov    %ebx,%eax
  80080a:	3d 81 00 00 00       	cmp    $0x81,%eax
  80080f:	74 17                	je     800828 <_main+0x7f0>
  800811:	83 ec 04             	sub    $0x4,%esp
  800814:	68 ec 33 80 00       	push   $0x8033ec
  800819:	68 9c 00 00 00       	push   $0x9c
  80081e:	68 50 32 80 00       	push   $0x803250
  800823:	e8 b5 08 00 00       	call   8010dd <_panic>

		//Reallocate it [expanded in the same place]
		freeFrames = sys_calculate_free_frames() ;
  800828:	e8 2e 23 00 00       	call   802b5b <sys_calculate_free_frames>
  80082d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800830:	e8 a9 23 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800835:	89 45 d0             	mov    %eax,-0x30(%ebp)

		ptr_allocations[8] = realloc(ptr_allocations[8], 512*kilo + 256*kilo - kilo);
  800838:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80083b:	89 d0                	mov    %edx,%eax
  80083d:	01 c0                	add    %eax,%eax
  80083f:	01 d0                	add    %edx,%eax
  800841:	c1 e0 08             	shl    $0x8,%eax
  800844:	29 d0                	sub    %edx,%eax
  800846:	89 c2                	mov    %eax,%edx
  800848:	8b 45 90             	mov    -0x70(%ebp),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	52                   	push   %edx
  80084f:	50                   	push   %eax
  800850:	e8 bb 21 00 00       	call   802a10 <realloc>
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	89 45 90             	mov    %eax,-0x70(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[8] !=(USER_HEAP_START + 1*Mega)) panic("Wrong start address for the re-allocated space... ");
  80085b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80085e:	89 c2                	mov    %eax,%edx
  800860:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800863:	05 00 00 00 80       	add    $0x80000000,%eax
  800868:	39 c2                	cmp    %eax,%edx
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 20 34 80 00       	push   $0x803420
  800874:	68 a5 00 00 00       	push   $0xa5
  800879:	68 50 32 80 00       	push   $0x803250
  80087e:	e8 5a 08 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong re-allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800883:	e8 d3 22 00 00       	call   802b5b <sys_calculate_free_frames>
  800888:	89 c2                	mov    %eax,%edx
  80088a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80088d:	39 c2                	cmp    %eax,%edx
  80088f:	74 17                	je     8008a8 <_main+0x870>
  800891:	83 ec 04             	sub    $0x4,%esp
  800894:	68 54 34 80 00       	push   $0x803454
  800899:	68 a7 00 00 00       	push   $0xa7
  80089e:	68 50 32 80 00       	push   $0x803250
  8008a3:	e8 35 08 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are allocated in PageFile");
  8008a8:	e8 31 23 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8008ad:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8008b0:	83 f8 40             	cmp    $0x40,%eax
  8008b3:	74 17                	je     8008cc <_main+0x894>
  8008b5:	83 ec 04             	sub    $0x4,%esp
  8008b8:	68 54 33 80 00       	push   $0x803354
  8008bd:	68 a8 00 00 00       	push   $0xa8
  8008c2:	68 50 32 80 00       	push   $0x803250
  8008c7:	e8 11 08 00 00       	call   8010dd <_panic>

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
  8008cc:	e8 8a 22 00 00       	call   802b5b <sys_calculate_free_frames>
  8008d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;
  8008d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008d7:	89 d0                	mov    %edx,%eax
  8008d9:	01 c0                	add    %eax,%eax
  8008db:	01 d0                	add    %edx,%eax
  8008dd:	c1 e0 08             	shl    $0x8,%eax
  8008e0:	c1 e8 02             	shr    $0x2,%eax
  8008e3:	48                   	dec    %eax
  8008e4:	89 45 c0             	mov    %eax,-0x40(%ebp)

		for (i=lastIndexOfInt1+1; i < lastIndexOfInt2 ; i++)
  8008e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8008ea:	40                   	inc    %eax
  8008eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8008ee:	eb 17                	jmp    800907 <_main+0x8cf>
		{
			intArr[i] = i ;
  8008f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008fd:	01 c2                	add    %eax,%edx
  8008ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800902:	89 02                	mov    %eax,(%edx)

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1+1; i < lastIndexOfInt2 ; i++)
  800904:	ff 45 e8             	incl   -0x18(%ebp)
  800907:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80090a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  80090d:	7c e1                	jl     8008f0 <_main+0x8b8>
		{
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong placement when accessing the allocated space");
  80090f:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800912:	e8 44 22 00 00       	call   802b5b <sys_calculate_free_frames>
  800917:	29 c3                	sub    %eax,%ebx
  800919:	89 d8                	mov    %ebx,%eax
  80091b:	83 f8 40             	cmp    $0x40,%eax
  80091e:	74 17                	je     800937 <_main+0x8ff>
  800920:	83 ec 04             	sub    $0x4,%esp
  800923:	68 ec 33 80 00       	push   $0x8033ec
  800928:	68 b2 00 00 00       	push   $0xb2
  80092d:	68 50 32 80 00       	push   $0x803250
  800932:	e8 a6 07 00 00       	call   8010dd <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800937:	e8 1f 22 00 00       	call   802b5b <sys_calculate_free_frames>
  80093c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i=0; i < lastIndexOfInt2 ; i++)
  80093f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800946:	eb 33                	jmp    80097b <_main+0x943>
		{
			cnt++;
  800948:	ff 45 ec             	incl   -0x14(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80094b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80095f:	74 17                	je     800978 <_main+0x940>
  800961:	83 ec 04             	sub    $0x4,%esp
  800964:	68 c4 34 80 00       	push   $0x8034c4
  800969:	68 b8 00 00 00       	push   $0xb8
  80096e:	68 50 32 80 00       	push   $0x803250
  800973:	e8 65 07 00 00       	call   8010dd <_panic>
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong placement when accessing the allocated space");

		freeFrames = sys_calculate_free_frames() ;
		for (i=0; i < lastIndexOfInt2 ; i++)
  800978:	ff 45 e8             	incl   -0x18(%ebp)
  80097b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80097e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800981:	7c c5                	jl     800948 <_main+0x910>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong placement when accessing the allocated space");
  800983:	e8 d3 21 00 00       	call   802b5b <sys_calculate_free_frames>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80098d:	39 c2                	cmp    %eax,%edx
  80098f:	74 17                	je     8009a8 <_main+0x970>
  800991:	83 ec 04             	sub    $0x4,%esp
  800994:	68 ec 33 80 00       	push   $0x8033ec
  800999:	68 ba 00 00 00       	push   $0xba
  80099e:	68 50 32 80 00       	push   $0x803250
  8009a3:	e8 35 07 00 00       	call   8010dd <_panic>

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8009a8:	e8 ae 21 00 00       	call   802b5b <sys_calculate_free_frames>
  8009ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009b0:	e8 29 22 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8009b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		free(ptr_allocations[8]);
  8009b8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8009bb:	83 ec 0c             	sub    $0xc,%esp
  8009be:	50                   	push   %eax
  8009bf:	e8 69 1f 00 00       	call   80292d <free>
  8009c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((sys_calculate_free_frames() - freeFrames) != 128+64+1) panic("Wrong re-allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8009c7:	e8 8f 21 00 00       	call   802b5b <sys_calculate_free_frames>
  8009cc:	89 c2                	mov    %eax,%edx
  8009ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009d1:	29 c2                	sub    %eax,%edx
  8009d3:	89 d0                	mov    %edx,%eax
  8009d5:	3d c1 00 00 00       	cmp    $0xc1,%eax
  8009da:	74 17                	je     8009f3 <_main+0x9bb>
  8009dc:	83 ec 04             	sub    $0x4,%esp
  8009df:	68 54 34 80 00       	push   $0x803454
  8009e4:	68 c1 00 00 00       	push   $0xc1
  8009e9:	68 50 32 80 00       	push   $0x803250
  8009ee:	e8 ea 06 00 00       	call   8010dd <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Extra or less pages are allocated in PageFile");
  8009f3:	e8 e6 21 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  8009f8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8009fb:	29 c2                	sub    %eax,%edx
  8009fd:	89 d0                	mov    %edx,%eax
  8009ff:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800a04:	74 17                	je     800a1d <_main+0x9e5>
  800a06:	83 ec 04             	sub    $0x4,%esp
  800a09:	68 54 33 80 00       	push   $0x803354
  800a0e:	68 c2 00 00 00       	push   $0xc2
  800a13:	68 50 32 80 00       	push   $0x803250
  800a18:	e8 c0 06 00 00       	call   8010dd <_panic>

		cprintf("\nCASE1: (Re-allocate that's fit in the same location) is succeeded...\n") ;
  800a1d:	83 ec 0c             	sub    $0xc,%esp
  800a20:	68 fc 34 80 00       	push   $0x8034fc
  800a25:	e8 de 07 00 00       	call   801208 <cprintf>
  800a2a:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800a2d:	e8 29 21 00 00       	call   802b5b <sys_calculate_free_frames>
  800a32:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a35:	e8 a4 21 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800a3a:	89 45 d0             	mov    %eax,-0x30(%ebp)

		ptr_allocations[8] = malloc(1*Mega + 512*kilo - kilo);
  800a3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a40:	c1 e0 09             	shl    $0x9,%eax
  800a43:	89 c2                	mov    %eax,%edx
  800a45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a48:	01 d0                	add    %edx,%eax
  800a4a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800a4d:	83 ec 0c             	sub    $0xc,%esp
  800a50:	50                   	push   %eax
  800a51:	e8 35 15 00 00       	call   801f8b <malloc>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	89 45 90             	mov    %eax,-0x70(%ebp)

		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800a5c:	8b 45 90             	mov    -0x70(%ebp),%eax
  800a5f:	89 c2                	mov    %eax,%edx
  800a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a64:	c1 e0 02             	shl    $0x2,%eax
  800a67:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6c:	39 c2                	cmp    %eax,%edx
  800a6e:	74 17                	je     800a87 <_main+0xa4f>
  800a70:	83 ec 04             	sub    $0x4,%esp
  800a73:	68 b8 32 80 00       	push   $0x8032b8
  800a78:	68 ce 00 00 00       	push   $0xce
  800a7d:	68 50 32 80 00       	push   $0x803250
  800a82:	e8 56 06 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong re-allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800a87:	e8 cf 20 00 00       	call   802b5b <sys_calculate_free_frames>
  800a8c:	89 c2                	mov    %eax,%edx
  800a8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a91:	39 c2                	cmp    %eax,%edx
  800a93:	74 17                	je     800aac <_main+0xa74>
  800a95:	83 ec 04             	sub    $0x4,%esp
  800a98:	68 54 34 80 00       	push   $0x803454
  800a9d:	68 d0 00 00 00       	push   $0xd0
  800aa2:	68 50 32 80 00       	push   $0x803250
  800aa7:	e8 31 06 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800aac:	e8 2d 21 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800ab1:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800ab4:	3d 80 01 00 00       	cmp    $0x180,%eax
  800ab9:	74 17                	je     800ad2 <_main+0xa9a>
  800abb:	83 ec 04             	sub    $0x4,%esp
  800abe:	68 54 33 80 00       	push   $0x803354
  800ac3:	68 d1 00 00 00       	push   $0xd1
  800ac8:	68 50 32 80 00       	push   $0x803250
  800acd:	e8 0b 06 00 00       	call   8010dd <_panic>

		//Fill it with data
		freeFrames = sys_calculate_free_frames() ;
  800ad2:	e8 84 20 00 00       	call   802b5b <sys_calculate_free_frames>
  800ad7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[8];
  800ada:	8b 45 90             	mov    -0x70(%ebp),%eax
  800add:	89 45 c8             	mov    %eax,-0x38(%ebp)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
  800ae0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ae3:	c1 e0 09             	shl    $0x9,%eax
  800ae6:	89 c2                	mov    %eax,%edx
  800ae8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800aeb:	01 d0                	add    %edx,%eax
  800aed:	c1 e8 02             	shr    $0x2,%eax
  800af0:	48                   	dec    %eax
  800af1:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		i = 0;
  800af4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800afb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b02:	eb 17                	jmp    800b1b <_main+0xae3>
		{
			intArr[i] = i ;
  800b04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b07:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b0e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b11:	01 c2                	add    %eax,%edx
  800b13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b16:	89 02                	mov    %eax,(%edx)
		freeFrames = sys_calculate_free_frames() ;
		intArr = (int*) ptr_allocations[8];
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;

		i = 0;
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800b18:	ff 45 e8             	incl   -0x18(%ebp)
  800b1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b1e:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b21:	7e e1                	jle    800b04 <_main+0xacc>
		{
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 384 + 1) panic("Wrong placement when accessing the allocated space");
  800b23:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800b26:	e8 30 20 00 00       	call   802b5b <sys_calculate_free_frames>
  800b2b:	29 c3                	sub    %eax,%ebx
  800b2d:	89 d8                	mov    %ebx,%eax
  800b2f:	3d 81 01 00 00       	cmp    $0x181,%eax
  800b34:	74 17                	je     800b4d <_main+0xb15>
  800b36:	83 ec 04             	sub    $0x4,%esp
  800b39:	68 ec 33 80 00       	push   $0x8033ec
  800b3e:	68 dd 00 00 00       	push   $0xdd
  800b43:	68 50 32 80 00       	push   $0x803250
  800b48:	e8 90 05 00 00       	call   8010dd <_panic>

		//Reallocate it to 2.5 MB [should be moved to next hole]
		freeFrames = sys_calculate_free_frames() ;
  800b4d:	e8 09 20 00 00       	call   802b5b <sys_calculate_free_frames>
  800b52:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b55:	e8 84 20 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800b5a:	89 45 d0             	mov    %eax,-0x30(%ebp)

		ptr_allocations[8] = realloc(ptr_allocations[8], 1*Mega + 512*kilo + 1*Mega - kilo);
  800b5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b60:	c1 e0 09             	shl    $0x9,%eax
  800b63:	89 c2                	mov    %eax,%edx
  800b65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b68:	01 c2                	add    %eax,%edx
  800b6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b6d:	01 d0                	add    %edx,%eax
  800b6f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800b72:	89 c2                	mov    %eax,%edx
  800b74:	8b 45 90             	mov    -0x70(%ebp),%eax
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	52                   	push   %edx
  800b7b:	50                   	push   %eax
  800b7c:	e8 8f 1e 00 00       	call   802a10 <realloc>
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	89 45 90             	mov    %eax,-0x70(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[8] !=(USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800b87:	8b 45 90             	mov    -0x70(%ebp),%eax
  800b8a:	89 c2                	mov    %eax,%edx
  800b8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b8f:	c1 e0 03             	shl    $0x3,%eax
  800b92:	05 00 00 00 80       	add    $0x80000000,%eax
  800b97:	39 c2                	cmp    %eax,%edx
  800b99:	74 17                	je     800bb2 <_main+0xb7a>
  800b9b:	83 ec 04             	sub    $0x4,%esp
  800b9e:	68 20 34 80 00       	push   $0x803420
  800ba3:	68 e6 00 00 00       	push   $0xe6
  800ba8:	68 50 32 80 00       	push   $0x803250
  800bad:	e8 2b 05 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");
		if ((sys_calculate_free_frames() - freeFrames) != 384 + 1 ) panic("Wrong re-allocation: either extra pages are allocated in memory or pages not removed correctly when moving the reallocated block");
  800bb2:	e8 a4 1f 00 00       	call   802b5b <sys_calculate_free_frames>
  800bb7:	89 c2                	mov    %eax,%edx
  800bb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800bbc:	29 c2                	sub    %eax,%edx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	3d 81 01 00 00       	cmp    $0x181,%eax
  800bc5:	74 17                	je     800bde <_main+0xba6>
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	68 44 35 80 00       	push   $0x803544
  800bcf:	68 e8 00 00 00       	push   $0xe8
  800bd4:	68 50 32 80 00       	push   $0x803250
  800bd9:	e8 ff 04 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800bde:	e8 fb 1f 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800be3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800be6:	3d 00 01 00 00       	cmp    $0x100,%eax
  800beb:	74 17                	je     800c04 <_main+0xbcc>
  800bed:	83 ec 04             	sub    $0x4,%esp
  800bf0:	68 54 33 80 00       	push   $0x803354
  800bf5:	68 e9 00 00 00       	push   $0xe9
  800bfa:	68 50 32 80 00       	push   $0x803250
  800bff:	e8 d9 04 00 00       	call   8010dd <_panic>

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
  800c04:	e8 52 1f 00 00       	call   802b5b <sys_calculate_free_frames>
  800c09:	89 45 cc             	mov    %eax,-0x34(%ebp)
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
  800c0c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c0f:	c1 e0 08             	shl    $0x8,%eax
  800c12:	89 c2                	mov    %eax,%edx
  800c14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c17:	01 d0                	add    %edx,%eax
  800c19:	01 c0                	add    %eax,%eax
  800c1b:	c1 e8 02             	shr    $0x2,%eax
  800c1e:	48                   	dec    %eax
  800c1f:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int*) ptr_allocations[8];
  800c22:	8b 45 90             	mov    -0x70(%ebp),%eax
  800c25:	89 45 c8             	mov    %eax,-0x38(%ebp)

		for (i=lastIndexOfInt1+1; i < lastIndexOfInt2 ; i++)
  800c28:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c2b:	40                   	inc    %eax
  800c2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800c2f:	eb 17                	jmp    800c48 <_main+0xc10>
		{
			intArr[i] = i ;
  800c31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c3b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c3e:	01 c2                	add    %eax,%edx
  800c40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c43:	89 02                	mov    %eax,(%edx)
		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[8];

		for (i=lastIndexOfInt1+1; i < lastIndexOfInt2 ; i++)
  800c45:	ff 45 e8             	incl   -0x18(%ebp)
  800c48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c4b:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800c4e:	7c e1                	jl     800c31 <_main+0xbf9>
		{
			intArr[i] = i ;
		}

		if ((freeFrames - sys_calculate_free_frames()) != 256 + 1) panic("Wrong placement when accessing the allocated space");
  800c50:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c53:	e8 03 1f 00 00       	call   802b5b <sys_calculate_free_frames>
  800c58:	29 c3                	sub    %eax,%ebx
  800c5a:	89 d8                	mov    %ebx,%eax
  800c5c:	3d 01 01 00 00       	cmp    $0x101,%eax
  800c61:	74 17                	je     800c7a <_main+0xc42>
  800c63:	83 ec 04             	sub    $0x4,%esp
  800c66:	68 ec 33 80 00       	push   $0x8033ec
  800c6b:	68 f5 00 00 00       	push   $0xf5
  800c70:	68 50 32 80 00       	push   $0x803250
  800c75:	e8 63 04 00 00       	call   8010dd <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c7a:	e8 dc 1e 00 00       	call   802b5b <sys_calculate_free_frames>
  800c7f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i=0; i < lastIndexOfInt2 ; i++)
  800c82:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800c89:	eb 33                	jmp    800cbe <_main+0xc86>
		{
			cnt++;
  800c8b:	ff 45 ec             	incl   -0x14(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c98:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c9b:	01 d0                	add    %edx,%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800ca2:	74 17                	je     800cbb <_main+0xc83>
  800ca4:	83 ec 04             	sub    $0x4,%esp
  800ca7:	68 c4 34 80 00       	push   $0x8034c4
  800cac:	68 fb 00 00 00       	push   $0xfb
  800cb1:	68 50 32 80 00       	push   $0x803250
  800cb6:	e8 22 04 00 00       	call   8010dd <_panic>
		}

		if ((freeFrames - sys_calculate_free_frames()) != 256 + 1) panic("Wrong placement when accessing the allocated space");

		freeFrames = sys_calculate_free_frames() ;
		for (i=0; i < lastIndexOfInt2 ; i++)
  800cbb:	ff 45 e8             	incl   -0x18(%ebp)
  800cbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800cc1:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800cc4:	7c c5                	jl     800c8b <_main+0xc53>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong placement when accessing the allocated space");
  800cc6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800cc9:	e8 8d 1e 00 00       	call   802b5b <sys_calculate_free_frames>
  800cce:	29 c3                	sub    %eax,%ebx
  800cd0:	89 d8                	mov    %ebx,%eax
  800cd2:	3d 80 01 00 00       	cmp    $0x180,%eax
  800cd7:	74 17                	je     800cf0 <_main+0xcb8>
  800cd9:	83 ec 04             	sub    $0x4,%esp
  800cdc:	68 ec 33 80 00       	push   $0x8033ec
  800ce1:	68 fd 00 00 00       	push   $0xfd
  800ce6:	68 50 32 80 00       	push   $0x803250
  800ceb:	e8 ed 03 00 00       	call   8010dd <_panic>

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800cf0:	e8 66 1e 00 00       	call   802b5b <sys_calculate_free_frames>
  800cf5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cf8:	e8 e1 1e 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800cfd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		free(ptr_allocations[8]);
  800d00:	8b 45 90             	mov    -0x70(%ebp),%eax
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	e8 21 1c 00 00       	call   80292d <free>
  800d0c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((sys_calculate_free_frames()-freeFrames) != 256+384+1 ) panic("Wrong free after reallocation");
  800d0f:	e8 47 1e 00 00       	call   802b5b <sys_calculate_free_frames>
  800d14:	89 c2                	mov    %eax,%edx
  800d16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800d19:	29 c2                	sub    %eax,%edx
  800d1b:	89 d0                	mov    %edx,%eax
  800d1d:	3d 81 02 00 00       	cmp    $0x281,%eax
  800d22:	74 17                	je     800d3b <_main+0xd03>
  800d24:	83 ec 04             	sub    $0x4,%esp
  800d27:	68 c5 35 80 00       	push   $0x8035c5
  800d2c:	68 04 01 00 00       	push   $0x104
  800d31:	68 50 32 80 00       	push   $0x803250
  800d36:	e8 a2 03 00 00       	call   8010dd <_panic>
		if ((usedDiskPages- sys_pf_calculate_allocated_pages()) != 256+384) panic("Extra or less pages are removed from PageFile");
  800d3b:	e8 9e 1e 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800d40:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800d43:	29 c2                	sub    %eax,%edx
  800d45:	89 d0                	mov    %edx,%eax
  800d47:	3d 80 02 00 00       	cmp    $0x280,%eax
  800d4c:	74 17                	je     800d65 <_main+0xd2d>
  800d4e:	83 ec 04             	sub    $0x4,%esp
  800d51:	68 e4 35 80 00       	push   $0x8035e4
  800d56:	68 05 01 00 00       	push   $0x105
  800d5b:	68 50 32 80 00       	push   $0x803250
  800d60:	e8 78 03 00 00       	call   8010dd <_panic>

		cprintf("\nCASE2: (Re-allocate that's not fit in the same location) is succeeded...\n") ;
  800d65:	83 ec 0c             	sub    $0xc,%esp
  800d68:	68 14 36 80 00       	push   $0x803614
  800d6d:	e8 96 04 00 00       	call   801208 <cprintf>
  800d72:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate that's not fit in the same location*/

		//Fill it with data
		freeFrames = sys_calculate_free_frames() ;
  800d75:	e8 e1 1d 00 00       	call   802b5b <sys_calculate_free_frames>
  800d7a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[0];
  800d7d:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800d83:	89 45 c8             	mov    %eax,-0x38(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800d86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d89:	c1 e8 02             	shr    $0x2,%eax
  800d8c:	48                   	dec    %eax
  800d8d:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		i = 0;
  800d90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800d97:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d9e:	eb 17                	jmp    800db7 <_main+0xd7f>
		{
			intArr[i] = i ;
  800da0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800da3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800daa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800dad:	01 c2                	add    %eax,%edx
  800daf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800db2:	89 02                	mov    %eax,(%edx)
		freeFrames = sys_calculate_free_frames() ;
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800db4:	ff 45 e8             	incl   -0x18(%ebp)
  800db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dba:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800dbd:	7e e1                	jle    800da0 <_main+0xd68>
		{
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 256 + 1) panic("Wrong placement when accessing the allocated space");
  800dbf:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800dc2:	e8 94 1d 00 00       	call   802b5b <sys_calculate_free_frames>
  800dc7:	29 c3                	sub    %eax,%ebx
  800dc9:	89 d8                	mov    %ebx,%eax
  800dcb:	3d 01 01 00 00       	cmp    $0x101,%eax
  800dd0:	74 17                	je     800de9 <_main+0xdb1>
  800dd2:	83 ec 04             	sub    $0x4,%esp
  800dd5:	68 ec 33 80 00       	push   $0x8033ec
  800dda:	68 15 01 00 00       	push   $0x115
  800ddf:	68 50 32 80 00       	push   $0x803250
  800de4:	e8 f4 02 00 00       	call   8010dd <_panic>

		//Reallocate it to 4 MB [should be moved to last hole]
		freeFrames = sys_calculate_free_frames() ;
  800de9:	e8 6d 1d 00 00       	call   802b5b <sys_calculate_free_frames>
  800dee:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800df1:	e8 e8 1d 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800df6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 1*Mega + 3*Mega - kilo);
  800df9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dfc:	c1 e0 02             	shl    $0x2,%eax
  800dff:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800e02:	89 c2                	mov    %eax,%edx
  800e04:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	52                   	push   %edx
  800e0e:	50                   	push   %eax
  800e0f:	e8 fc 1b 00 00       	call   802a10 <realloc>
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] !=(USER_HEAP_START + 14*Mega)) panic("Wrong start address for the re-allocated space... ");
  800e1d:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800e23:	89 c1                	mov    %eax,%ecx
  800e25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e28:	89 d0                	mov    %edx,%eax
  800e2a:	01 c0                	add    %eax,%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	01 c0                	add    %eax,%eax
  800e30:	01 d0                	add    %edx,%eax
  800e32:	01 c0                	add    %eax,%eax
  800e34:	05 00 00 00 80       	add    $0x80000000,%eax
  800e39:	39 c1                	cmp    %eax,%ecx
  800e3b:	74 17                	je     800e54 <_main+0xe1c>
  800e3d:	83 ec 04             	sub    $0x4,%esp
  800e40:	68 20 34 80 00       	push   $0x803420
  800e45:	68 1d 01 00 00       	push   $0x11d
  800e4a:	68 50 32 80 00       	push   $0x803250
  800e4f:	e8 89 02 00 00       	call   8010dd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		if ((sys_calculate_free_frames() - freeFrames) != 256 + 1 - 1) panic("Wrong re-allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800e54:	e8 02 1d 00 00       	call   802b5b <sys_calculate_free_frames>
  800e59:	89 c2                	mov    %eax,%edx
  800e5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e5e:	29 c2                	sub    %eax,%edx
  800e60:	89 d0                	mov    %edx,%eax
  800e62:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e67:	74 17                	je     800e80 <_main+0xe48>
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	68 54 34 80 00       	push   $0x803454
  800e71:	68 1f 01 00 00       	push   $0x11f
  800e76:	68 50 32 80 00       	push   $0x803250
  800e7b:	e8 5d 02 00 00       	call   8010dd <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800e80:	e8 59 1d 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800e85:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800e88:	3d 00 03 00 00       	cmp    $0x300,%eax
  800e8d:	74 17                	je     800ea6 <_main+0xe6e>
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 54 33 80 00       	push   $0x803354
  800e97:	68 20 01 00 00       	push   $0x120
  800e9c:	68 50 32 80 00       	push   $0x803250
  800ea1:	e8 37 02 00 00       	call   8010dd <_panic>

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
  800ea6:	e8 b0 1c 00 00       	call   802b5b <sys_calculate_free_frames>
  800eab:	89 45 cc             	mov    %eax,-0x34(%ebp)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  800eae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800eb1:	c1 e0 02             	shl    $0x2,%eax
  800eb4:	c1 e8 02             	shr    $0x2,%eax
  800eb7:	48                   	dec    %eax
  800eb8:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int*) ptr_allocations[0];
  800ebb:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800ec1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for (i=lastIndexOfInt1+1; i < lastIndexOfInt2 ; i++)
  800ec4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800ec7:	40                   	inc    %eax
  800ec8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800ecb:	eb 17                	jmp    800ee4 <_main+0xeac>
		{
			intArr[i] = i ;
  800ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ed0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ed7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800eda:	01 c2                	add    %eax,%edx
  800edc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800edf:	89 02                	mov    %eax,(%edx)

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[0];
		for (i=lastIndexOfInt1+1; i < lastIndexOfInt2 ; i++)
  800ee1:	ff 45 e8             	incl   -0x18(%ebp)
  800ee4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ee7:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800eea:	7c e1                	jl     800ecd <_main+0xe95>
		{
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 768 + 2) panic("Wrong placement when accessing the allocated space");
  800eec:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800eef:	e8 67 1c 00 00       	call   802b5b <sys_calculate_free_frames>
  800ef4:	29 c3                	sub    %eax,%ebx
  800ef6:	89 d8                	mov    %ebx,%eax
  800ef8:	3d 02 03 00 00       	cmp    $0x302,%eax
  800efd:	74 17                	je     800f16 <_main+0xede>
  800eff:	83 ec 04             	sub    $0x4,%esp
  800f02:	68 ec 33 80 00       	push   $0x8033ec
  800f07:	68 2a 01 00 00       	push   $0x12a
  800f0c:	68 50 32 80 00       	push   $0x803250
  800f11:	e8 c7 01 00 00       	call   8010dd <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800f16:	e8 40 1c 00 00       	call   802b5b <sys_calculate_free_frames>
  800f1b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i=0; i < lastIndexOfInt2 ; i++)
  800f1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f25:	eb 33                	jmp    800f5a <_main+0xf22>
		{
			cnt++;
  800f27:	ff 45 ec             	incl   -0x14(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800f2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f34:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800f37:	01 d0                	add    %edx,%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800f3e:	74 17                	je     800f57 <_main+0xf1f>
  800f40:	83 ec 04             	sub    $0x4,%esp
  800f43:	68 c4 34 80 00       	push   $0x8034c4
  800f48:	68 30 01 00 00       	push   $0x130
  800f4d:	68 50 32 80 00       	push   $0x803250
  800f52:	e8 86 01 00 00       	call   8010dd <_panic>
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 768 + 2) panic("Wrong placement when accessing the allocated space");

		freeFrames = sys_calculate_free_frames() ;
		for (i=0; i < lastIndexOfInt2 ; i++)
  800f57:	ff 45 e8             	incl   -0x18(%ebp)
  800f5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f5d:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800f60:	7c c5                	jl     800f27 <_main+0xeef>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong placement when accessing the allocated space");
  800f62:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800f65:	e8 f1 1b 00 00       	call   802b5b <sys_calculate_free_frames>
  800f6a:	29 c3                	sub    %eax,%ebx
  800f6c:	89 d8                	mov    %ebx,%eax
  800f6e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800f73:	74 17                	je     800f8c <_main+0xf54>
  800f75:	83 ec 04             	sub    $0x4,%esp
  800f78:	68 ec 33 80 00       	push   $0x8033ec
  800f7d:	68 32 01 00 00       	push   $0x132
  800f82:	68 50 32 80 00       	push   $0x803250
  800f87:	e8 51 01 00 00       	call   8010dd <_panic>

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800f8c:	e8 ca 1b 00 00       	call   802b5b <sys_calculate_free_frames>
  800f91:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800f94:	e8 45 1c 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800f99:	89 45 d0             	mov    %eax,-0x30(%ebp)
		free(ptr_allocations[0]);
  800f9c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800fa2:	83 ec 0c             	sub    $0xc,%esp
  800fa5:	50                   	push   %eax
  800fa6:	e8 82 19 00 00       	call   80292d <free>
  800fab:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((sys_calculate_free_frames() - freeFrames) != 1024+2) panic("Wrong re-allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800fae:	e8 a8 1b 00 00       	call   802b5b <sys_calculate_free_frames>
  800fb3:	89 c2                	mov    %eax,%edx
  800fb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800fb8:	29 c2                	sub    %eax,%edx
  800fba:	89 d0                	mov    %edx,%eax
  800fbc:	3d 02 04 00 00       	cmp    $0x402,%eax
  800fc1:	74 17                	je     800fda <_main+0xfa2>
  800fc3:	83 ec 04             	sub    $0x4,%esp
  800fc6:	68 54 34 80 00       	push   $0x803454
  800fcb:	68 39 01 00 00       	push   $0x139
  800fd0:	68 50 32 80 00       	push   $0x803250
  800fd5:	e8 03 01 00 00       	call   8010dd <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Extra or less pages are allocated in PageFile");
  800fda:	e8 ff 1b 00 00       	call   802bde <sys_pf_calculate_allocated_pages>
  800fdf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800fe2:	29 c2                	sub    %eax,%edx
  800fe4:	89 d0                	mov    %edx,%eax
  800fe6:	3d 00 04 00 00       	cmp    $0x400,%eax
  800feb:	74 17                	je     801004 <_main+0xfcc>
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	68 54 33 80 00       	push   $0x803354
  800ff5:	68 3a 01 00 00       	push   $0x13a
  800ffa:	68 50 32 80 00       	push   $0x803250
  800fff:	e8 d9 00 00 00       	call   8010dd <_panic>

		("\nCASE3: (Re-allocate that's not fit in the same location) is succeeded...\n") ;
	}

	cprintf("Congratulations!! test realloc [1] is completed successfully.\n");
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	68 60 36 80 00       	push   $0x803660
  80100c:	e8 f7 01 00 00       	call   801208 <cprintf>
  801011:	83 c4 10             	add    $0x10,%esp

	return;
  801014:	90                   	nop
}
  801015:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801018:	5b                   	pop    %ebx
  801019:	5f                   	pop    %edi
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801022:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801026:	7e 0a                	jle    801032 <libmain+0x16>
		binaryname = argv[0];
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	8b 00                	mov    (%eax),%eax
  80102d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  801032:	83 ec 08             	sub    $0x8,%esp
  801035:	ff 75 0c             	pushl  0xc(%ebp)
  801038:	ff 75 08             	pushl  0x8(%ebp)
  80103b:	e8 f8 ef ff ff       	call   800038 <_main>
  801040:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  801043:	e8 61 1a 00 00       	call   802aa9 <sys_getenvid>
  801048:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80104b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104e:	89 d0                	mov    %edx,%eax
  801050:	c1 e0 03             	shl    $0x3,%eax
  801053:	01 d0                	add    %edx,%eax
  801055:	01 c0                	add    %eax,%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80106a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  80106d:	e8 85 1b 00 00       	call   802bf7 <sys_disable_interrupt>
		cprintf("**************************************\n");
  801072:	83 ec 0c             	sub    $0xc,%esp
  801075:	68 b8 36 80 00       	push   $0x8036b8
  80107a:	e8 89 01 00 00       	call   801208 <cprintf>
  80107f:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  801082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801085:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  80108b:	83 ec 08             	sub    $0x8,%esp
  80108e:	50                   	push   %eax
  80108f:	68 e0 36 80 00       	push   $0x8036e0
  801094:	e8 6f 01 00 00       	call   801208 <cprintf>
  801099:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80109c:	83 ec 0c             	sub    $0xc,%esp
  80109f:	68 b8 36 80 00       	push   $0x8036b8
  8010a4:	e8 5f 01 00 00       	call   801208 <cprintf>
  8010a9:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8010ac:	e8 60 1b 00 00       	call   802c11 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8010b1:	e8 19 00 00 00       	call   8010cf <exit>
}
  8010b6:	90                   	nop
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8010bf:	83 ec 0c             	sub    $0xc,%esp
  8010c2:	6a 00                	push   $0x0
  8010c4:	e8 c5 19 00 00       	call   802a8e <sys_env_destroy>
  8010c9:	83 c4 10             	add    $0x10,%esp
}
  8010cc:	90                   	nop
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <exit>:

void
exit(void)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8010d5:	e8 e8 19 00 00       	call   802ac2 <sys_env_exit>
}
  8010da:	90                   	nop
  8010db:	c9                   	leave  
  8010dc:	c3                   	ret    

008010dd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010e3:	8d 45 10             	lea    0x10(%ebp),%eax
  8010e6:	83 c0 04             	add    $0x4,%eax
  8010e9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8010ec:	a1 50 40 98 00       	mov    0x984050,%eax
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	74 16                	je     80110b <_panic+0x2e>
		cprintf("%s: ", argv0);
  8010f5:	a1 50 40 98 00       	mov    0x984050,%eax
  8010fa:	83 ec 08             	sub    $0x8,%esp
  8010fd:	50                   	push   %eax
  8010fe:	68 f9 36 80 00       	push   $0x8036f9
  801103:	e8 00 01 00 00       	call   801208 <cprintf>
  801108:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80110b:	a1 00 40 80 00       	mov    0x804000,%eax
  801110:	ff 75 0c             	pushl  0xc(%ebp)
  801113:	ff 75 08             	pushl  0x8(%ebp)
  801116:	50                   	push   %eax
  801117:	68 fe 36 80 00       	push   $0x8036fe
  80111c:	e8 e7 00 00 00       	call   801208 <cprintf>
  801121:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	ff 75 f4             	pushl  -0xc(%ebp)
  80112d:	50                   	push   %eax
  80112e:	e8 7a 00 00 00       	call   8011ad <vcprintf>
  801133:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	68 1a 37 80 00       	push   $0x80371a
  80113e:	e8 c5 00 00 00       	call   801208 <cprintf>
  801143:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801146:	e8 84 ff ff ff       	call   8010cf <exit>

	// should not return here
	while (1) ;
  80114b:	eb fe                	jmp    80114b <_panic+0x6e>

0080114d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801153:	8b 45 0c             	mov    0xc(%ebp),%eax
  801156:	8b 00                	mov    (%eax),%eax
  801158:	8d 48 01             	lea    0x1(%eax),%ecx
  80115b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115e:	89 0a                	mov    %ecx,(%edx)
  801160:	8b 55 08             	mov    0x8(%ebp),%edx
  801163:	88 d1                	mov    %dl,%cl
  801165:	8b 55 0c             	mov    0xc(%ebp),%edx
  801168:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	8b 00                	mov    (%eax),%eax
  801171:	3d ff 00 00 00       	cmp    $0xff,%eax
  801176:	75 23                	jne    80119b <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  801178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117b:	8b 00                	mov    (%eax),%eax
  80117d:	89 c2                	mov    %eax,%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	83 c0 08             	add    $0x8,%eax
  801185:	83 ec 08             	sub    $0x8,%esp
  801188:	52                   	push   %edx
  801189:	50                   	push   %eax
  80118a:	e8 c9 18 00 00       	call   802a58 <sys_cputs>
  80118f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8b 40 04             	mov    0x4(%eax),%eax
  8011a1:	8d 50 01             	lea    0x1(%eax),%edx
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011aa:	90                   	nop
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011b6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011bd:	00 00 00 
	b.cnt = 0;
  8011c0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011c7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	ff 75 08             	pushl  0x8(%ebp)
  8011d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011d6:	50                   	push   %eax
  8011d7:	68 4d 11 80 00       	push   $0x80114d
  8011dc:	e8 fa 01 00 00       	call   8013db <vprintfmt>
  8011e1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8011e4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	50                   	push   %eax
  8011ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011f4:	83 c0 08             	add    $0x8,%eax
  8011f7:	50                   	push   %eax
  8011f8:	e8 5b 18 00 00       	call   802a58 <sys_cputs>
  8011fd:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  801200:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <cprintf>:

int cprintf(const char *fmt, ...) {
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80120e:	8d 45 0c             	lea    0xc(%ebp),%eax
  801211:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	ff 75 f4             	pushl  -0xc(%ebp)
  80121d:	50                   	push   %eax
  80121e:	e8 8a ff ff ff       	call   8011ad <vcprintf>
  801223:	83 c4 10             	add    $0x10,%esp
  801226:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801229:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801234:	e8 be 19 00 00       	call   802bf7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801239:	8d 45 0c             	lea    0xc(%ebp),%eax
  80123c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	83 ec 08             	sub    $0x8,%esp
  801245:	ff 75 f4             	pushl  -0xc(%ebp)
  801248:	50                   	push   %eax
  801249:	e8 5f ff ff ff       	call   8011ad <vcprintf>
  80124e:	83 c4 10             	add    $0x10,%esp
  801251:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801254:	e8 b8 19 00 00       	call   802c11 <sys_enable_interrupt>
	return cnt;
  801259:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    

0080125e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	53                   	push   %ebx
  801262:	83 ec 14             	sub    $0x14,%esp
  801265:	8b 45 10             	mov    0x10(%ebp),%eax
  801268:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801271:	8b 45 18             	mov    0x18(%ebp),%eax
  801274:	ba 00 00 00 00       	mov    $0x0,%edx
  801279:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80127c:	77 55                	ja     8012d3 <printnum+0x75>
  80127e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801281:	72 05                	jb     801288 <printnum+0x2a>
  801283:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801286:	77 4b                	ja     8012d3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801288:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80128b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80128e:	8b 45 18             	mov    0x18(%ebp),%eax
  801291:	ba 00 00 00 00       	mov    $0x0,%edx
  801296:	52                   	push   %edx
  801297:	50                   	push   %eax
  801298:	ff 75 f4             	pushl  -0xc(%ebp)
  80129b:	ff 75 f0             	pushl  -0x10(%ebp)
  80129e:	e8 f1 1c 00 00       	call   802f94 <__udivdi3>
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	83 ec 04             	sub    $0x4,%esp
  8012a9:	ff 75 20             	pushl  0x20(%ebp)
  8012ac:	53                   	push   %ebx
  8012ad:	ff 75 18             	pushl  0x18(%ebp)
  8012b0:	52                   	push   %edx
  8012b1:	50                   	push   %eax
  8012b2:	ff 75 0c             	pushl  0xc(%ebp)
  8012b5:	ff 75 08             	pushl  0x8(%ebp)
  8012b8:	e8 a1 ff ff ff       	call   80125e <printnum>
  8012bd:	83 c4 20             	add    $0x20,%esp
  8012c0:	eb 1a                	jmp    8012dc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012c2:	83 ec 08             	sub    $0x8,%esp
  8012c5:	ff 75 0c             	pushl  0xc(%ebp)
  8012c8:	ff 75 20             	pushl  0x20(%ebp)
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	ff d0                	call   *%eax
  8012d0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012d3:	ff 4d 1c             	decl   0x1c(%ebp)
  8012d6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012da:	7f e6                	jg     8012c2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012dc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ea:	53                   	push   %ebx
  8012eb:	51                   	push   %ecx
  8012ec:	52                   	push   %edx
  8012ed:	50                   	push   %eax
  8012ee:	e8 b1 1d 00 00       	call   8030a4 <__umoddi3>
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	05 34 39 80 00       	add    $0x803934,%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	0f be c0             	movsbl %al,%eax
  801300:	83 ec 08             	sub    $0x8,%esp
  801303:	ff 75 0c             	pushl  0xc(%ebp)
  801306:	50                   	push   %eax
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	ff d0                	call   *%eax
  80130c:	83 c4 10             	add    $0x10,%esp
}
  80130f:	90                   	nop
  801310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801318:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80131c:	7e 1c                	jle    80133a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8b 00                	mov    (%eax),%eax
  801323:	8d 50 08             	lea    0x8(%eax),%edx
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 10                	mov    %edx,(%eax)
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8b 00                	mov    (%eax),%eax
  801330:	83 e8 08             	sub    $0x8,%eax
  801333:	8b 50 04             	mov    0x4(%eax),%edx
  801336:	8b 00                	mov    (%eax),%eax
  801338:	eb 40                	jmp    80137a <getuint+0x65>
	else if (lflag)
  80133a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80133e:	74 1e                	je     80135e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	8d 50 04             	lea    0x4(%eax),%edx
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	89 10                	mov    %edx,(%eax)
  80134d:	8b 45 08             	mov    0x8(%ebp),%eax
  801350:	8b 00                	mov    (%eax),%eax
  801352:	83 e8 04             	sub    $0x4,%eax
  801355:	8b 00                	mov    (%eax),%eax
  801357:	ba 00 00 00 00       	mov    $0x0,%edx
  80135c:	eb 1c                	jmp    80137a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8b 00                	mov    (%eax),%eax
  801363:	8d 50 04             	lea    0x4(%eax),%edx
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	89 10                	mov    %edx,(%eax)
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8b 00                	mov    (%eax),%eax
  801370:	83 e8 04             	sub    $0x4,%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80137f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801383:	7e 1c                	jle    8013a1 <getint+0x25>
		return va_arg(*ap, long long);
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8b 00                	mov    (%eax),%eax
  80138a:	8d 50 08             	lea    0x8(%eax),%edx
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	89 10                	mov    %edx,(%eax)
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8b 00                	mov    (%eax),%eax
  801397:	83 e8 08             	sub    $0x8,%eax
  80139a:	8b 50 04             	mov    0x4(%eax),%edx
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	eb 38                	jmp    8013d9 <getint+0x5d>
	else if (lflag)
  8013a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013a5:	74 1a                	je     8013c1 <getint+0x45>
		return va_arg(*ap, long);
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8b 00                	mov    (%eax),%eax
  8013ac:	8d 50 04             	lea    0x4(%eax),%edx
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	89 10                	mov    %edx,(%eax)
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	8b 00                	mov    (%eax),%eax
  8013b9:	83 e8 04             	sub    $0x4,%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	99                   	cltd   
  8013bf:	eb 18                	jmp    8013d9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8b 00                	mov    (%eax),%eax
  8013c6:	8d 50 04             	lea    0x4(%eax),%edx
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	89 10                	mov    %edx,(%eax)
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	83 e8 04             	sub    $0x4,%eax
  8013d6:	8b 00                	mov    (%eax),%eax
  8013d8:	99                   	cltd   
}
  8013d9:	5d                   	pop    %ebp
  8013da:	c3                   	ret    

008013db <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	56                   	push   %esi
  8013df:	53                   	push   %ebx
  8013e0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013e3:	eb 17                	jmp    8013fc <vprintfmt+0x21>
			if (ch == '\0')
  8013e5:	85 db                	test   %ebx,%ebx
  8013e7:	0f 84 af 03 00 00    	je     80179c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8013ed:	83 ec 08             	sub    $0x8,%esp
  8013f0:	ff 75 0c             	pushl  0xc(%ebp)
  8013f3:	53                   	push   %ebx
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	ff d0                	call   *%eax
  8013f9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ff:	8d 50 01             	lea    0x1(%eax),%edx
  801402:	89 55 10             	mov    %edx,0x10(%ebp)
  801405:	8a 00                	mov    (%eax),%al
  801407:	0f b6 d8             	movzbl %al,%ebx
  80140a:	83 fb 25             	cmp    $0x25,%ebx
  80140d:	75 d6                	jne    8013e5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80140f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801413:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80141a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801421:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801428:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80142f:	8b 45 10             	mov    0x10(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 10             	mov    %edx,0x10(%ebp)
  801438:	8a 00                	mov    (%eax),%al
  80143a:	0f b6 d8             	movzbl %al,%ebx
  80143d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801440:	83 f8 55             	cmp    $0x55,%eax
  801443:	0f 87 2b 03 00 00    	ja     801774 <vprintfmt+0x399>
  801449:	8b 04 85 58 39 80 00 	mov    0x803958(,%eax,4),%eax
  801450:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801452:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801456:	eb d7                	jmp    80142f <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801458:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80145c:	eb d1                	jmp    80142f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80145e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801468:	89 d0                	mov    %edx,%eax
  80146a:	c1 e0 02             	shl    $0x2,%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	01 c0                	add    %eax,%eax
  801471:	01 d8                	add    %ebx,%eax
  801473:	83 e8 30             	sub    $0x30,%eax
  801476:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801479:	8b 45 10             	mov    0x10(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801481:	83 fb 2f             	cmp    $0x2f,%ebx
  801484:	7e 3e                	jle    8014c4 <vprintfmt+0xe9>
  801486:	83 fb 39             	cmp    $0x39,%ebx
  801489:	7f 39                	jg     8014c4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80148b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80148e:	eb d5                	jmp    801465 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801490:	8b 45 14             	mov    0x14(%ebp),%eax
  801493:	83 c0 04             	add    $0x4,%eax
  801496:	89 45 14             	mov    %eax,0x14(%ebp)
  801499:	8b 45 14             	mov    0x14(%ebp),%eax
  80149c:	83 e8 04             	sub    $0x4,%eax
  80149f:	8b 00                	mov    (%eax),%eax
  8014a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014a4:	eb 1f                	jmp    8014c5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014aa:	79 83                	jns    80142f <vprintfmt+0x54>
				width = 0;
  8014ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014b3:	e9 77 ff ff ff       	jmp    80142f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014b8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014bf:	e9 6b ff ff ff       	jmp    80142f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014c4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014c9:	0f 89 60 ff ff ff    	jns    80142f <vprintfmt+0x54>
				width = precision, precision = -1;
  8014cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014dc:	e9 4e ff ff ff       	jmp    80142f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014e1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014e4:	e9 46 ff ff ff       	jmp    80142f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8014e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ec:	83 c0 04             	add    $0x4,%eax
  8014ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8014f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f5:	83 e8 04             	sub    $0x4,%eax
  8014f8:	8b 00                	mov    (%eax),%eax
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	50                   	push   %eax
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	ff d0                	call   *%eax
  801506:	83 c4 10             	add    $0x10,%esp
			break;
  801509:	e9 89 02 00 00       	jmp    801797 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80150e:	8b 45 14             	mov    0x14(%ebp),%eax
  801511:	83 c0 04             	add    $0x4,%eax
  801514:	89 45 14             	mov    %eax,0x14(%ebp)
  801517:	8b 45 14             	mov    0x14(%ebp),%eax
  80151a:	83 e8 04             	sub    $0x4,%eax
  80151d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80151f:	85 db                	test   %ebx,%ebx
  801521:	79 02                	jns    801525 <vprintfmt+0x14a>
				err = -err;
  801523:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801525:	83 fb 64             	cmp    $0x64,%ebx
  801528:	7f 0b                	jg     801535 <vprintfmt+0x15a>
  80152a:	8b 34 9d a0 37 80 00 	mov    0x8037a0(,%ebx,4),%esi
  801531:	85 f6                	test   %esi,%esi
  801533:	75 19                	jne    80154e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801535:	53                   	push   %ebx
  801536:	68 45 39 80 00       	push   $0x803945
  80153b:	ff 75 0c             	pushl  0xc(%ebp)
  80153e:	ff 75 08             	pushl  0x8(%ebp)
  801541:	e8 5e 02 00 00       	call   8017a4 <printfmt>
  801546:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801549:	e9 49 02 00 00       	jmp    801797 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80154e:	56                   	push   %esi
  80154f:	68 4e 39 80 00       	push   $0x80394e
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	ff 75 08             	pushl  0x8(%ebp)
  80155a:	e8 45 02 00 00       	call   8017a4 <printfmt>
  80155f:	83 c4 10             	add    $0x10,%esp
			break;
  801562:	e9 30 02 00 00       	jmp    801797 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801567:	8b 45 14             	mov    0x14(%ebp),%eax
  80156a:	83 c0 04             	add    $0x4,%eax
  80156d:	89 45 14             	mov    %eax,0x14(%ebp)
  801570:	8b 45 14             	mov    0x14(%ebp),%eax
  801573:	83 e8 04             	sub    $0x4,%eax
  801576:	8b 30                	mov    (%eax),%esi
  801578:	85 f6                	test   %esi,%esi
  80157a:	75 05                	jne    801581 <vprintfmt+0x1a6>
				p = "(null)";
  80157c:	be 51 39 80 00       	mov    $0x803951,%esi
			if (width > 0 && padc != '-')
  801581:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801585:	7e 6d                	jle    8015f4 <vprintfmt+0x219>
  801587:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80158b:	74 67                	je     8015f4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80158d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801590:	83 ec 08             	sub    $0x8,%esp
  801593:	50                   	push   %eax
  801594:	56                   	push   %esi
  801595:	e8 0c 03 00 00       	call   8018a6 <strnlen>
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015a0:	eb 16                	jmp    8015b8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015a2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	50                   	push   %eax
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	ff d0                	call   *%eax
  8015b2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015b5:	ff 4d e4             	decl   -0x1c(%ebp)
  8015b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015bc:	7f e4                	jg     8015a2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015be:	eb 34                	jmp    8015f4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015c4:	74 1c                	je     8015e2 <vprintfmt+0x207>
  8015c6:	83 fb 1f             	cmp    $0x1f,%ebx
  8015c9:	7e 05                	jle    8015d0 <vprintfmt+0x1f5>
  8015cb:	83 fb 7e             	cmp    $0x7e,%ebx
  8015ce:	7e 12                	jle    8015e2 <vprintfmt+0x207>
					putch('?', putdat);
  8015d0:	83 ec 08             	sub    $0x8,%esp
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	6a 3f                	push   $0x3f
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	ff d0                	call   *%eax
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	eb 0f                	jmp    8015f1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	ff 75 0c             	pushl  0xc(%ebp)
  8015e8:	53                   	push   %ebx
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	ff d0                	call   *%eax
  8015ee:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015f1:	ff 4d e4             	decl   -0x1c(%ebp)
  8015f4:	89 f0                	mov    %esi,%eax
  8015f6:	8d 70 01             	lea    0x1(%eax),%esi
  8015f9:	8a 00                	mov    (%eax),%al
  8015fb:	0f be d8             	movsbl %al,%ebx
  8015fe:	85 db                	test   %ebx,%ebx
  801600:	74 24                	je     801626 <vprintfmt+0x24b>
  801602:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801606:	78 b8                	js     8015c0 <vprintfmt+0x1e5>
  801608:	ff 4d e0             	decl   -0x20(%ebp)
  80160b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80160f:	79 af                	jns    8015c0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801611:	eb 13                	jmp    801626 <vprintfmt+0x24b>
				putch(' ', putdat);
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	ff 75 0c             	pushl  0xc(%ebp)
  801619:	6a 20                	push   $0x20
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	ff d0                	call   *%eax
  801620:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801623:	ff 4d e4             	decl   -0x1c(%ebp)
  801626:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80162a:	7f e7                	jg     801613 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80162c:	e9 66 01 00 00       	jmp    801797 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	ff 75 e8             	pushl  -0x18(%ebp)
  801637:	8d 45 14             	lea    0x14(%ebp),%eax
  80163a:	50                   	push   %eax
  80163b:	e8 3c fd ff ff       	call   80137c <getint>
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801646:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164f:	85 d2                	test   %edx,%edx
  801651:	79 23                	jns    801676 <vprintfmt+0x29b>
				putch('-', putdat);
  801653:	83 ec 08             	sub    $0x8,%esp
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	6a 2d                	push   $0x2d
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	ff d0                	call   *%eax
  801660:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801666:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801669:	f7 d8                	neg    %eax
  80166b:	83 d2 00             	adc    $0x0,%edx
  80166e:	f7 da                	neg    %edx
  801670:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801673:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801676:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80167d:	e9 bc 00 00 00       	jmp    80173e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801682:	83 ec 08             	sub    $0x8,%esp
  801685:	ff 75 e8             	pushl  -0x18(%ebp)
  801688:	8d 45 14             	lea    0x14(%ebp),%eax
  80168b:	50                   	push   %eax
  80168c:	e8 84 fc ff ff       	call   801315 <getuint>
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801697:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80169a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016a1:	e9 98 00 00 00       	jmp    80173e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016a6:	83 ec 08             	sub    $0x8,%esp
  8016a9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ac:	6a 58                	push   $0x58
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	ff d0                	call   *%eax
  8016b3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016b6:	83 ec 08             	sub    $0x8,%esp
  8016b9:	ff 75 0c             	pushl  0xc(%ebp)
  8016bc:	6a 58                	push   $0x58
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	ff d0                	call   *%eax
  8016c3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	6a 58                	push   $0x58
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	ff d0                	call   *%eax
  8016d3:	83 c4 10             	add    $0x10,%esp
			break;
  8016d6:	e9 bc 00 00 00       	jmp    801797 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016db:	83 ec 08             	sub    $0x8,%esp
  8016de:	ff 75 0c             	pushl  0xc(%ebp)
  8016e1:	6a 30                	push   $0x30
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	ff d0                	call   *%eax
  8016e8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8016eb:	83 ec 08             	sub    $0x8,%esp
  8016ee:	ff 75 0c             	pushl  0xc(%ebp)
  8016f1:	6a 78                	push   $0x78
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	ff d0                	call   *%eax
  8016f8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8016fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fe:	83 c0 04             	add    $0x4,%eax
  801701:	89 45 14             	mov    %eax,0x14(%ebp)
  801704:	8b 45 14             	mov    0x14(%ebp),%eax
  801707:	83 e8 04             	sub    $0x4,%eax
  80170a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80170c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80170f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801716:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80171d:	eb 1f                	jmp    80173e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	ff 75 e8             	pushl  -0x18(%ebp)
  801725:	8d 45 14             	lea    0x14(%ebp),%eax
  801728:	50                   	push   %eax
  801729:	e8 e7 fb ff ff       	call   801315 <getuint>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801734:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801737:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80173e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	52                   	push   %edx
  801749:	ff 75 e4             	pushl  -0x1c(%ebp)
  80174c:	50                   	push   %eax
  80174d:	ff 75 f4             	pushl  -0xc(%ebp)
  801750:	ff 75 f0             	pushl  -0x10(%ebp)
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	ff 75 08             	pushl  0x8(%ebp)
  801759:	e8 00 fb ff ff       	call   80125e <printnum>
  80175e:	83 c4 20             	add    $0x20,%esp
			break;
  801761:	eb 34                	jmp    801797 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801763:	83 ec 08             	sub    $0x8,%esp
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	53                   	push   %ebx
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	ff d0                	call   *%eax
  80176f:	83 c4 10             	add    $0x10,%esp
			break;
  801772:	eb 23                	jmp    801797 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	ff 75 0c             	pushl  0xc(%ebp)
  80177a:	6a 25                	push   $0x25
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	ff d0                	call   *%eax
  801781:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801784:	ff 4d 10             	decl   0x10(%ebp)
  801787:	eb 03                	jmp    80178c <vprintfmt+0x3b1>
  801789:	ff 4d 10             	decl   0x10(%ebp)
  80178c:	8b 45 10             	mov    0x10(%ebp),%eax
  80178f:	48                   	dec    %eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3c 25                	cmp    $0x25,%al
  801794:	75 f3                	jne    801789 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801796:	90                   	nop
		}
	}
  801797:	e9 47 fc ff ff       	jmp    8013e3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80179c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80179d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a0:	5b                   	pop    %ebx
  8017a1:	5e                   	pop    %esi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    

008017a4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8017ad:	83 c0 04             	add    $0x4,%eax
  8017b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b9:	50                   	push   %eax
  8017ba:	ff 75 0c             	pushl  0xc(%ebp)
  8017bd:	ff 75 08             	pushl  0x8(%ebp)
  8017c0:	e8 16 fc ff ff       	call   8013db <vprintfmt>
  8017c5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017c8:	90                   	nop
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	8b 40 08             	mov    0x8(%eax),%eax
  8017d4:	8d 50 01             	lea    0x1(%eax),%edx
  8017d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017da:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e0:	8b 10                	mov    (%eax),%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	8b 40 04             	mov    0x4(%eax),%eax
  8017e8:	39 c2                	cmp    %eax,%edx
  8017ea:	73 12                	jae    8017fe <sprintputch+0x33>
		*b->buf++ = ch;
  8017ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ef:	8b 00                	mov    (%eax),%eax
  8017f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8017f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f7:	89 0a                	mov    %ecx,(%edx)
  8017f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fc:	88 10                	mov    %dl,(%eax)
}
  8017fe:	90                   	nop
  8017ff:	5d                   	pop    %ebp
  801800:	c3                   	ret    

00801801 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80180d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801810:	8d 50 ff             	lea    -0x1(%eax),%edx
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80181b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801822:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801826:	74 06                	je     80182e <vsnprintf+0x2d>
  801828:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80182c:	7f 07                	jg     801835 <vsnprintf+0x34>
		return -E_INVAL;
  80182e:	b8 03 00 00 00       	mov    $0x3,%eax
  801833:	eb 20                	jmp    801855 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801835:	ff 75 14             	pushl  0x14(%ebp)
  801838:	ff 75 10             	pushl  0x10(%ebp)
  80183b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80183e:	50                   	push   %eax
  80183f:	68 cb 17 80 00       	push   $0x8017cb
  801844:	e8 92 fb ff ff       	call   8013db <vprintfmt>
  801849:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80184c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80185d:	8d 45 10             	lea    0x10(%ebp),%eax
  801860:	83 c0 04             	add    $0x4,%eax
  801863:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801866:	8b 45 10             	mov    0x10(%ebp),%eax
  801869:	ff 75 f4             	pushl  -0xc(%ebp)
  80186c:	50                   	push   %eax
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	e8 89 ff ff ff       	call   801801 <vsnprintf>
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801889:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801890:	eb 06                	jmp    801898 <strlen+0x15>
		n++;
  801892:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801895:	ff 45 08             	incl   0x8(%ebp)
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	8a 00                	mov    (%eax),%al
  80189d:	84 c0                	test   %al,%al
  80189f:	75 f1                	jne    801892 <strlen+0xf>
		n++;
	return n;
  8018a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018b3:	eb 09                	jmp    8018be <strnlen+0x18>
		n++;
  8018b5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018b8:	ff 45 08             	incl   0x8(%ebp)
  8018bb:	ff 4d 0c             	decl   0xc(%ebp)
  8018be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c2:	74 09                	je     8018cd <strnlen+0x27>
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	8a 00                	mov    (%eax),%al
  8018c9:	84 c0                	test   %al,%al
  8018cb:	75 e8                	jne    8018b5 <strnlen+0xf>
		n++;
	return n;
  8018cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018de:	90                   	nop
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8d 50 01             	lea    0x1(%eax),%edx
  8018e5:	89 55 08             	mov    %edx,0x8(%ebp)
  8018e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018ee:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018f1:	8a 12                	mov    (%edx),%dl
  8018f3:	88 10                	mov    %dl,(%eax)
  8018f5:	8a 00                	mov    (%eax),%al
  8018f7:	84 c0                	test   %al,%al
  8018f9:	75 e4                	jne    8018df <strcpy+0xd>
		/* do nothing */;
	return ret;
  8018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80190c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801913:	eb 1f                	jmp    801934 <strncpy+0x34>
		*dst++ = *src;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 08             	mov    %edx,0x8(%ebp)
  80191e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801921:	8a 12                	mov    (%edx),%dl
  801923:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801925:	8b 45 0c             	mov    0xc(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	74 03                	je     801931 <strncpy+0x31>
			src++;
  80192e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801931:	ff 45 fc             	incl   -0x4(%ebp)
  801934:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801937:	3b 45 10             	cmp    0x10(%ebp),%eax
  80193a:	72 d9                	jb     801915 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80193c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80194d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801951:	74 30                	je     801983 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801953:	eb 16                	jmp    80196b <strlcpy+0x2a>
			*dst++ = *src++;
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	8d 50 01             	lea    0x1(%eax),%edx
  80195b:	89 55 08             	mov    %edx,0x8(%ebp)
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8d 4a 01             	lea    0x1(%edx),%ecx
  801964:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801967:	8a 12                	mov    (%edx),%dl
  801969:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80196b:	ff 4d 10             	decl   0x10(%ebp)
  80196e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801972:	74 09                	je     80197d <strlcpy+0x3c>
  801974:	8b 45 0c             	mov    0xc(%ebp),%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	84 c0                	test   %al,%al
  80197b:	75 d8                	jne    801955 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801983:	8b 55 08             	mov    0x8(%ebp),%edx
  801986:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801989:	29 c2                	sub    %eax,%edx
  80198b:	89 d0                	mov    %edx,%eax
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801992:	eb 06                	jmp    80199a <strcmp+0xb>
		p++, q++;
  801994:	ff 45 08             	incl   0x8(%ebp)
  801997:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	8a 00                	mov    (%eax),%al
  80199f:	84 c0                	test   %al,%al
  8019a1:	74 0e                	je     8019b1 <strcmp+0x22>
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	8a 10                	mov    (%eax),%dl
  8019a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ab:	8a 00                	mov    (%eax),%al
  8019ad:	38 c2                	cmp    %al,%dl
  8019af:	74 e3                	je     801994 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	8a 00                	mov    (%eax),%al
  8019b6:	0f b6 d0             	movzbl %al,%edx
  8019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bc:	8a 00                	mov    (%eax),%al
  8019be:	0f b6 c0             	movzbl %al,%eax
  8019c1:	29 c2                	sub    %eax,%edx
  8019c3:	89 d0                	mov    %edx,%eax
}
  8019c5:	5d                   	pop    %ebp
  8019c6:	c3                   	ret    

008019c7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019ca:	eb 09                	jmp    8019d5 <strncmp+0xe>
		n--, p++, q++;
  8019cc:	ff 4d 10             	decl   0x10(%ebp)
  8019cf:	ff 45 08             	incl   0x8(%ebp)
  8019d2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d9:	74 17                	je     8019f2 <strncmp+0x2b>
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	8a 00                	mov    (%eax),%al
  8019e0:	84 c0                	test   %al,%al
  8019e2:	74 0e                	je     8019f2 <strncmp+0x2b>
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	8a 10                	mov    (%eax),%dl
  8019e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	38 c2                	cmp    %al,%dl
  8019f0:	74 da                	je     8019cc <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8019f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f6:	75 07                	jne    8019ff <strncmp+0x38>
		return 0;
  8019f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fd:	eb 14                	jmp    801a13 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	0f b6 d0             	movzbl %al,%edx
  801a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0a:	8a 00                	mov    (%eax),%al
  801a0c:	0f b6 c0             	movzbl %al,%eax
  801a0f:	29 c2                	sub    %eax,%edx
  801a11:	89 d0                	mov    %edx,%eax
}
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    

00801a15 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	83 ec 04             	sub    $0x4,%esp
  801a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a21:	eb 12                	jmp    801a35 <strchr+0x20>
		if (*s == c)
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	8a 00                	mov    (%eax),%al
  801a28:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a2b:	75 05                	jne    801a32 <strchr+0x1d>
			return (char *) s;
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	eb 11                	jmp    801a43 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a32:	ff 45 08             	incl   0x8(%ebp)
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	8a 00                	mov    (%eax),%al
  801a3a:	84 c0                	test   %al,%al
  801a3c:	75 e5                	jne    801a23 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 04             	sub    $0x4,%esp
  801a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a51:	eb 0d                	jmp    801a60 <strfind+0x1b>
		if (*s == c)
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	8a 00                	mov    (%eax),%al
  801a58:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a5b:	74 0e                	je     801a6b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a5d:	ff 45 08             	incl   0x8(%ebp)
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	8a 00                	mov    (%eax),%al
  801a65:	84 c0                	test   %al,%al
  801a67:	75 ea                	jne    801a53 <strfind+0xe>
  801a69:	eb 01                	jmp    801a6c <strfind+0x27>
		if (*s == c)
			break;
  801a6b:	90                   	nop
	return (char *) s;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a80:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a83:	eb 0e                	jmp    801a93 <memset+0x22>
		*p++ = c;
  801a85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a88:	8d 50 01             	lea    0x1(%eax),%edx
  801a8b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a91:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a93:	ff 4d f8             	decl   -0x8(%ebp)
  801a96:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a9a:	79 e9                	jns    801a85 <memset+0x14>
		*p++ = c;

	return v;
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801ab3:	eb 16                	jmp    801acb <memcpy+0x2a>
		*d++ = *s++;
  801ab5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ab8:	8d 50 01             	lea    0x1(%eax),%edx
  801abb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801abe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac1:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ac4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ac7:	8a 12                	mov    (%edx),%dl
  801ac9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801acb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ace:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ad1:	89 55 10             	mov    %edx,0x10(%ebp)
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	75 dd                	jne    801ab5 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801aef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801af5:	73 50                	jae    801b47 <memmove+0x6a>
  801af7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801afa:	8b 45 10             	mov    0x10(%ebp),%eax
  801afd:	01 d0                	add    %edx,%eax
  801aff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b02:	76 43                	jbe    801b47 <memmove+0x6a>
		s += n;
  801b04:	8b 45 10             	mov    0x10(%ebp),%eax
  801b07:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b10:	eb 10                	jmp    801b22 <memmove+0x45>
			*--d = *--s;
  801b12:	ff 4d f8             	decl   -0x8(%ebp)
  801b15:	ff 4d fc             	decl   -0x4(%ebp)
  801b18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b1b:	8a 10                	mov    (%eax),%dl
  801b1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b20:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b22:	8b 45 10             	mov    0x10(%ebp),%eax
  801b25:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b28:	89 55 10             	mov    %edx,0x10(%ebp)
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	75 e3                	jne    801b12 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b2f:	eb 23                	jmp    801b54 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b34:	8d 50 01             	lea    0x1(%eax),%edx
  801b37:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b40:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b43:	8a 12                	mov    (%edx),%dl
  801b45:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b47:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b4d:	89 55 10             	mov    %edx,0x10(%ebp)
  801b50:	85 c0                	test   %eax,%eax
  801b52:	75 dd                	jne    801b31 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b68:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b6b:	eb 2a                	jmp    801b97 <memcmp+0x3e>
		if (*s1 != *s2)
  801b6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b70:	8a 10                	mov    (%eax),%dl
  801b72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b75:	8a 00                	mov    (%eax),%al
  801b77:	38 c2                	cmp    %al,%dl
  801b79:	74 16                	je     801b91 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7e:	8a 00                	mov    (%eax),%al
  801b80:	0f b6 d0             	movzbl %al,%edx
  801b83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	0f b6 c0             	movzbl %al,%eax
  801b8b:	29 c2                	sub    %eax,%edx
  801b8d:	89 d0                	mov    %edx,%eax
  801b8f:	eb 18                	jmp    801ba9 <memcmp+0x50>
		s1++, s2++;
  801b91:	ff 45 fc             	incl   -0x4(%ebp)
  801b94:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b97:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b9d:	89 55 10             	mov    %edx,0x10(%ebp)
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	75 c9                	jne    801b6d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ba4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  801bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb7:	01 d0                	add    %edx,%eax
  801bb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801bbc:	eb 15                	jmp    801bd3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	8a 00                	mov    (%eax),%al
  801bc3:	0f b6 d0             	movzbl %al,%edx
  801bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc9:	0f b6 c0             	movzbl %al,%eax
  801bcc:	39 c2                	cmp    %eax,%edx
  801bce:	74 0d                	je     801bdd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801bd0:	ff 45 08             	incl   0x8(%ebp)
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bd9:	72 e3                	jb     801bbe <memfind+0x13>
  801bdb:	eb 01                	jmp    801bde <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bdd:	90                   	nop
	return (void *) s;
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801be9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801bf0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bf7:	eb 03                	jmp    801bfc <strtol+0x19>
		s++;
  801bf9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	8a 00                	mov    (%eax),%al
  801c01:	3c 20                	cmp    $0x20,%al
  801c03:	74 f4                	je     801bf9 <strtol+0x16>
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	8a 00                	mov    (%eax),%al
  801c0a:	3c 09                	cmp    $0x9,%al
  801c0c:	74 eb                	je     801bf9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	8a 00                	mov    (%eax),%al
  801c13:	3c 2b                	cmp    $0x2b,%al
  801c15:	75 05                	jne    801c1c <strtol+0x39>
		s++;
  801c17:	ff 45 08             	incl   0x8(%ebp)
  801c1a:	eb 13                	jmp    801c2f <strtol+0x4c>
	else if (*s == '-')
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	8a 00                	mov    (%eax),%al
  801c21:	3c 2d                	cmp    $0x2d,%al
  801c23:	75 0a                	jne    801c2f <strtol+0x4c>
		s++, neg = 1;
  801c25:	ff 45 08             	incl   0x8(%ebp)
  801c28:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c33:	74 06                	je     801c3b <strtol+0x58>
  801c35:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c39:	75 20                	jne    801c5b <strtol+0x78>
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	8a 00                	mov    (%eax),%al
  801c40:	3c 30                	cmp    $0x30,%al
  801c42:	75 17                	jne    801c5b <strtol+0x78>
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	40                   	inc    %eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	3c 78                	cmp    $0x78,%al
  801c4c:	75 0d                	jne    801c5b <strtol+0x78>
		s += 2, base = 16;
  801c4e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c52:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c59:	eb 28                	jmp    801c83 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c5f:	75 15                	jne    801c76 <strtol+0x93>
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	8a 00                	mov    (%eax),%al
  801c66:	3c 30                	cmp    $0x30,%al
  801c68:	75 0c                	jne    801c76 <strtol+0x93>
		s++, base = 8;
  801c6a:	ff 45 08             	incl   0x8(%ebp)
  801c6d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c74:	eb 0d                	jmp    801c83 <strtol+0xa0>
	else if (base == 0)
  801c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7a:	75 07                	jne    801c83 <strtol+0xa0>
		base = 10;
  801c7c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8a 00                	mov    (%eax),%al
  801c88:	3c 2f                	cmp    $0x2f,%al
  801c8a:	7e 19                	jle    801ca5 <strtol+0xc2>
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	8a 00                	mov    (%eax),%al
  801c91:	3c 39                	cmp    $0x39,%al
  801c93:	7f 10                	jg     801ca5 <strtol+0xc2>
			dig = *s - '0';
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	8a 00                	mov    (%eax),%al
  801c9a:	0f be c0             	movsbl %al,%eax
  801c9d:	83 e8 30             	sub    $0x30,%eax
  801ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ca3:	eb 42                	jmp    801ce7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	8a 00                	mov    (%eax),%al
  801caa:	3c 60                	cmp    $0x60,%al
  801cac:	7e 19                	jle    801cc7 <strtol+0xe4>
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	8a 00                	mov    (%eax),%al
  801cb3:	3c 7a                	cmp    $0x7a,%al
  801cb5:	7f 10                	jg     801cc7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8a 00                	mov    (%eax),%al
  801cbc:	0f be c0             	movsbl %al,%eax
  801cbf:	83 e8 57             	sub    $0x57,%eax
  801cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc5:	eb 20                	jmp    801ce7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	8a 00                	mov    (%eax),%al
  801ccc:	3c 40                	cmp    $0x40,%al
  801cce:	7e 39                	jle    801d09 <strtol+0x126>
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	8a 00                	mov    (%eax),%al
  801cd5:	3c 5a                	cmp    $0x5a,%al
  801cd7:	7f 30                	jg     801d09 <strtol+0x126>
			dig = *s - 'A' + 10;
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	8a 00                	mov    (%eax),%al
  801cde:	0f be c0             	movsbl %al,%eax
  801ce1:	83 e8 37             	sub    $0x37,%eax
  801ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cea:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ced:	7d 19                	jge    801d08 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801cef:	ff 45 08             	incl   0x8(%ebp)
  801cf2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf5:	0f af 45 10          	imul   0x10(%ebp),%eax
  801cf9:	89 c2                	mov    %eax,%edx
  801cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfe:	01 d0                	add    %edx,%eax
  801d00:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d03:	e9 7b ff ff ff       	jmp    801c83 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d08:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d0d:	74 08                	je     801d17 <strtol+0x134>
		*endptr = (char *) s;
  801d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d12:	8b 55 08             	mov    0x8(%ebp),%edx
  801d15:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d17:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d1b:	74 07                	je     801d24 <strtol+0x141>
  801d1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d20:	f7 d8                	neg    %eax
  801d22:	eb 03                	jmp    801d27 <strtol+0x144>
  801d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <ltostr>:

void
ltostr(long value, char *str)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d36:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d41:	79 13                	jns    801d56 <ltostr+0x2d>
	{
		neg = 1;
  801d43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d50:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d53:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d5e:	99                   	cltd   
  801d5f:	f7 f9                	idiv   %ecx
  801d61:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d67:	8d 50 01             	lea    0x1(%eax),%edx
  801d6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d6d:	89 c2                	mov    %eax,%edx
  801d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d72:	01 d0                	add    %edx,%eax
  801d74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d77:	83 c2 30             	add    $0x30,%edx
  801d7a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d84:	f7 e9                	imul   %ecx
  801d86:	c1 fa 02             	sar    $0x2,%edx
  801d89:	89 c8                	mov    %ecx,%eax
  801d8b:	c1 f8 1f             	sar    $0x1f,%eax
  801d8e:	29 c2                	sub    %eax,%edx
  801d90:	89 d0                	mov    %edx,%eax
  801d92:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d98:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d9d:	f7 e9                	imul   %ecx
  801d9f:	c1 fa 02             	sar    $0x2,%edx
  801da2:	89 c8                	mov    %ecx,%eax
  801da4:	c1 f8 1f             	sar    $0x1f,%eax
  801da7:	29 c2                	sub    %eax,%edx
  801da9:	89 d0                	mov    %edx,%eax
  801dab:	c1 e0 02             	shl    $0x2,%eax
  801dae:	01 d0                	add    %edx,%eax
  801db0:	01 c0                	add    %eax,%eax
  801db2:	29 c1                	sub    %eax,%ecx
  801db4:	89 ca                	mov    %ecx,%edx
  801db6:	85 d2                	test   %edx,%edx
  801db8:	75 9c                	jne    801d56 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801dba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc4:	48                   	dec    %eax
  801dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801dc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801dcc:	74 3d                	je     801e0b <ltostr+0xe2>
		start = 1 ;
  801dce:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801dd5:	eb 34                	jmp    801e0b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddd:	01 d0                	add    %edx,%eax
  801ddf:	8a 00                	mov    (%eax),%al
  801de1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dea:	01 c2                	add    %eax,%edx
  801dec:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801def:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df2:	01 c8                	add    %ecx,%eax
  801df4:	8a 00                	mov    (%eax),%al
  801df6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801df8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfe:	01 c2                	add    %eax,%edx
  801e00:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e03:	88 02                	mov    %al,(%edx)
		start++ ;
  801e05:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e08:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e11:	7c c4                	jl     801dd7 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e13:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 d0                	add    %edx,%eax
  801e1b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e1e:	90                   	nop
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e27:	ff 75 08             	pushl  0x8(%ebp)
  801e2a:	e8 54 fa ff ff       	call   801883 <strlen>
  801e2f:	83 c4 04             	add    $0x4,%esp
  801e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	e8 46 fa ff ff       	call   801883 <strlen>
  801e3d:	83 c4 04             	add    $0x4,%esp
  801e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e51:	eb 17                	jmp    801e6a <strcconcat+0x49>
		final[s] = str1[s] ;
  801e53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e56:	8b 45 10             	mov    0x10(%ebp),%eax
  801e59:	01 c2                	add    %eax,%edx
  801e5b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	01 c8                	add    %ecx,%eax
  801e63:	8a 00                	mov    (%eax),%al
  801e65:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e67:	ff 45 fc             	incl   -0x4(%ebp)
  801e6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e6d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e70:	7c e1                	jl     801e53 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e72:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e79:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e80:	eb 1f                	jmp    801ea1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e85:	8d 50 01             	lea    0x1(%eax),%edx
  801e88:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e8b:	89 c2                	mov    %eax,%edx
  801e8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e90:	01 c2                	add    %eax,%edx
  801e92:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	01 c8                	add    %ecx,%eax
  801e9a:	8a 00                	mov    (%eax),%al
  801e9c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e9e:	ff 45 f8             	incl   -0x8(%ebp)
  801ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ea4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ea7:	7c d9                	jl     801e82 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ea9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	01 d0                	add    %edx,%eax
  801eb1:	c6 00 00             	movb   $0x0,(%eax)
}
  801eb4:	90                   	nop
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801eba:	8b 45 14             	mov    0x14(%ebp),%eax
  801ebd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ec3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec6:	8b 00                	mov    (%eax),%eax
  801ec8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed2:	01 d0                	add    %edx,%eax
  801ed4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801eda:	eb 0c                	jmp    801ee8 <strsplit+0x31>
			*string++ = 0;
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	8d 50 01             	lea    0x1(%eax),%edx
  801ee2:	89 55 08             	mov    %edx,0x8(%ebp)
  801ee5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	8a 00                	mov    (%eax),%al
  801eed:	84 c0                	test   %al,%al
  801eef:	74 18                	je     801f09 <strsplit+0x52>
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	8a 00                	mov    (%eax),%al
  801ef6:	0f be c0             	movsbl %al,%eax
  801ef9:	50                   	push   %eax
  801efa:	ff 75 0c             	pushl  0xc(%ebp)
  801efd:	e8 13 fb ff ff       	call   801a15 <strchr>
  801f02:	83 c4 08             	add    $0x8,%esp
  801f05:	85 c0                	test   %eax,%eax
  801f07:	75 d3                	jne    801edc <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	8a 00                	mov    (%eax),%al
  801f0e:	84 c0                	test   %al,%al
  801f10:	74 5a                	je     801f6c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801f12:	8b 45 14             	mov    0x14(%ebp),%eax
  801f15:	8b 00                	mov    (%eax),%eax
  801f17:	83 f8 0f             	cmp    $0xf,%eax
  801f1a:	75 07                	jne    801f23 <strsplit+0x6c>
		{
			return 0;
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f21:	eb 66                	jmp    801f89 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f23:	8b 45 14             	mov    0x14(%ebp),%eax
  801f26:	8b 00                	mov    (%eax),%eax
  801f28:	8d 48 01             	lea    0x1(%eax),%ecx
  801f2b:	8b 55 14             	mov    0x14(%ebp),%edx
  801f2e:	89 0a                	mov    %ecx,(%edx)
  801f30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f37:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3a:	01 c2                	add    %eax,%edx
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f41:	eb 03                	jmp    801f46 <strsplit+0x8f>
			string++;
  801f43:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	8a 00                	mov    (%eax),%al
  801f4b:	84 c0                	test   %al,%al
  801f4d:	74 8b                	je     801eda <strsplit+0x23>
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	8a 00                	mov    (%eax),%al
  801f54:	0f be c0             	movsbl %al,%eax
  801f57:	50                   	push   %eax
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	e8 b5 fa ff ff       	call   801a15 <strchr>
  801f60:	83 c4 08             	add    $0x8,%esp
  801f63:	85 c0                	test   %eax,%eax
  801f65:	74 dc                	je     801f43 <strsplit+0x8c>
			string++;
	}
  801f67:	e9 6e ff ff ff       	jmp    801eda <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f6c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f70:	8b 00                	mov    (%eax),%eax
  801f72:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f79:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7c:	01 d0                	add    %edx,%eax
  801f7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f84:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801f94:	e8 7d 0f 00 00       	call   802f16 <sys_isUHeapPlacementStrategyNEXTFIT>
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	0f 84 6f 03 00 00    	je     802310 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801fa1:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  801fab:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801fae:	01 d0                	add    %edx,%eax
  801fb0:	48                   	dec    %eax
  801fb1:	89 45 80             	mov    %eax,-0x80(%ebp)
  801fb4:	8b 45 80             	mov    -0x80(%ebp),%eax
  801fb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbc:	f7 75 84             	divl   -0x7c(%ebp)
  801fbf:	8b 45 80             	mov    -0x80(%ebp),%eax
  801fc2:	29 d0                	sub    %edx,%eax
  801fc4:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801fc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fcb:	74 09                	je     801fd6 <malloc+0x4b>
  801fcd:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801fd4:	76 0a                	jbe    801fe0 <malloc+0x55>
			return NULL;
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdb:	e9 4b 09 00 00       	jmp    80292b <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801fe0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	01 d0                	add    %edx,%eax
  801feb:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801ff0:	0f 87 a2 00 00 00    	ja     802098 <malloc+0x10d>
  801ff6:	a1 40 40 98 00       	mov    0x984040,%eax
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	0f 85 95 00 00 00    	jne    802098 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  802003:	a1 04 40 80 00       	mov    0x804004,%eax
  802008:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  80200e:	a1 04 40 80 00       	mov    0x804004,%eax
  802013:	83 ec 08             	sub    $0x8,%esp
  802016:	ff 75 08             	pushl  0x8(%ebp)
  802019:	50                   	push   %eax
  80201a:	e8 a3 0b 00 00       	call   802bc2 <sys_allocateMem>
  80201f:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  802022:	a1 20 40 80 00       	mov    0x804020,%eax
  802027:	8b 55 08             	mov    0x8(%ebp),%edx
  80202a:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802031:	a1 20 40 80 00       	mov    0x804020,%eax
  802036:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80203c:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  802043:	a1 20 40 80 00       	mov    0x804020,%eax
  802048:	40                   	inc    %eax
  802049:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  80204e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  802055:	eb 2e                	jmp    802085 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802057:	a1 04 40 80 00       	mov    0x804004,%eax
  80205c:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  802061:	c1 e8 0c             	shr    $0xc,%eax
  802064:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  80206b:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  80206f:	a1 04 40 80 00       	mov    0x804004,%eax
  802074:	05 00 10 00 00       	add    $0x1000,%eax
  802079:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  80207e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802088:	3b 45 08             	cmp    0x8(%ebp),%eax
  80208b:	72 ca                	jb     802057 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  80208d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  802093:	e9 93 08 00 00       	jmp    80292b <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  802098:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  80209f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  8020a6:	a1 40 40 98 00       	mov    0x984040,%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	75 1d                	jne    8020cc <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  8020af:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  8020b6:	00 00 80 
				check = 1;
  8020b9:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  8020c0:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  8020c3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  8020ca:	eb 08                	jmp    8020d4 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  8020cc:	a1 04 40 80 00       	mov    0x804004,%eax
  8020d1:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  8020d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  8020db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  8020e2:	a1 04 40 80 00       	mov    0x804004,%eax
  8020e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8020ea:	eb 4d                	jmp    802139 <malloc+0x1ae>
				if (sz == size) {
  8020ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020f2:	75 09                	jne    8020fd <malloc+0x172>
					f = 1;
  8020f4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8020fb:	eb 45                	jmp    802142 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8020fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802100:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  802105:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802108:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  80210f:	85 c0                	test   %eax,%eax
  802111:	75 10                	jne    802123 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  802113:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80211a:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  802121:	eb 16                	jmp    802139 <malloc+0x1ae>
				} else {
					sz = 0;
  802123:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  80212a:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  802131:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802134:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  802139:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  802140:	76 aa                	jbe    8020ec <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  802142:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802146:	0f 84 95 00 00 00    	je     8021e1 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  80214c:	a1 04 40 80 00       	mov    0x804004,%eax
  802151:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  802157:	a1 04 40 80 00       	mov    0x804004,%eax
  80215c:	83 ec 08             	sub    $0x8,%esp
  80215f:	ff 75 08             	pushl  0x8(%ebp)
  802162:	50                   	push   %eax
  802163:	e8 5a 0a 00 00       	call   802bc2 <sys_allocateMem>
  802168:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  80216b:	a1 20 40 80 00       	mov    0x804020,%eax
  802170:	8b 55 08             	mov    0x8(%ebp),%edx
  802173:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80217a:	a1 20 40 80 00       	mov    0x804020,%eax
  80217f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802185:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  80218c:	a1 20 40 80 00       	mov    0x804020,%eax
  802191:	40                   	inc    %eax
  802192:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  802197:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80219e:	eb 2e                	jmp    8021ce <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8021a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8021a5:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8021aa:	c1 e8 0c             	shr    $0xc,%eax
  8021ad:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8021b4:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  8021b8:	a1 04 40 80 00       	mov    0x804004,%eax
  8021bd:	05 00 10 00 00       	add    $0x1000,%eax
  8021c2:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8021c7:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8021ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021d4:	72 ca                	jb     8021a0 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  8021d6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8021dc:	e9 4a 07 00 00       	jmp    80292b <malloc+0x9a0>

			} else {

				if (check_start) {
  8021e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e5:	74 0a                	je     8021f1 <malloc+0x266>

					return NULL;
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	e9 3a 07 00 00       	jmp    80292b <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  8021f1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  8021f8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  8021ff:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  802206:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  80220d:	00 00 80 
				while (ptr < (uint32) temp_end) {
  802210:	eb 4d                	jmp    80225f <malloc+0x2d4>
					if (sz == size) {
  802212:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802215:	3b 45 08             	cmp    0x8(%ebp),%eax
  802218:	75 09                	jne    802223 <malloc+0x298>
						f = 1;
  80221a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  802221:	eb 44                	jmp    802267 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802223:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802226:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  80222b:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80222e:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802235:	85 c0                	test   %eax,%eax
  802237:	75 10                	jne    802249 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  802239:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  802240:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  802247:	eb 16                	jmp    80225f <malloc+0x2d4>
					} else {
						sz = 0;
  802249:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  802250:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  802257:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80225a:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  80225f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802262:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  802265:	72 ab                	jb     802212 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  802267:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80226b:	0f 84 95 00 00 00    	je     802306 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  802271:	a1 04 40 80 00       	mov    0x804004,%eax
  802276:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  80227c:	a1 04 40 80 00       	mov    0x804004,%eax
  802281:	83 ec 08             	sub    $0x8,%esp
  802284:	ff 75 08             	pushl  0x8(%ebp)
  802287:	50                   	push   %eax
  802288:	e8 35 09 00 00       	call   802bc2 <sys_allocateMem>
  80228d:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  802290:	a1 20 40 80 00       	mov    0x804020,%eax
  802295:	8b 55 08             	mov    0x8(%ebp),%edx
  802298:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80229f:	a1 20 40 80 00       	mov    0x804020,%eax
  8022a4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8022aa:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  8022b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8022b6:	40                   	inc    %eax
  8022b7:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  8022bc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  8022c3:	eb 2e                	jmp    8022f3 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8022c5:	a1 04 40 80 00       	mov    0x804004,%eax
  8022ca:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  8022cf:	c1 e8 0c             	shr    $0xc,%eax
  8022d2:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8022d9:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  8022dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8022e2:	05 00 10 00 00       	add    $0x1000,%eax
  8022e7:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  8022ec:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  8022f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f9:	72 ca                	jb     8022c5 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  8022fb:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  802301:	e9 25 06 00 00       	jmp    80292b <malloc+0x9a0>

				} else {

					return NULL;
  802306:	b8 00 00 00 00       	mov    $0x0,%eax
  80230b:	e9 1b 06 00 00       	jmp    80292b <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  802310:	e8 d0 0b 00 00       	call   802ee5 <sys_isUHeapPlacementStrategyBESTFIT>
  802315:	85 c0                	test   %eax,%eax
  802317:	0f 84 ba 01 00 00    	je     8024d7 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  80231d:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  802324:	10 00 00 
  802327:	8b 55 08             	mov    0x8(%ebp),%edx
  80232a:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  802330:	01 d0                	add    %edx,%eax
  802332:	48                   	dec    %eax
  802333:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  802339:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80233f:	ba 00 00 00 00       	mov    $0x0,%edx
  802344:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  80234a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  802350:	29 d0                	sub    %edx,%eax
  802352:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802355:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802359:	74 09                	je     802364 <malloc+0x3d9>
  80235b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802362:	76 0a                	jbe    80236e <malloc+0x3e3>
			return NULL;
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
  802369:	e9 bd 05 00 00       	jmp    80292b <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  80236e:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  802375:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  80237c:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  802383:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  80238a:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	c1 e8 0c             	shr    $0xc,%eax
  802397:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  80239d:	e9 80 00 00 00       	jmp    802422 <malloc+0x497>

			if (heap_mem[i] == 0) {
  8023a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023a5:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	75 0c                	jne    8023bc <malloc+0x431>

				count++;
  8023b0:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  8023b3:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8023ba:	eb 2d                	jmp    8023e9 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  8023bc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8023c2:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8023c5:	77 14                	ja     8023db <malloc+0x450>
  8023c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023ca:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8023cd:	76 0c                	jbe    8023db <malloc+0x450>

					min_sz = count;
  8023cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023d2:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  8023d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  8023db:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  8023e2:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  8023e9:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  8023f0:	75 2d                	jne    80241f <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  8023f2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8023f8:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8023fb:	77 22                	ja     80241f <malloc+0x494>
  8023fd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802400:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  802403:	76 1a                	jbe    80241f <malloc+0x494>

					min_sz = count;
  802405:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802408:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  80240b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80240e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  802411:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  802418:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  80241f:	ff 45 b8             	incl   -0x48(%ebp)
  802422:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802425:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  80242a:	0f 86 72 ff ff ff    	jbe    8023a2 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  802430:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  802436:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  802439:	77 06                	ja     802441 <malloc+0x4b6>
  80243b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80243f:	75 0a                	jne    80244b <malloc+0x4c0>
			return NULL;
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
  802446:	e9 e0 04 00 00       	jmp    80292b <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  80244b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80244e:	c1 e0 0c             	shl    $0xc,%eax
  802451:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  802454:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802457:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  80245d:	83 ec 08             	sub    $0x8,%esp
  802460:	ff 75 08             	pushl  0x8(%ebp)
  802463:	ff 75 c4             	pushl  -0x3c(%ebp)
  802466:	e8 57 07 00 00       	call   802bc2 <sys_allocateMem>
  80246b:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80246e:	a1 20 40 80 00       	mov    0x804020,%eax
  802473:	8b 55 08             	mov    0x8(%ebp),%edx
  802476:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  80247d:	a1 20 40 80 00       	mov    0x804020,%eax
  802482:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802485:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  80248c:	a1 20 40 80 00       	mov    0x804020,%eax
  802491:	40                   	inc    %eax
  802492:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  802497:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  80249e:	eb 24                	jmp    8024c4 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8024a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024a3:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8024a8:	c1 e8 0c             	shr    $0xc,%eax
  8024ab:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8024b2:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  8024b6:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8024bd:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  8024c4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ca:	72 d4                	jb     8024a0 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8024cc:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8024d2:	e9 54 04 00 00       	jmp    80292b <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8024d7:	e8 d8 09 00 00       	call   802eb4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8024dc:	85 c0                	test   %eax,%eax
  8024de:	0f 84 88 01 00 00    	je     80266c <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  8024e4:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  8024eb:	10 00 00 
  8024ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8024f7:	01 d0                	add    %edx,%eax
  8024f9:	48                   	dec    %eax
  8024fa:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  802500:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  802506:	ba 00 00 00 00       	mov    $0x0,%edx
  80250b:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  802511:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  802517:	29 d0                	sub    %edx,%eax
  802519:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80251c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802520:	74 09                	je     80252b <malloc+0x5a0>
  802522:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802529:	76 0a                	jbe    802535 <malloc+0x5aa>
			return NULL;
  80252b:	b8 00 00 00 00       	mov    $0x0,%eax
  802530:	e9 f6 03 00 00       	jmp    80292b <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  802535:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  80253c:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  802543:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  80254a:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  802551:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	c1 e8 0c             	shr    $0xc,%eax
  80255e:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  802564:	eb 5a                	jmp    8025c0 <malloc+0x635>

			if (heap_mem[i] == 0) {
  802566:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802569:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	75 0c                	jne    802580 <malloc+0x5f5>

				count++;
  802574:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  802577:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  80257e:	eb 22                	jmp    8025a2 <malloc+0x617>
			} else {
				if (num_p <= count) {
  802580:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802586:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  802589:	77 09                	ja     802594 <malloc+0x609>

					found = 1;
  80258b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  802592:	eb 36                	jmp    8025ca <malloc+0x63f>
				}
				count = 0;
  802594:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  80259b:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  8025a2:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  8025a9:	75 12                	jne    8025bd <malloc+0x632>

				if (num_p <= count) {
  8025ab:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8025b1:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  8025b4:	77 07                	ja     8025bd <malloc+0x632>

					found = 1;
  8025b6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  8025bd:	ff 45 a4             	incl   -0x5c(%ebp)
  8025c0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025c3:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8025c8:	76 9c                	jbe    802566 <malloc+0x5db>

			}

		}

		if (!found) {
  8025ca:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  8025ce:	75 0a                	jne    8025da <malloc+0x64f>
			return NULL;
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d5:	e9 51 03 00 00       	jmp    80292b <malloc+0x9a0>

		}

		temp = ptr;
  8025da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  8025e0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025e3:	c1 e0 0c             	shl    $0xc,%eax
  8025e6:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  8025e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ec:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  8025f2:	83 ec 08             	sub    $0x8,%esp
  8025f5:	ff 75 08             	pushl  0x8(%ebp)
  8025f8:	ff 75 b0             	pushl  -0x50(%ebp)
  8025fb:	e8 c2 05 00 00       	call   802bc2 <sys_allocateMem>
  802600:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802603:	a1 20 40 80 00       	mov    0x804020,%eax
  802608:	8b 55 08             	mov    0x8(%ebp),%edx
  80260b:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  802612:	a1 20 40 80 00       	mov    0x804020,%eax
  802617:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80261a:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  802621:	a1 20 40 80 00       	mov    0x804020,%eax
  802626:	40                   	inc    %eax
  802627:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  80262c:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802633:	eb 24                	jmp    802659 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802635:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802638:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80263d:	c1 e8 0c             	shr    $0xc,%eax
  802640:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802647:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  80264b:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802652:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  802659:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80265c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265f:	72 d4                	jb     802635 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  802661:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  802667:	e9 bf 02 00 00       	jmp    80292b <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  80266c:	e8 d6 08 00 00       	call   802f47 <sys_isUHeapPlacementStrategyWORSTFIT>
  802671:	85 c0                	test   %eax,%eax
  802673:	0f 84 ba 01 00 00    	je     802833 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  802679:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  802680:	10 00 00 
  802683:	8b 55 08             	mov    0x8(%ebp),%edx
  802686:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80268c:	01 d0                	add    %edx,%eax
  80268e:	48                   	dec    %eax
  80268f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802695:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80269b:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a0:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  8026a6:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8026ac:	29 d0                	sub    %edx,%eax
  8026ae:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8026b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026b5:	74 09                	je     8026c0 <malloc+0x735>
  8026b7:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8026be:	76 0a                	jbe    8026ca <malloc+0x73f>
					return NULL;
  8026c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c5:	e9 61 02 00 00       	jmp    80292b <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  8026ca:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  8026d1:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  8026d8:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  8026df:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  8026e6:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	c1 e8 0c             	shr    $0xc,%eax
  8026f3:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8026f9:	e9 80 00 00 00       	jmp    80277e <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  8026fe:	8b 45 90             	mov    -0x70(%ebp),%eax
  802701:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	75 0c                	jne    802718 <malloc+0x78d>

						count++;
  80270c:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  80270f:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  802716:	eb 2d                	jmp    802745 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  802718:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80271e:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802721:	77 14                	ja     802737 <malloc+0x7ac>
  802723:	8b 45 98             	mov    -0x68(%ebp),%eax
  802726:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802729:	73 0c                	jae    802737 <malloc+0x7ac>

							max_sz = count;
  80272b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80272e:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802731:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802734:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  802737:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  80273e:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  802745:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  80274c:	75 2d                	jne    80277b <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  80274e:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802754:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802757:	77 22                	ja     80277b <malloc+0x7f0>
  802759:	8b 45 98             	mov    -0x68(%ebp),%eax
  80275c:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80275f:	76 1a                	jbe    80277b <malloc+0x7f0>

							max_sz = count;
  802761:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802764:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802767:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80276a:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  80276d:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  802774:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  80277b:	ff 45 90             	incl   -0x70(%ebp)
  80277e:	8b 45 90             	mov    -0x70(%ebp),%eax
  802781:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802786:	0f 86 72 ff ff ff    	jbe    8026fe <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  80278c:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802792:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802795:	77 06                	ja     80279d <malloc+0x812>
  802797:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80279b:	75 0a                	jne    8027a7 <malloc+0x81c>
					return NULL;
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a2:	e9 84 01 00 00       	jmp    80292b <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  8027a7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8027aa:	c1 e0 0c             	shl    $0xc,%eax
  8027ad:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  8027b0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8027b3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  8027b9:	83 ec 08             	sub    $0x8,%esp
  8027bc:	ff 75 08             	pushl  0x8(%ebp)
  8027bf:	ff 75 9c             	pushl  -0x64(%ebp)
  8027c2:	e8 fb 03 00 00       	call   802bc2 <sys_allocateMem>
  8027c7:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8027ca:	a1 20 40 80 00       	mov    0x804020,%eax
  8027cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d2:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  8027d9:	a1 20 40 80 00       	mov    0x804020,%eax
  8027de:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8027e1:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  8027e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8027ed:	40                   	inc    %eax
  8027ee:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  8027f3:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8027fa:	eb 24                	jmp    802820 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8027fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8027ff:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802804:	c1 e8 0c             	shr    $0xc,%eax
  802807:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  80280e:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802812:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802819:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802820:	8b 45 90             	mov    -0x70(%ebp),%eax
  802823:	3b 45 08             	cmp    0x8(%ebp),%eax
  802826:	72 d4                	jb     8027fc <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  802828:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80282e:	e9 f8 00 00 00       	jmp    80292b <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802833:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  80283a:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  802841:	10 00 00 
  802844:	8b 55 08             	mov    0x8(%ebp),%edx
  802847:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80284d:	01 d0                	add    %edx,%eax
  80284f:	48                   	dec    %eax
  802850:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802856:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80285c:	ba 00 00 00 00       	mov    $0x0,%edx
  802861:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802867:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80286d:	29 d0                	sub    %edx,%eax
  80286f:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802872:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802876:	74 09                	je     802881 <malloc+0x8f6>
  802878:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80287f:	76 0a                	jbe    80288b <malloc+0x900>
		return NULL;
  802881:	b8 00 00 00 00       	mov    $0x0,%eax
  802886:	e9 a0 00 00 00       	jmp    80292b <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  80288b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	01 d0                	add    %edx,%eax
  802896:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80289b:	0f 87 87 00 00 00    	ja     802928 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  8028a1:	a1 04 40 80 00       	mov    0x804004,%eax
  8028a6:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  8028a9:	a1 04 40 80 00       	mov    0x804004,%eax
  8028ae:	83 ec 08             	sub    $0x8,%esp
  8028b1:	ff 75 08             	pushl  0x8(%ebp)
  8028b4:	50                   	push   %eax
  8028b5:	e8 08 03 00 00       	call   802bc2 <sys_allocateMem>
  8028ba:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8028bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8028c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c5:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8028cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8028d1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8028d7:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8028de:	a1 20 40 80 00       	mov    0x804020,%eax
  8028e3:	40                   	inc    %eax
  8028e4:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  8028e9:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8028f0:	eb 2e                	jmp    802920 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8028f2:	a1 04 40 80 00       	mov    0x804004,%eax
  8028f7:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8028fc:	c1 e8 0c             	shr    $0xc,%eax
  8028ff:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802906:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  80290a:	a1 04 40 80 00       	mov    0x804004,%eax
  80290f:	05 00 10 00 00       	add    $0x1000,%eax
  802914:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  802919:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802920:	8b 45 88             	mov    -0x78(%ebp),%eax
  802923:	3b 45 08             	cmp    0x8(%ebp),%eax
  802926:	72 ca                	jb     8028f2 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  802928:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  80292b:	c9                   	leave  
  80292c:	c3                   	ret    

0080292d <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  80292d:	55                   	push   %ebp
  80292e:	89 e5                	mov    %esp,%ebp
  802930:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802933:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  80293a:	e9 c1 00 00 00       	jmp    802a00 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  802949:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294c:	0f 85 ab 00 00 00    	jne    8029fd <free+0xd0>

			if (heap_size[inx].size == 0) {
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	75 21                	jne    802981 <free+0x54>
				heap_size[inx].size = 0;
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  80296a:	00 00 00 00 
				heap_size[inx].vir = NULL;
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802978:	00 00 00 00 
				return;
  80297c:	e9 8d 00 00 00       	jmp    802a0e <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	83 ec 08             	sub    $0x8,%esp
  802991:	52                   	push   %edx
  802992:	50                   	push   %eax
  802993:	e8 0e 02 00 00       	call   802ba6 <sys_freeMem>
  802998:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  80299b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8029a8:	eb 24                	jmp    8029ce <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  8029aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ad:	05 00 00 00 80       	add    $0x80000000,%eax
  8029b2:	c1 e8 0c             	shr    $0xc,%eax
  8029b5:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  8029bc:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  8029c0:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8029c7:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	39 c2                	cmp    %eax,%edx
  8029dd:	77 cb                	ja     8029aa <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  8029e9:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  8029f7:	00 00 00 00 
			break;
  8029fb:	eb 11                	jmp    802a0e <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8029fd:	ff 45 f4             	incl   -0xc(%ebp)
  802a00:	a1 20 40 80 00       	mov    0x804020,%eax
  802a05:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802a08:	0f 8c 31 ff ff ff    	jl     80293f <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  802a0e:	c9                   	leave  
  802a0f:	c3                   	ret    

00802a10 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802a16:	83 ec 04             	sub    $0x4,%esp
  802a19:	68 b0 3a 80 00       	push   $0x803ab0
  802a1e:	68 1c 02 00 00       	push   $0x21c
  802a23:	68 d6 3a 80 00       	push   $0x803ad6
  802a28:	e8 b0 e6 ff ff       	call   8010dd <_panic>

00802a2d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802a2d:	55                   	push   %ebp
  802a2e:	89 e5                	mov    %esp,%ebp
  802a30:	57                   	push   %edi
  802a31:	56                   	push   %esi
  802a32:	53                   	push   %ebx
  802a33:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a42:	8b 7d 18             	mov    0x18(%ebp),%edi
  802a45:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802a48:	cd 30                	int    $0x30
  802a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802a50:	83 c4 10             	add    $0x10,%esp
  802a53:	5b                   	pop    %ebx
  802a54:	5e                   	pop    %esi
  802a55:	5f                   	pop    %edi
  802a56:	5d                   	pop    %ebp
  802a57:	c3                   	ret    

00802a58 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802a58:	55                   	push   %ebp
  802a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	ff 75 0c             	pushl  0xc(%ebp)
  802a67:	50                   	push   %eax
  802a68:	6a 00                	push   $0x0
  802a6a:	e8 be ff ff ff       	call   802a2d <syscall>
  802a6f:	83 c4 18             	add    $0x18,%esp
}
  802a72:	90                   	nop
  802a73:	c9                   	leave  
  802a74:	c3                   	ret    

00802a75 <sys_cgetc>:

int
sys_cgetc(void)
{
  802a75:	55                   	push   %ebp
  802a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	6a 00                	push   $0x0
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 00                	push   $0x0
  802a82:	6a 01                	push   $0x1
  802a84:	e8 a4 ff ff ff       	call   802a2d <syscall>
  802a89:	83 c4 18             	add    $0x18,%esp
}
  802a8c:	c9                   	leave  
  802a8d:	c3                   	ret    

00802a8e <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802a8e:	55                   	push   %ebp
  802a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	6a 00                	push   $0x0
  802a96:	6a 00                	push   $0x0
  802a98:	6a 00                	push   $0x0
  802a9a:	6a 00                	push   $0x0
  802a9c:	50                   	push   %eax
  802a9d:	6a 03                	push   $0x3
  802a9f:	e8 89 ff ff ff       	call   802a2d <syscall>
  802aa4:	83 c4 18             	add    $0x18,%esp
}
  802aa7:	c9                   	leave  
  802aa8:	c3                   	ret    

00802aa9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802aa9:	55                   	push   %ebp
  802aaa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 02                	push   $0x2
  802ab8:	e8 70 ff ff ff       	call   802a2d <syscall>
  802abd:	83 c4 18             	add    $0x18,%esp
}
  802ac0:	c9                   	leave  
  802ac1:	c3                   	ret    

00802ac2 <sys_env_exit>:

void sys_env_exit(void)
{
  802ac2:	55                   	push   %ebp
  802ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802ac5:	6a 00                	push   $0x0
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 04                	push   $0x4
  802ad1:	e8 57 ff ff ff       	call   802a2d <syscall>
  802ad6:	83 c4 18             	add    $0x18,%esp
}
  802ad9:	90                   	nop
  802ada:	c9                   	leave  
  802adb:	c3                   	ret    

00802adc <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802adc:	55                   	push   %ebp
  802add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 00                	push   $0x0
  802aeb:	52                   	push   %edx
  802aec:	50                   	push   %eax
  802aed:	6a 05                	push   $0x5
  802aef:	e8 39 ff ff ff       	call   802a2d <syscall>
  802af4:	83 c4 18             	add    $0x18,%esp
}
  802af7:	c9                   	leave  
  802af8:	c3                   	ret    

00802af9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802af9:	55                   	push   %ebp
  802afa:	89 e5                	mov    %esp,%ebp
  802afc:	56                   	push   %esi
  802afd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802afe:	8b 75 18             	mov    0x18(%ebp),%esi
  802b01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	56                   	push   %esi
  802b0e:	53                   	push   %ebx
  802b0f:	51                   	push   %ecx
  802b10:	52                   	push   %edx
  802b11:	50                   	push   %eax
  802b12:	6a 06                	push   $0x6
  802b14:	e8 14 ff ff ff       	call   802a2d <syscall>
  802b19:	83 c4 18             	add    $0x18,%esp
}
  802b1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b1f:	5b                   	pop    %ebx
  802b20:	5e                   	pop    %esi
  802b21:	5d                   	pop    %ebp
  802b22:	c3                   	ret    

00802b23 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	6a 00                	push   $0x0
  802b2e:	6a 00                	push   $0x0
  802b30:	6a 00                	push   $0x0
  802b32:	52                   	push   %edx
  802b33:	50                   	push   %eax
  802b34:	6a 07                	push   $0x7
  802b36:	e8 f2 fe ff ff       	call   802a2d <syscall>
  802b3b:	83 c4 18             	add    $0x18,%esp
}
  802b3e:	c9                   	leave  
  802b3f:	c3                   	ret    

00802b40 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	ff 75 0c             	pushl  0xc(%ebp)
  802b4c:	ff 75 08             	pushl  0x8(%ebp)
  802b4f:	6a 08                	push   $0x8
  802b51:	e8 d7 fe ff ff       	call   802a2d <syscall>
  802b56:	83 c4 18             	add    $0x18,%esp
}
  802b59:	c9                   	leave  
  802b5a:	c3                   	ret    

00802b5b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802b5b:	55                   	push   %ebp
  802b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	6a 00                	push   $0x0
  802b66:	6a 00                	push   $0x0
  802b68:	6a 09                	push   $0x9
  802b6a:	e8 be fe ff ff       	call   802a2d <syscall>
  802b6f:	83 c4 18             	add    $0x18,%esp
}
  802b72:	c9                   	leave  
  802b73:	c3                   	ret    

00802b74 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802b74:	55                   	push   %ebp
  802b75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802b77:	6a 00                	push   $0x0
  802b79:	6a 00                	push   $0x0
  802b7b:	6a 00                	push   $0x0
  802b7d:	6a 00                	push   $0x0
  802b7f:	6a 00                	push   $0x0
  802b81:	6a 0a                	push   $0xa
  802b83:	e8 a5 fe ff ff       	call   802a2d <syscall>
  802b88:	83 c4 18             	add    $0x18,%esp
}
  802b8b:	c9                   	leave  
  802b8c:	c3                   	ret    

00802b8d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802b8d:	55                   	push   %ebp
  802b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	6a 0b                	push   $0xb
  802b9c:	e8 8c fe ff ff       	call   802a2d <syscall>
  802ba1:	83 c4 18             	add    $0x18,%esp
}
  802ba4:	c9                   	leave  
  802ba5:	c3                   	ret    

00802ba6 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802ba6:	55                   	push   %ebp
  802ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802ba9:	6a 00                	push   $0x0
  802bab:	6a 00                	push   $0x0
  802bad:	6a 00                	push   $0x0
  802baf:	ff 75 0c             	pushl  0xc(%ebp)
  802bb2:	ff 75 08             	pushl  0x8(%ebp)
  802bb5:	6a 0d                	push   $0xd
  802bb7:	e8 71 fe ff ff       	call   802a2d <syscall>
  802bbc:	83 c4 18             	add    $0x18,%esp
	return;
  802bbf:	90                   	nop
}
  802bc0:	c9                   	leave  
  802bc1:	c3                   	ret    

00802bc2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802bc2:	55                   	push   %ebp
  802bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 00                	push   $0x0
  802bcb:	ff 75 0c             	pushl  0xc(%ebp)
  802bce:	ff 75 08             	pushl  0x8(%ebp)
  802bd1:	6a 0e                	push   $0xe
  802bd3:	e8 55 fe ff ff       	call   802a2d <syscall>
  802bd8:	83 c4 18             	add    $0x18,%esp
	return ;
  802bdb:	90                   	nop
}
  802bdc:	c9                   	leave  
  802bdd:	c3                   	ret    

00802bde <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802bde:	55                   	push   %ebp
  802bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	6a 00                	push   $0x0
  802be7:	6a 00                	push   $0x0
  802be9:	6a 00                	push   $0x0
  802beb:	6a 0c                	push   $0xc
  802bed:	e8 3b fe ff ff       	call   802a2d <syscall>
  802bf2:	83 c4 18             	add    $0x18,%esp
}
  802bf5:	c9                   	leave  
  802bf6:	c3                   	ret    

00802bf7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802bf7:	55                   	push   %ebp
  802bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 00                	push   $0x0
  802c02:	6a 00                	push   $0x0
  802c04:	6a 10                	push   $0x10
  802c06:	e8 22 fe ff ff       	call   802a2d <syscall>
  802c0b:	83 c4 18             	add    $0x18,%esp
}
  802c0e:	90                   	nop
  802c0f:	c9                   	leave  
  802c10:	c3                   	ret    

00802c11 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802c11:	55                   	push   %ebp
  802c12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 00                	push   $0x0
  802c1a:	6a 00                	push   $0x0
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 11                	push   $0x11
  802c20:	e8 08 fe ff ff       	call   802a2d <syscall>
  802c25:	83 c4 18             	add    $0x18,%esp
}
  802c28:	90                   	nop
  802c29:	c9                   	leave  
  802c2a:	c3                   	ret    

00802c2b <sys_cputc>:


void
sys_cputc(const char c)
{
  802c2b:	55                   	push   %ebp
  802c2c:	89 e5                	mov    %esp,%ebp
  802c2e:	83 ec 04             	sub    $0x4,%esp
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802c37:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c3b:	6a 00                	push   $0x0
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 00                	push   $0x0
  802c41:	6a 00                	push   $0x0
  802c43:	50                   	push   %eax
  802c44:	6a 12                	push   $0x12
  802c46:	e8 e2 fd ff ff       	call   802a2d <syscall>
  802c4b:	83 c4 18             	add    $0x18,%esp
}
  802c4e:	90                   	nop
  802c4f:	c9                   	leave  
  802c50:	c3                   	ret    

00802c51 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802c51:	55                   	push   %ebp
  802c52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802c54:	6a 00                	push   $0x0
  802c56:	6a 00                	push   $0x0
  802c58:	6a 00                	push   $0x0
  802c5a:	6a 00                	push   $0x0
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 13                	push   $0x13
  802c60:	e8 c8 fd ff ff       	call   802a2d <syscall>
  802c65:	83 c4 18             	add    $0x18,%esp
}
  802c68:	90                   	nop
  802c69:	c9                   	leave  
  802c6a:	c3                   	ret    

00802c6b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802c6b:	55                   	push   %ebp
  802c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	6a 00                	push   $0x0
  802c73:	6a 00                	push   $0x0
  802c75:	6a 00                	push   $0x0
  802c77:	ff 75 0c             	pushl  0xc(%ebp)
  802c7a:	50                   	push   %eax
  802c7b:	6a 14                	push   $0x14
  802c7d:	e8 ab fd ff ff       	call   802a2d <syscall>
  802c82:	83 c4 18             	add    $0x18,%esp
}
  802c85:	c9                   	leave  
  802c86:	c3                   	ret    

00802c87 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802c87:	55                   	push   %ebp
  802c88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	6a 00                	push   $0x0
  802c8f:	6a 00                	push   $0x0
  802c91:	6a 00                	push   $0x0
  802c93:	6a 00                	push   $0x0
  802c95:	50                   	push   %eax
  802c96:	6a 17                	push   $0x17
  802c98:	e8 90 fd ff ff       	call   802a2d <syscall>
  802c9d:	83 c4 18             	add    $0x18,%esp
}
  802ca0:	c9                   	leave  
  802ca1:	c3                   	ret    

00802ca2 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802ca2:	55                   	push   %ebp
  802ca3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	6a 00                	push   $0x0
  802caa:	6a 00                	push   $0x0
  802cac:	6a 00                	push   $0x0
  802cae:	6a 00                	push   $0x0
  802cb0:	50                   	push   %eax
  802cb1:	6a 15                	push   $0x15
  802cb3:	e8 75 fd ff ff       	call   802a2d <syscall>
  802cb8:	83 c4 18             	add    $0x18,%esp
}
  802cbb:	90                   	nop
  802cbc:	c9                   	leave  
  802cbd:	c3                   	ret    

00802cbe <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802cbe:	55                   	push   %ebp
  802cbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	6a 00                	push   $0x0
  802cc6:	6a 00                	push   $0x0
  802cc8:	6a 00                	push   $0x0
  802cca:	6a 00                	push   $0x0
  802ccc:	50                   	push   %eax
  802ccd:	6a 16                	push   $0x16
  802ccf:	e8 59 fd ff ff       	call   802a2d <syscall>
  802cd4:	83 c4 18             	add    $0x18,%esp
}
  802cd7:	90                   	nop
  802cd8:	c9                   	leave  
  802cd9:	c3                   	ret    

00802cda <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802cda:	55                   	push   %ebp
  802cdb:	89 e5                	mov    %esp,%ebp
  802cdd:	83 ec 04             	sub    $0x4,%esp
  802ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ce3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802ce6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ce9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	6a 00                	push   $0x0
  802cf2:	51                   	push   %ecx
  802cf3:	52                   	push   %edx
  802cf4:	ff 75 0c             	pushl  0xc(%ebp)
  802cf7:	50                   	push   %eax
  802cf8:	6a 18                	push   $0x18
  802cfa:	e8 2e fd ff ff       	call   802a2d <syscall>
  802cff:	83 c4 18             	add    $0x18,%esp
}
  802d02:	c9                   	leave  
  802d03:	c3                   	ret    

00802d04 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802d04:	55                   	push   %ebp
  802d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	6a 00                	push   $0x0
  802d0f:	6a 00                	push   $0x0
  802d11:	6a 00                	push   $0x0
  802d13:	52                   	push   %edx
  802d14:	50                   	push   %eax
  802d15:	6a 19                	push   $0x19
  802d17:	e8 11 fd ff ff       	call   802a2d <syscall>
  802d1c:	83 c4 18             	add    $0x18,%esp
}
  802d1f:	c9                   	leave  
  802d20:	c3                   	ret    

00802d21 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802d21:	55                   	push   %ebp
  802d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	6a 00                	push   $0x0
  802d29:	6a 00                	push   $0x0
  802d2b:	6a 00                	push   $0x0
  802d2d:	6a 00                	push   $0x0
  802d2f:	50                   	push   %eax
  802d30:	6a 1a                	push   $0x1a
  802d32:	e8 f6 fc ff ff       	call   802a2d <syscall>
  802d37:	83 c4 18             	add    $0x18,%esp
}
  802d3a:	c9                   	leave  
  802d3b:	c3                   	ret    

00802d3c <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802d3c:	55                   	push   %ebp
  802d3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  802d3f:	6a 00                	push   $0x0
  802d41:	6a 00                	push   $0x0
  802d43:	6a 00                	push   $0x0
  802d45:	6a 00                	push   $0x0
  802d47:	6a 00                	push   $0x0
  802d49:	6a 1b                	push   $0x1b
  802d4b:	e8 dd fc ff ff       	call   802a2d <syscall>
  802d50:	83 c4 18             	add    $0x18,%esp
}
  802d53:	c9                   	leave  
  802d54:	c3                   	ret    

00802d55 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802d55:	55                   	push   %ebp
  802d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802d58:	6a 00                	push   $0x0
  802d5a:	6a 00                	push   $0x0
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 1c                	push   $0x1c
  802d64:	e8 c4 fc ff ff       	call   802a2d <syscall>
  802d69:	83 c4 18             	add    $0x18,%esp
}
  802d6c:	c9                   	leave  
  802d6d:	c3                   	ret    

00802d6e <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802d6e:	55                   	push   %ebp
  802d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	6a 00                	push   $0x0
  802d76:	6a 00                	push   $0x0
  802d78:	6a 00                	push   $0x0
  802d7a:	ff 75 0c             	pushl  0xc(%ebp)
  802d7d:	50                   	push   %eax
  802d7e:	6a 1d                	push   $0x1d
  802d80:	e8 a8 fc ff ff       	call   802a2d <syscall>
  802d85:	83 c4 18             	add    $0x18,%esp
}
  802d88:	c9                   	leave  
  802d89:	c3                   	ret    

00802d8a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 00                	push   $0x0
  802d96:	6a 00                	push   $0x0
  802d98:	50                   	push   %eax
  802d99:	6a 1e                	push   $0x1e
  802d9b:	e8 8d fc ff ff       	call   802a2d <syscall>
  802da0:	83 c4 18             	add    $0x18,%esp
}
  802da3:	90                   	nop
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    

00802da6 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	6a 00                	push   $0x0
  802dae:	6a 00                	push   $0x0
  802db0:	6a 00                	push   $0x0
  802db2:	6a 00                	push   $0x0
  802db4:	50                   	push   %eax
  802db5:	6a 1f                	push   $0x1f
  802db7:	e8 71 fc ff ff       	call   802a2d <syscall>
  802dbc:	83 c4 18             	add    $0x18,%esp
}
  802dbf:	90                   	nop
  802dc0:	c9                   	leave  
  802dc1:	c3                   	ret    

00802dc2 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
  802dc5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802dc8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dcb:	8d 50 04             	lea    0x4(%eax),%edx
  802dce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dd1:	6a 00                	push   $0x0
  802dd3:	6a 00                	push   $0x0
  802dd5:	6a 00                	push   $0x0
  802dd7:	52                   	push   %edx
  802dd8:	50                   	push   %eax
  802dd9:	6a 20                	push   $0x20
  802ddb:	e8 4d fc ff ff       	call   802a2d <syscall>
  802de0:	83 c4 18             	add    $0x18,%esp
	return result;
  802de3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802de6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802de9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802dec:	89 01                	mov    %eax,(%ecx)
  802dee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	c9                   	leave  
  802df5:	c2 04 00             	ret    $0x4

00802df8 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802df8:	55                   	push   %ebp
  802df9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802dfb:	6a 00                	push   $0x0
  802dfd:	6a 00                	push   $0x0
  802dff:	ff 75 10             	pushl  0x10(%ebp)
  802e02:	ff 75 0c             	pushl  0xc(%ebp)
  802e05:	ff 75 08             	pushl  0x8(%ebp)
  802e08:	6a 0f                	push   $0xf
  802e0a:	e8 1e fc ff ff       	call   802a2d <syscall>
  802e0f:	83 c4 18             	add    $0x18,%esp
	return ;
  802e12:	90                   	nop
}
  802e13:	c9                   	leave  
  802e14:	c3                   	ret    

00802e15 <sys_rcr2>:
uint32 sys_rcr2()
{
  802e15:	55                   	push   %ebp
  802e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	6a 00                	push   $0x0
  802e1e:	6a 00                	push   $0x0
  802e20:	6a 00                	push   $0x0
  802e22:	6a 21                	push   $0x21
  802e24:	e8 04 fc ff ff       	call   802a2d <syscall>
  802e29:	83 c4 18             	add    $0x18,%esp
}
  802e2c:	c9                   	leave  
  802e2d:	c3                   	ret    

00802e2e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802e2e:	55                   	push   %ebp
  802e2f:	89 e5                	mov    %esp,%ebp
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e3a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e3e:	6a 00                	push   $0x0
  802e40:	6a 00                	push   $0x0
  802e42:	6a 00                	push   $0x0
  802e44:	6a 00                	push   $0x0
  802e46:	50                   	push   %eax
  802e47:	6a 22                	push   $0x22
  802e49:	e8 df fb ff ff       	call   802a2d <syscall>
  802e4e:	83 c4 18             	add    $0x18,%esp
	return ;
  802e51:	90                   	nop
}
  802e52:	c9                   	leave  
  802e53:	c3                   	ret    

00802e54 <rsttst>:
void rsttst()
{
  802e54:	55                   	push   %ebp
  802e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 24                	push   $0x24
  802e63:	e8 c5 fb ff ff       	call   802a2d <syscall>
  802e68:	83 c4 18             	add    $0x18,%esp
	return ;
  802e6b:	90                   	nop
}
  802e6c:	c9                   	leave  
  802e6d:	c3                   	ret    

00802e6e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e6e:	55                   	push   %ebp
  802e6f:	89 e5                	mov    %esp,%ebp
  802e71:	83 ec 04             	sub    $0x4,%esp
  802e74:	8b 45 14             	mov    0x14(%ebp),%eax
  802e77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e7a:	8b 55 18             	mov    0x18(%ebp),%edx
  802e7d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e81:	52                   	push   %edx
  802e82:	50                   	push   %eax
  802e83:	ff 75 10             	pushl  0x10(%ebp)
  802e86:	ff 75 0c             	pushl  0xc(%ebp)
  802e89:	ff 75 08             	pushl  0x8(%ebp)
  802e8c:	6a 23                	push   $0x23
  802e8e:	e8 9a fb ff ff       	call   802a2d <syscall>
  802e93:	83 c4 18             	add    $0x18,%esp
	return ;
  802e96:	90                   	nop
}
  802e97:	c9                   	leave  
  802e98:	c3                   	ret    

00802e99 <chktst>:
void chktst(uint32 n)
{
  802e99:	55                   	push   %ebp
  802e9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	ff 75 08             	pushl  0x8(%ebp)
  802ea7:	6a 25                	push   $0x25
  802ea9:	e8 7f fb ff ff       	call   802a2d <syscall>
  802eae:	83 c4 18             	add    $0x18,%esp
	return ;
  802eb1:	90                   	nop
}
  802eb2:	c9                   	leave  
  802eb3:	c3                   	ret    

00802eb4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802eb4:	55                   	push   %ebp
  802eb5:	89 e5                	mov    %esp,%ebp
  802eb7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 00                	push   $0x0
  802ec0:	6a 00                	push   $0x0
  802ec2:	6a 00                	push   $0x0
  802ec4:	6a 26                	push   $0x26
  802ec6:	e8 62 fb ff ff       	call   802a2d <syscall>
  802ecb:	83 c4 18             	add    $0x18,%esp
  802ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ed1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802ed5:	75 07                	jne    802ede <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802ed7:	b8 01 00 00 00       	mov    $0x1,%eax
  802edc:	eb 05                	jmp    802ee3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802ede:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee3:	c9                   	leave  
  802ee4:	c3                   	ret    

00802ee5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802ee5:	55                   	push   %ebp
  802ee6:	89 e5                	mov    %esp,%ebp
  802ee8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 00                	push   $0x0
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 00                	push   $0x0
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 26                	push   $0x26
  802ef7:	e8 31 fb ff ff       	call   802a2d <syscall>
  802efc:	83 c4 18             	add    $0x18,%esp
  802eff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802f02:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802f06:	75 07                	jne    802f0f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802f08:	b8 01 00 00 00       	mov    $0x1,%eax
  802f0d:	eb 05                	jmp    802f14 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802f0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f14:	c9                   	leave  
  802f15:	c3                   	ret    

00802f16 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f16:	55                   	push   %ebp
  802f17:	89 e5                	mov    %esp,%ebp
  802f19:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f1c:	6a 00                	push   $0x0
  802f1e:	6a 00                	push   $0x0
  802f20:	6a 00                	push   $0x0
  802f22:	6a 00                	push   $0x0
  802f24:	6a 00                	push   $0x0
  802f26:	6a 26                	push   $0x26
  802f28:	e8 00 fb ff ff       	call   802a2d <syscall>
  802f2d:	83 c4 18             	add    $0x18,%esp
  802f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802f33:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802f37:	75 07                	jne    802f40 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802f39:	b8 01 00 00 00       	mov    $0x1,%eax
  802f3e:	eb 05                	jmp    802f45 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f45:	c9                   	leave  
  802f46:	c3                   	ret    

00802f47 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802f47:	55                   	push   %ebp
  802f48:	89 e5                	mov    %esp,%ebp
  802f4a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f4d:	6a 00                	push   $0x0
  802f4f:	6a 00                	push   $0x0
  802f51:	6a 00                	push   $0x0
  802f53:	6a 00                	push   $0x0
  802f55:	6a 00                	push   $0x0
  802f57:	6a 26                	push   $0x26
  802f59:	e8 cf fa ff ff       	call   802a2d <syscall>
  802f5e:	83 c4 18             	add    $0x18,%esp
  802f61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802f64:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802f68:	75 07                	jne    802f71 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f6f:	eb 05                	jmp    802f76 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f76:	c9                   	leave  
  802f77:	c3                   	ret    

00802f78 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f78:	55                   	push   %ebp
  802f79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f7b:	6a 00                	push   $0x0
  802f7d:	6a 00                	push   $0x0
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	ff 75 08             	pushl  0x8(%ebp)
  802f86:	6a 27                	push   $0x27
  802f88:	e8 a0 fa ff ff       	call   802a2d <syscall>
  802f8d:	83 c4 18             	add    $0x18,%esp
	return ;
  802f90:	90                   	nop
}
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    
  802f93:	90                   	nop

00802f94 <__udivdi3>:
  802f94:	55                   	push   %ebp
  802f95:	57                   	push   %edi
  802f96:	56                   	push   %esi
  802f97:	53                   	push   %ebx
  802f98:	83 ec 1c             	sub    $0x1c,%esp
  802f9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fa7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fab:	89 ca                	mov    %ecx,%edx
  802fad:	89 f8                	mov    %edi,%eax
  802faf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802fb3:	85 f6                	test   %esi,%esi
  802fb5:	75 2d                	jne    802fe4 <__udivdi3+0x50>
  802fb7:	39 cf                	cmp    %ecx,%edi
  802fb9:	77 65                	ja     803020 <__udivdi3+0x8c>
  802fbb:	89 fd                	mov    %edi,%ebp
  802fbd:	85 ff                	test   %edi,%edi
  802fbf:	75 0b                	jne    802fcc <__udivdi3+0x38>
  802fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  802fc6:	31 d2                	xor    %edx,%edx
  802fc8:	f7 f7                	div    %edi
  802fca:	89 c5                	mov    %eax,%ebp
  802fcc:	31 d2                	xor    %edx,%edx
  802fce:	89 c8                	mov    %ecx,%eax
  802fd0:	f7 f5                	div    %ebp
  802fd2:	89 c1                	mov    %eax,%ecx
  802fd4:	89 d8                	mov    %ebx,%eax
  802fd6:	f7 f5                	div    %ebp
  802fd8:	89 cf                	mov    %ecx,%edi
  802fda:	89 fa                	mov    %edi,%edx
  802fdc:	83 c4 1c             	add    $0x1c,%esp
  802fdf:	5b                   	pop    %ebx
  802fe0:	5e                   	pop    %esi
  802fe1:	5f                   	pop    %edi
  802fe2:	5d                   	pop    %ebp
  802fe3:	c3                   	ret    
  802fe4:	39 ce                	cmp    %ecx,%esi
  802fe6:	77 28                	ja     803010 <__udivdi3+0x7c>
  802fe8:	0f bd fe             	bsr    %esi,%edi
  802feb:	83 f7 1f             	xor    $0x1f,%edi
  802fee:	75 40                	jne    803030 <__udivdi3+0x9c>
  802ff0:	39 ce                	cmp    %ecx,%esi
  802ff2:	72 0a                	jb     802ffe <__udivdi3+0x6a>
  802ff4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ff8:	0f 87 9e 00 00 00    	ja     80309c <__udivdi3+0x108>
  802ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  803003:	89 fa                	mov    %edi,%edx
  803005:	83 c4 1c             	add    $0x1c,%esp
  803008:	5b                   	pop    %ebx
  803009:	5e                   	pop    %esi
  80300a:	5f                   	pop    %edi
  80300b:	5d                   	pop    %ebp
  80300c:	c3                   	ret    
  80300d:	8d 76 00             	lea    0x0(%esi),%esi
  803010:	31 ff                	xor    %edi,%edi
  803012:	31 c0                	xor    %eax,%eax
  803014:	89 fa                	mov    %edi,%edx
  803016:	83 c4 1c             	add    $0x1c,%esp
  803019:	5b                   	pop    %ebx
  80301a:	5e                   	pop    %esi
  80301b:	5f                   	pop    %edi
  80301c:	5d                   	pop    %ebp
  80301d:	c3                   	ret    
  80301e:	66 90                	xchg   %ax,%ax
  803020:	89 d8                	mov    %ebx,%eax
  803022:	f7 f7                	div    %edi
  803024:	31 ff                	xor    %edi,%edi
  803026:	89 fa                	mov    %edi,%edx
  803028:	83 c4 1c             	add    $0x1c,%esp
  80302b:	5b                   	pop    %ebx
  80302c:	5e                   	pop    %esi
  80302d:	5f                   	pop    %edi
  80302e:	5d                   	pop    %ebp
  80302f:	c3                   	ret    
  803030:	bd 20 00 00 00       	mov    $0x20,%ebp
  803035:	89 eb                	mov    %ebp,%ebx
  803037:	29 fb                	sub    %edi,%ebx
  803039:	89 f9                	mov    %edi,%ecx
  80303b:	d3 e6                	shl    %cl,%esi
  80303d:	89 c5                	mov    %eax,%ebp
  80303f:	88 d9                	mov    %bl,%cl
  803041:	d3 ed                	shr    %cl,%ebp
  803043:	89 e9                	mov    %ebp,%ecx
  803045:	09 f1                	or     %esi,%ecx
  803047:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80304b:	89 f9                	mov    %edi,%ecx
  80304d:	d3 e0                	shl    %cl,%eax
  80304f:	89 c5                	mov    %eax,%ebp
  803051:	89 d6                	mov    %edx,%esi
  803053:	88 d9                	mov    %bl,%cl
  803055:	d3 ee                	shr    %cl,%esi
  803057:	89 f9                	mov    %edi,%ecx
  803059:	d3 e2                	shl    %cl,%edx
  80305b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80305f:	88 d9                	mov    %bl,%cl
  803061:	d3 e8                	shr    %cl,%eax
  803063:	09 c2                	or     %eax,%edx
  803065:	89 d0                	mov    %edx,%eax
  803067:	89 f2                	mov    %esi,%edx
  803069:	f7 74 24 0c          	divl   0xc(%esp)
  80306d:	89 d6                	mov    %edx,%esi
  80306f:	89 c3                	mov    %eax,%ebx
  803071:	f7 e5                	mul    %ebp
  803073:	39 d6                	cmp    %edx,%esi
  803075:	72 19                	jb     803090 <__udivdi3+0xfc>
  803077:	74 0b                	je     803084 <__udivdi3+0xf0>
  803079:	89 d8                	mov    %ebx,%eax
  80307b:	31 ff                	xor    %edi,%edi
  80307d:	e9 58 ff ff ff       	jmp    802fda <__udivdi3+0x46>
  803082:	66 90                	xchg   %ax,%ax
  803084:	8b 54 24 08          	mov    0x8(%esp),%edx
  803088:	89 f9                	mov    %edi,%ecx
  80308a:	d3 e2                	shl    %cl,%edx
  80308c:	39 c2                	cmp    %eax,%edx
  80308e:	73 e9                	jae    803079 <__udivdi3+0xe5>
  803090:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803093:	31 ff                	xor    %edi,%edi
  803095:	e9 40 ff ff ff       	jmp    802fda <__udivdi3+0x46>
  80309a:	66 90                	xchg   %ax,%ax
  80309c:	31 c0                	xor    %eax,%eax
  80309e:	e9 37 ff ff ff       	jmp    802fda <__udivdi3+0x46>
  8030a3:	90                   	nop

008030a4 <__umoddi3>:
  8030a4:	55                   	push   %ebp
  8030a5:	57                   	push   %edi
  8030a6:	56                   	push   %esi
  8030a7:	53                   	push   %ebx
  8030a8:	83 ec 1c             	sub    $0x1c,%esp
  8030ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030c3:	89 f3                	mov    %esi,%ebx
  8030c5:	89 fa                	mov    %edi,%edx
  8030c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030cb:	89 34 24             	mov    %esi,(%esp)
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	75 1a                	jne    8030ec <__umoddi3+0x48>
  8030d2:	39 f7                	cmp    %esi,%edi
  8030d4:	0f 86 a2 00 00 00    	jbe    80317c <__umoddi3+0xd8>
  8030da:	89 c8                	mov    %ecx,%eax
  8030dc:	89 f2                	mov    %esi,%edx
  8030de:	f7 f7                	div    %edi
  8030e0:	89 d0                	mov    %edx,%eax
  8030e2:	31 d2                	xor    %edx,%edx
  8030e4:	83 c4 1c             	add    $0x1c,%esp
  8030e7:	5b                   	pop    %ebx
  8030e8:	5e                   	pop    %esi
  8030e9:	5f                   	pop    %edi
  8030ea:	5d                   	pop    %ebp
  8030eb:	c3                   	ret    
  8030ec:	39 f0                	cmp    %esi,%eax
  8030ee:	0f 87 ac 00 00 00    	ja     8031a0 <__umoddi3+0xfc>
  8030f4:	0f bd e8             	bsr    %eax,%ebp
  8030f7:	83 f5 1f             	xor    $0x1f,%ebp
  8030fa:	0f 84 ac 00 00 00    	je     8031ac <__umoddi3+0x108>
  803100:	bf 20 00 00 00       	mov    $0x20,%edi
  803105:	29 ef                	sub    %ebp,%edi
  803107:	89 fe                	mov    %edi,%esi
  803109:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80310d:	89 e9                	mov    %ebp,%ecx
  80310f:	d3 e0                	shl    %cl,%eax
  803111:	89 d7                	mov    %edx,%edi
  803113:	89 f1                	mov    %esi,%ecx
  803115:	d3 ef                	shr    %cl,%edi
  803117:	09 c7                	or     %eax,%edi
  803119:	89 e9                	mov    %ebp,%ecx
  80311b:	d3 e2                	shl    %cl,%edx
  80311d:	89 14 24             	mov    %edx,(%esp)
  803120:	89 d8                	mov    %ebx,%eax
  803122:	d3 e0                	shl    %cl,%eax
  803124:	89 c2                	mov    %eax,%edx
  803126:	8b 44 24 08          	mov    0x8(%esp),%eax
  80312a:	d3 e0                	shl    %cl,%eax
  80312c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803130:	8b 44 24 08          	mov    0x8(%esp),%eax
  803134:	89 f1                	mov    %esi,%ecx
  803136:	d3 e8                	shr    %cl,%eax
  803138:	09 d0                	or     %edx,%eax
  80313a:	d3 eb                	shr    %cl,%ebx
  80313c:	89 da                	mov    %ebx,%edx
  80313e:	f7 f7                	div    %edi
  803140:	89 d3                	mov    %edx,%ebx
  803142:	f7 24 24             	mull   (%esp)
  803145:	89 c6                	mov    %eax,%esi
  803147:	89 d1                	mov    %edx,%ecx
  803149:	39 d3                	cmp    %edx,%ebx
  80314b:	0f 82 87 00 00 00    	jb     8031d8 <__umoddi3+0x134>
  803151:	0f 84 91 00 00 00    	je     8031e8 <__umoddi3+0x144>
  803157:	8b 54 24 04          	mov    0x4(%esp),%edx
  80315b:	29 f2                	sub    %esi,%edx
  80315d:	19 cb                	sbb    %ecx,%ebx
  80315f:	89 d8                	mov    %ebx,%eax
  803161:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803165:	d3 e0                	shl    %cl,%eax
  803167:	89 e9                	mov    %ebp,%ecx
  803169:	d3 ea                	shr    %cl,%edx
  80316b:	09 d0                	or     %edx,%eax
  80316d:	89 e9                	mov    %ebp,%ecx
  80316f:	d3 eb                	shr    %cl,%ebx
  803171:	89 da                	mov    %ebx,%edx
  803173:	83 c4 1c             	add    $0x1c,%esp
  803176:	5b                   	pop    %ebx
  803177:	5e                   	pop    %esi
  803178:	5f                   	pop    %edi
  803179:	5d                   	pop    %ebp
  80317a:	c3                   	ret    
  80317b:	90                   	nop
  80317c:	89 fd                	mov    %edi,%ebp
  80317e:	85 ff                	test   %edi,%edi
  803180:	75 0b                	jne    80318d <__umoddi3+0xe9>
  803182:	b8 01 00 00 00       	mov    $0x1,%eax
  803187:	31 d2                	xor    %edx,%edx
  803189:	f7 f7                	div    %edi
  80318b:	89 c5                	mov    %eax,%ebp
  80318d:	89 f0                	mov    %esi,%eax
  80318f:	31 d2                	xor    %edx,%edx
  803191:	f7 f5                	div    %ebp
  803193:	89 c8                	mov    %ecx,%eax
  803195:	f7 f5                	div    %ebp
  803197:	89 d0                	mov    %edx,%eax
  803199:	e9 44 ff ff ff       	jmp    8030e2 <__umoddi3+0x3e>
  80319e:	66 90                	xchg   %ax,%ax
  8031a0:	89 c8                	mov    %ecx,%eax
  8031a2:	89 f2                	mov    %esi,%edx
  8031a4:	83 c4 1c             	add    $0x1c,%esp
  8031a7:	5b                   	pop    %ebx
  8031a8:	5e                   	pop    %esi
  8031a9:	5f                   	pop    %edi
  8031aa:	5d                   	pop    %ebp
  8031ab:	c3                   	ret    
  8031ac:	3b 04 24             	cmp    (%esp),%eax
  8031af:	72 06                	jb     8031b7 <__umoddi3+0x113>
  8031b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031b5:	77 0f                	ja     8031c6 <__umoddi3+0x122>
  8031b7:	89 f2                	mov    %esi,%edx
  8031b9:	29 f9                	sub    %edi,%ecx
  8031bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031bf:	89 14 24             	mov    %edx,(%esp)
  8031c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031ca:	8b 14 24             	mov    (%esp),%edx
  8031cd:	83 c4 1c             	add    $0x1c,%esp
  8031d0:	5b                   	pop    %ebx
  8031d1:	5e                   	pop    %esi
  8031d2:	5f                   	pop    %edi
  8031d3:	5d                   	pop    %ebp
  8031d4:	c3                   	ret    
  8031d5:	8d 76 00             	lea    0x0(%esi),%esi
  8031d8:	2b 04 24             	sub    (%esp),%eax
  8031db:	19 fa                	sbb    %edi,%edx
  8031dd:	89 d1                	mov    %edx,%ecx
  8031df:	89 c6                	mov    %eax,%esi
  8031e1:	e9 71 ff ff ff       	jmp    803157 <__umoddi3+0xb3>
  8031e6:	66 90                	xchg   %ax,%ax
  8031e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031ec:	72 ea                	jb     8031d8 <__umoddi3+0x134>
  8031ee:	89 d9                	mov    %ebx,%ecx
  8031f0:	e9 62 ff ff ff       	jmp    803157 <__umoddi3+0xb3>
