
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 40 12 00 00       	call   801276 <libmain>
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
  800043:	e8 bb 2c 00 00       	call   802d03 <sys_getenvid>
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
  80007b:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  800081:	b9 14 00 00 00       	mov    $0x14,%ecx
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	89 d7                	mov    %edx,%edi
  80008d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80008f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int requiredNumOfEmptyWSLocs = 1050;
  800096:	c7 45 d4 1a 04 00 00 	movl   $0x41a,-0x2c(%ebp)
	int numOfEmptyWSLocs = 0;
  80009d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
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
	int freeFrames ;
	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 1050;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
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
  8000e9:	68 60 34 80 00       	push   $0x803460
  8000ee:	6a 1b                	push   $0x1b
  8000f0:	68 b0 34 80 00       	push   $0x8034b0
  8000f5:	e8 3d 12 00 00       	call   801337 <_panic>

	cprintf("This test has FIVE cases. A pass message will be displayed after each one.\n");
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	68 c8 34 80 00       	push   $0x8034c8
  800102:	e8 5b 13 00 00       	call   801462 <cprintf>
  800107:	83 c4 10             	add    $0x10,%esp

	int usedDiskPages;

	//[1] Allocate all
	{
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80010a:	e8 29 2d 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  80010f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800112:	e8 9e 2c 00 00       	call   802db5 <sys_calculate_free_frames>
  800117:	89 45 cc             	mov    %eax,-0x34(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80011a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80011d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 bc 20 00 00       	call   8021e5 <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800132:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800138:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 14 35 80 00       	push   $0x803514
  800147:	6a 28                	push   $0x28
  800149:	68 b0 34 80 00       	push   $0x8034b0
  80014e:	e8 e4 11 00 00       	call   801337 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800156:	e8 5a 2c 00 00       	call   802db5 <sys_calculate_free_frames>
  80015b:	29 c3                	sub    %eax,%ebx
  80015d:	89 d8                	mov    %ebx,%eax
  80015f:	83 f8 01             	cmp    $0x1,%eax
  800162:	74 14                	je     800178 <_main+0x140>
  800164:	83 ec 04             	sub    $0x4,%esp
  800167:	68 44 35 80 00       	push   $0x803544
  80016c:	6a 2a                	push   $0x2a
  80016e:	68 b0 34 80 00       	push   $0x8034b0
  800173:	e8 bf 11 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800178:	e8 bb 2c 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  80017d:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800180:	3d 00 01 00 00       	cmp    $0x100,%eax
  800185:	74 14                	je     80019b <_main+0x163>
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	68 b0 35 80 00       	push   $0x8035b0
  80018f:	6a 2b                	push   $0x2b
  800191:	68 b0 34 80 00       	push   $0x8034b0
  800196:	e8 9c 11 00 00       	call   801337 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80019b:	e8 15 2c 00 00       	call   802db5 <sys_calculate_free_frames>
  8001a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001a3:	e8 90 2c 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8001a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  8001ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ae:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	50                   	push   %eax
  8001b5:	e8 2b 20 00 00       	call   8021e5 <malloc>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8001c3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001c9:	89 c2                	mov    %eax,%edx
  8001cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ce:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d3:	39 c2                	cmp    %eax,%edx
  8001d5:	74 14                	je     8001eb <_main+0x1b3>
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	68 14 35 80 00       	push   $0x803514
  8001df:	6a 31                	push   $0x31
  8001e1:	68 b0 34 80 00       	push   $0x8034b0
  8001e6:	e8 4c 11 00 00       	call   801337 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001eb:	e8 c5 2b 00 00       	call   802db5 <sys_calculate_free_frames>
  8001f0:	89 c2                	mov    %eax,%edx
  8001f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001f5:	39 c2                	cmp    %eax,%edx
  8001f7:	74 14                	je     80020d <_main+0x1d5>
  8001f9:	83 ec 04             	sub    $0x4,%esp
  8001fc:	68 44 35 80 00       	push   $0x803544
  800201:	6a 33                	push   $0x33
  800203:	68 b0 34 80 00       	push   $0x8034b0
  800208:	e8 2a 11 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80020d:	e8 26 2c 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800212:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800215:	3d 00 01 00 00       	cmp    $0x100,%eax
  80021a:	74 14                	je     800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 b0 35 80 00       	push   $0x8035b0
  800224:	6a 34                	push   $0x34
  800226:	68 b0 34 80 00       	push   $0x8034b0
  80022b:	e8 07 11 00 00       	call   801337 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800230:	e8 80 2b 00 00       	call   802db5 <sys_calculate_free_frames>
  800235:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800238:	e8 fb 2b 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  80023d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800240:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800243:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	50                   	push   %eax
  80024a:	e8 96 1f 00 00       	call   8021e5 <malloc>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800258:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80025e:	89 c2                	mov    %eax,%edx
  800260:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800263:	01 c0                	add    %eax,%eax
  800265:	05 00 00 00 80       	add    $0x80000000,%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 14 35 80 00       	push   $0x803514
  800276:	6a 3a                	push   $0x3a
  800278:	68 b0 34 80 00       	push   $0x8034b0
  80027d:	e8 b5 10 00 00       	call   801337 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800282:	e8 2e 2b 00 00       	call   802db5 <sys_calculate_free_frames>
  800287:	89 c2                	mov    %eax,%edx
  800289:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80028c:	39 c2                	cmp    %eax,%edx
  80028e:	74 14                	je     8002a4 <_main+0x26c>
  800290:	83 ec 04             	sub    $0x4,%esp
  800293:	68 44 35 80 00       	push   $0x803544
  800298:	6a 3c                	push   $0x3c
  80029a:	68 b0 34 80 00       	push   $0x8034b0
  80029f:	e8 93 10 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8002a4:	e8 8f 2b 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8002a9:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002ac:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002b1:	74 14                	je     8002c7 <_main+0x28f>
  8002b3:	83 ec 04             	sub    $0x4,%esp
  8002b6:	68 b0 35 80 00       	push   $0x8035b0
  8002bb:	6a 3d                	push   $0x3d
  8002bd:	68 b0 34 80 00       	push   $0x8034b0
  8002c2:	e8 70 10 00 00       	call   801337 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8002c7:	e8 e9 2a 00 00       	call   802db5 <sys_calculate_free_frames>
  8002cc:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cf:	e8 64 2b 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8002d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8002d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002da:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	50                   	push   %eax
  8002e1:	e8 ff 1e 00 00       	call   8021e5 <malloc>
  8002e6:	83 c4 10             	add    $0x10,%esp
  8002e9:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  8002ef:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8002f5:	89 c1                	mov    %eax,%ecx
  8002f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fa:	89 c2                	mov    %eax,%edx
  8002fc:	01 d2                	add    %edx,%edx
  8002fe:	01 d0                	add    %edx,%eax
  800300:	05 00 00 00 80       	add    $0x80000000,%eax
  800305:	39 c1                	cmp    %eax,%ecx
  800307:	74 14                	je     80031d <_main+0x2e5>
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 14 35 80 00       	push   $0x803514
  800311:	6a 43                	push   $0x43
  800313:	68 b0 34 80 00       	push   $0x8034b0
  800318:	e8 1a 10 00 00       	call   801337 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80031d:	e8 93 2a 00 00       	call   802db5 <sys_calculate_free_frames>
  800322:	89 c2                	mov    %eax,%edx
  800324:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800327:	39 c2                	cmp    %eax,%edx
  800329:	74 14                	je     80033f <_main+0x307>
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	68 44 35 80 00       	push   $0x803544
  800333:	6a 45                	push   $0x45
  800335:	68 b0 34 80 00       	push   $0x8034b0
  80033a:	e8 f8 0f 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80033f:	e8 f4 2a 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800344:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800347:	3d 00 01 00 00       	cmp    $0x100,%eax
  80034c:	74 14                	je     800362 <_main+0x32a>
  80034e:	83 ec 04             	sub    $0x4,%esp
  800351:	68 b0 35 80 00       	push   $0x8035b0
  800356:	6a 46                	push   $0x46
  800358:	68 b0 34 80 00       	push   $0x8034b0
  80035d:	e8 d5 0f 00 00       	call   801337 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800362:	e8 4e 2a 00 00       	call   802db5 <sys_calculate_free_frames>
  800367:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80036a:	e8 c9 2a 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  80036f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800372:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	50                   	push   %eax
  80037e:	e8 62 1e 00 00       	call   8021e5 <malloc>
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  80038c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800392:	89 c2                	mov    %eax,%edx
  800394:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800397:	c1 e0 02             	shl    $0x2,%eax
  80039a:	05 00 00 00 80       	add    $0x80000000,%eax
  80039f:	39 c2                	cmp    %eax,%edx
  8003a1:	74 14                	je     8003b7 <_main+0x37f>
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	68 14 35 80 00       	push   $0x803514
  8003ab:	6a 4c                	push   $0x4c
  8003ad:	68 b0 34 80 00       	push   $0x8034b0
  8003b2:	e8 80 0f 00 00       	call   801337 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003b7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003ba:	e8 f6 29 00 00       	call   802db5 <sys_calculate_free_frames>
  8003bf:	29 c3                	sub    %eax,%ebx
  8003c1:	89 d8                	mov    %ebx,%eax
  8003c3:	83 f8 01             	cmp    $0x1,%eax
  8003c6:	74 14                	je     8003dc <_main+0x3a4>
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	68 44 35 80 00       	push   $0x803544
  8003d0:	6a 4e                	push   $0x4e
  8003d2:	68 b0 34 80 00       	push   $0x8034b0
  8003d7:	e8 5b 0f 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003dc:	e8 57 2a 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8003e1:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003e4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003e9:	74 14                	je     8003ff <_main+0x3c7>
  8003eb:	83 ec 04             	sub    $0x4,%esp
  8003ee:	68 b0 35 80 00       	push   $0x8035b0
  8003f3:	6a 4f                	push   $0x4f
  8003f5:	68 b0 34 80 00       	push   $0x8034b0
  8003fa:	e8 38 0f 00 00       	call   801337 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ff:	e8 b1 29 00 00       	call   802db5 <sys_calculate_free_frames>
  800404:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800407:	e8 2c 2a 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  80040c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80040f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800412:	01 c0                	add    %eax,%eax
  800414:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800417:	83 ec 0c             	sub    $0xc,%esp
  80041a:	50                   	push   %eax
  80041b:	e8 c5 1d 00 00       	call   8021e5 <malloc>
  800420:	83 c4 10             	add    $0x10,%esp
  800423:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  800426:	8b 45 80             	mov    -0x80(%ebp),%eax
  800429:	89 c1                	mov    %eax,%ecx
  80042b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	05 00 00 00 80       	add    $0x80000000,%eax
  80043b:	39 c1                	cmp    %eax,%ecx
  80043d:	74 14                	je     800453 <_main+0x41b>
  80043f:	83 ec 04             	sub    $0x4,%esp
  800442:	68 14 35 80 00       	push   $0x803514
  800447:	6a 55                	push   $0x55
  800449:	68 b0 34 80 00       	push   $0x8034b0
  80044e:	e8 e4 0e 00 00       	call   801337 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800453:	e8 5d 29 00 00       	call   802db5 <sys_calculate_free_frames>
  800458:	89 c2                	mov    %eax,%edx
  80045a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80045d:	39 c2                	cmp    %eax,%edx
  80045f:	74 14                	je     800475 <_main+0x43d>
  800461:	83 ec 04             	sub    $0x4,%esp
  800464:	68 44 35 80 00       	push   $0x803544
  800469:	6a 57                	push   $0x57
  80046b:	68 b0 34 80 00       	push   $0x8034b0
  800470:	e8 c2 0e 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800475:	e8 be 29 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  80047a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80047d:	3d 00 02 00 00       	cmp    $0x200,%eax
  800482:	74 14                	je     800498 <_main+0x460>
  800484:	83 ec 04             	sub    $0x4,%esp
  800487:	68 b0 35 80 00       	push   $0x8035b0
  80048c:	6a 58                	push   $0x58
  80048e:	68 b0 34 80 00       	push   $0x8034b0
  800493:	e8 9f 0e 00 00       	call   801337 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800498:	e8 18 29 00 00       	call   802db5 <sys_calculate_free_frames>
  80049d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004a0:	e8 93 29 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8004a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8004a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ab:	89 c2                	mov    %eax,%edx
  8004ad:	01 d2                	add    %edx,%edx
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8004b4:	83 ec 0c             	sub    $0xc,%esp
  8004b7:	50                   	push   %eax
  8004b8:	e8 28 1d 00 00       	call   8021e5 <malloc>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8004c3:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8004c6:	89 c2                	mov    %eax,%edx
  8004c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004cb:	c1 e0 03             	shl    $0x3,%eax
  8004ce:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d3:	39 c2                	cmp    %eax,%edx
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 14 35 80 00       	push   $0x803514
  8004df:	6a 5e                	push   $0x5e
  8004e1:	68 b0 34 80 00       	push   $0x8034b0
  8004e6:	e8 4c 0e 00 00       	call   801337 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004eb:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ee:	e8 c2 28 00 00       	call   802db5 <sys_calculate_free_frames>
  8004f3:	29 c3                	sub    %eax,%ebx
  8004f5:	89 d8                	mov    %ebx,%eax
  8004f7:	83 f8 01             	cmp    $0x1,%eax
  8004fa:	74 14                	je     800510 <_main+0x4d8>
  8004fc:	83 ec 04             	sub    $0x4,%esp
  8004ff:	68 44 35 80 00       	push   $0x803544
  800504:	6a 60                	push   $0x60
  800506:	68 b0 34 80 00       	push   $0x8034b0
  80050b:	e8 27 0e 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800510:	e8 23 29 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800515:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800518:	3d 00 03 00 00       	cmp    $0x300,%eax
  80051d:	74 14                	je     800533 <_main+0x4fb>
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	68 b0 35 80 00       	push   $0x8035b0
  800527:	6a 61                	push   $0x61
  800529:	68 b0 34 80 00       	push   $0x8034b0
  80052e:	e8 04 0e 00 00       	call   801337 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800533:	e8 7d 28 00 00       	call   802db5 <sys_calculate_free_frames>
  800538:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80053b:	e8 f8 28 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800540:	89 45 d0             	mov    %eax,-0x30(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800543:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800546:	89 c2                	mov    %eax,%edx
  800548:	01 d2                	add    %edx,%edx
  80054a:	01 d0                	add    %edx,%eax
  80054c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80054f:	83 ec 0c             	sub    $0xc,%esp
  800552:	50                   	push   %eax
  800553:	e8 8d 1c 00 00       	call   8021e5 <malloc>
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  80055e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800561:	89 c1                	mov    %eax,%ecx
  800563:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800566:	89 d0                	mov    %edx,%eax
  800568:	c1 e0 02             	shl    $0x2,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	05 00 00 00 80       	add    $0x80000000,%eax
  800576:	39 c1                	cmp    %eax,%ecx
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 14 35 80 00       	push   $0x803514
  800582:	6a 67                	push   $0x67
  800584:	68 b0 34 80 00       	push   $0x8034b0
  800589:	e8 a9 0d 00 00       	call   801337 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80058e:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800591:	e8 1f 28 00 00       	call   802db5 <sys_calculate_free_frames>
  800596:	29 c3                	sub    %eax,%ebx
  800598:	89 d8                	mov    %ebx,%eax
  80059a:	83 f8 01             	cmp    $0x1,%eax
  80059d:	74 14                	je     8005b3 <_main+0x57b>
  80059f:	83 ec 04             	sub    $0x4,%esp
  8005a2:	68 44 35 80 00       	push   $0x803544
  8005a7:	6a 69                	push   $0x69
  8005a9:	68 b0 34 80 00       	push   $0x8034b0
  8005ae:	e8 84 0d 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8005b3:	e8 80 28 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8005b8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8005bb:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005c0:	74 14                	je     8005d6 <_main+0x59e>
  8005c2:	83 ec 04             	sub    $0x4,%esp
  8005c5:	68 b0 35 80 00       	push   $0x8035b0
  8005ca:	6a 6a                	push   $0x6a
  8005cc:	68 b0 34 80 00       	push   $0x8034b0
  8005d1:	e8 61 0d 00 00       	call   801337 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d6:	e8 5d 28 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8005db:	89 45 d0             	mov    %eax,-0x30(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8005de:	e8 d2 27 00 00       	call   802db5 <sys_calculate_free_frames>
  8005e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
		free(ptr_allocations[1]);
  8005e6:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	50                   	push   %eax
  8005f0:	e8 92 25 00 00       	call   802b87 <free>
  8005f5:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: table is not removed correctly");
  8005f8:	e8 b8 27 00 00       	call   802db5 <sys_calculate_free_frames>
  8005fd:	89 c2                	mov    %eax,%edx
  8005ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800602:	39 c2                	cmp    %eax,%edx
  800604:	74 14                	je     80061a <_main+0x5e2>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 e0 35 80 00       	push   $0x8035e0
  80060e:	6a 73                	push   $0x73
  800610:	68 b0 34 80 00       	push   $0x8034b0
  800615:	e8 1d 0d 00 00       	call   801337 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  80061a:	e8 19 28 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  80061f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800622:	29 c2                	sub    %eax,%edx
  800624:	89 d0                	mov    %edx,%eax
  800626:	3d 00 01 00 00       	cmp    $0x100,%eax
  80062b:	74 14                	je     800641 <_main+0x609>
  80062d:	83 ec 04             	sub    $0x4,%esp
  800630:	68 0c 36 80 00       	push   $0x80360c
  800635:	6a 74                	push   $0x74
  800637:	68 b0 34 80 00       	push   $0x8034b0
  80063c:	e8 f6 0c 00 00       	call   801337 <_panic>

		//2 MB Hole
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800641:	e8 f2 27 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800646:	89 45 d0             	mov    %eax,-0x30(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  800649:	e8 67 27 00 00       	call   802db5 <sys_calculate_free_frames>
  80064e:	89 45 cc             	mov    %eax,-0x34(%ebp)
		free(ptr_allocations[4]);
  800651:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800657:	83 ec 0c             	sub    $0xc,%esp
  80065a:	50                   	push   %eax
  80065b:	e8 27 25 00 00       	call   802b87 <free>
  800660:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: table is not removed correctly");
  800663:	e8 4d 27 00 00       	call   802db5 <sys_calculate_free_frames>
  800668:	89 c2                	mov    %eax,%edx
  80066a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80066d:	39 c2                	cmp    %eax,%edx
  80066f:	74 14                	je     800685 <_main+0x64d>
  800671:	83 ec 04             	sub    $0x4,%esp
  800674:	68 e0 35 80 00       	push   $0x8035e0
  800679:	6a 7a                	push   $0x7a
  80067b:	68 b0 34 80 00       	push   $0x8034b0
  800680:	e8 b2 0c 00 00       	call   801337 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800685:	e8 ae 27 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  80068a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80068d:	29 c2                	sub    %eax,%edx
  80068f:	89 d0                	mov    %edx,%eax
  800691:	3d 00 02 00 00       	cmp    $0x200,%eax
  800696:	74 14                	je     8006ac <_main+0x674>
  800698:	83 ec 04             	sub    $0x4,%esp
  80069b:	68 0c 36 80 00       	push   $0x80360c
  8006a0:	6a 7b                	push   $0x7b
  8006a2:	68 b0 34 80 00       	push   $0x8034b0
  8006a7:	e8 8b 0c 00 00       	call   801337 <_panic>

		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ac:	e8 87 27 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8006b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b4:	e8 fc 26 00 00       	call   802db5 <sys_calculate_free_frames>
  8006b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		free(ptr_allocations[6]);
  8006bc:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8006bf:	83 ec 0c             	sub    $0xc,%esp
  8006c2:	50                   	push   %eax
  8006c3:	e8 bf 24 00 00       	call   802b87 <free>
  8006c8:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: table is not removed correctly");
  8006cb:	e8 e5 26 00 00       	call   802db5 <sys_calculate_free_frames>
  8006d0:	89 c2                	mov    %eax,%edx
  8006d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006d5:	39 c2                	cmp    %eax,%edx
  8006d7:	74 17                	je     8006f0 <_main+0x6b8>
  8006d9:	83 ec 04             	sub    $0x4,%esp
  8006dc:	68 e0 35 80 00       	push   $0x8035e0
  8006e1:	68 81 00 00 00       	push   $0x81
  8006e6:	68 b0 34 80 00       	push   $0x8034b0
  8006eb:	e8 47 0c 00 00       	call   801337 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006f0:	e8 43 27 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8006f5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006f8:	29 c2                	sub    %eax,%edx
  8006fa:	89 d0                	mov    %edx,%eax
  8006fc:	3d 00 03 00 00       	cmp    $0x300,%eax
  800701:	74 17                	je     80071a <_main+0x6e2>
  800703:	83 ec 04             	sub    $0x4,%esp
  800706:	68 0c 36 80 00       	push   $0x80360c
  80070b:	68 82 00 00 00       	push   $0x82
  800710:	68 b0 34 80 00       	push   $0x8034b0
  800715:	e8 1d 0c 00 00       	call   801337 <_panic>
	}

	int cnt = 0;
  80071a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	6a 03                	push   $0x3
  800726:	e8 5d 29 00 00       	call   803088 <sys_bypassPageFault>
  80072b:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size  = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  80072e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800734:	89 45 c8             	mov    %eax,-0x38(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  800737:	e8 79 26 00 00       	call   802db5 <sys_calculate_free_frames>
  80073c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80073f:	e8 f4 26 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800744:	89 45 d0             	mov    %eax,-0x30(%ebp)

		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  800747:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	6a 00                	push   $0x0
  800752:	50                   	push   %eax
  800753:	e8 12 25 00 00       	call   802c6a <realloc>
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800761:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800767:	85 c0                	test   %eax,%eax
  800769:	74 17                	je     800782 <_main+0x74a>
  80076b:	83 ec 04             	sub    $0x4,%esp
  80076e:	68 48 36 80 00       	push   $0x803648
  800773:	68 98 00 00 00       	push   $0x98
  800778:	68 b0 34 80 00       	push   $0x8034b0
  80077d:	e8 b5 0b 00 00       	call   801337 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong re-allocation");
  800782:	e8 2e 26 00 00       	call   802db5 <sys_calculate_free_frames>
  800787:	89 c2                	mov    %eax,%edx
  800789:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80078c:	39 c2                	cmp    %eax,%edx
  80078e:	74 17                	je     8007a7 <_main+0x76f>
  800790:	83 ec 04             	sub    $0x4,%esp
  800793:	68 90 36 80 00       	push   $0x803690
  800798:	68 99 00 00 00       	push   $0x99
  80079d:	68 b0 34 80 00       	push   $0x8034b0
  8007a2:	e8 90 0b 00 00       	call   801337 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong re-allocation to size 0: Extra or less pages are removed from PageFile");
  8007a7:	e8 8c 26 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8007ac:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007af:	29 c2                	sub    %eax,%edx
  8007b1:	89 d0                	mov    %edx,%eax
  8007b3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007b8:	74 17                	je     8007d1 <_main+0x799>
  8007ba:	83 ec 04             	sub    $0x4,%esp
  8007bd:	68 a4 36 80 00       	push   $0x8036a4
  8007c2:	68 9a 00 00 00       	push   $0x9a
  8007c7:	68 b0 34 80 00       	push   $0x8034b0
  8007cc:	e8 66 0b 00 00       	call   801337 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007d4:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007d7:	e8 93 28 00 00       	call   80306f <sys_rcr2>
  8007dc:	89 c2                	mov    %eax,%edx
  8007de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007e1:	39 c2                	cmp    %eax,%edx
  8007e3:	74 17                	je     8007fc <_main+0x7c4>
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	68 f4 36 80 00       	push   $0x8036f4
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 b0 34 80 00       	push   $0x8034b0
  8007f7:	e8 3b 0b 00 00       	call   801337 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  8007fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ff:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800802:	8d 50 ff             	lea    -0x1(%eax),%edx
  800805:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800808:	01 d0                	add    %edx,%eax
  80080a:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  80080d:	e8 5d 28 00 00       	call   80306f <sys_rcr2>
  800812:	89 c2                	mov    %eax,%edx
  800814:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800817:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80081a:	8d 48 ff             	lea    -0x1(%eax),%ecx
  80081d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800820:	01 c8                	add    %ecx,%eax
  800822:	39 c2                	cmp    %eax,%edx
  800824:	74 17                	je     80083d <_main+0x805>
  800826:	83 ec 04             	sub    $0x4,%esp
  800829:	68 48 37 80 00       	push   $0x803748
  80082e:	68 a0 00 00 00       	push   $0xa0
  800833:	68 b0 34 80 00       	push   $0x8034b0
  800838:	e8 fa 0a 00 00       	call   801337 <_panic>

		cprintf("\nCASE1: (Re-allocate with size  = 0) is succeeded...\n") ;
  80083d:	83 ec 0c             	sub    $0xc,%esp
  800840:	68 98 37 80 00       	push   $0x803798
  800845:	e8 18 0c 00 00       	call   801462 <cprintf>
  80084a:	83 c4 10             	add    $0x10,%esp

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  80084d:	83 ec 0c             	sub    $0xc,%esp
  800850:	6a 00                	push   $0x0
  800852:	e8 31 28 00 00       	call   803088 <sys_bypassPageFault>
  800857:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80085a:	e8 56 25 00 00       	call   802db5 <sys_calculate_free_frames>
  80085f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800862:	e8 d1 25 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800867:	89 45 d0             	mov    %eax,-0x30(%ebp)

		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  80086a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80086d:	89 d0                	mov    %edx,%eax
  80086f:	c1 e0 08             	shl    $0x8,%eax
  800872:	29 d0                	sub    %edx,%eax
  800874:	89 c2                	mov    %eax,%edx
  800876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800879:	01 d0                	add    %edx,%eax
  80087b:	01 c0                	add    %eax,%eax
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	50                   	push   %eax
  800881:	6a 00                	push   $0x0
  800883:	e8 e2 23 00 00       	call   802c6a <realloc>
  800888:	83 c4 10             	add    $0x10,%esp
  80088b:	89 45 94             	mov    %eax,-0x6c(%ebp)

		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80088e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800891:	89 c2                	mov    %eax,%edx
  800893:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800896:	c1 e0 03             	shl    $0x3,%eax
  800899:	05 00 00 00 80       	add    $0x80000000,%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	74 17                	je     8008b9 <_main+0x881>
  8008a2:	83 ec 04             	sub    $0x4,%esp
  8008a5:	68 14 35 80 00       	push   $0x803514
  8008aa:	68 af 00 00 00       	push   $0xaf
  8008af:	68 b0 34 80 00       	push   $0x8034b0
  8008b4:	e8 7e 0a 00 00       	call   801337 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
  8008b9:	e8 f7 24 00 00       	call   802db5 <sys_calculate_free_frames>
  8008be:	89 c2                	mov    %eax,%edx
  8008c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008c3:	39 c2                	cmp    %eax,%edx
  8008c5:	74 17                	je     8008de <_main+0x8a6>
  8008c7:	83 ec 04             	sub    $0x4,%esp
  8008ca:	68 90 36 80 00       	push   $0x803690
  8008cf:	68 b0 00 00 00       	push   $0xb0
  8008d4:	68 b0 34 80 00       	push   $0x8034b0
  8008d9:	e8 59 0a 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are allocated in PageFile");
  8008de:	e8 55 25 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8008e3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8008e6:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008eb:	74 17                	je     800904 <_main+0x8cc>
  8008ed:	83 ec 04             	sub    $0x4,%esp
  8008f0:	68 b0 35 80 00       	push   $0x8035b0
  8008f5:	68 b1 00 00 00       	push   $0xb1
  8008fa:	68 b0 34 80 00       	push   $0x8034b0
  8008ff:	e8 33 0a 00 00       	call   801337 <_panic>

		//Fill it with data
		freeFrames = sys_calculate_free_frames() ;
  800904:	e8 ac 24 00 00       	call   802db5 <sys_calculate_free_frames>
  800909:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int *intArr = (int*) ptr_allocations[10];
  80090c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80090f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800912:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800915:	89 d0                	mov    %edx,%eax
  800917:	c1 e0 08             	shl    $0x8,%eax
  80091a:	29 d0                	sub    %edx,%eax
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800921:	01 d0                	add    %edx,%eax
  800923:	01 c0                	add    %eax,%eax
  800925:	c1 e8 02             	shr    $0x2,%eax
  800928:	48                   	dec    %eax
  800929:	89 45 c0             	mov    %eax,-0x40(%ebp)

		int i = 0;
  80092c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800933:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80093a:	eb 17                	jmp    800953 <_main+0x91b>
		{
			intArr[i] = i ;
  80093c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80093f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800946:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800949:	01 c2                	add    %eax,%edx
  80094b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80094e:	89 02                	mov    %eax,(%edx)
		freeFrames = sys_calculate_free_frames() ;
		int *intArr = (int*) ptr_allocations[10];
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800950:	ff 45 e8             	incl   -0x18(%ebp)
  800953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800956:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800959:	7e e1                	jle    80093c <_main+0x904>
		{
			intArr[i] = i ;
		}

		if ((freeFrames - sys_calculate_free_frames()) != 640 + 1) panic("Wrong placement when accessing the allocated space");
  80095b:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80095e:	e8 52 24 00 00       	call   802db5 <sys_calculate_free_frames>
  800963:	29 c3                	sub    %eax,%ebx
  800965:	89 d8                	mov    %ebx,%eax
  800967:	3d 81 02 00 00       	cmp    $0x281,%eax
  80096c:	74 17                	je     800985 <_main+0x94d>
  80096e:	83 ec 04             	sub    $0x4,%esp
  800971:	68 d0 37 80 00       	push   $0x8037d0
  800976:	68 be 00 00 00       	push   $0xbe
  80097b:	68 b0 34 80 00       	push   $0x8034b0
  800980:	e8 b2 09 00 00       	call   801337 <_panic>

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
  800985:	e8 2b 24 00 00       	call   802db5 <sys_calculate_free_frames>
  80098a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i=0; i <= lastIndexOfInt1 ; i++)
  80098d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800994:	eb 33                	jmp    8009c9 <_main+0x991>
		{
			cnt++;
  800996:	ff 45 ec             	incl   -0x14(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80099c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8009a6:	01 d0                	add    %edx,%eax
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8009ad:	74 17                	je     8009c6 <_main+0x98e>
  8009af:	83 ec 04             	sub    $0x4,%esp
  8009b2:	68 04 38 80 00       	push   $0x803804
  8009b7:	68 c5 00 00 00       	push   $0xc5
  8009bc:	68 b0 34 80 00       	push   $0x8034b0
  8009c1:	e8 71 09 00 00       	call   801337 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) != 640 + 1) panic("Wrong placement when accessing the allocated space");

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
		for (i=0; i <= lastIndexOfInt1 ; i++)
  8009c6:	ff 45 e8             	incl   -0x18(%ebp)
  8009c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009cc:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  8009cf:	7e c5                	jle    800996 <_main+0x95e>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong placement when accessing the allocated space");
  8009d1:	e8 df 23 00 00       	call   802db5 <sys_calculate_free_frames>
  8009d6:	89 c2                	mov    %eax,%edx
  8009d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009db:	39 c2                	cmp    %eax,%edx
  8009dd:	74 17                	je     8009f6 <_main+0x9be>
  8009df:	83 ec 04             	sub    $0x4,%esp
  8009e2:	68 d0 37 80 00       	push   $0x8037d0
  8009e7:	68 c7 00 00 00       	push   $0xc7
  8009ec:	68 b0 34 80 00       	push   $0x8034b0
  8009f1:	e8 41 09 00 00       	call   801337 <_panic>

		cprintf("CASE2: (Re-allocate with address = NULL) is succeeded...\n") ;
  8009f6:	83 ec 0c             	sub    $0xc,%esp
  8009f9:	68 3c 38 80 00       	push   $0x80383c
  8009fe:	e8 5f 0a 00 00       	call   801462 <cprintf>
  800a03:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a06:	e8 aa 23 00 00       	call   802db5 <sys_calculate_free_frames>
  800a0b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0e:	e8 25 24 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800a13:	89 45 d0             	mov    %eax,-0x30(%ebp)

		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a16:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a19:	89 d0                	mov    %edx,%eax
  800a1b:	c1 e0 08             	shl    $0x8,%eax
  800a1e:	29 d0                	sub    %edx,%eax
  800a20:	89 c2                	mov    %eax,%edx
  800a22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a25:	01 d0                	add    %edx,%eax
  800a27:	01 c0                	add    %eax,%eax
  800a29:	89 c2                	mov    %eax,%edx
  800a2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2e:	01 d0                	add    %edx,%eax
  800a30:	89 c2                	mov    %eax,%edx
  800a32:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	52                   	push   %edx
  800a39:	50                   	push   %eax
  800a3a:	e8 2b 22 00 00       	call   802c6a <realloc>
  800a3f:	83 c4 10             	add    $0x10,%esp
  800a42:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a45:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a4d:	c1 e0 03             	shl    $0x3,%eax
  800a50:	05 00 00 00 80       	add    $0x80000000,%eax
  800a55:	39 c2                	cmp    %eax,%edx
  800a57:	74 17                	je     800a70 <_main+0xa38>
  800a59:	83 ec 04             	sub    $0x4,%esp
  800a5c:	68 78 38 80 00       	push   $0x803878
  800a61:	68 d4 00 00 00       	push   $0xd4
  800a66:	68 b0 34 80 00       	push   $0x8034b0
  800a6b:	e8 c7 08 00 00       	call   801337 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
  800a70:	e8 40 23 00 00       	call   802db5 <sys_calculate_free_frames>
  800a75:	89 c2                	mov    %eax,%edx
  800a77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a7a:	39 c2                	cmp    %eax,%edx
  800a7c:	74 17                	je     800a95 <_main+0xa5d>
  800a7e:	83 ec 04             	sub    $0x4,%esp
  800a81:	68 90 36 80 00       	push   $0x803690
  800a86:	68 d5 00 00 00       	push   $0xd5
  800a8b:	68 b0 34 80 00       	push   $0x8034b0
  800a90:	e8 a2 08 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a95:	e8 9e 23 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800a9a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800a9d:	74 17                	je     800ab6 <_main+0xa7e>
  800a9f:	83 ec 04             	sub    $0x4,%esp
  800aa2:	68 b0 35 80 00       	push   $0x8035b0
  800aa7:	68 d6 00 00 00       	push   $0xd6
  800aac:	68 b0 34 80 00       	push   $0x8034b0
  800ab1:	e8 81 08 00 00       	call   801337 <_panic>

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
  800ab6:	e8 fa 22 00 00       	call   802db5 <sys_calculate_free_frames>
  800abb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800abe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ac1:	89 d0                	mov    %edx,%eax
  800ac3:	c1 e0 08             	shl    $0x8,%eax
  800ac6:	29 d0                	sub    %edx,%eax
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800acd:	01 d0                	add    %edx,%eax
  800acf:	01 c0                	add    %eax,%eax
  800ad1:	89 c2                	mov    %eax,%edx
  800ad3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad6:	01 d0                	add    %edx,%eax
  800ad8:	c1 e8 02             	shr    $0x2,%eax
  800adb:	48                   	dec    %eax
  800adc:	89 45 bc             	mov    %eax,-0x44(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt2 ; i++)
  800adf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae2:	40                   	inc    %eax
  800ae3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800ae6:	eb 17                	jmp    800aff <_main+0xac7>
		{
			intArr[i] = i ;
  800ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800aeb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800af2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800af5:	01 c2                	add    %eax,%edx
  800af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800afa:	89 02                	mov    %eax,(%edx)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt2 ; i++)
  800afc:	ff 45 e8             	incl   -0x18(%ebp)
  800aff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b02:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800b05:	7c e1                	jl     800ae8 <_main+0xab0>
		{
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong placement when accessing the allocated space");
  800b07:	e8 a9 22 00 00       	call   802db5 <sys_calculate_free_frames>
  800b0c:	89 c2                	mov    %eax,%edx
  800b0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	74 17                	je     800b2c <_main+0xaf4>
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	68 d0 37 80 00       	push   $0x8037d0
  800b1d:	68 df 00 00 00       	push   $0xdf
  800b22:	68 b0 34 80 00       	push   $0x8034b0
  800b27:	e8 0b 08 00 00       	call   801337 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800b2c:	e8 84 22 00 00       	call   802db5 <sys_calculate_free_frames>
  800b31:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i=0; i < lastIndexOfInt2 ; i++)
  800b34:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b3b:	eb 33                	jmp    800b70 <_main+0xb38>
		{
			cnt++;
  800b3d:	ff 45 ec             	incl   -0x14(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b4a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800b54:	74 17                	je     800b6d <_main+0xb35>
  800b56:	83 ec 04             	sub    $0x4,%esp
  800b59:	68 04 38 80 00       	push   $0x803804
  800b5e:	68 e5 00 00 00       	push   $0xe5
  800b63:	68 b0 34 80 00       	push   $0x8034b0
  800b68:	e8 ca 07 00 00       	call   801337 <_panic>
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong placement when accessing the allocated space");

		freeFrames = sys_calculate_free_frames() ;
		for (i=0; i < lastIndexOfInt2 ; i++)
  800b6d:	ff 45 e8             	incl   -0x18(%ebp)
  800b70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b73:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800b76:	7c c5                	jl     800b3d <_main+0xb05>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong placement when accessing the allocated space");
  800b78:	e8 38 22 00 00       	call   802db5 <sys_calculate_free_frames>
  800b7d:	89 c2                	mov    %eax,%edx
  800b7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b82:	39 c2                	cmp    %eax,%edx
  800b84:	74 17                	je     800b9d <_main+0xb65>
  800b86:	83 ec 04             	sub    $0x4,%esp
  800b89:	68 d0 37 80 00       	push   $0x8037d0
  800b8e:	68 e7 00 00 00       	push   $0xe7
  800b93:	68 b0 34 80 00       	push   $0x8034b0
  800b98:	e8 9a 07 00 00       	call   801337 <_panic>

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800b9d:	e8 13 22 00 00       	call   802db5 <sys_calculate_free_frames>
  800ba2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ba5:	e8 8e 22 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800baa:	89 45 d0             	mov    %eax,-0x30(%ebp)

		free(ptr_allocations[10]);
  800bad:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800bb0:	83 ec 0c             	sub    $0xc,%esp
  800bb3:	50                   	push   %eax
  800bb4:	e8 ce 1f 00 00       	call   802b87 <free>
  800bb9:	83 c4 10             	add    $0x10,%esp

		if ((sys_calculate_free_frames() - freeFrames) != 640+1) panic("Wrong free of the re-allocated space");
  800bbc:	e8 f4 21 00 00       	call   802db5 <sys_calculate_free_frames>
  800bc1:	89 c2                	mov    %eax,%edx
  800bc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800bc6:	29 c2                	sub    %eax,%edx
  800bc8:	89 d0                	mov    %edx,%eax
  800bca:	3d 81 02 00 00       	cmp    $0x281,%eax
  800bcf:	74 17                	je     800be8 <_main+0xbb0>
  800bd1:	83 ec 04             	sub    $0x4,%esp
  800bd4:	68 ac 38 80 00       	push   $0x8038ac
  800bd9:	68 ef 00 00 00       	push   $0xef
  800bde:	68 b0 34 80 00       	push   $0x8034b0
  800be3:	e8 4f 07 00 00       	call   801337 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free: Extra or less pages are removed from PageFile");
  800be8:	e8 4b 22 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800bed:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800bf0:	29 c2                	sub    %eax,%edx
  800bf2:	89 d0                	mov    %edx,%eax
  800bf4:	3d 80 02 00 00       	cmp    $0x280,%eax
  800bf9:	74 17                	je     800c12 <_main+0xbda>
  800bfb:	83 ec 04             	sub    $0x4,%esp
  800bfe:	68 0c 36 80 00       	push   $0x80360c
  800c03:	68 f0 00 00 00       	push   $0xf0
  800c08:	68 b0 34 80 00       	push   $0x8034b0
  800c0d:	e8 25 07 00 00       	call   801337 <_panic>

		cprintf("CASE3: (Re-allocate in the existing internal fragment) is succeeded...\n") ;
  800c12:	83 ec 0c             	sub    $0xc,%esp
  800c15:	68 d4 38 80 00       	push   $0x8038d4
  800c1a:	e8 43 08 00 00       	call   801462 <cprintf>
  800c1f:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		freeFrames = sys_calculate_free_frames() ;
  800c22:	e8 8e 21 00 00       	call   802db5 <sys_calculate_free_frames>
  800c27:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[2];
  800c2a:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800c30:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800c33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c36:	c1 e8 02             	shr    $0x2,%eax
  800c39:	48                   	dec    %eax
  800c3a:	89 45 c0             	mov    %eax,-0x40(%ebp)

		i = 0;
  800c3d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800c44:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800c4b:	eb 17                	jmp    800c64 <_main+0xc2c>
		{
			intArr[i] = i ;
  800c4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c57:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c5a:	01 c2                	add    %eax,%edx
  800c5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c5f:	89 02                	mov    %eax,(%edx)
		freeFrames = sys_calculate_free_frames() ;
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800c61:	ff 45 e8             	incl   -0x18(%ebp)
  800c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c67:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800c6a:	7e e1                	jle    800c4d <_main+0xc15>
		{
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 256+1) panic("Wrong re-allocation");
  800c6c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c6f:	e8 41 21 00 00       	call   802db5 <sys_calculate_free_frames>
  800c74:	29 c3                	sub    %eax,%ebx
  800c76:	89 d8                	mov    %ebx,%eax
  800c78:	3d 01 01 00 00       	cmp    $0x101,%eax
  800c7d:	74 17                	je     800c96 <_main+0xc5e>
  800c7f:	83 ec 04             	sub    $0x4,%esp
  800c82:	68 90 36 80 00       	push   $0x803690
  800c87:	68 00 01 00 00       	push   $0x100
  800c8c:	68 b0 34 80 00       	push   $0x8034b0
  800c91:	e8 a1 06 00 00       	call   801337 <_panic>

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800c96:	e8 1a 21 00 00       	call   802db5 <sys_calculate_free_frames>
  800c9b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c9e:	e8 95 21 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800ca3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800ca6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800ca9:	89 d0                	mov    %edx,%eax
  800cab:	01 c0                	add    %eax,%eax
  800cad:	01 d0                	add    %edx,%eax
  800caf:	c1 e0 02             	shl    $0x2,%eax
  800cb2:	01 d0                	add    %edx,%eax
  800cb4:	f7 d8                	neg    %eax
  800cb6:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800cbc:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800cc2:	83 ec 08             	sub    $0x8,%esp
  800cc5:	52                   	push   %edx
  800cc6:	50                   	push   %eax
  800cc7:	e8 9e 1f 00 00       	call   802c6a <realloc>
  800ccc:	83 c4 10             	add    $0x10,%esp
  800ccf:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  800cd5:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800cdb:	89 c2                	mov    %eax,%edx
  800cdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce0:	01 c0                	add    %eax,%eax
  800ce2:	05 00 00 00 80       	add    $0x80000000,%eax
  800ce7:	39 c2                	cmp    %eax,%edx
  800ce9:	74 17                	je     800d02 <_main+0xcca>
  800ceb:	83 ec 04             	sub    $0x4,%esp
  800cee:	68 78 38 80 00       	push   $0x803878
  800cf3:	68 0b 01 00 00       	push   $0x10b
  800cf8:	68 b0 34 80 00       	push   $0x8034b0
  800cfd:	e8 35 06 00 00       	call   801337 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
  800d02:	e8 ae 20 00 00       	call   802db5 <sys_calculate_free_frames>
  800d07:	89 c2                	mov    %eax,%edx
  800d09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800d0c:	39 c2                	cmp    %eax,%edx
  800d0e:	74 17                	je     800d27 <_main+0xcef>
  800d10:	83 ec 04             	sub    $0x4,%esp
  800d13:	68 90 36 80 00       	push   $0x803690
  800d18:	68 0c 01 00 00       	push   $0x10c
  800d1d:	68 b0 34 80 00       	push   $0x8034b0
  800d22:	e8 10 06 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800d27:	e8 0c 21 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800d2c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800d2f:	74 17                	je     800d48 <_main+0xd10>
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	68 b0 35 80 00       	push   $0x8035b0
  800d39:	68 0d 01 00 00       	push   $0x10d
  800d3e:	68 b0 34 80 00       	push   $0x8034b0
  800d43:	e8 ef 05 00 00       	call   801337 <_panic>

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
  800d48:	e8 68 20 00 00       	call   802db5 <sys_calculate_free_frames>
  800d4d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800d50:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d57:	eb 33                	jmp    800d8c <_main+0xd54>
		{
			cnt++;
  800d59:	ff 45 ec             	incl   -0x14(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d69:	01 d0                	add    %edx,%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800d70:	74 17                	je     800d89 <_main+0xd51>
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	68 04 38 80 00       	push   $0x803804
  800d7a:	68 14 01 00 00       	push   $0x114
  800d7f:	68 b0 34 80 00       	push   $0x8034b0
  800d84:	e8 ae 05 00 00       	call   801337 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800d89:	ff 45 e8             	incl   -0x18(%ebp)
  800d8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d8f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800d92:	7e c5                	jle    800d59 <_main+0xd21>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong placement when accessing the allocated space");
  800d94:	e8 1c 20 00 00       	call   802db5 <sys_calculate_free_frames>
  800d99:	89 c2                	mov    %eax,%edx
  800d9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800d9e:	39 c2                	cmp    %eax,%edx
  800da0:	74 17                	je     800db9 <_main+0xd81>
  800da2:	83 ec 04             	sub    $0x4,%esp
  800da5:	68 d0 37 80 00       	push   $0x8037d0
  800daa:	68 16 01 00 00       	push   $0x116
  800daf:	68 b0 34 80 00       	push   $0x8034b0
  800db4:	e8 7e 05 00 00       	call   801337 <_panic>

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800db9:	e8 f7 1f 00 00       	call   802db5 <sys_calculate_free_frames>
  800dbe:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800dc1:	e8 72 20 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800dc6:	89 45 d0             	mov    %eax,-0x30(%ebp)

		free(ptr_allocations[2]);
  800dc9:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	50                   	push   %eax
  800dd3:	e8 af 1d 00 00       	call   802b87 <free>
  800dd8:	83 c4 10             	add    $0x10,%esp

		if ((sys_calculate_free_frames() - freeFrames) != 256+1) panic("Wrong free of the re-allocated space");
  800ddb:	e8 d5 1f 00 00       	call   802db5 <sys_calculate_free_frames>
  800de0:	89 c2                	mov    %eax,%edx
  800de2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800de5:	29 c2                	sub    %eax,%edx
  800de7:	89 d0                	mov    %edx,%eax
  800de9:	3d 01 01 00 00       	cmp    $0x101,%eax
  800dee:	74 17                	je     800e07 <_main+0xdcf>
  800df0:	83 ec 04             	sub    $0x4,%esp
  800df3:	68 ac 38 80 00       	push   $0x8038ac
  800df8:	68 1e 01 00 00       	push   $0x11e
  800dfd:	68 b0 34 80 00       	push   $0x8034b0
  800e02:	e8 30 05 00 00       	call   801337 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e07:	e8 2c 20 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800e0c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e0f:	29 c2                	sub    %eax,%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e18:	74 17                	je     800e31 <_main+0xdf9>
  800e1a:	83 ec 04             	sub    $0x4,%esp
  800e1d:	68 0c 36 80 00       	push   $0x80360c
  800e22:	68 1f 01 00 00       	push   $0x11f
  800e27:	68 b0 34 80 00       	push   $0x8034b0
  800e2c:	e8 06 05 00 00       	call   801337 <_panic>

		cprintf("CASE4: (Re-allocate that can NOT fit in any free fragment) is succeeded...\n") ;
  800e31:	83 ec 0c             	sub    $0xc,%esp
  800e34:	68 1c 39 80 00       	push   $0x80391c
  800e39:	e8 24 06 00 00       	call   801462 <cprintf>
  800e3e:	83 c4 10             	add    $0x10,%esp

		/*CASE5: Re-allocate that only fit in the 1st or last segment*/

		//[1] create 4 MB hole at beginning of the heap
		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800e41:	e8 6f 1f 00 00       	call   802db5 <sys_calculate_free_frames>
  800e46:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800e49:	e8 ea 1f 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800e4e:	89 45 d0             	mov    %eax,-0x30(%ebp)

		ptr_allocations[10] = malloc(2*Mega-kilo);
  800e51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e54:	01 c0                	add    %eax,%eax
  800e56:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	50                   	push   %eax
  800e5d:	e8 83 13 00 00       	call   8021e5 <malloc>
  800e62:	83 c4 10             	add    $0x10,%esp
  800e65:	89 45 94             	mov    %eax,-0x6c(%ebp)

		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800e68:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800e6b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 14 35 80 00       	push   $0x803514
  800e7a:	68 2c 01 00 00       	push   $0x12c
  800e7f:	68 b0 34 80 00       	push   $0x8034b0
  800e84:	e8 ae 04 00 00       	call   801337 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800e89:	e8 27 1f 00 00       	call   802db5 <sys_calculate_free_frames>
  800e8e:	89 c2                	mov    %eax,%edx
  800e90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e93:	39 c2                	cmp    %eax,%edx
  800e95:	74 17                	je     800eae <_main+0xe76>
  800e97:	83 ec 04             	sub    $0x4,%esp
  800e9a:	68 68 39 80 00       	push   $0x803968
  800e9f:	68 2d 01 00 00       	push   $0x12d
  800ea4:	68 b0 34 80 00       	push   $0x8034b0
  800ea9:	e8 89 04 00 00       	call   801337 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800eae:	e8 85 1f 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800eb3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800eb6:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ebb:	74 17                	je     800ed4 <_main+0xe9c>
  800ebd:	83 ec 04             	sub    $0x4,%esp
  800ec0:	68 b0 35 80 00       	push   $0x8035b0
  800ec5:	68 2e 01 00 00       	push   $0x12e
  800eca:	68 b0 34 80 00       	push   $0x8034b0
  800ecf:	e8 63 04 00 00       	call   801337 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800ed4:	e8 dc 1e 00 00       	call   802db5 <sys_calculate_free_frames>
  800ed9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800edc:	e8 57 1f 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800ee1:	89 45 d0             	mov    %eax,-0x30(%ebp)

		free(ptr_allocations[3]);
  800ee4:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	50                   	push   %eax
  800eee:	e8 94 1c 00 00       	call   802b87 <free>
  800ef3:	83 c4 10             	add    $0x10,%esp

		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ef6:	e8 ba 1e 00 00       	call   802db5 <sys_calculate_free_frames>
  800efb:	89 c2                	mov    %eax,%edx
  800efd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800f00:	39 c2                	cmp    %eax,%edx
  800f02:	74 17                	je     800f1b <_main+0xee3>
  800f04:	83 ec 04             	sub    $0x4,%esp
  800f07:	68 7b 39 80 00       	push   $0x80397b
  800f0c:	68 36 01 00 00       	push   $0x136
  800f11:	68 b0 34 80 00       	push   $0x8034b0
  800f16:	e8 1c 04 00 00       	call   801337 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f1b:	e8 18 1f 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800f20:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800f23:	29 c2                	sub    %eax,%edx
  800f25:	89 d0                	mov    %edx,%eax
  800f27:	3d 00 01 00 00       	cmp    $0x100,%eax
  800f2c:	74 17                	je     800f45 <_main+0xf0d>
  800f2e:	83 ec 04             	sub    $0x4,%esp
  800f31:	68 0c 36 80 00       	push   $0x80360c
  800f36:	68 37 01 00 00       	push   $0x137
  800f3b:	68 b0 34 80 00       	push   $0x8034b0
  800f40:	e8 f2 03 00 00       	call   801337 <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800f45:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800f48:	89 d0                	mov    %edx,%eax
  800f4a:	c1 e0 02             	shl    $0x2,%eax
  800f4d:	01 d0                	add    %edx,%eax
  800f4f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800f52:	83 ec 0c             	sub    $0xc,%esp
  800f55:	50                   	push   %eax
  800f56:	e8 8a 12 00 00       	call   8021e5 <malloc>
  800f5b:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		freeFrames = sys_calculate_free_frames() ;
  800f5e:	e8 52 1e 00 00       	call   802db5 <sys_calculate_free_frames>
  800f63:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  800f66:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f69:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfInt1 = (3*Mega)/sizeof(int) - 1;
  800f6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f6f:	89 c2                	mov    %eax,%edx
  800f71:	01 d2                	add    %edx,%edx
  800f73:	01 d0                	add    %edx,%eax
  800f75:	c1 e8 02             	shr    $0x2,%eax
  800f78:	48                   	dec    %eax
  800f79:	89 45 c0             	mov    %eax,-0x40(%ebp)

		i = 0;
  800f7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800f83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f8a:	eb 17                	jmp    800fa3 <_main+0xf6b>
		{
			intArr[i] = i ;
  800f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f8f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f96:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800f99:	01 c2                	add    %eax,%edx
  800f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f9e:	89 02                	mov    %eax,(%edx)
		freeFrames = sys_calculate_free_frames() ;
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega)/sizeof(int) - 1;

		i = 0;
		for (i=0; i <= lastIndexOfInt1 ; i++)
  800fa0:	ff 45 e8             	incl   -0x18(%ebp)
  800fa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fa6:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800fa9:	7e e1                	jle    800f8c <_main+0xf54>
		{
			intArr[i] = i ;
		}
		if ((freeFrames - sys_calculate_free_frames()) != 768 + 2) panic("Wrong placement when accessing the allocated space");
  800fab:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800fae:	e8 02 1e 00 00       	call   802db5 <sys_calculate_free_frames>
  800fb3:	29 c3                	sub    %eax,%ebx
  800fb5:	89 d8                	mov    %ebx,%eax
  800fb7:	3d 02 03 00 00       	cmp    $0x302,%eax
  800fbc:	74 17                	je     800fd5 <_main+0xf9d>
  800fbe:	83 ec 04             	sub    $0x4,%esp
  800fc1:	68 d0 37 80 00       	push   $0x8037d0
  800fc6:	68 4c 01 00 00       	push   $0x14c
  800fcb:	68 b0 34 80 00       	push   $0x8034b0
  800fd0:	e8 62 03 00 00       	call   801337 <_panic>

		//Reallocate it to 4 MB, so that it can either fit at the 1st fragment or last one
		freeFrames = sys_calculate_free_frames() ;
  800fd5:	e8 db 1d 00 00       	call   802db5 <sys_calculate_free_frames>
  800fda:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800fdd:	e8 56 1e 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  800fe2:	89 45 d0             	mov    %eax,-0x30(%ebp)

		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  800fe5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fe8:	c1 e0 02             	shl    $0x2,%eax
  800feb:	2b 45 d8             	sub    -0x28(%ebp),%eax
  800fee:	89 c2                	mov    %eax,%edx
  800ff0:	8b 45 88             	mov    -0x78(%ebp),%eax
  800ff3:	83 ec 08             	sub    $0x8,%esp
  800ff6:	52                   	push   %edx
  800ff7:	50                   	push   %eax
  800ff8:	e8 6d 1c 00 00       	call   802c6a <realloc>
  800ffd:	83 c4 10             	add    $0x10,%esp
  801000:	89 45 88             	mov    %eax,-0x78(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega) && (uint32) ptr_allocations[7] != (USER_HEAP_START + 19*Mega)) panic("Wrong start address for the re-allocated space... ");
  801003:	8b 45 88             	mov    -0x78(%ebp),%eax
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80100b:	01 c0                	add    %eax,%eax
  80100d:	05 00 00 00 80       	add    $0x80000000,%eax
  801012:	39 c2                	cmp    %eax,%edx
  801014:	74 33                	je     801049 <_main+0x1011>
  801016:	8b 45 88             	mov    -0x78(%ebp),%eax
  801019:	89 c1                	mov    %eax,%ecx
  80101b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80101e:	89 d0                	mov    %edx,%eax
  801020:	c1 e0 03             	shl    $0x3,%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	01 c0                	add    %eax,%eax
  801027:	01 d0                	add    %edx,%eax
  801029:	05 00 00 00 80       	add    $0x80000000,%eax
  80102e:	39 c1                	cmp    %eax,%ecx
  801030:	74 17                	je     801049 <_main+0x1011>
  801032:	83 ec 04             	sub    $0x4,%esp
  801035:	68 78 38 80 00       	push   $0x803878
  80103a:	68 55 01 00 00       	push   $0x155
  80103f:	68 b0 34 80 00       	push   $0x8034b0
  801044:	e8 ee 02 00 00       	call   801337 <_panic>
		if ((uint32) ptr_allocations[7] == (USER_HEAP_START + 2*Mega))
  801049:	8b 45 88             	mov    -0x78(%ebp),%eax
  80104c:	89 c2                	mov    %eax,%edx
  80104e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801051:	01 c0                	add    %eax,%eax
  801053:	05 00 00 00 80       	add    $0x80000000,%eax
  801058:	39 c2                	cmp    %eax,%edx
  80105a:	75 2c                	jne    801088 <_main+0x1050>
		{
			if ((sys_calculate_free_frames() - freeFrames) != 768 + 2) panic("Wrong re-allocation: either extra pages are allocated in memory or pages not removed correctly when moving the reallocated block");
  80105c:	e8 54 1d 00 00       	call   802db5 <sys_calculate_free_frames>
  801061:	89 c2                	mov    %eax,%edx
  801063:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801066:	29 c2                	sub    %eax,%edx
  801068:	89 d0                	mov    %edx,%eax
  80106a:	3d 02 03 00 00       	cmp    $0x302,%eax
  80106f:	74 5f                	je     8010d0 <_main+0x1098>
  801071:	83 ec 04             	sub    $0x4,%esp
  801074:	68 88 39 80 00       	push   $0x803988
  801079:	68 58 01 00 00       	push   $0x158
  80107e:	68 b0 34 80 00       	push   $0x8034b0
  801083:	e8 af 02 00 00       	call   801337 <_panic>
		}
		else if ((uint32) ptr_allocations[7] == (USER_HEAP_START + 19*Mega))
  801088:	8b 45 88             	mov    -0x78(%ebp),%eax
  80108b:	89 c1                	mov    %eax,%ecx
  80108d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801090:	89 d0                	mov    %edx,%eax
  801092:	c1 e0 03             	shl    $0x3,%eax
  801095:	01 d0                	add    %edx,%eax
  801097:	01 c0                	add    %eax,%eax
  801099:	01 d0                	add    %edx,%eax
  80109b:	05 00 00 00 80       	add    $0x80000000,%eax
  8010a0:	39 c1                	cmp    %eax,%ecx
  8010a2:	75 2c                	jne    8010d0 <_main+0x1098>
		{
			if ((sys_calculate_free_frames() - freeFrames) != 768 + 2 - 1) panic("Wrong re-allocation: either extra pages are allocated in memory or pages not removed correctly when moving the reallocated block");
  8010a4:	e8 0c 1d 00 00       	call   802db5 <sys_calculate_free_frames>
  8010a9:	89 c2                	mov    %eax,%edx
  8010ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010ae:	29 c2                	sub    %eax,%edx
  8010b0:	89 d0                	mov    %edx,%eax
  8010b2:	3d 01 03 00 00       	cmp    $0x301,%eax
  8010b7:	74 17                	je     8010d0 <_main+0x1098>
  8010b9:	83 ec 04             	sub    $0x4,%esp
  8010bc:	68 88 39 80 00       	push   $0x803988
  8010c1:	68 5c 01 00 00       	push   $0x15c
  8010c6:	68 b0 34 80 00       	push   $0x8034b0
  8010cb:	e8 67 02 00 00       	call   801337 <_panic>
		}
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8010d0:	e8 63 1d 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8010d5:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8010d8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010dd:	74 17                	je     8010f6 <_main+0x10be>
  8010df:	83 ec 04             	sub    $0x4,%esp
  8010e2:	68 b0 35 80 00       	push   $0x8035b0
  8010e7:	68 5e 01 00 00       	push   $0x15e
  8010ec:	68 b0 34 80 00       	push   $0x8034b0
  8010f1:	e8 41 02 00 00       	call   801337 <_panic>

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
  8010f6:	e8 ba 1c 00 00       	call   802db5 <sys_calculate_free_frames>
  8010fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  8010fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801101:	c1 e0 02             	shl    $0x2,%eax
  801104:	c1 e8 02             	shr    $0x2,%eax
  801107:	48                   	dec    %eax
  801108:	89 45 bc             	mov    %eax,-0x44(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80110e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for (i=lastIndexOfInt1+1; i < lastIndexOfInt2 ; i++)
  801111:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801114:	40                   	inc    %eax
  801115:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801118:	eb 17                	jmp    801131 <_main+0x10f9>
		{
			intArr[i] = i ;
  80111a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80111d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801124:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801127:	01 c2                	add    %eax,%edx
  801129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80112c:	89 02                	mov    %eax,(%edx)

		//[2] test memory access
		freeFrames = sys_calculate_free_frames() ;
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1+1; i < lastIndexOfInt2 ; i++)
  80112e:	ff 45 e8             	incl   -0x18(%ebp)
  801131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801134:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801137:	7c e1                	jl     80111a <_main+0x10e2>
		{
			intArr[i] = i ;
		}

		if ((freeFrames - sys_calculate_free_frames()) != 256 + 1) panic("Wrong placement when accessing the allocated space");
  801139:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80113c:	e8 74 1c 00 00       	call   802db5 <sys_calculate_free_frames>
  801141:	29 c3                	sub    %eax,%ebx
  801143:	89 d8                	mov    %ebx,%eax
  801145:	3d 01 01 00 00       	cmp    $0x101,%eax
  80114a:	74 17                	je     801163 <_main+0x112b>
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	68 d0 37 80 00       	push   $0x8037d0
  801154:	68 69 01 00 00       	push   $0x169
  801159:	68 b0 34 80 00       	push   $0x8034b0
  80115e:	e8 d4 01 00 00       	call   801337 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801163:	e8 4d 1c 00 00       	call   802db5 <sys_calculate_free_frames>
  801168:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i=0; i < lastIndexOfInt2 ; i++)
  80116b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801172:	eb 33                	jmp    8011a7 <_main+0x116f>
		{
			cnt++;
  801174:	ff 45 ec             	incl   -0x14(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80117a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801181:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	8b 00                	mov    (%eax),%eax
  801188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80118b:	74 17                	je     8011a4 <_main+0x116c>
  80118d:	83 ec 04             	sub    $0x4,%esp
  801190:	68 04 38 80 00       	push   $0x803804
  801195:	68 6f 01 00 00       	push   $0x16f
  80119a:	68 b0 34 80 00       	push   $0x8034b0
  80119f:	e8 93 01 00 00       	call   801337 <_panic>
		}

		if ((freeFrames - sys_calculate_free_frames()) != 256 + 1) panic("Wrong placement when accessing the allocated space");

		freeFrames = sys_calculate_free_frames() ;
		for (i=0; i < lastIndexOfInt2 ; i++)
  8011a4:	ff 45 e8             	incl   -0x18(%ebp)
  8011a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011aa:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8011ad:	7c c5                	jl     801174 <_main+0x113c>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong placement when accessing the allocated space");
  8011af:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8011b2:	e8 fe 1b 00 00       	call   802db5 <sys_calculate_free_frames>
  8011b7:	29 c3                	sub    %eax,%ebx
  8011b9:	89 d8                	mov    %ebx,%eax
  8011bb:	3d 01 03 00 00       	cmp    $0x301,%eax
  8011c0:	74 17                	je     8011d9 <_main+0x11a1>
  8011c2:	83 ec 04             	sub    $0x4,%esp
  8011c5:	68 d0 37 80 00       	push   $0x8037d0
  8011ca:	68 71 01 00 00       	push   $0x171
  8011cf:	68 b0 34 80 00       	push   $0x8034b0
  8011d4:	e8 5e 01 00 00       	call   801337 <_panic>

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8011d9:	e8 d7 1b 00 00       	call   802db5 <sys_calculate_free_frames>
  8011de:	89 45 cc             	mov    %eax,-0x34(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8011e1:	e8 52 1c 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  8011e6:	89 45 d0             	mov    %eax,-0x30(%ebp)

		free(ptr_allocations[7]);
  8011e9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8011ec:	83 ec 0c             	sub    $0xc,%esp
  8011ef:	50                   	push   %eax
  8011f0:	e8 92 19 00 00       	call   802b87 <free>
  8011f5:	83 c4 10             	add    $0x10,%esp

		if ((sys_calculate_free_frames() - freeFrames) != 1024+2) panic("Wrong free of the re-allocated space");
  8011f8:	e8 b8 1b 00 00       	call   802db5 <sys_calculate_free_frames>
  8011fd:	89 c2                	mov    %eax,%edx
  8011ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801202:	29 c2                	sub    %eax,%edx
  801204:	89 d0                	mov    %edx,%eax
  801206:	3d 02 04 00 00       	cmp    $0x402,%eax
  80120b:	74 17                	je     801224 <_main+0x11ec>
  80120d:	83 ec 04             	sub    $0x4,%esp
  801210:	68 ac 38 80 00       	push   $0x8038ac
  801215:	68 79 01 00 00       	push   $0x179
  80121a:	68 b0 34 80 00       	push   $0x8034b0
  80121f:	e8 13 01 00 00       	call   801337 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free: Extra or less pages are removed from PageFile");
  801224:	e8 0f 1c 00 00       	call   802e38 <sys_pf_calculate_allocated_pages>
  801229:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80122c:	29 c2                	sub    %eax,%edx
  80122e:	89 d0                	mov    %edx,%eax
  801230:	3d 00 04 00 00       	cmp    $0x400,%eax
  801235:	74 17                	je     80124e <_main+0x1216>
  801237:	83 ec 04             	sub    $0x4,%esp
  80123a:	68 0c 36 80 00       	push   $0x80360c
  80123f:	68 7a 01 00 00       	push   $0x17a
  801244:	68 b0 34 80 00       	push   $0x8034b0
  801249:	e8 e9 00 00 00       	call   801337 <_panic>

		cprintf("CASE5: (Re-allocate that only fit in the 1st or last segment) is succeeded...\n") ;
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	68 0c 3a 80 00       	push   $0x803a0c
  801256:	e8 07 02 00 00       	call   801462 <cprintf>
  80125b:	83 c4 10             	add    $0x10,%esp

	}


	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	68 5c 3a 80 00       	push   $0x803a5c
  801266:	e8 f7 01 00 00       	call   801462 <cprintf>
  80126b:	83 c4 10             	add    $0x10,%esp

	return;
  80126e:	90                   	nop
}
  80126f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801272:	5b                   	pop    %ebx
  801273:	5f                   	pop    %edi
  801274:	5d                   	pop    %ebp
  801275:	c3                   	ret    

00801276 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80127c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801280:	7e 0a                	jle    80128c <libmain+0x16>
		binaryname = argv[0];
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	ff 75 0c             	pushl  0xc(%ebp)
  801292:	ff 75 08             	pushl  0x8(%ebp)
  801295:	e8 9e ed ff ff       	call   800038 <_main>
  80129a:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80129d:	e8 61 1a 00 00       	call   802d03 <sys_getenvid>
  8012a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8012a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a8:	89 d0                	mov    %edx,%eax
  8012aa:	c1 e0 03             	shl    $0x3,%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	01 c0                	add    %eax,%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c1 e0 03             	shl    $0x3,%eax
  8012bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012c4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8012c7:	e8 85 1b 00 00       	call   802e51 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8012cc:	83 ec 0c             	sub    $0xc,%esp
  8012cf:	68 b0 3a 80 00       	push   $0x803ab0
  8012d4:	e8 89 01 00 00       	call   801462 <cprintf>
  8012d9:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8012dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012df:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8012e5:	83 ec 08             	sub    $0x8,%esp
  8012e8:	50                   	push   %eax
  8012e9:	68 d8 3a 80 00       	push   $0x803ad8
  8012ee:	e8 6f 01 00 00       	call   801462 <cprintf>
  8012f3:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8012f6:	83 ec 0c             	sub    $0xc,%esp
  8012f9:	68 b0 3a 80 00       	push   $0x803ab0
  8012fe:	e8 5f 01 00 00       	call   801462 <cprintf>
  801303:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801306:	e8 60 1b 00 00       	call   802e6b <sys_enable_interrupt>

	// exit gracefully
	exit();
  80130b:	e8 19 00 00 00       	call   801329 <exit>
}
  801310:	90                   	nop
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  801319:	83 ec 0c             	sub    $0xc,%esp
  80131c:	6a 00                	push   $0x0
  80131e:	e8 c5 19 00 00       	call   802ce8 <sys_env_destroy>
  801323:	83 c4 10             	add    $0x10,%esp
}
  801326:	90                   	nop
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <exit>:

void
exit(void)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
  80132c:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80132f:	e8 e8 19 00 00       	call   802d1c <sys_env_exit>
}
  801334:	90                   	nop
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80133d:	8d 45 10             	lea    0x10(%ebp),%eax
  801340:	83 c0 04             	add    $0x4,%eax
  801343:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  801346:	a1 50 40 98 00       	mov    0x984050,%eax
  80134b:	85 c0                	test   %eax,%eax
  80134d:	74 16                	je     801365 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80134f:	a1 50 40 98 00       	mov    0x984050,%eax
  801354:	83 ec 08             	sub    $0x8,%esp
  801357:	50                   	push   %eax
  801358:	68 f1 3a 80 00       	push   $0x803af1
  80135d:	e8 00 01 00 00       	call   801462 <cprintf>
  801362:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801365:	a1 00 40 80 00       	mov    0x804000,%eax
  80136a:	ff 75 0c             	pushl  0xc(%ebp)
  80136d:	ff 75 08             	pushl  0x8(%ebp)
  801370:	50                   	push   %eax
  801371:	68 f6 3a 80 00       	push   $0x803af6
  801376:	e8 e7 00 00 00       	call   801462 <cprintf>
  80137b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	ff 75 f4             	pushl  -0xc(%ebp)
  801387:	50                   	push   %eax
  801388:	e8 7a 00 00 00       	call   801407 <vcprintf>
  80138d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  801390:	83 ec 0c             	sub    $0xc,%esp
  801393:	68 12 3b 80 00       	push   $0x803b12
  801398:	e8 c5 00 00 00       	call   801462 <cprintf>
  80139d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8013a0:	e8 84 ff ff ff       	call   801329 <exit>

	// should not return here
	while (1) ;
  8013a5:	eb fe                	jmp    8013a5 <_panic+0x6e>

008013a7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b8:	89 0a                	mov    %ecx,(%edx)
  8013ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bd:	88 d1                	mov    %dl,%cl
  8013bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8b 00                	mov    (%eax),%eax
  8013cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8013d0:	75 23                	jne    8013f5 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	89 c2                	mov    %eax,%edx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	83 c0 08             	add    $0x8,%eax
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	52                   	push   %edx
  8013e3:	50                   	push   %eax
  8013e4:	e8 c9 18 00 00       	call   802cb2 <sys_cputs>
  8013e9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	8b 40 04             	mov    0x4(%eax),%eax
  8013fb:	8d 50 01             	lea    0x1(%eax),%edx
  8013fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801401:	89 50 04             	mov    %edx,0x4(%eax)
}
  801404:	90                   	nop
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801410:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801417:	00 00 00 
	b.cnt = 0;
  80141a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801421:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801424:	ff 75 0c             	pushl  0xc(%ebp)
  801427:	ff 75 08             	pushl  0x8(%ebp)
  80142a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801430:	50                   	push   %eax
  801431:	68 a7 13 80 00       	push   $0x8013a7
  801436:	e8 fa 01 00 00       	call   801635 <vprintfmt>
  80143b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80143e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801444:	83 ec 08             	sub    $0x8,%esp
  801447:	50                   	push   %eax
  801448:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80144e:	83 c0 08             	add    $0x8,%eax
  801451:	50                   	push   %eax
  801452:	e8 5b 18 00 00       	call   802cb2 <sys_cputs>
  801457:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80145a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <cprintf>:

int cprintf(const char *fmt, ...) {
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801468:	8d 45 0c             	lea    0xc(%ebp),%eax
  80146b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	ff 75 f4             	pushl  -0xc(%ebp)
  801477:	50                   	push   %eax
  801478:	e8 8a ff ff ff       	call   801407 <vcprintf>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801483:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80148e:	e8 be 19 00 00       	call   802e51 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801493:	8d 45 0c             	lea    0xc(%ebp),%eax
  801496:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	83 ec 08             	sub    $0x8,%esp
  80149f:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a2:	50                   	push   %eax
  8014a3:	e8 5f ff ff ff       	call   801407 <vcprintf>
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8014ae:	e8 b8 19 00 00       	call   802e6b <sys_enable_interrupt>
	return cnt;
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
  8014bb:	53                   	push   %ebx
  8014bc:	83 ec 14             	sub    $0x14,%esp
  8014bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8014cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8014ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8014d6:	77 55                	ja     80152d <printnum+0x75>
  8014d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8014db:	72 05                	jb     8014e2 <printnum+0x2a>
  8014dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e0:	77 4b                	ja     80152d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8014e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8014e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8014e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8014eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f0:	52                   	push   %edx
  8014f1:	50                   	push   %eax
  8014f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f8:	e8 f3 1c 00 00       	call   8031f0 <__udivdi3>
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	ff 75 20             	pushl  0x20(%ebp)
  801506:	53                   	push   %ebx
  801507:	ff 75 18             	pushl  0x18(%ebp)
  80150a:	52                   	push   %edx
  80150b:	50                   	push   %eax
  80150c:	ff 75 0c             	pushl  0xc(%ebp)
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	e8 a1 ff ff ff       	call   8014b8 <printnum>
  801517:	83 c4 20             	add    $0x20,%esp
  80151a:	eb 1a                	jmp    801536 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80151c:	83 ec 08             	sub    $0x8,%esp
  80151f:	ff 75 0c             	pushl  0xc(%ebp)
  801522:	ff 75 20             	pushl  0x20(%ebp)
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	ff d0                	call   *%eax
  80152a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80152d:	ff 4d 1c             	decl   0x1c(%ebp)
  801530:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801534:	7f e6                	jg     80151c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801536:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801539:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801544:	53                   	push   %ebx
  801545:	51                   	push   %ecx
  801546:	52                   	push   %edx
  801547:	50                   	push   %eax
  801548:	e8 b3 1d 00 00       	call   803300 <__umoddi3>
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	05 34 3d 80 00       	add    $0x803d34,%eax
  801555:	8a 00                	mov    (%eax),%al
  801557:	0f be c0             	movsbl %al,%eax
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	ff 75 0c             	pushl  0xc(%ebp)
  801560:	50                   	push   %eax
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	ff d0                	call   *%eax
  801566:	83 c4 10             	add    $0x10,%esp
}
  801569:	90                   	nop
  80156a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801572:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801576:	7e 1c                	jle    801594 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	8b 00                	mov    (%eax),%eax
  80157d:	8d 50 08             	lea    0x8(%eax),%edx
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	89 10                	mov    %edx,(%eax)
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	83 e8 08             	sub    $0x8,%eax
  80158d:	8b 50 04             	mov    0x4(%eax),%edx
  801590:	8b 00                	mov    (%eax),%eax
  801592:	eb 40                	jmp    8015d4 <getuint+0x65>
	else if (lflag)
  801594:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801598:	74 1e                	je     8015b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8b 00                	mov    (%eax),%eax
  80159f:	8d 50 04             	lea    0x4(%eax),%edx
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 10                	mov    %edx,(%eax)
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	8b 00                	mov    (%eax),%eax
  8015ac:	83 e8 04             	sub    $0x4,%eax
  8015af:	8b 00                	mov    (%eax),%eax
  8015b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b6:	eb 1c                	jmp    8015d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	8b 00                	mov    (%eax),%eax
  8015bd:	8d 50 04             	lea    0x4(%eax),%edx
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	89 10                	mov    %edx,(%eax)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8b 00                	mov    (%eax),%eax
  8015ca:	83 e8 04             	sub    $0x4,%eax
  8015cd:	8b 00                	mov    (%eax),%eax
  8015cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8015d4:	5d                   	pop    %ebp
  8015d5:	c3                   	ret    

008015d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015dd:	7e 1c                	jle    8015fb <getint+0x25>
		return va_arg(*ap, long long);
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8b 00                	mov    (%eax),%eax
  8015e4:	8d 50 08             	lea    0x8(%eax),%edx
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	89 10                	mov    %edx,(%eax)
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	8b 00                	mov    (%eax),%eax
  8015f1:	83 e8 08             	sub    $0x8,%eax
  8015f4:	8b 50 04             	mov    0x4(%eax),%edx
  8015f7:	8b 00                	mov    (%eax),%eax
  8015f9:	eb 38                	jmp    801633 <getint+0x5d>
	else if (lflag)
  8015fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ff:	74 1a                	je     80161b <getint+0x45>
		return va_arg(*ap, long);
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8b 00                	mov    (%eax),%eax
  801606:	8d 50 04             	lea    0x4(%eax),%edx
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	89 10                	mov    %edx,(%eax)
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	8b 00                	mov    (%eax),%eax
  801613:	83 e8 04             	sub    $0x4,%eax
  801616:	8b 00                	mov    (%eax),%eax
  801618:	99                   	cltd   
  801619:	eb 18                	jmp    801633 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8b 00                	mov    (%eax),%eax
  801620:	8d 50 04             	lea    0x4(%eax),%edx
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	89 10                	mov    %edx,(%eax)
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	83 e8 04             	sub    $0x4,%eax
  801630:	8b 00                	mov    (%eax),%eax
  801632:	99                   	cltd   
}
  801633:	5d                   	pop    %ebp
  801634:	c3                   	ret    

00801635 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	56                   	push   %esi
  801639:	53                   	push   %ebx
  80163a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80163d:	eb 17                	jmp    801656 <vprintfmt+0x21>
			if (ch == '\0')
  80163f:	85 db                	test   %ebx,%ebx
  801641:	0f 84 af 03 00 00    	je     8019f6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	53                   	push   %ebx
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	ff d0                	call   *%eax
  801653:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801656:	8b 45 10             	mov    0x10(%ebp),%eax
  801659:	8d 50 01             	lea    0x1(%eax),%edx
  80165c:	89 55 10             	mov    %edx,0x10(%ebp)
  80165f:	8a 00                	mov    (%eax),%al
  801661:	0f b6 d8             	movzbl %al,%ebx
  801664:	83 fb 25             	cmp    $0x25,%ebx
  801667:	75 d6                	jne    80163f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801669:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80166d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801674:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80167b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801682:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801689:	8b 45 10             	mov    0x10(%ebp),%eax
  80168c:	8d 50 01             	lea    0x1(%eax),%edx
  80168f:	89 55 10             	mov    %edx,0x10(%ebp)
  801692:	8a 00                	mov    (%eax),%al
  801694:	0f b6 d8             	movzbl %al,%ebx
  801697:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80169a:	83 f8 55             	cmp    $0x55,%eax
  80169d:	0f 87 2b 03 00 00    	ja     8019ce <vprintfmt+0x399>
  8016a3:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
  8016aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8016ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8016b0:	eb d7                	jmp    801689 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8016b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8016b6:	eb d1                	jmp    801689 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8016bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016c2:	89 d0                	mov    %edx,%eax
  8016c4:	c1 e0 02             	shl    $0x2,%eax
  8016c7:	01 d0                	add    %edx,%eax
  8016c9:	01 c0                	add    %eax,%eax
  8016cb:	01 d8                	add    %ebx,%eax
  8016cd:	83 e8 30             	sub    $0x30,%eax
  8016d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8016d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8016db:	83 fb 2f             	cmp    $0x2f,%ebx
  8016de:	7e 3e                	jle    80171e <vprintfmt+0xe9>
  8016e0:	83 fb 39             	cmp    $0x39,%ebx
  8016e3:	7f 39                	jg     80171e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8016e8:	eb d5                	jmp    8016bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8016ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ed:	83 c0 04             	add    $0x4,%eax
  8016f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8016f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f6:	83 e8 04             	sub    $0x4,%eax
  8016f9:	8b 00                	mov    (%eax),%eax
  8016fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8016fe:	eb 1f                	jmp    80171f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801700:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801704:	79 83                	jns    801689 <vprintfmt+0x54>
				width = 0;
  801706:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80170d:	e9 77 ff ff ff       	jmp    801689 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801712:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801719:	e9 6b ff ff ff       	jmp    801689 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80171e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80171f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801723:	0f 89 60 ff ff ff    	jns    801689 <vprintfmt+0x54>
				width = precision, precision = -1;
  801729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80172f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801736:	e9 4e ff ff ff       	jmp    801689 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80173b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80173e:	e9 46 ff ff ff       	jmp    801689 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801743:	8b 45 14             	mov    0x14(%ebp),%eax
  801746:	83 c0 04             	add    $0x4,%eax
  801749:	89 45 14             	mov    %eax,0x14(%ebp)
  80174c:	8b 45 14             	mov    0x14(%ebp),%eax
  80174f:	83 e8 04             	sub    $0x4,%eax
  801752:	8b 00                	mov    (%eax),%eax
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	50                   	push   %eax
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	ff d0                	call   *%eax
  801760:	83 c4 10             	add    $0x10,%esp
			break;
  801763:	e9 89 02 00 00       	jmp    8019f1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801768:	8b 45 14             	mov    0x14(%ebp),%eax
  80176b:	83 c0 04             	add    $0x4,%eax
  80176e:	89 45 14             	mov    %eax,0x14(%ebp)
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	83 e8 04             	sub    $0x4,%eax
  801777:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801779:	85 db                	test   %ebx,%ebx
  80177b:	79 02                	jns    80177f <vprintfmt+0x14a>
				err = -err;
  80177d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80177f:	83 fb 64             	cmp    $0x64,%ebx
  801782:	7f 0b                	jg     80178f <vprintfmt+0x15a>
  801784:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  80178b:	85 f6                	test   %esi,%esi
  80178d:	75 19                	jne    8017a8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80178f:	53                   	push   %ebx
  801790:	68 45 3d 80 00       	push   $0x803d45
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	ff 75 08             	pushl  0x8(%ebp)
  80179b:	e8 5e 02 00 00       	call   8019fe <printfmt>
  8017a0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8017a3:	e9 49 02 00 00       	jmp    8019f1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8017a8:	56                   	push   %esi
  8017a9:	68 4e 3d 80 00       	push   $0x803d4e
  8017ae:	ff 75 0c             	pushl  0xc(%ebp)
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	e8 45 02 00 00       	call   8019fe <printfmt>
  8017b9:	83 c4 10             	add    $0x10,%esp
			break;
  8017bc:	e9 30 02 00 00       	jmp    8019f1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8017c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c4:	83 c0 04             	add    $0x4,%eax
  8017c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8017ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cd:	83 e8 04             	sub    $0x4,%eax
  8017d0:	8b 30                	mov    (%eax),%esi
  8017d2:	85 f6                	test   %esi,%esi
  8017d4:	75 05                	jne    8017db <vprintfmt+0x1a6>
				p = "(null)";
  8017d6:	be 51 3d 80 00       	mov    $0x803d51,%esi
			if (width > 0 && padc != '-')
  8017db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017df:	7e 6d                	jle    80184e <vprintfmt+0x219>
  8017e1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8017e5:	74 67                	je     80184e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	50                   	push   %eax
  8017ee:	56                   	push   %esi
  8017ef:	e8 0c 03 00 00       	call   801b00 <strnlen>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8017fa:	eb 16                	jmp    801812 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8017fc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	ff 75 0c             	pushl  0xc(%ebp)
  801806:	50                   	push   %eax
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	ff d0                	call   *%eax
  80180c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80180f:	ff 4d e4             	decl   -0x1c(%ebp)
  801812:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801816:	7f e4                	jg     8017fc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801818:	eb 34                	jmp    80184e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80181a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80181e:	74 1c                	je     80183c <vprintfmt+0x207>
  801820:	83 fb 1f             	cmp    $0x1f,%ebx
  801823:	7e 05                	jle    80182a <vprintfmt+0x1f5>
  801825:	83 fb 7e             	cmp    $0x7e,%ebx
  801828:	7e 12                	jle    80183c <vprintfmt+0x207>
					putch('?', putdat);
  80182a:	83 ec 08             	sub    $0x8,%esp
  80182d:	ff 75 0c             	pushl  0xc(%ebp)
  801830:	6a 3f                	push   $0x3f
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	ff d0                	call   *%eax
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	eb 0f                	jmp    80184b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80183c:	83 ec 08             	sub    $0x8,%esp
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	53                   	push   %ebx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	ff d0                	call   *%eax
  801848:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80184b:	ff 4d e4             	decl   -0x1c(%ebp)
  80184e:	89 f0                	mov    %esi,%eax
  801850:	8d 70 01             	lea    0x1(%eax),%esi
  801853:	8a 00                	mov    (%eax),%al
  801855:	0f be d8             	movsbl %al,%ebx
  801858:	85 db                	test   %ebx,%ebx
  80185a:	74 24                	je     801880 <vprintfmt+0x24b>
  80185c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801860:	78 b8                	js     80181a <vprintfmt+0x1e5>
  801862:	ff 4d e0             	decl   -0x20(%ebp)
  801865:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801869:	79 af                	jns    80181a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80186b:	eb 13                	jmp    801880 <vprintfmt+0x24b>
				putch(' ', putdat);
  80186d:	83 ec 08             	sub    $0x8,%esp
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	6a 20                	push   $0x20
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	ff d0                	call   *%eax
  80187a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80187d:	ff 4d e4             	decl   -0x1c(%ebp)
  801880:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801884:	7f e7                	jg     80186d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801886:	e9 66 01 00 00       	jmp    8019f1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	ff 75 e8             	pushl  -0x18(%ebp)
  801891:	8d 45 14             	lea    0x14(%ebp),%eax
  801894:	50                   	push   %eax
  801895:	e8 3c fd ff ff       	call   8015d6 <getint>
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8018a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a9:	85 d2                	test   %edx,%edx
  8018ab:	79 23                	jns    8018d0 <vprintfmt+0x29b>
				putch('-', putdat);
  8018ad:	83 ec 08             	sub    $0x8,%esp
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	6a 2d                	push   $0x2d
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	ff d0                	call   *%eax
  8018ba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8018bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c3:	f7 d8                	neg    %eax
  8018c5:	83 d2 00             	adc    $0x0,%edx
  8018c8:	f7 da                	neg    %edx
  8018ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8018d0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8018d7:	e9 bc 00 00 00       	jmp    801998 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	ff 75 e8             	pushl  -0x18(%ebp)
  8018e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8018e5:	50                   	push   %eax
  8018e6:	e8 84 fc ff ff       	call   80156f <getuint>
  8018eb:	83 c4 10             	add    $0x10,%esp
  8018ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8018f4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8018fb:	e9 98 00 00 00       	jmp    801998 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801900:	83 ec 08             	sub    $0x8,%esp
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	6a 58                	push   $0x58
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	ff d0                	call   *%eax
  80190d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	6a 58                	push   $0x58
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	ff d0                	call   *%eax
  80191d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	6a 58                	push   $0x58
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	ff d0                	call   *%eax
  80192d:	83 c4 10             	add    $0x10,%esp
			break;
  801930:	e9 bc 00 00 00       	jmp    8019f1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	6a 30                	push   $0x30
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	ff d0                	call   *%eax
  801942:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801945:	83 ec 08             	sub    $0x8,%esp
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	6a 78                	push   $0x78
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	ff d0                	call   *%eax
  801952:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801955:	8b 45 14             	mov    0x14(%ebp),%eax
  801958:	83 c0 04             	add    $0x4,%eax
  80195b:	89 45 14             	mov    %eax,0x14(%ebp)
  80195e:	8b 45 14             	mov    0x14(%ebp),%eax
  801961:	83 e8 04             	sub    $0x4,%eax
  801964:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801969:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801970:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801977:	eb 1f                	jmp    801998 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801979:	83 ec 08             	sub    $0x8,%esp
  80197c:	ff 75 e8             	pushl  -0x18(%ebp)
  80197f:	8d 45 14             	lea    0x14(%ebp),%eax
  801982:	50                   	push   %eax
  801983:	e8 e7 fb ff ff       	call   80156f <getuint>
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80198e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801991:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801998:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80199c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	52                   	push   %edx
  8019a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019a6:	50                   	push   %eax
  8019a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	e8 00 fb ff ff       	call   8014b8 <printnum>
  8019b8:	83 c4 20             	add    $0x20,%esp
			break;
  8019bb:	eb 34                	jmp    8019f1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8019bd:	83 ec 08             	sub    $0x8,%esp
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	53                   	push   %ebx
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	ff d0                	call   *%eax
  8019c9:	83 c4 10             	add    $0x10,%esp
			break;
  8019cc:	eb 23                	jmp    8019f1 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8019ce:	83 ec 08             	sub    $0x8,%esp
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	6a 25                	push   $0x25
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	ff d0                	call   *%eax
  8019db:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8019de:	ff 4d 10             	decl   0x10(%ebp)
  8019e1:	eb 03                	jmp    8019e6 <vprintfmt+0x3b1>
  8019e3:	ff 4d 10             	decl   0x10(%ebp)
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	48                   	dec    %eax
  8019ea:	8a 00                	mov    (%eax),%al
  8019ec:	3c 25                	cmp    $0x25,%al
  8019ee:	75 f3                	jne    8019e3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8019f0:	90                   	nop
		}
	}
  8019f1:	e9 47 fc ff ff       	jmp    80163d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8019f6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8019f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    

008019fe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a04:	8d 45 10             	lea    0x10(%ebp),%eax
  801a07:	83 c0 04             	add    $0x4,%eax
  801a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a10:	ff 75 f4             	pushl  -0xc(%ebp)
  801a13:	50                   	push   %eax
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	ff 75 08             	pushl  0x8(%ebp)
  801a1a:	e8 16 fc ff ff       	call   801635 <vprintfmt>
  801a1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2b:	8b 40 08             	mov    0x8(%eax),%eax
  801a2e:	8d 50 01             	lea    0x1(%eax),%edx
  801a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3a:	8b 10                	mov    (%eax),%edx
  801a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3f:	8b 40 04             	mov    0x4(%eax),%eax
  801a42:	39 c2                	cmp    %eax,%edx
  801a44:	73 12                	jae    801a58 <sprintputch+0x33>
		*b->buf++ = ch;
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	8b 00                	mov    (%eax),%eax
  801a4b:	8d 48 01             	lea    0x1(%eax),%ecx
  801a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a51:	89 0a                	mov    %ecx,(%edx)
  801a53:	8b 55 08             	mov    0x8(%ebp),%edx
  801a56:	88 10                	mov    %dl,(%eax)
}
  801a58:	90                   	nop
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    

00801a5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	01 d0                	add    %edx,%eax
  801a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801a7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a80:	74 06                	je     801a88 <vsnprintf+0x2d>
  801a82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a86:	7f 07                	jg     801a8f <vsnprintf+0x34>
		return -E_INVAL;
  801a88:	b8 03 00 00 00       	mov    $0x3,%eax
  801a8d:	eb 20                	jmp    801aaf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801a8f:	ff 75 14             	pushl  0x14(%ebp)
  801a92:	ff 75 10             	pushl  0x10(%ebp)
  801a95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a98:	50                   	push   %eax
  801a99:	68 25 1a 80 00       	push   $0x801a25
  801a9e:	e8 92 fb ff ff       	call   801635 <vprintfmt>
  801aa3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ab7:	8d 45 10             	lea    0x10(%ebp),%eax
  801aba:	83 c0 04             	add    $0x4,%eax
  801abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac6:	50                   	push   %eax
  801ac7:	ff 75 0c             	pushl  0xc(%ebp)
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	e8 89 ff ff ff       	call   801a5b <vsnprintf>
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ae3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aea:	eb 06                	jmp    801af2 <strlen+0x15>
		n++;
  801aec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801aef:	ff 45 08             	incl   0x8(%ebp)
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	84 c0                	test   %al,%al
  801af9:	75 f1                	jne    801aec <strlen+0xf>
		n++;
	return n;
  801afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b0d:	eb 09                	jmp    801b18 <strnlen+0x18>
		n++;
  801b0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b12:	ff 45 08             	incl   0x8(%ebp)
  801b15:	ff 4d 0c             	decl   0xc(%ebp)
  801b18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b1c:	74 09                	je     801b27 <strnlen+0x27>
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	8a 00                	mov    (%eax),%al
  801b23:	84 c0                	test   %al,%al
  801b25:	75 e8                	jne    801b0f <strnlen+0xf>
		n++;
	return n;
  801b27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801b38:	90                   	nop
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	8d 50 01             	lea    0x1(%eax),%edx
  801b3f:	89 55 08             	mov    %edx,0x8(%ebp)
  801b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b45:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801b4b:	8a 12                	mov    (%edx),%dl
  801b4d:	88 10                	mov    %dl,(%eax)
  801b4f:	8a 00                	mov    (%eax),%al
  801b51:	84 c0                	test   %al,%al
  801b53:	75 e4                	jne    801b39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801b55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801b66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b6d:	eb 1f                	jmp    801b8e <strncpy+0x34>
		*dst++ = *src;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	8d 50 01             	lea    0x1(%eax),%edx
  801b75:	89 55 08             	mov    %edx,0x8(%ebp)
  801b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7b:	8a 12                	mov    (%edx),%dl
  801b7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b82:	8a 00                	mov    (%eax),%al
  801b84:	84 c0                	test   %al,%al
  801b86:	74 03                	je     801b8b <strncpy+0x31>
			src++;
  801b88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801b8b:	ff 45 fc             	incl   -0x4(%ebp)
  801b8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b91:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b94:	72 d9                	jb     801b6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801b96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801ba7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bab:	74 30                	je     801bdd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801bad:	eb 16                	jmp    801bc5 <strlcpy+0x2a>
			*dst++ = *src++;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	8d 50 01             	lea    0x1(%eax),%edx
  801bb5:	89 55 08             	mov    %edx,0x8(%ebp)
  801bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbb:	8d 4a 01             	lea    0x1(%edx),%ecx
  801bbe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801bc1:	8a 12                	mov    (%edx),%dl
  801bc3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801bc5:	ff 4d 10             	decl   0x10(%ebp)
  801bc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bcc:	74 09                	je     801bd7 <strlcpy+0x3c>
  801bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd1:	8a 00                	mov    (%eax),%al
  801bd3:	84 c0                	test   %al,%al
  801bd5:	75 d8                	jne    801baf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  801be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be3:	29 c2                	sub    %eax,%edx
  801be5:	89 d0                	mov    %edx,%eax
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801bec:	eb 06                	jmp    801bf4 <strcmp+0xb>
		p++, q++;
  801bee:	ff 45 08             	incl   0x8(%ebp)
  801bf1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	8a 00                	mov    (%eax),%al
  801bf9:	84 c0                	test   %al,%al
  801bfb:	74 0e                	je     801c0b <strcmp+0x22>
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	8a 10                	mov    (%eax),%dl
  801c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c05:	8a 00                	mov    (%eax),%al
  801c07:	38 c2                	cmp    %al,%dl
  801c09:	74 e3                	je     801bee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	8a 00                	mov    (%eax),%al
  801c10:	0f b6 d0             	movzbl %al,%edx
  801c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c16:	8a 00                	mov    (%eax),%al
  801c18:	0f b6 c0             	movzbl %al,%eax
  801c1b:	29 c2                	sub    %eax,%edx
  801c1d:	89 d0                	mov    %edx,%eax
}
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    

