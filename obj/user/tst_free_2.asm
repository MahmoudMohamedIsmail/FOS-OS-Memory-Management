
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 72 09 00 00       	call   8009a8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp
	int envID = sys_getenvid();
  800042:	e8 ee 23 00 00       	call   802435 <sys_getenvid>
  800047:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  80004a:	83 ec 0c             	sub    $0xc,%esp
  80004d:	6a 03                	push   $0x3
  80004f:	e8 66 27 00 00       	call   8027ba <sys_bypassPageFault>
  800054:	83 c4 10             	add    $0x10,%esp


	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800057:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	c1 e0 03             	shl    $0x3,%eax
  80005f:	01 d0                	add    %edx,%eax
  800061:	01 c0                	add    %eax,%eax
  800063:	01 d0                	add    %edx,%eax
  800065:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800076:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int Mega = 1024*1024;
  800079:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  800080:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  800087:	e8 5b 24 00 00       	call   8024e7 <sys_calculate_free_frames>
  80008c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  80008f:	8d 55 80             	lea    -0x80(%ebp),%edx
  800092:	b9 14 00 00 00       	mov    $0x14,%ecx
  800097:	b8 00 00 00 00       	mov    $0x0,%eax
  80009c:	89 d7                	mov    %edx,%edi
  80009e:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000a0:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  8000a6:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	89 d7                	mov    %edx,%edi
  8000b2:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000b4:	e8 2e 24 00 00       	call   8024e7 <sys_calculate_free_frames>
  8000b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000bc:	e8 a9 24 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8000c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c7:	01 c0                	add    %eax,%eax
  8000c9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 42 18 00 00       	call   801917 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8000db:	8b 45 80             	mov    -0x80(%ebp),%eax
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	78 14                	js     8000f6 <_main+0xbe>
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	68 a0 2b 80 00       	push   $0x802ba0
  8000ea:	6a 1e                	push   $0x1e
  8000ec:	68 05 2c 80 00       	push   $0x802c05
  8000f1:	e8 73 09 00 00       	call   800a69 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8000f6:	e8 6f 24 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8000fb:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000fe:	3d 00 02 00 00       	cmp    $0x200,%eax
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 18 2c 80 00       	push   $0x802c18
  80010d:	6a 1f                	push   $0x1f
  80010f:	68 05 2c 80 00       	push   $0x802c05
  800114:	e8 50 09 00 00       	call   800a69 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800119:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800121:	48                   	dec    %eax
  800122:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800128:	e8 ba 23 00 00       	call   8024e7 <sys_calculate_free_frames>
  80012d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800130:	e8 35 24 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800135:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800138:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80013b:	01 c0                	add    %eax,%eax
  80013d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	50                   	push   %eax
  800144:	e8 ce 17 00 00       	call   801917 <malloc>
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80014f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800152:	89 c2                	mov    %eax,%edx
  800154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800157:	01 c0                	add    %eax,%eax
  800159:	05 00 00 00 80       	add    $0x80000000,%eax
  80015e:	39 c2                	cmp    %eax,%edx
  800160:	73 14                	jae    800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 a0 2b 80 00       	push   $0x802ba0
  80016a:	6a 26                	push   $0x26
  80016c:	68 05 2c 80 00       	push   $0x802c05
  800171:	e8 f3 08 00 00       	call   800a69 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800176:	e8 ef 23 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  80017b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017e:	3d 00 02 00 00       	cmp    $0x200,%eax
  800183:	74 14                	je     800199 <_main+0x161>
  800185:	83 ec 04             	sub    $0x4,%esp
  800188:	68 18 2c 80 00       	push   $0x802c18
  80018d:	6a 27                	push   $0x27
  80018f:	68 05 2c 80 00       	push   $0x802c05
  800194:	e8 d0 08 00 00       	call   800a69 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	01 c0                	add    %eax,%eax
  80019e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001a1:	48                   	dec    %eax
  8001a2:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001a8:	e8 3a 23 00 00       	call   8024e7 <sys_calculate_free_frames>
  8001ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b0:	e8 b5 23 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001bb:	01 c0                	add    %eax,%eax
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	50                   	push   %eax
  8001c1:	e8 51 17 00 00       	call   801917 <malloc>
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8001cc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001cf:	89 c2                	mov    %eax,%edx
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	c1 e0 02             	shl    $0x2,%eax
  8001d7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001dc:	39 c2                	cmp    %eax,%edx
  8001de:	73 14                	jae    8001f4 <_main+0x1bc>
  8001e0:	83 ec 04             	sub    $0x4,%esp
  8001e3:	68 a0 2b 80 00       	push   $0x802ba0
  8001e8:	6a 2e                	push   $0x2e
  8001ea:	68 05 2c 80 00       	push   $0x802c05
  8001ef:	e8 75 08 00 00       	call   800a69 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  8001f4:	e8 71 23 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8001f9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8001fc:	83 f8 01             	cmp    $0x1,%eax
  8001ff:	74 14                	je     800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 18 2c 80 00       	push   $0x802c18
  800209:	6a 2f                	push   $0x2f
  80020b:	68 05 2c 80 00       	push   $0x802c05
  800210:	e8 54 08 00 00       	call   800a69 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  800215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800218:	01 c0                	add    %eax,%eax
  80021a:	48                   	dec    %eax
  80021b:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800221:	e8 c1 22 00 00       	call   8024e7 <sys_calculate_free_frames>
  800226:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800229:	e8 3c 23 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  80022e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800234:	01 c0                	add    %eax,%eax
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	50                   	push   %eax
  80023a:	e8 d8 16 00 00       	call   801917 <malloc>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800245:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800248:	89 c2                	mov    %eax,%edx
  80024a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80024d:	c1 e0 02             	shl    $0x2,%eax
  800250:	89 c1                	mov    %eax,%ecx
  800252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800255:	c1 e0 02             	shl    $0x2,%eax
  800258:	01 c8                	add    %ecx,%eax
  80025a:	05 00 00 00 80       	add    $0x80000000,%eax
  80025f:	39 c2                	cmp    %eax,%edx
  800261:	73 14                	jae    800277 <_main+0x23f>
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	68 a0 2b 80 00       	push   $0x802ba0
  80026b:	6a 36                	push   $0x36
  80026d:	68 05 2c 80 00       	push   $0x802c05
  800272:	e8 f2 07 00 00       	call   800a69 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800277:	e8 ee 22 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  80027c:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80027f:	83 f8 01             	cmp    $0x1,%eax
  800282:	74 14                	je     800298 <_main+0x260>
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	68 18 2c 80 00       	push   $0x802c18
  80028c:	6a 37                	push   $0x37
  80028e:	68 05 2c 80 00       	push   $0x802c05
  800293:	e8 d1 07 00 00       	call   800a69 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  800298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80029b:	01 c0                	add    %eax,%eax
  80029d:	48                   	dec    %eax
  80029e:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002a4:	e8 3e 22 00 00       	call   8024e7 <sys_calculate_free_frames>
  8002a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ac:	e8 b9 22 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8002b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b7:	89 d0                	mov    %edx,%eax
  8002b9:	01 c0                	add    %eax,%eax
  8002bb:	01 d0                	add    %edx,%eax
  8002bd:	01 c0                	add    %eax,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	50                   	push   %eax
  8002c5:	e8 4d 16 00 00       	call   801917 <malloc>
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002d0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002d3:	89 c2                	mov    %eax,%edx
  8002d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d8:	c1 e0 02             	shl    $0x2,%eax
  8002db:	89 c1                	mov    %eax,%ecx
  8002dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002e0:	c1 e0 03             	shl    $0x3,%eax
  8002e3:	01 c8                	add    %ecx,%eax
  8002e5:	05 00 00 00 80       	add    $0x80000000,%eax
  8002ea:	39 c2                	cmp    %eax,%edx
  8002ec:	73 14                	jae    800302 <_main+0x2ca>
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	68 a0 2b 80 00       	push   $0x802ba0
  8002f6:	6a 3e                	push   $0x3e
  8002f8:	68 05 2c 80 00       	push   $0x802c05
  8002fd:	e8 67 07 00 00       	call   800a69 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800302:	e8 63 22 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800307:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80030a:	83 f8 02             	cmp    $0x2,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 18 2c 80 00       	push   $0x802c18
  800317:	6a 3f                	push   $0x3f
  800319:	68 05 2c 80 00       	push   $0x802c05
  80031e:	e8 46 07 00 00       	call   800a69 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800323:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800326:	89 d0                	mov    %edx,%eax
  800328:	01 c0                	add    %eax,%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	01 c0                	add    %eax,%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	48                   	dec    %eax
  800331:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 ab 21 00 00       	call   8024e7 <sys_calculate_free_frames>
  80033c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80033f:	e8 26 22 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	89 c2                	mov    %eax,%edx
  80034c:	01 d2                	add    %edx,%edx
  80034e:	01 d0                	add    %edx,%eax
  800350:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	50                   	push   %eax
  800357:	e8 bb 15 00 00       	call   801917 <malloc>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800362:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800365:	89 c2                	mov    %eax,%edx
  800367:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80036a:	c1 e0 02             	shl    $0x2,%eax
  80036d:	89 c1                	mov    %eax,%ecx
  80036f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800372:	c1 e0 04             	shl    $0x4,%eax
  800375:	01 c8                	add    %ecx,%eax
  800377:	05 00 00 00 80       	add    $0x80000000,%eax
  80037c:	39 c2                	cmp    %eax,%edx
  80037e:	73 14                	jae    800394 <_main+0x35c>
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	68 a0 2b 80 00       	push   $0x802ba0
  800388:	6a 46                	push   $0x46
  80038a:	68 05 2c 80 00       	push   $0x802c05
  80038f:	e8 d5 06 00 00       	call   800a69 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800394:	e8 d1 21 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800399:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80039c:	89 c2                	mov    %eax,%edx
  80039e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a1:	89 c1                	mov    %eax,%ecx
  8003a3:	01 c9                	add    %ecx,%ecx
  8003a5:	01 c8                	add    %ecx,%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	79 05                	jns    8003b0 <_main+0x378>
  8003ab:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003b0:	c1 f8 0c             	sar    $0xc,%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 18 2c 80 00       	push   $0x802c18
  8003bf:	6a 47                	push   $0x47
  8003c1:	68 05 2c 80 00       	push   $0x802c05
  8003c6:	e8 9e 06 00 00       	call   800a69 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ce:	89 c2                	mov    %eax,%edx
  8003d0:	01 d2                	add    %edx,%edx
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003d7:	48                   	dec    %eax
  8003d8:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8003de:	e8 04 21 00 00       	call   8024e7 <sys_calculate_free_frames>
  8003e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e6:	e8 7f 21 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8003eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8003ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003f1:	01 c0                	add    %eax,%eax
  8003f3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003f6:	83 ec 0c             	sub    $0xc,%esp
  8003f9:	50                   	push   %eax
  8003fa:	e8 18 15 00 00       	call   801917 <malloc>
  8003ff:	83 c4 10             	add    $0x10,%esp
  800402:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800405:	8b 45 98             	mov    -0x68(%ebp),%eax
  800408:	89 c1                	mov    %eax,%ecx
  80040a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80040d:	89 d0                	mov    %edx,%eax
  80040f:	01 c0                	add    %eax,%eax
  800411:	01 d0                	add    %edx,%eax
  800413:	01 c0                	add    %eax,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	89 c2                	mov    %eax,%edx
  800419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041c:	c1 e0 04             	shl    $0x4,%eax
  80041f:	01 d0                	add    %edx,%eax
  800421:	05 00 00 00 80       	add    $0x80000000,%eax
  800426:	39 c1                	cmp    %eax,%ecx
  800428:	73 14                	jae    80043e <_main+0x406>
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	68 a0 2b 80 00       	push   $0x802ba0
  800432:	6a 4e                	push   $0x4e
  800434:	68 05 2c 80 00       	push   $0x802c05
  800439:	e8 2b 06 00 00       	call   800a69 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80043e:	e8 27 21 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800443:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800446:	3d 00 02 00 00       	cmp    $0x200,%eax
  80044b:	74 14                	je     800461 <_main+0x429>
  80044d:	83 ec 04             	sub    $0x4,%esp
  800450:	68 18 2c 80 00       	push   $0x802c18
  800455:	6a 4f                	push   $0x4f
  800457:	68 05 2c 80 00       	push   $0x802c05
  80045c:	e8 08 06 00 00       	call   800a69 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800461:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800469:	48                   	dec    %eax
  80046a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  800470:	e8 72 20 00 00       	call   8024e7 <sys_calculate_free_frames>
  800475:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800478:	e8 ed 20 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  80047d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800480:	8b 45 80             	mov    -0x80(%ebp),%eax
  800483:	83 ec 0c             	sub    $0xc,%esp
  800486:	50                   	push   %eax
  800487:	e8 2d 1e 00 00       	call   8022b9 <free>
  80048c:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80048f:	e8 d6 20 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800494:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800497:	29 c2                	sub    %eax,%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	3d 00 02 00 00       	cmp    $0x200,%eax
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 48 2c 80 00       	push   $0x802c48
  8004aa:	6a 5c                	push   $0x5c
  8004ac:	68 05 2c 80 00       	push   $0x802c05
  8004b1:	e8 b3 05 00 00       	call   800a69 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004b6:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004bf:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004c2:	e8 da 22 00 00       	call   8027a1 <sys_rcr2>
  8004c7:	89 c2                	mov    %eax,%edx
  8004c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cc:	39 c2                	cmp    %eax,%edx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 84 2c 80 00       	push   $0x802c84
  8004d8:	6a 60                	push   $0x60
  8004da:	68 05 2c 80 00       	push   $0x802c05
  8004df:	e8 85 05 00 00       	call   800a69 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004e4:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004ea:	89 c2                	mov    %eax,%edx
  8004ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004f4:	e8 a8 22 00 00       	call   8027a1 <sys_rcr2>
  8004f9:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8004ff:	89 d1                	mov    %edx,%ecx
  800501:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800504:	01 ca                	add    %ecx,%edx
  800506:	39 d0                	cmp    %edx,%eax
  800508:	74 14                	je     80051e <_main+0x4e6>
  80050a:	83 ec 04             	sub    $0x4,%esp
  80050d:	68 84 2c 80 00       	push   $0x802c84
  800512:	6a 62                	push   $0x62
  800514:	68 05 2c 80 00       	push   $0x802c05
  800519:	e8 4b 05 00 00       	call   800a69 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80051e:	e8 c4 1f 00 00       	call   8024e7 <sys_calculate_free_frames>
  800523:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800526:	e8 3f 20 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  80052b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  80052e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800531:	83 ec 0c             	sub    $0xc,%esp
  800534:	50                   	push   %eax
  800535:	e8 7f 1d 00 00       	call   8022b9 <free>
  80053a:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80053d:	e8 28 20 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800542:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800545:	29 c2                	sub    %eax,%edx
  800547:	89 d0                	mov    %edx,%eax
  800549:	3d 00 02 00 00       	cmp    $0x200,%eax
  80054e:	74 14                	je     800564 <_main+0x52c>
  800550:	83 ec 04             	sub    $0x4,%esp
  800553:	68 48 2c 80 00       	push   $0x802c48
  800558:	6a 67                	push   $0x67
  80055a:	68 05 2c 80 00       	push   $0x802c05
  80055f:	e8 05 05 00 00       	call   800a69 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800564:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800567:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80056a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056d:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800570:	e8 2c 22 00 00       	call   8027a1 <sys_rcr2>
  800575:	89 c2                	mov    %eax,%edx
  800577:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80057a:	39 c2                	cmp    %eax,%edx
  80057c:	74 14                	je     800592 <_main+0x55a>
  80057e:	83 ec 04             	sub    $0x4,%esp
  800581:	68 84 2c 80 00       	push   $0x802c84
  800586:	6a 6b                	push   $0x6b
  800588:	68 05 2c 80 00       	push   $0x802c05
  80058d:	e8 d7 04 00 00       	call   800a69 <_panic>
		byteArr[lastIndices[1]] = 10;
  800592:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800598:	89 c2                	mov    %eax,%edx
  80059a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a2:	e8 fa 21 00 00       	call   8027a1 <sys_rcr2>
  8005a7:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ad:	89 d1                	mov    %edx,%ecx
  8005af:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b2:	01 ca                	add    %ecx,%edx
  8005b4:	39 d0                	cmp    %edx,%eax
  8005b6:	74 14                	je     8005cc <_main+0x594>
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 84 2c 80 00       	push   $0x802c84
  8005c0:	6a 6d                	push   $0x6d
  8005c2:	68 05 2c 80 00       	push   $0x802c05
  8005c7:	e8 9d 04 00 00       	call   800a69 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cc:	e8 16 1f 00 00       	call   8024e7 <sys_calculate_free_frames>
  8005d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d4:	e8 91 1f 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8005d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005dc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005df:	83 ec 0c             	sub    $0xc,%esp
  8005e2:	50                   	push   %eax
  8005e3:	e8 d1 1c 00 00       	call   8022b9 <free>
  8005e8:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005eb:	e8 7a 1f 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8005f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f3:	29 c2                	sub    %eax,%edx
  8005f5:	89 d0                	mov    %edx,%eax
  8005f7:	83 f8 01             	cmp    $0x1,%eax
  8005fa:	74 14                	je     800610 <_main+0x5d8>
  8005fc:	83 ec 04             	sub    $0x4,%esp
  8005ff:	68 48 2c 80 00       	push   $0x802c48
  800604:	6a 72                	push   $0x72
  800606:	68 05 2c 80 00       	push   $0x802c05
  80060b:	e8 59 04 00 00       	call   800a69 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  800610:	8b 45 88             	mov    -0x78(%ebp),%eax
  800613:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800616:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800619:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80061c:	e8 80 21 00 00       	call   8027a1 <sys_rcr2>
  800621:	89 c2                	mov    %eax,%edx
  800623:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800626:	39 c2                	cmp    %eax,%edx
  800628:	74 14                	je     80063e <_main+0x606>
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	68 84 2c 80 00       	push   $0x802c84
  800632:	6a 76                	push   $0x76
  800634:	68 05 2c 80 00       	push   $0x802c05
  800639:	e8 2b 04 00 00       	call   800a69 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800644:	89 c2                	mov    %eax,%edx
  800646:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800649:	01 d0                	add    %edx,%eax
  80064b:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064e:	e8 4e 21 00 00       	call   8027a1 <sys_rcr2>
  800653:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800659:	89 d1                	mov    %edx,%ecx
  80065b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065e:	01 ca                	add    %ecx,%edx
  800660:	39 d0                	cmp    %edx,%eax
  800662:	74 14                	je     800678 <_main+0x640>
  800664:	83 ec 04             	sub    $0x4,%esp
  800667:	68 84 2c 80 00       	push   $0x802c84
  80066c:	6a 78                	push   $0x78
  80066e:	68 05 2c 80 00       	push   $0x802c05
  800673:	e8 f1 03 00 00       	call   800a69 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800678:	e8 6a 1e 00 00       	call   8024e7 <sys_calculate_free_frames>
  80067d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800680:	e8 e5 1e 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800685:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800688:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068b:	83 ec 0c             	sub    $0xc,%esp
  80068e:	50                   	push   %eax
  80068f:	e8 25 1c 00 00       	call   8022b9 <free>
  800694:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  800697:	e8 ce 1e 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  80069c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80069f:	29 c2                	sub    %eax,%edx
  8006a1:	89 d0                	mov    %edx,%eax
  8006a3:	83 f8 01             	cmp    $0x1,%eax
  8006a6:	74 14                	je     8006bc <_main+0x684>
  8006a8:	83 ec 04             	sub    $0x4,%esp
  8006ab:	68 48 2c 80 00       	push   $0x802c48
  8006b0:	6a 7d                	push   $0x7d
  8006b2:	68 05 2c 80 00       	push   $0x802c05
  8006b7:	e8 ad 03 00 00       	call   800a69 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006bc:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c8:	e8 d4 20 00 00       	call   8027a1 <sys_rcr2>
  8006cd:	89 c2                	mov    %eax,%edx
  8006cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d2:	39 c2                	cmp    %eax,%edx
  8006d4:	74 17                	je     8006ed <_main+0x6b5>
  8006d6:	83 ec 04             	sub    $0x4,%esp
  8006d9:	68 84 2c 80 00       	push   $0x802c84
  8006de:	68 81 00 00 00       	push   $0x81
  8006e3:	68 05 2c 80 00       	push   $0x802c05
  8006e8:	e8 7c 03 00 00       	call   800a69 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ed:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f8:	01 d0                	add    %edx,%eax
  8006fa:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fd:	e8 9f 20 00 00       	call   8027a1 <sys_rcr2>
  800702:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800708:	89 d1                	mov    %edx,%ecx
  80070a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070d:	01 ca                	add    %ecx,%edx
  80070f:	39 d0                	cmp    %edx,%eax
  800711:	74 17                	je     80072a <_main+0x6f2>
  800713:	83 ec 04             	sub    $0x4,%esp
  800716:	68 84 2c 80 00       	push   $0x802c84
  80071b:	68 83 00 00 00       	push   $0x83
  800720:	68 05 2c 80 00       	push   $0x802c05
  800725:	e8 3f 03 00 00       	call   800a69 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80072a:	e8 b8 1d 00 00       	call   8024e7 <sys_calculate_free_frames>
  80072f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800732:	e8 33 1e 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800737:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  80073a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073d:	83 ec 0c             	sub    $0xc,%esp
  800740:	50                   	push   %eax
  800741:	e8 73 1b 00 00       	call   8022b9 <free>
  800746:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
  800749:	e8 1c 1e 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  80074e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800751:	29 c2                	sub    %eax,%edx
  800753:	89 d0                	mov    %edx,%eax
  800755:	83 f8 02             	cmp    $0x2,%eax
  800758:	74 17                	je     800771 <_main+0x739>
  80075a:	83 ec 04             	sub    $0x4,%esp
  80075d:	68 48 2c 80 00       	push   $0x802c48
  800762:	68 88 00 00 00       	push   $0x88
  800767:	68 05 2c 80 00       	push   $0x802c05
  80076c:	e8 f8 02 00 00       	call   800a69 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800771:	8b 45 90             	mov    -0x70(%ebp),%eax
  800774:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800777:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077a:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80077d:	e8 1f 20 00 00       	call   8027a1 <sys_rcr2>
  800782:	89 c2                	mov    %eax,%edx
  800784:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800787:	39 c2                	cmp    %eax,%edx
  800789:	74 17                	je     8007a2 <_main+0x76a>
  80078b:	83 ec 04             	sub    $0x4,%esp
  80078e:	68 84 2c 80 00       	push   $0x802c84
  800793:	68 8c 00 00 00       	push   $0x8c
  800798:	68 05 2c 80 00       	push   $0x802c05
  80079d:	e8 c7 02 00 00       	call   800a69 <_panic>
		byteArr[lastIndices[4]] = 10;
  8007a2:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8007a8:	89 c2                	mov    %eax,%edx
  8007aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ad:	01 d0                	add    %edx,%eax
  8007af:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007b2:	e8 ea 1f 00 00       	call   8027a1 <sys_rcr2>
  8007b7:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007bd:	89 d1                	mov    %edx,%ecx
  8007bf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007c2:	01 ca                	add    %ecx,%edx
  8007c4:	39 d0                	cmp    %edx,%eax
  8007c6:	74 17                	je     8007df <_main+0x7a7>
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	68 84 2c 80 00       	push   $0x802c84
  8007d0:	68 8e 00 00 00       	push   $0x8e
  8007d5:	68 05 2c 80 00       	push   $0x802c05
  8007da:	e8 8a 02 00 00       	call   800a69 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007df:	e8 03 1d 00 00       	call   8024e7 <sys_calculate_free_frames>
  8007e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007e7:	e8 7e 1d 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8007ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007ef:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007f2:	83 ec 0c             	sub    $0xc,%esp
  8007f5:	50                   	push   %eax
  8007f6:	e8 be 1a 00 00       	call   8022b9 <free>
  8007fb:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/4096 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007fe:	e8 67 1d 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  800803:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800806:	89 d1                	mov    %edx,%ecx
  800808:	29 c1                	sub    %eax,%ecx
  80080a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080d:	89 c2                	mov    %eax,%edx
  80080f:	01 d2                	add    %edx,%edx
  800811:	01 d0                	add    %edx,%eax
  800813:	85 c0                	test   %eax,%eax
  800815:	79 05                	jns    80081c <_main+0x7e4>
  800817:	05 ff 0f 00 00       	add    $0xfff,%eax
  80081c:	c1 f8 0c             	sar    $0xc,%eax
  80081f:	39 c1                	cmp    %eax,%ecx
  800821:	74 17                	je     80083a <_main+0x802>
  800823:	83 ec 04             	sub    $0x4,%esp
  800826:	68 48 2c 80 00       	push   $0x802c48
  80082b:	68 93 00 00 00       	push   $0x93
  800830:	68 05 2c 80 00       	push   $0x802c05
  800835:	e8 2f 02 00 00       	call   800a69 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  80083a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80083d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800840:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800843:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800846:	e8 56 1f 00 00       	call   8027a1 <sys_rcr2>
  80084b:	89 c2                	mov    %eax,%edx
  80084d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800850:	39 c2                	cmp    %eax,%edx
  800852:	74 17                	je     80086b <_main+0x833>
  800854:	83 ec 04             	sub    $0x4,%esp
  800857:	68 84 2c 80 00       	push   $0x802c84
  80085c:	68 97 00 00 00       	push   $0x97
  800861:	68 05 2c 80 00       	push   $0x802c05
  800866:	e8 fe 01 00 00       	call   800a69 <_panic>
		byteArr[lastIndices[5]] = 10;
  80086b:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800871:	89 c2                	mov    %eax,%edx
  800873:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800876:	01 d0                	add    %edx,%eax
  800878:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80087b:	e8 21 1f 00 00       	call   8027a1 <sys_rcr2>
  800880:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800886:	89 d1                	mov    %edx,%ecx
  800888:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80088b:	01 ca                	add    %ecx,%edx
  80088d:	39 d0                	cmp    %edx,%eax
  80088f:	74 17                	je     8008a8 <_main+0x870>
  800891:	83 ec 04             	sub    $0x4,%esp
  800894:	68 84 2c 80 00       	push   $0x802c84
  800899:	68 99 00 00 00       	push   $0x99
  80089e:	68 05 2c 80 00       	push   $0x802c05
  8008a3:	e8 c1 01 00 00       	call   800a69 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8008a8:	e8 3a 1c 00 00       	call   8024e7 <sys_calculate_free_frames>
  8008ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b0:	e8 b5 1c 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8008b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  8008b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	50                   	push   %eax
  8008bf:	e8 f5 19 00 00       	call   8022b9 <free>
  8008c4:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008c7:	e8 9e 1c 00 00       	call   80256a <sys_pf_calculate_allocated_pages>
  8008cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008cf:	29 c2                	sub    %eax,%edx
  8008d1:	89 d0                	mov    %edx,%eax
  8008d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8008d8:	74 17                	je     8008f1 <_main+0x8b9>
  8008da:	83 ec 04             	sub    $0x4,%esp
  8008dd:	68 48 2c 80 00       	push   $0x802c48
  8008e2:	68 9e 00 00 00       	push   $0x9e
  8008e7:	68 05 2c 80 00       	push   $0x802c05
  8008ec:	e8 78 01 00 00       	call   800a69 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008f1:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008fa:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008fd:	e8 9f 1e 00 00       	call   8027a1 <sys_rcr2>
  800902:	89 c2                	mov    %eax,%edx
  800904:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800907:	39 c2                	cmp    %eax,%edx
  800909:	74 17                	je     800922 <_main+0x8ea>
  80090b:	83 ec 04             	sub    $0x4,%esp
  80090e:	68 84 2c 80 00       	push   $0x802c84
  800913:	68 a2 00 00 00       	push   $0xa2
  800918:	68 05 2c 80 00       	push   $0x802c05
  80091d:	e8 47 01 00 00       	call   800a69 <_panic>
		byteArr[lastIndices[6]] = 10;
  800922:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800928:	89 c2                	mov    %eax,%edx
  80092a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80092d:	01 d0                	add    %edx,%eax
  80092f:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800932:	e8 6a 1e 00 00       	call   8027a1 <sys_rcr2>
  800937:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80093d:	89 d1                	mov    %edx,%ecx
  80093f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800942:	01 ca                	add    %ecx,%edx
  800944:	39 d0                	cmp    %edx,%eax
  800946:	74 17                	je     80095f <_main+0x927>
  800948:	83 ec 04             	sub    $0x4,%esp
  80094b:	68 84 2c 80 00       	push   $0x802c84
  800950:	68 a4 00 00 00       	push   $0xa4
  800955:	68 05 2c 80 00       	push   $0x802c05
  80095a:	e8 0a 01 00 00       	call   800a69 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames() + 3) ) {panic("Wrong free: not all pages removed correctly at end");}
  80095f:	e8 83 1b 00 00       	call   8024e7 <sys_calculate_free_frames>
  800964:	8d 50 03             	lea    0x3(%eax),%edx
  800967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80096a:	39 c2                	cmp    %eax,%edx
  80096c:	74 17                	je     800985 <_main+0x94d>
  80096e:	83 ec 04             	sub    $0x4,%esp
  800971:	68 c8 2c 80 00       	push   $0x802cc8
  800976:	68 a6 00 00 00       	push   $0xa6
  80097b:	68 05 2c 80 00       	push   $0x802c05
  800980:	e8 e4 00 00 00       	call   800a69 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800985:	83 ec 0c             	sub    $0xc,%esp
  800988:	6a 00                	push   $0x0
  80098a:	e8 2b 1e 00 00       	call   8027ba <sys_bypassPageFault>
  80098f:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800992:	83 ec 0c             	sub    $0xc,%esp
  800995:	68 fc 2c 80 00       	push   $0x802cfc
  80099a:	e8 f5 01 00 00       	call   800b94 <cprintf>
  80099f:	83 c4 10             	add    $0x10,%esp

	return;
  8009a2:	90                   	nop
}
  8009a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009a6:	c9                   	leave  
  8009a7:	c3                   	ret    

