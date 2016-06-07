
obj/user/tst_page_replacement_lru:     file format elf32-i386


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
  800031:	e8 83 04 00 00       	call   8004b9 <libmain>
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
  80003e:	e8 61 14 00 00       	call   8014a4 <sys_getenvid>
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
  800088:	68 00 1c 80 00       	push   $0x801c00
  80008d:	6a 15                	push   $0x15
  80008f:	68 44 1c 80 00       	push   $0x801c44
  800094:	e8 e1 04 00 00       	call   80057a <_panic>
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
  8000bc:	68 00 1c 80 00       	push   $0x801c00
  8000c1:	6a 16                	push   $0x16
  8000c3:	68 44 1c 80 00       	push   $0x801c44
  8000c8:	e8 ad 04 00 00       	call   80057a <_panic>
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
  8000f0:	68 00 1c 80 00       	push   $0x801c00
  8000f5:	6a 17                	push   $0x17
  8000f7:	68 44 1c 80 00       	push   $0x801c44
  8000fc:	e8 79 04 00 00       	call   80057a <_panic>
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
  800124:	68 00 1c 80 00       	push   $0x801c00
  800129:	6a 18                	push   $0x18
  80012b:	68 44 1c 80 00       	push   $0x801c44
  800130:	e8 45 04 00 00       	call   80057a <_panic>
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
  800158:	68 00 1c 80 00       	push   $0x801c00
  80015d:	6a 19                	push   $0x19
  80015f:	68 44 1c 80 00       	push   $0x801c44
  800164:	e8 11 04 00 00       	call   80057a <_panic>
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
  80018c:	68 00 1c 80 00       	push   $0x801c00
  800191:	6a 1a                	push   $0x1a
  800193:	68 44 1c 80 00       	push   $0x801c44
  800198:	e8 dd 03 00 00       	call   80057a <_panic>
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
  8001c0:	68 00 1c 80 00       	push   $0x801c00
  8001c5:	6a 1b                	push   $0x1b
  8001c7:	68 44 1c 80 00       	push   $0x801c44
  8001cc:	e8 a9 03 00 00       	call   80057a <_panic>
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
  8001f4:	68 00 1c 80 00       	push   $0x801c00
  8001f9:	6a 1c                	push   $0x1c
  8001fb:	68 44 1c 80 00       	push   $0x801c44
  800200:	e8 75 03 00 00       	call   80057a <_panic>
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
  800228:	68 00 1c 80 00       	push   $0x801c00
  80022d:	6a 1d                	push   $0x1d
  80022f:	68 44 1c 80 00       	push   $0x801c44
  800234:	e8 41 03 00 00       	call   80057a <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  800242:	85 c0                	test   %eax,%eax
  800244:	74 14                	je     80025a <_main+0x222>
  800246:	83 ec 04             	sub    $0x4,%esp
  800249:	68 64 1c 80 00       	push   $0x801c64
  80024e:	6a 1e                	push   $0x1e
  800250:	68 44 1c 80 00       	push   $0x801c44
  800255:	e8 20 03 00 00       	call   80057a <_panic>




	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  80025a:	a0 1f e0 80 00       	mov    0x80e01f,%al
  80025f:	88 45 c7             	mov    %al,-0x39(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  800262:	a0 1f f0 80 00       	mov    0x80f01f,%al
  800267:	88 45 c6             	mov    %al,-0x3a(%ebp)


	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80026a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800271:	eb 37                	jmp    8002aa <_main+0x272>
	{
		arr[i] = -1 ;
  800273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800276:	05 20 30 80 00       	add    $0x803020,%eax
  80027b:	c6 00 ff             	movb   $0xff,(%eax)
		*ptr = *ptr2 ;
  80027e:	a1 00 30 80 00       	mov    0x803000,%eax
  800283:	8b 15 04 30 80 00    	mov    0x803004,%edx
  800289:	8a 12                	mov    (%edx),%dl
  80028b:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  80028d:	a1 00 30 80 00       	mov    0x803000,%eax
  800292:	40                   	inc    %eax
  800293:	a3 00 30 80 00       	mov    %eax,0x803000
  800298:	a1 04 30 80 00       	mov    0x803004,%eax
  80029d:	40                   	inc    %eax
  80029e:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = arr[PAGE_SIZE*12-1] ;


	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002a3:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8002aa:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8002b1:	7e c0                	jle    800273 <_main+0x23b>
	//===================


	//cprintf("Checking PAGE LRU algorithm... \n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0x80b000)  panic("Page LRU algo failed.. trace it by printing WS before and after page fault");
  8002b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b6:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8002bc:	8b 00                	mov    (%eax),%eax
  8002be:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8002c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c9:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  8002ce:	74 14                	je     8002e4 <_main+0x2ac>
  8002d0:	83 ec 04             	sub    $0x4,%esp
  8002d3:	68 ac 1c 80 00       	push   $0x801cac
  8002d8:	6a 37                	push   $0x37
  8002da:	68 44 1c 80 00       	push   $0x801c44
  8002df:	e8 96 02 00 00       	call   80057a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80c000)  panic("Page LRU algo failed.. trace it by printing WS before and after page fault");
  8002e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e7:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8002ed:	83 c0 0c             	add    $0xc,%eax
  8002f0:	8b 00                	mov    (%eax),%eax
  8002f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8002f5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002fd:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800302:	74 14                	je     800318 <_main+0x2e0>
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	68 ac 1c 80 00       	push   $0x801cac
  80030c:	6a 38                	push   $0x38
  80030e:	68 44 1c 80 00       	push   $0x801c44
  800313:	e8 62 02 00 00       	call   80057a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page LRU algo failed.. trace it by printing WS before and after page fault");
  800318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80031b:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800321:	83 c0 18             	add    $0x18,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800329:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80032c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800331:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800336:	74 14                	je     80034c <_main+0x314>
  800338:	83 ec 04             	sub    $0x4,%esp
  80033b:	68 ac 1c 80 00       	push   $0x801cac
  800340:	6a 39                	push   $0x39
  800342:	68 44 1c 80 00       	push   $0x801c44
  800347:	e8 2e 02 00 00       	call   80057a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page LRU algo failed.. trace it by printing WS before and after page fault");
  80034c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034f:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800355:	83 c0 24             	add    $0x24,%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80035d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800360:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800365:	3d 00 40 80 00       	cmp    $0x804000,%eax
  80036a:	74 14                	je     800380 <_main+0x348>
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	68 ac 1c 80 00       	push   $0x801cac
  800374:	6a 3a                	push   $0x3a
  800376:	68 44 1c 80 00       	push   $0x801c44
  80037b:	e8 fa 01 00 00       	call   80057a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x809000)  panic("Page LRU algo failed.. trace it by printing WS before and after page fault");
  800380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800383:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800389:	83 c0 30             	add    $0x30,%eax
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800391:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800394:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800399:	3d 00 90 80 00       	cmp    $0x809000,%eax
  80039e:	74 14                	je     8003b4 <_main+0x37c>
  8003a0:	83 ec 04             	sub    $0x4,%esp
  8003a3:	68 ac 1c 80 00       	push   $0x801cac
  8003a8:	6a 3b                	push   $0x3b
  8003aa:	68 44 1c 80 00       	push   $0x801c44
  8003af:	e8 c6 01 00 00       	call   80057a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("Page LRU algo failed.. trace it by printing WS before and after page fault");
  8003b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003b7:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8003bd:	83 c0 3c             	add    $0x3c,%eax
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8003c5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003cd:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  8003d2:	74 14                	je     8003e8 <_main+0x3b0>
  8003d4:	83 ec 04             	sub    $0x4,%esp
  8003d7:	68 ac 1c 80 00       	push   $0x801cac
  8003dc:	6a 3c                	push   $0x3c
  8003de:	68 44 1c 80 00       	push   $0x801c44
  8003e3:	e8 92 01 00 00       	call   80057a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page LRU algo failed.. trace it by printing WS before and after page fault");
  8003e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003eb:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8003f1:	83 c0 48             	add    $0x48,%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8003f9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800401:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800406:	74 14                	je     80041c <_main+0x3e4>
  800408:	83 ec 04             	sub    $0x4,%esp
  80040b:	68 ac 1c 80 00       	push   $0x801cac
  800410:	6a 3d                	push   $0x3d
  800412:	68 44 1c 80 00       	push   $0x801c44
  800417:	e8 5e 01 00 00       	call   80057a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page LRU algo failed.. trace it by printing WS before and after page fault");
  80041c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80041f:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800425:	83 c0 54             	add    $0x54,%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80042d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800430:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800435:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80043a:	74 14                	je     800450 <_main+0x418>
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	68 ac 1c 80 00       	push   $0x801cac
  800444:	6a 3e                	push   $0x3e
  800446:	68 44 1c 80 00       	push   $0x801c44
  80044b:	e8 2a 01 00 00       	call   80057a <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page LRU algo failed.. trace it by printing WS before and after page fault");
  800450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800453:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800459:	83 c0 60             	add    $0x60,%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800461:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800464:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800469:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80046e:	74 14                	je     800484 <_main+0x44c>
  800470:	83 ec 04             	sub    $0x4,%esp
  800473:	68 ac 1c 80 00       	push   $0x801cac
  800478:	6a 3f                	push   $0x3f
  80047a:	68 44 1c 80 00       	push   $0x801c44
  80047f:	e8 f6 00 00 00       	call   80057a <_panic>


		if(myEnv->page_last_WS_index != 2) panic("wrong PAGE WS pointer location");
  800484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800487:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  80048d:	83 f8 02             	cmp    $0x2,%eax
  800490:	74 14                	je     8004a6 <_main+0x46e>
  800492:	83 ec 04             	sub    $0x4,%esp
  800495:	68 f8 1c 80 00       	push   $0x801cf8
  80049a:	6a 42                	push   $0x42
  80049c:	68 44 1c 80 00       	push   $0x801c44
  8004a1:	e8 d4 00 00 00       	call   80057a <_panic>


	}

	cprintf("Congratulations!! test PAGE replacement [LRU Alg.] is completed successfully.\n");
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	68 18 1d 80 00       	push   $0x801d18
  8004ae:	e8 f2 01 00 00       	call   8006a5 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
	return;
  8004b6:	90                   	nop
}
  8004b7:	c9                   	leave  
  8004b8:	c3                   	ret    