00801c21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801c24:	eb 09                	jmp    801c2f <strncmp+0xe>
		n--, p++, q++;
  801c26:	ff 4d 10             	decl   0x10(%ebp)
  801c29:	ff 45 08             	incl   0x8(%ebp)
  801c2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801c2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c33:	74 17                	je     801c4c <strncmp+0x2b>
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	8a 00                	mov    (%eax),%al
  801c3a:	84 c0                	test   %al,%al
  801c3c:	74 0e                	je     801c4c <strncmp+0x2b>
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	8a 10                	mov    (%eax),%dl
  801c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c46:	8a 00                	mov    (%eax),%al
  801c48:	38 c2                	cmp    %al,%dl
  801c4a:	74 da                	je     801c26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801c4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c50:	75 07                	jne    801c59 <strncmp+0x38>
		return 0;
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
  801c57:	eb 14                	jmp    801c6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	8a 00                	mov    (%eax),%al
  801c5e:	0f b6 d0             	movzbl %al,%edx
  801c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c64:	8a 00                	mov    (%eax),%al
  801c66:	0f b6 c0             	movzbl %al,%eax
  801c69:	29 c2                	sub    %eax,%edx
  801c6b:	89 d0                	mov    %edx,%eax
}
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    

00801c6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 04             	sub    $0x4,%esp
  801c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c7b:	eb 12                	jmp    801c8f <strchr+0x20>
		if (*s == c)
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	8a 00                	mov    (%eax),%al
  801c82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801c85:	75 05                	jne    801c8c <strchr+0x1d>
			return (char *) s;
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	eb 11                	jmp    801c9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801c8c:	ff 45 08             	incl   0x8(%ebp)
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	8a 00                	mov    (%eax),%al
  801c94:	84 c0                	test   %al,%al
  801c96:	75 e5                	jne    801c7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801cab:	eb 0d                	jmp    801cba <strfind+0x1b>
		if (*s == c)
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	8a 00                	mov    (%eax),%al
  801cb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801cb5:	74 0e                	je     801cc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801cb7:	ff 45 08             	incl   0x8(%ebp)
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	8a 00                	mov    (%eax),%al
  801cbf:	84 c0                	test   %al,%al
  801cc1:	75 ea                	jne    801cad <strfind+0xe>
  801cc3:	eb 01                	jmp    801cc6 <strfind+0x27>
		if (*s == c)
			break;
  801cc5:	90                   	nop
	return (char *) s;
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801cd7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801cdd:	eb 0e                	jmp    801ced <memset+0x22>
		*p++ = c;
  801cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce2:	8d 50 01             	lea    0x1(%eax),%edx
  801ce5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801ced:	ff 4d f8             	decl   -0x8(%ebp)
  801cf0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801cf4:	79 e9                	jns    801cdf <memset+0x14>
		*p++ = c;

	return v;
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801d0d:	eb 16                	jmp    801d25 <memcpy+0x2a>
		*d++ = *s++;
  801d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d12:	8d 50 01             	lea    0x1(%eax),%edx
  801d15:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d1b:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d1e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801d21:	8a 12                	mov    (%edx),%dl
  801d23:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801d25:	8b 45 10             	mov    0x10(%ebp),%eax
  801d28:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d2b:	89 55 10             	mov    %edx,0x10(%ebp)
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	75 dd                	jne    801d0f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d4f:	73 50                	jae    801da1 <memmove+0x6a>
  801d51:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d5c:	76 43                	jbe    801da1 <memmove+0x6a>
		s += n;
  801d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d61:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801d64:	8b 45 10             	mov    0x10(%ebp),%eax
  801d67:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801d6a:	eb 10                	jmp    801d7c <memmove+0x45>
			*--d = *--s;
  801d6c:	ff 4d f8             	decl   -0x8(%ebp)
  801d6f:	ff 4d fc             	decl   -0x4(%ebp)
  801d72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d75:	8a 10                	mov    (%eax),%dl
  801d77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d7a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d82:	89 55 10             	mov    %edx,0x10(%ebp)
  801d85:	85 c0                	test   %eax,%eax
  801d87:	75 e3                	jne    801d6c <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d89:	eb 23                	jmp    801dae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801d8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d8e:	8d 50 01             	lea    0x1(%eax),%edx
  801d91:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d94:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d97:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d9a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801d9d:	8a 12                	mov    (%edx),%dl
  801d9f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801da1:	8b 45 10             	mov    0x10(%ebp),%eax
  801da4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801da7:	89 55 10             	mov    %edx,0x10(%ebp)
  801daa:	85 c0                	test   %eax,%eax
  801dac:	75 dd                	jne    801d8b <memmove+0x54>
			*d++ = *s++;

	return dst;
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801dc5:	eb 2a                	jmp    801df1 <memcmp+0x3e>
		if (*s1 != *s2)
  801dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dca:	8a 10                	mov    (%eax),%dl
  801dcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dcf:	8a 00                	mov    (%eax),%al
  801dd1:	38 c2                	cmp    %al,%dl
  801dd3:	74 16                	je     801deb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd8:	8a 00                	mov    (%eax),%al
  801dda:	0f b6 d0             	movzbl %al,%edx
  801ddd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801de0:	8a 00                	mov    (%eax),%al
  801de2:	0f b6 c0             	movzbl %al,%eax
  801de5:	29 c2                	sub    %eax,%edx
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	eb 18                	jmp    801e03 <memcmp+0x50>
		s1++, s2++;
  801deb:	ff 45 fc             	incl   -0x4(%ebp)
  801dee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801df1:	8b 45 10             	mov    0x10(%ebp),%eax
  801df4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801df7:	89 55 10             	mov    %edx,0x10(%ebp)
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	75 c9                	jne    801dc7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e11:	01 d0                	add    %edx,%eax
  801e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801e16:	eb 15                	jmp    801e2d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	8a 00                	mov    (%eax),%al
  801e1d:	0f b6 d0             	movzbl %al,%edx
  801e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e23:	0f b6 c0             	movzbl %al,%eax
  801e26:	39 c2                	cmp    %eax,%edx
  801e28:	74 0d                	je     801e37 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e2a:	ff 45 08             	incl   0x8(%ebp)
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e33:	72 e3                	jb     801e18 <memfind+0x13>
  801e35:	eb 01                	jmp    801e38 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801e37:	90                   	nop
	return (void *) s;
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801e43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801e4a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e51:	eb 03                	jmp    801e56 <strtol+0x19>
		s++;
  801e53:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	8a 00                	mov    (%eax),%al
  801e5b:	3c 20                	cmp    $0x20,%al
  801e5d:	74 f4                	je     801e53 <strtol+0x16>
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	8a 00                	mov    (%eax),%al
  801e64:	3c 09                	cmp    $0x9,%al
  801e66:	74 eb                	je     801e53 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	8a 00                	mov    (%eax),%al
  801e6d:	3c 2b                	cmp    $0x2b,%al
  801e6f:	75 05                	jne    801e76 <strtol+0x39>
		s++;
  801e71:	ff 45 08             	incl   0x8(%ebp)
  801e74:	eb 13                	jmp    801e89 <strtol+0x4c>
	else if (*s == '-')
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8a 00                	mov    (%eax),%al
  801e7b:	3c 2d                	cmp    $0x2d,%al
  801e7d:	75 0a                	jne    801e89 <strtol+0x4c>
		s++, neg = 1;
  801e7f:	ff 45 08             	incl   0x8(%ebp)
  801e82:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e8d:	74 06                	je     801e95 <strtol+0x58>
  801e8f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801e93:	75 20                	jne    801eb5 <strtol+0x78>
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	3c 30                	cmp    $0x30,%al
  801e9c:	75 17                	jne    801eb5 <strtol+0x78>
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	40                   	inc    %eax
  801ea2:	8a 00                	mov    (%eax),%al
  801ea4:	3c 78                	cmp    $0x78,%al
  801ea6:	75 0d                	jne    801eb5 <strtol+0x78>
		s += 2, base = 16;
  801ea8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801eac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801eb3:	eb 28                	jmp    801edd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801eb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb9:	75 15                	jne    801ed0 <strtol+0x93>
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8a 00                	mov    (%eax),%al
  801ec0:	3c 30                	cmp    $0x30,%al
  801ec2:	75 0c                	jne    801ed0 <strtol+0x93>
		s++, base = 8;
  801ec4:	ff 45 08             	incl   0x8(%ebp)
  801ec7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801ece:	eb 0d                	jmp    801edd <strtol+0xa0>
	else if (base == 0)
  801ed0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed4:	75 07                	jne    801edd <strtol+0xa0>
		base = 10;
  801ed6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	8a 00                	mov    (%eax),%al
  801ee2:	3c 2f                	cmp    $0x2f,%al
  801ee4:	7e 19                	jle    801eff <strtol+0xc2>
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	8a 00                	mov    (%eax),%al
  801eeb:	3c 39                	cmp    $0x39,%al
  801eed:	7f 10                	jg     801eff <strtol+0xc2>
			dig = *s - '0';
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	8a 00                	mov    (%eax),%al
  801ef4:	0f be c0             	movsbl %al,%eax
  801ef7:	83 e8 30             	sub    $0x30,%eax
  801efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801efd:	eb 42                	jmp    801f41 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8a 00                	mov    (%eax),%al
  801f04:	3c 60                	cmp    $0x60,%al
  801f06:	7e 19                	jle    801f21 <strtol+0xe4>
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	8a 00                	mov    (%eax),%al
  801f0d:	3c 7a                	cmp    $0x7a,%al
  801f0f:	7f 10                	jg     801f21 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	0f be c0             	movsbl %al,%eax
  801f19:	83 e8 57             	sub    $0x57,%eax
  801f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1f:	eb 20                	jmp    801f41 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	8a 00                	mov    (%eax),%al
  801f26:	3c 40                	cmp    $0x40,%al
  801f28:	7e 39                	jle    801f63 <strtol+0x126>
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	8a 00                	mov    (%eax),%al
  801f2f:	3c 5a                	cmp    $0x5a,%al
  801f31:	7f 30                	jg     801f63 <strtol+0x126>
			dig = *s - 'A' + 10;
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	8a 00                	mov    (%eax),%al
  801f38:	0f be c0             	movsbl %al,%eax
  801f3b:	83 e8 37             	sub    $0x37,%eax
  801f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f47:	7d 19                	jge    801f62 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801f49:	ff 45 08             	incl   0x8(%ebp)
  801f4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f4f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f53:	89 c2                	mov    %eax,%edx
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	01 d0                	add    %edx,%eax
  801f5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801f5d:	e9 7b ff ff ff       	jmp    801edd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801f62:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801f63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f67:	74 08                	je     801f71 <strtol+0x134>
		*endptr = (char *) s;
  801f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f6f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801f71:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f75:	74 07                	je     801f7e <strtol+0x141>
  801f77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f7a:	f7 d8                	neg    %eax
  801f7c:	eb 03                	jmp    801f81 <strtol+0x144>
  801f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <ltostr>:

