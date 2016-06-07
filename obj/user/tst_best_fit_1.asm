
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 cc 0b 00 00       	call   800c02 <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	int envID = sys_getenvid();
  800040:	e8 4a 26 00 00       	call   80268f <sys_getenvid>
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
  80006f:	e8 ea 2a 00 00       	call   802b5e <sys_set_uheap_strategy>
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
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800096:	e8 a6 26 00 00       	call   802741 <sys_calculate_free_frames>
  80009b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80009e:	e8 21 27 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8000a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a9:	89 c2                	mov    %eax,%edx
  8000ab:	01 d2                	add    %edx,%edx
  8000ad:	01 d0                	add    %edx,%eax
  8000af:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	50                   	push   %eax
  8000b6:	e8 b6 1a 00 00       	call   801b71 <malloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 90             	mov    %eax,-0x70(%ebp)

		//cprintf("\n el mafroud kda inx= %d   size= %d\n",0,(3*Mega-kilo)/PAGE_SIZE);

		if ((uint32) ptr_allocations[0] < (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000c1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000c4:	85 c0                	test   %eax,%eax
  8000c6:	79 0a                	jns    8000d2 <_main+0x9a>
  8000c8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000d0:	76 14                	jbe    8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 e0 2d 80 00       	push   $0x802de0
  8000da:	6a 1d                	push   $0x1d
  8000dc:	68 10 2e 80 00       	push   $0x802e10
  8000e1:	e8 dd 0b 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8000e6:	e8 d9 26 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8000eb:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000ee:	3d 00 03 00 00       	cmp    $0x300,%eax
  8000f3:	74 14                	je     800109 <_main+0xd1>
  8000f5:	83 ec 04             	sub    $0x4,%esp
  8000f8:	68 26 2e 80 00       	push   $0x802e26
  8000fd:	6a 1f                	push   $0x1f
  8000ff:	68 10 2e 80 00       	push   $0x802e10
  800104:	e8 ba 0b 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800109:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80010c:	e8 30 26 00 00       	call   802741 <sys_calculate_free_frames>
  800111:	29 c3                	sub    %eax,%ebx
  800113:	89 d8                	mov    %ebx,%eax
  800115:	83 f8 01             	cmp    $0x1,%eax
  800118:	74 14                	je     80012e <_main+0xf6>
  80011a:	83 ec 04             	sub    $0x4,%esp
  80011d:	68 43 2e 80 00       	push   $0x802e43
  800122:	6a 20                	push   $0x20
  800124:	68 10 2e 80 00       	push   $0x802e10
  800129:	e8 95 0b 00 00       	call   800cc3 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80012e:	e8 0e 26 00 00       	call   802741 <sys_calculate_free_frames>
  800133:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800136:	e8 89 26 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  80013b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  80013e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800141:	89 c2                	mov    %eax,%edx
  800143:	01 d2                	add    %edx,%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	50                   	push   %eax
  80014e:	e8 1e 1a 00 00       	call   801b71 <malloc>
  800153:	83 c4 10             	add    $0x10,%esp
  800156:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//cprintf("\n el mafroud kda inx= %d   size= %d\n",(3*Mega)/PAGE_SIZE,(3*Mega-kilo)/PAGE_SIZE);
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 3*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800159:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80015c:	89 c1                	mov    %eax,%ecx
  80015e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800161:	89 c2                	mov    %eax,%edx
  800163:	01 d2                	add    %edx,%edx
  800165:	01 d0                	add    %edx,%eax
  800167:	05 00 00 00 80       	add    $0x80000000,%eax
  80016c:	39 c1                	cmp    %eax,%ecx
  80016e:	75 17                	jne    800187 <_main+0x14f>
  800170:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800173:	89 c1                	mov    %eax,%ecx
  800175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800178:	89 c2                	mov    %eax,%edx
  80017a:	01 d2                	add    %edx,%edx
  80017c:	01 d0                	add    %edx,%eax
  80017e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800183:	39 c1                	cmp    %eax,%ecx
  800185:	76 14                	jbe    80019b <_main+0x163>
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	68 e0 2d 80 00       	push   $0x802de0
  80018f:	6a 28                	push   $0x28
  800191:	68 10 2e 80 00       	push   $0x802e10
  800196:	e8 28 0b 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  80019b:	e8 24 26 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8001a0:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001a3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001a8:	74 14                	je     8001be <_main+0x186>
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	68 26 2e 80 00       	push   $0x802e26
  8001b2:	6a 2a                	push   $0x2a
  8001b4:	68 10 2e 80 00       	push   $0x802e10
  8001b9:	e8 05 0b 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001c1:	e8 7b 25 00 00       	call   802741 <sys_calculate_free_frames>
  8001c6:	29 c3                	sub    %eax,%ebx
  8001c8:	89 d8                	mov    %ebx,%eax
  8001ca:	83 f8 01             	cmp    $0x1,%eax
  8001cd:	74 14                	je     8001e3 <_main+0x1ab>
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	68 43 2e 80 00       	push   $0x802e43
  8001d7:	6a 2b                	push   $0x2b
  8001d9:	68 10 2e 80 00       	push   $0x802e10
  8001de:	e8 e0 0a 00 00       	call   800cc3 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e3:	e8 59 25 00 00       	call   802741 <sys_calculate_free_frames>
  8001e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001eb:	e8 d4 25 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8001f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  8001f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f6:	01 c0                	add    %eax,%eax
  8001f8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	50                   	push   %eax
  8001ff:	e8 6d 19 00 00       	call   801b71 <malloc>
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 6*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80020a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020d:	89 c1                	mov    %eax,%ecx
  80020f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800212:	89 d0                	mov    %edx,%eax
  800214:	01 c0                	add    %eax,%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	01 c0                	add    %eax,%eax
  80021a:	05 00 00 00 80       	add    $0x80000000,%eax
  80021f:	39 c1                	cmp    %eax,%ecx
  800221:	75 19                	jne    80023c <_main+0x204>
  800223:	8b 45 98             	mov    -0x68(%ebp),%eax
  800226:	89 c1                	mov    %eax,%ecx
  800228:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80022b:	89 d0                	mov    %edx,%eax
  80022d:	01 c0                	add    %eax,%eax
  80022f:	01 d0                	add    %edx,%eax
  800231:	01 c0                	add    %eax,%eax
  800233:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800238:	39 c1                	cmp    %eax,%ecx
  80023a:	76 14                	jbe    800250 <_main+0x218>
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	68 e0 2d 80 00       	push   $0x802de0
  800244:	6a 31                	push   $0x31
  800246:	68 10 2e 80 00       	push   $0x802e10
  80024b:	e8 73 0a 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800250:	e8 6f 25 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800255:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800258:	3d 00 02 00 00       	cmp    $0x200,%eax
  80025d:	74 14                	je     800273 <_main+0x23b>
  80025f:	83 ec 04             	sub    $0x4,%esp
  800262:	68 26 2e 80 00       	push   $0x802e26
  800267:	6a 33                	push   $0x33
  800269:	68 10 2e 80 00       	push   $0x802e10
  80026e:	e8 50 0a 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800273:	e8 c9 24 00 00       	call   802741 <sys_calculate_free_frames>
  800278:	89 c2                	mov    %eax,%edx
  80027a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027d:	39 c2                	cmp    %eax,%edx
  80027f:	74 14                	je     800295 <_main+0x25d>
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	68 43 2e 80 00       	push   $0x802e43
  800289:	6a 34                	push   $0x34
  80028b:	68 10 2e 80 00       	push   $0x802e10
  800290:	e8 2e 0a 00 00       	call   800cc3 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800295:	e8 a7 24 00 00       	call   802741 <sys_calculate_free_frames>
  80029a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80029d:	e8 22 25 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8002a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002a8:	01 c0                	add    %eax,%eax
  8002aa:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	50                   	push   %eax
  8002b1:	e8 bb 18 00 00       	call   801b71 <malloc>
  8002b6:	83 c4 10             	add    $0x10,%esp
  8002b9:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 8*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002bc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002bf:	89 c2                	mov    %eax,%edx
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	c1 e0 03             	shl    $0x3,%eax
  8002c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8002cc:	39 c2                	cmp    %eax,%edx
  8002ce:	75 14                	jne    8002e4 <_main+0x2ac>
  8002d0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002d3:	89 c2                	mov    %eax,%edx
  8002d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d8:	c1 e0 03             	shl    $0x3,%eax
  8002db:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002e0:	39 c2                	cmp    %eax,%edx
  8002e2:	76 14                	jbe    8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 e0 2d 80 00       	push   $0x802de0
  8002ec:	6a 3a                	push   $0x3a
  8002ee:	68 10 2e 80 00       	push   $0x802e10
  8002f3:	e8 cb 09 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002f8:	e8 c7 24 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8002fd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800300:	3d 00 02 00 00       	cmp    $0x200,%eax
  800305:	74 14                	je     80031b <_main+0x2e3>
  800307:	83 ec 04             	sub    $0x4,%esp
  80030a:	68 26 2e 80 00       	push   $0x802e26
  80030f:	6a 3c                	push   $0x3c
  800311:	68 10 2e 80 00       	push   $0x802e10
  800316:	e8 a8 09 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  80031b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80031e:	e8 1e 24 00 00       	call   802741 <sys_calculate_free_frames>
  800323:	29 c3                	sub    %eax,%ebx
  800325:	89 d8                	mov    %ebx,%eax
  800327:	83 f8 01             	cmp    $0x1,%eax
  80032a:	74 14                	je     800340 <_main+0x308>
  80032c:	83 ec 04             	sub    $0x4,%esp
  80032f:	68 43 2e 80 00       	push   $0x802e43
  800334:	6a 3d                	push   $0x3d
  800336:	68 10 2e 80 00       	push   $0x802e10
  80033b:	e8 83 09 00 00       	call   800cc3 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800340:	e8 fc 23 00 00       	call   802741 <sys_calculate_free_frames>
  800345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800348:	e8 77 24 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  80034d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800350:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800353:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	50                   	push   %eax
  80035a:	e8 12 18 00 00       	call   801b71 <malloc>
  80035f:	83 c4 10             	add    $0x10,%esp
  800362:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 10*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800365:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800368:	89 c1                	mov    %eax,%ecx
  80036a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80036d:	89 d0                	mov    %edx,%eax
  80036f:	c1 e0 02             	shl    $0x2,%eax
  800372:	01 d0                	add    %edx,%eax
  800374:	01 c0                	add    %eax,%eax
  800376:	05 00 00 00 80       	add    $0x80000000,%eax
  80037b:	39 c1                	cmp    %eax,%ecx
  80037d:	75 1a                	jne    800399 <_main+0x361>
  80037f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800382:	89 c1                	mov    %eax,%ecx
  800384:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800387:	89 d0                	mov    %edx,%eax
  800389:	c1 e0 02             	shl    $0x2,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	01 c0                	add    %eax,%eax
  800390:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800395:	39 c1                	cmp    %eax,%ecx
  800397:	76 14                	jbe    8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 e0 2d 80 00       	push   $0x802de0
  8003a1:	6a 43                	push   $0x43
  8003a3:	68 10 2e 80 00       	push   $0x802e10
  8003a8:	e8 16 09 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8003ad:	e8 12 24 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8003b2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003b5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8003ba:	74 14                	je     8003d0 <_main+0x398>
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	68 26 2e 80 00       	push   $0x802e26
  8003c4:	6a 45                	push   $0x45
  8003c6:	68 10 2e 80 00       	push   $0x802e10
  8003cb:	e8 f3 08 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003d0:	e8 6c 23 00 00       	call   802741 <sys_calculate_free_frames>
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003da:	39 c2                	cmp    %eax,%edx
  8003dc:	74 14                	je     8003f2 <_main+0x3ba>
  8003de:	83 ec 04             	sub    $0x4,%esp
  8003e1:	68 43 2e 80 00       	push   $0x802e43
  8003e6:	6a 46                	push   $0x46
  8003e8:	68 10 2e 80 00       	push   $0x802e10
  8003ed:	e8 d1 08 00 00       	call   800cc3 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003f2:	e8 4a 23 00 00       	call   802741 <sys_calculate_free_frames>
  8003f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003fa:	e8 c5 23 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8003ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  800402:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800405:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800408:	83 ec 0c             	sub    $0xc,%esp
  80040b:	50                   	push   %eax
  80040c:	e8 60 17 00 00       	call   801b71 <malloc>
  800411:	83 c4 10             	add    $0x10,%esp
  800414:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 11*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800417:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80041a:	89 c1                	mov    %eax,%ecx
  80041c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 02             	shl    $0x2,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	05 00 00 00 80       	add    $0x80000000,%eax
  80042f:	39 c1                	cmp    %eax,%ecx
  800431:	75 1c                	jne    80044f <_main+0x417>
  800433:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800436:	89 c1                	mov    %eax,%ecx
  800438:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80043b:	89 d0                	mov    %edx,%eax
  80043d:	c1 e0 02             	shl    $0x2,%eax
  800440:	01 d0                	add    %edx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80044b:	39 c1                	cmp    %eax,%ecx
  80044d:	76 14                	jbe    800463 <_main+0x42b>
  80044f:	83 ec 04             	sub    $0x4,%esp
  800452:	68 e0 2d 80 00       	push   $0x802de0
  800457:	6a 4c                	push   $0x4c
  800459:	68 10 2e 80 00       	push   $0x802e10
  80045e:	e8 60 08 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800463:	e8 5c 23 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800468:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80046b:	3d 00 01 00 00       	cmp    $0x100,%eax
  800470:	74 14                	je     800486 <_main+0x44e>
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 26 2e 80 00       	push   $0x802e26
  80047a:	6a 4e                	push   $0x4e
  80047c:	68 10 2e 80 00       	push   $0x802e10
  800481:	e8 3d 08 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800486:	e8 b6 22 00 00       	call   802741 <sys_calculate_free_frames>
  80048b:	89 c2                	mov    %eax,%edx
  80048d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800490:	39 c2                	cmp    %eax,%edx
  800492:	74 14                	je     8004a8 <_main+0x470>
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 43 2e 80 00       	push   $0x802e43
  80049c:	6a 4f                	push   $0x4f
  80049e:	68 10 2e 80 00       	push   $0x802e10
  8004a3:	e8 1b 08 00 00       	call   800cc3 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8004a8:	e8 94 22 00 00       	call   802741 <sys_calculate_free_frames>
  8004ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b0:	e8 0f 23 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8004b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004be:	83 ec 0c             	sub    $0xc,%esp
  8004c1:	50                   	push   %eax
  8004c2:	e8 aa 16 00 00       	call   801b71 <malloc>
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 12*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d0:	89 c1                	mov    %eax,%ecx
  8004d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004d5:	89 d0                	mov    %edx,%eax
  8004d7:	01 c0                	add    %eax,%eax
  8004d9:	01 d0                	add    %edx,%eax
  8004db:	c1 e0 02             	shl    $0x2,%eax
  8004de:	05 00 00 00 80       	add    $0x80000000,%eax
  8004e3:	39 c1                	cmp    %eax,%ecx
  8004e5:	75 1a                	jne    800501 <_main+0x4c9>
  8004e7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004ea:	89 c1                	mov    %eax,%ecx
  8004ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004ef:	89 d0                	mov    %edx,%eax
  8004f1:	01 c0                	add    %eax,%eax
  8004f3:	01 d0                	add    %edx,%eax
  8004f5:	c1 e0 02             	shl    $0x2,%eax
  8004f8:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8004fd:	39 c1                	cmp    %eax,%ecx
  8004ff:	76 14                	jbe    800515 <_main+0x4dd>
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	68 e0 2d 80 00       	push   $0x802de0
  800509:	6a 55                	push   $0x55
  80050b:	68 10 2e 80 00       	push   $0x802e10
  800510:	e8 ae 07 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800515:	e8 aa 22 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  80051a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80051d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800522:	74 14                	je     800538 <_main+0x500>
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 26 2e 80 00       	push   $0x802e26
  80052c:	6a 57                	push   $0x57
  80052e:	68 10 2e 80 00       	push   $0x802e10
  800533:	e8 8b 07 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800538:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80053b:	e8 01 22 00 00       	call   802741 <sys_calculate_free_frames>
  800540:	29 c3                	sub    %eax,%ebx
  800542:	89 d8                	mov    %ebx,%eax
  800544:	83 f8 01             	cmp    $0x1,%eax
  800547:	74 14                	je     80055d <_main+0x525>
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	68 43 2e 80 00       	push   $0x802e43
  800551:	6a 58                	push   $0x58
  800553:	68 10 2e 80 00       	push   $0x802e10
  800558:	e8 66 07 00 00       	call   800cc3 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 df 21 00 00       	call   802741 <sys_calculate_free_frames>
  800562:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 5a 22 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  80056a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  80056d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800570:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 f5 15 00 00       	call   801b71 <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega) || (uint32) ptr_allocations[7] > (USER_HEAP_START + 13*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800582:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800585:	89 c1                	mov    %eax,%ecx
  800587:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80058a:	89 d0                	mov    %edx,%eax
  80058c:	01 c0                	add    %eax,%eax
  80058e:	01 d0                	add    %edx,%eax
  800590:	c1 e0 02             	shl    $0x2,%eax
  800593:	01 d0                	add    %edx,%eax
  800595:	05 00 00 00 80       	add    $0x80000000,%eax
  80059a:	39 c1                	cmp    %eax,%ecx
  80059c:	75 1c                	jne    8005ba <_main+0x582>
  80059e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005a1:	89 c1                	mov    %eax,%ecx
  8005a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005a6:	89 d0                	mov    %edx,%eax
  8005a8:	01 c0                	add    %eax,%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	c1 e0 02             	shl    $0x2,%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8005b6:	39 c1                	cmp    %eax,%ecx
  8005b8:	76 14                	jbe    8005ce <_main+0x596>
  8005ba:	83 ec 04             	sub    $0x4,%esp
  8005bd:	68 e0 2d 80 00       	push   $0x802de0
  8005c2:	6a 5e                	push   $0x5e
  8005c4:	68 10 2e 80 00       	push   $0x802e10
  8005c9:	e8 f5 06 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8005ce:	e8 f1 21 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8005d3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005d6:	3d 00 01 00 00       	cmp    $0x100,%eax
  8005db:	74 14                	je     8005f1 <_main+0x5b9>
  8005dd:	83 ec 04             	sub    $0x4,%esp
  8005e0:	68 26 2e 80 00       	push   $0x802e26
  8005e5:	6a 60                	push   $0x60
  8005e7:	68 10 2e 80 00       	push   $0x802e10
  8005ec:	e8 d2 06 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8005f1:	e8 4b 21 00 00       	call   802741 <sys_calculate_free_frames>
  8005f6:	89 c2                	mov    %eax,%edx
  8005f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005fb:	39 c2                	cmp    %eax,%edx
  8005fd:	74 14                	je     800613 <_main+0x5db>
  8005ff:	83 ec 04             	sub    $0x4,%esp
  800602:	68 43 2e 80 00       	push   $0x802e43
  800607:	6a 61                	push   $0x61
  800609:	68 10 2e 80 00       	push   $0x802e10
  80060e:	e8 b0 06 00 00       	call   800cc3 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800613:	e8 29 21 00 00       	call   802741 <sys_calculate_free_frames>
  800618:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80061b:	e8 a4 21 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800620:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800623:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800626:	83 ec 0c             	sub    $0xc,%esp
  800629:	50                   	push   %eax
  80062a:	e8 e4 1e 00 00       	call   802513 <free>
  80062f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  800632:	e8 8d 21 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800637:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063a:	29 c2                	sub    %eax,%edx
  80063c:	89 d0                	mov    %edx,%eax
  80063e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800643:	74 14                	je     800659 <_main+0x621>
  800645:	83 ec 04             	sub    $0x4,%esp
  800648:	68 56 2e 80 00       	push   $0x802e56
  80064d:	6a 6b                	push   $0x6b
  80064f:	68 10 2e 80 00       	push   $0x802e10
  800654:	e8 6a 06 00 00       	call   800cc3 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800659:	e8 e3 20 00 00       	call   802741 <sys_calculate_free_frames>
  80065e:	89 c2                	mov    %eax,%edx
  800660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800663:	39 c2                	cmp    %eax,%edx
  800665:	74 14                	je     80067b <_main+0x643>
  800667:	83 ec 04             	sub    $0x4,%esp
  80066a:	68 6d 2e 80 00       	push   $0x802e6d
  80066f:	6a 6c                	push   $0x6c
  800671:	68 10 2e 80 00       	push   $0x802e10
  800676:	e8 48 06 00 00       	call   800cc3 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80067b:	e8 c1 20 00 00       	call   802741 <sys_calculate_free_frames>
  800680:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800683:	e8 3c 21 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800688:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  80068b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	50                   	push   %eax
  800692:	e8 7c 1e 00 00       	call   802513 <free>
  800697:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  80069a:	e8 25 21 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  80069f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006a2:	29 c2                	sub    %eax,%edx
  8006a4:	89 d0                	mov    %edx,%eax
  8006a6:	3d 00 02 00 00       	cmp    $0x200,%eax
  8006ab:	74 14                	je     8006c1 <_main+0x689>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 56 2e 80 00       	push   $0x802e56
  8006b5:	6a 73                	push   $0x73
  8006b7:	68 10 2e 80 00       	push   $0x802e10
  8006bc:	e8 02 06 00 00       	call   800cc3 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006c1:	e8 7b 20 00 00       	call   802741 <sys_calculate_free_frames>
  8006c6:	89 c2                	mov    %eax,%edx
  8006c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cb:	39 c2                	cmp    %eax,%edx
  8006cd:	74 14                	je     8006e3 <_main+0x6ab>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 6d 2e 80 00       	push   $0x802e6d
  8006d7:	6a 74                	push   $0x74
  8006d9:	68 10 2e 80 00       	push   $0x802e10
  8006de:	e8 e0 05 00 00       	call   800cc3 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006e3:	e8 59 20 00 00       	call   802741 <sys_calculate_free_frames>
  8006e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006eb:	e8 d4 20 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8006f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8006f3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 14 1e 00 00       	call   802513 <free>
  8006ff:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800702:	e8 bd 20 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800707:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80070a:	29 c2                	sub    %eax,%edx
  80070c:	89 d0                	mov    %edx,%eax
  80070e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800713:	74 14                	je     800729 <_main+0x6f1>
  800715:	83 ec 04             	sub    $0x4,%esp
  800718:	68 56 2e 80 00       	push   $0x802e56
  80071d:	6a 7b                	push   $0x7b
  80071f:	68 10 2e 80 00       	push   $0x802e10
  800724:	e8 9a 05 00 00       	call   800cc3 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800729:	e8 13 20 00 00       	call   802741 <sys_calculate_free_frames>
  80072e:	89 c2                	mov    %eax,%edx
  800730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800733:	39 c2                	cmp    %eax,%edx
  800735:	74 14                	je     80074b <_main+0x713>
  800737:	83 ec 04             	sub    $0x4,%esp
  80073a:	68 6d 2e 80 00       	push   $0x802e6d
  80073f:	6a 7c                	push   $0x7c
  800741:	68 10 2e 80 00       	push   $0x802e10
  800746:	e8 78 05 00 00       	call   800cc3 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80074b:	e8 f1 1f 00 00       	call   802741 <sys_calculate_free_frames>
  800750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800753:	e8 6c 20 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800758:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  80075b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80075e:	c1 e0 09             	shl    $0x9,%eax
  800761:	83 ec 0c             	sub    $0xc,%esp
  800764:	50                   	push   %eax
  800765:	e8 07 14 00 00       	call   801b71 <malloc>
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega) || (uint32) ptr_allocations[8] > (USER_HEAP_START + 11*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800770:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800773:	89 c1                	mov    %eax,%ecx
  800775:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800778:	89 d0                	mov    %edx,%eax
  80077a:	c1 e0 02             	shl    $0x2,%eax
  80077d:	01 d0                	add    %edx,%eax
  80077f:	01 c0                	add    %eax,%eax
  800781:	01 d0                	add    %edx,%eax
  800783:	05 00 00 00 80       	add    $0x80000000,%eax
  800788:	39 c1                	cmp    %eax,%ecx
  80078a:	75 1c                	jne    8007a8 <_main+0x770>
  80078c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80078f:	89 c1                	mov    %eax,%ecx
  800791:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800794:	89 d0                	mov    %edx,%eax
  800796:	c1 e0 02             	shl    $0x2,%eax
  800799:	01 d0                	add    %edx,%eax
  80079b:	01 c0                	add    %eax,%eax
  80079d:	01 d0                	add    %edx,%eax
  80079f:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8007a4:	39 c1                	cmp    %eax,%ecx
  8007a6:	76 17                	jbe    8007bf <_main+0x787>
  8007a8:	83 ec 04             	sub    $0x4,%esp
  8007ab:	68 e0 2d 80 00       	push   $0x802de0
  8007b0:	68 85 00 00 00       	push   $0x85
  8007b5:	68 10 2e 80 00       	push   $0x802e10
  8007ba:	e8 04 05 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  8007bf:	e8 00 20 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8007c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007c7:	3d 80 00 00 00       	cmp    $0x80,%eax
  8007cc:	74 17                	je     8007e5 <_main+0x7ad>
  8007ce:	83 ec 04             	sub    $0x4,%esp
  8007d1:	68 26 2e 80 00       	push   $0x802e26
  8007d6:	68 87 00 00 00       	push   $0x87
  8007db:	68 10 2e 80 00       	push   $0x802e10
  8007e0:	e8 de 04 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007e5:	e8 57 1f 00 00       	call   802741 <sys_calculate_free_frames>
  8007ea:	89 c2                	mov    %eax,%edx
  8007ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ef:	39 c2                	cmp    %eax,%edx
  8007f1:	74 17                	je     80080a <_main+0x7d2>
  8007f3:	83 ec 04             	sub    $0x4,%esp
  8007f6:	68 43 2e 80 00       	push   $0x802e43
  8007fb:	68 88 00 00 00       	push   $0x88
  800800:	68 10 2e 80 00       	push   $0x802e10
  800805:	e8 b9 04 00 00       	call   800cc3 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80080a:	e8 32 1f 00 00       	call   802741 <sys_calculate_free_frames>
  80080f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800812:	e8 ad 1f 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800817:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800820:	83 ec 0c             	sub    $0xc,%esp
  800823:	50                   	push   %eax
  800824:	e8 48 13 00 00       	call   801b71 <malloc>
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega) || (uint32) ptr_allocations[9] > (USER_HEAP_START + 8*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80082f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800832:	89 c2                	mov    %eax,%edx
  800834:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800837:	c1 e0 03             	shl    $0x3,%eax
  80083a:	05 00 00 00 80       	add    $0x80000000,%eax
  80083f:	39 c2                	cmp    %eax,%edx
  800841:	75 14                	jne    800857 <_main+0x81f>
  800843:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800846:	89 c2                	mov    %eax,%edx
  800848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084b:	c1 e0 03             	shl    $0x3,%eax
  80084e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800853:	39 c2                	cmp    %eax,%edx
  800855:	76 17                	jbe    80086e <_main+0x836>
  800857:	83 ec 04             	sub    $0x4,%esp
  80085a:	68 e0 2d 80 00       	push   $0x802de0
  80085f:	68 8e 00 00 00       	push   $0x8e
  800864:	68 10 2e 80 00       	push   $0x802e10
  800869:	e8 55 04 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80086e:	e8 51 1f 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800873:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800876:	3d 00 01 00 00       	cmp    $0x100,%eax
  80087b:	74 17                	je     800894 <_main+0x85c>
  80087d:	83 ec 04             	sub    $0x4,%esp
  800880:	68 26 2e 80 00       	push   $0x802e26
  800885:	68 90 00 00 00       	push   $0x90
  80088a:	68 10 2e 80 00       	push   $0x802e10
  80088f:	e8 2f 04 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800894:	e8 a8 1e 00 00       	call   802741 <sys_calculate_free_frames>
  800899:	89 c2                	mov    %eax,%edx
  80089b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	74 17                	je     8008b9 <_main+0x881>
  8008a2:	83 ec 04             	sub    $0x4,%esp
  8008a5:	68 43 2e 80 00       	push   $0x802e43
  8008aa:	68 91 00 00 00       	push   $0x91
  8008af:	68 10 2e 80 00       	push   $0x802e10
  8008b4:	e8 0a 04 00 00       	call   800cc3 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8008b9:	e8 83 1e 00 00       	call   802741 <sys_calculate_free_frames>
  8008be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008c1:	e8 fe 1e 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  8008c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8008c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008cc:	89 d0                	mov    %edx,%eax
  8008ce:	c1 e0 08             	shl    $0x8,%eax
  8008d1:	29 d0                	sub    %edx,%eax
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	50                   	push   %eax
  8008d7:	e8 95 12 00 00       	call   801b71 <malloc>
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo) || (uint32) ptr_allocations[10] > (USER_HEAP_START + 11*Mega + 512*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8008e2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8008e5:	89 c1                	mov    %eax,%ecx
  8008e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008ea:	89 d0                	mov    %edx,%eax
  8008ec:	c1 e0 02             	shl    $0x2,%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	01 c0                	add    %eax,%eax
  8008f3:	01 d0                	add    %edx,%eax
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008fa:	c1 e0 09             	shl    $0x9,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	05 00 00 00 80       	add    $0x80000000,%eax
  800904:	39 c1                	cmp    %eax,%ecx
  800906:	75 26                	jne    80092e <_main+0x8f6>
  800908:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80090b:	89 c1                	mov    %eax,%ecx
  80090d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800910:	89 d0                	mov    %edx,%eax
  800912:	c1 e0 02             	shl    $0x2,%eax
  800915:	01 d0                	add    %edx,%eax
  800917:	01 c0                	add    %eax,%eax
  800919:	01 d0                	add    %edx,%eax
  80091b:	89 c2                	mov    %eax,%edx
  80091d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800920:	c1 e0 09             	shl    $0x9,%eax
  800923:	01 d0                	add    %edx,%eax
  800925:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80092a:	39 c1                	cmp    %eax,%ecx
  80092c:	76 17                	jbe    800945 <_main+0x90d>
  80092e:	83 ec 04             	sub    $0x4,%esp
  800931:	68 e0 2d 80 00       	push   $0x802de0
  800936:	68 97 00 00 00       	push   $0x97
  80093b:	68 10 2e 80 00       	push   $0x802e10
  800940:	e8 7e 03 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800945:	e8 7a 1e 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  80094a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80094d:	83 f8 40             	cmp    $0x40,%eax
  800950:	74 17                	je     800969 <_main+0x931>
  800952:	83 ec 04             	sub    $0x4,%esp
  800955:	68 26 2e 80 00       	push   $0x802e26
  80095a:	68 99 00 00 00       	push   $0x99
  80095f:	68 10 2e 80 00       	push   $0x802e10
  800964:	e8 5a 03 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800969:	e8 d3 1d 00 00       	call   802741 <sys_calculate_free_frames>
  80096e:	89 c2                	mov    %eax,%edx
  800970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800973:	39 c2                	cmp    %eax,%edx
  800975:	74 17                	je     80098e <_main+0x956>
  800977:	83 ec 04             	sub    $0x4,%esp
  80097a:	68 43 2e 80 00       	push   $0x802e43
  80097f:	68 9a 00 00 00       	push   $0x9a
  800984:	68 10 2e 80 00       	push   $0x802e10
  800989:	e8 35 03 00 00       	call   800cc3 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80098e:	e8 ae 1d 00 00       	call   802741 <sys_calculate_free_frames>
  800993:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800996:	e8 29 1e 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  80099b:	89 45 e0             	mov    %eax,-0x20(%ebp)

		ptr_allocations[11] = malloc(4*Mega - kilo);
  80099e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a1:	c1 e0 02             	shl    $0x2,%eax
  8009a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8009a7:	83 ec 0c             	sub    $0xc,%esp
  8009aa:	50                   	push   %eax
  8009ab:	e8 c1 11 00 00       	call   801b71 <malloc>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 bc             	mov    %eax,-0x44(%ebp)


		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega) || (uint32) ptr_allocations[11] > (USER_HEAP_START + 14*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8009b6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8009b9:	89 c1                	mov    %eax,%ecx
  8009bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009be:	89 d0                	mov    %edx,%eax
  8009c0:	01 c0                	add    %eax,%eax
  8009c2:	01 d0                	add    %edx,%eax
  8009c4:	01 c0                	add    %eax,%eax
  8009c6:	01 d0                	add    %edx,%eax
  8009c8:	01 c0                	add    %eax,%eax
  8009ca:	05 00 00 00 80       	add    $0x80000000,%eax
  8009cf:	39 c1                	cmp    %eax,%ecx
  8009d1:	75 1d                	jne    8009f0 <_main+0x9b8>
  8009d3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8009d6:	89 c1                	mov    %eax,%ecx
  8009d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d0                	add    %edx,%eax
  8009e1:	01 c0                	add    %eax,%eax
  8009e3:	01 d0                	add    %edx,%eax
  8009e5:	01 c0                	add    %eax,%eax
  8009e7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009ec:	39 c1                	cmp    %eax,%ecx
  8009ee:	76 17                	jbe    800a07 <_main+0x9cf>
  8009f0:	83 ec 04             	sub    $0x4,%esp
  8009f3:	68 e0 2d 80 00       	push   $0x802de0
  8009f8:	68 a3 00 00 00       	push   $0xa3
  8009fd:	68 10 2e 80 00       	push   $0x802e10
  800a02:	e8 bc 02 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800a07:	e8 b8 1d 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800a0c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a0f:	3d 00 04 00 00       	cmp    $0x400,%eax
  800a14:	74 17                	je     800a2d <_main+0x9f5>
  800a16:	83 ec 04             	sub    $0x4,%esp
  800a19:	68 26 2e 80 00       	push   $0x802e26
  800a1e:	68 a5 00 00 00       	push   $0xa5
  800a23:	68 10 2e 80 00       	push   $0x802e10
  800a28:	e8 96 02 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800a2d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800a30:	e8 0c 1d 00 00       	call   802741 <sys_calculate_free_frames>
  800a35:	29 c3                	sub    %eax,%ebx
  800a37:	89 d8                	mov    %ebx,%eax
  800a39:	83 f8 01             	cmp    $0x1,%eax
  800a3c:	74 17                	je     800a55 <_main+0xa1d>
  800a3e:	83 ec 04             	sub    $0x4,%esp
  800a41:	68 43 2e 80 00       	push   $0x802e43
  800a46:	68 a6 00 00 00       	push   $0xa6
  800a4b:	68 10 2e 80 00       	push   $0x802e10
  800a50:	e8 6e 02 00 00       	call   800cc3 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800a55:	e8 e7 1c 00 00       	call   802741 <sys_calculate_free_frames>
  800a5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a5d:	e8 62 1d 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800a62:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800a65:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a68:	83 ec 0c             	sub    $0xc,%esp
  800a6b:	50                   	push   %eax
  800a6c:	e8 a2 1a 00 00       	call   802513 <free>
  800a71:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800a74:	e8 4b 1d 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800a79:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a7c:	29 c2                	sub    %eax,%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	3d 00 01 00 00       	cmp    $0x100,%eax
  800a85:	74 17                	je     800a9e <_main+0xa66>
  800a87:	83 ec 04             	sub    $0x4,%esp
  800a8a:	68 56 2e 80 00       	push   $0x802e56
  800a8f:	68 b0 00 00 00       	push   $0xb0
  800a94:	68 10 2e 80 00       	push   $0x802e10
  800a99:	e8 25 02 00 00       	call   800cc3 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a9e:	e8 9e 1c 00 00       	call   802741 <sys_calculate_free_frames>
  800aa3:	89 c2                	mov    %eax,%edx
  800aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800aa8:	39 c2                	cmp    %eax,%edx
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 6d 2e 80 00       	push   $0x802e6d
  800ab4:	68 b1 00 00 00       	push   $0xb1
  800ab9:	68 10 2e 80 00       	push   $0x802e10
  800abe:	e8 00 02 00 00       	call   800cc3 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  800ac3:	e8 79 1c 00 00       	call   802741 <sys_calculate_free_frames>
  800ac8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800acb:	e8 f4 1c 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800ad0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  800ad3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800ad6:	83 ec 0c             	sub    $0xc,%esp
  800ad9:	50                   	push   %eax
  800ada:	e8 34 1a 00 00       	call   802513 <free>
  800adf:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800ae2:	e8 dd 1c 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800ae7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aea:	29 c2                	sub    %eax,%edx
  800aec:	89 d0                	mov    %edx,%eax
  800aee:	3d 80 00 00 00       	cmp    $0x80,%eax
  800af3:	74 17                	je     800b0c <_main+0xad4>
  800af5:	83 ec 04             	sub    $0x4,%esp
  800af8:	68 56 2e 80 00       	push   $0x802e56
  800afd:	68 b8 00 00 00       	push   $0xb8
  800b02:	68 10 2e 80 00       	push   $0x802e10
  800b07:	e8 b7 01 00 00       	call   800cc3 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800b0c:	e8 30 1c 00 00       	call   802741 <sys_calculate_free_frames>
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b16:	39 c2                	cmp    %eax,%edx
  800b18:	74 17                	je     800b31 <_main+0xaf9>
  800b1a:	83 ec 04             	sub    $0x4,%esp
  800b1d:	68 6d 2e 80 00       	push   $0x802e6d
  800b22:	68 b9 00 00 00       	push   $0xb9
  800b27:	68 10 2e 80 00       	push   $0x802e10
  800b2c:	e8 92 01 00 00       	call   800cc3 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800b31:	e8 0b 1c 00 00       	call   802741 <sys_calculate_free_frames>
  800b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b39:	e8 86 1c 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800b3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b44:	01 c0                	add    %eax,%eax
  800b46:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800b49:	83 ec 0c             	sub    $0xc,%esp
  800b4c:	50                   	push   %eax
  800b4d:	e8 1f 10 00 00       	call   801b71 <malloc>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega) || (uint32) ptr_allocations[12] > (USER_HEAP_START + 9*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800b58:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b5b:	89 c1                	mov    %eax,%ecx
  800b5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b60:	89 d0                	mov    %edx,%eax
  800b62:	c1 e0 03             	shl    $0x3,%eax
  800b65:	01 d0                	add    %edx,%eax
  800b67:	05 00 00 00 80       	add    $0x80000000,%eax
  800b6c:	39 c1                	cmp    %eax,%ecx
  800b6e:	75 18                	jne    800b88 <_main+0xb50>
  800b70:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b73:	89 c1                	mov    %eax,%ecx
  800b75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b78:	89 d0                	mov    %edx,%eax
  800b7a:	c1 e0 03             	shl    $0x3,%eax
  800b7d:	01 d0                	add    %edx,%eax
  800b7f:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800b84:	39 c1                	cmp    %eax,%ecx
  800b86:	76 17                	jbe    800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 e0 2d 80 00       	push   $0x802de0
  800b90:	68 c2 00 00 00       	push   $0xc2
  800b95:	68 10 2e 80 00       	push   $0x802e10
  800b9a:	e8 24 01 00 00       	call   800cc3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800b9f:	e8 20 1c 00 00       	call   8027c4 <sys_pf_calculate_allocated_pages>
  800ba4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800ba7:	3d 00 02 00 00       	cmp    $0x200,%eax
  800bac:	74 17                	je     800bc5 <_main+0xb8d>
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	68 26 2e 80 00       	push   $0x802e26
  800bb6:	68 c4 00 00 00       	push   $0xc4
  800bbb:	68 10 2e 80 00       	push   $0x802e10
  800bc0:	e8 fe 00 00 00       	call   800cc3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800bc5:	e8 77 1b 00 00       	call   802741 <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 43 2e 80 00       	push   $0x802e43
  800bdb:	68 c5 00 00 00       	push   $0xc5
  800be0:	68 10 2e 80 00       	push   $0x802e10
  800be5:	e8 d9 00 00 00       	call   800cc3 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800bea:	83 ec 0c             	sub    $0xc,%esp
  800bed:	68 7c 2e 80 00       	push   $0x802e7c
  800bf2:	e8 f7 01 00 00       	call   800dee <cprintf>
  800bf7:	83 c4 10             	add    $0x10,%esp

	return;
  800bfa:	90                   	nop
}
  800bfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bfe:	5b                   	pop    %ebx
  800bff:	5f                   	pop    %edi
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0c:	7e 0a                	jle    800c18 <libmain+0x16>
		binaryname = argv[0];
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 00                	mov    (%eax),%eax
  800c13:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800c18:	83 ec 08             	sub    $0x8,%esp
  800c1b:	ff 75 0c             	pushl  0xc(%ebp)
  800c1e:	ff 75 08             	pushl  0x8(%ebp)
  800c21:	e8 12 f4 ff ff       	call   800038 <_main>
  800c26:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800c29:	e8 61 1a 00 00       	call   80268f <sys_getenvid>
  800c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c34:	89 d0                	mov    %edx,%eax
  800c36:	c1 e0 03             	shl    $0x3,%eax
  800c39:	01 d0                	add    %edx,%eax
  800c3b:	01 c0                	add    %eax,%eax
  800c3d:	01 d0                	add    %edx,%eax
  800c3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c46:	01 d0                	add    %edx,%eax
  800c48:	c1 e0 03             	shl    $0x3,%eax
  800c4b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c50:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800c53:	e8 85 1b 00 00       	call   8027dd <sys_disable_interrupt>
		cprintf("**************************************\n");
  800c58:	83 ec 0c             	sub    $0xc,%esp
  800c5b:	68 dc 2e 80 00       	push   $0x802edc
  800c60:	e8 89 01 00 00       	call   800dee <cprintf>
  800c65:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6b:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800c71:	83 ec 08             	sub    $0x8,%esp
  800c74:	50                   	push   %eax
  800c75:	68 04 2f 80 00       	push   $0x802f04
  800c7a:	e8 6f 01 00 00       	call   800dee <cprintf>
  800c7f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c82:	83 ec 0c             	sub    $0xc,%esp
  800c85:	68 dc 2e 80 00       	push   $0x802edc
  800c8a:	e8 5f 01 00 00       	call   800dee <cprintf>
  800c8f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c92:	e8 60 1b 00 00       	call   8027f7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c97:	e8 19 00 00 00       	call   800cb5 <exit>
}
  800c9c:	90                   	nop
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800ca5:	83 ec 0c             	sub    $0xc,%esp
  800ca8:	6a 00                	push   $0x0
  800caa:	e8 c5 19 00 00       	call   802674 <sys_env_destroy>
  800caf:	83 c4 10             	add    $0x10,%esp
}
  800cb2:	90                   	nop
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <exit>:

void
exit(void)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800cbb:	e8 e8 19 00 00       	call   8026a8 <sys_env_exit>
}
  800cc0:	90                   	nop
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cc9:	8d 45 10             	lea    0x10(%ebp),%eax
  800ccc:	83 c0 04             	add    $0x4,%eax
  800ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800cd2:	a1 50 40 98 00       	mov    0x984050,%eax
  800cd7:	85 c0                	test   %eax,%eax
  800cd9:	74 16                	je     800cf1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800cdb:	a1 50 40 98 00       	mov    0x984050,%eax
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	50                   	push   %eax
  800ce4:	68 1d 2f 80 00       	push   $0x802f1d
  800ce9:	e8 00 01 00 00       	call   800dee <cprintf>
  800cee:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cf1:	a1 00 40 80 00       	mov    0x804000,%eax
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	50                   	push   %eax
  800cfd:	68 22 2f 80 00       	push   $0x802f22
  800d02:	e8 e7 00 00 00       	call   800dee <cprintf>
  800d07:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0d:	83 ec 08             	sub    $0x8,%esp
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	e8 7a 00 00 00       	call   800d93 <vcprintf>
  800d19:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	68 3e 2f 80 00       	push   $0x802f3e
  800d24:	e8 c5 00 00 00       	call   800dee <cprintf>
  800d29:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d2c:	e8 84 ff ff ff       	call   800cb5 <exit>

	// should not return here
	while (1) ;
  800d31:	eb fe                	jmp    800d31 <_panic+0x6e>