008009a8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009b2:	7e 0a                	jle    8009be <libmain+0x16>
		binaryname = argv[0];
  8009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 0c             	pushl  0xc(%ebp)
  8009c4:	ff 75 08             	pushl  0x8(%ebp)
  8009c7:	e8 6c f6 ff ff       	call   800038 <_main>
  8009cc:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8009cf:	e8 61 1a 00 00       	call   802435 <sys_getenvid>
  8009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8009d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009da:	89 d0                	mov    %edx,%eax
  8009dc:	c1 e0 03             	shl    $0x3,%eax
  8009df:	01 d0                	add    %edx,%eax
  8009e1:	01 c0                	add    %eax,%eax
  8009e3:	01 d0                	add    %edx,%eax
  8009e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ec:	01 d0                	add    %edx,%eax
  8009ee:	c1 e0 03             	shl    $0x3,%eax
  8009f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8009f9:	e8 85 1b 00 00       	call   802583 <sys_disable_interrupt>
		cprintf("**************************************\n");
  8009fe:	83 ec 0c             	sub    $0xc,%esp
  800a01:	68 50 2d 80 00       	push   $0x802d50
  800a06:	e8 89 01 00 00       	call   800b94 <cprintf>
  800a0b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a11:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	50                   	push   %eax
  800a1b:	68 78 2d 80 00       	push   $0x802d78
  800a20:	e8 6f 01 00 00       	call   800b94 <cprintf>
  800a25:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 50 2d 80 00       	push   $0x802d50
  800a30:	e8 5f 01 00 00       	call   800b94 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a38:	e8 60 1b 00 00       	call   80259d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a3d:	e8 19 00 00 00       	call   800a5b <exit>
}
  800a42:	90                   	nop
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800a4b:	83 ec 0c             	sub    $0xc,%esp
  800a4e:	6a 00                	push   $0x0
  800a50:	e8 c5 19 00 00       	call   80241a <sys_env_destroy>
  800a55:	83 c4 10             	add    $0x10,%esp
}
  800a58:	90                   	nop
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <exit>:

void
exit(void)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800a61:	e8 e8 19 00 00       	call   80244e <sys_env_exit>
}
  800a66:	90                   	nop
  800a67:	c9                   	leave  
  800a68:	c3                   	ret    

00800a69 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a6f:	8d 45 10             	lea    0x10(%ebp),%eax
  800a72:	83 c0 04             	add    $0x4,%eax
  800a75:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800a78:	a1 50 40 98 00       	mov    0x984050,%eax
  800a7d:	85 c0                	test   %eax,%eax
  800a7f:	74 16                	je     800a97 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a81:	a1 50 40 98 00       	mov    0x984050,%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	50                   	push   %eax
  800a8a:	68 91 2d 80 00       	push   $0x802d91
  800a8f:	e8 00 01 00 00       	call   800b94 <cprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a97:	a1 00 40 80 00       	mov    0x804000,%eax
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	50                   	push   %eax
  800aa3:	68 96 2d 80 00       	push   $0x802d96
  800aa8:	e8 e7 00 00 00       	call   800b94 <cprintf>
  800aad:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	50                   	push   %eax
  800aba:	e8 7a 00 00 00       	call   800b39 <vcprintf>
  800abf:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800ac2:	83 ec 0c             	sub    $0xc,%esp
  800ac5:	68 b2 2d 80 00       	push   $0x802db2
  800aca:	e8 c5 00 00 00       	call   800b94 <cprintf>
  800acf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ad2:	e8 84 ff ff ff       	call   800a5b <exit>

	// should not return here
	while (1) ;
  800ad7:	eb fe                	jmp    800ad7 <_panic+0x6e>

00800ad9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae2:	8b 00                	mov    (%eax),%eax
  800ae4:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aea:	89 0a                	mov    %ecx,(%edx)
  800aec:	8b 55 08             	mov    0x8(%ebp),%edx
  800aef:	88 d1                	mov    %dl,%cl
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b02:	75 23                	jne    800b27 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	89 c2                	mov    %eax,%edx
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	83 c0 08             	add    $0x8,%eax
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	52                   	push   %edx
  800b15:	50                   	push   %eax
  800b16:	e8 c9 18 00 00       	call   8023e4 <sys_cputs>
  800b1b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	8b 40 04             	mov    0x4(%eax),%eax
  800b2d:	8d 50 01             	lea    0x1(%eax),%edx
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b36:	90                   	nop
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b42:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b49:	00 00 00 
	b.cnt = 0;
  800b4c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b53:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b62:	50                   	push   %eax
  800b63:	68 d9 0a 80 00       	push   $0x800ad9
  800b68:	e8 fa 01 00 00       	call   800d67 <vprintfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800b70:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	50                   	push   %eax
  800b7a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b80:	83 c0 08             	add    $0x8,%eax
  800b83:	50                   	push   %eax
  800b84:	e8 5b 18 00 00       	call   8023e4 <sys_cputs>
  800b89:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800b8c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b9a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	e8 8a ff ff ff       	call   800b39 <vcprintf>
  800baf:	83 c4 10             	add    $0x10,%esp
  800bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    

00800bba <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bc0:	e8 be 19 00 00       	call   802583 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc5:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd4:	50                   	push   %eax
  800bd5:	e8 5f ff ff ff       	call   800b39 <vcprintf>
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800be0:	e8 b8 19 00 00       	call   80259d <sys_enable_interrupt>
	return cnt;
  800be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	53                   	push   %ebx
  800bee:	83 ec 14             	sub    $0x14,%esp
  800bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bfd:	8b 45 18             	mov    0x18(%ebp),%eax
  800c00:	ba 00 00 00 00       	mov    $0x0,%edx
  800c05:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c08:	77 55                	ja     800c5f <printnum+0x75>
  800c0a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0d:	72 05                	jb     800c14 <printnum+0x2a>
  800c0f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c12:	77 4b                	ja     800c5f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c14:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c17:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c1a:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c22:	52                   	push   %edx
  800c23:	50                   	push   %eax
  800c24:	ff 75 f4             	pushl  -0xc(%ebp)
  800c27:	ff 75 f0             	pushl  -0x10(%ebp)
  800c2a:	e8 f1 1c 00 00       	call   802920 <__udivdi3>
  800c2f:	83 c4 10             	add    $0x10,%esp
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	ff 75 20             	pushl  0x20(%ebp)
  800c38:	53                   	push   %ebx
  800c39:	ff 75 18             	pushl  0x18(%ebp)
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	ff 75 08             	pushl  0x8(%ebp)
  800c44:	e8 a1 ff ff ff       	call   800bea <printnum>
  800c49:	83 c4 20             	add    $0x20,%esp
  800c4c:	eb 1a                	jmp    800c68 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c4e:	83 ec 08             	sub    $0x8,%esp
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	ff 75 20             	pushl  0x20(%ebp)
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5f:	ff 4d 1c             	decl   0x1c(%ebp)
  800c62:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c66:	7f e6                	jg     800c4e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c68:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c76:	53                   	push   %ebx
  800c77:	51                   	push   %ecx
  800c78:	52                   	push   %edx
  800c79:	50                   	push   %eax
  800c7a:	e8 b1 1d 00 00       	call   802a30 <__umoddi3>
  800c7f:	83 c4 10             	add    $0x10,%esp
  800c82:	05 d4 2f 80 00       	add    $0x802fd4,%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	0f be c0             	movsbl %al,%eax
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	50                   	push   %eax
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	ff d0                	call   *%eax
  800c98:	83 c4 10             	add    $0x10,%esp
}
  800c9b:	90                   	nop
  800c9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c9f:	c9                   	leave  
  800ca0:	c3                   	ret    

