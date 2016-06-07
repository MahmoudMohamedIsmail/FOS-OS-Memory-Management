
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 62 05 00 00       	call   800598 <libmain>
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
  80003d:	83 ec 70             	sub    $0x70,%esp
	int envID = sys_getenvid();
  800040:	e8 e0 1f 00 00       	call   802025 <sys_getenvid>
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

	int Mega = 1024*1024;
  80006a:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  800071:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	void* ptr_allocations[20] = {0};
  800078:	8d 55 90             	lea    -0x70(%ebp),%edx
  80007b:	b9 14 00 00 00       	mov    $0x14,%ecx
  800080:	b8 00 00 00 00       	mov    $0x0,%eax
  800085:	89 d7                	mov    %edx,%edi
  800087:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  800089:	e8 49 20 00 00       	call   8020d7 <sys_calculate_free_frames>
  80008e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800091:	e8 c4 20 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  800096:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800099:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009c:	01 c0                	add    %eax,%eax
  80009e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	e8 5d 14 00 00       	call   801507 <malloc>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000b0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000b3:	85 c0                	test   %eax,%eax
  8000b5:	79 0a                	jns    8000c1 <_main+0x89>
  8000b7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ba:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000bf:	76 14                	jbe    8000d5 <_main+0x9d>
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	68 80 27 80 00       	push   $0x802780
  8000c9:	6a 16                	push   $0x16
  8000cb:	68 b0 27 80 00       	push   $0x8027b0
  8000d0:	e8 84 05 00 00       	call   800659 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000d5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d8:	e8 fa 1f 00 00       	call   8020d7 <sys_calculate_free_frames>
  8000dd:	29 c3                	sub    %eax,%ebx
  8000df:	89 d8                	mov    %ebx,%eax
  8000e1:	83 f8 01             	cmp    $0x1,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 c4 27 80 00       	push   $0x8027c4
  8000ee:	6a 18                	push   $0x18
  8000f0:	68 b0 27 80 00       	push   $0x8027b0
  8000f5:	e8 5f 05 00 00       	call   800659 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8000fa:	e8 5b 20 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  8000ff:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800102:	3d 00 02 00 00       	cmp    $0x200,%eax
  800107:	74 14                	je     80011d <_main+0xe5>
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 30 28 80 00       	push   $0x802830
  800111:	6a 19                	push   $0x19
  800113:	68 b0 27 80 00       	push   $0x8027b0
  800118:	e8 3c 05 00 00       	call   800659 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80011d:	e8 b5 1f 00 00       	call   8020d7 <sys_calculate_free_frames>
  800122:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800125:	e8 30 20 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  80012a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80012d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800130:	01 c0                	add    %eax,%eax
  800132:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	50                   	push   %eax
  800139:	e8 c9 13 00 00       	call   801507 <malloc>
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800144:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800147:	89 c2                	mov    %eax,%edx
  800149:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80014c:	01 c0                	add    %eax,%eax
  80014e:	05 00 00 00 80       	add    $0x80000000,%eax
  800153:	39 c2                	cmp    %eax,%edx
  800155:	72 13                	jb     80016a <_main+0x132>
  800157:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80015a:	89 c2                	mov    %eax,%edx
  80015c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015f:	01 c0                	add    %eax,%eax
  800161:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800166:	39 c2                	cmp    %eax,%edx
  800168:	76 14                	jbe    80017e <_main+0x146>
  80016a:	83 ec 04             	sub    $0x4,%esp
  80016d:	68 80 27 80 00       	push   $0x802780
  800172:	6a 1e                	push   $0x1e
  800174:	68 b0 27 80 00       	push   $0x8027b0
  800179:	e8 db 04 00 00       	call   800659 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80017e:	e8 54 1f 00 00       	call   8020d7 <sys_calculate_free_frames>
  800183:	89 c2                	mov    %eax,%edx
  800185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800188:	39 c2                	cmp    %eax,%edx
  80018a:	74 14                	je     8001a0 <_main+0x168>
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	68 c4 27 80 00       	push   $0x8027c4
  800194:	6a 20                	push   $0x20
  800196:	68 b0 27 80 00       	push   $0x8027b0
  80019b:	e8 b9 04 00 00       	call   800659 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8001a0:	e8 b5 1f 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  8001a5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001a8:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 30 28 80 00       	push   $0x802830
  8001b7:	6a 21                	push   $0x21
  8001b9:	68 b0 27 80 00       	push   $0x8027b0
  8001be:	e8 96 04 00 00       	call   800659 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 0f 1f 00 00       	call   8020d7 <sys_calculate_free_frames>
  8001c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001cb:	e8 8a 1f 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  8001d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d6:	01 c0                	add    %eax,%eax
  8001d8:	83 ec 0c             	sub    $0xc,%esp
  8001db:	50                   	push   %eax
  8001dc:	e8 26 13 00 00       	call   801507 <malloc>
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8001e7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001ea:	89 c2                	mov    %eax,%edx
  8001ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001ef:	c1 e0 02             	shl    $0x2,%eax
  8001f2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001f7:	39 c2                	cmp    %eax,%edx
  8001f9:	72 14                	jb     80020f <_main+0x1d7>
  8001fb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001fe:	89 c2                	mov    %eax,%edx
  800200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800203:	c1 e0 02             	shl    $0x2,%eax
  800206:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80020b:	39 c2                	cmp    %eax,%edx
  80020d:	76 14                	jbe    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 80 27 80 00       	push   $0x802780
  800217:	6a 26                	push   $0x26
  800219:	68 b0 27 80 00       	push   $0x8027b0
  80021e:	e8 36 04 00 00       	call   800659 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800223:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800226:	e8 ac 1e 00 00       	call   8020d7 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 01             	cmp    $0x1,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 c4 27 80 00       	push   $0x8027c4
  80023c:	6a 28                	push   $0x28
  80023e:	68 b0 27 80 00       	push   $0x8027b0
  800243:	e8 11 04 00 00       	call   800659 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800248:	e8 0d 1f 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  80024d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800250:	83 f8 01             	cmp    $0x1,%eax
  800253:	74 14                	je     800269 <_main+0x231>
  800255:	83 ec 04             	sub    $0x4,%esp
  800258:	68 30 28 80 00       	push   $0x802830
  80025d:	6a 29                	push   $0x29
  80025f:	68 b0 27 80 00       	push   $0x8027b0
  800264:	e8 f0 03 00 00       	call   800659 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800269:	e8 69 1e 00 00       	call   8020d7 <sys_calculate_free_frames>
  80026e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800271:	e8 e4 1e 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  800276:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800279:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027c:	01 c0                	add    %eax,%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 80 12 00 00       	call   801507 <malloc>
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80028d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800290:	89 c2                	mov    %eax,%edx
  800292:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800295:	c1 e0 02             	shl    $0x2,%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80029d:	c1 e0 02             	shl    $0x2,%eax
  8002a0:	01 c8                	add    %ecx,%eax
  8002a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a7:	39 c2                	cmp    %eax,%edx
  8002a9:	72 1e                	jb     8002c9 <_main+0x291>
  8002ab:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	c1 e0 02             	shl    $0x2,%eax
  8002b6:	89 c1                	mov    %eax,%ecx
  8002b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002bb:	c1 e0 02             	shl    $0x2,%eax
  8002be:	01 c8                	add    %ecx,%eax
  8002c0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c5:	39 c2                	cmp    %eax,%edx
  8002c7:	76 14                	jbe    8002dd <_main+0x2a5>
  8002c9:	83 ec 04             	sub    $0x4,%esp
  8002cc:	68 80 27 80 00       	push   $0x802780
  8002d1:	6a 2e                	push   $0x2e
  8002d3:	68 b0 27 80 00       	push   $0x8027b0
  8002d8:	e8 7c 03 00 00       	call   800659 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002dd:	e8 f5 1d 00 00       	call   8020d7 <sys_calculate_free_frames>
  8002e2:	89 c2                	mov    %eax,%edx
  8002e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e7:	39 c2                	cmp    %eax,%edx
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 c4 27 80 00       	push   $0x8027c4
  8002f3:	6a 30                	push   $0x30
  8002f5:	68 b0 27 80 00       	push   $0x8027b0
  8002fa:	e8 5a 03 00 00       	call   800659 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  8002ff:	e8 56 1e 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  800304:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800307:	83 f8 01             	cmp    $0x1,%eax
  80030a:	74 14                	je     800320 <_main+0x2e8>
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	68 30 28 80 00       	push   $0x802830
  800314:	6a 31                	push   $0x31
  800316:	68 b0 27 80 00       	push   $0x8027b0
  80031b:	e8 39 03 00 00       	call   800659 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800320:	e8 b2 1d 00 00       	call   8020d7 <sys_calculate_free_frames>
  800325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800328:	e8 2d 1e 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  80032d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800330:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800333:	89 d0                	mov    %edx,%eax
  800335:	01 c0                	add    %eax,%eax
  800337:	01 d0                	add    %edx,%eax
  800339:	01 c0                	add    %eax,%eax
  80033b:	01 d0                	add    %edx,%eax
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	50                   	push   %eax
  800341:	e8 c1 11 00 00       	call   801507 <malloc>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80034c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80034f:	89 c2                	mov    %eax,%edx
  800351:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800354:	c1 e0 02             	shl    $0x2,%eax
  800357:	89 c1                	mov    %eax,%ecx
  800359:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80035c:	c1 e0 03             	shl    $0x3,%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	05 00 00 00 80       	add    $0x80000000,%eax
  800366:	39 c2                	cmp    %eax,%edx
  800368:	72 1e                	jb     800388 <_main+0x350>
  80036a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80036d:	89 c2                	mov    %eax,%edx
  80036f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800372:	c1 e0 02             	shl    $0x2,%eax
  800375:	89 c1                	mov    %eax,%ecx
  800377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80037a:	c1 e0 03             	shl    $0x3,%eax
  80037d:	01 c8                	add    %ecx,%eax
  80037f:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800384:	39 c2                	cmp    %eax,%edx
  800386:	76 14                	jbe    80039c <_main+0x364>
  800388:	83 ec 04             	sub    $0x4,%esp
  80038b:	68 80 27 80 00       	push   $0x802780
  800390:	6a 36                	push   $0x36
  800392:	68 b0 27 80 00       	push   $0x8027b0
  800397:	e8 bd 02 00 00       	call   800659 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039c:	e8 36 1d 00 00       	call   8020d7 <sys_calculate_free_frames>
  8003a1:	89 c2                	mov    %eax,%edx
  8003a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a6:	39 c2                	cmp    %eax,%edx
  8003a8:	74 14                	je     8003be <_main+0x386>
  8003aa:	83 ec 04             	sub    $0x4,%esp
  8003ad:	68 c4 27 80 00       	push   $0x8027c4
  8003b2:	6a 38                	push   $0x38
  8003b4:	68 b0 27 80 00       	push   $0x8027b0
  8003b9:	e8 9b 02 00 00       	call   800659 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  8003be:	e8 97 1d 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  8003c3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003c6:	83 f8 02             	cmp    $0x2,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 30 28 80 00       	push   $0x802830
  8003d3:	6a 39                	push   $0x39
  8003d5:	68 b0 27 80 00       	push   $0x8027b0
  8003da:	e8 7a 02 00 00       	call   800659 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 f3 1c 00 00       	call   8020d7 <sys_calculate_free_frames>
  8003e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 6e 1d 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  8003ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	01 d2                	add    %edx,%edx
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	50                   	push   %eax
  8003ff:	e8 03 11 00 00       	call   801507 <malloc>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80040a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800412:	c1 e0 02             	shl    $0x2,%eax
  800415:	89 c1                	mov    %eax,%ecx
  800417:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041a:	c1 e0 04             	shl    $0x4,%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	05 00 00 00 80       	add    $0x80000000,%eax
  800424:	39 c2                	cmp    %eax,%edx
  800426:	72 1e                	jb     800446 <_main+0x40e>
  800428:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80042b:	89 c2                	mov    %eax,%edx
  80042d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800430:	c1 e0 02             	shl    $0x2,%eax
  800433:	89 c1                	mov    %eax,%ecx
  800435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800438:	c1 e0 04             	shl    $0x4,%eax
  80043b:	01 c8                	add    %ecx,%eax
  80043d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800442:	39 c2                	cmp    %eax,%edx
  800444:	76 14                	jbe    80045a <_main+0x422>
  800446:	83 ec 04             	sub    $0x4,%esp
  800449:	68 80 27 80 00       	push   $0x802780
  80044e:	6a 3e                	push   $0x3e
  800450:	68 b0 27 80 00       	push   $0x8027b0
  800455:	e8 ff 01 00 00       	call   800659 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80045a:	e8 78 1c 00 00       	call   8020d7 <sys_calculate_free_frames>
  80045f:	89 c2                	mov    %eax,%edx
  800461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	74 14                	je     80047c <_main+0x444>
  800468:	83 ec 04             	sub    $0x4,%esp
  80046b:	68 5e 28 80 00       	push   $0x80285e
  800470:	6a 3f                	push   $0x3f
  800472:	68 b0 27 80 00       	push   $0x8027b0
  800477:	e8 dd 01 00 00       	call   800659 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80047c:	e8 d9 1c 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  800481:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800484:	89 c2                	mov    %eax,%edx
  800486:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800489:	89 c1                	mov    %eax,%ecx
  80048b:	01 c9                	add    %ecx,%ecx
  80048d:	01 c8                	add    %ecx,%eax
  80048f:	85 c0                	test   %eax,%eax
  800491:	79 05                	jns    800498 <_main+0x460>
  800493:	05 ff 0f 00 00       	add    $0xfff,%eax
  800498:	c1 f8 0c             	sar    $0xc,%eax
  80049b:	39 c2                	cmp    %eax,%edx
  80049d:	74 14                	je     8004b3 <_main+0x47b>
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	68 30 28 80 00       	push   $0x802830
  8004a7:	6a 40                	push   $0x40
  8004a9:	68 b0 27 80 00       	push   $0x8027b0
  8004ae:	e8 a6 01 00 00       	call   800659 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b3:	e8 1f 1c 00 00       	call   8020d7 <sys_calculate_free_frames>
  8004b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004bb:	e8 9a 1c 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  8004c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004cb:	83 ec 0c             	sub    $0xc,%esp
  8004ce:	50                   	push   %eax
  8004cf:	e8 33 10 00 00       	call   801507 <malloc>
  8004d4:	83 c4 10             	add    $0x10,%esp
  8004d7:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004da:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004dd:	89 c1                	mov    %eax,%ecx
  8004df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e2:	89 d0                	mov    %edx,%eax
  8004e4:	01 c0                	add    %eax,%eax
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	01 c0                	add    %eax,%eax
  8004ea:	01 d0                	add    %edx,%eax
  8004ec:	89 c2                	mov    %eax,%edx
  8004ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004f1:	c1 e0 04             	shl    $0x4,%eax
  8004f4:	01 d0                	add    %edx,%eax
  8004f6:	05 00 00 00 80       	add    $0x80000000,%eax
  8004fb:	39 c1                	cmp    %eax,%ecx
  8004fd:	72 25                	jb     800524 <_main+0x4ec>
  8004ff:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800502:	89 c1                	mov    %eax,%ecx
  800504:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800507:	89 d0                	mov    %edx,%eax
  800509:	01 c0                	add    %eax,%eax
  80050b:	01 d0                	add    %edx,%eax
  80050d:	01 c0                	add    %eax,%eax
  80050f:	01 d0                	add    %edx,%eax
  800511:	89 c2                	mov    %eax,%edx
  800513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800516:	c1 e0 04             	shl    $0x4,%eax
  800519:	01 d0                	add    %edx,%eax
  80051b:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800520:	39 c1                	cmp    %eax,%ecx
  800522:	76 14                	jbe    800538 <_main+0x500>
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 80 27 80 00       	push   $0x802780
  80052c:	6a 45                	push   $0x45
  80052e:	68 b0 27 80 00       	push   $0x8027b0
  800533:	e8 21 01 00 00       	call   800659 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800538:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80053b:	e8 97 1b 00 00       	call   8020d7 <sys_calculate_free_frames>
  800540:	29 c3                	sub    %eax,%ebx
  800542:	89 d8                	mov    %ebx,%eax
  800544:	83 f8 01             	cmp    $0x1,%eax
  800547:	74 14                	je     80055d <_main+0x525>
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	68 5e 28 80 00       	push   $0x80285e
  800551:	6a 46                	push   $0x46
  800553:	68 b0 27 80 00       	push   $0x8027b0
  800558:	e8 fc 00 00 00       	call   800659 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80055d:	e8 f8 1b 00 00       	call   80215a <sys_pf_calculate_allocated_pages>
  800562:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800565:	3d 00 02 00 00       	cmp    $0x200,%eax
  80056a:	74 14                	je     800580 <_main+0x548>
  80056c:	83 ec 04             	sub    $0x4,%esp
  80056f:	68 30 28 80 00       	push   $0x802830
  800574:	6a 47                	push   $0x47
  800576:	68 b0 27 80 00       	push   $0x8027b0
  80057b:	e8 d9 00 00 00       	call   800659 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  800580:	83 ec 0c             	sub    $0xc,%esp
  800583:	68 74 28 80 00       	push   $0x802874
  800588:	e8 f7 01 00 00       	call   800784 <cprintf>
  80058d:	83 c4 10             	add    $0x10,%esp

	return;
  800590:	90                   	nop
}
  800591:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800594:	5b                   	pop    %ebx
  800595:	5f                   	pop    %edi
  800596:	5d                   	pop    %ebp
  800597:	c3                   	ret    

