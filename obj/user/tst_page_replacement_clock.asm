
obj/user/tst_page_replacement_clock:     file format elf32-i386


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
  800031:	e8 a3 04 00 00       	call   8004d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
uint8* ptr = (uint8* )0x0801000 ;
uint8* ptr2 = (uint8* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 68             	sub    $0x68,%esp
	int envID = sys_getenvid();
  80003e:	e8 81 14 00 00       	call   8014c4 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf("envID = %d\n",envID);

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800046:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800049:	89 d0                	mov    %edx,%eax
  80004b:	c1 e0 03             	shl    $0x3,%eax
  80004e:	01 d0                	add    %edx,%eax
  800050:	01 c0                	add    %eax,%eax
  800052:	01 d0                	add    %edx,%eax
  800054:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005b:	01 d0                	add    %edx,%eax
  80005d:	c1 e0 03             	shl    $0x3,%eax
  800060:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800065:	89 45 ec             	mov    %eax,-0x14(%ebp)

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800068:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800071:	8b 00                	mov    (%eax),%eax
  800073:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800079:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80007e:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800083:	74 14                	je     800099 <_main+0x61>
  800085:	83 ec 04             	sub    $0x4,%esp
  800088:	68 20 1c 80 00       	push   $0x801c20
  80008d:	6a 15                	push   $0x15
  80008f:	68 64 1c 80 00       	push   $0x801c64
  800094:	e8 01 05 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800099:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009c:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000a2:	83 c0 0c             	add    $0xc,%eax
  8000a5:	8b 00                	mov    (%eax),%eax
  8000a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000b2:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000b7:	74 14                	je     8000cd <_main+0x95>
  8000b9:	83 ec 04             	sub    $0x4,%esp
  8000bc:	68 20 1c 80 00       	push   $0x801c20
  8000c1:	6a 16                	push   $0x16
  8000c3:	68 64 1c 80 00       	push   $0x801c64
  8000c8:	e8 cd 04 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d0:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000d6:	83 c0 18             	add    $0x18,%eax
  8000d9:	8b 00                	mov    (%eax),%eax
  8000db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000e6:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000eb:	74 14                	je     800101 <_main+0xc9>
  8000ed:	83 ec 04             	sub    $0x4,%esp
  8000f0:	68 20 1c 80 00       	push   $0x801c20
  8000f5:	6a 17                	push   $0x17
  8000f7:	68 64 1c 80 00       	push   $0x801c64
  8000fc:	e8 99 04 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800104:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80010a:	83 c0 24             	add    $0x24,%eax
  80010d:	8b 00                	mov    (%eax),%eax
  80010f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800112:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800115:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80011a:	3d 00 30 20 00       	cmp    $0x203000,%eax
  80011f:	74 14                	je     800135 <_main+0xfd>
  800121:	83 ec 04             	sub    $0x4,%esp
  800124:	68 20 1c 80 00       	push   $0x801c20
  800129:	6a 18                	push   $0x18
  80012b:	68 64 1c 80 00       	push   $0x801c64
  800130:	e8 65 04 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800138:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80013e:	83 c0 30             	add    $0x30,%eax
  800141:	8b 00                	mov    (%eax),%eax
  800143:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800146:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800149:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80014e:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 20 1c 80 00       	push   $0x801c20
  80015d:	6a 19                	push   $0x19
  80015f:	68 64 1c 80 00       	push   $0x801c64
  800164:	e8 31 04 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800169:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016c:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800172:	83 c0 3c             	add    $0x3c,%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80017a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80017d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800182:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800187:	74 14                	je     80019d <_main+0x165>
  800189:	83 ec 04             	sub    $0x4,%esp
  80018c:	68 20 1c 80 00       	push   $0x801c20
  800191:	6a 1a                	push   $0x1a
  800193:	68 64 1c 80 00       	push   $0x801c64
  800198:	e8 fd 03 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80019d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a0:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001a6:	83 c0 48             	add    $0x48,%eax
  8001a9:	8b 00                	mov    (%eax),%eax
  8001ab:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b6:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 20 1c 80 00       	push   $0x801c20
  8001c5:	6a 1b                	push   $0x1b
  8001c7:	68 64 1c 80 00       	push   $0x801c64
  8001cc:	e8 c9 03 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001da:	83 c0 54             	add    $0x54,%eax
  8001dd:	8b 00                	mov    (%eax),%eax
  8001df:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ea:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001ef:	74 14                	je     800205 <_main+0x1cd>
  8001f1:	83 ec 04             	sub    $0x4,%esp
  8001f4:	68 20 1c 80 00       	push   $0x801c20
  8001f9:	6a 1c                	push   $0x1c
  8001fb:	68 64 1c 80 00       	push   $0x801c64
  800200:	e8 95 03 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800208:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80020e:	83 c0 60             	add    $0x60,%eax
  800211:	8b 00                	mov    (%eax),%eax
  800213:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800216:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800219:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80021e:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 20 1c 80 00       	push   $0x801c20
  80022d:	6a 1d                	push   $0x1d
  80022f:	68 64 1c 80 00       	push   $0x801c64
  800234:	e8 61 03 00 00       	call   80059a <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  800242:	85 c0                	test   %eax,%eax
  800244:	74 14                	je     80025a <_main+0x222>
  800246:	83 ec 04             	sub    $0x4,%esp
  800249:	68 88 1c 80 00       	push   $0x801c88
  80024e:	6a 1e                	push   $0x1e
  800250:	68 64 1c 80 00       	push   $0x801c64
  800255:	e8 40 03 00 00       	call   80059a <_panic>
	}

	int freePages = sys_calculate_free_frames();
  80025a:	e8 17 13 00 00       	call   801576 <sys_calculate_free_frames>
  80025f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800262:	e8 92 13 00 00       	call   8015f9 <sys_pf_calculate_allocated_pages>
  800267:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//cprintf("\n DONE DONE\n");
	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  80026a:	a0 1f e0 80 00       	mov    0x80e01f,%al
  80026f:	88 45 bf             	mov    %al,-0x41(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  800272:	a0 1f f0 80 00       	mov    0x80f01f,%al
  800277:	88 45 be             	mov    %al,-0x42(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80027a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800281:	eb 37                	jmp    8002ba <_main+0x282>
	{
		arr[i] = -1 ;
  800283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800286:	05 20 30 80 00       	add    $0x803020,%eax
  80028b:	c6 00 ff             	movb   $0xff,(%eax)
		*ptr = *ptr2 ;
  80028e:	a1 00 30 80 00       	mov    0x803000,%eax
  800293:	8b 15 04 30 80 00    	mov    0x803004,%edx
  800299:	8a 12                	mov    (%edx),%dl
  80029b:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  80029d:	a1 00 30 80 00       	mov    0x803000,%eax
  8002a2:	40                   	inc    %eax
  8002a3:	a3 00 30 80 00       	mov    %eax,0x803000
  8002a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ad:	40                   	inc    %eax
  8002ae:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002b3:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8002ba:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8002c1:	7e c0                	jle    800283 <_main+0x24b>
	}

	//===================


	cprintf("Checking PAGE CLOCK algorithm... \n");
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	68 d0 1c 80 00       	push   $0x801cd0
  8002cb:	e8 f5 03 00 00       	call   8006c5 <cprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8002dc:	8b 00                	mov    (%eax),%eax
  8002de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8002e1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002e9:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8002ee:	74 14                	je     800304 <_main+0x2cc>
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	68 f4 1c 80 00       	push   $0x801cf4
  8002f8:	6a 37                	push   $0x37
  8002fa:	68 64 1c 80 00       	push   $0x801c64
  8002ff:	e8 96 02 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80c000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800304:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800307:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80030d:	83 c0 0c             	add    $0xc,%eax
  800310:	8b 00                	mov    (%eax),%eax
  800312:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800315:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800318:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80031d:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800322:	74 14                	je     800338 <_main+0x300>
  800324:	83 ec 04             	sub    $0x4,%esp
  800327:	68 f4 1c 80 00       	push   $0x801cf4
  80032c:	6a 38                	push   $0x38
  80032e:	68 64 1c 80 00       	push   $0x801c64
  800333:	e8 62 02 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800341:	83 c0 18             	add    $0x18,%eax
  800344:	8b 00                	mov    (%eax),%eax
  800346:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800349:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80034c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800351:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 f4 1c 80 00       	push   $0x801cf4
  800360:	6a 39                	push   $0x39
  800362:	68 64 1c 80 00       	push   $0x801c64
  800367:	e8 2e 02 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80036c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80036f:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800375:	83 c0 24             	add    $0x24,%eax
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80037d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800380:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800385:	3d 00 40 80 00       	cmp    $0x804000,%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 f4 1c 80 00       	push   $0x801cf4
  800394:	6a 3a                	push   $0x3a
  800396:	68 64 1c 80 00       	push   $0x801c64
  80039b:	e8 fa 01 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x809000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8003a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a3:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8003a9:	83 c0 30             	add    $0x30,%eax
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8003b1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b9:	3d 00 90 80 00       	cmp    $0x809000,%eax
  8003be:	74 14                	je     8003d4 <_main+0x39c>
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	68 f4 1c 80 00       	push   $0x801cf4
  8003c8:	6a 3b                	push   $0x3b
  8003ca:	68 64 1c 80 00       	push   $0x801c64
  8003cf:	e8 c6 01 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8003d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003d7:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8003dd:	83 c0 3c             	add    $0x3c,%eax
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8003e5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ed:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  8003f2:	74 14                	je     800408 <_main+0x3d0>
  8003f4:	83 ec 04             	sub    $0x4,%esp
  8003f7:	68 f4 1c 80 00       	push   $0x801cf4
  8003fc:	6a 3c                	push   $0x3c
  8003fe:	68 64 1c 80 00       	push   $0x801c64
  800403:	e8 92 01 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x80b000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800408:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800411:	83 c0 48             	add    $0x48,%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800419:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80041c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800421:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 f4 1c 80 00       	push   $0x801cf4
  800430:	6a 3d                	push   $0x3d
  800432:	68 64 1c 80 00       	push   $0x801c64
  800437:	e8 5e 01 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80043c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80043f:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800445:	83 c0 54             	add    $0x54,%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80044d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800450:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800455:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80045a:	74 14                	je     800470 <_main+0x438>
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	68 f4 1c 80 00       	push   $0x801cf4
  800464:	6a 3e                	push   $0x3e
  800466:	68 64 1c 80 00       	push   $0x801c64
  80046b:	e8 2a 01 00 00       	call   80059a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800473:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800479:	83 c0 60             	add    $0x60,%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	89 45 98             	mov    %eax,-0x68(%ebp)
  800481:	8b 45 98             	mov    -0x68(%ebp),%eax
  800484:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800489:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 f4 1c 80 00       	push   $0x801cf4
  800498:	6a 3f                	push   $0x3f
  80049a:	68 64 1c 80 00       	push   $0x801c64
  80049f:	e8 f6 00 00 00       	call   80059a <_panic>

		if(myEnv->page_last_WS_index != 2) panic("wrong PAGE WS pointer location");
  8004a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004a7:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  8004ad:	83 f8 02             	cmp    $0x2,%eax
  8004b0:	74 14                	je     8004c6 <_main+0x48e>
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 44 1d 80 00       	push   $0x801d44
  8004ba:	6a 41                	push   $0x41
  8004bc:	68 64 1c 80 00       	push   $0x801c64
  8004c1:	e8 d4 00 00 00       	call   80059a <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [CLOCK Alg.] is completed successfully.\n");
  8004c6:	83 ec 0c             	sub    $0xc,%esp
  8004c9:	68 64 1d 80 00       	push   $0x801d64
  8004ce:	e8 f2 01 00 00       	call   8006c5 <cprintf>
  8004d3:	83 c4 10             	add    $0x10,%esp
	return;
  8004d6:	90                   	nop
}
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004e3:	7e 0a                	jle    8004ef <libmain+0x16>
		binaryname = argv[0];
  8004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	ff 75 0c             	pushl  0xc(%ebp)
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 3b fb ff ff       	call   800038 <_main>
  8004fd:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800500:	e8 bf 0f 00 00       	call   8014c4 <sys_getenvid>
  800505:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80050b:	89 d0                	mov    %edx,%eax
  80050d:	c1 e0 03             	shl    $0x3,%eax
  800510:	01 d0                	add    %edx,%eax
  800512:	01 c0                	add    %eax,%eax
  800514:	01 d0                	add    %edx,%eax
  800516:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051d:	01 d0                	add    %edx,%eax
  80051f:	c1 e0 03             	shl    $0x3,%eax
  800522:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800527:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  80052a:	e8 e3 10 00 00       	call   801612 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80052f:	83 ec 0c             	sub    $0xc,%esp
  800532:	68 d0 1d 80 00       	push   $0x801dd0
  800537:	e8 89 01 00 00       	call   8006c5 <cprintf>
  80053c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80053f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800542:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	50                   	push   %eax
  80054c:	68 f8 1d 80 00       	push   $0x801df8
  800551:	e8 6f 01 00 00       	call   8006c5 <cprintf>
  800556:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800559:	83 ec 0c             	sub    $0xc,%esp
  80055c:	68 d0 1d 80 00       	push   $0x801dd0
  800561:	e8 5f 01 00 00       	call   8006c5 <cprintf>
  800566:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800569:	e8 be 10 00 00       	call   80162c <sys_enable_interrupt>

	// exit gracefully
	exit();
  80056e:	e8 19 00 00 00       	call   80058c <exit>
}
  800573:	90                   	nop
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80057c:	83 ec 0c             	sub    $0xc,%esp
  80057f:	6a 00                	push   $0x0
  800581:	e8 23 0f 00 00       	call   8014a9 <sys_env_destroy>
  800586:	83 c4 10             	add    $0x10,%esp
}
  800589:	90                   	nop
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    

