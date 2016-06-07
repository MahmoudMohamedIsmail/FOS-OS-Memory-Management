
obj/user/tst_worstfit:     file format elf32-i386


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
  800031:	e8 79 0b 00 00       	call   800baf <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp

	int count = 0;
  800043:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int totalNumberOfTests = 11;
  80004a:	c7 45 e4 0b 00 00 00 	movl   $0xb,-0x1c(%ebp)
	int envID = sys_getenvid();
  800051:	e8 e6 25 00 00       	call   80263c <sys_getenvid>
  800056:	89 45 e0             	mov    %eax,-0x20(%ebp)

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80005c:	89 d0                	mov    %edx,%eax
  80005e:	c1 e0 03             	shl    $0x3,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	01 c0                	add    %eax,%eax
  800065:	01 d0                	add    %edx,%eax
  800067:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80006e:	01 d0                	add    %edx,%eax
  800070:	c1 e0 03             	shl    $0x3,%eax
  800073:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800078:	89 45 dc             	mov    %eax,-0x24(%ebp)

	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	6a 04                	push   $0x4
  800080:	e8 86 2a 00 00       	call   802b0b <sys_set_uheap_strategy>
  800085:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  800088:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  80008f:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80009c:	68 a0 2d 80 00       	push   $0x802da0
  8000a1:	e8 f5 0c 00 00       	call   800d9b <cprintf>
  8000a6:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  8000a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  8000b0:	c7 45 d0 02 00 00 00 	movl   $0x2,-0x30(%ebp)
	int numOfEmptyWSLocs = 0;
  8000b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8000be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c5:	eb 24                	jmp    8000eb <_main+0xb3>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8000c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000ca:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8000d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	01 c8                	add    %ecx,%eax
  8000de:	8a 40 04             	mov    0x4(%eax),%al
  8000e1:	3c 01                	cmp    $0x1,%al
  8000e3:	75 03                	jne    8000e8 <_main+0xb0>
			numOfEmptyWSLocs++;
  8000e5:	ff 45 f0             	incl   -0x10(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8000e8:	ff 45 f4             	incl   -0xc(%ebp)
  8000eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000ee:	8b 50 74             	mov    0x74(%eax),%edx
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	39 c2                	cmp    %eax,%edx
  8000f6:	77 cf                	ja     8000c7 <_main+0x8f>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8000f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000fb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8000fe:	7d 14                	jge    800114 <_main+0xdc>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	68 ec 2d 80 00       	push   $0x802dec
  800108:	6a 24                	push   $0x24
  80010a:	68 3c 2e 80 00       	push   $0x802e3c
  80010f:	e8 5c 0b 00 00       	call   800c70 <_panic>

	void* ptr_allocations[512] = {0};
  800114:	8d 95 c4 f7 ff ff    	lea    -0x83c(%ebp),%edx
  80011a:	b9 00 02 00 00       	mov    $0x200,%ecx
  80011f:	b8 00 00 00 00       	mov    $0x0,%eax
  800124:	89 d7                	mov    %edx,%edi
  800126:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  800128:	e8 c1 25 00 00       	call   8026ee <sys_calculate_free_frames>
  80012d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800130:	e8 3c 26 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800135:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for(i = 0; i< 256;i++)
  800138:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80013f:	eb 20                	jmp    800161 <_main+0x129>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800141:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800144:	01 c0                	add    %eax,%eax
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	50                   	push   %eax
  80014a:	e8 cf 19 00 00       	call   801b1e <malloc>
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	89 c2                	mov    %eax,%edx
  800154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800157:	89 94 85 c4 f7 ff ff 	mov    %edx,-0x83c(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  80015e:	ff 45 ec             	incl   -0x14(%ebp)
  800161:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%ebp)
  800168:	7e d7                	jle    800141 <_main+0x109>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  80016a:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800170:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800175:	75 4e                	jne    8001c5 <_main+0x18d>
		(uint32)ptr_allocations[2] != 0x80400000 ||
  800177:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  80017d:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800182:	75 41                	jne    8001c5 <_main+0x18d>
		(uint32)ptr_allocations[2] != 0x80400000 ||
		(uint32)ptr_allocations[8] != 0x81000000 ||
  800184:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
		(uint32)ptr_allocations[2] != 0x80400000 ||
  80018a:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  80018f:	75 34                	jne    8001c5 <_main+0x18d>
		(uint32)ptr_allocations[8] != 0x81000000 ||
		(uint32)ptr_allocations[100] != 0x8C800000 ||
  800191:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
		(uint32)ptr_allocations[2] != 0x80400000 ||
		(uint32)ptr_allocations[8] != 0x81000000 ||
  800197:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  80019c:	75 27                	jne    8001c5 <_main+0x18d>
		(uint32)ptr_allocations[100] != 0x8C800000 ||
		(uint32)ptr_allocations[150] != 0x92C00000 ||
  80019e:	8b 85 1c fa ff ff    	mov    -0x5e4(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
		(uint32)ptr_allocations[2] != 0x80400000 ||
		(uint32)ptr_allocations[8] != 0x81000000 ||
		(uint32)ptr_allocations[100] != 0x8C800000 ||
  8001a4:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  8001a9:	75 1a                	jne    8001c5 <_main+0x18d>
		(uint32)ptr_allocations[150] != 0x92C00000 ||
		(uint32)ptr_allocations[200] != 0x99000000 ||
  8001ab:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
		(uint32)ptr_allocations[2] != 0x80400000 ||
		(uint32)ptr_allocations[8] != 0x81000000 ||
		(uint32)ptr_allocations[100] != 0x8C800000 ||
		(uint32)ptr_allocations[150] != 0x92C00000 ||
  8001b1:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  8001b6:	75 0d                	jne    8001c5 <_main+0x18d>
		(uint32)ptr_allocations[200] != 0x99000000 ||
		(uint32)ptr_allocations[255] != 0x9FE00000)
  8001b8:	8b 85 c0 fb ff ff    	mov    -0x440(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
		(uint32)ptr_allocations[2] != 0x80400000 ||
		(uint32)ptr_allocations[8] != 0x81000000 ||
		(uint32)ptr_allocations[100] != 0x8C800000 ||
		(uint32)ptr_allocations[150] != 0x92C00000 ||
		(uint32)ptr_allocations[200] != 0x99000000 ||
  8001be:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
		(uint32)ptr_allocations[255] != 0x9FE00000)
			panic("Wrong allocation, Check fitting strategy is working correctly");
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 50 2e 80 00       	push   $0x802e50
  8001cd:	6a 39                	push   $0x39
  8001cf:	68 3c 2e 80 00       	push   $0x802e3c
  8001d4:	e8 97 0a 00 00       	call   800c70 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8001d9:	e8 93 25 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  8001de:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8001e1:	89 c2                	mov    %eax,%edx
  8001e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e6:	c1 e0 09             	shl    $0x9,%eax
  8001e9:	85 c0                	test   %eax,%eax
  8001eb:	79 05                	jns    8001f2 <_main+0x1ba>
  8001ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8001f2:	c1 f8 0c             	sar    $0xc,%eax
  8001f5:	39 c2                	cmp    %eax,%edx
  8001f7:	74 14                	je     80020d <_main+0x1d5>
  8001f9:	83 ec 04             	sub    $0x4,%esp
  8001fc:	68 8e 2e 80 00       	push   $0x802e8e
  800201:	6a 3b                	push   $0x3b
  800203:	68 3c 2e 80 00       	push   $0x802e3c
  800208:	e8 63 0a 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  80020d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800210:	e8 d9 24 00 00       	call   8026ee <sys_calculate_free_frames>
  800215:	29 c3                	sub    %eax,%ebx
  800217:	89 da                	mov    %ebx,%edx
  800219:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021c:	c1 e0 09             	shl    $0x9,%eax
  80021f:	85 c0                	test   %eax,%eax
  800221:	79 05                	jns    800228 <_main+0x1f0>
  800223:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  800228:	c1 f8 16             	sar    $0x16,%eax
  80022b:	39 c2                	cmp    %eax,%edx
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 ab 2e 80 00       	push   $0x802eab
  800237:	6a 3c                	push   $0x3c
  800239:	68 3c 2e 80 00       	push   $0x802e3c
  80023e:	e8 2d 0a 00 00       	call   800c70 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800243:	e8 a6 24 00 00       	call   8026ee <sys_calculate_free_frames>
  800248:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 21 25 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800250:	89 45 c8             	mov    %eax,-0x38(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800253:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	50                   	push   %eax
  80025d:	e8 5e 22 00 00       	call   8024c0 <free>
  800262:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800265:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	e8 4c 22 00 00       	call   8024c0 <free>
  800274:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  800277:	8b 85 d0 f7 ff ff    	mov    -0x830(%ebp),%eax
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	50                   	push   %eax
  800281:	e8 3a 22 00 00       	call   8024c0 <free>
  800286:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800289:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 28 22 00 00       	call   8024c0 <free>
  800298:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  80029b:	8b 85 f4 f7 ff ff    	mov    -0x80c(%ebp),%eax
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	50                   	push   %eax
  8002a5:	e8 16 22 00 00       	call   8024c0 <free>
  8002aa:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8002ad:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	50                   	push   %eax
  8002b7:	e8 04 22 00 00       	call   8024c0 <free>
  8002bc:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8002bf:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	50                   	push   %eax
  8002c9:	e8 f2 21 00 00       	call   8024c0 <free>
  8002ce:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8002d1:	8b 85 64 f9 ff ff    	mov    -0x69c(%ebp),%eax
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	50                   	push   %eax
  8002db:	e8 e0 21 00 00       	call   8024c0 <free>
  8002e0:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8002e3:	8b 85 60 f9 ff ff    	mov    -0x6a0(%ebp),%eax
  8002e9:	83 ec 0c             	sub    $0xc,%esp
  8002ec:	50                   	push   %eax
  8002ed:	e8 ce 21 00 00       	call   8024c0 <free>
  8002f2:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8002f5:	8b 85 5c f9 ff ff    	mov    -0x6a4(%ebp),%eax
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	50                   	push   %eax
  8002ff:	e8 bc 21 00 00       	call   8024c0 <free>
  800304:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  800307:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	50                   	push   %eax
  800311:	e8 aa 21 00 00       	call   8024c0 <free>
  800316:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800319:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	50                   	push   %eax
  800323:	e8 98 21 00 00       	call   8024c0 <free>
  800328:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  80032b:	8b 85 e8 fa ff ff    	mov    -0x518(%ebp),%eax
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	50                   	push   %eax
  800335:	e8 86 21 00 00       	call   8024c0 <free>
  80033a:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  80033d:	8b 85 ec fa ff ff    	mov    -0x514(%ebp),%eax
  800343:	83 ec 0c             	sub    $0xc,%esp
  800346:	50                   	push   %eax
  800347:	e8 74 21 00 00       	call   8024c0 <free>
  80034c:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  80034f:	8b 85 f0 fa ff ff    	mov    -0x510(%ebp),%eax
  800355:	83 ec 0c             	sub    $0xc,%esp
  800358:	50                   	push   %eax
  800359:	e8 62 21 00 00       	call   8024c0 <free>
  80035e:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800361:	e8 0b 24 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800366:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800369:	89 d1                	mov    %edx,%ecx
  80036b:	29 c1                	sub    %eax,%ecx
  80036d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800370:	89 d0                	mov    %edx,%eax
  800372:	01 c0                	add    %eax,%eax
  800374:	01 d0                	add    %edx,%eax
  800376:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	01 c0                	add    %eax,%eax
  800381:	85 c0                	test   %eax,%eax
  800383:	79 05                	jns    80038a <_main+0x352>
  800385:	05 ff 0f 00 00       	add    $0xfff,%eax
  80038a:	c1 f8 0c             	sar    $0xc,%eax
  80038d:	39 c1                	cmp    %eax,%ecx
  80038f:	74 14                	je     8003a5 <_main+0x36d>
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	68 bc 2e 80 00       	push   $0x802ebc
  800399:	6a 52                	push   $0x52
  80039b:	68 3c 2e 80 00       	push   $0x802e3c
  8003a0:	e8 cb 08 00 00       	call   800c70 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  8003a5:	e8 44 23 00 00       	call   8026ee <sys_calculate_free_frames>
  8003aa:	89 c2                	mov    %eax,%edx
  8003ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003af:	39 c2                	cmp    %eax,%edx
  8003b1:	74 14                	je     8003c7 <_main+0x38f>
  8003b3:	83 ec 04             	sub    $0x4,%esp
  8003b6:	68 f8 2e 80 00       	push   $0x802ef8
  8003bb:	6a 53                	push   $0x53
  8003bd:	68 3c 2e 80 00       	push   $0x802e3c
  8003c2:	e8 a9 08 00 00       	call   800c70 <_panic>

	// Test worst fit
	freeFrames = sys_calculate_free_frames() ;
  8003c7:	e8 22 23 00 00       	call   8026ee <sys_calculate_free_frames>
  8003cc:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8003cf:	e8 9d 23 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  8003d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	void* tempAddress = malloc(Mega);
  8003d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	50                   	push   %eax
  8003de:	e8 3b 17 00 00       	call   801b1e <malloc>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	// Use Hole 4 -> Hole 4 = 9 M
	//cprintf("adrr= %d",((uint32)tempAddress-USER_HEAP_START)/PAGE_SIZE);
	if((uint32)tempAddress != 0x8C800000)
  8003e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003ec:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8003f1:	74 14                	je     800407 <_main+0x3cf>
		panic("Worst Fit not working correctly");
  8003f3:	83 ec 04             	sub    $0x4,%esp
  8003f6:	68 38 2f 80 00       	push   $0x802f38
  8003fb:	6a 5c                	push   $0x5c
  8003fd:	68 3c 2e 80 00       	push   $0x802e3c
  800402:	e8 69 08 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800407:	e8 65 23 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  80040c:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80040f:	89 c2                	mov    %eax,%edx
  800411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800414:	85 c0                	test   %eax,%eax
  800416:	79 05                	jns    80041d <_main+0x3e5>
  800418:	05 ff 0f 00 00       	add    $0xfff,%eax
  80041d:	c1 f8 0c             	sar    $0xc,%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	74 14                	je     800438 <_main+0x400>
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 8e 2e 80 00       	push   $0x802e8e
  80042c:	6a 5d                	push   $0x5d
  80042e:	68 3c 2e 80 00       	push   $0x802e3c
  800433:	e8 38 08 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800438:	e8 b1 22 00 00       	call   8026ee <sys_calculate_free_frames>
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800442:	39 c2                	cmp    %eax,%edx
  800444:	74 14                	je     80045a <_main+0x422>
  800446:	83 ec 04             	sub    $0x4,%esp
  800449:	68 ab 2e 80 00       	push   $0x802eab
  80044e:	6a 5e                	push   $0x5e
  800450:	68 3c 2e 80 00       	push   $0x802e3c
  800455:	e8 16 08 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  80045a:	ff 45 e8             	incl   -0x18(%ebp)
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	ff 75 e8             	pushl  -0x18(%ebp)
  800463:	68 58 2f 80 00       	push   $0x802f58
  800468:	e8 2e 09 00 00       	call   800d9b <cprintf>
  80046d:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800470:	e8 79 22 00 00       	call   8026ee <sys_calculate_free_frames>
  800475:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800478:	e8 f4 22 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  80047d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  800480:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800483:	c1 e0 02             	shl    $0x2,%eax
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	50                   	push   %eax
  80048a:	e8 8f 16 00 00       	call   801b1e <malloc>
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  800495:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800498:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  80049d:	74 14                	je     8004b3 <_main+0x47b>
		panic("Worst Fit not working correctly");
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	68 38 2f 80 00       	push   $0x802f38
  8004a7:	6a 65                	push   $0x65
  8004a9:	68 3c 2e 80 00       	push   $0x802e3c
  8004ae:	e8 bd 07 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004b3:	e8 b9 22 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  8004b8:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8004bb:	89 c2                	mov    %eax,%edx
  8004bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c0:	c1 e0 02             	shl    $0x2,%eax
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	79 05                	jns    8004cc <_main+0x494>
  8004c7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004cc:	c1 f8 0c             	sar    $0xc,%eax
  8004cf:	39 c2                	cmp    %eax,%edx
  8004d1:	74 14                	je     8004e7 <_main+0x4af>
  8004d3:	83 ec 04             	sub    $0x4,%esp
  8004d6:	68 8e 2e 80 00       	push   $0x802e8e
  8004db:	6a 66                	push   $0x66
  8004dd:	68 3c 2e 80 00       	push   $0x802e3c
  8004e2:	e8 89 07 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004e7:	e8 02 22 00 00       	call   8026ee <sys_calculate_free_frames>
  8004ec:	89 c2                	mov    %eax,%edx
  8004ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f1:	39 c2                	cmp    %eax,%edx
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 ab 2e 80 00       	push   $0x802eab
  8004fd:	6a 67                	push   $0x67
  8004ff:	68 3c 2e 80 00       	push   $0x802e3c
  800504:	e8 67 07 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800509:	ff 45 e8             	incl   -0x18(%ebp)
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	ff 75 e8             	pushl  -0x18(%ebp)
  800512:	68 58 2f 80 00       	push   $0x802f58
  800517:	e8 7f 08 00 00       	call   800d9b <cprintf>
  80051c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80051f:	e8 ca 21 00 00       	call   8026ee <sys_calculate_free_frames>
  800524:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800527:	e8 45 22 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  80052c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  80052f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800532:	89 d0                	mov    %edx,%eax
  800534:	01 c0                	add    %eax,%eax
  800536:	01 d0                	add    %edx,%eax
  800538:	01 c0                	add    %eax,%eax
  80053a:	83 ec 0c             	sub    $0xc,%esp
  80053d:	50                   	push   %eax
  80053e:	e8 db 15 00 00       	call   801b1e <malloc>
  800543:	83 c4 10             	add    $0x10,%esp
  800546:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x99000000)
  800549:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80054c:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800551:	74 14                	je     800567 <_main+0x52f>
		panic("Worst Fit not working correctly");
  800553:	83 ec 04             	sub    $0x4,%esp
  800556:	68 38 2f 80 00       	push   $0x802f38
  80055b:	6a 6e                	push   $0x6e
  80055d:	68 3c 2e 80 00       	push   $0x802e3c
  800562:	e8 09 07 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800567:	e8 05 22 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  80056c:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80056f:	89 c1                	mov    %eax,%ecx
  800571:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800574:	89 d0                	mov    %edx,%eax
  800576:	01 c0                	add    %eax,%eax
  800578:	01 d0                	add    %edx,%eax
  80057a:	01 c0                	add    %eax,%eax
  80057c:	85 c0                	test   %eax,%eax
  80057e:	79 05                	jns    800585 <_main+0x54d>
  800580:	05 ff 0f 00 00       	add    $0xfff,%eax
  800585:	c1 f8 0c             	sar    $0xc,%eax
  800588:	39 c1                	cmp    %eax,%ecx
  80058a:	74 14                	je     8005a0 <_main+0x568>
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 8e 2e 80 00       	push   $0x802e8e
  800594:	6a 6f                	push   $0x6f
  800596:	68 3c 2e 80 00       	push   $0x802e3c
  80059b:	e8 d0 06 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005a0:	e8 49 21 00 00       	call   8026ee <sys_calculate_free_frames>
  8005a5:	89 c2                	mov    %eax,%edx
  8005a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005aa:	39 c2                	cmp    %eax,%edx
  8005ac:	74 14                	je     8005c2 <_main+0x58a>
  8005ae:	83 ec 04             	sub    $0x4,%esp
  8005b1:	68 ab 2e 80 00       	push   $0x802eab
  8005b6:	6a 70                	push   $0x70
  8005b8:	68 3c 2e 80 00       	push   $0x802e3c
  8005bd:	e8 ae 06 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005c2:	ff 45 e8             	incl   -0x18(%ebp)
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8005cb:	68 58 2f 80 00       	push   $0x802f58
  8005d0:	e8 c6 07 00 00       	call   800d9b <cprintf>
  8005d5:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 11 21 00 00       	call   8026ee <sys_calculate_free_frames>
  8005dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8005e0:	e8 8c 21 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  8005e8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005eb:	89 d0                	mov    %edx,%eax
  8005ed:	c1 e0 02             	shl    $0x2,%eax
  8005f0:	01 d0                	add    %edx,%eax
  8005f2:	83 ec 0c             	sub    $0xc,%esp
  8005f5:	50                   	push   %eax
  8005f6:	e8 23 15 00 00       	call   801b1e <malloc>
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800601:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800604:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800609:	74 14                	je     80061f <_main+0x5e7>
		panic("Worst Fit not working correctly");
  80060b:	83 ec 04             	sub    $0x4,%esp
  80060e:	68 38 2f 80 00       	push   $0x802f38
  800613:	6a 77                	push   $0x77
  800615:	68 3c 2e 80 00       	push   $0x802e3c
  80061a:	e8 51 06 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80061f:	e8 4d 21 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800624:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800627:	89 c1                	mov    %eax,%ecx
  800629:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80062c:	89 d0                	mov    %edx,%eax
  80062e:	c1 e0 02             	shl    $0x2,%eax
  800631:	01 d0                	add    %edx,%eax
  800633:	85 c0                	test   %eax,%eax
  800635:	79 05                	jns    80063c <_main+0x604>
  800637:	05 ff 0f 00 00       	add    $0xfff,%eax
  80063c:	c1 f8 0c             	sar    $0xc,%eax
  80063f:	39 c1                	cmp    %eax,%ecx
  800641:	74 14                	je     800657 <_main+0x61f>
  800643:	83 ec 04             	sub    $0x4,%esp
  800646:	68 8e 2e 80 00       	push   $0x802e8e
  80064b:	6a 78                	push   $0x78
  80064d:	68 3c 2e 80 00       	push   $0x802e3c
  800652:	e8 19 06 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800657:	e8 92 20 00 00       	call   8026ee <sys_calculate_free_frames>
  80065c:	89 c2                	mov    %eax,%edx
  80065e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800661:	39 c2                	cmp    %eax,%edx
  800663:	74 14                	je     800679 <_main+0x641>
  800665:	83 ec 04             	sub    $0x4,%esp
  800668:	68 ab 2e 80 00       	push   $0x802eab
  80066d:	6a 79                	push   $0x79
  80066f:	68 3c 2e 80 00       	push   $0x802e3c
  800674:	e8 f7 05 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800679:	ff 45 e8             	incl   -0x18(%ebp)
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	ff 75 e8             	pushl  -0x18(%ebp)
  800682:	68 58 2f 80 00       	push   $0x802f58
  800687:	e8 0f 07 00 00       	call   800d9b <cprintf>
  80068c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80068f:	e8 5a 20 00 00       	call   8026ee <sys_calculate_free_frames>
  800694:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800697:	e8 d5 20 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  80069c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80069f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006a2:	c1 e0 02             	shl    $0x2,%eax
  8006a5:	83 ec 0c             	sub    $0xc,%esp
  8006a8:	50                   	push   %eax
  8006a9:	e8 70 14 00 00       	call   801b1e <malloc>
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  8006b4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006b7:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  8006bc:	74 17                	je     8006d5 <_main+0x69d>
		panic("Worst Fit not working correctly");
  8006be:	83 ec 04             	sub    $0x4,%esp
  8006c1:	68 38 2f 80 00       	push   $0x802f38
  8006c6:	68 80 00 00 00       	push   $0x80
  8006cb:	68 3c 2e 80 00       	push   $0x802e3c
  8006d0:	e8 9b 05 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8006d5:	e8 97 20 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  8006da:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8006dd:	89 c2                	mov    %eax,%edx
  8006df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e2:	c1 e0 02             	shl    $0x2,%eax
  8006e5:	85 c0                	test   %eax,%eax
  8006e7:	79 05                	jns    8006ee <_main+0x6b6>
  8006e9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006ee:	c1 f8 0c             	sar    $0xc,%eax
  8006f1:	39 c2                	cmp    %eax,%edx
  8006f3:	74 17                	je     80070c <_main+0x6d4>
  8006f5:	83 ec 04             	sub    $0x4,%esp
  8006f8:	68 8e 2e 80 00       	push   $0x802e8e
  8006fd:	68 81 00 00 00       	push   $0x81
  800702:	68 3c 2e 80 00       	push   $0x802e3c
  800707:	e8 64 05 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80070c:	e8 dd 1f 00 00       	call   8026ee <sys_calculate_free_frames>
  800711:	89 c2                	mov    %eax,%edx
  800713:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800716:	39 c2                	cmp    %eax,%edx
  800718:	74 17                	je     800731 <_main+0x6f9>
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	68 ab 2e 80 00       	push   $0x802eab
  800722:	68 82 00 00 00       	push   $0x82
  800727:	68 3c 2e 80 00       	push   $0x802e3c
  80072c:	e8 3f 05 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800731:	ff 45 e8             	incl   -0x18(%ebp)
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	ff 75 e8             	pushl  -0x18(%ebp)
  80073a:	68 58 2f 80 00       	push   $0x802f58
  80073f:	e8 57 06 00 00       	call   800d9b <cprintf>
  800744:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800747:	e8 a2 1f 00 00       	call   8026ee <sys_calculate_free_frames>
  80074c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80074f:	e8 1d 20 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800754:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  800757:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80075a:	01 c0                	add    %eax,%eax
  80075c:	83 ec 0c             	sub    $0xc,%esp
  80075f:	50                   	push   %eax
  800760:	e8 b9 13 00 00       	call   801b1e <malloc>
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80076b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80076e:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800773:	74 17                	je     80078c <_main+0x754>
		panic("Worst Fit not working correctly");
  800775:	83 ec 04             	sub    $0x4,%esp
  800778:	68 38 2f 80 00       	push   $0x802f38
  80077d:	68 89 00 00 00       	push   $0x89
  800782:	68 3c 2e 80 00       	push   $0x802e3c
  800787:	e8 e4 04 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80078c:	e8 e0 1f 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800791:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800794:	89 c2                	mov    %eax,%edx
  800796:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	85 c0                	test   %eax,%eax
  80079d:	79 05                	jns    8007a4 <_main+0x76c>
  80079f:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007a4:	c1 f8 0c             	sar    $0xc,%eax
  8007a7:	39 c2                	cmp    %eax,%edx
  8007a9:	74 17                	je     8007c2 <_main+0x78a>
  8007ab:	83 ec 04             	sub    $0x4,%esp
  8007ae:	68 8e 2e 80 00       	push   $0x802e8e
  8007b3:	68 8a 00 00 00       	push   $0x8a
  8007b8:	68 3c 2e 80 00       	push   $0x802e3c
  8007bd:	e8 ae 04 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007c2:	e8 27 1f 00 00       	call   8026ee <sys_calculate_free_frames>
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007cc:	39 c2                	cmp    %eax,%edx
  8007ce:	74 17                	je     8007e7 <_main+0x7af>
  8007d0:	83 ec 04             	sub    $0x4,%esp
  8007d3:	68 ab 2e 80 00       	push   $0x802eab
  8007d8:	68 8b 00 00 00       	push   $0x8b
  8007dd:	68 3c 2e 80 00       	push   $0x802e3c
  8007e2:	e8 89 04 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8007e7:	ff 45 e8             	incl   -0x18(%ebp)
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8007f0:	68 58 2f 80 00       	push   $0x802f58
  8007f5:	e8 a1 05 00 00       	call   800d9b <cprintf>
  8007fa:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8007fd:	e8 ec 1e 00 00       	call   8026ee <sys_calculate_free_frames>
  800802:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800805:	e8 67 1f 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  80080a:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  80080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800810:	c1 e0 09             	shl    $0x9,%eax
  800813:	89 c2                	mov    %eax,%edx
  800815:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800818:	01 d0                	add    %edx,%eax
  80081a:	83 ec 0c             	sub    $0xc,%esp
  80081d:	50                   	push   %eax
  80081e:	e8 fb 12 00 00       	call   801b1e <malloc>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800829:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80082c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800831:	74 17                	je     80084a <_main+0x812>
		panic("Worst Fit not working correctly");
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	68 38 2f 80 00       	push   $0x802f38
  80083b:	68 92 00 00 00       	push   $0x92
  800840:	68 3c 2e 80 00       	push   $0x802e3c
  800845:	e8 26 04 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80084a:	e8 22 1f 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  80084f:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800852:	89 c2                	mov    %eax,%edx
  800854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800857:	c1 e0 09             	shl    $0x9,%eax
  80085a:	89 c1                	mov    %eax,%ecx
  80085c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085f:	01 c8                	add    %ecx,%eax
  800861:	85 c0                	test   %eax,%eax
  800863:	79 05                	jns    80086a <_main+0x832>
  800865:	05 ff 0f 00 00       	add    $0xfff,%eax
  80086a:	c1 f8 0c             	sar    $0xc,%eax
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	74 17                	je     800888 <_main+0x850>
  800871:	83 ec 04             	sub    $0x4,%esp
  800874:	68 8e 2e 80 00       	push   $0x802e8e
  800879:	68 93 00 00 00       	push   $0x93
  80087e:	68 3c 2e 80 00       	push   $0x802e3c
  800883:	e8 e8 03 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800888:	e8 61 1e 00 00       	call   8026ee <sys_calculate_free_frames>
  80088d:	89 c2                	mov    %eax,%edx
  80088f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800892:	39 c2                	cmp    %eax,%edx
  800894:	74 17                	je     8008ad <_main+0x875>
  800896:	83 ec 04             	sub    $0x4,%esp
  800899:	68 ab 2e 80 00       	push   $0x802eab
  80089e:	68 94 00 00 00       	push   $0x94
  8008a3:	68 3c 2e 80 00       	push   $0x802e3c
  8008a8:	e8 c3 03 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ad:	ff 45 e8             	incl   -0x18(%ebp)
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8008b6:	68 58 2f 80 00       	push   $0x802f58
  8008bb:	e8 db 04 00 00       	call   800d9b <cprintf>
  8008c0:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8008c3:	e8 26 1e 00 00       	call   8026ee <sys_calculate_free_frames>
  8008c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008cb:	e8 a1 1e 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  8008d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  8008d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008d6:	c1 e0 09             	shl    $0x9,%eax
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	50                   	push   %eax
  8008dd:	e8 3c 12 00 00       	call   801b1e <malloc>
  8008e2:	83 c4 10             	add    $0x10,%esp
  8008e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x80600000)
  8008e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8008eb:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  8008f0:	74 17                	je     800909 <_main+0x8d1>
		panic("Worst Fit not working correctly");
  8008f2:	83 ec 04             	sub    $0x4,%esp
  8008f5:	68 38 2f 80 00       	push   $0x802f38
  8008fa:	68 9b 00 00 00       	push   $0x9b
  8008ff:	68 3c 2e 80 00       	push   $0x802e3c
  800904:	e8 67 03 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800909:	e8 63 1e 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  80090e:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800911:	89 c2                	mov    %eax,%edx
  800913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800916:	c1 e0 09             	shl    $0x9,%eax
  800919:	85 c0                	test   %eax,%eax
  80091b:	79 05                	jns    800922 <_main+0x8ea>
  80091d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800922:	c1 f8 0c             	sar    $0xc,%eax
  800925:	39 c2                	cmp    %eax,%edx
  800927:	74 17                	je     800940 <_main+0x908>
  800929:	83 ec 04             	sub    $0x4,%esp
  80092c:	68 8e 2e 80 00       	push   $0x802e8e
  800931:	68 9c 00 00 00       	push   $0x9c
  800936:	68 3c 2e 80 00       	push   $0x802e3c
  80093b:	e8 30 03 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800940:	e8 a9 1d 00 00       	call   8026ee <sys_calculate_free_frames>
  800945:	89 c2                	mov    %eax,%edx
  800947:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80094a:	39 c2                	cmp    %eax,%edx
  80094c:	74 17                	je     800965 <_main+0x92d>
  80094e:	83 ec 04             	sub    $0x4,%esp
  800951:	68 ab 2e 80 00       	push   $0x802eab
  800956:	68 9d 00 00 00       	push   $0x9d
  80095b:	68 3c 2e 80 00       	push   $0x802e3c
  800960:	e8 0b 03 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800965:	ff 45 e8             	incl   -0x18(%ebp)
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	ff 75 e8             	pushl  -0x18(%ebp)
  80096e:	68 58 2f 80 00       	push   $0x802f58
  800973:	e8 23 04 00 00       	call   800d9b <cprintf>
  800978:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80097b:	e8 6e 1d 00 00       	call   8026ee <sys_calculate_free_frames>
  800980:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800983:	e8 e9 1d 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800988:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  80098b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80098e:	83 ec 0c             	sub    $0xc,%esp
  800991:	50                   	push   %eax
  800992:	e8 87 11 00 00       	call   801b1e <malloc>
  800997:	83 c4 10             	add    $0x10,%esp
  80099a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x99600000)
  80099d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8009a0:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  8009a5:	74 17                	je     8009be <_main+0x986>
		panic("Worst Fit not working correctly");
  8009a7:	83 ec 04             	sub    $0x4,%esp
  8009aa:	68 38 2f 80 00       	push   $0x802f38
  8009af:	68 a4 00 00 00       	push   $0xa4
  8009b4:	68 3c 2e 80 00       	push   $0x802e3c
  8009b9:	e8 b2 02 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8009be:	e8 ae 1d 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  8009c3:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8009c6:	89 c2                	mov    %eax,%edx
  8009c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009cb:	c1 e0 02             	shl    $0x2,%eax
  8009ce:	85 c0                	test   %eax,%eax
  8009d0:	79 05                	jns    8009d7 <_main+0x99f>
  8009d2:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009d7:	c1 f8 0c             	sar    $0xc,%eax
  8009da:	39 c2                	cmp    %eax,%edx
  8009dc:	74 17                	je     8009f5 <_main+0x9bd>
  8009de:	83 ec 04             	sub    $0x4,%esp
  8009e1:	68 8e 2e 80 00       	push   $0x802e8e
  8009e6:	68 a5 00 00 00       	push   $0xa5
  8009eb:	68 3c 2e 80 00       	push   $0x802e3c
  8009f0:	e8 7b 02 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009f5:	e8 f4 1c 00 00       	call   8026ee <sys_calculate_free_frames>
  8009fa:	89 c2                	mov    %eax,%edx
  8009fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009ff:	39 c2                	cmp    %eax,%edx
  800a01:	74 17                	je     800a1a <_main+0x9e2>
  800a03:	83 ec 04             	sub    $0x4,%esp
  800a06:	68 ab 2e 80 00       	push   $0x802eab
  800a0b:	68 a6 00 00 00       	push   $0xa6
  800a10:	68 3c 2e 80 00       	push   $0x802e3c
  800a15:	e8 56 02 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a1a:	ff 45 e8             	incl   -0x18(%ebp)
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 e8             	pushl  -0x18(%ebp)
  800a23:	68 58 2f 80 00       	push   $0x802f58
  800a28:	e8 6e 03 00 00       	call   800d9b <cprintf>
  800a2d:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a30:	e8 b9 1c 00 00       	call   8026ee <sys_calculate_free_frames>
  800a35:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a38:	e8 34 1d 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800a3d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800a40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a43:	01 c0                	add    %eax,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a4a:	29 d0                	sub    %edx,%eax
  800a4c:	01 c0                	add    %eax,%eax
  800a4e:	83 ec 0c             	sub    $0xc,%esp
  800a51:	50                   	push   %eax
  800a52:	e8 c7 10 00 00       	call   801b1e <malloc>
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800a5d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a60:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800a65:	74 17                	je     800a7e <_main+0xa46>
		panic("Worst Fit not working correctly");
  800a67:	83 ec 04             	sub    $0x4,%esp
  800a6a:	68 38 2f 80 00       	push   $0x802f38
  800a6f:	68 ad 00 00 00       	push   $0xad
  800a74:	68 3c 2e 80 00       	push   $0x802e3c
  800a79:	e8 f2 01 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a7e:	e8 ee 1c 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800a83:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800a86:	89 c2                	mov    %eax,%edx
  800a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a8b:	01 c0                	add    %eax,%eax
  800a8d:	89 c1                	mov    %eax,%ecx
  800a8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a92:	29 c8                	sub    %ecx,%eax
  800a94:	01 c0                	add    %eax,%eax
  800a96:	85 c0                	test   %eax,%eax
  800a98:	79 05                	jns    800a9f <_main+0xa67>
  800a9a:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a9f:	c1 f8 0c             	sar    $0xc,%eax
  800aa2:	39 c2                	cmp    %eax,%edx
  800aa4:	74 17                	je     800abd <_main+0xa85>
  800aa6:	83 ec 04             	sub    $0x4,%esp
  800aa9:	68 8e 2e 80 00       	push   $0x802e8e
  800aae:	68 ae 00 00 00       	push   $0xae
  800ab3:	68 3c 2e 80 00       	push   $0x802e3c
  800ab8:	e8 b3 01 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800abd:	e8 2c 1c 00 00       	call   8026ee <sys_calculate_free_frames>
  800ac2:	89 c2                	mov    %eax,%edx
  800ac4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800ac7:	39 c2                	cmp    %eax,%edx
  800ac9:	74 17                	je     800ae2 <_main+0xaaa>
  800acb:	83 ec 04             	sub    $0x4,%esp
  800ace:	68 ab 2e 80 00       	push   $0x802eab
  800ad3:	68 af 00 00 00       	push   $0xaf
  800ad8:	68 3c 2e 80 00       	push   $0x802e3c
  800add:	e8 8e 01 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800ae2:	ff 45 e8             	incl   -0x18(%ebp)
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 e8             	pushl  -0x18(%ebp)
  800aeb:	68 58 2f 80 00       	push   $0x802f58
  800af0:	e8 a6 02 00 00       	call   800d9b <cprintf>
  800af5:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800af8:	e8 f1 1b 00 00       	call   8026ee <sys_calculate_free_frames>
  800afd:	89 45 cc             	mov    %eax,-0x34(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b00:	e8 6c 1c 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800b05:	89 45 c8             	mov    %eax,-0x38(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800b08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b0b:	c1 e0 02             	shl    $0x2,%eax
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	50                   	push   %eax
  800b12:	e8 07 10 00 00       	call   801b1e <malloc>
  800b17:	83 c4 10             	add    $0x10,%esp
  800b1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	if((uint32)tempAddress != 0x0)
  800b1d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b20:	85 c0                	test   %eax,%eax
  800b22:	74 17                	je     800b3b <_main+0xb03>
		panic("Worst Fit not working correctly");
  800b24:	83 ec 04             	sub    $0x4,%esp
  800b27:	68 38 2f 80 00       	push   $0x802f38
  800b2c:	68 b7 00 00 00       	push   $0xb7
  800b31:	68 3c 2e 80 00       	push   $0x802e3c
  800b36:	e8 35 01 00 00       	call   800c70 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b3b:	e8 31 1c 00 00       	call   802771 <sys_pf_calculate_allocated_pages>
  800b40:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800b43:	74 17                	je     800b5c <_main+0xb24>
  800b45:	83 ec 04             	sub    $0x4,%esp
  800b48:	68 8e 2e 80 00       	push   $0x802e8e
  800b4d:	68 b8 00 00 00       	push   $0xb8
  800b52:	68 3c 2e 80 00       	push   $0x802e3c
  800b57:	e8 14 01 00 00       	call   800c70 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b5c:	e8 8d 1b 00 00       	call   8026ee <sys_calculate_free_frames>
  800b61:	89 c2                	mov    %eax,%edx
  800b63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b66:	39 c2                	cmp    %eax,%edx
  800b68:	74 17                	je     800b81 <_main+0xb49>
  800b6a:	83 ec 04             	sub    $0x4,%esp
  800b6d:	68 ab 2e 80 00       	push   $0x802eab
  800b72:	68 b9 00 00 00       	push   $0xb9
  800b77:	68 3c 2e 80 00       	push   $0x802e3c
  800b7c:	e8 ef 00 00 00       	call   800c70 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b81:	ff 45 e8             	incl   -0x18(%ebp)
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 e8             	pushl  -0x18(%ebp)
  800b8a:	68 58 2f 80 00       	push   $0x802f58
  800b8f:	e8 07 02 00 00       	call   800d9b <cprintf>
  800b94:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800b97:	83 ec 0c             	sub    $0xc,%esp
  800b9a:	68 6c 2f 80 00       	push   $0x802f6c
  800b9f:	e8 f7 01 00 00       	call   800d9b <cprintf>
  800ba4:	83 c4 10             	add    $0x10,%esp

	return;
  800ba7:	90                   	nop
}
  800ba8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bab:	5b                   	pop    %ebx
  800bac:	5f                   	pop    %edi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb9:	7e 0a                	jle    800bc5 <libmain+0x16>
		binaryname = argv[0];
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8b 00                	mov    (%eax),%eax
  800bc0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	ff 75 0c             	pushl  0xc(%ebp)
  800bcb:	ff 75 08             	pushl  0x8(%ebp)
  800bce:	e8 65 f4 ff ff       	call   800038 <_main>
  800bd3:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800bd6:	e8 61 1a 00 00       	call   80263c <sys_getenvid>
  800bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be1:	89 d0                	mov    %edx,%eax
  800be3:	c1 e0 03             	shl    $0x3,%eax
  800be6:	01 d0                	add    %edx,%eax
  800be8:	01 c0                	add    %eax,%eax
  800bea:	01 d0                	add    %edx,%eax
  800bec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bf3:	01 d0                	add    %edx,%eax
  800bf5:	c1 e0 03             	shl    $0x3,%eax
  800bf8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800c00:	e8 85 1b 00 00       	call   80278a <sys_disable_interrupt>
		cprintf("**************************************\n");
  800c05:	83 ec 0c             	sub    $0xc,%esp
  800c08:	68 c0 2f 80 00       	push   $0x802fc0
  800c0d:	e8 89 01 00 00       	call   800d9b <cprintf>
  800c12:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c18:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	50                   	push   %eax
  800c22:	68 e8 2f 80 00       	push   $0x802fe8
  800c27:	e8 6f 01 00 00       	call   800d9b <cprintf>
  800c2c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	68 c0 2f 80 00       	push   $0x802fc0
  800c37:	e8 5f 01 00 00       	call   800d9b <cprintf>
  800c3c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c3f:	e8 60 1b 00 00       	call   8027a4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c44:	e8 19 00 00 00       	call   800c62 <exit>
}
  800c49:	90                   	nop
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800c52:	83 ec 0c             	sub    $0xc,%esp
  800c55:	6a 00                	push   $0x0
  800c57:	e8 c5 19 00 00       	call   802621 <sys_env_destroy>
  800c5c:	83 c4 10             	add    $0x10,%esp
}
  800c5f:	90                   	nop
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <exit>:

void
exit(void)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800c68:	e8 e8 19 00 00       	call   802655 <sys_env_exit>
}
  800c6d:	90                   	nop
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c76:	8d 45 10             	lea    0x10(%ebp),%eax
  800c79:	83 c0 04             	add    $0x4,%eax
  800c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800c7f:	a1 50 40 98 00       	mov    0x984050,%eax
  800c84:	85 c0                	test   %eax,%eax
  800c86:	74 16                	je     800c9e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c88:	a1 50 40 98 00       	mov    0x984050,%eax
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	50                   	push   %eax
  800c91:	68 01 30 80 00       	push   $0x803001
  800c96:	e8 00 01 00 00       	call   800d9b <cprintf>
  800c9b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c9e:	a1 00 40 80 00       	mov    0x804000,%eax
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	ff 75 08             	pushl  0x8(%ebp)
  800ca9:	50                   	push   %eax
  800caa:	68 06 30 80 00       	push   $0x803006
  800caf:	e8 e7 00 00 00       	call   800d9b <cprintf>
  800cb4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	e8 7a 00 00 00       	call   800d40 <vcprintf>
  800cc6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	68 22 30 80 00       	push   $0x803022
  800cd1:	e8 c5 00 00 00       	call   800d9b <cprintf>
  800cd6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cd9:	e8 84 ff ff ff       	call   800c62 <exit>

	// should not return here
	while (1) ;
  800cde:	eb fe                	jmp    800cde <_panic+0x6e>