00800598 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80059e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005a2:	7e 0a                	jle    8005ae <libmain+0x16>
		binaryname = argv[0];
  8005a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	ff 75 08             	pushl  0x8(%ebp)
  8005b7:	e8 7c fa ff ff       	call   800038 <_main>
  8005bc:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8005bf:	e8 61 1a 00 00       	call   802025 <sys_getenvid>
  8005c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8005c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005ca:	89 d0                	mov    %edx,%eax
  8005cc:	c1 e0 03             	shl    $0x3,%eax
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	01 c0                	add    %eax,%eax
  8005d3:	01 d0                	add    %edx,%eax
  8005d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005dc:	01 d0                	add    %edx,%eax
  8005de:	c1 e0 03             	shl    $0x3,%eax
  8005e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005e6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8005e9:	e8 85 1b 00 00       	call   802173 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	68 c8 28 80 00       	push   $0x8028c8
  8005f6:	e8 89 01 00 00       	call   800784 <cprintf>
  8005fb:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8005fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800601:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	50                   	push   %eax
  80060b:	68 f0 28 80 00       	push   $0x8028f0
  800610:	e8 6f 01 00 00       	call   800784 <cprintf>
  800615:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800618:	83 ec 0c             	sub    $0xc,%esp
  80061b:	68 c8 28 80 00       	push   $0x8028c8
  800620:	e8 5f 01 00 00       	call   800784 <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800628:	e8 60 1b 00 00       	call   80218d <sys_enable_interrupt>

	// exit gracefully
	exit();
  80062d:	e8 19 00 00 00       	call   80064b <exit>
}
  800632:	90                   	nop
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	6a 00                	push   $0x0
  800640:	e8 c5 19 00 00       	call   80200a <sys_env_destroy>
  800645:	83 c4 10             	add    $0x10,%esp
}
  800648:	90                   	nop
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <exit>:

void
exit(void)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800651:	e8 e8 19 00 00       	call   80203e <sys_env_exit>
}
  800656:	90                   	nop
  800657:	c9                   	leave  
  800658:	c3                   	ret    

00800659 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80065f:	8d 45 10             	lea    0x10(%ebp),%eax
  800662:	83 c0 04             	add    $0x4,%eax
  800665:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800668:	a1 50 30 98 00       	mov    0x983050,%eax
  80066d:	85 c0                	test   %eax,%eax
  80066f:	74 16                	je     800687 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800671:	a1 50 30 98 00       	mov    0x983050,%eax
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	50                   	push   %eax
  80067a:	68 09 29 80 00       	push   $0x802909
  80067f:	e8 00 01 00 00       	call   800784 <cprintf>
  800684:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800687:	a1 00 30 80 00       	mov    0x803000,%eax
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	ff 75 08             	pushl  0x8(%ebp)
  800692:	50                   	push   %eax
  800693:	68 0e 29 80 00       	push   $0x80290e
  800698:	e8 e7 00 00 00       	call   800784 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a9:	50                   	push   %eax
  8006aa:	e8 7a 00 00 00       	call   800729 <vcprintf>
  8006af:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8006b2:	83 ec 0c             	sub    $0xc,%esp
  8006b5:	68 2a 29 80 00       	push   $0x80292a
  8006ba:	e8 c5 00 00 00       	call   800784 <cprintf>
  8006bf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8006c2:	e8 84 ff ff ff       	call   80064b <exit>

	// should not return here
	while (1) ;
  8006c7:	eb fe                	jmp    8006c7 <_panic+0x6e>

008006c9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8006d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006da:	89 0a                	mov    %ecx,(%edx)
  8006dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8006df:	88 d1                	mov    %dl,%cl
  8006e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006f2:	75 23                	jne    800717 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8006f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	89 c2                	mov    %eax,%edx
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	83 c0 08             	add    $0x8,%eax
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	52                   	push   %edx
  800705:	50                   	push   %eax
  800706:	e8 c9 18 00 00       	call   801fd4 <sys_cputs>
  80070b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80070e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800711:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071a:	8b 40 04             	mov    0x4(%eax),%eax
  80071d:	8d 50 01             	lea    0x1(%eax),%edx
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	89 50 04             	mov    %edx,0x4(%eax)
}
  800726:	90                   	nop
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800732:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800739:	00 00 00 
	b.cnt = 0;
  80073c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800743:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	ff 75 08             	pushl  0x8(%ebp)
  80074c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800752:	50                   	push   %eax
  800753:	68 c9 06 80 00       	push   $0x8006c9
  800758:	e8 fa 01 00 00       	call   800957 <vprintfmt>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800760:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	50                   	push   %eax
  80076a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800770:	83 c0 08             	add    $0x8,%eax
  800773:	50                   	push   %eax
  800774:	e8 5b 18 00 00       	call   801fd4 <sys_cputs>
  800779:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80077c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <cprintf>:

int cprintf(const char *fmt, ...) {
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80078a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 f4             	pushl  -0xc(%ebp)
  800799:	50                   	push   %eax
  80079a:	e8 8a ff ff ff       	call   800729 <vcprintf>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007b0:	e8 be 19 00 00       	call   802173 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	e8 5f ff ff ff       	call   800729 <vcprintf>
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007d0:	e8 b8 19 00 00       	call   80218d <sys_enable_interrupt>
	return cnt;
  8007d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d8:	c9                   	leave  
  8007d9:	c3                   	ret    

008007da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	53                   	push   %ebx
  8007de:	83 ec 14             	sub    $0x14,%esp
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f8:	77 55                	ja     80084f <printnum+0x75>
  8007fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007fd:	72 05                	jb     800804 <printnum+0x2a>
  8007ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800802:	77 4b                	ja     80084f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800804:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800807:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80080a:	8b 45 18             	mov    0x18(%ebp),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	52                   	push   %edx
  800813:	50                   	push   %eax
  800814:	ff 75 f4             	pushl  -0xc(%ebp)
  800817:	ff 75 f0             	pushl  -0x10(%ebp)
  80081a:	e8 f1 1c 00 00       	call   802510 <__udivdi3>
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	ff 75 20             	pushl  0x20(%ebp)
  800828:	53                   	push   %ebx
  800829:	ff 75 18             	pushl  0x18(%ebp)
  80082c:	52                   	push   %edx
  80082d:	50                   	push   %eax
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	ff 75 08             	pushl  0x8(%ebp)
  800834:	e8 a1 ff ff ff       	call   8007da <printnum>
  800839:	83 c4 20             	add    $0x20,%esp
  80083c:	eb 1a                	jmp    800858 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	ff 75 20             	pushl  0x20(%ebp)
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	ff d0                	call   *%eax
  80084c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80084f:	ff 4d 1c             	decl   0x1c(%ebp)
  800852:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800856:	7f e6                	jg     80083e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800858:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80085b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800866:	53                   	push   %ebx
  800867:	51                   	push   %ecx
  800868:	52                   	push   %edx
  800869:	50                   	push   %eax
  80086a:	e8 b1 1d 00 00       	call   802620 <__umoddi3>
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	05 54 2b 80 00       	add    $0x802b54,%eax
  800877:	8a 00                	mov    (%eax),%al
  800879:	0f be c0             	movsbl %al,%eax
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	50                   	push   %eax
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	ff d0                	call   *%eax
  800888:	83 c4 10             	add    $0x10,%esp
}
  80088b:	90                   	nop
  80088c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088f:	c9                   	leave  
  800890:	c3                   	ret    

