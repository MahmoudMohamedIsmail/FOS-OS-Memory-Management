
obj/user/tst_page_replacement_FIFO_1:     file format elf32-i386


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
  800031:	e8 93 04 00 00       	call   8004c9 <libmain>
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
  80003e:	e8 71 14 00 00       	call   8014b4 <sys_getenvid>
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
  800094:	e8 f1 04 00 00       	call   80058a <_panic>
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
  8000c8:	e8 bd 04 00 00       	call   80058a <_panic>
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
  8000fc:	e8 89 04 00 00       	call   80058a <_panic>
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
  800130:	e8 55 04 00 00       	call   80058a <_panic>
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
  800164:	e8 21 04 00 00       	call   80058a <_panic>
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
  800198:	e8 ed 03 00 00       	call   80058a <_panic>
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
  8001cc:	e8 b9 03 00 00       	call   80058a <_panic>
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
  800200:	e8 85 03 00 00       	call   80058a <_panic>
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
  800234:	e8 51 03 00 00       	call   80058a <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  800242:	85 c0                	test   %eax,%eax
  800244:	74 14                	je     80025a <_main+0x222>
  800246:	83 ec 04             	sub    $0x4,%esp
  800249:	68 88 1c 80 00       	push   $0x801c88
  80024e:	6a 1e                	push   $0x1e
  800250:	68 64 1c 80 00       	push   $0x801c64
  800255:	e8 30 03 00 00       	call   80058a <_panic>
	}


	int freePages = sys_calculate_free_frames();
  80025a:	e8 07 13 00 00       	call   801566 <sys_calculate_free_frames>
  80025f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800262:	e8 82 13 00 00       	call   8015e9 <sys_pf_calculate_allocated_pages>
  800267:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1];
  80026a:	a0 1f e0 80 00       	mov    0x80e01f,%al
  80026f:	88 45 bf             	mov    %al,-0x41(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
  800272:	a0 1f f0 80 00       	mov    0x80f01f,%al
  800277:	88 45 be             	mov    %al,-0x42(%ebp)

	//Writing (Modified)
	int i;
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
	char garbage1 = arr[PAGE_SIZE*11-1];
	char garbage2 = arr[PAGE_SIZE*12-1];

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002b3:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8002ba:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8002c1:	7e c0                	jle    800283 <_main+0x24b>
	}

	//===================
	//cprintf("Checking PAGE FIFO algorithm... \n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8002c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c6:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8002d1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002d9:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 d0 1c 80 00       	push   $0x801cd0
  8002e8:	6a 35                	push   $0x35
  8002ea:	68 64 1c 80 00       	push   $0x801c64
  8002ef:	e8 96 02 00 00       	call   80058a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8002f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f7:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8002fd:	83 c0 0c             	add    $0xc,%eax
  800300:	8b 00                	mov    (%eax),%eax
  800302:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800305:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800308:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80030d:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 d0 1c 80 00       	push   $0x801cd0
  80031c:	6a 36                	push   $0x36
  80031e:	68 64 1c 80 00       	push   $0x801c64
  800323:	e8 62 02 00 00       	call   80058a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x809000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800331:	83 c0 18             	add    $0x18,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800339:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80033c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800341:	3d 00 90 80 00       	cmp    $0x809000,%eax
  800346:	74 14                	je     80035c <_main+0x324>
  800348:	83 ec 04             	sub    $0x4,%esp
  80034b:	68 d0 1c 80 00       	push   $0x801cd0
  800350:	6a 37                	push   $0x37
  800352:	68 64 1c 80 00       	push   $0x801c64
  800357:	e8 2e 02 00 00       	call   80058a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80035c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80035f:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800365:	83 c0 24             	add    $0x24,%eax
  800368:	8b 00                	mov    (%eax),%eax
  80036a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80036d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800370:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800375:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80037a:	74 14                	je     800390 <_main+0x358>
  80037c:	83 ec 04             	sub    $0x4,%esp
  80037f:	68 d0 1c 80 00       	push   $0x801cd0
  800384:	6a 38                	push   $0x38
  800386:	68 64 1c 80 00       	push   $0x801c64
  80038b:	e8 fa 01 00 00       	call   80058a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800390:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800393:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800399:	83 c0 30             	add    $0x30,%eax
  80039c:	8b 00                	mov    (%eax),%eax
  80039e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8003a1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a9:	3d 00 40 80 00       	cmp    $0x804000,%eax
  8003ae:	74 14                	je     8003c4 <_main+0x38c>
  8003b0:	83 ec 04             	sub    $0x4,%esp
  8003b3:	68 d0 1c 80 00       	push   $0x801cd0
  8003b8:	6a 39                	push   $0x39
  8003ba:	68 64 1c 80 00       	push   $0x801c64
  8003bf:	e8 c6 01 00 00       	call   80058a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8003c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c7:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8003cd:	83 c0 3c             	add    $0x3c,%eax
  8003d0:	8b 00                	mov    (%eax),%eax
  8003d2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8003d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003dd:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  8003e2:	74 14                	je     8003f8 <_main+0x3c0>
  8003e4:	83 ec 04             	sub    $0x4,%esp
  8003e7:	68 d0 1c 80 00       	push   $0x801cd0
  8003ec:	6a 3a                	push   $0x3a
  8003ee:	68 64 1c 80 00       	push   $0x801c64
  8003f3:	e8 92 01 00 00       	call   80058a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x80b000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8003f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003fb:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800401:	83 c0 48             	add    $0x48,%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800409:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80040c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800411:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 d0 1c 80 00       	push   $0x801cd0
  800420:	6a 3b                	push   $0x3b
  800422:	68 64 1c 80 00       	push   $0x801c64
  800427:	e8 5e 01 00 00       	call   80058a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x80c000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80042c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80042f:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800435:	83 c0 54             	add    $0x54,%eax
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80043d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800440:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800445:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 d0 1c 80 00       	push   $0x801cd0
  800454:	6a 3c                	push   $0x3c
  800456:	68 64 1c 80 00       	push   $0x801c64
  80045b:	e8 2a 01 00 00       	call   80058a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800463:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800469:	83 c0 60             	add    $0x60,%eax
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	89 45 98             	mov    %eax,-0x68(%ebp)
  800471:	8b 45 98             	mov    -0x68(%ebp),%eax
  800474:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800479:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 d0 1c 80 00       	push   $0x801cd0
  800488:	6a 3d                	push   $0x3d
  80048a:	68 64 1c 80 00       	push   $0x801c64
  80048f:	e8 f6 00 00 00       	call   80058a <_panic>

		if(myEnv->page_last_WS_index != 2) panic("wrong PAGE WS pointer location");
  800494:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800497:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  80049d:	83 f8 02             	cmp    $0x2,%eax
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 1c 1d 80 00       	push   $0x801d1c
  8004aa:	6a 3f                	push   $0x3f
  8004ac:	68 64 1c 80 00       	push   $0x801c64
  8004b1:	e8 d4 00 00 00       	call   80058a <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [FIFO Alg.] is completed successfully.\n");
  8004b6:	83 ec 0c             	sub    $0xc,%esp
  8004b9:	68 3c 1d 80 00       	push   $0x801d3c
  8004be:	e8 f2 01 00 00       	call   8006b5 <cprintf>
  8004c3:	83 c4 10             	add    $0x10,%esp
	return;
  8004c6:	90                   	nop
}
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004d3:	7e 0a                	jle    8004df <libmain+0x16>
		binaryname = argv[0];
  8004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	ff 75 0c             	pushl  0xc(%ebp)
  8004e5:	ff 75 08             	pushl  0x8(%ebp)
  8004e8:	e8 4b fb ff ff       	call   800038 <_main>
  8004ed:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8004f0:	e8 bf 0f 00 00       	call   8014b4 <sys_getenvid>
  8004f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8004f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004fb:	89 d0                	mov    %edx,%eax
  8004fd:	c1 e0 03             	shl    $0x3,%eax
  800500:	01 d0                	add    %edx,%eax
  800502:	01 c0                	add    %eax,%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050d:	01 d0                	add    %edx,%eax
  80050f:	c1 e0 03             	shl    $0x3,%eax
  800512:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800517:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  80051a:	e8 e3 10 00 00       	call   801602 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	68 a4 1d 80 00       	push   $0x801da4
  800527:	e8 89 01 00 00       	call   8006b5 <cprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80052f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800532:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	50                   	push   %eax
  80053c:	68 cc 1d 80 00       	push   $0x801dcc
  800541:	e8 6f 01 00 00       	call   8006b5 <cprintf>
  800546:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	68 a4 1d 80 00       	push   $0x801da4
  800551:	e8 5f 01 00 00       	call   8006b5 <cprintf>
  800556:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800559:	e8 be 10 00 00       	call   80161c <sys_enable_interrupt>

	// exit gracefully
	exit();
  80055e:	e8 19 00 00 00       	call   80057c <exit>
}
  800563:	90                   	nop
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80056c:	83 ec 0c             	sub    $0xc,%esp
  80056f:	6a 00                	push   $0x0
  800571:	e8 23 0f 00 00       	call   801499 <sys_env_destroy>
  800576:	83 c4 10             	add    $0x10,%esp
}
  800579:	90                   	nop
  80057a:	c9                   	leave  
  80057b:	c3                   	ret    

