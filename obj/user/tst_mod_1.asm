
obj/user/tst_mod_1:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 2000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
	int envID = sys_getenvid();
  80003f:	e8 dc 1f 00 00       	call   802020 <sys_getenvid>
  800044:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("envID = %d\n",envID);
  800047:	83 ec 08             	sub    $0x8,%esp
  80004a:	ff 75 f4             	pushl  -0xc(%ebp)
  80004d:	68 80 27 80 00       	push   $0x802780
  800052:	e8 28 07 00 00       	call   80077f <cprintf>
  800057:	83 c4 10             	add    $0x10,%esp

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80005a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	01 c0                	add    %eax,%eax
  800066:	01 d0                	add    %edx,%eax
  800068:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 03             	shl    $0x3,%eax
  800074:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int Mega = 1024*1024;
  80007c:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  800083:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)


	uint8 *x ;
	{
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80008a:	e8 c6 20 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  80008f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800092:	e8 3b 20 00 00       	call   8020d2 <sys_calculate_free_frames>
  800097:	89 45 e0             	mov    %eax,-0x20(%ebp)

		//allocate 2 MB in the heap

		x = malloc(2*Mega) ;
  80009a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009d:	01 c0                	add    %eax,%eax
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	50                   	push   %eax
  8000a3:	e8 5a 14 00 00       	call   801502 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
		assert((uint32) x == USER_HEAP_START);
  8000ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000b1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000b6:	74 16                	je     8000ce <_main+0x96>
  8000b8:	68 8c 27 80 00       	push   $0x80278c
  8000bd:	68 aa 27 80 00       	push   $0x8027aa
  8000c2:	6a 1a                	push   $0x1a
  8000c4:	68 bf 27 80 00       	push   $0x8027bf
  8000c9:	e8 86 05 00 00       	call   800654 <_panic>
		//		cprintf("Allocated frames = %d\n", (freeFrames - sys_calculate_free_frames())) ;
		assert((freeFrames - sys_calculate_free_frames()) == (/*1 +*/ 1 + 2 * Mega / PAGE_SIZE));
  8000ce:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000d1:	e8 fc 1f 00 00       	call   8020d2 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 da                	mov    %ebx,%edx
  8000da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000dd:	01 c0                	add    %eax,%eax
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	79 05                	jns    8000e8 <_main+0xb0>
  8000e3:	05 ff 0f 00 00       	add    $0xfff,%eax
  8000e8:	c1 f8 0c             	sar    $0xc,%eax
  8000eb:	40                   	inc    %eax
  8000ec:	39 c2                	cmp    %eax,%edx
  8000ee:	74 16                	je     800106 <_main+0xce>
  8000f0:	68 d0 27 80 00       	push   $0x8027d0
  8000f5:	68 aa 27 80 00       	push   $0x8027aa
  8000fa:	6a 1c                	push   $0x1c
  8000fc:	68 bf 27 80 00       	push   $0x8027bf
  800101:	e8 4e 05 00 00       	call   800654 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  800106:	e8 4a 20 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  80010b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80010e:	74 16                	je     800126 <_main+0xee>
  800110:	68 1c 28 80 00       	push   $0x80281c
  800115:	68 aa 27 80 00       	push   $0x8027aa
  80011a:	6a 1d                	push   $0x1d
  80011c:	68 bf 27 80 00       	push   $0x8027bf
  800121:	e8 2e 05 00 00       	call   800654 <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2 * Mega / PAGE_SIZE);

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 a7 1f 00 00       	call   8020d2 <sys_calculate_free_frames>
  80012b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80012e:	e8 22 20 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  800133:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(2*Mega) == USER_HEAP_START + 2*Mega) ;
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 be 13 00 00       	call   801502 <malloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 c2                	mov    %eax,%edx
  800149:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80014c:	01 c0                	add    %eax,%eax
  80014e:	05 00 00 00 80       	add    $0x80000000,%eax
  800153:	39 c2                	cmp    %eax,%edx
  800155:	74 16                	je     80016d <_main+0x135>
  800157:	68 58 28 80 00       	push   $0x802858
  80015c:	68 aa 27 80 00       	push   $0x8027aa
  800161:	6a 22                	push   $0x22
  800163:	68 bf 27 80 00       	push   $0x8027bf
  800168:	e8 e7 04 00 00       	call   800654 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (2 * Mega / PAGE_SIZE));
  80016d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800170:	e8 5d 1f 00 00       	call   8020d2 <sys_calculate_free_frames>
  800175:	29 c3                	sub    %eax,%ebx
  800177:	89 da                	mov    %ebx,%edx
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	01 c0                	add    %eax,%eax
  80017e:	85 c0                	test   %eax,%eax
  800180:	79 05                	jns    800187 <_main+0x14f>
  800182:	05 ff 0f 00 00       	add    $0xfff,%eax
  800187:	c1 f8 0c             	sar    $0xc,%eax
  80018a:	39 c2                	cmp    %eax,%edx
  80018c:	74 16                	je     8001a4 <_main+0x16c>
  80018e:	68 8c 28 80 00       	push   $0x80288c
  800193:	68 aa 27 80 00       	push   $0x8027aa
  800198:	6a 23                	push   $0x23
  80019a:	68 bf 27 80 00       	push   $0x8027bf
  80019f:	e8 b0 04 00 00       	call   800654 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  8001a4:	e8 ac 1f 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001ac:	74 16                	je     8001c4 <_main+0x18c>
  8001ae:	68 1c 28 80 00       	push   $0x80281c
  8001b3:	68 aa 27 80 00       	push   $0x8027aa
  8001b8:	6a 24                	push   $0x24
  8001ba:	68 bf 27 80 00       	push   $0x8027bf
  8001bf:	e8 90 04 00 00       	call   800654 <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2 * Mega / PAGE_SIZE);

		freeFrames = sys_calculate_free_frames() ;
  8001c4:	e8 09 1f 00 00       	call   8020d2 <sys_calculate_free_frames>
  8001c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001cc:	e8 84 1f 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  8001d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(3*Mega) == USER_HEAP_START + 4*Mega) ;
  8001d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d7:	89 c2                	mov    %eax,%edx
  8001d9:	01 d2                	add    %edx,%edx
  8001db:	01 d0                	add    %edx,%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 1c 13 00 00       	call   801502 <malloc>
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001ee:	c1 e0 02             	shl    $0x2,%eax
  8001f1:	05 00 00 00 80       	add    $0x80000000,%eax
  8001f6:	39 c2                	cmp    %eax,%edx
  8001f8:	74 16                	je     800210 <_main+0x1d8>
  8001fa:	68 d4 28 80 00       	push   $0x8028d4
  8001ff:	68 aa 27 80 00       	push   $0x8027aa
  800204:	6a 29                	push   $0x29
  800206:	68 bf 27 80 00       	push   $0x8027bf
  80020b:	e8 44 04 00 00       	call   800654 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (/*1 +*/1 + 3 * Mega / PAGE_SIZE));
  800210:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800213:	e8 ba 1e 00 00       	call   8020d2 <sys_calculate_free_frames>
  800218:	89 d9                	mov    %ebx,%ecx
  80021a:	29 c1                	sub    %eax,%ecx
  80021c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021f:	89 c2                	mov    %eax,%edx
  800221:	01 d2                	add    %edx,%edx
  800223:	01 d0                	add    %edx,%eax
  800225:	85 c0                	test   %eax,%eax
  800227:	79 05                	jns    80022e <_main+0x1f6>
  800229:	05 ff 0f 00 00       	add    $0xfff,%eax
  80022e:	c1 f8 0c             	sar    $0xc,%eax
  800231:	40                   	inc    %eax
  800232:	39 c1                	cmp    %eax,%ecx
  800234:	74 16                	je     80024c <_main+0x214>
  800236:	68 08 29 80 00       	push   $0x802908
  80023b:	68 aa 27 80 00       	push   $0x8027aa
  800240:	6a 2a                	push   $0x2a
  800242:	68 bf 27 80 00       	push   $0x8027bf
  800247:	e8 08 04 00 00       	call   800654 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  80024c:	e8 04 1f 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  800251:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800254:	74 16                	je     80026c <_main+0x234>
  800256:	68 1c 28 80 00       	push   $0x80281c
  80025b:	68 aa 27 80 00       	push   $0x8027aa
  800260:	6a 2b                	push   $0x2b
  800262:	68 bf 27 80 00       	push   $0x8027bf
  800267:	e8 e8 03 00 00       	call   800654 <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 3 * Mega / PAGE_SIZE);

		freeFrames = sys_calculate_free_frames() ;
  80026c:	e8 61 1e 00 00       	call   8020d2 <sys_calculate_free_frames>
  800271:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800274:	e8 dc 1e 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(2*kilo) == USER_HEAP_START + 7*Mega) ;
  80027c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027f:	01 c0                	add    %eax,%eax
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	50                   	push   %eax
  800285:	e8 78 12 00 00       	call   801502 <malloc>
  80028a:	83 c4 10             	add    $0x10,%esp
  80028d:	89 c1                	mov    %eax,%ecx
  80028f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800292:	89 d0                	mov    %edx,%eax
  800294:	01 c0                	add    %eax,%eax
  800296:	01 d0                	add    %edx,%eax
  800298:	01 c0                	add    %eax,%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 16                	je     8002bb <_main+0x283>
  8002a5:	68 54 29 80 00       	push   $0x802954
  8002aa:	68 aa 27 80 00       	push   $0x8027aa
  8002af:	6a 30                	push   $0x30
  8002b1:	68 bf 27 80 00       	push   $0x8027bf
  8002b6:	e8 99 03 00 00       	call   800654 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  8002bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8002be:	e8 0f 1e 00 00       	call   8020d2 <sys_calculate_free_frames>
  8002c3:	29 c3                	sub    %eax,%ebx
  8002c5:	89 d8                	mov    %ebx,%eax
  8002c7:	83 f8 01             	cmp    $0x1,%eax
  8002ca:	74 16                	je     8002e2 <_main+0x2aa>
  8002cc:	68 88 29 80 00       	push   $0x802988
  8002d1:	68 aa 27 80 00       	push   $0x8027aa
  8002d6:	6a 31                	push   $0x31
  8002d8:	68 bf 27 80 00       	push   $0x8027bf
  8002dd:	e8 72 03 00 00       	call   800654 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  8002e2:	e8 6e 1e 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  8002e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8002ea:	74 16                	je     800302 <_main+0x2ca>
  8002ec:	68 1c 28 80 00       	push   $0x80281c
  8002f1:	68 aa 27 80 00       	push   $0x8027aa
  8002f6:	6a 32                	push   $0x32
  8002f8:	68 bf 27 80 00       	push   $0x8027bf
  8002fd:	e8 52 03 00 00       	call   800654 <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);

		freeFrames = sys_calculate_free_frames() ;
  800302:	e8 cb 1d 00 00       	call   8020d2 <sys_calculate_free_frames>
  800307:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80030a:	e8 46 1e 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  80030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(2*kilo) == USER_HEAP_START + 7*Mega + 4*kilo) ;
  800312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800315:	01 c0                	add    %eax,%eax
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	50                   	push   %eax
  80031b:	e8 e2 11 00 00       	call   801502 <malloc>
  800320:	83 c4 10             	add    $0x10,%esp
  800323:	89 c1                	mov    %eax,%ecx
  800325:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800328:	89 d0                	mov    %edx,%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	01 c0                	add    %eax,%eax
  800330:	01 d0                	add    %edx,%eax
  800332:	89 c2                	mov    %eax,%edx
  800334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800337:	c1 e0 02             	shl    $0x2,%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	05 00 00 00 80       	add    $0x80000000,%eax
  800341:	39 c1                	cmp    %eax,%ecx
  800343:	74 16                	je     80035b <_main+0x323>
  800345:	68 bc 29 80 00       	push   $0x8029bc
  80034a:	68 aa 27 80 00       	push   $0x8027aa
  80034f:	6a 37                	push   $0x37
  800351:	68 bf 27 80 00       	push   $0x8027bf
  800356:	e8 f9 02 00 00       	call   800654 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  80035b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80035e:	e8 6f 1d 00 00       	call   8020d2 <sys_calculate_free_frames>
  800363:	29 c3                	sub    %eax,%ebx
  800365:	89 d8                	mov    %ebx,%eax
  800367:	83 f8 01             	cmp    $0x1,%eax
  80036a:	74 16                	je     800382 <_main+0x34a>
  80036c:	68 88 29 80 00       	push   $0x802988
  800371:	68 aa 27 80 00       	push   $0x8027aa
  800376:	6a 38                	push   $0x38
  800378:	68 bf 27 80 00       	push   $0x8027bf
  80037d:	e8 d2 02 00 00       	call   800654 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  800382:	e8 ce 1d 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  800387:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80038a:	74 16                	je     8003a2 <_main+0x36a>
  80038c:	68 1c 28 80 00       	push   $0x80281c
  800391:	68 aa 27 80 00       	push   $0x8027aa
  800396:	6a 39                	push   $0x39
  800398:	68 bf 27 80 00       	push   $0x8027bf
  80039d:	e8 b2 02 00 00       	call   800654 <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);

		freeFrames = sys_calculate_free_frames() ;
  8003a2:	e8 2b 1d 00 00       	call   8020d2 <sys_calculate_free_frames>
  8003a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003aa:	e8 a6 1d 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  8003af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(7*kilo) == USER_HEAP_START + 7*Mega + 8*kilo) ;
  8003b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b5:	89 d0                	mov    %edx,%eax
  8003b7:	01 c0                	add    %eax,%eax
  8003b9:	01 d0                	add    %edx,%eax
  8003bb:	01 c0                	add    %eax,%eax
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	50                   	push   %eax
  8003c3:	e8 3a 11 00 00       	call   801502 <malloc>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 c1                	mov    %eax,%ecx
  8003cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003d0:	89 d0                	mov    %edx,%eax
  8003d2:	01 c0                	add    %eax,%eax
  8003d4:	01 d0                	add    %edx,%eax
  8003d6:	01 c0                	add    %eax,%eax
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	89 c2                	mov    %eax,%edx
  8003dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003df:	c1 e0 03             	shl    $0x3,%eax
  8003e2:	01 d0                	add    %edx,%eax
  8003e4:	05 00 00 00 80       	add    $0x80000000,%eax
  8003e9:	39 c1                	cmp    %eax,%ecx
  8003eb:	74 16                	je     800403 <_main+0x3cb>
  8003ed:	68 f8 29 80 00       	push   $0x8029f8
  8003f2:	68 aa 27 80 00       	push   $0x8027aa
  8003f7:	6a 3e                	push   $0x3e
  8003f9:	68 bf 27 80 00       	push   $0x8027bf
  8003fe:	e8 51 02 00 00       	call   800654 <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (2));
  800403:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800406:	e8 c7 1c 00 00       	call   8020d2 <sys_calculate_free_frames>
  80040b:	29 c3                	sub    %eax,%ebx
  80040d:	89 d8                	mov    %ebx,%eax
  80040f:	83 f8 02             	cmp    $0x2,%eax
  800412:	74 16                	je     80042a <_main+0x3f2>
  800414:	68 34 2a 80 00       	push   $0x802a34
  800419:	68 aa 27 80 00       	push   $0x8027aa
  80041e:	6a 3f                	push   $0x3f
  800420:	68 bf 27 80 00       	push   $0x8027bf
  800425:	e8 2a 02 00 00       	call   800654 <_panic>
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  80042a:	e8 26 1d 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  80042f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800432:	74 16                	je     80044a <_main+0x412>
  800434:	68 1c 28 80 00       	push   $0x80281c
  800439:	68 aa 27 80 00       	push   $0x8027aa
  80043e:	6a 40                	push   $0x40
  800440:	68 bf 27 80 00       	push   $0x8027bf
  800445:	e8 0a 02 00 00       	call   800654 <_panic>
	}

	///====================


	int freeFrames = sys_calculate_free_frames() ;
  80044a:	e8 83 1c 00 00       	call   8020d2 <sys_calculate_free_frames>
  80044f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800452:	e8 fe 1c 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  800457:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	{
		x[0] = -1 ;
  80045a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80045d:	c6 00 ff             	movb   $0xff,(%eax)
		x[2*Mega] = -1 ;
  800460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800463:	01 c0                	add    %eax,%eax
  800465:	89 c2                	mov    %eax,%edx
  800467:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80046a:	01 d0                	add    %edx,%eax
  80046c:	c6 00 ff             	movb   $0xff,(%eax)
		x[3*Mega] = -1 ;
  80046f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800472:	89 c2                	mov    %eax,%edx
  800474:	01 d2                	add    %edx,%edx
  800476:	01 d0                	add    %edx,%eax
  800478:	89 c2                	mov    %eax,%edx
  80047a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c6 00 ff             	movb   $0xff,(%eax)
		x[4*Mega] = -1 ;
  800482:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800485:	c1 e0 02             	shl    $0x2,%eax
  800488:	89 c2                	mov    %eax,%edx
  80048a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	c6 00 ff             	movb   $0xff,(%eax)
		x[5*Mega] = -1 ;
  800492:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800495:	89 d0                	mov    %edx,%eax
  800497:	c1 e0 02             	shl    $0x2,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	c6 00 ff             	movb   $0xff,(%eax)
		x[6*Mega] = -1 ;
  8004a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004a9:	89 d0                	mov    %edx,%eax
  8004ab:	01 c0                	add    %eax,%eax
  8004ad:	01 d0                	add    %edx,%eax
  8004af:	01 c0                	add    %eax,%eax
  8004b1:	89 c2                	mov    %eax,%edx
  8004b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega-1] = -1 ;
  8004bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004be:	89 d0                	mov    %edx,%eax
  8004c0:	01 c0                	add    %eax,%eax
  8004c2:	01 d0                	add    %edx,%eax
  8004c4:	01 c0                	add    %eax,%eax
  8004c6:	01 d0                	add    %edx,%eax
  8004c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ce:	01 d0                	add    %edx,%eax
  8004d0:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega+1*kilo] = -1 ;
  8004d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004d6:	89 d0                	mov    %edx,%eax
  8004d8:	01 c0                	add    %eax,%eax
  8004da:	01 d0                	add    %edx,%eax
  8004dc:	01 c0                	add    %eax,%eax
  8004de:	01 c2                	add    %eax,%edx
  8004e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e3:	01 d0                	add    %edx,%eax
  8004e5:	89 c2                	mov    %eax,%edx
  8004e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ea:	01 d0                	add    %edx,%eax
  8004ec:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega+5*kilo] = -1 ;
  8004ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f2:	89 d0                	mov    %edx,%eax
  8004f4:	01 c0                	add    %eax,%eax
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	01 c0                	add    %eax,%eax
  8004fa:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8004fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800500:	89 d0                	mov    %edx,%eax
  800502:	c1 e0 02             	shl    $0x2,%eax
  800505:	01 d0                	add    %edx,%eax
  800507:	01 c8                	add    %ecx,%eax
  800509:	89 c2                	mov    %eax,%edx
  80050b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80050e:	01 d0                	add    %edx,%eax
  800510:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega+10*kilo] = -1 ;
  800513:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800516:	89 d0                	mov    %edx,%eax
  800518:	01 c0                	add    %eax,%eax
  80051a:	01 d0                	add    %edx,%eax
  80051c:	01 c0                	add    %eax,%eax
  80051e:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800521:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800524:	89 d0                	mov    %edx,%eax
  800526:	c1 e0 02             	shl    $0x2,%eax
  800529:	01 d0                	add    %edx,%eax
  80052b:	01 c0                	add    %eax,%eax
  80052d:	01 c8                	add    %ecx,%eax
  80052f:	89 c2                	mov    %eax,%edx
  800531:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	c6 00 ff             	movb   $0xff,(%eax)
	}

	assert((freeFrames - sys_calculate_free_frames()) == 0 );
  800539:	e8 94 1b 00 00       	call   8020d2 <sys_calculate_free_frames>
  80053e:	89 c2                	mov    %eax,%edx
  800540:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800543:	39 c2                	cmp    %eax,%edx
  800545:	74 16                	je     80055d <_main+0x525>
  800547:	68 68 2a 80 00       	push   $0x802a68
  80054c:	68 aa 27 80 00       	push   $0x8027aa
  800551:	6a 56                	push   $0x56
  800553:	68 bf 27 80 00       	push   $0x8027bf
  800558:	e8 f7 00 00 00       	call   800654 <_panic>
	assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  80055d:	e8 f3 1b 00 00       	call   802155 <sys_pf_calculate_allocated_pages>
  800562:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800565:	74 16                	je     80057d <_main+0x545>
  800567:	68 1c 28 80 00       	push   $0x80281c
  80056c:	68 aa 27 80 00       	push   $0x8027aa
  800571:	6a 57                	push   $0x57
  800573:	68 bf 27 80 00       	push   $0x8027bf
  800578:	e8 d7 00 00 00       	call   800654 <_panic>

	cprintf("Congratulations!! your modification is completed successfully.\n");
  80057d:	83 ec 0c             	sub    $0xc,%esp
  800580:	68 98 2a 80 00       	push   $0x802a98
  800585:	e8 f5 01 00 00       	call   80077f <cprintf>
  80058a:	83 c4 10             	add    $0x10,%esp

	return;
  80058d:	90                   	nop
}
  80058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800599:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80059d:	7e 0a                	jle    8005a9 <libmain+0x16>
		binaryname = argv[0];
  80059f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 0c             	pushl  0xc(%ebp)
  8005af:	ff 75 08             	pushl  0x8(%ebp)
  8005b2:	e8 81 fa ff ff       	call   800038 <_main>
  8005b7:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8005ba:	e8 61 1a 00 00       	call   802020 <sys_getenvid>
  8005bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8005c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005c5:	89 d0                	mov    %edx,%eax
  8005c7:	c1 e0 03             	shl    $0x3,%eax
  8005ca:	01 d0                	add    %edx,%eax
  8005cc:	01 c0                	add    %eax,%eax
  8005ce:	01 d0                	add    %edx,%eax
  8005d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d7:	01 d0                	add    %edx,%eax
  8005d9:	c1 e0 03             	shl    $0x3,%eax
  8005dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005e1:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  8005e4:	e8 85 1b 00 00       	call   80216e <sys_disable_interrupt>
		cprintf("**************************************\n");
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	68 f0 2a 80 00       	push   $0x802af0
  8005f1:	e8 89 01 00 00       	call   80077f <cprintf>
  8005f6:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fc:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	50                   	push   %eax
  800606:	68 18 2b 80 00       	push   $0x802b18
  80060b:	e8 6f 01 00 00       	call   80077f <cprintf>
  800610:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800613:	83 ec 0c             	sub    $0xc,%esp
  800616:	68 f0 2a 80 00       	push   $0x802af0
  80061b:	e8 5f 01 00 00       	call   80077f <cprintf>
  800620:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800623:	e8 60 1b 00 00       	call   802188 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800628:	e8 19 00 00 00       	call   800646 <exit>
}
  80062d:	90                   	nop
  80062e:	c9                   	leave  
  80062f:	c3                   	ret    

