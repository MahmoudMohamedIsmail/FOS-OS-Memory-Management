
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 81 07 00 00       	call   8007b7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	int envID = sys_getenvid();
  800040:	e8 ff 21 00 00       	call   802244 <sys_getenvid>
  800045:	89 45 f4             	mov    %eax,-0xc(%ebp)

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80004b:	89 d0                	mov    %edx,%eax
  80004d:	c1 e0 03             	shl    $0x3,%eax
  800050:	01 d0                	add    %edx,%eax
  800052:	01 c0                	add    %eax,%eax
  800054:	01 d0                	add    %edx,%eax
  800056:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	6a 01                	push   $0x1
  80006f:	e8 9f 26 00 00       	call   802713 <sys_set_uheap_strategy>
  800074:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  800077:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  80007e:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  800085:	8d 55 90             	lea    -0x70(%ebp),%edx
  800088:	b9 14 00 00 00       	mov    $0x14,%ecx
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	89 d7                	mov    %edx,%edi
  800094:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 01 00 00 20       	push   $0x20000001
  80009e:	e8 83 16 00 00       	call   801726 <malloc>
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000a9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ac:	85 c0                	test   %eax,%eax
  8000ae:	74 14                	je     8000c4 <_main+0x8c>
  8000b0:	83 ec 04             	sub    $0x4,%esp
  8000b3:	68 a0 29 80 00       	push   $0x8029a0
  8000b8:	6a 1c                	push   $0x1c
  8000ba:	68 e4 29 80 00       	push   $0x8029e4
  8000bf:	e8 b4 07 00 00       	call   800878 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  8000c4:	e8 2d 22 00 00       	call   8022f6 <sys_calculate_free_frames>
  8000c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cc:	e8 a8 22 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8000d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 41 16 00 00       	call   801726 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] >  (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	79 0a                	jns    8000fc <_main+0xc4>
  8000f2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f5:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000fa:	76 14                	jbe    800110 <_main+0xd8>
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	68 fc 29 80 00       	push   $0x8029fc
  800104:	6a 25                	push   $0x25
  800106:	68 e4 29 80 00       	push   $0x8029e4
  80010b:	e8 68 07 00 00       	call   800878 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800110:	e8 64 22 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800115:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800118:	3d 00 02 00 00       	cmp    $0x200,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 2c 2a 80 00       	push   $0x802a2c
  800127:	6a 27                	push   $0x27
  800129:	68 e4 29 80 00       	push   $0x8029e4
  80012e:	e8 45 07 00 00       	call   800878 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800133:	e8 be 21 00 00       	call   8022f6 <sys_calculate_free_frames>
  800138:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80013b:	e8 39 22 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800140:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800146:	01 c0                	add    %eax,%eax
  800148:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	50                   	push   %eax
  80014f:	e8 d2 15 00 00       	call   801726 <malloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80015a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80015d:	89 c2                	mov    %eax,%edx
  80015f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800162:	01 c0                	add    %eax,%eax
  800164:	05 00 00 00 80       	add    $0x80000000,%eax
  800169:	39 c2                	cmp    %eax,%edx
  80016b:	72 13                	jb     800180 <_main+0x148>
  80016d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800170:	89 c2                	mov    %eax,%edx
  800172:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800175:	01 c0                	add    %eax,%eax
  800177:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80017c:	39 c2                	cmp    %eax,%edx
  80017e:	76 14                	jbe    800194 <_main+0x15c>
  800180:	83 ec 04             	sub    $0x4,%esp
  800183:	68 fc 29 80 00       	push   $0x8029fc
  800188:	6a 2d                	push   $0x2d
  80018a:	68 e4 29 80 00       	push   $0x8029e4
  80018f:	e8 e4 06 00 00       	call   800878 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800194:	e8 e0 21 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800199:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80019c:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 2c 2a 80 00       	push   $0x802a2c
  8001ab:	6a 2f                	push   $0x2f
  8001ad:	68 e4 29 80 00       	push   $0x8029e4
  8001b2:	e8 c1 06 00 00       	call   800878 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001b7:	e8 3a 21 00 00       	call   8022f6 <sys_calculate_free_frames>
  8001bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001bf:	e8 b5 21 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8001c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ca:	01 c0                	add    %eax,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 51 15 00 00       	call   801726 <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001de:	89 c2                	mov    %eax,%edx
  8001e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e3:	c1 e0 02             	shl    $0x2,%eax
  8001e6:	05 00 00 00 80       	add    $0x80000000,%eax
  8001eb:	39 c2                	cmp    %eax,%edx
  8001ed:	72 14                	jb     800203 <_main+0x1cb>
  8001ef:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001f2:	89 c2                	mov    %eax,%edx
  8001f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f7:	c1 e0 02             	shl    $0x2,%eax
  8001fa:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8001ff:	39 c2                	cmp    %eax,%edx
  800201:	76 14                	jbe    800217 <_main+0x1df>
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	68 fc 29 80 00       	push   $0x8029fc
  80020b:	6a 35                	push   $0x35
  80020d:	68 e4 29 80 00       	push   $0x8029e4
  800212:	e8 61 06 00 00       	call   800878 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  800217:	e8 5d 21 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  80021c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80021f:	83 f8 01             	cmp    $0x1,%eax
  800222:	74 14                	je     800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 2c 2a 80 00       	push   $0x802a2c
  80022c:	6a 37                	push   $0x37
  80022e:	68 e4 29 80 00       	push   $0x8029e4
  800233:	e8 40 06 00 00       	call   800878 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800238:	e8 b9 20 00 00       	call   8022f6 <sys_calculate_free_frames>
  80023d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800240:	e8 34 21 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800245:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024b:	01 c0                	add    %eax,%eax
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	50                   	push   %eax
  800251:	e8 d0 14 00 00       	call   801726 <malloc>
  800256:	83 c4 10             	add    $0x10,%esp
  800259:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80025c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80025f:	89 c2                	mov    %eax,%edx
  800261:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800264:	c1 e0 02             	shl    $0x2,%eax
  800267:	89 c1                	mov    %eax,%ecx
  800269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80026c:	c1 e0 02             	shl    $0x2,%eax
  80026f:	01 c8                	add    %ecx,%eax
  800271:	05 00 00 00 80       	add    $0x80000000,%eax
  800276:	39 c2                	cmp    %eax,%edx
  800278:	72 1e                	jb     800298 <_main+0x260>
  80027a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	89 c1                	mov    %eax,%ecx
  800287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028a:	c1 e0 02             	shl    $0x2,%eax
  80028d:	01 c8                	add    %ecx,%eax
  80028f:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800294:	39 c2                	cmp    %eax,%edx
  800296:	76 14                	jbe    8002ac <_main+0x274>
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	68 fc 29 80 00       	push   $0x8029fc
  8002a0:	6a 3d                	push   $0x3d
  8002a2:	68 e4 29 80 00       	push   $0x8029e4
  8002a7:	e8 cc 05 00 00       	call   800878 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002ac:	e8 c8 20 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8002b1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002b4:	83 f8 01             	cmp    $0x1,%eax
  8002b7:	74 14                	je     8002cd <_main+0x295>
  8002b9:	83 ec 04             	sub    $0x4,%esp
  8002bc:	68 2c 2a 80 00       	push   $0x802a2c
  8002c1:	6a 3f                	push   $0x3f
  8002c3:	68 e4 29 80 00       	push   $0x8029e4
  8002c8:	e8 ab 05 00 00       	call   800878 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002cd:	e8 24 20 00 00       	call   8022f6 <sys_calculate_free_frames>
  8002d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002d5:	e8 9f 20 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8002da:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002dd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	50                   	push   %eax
  8002e4:	e8 df 1d 00 00       	call   8020c8 <free>
  8002e9:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002ec:	e8 88 20 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8002f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002f4:	29 c2                	sub    %eax,%edx
  8002f6:	89 d0                	mov    %edx,%eax
  8002f8:	83 f8 01             	cmp    $0x1,%eax
  8002fb:	74 14                	je     800311 <_main+0x2d9>
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	68 49 2a 80 00       	push   $0x802a49
  800305:	6a 46                	push   $0x46
  800307:	68 e4 29 80 00       	push   $0x8029e4
  80030c:	e8 67 05 00 00       	call   800878 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800311:	e8 e0 1f 00 00       	call   8022f6 <sys_calculate_free_frames>
  800316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800319:	e8 5b 20 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  80031e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800321:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800324:	89 d0                	mov    %edx,%eax
  800326:	01 c0                	add    %eax,%eax
  800328:	01 d0                	add    %edx,%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	50                   	push   %eax
  800332:	e8 ef 13 00 00       	call   801726 <malloc>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80033d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800340:	89 c2                	mov    %eax,%edx
  800342:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800345:	c1 e0 02             	shl    $0x2,%eax
  800348:	89 c1                	mov    %eax,%ecx
  80034a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80034d:	c1 e0 03             	shl    $0x3,%eax
  800350:	01 c8                	add    %ecx,%eax
  800352:	05 00 00 00 80       	add    $0x80000000,%eax
  800357:	39 c2                	cmp    %eax,%edx
  800359:	72 1e                	jb     800379 <_main+0x341>
  80035b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035e:	89 c2                	mov    %eax,%edx
  800360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800363:	c1 e0 02             	shl    $0x2,%eax
  800366:	89 c1                	mov    %eax,%ecx
  800368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80036b:	c1 e0 03             	shl    $0x3,%eax
  80036e:	01 c8                	add    %ecx,%eax
  800370:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800375:	39 c2                	cmp    %eax,%edx
  800377:	76 14                	jbe    80038d <_main+0x355>
  800379:	83 ec 04             	sub    $0x4,%esp
  80037c:	68 fc 29 80 00       	push   $0x8029fc
  800381:	6a 4c                	push   $0x4c
  800383:	68 e4 29 80 00       	push   $0x8029e4
  800388:	e8 eb 04 00 00       	call   800878 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  80038d:	e8 e7 1f 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800392:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800395:	83 f8 02             	cmp    $0x2,%eax
  800398:	74 14                	je     8003ae <_main+0x376>
  80039a:	83 ec 04             	sub    $0x4,%esp
  80039d:	68 2c 2a 80 00       	push   $0x802a2c
  8003a2:	6a 4e                	push   $0x4e
  8003a4:	68 e4 29 80 00       	push   $0x8029e4
  8003a9:	e8 ca 04 00 00       	call   800878 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8003ae:	e8 43 1f 00 00       	call   8022f6 <sys_calculate_free_frames>
  8003b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b6:	e8 be 1f 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  8003be:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003c1:	83 ec 0c             	sub    $0xc,%esp
  8003c4:	50                   	push   %eax
  8003c5:	e8 fe 1c 00 00       	call   8020c8 <free>
  8003ca:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003cd:	e8 a7 1f 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8003d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d5:	29 c2                	sub    %eax,%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003de:	74 14                	je     8003f4 <_main+0x3bc>
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	68 49 2a 80 00       	push   $0x802a49
  8003e8:	6a 55                	push   $0x55
  8003ea:	68 e4 29 80 00       	push   $0x8029e4
  8003ef:	e8 84 04 00 00       	call   800878 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003f4:	e8 fd 1e 00 00       	call   8022f6 <sys_calculate_free_frames>
  8003f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003fc:	e8 78 1f 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800401:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	89 c2                	mov    %eax,%edx
  800409:	01 d2                	add    %edx,%edx
  80040b:	01 d0                	add    %edx,%eax
  80040d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	50                   	push   %eax
  800414:	e8 0d 13 00 00       	call   801726 <malloc>
  800419:	83 c4 10             	add    $0x10,%esp
  80041c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80041f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800427:	c1 e0 02             	shl    $0x2,%eax
  80042a:	89 c1                	mov    %eax,%ecx
  80042c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80042f:	c1 e0 04             	shl    $0x4,%eax
  800432:	01 c8                	add    %ecx,%eax
  800434:	05 00 00 00 80       	add    $0x80000000,%eax
  800439:	39 c2                	cmp    %eax,%edx
  80043b:	72 1e                	jb     80045b <_main+0x423>
  80043d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800440:	89 c2                	mov    %eax,%edx
  800442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800445:	c1 e0 02             	shl    $0x2,%eax
  800448:	89 c1                	mov    %eax,%ecx
  80044a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044d:	c1 e0 04             	shl    $0x4,%eax
  800450:	01 c8                	add    %ecx,%eax
  800452:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800457:	39 c2                	cmp    %eax,%edx
  800459:	76 14                	jbe    80046f <_main+0x437>
  80045b:	83 ec 04             	sub    $0x4,%esp
  80045e:	68 fc 29 80 00       	push   $0x8029fc
  800463:	6a 5b                	push   $0x5b
  800465:	68 e4 29 80 00       	push   $0x8029e4
  80046a:	e8 09 04 00 00       	call   800878 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  80046f:	e8 05 1f 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800474:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800477:	89 c2                	mov    %eax,%edx
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	89 c1                	mov    %eax,%ecx
  80047e:	01 c9                	add    %ecx,%ecx
  800480:	01 c8                	add    %ecx,%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	79 05                	jns    80048b <_main+0x453>
  800486:	05 ff 0f 00 00       	add    $0xfff,%eax
  80048b:	c1 f8 0c             	sar    $0xc,%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	74 14                	je     8004a6 <_main+0x46e>
  800492:	83 ec 04             	sub    $0x4,%esp
  800495:	68 2c 2a 80 00       	push   $0x802a2c
  80049a:	6a 5d                	push   $0x5d
  80049c:	68 e4 29 80 00       	push   $0x8029e4
  8004a1:	e8 d2 03 00 00       	call   800878 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  8004a6:	e8 4b 1e 00 00       	call   8022f6 <sys_calculate_free_frames>
  8004ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ae:	e8 c6 1e 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8004b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  8004b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b9:	89 c2                	mov    %eax,%edx
  8004bb:	01 d2                	add    %edx,%edx
  8004bd:	01 c2                	add    %eax,%edx
  8004bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c2:	01 d0                	add    %edx,%eax
  8004c4:	01 c0                	add    %eax,%eax
  8004c6:	83 ec 0c             	sub    $0xc,%esp
  8004c9:	50                   	push   %eax
  8004ca:	e8 57 12 00 00       	call   801726 <malloc>
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004d5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d8:	89 c1                	mov    %eax,%ecx
  8004da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	01 c0                	add    %eax,%eax
  8004e5:	01 d0                	add    %edx,%eax
  8004e7:	89 c2                	mov    %eax,%edx
  8004e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ec:	c1 e0 04             	shl    $0x4,%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	05 00 00 00 80       	add    $0x80000000,%eax
  8004f6:	39 c1                	cmp    %eax,%ecx
  8004f8:	72 25                	jb     80051f <_main+0x4e7>
  8004fa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004fd:	89 c1                	mov    %eax,%ecx
  8004ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800502:	89 d0                	mov    %edx,%eax
  800504:	01 c0                	add    %eax,%eax
  800506:	01 d0                	add    %edx,%eax
  800508:	01 c0                	add    %eax,%eax
  80050a:	01 d0                	add    %edx,%eax
  80050c:	89 c2                	mov    %eax,%edx
  80050e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800511:	c1 e0 04             	shl    $0x4,%eax
  800514:	01 d0                	add    %edx,%eax
  800516:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80051b:	39 c1                	cmp    %eax,%ecx
  80051d:	76 14                	jbe    800533 <_main+0x4fb>
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	68 fc 29 80 00       	push   $0x8029fc
  800527:	6a 63                	push   $0x63
  800529:	68 e4 29 80 00       	push   $0x8029e4
  80052e:	e8 45 03 00 00       	call   800878 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  800533:	e8 41 1e 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800538:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80053b:	3d 02 02 00 00       	cmp    $0x202,%eax
  800540:	74 14                	je     800556 <_main+0x51e>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 2c 2a 80 00       	push   $0x802a2c
  80054a:	6a 65                	push   $0x65
  80054c:	68 e4 29 80 00       	push   $0x8029e4
  800551:	e8 22 03 00 00       	call   800878 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800556:	e8 9b 1d 00 00       	call   8022f6 <sys_calculate_free_frames>
  80055b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80055e:	e8 16 1e 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800563:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  800566:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800569:	83 ec 0c             	sub    $0xc,%esp
  80056c:	50                   	push   %eax
  80056d:	e8 56 1b 00 00       	call   8020c8 <free>
  800572:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800575:	e8 ff 1d 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  80057a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80057d:	29 c2                	sub    %eax,%edx
  80057f:	89 d0                	mov    %edx,%eax
  800581:	3d 00 03 00 00       	cmp    $0x300,%eax
  800586:	74 14                	je     80059c <_main+0x564>
  800588:	83 ec 04             	sub    $0x4,%esp
  80058b:	68 49 2a 80 00       	push   $0x802a49
  800590:	6a 6c                	push   $0x6c
  800592:	68 e4 29 80 00       	push   $0x8029e4
  800597:	e8 dc 02 00 00       	call   800878 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80059c:	e8 55 1d 00 00       	call   8022f6 <sys_calculate_free_frames>
  8005a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a4:	e8 d0 1d 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8005a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8005ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	c1 e0 02             	shl    $0x2,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8005b9:	83 ec 0c             	sub    $0xc,%esp
  8005bc:	50                   	push   %eax
  8005bd:	e8 64 11 00 00       	call   801726 <malloc>
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 9*Mega + 24*kilo) || (uint32) ptr_allocations[7] > (USER_HEAP_START + 9*Mega + 24*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8005c8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005cb:	89 c1                	mov    %eax,%ecx
  8005cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005d0:	89 d0                	mov    %edx,%eax
  8005d2:	c1 e0 03             	shl    $0x3,%eax
  8005d5:	01 d0                	add    %edx,%eax
  8005d7:	89 c3                	mov    %eax,%ebx
  8005d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005dc:	89 d0                	mov    %edx,%eax
  8005de:	01 c0                	add    %eax,%eax
  8005e0:	01 d0                	add    %edx,%eax
  8005e2:	c1 e0 03             	shl    $0x3,%eax
  8005e5:	01 d8                	add    %ebx,%eax
  8005e7:	05 00 00 00 80       	add    $0x80000000,%eax
  8005ec:	39 c1                	cmp    %eax,%ecx
  8005ee:	72 28                	jb     800618 <_main+0x5e0>
  8005f0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005f3:	89 c1                	mov    %eax,%ecx
  8005f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005f8:	89 d0                	mov    %edx,%eax
  8005fa:	c1 e0 03             	shl    $0x3,%eax
  8005fd:	01 d0                	add    %edx,%eax
  8005ff:	89 c3                	mov    %eax,%ebx
  800601:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800604:	89 d0                	mov    %edx,%eax
  800606:	01 c0                	add    %eax,%eax
  800608:	01 d0                	add    %edx,%eax
  80060a:	c1 e0 03             	shl    $0x3,%eax
  80060d:	01 d8                	add    %ebx,%eax
  80060f:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800614:	39 c1                	cmp    %eax,%ecx
  800616:	76 14                	jbe    80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 fc 29 80 00       	push   $0x8029fc
  800620:	6a 72                	push   $0x72
  800622:	68 e4 29 80 00       	push   $0x8029e4
  800627:	e8 4c 02 00 00       	call   800878 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  80062c:	e8 48 1d 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800631:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800634:	89 c1                	mov    %eax,%ecx
  800636:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800639:	89 d0                	mov    %edx,%eax
  80063b:	c1 e0 02             	shl    $0x2,%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	85 c0                	test   %eax,%eax
  800642:	79 05                	jns    800649 <_main+0x611>
  800644:	05 ff 0f 00 00       	add    $0xfff,%eax
  800649:	c1 f8 0c             	sar    $0xc,%eax
  80064c:	39 c1                	cmp    %eax,%ecx
  80064e:	74 14                	je     800664 <_main+0x62c>
  800650:	83 ec 04             	sub    $0x4,%esp
  800653:	68 2c 2a 80 00       	push   $0x802a2c
  800658:	6a 74                	push   $0x74
  80065a:	68 e4 29 80 00       	push   $0x8029e4
  80065f:	e8 14 02 00 00       	call   800878 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  800664:	e8 8d 1c 00 00       	call   8022f6 <sys_calculate_free_frames>
  800669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80066c:	e8 08 1d 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800671:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  800674:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	50                   	push   %eax
  80067b:	e8 48 1a 00 00       	call   8020c8 <free>
  800680:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  800683:	e8 f1 1c 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  800688:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068b:	29 c2                	sub    %eax,%edx
  80068d:	89 d0                	mov    %edx,%eax
  80068f:	3d 02 02 00 00       	cmp    $0x202,%eax
  800694:	74 14                	je     8006aa <_main+0x672>
  800696:	83 ec 04             	sub    $0x4,%esp
  800699:	68 49 2a 80 00       	push   $0x802a49
  80069e:	6a 7b                	push   $0x7b
  8006a0:	68 e4 29 80 00       	push   $0x8029e4
  8006a5:	e8 ce 01 00 00       	call   800878 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  8006aa:	e8 47 1c 00 00       	call   8022f6 <sys_calculate_free_frames>
  8006af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006b2:	e8 c2 1c 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  8006b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(4*Mega-kilo);
  8006ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006bd:	c1 e0 02             	shl    $0x2,%eax
  8006c0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	50                   	push   %eax
  8006c7:	e8 5a 10 00 00       	call   801726 <malloc>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[8] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8006d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006d5:	89 c2                	mov    %eax,%edx
  8006d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006da:	c1 e0 02             	shl    $0x2,%eax
  8006dd:	89 c1                	mov    %eax,%ecx
  8006df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e2:	c1 e0 04             	shl    $0x4,%eax
  8006e5:	01 c8                	add    %ecx,%eax
  8006e7:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ec:	39 c2                	cmp    %eax,%edx
  8006ee:	72 1e                	jb     80070e <_main+0x6d6>
  8006f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f8:	c1 e0 02             	shl    $0x2,%eax
  8006fb:	89 c1                	mov    %eax,%ecx
  8006fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800700:	c1 e0 04             	shl    $0x4,%eax
  800703:	01 c8                	add    %ecx,%eax
  800705:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80070a:	39 c2                	cmp    %eax,%edx
  80070c:	76 17                	jbe    800725 <_main+0x6ed>
  80070e:	83 ec 04             	sub    $0x4,%esp
  800711:	68 fc 29 80 00       	push   $0x8029fc
  800716:	68 81 00 00 00       	push   $0x81
  80071b:	68 e4 29 80 00       	push   $0x8029e4
  800720:	e8 53 01 00 00       	call   800878 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800725:	e8 4f 1c 00 00       	call   802379 <sys_pf_calculate_allocated_pages>
  80072a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80072d:	89 c2                	mov    %eax,%edx
  80072f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800732:	c1 e0 02             	shl    $0x2,%eax
  800735:	85 c0                	test   %eax,%eax
  800737:	79 05                	jns    80073e <_main+0x706>
  800739:	05 ff 0f 00 00       	add    $0xfff,%eax
  80073e:	c1 f8 0c             	sar    $0xc,%eax
  800741:	39 c2                	cmp    %eax,%edx
  800743:	74 17                	je     80075c <_main+0x724>
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 2c 2a 80 00       	push   $0x802a2c
  80074d:	68 83 00 00 00       	push   $0x83
  800752:	68 e4 29 80 00       	push   $0x8029e4
  800757:	e8 1c 01 00 00       	call   800878 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  80075c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80075f:	89 d0                	mov    %edx,%eax
  800761:	01 c0                	add    %eax,%eax
  800763:	01 d0                	add    %edx,%eax
  800765:	01 c0                	add    %eax,%eax
  800767:	01 d0                	add    %edx,%eax
  800769:	01 c0                	add    %eax,%eax
  80076b:	f7 d8                	neg    %eax
  80076d:	05 00 00 00 20       	add    $0x20000000,%eax
  800772:	83 ec 0c             	sub    $0xc,%esp
  800775:	50                   	push   %eax
  800776:	e8 ab 0f 00 00       	call   801726 <malloc>
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  800781:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800784:	85 c0                	test   %eax,%eax
  800786:	74 17                	je     80079f <_main+0x767>
  800788:	83 ec 04             	sub    $0x4,%esp
  80078b:	68 60 2a 80 00       	push   $0x802a60
  800790:	68 8c 00 00 00       	push   $0x8c
  800795:	68 e4 29 80 00       	push   $0x8029e4
  80079a:	e8 d9 00 00 00       	call   800878 <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	68 c4 2a 80 00       	push   $0x802ac4
  8007a7:	e8 f7 01 00 00       	call   8009a3 <cprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp

		return;
  8007af:	90                   	nop
	}
}
  8007b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007b3:	5b                   	pop    %ebx
  8007b4:	5f                   	pop    %edi
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007c1:	7e 0a                	jle    8007cd <libmain+0x16>
		binaryname = argv[0];
  8007c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	ff 75 08             	pushl  0x8(%ebp)
  8007d6:	e8 5d f8 ff ff       	call   800038 <_main>
  8007db:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8007de:	e8 61 1a 00 00       	call   802244 <sys_getenvid>
  8007e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8007e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e9:	89 d0                	mov    %edx,%eax
  8007eb:	c1 e0 03             	shl    $0x3,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	01 c0                	add    %eax,%eax
  8007f2:	01 d0                	add    %edx,%eax
  8007f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007fb:	01 d0                	add    %edx,%eax
  8007fd:	c1 e0 03             	shl    $0x3,%eax
  800800:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800805:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800808:	e8 85 1b 00 00       	call   802392 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80080d:	83 ec 0c             	sub    $0xc,%esp
  800810:	68 28 2b 80 00       	push   $0x802b28
  800815:	e8 89 01 00 00       	call   8009a3 <cprintf>
  80081a:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80081d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800820:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	50                   	push   %eax
  80082a:	68 50 2b 80 00       	push   $0x802b50
  80082f:	e8 6f 01 00 00       	call   8009a3 <cprintf>
  800834:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800837:	83 ec 0c             	sub    $0xc,%esp
  80083a:	68 28 2b 80 00       	push   $0x802b28
  80083f:	e8 5f 01 00 00       	call   8009a3 <cprintf>
  800844:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800847:	e8 60 1b 00 00       	call   8023ac <sys_enable_interrupt>

	// exit gracefully
	exit();
  80084c:	e8 19 00 00 00       	call   80086a <exit>
}
  800851:	90                   	nop
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80085a:	83 ec 0c             	sub    $0xc,%esp
  80085d:	6a 00                	push   $0x0
  80085f:	e8 c5 19 00 00       	call   802229 <sys_env_destroy>
  800864:	83 c4 10             	add    $0x10,%esp
}
  800867:	90                   	nop
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <exit>:

void
exit(void)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800870:	e8 e8 19 00 00       	call   80225d <sys_env_exit>
}
  800875:	90                   	nop
  800876:	c9                   	leave  
  800877:	c3                   	ret    

00800878 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80087e:	8d 45 10             	lea    0x10(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800887:	a1 50 30 98 00       	mov    0x983050,%eax
  80088c:	85 c0                	test   %eax,%eax
  80088e:	74 16                	je     8008a6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800890:	a1 50 30 98 00       	mov    0x983050,%eax
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	50                   	push   %eax
  800899:	68 69 2b 80 00       	push   $0x802b69
  80089e:	e8 00 01 00 00       	call   8009a3 <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008a6:	a1 00 30 80 00       	mov    0x803000,%eax
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	50                   	push   %eax
  8008b2:	68 6e 2b 80 00       	push   $0x802b6e
  8008b7:	e8 e7 00 00 00       	call   8009a3 <cprintf>
  8008bc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	e8 7a 00 00 00       	call   800948 <vcprintf>
  8008ce:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8008d1:	83 ec 0c             	sub    $0xc,%esp
  8008d4:	68 8a 2b 80 00       	push   $0x802b8a
  8008d9:	e8 c5 00 00 00       	call   8009a3 <cprintf>
  8008de:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008e1:	e8 84 ff ff ff       	call   80086a <exit>

	// should not return here
	while (1) ;
  8008e6:	eb fe                	jmp    8008e6 <_panic+0x6e>

008008e8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f9:	89 0a                	mov    %ecx,(%edx)
  8008fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8008fe:	88 d1                	mov    %dl,%cl
  800900:	8b 55 0c             	mov    0xc(%ebp),%edx
  800903:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800911:	75 23                	jne    800936 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800913:	8b 45 0c             	mov    0xc(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	89 c2                	mov    %eax,%edx
  80091a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091d:	83 c0 08             	add    $0x8,%eax
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	52                   	push   %edx
  800924:	50                   	push   %eax
  800925:	e8 c9 18 00 00       	call   8021f3 <sys_cputs>
  80092a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800930:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800936:	8b 45 0c             	mov    0xc(%ebp),%eax
  800939:	8b 40 04             	mov    0x4(%eax),%eax
  80093c:	8d 50 01             	lea    0x1(%eax),%edx
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	89 50 04             	mov    %edx,0x4(%eax)
}
  800945:	90                   	nop
  800946:	c9                   	leave  
  800947:	c3                   	ret    

00800948 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800951:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800958:	00 00 00 
	b.cnt = 0;
  80095b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800962:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	ff 75 08             	pushl  0x8(%ebp)
  80096b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800971:	50                   	push   %eax
  800972:	68 e8 08 80 00       	push   $0x8008e8
  800977:	e8 fa 01 00 00       	call   800b76 <vprintfmt>
  80097c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80097f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	50                   	push   %eax
  800989:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80098f:	83 c0 08             	add    $0x8,%eax
  800992:	50                   	push   %eax
  800993:	e8 5b 18 00 00       	call   8021f3 <sys_cputs>
  800998:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80099b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    

008009a3 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b8:	50                   	push   %eax
  8009b9:	e8 8a ff ff ff       	call   800948 <vcprintf>
  8009be:	83 c4 10             	add    $0x10,%esp
  8009c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009cf:	e8 be 19 00 00       	call   802392 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e3:	50                   	push   %eax
  8009e4:	e8 5f ff ff ff       	call   800948 <vcprintf>
  8009e9:	83 c4 10             	add    $0x10,%esp
  8009ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009ef:	e8 b8 19 00 00       	call   8023ac <sys_enable_interrupt>
	return cnt;
  8009f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    

008009f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	53                   	push   %ebx
  8009fd:	83 ec 14             	sub    $0x14,%esp
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a06:	8b 45 14             	mov    0x14(%ebp),%eax
  800a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a0c:	8b 45 18             	mov    0x18(%ebp),%eax
  800a0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a14:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a17:	77 55                	ja     800a6e <printnum+0x75>
  800a19:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a1c:	72 05                	jb     800a23 <printnum+0x2a>
  800a1e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a21:	77 4b                	ja     800a6e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a23:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a26:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a29:	8b 45 18             	mov    0x18(%ebp),%eax
  800a2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a31:	52                   	push   %edx
  800a32:	50                   	push   %eax
  800a33:	ff 75 f4             	pushl  -0xc(%ebp)
  800a36:	ff 75 f0             	pushl  -0x10(%ebp)
  800a39:	e8 f2 1c 00 00       	call   802730 <__udivdi3>
  800a3e:	83 c4 10             	add    $0x10,%esp
  800a41:	83 ec 04             	sub    $0x4,%esp
  800a44:	ff 75 20             	pushl  0x20(%ebp)
  800a47:	53                   	push   %ebx
  800a48:	ff 75 18             	pushl  0x18(%ebp)
  800a4b:	52                   	push   %edx
  800a4c:	50                   	push   %eax
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	ff 75 08             	pushl  0x8(%ebp)
  800a53:	e8 a1 ff ff ff       	call   8009f9 <printnum>
  800a58:	83 c4 20             	add    $0x20,%esp
  800a5b:	eb 1a                	jmp    800a77 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	ff 75 0c             	pushl  0xc(%ebp)
  800a63:	ff 75 20             	pushl  0x20(%ebp)
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	ff d0                	call   *%eax
  800a6b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a6e:	ff 4d 1c             	decl   0x1c(%ebp)
  800a71:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a75:	7f e6                	jg     800a5d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a77:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a85:	53                   	push   %ebx
  800a86:	51                   	push   %ecx
  800a87:	52                   	push   %edx
  800a88:	50                   	push   %eax
  800a89:	e8 b2 1d 00 00       	call   802840 <__umoddi3>
  800a8e:	83 c4 10             	add    $0x10,%esp
  800a91:	05 b4 2d 80 00       	add    $0x802db4,%eax
  800a96:	8a 00                	mov    (%eax),%al
  800a98:	0f be c0             	movsbl %al,%eax
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	50                   	push   %eax
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
}
  800aaa:	90                   	nop
  800aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ab3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab7:	7e 1c                	jle    800ad5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 00                	mov    (%eax),%eax
  800abe:	8d 50 08             	lea    0x8(%eax),%edx
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	89 10                	mov    %edx,(%eax)
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8b 00                	mov    (%eax),%eax
  800acb:	83 e8 08             	sub    $0x8,%eax
  800ace:	8b 50 04             	mov    0x4(%eax),%edx
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	eb 40                	jmp    800b15 <getuint+0x65>
	else if (lflag)
  800ad5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad9:	74 1e                	je     800af9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8b 00                	mov    (%eax),%eax
  800ae0:	8d 50 04             	lea    0x4(%eax),%edx
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	89 10                	mov    %edx,(%eax)
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8b 00                	mov    (%eax),%eax
  800aed:	83 e8 04             	sub    $0x4,%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	ba 00 00 00 00       	mov    $0x0,%edx
  800af7:	eb 1c                	jmp    800b15 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 00                	mov    (%eax),%eax
  800afe:	8d 50 04             	lea    0x4(%eax),%edx
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	89 10                	mov    %edx,(%eax)
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8b 00                	mov    (%eax),%eax
  800b0b:	83 e8 04             	sub    $0x4,%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b1a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b1e:	7e 1c                	jle    800b3c <getint+0x25>
		return va_arg(*ap, long long);
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	8d 50 08             	lea    0x8(%eax),%edx
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	89 10                	mov    %edx,(%eax)
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	83 e8 08             	sub    $0x8,%eax
  800b35:	8b 50 04             	mov    0x4(%eax),%edx
  800b38:	8b 00                	mov    (%eax),%eax
  800b3a:	eb 38                	jmp    800b74 <getint+0x5d>
	else if (lflag)
  800b3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b40:	74 1a                	je     800b5c <getint+0x45>
		return va_arg(*ap, long);
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8b 00                	mov    (%eax),%eax
  800b47:	8d 50 04             	lea    0x4(%eax),%edx
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 10                	mov    %edx,(%eax)
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	83 e8 04             	sub    $0x4,%eax
  800b57:	8b 00                	mov    (%eax),%eax
  800b59:	99                   	cltd   
  800b5a:	eb 18                	jmp    800b74 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 50 04             	lea    0x4(%eax),%edx
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	89 10                	mov    %edx,(%eax)
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	83 e8 04             	sub    $0x4,%eax
  800b71:	8b 00                	mov    (%eax),%eax
  800b73:	99                   	cltd   
}
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
  800b7b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7e:	eb 17                	jmp    800b97 <vprintfmt+0x21>
			if (ch == '\0')
  800b80:	85 db                	test   %ebx,%ebx
  800b82:	0f 84 af 03 00 00    	je     800f37 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	53                   	push   %ebx
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	ff d0                	call   *%eax
  800b94:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b97:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9a:	8d 50 01             	lea    0x1(%eax),%edx
  800b9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	0f b6 d8             	movzbl %al,%ebx
  800ba5:	83 fb 25             	cmp    $0x25,%ebx
  800ba8:	75 d6                	jne    800b80 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800baa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bb5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bbc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bc3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bca:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcd:	8d 50 01             	lea    0x1(%eax),%edx
  800bd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	0f b6 d8             	movzbl %al,%ebx
  800bd8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bdb:	83 f8 55             	cmp    $0x55,%eax
  800bde:	0f 87 2b 03 00 00    	ja     800f0f <vprintfmt+0x399>
  800be4:	8b 04 85 d8 2d 80 00 	mov    0x802dd8(,%eax,4),%eax
  800beb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bf1:	eb d7                	jmp    800bca <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bf3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf7:	eb d1                	jmp    800bca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c03:	89 d0                	mov    %edx,%eax
  800c05:	c1 e0 02             	shl    $0x2,%eax
  800c08:	01 d0                	add    %edx,%eax
  800c0a:	01 c0                	add    %eax,%eax
  800c0c:	01 d8                	add    %ebx,%eax
  800c0e:	83 e8 30             	sub    $0x30,%eax
  800c11:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800c1f:	7e 3e                	jle    800c5f <vprintfmt+0xe9>
  800c21:	83 fb 39             	cmp    $0x39,%ebx
  800c24:	7f 39                	jg     800c5f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c26:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c29:	eb d5                	jmp    800c00 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2e:	83 c0 04             	add    $0x4,%eax
  800c31:	89 45 14             	mov    %eax,0x14(%ebp)
  800c34:	8b 45 14             	mov    0x14(%ebp),%eax
  800c37:	83 e8 04             	sub    $0x4,%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c3f:	eb 1f                	jmp    800c60 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c45:	79 83                	jns    800bca <vprintfmt+0x54>
				width = 0;
  800c47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c4e:	e9 77 ff ff ff       	jmp    800bca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c5a:	e9 6b ff ff ff       	jmp    800bca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c64:	0f 89 60 ff ff ff    	jns    800bca <vprintfmt+0x54>
				width = precision, precision = -1;
  800c6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c77:	e9 4e ff ff ff       	jmp    800bca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c7c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c7f:	e9 46 ff ff ff       	jmp    800bca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	50                   	push   %eax
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	ff d0                	call   *%eax
  800ca1:	83 c4 10             	add    $0x10,%esp
			break;
  800ca4:	e9 89 02 00 00       	jmp    800f32 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 c0 04             	add    $0x4,%eax
  800caf:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	83 e8 04             	sub    $0x4,%eax
  800cb8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cba:	85 db                	test   %ebx,%ebx
  800cbc:	79 02                	jns    800cc0 <vprintfmt+0x14a>
				err = -err;
  800cbe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cc0:	83 fb 64             	cmp    $0x64,%ebx
  800cc3:	7f 0b                	jg     800cd0 <vprintfmt+0x15a>
  800cc5:	8b 34 9d 20 2c 80 00 	mov    0x802c20(,%ebx,4),%esi
  800ccc:	85 f6                	test   %esi,%esi
  800cce:	75 19                	jne    800ce9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cd0:	53                   	push   %ebx
  800cd1:	68 c5 2d 80 00       	push   $0x802dc5
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 5e 02 00 00       	call   800f3f <printfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ce4:	e9 49 02 00 00       	jmp    800f32 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce9:	56                   	push   %esi
  800cea:	68 ce 2d 80 00       	push   $0x802dce
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 45 02 00 00       	call   800f3f <printfmt>
  800cfa:	83 c4 10             	add    $0x10,%esp
			break;
  800cfd:	e9 30 02 00 00       	jmp    800f32 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d02:	8b 45 14             	mov    0x14(%ebp),%eax
  800d05:	83 c0 04             	add    $0x4,%eax
  800d08:	89 45 14             	mov    %eax,0x14(%ebp)
  800d0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0e:	83 e8 04             	sub    $0x4,%eax
  800d11:	8b 30                	mov    (%eax),%esi
  800d13:	85 f6                	test   %esi,%esi
  800d15:	75 05                	jne    800d1c <vprintfmt+0x1a6>
				p = "(null)";
  800d17:	be d1 2d 80 00       	mov    $0x802dd1,%esi
			if (width > 0 && padc != '-')
  800d1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d20:	7e 6d                	jle    800d8f <vprintfmt+0x219>
  800d22:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d26:	74 67                	je     800d8f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d2b:	83 ec 08             	sub    $0x8,%esp
  800d2e:	50                   	push   %eax
  800d2f:	56                   	push   %esi
  800d30:	e8 0c 03 00 00       	call   801041 <strnlen>
  800d35:	83 c4 10             	add    $0x10,%esp
  800d38:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d3b:	eb 16                	jmp    800d53 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d3d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	ff 75 0c             	pushl  0xc(%ebp)
  800d47:	50                   	push   %eax
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	ff d0                	call   *%eax
  800d4d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d50:	ff 4d e4             	decl   -0x1c(%ebp)
  800d53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d57:	7f e4                	jg     800d3d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d59:	eb 34                	jmp    800d8f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d5f:	74 1c                	je     800d7d <vprintfmt+0x207>
  800d61:	83 fb 1f             	cmp    $0x1f,%ebx
  800d64:	7e 05                	jle    800d6b <vprintfmt+0x1f5>
  800d66:	83 fb 7e             	cmp    $0x7e,%ebx
  800d69:	7e 12                	jle    800d7d <vprintfmt+0x207>
					putch('?', putdat);
  800d6b:	83 ec 08             	sub    $0x8,%esp
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	6a 3f                	push   $0x3f
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	ff d0                	call   *%eax
  800d78:	83 c4 10             	add    $0x10,%esp
  800d7b:	eb 0f                	jmp    800d8c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d7d:	83 ec 08             	sub    $0x8,%esp
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	53                   	push   %ebx
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	ff d0                	call   *%eax
  800d89:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800d8f:	89 f0                	mov    %esi,%eax
  800d91:	8d 70 01             	lea    0x1(%eax),%esi
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	0f be d8             	movsbl %al,%ebx
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	74 24                	je     800dc1 <vprintfmt+0x24b>
  800d9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da1:	78 b8                	js     800d5b <vprintfmt+0x1e5>
  800da3:	ff 4d e0             	decl   -0x20(%ebp)
  800da6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800daa:	79 af                	jns    800d5b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dac:	eb 13                	jmp    800dc1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800dae:	83 ec 08             	sub    $0x8,%esp
  800db1:	ff 75 0c             	pushl  0xc(%ebp)
  800db4:	6a 20                	push   $0x20
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	ff d0                	call   *%eax
  800dbb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc5:	7f e7                	jg     800dae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc7:	e9 66 01 00 00       	jmp    800f32 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dcc:	83 ec 08             	sub    $0x8,%esp
  800dcf:	ff 75 e8             	pushl  -0x18(%ebp)
  800dd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800dd5:	50                   	push   %eax
  800dd6:	e8 3c fd ff ff       	call   800b17 <getint>
  800ddb:	83 c4 10             	add    $0x10,%esp
  800dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dea:	85 d2                	test   %edx,%edx
  800dec:	79 23                	jns    800e11 <vprintfmt+0x29b>
				putch('-', putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	6a 2d                	push   $0x2d
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	ff d0                	call   *%eax
  800dfb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e04:	f7 d8                	neg    %eax
  800e06:	83 d2 00             	adc    $0x0,%edx
  800e09:	f7 da                	neg    %edx
  800e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e18:	e9 bc 00 00 00       	jmp    800ed9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e1d:	83 ec 08             	sub    $0x8,%esp
  800e20:	ff 75 e8             	pushl  -0x18(%ebp)
  800e23:	8d 45 14             	lea    0x14(%ebp),%eax
  800e26:	50                   	push   %eax
  800e27:	e8 84 fc ff ff       	call   800ab0 <getuint>
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e3c:	e9 98 00 00 00       	jmp    800ed9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 58                	push   $0x58
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	6a 58                	push   $0x58
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	6a 58                	push   $0x58
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	ff d0                	call   *%eax
  800e6e:	83 c4 10             	add    $0x10,%esp
			break;
  800e71:	e9 bc 00 00 00       	jmp    800f32 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e76:	83 ec 08             	sub    $0x8,%esp
  800e79:	ff 75 0c             	pushl  0xc(%ebp)
  800e7c:	6a 30                	push   $0x30
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	ff d0                	call   *%eax
  800e83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	6a 78                	push   $0x78
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	ff d0                	call   *%eax
  800e93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e96:	8b 45 14             	mov    0x14(%ebp),%eax
  800e99:	83 c0 04             	add    $0x4,%eax
  800e9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea2:	83 e8 04             	sub    $0x4,%eax
  800ea5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb8:	eb 1f                	jmp    800ed9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eba:	83 ec 08             	sub    $0x8,%esp
  800ebd:	ff 75 e8             	pushl  -0x18(%ebp)
  800ec0:	8d 45 14             	lea    0x14(%ebp),%eax
  800ec3:	50                   	push   %eax
  800ec4:	e8 e7 fb ff ff       	call   800ab0 <getuint>
  800ec9:	83 c4 10             	add    $0x10,%esp
  800ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ecf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ed2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ee0:	83 ec 04             	sub    $0x4,%esp
  800ee3:	52                   	push   %edx
  800ee4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee7:	50                   	push   %eax
  800ee8:	ff 75 f4             	pushl  -0xc(%ebp)
  800eeb:	ff 75 f0             	pushl  -0x10(%ebp)
  800eee:	ff 75 0c             	pushl  0xc(%ebp)
  800ef1:	ff 75 08             	pushl  0x8(%ebp)
  800ef4:	e8 00 fb ff ff       	call   8009f9 <printnum>
  800ef9:	83 c4 20             	add    $0x20,%esp
			break;
  800efc:	eb 34                	jmp    800f32 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800efe:	83 ec 08             	sub    $0x8,%esp
  800f01:	ff 75 0c             	pushl  0xc(%ebp)
  800f04:	53                   	push   %ebx
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	ff d0                	call   *%eax
  800f0a:	83 c4 10             	add    $0x10,%esp
			break;
  800f0d:	eb 23                	jmp    800f32 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f0f:	83 ec 08             	sub    $0x8,%esp
  800f12:	ff 75 0c             	pushl  0xc(%ebp)
  800f15:	6a 25                	push   $0x25
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	ff d0                	call   *%eax
  800f1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f1f:	ff 4d 10             	decl   0x10(%ebp)
  800f22:	eb 03                	jmp    800f27 <vprintfmt+0x3b1>
  800f24:	ff 4d 10             	decl   0x10(%ebp)
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	48                   	dec    %eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	3c 25                	cmp    $0x25,%al
  800f2f:	75 f3                	jne    800f24 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f31:	90                   	nop
		}
	}
  800f32:	e9 47 fc ff ff       	jmp    800b7e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f45:	8d 45 10             	lea    0x10(%ebp),%eax
  800f48:	83 c0 04             	add    $0x4,%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f51:	ff 75 f4             	pushl  -0xc(%ebp)
  800f54:	50                   	push   %eax
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	ff 75 08             	pushl  0x8(%ebp)
  800f5b:	e8 16 fc ff ff       	call   800b76 <vprintfmt>
  800f60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f63:	90                   	nop
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	8b 40 08             	mov    0x8(%eax),%eax
  800f6f:	8d 50 01             	lea    0x1(%eax),%edx
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	8b 10                	mov    (%eax),%edx
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	8b 40 04             	mov    0x4(%eax),%eax
  800f83:	39 c2                	cmp    %eax,%edx
  800f85:	73 12                	jae    800f99 <sprintputch+0x33>
		*b->buf++ = ch;
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8b 00                	mov    (%eax),%eax
  800f8c:	8d 48 01             	lea    0x1(%eax),%ecx
  800f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f92:	89 0a                	mov    %ecx,(%edx)
  800f94:	8b 55 08             	mov    0x8(%ebp),%edx
  800f97:	88 10                	mov    %dl,(%eax)
}
  800f99:	90                   	nop
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	01 d0                	add    %edx,%eax
  800fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fc1:	74 06                	je     800fc9 <vsnprintf+0x2d>
  800fc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc7:	7f 07                	jg     800fd0 <vsnprintf+0x34>
		return -E_INVAL;
  800fc9:	b8 03 00 00 00       	mov    $0x3,%eax
  800fce:	eb 20                	jmp    800ff0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fd0:	ff 75 14             	pushl  0x14(%ebp)
  800fd3:	ff 75 10             	pushl  0x10(%ebp)
  800fd6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd9:	50                   	push   %eax
  800fda:	68 66 0f 80 00       	push   $0x800f66
  800fdf:	e8 92 fb ff ff       	call   800b76 <vprintfmt>
  800fe4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801001:	8b 45 10             	mov    0x10(%ebp),%eax
  801004:	ff 75 f4             	pushl  -0xc(%ebp)
  801007:	50                   	push   %eax
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 89 ff ff ff       	call   800f9c <vsnprintf>
  801013:	83 c4 10             	add    $0x10,%esp
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801019:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801024:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80102b:	eb 06                	jmp    801033 <strlen+0x15>
		n++;
  80102d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801030:	ff 45 08             	incl   0x8(%ebp)
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	84 c0                	test   %al,%al
  80103a:	75 f1                	jne    80102d <strlen+0xf>
		n++;
	return n;
  80103c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801047:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80104e:	eb 09                	jmp    801059 <strnlen+0x18>
		n++;
  801050:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801053:	ff 45 08             	incl   0x8(%ebp)
  801056:	ff 4d 0c             	decl   0xc(%ebp)
  801059:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105d:	74 09                	je     801068 <strnlen+0x27>
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	84 c0                	test   %al,%al
  801066:	75 e8                	jne    801050 <strnlen+0xf>
		n++;
	return n;
  801068:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801079:	90                   	nop
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8d 50 01             	lea    0x1(%eax),%edx
  801080:	89 55 08             	mov    %edx,0x8(%ebp)
  801083:	8b 55 0c             	mov    0xc(%ebp),%edx
  801086:	8d 4a 01             	lea    0x1(%edx),%ecx
  801089:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80108c:	8a 12                	mov    (%edx),%dl
  80108e:	88 10                	mov    %dl,(%eax)
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	75 e4                	jne    80107a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801096:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ae:	eb 1f                	jmp    8010cf <strncpy+0x34>
		*dst++ = *src;
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8a 12                	mov    (%edx),%dl
  8010be:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 03                	je     8010cc <strncpy+0x31>
			src++;
  8010c9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010cc:	ff 45 fc             	incl   -0x4(%ebp)
  8010cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d5:	72 d9                	jb     8010b0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ec:	74 30                	je     80111e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010ee:	eb 16                	jmp    801106 <strlcpy+0x2a>
			*dst++ = *src++;
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8d 50 01             	lea    0x1(%eax),%edx
  8010f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801102:	8a 12                	mov    (%edx),%dl
  801104:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801106:	ff 4d 10             	decl   0x10(%ebp)
  801109:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110d:	74 09                	je     801118 <strlcpy+0x3c>
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	84 c0                	test   %al,%al
  801116:	75 d8                	jne    8010f0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80111e:	8b 55 08             	mov    0x8(%ebp),%edx
  801121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801124:	29 c2                	sub    %eax,%edx
  801126:	89 d0                	mov    %edx,%eax
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80112d:	eb 06                	jmp    801135 <strcmp+0xb>
		p++, q++;
  80112f:	ff 45 08             	incl   0x8(%ebp)
  801132:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	84 c0                	test   %al,%al
  80113c:	74 0e                	je     80114c <strcmp+0x22>
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 10                	mov    (%eax),%dl
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	38 c2                	cmp    %al,%dl
  80114a:	74 e3                	je     80112f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f b6 d0             	movzbl %al,%edx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f b6 c0             	movzbl %al,%eax
  80115c:	29 c2                	sub    %eax,%edx
  80115e:	89 d0                	mov    %edx,%eax
}
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    

