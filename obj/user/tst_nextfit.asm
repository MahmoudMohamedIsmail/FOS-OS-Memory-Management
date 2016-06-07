
obj/user/tst_nextfit:     file format elf32-i386


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
  800031:	e8 b4 0a 00 00       	call   800aea <libmain>
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
  80003d:	81 ec 30 08 00 00    	sub    $0x830,%esp
	int envID = sys_getenvid();
  800043:	e8 2f 25 00 00       	call   802577 <sys_getenvid>
  800048:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	6a 03                	push   $0x3
  800050:	e8 f1 29 00 00       	call   802a46 <sys_set_uheap_strategy>
  800055:	83 c4 10             	add    $0x10,%esp

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800058:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80005b:	89 d0                	mov    %edx,%eax
  80005d:	c1 e0 03             	shl    $0x3,%eax
  800060:	01 d0                	add    %edx,%eax
  800062:	01 c0                	add    %eax,%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80006d:	01 d0                	add    %edx,%eax
  80006f:	c1 e0 03             	shl    $0x3,%eax
  800072:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800077:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int Mega = 1024*1024;
  80007a:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  800081:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  800088:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  80008f:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
	int numOfEmptyWSLocs = 0;
  800096:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  80009d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000a4:	eb 24                	jmp    8000ca <_main+0x92>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8000a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000a9:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8000af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000b2:	89 d0                	mov    %edx,%eax
  8000b4:	01 c0                	add    %eax,%eax
  8000b6:	01 d0                	add    %edx,%eax
  8000b8:	c1 e0 02             	shl    $0x2,%eax
  8000bb:	01 c8                	add    %ecx,%eax
  8000bd:	8a 40 04             	mov    0x4(%eax),%al
  8000c0:	3c 01                	cmp    $0x1,%al
  8000c2:	75 03                	jne    8000c7 <_main+0x8f>
			numOfEmptyWSLocs++;
  8000c4:	ff 45 f0             	incl   -0x10(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  8000c7:	ff 45 f4             	incl   -0xc(%ebp)
  8000ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000cd:	8b 50 74             	mov    0x74(%eax),%edx
  8000d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d3:	39 c2                	cmp    %eax,%edx
  8000d5:	77 cf                	ja     8000a6 <_main+0x6e>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8000d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000da:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8000dd:	7d 14                	jge    8000f3 <_main+0xbb>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 e0 2c 80 00       	push   $0x802ce0
  8000e7:	6a 1f                	push   $0x1f
  8000e9:	68 30 2d 80 00       	push   $0x802d30
  8000ee:	e8 b8 0a 00 00       	call   800bab <_panic>


	void* ptr_allocations[512] = {0};
  8000f3:	8d 95 cc f7 ff ff    	lea    -0x834(%ebp),%edx
  8000f9:	b9 00 02 00 00       	mov    $0x200,%ecx
  8000fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800103:	89 d7                	mov    %edx,%edi
  800105:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  800107:	83 ec 0c             	sub    $0xc,%esp
  80010a:	68 44 2d 80 00       	push   $0x802d44
  80010f:	e8 c2 0b 00 00       	call   800cd6 <cprintf>
  800114:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  800117:	e8 0d 25 00 00       	call   802629 <sys_calculate_free_frames>
  80011c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80011f:	e8 88 25 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800124:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for(i = 0; i< 256;i++)
  800127:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80012e:	eb 20                	jmp    800150 <_main+0x118>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800130:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800133:	01 c0                	add    %eax,%eax
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	50                   	push   %eax
  800139:	e8 1b 19 00 00       	call   801a59 <malloc>
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	89 c2                	mov    %eax,%edx
  800143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800146:	89 94 85 cc f7 ff ff 	mov    %edx,-0x834(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  80014d:	ff 45 ec             	incl   -0x14(%ebp)
  800150:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%ebp)
  800157:	7e d7                	jle    800130 <_main+0xf8>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800159:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  80015f:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800164:	75 5b                	jne    8001c1 <_main+0x189>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800166:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  80016c:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800171:	75 4e                	jne    8001c1 <_main+0x189>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  800173:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800179:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  80017e:	75 41                	jne    8001c1 <_main+0x189>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800180:	8b 85 f4 f7 ff ff    	mov    -0x80c(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  800186:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  80018b:	75 34                	jne    8001c1 <_main+0x189>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  80018d:	8b 85 08 f8 ff ff    	mov    -0x7f8(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800193:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  800198:	75 27                	jne    8001c1 <_main+0x189>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  80019a:	8b 85 1c f8 ff ff    	mov    -0x7e4(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  8001a0:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8001a5:	75 1a                	jne    8001c1 <_main+0x189>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8001a7:	8b 85 30 f8 ff ff    	mov    -0x7d0(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  8001ad:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  8001b2:	75 0d                	jne    8001c1 <_main+0x189>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  8001b4:	8b 85 c8 fb ff ff    	mov    -0x438(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8001ba:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 94 2d 80 00       	push   $0x802d94
  8001c9:	6a 38                	push   $0x38
  8001cb:	68 30 2d 80 00       	push   $0x802d30
  8001d0:	e8 d6 09 00 00       	call   800bab <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8001d5:	e8 d2 24 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8001da:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8001dd:	89 c2                	mov    %eax,%edx
  8001df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e2:	c1 e0 09             	shl    $0x9,%eax
  8001e5:	85 c0                	test   %eax,%eax
  8001e7:	79 05                	jns    8001ee <_main+0x1b6>
  8001e9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8001ee:	c1 f8 0c             	sar    $0xc,%eax
  8001f1:	39 c2                	cmp    %eax,%edx
  8001f3:	74 14                	je     800209 <_main+0x1d1>
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	68 d2 2d 80 00       	push   $0x802dd2
  8001fd:	6a 3a                	push   $0x3a
  8001ff:	68 30 2d 80 00       	push   $0x802d30
  800204:	e8 a2 09 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  800209:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80020c:	e8 18 24 00 00       	call   802629 <sys_calculate_free_frames>
  800211:	29 c3                	sub    %eax,%ebx
  800213:	89 da                	mov    %ebx,%edx
  800215:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800218:	c1 e0 09             	shl    $0x9,%eax
  80021b:	85 c0                	test   %eax,%eax
  80021d:	79 05                	jns    800224 <_main+0x1ec>
  80021f:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  800224:	c1 f8 16             	sar    $0x16,%eax
  800227:	39 c2                	cmp    %eax,%edx
  800229:	74 14                	je     80023f <_main+0x207>
  80022b:	83 ec 04             	sub    $0x4,%esp
  80022e:	68 ef 2d 80 00       	push   $0x802def
  800233:	6a 3b                	push   $0x3b
  800235:	68 30 2d 80 00       	push   $0x802d30
  80023a:	e8 6c 09 00 00       	call   800bab <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80023f:	e8 e5 23 00 00       	call   802629 <sys_calculate_free_frames>
  800244:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800247:	e8 60 24 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  80024c:	89 45 d0             	mov    %eax,-0x30(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80024f:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	50                   	push   %eax
  800259:	e8 9d 21 00 00       	call   8023fb <free>
  80025e:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800261:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	50                   	push   %eax
  80026b:	e8 8b 21 00 00       	call   8023fb <free>
  800270:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  800273:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
  800279:	83 ec 0c             	sub    $0xc,%esp
  80027c:	50                   	push   %eax
  80027d:	e8 79 21 00 00       	call   8023fb <free>
  800282:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  800285:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	50                   	push   %eax
  80028f:	e8 67 21 00 00       	call   8023fb <free>
  800294:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  800297:	8b 85 f4 f7 ff ff    	mov    -0x80c(%ebp),%eax
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	50                   	push   %eax
  8002a1:	e8 55 21 00 00       	call   8023fb <free>
  8002a6:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  8002a9:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8002af:	83 ec 0c             	sub    $0xc,%esp
  8002b2:	50                   	push   %eax
  8002b3:	e8 43 21 00 00       	call   8023fb <free>
  8002b8:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8002bb:	8b 85 f8 f7 ff ff    	mov    -0x808(%ebp),%eax
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	50                   	push   %eax
  8002c5:	e8 31 21 00 00       	call   8023fb <free>
  8002ca:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8002cd:	8b 85 1c f8 ff ff    	mov    -0x7e4(%ebp),%eax
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	50                   	push   %eax
  8002d7:	e8 1f 21 00 00       	call   8023fb <free>
  8002dc:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8002df:	8b 85 30 f8 ff ff    	mov    -0x7d0(%ebp),%eax
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	50                   	push   %eax
  8002e9:	e8 0d 21 00 00       	call   8023fb <free>
  8002ee:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8002f1:	8b 85 c8 fb ff ff    	mov    -0x438(%ebp),%eax
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	50                   	push   %eax
  8002fb:	e8 fb 20 00 00       	call   8023fb <free>
  800300:	83 c4 10             	add    $0x10,%esp




	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800303:	e8 a4 23 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800308:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80030b:	89 d1                	mov    %edx,%ecx
  80030d:	29 c1                	sub    %eax,%ecx
  80030f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800312:	89 d0                	mov    %edx,%eax
  800314:	c1 e0 02             	shl    $0x2,%eax
  800317:	01 d0                	add    %edx,%eax
  800319:	c1 e0 02             	shl    $0x2,%eax
  80031c:	85 c0                	test   %eax,%eax
  80031e:	79 05                	jns    800325 <_main+0x2ed>
  800320:	05 ff 0f 00 00       	add    $0xfff,%eax
  800325:	c1 f8 0c             	sar    $0xc,%eax
  800328:	39 c1                	cmp    %eax,%ecx
  80032a:	74 14                	je     800340 <_main+0x308>
  80032c:	83 ec 04             	sub    $0x4,%esp
  80032f:	68 00 2e 80 00       	push   $0x802e00
  800334:	6a 4f                	push   $0x4f
  800336:	68 30 2d 80 00       	push   $0x802d30
  80033b:	e8 6b 08 00 00       	call   800bab <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800340:	e8 e4 22 00 00       	call   802629 <sys_calculate_free_frames>
  800345:	89 c2                	mov    %eax,%edx
  800347:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034a:	39 c2                	cmp    %eax,%edx
  80034c:	74 14                	je     800362 <_main+0x32a>
  80034e:	83 ec 04             	sub    $0x4,%esp
  800351:	68 3c 2e 80 00       	push   $0x802e3c
  800356:	6a 50                	push   $0x50
  800358:	68 30 2d 80 00       	push   $0x802d30
  80035d:	e8 49 08 00 00       	call   800bab <_panic>



	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800362:	e8 c2 22 00 00       	call   802629 <sys_calculate_free_frames>
  800367:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80036a:	e8 3d 23 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  80036f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  800372:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800375:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800378:	83 ec 0c             	sub    $0xc,%esp
  80037b:	50                   	push   %eax
  80037c:	e8 d8 16 00 00       	call   801a59 <malloc>
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800387:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80038a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80038f:	74 14                	je     8003a5 <_main+0x36d>
		panic("Next Fit not working correctly");
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	68 7c 2e 80 00       	push   $0x802e7c
  800399:	6a 5c                	push   $0x5c
  80039b:	68 30 2d 80 00       	push   $0x802d30
  8003a0:	e8 06 08 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8003a5:	e8 02 23 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8003aa:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ad:	89 c2                	mov    %eax,%edx
  8003af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	79 05                	jns    8003bb <_main+0x383>
  8003b6:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003bb:	c1 f8 0c             	sar    $0xc,%eax
  8003be:	39 c2                	cmp    %eax,%edx
  8003c0:	74 14                	je     8003d6 <_main+0x39e>
  8003c2:	83 ec 04             	sub    $0x4,%esp
  8003c5:	68 d2 2d 80 00       	push   $0x802dd2
  8003ca:	6a 5d                	push   $0x5d
  8003cc:	68 30 2d 80 00       	push   $0x802d30
  8003d1:	e8 d5 07 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8003d6:	e8 4e 22 00 00       	call   802629 <sys_calculate_free_frames>
  8003db:	89 c2                	mov    %eax,%edx
  8003dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e0:	39 c2                	cmp    %eax,%edx
  8003e2:	74 14                	je     8003f8 <_main+0x3c0>
  8003e4:	83 ec 04             	sub    $0x4,%esp
  8003e7:	68 ef 2d 80 00       	push   $0x802def
  8003ec:	6a 5e                	push   $0x5e
  8003ee:	68 30 2d 80 00       	push   $0x802d30
  8003f3:	e8 b3 07 00 00       	call   800bab <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8003f8:	e8 2c 22 00 00       	call   802629 <sys_calculate_free_frames>
  8003fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800400:	e8 a7 22 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800405:	89 45 d0             	mov    %eax,-0x30(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  800408:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040b:	83 ec 0c             	sub    $0xc,%esp
  80040e:	50                   	push   %eax
  80040f:	e8 45 16 00 00       	call   801a59 <malloc>
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if((uint32)tempAddress != 0x80100000)
  80041a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80041d:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800422:	74 14                	je     800438 <_main+0x400>
		panic("Next Fit not working correctly");
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 7c 2e 80 00       	push   $0x802e7c
  80042c:	6a 65                	push   $0x65
  80042e:	68 30 2d 80 00       	push   $0x802d30
  800433:	e8 73 07 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800438:	e8 6f 22 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  80043d:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800440:	89 c2                	mov    %eax,%edx
  800442:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800445:	c1 e0 02             	shl    $0x2,%eax
  800448:	85 c0                	test   %eax,%eax
  80044a:	79 05                	jns    800451 <_main+0x419>
  80044c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800451:	c1 f8 0c             	sar    $0xc,%eax
  800454:	39 c2                	cmp    %eax,%edx
  800456:	74 14                	je     80046c <_main+0x434>
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	68 d2 2d 80 00       	push   $0x802dd2
  800460:	6a 66                	push   $0x66
  800462:	68 30 2d 80 00       	push   $0x802d30
  800467:	e8 3f 07 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80046c:	e8 b8 21 00 00       	call   802629 <sys_calculate_free_frames>
  800471:	89 c2                	mov    %eax,%edx
  800473:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800476:	39 c2                	cmp    %eax,%edx
  800478:	74 14                	je     80048e <_main+0x456>
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	68 ef 2d 80 00       	push   $0x802def
  800482:	6a 67                	push   $0x67
  800484:	68 30 2d 80 00       	push   $0x802d30
  800489:	e8 1d 07 00 00       	call   800bab <_panic>



	freeFrames = sys_calculate_free_frames() ;
  80048e:	e8 96 21 00 00       	call   802629 <sys_calculate_free_frames>
  800493:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800496:	e8 11 22 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  80049b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80049e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a1:	89 d0                	mov    %edx,%eax
  8004a3:	c1 e0 02             	shl    $0x2,%eax
  8004a6:	01 d0                	add    %edx,%eax
  8004a8:	83 ec 0c             	sub    $0xc,%esp
  8004ab:	50                   	push   %eax
  8004ac:	e8 a8 15 00 00       	call   801a59 <malloc>
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if((uint32)tempAddress != 0x81400000)
  8004b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ba:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8004bf:	74 14                	je     8004d5 <_main+0x49d>
		panic("Next Fit not working correctly");
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	68 7c 2e 80 00       	push   $0x802e7c
  8004c9:	6a 6f                	push   $0x6f
  8004cb:	68 30 2d 80 00       	push   $0x802d30
  8004d0:	e8 d6 06 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004d5:	e8 d2 21 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8004da:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8004dd:	89 c1                	mov    %eax,%ecx
  8004df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e2:	89 d0                	mov    %edx,%eax
  8004e4:	c1 e0 02             	shl    $0x2,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	85 c0                	test   %eax,%eax
  8004eb:	79 05                	jns    8004f2 <_main+0x4ba>
  8004ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004f2:	c1 f8 0c             	sar    $0xc,%eax
  8004f5:	39 c1                	cmp    %eax,%ecx
  8004f7:	74 14                	je     80050d <_main+0x4d5>
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	68 d2 2d 80 00       	push   $0x802dd2
  800501:	6a 70                	push   $0x70
  800503:	68 30 2d 80 00       	push   $0x802d30
  800508:	e8 9e 06 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80050d:	e8 17 21 00 00       	call   802629 <sys_calculate_free_frames>
  800512:	89 c2                	mov    %eax,%edx
  800514:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800517:	39 c2                	cmp    %eax,%edx
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 ef 2d 80 00       	push   $0x802def
  800523:	6a 71                	push   $0x71
  800525:	68 30 2d 80 00       	push   $0x802d30
  80052a:	e8 7c 06 00 00       	call   800bab <_panic>



	freeFrames = sys_calculate_free_frames() ;
  80052f:	e8 f5 20 00 00       	call   802629 <sys_calculate_free_frames>
  800534:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800537:	e8 70 21 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  80053c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	tempAddress = malloc(1*Mega);
  80053f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800542:	83 ec 0c             	sub    $0xc,%esp
  800545:	50                   	push   %eax
  800546:	e8 0e 15 00 00       	call   801a59 <malloc>
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	89 45 cc             	mov    %eax,-0x34(%ebp)



	// Use Hole 4 -> Hole 4 = 0 M
	if((uint32)tempAddress != 0x81900000)
  800551:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800554:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  800559:	74 14                	je     80056f <_main+0x537>
		panic("Next Fit not working correctly");
  80055b:	83 ec 04             	sub    $0x4,%esp
  80055e:	68 7c 2e 80 00       	push   $0x802e7c
  800563:	6a 7d                	push   $0x7d
  800565:	68 30 2d 80 00       	push   $0x802d30
  80056a:	e8 3c 06 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80056f:	e8 38 21 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800574:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800577:	89 c2                	mov    %eax,%edx
  800579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057c:	85 c0                	test   %eax,%eax
  80057e:	79 05                	jns    800585 <_main+0x54d>
  800580:	05 ff 0f 00 00       	add    $0xfff,%eax
  800585:	c1 f8 0c             	sar    $0xc,%eax
  800588:	39 c2                	cmp    %eax,%edx
  80058a:	74 14                	je     8005a0 <_main+0x568>
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 d2 2d 80 00       	push   $0x802dd2
  800594:	6a 7e                	push   $0x7e
  800596:	68 30 2d 80 00       	push   $0x802d30
  80059b:	e8 0b 06 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005a0:	e8 84 20 00 00       	call   802629 <sys_calculate_free_frames>
  8005a5:	89 c2                	mov    %eax,%edx
  8005a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005aa:	39 c2                	cmp    %eax,%edx
  8005ac:	74 14                	je     8005c2 <_main+0x58a>
  8005ae:	83 ec 04             	sub    $0x4,%esp
  8005b1:	68 ef 2d 80 00       	push   $0x802def
  8005b6:	6a 7f                	push   $0x7f
  8005b8:	68 30 2d 80 00       	push   $0x802d30
  8005bd:	e8 e9 05 00 00       	call   800bab <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8005c2:	e8 62 20 00 00       	call   802629 <sys_calculate_free_frames>
  8005c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ca:	e8 dd 20 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8005cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8005d2:	8b 85 08 f8 ff ff    	mov    -0x7f8(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 1a 1e 00 00       	call   8023fb <free>
  8005e1:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005e4:	e8 c3 20 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8005e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ec:	29 c2                	sub    %eax,%edx
  8005ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f1:	01 c0                	add    %eax,%eax
  8005f3:	85 c0                	test   %eax,%eax
  8005f5:	79 05                	jns    8005fc <_main+0x5c4>
  8005f7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005fc:	c1 f8 0c             	sar    $0xc,%eax
  8005ff:	39 c2                	cmp    %eax,%edx
  800601:	74 17                	je     80061a <_main+0x5e2>
  800603:	83 ec 04             	sub    $0x4,%esp
  800606:	68 00 2e 80 00       	push   $0x802e00
  80060b:	68 85 00 00 00       	push   $0x85
  800610:	68 30 2d 80 00       	push   $0x802d30
  800615:	e8 91 05 00 00       	call   800bab <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80061a:	e8 0a 20 00 00       	call   802629 <sys_calculate_free_frames>
  80061f:	89 c2                	mov    %eax,%edx
  800621:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800624:	39 c2                	cmp    %eax,%edx
  800626:	74 17                	je     80063f <_main+0x607>
  800628:	83 ec 04             	sub    $0x4,%esp
  80062b:	68 3c 2e 80 00       	push   $0x802e3c
  800630:	68 86 00 00 00       	push   $0x86
  800635:	68 30 2d 80 00       	push   $0x802d30
  80063a:	e8 6c 05 00 00       	call   800bab <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80063f:	e8 e5 1f 00 00       	call   802629 <sys_calculate_free_frames>
  800644:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800647:	e8 60 20 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  80064c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  80064f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	50                   	push   %eax
  800656:	e8 fe 13 00 00       	call   801a59 <malloc>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  800661:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800664:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  800669:	74 17                	je     800682 <_main+0x64a>
		panic("Next Fit not working correctly");
  80066b:	83 ec 04             	sub    $0x4,%esp
  80066e:	68 7c 2e 80 00       	push   $0x802e7c
  800673:	68 8c 00 00 00       	push   $0x8c
  800678:	68 30 2d 80 00       	push   $0x802d30
  80067d:	e8 29 05 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800682:	e8 25 20 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800687:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80068a:	89 c2                	mov    %eax,%edx
  80068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80068f:	c1 e0 02             	shl    $0x2,%eax
  800692:	85 c0                	test   %eax,%eax
  800694:	79 05                	jns    80069b <_main+0x663>
  800696:	05 ff 0f 00 00       	add    $0xfff,%eax
  80069b:	c1 f8 0c             	sar    $0xc,%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 d2 2d 80 00       	push   $0x802dd2
  8006aa:	68 8d 00 00 00       	push   $0x8d
  8006af:	68 30 2d 80 00       	push   $0x802d30
  8006b4:	e8 f2 04 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8006b9:	e8 6b 1f 00 00       	call   802629 <sys_calculate_free_frames>
  8006be:	89 c2                	mov    %eax,%edx
  8006c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006c3:	39 c2                	cmp    %eax,%edx
  8006c5:	74 17                	je     8006de <_main+0x6a6>
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	68 ef 2d 80 00       	push   $0x802def
  8006cf:	68 8e 00 00 00       	push   $0x8e
  8006d4:	68 30 2d 80 00       	push   $0x802d30
  8006d9:	e8 cd 04 00 00       	call   800bab <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8006de:	e8 46 1f 00 00       	call   802629 <sys_calculate_free_frames>
  8006e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e6:	e8 c1 1f 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8006eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  8006ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006f1:	c1 e0 03             	shl    $0x3,%eax
  8006f4:	89 c2                	mov    %eax,%edx
  8006f6:	c1 e2 07             	shl    $0x7,%edx
  8006f9:	29 c2                	sub    %eax,%edx
  8006fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006fe:	01 d0                	add    %edx,%eax
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	50                   	push   %eax
  800704:	e8 50 13 00 00       	call   801a59 <malloc>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  80070f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800712:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  800717:	74 17                	je     800730 <_main+0x6f8>
		panic("Next Fit not working correctly");
  800719:	83 ec 04             	sub    $0x4,%esp
  80071c:	68 7c 2e 80 00       	push   $0x802e7c
  800721:	68 94 00 00 00       	push   $0x94
  800726:	68 30 2d 80 00       	push   $0x802d30
  80072b:	e8 7b 04 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800730:	e8 77 1f 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800735:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800738:	89 c2                	mov    %eax,%edx
  80073a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80073d:	c1 e0 03             	shl    $0x3,%eax
  800740:	89 c1                	mov    %eax,%ecx
  800742:	c1 e1 07             	shl    $0x7,%ecx
  800745:	29 c1                	sub    %eax,%ecx
  800747:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80074a:	01 c8                	add    %ecx,%eax
  80074c:	85 c0                	test   %eax,%eax
  80074e:	79 05                	jns    800755 <_main+0x71d>
  800750:	05 ff 0f 00 00       	add    $0xfff,%eax
  800755:	c1 f8 0c             	sar    $0xc,%eax
  800758:	39 c2                	cmp    %eax,%edx
  80075a:	74 17                	je     800773 <_main+0x73b>
  80075c:	83 ec 04             	sub    $0x4,%esp
  80075f:	68 d2 2d 80 00       	push   $0x802dd2
  800764:	68 95 00 00 00       	push   $0x95
  800769:	68 30 2d 80 00       	push   $0x802d30
  80076e:	e8 38 04 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800773:	e8 b1 1e 00 00       	call   802629 <sys_calculate_free_frames>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 ef 2d 80 00       	push   $0x802def
  800789:	68 96 00 00 00       	push   $0x96
  80078e:	68 30 2d 80 00       	push   $0x802d30
  800793:	e8 13 04 00 00       	call   800bab <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800798:	e8 8c 1e 00 00       	call   802629 <sys_calculate_free_frames>
  80079d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a0:	e8 07 1f 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8007a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  8007a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ab:	c1 e0 09             	shl    $0x9,%eax
  8007ae:	83 ec 0c             	sub    $0xc,%esp
  8007b1:	50                   	push   %eax
  8007b2:	e8 a2 12 00 00       	call   801a59 <malloc>
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if((uint32)tempAddress != 0x82800000)
  8007bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007c0:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8007c5:	74 17                	je     8007de <_main+0x7a6>
		panic("Next Fit not working correctly");
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 7c 2e 80 00       	push   $0x802e7c
  8007cf:	68 9c 00 00 00       	push   $0x9c
  8007d4:	68 30 2d 80 00       	push   $0x802d30
  8007d9:	e8 cd 03 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007de:	e8 c9 1e 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8007e3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8007e6:	89 c2                	mov    %eax,%edx
  8007e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007eb:	c1 e0 09             	shl    $0x9,%eax
  8007ee:	85 c0                	test   %eax,%eax
  8007f0:	79 05                	jns    8007f7 <_main+0x7bf>
  8007f2:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f7:	c1 f8 0c             	sar    $0xc,%eax
  8007fa:	39 c2                	cmp    %eax,%edx
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 d2 2d 80 00       	push   $0x802dd2
  800806:	68 9d 00 00 00       	push   $0x9d
  80080b:	68 30 2d 80 00       	push   $0x802d30
  800810:	e8 96 03 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800815:	e8 0f 1e 00 00       	call   802629 <sys_calculate_free_frames>
  80081a:	89 c2                	mov    %eax,%edx
  80081c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80081f:	39 c2                	cmp    %eax,%edx
  800821:	74 17                	je     80083a <_main+0x802>
  800823:	83 ec 04             	sub    $0x4,%esp
  800826:	68 ef 2d 80 00       	push   $0x802def
  80082b:	68 9e 00 00 00       	push   $0x9e
  800830:	68 30 2d 80 00       	push   $0x802d30
  800835:	e8 71 03 00 00       	call   800bab <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80083a:	83 ec 0c             	sub    $0xc,%esp
  80083d:	68 9c 2e 80 00       	push   $0x802e9c
  800842:	e8 8f 04 00 00       	call   800cd6 <cprintf>
  800847:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80084a:	e8 da 1d 00 00       	call   802629 <sys_calculate_free_frames>
  80084f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800852:	e8 55 1e 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800857:	89 45 d0             	mov    %eax,-0x30(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  80085a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80085d:	89 c2                	mov    %eax,%edx
  80085f:	01 d2                	add    %edx,%edx
  800861:	01 c2                	add    %eax,%edx
  800863:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800866:	c1 e0 09             	shl    $0x9,%eax
  800869:	01 d0                	add    %edx,%eax
  80086b:	83 ec 0c             	sub    $0xc,%esp
  80086e:	50                   	push   %eax
  80086f:	e8 e5 11 00 00       	call   801a59 <malloc>
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80087a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80087d:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800882:	74 17                	je     80089b <_main+0x863>
		panic("Next Fit not working correctly");
  800884:	83 ec 04             	sub    $0x4,%esp
  800887:	68 7c 2e 80 00       	push   $0x802e7c
  80088c:	68 a7 00 00 00       	push   $0xa7
  800891:	68 30 2d 80 00       	push   $0x802d30
  800896:	e8 10 03 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80089b:	e8 0c 1e 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8008a0:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8008a3:	89 c2                	mov    %eax,%edx
  8008a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a8:	89 c1                	mov    %eax,%ecx
  8008aa:	01 c9                	add    %ecx,%ecx
  8008ac:	01 c1                	add    %eax,%ecx
  8008ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b1:	c1 e0 09             	shl    $0x9,%eax
  8008b4:	01 c8                	add    %ecx,%eax
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	79 05                	jns    8008bf <_main+0x887>
  8008ba:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008bf:	c1 f8 0c             	sar    $0xc,%eax
  8008c2:	39 c2                	cmp    %eax,%edx
  8008c4:	74 17                	je     8008dd <_main+0x8a5>
  8008c6:	83 ec 04             	sub    $0x4,%esp
  8008c9:	68 d2 2d 80 00       	push   $0x802dd2
  8008ce:	68 a8 00 00 00       	push   $0xa8
  8008d3:	68 30 2d 80 00       	push   $0x802d30
  8008d8:	e8 ce 02 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008dd:	e8 47 1d 00 00       	call   802629 <sys_calculate_free_frames>
  8008e2:	89 c2                	mov    %eax,%edx
  8008e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008e7:	39 c2                	cmp    %eax,%edx
  8008e9:	74 17                	je     800902 <_main+0x8ca>
  8008eb:	83 ec 04             	sub    $0x4,%esp
  8008ee:	68 ef 2d 80 00       	push   $0x802def
  8008f3:	68 a9 00 00 00       	push   $0xa9
  8008f8:	68 30 2d 80 00       	push   $0x802d30
  8008fd:	e8 a9 02 00 00       	call   800bab <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800902:	e8 22 1d 00 00       	call   802629 <sys_calculate_free_frames>
  800907:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090a:	e8 9d 1d 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  80090f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800912:	8b 85 2c f8 ff ff    	mov    -0x7d4(%ebp),%eax
  800918:	83 ec 0c             	sub    $0xc,%esp
  80091b:	50                   	push   %eax
  80091c:	e8 da 1a 00 00       	call   8023fb <free>
  800921:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800924:	e8 83 1d 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800929:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80092c:	29 c2                	sub    %eax,%edx
  80092e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800931:	01 c0                	add    %eax,%eax
  800933:	85 c0                	test   %eax,%eax
  800935:	79 05                	jns    80093c <_main+0x904>
  800937:	05 ff 0f 00 00       	add    $0xfff,%eax
  80093c:	c1 f8 0c             	sar    $0xc,%eax
  80093f:	39 c2                	cmp    %eax,%edx
  800941:	74 17                	je     80095a <_main+0x922>
  800943:	83 ec 04             	sub    $0x4,%esp
  800946:	68 00 2e 80 00       	push   $0x802e00
  80094b:	68 af 00 00 00       	push   $0xaf
  800950:	68 30 2d 80 00       	push   $0x802d30
  800955:	e8 51 02 00 00       	call   800bab <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80095a:	e8 ca 1c 00 00       	call   802629 <sys_calculate_free_frames>
  80095f:	89 c2                	mov    %eax,%edx
  800961:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800964:	39 c2                	cmp    %eax,%edx
  800966:	74 17                	je     80097f <_main+0x947>
  800968:	83 ec 04             	sub    $0x4,%esp
  80096b:	68 3c 2e 80 00       	push   $0x802e3c
  800970:	68 b0 00 00 00       	push   $0xb0
  800975:	68 30 2d 80 00       	push   $0x802d30
  80097a:	e8 2c 02 00 00       	call   800bab <_panic>


	freeFrames = sys_calculate_free_frames() ;
  80097f:	e8 a5 1c 00 00       	call   802629 <sys_calculate_free_frames>
  800984:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800987:	e8 20 1d 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  80098c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  80098f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800992:	c1 e0 02             	shl    $0x2,%eax
  800995:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800998:	83 ec 0c             	sub    $0xc,%esp
  80099b:	50                   	push   %eax
  80099c:	e8 b8 10 00 00       	call   801a59 <malloc>
  8009a1:	83 c4 10             	add    $0x10,%esp
  8009a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if((uint32)tempAddress != 0x83000000)
  8009a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009aa:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  8009af:	74 17                	je     8009c8 <_main+0x990>
		panic("Next Fit not working correctly");
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	68 7c 2e 80 00       	push   $0x802e7c
  8009b9:	68 b7 00 00 00       	push   $0xb7
  8009be:	68 30 2d 80 00       	push   $0x802d30
  8009c3:	e8 e3 01 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8009c8:	e8 df 1c 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  8009cd:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8009d0:	89 c2                	mov    %eax,%edx
  8009d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d5:	c1 e0 02             	shl    $0x2,%eax
  8009d8:	85 c0                	test   %eax,%eax
  8009da:	79 05                	jns    8009e1 <_main+0x9a9>
  8009dc:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009e1:	c1 f8 0c             	sar    $0xc,%eax
  8009e4:	39 c2                	cmp    %eax,%edx
  8009e6:	74 17                	je     8009ff <_main+0x9c7>
  8009e8:	83 ec 04             	sub    $0x4,%esp
  8009eb:	68 d2 2d 80 00       	push   $0x802dd2
  8009f0:	68 b8 00 00 00       	push   $0xb8
  8009f5:	68 30 2d 80 00       	push   $0x802d30
  8009fa:	e8 ac 01 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009ff:	e8 25 1c 00 00       	call   802629 <sys_calculate_free_frames>
  800a04:	89 c2                	mov    %eax,%edx
  800a06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a09:	39 c2                	cmp    %eax,%edx
  800a0b:	74 17                	je     800a24 <_main+0x9ec>
  800a0d:	83 ec 04             	sub    $0x4,%esp
  800a10:	68 ef 2d 80 00       	push   $0x802def
  800a15:	68 b9 00 00 00       	push   $0xb9
  800a1a:	68 30 2d 80 00       	push   $0x802d30
  800a1f:	e8 87 01 00 00       	call   800bab <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800a24:	83 ec 0c             	sub    $0xc,%esp
  800a27:	68 d8 2e 80 00       	push   $0x802ed8
  800a2c:	e8 a5 02 00 00       	call   800cd6 <cprintf>
  800a31:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800a34:	e8 f0 1b 00 00       	call   802629 <sys_calculate_free_frames>
  800a39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a3c:	e8 6b 1c 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800a41:	89 45 d0             	mov    %eax,-0x30(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800a44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a47:	89 d0                	mov    %edx,%eax
  800a49:	01 c0                	add    %eax,%eax
  800a4b:	01 d0                	add    %edx,%eax
  800a4d:	01 c0                	add    %eax,%eax
  800a4f:	83 ec 0c             	sub    $0xc,%esp
  800a52:	50                   	push   %eax
  800a53:	e8 01 10 00 00       	call   801a59 <malloc>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if((uint32)tempAddress != 0x0)
  800a5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a61:	85 c0                	test   %eax,%eax
  800a63:	74 17                	je     800a7c <_main+0xa44>
		panic("Next Fit not working correctly");
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	68 7c 2e 80 00       	push   $0x802e7c
  800a6d:	68 c2 00 00 00       	push   $0xc2
  800a72:	68 30 2d 80 00       	push   $0x802d30
  800a77:	e8 2f 01 00 00       	call   800bab <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800a7c:	e8 2b 1c 00 00       	call   8026ac <sys_pf_calculate_allocated_pages>
  800a81:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800a84:	74 17                	je     800a9d <_main+0xa65>
  800a86:	83 ec 04             	sub    $0x4,%esp
  800a89:	68 d2 2d 80 00       	push   $0x802dd2
  800a8e:	68 c3 00 00 00       	push   $0xc3
  800a93:	68 30 2d 80 00       	push   $0x802d30
  800a98:	e8 0e 01 00 00       	call   800bab <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a9d:	e8 87 1b 00 00       	call   802629 <sys_calculate_free_frames>
  800aa2:	89 c2                	mov    %eax,%edx
  800aa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800aa7:	39 c2                	cmp    %eax,%edx
  800aa9:	74 17                	je     800ac2 <_main+0xa8a>
  800aab:	83 ec 04             	sub    $0x4,%esp
  800aae:	68 ef 2d 80 00       	push   $0x802def
  800ab3:	68 c4 00 00 00       	push   $0xc4
  800ab8:	68 30 2d 80 00       	push   $0x802d30
  800abd:	e8 e9 00 00 00       	call   800bab <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800ac2:	83 ec 0c             	sub    $0xc,%esp
  800ac5:	68 10 2f 80 00       	push   $0x802f10
  800aca:	e8 07 02 00 00       	call   800cd6 <cprintf>
  800acf:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800ad2:	83 ec 0c             	sub    $0xc,%esp
  800ad5:	68 4c 2f 80 00       	push   $0x802f4c
  800ada:	e8 f7 01 00 00       	call   800cd6 <cprintf>
  800adf:	83 c4 10             	add    $0x10,%esp

	return;
  800ae2:	90                   	nop
}
  800ae3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae6:	5b                   	pop    %ebx
  800ae7:	5f                   	pop    %edi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800af0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800af4:	7e 0a                	jle    800b00 <libmain+0x16>
		binaryname = argv[0];
  800af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af9:	8b 00                	mov    (%eax),%eax
  800afb:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 2a f5 ff ff       	call   800038 <_main>
  800b0e:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800b11:	e8 61 1a 00 00       	call   802577 <sys_getenvid>
  800b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1c:	89 d0                	mov    %edx,%eax
  800b1e:	c1 e0 03             	shl    $0x3,%eax
  800b21:	01 d0                	add    %edx,%eax
  800b23:	01 c0                	add    %eax,%eax
  800b25:	01 d0                	add    %edx,%eax
  800b27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2e:	01 d0                	add    %edx,%eax
  800b30:	c1 e0 03             	shl    $0x3,%eax
  800b33:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b38:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800b3b:	e8 85 1b 00 00       	call   8026c5 <sys_disable_interrupt>
		cprintf("**************************************\n");
  800b40:	83 ec 0c             	sub    $0xc,%esp
  800b43:	68 a0 2f 80 00       	push   $0x802fa0
  800b48:	e8 89 01 00 00       	call   800cd6 <cprintf>
  800b4d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b53:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	50                   	push   %eax
  800b5d:	68 c8 2f 80 00       	push   $0x802fc8
  800b62:	e8 6f 01 00 00       	call   800cd6 <cprintf>
  800b67:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b6a:	83 ec 0c             	sub    $0xc,%esp
  800b6d:	68 a0 2f 80 00       	push   $0x802fa0
  800b72:	e8 5f 01 00 00       	call   800cd6 <cprintf>
  800b77:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800b7a:	e8 60 1b 00 00       	call   8026df <sys_enable_interrupt>

	// exit gracefully
	exit();
  800b7f:	e8 19 00 00 00       	call   800b9d <exit>
}
  800b84:	90                   	nop
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800b8d:	83 ec 0c             	sub    $0xc,%esp
  800b90:	6a 00                	push   $0x0
  800b92:	e8 c5 19 00 00       	call   80255c <sys_env_destroy>
  800b97:	83 c4 10             	add    $0x10,%esp
}
  800b9a:	90                   	nop
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    

00800b9d <exit>:

void
exit(void)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800ba3:	e8 e8 19 00 00       	call   802590 <sys_env_exit>
}
  800ba8:	90                   	nop
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb1:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb4:	83 c0 04             	add    $0x4,%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800bba:	a1 50 40 98 00       	mov    0x984050,%eax
  800bbf:	85 c0                	test   %eax,%eax
  800bc1:	74 16                	je     800bd9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800bc3:	a1 50 40 98 00       	mov    0x984050,%eax
  800bc8:	83 ec 08             	sub    $0x8,%esp
  800bcb:	50                   	push   %eax
  800bcc:	68 e1 2f 80 00       	push   $0x802fe1
  800bd1:	e8 00 01 00 00       	call   800cd6 <cprintf>
  800bd6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800bd9:	a1 00 40 80 00       	mov    0x804000,%eax
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	ff 75 08             	pushl  0x8(%ebp)
  800be4:	50                   	push   %eax
  800be5:	68 e6 2f 80 00       	push   $0x802fe6
  800bea:	e8 e7 00 00 00       	call   800cd6 <cprintf>
  800bef:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800bf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	e8 7a 00 00 00       	call   800c7b <vcprintf>
  800c01:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800c04:	83 ec 0c             	sub    $0xc,%esp
  800c07:	68 02 30 80 00       	push   $0x803002
  800c0c:	e8 c5 00 00 00       	call   800cd6 <cprintf>
  800c11:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800c14:	e8 84 ff ff ff       	call   800b9d <exit>

	// should not return here
	while (1) ;
  800c19:	eb fe                	jmp    800c19 <_panic+0x6e>

00800c1b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	8d 48 01             	lea    0x1(%eax),%ecx
  800c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2c:	89 0a                	mov    %ecx,(%edx)
  800c2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c31:	88 d1                	mov    %dl,%cl
  800c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c36:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	8b 00                	mov    (%eax),%eax
  800c3f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c44:	75 23                	jne    800c69 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	8b 00                	mov    (%eax),%eax
  800c4b:	89 c2                	mov    %eax,%edx
  800c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c50:	83 c0 08             	add    $0x8,%eax
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	52                   	push   %edx
  800c57:	50                   	push   %eax
  800c58:	e8 c9 18 00 00       	call   802526 <sys_cputs>
  800c5d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	8b 40 04             	mov    0x4(%eax),%eax
  800c6f:	8d 50 01             	lea    0x1(%eax),%edx
  800c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c75:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c78:	90                   	nop
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c84:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c8b:	00 00 00 
	b.cnt = 0;
  800c8e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c95:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	ff 75 08             	pushl  0x8(%ebp)
  800c9e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ca4:	50                   	push   %eax
  800ca5:	68 1b 0c 80 00       	push   $0x800c1b
  800caa:	e8 fa 01 00 00       	call   800ea9 <vprintfmt>
  800caf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800cb2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800cb8:	83 ec 08             	sub    $0x8,%esp
  800cbb:	50                   	push   %eax
  800cbc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cc2:	83 c0 08             	add    $0x8,%eax
  800cc5:	50                   	push   %eax
  800cc6:	e8 5b 18 00 00       	call   802526 <sys_cputs>
  800ccb:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800cce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cd4:	c9                   	leave  
  800cd5:	c3                   	ret    

00800cd6 <cprintf>:

int cprintf(const char *fmt, ...) {
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800cdc:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	83 ec 08             	sub    $0x8,%esp
  800ce8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ceb:	50                   	push   %eax
  800cec:	e8 8a ff ff ff       	call   800c7b <vcprintf>
  800cf1:	83 c4 10             	add    $0x10,%esp
  800cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d02:	e8 be 19 00 00       	call   8026c5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d07:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	ff 75 f4             	pushl  -0xc(%ebp)
  800d16:	50                   	push   %eax
  800d17:	e8 5f ff ff ff       	call   800c7b <vcprintf>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d22:	e8 b8 19 00 00       	call   8026df <sys_enable_interrupt>
	return cnt;
  800d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 14             	sub    $0x14,%esp
  800d33:	8b 45 10             	mov    0x10(%ebp),%eax
  800d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d39:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d3f:	8b 45 18             	mov    0x18(%ebp),%eax
  800d42:	ba 00 00 00 00       	mov    $0x0,%edx
  800d47:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d4a:	77 55                	ja     800da1 <printnum+0x75>
  800d4c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d4f:	72 05                	jb     800d56 <printnum+0x2a>
  800d51:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d54:	77 4b                	ja     800da1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d56:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d59:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d5c:	8b 45 18             	mov    0x18(%ebp),%eax
  800d5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d64:	52                   	push   %edx
  800d65:	50                   	push   %eax
  800d66:	ff 75 f4             	pushl  -0xc(%ebp)
  800d69:	ff 75 f0             	pushl  -0x10(%ebp)
  800d6c:	e8 f3 1c 00 00       	call   802a64 <__udivdi3>
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	83 ec 04             	sub    $0x4,%esp
  800d77:	ff 75 20             	pushl  0x20(%ebp)
  800d7a:	53                   	push   %ebx
  800d7b:	ff 75 18             	pushl  0x18(%ebp)
  800d7e:	52                   	push   %edx
  800d7f:	50                   	push   %eax
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	ff 75 08             	pushl  0x8(%ebp)
  800d86:	e8 a1 ff ff ff       	call   800d2c <printnum>
  800d8b:	83 c4 20             	add    $0x20,%esp
  800d8e:	eb 1a                	jmp    800daa <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d90:	83 ec 08             	sub    $0x8,%esp
  800d93:	ff 75 0c             	pushl  0xc(%ebp)
  800d96:	ff 75 20             	pushl  0x20(%ebp)
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	ff d0                	call   *%eax
  800d9e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800da1:	ff 4d 1c             	decl   0x1c(%ebp)
  800da4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800da8:	7f e6                	jg     800d90 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800daa:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db8:	53                   	push   %ebx
  800db9:	51                   	push   %ecx
  800dba:	52                   	push   %edx
  800dbb:	50                   	push   %eax
  800dbc:	e8 b3 1d 00 00       	call   802b74 <__umoddi3>
  800dc1:	83 c4 10             	add    $0x10,%esp
  800dc4:	05 34 32 80 00       	add    $0x803234,%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	0f be c0             	movsbl %al,%eax
  800dce:	83 ec 08             	sub    $0x8,%esp
  800dd1:	ff 75 0c             	pushl  0xc(%ebp)
  800dd4:	50                   	push   %eax
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	ff d0                	call   *%eax
  800dda:	83 c4 10             	add    $0x10,%esp
}
  800ddd:	90                   	nop
  800dde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800de6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dea:	7e 1c                	jle    800e08 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	8d 50 08             	lea    0x8(%eax),%edx
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	89 10                	mov    %edx,(%eax)
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8b 00                	mov    (%eax),%eax
  800dfe:	83 e8 08             	sub    $0x8,%eax
  800e01:	8b 50 04             	mov    0x4(%eax),%edx
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	eb 40                	jmp    800e48 <getuint+0x65>
	else if (lflag)
  800e08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0c:	74 1e                	je     800e2c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	8d 50 04             	lea    0x4(%eax),%edx
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 10                	mov    %edx,(%eax)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8b 00                	mov    (%eax),%eax
  800e20:	83 e8 04             	sub    $0x4,%eax
  800e23:	8b 00                	mov    (%eax),%eax
  800e25:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2a:	eb 1c                	jmp    800e48 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	8d 50 04             	lea    0x4(%eax),%edx
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	89 10                	mov    %edx,(%eax)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	83 e8 04             	sub    $0x4,%eax
  800e41:	8b 00                	mov    (%eax),%eax
  800e43:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    

00800e4a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e4d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e51:	7e 1c                	jle    800e6f <getint+0x25>
		return va_arg(*ap, long long);
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8b 00                	mov    (%eax),%eax
  800e58:	8d 50 08             	lea    0x8(%eax),%edx
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	89 10                	mov    %edx,(%eax)
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8b 00                	mov    (%eax),%eax
  800e65:	83 e8 08             	sub    $0x8,%eax
  800e68:	8b 50 04             	mov    0x4(%eax),%edx
  800e6b:	8b 00                	mov    (%eax),%eax
  800e6d:	eb 38                	jmp    800ea7 <getint+0x5d>
	else if (lflag)
  800e6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e73:	74 1a                	je     800e8f <getint+0x45>
		return va_arg(*ap, long);
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8b 00                	mov    (%eax),%eax
  800e7a:	8d 50 04             	lea    0x4(%eax),%edx
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 10                	mov    %edx,(%eax)
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	83 e8 04             	sub    $0x4,%eax
  800e8a:	8b 00                	mov    (%eax),%eax
  800e8c:	99                   	cltd   
  800e8d:	eb 18                	jmp    800ea7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8b 00                	mov    (%eax),%eax
  800e94:	8d 50 04             	lea    0x4(%eax),%edx
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	89 10                	mov    %edx,(%eax)
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8b 00                	mov    (%eax),%eax
  800ea1:	83 e8 04             	sub    $0x4,%eax
  800ea4:	8b 00                	mov    (%eax),%eax
  800ea6:	99                   	cltd   
}
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
  800eae:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eb1:	eb 17                	jmp    800eca <vprintfmt+0x21>
			if (ch == '\0')
  800eb3:	85 db                	test   %ebx,%ebx
  800eb5:	0f 84 af 03 00 00    	je     80126a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ebb:	83 ec 08             	sub    $0x8,%esp
  800ebe:	ff 75 0c             	pushl  0xc(%ebp)
  800ec1:	53                   	push   %ebx
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	ff d0                	call   *%eax
  800ec7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecd:	8d 50 01             	lea    0x1(%eax),%edx
  800ed0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	0f b6 d8             	movzbl %al,%ebx
  800ed8:	83 fb 25             	cmp    $0x25,%ebx
  800edb:	75 d6                	jne    800eb3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800edd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ee1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ee8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800eef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ef6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800efd:	8b 45 10             	mov    0x10(%ebp),%eax
  800f00:	8d 50 01             	lea    0x1(%eax),%edx
  800f03:	89 55 10             	mov    %edx,0x10(%ebp)
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	0f b6 d8             	movzbl %al,%ebx
  800f0b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f0e:	83 f8 55             	cmp    $0x55,%eax
  800f11:	0f 87 2b 03 00 00    	ja     801242 <vprintfmt+0x399>
  800f17:	8b 04 85 58 32 80 00 	mov    0x803258(,%eax,4),%eax
  800f1e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f20:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f24:	eb d7                	jmp    800efd <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f26:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f2a:	eb d1                	jmp    800efd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f2c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f36:	89 d0                	mov    %edx,%eax
  800f38:	c1 e0 02             	shl    $0x2,%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	01 c0                	add    %eax,%eax
  800f3f:	01 d8                	add    %ebx,%eax
  800f41:	83 e8 30             	sub    $0x30,%eax
  800f44:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f4f:	83 fb 2f             	cmp    $0x2f,%ebx
  800f52:	7e 3e                	jle    800f92 <vprintfmt+0xe9>
  800f54:	83 fb 39             	cmp    $0x39,%ebx
  800f57:	7f 39                	jg     800f92 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f59:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f5c:	eb d5                	jmp    800f33 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f61:	83 c0 04             	add    $0x4,%eax
  800f64:	89 45 14             	mov    %eax,0x14(%ebp)
  800f67:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6a:	83 e8 04             	sub    $0x4,%eax
  800f6d:	8b 00                	mov    (%eax),%eax
  800f6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f72:	eb 1f                	jmp    800f93 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f78:	79 83                	jns    800efd <vprintfmt+0x54>
				width = 0;
  800f7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f81:	e9 77 ff ff ff       	jmp    800efd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f86:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f8d:	e9 6b ff ff ff       	jmp    800efd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f92:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f97:	0f 89 60 ff ff ff    	jns    800efd <vprintfmt+0x54>
				width = precision, precision = -1;
  800f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fa3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800faa:	e9 4e ff ff ff       	jmp    800efd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800faf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fb2:	e9 46 ff ff ff       	jmp    800efd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fba:	83 c0 04             	add    $0x4,%eax
  800fbd:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc3:	83 e8 04             	sub    $0x4,%eax
  800fc6:	8b 00                	mov    (%eax),%eax
  800fc8:	83 ec 08             	sub    $0x8,%esp
  800fcb:	ff 75 0c             	pushl  0xc(%ebp)
  800fce:	50                   	push   %eax
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	ff d0                	call   *%eax
  800fd4:	83 c4 10             	add    $0x10,%esp
			break;
  800fd7:	e9 89 02 00 00       	jmp    801265 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdf:	83 c0 04             	add    $0x4,%eax
  800fe2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fe5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe8:	83 e8 04             	sub    $0x4,%eax
  800feb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800fed:	85 db                	test   %ebx,%ebx
  800fef:	79 02                	jns    800ff3 <vprintfmt+0x14a>
				err = -err;
  800ff1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ff3:	83 fb 64             	cmp    $0x64,%ebx
  800ff6:	7f 0b                	jg     801003 <vprintfmt+0x15a>
  800ff8:	8b 34 9d a0 30 80 00 	mov    0x8030a0(,%ebx,4),%esi
  800fff:	85 f6                	test   %esi,%esi
  801001:	75 19                	jne    80101c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801003:	53                   	push   %ebx
  801004:	68 45 32 80 00       	push   $0x803245
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	ff 75 08             	pushl  0x8(%ebp)
  80100f:	e8 5e 02 00 00       	call   801272 <printfmt>
  801014:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801017:	e9 49 02 00 00       	jmp    801265 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80101c:	56                   	push   %esi
  80101d:	68 4e 32 80 00       	push   $0x80324e
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 08             	pushl  0x8(%ebp)
  801028:	e8 45 02 00 00       	call   801272 <printfmt>
  80102d:	83 c4 10             	add    $0x10,%esp
			break;
  801030:	e9 30 02 00 00       	jmp    801265 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	83 c0 04             	add    $0x4,%eax
  80103b:	89 45 14             	mov    %eax,0x14(%ebp)
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	83 e8 04             	sub    $0x4,%eax
  801044:	8b 30                	mov    (%eax),%esi
  801046:	85 f6                	test   %esi,%esi
  801048:	75 05                	jne    80104f <vprintfmt+0x1a6>
				p = "(null)";
  80104a:	be 51 32 80 00       	mov    $0x803251,%esi
			if (width > 0 && padc != '-')
  80104f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801053:	7e 6d                	jle    8010c2 <vprintfmt+0x219>
  801055:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801059:	74 67                	je     8010c2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80105b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80105e:	83 ec 08             	sub    $0x8,%esp
  801061:	50                   	push   %eax
  801062:	56                   	push   %esi
  801063:	e8 0c 03 00 00       	call   801374 <strnlen>
  801068:	83 c4 10             	add    $0x10,%esp
  80106b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80106e:	eb 16                	jmp    801086 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801070:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	ff 75 0c             	pushl  0xc(%ebp)
  80107a:	50                   	push   %eax
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	ff d0                	call   *%eax
  801080:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801083:	ff 4d e4             	decl   -0x1c(%ebp)
  801086:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80108a:	7f e4                	jg     801070 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80108c:	eb 34                	jmp    8010c2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80108e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801092:	74 1c                	je     8010b0 <vprintfmt+0x207>
  801094:	83 fb 1f             	cmp    $0x1f,%ebx
  801097:	7e 05                	jle    80109e <vprintfmt+0x1f5>
  801099:	83 fb 7e             	cmp    $0x7e,%ebx
  80109c:	7e 12                	jle    8010b0 <vprintfmt+0x207>
					putch('?', putdat);
  80109e:	83 ec 08             	sub    $0x8,%esp
  8010a1:	ff 75 0c             	pushl  0xc(%ebp)
  8010a4:	6a 3f                	push   $0x3f
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	ff d0                	call   *%eax
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	eb 0f                	jmp    8010bf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	ff 75 0c             	pushl  0xc(%ebp)
  8010b6:	53                   	push   %ebx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	ff d0                	call   *%eax
  8010bc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8010c2:	89 f0                	mov    %esi,%eax
  8010c4:	8d 70 01             	lea    0x1(%eax),%esi
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	0f be d8             	movsbl %al,%ebx
  8010cc:	85 db                	test   %ebx,%ebx
  8010ce:	74 24                	je     8010f4 <vprintfmt+0x24b>
  8010d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010d4:	78 b8                	js     80108e <vprintfmt+0x1e5>
  8010d6:	ff 4d e0             	decl   -0x20(%ebp)
  8010d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010dd:	79 af                	jns    80108e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010df:	eb 13                	jmp    8010f4 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010e1:	83 ec 08             	sub    $0x8,%esp
  8010e4:	ff 75 0c             	pushl  0xc(%ebp)
  8010e7:	6a 20                	push   $0x20
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	ff d0                	call   *%eax
  8010ee:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010f1:	ff 4d e4             	decl   -0x1c(%ebp)
  8010f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010f8:	7f e7                	jg     8010e1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8010fa:	e9 66 01 00 00       	jmp    801265 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8010ff:	83 ec 08             	sub    $0x8,%esp
  801102:	ff 75 e8             	pushl  -0x18(%ebp)
  801105:	8d 45 14             	lea    0x14(%ebp),%eax
  801108:	50                   	push   %eax
  801109:	e8 3c fd ff ff       	call   800e4a <getint>
  80110e:	83 c4 10             	add    $0x10,%esp
  801111:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801114:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	85 d2                	test   %edx,%edx
  80111f:	79 23                	jns    801144 <vprintfmt+0x29b>
				putch('-', putdat);
  801121:	83 ec 08             	sub    $0x8,%esp
  801124:	ff 75 0c             	pushl  0xc(%ebp)
  801127:	6a 2d                	push   $0x2d
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	ff d0                	call   *%eax
  80112e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801137:	f7 d8                	neg    %eax
  801139:	83 d2 00             	adc    $0x0,%edx
  80113c:	f7 da                	neg    %edx
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801144:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80114b:	e9 bc 00 00 00       	jmp    80120c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801150:	83 ec 08             	sub    $0x8,%esp
  801153:	ff 75 e8             	pushl  -0x18(%ebp)
  801156:	8d 45 14             	lea    0x14(%ebp),%eax
  801159:	50                   	push   %eax
  80115a:	e8 84 fc ff ff       	call   800de3 <getuint>
  80115f:	83 c4 10             	add    $0x10,%esp
  801162:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801165:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801168:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80116f:	e9 98 00 00 00       	jmp    80120c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	ff 75 0c             	pushl  0xc(%ebp)
  80117a:	6a 58                	push   $0x58
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	ff d0                	call   *%eax
  801181:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801184:	83 ec 08             	sub    $0x8,%esp
  801187:	ff 75 0c             	pushl  0xc(%ebp)
  80118a:	6a 58                	push   $0x58
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	ff d0                	call   *%eax
  801191:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	ff 75 0c             	pushl  0xc(%ebp)
  80119a:	6a 58                	push   $0x58
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	ff d0                	call   *%eax
  8011a1:	83 c4 10             	add    $0x10,%esp
			break;
  8011a4:	e9 bc 00 00 00       	jmp    801265 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	ff 75 0c             	pushl  0xc(%ebp)
  8011af:	6a 30                	push   $0x30
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	ff d0                	call   *%eax
  8011b6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011b9:	83 ec 08             	sub    $0x8,%esp
  8011bc:	ff 75 0c             	pushl  0xc(%ebp)
  8011bf:	6a 78                	push   $0x78
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	ff d0                	call   *%eax
  8011c6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cc:	83 c0 04             	add    $0x4,%eax
  8011cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d5:	83 e8 04             	sub    $0x4,%eax
  8011d8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011e4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011eb:	eb 1f                	jmp    80120c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011ed:	83 ec 08             	sub    $0x8,%esp
  8011f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8011f6:	50                   	push   %eax
  8011f7:	e8 e7 fb ff ff       	call   800de3 <getuint>
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801202:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801205:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80120c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801213:	83 ec 04             	sub    $0x4,%esp
  801216:	52                   	push   %edx
  801217:	ff 75 e4             	pushl  -0x1c(%ebp)
  80121a:	50                   	push   %eax
  80121b:	ff 75 f4             	pushl  -0xc(%ebp)
  80121e:	ff 75 f0             	pushl  -0x10(%ebp)
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	ff 75 08             	pushl  0x8(%ebp)
  801227:	e8 00 fb ff ff       	call   800d2c <printnum>
  80122c:	83 c4 20             	add    $0x20,%esp
			break;
  80122f:	eb 34                	jmp    801265 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801231:	83 ec 08             	sub    $0x8,%esp
  801234:	ff 75 0c             	pushl  0xc(%ebp)
  801237:	53                   	push   %ebx
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	ff d0                	call   *%eax
  80123d:	83 c4 10             	add    $0x10,%esp
			break;
  801240:	eb 23                	jmp    801265 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801242:	83 ec 08             	sub    $0x8,%esp
  801245:	ff 75 0c             	pushl  0xc(%ebp)
  801248:	6a 25                	push   $0x25
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	ff d0                	call   *%eax
  80124f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801252:	ff 4d 10             	decl   0x10(%ebp)
  801255:	eb 03                	jmp    80125a <vprintfmt+0x3b1>
  801257:	ff 4d 10             	decl   0x10(%ebp)
  80125a:	8b 45 10             	mov    0x10(%ebp),%eax
  80125d:	48                   	dec    %eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	3c 25                	cmp    $0x25,%al
  801262:	75 f3                	jne    801257 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801264:	90                   	nop
		}
	}
  801265:	e9 47 fc ff ff       	jmp    800eb1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80126a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80126b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80126e:	5b                   	pop    %ebx
  80126f:	5e                   	pop    %esi
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    

00801272 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801278:	8d 45 10             	lea    0x10(%ebp),%eax
  80127b:	83 c0 04             	add    $0x4,%eax
  80127e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801281:	8b 45 10             	mov    0x10(%ebp),%eax
  801284:	ff 75 f4             	pushl  -0xc(%ebp)
  801287:	50                   	push   %eax
  801288:	ff 75 0c             	pushl  0xc(%ebp)
  80128b:	ff 75 08             	pushl  0x8(%ebp)
  80128e:	e8 16 fc ff ff       	call   800ea9 <vprintfmt>
  801293:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801296:	90                   	nop
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	8b 40 08             	mov    0x8(%eax),%eax
  8012a2:	8d 50 01             	lea    0x1(%eax),%edx
  8012a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	8b 10                	mov    (%eax),%edx
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	8b 40 04             	mov    0x4(%eax),%eax
  8012b6:	39 c2                	cmp    %eax,%edx
  8012b8:	73 12                	jae    8012cc <sprintputch+0x33>
		*b->buf++ = ch;
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	8b 00                	mov    (%eax),%eax
  8012bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c5:	89 0a                	mov    %ecx,(%edx)
  8012c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ca:	88 10                	mov    %dl,(%eax)
}
  8012cc:	90                   	nop
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    

008012cf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	01 d0                	add    %edx,%eax
  8012e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f4:	74 06                	je     8012fc <vsnprintf+0x2d>
  8012f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fa:	7f 07                	jg     801303 <vsnprintf+0x34>
		return -E_INVAL;
  8012fc:	b8 03 00 00 00       	mov    $0x3,%eax
  801301:	eb 20                	jmp    801323 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801303:	ff 75 14             	pushl  0x14(%ebp)
  801306:	ff 75 10             	pushl  0x10(%ebp)
  801309:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80130c:	50                   	push   %eax
  80130d:	68 99 12 80 00       	push   $0x801299
  801312:	e8 92 fb ff ff       	call   800ea9 <vprintfmt>
  801317:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80131a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80131d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801320:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80132b:	8d 45 10             	lea    0x10(%ebp),%eax
  80132e:	83 c0 04             	add    $0x4,%eax
  801331:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	ff 75 f4             	pushl  -0xc(%ebp)
  80133a:	50                   	push   %eax
  80133b:	ff 75 0c             	pushl  0xc(%ebp)
  80133e:	ff 75 08             	pushl  0x8(%ebp)
  801341:	e8 89 ff ff ff       	call   8012cf <vsnprintf>
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80134c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135e:	eb 06                	jmp    801366 <strlen+0x15>
		n++;
  801360:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	ff 45 08             	incl   0x8(%ebp)
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	8a 00                	mov    (%eax),%al
  80136b:	84 c0                	test   %al,%al
  80136d:	75 f1                	jne    801360 <strlen+0xf>
		n++;
	return n;
  80136f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80137a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801381:	eb 09                	jmp    80138c <strnlen+0x18>
		n++;
  801383:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	ff 45 08             	incl   0x8(%ebp)
  801389:	ff 4d 0c             	decl   0xc(%ebp)
  80138c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801390:	74 09                	je     80139b <strnlen+0x27>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	84 c0                	test   %al,%al
  801399:	75 e8                	jne    801383 <strnlen+0xf>
		n++;
	return n;
  80139b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013ac:	90                   	nop
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8d 50 01             	lea    0x1(%eax),%edx
  8013b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013bc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013bf:	8a 12                	mov    (%edx),%dl
  8013c1:	88 10                	mov    %dl,(%eax)
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	84 c0                	test   %al,%al
  8013c7:	75 e4                	jne    8013ad <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e1:	eb 1f                	jmp    801402 <strncpy+0x34>
		*dst++ = *src;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8d 50 01             	lea    0x1(%eax),%edx
  8013e9:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ef:	8a 12                	mov    (%edx),%dl
  8013f1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	84 c0                	test   %al,%al
  8013fa:	74 03                	je     8013ff <strncpy+0x31>
			src++;
  8013fc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ff:	ff 45 fc             	incl   -0x4(%ebp)
  801402:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801405:	3b 45 10             	cmp    0x10(%ebp),%eax
  801408:	72 d9                	jb     8013e3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80140a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80141b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141f:	74 30                	je     801451 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801421:	eb 16                	jmp    801439 <strlcpy+0x2a>
			*dst++ = *src++;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8d 50 01             	lea    0x1(%eax),%edx
  801429:	89 55 08             	mov    %edx,0x8(%ebp)
  80142c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801432:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801435:	8a 12                	mov    (%edx),%dl
  801437:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801439:	ff 4d 10             	decl   0x10(%ebp)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	74 09                	je     80144b <strlcpy+0x3c>
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	75 d8                	jne    801423 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801451:	8b 55 08             	mov    0x8(%ebp),%edx
  801454:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801457:	29 c2                	sub    %eax,%edx
  801459:	89 d0                	mov    %edx,%eax
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801460:	eb 06                	jmp    801468 <strcmp+0xb>
		p++, q++;
  801462:	ff 45 08             	incl   0x8(%ebp)
  801465:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8a 00                	mov    (%eax),%al
  80146d:	84 c0                	test   %al,%al
  80146f:	74 0e                	je     80147f <strcmp+0x22>
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 10                	mov    (%eax),%dl
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	38 c2                	cmp    %al,%dl
  80147d:	74 e3                	je     801462 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	0f b6 d0             	movzbl %al,%edx
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	0f b6 c0             	movzbl %al,%eax
  80148f:	29 c2                	sub    %eax,%edx
  801491:	89 d0                	mov    %edx,%eax
}
  801493:	5d                   	pop    %ebp
  801494:	c3                   	ret    

00801495 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801498:	eb 09                	jmp    8014a3 <strncmp+0xe>
		n--, p++, q++;
  80149a:	ff 4d 10             	decl   0x10(%ebp)
  80149d:	ff 45 08             	incl   0x8(%ebp)
  8014a0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	74 17                	je     8014c0 <strncmp+0x2b>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	84 c0                	test   %al,%al
  8014b0:	74 0e                	je     8014c0 <strncmp+0x2b>
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8a 10                	mov    (%eax),%dl
  8014b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	38 c2                	cmp    %al,%dl
  8014be:	74 da                	je     80149a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c4:	75 07                	jne    8014cd <strncmp+0x38>
		return 0;
  8014c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cb:	eb 14                	jmp    8014e1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	0f b6 d0             	movzbl %al,%edx
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	0f b6 c0             	movzbl %al,%eax
  8014dd:	29 c2                	sub    %eax,%edx
  8014df:	89 d0                	mov    %edx,%eax
}
  8014e1:	5d                   	pop    %ebp
  8014e2:	c3                   	ret    

008014e3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 04             	sub    $0x4,%esp
  8014e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014ef:	eb 12                	jmp    801503 <strchr+0x20>
		if (*s == c)
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014f9:	75 05                	jne    801500 <strchr+0x1d>
			return (char *) s;
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	eb 11                	jmp    801511 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801500:	ff 45 08             	incl   0x8(%ebp)
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	84 c0                	test   %al,%al
  80150a:	75 e5                	jne    8014f1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 04             	sub    $0x4,%esp
  801519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80151f:	eb 0d                	jmp    80152e <strfind+0x1b>
		if (*s == c)
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801529:	74 0e                	je     801539 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80152b:	ff 45 08             	incl   0x8(%ebp)
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 ea                	jne    801521 <strfind+0xe>
  801537:	eb 01                	jmp    80153a <strfind+0x27>
		if (*s == c)
			break;
  801539:	90                   	nop
	return (char *) s;
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80154b:	8b 45 10             	mov    0x10(%ebp),%eax
  80154e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801551:	eb 0e                	jmp    801561 <memset+0x22>
		*p++ = c;
  801553:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801556:	8d 50 01             	lea    0x1(%eax),%edx
  801559:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80155c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801561:	ff 4d f8             	decl   -0x8(%ebp)
  801564:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801568:	79 e9                	jns    801553 <memset+0x14>
		*p++ = c;

	return v;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801575:	8b 45 0c             	mov    0xc(%ebp),%eax
  801578:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801581:	eb 16                	jmp    801599 <memcpy+0x2a>
		*d++ = *s++;
  801583:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801586:	8d 50 01             	lea    0x1(%eax),%edx
  801589:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80158c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801592:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801595:	8a 12                	mov    (%edx),%dl
  801597:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80159f:	89 55 10             	mov    %edx,0x10(%ebp)
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	75 dd                	jne    801583 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015c3:	73 50                	jae    801615 <memmove+0x6a>
  8015c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cb:	01 d0                	add    %edx,%eax
  8015cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015d0:	76 43                	jbe    801615 <memmove+0x6a>
		s += n;
  8015d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015db:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015de:	eb 10                	jmp    8015f0 <memmove+0x45>
			*--d = *--s;
  8015e0:	ff 4d f8             	decl   -0x8(%ebp)
  8015e3:	ff 4d fc             	decl   -0x4(%ebp)
  8015e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e9:	8a 10                	mov    (%eax),%dl
  8015eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ee:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	75 e3                	jne    8015e0 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015fd:	eb 23                	jmp    801622 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801602:	8d 50 01             	lea    0x1(%eax),%edx
  801605:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801608:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80160e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801611:	8a 12                	mov    (%edx),%dl
  801613:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801615:	8b 45 10             	mov    0x10(%ebp),%eax
  801618:	8d 50 ff             	lea    -0x1(%eax),%edx
  80161b:	89 55 10             	mov    %edx,0x10(%ebp)
  80161e:	85 c0                	test   %eax,%eax
  801620:	75 dd                	jne    8015ff <memmove+0x54>
			*d++ = *s++;

	return dst;
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801633:	8b 45 0c             	mov    0xc(%ebp),%eax
  801636:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801639:	eb 2a                	jmp    801665 <memcmp+0x3e>
		if (*s1 != *s2)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	8a 10                	mov    (%eax),%dl
  801640:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801643:	8a 00                	mov    (%eax),%al
  801645:	38 c2                	cmp    %al,%dl
  801647:	74 16                	je     80165f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801649:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164c:	8a 00                	mov    (%eax),%al
  80164e:	0f b6 d0             	movzbl %al,%edx
  801651:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801654:	8a 00                	mov    (%eax),%al
  801656:	0f b6 c0             	movzbl %al,%eax
  801659:	29 c2                	sub    %eax,%edx
  80165b:	89 d0                	mov    %edx,%eax
  80165d:	eb 18                	jmp    801677 <memcmp+0x50>
		s1++, s2++;
  80165f:	ff 45 fc             	incl   -0x4(%ebp)
  801662:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801665:	8b 45 10             	mov    0x10(%ebp),%eax
  801668:	8d 50 ff             	lea    -0x1(%eax),%edx
  80166b:	89 55 10             	mov    %edx,0x10(%ebp)
  80166e:	85 c0                	test   %eax,%eax
  801670:	75 c9                	jne    80163b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801672:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80167f:	8b 55 08             	mov    0x8(%ebp),%edx
  801682:	8b 45 10             	mov    0x10(%ebp),%eax
  801685:	01 d0                	add    %edx,%eax
  801687:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80168a:	eb 15                	jmp    8016a1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	8a 00                	mov    (%eax),%al
  801691:	0f b6 d0             	movzbl %al,%edx
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
  801697:	0f b6 c0             	movzbl %al,%eax
  80169a:	39 c2                	cmp    %eax,%edx
  80169c:	74 0d                	je     8016ab <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80169e:	ff 45 08             	incl   0x8(%ebp)
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016a7:	72 e3                	jb     80168c <memfind+0x13>
  8016a9:	eb 01                	jmp    8016ac <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016ab:	90                   	nop
	return (void *) s;
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c5:	eb 03                	jmp    8016ca <strtol+0x19>
		s++;
  8016c7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	3c 20                	cmp    $0x20,%al
  8016d1:	74 f4                	je     8016c7 <strtol+0x16>
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	3c 09                	cmp    $0x9,%al
  8016da:	74 eb                	je     8016c7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	3c 2b                	cmp    $0x2b,%al
  8016e3:	75 05                	jne    8016ea <strtol+0x39>
		s++;
  8016e5:	ff 45 08             	incl   0x8(%ebp)
  8016e8:	eb 13                	jmp    8016fd <strtol+0x4c>
	else if (*s == '-')
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	8a 00                	mov    (%eax),%al
  8016ef:	3c 2d                	cmp    $0x2d,%al
  8016f1:	75 0a                	jne    8016fd <strtol+0x4c>
		s++, neg = 1;
  8016f3:	ff 45 08             	incl   0x8(%ebp)
  8016f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801701:	74 06                	je     801709 <strtol+0x58>
  801703:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801707:	75 20                	jne    801729 <strtol+0x78>
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 30                	cmp    $0x30,%al
  801710:	75 17                	jne    801729 <strtol+0x78>
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	40                   	inc    %eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	3c 78                	cmp    $0x78,%al
  80171a:	75 0d                	jne    801729 <strtol+0x78>
		s += 2, base = 16;
  80171c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801720:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801727:	eb 28                	jmp    801751 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801729:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172d:	75 15                	jne    801744 <strtol+0x93>
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	8a 00                	mov    (%eax),%al
  801734:	3c 30                	cmp    $0x30,%al
  801736:	75 0c                	jne    801744 <strtol+0x93>
		s++, base = 8;
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801742:	eb 0d                	jmp    801751 <strtol+0xa0>
	else if (base == 0)
  801744:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801748:	75 07                	jne    801751 <strtol+0xa0>
		base = 10;
  80174a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8a 00                	mov    (%eax),%al
  801756:	3c 2f                	cmp    $0x2f,%al
  801758:	7e 19                	jle    801773 <strtol+0xc2>
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8a 00                	mov    (%eax),%al
  80175f:	3c 39                	cmp    $0x39,%al
  801761:	7f 10                	jg     801773 <strtol+0xc2>
			dig = *s - '0';
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	8a 00                	mov    (%eax),%al
  801768:	0f be c0             	movsbl %al,%eax
  80176b:	83 e8 30             	sub    $0x30,%eax
  80176e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801771:	eb 42                	jmp    8017b5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	8a 00                	mov    (%eax),%al
  801778:	3c 60                	cmp    $0x60,%al
  80177a:	7e 19                	jle    801795 <strtol+0xe4>
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8a 00                	mov    (%eax),%al
  801781:	3c 7a                	cmp    $0x7a,%al
  801783:	7f 10                	jg     801795 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8a 00                	mov    (%eax),%al
  80178a:	0f be c0             	movsbl %al,%eax
  80178d:	83 e8 57             	sub    $0x57,%eax
  801790:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801793:	eb 20                	jmp    8017b5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 40                	cmp    $0x40,%al
  80179c:	7e 39                	jle    8017d7 <strtol+0x126>
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 5a                	cmp    $0x5a,%al
  8017a5:	7f 30                	jg     8017d7 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	0f be c0             	movsbl %al,%eax
  8017af:	83 e8 37             	sub    $0x37,%eax
  8017b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017bb:	7d 19                	jge    8017d6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017bd:	ff 45 08             	incl   0x8(%ebp)
  8017c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017c7:	89 c2                	mov    %eax,%edx
  8017c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cc:	01 d0                	add    %edx,%eax
  8017ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017d1:	e9 7b ff ff ff       	jmp    801751 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017d6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017db:	74 08                	je     8017e5 <strtol+0x134>
		*endptr = (char *) s;
  8017dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017e9:	74 07                	je     8017f2 <strtol+0x141>
  8017eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ee:	f7 d8                	neg    %eax
  8017f0:	eb 03                	jmp    8017f5 <strtol+0x144>
  8017f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <ltostr>:

void
ltostr(long value, char *str)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801804:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80180b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80180f:	79 13                	jns    801824 <ltostr+0x2d>
	{
		neg = 1;
  801811:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80181e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801821:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80182c:	99                   	cltd   
  80182d:	f7 f9                	idiv   %ecx
  80182f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801832:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801835:	8d 50 01             	lea    0x1(%eax),%edx
  801838:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80183b:	89 c2                	mov    %eax,%edx
  80183d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801840:	01 d0                	add    %edx,%eax
  801842:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801845:	83 c2 30             	add    $0x30,%edx
  801848:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80184a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80184d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801852:	f7 e9                	imul   %ecx
  801854:	c1 fa 02             	sar    $0x2,%edx
  801857:	89 c8                	mov    %ecx,%eax
  801859:	c1 f8 1f             	sar    $0x1f,%eax
  80185c:	29 c2                	sub    %eax,%edx
  80185e:	89 d0                	mov    %edx,%eax
  801860:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801863:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801866:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80186b:	f7 e9                	imul   %ecx
  80186d:	c1 fa 02             	sar    $0x2,%edx
  801870:	89 c8                	mov    %ecx,%eax
  801872:	c1 f8 1f             	sar    $0x1f,%eax
  801875:	29 c2                	sub    %eax,%edx
  801877:	89 d0                	mov    %edx,%eax
  801879:	c1 e0 02             	shl    $0x2,%eax
  80187c:	01 d0                	add    %edx,%eax
  80187e:	01 c0                	add    %eax,%eax
  801880:	29 c1                	sub    %eax,%ecx
  801882:	89 ca                	mov    %ecx,%edx
  801884:	85 d2                	test   %edx,%edx
  801886:	75 9c                	jne    801824 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801888:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80188f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801892:	48                   	dec    %eax
  801893:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801896:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80189a:	74 3d                	je     8018d9 <ltostr+0xe2>
		start = 1 ;
  80189c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018a3:	eb 34                	jmp    8018d9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ab:	01 d0                	add    %edx,%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b8:	01 c2                	add    %eax,%edx
  8018ba:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	01 c8                	add    %ecx,%eax
  8018c2:	8a 00                	mov    (%eax),%al
  8018c4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c2                	add    %eax,%edx
  8018ce:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018d1:	88 02                	mov    %al,(%edx)
		start++ ;
  8018d3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018d6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018df:	7c c4                	jl     8018a5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e7:	01 d0                	add    %edx,%eax
  8018e9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018ec:	90                   	nop
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8018f5:	ff 75 08             	pushl  0x8(%ebp)
  8018f8:	e8 54 fa ff ff       	call   801351 <strlen>
  8018fd:	83 c4 04             	add    $0x4,%esp
  801900:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	e8 46 fa ff ff       	call   801351 <strlen>
  80190b:	83 c4 04             	add    $0x4,%esp
  80190e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801911:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801918:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80191f:	eb 17                	jmp    801938 <strcconcat+0x49>
		final[s] = str1[s] ;
  801921:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801924:	8b 45 10             	mov    0x10(%ebp),%eax
  801927:	01 c2                	add    %eax,%edx
  801929:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	01 c8                	add    %ecx,%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801935:	ff 45 fc             	incl   -0x4(%ebp)
  801938:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80193b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80193e:	7c e1                	jl     801921 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801940:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801947:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80194e:	eb 1f                	jmp    80196f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801950:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801953:	8d 50 01             	lea    0x1(%eax),%edx
  801956:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801959:	89 c2                	mov    %eax,%edx
  80195b:	8b 45 10             	mov    0x10(%ebp),%eax
  80195e:	01 c2                	add    %eax,%edx
  801960:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 c8                	add    %ecx,%eax
  801968:	8a 00                	mov    (%eax),%al
  80196a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80196c:	ff 45 f8             	incl   -0x8(%ebp)
  80196f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801972:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801975:	7c d9                	jl     801950 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801977:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80197a:	8b 45 10             	mov    0x10(%ebp),%eax
  80197d:	01 d0                	add    %edx,%eax
  80197f:	c6 00 00             	movb   $0x0,(%eax)
}
  801982:	90                   	nop
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801988:	8b 45 14             	mov    0x14(%ebp),%eax
  80198b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801991:	8b 45 14             	mov    0x14(%ebp),%eax
  801994:	8b 00                	mov    (%eax),%eax
  801996:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80199d:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a0:	01 d0                	add    %edx,%eax
  8019a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019a8:	eb 0c                	jmp    8019b6 <strsplit+0x31>
			*string++ = 0;
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	8d 50 01             	lea    0x1(%eax),%edx
  8019b0:	89 55 08             	mov    %edx,0x8(%ebp)
  8019b3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	84 c0                	test   %al,%al
  8019bd:	74 18                	je     8019d7 <strsplit+0x52>
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	8a 00                	mov    (%eax),%al
  8019c4:	0f be c0             	movsbl %al,%eax
  8019c7:	50                   	push   %eax
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	e8 13 fb ff ff       	call   8014e3 <strchr>
  8019d0:	83 c4 08             	add    $0x8,%esp
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	75 d3                	jne    8019aa <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	84 c0                	test   %al,%al
  8019de:	74 5a                	je     801a3a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8019e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e3:	8b 00                	mov    (%eax),%eax
  8019e5:	83 f8 0f             	cmp    $0xf,%eax
  8019e8:	75 07                	jne    8019f1 <strsplit+0x6c>
		{
			return 0;
  8019ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ef:	eb 66                	jmp    801a57 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f4:	8b 00                	mov    (%eax),%eax
  8019f6:	8d 48 01             	lea    0x1(%eax),%ecx
  8019f9:	8b 55 14             	mov    0x14(%ebp),%edx
  8019fc:	89 0a                	mov    %ecx,(%edx)
  8019fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	01 c2                	add    %eax,%edx
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a0f:	eb 03                	jmp    801a14 <strsplit+0x8f>
			string++;
  801a11:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	84 c0                	test   %al,%al
  801a1b:	74 8b                	je     8019a8 <strsplit+0x23>
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	8a 00                	mov    (%eax),%al
  801a22:	0f be c0             	movsbl %al,%eax
  801a25:	50                   	push   %eax
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	e8 b5 fa ff ff       	call   8014e3 <strchr>
  801a2e:	83 c4 08             	add    $0x8,%esp
  801a31:	85 c0                	test   %eax,%eax
  801a33:	74 dc                	je     801a11 <strsplit+0x8c>
			string++;
	}
  801a35:	e9 6e ff ff ff       	jmp    8019a8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a3a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 d0                	add    %edx,%eax
  801a4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a52:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801a62:	e8 7d 0f 00 00       	call   8029e4 <sys_isUHeapPlacementStrategyNEXTFIT>
  801a67:	85 c0                	test   %eax,%eax
  801a69:	0f 84 6f 03 00 00    	je     801dde <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801a6f:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801a76:	8b 55 08             	mov    0x8(%ebp),%edx
  801a79:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801a7c:	01 d0                	add    %edx,%eax
  801a7e:	48                   	dec    %eax
  801a7f:	89 45 80             	mov    %eax,-0x80(%ebp)
  801a82:	8b 45 80             	mov    -0x80(%ebp),%eax
  801a85:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8a:	f7 75 84             	divl   -0x7c(%ebp)
  801a8d:	8b 45 80             	mov    -0x80(%ebp),%eax
  801a90:	29 d0                	sub    %edx,%eax
  801a92:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801a95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a99:	74 09                	je     801aa4 <malloc+0x4b>
  801a9b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801aa2:	76 0a                	jbe    801aae <malloc+0x55>
			return NULL;
  801aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa9:	e9 4b 09 00 00       	jmp    8023f9 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801aae:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	01 d0                	add    %edx,%eax
  801ab9:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801abe:	0f 87 a2 00 00 00    	ja     801b66 <malloc+0x10d>
  801ac4:	a1 40 40 98 00       	mov    0x984040,%eax
  801ac9:	85 c0                	test   %eax,%eax
  801acb:	0f 85 95 00 00 00    	jne    801b66 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801ad1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ad6:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801adc:	a1 04 40 80 00       	mov    0x804004,%eax
  801ae1:	83 ec 08             	sub    $0x8,%esp
  801ae4:	ff 75 08             	pushl  0x8(%ebp)
  801ae7:	50                   	push   %eax
  801ae8:	e8 a3 0b 00 00       	call   802690 <sys_allocateMem>
  801aed:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801af0:	a1 20 40 80 00       	mov    0x804020,%eax
  801af5:	8b 55 08             	mov    0x8(%ebp),%edx
  801af8:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801aff:	a1 20 40 80 00       	mov    0x804020,%eax
  801b04:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b0a:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  801b11:	a1 20 40 80 00       	mov    0x804020,%eax
  801b16:	40                   	inc    %eax
  801b17:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  801b1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801b23:	eb 2e                	jmp    801b53 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801b25:	a1 04 40 80 00       	mov    0x804004,%eax
  801b2a:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801b2f:	c1 e8 0c             	shr    $0xc,%eax
  801b32:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801b39:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801b3d:	a1 04 40 80 00       	mov    0x804004,%eax
  801b42:	05 00 10 00 00       	add    $0x1000,%eax
  801b47:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801b4c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b56:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b59:	72 ca                	jb     801b25 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801b5b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801b61:	e9 93 08 00 00       	jmp    8023f9 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801b66:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801b6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801b74:	a1 40 40 98 00       	mov    0x984040,%eax
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	75 1d                	jne    801b9a <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801b7d:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801b84:	00 00 80 
				check = 1;
  801b87:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  801b8e:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801b91:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801b98:	eb 08                	jmp    801ba2 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801b9a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801ba2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801ba9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801bb0:	a1 04 40 80 00       	mov    0x804004,%eax
  801bb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801bb8:	eb 4d                	jmp    801c07 <malloc+0x1ae>
				if (sz == size) {
  801bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bbd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bc0:	75 09                	jne    801bcb <malloc+0x172>
					f = 1;
  801bc2:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801bc9:	eb 45                	jmp    801c10 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801bcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bce:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801bd3:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801bd6:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	75 10                	jne    801bf1 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801be1:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801be8:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801bef:	eb 16                	jmp    801c07 <malloc+0x1ae>
				} else {
					sz = 0;
  801bf1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801bf8:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c02:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801c07:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801c0e:	76 aa                	jbe    801bba <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801c10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c14:	0f 84 95 00 00 00    	je     801caf <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801c1a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c1f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801c25:	a1 04 40 80 00       	mov    0x804004,%eax
  801c2a:	83 ec 08             	sub    $0x8,%esp
  801c2d:	ff 75 08             	pushl  0x8(%ebp)
  801c30:	50                   	push   %eax
  801c31:	e8 5a 0a 00 00       	call   802690 <sys_allocateMem>
  801c36:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801c39:	a1 20 40 80 00       	mov    0x804020,%eax
  801c3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801c41:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801c48:	a1 20 40 80 00       	mov    0x804020,%eax
  801c4d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c53:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  801c5a:	a1 20 40 80 00       	mov    0x804020,%eax
  801c5f:	40                   	inc    %eax
  801c60:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  801c65:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801c6c:	eb 2e                	jmp    801c9c <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801c6e:	a1 04 40 80 00       	mov    0x804004,%eax
  801c73:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801c78:	c1 e8 0c             	shr    $0xc,%eax
  801c7b:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801c82:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801c86:	a1 04 40 80 00       	mov    0x804004,%eax
  801c8b:	05 00 10 00 00       	add    $0x1000,%eax
  801c90:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801c95:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801c9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ca2:	72 ca                	jb     801c6e <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801ca4:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801caa:	e9 4a 07 00 00       	jmp    8023f9 <malloc+0x9a0>

			} else {

				if (check_start) {
  801caf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cb3:	74 0a                	je     801cbf <malloc+0x266>

					return NULL;
  801cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cba:	e9 3a 07 00 00       	jmp    8023f9 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801cbf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801cc6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801ccd:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801cd4:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801cdb:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801cde:	eb 4d                	jmp    801d2d <malloc+0x2d4>
					if (sz == size) {
  801ce0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ce3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ce6:	75 09                	jne    801cf1 <malloc+0x298>
						f = 1;
  801ce8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801cef:	eb 44                	jmp    801d35 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801cf1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cf4:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801cf9:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801cfc:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801d03:	85 c0                	test   %eax,%eax
  801d05:	75 10                	jne    801d17 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801d07:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801d0e:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801d15:	eb 16                	jmp    801d2d <malloc+0x2d4>
					} else {
						sz = 0;
  801d17:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801d1e:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801d25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d28:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d30:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801d33:	72 ab                	jb     801ce0 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801d35:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801d39:	0f 84 95 00 00 00    	je     801dd4 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801d3f:	a1 04 40 80 00       	mov    0x804004,%eax
  801d44:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801d4a:	a1 04 40 80 00       	mov    0x804004,%eax
  801d4f:	83 ec 08             	sub    $0x8,%esp
  801d52:	ff 75 08             	pushl  0x8(%ebp)
  801d55:	50                   	push   %eax
  801d56:	e8 35 09 00 00       	call   802690 <sys_allocateMem>
  801d5b:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801d5e:	a1 20 40 80 00       	mov    0x804020,%eax
  801d63:	8b 55 08             	mov    0x8(%ebp),%edx
  801d66:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801d6d:	a1 20 40 80 00       	mov    0x804020,%eax
  801d72:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d78:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  801d7f:	a1 20 40 80 00       	mov    0x804020,%eax
  801d84:	40                   	inc    %eax
  801d85:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  801d8a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801d91:	eb 2e                	jmp    801dc1 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801d93:	a1 04 40 80 00       	mov    0x804004,%eax
  801d98:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801d9d:	c1 e8 0c             	shr    $0xc,%eax
  801da0:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801da7:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801dab:	a1 04 40 80 00       	mov    0x804004,%eax
  801db0:	05 00 10 00 00       	add    $0x1000,%eax
  801db5:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801dba:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801dc1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801dc4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dc7:	72 ca                	jb     801d93 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801dc9:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801dcf:	e9 25 06 00 00       	jmp    8023f9 <malloc+0x9a0>

				} else {

					return NULL;
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd9:	e9 1b 06 00 00       	jmp    8023f9 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801dde:	e8 d0 0b 00 00       	call   8029b3 <sys_isUHeapPlacementStrategyBESTFIT>
  801de3:	85 c0                	test   %eax,%eax
  801de5:	0f 84 ba 01 00 00    	je     801fa5 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801deb:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801df2:	10 00 00 
  801df5:	8b 55 08             	mov    0x8(%ebp),%edx
  801df8:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801dfe:	01 d0                	add    %edx,%eax
  801e00:	48                   	dec    %eax
  801e01:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801e07:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801e0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e12:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801e18:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801e1e:	29 d0                	sub    %edx,%eax
  801e20:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e27:	74 09                	je     801e32 <malloc+0x3d9>
  801e29:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801e30:	76 0a                	jbe    801e3c <malloc+0x3e3>
			return NULL;
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
  801e37:	e9 bd 05 00 00       	jmp    8023f9 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801e3c:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801e43:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801e4a:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801e51:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801e58:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	c1 e8 0c             	shr    $0xc,%eax
  801e65:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801e6b:	e9 80 00 00 00       	jmp    801ef0 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801e70:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e73:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	75 0c                	jne    801e8a <malloc+0x431>

				count++;
  801e7e:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801e81:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801e88:	eb 2d                	jmp    801eb7 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801e8a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801e90:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801e93:	77 14                	ja     801ea9 <malloc+0x450>
  801e95:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e98:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801e9b:	76 0c                	jbe    801ea9 <malloc+0x450>

					min_sz = count;
  801e9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801ea0:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801ea3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ea6:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801ea9:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801eb0:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801eb7:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801ebe:	75 2d                	jne    801eed <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801ec0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801ec6:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801ec9:	77 22                	ja     801eed <malloc+0x494>
  801ecb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ece:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801ed1:	76 1a                	jbe    801eed <malloc+0x494>

					min_sz = count;
  801ed3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801ed6:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801ed9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801edc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801edf:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801ee6:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801eed:	ff 45 b8             	incl   -0x48(%ebp)
  801ef0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ef3:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801ef8:	0f 86 72 ff ff ff    	jbe    801e70 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801efe:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801f04:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801f07:	77 06                	ja     801f0f <malloc+0x4b6>
  801f09:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801f0d:	75 0a                	jne    801f19 <malloc+0x4c0>
			return NULL;
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	e9 e0 04 00 00       	jmp    8023f9 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801f19:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f1c:	c1 e0 0c             	shl    $0xc,%eax
  801f1f:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801f22:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f25:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801f2b:	83 ec 08             	sub    $0x8,%esp
  801f2e:	ff 75 08             	pushl  0x8(%ebp)
  801f31:	ff 75 c4             	pushl  -0x3c(%ebp)
  801f34:	e8 57 07 00 00       	call   802690 <sys_allocateMem>
  801f39:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801f3c:	a1 20 40 80 00       	mov    0x804020,%eax
  801f41:	8b 55 08             	mov    0x8(%ebp),%edx
  801f44:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801f4b:	a1 20 40 80 00       	mov    0x804020,%eax
  801f50:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801f53:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  801f5a:	a1 20 40 80 00       	mov    0x804020,%eax
  801f5f:	40                   	inc    %eax
  801f60:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  801f65:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801f6c:	eb 24                	jmp    801f92 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801f6e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f71:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801f76:	c1 e8 0c             	shr    $0xc,%eax
  801f79:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801f80:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801f84:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801f8b:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801f92:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f95:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f98:	72 d4                	jb     801f6e <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801f9a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801fa0:	e9 54 04 00 00       	jmp    8023f9 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801fa5:	e8 d8 09 00 00       	call   802982 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801faa:	85 c0                	test   %eax,%eax
  801fac:	0f 84 88 01 00 00    	je     80213a <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801fb2:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801fb9:	10 00 00 
  801fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  801fbf:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801fc5:	01 d0                	add    %edx,%eax
  801fc7:	48                   	dec    %eax
  801fc8:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801fce:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801fd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd9:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801fdf:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801fe5:	29 d0                	sub    %edx,%eax
  801fe7:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801fea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fee:	74 09                	je     801ff9 <malloc+0x5a0>
  801ff0:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ff7:	76 0a                	jbe    802003 <malloc+0x5aa>
			return NULL;
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffe:	e9 f6 03 00 00       	jmp    8023f9 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  802003:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  80200a:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  802011:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  802018:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  80201f:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	c1 e8 0c             	shr    $0xc,%eax
  80202c:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  802032:	eb 5a                	jmp    80208e <malloc+0x635>

			if (heap_mem[i] == 0) {
  802034:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802037:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	75 0c                	jne    80204e <malloc+0x5f5>

				count++;
  802042:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  802045:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  80204c:	eb 22                	jmp    802070 <malloc+0x617>
			} else {
				if (num_p <= count) {
  80204e:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802054:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  802057:	77 09                	ja     802062 <malloc+0x609>

					found = 1;
  802059:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  802060:	eb 36                	jmp    802098 <malloc+0x63f>
				}
				count = 0;
  802062:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  802069:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  802070:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  802077:	75 12                	jne    80208b <malloc+0x632>

				if (num_p <= count) {
  802079:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80207f:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  802082:	77 07                	ja     80208b <malloc+0x632>

					found = 1;
  802084:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  80208b:	ff 45 a4             	incl   -0x5c(%ebp)
  80208e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802091:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802096:	76 9c                	jbe    802034 <malloc+0x5db>

			}

		}

		if (!found) {
  802098:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  80209c:	75 0a                	jne    8020a8 <malloc+0x64f>
			return NULL;
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a3:	e9 51 03 00 00       	jmp    8023f9 <malloc+0x9a0>

		}

		temp = ptr;
  8020a8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8020ab:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  8020ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8020b1:	c1 e0 0c             	shl    $0xc,%eax
  8020b4:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  8020b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020ba:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  8020c0:	83 ec 08             	sub    $0x8,%esp
  8020c3:	ff 75 08             	pushl  0x8(%ebp)
  8020c6:	ff 75 b0             	pushl  -0x50(%ebp)
  8020c9:	e8 c2 05 00 00       	call   802690 <sys_allocateMem>
  8020ce:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8020d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8020d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d9:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8020e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8020e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020e8:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8020ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8020f4:	40                   	inc    %eax
  8020f5:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  8020fa:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802101:	eb 24                	jmp    802127 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802103:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802106:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80210b:	c1 e8 0c             	shr    $0xc,%eax
  80210e:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802115:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802119:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802120:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  802127:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80212a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80212d:	72 d4                	jb     802103 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  80212f:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  802135:	e9 bf 02 00 00       	jmp    8023f9 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  80213a:	e8 d6 08 00 00       	call   802a15 <sys_isUHeapPlacementStrategyWORSTFIT>
  80213f:	85 c0                	test   %eax,%eax
  802141:	0f 84 ba 01 00 00    	je     802301 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  802147:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  80214e:	10 00 00 
  802151:	8b 55 08             	mov    0x8(%ebp),%edx
  802154:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80215a:	01 d0                	add    %edx,%eax
  80215c:	48                   	dec    %eax
  80215d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802163:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802169:	ba 00 00 00 00       	mov    $0x0,%edx
  80216e:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802174:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80217a:	29 d0                	sub    %edx,%eax
  80217c:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80217f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802183:	74 09                	je     80218e <malloc+0x735>
  802185:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80218c:	76 0a                	jbe    802198 <malloc+0x73f>
					return NULL;
  80218e:	b8 00 00 00 00       	mov    $0x0,%eax
  802193:	e9 61 02 00 00       	jmp    8023f9 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  802198:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  80219f:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  8021a6:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  8021ad:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  8021b4:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	c1 e8 0c             	shr    $0xc,%eax
  8021c1:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8021c7:	e9 80 00 00 00       	jmp    80224c <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  8021cc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8021cf:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	75 0c                	jne    8021e6 <malloc+0x78d>

						count++;
  8021da:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  8021dd:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  8021e4:	eb 2d                	jmp    802213 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  8021e6:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8021ec:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8021ef:	77 14                	ja     802205 <malloc+0x7ac>
  8021f1:	8b 45 98             	mov    -0x68(%ebp),%eax
  8021f4:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8021f7:	73 0c                	jae    802205 <malloc+0x7ac>

							max_sz = count;
  8021f9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8021fc:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8021ff:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802202:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  802205:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  80220c:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  802213:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  80221a:	75 2d                	jne    802249 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  80221c:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802222:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802225:	77 22                	ja     802249 <malloc+0x7f0>
  802227:	8b 45 98             	mov    -0x68(%ebp),%eax
  80222a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80222d:	76 1a                	jbe    802249 <malloc+0x7f0>

							max_sz = count;
  80222f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802232:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802235:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802238:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  80223b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  802242:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802249:	ff 45 90             	incl   -0x70(%ebp)
  80224c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80224f:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802254:	0f 86 72 ff ff ff    	jbe    8021cc <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  80225a:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802260:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802263:	77 06                	ja     80226b <malloc+0x812>
  802265:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802269:	75 0a                	jne    802275 <malloc+0x81c>
					return NULL;
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	e9 84 01 00 00       	jmp    8023f9 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802275:	8b 45 98             	mov    -0x68(%ebp),%eax
  802278:	c1 e0 0c             	shl    $0xc,%eax
  80227b:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  80227e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802281:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  802287:	83 ec 08             	sub    $0x8,%esp
  80228a:	ff 75 08             	pushl  0x8(%ebp)
  80228d:	ff 75 9c             	pushl  -0x64(%ebp)
  802290:	e8 fb 03 00 00       	call   802690 <sys_allocateMem>
  802295:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802298:	a1 20 40 80 00       	mov    0x804020,%eax
  80229d:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a0:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  8022a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8022ac:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8022af:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  8022b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8022bb:	40                   	inc    %eax
  8022bc:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  8022c1:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8022c8:	eb 24                	jmp    8022ee <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8022ca:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8022cd:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8022d2:	c1 e8 0c             	shr    $0xc,%eax
  8022d5:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8022dc:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  8022e0:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8022e7:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  8022ee:	8b 45 90             	mov    -0x70(%ebp),%eax
  8022f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f4:	72 d4                	jb     8022ca <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  8022f6:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8022fc:	e9 f8 00 00 00       	jmp    8023f9 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802301:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  802308:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  80230f:	10 00 00 
  802312:	8b 55 08             	mov    0x8(%ebp),%edx
  802315:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80231b:	01 d0                	add    %edx,%eax
  80231d:	48                   	dec    %eax
  80231e:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802324:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80232a:	ba 00 00 00 00       	mov    $0x0,%edx
  80232f:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802335:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80233b:	29 d0                	sub    %edx,%eax
  80233d:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802344:	74 09                	je     80234f <malloc+0x8f6>
  802346:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80234d:	76 0a                	jbe    802359 <malloc+0x900>
		return NULL;
  80234f:	b8 00 00 00 00       	mov    $0x0,%eax
  802354:	e9 a0 00 00 00       	jmp    8023f9 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802359:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	01 d0                	add    %edx,%eax
  802364:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802369:	0f 87 87 00 00 00    	ja     8023f6 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80236f:	a1 04 40 80 00       	mov    0x804004,%eax
  802374:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802377:	a1 04 40 80 00       	mov    0x804004,%eax
  80237c:	83 ec 08             	sub    $0x8,%esp
  80237f:	ff 75 08             	pushl  0x8(%ebp)
  802382:	50                   	push   %eax
  802383:	e8 08 03 00 00       	call   802690 <sys_allocateMem>
  802388:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80238b:	a1 20 40 80 00       	mov    0x804020,%eax
  802390:	8b 55 08             	mov    0x8(%ebp),%edx
  802393:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80239a:	a1 20 40 80 00       	mov    0x804020,%eax
  80239f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8023a5:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8023ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8023b1:	40                   	inc    %eax
  8023b2:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  8023b7:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8023be:	eb 2e                	jmp    8023ee <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8023c0:	a1 04 40 80 00       	mov    0x804004,%eax
  8023c5:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8023ca:	c1 e8 0c             	shr    $0xc,%eax
  8023cd:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8023d4:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8023d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8023dd:	05 00 10 00 00       	add    $0x1000,%eax
  8023e2:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8023e7:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  8023ee:	8b 45 88             	mov    -0x78(%ebp),%eax
  8023f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f4:	72 ca                	jb     8023c0 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  8023f6:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  802408:	e9 c1 00 00 00       	jmp    8024ce <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  802417:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241a:	0f 85 ab 00 00 00    	jne    8024cb <free+0xd0>

			if (heap_size[inx].size == 0) {
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  80242a:	85 c0                	test   %eax,%eax
  80242c:	75 21                	jne    80244f <free+0x54>
				heap_size[inx].size = 0;
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802438:	00 00 00 00 
				heap_size[inx].vir = NULL;
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802446:	00 00 00 00 
				return;
  80244a:	e9 8d 00 00 00       	jmp    8024dc <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802459:	8b 45 08             	mov    0x8(%ebp),%eax
  80245c:	83 ec 08             	sub    $0x8,%esp
  80245f:	52                   	push   %edx
  802460:	50                   	push   %eax
  802461:	e8 0e 02 00 00       	call   802674 <sys_freeMem>
  802466:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802469:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802476:	eb 24                	jmp    80249c <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247b:	05 00 00 00 80       	add    $0x80000000,%eax
  802480:	c1 e8 0c             	shr    $0xc,%eax
  802483:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  80248a:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  80248e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802495:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  8024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a9:	39 c2                	cmp    %eax,%edx
  8024ab:	77 cb                	ja     802478 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  8024b7:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  8024c5:	00 00 00 00 
			break;
  8024c9:	eb 11                	jmp    8024dc <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8024cb:	ff 45 f4             	incl   -0xc(%ebp)
  8024ce:	a1 20 40 80 00       	mov    0x804020,%eax
  8024d3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8024d6:	0f 8c 31 ff ff ff    	jl     80240d <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8024e4:	83 ec 04             	sub    $0x4,%esp
  8024e7:	68 b0 33 80 00       	push   $0x8033b0
  8024ec:	68 1c 02 00 00       	push   $0x21c
  8024f1:	68 d6 33 80 00       	push   $0x8033d6
  8024f6:	e8 b0 e6 ff ff       	call   800bab <_panic>

008024fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	57                   	push   %edi
  8024ff:	56                   	push   %esi
  802500:	53                   	push   %ebx
  802501:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80250d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802510:	8b 7d 18             	mov    0x18(%ebp),%edi
  802513:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802516:	cd 30                	int    $0x30
  802518:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80251b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    

00802526 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	ff 75 0c             	pushl  0xc(%ebp)
  802535:	50                   	push   %eax
  802536:	6a 00                	push   $0x0
  802538:	e8 be ff ff ff       	call   8024fb <syscall>
  80253d:	83 c4 18             	add    $0x18,%esp
}
  802540:	90                   	nop
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <sys_cgetc>:

int
sys_cgetc(void)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 01                	push   $0x1
  802552:	e8 a4 ff ff ff       	call   8024fb <syscall>
  802557:	83 c4 18             	add    $0x18,%esp
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	50                   	push   %eax
  80256b:	6a 03                	push   $0x3
  80256d:	e8 89 ff ff ff       	call   8024fb <syscall>
  802572:	83 c4 18             	add    $0x18,%esp
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 02                	push   $0x2
  802586:	e8 70 ff ff ff       	call   8024fb <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <sys_env_exit>:

void sys_env_exit(void)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 04                	push   $0x4
  80259f:	e8 57 ff ff ff       	call   8024fb <syscall>
  8025a4:	83 c4 18             	add    $0x18,%esp
}
  8025a7:	90                   	nop
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8025ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	52                   	push   %edx
  8025ba:	50                   	push   %eax
  8025bb:	6a 05                	push   $0x5
  8025bd:	e8 39 ff ff ff       	call   8024fb <syscall>
  8025c2:	83 c4 18             	add    $0x18,%esp
}
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
  8025ca:	56                   	push   %esi
  8025cb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8025cc:	8b 75 18             	mov    0x18(%ebp),%esi
  8025cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	56                   	push   %esi
  8025dc:	53                   	push   %ebx
  8025dd:	51                   	push   %ecx
  8025de:	52                   	push   %edx
  8025df:	50                   	push   %eax
  8025e0:	6a 06                	push   $0x6
  8025e2:	e8 14 ff ff ff       	call   8024fb <syscall>
  8025e7:	83 c4 18             	add    $0x18,%esp
}
  8025ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ed:	5b                   	pop    %ebx
  8025ee:	5e                   	pop    %esi
  8025ef:	5d                   	pop    %ebp
  8025f0:	c3                   	ret    

008025f1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8025f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	52                   	push   %edx
  802601:	50                   	push   %eax
  802602:	6a 07                	push   $0x7
  802604:	e8 f2 fe ff ff       	call   8024fb <syscall>
  802609:	83 c4 18             	add    $0x18,%esp
}
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	ff 75 0c             	pushl  0xc(%ebp)
  80261a:	ff 75 08             	pushl  0x8(%ebp)
  80261d:	6a 08                	push   $0x8
  80261f:	e8 d7 fe ff ff       	call   8024fb <syscall>
  802624:	83 c4 18             	add    $0x18,%esp
}
  802627:	c9                   	leave  
  802628:	c3                   	ret    