0080058c <exit>:

void
exit(void)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800592:	e8 46 0f 00 00       	call   8014dd <sys_env_exit>
}
  800597:	90                   	nop
  800598:	c9                   	leave  
  800599:	c3                   	ret    

0080059a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80059a:	55                   	push   %ebp
  80059b:	89 e5                	mov    %esp,%ebp
  80059d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005a0:	8d 45 10             	lea    0x10(%ebp),%eax
  8005a3:	83 c0 04             	add    $0x4,%eax
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8005a9:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  8005ae:	85 c0                	test   %eax,%eax
  8005b0:	74 16                	je     8005c8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005b2:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	50                   	push   %eax
  8005bb:	68 11 1e 80 00       	push   $0x801e11
  8005c0:	e8 00 01 00 00       	call   8006c5 <cprintf>
  8005c5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005c8:	a1 08 30 80 00       	mov    0x803008,%eax
  8005cd:	ff 75 0c             	pushl  0xc(%ebp)
  8005d0:	ff 75 08             	pushl  0x8(%ebp)
  8005d3:	50                   	push   %eax
  8005d4:	68 16 1e 80 00       	push   $0x801e16
  8005d9:	e8 e7 00 00 00       	call   8006c5 <cprintf>
  8005de:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ea:	50                   	push   %eax
  8005eb:	e8 7a 00 00 00       	call   80066a <vcprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8005f3:	83 ec 0c             	sub    $0xc,%esp
  8005f6:	68 32 1e 80 00       	push   $0x801e32
  8005fb:	e8 c5 00 00 00       	call   8006c5 <cprintf>
  800600:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800603:	e8 84 ff ff ff       	call   80058c <exit>

	// should not return here
	while (1) ;
  800608:	eb fe                	jmp    800608 <_panic+0x6e>

0080060a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80060a:	55                   	push   %ebp
  80060b:	89 e5                	mov    %esp,%ebp
  80060d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800610:	8b 45 0c             	mov    0xc(%ebp),%eax
  800613:	8b 00                	mov    (%eax),%eax
  800615:	8d 48 01             	lea    0x1(%eax),%ecx
  800618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061b:	89 0a                	mov    %ecx,(%edx)
  80061d:	8b 55 08             	mov    0x8(%ebp),%edx
  800620:	88 d1                	mov    %dl,%cl
  800622:	8b 55 0c             	mov    0xc(%ebp),%edx
  800625:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800633:	75 23                	jne    800658 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800635:	8b 45 0c             	mov    0xc(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	89 c2                	mov    %eax,%edx
  80063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063f:	83 c0 08             	add    $0x8,%eax
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	52                   	push   %edx
  800646:	50                   	push   %eax
  800647:	e8 27 0e 00 00       	call   801473 <sys_cputs>
  80064c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80064f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800652:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065b:	8b 40 04             	mov    0x4(%eax),%eax
  80065e:	8d 50 01             	lea    0x1(%eax),%edx
  800661:	8b 45 0c             	mov    0xc(%ebp),%eax
  800664:	89 50 04             	mov    %edx,0x4(%eax)
}
  800667:	90                   	nop
  800668:	c9                   	leave  
  800669:	c3                   	ret    

0080066a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80066a:	55                   	push   %ebp
  80066b:	89 e5                	mov    %esp,%ebp
  80066d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800673:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80067a:	00 00 00 
	b.cnt = 0;
  80067d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800684:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	ff 75 08             	pushl  0x8(%ebp)
  80068d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800693:	50                   	push   %eax
  800694:	68 0a 06 80 00       	push   $0x80060a
  800699:	e8 fa 01 00 00       	call   800898 <vprintfmt>
  80069e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8006a1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	50                   	push   %eax
  8006ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006b1:	83 c0 08             	add    $0x8,%eax
  8006b4:	50                   	push   %eax
  8006b5:	e8 b9 0d 00 00       	call   801473 <sys_cputs>
  8006ba:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8006bd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006c3:	c9                   	leave  
  8006c4:	c3                   	ret    

008006c5 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006c5:	55                   	push   %ebp
  8006c6:	89 e5                	mov    %esp,%ebp
  8006c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006da:	50                   	push   %eax
  8006db:	e8 8a ff ff ff       	call   80066a <vcprintf>
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e9:	c9                   	leave  
  8006ea:	c3                   	ret    