008004b9 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c3:	7e 0a                	jle    8004cf <libmain+0x16>
		binaryname = argv[0];
  8004c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 5b fb ff ff       	call   800038 <_main>
  8004dd:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8004e0:	e8 bf 0f 00 00       	call   8014a4 <sys_getenvid>
  8004e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  8004e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004eb:	89 d0                	mov    %edx,%eax
  8004ed:	c1 e0 03             	shl    $0x3,%eax
  8004f0:	01 d0                	add    %edx,%eax
  8004f2:	01 c0                	add    %eax,%eax
  8004f4:	01 d0                	add    %edx,%eax
  8004f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	c1 e0 03             	shl    $0x3,%eax
  800502:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800507:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  80050a:	e8 e3 10 00 00       	call   8015f2 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80050f:	83 ec 0c             	sub    $0xc,%esp
  800512:	68 80 1d 80 00       	push   $0x801d80
  800517:	e8 89 01 00 00       	call   8006a5 <cprintf>
  80051c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800522:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	50                   	push   %eax
  80052c:	68 a8 1d 80 00       	push   $0x801da8
  800531:	e8 6f 01 00 00       	call   8006a5 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	68 80 1d 80 00       	push   $0x801d80
  800541:	e8 5f 01 00 00       	call   8006a5 <cprintf>
  800546:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800549:	e8 be 10 00 00       	call   80160c <sys_enable_interrupt>

	// exit gracefully
	exit();
  80054e:	e8 19 00 00 00       	call   80056c <exit>
}
  800553:	90                   	nop
  800554:	c9                   	leave  
  800555:	c3                   	ret    

00800556 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	6a 00                	push   $0x0
  800561:	e8 23 0f 00 00       	call   801489 <sys_env_destroy>
  800566:	83 c4 10             	add    $0x10,%esp
}
  800569:	90                   	nop
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <exit>:

void
exit(void)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800572:	e8 46 0f 00 00       	call   8014bd <sys_env_exit>
}
  800577:	90                   	nop
  800578:	c9                   	leave  
  800579:	c3                   	ret    

0080057a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80057a:	55                   	push   %ebp
  80057b:	89 e5                	mov    %esp,%ebp
  80057d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800580:	8d 45 10             	lea    0x10(%ebp),%eax
  800583:	83 c0 04             	add    $0x4,%eax
  800586:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800589:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  80058e:	85 c0                	test   %eax,%eax
  800590:	74 16                	je     8005a8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800592:	a1 2c f0 80 00       	mov    0x80f02c,%eax
  800597:	83 ec 08             	sub    $0x8,%esp
  80059a:	50                   	push   %eax
  80059b:	68 c1 1d 80 00       	push   $0x801dc1
  8005a0:	e8 00 01 00 00       	call   8006a5 <cprintf>
  8005a5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005a8:	a1 08 30 80 00       	mov    0x803008,%eax
  8005ad:	ff 75 0c             	pushl  0xc(%ebp)
  8005b0:	ff 75 08             	pushl  0x8(%ebp)
  8005b3:	50                   	push   %eax
  8005b4:	68 c6 1d 80 00       	push   $0x801dc6
  8005b9:	e8 e7 00 00 00       	call   8006a5 <cprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ca:	50                   	push   %eax
  8005cb:	e8 7a 00 00 00       	call   80064a <vcprintf>
  8005d0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  8005d3:	83 ec 0c             	sub    $0xc,%esp
  8005d6:	68 e2 1d 80 00       	push   $0x801de2
  8005db:	e8 c5 00 00 00       	call   8006a5 <cprintf>
  8005e0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005e3:	e8 84 ff ff ff       	call   80056c <exit>

	// should not return here
	while (1) ;
  8005e8:	eb fe                	jmp    8005e8 <_panic+0x6e>

008005ea <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	8d 48 01             	lea    0x1(%eax),%ecx
  8005f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fb:	89 0a                	mov    %ecx,(%edx)
  8005fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800600:	88 d1                	mov    %dl,%cl
  800602:	8b 55 0c             	mov    0xc(%ebp),%edx
  800605:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800613:	75 23                	jne    800638 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800615:	8b 45 0c             	mov    0xc(%ebp),%eax
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	89 c2                	mov    %eax,%edx
  80061c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061f:	83 c0 08             	add    $0x8,%eax
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	52                   	push   %edx
  800626:	50                   	push   %eax
  800627:	e8 27 0e 00 00       	call   801453 <sys_cputs>
  80062c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 40 04             	mov    0x4(%eax),%eax
  80063e:	8d 50 01             	lea    0x1(%eax),%edx
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	89 50 04             	mov    %edx,0x4(%eax)
}
  800647:	90                   	nop
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
  80064d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800653:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80065a:	00 00 00 
	b.cnt = 0;
  80065d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800664:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800667:	ff 75 0c             	pushl  0xc(%ebp)
  80066a:	ff 75 08             	pushl  0x8(%ebp)
  80066d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800673:	50                   	push   %eax
  800674:	68 ea 05 80 00       	push   $0x8005ea
  800679:	e8 fa 01 00 00       	call   800878 <vprintfmt>
  80067e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800681:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	50                   	push   %eax
  80068b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800691:	83 c0 08             	add    $0x8,%eax
  800694:	50                   	push   %eax
  800695:	e8 b9 0d 00 00       	call   801453 <sys_cputs>
  80069a:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80069d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006ab:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ba:	50                   	push   %eax
  8006bb:	e8 8a ff ff ff       	call   80064a <vcprintf>
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006c9:	c9                   	leave  
  8006ca:	c3                   	ret    

008006cb <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006d1:	e8 1c 0f 00 00       	call   8015f2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e5:	50                   	push   %eax
  8006e6:	e8 5f ff ff ff       	call   80064a <vcprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006f1:	e8 16 0f 00 00       	call   80160c <sys_enable_interrupt>
	return cnt;
  8006f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	53                   	push   %ebx
  8006ff:	83 ec 14             	sub    $0x14,%esp
  800702:	8b 45 10             	mov    0x10(%ebp),%eax
  800705:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80070e:	8b 45 18             	mov    0x18(%ebp),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
  800716:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800719:	77 55                	ja     800770 <printnum+0x75>
  80071b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80071e:	72 05                	jb     800725 <printnum+0x2a>
  800720:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800723:	77 4b                	ja     800770 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800725:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800728:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80072b:	8b 45 18             	mov    0x18(%ebp),%eax
  80072e:	ba 00 00 00 00       	mov    $0x0,%edx
  800733:	52                   	push   %edx
  800734:	50                   	push   %eax
  800735:	ff 75 f4             	pushl  -0xc(%ebp)
  800738:	ff 75 f0             	pushl  -0x10(%ebp)
  80073b:	e8 50 12 00 00       	call   801990 <__udivdi3>
  800740:	83 c4 10             	add    $0x10,%esp
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	ff 75 20             	pushl  0x20(%ebp)
  800749:	53                   	push   %ebx
  80074a:	ff 75 18             	pushl  0x18(%ebp)
  80074d:	52                   	push   %edx
  80074e:	50                   	push   %eax
  80074f:	ff 75 0c             	pushl  0xc(%ebp)
  800752:	ff 75 08             	pushl  0x8(%ebp)
  800755:	e8 a1 ff ff ff       	call   8006fb <printnum>
  80075a:	83 c4 20             	add    $0x20,%esp
  80075d:	eb 1a                	jmp    800779 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	ff 75 20             	pushl  0x20(%ebp)
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	ff d0                	call   *%eax
  80076d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800770:	ff 4d 1c             	decl   0x1c(%ebp)
  800773:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800777:	7f e6                	jg     80075f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800779:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80077c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800784:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800787:	53                   	push   %ebx
  800788:	51                   	push   %ecx
  800789:	52                   	push   %edx
  80078a:	50                   	push   %eax
  80078b:	e8 10 13 00 00       	call   801aa0 <__umoddi3>
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	05 14 20 80 00       	add    $0x802014,%eax
  800798:	8a 00                	mov    (%eax),%al
  80079a:	0f be c0             	movsbl %al,%eax
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	50                   	push   %eax
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	ff d0                	call   *%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
}
  8007ac:	90                   	nop
  8007ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b0:	c9                   	leave  
  8007b1:	c3                   	ret    