00802629 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802629:	55                   	push   %ebp
  80262a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 09                	push   $0x9
  802638:	e8 be fe ff ff       	call   8024fb <syscall>
  80263d:	83 c4 18             	add    $0x18,%esp
}
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 0a                	push   $0xa
  802651:	e8 a5 fe ff ff       	call   8024fb <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 0b                	push   $0xb
  80266a:	e8 8c fe ff ff       	call   8024fb <syscall>
  80266f:	83 c4 18             	add    $0x18,%esp
}
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	ff 75 0c             	pushl  0xc(%ebp)
  802680:	ff 75 08             	pushl  0x8(%ebp)
  802683:	6a 0d                	push   $0xd
  802685:	e8 71 fe ff ff       	call   8024fb <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
	return;
  80268d:	90                   	nop
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 00                	push   $0x0
  802699:	ff 75 0c             	pushl  0xc(%ebp)
  80269c:	ff 75 08             	pushl  0x8(%ebp)
  80269f:	6a 0e                	push   $0xe
  8026a1:	e8 55 fe ff ff       	call   8024fb <syscall>
  8026a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8026a9:	90                   	nop
}
  8026aa:	c9                   	leave  
  8026ab:	c3                   	ret    

008026ac <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 0c                	push   $0xc
  8026bb:	e8 3b fe ff ff       	call   8024fb <syscall>
  8026c0:	83 c4 18             	add    $0x18,%esp
}
  8026c3:	c9                   	leave  
  8026c4:	c3                   	ret    