00800630 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
  800633:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800636:	83 ec 0c             	sub    $0xc,%esp
  800639:	6a 00                	push   $0x0
  80063b:	e8 c5 19 00 00       	call   802005 <sys_env_destroy>
  800640:	83 c4 10             	add    $0x10,%esp
}
  800643:	90                   	nop
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <exit>:

void
exit(void)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80064c:	e8 e8 19 00 00       	call   802039 <sys_env_exit>
}
  800651:	90                   	nop
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80065a:	8d 45 10             	lea    0x10(%ebp),%eax
  80065d:	83 c0 04             	add    $0x4,%eax
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800663:	a1 50 30 98 00       	mov    0x983050,%eax
  800668:	85 c0                	test   %eax,%eax
  80066a:	74 16                	je     800682 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80066c:	a1 50 30 98 00       	mov    0x983050,%eax
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	50                   	push   %eax
  800675:	68 31 2b 80 00       	push   $0x802b31
  80067a:	e8 00 01 00 00       	call   80077f <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800682:	a1 00 30 80 00       	mov    0x803000,%eax
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	ff 75 08             	pushl  0x8(%ebp)
  80068d:	50                   	push   %eax
  80068e:	68 36 2b 80 00       	push   $0x802b36
  800693:	e8 e7 00 00 00       	call   80077f <cprintf>
  800698:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80069b:	8b 45 10             	mov    0x10(%ebp),%eax
  80069e:	83 ec 08             	sub    $0x8,%esp
  8006a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a4:	50                   	push   %eax
  8006a5:	e8 7a 00 00 00       	call   800724 <vcprintf>
  8006aa:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8006ad:	83 ec 0c             	sub    $0xc,%esp
  8006b0:	68 52 2b 80 00       	push   $0x802b52
  8006b5:	e8 c5 00 00 00       	call   80077f <cprintf>
  8006ba:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8006bd:	e8 84 ff ff ff       	call   800646 <exit>

	// should not return here
	while (1) ;
  8006c2:	eb fe                	jmp    8006c2 <_panic+0x6e>

008006c4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8006d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d5:	89 0a                	mov    %ecx,(%edx)
  8006d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8006da:	88 d1                	mov    %dl,%cl
  8006dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006df:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ed:	75 23                	jne    800712 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  8006ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	89 c2                	mov    %eax,%edx
  8006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f9:	83 c0 08             	add    $0x8,%eax
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	52                   	push   %edx
  800700:	50                   	push   %eax
  800701:	e8 c9 18 00 00       	call   801fcf <sys_cputs>
  800706:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800712:	8b 45 0c             	mov    0xc(%ebp),%eax
  800715:	8b 40 04             	mov    0x4(%eax),%eax
  800718:	8d 50 01             	lea    0x1(%eax),%edx
  80071b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800721:	90                   	nop
  800722:	c9                   	leave  
  800723:	c3                   	ret    

00800724 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80072d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800734:	00 00 00 
	b.cnt = 0;
  800737:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80073e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	ff 75 08             	pushl  0x8(%ebp)
  800747:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074d:	50                   	push   %eax
  80074e:	68 c4 06 80 00       	push   $0x8006c4
  800753:	e8 fa 01 00 00       	call   800952 <vprintfmt>
  800758:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80075b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	50                   	push   %eax
  800765:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076b:	83 c0 08             	add    $0x8,%eax
  80076e:	50                   	push   %eax
  80076f:	e8 5b 18 00 00       	call   801fcf <sys_cputs>
  800774:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800777:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80077d:	c9                   	leave  
  80077e:	c3                   	ret    

0080077f <cprintf>:

int cprintf(const char *fmt, ...) {
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800785:	8d 45 0c             	lea    0xc(%ebp),%eax
  800788:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 f4             	pushl  -0xc(%ebp)
  800794:	50                   	push   %eax
  800795:	e8 8a ff ff ff       	call   800724 <vcprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a3:	c9                   	leave  
  8007a4:	c3                   	ret    

008007a5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007ab:	e8 be 19 00 00       	call   80216e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007b0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bf:	50                   	push   %eax
  8007c0:	e8 5f ff ff ff       	call   800724 <vcprintf>
  8007c5:	83 c4 10             	add    $0x10,%esp
  8007c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007cb:	e8 b8 19 00 00       	call   802188 <sys_enable_interrupt>
	return cnt;
  8007d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d3:	c9                   	leave  
  8007d4:	c3                   	ret    

008007d5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	53                   	push   %ebx
  8007d9:	83 ec 14             	sub    $0x14,%esp
  8007dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f3:	77 55                	ja     80084a <printnum+0x75>
  8007f5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f8:	72 05                	jb     8007ff <printnum+0x2a>
  8007fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007fd:	77 4b                	ja     80084a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007ff:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800802:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800805:	8b 45 18             	mov    0x18(%ebp),%eax
  800808:	ba 00 00 00 00       	mov    $0x0,%edx
  80080d:	52                   	push   %edx
  80080e:	50                   	push   %eax
  80080f:	ff 75 f4             	pushl  -0xc(%ebp)
  800812:	ff 75 f0             	pushl  -0x10(%ebp)
  800815:	e8 f2 1c 00 00       	call   80250c <__udivdi3>
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	83 ec 04             	sub    $0x4,%esp
  800820:	ff 75 20             	pushl  0x20(%ebp)
  800823:	53                   	push   %ebx
  800824:	ff 75 18             	pushl  0x18(%ebp)
  800827:	52                   	push   %edx
  800828:	50                   	push   %eax
  800829:	ff 75 0c             	pushl  0xc(%ebp)
  80082c:	ff 75 08             	pushl  0x8(%ebp)
  80082f:	e8 a1 ff ff ff       	call   8007d5 <printnum>
  800834:	83 c4 20             	add    $0x20,%esp
  800837:	eb 1a                	jmp    800853 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 0c             	pushl  0xc(%ebp)
  80083f:	ff 75 20             	pushl  0x20(%ebp)
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80084a:	ff 4d 1c             	decl   0x1c(%ebp)
  80084d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800851:	7f e6                	jg     800839 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800853:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800856:	bb 00 00 00 00       	mov    $0x0,%ebx
  80085b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800861:	53                   	push   %ebx
  800862:	51                   	push   %ecx
  800863:	52                   	push   %edx
  800864:	50                   	push   %eax
  800865:	e8 b2 1d 00 00       	call   80261c <__umoddi3>
  80086a:	83 c4 10             	add    $0x10,%esp
  80086d:	05 74 2d 80 00       	add    $0x802d74,%eax
  800872:	8a 00                	mov    (%eax),%al
  800874:	0f be c0             	movsbl %al,%eax
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	50                   	push   %eax
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	ff d0                	call   *%eax
  800883:	83 c4 10             	add    $0x10,%esp
}
  800886:	90                   	nop
  800887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    

0080088c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80088f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800893:	7e 1c                	jle    8008b1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	8d 50 08             	lea    0x8(%eax),%edx
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	89 10                	mov    %edx,(%eax)
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	83 e8 08             	sub    $0x8,%eax
  8008aa:	8b 50 04             	mov    0x4(%eax),%edx
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	eb 40                	jmp    8008f1 <getuint+0x65>
	else if (lflag)
  8008b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b5:	74 1e                	je     8008d5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	8d 50 04             	lea    0x4(%eax),%edx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	89 10                	mov    %edx,(%eax)
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	83 e8 04             	sub    $0x4,%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d3:	eb 1c                	jmp    8008f1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	8d 50 04             	lea    0x4(%eax),%edx
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	89 10                	mov    %edx,(%eax)
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	83 e8 04             	sub    $0x4,%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008f1:	5d                   	pop    %ebp
  8008f2:	c3                   	ret    

008008f3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008fa:	7e 1c                	jle    800918 <getint+0x25>
		return va_arg(*ap, long long);
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	8d 50 08             	lea    0x8(%eax),%edx
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	89 10                	mov    %edx,(%eax)
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	83 e8 08             	sub    $0x8,%eax
  800911:	8b 50 04             	mov    0x4(%eax),%edx
  800914:	8b 00                	mov    (%eax),%eax
  800916:	eb 38                	jmp    800950 <getint+0x5d>
	else if (lflag)
  800918:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091c:	74 1a                	je     800938 <getint+0x45>
		return va_arg(*ap, long);
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8d 50 04             	lea    0x4(%eax),%edx
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	89 10                	mov    %edx,(%eax)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	83 e8 04             	sub    $0x4,%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	99                   	cltd   
  800936:	eb 18                	jmp    800950 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	8d 50 04             	lea    0x4(%eax),%edx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	89 10                	mov    %edx,(%eax)
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	83 e8 04             	sub    $0x4,%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	99                   	cltd   
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	56                   	push   %esi
  800956:	53                   	push   %ebx
  800957:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095a:	eb 17                	jmp    800973 <vprintfmt+0x21>
			if (ch == '\0')
  80095c:	85 db                	test   %ebx,%ebx
  80095e:	0f 84 af 03 00 00    	je     800d13 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 0c             	pushl  0xc(%ebp)
  80096a:	53                   	push   %ebx
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	ff d0                	call   *%eax
  800970:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800973:	8b 45 10             	mov    0x10(%ebp),%eax
  800976:	8d 50 01             	lea    0x1(%eax),%edx
  800979:	89 55 10             	mov    %edx,0x10(%ebp)
  80097c:	8a 00                	mov    (%eax),%al
  80097e:	0f b6 d8             	movzbl %al,%ebx
  800981:	83 fb 25             	cmp    $0x25,%ebx
  800984:	75 d6                	jne    80095c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800986:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80098a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800991:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800998:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80099f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a9:	8d 50 01             	lea    0x1(%eax),%edx
  8009ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8009af:	8a 00                	mov    (%eax),%al
  8009b1:	0f b6 d8             	movzbl %al,%ebx
  8009b4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009b7:	83 f8 55             	cmp    $0x55,%eax
  8009ba:	0f 87 2b 03 00 00    	ja     800ceb <vprintfmt+0x399>
  8009c0:	8b 04 85 98 2d 80 00 	mov    0x802d98(,%eax,4),%eax
  8009c7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009cd:	eb d7                	jmp    8009a6 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009cf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009d3:	eb d1                	jmp    8009a6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009df:	89 d0                	mov    %edx,%eax
  8009e1:	c1 e0 02             	shl    $0x2,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	01 c0                	add    %eax,%eax
  8009e8:	01 d8                	add    %ebx,%eax
  8009ea:	83 e8 30             	sub    $0x30,%eax
  8009ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f3:	8a 00                	mov    (%eax),%al
  8009f5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f8:	83 fb 2f             	cmp    $0x2f,%ebx
  8009fb:	7e 3e                	jle    800a3b <vprintfmt+0xe9>
  8009fd:	83 fb 39             	cmp    $0x39,%ebx
  800a00:	7f 39                	jg     800a3b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a02:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a05:	eb d5                	jmp    8009dc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 c0 04             	add    $0x4,%eax
  800a0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	83 e8 04             	sub    $0x4,%eax
  800a16:	8b 00                	mov    (%eax),%eax
  800a18:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a1b:	eb 1f                	jmp    800a3c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a21:	79 83                	jns    8009a6 <vprintfmt+0x54>
				width = 0;
  800a23:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a2a:	e9 77 ff ff ff       	jmp    8009a6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a2f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a36:	e9 6b ff ff ff       	jmp    8009a6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a3b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a40:	0f 89 60 ff ff ff    	jns    8009a6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a4c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a53:	e9 4e ff ff ff       	jmp    8009a6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a58:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a5b:	e9 46 ff ff ff       	jmp    8009a6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 c0 04             	add    $0x4,%eax
  800a66:	89 45 14             	mov    %eax,0x14(%ebp)
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 e8 04             	sub    $0x4,%eax
  800a6f:	8b 00                	mov    (%eax),%eax
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	50                   	push   %eax
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
			break;
  800a80:	e9 89 02 00 00       	jmp    800d0e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 c0 04             	add    $0x4,%eax
  800a8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 e8 04             	sub    $0x4,%eax
  800a94:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a96:	85 db                	test   %ebx,%ebx
  800a98:	79 02                	jns    800a9c <vprintfmt+0x14a>
				err = -err;
  800a9a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a9c:	83 fb 64             	cmp    $0x64,%ebx
  800a9f:	7f 0b                	jg     800aac <vprintfmt+0x15a>
  800aa1:	8b 34 9d e0 2b 80 00 	mov    0x802be0(,%ebx,4),%esi
  800aa8:	85 f6                	test   %esi,%esi
  800aaa:	75 19                	jne    800ac5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aac:	53                   	push   %ebx
  800aad:	68 85 2d 80 00       	push   $0x802d85
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	ff 75 08             	pushl  0x8(%ebp)
  800ab8:	e8 5e 02 00 00       	call   800d1b <printfmt>
  800abd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ac0:	e9 49 02 00 00       	jmp    800d0e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac5:	56                   	push   %esi
  800ac6:	68 8e 2d 80 00       	push   $0x802d8e
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	ff 75 08             	pushl  0x8(%ebp)
  800ad1:	e8 45 02 00 00       	call   800d1b <printfmt>
  800ad6:	83 c4 10             	add    $0x10,%esp
			break;
  800ad9:	e9 30 02 00 00       	jmp    800d0e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 c0 04             	add    $0x4,%eax
  800ae4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	83 e8 04             	sub    $0x4,%eax
  800aed:	8b 30                	mov    (%eax),%esi
  800aef:	85 f6                	test   %esi,%esi
  800af1:	75 05                	jne    800af8 <vprintfmt+0x1a6>
				p = "(null)";
  800af3:	be 91 2d 80 00       	mov    $0x802d91,%esi
			if (width > 0 && padc != '-')
  800af8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afc:	7e 6d                	jle    800b6b <vprintfmt+0x219>
  800afe:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b02:	74 67                	je     800b6b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	50                   	push   %eax
  800b0b:	56                   	push   %esi
  800b0c:	e8 0c 03 00 00       	call   800e1d <strnlen>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b17:	eb 16                	jmp    800b2f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b19:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	50                   	push   %eax
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b33:	7f e4                	jg     800b19 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b35:	eb 34                	jmp    800b6b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b37:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b3b:	74 1c                	je     800b59 <vprintfmt+0x207>
  800b3d:	83 fb 1f             	cmp    $0x1f,%ebx
  800b40:	7e 05                	jle    800b47 <vprintfmt+0x1f5>
  800b42:	83 fb 7e             	cmp    $0x7e,%ebx
  800b45:	7e 12                	jle    800b59 <vprintfmt+0x207>
					putch('?', putdat);
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	6a 3f                	push   $0x3f
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	ff d0                	call   *%eax
  800b54:	83 c4 10             	add    $0x10,%esp
  800b57:	eb 0f                	jmp    800b68 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	53                   	push   %ebx
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b68:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6b:	89 f0                	mov    %esi,%eax
  800b6d:	8d 70 01             	lea    0x1(%eax),%esi
  800b70:	8a 00                	mov    (%eax),%al
  800b72:	0f be d8             	movsbl %al,%ebx
  800b75:	85 db                	test   %ebx,%ebx
  800b77:	74 24                	je     800b9d <vprintfmt+0x24b>
  800b79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7d:	78 b8                	js     800b37 <vprintfmt+0x1e5>
  800b7f:	ff 4d e0             	decl   -0x20(%ebp)
  800b82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b86:	79 af                	jns    800b37 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b88:	eb 13                	jmp    800b9d <vprintfmt+0x24b>
				putch(' ', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 20                	push   $0x20
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba1:	7f e7                	jg     800b8a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ba3:	e9 66 01 00 00       	jmp    800d0e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ba8:	83 ec 08             	sub    $0x8,%esp
  800bab:	ff 75 e8             	pushl  -0x18(%ebp)
  800bae:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb1:	50                   	push   %eax
  800bb2:	e8 3c fd ff ff       	call   8008f3 <getint>
  800bb7:	83 c4 10             	add    $0x10,%esp
  800bba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc6:	85 d2                	test   %edx,%edx
  800bc8:	79 23                	jns    800bed <vprintfmt+0x29b>
				putch('-', putdat);
  800bca:	83 ec 08             	sub    $0x8,%esp
  800bcd:	ff 75 0c             	pushl  0xc(%ebp)
  800bd0:	6a 2d                	push   $0x2d
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	ff d0                	call   *%eax
  800bd7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be0:	f7 d8                	neg    %eax
  800be2:	83 d2 00             	adc    $0x0,%edx
  800be5:	f7 da                	neg    %edx
  800be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf4:	e9 bc 00 00 00       	jmp    800cb5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 e8             	pushl  -0x18(%ebp)
  800bff:	8d 45 14             	lea    0x14(%ebp),%eax
  800c02:	50                   	push   %eax
  800c03:	e8 84 fc ff ff       	call   80088c <getuint>
  800c08:	83 c4 10             	add    $0x10,%esp
  800c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c18:	e9 98 00 00 00       	jmp    800cb5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 0c             	pushl  0xc(%ebp)
  800c23:	6a 58                	push   $0x58
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	ff d0                	call   *%eax
  800c2a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c2d:	83 ec 08             	sub    $0x8,%esp
  800c30:	ff 75 0c             	pushl  0xc(%ebp)
  800c33:	6a 58                	push   $0x58
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	ff d0                	call   *%eax
  800c3a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	ff 75 0c             	pushl  0xc(%ebp)
  800c43:	6a 58                	push   $0x58
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	ff d0                	call   *%eax
  800c4a:	83 c4 10             	add    $0x10,%esp
			break;
  800c4d:	e9 bc 00 00 00       	jmp    800d0e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	6a 30                	push   $0x30
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	ff d0                	call   *%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	6a 78                	push   $0x78
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	ff d0                	call   *%eax
  800c6f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 c0 04             	add    $0x4,%eax
  800c78:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7e:	83 e8 04             	sub    $0x4,%eax
  800c81:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c8d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c94:	eb 1f                	jmp    800cb5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c96:	83 ec 08             	sub    $0x8,%esp
  800c99:	ff 75 e8             	pushl  -0x18(%ebp)
  800c9c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9f:	50                   	push   %eax
  800ca0:	e8 e7 fb ff ff       	call   80088c <getuint>
  800ca5:	83 c4 10             	add    $0x10,%esp
  800ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cae:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	52                   	push   %edx
  800cc0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cc3:	50                   	push   %eax
  800cc4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc7:	ff 75 f0             	pushl  -0x10(%ebp)
  800cca:	ff 75 0c             	pushl  0xc(%ebp)
  800ccd:	ff 75 08             	pushl  0x8(%ebp)
  800cd0:	e8 00 fb ff ff       	call   8007d5 <printnum>
  800cd5:	83 c4 20             	add    $0x20,%esp
			break;
  800cd8:	eb 34                	jmp    800d0e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cda:	83 ec 08             	sub    $0x8,%esp
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	53                   	push   %ebx
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	ff d0                	call   *%eax
  800ce6:	83 c4 10             	add    $0x10,%esp
			break;
  800ce9:	eb 23                	jmp    800d0e <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ceb:	83 ec 08             	sub    $0x8,%esp
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	6a 25                	push   $0x25
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cfb:	ff 4d 10             	decl   0x10(%ebp)
  800cfe:	eb 03                	jmp    800d03 <vprintfmt+0x3b1>
  800d00:	ff 4d 10             	decl   0x10(%ebp)
  800d03:	8b 45 10             	mov    0x10(%ebp),%eax
  800d06:	48                   	dec    %eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	3c 25                	cmp    $0x25,%al
  800d0b:	75 f3                	jne    800d00 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d0d:	90                   	nop
		}
	}
  800d0e:	e9 47 fc ff ff       	jmp    80095a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d13:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d21:	8d 45 10             	lea    0x10(%ebp),%eax
  800d24:	83 c0 04             	add    $0x4,%eax
  800d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d30:	50                   	push   %eax
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	ff 75 08             	pushl  0x8(%ebp)
  800d37:	e8 16 fc ff ff       	call   800952 <vprintfmt>
  800d3c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d3f:	90                   	nop
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	8b 40 08             	mov    0x8(%eax),%eax
  800d4b:	8d 50 01             	lea    0x1(%eax),%edx
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	8b 10                	mov    (%eax),%edx
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8b 40 04             	mov    0x4(%eax),%eax
  800d5f:	39 c2                	cmp    %eax,%edx
  800d61:	73 12                	jae    800d75 <sprintputch+0x33>
		*b->buf++ = ch;
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8b 00                	mov    (%eax),%eax
  800d68:	8d 48 01             	lea    0x1(%eax),%ecx
  800d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6e:	89 0a                	mov    %ecx,(%edx)
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	88 10                	mov    %dl,(%eax)
}
  800d75:	90                   	nop
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	01 d0                	add    %edx,%eax
  800d8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d9d:	74 06                	je     800da5 <vsnprintf+0x2d>
  800d9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da3:	7f 07                	jg     800dac <vsnprintf+0x34>
		return -E_INVAL;
  800da5:	b8 03 00 00 00       	mov    $0x3,%eax
  800daa:	eb 20                	jmp    800dcc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dac:	ff 75 14             	pushl  0x14(%ebp)
  800daf:	ff 75 10             	pushl  0x10(%ebp)
  800db2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800db5:	50                   	push   %eax
  800db6:	68 42 0d 80 00       	push   $0x800d42
  800dbb:	e8 92 fb ff ff       	call   800952 <vprintfmt>
  800dc0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dd4:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd7:	83 c0 04             	add    $0x4,%eax
  800dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  800de0:	ff 75 f4             	pushl  -0xc(%ebp)
  800de3:	50                   	push   %eax
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	ff 75 08             	pushl  0x8(%ebp)
  800dea:	e8 89 ff ff ff       	call   800d78 <vsnprintf>
  800def:	83 c4 10             	add    $0x10,%esp
  800df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e07:	eb 06                	jmp    800e0f <strlen+0x15>
		n++;
  800e09:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0c:	ff 45 08             	incl   0x8(%ebp)
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	84 c0                	test   %al,%al
  800e16:	75 f1                	jne    800e09 <strlen+0xf>
		n++;
	return n;
  800e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1b:	c9                   	leave  
  800e1c:	c3                   	ret    