void
ltostr(long value, char *str)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801f89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801f90:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801f97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f9b:	79 13                	jns    801fb0 <ltostr+0x2d>
	{
		neg = 1;
  801f9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801faa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801fad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801fb8:	99                   	cltd   
  801fb9:	f7 f9                	idiv   %ecx
  801fbb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801fbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fc1:	8d 50 01             	lea    0x1(%eax),%edx
  801fc4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fc7:	89 c2                	mov    %eax,%edx
  801fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcc:	01 d0                	add    %edx,%eax
  801fce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fd1:	83 c2 30             	add    $0x30,%edx
  801fd4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801fd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801fde:	f7 e9                	imul   %ecx
  801fe0:	c1 fa 02             	sar    $0x2,%edx
  801fe3:	89 c8                	mov    %ecx,%eax
  801fe5:	c1 f8 1f             	sar    $0x1f,%eax
  801fe8:	29 c2                	sub    %eax,%edx
  801fea:	89 d0                	mov    %edx,%eax
  801fec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801fef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ff7:	f7 e9                	imul   %ecx
  801ff9:	c1 fa 02             	sar    $0x2,%edx
  801ffc:	89 c8                	mov    %ecx,%eax
  801ffe:	c1 f8 1f             	sar    $0x1f,%eax
  802001:	29 c2                	sub    %eax,%edx
  802003:	89 d0                	mov    %edx,%eax
  802005:	c1 e0 02             	shl    $0x2,%eax
  802008:	01 d0                	add    %edx,%eax
  80200a:	01 c0                	add    %eax,%eax
  80200c:	29 c1                	sub    %eax,%ecx
  80200e:	89 ca                	mov    %ecx,%edx
  802010:	85 d2                	test   %edx,%edx
  802012:	75 9c                	jne    801fb0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802014:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80201b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80201e:	48                   	dec    %eax
  80201f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802022:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802026:	74 3d                	je     802065 <ltostr+0xe2>
		start = 1 ;
  802028:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80202f:	eb 34                	jmp    802065 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802031:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802034:	8b 45 0c             	mov    0xc(%ebp),%eax
  802037:	01 d0                	add    %edx,%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80203e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	01 c2                	add    %eax,%edx
  802046:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204c:	01 c8                	add    %ecx,%eax
  80204e:	8a 00                	mov    (%eax),%al
  802050:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802052:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802055:	8b 45 0c             	mov    0xc(%ebp),%eax
  802058:	01 c2                	add    %eax,%edx
  80205a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80205d:	88 02                	mov    %al,(%edx)
		start++ ;
  80205f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802062:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802068:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80206b:	7c c4                	jl     802031 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80206d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802070:	8b 45 0c             	mov    0xc(%ebp),%eax
  802073:	01 d0                	add    %edx,%eax
  802075:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802078:	90                   	nop
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802081:	ff 75 08             	pushl  0x8(%ebp)
  802084:	e8 54 fa ff ff       	call   801add <strlen>
  802089:	83 c4 04             	add    $0x4,%esp
  80208c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	e8 46 fa ff ff       	call   801add <strlen>
  802097:	83 c4 04             	add    $0x4,%esp
  80209a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80209d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8020a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8020ab:	eb 17                	jmp    8020c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8020ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b3:	01 c2                	add    %eax,%edx
  8020b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	01 c8                	add    %ecx,%eax
  8020bd:	8a 00                	mov    (%eax),%al
  8020bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8020c1:	ff 45 fc             	incl   -0x4(%ebp)
  8020c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020ca:	7c e1                	jl     8020ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8020cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8020d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8020da:	eb 1f                	jmp    8020fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8020dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020df:	8d 50 01             	lea    0x1(%eax),%edx
  8020e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8020e5:	89 c2                	mov    %eax,%edx
  8020e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ea:	01 c2                	add    %eax,%edx
  8020ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8020ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f2:	01 c8                	add    %ecx,%eax
  8020f4:	8a 00                	mov    (%eax),%al
  8020f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8020f8:	ff 45 f8             	incl   -0x8(%ebp)
  8020fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802101:	7c d9                	jl     8020dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802103:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802106:	8b 45 10             	mov    0x10(%ebp),%eax
  802109:	01 d0                	add    %edx,%eax
  80210b:	c6 00 00             	movb   $0x0,(%eax)
}
  80210e:	90                   	nop
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802114:	8b 45 14             	mov    0x14(%ebp),%eax
  802117:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80211d:	8b 45 14             	mov    0x14(%ebp),%eax
  802120:	8b 00                	mov    (%eax),%eax
  802122:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802129:	8b 45 10             	mov    0x10(%ebp),%eax
  80212c:	01 d0                	add    %edx,%eax
  80212e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802134:	eb 0c                	jmp    802142 <strsplit+0x31>
			*string++ = 0;
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	8d 50 01             	lea    0x1(%eax),%edx
  80213c:	89 55 08             	mov    %edx,0x8(%ebp)
  80213f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	8a 00                	mov    (%eax),%al
  802147:	84 c0                	test   %al,%al
  802149:	74 18                	je     802163 <strsplit+0x52>
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	8a 00                	mov    (%eax),%al
  802150:	0f be c0             	movsbl %al,%eax
  802153:	50                   	push   %eax
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	e8 13 fb ff ff       	call   801c6f <strchr>
  80215c:	83 c4 08             	add    $0x8,%esp
  80215f:	85 c0                	test   %eax,%eax
  802161:	75 d3                	jne    802136 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	8a 00                	mov    (%eax),%al
  802168:	84 c0                	test   %al,%al
  80216a:	74 5a                	je     8021c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  80216c:	8b 45 14             	mov    0x14(%ebp),%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	83 f8 0f             	cmp    $0xf,%eax
  802174:	75 07                	jne    80217d <strsplit+0x6c>
		{
			return 0;
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
  80217b:	eb 66                	jmp    8021e3 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80217d:	8b 45 14             	mov    0x14(%ebp),%eax
  802180:	8b 00                	mov    (%eax),%eax
  802182:	8d 48 01             	lea    0x1(%eax),%ecx
  802185:	8b 55 14             	mov    0x14(%ebp),%edx
  802188:	89 0a                	mov    %ecx,(%edx)
  80218a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802191:	8b 45 10             	mov    0x10(%ebp),%eax
  802194:	01 c2                	add    %eax,%edx
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80219b:	eb 03                	jmp    8021a0 <strsplit+0x8f>
			string++;
  80219d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	8a 00                	mov    (%eax),%al
  8021a5:	84 c0                	test   %al,%al
  8021a7:	74 8b                	je     802134 <strsplit+0x23>
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	8a 00                	mov    (%eax),%al
  8021ae:	0f be c0             	movsbl %al,%eax
  8021b1:	50                   	push   %eax
  8021b2:	ff 75 0c             	pushl  0xc(%ebp)
  8021b5:	e8 b5 fa ff ff       	call   801c6f <strchr>
  8021ba:	83 c4 08             	add    $0x8,%esp
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	74 dc                	je     80219d <strsplit+0x8c>
			string++;
	}
  8021c1:	e9 6e ff ff ff       	jmp    802134 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8021c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8021c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ca:	8b 00                	mov    (%eax),%eax
  8021cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d6:	01 d0                	add    %edx,%eax
  8021d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8021de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  8021ee:	e8 7d 0f 00 00       	call   803170 <sys_isUHeapPlacementStrategyNEXTFIT>
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	0f 84 6f 03 00 00    	je     80256a <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  8021fb:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  802202:	8b 55 08             	mov    0x8(%ebp),%edx
  802205:	8b 45 84             	mov    -0x7c(%ebp),%eax
  802208:	01 d0                	add    %edx,%eax
  80220a:	48                   	dec    %eax
  80220b:	89 45 80             	mov    %eax,-0x80(%ebp)
  80220e:	8b 45 80             	mov    -0x80(%ebp),%eax
  802211:	ba 00 00 00 00       	mov    $0x0,%edx
  802216:	f7 75 84             	divl   -0x7c(%ebp)
  802219:	8b 45 80             	mov    -0x80(%ebp),%eax
  80221c:	29 d0                	sub    %edx,%eax
  80221e:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802221:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802225:	74 09                	je     802230 <malloc+0x4b>
  802227:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80222e:	76 0a                	jbe    80223a <malloc+0x55>
			return NULL;
  802230:	b8 00 00 00 00       	mov    $0x0,%eax
  802235:	e9 4b 09 00 00       	jmp    802b85 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  80223a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	01 d0                	add    %edx,%eax
  802245:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80224a:	0f 87 a2 00 00 00    	ja     8022f2 <malloc+0x10d>
  802250:	a1 40 40 98 00       	mov    0x984040,%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	0f 85 95 00 00 00    	jne    8022f2 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  80225d:	a1 04 40 80 00       	mov    0x804004,%eax
  802262:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  802268:	a1 04 40 80 00       	mov    0x804004,%eax
  80226d:	83 ec 08             	sub    $0x8,%esp
  802270:	ff 75 08             	pushl  0x8(%ebp)
  802273:	50                   	push   %eax
  802274:	e8 a3 0b 00 00       	call   802e1c <sys_allocateMem>
  802279:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  80227c:	a1 20 40 80 00       	mov    0x804020,%eax
  802281:	8b 55 08             	mov    0x8(%ebp),%edx
  802284:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80228b:	a1 20 40 80 00       	mov    0x804020,%eax
  802290:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802296:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  80229d:	a1 20 40 80 00       	mov    0x804020,%eax
  8022a2:	40                   	inc    %eax
  8022a3:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  8022a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8022af:	eb 2e                	jmp    8022df <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8022b1:	a1 04 40 80 00       	mov    0x804004,%eax
  8022b6:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8022bb:	c1 e8 0c             	shr    $0xc,%eax
  8022be:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8022c5:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8022c9:	a1 04 40 80 00       	mov    0x804004,%eax
  8022ce:	05 00 10 00 00       	add    $0x1000,%eax
  8022d3:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8022d8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e5:	72 ca                	jb     8022b1 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  8022e7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8022ed:	e9 93 08 00 00       	jmp    802b85 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  8022f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  8022f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  802300:	a1 40 40 98 00       	mov    0x984040,%eax
  802305:	85 c0                	test   %eax,%eax
  802307:	75 1d                	jne    802326 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  802309:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  802310:	00 00 80 
				check = 1;
  802313:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  80231a:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  80231d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  802324:	eb 08                	jmp    80232e <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  802326:	a1 04 40 80 00       	mov    0x804004,%eax
  80232b:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  80232e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  802335:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  80233c:	a1 04 40 80 00       	mov    0x804004,%eax
  802341:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  802344:	eb 4d                	jmp    802393 <malloc+0x1ae>
				if (sz == size) {
  802346:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802349:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234c:	75 09                	jne    802357 <malloc+0x172>
					f = 1;
  80234e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802355:	eb 45                	jmp    80239c <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80235a:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  80235f:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802362:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802369:	85 c0                	test   %eax,%eax
  80236b:	75 10                	jne    80237d <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  80236d:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  802374:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  80237b:	eb 16                	jmp    802393 <malloc+0x1ae>
				} else {
					sz = 0;
  80237d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  802384:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  80238b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238e:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  802393:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  80239a:	76 aa                	jbe    802346 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  80239c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023a0:	0f 84 95 00 00 00    	je     80243b <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8023a6:	a1 04 40 80 00       	mov    0x804004,%eax
  8023ab:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  8023b1:	a1 04 40 80 00       	mov    0x804004,%eax
  8023b6:	83 ec 08             	sub    $0x8,%esp
  8023b9:	ff 75 08             	pushl  0x8(%ebp)
  8023bc:	50                   	push   %eax
  8023bd:	e8 5a 0a 00 00       	call   802e1c <sys_allocateMem>
  8023c2:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8023c5:	a1 20 40 80 00       	mov    0x804020,%eax
  8023ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cd:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8023d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8023d9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8023df:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  8023e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8023eb:	40                   	inc    %eax
  8023ec:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  8023f1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8023f8:	eb 2e                	jmp    802428 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8023fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8023ff:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802404:	c1 e8 0c             	shr    $0xc,%eax
  802407:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  80240e:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  802412:	a1 04 40 80 00       	mov    0x804004,%eax
  802417:	05 00 10 00 00       	add    $0x1000,%eax
  80241c:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802421:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  802428:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80242b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80242e:	72 ca                	jb     8023fa <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  802430:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  802436:	e9 4a 07 00 00       	jmp    802b85 <malloc+0x9a0>

			} else {

				if (check_start) {
  80243b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80243f:	74 0a                	je     80244b <malloc+0x266>

					return NULL;
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
  802446:	e9 3a 07 00 00       	jmp    802b85 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  80244b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  802452:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  802459:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  802460:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  802467:	00 00 80 
				while (ptr < (uint32) temp_end) {
  80246a:	eb 4d                	jmp    8024b9 <malloc+0x2d4>
					if (sz == size) {
  80246c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80246f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802472:	75 09                	jne    80247d <malloc+0x298>
						f = 1;
  802474:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  80247b:	eb 44                	jmp    8024c1 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80247d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802480:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  802485:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802488:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  80248f:	85 c0                	test   %eax,%eax
  802491:	75 10                	jne    8024a3 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  802493:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  80249a:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  8024a1:	eb 16                	jmp    8024b9 <malloc+0x2d4>
					} else {
						sz = 0;
  8024a3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8024aa:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  8024b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024b4:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  8024b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bc:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8024bf:	72 ab                	jb     80246c <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  8024c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8024c5:	0f 84 95 00 00 00    	je     802560 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  8024cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8024d0:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  8024d6:	a1 04 40 80 00       	mov    0x804004,%eax
  8024db:	83 ec 08             	sub    $0x8,%esp
  8024de:	ff 75 08             	pushl  0x8(%ebp)
  8024e1:	50                   	push   %eax
  8024e2:	e8 35 09 00 00       	call   802e1c <sys_allocateMem>
  8024e7:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  8024ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8024ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f2:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8024f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8024fe:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802504:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  80250b:	a1 20 40 80 00       	mov    0x804020,%eax
  802510:	40                   	inc    %eax
  802511:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  802516:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  80251d:	eb 2e                	jmp    80254d <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80251f:	a1 04 40 80 00       	mov    0x804004,%eax
  802524:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  802529:	c1 e8 0c             	shr    $0xc,%eax
  80252c:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802533:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  802537:	a1 04 40 80 00       	mov    0x804004,%eax
  80253c:	05 00 10 00 00       	add    $0x1000,%eax
  802541:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  802546:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  80254d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802550:	3b 45 08             	cmp    0x8(%ebp),%eax
  802553:	72 ca                	jb     80251f <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  802555:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80255b:	e9 25 06 00 00       	jmp    802b85 <malloc+0x9a0>

				} else {

					return NULL;
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
  802565:	e9 1b 06 00 00       	jmp    802b85 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  80256a:	e8 d0 0b 00 00       	call   80313f <sys_isUHeapPlacementStrategyBESTFIT>
  80256f:	85 c0                	test   %eax,%eax
  802571:	0f 84 ba 01 00 00    	je     802731 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  802577:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  80257e:	10 00 00 
  802581:	8b 55 08             	mov    0x8(%ebp),%edx
  802584:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80258a:	01 d0                	add    %edx,%eax
  80258c:	48                   	dec    %eax
  80258d:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  802593:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  802599:	ba 00 00 00 00       	mov    $0x0,%edx
  80259e:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  8025a4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8025aa:	29 d0                	sub    %edx,%eax
  8025ac:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8025af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025b3:	74 09                	je     8025be <malloc+0x3d9>
  8025b5:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8025bc:	76 0a                	jbe    8025c8 <malloc+0x3e3>
			return NULL;
  8025be:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c3:	e9 bd 05 00 00       	jmp    802b85 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  8025c8:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  8025cf:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  8025d6:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  8025dd:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  8025e4:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	c1 e8 0c             	shr    $0xc,%eax
  8025f1:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  8025f7:	e9 80 00 00 00       	jmp    80267c <malloc+0x497>

			if (heap_mem[i] == 0) {
  8025fc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8025ff:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802606:	85 c0                	test   %eax,%eax
  802608:	75 0c                	jne    802616 <malloc+0x431>

				count++;
  80260a:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  80260d:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  802614:	eb 2d                	jmp    802643 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  802616:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80261c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80261f:	77 14                	ja     802635 <malloc+0x450>
  802621:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802624:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  802627:	76 0c                	jbe    802635 <malloc+0x450>

					min_sz = count;
  802629:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80262c:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  80262f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802632:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  802635:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  80263c:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  802643:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  80264a:	75 2d                	jne    802679 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  80264c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  802652:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  802655:	77 22                	ja     802679 <malloc+0x494>
  802657:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80265a:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80265d:	76 1a                	jbe    802679 <malloc+0x494>

					min_sz = count;
  80265f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802662:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  802665:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802668:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  80266b:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  802672:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  802679:	ff 45 b8             	incl   -0x48(%ebp)
  80267c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80267f:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802684:	0f 86 72 ff ff ff    	jbe    8025fc <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  80268a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  802690:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  802693:	77 06                	ja     80269b <malloc+0x4b6>
  802695:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802699:	75 0a                	jne    8026a5 <malloc+0x4c0>
			return NULL;
  80269b:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a0:	e9 e0 04 00 00       	jmp    802b85 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  8026a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026a8:	c1 e0 0c             	shl    $0xc,%eax
  8026ab:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  8026ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026b1:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  8026b7:	83 ec 08             	sub    $0x8,%esp
  8026ba:	ff 75 08             	pushl  0x8(%ebp)
  8026bd:	ff 75 c4             	pushl  -0x3c(%ebp)
  8026c0:	e8 57 07 00 00       	call   802e1c <sys_allocateMem>
  8026c5:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8026c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8026cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d0:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8026d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8026dc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8026df:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8026e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8026eb:	40                   	inc    %eax
  8026ec:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  8026f1:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8026f8:	eb 24                	jmp    80271e <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8026fa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026fd:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802702:	c1 e8 0c             	shr    $0xc,%eax
  802705:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  80270c:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802710:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802717:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  80271e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802721:	3b 45 08             	cmp    0x8(%ebp),%eax
  802724:	72 d4                	jb     8026fa <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  802726:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80272c:	e9 54 04 00 00       	jmp    802b85 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  802731:	e8 d8 09 00 00       	call   80310e <sys_isUHeapPlacementStrategyFIRSTFIT>
  802736:	85 c0                	test   %eax,%eax
  802738:	0f 84 88 01 00 00    	je     8028c6 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  80273e:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  802745:	10 00 00 
  802748:	8b 55 08             	mov    0x8(%ebp),%edx
  80274b:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  802751:	01 d0                	add    %edx,%eax
  802753:	48                   	dec    %eax
  802754:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  80275a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  802760:	ba 00 00 00 00       	mov    $0x0,%edx
  802765:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  80276b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  802771:	29 d0                	sub    %edx,%eax
  802773:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802776:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80277a:	74 09                	je     802785 <malloc+0x5a0>
  80277c:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802783:	76 0a                	jbe    80278f <malloc+0x5aa>
			return NULL;
  802785:	b8 00 00 00 00       	mov    $0x0,%eax
  80278a:	e9 f6 03 00 00       	jmp    802b85 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  80278f:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  802796:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  80279d:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  8027a4:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  8027ab:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b5:	c1 e8 0c             	shr    $0xc,%eax
  8027b8:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  8027be:	eb 5a                	jmp    80281a <malloc+0x635>

			if (heap_mem[i] == 0) {
  8027c0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027c3:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	75 0c                	jne    8027da <malloc+0x5f5>

				count++;
  8027ce:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  8027d1:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  8027d8:	eb 22                	jmp    8027fc <malloc+0x617>
			} else {
				if (num_p <= count) {
  8027da:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8027e0:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  8027e3:	77 09                	ja     8027ee <malloc+0x609>

					found = 1;
  8027e5:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  8027ec:	eb 36                	jmp    802824 <malloc+0x63f>
				}
				count = 0;
  8027ee:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  8027f5:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  8027fc:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  802803:	75 12                	jne    802817 <malloc+0x632>

				if (num_p <= count) {
  802805:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80280b:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  80280e:	77 07                	ja     802817 <malloc+0x632>

					found = 1;
  802810:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  802817:	ff 45 a4             	incl   -0x5c(%ebp)
  80281a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80281d:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802822:	76 9c                	jbe    8027c0 <malloc+0x5db>

			}

		}

		if (!found) {
  802824:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  802828:	75 0a                	jne    802834 <malloc+0x64f>
			return NULL;
  80282a:	b8 00 00 00 00       	mov    $0x0,%eax
  80282f:	e9 51 03 00 00       	jmp    802b85 <malloc+0x9a0>

		}

		temp = ptr;
  802834:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802837:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  80283a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80283d:	c1 e0 0c             	shl    $0xc,%eax
  802840:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  802843:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802846:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  80284c:	83 ec 08             	sub    $0x8,%esp
  80284f:	ff 75 08             	pushl  0x8(%ebp)
  802852:	ff 75 b0             	pushl  -0x50(%ebp)
  802855:	e8 c2 05 00 00       	call   802e1c <sys_allocateMem>
  80285a:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80285d:	a1 20 40 80 00       	mov    0x804020,%eax
  802862:	8b 55 08             	mov    0x8(%ebp),%edx
  802865:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  80286c:	a1 20 40 80 00       	mov    0x804020,%eax
  802871:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802874:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  80287b:	a1 20 40 80 00       	mov    0x804020,%eax
  802880:	40                   	inc    %eax
  802881:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  802886:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  80288d:	eb 24                	jmp    8028b3 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  80288f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802892:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802897:	c1 e8 0c             	shr    $0xc,%eax
  80289a:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8028a1:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  8028a5:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8028ac:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  8028b3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b9:	72 d4                	jb     80288f <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8028bb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8028c1:	e9 bf 02 00 00       	jmp    802b85 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  8028c6:	e8 d6 08 00 00       	call   8031a1 <sys_isUHeapPlacementStrategyWORSTFIT>
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	0f 84 ba 01 00 00    	je     802a8d <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  8028d3:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  8028da:	10 00 00 
  8028dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e0:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8028e6:	01 d0                	add    %edx,%eax
  8028e8:	48                   	dec    %eax
  8028e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  8028ef:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8028f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8028fa:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802900:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802906:	29 d0                	sub    %edx,%eax
  802908:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80290b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80290f:	74 09                	je     80291a <malloc+0x735>
  802911:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802918:	76 0a                	jbe    802924 <malloc+0x73f>
					return NULL;
  80291a:	b8 00 00 00 00       	mov    $0x0,%eax
  80291f:	e9 61 02 00 00       	jmp    802b85 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  802924:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  80292b:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  802932:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  802939:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  802940:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	c1 e8 0c             	shr    $0xc,%eax
  80294d:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802953:	e9 80 00 00 00       	jmp    8029d8 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  802958:	8b 45 90             	mov    -0x70(%ebp),%eax
  80295b:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	75 0c                	jne    802972 <malloc+0x78d>

						count++;
  802966:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  802969:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  802970:	eb 2d                	jmp    80299f <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  802972:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802978:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80297b:	77 14                	ja     802991 <malloc+0x7ac>
  80297d:	8b 45 98             	mov    -0x68(%ebp),%eax
  802980:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802983:	73 0c                	jae    802991 <malloc+0x7ac>

							max_sz = count;
  802985:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802988:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  80298b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80298e:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  802991:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  802998:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  80299f:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  8029a6:	75 2d                	jne    8029d5 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  8029a8:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8029ae:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8029b1:	77 22                	ja     8029d5 <malloc+0x7f0>
  8029b3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8029b6:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8029b9:	76 1a                	jbe    8029d5 <malloc+0x7f0>

							max_sz = count;
  8029bb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8029be:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8029c1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8029c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  8029c7:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  8029ce:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8029d5:	ff 45 90             	incl   -0x70(%ebp)
  8029d8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8029db:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8029e0:	0f 86 72 ff ff ff    	jbe    802958 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  8029e6:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8029ec:	3b 45 98             	cmp    -0x68(%ebp),%eax
  8029ef:	77 06                	ja     8029f7 <malloc+0x812>
  8029f1:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8029f5:	75 0a                	jne    802a01 <malloc+0x81c>
					return NULL;
  8029f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fc:	e9 84 01 00 00       	jmp    802b85 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802a01:	8b 45 98             	mov    -0x68(%ebp),%eax
  802a04:	c1 e0 0c             	shl    $0xc,%eax
  802a07:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  802a0a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802a0d:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  802a13:	83 ec 08             	sub    $0x8,%esp
  802a16:	ff 75 08             	pushl  0x8(%ebp)
  802a19:	ff 75 9c             	pushl  -0x64(%ebp)
  802a1c:	e8 fb 03 00 00       	call   802e1c <sys_allocateMem>
  802a21:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802a24:	a1 20 40 80 00       	mov    0x804020,%eax
  802a29:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2c:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  802a33:	a1 20 40 80 00       	mov    0x804020,%eax
  802a38:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802a3b:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  802a42:	a1 20 40 80 00       	mov    0x804020,%eax
  802a47:	40                   	inc    %eax
  802a48:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  802a4d:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802a54:	eb 24                	jmp    802a7a <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802a56:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802a59:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802a5e:	c1 e8 0c             	shr    $0xc,%eax
  802a61:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802a68:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802a6c:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802a73:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802a7a:	8b 45 90             	mov    -0x70(%ebp),%eax
  802a7d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a80:	72 d4                	jb     802a56 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  802a82:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  802a88:	e9 f8 00 00 00       	jmp    802b85 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802a8d:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  802a94:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  802a9b:	10 00 00 
  802a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  802aa7:	01 d0                	add    %edx,%eax
  802aa9:	48                   	dec    %eax
  802aaa:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802ab0:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  802abb:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802ac1:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802ac7:	29 d0                	sub    %edx,%eax
  802ac9:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802acc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad0:	74 09                	je     802adb <malloc+0x8f6>
  802ad2:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802ad9:	76 0a                	jbe    802ae5 <malloc+0x900>
		return NULL;
  802adb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae0:	e9 a0 00 00 00       	jmp    802b85 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802ae5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	01 d0                	add    %edx,%eax
  802af0:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802af5:	0f 87 87 00 00 00    	ja     802b82 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802afb:	a1 04 40 80 00       	mov    0x804004,%eax
  802b00:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802b03:	a1 04 40 80 00       	mov    0x804004,%eax
  802b08:	83 ec 08             	sub    $0x8,%esp
  802b0b:	ff 75 08             	pushl  0x8(%ebp)
  802b0e:	50                   	push   %eax
  802b0f:	e8 08 03 00 00       	call   802e1c <sys_allocateMem>
  802b14:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802b17:	a1 20 40 80 00       	mov    0x804020,%eax
  802b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1f:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802b26:	a1 20 40 80 00       	mov    0x804020,%eax
  802b2b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802b31:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  802b38:	a1 20 40 80 00       	mov    0x804020,%eax
  802b3d:	40                   	inc    %eax
  802b3e:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  802b43:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  802b4a:	eb 2e                	jmp    802b7a <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802b4c:	a1 04 40 80 00       	mov    0x804004,%eax
  802b51:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802b56:	c1 e8 0c             	shr    $0xc,%eax
  802b59:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802b60:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  802b64:	a1 04 40 80 00       	mov    0x804004,%eax
  802b69:	05 00 10 00 00       	add    $0x1000,%eax
  802b6e:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  802b73:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802b7a:	8b 45 88             	mov    -0x78(%ebp),%eax
  802b7d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b80:	72 ca                	jb     802b4c <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  802b82:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  802b85:	c9                   	leave  
  802b86:	c3                   	ret    

00802b87 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  802b87:	55                   	push   %ebp
  802b88:	89 e5                	mov    %esp,%ebp
  802b8a:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802b8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  802b94:	e9 c1 00 00 00       	jmp    802c5a <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  802ba3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba6:	0f 85 ab 00 00 00    	jne    802c57 <free+0xd0>

			if (heap_size[inx].size == 0) {
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	75 21                	jne    802bdb <free+0x54>
				heap_size[inx].size = 0;
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802bc4:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802bd2:	00 00 00 00 
				return;
  802bd6:	e9 8d 00 00 00       	jmp    802c68 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	83 ec 08             	sub    $0x8,%esp
  802beb:	52                   	push   %edx
  802bec:	50                   	push   %eax
  802bed:	e8 0e 02 00 00       	call   802e00 <sys_freeMem>
  802bf2:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802bf5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802c02:	eb 24                	jmp    802c28 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c07:	05 00 00 00 80       	add    $0x80000000,%eax
  802c0c:	c1 e8 0c             	shr    $0xc,%eax
  802c0f:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  802c16:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  802c1a:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802c21:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c35:	39 c2                	cmp    %eax,%edx
  802c37:	77 cb                	ja     802c04 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802c43:	00 00 00 00 
			heap_size[inx].vir = NULL;
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802c51:	00 00 00 00 
			break;
  802c55:	eb 11                	jmp    802c68 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  802c57:	ff 45 f4             	incl   -0xc(%ebp)
  802c5a:	a1 20 40 80 00       	mov    0x804020,%eax
  802c5f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802c62:	0f 8c 31 ff ff ff    	jl     802b99 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  802c68:	c9                   	leave  
  802c69:	c3                   	ret    

00802c6a <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  802c6a:	55                   	push   %ebp
  802c6b:	89 e5                	mov    %esp,%ebp
  802c6d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	68 b0 3e 80 00       	push   $0x803eb0
  802c78:	68 1c 02 00 00       	push   $0x21c
  802c7d:	68 d6 3e 80 00       	push   $0x803ed6
  802c82:	e8 b0 e6 ff ff       	call   801337 <_panic>

00802c87 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802c87:	55                   	push   %ebp
  802c88:	89 e5                	mov    %esp,%ebp
  802c8a:	57                   	push   %edi
  802c8b:	56                   	push   %esi
  802c8c:	53                   	push   %ebx
  802c8d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c99:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c9c:	8b 7d 18             	mov    0x18(%ebp),%edi
  802c9f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ca2:	cd 30                	int    $0x30
  802ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802caa:	83 c4 10             	add    $0x10,%esp
  802cad:	5b                   	pop    %ebx
  802cae:	5e                   	pop    %esi
  802caf:	5f                   	pop    %edi
  802cb0:	5d                   	pop    %ebp
  802cb1:	c3                   	ret    

00802cb2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802cb2:	55                   	push   %ebp
  802cb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	6a 00                	push   $0x0
  802cba:	6a 00                	push   $0x0
  802cbc:	6a 00                	push   $0x0
  802cbe:	ff 75 0c             	pushl  0xc(%ebp)
  802cc1:	50                   	push   %eax
  802cc2:	6a 00                	push   $0x0
  802cc4:	e8 be ff ff ff       	call   802c87 <syscall>
  802cc9:	83 c4 18             	add    $0x18,%esp
}
  802ccc:	90                   	nop
  802ccd:	c9                   	leave  
  802cce:	c3                   	ret    

00802ccf <sys_cgetc>:

int
sys_cgetc(void)
{
  802ccf:	55                   	push   %ebp
  802cd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802cd2:	6a 00                	push   $0x0
  802cd4:	6a 00                	push   $0x0
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	6a 01                	push   $0x1
  802cde:	e8 a4 ff ff ff       	call   802c87 <syscall>
  802ce3:	83 c4 18             	add    $0x18,%esp
}
  802ce6:	c9                   	leave  
  802ce7:	c3                   	ret    

00802ce8 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	6a 00                	push   $0x0
  802cf0:	6a 00                	push   $0x0
  802cf2:	6a 00                	push   $0x0
  802cf4:	6a 00                	push   $0x0
  802cf6:	50                   	push   %eax
  802cf7:	6a 03                	push   $0x3
  802cf9:	e8 89 ff ff ff       	call   802c87 <syscall>
  802cfe:	83 c4 18             	add    $0x18,%esp
}
  802d01:	c9                   	leave  
  802d02:	c3                   	ret    

00802d03 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d03:	55                   	push   %ebp
  802d04:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d06:	6a 00                	push   $0x0
  802d08:	6a 00                	push   $0x0
  802d0a:	6a 00                	push   $0x0
  802d0c:	6a 00                	push   $0x0
  802d0e:	6a 00                	push   $0x0
  802d10:	6a 02                	push   $0x2
  802d12:	e8 70 ff ff ff       	call   802c87 <syscall>
  802d17:	83 c4 18             	add    $0x18,%esp
}
  802d1a:	c9                   	leave  
  802d1b:	c3                   	ret    

00802d1c <sys_env_exit>:

void sys_env_exit(void)
{
  802d1c:	55                   	push   %ebp
  802d1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802d1f:	6a 00                	push   $0x0
  802d21:	6a 00                	push   $0x0
  802d23:	6a 00                	push   $0x0
  802d25:	6a 00                	push   $0x0
  802d27:	6a 00                	push   $0x0
  802d29:	6a 04                	push   $0x4
  802d2b:	e8 57 ff ff ff       	call   802c87 <syscall>
  802d30:	83 c4 18             	add    $0x18,%esp
}
  802d33:	90                   	nop
  802d34:	c9                   	leave  
  802d35:	c3                   	ret    

00802d36 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802d36:	55                   	push   %ebp
  802d37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	6a 00                	push   $0x0
  802d41:	6a 00                	push   $0x0
  802d43:	6a 00                	push   $0x0
  802d45:	52                   	push   %edx
  802d46:	50                   	push   %eax
  802d47:	6a 05                	push   $0x5
  802d49:	e8 39 ff ff ff       	call   802c87 <syscall>
  802d4e:	83 c4 18             	add    $0x18,%esp
}
  802d51:	c9                   	leave  
  802d52:	c3                   	ret    

00802d53 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802d53:	55                   	push   %ebp
  802d54:	89 e5                	mov    %esp,%ebp
  802d56:	56                   	push   %esi
  802d57:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802d58:	8b 75 18             	mov    0x18(%ebp),%esi
  802d5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	56                   	push   %esi
  802d68:	53                   	push   %ebx
  802d69:	51                   	push   %ecx
  802d6a:	52                   	push   %edx
  802d6b:	50                   	push   %eax
  802d6c:	6a 06                	push   $0x6
  802d6e:	e8 14 ff ff ff       	call   802c87 <syscall>
  802d73:	83 c4 18             	add    $0x18,%esp
}
  802d76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d79:	5b                   	pop    %ebx
  802d7a:	5e                   	pop    %esi
  802d7b:	5d                   	pop    %ebp
  802d7c:	c3                   	ret    

00802d7d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802d7d:	55                   	push   %ebp
  802d7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	6a 00                	push   $0x0
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	52                   	push   %edx
  802d8d:	50                   	push   %eax
  802d8e:	6a 07                	push   $0x7
  802d90:	e8 f2 fe ff ff       	call   802c87 <syscall>
  802d95:	83 c4 18             	add    $0x18,%esp
}
  802d98:	c9                   	leave  
  802d99:	c3                   	ret    