008026c5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8026c5:	55                   	push   %ebp
  8026c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 10                	push   $0x10
  8026d4:	e8 22 fe ff ff       	call   8024fb <syscall>
  8026d9:	83 c4 18             	add    $0x18,%esp
}
  8026dc:	90                   	nop
  8026dd:	c9                   	leave  
  8026de:	c3                   	ret    

008026df <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 11                	push   $0x11
  8026ee:	e8 08 fe ff ff       	call   8024fb <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp
}
  8026f6:	90                   	nop
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 04             	sub    $0x4,%esp
  8026ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802702:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802705:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	50                   	push   %eax
  802712:	6a 12                	push   $0x12
  802714:	e8 e2 fd ff ff       	call   8024fb <syscall>
  802719:	83 c4 18             	add    $0x18,%esp
}
  80271c:	90                   	nop
  80271d:	c9                   	leave  
  80271e:	c3                   	ret    

0080271f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80271f:	55                   	push   %ebp
  802720:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 13                	push   $0x13
  80272e:	e8 c8 fd ff ff       	call   8024fb <syscall>
  802733:	83 c4 18             	add    $0x18,%esp
}
  802736:	90                   	nop
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	ff 75 0c             	pushl  0xc(%ebp)
  802748:	50                   	push   %eax
  802749:	6a 14                	push   $0x14
  80274b:	e8 ab fd ff ff       	call   8024fb <syscall>
  802750:	83 c4 18             	add    $0x18,%esp
}
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	50                   	push   %eax
  802764:	6a 17                	push   $0x17
  802766:	e8 90 fd ff ff       	call   8024fb <syscall>
  80276b:	83 c4 18             	add    $0x18,%esp
}
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	50                   	push   %eax
  80277f:	6a 15                	push   $0x15
  802781:	e8 75 fd ff ff       	call   8024fb <syscall>
  802786:	83 c4 18             	add    $0x18,%esp
}
  802789:	90                   	nop
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	50                   	push   %eax
  80279b:	6a 16                	push   $0x16
  80279d:	e8 59 fd ff ff       	call   8024fb <syscall>
  8027a2:	83 c4 18             	add    $0x18,%esp
}
  8027a5:	90                   	nop
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
  8027ab:	83 ec 04             	sub    $0x4,%esp
  8027ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8027b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8027b4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027b7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	6a 00                	push   $0x0
  8027c0:	51                   	push   %ecx
  8027c1:	52                   	push   %edx
  8027c2:	ff 75 0c             	pushl  0xc(%ebp)
  8027c5:	50                   	push   %eax
  8027c6:	6a 18                	push   $0x18
  8027c8:	e8 2e fd ff ff       	call   8024fb <syscall>
  8027cd:	83 c4 18             	add    $0x18,%esp
}
  8027d0:	c9                   	leave  
  8027d1:	c3                   	ret    