00800e1d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2a:	eb 09                	jmp    800e35 <strnlen+0x18>
		n++;
  800e2c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e2f:	ff 45 08             	incl   0x8(%ebp)
  800e32:	ff 4d 0c             	decl   0xc(%ebp)
  800e35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e39:	74 09                	je     800e44 <strnlen+0x27>
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 e8                	jne    800e2c <strnlen+0xf>
		n++;
	return n;
  800e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e55:	90                   	nop
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8d 50 01             	lea    0x1(%eax),%edx
  800e5c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e62:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e65:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e68:	8a 12                	mov    (%edx),%dl
  800e6a:	88 10                	mov    %dl,(%eax)
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e4                	jne    800e56 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8a:	eb 1f                	jmp    800eab <strncpy+0x34>
		*dst++ = *src;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8d 50 01             	lea    0x1(%eax),%edx
  800e92:	89 55 08             	mov    %edx,0x8(%ebp)
  800e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e98:	8a 12                	mov    (%edx),%dl
  800e9a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	84 c0                	test   %al,%al
  800ea3:	74 03                	je     800ea8 <strncpy+0x31>
			src++;
  800ea5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ea8:	ff 45 fc             	incl   -0x4(%ebp)
  800eab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eae:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eb1:	72 d9                	jb     800e8c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ec4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec8:	74 30                	je     800efa <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eca:	eb 16                	jmp    800ee2 <strlcpy+0x2a>
			*dst++ = *src++;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8d 50 01             	lea    0x1(%eax),%edx
  800ed2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ede:	8a 12                	mov    (%edx),%dl
  800ee0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ee2:	ff 4d 10             	decl   0x10(%ebp)
  800ee5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee9:	74 09                	je     800ef4 <strlcpy+0x3c>
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	84 c0                	test   %al,%al
  800ef2:	75 d8                	jne    800ecc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800efa:	8b 55 08             	mov    0x8(%ebp),%edx
  800efd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f00:	29 c2                	sub    %eax,%edx
  800f02:	89 d0                	mov    %edx,%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f09:	eb 06                	jmp    800f11 <strcmp+0xb>
		p++, q++;
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	84 c0                	test   %al,%al
  800f18:	74 0e                	je     800f28 <strcmp+0x22>
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 10                	mov    (%eax),%dl
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	38 c2                	cmp    %al,%dl
  800f26:	74 e3                	je     800f0b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	0f b6 d0             	movzbl %al,%edx
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	0f b6 c0             	movzbl %al,%eax
  800f38:	29 c2                	sub    %eax,%edx
  800f3a:	89 d0                	mov    %edx,%eax
}
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f41:	eb 09                	jmp    800f4c <strncmp+0xe>
		n--, p++, q++;
  800f43:	ff 4d 10             	decl   0x10(%ebp)
  800f46:	ff 45 08             	incl   0x8(%ebp)
  800f49:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	74 17                	je     800f69 <strncmp+0x2b>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	84 c0                	test   %al,%al
  800f59:	74 0e                	je     800f69 <strncmp+0x2b>
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	38 c2                	cmp    %al,%dl
  800f67:	74 da                	je     800f43 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 07                	jne    800f76 <strncmp+0x38>
		return 0;
  800f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f74:	eb 14                	jmp    800f8a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	0f b6 d0             	movzbl %al,%edx
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	0f b6 c0             	movzbl %al,%eax
  800f86:	29 c2                	sub    %eax,%edx
  800f88:	89 d0                	mov    %edx,%eax
}
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f98:	eb 12                	jmp    800fac <strchr+0x20>
		if (*s == c)
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa2:	75 05                	jne    800fa9 <strchr+0x1d>
			return (char *) s;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	eb 11                	jmp    800fba <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 e5                	jne    800f9a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 04             	sub    $0x4,%esp
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc8:	eb 0d                	jmp    800fd7 <strfind+0x1b>
		if (*s == c)
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd2:	74 0e                	je     800fe2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fd4:	ff 45 08             	incl   0x8(%ebp)
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	84 c0                	test   %al,%al
  800fde:	75 ea                	jne    800fca <strfind+0xe>
  800fe0:	eb 01                	jmp    800fe3 <strfind+0x27>
		if (*s == c)
			break;
  800fe2:	90                   	nop
	return (char *) s;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ffa:	eb 0e                	jmp    80100a <memset+0x22>
		*p++ = c;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	8b 55 0c             	mov    0xc(%ebp),%edx
  801008:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80100a:	ff 4d f8             	decl   -0x8(%ebp)
  80100d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801011:	79 e9                	jns    800ffc <memset+0x14>
		*p++ = c;

	return v;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80102a:	eb 16                	jmp    801042 <memcpy+0x2a>
		*d++ = *s++;
  80102c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102f:	8d 50 01             	lea    0x1(%eax),%edx
  801032:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801035:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801038:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80103e:	8a 12                	mov    (%edx),%dl
  801040:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801042:	8b 45 10             	mov    0x10(%ebp),%eax
  801045:	8d 50 ff             	lea    -0x1(%eax),%edx
  801048:	89 55 10             	mov    %edx,0x10(%ebp)
  80104b:	85 c0                	test   %eax,%eax
  80104d:	75 dd                	jne    80102c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801066:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801069:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80106c:	73 50                	jae    8010be <memmove+0x6a>
  80106e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801071:	8b 45 10             	mov    0x10(%ebp),%eax
  801074:	01 d0                	add    %edx,%eax
  801076:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801079:	76 43                	jbe    8010be <memmove+0x6a>
		s += n;
  80107b:	8b 45 10             	mov    0x10(%ebp),%eax
  80107e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801081:	8b 45 10             	mov    0x10(%ebp),%eax
  801084:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801087:	eb 10                	jmp    801099 <memmove+0x45>
			*--d = *--s;
  801089:	ff 4d f8             	decl   -0x8(%ebp)
  80108c:	ff 4d fc             	decl   -0x4(%ebp)
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801092:	8a 10                	mov    (%eax),%dl
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801097:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109f:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	75 e3                	jne    801089 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010a6:	eb 23                	jmp    8010cb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ab:	8d 50 01             	lea    0x1(%eax),%edx
  8010ae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ba:	8a 12                	mov    (%edx),%dl
  8010bc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	75 dd                	jne    8010a8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    

008010d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010df:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010e2:	eb 2a                	jmp    80110e <memcmp+0x3e>
		if (*s1 != *s2)
  8010e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e7:	8a 10                	mov    (%eax),%dl
  8010e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	38 c2                	cmp    %al,%dl
  8010f0:	74 16                	je     801108 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	0f b6 d0             	movzbl %al,%edx
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 c0             	movzbl %al,%eax
  801102:	29 c2                	sub    %eax,%edx
  801104:	89 d0                	mov    %edx,%eax
  801106:	eb 18                	jmp    801120 <memcmp+0x50>
		s1++, s2++;
  801108:	ff 45 fc             	incl   -0x4(%ebp)
  80110b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	8d 50 ff             	lea    -0x1(%eax),%edx
  801114:	89 55 10             	mov    %edx,0x10(%ebp)
  801117:	85 c0                	test   %eax,%eax
  801119:	75 c9                	jne    8010e4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801120:	c9                   	leave  
  801121:	c3                   	ret    

00801122 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801128:	8b 55 08             	mov    0x8(%ebp),%edx
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	01 d0                	add    %edx,%eax
  801130:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801133:	eb 15                	jmp    80114a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	0f b6 d0             	movzbl %al,%edx
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	39 c2                	cmp    %eax,%edx
  801145:	74 0d                	je     801154 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801147:	ff 45 08             	incl   0x8(%ebp)
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801150:	72 e3                	jb     801135 <memfind+0x13>
  801152:	eb 01                	jmp    801155 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801154:	90                   	nop
	return (void *) s;
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116e:	eb 03                	jmp    801173 <strtol+0x19>
		s++;
  801170:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 20                	cmp    $0x20,%al
  80117a:	74 f4                	je     801170 <strtol+0x16>
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 09                	cmp    $0x9,%al
  801183:	74 eb                	je     801170 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 2b                	cmp    $0x2b,%al
  80118c:	75 05                	jne    801193 <strtol+0x39>
		s++;
  80118e:	ff 45 08             	incl   0x8(%ebp)
  801191:	eb 13                	jmp    8011a6 <strtol+0x4c>
	else if (*s == '-')
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	3c 2d                	cmp    $0x2d,%al
  80119a:	75 0a                	jne    8011a6 <strtol+0x4c>
		s++, neg = 1;
  80119c:	ff 45 08             	incl   0x8(%ebp)
  80119f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 06                	je     8011b2 <strtol+0x58>
  8011ac:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011b0:	75 20                	jne    8011d2 <strtol+0x78>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	3c 30                	cmp    $0x30,%al
  8011b9:	75 17                	jne    8011d2 <strtol+0x78>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	40                   	inc    %eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	3c 78                	cmp    $0x78,%al
  8011c3:	75 0d                	jne    8011d2 <strtol+0x78>
		s += 2, base = 16;
  8011c5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011d0:	eb 28                	jmp    8011fa <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d6:	75 15                	jne    8011ed <strtol+0x93>
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 30                	cmp    $0x30,%al
  8011df:	75 0c                	jne    8011ed <strtol+0x93>
		s++, base = 8;
  8011e1:	ff 45 08             	incl   0x8(%ebp)
  8011e4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011eb:	eb 0d                	jmp    8011fa <strtol+0xa0>
	else if (base == 0)
  8011ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f1:	75 07                	jne    8011fa <strtol+0xa0>
		base = 10;
  8011f3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 2f                	cmp    $0x2f,%al
  801201:	7e 19                	jle    80121c <strtol+0xc2>
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 39                	cmp    $0x39,%al
  80120a:	7f 10                	jg     80121c <strtol+0xc2>
			dig = *s - '0';
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	0f be c0             	movsbl %al,%eax
  801214:	83 e8 30             	sub    $0x30,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121a:	eb 42                	jmp    80125e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 60                	cmp    $0x60,%al
  801223:	7e 19                	jle    80123e <strtol+0xe4>
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	3c 7a                	cmp    $0x7a,%al
  80122c:	7f 10                	jg     80123e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	0f be c0             	movsbl %al,%eax
  801236:	83 e8 57             	sub    $0x57,%eax
  801239:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123c:	eb 20                	jmp    80125e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 40                	cmp    $0x40,%al
  801245:	7e 39                	jle    801280 <strtol+0x126>
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	3c 5a                	cmp    $0x5a,%al
  80124e:	7f 30                	jg     801280 <strtol+0x126>
			dig = *s - 'A' + 10;
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	0f be c0             	movsbl %al,%eax
  801258:	83 e8 37             	sub    $0x37,%eax
  80125b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80125e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801261:	3b 45 10             	cmp    0x10(%ebp),%eax
  801264:	7d 19                	jge    80127f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801266:	ff 45 08             	incl   0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801270:	89 c2                	mov    %eax,%edx
  801272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801275:	01 d0                	add    %edx,%eax
  801277:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80127a:	e9 7b ff ff ff       	jmp    8011fa <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80127f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801280:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801284:	74 08                	je     80128e <strtol+0x134>
		*endptr = (char *) s;
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	8b 55 08             	mov    0x8(%ebp),%edx
  80128c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80128e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801292:	74 07                	je     80129b <strtol+0x141>
  801294:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801297:	f7 d8                	neg    %eax
  801299:	eb 03                	jmp    80129e <strtol+0x144>
  80129b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <ltostr>:

void
ltostr(long value, char *str)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b8:	79 13                	jns    8012cd <ltostr+0x2d>
	{
		neg = 1;
  8012ba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012c7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ca:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012d5:	99                   	cltd   
  8012d6:	f7 f9                	idiv   %ecx
  8012d8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012de:	8d 50 01             	lea    0x1(%eax),%edx
  8012e1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e4:	89 c2                	mov    %eax,%edx
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	01 d0                	add    %edx,%eax
  8012eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012ee:	83 c2 30             	add    $0x30,%edx
  8012f1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012fb:	f7 e9                	imul   %ecx
  8012fd:	c1 fa 02             	sar    $0x2,%edx
  801300:	89 c8                	mov    %ecx,%eax
  801302:	c1 f8 1f             	sar    $0x1f,%eax
  801305:	29 c2                	sub    %eax,%edx
  801307:	89 d0                	mov    %edx,%eax
  801309:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80130c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801314:	f7 e9                	imul   %ecx
  801316:	c1 fa 02             	sar    $0x2,%edx
  801319:	89 c8                	mov    %ecx,%eax
  80131b:	c1 f8 1f             	sar    $0x1f,%eax
  80131e:	29 c2                	sub    %eax,%edx
  801320:	89 d0                	mov    %edx,%eax
  801322:	c1 e0 02             	shl    $0x2,%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	01 c0                	add    %eax,%eax
  801329:	29 c1                	sub    %eax,%ecx
  80132b:	89 ca                	mov    %ecx,%edx
  80132d:	85 d2                	test   %edx,%edx
  80132f:	75 9c                	jne    8012cd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801338:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133b:	48                   	dec    %eax
  80133c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80133f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801343:	74 3d                	je     801382 <ltostr+0xe2>
		start = 1 ;
  801345:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80134c:	eb 34                	jmp    801382 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80134e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801351:	8b 45 0c             	mov    0xc(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80135b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	01 c2                	add    %eax,%edx
  801363:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	01 c8                	add    %ecx,%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80136f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801372:	8b 45 0c             	mov    0xc(%ebp),%eax
  801375:	01 c2                	add    %eax,%edx
  801377:	8a 45 eb             	mov    -0x15(%ebp),%al
  80137a:	88 02                	mov    %al,(%edx)
		start++ ;
  80137c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80137f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801385:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801388:	7c c4                	jl     80134e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80138a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	01 d0                	add    %edx,%eax
  801392:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801395:	90                   	nop
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80139e:	ff 75 08             	pushl  0x8(%ebp)
  8013a1:	e8 54 fa ff ff       	call   800dfa <strlen>
  8013a6:	83 c4 04             	add    $0x4,%esp
  8013a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013ac:	ff 75 0c             	pushl  0xc(%ebp)
  8013af:	e8 46 fa ff ff       	call   800dfa <strlen>
  8013b4:	83 c4 04             	add    $0x4,%esp
  8013b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013c8:	eb 17                	jmp    8013e1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d0:	01 c2                	add    %eax,%edx
  8013d2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	01 c8                	add    %ecx,%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013de:	ff 45 fc             	incl   -0x4(%ebp)
  8013e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013e7:	7c e1                	jl     8013ca <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013f7:	eb 1f                	jmp    801418 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013fc:	8d 50 01             	lea    0x1(%eax),%edx
  8013ff:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801402:	89 c2                	mov    %eax,%edx
  801404:	8b 45 10             	mov    0x10(%ebp),%eax
  801407:	01 c2                	add    %eax,%edx
  801409:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80140c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140f:	01 c8                	add    %ecx,%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801415:	ff 45 f8             	incl   -0x8(%ebp)
  801418:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80141e:	7c d9                	jl     8013f9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801420:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	c6 00 00             	movb   $0x0,(%eax)
}
  80142b:	90                   	nop
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801431:	8b 45 14             	mov    0x14(%ebp),%eax
  801434:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80143a:	8b 45 14             	mov    0x14(%ebp),%eax
  80143d:	8b 00                	mov    (%eax),%eax
  80143f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801446:	8b 45 10             	mov    0x10(%ebp),%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801451:	eb 0c                	jmp    80145f <strsplit+0x31>
			*string++ = 0;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8d 50 01             	lea    0x1(%eax),%edx
  801459:	89 55 08             	mov    %edx,0x8(%ebp)
  80145c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	84 c0                	test   %al,%al
  801466:	74 18                	je     801480 <strsplit+0x52>
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8a 00                	mov    (%eax),%al
  80146d:	0f be c0             	movsbl %al,%eax
  801470:	50                   	push   %eax
  801471:	ff 75 0c             	pushl  0xc(%ebp)
  801474:	e8 13 fb ff ff       	call   800f8c <strchr>
  801479:	83 c4 08             	add    $0x8,%esp
  80147c:	85 c0                	test   %eax,%eax
  80147e:	75 d3                	jne    801453 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	8a 00                	mov    (%eax),%al
  801485:	84 c0                	test   %al,%al
  801487:	74 5a                	je     8014e3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801489:	8b 45 14             	mov    0x14(%ebp),%eax
  80148c:	8b 00                	mov    (%eax),%eax
  80148e:	83 f8 0f             	cmp    $0xf,%eax
  801491:	75 07                	jne    80149a <strsplit+0x6c>
		{
			return 0;
  801493:	b8 00 00 00 00       	mov    $0x0,%eax
  801498:	eb 66                	jmp    801500 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80149a:	8b 45 14             	mov    0x14(%ebp),%eax
  80149d:	8b 00                	mov    (%eax),%eax
  80149f:	8d 48 01             	lea    0x1(%eax),%ecx
  8014a2:	8b 55 14             	mov    0x14(%ebp),%edx
  8014a5:	89 0a                	mov    %ecx,(%edx)
  8014a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b1:	01 c2                	add    %eax,%edx
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b8:	eb 03                	jmp    8014bd <strsplit+0x8f>
			string++;
  8014ba:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	84 c0                	test   %al,%al
  8014c4:	74 8b                	je     801451 <strsplit+0x23>
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	0f be c0             	movsbl %al,%eax
  8014ce:	50                   	push   %eax
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	e8 b5 fa ff ff       	call   800f8c <strchr>
  8014d7:	83 c4 08             	add    $0x8,%esp
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	74 dc                	je     8014ba <strsplit+0x8c>
			string++;
	}
  8014de:	e9 6e ff ff ff       	jmp    801451 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014e3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e7:	8b 00                	mov    (%eax),%eax
  8014e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f3:	01 d0                	add    %edx,%eax
  8014f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014fb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  80150b:	e8 7d 0f 00 00       	call   80248d <sys_isUHeapPlacementStrategyNEXTFIT>
  801510:	85 c0                	test   %eax,%eax
  801512:	0f 84 6f 03 00 00    	je     801887 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801518:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  80151f:	8b 55 08             	mov    0x8(%ebp),%edx
  801522:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801525:	01 d0                	add    %edx,%eax
  801527:	48                   	dec    %eax
  801528:	89 45 80             	mov    %eax,-0x80(%ebp)
  80152b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80152e:	ba 00 00 00 00       	mov    $0x0,%edx
  801533:	f7 75 84             	divl   -0x7c(%ebp)
  801536:	8b 45 80             	mov    -0x80(%ebp),%eax
  801539:	29 d0                	sub    %edx,%eax
  80153b:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80153e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801542:	74 09                	je     80154d <malloc+0x4b>
  801544:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80154b:	76 0a                	jbe    801557 <malloc+0x55>
			return NULL;
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	e9 4b 09 00 00       	jmp    801ea2 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801557:	8b 15 04 30 80 00    	mov    0x803004,%edx
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	01 d0                	add    %edx,%eax
  801562:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801567:	0f 87 a2 00 00 00    	ja     80160f <malloc+0x10d>
  80156d:	a1 40 30 98 00       	mov    0x983040,%eax
  801572:	85 c0                	test   %eax,%eax
  801574:	0f 85 95 00 00 00    	jne    80160f <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  80157a:	a1 04 30 80 00       	mov    0x803004,%eax
  80157f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801585:	a1 04 30 80 00       	mov    0x803004,%eax
  80158a:	83 ec 08             	sub    $0x8,%esp
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	50                   	push   %eax
  801591:	e8 a3 0b 00 00       	call   802139 <sys_allocateMem>
  801596:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801599:	a1 20 30 80 00       	mov    0x803020,%eax
  80159e:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a1:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8015a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8015ad:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8015b3:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
			cnt_mem++;
  8015ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8015bf:	40                   	inc    %eax
  8015c0:	a3 20 30 80 00       	mov    %eax,0x803020
			int i = 0;
  8015c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8015cc:	eb 2e                	jmp    8015fc <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8015ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8015d3:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  8015d8:	c1 e8 0c             	shr    $0xc,%eax
  8015db:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  8015e2:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  8015e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8015eb:	05 00 10 00 00       	add    $0x1000,%eax
  8015f0:	a3 04 30 80 00       	mov    %eax,0x803004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  8015f5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  801602:	72 ca                	jb     8015ce <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801604:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80160a:	e9 93 08 00 00       	jmp    801ea2 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  80160f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801616:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  80161d:	a1 40 30 98 00       	mov    0x983040,%eax
  801622:	85 c0                	test   %eax,%eax
  801624:	75 1d                	jne    801643 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801626:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  80162d:	00 00 80 
				check = 1;
  801630:	c7 05 40 30 98 00 01 	movl   $0x1,0x983040
  801637:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  80163a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801641:	eb 08                	jmp    80164b <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801643:	a1 04 30 80 00       	mov    0x803004,%eax
  801648:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  80164b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801652:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801659:	a1 04 30 80 00       	mov    0x803004,%eax
  80165e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801661:	eb 4d                	jmp    8016b0 <malloc+0x1ae>
				if (sz == size) {
  801663:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801666:	3b 45 08             	cmp    0x8(%ebp),%eax
  801669:	75 09                	jne    801674 <malloc+0x172>
					f = 1;
  80166b:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801672:	eb 45                	jmp    8016b9 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801674:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801677:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  80167c:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80167f:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801686:	85 c0                	test   %eax,%eax
  801688:	75 10                	jne    80169a <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  80168a:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801691:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801698:	eb 16                	jmp    8016b0 <malloc+0x1ae>
				} else {
					sz = 0;
  80169a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  8016a1:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  8016a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ab:	a3 04 30 80 00       	mov    %eax,0x803004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8016b0:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  8016b7:	76 aa                	jbe    801663 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  8016b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016bd:	0f 84 95 00 00 00    	je     801758 <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  8016c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8016c8:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  8016ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8016d3:	83 ec 08             	sub    $0x8,%esp
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	50                   	push   %eax
  8016da:	e8 5a 0a 00 00       	call   802139 <sys_allocateMem>
  8016df:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8016e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8016e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ea:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8016f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8016f6:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8016fc:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801703:	a1 20 30 80 00       	mov    0x803020,%eax
  801708:	40                   	inc    %eax
  801709:	a3 20 30 80 00       	mov    %eax,0x803020
				int i = 0;
  80170e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801715:	eb 2e                	jmp    801745 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801717:	a1 04 30 80 00       	mov    0x803004,%eax
  80171c:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801721:	c1 e8 0c             	shr    $0xc,%eax
  801724:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  80172b:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  80172f:	a1 04 30 80 00       	mov    0x803004,%eax
  801734:	05 00 10 00 00       	add    $0x1000,%eax
  801739:	a3 04 30 80 00       	mov    %eax,0x803004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  80173e:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801745:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801748:	3b 45 08             	cmp    0x8(%ebp),%eax
  80174b:	72 ca                	jb     801717 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  80174d:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801753:	e9 4a 07 00 00       	jmp    801ea2 <malloc+0x9a0>

			} else {

				if (check_start) {
  801758:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80175c:	74 0a                	je     801768 <malloc+0x266>

					return NULL;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
  801763:	e9 3a 07 00 00       	jmp    801ea2 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801768:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  80176f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801776:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  80177d:	c7 05 04 30 80 00 00 	movl   $0x80000000,0x803004
  801784:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801787:	eb 4d                	jmp    8017d6 <malloc+0x2d4>
					if (sz == size) {
  801789:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80178c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80178f:	75 09                	jne    80179a <malloc+0x298>
						f = 1;
  801791:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801798:	eb 44                	jmp    8017de <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80179a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80179d:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  8017a2:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8017a5:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	75 10                	jne    8017c0 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  8017b0:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8017b7:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  8017be:	eb 16                	jmp    8017d6 <malloc+0x2d4>
					} else {
						sz = 0;
  8017c0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  8017c7:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  8017ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017d1:	a3 04 30 80 00       	mov    %eax,0x803004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d9:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  8017dc:	72 ab                	jb     801789 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  8017de:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8017e2:	0f 84 95 00 00 00    	je     80187d <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  8017e8:	a1 04 30 80 00       	mov    0x803004,%eax
  8017ed:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  8017f3:	a1 04 30 80 00       	mov    0x803004,%eax
  8017f8:	83 ec 08             	sub    $0x8,%esp
  8017fb:	ff 75 08             	pushl  0x8(%ebp)
  8017fe:	50                   	push   %eax
  8017ff:	e8 35 09 00 00       	call   802139 <sys_allocateMem>
  801804:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801807:	a1 20 30 80 00       	mov    0x803020,%eax
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801816:	a1 20 30 80 00       	mov    0x803020,%eax
  80181b:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801821:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
					cnt_mem++;
  801828:	a1 20 30 80 00       	mov    0x803020,%eax
  80182d:	40                   	inc    %eax
  80182e:	a3 20 30 80 00       	mov    %eax,0x803020
					int i = 0;
  801833:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  80183a:	eb 2e                	jmp    80186a <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80183c:	a1 04 30 80 00       	mov    0x803004,%eax
  801841:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801846:	c1 e8 0c             	shr    $0xc,%eax
  801849:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801850:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801854:	a1 04 30 80 00       	mov    0x803004,%eax
  801859:	05 00 10 00 00       	add    $0x1000,%eax
  80185e:	a3 04 30 80 00       	mov    %eax,0x803004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801863:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  80186a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80186d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801870:	72 ca                	jb     80183c <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801872:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801878:	e9 25 06 00 00       	jmp    801ea2 <malloc+0x9a0>

				} else {

					return NULL;
  80187d:	b8 00 00 00 00       	mov    $0x0,%eax
  801882:	e9 1b 06 00 00       	jmp    801ea2 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801887:	e8 d0 0b 00 00       	call   80245c <sys_isUHeapPlacementStrategyBESTFIT>
  80188c:	85 c0                	test   %eax,%eax
  80188e:	0f 84 ba 01 00 00    	je     801a4e <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801894:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  80189b:	10 00 00 
  80189e:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a1:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8018a7:	01 d0                	add    %edx,%eax
  8018a9:	48                   	dec    %eax
  8018aa:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8018b0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8018b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bb:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  8018c1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8018c7:	29 d0                	sub    %edx,%eax
  8018c9:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8018cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d0:	74 09                	je     8018db <malloc+0x3d9>
  8018d2:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8018d9:	76 0a                	jbe    8018e5 <malloc+0x3e3>
			return NULL;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	e9 bd 05 00 00       	jmp    801ea2 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  8018e5:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  8018ec:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  8018f3:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  8018fa:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801901:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	c1 e8 0c             	shr    $0xc,%eax
  80190e:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801914:	e9 80 00 00 00       	jmp    801999 <malloc+0x497>

			if (heap_mem[i] == 0) {
  801919:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80191c:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801923:	85 c0                	test   %eax,%eax
  801925:	75 0c                	jne    801933 <malloc+0x431>

				count++;
  801927:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  80192a:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801931:	eb 2d                	jmp    801960 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801933:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801939:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80193c:	77 14                	ja     801952 <malloc+0x450>
  80193e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801941:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801944:	76 0c                	jbe    801952 <malloc+0x450>

					min_sz = count;
  801946:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801949:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  80194c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80194f:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801952:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801959:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801960:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801967:	75 2d                	jne    801996 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801969:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80196f:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801972:	77 22                	ja     801996 <malloc+0x494>
  801974:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801977:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80197a:	76 1a                	jbe    801996 <malloc+0x494>

					min_sz = count;
  80197c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80197f:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801982:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801985:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801988:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  80198f:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801996:	ff 45 b8             	incl   -0x48(%ebp)
  801999:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80199c:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8019a1:	0f 86 72 ff ff ff    	jbe    801919 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  8019a7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8019ad:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  8019b0:	77 06                	ja     8019b8 <malloc+0x4b6>
  8019b2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8019b6:	75 0a                	jne    8019c2 <malloc+0x4c0>
			return NULL;
  8019b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bd:	e9 e0 04 00 00       	jmp    801ea2 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  8019c2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019c5:	c1 e0 0c             	shl    $0xc,%eax
  8019c8:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  8019cb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019ce:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  8019d4:	83 ec 08             	sub    $0x8,%esp
  8019d7:	ff 75 08             	pushl  0x8(%ebp)
  8019da:	ff 75 c4             	pushl  -0x3c(%ebp)
  8019dd:	e8 57 07 00 00       	call   802139 <sys_allocateMem>
  8019e2:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8019e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8019ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ed:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8019f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8019f9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019fc:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801a03:	a1 20 30 80 00       	mov    0x803020,%eax
  801a08:	40                   	inc    %eax
  801a09:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801a0e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801a15:	eb 24                	jmp    801a3b <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801a17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a1a:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801a1f:	c1 e8 0c             	shr    $0xc,%eax
  801a22:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801a29:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801a2d:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801a34:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801a3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a41:	72 d4                	jb     801a17 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801a43:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801a49:	e9 54 04 00 00       	jmp    801ea2 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801a4e:	e8 d8 09 00 00       	call   80242b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a53:	85 c0                	test   %eax,%eax
  801a55:	0f 84 88 01 00 00    	je     801be3 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801a5b:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801a62:	10 00 00 
  801a65:	8b 55 08             	mov    0x8(%ebp),%edx
  801a68:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801a6e:	01 d0                	add    %edx,%eax
  801a70:	48                   	dec    %eax
  801a71:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801a77:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801a7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a82:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801a88:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801a8e:	29 d0                	sub    %edx,%eax
  801a90:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801a93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a97:	74 09                	je     801aa2 <malloc+0x5a0>
  801a99:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801aa0:	76 0a                	jbe    801aac <malloc+0x5aa>
			return NULL;
  801aa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa7:	e9 f6 03 00 00       	jmp    801ea2 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801aac:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801ab3:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801aba:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801ac1:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801ac8:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	c1 e8 0c             	shr    $0xc,%eax
  801ad5:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801adb:	eb 5a                	jmp    801b37 <malloc+0x635>

			if (heap_mem[i] == 0) {
  801add:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ae0:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	75 0c                	jne    801af7 <malloc+0x5f5>

				count++;
  801aeb:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801aee:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801af5:	eb 22                	jmp    801b19 <malloc+0x617>
			} else {
				if (num_p <= count) {
  801af7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801afd:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801b00:	77 09                	ja     801b0b <malloc+0x609>

					found = 1;
  801b02:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801b09:	eb 36                	jmp    801b41 <malloc+0x63f>
				}
				count = 0;
  801b0b:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  801b12:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  801b19:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  801b20:	75 12                	jne    801b34 <malloc+0x632>

				if (num_p <= count) {
  801b22:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801b28:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801b2b:	77 07                	ja     801b34 <malloc+0x632>

					found = 1;
  801b2d:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  801b34:	ff 45 a4             	incl   -0x5c(%ebp)
  801b37:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801b3a:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801b3f:	76 9c                	jbe    801add <malloc+0x5db>

			}

		}

		if (!found) {
  801b41:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  801b45:	75 0a                	jne    801b51 <malloc+0x64f>
			return NULL;
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4c:	e9 51 03 00 00       	jmp    801ea2 <malloc+0x9a0>

		}

		temp = ptr;
  801b51:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801b54:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  801b57:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801b5a:	c1 e0 0c             	shl    $0xc,%eax
  801b5d:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  801b60:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801b63:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  801b69:	83 ec 08             	sub    $0x8,%esp
  801b6c:	ff 75 08             	pushl  0x8(%ebp)
  801b6f:	ff 75 b0             	pushl  -0x50(%ebp)
  801b72:	e8 c2 05 00 00       	call   802139 <sys_allocateMem>
  801b77:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801b7a:	a1 20 30 80 00       	mov    0x803020,%eax
  801b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b82:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801b89:	a1 20 30 80 00       	mov    0x803020,%eax
  801b8e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801b91:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801b98:	a1 20 30 80 00       	mov    0x803020,%eax
  801b9d:	40                   	inc    %eax
  801b9e:	a3 20 30 80 00       	mov    %eax,0x803020
		i = 0;
  801ba3:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801baa:	eb 24                	jmp    801bd0 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801bac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801baf:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801bb4:	c1 e8 0c             	shr    $0xc,%eax
  801bb7:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801bbe:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801bc2:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801bc9:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  801bd0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801bd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bd6:	72 d4                	jb     801bac <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801bd8:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  801bde:	e9 bf 02 00 00       	jmp    801ea2 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  801be3:	e8 d6 08 00 00       	call   8024be <sys_isUHeapPlacementStrategyWORSTFIT>
  801be8:	85 c0                	test   %eax,%eax
  801bea:	0f 84 ba 01 00 00    	je     801daa <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801bf0:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  801bf7:	10 00 00 
  801bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  801bfd:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  801c03:	01 d0                	add    %edx,%eax
  801c05:	48                   	dec    %eax
  801c06:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  801c0c:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801c12:	ba 00 00 00 00       	mov    $0x0,%edx
  801c17:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  801c1d:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  801c23:	29 d0                	sub    %edx,%eax
  801c25:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c2c:	74 09                	je     801c37 <malloc+0x735>
  801c2e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801c35:	76 0a                	jbe    801c41 <malloc+0x73f>
					return NULL;
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3c:	e9 61 02 00 00       	jmp    801ea2 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  801c41:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  801c48:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  801c4f:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  801c56:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  801c5d:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	c1 e8 0c             	shr    $0xc,%eax
  801c6a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801c70:	e9 80 00 00 00       	jmp    801cf5 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  801c75:	8b 45 90             	mov    -0x70(%ebp),%eax
  801c78:	8b 04 85 40 30 80 00 	mov    0x803040(,%eax,4),%eax
  801c7f:	85 c0                	test   %eax,%eax
  801c81:	75 0c                	jne    801c8f <malloc+0x78d>

						count++;
  801c83:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  801c86:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  801c8d:	eb 2d                	jmp    801cbc <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  801c8f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801c95:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801c98:	77 14                	ja     801cae <malloc+0x7ac>
  801c9a:	8b 45 98             	mov    -0x68(%ebp),%eax
  801c9d:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801ca0:	73 0c                	jae    801cae <malloc+0x7ac>

							max_sz = count;
  801ca2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801ca5:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801ca8:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801cab:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  801cae:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  801cb5:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  801cbc:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  801cc3:	75 2d                	jne    801cf2 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  801cc5:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801ccb:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801cce:	77 22                	ja     801cf2 <malloc+0x7f0>
  801cd0:	8b 45 98             	mov    -0x68(%ebp),%eax
  801cd3:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  801cd6:	76 1a                	jbe    801cf2 <malloc+0x7f0>

							max_sz = count;
  801cd8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801cdb:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  801cde:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801ce1:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  801ce4:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  801ceb:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  801cf2:	ff 45 90             	incl   -0x70(%ebp)
  801cf5:	8b 45 90             	mov    -0x70(%ebp),%eax
  801cf8:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801cfd:	0f 86 72 ff ff ff    	jbe    801c75 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  801d03:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  801d09:	3b 45 98             	cmp    -0x68(%ebp),%eax
  801d0c:	77 06                	ja     801d14 <malloc+0x812>
  801d0e:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  801d12:	75 0a                	jne    801d1e <malloc+0x81c>
					return NULL;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
  801d19:	e9 84 01 00 00       	jmp    801ea2 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  801d1e:	8b 45 98             	mov    -0x68(%ebp),%eax
  801d21:	c1 e0 0c             	shl    $0xc,%eax
  801d24:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  801d27:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801d2a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  801d30:	83 ec 08             	sub    $0x8,%esp
  801d33:	ff 75 08             	pushl  0x8(%ebp)
  801d36:	ff 75 9c             	pushl  -0x64(%ebp)
  801d39:	e8 fb 03 00 00       	call   802139 <sys_allocateMem>
  801d3e:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801d41:	a1 20 30 80 00       	mov    0x803020,%eax
  801d46:	8b 55 08             	mov    0x8(%ebp),%edx
  801d49:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  801d50:	a1 20 30 80 00       	mov    0x803020,%eax
  801d55:	8b 55 9c             	mov    -0x64(%ebp),%edx
  801d58:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
				cnt_mem++;
  801d5f:	a1 20 30 80 00       	mov    0x803020,%eax
  801d64:	40                   	inc    %eax
  801d65:	a3 20 30 80 00       	mov    %eax,0x803020
				i = 0;
  801d6a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801d71:	eb 24                	jmp    801d97 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801d73:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801d76:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801d7b:	c1 e8 0c             	shr    $0xc,%eax
  801d7e:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801d85:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  801d89:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801d90:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  801d97:	8b 45 90             	mov    -0x70(%ebp),%eax
  801d9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d9d:	72 d4                	jb     801d73 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  801d9f:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  801da5:	e9 f8 00 00 00       	jmp    801ea2 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  801daa:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  801db1:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  801db8:	10 00 00 
  801dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  801dbe:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801dc4:	01 d0                	add    %edx,%eax
  801dc6:	48                   	dec    %eax
  801dc7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  801dcd:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd8:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  801dde:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  801de4:	29 d0                	sub    %edx,%eax
  801de6:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ded:	74 09                	je     801df8 <malloc+0x8f6>
  801def:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801df6:	76 0a                	jbe    801e02 <malloc+0x900>
		return NULL;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfd:	e9 a0 00 00 00       	jmp    801ea2 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  801e02:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	01 d0                	add    %edx,%eax
  801e0d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801e12:	0f 87 87 00 00 00    	ja     801e9f <malloc+0x99d>

		ret = (void *) ptr_uheap;
  801e18:	a1 04 30 80 00       	mov    0x803004,%eax
  801e1d:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  801e20:	a1 04 30 80 00       	mov    0x803004,%eax
  801e25:	83 ec 08             	sub    $0x8,%esp
  801e28:	ff 75 08             	pushl  0x8(%ebp)
  801e2b:	50                   	push   %eax
  801e2c:	e8 08 03 00 00       	call   802139 <sys_allocateMem>
  801e31:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801e34:	a1 20 30 80 00       	mov    0x803020,%eax
  801e39:	8b 55 08             	mov    0x8(%ebp),%edx
  801e3c:	89 14 c5 44 30 88 00 	mov    %edx,0x883044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801e43:	a1 20 30 80 00       	mov    0x803020,%eax
  801e48:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801e4e:	89 14 c5 40 30 88 00 	mov    %edx,0x883040(,%eax,8)
		cnt_mem++;
  801e55:	a1 20 30 80 00       	mov    0x803020,%eax
  801e5a:	40                   	inc    %eax
  801e5b:	a3 20 30 80 00       	mov    %eax,0x803020
		int i = 0;
  801e60:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  801e67:	eb 2e                	jmp    801e97 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801e69:	a1 04 30 80 00       	mov    0x803004,%eax
  801e6e:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801e73:	c1 e8 0c             	shr    $0xc,%eax
  801e76:	c7 04 85 40 30 80 00 	movl   $0x1,0x803040(,%eax,4)
  801e7d:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  801e81:	a1 04 30 80 00       	mov    0x803004,%eax
  801e86:	05 00 10 00 00       	add    $0x1000,%eax
  801e8b:	a3 04 30 80 00       	mov    %eax,0x803004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  801e90:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  801e97:	8b 45 88             	mov    -0x78(%ebp),%eax
  801e9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e9d:	72 ca                	jb     801e69 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  801e9f:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  801eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  801eb1:	e9 c1 00 00 00       	jmp    801f77 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	8b 04 c5 40 30 88 00 	mov    0x883040(,%eax,8),%eax
  801ec0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ec3:	0f 85 ab 00 00 00    	jne    801f74 <free+0xd0>

			if (heap_size[inx].size == 0) {
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	8b 04 c5 44 30 88 00 	mov    0x883044(,%eax,8),%eax
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	75 21                	jne    801ef8 <free+0x54>
				heap_size[inx].size = 0;
  801ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eda:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801ee1:	00 00 00 00 
				heap_size[inx].vir = NULL;
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801eef:	00 00 00 00 
				return;
  801ef3:	e9 8d 00 00 00       	jmp    801f85 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	83 ec 08             	sub    $0x8,%esp
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	e8 0e 02 00 00       	call   80211d <sys_freeMem>
  801f0f:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  801f12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801f1f:	eb 24                	jmp    801f45 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  801f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f24:	05 00 00 00 80       	add    $0x80000000,%eax
  801f29:	c1 e8 0c             	shr    $0xc,%eax
  801f2c:	c7 04 85 40 30 80 00 	movl   $0x0,0x803040(,%eax,4)
  801f33:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  801f37:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  801f3e:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 14 c5 44 30 88 00 	mov    0x883044(,%eax,8),%edx
  801f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f52:	39 c2                	cmp    %eax,%edx
  801f54:	77 cb                	ja     801f21 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	c7 04 c5 44 30 88 00 	movl   $0x0,0x883044(,%eax,8)
  801f60:	00 00 00 00 
			heap_size[inx].vir = NULL;
  801f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f67:	c7 04 c5 40 30 88 00 	movl   $0x0,0x883040(,%eax,8)
  801f6e:	00 00 00 00 
			break;
  801f72:	eb 11                	jmp    801f85 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  801f74:	ff 45 f4             	incl   -0xc(%ebp)
  801f77:	a1 20 30 80 00       	mov    0x803020,%eax
  801f7c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801f7f:	0f 8c 31 ff ff ff    	jl     801eb6 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	68 f0 2e 80 00       	push   $0x802ef0
  801f95:	68 1c 02 00 00       	push   $0x21c
  801f9a:	68 16 2f 80 00       	push   $0x802f16
  801f9f:	e8 b0 e6 ff ff       	call   800654 <_panic>

00801fa4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	57                   	push   %edi
  801fa8:	56                   	push   %esi
  801fa9:	53                   	push   %ebx
  801faa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fb9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fbc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fbf:	cd 30                	int    $0x30
  801fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	5b                   	pop    %ebx
  801fcb:	5e                   	pop    %esi
  801fcc:	5f                   	pop    %edi
  801fcd:	5d                   	pop    %ebp
  801fce:	c3                   	ret    

00801fcf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	ff 75 0c             	pushl  0xc(%ebp)
  801fde:	50                   	push   %eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	e8 be ff ff ff       	call   801fa4 <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
}
  801fe9:	90                   	nop
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_cgetc>:

int
sys_cgetc(void)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 01                	push   $0x1
  801ffb:	e8 a4 ff ff ff       	call   801fa4 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	50                   	push   %eax
  802014:	6a 03                	push   $0x3
  802016:	e8 89 ff ff ff       	call   801fa4 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 02                	push   $0x2
  80202f:	e8 70 ff ff ff       	call   801fa4 <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_env_exit>:

void sys_env_exit(void)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 04                	push   $0x4
  802048:	e8 57 ff ff ff       	call   801fa4 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	90                   	nop
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802056:	8b 55 0c             	mov    0xc(%ebp),%edx
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	52                   	push   %edx
  802063:	50                   	push   %eax
  802064:	6a 05                	push   $0x5
  802066:	e8 39 ff ff ff       	call   801fa4 <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	56                   	push   %esi
  802074:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802075:	8b 75 18             	mov    0x18(%ebp),%esi
  802078:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80207b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80207e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	56                   	push   %esi
  802085:	53                   	push   %ebx
  802086:	51                   	push   %ecx
  802087:	52                   	push   %edx
  802088:	50                   	push   %eax
  802089:	6a 06                	push   $0x6
  80208b:	e8 14 ff ff ff       	call   801fa4 <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
}
  802093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802096:	5b                   	pop    %ebx
  802097:	5e                   	pop    %esi
  802098:	5d                   	pop    %ebp
  802099:	c3                   	ret    

0080209a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80209d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	52                   	push   %edx
  8020aa:	50                   	push   %eax
  8020ab:	6a 07                	push   $0x7
  8020ad:	e8 f2 fe ff ff       	call   801fa4 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	ff 75 0c             	pushl  0xc(%ebp)
  8020c3:	ff 75 08             	pushl  0x8(%ebp)
  8020c6:	6a 08                	push   $0x8
  8020c8:	e8 d7 fe ff ff       	call   801fa4 <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 09                	push   $0x9
  8020e1:	e8 be fe ff ff       	call   801fa4 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 0a                	push   $0xa
  8020fa:	e8 a5 fe ff ff       	call   801fa4 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 0b                	push   $0xb
  802113:	e8 8c fe ff ff       	call   801fa4 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	ff 75 0c             	pushl  0xc(%ebp)
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	6a 0d                	push   $0xd
  80212e:	e8 71 fe ff ff       	call   801fa4 <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
	return;
  802136:	90                   	nop
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	ff 75 0c             	pushl  0xc(%ebp)
  802145:	ff 75 08             	pushl  0x8(%ebp)
  802148:	6a 0e                	push   $0xe
  80214a:	e8 55 fe ff ff       	call   801fa4 <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
	return ;
  802152:	90                   	nop
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 0c                	push   $0xc
  802164:	e8 3b fe ff ff       	call   801fa4 <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 10                	push   $0x10
  80217d:	e8 22 fe ff ff       	call   801fa4 <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
}
  802185:	90                   	nop
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 11                	push   $0x11
  802197:	e8 08 fe ff ff       	call   801fa4 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	90                   	nop
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 04             	sub    $0x4,%esp
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	50                   	push   %eax
  8021bb:	6a 12                	push   $0x12
  8021bd:	e8 e2 fd ff ff       	call   801fa4 <syscall>
  8021c2:	83 c4 18             	add    $0x18,%esp
}
  8021c5:	90                   	nop
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 13                	push   $0x13
  8021d7:	e8 c8 fd ff ff       	call   801fa4 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
}
  8021df:	90                   	nop
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	ff 75 0c             	pushl  0xc(%ebp)
  8021f1:	50                   	push   %eax
  8021f2:	6a 14                	push   $0x14
  8021f4:	e8 ab fd ff ff       	call   801fa4 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	50                   	push   %eax
  80220d:	6a 17                	push   $0x17
  80220f:	e8 90 fd ff ff       	call   801fa4 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	50                   	push   %eax
  802228:	6a 15                	push   $0x15
  80222a:	e8 75 fd ff ff       	call   801fa4 <syscall>
  80222f:	83 c4 18             	add    $0x18,%esp
}
  802232:	90                   	nop
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	50                   	push   %eax
  802244:	6a 16                	push   $0x16
  802246:	e8 59 fd ff ff       	call   801fa4 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
}
  80224e:	90                   	nop
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	8b 45 10             	mov    0x10(%ebp),%eax
  80225a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  80225d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802260:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	6a 00                	push   $0x0
  802269:	51                   	push   %ecx
  80226a:	52                   	push   %edx
  80226b:	ff 75 0c             	pushl  0xc(%ebp)
  80226e:	50                   	push   %eax
  80226f:	6a 18                	push   $0x18
  802271:	e8 2e fd ff ff       	call   801fa4 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  80227e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	52                   	push   %edx
  80228b:	50                   	push   %eax
  80228c:	6a 19                	push   $0x19
  80228e:	e8 11 fd ff ff       	call   801fa4 <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	50                   	push   %eax
  8022a7:	6a 1a                	push   $0x1a
  8022a9:	e8 f6 fc ff ff       	call   801fa4 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 1b                	push   $0x1b
  8022c2:	e8 dd fc ff ff       	call   801fa4 <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 1c                	push   $0x1c
  8022db:	e8 c4 fc ff ff       	call   801fa4 <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	ff 75 0c             	pushl  0xc(%ebp)
  8022f4:	50                   	push   %eax
  8022f5:	6a 1d                	push   $0x1d
  8022f7:	e8 a8 fc ff ff       	call   801fa4 <syscall>
  8022fc:	83 c4 18             	add    $0x18,%esp
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	50                   	push   %eax
  802310:	6a 1e                	push   $0x1e
  802312:	e8 8d fc ff ff       	call   801fa4 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	90                   	nop
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	50                   	push   %eax
  80232c:	6a 1f                	push   $0x1f
  80232e:	e8 71 fc ff ff       	call   801fa4 <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
}
  802336:	90                   	nop
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80233f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802342:	8d 50 04             	lea    0x4(%eax),%edx
  802345:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	52                   	push   %edx
  80234f:	50                   	push   %eax
  802350:	6a 20                	push   $0x20
  802352:	e8 4d fc ff ff       	call   801fa4 <syscall>
  802357:	83 c4 18             	add    $0x18,%esp
	return result;
  80235a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80235d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802360:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802363:	89 01                	mov    %eax,(%ecx)
  802365:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	c9                   	leave  
  80236c:	c2 04 00             	ret    $0x4