00802d9a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802d9a:	55                   	push   %ebp
  802d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 00                	push   $0x0
  802da3:	ff 75 0c             	pushl  0xc(%ebp)
  802da6:	ff 75 08             	pushl  0x8(%ebp)
  802da9:	6a 08                	push   $0x8
  802dab:	e8 d7 fe ff ff       	call   802c87 <syscall>
  802db0:	83 c4 18             	add    $0x18,%esp
}
  802db3:	c9                   	leave  
  802db4:	c3                   	ret    

00802db5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802db5:	55                   	push   %ebp
  802db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	6a 09                	push   $0x9
  802dc4:	e8 be fe ff ff       	call   802c87 <syscall>
  802dc9:	83 c4 18             	add    $0x18,%esp
}
  802dcc:	c9                   	leave  
  802dcd:	c3                   	ret    

00802dce <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802dce:	55                   	push   %ebp
  802dcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802dd1:	6a 00                	push   $0x0
  802dd3:	6a 00                	push   $0x0
  802dd5:	6a 00                	push   $0x0
  802dd7:	6a 00                	push   $0x0
  802dd9:	6a 00                	push   $0x0
  802ddb:	6a 0a                	push   $0xa
  802ddd:	e8 a5 fe ff ff       	call   802c87 <syscall>
  802de2:	83 c4 18             	add    $0x18,%esp
}
  802de5:	c9                   	leave  
  802de6:	c3                   	ret    