008006eb <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006eb:	55                   	push   %ebp
  8006ec:	89 e5                	mov    %esp,%ebp
  8006ee:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006f1:	e8 1c 0f 00 00       	call   801612 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	ff 75 f4             	pushl  -0xc(%ebp)
  800705:	50                   	push   %eax
  800706:	e8 5f ff ff ff       	call   80066a <vcprintf>
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800711:	e8 16 0f 00 00       	call   80162c <sys_enable_interrupt>
	return cnt;
  800716:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	53                   	push   %ebx
  80071f:	83 ec 14             	sub    $0x14,%esp
  800722:	8b 45 10             	mov    0x10(%ebp),%eax
  800725:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072e:	8b 45 18             	mov    0x18(%ebp),%eax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800739:	77 55                	ja     800790 <printnum+0x75>
  80073b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073e:	72 05                	jb     800745 <printnum+0x2a>
  800740:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800743:	77 4b                	ja     800790 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800745:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800748:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80074b:	8b 45 18             	mov    0x18(%ebp),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
  800753:	52                   	push   %edx
  800754:	50                   	push   %eax
  800755:	ff 75 f4             	pushl  -0xc(%ebp)
  800758:	ff 75 f0             	pushl  -0x10(%ebp)
  80075b:	e8 50 12 00 00       	call   8019b0 <__udivdi3>
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	83 ec 04             	sub    $0x4,%esp
  800766:	ff 75 20             	pushl  0x20(%ebp)
  800769:	53                   	push   %ebx
  80076a:	ff 75 18             	pushl  0x18(%ebp)
  80076d:	52                   	push   %edx
  80076e:	50                   	push   %eax
  80076f:	ff 75 0c             	pushl  0xc(%ebp)
  800772:	ff 75 08             	pushl  0x8(%ebp)
  800775:	e8 a1 ff ff ff       	call   80071b <printnum>
  80077a:	83 c4 20             	add    $0x20,%esp
  80077d:	eb 1a                	jmp    800799 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	ff 75 20             	pushl  0x20(%ebp)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	ff d0                	call   *%eax
  80078d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800790:	ff 4d 1c             	decl   0x1c(%ebp)
  800793:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800797:	7f e6                	jg     80077f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800799:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80079c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a7:	53                   	push   %ebx
  8007a8:	51                   	push   %ecx
  8007a9:	52                   	push   %edx
  8007aa:	50                   	push   %eax
  8007ab:	e8 10 13 00 00       	call   801ac0 <__umoddi3>
  8007b0:	83 c4 10             	add    $0x10,%esp
  8007b3:	05 54 20 80 00       	add    $0x802054,%eax
  8007b8:	8a 00                	mov    (%eax),%al
  8007ba:	0f be c0             	movsbl %al,%eax
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	50                   	push   %eax
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	ff d0                	call   *%eax
  8007c9:	83 c4 10             	add    $0x10,%esp
}
  8007cc:	90                   	nop
  8007cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    