00800d33 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 48 01             	lea    0x1(%eax),%ecx
  800d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d44:	89 0a                	mov    %ecx,(%edx)
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	88 d1                	mov    %dl,%cl
  800d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d5c:	75 23                	jne    800d81 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	8b 00                	mov    (%eax),%eax
  800d63:	89 c2                	mov    %eax,%edx
  800d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d68:	83 c0 08             	add    $0x8,%eax
  800d6b:	83 ec 08             	sub    $0x8,%esp
  800d6e:	52                   	push   %edx
  800d6f:	50                   	push   %eax
  800d70:	e8 c9 18 00 00       	call   80263e <sys_cputs>
  800d75:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8b 40 04             	mov    0x4(%eax),%eax
  800d87:	8d 50 01             	lea    0x1(%eax),%edx
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800d90:	90                   	nop
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d9c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800da3:	00 00 00 
	b.cnt = 0;
  800da6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800dad:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800db0:	ff 75 0c             	pushl  0xc(%ebp)
  800db3:	ff 75 08             	pushl  0x8(%ebp)
  800db6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	68 33 0d 80 00       	push   $0x800d33
  800dc2:	e8 fa 01 00 00       	call   800fc1 <vprintfmt>
  800dc7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800dca:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800dd0:	83 ec 08             	sub    $0x8,%esp
  800dd3:	50                   	push   %eax
  800dd4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800dda:	83 c0 08             	add    $0x8,%eax
  800ddd:	50                   	push   %eax
  800dde:	e8 5b 18 00 00       	call   80263e <sys_cputs>
  800de3:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800de6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800dec:	c9                   	leave  
  800ded:	c3                   	ret    

00800dee <cprintf>:

int cprintf(const char *fmt, ...) {
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800df4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	83 ec 08             	sub    $0x8,%esp
  800e00:	ff 75 f4             	pushl  -0xc(%ebp)
  800e03:	50                   	push   %eax
  800e04:	e8 8a ff ff ff       	call   800d93 <vcprintf>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800e1a:	e8 be 19 00 00       	call   8027dd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800e1f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2e:	50                   	push   %eax
  800e2f:	e8 5f ff ff ff       	call   800d93 <vcprintf>
  800e34:	83 c4 10             	add    $0x10,%esp
  800e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800e3a:	e8 b8 19 00 00       	call   8027f7 <sys_enable_interrupt>
	return cnt;
  800e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	53                   	push   %ebx
  800e48:	83 ec 14             	sub    $0x14,%esp
  800e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e51:	8b 45 14             	mov    0x14(%ebp),%eax
  800e54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e57:	8b 45 18             	mov    0x18(%ebp),%eax
  800e5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e62:	77 55                	ja     800eb9 <printnum+0x75>
  800e64:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e67:	72 05                	jb     800e6e <printnum+0x2a>
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	77 4b                	ja     800eb9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e6e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e71:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e74:	8b 45 18             	mov    0x18(%ebp),%eax
  800e77:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7c:	52                   	push   %edx
  800e7d:	50                   	push   %eax
  800e7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e81:	ff 75 f0             	pushl  -0x10(%ebp)
  800e84:	e8 f3 1c 00 00       	call   802b7c <__udivdi3>
  800e89:	83 c4 10             	add    $0x10,%esp
  800e8c:	83 ec 04             	sub    $0x4,%esp
  800e8f:	ff 75 20             	pushl  0x20(%ebp)
  800e92:	53                   	push   %ebx
  800e93:	ff 75 18             	pushl  0x18(%ebp)
  800e96:	52                   	push   %edx
  800e97:	50                   	push   %eax
  800e98:	ff 75 0c             	pushl  0xc(%ebp)
  800e9b:	ff 75 08             	pushl  0x8(%ebp)
  800e9e:	e8 a1 ff ff ff       	call   800e44 <printnum>
  800ea3:	83 c4 20             	add    $0x20,%esp
  800ea6:	eb 1a                	jmp    800ec2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ea8:	83 ec 08             	sub    $0x8,%esp
  800eab:	ff 75 0c             	pushl  0xc(%ebp)
  800eae:	ff 75 20             	pushl  0x20(%ebp)
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	ff d0                	call   *%eax
  800eb6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800eb9:	ff 4d 1c             	decl   0x1c(%ebp)
  800ebc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ec0:	7f e6                	jg     800ea8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ec2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ec5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed0:	53                   	push   %ebx
  800ed1:	51                   	push   %ecx
  800ed2:	52                   	push   %edx
  800ed3:	50                   	push   %eax
  800ed4:	e8 b3 1d 00 00       	call   802c8c <__umoddi3>
  800ed9:	83 c4 10             	add    $0x10,%esp
  800edc:	05 54 31 80 00       	add    $0x803154,%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	0f be c0             	movsbl %al,%eax
  800ee6:	83 ec 08             	sub    $0x8,%esp
  800ee9:	ff 75 0c             	pushl  0xc(%ebp)
  800eec:	50                   	push   %eax
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	ff d0                	call   *%eax
  800ef2:	83 c4 10             	add    $0x10,%esp
}
  800ef5:	90                   	nop
  800ef6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800efe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f02:	7e 1c                	jle    800f20 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	8d 50 08             	lea    0x8(%eax),%edx
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	89 10                	mov    %edx,(%eax)
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8b 00                	mov    (%eax),%eax
  800f16:	83 e8 08             	sub    $0x8,%eax
  800f19:	8b 50 04             	mov    0x4(%eax),%edx
  800f1c:	8b 00                	mov    (%eax),%eax
  800f1e:	eb 40                	jmp    800f60 <getuint+0x65>
	else if (lflag)
  800f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f24:	74 1e                	je     800f44 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8b 00                	mov    (%eax),%eax
  800f2b:	8d 50 04             	lea    0x4(%eax),%edx
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	89 10                	mov    %edx,(%eax)
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8b 00                	mov    (%eax),%eax
  800f38:	83 e8 04             	sub    $0x4,%eax
  800f3b:	8b 00                	mov    (%eax),%eax
  800f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f42:	eb 1c                	jmp    800f60 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8b 00                	mov    (%eax),%eax
  800f49:	8d 50 04             	lea    0x4(%eax),%edx
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	89 10                	mov    %edx,(%eax)
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8b 00                	mov    (%eax),%eax
  800f56:	83 e8 04             	sub    $0x4,%eax
  800f59:	8b 00                	mov    (%eax),%eax
  800f5b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f65:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f69:	7e 1c                	jle    800f87 <getint+0x25>
		return va_arg(*ap, long long);
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8b 00                	mov    (%eax),%eax
  800f70:	8d 50 08             	lea    0x8(%eax),%edx
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 10                	mov    %edx,(%eax)
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8b 00                	mov    (%eax),%eax
  800f7d:	83 e8 08             	sub    $0x8,%eax
  800f80:	8b 50 04             	mov    0x4(%eax),%edx
  800f83:	8b 00                	mov    (%eax),%eax
  800f85:	eb 38                	jmp    800fbf <getint+0x5d>
	else if (lflag)
  800f87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f8b:	74 1a                	je     800fa7 <getint+0x45>
		return va_arg(*ap, long);
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8b 00                	mov    (%eax),%eax
  800f92:	8d 50 04             	lea    0x4(%eax),%edx
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	89 10                	mov    %edx,(%eax)
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8b 00                	mov    (%eax),%eax
  800f9f:	83 e8 04             	sub    $0x4,%eax
  800fa2:	8b 00                	mov    (%eax),%eax
  800fa4:	99                   	cltd   
  800fa5:	eb 18                	jmp    800fbf <getint+0x5d>
	else
		return va_arg(*ap, int);
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8b 00                	mov    (%eax),%eax
  800fac:	8d 50 04             	lea    0x4(%eax),%edx
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	89 10                	mov    %edx,(%eax)
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8b 00                	mov    (%eax),%eax
  800fb9:	83 e8 04             	sub    $0x4,%eax
  800fbc:	8b 00                	mov    (%eax),%eax
  800fbe:	99                   	cltd   
}
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
  800fc6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fc9:	eb 17                	jmp    800fe2 <vprintfmt+0x21>
			if (ch == '\0')
  800fcb:	85 db                	test   %ebx,%ebx
  800fcd:	0f 84 af 03 00 00    	je     801382 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800fd3:	83 ec 08             	sub    $0x8,%esp
  800fd6:	ff 75 0c             	pushl  0xc(%ebp)
  800fd9:	53                   	push   %ebx
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe5:	8d 50 01             	lea    0x1(%eax),%edx
  800fe8:	89 55 10             	mov    %edx,0x10(%ebp)
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	0f b6 d8             	movzbl %al,%ebx
  800ff0:	83 fb 25             	cmp    $0x25,%ebx
  800ff3:	75 d6                	jne    800fcb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ff5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ff9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801000:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801007:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80100e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801015:	8b 45 10             	mov    0x10(%ebp),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	89 55 10             	mov    %edx,0x10(%ebp)
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 d8             	movzbl %al,%ebx
  801023:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801026:	83 f8 55             	cmp    $0x55,%eax
  801029:	0f 87 2b 03 00 00    	ja     80135a <vprintfmt+0x399>
  80102f:	8b 04 85 78 31 80 00 	mov    0x803178(,%eax,4),%eax
  801036:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801038:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80103c:	eb d7                	jmp    801015 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80103e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801042:	eb d1                	jmp    801015 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801044:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80104b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80104e:	89 d0                	mov    %edx,%eax
  801050:	c1 e0 02             	shl    $0x2,%eax
  801053:	01 d0                	add    %edx,%eax
  801055:	01 c0                	add    %eax,%eax
  801057:	01 d8                	add    %ebx,%eax
  801059:	83 e8 30             	sub    $0x30,%eax
  80105c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80105f:	8b 45 10             	mov    0x10(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801067:	83 fb 2f             	cmp    $0x2f,%ebx
  80106a:	7e 3e                	jle    8010aa <vprintfmt+0xe9>
  80106c:	83 fb 39             	cmp    $0x39,%ebx
  80106f:	7f 39                	jg     8010aa <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801071:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801074:	eb d5                	jmp    80104b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801076:	8b 45 14             	mov    0x14(%ebp),%eax
  801079:	83 c0 04             	add    $0x4,%eax
  80107c:	89 45 14             	mov    %eax,0x14(%ebp)
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	83 e8 04             	sub    $0x4,%eax
  801085:	8b 00                	mov    (%eax),%eax
  801087:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80108a:	eb 1f                	jmp    8010ab <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80108c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801090:	79 83                	jns    801015 <vprintfmt+0x54>
				width = 0;
  801092:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801099:	e9 77 ff ff ff       	jmp    801015 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80109e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8010a5:	e9 6b ff ff ff       	jmp    801015 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8010aa:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8010ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010af:	0f 89 60 ff ff ff    	jns    801015 <vprintfmt+0x54>
				width = precision, precision = -1;
  8010b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010bb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8010c2:	e9 4e ff ff ff       	jmp    801015 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8010c7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8010ca:	e9 46 ff ff ff       	jmp    801015 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8010cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d2:	83 c0 04             	add    $0x4,%eax
  8010d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010db:	83 e8 04             	sub    $0x4,%eax
  8010de:	8b 00                	mov    (%eax),%eax
  8010e0:	83 ec 08             	sub    $0x8,%esp
  8010e3:	ff 75 0c             	pushl  0xc(%ebp)
  8010e6:	50                   	push   %eax
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	ff d0                	call   *%eax
  8010ec:	83 c4 10             	add    $0x10,%esp
			break;
  8010ef:	e9 89 02 00 00       	jmp    80137d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8010f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f7:	83 c0 04             	add    $0x4,%eax
  8010fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8010fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801100:	83 e8 04             	sub    $0x4,%eax
  801103:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801105:	85 db                	test   %ebx,%ebx
  801107:	79 02                	jns    80110b <vprintfmt+0x14a>
				err = -err;
  801109:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80110b:	83 fb 64             	cmp    $0x64,%ebx
  80110e:	7f 0b                	jg     80111b <vprintfmt+0x15a>
  801110:	8b 34 9d c0 2f 80 00 	mov    0x802fc0(,%ebx,4),%esi
  801117:	85 f6                	test   %esi,%esi
  801119:	75 19                	jne    801134 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80111b:	53                   	push   %ebx
  80111c:	68 65 31 80 00       	push   $0x803165
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	ff 75 08             	pushl  0x8(%ebp)
  801127:	e8 5e 02 00 00       	call   80138a <printfmt>
  80112c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80112f:	e9 49 02 00 00       	jmp    80137d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801134:	56                   	push   %esi
  801135:	68 6e 31 80 00       	push   $0x80316e
  80113a:	ff 75 0c             	pushl  0xc(%ebp)
  80113d:	ff 75 08             	pushl  0x8(%ebp)
  801140:	e8 45 02 00 00       	call   80138a <printfmt>
  801145:	83 c4 10             	add    $0x10,%esp
			break;
  801148:	e9 30 02 00 00       	jmp    80137d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80114d:	8b 45 14             	mov    0x14(%ebp),%eax
  801150:	83 c0 04             	add    $0x4,%eax
  801153:	89 45 14             	mov    %eax,0x14(%ebp)
  801156:	8b 45 14             	mov    0x14(%ebp),%eax
  801159:	83 e8 04             	sub    $0x4,%eax
  80115c:	8b 30                	mov    (%eax),%esi
  80115e:	85 f6                	test   %esi,%esi
  801160:	75 05                	jne    801167 <vprintfmt+0x1a6>
				p = "(null)";
  801162:	be 71 31 80 00       	mov    $0x803171,%esi
			if (width > 0 && padc != '-')
  801167:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80116b:	7e 6d                	jle    8011da <vprintfmt+0x219>
  80116d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801171:	74 67                	je     8011da <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801173:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	50                   	push   %eax
  80117a:	56                   	push   %esi
  80117b:	e8 0c 03 00 00       	call   80148c <strnlen>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801186:	eb 16                	jmp    80119e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801188:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	ff 75 0c             	pushl  0xc(%ebp)
  801192:	50                   	push   %eax
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	ff d0                	call   *%eax
  801198:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80119b:	ff 4d e4             	decl   -0x1c(%ebp)
  80119e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a2:	7f e4                	jg     801188 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011a4:	eb 34                	jmp    8011da <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8011a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011aa:	74 1c                	je     8011c8 <vprintfmt+0x207>
  8011ac:	83 fb 1f             	cmp    $0x1f,%ebx
  8011af:	7e 05                	jle    8011b6 <vprintfmt+0x1f5>
  8011b1:	83 fb 7e             	cmp    $0x7e,%ebx
  8011b4:	7e 12                	jle    8011c8 <vprintfmt+0x207>
					putch('?', putdat);
  8011b6:	83 ec 08             	sub    $0x8,%esp
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	6a 3f                	push   $0x3f
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	ff d0                	call   *%eax
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	eb 0f                	jmp    8011d7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	53                   	push   %ebx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	ff d0                	call   *%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8011da:	89 f0                	mov    %esi,%eax
  8011dc:	8d 70 01             	lea    0x1(%eax),%esi
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	0f be d8             	movsbl %al,%ebx
  8011e4:	85 db                	test   %ebx,%ebx
  8011e6:	74 24                	je     80120c <vprintfmt+0x24b>
  8011e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011ec:	78 b8                	js     8011a6 <vprintfmt+0x1e5>
  8011ee:	ff 4d e0             	decl   -0x20(%ebp)
  8011f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011f5:	79 af                	jns    8011a6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011f7:	eb 13                	jmp    80120c <vprintfmt+0x24b>
				putch(' ', putdat);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 0c             	pushl  0xc(%ebp)
  8011ff:	6a 20                	push   $0x20
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	ff d0                	call   *%eax
  801206:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801209:	ff 4d e4             	decl   -0x1c(%ebp)
  80120c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801210:	7f e7                	jg     8011f9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801212:	e9 66 01 00 00       	jmp    80137d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	ff 75 e8             	pushl  -0x18(%ebp)
  80121d:	8d 45 14             	lea    0x14(%ebp),%eax
  801220:	50                   	push   %eax
  801221:	e8 3c fd ff ff       	call   800f62 <getint>
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80122c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80122f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801232:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801235:	85 d2                	test   %edx,%edx
  801237:	79 23                	jns    80125c <vprintfmt+0x29b>
				putch('-', putdat);
  801239:	83 ec 08             	sub    $0x8,%esp
  80123c:	ff 75 0c             	pushl  0xc(%ebp)
  80123f:	6a 2d                	push   $0x2d
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	ff d0                	call   *%eax
  801246:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124f:	f7 d8                	neg    %eax
  801251:	83 d2 00             	adc    $0x0,%edx
  801254:	f7 da                	neg    %edx
  801256:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801259:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80125c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801263:	e9 bc 00 00 00       	jmp    801324 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801268:	83 ec 08             	sub    $0x8,%esp
  80126b:	ff 75 e8             	pushl  -0x18(%ebp)
  80126e:	8d 45 14             	lea    0x14(%ebp),%eax
  801271:	50                   	push   %eax
  801272:	e8 84 fc ff ff       	call   800efb <getuint>
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80127d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801280:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801287:	e9 98 00 00 00       	jmp    801324 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	ff 75 0c             	pushl  0xc(%ebp)
  801292:	6a 58                	push   $0x58
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	ff d0                	call   *%eax
  801299:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	ff 75 0c             	pushl  0xc(%ebp)
  8012a2:	6a 58                	push   $0x58
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8012ac:	83 ec 08             	sub    $0x8,%esp
  8012af:	ff 75 0c             	pushl  0xc(%ebp)
  8012b2:	6a 58                	push   $0x58
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	ff d0                	call   *%eax
  8012b9:	83 c4 10             	add    $0x10,%esp
			break;
  8012bc:	e9 bc 00 00 00       	jmp    80137d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	ff 75 0c             	pushl  0xc(%ebp)
  8012c7:	6a 30                	push   $0x30
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	ff d0                	call   *%eax
  8012ce:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8012d1:	83 ec 08             	sub    $0x8,%esp
  8012d4:	ff 75 0c             	pushl  0xc(%ebp)
  8012d7:	6a 78                	push   $0x78
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	ff d0                	call   *%eax
  8012de:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8012e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e4:	83 c0 04             	add    $0x4,%eax
  8012e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8012ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ed:	83 e8 04             	sub    $0x4,%eax
  8012f0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8012f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8012fc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801303:	eb 1f                	jmp    801324 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801305:	83 ec 08             	sub    $0x8,%esp
  801308:	ff 75 e8             	pushl  -0x18(%ebp)
  80130b:	8d 45 14             	lea    0x14(%ebp),%eax
  80130e:	50                   	push   %eax
  80130f:	e8 e7 fb ff ff       	call   800efb <getuint>
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80131a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80131d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801324:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80132b:	83 ec 04             	sub    $0x4,%esp
  80132e:	52                   	push   %edx
  80132f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801332:	50                   	push   %eax
  801333:	ff 75 f4             	pushl  -0xc(%ebp)
  801336:	ff 75 f0             	pushl  -0x10(%ebp)
  801339:	ff 75 0c             	pushl  0xc(%ebp)
  80133c:	ff 75 08             	pushl  0x8(%ebp)
  80133f:	e8 00 fb ff ff       	call   800e44 <printnum>
  801344:	83 c4 20             	add    $0x20,%esp
			break;
  801347:	eb 34                	jmp    80137d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	ff 75 0c             	pushl  0xc(%ebp)
  80134f:	53                   	push   %ebx
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	ff d0                	call   *%eax
  801355:	83 c4 10             	add    $0x10,%esp
			break;
  801358:	eb 23                	jmp    80137d <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	ff 75 0c             	pushl  0xc(%ebp)
  801360:	6a 25                	push   $0x25
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	ff d0                	call   *%eax
  801367:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80136a:	ff 4d 10             	decl   0x10(%ebp)
  80136d:	eb 03                	jmp    801372 <vprintfmt+0x3b1>
  80136f:	ff 4d 10             	decl   0x10(%ebp)
  801372:	8b 45 10             	mov    0x10(%ebp),%eax
  801375:	48                   	dec    %eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	3c 25                	cmp    $0x25,%al
  80137a:	75 f3                	jne    80136f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80137c:	90                   	nop
		}
	}
  80137d:	e9 47 fc ff ff       	jmp    800fc9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801382:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801383:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801386:	5b                   	pop    %ebx
  801387:	5e                   	pop    %esi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801390:	8d 45 10             	lea    0x10(%ebp),%eax
  801393:	83 c0 04             	add    $0x4,%eax
  801396:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801399:	8b 45 10             	mov    0x10(%ebp),%eax
  80139c:	ff 75 f4             	pushl  -0xc(%ebp)
  80139f:	50                   	push   %eax
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	ff 75 08             	pushl  0x8(%ebp)
  8013a6:	e8 16 fc ff ff       	call   800fc1 <vprintfmt>
  8013ab:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8013ae:	90                   	nop
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	8b 40 08             	mov    0x8(%eax),%eax
  8013ba:	8d 50 01             	lea    0x1(%eax),%edx
  8013bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	8b 10                	mov    (%eax),%edx
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	8b 40 04             	mov    0x4(%eax),%eax
  8013ce:	39 c2                	cmp    %eax,%edx
  8013d0:	73 12                	jae    8013e4 <sprintputch+0x33>
		*b->buf++ = ch;
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dd:	89 0a                	mov    %ecx,(%edx)
  8013df:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e2:	88 10                	mov    %dl,(%eax)
}
  8013e4:	90                   	nop
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    

008013e7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	01 d0                	add    %edx,%eax
  8013fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801408:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80140c:	74 06                	je     801414 <vsnprintf+0x2d>
  80140e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801412:	7f 07                	jg     80141b <vsnprintf+0x34>
		return -E_INVAL;
  801414:	b8 03 00 00 00       	mov    $0x3,%eax
  801419:	eb 20                	jmp    80143b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80141b:	ff 75 14             	pushl  0x14(%ebp)
  80141e:	ff 75 10             	pushl  0x10(%ebp)
  801421:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	68 b1 13 80 00       	push   $0x8013b1
  80142a:	e8 92 fb ff ff       	call   800fc1 <vprintfmt>
  80142f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801432:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801435:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801438:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801443:	8d 45 10             	lea    0x10(%ebp),%eax
  801446:	83 c0 04             	add    $0x4,%eax
  801449:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80144c:	8b 45 10             	mov    0x10(%ebp),%eax
  80144f:	ff 75 f4             	pushl  -0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	ff 75 0c             	pushl  0xc(%ebp)
  801456:	ff 75 08             	pushl  0x8(%ebp)
  801459:	e8 89 ff ff ff       	call   8013e7 <vsnprintf>
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801464:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80146f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801476:	eb 06                	jmp    80147e <strlen+0x15>
		n++;
  801478:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80147b:	ff 45 08             	incl   0x8(%ebp)
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	75 f1                	jne    801478 <strlen+0xf>
		n++;
	return n;
  801487:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801499:	eb 09                	jmp    8014a4 <strnlen+0x18>
		n++;
  80149b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80149e:	ff 45 08             	incl   0x8(%ebp)
  8014a1:	ff 4d 0c             	decl   0xc(%ebp)
  8014a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a8:	74 09                	je     8014b3 <strnlen+0x27>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	75 e8                	jne    80149b <strnlen+0xf>
		n++;
	return n;
  8014b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
  8014bb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8014c4:	90                   	nop
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	8d 50 01             	lea    0x1(%eax),%edx
  8014cb:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014d7:	8a 12                	mov    (%edx),%dl
  8014d9:	88 10                	mov    %dl,(%eax)
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	84 c0                	test   %al,%al
  8014df:	75 e4                	jne    8014c5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014f9:	eb 1f                	jmp    80151a <strncpy+0x34>
		*dst++ = *src;
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8d 50 01             	lea    0x1(%eax),%edx
  801501:	89 55 08             	mov    %edx,0x8(%ebp)
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	8a 12                	mov    (%edx),%dl
  801509:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	8a 00                	mov    (%eax),%al
  801510:	84 c0                	test   %al,%al
  801512:	74 03                	je     801517 <strncpy+0x31>
			src++;
  801514:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801517:	ff 45 fc             	incl   -0x4(%ebp)
  80151a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801520:	72 d9                	jb     8014fb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801522:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801533:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801537:	74 30                	je     801569 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801539:	eb 16                	jmp    801551 <strlcpy+0x2a>
			*dst++ = *src++;
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8d 50 01             	lea    0x1(%eax),%edx
  801541:	89 55 08             	mov    %edx,0x8(%ebp)
  801544:	8b 55 0c             	mov    0xc(%ebp),%edx
  801547:	8d 4a 01             	lea    0x1(%edx),%ecx
  80154a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154d:	8a 12                	mov    (%edx),%dl
  80154f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801551:	ff 4d 10             	decl   0x10(%ebp)
  801554:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801558:	74 09                	je     801563 <strlcpy+0x3c>
  80155a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	84 c0                	test   %al,%al
  801561:	75 d8                	jne    80153b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801569:	8b 55 08             	mov    0x8(%ebp),%edx
  80156c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156f:	29 c2                	sub    %eax,%edx
  801571:	89 d0                	mov    %edx,%eax
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801578:	eb 06                	jmp    801580 <strcmp+0xb>
		p++, q++;
  80157a:	ff 45 08             	incl   0x8(%ebp)
  80157d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	74 0e                	je     801597 <strcmp+0x22>
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	8a 10                	mov    (%eax),%dl
  80158e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	38 c2                	cmp    %al,%dl
  801595:	74 e3                	je     80157a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f b6 d0             	movzbl %al,%edx
  80159f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	0f b6 c0             	movzbl %al,%eax
  8015a7:	29 c2                	sub    %eax,%edx
  8015a9:	89 d0                	mov    %edx,%eax
}
  8015ab:	5d                   	pop    %ebp
  8015ac:	c3                   	ret    

