
obj/user/tst_page_replacement_FIFO_2:     file format elf32-i386


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
  800031:	e8 7f 08 00 00       	call   8008b5 <libmain>
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
  80003b:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	int envID = sys_getenvid();
  800041:	e8 5a 18 00 00       	call   8018a0 <sys_getenvid>
  800046:	89 45 ec             	mov    %eax,-0x14(%ebp)
//	cprintf("envID = %d\n",envID);

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800049:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80004c:	89 d0                	mov    %edx,%eax
  80004e:	c1 e0 03             	shl    $0x3,%eax
  800051:	01 d0                	add    %edx,%eax
  800053:	01 c0                	add    %eax,%eax
  800055:	01 d0                	add    %edx,%eax
  800057:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800068:	89 45 e8             	mov    %eax,-0x18(%ebp)
	char* tempArr = (char*)0x80000000;
  80006b:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
	//sys_allocateMem(0x80000000, 15*1024);

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800072:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800075:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80007b:	8b 00                	mov    (%eax),%eax
  80007d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800080:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800083:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800088:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80008d:	74 14                	je     8000a3 <_main+0x6b>
  80008f:	83 ec 04             	sub    $0x4,%esp
  800092:	68 00 20 80 00       	push   $0x802000
  800097:	6a 17                	push   $0x17
  800099:	68 44 20 80 00       	push   $0x802044
  80009e:	e8 d3 08 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a6:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000ac:	83 c0 0c             	add    $0xc,%eax
  8000af:	8b 00                	mov    (%eax),%eax
  8000b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8000b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000bc:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 00 20 80 00       	push   $0x802000
  8000cb:	6a 18                	push   $0x18
  8000cd:	68 44 20 80 00       	push   $0x802044
  8000d2:	e8 9f 08 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000da:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000e0:	83 c0 18             	add    $0x18,%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8000e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f0:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 00 20 80 00       	push   $0x802000
  8000ff:	6a 19                	push   $0x19
  800101:	68 44 20 80 00       	push   $0x802044
  800106:	e8 6b 08 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80010b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80010e:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800114:	83 c0 24             	add    $0x24,%eax
  800117:	8b 00                	mov    (%eax),%eax
  800119:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80011c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80011f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800124:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800129:	74 14                	je     80013f <_main+0x107>
  80012b:	83 ec 04             	sub    $0x4,%esp
  80012e:	68 00 20 80 00       	push   $0x802000
  800133:	6a 1a                	push   $0x1a
  800135:	68 44 20 80 00       	push   $0x802044
  80013a:	e8 37 08 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80013f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800142:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800148:	83 c0 30             	add    $0x30,%eax
  80014b:	8b 00                	mov    (%eax),%eax
  80014d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800150:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800153:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800158:	3d 00 40 20 00       	cmp    $0x204000,%eax
  80015d:	74 14                	je     800173 <_main+0x13b>
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	68 00 20 80 00       	push   $0x802000
  800167:	6a 1b                	push   $0x1b
  800169:	68 44 20 80 00       	push   $0x802044
  80016e:	e8 03 08 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800173:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800176:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80017c:	83 c0 3c             	add    $0x3c,%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800184:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800187:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80018c:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800191:	74 14                	je     8001a7 <_main+0x16f>
  800193:	83 ec 04             	sub    $0x4,%esp
  800196:	68 00 20 80 00       	push   $0x802000
  80019b:	6a 1c                	push   $0x1c
  80019d:	68 44 20 80 00       	push   $0x802044
  8001a2:	e8 cf 07 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001b0:	83 c0 48             	add    $0x48,%eax
  8001b3:	8b 00                	mov    (%eax),%eax
  8001b5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001c0:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001c5:	74 14                	je     8001db <_main+0x1a3>
  8001c7:	83 ec 04             	sub    $0x4,%esp
  8001ca:	68 00 20 80 00       	push   $0x802000
  8001cf:	6a 1d                	push   $0x1d
  8001d1:	68 44 20 80 00       	push   $0x802044
  8001d6:	e8 9b 07 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001de:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001e4:	83 c0 54             	add    $0x54,%eax
  8001e7:	8b 00                	mov    (%eax),%eax
  8001e9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001ec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f4:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001f9:	74 14                	je     80020f <_main+0x1d7>
  8001fb:	83 ec 04             	sub    $0x4,%esp
  8001fe:	68 00 20 80 00       	push   $0x802000
  800203:	6a 1e                	push   $0x1e
  800205:	68 44 20 80 00       	push   $0x802044
  80020a:	e8 67 07 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80020f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800212:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800218:	83 c0 60             	add    $0x60,%eax
  80021b:	8b 00                	mov    (%eax),%eax
  80021d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800220:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800223:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800228:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 00 20 80 00       	push   $0x802000
  800237:	6a 1f                	push   $0x1f
  800239:	68 44 20 80 00       	push   $0x802044
  80023e:	e8 33 07 00 00       	call   800976 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800246:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  80024c:	85 c0                	test   %eax,%eax
  80024e:	74 14                	je     800264 <_main+0x22c>
  800250:	83 ec 04             	sub    $0x4,%esp
  800253:	68 68 20 80 00       	push   $0x802068
  800258:	6a 20                	push   $0x20
  80025a:	68 44 20 80 00       	push   $0x802044
  80025f:	e8 12 07 00 00       	call   800976 <_panic>
	}

	int freePages = sys_calculate_free_frames();
  800264:	e8 e9 16 00 00       	call   801952 <sys_calculate_free_frames>
  800269:	89 45 bc             	mov    %eax,-0x44(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80026c:	e8 64 17 00 00       	call   8019d5 <sys_pf_calculate_allocated_pages>
  800271:	89 45 b8             	mov    %eax,-0x48(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1];
  800274:	a0 1f e0 80 00       	mov    0x80e01f,%al
  800279:	88 45 b7             	mov    %al,-0x49(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
  80027c:	a0 1f f0 80 00       	mov    0x80f01f,%al
  800281:	88 45 b6             	mov    %al,-0x4a(%ebp)

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*5 ; i+=PAGE_SIZE/2)
  800284:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80028b:	eb 37                	jmp    8002c4 <_main+0x28c>
	{
		arr[i] = -1 ;
  80028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800290:	05 20 30 80 00       	add    $0x803020,%eax
  800295:	c6 00 ff             	movb   $0xff,(%eax)
		*ptr = *ptr2 ;
  800298:	a1 00 30 80 00       	mov    0x803000,%eax
  80029d:	8b 15 04 30 80 00    	mov    0x803004,%edx
  8002a3:	8a 12                	mov    (%edx),%dl
  8002a5:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8002a7:	a1 00 30 80 00       	mov    0x803000,%eax
  8002ac:	40                   	inc    %eax
  8002ad:	a3 00 30 80 00       	mov    %eax,0x803000
  8002b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b7:	40                   	inc    %eax
  8002b8:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1];
	char garbage2 = arr[PAGE_SIZE*12-1];

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*5 ; i+=PAGE_SIZE/2)
  8002bd:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8002c4:	81 7d f4 ff 4f 00 00 	cmpl   $0x4fff,-0xc(%ebp)
  8002cb:	7e c0                	jle    80028d <_main+0x255>
		ptr++ ; ptr2++ ;
	}

	//Check FIFO 1
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8002cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d0:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8002db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002e3:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8002e8:	74 14                	je     8002fe <_main+0x2c6>
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	68 b0 20 80 00       	push   $0x8020b0
  8002f2:	6a 35                	push   $0x35
  8002f4:	68 44 20 80 00       	push   $0x802044
  8002f9:	e8 78 06 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80f000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8002fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800301:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800307:	83 c0 0c             	add    $0xc,%eax
  80030a:	8b 00                	mov    (%eax),%eax
  80030c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80030f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800312:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800317:	3d 00 f0 80 00       	cmp    $0x80f000,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 b0 20 80 00       	push   $0x8020b0
  800326:	6a 36                	push   $0x36
  800328:	68 44 20 80 00       	push   $0x802044
  80032d:	e8 44 06 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800335:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80033b:	83 c0 18             	add    $0x18,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800343:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800346:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80034b:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800350:	74 14                	je     800366 <_main+0x32e>
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	68 b0 20 80 00       	push   $0x8020b0
  80035a:	6a 37                	push   $0x37
  80035c:	68 44 20 80 00       	push   $0x802044
  800361:	e8 10 06 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800369:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80036f:	83 c0 24             	add    $0x24,%eax
  800372:	8b 00                	mov    (%eax),%eax
  800374:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800377:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80037a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037f:	3d 00 40 80 00       	cmp    $0x804000,%eax
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 b0 20 80 00       	push   $0x8020b0
  80038e:	6a 38                	push   $0x38
  800390:	68 44 20 80 00       	push   $0x802044
  800395:	e8 dc 05 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x805000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80039a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80039d:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8003a3:	83 c0 30             	add    $0x30,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8003ab:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b3:	3d 00 50 80 00       	cmp    $0x805000,%eax
  8003b8:	74 14                	je     8003ce <_main+0x396>
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	68 b0 20 80 00       	push   $0x8020b0
  8003c2:	6a 39                	push   $0x39
  8003c4:	68 44 20 80 00       	push   $0x802044
  8003c9:	e8 a8 05 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x806000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8003d7:	83 c0 3c             	add    $0x3c,%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003df:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003e7:	3d 00 60 80 00       	cmp    $0x806000,%eax
  8003ec:	74 14                	je     800402 <_main+0x3ca>
  8003ee:	83 ec 04             	sub    $0x4,%esp
  8003f1:	68 b0 20 80 00       	push   $0x8020b0
  8003f6:	6a 3a                	push   $0x3a
  8003f8:	68 44 20 80 00       	push   $0x802044
  8003fd:	e8 74 05 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x807000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80040b:	83 c0 48             	add    $0x48,%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	89 45 98             	mov    %eax,-0x68(%ebp)
  800413:	8b 45 98             	mov    -0x68(%ebp),%eax
  800416:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041b:	3d 00 70 80 00       	cmp    $0x807000,%eax
  800420:	74 14                	je     800436 <_main+0x3fe>
  800422:	83 ec 04             	sub    $0x4,%esp
  800425:	68 b0 20 80 00       	push   $0x8020b0
  80042a:	6a 3b                	push   $0x3b
  80042c:	68 44 20 80 00       	push   $0x802044
  800431:	e8 40 05 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800439:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80043f:	83 c0 54             	add    $0x54,%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800447:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80044a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80044f:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800454:	74 14                	je     80046a <_main+0x432>
  800456:	83 ec 04             	sub    $0x4,%esp
  800459:	68 b0 20 80 00       	push   $0x8020b0
  80045e:	6a 3c                	push   $0x3c
  800460:	68 44 20 80 00       	push   $0x802044
  800465:	e8 0c 05 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80046a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046d:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800473:	83 c0 60             	add    $0x60,%eax
  800476:	8b 00                	mov    (%eax),%eax
  800478:	89 45 90             	mov    %eax,-0x70(%ebp)
  80047b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80047e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800483:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800488:	74 14                	je     80049e <_main+0x466>
  80048a:	83 ec 04             	sub    $0x4,%esp
  80048d:	68 b0 20 80 00       	push   $0x8020b0
  800492:	6a 3d                	push   $0x3d
  800494:	68 44 20 80 00       	push   $0x802044
  800499:	e8 d8 04 00 00       	call   800976 <_panic>

		if(myEnv->page_last_WS_index != 1) panic("wrong PAGE WS pointer location");
  80049e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a1:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  8004a7:	83 f8 01             	cmp    $0x1,%eax
  8004aa:	74 14                	je     8004c0 <_main+0x488>
  8004ac:	83 ec 04             	sub    $0x4,%esp
  8004af:	68 fc 20 80 00       	push   $0x8020fc
  8004b4:	6a 3f                	push   $0x3f
  8004b6:	68 44 20 80 00       	push   $0x802044
  8004bb:	e8 b6 04 00 00       	call   800976 <_panic>
	}

	sys_allocateMem(0x80000000, 4*PAGE_SIZE);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	68 00 40 00 00       	push   $0x4000
  8004c8:	68 00 00 00 80       	push   $0x80000000
  8004cd:	e8 e7 14 00 00       	call   8019b9 <sys_allocateMem>
  8004d2:	83 c4 10             	add    $0x10,%esp

	int c;
	for(c = 0;c< 15*1024;c++)
  8004d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004dc:	eb 0e                	jmp    8004ec <_main+0x4b4>
	{
		tempArr[c] = 'a';
  8004de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004e4:	01 d0                	add    %edx,%eax
  8004e6:	c6 00 61             	movb   $0x61,(%eax)
	}

	sys_allocateMem(0x80000000, 4*PAGE_SIZE);

	int c;
	for(c = 0;c< 15*1024;c++)
  8004e9:	ff 45 f0             	incl   -0x10(%ebp)
  8004ec:	81 7d f0 ff 3b 00 00 	cmpl   $0x3bff,-0x10(%ebp)
  8004f3:	7e e9                	jle    8004de <_main+0x4a6>
	{
		tempArr[c] = 'a';
	}

	sys_freeMem(0x80000000, 4*PAGE_SIZE);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	68 00 40 00 00       	push   $0x4000
  8004fd:	68 00 00 00 80       	push   $0x80000000
  800502:	e8 96 14 00 00       	call   80199d <sys_freeMem>
  800507:	83 c4 10             	add    $0x10,%esp

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*5 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80050a:	c7 45 f4 00 50 00 00 	movl   $0x5000,-0xc(%ebp)
  800511:	eb 37                	jmp    80054a <_main+0x512>
	{
		arr[i] = -1 ;
  800513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800516:	05 20 30 80 00       	add    $0x803020,%eax
  80051b:	c6 00 ff             	movb   $0xff,(%eax)
		*ptr = *ptr2 ;
  80051e:	a1 00 30 80 00       	mov    0x803000,%eax
  800523:	8b 15 04 30 80 00    	mov    0x803004,%edx
  800529:	8a 12                	mov    (%edx),%dl
  80052b:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  80052d:	a1 00 30 80 00       	mov    0x803000,%eax
  800532:	40                   	inc    %eax
  800533:	a3 00 30 80 00       	mov    %eax,0x803000
  800538:	a1 04 30 80 00       	mov    0x803004,%eax
  80053d:	40                   	inc    %eax
  80053e:	a3 04 30 80 00       	mov    %eax,0x803004
	}

	sys_freeMem(0x80000000, 4*PAGE_SIZE);

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*5 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800543:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  80054a:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  800551:	7e c0                	jle    800513 <_main+0x4db>
	}

	//===================
	//cprintf("Checking PAGE FIFO algorithm after Free and replacement... \n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800553:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800556:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800561:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800564:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800569:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  80056e:	74 14                	je     800584 <_main+0x54c>
  800570:	83 ec 04             	sub    $0x4,%esp
  800573:	68 b0 20 80 00       	push   $0x8020b0
  800578:	6a 57                	push   $0x57
  80057a:	68 44 20 80 00       	push   $0x802044
  80057f:	e8 f2 03 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0xeebfd000 && ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x801000) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800584:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800587:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80058d:	83 c0 0c             	add    $0xc,%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	89 45 88             	mov    %eax,-0x78(%ebp)
  800595:	8b 45 88             	mov    -0x78(%ebp),%eax
  800598:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059d:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8005a2:	74 34                	je     8005d8 <_main+0x5a0>
  8005a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a7:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8005ad:	83 c0 0c             	add    $0xc,%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8005b5:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005bd:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 b0 20 80 00       	push   $0x8020b0
  8005cc:	6a 58                	push   $0x58
  8005ce:	68 44 20 80 00       	push   $0x802044
  8005d3:	e8 9e 03 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x80b000 && ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x803000) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8005d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005db:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8005e1:	83 c0 18             	add    $0x18,%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	89 45 80             	mov    %eax,-0x80(%ebp)
  8005e9:	8b 45 80             	mov    -0x80(%ebp),%eax
  8005ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f1:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  8005f6:	74 3a                	je     800632 <_main+0x5fa>
  8005f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005fb:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800601:	83 c0 18             	add    $0x18,%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80060c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800612:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800617:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80061c:	74 14                	je     800632 <_main+0x5fa>
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	68 b0 20 80 00       	push   $0x8020b0
  800626:	6a 59                	push   $0x59
  800628:	68 44 20 80 00       	push   $0x802044
  80062d:	e8 44 03 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x80c000 && ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x804000) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800632:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800635:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80063b:	83 c0 24             	add    $0x24,%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800646:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80064c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800651:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800656:	74 3a                	je     800692 <_main+0x65a>
  800658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800661:	83 c0 24             	add    $0x24,%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80066c:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800672:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800677:	3d 00 40 80 00       	cmp    $0x804000,%eax
  80067c:	74 14                	je     800692 <_main+0x65a>
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	68 b0 20 80 00       	push   $0x8020b0
  800686:	6a 5a                	push   $0x5a
  800688:	68 44 20 80 00       	push   $0x802044
  80068d:	e8 e4 02 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x800000 && ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x809000) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800695:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80069b:	83 c0 30             	add    $0x30,%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  8006a6:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006b1:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8006b6:	74 3a                	je     8006f2 <_main+0x6ba>
  8006b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006bb:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8006c1:	83 c0 30             	add    $0x30,%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8006cc:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8006d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006d7:	3d 00 90 80 00       	cmp    $0x809000,%eax
  8006dc:	74 14                	je     8006f2 <_main+0x6ba>
  8006de:	83 ec 04             	sub    $0x4,%esp
  8006e1:	68 b0 20 80 00       	push   $0x8020b0
  8006e6:	6a 5b                	push   $0x5b
  8006e8:	68 44 20 80 00       	push   $0x802044
  8006ed:	e8 84 02 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x801000 && ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0xeebfd000) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8006f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f5:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8006fb:	83 c0 3c             	add    $0x3c,%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800706:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80070c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800711:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800716:	74 3a                	je     800752 <_main+0x71a>
  800718:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80071b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800721:	83 c0 3c             	add    $0x3c,%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80072c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800732:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800737:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80073c:	74 14                	je     800752 <_main+0x71a>
  80073e:	83 ec 04             	sub    $0x4,%esp
  800741:	68 b0 20 80 00       	push   $0x8020b0
  800746:	6a 5c                	push   $0x5c
  800748:	68 44 20 80 00       	push   $0x802044
  80074d:	e8 24 02 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x803000 && ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x80b000) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800755:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80075b:	83 c0 48             	add    $0x48,%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800766:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80076c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800771:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800776:	74 3a                	je     8007b2 <_main+0x77a>
  800778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80077b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800781:	83 c0 48             	add    $0x48,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  80078c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800792:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800797:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  80079c:	74 14                	je     8007b2 <_main+0x77a>
  80079e:	83 ec 04             	sub    $0x4,%esp
  8007a1:	68 b0 20 80 00       	push   $0x8020b0
  8007a6:	6a 5d                	push   $0x5d
  8007a8:	68 44 20 80 00       	push   $0x802044
  8007ad:	e8 c4 01 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x804000 && ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x80c000) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8007b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b5:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8007bb:	83 c0 54             	add    $0x54,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8007c6:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8007cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d1:	3d 00 40 80 00       	cmp    $0x804000,%eax
  8007d6:	74 3a                	je     800812 <_main+0x7da>
  8007d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007db:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8007e1:	83 c0 54             	add    $0x54,%eax
  8007e4:	8b 00                	mov    (%eax),%eax
  8007e6:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  8007ec:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8007f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007f7:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  8007fc:	74 14                	je     800812 <_main+0x7da>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 b0 20 80 00       	push   $0x8020b0
  800806:	6a 5e                	push   $0x5e
  800808:	68 44 20 80 00       	push   $0x802044
  80080d:	e8 64 01 00 00       	call   800976 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x809000 && ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x800000) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800812:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800815:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80081b:	83 c0 60             	add    $0x60,%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800826:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80082c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800831:	3d 00 90 80 00       	cmp    $0x809000,%eax
  800836:	74 3a                	je     800872 <_main+0x83a>
  800838:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80083b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800841:	83 c0 60             	add    $0x60,%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  80084c:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800852:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800857:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80085c:	74 14                	je     800872 <_main+0x83a>
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 b0 20 80 00       	push   $0x8020b0
  800866:	6a 5f                	push   $0x5f
  800868:	68 44 20 80 00       	push   $0x802044
  80086d:	e8 04 01 00 00       	call   800976 <_panic>

		if(myEnv->page_last_WS_index != 6 && myEnv->page_last_WS_index != 2) panic("wrong PAGE WS pointer location");
  800872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800875:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  80087b:	83 f8 06             	cmp    $0x6,%eax
  80087e:	74 22                	je     8008a2 <_main+0x86a>
  800880:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800883:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  800889:	83 f8 02             	cmp    $0x2,%eax
  80088c:	74 14                	je     8008a2 <_main+0x86a>
  80088e:	83 ec 04             	sub    $0x4,%esp
  800891:	68 fc 20 80 00       	push   $0x8020fc
  800896:	6a 61                	push   $0x61
  800898:	68 44 20 80 00       	push   $0x802044
  80089d:	e8 d4 00 00 00       	call   800976 <_panic>
	}

	cprintf("Congratulations!! test PAGE replacement [FIFO Alg.] is completed successfully.\n");
  8008a2:	83 ec 0c             	sub    $0xc,%esp
  8008a5:	68 1c 21 80 00       	push   $0x80211c
  8008aa:	e8 f2 01 00 00       	call   800aa1 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	return;	
  8008b2:	90                   	nop
}
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008bf:	7e 0a                	jle    8008cb <libmain+0x16>
		binaryname = argv[0];
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	e8 5f f7 ff ff       	call   800038 <_main>
  8008d9:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8008dc:	e8 bf 0f 00 00       	call   8018a0 <sys_getenvid>
  8008e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8008e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e7:	89 d0                	mov    %edx,%eax
  8008e9:	c1 e0 03             	shl    $0x3,%eax
  8008ec:	01 d0                	add    %edx,%eax
  8008ee:	01 c0                	add    %eax,%eax
  8008f0:	01 d0                	add    %edx,%eax
  8008f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008f9:	01 d0                	add    %edx,%eax
  8008fb:	c1 e0 03             	shl    $0x3,%eax
  8008fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800903:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800906:	e8 e3 10 00 00       	call   8019ee <sys_disable_interrupt>
		cprintf("**************************************\n");
  80090b:	83 ec 0c             	sub    $0xc,%esp
  80090e:	68 84 21 80 00       	push   $0x802184
  800913:	e8 89 01 00 00       	call   800aa1 <cprintf>
  800918:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80091b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80091e:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	50                   	push   %eax
  800928:	68 ac 21 80 00       	push   $0x8021ac
  80092d:	e8 6f 01 00 00       	call   800aa1 <cprintf>
  800932:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800935:	83 ec 0c             	sub    $0xc,%esp
  800938:	68 84 21 80 00       	push   $0x802184
  80093d:	e8 5f 01 00 00       	call   800aa1 <cprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800945:	e8 be 10 00 00       	call   801a08 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80094a:	e8 19 00 00 00       	call   800968 <exit>
}
  80094f:	90                   	nop
  800950:	c9                   	leave  
  800951:	c3                   	ret    