008007d2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d9:	7e 1c                	jle    8007f7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	8d 50 08             	lea    0x8(%eax),%edx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	89 10                	mov    %edx,(%eax)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	83 e8 08             	sub    $0x8,%eax
  8007f0:	8b 50 04             	mov    0x4(%eax),%edx
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	eb 40                	jmp    800837 <getuint+0x65>
	else if (lflag)
  8007f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007fb:	74 1e                	je     80081b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	8d 50 04             	lea    0x4(%eax),%edx
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	89 10                	mov    %edx,(%eax)
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	83 e8 04             	sub    $0x4,%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	ba 00 00 00 00       	mov    $0x0,%edx
  800819:	eb 1c                	jmp    800837 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	8d 50 04             	lea    0x4(%eax),%edx
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	89 10                	mov    %edx,(%eax)
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	83 e8 04             	sub    $0x4,%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80083c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800840:	7e 1c                	jle    80085e <getint+0x25>
		return va_arg(*ap, long long);
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	8d 50 08             	lea    0x8(%eax),%edx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	89 10                	mov    %edx,(%eax)
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	83 e8 08             	sub    $0x8,%eax
  800857:	8b 50 04             	mov    0x4(%eax),%edx
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	eb 38                	jmp    800896 <getint+0x5d>
	else if (lflag)
  80085e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800862:	74 1a                	je     80087e <getint+0x45>
		return va_arg(*ap, long);
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	8d 50 04             	lea    0x4(%eax),%edx
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	89 10                	mov    %edx,(%eax)
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	99                   	cltd   
  80087c:	eb 18                	jmp    800896 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	8d 50 04             	lea    0x4(%eax),%edx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	89 10                	mov    %edx,(%eax)
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	99                   	cltd   
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	56                   	push   %esi
  80089c:	53                   	push   %ebx
  80089d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a0:	eb 17                	jmp    8008b9 <vprintfmt+0x21>
			if (ch == '\0')
  8008a2:	85 db                	test   %ebx,%ebx
  8008a4:	0f 84 af 03 00 00    	je     800c59 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bc:	8d 50 01             	lea    0x1(%eax),%edx
  8008bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8008c2:	8a 00                	mov    (%eax),%al
  8008c4:	0f b6 d8             	movzbl %al,%ebx
  8008c7:	83 fb 25             	cmp    $0x25,%ebx
  8008ca:	75 d6                	jne    8008a2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008cc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008d0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ef:	8d 50 01             	lea    0x1(%eax),%edx
  8008f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f5:	8a 00                	mov    (%eax),%al
  8008f7:	0f b6 d8             	movzbl %al,%ebx
  8008fa:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008fd:	83 f8 55             	cmp    $0x55,%eax
  800900:	0f 87 2b 03 00 00    	ja     800c31 <vprintfmt+0x399>
  800906:	8b 04 85 78 20 80 00 	mov    0x802078(,%eax,4),%eax
  80090d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80090f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800913:	eb d7                	jmp    8008ec <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800915:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800919:	eb d1                	jmp    8008ec <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800922:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800925:	89 d0                	mov    %edx,%eax
  800927:	c1 e0 02             	shl    $0x2,%eax
  80092a:	01 d0                	add    %edx,%eax
  80092c:	01 c0                	add    %eax,%eax
  80092e:	01 d8                	add    %ebx,%eax
  800930:	83 e8 30             	sub    $0x30,%eax
  800933:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800936:	8b 45 10             	mov    0x10(%ebp),%eax
  800939:	8a 00                	mov    (%eax),%al
  80093b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093e:	83 fb 2f             	cmp    $0x2f,%ebx
  800941:	7e 3e                	jle    800981 <vprintfmt+0xe9>
  800943:	83 fb 39             	cmp    $0x39,%ebx
  800946:	7f 39                	jg     800981 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800948:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80094b:	eb d5                	jmp    800922 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	83 c0 04             	add    $0x4,%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	83 e8 04             	sub    $0x4,%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800961:	eb 1f                	jmp    800982 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800963:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800967:	79 83                	jns    8008ec <vprintfmt+0x54>
				width = 0;
  800969:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800970:	e9 77 ff ff ff       	jmp    8008ec <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800975:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80097c:	e9 6b ff ff ff       	jmp    8008ec <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800981:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800986:	0f 89 60 ff ff ff    	jns    8008ec <vprintfmt+0x54>
				width = precision, precision = -1;
  80098c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800992:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800999:	e9 4e ff ff ff       	jmp    8008ec <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009a1:	e9 46 ff ff ff       	jmp    8008ec <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	83 c0 04             	add    $0x4,%eax
  8009ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	83 e8 04             	sub    $0x4,%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	50                   	push   %eax
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	ff d0                	call   *%eax
  8009c3:	83 c4 10             	add    $0x10,%esp
			break;
  8009c6:	e9 89 02 00 00       	jmp    800c54 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	83 c0 04             	add    $0x4,%eax
  8009d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	83 e8 04             	sub    $0x4,%eax
  8009da:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009dc:	85 db                	test   %ebx,%ebx
  8009de:	79 02                	jns    8009e2 <vprintfmt+0x14a>
				err = -err;
  8009e0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009e2:	83 fb 64             	cmp    $0x64,%ebx
  8009e5:	7f 0b                	jg     8009f2 <vprintfmt+0x15a>
  8009e7:	8b 34 9d c0 1e 80 00 	mov    0x801ec0(,%ebx,4),%esi
  8009ee:	85 f6                	test   %esi,%esi
  8009f0:	75 19                	jne    800a0b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009f2:	53                   	push   %ebx
  8009f3:	68 65 20 80 00       	push   $0x802065
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	ff 75 08             	pushl  0x8(%ebp)
  8009fe:	e8 5e 02 00 00       	call   800c61 <printfmt>
  800a03:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a06:	e9 49 02 00 00       	jmp    800c54 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a0b:	56                   	push   %esi
  800a0c:	68 6e 20 80 00       	push   $0x80206e
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	ff 75 08             	pushl  0x8(%ebp)
  800a17:	e8 45 02 00 00       	call   800c61 <printfmt>
  800a1c:	83 c4 10             	add    $0x10,%esp
			break;
  800a1f:	e9 30 02 00 00       	jmp    800c54 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 c0 04             	add    $0x4,%eax
  800a2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 e8 04             	sub    $0x4,%eax
  800a33:	8b 30                	mov    (%eax),%esi
  800a35:	85 f6                	test   %esi,%esi
  800a37:	75 05                	jne    800a3e <vprintfmt+0x1a6>
				p = "(null)";
  800a39:	be 71 20 80 00       	mov    $0x802071,%esi
			if (width > 0 && padc != '-')
  800a3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a42:	7e 6d                	jle    800ab1 <vprintfmt+0x219>
  800a44:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a48:	74 67                	je     800ab1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	50                   	push   %eax
  800a51:	56                   	push   %esi
  800a52:	e8 0c 03 00 00       	call   800d63 <strnlen>
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a5d:	eb 16                	jmp    800a75 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a5f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	50                   	push   %eax
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a72:	ff 4d e4             	decl   -0x1c(%ebp)
  800a75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a79:	7f e4                	jg     800a5f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7b:	eb 34                	jmp    800ab1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a81:	74 1c                	je     800a9f <vprintfmt+0x207>
  800a83:	83 fb 1f             	cmp    $0x1f,%ebx
  800a86:	7e 05                	jle    800a8d <vprintfmt+0x1f5>
  800a88:	83 fb 7e             	cmp    $0x7e,%ebx
  800a8b:	7e 12                	jle    800a9f <vprintfmt+0x207>
					putch('?', putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	6a 3f                	push   $0x3f
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	eb 0f                	jmp    800aae <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	53                   	push   %ebx
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aae:	ff 4d e4             	decl   -0x1c(%ebp)
  800ab1:	89 f0                	mov    %esi,%eax
  800ab3:	8d 70 01             	lea    0x1(%eax),%esi
  800ab6:	8a 00                	mov    (%eax),%al
  800ab8:	0f be d8             	movsbl %al,%ebx
  800abb:	85 db                	test   %ebx,%ebx
  800abd:	74 24                	je     800ae3 <vprintfmt+0x24b>
  800abf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac3:	78 b8                	js     800a7d <vprintfmt+0x1e5>
  800ac5:	ff 4d e0             	decl   -0x20(%ebp)
  800ac8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800acc:	79 af                	jns    800a7d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ace:	eb 13                	jmp    800ae3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	6a 20                	push   $0x20
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae7:	7f e7                	jg     800ad0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ae9:	e9 66 01 00 00       	jmp    800c54 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 e8             	pushl  -0x18(%ebp)
  800af4:	8d 45 14             	lea    0x14(%ebp),%eax
  800af7:	50                   	push   %eax
  800af8:	e8 3c fd ff ff       	call   800839 <getint>
  800afd:	83 c4 10             	add    $0x10,%esp
  800b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0c:	85 d2                	test   %edx,%edx
  800b0e:	79 23                	jns    800b33 <vprintfmt+0x29b>
				putch('-', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 2d                	push   $0x2d
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b26:	f7 d8                	neg    %eax
  800b28:	83 d2 00             	adc    $0x0,%edx
  800b2b:	f7 da                	neg    %edx
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b3a:	e9 bc 00 00 00       	jmp    800bfb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 e8             	pushl  -0x18(%ebp)
  800b45:	8d 45 14             	lea    0x14(%ebp),%eax
  800b48:	50                   	push   %eax
  800b49:	e8 84 fc ff ff       	call   8007d2 <getuint>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b54:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b57:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5e:	e9 98 00 00 00       	jmp    800bfb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	ff 75 0c             	pushl  0xc(%ebp)
  800b69:	6a 58                	push   $0x58
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	ff d0                	call   *%eax
  800b70:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	6a 58                	push   $0x58
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	ff d0                	call   *%eax
  800b80:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b83:	83 ec 08             	sub    $0x8,%esp
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	6a 58                	push   $0x58
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	e9 bc 00 00 00       	jmp    800c54 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 30                	push   $0x30
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba8:	83 ec 08             	sub    $0x8,%esp
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	6a 78                	push   $0x78
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	ff d0                	call   *%eax
  800bb5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbb:	83 c0 04             	add    $0x4,%eax
  800bbe:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc4:	83 e8 04             	sub    $0x4,%eax
  800bc7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bd3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bda:	eb 1f                	jmp    800bfb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800be2:	8d 45 14             	lea    0x14(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	e8 e7 fb ff ff       	call   8007d2 <getuint>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bf4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bfb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c02:	83 ec 04             	sub    $0x4,%esp
  800c05:	52                   	push   %edx
  800c06:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0d:	ff 75 f0             	pushl  -0x10(%ebp)
  800c10:	ff 75 0c             	pushl  0xc(%ebp)
  800c13:	ff 75 08             	pushl  0x8(%ebp)
  800c16:	e8 00 fb ff ff       	call   80071b <printnum>
  800c1b:	83 c4 20             	add    $0x20,%esp
			break;
  800c1e:	eb 34                	jmp    800c54 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
			break;
  800c2f:	eb 23                	jmp    800c54 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	6a 25                	push   $0x25
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c41:	ff 4d 10             	decl   0x10(%ebp)
  800c44:	eb 03                	jmp    800c49 <vprintfmt+0x3b1>
  800c46:	ff 4d 10             	decl   0x10(%ebp)
  800c49:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4c:	48                   	dec    %eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	3c 25                	cmp    $0x25,%al
  800c51:	75 f3                	jne    800c46 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c53:	90                   	nop
		}
	}
  800c54:	e9 47 fc ff ff       	jmp    8008a0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c59:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c67:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6a:	83 c0 04             	add    $0x4,%eax
  800c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c70:	8b 45 10             	mov    0x10(%ebp),%eax
  800c73:	ff 75 f4             	pushl  -0xc(%ebp)
  800c76:	50                   	push   %eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	e8 16 fc ff ff       	call   800898 <vprintfmt>
  800c82:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c85:	90                   	nop
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	8b 40 08             	mov    0x8(%eax),%eax
  800c91:	8d 50 01             	lea    0x1(%eax),%edx
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	8b 10                	mov    (%eax),%edx
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	8b 40 04             	mov    0x4(%eax),%eax
  800ca5:	39 c2                	cmp    %eax,%edx
  800ca7:	73 12                	jae    800cbb <sprintputch+0x33>
		*b->buf++ = ch;
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	8d 48 01             	lea    0x1(%eax),%ecx
  800cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb4:	89 0a                	mov    %ecx,(%edx)
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	88 10                	mov    %dl,(%eax)
}
  800cbb:	90                   	nop
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	01 d0                	add    %edx,%eax
  800cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ce3:	74 06                	je     800ceb <vsnprintf+0x2d>
  800ce5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce9:	7f 07                	jg     800cf2 <vsnprintf+0x34>
		return -E_INVAL;
  800ceb:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf0:	eb 20                	jmp    800d12 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cf2:	ff 75 14             	pushl  0x14(%ebp)
  800cf5:	ff 75 10             	pushl  0x10(%ebp)
  800cf8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cfb:	50                   	push   %eax
  800cfc:	68 88 0c 80 00       	push   $0x800c88
  800d01:	e8 92 fb ff ff       	call   800898 <vprintfmt>
  800d06:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d0c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d23:	8b 45 10             	mov    0x10(%ebp),%eax
  800d26:	ff 75 f4             	pushl  -0xc(%ebp)
  800d29:	50                   	push   %eax
  800d2a:	ff 75 0c             	pushl  0xc(%ebp)
  800d2d:	ff 75 08             	pushl  0x8(%ebp)
  800d30:	e8 89 ff ff ff       	call   800cbe <vsnprintf>
  800d35:	83 c4 10             	add    $0x10,%esp
  800d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d4d:	eb 06                	jmp    800d55 <strlen+0x15>
		n++;
  800d4f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d52:	ff 45 08             	incl   0x8(%ebp)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	75 f1                	jne    800d4f <strlen+0xf>
		n++;
	return n;
  800d5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d61:	c9                   	leave  
  800d62:	c3                   	ret    

00800d63 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d70:	eb 09                	jmp    800d7b <strnlen+0x18>
		n++;
  800d72:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	ff 4d 0c             	decl   0xc(%ebp)
  800d7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7f:	74 09                	je     800d8a <strnlen+0x27>
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	84 c0                	test   %al,%al
  800d88:	75 e8                	jne    800d72 <strnlen+0xf>
		n++;
	return n;
  800d8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d9b:	90                   	nop
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8d 50 01             	lea    0x1(%eax),%edx
  800da2:	89 55 08             	mov    %edx,0x8(%ebp)
  800da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dae:	8a 12                	mov    (%edx),%dl
  800db0:	88 10                	mov    %dl,(%eax)
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	75 e4                	jne    800d9c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dbb:	c9                   	leave  
  800dbc:	c3                   	ret    