00800ca1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ca8:	7e 1c                	jle    800cc6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	8b 00                	mov    (%eax),%eax
  800caf:	8d 50 08             	lea    0x8(%eax),%edx
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	89 10                	mov    %edx,(%eax)
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	8b 00                	mov    (%eax),%eax
  800cbc:	83 e8 08             	sub    $0x8,%eax
  800cbf:	8b 50 04             	mov    0x4(%eax),%edx
  800cc2:	8b 00                	mov    (%eax),%eax
  800cc4:	eb 40                	jmp    800d06 <getuint+0x65>
	else if (lflag)
  800cc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cca:	74 1e                	je     800cea <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8b 00                	mov    (%eax),%eax
  800cd1:	8d 50 04             	lea    0x4(%eax),%edx
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 10                	mov    %edx,(%eax)
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	83 e8 04             	sub    $0x4,%eax
  800ce1:	8b 00                	mov    (%eax),%eax
  800ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce8:	eb 1c                	jmp    800d06 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	8d 50 04             	lea    0x4(%eax),%edx
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	89 10                	mov    %edx,(%eax)
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	83 e8 04             	sub    $0x4,%eax
  800cff:	8b 00                	mov    (%eax),%eax
  800d01:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d0b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d0f:	7e 1c                	jle    800d2d <getint+0x25>
		return va_arg(*ap, long long);
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	8d 50 08             	lea    0x8(%eax),%edx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 10                	mov    %edx,(%eax)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	83 e8 08             	sub    $0x8,%eax
  800d26:	8b 50 04             	mov    0x4(%eax),%edx
  800d29:	8b 00                	mov    (%eax),%eax
  800d2b:	eb 38                	jmp    800d65 <getint+0x5d>
	else if (lflag)
  800d2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d31:	74 1a                	je     800d4d <getint+0x45>
		return va_arg(*ap, long);
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8b 00                	mov    (%eax),%eax
  800d38:	8d 50 04             	lea    0x4(%eax),%edx
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	89 10                	mov    %edx,(%eax)
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	83 e8 04             	sub    $0x4,%eax
  800d48:	8b 00                	mov    (%eax),%eax
  800d4a:	99                   	cltd   
  800d4b:	eb 18                	jmp    800d65 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	8d 50 04             	lea    0x4(%eax),%edx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 10                	mov    %edx,(%eax)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	99                   	cltd   
}
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
  800d6c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6f:	eb 17                	jmp    800d88 <vprintfmt+0x21>
			if (ch == '\0')
  800d71:	85 db                	test   %ebx,%ebx
  800d73:	0f 84 af 03 00 00    	je     801128 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d79:	83 ec 08             	sub    $0x8,%esp
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	53                   	push   %ebx
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	ff d0                	call   *%eax
  800d85:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d88:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8b:	8d 50 01             	lea    0x1(%eax),%edx
  800d8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	0f b6 d8             	movzbl %al,%ebx
  800d96:	83 fb 25             	cmp    $0x25,%ebx
  800d99:	75 d6                	jne    800d71 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d9b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d9f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800da6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800db4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 01             	lea    0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 d8             	movzbl %al,%ebx
  800dc9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dcc:	83 f8 55             	cmp    $0x55,%eax
  800dcf:	0f 87 2b 03 00 00    	ja     801100 <vprintfmt+0x399>
  800dd5:	8b 04 85 f8 2f 80 00 	mov    0x802ff8(,%eax,4),%eax
  800ddc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800dde:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800de2:	eb d7                	jmp    800dbb <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800de4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800de8:	eb d1                	jmp    800dbb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800df1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df4:	89 d0                	mov    %edx,%eax
  800df6:	c1 e0 02             	shl    $0x2,%eax
  800df9:	01 d0                	add    %edx,%eax
  800dfb:	01 c0                	add    %eax,%eax
  800dfd:	01 d8                	add    %ebx,%eax
  800dff:	83 e8 30             	sub    $0x30,%eax
  800e02:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e05:	8b 45 10             	mov    0x10(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e0d:	83 fb 2f             	cmp    $0x2f,%ebx
  800e10:	7e 3e                	jle    800e50 <vprintfmt+0xe9>
  800e12:	83 fb 39             	cmp    $0x39,%ebx
  800e15:	7f 39                	jg     800e50 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e17:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e1a:	eb d5                	jmp    800df1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1f:	83 c0 04             	add    $0x4,%eax
  800e22:	89 45 14             	mov    %eax,0x14(%ebp)
  800e25:	8b 45 14             	mov    0x14(%ebp),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e30:	eb 1f                	jmp    800e51 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	79 83                	jns    800dbb <vprintfmt+0x54>
				width = 0;
  800e38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e3f:	e9 77 ff ff ff       	jmp    800dbb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e44:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e4b:	e9 6b ff ff ff       	jmp    800dbb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e50:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e55:	0f 89 60 ff ff ff    	jns    800dbb <vprintfmt+0x54>
				width = precision, precision = -1;
  800e5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e68:	e9 4e ff ff ff       	jmp    800dbb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e70:	e9 46 ff ff ff       	jmp    800dbb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e75:	8b 45 14             	mov    0x14(%ebp),%eax
  800e78:	83 c0 04             	add    $0x4,%eax
  800e7b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e81:	83 e8 04             	sub    $0x4,%eax
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	50                   	push   %eax
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	ff d0                	call   *%eax
  800e92:	83 c4 10             	add    $0x10,%esp
			break;
  800e95:	e9 89 02 00 00       	jmp    801123 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9d:	83 c0 04             	add    $0x4,%eax
  800ea0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea6:	83 e8 04             	sub    $0x4,%eax
  800ea9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800eab:	85 db                	test   %ebx,%ebx
  800ead:	79 02                	jns    800eb1 <vprintfmt+0x14a>
				err = -err;
  800eaf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eb1:	83 fb 64             	cmp    $0x64,%ebx
  800eb4:	7f 0b                	jg     800ec1 <vprintfmt+0x15a>
  800eb6:	8b 34 9d 40 2e 80 00 	mov    0x802e40(,%ebx,4),%esi
  800ebd:	85 f6                	test   %esi,%esi
  800ebf:	75 19                	jne    800eda <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ec1:	53                   	push   %ebx
  800ec2:	68 e5 2f 80 00       	push   $0x802fe5
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	ff 75 08             	pushl  0x8(%ebp)
  800ecd:	e8 5e 02 00 00       	call   801130 <printfmt>
  800ed2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed5:	e9 49 02 00 00       	jmp    801123 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800eda:	56                   	push   %esi
  800edb:	68 ee 2f 80 00       	push   $0x802fee
  800ee0:	ff 75 0c             	pushl  0xc(%ebp)
  800ee3:	ff 75 08             	pushl  0x8(%ebp)
  800ee6:	e8 45 02 00 00       	call   801130 <printfmt>
  800eeb:	83 c4 10             	add    $0x10,%esp
			break;
  800eee:	e9 30 02 00 00       	jmp    801123 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ef3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef6:	83 c0 04             	add    $0x4,%eax
  800ef9:	89 45 14             	mov    %eax,0x14(%ebp)
  800efc:	8b 45 14             	mov    0x14(%ebp),%eax
  800eff:	83 e8 04             	sub    $0x4,%eax
  800f02:	8b 30                	mov    (%eax),%esi
  800f04:	85 f6                	test   %esi,%esi
  800f06:	75 05                	jne    800f0d <vprintfmt+0x1a6>
				p = "(null)";
  800f08:	be f1 2f 80 00       	mov    $0x802ff1,%esi
			if (width > 0 && padc != '-')
  800f0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f11:	7e 6d                	jle    800f80 <vprintfmt+0x219>
  800f13:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f17:	74 67                	je     800f80 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1c:	83 ec 08             	sub    $0x8,%esp
  800f1f:	50                   	push   %eax
  800f20:	56                   	push   %esi
  800f21:	e8 0c 03 00 00       	call   801232 <strnlen>
  800f26:	83 c4 10             	add    $0x10,%esp
  800f29:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f2c:	eb 16                	jmp    800f44 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f2e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	50                   	push   %eax
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	ff d0                	call   *%eax
  800f3e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	ff 4d e4             	decl   -0x1c(%ebp)
  800f44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f48:	7f e4                	jg     800f2e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f4a:	eb 34                	jmp    800f80 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f50:	74 1c                	je     800f6e <vprintfmt+0x207>
  800f52:	83 fb 1f             	cmp    $0x1f,%ebx
  800f55:	7e 05                	jle    800f5c <vprintfmt+0x1f5>
  800f57:	83 fb 7e             	cmp    $0x7e,%ebx
  800f5a:	7e 12                	jle    800f6e <vprintfmt+0x207>
					putch('?', putdat);
  800f5c:	83 ec 08             	sub    $0x8,%esp
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	6a 3f                	push   $0x3f
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	ff d0                	call   *%eax
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	eb 0f                	jmp    800f7d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f6e:	83 ec 08             	sub    $0x8,%esp
  800f71:	ff 75 0c             	pushl  0xc(%ebp)
  800f74:	53                   	push   %ebx
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	ff d0                	call   *%eax
  800f7a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800f80:	89 f0                	mov    %esi,%eax
  800f82:	8d 70 01             	lea    0x1(%eax),%esi
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	0f be d8             	movsbl %al,%ebx
  800f8a:	85 db                	test   %ebx,%ebx
  800f8c:	74 24                	je     800fb2 <vprintfmt+0x24b>
  800f8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f92:	78 b8                	js     800f4c <vprintfmt+0x1e5>
  800f94:	ff 4d e0             	decl   -0x20(%ebp)
  800f97:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f9b:	79 af                	jns    800f4c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9d:	eb 13                	jmp    800fb2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 0c             	pushl  0xc(%ebp)
  800fa5:	6a 20                	push   $0x20
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	ff d0                	call   *%eax
  800fac:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800faf:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb6:	7f e7                	jg     800f9f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fb8:	e9 66 01 00 00       	jmp    801123 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc3:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc6:	50                   	push   %eax
  800fc7:	e8 3c fd ff ff       	call   800d08 <getint>
  800fcc:	83 c4 10             	add    $0x10,%esp
  800fcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fdb:	85 d2                	test   %edx,%edx
  800fdd:	79 23                	jns    801002 <vprintfmt+0x29b>
				putch('-', putdat);
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	ff 75 0c             	pushl  0xc(%ebp)
  800fe5:	6a 2d                	push   $0x2d
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	ff d0                	call   *%eax
  800fec:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	f7 d8                	neg    %eax
  800ff7:	83 d2 00             	adc    $0x0,%edx
  800ffa:	f7 da                	neg    %edx
  800ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801002:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801009:	e9 bc 00 00 00       	jmp    8010ca <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	ff 75 e8             	pushl  -0x18(%ebp)
  801014:	8d 45 14             	lea    0x14(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	e8 84 fc ff ff       	call   800ca1 <getuint>
  80101d:	83 c4 10             	add    $0x10,%esp
  801020:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801023:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801026:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102d:	e9 98 00 00 00       	jmp    8010ca <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801032:	83 ec 08             	sub    $0x8,%esp
  801035:	ff 75 0c             	pushl  0xc(%ebp)
  801038:	6a 58                	push   $0x58
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	ff d0                	call   *%eax
  80103f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801042:	83 ec 08             	sub    $0x8,%esp
  801045:	ff 75 0c             	pushl  0xc(%ebp)
  801048:	6a 58                	push   $0x58
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	ff d0                	call   *%eax
  80104f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801052:	83 ec 08             	sub    $0x8,%esp
  801055:	ff 75 0c             	pushl  0xc(%ebp)
  801058:	6a 58                	push   $0x58
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	ff d0                	call   *%eax
  80105f:	83 c4 10             	add    $0x10,%esp
			break;
  801062:	e9 bc 00 00 00       	jmp    801123 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801067:	83 ec 08             	sub    $0x8,%esp
  80106a:	ff 75 0c             	pushl  0xc(%ebp)
  80106d:	6a 30                	push   $0x30
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	ff d0                	call   *%eax
  801074:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801077:	83 ec 08             	sub    $0x8,%esp
  80107a:	ff 75 0c             	pushl  0xc(%ebp)
  80107d:	6a 78                	push   $0x78
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	ff d0                	call   *%eax
  801084:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801087:	8b 45 14             	mov    0x14(%ebp),%eax
  80108a:	83 c0 04             	add    $0x4,%eax
  80108d:	89 45 14             	mov    %eax,0x14(%ebp)
  801090:	8b 45 14             	mov    0x14(%ebp),%eax
  801093:	83 e8 04             	sub    $0x4,%eax
  801096:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010a2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010a9:	eb 1f                	jmp    8010ca <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010ab:	83 ec 08             	sub    $0x8,%esp
  8010ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8010b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b4:	50                   	push   %eax
  8010b5:	e8 e7 fb ff ff       	call   800ca1 <getuint>
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010c3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010ca:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	52                   	push   %edx
  8010d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d8:	50                   	push   %eax
  8010d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8010dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8010df:	ff 75 0c             	pushl  0xc(%ebp)
  8010e2:	ff 75 08             	pushl  0x8(%ebp)
  8010e5:	e8 00 fb ff ff       	call   800bea <printnum>
  8010ea:	83 c4 20             	add    $0x20,%esp
			break;
  8010ed:	eb 34                	jmp    801123 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ef:	83 ec 08             	sub    $0x8,%esp
  8010f2:	ff 75 0c             	pushl  0xc(%ebp)
  8010f5:	53                   	push   %ebx
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	ff d0                	call   *%eax
  8010fb:	83 c4 10             	add    $0x10,%esp
			break;
  8010fe:	eb 23                	jmp    801123 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801100:	83 ec 08             	sub    $0x8,%esp
  801103:	ff 75 0c             	pushl  0xc(%ebp)
  801106:	6a 25                	push   $0x25
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	ff d0                	call   *%eax
  80110d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801110:	ff 4d 10             	decl   0x10(%ebp)
  801113:	eb 03                	jmp    801118 <vprintfmt+0x3b1>
  801115:	ff 4d 10             	decl   0x10(%ebp)
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	48                   	dec    %eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	3c 25                	cmp    $0x25,%al
  801120:	75 f3                	jne    801115 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801122:	90                   	nop
		}
	}
  801123:	e9 47 fc ff ff       	jmp    800d6f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801128:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801129:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801136:	8d 45 10             	lea    0x10(%ebp),%eax
  801139:	83 c0 04             	add    $0x4,%eax
  80113c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80113f:	8b 45 10             	mov    0x10(%ebp),%eax
  801142:	ff 75 f4             	pushl  -0xc(%ebp)
  801145:	50                   	push   %eax
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	ff 75 08             	pushl  0x8(%ebp)
  80114c:	e8 16 fc ff ff       	call   800d67 <vprintfmt>
  801151:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801154:	90                   	nop
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80115a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115d:	8b 40 08             	mov    0x8(%eax),%eax
  801160:	8d 50 01             	lea    0x1(%eax),%edx
  801163:	8b 45 0c             	mov    0xc(%ebp),%eax
  801166:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116c:	8b 10                	mov    (%eax),%edx
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	8b 40 04             	mov    0x4(%eax),%eax
  801174:	39 c2                	cmp    %eax,%edx
  801176:	73 12                	jae    80118a <sprintputch+0x33>
		*b->buf++ = ch;
  801178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117b:	8b 00                	mov    (%eax),%eax
  80117d:	8d 48 01             	lea    0x1(%eax),%ecx
  801180:	8b 55 0c             	mov    0xc(%ebp),%edx
  801183:	89 0a                	mov    %ecx,(%edx)
  801185:	8b 55 08             	mov    0x8(%ebp),%edx
  801188:	88 10                	mov    %dl,(%eax)
}
  80118a:	90                   	nop
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	01 d0                	add    %edx,%eax
  8011a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b2:	74 06                	je     8011ba <vsnprintf+0x2d>
  8011b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b8:	7f 07                	jg     8011c1 <vsnprintf+0x34>
		return -E_INVAL;
  8011ba:	b8 03 00 00 00       	mov    $0x3,%eax
  8011bf:	eb 20                	jmp    8011e1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011c1:	ff 75 14             	pushl  0x14(%ebp)
  8011c4:	ff 75 10             	pushl  0x10(%ebp)
  8011c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011ca:	50                   	push   %eax
  8011cb:	68 57 11 80 00       	push   $0x801157
  8011d0:	e8 92 fb ff ff       	call   800d67 <vprintfmt>
  8011d5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011e9:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ec:	83 c0 04             	add    $0x4,%eax
  8011ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f8:	50                   	push   %eax
  8011f9:	ff 75 0c             	pushl  0xc(%ebp)
  8011fc:	ff 75 08             	pushl  0x8(%ebp)
  8011ff:	e8 89 ff ff ff       	call   80118d <vsnprintf>
  801204:	83 c4 10             	add    $0x10,%esp
  801207:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80120a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801215:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80121c:	eb 06                	jmp    801224 <strlen+0x15>
		n++;
  80121e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801221:	ff 45 08             	incl   0x8(%ebp)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	84 c0                	test   %al,%al
  80122b:	75 f1                	jne    80121e <strlen+0xf>
		n++;
	return n;
  80122d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801238:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80123f:	eb 09                	jmp    80124a <strnlen+0x18>
		n++;
  801241:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801244:	ff 45 08             	incl   0x8(%ebp)
  801247:	ff 4d 0c             	decl   0xc(%ebp)
  80124a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124e:	74 09                	je     801259 <strnlen+0x27>
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	84 c0                	test   %al,%al
  801257:	75 e8                	jne    801241 <strnlen+0xf>
		n++;
	return n;
  801259:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    

0080125e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80126a:	90                   	nop
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8d 50 01             	lea    0x1(%eax),%edx
  801271:	89 55 08             	mov    %edx,0x8(%ebp)
  801274:	8b 55 0c             	mov    0xc(%ebp),%edx
  801277:	8d 4a 01             	lea    0x1(%edx),%ecx
  80127a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80127d:	8a 12                	mov    (%edx),%dl
  80127f:	88 10                	mov    %dl,(%eax)
  801281:	8a 00                	mov    (%eax),%al
  801283:	84 c0                	test   %al,%al
  801285:	75 e4                	jne    80126b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801287:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80129f:	eb 1f                	jmp    8012c0 <strncpy+0x34>
		*dst++ = *src;
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8d 50 01             	lea    0x1(%eax),%edx
  8012a7:	89 55 08             	mov    %edx,0x8(%ebp)
  8012aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ad:	8a 12                	mov    (%edx),%dl
  8012af:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	74 03                	je     8012bd <strncpy+0x31>
			src++;
  8012ba:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012bd:	ff 45 fc             	incl   -0x4(%ebp)
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012c6:	72 d9                	jb     8012a1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dd:	74 30                	je     80130f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012df:	eb 16                	jmp    8012f7 <strlcpy+0x2a>
			*dst++ = *src++;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8d 50 01             	lea    0x1(%eax),%edx
  8012e7:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012f3:	8a 12                	mov    (%edx),%dl
  8012f5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012f7:	ff 4d 10             	decl   0x10(%ebp)
  8012fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012fe:	74 09                	je     801309 <strlcpy+0x3c>
  801300:	8b 45 0c             	mov    0xc(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	84 c0                	test   %al,%al
  801307:	75 d8                	jne    8012e1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
}
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80131e:	eb 06                	jmp    801326 <strcmp+0xb>
		p++, q++;
  801320:	ff 45 08             	incl   0x8(%ebp)
  801323:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 0e                	je     80133d <strcmp+0x22>
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8a 10                	mov    (%eax),%dl
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	38 c2                	cmp    %al,%dl
  80133b:	74 e3                	je     801320 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	0f b6 d0             	movzbl %al,%edx
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	8a 00                	mov    (%eax),%al
  80134a:	0f b6 c0             	movzbl %al,%eax
  80134d:	29 c2                	sub    %eax,%edx
  80134f:	89 d0                	mov    %edx,%eax
}
  801351:	5d                   	pop    %ebp
  801352:	c3                   	ret    

00801353 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801356:	eb 09                	jmp    801361 <strncmp+0xe>
		n--, p++, q++;
  801358:	ff 4d 10             	decl   0x10(%ebp)
  80135b:	ff 45 08             	incl   0x8(%ebp)
  80135e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801365:	74 17                	je     80137e <strncmp+0x2b>
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 0e                	je     80137e <strncmp+0x2b>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 10                	mov    (%eax),%dl
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8a 00                	mov    (%eax),%al
  80137a:	38 c2                	cmp    %al,%dl
  80137c:	74 da                	je     801358 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80137e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801382:	75 07                	jne    80138b <strncmp+0x38>
		return 0;
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
  801389:	eb 14                	jmp    80139f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	0f b6 d0             	movzbl %al,%edx
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	0f b6 c0             	movzbl %al,%eax
  80139b:	29 c2                	sub    %eax,%edx
  80139d:	89 d0                	mov    %edx,%eax
}
  80139f:	5d                   	pop    %ebp
  8013a0:	c3                   	ret    