00800891 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800894:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800898:	7e 1c                	jle    8008b6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 08             	lea    0x8(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 08             	sub    $0x8,%eax
  8008af:	8b 50 04             	mov    0x4(%eax),%edx
  8008b2:	8b 00                	mov    (%eax),%eax
  8008b4:	eb 40                	jmp    8008f6 <getuint+0x65>
	else if (lflag)
  8008b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ba:	74 1e                	je     8008da <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	8d 50 04             	lea    0x4(%eax),%edx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	89 10                	mov    %edx,(%eax)
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d8:	eb 1c                	jmp    8008f6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	8d 50 04             	lea    0x4(%eax),%edx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	89 10                	mov    %edx,(%eax)
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ff:	7e 1c                	jle    80091d <getint+0x25>
		return va_arg(*ap, long long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 08             	lea    0x8(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 08             	sub    $0x8,%eax
  800916:	8b 50 04             	mov    0x4(%eax),%edx
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	eb 38                	jmp    800955 <getint+0x5d>
	else if (lflag)
  80091d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800921:	74 1a                	je     80093d <getint+0x45>
		return va_arg(*ap, long);
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	8d 50 04             	lea    0x4(%eax),%edx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	89 10                	mov    %edx,(%eax)
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	83 e8 04             	sub    $0x4,%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	99                   	cltd   
  80093b:	eb 18                	jmp    800955 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 04             	lea    0x4(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	99                   	cltd   
}
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095f:	eb 17                	jmp    800978 <vprintfmt+0x21>
			if (ch == '\0')
  800961:	85 db                	test   %ebx,%ebx
  800963:	0f 84 af 03 00 00    	je     800d18 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	53                   	push   %ebx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	ff d0                	call   *%eax
  800975:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800978:	8b 45 10             	mov    0x10(%ebp),%eax
  80097b:	8d 50 01             	lea    0x1(%eax),%edx
  80097e:	89 55 10             	mov    %edx,0x10(%ebp)
  800981:	8a 00                	mov    (%eax),%al
  800983:	0f b6 d8             	movzbl %al,%ebx
  800986:	83 fb 25             	cmp    $0x25,%ebx
  800989:	75 d6                	jne    800961 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80098b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80098f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800996:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80099d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009a4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ae:	8d 50 01             	lea    0x1(%eax),%edx
  8009b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b4:	8a 00                	mov    (%eax),%al
  8009b6:	0f b6 d8             	movzbl %al,%ebx
  8009b9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009bc:	83 f8 55             	cmp    $0x55,%eax
  8009bf:	0f 87 2b 03 00 00    	ja     800cf0 <vprintfmt+0x399>
  8009c5:	8b 04 85 78 2b 80 00 	mov    0x802b78(,%eax,4),%eax
  8009cc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ce:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009d2:	eb d7                	jmp    8009ab <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009d4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009d8:	eb d1                	jmp    8009ab <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009e4:	89 d0                	mov    %edx,%eax
  8009e6:	c1 e0 02             	shl    $0x2,%eax
  8009e9:	01 d0                	add    %edx,%eax
  8009eb:	01 c0                	add    %eax,%eax
  8009ed:	01 d8                	add    %ebx,%eax
  8009ef:	83 e8 30             	sub    $0x30,%eax
  8009f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f8:	8a 00                	mov    (%eax),%al
  8009fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009fd:	83 fb 2f             	cmp    $0x2f,%ebx
  800a00:	7e 3e                	jle    800a40 <vprintfmt+0xe9>
  800a02:	83 fb 39             	cmp    $0x39,%ebx
  800a05:	7f 39                	jg     800a40 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a07:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a0a:	eb d5                	jmp    8009e1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	83 c0 04             	add    $0x4,%eax
  800a12:	89 45 14             	mov    %eax,0x14(%ebp)
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	83 e8 04             	sub    $0x4,%eax
  800a1b:	8b 00                	mov    (%eax),%eax
  800a1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a20:	eb 1f                	jmp    800a41 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a26:	79 83                	jns    8009ab <vprintfmt+0x54>
				width = 0;
  800a28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a2f:	e9 77 ff ff ff       	jmp    8009ab <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a34:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a3b:	e9 6b ff ff ff       	jmp    8009ab <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a40:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a45:	0f 89 60 ff ff ff    	jns    8009ab <vprintfmt+0x54>
				width = precision, precision = -1;
  800a4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a51:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a58:	e9 4e ff ff ff       	jmp    8009ab <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a5d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a60:	e9 46 ff ff ff       	jmp    8009ab <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a65:	8b 45 14             	mov    0x14(%ebp),%eax
  800a68:	83 c0 04             	add    $0x4,%eax
  800a6b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a71:	83 e8 04             	sub    $0x4,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	50                   	push   %eax
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	ff d0                	call   *%eax
  800a82:	83 c4 10             	add    $0x10,%esp
			break;
  800a85:	e9 89 02 00 00       	jmp    800d13 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	83 c0 04             	add    $0x4,%eax
  800a90:	89 45 14             	mov    %eax,0x14(%ebp)
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	83 e8 04             	sub    $0x4,%eax
  800a99:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a9b:	85 db                	test   %ebx,%ebx
  800a9d:	79 02                	jns    800aa1 <vprintfmt+0x14a>
				err = -err;
  800a9f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aa1:	83 fb 64             	cmp    $0x64,%ebx
  800aa4:	7f 0b                	jg     800ab1 <vprintfmt+0x15a>
  800aa6:	8b 34 9d c0 29 80 00 	mov    0x8029c0(,%ebx,4),%esi
  800aad:	85 f6                	test   %esi,%esi
  800aaf:	75 19                	jne    800aca <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ab1:	53                   	push   %ebx
  800ab2:	68 65 2b 80 00       	push   $0x802b65
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	ff 75 08             	pushl  0x8(%ebp)
  800abd:	e8 5e 02 00 00       	call   800d20 <printfmt>
  800ac2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ac5:	e9 49 02 00 00       	jmp    800d13 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aca:	56                   	push   %esi
  800acb:	68 6e 2b 80 00       	push   $0x802b6e
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	ff 75 08             	pushl  0x8(%ebp)
  800ad6:	e8 45 02 00 00       	call   800d20 <printfmt>
  800adb:	83 c4 10             	add    $0x10,%esp
			break;
  800ade:	e9 30 02 00 00       	jmp    800d13 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 30                	mov    (%eax),%esi
  800af4:	85 f6                	test   %esi,%esi
  800af6:	75 05                	jne    800afd <vprintfmt+0x1a6>
				p = "(null)";
  800af8:	be 71 2b 80 00       	mov    $0x802b71,%esi
			if (width > 0 && padc != '-')
  800afd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b01:	7e 6d                	jle    800b70 <vprintfmt+0x219>
  800b03:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b07:	74 67                	je     800b70 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	50                   	push   %eax
  800b10:	56                   	push   %esi
  800b11:	e8 0c 03 00 00       	call   800e22 <strnlen>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b1c:	eb 16                	jmp    800b34 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b1e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	50                   	push   %eax
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	ff d0                	call   *%eax
  800b2e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b31:	ff 4d e4             	decl   -0x1c(%ebp)
  800b34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b38:	7f e4                	jg     800b1e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3a:	eb 34                	jmp    800b70 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b40:	74 1c                	je     800b5e <vprintfmt+0x207>
  800b42:	83 fb 1f             	cmp    $0x1f,%ebx
  800b45:	7e 05                	jle    800b4c <vprintfmt+0x1f5>
  800b47:	83 fb 7e             	cmp    $0x7e,%ebx
  800b4a:	7e 12                	jle    800b5e <vprintfmt+0x207>
					putch('?', putdat);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	6a 3f                	push   $0x3f
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	ff d0                	call   *%eax
  800b59:	83 c4 10             	add    $0x10,%esp
  800b5c:	eb 0f                	jmp    800b6d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	53                   	push   %ebx
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b70:	89 f0                	mov    %esi,%eax
  800b72:	8d 70 01             	lea    0x1(%eax),%esi
  800b75:	8a 00                	mov    (%eax),%al
  800b77:	0f be d8             	movsbl %al,%ebx
  800b7a:	85 db                	test   %ebx,%ebx
  800b7c:	74 24                	je     800ba2 <vprintfmt+0x24b>
  800b7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b82:	78 b8                	js     800b3c <vprintfmt+0x1e5>
  800b84:	ff 4d e0             	decl   -0x20(%ebp)
  800b87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8b:	79 af                	jns    800b3c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8d:	eb 13                	jmp    800ba2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 20                	push   $0x20
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9f:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba6:	7f e7                	jg     800b8f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ba8:	e9 66 01 00 00       	jmp    800d13 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb6:	50                   	push   %eax
  800bb7:	e8 3c fd ff ff       	call   8008f8 <getint>
  800bbc:	83 c4 10             	add    $0x10,%esp
  800bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcb:	85 d2                	test   %edx,%edx
  800bcd:	79 23                	jns    800bf2 <vprintfmt+0x29b>
				putch('-', putdat);
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	6a 2d                	push   $0x2d
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	ff d0                	call   *%eax
  800bdc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be5:	f7 d8                	neg    %eax
  800be7:	83 d2 00             	adc    $0x0,%edx
  800bea:	f7 da                	neg    %edx
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bf2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf9:	e9 bc 00 00 00       	jmp    800cba <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bfe:	83 ec 08             	sub    $0x8,%esp
  800c01:	ff 75 e8             	pushl  -0x18(%ebp)
  800c04:	8d 45 14             	lea    0x14(%ebp),%eax
  800c07:	50                   	push   %eax
  800c08:	e8 84 fc ff ff       	call   800891 <getuint>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c16:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c1d:	e9 98 00 00 00       	jmp    800cba <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c22:	83 ec 08             	sub    $0x8,%esp
  800c25:	ff 75 0c             	pushl  0xc(%ebp)
  800c28:	6a 58                	push   $0x58
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	ff d0                	call   *%eax
  800c2f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 58                	push   $0x58
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	6a 58                	push   $0x58
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	ff d0                	call   *%eax
  800c4f:	83 c4 10             	add    $0x10,%esp
			break;
  800c52:	e9 bc 00 00 00       	jmp    800d13 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	6a 30                	push   $0x30
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	ff d0                	call   *%eax
  800c64:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	6a 78                	push   $0x78
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	ff d0                	call   *%eax
  800c74:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c77:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7a:	83 c0 04             	add    $0x4,%eax
  800c7d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c80:	8b 45 14             	mov    0x14(%ebp),%eax
  800c83:	83 e8 04             	sub    $0x4,%eax
  800c86:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c92:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c99:	eb 1f                	jmp    800cba <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c9b:	83 ec 08             	sub    $0x8,%esp
  800c9e:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca4:	50                   	push   %eax
  800ca5:	e8 e7 fb ff ff       	call   800891 <getuint>
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cb3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cba:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc1:	83 ec 04             	sub    $0x4,%esp
  800cc4:	52                   	push   %edx
  800cc5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cc8:	50                   	push   %eax
  800cc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800ccc:	ff 75 f0             	pushl  -0x10(%ebp)
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 00 fb ff ff       	call   8007da <printnum>
  800cda:	83 c4 20             	add    $0x20,%esp
			break;
  800cdd:	eb 34                	jmp    800d13 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	ff 75 0c             	pushl  0xc(%ebp)
  800ce5:	53                   	push   %ebx
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	ff d0                	call   *%eax
  800ceb:	83 c4 10             	add    $0x10,%esp
			break;
  800cee:	eb 23                	jmp    800d13 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	ff 75 0c             	pushl  0xc(%ebp)
  800cf6:	6a 25                	push   $0x25
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	ff d0                	call   *%eax
  800cfd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d00:	ff 4d 10             	decl   0x10(%ebp)
  800d03:	eb 03                	jmp    800d08 <vprintfmt+0x3b1>
  800d05:	ff 4d 10             	decl   0x10(%ebp)
  800d08:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0b:	48                   	dec    %eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	3c 25                	cmp    $0x25,%al
  800d10:	75 f3                	jne    800d05 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d12:	90                   	nop
		}
	}
  800d13:	e9 47 fc ff ff       	jmp    80095f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d18:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d26:	8d 45 10             	lea    0x10(%ebp),%eax
  800d29:	83 c0 04             	add    $0x4,%eax
  800d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	ff 75 f4             	pushl  -0xc(%ebp)
  800d35:	50                   	push   %eax
  800d36:	ff 75 0c             	pushl  0xc(%ebp)
  800d39:	ff 75 08             	pushl  0x8(%ebp)
  800d3c:	e8 16 fc ff ff       	call   800957 <vprintfmt>
  800d41:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d44:	90                   	nop
  800d45:	c9                   	leave  
  800d46:	c3                   	ret    

00800d47 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8b 40 08             	mov    0x8(%eax),%eax
  800d50:	8d 50 01             	lea    0x1(%eax),%edx
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8b 10                	mov    (%eax),%edx
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	8b 40 04             	mov    0x4(%eax),%eax
  800d64:	39 c2                	cmp    %eax,%edx
  800d66:	73 12                	jae    800d7a <sprintputch+0x33>
		*b->buf++ = ch;
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d73:	89 0a                	mov    %ecx,(%edx)
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	88 10                	mov    %dl,(%eax)
}
  800d7a:	90                   	nop
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	01 d0                	add    %edx,%eax
  800d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da2:	74 06                	je     800daa <vsnprintf+0x2d>
  800da4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da8:	7f 07                	jg     800db1 <vsnprintf+0x34>
		return -E_INVAL;
  800daa:	b8 03 00 00 00       	mov    $0x3,%eax
  800daf:	eb 20                	jmp    800dd1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800db1:	ff 75 14             	pushl  0x14(%ebp)
  800db4:	ff 75 10             	pushl  0x10(%ebp)
  800db7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dba:	50                   	push   %eax
  800dbb:	68 47 0d 80 00       	push   $0x800d47
  800dc0:	e8 92 fb ff ff       	call   800957 <vprintfmt>
  800dc5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dcb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dd9:	8d 45 10             	lea    0x10(%ebp),%eax
  800ddc:	83 c0 04             	add    $0x4,%eax
  800ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	ff 75 f4             	pushl  -0xc(%ebp)
  800de8:	50                   	push   %eax
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	ff 75 08             	pushl  0x8(%ebp)
  800def:	e8 89 ff ff ff       	call   800d7d <vsnprintf>
  800df4:	83 c4 10             	add    $0x10,%esp
  800df7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0c:	eb 06                	jmp    800e14 <strlen+0x15>
		n++;
  800e0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e11:	ff 45 08             	incl   0x8(%ebp)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	84 c0                	test   %al,%al
  800e1b:	75 f1                	jne    800e0e <strlen+0xf>
		n++;
	return n;
  800e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2f:	eb 09                	jmp    800e3a <strnlen+0x18>
		n++;
  800e31:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e34:	ff 45 08             	incl   0x8(%ebp)
  800e37:	ff 4d 0c             	decl   0xc(%ebp)
  800e3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e3e:	74 09                	je     800e49 <strnlen+0x27>
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	84 c0                	test   %al,%al
  800e47:	75 e8                	jne    800e31 <strnlen+0xf>
		n++;
	return n;
  800e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e5a:	90                   	nop
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	8d 50 01             	lea    0x1(%eax),%edx
  800e61:	89 55 08             	mov    %edx,0x8(%ebp)
  800e64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	84 c0                	test   %al,%al
  800e75:	75 e4                	jne    800e5b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8f:	eb 1f                	jmp    800eb0 <strncpy+0x34>
		*dst++ = *src;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8a 12                	mov    (%edx),%dl
  800e9f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	84 c0                	test   %al,%al
  800ea8:	74 03                	je     800ead <strncpy+0x31>
			src++;
  800eaa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ead:	ff 45 fc             	incl   -0x4(%ebp)
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eb6:	72 d9                	jb     800e91 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ebb:	c9                   	leave  
  800ebc:	c3                   	ret    