00801162 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801165:	eb 09                	jmp    801170 <strncmp+0xe>
		n--, p++, q++;
  801167:	ff 4d 10             	decl   0x10(%ebp)
  80116a:	ff 45 08             	incl   0x8(%ebp)
  80116d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801170:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801174:	74 17                	je     80118d <strncmp+0x2b>
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	84 c0                	test   %al,%al
  80117d:	74 0e                	je     80118d <strncmp+0x2b>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 10                	mov    (%eax),%dl
  801184:	8b 45 0c             	mov    0xc(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	38 c2                	cmp    %al,%dl
  80118b:	74 da                	je     801167 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80118d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801191:	75 07                	jne    80119a <strncmp+0x38>
		return 0;
  801193:	b8 00 00 00 00       	mov    $0x0,%eax
  801198:	eb 14                	jmp    8011ae <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	0f b6 d0             	movzbl %al,%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	0f b6 c0             	movzbl %al,%eax
  8011aa:	29 c2                	sub    %eax,%edx
  8011ac:	89 d0                	mov    %edx,%eax
}
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 04             	sub    $0x4,%esp
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011bc:	eb 12                	jmp    8011d0 <strchr+0x20>
		if (*s == c)
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c6:	75 05                	jne    8011cd <strchr+0x1d>
			return (char *) s;
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	eb 11                	jmp    8011de <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011cd:	ff 45 08             	incl   0x8(%ebp)
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	84 c0                	test   %al,%al
  8011d7:	75 e5                	jne    8011be <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011ec:	eb 0d                	jmp    8011fb <strfind+0x1b>
		if (*s == c)
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011f6:	74 0e                	je     801206 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f8:	ff 45 08             	incl   0x8(%ebp)
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	84 c0                	test   %al,%al
  801202:	75 ea                	jne    8011ee <strfind+0xe>
  801204:	eb 01                	jmp    801207 <strfind+0x27>
		if (*s == c)
			break;
  801206:	90                   	nop
	return (char *) s;
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80120a:	c9                   	leave  
  80120b:	c3                   	ret    