008007b2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b9:	7e 1c                	jle    8007d7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	8d 50 08             	lea    0x8(%eax),%edx
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	89 10                	mov    %edx,(%eax)
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	83 e8 08             	sub    $0x8,%eax
  8007d0:	8b 50 04             	mov    0x4(%eax),%edx
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	eb 40                	jmp    800817 <getuint+0x65>
	else if (lflag)
  8007d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007db:	74 1e                	je     8007fb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	8d 50 04             	lea    0x4(%eax),%edx
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	89 10                	mov    %edx,(%eax)
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	83 e8 04             	sub    $0x4,%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f9:	eb 1c                	jmp    800817 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	8d 50 04             	lea    0x4(%eax),%edx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	89 10                	mov    %edx,(%eax)
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	83 e8 04             	sub    $0x4,%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80081c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800820:	7e 1c                	jle    80083e <getint+0x25>
		return va_arg(*ap, long long);
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	8d 50 08             	lea    0x8(%eax),%edx
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	89 10                	mov    %edx,(%eax)
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	83 e8 08             	sub    $0x8,%eax
  800837:	8b 50 04             	mov    0x4(%eax),%edx
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	eb 38                	jmp    800876 <getint+0x5d>
	else if (lflag)
  80083e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800842:	74 1a                	je     80085e <getint+0x45>
		return va_arg(*ap, long);
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	8d 50 04             	lea    0x4(%eax),%edx
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	89 10                	mov    %edx,(%eax)
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	83 e8 04             	sub    $0x4,%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	99                   	cltd   
  80085c:	eb 18                	jmp    800876 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	8d 50 04             	lea    0x4(%eax),%edx
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	89 10                	mov    %edx,(%eax)
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	83 e8 04             	sub    $0x4,%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	99                   	cltd   
}
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	56                   	push   %esi
  80087c:	53                   	push   %ebx
  80087d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800880:	eb 17                	jmp    800899 <vprintfmt+0x21>
			if (ch == '\0')
  800882:	85 db                	test   %ebx,%ebx
  800884:	0f 84 af 03 00 00    	je     800c39 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	53                   	push   %ebx
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	ff d0                	call   *%eax
  800896:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800899:	8b 45 10             	mov    0x10(%ebp),%eax
  80089c:	8d 50 01             	lea    0x1(%eax),%edx
  80089f:	89 55 10             	mov    %edx,0x10(%ebp)
  8008a2:	8a 00                	mov    (%eax),%al
  8008a4:	0f b6 d8             	movzbl %al,%ebx
  8008a7:	83 fb 25             	cmp    $0x25,%ebx
  8008aa:	75 d6                	jne    800882 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ac:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008b0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008b7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008c5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cf:	8d 50 01             	lea    0x1(%eax),%edx
  8008d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8008d5:	8a 00                	mov    (%eax),%al
  8008d7:	0f b6 d8             	movzbl %al,%ebx
  8008da:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008dd:	83 f8 55             	cmp    $0x55,%eax
  8008e0:	0f 87 2b 03 00 00    	ja     800c11 <vprintfmt+0x399>
  8008e6:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  8008ed:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008ef:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008f3:	eb d7                	jmp    8008cc <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008f9:	eb d1                	jmp    8008cc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800902:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800905:	89 d0                	mov    %edx,%eax
  800907:	c1 e0 02             	shl    $0x2,%eax
  80090a:	01 d0                	add    %edx,%eax
  80090c:	01 c0                	add    %eax,%eax
  80090e:	01 d8                	add    %ebx,%eax
  800910:	83 e8 30             	sub    $0x30,%eax
  800913:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800916:	8b 45 10             	mov    0x10(%ebp),%eax
  800919:	8a 00                	mov    (%eax),%al
  80091b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80091e:	83 fb 2f             	cmp    $0x2f,%ebx
  800921:	7e 3e                	jle    800961 <vprintfmt+0xe9>
  800923:	83 fb 39             	cmp    $0x39,%ebx
  800926:	7f 39                	jg     800961 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800928:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80092b:	eb d5                	jmp    800902 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	83 c0 04             	add    $0x4,%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
  800936:	8b 45 14             	mov    0x14(%ebp),%eax
  800939:	83 e8 04             	sub    $0x4,%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800941:	eb 1f                	jmp    800962 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800943:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800947:	79 83                	jns    8008cc <vprintfmt+0x54>
				width = 0;
  800949:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800950:	e9 77 ff ff ff       	jmp    8008cc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800955:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80095c:	e9 6b ff ff ff       	jmp    8008cc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800961:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800962:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800966:	0f 89 60 ff ff ff    	jns    8008cc <vprintfmt+0x54>
				width = precision, precision = -1;
  80096c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80096f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800972:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800979:	e9 4e ff ff ff       	jmp    8008cc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80097e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800981:	e9 46 ff ff ff       	jmp    8008cc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	83 c0 04             	add    $0x4,%eax
  80098c:	89 45 14             	mov    %eax,0x14(%ebp)
  80098f:	8b 45 14             	mov    0x14(%ebp),%eax
  800992:	83 e8 04             	sub    $0x4,%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	50                   	push   %eax
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
			break;
  8009a6:	e9 89 02 00 00       	jmp    800c34 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	83 c0 04             	add    $0x4,%eax
  8009b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	83 e8 04             	sub    $0x4,%eax
  8009ba:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009bc:	85 db                	test   %ebx,%ebx
  8009be:	79 02                	jns    8009c2 <vprintfmt+0x14a>
				err = -err;
  8009c0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009c2:	83 fb 64             	cmp    $0x64,%ebx
  8009c5:	7f 0b                	jg     8009d2 <vprintfmt+0x15a>
  8009c7:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  8009ce:	85 f6                	test   %esi,%esi
  8009d0:	75 19                	jne    8009eb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009d2:	53                   	push   %ebx
  8009d3:	68 25 20 80 00       	push   $0x802025
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	e8 5e 02 00 00       	call   800c41 <printfmt>
  8009e3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009e6:	e9 49 02 00 00       	jmp    800c34 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009eb:	56                   	push   %esi
  8009ec:	68 2e 20 80 00       	push   $0x80202e
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	e8 45 02 00 00       	call   800c41 <printfmt>
  8009fc:	83 c4 10             	add    $0x10,%esp
			break;
  8009ff:	e9 30 02 00 00       	jmp    800c34 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	83 e8 04             	sub    $0x4,%eax
  800a13:	8b 30                	mov    (%eax),%esi
  800a15:	85 f6                	test   %esi,%esi
  800a17:	75 05                	jne    800a1e <vprintfmt+0x1a6>
				p = "(null)";
  800a19:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  800a1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a22:	7e 6d                	jle    800a91 <vprintfmt+0x219>
  800a24:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a28:	74 67                	je     800a91 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	50                   	push   %eax
  800a31:	56                   	push   %esi
  800a32:	e8 0c 03 00 00       	call   800d43 <strnlen>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a3d:	eb 16                	jmp    800a55 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a3f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	50                   	push   %eax
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a52:	ff 4d e4             	decl   -0x1c(%ebp)
  800a55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a59:	7f e4                	jg     800a3f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5b:	eb 34                	jmp    800a91 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a5d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a61:	74 1c                	je     800a7f <vprintfmt+0x207>
  800a63:	83 fb 1f             	cmp    $0x1f,%ebx
  800a66:	7e 05                	jle    800a6d <vprintfmt+0x1f5>
  800a68:	83 fb 7e             	cmp    $0x7e,%ebx
  800a6b:	7e 12                	jle    800a7f <vprintfmt+0x207>
					putch('?', putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	6a 3f                	push   $0x3f
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
  800a7d:	eb 0f                	jmp    800a8e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	53                   	push   %ebx
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a91:	89 f0                	mov    %esi,%eax
  800a93:	8d 70 01             	lea    0x1(%eax),%esi
  800a96:	8a 00                	mov    (%eax),%al
  800a98:	0f be d8             	movsbl %al,%ebx
  800a9b:	85 db                	test   %ebx,%ebx
  800a9d:	74 24                	je     800ac3 <vprintfmt+0x24b>
  800a9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa3:	78 b8                	js     800a5d <vprintfmt+0x1e5>
  800aa5:	ff 4d e0             	decl   -0x20(%ebp)
  800aa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aac:	79 af                	jns    800a5d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aae:	eb 13                	jmp    800ac3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	6a 20                	push   $0x20
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	ff d0                	call   *%eax
  800abd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac7:	7f e7                	jg     800ab0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ac9:	e9 66 01 00 00       	jmp    800c34 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad7:	50                   	push   %eax
  800ad8:	e8 3c fd ff ff       	call   800819 <getint>
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aec:	85 d2                	test   %edx,%edx
  800aee:	79 23                	jns    800b13 <vprintfmt+0x29b>
				putch('-', putdat);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	6a 2d                	push   $0x2d
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	ff d0                	call   *%eax
  800afd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b06:	f7 d8                	neg    %eax
  800b08:	83 d2 00             	adc    $0x0,%edx
  800b0b:	f7 da                	neg    %edx
  800b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b13:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b1a:	e9 bc 00 00 00       	jmp    800bdb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 e8             	pushl  -0x18(%ebp)
  800b25:	8d 45 14             	lea    0x14(%ebp),%eax
  800b28:	50                   	push   %eax
  800b29:	e8 84 fc ff ff       	call   8007b2 <getuint>
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b37:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b3e:	e9 98 00 00 00       	jmp    800bdb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	6a 58                	push   $0x58
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
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
			break;
  800b73:	e9 bc 00 00 00       	jmp    800c34 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	6a 30                	push   $0x30
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	ff d0                	call   *%eax
  800b85:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	6a 78                	push   $0x78
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	ff d0                	call   *%eax
  800b95:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b98:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9b:	83 c0 04             	add    $0x4,%eax
  800b9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba4:	83 e8 04             	sub    $0x4,%eax
  800ba7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bb3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bba:	eb 1f                	jmp    800bdb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bbc:	83 ec 08             	sub    $0x8,%esp
  800bbf:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc5:	50                   	push   %eax
  800bc6:	e8 e7 fb ff ff       	call   8007b2 <getuint>
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bd4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bdb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be2:	83 ec 04             	sub    $0x4,%esp
  800be5:	52                   	push   %edx
  800be6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800be9:	50                   	push   %eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	ff 75 08             	pushl  0x8(%ebp)
  800bf6:	e8 00 fb ff ff       	call   8006fb <printnum>
  800bfb:	83 c4 20             	add    $0x20,%esp
			break;
  800bfe:	eb 34                	jmp    800c34 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	53                   	push   %ebx
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	ff d0                	call   *%eax
  800c0c:	83 c4 10             	add    $0x10,%esp
			break;
  800c0f:	eb 23                	jmp    800c34 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c11:	83 ec 08             	sub    $0x8,%esp
  800c14:	ff 75 0c             	pushl  0xc(%ebp)
  800c17:	6a 25                	push   $0x25
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c21:	ff 4d 10             	decl   0x10(%ebp)
  800c24:	eb 03                	jmp    800c29 <vprintfmt+0x3b1>
  800c26:	ff 4d 10             	decl   0x10(%ebp)
  800c29:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2c:	48                   	dec    %eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	3c 25                	cmp    $0x25,%al
  800c31:	75 f3                	jne    800c26 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c33:	90                   	nop
		}
	}
  800c34:	e9 47 fc ff ff       	jmp    800880 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c39:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    