008027d2 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8027d2:	55                   	push   %ebp
  8027d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8027d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	52                   	push   %edx
  8027e2:	50                   	push   %eax
  8027e3:	6a 19                	push   $0x19
  8027e5:	e8 11 fd ff ff       	call   8024fb <syscall>
  8027ea:	83 c4 18             	add    $0x18,%esp
}
  8027ed:	c9                   	leave  
  8027ee:	c3                   	ret    

008027ef <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	50                   	push   %eax
  8027fe:	6a 1a                	push   $0x1a
  802800:	e8 f6 fc ff ff       	call   8024fb <syscall>
  802805:	83 c4 18             	add    $0x18,%esp
}
  802808:	c9                   	leave  
  802809:	c3                   	ret    

0080280a <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 1b                	push   $0x1b
  802819:	e8 dd fc ff ff       	call   8024fb <syscall>
  80281e:	83 c4 18             	add    $0x18,%esp
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 1c                	push   $0x1c
  802832:	e8 c4 fc ff ff       	call   8024fb <syscall>
  802837:	83 c4 18             	add    $0x18,%esp
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	ff 75 0c             	pushl  0xc(%ebp)
  80284b:	50                   	push   %eax
  80284c:	6a 1d                	push   $0x1d
  80284e:	e8 a8 fc ff ff       	call   8024fb <syscall>
  802853:	83 c4 18             	add    $0x18,%esp
}
  802856:	c9                   	leave  
  802857:	c3                   	ret    