0080120c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801218:	8b 45 10             	mov    0x10(%ebp),%eax
  80121b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80121e:	eb 0e                	jmp    80122e <memset+0x22>
		*p++ = c;
  801220:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801223:	8d 50 01             	lea    0x1(%eax),%edx
  801226:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80122e:	ff 4d f8             	decl   -0x8(%ebp)
  801231:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801235:	79 e9                	jns    801220 <memset+0x14>
		*p++ = c;

	return v;
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801242:	8b 45 0c             	mov    0xc(%ebp),%eax
  801245:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80124e:	eb 16                	jmp    801266 <memcpy+0x2a>
		*d++ = *s++;
  801250:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801253:	8d 50 01             	lea    0x1(%eax),%edx
  801256:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801259:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80125f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801262:	8a 12                	mov    (%edx),%dl
  801264:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	8d 50 ff             	lea    -0x1(%eax),%edx
  80126c:	89 55 10             	mov    %edx,0x10(%ebp)
  80126f:	85 c0                	test   %eax,%eax
  801271:	75 dd                	jne    801250 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  80127e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801281:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80128a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801290:	73 50                	jae    8012e2 <memmove+0x6a>
  801292:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801295:	8b 45 10             	mov    0x10(%ebp),%eax
  801298:	01 d0                	add    %edx,%eax
  80129a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80129d:	76 43                	jbe    8012e2 <memmove+0x6a>
		s += n;
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012ab:	eb 10                	jmp    8012bd <memmove+0x45>
			*--d = *--s;
  8012ad:	ff 4d f8             	decl   -0x8(%ebp)
  8012b0:	ff 4d fc             	decl   -0x4(%ebp)
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	8a 10                	mov    (%eax),%dl
  8012b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	75 e3                	jne    8012ad <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012ca:	eb 23                	jmp    8012ef <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012cf:	8d 50 01             	lea    0x1(%eax),%edx
  8012d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012db:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012de:	8a 12                	mov    (%edx),%dl
  8012e0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	75 dd                	jne    8012cc <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801300:	8b 45 0c             	mov    0xc(%ebp),%eax
  801303:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801306:	eb 2a                	jmp    801332 <memcmp+0x3e>
		if (*s1 != *s2)
  801308:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130b:	8a 10                	mov    (%eax),%dl
  80130d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	38 c2                	cmp    %al,%dl
  801314:	74 16                	je     80132c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801316:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	0f b6 d0             	movzbl %al,%edx
  80131e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	0f b6 c0             	movzbl %al,%eax
  801326:	29 c2                	sub    %eax,%edx
  801328:	89 d0                	mov    %edx,%eax
  80132a:	eb 18                	jmp    801344 <memcmp+0x50>
		s1++, s2++;
  80132c:	ff 45 fc             	incl   -0x4(%ebp)
  80132f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	8d 50 ff             	lea    -0x1(%eax),%edx
  801338:	89 55 10             	mov    %edx,0x10(%ebp)
  80133b:	85 c0                	test   %eax,%eax
  80133d:	75 c9                	jne    801308 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80133f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80134c:	8b 55 08             	mov    0x8(%ebp),%edx
  80134f:	8b 45 10             	mov    0x10(%ebp),%eax
  801352:	01 d0                	add    %edx,%eax
  801354:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801357:	eb 15                	jmp    80136e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	0f b6 d0             	movzbl %al,%edx
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	39 c2                	cmp    %eax,%edx
  801369:	74 0d                	je     801378 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80136b:	ff 45 08             	incl   0x8(%ebp)
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801374:	72 e3                	jb     801359 <memfind+0x13>
  801376:	eb 01                	jmp    801379 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801378:	90                   	nop
	return (void *) s;
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801384:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80138b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801392:	eb 03                	jmp    801397 <strtol+0x19>
		s++;
  801394:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	3c 20                	cmp    $0x20,%al
  80139e:	74 f4                	je     801394 <strtol+0x16>
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	3c 09                	cmp    $0x9,%al
  8013a7:	74 eb                	je     801394 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	3c 2b                	cmp    $0x2b,%al
  8013b0:	75 05                	jne    8013b7 <strtol+0x39>
		s++;
  8013b2:	ff 45 08             	incl   0x8(%ebp)
  8013b5:	eb 13                	jmp    8013ca <strtol+0x4c>
	else if (*s == '-')
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	3c 2d                	cmp    $0x2d,%al
  8013be:	75 0a                	jne    8013ca <strtol+0x4c>
		s++, neg = 1;
  8013c0:	ff 45 08             	incl   0x8(%ebp)
  8013c3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ce:	74 06                	je     8013d6 <strtol+0x58>
  8013d0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013d4:	75 20                	jne    8013f6 <strtol+0x78>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 30                	cmp    $0x30,%al
  8013dd:	75 17                	jne    8013f6 <strtol+0x78>
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	40                   	inc    %eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	3c 78                	cmp    $0x78,%al
  8013e7:	75 0d                	jne    8013f6 <strtol+0x78>
		s += 2, base = 16;
  8013e9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013ed:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013f4:	eb 28                	jmp    80141e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fa:	75 15                	jne    801411 <strtol+0x93>
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	3c 30                	cmp    $0x30,%al
  801403:	75 0c                	jne    801411 <strtol+0x93>
		s++, base = 8;
  801405:	ff 45 08             	incl   0x8(%ebp)
  801408:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80140f:	eb 0d                	jmp    80141e <strtol+0xa0>
	else if (base == 0)
  801411:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801415:	75 07                	jne    80141e <strtol+0xa0>
		base = 10;
  801417:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	3c 2f                	cmp    $0x2f,%al
  801425:	7e 19                	jle    801440 <strtol+0xc2>
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 39                	cmp    $0x39,%al
  80142e:	7f 10                	jg     801440 <strtol+0xc2>
			dig = *s - '0';
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	0f be c0             	movsbl %al,%eax
  801438:	83 e8 30             	sub    $0x30,%eax
  80143b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80143e:	eb 42                	jmp    801482 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	3c 60                	cmp    $0x60,%al
  801447:	7e 19                	jle    801462 <strtol+0xe4>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 7a                	cmp    $0x7a,%al
  801450:	7f 10                	jg     801462 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	0f be c0             	movsbl %al,%eax
  80145a:	83 e8 57             	sub    $0x57,%eax
  80145d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801460:	eb 20                	jmp    801482 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	3c 40                	cmp    $0x40,%al
  801469:	7e 39                	jle    8014a4 <strtol+0x126>
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	3c 5a                	cmp    $0x5a,%al
  801472:	7f 30                	jg     8014a4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	0f be c0             	movsbl %al,%eax
  80147c:	83 e8 37             	sub    $0x37,%eax
  80147f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801485:	3b 45 10             	cmp    0x10(%ebp),%eax
  801488:	7d 19                	jge    8014a3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80148a:	ff 45 08             	incl   0x8(%ebp)
  80148d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801490:	0f af 45 10          	imul   0x10(%ebp),%eax
  801494:	89 c2                	mov    %eax,%edx
  801496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801499:	01 d0                	add    %edx,%eax
  80149b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80149e:	e9 7b ff ff ff       	jmp    80141e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014a3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a8:	74 08                	je     8014b2 <strtol+0x134>
		*endptr = (char *) s;
  8014aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014b6:	74 07                	je     8014bf <strtol+0x141>
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014bb:	f7 d8                	neg    %eax
  8014bd:	eb 03                	jmp    8014c2 <strtol+0x144>
  8014bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <ltostr>:

void
ltostr(long value, char *str)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014dc:	79 13                	jns    8014f1 <ltostr+0x2d>
	{
		neg = 1;
  8014de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014eb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014ee:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f9:	99                   	cltd   
  8014fa:	f7 f9                	idiv   %ecx
  8014fc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801502:	8d 50 01             	lea    0x1(%eax),%edx
  801505:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801508:	89 c2                	mov    %eax,%edx
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801512:	83 c2 30             	add    $0x30,%edx
  801515:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801517:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80151f:	f7 e9                	imul   %ecx
  801521:	c1 fa 02             	sar    $0x2,%edx
  801524:	89 c8                	mov    %ecx,%eax
  801526:	c1 f8 1f             	sar    $0x1f,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801530:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801533:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801538:	f7 e9                	imul   %ecx
  80153a:	c1 fa 02             	sar    $0x2,%edx
  80153d:	89 c8                	mov    %ecx,%eax
  80153f:	c1 f8 1f             	sar    $0x1f,%eax
  801542:	29 c2                	sub    %eax,%edx
  801544:	89 d0                	mov    %edx,%eax
  801546:	c1 e0 02             	shl    $0x2,%eax
  801549:	01 d0                	add    %edx,%eax
  80154b:	01 c0                	add    %eax,%eax
  80154d:	29 c1                	sub    %eax,%ecx
  80154f:	89 ca                	mov    %ecx,%edx
  801551:	85 d2                	test   %edx,%edx
  801553:	75 9c                	jne    8014f1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80155c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155f:	48                   	dec    %eax
  801560:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801563:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801567:	74 3d                	je     8015a6 <ltostr+0xe2>
		start = 1 ;
  801569:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801570:	eb 34                	jmp    8015a6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801575:	8b 45 0c             	mov    0xc(%ebp),%eax
  801578:	01 d0                	add    %edx,%eax
  80157a:	8a 00                	mov    (%eax),%al
  80157c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80157f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	01 c2                	add    %eax,%edx
  801587:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80158a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158d:	01 c8                	add    %ecx,%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801593:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801596:	8b 45 0c             	mov    0xc(%ebp),%eax
  801599:	01 c2                	add    %eax,%edx
  80159b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80159e:	88 02                	mov    %al,(%edx)
		start++ ;
  8015a0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015a3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015ac:	7c c4                	jl     801572 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	01 d0                	add    %edx,%eax
  8015b6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b9:	90                   	nop
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015c2:	ff 75 08             	pushl  0x8(%ebp)
  8015c5:	e8 54 fa ff ff       	call   80101e <strlen>
  8015ca:	83 c4 04             	add    $0x4,%esp
  8015cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015d0:	ff 75 0c             	pushl  0xc(%ebp)
  8015d3:	e8 46 fa ff ff       	call   80101e <strlen>
  8015d8:	83 c4 04             	add    $0x4,%esp
  8015db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ec:	eb 17                	jmp    801605 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f4:	01 c2                	add    %eax,%edx
  8015f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	01 c8                	add    %ecx,%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801602:	ff 45 fc             	incl   -0x4(%ebp)
  801605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801608:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80160b:	7c e1                	jl     8015ee <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801614:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80161b:	eb 1f                	jmp    80163c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80161d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801626:	89 c2                	mov    %eax,%edx
  801628:	8b 45 10             	mov    0x10(%ebp),%eax
  80162b:	01 c2                	add    %eax,%edx
  80162d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801630:	8b 45 0c             	mov    0xc(%ebp),%eax
  801633:	01 c8                	add    %ecx,%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801639:	ff 45 f8             	incl   -0x8(%ebp)
  80163c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801642:	7c d9                	jl     80161d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801644:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801647:	8b 45 10             	mov    0x10(%ebp),%eax
  80164a:	01 d0                	add    %edx,%eax
  80164c:	c6 00 00             	movb   $0x0,(%eax)
}
  80164f:	90                   	nop
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801655:	8b 45 14             	mov    0x14(%ebp),%eax
  801658:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80165e:	8b 45 14             	mov    0x14(%ebp),%eax
  801661:	8b 00                	mov    (%eax),%eax
  801663:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80166a:	8b 45 10             	mov    0x10(%ebp),%eax
  80166d:	01 d0                	add    %edx,%eax
  80166f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801675:	eb 0c                	jmp    801683 <strsplit+0x31>
			*string++ = 0;
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	8d 50 01             	lea    0x1(%eax),%edx
  80167d:	89 55 08             	mov    %edx,0x8(%ebp)
  801680:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	8a 00                	mov    (%eax),%al
  801688:	84 c0                	test   %al,%al
  80168a:	74 18                	je     8016a4 <strsplit+0x52>
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	8a 00                	mov    (%eax),%al
  801691:	0f be c0             	movsbl %al,%eax
  801694:	50                   	push   %eax
  801695:	ff 75 0c             	pushl  0xc(%ebp)
  801698:	e8 13 fb ff ff       	call   8011b0 <strchr>
  80169d:	83 c4 08             	add    $0x8,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	75 d3                	jne    801677 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	8a 00                	mov    (%eax),%al
  8016a9:	84 c0                	test   %al,%al
  8016ab:	74 5a                	je     801707 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8016ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b0:	8b 00                	mov    (%eax),%eax
  8016b2:	83 f8 0f             	cmp    $0xf,%eax
  8016b5:	75 07                	jne    8016be <strsplit+0x6c>
		{
			return 0;
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bc:	eb 66                	jmp    801724 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016be:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8016c6:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c9:	89 0a                	mov    %ecx,(%edx)
  8016cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d5:	01 c2                	add    %eax,%edx
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016dc:	eb 03                	jmp    8016e1 <strsplit+0x8f>
			string++;
  8016de:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	84 c0                	test   %al,%al
  8016e8:	74 8b                	je     801675 <strsplit+0x23>
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	8a 00                	mov    (%eax),%al
  8016ef:	0f be c0             	movsbl %al,%eax
  8016f2:	50                   	push   %eax
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	e8 b5 fa ff ff       	call   8011b0 <strchr>
  8016fb:	83 c4 08             	add    $0x8,%esp
  8016fe:	85 c0                	test   %eax,%eax
  801700:	74 dc                	je     8016de <strsplit+0x8c>
			string++;
	}
  801702:	e9 6e ff ff ff       	jmp    801675 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801707:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	8b 00                	mov    (%eax),%eax
  80170d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801714:	8b 45 10             	mov    0x10(%ebp),%eax
  801717:	01 d0                	add    %edx,%eax
  801719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80171f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  80172f:	e8 7d 0f 00 00       	call   8026b1 <sys_isUHeapPlacementStrategyNEXTFIT>
  801734:	85 c0                	test   %eax,%eax
  801736:	0f 84 6f 03 00 00    	je     801aab <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  80173c:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801743:	8b 55 08             	mov    0x8(%ebp),%edx
  801746:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	48                   	dec    %eax
  80174c:	89 45 80             	mov    %eax,-0x80(%ebp)
  80174f:	8b 45 80             	mov    -0x80(%ebp),%eax
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	f7 75 84             	divl   -0x7c(%ebp)
  80175a:	8b 45 80             	mov    -0x80(%ebp),%eax
  80175d:	29 d0                	sub    %edx,%eax
  80175f:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801762:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801766:	74 09                	je     801771 <malloc+0x4b>
  801768:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80176f:	76 0a                	jbe    80177b <malloc+0x55>
			return NULL;
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	e9 4b 09 00 00       	jmp    8020c6 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  80177b:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	01 d0                	add    %edx,%eax
  801786:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80178b:	0f 87 a2 00 00 00    	ja     801833 <malloc+0x10d>
  801791:	a1 40 30 98 00       	mov    0x983040,%eax
  801796:	85 c0                	test   %eax,%eax
  801798:	0f 85 95 00 00 00    	jne    801833 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  80179e:	a1 04 30 80 00       	mov    0x803004,%eax
  8017a3:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8017a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	50                   	push   %eax
  8017b5:	e8 a3 0b 00 00       	call   80235d <sys_allocateMem>
  8017ba:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  8017bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8017c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c5:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8017cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8017d1:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8017d7:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
			cnt_mem++;
  8017de:	a1 20 30 80 00       	mov    0x803020,%eax
  8017e3:	40                   	inc    %eax
  8017e4:	a3 20 30 80 00       	mov    %eax,0x803020
			int i = 0;
  8017e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8017f0:	eb 2e                	jmp    801820 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8017f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8017f7:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8017fc:	c1 e8 0c             	shr    $0xc,%eax
  8017ff:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801806:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  80180a:	a1 04 30 80 00       	mov    0x803004,%eax
  80180f:	05 00 10 00 00       	add    $0x1000,%eax
  801814:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801819:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801823:	3b 45 08             	cmp    0x8(%ebp),%eax
  801826:	72 ca                	jb     8017f2 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801828:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80182e:	e9 93 08 00 00       	jmp    8020c6 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  80183a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801841:	a1 40 30 98 00       	mov    0x983040,%eax
  801846:	85 c0                	test   %eax,%eax
  801848:	75 1d                	jne    801867 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  80184a:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801851:	00 00 80 
				check = 1;
  801854:	c7 05 40 30 98 00 01 	movl   $0x1,0x983040
  80185b:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  80185e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801865:	eb 08                	jmp    80186f <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801867:	a1 04 30 80 00       	mov    0x803004,%eax
  80186c:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  80186f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801876:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  80187d:	a1 04 30 80 00       	mov    0x803004,%eax
  801882:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801885:	eb 4d                	jmp    8018d4 <malloc+0x1ae>
				if (sz == size) {
  801887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80188a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80188d:	75 09                	jne    801898 <malloc+0x172>
					f = 1;
  80188f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801896:	eb 45                	jmp    8018dd <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801898:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189b:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  8018a0:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8018a3:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	75 10                	jne    8018be <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  8018ae:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8018b5:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  8018bc:	eb 16                	jmp    8018d4 <malloc+0x1ae>
				} else {
					sz = 0;
  8018be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8018c5:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  8018cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018cf:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8018d4:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8018db:	76 aa                	jbe    801887 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  8018dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e1:	0f 84 95 00 00 00    	je     80197c <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8018e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8018ec:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  8018f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	ff 75 08             	pushl  0x8(%ebp)
  8018fd:	50                   	push   %eax
  8018fe:	e8 5a 0a 00 00       	call   80235d <sys_allocateMem>
  801903:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801906:	a1 20 30 80 00       	mov    0x803020,%eax
  80190b:	8b 55 08             	mov    0x8(%ebp),%edx
  80190e:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801915:	a1 20 30 80 00       	mov    0x803020,%eax
  80191a:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801920:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801927:	a1 20 30 80 00       	mov    0x803020,%eax
  80192c:	40                   	inc    %eax
  80192d:	a3 20 30 80 00       	mov    %eax,0x803020
				int i = 0;
  801932:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801939:	eb 2e                	jmp    801969 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80193b:	a1 04 30 80 00       	mov    0x803004,%eax
  801940:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801945:	c1 e8 0c             	shr    $0xc,%eax
  801948:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  80194f:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801953:	a1 04 30 80 00       	mov    0x803004,%eax
  801958:	05 00 10 00 00       	add    $0x1000,%eax
  80195d:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801962:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801969:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80196c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80196f:	72 ca                	jb     80193b <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801971:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801977:	e9 4a 07 00 00       	jmp    8020c6 <malloc+0x9a0>

			} else {

				if (check_start) {
  80197c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801980:	74 0a                	je     80198c <malloc+0x266>

					return NULL;
  801982:	b8 00 00 00 00       	mov    $0x0,%eax
  801987:	e9 3a 07 00 00       	jmp    8020c6 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  80198c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801993:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  80199a:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  8019a1:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  8019a8:	00 00 80 
				while (ptr < (uint32) temp_end) {
  8019ab:	eb 4d                	jmp    8019fa <malloc+0x2d4>
					if (sz == size) {
  8019ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019b3:	75 09                	jne    8019be <malloc+0x298>
						f = 1;
  8019b5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  8019bc:	eb 44                	jmp    801a02 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8019be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019c1:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  8019c6:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8019c9:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	75 10                	jne    8019e4 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  8019d4:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8019db:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  8019e2:	eb 16                	jmp    8019fa <malloc+0x2d4>
					} else {
						sz = 0;
  8019e4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8019eb:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  8019f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019f5:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  8019fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fd:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a00:	72 ab                	jb     8019ad <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801a02:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a06:	0f 84 95 00 00 00    	je     801aa1 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801a0c:	a1 04 30 80 00       	mov    0x803004,%eax
  801a11:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801a17:	a1 04 30 80 00       	mov    0x803004,%eax
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	ff 75 08             	pushl  0x8(%ebp)
  801a22:	50                   	push   %eax
  801a23:	e8 35 09 00 00       	call   80235d <sys_allocateMem>
  801a28:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801a2b:	a1 20 30 80 00       	mov    0x803020,%eax
  801a30:	8b 55 08             	mov    0x8(%ebp),%edx
  801a33:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801a3a:	a1 20 30 80 00       	mov    0x803020,%eax
  801a3f:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a45:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
					cnt_mem++;
  801a4c:	a1 20 30 80 00       	mov    0x803020,%eax
  801a51:	40                   	inc    %eax
  801a52:	a3 20 30 80 00       	mov    %eax,0x803020
					int i = 0;
  801a57:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801a5e:	eb 2e                	jmp    801a8e <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801a60:	a1 04 30 80 00       	mov    0x803004,%eax
  801a65:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801a6a:	c1 e8 0c             	shr    $0xc,%eax
  801a6d:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801a74:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801a78:	a1 04 30 80 00       	mov    0x803004,%eax
  801a7d:	05 00 10 00 00       	add    $0x1000,%eax
  801a82:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801a87:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801a8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a91:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a94:	72 ca                	jb     801a60 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801a96:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801a9c:	e9 25 06 00 00       	jmp    8020c6 <malloc+0x9a0>

				} else {

					return NULL;
  801aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa6:	e9 1b 06 00 00       	jmp    8020c6 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801aab:	e8 d0 0b 00 00       	call   802680 <sys_isUHeapPlacementStrategyBESTFIT>
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	0f 84 ba 01 00 00    	je     801c72 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801ab8:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801abf:	10 00 00 
  801ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac5:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801acb:	01 d0                	add    %edx,%eax
  801acd:	48                   	dec    %eax
  801ace:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801ad4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801ada:	ba 00 00 00 00       	mov    $0x0,%edx
  801adf:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801ae5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801aeb:	29 d0                	sub    %edx,%eax
  801aed:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801af0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801af4:	74 09                	je     801aff <malloc+0x3d9>
  801af6:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801afd:	76 0a                	jbe    801b09 <malloc+0x3e3>
			return NULL;
  801aff:	b8 00 00 00 00       	mov    $0x0,%eax
  801b04:	e9 bd 05 00 00       	jmp    8020c6 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801b09:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801b10:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801b17:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801b1e:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801b25:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	c1 e8 0c             	shr    $0xc,%eax
  801b32:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801b38:	e9 80 00 00 00       	jmp    801bbd <malloc+0x497>

			if (heap_mem[i] == 0) {
  801b3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b40:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801b47:	85 c0                	test   %eax,%eax
  801b49:	75 0c                	jne    801b57 <malloc+0x431>

				count++;
  801b4b:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801b4e:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801b55:	eb 2d                	jmp    801b84 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801b57:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801b5d:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801b60:	77 14                	ja     801b76 <malloc+0x450>
  801b62:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b65:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801b68:	76 0c                	jbe    801b76 <malloc+0x450>

					min_sz = count;
  801b6a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801b6d:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801b70:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b73:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801b76:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801b7d:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801b84:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801b8b:	75 2d                	jne    801bba <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801b8d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801b93:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801b96:	77 22                	ja     801bba <malloc+0x494>
  801b98:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b9b:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801b9e:	76 1a                	jbe    801bba <malloc+0x494>

					min_sz = count;
  801ba0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801ba3:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ba9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801bac:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801bb3:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801bba:	ff 45 b8             	incl   -0x48(%ebp)
  801bbd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801bc0:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801bc5:	0f 86 72 ff ff ff    	jbe    801b3d <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801bcb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801bd1:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801bd4:	77 06                	ja     801bdc <malloc+0x4b6>
  801bd6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801bda:	75 0a                	jne    801be6 <malloc+0x4c0>
			return NULL;
  801bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801be1:	e9 e0 04 00 00       	jmp    8020c6 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801be6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801be9:	c1 e0 0c             	shl    $0xc,%eax
  801bec:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801bef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801bf2:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801bf8:	83 ec 08             	sub    $0x8,%esp
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	ff 75 c4             	pushl  -0x3c(%ebp)
  801c01:	e8 57 07 00 00       	call   80235d <sys_allocateMem>
  801c06:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801c09:	a1 20 30 80 00       	mov    0x803020,%eax
  801c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801c11:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801c18:	a1 20 30 80 00       	mov    0x803020,%eax
  801c1d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801c20:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801c27:	a1 20 30 80 00       	mov    0x803020,%eax
  801c2c:	40                   	inc    %eax
  801c2d:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801c32:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801c39:	eb 24                	jmp    801c5f <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801c3b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c3e:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801c43:	c1 e8 0c             	shr    $0xc,%eax
  801c46:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801c4d:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801c51:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801c58:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801c5f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c62:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c65:	72 d4                	jb     801c3b <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801c67:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801c6d:	e9 54 04 00 00       	jmp    8020c6 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801c72:	e8 d8 09 00 00       	call   80264f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c77:	85 c0                	test   %eax,%eax
  801c79:	0f 84 88 01 00 00    	je     801e07 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801c7f:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801c86:	10 00 00 
  801c89:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801c92:	01 d0                	add    %edx,%eax
  801c94:	48                   	dec    %eax
  801c95:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801c9b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801ca1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca6:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801cac:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801cb2:	29 d0                	sub    %edx,%eax
  801cb4:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801cb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cbb:	74 09                	je     801cc6 <malloc+0x5a0>
  801cbd:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801cc4:	76 0a                	jbe    801cd0 <malloc+0x5aa>
			return NULL;
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccb:	e9 f6 03 00 00       	jmp    8020c6 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801cd0:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801cd7:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801cde:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801ce5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801cec:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	c1 e8 0c             	shr    $0xc,%eax
  801cf9:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801cff:	eb 5a                	jmp    801d5b <malloc+0x635>

			if (heap_mem[i] == 0) {
  801d01:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d04:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	75 0c                	jne    801d1b <malloc+0x5f5>

				count++;
  801d0f:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801d12:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801d19:	eb 22                	jmp    801d3d <malloc+0x617>
			} else {
				if (num_p <= count) {
  801d1b:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d21:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d24:	77 09                	ja     801d2f <malloc+0x609>

					found = 1;
  801d26:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801d2d:	eb 36                	jmp    801d65 <malloc+0x63f>
				}
				count = 0;
  801d2f:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801d36:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801d3d:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801d44:	75 12                	jne    801d58 <malloc+0x632>

				if (num_p <= count) {
  801d46:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801d4c:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801d4f:	77 07                	ja     801d58 <malloc+0x632>

					found = 1;
  801d51:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801d58:	ff 45 a4             	incl   -0x5c(%ebp)
  801d5b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801d5e:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801d63:	76 9c                	jbe    801d01 <malloc+0x5db>

			}

		}

		if (!found) {
  801d65:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801d69:	75 0a                	jne    801d75 <malloc+0x64f>
			return NULL;
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d70:	e9 51 03 00 00       	jmp    8020c6 <malloc+0x9a0>

		}

		temp = ptr;
  801d75:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801d78:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801d7b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801d7e:	c1 e0 0c             	shl    $0xc,%eax
  801d81:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801d84:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801d87:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801d8d:	83 ec 08             	sub    $0x8,%esp
  801d90:	ff 75 08             	pushl  0x8(%ebp)
  801d93:	ff 75 b0             	pushl  -0x50(%ebp)
  801d96:	e8 c2 05 00 00       	call   80235d <sys_allocateMem>
  801d9b:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801d9e:	a1 20 30 80 00       	mov    0x803020,%eax
  801da3:	8b 55 08             	mov    0x8(%ebp),%edx
  801da6:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801dad:	a1 20 30 80 00       	mov    0x803020,%eax
  801db2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801db5:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801dbc:	a1 20 30 80 00       	mov    0x803020,%eax
  801dc1:	40                   	inc    %eax
  801dc2:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801dc7:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801dce:	eb 24                	jmp    801df4 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801dd0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801dd3:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801dd8:	c1 e8 0c             	shr    $0xc,%eax
  801ddb:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801de2:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801de6:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801ded:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801df4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801df7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dfa:	72 d4                	jb     801dd0 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801dfc:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801e02:	e9 bf 02 00 00       	jmp    8020c6 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801e07:	e8 d6 08 00 00       	call   8026e2 <sys_isUHeapPlacementStrategyWORSTFIT>
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	0f 84 ba 01 00 00    	je     801fce <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801e14:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801e1b:	10 00 00 
  801e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e21:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801e27:	01 d0                	add    %edx,%eax
  801e29:	48                   	dec    %eax
  801e2a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801e30:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e36:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3b:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801e41:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801e47:	29 d0                	sub    %edx,%eax
  801e49:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801e4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e50:	74 09                	je     801e5b <malloc+0x735>
  801e52:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801e59:	76 0a                	jbe    801e65 <malloc+0x73f>
					return NULL;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e60:	e9 61 02 00 00       	jmp    8020c6 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801e65:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801e6c:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801e73:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801e7a:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801e81:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	c1 e8 0c             	shr    $0xc,%eax
  801e8e:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801e94:	e9 80 00 00 00       	jmp    801f19 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801e99:	8b 45 90             	mov    -0x70(%ebp),%eax
  801e9c:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	75 0c                	jne    801eb3 <malloc+0x78d>

						count++;
  801ea7:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801eaa:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801eb1:	eb 2d                	jmp    801ee0 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801eb3:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801eb9:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ebc:	77 14                	ja     801ed2 <malloc+0x7ac>
  801ebe:	8b 45 98             	mov    -0x68(%ebp),%eax
  801ec1:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ec4:	73 0c                	jae    801ed2 <malloc+0x7ac>

							max_sz = count;
  801ec6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801ec9:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801ecc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801ecf:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801ed2:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801ed9:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801ee0:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801ee7:	75 2d                	jne    801f16 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801ee9:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801eef:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ef2:	77 22                	ja     801f16 <malloc+0x7f0>
  801ef4:	8b 45 98             	mov    -0x68(%ebp),%eax
  801ef7:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801efa:	76 1a                	jbe    801f16 <malloc+0x7f0>

							max_sz = count;
  801efc:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801eff:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801f02:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801f05:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801f08:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801f0f:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801f16:	ff 45 90             	incl   -0x70(%ebp)
  801f19:	8b 45 90             	mov    -0x70(%ebp),%eax
  801f1c:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f21:	0f 86 72 ff ff ff    	jbe    801e99 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801f27:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801f2d:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801f30:	77 06                	ja     801f38 <malloc+0x812>
  801f32:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801f36:	75 0a                	jne    801f42 <malloc+0x81c>
					return NULL;
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3d:	e9 84 01 00 00       	jmp    8020c6 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801f42:	8b 45 98             	mov    -0x68(%ebp),%eax
  801f45:	c1 e0 0c             	shl    $0xc,%eax
  801f48:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801f4b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801f4e:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801f54:	83 ec 08             	sub    $0x8,%esp
  801f57:	ff 75 08             	pushl  0x8(%ebp)
  801f5a:	ff 75 9c             	pushl  -0x64(%ebp)
  801f5d:	e8 fb 03 00 00       	call   80235d <sys_allocateMem>
  801f62:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801f65:	a1 20 30 80 00       	mov    0x803020,%eax
  801f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f6d:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801f74:	a1 20 30 80 00       	mov    0x803020,%eax
  801f79:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801f7c:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801f83:	a1 20 30 80 00       	mov    0x803020,%eax
  801f88:	40                   	inc    %eax
  801f89:	a3 20 30 80 00       	mov    %eax,0x803020
				i = 0;
  801f8e:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801f95:	eb 24                	jmp    801fbb <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801f97:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801f9a:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801f9f:	c1 e8 0c             	shr    $0xc,%eax
  801fa2:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801fa9:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801fad:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801fb4:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801fbb:	8b 45 90             	mov    -0x70(%ebp),%eax
  801fbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fc1:	72 d4                	jb     801f97 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801fc3:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801fc9:	e9 f8 00 00 00       	jmp    8020c6 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801fce:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801fd5:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  801fdc:	10 00 00 
  801fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe2:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	48                   	dec    %eax
  801feb:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  801ff1:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801ff7:	ba 00 00 00 00       	mov    $0x0,%edx
  801ffc:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802002:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802008:	29 d0                	sub    %edx,%eax
  80200a:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80200d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802011:	74 09                	je     80201c <malloc+0x8f6>
  802013:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80201a:	76 0a                	jbe    802026 <malloc+0x900>
		return NULL;
  80201c:	b8 00 00 00 00       	mov    $0x0,%eax
  802021:	e9 a0 00 00 00       	jmp    8020c6 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802026:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	01 d0                	add    %edx,%eax
  802031:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802036:	0f 87 87 00 00 00    	ja     8020c3 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80203c:	a1 04 30 80 00       	mov    0x803004,%eax
  802041:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802044:	a1 04 30 80 00       	mov    0x803004,%eax
  802049:	83 ec 08             	sub    $0x8,%esp
  80204c:	ff 75 08             	pushl  0x8(%ebp)
  80204f:	50                   	push   %eax
  802050:	e8 08 03 00 00       	call   80235d <sys_allocateMem>
  802055:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802058:	a1 20 30 80 00       	mov    0x803020,%eax
  80205d:	8b 55 08             	mov    0x8(%ebp),%edx
  802060:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802067:	a1 20 30 80 00       	mov    0x803020,%eax
  80206c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  802072:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  802079:	a1 20 30 80 00       	mov    0x803020,%eax
  80207e:	40                   	inc    %eax
  80207f:	a3 20 30 80 00       	mov    %eax,0x803020
		int i = 0;
  802084:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  80208b:	eb 2e                	jmp    8020bb <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80208d:	a1 04 30 80 00       	mov    0x803004,%eax
  802092:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802097:	c1 e8 0c             	shr    $0xc,%eax
  80209a:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8020a1:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8020a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8020aa:	05 00 10 00 00       	add    $0x1000,%eax
  8020af:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8020b4:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  8020bb:	8b 45 88             	mov    -0x78(%ebp),%eax
  8020be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c1:	72 ca                	jb     80208d <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  8020c3:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  8020ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  8020d5:	e9 c1 00 00 00       	jmp    80219b <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	8b 04 c5 40 30 88 00 	mov    0x883040(,%eax,8),%eax
  8020e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020e7:	0f 85 ab 00 00 00    	jne    802198 <free+0xd0>

			if (heap_size[inx].size == 0) {
  8020ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f0:	8b 04 c5 44 30 88 00 	mov    0x883044(,%eax,8),%eax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	75 21                	jne    80211c <free+0x54>
				heap_size[inx].size = 0;
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  802105:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  802113:	00 00 00 00 
				return;
  802117:	e9 8d 00 00 00       	jmp    8021a9 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	83 ec 08             	sub    $0x8,%esp
  80212c:	52                   	push   %edx
  80212d:	50                   	push   %eax
  80212e:	e8 0e 02 00 00       	call   802341 <sys_freeMem>
  802133:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802136:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802143:	eb 24                	jmp    802169 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802145:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802148:	05 00 00 00 80       	add    $0x80000000,%eax
  80214d:	c1 e8 0c             	shr    $0xc,%eax
  802150:	c7 04 85 40 30 80 00 	movl   $0x0,0x803040(,%eax,4)
  802157:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  80215b:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802162:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  802173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802176:	39 c2                	cmp    %eax,%edx
  802178:	77 cb                	ja     802145 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  802184:	00 00 00 00 
			heap_size[inx].vir = NULL;
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  802192:	00 00 00 00 
			break;
  802196:	eb 11                	jmp    8021a9 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  802198:	ff 45 f4             	incl   -0xc(%ebp)
  80219b:	a1 20 30 80 00       	mov    0x803020,%eax
  8021a0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8021a3:	0f 8c 31 ff ff ff    	jl     8020da <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021b1:	83 ec 04             	sub    $0x4,%esp
  8021b4:	68 30 2f 80 00       	push   $0x802f30
  8021b9:	68 1c 02 00 00       	push   $0x21c
  8021be:	68 56 2f 80 00       	push   $0x802f56
  8021c3:	e8 b0 e6 ff ff       	call   800878 <_panic>

008021c8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	57                   	push   %edi
  8021cc:	56                   	push   %esi
  8021cd:	53                   	push   %ebx
  8021ce:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021dd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021e0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021e3:	cd 30                	int    $0x30
  8021e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021eb:	83 c4 10             	add    $0x10,%esp
  8021ee:	5b                   	pop    %ebx
  8021ef:	5e                   	pop    %esi
  8021f0:	5f                   	pop    %edi
  8021f1:	5d                   	pop    %ebp
  8021f2:	c3                   	ret    

008021f3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	ff 75 0c             	pushl  0xc(%ebp)
  802202:	50                   	push   %eax
  802203:	6a 00                	push   $0x0
  802205:	e8 be ff ff ff       	call   8021c8 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	90                   	nop
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_cgetc>:

int
sys_cgetc(void)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 01                	push   $0x1
  80221f:	e8 a4 ff ff ff       	call   8021c8 <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	50                   	push   %eax
  802238:	6a 03                	push   $0x3
  80223a:	e8 89 ff ff ff       	call   8021c8 <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 02                	push   $0x2
  802253:	e8 70 ff ff ff       	call   8021c8 <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_env_exit>:

void sys_env_exit(void)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 04                	push   $0x4
  80226c:	e8 57 ff ff ff       	call   8021c8 <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
}
  802274:	90                   	nop
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80227a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	52                   	push   %edx
  802287:	50                   	push   %eax
  802288:	6a 05                	push   $0x5
  80228a:	e8 39 ff ff ff       	call   8021c8 <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	56                   	push   %esi
  802298:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802299:	8b 75 18             	mov    0x18(%ebp),%esi
  80229c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80229f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	56                   	push   %esi
  8022a9:	53                   	push   %ebx
  8022aa:	51                   	push   %ecx
  8022ab:	52                   	push   %edx
  8022ac:	50                   	push   %eax
  8022ad:	6a 06                	push   $0x6
  8022af:	e8 14 ff ff ff       	call   8021c8 <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
}
  8022b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ba:	5b                   	pop    %ebx
  8022bb:	5e                   	pop    %esi
  8022bc:	5d                   	pop    %ebp
  8022bd:	c3                   	ret    

008022be <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	52                   	push   %edx
  8022ce:	50                   	push   %eax
  8022cf:	6a 07                	push   $0x7
  8022d1:	e8 f2 fe ff ff       	call   8021c8 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	ff 75 0c             	pushl  0xc(%ebp)
  8022e7:	ff 75 08             	pushl  0x8(%ebp)
  8022ea:	6a 08                	push   $0x8
  8022ec:	e8 d7 fe ff ff       	call   8021c8 <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 09                	push   $0x9
  802305:	e8 be fe ff ff       	call   8021c8 <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
}
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 0a                	push   $0xa
  80231e:	e8 a5 fe ff ff       	call   8021c8 <syscall>
  802323:	83 c4 18             	add    $0x18,%esp
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 0b                	push   $0xb
  802337:	e8 8c fe ff ff       	call   8021c8 <syscall>
  80233c:	83 c4 18             	add    $0x18,%esp
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	ff 75 0c             	pushl  0xc(%ebp)
  80234d:	ff 75 08             	pushl  0x8(%ebp)
  802350:	6a 0d                	push   $0xd
  802352:	e8 71 fe ff ff       	call   8021c8 <syscall>
  802357:	83 c4 18             	add    $0x18,%esp
	return;
  80235a:	90                   	nop
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	ff 75 0c             	pushl  0xc(%ebp)
  802369:	ff 75 08             	pushl  0x8(%ebp)
  80236c:	6a 0e                	push   $0xe
  80236e:	e8 55 fe ff ff       	call   8021c8 <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
	return ;
  802376:	90                   	nop
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 0c                	push   $0xc
  802388:	e8 3b fe ff ff       	call   8021c8 <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 10                	push   $0x10
  8023a1:	e8 22 fe ff ff       	call   8021c8 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
}
  8023a9:	90                   	nop
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 11                	push   $0x11
  8023bb:	e8 08 fe ff ff       	call   8021c8 <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
}
  8023c3:	90                   	nop
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	83 ec 04             	sub    $0x4,%esp
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	50                   	push   %eax
  8023df:	6a 12                	push   $0x12
  8023e1:	e8 e2 fd ff ff       	call   8021c8 <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
}
  8023e9:	90                   	nop
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 13                	push   $0x13
  8023fb:	e8 c8 fd ff ff       	call   8021c8 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
}
  802403:	90                   	nop
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	ff 75 0c             	pushl  0xc(%ebp)
  802415:	50                   	push   %eax
  802416:	6a 14                	push   $0x14
  802418:	e8 ab fd ff ff       	call   8021c8 <syscall>
  80241d:	83 c4 18             	add    $0x18,%esp
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802425:	8b 45 08             	mov    0x8(%ebp),%eax
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	50                   	push   %eax
  802431:	6a 17                	push   $0x17
  802433:	e8 90 fd ff ff       	call   8021c8 <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
}
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802440:	8b 45 08             	mov    0x8(%ebp),%eax
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	50                   	push   %eax
  80244c:	6a 15                	push   $0x15
  80244e:	e8 75 fd ff ff       	call   8021c8 <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
}
  802456:	90                   	nop
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	50                   	push   %eax
  802468:	6a 16                	push   $0x16
  80246a:	e8 59 fd ff ff       	call   8021c8 <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
}
  802472:	90                   	nop
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 04             	sub    $0x4,%esp
  80247b:	8b 45 10             	mov    0x10(%ebp),%eax
  80247e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802481:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802484:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	6a 00                	push   $0x0
  80248d:	51                   	push   %ecx
  80248e:	52                   	push   %edx
  80248f:	ff 75 0c             	pushl  0xc(%ebp)
  802492:	50                   	push   %eax
  802493:	6a 18                	push   $0x18
  802495:	e8 2e fd ff ff       	call   8021c8 <syscall>
  80249a:	83 c4 18             	add    $0x18,%esp
}
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8024a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	52                   	push   %edx
  8024af:	50                   	push   %eax
  8024b0:	6a 19                	push   $0x19
  8024b2:	e8 11 fd ff ff       	call   8021c8 <syscall>
  8024b7:	83 c4 18             	add    $0x18,%esp
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	50                   	push   %eax
  8024cb:	6a 1a                	push   $0x1a
  8024cd:	e8 f6 fc ff ff       	call   8021c8 <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 1b                	push   $0x1b
  8024e6:	e8 dd fc ff ff       	call   8021c8 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 1c                	push   $0x1c
  8024ff:	e8 c4 fc ff ff       	call   8021c8 <syscall>
  802504:	83 c4 18             	add    $0x18,%esp
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	ff 75 0c             	pushl  0xc(%ebp)
  802518:	50                   	push   %eax
  802519:	6a 1d                	push   $0x1d
  80251b:	e8 a8 fc ff ff       	call   8021c8 <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	50                   	push   %eax
  802534:	6a 1e                	push   $0x1e
  802536:	e8 8d fc ff ff       	call   8021c8 <syscall>
  80253b:	83 c4 18             	add    $0x18,%esp
}
  80253e:	90                   	nop
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	50                   	push   %eax
  802550:	6a 1f                	push   $0x1f
  802552:	e8 71 fc ff ff       	call   8021c8 <syscall>
  802557:	83 c4 18             	add    $0x18,%esp
}
  80255a:	90                   	nop
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802563:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802566:	8d 50 04             	lea    0x4(%eax),%edx
  802569:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	52                   	push   %edx
  802573:	50                   	push   %eax
  802574:	6a 20                	push   $0x20
  802576:	e8 4d fc ff ff       	call   8021c8 <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
	return result;
  80257e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802581:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802584:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802587:	89 01                	mov    %eax,(%ecx)
  802589:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	c9                   	leave  
  802590:	c2 04 00             	ret    $0x4