00800ce0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	8d 48 01             	lea    0x1(%eax),%ecx
  800cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf1:	89 0a                	mov    %ecx,(%edx)
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	88 d1                	mov    %dl,%cl
  800cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d09:	75 23                	jne    800d2e <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	89 c2                	mov    %eax,%edx
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	83 c0 08             	add    $0x8,%eax
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	52                   	push   %edx
  800d1c:	50                   	push   %eax
  800d1d:	e8 c9 18 00 00       	call   8025eb <sys_cputs>
  800d22:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 40 04             	mov    0x4(%eax),%eax
  800d34:	8d 50 01             	lea    0x1(%eax),%edx
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800d3d:	90                   	nop
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d49:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d50:	00 00 00 
	b.cnt = 0;
  800d53:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d5a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	ff 75 08             	pushl  0x8(%ebp)
  800d63:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d69:	50                   	push   %eax
  800d6a:	68 e0 0c 80 00       	push   $0x800ce0
  800d6f:	e8 fa 01 00 00       	call   800f6e <vprintfmt>
  800d74:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800d77:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800d7d:	83 ec 08             	sub    $0x8,%esp
  800d80:	50                   	push   %eax
  800d81:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d87:	83 c0 08             	add    $0x8,%eax
  800d8a:	50                   	push   %eax
  800d8b:	e8 5b 18 00 00       	call   8025eb <sys_cputs>
  800d90:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800d93:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <cprintf>:

int cprintf(const char *fmt, ...) {
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800da1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	50                   	push   %eax
  800db1:	e8 8a ff ff ff       	call   800d40 <vcprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800dc7:	e8 be 19 00 00       	call   80278a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800dcc:	8d 45 0c             	lea    0xc(%ebp),%eax
  800dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ddb:	50                   	push   %eax
  800ddc:	e8 5f ff ff ff       	call   800d40 <vcprintf>
  800de1:	83 c4 10             	add    $0x10,%esp
  800de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800de7:	e8 b8 19 00 00       	call   8027a4 <sys_enable_interrupt>
	return cnt;
  800dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	53                   	push   %ebx
  800df5:	83 ec 14             	sub    $0x14,%esp
  800df8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e04:	8b 45 18             	mov    0x18(%ebp),%eax
  800e07:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e0f:	77 55                	ja     800e66 <printnum+0x75>
  800e11:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e14:	72 05                	jb     800e1b <printnum+0x2a>
  800e16:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e19:	77 4b                	ja     800e66 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e1b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e1e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e21:	8b 45 18             	mov    0x18(%ebp),%eax
  800e24:	ba 00 00 00 00       	mov    $0x0,%edx
  800e29:	52                   	push   %edx
  800e2a:	50                   	push   %eax
  800e2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2e:	ff 75 f0             	pushl  -0x10(%ebp)
  800e31:	e8 f2 1c 00 00       	call   802b28 <__udivdi3>
  800e36:	83 c4 10             	add    $0x10,%esp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	ff 75 20             	pushl  0x20(%ebp)
  800e3f:	53                   	push   %ebx
  800e40:	ff 75 18             	pushl  0x18(%ebp)
  800e43:	52                   	push   %edx
  800e44:	50                   	push   %eax
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	ff 75 08             	pushl  0x8(%ebp)
  800e4b:	e8 a1 ff ff ff       	call   800df1 <printnum>
  800e50:	83 c4 20             	add    $0x20,%esp
  800e53:	eb 1a                	jmp    800e6f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e55:	83 ec 08             	sub    $0x8,%esp
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	ff 75 20             	pushl  0x20(%ebp)
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	ff d0                	call   *%eax
  800e63:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e66:	ff 4d 1c             	decl   0x1c(%ebp)
  800e69:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e6d:	7f e6                	jg     800e55 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e6f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7d:	53                   	push   %ebx
  800e7e:	51                   	push   %ecx
  800e7f:	52                   	push   %edx
  800e80:	50                   	push   %eax
  800e81:	e8 b2 1d 00 00       	call   802c38 <__umoddi3>
  800e86:	83 c4 10             	add    $0x10,%esp
  800e89:	05 54 32 80 00       	add    $0x803254,%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	0f be c0             	movsbl %al,%eax
  800e93:	83 ec 08             	sub    $0x8,%esp
  800e96:	ff 75 0c             	pushl  0xc(%ebp)
  800e99:	50                   	push   %eax
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	ff d0                	call   *%eax
  800e9f:	83 c4 10             	add    $0x10,%esp
}
  800ea2:	90                   	nop
  800ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

00800ea8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800eab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eaf:	7e 1c                	jle    800ecd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8b 00                	mov    (%eax),%eax
  800eb6:	8d 50 08             	lea    0x8(%eax),%edx
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	89 10                	mov    %edx,(%eax)
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	8b 00                	mov    (%eax),%eax
  800ec3:	83 e8 08             	sub    $0x8,%eax
  800ec6:	8b 50 04             	mov    0x4(%eax),%edx
  800ec9:	8b 00                	mov    (%eax),%eax
  800ecb:	eb 40                	jmp    800f0d <getuint+0x65>
	else if (lflag)
  800ecd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed1:	74 1e                	je     800ef1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	8d 50 04             	lea    0x4(%eax),%edx
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	89 10                	mov    %edx,(%eax)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8b 00                	mov    (%eax),%eax
  800ee5:	83 e8 04             	sub    $0x4,%eax
  800ee8:	8b 00                	mov    (%eax),%eax
  800eea:	ba 00 00 00 00       	mov    $0x0,%edx
  800eef:	eb 1c                	jmp    800f0d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	8d 50 04             	lea    0x4(%eax),%edx
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 10                	mov    %edx,(%eax)
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8b 00                	mov    (%eax),%eax
  800f03:	83 e8 04             	sub    $0x4,%eax
  800f06:	8b 00                	mov    (%eax),%eax
  800f08:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f12:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f16:	7e 1c                	jle    800f34 <getint+0x25>
		return va_arg(*ap, long long);
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8b 00                	mov    (%eax),%eax
  800f1d:	8d 50 08             	lea    0x8(%eax),%edx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	89 10                	mov    %edx,(%eax)
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8b 00                	mov    (%eax),%eax
  800f2a:	83 e8 08             	sub    $0x8,%eax
  800f2d:	8b 50 04             	mov    0x4(%eax),%edx
  800f30:	8b 00                	mov    (%eax),%eax
  800f32:	eb 38                	jmp    800f6c <getint+0x5d>
	else if (lflag)
  800f34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f38:	74 1a                	je     800f54 <getint+0x45>
		return va_arg(*ap, long);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8b 00                	mov    (%eax),%eax
  800f3f:	8d 50 04             	lea    0x4(%eax),%edx
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	89 10                	mov    %edx,(%eax)
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8b 00                	mov    (%eax),%eax
  800f4c:	83 e8 04             	sub    $0x4,%eax
  800f4f:	8b 00                	mov    (%eax),%eax
  800f51:	99                   	cltd   
  800f52:	eb 18                	jmp    800f6c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8b 00                	mov    (%eax),%eax
  800f59:	8d 50 04             	lea    0x4(%eax),%edx
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	89 10                	mov    %edx,(%eax)
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8b 00                	mov    (%eax),%eax
  800f66:	83 e8 04             	sub    $0x4,%eax
  800f69:	8b 00                	mov    (%eax),%eax
  800f6b:	99                   	cltd   
}
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    