00802858 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802858:	55                   	push   %ebp
  802859:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	6a 00                	push   $0x0
  802860:	6a 00                	push   $0x0
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	50                   	push   %eax
  802867:	6a 1e                	push   $0x1e
  802869:	e8 8d fc ff ff       	call   8024fb <syscall>
  80286e:	83 c4 18             	add    $0x18,%esp
}
  802871:	90                   	nop
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	6a 00                	push   $0x0
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	50                   	push   %eax
  802883:	6a 1f                	push   $0x1f
  802885:	e8 71 fc ff ff       	call   8024fb <syscall>
  80288a:	83 c4 18             	add    $0x18,%esp
}
  80288d:	90                   	nop
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802896:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802899:	8d 50 04             	lea    0x4(%eax),%edx
  80289c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	52                   	push   %edx
  8028a6:	50                   	push   %eax
  8028a7:	6a 20                	push   $0x20
  8028a9:	e8 4d fc ff ff       	call   8024fb <syscall>
  8028ae:	83 c4 18             	add    $0x18,%esp
	return result;
  8028b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028ba:	89 01                	mov    %eax,(%ecx)
  8028bc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	c9                   	leave  
  8028c3:	c2 04 00             	ret    $0x4

008028c6 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	ff 75 10             	pushl  0x10(%ebp)
  8028d0:	ff 75 0c             	pushl  0xc(%ebp)
  8028d3:	ff 75 08             	pushl  0x8(%ebp)
  8028d6:	6a 0f                	push   $0xf
  8028d8:	e8 1e fc ff ff       	call   8024fb <syscall>
  8028dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e0:	90                   	nop
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 21                	push   $0x21
  8028f2:	e8 04 fc ff ff       	call   8024fb <syscall>
  8028f7:	83 c4 18             	add    $0x18,%esp
}
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	83 ec 04             	sub    $0x4,%esp
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802908:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	6a 00                	push   $0x0
  802912:	6a 00                	push   $0x0
  802914:	50                   	push   %eax
  802915:	6a 22                	push   $0x22
  802917:	e8 df fb ff ff       	call   8024fb <syscall>
  80291c:	83 c4 18             	add    $0x18,%esp
	return ;
  80291f:	90                   	nop
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    