00800c41 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c47:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4a:	83 c0 04             	add    $0x4,%eax
  800c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c50:	8b 45 10             	mov    0x10(%ebp),%eax
  800c53:	ff 75 f4             	pushl  -0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	ff 75 08             	pushl  0x8(%ebp)
  800c5d:	e8 16 fc ff ff       	call   800878 <vprintfmt>
  800c62:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c65:	90                   	nop
  800c66:	c9                   	leave  
  800c67:	c3                   	ret    

00800c68 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6e:	8b 40 08             	mov    0x8(%eax),%eax
  800c71:	8d 50 01             	lea    0x1(%eax),%edx
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	8b 10                	mov    (%eax),%edx
  800c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c82:	8b 40 04             	mov    0x4(%eax),%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	73 12                	jae    800c9b <sprintputch+0x33>
		*b->buf++ = ch;
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c94:	89 0a                	mov    %ecx,(%edx)
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	88 10                	mov    %dl,(%eax)
}
  800c9b:	90                   	nop
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	01 d0                	add    %edx,%eax
  800cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cc3:	74 06                	je     800ccb <vsnprintf+0x2d>
  800cc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc9:	7f 07                	jg     800cd2 <vsnprintf+0x34>
		return -E_INVAL;
  800ccb:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd0:	eb 20                	jmp    800cf2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cd2:	ff 75 14             	pushl  0x14(%ebp)
  800cd5:	ff 75 10             	pushl  0x10(%ebp)
  800cd8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cdb:	50                   	push   %eax
  800cdc:	68 68 0c 80 00       	push   $0x800c68
  800ce1:	e8 92 fb ff ff       	call   800878 <vprintfmt>
  800ce6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800cfd:	83 c0 04             	add    $0x4,%eax
  800d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d03:	8b 45 10             	mov    0x10(%ebp),%eax
  800d06:	ff 75 f4             	pushl  -0xc(%ebp)
  800d09:	50                   	push   %eax
  800d0a:	ff 75 0c             	pushl  0xc(%ebp)
  800d0d:	ff 75 08             	pushl  0x8(%ebp)
  800d10:	e8 89 ff ff ff       	call   800c9e <vsnprintf>
  800d15:	83 c4 10             	add    $0x10,%esp
  800d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d1e:	c9                   	leave  
  800d1f:	c3                   	ret    

