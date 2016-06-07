
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 b1 09 00 00       	call   8009e7 <libmain>
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
  800040:	e8 2f 24 00 00       	call   802474 <sys_getenvid>
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

	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	6a 02                	push   $0x2
  80006f:	e8 cf 28 00 00       	call   802943 <sys_set_uheap_strategy>
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
  80009e:	e8 b3 18 00 00       	call   801956 <malloc>
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000a9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ac:	85 c0                	test   %eax,%eax
  8000ae:	74 14                	je     8000c4 <_main+0x8c>
  8000b0:	83 ec 04             	sub    $0x4,%esp
  8000b3:	68 e0 2b 80 00       	push   $0x802be0
  8000b8:	6a 1b                	push   $0x1b
  8000ba:	68 24 2c 80 00       	push   $0x802c24
  8000bf:	e8 e4 09 00 00       	call   800aa8 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  8000c4:	e8 5d 24 00 00       	call   802526 <sys_calculate_free_frames>
  8000c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cc:	e8 d8 24 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8000d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 71 18 00 00       	call   801956 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] < (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	79 0a                	jns    8000fc <_main+0xc4>
  8000f2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f5:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000fa:	76 14                	jbe    800110 <_main+0xd8>
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	68 3c 2c 80 00       	push   $0x802c3c
  800104:	6a 24                	push   $0x24
  800106:	68 24 2c 80 00       	push   $0x802c24
  80010b:	e8 98 09 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800110:	e8 94 24 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800115:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800118:	3d 00 02 00 00       	cmp    $0x200,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 6c 2c 80 00       	push   $0x802c6c
  800127:	6a 26                	push   $0x26
  800129:	68 24 2c 80 00       	push   $0x802c24
  80012e:	e8 75 09 00 00       	call   800aa8 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800133:	e8 ee 23 00 00       	call   802526 <sys_calculate_free_frames>
  800138:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80013b:	e8 69 24 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800140:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800146:	01 c0                	add    %eax,%eax
  800148:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	50                   	push   %eax
  80014f:	e8 02 18 00 00       	call   801956 <malloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
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
  800183:	68 3c 2c 80 00       	push   $0x802c3c
  800188:	6a 2c                	push   $0x2c
  80018a:	68 24 2c 80 00       	push   $0x802c24
  80018f:	e8 14 09 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800194:	e8 10 24 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800199:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80019c:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 6c 2c 80 00       	push   $0x802c6c
  8001ab:	6a 2e                	push   $0x2e
  8001ad:	68 24 2c 80 00       	push   $0x802c24
  8001b2:	e8 f1 08 00 00       	call   800aa8 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001b7:	e8 6a 23 00 00       	call   802526 <sys_calculate_free_frames>
  8001bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001bf:	e8 e5 23 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8001c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ca:	01 c0                	add    %eax,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 81 17 00 00       	call   801956 <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 98             	mov    %eax,-0x68(%ebp)

		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001de:	89 c2                	mov    %eax,%edx
  8001e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e3:	c1 e0 02             	shl    $0x2,%eax
  8001e6:	05 00 00 00 80       	add    $0x80000000,%eax
  8001eb:	39 c2                	cmp    %eax,%edx
  8001ed:	75 14                	jne    800203 <_main+0x1cb>
  8001ef:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001f2:	89 c2                	mov    %eax,%edx
  8001f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f7:	c1 e0 02             	shl    $0x2,%eax
  8001fa:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8001ff:	39 c2                	cmp    %eax,%edx
  800201:	76 14                	jbe    800217 <_main+0x1df>
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	68 3c 2c 80 00       	push   $0x802c3c
  80020b:	6a 35                	push   $0x35
  80020d:	68 24 2c 80 00       	push   $0x802c24
  800212:	e8 91 08 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  800217:	e8 8d 23 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  80021c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80021f:	83 f8 01             	cmp    $0x1,%eax
  800222:	74 14                	je     800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 6c 2c 80 00       	push   $0x802c6c
  80022c:	6a 37                	push   $0x37
  80022e:	68 24 2c 80 00       	push   $0x802c24
  800233:	e8 70 08 00 00       	call   800aa8 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800238:	e8 e9 22 00 00       	call   802526 <sys_calculate_free_frames>
  80023d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800240:	e8 64 23 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800245:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024b:	01 c0                	add    %eax,%eax
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	50                   	push   %eax
  800251:	e8 00 17 00 00       	call   801956 <malloc>
  800256:	83 c4 10             	add    $0x10,%esp
  800259:	89 45 9c             	mov    %eax,-0x64(%ebp)

		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo+ PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
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
  800278:	75 1e                	jne    800298 <_main+0x260>
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
  80029b:	68 3c 2c 80 00       	push   $0x802c3c
  8002a0:	6a 3e                	push   $0x3e
  8002a2:	68 24 2c 80 00       	push   $0x802c24
  8002a7:	e8 fc 07 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002ac:	e8 f8 22 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8002b1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002b4:	83 f8 01             	cmp    $0x1,%eax
  8002b7:	74 14                	je     8002cd <_main+0x295>
  8002b9:	83 ec 04             	sub    $0x4,%esp
  8002bc:	68 6c 2c 80 00       	push   $0x802c6c
  8002c1:	6a 40                	push   $0x40
  8002c3:	68 24 2c 80 00       	push   $0x802c24
  8002c8:	e8 db 07 00 00       	call   800aa8 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002cd:	e8 54 22 00 00       	call   802526 <sys_calculate_free_frames>
  8002d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002d5:	e8 cf 22 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8002da:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002dd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	50                   	push   %eax
  8002e4:	e8 0f 20 00 00       	call   8022f8 <free>
  8002e9:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002ec:	e8 b8 22 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8002f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002f4:	29 c2                	sub    %eax,%edx
  8002f6:	89 d0                	mov    %edx,%eax
  8002f8:	83 f8 01             	cmp    $0x1,%eax
  8002fb:	74 14                	je     800311 <_main+0x2d9>
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	68 89 2c 80 00       	push   $0x802c89
  800305:	6a 47                	push   $0x47
  800307:	68 24 2c 80 00       	push   $0x802c24
  80030c:	e8 97 07 00 00       	call   800aa8 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800311:	e8 10 22 00 00       	call   802526 <sys_calculate_free_frames>
  800316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800319:	e8 8b 22 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
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
  800332:	e8 1f 16 00 00       	call   801956 <malloc>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo+ PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
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
  800359:	75 1e                	jne    800379 <_main+0x341>
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
  80037c:	68 3c 2c 80 00       	push   $0x802c3c
  800381:	6a 4d                	push   $0x4d
  800383:	68 24 2c 80 00       	push   $0x802c24
  800388:	e8 1b 07 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  80038d:	e8 17 22 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800392:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800395:	83 f8 02             	cmp    $0x2,%eax
  800398:	74 14                	je     8003ae <_main+0x376>
  80039a:	83 ec 04             	sub    $0x4,%esp
  80039d:	68 6c 2c 80 00       	push   $0x802c6c
  8003a2:	6a 4f                	push   $0x4f
  8003a4:	68 24 2c 80 00       	push   $0x802c24
  8003a9:	e8 fa 06 00 00       	call   800aa8 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8003ae:	e8 73 21 00 00       	call   802526 <sys_calculate_free_frames>
  8003b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b6:	e8 ee 21 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  8003be:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003c1:	83 ec 0c             	sub    $0xc,%esp
  8003c4:	50                   	push   %eax
  8003c5:	e8 2e 1f 00 00       	call   8022f8 <free>
  8003ca:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003cd:	e8 d7 21 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8003d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d5:	29 c2                	sub    %eax,%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003de:	74 14                	je     8003f4 <_main+0x3bc>
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	68 89 2c 80 00       	push   $0x802c89
  8003e8:	6a 56                	push   $0x56
  8003ea:	68 24 2c 80 00       	push   $0x802c24
  8003ef:	e8 b4 06 00 00       	call   800aa8 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003f4:	e8 2d 21 00 00       	call   802526 <sys_calculate_free_frames>
  8003f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003fc:	e8 a8 21 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800401:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	89 c2                	mov    %eax,%edx
  800409:	01 d2                	add    %edx,%edx
  80040b:	01 d0                	add    %edx,%eax
  80040d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	50                   	push   %eax
  800414:	e8 3d 15 00 00       	call   801956 <malloc>
  800419:	83 c4 10             	add    $0x10,%esp
  80041c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo+ PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
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
  80043b:	75 1e                	jne    80045b <_main+0x423>
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
  80045e:	68 3c 2c 80 00       	push   $0x802c3c
  800463:	6a 5c                	push   $0x5c
  800465:	68 24 2c 80 00       	push   $0x802c24
  80046a:	e8 39 06 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  80046f:	e8 35 21 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
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
  800495:	68 6c 2c 80 00       	push   $0x802c6c
  80049a:	6a 5e                	push   $0x5e
  80049c:	68 24 2c 80 00       	push   $0x802c24
  8004a1:	e8 02 06 00 00       	call   800aa8 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  8004a6:	e8 7b 20 00 00       	call   802526 <sys_calculate_free_frames>
  8004ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ae:	e8 f6 20 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
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
  8004ca:	e8 87 14 00 00       	call   801956 <malloc>
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
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
  8004f8:	75 25                	jne    80051f <_main+0x4e7>
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
  800522:	68 3c 2c 80 00       	push   $0x802c3c
  800527:	6a 64                	push   $0x64
  800529:	68 24 2c 80 00       	push   $0x802c24
  80052e:	e8 75 05 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  800533:	e8 71 20 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800538:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80053b:	3d 02 02 00 00       	cmp    $0x202,%eax
  800540:	74 14                	je     800556 <_main+0x51e>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 6c 2c 80 00       	push   $0x802c6c
  80054a:	6a 66                	push   $0x66
  80054c:	68 24 2c 80 00       	push   $0x802c24
  800551:	e8 52 05 00 00       	call   800aa8 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  800556:	e8 cb 1f 00 00       	call   802526 <sys_calculate_free_frames>
  80055b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80055e:	e8 46 20 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800563:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  800566:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800569:	89 d0                	mov    %edx,%eax
  80056b:	c1 e0 02             	shl    $0x2,%eax
  80056e:	01 d0                	add    %edx,%eax
  800570:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 da 13 00 00       	call   801956 <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo) || (uint32) ptr_allocations[7] > (USER_HEAP_START + 9*Mega + 24*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800582:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800585:	89 c1                	mov    %eax,%ecx
  800587:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80058a:	89 d0                	mov    %edx,%eax
  80058c:	c1 e0 03             	shl    $0x3,%eax
  80058f:	01 d0                	add    %edx,%eax
  800591:	89 c3                	mov    %eax,%ebx
  800593:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	01 c0                	add    %eax,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 03             	shl    $0x3,%eax
  80059f:	01 d8                	add    %ebx,%eax
  8005a1:	05 00 00 00 80       	add    $0x80000000,%eax
  8005a6:	39 c1                	cmp    %eax,%ecx
  8005a8:	75 28                	jne    8005d2 <_main+0x59a>
  8005aa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005ad:	89 c1                	mov    %eax,%ecx
  8005af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005b2:	89 d0                	mov    %edx,%eax
  8005b4:	c1 e0 03             	shl    $0x3,%eax
  8005b7:	01 d0                	add    %edx,%eax
  8005b9:	89 c3                	mov    %eax,%ebx
  8005bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005be:	89 d0                	mov    %edx,%eax
  8005c0:	01 c0                	add    %eax,%eax
  8005c2:	01 d0                	add    %edx,%eax
  8005c4:	c1 e0 03             	shl    $0x3,%eax
  8005c7:	01 d8                	add    %ebx,%eax
  8005c9:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8005ce:	39 c1                	cmp    %eax,%ecx
  8005d0:	76 14                	jbe    8005e6 <_main+0x5ae>
  8005d2:	83 ec 04             	sub    $0x4,%esp
  8005d5:	68 3c 2c 80 00       	push   $0x802c3c
  8005da:	6a 6c                	push   $0x6c
  8005dc:	68 24 2c 80 00       	push   $0x802c24
  8005e1:	e8 c2 04 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  8005e6:	e8 be 1f 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8005eb:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005ee:	89 c1                	mov    %eax,%ecx
  8005f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 02             	shl    $0x2,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	85 c0                	test   %eax,%eax
  8005fc:	79 05                	jns    800603 <_main+0x5cb>
  8005fe:	05 ff 0f 00 00       	add    $0xfff,%eax
  800603:	c1 f8 0c             	sar    $0xc,%eax
  800606:	39 c1                	cmp    %eax,%ecx
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 6c 2c 80 00       	push   $0x802c6c
  800612:	6a 6e                	push   $0x6e
  800614:	68 24 2c 80 00       	push   $0x802c24
  800619:	e8 8a 04 00 00       	call   800aa8 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80061e:	e8 03 1f 00 00       	call   802526 <sys_calculate_free_frames>
  800623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800626:	e8 7e 1f 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  80062b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80062e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800631:	83 ec 0c             	sub    $0xc,%esp
  800634:	50                   	push   %eax
  800635:	e8 be 1c 00 00       	call   8022f8 <free>
  80063a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  80063d:	e8 67 1f 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800642:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800645:	29 c2                	sub    %eax,%edx
  800647:	89 d0                	mov    %edx,%eax
  800649:	3d 02 02 00 00       	cmp    $0x202,%eax
  80064e:	74 14                	je     800664 <_main+0x62c>
  800650:	83 ec 04             	sub    $0x4,%esp
  800653:	68 89 2c 80 00       	push   $0x802c89
  800658:	6a 75                	push   $0x75
  80065a:	68 24 2c 80 00       	push   $0x802c24
  80065f:	e8 44 04 00 00       	call   800aa8 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800664:	e8 bd 1e 00 00       	call   802526 <sys_calculate_free_frames>
  800669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80066c:	e8 38 1f 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800671:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800674:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	50                   	push   %eax
  80067b:	e8 78 1c 00 00       	call   8022f8 <free>
  800680:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  800683:	e8 21 1f 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800688:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068b:	29 c2                	sub    %eax,%edx
  80068d:	89 d0                	mov    %edx,%eax
  80068f:	3d 00 02 00 00       	cmp    $0x200,%eax
  800694:	74 14                	je     8006aa <_main+0x672>
  800696:	83 ec 04             	sub    $0x4,%esp
  800699:	68 89 2c 80 00       	push   $0x802c89
  80069e:	6a 7c                	push   $0x7c
  8006a0:	68 24 2c 80 00       	push   $0x802c24
  8006a5:	e8 fe 03 00 00       	call   800aa8 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  8006aa:	e8 77 1e 00 00       	call   802526 <sys_calculate_free_frames>
  8006af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006b2:	e8 f2 1e 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8006b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  8006ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006bd:	01 c0                	add    %eax,%eax
  8006bf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8006c2:	83 ec 0c             	sub    $0xc,%esp
  8006c5:	50                   	push   %eax
  8006c6:	e8 8b 12 00 00       	call   801956 <malloc>
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[8] > (USER_HEAP_START+ + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8006d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006d4:	89 c1                	mov    %eax,%ecx
  8006d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006d9:	89 d0                	mov    %edx,%eax
  8006db:	01 c0                	add    %eax,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	01 c0                	add    %eax,%eax
  8006e1:	01 d0                	add    %edx,%eax
  8006e3:	89 c2                	mov    %eax,%edx
  8006e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e8:	c1 e0 04             	shl    $0x4,%eax
  8006eb:	01 d0                	add    %edx,%eax
  8006ed:	05 00 00 00 80       	add    $0x80000000,%eax
  8006f2:	39 c1                	cmp    %eax,%ecx
  8006f4:	72 25                	jb     80071b <_main+0x6e3>
  8006f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006f9:	89 c1                	mov    %eax,%ecx
  8006fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006fe:	89 d0                	mov    %edx,%eax
  800700:	01 c0                	add    %eax,%eax
  800702:	01 d0                	add    %edx,%eax
  800704:	01 c0                	add    %eax,%eax
  800706:	01 d0                	add    %edx,%eax
  800708:	89 c2                	mov    %eax,%edx
  80070a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80070d:	c1 e0 04             	shl    $0x4,%eax
  800710:	01 d0                	add    %edx,%eax
  800712:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800717:	39 c1                	cmp    %eax,%ecx
  800719:	76 17                	jbe    800732 <_main+0x6fa>
  80071b:	83 ec 04             	sub    $0x4,%esp
  80071e:	68 3c 2c 80 00       	push   $0x802c3c
  800723:	68 82 00 00 00       	push   $0x82
  800728:	68 24 2c 80 00       	push   $0x802c24
  80072d:	e8 76 03 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800732:	e8 72 1e 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800737:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80073f:	74 17                	je     800758 <_main+0x720>
  800741:	83 ec 04             	sub    $0x4,%esp
  800744:	68 6c 2c 80 00       	push   $0x802c6c
  800749:	68 84 00 00 00       	push   $0x84
  80074e:	68 24 2c 80 00       	push   $0x802c24
  800753:	e8 50 03 00 00       	call   800aa8 <_panic>

		//6 KB
		freeFrames = sys_calculate_free_frames() ;
  800758:	e8 c9 1d 00 00       	call   802526 <sys_calculate_free_frames>
  80075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800760:	e8 44 1e 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800765:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  800768:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80076b:	89 d0                	mov    %edx,%eax
  80076d:	01 c0                	add    %eax,%eax
  80076f:	01 d0                	add    %edx,%eax
  800771:	01 c0                	add    %eax,%eax
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	50                   	push   %eax
  800777:	e8 da 11 00 00       	call   801956 <malloc>
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo) || (uint32) ptr_allocations[9] > (USER_HEAP_START + 9*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800782:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800785:	89 c1                	mov    %eax,%ecx
  800787:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80078a:	89 d0                	mov    %edx,%eax
  80078c:	c1 e0 03             	shl    $0x3,%eax
  80078f:	01 d0                	add    %edx,%eax
  800791:	89 c2                	mov    %eax,%edx
  800793:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800796:	c1 e0 04             	shl    $0x4,%eax
  800799:	01 d0                	add    %edx,%eax
  80079b:	05 00 00 00 80       	add    $0x80000000,%eax
  8007a0:	39 c1                	cmp    %eax,%ecx
  8007a2:	75 22                	jne    8007c6 <_main+0x78e>
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c1                	mov    %eax,%ecx
  8007a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	89 c2                	mov    %eax,%edx
  8007b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b8:	c1 e0 04             	shl    $0x4,%eax
  8007bb:	01 d0                	add    %edx,%eax
  8007bd:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8007c2:	39 c1                	cmp    %eax,%ecx
  8007c4:	76 17                	jbe    8007dd <_main+0x7a5>
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	68 3c 2c 80 00       	push   $0x802c3c
  8007ce:	68 8a 00 00 00       	push   $0x8a
  8007d3:	68 24 2c 80 00       	push   $0x802c24
  8007d8:	e8 cb 02 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  8007dd:	e8 c7 1d 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8007e2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007e5:	83 f8 02             	cmp    $0x2,%eax
  8007e8:	74 17                	je     800801 <_main+0x7c9>
  8007ea:	83 ec 04             	sub    $0x4,%esp
  8007ed:	68 6c 2c 80 00       	push   $0x802c6c
  8007f2:	68 8c 00 00 00       	push   $0x8c
  8007f7:	68 24 2c 80 00       	push   $0x802c24
  8007fc:	e8 a7 02 00 00       	call   800aa8 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800801:	e8 20 1d 00 00       	call   802526 <sys_calculate_free_frames>
  800806:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800809:	e8 9b 1d 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  80080e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  800811:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800814:	83 ec 0c             	sub    $0xc,%esp
  800817:	50                   	push   %eax
  800818:	e8 db 1a 00 00       	call   8022f8 <free>
  80081d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800820:	e8 84 1d 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800825:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800828:	29 c2                	sub    %eax,%edx
  80082a:	89 d0                	mov    %edx,%eax
  80082c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800831:	74 17                	je     80084a <_main+0x812>
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	68 89 2c 80 00       	push   $0x802c89
  80083b:	68 93 00 00 00       	push   $0x93
  800840:	68 24 2c 80 00       	push   $0x802c24
  800845:	e8 5e 02 00 00       	call   800aa8 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  80084a:	e8 d7 1c 00 00       	call   802526 <sys_calculate_free_frames>
  80084f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800852:	e8 52 1d 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  800857:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  80085a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085d:	89 c2                	mov    %eax,%edx
  80085f:	01 d2                	add    %edx,%edx
  800861:	01 d0                	add    %edx,%eax
  800863:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800866:	83 ec 0c             	sub    $0xc,%esp
  800869:	50                   	push   %eax
  80086a:	e8 e7 10 00 00       	call   801956 <malloc>
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[10] > (USER_HEAP_START + 4*Mega + 16*kilo+ PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800875:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800878:	89 c2                	mov    %eax,%edx
  80087a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087d:	c1 e0 02             	shl    $0x2,%eax
  800880:	89 c1                	mov    %eax,%ecx
  800882:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800885:	c1 e0 04             	shl    $0x4,%eax
  800888:	01 c8                	add    %ecx,%eax
  80088a:	05 00 00 00 80       	add    $0x80000000,%eax
  80088f:	39 c2                	cmp    %eax,%edx
  800891:	75 1e                	jne    8008b1 <_main+0x879>
  800893:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800896:	89 c2                	mov    %eax,%edx
  800898:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089b:	c1 e0 02             	shl    $0x2,%eax
  80089e:	89 c1                	mov    %eax,%ecx
  8008a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a3:	c1 e0 04             	shl    $0x4,%eax
  8008a6:	01 c8                	add    %ecx,%eax
  8008a8:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8008ad:	39 c2                	cmp    %eax,%edx
  8008af:	76 17                	jbe    8008c8 <_main+0x890>
  8008b1:	83 ec 04             	sub    $0x4,%esp
  8008b4:	68 3c 2c 80 00       	push   $0x802c3c
  8008b9:	68 99 00 00 00       	push   $0x99
  8008be:	68 24 2c 80 00       	push   $0x802c24
  8008c3:	e8 e0 01 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8008c8:	e8 dc 1c 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  8008cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008d0:	89 c2                	mov    %eax,%edx
  8008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d5:	89 c1                	mov    %eax,%ecx
  8008d7:	01 c9                	add    %ecx,%ecx
  8008d9:	01 c8                	add    %ecx,%eax
  8008db:	85 c0                	test   %eax,%eax
  8008dd:	79 05                	jns    8008e4 <_main+0x8ac>
  8008df:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008e4:	c1 f8 0c             	sar    $0xc,%eax
  8008e7:	39 c2                	cmp    %eax,%edx
  8008e9:	74 17                	je     800902 <_main+0x8ca>
  8008eb:	83 ec 04             	sub    $0x4,%esp
  8008ee:	68 6c 2c 80 00       	push   $0x802c6c
  8008f3:	68 9b 00 00 00       	push   $0x9b
  8008f8:	68 24 2c 80 00       	push   $0x802c24
  8008fd:	e8 a6 01 00 00       	call   800aa8 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800902:	e8 1f 1c 00 00       	call   802526 <sys_calculate_free_frames>
  800907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80090a:	e8 9a 1c 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  80090f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  800912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800915:	c1 e0 02             	shl    $0x2,%eax
  800918:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80091b:	83 ec 0c             	sub    $0xc,%esp
  80091e:	50                   	push   %eax
  80091f:	e8 32 10 00 00       	call   801956 <malloc>
  800924:	83 c4 10             	add    $0x10,%esp
  800927:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START) || (uint32) ptr_allocations[11] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80092a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80092d:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800932:	75 0a                	jne    80093e <_main+0x906>
  800934:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800937:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  80093c:	76 17                	jbe    800955 <_main+0x91d>
  80093e:	83 ec 04             	sub    $0x4,%esp
  800941:	68 3c 2c 80 00       	push   $0x802c3c
  800946:	68 a1 00 00 00       	push   $0xa1
  80094b:	68 24 2c 80 00       	push   $0x802c24
  800950:	e8 53 01 00 00       	call   800aa8 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800955:	e8 4f 1c 00 00       	call   8025a9 <sys_pf_calculate_allocated_pages>
  80095a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80095d:	89 c2                	mov    %eax,%edx
  80095f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800962:	c1 e0 02             	shl    $0x2,%eax
  800965:	85 c0                	test   %eax,%eax
  800967:	79 05                	jns    80096e <_main+0x936>
  800969:	05 ff 0f 00 00       	add    $0xfff,%eax
  80096e:	c1 f8 0c             	sar    $0xc,%eax
  800971:	39 c2                	cmp    %eax,%edx
  800973:	74 17                	je     80098c <_main+0x954>
  800975:	83 ec 04             	sub    $0x4,%esp
  800978:	68 6c 2c 80 00       	push   $0x802c6c
  80097d:	68 a3 00 00 00       	push   $0xa3
  800982:	68 24 2c 80 00       	push   $0x802c24
  800987:	e8 1c 01 00 00       	call   800aa8 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  80098c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	01 c0                	add    %eax,%eax
  800993:	01 d0                	add    %edx,%eax
  800995:	01 c0                	add    %eax,%eax
  800997:	01 d0                	add    %edx,%eax
  800999:	01 c0                	add    %eax,%eax
  80099b:	f7 d8                	neg    %eax
  80099d:	05 00 00 00 20       	add    $0x20000000,%eax
  8009a2:	83 ec 0c             	sub    $0xc,%esp
  8009a5:	50                   	push   %eax
  8009a6:	e8 ab 0f 00 00       	call   801956 <malloc>
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8009b1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8009b4:	85 c0                	test   %eax,%eax
  8009b6:	74 17                	je     8009cf <_main+0x997>
  8009b8:	83 ec 04             	sub    $0x4,%esp
  8009bb:	68 a0 2c 80 00       	push   $0x802ca0
  8009c0:	68 ac 00 00 00       	push   $0xac
  8009c5:	68 24 2c 80 00       	push   $0x802c24
  8009ca:	e8 d9 00 00 00       	call   800aa8 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8009cf:	83 ec 0c             	sub    $0xc,%esp
  8009d2:	68 04 2d 80 00       	push   $0x802d04
  8009d7:	e8 f7 01 00 00       	call   800bd3 <cprintf>
  8009dc:	83 c4 10             	add    $0x10,%esp

		return;
  8009df:	90                   	nop
	}
}
  8009e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009e3:	5b                   	pop    %ebx
  8009e4:	5f                   	pop    %edi
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009f1:	7e 0a                	jle    8009fd <libmain+0x16>
		binaryname = argv[0];
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8b 00                	mov    (%eax),%eax
  8009f8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	ff 75 08             	pushl  0x8(%ebp)
  800a06:	e8 2d f6 ff ff       	call   800038 <_main>
  800a0b:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800a0e:	e8 61 1a 00 00       	call   802474 <sys_getenvid>
  800a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a19:	89 d0                	mov    %edx,%eax
  800a1b:	c1 e0 03             	shl    $0x3,%eax
  800a1e:	01 d0                	add    %edx,%eax
  800a20:	01 c0                	add    %eax,%eax
  800a22:	01 d0                	add    %edx,%eax
  800a24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a2b:	01 d0                	add    %edx,%eax
  800a2d:	c1 e0 03             	shl    $0x3,%eax
  800a30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a35:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800a38:	e8 85 1b 00 00       	call   8025c2 <sys_disable_interrupt>
		cprintf("**************************************\n");
  800a3d:	83 ec 0c             	sub    $0xc,%esp
  800a40:	68 64 2d 80 00       	push   $0x802d64
  800a45:	e8 89 01 00 00       	call   800bd3 <cprintf>
  800a4a:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a50:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	50                   	push   %eax
  800a5a:	68 8c 2d 80 00       	push   $0x802d8c
  800a5f:	e8 6f 01 00 00       	call   800bd3 <cprintf>
  800a64:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	68 64 2d 80 00       	push   $0x802d64
  800a6f:	e8 5f 01 00 00       	call   800bd3 <cprintf>
  800a74:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a77:	e8 60 1b 00 00       	call   8025dc <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a7c:	e8 19 00 00 00       	call   800a9a <exit>
}
  800a81:	90                   	nop
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800a8a:	83 ec 0c             	sub    $0xc,%esp
  800a8d:	6a 00                	push   $0x0
  800a8f:	e8 c5 19 00 00       	call   802459 <sys_env_destroy>
  800a94:	83 c4 10             	add    $0x10,%esp
}
  800a97:	90                   	nop
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <exit>:

void
exit(void)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800aa0:	e8 e8 19 00 00       	call   80248d <sys_env_exit>
}
  800aa5:	90                   	nop
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aae:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab1:	83 c0 04             	add    $0x4,%eax
  800ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800ab7:	a1 50 40 98 00       	mov    0x984050,%eax
  800abc:	85 c0                	test   %eax,%eax
  800abe:	74 16                	je     800ad6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ac0:	a1 50 40 98 00       	mov    0x984050,%eax
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	50                   	push   %eax
  800ac9:	68 a5 2d 80 00       	push   $0x802da5
  800ace:	e8 00 01 00 00       	call   800bd3 <cprintf>
  800ad3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ad6:	a1 00 40 80 00       	mov    0x804000,%eax
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	ff 75 08             	pushl  0x8(%ebp)
  800ae1:	50                   	push   %eax
  800ae2:	68 aa 2d 80 00       	push   $0x802daa
  800ae7:	e8 e7 00 00 00       	call   800bd3 <cprintf>
  800aec:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800aef:	8b 45 10             	mov    0x10(%ebp),%eax
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 f4             	pushl  -0xc(%ebp)
  800af8:	50                   	push   %eax
  800af9:	e8 7a 00 00 00       	call   800b78 <vcprintf>
  800afe:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800b01:	83 ec 0c             	sub    $0xc,%esp
  800b04:	68 c6 2d 80 00       	push   $0x802dc6
  800b09:	e8 c5 00 00 00       	call   800bd3 <cprintf>
  800b0e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b11:	e8 84 ff ff ff       	call   800a9a <exit>

	// should not return here
	while (1) ;
  800b16:	eb fe                	jmp    800b16 <_panic+0x6e>