00802922 <rsttst>:
void rsttst()
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 24                	push   $0x24
  802931:	e8 c5 fb ff ff       	call   8024fb <syscall>
  802936:	83 c4 18             	add    $0x18,%esp
	return ;
  802939:	90                   	nop
}
  80293a:	c9                   	leave  
  80293b:	c3                   	ret    

0080293c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80293c:	55                   	push   %ebp
  80293d:	89 e5                	mov    %esp,%ebp
  80293f:	83 ec 04             	sub    $0x4,%esp
  802942:	8b 45 14             	mov    0x14(%ebp),%eax
  802945:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802948:	8b 55 18             	mov    0x18(%ebp),%edx
  80294b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80294f:	52                   	push   %edx
  802950:	50                   	push   %eax
  802951:	ff 75 10             	pushl  0x10(%ebp)
  802954:	ff 75 0c             	pushl  0xc(%ebp)
  802957:	ff 75 08             	pushl  0x8(%ebp)
  80295a:	6a 23                	push   $0x23
  80295c:	e8 9a fb ff ff       	call   8024fb <syscall>
  802961:	83 c4 18             	add    $0x18,%esp
	return ;
  802964:	90                   	nop
}
  802965:	c9                   	leave  
  802966:	c3                   	ret    

00802967 <chktst>:
void chktst(uint32 n)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80296a:	6a 00                	push   $0x0
  80296c:	6a 00                	push   $0x0
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	ff 75 08             	pushl  0x8(%ebp)
  802975:	6a 25                	push   $0x25
  802977:	e8 7f fb ff ff       	call   8024fb <syscall>
  80297c:	83 c4 18             	add    $0x18,%esp
	return ;
  80297f:	90                   	nop
}
  802980:	c9                   	leave  
  802981:	c3                   	ret    