00802593 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	ff 75 10             	pushl  0x10(%ebp)
  80259d:	ff 75 0c             	pushl  0xc(%ebp)
  8025a0:	ff 75 08             	pushl  0x8(%ebp)
  8025a3:	6a 0f                	push   $0xf
  8025a5:	e8 1e fc ff ff       	call   8021c8 <syscall>
  8025aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ad:	90                   	nop
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 21                	push   $0x21
  8025bf:	e8 04 fc ff ff       	call   8021c8 <syscall>
  8025c4:	83 c4 18             	add    $0x18,%esp
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	83 ec 04             	sub    $0x4,%esp
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025d5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	50                   	push   %eax
  8025e2:	6a 22                	push   $0x22
  8025e4:	e8 df fb ff ff       	call   8021c8 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ec:	90                   	nop
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <rsttst>:
void rsttst()
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 24                	push   $0x24
  8025fe:	e8 c5 fb ff ff       	call   8021c8 <syscall>
  802603:	83 c4 18             	add    $0x18,%esp
	return ;
  802606:	90                   	nop
}
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	83 ec 04             	sub    $0x4,%esp
  80260f:	8b 45 14             	mov    0x14(%ebp),%eax
  802612:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802615:	8b 55 18             	mov    0x18(%ebp),%edx
  802618:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80261c:	52                   	push   %edx
  80261d:	50                   	push   %eax
  80261e:	ff 75 10             	pushl  0x10(%ebp)
  802621:	ff 75 0c             	pushl  0xc(%ebp)
  802624:	ff 75 08             	pushl  0x8(%ebp)
  802627:	6a 23                	push   $0x23
  802629:	e8 9a fb ff ff       	call   8021c8 <syscall>
  80262e:	83 c4 18             	add    $0x18,%esp
	return ;
  802631:	90                   	nop
}
  802632:	c9                   	leave  
  802633:	c3                   	ret    