00800b18 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	8d 48 01             	lea    0x1(%eax),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 0a                	mov    %ecx,(%edx)
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	88 d1                	mov    %dl,%cl
  800b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b33:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b41:	75 23                	jne    800b66 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	89 c2                	mov    %eax,%edx
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	83 c0 08             	add    $0x8,%eax
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	52                   	push   %edx
  800b54:	50                   	push   %eax
  800b55:	e8 c9 18 00 00       	call   802423 <sys_cputs>
  800b5a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 40 04             	mov    0x4(%eax),%eax
  800b6c:	8d 50 01             	lea    0x1(%eax),%edx
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b75:	90                   	nop
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    

00800b78 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b81:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b88:	00 00 00 
	b.cnt = 0;
  800b8b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b92:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	ff 75 08             	pushl  0x8(%ebp)
  800b9b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba1:	50                   	push   %eax
  800ba2:	68 18 0b 80 00       	push   $0x800b18
  800ba7:	e8 fa 01 00 00       	call   800da6 <vprintfmt>
  800bac:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800baf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	50                   	push   %eax
  800bb9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bbf:	83 c0 08             	add    $0x8,%eax
  800bc2:	50                   	push   %eax
  800bc3:	e8 5b 18 00 00       	call   802423 <sys_cputs>
  800bc8:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800bcb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bd9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 f4             	pushl  -0xc(%ebp)
  800be8:	50                   	push   %eax
  800be9:	e8 8a ff ff ff       	call   800b78 <vcprintf>
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bff:	e8 be 19 00 00       	call   8025c2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c04:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	83 ec 08             	sub    $0x8,%esp
  800c10:	ff 75 f4             	pushl  -0xc(%ebp)
  800c13:	50                   	push   %eax
  800c14:	e8 5f ff ff ff       	call   800b78 <vcprintf>
  800c19:	83 c4 10             	add    $0x10,%esp
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c1f:	e8 b8 19 00 00       	call   8025dc <sys_enable_interrupt>
	return cnt;
  800c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	53                   	push   %ebx
  800c2d:	83 ec 14             	sub    $0x14,%esp
  800c30:	8b 45 10             	mov    0x10(%ebp),%eax
  800c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c3c:	8b 45 18             	mov    0x18(%ebp),%eax
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c47:	77 55                	ja     800c9e <printnum+0x75>
  800c49:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c4c:	72 05                	jb     800c53 <printnum+0x2a>
  800c4e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c51:	77 4b                	ja     800c9e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c53:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c56:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c59:	8b 45 18             	mov    0x18(%ebp),%eax
  800c5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c61:	52                   	push   %edx
  800c62:	50                   	push   %eax
  800c63:	ff 75 f4             	pushl  -0xc(%ebp)
  800c66:	ff 75 f0             	pushl  -0x10(%ebp)
  800c69:	e8 f2 1c 00 00       	call   802960 <__udivdi3>
  800c6e:	83 c4 10             	add    $0x10,%esp
  800c71:	83 ec 04             	sub    $0x4,%esp
  800c74:	ff 75 20             	pushl  0x20(%ebp)
  800c77:	53                   	push   %ebx
  800c78:	ff 75 18             	pushl  0x18(%ebp)
  800c7b:	52                   	push   %edx
  800c7c:	50                   	push   %eax
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	ff 75 08             	pushl  0x8(%ebp)
  800c83:	e8 a1 ff ff ff       	call   800c29 <printnum>
  800c88:	83 c4 20             	add    $0x20,%esp
  800c8b:	eb 1a                	jmp    800ca7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	ff 75 20             	pushl  0x20(%ebp)
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	ff d0                	call   *%eax
  800c9b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c9e:	ff 4d 1c             	decl   0x1c(%ebp)
  800ca1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ca5:	7f e6                	jg     800c8d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ca7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800caa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb5:	53                   	push   %ebx
  800cb6:	51                   	push   %ecx
  800cb7:	52                   	push   %edx
  800cb8:	50                   	push   %eax
  800cb9:	e8 b2 1d 00 00       	call   802a70 <__umoddi3>
  800cbe:	83 c4 10             	add    $0x10,%esp
  800cc1:	05 f4 2f 80 00       	add    $0x802ff4,%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	0f be c0             	movsbl %al,%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
}
  800cda:	90                   	nop
  800cdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cde:	c9                   	leave  
  800cdf:	c3                   	ret    

00800ce0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ce3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ce7:	7e 1c                	jle    800d05 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8b 00                	mov    (%eax),%eax
  800cee:	8d 50 08             	lea    0x8(%eax),%edx
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	89 10                	mov    %edx,(%eax)
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8b 00                	mov    (%eax),%eax
  800cfb:	83 e8 08             	sub    $0x8,%eax
  800cfe:	8b 50 04             	mov    0x4(%eax),%edx
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	eb 40                	jmp    800d45 <getuint+0x65>
	else if (lflag)
  800d05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d09:	74 1e                	je     800d29 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	8d 50 04             	lea    0x4(%eax),%edx
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	89 10                	mov    %edx,(%eax)
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8b 00                	mov    (%eax),%eax
  800d1d:	83 e8 04             	sub    $0x4,%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	ba 00 00 00 00       	mov    $0x0,%edx
  800d27:	eb 1c                	jmp    800d45 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8b 00                	mov    (%eax),%eax
  800d2e:	8d 50 04             	lea    0x4(%eax),%edx
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	89 10                	mov    %edx,(%eax)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8b 00                	mov    (%eax),%eax
  800d3b:	83 e8 04             	sub    $0x4,%eax
  800d3e:	8b 00                	mov    (%eax),%eax
  800d40:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d4a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d4e:	7e 1c                	jle    800d6c <getint+0x25>
		return va_arg(*ap, long long);
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8b 00                	mov    (%eax),%eax
  800d55:	8d 50 08             	lea    0x8(%eax),%edx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	89 10                	mov    %edx,(%eax)
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	83 e8 08             	sub    $0x8,%eax
  800d65:	8b 50 04             	mov    0x4(%eax),%edx
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	eb 38                	jmp    800da4 <getint+0x5d>
	else if (lflag)
  800d6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d70:	74 1a                	je     800d8c <getint+0x45>
		return va_arg(*ap, long);
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	8d 50 04             	lea    0x4(%eax),%edx
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	89 10                	mov    %edx,(%eax)
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8b 00                	mov    (%eax),%eax
  800d84:	83 e8 04             	sub    $0x4,%eax
  800d87:	8b 00                	mov    (%eax),%eax
  800d89:	99                   	cltd   
  800d8a:	eb 18                	jmp    800da4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8b 00                	mov    (%eax),%eax
  800d91:	8d 50 04             	lea    0x4(%eax),%edx
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	89 10                	mov    %edx,(%eax)
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	83 e8 04             	sub    $0x4,%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	99                   	cltd   
}
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
  800dab:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dae:	eb 17                	jmp    800dc7 <vprintfmt+0x21>
			if (ch == '\0')
  800db0:	85 db                	test   %ebx,%ebx
  800db2:	0f 84 af 03 00 00    	je     801167 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800db8:	83 ec 08             	sub    $0x8,%esp
  800dbb:	ff 75 0c             	pushl  0xc(%ebp)
  800dbe:	53                   	push   %ebx
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	ff d0                	call   *%eax
  800dc4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dca:	8d 50 01             	lea    0x1(%eax),%edx
  800dcd:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	0f b6 d8             	movzbl %al,%ebx
  800dd5:	83 fb 25             	cmp    $0x25,%ebx
  800dd8:	75 d6                	jne    800db0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dda:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dde:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800de5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800df3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfd:	8d 50 01             	lea    0x1(%eax),%edx
  800e00:	89 55 10             	mov    %edx,0x10(%ebp)
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	0f b6 d8             	movzbl %al,%ebx
  800e08:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e0b:	83 f8 55             	cmp    $0x55,%eax
  800e0e:	0f 87 2b 03 00 00    	ja     80113f <vprintfmt+0x399>
  800e14:	8b 04 85 18 30 80 00 	mov    0x803018(,%eax,4),%eax
  800e1b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e1d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e21:	eb d7                	jmp    800dfa <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e23:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e27:	eb d1                	jmp    800dfa <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e29:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e33:	89 d0                	mov    %edx,%eax
  800e35:	c1 e0 02             	shl    $0x2,%eax
  800e38:	01 d0                	add    %edx,%eax
  800e3a:	01 c0                	add    %eax,%eax
  800e3c:	01 d8                	add    %ebx,%eax
  800e3e:	83 e8 30             	sub    $0x30,%eax
  800e41:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e44:	8b 45 10             	mov    0x10(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e4c:	83 fb 2f             	cmp    $0x2f,%ebx
  800e4f:	7e 3e                	jle    800e8f <vprintfmt+0xe9>
  800e51:	83 fb 39             	cmp    $0x39,%ebx
  800e54:	7f 39                	jg     800e8f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e56:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e59:	eb d5                	jmp    800e30 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5e:	83 c0 04             	add    $0x4,%eax
  800e61:	89 45 14             	mov    %eax,0x14(%ebp)
  800e64:	8b 45 14             	mov    0x14(%ebp),%eax
  800e67:	83 e8 04             	sub    $0x4,%eax
  800e6a:	8b 00                	mov    (%eax),%eax
  800e6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e6f:	eb 1f                	jmp    800e90 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e75:	79 83                	jns    800dfa <vprintfmt+0x54>
				width = 0;
  800e77:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e7e:	e9 77 ff ff ff       	jmp    800dfa <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e83:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e8a:	e9 6b ff ff ff       	jmp    800dfa <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e8f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e94:	0f 89 60 ff ff ff    	jns    800dfa <vprintfmt+0x54>
				width = precision, precision = -1;
  800e9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ea0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ea7:	e9 4e ff ff ff       	jmp    800dfa <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800eac:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800eaf:	e9 46 ff ff ff       	jmp    800dfa <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	83 c0 04             	add    $0x4,%eax
  800eba:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 00                	mov    (%eax),%eax
  800ec5:	83 ec 08             	sub    $0x8,%esp
  800ec8:	ff 75 0c             	pushl  0xc(%ebp)
  800ecb:	50                   	push   %eax
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			break;
  800ed4:	e9 89 02 00 00       	jmp    801162 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ed9:	8b 45 14             	mov    0x14(%ebp),%eax
  800edc:	83 c0 04             	add    $0x4,%eax
  800edf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee5:	83 e8 04             	sub    $0x4,%eax
  800ee8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800eea:	85 db                	test   %ebx,%ebx
  800eec:	79 02                	jns    800ef0 <vprintfmt+0x14a>
				err = -err;
  800eee:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ef0:	83 fb 64             	cmp    $0x64,%ebx
  800ef3:	7f 0b                	jg     800f00 <vprintfmt+0x15a>
  800ef5:	8b 34 9d 60 2e 80 00 	mov    0x802e60(,%ebx,4),%esi
  800efc:	85 f6                	test   %esi,%esi
  800efe:	75 19                	jne    800f19 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f00:	53                   	push   %ebx
  800f01:	68 05 30 80 00       	push   $0x803005
  800f06:	ff 75 0c             	pushl  0xc(%ebp)
  800f09:	ff 75 08             	pushl  0x8(%ebp)
  800f0c:	e8 5e 02 00 00       	call   80116f <printfmt>
  800f11:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f14:	e9 49 02 00 00       	jmp    801162 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f19:	56                   	push   %esi
  800f1a:	68 0e 30 80 00       	push   $0x80300e
  800f1f:	ff 75 0c             	pushl  0xc(%ebp)
  800f22:	ff 75 08             	pushl  0x8(%ebp)
  800f25:	e8 45 02 00 00       	call   80116f <printfmt>
  800f2a:	83 c4 10             	add    $0x10,%esp
			break;
  800f2d:	e9 30 02 00 00       	jmp    801162 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f32:	8b 45 14             	mov    0x14(%ebp),%eax
  800f35:	83 c0 04             	add    $0x4,%eax
  800f38:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3e:	83 e8 04             	sub    $0x4,%eax
  800f41:	8b 30                	mov    (%eax),%esi
  800f43:	85 f6                	test   %esi,%esi
  800f45:	75 05                	jne    800f4c <vprintfmt+0x1a6>
				p = "(null)";
  800f47:	be 11 30 80 00       	mov    $0x803011,%esi
			if (width > 0 && padc != '-')
  800f4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f50:	7e 6d                	jle    800fbf <vprintfmt+0x219>
  800f52:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f56:	74 67                	je     800fbf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f5b:	83 ec 08             	sub    $0x8,%esp
  800f5e:	50                   	push   %eax
  800f5f:	56                   	push   %esi
  800f60:	e8 0c 03 00 00       	call   801271 <strnlen>
  800f65:	83 c4 10             	add    $0x10,%esp
  800f68:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f6b:	eb 16                	jmp    800f83 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f6d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f71:	83 ec 08             	sub    $0x8,%esp
  800f74:	ff 75 0c             	pushl  0xc(%ebp)
  800f77:	50                   	push   %eax
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	ff d0                	call   *%eax
  800f7d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f80:	ff 4d e4             	decl   -0x1c(%ebp)
  800f83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f87:	7f e4                	jg     800f6d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f89:	eb 34                	jmp    800fbf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f8f:	74 1c                	je     800fad <vprintfmt+0x207>
  800f91:	83 fb 1f             	cmp    $0x1f,%ebx
  800f94:	7e 05                	jle    800f9b <vprintfmt+0x1f5>
  800f96:	83 fb 7e             	cmp    $0x7e,%ebx
  800f99:	7e 12                	jle    800fad <vprintfmt+0x207>
					putch('?', putdat);
  800f9b:	83 ec 08             	sub    $0x8,%esp
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	6a 3f                	push   $0x3f
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
  800fab:	eb 0f                	jmp    800fbc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fad:	83 ec 08             	sub    $0x8,%esp
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	53                   	push   %ebx
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	ff d0                	call   *%eax
  800fb9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fbc:	ff 4d e4             	decl   -0x1c(%ebp)
  800fbf:	89 f0                	mov    %esi,%eax
  800fc1:	8d 70 01             	lea    0x1(%eax),%esi
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	0f be d8             	movsbl %al,%ebx
  800fc9:	85 db                	test   %ebx,%ebx
  800fcb:	74 24                	je     800ff1 <vprintfmt+0x24b>
  800fcd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fd1:	78 b8                	js     800f8b <vprintfmt+0x1e5>
  800fd3:	ff 4d e0             	decl   -0x20(%ebp)
  800fd6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fda:	79 af                	jns    800f8b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fdc:	eb 13                	jmp    800ff1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fde:	83 ec 08             	sub    $0x8,%esp
  800fe1:	ff 75 0c             	pushl  0xc(%ebp)
  800fe4:	6a 20                	push   $0x20
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	ff d0                	call   *%eax
  800feb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fee:	ff 4d e4             	decl   -0x1c(%ebp)
  800ff1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff5:	7f e7                	jg     800fde <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ff7:	e9 66 01 00 00       	jmp    801162 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 e8             	pushl  -0x18(%ebp)
  801002:	8d 45 14             	lea    0x14(%ebp),%eax
  801005:	50                   	push   %eax
  801006:	e8 3c fd ff ff       	call   800d47 <getint>
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801011:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801017:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101a:	85 d2                	test   %edx,%edx
  80101c:	79 23                	jns    801041 <vprintfmt+0x29b>
				putch('-', putdat);
  80101e:	83 ec 08             	sub    $0x8,%esp
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	6a 2d                	push   $0x2d
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	ff d0                	call   *%eax
  80102b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80102e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801031:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801034:	f7 d8                	neg    %eax
  801036:	83 d2 00             	adc    $0x0,%edx
  801039:	f7 da                	neg    %edx
  80103b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801041:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801048:	e9 bc 00 00 00       	jmp    801109 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80104d:	83 ec 08             	sub    $0x8,%esp
  801050:	ff 75 e8             	pushl  -0x18(%ebp)
  801053:	8d 45 14             	lea    0x14(%ebp),%eax
  801056:	50                   	push   %eax
  801057:	e8 84 fc ff ff       	call   800ce0 <getuint>
  80105c:	83 c4 10             	add    $0x10,%esp
  80105f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801062:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801065:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80106c:	e9 98 00 00 00       	jmp    801109 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801071:	83 ec 08             	sub    $0x8,%esp
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	6a 58                	push   $0x58
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	ff d0                	call   *%eax
  80107e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 58                	push   $0x58
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	6a 58                	push   $0x58
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	ff d0                	call   *%eax
  80109e:	83 c4 10             	add    $0x10,%esp
			break;
  8010a1:	e9 bc 00 00 00       	jmp    801162 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8010a6:	83 ec 08             	sub    $0x8,%esp
  8010a9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ac:	6a 30                	push   $0x30
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	ff d0                	call   *%eax
  8010b3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010b6:	83 ec 08             	sub    $0x8,%esp
  8010b9:	ff 75 0c             	pushl  0xc(%ebp)
  8010bc:	6a 78                	push   $0x78
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	ff d0                	call   *%eax
  8010c3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c9:	83 c0 04             	add    $0x4,%eax
  8010cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8010cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d2:	83 e8 04             	sub    $0x4,%eax
  8010d5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010e1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010e8:	eb 1f                	jmp    801109 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010ea:	83 ec 08             	sub    $0x8,%esp
  8010ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8010f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8010f3:	50                   	push   %eax
  8010f4:	e8 e7 fb ff ff       	call   800ce0 <getuint>
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801102:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801109:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80110d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801110:	83 ec 04             	sub    $0x4,%esp
  801113:	52                   	push   %edx
  801114:	ff 75 e4             	pushl  -0x1c(%ebp)
  801117:	50                   	push   %eax
  801118:	ff 75 f4             	pushl  -0xc(%ebp)
  80111b:	ff 75 f0             	pushl  -0x10(%ebp)
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	ff 75 08             	pushl  0x8(%ebp)
  801124:	e8 00 fb ff ff       	call   800c29 <printnum>
  801129:	83 c4 20             	add    $0x20,%esp
			break;
  80112c:	eb 34                	jmp    801162 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	ff 75 0c             	pushl  0xc(%ebp)
  801134:	53                   	push   %ebx
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	ff d0                	call   *%eax
  80113a:	83 c4 10             	add    $0x10,%esp
			break;
  80113d:	eb 23                	jmp    801162 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80113f:	83 ec 08             	sub    $0x8,%esp
  801142:	ff 75 0c             	pushl  0xc(%ebp)
  801145:	6a 25                	push   $0x25
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	ff d0                	call   *%eax
  80114c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80114f:	ff 4d 10             	decl   0x10(%ebp)
  801152:	eb 03                	jmp    801157 <vprintfmt+0x3b1>
  801154:	ff 4d 10             	decl   0x10(%ebp)
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	48                   	dec    %eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 25                	cmp    $0x25,%al
  80115f:	75 f3                	jne    801154 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801161:	90                   	nop
		}
	}
  801162:	e9 47 fc ff ff       	jmp    800dae <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801167:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801168:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5e                   	pop    %esi
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801175:	8d 45 10             	lea    0x10(%ebp),%eax
  801178:	83 c0 04             	add    $0x4,%eax
  80117b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80117e:	8b 45 10             	mov    0x10(%ebp),%eax
  801181:	ff 75 f4             	pushl  -0xc(%ebp)
  801184:	50                   	push   %eax
  801185:	ff 75 0c             	pushl  0xc(%ebp)
  801188:	ff 75 08             	pushl  0x8(%ebp)
  80118b:	e8 16 fc ff ff       	call   800da6 <vprintfmt>
  801190:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801193:	90                   	nop
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	8b 40 08             	mov    0x8(%eax),%eax
  80119f:	8d 50 01             	lea    0x1(%eax),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	8b 10                	mov    (%eax),%edx
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	8b 40 04             	mov    0x4(%eax),%eax
  8011b3:	39 c2                	cmp    %eax,%edx
  8011b5:	73 12                	jae    8011c9 <sprintputch+0x33>
		*b->buf++ = ch;
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	8b 00                	mov    (%eax),%eax
  8011bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8011bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c2:	89 0a                	mov    %ecx,(%edx)
  8011c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c7:	88 10                	mov    %dl,(%eax)
}
  8011c9:	90                   	nop
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f1:	74 06                	je     8011f9 <vsnprintf+0x2d>
  8011f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011f7:	7f 07                	jg     801200 <vsnprintf+0x34>
		return -E_INVAL;
  8011f9:	b8 03 00 00 00       	mov    $0x3,%eax
  8011fe:	eb 20                	jmp    801220 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801200:	ff 75 14             	pushl  0x14(%ebp)
  801203:	ff 75 10             	pushl  0x10(%ebp)
  801206:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801209:	50                   	push   %eax
  80120a:	68 96 11 80 00       	push   $0x801196
  80120f:	e8 92 fb ff ff       	call   800da6 <vprintfmt>
  801214:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80121d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801220:	c9                   	leave  
  801221:	c3                   	ret    