00800952 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800958:	83 ec 0c             	sub    $0xc,%esp
  80095b:	6a 00                	push   $0x0
  80095d:	e8 23 0f 00 00       	call   801885 <sys_env_destroy>
  800962:	83 c4 10             	add    $0x10,%esp
}
  800965:	90                   	nop
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <exit>:

void
exit(void)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80096e:	e8 46 0f 00 00       	call   8018b9 <sys_env_exit>
}
  800973:	90                   	nop
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80097c:	8d 45 10             	lea    0x10(%ebp),%eax
  80097f:	83 c0 04             	add    $0x4,%eax
  800982:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800985:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  80098a:	85 c0                	test   %eax,%eax
  80098c:	74 16                	je     8009a4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80098e:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	50                   	push   %eax
  800997:	68 c5 21 80 00       	push   $0x8021c5
  80099c:	e8 00 01 00 00       	call   800aa1 <cprintf>
  8009a1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009a4:	a1 08 30 80 00       	mov    0x803008,%eax
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	ff 75 08             	pushl  0x8(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	68 ca 21 80 00       	push   $0x8021ca
  8009b5:	e8 e7 00 00 00       	call   800aa1 <cprintf>
  8009ba:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c6:	50                   	push   %eax
  8009c7:	e8 7a 00 00 00       	call   800a46 <vcprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8009cf:	83 ec 0c             	sub    $0xc,%esp
  8009d2:	68 e6 21 80 00       	push   $0x8021e6
  8009d7:	e8 c5 00 00 00       	call   800aa1 <cprintf>
  8009dc:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009df:	e8 84 ff ff ff       	call   800968 <exit>

	// should not return here
	while (1) ;
  8009e4:	eb fe                	jmp    8009e4 <_panic+0x6e>

008009e6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	8b 00                	mov    (%eax),%eax
  8009f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8009f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f7:	89 0a                	mov    %ecx,(%edx)
  8009f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8009fc:	88 d1                	mov    %dl,%cl
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a01:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a0f:	75 23                	jne    800a34 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a14:	8b 00                	mov    (%eax),%eax
  800a16:	89 c2                	mov    %eax,%edx
  800a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1b:	83 c0 08             	add    $0x8,%eax
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	52                   	push   %edx
  800a22:	50                   	push   %eax
  800a23:	e8 27 0e 00 00       	call   80184f <sys_cputs>
  800a28:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	8b 40 04             	mov    0x4(%eax),%eax
  800a3a:	8d 50 01             	lea    0x1(%eax),%edx
  800a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a40:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a43:	90                   	nop
  800a44:	c9                   	leave  
  800a45:	c3                   	ret    

00800a46 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a4f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a56:	00 00 00 
	b.cnt = 0;
  800a59:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a60:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a63:	ff 75 0c             	pushl  0xc(%ebp)
  800a66:	ff 75 08             	pushl  0x8(%ebp)
  800a69:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a6f:	50                   	push   %eax
  800a70:	68 e6 09 80 00       	push   $0x8009e6
  800a75:	e8 fa 01 00 00       	call   800c74 <vprintfmt>
  800a7a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800a7d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	50                   	push   %eax
  800a87:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a8d:	83 c0 08             	add    $0x8,%eax
  800a90:	50                   	push   %eax
  800a91:	e8 b9 0d 00 00       	call   80184f <sys_cputs>
  800a96:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800a99:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <cprintf>:

int cprintf(const char *fmt, ...) {
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aa7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab6:	50                   	push   %eax
  800ab7:	e8 8a ff ff ff       	call   800a46 <vcprintf>
  800abc:	83 c4 10             	add    $0x10,%esp
  800abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    

00800ac7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800acd:	e8 1c 0f 00 00       	call   8019ee <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800ad2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae1:	50                   	push   %eax
  800ae2:	e8 5f ff ff ff       	call   800a46 <vcprintf>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800aed:	e8 16 0f 00 00       	call   801a08 <sys_enable_interrupt>
	return cnt;
  800af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af5:	c9                   	leave  
  800af6:	c3                   	ret    

00800af7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	53                   	push   %ebx
  800afb:	83 ec 14             	sub    $0x14,%esp
  800afe:	8b 45 10             	mov    0x10(%ebp),%eax
  800b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b0a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b15:	77 55                	ja     800b6c <printnum+0x75>
  800b17:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b1a:	72 05                	jb     800b21 <printnum+0x2a>
  800b1c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b1f:	77 4b                	ja     800b6c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b21:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b24:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b27:	8b 45 18             	mov    0x18(%ebp),%eax
  800b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2f:	52                   	push   %edx
  800b30:	50                   	push   %eax
  800b31:	ff 75 f4             	pushl  -0xc(%ebp)
  800b34:	ff 75 f0             	pushl  -0x10(%ebp)
  800b37:	e8 50 12 00 00       	call   801d8c <__udivdi3>
  800b3c:	83 c4 10             	add    $0x10,%esp
  800b3f:	83 ec 04             	sub    $0x4,%esp
  800b42:	ff 75 20             	pushl  0x20(%ebp)
  800b45:	53                   	push   %ebx
  800b46:	ff 75 18             	pushl  0x18(%ebp)
  800b49:	52                   	push   %edx
  800b4a:	50                   	push   %eax
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	ff 75 08             	pushl  0x8(%ebp)
  800b51:	e8 a1 ff ff ff       	call   800af7 <printnum>
  800b56:	83 c4 20             	add    $0x20,%esp
  800b59:	eb 1a                	jmp    800b75 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	ff 75 20             	pushl  0x20(%ebp)
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b6c:	ff 4d 1c             	decl   0x1c(%ebp)
  800b6f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b73:	7f e6                	jg     800b5b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b75:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b83:	53                   	push   %ebx
  800b84:	51                   	push   %ecx
  800b85:	52                   	push   %edx
  800b86:	50                   	push   %eax
  800b87:	e8 10 13 00 00       	call   801e9c <__umoddi3>
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	05 14 24 80 00       	add    $0x802414,%eax
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	0f be c0             	movsbl %al,%eax
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	50                   	push   %eax
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
}
  800ba8:	90                   	nop
  800ba9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb5:	7e 1c                	jle    800bd3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8b 00                	mov    (%eax),%eax
  800bbc:	8d 50 08             	lea    0x8(%eax),%edx
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	89 10                	mov    %edx,(%eax)
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	83 e8 08             	sub    $0x8,%eax
  800bcc:	8b 50 04             	mov    0x4(%eax),%edx
  800bcf:	8b 00                	mov    (%eax),%eax
  800bd1:	eb 40                	jmp    800c13 <getuint+0x65>
	else if (lflag)
  800bd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd7:	74 1e                	je     800bf7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8b 00                	mov    (%eax),%eax
  800bde:	8d 50 04             	lea    0x4(%eax),%edx
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	89 10                	mov    %edx,(%eax)
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	83 e8 04             	sub    $0x4,%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf5:	eb 1c                	jmp    800c13 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	8d 50 04             	lea    0x4(%eax),%edx
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 10                	mov    %edx,(%eax)
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	83 e8 04             	sub    $0x4,%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c18:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c1c:	7e 1c                	jle    800c3a <getint+0x25>
		return va_arg(*ap, long long);
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	8d 50 08             	lea    0x8(%eax),%edx
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 10                	mov    %edx,(%eax)
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	83 e8 08             	sub    $0x8,%eax
  800c33:	8b 50 04             	mov    0x4(%eax),%edx
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	eb 38                	jmp    800c72 <getint+0x5d>
	else if (lflag)
  800c3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3e:	74 1a                	je     800c5a <getint+0x45>
		return va_arg(*ap, long);
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	8d 50 04             	lea    0x4(%eax),%edx
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 10                	mov    %edx,(%eax)
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	8b 00                	mov    (%eax),%eax
  800c52:	83 e8 04             	sub    $0x4,%eax
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	99                   	cltd   
  800c58:	eb 18                	jmp    800c72 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	8d 50 04             	lea    0x4(%eax),%edx
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	89 10                	mov    %edx,(%eax)
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	83 e8 04             	sub    $0x4,%eax
  800c6f:	8b 00                	mov    (%eax),%eax
  800c71:	99                   	cltd   
}
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c7c:	eb 17                	jmp    800c95 <vprintfmt+0x21>
			if (ch == '\0')
  800c7e:	85 db                	test   %ebx,%ebx
  800c80:	0f 84 af 03 00 00    	je     801035 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	53                   	push   %ebx
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	ff d0                	call   *%eax
  800c92:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c95:	8b 45 10             	mov    0x10(%ebp),%eax
  800c98:	8d 50 01             	lea    0x1(%eax),%edx
  800c9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c9e:	8a 00                	mov    (%eax),%al
  800ca0:	0f b6 d8             	movzbl %al,%ebx
  800ca3:	83 fb 25             	cmp    $0x25,%ebx
  800ca6:	75 d6                	jne    800c7e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ca8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cb3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cc1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	8d 50 01             	lea    0x1(%eax),%edx
  800cce:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	0f b6 d8             	movzbl %al,%ebx
  800cd6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cd9:	83 f8 55             	cmp    $0x55,%eax
  800cdc:	0f 87 2b 03 00 00    	ja     80100d <vprintfmt+0x399>
  800ce2:	8b 04 85 38 24 80 00 	mov    0x802438(,%eax,4),%eax
  800ce9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ceb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cef:	eb d7                	jmp    800cc8 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cf1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cf5:	eb d1                	jmp    800cc8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cf7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d01:	89 d0                	mov    %edx,%eax
  800d03:	c1 e0 02             	shl    $0x2,%eax
  800d06:	01 d0                	add    %edx,%eax
  800d08:	01 c0                	add    %eax,%eax
  800d0a:	01 d8                	add    %ebx,%eax
  800d0c:	83 e8 30             	sub    $0x30,%eax
  800d0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d1a:	83 fb 2f             	cmp    $0x2f,%ebx
  800d1d:	7e 3e                	jle    800d5d <vprintfmt+0xe9>
  800d1f:	83 fb 39             	cmp    $0x39,%ebx
  800d22:	7f 39                	jg     800d5d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d24:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d27:	eb d5                	jmp    800cfe <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d29:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2c:	83 c0 04             	add    $0x4,%eax
  800d2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d32:	8b 45 14             	mov    0x14(%ebp),%eax
  800d35:	83 e8 04             	sub    $0x4,%eax
  800d38:	8b 00                	mov    (%eax),%eax
  800d3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d3d:	eb 1f                	jmp    800d5e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d43:	79 83                	jns    800cc8 <vprintfmt+0x54>
				width = 0;
  800d45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d4c:	e9 77 ff ff ff       	jmp    800cc8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d51:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d58:	e9 6b ff ff ff       	jmp    800cc8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d5d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d62:	0f 89 60 ff ff ff    	jns    800cc8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d6e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d75:	e9 4e ff ff ff       	jmp    800cc8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d7a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d7d:	e9 46 ff ff ff       	jmp    800cc8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d82:	8b 45 14             	mov    0x14(%ebp),%eax
  800d85:	83 c0 04             	add    $0x4,%eax
  800d88:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8e:	83 e8 04             	sub    $0x4,%eax
  800d91:	8b 00                	mov    (%eax),%eax
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	50                   	push   %eax
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	ff d0                	call   *%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
			break;
  800da2:	e9 89 02 00 00       	jmp    801030 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800da7:	8b 45 14             	mov    0x14(%ebp),%eax
  800daa:	83 c0 04             	add    $0x4,%eax
  800dad:	89 45 14             	mov    %eax,0x14(%ebp)
  800db0:	8b 45 14             	mov    0x14(%ebp),%eax
  800db3:	83 e8 04             	sub    $0x4,%eax
  800db6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800db8:	85 db                	test   %ebx,%ebx
  800dba:	79 02                	jns    800dbe <vprintfmt+0x14a>
				err = -err;
  800dbc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dbe:	83 fb 64             	cmp    $0x64,%ebx
  800dc1:	7f 0b                	jg     800dce <vprintfmt+0x15a>
  800dc3:	8b 34 9d 80 22 80 00 	mov    0x802280(,%ebx,4),%esi
  800dca:	85 f6                	test   %esi,%esi
  800dcc:	75 19                	jne    800de7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dce:	53                   	push   %ebx
  800dcf:	68 25 24 80 00       	push   $0x802425
  800dd4:	ff 75 0c             	pushl  0xc(%ebp)
  800dd7:	ff 75 08             	pushl  0x8(%ebp)
  800dda:	e8 5e 02 00 00       	call   80103d <printfmt>
  800ddf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800de2:	e9 49 02 00 00       	jmp    801030 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800de7:	56                   	push   %esi
  800de8:	68 2e 24 80 00       	push   $0x80242e
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	ff 75 08             	pushl  0x8(%ebp)
  800df3:	e8 45 02 00 00       	call   80103d <printfmt>
  800df8:	83 c4 10             	add    $0x10,%esp
			break;
  800dfb:	e9 30 02 00 00       	jmp    801030 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e00:	8b 45 14             	mov    0x14(%ebp),%eax
  800e03:	83 c0 04             	add    $0x4,%eax
  800e06:	89 45 14             	mov    %eax,0x14(%ebp)
  800e09:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0c:	83 e8 04             	sub    $0x4,%eax
  800e0f:	8b 30                	mov    (%eax),%esi
  800e11:	85 f6                	test   %esi,%esi
  800e13:	75 05                	jne    800e1a <vprintfmt+0x1a6>
				p = "(null)";
  800e15:	be 31 24 80 00       	mov    $0x802431,%esi
			if (width > 0 && padc != '-')
  800e1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e1e:	7e 6d                	jle    800e8d <vprintfmt+0x219>
  800e20:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e24:	74 67                	je     800e8d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e29:	83 ec 08             	sub    $0x8,%esp
  800e2c:	50                   	push   %eax
  800e2d:	56                   	push   %esi
  800e2e:	e8 0c 03 00 00       	call   80113f <strnlen>
  800e33:	83 c4 10             	add    $0x10,%esp
  800e36:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e39:	eb 16                	jmp    800e51 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e3b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	50                   	push   %eax
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	ff d0                	call   *%eax
  800e4b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4e:	ff 4d e4             	decl   -0x1c(%ebp)
  800e51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e55:	7f e4                	jg     800e3b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e57:	eb 34                	jmp    800e8d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e59:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e5d:	74 1c                	je     800e7b <vprintfmt+0x207>
  800e5f:	83 fb 1f             	cmp    $0x1f,%ebx
  800e62:	7e 05                	jle    800e69 <vprintfmt+0x1f5>
  800e64:	83 fb 7e             	cmp    $0x7e,%ebx
  800e67:	7e 12                	jle    800e7b <vprintfmt+0x207>
					putch('?', putdat);
  800e69:	83 ec 08             	sub    $0x8,%esp
  800e6c:	ff 75 0c             	pushl  0xc(%ebp)
  800e6f:	6a 3f                	push   $0x3f
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	ff d0                	call   *%eax
  800e76:	83 c4 10             	add    $0x10,%esp
  800e79:	eb 0f                	jmp    800e8a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e7b:	83 ec 08             	sub    $0x8,%esp
  800e7e:	ff 75 0c             	pushl  0xc(%ebp)
  800e81:	53                   	push   %ebx
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	ff d0                	call   *%eax
  800e87:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e8d:	89 f0                	mov    %esi,%eax
  800e8f:	8d 70 01             	lea    0x1(%eax),%esi
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	0f be d8             	movsbl %al,%ebx
  800e97:	85 db                	test   %ebx,%ebx
  800e99:	74 24                	je     800ebf <vprintfmt+0x24b>
  800e9b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e9f:	78 b8                	js     800e59 <vprintfmt+0x1e5>
  800ea1:	ff 4d e0             	decl   -0x20(%ebp)
  800ea4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ea8:	79 af                	jns    800e59 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eaa:	eb 13                	jmp    800ebf <vprintfmt+0x24b>
				putch(' ', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 20                	push   $0x20
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ebc:	ff 4d e4             	decl   -0x1c(%ebp)
  800ebf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec3:	7f e7                	jg     800eac <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ec5:	e9 66 01 00 00       	jmp    801030 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800eca:	83 ec 08             	sub    $0x8,%esp
  800ecd:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed0:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed3:	50                   	push   %eax
  800ed4:	e8 3c fd ff ff       	call   800c15 <getint>
  800ed9:	83 c4 10             	add    $0x10,%esp
  800edc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee8:	85 d2                	test   %edx,%edx
  800eea:	79 23                	jns    800f0f <vprintfmt+0x29b>
				putch('-', putdat);
  800eec:	83 ec 08             	sub    $0x8,%esp
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	6a 2d                	push   $0x2d
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	ff d0                	call   *%eax
  800ef9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f02:	f7 d8                	neg    %eax
  800f04:	83 d2 00             	adc    $0x0,%edx
  800f07:	f7 da                	neg    %edx
  800f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f16:	e9 bc 00 00 00       	jmp    800fd7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f21:	8d 45 14             	lea    0x14(%ebp),%eax
  800f24:	50                   	push   %eax
  800f25:	e8 84 fc ff ff       	call   800bae <getuint>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3a:	e9 98 00 00 00       	jmp    800fd7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	ff 75 0c             	pushl  0xc(%ebp)
  800f45:	6a 58                	push   $0x58
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	ff d0                	call   *%eax
  800f4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	6a 58                	push   $0x58
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	ff d0                	call   *%eax
  800f5c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f5f:	83 ec 08             	sub    $0x8,%esp
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	6a 58                	push   $0x58
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	ff d0                	call   *%eax
  800f6c:	83 c4 10             	add    $0x10,%esp
			break;
  800f6f:	e9 bc 00 00 00       	jmp    801030 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 0c             	pushl  0xc(%ebp)
  800f7a:	6a 30                	push   $0x30
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	ff d0                	call   *%eax
  800f81:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 78                	push   $0x78
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f94:	8b 45 14             	mov    0x14(%ebp),%eax
  800f97:	83 c0 04             	add    $0x4,%eax
  800f9a:	89 45 14             	mov    %eax,0x14(%ebp)
  800f9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa0:	83 e8 04             	sub    $0x4,%eax
  800fa3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800faf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fb6:	eb 1f                	jmp    800fd7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 e8             	pushl  -0x18(%ebp)
  800fbe:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc1:	50                   	push   %eax
  800fc2:	e8 e7 fb ff ff       	call   800bae <getuint>
  800fc7:	83 c4 10             	add    $0x10,%esp
  800fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fd0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fd7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fde:	83 ec 04             	sub    $0x4,%esp
  800fe1:	52                   	push   %edx
  800fe2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fe5:	50                   	push   %eax
  800fe6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe9:	ff 75 f0             	pushl  -0x10(%ebp)
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 00 fb ff ff       	call   800af7 <printnum>
  800ff7:	83 c4 20             	add    $0x20,%esp
			break;
  800ffa:	eb 34                	jmp    801030 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	53                   	push   %ebx
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	ff d0                	call   *%eax
  801008:	83 c4 10             	add    $0x10,%esp
			break;
  80100b:	eb 23                	jmp    801030 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80100d:	83 ec 08             	sub    $0x8,%esp
  801010:	ff 75 0c             	pushl  0xc(%ebp)
  801013:	6a 25                	push   $0x25
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	ff d0                	call   *%eax
  80101a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80101d:	ff 4d 10             	decl   0x10(%ebp)
  801020:	eb 03                	jmp    801025 <vprintfmt+0x3b1>
  801022:	ff 4d 10             	decl   0x10(%ebp)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	48                   	dec    %eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 25                	cmp    $0x25,%al
  80102d:	75 f3                	jne    801022 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80102f:	90                   	nop
		}
	}
  801030:	e9 47 fc ff ff       	jmp    800c7c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801035:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801036:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801043:	8d 45 10             	lea    0x10(%ebp),%eax
  801046:	83 c0 04             	add    $0x4,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80104c:	8b 45 10             	mov    0x10(%ebp),%eax
  80104f:	ff 75 f4             	pushl  -0xc(%ebp)
  801052:	50                   	push   %eax
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	ff 75 08             	pushl  0x8(%ebp)
  801059:	e8 16 fc ff ff       	call   800c74 <vprintfmt>
  80105e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801061:	90                   	nop
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	8b 40 08             	mov    0x8(%eax),%eax
  80106d:	8d 50 01             	lea    0x1(%eax),%edx
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	8b 10                	mov    (%eax),%edx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8b 40 04             	mov    0x4(%eax),%eax
  801081:	39 c2                	cmp    %eax,%edx
  801083:	73 12                	jae    801097 <sprintputch+0x33>
		*b->buf++ = ch;
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	8b 00                	mov    (%eax),%eax
  80108a:	8d 48 01             	lea    0x1(%eax),%ecx
  80108d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801090:	89 0a                	mov    %ecx,(%edx)
  801092:	8b 55 08             	mov    0x8(%ebp),%edx
  801095:	88 10                	mov    %dl,(%eax)
}
  801097:	90                   	nop
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	01 d0                	add    %edx,%eax
  8010b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010bf:	74 06                	je     8010c7 <vsnprintf+0x2d>
  8010c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010c5:	7f 07                	jg     8010ce <vsnprintf+0x34>
		return -E_INVAL;
  8010c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8010cc:	eb 20                	jmp    8010ee <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010ce:	ff 75 14             	pushl  0x14(%ebp)
  8010d1:	ff 75 10             	pushl  0x10(%ebp)
  8010d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010d7:	50                   	push   %eax
  8010d8:	68 64 10 80 00       	push   $0x801064
  8010dd:	e8 92 fb ff ff       	call   800c74 <vprintfmt>
  8010e2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8010f9:	83 c0 04             	add    $0x4,%eax
  8010fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801102:	ff 75 f4             	pushl  -0xc(%ebp)
  801105:	50                   	push   %eax
  801106:	ff 75 0c             	pushl  0xc(%ebp)
  801109:	ff 75 08             	pushl  0x8(%ebp)
  80110c:	e8 89 ff ff ff       	call   80109a <vsnprintf>
  801111:	83 c4 10             	add    $0x10,%esp
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801117:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801122:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801129:	eb 06                	jmp    801131 <strlen+0x15>
		n++;
  80112b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80112e:	ff 45 08             	incl   0x8(%ebp)
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	75 f1                	jne    80112b <strlen+0xf>
		n++;
	return n;
  80113a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801145:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80114c:	eb 09                	jmp    801157 <strnlen+0x18>
		n++;
  80114e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	ff 4d 0c             	decl   0xc(%ebp)
  801157:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115b:	74 09                	je     801166 <strnlen+0x27>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	75 e8                	jne    80114e <strnlen+0xf>
		n++;
	return n;
  801166:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801169:	c9                   	leave  
  80116a:	c3                   	ret    