00800dbd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd0:	eb 1f                	jmp    800df1 <strncpy+0x34>
		*dst++ = *src;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8d 50 01             	lea    0x1(%eax),%edx
  800dd8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dde:	8a 12                	mov    (%edx),%dl
  800de0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	84 c0                	test   %al,%al
  800de9:	74 03                	je     800dee <strncpy+0x31>
			src++;
  800deb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dee:	ff 45 fc             	incl   -0x4(%ebp)
  800df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df7:	72 d9                	jb     800dd2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800df9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0e:	74 30                	je     800e40 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e10:	eb 16                	jmp    800e28 <strlcpy+0x2a>
			*dst++ = *src++;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8d 50 01             	lea    0x1(%eax),%edx
  800e18:	89 55 08             	mov    %edx,0x8(%ebp)
  800e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e21:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e24:	8a 12                	mov    (%edx),%dl
  800e26:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e28:	ff 4d 10             	decl   0x10(%ebp)
  800e2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2f:	74 09                	je     800e3a <strlcpy+0x3c>
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	84 c0                	test   %al,%al
  800e38:	75 d8                	jne    800e12 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e46:	29 c2                	sub    %eax,%edx
  800e48:	89 d0                	mov    %edx,%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e4f:	eb 06                	jmp    800e57 <strcmp+0xb>
		p++, q++;
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	84 c0                	test   %al,%al
  800e5e:	74 0e                	je     800e6e <strcmp+0x22>
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 10                	mov    (%eax),%dl
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	38 c2                	cmp    %al,%dl
  800e6c:	74 e3                	je     800e51 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	0f b6 d0             	movzbl %al,%edx
  800e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	0f b6 c0             	movzbl %al,%eax
  800e7e:	29 c2                	sub    %eax,%edx
  800e80:	89 d0                	mov    %edx,%eax
}
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    

00800e84 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e87:	eb 09                	jmp    800e92 <strncmp+0xe>
		n--, p++, q++;
  800e89:	ff 4d 10             	decl   0x10(%ebp)
  800e8c:	ff 45 08             	incl   0x8(%ebp)
  800e8f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e96:	74 17                	je     800eaf <strncmp+0x2b>
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	84 c0                	test   %al,%al
  800e9f:	74 0e                	je     800eaf <strncmp+0x2b>
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 10                	mov    (%eax),%dl
  800ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	38 c2                	cmp    %al,%dl
  800ead:	74 da                	je     800e89 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb3:	75 07                	jne    800ebc <strncmp+0x38>
		return 0;
  800eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eba:	eb 14                	jmp    800ed0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	0f b6 d0             	movzbl %al,%edx
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	29 c2                	sub    %eax,%edx
  800ece:	89 d0                	mov    %edx,%eax
}
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    