00801222 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801228:	8d 45 10             	lea    0x10(%ebp),%eax
  80122b:	83 c0 04             	add    $0x4,%eax
  80122e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	ff 75 f4             	pushl  -0xc(%ebp)
  801237:	50                   	push   %eax
  801238:	ff 75 0c             	pushl  0xc(%ebp)
  80123b:	ff 75 08             	pushl  0x8(%ebp)
  80123e:	e8 89 ff ff ff       	call   8011cc <vsnprintf>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801249:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125b:	eb 06                	jmp    801263 <strlen+0x15>
		n++;
  80125d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801260:	ff 45 08             	incl   0x8(%ebp)
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	84 c0                	test   %al,%al
  80126a:	75 f1                	jne    80125d <strlen+0xf>
		n++;
	return n;
  80126c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801277:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80127e:	eb 09                	jmp    801289 <strnlen+0x18>
		n++;
  801280:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801283:	ff 45 08             	incl   0x8(%ebp)
  801286:	ff 4d 0c             	decl   0xc(%ebp)
  801289:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80128d:	74 09                	je     801298 <strnlen+0x27>
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	84 c0                	test   %al,%al
  801296:	75 e8                	jne    801280 <strnlen+0xf>
		n++;
	return n;
  801298:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012a9:	90                   	nop
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8d 50 01             	lea    0x1(%eax),%edx
  8012b0:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012b9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012bc:	8a 12                	mov    (%edx),%dl
  8012be:	88 10                	mov    %dl,(%eax)
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	84 c0                	test   %al,%al
  8012c4:	75 e4                	jne    8012aa <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012de:	eb 1f                	jmp    8012ff <strncpy+0x34>
		*dst++ = *src;
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8d 50 01             	lea    0x1(%eax),%edx
  8012e6:	89 55 08             	mov    %edx,0x8(%ebp)
  8012e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ec:	8a 12                	mov    (%edx),%dl
  8012ee:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	84 c0                	test   %al,%al
  8012f7:	74 03                	je     8012fc <strncpy+0x31>
			src++;
  8012f9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012fc:	ff 45 fc             	incl   -0x4(%ebp)
  8012ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801302:	3b 45 10             	cmp    0x10(%ebp),%eax
  801305:	72 d9                	jb     8012e0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801307:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80131c:	74 30                	je     80134e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80131e:	eb 16                	jmp    801336 <strlcpy+0x2a>
			*dst++ = *src++;
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8d 50 01             	lea    0x1(%eax),%edx
  801326:	89 55 08             	mov    %edx,0x8(%ebp)
  801329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80132f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801332:	8a 12                	mov    (%edx),%dl
  801334:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801336:	ff 4d 10             	decl   0x10(%ebp)
  801339:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80133d:	74 09                	je     801348 <strlcpy+0x3c>
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	84 c0                	test   %al,%al
  801346:	75 d8                	jne    801320 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80134e:	8b 55 08             	mov    0x8(%ebp),%edx
  801351:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801354:	29 c2                	sub    %eax,%edx
  801356:	89 d0                	mov    %edx,%eax
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80135d:	eb 06                	jmp    801365 <strcmp+0xb>
		p++, q++;
  80135f:	ff 45 08             	incl   0x8(%ebp)
  801362:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	84 c0                	test   %al,%al
  80136c:	74 0e                	je     80137c <strcmp+0x22>
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	8a 10                	mov    (%eax),%dl
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	38 c2                	cmp    %al,%dl
  80137a:	74 e3                	je     80135f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8a 00                	mov    (%eax),%al
  801381:	0f b6 d0             	movzbl %al,%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	0f b6 c0             	movzbl %al,%eax
  80138c:	29 c2                	sub    %eax,%edx
  80138e:	89 d0                	mov    %edx,%eax
}
  801390:	5d                   	pop    %ebp
  801391:	c3                   	ret    

00801392 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801395:	eb 09                	jmp    8013a0 <strncmp+0xe>
		n--, p++, q++;
  801397:	ff 4d 10             	decl   0x10(%ebp)
  80139a:	ff 45 08             	incl   0x8(%ebp)
  80139d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a4:	74 17                	je     8013bd <strncmp+0x2b>
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	8a 00                	mov    (%eax),%al
  8013ab:	84 c0                	test   %al,%al
  8013ad:	74 0e                	je     8013bd <strncmp+0x2b>
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 10                	mov    (%eax),%dl
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	8a 00                	mov    (%eax),%al
  8013b9:	38 c2                	cmp    %al,%dl
  8013bb:	74 da                	je     801397 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c1:	75 07                	jne    8013ca <strncmp+0x38>
		return 0;
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c8:	eb 14                	jmp    8013de <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	0f b6 c0             	movzbl %al,%eax
  8013da:	29 c2                	sub    %eax,%edx
  8013dc:	89 d0                	mov    %edx,%eax
}
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013ec:	eb 12                	jmp    801400 <strchr+0x20>
		if (*s == c)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013f6:	75 05                	jne    8013fd <strchr+0x1d>
			return (char *) s;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	eb 11                	jmp    80140e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013fd:	ff 45 08             	incl   0x8(%ebp)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	75 e5                	jne    8013ee <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801409:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80141c:	eb 0d                	jmp    80142b <strfind+0x1b>
		if (*s == c)
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801426:	74 0e                	je     801436 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801428:	ff 45 08             	incl   0x8(%ebp)
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	84 c0                	test   %al,%al
  801432:	75 ea                	jne    80141e <strfind+0xe>
  801434:	eb 01                	jmp    801437 <strfind+0x27>
		if (*s == c)
			break;
  801436:	90                   	nop
	return (char *) s;
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801448:	8b 45 10             	mov    0x10(%ebp),%eax
  80144b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80144e:	eb 0e                	jmp    80145e <memset+0x22>
		*p++ = c;
  801450:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801453:	8d 50 01             	lea    0x1(%eax),%edx
  801456:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801459:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80145e:	ff 4d f8             	decl   -0x8(%ebp)
  801461:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801465:	79 e9                	jns    801450 <memset+0x14>
		*p++ = c;

	return v;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801472:	8b 45 0c             	mov    0xc(%ebp),%eax
  801475:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80147e:	eb 16                	jmp    801496 <memcpy+0x2a>
		*d++ = *s++;
  801480:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801483:	8d 50 01             	lea    0x1(%eax),%edx
  801486:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801489:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80148f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801492:	8a 12                	mov    (%edx),%dl
  801494:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801496:	8b 45 10             	mov    0x10(%ebp),%eax
  801499:	8d 50 ff             	lea    -0x1(%eax),%edx
  80149c:	89 55 10             	mov    %edx,0x10(%ebp)
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	75 dd                	jne    801480 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8014ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014c0:	73 50                	jae    801512 <memmove+0x6a>
  8014c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014cd:	76 43                	jbe    801512 <memmove+0x6a>
		s += n;
  8014cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014db:	eb 10                	jmp    8014ed <memmove+0x45>
			*--d = *--s;
  8014dd:	ff 4d f8             	decl   -0x8(%ebp)
  8014e0:	ff 4d fc             	decl   -0x4(%ebp)
  8014e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e6:	8a 10                	mov    (%eax),%dl
  8014e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014eb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 e3                	jne    8014dd <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014fa:	eb 23                	jmp    80151f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	8d 50 01             	lea    0x1(%eax),%edx
  801502:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801505:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801508:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80150e:	8a 12                	mov    (%edx),%dl
  801510:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801512:	8b 45 10             	mov    0x10(%ebp),%eax
  801515:	8d 50 ff             	lea    -0x1(%eax),%edx
  801518:	89 55 10             	mov    %edx,0x10(%ebp)
  80151b:	85 c0                	test   %eax,%eax
  80151d:	75 dd                	jne    8014fc <memmove+0x54>
			*d++ = *s++;

	return dst;
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801536:	eb 2a                	jmp    801562 <memcmp+0x3e>
		if (*s1 != *s2)
  801538:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153b:	8a 10                	mov    (%eax),%dl
  80153d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	38 c2                	cmp    %al,%dl
  801544:	74 16                	je     80155c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801546:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	0f b6 d0             	movzbl %al,%edx
  80154e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801551:	8a 00                	mov    (%eax),%al
  801553:	0f b6 c0             	movzbl %al,%eax
  801556:	29 c2                	sub    %eax,%edx
  801558:	89 d0                	mov    %edx,%eax
  80155a:	eb 18                	jmp    801574 <memcmp+0x50>
		s1++, s2++;
  80155c:	ff 45 fc             	incl   -0x4(%ebp)
  80155f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801562:	8b 45 10             	mov    0x10(%ebp),%eax
  801565:	8d 50 ff             	lea    -0x1(%eax),%edx
  801568:	89 55 10             	mov    %edx,0x10(%ebp)
  80156b:	85 c0                	test   %eax,%eax
  80156d:	75 c9                	jne    801538 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80157c:	8b 55 08             	mov    0x8(%ebp),%edx
  80157f:	8b 45 10             	mov    0x10(%ebp),%eax
  801582:	01 d0                	add    %edx,%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801587:	eb 15                	jmp    80159e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	8a 00                	mov    (%eax),%al
  80158e:	0f b6 d0             	movzbl %al,%edx
  801591:	8b 45 0c             	mov    0xc(%ebp),%eax
  801594:	0f b6 c0             	movzbl %al,%eax
  801597:	39 c2                	cmp    %eax,%edx
  801599:	74 0d                	je     8015a8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80159b:	ff 45 08             	incl   0x8(%ebp)
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015a4:	72 e3                	jb     801589 <memfind+0x13>
  8015a6:	eb 01                	jmp    8015a9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015a8:	90                   	nop
	return (void *) s;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c2:	eb 03                	jmp    8015c7 <strtol+0x19>
		s++;
  8015c4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	3c 20                	cmp    $0x20,%al
  8015ce:	74 f4                	je     8015c4 <strtol+0x16>
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	8a 00                	mov    (%eax),%al
  8015d5:	3c 09                	cmp    $0x9,%al
  8015d7:	74 eb                	je     8015c4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	8a 00                	mov    (%eax),%al
  8015de:	3c 2b                	cmp    $0x2b,%al
  8015e0:	75 05                	jne    8015e7 <strtol+0x39>
		s++;
  8015e2:	ff 45 08             	incl   0x8(%ebp)
  8015e5:	eb 13                	jmp    8015fa <strtol+0x4c>
	else if (*s == '-')
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	8a 00                	mov    (%eax),%al
  8015ec:	3c 2d                	cmp    $0x2d,%al
  8015ee:	75 0a                	jne    8015fa <strtol+0x4c>
		s++, neg = 1;
  8015f0:	ff 45 08             	incl   0x8(%ebp)
  8015f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015fe:	74 06                	je     801606 <strtol+0x58>
  801600:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801604:	75 20                	jne    801626 <strtol+0x78>
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	3c 30                	cmp    $0x30,%al
  80160d:	75 17                	jne    801626 <strtol+0x78>
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	40                   	inc    %eax
  801613:	8a 00                	mov    (%eax),%al
  801615:	3c 78                	cmp    $0x78,%al
  801617:	75 0d                	jne    801626 <strtol+0x78>
		s += 2, base = 16;
  801619:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80161d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801624:	eb 28                	jmp    80164e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801626:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80162a:	75 15                	jne    801641 <strtol+0x93>
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	3c 30                	cmp    $0x30,%al
  801633:	75 0c                	jne    801641 <strtol+0x93>
		s++, base = 8;
  801635:	ff 45 08             	incl   0x8(%ebp)
  801638:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80163f:	eb 0d                	jmp    80164e <strtol+0xa0>
	else if (base == 0)
  801641:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801645:	75 07                	jne    80164e <strtol+0xa0>
		base = 10;
  801647:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	3c 2f                	cmp    $0x2f,%al
  801655:	7e 19                	jle    801670 <strtol+0xc2>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	3c 39                	cmp    $0x39,%al
  80165e:	7f 10                	jg     801670 <strtol+0xc2>
			dig = *s - '0';
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	0f be c0             	movsbl %al,%eax
  801668:	83 e8 30             	sub    $0x30,%eax
  80166b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166e:	eb 42                	jmp    8016b2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8a 00                	mov    (%eax),%al
  801675:	3c 60                	cmp    $0x60,%al
  801677:	7e 19                	jle    801692 <strtol+0xe4>
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	8a 00                	mov    (%eax),%al
  80167e:	3c 7a                	cmp    $0x7a,%al
  801680:	7f 10                	jg     801692 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	0f be c0             	movsbl %al,%eax
  80168a:	83 e8 57             	sub    $0x57,%eax
  80168d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801690:	eb 20                	jmp    8016b2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	3c 40                	cmp    $0x40,%al
  801699:	7e 39                	jle    8016d4 <strtol+0x126>
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	8a 00                	mov    (%eax),%al
  8016a0:	3c 5a                	cmp    $0x5a,%al
  8016a2:	7f 30                	jg     8016d4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	8a 00                	mov    (%eax),%al
  8016a9:	0f be c0             	movsbl %al,%eax
  8016ac:	83 e8 37             	sub    $0x37,%eax
  8016af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016b8:	7d 19                	jge    8016d3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ba:	ff 45 08             	incl   0x8(%ebp)
  8016bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016c4:	89 c2                	mov    %eax,%edx
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	01 d0                	add    %edx,%eax
  8016cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016ce:	e9 7b ff ff ff       	jmp    80164e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016d3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d8:	74 08                	je     8016e2 <strtol+0x134>
		*endptr = (char *) s;
  8016da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016e6:	74 07                	je     8016ef <strtol+0x141>
  8016e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016eb:	f7 d8                	neg    %eax
  8016ed:	eb 03                	jmp    8016f2 <strtol+0x144>
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <ltostr>:

void
ltostr(long value, char *str)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801701:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801708:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80170c:	79 13                	jns    801721 <ltostr+0x2d>
	{
		neg = 1;
  80170e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80171b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80171e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801729:	99                   	cltd   
  80172a:	f7 f9                	idiv   %ecx
  80172c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80172f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801732:	8d 50 01             	lea    0x1(%eax),%edx
  801735:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801738:	89 c2                	mov    %eax,%edx
  80173a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173d:	01 d0                	add    %edx,%eax
  80173f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801742:	83 c2 30             	add    $0x30,%edx
  801745:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801747:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80174a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80174f:	f7 e9                	imul   %ecx
  801751:	c1 fa 02             	sar    $0x2,%edx
  801754:	89 c8                	mov    %ecx,%eax
  801756:	c1 f8 1f             	sar    $0x1f,%eax
  801759:	29 c2                	sub    %eax,%edx
  80175b:	89 d0                	mov    %edx,%eax
  80175d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801760:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801763:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801768:	f7 e9                	imul   %ecx
  80176a:	c1 fa 02             	sar    $0x2,%edx
  80176d:	89 c8                	mov    %ecx,%eax
  80176f:	c1 f8 1f             	sar    $0x1f,%eax
  801772:	29 c2                	sub    %eax,%edx
  801774:	89 d0                	mov    %edx,%eax
  801776:	c1 e0 02             	shl    $0x2,%eax
  801779:	01 d0                	add    %edx,%eax
  80177b:	01 c0                	add    %eax,%eax
  80177d:	29 c1                	sub    %eax,%ecx
  80177f:	89 ca                	mov    %ecx,%edx
  801781:	85 d2                	test   %edx,%edx
  801783:	75 9c                	jne    801721 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801785:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80178c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178f:	48                   	dec    %eax
  801790:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801793:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801797:	74 3d                	je     8017d6 <ltostr+0xe2>
		start = 1 ;
  801799:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017a0:	eb 34                	jmp    8017d6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a8:	01 d0                	add    %edx,%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b5:	01 c2                	add    %eax,%edx
  8017b7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	01 c8                	add    %ecx,%eax
  8017bf:	8a 00                	mov    (%eax),%al
  8017c1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	01 c2                	add    %eax,%edx
  8017cb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017ce:	88 02                	mov    %al,(%edx)
		start++ ;
  8017d0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017d3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017dc:	7c c4                	jl     8017a2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017de:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	01 d0                	add    %edx,%eax
  8017e6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017e9:	90                   	nop
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	e8 54 fa ff ff       	call   80124e <strlen>
  8017fa:	83 c4 04             	add    $0x4,%esp
  8017fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801800:	ff 75 0c             	pushl  0xc(%ebp)
  801803:	e8 46 fa ff ff       	call   80124e <strlen>
  801808:	83 c4 04             	add    $0x4,%esp
  80180b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80180e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801815:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80181c:	eb 17                	jmp    801835 <strcconcat+0x49>
		final[s] = str1[s] ;
  80181e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801821:	8b 45 10             	mov    0x10(%ebp),%eax
  801824:	01 c2                	add    %eax,%edx
  801826:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	01 c8                	add    %ecx,%eax
  80182e:	8a 00                	mov    (%eax),%al
  801830:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801832:	ff 45 fc             	incl   -0x4(%ebp)
  801835:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801838:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80183b:	7c e1                	jl     80181e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80183d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801844:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80184b:	eb 1f                	jmp    80186c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80184d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801850:	8d 50 01             	lea    0x1(%eax),%edx
  801853:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801856:	89 c2                	mov    %eax,%edx
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	01 c2                	add    %eax,%edx
  80185d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	01 c8                	add    %ecx,%eax
  801865:	8a 00                	mov    (%eax),%al
  801867:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801869:	ff 45 f8             	incl   -0x8(%ebp)
  80186c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801872:	7c d9                	jl     80184d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801874:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801877:	8b 45 10             	mov    0x10(%ebp),%eax
  80187a:	01 d0                	add    %edx,%eax
  80187c:	c6 00 00             	movb   $0x0,(%eax)
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801885:	8b 45 14             	mov    0x14(%ebp),%eax
  801888:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80188e:	8b 45 14             	mov    0x14(%ebp),%eax
  801891:	8b 00                	mov    (%eax),%eax
  801893:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80189a:	8b 45 10             	mov    0x10(%ebp),%eax
  80189d:	01 d0                	add    %edx,%eax
  80189f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018a5:	eb 0c                	jmp    8018b3 <strsplit+0x31>
			*string++ = 0;
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8d 50 01             	lea    0x1(%eax),%edx
  8018ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8018b0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	84 c0                	test   %al,%al
  8018ba:	74 18                	je     8018d4 <strsplit+0x52>
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8a 00                	mov    (%eax),%al
  8018c1:	0f be c0             	movsbl %al,%eax
  8018c4:	50                   	push   %eax
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	e8 13 fb ff ff       	call   8013e0 <strchr>
  8018cd:	83 c4 08             	add    $0x8,%esp
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	75 d3                	jne    8018a7 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8a 00                	mov    (%eax),%al
  8018d9:	84 c0                	test   %al,%al
  8018db:	74 5a                	je     801937 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8018dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e0:	8b 00                	mov    (%eax),%eax
  8018e2:	83 f8 0f             	cmp    $0xf,%eax
  8018e5:	75 07                	jne    8018ee <strsplit+0x6c>
		{
			return 0;
  8018e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ec:	eb 66                	jmp    801954 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f1:	8b 00                	mov    (%eax),%eax
  8018f3:	8d 48 01             	lea    0x1(%eax),%ecx
  8018f6:	8b 55 14             	mov    0x14(%ebp),%edx
  8018f9:	89 0a                	mov    %ecx,(%edx)
  8018fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801902:	8b 45 10             	mov    0x10(%ebp),%eax
  801905:	01 c2                	add    %eax,%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80190c:	eb 03                	jmp    801911 <strsplit+0x8f>
			string++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	8a 00                	mov    (%eax),%al
  801916:	84 c0                	test   %al,%al
  801918:	74 8b                	je     8018a5 <strsplit+0x23>
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	8a 00                	mov    (%eax),%al
  80191f:	0f be c0             	movsbl %al,%eax
  801922:	50                   	push   %eax
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	e8 b5 fa ff ff       	call   8013e0 <strchr>
  80192b:	83 c4 08             	add    $0x8,%esp
  80192e:	85 c0                	test   %eax,%eax
  801930:	74 dc                	je     80190e <strsplit+0x8c>
			string++;
	}
  801932:	e9 6e ff ff ff       	jmp    8018a5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801937:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801938:	8b 45 14             	mov    0x14(%ebp),%eax
  80193b:	8b 00                	mov    (%eax),%eax
  80193d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801944:	8b 45 10             	mov    0x10(%ebp),%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80194f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  80195f:	e8 7d 0f 00 00       	call   8028e1 <sys_isUHeapPlacementStrategyNEXTFIT>
  801964:	85 c0                	test   %eax,%eax
  801966:	0f 84 6f 03 00 00    	je     801cdb <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  80196c:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801973:	8b 55 08             	mov    0x8(%ebp),%edx
  801976:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801979:	01 d0                	add    %edx,%eax
  80197b:	48                   	dec    %eax
  80197c:	89 45 80             	mov    %eax,-0x80(%ebp)
  80197f:	8b 45 80             	mov    -0x80(%ebp),%eax
  801982:	ba 00 00 00 00       	mov    $0x0,%edx
  801987:	f7 75 84             	divl   -0x7c(%ebp)
  80198a:	8b 45 80             	mov    -0x80(%ebp),%eax
  80198d:	29 d0                	sub    %edx,%eax
  80198f:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801992:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801996:	74 09                	je     8019a1 <malloc+0x4b>
  801998:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80199f:	76 0a                	jbe    8019ab <malloc+0x55>
			return NULL;
  8019a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a6:	e9 4b 09 00 00       	jmp    8022f6 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8019ab:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	01 d0                	add    %edx,%eax
  8019b6:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019bb:	0f 87 a2 00 00 00    	ja     801a63 <malloc+0x10d>
  8019c1:	a1 40 40 98 00       	mov    0x984040,%eax
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	0f 85 95 00 00 00    	jne    801a63 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  8019ce:	a1 04 40 80 00       	mov    0x804004,%eax
  8019d3:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8019d9:	a1 04 40 80 00       	mov    0x804004,%eax
  8019de:	83 ec 08             	sub    $0x8,%esp
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	50                   	push   %eax
  8019e5:	e8 a3 0b 00 00       	call   80258d <sys_allocateMem>
  8019ea:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  8019ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8019f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f5:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8019fc:	a1 20 40 80 00       	mov    0x804020,%eax
  801a01:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a07:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  801a0e:	a1 20 40 80 00       	mov    0x804020,%eax
  801a13:	40                   	inc    %eax
  801a14:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  801a19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801a20:	eb 2e                	jmp    801a50 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801a22:	a1 04 40 80 00       	mov    0x804004,%eax
  801a27:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801a2c:	c1 e8 0c             	shr    $0xc,%eax
  801a2f:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801a36:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801a3a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a3f:	05 00 10 00 00       	add    $0x1000,%eax
  801a44:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801a49:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a53:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a56:	72 ca                	jb     801a22 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801a58:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801a5e:	e9 93 08 00 00       	jmp    8022f6 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801a63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801a6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801a71:	a1 40 40 98 00       	mov    0x984040,%eax
  801a76:	85 c0                	test   %eax,%eax
  801a78:	75 1d                	jne    801a97 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801a7a:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801a81:	00 00 80 
				check = 1;
  801a84:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  801a8b:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801a8e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801a95:	eb 08                	jmp    801a9f <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801a97:	a1 04 40 80 00       	mov    0x804004,%eax
  801a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801a9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801aa6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801aad:	a1 04 40 80 00       	mov    0x804004,%eax
  801ab2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801ab5:	eb 4d                	jmp    801b04 <malloc+0x1ae>
				if (sz == size) {
  801ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aba:	3b 45 08             	cmp    0x8(%ebp),%eax
  801abd:	75 09                	jne    801ac8 <malloc+0x172>
					f = 1;
  801abf:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801ac6:	eb 45                	jmp    801b0d <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801ac8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801acb:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801ad0:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801ad3:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801ada:	85 c0                	test   %eax,%eax
  801adc:	75 10                	jne    801aee <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801ade:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801ae5:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801aec:	eb 16                	jmp    801b04 <malloc+0x1ae>
				} else {
					sz = 0;
  801aee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801af5:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aff:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801b04:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801b0b:	76 aa                	jbe    801ab7 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801b0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b11:	0f 84 95 00 00 00    	je     801bac <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801b17:	a1 04 40 80 00       	mov    0x804004,%eax
  801b1c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801b22:	a1 04 40 80 00       	mov    0x804004,%eax
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	50                   	push   %eax
  801b2e:	e8 5a 0a 00 00       	call   80258d <sys_allocateMem>
  801b33:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801b36:	a1 20 40 80 00       	mov    0x804020,%eax
  801b3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b3e:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801b45:	a1 20 40 80 00       	mov    0x804020,%eax
  801b4a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b50:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  801b57:	a1 20 40 80 00       	mov    0x804020,%eax
  801b5c:	40                   	inc    %eax
  801b5d:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  801b62:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b69:	eb 2e                	jmp    801b99 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801b6b:	a1 04 40 80 00       	mov    0x804004,%eax
  801b70:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801b75:	c1 e8 0c             	shr    $0xc,%eax
  801b78:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801b7f:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801b83:	a1 04 40 80 00       	mov    0x804004,%eax
  801b88:	05 00 10 00 00       	add    $0x1000,%eax
  801b8d:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b92:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801b99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b9f:	72 ca                	jb     801b6b <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801ba1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801ba7:	e9 4a 07 00 00       	jmp    8022f6 <malloc+0x9a0>

			} else {

				if (check_start) {
  801bac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bb0:	74 0a                	je     801bbc <malloc+0x266>

					return NULL;
  801bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb7:	e9 3a 07 00 00       	jmp    8022f6 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801bbc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801bc3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801bca:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801bd1:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801bd8:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801bdb:	eb 4d                	jmp    801c2a <malloc+0x2d4>
					if (sz == size) {
  801bdd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801be0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801be3:	75 09                	jne    801bee <malloc+0x298>
						f = 1;
  801be5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801bec:	eb 44                	jmp    801c32 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801bee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bf1:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801bf6:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801bf9:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801c00:	85 c0                	test   %eax,%eax
  801c02:	75 10                	jne    801c14 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801c04:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801c0b:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801c12:	eb 16                	jmp    801c2a <malloc+0x2d4>
					} else {
						sz = 0;
  801c14:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801c1b:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801c22:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c25:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801c30:	72 ab                	jb     801bdd <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801c32:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801c36:	0f 84 95 00 00 00    	je     801cd1 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801c3c:	a1 04 40 80 00       	mov    0x804004,%eax
  801c41:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801c47:	a1 04 40 80 00       	mov    0x804004,%eax
  801c4c:	83 ec 08             	sub    $0x8,%esp
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	50                   	push   %eax
  801c53:	e8 35 09 00 00       	call   80258d <sys_allocateMem>
  801c58:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801c5b:	a1 20 40 80 00       	mov    0x804020,%eax
  801c60:	8b 55 08             	mov    0x8(%ebp),%edx
  801c63:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801c6a:	a1 20 40 80 00       	mov    0x804020,%eax
  801c6f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c75:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  801c7c:	a1 20 40 80 00       	mov    0x804020,%eax
  801c81:	40                   	inc    %eax
  801c82:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  801c87:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801c8e:	eb 2e                	jmp    801cbe <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801c90:	a1 04 40 80 00       	mov    0x804004,%eax
  801c95:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801c9a:	c1 e8 0c             	shr    $0xc,%eax
  801c9d:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801ca4:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801ca8:	a1 04 40 80 00       	mov    0x804004,%eax
  801cad:	05 00 10 00 00       	add    $0x1000,%eax
  801cb2:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801cb7:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801cbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cc1:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cc4:	72 ca                	jb     801c90 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801cc6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801ccc:	e9 25 06 00 00       	jmp    8022f6 <malloc+0x9a0>

				} else {

					return NULL;
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd6:	e9 1b 06 00 00       	jmp    8022f6 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801cdb:	e8 d0 0b 00 00       	call   8028b0 <sys_isUHeapPlacementStrategyBESTFIT>
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	0f 84 ba 01 00 00    	je     801ea2 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801ce8:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801cef:	10 00 00 
  801cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf5:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801cfb:	01 d0                	add    %edx,%eax
  801cfd:	48                   	dec    %eax
  801cfe:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801d04:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0f:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801d15:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801d1b:	29 d0                	sub    %edx,%eax
  801d1d:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801d20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d24:	74 09                	je     801d2f <malloc+0x3d9>
  801d26:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d2d:	76 0a                	jbe    801d39 <malloc+0x3e3>
			return NULL;
  801d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d34:	e9 bd 05 00 00       	jmp    8022f6 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801d39:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801d40:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801d47:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801d4e:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801d55:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	c1 e8 0c             	shr    $0xc,%eax
  801d62:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801d68:	e9 80 00 00 00       	jmp    801ded <malloc+0x497>

			if (heap_mem[i] == 0) {
  801d6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d70:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801d77:	85 c0                	test   %eax,%eax
  801d79:	75 0c                	jne    801d87 <malloc+0x431>

				count++;
  801d7b:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801d7e:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801d85:	eb 2d                	jmp    801db4 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801d87:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801d8d:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d90:	77 14                	ja     801da6 <malloc+0x450>
  801d92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d95:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d98:	76 0c                	jbe    801da6 <malloc+0x450>

					min_sz = count;
  801d9a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d9d:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801da0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801da3:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801da6:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801dad:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801db4:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801dbb:	75 2d                	jne    801dea <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801dbd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801dc3:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801dc6:	77 22                	ja     801dea <malloc+0x494>
  801dc8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801dcb:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801dce:	76 1a                	jbe    801dea <malloc+0x494>

					min_sz = count;
  801dd0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801dd3:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801dd6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dd9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801ddc:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801de3:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801dea:	ff 45 b8             	incl   -0x48(%ebp)
  801ded:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801df0:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801df5:	0f 86 72 ff ff ff    	jbe    801d6d <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801dfb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801e01:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801e04:	77 06                	ja     801e0c <malloc+0x4b6>
  801e06:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801e0a:	75 0a                	jne    801e16 <malloc+0x4c0>
			return NULL;
  801e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e11:	e9 e0 04 00 00       	jmp    8022f6 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801e16:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e19:	c1 e0 0c             	shl    $0xc,%eax
  801e1c:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801e1f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e22:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801e28:	83 ec 08             	sub    $0x8,%esp
  801e2b:	ff 75 08             	pushl  0x8(%ebp)
  801e2e:	ff 75 c4             	pushl  -0x3c(%ebp)
  801e31:	e8 57 07 00 00       	call   80258d <sys_allocateMem>
  801e36:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e39:	a1 20 40 80 00       	mov    0x804020,%eax
  801e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e41:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801e48:	a1 20 40 80 00       	mov    0x804020,%eax
  801e4d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801e50:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  801e57:	a1 20 40 80 00       	mov    0x804020,%eax
  801e5c:	40                   	inc    %eax
  801e5d:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  801e62:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e69:	eb 24                	jmp    801e8f <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801e6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e6e:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e73:	c1 e8 0c             	shr    $0xc,%eax
  801e76:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801e7d:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801e81:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e88:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801e8f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e92:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e95:	72 d4                	jb     801e6b <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e97:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801e9d:	e9 54 04 00 00       	jmp    8022f6 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801ea2:	e8 d8 09 00 00       	call   80287f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	0f 84 88 01 00 00    	je     802037 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801eaf:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801eb6:	10 00 00 
  801eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801ec2:	01 d0                	add    %edx,%eax
  801ec4:	48                   	dec    %eax
  801ec5:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801ecb:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801ed1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed6:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801edc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801ee2:	29 d0                	sub    %edx,%eax
  801ee4:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801ee7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eeb:	74 09                	je     801ef6 <malloc+0x5a0>
  801eed:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ef4:	76 0a                	jbe    801f00 <malloc+0x5aa>
			return NULL;
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  801efb:	e9 f6 03 00 00       	jmp    8022f6 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801f00:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801f07:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801f0e:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801f15:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801f1c:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	c1 e8 0c             	shr    $0xc,%eax
  801f29:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801f2f:	eb 5a                	jmp    801f8b <malloc+0x635>

			if (heap_mem[i] == 0) {
  801f31:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801f34:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	75 0c                	jne    801f4b <malloc+0x5f5>

				count++;
  801f3f:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801f42:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801f49:	eb 22                	jmp    801f6d <malloc+0x617>
			} else {
				if (num_p <= count) {
  801f4b:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801f51:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801f54:	77 09                	ja     801f5f <malloc+0x609>

					found = 1;
  801f56:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801f5d:	eb 36                	jmp    801f95 <malloc+0x63f>
				}
				count = 0;
  801f5f:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801f66:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801f6d:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801f74:	75 12                	jne    801f88 <malloc+0x632>

				if (num_p <= count) {
  801f76:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801f7c:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801f7f:	77 07                	ja     801f88 <malloc+0x632>

					found = 1;
  801f81:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801f88:	ff 45 a4             	incl   -0x5c(%ebp)
  801f8b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801f8e:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f93:	76 9c                	jbe    801f31 <malloc+0x5db>

			}

		}

		if (!found) {
  801f95:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801f99:	75 0a                	jne    801fa5 <malloc+0x64f>
			return NULL;
  801f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa0:	e9 51 03 00 00       	jmp    8022f6 <malloc+0x9a0>

		}

		temp = ptr;
  801fa5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801fa8:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801fab:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801fae:	c1 e0 0c             	shl    $0xc,%eax
  801fb1:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801fb4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801fb7:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801fbd:	83 ec 08             	sub    $0x8,%esp
  801fc0:	ff 75 08             	pushl  0x8(%ebp)
  801fc3:	ff 75 b0             	pushl  -0x50(%ebp)
  801fc6:	e8 c2 05 00 00       	call   80258d <sys_allocateMem>
  801fcb:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801fce:	a1 20 40 80 00       	mov    0x804020,%eax
  801fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd6:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801fdd:	a1 20 40 80 00       	mov    0x804020,%eax
  801fe2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801fe5:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  801fec:	a1 20 40 80 00       	mov    0x804020,%eax
  801ff1:	40                   	inc    %eax
  801ff2:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  801ff7:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801ffe:	eb 24                	jmp    802024 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802000:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802003:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802008:	c1 e8 0c             	shr    $0xc,%eax
  80200b:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802012:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802016:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  80201d:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  802024:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802027:	3b 45 08             	cmp    0x8(%ebp),%eax
  80202a:	72 d4                	jb     802000 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  80202c:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  802032:	e9 bf 02 00 00       	jmp    8022f6 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  802037:	e8 d6 08 00 00       	call   802912 <sys_isUHeapPlacementStrategyWORSTFIT>
  80203c:	85 c0                	test   %eax,%eax
  80203e:	0f 84 ba 01 00 00    	je     8021fe <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  802044:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  80204b:	10 00 00 
  80204e:	8b 55 08             	mov    0x8(%ebp),%edx
  802051:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802057:	01 d0                	add    %edx,%eax
  802059:	48                   	dec    %eax
  80205a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802060:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802066:	ba 00 00 00 00       	mov    $0x0,%edx
  80206b:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802071:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802077:	29 d0                	sub    %edx,%eax
  802079:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80207c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802080:	74 09                	je     80208b <malloc+0x735>
  802082:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802089:	76 0a                	jbe    802095 <malloc+0x73f>
					return NULL;
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
  802090:	e9 61 02 00 00       	jmp    8022f6 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  802095:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  80209c:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  8020a3:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  8020aa:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  8020b1:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	c1 e8 0c             	shr    $0xc,%eax
  8020be:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8020c4:	e9 80 00 00 00       	jmp    802149 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  8020c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8020cc:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	75 0c                	jne    8020e3 <malloc+0x78d>

						count++;
  8020d7:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  8020da:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  8020e1:	eb 2d                	jmp    802110 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  8020e3:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8020e9:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020ec:	77 14                	ja     802102 <malloc+0x7ac>
  8020ee:	8b 45 98             	mov    -0x68(%ebp),%eax
  8020f1:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020f4:	73 0c                	jae    802102 <malloc+0x7ac>

							max_sz = count;
  8020f6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8020f9:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8020fc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8020ff:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  802102:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  802109:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  802110:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  802117:	75 2d                	jne    802146 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  802119:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80211f:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802122:	77 22                	ja     802146 <malloc+0x7f0>
  802124:	8b 45 98             	mov    -0x68(%ebp),%eax
  802127:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80212a:	76 1a                	jbe    802146 <malloc+0x7f0>

							max_sz = count;
  80212c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80212f:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802132:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802135:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  802138:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  80213f:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802146:	ff 45 90             	incl   -0x70(%ebp)
  802149:	8b 45 90             	mov    -0x70(%ebp),%eax
  80214c:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802151:	0f 86 72 ff ff ff    	jbe    8020c9 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  802157:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80215d:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802160:	77 06                	ja     802168 <malloc+0x812>
  802162:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802166:	75 0a                	jne    802172 <malloc+0x81c>
					return NULL;
  802168:	b8 00 00 00 00       	mov    $0x0,%eax
  80216d:	e9 84 01 00 00       	jmp    8022f6 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802172:	8b 45 98             	mov    -0x68(%ebp),%eax
  802175:	c1 e0 0c             	shl    $0xc,%eax
  802178:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  80217b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80217e:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  802184:	83 ec 08             	sub    $0x8,%esp
  802187:	ff 75 08             	pushl  0x8(%ebp)
  80218a:	ff 75 9c             	pushl  -0x64(%ebp)
  80218d:	e8 fb 03 00 00       	call   80258d <sys_allocateMem>
  802192:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802195:	a1 20 40 80 00       	mov    0x804020,%eax
  80219a:	8b 55 08             	mov    0x8(%ebp),%edx
  80219d:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  8021a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8021a9:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8021ac:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  8021b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8021b8:	40                   	inc    %eax
  8021b9:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  8021be:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8021c5:	eb 24                	jmp    8021eb <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8021c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8021ca:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8021cf:	c1 e8 0c             	shr    $0xc,%eax
  8021d2:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8021d9:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  8021dd:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8021e4:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  8021eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8021ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f1:	72 d4                	jb     8021c7 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  8021f3:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8021f9:	e9 f8 00 00 00       	jmp    8022f6 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  8021fe:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  802205:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  80220c:	10 00 00 
  80220f:	8b 55 08             	mov    0x8(%ebp),%edx
  802212:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  802218:	01 d0                	add    %edx,%eax
  80221a:	48                   	dec    %eax
  80221b:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802221:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802227:	ba 00 00 00 00       	mov    $0x0,%edx
  80222c:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802232:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802238:	29 d0                	sub    %edx,%eax
  80223a:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80223d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802241:	74 09                	je     80224c <malloc+0x8f6>
  802243:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80224a:	76 0a                	jbe    802256 <malloc+0x900>
		return NULL;
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
  802251:	e9 a0 00 00 00       	jmp    8022f6 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802256:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	01 d0                	add    %edx,%eax
  802261:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802266:	0f 87 87 00 00 00    	ja     8022f3 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80226c:	a1 04 40 80 00       	mov    0x804004,%eax
  802271:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802274:	a1 04 40 80 00       	mov    0x804004,%eax
  802279:	83 ec 08             	sub    $0x8,%esp
  80227c:	ff 75 08             	pushl  0x8(%ebp)
  80227f:	50                   	push   %eax
  802280:	e8 08 03 00 00       	call   80258d <sys_allocateMem>
  802285:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802288:	a1 20 40 80 00       	mov    0x804020,%eax
  80228d:	8b 55 08             	mov    0x8(%ebp),%edx
  802290:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802297:	a1 20 40 80 00       	mov    0x804020,%eax
  80229c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8022a2:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8022a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8022ae:	40                   	inc    %eax
  8022af:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  8022b4:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8022bb:	eb 2e                	jmp    8022eb <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8022bd:	a1 04 40 80 00       	mov    0x804004,%eax
  8022c2:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8022c7:	c1 e8 0c             	shr    $0xc,%eax
  8022ca:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8022d1:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8022d5:	a1 04 40 80 00       	mov    0x804004,%eax
  8022da:	05 00 10 00 00       	add    $0x1000,%eax
  8022df:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8022e4:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  8022eb:	8b 45 88             	mov    -0x78(%ebp),%eax
  8022ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f1:	72 ca                	jb     8022bd <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  8022f3:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  8022fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  802305:	e9 c1 00 00 00       	jmp    8023cb <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  802314:	3b 45 08             	cmp    0x8(%ebp),%eax
  802317:	0f 85 ab 00 00 00    	jne    8023c8 <free+0xd0>

			if (heap_size[inx].size == 0) {
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  802327:	85 c0                	test   %eax,%eax
  802329:	75 21                	jne    80234c <free+0x54>
				heap_size[inx].size = 0;
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802335:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802343:	00 00 00 00 
				return;
  802347:	e9 8d 00 00 00       	jmp    8023d9 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	83 ec 08             	sub    $0x8,%esp
  80235c:	52                   	push   %edx
  80235d:	50                   	push   %eax
  80235e:	e8 0e 02 00 00       	call   802571 <sys_freeMem>
  802363:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802373:	eb 24                	jmp    802399 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802378:	05 00 00 00 80       	add    $0x80000000,%eax
  80237d:	c1 e8 0c             	shr    $0xc,%eax
  802380:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  802387:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  80238b:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802392:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  8023a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a6:	39 c2                	cmp    %eax,%edx
  8023a8:	77 cb                	ja     802375 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  8023b4:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  8023c2:	00 00 00 00 
			break;
  8023c6:	eb 11                	jmp    8023d9 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8023c8:	ff 45 f4             	incl   -0xc(%ebp)
  8023cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8023d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8023d3:	0f 8c 31 ff ff ff    	jl     80230a <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8023e1:	83 ec 04             	sub    $0x4,%esp
  8023e4:	68 70 31 80 00       	push   $0x803170
  8023e9:	68 1c 02 00 00       	push   $0x21c
  8023ee:	68 96 31 80 00       	push   $0x803196
  8023f3:	e8 b0 e6 ff ff       	call   800aa8 <_panic>

008023f8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	57                   	push   %edi
  8023fc:	56                   	push   %esi
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	8b 55 0c             	mov    0xc(%ebp),%edx
  802407:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80240a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80240d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802410:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802413:	cd 30                	int    $0x30
  802415:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802418:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	5b                   	pop    %ebx
  80241f:	5e                   	pop    %esi
  802420:	5f                   	pop    %edi
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    

00802423 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	ff 75 0c             	pushl  0xc(%ebp)
  802432:	50                   	push   %eax
  802433:	6a 00                	push   $0x0
  802435:	e8 be ff ff ff       	call   8023f8 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
}
  80243d:	90                   	nop
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_cgetc>:

int
sys_cgetc(void)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 01                	push   $0x1
  80244f:	e8 a4 ff ff ff       	call   8023f8 <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	50                   	push   %eax
  802468:	6a 03                	push   $0x3
  80246a:	e8 89 ff ff ff       	call   8023f8 <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 02                	push   $0x2
  802483:	e8 70 ff ff ff       	call   8023f8 <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_env_exit>:

void sys_env_exit(void)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 04                	push   $0x4
  80249c:	e8 57 ff ff ff       	call   8023f8 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	90                   	nop
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	52                   	push   %edx
  8024b7:	50                   	push   %eax
  8024b8:	6a 05                	push   $0x5
  8024ba:	e8 39 ff ff ff       	call   8023f8 <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	56                   	push   %esi
  8024c8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024c9:	8b 75 18             	mov    0x18(%ebp),%esi
  8024cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	56                   	push   %esi
  8024d9:	53                   	push   %ebx
  8024da:	51                   	push   %ecx
  8024db:	52                   	push   %edx
  8024dc:	50                   	push   %eax
  8024dd:	6a 06                	push   $0x6
  8024df:	e8 14 ff ff ff       	call   8023f8 <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
}
  8024e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024ea:	5b                   	pop    %ebx
  8024eb:	5e                   	pop    %esi
  8024ec:	5d                   	pop    %ebp
  8024ed:	c3                   	ret    

008024ee <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	52                   	push   %edx
  8024fe:	50                   	push   %eax
  8024ff:	6a 07                	push   $0x7
  802501:	e8 f2 fe ff ff       	call   8023f8 <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	ff 75 0c             	pushl  0xc(%ebp)
  802517:	ff 75 08             	pushl  0x8(%ebp)
  80251a:	6a 08                	push   $0x8
  80251c:	e8 d7 fe ff ff       	call   8023f8 <syscall>
  802521:	83 c4 18             	add    $0x18,%esp
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 09                	push   $0x9
  802535:	e8 be fe ff ff       	call   8023f8 <syscall>
  80253a:	83 c4 18             	add    $0x18,%esp
}
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 0a                	push   $0xa
  80254e:	e8 a5 fe ff ff       	call   8023f8 <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 0b                	push   $0xb
  802567:	e8 8c fe ff ff       	call   8023f8 <syscall>
  80256c:	83 c4 18             	add    $0x18,%esp
}
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	ff 75 0c             	pushl  0xc(%ebp)
  80257d:	ff 75 08             	pushl  0x8(%ebp)
  802580:	6a 0d                	push   $0xd
  802582:	e8 71 fe ff ff       	call   8023f8 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
	return;
  80258a:	90                   	nop
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	ff 75 0c             	pushl  0xc(%ebp)
  802599:	ff 75 08             	pushl  0x8(%ebp)
  80259c:	6a 0e                	push   $0xe
  80259e:	e8 55 fe ff ff       	call   8023f8 <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a6:	90                   	nop
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 0c                	push   $0xc
  8025b8:	e8 3b fe ff ff       	call   8023f8 <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 10                	push   $0x10
  8025d1:	e8 22 fe ff ff       	call   8023f8 <syscall>
  8025d6:	83 c4 18             	add    $0x18,%esp
}
  8025d9:	90                   	nop
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 11                	push   $0x11
  8025eb:	e8 08 fe ff ff       	call   8023f8 <syscall>
  8025f0:	83 c4 18             	add    $0x18,%esp
}
  8025f3:	90                   	nop
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802602:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	50                   	push   %eax
  80260f:	6a 12                	push   $0x12
  802611:	e8 e2 fd ff ff       	call   8023f8 <syscall>
  802616:	83 c4 18             	add    $0x18,%esp
}
  802619:	90                   	nop
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 13                	push   $0x13
  80262b:	e8 c8 fd ff ff       	call   8023f8 <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
}
  802633:	90                   	nop
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	ff 75 0c             	pushl  0xc(%ebp)
  802645:	50                   	push   %eax
  802646:	6a 14                	push   $0x14
  802648:	e8 ab fd ff ff       	call   8023f8 <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    