0080057c <exit>:

void
exit(void)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800582:	e8 46 0f 00 00       	call   8014cd <sys_env_exit>
}
  800587:	90                   	nop
  800588:	c9                   	leave  
  800589:	c3                   	ret    

0080058a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
  80058d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800590:	8d 45 10             	lea    0x10(%ebp),%eax
  800593:	83 c0 04             	add    $0x4,%eax
  800596:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800599:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  80059e:	85 c0                	test   %eax,%eax
  8005a0:	74 16                	je     8005b8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005a2:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	50                   	push   %eax
  8005ab:	68 e5 1d 80 00       	push   $0x801de5
  8005b0:	e8 00 01 00 00       	call   8006b5 <cprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005b8:	a1 08 30 80 00       	mov    0x803008,%eax
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	50                   	push   %eax
  8005c4:	68 ea 1d 80 00       	push   $0x801dea
  8005c9:	e8 e7 00 00 00       	call   8006b5 <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005da:	50                   	push   %eax
  8005db:	e8 7a 00 00 00       	call   80065a <vcprintf>
  8005e0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	68 06 1e 80 00       	push   $0x801e06
  8005eb:	e8 c5 00 00 00       	call   8006b5 <cprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005f3:	e8 84 ff ff ff       	call   80057c <exit>

	// should not return here
	while (1) ;
  8005f8:	eb fe                	jmp    8005f8 <_panic+0x6e>

008005fa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800600:	8b 45 0c             	mov    0xc(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 48 01             	lea    0x1(%eax),%ecx
  800608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060b:	89 0a                	mov    %ecx,(%edx)
  80060d:	8b 55 08             	mov    0x8(%ebp),%edx
  800610:	88 d1                	mov    %dl,%cl
  800612:	8b 55 0c             	mov    0xc(%ebp),%edx
  800615:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800623:	75 23                	jne    800648 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800625:	8b 45 0c             	mov    0xc(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	89 c2                	mov    %eax,%edx
  80062c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062f:	83 c0 08             	add    $0x8,%eax
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	52                   	push   %edx
  800636:	50                   	push   %eax
  800637:	e8 27 0e 00 00       	call   801463 <sys_cputs>
  80063c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80063f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800642:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064b:	8b 40 04             	mov    0x4(%eax),%eax
  80064e:	8d 50 01             	lea    0x1(%eax),%edx
  800651:	8b 45 0c             	mov    0xc(%ebp),%eax
  800654:	89 50 04             	mov    %edx,0x4(%eax)
}
  800657:	90                   	nop
  800658:	c9                   	leave  
  800659:	c3                   	ret    

0080065a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80065a:	55                   	push   %ebp
  80065b:	89 e5                	mov    %esp,%ebp
  80065d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800663:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80066a:	00 00 00 
	b.cnt = 0;
  80066d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800674:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	ff 75 08             	pushl  0x8(%ebp)
  80067d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800683:	50                   	push   %eax
  800684:	68 fa 05 80 00       	push   $0x8005fa
  800689:	e8 fa 01 00 00       	call   800888 <vprintfmt>
  80068e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800691:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	50                   	push   %eax
  80069b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a1:	83 c0 08             	add    $0x8,%eax
  8006a4:	50                   	push   %eax
  8006a5:	e8 b9 0d 00 00       	call   801463 <sys_cputs>
  8006aa:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8006ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006b3:	c9                   	leave  
  8006b4:	c3                   	ret    

008006b5 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006b5:	55                   	push   %ebp
  8006b6:	89 e5                	mov    %esp,%ebp
  8006b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	50                   	push   %eax
  8006cb:	e8 8a ff ff ff       	call   80065a <vcprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d9:	c9                   	leave  
  8006da:	c3                   	ret    

008006db <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e1:	e8 1c 0f 00 00       	call   801602 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f5:	50                   	push   %eax
  8006f6:	e8 5f ff ff ff       	call   80065a <vcprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800701:	e8 16 0f 00 00       	call   80161c <sys_enable_interrupt>
	return cnt;
  800706:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800709:	c9                   	leave  
  80070a:	c3                   	ret    

0080070b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	53                   	push   %ebx
  80070f:	83 ec 14             	sub    $0x14,%esp
  800712:	8b 45 10             	mov    0x10(%ebp),%eax
  800715:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80071e:	8b 45 18             	mov    0x18(%ebp),%eax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800729:	77 55                	ja     800780 <printnum+0x75>
  80072b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072e:	72 05                	jb     800735 <printnum+0x2a>
  800730:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800733:	77 4b                	ja     800780 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800735:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800738:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073b:	8b 45 18             	mov    0x18(%ebp),%eax
  80073e:	ba 00 00 00 00       	mov    $0x0,%edx
  800743:	52                   	push   %edx
  800744:	50                   	push   %eax
  800745:	ff 75 f4             	pushl  -0xc(%ebp)
  800748:	ff 75 f0             	pushl  -0x10(%ebp)
  80074b:	e8 50 12 00 00       	call   8019a0 <__udivdi3>
  800750:	83 c4 10             	add    $0x10,%esp
  800753:	83 ec 04             	sub    $0x4,%esp
  800756:	ff 75 20             	pushl  0x20(%ebp)
  800759:	53                   	push   %ebx
  80075a:	ff 75 18             	pushl  0x18(%ebp)
  80075d:	52                   	push   %edx
  80075e:	50                   	push   %eax
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	ff 75 08             	pushl  0x8(%ebp)
  800765:	e8 a1 ff ff ff       	call   80070b <printnum>
  80076a:	83 c4 20             	add    $0x20,%esp
  80076d:	eb 1a                	jmp    800789 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	ff 75 0c             	pushl  0xc(%ebp)
  800775:	ff 75 20             	pushl  0x20(%ebp)
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800780:	ff 4d 1c             	decl   0x1c(%ebp)
  800783:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800787:	7f e6                	jg     80076f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800789:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800794:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800797:	53                   	push   %ebx
  800798:	51                   	push   %ecx
  800799:	52                   	push   %edx
  80079a:	50                   	push   %eax
  80079b:	e8 10 13 00 00       	call   801ab0 <__umoddi3>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	05 34 20 80 00       	add    $0x802034,%eax
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f be c0             	movsbl %al,%eax
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	50                   	push   %eax
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	ff d0                	call   *%eax
  8007b9:	83 c4 10             	add    $0x10,%esp
}
  8007bc:	90                   	nop
  8007bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c9:	7e 1c                	jle    8007e7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	8d 50 08             	lea    0x8(%eax),%edx
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	89 10                	mov    %edx,(%eax)
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	83 e8 08             	sub    $0x8,%eax
  8007e0:	8b 50 04             	mov    0x4(%eax),%edx
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	eb 40                	jmp    800827 <getuint+0x65>
	else if (lflag)
  8007e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007eb:	74 1e                	je     80080b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	8d 50 04             	lea    0x4(%eax),%edx
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	89 10                	mov    %edx,(%eax)
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	83 e8 04             	sub    $0x4,%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
  800809:	eb 1c                	jmp    800827 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	8d 50 04             	lea    0x4(%eax),%edx
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	89 10                	mov    %edx,(%eax)
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800827:	5d                   	pop    %ebp
  800828:	c3                   	ret    