00800ed2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 04             	sub    $0x4,%esp
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ede:	eb 12                	jmp    800ef2 <strchr+0x20>
		if (*s == c)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee8:	75 05                	jne    800eef <strchr+0x1d>
			return (char *) s;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	eb 11                	jmp    800f00 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eef:	ff 45 08             	incl   0x8(%ebp)
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	84 c0                	test   %al,%al
  800ef9:	75 e5                	jne    800ee0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800efb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 04             	sub    $0x4,%esp
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f0e:	eb 0d                	jmp    800f1d <strfind+0x1b>
		if (*s == c)
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f18:	74 0e                	je     800f28 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	84 c0                	test   %al,%al
  800f24:	75 ea                	jne    800f10 <strfind+0xe>
  800f26:	eb 01                	jmp    800f29 <strfind+0x27>
		if (*s == c)
			break;
  800f28:	90                   	nop
	return (char *) s;
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f40:	eb 0e                	jmp    800f50 <memset+0x22>
		*p++ = c;
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f45:	8d 50 01             	lea    0x1(%eax),%edx
  800f48:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f50:	ff 4d f8             	decl   -0x8(%ebp)
  800f53:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f57:	79 e9                	jns    800f42 <memset+0x14>
		*p++ = c;

	return v;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f70:	eb 16                	jmp    800f88 <memcpy+0x2a>
		*d++ = *s++;
  800f72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f75:	8d 50 01             	lea    0x1(%eax),%edx
  800f78:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f81:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f84:	8a 12                	mov    (%edx),%dl
  800f86:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f91:	85 c0                	test   %eax,%eax
  800f93:	75 dd                	jne    800f72 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb2:	73 50                	jae    801004 <memmove+0x6a>
  800fb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fba:	01 d0                	add    %edx,%eax
  800fbc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbf:	76 43                	jbe    801004 <memmove+0x6a>
		s += n;
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcd:	eb 10                	jmp    800fdf <memmove+0x45>
			*--d = *--s;
  800fcf:	ff 4d f8             	decl   -0x8(%ebp)
  800fd2:	ff 4d fc             	decl   -0x4(%ebp)
  800fd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd8:	8a 10                	mov    (%eax),%dl
  800fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	75 e3                	jne    800fcf <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fec:	eb 23                	jmp    801011 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff1:	8d 50 01             	lea    0x1(%eax),%edx
  800ff4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801000:	8a 12                	mov    (%edx),%dl
  801002:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100a:	89 55 10             	mov    %edx,0x10(%ebp)
  80100d:	85 c0                	test   %eax,%eax
  80100f:	75 dd                	jne    800fee <memmove+0x54>
			*d++ = *s++;

	return dst;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801022:	8b 45 0c             	mov    0xc(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801028:	eb 2a                	jmp    801054 <memcmp+0x3e>
		if (*s1 != *s2)
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 10                	mov    (%eax),%dl
  80102f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	38 c2                	cmp    %al,%dl
  801036:	74 16                	je     80104e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801038:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f b6 d0             	movzbl %al,%edx
  801040:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 c0             	movzbl %al,%eax
  801048:	29 c2                	sub    %eax,%edx
  80104a:	89 d0                	mov    %edx,%eax
  80104c:	eb 18                	jmp    801066 <memcmp+0x50>
		s1++, s2++;
  80104e:	ff 45 fc             	incl   -0x4(%ebp)
  801051:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 c9                	jne    80102a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	8b 45 10             	mov    0x10(%ebp),%eax
  801074:	01 d0                	add    %edx,%eax
  801076:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801079:	eb 15                	jmp    801090 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	0f b6 d0             	movzbl %al,%edx
  801083:	8b 45 0c             	mov    0xc(%ebp),%eax
  801086:	0f b6 c0             	movzbl %al,%eax
  801089:	39 c2                	cmp    %eax,%edx
  80108b:	74 0d                	je     80109a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108d:	ff 45 08             	incl   0x8(%ebp)
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801096:	72 e3                	jb     80107b <memfind+0x13>
  801098:	eb 01                	jmp    80109b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80109a:	90                   	nop
	return (void *) s;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109e:	c9                   	leave  
  80109f:	c3                   	ret    

008010a0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b4:	eb 03                	jmp    8010b9 <strtol+0x19>
		s++;
  8010b6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	3c 20                	cmp    $0x20,%al
  8010c0:	74 f4                	je     8010b6 <strtol+0x16>
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 09                	cmp    $0x9,%al
  8010c9:	74 eb                	je     8010b6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 2b                	cmp    $0x2b,%al
  8010d2:	75 05                	jne    8010d9 <strtol+0x39>
		s++;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	eb 13                	jmp    8010ec <strtol+0x4c>
	else if (*s == '-')
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 2d                	cmp    $0x2d,%al
  8010e0:	75 0a                	jne    8010ec <strtol+0x4c>
		s++, neg = 1;
  8010e2:	ff 45 08             	incl   0x8(%ebp)
  8010e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f0:	74 06                	je     8010f8 <strtol+0x58>
  8010f2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f6:	75 20                	jne    801118 <strtol+0x78>
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 30                	cmp    $0x30,%al
  8010ff:	75 17                	jne    801118 <strtol+0x78>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	40                   	inc    %eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	3c 78                	cmp    $0x78,%al
  801109:	75 0d                	jne    801118 <strtol+0x78>
		s += 2, base = 16;
  80110b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80110f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801116:	eb 28                	jmp    801140 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801118:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111c:	75 15                	jne    801133 <strtol+0x93>
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	3c 30                	cmp    $0x30,%al
  801125:	75 0c                	jne    801133 <strtol+0x93>
		s++, base = 8;
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801131:	eb 0d                	jmp    801140 <strtol+0xa0>
	else if (base == 0)
  801133:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801137:	75 07                	jne    801140 <strtol+0xa0>
		base = 10;
  801139:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	3c 2f                	cmp    $0x2f,%al
  801147:	7e 19                	jle    801162 <strtol+0xc2>
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 39                	cmp    $0x39,%al
  801150:	7f 10                	jg     801162 <strtol+0xc2>
			dig = *s - '0';
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	0f be c0             	movsbl %al,%eax
  80115a:	83 e8 30             	sub    $0x30,%eax
  80115d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801160:	eb 42                	jmp    8011a4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	3c 60                	cmp    $0x60,%al
  801169:	7e 19                	jle    801184 <strtol+0xe4>
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	3c 7a                	cmp    $0x7a,%al
  801172:	7f 10                	jg     801184 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	0f be c0             	movsbl %al,%eax
  80117c:	83 e8 57             	sub    $0x57,%eax
  80117f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801182:	eb 20                	jmp    8011a4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	3c 40                	cmp    $0x40,%al
  80118b:	7e 39                	jle    8011c6 <strtol+0x126>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 5a                	cmp    $0x5a,%al
  801194:	7f 30                	jg     8011c6 <strtol+0x126>
			dig = *s - 'A' + 10;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	0f be c0             	movsbl %al,%eax
  80119e:	83 e8 37             	sub    $0x37,%eax
  8011a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011aa:	7d 19                	jge    8011c5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ac:	ff 45 08             	incl   0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b6:	89 c2                	mov    %eax,%edx
  8011b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bb:	01 d0                	add    %edx,%eax
  8011bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c0:	e9 7b ff ff ff       	jmp    801140 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ca:	74 08                	je     8011d4 <strtol+0x134>
		*endptr = (char *) s;
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d8:	74 07                	je     8011e1 <strtol+0x141>
  8011da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dd:	f7 d8                	neg    %eax
  8011df:	eb 03                	jmp    8011e4 <strtol+0x144>
  8011e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fe:	79 13                	jns    801213 <ltostr+0x2d>
	{
		neg = 1;
  801200:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801210:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80121b:	99                   	cltd   
  80121c:	f7 f9                	idiv   %ecx
  80121e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801221:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801224:	8d 50 01             	lea    0x1(%eax),%edx
  801227:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80122a:	89 c2                	mov    %eax,%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801234:	83 c2 30             	add    $0x30,%edx
  801237:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801239:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801241:	f7 e9                	imul   %ecx
  801243:	c1 fa 02             	sar    $0x2,%edx
  801246:	89 c8                	mov    %ecx,%eax
  801248:	c1 f8 1f             	sar    $0x1f,%eax
  80124b:	29 c2                	sub    %eax,%edx
  80124d:	89 d0                	mov    %edx,%eax
  80124f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801252:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801255:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80125a:	f7 e9                	imul   %ecx
  80125c:	c1 fa 02             	sar    $0x2,%edx
  80125f:	89 c8                	mov    %ecx,%eax
  801261:	c1 f8 1f             	sar    $0x1f,%eax
  801264:	29 c2                	sub    %eax,%edx
  801266:	89 d0                	mov    %edx,%eax
  801268:	c1 e0 02             	shl    $0x2,%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	01 c0                	add    %eax,%eax
  80126f:	29 c1                	sub    %eax,%ecx
  801271:	89 ca                	mov    %ecx,%edx
  801273:	85 d2                	test   %edx,%edx
  801275:	75 9c                	jne    801213 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801281:	48                   	dec    %eax
  801282:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 3d                	je     8012c8 <ltostr+0xe2>
		start = 1 ;
  80128b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801292:	eb 34                	jmp    8012c8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	01 c2                	add    %eax,%edx
  8012a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	01 c8                	add    %ecx,%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012c0:	88 02                	mov    %al,(%edx)
		start++ ;
  8012c2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012c5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ce:	7c c4                	jl     801294 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	01 d0                	add    %edx,%eax
  8012d8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012db:	90                   	nop
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012e4:	ff 75 08             	pushl  0x8(%ebp)
  8012e7:	e8 54 fa ff ff       	call   800d40 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	e8 46 fa ff ff       	call   800d40 <strlen>
  8012fa:	83 c4 04             	add    $0x4,%esp
  8012fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130e:	eb 17                	jmp    801327 <strcconcat+0x49>
		final[s] = str1[s] ;
  801310:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801313:	8b 45 10             	mov    0x10(%ebp),%eax
  801316:	01 c2                	add    %eax,%edx
  801318:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	01 c8                	add    %ecx,%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801324:	ff 45 fc             	incl   -0x4(%ebp)
  801327:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80132d:	7c e1                	jl     801310 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80132f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801336:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80133d:	eb 1f                	jmp    80135e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801342:	8d 50 01             	lea    0x1(%eax),%edx
  801345:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801348:	89 c2                	mov    %eax,%edx
  80134a:	8b 45 10             	mov    0x10(%ebp),%eax
  80134d:	01 c2                	add    %eax,%edx
  80134f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 c8                	add    %ecx,%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80135b:	ff 45 f8             	incl   -0x8(%ebp)
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801361:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801364:	7c d9                	jl     80133f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	c6 00 00             	movb   $0x0,(%eax)
}
  801371:	90                   	nop
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801377:	8b 45 14             	mov    0x14(%ebp),%eax
  80137a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801380:	8b 45 14             	mov    0x14(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138c:	8b 45 10             	mov    0x10(%ebp),%eax
  80138f:	01 d0                	add    %edx,%eax
  801391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	eb 0c                	jmp    8013a5 <strsplit+0x31>
			*string++ = 0;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8d 50 01             	lea    0x1(%eax),%edx
  80139f:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 18                	je     8013c6 <strsplit+0x52>
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	0f be c0             	movsbl %al,%eax
  8013b6:	50                   	push   %eax
  8013b7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ba:	e8 13 fb ff ff       	call   800ed2 <strchr>
  8013bf:	83 c4 08             	add    $0x8,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	75 d3                	jne    801399 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	74 5a                	je     801429 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8013cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 f8 0f             	cmp    $0xf,%eax
  8013d7:	75 07                	jne    8013e0 <strsplit+0x6c>
		{
			return 0;
  8013d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013de:	eb 66                	jmp    801446 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e3:	8b 00                	mov    (%eax),%eax
  8013e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8013e8:	8b 55 14             	mov    0x14(%ebp),%edx
  8013eb:	89 0a                	mov    %ecx,(%edx)
  8013ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	01 c2                	add    %eax,%edx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fe:	eb 03                	jmp    801403 <strsplit+0x8f>
			string++;
  801400:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	84 c0                	test   %al,%al
  80140a:	74 8b                	je     801397 <strsplit+0x23>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f be c0             	movsbl %al,%eax
  801414:	50                   	push   %eax
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	e8 b5 fa ff ff       	call   800ed2 <strchr>
  80141d:	83 c4 08             	add    $0x8,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	74 dc                	je     801400 <strsplit+0x8c>
			string++;
	}
  801424:	e9 6e ff ff ff       	jmp    801397 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801429:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80142a:	8b 45 14             	mov    0x14(%ebp),%eax
  80142d:	8b 00                	mov    (%eax),%eax
  80142f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801436:	8b 45 10             	mov    0x10(%ebp),%eax
  801439:	01 d0                	add    %edx,%eax
  80143b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801441:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	57                   	push   %edi
  80144c:	56                   	push   %esi
  80144d:	53                   	push   %ebx
  80144e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8b 55 0c             	mov    0xc(%ebp),%edx
  801457:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80145a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80145d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801460:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801463:	cd 30                	int    $0x30
  801465:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801468:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	5b                   	pop    %ebx
  80146f:	5e                   	pop    %esi
  801470:	5f                   	pop    %edi
  801471:	5d                   	pop    %ebp
  801472:	c3                   	ret    

00801473 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	ff 75 0c             	pushl  0xc(%ebp)
  801482:	50                   	push   %eax
  801483:	6a 00                	push   $0x0
  801485:	e8 be ff ff ff       	call   801448 <syscall>
  80148a:	83 c4 18             	add    $0x18,%esp
}
  80148d:	90                   	nop
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <sys_cgetc>:

int
sys_cgetc(void)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 01                	push   $0x1
  80149f:	e8 a4 ff ff ff       	call   801448 <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	50                   	push   %eax
  8014b8:	6a 03                	push   $0x3
  8014ba:	e8 89 ff ff ff       	call   801448 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 02                	push   $0x2
  8014d3:	e8 70 ff ff ff       	call   801448 <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_env_exit>:

void sys_env_exit(void)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 04                	push   $0x4
  8014ec:	e8 57 ff ff ff       	call   801448 <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	90                   	nop
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	52                   	push   %edx
  801507:	50                   	push   %eax
  801508:	6a 05                	push   $0x5
  80150a:	e8 39 ff ff ff       	call   801448 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801519:	8b 75 18             	mov    0x18(%ebp),%esi
  80151c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80151f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801522:	8b 55 0c             	mov    0xc(%ebp),%edx
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	56                   	push   %esi
  801529:	53                   	push   %ebx
  80152a:	51                   	push   %ecx
  80152b:	52                   	push   %edx
  80152c:	50                   	push   %eax
  80152d:	6a 06                	push   $0x6
  80152f:	e8 14 ff ff ff       	call   801448 <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
}
  801537:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5e                   	pop    %esi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    

0080153e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801541:	8b 55 0c             	mov    0xc(%ebp),%edx
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	52                   	push   %edx
  80154e:	50                   	push   %eax
  80154f:	6a 07                	push   $0x7
  801551:	e8 f2 fe ff ff       	call   801448 <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	6a 08                	push   $0x8
  80156c:	e8 d7 fe ff ff       	call   801448 <syscall>
  801571:	83 c4 18             	add    $0x18,%esp
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 09                	push   $0x9
  801585:	e8 be fe ff ff       	call   801448 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 0a                	push   $0xa
  80159e:	e8 a5 fe ff ff       	call   801448 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 0b                	push   $0xb
  8015b7:	e8 8c fe ff ff       	call   801448 <syscall>
  8015bc:	83 c4 18             	add    $0x18,%esp
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	6a 0d                	push   $0xd
  8015d2:	e8 71 fe ff ff       	call   801448 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
	return;
  8015da:	90                   	nop
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	6a 0e                	push   $0xe
  8015ee:	e8 55 fe ff ff       	call   801448 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f6:	90                   	nop
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 0c                	push   $0xc
  801608:	e8 3b fe ff ff       	call   801448 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 10                	push   $0x10
  801621:	e8 22 fe ff ff       	call   801448 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	90                   	nop
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 11                	push   $0x11
  80163b:	e8 08 fe ff ff       	call   801448 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	90                   	nop
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <sys_cputc>:


void
sys_cputc(const char c)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801652:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	50                   	push   %eax
  80165f:	6a 12                	push   $0x12
  801661:	e8 e2 fd ff ff       	call   801448 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 13                	push   $0x13
  80167b:	e8 c8 fd ff ff       	call   801448 <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
}
  801683:	90                   	nop
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	50                   	push   %eax
  801696:	6a 14                	push   $0x14
  801698:	e8 ab fd ff ff       	call   801448 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	50                   	push   %eax
  8016b1:	6a 17                	push   $0x17
  8016b3:	e8 90 fd ff ff       	call   801448 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	50                   	push   %eax
  8016cc:	6a 15                	push   $0x15
  8016ce:	e8 75 fd ff ff       	call   801448 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	90                   	nop
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	50                   	push   %eax
  8016e8:	6a 16                	push   $0x16
  8016ea:	e8 59 fd ff ff       	call   801448 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	90                   	nop
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 04             	sub    $0x4,%esp
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801701:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801704:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	6a 00                	push   $0x0
  80170d:	51                   	push   %ecx
  80170e:	52                   	push   %edx
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	6a 18                	push   $0x18
  801715:	e8 2e fd ff ff       	call   801448 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801722:	8b 55 0c             	mov    0xc(%ebp),%edx
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	52                   	push   %edx
  80172f:	50                   	push   %eax
  801730:	6a 19                	push   $0x19
  801732:	e8 11 fd ff ff       	call   801448 <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	50                   	push   %eax
  80174b:	6a 1a                	push   $0x1a
  80174d:	e8 f6 fc ff ff       	call   801448 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 1b                	push   $0x1b
  801766:	e8 dd fc ff ff       	call   801448 <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 1c                	push   $0x1c
  80177f:	e8 c4 fc ff ff       	call   801448 <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	50                   	push   %eax
  801799:	6a 1d                	push   $0x1d
  80179b:	e8 a8 fc ff ff       	call   801448 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	50                   	push   %eax
  8017b4:	6a 1e                	push   $0x1e
  8017b6:	e8 8d fc ff ff       	call   801448 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	90                   	nop
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	50                   	push   %eax
  8017d0:	6a 1f                	push   $0x1f
  8017d2:	e8 71 fc ff ff       	call   801448 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	90                   	nop
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e6:	8d 50 04             	lea    0x4(%eax),%edx
  8017e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	52                   	push   %edx
  8017f3:	50                   	push   %eax
  8017f4:	6a 20                	push   $0x20
  8017f6:	e8 4d fc ff ff       	call   801448 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
	return result;
  8017fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801801:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801804:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801807:	89 01                	mov    %eax,(%ecx)
  801809:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	c9                   	leave  
  801810:	c2 04 00             	ret    $0x4

00801813 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	ff 75 10             	pushl  0x10(%ebp)
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	6a 0f                	push   $0xf
  801825:	e8 1e fc ff ff       	call   801448 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
	return ;
  80182d:	90                   	nop
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_rcr2>:
uint32 sys_rcr2()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 21                	push   $0x21
  80183f:	e8 04 fc ff ff       	call   801448 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801855:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	50                   	push   %eax
  801862:	6a 22                	push   $0x22
  801864:	e8 df fb ff ff       	call   801448 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
	return ;
  80186c:	90                   	nop
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <rsttst>:
void rsttst()
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 24                	push   $0x24
  80187e:	e8 c5 fb ff ff       	call   801448 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
	return ;
  801886:	90                   	nop
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	8b 45 14             	mov    0x14(%ebp),%eax
  801892:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801895:	8b 55 18             	mov    0x18(%ebp),%edx
  801898:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	ff 75 10             	pushl  0x10(%ebp)
  8018a1:	ff 75 0c             	pushl  0xc(%ebp)
  8018a4:	ff 75 08             	pushl  0x8(%ebp)
  8018a7:	6a 23                	push   $0x23
  8018a9:	e8 9a fb ff ff       	call   801448 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b1:	90                   	nop
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <chktst>:
void chktst(uint32 n)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	ff 75 08             	pushl  0x8(%ebp)
  8018c2:	6a 25                	push   $0x25
  8018c4:	e8 7f fb ff ff       	call   801448 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018cc:	90                   	nop
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 26                	push   $0x26
  8018e1:	e8 62 fb ff ff       	call   801448 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
  8018e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018ec:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018f0:	75 07                	jne    8018f9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f7:	eb 05                	jmp    8018fe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 26                	push   $0x26
  801912:	e8 31 fb ff ff       	call   801448 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
  80191a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80191d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801921:	75 07                	jne    80192a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801923:	b8 01 00 00 00       	mov    $0x1,%eax
  801928:	eb 05                	jmp    80192f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80192a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 26                	push   $0x26
  801943:	e8 00 fb ff ff       	call   801448 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
  80194b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80194e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801952:	75 07                	jne    80195b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801954:	b8 01 00 00 00       	mov    $0x1,%eax
  801959:	eb 05                	jmp    801960 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80195b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 26                	push   $0x26
  801974:	e8 cf fa ff ff       	call   801448 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
  80197c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80197f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801983:	75 07                	jne    80198c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801985:	b8 01 00 00 00       	mov    $0x1,%eax
  80198a:	eb 05                	jmp    801991 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80198c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	ff 75 08             	pushl  0x8(%ebp)
  8019a1:	6a 27                	push   $0x27
  8019a3:	e8 a0 fa ff ff       	call   801448 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ab:	90                   	nop
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    
  8019ae:	66 90                	xchg   %ax,%ax

008019b0 <__udivdi3>:
  8019b0:	55                   	push   %ebp
  8019b1:	57                   	push   %edi
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 1c             	sub    $0x1c,%esp
  8019b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019c7:	89 ca                	mov    %ecx,%edx
  8019c9:	89 f8                	mov    %edi,%eax
  8019cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019cf:	85 f6                	test   %esi,%esi
  8019d1:	75 2d                	jne    801a00 <__udivdi3+0x50>
  8019d3:	39 cf                	cmp    %ecx,%edi
  8019d5:	77 65                	ja     801a3c <__udivdi3+0x8c>
  8019d7:	89 fd                	mov    %edi,%ebp
  8019d9:	85 ff                	test   %edi,%edi
  8019db:	75 0b                	jne    8019e8 <__udivdi3+0x38>
  8019dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e2:	31 d2                	xor    %edx,%edx
  8019e4:	f7 f7                	div    %edi
  8019e6:	89 c5                	mov    %eax,%ebp
  8019e8:	31 d2                	xor    %edx,%edx
  8019ea:	89 c8                	mov    %ecx,%eax
  8019ec:	f7 f5                	div    %ebp
  8019ee:	89 c1                	mov    %eax,%ecx
  8019f0:	89 d8                	mov    %ebx,%eax
  8019f2:	f7 f5                	div    %ebp
  8019f4:	89 cf                	mov    %ecx,%edi
  8019f6:	89 fa                	mov    %edi,%edx
  8019f8:	83 c4 1c             	add    $0x1c,%esp
  8019fb:	5b                   	pop    %ebx
  8019fc:	5e                   	pop    %esi
  8019fd:	5f                   	pop    %edi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    
  801a00:	39 ce                	cmp    %ecx,%esi
  801a02:	77 28                	ja     801a2c <__udivdi3+0x7c>
  801a04:	0f bd fe             	bsr    %esi,%edi
  801a07:	83 f7 1f             	xor    $0x1f,%edi
  801a0a:	75 40                	jne    801a4c <__udivdi3+0x9c>
  801a0c:	39 ce                	cmp    %ecx,%esi
  801a0e:	72 0a                	jb     801a1a <__udivdi3+0x6a>
  801a10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a14:	0f 87 9e 00 00 00    	ja     801ab8 <__udivdi3+0x108>
  801a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1f:	89 fa                	mov    %edi,%edx
  801a21:	83 c4 1c             	add    $0x1c,%esp
  801a24:	5b                   	pop    %ebx
  801a25:	5e                   	pop    %esi
  801a26:	5f                   	pop    %edi
  801a27:	5d                   	pop    %ebp
  801a28:	c3                   	ret    
  801a29:	8d 76 00             	lea    0x0(%esi),%esi
  801a2c:	31 ff                	xor    %edi,%edi
  801a2e:	31 c0                	xor    %eax,%eax
  801a30:	89 fa                	mov    %edi,%edx
  801a32:	83 c4 1c             	add    $0x1c,%esp
  801a35:	5b                   	pop    %ebx
  801a36:	5e                   	pop    %esi
  801a37:	5f                   	pop    %edi
  801a38:	5d                   	pop    %ebp
  801a39:	c3                   	ret    
  801a3a:	66 90                	xchg   %ax,%ax
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	f7 f7                	div    %edi
  801a40:	31 ff                	xor    %edi,%edi
  801a42:	89 fa                	mov    %edi,%edx
  801a44:	83 c4 1c             	add    $0x1c,%esp
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5f                   	pop    %edi
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    
  801a4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a51:	89 eb                	mov    %ebp,%ebx
  801a53:	29 fb                	sub    %edi,%ebx
  801a55:	89 f9                	mov    %edi,%ecx
  801a57:	d3 e6                	shl    %cl,%esi
  801a59:	89 c5                	mov    %eax,%ebp
  801a5b:	88 d9                	mov    %bl,%cl
  801a5d:	d3 ed                	shr    %cl,%ebp
  801a5f:	89 e9                	mov    %ebp,%ecx
  801a61:	09 f1                	or     %esi,%ecx
  801a63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a67:	89 f9                	mov    %edi,%ecx
  801a69:	d3 e0                	shl    %cl,%eax
  801a6b:	89 c5                	mov    %eax,%ebp
  801a6d:	89 d6                	mov    %edx,%esi
  801a6f:	88 d9                	mov    %bl,%cl
  801a71:	d3 ee                	shr    %cl,%esi
  801a73:	89 f9                	mov    %edi,%ecx
  801a75:	d3 e2                	shl    %cl,%edx
  801a77:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a7b:	88 d9                	mov    %bl,%cl
  801a7d:	d3 e8                	shr    %cl,%eax
  801a7f:	09 c2                	or     %eax,%edx
  801a81:	89 d0                	mov    %edx,%eax
  801a83:	89 f2                	mov    %esi,%edx
  801a85:	f7 74 24 0c          	divl   0xc(%esp)
  801a89:	89 d6                	mov    %edx,%esi
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	f7 e5                	mul    %ebp
  801a8f:	39 d6                	cmp    %edx,%esi
  801a91:	72 19                	jb     801aac <__udivdi3+0xfc>
  801a93:	74 0b                	je     801aa0 <__udivdi3+0xf0>
  801a95:	89 d8                	mov    %ebx,%eax
  801a97:	31 ff                	xor    %edi,%edi
  801a99:	e9 58 ff ff ff       	jmp    8019f6 <__udivdi3+0x46>
  801a9e:	66 90                	xchg   %ax,%ax
  801aa0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801aa4:	89 f9                	mov    %edi,%ecx
  801aa6:	d3 e2                	shl    %cl,%edx
  801aa8:	39 c2                	cmp    %eax,%edx
  801aaa:	73 e9                	jae    801a95 <__udivdi3+0xe5>
  801aac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801aaf:	31 ff                	xor    %edi,%edi
  801ab1:	e9 40 ff ff ff       	jmp    8019f6 <__udivdi3+0x46>
  801ab6:	66 90                	xchg   %ax,%ax
  801ab8:	31 c0                	xor    %eax,%eax
  801aba:	e9 37 ff ff ff       	jmp    8019f6 <__udivdi3+0x46>
  801abf:	90                   	nop