00802652 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	50                   	push   %eax
  802661:	6a 17                	push   $0x17
  802663:	e8 90 fd ff ff       	call   8023f8 <syscall>
  802668:	83 c4 18             	add    $0x18,%esp
}
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	50                   	push   %eax
  80267c:	6a 15                	push   $0x15
  80267e:	e8 75 fd ff ff       	call   8023f8 <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
}
  802686:	90                   	nop
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	50                   	push   %eax
  802698:	6a 16                	push   $0x16
  80269a:	e8 59 fd ff ff       	call   8023f8 <syscall>
  80269f:	83 c4 18             	add    $0x18,%esp
}
  8026a2:	90                   	nop
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
  8026a8:	83 ec 04             	sub    $0x4,%esp
  8026ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8026b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026b4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	6a 00                	push   $0x0
  8026bd:	51                   	push   %ecx
  8026be:	52                   	push   %edx
  8026bf:	ff 75 0c             	pushl  0xc(%ebp)
  8026c2:	50                   	push   %eax
  8026c3:	6a 18                	push   $0x18
  8026c5:	e8 2e fd ff ff       	call   8023f8 <syscall>
  8026ca:	83 c4 18             	add    $0x18,%esp
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8026d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	52                   	push   %edx
  8026df:	50                   	push   %eax
  8026e0:	6a 19                	push   $0x19
  8026e2:	e8 11 fd ff ff       	call   8023f8 <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
}
  8026ea:	c9                   	leave  
  8026eb:	c3                   	ret    