008013a1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	83 ec 04             	sub    $0x4,%esp
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013ad:	eb 12                	jmp    8013c1 <strchr+0x20>
		if (*s == c)
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013b7:	75 05                	jne    8013be <strchr+0x1d>
			return (char *) s;
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	eb 11                	jmp    8013cf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013be:	ff 45 08             	incl   0x8(%ebp)
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	84 c0                	test   %al,%al
  8013c8:	75 e5                	jne    8013af <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013dd:	eb 0d                	jmp    8013ec <strfind+0x1b>
		if (*s == c)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013e7:	74 0e                	je     8013f7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013e9:	ff 45 08             	incl   0x8(%ebp)
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	84 c0                	test   %al,%al
  8013f3:	75 ea                	jne    8013df <strfind+0xe>
  8013f5:	eb 01                	jmp    8013f8 <strfind+0x27>
		if (*s == c)
			break;
  8013f7:	90                   	nop
	return (char *) s;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801409:	8b 45 10             	mov    0x10(%ebp),%eax
  80140c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80140f:	eb 0e                	jmp    80141f <memset+0x22>
		*p++ = c;
  801411:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801414:	8d 50 01             	lea    0x1(%eax),%edx
  801417:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80141a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80141f:	ff 4d f8             	decl   -0x8(%ebp)
  801422:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801426:	79 e9                	jns    801411 <memset+0x14>
		*p++ = c;

	return v;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80143f:	eb 16                	jmp    801457 <memcpy+0x2a>
		*d++ = *s++;
  801441:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801444:	8d 50 01             	lea    0x1(%eax),%edx
  801447:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80144a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801450:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801453:	8a 12                	mov    (%edx),%dl
  801455:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801457:	8b 45 10             	mov    0x10(%ebp),%eax
  80145a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80145d:	89 55 10             	mov    %edx,0x10(%ebp)
  801460:	85 c0                	test   %eax,%eax
  801462:	75 dd                	jne    801441 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  80146f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801472:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80147b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801481:	73 50                	jae    8014d3 <memmove+0x6a>
  801483:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801486:	8b 45 10             	mov    0x10(%ebp),%eax
  801489:	01 d0                	add    %edx,%eax
  80148b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80148e:	76 43                	jbe    8014d3 <memmove+0x6a>
		s += n;
  801490:	8b 45 10             	mov    0x10(%ebp),%eax
  801493:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801496:	8b 45 10             	mov    0x10(%ebp),%eax
  801499:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80149c:	eb 10                	jmp    8014ae <memmove+0x45>
			*--d = *--s;
  80149e:	ff 4d f8             	decl   -0x8(%ebp)
  8014a1:	ff 4d fc             	decl   -0x4(%ebp)
  8014a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a7:	8a 10                	mov    (%eax),%dl
  8014a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ac:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	75 e3                	jne    80149e <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014bb:	eb 23                	jmp    8014e0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014cf:	8a 12                	mov    (%edx),%dl
  8014d1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	75 dd                	jne    8014bd <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014f7:	eb 2a                	jmp    801523 <memcmp+0x3e>
		if (*s1 != *s2)
  8014f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fc:	8a 10                	mov    (%eax),%dl
  8014fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 16                	je     80151d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801507:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
  80151b:	eb 18                	jmp    801535 <memcmp+0x50>
		s1++, s2++;
  80151d:	ff 45 fc             	incl   -0x4(%ebp)
  801520:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801523:	8b 45 10             	mov    0x10(%ebp),%eax
  801526:	8d 50 ff             	lea    -0x1(%eax),%edx
  801529:	89 55 10             	mov    %edx,0x10(%ebp)
  80152c:	85 c0                	test   %eax,%eax
  80152e:	75 c9                	jne    8014f9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	8b 45 10             	mov    0x10(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801548:	eb 15                	jmp    80155f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	0f b6 d0             	movzbl %al,%edx
  801552:	8b 45 0c             	mov    0xc(%ebp),%eax
  801555:	0f b6 c0             	movzbl %al,%eax
  801558:	39 c2                	cmp    %eax,%edx
  80155a:	74 0d                	je     801569 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80155c:	ff 45 08             	incl   0x8(%ebp)
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801565:	72 e3                	jb     80154a <memfind+0x13>
  801567:	eb 01                	jmp    80156a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801569:	90                   	nop
	return (void *) s;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801575:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80157c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801583:	eb 03                	jmp    801588 <strtol+0x19>
		s++;
  801585:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8a 00                	mov    (%eax),%al
  80158d:	3c 20                	cmp    $0x20,%al
  80158f:	74 f4                	je     801585 <strtol+0x16>
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	8a 00                	mov    (%eax),%al
  801596:	3c 09                	cmp    $0x9,%al
  801598:	74 eb                	je     801585 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	3c 2b                	cmp    $0x2b,%al
  8015a1:	75 05                	jne    8015a8 <strtol+0x39>
		s++;
  8015a3:	ff 45 08             	incl   0x8(%ebp)
  8015a6:	eb 13                	jmp    8015bb <strtol+0x4c>
	else if (*s == '-')
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	3c 2d                	cmp    $0x2d,%al
  8015af:	75 0a                	jne    8015bb <strtol+0x4c>
		s++, neg = 1;
  8015b1:	ff 45 08             	incl   0x8(%ebp)
  8015b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015bf:	74 06                	je     8015c7 <strtol+0x58>
  8015c1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015c5:	75 20                	jne    8015e7 <strtol+0x78>
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	3c 30                	cmp    $0x30,%al
  8015ce:	75 17                	jne    8015e7 <strtol+0x78>
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	40                   	inc    %eax
  8015d4:	8a 00                	mov    (%eax),%al
  8015d6:	3c 78                	cmp    $0x78,%al
  8015d8:	75 0d                	jne    8015e7 <strtol+0x78>
		s += 2, base = 16;
  8015da:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015de:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015e5:	eb 28                	jmp    80160f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015eb:	75 15                	jne    801602 <strtol+0x93>
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	3c 30                	cmp    $0x30,%al
  8015f4:	75 0c                	jne    801602 <strtol+0x93>
		s++, base = 8;
  8015f6:	ff 45 08             	incl   0x8(%ebp)
  8015f9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801600:	eb 0d                	jmp    80160f <strtol+0xa0>
	else if (base == 0)
  801602:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801606:	75 07                	jne    80160f <strtol+0xa0>
		base = 10;
  801608:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	3c 2f                	cmp    $0x2f,%al
  801616:	7e 19                	jle    801631 <strtol+0xc2>
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	8a 00                	mov    (%eax),%al
  80161d:	3c 39                	cmp    $0x39,%al
  80161f:	7f 10                	jg     801631 <strtol+0xc2>
			dig = *s - '0';
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	0f be c0             	movsbl %al,%eax
  801629:	83 e8 30             	sub    $0x30,%eax
  80162c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80162f:	eb 42                	jmp    801673 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	3c 60                	cmp    $0x60,%al
  801638:	7e 19                	jle    801653 <strtol+0xe4>
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	8a 00                	mov    (%eax),%al
  80163f:	3c 7a                	cmp    $0x7a,%al
  801641:	7f 10                	jg     801653 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	0f be c0             	movsbl %al,%eax
  80164b:	83 e8 57             	sub    $0x57,%eax
  80164e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801651:	eb 20                	jmp    801673 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8a 00                	mov    (%eax),%al
  801658:	3c 40                	cmp    $0x40,%al
  80165a:	7e 39                	jle    801695 <strtol+0x126>
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8a 00                	mov    (%eax),%al
  801661:	3c 5a                	cmp    $0x5a,%al
  801663:	7f 30                	jg     801695 <strtol+0x126>
			dig = *s - 'A' + 10;
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	8a 00                	mov    (%eax),%al
  80166a:	0f be c0             	movsbl %al,%eax
  80166d:	83 e8 37             	sub    $0x37,%eax
  801670:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801676:	3b 45 10             	cmp    0x10(%ebp),%eax
  801679:	7d 19                	jge    801694 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80167b:	ff 45 08             	incl   0x8(%ebp)
  80167e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801681:	0f af 45 10          	imul   0x10(%ebp),%eax
  801685:	89 c2                	mov    %eax,%edx
  801687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168a:	01 d0                	add    %edx,%eax
  80168c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80168f:	e9 7b ff ff ff       	jmp    80160f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801694:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801695:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801699:	74 08                	je     8016a3 <strtol+0x134>
		*endptr = (char *) s;
  80169b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169e:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016a7:	74 07                	je     8016b0 <strtol+0x141>
  8016a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ac:	f7 d8                	neg    %eax
  8016ae:	eb 03                	jmp    8016b3 <strtol+0x144>
  8016b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <ltostr>:

void
ltostr(long value, char *str)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016cd:	79 13                	jns    8016e2 <ltostr+0x2d>
	{
		neg = 1;
  8016cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016dc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016df:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016ea:	99                   	cltd   
  8016eb:	f7 f9                	idiv   %ecx
  8016ed:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f3:	8d 50 01             	lea    0x1(%eax),%edx
  8016f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f9:	89 c2                	mov    %eax,%edx
  8016fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fe:	01 d0                	add    %edx,%eax
  801700:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801703:	83 c2 30             	add    $0x30,%edx
  801706:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801708:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801710:	f7 e9                	imul   %ecx
  801712:	c1 fa 02             	sar    $0x2,%edx
  801715:	89 c8                	mov    %ecx,%eax
  801717:	c1 f8 1f             	sar    $0x1f,%eax
  80171a:	29 c2                	sub    %eax,%edx
  80171c:	89 d0                	mov    %edx,%eax
  80171e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801721:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801724:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801729:	f7 e9                	imul   %ecx
  80172b:	c1 fa 02             	sar    $0x2,%edx
  80172e:	89 c8                	mov    %ecx,%eax
  801730:	c1 f8 1f             	sar    $0x1f,%eax
  801733:	29 c2                	sub    %eax,%edx
  801735:	89 d0                	mov    %edx,%eax
  801737:	c1 e0 02             	shl    $0x2,%eax
  80173a:	01 d0                	add    %edx,%eax
  80173c:	01 c0                	add    %eax,%eax
  80173e:	29 c1                	sub    %eax,%ecx
  801740:	89 ca                	mov    %ecx,%edx
  801742:	85 d2                	test   %edx,%edx
  801744:	75 9c                	jne    8016e2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801746:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80174d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801750:	48                   	dec    %eax
  801751:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801754:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801758:	74 3d                	je     801797 <ltostr+0xe2>
		start = 1 ;
  80175a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801761:	eb 34                	jmp    801797 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801766:	8b 45 0c             	mov    0xc(%ebp),%eax
  801769:	01 d0                	add    %edx,%eax
  80176b:	8a 00                	mov    (%eax),%al
  80176d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801770:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801773:	8b 45 0c             	mov    0xc(%ebp),%eax
  801776:	01 c2                	add    %eax,%edx
  801778:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	01 c8                	add    %ecx,%eax
  801780:	8a 00                	mov    (%eax),%al
  801782:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801784:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178a:	01 c2                	add    %eax,%edx
  80178c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80178f:	88 02                	mov    %al,(%edx)
		start++ ;
  801791:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801794:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80179d:	7c c4                	jl     801763 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80179f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	01 d0                	add    %edx,%eax
  8017a7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017aa:	90                   	nop
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	e8 54 fa ff ff       	call   80120f <strlen>
  8017bb:	83 c4 04             	add    $0x4,%esp
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017c1:	ff 75 0c             	pushl  0xc(%ebp)
  8017c4:	e8 46 fa ff ff       	call   80120f <strlen>
  8017c9:	83 c4 04             	add    $0x4,%esp
  8017cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017dd:	eb 17                	jmp    8017f6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e5:	01 c2                	add    %eax,%edx
  8017e7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	01 c8                	add    %ecx,%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017f3:	ff 45 fc             	incl   -0x4(%ebp)
  8017f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017fc:	7c e1                	jl     8017df <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801805:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80180c:	eb 1f                	jmp    80182d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80180e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801811:	8d 50 01             	lea    0x1(%eax),%edx
  801814:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801817:	89 c2                	mov    %eax,%edx
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	01 c2                	add    %eax,%edx
  80181e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	01 c8                	add    %ecx,%eax
  801826:	8a 00                	mov    (%eax),%al
  801828:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80182a:	ff 45 f8             	incl   -0x8(%ebp)
  80182d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801830:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801833:	7c d9                	jl     80180e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801835:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801838:	8b 45 10             	mov    0x10(%ebp),%eax
  80183b:	01 d0                	add    %edx,%eax
  80183d:	c6 00 00             	movb   $0x0,(%eax)
}
  801840:	90                   	nop
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	8b 00                	mov    (%eax),%eax
  801854:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80185b:	8b 45 10             	mov    0x10(%ebp),%eax
  80185e:	01 d0                	add    %edx,%eax
  801860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801866:	eb 0c                	jmp    801874 <strsplit+0x31>
			*string++ = 0;
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8d 50 01             	lea    0x1(%eax),%edx
  80186e:	89 55 08             	mov    %edx,0x8(%ebp)
  801871:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	8a 00                	mov    (%eax),%al
  801879:	84 c0                	test   %al,%al
  80187b:	74 18                	je     801895 <strsplit+0x52>
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	8a 00                	mov    (%eax),%al
  801882:	0f be c0             	movsbl %al,%eax
  801885:	50                   	push   %eax
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	e8 13 fb ff ff       	call   8013a1 <strchr>
  80188e:	83 c4 08             	add    $0x8,%esp
  801891:	85 c0                	test   %eax,%eax
  801893:	75 d3                	jne    801868 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	8a 00                	mov    (%eax),%al
  80189a:	84 c0                	test   %al,%al
  80189c:	74 5a                	je     8018f8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  80189e:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a1:	8b 00                	mov    (%eax),%eax
  8018a3:	83 f8 0f             	cmp    $0xf,%eax
  8018a6:	75 07                	jne    8018af <strsplit+0x6c>
		{
			return 0;
  8018a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ad:	eb 66                	jmp    801915 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018af:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	8d 48 01             	lea    0x1(%eax),%ecx
  8018b7:	8b 55 14             	mov    0x14(%ebp),%edx
  8018ba:	89 0a                	mov    %ecx,(%edx)
  8018bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c6:	01 c2                	add    %eax,%edx
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018cd:	eb 03                	jmp    8018d2 <strsplit+0x8f>
			string++;
  8018cf:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	8a 00                	mov    (%eax),%al
  8018d7:	84 c0                	test   %al,%al
  8018d9:	74 8b                	je     801866 <strsplit+0x23>
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	0f be c0             	movsbl %al,%eax
  8018e3:	50                   	push   %eax
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	e8 b5 fa ff ff       	call   8013a1 <strchr>
  8018ec:	83 c4 08             	add    $0x8,%esp
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	74 dc                	je     8018cf <strsplit+0x8c>
			string++;
	}
  8018f3:	e9 6e ff ff ff       	jmp    801866 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018f8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fc:	8b 00                	mov    (%eax),%eax
  8018fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801905:	8b 45 10             	mov    0x10(%ebp),%eax
  801908:	01 d0                	add    %edx,%eax
  80190a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801910:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801920:	e8 7d 0f 00 00       	call   8028a2 <sys_isUHeapPlacementStrategyNEXTFIT>
  801925:	85 c0                	test   %eax,%eax
  801927:	0f 84 6f 03 00 00    	je     801c9c <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  80192d:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801934:	8b 55 08             	mov    0x8(%ebp),%edx
  801937:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80193a:	01 d0                	add    %edx,%eax
  80193c:	48                   	dec    %eax
  80193d:	89 45 80             	mov    %eax,-0x80(%ebp)
  801940:	8b 45 80             	mov    -0x80(%ebp),%eax
  801943:	ba 00 00 00 00       	mov    $0x0,%edx
  801948:	f7 75 84             	divl   -0x7c(%ebp)
  80194b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80194e:	29 d0                	sub    %edx,%eax
  801950:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801953:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801957:	74 09                	je     801962 <malloc+0x4b>
  801959:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801960:	76 0a                	jbe    80196c <malloc+0x55>
			return NULL;
  801962:	b8 00 00 00 00       	mov    $0x0,%eax
  801967:	e9 4b 09 00 00       	jmp    8022b7 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  80196c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	01 d0                	add    %edx,%eax
  801977:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80197c:	0f 87 a2 00 00 00    	ja     801a24 <malloc+0x10d>
  801982:	a1 40 40 98 00       	mov    0x984040,%eax
  801987:	85 c0                	test   %eax,%eax
  801989:	0f 85 95 00 00 00    	jne    801a24 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  80198f:	a1 04 40 80 00       	mov    0x804004,%eax
  801994:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  80199a:	a1 04 40 80 00       	mov    0x804004,%eax
  80199f:	83 ec 08             	sub    $0x8,%esp
  8019a2:	ff 75 08             	pushl  0x8(%ebp)
  8019a5:	50                   	push   %eax
  8019a6:	e8 a3 0b 00 00       	call   80254e <sys_allocateMem>
  8019ab:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  8019ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8019b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b6:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8019bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8019c2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019c8:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  8019cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8019d4:	40                   	inc    %eax
  8019d5:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  8019da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8019e1:	eb 2e                	jmp    801a11 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8019e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8019e8:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8019ed:	c1 e8 0c             	shr    $0xc,%eax
  8019f0:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8019f7:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8019fb:	a1 04 40 80 00       	mov    0x804004,%eax
  801a00:	05 00 10 00 00       	add    $0x1000,%eax
  801a05:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801a0a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a14:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a17:	72 ca                	jb     8019e3 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801a19:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801a1f:	e9 93 08 00 00       	jmp    8022b7 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801a2b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801a32:	a1 40 40 98 00       	mov    0x984040,%eax
  801a37:	85 c0                	test   %eax,%eax
  801a39:	75 1d                	jne    801a58 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801a3b:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801a42:	00 00 80 
				check = 1;
  801a45:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  801a4c:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801a4f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801a56:	eb 08                	jmp    801a60 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801a58:	a1 04 40 80 00       	mov    0x804004,%eax
  801a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801a60:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801a67:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801a6e:	a1 04 40 80 00       	mov    0x804004,%eax
  801a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801a76:	eb 4d                	jmp    801ac5 <malloc+0x1ae>
				if (sz == size) {
  801a78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a7e:	75 09                	jne    801a89 <malloc+0x172>
					f = 1;
  801a80:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801a87:	eb 45                	jmp    801ace <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8c:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801a91:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801a94:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	75 10                	jne    801aaf <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801a9f:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801aa6:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801aad:	eb 16                	jmp    801ac5 <malloc+0x1ae>
				} else {
					sz = 0;
  801aaf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801ab6:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801abd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac0:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801ac5:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801acc:	76 aa                	jbe    801a78 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801ace:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ad2:	0f 84 95 00 00 00    	je     801b6d <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801ad8:	a1 04 40 80 00       	mov    0x804004,%eax
  801add:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801ae3:	a1 04 40 80 00       	mov    0x804004,%eax
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	ff 75 08             	pushl  0x8(%ebp)
  801aee:	50                   	push   %eax
  801aef:	e8 5a 0a 00 00       	call   80254e <sys_allocateMem>
  801af4:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801af7:	a1 20 40 80 00       	mov    0x804020,%eax
  801afc:	8b 55 08             	mov    0x8(%ebp),%edx
  801aff:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801b06:	a1 20 40 80 00       	mov    0x804020,%eax
  801b0b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b11:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  801b18:	a1 20 40 80 00       	mov    0x804020,%eax
  801b1d:	40                   	inc    %eax
  801b1e:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  801b23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b2a:	eb 2e                	jmp    801b5a <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801b2c:	a1 04 40 80 00       	mov    0x804004,%eax
  801b31:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801b36:	c1 e8 0c             	shr    $0xc,%eax
  801b39:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801b40:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801b44:	a1 04 40 80 00       	mov    0x804004,%eax
  801b49:	05 00 10 00 00       	add    $0x1000,%eax
  801b4e:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801b53:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801b5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b60:	72 ca                	jb     801b2c <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801b62:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801b68:	e9 4a 07 00 00       	jmp    8022b7 <malloc+0x9a0>

			} else {

				if (check_start) {
  801b6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b71:	74 0a                	je     801b7d <malloc+0x266>

					return NULL;
  801b73:	b8 00 00 00 00       	mov    $0x0,%eax
  801b78:	e9 3a 07 00 00       	jmp    8022b7 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801b7d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801b84:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801b8b:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801b92:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801b99:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801b9c:	eb 4d                	jmp    801beb <malloc+0x2d4>
					if (sz == size) {
  801b9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ba1:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ba4:	75 09                	jne    801baf <malloc+0x298>
						f = 1;
  801ba6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801bad:	eb 44                	jmp    801bf3 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801baf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bb2:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801bb7:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801bba:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	75 10                	jne    801bd5 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801bc5:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801bcc:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801bd3:	eb 16                	jmp    801beb <malloc+0x2d4>
					} else {
						sz = 0;
  801bd5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801bdc:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801be3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801be6:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bee:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801bf1:	72 ab                	jb     801b9e <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801bf3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801bf7:	0f 84 95 00 00 00    	je     801c92 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801bfd:	a1 04 40 80 00       	mov    0x804004,%eax
  801c02:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801c08:	a1 04 40 80 00       	mov    0x804004,%eax
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	ff 75 08             	pushl  0x8(%ebp)
  801c13:	50                   	push   %eax
  801c14:	e8 35 09 00 00       	call   80254e <sys_allocateMem>
  801c19:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801c1c:	a1 20 40 80 00       	mov    0x804020,%eax
  801c21:	8b 55 08             	mov    0x8(%ebp),%edx
  801c24:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801c2b:	a1 20 40 80 00       	mov    0x804020,%eax
  801c30:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c36:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  801c3d:	a1 20 40 80 00       	mov    0x804020,%eax
  801c42:	40                   	inc    %eax
  801c43:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  801c48:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801c4f:	eb 2e                	jmp    801c7f <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801c51:	a1 04 40 80 00       	mov    0x804004,%eax
  801c56:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801c5b:	c1 e8 0c             	shr    $0xc,%eax
  801c5e:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801c65:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801c69:	a1 04 40 80 00       	mov    0x804004,%eax
  801c6e:	05 00 10 00 00       	add    $0x1000,%eax
  801c73:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801c78:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801c7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c82:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c85:	72 ca                	jb     801c51 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801c87:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801c8d:	e9 25 06 00 00       	jmp    8022b7 <malloc+0x9a0>

				} else {

					return NULL;
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
  801c97:	e9 1b 06 00 00       	jmp    8022b7 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801c9c:	e8 d0 0b 00 00       	call   802871 <sys_isUHeapPlacementStrategyBESTFIT>
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	0f 84 ba 01 00 00    	je     801e63 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801ca9:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801cb0:	10 00 00 
  801cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb6:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801cbc:	01 d0                	add    %edx,%eax
  801cbe:	48                   	dec    %eax
  801cbf:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801cc5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd0:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801cd6:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801cdc:	29 d0                	sub    %edx,%eax
  801cde:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801ce1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ce5:	74 09                	je     801cf0 <malloc+0x3d9>
  801ce7:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801cee:	76 0a                	jbe    801cfa <malloc+0x3e3>
			return NULL;
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf5:	e9 bd 05 00 00       	jmp    8022b7 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801cfa:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801d01:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801d08:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801d0f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801d16:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	c1 e8 0c             	shr    $0xc,%eax
  801d23:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801d29:	e9 80 00 00 00       	jmp    801dae <malloc+0x497>

			if (heap_mem[i] == 0) {
  801d2e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d31:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	75 0c                	jne    801d48 <malloc+0x431>

				count++;
  801d3c:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801d3f:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801d46:	eb 2d                	jmp    801d75 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801d48:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801d4e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d51:	77 14                	ja     801d67 <malloc+0x450>
  801d53:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d56:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d59:	76 0c                	jbe    801d67 <malloc+0x450>

					min_sz = count;
  801d5b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d5e:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801d61:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d64:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801d67:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801d6e:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801d75:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801d7c:	75 2d                	jne    801dab <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801d7e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801d84:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d87:	77 22                	ja     801dab <malloc+0x494>
  801d89:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d8c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801d8f:	76 1a                	jbe    801dab <malloc+0x494>

					min_sz = count;
  801d91:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d94:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801d97:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801d9d:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801da4:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801dab:	ff 45 b8             	incl   -0x48(%ebp)
  801dae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801db1:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801db6:	0f 86 72 ff ff ff    	jbe    801d2e <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801dbc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801dc2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801dc5:	77 06                	ja     801dcd <malloc+0x4b6>
  801dc7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801dcb:	75 0a                	jne    801dd7 <malloc+0x4c0>
			return NULL;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	e9 e0 04 00 00       	jmp    8022b7 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801dd7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801dda:	c1 e0 0c             	shl    $0xc,%eax
  801ddd:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801de0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801de3:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801de9:	83 ec 08             	sub    $0x8,%esp
  801dec:	ff 75 08             	pushl  0x8(%ebp)
  801def:	ff 75 c4             	pushl  -0x3c(%ebp)
  801df2:	e8 57 07 00 00       	call   80254e <sys_allocateMem>
  801df7:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801dfa:	a1 20 40 80 00       	mov    0x804020,%eax
  801dff:	8b 55 08             	mov    0x8(%ebp),%edx
  801e02:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801e09:	a1 20 40 80 00       	mov    0x804020,%eax
  801e0e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801e11:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  801e18:	a1 20 40 80 00       	mov    0x804020,%eax
  801e1d:	40                   	inc    %eax
  801e1e:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  801e23:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e2a:	eb 24                	jmp    801e50 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801e2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e2f:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e34:	c1 e8 0c             	shr    $0xc,%eax
  801e37:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801e3e:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801e42:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801e49:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801e50:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e53:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e56:	72 d4                	jb     801e2c <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801e58:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801e5e:	e9 54 04 00 00       	jmp    8022b7 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801e63:	e8 d8 09 00 00       	call   802840 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	0f 84 88 01 00 00    	je     801ff8 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801e70:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801e77:	10 00 00 
  801e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  801e7d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801e83:	01 d0                	add    %edx,%eax
  801e85:	48                   	dec    %eax
  801e86:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801e8c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801e92:	ba 00 00 00 00       	mov    $0x0,%edx
  801e97:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801e9d:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801ea3:	29 d0                	sub    %edx,%eax
  801ea5:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801ea8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eac:	74 09                	je     801eb7 <malloc+0x5a0>
  801eae:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801eb5:	76 0a                	jbe    801ec1 <malloc+0x5aa>
			return NULL;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebc:	e9 f6 03 00 00       	jmp    8022b7 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801ec1:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801ec8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801ecf:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801ed6:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801edd:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	c1 e8 0c             	shr    $0xc,%eax
  801eea:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801ef0:	eb 5a                	jmp    801f4c <malloc+0x635>

			if (heap_mem[i] == 0) {
  801ef2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ef5:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801efc:	85 c0                	test   %eax,%eax
  801efe:	75 0c                	jne    801f0c <malloc+0x5f5>

				count++;
  801f00:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801f03:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801f0a:	eb 22                	jmp    801f2e <malloc+0x617>
			} else {
				if (num_p <= count) {
  801f0c:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801f12:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801f15:	77 09                	ja     801f20 <malloc+0x609>

					found = 1;
  801f17:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801f1e:	eb 36                	jmp    801f56 <malloc+0x63f>
				}
				count = 0;
  801f20:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801f27:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801f2e:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801f35:	75 12                	jne    801f49 <malloc+0x632>

				if (num_p <= count) {
  801f37:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801f3d:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801f40:	77 07                	ja     801f49 <malloc+0x632>

					found = 1;
  801f42:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801f49:	ff 45 a4             	incl   -0x5c(%ebp)
  801f4c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801f4f:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801f54:	76 9c                	jbe    801ef2 <malloc+0x5db>

			}

		}

		if (!found) {
  801f56:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801f5a:	75 0a                	jne    801f66 <malloc+0x64f>
			return NULL;
  801f5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f61:	e9 51 03 00 00       	jmp    8022b7 <malloc+0x9a0>

		}

		temp = ptr;
  801f66:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801f69:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801f6c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801f6f:	c1 e0 0c             	shl    $0xc,%eax
  801f72:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801f75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801f78:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801f7e:	83 ec 08             	sub    $0x8,%esp
  801f81:	ff 75 08             	pushl  0x8(%ebp)
  801f84:	ff 75 b0             	pushl  -0x50(%ebp)
  801f87:	e8 c2 05 00 00       	call   80254e <sys_allocateMem>
  801f8c:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801f8f:	a1 20 40 80 00       	mov    0x804020,%eax
  801f94:	8b 55 08             	mov    0x8(%ebp),%edx
  801f97:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801f9e:	a1 20 40 80 00       	mov    0x804020,%eax
  801fa3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801fa6:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  801fad:	a1 20 40 80 00       	mov    0x804020,%eax
  801fb2:	40                   	inc    %eax
  801fb3:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  801fb8:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801fbf:	eb 24                	jmp    801fe5 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801fc1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801fc4:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801fc9:	c1 e8 0c             	shr    $0xc,%eax
  801fcc:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801fd3:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801fd7:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801fde:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801fe5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801fe8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801feb:	72 d4                	jb     801fc1 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801fed:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801ff3:	e9 bf 02 00 00       	jmp    8022b7 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801ff8:	e8 d6 08 00 00       	call   8028d3 <sys_isUHeapPlacementStrategyWORSTFIT>
  801ffd:	85 c0                	test   %eax,%eax
  801fff:	0f 84 ba 01 00 00    	je     8021bf <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  802005:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  80200c:	10 00 00 
  80200f:	8b 55 08             	mov    0x8(%ebp),%edx
  802012:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802018:	01 d0                	add    %edx,%eax
  80201a:	48                   	dec    %eax
  80201b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802021:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802027:	ba 00 00 00 00       	mov    $0x0,%edx
  80202c:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802032:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802038:	29 d0                	sub    %edx,%eax
  80203a:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80203d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802041:	74 09                	je     80204c <malloc+0x735>
  802043:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80204a:	76 0a                	jbe    802056 <malloc+0x73f>
					return NULL;
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
  802051:	e9 61 02 00 00       	jmp    8022b7 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  802056:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  80205d:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  802064:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  80206b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  802072:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	c1 e8 0c             	shr    $0xc,%eax
  80207f:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802085:	e9 80 00 00 00       	jmp    80210a <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  80208a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80208d:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802094:	85 c0                	test   %eax,%eax
  802096:	75 0c                	jne    8020a4 <malloc+0x78d>

						count++;
  802098:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  80209b:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  8020a2:	eb 2d                	jmp    8020d1 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  8020a4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8020aa:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020ad:	77 14                	ja     8020c3 <malloc+0x7ac>
  8020af:	8b 45 98             	mov    -0x68(%ebp),%eax
  8020b2:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020b5:	73 0c                	jae    8020c3 <malloc+0x7ac>

							max_sz = count;
  8020b7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8020ba:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8020bd:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8020c0:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  8020c3:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  8020ca:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  8020d1:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  8020d8:	75 2d                	jne    802107 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  8020da:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8020e0:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020e3:	77 22                	ja     802107 <malloc+0x7f0>
  8020e5:	8b 45 98             	mov    -0x68(%ebp),%eax
  8020e8:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8020eb:	76 1a                	jbe    802107 <malloc+0x7f0>

							max_sz = count;
  8020ed:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8020f0:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8020f3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8020f6:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  8020f9:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  802100:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802107:	ff 45 90             	incl   -0x70(%ebp)
  80210a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80210d:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802112:	0f 86 72 ff ff ff    	jbe    80208a <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  802118:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80211e:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802121:	77 06                	ja     802129 <malloc+0x812>
  802123:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802127:	75 0a                	jne    802133 <malloc+0x81c>
					return NULL;
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
  80212e:	e9 84 01 00 00       	jmp    8022b7 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802133:	8b 45 98             	mov    -0x68(%ebp),%eax
  802136:	c1 e0 0c             	shl    $0xc,%eax
  802139:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  80213c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80213f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  802145:	83 ec 08             	sub    $0x8,%esp
  802148:	ff 75 08             	pushl  0x8(%ebp)
  80214b:	ff 75 9c             	pushl  -0x64(%ebp)
  80214e:	e8 fb 03 00 00       	call   80254e <sys_allocateMem>
  802153:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802156:	a1 20 40 80 00       	mov    0x804020,%eax
  80215b:	8b 55 08             	mov    0x8(%ebp),%edx
  80215e:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  802165:	a1 20 40 80 00       	mov    0x804020,%eax
  80216a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80216d:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  802174:	a1 20 40 80 00       	mov    0x804020,%eax
  802179:	40                   	inc    %eax
  80217a:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  80217f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802186:	eb 24                	jmp    8021ac <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802188:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80218b:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802190:	c1 e8 0c             	shr    $0xc,%eax
  802193:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  80219a:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  80219e:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8021a5:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  8021ac:	8b 45 90             	mov    -0x70(%ebp),%eax
  8021af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b2:	72 d4                	jb     802188 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  8021b4:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8021ba:	e9 f8 00 00 00       	jmp    8022b7 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  8021bf:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  8021c6:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  8021cd:	10 00 00 
  8021d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8021d9:	01 d0                	add    %edx,%eax
  8021db:	48                   	dec    %eax
  8021dc:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  8021e2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8021e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ed:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  8021f3:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8021f9:	29 d0                	sub    %edx,%eax
  8021fb:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8021fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802202:	74 09                	je     80220d <malloc+0x8f6>
  802204:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80220b:	76 0a                	jbe    802217 <malloc+0x900>
		return NULL;
  80220d:	b8 00 00 00 00       	mov    $0x0,%eax
  802212:	e9 a0 00 00 00       	jmp    8022b7 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802217:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	01 d0                	add    %edx,%eax
  802222:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802227:	0f 87 87 00 00 00    	ja     8022b4 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80222d:	a1 04 40 80 00       	mov    0x804004,%eax
  802232:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802235:	a1 04 40 80 00       	mov    0x804004,%eax
  80223a:	83 ec 08             	sub    $0x8,%esp
  80223d:	ff 75 08             	pushl  0x8(%ebp)
  802240:	50                   	push   %eax
  802241:	e8 08 03 00 00       	call   80254e <sys_allocateMem>
  802246:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802249:	a1 20 40 80 00       	mov    0x804020,%eax
  80224e:	8b 55 08             	mov    0x8(%ebp),%edx
  802251:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802258:	a1 20 40 80 00       	mov    0x804020,%eax
  80225d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802263:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  80226a:	a1 20 40 80 00       	mov    0x804020,%eax
  80226f:	40                   	inc    %eax
  802270:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  802275:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  80227c:	eb 2e                	jmp    8022ac <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80227e:	a1 04 40 80 00       	mov    0x804004,%eax
  802283:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802288:	c1 e8 0c             	shr    $0xc,%eax
  80228b:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802292:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  802296:	a1 04 40 80 00       	mov    0x804004,%eax
  80229b:	05 00 10 00 00       	add    $0x1000,%eax
  8022a0:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8022a5:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  8022ac:	8b 45 88             	mov    -0x78(%ebp),%eax
  8022af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022b2:	72 ca                	jb     80227e <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  8022b4:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  8022bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  8022c6:	e9 c1 00 00 00       	jmp    80238c <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  8022d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d8:	0f 85 ab 00 00 00    	jne    802389 <free+0xd0>

			if (heap_size[inx].size == 0) {
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	75 21                	jne    80230d <free+0x54>
				heap_size[inx].size = 0;
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  8022f6:	00 00 00 00 
				heap_size[inx].vir = NULL;
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802304:	00 00 00 00 
				return;
  802308:	e9 8d 00 00 00       	jmp    80239a <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	83 ec 08             	sub    $0x8,%esp
  80231d:	52                   	push   %edx
  80231e:	50                   	push   %eax
  80231f:	e8 0e 02 00 00       	call   802532 <sys_freeMem>
  802324:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802327:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802334:	eb 24                	jmp    80235a <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802336:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802339:	05 00 00 00 80       	add    $0x80000000,%eax
  80233e:	c1 e8 0c             	shr    $0xc,%eax
  802341:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  802348:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  80234c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802353:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	39 c2                	cmp    %eax,%edx
  802369:	77 cb                	ja     802336 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802375:	00 00 00 00 
			heap_size[inx].vir = NULL;
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802383:	00 00 00 00 
			break;
  802387:	eb 11                	jmp    80239a <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  802389:	ff 45 f4             	incl   -0xc(%ebp)
  80238c:	a1 20 40 80 00       	mov    0x804020,%eax
  802391:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802394:	0f 8c 31 ff ff ff    	jl     8022cb <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8023a2:	83 ec 04             	sub    $0x4,%esp
  8023a5:	68 50 31 80 00       	push   $0x803150
  8023aa:	68 1c 02 00 00       	push   $0x21c
  8023af:	68 76 31 80 00       	push   $0x803176
  8023b4:	e8 b0 e6 ff ff       	call   800a69 <_panic>

008023b9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	57                   	push   %edi
  8023bd:	56                   	push   %esi
  8023be:	53                   	push   %ebx
  8023bf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023ce:	8b 7d 18             	mov    0x18(%ebp),%edi
  8023d1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8023d4:	cd 30                	int    $0x30
  8023d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8023d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8023dc:	83 c4 10             	add    $0x10,%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5f                   	pop    %edi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    

008023e4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	ff 75 0c             	pushl  0xc(%ebp)
  8023f3:	50                   	push   %eax
  8023f4:	6a 00                	push   $0x0
  8023f6:	e8 be ff ff ff       	call   8023b9 <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
}
  8023fe:	90                   	nop
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_cgetc>:

int
sys_cgetc(void)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 01                	push   $0x1
  802410:	e8 a4 ff ff ff       	call   8023b9 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	50                   	push   %eax
  802429:	6a 03                	push   $0x3
  80242b:	e8 89 ff ff ff       	call   8023b9 <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 02                	push   $0x2
  802444:	e8 70 ff ff ff       	call   8023b9 <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <sys_env_exit>:

void sys_env_exit(void)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 04                	push   $0x4
  80245d:	e8 57 ff ff ff       	call   8023b9 <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
}
  802465:	90                   	nop
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80246b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	52                   	push   %edx
  802478:	50                   	push   %eax
  802479:	6a 05                	push   $0x5
  80247b:	e8 39 ff ff ff       	call   8023b9 <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	56                   	push   %esi
  802489:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80248a:	8b 75 18             	mov    0x18(%ebp),%esi
  80248d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802490:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802493:	8b 55 0c             	mov    0xc(%ebp),%edx
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	56                   	push   %esi
  80249a:	53                   	push   %ebx
  80249b:	51                   	push   %ecx
  80249c:	52                   	push   %edx
  80249d:	50                   	push   %eax
  80249e:	6a 06                	push   $0x6
  8024a0:	e8 14 ff ff ff       	call   8023b9 <syscall>
  8024a5:	83 c4 18             	add    $0x18,%esp
}
  8024a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5d                   	pop    %ebp
  8024ae:	c3                   	ret    

008024af <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	52                   	push   %edx
  8024bf:	50                   	push   %eax
  8024c0:	6a 07                	push   $0x7
  8024c2:	e8 f2 fe ff ff       	call   8023b9 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	ff 75 0c             	pushl  0xc(%ebp)
  8024d8:	ff 75 08             	pushl  0x8(%ebp)
  8024db:	6a 08                	push   $0x8
  8024dd:	e8 d7 fe ff ff       	call   8023b9 <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
}
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 09                	push   $0x9
  8024f6:	e8 be fe ff ff       	call   8023b9 <syscall>
  8024fb:	83 c4 18             	add    $0x18,%esp
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	6a 0a                	push   $0xa
  80250f:	e8 a5 fe ff ff       	call   8023b9 <syscall>
  802514:	83 c4 18             	add    $0x18,%esp
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 0b                	push   $0xb
  802528:	e8 8c fe ff ff       	call   8023b9 <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	ff 75 0c             	pushl  0xc(%ebp)
  80253e:	ff 75 08             	pushl  0x8(%ebp)
  802541:	6a 0d                	push   $0xd
  802543:	e8 71 fe ff ff       	call   8023b9 <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
	return;
  80254b:	90                   	nop
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	ff 75 0c             	pushl  0xc(%ebp)
  80255a:	ff 75 08             	pushl  0x8(%ebp)
  80255d:	6a 0e                	push   $0xe
  80255f:	e8 55 fe ff ff       	call   8023b9 <syscall>
  802564:	83 c4 18             	add    $0x18,%esp
	return ;
  802567:	90                   	nop
}
  802568:	c9                   	leave  
  802569:	c3                   	ret    

0080256a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 0c                	push   $0xc
  802579:	e8 3b fe ff ff       	call   8023b9 <syscall>
  80257e:	83 c4 18             	add    $0x18,%esp
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 10                	push   $0x10
  802592:	e8 22 fe ff ff       	call   8023b9 <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
}
  80259a:	90                   	nop
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 11                	push   $0x11
  8025ac:	e8 08 fe ff ff       	call   8023b9 <syscall>
  8025b1:	83 c4 18             	add    $0x18,%esp
}
  8025b4:	90                   	nop
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	83 ec 04             	sub    $0x4,%esp
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8025c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	50                   	push   %eax
  8025d0:	6a 12                	push   $0x12
  8025d2:	e8 e2 fd ff ff       	call   8023b9 <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
}
  8025da:	90                   	nop
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    