00802de7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802de7:	55                   	push   %ebp
  802de8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	6a 00                	push   $0x0
  802df0:	6a 00                	push   $0x0
  802df2:	6a 00                	push   $0x0
  802df4:	6a 0b                	push   $0xb
  802df6:	e8 8c fe ff ff       	call   802c87 <syscall>
  802dfb:	83 c4 18             	add    $0x18,%esp
}
  802dfe:	c9                   	leave  
  802dff:	c3                   	ret    

00802e00 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802e00:	55                   	push   %ebp
  802e01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 00                	push   $0x0
  802e09:	ff 75 0c             	pushl  0xc(%ebp)
  802e0c:	ff 75 08             	pushl  0x8(%ebp)
  802e0f:	6a 0d                	push   $0xd
  802e11:	e8 71 fe ff ff       	call   802c87 <syscall>
  802e16:	83 c4 18             	add    $0x18,%esp
	return;
  802e19:	90                   	nop
}
  802e1a:	c9                   	leave  
  802e1b:	c3                   	ret    

00802e1c <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802e1c:	55                   	push   %ebp
  802e1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802e1f:	6a 00                	push   $0x0
  802e21:	6a 00                	push   $0x0
  802e23:	6a 00                	push   $0x0
  802e25:	ff 75 0c             	pushl  0xc(%ebp)
  802e28:	ff 75 08             	pushl  0x8(%ebp)
  802e2b:	6a 0e                	push   $0xe
  802e2d:	e8 55 fe ff ff       	call   802c87 <syscall>
  802e32:	83 c4 18             	add    $0x18,%esp
	return ;
  802e35:	90                   	nop
}
  802e36:	c9                   	leave  
  802e37:	c3                   	ret    