0080236f <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	ff 75 10             	pushl  0x10(%ebp)
  802379:	ff 75 0c             	pushl  0xc(%ebp)
  80237c:	ff 75 08             	pushl  0x8(%ebp)
  80237f:	6a 0f                	push   $0xf
  802381:	e8 1e fc ff ff       	call   801fa4 <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
	return ;
  802389:	90                   	nop
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <sys_rcr2>:
uint32 sys_rcr2()
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 21                	push   $0x21
  80239b:	e8 04 fc ff ff       	call   801fa4 <syscall>
  8023a0:	83 c4 18             	add    $0x18,%esp
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023b1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	50                   	push   %eax
  8023be:	6a 22                	push   $0x22
  8023c0:	e8 df fb ff ff       	call   801fa4 <syscall>
  8023c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c8:	90                   	nop
}
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <rsttst>:
void rsttst()
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 24                	push   $0x24
  8023da:	e8 c5 fb ff ff       	call   801fa4 <syscall>
  8023df:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e2:	90                   	nop
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	83 ec 04             	sub    $0x4,%esp
  8023eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023f1:	8b 55 18             	mov    0x18(%ebp),%edx
  8023f4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023f8:	52                   	push   %edx
  8023f9:	50                   	push   %eax
  8023fa:	ff 75 10             	pushl  0x10(%ebp)
  8023fd:	ff 75 0c             	pushl  0xc(%ebp)
  802400:	ff 75 08             	pushl  0x8(%ebp)
  802403:	6a 23                	push   $0x23
  802405:	e8 9a fb ff ff       	call   801fa4 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
	return ;
  80240d:	90                   	nop
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <chktst>:
void chktst(uint32 n)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	ff 75 08             	pushl  0x8(%ebp)
  80241e:	6a 25                	push   $0x25
  802420:	e8 7f fb ff ff       	call   801fa4 <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
	return ;
  802428:	90                   	nop
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 26                	push   $0x26
  80243d:	e8 62 fb ff ff       	call   801fa4 <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
  802445:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802448:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80244c:	75 07                	jne    802455 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	eb 05                	jmp    80245a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 26                	push   $0x26
  80246e:	e8 31 fb ff ff       	call   801fa4 <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
  802476:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802479:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80247d:	75 07                	jne    802486 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80247f:	b8 01 00 00 00       	mov    $0x1,%eax
  802484:	eb 05                	jmp    80248b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 26                	push   $0x26
  80249f:	e8 00 fb ff ff       	call   801fa4 <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
  8024a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024aa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024ae:	75 07                	jne    8024b7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b5:	eb 05                	jmp    8024bc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 26                	push   $0x26
  8024d0:	e8 cf fa ff ff       	call   801fa4 <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
  8024d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024db:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024df:	75 07                	jne    8024e8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e6:	eb 05                	jmp    8024ed <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	ff 75 08             	pushl  0x8(%ebp)
  8024fd:	6a 27                	push   $0x27
  8024ff:	e8 a0 fa ff ff       	call   801fa4 <syscall>
  802504:	83 c4 18             	add    $0x18,%esp
	return ;
  802507:	90                   	nop
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    
  80250a:	66 90                	xchg   %ax,%ax