008025dd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 13                	push   $0x13
  8025ec:	e8 c8 fd ff ff       	call   8023b9 <syscall>
  8025f1:	83 c4 18             	add    $0x18,%esp
}
  8025f4:	90                   	nop
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	ff 75 0c             	pushl  0xc(%ebp)
  802606:	50                   	push   %eax
  802607:	6a 14                	push   $0x14
  802609:	e8 ab fd ff ff       	call   8023b9 <syscall>
  80260e:	83 c4 18             	add    $0x18,%esp
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	50                   	push   %eax
  802622:	6a 17                	push   $0x17
  802624:	e8 90 fd ff ff       	call   8023b9 <syscall>
  802629:	83 c4 18             	add    $0x18,%esp
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802631:	8b 45 08             	mov    0x8(%ebp),%eax
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	50                   	push   %eax
  80263d:	6a 15                	push   $0x15
  80263f:	e8 75 fd ff ff       	call   8023b9 <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
}
  802647:	90                   	nop
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80264d:	8b 45 08             	mov    0x8(%ebp),%eax
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	50                   	push   %eax
  802659:	6a 16                	push   $0x16
  80265b:	e8 59 fd ff ff       	call   8023b9 <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
}
  802663:	90                   	nop
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	83 ec 04             	sub    $0x4,%esp
  80266c:	8b 45 10             	mov    0x10(%ebp),%eax
  80266f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802672:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802675:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	6a 00                	push   $0x0
  80267e:	51                   	push   %ecx
  80267f:	52                   	push   %edx
  802680:	ff 75 0c             	pushl  0xc(%ebp)
  802683:	50                   	push   %eax
  802684:	6a 18                	push   $0x18
  802686:	e8 2e fd ff ff       	call   8023b9 <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802693:	8b 55 0c             	mov    0xc(%ebp),%edx
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	52                   	push   %edx
  8026a0:	50                   	push   %eax
  8026a1:	6a 19                	push   $0x19
  8026a3:	e8 11 fd ff ff       	call   8023b9 <syscall>
  8026a8:	83 c4 18             	add    $0x18,%esp
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	50                   	push   %eax
  8026bc:	6a 1a                	push   $0x1a
  8026be:	e8 f6 fc ff ff       	call   8023b9 <syscall>
  8026c3:	83 c4 18             	add    $0x18,%esp
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 1b                	push   $0x1b
  8026d7:	e8 dd fc ff ff       	call   8023b9 <syscall>
  8026dc:	83 c4 18             	add    $0x18,%esp
}
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 1c                	push   $0x1c
  8026f0:	e8 c4 fc ff ff       	call   8023b9 <syscall>
  8026f5:	83 c4 18             	add    $0x18,%esp
}
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	ff 75 0c             	pushl  0xc(%ebp)
  802709:	50                   	push   %eax
  80270a:	6a 1d                	push   $0x1d
  80270c:	e8 a8 fc ff ff       	call   8023b9 <syscall>
  802711:	83 c4 18             	add    $0x18,%esp
}
  802714:	c9                   	leave  
  802715:	c3                   	ret    