00800829 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800830:	7e 1c                	jle    80084e <getint+0x25>
		return va_arg(*ap, long long);
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	8d 50 08             	lea    0x8(%eax),%edx
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	89 10                	mov    %edx,(%eax)
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	8b 00                	mov    (%eax),%eax
  800844:	83 e8 08             	sub    $0x8,%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	eb 38                	jmp    800886 <getint+0x5d>
	else if (lflag)
  80084e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800852:	74 1a                	je     80086e <getint+0x45>
		return va_arg(*ap, long);
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	8d 50 04             	lea    0x4(%eax),%edx
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	89 10                	mov    %edx,(%eax)
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	83 e8 04             	sub    $0x4,%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	99                   	cltd   
  80086c:	eb 18                	jmp    800886 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	8d 50 04             	lea    0x4(%eax),%edx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	89 10                	mov    %edx,(%eax)
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	83 e8 04             	sub    $0x4,%eax
  800883:	8b 00                	mov    (%eax),%eax
  800885:	99                   	cltd   
}
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	56                   	push   %esi
  80088c:	53                   	push   %ebx
  80088d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800890:	eb 17                	jmp    8008a9 <vprintfmt+0x21>
			if (ch == '\0')
  800892:	85 db                	test   %ebx,%ebx
  800894:	0f 84 af 03 00 00    	je     800c49 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	53                   	push   %ebx
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	ff d0                	call   *%eax
  8008a6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ac:	8d 50 01             	lea    0x1(%eax),%edx
  8008af:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b2:	8a 00                	mov    (%eax),%al
  8008b4:	0f b6 d8             	movzbl %al,%ebx
  8008b7:	83 fb 25             	cmp    $0x25,%ebx
  8008ba:	75 d6                	jne    800892 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008bc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008df:	8d 50 01             	lea    0x1(%eax),%edx
  8008e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e5:	8a 00                	mov    (%eax),%al
  8008e7:	0f b6 d8             	movzbl %al,%ebx
  8008ea:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ed:	83 f8 55             	cmp    $0x55,%eax
  8008f0:	0f 87 2b 03 00 00    	ja     800c21 <vprintfmt+0x399>
  8008f6:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  8008fd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008ff:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800903:	eb d7                	jmp    8008dc <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800905:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800909:	eb d1                	jmp    8008dc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800912:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800915:	89 d0                	mov    %edx,%eax
  800917:	c1 e0 02             	shl    $0x2,%eax
  80091a:	01 d0                	add    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d8                	add    %ebx,%eax
  800920:	83 e8 30             	sub    $0x30,%eax
  800923:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800926:	8b 45 10             	mov    0x10(%ebp),%eax
  800929:	8a 00                	mov    (%eax),%al
  80092b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80092e:	83 fb 2f             	cmp    $0x2f,%ebx
  800931:	7e 3e                	jle    800971 <vprintfmt+0xe9>
  800933:	83 fb 39             	cmp    $0x39,%ebx
  800936:	7f 39                	jg     800971 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800938:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093b:	eb d5                	jmp    800912 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	83 c0 04             	add    $0x4,%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	83 e8 04             	sub    $0x4,%eax
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800951:	eb 1f                	jmp    800972 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800953:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800957:	79 83                	jns    8008dc <vprintfmt+0x54>
				width = 0;
  800959:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800960:	e9 77 ff ff ff       	jmp    8008dc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800965:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096c:	e9 6b ff ff ff       	jmp    8008dc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800971:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800972:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800976:	0f 89 60 ff ff ff    	jns    8008dc <vprintfmt+0x54>
				width = precision, precision = -1;
  80097c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80097f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800982:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800989:	e9 4e ff ff ff       	jmp    8008dc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80098e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800991:	e9 46 ff ff ff       	jmp    8008dc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800996:	8b 45 14             	mov    0x14(%ebp),%eax
  800999:	83 c0 04             	add    $0x4,%eax
  80099c:	89 45 14             	mov    %eax,0x14(%ebp)
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	83 e8 04             	sub    $0x4,%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	50                   	push   %eax
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	ff d0                	call   *%eax
  8009b3:	83 c4 10             	add    $0x10,%esp
			break;
  8009b6:	e9 89 02 00 00       	jmp    800c44 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	83 c0 04             	add    $0x4,%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	83 e8 04             	sub    $0x4,%eax
  8009ca:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009cc:	85 db                	test   %ebx,%ebx
  8009ce:	79 02                	jns    8009d2 <vprintfmt+0x14a>
				err = -err;
  8009d0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d2:	83 fb 64             	cmp    $0x64,%ebx
  8009d5:	7f 0b                	jg     8009e2 <vprintfmt+0x15a>
  8009d7:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  8009de:	85 f6                	test   %esi,%esi
  8009e0:	75 19                	jne    8009fb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e2:	53                   	push   %ebx
  8009e3:	68 45 20 80 00       	push   $0x802045
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 5e 02 00 00       	call   800c51 <printfmt>
  8009f3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f6:	e9 49 02 00 00       	jmp    800c44 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fb:	56                   	push   %esi
  8009fc:	68 4e 20 80 00       	push   $0x80204e
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	e8 45 02 00 00       	call   800c51 <printfmt>
  800a0c:	83 c4 10             	add    $0x10,%esp
			break;
  800a0f:	e9 30 02 00 00       	jmp    800c44 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	83 c0 04             	add    $0x4,%eax
  800a1a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	83 e8 04             	sub    $0x4,%eax
  800a23:	8b 30                	mov    (%eax),%esi
  800a25:	85 f6                	test   %esi,%esi
  800a27:	75 05                	jne    800a2e <vprintfmt+0x1a6>
				p = "(null)";
  800a29:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  800a2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a32:	7e 6d                	jle    800aa1 <vprintfmt+0x219>
  800a34:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a38:	74 67                	je     800aa1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	50                   	push   %eax
  800a41:	56                   	push   %esi
  800a42:	e8 0c 03 00 00       	call   800d53 <strnlen>
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4d:	eb 16                	jmp    800a65 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a4f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	50                   	push   %eax
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a62:	ff 4d e4             	decl   -0x1c(%ebp)
  800a65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a69:	7f e4                	jg     800a4f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6b:	eb 34                	jmp    800aa1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a71:	74 1c                	je     800a8f <vprintfmt+0x207>
  800a73:	83 fb 1f             	cmp    $0x1f,%ebx
  800a76:	7e 05                	jle    800a7d <vprintfmt+0x1f5>
  800a78:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7b:	7e 12                	jle    800a8f <vprintfmt+0x207>
					putch('?', putdat);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	6a 3f                	push   $0x3f
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	ff d0                	call   *%eax
  800a8a:	83 c4 10             	add    $0x10,%esp
  800a8d:	eb 0f                	jmp    800a9e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a9e:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa1:	89 f0                	mov    %esi,%eax
  800aa3:	8d 70 01             	lea    0x1(%eax),%esi
  800aa6:	8a 00                	mov    (%eax),%al
  800aa8:	0f be d8             	movsbl %al,%ebx
  800aab:	85 db                	test   %ebx,%ebx
  800aad:	74 24                	je     800ad3 <vprintfmt+0x24b>
  800aaf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab3:	78 b8                	js     800a6d <vprintfmt+0x1e5>
  800ab5:	ff 4d e0             	decl   -0x20(%ebp)
  800ab8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abc:	79 af                	jns    800a6d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800abe:	eb 13                	jmp    800ad3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	6a 20                	push   $0x20
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad7:	7f e7                	jg     800ac0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad9:	e9 66 01 00 00       	jmp    800c44 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae7:	50                   	push   %eax
  800ae8:	e8 3c fd ff ff       	call   800829 <getint>
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afc:	85 d2                	test   %edx,%edx
  800afe:	79 23                	jns    800b23 <vprintfmt+0x29b>
				putch('-', putdat);
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	6a 2d                	push   $0x2d
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	ff d0                	call   *%eax
  800b0d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b16:	f7 d8                	neg    %eax
  800b18:	83 d2 00             	adc    $0x0,%edx
  800b1b:	f7 da                	neg    %edx
  800b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2a:	e9 bc 00 00 00       	jmp    800beb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 e8             	pushl  -0x18(%ebp)
  800b35:	8d 45 14             	lea    0x14(%ebp),%eax
  800b38:	50                   	push   %eax
  800b39:	e8 84 fc ff ff       	call   8007c2 <getuint>
  800b3e:	83 c4 10             	add    $0x10,%esp
  800b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b4e:	e9 98 00 00 00       	jmp    800beb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	6a 58                	push   $0x58
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
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
			break;
  800b83:	e9 bc 00 00 00       	jmp    800c44 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	6a 30                	push   $0x30
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	ff d0                	call   *%eax
  800b95:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 78                	push   $0x78
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bab:	83 c0 04             	add    $0x4,%eax
  800bae:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb4:	83 e8 04             	sub    $0x4,%eax
  800bb7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bca:	eb 1f                	jmp    800beb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd5:	50                   	push   %eax
  800bd6:	e8 e7 fb ff ff       	call   8007c2 <getuint>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800beb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf2:	83 ec 04             	sub    $0x4,%esp
  800bf5:	52                   	push   %edx
  800bf6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf9:	50                   	push   %eax
  800bfa:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfd:	ff 75 f0             	pushl  -0x10(%ebp)
  800c00:	ff 75 0c             	pushl  0xc(%ebp)
  800c03:	ff 75 08             	pushl  0x8(%ebp)
  800c06:	e8 00 fb ff ff       	call   80070b <printnum>
  800c0b:	83 c4 20             	add    $0x20,%esp
			break;
  800c0e:	eb 34                	jmp    800c44 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	53                   	push   %ebx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	ff d0                	call   *%eax
  800c1c:	83 c4 10             	add    $0x10,%esp
			break;
  800c1f:	eb 23                	jmp    800c44 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c21:	83 ec 08             	sub    $0x8,%esp
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	6a 25                	push   $0x25
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	ff d0                	call   *%eax
  800c2e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c31:	ff 4d 10             	decl   0x10(%ebp)
  800c34:	eb 03                	jmp    800c39 <vprintfmt+0x3b1>
  800c36:	ff 4d 10             	decl   0x10(%ebp)
  800c39:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3c:	48                   	dec    %eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	3c 25                	cmp    $0x25,%al
  800c41:	75 f3                	jne    800c36 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c43:	90                   	nop
		}
	}
  800c44:	e9 47 fc ff ff       	jmp    800890 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c49:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c57:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5a:	83 c0 04             	add    $0x4,%eax
  800c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c60:	8b 45 10             	mov    0x10(%ebp),%eax
  800c63:	ff 75 f4             	pushl  -0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	ff 75 08             	pushl  0x8(%ebp)
  800c6d:	e8 16 fc ff ff       	call   800888 <vprintfmt>
  800c72:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c75:	90                   	nop
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	8b 40 08             	mov    0x8(%eax),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8b 10                	mov    (%eax),%edx
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8b 40 04             	mov    0x4(%eax),%eax
  800c95:	39 c2                	cmp    %eax,%edx
  800c97:	73 12                	jae    800cab <sprintputch+0x33>
		*b->buf++ = ch;
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	8b 00                	mov    (%eax),%eax
  800c9e:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	89 0a                	mov    %ecx,(%edx)
  800ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca9:	88 10                	mov    %dl,(%eax)
}
  800cab:	90                   	nop
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    