0080250c <__udivdi3>:
  80250c:	55                   	push   %ebp
  80250d:	57                   	push   %edi
  80250e:	56                   	push   %esi
  80250f:	53                   	push   %ebx
  802510:	83 ec 1c             	sub    $0x1c,%esp
  802513:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802517:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80251b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80251f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802523:	89 ca                	mov    %ecx,%edx
  802525:	89 f8                	mov    %edi,%eax
  802527:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80252b:	85 f6                	test   %esi,%esi
  80252d:	75 2d                	jne    80255c <__udivdi3+0x50>
  80252f:	39 cf                	cmp    %ecx,%edi
  802531:	77 65                	ja     802598 <__udivdi3+0x8c>
  802533:	89 fd                	mov    %edi,%ebp
  802535:	85 ff                	test   %edi,%edi
  802537:	75 0b                	jne    802544 <__udivdi3+0x38>
  802539:	b8 01 00 00 00       	mov    $0x1,%eax
  80253e:	31 d2                	xor    %edx,%edx
  802540:	f7 f7                	div    %edi
  802542:	89 c5                	mov    %eax,%ebp
  802544:	31 d2                	xor    %edx,%edx
  802546:	89 c8                	mov    %ecx,%eax
  802548:	f7 f5                	div    %ebp
  80254a:	89 c1                	mov    %eax,%ecx
  80254c:	89 d8                	mov    %ebx,%eax
  80254e:	f7 f5                	div    %ebp
  802550:	89 cf                	mov    %ecx,%edi
  802552:	89 fa                	mov    %edi,%edx
  802554:	83 c4 1c             	add    $0x1c,%esp
  802557:	5b                   	pop    %ebx
  802558:	5e                   	pop    %esi
  802559:	5f                   	pop    %edi
  80255a:	5d                   	pop    %ebp
  80255b:	c3                   	ret    
  80255c:	39 ce                	cmp    %ecx,%esi
  80255e:	77 28                	ja     802588 <__udivdi3+0x7c>
  802560:	0f bd fe             	bsr    %esi,%edi
  802563:	83 f7 1f             	xor    $0x1f,%edi
  802566:	75 40                	jne    8025a8 <__udivdi3+0x9c>
  802568:	39 ce                	cmp    %ecx,%esi
  80256a:	72 0a                	jb     802576 <__udivdi3+0x6a>
  80256c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802570:	0f 87 9e 00 00 00    	ja     802614 <__udivdi3+0x108>
  802576:	b8 01 00 00 00       	mov    $0x1,%eax
  80257b:	89 fa                	mov    %edi,%edx
  80257d:	83 c4 1c             	add    $0x1c,%esp
  802580:	5b                   	pop    %ebx
  802581:	5e                   	pop    %esi
  802582:	5f                   	pop    %edi
  802583:	5d                   	pop    %ebp
  802584:	c3                   	ret    
  802585:	8d 76 00             	lea    0x0(%esi),%esi
  802588:	31 ff                	xor    %edi,%edi
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	89 fa                	mov    %edi,%edx
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	66 90                	xchg   %ax,%ax
  802598:	89 d8                	mov    %ebx,%eax
  80259a:	f7 f7                	div    %edi
  80259c:	31 ff                	xor    %edi,%edi
  80259e:	89 fa                	mov    %edi,%edx
  8025a0:	83 c4 1c             	add    $0x1c,%esp
  8025a3:	5b                   	pop    %ebx
  8025a4:	5e                   	pop    %esi
  8025a5:	5f                   	pop    %edi
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    
  8025a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025ad:	89 eb                	mov    %ebp,%ebx
  8025af:	29 fb                	sub    %edi,%ebx
  8025b1:	89 f9                	mov    %edi,%ecx
  8025b3:	d3 e6                	shl    %cl,%esi
  8025b5:	89 c5                	mov    %eax,%ebp
  8025b7:	88 d9                	mov    %bl,%cl
  8025b9:	d3 ed                	shr    %cl,%ebp
  8025bb:	89 e9                	mov    %ebp,%ecx
  8025bd:	09 f1                	or     %esi,%ecx
  8025bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025c3:	89 f9                	mov    %edi,%ecx
  8025c5:	d3 e0                	shl    %cl,%eax
  8025c7:	89 c5                	mov    %eax,%ebp
  8025c9:	89 d6                	mov    %edx,%esi
  8025cb:	88 d9                	mov    %bl,%cl
  8025cd:	d3 ee                	shr    %cl,%esi
  8025cf:	89 f9                	mov    %edi,%ecx
  8025d1:	d3 e2                	shl    %cl,%edx
  8025d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025d7:	88 d9                	mov    %bl,%cl
  8025d9:	d3 e8                	shr    %cl,%eax
  8025db:	09 c2                	or     %eax,%edx
  8025dd:	89 d0                	mov    %edx,%eax
  8025df:	89 f2                	mov    %esi,%edx
  8025e1:	f7 74 24 0c          	divl   0xc(%esp)
  8025e5:	89 d6                	mov    %edx,%esi
  8025e7:	89 c3                	mov    %eax,%ebx
  8025e9:	f7 e5                	mul    %ebp
  8025eb:	39 d6                	cmp    %edx,%esi
  8025ed:	72 19                	jb     802608 <__udivdi3+0xfc>
  8025ef:	74 0b                	je     8025fc <__udivdi3+0xf0>
  8025f1:	89 d8                	mov    %ebx,%eax
  8025f3:	31 ff                	xor    %edi,%edi
  8025f5:	e9 58 ff ff ff       	jmp    802552 <__udivdi3+0x46>
  8025fa:	66 90                	xchg   %ax,%ax
  8025fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  802600:	89 f9                	mov    %edi,%ecx
  802602:	d3 e2                	shl    %cl,%edx
  802604:	39 c2                	cmp    %eax,%edx
  802606:	73 e9                	jae    8025f1 <__udivdi3+0xe5>
  802608:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80260b:	31 ff                	xor    %edi,%edi
  80260d:	e9 40 ff ff ff       	jmp    802552 <__udivdi3+0x46>
  802612:	66 90                	xchg   %ax,%ax
  802614:	31 c0                	xor    %eax,%eax
  802616:	e9 37 ff ff ff       	jmp    802552 <__udivdi3+0x46>
  80261b:	90                   	nop