00802716 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802716:	55                   	push   %ebp
  802717:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802719:	8b 45 08             	mov    0x8(%ebp),%eax
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	50                   	push   %eax
  802725:	6a 1e                	push   $0x1e
  802727:	e8 8d fc ff ff       	call   8023b9 <syscall>
  80272c:	83 c4 18             	add    $0x18,%esp
}
  80272f:	90                   	nop
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	50                   	push   %eax
  802741:	6a 1f                	push   $0x1f
  802743:	e8 71 fc ff ff       	call   8023b9 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
}
  80274b:	90                   	nop
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802754:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802757:	8d 50 04             	lea    0x4(%eax),%edx
  80275a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	52                   	push   %edx
  802764:	50                   	push   %eax
  802765:	6a 20                	push   $0x20
  802767:	e8 4d fc ff ff       	call   8023b9 <syscall>
  80276c:	83 c4 18             	add    $0x18,%esp
	return result;
  80276f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802772:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802775:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802778:	89 01                	mov    %eax,(%ecx)
  80277a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	c9                   	leave  
  802781:	c2 04 00             	ret    $0x4

00802784 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	ff 75 10             	pushl  0x10(%ebp)
  80278e:	ff 75 0c             	pushl  0xc(%ebp)
  802791:	ff 75 08             	pushl  0x8(%ebp)
  802794:	6a 0f                	push   $0xf
  802796:	e8 1e fc ff ff       	call   8023b9 <syscall>
  80279b:	83 c4 18             	add    $0x18,%esp
	return ;
  80279e:	90                   	nop
}
  80279f:	c9                   	leave  
  8027a0:	c3                   	ret    

008027a1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 21                	push   $0x21
  8027b0:	e8 04 fc ff ff       	call   8023b9 <syscall>
  8027b5:	83 c4 18             	add    $0x18,%esp
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027c6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	50                   	push   %eax
  8027d3:	6a 22                	push   $0x22
  8027d5:	e8 df fb ff ff       	call   8023b9 <syscall>
  8027da:	83 c4 18             	add    $0x18,%esp
	return ;
  8027dd:	90                   	nop
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <rsttst>:
void rsttst()
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 24                	push   $0x24
  8027ef:	e8 c5 fb ff ff       	call   8023b9 <syscall>
  8027f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f7:	90                   	nop
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 04             	sub    $0x4,%esp
  802800:	8b 45 14             	mov    0x14(%ebp),%eax
  802803:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802806:	8b 55 18             	mov    0x18(%ebp),%edx
  802809:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80280d:	52                   	push   %edx
  80280e:	50                   	push   %eax
  80280f:	ff 75 10             	pushl  0x10(%ebp)
  802812:	ff 75 0c             	pushl  0xc(%ebp)
  802815:	ff 75 08             	pushl  0x8(%ebp)
  802818:	6a 23                	push   $0x23
  80281a:	e8 9a fb ff ff       	call   8023b9 <syscall>
  80281f:	83 c4 18             	add    $0x18,%esp
	return ;
  802822:	90                   	nop
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <chktst>:
void chktst(uint32 n)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	ff 75 08             	pushl  0x8(%ebp)
  802833:	6a 25                	push   $0x25
  802835:	e8 7f fb ff ff       	call   8023b9 <syscall>
  80283a:	83 c4 18             	add    $0x18,%esp
	return ;
  80283d:	90                   	nop
}
  80283e:	c9                   	leave  
  80283f:	c3                   	ret    

00802840 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	6a 00                	push   $0x0
  80284e:	6a 00                	push   $0x0
  802850:	6a 26                	push   $0x26
  802852:	e8 62 fb ff ff       	call   8023b9 <syscall>
  802857:	83 c4 18             	add    $0x18,%esp
  80285a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80285d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802861:	75 07                	jne    80286a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802863:	b8 01 00 00 00       	mov    $0x1,%eax
  802868:	eb 05                	jmp    80286f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80286a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286f:	c9                   	leave  
  802870:	c3                   	ret    