00800cae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	01 d0                	add    %edx,%eax
  800cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ccf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd3:	74 06                	je     800cdb <vsnprintf+0x2d>
  800cd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd9:	7f 07                	jg     800ce2 <vsnprintf+0x34>
		return -E_INVAL;
  800cdb:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce0:	eb 20                	jmp    800d02 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce2:	ff 75 14             	pushl  0x14(%ebp)
  800ce5:	ff 75 10             	pushl  0x10(%ebp)
  800ce8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ceb:	50                   	push   %eax
  800cec:	68 78 0c 80 00       	push   $0x800c78
  800cf1:	e8 92 fb ff ff       	call   800888 <vprintfmt>
  800cf6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0d:	83 c0 04             	add    $0x4,%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d13:	8b 45 10             	mov    0x10(%ebp),%eax
  800d16:	ff 75 f4             	pushl  -0xc(%ebp)
  800d19:	50                   	push   %eax
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 89 ff ff ff       	call   800cae <vsnprintf>
  800d25:	83 c4 10             	add    $0x10,%esp
  800d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3d:	eb 06                	jmp    800d45 <strlen+0x15>
		n++;
  800d3f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d42:	ff 45 08             	incl   0x8(%ebp)
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	84 c0                	test   %al,%al
  800d4c:	75 f1                	jne    800d3f <strlen+0xf>
		n++;
	return n;
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d60:	eb 09                	jmp    800d6b <strnlen+0x18>
		n++;
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d65:	ff 45 08             	incl   0x8(%ebp)
  800d68:	ff 4d 0c             	decl   0xc(%ebp)
  800d6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6f:	74 09                	je     800d7a <strnlen+0x27>
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	84 c0                	test   %al,%al
  800d78:	75 e8                	jne    800d62 <strnlen+0xf>
		n++;
	return n;
  800d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d8b:	90                   	nop
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8d 50 01             	lea    0x1(%eax),%edx
  800d92:	89 55 08             	mov    %edx,0x8(%ebp)
  800d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d9e:	8a 12                	mov    (%edx),%dl
  800da0:	88 10                	mov    %dl,(%eax)
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	84 c0                	test   %al,%al
  800da6:	75 e4                	jne    800d8c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc0:	eb 1f                	jmp    800de1 <strncpy+0x34>
		*dst++ = *src;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8d 50 01             	lea    0x1(%eax),%edx
  800dc8:	89 55 08             	mov    %edx,0x8(%ebp)
  800dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dce:	8a 12                	mov    (%edx),%dl
  800dd0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	84 c0                	test   %al,%al
  800dd9:	74 03                	je     800dde <strncpy+0x31>
			src++;
  800ddb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dde:	ff 45 fc             	incl   -0x4(%ebp)
  800de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de7:	72 d9                	jb     800dc2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dec:	c9                   	leave  
  800ded:	c3                   	ret    

00800dee <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfe:	74 30                	je     800e30 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e00:	eb 16                	jmp    800e18 <strlcpy+0x2a>
			*dst++ = *src++;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8d 50 01             	lea    0x1(%eax),%edx
  800e08:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e11:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e14:	8a 12                	mov    (%edx),%dl
  800e16:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e18:	ff 4d 10             	decl   0x10(%ebp)
  800e1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1f:	74 09                	je     800e2a <strlcpy+0x3c>
  800e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 d8                	jne    800e02 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e36:	29 c2                	sub    %eax,%edx
  800e38:	89 d0                	mov    %edx,%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e3f:	eb 06                	jmp    800e47 <strcmp+0xb>
		p++, q++;
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	84 c0                	test   %al,%al
  800e4e:	74 0e                	je     800e5e <strcmp+0x22>
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 10                	mov    (%eax),%dl
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	38 c2                	cmp    %al,%dl
  800e5c:	74 e3                	je     800e41 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	0f b6 d0             	movzbl %al,%edx
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	0f b6 c0             	movzbl %al,%eax
  800e6e:	29 c2                	sub    %eax,%edx
  800e70:	89 d0                	mov    %edx,%eax
}
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e77:	eb 09                	jmp    800e82 <strncmp+0xe>
		n--, p++, q++;
  800e79:	ff 4d 10             	decl   0x10(%ebp)
  800e7c:	ff 45 08             	incl   0x8(%ebp)
  800e7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e86:	74 17                	je     800e9f <strncmp+0x2b>
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	84 c0                	test   %al,%al
  800e8f:	74 0e                	je     800e9f <strncmp+0x2b>
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 10                	mov    (%eax),%dl
  800e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	38 c2                	cmp    %al,%dl
  800e9d:	74 da                	je     800e79 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea3:	75 07                	jne    800eac <strncmp+0x38>
		return 0;
  800ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eaa:	eb 14                	jmp    800ec0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	0f b6 d0             	movzbl %al,%edx
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	0f b6 c0             	movzbl %al,%eax
  800ebc:	29 c2                	sub    %eax,%edx
  800ebe:	89 d0                	mov    %edx,%eax
}
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    

00800ec2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 04             	sub    $0x4,%esp
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ece:	eb 12                	jmp    800ee2 <strchr+0x20>
		if (*s == c)
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed8:	75 05                	jne    800edf <strchr+0x1d>
			return (char *) s;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	eb 11                	jmp    800ef0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 e5                	jne    800ed0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 04             	sub    $0x4,%esp
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800efe:	eb 0d                	jmp    800f0d <strfind+0x1b>
		if (*s == c)
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f08:	74 0e                	je     800f18 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f0a:	ff 45 08             	incl   0x8(%ebp)
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	84 c0                	test   %al,%al
  800f14:	75 ea                	jne    800f00 <strfind+0xe>
  800f16:	eb 01                	jmp    800f19 <strfind+0x27>
		if (*s == c)
			break;
  800f18:	90                   	nop
	return (char *) s;
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1c:	c9                   	leave  
  800f1d:	c3                   	ret    