0080116b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801177:	90                   	nop
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8d 50 01             	lea    0x1(%eax),%edx
  80117e:	89 55 08             	mov    %edx,0x8(%ebp)
  801181:	8b 55 0c             	mov    0xc(%ebp),%edx
  801184:	8d 4a 01             	lea    0x1(%edx),%ecx
  801187:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80118a:	8a 12                	mov    (%edx),%dl
  80118c:	88 10                	mov    %dl,(%eax)
  80118e:	8a 00                	mov    (%eax),%al
  801190:	84 c0                	test   %al,%al
  801192:	75 e4                	jne    801178 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801197:	c9                   	leave  
  801198:	c3                   	ret    

00801199 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ac:	eb 1f                	jmp    8011cd <strncpy+0x34>
		*dst++ = *src;
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8d 50 01             	lea    0x1(%eax),%edx
  8011b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ba:	8a 12                	mov    (%edx),%dl
  8011bc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	84 c0                	test   %al,%al
  8011c5:	74 03                	je     8011ca <strncpy+0x31>
			src++;
  8011c7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011ca:	ff 45 fc             	incl   -0x4(%ebp)
  8011cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011d3:	72 d9                	jb     8011ae <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ea:	74 30                	je     80121c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011ec:	eb 16                	jmp    801204 <strlcpy+0x2a>
			*dst++ = *src++;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8d 50 01             	lea    0x1(%eax),%edx
  8011f4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011fd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801200:	8a 12                	mov    (%edx),%dl
  801202:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801204:	ff 4d 10             	decl   0x10(%ebp)
  801207:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120b:	74 09                	je     801216 <strlcpy+0x3c>
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	84 c0                	test   %al,%al
  801214:	75 d8                	jne    8011ee <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80121c:	8b 55 08             	mov    0x8(%ebp),%edx
  80121f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801222:	29 c2                	sub    %eax,%edx
  801224:	89 d0                	mov    %edx,%eax
}
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80122b:	eb 06                	jmp    801233 <strcmp+0xb>
		p++, q++;
  80122d:	ff 45 08             	incl   0x8(%ebp)
  801230:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	84 c0                	test   %al,%al
  80123a:	74 0e                	je     80124a <strcmp+0x22>
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 10                	mov    (%eax),%dl
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	38 c2                	cmp    %al,%dl
  801248:	74 e3                	je     80122d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	0f b6 d0             	movzbl %al,%edx
  801252:	8b 45 0c             	mov    0xc(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	0f b6 c0             	movzbl %al,%eax
  80125a:	29 c2                	sub    %eax,%edx
  80125c:	89 d0                	mov    %edx,%eax
}
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    