008026ec <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	50                   	push   %eax
  8026fb:	6a 1a                	push   $0x1a
  8026fd:	e8 f6 fc ff ff       	call   8023f8 <syscall>
  802702:	83 c4 18             	add    $0x18,%esp
}
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 1b                	push   $0x1b
  802716:	e8 dd fc ff ff       	call   8023f8 <syscall>
  80271b:	83 c4 18             	add    $0x18,%esp
}
  80271e:	c9                   	leave  
  80271f:	c3                   	ret    

00802720 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 1c                	push   $0x1c
  80272f:	e8 c4 fc ff ff       	call   8023f8 <syscall>
  802734:	83 c4 18             	add    $0x18,%esp
}
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	ff 75 0c             	pushl  0xc(%ebp)
  802748:	50                   	push   %eax
  802749:	6a 1d                	push   $0x1d
  80274b:	e8 a8 fc ff ff       	call   8023f8 <syscall>
  802750:	83 c4 18             	add    $0x18,%esp
}
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	50                   	push   %eax
  802764:	6a 1e                	push   $0x1e
  802766:	e8 8d fc ff ff       	call   8023f8 <syscall>
  80276b:	83 c4 18             	add    $0x18,%esp
}
  80276e:	90                   	nop
  80276f:	c9                   	leave  
  802770:	c3                   	ret    

00802771 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	50                   	push   %eax
  802780:	6a 1f                	push   $0x1f
  802782:	e8 71 fc ff ff       	call   8023f8 <syscall>
  802787:	83 c4 18             	add    $0x18,%esp
}
  80278a:	90                   	nop
  80278b:	c9                   	leave  
  80278c:	c3                   	ret    

0080278d <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80278d:	55                   	push   %ebp
  80278e:	89 e5                	mov    %esp,%ebp
  802790:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802793:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802796:	8d 50 04             	lea    0x4(%eax),%edx
  802799:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	52                   	push   %edx
  8027a3:	50                   	push   %eax
  8027a4:	6a 20                	push   $0x20
  8027a6:	e8 4d fc ff ff       	call   8023f8 <syscall>
  8027ab:	83 c4 18             	add    $0x18,%esp
	return result;
  8027ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027b7:	89 01                	mov    %eax,(%ecx)
  8027b9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	c9                   	leave  
  8027c0:	c2 04 00             	ret    $0x4

008027c3 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	ff 75 10             	pushl  0x10(%ebp)
  8027cd:	ff 75 0c             	pushl  0xc(%ebp)
  8027d0:	ff 75 08             	pushl  0x8(%ebp)
  8027d3:	6a 0f                	push   $0xf
  8027d5:	e8 1e fc ff ff       	call   8023f8 <syscall>
  8027da:	83 c4 18             	add    $0x18,%esp
	return ;
  8027dd:	90                   	nop
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 21                	push   $0x21
  8027ef:	e8 04 fc ff ff       	call   8023f8 <syscall>
  8027f4:	83 c4 18             	add    $0x18,%esp
}
  8027f7:	c9                   	leave  
  8027f8:	c3                   	ret    

008027f9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
  8027fc:	83 ec 04             	sub    $0x4,%esp
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802805:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	50                   	push   %eax
  802812:	6a 22                	push   $0x22
  802814:	e8 df fb ff ff       	call   8023f8 <syscall>
  802819:	83 c4 18             	add    $0x18,%esp
	return ;
  80281c:	90                   	nop
}
  80281d:	c9                   	leave  
  80281e:	c3                   	ret    

0080281f <rsttst>:
void rsttst()
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 24                	push   $0x24
  80282e:	e8 c5 fb ff ff       	call   8023f8 <syscall>
  802833:	83 c4 18             	add    $0x18,%esp
	return ;
  802836:	90                   	nop
}
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	83 ec 04             	sub    $0x4,%esp
  80283f:	8b 45 14             	mov    0x14(%ebp),%eax
  802842:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802845:	8b 55 18             	mov    0x18(%ebp),%edx
  802848:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80284c:	52                   	push   %edx
  80284d:	50                   	push   %eax
  80284e:	ff 75 10             	pushl  0x10(%ebp)
  802851:	ff 75 0c             	pushl  0xc(%ebp)
  802854:	ff 75 08             	pushl  0x8(%ebp)
  802857:	6a 23                	push   $0x23
  802859:	e8 9a fb ff ff       	call   8023f8 <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
	return ;
  802861:	90                   	nop
}
  802862:	c9                   	leave  
  802863:	c3                   	ret    

00802864 <chktst>:
void chktst(uint32 n)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	ff 75 08             	pushl  0x8(%ebp)
  802872:	6a 25                	push   $0x25
  802874:	e8 7f fb ff ff       	call   8023f8 <syscall>
  802879:	83 c4 18             	add    $0x18,%esp
	return ;
  80287c:	90                   	nop
}
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 26                	push   $0x26
  802891:	e8 62 fb ff ff       	call   8023f8 <syscall>
  802896:	83 c4 18             	add    $0x18,%esp
  802899:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80289c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028a0:	75 07                	jne    8028a9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a7:	eb 05                	jmp    8028ae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 26                	push   $0x26
  8028c2:	e8 31 fb ff ff       	call   8023f8 <syscall>
  8028c7:	83 c4 18             	add    $0x18,%esp
  8028ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028cd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028d1:	75 07                	jne    8028da <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d8:	eb 05                	jmp    8028df <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 26                	push   $0x26
  8028f3:	e8 00 fb ff ff       	call   8023f8 <syscall>
  8028f8:	83 c4 18             	add    $0x18,%esp
  8028fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028fe:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802902:	75 07                	jne    80290b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802904:	b8 01 00 00 00       	mov    $0x1,%eax
  802909:	eb 05                	jmp    802910 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80290b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802910:	c9                   	leave  
  802911:	c3                   	ret    