008015ad <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015b0:	eb 09                	jmp    8015bb <strncmp+0xe>
		n--, p++, q++;
  8015b2:	ff 4d 10             	decl   0x10(%ebp)
  8015b5:	ff 45 08             	incl   0x8(%ebp)
  8015b8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015bf:	74 17                	je     8015d8 <strncmp+0x2b>
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	84 c0                	test   %al,%al
  8015c8:	74 0e                	je     8015d8 <strncmp+0x2b>
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	8a 10                	mov    (%eax),%dl
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	38 c2                	cmp    %al,%dl
  8015d6:	74 da                	je     8015b2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015dc:	75 07                	jne    8015e5 <strncmp+0x38>
		return 0;
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e3:	eb 14                	jmp    8015f9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	8a 00                	mov    (%eax),%al
  8015ea:	0f b6 d0             	movzbl %al,%edx
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	0f b6 c0             	movzbl %al,%eax
  8015f5:	29 c2                	sub    %eax,%edx
  8015f7:	89 d0                	mov    %edx,%eax
}
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    

008015fb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801607:	eb 12                	jmp    80161b <strchr+0x20>
		if (*s == c)
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8a 00                	mov    (%eax),%al
  80160e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801611:	75 05                	jne    801618 <strchr+0x1d>
			return (char *) s;
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	eb 11                	jmp    801629 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801618:	ff 45 08             	incl   0x8(%ebp)
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	84 c0                	test   %al,%al
  801622:	75 e5                	jne    801609 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	8b 45 0c             	mov    0xc(%ebp),%eax
  801634:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801637:	eb 0d                	jmp    801646 <strfind+0x1b>
		if (*s == c)
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	8a 00                	mov    (%eax),%al
  80163e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801641:	74 0e                	je     801651 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801643:	ff 45 08             	incl   0x8(%ebp)
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	84 c0                	test   %al,%al
  80164d:	75 ea                	jne    801639 <strfind+0xe>
  80164f:	eb 01                	jmp    801652 <strfind+0x27>
		if (*s == c)
			break;
  801651:	90                   	nop
	return (char *) s;
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801669:	eb 0e                	jmp    801679 <memset+0x22>
		*p++ = c;
  80166b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166e:	8d 50 01             	lea    0x1(%eax),%edx
  801671:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801674:	8b 55 0c             	mov    0xc(%ebp),%edx
  801677:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801679:	ff 4d f8             	decl   -0x8(%ebp)
  80167c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801680:	79 e9                	jns    80166b <memset+0x14>
		*p++ = c;

	return v;
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80168d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801690:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801699:	eb 16                	jmp    8016b1 <memcpy+0x2a>
		*d++ = *s++;
  80169b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169e:	8d 50 01             	lea    0x1(%eax),%edx
  8016a1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016aa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ad:	8a 12                	mov    (%edx),%dl
  8016af:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8016b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	75 dd                	jne    80169b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8016c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016db:	73 50                	jae    80172d <memmove+0x6a>
  8016dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e3:	01 d0                	add    %edx,%eax
  8016e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016e8:	76 43                	jbe    80172d <memmove+0x6a>
		s += n;
  8016ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ed:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016f6:	eb 10                	jmp    801708 <memmove+0x45>
			*--d = *--s;
  8016f8:	ff 4d f8             	decl   -0x8(%ebp)
  8016fb:	ff 4d fc             	decl   -0x4(%ebp)
  8016fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801701:	8a 10                	mov    (%eax),%dl
  801703:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801706:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80170e:	89 55 10             	mov    %edx,0x10(%ebp)
  801711:	85 c0                	test   %eax,%eax
  801713:	75 e3                	jne    8016f8 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801715:	eb 23                	jmp    80173a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801717:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171a:	8d 50 01             	lea    0x1(%eax),%edx
  80171d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801720:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801723:	8d 4a 01             	lea    0x1(%edx),%ecx
  801726:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801729:	8a 12                	mov    (%edx),%dl
  80172b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80172d:	8b 45 10             	mov    0x10(%ebp),%eax
  801730:	8d 50 ff             	lea    -0x1(%eax),%edx
  801733:	89 55 10             	mov    %edx,0x10(%ebp)
  801736:	85 c0                	test   %eax,%eax
  801738:	75 dd                	jne    801717 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80174b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801751:	eb 2a                	jmp    80177d <memcmp+0x3e>
		if (*s1 != *s2)
  801753:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801756:	8a 10                	mov    (%eax),%dl
  801758:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80175b:	8a 00                	mov    (%eax),%al
  80175d:	38 c2                	cmp    %al,%dl
  80175f:	74 16                	je     801777 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	8a 00                	mov    (%eax),%al
  801766:	0f b6 d0             	movzbl %al,%edx
  801769:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176c:	8a 00                	mov    (%eax),%al
  80176e:	0f b6 c0             	movzbl %al,%eax
  801771:	29 c2                	sub    %eax,%edx
  801773:	89 d0                	mov    %edx,%eax
  801775:	eb 18                	jmp    80178f <memcmp+0x50>
		s1++, s2++;
  801777:	ff 45 fc             	incl   -0x4(%ebp)
  80177a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	8d 50 ff             	lea    -0x1(%eax),%edx
  801783:	89 55 10             	mov    %edx,0x10(%ebp)
  801786:	85 c0                	test   %eax,%eax
  801788:	75 c9                	jne    801753 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801797:	8b 55 08             	mov    0x8(%ebp),%edx
  80179a:	8b 45 10             	mov    0x10(%ebp),%eax
  80179d:	01 d0                	add    %edx,%eax
  80179f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017a2:	eb 15                	jmp    8017b9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	0f b6 d0             	movzbl %al,%edx
  8017ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017af:	0f b6 c0             	movzbl %al,%eax
  8017b2:	39 c2                	cmp    %eax,%edx
  8017b4:	74 0d                	je     8017c3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017b6:	ff 45 08             	incl   0x8(%ebp)
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017bf:	72 e3                	jb     8017a4 <memfind+0x13>
  8017c1:	eb 01                	jmp    8017c4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017c3:	90                   	nop
	return (void *) s;
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017dd:	eb 03                	jmp    8017e2 <strtol+0x19>
		s++;
  8017df:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 20                	cmp    $0x20,%al
  8017e9:	74 f4                	je     8017df <strtol+0x16>
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 09                	cmp    $0x9,%al
  8017f2:	74 eb                	je     8017df <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 2b                	cmp    $0x2b,%al
  8017fb:	75 05                	jne    801802 <strtol+0x39>
		s++;
  8017fd:	ff 45 08             	incl   0x8(%ebp)
  801800:	eb 13                	jmp    801815 <strtol+0x4c>
	else if (*s == '-')
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	8a 00                	mov    (%eax),%al
  801807:	3c 2d                	cmp    $0x2d,%al
  801809:	75 0a                	jne    801815 <strtol+0x4c>
		s++, neg = 1;
  80180b:	ff 45 08             	incl   0x8(%ebp)
  80180e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801819:	74 06                	je     801821 <strtol+0x58>
  80181b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80181f:	75 20                	jne    801841 <strtol+0x78>
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	8a 00                	mov    (%eax),%al
  801826:	3c 30                	cmp    $0x30,%al
  801828:	75 17                	jne    801841 <strtol+0x78>
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	40                   	inc    %eax
  80182e:	8a 00                	mov    (%eax),%al
  801830:	3c 78                	cmp    $0x78,%al
  801832:	75 0d                	jne    801841 <strtol+0x78>
		s += 2, base = 16;
  801834:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801838:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80183f:	eb 28                	jmp    801869 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801841:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801845:	75 15                	jne    80185c <strtol+0x93>
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	3c 30                	cmp    $0x30,%al
  80184e:	75 0c                	jne    80185c <strtol+0x93>
		s++, base = 8;
  801850:	ff 45 08             	incl   0x8(%ebp)
  801853:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80185a:	eb 0d                	jmp    801869 <strtol+0xa0>
	else if (base == 0)
  80185c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801860:	75 07                	jne    801869 <strtol+0xa0>
		base = 10;
  801862:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 2f                	cmp    $0x2f,%al
  801870:	7e 19                	jle    80188b <strtol+0xc2>
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	3c 39                	cmp    $0x39,%al
  801879:	7f 10                	jg     80188b <strtol+0xc2>
			dig = *s - '0';
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	8a 00                	mov    (%eax),%al
  801880:	0f be c0             	movsbl %al,%eax
  801883:	83 e8 30             	sub    $0x30,%eax
  801886:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801889:	eb 42                	jmp    8018cd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	8a 00                	mov    (%eax),%al
  801890:	3c 60                	cmp    $0x60,%al
  801892:	7e 19                	jle    8018ad <strtol+0xe4>
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	8a 00                	mov    (%eax),%al
  801899:	3c 7a                	cmp    $0x7a,%al
  80189b:	7f 10                	jg     8018ad <strtol+0xe4>
			dig = *s - 'a' + 10;
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8a 00                	mov    (%eax),%al
  8018a2:	0f be c0             	movsbl %al,%eax
  8018a5:	83 e8 57             	sub    $0x57,%eax
  8018a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018ab:	eb 20                	jmp    8018cd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	8a 00                	mov    (%eax),%al
  8018b2:	3c 40                	cmp    $0x40,%al
  8018b4:	7e 39                	jle    8018ef <strtol+0x126>
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	3c 5a                	cmp    $0x5a,%al
  8018bd:	7f 30                	jg     8018ef <strtol+0x126>
			dig = *s - 'A' + 10;
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	8a 00                	mov    (%eax),%al
  8018c4:	0f be c0             	movsbl %al,%eax
  8018c7:	83 e8 37             	sub    $0x37,%eax
  8018ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018d3:	7d 19                	jge    8018ee <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018d5:	ff 45 08             	incl   0x8(%ebp)
  8018d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018db:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018df:	89 c2                	mov    %eax,%edx
  8018e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e4:	01 d0                	add    %edx,%eax
  8018e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018e9:	e9 7b ff ff ff       	jmp    801869 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018ee:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018f3:	74 08                	je     8018fd <strtol+0x134>
		*endptr = (char *) s;
  8018f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801901:	74 07                	je     80190a <strtol+0x141>
  801903:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801906:	f7 d8                	neg    %eax
  801908:	eb 03                	jmp    80190d <strtol+0x144>
  80190a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <ltostr>:

void
ltostr(long value, char *str)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801915:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80191c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801923:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801927:	79 13                	jns    80193c <ltostr+0x2d>
	{
		neg = 1;
  801929:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801936:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801939:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801944:	99                   	cltd   
  801945:	f7 f9                	idiv   %ecx
  801947:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80194a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194d:	8d 50 01             	lea    0x1(%eax),%edx
  801950:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801953:	89 c2                	mov    %eax,%edx
  801955:	8b 45 0c             	mov    0xc(%ebp),%eax
  801958:	01 d0                	add    %edx,%eax
  80195a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80195d:	83 c2 30             	add    $0x30,%edx
  801960:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801962:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801965:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80196a:	f7 e9                	imul   %ecx
  80196c:	c1 fa 02             	sar    $0x2,%edx
  80196f:	89 c8                	mov    %ecx,%eax
  801971:	c1 f8 1f             	sar    $0x1f,%eax
  801974:	29 c2                	sub    %eax,%edx
  801976:	89 d0                	mov    %edx,%eax
  801978:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80197b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80197e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801983:	f7 e9                	imul   %ecx
  801985:	c1 fa 02             	sar    $0x2,%edx
  801988:	89 c8                	mov    %ecx,%eax
  80198a:	c1 f8 1f             	sar    $0x1f,%eax
  80198d:	29 c2                	sub    %eax,%edx
  80198f:	89 d0                	mov    %edx,%eax
  801991:	c1 e0 02             	shl    $0x2,%eax
  801994:	01 d0                	add    %edx,%eax
  801996:	01 c0                	add    %eax,%eax
  801998:	29 c1                	sub    %eax,%ecx
  80199a:	89 ca                	mov    %ecx,%edx
  80199c:	85 d2                	test   %edx,%edx
  80199e:	75 9c                	jne    80193c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019aa:	48                   	dec    %eax
  8019ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019b2:	74 3d                	je     8019f1 <ltostr+0xe2>
		start = 1 ;
  8019b4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019bb:	eb 34                	jmp    8019f1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8019bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	01 d0                	add    %edx,%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d0:	01 c2                	add    %eax,%edx
  8019d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d8:	01 c8                	add    %ecx,%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e4:	01 c2                	add    %eax,%edx
  8019e6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019e9:	88 02                	mov    %al,(%edx)
		start++ ;
  8019eb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019ee:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019f7:	7c c4                	jl     8019bd <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ff:	01 d0                	add    %edx,%eax
  801a01:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a04:	90                   	nop
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a0d:	ff 75 08             	pushl  0x8(%ebp)
  801a10:	e8 54 fa ff ff       	call   801469 <strlen>
  801a15:	83 c4 04             	add    $0x4,%esp
  801a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	e8 46 fa ff ff       	call   801469 <strlen>
  801a23:	83 c4 04             	add    $0x4,%esp
  801a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a37:	eb 17                	jmp    801a50 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	01 c2                	add    %eax,%edx
  801a41:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	01 c8                	add    %ecx,%eax
  801a49:	8a 00                	mov    (%eax),%al
  801a4b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a4d:	ff 45 fc             	incl   -0x4(%ebp)
  801a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a53:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a56:	7c e1                	jl     801a39 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a58:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a5f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a66:	eb 1f                	jmp    801a87 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a6b:	8d 50 01             	lea    0x1(%eax),%edx
  801a6e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a71:	89 c2                	mov    %eax,%edx
  801a73:	8b 45 10             	mov    0x10(%ebp),%eax
  801a76:	01 c2                	add    %eax,%edx
  801a78:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7e:	01 c8                	add    %ecx,%eax
  801a80:	8a 00                	mov    (%eax),%al
  801a82:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a84:	ff 45 f8             	incl   -0x8(%ebp)
  801a87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a8a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a8d:	7c d9                	jl     801a68 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a92:	8b 45 10             	mov    0x10(%ebp),%eax
  801a95:	01 d0                	add    %edx,%eax
  801a97:	c6 00 00             	movb   $0x0,(%eax)
}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  801aac:	8b 00                	mov    (%eax),%eax
  801aae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ab5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab8:	01 d0                	add    %edx,%eax
  801aba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ac0:	eb 0c                	jmp    801ace <strsplit+0x31>
			*string++ = 0;
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8d 50 01             	lea    0x1(%eax),%edx
  801ac8:	89 55 08             	mov    %edx,0x8(%ebp)
  801acb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	8a 00                	mov    (%eax),%al
  801ad3:	84 c0                	test   %al,%al
  801ad5:	74 18                	je     801aef <strsplit+0x52>
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	8a 00                	mov    (%eax),%al
  801adc:	0f be c0             	movsbl %al,%eax
  801adf:	50                   	push   %eax
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	e8 13 fb ff ff       	call   8015fb <strchr>
  801ae8:	83 c4 08             	add    $0x8,%esp
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	75 d3                	jne    801ac2 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	8a 00                	mov    (%eax),%al
  801af4:	84 c0                	test   %al,%al
  801af6:	74 5a                	je     801b52 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801af8:	8b 45 14             	mov    0x14(%ebp),%eax
  801afb:	8b 00                	mov    (%eax),%eax
  801afd:	83 f8 0f             	cmp    $0xf,%eax
  801b00:	75 07                	jne    801b09 <strsplit+0x6c>
		{
			return 0;
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax
  801b07:	eb 66                	jmp    801b6f <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b09:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0c:	8b 00                	mov    (%eax),%eax
  801b0e:	8d 48 01             	lea    0x1(%eax),%ecx
  801b11:	8b 55 14             	mov    0x14(%ebp),%edx
  801b14:	89 0a                	mov    %ecx,(%edx)
  801b16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b20:	01 c2                	add    %eax,%edx
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b27:	eb 03                	jmp    801b2c <strsplit+0x8f>
			string++;
  801b29:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	8a 00                	mov    (%eax),%al
  801b31:	84 c0                	test   %al,%al
  801b33:	74 8b                	je     801ac0 <strsplit+0x23>
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	8a 00                	mov    (%eax),%al
  801b3a:	0f be c0             	movsbl %al,%eax
  801b3d:	50                   	push   %eax
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	e8 b5 fa ff ff       	call   8015fb <strchr>
  801b46:	83 c4 08             	add    $0x8,%esp
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	74 dc                	je     801b29 <strsplit+0x8c>
			string++;
	}
  801b4d:	e9 6e ff ff ff       	jmp    801ac0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b52:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b53:	8b 45 14             	mov    0x14(%ebp),%eax
  801b56:	8b 00                	mov    (%eax),%eax
  801b58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b62:	01 d0                	add    %edx,%eax
  801b64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b6a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801b7a:	e8 7d 0f 00 00       	call   802afc <sys_isUHeapPlacementStrategyNEXTFIT>
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	0f 84 6f 03 00 00    	je     801ef6 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801b87:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b91:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801b94:	01 d0                	add    %edx,%eax
  801b96:	48                   	dec    %eax
  801b97:	89 45 80             	mov    %eax,-0x80(%ebp)
  801b9a:	8b 45 80             	mov    -0x80(%ebp),%eax
  801b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba2:	f7 75 84             	divl   -0x7c(%ebp)
  801ba5:	8b 45 80             	mov    -0x80(%ebp),%eax
  801ba8:	29 d0                	sub    %edx,%eax
  801baa:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801bad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bb1:	74 09                	je     801bbc <malloc+0x4b>
  801bb3:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801bba:	76 0a                	jbe    801bc6 <malloc+0x55>
			return NULL;
  801bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc1:	e9 4b 09 00 00       	jmp    802511 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801bc6:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	01 d0                	add    %edx,%eax
  801bd1:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801bd6:	0f 87 a2 00 00 00    	ja     801c7e <malloc+0x10d>
  801bdc:	a1 40 40 98 00       	mov    0x984040,%eax
  801be1:	85 c0                	test   %eax,%eax
  801be3:	0f 85 95 00 00 00    	jne    801c7e <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801be9:	a1 04 40 80 00       	mov    0x804004,%eax
  801bee:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801bf4:	a1 04 40 80 00       	mov    0x804004,%eax
  801bf9:	83 ec 08             	sub    $0x8,%esp
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	50                   	push   %eax
  801c00:	e8 a3 0b 00 00       	call   8027a8 <sys_allocateMem>
  801c05:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801c08:	a1 20 40 80 00       	mov    0x804020,%eax
  801c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  801c10:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801c17:	a1 20 40 80 00       	mov    0x804020,%eax
  801c1c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c22:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  801c29:	a1 20 40 80 00       	mov    0x804020,%eax
  801c2e:	40                   	inc    %eax
  801c2f:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  801c34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801c3b:	eb 2e                	jmp    801c6b <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801c3d:	a1 04 40 80 00       	mov    0x804004,%eax
  801c42:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801c47:	c1 e8 0c             	shr    $0xc,%eax
  801c4a:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801c51:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801c55:	a1 04 40 80 00       	mov    0x804004,%eax
  801c5a:	05 00 10 00 00       	add    $0x1000,%eax
  801c5f:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801c64:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c71:	72 ca                	jb     801c3d <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801c73:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801c79:	e9 93 08 00 00       	jmp    802511 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801c7e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801c85:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801c8c:	a1 40 40 98 00       	mov    0x984040,%eax
  801c91:	85 c0                	test   %eax,%eax
  801c93:	75 1d                	jne    801cb2 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801c95:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801c9c:	00 00 80 
				check = 1;
  801c9f:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  801ca6:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801ca9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801cb0:	eb 08                	jmp    801cba <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801cb2:	a1 04 40 80 00       	mov    0x804004,%eax
  801cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801cba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801cc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801cc8:	a1 04 40 80 00       	mov    0x804004,%eax
  801ccd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801cd0:	eb 4d                	jmp    801d1f <malloc+0x1ae>
				if (sz == size) {
  801cd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cd5:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cd8:	75 09                	jne    801ce3 <malloc+0x172>
					f = 1;
  801cda:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801ce1:	eb 45                	jmp    801d28 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801ce3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce6:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801ceb:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801cee:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	75 10                	jne    801d09 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801cf9:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801d00:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801d07:	eb 16                	jmp    801d1f <malloc+0x1ae>
				} else {
					sz = 0;
  801d09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801d10:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801d17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d1a:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801d1f:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801d26:	76 aa                	jbe    801cd2 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801d28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d2c:	0f 84 95 00 00 00    	je     801dc7 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801d32:	a1 04 40 80 00       	mov    0x804004,%eax
  801d37:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801d3d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d42:	83 ec 08             	sub    $0x8,%esp
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	50                   	push   %eax
  801d49:	e8 5a 0a 00 00       	call   8027a8 <sys_allocateMem>
  801d4e:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801d51:	a1 20 40 80 00       	mov    0x804020,%eax
  801d56:	8b 55 08             	mov    0x8(%ebp),%edx
  801d59:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801d60:	a1 20 40 80 00       	mov    0x804020,%eax
  801d65:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d6b:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  801d72:	a1 20 40 80 00       	mov    0x804020,%eax
  801d77:	40                   	inc    %eax
  801d78:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  801d7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801d84:	eb 2e                	jmp    801db4 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801d86:	a1 04 40 80 00       	mov    0x804004,%eax
  801d8b:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801d90:	c1 e8 0c             	shr    $0xc,%eax
  801d93:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801d9a:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801d9e:	a1 04 40 80 00       	mov    0x804004,%eax
  801da3:	05 00 10 00 00       	add    $0x1000,%eax
  801da8:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801dad:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801db4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801db7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dba:	72 ca                	jb     801d86 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801dbc:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801dc2:	e9 4a 07 00 00       	jmp    802511 <malloc+0x9a0>

			} else {

				if (check_start) {
  801dc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dcb:	74 0a                	je     801dd7 <malloc+0x266>

					return NULL;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	e9 3a 07 00 00       	jmp    802511 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801dd7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801dde:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801de5:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801dec:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801df3:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801df6:	eb 4d                	jmp    801e45 <malloc+0x2d4>
					if (sz == size) {
  801df8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dfb:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dfe:	75 09                	jne    801e09 <malloc+0x298>
						f = 1;
  801e00:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801e07:	eb 44                	jmp    801e4d <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801e09:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e0c:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801e11:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801e14:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	75 10                	jne    801e2f <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801e1f:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801e26:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801e2d:	eb 16                	jmp    801e45 <malloc+0x2d4>
					} else {
						sz = 0;
  801e2f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801e36:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801e3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e40:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e48:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801e4b:	72 ab                	jb     801df8 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801e4d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e51:	0f 84 95 00 00 00    	je     801eec <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801e57:	a1 04 40 80 00       	mov    0x804004,%eax
  801e5c:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801e62:	a1 04 40 80 00       	mov    0x804004,%eax
  801e67:	83 ec 08             	sub    $0x8,%esp
  801e6a:	ff 75 08             	pushl  0x8(%ebp)
  801e6d:	50                   	push   %eax
  801e6e:	e8 35 09 00 00       	call   8027a8 <sys_allocateMem>
  801e73:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801e76:	a1 20 40 80 00       	mov    0x804020,%eax
  801e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e7e:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801e85:	a1 20 40 80 00       	mov    0x804020,%eax
  801e8a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e90:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  801e97:	a1 20 40 80 00       	mov    0x804020,%eax
  801e9c:	40                   	inc    %eax
  801e9d:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  801ea2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801ea9:	eb 2e                	jmp    801ed9 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801eab:	a1 04 40 80 00       	mov    0x804004,%eax
  801eb0:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801eb5:	c1 e8 0c             	shr    $0xc,%eax
  801eb8:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801ebf:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801ec3:	a1 04 40 80 00       	mov    0x804004,%eax
  801ec8:	05 00 10 00 00       	add    $0x1000,%eax
  801ecd:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801ed2:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801ed9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801edc:	3b 45 08             	cmp    0x8(%ebp),%eax
  801edf:	72 ca                	jb     801eab <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801ee1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801ee7:	e9 25 06 00 00       	jmp    802511 <malloc+0x9a0>

				} else {

					return NULL;
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef1:	e9 1b 06 00 00       	jmp    802511 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801ef6:	e8 d0 0b 00 00       	call   802acb <sys_isUHeapPlacementStrategyBESTFIT>
  801efb:	85 c0                	test   %eax,%eax
  801efd:	0f 84 ba 01 00 00    	je     8020bd <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801f03:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801f0a:	10 00 00 
  801f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  801f10:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801f16:	01 d0                	add    %edx,%eax
  801f18:	48                   	dec    %eax
  801f19:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801f1f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801f25:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2a:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801f30:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801f36:	29 d0                	sub    %edx,%eax
  801f38:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801f3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f3f:	74 09                	je     801f4a <malloc+0x3d9>
  801f41:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801f48:	76 0a                	jbe    801f54 <malloc+0x3e3>
			return NULL;
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4f:	e9 bd 05 00 00       	jmp    802511 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801f54:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801f5b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801f62:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801f69:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801f70:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	c1 e8 0c             	shr    $0xc,%eax
  801f7d:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801f83:	e9 80 00 00 00       	jmp    802008 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801f88:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f8b:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801f92:	85 c0                	test   %eax,%eax
  801f94:	75 0c                	jne    801fa2 <malloc+0x431>

				count++;
  801f96:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801f99:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801fa0:	eb 2d                	jmp    801fcf <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801fa2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801fa8:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801fab:	77 14                	ja     801fc1 <malloc+0x450>
  801fad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fb0:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801fb3:	76 0c                	jbe    801fc1 <malloc+0x450>

					min_sz = count;
  801fb5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801fb8:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801fbb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801fc1:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801fc8:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801fcf:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801fd6:	75 2d                	jne    802005 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801fd8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801fde:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801fe1:	77 22                	ja     802005 <malloc+0x494>
  801fe3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fe6:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801fe9:	76 1a                	jbe    802005 <malloc+0x494>

					min_sz = count;
  801feb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801fee:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801ff1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ff4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801ff7:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801ffe:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  802005:	ff 45 b8             	incl   -0x48(%ebp)
  802008:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80200b:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802010:	0f 86 72 ff ff ff    	jbe    801f88 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  802016:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80201c:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  80201f:	77 06                	ja     802027 <malloc+0x4b6>
  802021:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802025:	75 0a                	jne    802031 <malloc+0x4c0>
			return NULL;
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	e9 e0 04 00 00       	jmp    802511 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  802031:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802034:	c1 e0 0c             	shl    $0xc,%eax
  802037:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  80203a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80203d:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  802043:	83 ec 08             	sub    $0x8,%esp
  802046:	ff 75 08             	pushl  0x8(%ebp)
  802049:	ff 75 c4             	pushl  -0x3c(%ebp)
  80204c:	e8 57 07 00 00       	call   8027a8 <sys_allocateMem>
  802051:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802054:	a1 20 40 80 00       	mov    0x804020,%eax
  802059:	8b 55 08             	mov    0x8(%ebp),%edx
  80205c:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  802063:	a1 20 40 80 00       	mov    0x804020,%eax
  802068:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80206b:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  802072:	a1 20 40 80 00       	mov    0x804020,%eax
  802077:	40                   	inc    %eax
  802078:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  80207d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802084:	eb 24                	jmp    8020aa <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802086:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802089:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80208e:	c1 e8 0c             	shr    $0xc,%eax
  802091:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802098:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  80209c:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8020a3:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  8020aa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020b0:	72 d4                	jb     802086 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8020b2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8020b8:	e9 54 04 00 00       	jmp    802511 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8020bd:	e8 d8 09 00 00       	call   802a9a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	0f 84 88 01 00 00    	je     802252 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  8020ca:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  8020d1:	10 00 00 
  8020d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d7:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	48                   	dec    %eax
  8020e0:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  8020e6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8020ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f1:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  8020f7:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8020fd:	29 d0                	sub    %edx,%eax
  8020ff:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802102:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802106:	74 09                	je     802111 <malloc+0x5a0>
  802108:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80210f:	76 0a                	jbe    80211b <malloc+0x5aa>
			return NULL;
  802111:	b8 00 00 00 00       	mov    $0x0,%eax
  802116:	e9 f6 03 00 00       	jmp    802511 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  80211b:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  802122:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  802129:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  802130:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  802137:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	c1 e8 0c             	shr    $0xc,%eax
  802144:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  80214a:	eb 5a                	jmp    8021a6 <malloc+0x635>

			if (heap_mem[i] == 0) {
  80214c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80214f:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802156:	85 c0                	test   %eax,%eax
  802158:	75 0c                	jne    802166 <malloc+0x5f5>

				count++;
  80215a:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  80215d:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  802164:	eb 22                	jmp    802188 <malloc+0x617>
			} else {
				if (num_p <= count) {
  802166:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80216c:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  80216f:	77 09                	ja     80217a <malloc+0x609>

					found = 1;
  802171:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  802178:	eb 36                	jmp    8021b0 <malloc+0x63f>
				}
				count = 0;
  80217a:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  802181:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  802188:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  80218f:	75 12                	jne    8021a3 <malloc+0x632>

				if (num_p <= count) {
  802191:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802197:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  80219a:	77 07                	ja     8021a3 <malloc+0x632>

					found = 1;
  80219c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  8021a3:	ff 45 a4             	incl   -0x5c(%ebp)
  8021a6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8021a9:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8021ae:	76 9c                	jbe    80214c <malloc+0x5db>

			}

		}

		if (!found) {
  8021b0:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  8021b4:	75 0a                	jne    8021c0 <malloc+0x64f>
			return NULL;
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bb:	e9 51 03 00 00       	jmp    802511 <malloc+0x9a0>

		}

		temp = ptr;
  8021c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8021c3:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  8021c6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8021c9:	c1 e0 0c             	shl    $0xc,%eax
  8021cc:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  8021cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d2:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  8021d8:	83 ec 08             	sub    $0x8,%esp
  8021db:	ff 75 08             	pushl  0x8(%ebp)
  8021de:	ff 75 b0             	pushl  -0x50(%ebp)
  8021e1:	e8 c2 05 00 00       	call   8027a8 <sys_allocateMem>
  8021e6:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8021e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8021ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f1:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8021f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8021fd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802200:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  802207:	a1 20 40 80 00       	mov    0x804020,%eax
  80220c:	40                   	inc    %eax
  80220d:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  802212:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802219:	eb 24                	jmp    80223f <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  80221b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80221e:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802223:	c1 e8 0c             	shr    $0xc,%eax
  802226:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  80222d:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802231:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802238:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  80223f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802242:	3b 45 08             	cmp    0x8(%ebp),%eax
  802245:	72 d4                	jb     80221b <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  802247:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80224d:	e9 bf 02 00 00       	jmp    802511 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  802252:	e8 d6 08 00 00       	call   802b2d <sys_isUHeapPlacementStrategyWORSTFIT>
  802257:	85 c0                	test   %eax,%eax
  802259:	0f 84 ba 01 00 00    	je     802419 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  80225f:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  802266:	10 00 00 
  802269:	8b 55 08             	mov    0x8(%ebp),%edx
  80226c:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802272:	01 d0                	add    %edx,%eax
  802274:	48                   	dec    %eax
  802275:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  80227b:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802281:	ba 00 00 00 00       	mov    $0x0,%edx
  802286:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  80228c:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802292:	29 d0                	sub    %edx,%eax
  802294:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229b:	74 09                	je     8022a6 <malloc+0x735>
  80229d:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8022a4:	76 0a                	jbe    8022b0 <malloc+0x73f>
					return NULL;
  8022a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ab:	e9 61 02 00 00       	jmp    802511 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  8022b0:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  8022b7:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  8022be:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  8022c5:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  8022cc:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	c1 e8 0c             	shr    $0xc,%eax
  8022d9:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8022df:	e9 80 00 00 00       	jmp    802364 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  8022e4:	8b 45 90             	mov    -0x70(%ebp),%eax
  8022e7:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	75 0c                	jne    8022fe <malloc+0x78d>

						count++;
  8022f2:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  8022f5:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  8022fc:	eb 2d                	jmp    80232b <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  8022fe:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802304:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802307:	77 14                	ja     80231d <malloc+0x7ac>
  802309:	8b 45 98             	mov    -0x68(%ebp),%eax
  80230c:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80230f:	73 0c                	jae    80231d <malloc+0x7ac>

							max_sz = count;
  802311:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802314:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802317:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80231a:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  80231d:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  802324:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  80232b:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  802332:	75 2d                	jne    802361 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  802334:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80233a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80233d:	77 22                	ja     802361 <malloc+0x7f0>
  80233f:	8b 45 98             	mov    -0x68(%ebp),%eax
  802342:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802345:	76 1a                	jbe    802361 <malloc+0x7f0>

							max_sz = count;
  802347:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80234a:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  80234d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802350:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  802353:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  80235a:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802361:	ff 45 90             	incl   -0x70(%ebp)
  802364:	8b 45 90             	mov    -0x70(%ebp),%eax
  802367:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  80236c:	0f 86 72 ff ff ff    	jbe    8022e4 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  802372:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802378:	3b 45 98             	cmp    -0x68(%ebp),%eax
  80237b:	77 06                	ja     802383 <malloc+0x812>
  80237d:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802381:	75 0a                	jne    80238d <malloc+0x81c>
					return NULL;
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
  802388:	e9 84 01 00 00       	jmp    802511 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  80238d:	8b 45 98             	mov    -0x68(%ebp),%eax
  802390:	c1 e0 0c             	shl    $0xc,%eax
  802393:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  802396:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802399:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  80239f:	83 ec 08             	sub    $0x8,%esp
  8023a2:	ff 75 08             	pushl  0x8(%ebp)
  8023a5:	ff 75 9c             	pushl  -0x64(%ebp)
  8023a8:	e8 fb 03 00 00       	call   8027a8 <sys_allocateMem>
  8023ad:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8023b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8023b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b8:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  8023bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8023c4:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8023c7:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  8023ce:	a1 20 40 80 00       	mov    0x804020,%eax
  8023d3:	40                   	inc    %eax
  8023d4:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  8023d9:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8023e0:	eb 24                	jmp    802406 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8023e2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8023e5:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8023ea:	c1 e8 0c             	shr    $0xc,%eax
  8023ed:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8023f4:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  8023f8:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8023ff:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802406:	8b 45 90             	mov    -0x70(%ebp),%eax
  802409:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240c:	72 d4                	jb     8023e2 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  80240e:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  802414:	e9 f8 00 00 00       	jmp    802511 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802419:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  802420:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  802427:	10 00 00 
  80242a:	8b 55 08             	mov    0x8(%ebp),%edx
  80242d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  802433:	01 d0                	add    %edx,%eax
  802435:	48                   	dec    %eax
  802436:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  80243c:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802442:	ba 00 00 00 00       	mov    $0x0,%edx
  802447:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  80244d:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802453:	29 d0                	sub    %edx,%eax
  802455:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802458:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80245c:	74 09                	je     802467 <malloc+0x8f6>
  80245e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802465:	76 0a                	jbe    802471 <malloc+0x900>
		return NULL;
  802467:	b8 00 00 00 00       	mov    $0x0,%eax
  80246c:	e9 a0 00 00 00       	jmp    802511 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802471:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	01 d0                	add    %edx,%eax
  80247c:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802481:	0f 87 87 00 00 00    	ja     80250e <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802487:	a1 04 40 80 00       	mov    0x804004,%eax
  80248c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  80248f:	a1 04 40 80 00       	mov    0x804004,%eax
  802494:	83 ec 08             	sub    $0x8,%esp
  802497:	ff 75 08             	pushl  0x8(%ebp)
  80249a:	50                   	push   %eax
  80249b:	e8 08 03 00 00       	call   8027a8 <sys_allocateMem>
  8024a0:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8024a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8024a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ab:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8024b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8024b7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8024bd:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8024c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8024c9:	40                   	inc    %eax
  8024ca:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  8024cf:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8024d6:	eb 2e                	jmp    802506 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8024d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8024dd:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8024e2:	c1 e8 0c             	shr    $0xc,%eax
  8024e5:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8024ec:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8024f0:	a1 04 40 80 00       	mov    0x804004,%eax
  8024f5:	05 00 10 00 00       	add    $0x1000,%eax
  8024fa:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8024ff:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802506:	8b 45 88             	mov    -0x78(%ebp),%eax
  802509:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250c:	72 ca                	jb     8024d8 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  80250e:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802519:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  802520:	e9 c1 00 00 00       	jmp    8025e6 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  80252f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802532:	0f 85 ab 00 00 00    	jne    8025e3 <free+0xd0>

			if (heap_size[inx].size == 0) {
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	75 21                	jne    802567 <free+0x54>
				heap_size[inx].size = 0;
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802550:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  80255e:	00 00 00 00 
				return;
  802562:	e9 8d 00 00 00       	jmp    8025f4 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802571:	8b 45 08             	mov    0x8(%ebp),%eax
  802574:	83 ec 08             	sub    $0x8,%esp
  802577:	52                   	push   %edx
  802578:	50                   	push   %eax
  802579:	e8 0e 02 00 00       	call   80278c <sys_freeMem>
  80257e:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802581:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  80258e:	eb 24                	jmp    8025b4 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802593:	05 00 00 00 80       	add    $0x80000000,%eax
  802598:	c1 e8 0c             	shr    $0xc,%eax
  80259b:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  8025a2:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  8025a6:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8025ad:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  8025be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c1:	39 c2                	cmp    %eax,%edx
  8025c3:	77 cb                	ja     802590 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  8025cf:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  8025dd:	00 00 00 00 
			break;
  8025e1:	eb 11                	jmp    8025f4 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8025e3:	ff 45 f4             	incl   -0xc(%ebp)
  8025e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8025eb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8025ee:	0f 8c 31 ff ff ff    	jl     802525 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8025fc:	83 ec 04             	sub    $0x4,%esp
  8025ff:	68 d0 32 80 00       	push   $0x8032d0
  802604:	68 1c 02 00 00       	push   $0x21c
  802609:	68 f6 32 80 00       	push   $0x8032f6
  80260e:	e8 b0 e6 ff ff       	call   800cc3 <_panic>

00802613 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	57                   	push   %edi
  802617:	56                   	push   %esi
  802618:	53                   	push   %ebx
  802619:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802622:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802625:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802628:	8b 7d 18             	mov    0x18(%ebp),%edi
  80262b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80262e:	cd 30                	int    $0x30
  802630:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802633:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802636:	83 c4 10             	add    $0x10,%esp
  802639:	5b                   	pop    %ebx
  80263a:	5e                   	pop    %esi
  80263b:	5f                   	pop    %edi
  80263c:	5d                   	pop    %ebp
  80263d:	c3                   	ret    

0080263e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	ff 75 0c             	pushl  0xc(%ebp)
  80264d:	50                   	push   %eax
  80264e:	6a 00                	push   $0x0
  802650:	e8 be ff ff ff       	call   802613 <syscall>
  802655:	83 c4 18             	add    $0x18,%esp
}
  802658:	90                   	nop
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <sys_cgetc>:

int
sys_cgetc(void)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 01                	push   $0x1
  80266a:	e8 a4 ff ff ff       	call   802613 <syscall>
  80266f:	83 c4 18             	add    $0x18,%esp
}
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	50                   	push   %eax
  802683:	6a 03                	push   $0x3
  802685:	e8 89 ff ff ff       	call   802613 <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 02                	push   $0x2
  80269e:	e8 70 ff ff ff       	call   802613 <syscall>
  8026a3:	83 c4 18             	add    $0x18,%esp
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <sys_env_exit>:

void sys_env_exit(void)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 04                	push   $0x4
  8026b7:	e8 57 ff ff ff       	call   802613 <syscall>
  8026bc:	83 c4 18             	add    $0x18,%esp
}
  8026bf:	90                   	nop
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	52                   	push   %edx
  8026d2:	50                   	push   %eax
  8026d3:	6a 05                	push   $0x5
  8026d5:	e8 39 ff ff ff       	call   802613 <syscall>
  8026da:	83 c4 18             	add    $0x18,%esp
}
  8026dd:	c9                   	leave  
  8026de:	c3                   	ret    