00801260 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801263:	eb 09                	jmp    80126e <strncmp+0xe>
		n--, p++, q++;
  801265:	ff 4d 10             	decl   0x10(%ebp)
  801268:	ff 45 08             	incl   0x8(%ebp)
  80126b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80126e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801272:	74 17                	je     80128b <strncmp+0x2b>
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	84 c0                	test   %al,%al
  80127b:	74 0e                	je     80128b <strncmp+0x2b>
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8a 10                	mov    (%eax),%dl
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	38 c2                	cmp    %al,%dl
  801289:	74 da                	je     801265 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80128b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128f:	75 07                	jne    801298 <strncmp+0x38>
		return 0;
  801291:	b8 00 00 00 00       	mov    $0x0,%eax
  801296:	eb 14                	jmp    8012ac <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	0f b6 d0             	movzbl %al,%edx
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	0f b6 c0             	movzbl %al,%eax
  8012a8:	29 c2                	sub    %eax,%edx
  8012aa:	89 d0                	mov    %edx,%eax
}
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    

008012ae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 04             	sub    $0x4,%esp
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012ba:	eb 12                	jmp    8012ce <strchr+0x20>
		if (*s == c)
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012c4:	75 05                	jne    8012cb <strchr+0x1d>
			return (char *) s;
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	eb 11                	jmp    8012dc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012cb:	ff 45 08             	incl   0x8(%ebp)
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	84 c0                	test   %al,%al
  8012d5:	75 e5                	jne    8012bc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012ea:	eb 0d                	jmp    8012f9 <strfind+0x1b>
		if (*s == c)
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012f4:	74 0e                	je     801304 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012f6:	ff 45 08             	incl   0x8(%ebp)
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8a 00                	mov    (%eax),%al
  8012fe:	84 c0                	test   %al,%al
  801300:	75 ea                	jne    8012ec <strfind+0xe>
  801302:	eb 01                	jmp    801305 <strfind+0x27>
		if (*s == c)
			break;
  801304:	90                   	nop
	return (char *) s;
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80131c:	eb 0e                	jmp    80132c <memset+0x22>
		*p++ = c;
  80131e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801321:	8d 50 01             	lea    0x1(%eax),%edx
  801324:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80132c:	ff 4d f8             	decl   -0x8(%ebp)
  80132f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801333:	79 e9                	jns    80131e <memset+0x14>
		*p++ = c;

	return v;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80134c:	eb 16                	jmp    801364 <memcpy+0x2a>
		*d++ = *s++;
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801357:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801360:	8a 12                	mov    (%edx),%dl
  801362:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801364:	8b 45 10             	mov    0x10(%ebp),%eax
  801367:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136a:	89 55 10             	mov    %edx,0x10(%ebp)
  80136d:	85 c0                	test   %eax,%eax
  80136f:	75 dd                	jne    80134e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  80137c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801388:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80138e:	73 50                	jae    8013e0 <memmove+0x6a>
  801390:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801393:	8b 45 10             	mov    0x10(%ebp),%eax
  801396:	01 d0                	add    %edx,%eax
  801398:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80139b:	76 43                	jbe    8013e0 <memmove+0x6a>
		s += n;
  80139d:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013a9:	eb 10                	jmp    8013bb <memmove+0x45>
			*--d = *--s;
  8013ab:	ff 4d f8             	decl   -0x8(%ebp)
  8013ae:	ff 4d fc             	decl   -0x4(%ebp)
  8013b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b4:	8a 10                	mov    (%eax),%dl
  8013b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	75 e3                	jne    8013ab <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013c8:	eb 23                	jmp    8013ed <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cd:	8d 50 01             	lea    0x1(%eax),%edx
  8013d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013dc:	8a 12                	mov    (%edx),%dl
  8013de:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	75 dd                	jne    8013ca <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801401:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801404:	eb 2a                	jmp    801430 <memcmp+0x3e>
		if (*s1 != *s2)
  801406:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801409:	8a 10                	mov    (%eax),%dl
  80140b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	38 c2                	cmp    %al,%dl
  801412:	74 16                	je     80142a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801414:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	0f b6 d0             	movzbl %al,%edx
  80141c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	0f b6 c0             	movzbl %al,%eax
  801424:	29 c2                	sub    %eax,%edx
  801426:	89 d0                	mov    %edx,%eax
  801428:	eb 18                	jmp    801442 <memcmp+0x50>
		s1++, s2++;
  80142a:	ff 45 fc             	incl   -0x4(%ebp)
  80142d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801430:	8b 45 10             	mov    0x10(%ebp),%eax
  801433:	8d 50 ff             	lea    -0x1(%eax),%edx
  801436:	89 55 10             	mov    %edx,0x10(%ebp)
  801439:	85 c0                	test   %eax,%eax
  80143b:	75 c9                	jne    801406 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80143d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80144a:	8b 55 08             	mov    0x8(%ebp),%edx
  80144d:	8b 45 10             	mov    0x10(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801455:	eb 15                	jmp    80146c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	0f b6 d0             	movzbl %al,%edx
  80145f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801462:	0f b6 c0             	movzbl %al,%eax
  801465:	39 c2                	cmp    %eax,%edx
  801467:	74 0d                	je     801476 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801469:	ff 45 08             	incl   0x8(%ebp)
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801472:	72 e3                	jb     801457 <memfind+0x13>
  801474:	eb 01                	jmp    801477 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801476:	90                   	nop
	return (void *) s;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801482:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801489:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801490:	eb 03                	jmp    801495 <strtol+0x19>
		s++;
  801492:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8a 00                	mov    (%eax),%al
  80149a:	3c 20                	cmp    $0x20,%al
  80149c:	74 f4                	je     801492 <strtol+0x16>
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	8a 00                	mov    (%eax),%al
  8014a3:	3c 09                	cmp    $0x9,%al
  8014a5:	74 eb                	je     801492 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	3c 2b                	cmp    $0x2b,%al
  8014ae:	75 05                	jne    8014b5 <strtol+0x39>
		s++;
  8014b0:	ff 45 08             	incl   0x8(%ebp)
  8014b3:	eb 13                	jmp    8014c8 <strtol+0x4c>
	else if (*s == '-')
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	3c 2d                	cmp    $0x2d,%al
  8014bc:	75 0a                	jne    8014c8 <strtol+0x4c>
		s++, neg = 1;
  8014be:	ff 45 08             	incl   0x8(%ebp)
  8014c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014cc:	74 06                	je     8014d4 <strtol+0x58>
  8014ce:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014d2:	75 20                	jne    8014f4 <strtol+0x78>
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	3c 30                	cmp    $0x30,%al
  8014db:	75 17                	jne    8014f4 <strtol+0x78>
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	40                   	inc    %eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	3c 78                	cmp    $0x78,%al
  8014e5:	75 0d                	jne    8014f4 <strtol+0x78>
		s += 2, base = 16;
  8014e7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014eb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014f2:	eb 28                	jmp    80151c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f8:	75 15                	jne    80150f <strtol+0x93>
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	3c 30                	cmp    $0x30,%al
  801501:	75 0c                	jne    80150f <strtol+0x93>
		s++, base = 8;
  801503:	ff 45 08             	incl   0x8(%ebp)
  801506:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80150d:	eb 0d                	jmp    80151c <strtol+0xa0>
	else if (base == 0)
  80150f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801513:	75 07                	jne    80151c <strtol+0xa0>
		base = 10;
  801515:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	8a 00                	mov    (%eax),%al
  801521:	3c 2f                	cmp    $0x2f,%al
  801523:	7e 19                	jle    80153e <strtol+0xc2>
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	3c 39                	cmp    $0x39,%al
  80152c:	7f 10                	jg     80153e <strtol+0xc2>
			dig = *s - '0';
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	0f be c0             	movsbl %al,%eax
  801536:	83 e8 30             	sub    $0x30,%eax
  801539:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80153c:	eb 42                	jmp    801580 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8a 00                	mov    (%eax),%al
  801543:	3c 60                	cmp    $0x60,%al
  801545:	7e 19                	jle    801560 <strtol+0xe4>
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	3c 7a                	cmp    $0x7a,%al
  80154e:	7f 10                	jg     801560 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	0f be c0             	movsbl %al,%eax
  801558:	83 e8 57             	sub    $0x57,%eax
  80155b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80155e:	eb 20                	jmp    801580 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8a 00                	mov    (%eax),%al
  801565:	3c 40                	cmp    $0x40,%al
  801567:	7e 39                	jle    8015a2 <strtol+0x126>
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	8a 00                	mov    (%eax),%al
  80156e:	3c 5a                	cmp    $0x5a,%al
  801570:	7f 30                	jg     8015a2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	8a 00                	mov    (%eax),%al
  801577:	0f be c0             	movsbl %al,%eax
  80157a:	83 e8 37             	sub    $0x37,%eax
  80157d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801583:	3b 45 10             	cmp    0x10(%ebp),%eax
  801586:	7d 19                	jge    8015a1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801588:	ff 45 08             	incl   0x8(%ebp)
  80158b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801592:	89 c2                	mov    %eax,%edx
  801594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801597:	01 d0                	add    %edx,%eax
  801599:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80159c:	e9 7b ff ff ff       	jmp    80151c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015a1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015a6:	74 08                	je     8015b0 <strtol+0x134>
		*endptr = (char *) s;
  8015a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ae:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b4:	74 07                	je     8015bd <strtol+0x141>
  8015b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b9:	f7 d8                	neg    %eax
  8015bb:	eb 03                	jmp    8015c0 <strtol+0x144>
  8015bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <ltostr>:

void
ltostr(long value, char *str)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015da:	79 13                	jns    8015ef <ltostr+0x2d>
	{
		neg = 1;
  8015dc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015e9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015ec:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015f7:	99                   	cltd   
  8015f8:	f7 f9                	idiv   %ecx
  8015fa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801600:	8d 50 01             	lea    0x1(%eax),%edx
  801603:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801606:	89 c2                	mov    %eax,%edx
  801608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160b:	01 d0                	add    %edx,%eax
  80160d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801610:	83 c2 30             	add    $0x30,%edx
  801613:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801615:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801618:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80161d:	f7 e9                	imul   %ecx
  80161f:	c1 fa 02             	sar    $0x2,%edx
  801622:	89 c8                	mov    %ecx,%eax
  801624:	c1 f8 1f             	sar    $0x1f,%eax
  801627:	29 c2                	sub    %eax,%edx
  801629:	89 d0                	mov    %edx,%eax
  80162b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80162e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801631:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801636:	f7 e9                	imul   %ecx
  801638:	c1 fa 02             	sar    $0x2,%edx
  80163b:	89 c8                	mov    %ecx,%eax
  80163d:	c1 f8 1f             	sar    $0x1f,%eax
  801640:	29 c2                	sub    %eax,%edx
  801642:	89 d0                	mov    %edx,%eax
  801644:	c1 e0 02             	shl    $0x2,%eax
  801647:	01 d0                	add    %edx,%eax
  801649:	01 c0                	add    %eax,%eax
  80164b:	29 c1                	sub    %eax,%ecx
  80164d:	89 ca                	mov    %ecx,%edx
  80164f:	85 d2                	test   %edx,%edx
  801651:	75 9c                	jne    8015ef <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801653:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80165a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165d:	48                   	dec    %eax
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801661:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801665:	74 3d                	je     8016a4 <ltostr+0xe2>
		start = 1 ;
  801667:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80166e:	eb 34                	jmp    8016a4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801670:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	01 d0                	add    %edx,%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80167d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801680:	8b 45 0c             	mov    0xc(%ebp),%eax
  801683:	01 c2                	add    %eax,%edx
  801685:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168b:	01 c8                	add    %ecx,%eax
  80168d:	8a 00                	mov    (%eax),%al
  80168f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801691:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
  801697:	01 c2                	add    %eax,%edx
  801699:	8a 45 eb             	mov    -0x15(%ebp),%al
  80169c:	88 02                	mov    %al,(%edx)
		start++ ;
  80169e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016a1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016aa:	7c c4                	jl     801670 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b2:	01 d0                	add    %edx,%eax
  8016b4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016b7:	90                   	nop
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016c0:	ff 75 08             	pushl  0x8(%ebp)
  8016c3:	e8 54 fa ff ff       	call   80111c <strlen>
  8016c8:	83 c4 04             	add    $0x4,%esp
  8016cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	e8 46 fa ff ff       	call   80111c <strlen>
  8016d6:	83 c4 04             	add    $0x4,%esp
  8016d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ea:	eb 17                	jmp    801703 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f2:	01 c2                	add    %eax,%edx
  8016f4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	01 c8                	add    %ecx,%eax
  8016fc:	8a 00                	mov    (%eax),%al
  8016fe:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801700:	ff 45 fc             	incl   -0x4(%ebp)
  801703:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801706:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801709:	7c e1                	jl     8016ec <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80170b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801712:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801719:	eb 1f                	jmp    80173a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80171b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80171e:	8d 50 01             	lea    0x1(%eax),%edx
  801721:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801724:	89 c2                	mov    %eax,%edx
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	01 c2                	add    %eax,%edx
  80172b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	01 c8                	add    %ecx,%eax
  801733:	8a 00                	mov    (%eax),%al
  801735:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801737:	ff 45 f8             	incl   -0x8(%ebp)
  80173a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801740:	7c d9                	jl     80171b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801742:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801745:	8b 45 10             	mov    0x10(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	c6 00 00             	movb   $0x0,(%eax)
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801753:	8b 45 14             	mov    0x14(%ebp),%eax
  801756:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80175c:	8b 45 14             	mov    0x14(%ebp),%eax
  80175f:	8b 00                	mov    (%eax),%eax
  801761:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801768:	8b 45 10             	mov    0x10(%ebp),%eax
  80176b:	01 d0                	add    %edx,%eax
  80176d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801773:	eb 0c                	jmp    801781 <strsplit+0x31>
			*string++ = 0;
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8d 50 01             	lea    0x1(%eax),%edx
  80177b:	89 55 08             	mov    %edx,0x8(%ebp)
  80177e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	8a 00                	mov    (%eax),%al
  801786:	84 c0                	test   %al,%al
  801788:	74 18                	je     8017a2 <strsplit+0x52>
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	8a 00                	mov    (%eax),%al
  80178f:	0f be c0             	movsbl %al,%eax
  801792:	50                   	push   %eax
  801793:	ff 75 0c             	pushl  0xc(%ebp)
  801796:	e8 13 fb ff ff       	call   8012ae <strchr>
  80179b:	83 c4 08             	add    $0x8,%esp
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	75 d3                	jne    801775 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	8a 00                	mov    (%eax),%al
  8017a7:	84 c0                	test   %al,%al
  8017a9:	74 5a                	je     801805 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8017ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ae:	8b 00                	mov    (%eax),%eax
  8017b0:	83 f8 0f             	cmp    $0xf,%eax
  8017b3:	75 07                	jne    8017bc <strsplit+0x6c>
		{
			return 0;
  8017b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ba:	eb 66                	jmp    801822 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bf:	8b 00                	mov    (%eax),%eax
  8017c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8017c4:	8b 55 14             	mov    0x14(%ebp),%edx
  8017c7:	89 0a                	mov    %ecx,(%edx)
  8017c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d3:	01 c2                	add    %eax,%edx
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017da:	eb 03                	jmp    8017df <strsplit+0x8f>
			string++;
  8017dc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8a 00                	mov    (%eax),%al
  8017e4:	84 c0                	test   %al,%al
  8017e6:	74 8b                	je     801773 <strsplit+0x23>
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	0f be c0             	movsbl %al,%eax
  8017f0:	50                   	push   %eax
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	e8 b5 fa ff ff       	call   8012ae <strchr>
  8017f9:	83 c4 08             	add    $0x8,%esp
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	74 dc                	je     8017dc <strsplit+0x8c>
			string++;
	}
  801800:	e9 6e ff ff ff       	jmp    801773 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801805:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801806:	8b 45 14             	mov    0x14(%ebp),%eax
  801809:	8b 00                	mov    (%eax),%eax
  80180b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801812:	8b 45 10             	mov    0x10(%ebp),%eax
  801815:	01 d0                	add    %edx,%eax
  801817:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80181d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	57                   	push   %edi
  801828:	56                   	push   %esi
  801829:	53                   	push   %ebx
  80182a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	8b 55 0c             	mov    0xc(%ebp),%edx
  801833:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801836:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801839:	8b 7d 18             	mov    0x18(%ebp),%edi
  80183c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80183f:	cd 30                	int    $0x30
  801841:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801844:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	5b                   	pop    %ebx
  80184b:	5e                   	pop    %esi
  80184c:	5f                   	pop    %edi
  80184d:	5d                   	pop    %ebp
  80184e:	c3                   	ret    

0080184f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	50                   	push   %eax
  80185f:	6a 00                	push   $0x0
  801861:	e8 be ff ff ff       	call   801824 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	90                   	nop
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_cgetc>:

int
sys_cgetc(void)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 01                	push   $0x1
  80187b:	e8 a4 ff ff ff       	call   801824 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	50                   	push   %eax
  801894:	6a 03                	push   $0x3
  801896:	e8 89 ff ff ff       	call   801824 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 02                	push   $0x2
  8018af:	e8 70 ff ff ff       	call   801824 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_env_exit>:

void sys_env_exit(void)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 04                	push   $0x4
  8018c8:	e8 57 ff ff ff       	call   801824 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	90                   	nop
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 05                	push   $0x5
  8018e6:	e8 39 ff ff ff       	call   801824 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	56                   	push   %esi
  8018f4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018f5:	8b 75 18             	mov    0x18(%ebp),%esi
  8018f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	56                   	push   %esi
  801905:	53                   	push   %ebx
  801906:	51                   	push   %ecx
  801907:	52                   	push   %edx
  801908:	50                   	push   %eax
  801909:	6a 06                	push   $0x6
  80190b:	e8 14 ff ff ff       	call   801824 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801916:	5b                   	pop    %ebx
  801917:	5e                   	pop    %esi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80191d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	52                   	push   %edx
  80192a:	50                   	push   %eax
  80192b:	6a 07                	push   $0x7
  80192d:	e8 f2 fe ff ff       	call   801824 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	6a 08                	push   $0x8
  801948:	e8 d7 fe ff ff       	call   801824 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 09                	push   $0x9
  801961:	e8 be fe ff ff       	call   801824 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 0a                	push   $0xa
  80197a:	e8 a5 fe ff ff       	call   801824 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 0b                	push   $0xb
  801993:	e8 8c fe ff ff       	call   801824 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	6a 0d                	push   $0xd
  8019ae:	e8 71 fe ff ff       	call   801824 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
	return;
  8019b6:	90                   	nop
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	6a 0e                	push   $0xe
  8019ca:	e8 55 fe ff ff       	call   801824 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d2:	90                   	nop
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 0c                	push   $0xc
  8019e4:	e8 3b fe ff ff       	call   801824 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 10                	push   $0x10
  8019fd:	e8 22 fe ff ff       	call   801824 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	90                   	nop
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 11                	push   $0x11
  801a17:	e8 08 fe ff ff       	call   801824 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	90                   	nop
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a2e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	50                   	push   %eax
  801a3b:	6a 12                	push   $0x12
  801a3d:	e8 e2 fd ff ff       	call   801824 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	90                   	nop
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 13                	push   $0x13
  801a57:	e8 c8 fd ff ff       	call   801824 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	90                   	nop
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	ff 75 0c             	pushl  0xc(%ebp)
  801a71:	50                   	push   %eax
  801a72:	6a 14                	push   $0x14
  801a74:	e8 ab fd ff ff       	call   801824 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	50                   	push   %eax
  801a8d:	6a 17                	push   $0x17
  801a8f:	e8 90 fd ff ff       	call   801824 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	50                   	push   %eax
  801aa8:	6a 15                	push   $0x15
  801aaa:	e8 75 fd ff ff       	call   801824 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	50                   	push   %eax
  801ac4:	6a 16                	push   $0x16
  801ac6:	e8 59 fd ff ff       	call   801824 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 04             	sub    $0x4,%esp
  801ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  801ada:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  801add:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ae0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	6a 00                	push   $0x0
  801ae9:	51                   	push   %ecx
  801aea:	52                   	push   %edx
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	50                   	push   %eax
  801aef:	6a 18                	push   $0x18
  801af1:	e8 2e fd ff ff       	call   801824 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 19                	push   $0x19
  801b0e:	e8 11 fd ff ff       	call   801824 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	50                   	push   %eax
  801b27:	6a 1a                	push   $0x1a
  801b29:	e8 f6 fc ff ff       	call   801824 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 1b                	push   $0x1b
  801b42:	e8 dd fc ff ff       	call   801824 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 1c                	push   $0x1c
  801b5b:	e8 c4 fc ff ff       	call   801824 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	50                   	push   %eax
  801b75:	6a 1d                	push   $0x1d
  801b77:	e8 a8 fc ff ff       	call   801824 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	50                   	push   %eax
  801b90:	6a 1e                	push   $0x1e
  801b92:	e8 8d fc ff ff       	call   801824 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	90                   	nop
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	50                   	push   %eax
  801bac:	6a 1f                	push   $0x1f
  801bae:	e8 71 fc ff ff       	call   801824 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	90                   	nop
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bbf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc2:	8d 50 04             	lea    0x4(%eax),%edx
  801bc5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	6a 20                	push   $0x20
  801bd2:	e8 4d fc ff ff       	call   801824 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return result;
  801bda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be3:	89 01                	mov    %eax,(%ecx)
  801be5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	c9                   	leave  
  801bec:	c2 04 00             	ret    $0x4

00801bef <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 10             	pushl  0x10(%ebp)
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 0f                	push   $0xf
  801c01:	e8 1e fc ff ff       	call   801824 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 21                	push   $0x21
  801c1b:	e8 04 fc ff ff       	call   801824 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c31:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	50                   	push   %eax
  801c3e:	6a 22                	push   $0x22
  801c40:	e8 df fb ff ff       	call   801824 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
	return ;
  801c48:	90                   	nop
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <rsttst>:
void rsttst()
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 24                	push   $0x24
  801c5a:	e8 c5 fb ff ff       	call   801824 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c62:	90                   	nop
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c71:	8b 55 18             	mov    0x18(%ebp),%edx
  801c74:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c78:	52                   	push   %edx
  801c79:	50                   	push   %eax
  801c7a:	ff 75 10             	pushl  0x10(%ebp)
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	ff 75 08             	pushl  0x8(%ebp)
  801c83:	6a 23                	push   $0x23
  801c85:	e8 9a fb ff ff       	call   801824 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <chktst>:
void chktst(uint32 n)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	ff 75 08             	pushl  0x8(%ebp)
  801c9e:	6a 25                	push   $0x25
  801ca0:	e8 7f fb ff ff       	call   801824 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca8:	90                   	nop
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 26                	push   $0x26
  801cbd:	e8 62 fb ff ff       	call   801824 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
  801cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ccc:	75 07                	jne    801cd5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cce:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd3:	eb 05                	jmp    801cda <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 26                	push   $0x26
  801cee:	e8 31 fb ff ff       	call   801824 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
  801cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cfd:	75 07                	jne    801d06 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cff:	b8 01 00 00 00       	mov    $0x1,%eax
  801d04:	eb 05                	jmp    801d0b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 26                	push   $0x26
  801d1f:	e8 00 fb ff ff       	call   801824 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
  801d27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d2a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d2e:	75 07                	jne    801d37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d30:	b8 01 00 00 00       	mov    $0x1,%eax
  801d35:	eb 05                	jmp    801d3c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 26                	push   $0x26
  801d50:	e8 cf fa ff ff       	call   801824 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
  801d58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d5b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d5f:	75 07                	jne    801d68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d61:	b8 01 00 00 00       	mov    $0x1,%eax
  801d66:	eb 05                	jmp    801d6d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	ff 75 08             	pushl  0x8(%ebp)
  801d7d:	6a 27                	push   $0x27
  801d7f:	e8 a0 fa ff ff       	call   801824 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
	return ;
  801d87:	90                   	nop
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    
  801d8a:	66 90                	xchg   %ax,%ax

00801d8c <__udivdi3>:
  801d8c:	55                   	push   %ebp
  801d8d:	57                   	push   %edi
  801d8e:	56                   	push   %esi
  801d8f:	53                   	push   %ebx
  801d90:	83 ec 1c             	sub    $0x1c,%esp
  801d93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801da3:	89 ca                	mov    %ecx,%edx
  801da5:	89 f8                	mov    %edi,%eax
  801da7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801dab:	85 f6                	test   %esi,%esi
  801dad:	75 2d                	jne    801ddc <__udivdi3+0x50>
  801daf:	39 cf                	cmp    %ecx,%edi
  801db1:	77 65                	ja     801e18 <__udivdi3+0x8c>
  801db3:	89 fd                	mov    %edi,%ebp
  801db5:	85 ff                	test   %edi,%edi
  801db7:	75 0b                	jne    801dc4 <__udivdi3+0x38>
  801db9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbe:	31 d2                	xor    %edx,%edx
  801dc0:	f7 f7                	div    %edi
  801dc2:	89 c5                	mov    %eax,%ebp
  801dc4:	31 d2                	xor    %edx,%edx
  801dc6:	89 c8                	mov    %ecx,%eax
  801dc8:	f7 f5                	div    %ebp
  801dca:	89 c1                	mov    %eax,%ecx
  801dcc:	89 d8                	mov    %ebx,%eax
  801dce:	f7 f5                	div    %ebp
  801dd0:	89 cf                	mov    %ecx,%edi
  801dd2:	89 fa                	mov    %edi,%edx
  801dd4:	83 c4 1c             	add    $0x1c,%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5f                   	pop    %edi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    
  801ddc:	39 ce                	cmp    %ecx,%esi
  801dde:	77 28                	ja     801e08 <__udivdi3+0x7c>
  801de0:	0f bd fe             	bsr    %esi,%edi
  801de3:	83 f7 1f             	xor    $0x1f,%edi
  801de6:	75 40                	jne    801e28 <__udivdi3+0x9c>
  801de8:	39 ce                	cmp    %ecx,%esi
  801dea:	72 0a                	jb     801df6 <__udivdi3+0x6a>
  801dec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801df0:	0f 87 9e 00 00 00    	ja     801e94 <__udivdi3+0x108>
  801df6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfb:	89 fa                	mov    %edi,%edx
  801dfd:	83 c4 1c             	add    $0x1c,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    
  801e05:	8d 76 00             	lea    0x0(%esi),%esi
  801e08:	31 ff                	xor    %edi,%edi
  801e0a:	31 c0                	xor    %eax,%eax
  801e0c:	89 fa                	mov    %edi,%edx
  801e0e:	83 c4 1c             	add    $0x1c,%esp
  801e11:	5b                   	pop    %ebx
  801e12:	5e                   	pop    %esi
  801e13:	5f                   	pop    %edi
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	89 d8                	mov    %ebx,%eax
  801e1a:	f7 f7                	div    %edi
  801e1c:	31 ff                	xor    %edi,%edi
  801e1e:	89 fa                	mov    %edi,%edx
  801e20:	83 c4 1c             	add    $0x1c,%esp
  801e23:	5b                   	pop    %ebx
  801e24:	5e                   	pop    %esi
  801e25:	5f                   	pop    %edi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    
  801e28:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e2d:	89 eb                	mov    %ebp,%ebx
  801e2f:	29 fb                	sub    %edi,%ebx
  801e31:	89 f9                	mov    %edi,%ecx
  801e33:	d3 e6                	shl    %cl,%esi
  801e35:	89 c5                	mov    %eax,%ebp
  801e37:	88 d9                	mov    %bl,%cl
  801e39:	d3 ed                	shr    %cl,%ebp
  801e3b:	89 e9                	mov    %ebp,%ecx
  801e3d:	09 f1                	or     %esi,%ecx
  801e3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e43:	89 f9                	mov    %edi,%ecx
  801e45:	d3 e0                	shl    %cl,%eax
  801e47:	89 c5                	mov    %eax,%ebp
  801e49:	89 d6                	mov    %edx,%esi
  801e4b:	88 d9                	mov    %bl,%cl
  801e4d:	d3 ee                	shr    %cl,%esi
  801e4f:	89 f9                	mov    %edi,%ecx
  801e51:	d3 e2                	shl    %cl,%edx
  801e53:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e57:	88 d9                	mov    %bl,%cl
  801e59:	d3 e8                	shr    %cl,%eax
  801e5b:	09 c2                	or     %eax,%edx
  801e5d:	89 d0                	mov    %edx,%eax
  801e5f:	89 f2                	mov    %esi,%edx
  801e61:	f7 74 24 0c          	divl   0xc(%esp)
  801e65:	89 d6                	mov    %edx,%esi
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	f7 e5                	mul    %ebp
  801e6b:	39 d6                	cmp    %edx,%esi
  801e6d:	72 19                	jb     801e88 <__udivdi3+0xfc>
  801e6f:	74 0b                	je     801e7c <__udivdi3+0xf0>
  801e71:	89 d8                	mov    %ebx,%eax
  801e73:	31 ff                	xor    %edi,%edi
  801e75:	e9 58 ff ff ff       	jmp    801dd2 <__udivdi3+0x46>
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e80:	89 f9                	mov    %edi,%ecx
  801e82:	d3 e2                	shl    %cl,%edx
  801e84:	39 c2                	cmp    %eax,%edx
  801e86:	73 e9                	jae    801e71 <__udivdi3+0xe5>
  801e88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e8b:	31 ff                	xor    %edi,%edi
  801e8d:	e9 40 ff ff ff       	jmp    801dd2 <__udivdi3+0x46>
  801e92:	66 90                	xchg   %ax,%ax
  801e94:	31 c0                	xor    %eax,%eax
  801e96:	e9 37 ff ff ff       	jmp    801dd2 <__udivdi3+0x46>
  801e9b:	90                   	nop

00801e9c <__umoddi3>:
  801e9c:	55                   	push   %ebp
  801e9d:	57                   	push   %edi
  801e9e:	56                   	push   %esi
  801e9f:	53                   	push   %ebx
  801ea0:	83 ec 1c             	sub    $0x1c,%esp
  801ea3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ea7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eaf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801eb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ebb:	89 f3                	mov    %esi,%ebx
  801ebd:	89 fa                	mov    %edi,%edx
  801ebf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec3:	89 34 24             	mov    %esi,(%esp)
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	75 1a                	jne    801ee4 <__umoddi3+0x48>
  801eca:	39 f7                	cmp    %esi,%edi
  801ecc:	0f 86 a2 00 00 00    	jbe    801f74 <__umoddi3+0xd8>
  801ed2:	89 c8                	mov    %ecx,%eax
  801ed4:	89 f2                	mov    %esi,%edx
  801ed6:	f7 f7                	div    %edi
  801ed8:	89 d0                	mov    %edx,%eax
  801eda:	31 d2                	xor    %edx,%edx
  801edc:	83 c4 1c             	add    $0x1c,%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5e                   	pop    %esi
  801ee1:	5f                   	pop    %edi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    
  801ee4:	39 f0                	cmp    %esi,%eax
  801ee6:	0f 87 ac 00 00 00    	ja     801f98 <__umoddi3+0xfc>
  801eec:	0f bd e8             	bsr    %eax,%ebp
  801eef:	83 f5 1f             	xor    $0x1f,%ebp
  801ef2:	0f 84 ac 00 00 00    	je     801fa4 <__umoddi3+0x108>
  801ef8:	bf 20 00 00 00       	mov    $0x20,%edi
  801efd:	29 ef                	sub    %ebp,%edi
  801eff:	89 fe                	mov    %edi,%esi
  801f01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f05:	89 e9                	mov    %ebp,%ecx
  801f07:	d3 e0                	shl    %cl,%eax
  801f09:	89 d7                	mov    %edx,%edi
  801f0b:	89 f1                	mov    %esi,%ecx
  801f0d:	d3 ef                	shr    %cl,%edi
  801f0f:	09 c7                	or     %eax,%edi
  801f11:	89 e9                	mov    %ebp,%ecx
  801f13:	d3 e2                	shl    %cl,%edx
  801f15:	89 14 24             	mov    %edx,(%esp)
  801f18:	89 d8                	mov    %ebx,%eax
  801f1a:	d3 e0                	shl    %cl,%eax
  801f1c:	89 c2                	mov    %eax,%edx
  801f1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f22:	d3 e0                	shl    %cl,%eax
  801f24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f2c:	89 f1                	mov    %esi,%ecx
  801f2e:	d3 e8                	shr    %cl,%eax
  801f30:	09 d0                	or     %edx,%eax
  801f32:	d3 eb                	shr    %cl,%ebx
  801f34:	89 da                	mov    %ebx,%edx
  801f36:	f7 f7                	div    %edi
  801f38:	89 d3                	mov    %edx,%ebx
  801f3a:	f7 24 24             	mull   (%esp)
  801f3d:	89 c6                	mov    %eax,%esi
  801f3f:	89 d1                	mov    %edx,%ecx
  801f41:	39 d3                	cmp    %edx,%ebx
  801f43:	0f 82 87 00 00 00    	jb     801fd0 <__umoddi3+0x134>
  801f49:	0f 84 91 00 00 00    	je     801fe0 <__umoddi3+0x144>
  801f4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f53:	29 f2                	sub    %esi,%edx
  801f55:	19 cb                	sbb    %ecx,%ebx
  801f57:	89 d8                	mov    %ebx,%eax
  801f59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f5d:	d3 e0                	shl    %cl,%eax
  801f5f:	89 e9                	mov    %ebp,%ecx
  801f61:	d3 ea                	shr    %cl,%edx
  801f63:	09 d0                	or     %edx,%eax
  801f65:	89 e9                	mov    %ebp,%ecx
  801f67:	d3 eb                	shr    %cl,%ebx
  801f69:	89 da                	mov    %ebx,%edx
  801f6b:	83 c4 1c             	add    $0x1c,%esp
  801f6e:	5b                   	pop    %ebx
  801f6f:	5e                   	pop    %esi
  801f70:	5f                   	pop    %edi
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    
  801f73:	90                   	nop
  801f74:	89 fd                	mov    %edi,%ebp
  801f76:	85 ff                	test   %edi,%edi
  801f78:	75 0b                	jne    801f85 <__umoddi3+0xe9>
  801f7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7f:	31 d2                	xor    %edx,%edx
  801f81:	f7 f7                	div    %edi
  801f83:	89 c5                	mov    %eax,%ebp
  801f85:	89 f0                	mov    %esi,%eax
  801f87:	31 d2                	xor    %edx,%edx
  801f89:	f7 f5                	div    %ebp
  801f8b:	89 c8                	mov    %ecx,%eax
  801f8d:	f7 f5                	div    %ebp
  801f8f:	89 d0                	mov    %edx,%eax
  801f91:	e9 44 ff ff ff       	jmp    801eda <__umoddi3+0x3e>
  801f96:	66 90                	xchg   %ax,%ax
  801f98:	89 c8                	mov    %ecx,%eax
  801f9a:	89 f2                	mov    %esi,%edx
  801f9c:	83 c4 1c             	add    $0x1c,%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    
  801fa4:	3b 04 24             	cmp    (%esp),%eax
  801fa7:	72 06                	jb     801faf <__umoddi3+0x113>
  801fa9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fad:	77 0f                	ja     801fbe <__umoddi3+0x122>
  801faf:	89 f2                	mov    %esi,%edx
  801fb1:	29 f9                	sub    %edi,%ecx
  801fb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fb7:	89 14 24             	mov    %edx,(%esp)
  801fba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fc2:	8b 14 24             	mov    (%esp),%edx
  801fc5:	83 c4 1c             	add    $0x1c,%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5e                   	pop    %esi
  801fca:	5f                   	pop    %edi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    
  801fcd:	8d 76 00             	lea    0x0(%esi),%esi
  801fd0:	2b 04 24             	sub    (%esp),%eax
  801fd3:	19 fa                	sbb    %edi,%edx
  801fd5:	89 d1                	mov    %edx,%ecx
  801fd7:	89 c6                	mov    %eax,%esi
  801fd9:	e9 71 ff ff ff       	jmp    801f4f <__umoddi3+0xb3>
  801fde:	66 90                	xchg   %ax,%ax
  801fe0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fe4:	72 ea                	jb     801fd0 <__umoddi3+0x134>
  801fe6:	89 d9                	mov    %ebx,%ecx
  801fe8:	e9 62 ff ff ff       	jmp    801f4f <__umoddi3+0xb3>