00800f6e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	56                   	push   %esi
  800f72:	53                   	push   %ebx
  800f73:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f76:	eb 17                	jmp    800f8f <vprintfmt+0x21>
			if (ch == '\0')
  800f78:	85 db                	test   %ebx,%ebx
  800f7a:	0f 84 af 03 00 00    	je     80132f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f80:	83 ec 08             	sub    $0x8,%esp
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	53                   	push   %ebx
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	ff d0                	call   *%eax
  800f8c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	8d 50 01             	lea    0x1(%eax),%edx
  800f95:	89 55 10             	mov    %edx,0x10(%ebp)
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	0f b6 d8             	movzbl %al,%ebx
  800f9d:	83 fb 25             	cmp    $0x25,%ebx
  800fa0:	75 d6                	jne    800f78 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800fa2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800fa6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800fad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800fb4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800fbb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	8d 50 01             	lea    0x1(%eax),%edx
  800fc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	0f b6 d8             	movzbl %al,%ebx
  800fd0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fd3:	83 f8 55             	cmp    $0x55,%eax
  800fd6:	0f 87 2b 03 00 00    	ja     801307 <vprintfmt+0x399>
  800fdc:	8b 04 85 78 32 80 00 	mov    0x803278(,%eax,4),%eax
  800fe3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fe5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fe9:	eb d7                	jmp    800fc2 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800feb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fef:	eb d1                	jmp    800fc2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ff8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ffb:	89 d0                	mov    %edx,%eax
  800ffd:	c1 e0 02             	shl    $0x2,%eax
  801000:	01 d0                	add    %edx,%eax
  801002:	01 c0                	add    %eax,%eax
  801004:	01 d8                	add    %ebx,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801014:	83 fb 2f             	cmp    $0x2f,%ebx
  801017:	7e 3e                	jle    801057 <vprintfmt+0xe9>
  801019:	83 fb 39             	cmp    $0x39,%ebx
  80101c:	7f 39                	jg     801057 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80101e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801021:	eb d5                	jmp    800ff8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801023:	8b 45 14             	mov    0x14(%ebp),%eax
  801026:	83 c0 04             	add    $0x4,%eax
  801029:	89 45 14             	mov    %eax,0x14(%ebp)
  80102c:	8b 45 14             	mov    0x14(%ebp),%eax
  80102f:	83 e8 04             	sub    $0x4,%eax
  801032:	8b 00                	mov    (%eax),%eax
  801034:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801037:	eb 1f                	jmp    801058 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801039:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80103d:	79 83                	jns    800fc2 <vprintfmt+0x54>
				width = 0;
  80103f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801046:	e9 77 ff ff ff       	jmp    800fc2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80104b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801052:	e9 6b ff ff ff       	jmp    800fc2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801057:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801058:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105c:	0f 89 60 ff ff ff    	jns    800fc2 <vprintfmt+0x54>
				width = precision, precision = -1;
  801062:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801065:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801068:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80106f:	e9 4e ff ff ff       	jmp    800fc2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801074:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801077:	e9 46 ff ff ff       	jmp    800fc2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80107c:	8b 45 14             	mov    0x14(%ebp),%eax
  80107f:	83 c0 04             	add    $0x4,%eax
  801082:	89 45 14             	mov    %eax,0x14(%ebp)
  801085:	8b 45 14             	mov    0x14(%ebp),%eax
  801088:	83 e8 04             	sub    $0x4,%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	83 ec 08             	sub    $0x8,%esp
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	50                   	push   %eax
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	ff d0                	call   *%eax
  801099:	83 c4 10             	add    $0x10,%esp
			break;
  80109c:	e9 89 02 00 00       	jmp    80132a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	83 e8 04             	sub    $0x4,%eax
  8010b0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8010b2:	85 db                	test   %ebx,%ebx
  8010b4:	79 02                	jns    8010b8 <vprintfmt+0x14a>
				err = -err;
  8010b6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8010b8:	83 fb 64             	cmp    $0x64,%ebx
  8010bb:	7f 0b                	jg     8010c8 <vprintfmt+0x15a>
  8010bd:	8b 34 9d c0 30 80 00 	mov    0x8030c0(,%ebx,4),%esi
  8010c4:	85 f6                	test   %esi,%esi
  8010c6:	75 19                	jne    8010e1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8010c8:	53                   	push   %ebx
  8010c9:	68 65 32 80 00       	push   $0x803265
  8010ce:	ff 75 0c             	pushl  0xc(%ebp)
  8010d1:	ff 75 08             	pushl  0x8(%ebp)
  8010d4:	e8 5e 02 00 00       	call   801337 <printfmt>
  8010d9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010dc:	e9 49 02 00 00       	jmp    80132a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010e1:	56                   	push   %esi
  8010e2:	68 6e 32 80 00       	push   $0x80326e
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	ff 75 08             	pushl  0x8(%ebp)
  8010ed:	e8 45 02 00 00       	call   801337 <printfmt>
  8010f2:	83 c4 10             	add    $0x10,%esp
			break;
  8010f5:	e9 30 02 00 00       	jmp    80132a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fd:	83 c0 04             	add    $0x4,%eax
  801100:	89 45 14             	mov    %eax,0x14(%ebp)
  801103:	8b 45 14             	mov    0x14(%ebp),%eax
  801106:	83 e8 04             	sub    $0x4,%eax
  801109:	8b 30                	mov    (%eax),%esi
  80110b:	85 f6                	test   %esi,%esi
  80110d:	75 05                	jne    801114 <vprintfmt+0x1a6>
				p = "(null)";
  80110f:	be 71 32 80 00       	mov    $0x803271,%esi
			if (width > 0 && padc != '-')
  801114:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801118:	7e 6d                	jle    801187 <vprintfmt+0x219>
  80111a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80111e:	74 67                	je     801187 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801120:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801123:	83 ec 08             	sub    $0x8,%esp
  801126:	50                   	push   %eax
  801127:	56                   	push   %esi
  801128:	e8 0c 03 00 00       	call   801439 <strnlen>
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801133:	eb 16                	jmp    80114b <vprintfmt+0x1dd>
					putch(padc, putdat);
  801135:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	ff 75 0c             	pushl  0xc(%ebp)
  80113f:	50                   	push   %eax
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	ff d0                	call   *%eax
  801145:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801148:	ff 4d e4             	decl   -0x1c(%ebp)
  80114b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80114f:	7f e4                	jg     801135 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801151:	eb 34                	jmp    801187 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801153:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801157:	74 1c                	je     801175 <vprintfmt+0x207>
  801159:	83 fb 1f             	cmp    $0x1f,%ebx
  80115c:	7e 05                	jle    801163 <vprintfmt+0x1f5>
  80115e:	83 fb 7e             	cmp    $0x7e,%ebx
  801161:	7e 12                	jle    801175 <vprintfmt+0x207>
					putch('?', putdat);
  801163:	83 ec 08             	sub    $0x8,%esp
  801166:	ff 75 0c             	pushl  0xc(%ebp)
  801169:	6a 3f                	push   $0x3f
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	ff d0                	call   *%eax
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	eb 0f                	jmp    801184 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801175:	83 ec 08             	sub    $0x8,%esp
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	53                   	push   %ebx
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	ff d0                	call   *%eax
  801181:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801184:	ff 4d e4             	decl   -0x1c(%ebp)
  801187:	89 f0                	mov    %esi,%eax
  801189:	8d 70 01             	lea    0x1(%eax),%esi
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f be d8             	movsbl %al,%ebx
  801191:	85 db                	test   %ebx,%ebx
  801193:	74 24                	je     8011b9 <vprintfmt+0x24b>
  801195:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801199:	78 b8                	js     801153 <vprintfmt+0x1e5>
  80119b:	ff 4d e0             	decl   -0x20(%ebp)
  80119e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011a2:	79 af                	jns    801153 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011a4:	eb 13                	jmp    8011b9 <vprintfmt+0x24b>
				putch(' ', putdat);
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	6a 20                	push   $0x20
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	ff d0                	call   *%eax
  8011b3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011b6:	ff 4d e4             	decl   -0x1c(%ebp)
  8011b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011bd:	7f e7                	jg     8011a6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8011bf:	e9 66 01 00 00       	jmp    80132a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8011c4:	83 ec 08             	sub    $0x8,%esp
  8011c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8011cd:	50                   	push   %eax
  8011ce:	e8 3c fd ff ff       	call   800f0f <getint>
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e2:	85 d2                	test   %edx,%edx
  8011e4:	79 23                	jns    801209 <vprintfmt+0x29b>
				putch('-', putdat);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ec:	6a 2d                	push   $0x2d
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	ff d0                	call   *%eax
  8011f3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fc:	f7 d8                	neg    %eax
  8011fe:	83 d2 00             	adc    $0x0,%edx
  801201:	f7 da                	neg    %edx
  801203:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801206:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801209:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801210:	e9 bc 00 00 00       	jmp    8012d1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801215:	83 ec 08             	sub    $0x8,%esp
  801218:	ff 75 e8             	pushl  -0x18(%ebp)
  80121b:	8d 45 14             	lea    0x14(%ebp),%eax
  80121e:	50                   	push   %eax
  80121f:	e8 84 fc ff ff       	call   800ea8 <getuint>
  801224:	83 c4 10             	add    $0x10,%esp
  801227:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80122a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80122d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801234:	e9 98 00 00 00       	jmp    8012d1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801239:	83 ec 08             	sub    $0x8,%esp
  80123c:	ff 75 0c             	pushl  0xc(%ebp)
  80123f:	6a 58                	push   $0x58
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	ff d0                	call   *%eax
  801246:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	ff 75 0c             	pushl  0xc(%ebp)
  80124f:	6a 58                	push   $0x58
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	ff d0                	call   *%eax
  801256:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801259:	83 ec 08             	sub    $0x8,%esp
  80125c:	ff 75 0c             	pushl  0xc(%ebp)
  80125f:	6a 58                	push   $0x58
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	ff d0                	call   *%eax
  801266:	83 c4 10             	add    $0x10,%esp
			break;
  801269:	e9 bc 00 00 00       	jmp    80132a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	6a 30                	push   $0x30
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	ff d0                	call   *%eax
  80127b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80127e:	83 ec 08             	sub    $0x8,%esp
  801281:	ff 75 0c             	pushl  0xc(%ebp)
  801284:	6a 78                	push   $0x78
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
  801289:	ff d0                	call   *%eax
  80128b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80128e:	8b 45 14             	mov    0x14(%ebp),%eax
  801291:	83 c0 04             	add    $0x4,%eax
  801294:	89 45 14             	mov    %eax,0x14(%ebp)
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	83 e8 04             	sub    $0x4,%eax
  80129d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80129f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8012a9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8012b0:	eb 1f                	jmp    8012d1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8012b2:	83 ec 08             	sub    $0x8,%esp
  8012b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8012b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8012bb:	50                   	push   %eax
  8012bc:	e8 e7 fb ff ff       	call   800ea8 <getuint>
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8012ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012d1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012d8:	83 ec 04             	sub    $0x4,%esp
  8012db:	52                   	push   %edx
  8012dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012df:	50                   	push   %eax
  8012e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	ff 75 08             	pushl  0x8(%ebp)
  8012ec:	e8 00 fb ff ff       	call   800df1 <printnum>
  8012f1:	83 c4 20             	add    $0x20,%esp
			break;
  8012f4:	eb 34                	jmp    80132a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	ff 75 0c             	pushl  0xc(%ebp)
  8012fc:	53                   	push   %ebx
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	ff d0                	call   *%eax
  801302:	83 c4 10             	add    $0x10,%esp
			break;
  801305:	eb 23                	jmp    80132a <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801307:	83 ec 08             	sub    $0x8,%esp
  80130a:	ff 75 0c             	pushl  0xc(%ebp)
  80130d:	6a 25                	push   $0x25
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	ff d0                	call   *%eax
  801314:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801317:	ff 4d 10             	decl   0x10(%ebp)
  80131a:	eb 03                	jmp    80131f <vprintfmt+0x3b1>
  80131c:	ff 4d 10             	decl   0x10(%ebp)
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	48                   	dec    %eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	3c 25                	cmp    $0x25,%al
  801327:	75 f3                	jne    80131c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801329:	90                   	nop
		}
	}
  80132a:	e9 47 fc ff ff       	jmp    800f76 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80132f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801330:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801333:	5b                   	pop    %ebx
  801334:	5e                   	pop    %esi
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80133d:	8d 45 10             	lea    0x10(%ebp),%eax
  801340:	83 c0 04             	add    $0x4,%eax
  801343:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801346:	8b 45 10             	mov    0x10(%ebp),%eax
  801349:	ff 75 f4             	pushl  -0xc(%ebp)
  80134c:	50                   	push   %eax
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	ff 75 08             	pushl  0x8(%ebp)
  801353:	e8 16 fc ff ff       	call   800f6e <vprintfmt>
  801358:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80135b:	90                   	nop
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	8b 40 08             	mov    0x8(%eax),%eax
  801367:	8d 50 01             	lea    0x1(%eax),%edx
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	8b 10                	mov    (%eax),%edx
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8b 40 04             	mov    0x4(%eax),%eax
  80137b:	39 c2                	cmp    %eax,%edx
  80137d:	73 12                	jae    801391 <sprintputch+0x33>
		*b->buf++ = ch;
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	8b 00                	mov    (%eax),%eax
  801384:	8d 48 01             	lea    0x1(%eax),%ecx
  801387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138a:	89 0a                	mov    %ecx,(%edx)
  80138c:	8b 55 08             	mov    0x8(%ebp),%edx
  80138f:	88 10                	mov    %dl,(%eax)
}
  801391:	90                   	nop
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    

00801394 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	01 d0                	add    %edx,%eax
  8013ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8013b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b9:	74 06                	je     8013c1 <vsnprintf+0x2d>
  8013bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013bf:	7f 07                	jg     8013c8 <vsnprintf+0x34>
		return -E_INVAL;
  8013c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8013c6:	eb 20                	jmp    8013e8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8013c8:	ff 75 14             	pushl  0x14(%ebp)
  8013cb:	ff 75 10             	pushl  0x10(%ebp)
  8013ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013d1:	50                   	push   %eax
  8013d2:	68 5e 13 80 00       	push   $0x80135e
  8013d7:	e8 92 fb ff ff       	call   800f6e <vprintfmt>
  8013dc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013f0:	8d 45 10             	lea    0x10(%ebp),%eax
  8013f3:	83 c0 04             	add    $0x4,%eax
  8013f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ff:	50                   	push   %eax
  801400:	ff 75 0c             	pushl  0xc(%ebp)
  801403:	ff 75 08             	pushl  0x8(%ebp)
  801406:	e8 89 ff ff ff       	call   801394 <vsnprintf>
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801411:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80141c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801423:	eb 06                	jmp    80142b <strlen+0x15>
		n++;
  801425:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801428:	ff 45 08             	incl   0x8(%ebp)
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	84 c0                	test   %al,%al
  801432:	75 f1                	jne    801425 <strlen+0xf>
		n++;
	return n;
  801434:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80143f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801446:	eb 09                	jmp    801451 <strnlen+0x18>
		n++;
  801448:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80144b:	ff 45 08             	incl   0x8(%ebp)
  80144e:	ff 4d 0c             	decl   0xc(%ebp)
  801451:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801455:	74 09                	je     801460 <strnlen+0x27>
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	84 c0                	test   %al,%al
  80145e:	75 e8                	jne    801448 <strnlen+0xf>
		n++;
	return n;
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801471:	90                   	nop
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	8d 50 01             	lea    0x1(%eax),%edx
  801478:	89 55 08             	mov    %edx,0x8(%ebp)
  80147b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801481:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801484:	8a 12                	mov    (%edx),%dl
  801486:	88 10                	mov    %dl,(%eax)
  801488:	8a 00                	mov    (%eax),%al
  80148a:	84 c0                	test   %al,%al
  80148c:	75 e4                	jne    801472 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80148e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80149f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a6:	eb 1f                	jmp    8014c7 <strncpy+0x34>
		*dst++ = *src;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8d 50 01             	lea    0x1(%eax),%edx
  8014ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b4:	8a 12                	mov    (%edx),%dl
  8014b6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bb:	8a 00                	mov    (%eax),%al
  8014bd:	84 c0                	test   %al,%al
  8014bf:	74 03                	je     8014c4 <strncpy+0x31>
			src++;
  8014c1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c4:	ff 45 fc             	incl   -0x4(%ebp)
  8014c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ca:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014cd:	72 d9                	jb     8014a8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e4:	74 30                	je     801516 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014e6:	eb 16                	jmp    8014fe <strlcpy+0x2a>
			*dst++ = *src++;
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8014f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014fa:	8a 12                	mov    (%edx),%dl
  8014fc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014fe:	ff 4d 10             	decl   0x10(%ebp)
  801501:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801505:	74 09                	je     801510 <strlcpy+0x3c>
  801507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	84 c0                	test   %al,%al
  80150e:	75 d8                	jne    8014e8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801516:	8b 55 08             	mov    0x8(%ebp),%edx
  801519:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151c:	29 c2                	sub    %eax,%edx
  80151e:	89 d0                	mov    %edx,%eax
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801525:	eb 06                	jmp    80152d <strcmp+0xb>
		p++, q++;
  801527:	ff 45 08             	incl   0x8(%ebp)
  80152a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	84 c0                	test   %al,%al
  801534:	74 0e                	je     801544 <strcmp+0x22>
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 10                	mov    (%eax),%dl
  80153b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	38 c2                	cmp    %al,%dl
  801542:	74 e3                	je     801527 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	0f b6 d0             	movzbl %al,%edx
  80154c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f b6 c0             	movzbl %al,%eax
  801554:	29 c2                	sub    %eax,%edx
  801556:	89 d0                	mov    %edx,%eax
}
  801558:	5d                   	pop    %ebp
  801559:	c3                   	ret    