00802912 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802912:	55                   	push   %ebp
  802913:	89 e5                	mov    %esp,%ebp
  802915:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	6a 26                	push   $0x26
  802924:	e8 cf fa ff ff       	call   8023f8 <syscall>
  802929:	83 c4 18             	add    $0x18,%esp
  80292c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80292f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802933:	75 07                	jne    80293c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802935:	b8 01 00 00 00       	mov    $0x1,%eax
  80293a:	eb 05                	jmp    802941 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80293c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802941:	c9                   	leave  
  802942:	c3                   	ret    

00802943 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802943:	55                   	push   %ebp
  802944:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802946:	6a 00                	push   $0x0
  802948:	6a 00                	push   $0x0
  80294a:	6a 00                	push   $0x0
  80294c:	6a 00                	push   $0x0
  80294e:	ff 75 08             	pushl  0x8(%ebp)
  802951:	6a 27                	push   $0x27
  802953:	e8 a0 fa ff ff       	call   8023f8 <syscall>
  802958:	83 c4 18             	add    $0x18,%esp
	return ;
  80295b:	90                   	nop
}
  80295c:	c9                   	leave  
  80295d:	c3                   	ret    
  80295e:	66 90                	xchg   %ax,%ax

00802960 <__udivdi3>:
  802960:	55                   	push   %ebp
  802961:	57                   	push   %edi
  802962:	56                   	push   %esi
  802963:	53                   	push   %ebx
  802964:	83 ec 1c             	sub    $0x1c,%esp
  802967:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80296b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80296f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802973:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802977:	89 ca                	mov    %ecx,%edx
  802979:	89 f8                	mov    %edi,%eax
  80297b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80297f:	85 f6                	test   %esi,%esi
  802981:	75 2d                	jne    8029b0 <__udivdi3+0x50>
  802983:	39 cf                	cmp    %ecx,%edi
  802985:	77 65                	ja     8029ec <__udivdi3+0x8c>
  802987:	89 fd                	mov    %edi,%ebp
  802989:	85 ff                	test   %edi,%edi
  80298b:	75 0b                	jne    802998 <__udivdi3+0x38>
  80298d:	b8 01 00 00 00       	mov    $0x1,%eax
  802992:	31 d2                	xor    %edx,%edx
  802994:	f7 f7                	div    %edi
  802996:	89 c5                	mov    %eax,%ebp
  802998:	31 d2                	xor    %edx,%edx
  80299a:	89 c8                	mov    %ecx,%eax
  80299c:	f7 f5                	div    %ebp
  80299e:	89 c1                	mov    %eax,%ecx
  8029a0:	89 d8                	mov    %ebx,%eax
  8029a2:	f7 f5                	div    %ebp
  8029a4:	89 cf                	mov    %ecx,%edi
  8029a6:	89 fa                	mov    %edi,%edx
  8029a8:	83 c4 1c             	add    $0x1c,%esp
  8029ab:	5b                   	pop    %ebx
  8029ac:	5e                   	pop    %esi
  8029ad:	5f                   	pop    %edi
  8029ae:	5d                   	pop    %ebp
  8029af:	c3                   	ret    
  8029b0:	39 ce                	cmp    %ecx,%esi
  8029b2:	77 28                	ja     8029dc <__udivdi3+0x7c>
  8029b4:	0f bd fe             	bsr    %esi,%edi
  8029b7:	83 f7 1f             	xor    $0x1f,%edi
  8029ba:	75 40                	jne    8029fc <__udivdi3+0x9c>
  8029bc:	39 ce                	cmp    %ecx,%esi
  8029be:	72 0a                	jb     8029ca <__udivdi3+0x6a>
  8029c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8029c4:	0f 87 9e 00 00 00    	ja     802a68 <__udivdi3+0x108>
  8029ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8029cf:	89 fa                	mov    %edi,%edx
  8029d1:	83 c4 1c             	add    $0x1c,%esp
  8029d4:	5b                   	pop    %ebx
  8029d5:	5e                   	pop    %esi
  8029d6:	5f                   	pop    %edi
  8029d7:	5d                   	pop    %ebp
  8029d8:	c3                   	ret    
  8029d9:	8d 76 00             	lea    0x0(%esi),%esi
  8029dc:	31 ff                	xor    %edi,%edi
  8029de:	31 c0                	xor    %eax,%eax
  8029e0:	89 fa                	mov    %edi,%edx
  8029e2:	83 c4 1c             	add    $0x1c,%esp
  8029e5:	5b                   	pop    %ebx
  8029e6:	5e                   	pop    %esi
  8029e7:	5f                   	pop    %edi
  8029e8:	5d                   	pop    %ebp
  8029e9:	c3                   	ret    
  8029ea:	66 90                	xchg   %ax,%ax
  8029ec:	89 d8                	mov    %ebx,%eax
  8029ee:	f7 f7                	div    %edi
  8029f0:	31 ff                	xor    %edi,%edi
  8029f2:	89 fa                	mov    %edi,%edx
  8029f4:	83 c4 1c             	add    $0x1c,%esp
  8029f7:	5b                   	pop    %ebx
  8029f8:	5e                   	pop    %esi
  8029f9:	5f                   	pop    %edi
  8029fa:	5d                   	pop    %ebp
  8029fb:	c3                   	ret    
  8029fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a01:	89 eb                	mov    %ebp,%ebx
  802a03:	29 fb                	sub    %edi,%ebx
  802a05:	89 f9                	mov    %edi,%ecx
  802a07:	d3 e6                	shl    %cl,%esi
  802a09:	89 c5                	mov    %eax,%ebp
  802a0b:	88 d9                	mov    %bl,%cl
  802a0d:	d3 ed                	shr    %cl,%ebp
  802a0f:	89 e9                	mov    %ebp,%ecx
  802a11:	09 f1                	or     %esi,%ecx
  802a13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a17:	89 f9                	mov    %edi,%ecx
  802a19:	d3 e0                	shl    %cl,%eax
  802a1b:	89 c5                	mov    %eax,%ebp
  802a1d:	89 d6                	mov    %edx,%esi
  802a1f:	88 d9                	mov    %bl,%cl
  802a21:	d3 ee                	shr    %cl,%esi
  802a23:	89 f9                	mov    %edi,%ecx
  802a25:	d3 e2                	shl    %cl,%edx
  802a27:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a2b:	88 d9                	mov    %bl,%cl
  802a2d:	d3 e8                	shr    %cl,%eax
  802a2f:	09 c2                	or     %eax,%edx
  802a31:	89 d0                	mov    %edx,%eax
  802a33:	89 f2                	mov    %esi,%edx
  802a35:	f7 74 24 0c          	divl   0xc(%esp)
  802a39:	89 d6                	mov    %edx,%esi
  802a3b:	89 c3                	mov    %eax,%ebx
  802a3d:	f7 e5                	mul    %ebp
  802a3f:	39 d6                	cmp    %edx,%esi
  802a41:	72 19                	jb     802a5c <__udivdi3+0xfc>
  802a43:	74 0b                	je     802a50 <__udivdi3+0xf0>
  802a45:	89 d8                	mov    %ebx,%eax
  802a47:	31 ff                	xor    %edi,%edi
  802a49:	e9 58 ff ff ff       	jmp    8029a6 <__udivdi3+0x46>
  802a4e:	66 90                	xchg   %ax,%ax
  802a50:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a54:	89 f9                	mov    %edi,%ecx
  802a56:	d3 e2                	shl    %cl,%edx
  802a58:	39 c2                	cmp    %eax,%edx
  802a5a:	73 e9                	jae    802a45 <__udivdi3+0xe5>
  802a5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a5f:	31 ff                	xor    %edi,%edi
  802a61:	e9 40 ff ff ff       	jmp    8029a6 <__udivdi3+0x46>
  802a66:	66 90                	xchg   %ax,%ax
  802a68:	31 c0                	xor    %eax,%eax
  802a6a:	e9 37 ff ff ff       	jmp    8029a6 <__udivdi3+0x46>
  802a6f:	90                   	nop

00802a70 <__umoddi3>:
  802a70:	55                   	push   %ebp
  802a71:	57                   	push   %edi
  802a72:	56                   	push   %esi
  802a73:	53                   	push   %ebx
  802a74:	83 ec 1c             	sub    $0x1c,%esp
  802a77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a8f:	89 f3                	mov    %esi,%ebx
  802a91:	89 fa                	mov    %edi,%edx
  802a93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a97:	89 34 24             	mov    %esi,(%esp)
  802a9a:	85 c0                	test   %eax,%eax
  802a9c:	75 1a                	jne    802ab8 <__umoddi3+0x48>
  802a9e:	39 f7                	cmp    %esi,%edi
  802aa0:	0f 86 a2 00 00 00    	jbe    802b48 <__umoddi3+0xd8>
  802aa6:	89 c8                	mov    %ecx,%eax
  802aa8:	89 f2                	mov    %esi,%edx
  802aaa:	f7 f7                	div    %edi
  802aac:	89 d0                	mov    %edx,%eax
  802aae:	31 d2                	xor    %edx,%edx
  802ab0:	83 c4 1c             	add    $0x1c,%esp
  802ab3:	5b                   	pop    %ebx
  802ab4:	5e                   	pop    %esi
  802ab5:	5f                   	pop    %edi
  802ab6:	5d                   	pop    %ebp
  802ab7:	c3                   	ret    
  802ab8:	39 f0                	cmp    %esi,%eax
  802aba:	0f 87 ac 00 00 00    	ja     802b6c <__umoddi3+0xfc>
  802ac0:	0f bd e8             	bsr    %eax,%ebp
  802ac3:	83 f5 1f             	xor    $0x1f,%ebp
  802ac6:	0f 84 ac 00 00 00    	je     802b78 <__umoddi3+0x108>
  802acc:	bf 20 00 00 00       	mov    $0x20,%edi
  802ad1:	29 ef                	sub    %ebp,%edi
  802ad3:	89 fe                	mov    %edi,%esi
  802ad5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ad9:	89 e9                	mov    %ebp,%ecx
  802adb:	d3 e0                	shl    %cl,%eax
  802add:	89 d7                	mov    %edx,%edi
  802adf:	89 f1                	mov    %esi,%ecx
  802ae1:	d3 ef                	shr    %cl,%edi
  802ae3:	09 c7                	or     %eax,%edi
  802ae5:	89 e9                	mov    %ebp,%ecx
  802ae7:	d3 e2                	shl    %cl,%edx
  802ae9:	89 14 24             	mov    %edx,(%esp)
  802aec:	89 d8                	mov    %ebx,%eax
  802aee:	d3 e0                	shl    %cl,%eax
  802af0:	89 c2                	mov    %eax,%edx
  802af2:	8b 44 24 08          	mov    0x8(%esp),%eax
  802af6:	d3 e0                	shl    %cl,%eax
  802af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802afc:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b00:	89 f1                	mov    %esi,%ecx
  802b02:	d3 e8                	shr    %cl,%eax
  802b04:	09 d0                	or     %edx,%eax
  802b06:	d3 eb                	shr    %cl,%ebx
  802b08:	89 da                	mov    %ebx,%edx
  802b0a:	f7 f7                	div    %edi
  802b0c:	89 d3                	mov    %edx,%ebx
  802b0e:	f7 24 24             	mull   (%esp)
  802b11:	89 c6                	mov    %eax,%esi
  802b13:	89 d1                	mov    %edx,%ecx
  802b15:	39 d3                	cmp    %edx,%ebx
  802b17:	0f 82 87 00 00 00    	jb     802ba4 <__umoddi3+0x134>
  802b1d:	0f 84 91 00 00 00    	je     802bb4 <__umoddi3+0x144>
  802b23:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b27:	29 f2                	sub    %esi,%edx
  802b29:	19 cb                	sbb    %ecx,%ebx
  802b2b:	89 d8                	mov    %ebx,%eax
  802b2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b31:	d3 e0                	shl    %cl,%eax
  802b33:	89 e9                	mov    %ebp,%ecx
  802b35:	d3 ea                	shr    %cl,%edx
  802b37:	09 d0                	or     %edx,%eax
  802b39:	89 e9                	mov    %ebp,%ecx
  802b3b:	d3 eb                	shr    %cl,%ebx
  802b3d:	89 da                	mov    %ebx,%edx
  802b3f:	83 c4 1c             	add    $0x1c,%esp
  802b42:	5b                   	pop    %ebx
  802b43:	5e                   	pop    %esi
  802b44:	5f                   	pop    %edi
  802b45:	5d                   	pop    %ebp
  802b46:	c3                   	ret    
  802b47:	90                   	nop
  802b48:	89 fd                	mov    %edi,%ebp
  802b4a:	85 ff                	test   %edi,%edi
  802b4c:	75 0b                	jne    802b59 <__umoddi3+0xe9>
  802b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b53:	31 d2                	xor    %edx,%edx
  802b55:	f7 f7                	div    %edi
  802b57:	89 c5                	mov    %eax,%ebp
  802b59:	89 f0                	mov    %esi,%eax
  802b5b:	31 d2                	xor    %edx,%edx
  802b5d:	f7 f5                	div    %ebp
  802b5f:	89 c8                	mov    %ecx,%eax
  802b61:	f7 f5                	div    %ebp
  802b63:	89 d0                	mov    %edx,%eax
  802b65:	e9 44 ff ff ff       	jmp    802aae <__umoddi3+0x3e>
  802b6a:	66 90                	xchg   %ax,%ax
  802b6c:	89 c8                	mov    %ecx,%eax
  802b6e:	89 f2                	mov    %esi,%edx
  802b70:	83 c4 1c             	add    $0x1c,%esp
  802b73:	5b                   	pop    %ebx
  802b74:	5e                   	pop    %esi
  802b75:	5f                   	pop    %edi
  802b76:	5d                   	pop    %ebp
  802b77:	c3                   	ret    
  802b78:	3b 04 24             	cmp    (%esp),%eax
  802b7b:	72 06                	jb     802b83 <__umoddi3+0x113>
  802b7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b81:	77 0f                	ja     802b92 <__umoddi3+0x122>
  802b83:	89 f2                	mov    %esi,%edx
  802b85:	29 f9                	sub    %edi,%ecx
  802b87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b8b:	89 14 24             	mov    %edx,(%esp)
  802b8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b92:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b96:	8b 14 24             	mov    (%esp),%edx
  802b99:	83 c4 1c             	add    $0x1c,%esp
  802b9c:	5b                   	pop    %ebx
  802b9d:	5e                   	pop    %esi
  802b9e:	5f                   	pop    %edi
  802b9f:	5d                   	pop    %ebp
  802ba0:	c3                   	ret    
  802ba1:	8d 76 00             	lea    0x0(%esi),%esi
  802ba4:	2b 04 24             	sub    (%esp),%eax
  802ba7:	19 fa                	sbb    %edi,%edx
  802ba9:	89 d1                	mov    %edx,%ecx
  802bab:	89 c6                	mov    %eax,%esi
  802bad:	e9 71 ff ff ff       	jmp    802b23 <__umoddi3+0xb3>
  802bb2:	66 90                	xchg   %ax,%ax
  802bb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802bb8:	72 ea                	jb     802ba4 <__umoddi3+0x134>
  802bba:	89 d9                	mov    %ebx,%ecx
  802bbc:	e9 62 ff ff ff       	jmp    802b23 <__umoddi3+0xb3>