00800d20 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d2d:	eb 06                	jmp    800d35 <strlen+0x15>
		n++;
  800d2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d32:	ff 45 08             	incl   0x8(%ebp)
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	75 f1                	jne    800d2f <strlen+0xf>
		n++;
	return n;
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d50:	eb 09                	jmp    800d5b <strnlen+0x18>
		n++;
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d55:	ff 45 08             	incl   0x8(%ebp)
  800d58:	ff 4d 0c             	decl   0xc(%ebp)
  800d5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5f:	74 09                	je     800d6a <strnlen+0x27>
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	84 c0                	test   %al,%al
  800d68:	75 e8                	jne    800d52 <strnlen+0xf>
		n++;
	return n;
  800d6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d7b:	90                   	nop
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8d 50 01             	lea    0x1(%eax),%edx
  800d82:	89 55 08             	mov    %edx,0x8(%ebp)
  800d85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d8b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d8e:	8a 12                	mov    (%edx),%dl
  800d90:	88 10                	mov    %dl,(%eax)
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	84 c0                	test   %al,%al
  800d96:	75 e4                	jne    800d7c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800da9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db0:	eb 1f                	jmp    800dd1 <strncpy+0x34>
		*dst++ = *src;
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8d 50 01             	lea    0x1(%eax),%edx
  800db8:	89 55 08             	mov    %edx,0x8(%ebp)
  800dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbe:	8a 12                	mov    (%edx),%dl
  800dc0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	84 c0                	test   %al,%al
  800dc9:	74 03                	je     800dce <strncpy+0x31>
			src++;
  800dcb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dce:	ff 45 fc             	incl   -0x4(%ebp)
  800dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dd7:	72 d9                	jb     800db2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dee:	74 30                	je     800e20 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800df0:	eb 16                	jmp    800e08 <strlcpy+0x2a>
			*dst++ = *src++;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8d 50 01             	lea    0x1(%eax),%edx
  800df8:	89 55 08             	mov    %edx,0x8(%ebp)
  800dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e01:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e04:	8a 12                	mov    (%edx),%dl
  800e06:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e08:	ff 4d 10             	decl   0x10(%ebp)
  800e0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0f:	74 09                	je     800e1a <strlcpy+0x3c>
  800e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	84 c0                	test   %al,%al
  800e18:	75 d8                	jne    800df2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e20:	8b 55 08             	mov    0x8(%ebp),%edx
  800e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e26:	29 c2                	sub    %eax,%edx
  800e28:	89 d0                	mov    %edx,%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e2f:	eb 06                	jmp    800e37 <strcmp+0xb>
		p++, q++;
  800e31:	ff 45 08             	incl   0x8(%ebp)
  800e34:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	84 c0                	test   %al,%al
  800e3e:	74 0e                	je     800e4e <strcmp+0x22>
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 10                	mov    (%eax),%dl
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	38 c2                	cmp    %al,%dl
  800e4c:	74 e3                	je     800e31 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	0f b6 d0             	movzbl %al,%edx
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	0f b6 c0             	movzbl %al,%eax
  800e5e:	29 c2                	sub    %eax,%edx
  800e60:	89 d0                	mov    %edx,%eax
}
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e67:	eb 09                	jmp    800e72 <strncmp+0xe>
		n--, p++, q++;
  800e69:	ff 4d 10             	decl   0x10(%ebp)
  800e6c:	ff 45 08             	incl   0x8(%ebp)
  800e6f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e76:	74 17                	je     800e8f <strncmp+0x2b>
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	74 0e                	je     800e8f <strncmp+0x2b>
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 10                	mov    (%eax),%dl
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	38 c2                	cmp    %al,%dl
  800e8d:	74 da                	je     800e69 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e93:	75 07                	jne    800e9c <strncmp+0x38>
		return 0;
  800e95:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9a:	eb 14                	jmp    800eb0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	0f b6 d0             	movzbl %al,%edx
  800ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	0f b6 c0             	movzbl %al,%eax
  800eac:	29 c2                	sub    %eax,%edx
  800eae:	89 d0                	mov    %edx,%eax
}
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	83 ec 04             	sub    $0x4,%esp
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ebe:	eb 12                	jmp    800ed2 <strchr+0x20>
		if (*s == c)
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec8:	75 05                	jne    800ecf <strchr+0x1d>
			return (char *) s;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	eb 11                	jmp    800ee0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	84 c0                	test   %al,%al
  800ed9:	75 e5                	jne    800ec0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800edb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 04             	sub    $0x4,%esp
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eee:	eb 0d                	jmp    800efd <strfind+0x1b>
		if (*s == c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef8:	74 0e                	je     800f08 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 ea                	jne    800ef0 <strfind+0xe>
  800f06:	eb 01                	jmp    800f09 <strfind+0x27>
		if (*s == c)
			break;
  800f08:	90                   	nop
	return (char *) s;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f20:	eb 0e                	jmp    800f30 <memset+0x22>
		*p++ = c;
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f25:	8d 50 01             	lea    0x1(%eax),%edx
  800f28:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f30:	ff 4d f8             	decl   -0x8(%ebp)
  800f33:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f37:	79 e9                	jns    800f22 <memset+0x14>
		*p++ = c;

	return v;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f50:	eb 16                	jmp    800f68 <memcpy+0x2a>
		*d++ = *s++;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 dd                	jne    800f52 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f92:	73 50                	jae    800fe4 <memmove+0x6a>
  800f94:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	01 d0                	add    %edx,%eax
  800f9c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9f:	76 43                	jbe    800fe4 <memmove+0x6a>
		s += n;
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  800faa:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fad:	eb 10                	jmp    800fbf <memmove+0x45>
			*--d = *--s;
  800faf:	ff 4d f8             	decl   -0x8(%ebp)
  800fb2:	ff 4d fc             	decl   -0x4(%ebp)
  800fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb8:	8a 10                	mov    (%eax),%dl
  800fba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	75 e3                	jne    800faf <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fcc:	eb 23                	jmp    800ff1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd1:	8d 50 01             	lea    0x1(%eax),%edx
  800fd4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fdd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fe0:	8a 12                	mov    (%edx),%dl
  800fe2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fea:	89 55 10             	mov    %edx,0x10(%ebp)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	75 dd                	jne    800fce <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801002:	8b 45 0c             	mov    0xc(%ebp),%eax
  801005:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801008:	eb 2a                	jmp    801034 <memcmp+0x3e>
		if (*s1 != *s2)
  80100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100d:	8a 10                	mov    (%eax),%dl
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	38 c2                	cmp    %al,%dl
  801016:	74 16                	je     80102e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	0f b6 d0             	movzbl %al,%edx
  801020:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f b6 c0             	movzbl %al,%eax
  801028:	29 c2                	sub    %eax,%edx
  80102a:	89 d0                	mov    %edx,%eax
  80102c:	eb 18                	jmp    801046 <memcmp+0x50>
		s1++, s2++;
  80102e:	ff 45 fc             	incl   -0x4(%ebp)
  801031:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
  801037:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103a:	89 55 10             	mov    %edx,0x10(%ebp)
  80103d:	85 c0                	test   %eax,%eax
  80103f:	75 c9                	jne    80100a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801041:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801046:	c9                   	leave  
  801047:	c3                   	ret    

00801048 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80104e:	8b 55 08             	mov    0x8(%ebp),%edx
  801051:	8b 45 10             	mov    0x10(%ebp),%eax
  801054:	01 d0                	add    %edx,%eax
  801056:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801059:	eb 15                	jmp    801070 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8a 00                	mov    (%eax),%al
  801060:	0f b6 d0             	movzbl %al,%edx
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	0f b6 c0             	movzbl %al,%eax
  801069:	39 c2                	cmp    %eax,%edx
  80106b:	74 0d                	je     80107a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80106d:	ff 45 08             	incl   0x8(%ebp)
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801076:	72 e3                	jb     80105b <memfind+0x13>
  801078:	eb 01                	jmp    80107b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80107a:	90                   	nop
	return (void *) s;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801086:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80108d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801094:	eb 03                	jmp    801099 <strtol+0x19>
		s++;
  801096:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	3c 20                	cmp    $0x20,%al
  8010a0:	74 f4                	je     801096 <strtol+0x16>
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	3c 09                	cmp    $0x9,%al
  8010a9:	74 eb                	je     801096 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 2b                	cmp    $0x2b,%al
  8010b2:	75 05                	jne    8010b9 <strtol+0x39>
		s++;
  8010b4:	ff 45 08             	incl   0x8(%ebp)
  8010b7:	eb 13                	jmp    8010cc <strtol+0x4c>
	else if (*s == '-')
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	3c 2d                	cmp    $0x2d,%al
  8010c0:	75 0a                	jne    8010cc <strtol+0x4c>
		s++, neg = 1;
  8010c2:	ff 45 08             	incl   0x8(%ebp)
  8010c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d0:	74 06                	je     8010d8 <strtol+0x58>
  8010d2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010d6:	75 20                	jne    8010f8 <strtol+0x78>
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	3c 30                	cmp    $0x30,%al
  8010df:	75 17                	jne    8010f8 <strtol+0x78>
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	40                   	inc    %eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 78                	cmp    $0x78,%al
  8010e9:	75 0d                	jne    8010f8 <strtol+0x78>
		s += 2, base = 16;
  8010eb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010ef:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010f6:	eb 28                	jmp    801120 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 15                	jne    801113 <strtol+0x93>
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 30                	cmp    $0x30,%al
  801105:	75 0c                	jne    801113 <strtol+0x93>
		s++, base = 8;
  801107:	ff 45 08             	incl   0x8(%ebp)
  80110a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801111:	eb 0d                	jmp    801120 <strtol+0xa0>
	else if (base == 0)
  801113:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801117:	75 07                	jne    801120 <strtol+0xa0>
		base = 10;
  801119:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 2f                	cmp    $0x2f,%al
  801127:	7e 19                	jle    801142 <strtol+0xc2>
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	3c 39                	cmp    $0x39,%al
  801130:	7f 10                	jg     801142 <strtol+0xc2>
			dig = *s - '0';
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	0f be c0             	movsbl %al,%eax
  80113a:	83 e8 30             	sub    $0x30,%eax
  80113d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801140:	eb 42                	jmp    801184 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	3c 60                	cmp    $0x60,%al
  801149:	7e 19                	jle    801164 <strtol+0xe4>
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	3c 7a                	cmp    $0x7a,%al
  801152:	7f 10                	jg     801164 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f be c0             	movsbl %al,%eax
  80115c:	83 e8 57             	sub    $0x57,%eax
  80115f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801162:	eb 20                	jmp    801184 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 40                	cmp    $0x40,%al
  80116b:	7e 39                	jle    8011a6 <strtol+0x126>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 5a                	cmp    $0x5a,%al
  801174:	7f 30                	jg     8011a6 <strtol+0x126>
			dig = *s - 'A' + 10;
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f be c0             	movsbl %al,%eax
  80117e:	83 e8 37             	sub    $0x37,%eax
  801181:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801187:	3b 45 10             	cmp    0x10(%ebp),%eax
  80118a:	7d 19                	jge    8011a5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80118c:	ff 45 08             	incl   0x8(%ebp)
  80118f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801192:	0f af 45 10          	imul   0x10(%ebp),%eax
  801196:	89 c2                	mov    %eax,%edx
  801198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119b:	01 d0                	add    %edx,%eax
  80119d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011a0:	e9 7b ff ff ff       	jmp    801120 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011a5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011aa:	74 08                	je     8011b4 <strtol+0x134>
		*endptr = (char *) s;
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b8:	74 07                	je     8011c1 <strtol+0x141>
  8011ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bd:	f7 d8                	neg    %eax
  8011bf:	eb 03                	jmp    8011c4 <strtol+0x144>
  8011c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <ltostr>:

void
ltostr(long value, char *str)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011de:	79 13                	jns    8011f3 <ltostr+0x2d>
	{
		neg = 1;
  8011e0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ed:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011f0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011fb:	99                   	cltd   
  8011fc:	f7 f9                	idiv   %ecx
  8011fe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801201:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801204:	8d 50 01             	lea    0x1(%eax),%edx
  801207:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80120a:	89 c2                	mov    %eax,%edx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 d0                	add    %edx,%eax
  801211:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801214:	83 c2 30             	add    $0x30,%edx
  801217:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801219:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801221:	f7 e9                	imul   %ecx
  801223:	c1 fa 02             	sar    $0x2,%edx
  801226:	89 c8                	mov    %ecx,%eax
  801228:	c1 f8 1f             	sar    $0x1f,%eax
  80122b:	29 c2                	sub    %eax,%edx
  80122d:	89 d0                	mov    %edx,%eax
  80122f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801232:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801235:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123a:	f7 e9                	imul   %ecx
  80123c:	c1 fa 02             	sar    $0x2,%edx
  80123f:	89 c8                	mov    %ecx,%eax
  801241:	c1 f8 1f             	sar    $0x1f,%eax
  801244:	29 c2                	sub    %eax,%edx
  801246:	89 d0                	mov    %edx,%eax
  801248:	c1 e0 02             	shl    $0x2,%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	01 c0                	add    %eax,%eax
  80124f:	29 c1                	sub    %eax,%ecx
  801251:	89 ca                	mov    %ecx,%edx
  801253:	85 d2                	test   %edx,%edx
  801255:	75 9c                	jne    8011f3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80125e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801261:	48                   	dec    %eax
  801262:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801265:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801269:	74 3d                	je     8012a8 <ltostr+0xe2>
		start = 1 ;
  80126b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801272:	eb 34                	jmp    8012a8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	01 c2                	add    %eax,%edx
  801289:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 c8                	add    %ecx,%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801295:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 c2                	add    %eax,%edx
  80129d:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a0:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ae:	7c c4                	jl     801274 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	01 d0                	add    %edx,%eax
  8012b8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012bb:	90                   	nop
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    

008012be <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c4:	ff 75 08             	pushl  0x8(%ebp)
  8012c7:	e8 54 fa ff ff       	call   800d20 <strlen>
  8012cc:	83 c4 04             	add    $0x4,%esp
  8012cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d2:	ff 75 0c             	pushl  0xc(%ebp)
  8012d5:	e8 46 fa ff ff       	call   800d20 <strlen>
  8012da:	83 c4 04             	add    $0x4,%esp
  8012dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ee:	eb 17                	jmp    801307 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	01 c2                	add    %eax,%edx
  8012f8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	01 c8                	add    %ecx,%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801304:	ff 45 fc             	incl   -0x4(%ebp)
  801307:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80130d:	7c e1                	jl     8012f0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80130f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801316:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80131d:	eb 1f                	jmp    80133e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80131f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801328:	89 c2                	mov    %eax,%edx
  80132a:	8b 45 10             	mov    0x10(%ebp),%eax
  80132d:	01 c2                	add    %eax,%edx
  80132f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801332:	8b 45 0c             	mov    0xc(%ebp),%eax
  801335:	01 c8                	add    %ecx,%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133b:	ff 45 f8             	incl   -0x8(%ebp)
  80133e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801344:	7c d9                	jl     80131f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c6 00 00             	movb   $0x0,(%eax)
}
  801351:	90                   	nop
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801357:	8b 45 14             	mov    0x14(%ebp),%eax
  80135a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801360:	8b 45 14             	mov    0x14(%ebp),%eax
  801363:	8b 00                	mov    (%eax),%eax
  801365:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136c:	8b 45 10             	mov    0x10(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801377:	eb 0c                	jmp    801385 <strsplit+0x31>
			*string++ = 0;
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8d 50 01             	lea    0x1(%eax),%edx
  80137f:	89 55 08             	mov    %edx,0x8(%ebp)
  801382:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	84 c0                	test   %al,%al
  80138c:	74 18                	je     8013a6 <strsplit+0x52>
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	0f be c0             	movsbl %al,%eax
  801396:	50                   	push   %eax
  801397:	ff 75 0c             	pushl  0xc(%ebp)
  80139a:	e8 13 fb ff ff       	call   800eb2 <strchr>
  80139f:	83 c4 08             	add    $0x8,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	75 d3                	jne    801379 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	8a 00                	mov    (%eax),%al
  8013ab:	84 c0                	test   %al,%al
  8013ad:	74 5a                	je     801409 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8013af:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b2:	8b 00                	mov    (%eax),%eax
  8013b4:	83 f8 0f             	cmp    $0xf,%eax
  8013b7:	75 07                	jne    8013c0 <strsplit+0x6c>
		{
			return 0;
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013be:	eb 66                	jmp    801426 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c3:	8b 00                	mov    (%eax),%eax
  8013c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c8:	8b 55 14             	mov    0x14(%ebp),%edx
  8013cb:	89 0a                	mov    %ecx,(%edx)
  8013cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d7:	01 c2                	add    %eax,%edx
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013de:	eb 03                	jmp    8013e3 <strsplit+0x8f>
			string++;
  8013e0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	84 c0                	test   %al,%al
  8013ea:	74 8b                	je     801377 <strsplit+0x23>
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	0f be c0             	movsbl %al,%eax
  8013f4:	50                   	push   %eax
  8013f5:	ff 75 0c             	pushl  0xc(%ebp)
  8013f8:	e8 b5 fa ff ff       	call   800eb2 <strchr>
  8013fd:	83 c4 08             	add    $0x8,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	74 dc                	je     8013e0 <strsplit+0x8c>
			string++;
	}
  801404:	e9 6e ff ff ff       	jmp    801377 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801409:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80140a:	8b 45 14             	mov    0x14(%ebp),%eax
  80140d:	8b 00                	mov    (%eax),%eax
  80140f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 d0                	add    %edx,%eax
  80141b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801421:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	57                   	push   %edi
  80142c:	56                   	push   %esi
  80142d:	53                   	push   %ebx
  80142e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80143d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801440:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801443:	cd 30                	int    $0x30
  801445:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801448:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	ff 75 0c             	pushl  0xc(%ebp)
  801462:	50                   	push   %eax
  801463:	6a 00                	push   $0x0
  801465:	e8 be ff ff ff       	call   801428 <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
}
  80146d:	90                   	nop
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <sys_cgetc>:

int
sys_cgetc(void)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 01                	push   $0x1
  80147f:	e8 a4 ff ff ff       	call   801428 <syscall>
  801484:	83 c4 18             	add    $0x18,%esp
}
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	50                   	push   %eax
  801498:	6a 03                	push   $0x3
  80149a:	e8 89 ff ff ff       	call   801428 <syscall>
  80149f:	83 c4 18             	add    $0x18,%esp
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 02                	push   $0x2
  8014b3:	e8 70 ff ff ff       	call   801428 <syscall>
  8014b8:	83 c4 18             	add    $0x18,%esp
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <sys_env_exit>:

void sys_env_exit(void)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 04                	push   $0x4
  8014cc:	e8 57 ff ff ff       	call   801428 <syscall>
  8014d1:	83 c4 18             	add    $0x18,%esp
}
  8014d4:	90                   	nop
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	52                   	push   %edx
  8014e7:	50                   	push   %eax
  8014e8:	6a 05                	push   $0x5
  8014ea:	e8 39 ff ff ff       	call   801428 <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	56                   	push   %esi
  8014f8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014f9:	8b 75 18             	mov    0x18(%ebp),%esi
  8014fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801502:	8b 55 0c             	mov    0xc(%ebp),%edx
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	56                   	push   %esi
  801509:	53                   	push   %ebx
  80150a:	51                   	push   %ecx
  80150b:	52                   	push   %edx
  80150c:	50                   	push   %eax
  80150d:	6a 06                	push   $0x6
  80150f:	e8 14 ff ff ff       	call   801428 <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
}
  801517:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5e                   	pop    %esi
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801521:	8b 55 0c             	mov    0xc(%ebp),%edx
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	52                   	push   %edx
  80152e:	50                   	push   %eax
  80152f:	6a 07                	push   $0x7
  801531:	e8 f2 fe ff ff       	call   801428 <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	ff 75 0c             	pushl  0xc(%ebp)
  801547:	ff 75 08             	pushl  0x8(%ebp)
  80154a:	6a 08                	push   $0x8
  80154c:	e8 d7 fe ff ff       	call   801428 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 09                	push   $0x9
  801565:	e8 be fe ff ff       	call   801428 <syscall>
  80156a:	83 c4 18             	add    $0x18,%esp
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 0a                	push   $0xa
  80157e:	e8 a5 fe ff ff       	call   801428 <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 0b                	push   $0xb
  801597:	e8 8c fe ff ff       	call   801428 <syscall>
  80159c:	83 c4 18             	add    $0x18,%esp
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	ff 75 0c             	pushl  0xc(%ebp)
  8015ad:	ff 75 08             	pushl  0x8(%ebp)
  8015b0:	6a 0d                	push   $0xd
  8015b2:	e8 71 fe ff ff       	call   801428 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
	return;
  8015ba:	90                   	nop
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	ff 75 0c             	pushl  0xc(%ebp)
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	6a 0e                	push   $0xe
  8015ce:	e8 55 fe ff ff       	call   801428 <syscall>
  8015d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d6:	90                   	nop
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 0c                	push   $0xc
  8015e8:	e8 3b fe ff ff       	call   801428 <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 10                	push   $0x10
  801601:	e8 22 fe ff ff       	call   801428 <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	90                   	nop
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 11                	push   $0x11
  80161b:	e8 08 fe ff ff       	call   801428 <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	90                   	nop
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sys_cputc>:


void
sys_cputc(const char c)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801632:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	50                   	push   %eax
  80163f:	6a 12                	push   $0x12
  801641:	e8 e2 fd ff ff       	call   801428 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
}
  801649:	90                   	nop
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 13                	push   $0x13
  80165b:	e8 c8 fd ff ff       	call   801428 <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	90                   	nop
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	50                   	push   %eax
  801676:	6a 14                	push   $0x14
  801678:	e8 ab fd ff ff       	call   801428 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	50                   	push   %eax
  801691:	6a 17                	push   $0x17
  801693:	e8 90 fd ff ff       	call   801428 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	50                   	push   %eax
  8016ac:	6a 15                	push   $0x15
  8016ae:	e8 75 fd ff ff       	call   801428 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	50                   	push   %eax
  8016c8:	6a 16                	push   $0x16
  8016ca:	e8 59 fd ff ff       	call   801428 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	90                   	nop
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 04             	sub    $0x4,%esp
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8016e1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	6a 00                	push   $0x0
  8016ed:	51                   	push   %ecx
  8016ee:	52                   	push   %edx
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	50                   	push   %eax
  8016f3:	6a 18                	push   $0x18
  8016f5:	e8 2e fd ff ff       	call   801428 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  801702:	8b 55 0c             	mov    0xc(%ebp),%edx
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	52                   	push   %edx
  80170f:	50                   	push   %eax
  801710:	6a 19                	push   $0x19
  801712:	e8 11 fd ff ff       	call   801428 <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	50                   	push   %eax
  80172b:	6a 1a                	push   $0x1a
  80172d:	e8 f6 fc ff ff       	call   801428 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 1b                	push   $0x1b
  801746:	e8 dd fc ff ff       	call   801428 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 1c                	push   $0x1c
  80175f:	e8 c4 fc ff ff       	call   801428 <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	ff 75 0c             	pushl  0xc(%ebp)
  801778:	50                   	push   %eax
  801779:	6a 1d                	push   $0x1d
  80177b:	e8 a8 fc ff ff       	call   801428 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	50                   	push   %eax
  801794:	6a 1e                	push   $0x1e
  801796:	e8 8d fc ff ff       	call   801428 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	90                   	nop
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	50                   	push   %eax
  8017b0:	6a 1f                	push   $0x1f
  8017b2:	e8 71 fc ff ff       	call   801428 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	90                   	nop
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017c3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017c6:	8d 50 04             	lea    0x4(%eax),%edx
  8017c9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	52                   	push   %edx
  8017d3:	50                   	push   %eax
  8017d4:	6a 20                	push   $0x20
  8017d6:	e8 4d fc ff ff       	call   801428 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
	return result;
  8017de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e7:	89 01                	mov    %eax,(%ecx)
  8017e9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	c9                   	leave  
  8017f0:	c2 04 00             	ret    $0x4

008017f3 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	ff 75 10             	pushl  0x10(%ebp)
  8017fd:	ff 75 0c             	pushl  0xc(%ebp)
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	6a 0f                	push   $0xf
  801805:	e8 1e fc ff ff       	call   801428 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
	return ;
  80180d:	90                   	nop
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_rcr2>:
uint32 sys_rcr2()
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 21                	push   $0x21
  80181f:	e8 04 fc ff ff       	call   801428 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801835:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	50                   	push   %eax
  801842:	6a 22                	push   $0x22
  801844:	e8 df fb ff ff       	call   801428 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
	return ;
  80184c:	90                   	nop
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <rsttst>:
void rsttst()
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 24                	push   $0x24
  80185e:	e8 c5 fb ff ff       	call   801428 <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
	return ;
  801866:	90                   	nop
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	83 ec 04             	sub    $0x4,%esp
  80186f:	8b 45 14             	mov    0x14(%ebp),%eax
  801872:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801875:	8b 55 18             	mov    0x18(%ebp),%edx
  801878:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80187c:	52                   	push   %edx
  80187d:	50                   	push   %eax
  80187e:	ff 75 10             	pushl  0x10(%ebp)
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	6a 23                	push   $0x23
  801889:	e8 9a fb ff ff       	call   801428 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
	return ;
  801891:	90                   	nop
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <chktst>:
void chktst(uint32 n)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	6a 25                	push   $0x25
  8018a4:	e8 7f fb ff ff       	call   801428 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ac:	90                   	nop
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 26                	push   $0x26
  8018c1:	e8 62 fb ff ff       	call   801428 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
  8018c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018cc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018d0:	75 07                	jne    8018d9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d7:	eb 05                	jmp    8018de <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 26                	push   $0x26
  8018f2:	e8 31 fb ff ff       	call   801428 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
  8018fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018fd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801901:	75 07                	jne    80190a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801903:	b8 01 00 00 00       	mov    $0x1,%eax
  801908:	eb 05                	jmp    80190f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80190a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 26                	push   $0x26
  801923:	e8 00 fb ff ff       	call   801428 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
  80192b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80192e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801932:	75 07                	jne    80193b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801934:	b8 01 00 00 00       	mov    $0x1,%eax
  801939:	eb 05                	jmp    801940 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80193b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 26                	push   $0x26
  801954:	e8 cf fa ff ff       	call   801428 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
  80195c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80195f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801963:	75 07                	jne    80196c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801965:	b8 01 00 00 00       	mov    $0x1,%eax
  80196a:	eb 05                	jmp    801971 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80196c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	6a 27                	push   $0x27
  801983:	e8 a0 fa ff ff       	call   801428 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
	return ;
  80198b:	90                   	nop
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    
  80198e:	66 90                	xchg   %ax,%ax

00801990 <__udivdi3>:
  801990:	55                   	push   %ebp
  801991:	57                   	push   %edi
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
  801994:	83 ec 1c             	sub    $0x1c,%esp
  801997:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80199b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80199f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019a7:	89 ca                	mov    %ecx,%edx
  8019a9:	89 f8                	mov    %edi,%eax
  8019ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019af:	85 f6                	test   %esi,%esi
  8019b1:	75 2d                	jne    8019e0 <__udivdi3+0x50>
  8019b3:	39 cf                	cmp    %ecx,%edi
  8019b5:	77 65                	ja     801a1c <__udivdi3+0x8c>
  8019b7:	89 fd                	mov    %edi,%ebp
  8019b9:	85 ff                	test   %edi,%edi
  8019bb:	75 0b                	jne    8019c8 <__udivdi3+0x38>
  8019bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c2:	31 d2                	xor    %edx,%edx
  8019c4:	f7 f7                	div    %edi
  8019c6:	89 c5                	mov    %eax,%ebp
  8019c8:	31 d2                	xor    %edx,%edx
  8019ca:	89 c8                	mov    %ecx,%eax
  8019cc:	f7 f5                	div    %ebp
  8019ce:	89 c1                	mov    %eax,%ecx
  8019d0:	89 d8                	mov    %ebx,%eax
  8019d2:	f7 f5                	div    %ebp
  8019d4:	89 cf                	mov    %ecx,%edi
  8019d6:	89 fa                	mov    %edi,%edx
  8019d8:	83 c4 1c             	add    $0x1c,%esp
  8019db:	5b                   	pop    %ebx
  8019dc:	5e                   	pop    %esi
  8019dd:	5f                   	pop    %edi
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    
  8019e0:	39 ce                	cmp    %ecx,%esi
  8019e2:	77 28                	ja     801a0c <__udivdi3+0x7c>
  8019e4:	0f bd fe             	bsr    %esi,%edi
  8019e7:	83 f7 1f             	xor    $0x1f,%edi
  8019ea:	75 40                	jne    801a2c <__udivdi3+0x9c>
  8019ec:	39 ce                	cmp    %ecx,%esi
  8019ee:	72 0a                	jb     8019fa <__udivdi3+0x6a>
  8019f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019f4:	0f 87 9e 00 00 00    	ja     801a98 <__udivdi3+0x108>
  8019fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ff:	89 fa                	mov    %edi,%edx
  801a01:	83 c4 1c             	add    $0x1c,%esp
  801a04:	5b                   	pop    %ebx
  801a05:	5e                   	pop    %esi
  801a06:	5f                   	pop    %edi
  801a07:	5d                   	pop    %ebp
  801a08:	c3                   	ret    
  801a09:	8d 76 00             	lea    0x0(%esi),%esi
  801a0c:	31 ff                	xor    %edi,%edi
  801a0e:	31 c0                	xor    %eax,%eax
  801a10:	89 fa                	mov    %edi,%edx
  801a12:	83 c4 1c             	add    $0x1c,%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5f                   	pop    %edi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    
  801a1a:	66 90                	xchg   %ax,%ax
  801a1c:	89 d8                	mov    %ebx,%eax
  801a1e:	f7 f7                	div    %edi
  801a20:	31 ff                	xor    %edi,%edi
  801a22:	89 fa                	mov    %edi,%edx
  801a24:	83 c4 1c             	add    $0x1c,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5f                   	pop    %edi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    
  801a2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a31:	89 eb                	mov    %ebp,%ebx
  801a33:	29 fb                	sub    %edi,%ebx
  801a35:	89 f9                	mov    %edi,%ecx
  801a37:	d3 e6                	shl    %cl,%esi
  801a39:	89 c5                	mov    %eax,%ebp
  801a3b:	88 d9                	mov    %bl,%cl
  801a3d:	d3 ed                	shr    %cl,%ebp
  801a3f:	89 e9                	mov    %ebp,%ecx
  801a41:	09 f1                	or     %esi,%ecx
  801a43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a47:	89 f9                	mov    %edi,%ecx
  801a49:	d3 e0                	shl    %cl,%eax
  801a4b:	89 c5                	mov    %eax,%ebp
  801a4d:	89 d6                	mov    %edx,%esi
  801a4f:	88 d9                	mov    %bl,%cl
  801a51:	d3 ee                	shr    %cl,%esi
  801a53:	89 f9                	mov    %edi,%ecx
  801a55:	d3 e2                	shl    %cl,%edx
  801a57:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a5b:	88 d9                	mov    %bl,%cl
  801a5d:	d3 e8                	shr    %cl,%eax
  801a5f:	09 c2                	or     %eax,%edx
  801a61:	89 d0                	mov    %edx,%eax
  801a63:	89 f2                	mov    %esi,%edx
  801a65:	f7 74 24 0c          	divl   0xc(%esp)
  801a69:	89 d6                	mov    %edx,%esi
  801a6b:	89 c3                	mov    %eax,%ebx
  801a6d:	f7 e5                	mul    %ebp
  801a6f:	39 d6                	cmp    %edx,%esi
  801a71:	72 19                	jb     801a8c <__udivdi3+0xfc>
  801a73:	74 0b                	je     801a80 <__udivdi3+0xf0>
  801a75:	89 d8                	mov    %ebx,%eax
  801a77:	31 ff                	xor    %edi,%edi
  801a79:	e9 58 ff ff ff       	jmp    8019d6 <__udivdi3+0x46>
  801a7e:	66 90                	xchg   %ax,%ax
  801a80:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a84:	89 f9                	mov    %edi,%ecx
  801a86:	d3 e2                	shl    %cl,%edx
  801a88:	39 c2                	cmp    %eax,%edx
  801a8a:	73 e9                	jae    801a75 <__udivdi3+0xe5>
  801a8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a8f:	31 ff                	xor    %edi,%edi
  801a91:	e9 40 ff ff ff       	jmp    8019d6 <__udivdi3+0x46>
  801a96:	66 90                	xchg   %ax,%ax
  801a98:	31 c0                	xor    %eax,%eax
  801a9a:	e9 37 ff ff ff       	jmp    8019d6 <__udivdi3+0x46>
  801a9f:	90                   	nop