00802982 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802982:	55                   	push   %ebp
  802983:	89 e5                	mov    %esp,%ebp
  802985:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802988:	6a 00                	push   $0x0
  80298a:	6a 00                	push   $0x0
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	6a 26                	push   $0x26
  802994:	e8 62 fb ff ff       	call   8024fb <syscall>
  802999:	83 c4 18             	add    $0x18,%esp
  80299c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80299f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8029a3:	75 07                	jne    8029ac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8029a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8029aa:	eb 05                	jmp    8029b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8029ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b1:	c9                   	leave  
  8029b2:	c3                   	ret    

008029b3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8029b3:	55                   	push   %ebp
  8029b4:	89 e5                	mov    %esp,%ebp
  8029b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 26                	push   $0x26
  8029c5:	e8 31 fb ff ff       	call   8024fb <syscall>
  8029ca:	83 c4 18             	add    $0x18,%esp
  8029cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8029d0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8029d4:	75 07                	jne    8029dd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8029d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029db:	eb 05                	jmp    8029e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e2:	c9                   	leave  
  8029e3:	c3                   	ret    

008029e4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8029e4:	55                   	push   %ebp
  8029e5:	89 e5                	mov    %esp,%ebp
  8029e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 26                	push   $0x26
  8029f6:	e8 00 fb ff ff       	call   8024fb <syscall>
  8029fb:	83 c4 18             	add    $0x18,%esp
  8029fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802a01:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802a05:	75 07                	jne    802a0e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a07:	b8 01 00 00 00       	mov    $0x1,%eax
  802a0c:	eb 05                	jmp    802a13 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