00800f1e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f30:	eb 0e                	jmp    800f40 <memset+0x22>
		*p++ = c;
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	8d 50 01             	lea    0x1(%eax),%edx
  800f38:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f40:	ff 4d f8             	decl   -0x8(%ebp)
  800f43:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f47:	79 e9                	jns    800f32 <memset+0x14>
		*p++ = c;

	return v;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f60:	eb 16                	jmp    800f78 <memcpy+0x2a>
		*d++ = *s++;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 dd                	jne    800f62 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa2:	73 50                	jae    800ff4 <memmove+0x6a>
  800fa4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800faf:	76 43                	jbe    800ff4 <memmove+0x6a>
		s += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fba:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbd:	eb 10                	jmp    800fcf <memmove+0x45>
			*--d = *--s;
  800fbf:	ff 4d f8             	decl   -0x8(%ebp)
  800fc2:	ff 4d fc             	decl   -0x4(%ebp)
  800fc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc8:	8a 10                	mov    (%eax),%dl
  800fca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	75 e3                	jne    800fbf <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fdc:	eb 23                	jmp    801001 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe1:	8d 50 01             	lea    0x1(%eax),%edx
  800fe4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fed:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff0:	8a 12                	mov    (%edx),%dl
  800ff2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	75 dd                	jne    800fde <memmove+0x54>
			*d++ = *s++;

	return dst;
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801018:	eb 2a                	jmp    801044 <memcmp+0x3e>
		if (*s1 != *s2)
  80101a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101d:	8a 10                	mov    (%eax),%dl
  80101f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	38 c2                	cmp    %al,%dl
  801026:	74 16                	je     80103e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801028:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	0f b6 d0             	movzbl %al,%edx
  801030:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	0f b6 c0             	movzbl %al,%eax
  801038:	29 c2                	sub    %eax,%edx
  80103a:	89 d0                	mov    %edx,%eax
  80103c:	eb 18                	jmp    801056 <memcmp+0x50>
		s1++, s2++;
  80103e:	ff 45 fc             	incl   -0x4(%ebp)
  801041:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801044:	8b 45 10             	mov    0x10(%ebp),%eax
  801047:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104a:	89 55 10             	mov    %edx,0x10(%ebp)
  80104d:	85 c0                	test   %eax,%eax
  80104f:	75 c9                	jne    80101a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801051:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80105e:	8b 55 08             	mov    0x8(%ebp),%edx
  801061:	8b 45 10             	mov    0x10(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801069:	eb 15                	jmp    801080 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f b6 d0             	movzbl %al,%edx
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	0f b6 c0             	movzbl %al,%eax
  801079:	39 c2                	cmp    %eax,%edx
  80107b:	74 0d                	je     80108a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80107d:	ff 45 08             	incl   0x8(%ebp)
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801086:	72 e3                	jb     80106b <memfind+0x13>
  801088:	eb 01                	jmp    80108b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108a:	90                   	nop
	return (void *) s;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80109d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a4:	eb 03                	jmp    8010a9 <strtol+0x19>
		s++;
  8010a6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 20                	cmp    $0x20,%al
  8010b0:	74 f4                	je     8010a6 <strtol+0x16>
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	3c 09                	cmp    $0x9,%al
  8010b9:	74 eb                	je     8010a6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 2b                	cmp    $0x2b,%al
  8010c2:	75 05                	jne    8010c9 <strtol+0x39>
		s++;
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	eb 13                	jmp    8010dc <strtol+0x4c>
	else if (*s == '-')
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 2d                	cmp    $0x2d,%al
  8010d0:	75 0a                	jne    8010dc <strtol+0x4c>
		s++, neg = 1;
  8010d2:	ff 45 08             	incl   0x8(%ebp)
  8010d5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e0:	74 06                	je     8010e8 <strtol+0x58>
  8010e2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e6:	75 20                	jne    801108 <strtol+0x78>
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 30                	cmp    $0x30,%al
  8010ef:	75 17                	jne    801108 <strtol+0x78>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	40                   	inc    %eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 78                	cmp    $0x78,%al
  8010f9:	75 0d                	jne    801108 <strtol+0x78>
		s += 2, base = 16;
  8010fb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010ff:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801106:	eb 28                	jmp    801130 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801108:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110c:	75 15                	jne    801123 <strtol+0x93>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 30                	cmp    $0x30,%al
  801115:	75 0c                	jne    801123 <strtol+0x93>
		s++, base = 8;
  801117:	ff 45 08             	incl   0x8(%ebp)
  80111a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801121:	eb 0d                	jmp    801130 <strtol+0xa0>
	else if (base == 0)
  801123:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801127:	75 07                	jne    801130 <strtol+0xa0>
		base = 10;
  801129:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 2f                	cmp    $0x2f,%al
  801137:	7e 19                	jle    801152 <strtol+0xc2>
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	3c 39                	cmp    $0x39,%al
  801140:	7f 10                	jg     801152 <strtol+0xc2>
			dig = *s - '0';
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	0f be c0             	movsbl %al,%eax
  80114a:	83 e8 30             	sub    $0x30,%eax
  80114d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801150:	eb 42                	jmp    801194 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 60                	cmp    $0x60,%al
  801159:	7e 19                	jle    801174 <strtol+0xe4>
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	3c 7a                	cmp    $0x7a,%al
  801162:	7f 10                	jg     801174 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	0f be c0             	movsbl %al,%eax
  80116c:	83 e8 57             	sub    $0x57,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801172:	eb 20                	jmp    801194 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	3c 40                	cmp    $0x40,%al
  80117b:	7e 39                	jle    8011b6 <strtol+0x126>
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	3c 5a                	cmp    $0x5a,%al
  801184:	7f 30                	jg     8011b6 <strtol+0x126>
			dig = *s - 'A' + 10;
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	0f be c0             	movsbl %al,%eax
  80118e:	83 e8 37             	sub    $0x37,%eax
  801191:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801197:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119a:	7d 19                	jge    8011b5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80119c:	ff 45 08             	incl   0x8(%ebp)
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a6:	89 c2                	mov    %eax,%edx
  8011a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ab:	01 d0                	add    %edx,%eax
  8011ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b0:	e9 7b ff ff ff       	jmp    801130 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ba:	74 08                	je     8011c4 <strtol+0x134>
		*endptr = (char *) s;
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c8:	74 07                	je     8011d1 <strtol+0x141>
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	f7 d8                	neg    %eax
  8011cf:	eb 03                	jmp    8011d4 <strtol+0x144>
  8011d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ee:	79 13                	jns    801203 <ltostr+0x2d>
	{
		neg = 1;
  8011f0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011fd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801200:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80120b:	99                   	cltd   
  80120c:	f7 f9                	idiv   %ecx
  80120e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121a:	89 c2                	mov    %eax,%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801224:	83 c2 30             	add    $0x30,%edx
  801227:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801229:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801231:	f7 e9                	imul   %ecx
  801233:	c1 fa 02             	sar    $0x2,%edx
  801236:	89 c8                	mov    %ecx,%eax
  801238:	c1 f8 1f             	sar    $0x1f,%eax
  80123b:	29 c2                	sub    %eax,%edx
  80123d:	89 d0                	mov    %edx,%eax
  80123f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801242:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801245:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124a:	f7 e9                	imul   %ecx
  80124c:	c1 fa 02             	sar    $0x2,%edx
  80124f:	89 c8                	mov    %ecx,%eax
  801251:	c1 f8 1f             	sar    $0x1f,%eax
  801254:	29 c2                	sub    %eax,%edx
  801256:	89 d0                	mov    %edx,%eax
  801258:	c1 e0 02             	shl    $0x2,%eax
  80125b:	01 d0                	add    %edx,%eax
  80125d:	01 c0                	add    %eax,%eax
  80125f:	29 c1                	sub    %eax,%ecx
  801261:	89 ca                	mov    %ecx,%edx
  801263:	85 d2                	test   %edx,%edx
  801265:	75 9c                	jne    801203 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80126e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801271:	48                   	dec    %eax
  801272:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801275:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801279:	74 3d                	je     8012b8 <ltostr+0xe2>
		start = 1 ;
  80127b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801282:	eb 34                	jmp    8012b8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801284:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801294:	8b 45 0c             	mov    0xc(%ebp),%eax
  801297:	01 c2                	add    %eax,%edx
  801299:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	01 c8                	add    %ecx,%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	01 c2                	add    %eax,%edx
  8012ad:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b0:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012be:	7c c4                	jl     801284 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c6:	01 d0                	add    %edx,%eax
  8012c8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cb:	90                   	nop
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d4:	ff 75 08             	pushl  0x8(%ebp)
  8012d7:	e8 54 fa ff ff       	call   800d30 <strlen>
  8012dc:	83 c4 04             	add    $0x4,%esp
  8012df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 46 fa ff ff       	call   800d30 <strlen>
  8012ea:	83 c4 04             	add    $0x4,%esp
  8012ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fe:	eb 17                	jmp    801317 <strcconcat+0x49>
		final[s] = str1[s] ;
  801300:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 c2                	add    %eax,%edx
  801308:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	01 c8                	add    %ecx,%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801314:	ff 45 fc             	incl   -0x4(%ebp)
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131d:	7c e1                	jl     801300 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80131f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801326:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132d:	eb 1f                	jmp    80134e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80132f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801332:	8d 50 01             	lea    0x1(%eax),%edx
  801335:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	01 c2                	add    %eax,%edx
  80133f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	01 c8                	add    %ecx,%eax
  801347:	8a 00                	mov    (%eax),%al
  801349:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134b:	ff 45 f8             	incl   -0x8(%ebp)
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801354:	7c d9                	jl     80132f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801356:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801359:	8b 45 10             	mov    0x10(%ebp),%eax
  80135c:	01 d0                	add    %edx,%eax
  80135e:	c6 00 00             	movb   $0x0,(%eax)
}
  801361:	90                   	nop
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801367:	8b 45 14             	mov    0x14(%ebp),%eax
  80136a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801370:	8b 45 14             	mov    0x14(%ebp),%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137c:	8b 45 10             	mov    0x10(%ebp),%eax
  80137f:	01 d0                	add    %edx,%eax
  801381:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801387:	eb 0c                	jmp    801395 <strsplit+0x31>
			*string++ = 0;
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8d 50 01             	lea    0x1(%eax),%edx
  80138f:	89 55 08             	mov    %edx,0x8(%ebp)
  801392:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	84 c0                	test   %al,%al
  80139c:	74 18                	je     8013b6 <strsplit+0x52>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	0f be c0             	movsbl %al,%eax
  8013a6:	50                   	push   %eax
  8013a7:	ff 75 0c             	pushl  0xc(%ebp)
  8013aa:	e8 13 fb ff ff       	call   800ec2 <strchr>
  8013af:	83 c4 08             	add    $0x8,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	75 d3                	jne    801389 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8a 00                	mov    (%eax),%al
  8013bb:	84 c0                	test   %al,%al
  8013bd:	74 5a                	je     801419 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8013bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c2:	8b 00                	mov    (%eax),%eax
  8013c4:	83 f8 0f             	cmp    $0xf,%eax
  8013c7:	75 07                	jne    8013d0 <strsplit+0x6c>
		{
			return 0;
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ce:	eb 66                	jmp    801436 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d8:	8b 55 14             	mov    0x14(%ebp),%edx
  8013db:	89 0a                	mov    %ecx,(%edx)
  8013dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ee:	eb 03                	jmp    8013f3 <strsplit+0x8f>
			string++;
  8013f0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	84 c0                	test   %al,%al
  8013fa:	74 8b                	je     801387 <strsplit+0x23>
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	0f be c0             	movsbl %al,%eax
  801404:	50                   	push   %eax
  801405:	ff 75 0c             	pushl  0xc(%ebp)
  801408:	e8 b5 fa ff ff       	call   800ec2 <strchr>
  80140d:	83 c4 08             	add    $0x8,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	74 dc                	je     8013f0 <strsplit+0x8c>
			string++;
	}
  801414:	e9 6e ff ff ff       	jmp    801387 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801419:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141a:	8b 45 14             	mov    0x14(%ebp),%eax
  80141d:	8b 00                	mov    (%eax),%eax
  80141f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801426:	8b 45 10             	mov    0x10(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801431:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	57                   	push   %edi
  80143c:	56                   	push   %esi
  80143d:	53                   	push   %ebx
  80143e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8b 55 0c             	mov    0xc(%ebp),%edx
  801447:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80144d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801450:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801453:	cd 30                	int    $0x30
  801455:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801458:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	5b                   	pop    %ebx
  80145f:	5e                   	pop    %esi
  801460:	5f                   	pop    %edi
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    

00801463 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	ff 75 0c             	pushl  0xc(%ebp)
  801472:	50                   	push   %eax
  801473:	6a 00                	push   $0x0
  801475:	e8 be ff ff ff       	call   801438 <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
}
  80147d:	90                   	nop
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <sys_cgetc>:

int
sys_cgetc(void)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 01                	push   $0x1
  80148f:	e8 a4 ff ff ff       	call   801438 <syscall>
  801494:	83 c4 18             	add    $0x18,%esp
}
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	50                   	push   %eax
  8014a8:	6a 03                	push   $0x3
  8014aa:	e8 89 ff ff ff       	call   801438 <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 02                	push   $0x2
  8014c3:	e8 70 ff ff ff       	call   801438 <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <sys_env_exit>:

void sys_env_exit(void)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 04                	push   $0x4
  8014dc:	e8 57 ff ff ff       	call   801438 <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
}
  8014e4:	90                   	nop
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	52                   	push   %edx
  8014f7:	50                   	push   %eax
  8014f8:	6a 05                	push   $0x5
  8014fa:	e8 39 ff ff ff       	call   801438 <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801509:	8b 75 18             	mov    0x18(%ebp),%esi
  80150c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80150f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801512:	8b 55 0c             	mov    0xc(%ebp),%edx
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	56                   	push   %esi
  801519:	53                   	push   %ebx
  80151a:	51                   	push   %ecx
  80151b:	52                   	push   %edx
  80151c:	50                   	push   %eax
  80151d:	6a 06                	push   $0x6
  80151f:	e8 14 ff ff ff       	call   801438 <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
}
  801527:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80152a:	5b                   	pop    %ebx
  80152b:	5e                   	pop    %esi
  80152c:	5d                   	pop    %ebp
  80152d:	c3                   	ret    

0080152e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801531:	8b 55 0c             	mov    0xc(%ebp),%edx
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	52                   	push   %edx
  80153e:	50                   	push   %eax
  80153f:	6a 07                	push   $0x7
  801541:	e8 f2 fe ff ff       	call   801438 <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	ff 75 08             	pushl  0x8(%ebp)
  80155a:	6a 08                	push   $0x8
  80155c:	e8 d7 fe ff ff       	call   801438 <syscall>
  801561:	83 c4 18             	add    $0x18,%esp
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 09                	push   $0x9
  801575:	e8 be fe ff ff       	call   801438 <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 0a                	push   $0xa
  80158e:	e8 a5 fe ff ff       	call   801438 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 0b                	push   $0xb
  8015a7:	e8 8c fe ff ff       	call   801438 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	ff 75 08             	pushl  0x8(%ebp)
  8015c0:	6a 0d                	push   $0xd
  8015c2:	e8 71 fe ff ff       	call   801438 <syscall>
  8015c7:	83 c4 18             	add    $0x18,%esp
	return;
  8015ca:	90                   	nop
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	ff 75 0c             	pushl  0xc(%ebp)
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	6a 0e                	push   $0xe
  8015de:	e8 55 fe ff ff       	call   801438 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e6:	90                   	nop
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 0c                	push   $0xc
  8015f8:	e8 3b fe ff ff       	call   801438 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 10                	push   $0x10
  801611:	e8 22 fe ff ff       	call   801438 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	90                   	nop
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 11                	push   $0x11
  80162b:	e8 08 fe ff ff       	call   801438 <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	90                   	nop
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_cputc>:


void
sys_cputc(const char c)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801642:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	50                   	push   %eax
  80164f:	6a 12                	push   $0x12
  801651:	e8 e2 fd ff ff       	call   801438 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	90                   	nop
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 13                	push   $0x13
  80166b:	e8 c8 fd ff ff       	call   801438 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	90                   	nop
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	50                   	push   %eax
  801686:	6a 14                	push   $0x14
  801688:	e8 ab fd ff ff       	call   801438 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	50                   	push   %eax
  8016a1:	6a 17                	push   $0x17
  8016a3:	e8 90 fd ff ff       	call   801438 <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	50                   	push   %eax
  8016bc:	6a 15                	push   $0x15
  8016be:	e8 75 fd ff ff       	call   801438 <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
}
  8016c6:	90                   	nop
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	50                   	push   %eax
  8016d8:	6a 16                	push   $0x16
  8016da:	e8 59 fd ff ff       	call   801438 <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	90                   	nop
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8016f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	51                   	push   %ecx
  8016fe:	52                   	push   %edx
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	50                   	push   %eax
  801703:	6a 18                	push   $0x18
  801705:	e8 2e fd ff ff       	call   801438 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801712:	8b 55 0c             	mov    0xc(%ebp),%edx
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	52                   	push   %edx
  80171f:	50                   	push   %eax
  801720:	6a 19                	push   $0x19
  801722:	e8 11 fd ff ff       	call   801438 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	50                   	push   %eax
  80173b:	6a 1a                	push   $0x1a
  80173d:	e8 f6 fc ff ff       	call   801438 <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 1b                	push   $0x1b
  801756:	e8 dd fc ff ff       	call   801438 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 1c                	push   $0x1c
  80176f:	e8 c4 fc ff ff       	call   801438 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	50                   	push   %eax
  801789:	6a 1d                	push   $0x1d
  80178b:	e8 a8 fc ff ff       	call   801438 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	50                   	push   %eax
  8017a4:	6a 1e                	push   $0x1e
  8017a6:	e8 8d fc ff ff       	call   801438 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	90                   	nop
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	50                   	push   %eax
  8017c0:	6a 1f                	push   $0x1f
  8017c2:	e8 71 fc ff ff       	call   801438 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	90                   	nop
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017d6:	8d 50 04             	lea    0x4(%eax),%edx
  8017d9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	52                   	push   %edx
  8017e3:	50                   	push   %eax
  8017e4:	6a 20                	push   $0x20
  8017e6:	e8 4d fc ff ff       	call   801438 <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
	return result;
  8017ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f7:	89 01                	mov    %eax,(%ecx)
  8017f9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	c9                   	leave  
  801800:	c2 04 00             	ret    $0x4