00801aa0 <__umoddi3>:
  801aa0:	55                   	push   %ebp
  801aa1:	57                   	push   %edi
  801aa2:	56                   	push   %esi
  801aa3:	53                   	push   %ebx
  801aa4:	83 ec 1c             	sub    $0x1c,%esp
  801aa7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801aab:	8b 74 24 34          	mov    0x34(%esp),%esi
  801aaf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ab3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ab7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801abb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801abf:	89 f3                	mov    %esi,%ebx
  801ac1:	89 fa                	mov    %edi,%edx
  801ac3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac7:	89 34 24             	mov    %esi,(%esp)
  801aca:	85 c0                	test   %eax,%eax
  801acc:	75 1a                	jne    801ae8 <__umoddi3+0x48>
  801ace:	39 f7                	cmp    %esi,%edi
  801ad0:	0f 86 a2 00 00 00    	jbe    801b78 <__umoddi3+0xd8>
  801ad6:	89 c8                	mov    %ecx,%eax
  801ad8:	89 f2                	mov    %esi,%edx
  801ada:	f7 f7                	div    %edi
  801adc:	89 d0                	mov    %edx,%eax
  801ade:	31 d2                	xor    %edx,%edx
  801ae0:	83 c4 1c             	add    $0x1c,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5f                   	pop    %edi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    
  801ae8:	39 f0                	cmp    %esi,%eax
  801aea:	0f 87 ac 00 00 00    	ja     801b9c <__umoddi3+0xfc>
  801af0:	0f bd e8             	bsr    %eax,%ebp
  801af3:	83 f5 1f             	xor    $0x1f,%ebp
  801af6:	0f 84 ac 00 00 00    	je     801ba8 <__umoddi3+0x108>
  801afc:	bf 20 00 00 00       	mov    $0x20,%edi
  801b01:	29 ef                	sub    %ebp,%edi
  801b03:	89 fe                	mov    %edi,%esi
  801b05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b09:	89 e9                	mov    %ebp,%ecx
  801b0b:	d3 e0                	shl    %cl,%eax
  801b0d:	89 d7                	mov    %edx,%edi
  801b0f:	89 f1                	mov    %esi,%ecx
  801b11:	d3 ef                	shr    %cl,%edi
  801b13:	09 c7                	or     %eax,%edi
  801b15:	89 e9                	mov    %ebp,%ecx
  801b17:	d3 e2                	shl    %cl,%edx
  801b19:	89 14 24             	mov    %edx,(%esp)
  801b1c:	89 d8                	mov    %ebx,%eax
  801b1e:	d3 e0                	shl    %cl,%eax
  801b20:	89 c2                	mov    %eax,%edx
  801b22:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b26:	d3 e0                	shl    %cl,%eax
  801b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b30:	89 f1                	mov    %esi,%ecx
  801b32:	d3 e8                	shr    %cl,%eax
  801b34:	09 d0                	or     %edx,%eax
  801b36:	d3 eb                	shr    %cl,%ebx
  801b38:	89 da                	mov    %ebx,%edx
  801b3a:	f7 f7                	div    %edi
  801b3c:	89 d3                	mov    %edx,%ebx
  801b3e:	f7 24 24             	mull   (%esp)
  801b41:	89 c6                	mov    %eax,%esi
  801b43:	89 d1                	mov    %edx,%ecx
  801b45:	39 d3                	cmp    %edx,%ebx
  801b47:	0f 82 87 00 00 00    	jb     801bd4 <__umoddi3+0x134>
  801b4d:	0f 84 91 00 00 00    	je     801be4 <__umoddi3+0x144>
  801b53:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b57:	29 f2                	sub    %esi,%edx
  801b59:	19 cb                	sbb    %ecx,%ebx
  801b5b:	89 d8                	mov    %ebx,%eax
  801b5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b61:	d3 e0                	shl    %cl,%eax
  801b63:	89 e9                	mov    %ebp,%ecx
  801b65:	d3 ea                	shr    %cl,%edx
  801b67:	09 d0                	or     %edx,%eax
  801b69:	89 e9                	mov    %ebp,%ecx
  801b6b:	d3 eb                	shr    %cl,%ebx
  801b6d:	89 da                	mov    %ebx,%edx
  801b6f:	83 c4 1c             	add    $0x1c,%esp
  801b72:	5b                   	pop    %ebx
  801b73:	5e                   	pop    %esi
  801b74:	5f                   	pop    %edi
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    
  801b77:	90                   	nop
  801b78:	89 fd                	mov    %edi,%ebp
  801b7a:	85 ff                	test   %edi,%edi
  801b7c:	75 0b                	jne    801b89 <__umoddi3+0xe9>
  801b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b83:	31 d2                	xor    %edx,%edx
  801b85:	f7 f7                	div    %edi
  801b87:	89 c5                	mov    %eax,%ebp
  801b89:	89 f0                	mov    %esi,%eax
  801b8b:	31 d2                	xor    %edx,%edx
  801b8d:	f7 f5                	div    %ebp
  801b8f:	89 c8                	mov    %ecx,%eax
  801b91:	f7 f5                	div    %ebp
  801b93:	89 d0                	mov    %edx,%eax
  801b95:	e9 44 ff ff ff       	jmp    801ade <__umoddi3+0x3e>
  801b9a:	66 90                	xchg   %ax,%ax
  801b9c:	89 c8                	mov    %ecx,%eax
  801b9e:	89 f2                	mov    %esi,%edx
  801ba0:	83 c4 1c             	add    $0x1c,%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5f                   	pop    %edi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    
  801ba8:	3b 04 24             	cmp    (%esp),%eax
  801bab:	72 06                	jb     801bb3 <__umoddi3+0x113>
  801bad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bb1:	77 0f                	ja     801bc2 <__umoddi3+0x122>
  801bb3:	89 f2                	mov    %esi,%edx
  801bb5:	29 f9                	sub    %edi,%ecx
  801bb7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bbb:	89 14 24             	mov    %edx,(%esp)
  801bbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bc2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bc6:	8b 14 24             	mov    (%esp),%edx
  801bc9:	83 c4 1c             	add    $0x1c,%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5e                   	pop    %esi
  801bce:	5f                   	pop    %edi
  801bcf:	5d                   	pop    %ebp
  801bd0:	c3                   	ret    
  801bd1:	8d 76 00             	lea    0x0(%esi),%esi
  801bd4:	2b 04 24             	sub    (%esp),%eax
  801bd7:	19 fa                	sbb    %edi,%edx
  801bd9:	89 d1                	mov    %edx,%ecx
  801bdb:	89 c6                	mov    %eax,%esi
  801bdd:	e9 71 ff ff ff       	jmp    801b53 <__umoddi3+0xb3>
  801be2:	66 90                	xchg   %ax,%ax
  801be4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801be8:	72 ea                	jb     801bd4 <__umoddi3+0x134>
  801bea:	89 d9                	mov    %ebx,%ecx
  801bec:	e9 62 ff ff ff       	jmp    801b53 <__umoddi3+0xb3>