00802634 <chktst>:
void chktst(uint32 n)
{
  802634:	55                   	push   %ebp
  802635:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	ff 75 08             	pushl  0x8(%ebp)
  802642:	6a 25                	push   $0x25
  802644:	e8 7f fb ff ff       	call   8021c8 <syscall>
  802649:	83 c4 18             	add    $0x18,%esp
	return ;
  80264c:	90                   	nop
}
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
  802652:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 26                	push   $0x26
  802661:	e8 62 fb ff ff       	call   8021c8 <syscall>
  802666:	83 c4 18             	add    $0x18,%esp
  802669:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80266c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802670:	75 07                	jne    802679 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802672:	b8 01 00 00 00       	mov    $0x1,%eax
  802677:	eb 05                	jmp    80267e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802679:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 26                	push   $0x26
  802692:	e8 31 fb ff ff       	call   8021c8 <syscall>
  802697:	83 c4 18             	add    $0x18,%esp
  80269a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80269d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026a1:	75 07                	jne    8026aa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a8:	eb 05                	jmp    8026af <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 26                	push   $0x26
  8026c3:	e8 00 fb ff ff       	call   8021c8 <syscall>
  8026c8:	83 c4 18             	add    $0x18,%esp
  8026cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026ce:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026d2:	75 07                	jne    8026db <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d9:	eb 05                	jmp    8026e0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 26                	push   $0x26
  8026f4:	e8 cf fa ff ff       	call   8021c8 <syscall>
  8026f9:	83 c4 18             	add    $0x18,%esp
  8026fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026ff:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802703:	75 07                	jne    80270c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802705:	b8 01 00 00 00       	mov    $0x1,%eax
  80270a:	eb 05                	jmp    802711 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802711:	c9                   	leave  
  802712:	c3                   	ret    