00800ebd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecd:	74 30                	je     800eff <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ecf:	eb 16                	jmp    800ee7 <strlcpy+0x2a>
			*dst++ = *src++;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8d 50 01             	lea    0x1(%eax),%edx
  800ed7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ee3:	8a 12                	mov    (%edx),%dl
  800ee5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ee7:	ff 4d 10             	decl   0x10(%ebp)
  800eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eee:	74 09                	je     800ef9 <strlcpy+0x3c>
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	84 c0                	test   %al,%al
  800ef7:	75 d8                	jne    800ed1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f05:	29 c2                	sub    %eax,%edx
  800f07:	89 d0                	mov    %edx,%eax
}
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f0e:	eb 06                	jmp    800f16 <strcmp+0xb>
		p++, q++;
  800f10:	ff 45 08             	incl   0x8(%ebp)
  800f13:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	84 c0                	test   %al,%al
  800f1d:	74 0e                	je     800f2d <strcmp+0x22>
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 10                	mov    (%eax),%dl
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	38 c2                	cmp    %al,%dl
  800f2b:	74 e3                	je     800f10 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	0f b6 d0             	movzbl %al,%edx
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	0f b6 c0             	movzbl %al,%eax
  800f3d:	29 c2                	sub    %eax,%edx
  800f3f:	89 d0                	mov    %edx,%eax
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f46:	eb 09                	jmp    800f51 <strncmp+0xe>
		n--, p++, q++;
  800f48:	ff 4d 10             	decl   0x10(%ebp)
  800f4b:	ff 45 08             	incl   0x8(%ebp)
  800f4e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f55:	74 17                	je     800f6e <strncmp+0x2b>
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	84 c0                	test   %al,%al
  800f5e:	74 0e                	je     800f6e <strncmp+0x2b>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 10                	mov    (%eax),%dl
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	38 c2                	cmp    %al,%dl
  800f6c:	74 da                	je     800f48 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f72:	75 07                	jne    800f7b <strncmp+0x38>
		return 0;
  800f74:	b8 00 00 00 00       	mov    $0x0,%eax
  800f79:	eb 14                	jmp    800f8f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	0f b6 d0             	movzbl %al,%edx
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	0f b6 c0             	movzbl %al,%eax
  800f8b:	29 c2                	sub    %eax,%edx
  800f8d:	89 d0                	mov    %edx,%eax
}
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    

00800f91 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9d:	eb 12                	jmp    800fb1 <strchr+0x20>
		if (*s == c)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa7:	75 05                	jne    800fae <strchr+0x1d>
			return (char *) s;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	eb 11                	jmp    800fbf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fae:	ff 45 08             	incl   0x8(%ebp)
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	84 c0                	test   %al,%al
  800fb8:	75 e5                	jne    800f9f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbf:	c9                   	leave  
  800fc0:	c3                   	ret    

00800fc1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 04             	sub    $0x4,%esp
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fcd:	eb 0d                	jmp    800fdc <strfind+0x1b>
		if (*s == c)
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd7:	74 0e                	je     800fe7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fd9:	ff 45 08             	incl   0x8(%ebp)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	84 c0                	test   %al,%al
  800fe3:	75 ea                	jne    800fcf <strfind+0xe>
  800fe5:	eb 01                	jmp    800fe8 <strfind+0x27>
		if (*s == c)
			break;
  800fe7:	90                   	nop
	return (char *) s;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fff:	eb 0e                	jmp    80100f <memset+0x22>
		*p++ = c;
  801001:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80100a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80100f:	ff 4d f8             	decl   -0x8(%ebp)
  801012:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801016:	79 e9                	jns    801001 <memset+0x14>
		*p++ = c;

	return v;
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80102f:	eb 16                	jmp    801047 <memcpy+0x2a>
		*d++ = *s++;
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	8d 50 01             	lea    0x1(%eax),%edx
  801037:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80103a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801040:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801043:	8a 12                	mov    (%edx),%dl
  801045:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104d:	89 55 10             	mov    %edx,0x10(%ebp)
  801050:	85 c0                	test   %eax,%eax
  801052:	75 dd                	jne    801031 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80106b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801071:	73 50                	jae    8010c3 <memmove+0x6a>
  801073:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801076:	8b 45 10             	mov    0x10(%ebp),%eax
  801079:	01 d0                	add    %edx,%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	76 43                	jbe    8010c3 <memmove+0x6a>
		s += n;
  801080:	8b 45 10             	mov    0x10(%ebp),%eax
  801083:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801086:	8b 45 10             	mov    0x10(%ebp),%eax
  801089:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80108c:	eb 10                	jmp    80109e <memmove+0x45>
			*--d = *--s;
  80108e:	ff 4d f8             	decl   -0x8(%ebp)
  801091:	ff 4d fc             	decl   -0x4(%ebp)
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	8a 10                	mov    (%eax),%dl
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80109e:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	75 e3                	jne    80108e <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010ab:	eb 23                	jmp    8010d0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b0:	8d 50 01             	lea    0x1(%eax),%edx
  8010b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010bf:	8a 12                	mov    (%edx),%dl
  8010c1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	75 dd                	jne    8010ad <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010e7:	eb 2a                	jmp    801113 <memcmp+0x3e>
		if (*s1 != *s2)
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 10                	mov    (%eax),%dl
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	38 c2                	cmp    %al,%dl
  8010f5:	74 16                	je     80110d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	0f b6 d0             	movzbl %al,%edx
  8010ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	0f b6 c0             	movzbl %al,%eax
  801107:	29 c2                	sub    %eax,%edx
  801109:	89 d0                	mov    %edx,%eax
  80110b:	eb 18                	jmp    801125 <memcmp+0x50>
		s1++, s2++;
  80110d:	ff 45 fc             	incl   -0x4(%ebp)
  801110:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	8d 50 ff             	lea    -0x1(%eax),%edx
  801119:	89 55 10             	mov    %edx,0x10(%ebp)
  80111c:	85 c0                	test   %eax,%eax
  80111e:	75 c9                	jne    8010e9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801120:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80112d:	8b 55 08             	mov    0x8(%ebp),%edx
  801130:	8b 45 10             	mov    0x10(%ebp),%eax
  801133:	01 d0                	add    %edx,%eax
  801135:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801138:	eb 15                	jmp    80114f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	0f b6 d0             	movzbl %al,%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	0f b6 c0             	movzbl %al,%eax
  801148:	39 c2                	cmp    %eax,%edx
  80114a:	74 0d                	je     801159 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80114c:	ff 45 08             	incl   0x8(%ebp)
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801155:	72 e3                	jb     80113a <memfind+0x13>
  801157:	eb 01                	jmp    80115a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801159:	90                   	nop
	return (void *) s;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    

0080115f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801165:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80116c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801173:	eb 03                	jmp    801178 <strtol+0x19>
		s++;
  801175:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	3c 20                	cmp    $0x20,%al
  80117f:	74 f4                	je     801175 <strtol+0x16>
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 09                	cmp    $0x9,%al
  801188:	74 eb                	je     801175 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2b                	cmp    $0x2b,%al
  801191:	75 05                	jne    801198 <strtol+0x39>
		s++;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	eb 13                	jmp    8011ab <strtol+0x4c>
	else if (*s == '-')
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	3c 2d                	cmp    $0x2d,%al
  80119f:	75 0a                	jne    8011ab <strtol+0x4c>
		s++, neg = 1;
  8011a1:	ff 45 08             	incl   0x8(%ebp)
  8011a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011af:	74 06                	je     8011b7 <strtol+0x58>
  8011b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011b5:	75 20                	jne    8011d7 <strtol+0x78>
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3c 30                	cmp    $0x30,%al
  8011be:	75 17                	jne    8011d7 <strtol+0x78>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	40                   	inc    %eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 78                	cmp    $0x78,%al
  8011c8:	75 0d                	jne    8011d7 <strtol+0x78>
		s += 2, base = 16;
  8011ca:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ce:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011d5:	eb 28                	jmp    8011ff <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011db:	75 15                	jne    8011f2 <strtol+0x93>
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 30                	cmp    $0x30,%al
  8011e4:	75 0c                	jne    8011f2 <strtol+0x93>
		s++, base = 8;
  8011e6:	ff 45 08             	incl   0x8(%ebp)
  8011e9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011f0:	eb 0d                	jmp    8011ff <strtol+0xa0>
	else if (base == 0)
  8011f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f6:	75 07                	jne    8011ff <strtol+0xa0>
		base = 10;
  8011f8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 2f                	cmp    $0x2f,%al
  801206:	7e 19                	jle    801221 <strtol+0xc2>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 39                	cmp    $0x39,%al
  80120f:	7f 10                	jg     801221 <strtol+0xc2>
			dig = *s - '0';
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 30             	sub    $0x30,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 42                	jmp    801263 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 60                	cmp    $0x60,%al
  801228:	7e 19                	jle    801243 <strtol+0xe4>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 7a                	cmp    $0x7a,%al
  801231:	7f 10                	jg     801243 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 57             	sub    $0x57,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801241:	eb 20                	jmp    801263 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 40                	cmp    $0x40,%al
  80124a:	7e 39                	jle    801285 <strtol+0x126>
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 5a                	cmp    $0x5a,%al
  801253:	7f 30                	jg     801285 <strtol+0x126>
			dig = *s - 'A' + 10;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f be c0             	movsbl %al,%eax
  80125d:	83 e8 37             	sub    $0x37,%eax
  801260:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801266:	3b 45 10             	cmp    0x10(%ebp),%eax
  801269:	7d 19                	jge    801284 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80126b:	ff 45 08             	incl   0x8(%ebp)
  80126e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801271:	0f af 45 10          	imul   0x10(%ebp),%eax
  801275:	89 c2                	mov    %eax,%edx
  801277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80127f:	e9 7b ff ff ff       	jmp    8011ff <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801284:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801285:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801289:	74 08                	je     801293 <strtol+0x134>
		*endptr = (char *) s;
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	8b 55 08             	mov    0x8(%ebp),%edx
  801291:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801293:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801297:	74 07                	je     8012a0 <strtol+0x141>
  801299:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129c:	f7 d8                	neg    %eax
  80129e:	eb 03                	jmp    8012a3 <strtol+0x144>
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <ltostr>:

void
ltostr(long value, char *str)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012bd:	79 13                	jns    8012d2 <ltostr+0x2d>
	{
		neg = 1;
  8012bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012cc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012da:	99                   	cltd   
  8012db:	f7 f9                	idiv   %ecx
  8012dd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e3:	8d 50 01             	lea    0x1(%eax),%edx
  8012e6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e9:	89 c2                	mov    %eax,%edx
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	01 d0                	add    %edx,%eax
  8012f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f3:	83 c2 30             	add    $0x30,%edx
  8012f6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012fb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801300:	f7 e9                	imul   %ecx
  801302:	c1 fa 02             	sar    $0x2,%edx
  801305:	89 c8                	mov    %ecx,%eax
  801307:	c1 f8 1f             	sar    $0x1f,%eax
  80130a:	29 c2                	sub    %eax,%edx
  80130c:	89 d0                	mov    %edx,%eax
  80130e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801311:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801314:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801319:	f7 e9                	imul   %ecx
  80131b:	c1 fa 02             	sar    $0x2,%edx
  80131e:	89 c8                	mov    %ecx,%eax
  801320:	c1 f8 1f             	sar    $0x1f,%eax
  801323:	29 c2                	sub    %eax,%edx
  801325:	89 d0                	mov    %edx,%eax
  801327:	c1 e0 02             	shl    $0x2,%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	01 c0                	add    %eax,%eax
  80132e:	29 c1                	sub    %eax,%ecx
  801330:	89 ca                	mov    %ecx,%edx
  801332:	85 d2                	test   %edx,%edx
  801334:	75 9c                	jne    8012d2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801336:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	48                   	dec    %eax
  801341:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801344:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801348:	74 3d                	je     801387 <ltostr+0xe2>
		start = 1 ;
  80134a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801351:	eb 34                	jmp    801387 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	01 d0                	add    %edx,%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 c2                	add    %eax,%edx
  801368:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	01 c8                	add    %ecx,%eax
  801370:	8a 00                	mov    (%eax),%al
  801372:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801374:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137a:	01 c2                	add    %eax,%edx
  80137c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80137f:	88 02                	mov    %al,(%edx)
		start++ ;
  801381:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801384:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80138d:	7c c4                	jl     801353 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80138f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801392:	8b 45 0c             	mov    0xc(%ebp),%eax
  801395:	01 d0                	add    %edx,%eax
  801397:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80139a:	90                   	nop
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013a3:	ff 75 08             	pushl  0x8(%ebp)
  8013a6:	e8 54 fa ff ff       	call   800dff <strlen>
  8013ab:	83 c4 04             	add    $0x4,%esp
  8013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013b1:	ff 75 0c             	pushl  0xc(%ebp)
  8013b4:	e8 46 fa ff ff       	call   800dff <strlen>
  8013b9:	83 c4 04             	add    $0x4,%esp
  8013bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013cd:	eb 17                	jmp    8013e6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d5:	01 c2                	add    %eax,%edx
  8013d7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	01 c8                	add    %ecx,%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013e3:	ff 45 fc             	incl   -0x4(%ebp)
  8013e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ec:	7c e1                	jl     8013cf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013fc:	eb 1f                	jmp    80141d <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801401:	8d 50 01             	lea    0x1(%eax),%edx
  801404:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801407:	89 c2                	mov    %eax,%edx
  801409:	8b 45 10             	mov    0x10(%ebp),%eax
  80140c:	01 c2                	add    %eax,%edx
  80140e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 c8                	add    %ecx,%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80141a:	ff 45 f8             	incl   -0x8(%ebp)
  80141d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801420:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801423:	7c d9                	jl     8013fe <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801425:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c6 00 00             	movb   $0x0,(%eax)
}
  801430:	90                   	nop
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801436:	8b 45 14             	mov    0x14(%ebp),%eax
  801439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80143f:	8b 45 14             	mov    0x14(%ebp),%eax
  801442:	8b 00                	mov    (%eax),%eax
  801444:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80144b:	8b 45 10             	mov    0x10(%ebp),%eax
  80144e:	01 d0                	add    %edx,%eax
  801450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801456:	eb 0c                	jmp    801464 <strsplit+0x31>
			*string++ = 0;
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	8d 50 01             	lea    0x1(%eax),%edx
  80145e:	89 55 08             	mov    %edx,0x8(%ebp)
  801461:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	84 c0                	test   %al,%al
  80146b:	74 18                	je     801485 <strsplit+0x52>
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	50                   	push   %eax
  801476:	ff 75 0c             	pushl  0xc(%ebp)
  801479:	e8 13 fb ff ff       	call   800f91 <strchr>
  80147e:	83 c4 08             	add    $0x8,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	75 d3                	jne    801458 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	84 c0                	test   %al,%al
  80148c:	74 5a                	je     8014e8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  80148e:	8b 45 14             	mov    0x14(%ebp),%eax
  801491:	8b 00                	mov    (%eax),%eax
  801493:	83 f8 0f             	cmp    $0xf,%eax
  801496:	75 07                	jne    80149f <strsplit+0x6c>
		{
			return 0;
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
  80149d:	eb 66                	jmp    801505 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80149f:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a2:	8b 00                	mov    (%eax),%eax
  8014a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8014a7:	8b 55 14             	mov    0x14(%ebp),%edx
  8014aa:	89 0a                	mov    %ecx,(%edx)
  8014ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b6:	01 c2                	add    %eax,%edx
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014bd:	eb 03                	jmp    8014c2 <strsplit+0x8f>
			string++;
  8014bf:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	84 c0                	test   %al,%al
  8014c9:	74 8b                	je     801456 <strsplit+0x23>
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8a 00                	mov    (%eax),%al
  8014d0:	0f be c0             	movsbl %al,%eax
  8014d3:	50                   	push   %eax
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	e8 b5 fa ff ff       	call   800f91 <strchr>
  8014dc:	83 c4 08             	add    $0x8,%esp
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	74 dc                	je     8014bf <strsplit+0x8c>
			string++;
	}
  8014e3:	e9 6e ff ff ff       	jmp    801456 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014e8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ec:	8b 00                	mov    (%eax),%eax
  8014ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f8:	01 d0                	add    %edx,%eax
  8014fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801500:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801510:	e8 7d 0f 00 00       	call   802492 <sys_isUHeapPlacementStrategyNEXTFIT>
  801515:	85 c0                	test   %eax,%eax
  801517:	0f 84 6f 03 00 00    	je     80188c <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  80151d:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801524:	8b 55 08             	mov    0x8(%ebp),%edx
  801527:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80152a:	01 d0                	add    %edx,%eax
  80152c:	48                   	dec    %eax
  80152d:	89 45 80             	mov    %eax,-0x80(%ebp)
  801530:	8b 45 80             	mov    -0x80(%ebp),%eax
  801533:	ba 00 00 00 00       	mov    $0x0,%edx
  801538:	f7 75 84             	divl   -0x7c(%ebp)
  80153b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80153e:	29 d0                	sub    %edx,%eax
  801540:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801543:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801547:	74 09                	je     801552 <malloc+0x4b>
  801549:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801550:	76 0a                	jbe    80155c <malloc+0x55>
			return NULL;
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
  801557:	e9 4b 09 00 00       	jmp    801ea7 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  80155c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	01 d0                	add    %edx,%eax
  801567:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80156c:	0f 87 a2 00 00 00    	ja     801614 <malloc+0x10d>
  801572:	a1 40 30 98 00       	mov    0x983040,%eax
  801577:	85 c0                	test   %eax,%eax
  801579:	0f 85 95 00 00 00    	jne    801614 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  80157f:	a1 04 30 80 00       	mov    0x803004,%eax
  801584:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  80158a:	a1 04 30 80 00       	mov    0x803004,%eax
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	ff 75 08             	pushl  0x8(%ebp)
  801595:	50                   	push   %eax
  801596:	e8 a3 0b 00 00       	call   80213e <sys_allocateMem>
  80159b:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  80159e:	a1 20 30 80 00       	mov    0x803020,%eax
  8015a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a6:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8015ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8015b2:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015b8:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
			cnt_mem++;
  8015bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8015c4:	40                   	inc    %eax
  8015c5:	a3 20 30 80 00       	mov    %eax,0x803020
			int i = 0;
  8015ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8015d1:	eb 2e                	jmp    801601 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8015d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8015d8:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8015dd:	c1 e8 0c             	shr    $0xc,%eax
  8015e0:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8015e7:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8015eb:	a1 04 30 80 00       	mov    0x803004,%eax
  8015f0:	05 00 10 00 00       	add    $0x1000,%eax
  8015f5:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8015fa:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801604:	3b 45 08             	cmp    0x8(%ebp),%eax
  801607:	72 ca                	jb     8015d3 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801609:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80160f:	e9 93 08 00 00       	jmp    801ea7 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801614:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  80161b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801622:	a1 40 30 98 00       	mov    0x983040,%eax
  801627:	85 c0                	test   %eax,%eax
  801629:	75 1d                	jne    801648 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  80162b:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801632:	00 00 80 
				check = 1;
  801635:	c7 05 40 30 98 00 01 	movl   $0x1,0x983040
  80163c:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  80163f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801646:	eb 08                	jmp    801650 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801648:	a1 04 30 80 00       	mov    0x803004,%eax
  80164d:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801650:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801657:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  80165e:	a1 04 30 80 00       	mov    0x803004,%eax
  801663:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801666:	eb 4d                	jmp    8016b5 <malloc+0x1ae>
				if (sz == size) {
  801668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80166b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80166e:	75 09                	jne    801679 <malloc+0x172>
					f = 1;
  801670:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801677:	eb 45                	jmp    8016be <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801679:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167c:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801681:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801684:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  80168b:	85 c0                	test   %eax,%eax
  80168d:	75 10                	jne    80169f <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  80168f:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801696:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  80169d:	eb 16                	jmp    8016b5 <malloc+0x1ae>
				} else {
					sz = 0;
  80169f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8016a6:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  8016ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b0:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8016b5:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8016bc:	76 aa                	jbe    801668 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  8016be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016c2:	0f 84 95 00 00 00    	je     80175d <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8016c8:	a1 04 30 80 00       	mov    0x803004,%eax
  8016cd:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  8016d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	ff 75 08             	pushl  0x8(%ebp)
  8016de:	50                   	push   %eax
  8016df:	e8 5a 0a 00 00       	call   80213e <sys_allocateMem>
  8016e4:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8016e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8016ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ef:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8016f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8016fb:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801701:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801708:	a1 20 30 80 00       	mov    0x803020,%eax
  80170d:	40                   	inc    %eax
  80170e:	a3 20 30 80 00       	mov    %eax,0x803020
				int i = 0;
  801713:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80171a:	eb 2e                	jmp    80174a <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80171c:	a1 04 30 80 00       	mov    0x803004,%eax
  801721:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801726:	c1 e8 0c             	shr    $0xc,%eax
  801729:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801730:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801734:	a1 04 30 80 00       	mov    0x803004,%eax
  801739:	05 00 10 00 00       	add    $0x1000,%eax
  80173e:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801743:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80174a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80174d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801750:	72 ca                	jb     80171c <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801752:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801758:	e9 4a 07 00 00       	jmp    801ea7 <malloc+0x9a0>

			} else {

				if (check_start) {
  80175d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801761:	74 0a                	je     80176d <malloc+0x266>

					return NULL;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	e9 3a 07 00 00       	jmp    801ea7 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  80176d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801774:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  80177b:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801782:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801789:	00 00 80 
				while (ptr < (uint32) temp_end) {
  80178c:	eb 4d                	jmp    8017db <malloc+0x2d4>
					if (sz == size) {
  80178e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801791:	3b 45 08             	cmp    0x8(%ebp),%eax
  801794:	75 09                	jne    80179f <malloc+0x298>
						f = 1;
  801796:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  80179d:	eb 44                	jmp    8017e3 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80179f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017a2:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  8017a7:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8017aa:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	75 10                	jne    8017c5 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  8017b5:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8017bc:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  8017c3:	eb 16                	jmp    8017db <malloc+0x2d4>
					} else {
						sz = 0;
  8017c5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8017cc:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  8017d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017d6:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  8017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017de:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8017e1:	72 ab                	jb     80178e <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  8017e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8017e7:	0f 84 95 00 00 00    	je     801882 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  8017ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8017f2:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  8017f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	50                   	push   %eax
  801804:	e8 35 09 00 00       	call   80213e <sys_allocateMem>
  801809:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  80180c:	a1 20 30 80 00       	mov    0x803020,%eax
  801811:	8b 55 08             	mov    0x8(%ebp),%edx
  801814:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80181b:	a1 20 30 80 00       	mov    0x803020,%eax
  801820:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801826:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
					cnt_mem++;
  80182d:	a1 20 30 80 00       	mov    0x803020,%eax
  801832:	40                   	inc    %eax
  801833:	a3 20 30 80 00       	mov    %eax,0x803020
					int i = 0;
  801838:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  80183f:	eb 2e                	jmp    80186f <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801841:	a1 04 30 80 00       	mov    0x803004,%eax
  801846:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  80184b:	c1 e8 0c             	shr    $0xc,%eax
  80184e:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801855:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801859:	a1 04 30 80 00       	mov    0x803004,%eax
  80185e:	05 00 10 00 00       	add    $0x1000,%eax
  801863:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801868:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  80186f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801872:	3b 45 08             	cmp    0x8(%ebp),%eax
  801875:	72 ca                	jb     801841 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801877:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80187d:	e9 25 06 00 00       	jmp    801ea7 <malloc+0x9a0>

				} else {

					return NULL;
  801882:	b8 00 00 00 00       	mov    $0x0,%eax
  801887:	e9 1b 06 00 00       	jmp    801ea7 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  80188c:	e8 d0 0b 00 00       	call   802461 <sys_isUHeapPlacementStrategyBESTFIT>
  801891:	85 c0                	test   %eax,%eax
  801893:	0f 84 ba 01 00 00    	je     801a53 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801899:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  8018a0:	10 00 00 
  8018a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a6:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8018ac:	01 d0                	add    %edx,%eax
  8018ae:	48                   	dec    %eax
  8018af:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8018b5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8018bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c0:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  8018c6:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8018cc:	29 d0                	sub    %edx,%eax
  8018ce:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8018d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d5:	74 09                	je     8018e0 <malloc+0x3d9>
  8018d7:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8018de:	76 0a                	jbe    8018ea <malloc+0x3e3>
			return NULL;
  8018e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e5:	e9 bd 05 00 00       	jmp    801ea7 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  8018ea:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  8018f1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  8018f8:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  8018ff:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801906:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	c1 e8 0c             	shr    $0xc,%eax
  801913:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801919:	e9 80 00 00 00       	jmp    80199e <malloc+0x497>

			if (heap_mem[i] == 0) {
  80191e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801921:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801928:	85 c0                	test   %eax,%eax
  80192a:	75 0c                	jne    801938 <malloc+0x431>

				count++;
  80192c:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  80192f:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801936:	eb 2d                	jmp    801965 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801938:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80193e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801941:	77 14                	ja     801957 <malloc+0x450>
  801943:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801946:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801949:	76 0c                	jbe    801957 <malloc+0x450>

					min_sz = count;
  80194b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80194e:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801951:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801954:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801957:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  80195e:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801965:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  80196c:	75 2d                	jne    80199b <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  80196e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801974:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801977:	77 22                	ja     80199b <malloc+0x494>
  801979:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80197c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80197f:	76 1a                	jbe    80199b <malloc+0x494>

					min_sz = count;
  801981:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801984:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801987:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80198a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  80198d:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801994:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  80199b:	ff 45 b8             	incl   -0x48(%ebp)
  80199e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019a1:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8019a6:	0f 86 72 ff ff ff    	jbe    80191e <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  8019ac:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8019b2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  8019b5:	77 06                	ja     8019bd <malloc+0x4b6>
  8019b7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8019bb:	75 0a                	jne    8019c7 <malloc+0x4c0>
			return NULL;
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c2:	e9 e0 04 00 00       	jmp    801ea7 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  8019c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019ca:	c1 e0 0c             	shl    $0xc,%eax
  8019cd:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  8019d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019d3:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  8019d9:	83 ec 08             	sub    $0x8,%esp
  8019dc:	ff 75 08             	pushl  0x8(%ebp)
  8019df:	ff 75 c4             	pushl  -0x3c(%ebp)
  8019e2:	e8 57 07 00 00       	call   80213e <sys_allocateMem>
  8019e7:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8019ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8019ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f2:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8019f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8019fe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801a01:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801a08:	a1 20 30 80 00       	mov    0x803020,%eax
  801a0d:	40                   	inc    %eax
  801a0e:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801a13:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801a1a:	eb 24                	jmp    801a40 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801a1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a1f:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801a24:	c1 e8 0c             	shr    $0xc,%eax
  801a27:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801a2e:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801a32:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801a39:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801a40:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a43:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a46:	72 d4                	jb     801a1c <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801a48:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801a4e:	e9 54 04 00 00       	jmp    801ea7 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801a53:	e8 d8 09 00 00       	call   802430 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	0f 84 88 01 00 00    	je     801be8 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801a60:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801a67:	10 00 00 
  801a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801a73:	01 d0                	add    %edx,%eax
  801a75:	48                   	dec    %eax
  801a76:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801a7c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801a82:	ba 00 00 00 00       	mov    $0x0,%edx
  801a87:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801a8d:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801a93:	29 d0                	sub    %edx,%eax
  801a95:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801a98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a9c:	74 09                	je     801aa7 <malloc+0x5a0>
  801a9e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801aa5:	76 0a                	jbe    801ab1 <malloc+0x5aa>
			return NULL;
  801aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aac:	e9 f6 03 00 00       	jmp    801ea7 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801ab1:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801ab8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801abf:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801ac6:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801acd:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	c1 e8 0c             	shr    $0xc,%eax
  801ada:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801ae0:	eb 5a                	jmp    801b3c <malloc+0x635>

			if (heap_mem[i] == 0) {
  801ae2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ae5:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	75 0c                	jne    801afc <malloc+0x5f5>

				count++;
  801af0:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801af3:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801afa:	eb 22                	jmp    801b1e <malloc+0x617>
			} else {
				if (num_p <= count) {
  801afc:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801b02:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801b05:	77 09                	ja     801b10 <malloc+0x609>

					found = 1;
  801b07:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801b0e:	eb 36                	jmp    801b46 <malloc+0x63f>
				}
				count = 0;
  801b10:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801b17:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801b1e:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801b25:	75 12                	jne    801b39 <malloc+0x632>

				if (num_p <= count) {
  801b27:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801b2d:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801b30:	77 07                	ja     801b39 <malloc+0x632>

					found = 1;
  801b32:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801b39:	ff 45 a4             	incl   -0x5c(%ebp)
  801b3c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801b3f:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801b44:	76 9c                	jbe    801ae2 <malloc+0x5db>

			}

		}

		if (!found) {
  801b46:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801b4a:	75 0a                	jne    801b56 <malloc+0x64f>
			return NULL;
  801b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b51:	e9 51 03 00 00       	jmp    801ea7 <malloc+0x9a0>

		}

		temp = ptr;
  801b56:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801b59:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801b5c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801b5f:	c1 e0 0c             	shl    $0xc,%eax
  801b62:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801b65:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801b68:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801b6e:	83 ec 08             	sub    $0x8,%esp
  801b71:	ff 75 08             	pushl  0x8(%ebp)
  801b74:	ff 75 b0             	pushl  -0x50(%ebp)
  801b77:	e8 c2 05 00 00       	call   80213e <sys_allocateMem>
  801b7c:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801b7f:	a1 20 30 80 00       	mov    0x803020,%eax
  801b84:	8b 55 08             	mov    0x8(%ebp),%edx
  801b87:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801b8e:	a1 20 30 80 00       	mov    0x803020,%eax
  801b93:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801b96:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801b9d:	a1 20 30 80 00       	mov    0x803020,%eax
  801ba2:	40                   	inc    %eax
  801ba3:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801ba8:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801baf:	eb 24                	jmp    801bd5 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801bb1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801bb4:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801bb9:	c1 e8 0c             	shr    $0xc,%eax
  801bbc:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801bc3:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801bc7:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801bce:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801bd5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801bd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bdb:	72 d4                	jb     801bb1 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801bdd:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801be3:	e9 bf 02 00 00       	jmp    801ea7 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801be8:	e8 d6 08 00 00       	call   8024c3 <sys_isUHeapPlacementStrategyWORSTFIT>
  801bed:	85 c0                	test   %eax,%eax
  801bef:	0f 84 ba 01 00 00    	je     801daf <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801bf5:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801bfc:	10 00 00 
  801bff:	8b 55 08             	mov    0x8(%ebp),%edx
  801c02:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801c08:	01 d0                	add    %edx,%eax
  801c0a:	48                   	dec    %eax
  801c0b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801c11:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801c17:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1c:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801c22:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801c28:	29 d0                	sub    %edx,%eax
  801c2a:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801c2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c31:	74 09                	je     801c3c <malloc+0x735>
  801c33:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801c3a:	76 0a                	jbe    801c46 <malloc+0x73f>
					return NULL;
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c41:	e9 61 02 00 00       	jmp    801ea7 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801c46:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801c4d:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801c54:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801c5b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801c62:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	c1 e8 0c             	shr    $0xc,%eax
  801c6f:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801c75:	e9 80 00 00 00       	jmp    801cfa <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801c7a:	8b 45 90             	mov    -0x70(%ebp),%eax
  801c7d:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801c84:	85 c0                	test   %eax,%eax
  801c86:	75 0c                	jne    801c94 <malloc+0x78d>

						count++;
  801c88:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801c8b:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801c92:	eb 2d                	jmp    801cc1 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801c94:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801c9a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801c9d:	77 14                	ja     801cb3 <malloc+0x7ac>
  801c9f:	8b 45 98             	mov    -0x68(%ebp),%eax
  801ca2:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ca5:	73 0c                	jae    801cb3 <malloc+0x7ac>

							max_sz = count;
  801ca7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801caa:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801cad:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801cb0:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801cb3:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801cba:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801cc1:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801cc8:	75 2d                	jne    801cf7 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801cca:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801cd0:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801cd3:	77 22                	ja     801cf7 <malloc+0x7f0>
  801cd5:	8b 45 98             	mov    -0x68(%ebp),%eax
  801cd8:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801cdb:	76 1a                	jbe    801cf7 <malloc+0x7f0>

							max_sz = count;
  801cdd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801ce0:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801ce3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801ce6:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801ce9:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801cf0:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801cf7:	ff 45 90             	incl   -0x70(%ebp)
  801cfa:	8b 45 90             	mov    -0x70(%ebp),%eax
  801cfd:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801d02:	0f 86 72 ff ff ff    	jbe    801c7a <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801d08:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801d0e:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801d11:	77 06                	ja     801d19 <malloc+0x812>
  801d13:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801d17:	75 0a                	jne    801d23 <malloc+0x81c>
					return NULL;
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1e:	e9 84 01 00 00       	jmp    801ea7 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801d23:	8b 45 98             	mov    -0x68(%ebp),%eax
  801d26:	c1 e0 0c             	shl    $0xc,%eax
  801d29:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801d2c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801d2f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801d35:	83 ec 08             	sub    $0x8,%esp
  801d38:	ff 75 08             	pushl  0x8(%ebp)
  801d3b:	ff 75 9c             	pushl  -0x64(%ebp)
  801d3e:	e8 fb 03 00 00       	call   80213e <sys_allocateMem>
  801d43:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801d46:	a1 20 30 80 00       	mov    0x803020,%eax
  801d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d4e:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801d55:	a1 20 30 80 00       	mov    0x803020,%eax
  801d5a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801d5d:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801d64:	a1 20 30 80 00       	mov    0x803020,%eax
  801d69:	40                   	inc    %eax
  801d6a:	a3 20 30 80 00       	mov    %eax,0x803020
				i = 0;
  801d6f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801d76:	eb 24                	jmp    801d9c <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801d78:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801d7b:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801d80:	c1 e8 0c             	shr    $0xc,%eax
  801d83:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801d8a:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801d8e:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801d95:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801d9c:	8b 45 90             	mov    -0x70(%ebp),%eax
  801d9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801da2:	72 d4                	jb     801d78 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801da4:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801daa:	e9 f8 00 00 00       	jmp    801ea7 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801daf:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801db6:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  801dbd:	10 00 00 
  801dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	48                   	dec    %eax
  801dcc:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  801dd2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801dd8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddd:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  801de3:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801de9:	29 d0                	sub    %edx,%eax
  801deb:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801dee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801df2:	74 09                	je     801dfd <malloc+0x8f6>
  801df4:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801dfb:	76 0a                	jbe    801e07 <malloc+0x900>
		return NULL;
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801e02:	e9 a0 00 00 00       	jmp    801ea7 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  801e07:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	01 d0                	add    %edx,%eax
  801e12:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801e17:	0f 87 87 00 00 00    	ja     801ea4 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  801e1d:	a1 04 30 80 00       	mov    0x803004,%eax
  801e22:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  801e25:	a1 04 30 80 00       	mov    0x803004,%eax
  801e2a:	83 ec 08             	sub    $0x8,%esp
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	50                   	push   %eax
  801e31:	e8 08 03 00 00       	call   80213e <sys_allocateMem>
  801e36:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e39:	a1 20 30 80 00       	mov    0x803020,%eax
  801e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e41:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801e48:	a1 20 30 80 00       	mov    0x803020,%eax
  801e4d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801e53:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801e5a:	a1 20 30 80 00       	mov    0x803020,%eax
  801e5f:	40                   	inc    %eax
  801e60:	a3 20 30 80 00       	mov    %eax,0x803020
		int i = 0;
  801e65:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  801e6c:	eb 2e                	jmp    801e9c <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801e6e:	a1 04 30 80 00       	mov    0x803004,%eax
  801e73:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e78:	c1 e8 0c             	shr    $0xc,%eax
  801e7b:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801e82:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  801e86:	a1 04 30 80 00       	mov    0x803004,%eax
  801e8b:	05 00 10 00 00       	add    $0x1000,%eax
  801e90:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  801e95:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  801e9c:	8b 45 88             	mov    -0x78(%ebp),%eax
  801e9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ea2:	72 ca                	jb     801e6e <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  801ea4:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  801eaf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  801eb6:	e9 c1 00 00 00       	jmp    801f7c <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  801ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebe:	8b 04 c5 40 30 88 00 	mov    0x883040(,%eax,8),%eax
  801ec5:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ec8:	0f 85 ab 00 00 00    	jne    801f79 <free+0xd0>

			if (heap_size[inx].size == 0) {
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	8b 04 c5 44 30 88 00 	mov    0x883044(,%eax,8),%eax
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	75 21                	jne    801efd <free+0x54>
				heap_size[inx].size = 0;
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801ee6:	00 00 00 00 
				heap_size[inx].vir = NULL;
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801ef4:	00 00 00 00 
				return;
  801ef8:	e9 8d 00 00 00       	jmp    801f8a <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  801efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f00:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	83 ec 08             	sub    $0x8,%esp
  801f0d:	52                   	push   %edx
  801f0e:	50                   	push   %eax
  801f0f:	e8 0e 02 00 00       	call   802122 <sys_freeMem>
  801f14:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  801f17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801f24:	eb 24                	jmp    801f4a <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  801f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f29:	05 00 00 00 80       	add    $0x80000000,%eax
  801f2e:	c1 e8 0c             	shr    $0xc,%eax
  801f31:	c7 04 85 40 30 80 00 	movl   $0x0,0x803040(,%eax,4)
  801f38:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  801f3c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801f43:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f57:	39 c2                	cmp    %eax,%edx
  801f59:	77 cb                	ja     801f26 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801f65:	00 00 00 00 
			heap_size[inx].vir = NULL;
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801f73:	00 00 00 00 
			break;
  801f77:	eb 11                	jmp    801f8a <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  801f79:	ff 45 f4             	incl   -0xc(%ebp)
  801f7c:	a1 20 30 80 00       	mov    0x803020,%eax
  801f81:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801f84:	0f 8c 31 ff ff ff    	jl     801ebb <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	68 d0 2c 80 00       	push   $0x802cd0
  801f9a:	68 1c 02 00 00       	push   $0x21c
  801f9f:	68 f6 2c 80 00       	push   $0x802cf6
  801fa4:	e8 b0 e6 ff ff       	call   800659 <_panic>

00801fa9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	57                   	push   %edi
  801fad:	56                   	push   %esi
  801fae:	53                   	push   %ebx
  801faf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fbb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fbe:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fc1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fc4:	cd 30                	int    $0x30
  801fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fcc:	83 c4 10             	add    $0x10,%esp
  801fcf:	5b                   	pop    %ebx
  801fd0:	5e                   	pop    %esi
  801fd1:	5f                   	pop    %edi
  801fd2:	5d                   	pop    %ebp
  801fd3:	c3                   	ret    

00801fd4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	ff 75 0c             	pushl  0xc(%ebp)
  801fe3:	50                   	push   %eax
  801fe4:	6a 00                	push   $0x0
  801fe6:	e8 be ff ff ff       	call   801fa9 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
}
  801fee:	90                   	nop
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 01                	push   $0x1
  802000:	e8 a4 ff ff ff       	call   801fa9 <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	50                   	push   %eax
  802019:	6a 03                	push   $0x3
  80201b:	e8 89 ff ff ff       	call   801fa9 <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 02                	push   $0x2
  802034:	e8 70 ff ff ff       	call   801fa9 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_env_exit>:

void sys_env_exit(void)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 04                	push   $0x4
  80204d:	e8 57 ff ff ff       	call   801fa9 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	90                   	nop
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80205b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	52                   	push   %edx
  802068:	50                   	push   %eax
  802069:	6a 05                	push   $0x5
  80206b:	e8 39 ff ff ff       	call   801fa9 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	56                   	push   %esi
  802079:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80207a:	8b 75 18             	mov    0x18(%ebp),%esi
  80207d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802080:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802083:	8b 55 0c             	mov    0xc(%ebp),%edx
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	56                   	push   %esi
  80208a:	53                   	push   %ebx
  80208b:	51                   	push   %ecx
  80208c:	52                   	push   %edx
  80208d:	50                   	push   %eax
  80208e:	6a 06                	push   $0x6
  802090:	e8 14 ff ff ff       	call   801fa9 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5e                   	pop    %esi
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    

0080209f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	52                   	push   %edx
  8020af:	50                   	push   %eax
  8020b0:	6a 07                	push   $0x7
  8020b2:	e8 f2 fe ff ff       	call   801fa9 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	ff 75 0c             	pushl  0xc(%ebp)
  8020c8:	ff 75 08             	pushl  0x8(%ebp)
  8020cb:	6a 08                	push   $0x8
  8020cd:	e8 d7 fe ff ff       	call   801fa9 <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 09                	push   $0x9
  8020e6:	e8 be fe ff ff       	call   801fa9 <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 0a                	push   $0xa
  8020ff:	e8 a5 fe ff ff       	call   801fa9 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 0b                	push   $0xb
  802118:	e8 8c fe ff ff       	call   801fa9 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	ff 75 0c             	pushl  0xc(%ebp)
  80212e:	ff 75 08             	pushl  0x8(%ebp)
  802131:	6a 0d                	push   $0xd
  802133:	e8 71 fe ff ff       	call   801fa9 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
	return;
  80213b:	90                   	nop
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	6a 0e                	push   $0xe
  80214f:	e8 55 fe ff ff       	call   801fa9 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
	return ;
  802157:	90                   	nop
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 0c                	push   $0xc
  802169:	e8 3b fe ff ff       	call   801fa9 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 10                	push   $0x10
  802182:	e8 22 fe ff ff       	call   801fa9 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	90                   	nop
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 11                	push   $0x11
  80219c:	e8 08 fe ff ff       	call   801fa9 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	90                   	nop
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 04             	sub    $0x4,%esp
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021b3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	50                   	push   %eax
  8021c0:	6a 12                	push   $0x12
  8021c2:	e8 e2 fd ff ff       	call   801fa9 <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
}
  8021ca:	90                   	nop
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 13                	push   $0x13
  8021dc:	e8 c8 fd ff ff       	call   801fa9 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	90                   	nop
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	ff 75 0c             	pushl  0xc(%ebp)
  8021f6:	50                   	push   %eax
  8021f7:	6a 14                	push   $0x14
  8021f9:	e8 ab fd ff ff       	call   801fa9 <syscall>
  8021fe:	83 c4 18             	add    $0x18,%esp
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	50                   	push   %eax
  802212:	6a 17                	push   $0x17
  802214:	e8 90 fd ff ff       	call   801fa9 <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	50                   	push   %eax
  80222d:	6a 15                	push   $0x15
  80222f:	e8 75 fd ff ff       	call   801fa9 <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
}
  802237:	90                   	nop
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	50                   	push   %eax
  802249:	6a 16                	push   $0x16
  80224b:	e8 59 fd ff ff       	call   801fa9 <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	90                   	nop
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	8b 45 10             	mov    0x10(%ebp),%eax
  80225f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802262:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802265:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	6a 00                	push   $0x0
  80226e:	51                   	push   %ecx
  80226f:	52                   	push   %edx
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	50                   	push   %eax
  802274:	6a 18                	push   $0x18
  802276:	e8 2e fd ff ff       	call   801fa9 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802283:	8b 55 0c             	mov    0xc(%ebp),%edx
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	52                   	push   %edx
  802290:	50                   	push   %eax
  802291:	6a 19                	push   $0x19
  802293:	e8 11 fd ff ff       	call   801fa9 <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	50                   	push   %eax
  8022ac:	6a 1a                	push   $0x1a
  8022ae:	e8 f6 fc ff ff       	call   801fa9 <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 1b                	push   $0x1b
  8022c7:	e8 dd fc ff ff       	call   801fa9 <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 1c                	push   $0x1c
  8022e0:	e8 c4 fc ff ff       	call   801fa9 <syscall>
  8022e5:	83 c4 18             	add    $0x18,%esp
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	ff 75 0c             	pushl  0xc(%ebp)
  8022f9:	50                   	push   %eax
  8022fa:	6a 1d                	push   $0x1d
  8022fc:	e8 a8 fc ff ff       	call   801fa9 <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	50                   	push   %eax
  802315:	6a 1e                	push   $0x1e
  802317:	e8 8d fc ff ff       	call   801fa9 <syscall>
  80231c:	83 c4 18             	add    $0x18,%esp
}
  80231f:	90                   	nop
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	50                   	push   %eax
  802331:	6a 1f                	push   $0x1f
  802333:	e8 71 fc ff ff       	call   801fa9 <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
}
  80233b:	90                   	nop
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802344:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802347:	8d 50 04             	lea    0x4(%eax),%edx
  80234a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	52                   	push   %edx
  802354:	50                   	push   %eax
  802355:	6a 20                	push   $0x20
  802357:	e8 4d fc ff ff       	call   801fa9 <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
	return result;
  80235f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802362:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802365:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802368:	89 01                	mov    %eax,(%ecx)
  80236a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	c9                   	leave  
  802371:	c2 04 00             	ret    $0x4

00802374 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	ff 75 10             	pushl  0x10(%ebp)
  80237e:	ff 75 0c             	pushl  0xc(%ebp)
  802381:	ff 75 08             	pushl  0x8(%ebp)
  802384:	6a 0f                	push   $0xf
  802386:	e8 1e fc ff ff       	call   801fa9 <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
	return ;
  80238e:	90                   	nop
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <sys_rcr2>:
uint32 sys_rcr2()
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 21                	push   $0x21
  8023a0:	e8 04 fc ff ff       	call   801fa9 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023b6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	50                   	push   %eax
  8023c3:	6a 22                	push   $0x22
  8023c5:	e8 df fb ff ff       	call   801fa9 <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8023cd:	90                   	nop
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <rsttst>:
void rsttst()
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 24                	push   $0x24
  8023df:	e8 c5 fb ff ff       	call   801fa9 <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e7:	90                   	nop
}
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023f6:	8b 55 18             	mov    0x18(%ebp),%edx
  8023f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023fd:	52                   	push   %edx
  8023fe:	50                   	push   %eax
  8023ff:	ff 75 10             	pushl  0x10(%ebp)
  802402:	ff 75 0c             	pushl  0xc(%ebp)
  802405:	ff 75 08             	pushl  0x8(%ebp)
  802408:	6a 23                	push   $0x23
  80240a:	e8 9a fb ff ff       	call   801fa9 <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
	return ;
  802412:	90                   	nop
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <chktst>:
void chktst(uint32 n)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	ff 75 08             	pushl  0x8(%ebp)
  802423:	6a 25                	push   $0x25
  802425:	e8 7f fb ff ff       	call   801fa9 <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
	return ;
  80242d:	90                   	nop
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 26                	push   $0x26
  802442:	e8 62 fb ff ff       	call   801fa9 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
  80244a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80244d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802451:	75 07                	jne    80245a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802453:	b8 01 00 00 00       	mov    $0x1,%eax
  802458:	eb 05                	jmp    80245f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 26                	push   $0x26
  802473:	e8 31 fb ff ff       	call   801fa9 <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
  80247b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80247e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802482:	75 07                	jne    80248b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802484:	b8 01 00 00 00       	mov    $0x1,%eax
  802489:	eb 05                	jmp    802490 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 26                	push   $0x26
  8024a4:	e8 00 fb ff ff       	call   801fa9 <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
  8024ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024af:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024b3:	75 07                	jne    8024bc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ba:	eb 05                	jmp    8024c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 26                	push   $0x26
  8024d5:	e8 cf fa ff ff       	call   801fa9 <syscall>
  8024da:	83 c4 18             	add    $0x18,%esp
  8024dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024e0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024e4:	75 07                	jne    8024ed <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024eb:	eb 05                	jmp    8024f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	ff 75 08             	pushl  0x8(%ebp)
  802502:	6a 27                	push   $0x27
  802504:	e8 a0 fa ff ff       	call   801fa9 <syscall>
  802509:	83 c4 18             	add    $0x18,%esp
	return ;
  80250c:	90                   	nop
}
  80250d:	c9                   	leave  
  80250e:	c3                   	ret    
  80250f:	90                   	nop