00801ac0 <__umoddi3>:
  801ac0:	55                   	push   %ebp
  801ac1:	57                   	push   %edi
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 1c             	sub    $0x1c,%esp
  801ac7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801acb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801acf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ad3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ad7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801adb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801adf:	89 f3                	mov    %esi,%ebx
  801ae1:	89 fa                	mov    %edi,%edx
  801ae3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ae7:	89 34 24             	mov    %esi,(%esp)
  801aea:	85 c0                	test   %eax,%eax
  801aec:	75 1a                	jne    801b08 <__umoddi3+0x48>
  801aee:	39 f7                	cmp    %esi,%edi
  801af0:	0f 86 a2 00 00 00    	jbe    801b98 <__umoddi3+0xd8>
  801af6:	89 c8                	mov    %ecx,%eax
  801af8:	89 f2                	mov    %esi,%edx
  801afa:	f7 f7                	div    %edi
  801afc:	89 d0                	mov    %edx,%eax
  801afe:	31 d2                	xor    %edx,%edx
  801b00:	83 c4 1c             	add    $0x1c,%esp
  801b03:	5b                   	pop    %ebx
  801b04:	5e                   	pop    %esi
  801b05:	5f                   	pop    %edi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    
  801b08:	39 f0                	cmp    %esi,%eax
  801b0a:	0f 87 ac 00 00 00    	ja     801bbc <__umoddi3+0xfc>
  801b10:	0f bd e8             	bsr    %eax,%ebp
  801b13:	83 f5 1f             	xor    $0x1f,%ebp
  801b16:	0f 84 ac 00 00 00    	je     801bc8 <__umoddi3+0x108>
  801b1c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b21:	29 ef                	sub    %ebp,%edi
  801b23:	89 fe                	mov    %edi,%esi
  801b25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b29:	89 e9                	mov    %ebp,%ecx
  801b2b:	d3 e0                	shl    %cl,%eax
  801b2d:	89 d7                	mov    %edx,%edi
  801b2f:	89 f1                	mov    %esi,%ecx
  801b31:	d3 ef                	shr    %cl,%edi
  801b33:	09 c7                	or     %eax,%edi
  801b35:	89 e9                	mov    %ebp,%ecx
  801b37:	d3 e2                	shl    %cl,%edx
  801b39:	89 14 24             	mov    %edx,(%esp)
  801b3c:	89 d8                	mov    %ebx,%eax
  801b3e:	d3 e0                	shl    %cl,%eax
  801b40:	89 c2                	mov    %eax,%edx
  801b42:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b46:	d3 e0                	shl    %cl,%eax
  801b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b50:	89 f1                	mov    %esi,%ecx
  801b52:	d3 e8                	shr    %cl,%eax
  801b54:	09 d0                	or     %edx,%eax
  801b56:	d3 eb                	shr    %cl,%ebx
  801b58:	89 da                	mov    %ebx,%edx
  801b5a:	f7 f7                	div    %edi
  801b5c:	89 d3                	mov    %edx,%ebx
  801b5e:	f7 24 24             	mull   (%esp)
  801b61:	89 c6                	mov    %eax,%esi
  801b63:	89 d1                	mov    %edx,%ecx
  801b65:	39 d3                	cmp    %edx,%ebx
  801b67:	0f 82 87 00 00 00    	jb     801bf4 <__umoddi3+0x134>
  801b6d:	0f 84 91 00 00 00    	je     801c04 <__umoddi3+0x144>
  801b73:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b77:	29 f2                	sub    %esi,%edx
  801b79:	19 cb                	sbb    %ecx,%ebx
  801b7b:	89 d8                	mov    %ebx,%eax
  801b7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b81:	d3 e0                	shl    %cl,%eax
  801b83:	89 e9                	mov    %ebp,%ecx
  801b85:	d3 ea                	shr    %cl,%edx
  801b87:	09 d0                	or     %edx,%eax
  801b89:	89 e9                	mov    %ebp,%ecx
  801b8b:	d3 eb                	shr    %cl,%ebx
  801b8d:	89 da                	mov    %ebx,%edx
  801b8f:	83 c4 1c             	add    $0x1c,%esp
  801b92:	5b                   	pop    %ebx
  801b93:	5e                   	pop    %esi
  801b94:	5f                   	pop    %edi
  801b95:	5d                   	pop    %ebp
  801b96:	c3                   	ret    
  801b97:	90                   	nop
  801b98:	89 fd                	mov    %edi,%ebp
  801b9a:	85 ff                	test   %edi,%edi
  801b9c:	75 0b                	jne    801ba9 <__umoddi3+0xe9>
  801b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba3:	31 d2                	xor    %edx,%edx
  801ba5:	f7 f7                	div    %edi
  801ba7:	89 c5                	mov    %eax,%ebp
  801ba9:	89 f0                	mov    %esi,%eax
  801bab:	31 d2                	xor    %edx,%edx
  801bad:	f7 f5                	div    %ebp
  801baf:	89 c8                	mov    %ecx,%eax
  801bb1:	f7 f5                	div    %ebp
  801bb3:	89 d0                	mov    %edx,%eax
  801bb5:	e9 44 ff ff ff       	jmp    801afe <__umoddi3+0x3e>
  801bba:	66 90                	xchg   %ax,%ax
  801bbc:	89 c8                	mov    %ecx,%eax
  801bbe:	89 f2                	mov    %esi,%edx
  801bc0:	83 c4 1c             	add    $0x1c,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5f                   	pop    %edi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
  801bc8:	3b 04 24             	cmp    (%esp),%eax
  801bcb:	72 06                	jb     801bd3 <__umoddi3+0x113>
  801bcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bd1:	77 0f                	ja     801be2 <__umoddi3+0x122>
  801bd3:	89 f2                	mov    %esi,%edx
  801bd5:	29 f9                	sub    %edi,%ecx
  801bd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bdb:	89 14 24             	mov    %edx,(%esp)
  801bde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801be2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801be6:	8b 14 24             	mov    (%esp),%edx
  801be9:	83 c4 1c             	add    $0x1c,%esp
  801bec:	5b                   	pop    %ebx
  801bed:	5e                   	pop    %esi
  801bee:	5f                   	pop    %edi
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    
  801bf1:	8d 76 00             	lea    0x0(%esi),%esi
  801bf4:	2b 04 24             	sub    (%esp),%eax
  801bf7:	19 fa                	sbb    %edi,%edx
  801bf9:	89 d1                	mov    %edx,%ecx
  801bfb:	89 c6                	mov    %eax,%esi
  801bfd:	e9 71 ff ff ff       	jmp    801b73 <__umoddi3+0xb3>
  801c02:	66 90                	xchg   %ax,%ax
  801c04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c08:	72 ea                	jb     801bf4 <__umoddi3+0x134>
  801c0a:	89 d9                	mov    %ebx,%ecx
  801c0c:	e9 62 ff ff ff       	jmp    801b73 <__umoddi3+0xb3>