00802e38 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e38:	55                   	push   %ebp
  802e39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e3b:	6a 00                	push   $0x0
  802e3d:	6a 00                	push   $0x0
  802e3f:	6a 00                	push   $0x0
  802e41:	6a 00                	push   $0x0
  802e43:	6a 00                	push   $0x0
  802e45:	6a 0c                	push   $0xc
  802e47:	e8 3b fe ff ff       	call   802c87 <syscall>
  802e4c:	83 c4 18             	add    $0x18,%esp
}
  802e4f:	c9                   	leave  
  802e50:	c3                   	ret    

00802e51 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802e51:	55                   	push   %ebp
  802e52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 10                	push   $0x10
  802e60:	e8 22 fe ff ff       	call   802c87 <syscall>
  802e65:	83 c4 18             	add    $0x18,%esp
}
  802e68:	90                   	nop
  802e69:	c9                   	leave  
  802e6a:	c3                   	ret    

00802e6b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802e6b:	55                   	push   %ebp
  802e6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802e6e:	6a 00                	push   $0x0
  802e70:	6a 00                	push   $0x0
  802e72:	6a 00                	push   $0x0
  802e74:	6a 00                	push   $0x0
  802e76:	6a 00                	push   $0x0
  802e78:	6a 11                	push   $0x11
  802e7a:	e8 08 fe ff ff       	call   802c87 <syscall>
  802e7f:	83 c4 18             	add    $0x18,%esp
}
  802e82:	90                   	nop
  802e83:	c9                   	leave  
  802e84:	c3                   	ret    