008026df <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
  8026e2:	56                   	push   %esi
  8026e3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8026e4:	8b 75 18             	mov    0x18(%ebp),%esi
  8026e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	56                   	push   %esi
  8026f4:	53                   	push   %ebx
  8026f5:	51                   	push   %ecx
  8026f6:	52                   	push   %edx
  8026f7:	50                   	push   %eax
  8026f8:	6a 06                	push   $0x6
  8026fa:	e8 14 ff ff ff       	call   802613 <syscall>
  8026ff:	83 c4 18             	add    $0x18,%esp
}
  802702:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802705:	5b                   	pop    %ebx
  802706:	5e                   	pop    %esi
  802707:	5d                   	pop    %ebp
  802708:	c3                   	ret    

00802709 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80270c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	52                   	push   %edx
  802719:	50                   	push   %eax
  80271a:	6a 07                	push   $0x7
  80271c:	e8 f2 fe ff ff       	call   802613 <syscall>
  802721:	83 c4 18             	add    $0x18,%esp
}
  802724:	c9                   	leave  
  802725:	c3                   	ret    

00802726 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	ff 75 0c             	pushl  0xc(%ebp)
  802732:	ff 75 08             	pushl  0x8(%ebp)
  802735:	6a 08                	push   $0x8
  802737:	e8 d7 fe ff ff       	call   802613 <syscall>
  80273c:	83 c4 18             	add    $0x18,%esp
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 09                	push   $0x9
  802750:	e8 be fe ff ff       	call   802613 <syscall>
  802755:	83 c4 18             	add    $0x18,%esp
}
  802758:	c9                   	leave  
  802759:	c3                   	ret    

0080275a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 0a                	push   $0xa
  802769:	e8 a5 fe ff ff       	call   802613 <syscall>
  80276e:	83 c4 18             	add    $0x18,%esp
}
  802771:	c9                   	leave  
  802772:	c3                   	ret    

00802773 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 0b                	push   $0xb
  802782:	e8 8c fe ff ff       	call   802613 <syscall>
  802787:	83 c4 18             	add    $0x18,%esp
}
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	ff 75 0c             	pushl  0xc(%ebp)
  802798:	ff 75 08             	pushl  0x8(%ebp)
  80279b:	6a 0d                	push   $0xd
  80279d:	e8 71 fe ff ff       	call   802613 <syscall>
  8027a2:	83 c4 18             	add    $0x18,%esp
	return;
  8027a5:	90                   	nop
}
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	ff 75 0c             	pushl  0xc(%ebp)
  8027b4:	ff 75 08             	pushl  0x8(%ebp)
  8027b7:	6a 0e                	push   $0xe
  8027b9:	e8 55 fe ff ff       	call   802613 <syscall>
  8027be:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c1:	90                   	nop
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 0c                	push   $0xc
  8027d3:	e8 3b fe ff ff       	call   802613 <syscall>
  8027d8:	83 c4 18             	add    $0x18,%esp
}
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	6a 00                	push   $0x0
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 10                	push   $0x10
  8027ec:	e8 22 fe ff ff       	call   802613 <syscall>
  8027f1:	83 c4 18             	add    $0x18,%esp
}
  8027f4:	90                   	nop
  8027f5:	c9                   	leave  
  8027f6:	c3                   	ret    

008027f7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 11                	push   $0x11
  802806:	e8 08 fe ff ff       	call   802613 <syscall>
  80280b:	83 c4 18             	add    $0x18,%esp
}
  80280e:	90                   	nop
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <sys_cputc>:


void
sys_cputc(const char c)
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
  802814:	83 ec 04             	sub    $0x4,%esp
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80281d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	6a 00                	push   $0x0
  802829:	50                   	push   %eax
  80282a:	6a 12                	push   $0x12
  80282c:	e8 e2 fd ff ff       	call   802613 <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
}
  802834:	90                   	nop
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80283a:	6a 00                	push   $0x0
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 13                	push   $0x13
  802846:	e8 c8 fd ff ff       	call   802613 <syscall>
  80284b:	83 c4 18             	add    $0x18,%esp
}
  80284e:	90                   	nop
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802854:	8b 45 08             	mov    0x8(%ebp),%eax
  802857:	6a 00                	push   $0x0
  802859:	6a 00                	push   $0x0
  80285b:	6a 00                	push   $0x0
  80285d:	ff 75 0c             	pushl  0xc(%ebp)
  802860:	50                   	push   %eax
  802861:	6a 14                	push   $0x14
  802863:	e8 ab fd ff ff       	call   802613 <syscall>
  802868:	83 c4 18             	add    $0x18,%esp
}
  80286b:	c9                   	leave  
  80286c:	c3                   	ret    

0080286d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  80286d:	55                   	push   %ebp
  80286e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	50                   	push   %eax
  80287c:	6a 17                	push   $0x17
  80287e:	e8 90 fd ff ff       	call   802613 <syscall>
  802883:	83 c4 18             	add    $0x18,%esp
}
  802886:	c9                   	leave  
  802887:	c3                   	ret    

00802888 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802888:	55                   	push   %ebp
  802889:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	6a 00                	push   $0x0
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	50                   	push   %eax
  802897:	6a 15                	push   $0x15
  802899:	e8 75 fd ff ff       	call   802613 <syscall>
  80289e:	83 c4 18             	add    $0x18,%esp
}
  8028a1:	90                   	nop
  8028a2:	c9                   	leave  
  8028a3:	c3                   	ret    

008028a4 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8028a4:	55                   	push   %ebp
  8028a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	50                   	push   %eax
  8028b3:	6a 16                	push   $0x16
  8028b5:	e8 59 fd ff ff       	call   802613 <syscall>
  8028ba:	83 c4 18             	add    $0x18,%esp
}
  8028bd:	90                   	nop
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
  8028c3:	83 ec 04             	sub    $0x4,%esp
  8028c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8028cc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028cf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	6a 00                	push   $0x0
  8028d8:	51                   	push   %ecx
  8028d9:	52                   	push   %edx
  8028da:	ff 75 0c             	pushl  0xc(%ebp)
  8028dd:	50                   	push   %eax
  8028de:	6a 18                	push   $0x18
  8028e0:	e8 2e fd ff ff       	call   802613 <syscall>
  8028e5:	83 c4 18             	add    $0x18,%esp
}
  8028e8:	c9                   	leave  
  8028e9:	c3                   	ret    

008028ea <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8028ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	52                   	push   %edx
  8028fa:	50                   	push   %eax
  8028fb:	6a 19                	push   $0x19
  8028fd:	e8 11 fd ff ff       	call   802613 <syscall>
  802902:	83 c4 18             	add    $0x18,%esp
}
  802905:	c9                   	leave  
  802906:	c3                   	ret    

00802907 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802907:	55                   	push   %ebp
  802908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	50                   	push   %eax
  802916:	6a 1a                	push   $0x1a
  802918:	e8 f6 fc ff ff       	call   802613 <syscall>
  80291d:	83 c4 18             	add    $0x18,%esp
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    

00802922 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 1b                	push   $0x1b
  802931:	e8 dd fc ff ff       	call   802613 <syscall>
  802936:	83 c4 18             	add    $0x18,%esp
}
  802939:	c9                   	leave  
  80293a:	c3                   	ret    

0080293b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 1c                	push   $0x1c
  80294a:	e8 c4 fc ff ff       	call   802613 <syscall>
  80294f:	83 c4 18             	add    $0x18,%esp
}
  802952:	c9                   	leave  
  802953:	c3                   	ret    

00802954 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	ff 75 0c             	pushl  0xc(%ebp)
  802963:	50                   	push   %eax
  802964:	6a 1d                	push   $0x1d
  802966:	e8 a8 fc ff ff       	call   802613 <syscall>
  80296b:	83 c4 18             	add    $0x18,%esp
}
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	50                   	push   %eax
  80297f:	6a 1e                	push   $0x1e
  802981:	e8 8d fc ff ff       	call   802613 <syscall>
  802986:	83 c4 18             	add    $0x18,%esp
}
  802989:	90                   	nop
  80298a:	c9                   	leave  
  80298b:	c3                   	ret    

0080298c <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	6a 00                	push   $0x0
  802994:	6a 00                	push   $0x0
  802996:	6a 00                	push   $0x0
  802998:	6a 00                	push   $0x0
  80299a:	50                   	push   %eax
  80299b:	6a 1f                	push   $0x1f
  80299d:	e8 71 fc ff ff       	call   802613 <syscall>
  8029a2:	83 c4 18             	add    $0x18,%esp
}
  8029a5:	90                   	nop
  8029a6:	c9                   	leave  
  8029a7:	c3                   	ret    

008029a8 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
  8029ab:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8029ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029b1:	8d 50 04             	lea    0x4(%eax),%edx
  8029b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	52                   	push   %edx
  8029be:	50                   	push   %eax
  8029bf:	6a 20                	push   $0x20
  8029c1:	e8 4d fc ff ff       	call   802613 <syscall>
  8029c6:	83 c4 18             	add    $0x18,%esp
	return result;
  8029c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029d2:	89 01                	mov    %eax,(%ecx)
  8029d4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	c9                   	leave  
  8029db:	c2 04 00             	ret    $0x4

008029de <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8029de:	55                   	push   %ebp
  8029df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 00                	push   $0x0
  8029e5:	ff 75 10             	pushl  0x10(%ebp)
  8029e8:	ff 75 0c             	pushl  0xc(%ebp)
  8029eb:	ff 75 08             	pushl  0x8(%ebp)
  8029ee:	6a 0f                	push   $0xf
  8029f0:	e8 1e fc ff ff       	call   802613 <syscall>
  8029f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8029f8:	90                   	nop
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

008029fb <sys_rcr2>:
uint32 sys_rcr2()
{
  8029fb:	55                   	push   %ebp
  8029fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 21                	push   $0x21
  802a0a:	e8 04 fc ff ff       	call   802613 <syscall>
  802a0f:	83 c4 18             	add    $0x18,%esp
}
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
  802a17:	83 ec 04             	sub    $0x4,%esp
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a20:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a24:	6a 00                	push   $0x0
  802a26:	6a 00                	push   $0x0
  802a28:	6a 00                	push   $0x0
  802a2a:	6a 00                	push   $0x0
  802a2c:	50                   	push   %eax
  802a2d:	6a 22                	push   $0x22
  802a2f:	e8 df fb ff ff       	call   802613 <syscall>
  802a34:	83 c4 18             	add    $0x18,%esp
	return ;
  802a37:	90                   	nop
}
  802a38:	c9                   	leave  
  802a39:	c3                   	ret    

00802a3a <rsttst>:
void rsttst()
{
  802a3a:	55                   	push   %ebp
  802a3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a3d:	6a 00                	push   $0x0
  802a3f:	6a 00                	push   $0x0
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	6a 24                	push   $0x24
  802a49:	e8 c5 fb ff ff       	call   802613 <syscall>
  802a4e:	83 c4 18             	add    $0x18,%esp
	return ;
  802a51:	90                   	nop
}
  802a52:	c9                   	leave  
  802a53:	c3                   	ret    

00802a54 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
  802a57:	83 ec 04             	sub    $0x4,%esp
  802a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  802a5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a60:	8b 55 18             	mov    0x18(%ebp),%edx
  802a63:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a67:	52                   	push   %edx
  802a68:	50                   	push   %eax
  802a69:	ff 75 10             	pushl  0x10(%ebp)
  802a6c:	ff 75 0c             	pushl  0xc(%ebp)
  802a6f:	ff 75 08             	pushl  0x8(%ebp)
  802a72:	6a 23                	push   $0x23
  802a74:	e8 9a fb ff ff       	call   802613 <syscall>
  802a79:	83 c4 18             	add    $0x18,%esp
	return ;
  802a7c:	90                   	nop
}
  802a7d:	c9                   	leave  
  802a7e:	c3                   	ret    