0080155a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80155d:	eb 09                	jmp    801568 <strncmp+0xe>
		n--, p++, q++;
  80155f:	ff 4d 10             	decl   0x10(%ebp)
  801562:	ff 45 08             	incl   0x8(%ebp)
  801565:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801568:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80156c:	74 17                	je     801585 <strncmp+0x2b>
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	84 c0                	test   %al,%al
  801575:	74 0e                	je     801585 <strncmp+0x2b>
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	8a 10                	mov    (%eax),%dl
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	38 c2                	cmp    %al,%dl
  801583:	74 da                	je     80155f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801585:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801589:	75 07                	jne    801592 <strncmp+0x38>
		return 0;
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
  801590:	eb 14                	jmp    8015a6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	8a 00                	mov    (%eax),%al
  801597:	0f b6 d0             	movzbl %al,%edx
  80159a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	0f b6 c0             	movzbl %al,%eax
  8015a2:	29 c2                	sub    %eax,%edx
  8015a4:	89 d0                	mov    %edx,%eax
}
  8015a6:	5d                   	pop    %ebp
  8015a7:	c3                   	ret    

008015a8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 04             	sub    $0x4,%esp
  8015ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b4:	eb 12                	jmp    8015c8 <strchr+0x20>
		if (*s == c)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015be:	75 05                	jne    8015c5 <strchr+0x1d>
			return (char *) s;
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	eb 11                	jmp    8015d6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c5:	ff 45 08             	incl   0x8(%ebp)
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 e5                	jne    8015b6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e4:	eb 0d                	jmp    8015f3 <strfind+0x1b>
		if (*s == c)
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	8a 00                	mov    (%eax),%al
  8015eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015ee:	74 0e                	je     8015fe <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015f0:	ff 45 08             	incl   0x8(%ebp)
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	8a 00                	mov    (%eax),%al
  8015f8:	84 c0                	test   %al,%al
  8015fa:	75 ea                	jne    8015e6 <strfind+0xe>
  8015fc:	eb 01                	jmp    8015ff <strfind+0x27>
		if (*s == c)
			break;
  8015fe:	90                   	nop
	return (char *) s;
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801610:	8b 45 10             	mov    0x10(%ebp),%eax
  801613:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801616:	eb 0e                	jmp    801626 <memset+0x22>
		*p++ = c;
  801618:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161b:	8d 50 01             	lea    0x1(%eax),%edx
  80161e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801626:	ff 4d f8             	decl   -0x8(%ebp)
  801629:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80162d:	79 e9                	jns    801618 <memset+0x14>
		*p++ = c;

	return v;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801646:	eb 16                	jmp    80165e <memcpy+0x2a>
		*d++ = *s++;
  801648:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164b:	8d 50 01             	lea    0x1(%eax),%edx
  80164e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801651:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801654:	8d 4a 01             	lea    0x1(%edx),%ecx
  801657:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80165a:	8a 12                	mov    (%edx),%dl
  80165c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	8d 50 ff             	lea    -0x1(%eax),%edx
  801664:	89 55 10             	mov    %edx,0x10(%ebp)
  801667:	85 c0                	test   %eax,%eax
  801669:	75 dd                	jne    801648 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801682:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801685:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801688:	73 50                	jae    8016da <memmove+0x6a>
  80168a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168d:	8b 45 10             	mov    0x10(%ebp),%eax
  801690:	01 d0                	add    %edx,%eax
  801692:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801695:	76 43                	jbe    8016da <memmove+0x6a>
		s += n;
  801697:	8b 45 10             	mov    0x10(%ebp),%eax
  80169a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a3:	eb 10                	jmp    8016b5 <memmove+0x45>
			*--d = *--s;
  8016a5:	ff 4d f8             	decl   -0x8(%ebp)
  8016a8:	ff 4d fc             	decl   -0x4(%ebp)
  8016ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ae:	8a 10                	mov    (%eax),%dl
  8016b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	75 e3                	jne    8016a5 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016c2:	eb 23                	jmp    8016e7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c7:	8d 50 01             	lea    0x1(%eax),%edx
  8016ca:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d6:	8a 12                	mov    (%edx),%dl
  8016d8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016da:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e0:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	75 dd                	jne    8016c4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016fe:	eb 2a                	jmp    80172a <memcmp+0x3e>
		if (*s1 != *s2)
  801700:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801703:	8a 10                	mov    (%eax),%dl
  801705:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	74 16                	je     801724 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 c0             	movzbl %al,%eax
  80171e:	29 c2                	sub    %eax,%edx
  801720:	89 d0                	mov    %edx,%eax
  801722:	eb 18                	jmp    80173c <memcmp+0x50>
		s1++, s2++;
  801724:	ff 45 fc             	incl   -0x4(%ebp)
  801727:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80172a:	8b 45 10             	mov    0x10(%ebp),%eax
  80172d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801730:	89 55 10             	mov    %edx,0x10(%ebp)
  801733:	85 c0                	test   %eax,%eax
  801735:	75 c9                	jne    801700 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801744:	8b 55 08             	mov    0x8(%ebp),%edx
  801747:	8b 45 10             	mov    0x10(%ebp),%eax
  80174a:	01 d0                	add    %edx,%eax
  80174c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80174f:	eb 15                	jmp    801766 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8a 00                	mov    (%eax),%al
  801756:	0f b6 d0             	movzbl %al,%edx
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	0f b6 c0             	movzbl %al,%eax
  80175f:	39 c2                	cmp    %eax,%edx
  801761:	74 0d                	je     801770 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801763:	ff 45 08             	incl   0x8(%ebp)
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80176c:	72 e3                	jb     801751 <memfind+0x13>
  80176e:	eb 01                	jmp    801771 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801770:	90                   	nop
	return (void *) s;
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80177c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801783:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178a:	eb 03                	jmp    80178f <strtol+0x19>
		s++;
  80178c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8a 00                	mov    (%eax),%al
  801794:	3c 20                	cmp    $0x20,%al
  801796:	74 f4                	je     80178c <strtol+0x16>
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	3c 09                	cmp    $0x9,%al
  80179f:	74 eb                	je     80178c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 2b                	cmp    $0x2b,%al
  8017a8:	75 05                	jne    8017af <strtol+0x39>
		s++;
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	eb 13                	jmp    8017c2 <strtol+0x4c>
	else if (*s == '-')
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8a 00                	mov    (%eax),%al
  8017b4:	3c 2d                	cmp    $0x2d,%al
  8017b6:	75 0a                	jne    8017c2 <strtol+0x4c>
		s++, neg = 1;
  8017b8:	ff 45 08             	incl   0x8(%ebp)
  8017bb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c6:	74 06                	je     8017ce <strtol+0x58>
  8017c8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017cc:	75 20                	jne    8017ee <strtol+0x78>
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	3c 30                	cmp    $0x30,%al
  8017d5:	75 17                	jne    8017ee <strtol+0x78>
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	40                   	inc    %eax
  8017db:	8a 00                	mov    (%eax),%al
  8017dd:	3c 78                	cmp    $0x78,%al
  8017df:	75 0d                	jne    8017ee <strtol+0x78>
		s += 2, base = 16;
  8017e1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017ec:	eb 28                	jmp    801816 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f2:	75 15                	jne    801809 <strtol+0x93>
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 30                	cmp    $0x30,%al
  8017fb:	75 0c                	jne    801809 <strtol+0x93>
		s++, base = 8;
  8017fd:	ff 45 08             	incl   0x8(%ebp)
  801800:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801807:	eb 0d                	jmp    801816 <strtol+0xa0>
	else if (base == 0)
  801809:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180d:	75 07                	jne    801816 <strtol+0xa0>
		base = 10;
  80180f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 2f                	cmp    $0x2f,%al
  80181d:	7e 19                	jle    801838 <strtol+0xc2>
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	3c 39                	cmp    $0x39,%al
  801826:	7f 10                	jg     801838 <strtol+0xc2>
			dig = *s - '0';
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	8a 00                	mov    (%eax),%al
  80182d:	0f be c0             	movsbl %al,%eax
  801830:	83 e8 30             	sub    $0x30,%eax
  801833:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801836:	eb 42                	jmp    80187a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 60                	cmp    $0x60,%al
  80183f:	7e 19                	jle    80185a <strtol+0xe4>
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	3c 7a                	cmp    $0x7a,%al
  801848:	7f 10                	jg     80185a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	8a 00                	mov    (%eax),%al
  80184f:	0f be c0             	movsbl %al,%eax
  801852:	83 e8 57             	sub    $0x57,%eax
  801855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801858:	eb 20                	jmp    80187a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8a 00                	mov    (%eax),%al
  80185f:	3c 40                	cmp    $0x40,%al
  801861:	7e 39                	jle    80189c <strtol+0x126>
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	8a 00                	mov    (%eax),%al
  801868:	3c 5a                	cmp    $0x5a,%al
  80186a:	7f 30                	jg     80189c <strtol+0x126>
			dig = *s - 'A' + 10;
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	8a 00                	mov    (%eax),%al
  801871:	0f be c0             	movsbl %al,%eax
  801874:	83 e8 37             	sub    $0x37,%eax
  801877:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801880:	7d 19                	jge    80189b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801882:	ff 45 08             	incl   0x8(%ebp)
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	0f af 45 10          	imul   0x10(%ebp),%eax
  80188c:	89 c2                	mov    %eax,%edx
  80188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801896:	e9 7b ff ff ff       	jmp    801816 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80189b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80189c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018a0:	74 08                	je     8018aa <strtol+0x134>
		*endptr = (char *) s;
  8018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ae:	74 07                	je     8018b7 <strtol+0x141>
  8018b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b3:	f7 d8                	neg    %eax
  8018b5:	eb 03                	jmp    8018ba <strtol+0x144>
  8018b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <ltostr>:

void
ltostr(long value, char *str)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d4:	79 13                	jns    8018e9 <ltostr+0x2d>
	{
		neg = 1;
  8018d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018f1:	99                   	cltd   
  8018f2:	f7 f9                	idiv   %ecx
  8018f4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fa:	8d 50 01             	lea    0x1(%eax),%edx
  8018fd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801900:	89 c2                	mov    %eax,%edx
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
  801905:	01 d0                	add    %edx,%eax
  801907:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80190a:	83 c2 30             	add    $0x30,%edx
  80190d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80190f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801912:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801917:	f7 e9                	imul   %ecx
  801919:	c1 fa 02             	sar    $0x2,%edx
  80191c:	89 c8                	mov    %ecx,%eax
  80191e:	c1 f8 1f             	sar    $0x1f,%eax
  801921:	29 c2                	sub    %eax,%edx
  801923:	89 d0                	mov    %edx,%eax
  801925:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801928:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801930:	f7 e9                	imul   %ecx
  801932:	c1 fa 02             	sar    $0x2,%edx
  801935:	89 c8                	mov    %ecx,%eax
  801937:	c1 f8 1f             	sar    $0x1f,%eax
  80193a:	29 c2                	sub    %eax,%edx
  80193c:	89 d0                	mov    %edx,%eax
  80193e:	c1 e0 02             	shl    $0x2,%eax
  801941:	01 d0                	add    %edx,%eax
  801943:	01 c0                	add    %eax,%eax
  801945:	29 c1                	sub    %eax,%ecx
  801947:	89 ca                	mov    %ecx,%edx
  801949:	85 d2                	test   %edx,%edx
  80194b:	75 9c                	jne    8018e9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80194d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801954:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801957:	48                   	dec    %eax
  801958:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80195b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80195f:	74 3d                	je     80199e <ltostr+0xe2>
		start = 1 ;
  801961:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801968:	eb 34                	jmp    80199e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80196a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801970:	01 d0                	add    %edx,%eax
  801972:	8a 00                	mov    (%eax),%al
  801974:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197d:	01 c2                	add    %eax,%edx
  80197f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801982:	8b 45 0c             	mov    0xc(%ebp),%eax
  801985:	01 c8                	add    %ecx,%eax
  801987:	8a 00                	mov    (%eax),%al
  801989:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80198b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801991:	01 c2                	add    %eax,%edx
  801993:	8a 45 eb             	mov    -0x15(%ebp),%al
  801996:	88 02                	mov    %al,(%edx)
		start++ ;
  801998:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80199b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a4:	7c c4                	jl     80196a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019ba:	ff 75 08             	pushl  0x8(%ebp)
  8019bd:	e8 54 fa ff ff       	call   801416 <strlen>
  8019c2:	83 c4 04             	add    $0x4,%esp
  8019c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	e8 46 fa ff ff       	call   801416 <strlen>
  8019d0:	83 c4 04             	add    $0x4,%esp
  8019d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e4:	eb 17                	jmp    8019fd <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ec:	01 c2                	add    %eax,%edx
  8019ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	01 c8                	add    %ecx,%eax
  8019f6:	8a 00                	mov    (%eax),%al
  8019f8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019fa:	ff 45 fc             	incl   -0x4(%ebp)
  8019fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a00:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a03:	7c e1                	jl     8019e6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a05:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a0c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a13:	eb 1f                	jmp    801a34 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a18:	8d 50 01             	lea    0x1(%eax),%edx
  801a1b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a1e:	89 c2                	mov    %eax,%edx
  801a20:	8b 45 10             	mov    0x10(%ebp),%eax
  801a23:	01 c2                	add    %eax,%edx
  801a25:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2b:	01 c8                	add    %ecx,%eax
  801a2d:	8a 00                	mov    (%eax),%al
  801a2f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a31:	ff 45 f8             	incl   -0x8(%ebp)
  801a34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a3a:	7c d9                	jl     801a15 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a42:	01 d0                	add    %edx,%eax
  801a44:	c6 00 00             	movb   $0x0,(%eax)
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a56:	8b 45 14             	mov    0x14(%ebp),%eax
  801a59:	8b 00                	mov    (%eax),%eax
  801a5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a62:	8b 45 10             	mov    0x10(%ebp),%eax
  801a65:	01 d0                	add    %edx,%eax
  801a67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a6d:	eb 0c                	jmp    801a7b <strsplit+0x31>
			*string++ = 0;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8d 50 01             	lea    0x1(%eax),%edx
  801a75:	89 55 08             	mov    %edx,0x8(%ebp)
  801a78:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	74 18                	je     801a9c <strsplit+0x52>
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	8a 00                	mov    (%eax),%al
  801a89:	0f be c0             	movsbl %al,%eax
  801a8c:	50                   	push   %eax
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	e8 13 fb ff ff       	call   8015a8 <strchr>
  801a95:	83 c4 08             	add    $0x8,%esp
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	75 d3                	jne    801a6f <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	84 c0                	test   %al,%al
  801aa3:	74 5a                	je     801aff <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801aa5:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa8:	8b 00                	mov    (%eax),%eax
  801aaa:	83 f8 0f             	cmp    $0xf,%eax
  801aad:	75 07                	jne    801ab6 <strsplit+0x6c>
		{
			return 0;
  801aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab4:	eb 66                	jmp    801b1c <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab9:	8b 00                	mov    (%eax),%eax
  801abb:	8d 48 01             	lea    0x1(%eax),%ecx
  801abe:	8b 55 14             	mov    0x14(%ebp),%edx
  801ac1:	89 0a                	mov    %ecx,(%edx)
  801ac3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aca:	8b 45 10             	mov    0x10(%ebp),%eax
  801acd:	01 c2                	add    %eax,%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad4:	eb 03                	jmp    801ad9 <strsplit+0x8f>
			string++;
  801ad6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	8a 00                	mov    (%eax),%al
  801ade:	84 c0                	test   %al,%al
  801ae0:	74 8b                	je     801a6d <strsplit+0x23>
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	8a 00                	mov    (%eax),%al
  801ae7:	0f be c0             	movsbl %al,%eax
  801aea:	50                   	push   %eax
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	e8 b5 fa ff ff       	call   8015a8 <strchr>
  801af3:	83 c4 08             	add    $0x8,%esp
  801af6:	85 c0                	test   %eax,%eax
  801af8:	74 dc                	je     801ad6 <strsplit+0x8c>
			string++;
	}
  801afa:	e9 6e ff ff ff       	jmp    801a6d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801aff:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b00:	8b 45 14             	mov    0x14(%ebp),%eax
  801b03:	8b 00                	mov    (%eax),%eax
  801b05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	01 d0                	add    %edx,%eax
  801b11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b17:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801b27:	e8 7d 0f 00 00       	call   802aa9 <sys_isUHeapPlacementStrategyNEXTFIT>
  801b2c:	85 c0                	test   %eax,%eax
  801b2e:	0f 84 6f 03 00 00    	je     801ea3 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801b34:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801b3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b3e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801b41:	01 d0                	add    %edx,%eax
  801b43:	48                   	dec    %eax
  801b44:	89 45 80             	mov    %eax,-0x80(%ebp)
  801b47:	8b 45 80             	mov    -0x80(%ebp),%eax
  801b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4f:	f7 75 84             	divl   -0x7c(%ebp)
  801b52:	8b 45 80             	mov    -0x80(%ebp),%eax
  801b55:	29 d0                	sub    %edx,%eax
  801b57:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801b5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b5e:	74 09                	je     801b69 <malloc+0x4b>
  801b60:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b67:	76 0a                	jbe    801b73 <malloc+0x55>
			return NULL;
  801b69:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6e:	e9 4b 09 00 00       	jmp    8024be <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801b73:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	01 d0                	add    %edx,%eax
  801b7e:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801b83:	0f 87 a2 00 00 00    	ja     801c2b <malloc+0x10d>
  801b89:	a1 40 40 98 00       	mov    0x984040,%eax
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	0f 85 95 00 00 00    	jne    801c2b <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801b96:	a1 04 40 80 00       	mov    0x804004,%eax
  801b9b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801ba1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ba6:	83 ec 08             	sub    $0x8,%esp
  801ba9:	ff 75 08             	pushl  0x8(%ebp)
  801bac:	50                   	push   %eax
  801bad:	e8 a3 0b 00 00       	call   802755 <sys_allocateMem>
  801bb2:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801bb5:	a1 20 40 80 00       	mov    0x804020,%eax
  801bba:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbd:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801bc4:	a1 20 40 80 00       	mov    0x804020,%eax
  801bc9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bcf:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  801bd6:	a1 20 40 80 00       	mov    0x804020,%eax
  801bdb:	40                   	inc    %eax
  801bdc:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  801be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801be8:	eb 2e                	jmp    801c18 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801bea:	a1 04 40 80 00       	mov    0x804004,%eax
  801bef:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801bf4:	c1 e8 0c             	shr    $0xc,%eax
  801bf7:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801bfe:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801c02:	a1 04 40 80 00       	mov    0x804004,%eax
  801c07:	05 00 10 00 00       	add    $0x1000,%eax
  801c0c:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801c11:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c1e:	72 ca                	jb     801bea <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801c20:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801c26:	e9 93 08 00 00       	jmp    8024be <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801c2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801c32:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801c39:	a1 40 40 98 00       	mov    0x984040,%eax
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	75 1d                	jne    801c5f <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801c42:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801c49:	00 00 80 
				check = 1;
  801c4c:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  801c53:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801c56:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801c5d:	eb 08                	jmp    801c67 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801c5f:	a1 04 40 80 00       	mov    0x804004,%eax
  801c64:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801c67:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801c6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801c75:	a1 04 40 80 00       	mov    0x804004,%eax
  801c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801c7d:	eb 4d                	jmp    801ccc <malloc+0x1ae>
				if (sz == size) {
  801c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c82:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c85:	75 09                	jne    801c90 <malloc+0x172>
					f = 1;
  801c87:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801c8e:	eb 45                	jmp    801cd5 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c93:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801c98:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801c9b:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	75 10                	jne    801cb6 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801ca6:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801cad:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801cb4:	eb 16                	jmp    801ccc <malloc+0x1ae>
				} else {
					sz = 0;
  801cb6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801cbd:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801cc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc7:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801ccc:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801cd3:	76 aa                	jbe    801c7f <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801cd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cd9:	0f 84 95 00 00 00    	je     801d74 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801cdf:	a1 04 40 80 00       	mov    0x804004,%eax
  801ce4:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801cea:	a1 04 40 80 00       	mov    0x804004,%eax
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	ff 75 08             	pushl  0x8(%ebp)
  801cf5:	50                   	push   %eax
  801cf6:	e8 5a 0a 00 00       	call   802755 <sys_allocateMem>
  801cfb:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801cfe:	a1 20 40 80 00       	mov    0x804020,%eax
  801d03:	8b 55 08             	mov    0x8(%ebp),%edx
  801d06:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801d0d:	a1 20 40 80 00       	mov    0x804020,%eax
  801d12:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d18:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  801d1f:	a1 20 40 80 00       	mov    0x804020,%eax
  801d24:	40                   	inc    %eax
  801d25:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  801d2a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801d31:	eb 2e                	jmp    801d61 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801d33:	a1 04 40 80 00       	mov    0x804004,%eax
  801d38:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801d3d:	c1 e8 0c             	shr    $0xc,%eax
  801d40:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801d47:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801d4b:	a1 04 40 80 00       	mov    0x804004,%eax
  801d50:	05 00 10 00 00       	add    $0x1000,%eax
  801d55:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801d5a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801d61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d64:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d67:	72 ca                	jb     801d33 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801d69:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801d6f:	e9 4a 07 00 00       	jmp    8024be <malloc+0x9a0>

			} else {

				if (check_start) {
  801d74:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d78:	74 0a                	je     801d84 <malloc+0x266>

					return NULL;
  801d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7f:	e9 3a 07 00 00       	jmp    8024be <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801d84:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801d8b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801d92:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801d99:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801da0:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801da3:	eb 4d                	jmp    801df2 <malloc+0x2d4>
					if (sz == size) {
  801da5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801da8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dab:	75 09                	jne    801db6 <malloc+0x298>
						f = 1;
  801dad:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801db4:	eb 44                	jmp    801dfa <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801db6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801db9:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801dbe:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801dc1:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801dc8:	85 c0                	test   %eax,%eax
  801dca:	75 10                	jne    801ddc <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801dcc:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801dd3:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801dda:	eb 16                	jmp    801df2 <malloc+0x2d4>
					} else {
						sz = 0;
  801ddc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801de3:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801dea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ded:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801df8:	72 ab                	jb     801da5 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801dfa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801dfe:	0f 84 95 00 00 00    	je     801e99 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801e04:	a1 04 40 80 00       	mov    0x804004,%eax
  801e09:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801e0f:	a1 04 40 80 00       	mov    0x804004,%eax
  801e14:	83 ec 08             	sub    $0x8,%esp
  801e17:	ff 75 08             	pushl  0x8(%ebp)
  801e1a:	50                   	push   %eax
  801e1b:	e8 35 09 00 00       	call   802755 <sys_allocateMem>
  801e20:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801e23:	a1 20 40 80 00       	mov    0x804020,%eax
  801e28:	8b 55 08             	mov    0x8(%ebp),%edx
  801e2b:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801e32:	a1 20 40 80 00       	mov    0x804020,%eax
  801e37:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e3d:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  801e44:	a1 20 40 80 00       	mov    0x804020,%eax
  801e49:	40                   	inc    %eax
  801e4a:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  801e4f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801e56:	eb 2e                	jmp    801e86 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801e58:	a1 04 40 80 00       	mov    0x804004,%eax
  801e5d:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801e62:	c1 e8 0c             	shr    $0xc,%eax
  801e65:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801e6c:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801e70:	a1 04 40 80 00       	mov    0x804004,%eax
  801e75:	05 00 10 00 00       	add    $0x1000,%eax
  801e7a:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801e7f:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801e86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e89:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e8c:	72 ca                	jb     801e58 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801e8e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801e94:	e9 25 06 00 00       	jmp    8024be <malloc+0x9a0>

				} else {

					return NULL;
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9e:	e9 1b 06 00 00       	jmp    8024be <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801ea3:	e8 d0 0b 00 00       	call   802a78 <sys_isUHeapPlacementStrategyBESTFIT>
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	0f 84 ba 01 00 00    	je     80206a <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801eb0:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801eb7:	10 00 00 
  801eba:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebd:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801ec3:	01 d0                	add    %edx,%eax
  801ec5:	48                   	dec    %eax
  801ec6:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801ecc:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801ed2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed7:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801edd:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801ee3:	29 d0                	sub    %edx,%eax
  801ee5:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801ee8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eec:	74 09                	je     801ef7 <malloc+0x3d9>
  801eee:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ef5:	76 0a                	jbe    801f01 <malloc+0x3e3>
			return NULL;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	e9 bd 05 00 00       	jmp    8024be <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801f01:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801f08:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801f0f:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801f16:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801f1d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	c1 e8 0c             	shr    $0xc,%eax
  801f2a:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801f30:	e9 80 00 00 00       	jmp    801fb5 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801f35:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f38:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	75 0c                	jne    801f4f <malloc+0x431>

				count++;
  801f43:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801f46:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801f4d:	eb 2d                	jmp    801f7c <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801f4f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801f55:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801f58:	77 14                	ja     801f6e <malloc+0x450>
  801f5a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f5d:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801f60:	76 0c                	jbe    801f6e <malloc+0x450>

					min_sz = count;
  801f62:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f65:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801f68:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f6b:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801f6e:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801f75:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801f7c:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801f83:	75 2d                	jne    801fb2 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801f85:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801f8b:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801f8e:	77 22                	ja     801fb2 <malloc+0x494>
  801f90:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f93:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801f96:	76 1a                	jbe    801fb2 <malloc+0x494>

					min_sz = count;
  801f98:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f9b:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801f9e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fa1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801fa4:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801fab:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801fb2:	ff 45 b8             	incl   -0x48(%ebp)
  801fb5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fb8:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801fbd:	0f 86 72 ff ff ff    	jbe    801f35 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801fc3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801fc9:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801fcc:	77 06                	ja     801fd4 <malloc+0x4b6>
  801fce:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801fd2:	75 0a                	jne    801fde <malloc+0x4c0>
			return NULL;
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	e9 e0 04 00 00       	jmp    8024be <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801fde:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fe1:	c1 e0 0c             	shl    $0xc,%eax
  801fe4:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801fe7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fea:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	ff 75 08             	pushl  0x8(%ebp)
  801ff6:	ff 75 c4             	pushl  -0x3c(%ebp)
  801ff9:	e8 57 07 00 00       	call   802755 <sys_allocateMem>
  801ffe:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802001:	a1 20 40 80 00       	mov    0x804020,%eax
  802006:	8b 55 08             	mov    0x8(%ebp),%edx
  802009:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  802010:	a1 20 40 80 00       	mov    0x804020,%eax
  802015:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802018:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  80201f:	a1 20 40 80 00       	mov    0x804020,%eax
  802024:	40                   	inc    %eax
  802025:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  80202a:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802031:	eb 24                	jmp    802057 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802033:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802036:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80203b:	c1 e8 0c             	shr    $0xc,%eax
  80203e:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802045:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802049:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802050:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  802057:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80205a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80205d:	72 d4                	jb     802033 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  80205f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802065:	e9 54 04 00 00       	jmp    8024be <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  80206a:	e8 d8 09 00 00       	call   802a47 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80206f:	85 c0                	test   %eax,%eax
  802071:	0f 84 88 01 00 00    	je     8021ff <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  802077:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  80207e:	10 00 00 
  802081:	8b 55 08             	mov    0x8(%ebp),%edx
  802084:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80208a:	01 d0                	add    %edx,%eax
  80208c:	48                   	dec    %eax
  80208d:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  802093:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  802099:	ba 00 00 00 00       	mov    $0x0,%edx
  80209e:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  8020a4:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8020aa:	29 d0                	sub    %edx,%eax
  8020ac:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8020af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b3:	74 09                	je     8020be <malloc+0x5a0>
  8020b5:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8020bc:	76 0a                	jbe    8020c8 <malloc+0x5aa>
			return NULL;
  8020be:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c3:	e9 f6 03 00 00       	jmp    8024be <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  8020c8:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  8020cf:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  8020d6:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  8020dd:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  8020e4:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	c1 e8 0c             	shr    $0xc,%eax
  8020f1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  8020f7:	eb 5a                	jmp    802153 <malloc+0x635>

			if (heap_mem[i] == 0) {
  8020f9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8020fc:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	75 0c                	jne    802113 <malloc+0x5f5>

				count++;
  802107:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  80210a:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  802111:	eb 22                	jmp    802135 <malloc+0x617>
			} else {
				if (num_p <= count) {
  802113:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802119:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  80211c:	77 09                	ja     802127 <malloc+0x609>

					found = 1;
  80211e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  802125:	eb 36                	jmp    80215d <malloc+0x63f>
				}
				count = 0;
  802127:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  80212e:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  802135:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  80213c:	75 12                	jne    802150 <malloc+0x632>

				if (num_p <= count) {
  80213e:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802144:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  802147:	77 07                	ja     802150 <malloc+0x632>

					found = 1;
  802149:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  802150:	ff 45 a4             	incl   -0x5c(%ebp)
  802153:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802156:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  80215b:	76 9c                	jbe    8020f9 <malloc+0x5db>

			}

		}

		if (!found) {
  80215d:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  802161:	75 0a                	jne    80216d <malloc+0x64f>
			return NULL;
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
  802168:	e9 51 03 00 00       	jmp    8024be <malloc+0x9a0>

		}

		temp = ptr;
  80216d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802170:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  802173:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802176:	c1 e0 0c             	shl    $0xc,%eax
  802179:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  80217c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80217f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  802185:	83 ec 08             	sub    $0x8,%esp
  802188:	ff 75 08             	pushl  0x8(%ebp)
  80218b:	ff 75 b0             	pushl  -0x50(%ebp)
  80218e:	e8 c2 05 00 00       	call   802755 <sys_allocateMem>
  802193:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802196:	a1 20 40 80 00       	mov    0x804020,%eax
  80219b:	8b 55 08             	mov    0x8(%ebp),%edx
  80219e:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8021a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8021aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021ad:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8021b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8021b9:	40                   	inc    %eax
  8021ba:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  8021bf:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8021c6:	eb 24                	jmp    8021ec <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8021c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021cb:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8021d0:	c1 e8 0c             	shr    $0xc,%eax
  8021d3:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8021da:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  8021de:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8021e5:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  8021ec:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8021ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f2:	72 d4                	jb     8021c8 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8021f4:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8021fa:	e9 bf 02 00 00       	jmp    8024be <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  8021ff:	e8 d6 08 00 00       	call   802ada <sys_isUHeapPlacementStrategyWORSTFIT>
  802204:	85 c0                	test   %eax,%eax
  802206:	0f 84 ba 01 00 00    	je     8023c6 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  80220c:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  802213:	10 00 00 
  802216:	8b 55 08             	mov    0x8(%ebp),%edx
  802219:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80221f:	01 d0                	add    %edx,%eax
  802221:	48                   	dec    %eax
  802222:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802228:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80222e:	ba 00 00 00 00       	mov    $0x0,%edx
  802233:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802239:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80223f:	29 d0                	sub    %edx,%eax
  802241:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802244:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802248:	74 09                	je     802253 <malloc+0x735>
  80224a:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802251:	76 0a                	jbe    80225d <malloc+0x73f>
					return NULL;
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
  802258:	e9 61 02 00 00       	jmp    8024be <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  80225d:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  802264:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  80226b:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  802272:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  802279:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	c1 e8 0c             	shr    $0xc,%eax
  802286:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  80228c:	e9 80 00 00 00       	jmp    802311 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  802291:	8b 45 90             	mov    -0x70(%ebp),%eax
  802294:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  80229b:	85 c0                	test   %eax,%eax
  80229d:	75 0c                	jne    8022ab <malloc+0x78d>

						count++;
  80229f:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  8022a2:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  8022a9:	eb 2d                	jmp    8022d8 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  8022ab:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8022b1:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8022b4:	77 14                	ja     8022ca <malloc+0x7ac>
  8022b6:	8b 45 98             	mov    -0x68(%ebp),%eax
  8022b9:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8022bc:	73 0c                	jae    8022ca <malloc+0x7ac>

							max_sz = count;
  8022be:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8022c1:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8022c4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8022c7:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  8022ca:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  8022d1:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  8022d8:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  8022df:	75 2d                	jne    80230e <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  8022e1:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8022e7:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8022ea:	77 22                	ja     80230e <malloc+0x7f0>
  8022ec:	8b 45 98             	mov    -0x68(%ebp),%eax
  8022ef:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8022f2:	76 1a                	jbe    80230e <malloc+0x7f0>

							max_sz = count;
  8022f4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8022f7:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8022fa:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8022fd:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  802300:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  802307:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  80230e:	ff 45 90             	incl   -0x70(%ebp)
  802311:	8b 45 90             	mov    -0x70(%ebp),%eax
  802314:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802319:	0f 86 72 ff ff ff    	jbe    802291 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  80231f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802325:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802328:	77 06                	ja     802330 <malloc+0x812>
  80232a:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80232e:	75 0a                	jne    80233a <malloc+0x81c>
					return NULL;
  802330:	b8 00 00 00 00       	mov    $0x0,%eax
  802335:	e9 84 01 00 00       	jmp    8024be <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  80233a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80233d:	c1 e0 0c             	shl    $0xc,%eax
  802340:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  802343:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802346:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  80234c:	83 ec 08             	sub    $0x8,%esp
  80234f:	ff 75 08             	pushl  0x8(%ebp)
  802352:	ff 75 9c             	pushl  -0x64(%ebp)
  802355:	e8 fb 03 00 00       	call   802755 <sys_allocateMem>
  80235a:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  80235d:	a1 20 40 80 00       	mov    0x804020,%eax
  802362:	8b 55 08             	mov    0x8(%ebp),%edx
  802365:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  80236c:	a1 20 40 80 00       	mov    0x804020,%eax
  802371:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802374:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  80237b:	a1 20 40 80 00       	mov    0x804020,%eax
  802380:	40                   	inc    %eax
  802381:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  802386:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80238d:	eb 24                	jmp    8023b3 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  80238f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802392:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802397:	c1 e8 0c             	shr    $0xc,%eax
  80239a:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8023a1:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  8023a5:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8023ac:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  8023b3:	8b 45 90             	mov    -0x70(%ebp),%eax
  8023b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b9:	72 d4                	jb     80238f <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  8023bb:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8023c1:	e9 f8 00 00 00       	jmp    8024be <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  8023c6:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  8023cd:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  8023d4:	10 00 00 
  8023d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023da:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8023e0:	01 d0                	add    %edx,%eax
  8023e2:	48                   	dec    %eax
  8023e3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  8023e9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8023ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f4:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  8023fa:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802400:	29 d0                	sub    %edx,%eax
  802402:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802405:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802409:	74 09                	je     802414 <malloc+0x8f6>
  80240b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802412:	76 0a                	jbe    80241e <malloc+0x900>
		return NULL;
  802414:	b8 00 00 00 00       	mov    $0x0,%eax
  802419:	e9 a0 00 00 00       	jmp    8024be <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  80241e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	01 d0                	add    %edx,%eax
  802429:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80242e:	0f 87 87 00 00 00    	ja     8024bb <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802434:	a1 04 40 80 00       	mov    0x804004,%eax
  802439:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  80243c:	a1 04 40 80 00       	mov    0x804004,%eax
  802441:	83 ec 08             	sub    $0x8,%esp
  802444:	ff 75 08             	pushl  0x8(%ebp)
  802447:	50                   	push   %eax
  802448:	e8 08 03 00 00       	call   802755 <sys_allocateMem>
  80244d:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802450:	a1 20 40 80 00       	mov    0x804020,%eax
  802455:	8b 55 08             	mov    0x8(%ebp),%edx
  802458:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80245f:	a1 20 40 80 00       	mov    0x804020,%eax
  802464:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80246a:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  802471:	a1 20 40 80 00       	mov    0x804020,%eax
  802476:	40                   	inc    %eax
  802477:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  80247c:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  802483:	eb 2e                	jmp    8024b3 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802485:	a1 04 40 80 00       	mov    0x804004,%eax
  80248a:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80248f:	c1 e8 0c             	shr    $0xc,%eax
  802492:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802499:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  80249d:	a1 04 40 80 00       	mov    0x804004,%eax
  8024a2:	05 00 10 00 00       	add    $0x1000,%eax
  8024a7:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8024ac:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  8024b3:	8b 45 88             	mov    -0x78(%ebp),%eax
  8024b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b9:	72 ca                	jb     802485 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  8024bb:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  8024c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  8024cd:	e9 c1 00 00 00       	jmp    802593 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  8024dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024df:	0f 85 ab 00 00 00    	jne    802590 <free+0xd0>

			if (heap_size[inx].size == 0) {
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	75 21                	jne    802514 <free+0x54>
				heap_size[inx].size = 0;
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  8024fd:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  80250b:	00 00 00 00 
				return;
  80250f:	e9 8d 00 00 00       	jmp    8025a1 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	83 ec 08             	sub    $0x8,%esp
  802524:	52                   	push   %edx
  802525:	50                   	push   %eax
  802526:	e8 0e 02 00 00       	call   802739 <sys_freeMem>
  80252b:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  80252e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80253b:	eb 24                	jmp    802561 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  80253d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802540:	05 00 00 00 80       	add    $0x80000000,%eax
  802545:	c1 e8 0c             	shr    $0xc,%eax
  802548:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  80254f:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  802553:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80255a:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	39 c2                	cmp    %eax,%edx
  802570:	77 cb                	ja     80253d <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  80257c:	00 00 00 00 
			heap_size[inx].vir = NULL;
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  80258a:	00 00 00 00 
			break;
  80258e:	eb 11                	jmp    8025a1 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  802590:	ff 45 f4             	incl   -0xc(%ebp)
  802593:	a1 20 40 80 00       	mov    0x804020,%eax
  802598:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80259b:	0f 8c 31 ff ff ff    	jl     8024d2 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
  8025a6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	68 d0 33 80 00       	push   $0x8033d0
  8025b1:	68 1c 02 00 00       	push   $0x21c
  8025b6:	68 f6 33 80 00       	push   $0x8033f6
  8025bb:	e8 b0 e6 ff ff       	call   800c70 <_panic>

008025c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	57                   	push   %edi
  8025c4:	56                   	push   %esi
  8025c5:	53                   	push   %ebx
  8025c6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025d5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8025d8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8025db:	cd 30                	int    $0x30
  8025dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8025e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8025e3:	83 c4 10             	add    $0x10,%esp
  8025e6:	5b                   	pop    %ebx
  8025e7:	5e                   	pop    %esi
  8025e8:	5f                   	pop    %edi
  8025e9:	5d                   	pop    %ebp
  8025ea:	c3                   	ret    

008025eb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	ff 75 0c             	pushl  0xc(%ebp)
  8025fa:	50                   	push   %eax
  8025fb:	6a 00                	push   $0x0
  8025fd:	e8 be ff ff ff       	call   8025c0 <syscall>
  802602:	83 c4 18             	add    $0x18,%esp
}
  802605:	90                   	nop
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <sys_cgetc>:

int
sys_cgetc(void)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 01                	push   $0x1
  802617:	e8 a4 ff ff ff       	call   8025c0 <syscall>
  80261c:	83 c4 18             	add    $0x18,%esp
}
  80261f:	c9                   	leave  
  802620:	c3                   	ret    

00802621 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802624:	8b 45 08             	mov    0x8(%ebp),%eax
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	50                   	push   %eax
  802630:	6a 03                	push   $0x3
  802632:	e8 89 ff ff ff       	call   8025c0 <syscall>
  802637:	83 c4 18             	add    $0x18,%esp
}
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 02                	push   $0x2
  80264b:	e8 70 ff ff ff       	call   8025c0 <syscall>
  802650:	83 c4 18             	add    $0x18,%esp
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <sys_env_exit>:

void sys_env_exit(void)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 04                	push   $0x4
  802664:	e8 57 ff ff ff       	call   8025c0 <syscall>
  802669:	83 c4 18             	add    $0x18,%esp
}
  80266c:	90                   	nop
  80266d:	c9                   	leave  
  80266e:	c3                   	ret    

0080266f <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80266f:	55                   	push   %ebp
  802670:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802672:	8b 55 0c             	mov    0xc(%ebp),%edx
  802675:	8b 45 08             	mov    0x8(%ebp),%eax
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	52                   	push   %edx
  80267f:	50                   	push   %eax
  802680:	6a 05                	push   $0x5
  802682:	e8 39 ff ff ff       	call   8025c0 <syscall>
  802687:	83 c4 18             	add    $0x18,%esp
}
  80268a:	c9                   	leave  
  80268b:	c3                   	ret    