00801803 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	ff 75 10             	pushl  0x10(%ebp)
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	6a 0f                	push   $0xf
  801815:	e8 1e fc ff ff       	call   801438 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
	return ;
  80181d:	90                   	nop
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_rcr2>:
uint32 sys_rcr2()
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 21                	push   $0x21
  80182f:	e8 04 fc ff ff       	call   801438 <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 04             	sub    $0x4,%esp
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801845:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	50                   	push   %eax
  801852:	6a 22                	push   $0x22
  801854:	e8 df fb ff ff       	call   801438 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
	return ;
  80185c:	90                   	nop
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <rsttst>:
void rsttst()
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 24                	push   $0x24
  80186e:	e8 c5 fb ff ff       	call   801438 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
	return ;
  801876:	90                   	nop
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	8b 45 14             	mov    0x14(%ebp),%eax
  801882:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801885:	8b 55 18             	mov    0x18(%ebp),%edx
  801888:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80188c:	52                   	push   %edx
  80188d:	50                   	push   %eax
  80188e:	ff 75 10             	pushl  0x10(%ebp)
  801891:	ff 75 0c             	pushl  0xc(%ebp)
  801894:	ff 75 08             	pushl  0x8(%ebp)
  801897:	6a 23                	push   $0x23
  801899:	e8 9a fb ff ff       	call   801438 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a1:	90                   	nop
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <chktst>:
void chktst(uint32 n)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	6a 25                	push   $0x25
  8018b4:	e8 7f fb ff ff       	call   801438 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bc:	90                   	nop
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 26                	push   $0x26
  8018d1:	e8 62 fb ff ff       	call   801438 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
  8018d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018dc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018e0:	75 07                	jne    8018e9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e7:	eb 05                	jmp    8018ee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 26                	push   $0x26
  801902:	e8 31 fb ff ff       	call   801438 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
  80190a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80190d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801911:	75 07                	jne    80191a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801913:	b8 01 00 00 00       	mov    $0x1,%eax
  801918:	eb 05                	jmp    80191f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80191a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 26                	push   $0x26
  801933:	e8 00 fb ff ff       	call   801438 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
  80193b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80193e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801942:	75 07                	jne    80194b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801944:	b8 01 00 00 00       	mov    $0x1,%eax
  801949:	eb 05                	jmp    801950 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80194b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 26                	push   $0x26
  801964:	e8 cf fa ff ff       	call   801438 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
  80196c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80196f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801973:	75 07                	jne    80197c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801975:	b8 01 00 00 00       	mov    $0x1,%eax
  80197a:	eb 05                	jmp    801981 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 08             	pushl  0x8(%ebp)
  801991:	6a 27                	push   $0x27
  801993:	e8 a0 fa ff ff       	call   801438 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
	return ;
  80199b:	90                   	nop
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    
  80199e:	66 90                	xchg   %ax,%ax

008019a0 <__udivdi3>:
  8019a0:	55                   	push   %ebp
  8019a1:	57                   	push   %edi
  8019a2:	56                   	push   %esi
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 1c             	sub    $0x1c,%esp
  8019a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019b7:	89 ca                	mov    %ecx,%edx
  8019b9:	89 f8                	mov    %edi,%eax
  8019bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019bf:	85 f6                	test   %esi,%esi
  8019c1:	75 2d                	jne    8019f0 <__udivdi3+0x50>
  8019c3:	39 cf                	cmp    %ecx,%edi
  8019c5:	77 65                	ja     801a2c <__udivdi3+0x8c>
  8019c7:	89 fd                	mov    %edi,%ebp
  8019c9:	85 ff                	test   %edi,%edi
  8019cb:	75 0b                	jne    8019d8 <__udivdi3+0x38>
  8019cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d2:	31 d2                	xor    %edx,%edx
  8019d4:	f7 f7                	div    %edi
  8019d6:	89 c5                	mov    %eax,%ebp
  8019d8:	31 d2                	xor    %edx,%edx
  8019da:	89 c8                	mov    %ecx,%eax
  8019dc:	f7 f5                	div    %ebp
  8019de:	89 c1                	mov    %eax,%ecx
  8019e0:	89 d8                	mov    %ebx,%eax
  8019e2:	f7 f5                	div    %ebp
  8019e4:	89 cf                	mov    %ecx,%edi
  8019e6:	89 fa                	mov    %edi,%edx
  8019e8:	83 c4 1c             	add    $0x1c,%esp
  8019eb:	5b                   	pop    %ebx
  8019ec:	5e                   	pop    %esi
  8019ed:	5f                   	pop    %edi
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    
  8019f0:	39 ce                	cmp    %ecx,%esi
  8019f2:	77 28                	ja     801a1c <__udivdi3+0x7c>
  8019f4:	0f bd fe             	bsr    %esi,%edi
  8019f7:	83 f7 1f             	xor    $0x1f,%edi
  8019fa:	75 40                	jne    801a3c <__udivdi3+0x9c>
  8019fc:	39 ce                	cmp    %ecx,%esi
  8019fe:	72 0a                	jb     801a0a <__udivdi3+0x6a>
  801a00:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a04:	0f 87 9e 00 00 00    	ja     801aa8 <__udivdi3+0x108>
  801a0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0f:	89 fa                	mov    %edi,%edx
  801a11:	83 c4 1c             	add    $0x1c,%esp
  801a14:	5b                   	pop    %ebx
  801a15:	5e                   	pop    %esi
  801a16:	5f                   	pop    %edi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    
  801a19:	8d 76 00             	lea    0x0(%esi),%esi
  801a1c:	31 ff                	xor    %edi,%edi
  801a1e:	31 c0                	xor    %eax,%eax
  801a20:	89 fa                	mov    %edi,%edx
  801a22:	83 c4 1c             	add    $0x1c,%esp
  801a25:	5b                   	pop    %ebx
  801a26:	5e                   	pop    %esi
  801a27:	5f                   	pop    %edi
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    
  801a2a:	66 90                	xchg   %ax,%ax
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	f7 f7                	div    %edi
  801a30:	31 ff                	xor    %edi,%edi
  801a32:	89 fa                	mov    %edi,%edx
  801a34:	83 c4 1c             	add    $0x1c,%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5f                   	pop    %edi
  801a3a:	5d                   	pop    %ebp
  801a3b:	c3                   	ret    
  801a3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a41:	89 eb                	mov    %ebp,%ebx
  801a43:	29 fb                	sub    %edi,%ebx
  801a45:	89 f9                	mov    %edi,%ecx
  801a47:	d3 e6                	shl    %cl,%esi
  801a49:	89 c5                	mov    %eax,%ebp
  801a4b:	88 d9                	mov    %bl,%cl
  801a4d:	d3 ed                	shr    %cl,%ebp
  801a4f:	89 e9                	mov    %ebp,%ecx
  801a51:	09 f1                	or     %esi,%ecx
  801a53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a57:	89 f9                	mov    %edi,%ecx
  801a59:	d3 e0                	shl    %cl,%eax
  801a5b:	89 c5                	mov    %eax,%ebp
  801a5d:	89 d6                	mov    %edx,%esi
  801a5f:	88 d9                	mov    %bl,%cl
  801a61:	d3 ee                	shr    %cl,%esi
  801a63:	89 f9                	mov    %edi,%ecx
  801a65:	d3 e2                	shl    %cl,%edx
  801a67:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a6b:	88 d9                	mov    %bl,%cl
  801a6d:	d3 e8                	shr    %cl,%eax
  801a6f:	09 c2                	or     %eax,%edx
  801a71:	89 d0                	mov    %edx,%eax
  801a73:	89 f2                	mov    %esi,%edx
  801a75:	f7 74 24 0c          	divl   0xc(%esp)
  801a79:	89 d6                	mov    %edx,%esi
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	f7 e5                	mul    %ebp
  801a7f:	39 d6                	cmp    %edx,%esi
  801a81:	72 19                	jb     801a9c <__udivdi3+0xfc>
  801a83:	74 0b                	je     801a90 <__udivdi3+0xf0>
  801a85:	89 d8                	mov    %ebx,%eax
  801a87:	31 ff                	xor    %edi,%edi
  801a89:	e9 58 ff ff ff       	jmp    8019e6 <__udivdi3+0x46>
  801a8e:	66 90                	xchg   %ax,%ax
  801a90:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a94:	89 f9                	mov    %edi,%ecx
  801a96:	d3 e2                	shl    %cl,%edx
  801a98:	39 c2                	cmp    %eax,%edx
  801a9a:	73 e9                	jae    801a85 <__udivdi3+0xe5>
  801a9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a9f:	31 ff                	xor    %edi,%edi
  801aa1:	e9 40 ff ff ff       	jmp    8019e6 <__udivdi3+0x46>
  801aa6:	66 90                	xchg   %ax,%ax
  801aa8:	31 c0                	xor    %eax,%eax
  801aaa:	e9 37 ff ff ff       	jmp    8019e6 <__udivdi3+0x46>
  801aaf:	90                   	nop