00802a7f <chktst>:
void chktst(uint32 n)
{
  802a7f:	55                   	push   %ebp
  802a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	6a 00                	push   $0x0
  802a8a:	ff 75 08             	pushl  0x8(%ebp)
  802a8d:	6a 25                	push   $0x25
  802a8f:	e8 7f fb ff ff       	call   802613 <syscall>
  802a94:	83 c4 18             	add    $0x18,%esp
	return ;
  802a97:	90                   	nop
}
  802a98:	c9                   	leave  
  802a99:	c3                   	ret    

00802a9a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aa0:	6a 00                	push   $0x0
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 26                	push   $0x26
  802aac:	e8 62 fb ff ff       	call   802613 <syscall>
  802ab1:	83 c4 18             	add    $0x18,%esp
  802ab4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ab7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802abb:	75 07                	jne    802ac4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802abd:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac2:	eb 05                	jmp    802ac9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802ac4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac9:	c9                   	leave  
  802aca:	c3                   	ret    

00802acb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802acb:	55                   	push   %ebp
  802acc:	89 e5                	mov    %esp,%ebp
  802ace:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ad1:	6a 00                	push   $0x0
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 26                	push   $0x26
  802add:	e8 31 fb ff ff       	call   802613 <syscall>
  802ae2:	83 c4 18             	add    $0x18,%esp
  802ae5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ae8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802aec:	75 07                	jne    802af5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802aee:	b8 01 00 00 00       	mov    $0x1,%eax
  802af3:	eb 05                	jmp    802afa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
  802aff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b02:	6a 00                	push   $0x0
  802b04:	6a 00                	push   $0x0
  802b06:	6a 00                	push   $0x0
  802b08:	6a 00                	push   $0x0
  802b0a:	6a 00                	push   $0x0
  802b0c:	6a 26                	push   $0x26
  802b0e:	e8 00 fb ff ff       	call   802613 <syscall>
  802b13:	83 c4 18             	add    $0x18,%esp
  802b16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802b19:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802b1d:	75 07                	jne    802b26 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802b1f:	b8 01 00 00 00       	mov    $0x1,%eax
  802b24:	eb 05                	jmp    802b2b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2b:	c9                   	leave  
  802b2c:	c3                   	ret    

00802b2d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802b2d:	55                   	push   %ebp
  802b2e:	89 e5                	mov    %esp,%ebp
  802b30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b33:	6a 00                	push   $0x0
  802b35:	6a 00                	push   $0x0
  802b37:	6a 00                	push   $0x0
  802b39:	6a 00                	push   $0x0
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 26                	push   $0x26
  802b3f:	e8 cf fa ff ff       	call   802613 <syscall>
  802b44:	83 c4 18             	add    $0x18,%esp
  802b47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802b4a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802b4e:	75 07                	jne    802b57 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802b50:	b8 01 00 00 00       	mov    $0x1,%eax
  802b55:	eb 05                	jmp    802b5c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5c:	c9                   	leave  
  802b5d:	c3                   	ret    

00802b5e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b5e:	55                   	push   %ebp
  802b5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b61:	6a 00                	push   $0x0
  802b63:	6a 00                	push   $0x0
  802b65:	6a 00                	push   $0x0
  802b67:	6a 00                	push   $0x0
  802b69:	ff 75 08             	pushl  0x8(%ebp)
  802b6c:	6a 27                	push   $0x27
  802b6e:	e8 a0 fa ff ff       	call   802613 <syscall>
  802b73:	83 c4 18             	add    $0x18,%esp
	return ;
  802b76:	90                   	nop
}
  802b77:	c9                   	leave  
  802b78:	c3                   	ret    
  802b79:	66 90                	xchg   %ax,%ax
  802b7b:	90                   	nop

00802b7c <__udivdi3>:
  802b7c:	55                   	push   %ebp
  802b7d:	57                   	push   %edi
  802b7e:	56                   	push   %esi
  802b7f:	53                   	push   %ebx
  802b80:	83 ec 1c             	sub    $0x1c,%esp
  802b83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802b87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802b8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b93:	89 ca                	mov    %ecx,%edx
  802b95:	89 f8                	mov    %edi,%eax
  802b97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802b9b:	85 f6                	test   %esi,%esi
  802b9d:	75 2d                	jne    802bcc <__udivdi3+0x50>
  802b9f:	39 cf                	cmp    %ecx,%edi
  802ba1:	77 65                	ja     802c08 <__udivdi3+0x8c>
  802ba3:	89 fd                	mov    %edi,%ebp
  802ba5:	85 ff                	test   %edi,%edi
  802ba7:	75 0b                	jne    802bb4 <__udivdi3+0x38>
  802ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  802bae:	31 d2                	xor    %edx,%edx
  802bb0:	f7 f7                	div    %edi
  802bb2:	89 c5                	mov    %eax,%ebp
  802bb4:	31 d2                	xor    %edx,%edx
  802bb6:	89 c8                	mov    %ecx,%eax
  802bb8:	f7 f5                	div    %ebp
  802bba:	89 c1                	mov    %eax,%ecx
  802bbc:	89 d8                	mov    %ebx,%eax
  802bbe:	f7 f5                	div    %ebp
  802bc0:	89 cf                	mov    %ecx,%edi
  802bc2:	89 fa                	mov    %edi,%edx
  802bc4:	83 c4 1c             	add    $0x1c,%esp
  802bc7:	5b                   	pop    %ebx
  802bc8:	5e                   	pop    %esi
  802bc9:	5f                   	pop    %edi
  802bca:	5d                   	pop    %ebp
  802bcb:	c3                   	ret    
  802bcc:	39 ce                	cmp    %ecx,%esi
  802bce:	77 28                	ja     802bf8 <__udivdi3+0x7c>
  802bd0:	0f bd fe             	bsr    %esi,%edi
  802bd3:	83 f7 1f             	xor    $0x1f,%edi
  802bd6:	75 40                	jne    802c18 <__udivdi3+0x9c>
  802bd8:	39 ce                	cmp    %ecx,%esi
  802bda:	72 0a                	jb     802be6 <__udivdi3+0x6a>
  802bdc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802be0:	0f 87 9e 00 00 00    	ja     802c84 <__udivdi3+0x108>
  802be6:	b8 01 00 00 00       	mov    $0x1,%eax
  802beb:	89 fa                	mov    %edi,%edx
  802bed:	83 c4 1c             	add    $0x1c,%esp
  802bf0:	5b                   	pop    %ebx
  802bf1:	5e                   	pop    %esi
  802bf2:	5f                   	pop    %edi
  802bf3:	5d                   	pop    %ebp
  802bf4:	c3                   	ret    
  802bf5:	8d 76 00             	lea    0x0(%esi),%esi
  802bf8:	31 ff                	xor    %edi,%edi
  802bfa:	31 c0                	xor    %eax,%eax
  802bfc:	89 fa                	mov    %edi,%edx
  802bfe:	83 c4 1c             	add    $0x1c,%esp
  802c01:	5b                   	pop    %ebx
  802c02:	5e                   	pop    %esi
  802c03:	5f                   	pop    %edi
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    
  802c06:	66 90                	xchg   %ax,%ax
  802c08:	89 d8                	mov    %ebx,%eax
  802c0a:	f7 f7                	div    %edi
  802c0c:	31 ff                	xor    %edi,%edi
  802c0e:	89 fa                	mov    %edi,%edx
  802c10:	83 c4 1c             	add    $0x1c,%esp
  802c13:	5b                   	pop    %ebx
  802c14:	5e                   	pop    %esi
  802c15:	5f                   	pop    %edi
  802c16:	5d                   	pop    %ebp
  802c17:	c3                   	ret    
  802c18:	bd 20 00 00 00       	mov    $0x20,%ebp
  802c1d:	89 eb                	mov    %ebp,%ebx
  802c1f:	29 fb                	sub    %edi,%ebx
  802c21:	89 f9                	mov    %edi,%ecx
  802c23:	d3 e6                	shl    %cl,%esi
  802c25:	89 c5                	mov    %eax,%ebp
  802c27:	88 d9                	mov    %bl,%cl
  802c29:	d3 ed                	shr    %cl,%ebp
  802c2b:	89 e9                	mov    %ebp,%ecx
  802c2d:	09 f1                	or     %esi,%ecx
  802c2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802c33:	89 f9                	mov    %edi,%ecx
  802c35:	d3 e0                	shl    %cl,%eax
  802c37:	89 c5                	mov    %eax,%ebp
  802c39:	89 d6                	mov    %edx,%esi
  802c3b:	88 d9                	mov    %bl,%cl
  802c3d:	d3 ee                	shr    %cl,%esi
  802c3f:	89 f9                	mov    %edi,%ecx
  802c41:	d3 e2                	shl    %cl,%edx
  802c43:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c47:	88 d9                	mov    %bl,%cl
  802c49:	d3 e8                	shr    %cl,%eax
  802c4b:	09 c2                	or     %eax,%edx
  802c4d:	89 d0                	mov    %edx,%eax
  802c4f:	89 f2                	mov    %esi,%edx
  802c51:	f7 74 24 0c          	divl   0xc(%esp)
  802c55:	89 d6                	mov    %edx,%esi
  802c57:	89 c3                	mov    %eax,%ebx
  802c59:	f7 e5                	mul    %ebp
  802c5b:	39 d6                	cmp    %edx,%esi
  802c5d:	72 19                	jb     802c78 <__udivdi3+0xfc>
  802c5f:	74 0b                	je     802c6c <__udivdi3+0xf0>
  802c61:	89 d8                	mov    %ebx,%eax
  802c63:	31 ff                	xor    %edi,%edi
  802c65:	e9 58 ff ff ff       	jmp    802bc2 <__udivdi3+0x46>
  802c6a:	66 90                	xchg   %ax,%ax
  802c6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802c70:	89 f9                	mov    %edi,%ecx
  802c72:	d3 e2                	shl    %cl,%edx
  802c74:	39 c2                	cmp    %eax,%edx
  802c76:	73 e9                	jae    802c61 <__udivdi3+0xe5>
  802c78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c7b:	31 ff                	xor    %edi,%edi
  802c7d:	e9 40 ff ff ff       	jmp    802bc2 <__udivdi3+0x46>
  802c82:	66 90                	xchg   %ax,%ax
  802c84:	31 c0                	xor    %eax,%eax
  802c86:	e9 37 ff ff ff       	jmp    802bc2 <__udivdi3+0x46>
  802c8b:	90                   	nop

00802c8c <__umoddi3>:
  802c8c:	55                   	push   %ebp
  802c8d:	57                   	push   %edi
  802c8e:	56                   	push   %esi
  802c8f:	53                   	push   %ebx
  802c90:	83 ec 1c             	sub    $0x1c,%esp
  802c93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802c97:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802ca3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ca7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cab:	89 f3                	mov    %esi,%ebx
  802cad:	89 fa                	mov    %edi,%edx
  802caf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802cb3:	89 34 24             	mov    %esi,(%esp)
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	75 1a                	jne    802cd4 <__umoddi3+0x48>
  802cba:	39 f7                	cmp    %esi,%edi
  802cbc:	0f 86 a2 00 00 00    	jbe    802d64 <__umoddi3+0xd8>
  802cc2:	89 c8                	mov    %ecx,%eax
  802cc4:	89 f2                	mov    %esi,%edx
  802cc6:	f7 f7                	div    %edi
  802cc8:	89 d0                	mov    %edx,%eax
  802cca:	31 d2                	xor    %edx,%edx
  802ccc:	83 c4 1c             	add    $0x1c,%esp
  802ccf:	5b                   	pop    %ebx
  802cd0:	5e                   	pop    %esi
  802cd1:	5f                   	pop    %edi
  802cd2:	5d                   	pop    %ebp
  802cd3:	c3                   	ret    
  802cd4:	39 f0                	cmp    %esi,%eax
  802cd6:	0f 87 ac 00 00 00    	ja     802d88 <__umoddi3+0xfc>
  802cdc:	0f bd e8             	bsr    %eax,%ebp
  802cdf:	83 f5 1f             	xor    $0x1f,%ebp
  802ce2:	0f 84 ac 00 00 00    	je     802d94 <__umoddi3+0x108>
  802ce8:	bf 20 00 00 00       	mov    $0x20,%edi
  802ced:	29 ef                	sub    %ebp,%edi
  802cef:	89 fe                	mov    %edi,%esi
  802cf1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cf5:	89 e9                	mov    %ebp,%ecx
  802cf7:	d3 e0                	shl    %cl,%eax
  802cf9:	89 d7                	mov    %edx,%edi
  802cfb:	89 f1                	mov    %esi,%ecx
  802cfd:	d3 ef                	shr    %cl,%edi
  802cff:	09 c7                	or     %eax,%edi
  802d01:	89 e9                	mov    %ebp,%ecx
  802d03:	d3 e2                	shl    %cl,%edx
  802d05:	89 14 24             	mov    %edx,(%esp)
  802d08:	89 d8                	mov    %ebx,%eax
  802d0a:	d3 e0                	shl    %cl,%eax
  802d0c:	89 c2                	mov    %eax,%edx
  802d0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d12:	d3 e0                	shl    %cl,%eax
  802d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d18:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d1c:	89 f1                	mov    %esi,%ecx
  802d1e:	d3 e8                	shr    %cl,%eax
  802d20:	09 d0                	or     %edx,%eax
  802d22:	d3 eb                	shr    %cl,%ebx
  802d24:	89 da                	mov    %ebx,%edx
  802d26:	f7 f7                	div    %edi
  802d28:	89 d3                	mov    %edx,%ebx
  802d2a:	f7 24 24             	mull   (%esp)
  802d2d:	89 c6                	mov    %eax,%esi
  802d2f:	89 d1                	mov    %edx,%ecx
  802d31:	39 d3                	cmp    %edx,%ebx
  802d33:	0f 82 87 00 00 00    	jb     802dc0 <__umoddi3+0x134>
  802d39:	0f 84 91 00 00 00    	je     802dd0 <__umoddi3+0x144>
  802d3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d43:	29 f2                	sub    %esi,%edx
  802d45:	19 cb                	sbb    %ecx,%ebx
  802d47:	89 d8                	mov    %ebx,%eax
  802d49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802d4d:	d3 e0                	shl    %cl,%eax
  802d4f:	89 e9                	mov    %ebp,%ecx
  802d51:	d3 ea                	shr    %cl,%edx
  802d53:	09 d0                	or     %edx,%eax
  802d55:	89 e9                	mov    %ebp,%ecx
  802d57:	d3 eb                	shr    %cl,%ebx
  802d59:	89 da                	mov    %ebx,%edx
  802d5b:	83 c4 1c             	add    $0x1c,%esp
  802d5e:	5b                   	pop    %ebx
  802d5f:	5e                   	pop    %esi
  802d60:	5f                   	pop    %edi
  802d61:	5d                   	pop    %ebp
  802d62:	c3                   	ret    
  802d63:	90                   	nop
  802d64:	89 fd                	mov    %edi,%ebp
  802d66:	85 ff                	test   %edi,%edi
  802d68:	75 0b                	jne    802d75 <__umoddi3+0xe9>
  802d6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802d6f:	31 d2                	xor    %edx,%edx
  802d71:	f7 f7                	div    %edi
  802d73:	89 c5                	mov    %eax,%ebp
  802d75:	89 f0                	mov    %esi,%eax
  802d77:	31 d2                	xor    %edx,%edx
  802d79:	f7 f5                	div    %ebp
  802d7b:	89 c8                	mov    %ecx,%eax
  802d7d:	f7 f5                	div    %ebp
  802d7f:	89 d0                	mov    %edx,%eax
  802d81:	e9 44 ff ff ff       	jmp    802cca <__umoddi3+0x3e>
  802d86:	66 90                	xchg   %ax,%ax
  802d88:	89 c8                	mov    %ecx,%eax
  802d8a:	89 f2                	mov    %esi,%edx
  802d8c:	83 c4 1c             	add    $0x1c,%esp
  802d8f:	5b                   	pop    %ebx
  802d90:	5e                   	pop    %esi
  802d91:	5f                   	pop    %edi
  802d92:	5d                   	pop    %ebp
  802d93:	c3                   	ret    
  802d94:	3b 04 24             	cmp    (%esp),%eax
  802d97:	72 06                	jb     802d9f <__umoddi3+0x113>
  802d99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802d9d:	77 0f                	ja     802dae <__umoddi3+0x122>
  802d9f:	89 f2                	mov    %esi,%edx
  802da1:	29 f9                	sub    %edi,%ecx
  802da3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802da7:	89 14 24             	mov    %edx,(%esp)
  802daa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802dae:	8b 44 24 04          	mov    0x4(%esp),%eax
  802db2:	8b 14 24             	mov    (%esp),%edx
  802db5:	83 c4 1c             	add    $0x1c,%esp
  802db8:	5b                   	pop    %ebx
  802db9:	5e                   	pop    %esi
  802dba:	5f                   	pop    %edi
  802dbb:	5d                   	pop    %ebp
  802dbc:	c3                   	ret    
  802dbd:	8d 76 00             	lea    0x0(%esi),%esi
  802dc0:	2b 04 24             	sub    (%esp),%eax
  802dc3:	19 fa                	sbb    %edi,%edx
  802dc5:	89 d1                	mov    %edx,%ecx
  802dc7:	89 c6                	mov    %eax,%esi
  802dc9:	e9 71 ff ff ff       	jmp    802d3f <__umoddi3+0xb3>
  802dce:	66 90                	xchg   %ax,%ax
  802dd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802dd4:	72 ea                	jb     802dc0 <__umoddi3+0x134>
  802dd6:	89 d9                	mov    %ebx,%ecx
  802dd8:	e9 62 ff ff ff       	jmp    802d3f <__umoddi3+0xb3>