0080268c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
  80268f:	56                   	push   %esi
  802690:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802691:	8b 75 18             	mov    0x18(%ebp),%esi
  802694:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802697:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80269a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	56                   	push   %esi
  8026a1:	53                   	push   %ebx
  8026a2:	51                   	push   %ecx
  8026a3:	52                   	push   %edx
  8026a4:	50                   	push   %eax
  8026a5:	6a 06                	push   $0x6
  8026a7:	e8 14 ff ff ff       	call   8025c0 <syscall>
  8026ac:	83 c4 18             	add    $0x18,%esp
}
  8026af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026b2:	5b                   	pop    %ebx
  8026b3:	5e                   	pop    %esi
  8026b4:	5d                   	pop    %ebp
  8026b5:	c3                   	ret    

008026b6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8026b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	52                   	push   %edx
  8026c6:	50                   	push   %eax
  8026c7:	6a 07                	push   $0x7
  8026c9:	e8 f2 fe ff ff       	call   8025c0 <syscall>
  8026ce:	83 c4 18             	add    $0x18,%esp
}
  8026d1:	c9                   	leave  
  8026d2:	c3                   	ret    

008026d3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	ff 75 0c             	pushl  0xc(%ebp)
  8026df:	ff 75 08             	pushl  0x8(%ebp)
  8026e2:	6a 08                	push   $0x8
  8026e4:	e8 d7 fe ff ff       	call   8025c0 <syscall>
  8026e9:	83 c4 18             	add    $0x18,%esp
}
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 09                	push   $0x9
  8026fd:	e8 be fe ff ff       	call   8025c0 <syscall>
  802702:	83 c4 18             	add    $0x18,%esp
}
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 0a                	push   $0xa
  802716:	e8 a5 fe ff ff       	call   8025c0 <syscall>
  80271b:	83 c4 18             	add    $0x18,%esp
}
  80271e:	c9                   	leave  
  80271f:	c3                   	ret    

00802720 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 0b                	push   $0xb
  80272f:	e8 8c fe ff ff       	call   8025c0 <syscall>
  802734:	83 c4 18             	add    $0x18,%esp
}
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	ff 75 0c             	pushl  0xc(%ebp)
  802745:	ff 75 08             	pushl  0x8(%ebp)
  802748:	6a 0d                	push   $0xd
  80274a:	e8 71 fe ff ff       	call   8025c0 <syscall>
  80274f:	83 c4 18             	add    $0x18,%esp
	return;
  802752:	90                   	nop
}
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	ff 75 0c             	pushl  0xc(%ebp)
  802761:	ff 75 08             	pushl  0x8(%ebp)
  802764:	6a 0e                	push   $0xe
  802766:	e8 55 fe ff ff       	call   8025c0 <syscall>
  80276b:	83 c4 18             	add    $0x18,%esp
	return ;
  80276e:	90                   	nop
}
  80276f:	c9                   	leave  
  802770:	c3                   	ret    

00802771 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 0c                	push   $0xc
  802780:	e8 3b fe ff ff       	call   8025c0 <syscall>
  802785:	83 c4 18             	add    $0x18,%esp
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 10                	push   $0x10
  802799:	e8 22 fe ff ff       	call   8025c0 <syscall>
  80279e:	83 c4 18             	add    $0x18,%esp
}
  8027a1:	90                   	nop
  8027a2:	c9                   	leave  
  8027a3:	c3                   	ret    

008027a4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 11                	push   $0x11
  8027b3:	e8 08 fe ff ff       	call   8025c0 <syscall>
  8027b8:	83 c4 18             	add    $0x18,%esp
}
  8027bb:	90                   	nop
  8027bc:	c9                   	leave  
  8027bd:	c3                   	ret    

008027be <sys_cputc>:


void
sys_cputc(const char c)
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
  8027c1:	83 ec 04             	sub    $0x4,%esp
  8027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8027ca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	50                   	push   %eax
  8027d7:	6a 12                	push   $0x12
  8027d9:	e8 e2 fd ff ff       	call   8025c0 <syscall>
  8027de:	83 c4 18             	add    $0x18,%esp
}
  8027e1:	90                   	nop
  8027e2:	c9                   	leave  
  8027e3:	c3                   	ret    

008027e4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 13                	push   $0x13
  8027f3:	e8 c8 fd ff ff       	call   8025c0 <syscall>
  8027f8:	83 c4 18             	add    $0x18,%esp
}
  8027fb:	90                   	nop
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	ff 75 0c             	pushl  0xc(%ebp)
  80280d:	50                   	push   %eax
  80280e:	6a 14                	push   $0x14
  802810:	e8 ab fd ff ff       	call   8025c0 <syscall>
  802815:	83 c4 18             	add    $0x18,%esp
}
  802818:	c9                   	leave  
  802819:	c3                   	ret    

0080281a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	50                   	push   %eax
  802829:	6a 17                	push   $0x17
  80282b:	e8 90 fd ff ff       	call   8025c0 <syscall>
  802830:	83 c4 18             	add    $0x18,%esp
}
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	6a 00                	push   $0x0
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	50                   	push   %eax
  802844:	6a 15                	push   $0x15
  802846:	e8 75 fd ff ff       	call   8025c0 <syscall>
  80284b:	83 c4 18             	add    $0x18,%esp
}
  80284e:	90                   	nop
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802854:	8b 45 08             	mov    0x8(%ebp),%eax
  802857:	6a 00                	push   $0x0
  802859:	6a 00                	push   $0x0
  80285b:	6a 00                	push   $0x0
  80285d:	6a 00                	push   $0x0
  80285f:	50                   	push   %eax
  802860:	6a 16                	push   $0x16
  802862:	e8 59 fd ff ff       	call   8025c0 <syscall>
  802867:	83 c4 18             	add    $0x18,%esp
}
  80286a:	90                   	nop
  80286b:	c9                   	leave  
  80286c:	c3                   	ret    

0080286d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  80286d:	55                   	push   %ebp
  80286e:	89 e5                	mov    %esp,%ebp
  802870:	83 ec 04             	sub    $0x4,%esp
  802873:	8b 45 10             	mov    0x10(%ebp),%eax
  802876:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802879:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80287c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	6a 00                	push   $0x0
  802885:	51                   	push   %ecx
  802886:	52                   	push   %edx
  802887:	ff 75 0c             	pushl  0xc(%ebp)
  80288a:	50                   	push   %eax
  80288b:	6a 18                	push   $0x18
  80288d:	e8 2e fd ff ff       	call   8025c0 <syscall>
  802892:	83 c4 18             	add    $0x18,%esp
}
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  80289a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	52                   	push   %edx
  8028a7:	50                   	push   %eax
  8028a8:	6a 19                	push   $0x19
  8028aa:	e8 11 fd ff ff       	call   8025c0 <syscall>
  8028af:	83 c4 18             	add    $0x18,%esp
}
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	50                   	push   %eax
  8028c3:	6a 1a                	push   $0x1a
  8028c5:	e8 f6 fc ff ff       	call   8025c0 <syscall>
  8028ca:	83 c4 18             	add    $0x18,%esp
}
  8028cd:	c9                   	leave  
  8028ce:	c3                   	ret    

008028cf <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8028cf:	55                   	push   %ebp
  8028d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 1b                	push   $0x1b
  8028de:	e8 dd fc ff ff       	call   8025c0 <syscall>
  8028e3:	83 c4 18             	add    $0x18,%esp
}
  8028e6:	c9                   	leave  
  8028e7:	c3                   	ret    

008028e8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8028e8:	55                   	push   %ebp
  8028e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 1c                	push   $0x1c
  8028f7:	e8 c4 fc ff ff       	call   8025c0 <syscall>
  8028fc:	83 c4 18             	add    $0x18,%esp
}
  8028ff:	c9                   	leave  
  802900:	c3                   	ret    

00802901 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802901:	55                   	push   %ebp
  802902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	ff 75 0c             	pushl  0xc(%ebp)
  802910:	50                   	push   %eax
  802911:	6a 1d                	push   $0x1d
  802913:	e8 a8 fc ff ff       	call   8025c0 <syscall>
  802918:	83 c4 18             	add    $0x18,%esp
}
  80291b:	c9                   	leave  
  80291c:	c3                   	ret    

0080291d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80291d:	55                   	push   %ebp
  80291e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	50                   	push   %eax
  80292c:	6a 1e                	push   $0x1e
  80292e:	e8 8d fc ff ff       	call   8025c0 <syscall>
  802933:	83 c4 18             	add    $0x18,%esp
}
  802936:	90                   	nop
  802937:	c9                   	leave  
  802938:	c3                   	ret    

00802939 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 00                	push   $0x0
  802947:	50                   	push   %eax
  802948:	6a 1f                	push   $0x1f
  80294a:	e8 71 fc ff ff       	call   8025c0 <syscall>
  80294f:	83 c4 18             	add    $0x18,%esp
}
  802952:	90                   	nop
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80295b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80295e:	8d 50 04             	lea    0x4(%eax),%edx
  802961:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	52                   	push   %edx
  80296b:	50                   	push   %eax
  80296c:	6a 20                	push   $0x20
  80296e:	e8 4d fc ff ff       	call   8025c0 <syscall>
  802973:	83 c4 18             	add    $0x18,%esp
	return result;
  802976:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802979:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80297c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80297f:	89 01                	mov    %eax,(%ecx)
  802981:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	c9                   	leave  
  802988:	c2 04 00             	ret    $0x4

0080298b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	ff 75 10             	pushl  0x10(%ebp)
  802995:	ff 75 0c             	pushl  0xc(%ebp)
  802998:	ff 75 08             	pushl  0x8(%ebp)
  80299b:	6a 0f                	push   $0xf
  80299d:	e8 1e fc ff ff       	call   8025c0 <syscall>
  8029a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8029a5:	90                   	nop
}
  8029a6:	c9                   	leave  
  8029a7:	c3                   	ret    

008029a8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	6a 00                	push   $0x0
  8029b1:	6a 00                	push   $0x0
  8029b3:	6a 00                	push   $0x0
  8029b5:	6a 21                	push   $0x21
  8029b7:	e8 04 fc ff ff       	call   8025c0 <syscall>
  8029bc:	83 c4 18             	add    $0x18,%esp
}
  8029bf:	c9                   	leave  
  8029c0:	c3                   	ret    

008029c1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029cd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 00                	push   $0x0
  8029d9:	50                   	push   %eax
  8029da:	6a 22                	push   $0x22
  8029dc:	e8 df fb ff ff       	call   8025c0 <syscall>
  8029e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8029e4:	90                   	nop
}
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <rsttst>:
void rsttst()
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 24                	push   $0x24
  8029f6:	e8 c5 fb ff ff       	call   8025c0 <syscall>
  8029fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8029fe:	90                   	nop
}
  8029ff:	c9                   	leave  
  802a00:	c3                   	ret    

00802a01 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
  802a04:	83 ec 04             	sub    $0x4,%esp
  802a07:	8b 45 14             	mov    0x14(%ebp),%eax
  802a0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a0d:	8b 55 18             	mov    0x18(%ebp),%edx
  802a10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a14:	52                   	push   %edx
  802a15:	50                   	push   %eax
  802a16:	ff 75 10             	pushl  0x10(%ebp)
  802a19:	ff 75 0c             	pushl  0xc(%ebp)
  802a1c:	ff 75 08             	pushl  0x8(%ebp)
  802a1f:	6a 23                	push   $0x23
  802a21:	e8 9a fb ff ff       	call   8025c0 <syscall>
  802a26:	83 c4 18             	add    $0x18,%esp
	return ;
  802a29:	90                   	nop
}
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <chktst>:
void chktst(uint32 n)
{
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	ff 75 08             	pushl  0x8(%ebp)
  802a3a:	6a 25                	push   $0x25
  802a3c:	e8 7f fb ff ff       	call   8025c0 <syscall>
  802a41:	83 c4 18             	add    $0x18,%esp
	return ;
  802a44:	90                   	nop
}
  802a45:	c9                   	leave  
  802a46:	c3                   	ret    