00802e85 <sys_cputc>:


void
sys_cputc(const char c)
{
  802e85:	55                   	push   %ebp
  802e86:	89 e5                	mov    %esp,%ebp
  802e88:	83 ec 04             	sub    $0x4,%esp
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802e91:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	50                   	push   %eax
  802e9e:	6a 12                	push   $0x12
  802ea0:	e8 e2 fd ff ff       	call   802c87 <syscall>
  802ea5:	83 c4 18             	add    $0x18,%esp
}
  802ea8:	90                   	nop
  802ea9:	c9                   	leave  
  802eaa:	c3                   	ret    

00802eab <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802eab:	55                   	push   %ebp
  802eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802eae:	6a 00                	push   $0x0
  802eb0:	6a 00                	push   $0x0
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 13                	push   $0x13
  802eba:	e8 c8 fd ff ff       	call   802c87 <syscall>
  802ebf:	83 c4 18             	add    $0x18,%esp
}
  802ec2:	90                   	nop
  802ec3:	c9                   	leave  
  802ec4:	c3                   	ret    

00802ec5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802ec5:	55                   	push   %ebp
  802ec6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	6a 00                	push   $0x0
  802ecd:	6a 00                	push   $0x0
  802ecf:	6a 00                	push   $0x0
  802ed1:	ff 75 0c             	pushl  0xc(%ebp)
  802ed4:	50                   	push   %eax
  802ed5:	6a 14                	push   $0x14
  802ed7:	e8 ab fd ff ff       	call   802c87 <syscall>
  802edc:	83 c4 18             	add    $0x18,%esp
}
  802edf:	c9                   	leave  
  802ee0:	c3                   	ret    

00802ee1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802ee1:	55                   	push   %ebp
  802ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 00                	push   $0x0
  802eef:	50                   	push   %eax
  802ef0:	6a 17                	push   $0x17
  802ef2:	e8 90 fd ff ff       	call   802c87 <syscall>
  802ef7:	83 c4 18             	add    $0x18,%esp
}
  802efa:	c9                   	leave  
  802efb:	c3                   	ret    

00802efc <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802efc:	55                   	push   %ebp
  802efd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	6a 00                	push   $0x0
  802f04:	6a 00                	push   $0x0
  802f06:	6a 00                	push   $0x0
  802f08:	6a 00                	push   $0x0
  802f0a:	50                   	push   %eax
  802f0b:	6a 15                	push   $0x15
  802f0d:	e8 75 fd ff ff       	call   802c87 <syscall>
  802f12:	83 c4 18             	add    $0x18,%esp
}
  802f15:	90                   	nop
  802f16:	c9                   	leave  
  802f17:	c3                   	ret    

00802f18 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802f18:	55                   	push   %ebp
  802f19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	6a 00                	push   $0x0
  802f20:	6a 00                	push   $0x0
  802f22:	6a 00                	push   $0x0
  802f24:	6a 00                	push   $0x0
  802f26:	50                   	push   %eax
  802f27:	6a 16                	push   $0x16
  802f29:	e8 59 fd ff ff       	call   802c87 <syscall>
  802f2e:	83 c4 18             	add    $0x18,%esp
}
  802f31:	90                   	nop
  802f32:	c9                   	leave  
  802f33:	c3                   	ret    

00802f34 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802f34:	55                   	push   %ebp
  802f35:	89 e5                	mov    %esp,%ebp
  802f37:	83 ec 04             	sub    $0x4,%esp
  802f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  802f3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802f40:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f43:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	6a 00                	push   $0x0
  802f4c:	51                   	push   %ecx
  802f4d:	52                   	push   %edx
  802f4e:	ff 75 0c             	pushl  0xc(%ebp)
  802f51:	50                   	push   %eax
  802f52:	6a 18                	push   $0x18
  802f54:	e8 2e fd ff ff       	call   802c87 <syscall>
  802f59:	83 c4 18             	add    $0x18,%esp
}
  802f5c:	c9                   	leave  
  802f5d:	c3                   	ret    

00802f5e <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802f5e:	55                   	push   %ebp
  802f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802f61:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	6a 00                	push   $0x0
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	52                   	push   %edx
  802f6e:	50                   	push   %eax
  802f6f:	6a 19                	push   $0x19
  802f71:	e8 11 fd ff ff       	call   802c87 <syscall>
  802f76:	83 c4 18             	add    $0x18,%esp
}
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	6a 00                	push   $0x0
  802f87:	6a 00                	push   $0x0
  802f89:	50                   	push   %eax
  802f8a:	6a 1a                	push   $0x1a
  802f8c:	e8 f6 fc ff ff       	call   802c87 <syscall>
  802f91:	83 c4 18             	add    $0x18,%esp
}
  802f94:	c9                   	leave  
  802f95:	c3                   	ret    

00802f96 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802f96:	55                   	push   %ebp
  802f97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 00                	push   $0x0
  802fa1:	6a 00                	push   $0x0
  802fa3:	6a 1b                	push   $0x1b
  802fa5:	e8 dd fc ff ff       	call   802c87 <syscall>
  802faa:	83 c4 18             	add    $0x18,%esp
}
  802fad:	c9                   	leave  
  802fae:	c3                   	ret    

00802faf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802faf:	55                   	push   %ebp
  802fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802fb2:	6a 00                	push   $0x0
  802fb4:	6a 00                	push   $0x0
  802fb6:	6a 00                	push   $0x0
  802fb8:	6a 00                	push   $0x0
  802fba:	6a 00                	push   $0x0
  802fbc:	6a 1c                	push   $0x1c
  802fbe:	e8 c4 fc ff ff       	call   802c87 <syscall>
  802fc3:	83 c4 18             	add    $0x18,%esp
}
  802fc6:	c9                   	leave  
  802fc7:	c3                   	ret    

00802fc8 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802fc8:	55                   	push   %ebp
  802fc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	6a 00                	push   $0x0
  802fd0:	6a 00                	push   $0x0
  802fd2:	6a 00                	push   $0x0
  802fd4:	ff 75 0c             	pushl  0xc(%ebp)
  802fd7:	50                   	push   %eax
  802fd8:	6a 1d                	push   $0x1d
  802fda:	e8 a8 fc ff ff       	call   802c87 <syscall>
  802fdf:	83 c4 18             	add    $0x18,%esp
}
  802fe2:	c9                   	leave  
  802fe3:	c3                   	ret    

00802fe4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802fe4:	55                   	push   %ebp
  802fe5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	6a 00                	push   $0x0
  802fec:	6a 00                	push   $0x0
  802fee:	6a 00                	push   $0x0
  802ff0:	6a 00                	push   $0x0
  802ff2:	50                   	push   %eax
  802ff3:	6a 1e                	push   $0x1e
  802ff5:	e8 8d fc ff ff       	call   802c87 <syscall>
  802ffa:	83 c4 18             	add    $0x18,%esp
}
  802ffd:	90                   	nop
  802ffe:	c9                   	leave  
  802fff:	c3                   	ret    

00803000 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  803000:	55                   	push   %ebp
  803001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	6a 00                	push   $0x0
  803008:	6a 00                	push   $0x0
  80300a:	6a 00                	push   $0x0
  80300c:	6a 00                	push   $0x0
  80300e:	50                   	push   %eax
  80300f:	6a 1f                	push   $0x1f
  803011:	e8 71 fc ff ff       	call   802c87 <syscall>
  803016:	83 c4 18             	add    $0x18,%esp
}
  803019:	90                   	nop
  80301a:	c9                   	leave  
  80301b:	c3                   	ret    