00802713 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	ff 75 08             	pushl  0x8(%ebp)
  802721:	6a 27                	push   $0x27
  802723:	e8 a0 fa ff ff       	call   8021c8 <syscall>
  802728:	83 c4 18             	add    $0x18,%esp
	return ;
  80272b:	90                   	nop
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    
  80272e:	66 90                	xchg   %ax,%ax

00802730 <__udivdi3>:
  802730:	55                   	push   %ebp
  802731:	57                   	push   %edi
  802732:	56                   	push   %esi
  802733:	53                   	push   %ebx
  802734:	83 ec 1c             	sub    $0x1c,%esp
  802737:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80273b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80273f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802743:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802747:	89 ca                	mov    %ecx,%edx
  802749:	89 f8                	mov    %edi,%eax
  80274b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80274f:	85 f6                	test   %esi,%esi
  802751:	75 2d                	jne    802780 <__udivdi3+0x50>
  802753:	39 cf                	cmp    %ecx,%edi
  802755:	77 65                	ja     8027bc <__udivdi3+0x8c>
  802757:	89 fd                	mov    %edi,%ebp
  802759:	85 ff                	test   %edi,%edi
  80275b:	75 0b                	jne    802768 <__udivdi3+0x38>
  80275d:	b8 01 00 00 00       	mov    $0x1,%eax
  802762:	31 d2                	xor    %edx,%edx
  802764:	f7 f7                	div    %edi
  802766:	89 c5                	mov    %eax,%ebp
  802768:	31 d2                	xor    %edx,%edx
  80276a:	89 c8                	mov    %ecx,%eax
  80276c:	f7 f5                	div    %ebp
  80276e:	89 c1                	mov    %eax,%ecx
  802770:	89 d8                	mov    %ebx,%eax
  802772:	f7 f5                	div    %ebp
  802774:	89 cf                	mov    %ecx,%edi
  802776:	89 fa                	mov    %edi,%edx
  802778:	83 c4 1c             	add    $0x1c,%esp
  80277b:	5b                   	pop    %ebx
  80277c:	5e                   	pop    %esi
  80277d:	5f                   	pop    %edi
  80277e:	5d                   	pop    %ebp
  80277f:	c3                   	ret    
  802780:	39 ce                	cmp    %ecx,%esi
  802782:	77 28                	ja     8027ac <__udivdi3+0x7c>
  802784:	0f bd fe             	bsr    %esi,%edi
  802787:	83 f7 1f             	xor    $0x1f,%edi
  80278a:	75 40                	jne    8027cc <__udivdi3+0x9c>
  80278c:	39 ce                	cmp    %ecx,%esi
  80278e:	72 0a                	jb     80279a <__udivdi3+0x6a>
  802790:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802794:	0f 87 9e 00 00 00    	ja     802838 <__udivdi3+0x108>
  80279a:	b8 01 00 00 00       	mov    $0x1,%eax
  80279f:	89 fa                	mov    %edi,%edx
  8027a1:	83 c4 1c             	add    $0x1c,%esp
  8027a4:	5b                   	pop    %ebx
  8027a5:	5e                   	pop    %esi
  8027a6:	5f                   	pop    %edi
  8027a7:	5d                   	pop    %ebp
  8027a8:	c3                   	ret    
  8027a9:	8d 76 00             	lea    0x0(%esi),%esi
  8027ac:	31 ff                	xor    %edi,%edi
  8027ae:	31 c0                	xor    %eax,%eax
  8027b0:	89 fa                	mov    %edi,%edx
  8027b2:	83 c4 1c             	add    $0x1c,%esp
  8027b5:	5b                   	pop    %ebx
  8027b6:	5e                   	pop    %esi
  8027b7:	5f                   	pop    %edi
  8027b8:	5d                   	pop    %ebp
  8027b9:	c3                   	ret    
  8027ba:	66 90                	xchg   %ax,%ax
  8027bc:	89 d8                	mov    %ebx,%eax
  8027be:	f7 f7                	div    %edi
  8027c0:	31 ff                	xor    %edi,%edi
  8027c2:	89 fa                	mov    %edi,%edx
  8027c4:	83 c4 1c             	add    $0x1c,%esp
  8027c7:	5b                   	pop    %ebx
  8027c8:	5e                   	pop    %esi
  8027c9:	5f                   	pop    %edi
  8027ca:	5d                   	pop    %ebp
  8027cb:	c3                   	ret    
  8027cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027d1:	89 eb                	mov    %ebp,%ebx
  8027d3:	29 fb                	sub    %edi,%ebx
  8027d5:	89 f9                	mov    %edi,%ecx
  8027d7:	d3 e6                	shl    %cl,%esi
  8027d9:	89 c5                	mov    %eax,%ebp
  8027db:	88 d9                	mov    %bl,%cl
  8027dd:	d3 ed                	shr    %cl,%ebp
  8027df:	89 e9                	mov    %ebp,%ecx
  8027e1:	09 f1                	or     %esi,%ecx
  8027e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027e7:	89 f9                	mov    %edi,%ecx
  8027e9:	d3 e0                	shl    %cl,%eax
  8027eb:	89 c5                	mov    %eax,%ebp
  8027ed:	89 d6                	mov    %edx,%esi
  8027ef:	88 d9                	mov    %bl,%cl
  8027f1:	d3 ee                	shr    %cl,%esi
  8027f3:	89 f9                	mov    %edi,%ecx
  8027f5:	d3 e2                	shl    %cl,%edx
  8027f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027fb:	88 d9                	mov    %bl,%cl
  8027fd:	d3 e8                	shr    %cl,%eax
  8027ff:	09 c2                	or     %eax,%edx
  802801:	89 d0                	mov    %edx,%eax
  802803:	89 f2                	mov    %esi,%edx
  802805:	f7 74 24 0c          	divl   0xc(%esp)
  802809:	89 d6                	mov    %edx,%esi
  80280b:	89 c3                	mov    %eax,%ebx
  80280d:	f7 e5                	mul    %ebp
  80280f:	39 d6                	cmp    %edx,%esi
  802811:	72 19                	jb     80282c <__udivdi3+0xfc>
  802813:	74 0b                	je     802820 <__udivdi3+0xf0>
  802815:	89 d8                	mov    %ebx,%eax
  802817:	31 ff                	xor    %edi,%edi
  802819:	e9 58 ff ff ff       	jmp    802776 <__udivdi3+0x46>
  80281e:	66 90                	xchg   %ax,%ax
  802820:	8b 54 24 08          	mov    0x8(%esp),%edx
  802824:	89 f9                	mov    %edi,%ecx
  802826:	d3 e2                	shl    %cl,%edx
  802828:	39 c2                	cmp    %eax,%edx
  80282a:	73 e9                	jae    802815 <__udivdi3+0xe5>
  80282c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80282f:	31 ff                	xor    %edi,%edi
  802831:	e9 40 ff ff ff       	jmp    802776 <__udivdi3+0x46>
  802836:	66 90                	xchg   %ax,%ax
  802838:	31 c0                	xor    %eax,%eax
  80283a:	e9 37 ff ff ff       	jmp    802776 <__udivdi3+0x46>
  80283f:	90                   	nop

00802840 <__umoddi3>:
  802840:	55                   	push   %ebp
  802841:	57                   	push   %edi
  802842:	56                   	push   %esi
  802843:	53                   	push   %ebx
  802844:	83 ec 1c             	sub    $0x1c,%esp
  802847:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80284b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80284f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802853:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802857:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80285b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80285f:	89 f3                	mov    %esi,%ebx
  802861:	89 fa                	mov    %edi,%edx
  802863:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802867:	89 34 24             	mov    %esi,(%esp)
  80286a:	85 c0                	test   %eax,%eax
  80286c:	75 1a                	jne    802888 <__umoddi3+0x48>
  80286e:	39 f7                	cmp    %esi,%edi
  802870:	0f 86 a2 00 00 00    	jbe    802918 <__umoddi3+0xd8>
  802876:	89 c8                	mov    %ecx,%eax
  802878:	89 f2                	mov    %esi,%edx
  80287a:	f7 f7                	div    %edi
  80287c:	89 d0                	mov    %edx,%eax
  80287e:	31 d2                	xor    %edx,%edx
  802880:	83 c4 1c             	add    $0x1c,%esp
  802883:	5b                   	pop    %ebx
  802884:	5e                   	pop    %esi
  802885:	5f                   	pop    %edi
  802886:	5d                   	pop    %ebp
  802887:	c3                   	ret    
  802888:	39 f0                	cmp    %esi,%eax
  80288a:	0f 87 ac 00 00 00    	ja     80293c <__umoddi3+0xfc>
  802890:	0f bd e8             	bsr    %eax,%ebp
  802893:	83 f5 1f             	xor    $0x1f,%ebp
  802896:	0f 84 ac 00 00 00    	je     802948 <__umoddi3+0x108>
  80289c:	bf 20 00 00 00       	mov    $0x20,%edi
  8028a1:	29 ef                	sub    %ebp,%edi
  8028a3:	89 fe                	mov    %edi,%esi
  8028a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028a9:	89 e9                	mov    %ebp,%ecx
  8028ab:	d3 e0                	shl    %cl,%eax
  8028ad:	89 d7                	mov    %edx,%edi
  8028af:	89 f1                	mov    %esi,%ecx
  8028b1:	d3 ef                	shr    %cl,%edi
  8028b3:	09 c7                	or     %eax,%edi
  8028b5:	89 e9                	mov    %ebp,%ecx
  8028b7:	d3 e2                	shl    %cl,%edx
  8028b9:	89 14 24             	mov    %edx,(%esp)
  8028bc:	89 d8                	mov    %ebx,%eax
  8028be:	d3 e0                	shl    %cl,%eax
  8028c0:	89 c2                	mov    %eax,%edx
  8028c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028c6:	d3 e0                	shl    %cl,%eax
  8028c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028d0:	89 f1                	mov    %esi,%ecx
  8028d2:	d3 e8                	shr    %cl,%eax
  8028d4:	09 d0                	or     %edx,%eax
  8028d6:	d3 eb                	shr    %cl,%ebx
  8028d8:	89 da                	mov    %ebx,%edx
  8028da:	f7 f7                	div    %edi
  8028dc:	89 d3                	mov    %edx,%ebx
  8028de:	f7 24 24             	mull   (%esp)
  8028e1:	89 c6                	mov    %eax,%esi
  8028e3:	89 d1                	mov    %edx,%ecx
  8028e5:	39 d3                	cmp    %edx,%ebx
  8028e7:	0f 82 87 00 00 00    	jb     802974 <__umoddi3+0x134>
  8028ed:	0f 84 91 00 00 00    	je     802984 <__umoddi3+0x144>
  8028f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028f7:	29 f2                	sub    %esi,%edx
  8028f9:	19 cb                	sbb    %ecx,%ebx
  8028fb:	89 d8                	mov    %ebx,%eax
  8028fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802901:	d3 e0                	shl    %cl,%eax
  802903:	89 e9                	mov    %ebp,%ecx
  802905:	d3 ea                	shr    %cl,%edx
  802907:	09 d0                	or     %edx,%eax
  802909:	89 e9                	mov    %ebp,%ecx
  80290b:	d3 eb                	shr    %cl,%ebx
  80290d:	89 da                	mov    %ebx,%edx
  80290f:	83 c4 1c             	add    $0x1c,%esp
  802912:	5b                   	pop    %ebx
  802913:	5e                   	pop    %esi
  802914:	5f                   	pop    %edi
  802915:	5d                   	pop    %ebp
  802916:	c3                   	ret    
  802917:	90                   	nop
  802918:	89 fd                	mov    %edi,%ebp
  80291a:	85 ff                	test   %edi,%edi
  80291c:	75 0b                	jne    802929 <__umoddi3+0xe9>
  80291e:	b8 01 00 00 00       	mov    $0x1,%eax
  802923:	31 d2                	xor    %edx,%edx
  802925:	f7 f7                	div    %edi
  802927:	89 c5                	mov    %eax,%ebp
  802929:	89 f0                	mov    %esi,%eax
  80292b:	31 d2                	xor    %edx,%edx
  80292d:	f7 f5                	div    %ebp
  80292f:	89 c8                	mov    %ecx,%eax
  802931:	f7 f5                	div    %ebp
  802933:	89 d0                	mov    %edx,%eax
  802935:	e9 44 ff ff ff       	jmp    80287e <__umoddi3+0x3e>
  80293a:	66 90                	xchg   %ax,%ax
  80293c:	89 c8                	mov    %ecx,%eax
  80293e:	89 f2                	mov    %esi,%edx
  802940:	83 c4 1c             	add    $0x1c,%esp
  802943:	5b                   	pop    %ebx
  802944:	5e                   	pop    %esi
  802945:	5f                   	pop    %edi
  802946:	5d                   	pop    %ebp
  802947:	c3                   	ret    
  802948:	3b 04 24             	cmp    (%esp),%eax
  80294b:	72 06                	jb     802953 <__umoddi3+0x113>
  80294d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802951:	77 0f                	ja     802962 <__umoddi3+0x122>
  802953:	89 f2                	mov    %esi,%edx
  802955:	29 f9                	sub    %edi,%ecx
  802957:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80295b:	89 14 24             	mov    %edx,(%esp)
  80295e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802962:	8b 44 24 04          	mov    0x4(%esp),%eax
  802966:	8b 14 24             	mov    (%esp),%edx
  802969:	83 c4 1c             	add    $0x1c,%esp
  80296c:	5b                   	pop    %ebx
  80296d:	5e                   	pop    %esi
  80296e:	5f                   	pop    %edi
  80296f:	5d                   	pop    %ebp
  802970:	c3                   	ret    
  802971:	8d 76 00             	lea    0x0(%esi),%esi
  802974:	2b 04 24             	sub    (%esp),%eax
  802977:	19 fa                	sbb    %edi,%edx
  802979:	89 d1                	mov    %edx,%ecx
  80297b:	89 c6                	mov    %eax,%esi
  80297d:	e9 71 ff ff ff       	jmp    8028f3 <__umoddi3+0xb3>
  802982:	66 90                	xchg   %ax,%ax
  802984:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802988:	72 ea                	jb     802974 <__umoddi3+0x134>
  80298a:	89 d9                	mov    %ebx,%ecx
  80298c:	e9 62 ff ff ff       	jmp    8028f3 <__umoddi3+0xb3>