00802a47 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a47:	55                   	push   %ebp
  802a48:	89 e5                	mov    %esp,%ebp
  802a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 00                	push   $0x0
  802a53:	6a 00                	push   $0x0
  802a55:	6a 00                	push   $0x0
  802a57:	6a 26                	push   $0x26
  802a59:	e8 62 fb ff ff       	call   8025c0 <syscall>
  802a5e:	83 c4 18             	add    $0x18,%esp
  802a61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a64:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a68:	75 07                	jne    802a71 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6f:	eb 05                	jmp    802a76 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a76:	c9                   	leave  
  802a77:	c3                   	ret    

00802a78 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a78:	55                   	push   %ebp
  802a79:	89 e5                	mov    %esp,%ebp
  802a7b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 00                	push   $0x0
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	6a 26                	push   $0x26
  802a8a:	e8 31 fb ff ff       	call   8025c0 <syscall>
  802a8f:	83 c4 18             	add    $0x18,%esp
  802a92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a95:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a99:	75 07                	jne    802aa2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a9b:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa0:	eb 05                	jmp    802aa7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802aa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aa7:	c9                   	leave  
  802aa8:	c3                   	ret    

00802aa9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802aa9:	55                   	push   %ebp
  802aaa:	89 e5                	mov    %esp,%ebp
  802aac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aaf:	6a 00                	push   $0x0
  802ab1:	6a 00                	push   $0x0
  802ab3:	6a 00                	push   $0x0
  802ab5:	6a 00                	push   $0x0
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 26                	push   $0x26
  802abb:	e8 00 fb ff ff       	call   8025c0 <syscall>
  802ac0:	83 c4 18             	add    $0x18,%esp
  802ac3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802ac6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802aca:	75 07                	jne    802ad3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802acc:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad1:	eb 05                	jmp    802ad8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad8:	c9                   	leave  
  802ad9:	c3                   	ret    

00802ada <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802ada:	55                   	push   %ebp
  802adb:	89 e5                	mov    %esp,%ebp
  802add:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	6a 00                	push   $0x0
  802ae6:	6a 00                	push   $0x0
  802ae8:	6a 00                	push   $0x0
  802aea:	6a 26                	push   $0x26
  802aec:	e8 cf fa ff ff       	call   8025c0 <syscall>
  802af1:	83 c4 18             	add    $0x18,%esp
  802af4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802af7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802afb:	75 07                	jne    802b04 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802afd:	b8 01 00 00 00       	mov    $0x1,%eax
  802b02:	eb 05                	jmp    802b09 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802b04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b09:	c9                   	leave  
  802b0a:	c3                   	ret    

00802b0b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b0b:	55                   	push   %ebp
  802b0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	6a 00                	push   $0x0
  802b14:	6a 00                	push   $0x0
  802b16:	ff 75 08             	pushl  0x8(%ebp)
  802b19:	6a 27                	push   $0x27
  802b1b:	e8 a0 fa ff ff       	call   8025c0 <syscall>
  802b20:	83 c4 18             	add    $0x18,%esp
	return ;
  802b23:	90                   	nop
}
  802b24:	c9                   	leave  
  802b25:	c3                   	ret    
  802b26:	66 90                	xchg   %ax,%ax

00802b28 <__udivdi3>:
  802b28:	55                   	push   %ebp
  802b29:	57                   	push   %edi
  802b2a:	56                   	push   %esi
  802b2b:	53                   	push   %ebx
  802b2c:	83 ec 1c             	sub    $0x1c,%esp
  802b2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802b33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802b37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b3f:	89 ca                	mov    %ecx,%edx
  802b41:	89 f8                	mov    %edi,%eax
  802b43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802b47:	85 f6                	test   %esi,%esi
  802b49:	75 2d                	jne    802b78 <__udivdi3+0x50>
  802b4b:	39 cf                	cmp    %ecx,%edi
  802b4d:	77 65                	ja     802bb4 <__udivdi3+0x8c>
  802b4f:	89 fd                	mov    %edi,%ebp
  802b51:	85 ff                	test   %edi,%edi
  802b53:	75 0b                	jne    802b60 <__udivdi3+0x38>
  802b55:	b8 01 00 00 00       	mov    $0x1,%eax
  802b5a:	31 d2                	xor    %edx,%edx
  802b5c:	f7 f7                	div    %edi
  802b5e:	89 c5                	mov    %eax,%ebp
  802b60:	31 d2                	xor    %edx,%edx
  802b62:	89 c8                	mov    %ecx,%eax
  802b64:	f7 f5                	div    %ebp
  802b66:	89 c1                	mov    %eax,%ecx
  802b68:	89 d8                	mov    %ebx,%eax
  802b6a:	f7 f5                	div    %ebp
  802b6c:	89 cf                	mov    %ecx,%edi
  802b6e:	89 fa                	mov    %edi,%edx
  802b70:	83 c4 1c             	add    $0x1c,%esp
  802b73:	5b                   	pop    %ebx
  802b74:	5e                   	pop    %esi
  802b75:	5f                   	pop    %edi
  802b76:	5d                   	pop    %ebp
  802b77:	c3                   	ret    
  802b78:	39 ce                	cmp    %ecx,%esi
  802b7a:	77 28                	ja     802ba4 <__udivdi3+0x7c>
  802b7c:	0f bd fe             	bsr    %esi,%edi
  802b7f:	83 f7 1f             	xor    $0x1f,%edi
  802b82:	75 40                	jne    802bc4 <__udivdi3+0x9c>
  802b84:	39 ce                	cmp    %ecx,%esi
  802b86:	72 0a                	jb     802b92 <__udivdi3+0x6a>
  802b88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802b8c:	0f 87 9e 00 00 00    	ja     802c30 <__udivdi3+0x108>
  802b92:	b8 01 00 00 00       	mov    $0x1,%eax
  802b97:	89 fa                	mov    %edi,%edx
  802b99:	83 c4 1c             	add    $0x1c,%esp
  802b9c:	5b                   	pop    %ebx
  802b9d:	5e                   	pop    %esi
  802b9e:	5f                   	pop    %edi
  802b9f:	5d                   	pop    %ebp
  802ba0:	c3                   	ret    
  802ba1:	8d 76 00             	lea    0x0(%esi),%esi
  802ba4:	31 ff                	xor    %edi,%edi
  802ba6:	31 c0                	xor    %eax,%eax
  802ba8:	89 fa                	mov    %edi,%edx
  802baa:	83 c4 1c             	add    $0x1c,%esp
  802bad:	5b                   	pop    %ebx
  802bae:	5e                   	pop    %esi
  802baf:	5f                   	pop    %edi
  802bb0:	5d                   	pop    %ebp
  802bb1:	c3                   	ret    
  802bb2:	66 90                	xchg   %ax,%ax
  802bb4:	89 d8                	mov    %ebx,%eax
  802bb6:	f7 f7                	div    %edi
  802bb8:	31 ff                	xor    %edi,%edi
  802bba:	89 fa                	mov    %edi,%edx
  802bbc:	83 c4 1c             	add    $0x1c,%esp
  802bbf:	5b                   	pop    %ebx
  802bc0:	5e                   	pop    %esi
  802bc1:	5f                   	pop    %edi
  802bc2:	5d                   	pop    %ebp
  802bc3:	c3                   	ret    
  802bc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802bc9:	89 eb                	mov    %ebp,%ebx
  802bcb:	29 fb                	sub    %edi,%ebx
  802bcd:	89 f9                	mov    %edi,%ecx
  802bcf:	d3 e6                	shl    %cl,%esi
  802bd1:	89 c5                	mov    %eax,%ebp
  802bd3:	88 d9                	mov    %bl,%cl
  802bd5:	d3 ed                	shr    %cl,%ebp
  802bd7:	89 e9                	mov    %ebp,%ecx
  802bd9:	09 f1                	or     %esi,%ecx
  802bdb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802bdf:	89 f9                	mov    %edi,%ecx
  802be1:	d3 e0                	shl    %cl,%eax
  802be3:	89 c5                	mov    %eax,%ebp
  802be5:	89 d6                	mov    %edx,%esi
  802be7:	88 d9                	mov    %bl,%cl
  802be9:	d3 ee                	shr    %cl,%esi
  802beb:	89 f9                	mov    %edi,%ecx
  802bed:	d3 e2                	shl    %cl,%edx
  802bef:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bf3:	88 d9                	mov    %bl,%cl
  802bf5:	d3 e8                	shr    %cl,%eax
  802bf7:	09 c2                	or     %eax,%edx
  802bf9:	89 d0                	mov    %edx,%eax
  802bfb:	89 f2                	mov    %esi,%edx
  802bfd:	f7 74 24 0c          	divl   0xc(%esp)
  802c01:	89 d6                	mov    %edx,%esi
  802c03:	89 c3                	mov    %eax,%ebx
  802c05:	f7 e5                	mul    %ebp
  802c07:	39 d6                	cmp    %edx,%esi
  802c09:	72 19                	jb     802c24 <__udivdi3+0xfc>
  802c0b:	74 0b                	je     802c18 <__udivdi3+0xf0>
  802c0d:	89 d8                	mov    %ebx,%eax
  802c0f:	31 ff                	xor    %edi,%edi
  802c11:	e9 58 ff ff ff       	jmp    802b6e <__udivdi3+0x46>
  802c16:	66 90                	xchg   %ax,%ax
  802c18:	8b 54 24 08          	mov    0x8(%esp),%edx
  802c1c:	89 f9                	mov    %edi,%ecx
  802c1e:	d3 e2                	shl    %cl,%edx
  802c20:	39 c2                	cmp    %eax,%edx
  802c22:	73 e9                	jae    802c0d <__udivdi3+0xe5>
  802c24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c27:	31 ff                	xor    %edi,%edi
  802c29:	e9 40 ff ff ff       	jmp    802b6e <__udivdi3+0x46>
  802c2e:	66 90                	xchg   %ax,%ax
  802c30:	31 c0                	xor    %eax,%eax
  802c32:	e9 37 ff ff ff       	jmp    802b6e <__udivdi3+0x46>
  802c37:	90                   	nop

00802c38 <__umoddi3>:
  802c38:	55                   	push   %ebp
  802c39:	57                   	push   %edi
  802c3a:	56                   	push   %esi
  802c3b:	53                   	push   %ebx
  802c3c:	83 ec 1c             	sub    $0x1c,%esp
  802c3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802c43:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c57:	89 f3                	mov    %esi,%ebx
  802c59:	89 fa                	mov    %edi,%edx
  802c5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c5f:	89 34 24             	mov    %esi,(%esp)
  802c62:	85 c0                	test   %eax,%eax
  802c64:	75 1a                	jne    802c80 <__umoddi3+0x48>
  802c66:	39 f7                	cmp    %esi,%edi
  802c68:	0f 86 a2 00 00 00    	jbe    802d10 <__umoddi3+0xd8>
  802c6e:	89 c8                	mov    %ecx,%eax
  802c70:	89 f2                	mov    %esi,%edx
  802c72:	f7 f7                	div    %edi
  802c74:	89 d0                	mov    %edx,%eax
  802c76:	31 d2                	xor    %edx,%edx
  802c78:	83 c4 1c             	add    $0x1c,%esp
  802c7b:	5b                   	pop    %ebx
  802c7c:	5e                   	pop    %esi
  802c7d:	5f                   	pop    %edi
  802c7e:	5d                   	pop    %ebp
  802c7f:	c3                   	ret    
  802c80:	39 f0                	cmp    %esi,%eax
  802c82:	0f 87 ac 00 00 00    	ja     802d34 <__umoddi3+0xfc>
  802c88:	0f bd e8             	bsr    %eax,%ebp
  802c8b:	83 f5 1f             	xor    $0x1f,%ebp
  802c8e:	0f 84 ac 00 00 00    	je     802d40 <__umoddi3+0x108>
  802c94:	bf 20 00 00 00       	mov    $0x20,%edi
  802c99:	29 ef                	sub    %ebp,%edi
  802c9b:	89 fe                	mov    %edi,%esi
  802c9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ca1:	89 e9                	mov    %ebp,%ecx
  802ca3:	d3 e0                	shl    %cl,%eax
  802ca5:	89 d7                	mov    %edx,%edi
  802ca7:	89 f1                	mov    %esi,%ecx
  802ca9:	d3 ef                	shr    %cl,%edi
  802cab:	09 c7                	or     %eax,%edi
  802cad:	89 e9                	mov    %ebp,%ecx
  802caf:	d3 e2                	shl    %cl,%edx
  802cb1:	89 14 24             	mov    %edx,(%esp)
  802cb4:	89 d8                	mov    %ebx,%eax
  802cb6:	d3 e0                	shl    %cl,%eax
  802cb8:	89 c2                	mov    %eax,%edx
  802cba:	8b 44 24 08          	mov    0x8(%esp),%eax
  802cbe:	d3 e0                	shl    %cl,%eax
  802cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cc4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802cc8:	89 f1                	mov    %esi,%ecx
  802cca:	d3 e8                	shr    %cl,%eax
  802ccc:	09 d0                	or     %edx,%eax
  802cce:	d3 eb                	shr    %cl,%ebx
  802cd0:	89 da                	mov    %ebx,%edx
  802cd2:	f7 f7                	div    %edi
  802cd4:	89 d3                	mov    %edx,%ebx
  802cd6:	f7 24 24             	mull   (%esp)
  802cd9:	89 c6                	mov    %eax,%esi
  802cdb:	89 d1                	mov    %edx,%ecx
  802cdd:	39 d3                	cmp    %edx,%ebx
  802cdf:	0f 82 87 00 00 00    	jb     802d6c <__umoddi3+0x134>
  802ce5:	0f 84 91 00 00 00    	je     802d7c <__umoddi3+0x144>
  802ceb:	8b 54 24 04          	mov    0x4(%esp),%edx
  802cef:	29 f2                	sub    %esi,%edx
  802cf1:	19 cb                	sbb    %ecx,%ebx
  802cf3:	89 d8                	mov    %ebx,%eax
  802cf5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802cf9:	d3 e0                	shl    %cl,%eax
  802cfb:	89 e9                	mov    %ebp,%ecx
  802cfd:	d3 ea                	shr    %cl,%edx
  802cff:	09 d0                	or     %edx,%eax
  802d01:	89 e9                	mov    %ebp,%ecx
  802d03:	d3 eb                	shr    %cl,%ebx
  802d05:	89 da                	mov    %ebx,%edx
  802d07:	83 c4 1c             	add    $0x1c,%esp
  802d0a:	5b                   	pop    %ebx
  802d0b:	5e                   	pop    %esi
  802d0c:	5f                   	pop    %edi
  802d0d:	5d                   	pop    %ebp
  802d0e:	c3                   	ret    
  802d0f:	90                   	nop
  802d10:	89 fd                	mov    %edi,%ebp
  802d12:	85 ff                	test   %edi,%edi
  802d14:	75 0b                	jne    802d21 <__umoddi3+0xe9>
  802d16:	b8 01 00 00 00       	mov    $0x1,%eax
  802d1b:	31 d2                	xor    %edx,%edx
  802d1d:	f7 f7                	div    %edi
  802d1f:	89 c5                	mov    %eax,%ebp
  802d21:	89 f0                	mov    %esi,%eax
  802d23:	31 d2                	xor    %edx,%edx
  802d25:	f7 f5                	div    %ebp
  802d27:	89 c8                	mov    %ecx,%eax
  802d29:	f7 f5                	div    %ebp
  802d2b:	89 d0                	mov    %edx,%eax
  802d2d:	e9 44 ff ff ff       	jmp    802c76 <__umoddi3+0x3e>
  802d32:	66 90                	xchg   %ax,%ax
  802d34:	89 c8                	mov    %ecx,%eax
  802d36:	89 f2                	mov    %esi,%edx
  802d38:	83 c4 1c             	add    $0x1c,%esp
  802d3b:	5b                   	pop    %ebx
  802d3c:	5e                   	pop    %esi
  802d3d:	5f                   	pop    %edi
  802d3e:	5d                   	pop    %ebp
  802d3f:	c3                   	ret    
  802d40:	3b 04 24             	cmp    (%esp),%eax
  802d43:	72 06                	jb     802d4b <__umoddi3+0x113>
  802d45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802d49:	77 0f                	ja     802d5a <__umoddi3+0x122>
  802d4b:	89 f2                	mov    %esi,%edx
  802d4d:	29 f9                	sub    %edi,%ecx
  802d4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802d53:	89 14 24             	mov    %edx,(%esp)
  802d56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d5e:	8b 14 24             	mov    (%esp),%edx
  802d61:	83 c4 1c             	add    $0x1c,%esp
  802d64:	5b                   	pop    %ebx
  802d65:	5e                   	pop    %esi
  802d66:	5f                   	pop    %edi
  802d67:	5d                   	pop    %ebp
  802d68:	c3                   	ret    
  802d69:	8d 76 00             	lea    0x0(%esi),%esi
  802d6c:	2b 04 24             	sub    (%esp),%eax
  802d6f:	19 fa                	sbb    %edi,%edx
  802d71:	89 d1                	mov    %edx,%ecx
  802d73:	89 c6                	mov    %eax,%esi
  802d75:	e9 71 ff ff ff       	jmp    802ceb <__umoddi3+0xb3>
  802d7a:	66 90                	xchg   %ax,%ax
  802d7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802d80:	72 ea                	jb     802d6c <__umoddi3+0x134>
  802d82:	89 d9                	mov    %ebx,%ecx
  802d84:	e9 62 ff ff ff       	jmp    802ceb <__umoddi3+0xb3>