00802510 <__udivdi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 1c             	sub    $0x1c,%esp
  802517:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80251b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80251f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802523:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802527:	89 ca                	mov    %ecx,%edx
  802529:	89 f8                	mov    %edi,%eax
  80252b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80252f:	85 f6                	test   %esi,%esi
  802531:	75 2d                	jne    802560 <__udivdi3+0x50>
  802533:	39 cf                	cmp    %ecx,%edi
  802535:	77 65                	ja     80259c <__udivdi3+0x8c>
  802537:	89 fd                	mov    %edi,%ebp
  802539:	85 ff                	test   %edi,%edi
  80253b:	75 0b                	jne    802548 <__udivdi3+0x38>
  80253d:	b8 01 00 00 00       	mov    $0x1,%eax
  802542:	31 d2                	xor    %edx,%edx
  802544:	f7 f7                	div    %edi
  802546:	89 c5                	mov    %eax,%ebp
  802548:	31 d2                	xor    %edx,%edx
  80254a:	89 c8                	mov    %ecx,%eax
  80254c:	f7 f5                	div    %ebp
  80254e:	89 c1                	mov    %eax,%ecx
  802550:	89 d8                	mov    %ebx,%eax
  802552:	f7 f5                	div    %ebp
  802554:	89 cf                	mov    %ecx,%edi
  802556:	89 fa                	mov    %edi,%edx
  802558:	83 c4 1c             	add    $0x1c,%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5e                   	pop    %esi
  80255d:	5f                   	pop    %edi
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    
  802560:	39 ce                	cmp    %ecx,%esi
  802562:	77 28                	ja     80258c <__udivdi3+0x7c>
  802564:	0f bd fe             	bsr    %esi,%edi
  802567:	83 f7 1f             	xor    $0x1f,%edi
  80256a:	75 40                	jne    8025ac <__udivdi3+0x9c>
  80256c:	39 ce                	cmp    %ecx,%esi
  80256e:	72 0a                	jb     80257a <__udivdi3+0x6a>
  802570:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802574:	0f 87 9e 00 00 00    	ja     802618 <__udivdi3+0x108>
  80257a:	b8 01 00 00 00       	mov    $0x1,%eax
  80257f:	89 fa                	mov    %edi,%edx
  802581:	83 c4 1c             	add    $0x1c,%esp
  802584:	5b                   	pop    %ebx
  802585:	5e                   	pop    %esi
  802586:	5f                   	pop    %edi
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    
  802589:	8d 76 00             	lea    0x0(%esi),%esi
  80258c:	31 ff                	xor    %edi,%edi
  80258e:	31 c0                	xor    %eax,%eax
  802590:	89 fa                	mov    %edi,%edx
  802592:	83 c4 1c             	add    $0x1c,%esp
  802595:	5b                   	pop    %ebx
  802596:	5e                   	pop    %esi
  802597:	5f                   	pop    %edi
  802598:	5d                   	pop    %ebp
  802599:	c3                   	ret    
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	89 d8                	mov    %ebx,%eax
  80259e:	f7 f7                	div    %edi
  8025a0:	31 ff                	xor    %edi,%edi
  8025a2:	89 fa                	mov    %edi,%edx
  8025a4:	83 c4 1c             	add    $0x1c,%esp
  8025a7:	5b                   	pop    %ebx
  8025a8:	5e                   	pop    %esi
  8025a9:	5f                   	pop    %edi
  8025aa:	5d                   	pop    %ebp
  8025ab:	c3                   	ret    
  8025ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025b1:	89 eb                	mov    %ebp,%ebx
  8025b3:	29 fb                	sub    %edi,%ebx
  8025b5:	89 f9                	mov    %edi,%ecx
  8025b7:	d3 e6                	shl    %cl,%esi
  8025b9:	89 c5                	mov    %eax,%ebp
  8025bb:	88 d9                	mov    %bl,%cl
  8025bd:	d3 ed                	shr    %cl,%ebp
  8025bf:	89 e9                	mov    %ebp,%ecx
  8025c1:	09 f1                	or     %esi,%ecx
  8025c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025c7:	89 f9                	mov    %edi,%ecx
  8025c9:	d3 e0                	shl    %cl,%eax
  8025cb:	89 c5                	mov    %eax,%ebp
  8025cd:	89 d6                	mov    %edx,%esi
  8025cf:	88 d9                	mov    %bl,%cl
  8025d1:	d3 ee                	shr    %cl,%esi
  8025d3:	89 f9                	mov    %edi,%ecx
  8025d5:	d3 e2                	shl    %cl,%edx
  8025d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025db:	88 d9                	mov    %bl,%cl
  8025dd:	d3 e8                	shr    %cl,%eax
  8025df:	09 c2                	or     %eax,%edx
  8025e1:	89 d0                	mov    %edx,%eax
  8025e3:	89 f2                	mov    %esi,%edx
  8025e5:	f7 74 24 0c          	divl   0xc(%esp)
  8025e9:	89 d6                	mov    %edx,%esi
  8025eb:	89 c3                	mov    %eax,%ebx
  8025ed:	f7 e5                	mul    %ebp
  8025ef:	39 d6                	cmp    %edx,%esi
  8025f1:	72 19                	jb     80260c <__udivdi3+0xfc>
  8025f3:	74 0b                	je     802600 <__udivdi3+0xf0>
  8025f5:	89 d8                	mov    %ebx,%eax
  8025f7:	31 ff                	xor    %edi,%edi
  8025f9:	e9 58 ff ff ff       	jmp    802556 <__udivdi3+0x46>
  8025fe:	66 90                	xchg   %ax,%ax
  802600:	8b 54 24 08          	mov    0x8(%esp),%edx
  802604:	89 f9                	mov    %edi,%ecx
  802606:	d3 e2                	shl    %cl,%edx
  802608:	39 c2                	cmp    %eax,%edx
  80260a:	73 e9                	jae    8025f5 <__udivdi3+0xe5>
  80260c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80260f:	31 ff                	xor    %edi,%edi
  802611:	e9 40 ff ff ff       	jmp    802556 <__udivdi3+0x46>
  802616:	66 90                	xchg   %ax,%ax
  802618:	31 c0                	xor    %eax,%eax
  80261a:	e9 37 ff ff ff       	jmp    802556 <__udivdi3+0x46>
  80261f:	90                   	nop