0080261c <__umoddi3>:
  80261c:	55                   	push   %ebp
  80261d:	57                   	push   %edi
  80261e:	56                   	push   %esi
  80261f:	53                   	push   %ebx
  802620:	83 ec 1c             	sub    $0x1c,%esp
  802623:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802627:	8b 74 24 34          	mov    0x34(%esp),%esi
  80262b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80262f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802633:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802637:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80263b:	89 f3                	mov    %esi,%ebx
  80263d:	89 fa                	mov    %edi,%edx
  80263f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802643:	89 34 24             	mov    %esi,(%esp)
  802646:	85 c0                	test   %eax,%eax
  802648:	75 1a                	jne    802664 <__umoddi3+0x48>
  80264a:	39 f7                	cmp    %esi,%edi
  80264c:	0f 86 a2 00 00 00    	jbe    8026f4 <__umoddi3+0xd8>
  802652:	89 c8                	mov    %ecx,%eax
  802654:	89 f2                	mov    %esi,%edx
  802656:	f7 f7                	div    %edi
  802658:	89 d0                	mov    %edx,%eax
  80265a:	31 d2                	xor    %edx,%edx
  80265c:	83 c4 1c             	add    $0x1c,%esp
  80265f:	5b                   	pop    %ebx
  802660:	5e                   	pop    %esi
  802661:	5f                   	pop    %edi
  802662:	5d                   	pop    %ebp
  802663:	c3                   	ret    
  802664:	39 f0                	cmp    %esi,%eax
  802666:	0f 87 ac 00 00 00    	ja     802718 <__umoddi3+0xfc>
  80266c:	0f bd e8             	bsr    %eax,%ebp
  80266f:	83 f5 1f             	xor    $0x1f,%ebp
  802672:	0f 84 ac 00 00 00    	je     802724 <__umoddi3+0x108>
  802678:	bf 20 00 00 00       	mov    $0x20,%edi
  80267d:	29 ef                	sub    %ebp,%edi
  80267f:	89 fe                	mov    %edi,%esi
  802681:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802685:	89 e9                	mov    %ebp,%ecx
  802687:	d3 e0                	shl    %cl,%eax
  802689:	89 d7                	mov    %edx,%edi
  80268b:	89 f1                	mov    %esi,%ecx
  80268d:	d3 ef                	shr    %cl,%edi
  80268f:	09 c7                	or     %eax,%edi
  802691:	89 e9                	mov    %ebp,%ecx
  802693:	d3 e2                	shl    %cl,%edx
  802695:	89 14 24             	mov    %edx,(%esp)
  802698:	89 d8                	mov    %ebx,%eax
  80269a:	d3 e0                	shl    %cl,%eax
  80269c:	89 c2                	mov    %eax,%edx
  80269e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026a2:	d3 e0                	shl    %cl,%eax
  8026a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026ac:	89 f1                	mov    %esi,%ecx
  8026ae:	d3 e8                	shr    %cl,%eax
  8026b0:	09 d0                	or     %edx,%eax
  8026b2:	d3 eb                	shr    %cl,%ebx
  8026b4:	89 da                	mov    %ebx,%edx
  8026b6:	f7 f7                	div    %edi
  8026b8:	89 d3                	mov    %edx,%ebx
  8026ba:	f7 24 24             	mull   (%esp)
  8026bd:	89 c6                	mov    %eax,%esi
  8026bf:	89 d1                	mov    %edx,%ecx
  8026c1:	39 d3                	cmp    %edx,%ebx
  8026c3:	0f 82 87 00 00 00    	jb     802750 <__umoddi3+0x134>
  8026c9:	0f 84 91 00 00 00    	je     802760 <__umoddi3+0x144>
  8026cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026d3:	29 f2                	sub    %esi,%edx
  8026d5:	19 cb                	sbb    %ecx,%ebx
  8026d7:	89 d8                	mov    %ebx,%eax
  8026d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026dd:	d3 e0                	shl    %cl,%eax
  8026df:	89 e9                	mov    %ebp,%ecx
  8026e1:	d3 ea                	shr    %cl,%edx
  8026e3:	09 d0                	or     %edx,%eax
  8026e5:	89 e9                	mov    %ebp,%ecx
  8026e7:	d3 eb                	shr    %cl,%ebx
  8026e9:	89 da                	mov    %ebx,%edx
  8026eb:	83 c4 1c             	add    $0x1c,%esp
  8026ee:	5b                   	pop    %ebx
  8026ef:	5e                   	pop    %esi
  8026f0:	5f                   	pop    %edi
  8026f1:	5d                   	pop    %ebp
  8026f2:	c3                   	ret    
  8026f3:	90                   	nop
  8026f4:	89 fd                	mov    %edi,%ebp
  8026f6:	85 ff                	test   %edi,%edi
  8026f8:	75 0b                	jne    802705 <__umoddi3+0xe9>
  8026fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ff:	31 d2                	xor    %edx,%edx
  802701:	f7 f7                	div    %edi
  802703:	89 c5                	mov    %eax,%ebp
  802705:	89 f0                	mov    %esi,%eax
  802707:	31 d2                	xor    %edx,%edx
  802709:	f7 f5                	div    %ebp
  80270b:	89 c8                	mov    %ecx,%eax
  80270d:	f7 f5                	div    %ebp
  80270f:	89 d0                	mov    %edx,%eax
  802711:	e9 44 ff ff ff       	jmp    80265a <__umoddi3+0x3e>
  802716:	66 90                	xchg   %ax,%ax
  802718:	89 c8                	mov    %ecx,%eax
  80271a:	89 f2                	mov    %esi,%edx
  80271c:	83 c4 1c             	add    $0x1c,%esp
  80271f:	5b                   	pop    %ebx
  802720:	5e                   	pop    %esi
  802721:	5f                   	pop    %edi
  802722:	5d                   	pop    %ebp
  802723:	c3                   	ret    
  802724:	3b 04 24             	cmp    (%esp),%eax
  802727:	72 06                	jb     80272f <__umoddi3+0x113>
  802729:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80272d:	77 0f                	ja     80273e <__umoddi3+0x122>
  80272f:	89 f2                	mov    %esi,%edx
  802731:	29 f9                	sub    %edi,%ecx
  802733:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802737:	89 14 24             	mov    %edx,(%esp)
  80273a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80273e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802742:	8b 14 24             	mov    (%esp),%edx
  802745:	83 c4 1c             	add    $0x1c,%esp
  802748:	5b                   	pop    %ebx
  802749:	5e                   	pop    %esi
  80274a:	5f                   	pop    %edi
  80274b:	5d                   	pop    %ebp
  80274c:	c3                   	ret    
  80274d:	8d 76 00             	lea    0x0(%esi),%esi
  802750:	2b 04 24             	sub    (%esp),%eax
  802753:	19 fa                	sbb    %edi,%edx
  802755:	89 d1                	mov    %edx,%ecx
  802757:	89 c6                	mov    %eax,%esi
  802759:	e9 71 ff ff ff       	jmp    8026cf <__umoddi3+0xb3>
  80275e:	66 90                	xchg   %ax,%ax
  802760:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802764:	72 ea                	jb     802750 <__umoddi3+0x134>
  802766:	89 d9                	mov    %ebx,%ecx
  802768:	e9 62 ff ff ff       	jmp    8026cf <__umoddi3+0xb3>