00801ab0 <__umoddi3>:
  801ab0:	55                   	push   %ebp
  801ab1:	57                   	push   %edi
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 1c             	sub    $0x1c,%esp
  801ab7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801abb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801abf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ac3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ac7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801acb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801acf:	89 f3                	mov    %esi,%ebx
  801ad1:	89 fa                	mov    %edi,%edx
  801ad3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad7:	89 34 24             	mov    %esi,(%esp)
  801ada:	85 c0                	test   %eax,%eax
  801adc:	75 1a                	jne    801af8 <__umoddi3+0x48>
  801ade:	39 f7                	cmp    %esi,%edi
  801ae0:	0f 86 a2 00 00 00    	jbe    801b88 <__umoddi3+0xd8>
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	89 f2                	mov    %esi,%edx
  801aea:	f7 f7                	div    %edi
  801aec:	89 d0                	mov    %edx,%eax
  801aee:	31 d2                	xor    %edx,%edx
  801af0:	83 c4 1c             	add    $0x1c,%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5f                   	pop    %edi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    
  801af8:	39 f0                	cmp    %esi,%eax
  801afa:	0f 87 ac 00 00 00    	ja     801bac <__umoddi3+0xfc>
  801b00:	0f bd e8             	bsr    %eax,%ebp
  801b03:	83 f5 1f             	xor    $0x1f,%ebp
  801b06:	0f 84 ac 00 00 00    	je     801bb8 <__umoddi3+0x108>
  801b0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b11:	29 ef                	sub    %ebp,%edi
  801b13:	89 fe                	mov    %edi,%esi
  801b15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b19:	89 e9                	mov    %ebp,%ecx
  801b1b:	d3 e0                	shl    %cl,%eax
  801b1d:	89 d7                	mov    %edx,%edi
  801b1f:	89 f1                	mov    %esi,%ecx
  801b21:	d3 ef                	shr    %cl,%edi
  801b23:	09 c7                	or     %eax,%edi
  801b25:	89 e9                	mov    %ebp,%ecx
  801b27:	d3 e2                	shl    %cl,%edx
  801b29:	89 14 24             	mov    %edx,(%esp)
  801b2c:	89 d8                	mov    %ebx,%eax
  801b2e:	d3 e0                	shl    %cl,%eax
  801b30:	89 c2                	mov    %eax,%edx
  801b32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b36:	d3 e0                	shl    %cl,%eax
  801b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b40:	89 f1                	mov    %esi,%ecx
  801b42:	d3 e8                	shr    %cl,%eax
  801b44:	09 d0                	or     %edx,%eax
  801b46:	d3 eb                	shr    %cl,%ebx
  801b48:	89 da                	mov    %ebx,%edx
  801b4a:	f7 f7                	div    %edi
  801b4c:	89 d3                	mov    %edx,%ebx
  801b4e:	f7 24 24             	mull   (%esp)
  801b51:	89 c6                	mov    %eax,%esi
  801b53:	89 d1                	mov    %edx,%ecx
  801b55:	39 d3                	cmp    %edx,%ebx
  801b57:	0f 82 87 00 00 00    	jb     801be4 <__umoddi3+0x134>
  801b5d:	0f 84 91 00 00 00    	je     801bf4 <__umoddi3+0x144>
  801b63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b67:	29 f2                	sub    %esi,%edx
  801b69:	19 cb                	sbb    %ecx,%ebx
  801b6b:	89 d8                	mov    %ebx,%eax
  801b6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b71:	d3 e0                	shl    %cl,%eax
  801b73:	89 e9                	mov    %ebp,%ecx
  801b75:	d3 ea                	shr    %cl,%edx
  801b77:	09 d0                	or     %edx,%eax
  801b79:	89 e9                	mov    %ebp,%ecx
  801b7b:	d3 eb                	shr    %cl,%ebx
  801b7d:	89 da                	mov    %ebx,%edx
  801b7f:	83 c4 1c             	add    $0x1c,%esp
  801b82:	5b                   	pop    %ebx
  801b83:	5e                   	pop    %esi
  801b84:	5f                   	pop    %edi
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    
  801b87:	90                   	nop
  801b88:	89 fd                	mov    %edi,%ebp
  801b8a:	85 ff                	test   %edi,%edi
  801b8c:	75 0b                	jne    801b99 <__umoddi3+0xe9>
  801b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b93:	31 d2                	xor    %edx,%edx
  801b95:	f7 f7                	div    %edi
  801b97:	89 c5                	mov    %eax,%ebp
  801b99:	89 f0                	mov    %esi,%eax
  801b9b:	31 d2                	xor    %edx,%edx
  801b9d:	f7 f5                	div    %ebp
  801b9f:	89 c8                	mov    %ecx,%eax
  801ba1:	f7 f5                	div    %ebp
  801ba3:	89 d0                	mov    %edx,%eax
  801ba5:	e9 44 ff ff ff       	jmp    801aee <__umoddi3+0x3e>
  801baa:	66 90                	xchg   %ax,%ax
  801bac:	89 c8                	mov    %ecx,%eax
  801bae:	89 f2                	mov    %esi,%edx
  801bb0:	83 c4 1c             	add    $0x1c,%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	5f                   	pop    %edi
  801bb6:	5d                   	pop    %ebp
  801bb7:	c3                   	ret    
  801bb8:	3b 04 24             	cmp    (%esp),%eax
  801bbb:	72 06                	jb     801bc3 <__umoddi3+0x113>
  801bbd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bc1:	77 0f                	ja     801bd2 <__umoddi3+0x122>
  801bc3:	89 f2                	mov    %esi,%edx
  801bc5:	29 f9                	sub    %edi,%ecx
  801bc7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bcb:	89 14 24             	mov    %edx,(%esp)
  801bce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bd2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bd6:	8b 14 24             	mov    (%esp),%edx
  801bd9:	83 c4 1c             	add    $0x1c,%esp
  801bdc:	5b                   	pop    %ebx
  801bdd:	5e                   	pop    %esi
  801bde:	5f                   	pop    %edi
  801bdf:	5d                   	pop    %ebp
  801be0:	c3                   	ret    
  801be1:	8d 76 00             	lea    0x0(%esi),%esi
  801be4:	2b 04 24             	sub    (%esp),%eax
  801be7:	19 fa                	sbb    %edi,%edx
  801be9:	89 d1                	mov    %edx,%ecx
  801beb:	89 c6                	mov    %eax,%esi
  801bed:	e9 71 ff ff ff       	jmp    801b63 <__umoddi3+0xb3>
  801bf2:	66 90                	xchg   %ax,%ax
  801bf4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bf8:	72 ea                	jb     801be4 <__umoddi3+0x134>
  801bfa:	89 d9                	mov    %ebx,%ecx
  801bfc:	e9 62 ff ff ff       	jmp    801b63 <__umoddi3+0xb3>