00802620 <__umoddi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	53                   	push   %ebx
  802624:	83 ec 1c             	sub    $0x1c,%esp
  802627:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80262b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80262f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802633:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802637:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80263b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80263f:	89 f3                	mov    %esi,%ebx
  802641:	89 fa                	mov    %edi,%edx
  802643:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802647:	89 34 24             	mov    %esi,(%esp)
  80264a:	85 c0                	test   %eax,%eax
  80264c:	75 1a                	jne    802668 <__umoddi3+0x48>
  80264e:	39 f7                	cmp    %esi,%edi
  802650:	0f 86 a2 00 00 00    	jbe    8026f8 <__umoddi3+0xd8>
  802656:	89 c8                	mov    %ecx,%eax
  802658:	89 f2                	mov    %esi,%edx
  80265a:	f7 f7                	div    %edi
  80265c:	89 d0                	mov    %edx,%eax
  80265e:	31 d2                	xor    %edx,%edx
  802660:	83 c4 1c             	add    $0x1c,%esp
  802663:	5b                   	pop    %ebx
  802664:	5e                   	pop    %esi
  802665:	5f                   	pop    %edi
  802666:	5d                   	pop    %ebp
  802667:	c3                   	ret    
  802668:	39 f0                	cmp    %esi,%eax
  80266a:	0f 87 ac 00 00 00    	ja     80271c <__umoddi3+0xfc>
  802670:	0f bd e8             	bsr    %eax,%ebp
  802673:	83 f5 1f             	xor    $0x1f,%ebp
  802676:	0f 84 ac 00 00 00    	je     802728 <__umoddi3+0x108>
  80267c:	bf 20 00 00 00       	mov    $0x20,%edi
  802681:	29 ef                	sub    %ebp,%edi
  802683:	89 fe                	mov    %edi,%esi
  802685:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802689:	89 e9                	mov    %ebp,%ecx
  80268b:	d3 e0                	shl    %cl,%eax
  80268d:	89 d7                	mov    %edx,%edi
  80268f:	89 f1                	mov    %esi,%ecx
  802691:	d3 ef                	shr    %cl,%edi
  802693:	09 c7                	or     %eax,%edi
  802695:	89 e9                	mov    %ebp,%ecx
  802697:	d3 e2                	shl    %cl,%edx
  802699:	89 14 24             	mov    %edx,(%esp)
  80269c:	89 d8                	mov    %ebx,%eax
  80269e:	d3 e0                	shl    %cl,%eax
  8026a0:	89 c2                	mov    %eax,%edx
  8026a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026a6:	d3 e0                	shl    %cl,%eax
  8026a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026b0:	89 f1                	mov    %esi,%ecx
  8026b2:	d3 e8                	shr    %cl,%eax
  8026b4:	09 d0                	or     %edx,%eax
  8026b6:	d3 eb                	shr    %cl,%ebx
  8026b8:	89 da                	mov    %ebx,%edx
  8026ba:	f7 f7                	div    %edi
  8026bc:	89 d3                	mov    %edx,%ebx
  8026be:	f7 24 24             	mull   (%esp)
  8026c1:	89 c6                	mov    %eax,%esi
  8026c3:	89 d1                	mov    %edx,%ecx
  8026c5:	39 d3                	cmp    %edx,%ebx
  8026c7:	0f 82 87 00 00 00    	jb     802754 <__umoddi3+0x134>
  8026cd:	0f 84 91 00 00 00    	je     802764 <__umoddi3+0x144>
  8026d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026d7:	29 f2                	sub    %esi,%edx
  8026d9:	19 cb                	sbb    %ecx,%ebx
  8026db:	89 d8                	mov    %ebx,%eax
  8026dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026e1:	d3 e0                	shl    %cl,%eax
  8026e3:	89 e9                	mov    %ebp,%ecx
  8026e5:	d3 ea                	shr    %cl,%edx
  8026e7:	09 d0                	or     %edx,%eax
  8026e9:	89 e9                	mov    %ebp,%ecx
  8026eb:	d3 eb                	shr    %cl,%ebx
  8026ed:	89 da                	mov    %ebx,%edx
  8026ef:	83 c4 1c             	add    $0x1c,%esp
  8026f2:	5b                   	pop    %ebx
  8026f3:	5e                   	pop    %esi
  8026f4:	5f                   	pop    %edi
  8026f5:	5d                   	pop    %ebp
  8026f6:	c3                   	ret    
  8026f7:	90                   	nop
  8026f8:	89 fd                	mov    %edi,%ebp
  8026fa:	85 ff                	test   %edi,%edi
  8026fc:	75 0b                	jne    802709 <__umoddi3+0xe9>
  8026fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802703:	31 d2                	xor    %edx,%edx
  802705:	f7 f7                	div    %edi
  802707:	89 c5                	mov    %eax,%ebp
  802709:	89 f0                	mov    %esi,%eax
  80270b:	31 d2                	xor    %edx,%edx
  80270d:	f7 f5                	div    %ebp
  80270f:	89 c8                	mov    %ecx,%eax
  802711:	f7 f5                	div    %ebp
  802713:	89 d0                	mov    %edx,%eax
  802715:	e9 44 ff ff ff       	jmp    80265e <__umoddi3+0x3e>
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	89 c8                	mov    %ecx,%eax
  80271e:	89 f2                	mov    %esi,%edx
  802720:	83 c4 1c             	add    $0x1c,%esp
  802723:	5b                   	pop    %ebx
  802724:	5e                   	pop    %esi
  802725:	5f                   	pop    %edi
  802726:	5d                   	pop    %ebp
  802727:	c3                   	ret    
  802728:	3b 04 24             	cmp    (%esp),%eax
  80272b:	72 06                	jb     802733 <__umoddi3+0x113>
  80272d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802731:	77 0f                	ja     802742 <__umoddi3+0x122>
  802733:	89 f2                	mov    %esi,%edx
  802735:	29 f9                	sub    %edi,%ecx
  802737:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80273b:	89 14 24             	mov    %edx,(%esp)
  80273e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802742:	8b 44 24 04          	mov    0x4(%esp),%eax
  802746:	8b 14 24             	mov    (%esp),%edx
  802749:	83 c4 1c             	add    $0x1c,%esp
  80274c:	5b                   	pop    %ebx
  80274d:	5e                   	pop    %esi
  80274e:	5f                   	pop    %edi
  80274f:	5d                   	pop    %ebp
  802750:	c3                   	ret    
  802751:	8d 76 00             	lea    0x0(%esi),%esi
  802754:	2b 04 24             	sub    (%esp),%eax
  802757:	19 fa                	sbb    %edi,%edx
  802759:	89 d1                	mov    %edx,%ecx
  80275b:	89 c6                	mov    %eax,%esi
  80275d:	e9 71 ff ff ff       	jmp    8026d3 <__umoddi3+0xb3>
  802762:	66 90                	xchg   %ax,%ax
  802764:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802768:	72 ea                	jb     802754 <__umoddi3+0x134>
  80276a:	89 d9                	mov    %ebx,%ecx
  80276c:	e9 62 ff ff ff       	jmp    8026d3 <__umoddi3+0xb3>