00802871 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802871:	55                   	push   %ebp
  802872:	89 e5                	mov    %esp,%ebp
  802874:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 26                	push   $0x26
  802883:	e8 31 fb ff ff       	call   8023b9 <syscall>
  802888:	83 c4 18             	add    $0x18,%esp
  80288b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80288e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802892:	75 07                	jne    80289b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802894:	b8 01 00 00 00       	mov    $0x1,%eax
  802899:	eb 05                	jmp    8028a0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80289b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a0:	c9                   	leave  
  8028a1:	c3                   	ret    

008028a2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 26                	push   $0x26
  8028b4:	e8 00 fb ff ff       	call   8023b9 <syscall>
  8028b9:	83 c4 18             	add    $0x18,%esp
  8028bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028bf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8028c3:	75 07                	jne    8028cc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8028c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ca:	eb 05                	jmp    8028d1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d1:	c9                   	leave  
  8028d2:	c3                   	ret    

008028d3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028d3:	55                   	push   %ebp
  8028d4:	89 e5                	mov    %esp,%ebp
  8028d6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 26                	push   $0x26
  8028e5:	e8 cf fa ff ff       	call   8023b9 <syscall>
  8028ea:	83 c4 18             	add    $0x18,%esp
  8028ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8028f0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8028f4:	75 07                	jne    8028fd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8028f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028fb:	eb 05                	jmp    802902 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8028fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802902:	c9                   	leave  
  802903:	c3                   	ret    

00802904 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	ff 75 08             	pushl  0x8(%ebp)
  802912:	6a 27                	push   $0x27
  802914:	e8 a0 fa ff ff       	call   8023b9 <syscall>
  802919:	83 c4 18             	add    $0x18,%esp
	return ;
  80291c:	90                   	nop
}
  80291d:	c9                   	leave  
  80291e:	c3                   	ret    
  80291f:	90                   	nop

00802920 <__udivdi3>:
  802920:	55                   	push   %ebp
  802921:	57                   	push   %edi
  802922:	56                   	push   %esi
  802923:	53                   	push   %ebx
  802924:	83 ec 1c             	sub    $0x1c,%esp
  802927:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80292b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80292f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802933:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802937:	89 ca                	mov    %ecx,%edx
  802939:	89 f8                	mov    %edi,%eax
  80293b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80293f:	85 f6                	test   %esi,%esi
  802941:	75 2d                	jne    802970 <__udivdi3+0x50>
  802943:	39 cf                	cmp    %ecx,%edi
  802945:	77 65                	ja     8029ac <__udivdi3+0x8c>
  802947:	89 fd                	mov    %edi,%ebp
  802949:	85 ff                	test   %edi,%edi
  80294b:	75 0b                	jne    802958 <__udivdi3+0x38>
  80294d:	b8 01 00 00 00       	mov    $0x1,%eax
  802952:	31 d2                	xor    %edx,%edx
  802954:	f7 f7                	div    %edi
  802956:	89 c5                	mov    %eax,%ebp
  802958:	31 d2                	xor    %edx,%edx
  80295a:	89 c8                	mov    %ecx,%eax
  80295c:	f7 f5                	div    %ebp
  80295e:	89 c1                	mov    %eax,%ecx
  802960:	89 d8                	mov    %ebx,%eax
  802962:	f7 f5                	div    %ebp
  802964:	89 cf                	mov    %ecx,%edi
  802966:	89 fa                	mov    %edi,%edx
  802968:	83 c4 1c             	add    $0x1c,%esp
  80296b:	5b                   	pop    %ebx
  80296c:	5e                   	pop    %esi
  80296d:	5f                   	pop    %edi
  80296e:	5d                   	pop    %ebp
  80296f:	c3                   	ret    
  802970:	39 ce                	cmp    %ecx,%esi
  802972:	77 28                	ja     80299c <__udivdi3+0x7c>
  802974:	0f bd fe             	bsr    %esi,%edi
  802977:	83 f7 1f             	xor    $0x1f,%edi
  80297a:	75 40                	jne    8029bc <__udivdi3+0x9c>
  80297c:	39 ce                	cmp    %ecx,%esi
  80297e:	72 0a                	jb     80298a <__udivdi3+0x6a>
  802980:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802984:	0f 87 9e 00 00 00    	ja     802a28 <__udivdi3+0x108>
  80298a:	b8 01 00 00 00       	mov    $0x1,%eax
  80298f:	89 fa                	mov    %edi,%edx
  802991:	83 c4 1c             	add    $0x1c,%esp
  802994:	5b                   	pop    %ebx
  802995:	5e                   	pop    %esi
  802996:	5f                   	pop    %edi
  802997:	5d                   	pop    %ebp
  802998:	c3                   	ret    
  802999:	8d 76 00             	lea    0x0(%esi),%esi
  80299c:	31 ff                	xor    %edi,%edi
  80299e:	31 c0                	xor    %eax,%eax
  8029a0:	89 fa                	mov    %edi,%edx
  8029a2:	83 c4 1c             	add    $0x1c,%esp
  8029a5:	5b                   	pop    %ebx
  8029a6:	5e                   	pop    %esi
  8029a7:	5f                   	pop    %edi
  8029a8:	5d                   	pop    %ebp
  8029a9:	c3                   	ret    
  8029aa:	66 90                	xchg   %ax,%ax
  8029ac:	89 d8                	mov    %ebx,%eax
  8029ae:	f7 f7                	div    %edi
  8029b0:	31 ff                	xor    %edi,%edi
  8029b2:	89 fa                	mov    %edi,%edx
  8029b4:	83 c4 1c             	add    $0x1c,%esp
  8029b7:	5b                   	pop    %ebx
  8029b8:	5e                   	pop    %esi
  8029b9:	5f                   	pop    %edi
  8029ba:	5d                   	pop    %ebp
  8029bb:	c3                   	ret    
  8029bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8029c1:	89 eb                	mov    %ebp,%ebx
  8029c3:	29 fb                	sub    %edi,%ebx
  8029c5:	89 f9                	mov    %edi,%ecx
  8029c7:	d3 e6                	shl    %cl,%esi
  8029c9:	89 c5                	mov    %eax,%ebp
  8029cb:	88 d9                	mov    %bl,%cl
  8029cd:	d3 ed                	shr    %cl,%ebp
  8029cf:	89 e9                	mov    %ebp,%ecx
  8029d1:	09 f1                	or     %esi,%ecx
  8029d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8029d7:	89 f9                	mov    %edi,%ecx
  8029d9:	d3 e0                	shl    %cl,%eax
  8029db:	89 c5                	mov    %eax,%ebp
  8029dd:	89 d6                	mov    %edx,%esi
  8029df:	88 d9                	mov    %bl,%cl
  8029e1:	d3 ee                	shr    %cl,%esi
  8029e3:	89 f9                	mov    %edi,%ecx
  8029e5:	d3 e2                	shl    %cl,%edx
  8029e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029eb:	88 d9                	mov    %bl,%cl
  8029ed:	d3 e8                	shr    %cl,%eax
  8029ef:	09 c2                	or     %eax,%edx
  8029f1:	89 d0                	mov    %edx,%eax
  8029f3:	89 f2                	mov    %esi,%edx
  8029f5:	f7 74 24 0c          	divl   0xc(%esp)
  8029f9:	89 d6                	mov    %edx,%esi
  8029fb:	89 c3                	mov    %eax,%ebx
  8029fd:	f7 e5                	mul    %ebp
  8029ff:	39 d6                	cmp    %edx,%esi
  802a01:	72 19                	jb     802a1c <__udivdi3+0xfc>
  802a03:	74 0b                	je     802a10 <__udivdi3+0xf0>
  802a05:	89 d8                	mov    %ebx,%eax
  802a07:	31 ff                	xor    %edi,%edi
  802a09:	e9 58 ff ff ff       	jmp    802966 <__udivdi3+0x46>
  802a0e:	66 90                	xchg   %ax,%ax
  802a10:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a14:	89 f9                	mov    %edi,%ecx
  802a16:	d3 e2                	shl    %cl,%edx
  802a18:	39 c2                	cmp    %eax,%edx
  802a1a:	73 e9                	jae    802a05 <__udivdi3+0xe5>
  802a1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a1f:	31 ff                	xor    %edi,%edi
  802a21:	e9 40 ff ff ff       	jmp    802966 <__udivdi3+0x46>
  802a26:	66 90                	xchg   %ax,%ax
  802a28:	31 c0                	xor    %eax,%eax
  802a2a:	e9 37 ff ff ff       	jmp    802966 <__udivdi3+0x46>
  802a2f:	90                   	nop

00802a30 <__umoddi3>:
  802a30:	55                   	push   %ebp
  802a31:	57                   	push   %edi
  802a32:	56                   	push   %esi
  802a33:	53                   	push   %ebx
  802a34:	83 ec 1c             	sub    $0x1c,%esp
  802a37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a4f:	89 f3                	mov    %esi,%ebx
  802a51:	89 fa                	mov    %edi,%edx
  802a53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a57:	89 34 24             	mov    %esi,(%esp)
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	75 1a                	jne    802a78 <__umoddi3+0x48>
  802a5e:	39 f7                	cmp    %esi,%edi
  802a60:	0f 86 a2 00 00 00    	jbe    802b08 <__umoddi3+0xd8>
  802a66:	89 c8                	mov    %ecx,%eax
  802a68:	89 f2                	mov    %esi,%edx
  802a6a:	f7 f7                	div    %edi
  802a6c:	89 d0                	mov    %edx,%eax
  802a6e:	31 d2                	xor    %edx,%edx
  802a70:	83 c4 1c             	add    $0x1c,%esp
  802a73:	5b                   	pop    %ebx
  802a74:	5e                   	pop    %esi
  802a75:	5f                   	pop    %edi
  802a76:	5d                   	pop    %ebp
  802a77:	c3                   	ret    
  802a78:	39 f0                	cmp    %esi,%eax
  802a7a:	0f 87 ac 00 00 00    	ja     802b2c <__umoddi3+0xfc>
  802a80:	0f bd e8             	bsr    %eax,%ebp
  802a83:	83 f5 1f             	xor    $0x1f,%ebp
  802a86:	0f 84 ac 00 00 00    	je     802b38 <__umoddi3+0x108>
  802a8c:	bf 20 00 00 00       	mov    $0x20,%edi
  802a91:	29 ef                	sub    %ebp,%edi
  802a93:	89 fe                	mov    %edi,%esi
  802a95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a99:	89 e9                	mov    %ebp,%ecx
  802a9b:	d3 e0                	shl    %cl,%eax
  802a9d:	89 d7                	mov    %edx,%edi
  802a9f:	89 f1                	mov    %esi,%ecx
  802aa1:	d3 ef                	shr    %cl,%edi
  802aa3:	09 c7                	or     %eax,%edi
  802aa5:	89 e9                	mov    %ebp,%ecx
  802aa7:	d3 e2                	shl    %cl,%edx
  802aa9:	89 14 24             	mov    %edx,(%esp)
  802aac:	89 d8                	mov    %ebx,%eax
  802aae:	d3 e0                	shl    %cl,%eax
  802ab0:	89 c2                	mov    %eax,%edx
  802ab2:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ab6:	d3 e0                	shl    %cl,%eax
  802ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802abc:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ac0:	89 f1                	mov    %esi,%ecx
  802ac2:	d3 e8                	shr    %cl,%eax
  802ac4:	09 d0                	or     %edx,%eax
  802ac6:	d3 eb                	shr    %cl,%ebx
  802ac8:	89 da                	mov    %ebx,%edx
  802aca:	f7 f7                	div    %edi
  802acc:	89 d3                	mov    %edx,%ebx
  802ace:	f7 24 24             	mull   (%esp)
  802ad1:	89 c6                	mov    %eax,%esi
  802ad3:	89 d1                	mov    %edx,%ecx
  802ad5:	39 d3                	cmp    %edx,%ebx
  802ad7:	0f 82 87 00 00 00    	jb     802b64 <__umoddi3+0x134>
  802add:	0f 84 91 00 00 00    	je     802b74 <__umoddi3+0x144>
  802ae3:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ae7:	29 f2                	sub    %esi,%edx
  802ae9:	19 cb                	sbb    %ecx,%ebx
  802aeb:	89 d8                	mov    %ebx,%eax
  802aed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802af1:	d3 e0                	shl    %cl,%eax
  802af3:	89 e9                	mov    %ebp,%ecx
  802af5:	d3 ea                	shr    %cl,%edx
  802af7:	09 d0                	or     %edx,%eax
  802af9:	89 e9                	mov    %ebp,%ecx
  802afb:	d3 eb                	shr    %cl,%ebx
  802afd:	89 da                	mov    %ebx,%edx
  802aff:	83 c4 1c             	add    $0x1c,%esp
  802b02:	5b                   	pop    %ebx
  802b03:	5e                   	pop    %esi
  802b04:	5f                   	pop    %edi
  802b05:	5d                   	pop    %ebp
  802b06:	c3                   	ret    
  802b07:	90                   	nop
  802b08:	89 fd                	mov    %edi,%ebp
  802b0a:	85 ff                	test   %edi,%edi
  802b0c:	75 0b                	jne    802b19 <__umoddi3+0xe9>
  802b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b13:	31 d2                	xor    %edx,%edx
  802b15:	f7 f7                	div    %edi
  802b17:	89 c5                	mov    %eax,%ebp
  802b19:	89 f0                	mov    %esi,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	f7 f5                	div    %ebp
  802b1f:	89 c8                	mov    %ecx,%eax
  802b21:	f7 f5                	div    %ebp
  802b23:	89 d0                	mov    %edx,%eax
  802b25:	e9 44 ff ff ff       	jmp    802a6e <__umoddi3+0x3e>
  802b2a:	66 90                	xchg   %ax,%ax
  802b2c:	89 c8                	mov    %ecx,%eax
  802b2e:	89 f2                	mov    %esi,%edx
  802b30:	83 c4 1c             	add    $0x1c,%esp
  802b33:	5b                   	pop    %ebx
  802b34:	5e                   	pop    %esi
  802b35:	5f                   	pop    %edi
  802b36:	5d                   	pop    %ebp
  802b37:	c3                   	ret    
  802b38:	3b 04 24             	cmp    (%esp),%eax
  802b3b:	72 06                	jb     802b43 <__umoddi3+0x113>
  802b3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b41:	77 0f                	ja     802b52 <__umoddi3+0x122>
  802b43:	89 f2                	mov    %esi,%edx
  802b45:	29 f9                	sub    %edi,%ecx
  802b47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b4b:	89 14 24             	mov    %edx,(%esp)
  802b4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b52:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b56:	8b 14 24             	mov    (%esp),%edx
  802b59:	83 c4 1c             	add    $0x1c,%esp
  802b5c:	5b                   	pop    %ebx
  802b5d:	5e                   	pop    %esi
  802b5e:	5f                   	pop    %edi
  802b5f:	5d                   	pop    %ebp
  802b60:	c3                   	ret    
  802b61:	8d 76 00             	lea    0x0(%esi),%esi
  802b64:	2b 04 24             	sub    (%esp),%eax
  802b67:	19 fa                	sbb    %edi,%edx
  802b69:	89 d1                	mov    %edx,%ecx
  802b6b:	89 c6                	mov    %eax,%esi
  802b6d:	e9 71 ff ff ff       	jmp    802ae3 <__umoddi3+0xb3>
  802b72:	66 90                	xchg   %ax,%ax
  802b74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b78:	72 ea                	jb     802b64 <__umoddi3+0x134>
  802b7a:	89 d9                	mov    %ebx,%ecx
  802b7c:	e9 62 ff ff ff       	jmp    802ae3 <__umoddi3+0xb3>