00802a15 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	6a 26                	push   $0x26
  802a27:	e8 cf fa ff ff       	call   8024fb <syscall>
  802a2c:	83 c4 18             	add    $0x18,%esp
  802a2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a32:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a36:	75 07                	jne    802a3f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a38:	b8 01 00 00 00       	mov    $0x1,%eax
  802a3d:	eb 05                	jmp    802a44 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a44:	c9                   	leave  
  802a45:	c3                   	ret    

00802a46 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	ff 75 08             	pushl  0x8(%ebp)
  802a54:	6a 27                	push   $0x27
  802a56:	e8 a0 fa ff ff       	call   8024fb <syscall>
  802a5b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a5e:	90                   	nop
}
  802a5f:	c9                   	leave  
  802a60:	c3                   	ret    
  802a61:	66 90                	xchg   %ax,%ax
  802a63:	90                   	nop

00802a64 <__udivdi3>:
  802a64:	55                   	push   %ebp
  802a65:	57                   	push   %edi
  802a66:	56                   	push   %esi
  802a67:	53                   	push   %ebx
  802a68:	83 ec 1c             	sub    $0x1c,%esp
  802a6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a7b:	89 ca                	mov    %ecx,%edx
  802a7d:	89 f8                	mov    %edi,%eax
  802a7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a83:	85 f6                	test   %esi,%esi
  802a85:	75 2d                	jne    802ab4 <__udivdi3+0x50>
  802a87:	39 cf                	cmp    %ecx,%edi
  802a89:	77 65                	ja     802af0 <__udivdi3+0x8c>
  802a8b:	89 fd                	mov    %edi,%ebp
  802a8d:	85 ff                	test   %edi,%edi
  802a8f:	75 0b                	jne    802a9c <__udivdi3+0x38>
  802a91:	b8 01 00 00 00       	mov    $0x1,%eax
  802a96:	31 d2                	xor    %edx,%edx
  802a98:	f7 f7                	div    %edi
  802a9a:	89 c5                	mov    %eax,%ebp
  802a9c:	31 d2                	xor    %edx,%edx
  802a9e:	89 c8                	mov    %ecx,%eax
  802aa0:	f7 f5                	div    %ebp
  802aa2:	89 c1                	mov    %eax,%ecx
  802aa4:	89 d8                	mov    %ebx,%eax
  802aa6:	f7 f5                	div    %ebp
  802aa8:	89 cf                	mov    %ecx,%edi
  802aaa:	89 fa                	mov    %edi,%edx
  802aac:	83 c4 1c             	add    $0x1c,%esp
  802aaf:	5b                   	pop    %ebx
  802ab0:	5e                   	pop    %esi
  802ab1:	5f                   	pop    %edi
  802ab2:	5d                   	pop    %ebp
  802ab3:	c3                   	ret    
  802ab4:	39 ce                	cmp    %ecx,%esi
  802ab6:	77 28                	ja     802ae0 <__udivdi3+0x7c>
  802ab8:	0f bd fe             	bsr    %esi,%edi
  802abb:	83 f7 1f             	xor    $0x1f,%edi
  802abe:	75 40                	jne    802b00 <__udivdi3+0x9c>
  802ac0:	39 ce                	cmp    %ecx,%esi
  802ac2:	72 0a                	jb     802ace <__udivdi3+0x6a>
  802ac4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ac8:	0f 87 9e 00 00 00    	ja     802b6c <__udivdi3+0x108>
  802ace:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad3:	89 fa                	mov    %edi,%edx
  802ad5:	83 c4 1c             	add    $0x1c,%esp
  802ad8:	5b                   	pop    %ebx
  802ad9:	5e                   	pop    %esi
  802ada:	5f                   	pop    %edi
  802adb:	5d                   	pop    %ebp
  802adc:	c3                   	ret    
  802add:	8d 76 00             	lea    0x0(%esi),%esi
  802ae0:	31 ff                	xor    %edi,%edi
  802ae2:	31 c0                	xor    %eax,%eax
  802ae4:	89 fa                	mov    %edi,%edx
  802ae6:	83 c4 1c             	add    $0x1c,%esp
  802ae9:	5b                   	pop    %ebx
  802aea:	5e                   	pop    %esi
  802aeb:	5f                   	pop    %edi
  802aec:	5d                   	pop    %ebp
  802aed:	c3                   	ret    
  802aee:	66 90                	xchg   %ax,%ax
  802af0:	89 d8                	mov    %ebx,%eax
  802af2:	f7 f7                	div    %edi
  802af4:	31 ff                	xor    %edi,%edi
  802af6:	89 fa                	mov    %edi,%edx
  802af8:	83 c4 1c             	add    $0x1c,%esp
  802afb:	5b                   	pop    %ebx
  802afc:	5e                   	pop    %esi
  802afd:	5f                   	pop    %edi
  802afe:	5d                   	pop    %ebp
  802aff:	c3                   	ret    
  802b00:	bd 20 00 00 00       	mov    $0x20,%ebp
  802b05:	89 eb                	mov    %ebp,%ebx
  802b07:	29 fb                	sub    %edi,%ebx
  802b09:	89 f9                	mov    %edi,%ecx
  802b0b:	d3 e6                	shl    %cl,%esi
  802b0d:	89 c5                	mov    %eax,%ebp
  802b0f:	88 d9                	mov    %bl,%cl
  802b11:	d3 ed                	shr    %cl,%ebp
  802b13:	89 e9                	mov    %ebp,%ecx
  802b15:	09 f1                	or     %esi,%ecx
  802b17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802b1b:	89 f9                	mov    %edi,%ecx
  802b1d:	d3 e0                	shl    %cl,%eax
  802b1f:	89 c5                	mov    %eax,%ebp
  802b21:	89 d6                	mov    %edx,%esi
  802b23:	88 d9                	mov    %bl,%cl
  802b25:	d3 ee                	shr    %cl,%esi
  802b27:	89 f9                	mov    %edi,%ecx
  802b29:	d3 e2                	shl    %cl,%edx
  802b2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b2f:	88 d9                	mov    %bl,%cl
  802b31:	d3 e8                	shr    %cl,%eax
  802b33:	09 c2                	or     %eax,%edx
  802b35:	89 d0                	mov    %edx,%eax
  802b37:	89 f2                	mov    %esi,%edx
  802b39:	f7 74 24 0c          	divl   0xc(%esp)
  802b3d:	89 d6                	mov    %edx,%esi
  802b3f:	89 c3                	mov    %eax,%ebx
  802b41:	f7 e5                	mul    %ebp
  802b43:	39 d6                	cmp    %edx,%esi
  802b45:	72 19                	jb     802b60 <__udivdi3+0xfc>
  802b47:	74 0b                	je     802b54 <__udivdi3+0xf0>
  802b49:	89 d8                	mov    %ebx,%eax
  802b4b:	31 ff                	xor    %edi,%edi
  802b4d:	e9 58 ff ff ff       	jmp    802aaa <__udivdi3+0x46>
  802b52:	66 90                	xchg   %ax,%ax
  802b54:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b58:	89 f9                	mov    %edi,%ecx
  802b5a:	d3 e2                	shl    %cl,%edx
  802b5c:	39 c2                	cmp    %eax,%edx
  802b5e:	73 e9                	jae    802b49 <__udivdi3+0xe5>
  802b60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b63:	31 ff                	xor    %edi,%edi
  802b65:	e9 40 ff ff ff       	jmp    802aaa <__udivdi3+0x46>
  802b6a:	66 90                	xchg   %ax,%ax
  802b6c:	31 c0                	xor    %eax,%eax
  802b6e:	e9 37 ff ff ff       	jmp    802aaa <__udivdi3+0x46>
  802b73:	90                   	nop

00802b74 <__umoddi3>:
  802b74:	55                   	push   %ebp
  802b75:	57                   	push   %edi
  802b76:	56                   	push   %esi
  802b77:	53                   	push   %ebx
  802b78:	83 ec 1c             	sub    $0x1c,%esp
  802b7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b93:	89 f3                	mov    %esi,%ebx
  802b95:	89 fa                	mov    %edi,%edx
  802b97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b9b:	89 34 24             	mov    %esi,(%esp)
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	75 1a                	jne    802bbc <__umoddi3+0x48>
  802ba2:	39 f7                	cmp    %esi,%edi
  802ba4:	0f 86 a2 00 00 00    	jbe    802c4c <__umoddi3+0xd8>
  802baa:	89 c8                	mov    %ecx,%eax
  802bac:	89 f2                	mov    %esi,%edx
  802bae:	f7 f7                	div    %edi
  802bb0:	89 d0                	mov    %edx,%eax
  802bb2:	31 d2                	xor    %edx,%edx
  802bb4:	83 c4 1c             	add    $0x1c,%esp
  802bb7:	5b                   	pop    %ebx
  802bb8:	5e                   	pop    %esi
  802bb9:	5f                   	pop    %edi
  802bba:	5d                   	pop    %ebp
  802bbb:	c3                   	ret    
  802bbc:	39 f0                	cmp    %esi,%eax
  802bbe:	0f 87 ac 00 00 00    	ja     802c70 <__umoddi3+0xfc>
  802bc4:	0f bd e8             	bsr    %eax,%ebp
  802bc7:	83 f5 1f             	xor    $0x1f,%ebp
  802bca:	0f 84 ac 00 00 00    	je     802c7c <__umoddi3+0x108>
  802bd0:	bf 20 00 00 00       	mov    $0x20,%edi
  802bd5:	29 ef                	sub    %ebp,%edi
  802bd7:	89 fe                	mov    %edi,%esi
  802bd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bdd:	89 e9                	mov    %ebp,%ecx
  802bdf:	d3 e0                	shl    %cl,%eax
  802be1:	89 d7                	mov    %edx,%edi
  802be3:	89 f1                	mov    %esi,%ecx
  802be5:	d3 ef                	shr    %cl,%edi
  802be7:	09 c7                	or     %eax,%edi
  802be9:	89 e9                	mov    %ebp,%ecx
  802beb:	d3 e2                	shl    %cl,%edx
  802bed:	89 14 24             	mov    %edx,(%esp)
  802bf0:	89 d8                	mov    %ebx,%eax
  802bf2:	d3 e0                	shl    %cl,%eax
  802bf4:	89 c2                	mov    %eax,%edx
  802bf6:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bfa:	d3 e0                	shl    %cl,%eax
  802bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c00:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c04:	89 f1                	mov    %esi,%ecx
  802c06:	d3 e8                	shr    %cl,%eax
  802c08:	09 d0                	or     %edx,%eax
  802c0a:	d3 eb                	shr    %cl,%ebx
  802c0c:	89 da                	mov    %ebx,%edx
  802c0e:	f7 f7                	div    %edi
  802c10:	89 d3                	mov    %edx,%ebx
  802c12:	f7 24 24             	mull   (%esp)
  802c15:	89 c6                	mov    %eax,%esi
  802c17:	89 d1                	mov    %edx,%ecx
  802c19:	39 d3                	cmp    %edx,%ebx
  802c1b:	0f 82 87 00 00 00    	jb     802ca8 <__umoddi3+0x134>
  802c21:	0f 84 91 00 00 00    	je     802cb8 <__umoddi3+0x144>
  802c27:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c2b:	29 f2                	sub    %esi,%edx
  802c2d:	19 cb                	sbb    %ecx,%ebx
  802c2f:	89 d8                	mov    %ebx,%eax
  802c31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c35:	d3 e0                	shl    %cl,%eax
  802c37:	89 e9                	mov    %ebp,%ecx
  802c39:	d3 ea                	shr    %cl,%edx
  802c3b:	09 d0                	or     %edx,%eax
  802c3d:	89 e9                	mov    %ebp,%ecx
  802c3f:	d3 eb                	shr    %cl,%ebx
  802c41:	89 da                	mov    %ebx,%edx
  802c43:	83 c4 1c             	add    $0x1c,%esp
  802c46:	5b                   	pop    %ebx
  802c47:	5e                   	pop    %esi
  802c48:	5f                   	pop    %edi
  802c49:	5d                   	pop    %ebp
  802c4a:	c3                   	ret    
  802c4b:	90                   	nop
  802c4c:	89 fd                	mov    %edi,%ebp
  802c4e:	85 ff                	test   %edi,%edi
  802c50:	75 0b                	jne    802c5d <__umoddi3+0xe9>
  802c52:	b8 01 00 00 00       	mov    $0x1,%eax
  802c57:	31 d2                	xor    %edx,%edx
  802c59:	f7 f7                	div    %edi
  802c5b:	89 c5                	mov    %eax,%ebp
  802c5d:	89 f0                	mov    %esi,%eax
  802c5f:	31 d2                	xor    %edx,%edx
  802c61:	f7 f5                	div    %ebp
  802c63:	89 c8                	mov    %ecx,%eax
  802c65:	f7 f5                	div    %ebp
  802c67:	89 d0                	mov    %edx,%eax
  802c69:	e9 44 ff ff ff       	jmp    802bb2 <__umoddi3+0x3e>
  802c6e:	66 90                	xchg   %ax,%ax
  802c70:	89 c8                	mov    %ecx,%eax
  802c72:	89 f2                	mov    %esi,%edx
  802c74:	83 c4 1c             	add    $0x1c,%esp
  802c77:	5b                   	pop    %ebx
  802c78:	5e                   	pop    %esi
  802c79:	5f                   	pop    %edi
  802c7a:	5d                   	pop    %ebp
  802c7b:	c3                   	ret    
  802c7c:	3b 04 24             	cmp    (%esp),%eax
  802c7f:	72 06                	jb     802c87 <__umoddi3+0x113>
  802c81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c85:	77 0f                	ja     802c96 <__umoddi3+0x122>
  802c87:	89 f2                	mov    %esi,%edx
  802c89:	29 f9                	sub    %edi,%ecx
  802c8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c8f:	89 14 24             	mov    %edx,(%esp)
  802c92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c96:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c9a:	8b 14 24             	mov    (%esp),%edx
  802c9d:	83 c4 1c             	add    $0x1c,%esp
  802ca0:	5b                   	pop    %ebx
  802ca1:	5e                   	pop    %esi
  802ca2:	5f                   	pop    %edi
  802ca3:	5d                   	pop    %ebp
  802ca4:	c3                   	ret    
  802ca5:	8d 76 00             	lea    0x0(%esi),%esi
  802ca8:	2b 04 24             	sub    (%esp),%eax
  802cab:	19 fa                	sbb    %edi,%edx
  802cad:	89 d1                	mov    %edx,%ecx
  802caf:	89 c6                	mov    %eax,%esi
  802cb1:	e9 71 ff ff ff       	jmp    802c27 <__umoddi3+0xb3>
  802cb6:	66 90                	xchg   %ax,%ax
  802cb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802cbc:	72 ea                	jb     802ca8 <__umoddi3+0x134>
  802cbe:	89 d9                	mov    %ebx,%ecx
  802cc0:	e9 62 ff ff ff       	jmp    802c27 <__umoddi3+0xb3>