0080301c <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80301c:	55                   	push   %ebp
  80301d:	89 e5                	mov    %esp,%ebp
  80301f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803022:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803025:	8d 50 04             	lea    0x4(%eax),%edx
  803028:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80302b:	6a 00                	push   $0x0
  80302d:	6a 00                	push   $0x0
  80302f:	6a 00                	push   $0x0
  803031:	52                   	push   %edx
  803032:	50                   	push   %eax
  803033:	6a 20                	push   $0x20
  803035:	e8 4d fc ff ff       	call   802c87 <syscall>
  80303a:	83 c4 18             	add    $0x18,%esp
	return result;
  80303d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803040:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803043:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803046:	89 01                	mov    %eax,(%ecx)
  803048:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	c9                   	leave  
  80304f:	c2 04 00             	ret    $0x4

00803052 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803052:	55                   	push   %ebp
  803053:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803055:	6a 00                	push   $0x0
  803057:	6a 00                	push   $0x0
  803059:	ff 75 10             	pushl  0x10(%ebp)
  80305c:	ff 75 0c             	pushl  0xc(%ebp)
  80305f:	ff 75 08             	pushl  0x8(%ebp)
  803062:	6a 0f                	push   $0xf
  803064:	e8 1e fc ff ff       	call   802c87 <syscall>
  803069:	83 c4 18             	add    $0x18,%esp
	return ;
  80306c:	90                   	nop
}
  80306d:	c9                   	leave  
  80306e:	c3                   	ret    

0080306f <sys_rcr2>:
uint32 sys_rcr2()
{
  80306f:	55                   	push   %ebp
  803070:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803072:	6a 00                	push   $0x0
  803074:	6a 00                	push   $0x0
  803076:	6a 00                	push   $0x0
  803078:	6a 00                	push   $0x0
  80307a:	6a 00                	push   $0x0
  80307c:	6a 21                	push   $0x21
  80307e:	e8 04 fc ff ff       	call   802c87 <syscall>
  803083:	83 c4 18             	add    $0x18,%esp
}
  803086:	c9                   	leave  
  803087:	c3                   	ret    

00803088 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  803088:	55                   	push   %ebp
  803089:	89 e5                	mov    %esp,%ebp
  80308b:	83 ec 04             	sub    $0x4,%esp
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803094:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803098:	6a 00                	push   $0x0
  80309a:	6a 00                	push   $0x0
  80309c:	6a 00                	push   $0x0
  80309e:	6a 00                	push   $0x0
  8030a0:	50                   	push   %eax
  8030a1:	6a 22                	push   $0x22
  8030a3:	e8 df fb ff ff       	call   802c87 <syscall>
  8030a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8030ab:	90                   	nop
}
  8030ac:	c9                   	leave  
  8030ad:	c3                   	ret    

008030ae <rsttst>:
void rsttst()
{
  8030ae:	55                   	push   %ebp
  8030af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	6a 00                	push   $0x0
  8030bb:	6a 24                	push   $0x24
  8030bd:	e8 c5 fb ff ff       	call   802c87 <syscall>
  8030c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8030c5:	90                   	nop
}
  8030c6:	c9                   	leave  
  8030c7:	c3                   	ret    

008030c8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8030c8:	55                   	push   %ebp
  8030c9:	89 e5                	mov    %esp,%ebp
  8030cb:	83 ec 04             	sub    $0x4,%esp
  8030ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8030d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8030d4:	8b 55 18             	mov    0x18(%ebp),%edx
  8030d7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030db:	52                   	push   %edx
  8030dc:	50                   	push   %eax
  8030dd:	ff 75 10             	pushl  0x10(%ebp)
  8030e0:	ff 75 0c             	pushl  0xc(%ebp)
  8030e3:	ff 75 08             	pushl  0x8(%ebp)
  8030e6:	6a 23                	push   $0x23
  8030e8:	e8 9a fb ff ff       	call   802c87 <syscall>
  8030ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8030f0:	90                   	nop
}
  8030f1:	c9                   	leave  
  8030f2:	c3                   	ret    

008030f3 <chktst>:
void chktst(uint32 n)
{
  8030f3:	55                   	push   %ebp
  8030f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 00                	push   $0x0
  8030fc:	6a 00                	push   $0x0
  8030fe:	ff 75 08             	pushl  0x8(%ebp)
  803101:	6a 25                	push   $0x25
  803103:	e8 7f fb ff ff       	call   802c87 <syscall>
  803108:	83 c4 18             	add    $0x18,%esp
	return ;
  80310b:	90                   	nop
}
  80310c:	c9                   	leave  
  80310d:	c3                   	ret    

0080310e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80310e:	55                   	push   %ebp
  80310f:	89 e5                	mov    %esp,%ebp
  803111:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803114:	6a 00                	push   $0x0
  803116:	6a 00                	push   $0x0
  803118:	6a 00                	push   $0x0
  80311a:	6a 00                	push   $0x0
  80311c:	6a 00                	push   $0x0
  80311e:	6a 26                	push   $0x26
  803120:	e8 62 fb ff ff       	call   802c87 <syscall>
  803125:	83 c4 18             	add    $0x18,%esp
  803128:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80312b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80312f:	75 07                	jne    803138 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  803131:	b8 01 00 00 00       	mov    $0x1,%eax
  803136:	eb 05                	jmp    80313d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  803138:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    

0080313f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80313f:	55                   	push   %ebp
  803140:	89 e5                	mov    %esp,%ebp
  803142:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	6a 00                	push   $0x0
  80314b:	6a 00                	push   $0x0
  80314d:	6a 00                	push   $0x0
  80314f:	6a 26                	push   $0x26
  803151:	e8 31 fb ff ff       	call   802c87 <syscall>
  803156:	83 c4 18             	add    $0x18,%esp
  803159:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80315c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803160:	75 07                	jne    803169 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803162:	b8 01 00 00 00       	mov    $0x1,%eax
  803167:	eb 05                	jmp    80316e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803169:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80316e:	c9                   	leave  
  80316f:	c3                   	ret    

00803170 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803170:	55                   	push   %ebp
  803171:	89 e5                	mov    %esp,%ebp
  803173:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 00                	push   $0x0
  80317e:	6a 00                	push   $0x0
  803180:	6a 26                	push   $0x26
  803182:	e8 00 fb ff ff       	call   802c87 <syscall>
  803187:	83 c4 18             	add    $0x18,%esp
  80318a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80318d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803191:	75 07                	jne    80319a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803193:	b8 01 00 00 00       	mov    $0x1,%eax
  803198:	eb 05                	jmp    80319f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319f:	c9                   	leave  
  8031a0:	c3                   	ret    

008031a1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8031a1:	55                   	push   %ebp
  8031a2:	89 e5                	mov    %esp,%ebp
  8031a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031a7:	6a 00                	push   $0x0
  8031a9:	6a 00                	push   $0x0
  8031ab:	6a 00                	push   $0x0
  8031ad:	6a 00                	push   $0x0
  8031af:	6a 00                	push   $0x0
  8031b1:	6a 26                	push   $0x26
  8031b3:	e8 cf fa ff ff       	call   802c87 <syscall>
  8031b8:	83 c4 18             	add    $0x18,%esp
  8031bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8031be:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8031c2:	75 07                	jne    8031cb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8031c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c9:	eb 05                	jmp    8031d0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8031cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031d0:	c9                   	leave  
  8031d1:	c3                   	ret    

008031d2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8031d2:	55                   	push   %ebp
  8031d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8031d5:	6a 00                	push   $0x0
  8031d7:	6a 00                	push   $0x0
  8031d9:	6a 00                	push   $0x0
  8031db:	6a 00                	push   $0x0
  8031dd:	ff 75 08             	pushl  0x8(%ebp)
  8031e0:	6a 27                	push   $0x27
  8031e2:	e8 a0 fa ff ff       	call   802c87 <syscall>
  8031e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ea:	90                   	nop
}
  8031eb:	c9                   	leave  
  8031ec:	c3                   	ret    
  8031ed:	66 90                	xchg   %ax,%ax
  8031ef:	90                   	nop

008031f0 <__udivdi3>:
  8031f0:	55                   	push   %ebp
  8031f1:	57                   	push   %edi
  8031f2:	56                   	push   %esi
  8031f3:	53                   	push   %ebx
  8031f4:	83 ec 1c             	sub    $0x1c,%esp
  8031f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803203:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803207:	89 ca                	mov    %ecx,%edx
  803209:	89 f8                	mov    %edi,%eax
  80320b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80320f:	85 f6                	test   %esi,%esi
  803211:	75 2d                	jne    803240 <__udivdi3+0x50>
  803213:	39 cf                	cmp    %ecx,%edi
  803215:	77 65                	ja     80327c <__udivdi3+0x8c>
  803217:	89 fd                	mov    %edi,%ebp
  803219:	85 ff                	test   %edi,%edi
  80321b:	75 0b                	jne    803228 <__udivdi3+0x38>
  80321d:	b8 01 00 00 00       	mov    $0x1,%eax
  803222:	31 d2                	xor    %edx,%edx
  803224:	f7 f7                	div    %edi
  803226:	89 c5                	mov    %eax,%ebp
  803228:	31 d2                	xor    %edx,%edx
  80322a:	89 c8                	mov    %ecx,%eax
  80322c:	f7 f5                	div    %ebp
  80322e:	89 c1                	mov    %eax,%ecx
  803230:	89 d8                	mov    %ebx,%eax
  803232:	f7 f5                	div    %ebp
  803234:	89 cf                	mov    %ecx,%edi
  803236:	89 fa                	mov    %edi,%edx
  803238:	83 c4 1c             	add    $0x1c,%esp
  80323b:	5b                   	pop    %ebx
  80323c:	5e                   	pop    %esi
  80323d:	5f                   	pop    %edi
  80323e:	5d                   	pop    %ebp
  80323f:	c3                   	ret    
  803240:	39 ce                	cmp    %ecx,%esi
  803242:	77 28                	ja     80326c <__udivdi3+0x7c>
  803244:	0f bd fe             	bsr    %esi,%edi
  803247:	83 f7 1f             	xor    $0x1f,%edi
  80324a:	75 40                	jne    80328c <__udivdi3+0x9c>
  80324c:	39 ce                	cmp    %ecx,%esi
  80324e:	72 0a                	jb     80325a <__udivdi3+0x6a>
  803250:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803254:	0f 87 9e 00 00 00    	ja     8032f8 <__udivdi3+0x108>
  80325a:	b8 01 00 00 00       	mov    $0x1,%eax
  80325f:	89 fa                	mov    %edi,%edx
  803261:	83 c4 1c             	add    $0x1c,%esp
  803264:	5b                   	pop    %ebx
  803265:	5e                   	pop    %esi
  803266:	5f                   	pop    %edi
  803267:	5d                   	pop    %ebp
  803268:	c3                   	ret    
  803269:	8d 76 00             	lea    0x0(%esi),%esi
  80326c:	31 ff                	xor    %edi,%edi
  80326e:	31 c0                	xor    %eax,%eax
  803270:	89 fa                	mov    %edi,%edx
  803272:	83 c4 1c             	add    $0x1c,%esp
  803275:	5b                   	pop    %ebx
  803276:	5e                   	pop    %esi
  803277:	5f                   	pop    %edi
  803278:	5d                   	pop    %ebp
  803279:	c3                   	ret    
  80327a:	66 90                	xchg   %ax,%ax
  80327c:	89 d8                	mov    %ebx,%eax
  80327e:	f7 f7                	div    %edi
  803280:	31 ff                	xor    %edi,%edi
  803282:	89 fa                	mov    %edi,%edx
  803284:	83 c4 1c             	add    $0x1c,%esp
  803287:	5b                   	pop    %ebx
  803288:	5e                   	pop    %esi
  803289:	5f                   	pop    %edi
  80328a:	5d                   	pop    %ebp
  80328b:	c3                   	ret    
  80328c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803291:	89 eb                	mov    %ebp,%ebx
  803293:	29 fb                	sub    %edi,%ebx
  803295:	89 f9                	mov    %edi,%ecx
  803297:	d3 e6                	shl    %cl,%esi
  803299:	89 c5                	mov    %eax,%ebp
  80329b:	88 d9                	mov    %bl,%cl
  80329d:	d3 ed                	shr    %cl,%ebp
  80329f:	89 e9                	mov    %ebp,%ecx
  8032a1:	09 f1                	or     %esi,%ecx
  8032a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032a7:	89 f9                	mov    %edi,%ecx
  8032a9:	d3 e0                	shl    %cl,%eax
  8032ab:	89 c5                	mov    %eax,%ebp
  8032ad:	89 d6                	mov    %edx,%esi
  8032af:	88 d9                	mov    %bl,%cl
  8032b1:	d3 ee                	shr    %cl,%esi
  8032b3:	89 f9                	mov    %edi,%ecx
  8032b5:	d3 e2                	shl    %cl,%edx
  8032b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032bb:	88 d9                	mov    %bl,%cl
  8032bd:	d3 e8                	shr    %cl,%eax
  8032bf:	09 c2                	or     %eax,%edx
  8032c1:	89 d0                	mov    %edx,%eax
  8032c3:	89 f2                	mov    %esi,%edx
  8032c5:	f7 74 24 0c          	divl   0xc(%esp)
  8032c9:	89 d6                	mov    %edx,%esi
  8032cb:	89 c3                	mov    %eax,%ebx
  8032cd:	f7 e5                	mul    %ebp
  8032cf:	39 d6                	cmp    %edx,%esi
  8032d1:	72 19                	jb     8032ec <__udivdi3+0xfc>
  8032d3:	74 0b                	je     8032e0 <__udivdi3+0xf0>
  8032d5:	89 d8                	mov    %ebx,%eax
  8032d7:	31 ff                	xor    %edi,%edi
  8032d9:	e9 58 ff ff ff       	jmp    803236 <__udivdi3+0x46>
  8032de:	66 90                	xchg   %ax,%ax
  8032e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032e4:	89 f9                	mov    %edi,%ecx
  8032e6:	d3 e2                	shl    %cl,%edx
  8032e8:	39 c2                	cmp    %eax,%edx
  8032ea:	73 e9                	jae    8032d5 <__udivdi3+0xe5>
  8032ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032ef:	31 ff                	xor    %edi,%edi
  8032f1:	e9 40 ff ff ff       	jmp    803236 <__udivdi3+0x46>
  8032f6:	66 90                	xchg   %ax,%ax
  8032f8:	31 c0                	xor    %eax,%eax
  8032fa:	e9 37 ff ff ff       	jmp    803236 <__udivdi3+0x46>
  8032ff:	90                   	nop

00803300 <__umoddi3>:
  803300:	55                   	push   %ebp
  803301:	57                   	push   %edi
  803302:	56                   	push   %esi
  803303:	53                   	push   %ebx
  803304:	83 ec 1c             	sub    $0x1c,%esp
  803307:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80330b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80330f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803313:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803317:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80331b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80331f:	89 f3                	mov    %esi,%ebx
  803321:	89 fa                	mov    %edi,%edx
  803323:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803327:	89 34 24             	mov    %esi,(%esp)
  80332a:	85 c0                	test   %eax,%eax
  80332c:	75 1a                	jne    803348 <__umoddi3+0x48>
  80332e:	39 f7                	cmp    %esi,%edi
  803330:	0f 86 a2 00 00 00    	jbe    8033d8 <__umoddi3+0xd8>
  803336:	89 c8                	mov    %ecx,%eax
  803338:	89 f2                	mov    %esi,%edx
  80333a:	f7 f7                	div    %edi
  80333c:	89 d0                	mov    %edx,%eax
  80333e:	31 d2                	xor    %edx,%edx
  803340:	83 c4 1c             	add    $0x1c,%esp
  803343:	5b                   	pop    %ebx
  803344:	5e                   	pop    %esi
  803345:	5f                   	pop    %edi
  803346:	5d                   	pop    %ebp
  803347:	c3                   	ret    
  803348:	39 f0                	cmp    %esi,%eax
  80334a:	0f 87 ac 00 00 00    	ja     8033fc <__umoddi3+0xfc>
  803350:	0f bd e8             	bsr    %eax,%ebp
  803353:	83 f5 1f             	xor    $0x1f,%ebp
  803356:	0f 84 ac 00 00 00    	je     803408 <__umoddi3+0x108>
  80335c:	bf 20 00 00 00       	mov    $0x20,%edi
  803361:	29 ef                	sub    %ebp,%edi
  803363:	89 fe                	mov    %edi,%esi
  803365:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803369:	89 e9                	mov    %ebp,%ecx
  80336b:	d3 e0                	shl    %cl,%eax
  80336d:	89 d7                	mov    %edx,%edi
  80336f:	89 f1                	mov    %esi,%ecx
  803371:	d3 ef                	shr    %cl,%edi
  803373:	09 c7                	or     %eax,%edi
  803375:	89 e9                	mov    %ebp,%ecx
  803377:	d3 e2                	shl    %cl,%edx
  803379:	89 14 24             	mov    %edx,(%esp)
  80337c:	89 d8                	mov    %ebx,%eax
  80337e:	d3 e0                	shl    %cl,%eax
  803380:	89 c2                	mov    %eax,%edx
  803382:	8b 44 24 08          	mov    0x8(%esp),%eax
  803386:	d3 e0                	shl    %cl,%eax
  803388:	89 44 24 04          	mov    %eax,0x4(%esp)
  80338c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803390:	89 f1                	mov    %esi,%ecx
  803392:	d3 e8                	shr    %cl,%eax
  803394:	09 d0                	or     %edx,%eax
  803396:	d3 eb                	shr    %cl,%ebx
  803398:	89 da                	mov    %ebx,%edx
  80339a:	f7 f7                	div    %edi
  80339c:	89 d3                	mov    %edx,%ebx
  80339e:	f7 24 24             	mull   (%esp)
  8033a1:	89 c6                	mov    %eax,%esi
  8033a3:	89 d1                	mov    %edx,%ecx
  8033a5:	39 d3                	cmp    %edx,%ebx
  8033a7:	0f 82 87 00 00 00    	jb     803434 <__umoddi3+0x134>
  8033ad:	0f 84 91 00 00 00    	je     803444 <__umoddi3+0x144>
  8033b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033b7:	29 f2                	sub    %esi,%edx
  8033b9:	19 cb                	sbb    %ecx,%ebx
  8033bb:	89 d8                	mov    %ebx,%eax
  8033bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8033c1:	d3 e0                	shl    %cl,%eax
  8033c3:	89 e9                	mov    %ebp,%ecx
  8033c5:	d3 ea                	shr    %cl,%edx
  8033c7:	09 d0                	or     %edx,%eax
  8033c9:	89 e9                	mov    %ebp,%ecx
  8033cb:	d3 eb                	shr    %cl,%ebx
  8033cd:	89 da                	mov    %ebx,%edx
  8033cf:	83 c4 1c             	add    $0x1c,%esp
  8033d2:	5b                   	pop    %ebx
  8033d3:	5e                   	pop    %esi
  8033d4:	5f                   	pop    %edi
  8033d5:	5d                   	pop    %ebp
  8033d6:	c3                   	ret    
  8033d7:	90                   	nop
  8033d8:	89 fd                	mov    %edi,%ebp
  8033da:	85 ff                	test   %edi,%edi
  8033dc:	75 0b                	jne    8033e9 <__umoddi3+0xe9>
  8033de:	b8 01 00 00 00       	mov    $0x1,%eax
  8033e3:	31 d2                	xor    %edx,%edx
  8033e5:	f7 f7                	div    %edi
  8033e7:	89 c5                	mov    %eax,%ebp
  8033e9:	89 f0                	mov    %esi,%eax
  8033eb:	31 d2                	xor    %edx,%edx
  8033ed:	f7 f5                	div    %ebp
  8033ef:	89 c8                	mov    %ecx,%eax
  8033f1:	f7 f5                	div    %ebp
  8033f3:	89 d0                	mov    %edx,%eax
  8033f5:	e9 44 ff ff ff       	jmp    80333e <__umoddi3+0x3e>
  8033fa:	66 90                	xchg   %ax,%ax
  8033fc:	89 c8                	mov    %ecx,%eax
  8033fe:	89 f2                	mov    %esi,%edx
  803400:	83 c4 1c             	add    $0x1c,%esp
  803403:	5b                   	pop    %ebx
  803404:	5e                   	pop    %esi
  803405:	5f                   	pop    %edi
  803406:	5d                   	pop    %ebp
  803407:	c3                   	ret    
  803408:	3b 04 24             	cmp    (%esp),%eax
  80340b:	72 06                	jb     803413 <__umoddi3+0x113>
  80340d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803411:	77 0f                	ja     803422 <__umoddi3+0x122>
  803413:	89 f2                	mov    %esi,%edx
  803415:	29 f9                	sub    %edi,%ecx
  803417:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80341b:	89 14 24             	mov    %edx,(%esp)
  80341e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803422:	8b 44 24 04          	mov    0x4(%esp),%eax
  803426:	8b 14 24             	mov    (%esp),%edx
  803429:	83 c4 1c             	add    $0x1c,%esp
  80342c:	5b                   	pop    %ebx
  80342d:	5e                   	pop    %esi
  80342e:	5f                   	pop    %edi
  80342f:	5d                   	pop    %ebp
  803430:	c3                   	ret    
  803431:	8d 76 00             	lea    0x0(%esi),%esi
  803434:	2b 04 24             	sub    (%esp),%eax
  803437:	19 fa                	sbb    %edi,%edx
  803439:	89 d1                	mov    %edx,%ecx
  80343b:	89 c6                	mov    %eax,%esi
  80343d:	e9 71 ff ff ff       	jmp    8033b3 <__umoddi3+0xb3>
  803442:	66 90                	xchg   %ax,%ax
  803444:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803448:	72 ea                	jb     803434 <__umoddi3+0x134>
  80344a:	89 d9                	mov    %ebx,%ecx
  80344c:	e9 62 ff ff ff       	jmp    8033b3 <__umoddi3+0xb3>
