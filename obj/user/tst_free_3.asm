
obj/user/tst_free_3:     file format elf32-i386


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
  800031:	e8 02 14 00 00       	call   801438 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

#define numOfAccessesFor3MB 7
#define numOfAccessesFor8MB 4
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 7c 01 00 00    	sub    $0x17c,%esp
	int envID = sys_getenvid();
  800044:	e8 7c 2e 00 00       	call   802ec5 <sys_getenvid>
  800049:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80004f:	89 d0                	mov    %edx,%eax
  800051:	c1 e0 03             	shl    $0x3,%eax
  800054:	01 d0                	add    %edx,%eax
  800056:	01 c0                	add    %eax,%eax
  800058:	01 d0                	add    %edx,%eax
  80005a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int Mega = 1024*1024;
  80006e:	c7 45 cc 00 00 10 00 	movl   $0x100000,-0x34(%ebp)
	int kilo = 1024;
  800075:	c7 45 c8 00 04 00 00 	movl   $0x400,-0x38(%ebp)
	char minByte = 1<<7;
  80007c:	c6 45 c7 80          	movb   $0x80,-0x39(%ebp)
	char maxByte = 0x7F;
  800080:	c6 45 c6 7f          	movb   $0x7f,-0x3a(%ebp)
	short minShort = 1<<15 ;
  800084:	66 c7 45 c4 00 80    	movw   $0x8000,-0x3c(%ebp)
	short maxShort = 0x7FFF;
  80008a:	66 c7 45 c2 ff 7f    	movw   $0x7fff,-0x3e(%ebp)
	int minInt = 1<<31 ;
  800090:	c7 45 bc 00 00 00 80 	movl   $0x80000000,-0x44(%ebp)
	int maxInt = 0x7FFFFFFF;
  800097:	c7 45 b8 ff ff ff 7f 	movl   $0x7fffffff,-0x48(%ebp)
	int *intArr;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80009e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000a1:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000a7:	8b 00                	mov    (%eax),%eax
  8000a9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000ac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8000af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000b4:	3d 00 00 20 00       	cmp    $0x200000,%eax
  8000b9:	74 14                	je     8000cf <_main+0x97>
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	68 20 36 80 00       	push   $0x803620
  8000c3:	6a 20                	push   $0x20
  8000c5:	68 61 36 80 00       	push   $0x803661
  8000ca:	e8 2a 14 00 00       	call   8014f9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000d2:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8000d8:	83 c0 0c             	add    $0xc,%eax
  8000db:	8b 00                	mov    (%eax),%eax
  8000dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8000e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8000e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000e8:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 20 36 80 00       	push   $0x803620
  8000f7:	6a 21                	push   $0x21
  8000f9:	68 61 36 80 00       	push   $0x803661
  8000fe:	e8 f6 13 00 00       	call   8014f9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800103:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800106:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  80010c:	83 c0 18             	add    $0x18,%eax
  80010f:	8b 00                	mov    (%eax),%eax
  800111:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800114:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800117:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80011c:	3d 00 20 20 00       	cmp    $0x202000,%eax
  800121:	74 14                	je     800137 <_main+0xff>
  800123:	83 ec 04             	sub    $0x4,%esp
  800126:	68 20 36 80 00       	push   $0x803620
  80012b:	6a 22                	push   $0x22
  80012d:	68 61 36 80 00       	push   $0x803661
  800132:	e8 c2 13 00 00       	call   8014f9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800137:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80013a:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800140:	83 c0 24             	add    $0x24,%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800148:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80014b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800150:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 20 36 80 00       	push   $0x803620
  80015f:	6a 23                	push   $0x23
  800161:	68 61 36 80 00       	push   $0x803661
  800166:	e8 8e 13 00 00       	call   8014f9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80016b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80016e:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800174:	83 c0 30             	add    $0x30,%eax
  800177:	8b 00                	mov    (%eax),%eax
  800179:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80017c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80017f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800184:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800189:	74 14                	je     80019f <_main+0x167>
  80018b:	83 ec 04             	sub    $0x4,%esp
  80018e:	68 20 36 80 00       	push   $0x803620
  800193:	6a 24                	push   $0x24
  800195:	68 61 36 80 00       	push   $0x803661
  80019a:	e8 5a 13 00 00       	call   8014f9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80019f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001a2:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001a8:	83 c0 3c             	add    $0x3c,%eax
  8001ab:	8b 00                	mov    (%eax),%eax
  8001ad:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8001b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8001b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b8:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001bd:	74 14                	je     8001d3 <_main+0x19b>
  8001bf:	83 ec 04             	sub    $0x4,%esp
  8001c2:	68 20 36 80 00       	push   $0x803620
  8001c7:	6a 25                	push   $0x25
  8001c9:	68 61 36 80 00       	push   $0x803661
  8001ce:	e8 26 13 00 00       	call   8014f9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001d6:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  8001dc:	83 c0 48             	add    $0x48,%eax
  8001df:	8b 00                	mov    (%eax),%eax
  8001e1:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8001e4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8001e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ec:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 20 36 80 00       	push   $0x803620
  8001fb:	6a 26                	push   $0x26
  8001fd:	68 61 36 80 00       	push   $0x803661
  800202:	e8 f2 12 00 00       	call   8014f9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800207:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80020a:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800210:	83 c0 54             	add    $0x54,%eax
  800213:	8b 00                	mov    (%eax),%eax
  800215:	89 45 98             	mov    %eax,-0x68(%ebp)
  800218:	8b 45 98             	mov    -0x68(%ebp),%eax
  80021b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800220:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800225:	74 14                	je     80023b <_main+0x203>
  800227:	83 ec 04             	sub    $0x4,%esp
  80022a:	68 20 36 80 00       	push   $0x803620
  80022f:	6a 27                	push   $0x27
  800231:	68 61 36 80 00       	push   $0x803661
  800236:	e8 be 12 00 00       	call   8014f9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80023b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80023e:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800244:	83 c0 60             	add    $0x60,%eax
  800247:	8b 00                	mov    (%eax),%eax
  800249:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80024c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80024f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800254:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800259:	74 14                	je     80026f <_main+0x237>
  80025b:	83 ec 04             	sub    $0x4,%esp
  80025e:	68 20 36 80 00       	push   $0x803620
  800263:	6a 28                	push   $0x28
  800265:	68 61 36 80 00       	push   $0x803661
  80026a:	e8 8a 12 00 00       	call   8014f9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800272:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
  800278:	83 c0 6c             	add    $0x6c,%eax
  80027b:	8b 00                	mov    (%eax),%eax
  80027d:	89 45 90             	mov    %eax,-0x70(%ebp)
  800280:	8b 45 90             	mov    -0x70(%ebp),%eax
  800283:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800288:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028d:	74 14                	je     8002a3 <_main+0x26b>
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 20 36 80 00       	push   $0x803620
  800297:	6a 29                	push   $0x29
  800299:	68 61 36 80 00       	push   $0x803661
  80029e:	e8 56 12 00 00       	call   8014f9 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002a6:	8b 80 d4 02 00 00    	mov    0x2d4(%eax),%eax
  8002ac:	85 c0                	test   %eax,%eax
  8002ae:	74 14                	je     8002c4 <_main+0x28c>
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	68 74 36 80 00       	push   $0x803674
  8002b8:	6a 2a                	push   $0x2a
  8002ba:	68 61 36 80 00       	push   $0x803661
  8002bf:	e8 35 12 00 00       	call   8014f9 <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c4:	e8 ae 2c 00 00       	call   802f77 <sys_calculate_free_frames>
  8002c9:	89 45 8c             	mov    %eax,-0x74(%ebp)

	int indicesOf3MB[numOfAccessesFor3MB];
	int indicesOf8MB[numOfAccessesFor8MB];
	int var, i, j;

	void* ptr_allocations[20] = {0};
  8002cc:	8d 95 78 fe ff ff    	lea    -0x188(%ebp),%edx
  8002d2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	89 d7                	mov    %edx,%edi
  8002de:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		/*ALLOCATE 2 MB*/
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002e0:	e8 15 2d 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  8002e5:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8002f0:	83 ec 0c             	sub    $0xc,%esp
  8002f3:	50                   	push   %eax
  8002f4:	e8 ae 20 00 00       	call   8023a7 <malloc>
  8002f9:	83 c4 10             	add    $0x10,%esp
  8002fc:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800302:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800308:	85 c0                	test   %eax,%eax
  80030a:	79 0d                	jns    800319 <_main+0x2e1>
  80030c:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800312:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800317:	76 14                	jbe    80032d <_main+0x2f5>
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	68 bc 36 80 00       	push   $0x8036bc
  800321:	6a 39                	push   $0x39
  800323:	68 61 36 80 00       	push   $0x803661
  800328:	e8 cc 11 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032d:	e8 c8 2c 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800332:	2b 45 88             	sub    -0x78(%ebp),%eax
  800335:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033a:	74 14                	je     800350 <_main+0x318>
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	68 24 37 80 00       	push   $0x803724
  800344:	6a 3a                	push   $0x3a
  800346:	68 61 36 80 00       	push   $0x803661
  80034b:	e8 a9 11 00 00       	call   8014f9 <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800350:	e8 a5 2c 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800355:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800358:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80035b:	89 c2                	mov    %eax,%edx
  80035d:	01 d2                	add    %edx,%edx
  80035f:	01 d0                	add    %edx,%eax
  800361:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 3a 20 00 00       	call   8023a7 <malloc>
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800376:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  80037c:	89 c2                	mov    %eax,%edx
  80037e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800381:	01 c0                	add    %eax,%eax
  800383:	05 00 00 00 80       	add    $0x80000000,%eax
  800388:	39 c2                	cmp    %eax,%edx
  80038a:	72 16                	jb     8003a2 <_main+0x36a>
  80038c:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  800392:	89 c2                	mov    %eax,%edx
  800394:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800397:	01 c0                	add    %eax,%eax
  800399:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80039e:	39 c2                	cmp    %eax,%edx
  8003a0:	76 14                	jbe    8003b6 <_main+0x37e>
  8003a2:	83 ec 04             	sub    $0x4,%esp
  8003a5:	68 bc 36 80 00       	push   $0x8036bc
  8003aa:	6a 40                	push   $0x40
  8003ac:	68 61 36 80 00       	push   $0x803661
  8003b1:	e8 43 11 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b6:	e8 3f 2c 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  8003bb:	2b 45 88             	sub    -0x78(%ebp),%eax
  8003be:	89 c2                	mov    %eax,%edx
  8003c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003c3:	89 c1                	mov    %eax,%ecx
  8003c5:	01 c9                	add    %ecx,%ecx
  8003c7:	01 c8                	add    %ecx,%eax
  8003c9:	85 c0                	test   %eax,%eax
  8003cb:	79 05                	jns    8003d2 <_main+0x39a>
  8003cd:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003d2:	c1 f8 0c             	sar    $0xc,%eax
  8003d5:	39 c2                	cmp    %eax,%edx
  8003d7:	74 14                	je     8003ed <_main+0x3b5>
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 24 37 80 00       	push   $0x803724
  8003e1:	6a 41                	push   $0x41
  8003e3:	68 61 36 80 00       	push   $0x803661
  8003e8:	e8 0c 11 00 00       	call   8014f9 <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ed:	e8 08 2c 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  8003f2:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003f8:	c1 e0 03             	shl    $0x3,%eax
  8003fb:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8003fe:	83 ec 0c             	sub    $0xc,%esp
  800401:	50                   	push   %eax
  800402:	e8 a0 1f 00 00       	call   8023a7 <malloc>
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 5*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 5*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800410:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800416:	89 c1                	mov    %eax,%ecx
  800418:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80041b:	89 d0                	mov    %edx,%eax
  80041d:	c1 e0 02             	shl    $0x2,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	05 00 00 00 80       	add    $0x80000000,%eax
  800427:	39 c1                	cmp    %eax,%ecx
  800429:	72 1b                	jb     800446 <_main+0x40e>
  80042b:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800431:	89 c1                	mov    %eax,%ecx
  800433:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800436:	89 d0                	mov    %edx,%eax
  800438:	c1 e0 02             	shl    $0x2,%eax
  80043b:	01 d0                	add    %edx,%eax
  80043d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800442:	39 c1                	cmp    %eax,%ecx
  800444:	76 14                	jbe    80045a <_main+0x422>
  800446:	83 ec 04             	sub    $0x4,%esp
  800449:	68 bc 36 80 00       	push   $0x8036bc
  80044e:	6a 47                	push   $0x47
  800450:	68 61 36 80 00       	push   $0x803661
  800455:	e8 9f 10 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045a:	e8 9b 2b 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  80045f:	2b 45 88             	sub    -0x78(%ebp),%eax
  800462:	89 c2                	mov    %eax,%edx
  800464:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800467:	c1 e0 03             	shl    $0x3,%eax
  80046a:	85 c0                	test   %eax,%eax
  80046c:	79 05                	jns    800473 <_main+0x43b>
  80046e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800473:	c1 f8 0c             	sar    $0xc,%eax
  800476:	39 c2                	cmp    %eax,%edx
  800478:	74 14                	je     80048e <_main+0x456>
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	68 24 37 80 00       	push   $0x803724
  800482:	6a 48                	push   $0x48
  800484:	68 61 36 80 00       	push   $0x803661
  800489:	e8 6b 10 00 00       	call   8014f9 <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048e:	e8 67 2b 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800493:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[3] = malloc(7*Mega-kilo);
  800496:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	01 c0                	add    %eax,%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	50                   	push   %eax
  8004aa:	e8 f8 1e 00 00       	call   8023a7 <malloc>
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 13*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 13*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8004b8:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  8004be:	89 c1                	mov    %eax,%ecx
  8004c0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8004c3:	89 d0                	mov    %edx,%eax
  8004c5:	01 c0                	add    %eax,%eax
  8004c7:	01 d0                	add    %edx,%eax
  8004c9:	c1 e0 02             	shl    $0x2,%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d3:	39 c1                	cmp    %eax,%ecx
  8004d5:	72 1f                	jb     8004f6 <_main+0x4be>
  8004d7:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  8004dd:	89 c1                	mov    %eax,%ecx
  8004df:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8004e2:	89 d0                	mov    %edx,%eax
  8004e4:	01 c0                	add    %eax,%eax
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	c1 e0 02             	shl    $0x2,%eax
  8004eb:	01 d0                	add    %edx,%eax
  8004ed:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8004f2:	39 c1                	cmp    %eax,%ecx
  8004f4:	76 14                	jbe    80050a <_main+0x4d2>
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	68 bc 36 80 00       	push   $0x8036bc
  8004fe:	6a 4e                	push   $0x4e
  800500:	68 61 36 80 00       	push   $0x803661
  800505:	e8 ef 0f 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050a:	e8 eb 2a 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  80050f:	2b 45 88             	sub    -0x78(%ebp),%eax
  800512:	89 c1                	mov    %eax,%ecx
  800514:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800517:	89 d0                	mov    %edx,%eax
  800519:	01 c0                	add    %eax,%eax
  80051b:	01 d0                	add    %edx,%eax
  80051d:	01 c0                	add    %eax,%eax
  80051f:	01 d0                	add    %edx,%eax
  800521:	85 c0                	test   %eax,%eax
  800523:	79 05                	jns    80052a <_main+0x4f2>
  800525:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052a:	c1 f8 0c             	sar    $0xc,%eax
  80052d:	39 c1                	cmp    %eax,%ecx
  80052f:	74 14                	je     800545 <_main+0x50d>
  800531:	83 ec 04             	sub    $0x4,%esp
  800534:	68 24 37 80 00       	push   $0x803724
  800539:	6a 4f                	push   $0x4f
  80053b:	68 61 36 80 00       	push   $0x803661
  800540:	e8 b4 0f 00 00       	call   8014f9 <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800545:	e8 2d 2a 00 00       	call   802f77 <sys_calculate_free_frames>
  80054a:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054d:	e8 3e 2a 00 00       	call   802f90 <sys_calculate_modified_frames>
  800552:	89 45 80             	mov    %eax,-0x80(%ebp)
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	89 c2                	mov    %eax,%edx
  80055a:	01 d2                	add    %edx,%edx
  80055c:	01 d0                	add    %edx,%eax
  80055e:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800561:	48                   	dec    %eax
  800562:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
  800568:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80056e:	bf 07 00 00 00       	mov    $0x7,%edi
  800573:	99                   	cltd   
  800574:	f7 ff                	idiv   %edi
  800576:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  80057c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800583:	eb 19                	jmp    80059e <_main+0x566>
		{
			indicesOf3MB[var] = var * inc ;
  800585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800588:	0f af 85 78 ff ff ff 	imul   -0x88(%ebp),%eax
  80058f:	89 c2                	mov    %eax,%edx
  800591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800594:	89 94 85 d8 fe ff ff 	mov    %edx,-0x128(%ebp,%eax,4)
		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
		int modFrames = sys_calculate_modified_frames();
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  80059b:	ff 45 e4             	incl   -0x1c(%ebp)
  80059e:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8005a2:	7e e1                	jle    800585 <_main+0x54d>
		{
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
  8005a4:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8005aa:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		//3 reads
		int sum = 0;
  8005b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005be:	eb 1f                	jmp    8005df <_main+0x5a7>
		{
			sum += byteArr[indicesOf3MB[var]] ;
  8005c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005c3:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
  8005ca:	89 c2                	mov    %eax,%edx
  8005cc:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005d2:	01 d0                	add    %edx,%eax
  8005d4:	8a 00                	mov    (%eax),%al
  8005d6:	0f be c0             	movsbl %al,%eax
  8005d9:	01 45 dc             	add    %eax,-0x24(%ebp)
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
		//3 reads
		int sum = 0;
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005dc:	ff 45 e4             	incl   -0x1c(%ebp)
  8005df:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8005e3:	7e db                	jle    8005c0 <_main+0x588>
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005e5:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8005ec:	eb 1c                	jmp    80060a <_main+0x5d2>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
  8005ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f1:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
  8005f8:	89 c2                	mov    %eax,%edx
  8005fa:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800600:	01 c2                	add    %eax,%edx
  800602:	8a 45 c6             	mov    -0x3a(%ebp),%al
  800605:	88 02                	mov    %al,(%edx)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  800607:	ff 45 e4             	incl   -0x1c(%ebp)
  80060a:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  80060e:	7e de                	jle    8005ee <_main+0x5b6>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800610:	8b 55 84             	mov    -0x7c(%ebp),%edx
  800613:	8b 45 80             	mov    -0x80(%ebp),%eax
  800616:	01 d0                	add    %edx,%eax
  800618:	89 c6                	mov    %eax,%esi
  80061a:	e8 58 29 00 00       	call   802f77 <sys_calculate_free_frames>
  80061f:	89 c3                	mov    %eax,%ebx
  800621:	e8 6a 29 00 00       	call   802f90 <sys_calculate_modified_frames>
  800626:	01 d8                	add    %ebx,%eax
  800628:	29 c6                	sub    %eax,%esi
  80062a:	89 f0                	mov    %esi,%eax
  80062c:	83 f8 02             	cmp    $0x2,%eax
  80062f:	74 14                	je     800645 <_main+0x60d>
  800631:	83 ec 04             	sub    $0x4,%esp
  800634:	68 54 37 80 00       	push   $0x803754
  800639:	6a 67                	push   $0x67
  80063b:	68 61 36 80 00       	push   $0x803661
  800640:	e8 b4 0e 00 00       	call   8014f9 <_panic>
		int found = 0;
  800645:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  80064c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800653:	eb 74                	jmp    8006c9 <_main+0x691>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800655:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80065c:	eb 5b                	jmp    8006b9 <_main+0x681>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  80065e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800661:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800667:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80066a:	89 d0                	mov    %edx,%eax
  80066c:	01 c0                	add    %eax,%eax
  80066e:	01 d0                	add    %edx,%eax
  800670:	c1 e0 02             	shl    $0x2,%eax
  800673:	01 c8                	add    %ecx,%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  80067d:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800683:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800688:	89 c2                	mov    %eax,%edx
  80068a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068d:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
  800694:	89 c1                	mov    %eax,%ecx
  800696:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80069c:	01 c8                	add    %ecx,%eax
  80069e:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8006a4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8006aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006af:	39 c2                	cmp    %eax,%edx
  8006b1:	75 03                	jne    8006b6 <_main+0x67e>
				{
					found++;
  8006b3:	ff 45 d8             	incl   -0x28(%ebp)
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8006b6:	ff 45 e0             	incl   -0x20(%ebp)
  8006b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006bc:	8b 50 74             	mov    0x74(%eax),%edx
  8006bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c2:	39 c2                	cmp    %eax,%edx
  8006c4:	77 98                	ja     80065e <_main+0x626>
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8006c6:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c9:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8006cd:	7e 86                	jle    800655 <_main+0x61d>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor3MB) panic("malloc: page is not added to WS");
  8006cf:	83 7d d8 07          	cmpl   $0x7,-0x28(%ebp)
  8006d3:	74 14                	je     8006e9 <_main+0x6b1>
  8006d5:	83 ec 04             	sub    $0x4,%esp
  8006d8:	68 98 37 80 00       	push   $0x803798
  8006dd:	6a 73                	push   $0x73
  8006df:	68 61 36 80 00       	push   $0x803661
  8006e4:	e8 10 0e 00 00       	call   8014f9 <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e9:	e8 89 28 00 00       	call   802f77 <sys_calculate_free_frames>
  8006ee:	89 45 84             	mov    %eax,-0x7c(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006f1:	e8 9a 28 00 00       	call   802f90 <sys_calculate_modified_frames>
  8006f6:	89 45 80             	mov    %eax,-0x80(%ebp)
		lastIndexOfShort = (8*Mega-kilo)/sizeof(short) - 1;
  8006f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006fc:	c1 e0 03             	shl    $0x3,%eax
  8006ff:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800702:	d1 e8                	shr    %eax
  800704:	48                   	dec    %eax
  800705:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		indicesOf8MB[0] = lastIndexOfShort * 1 / 2;
  80070b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800711:	89 c2                	mov    %eax,%edx
  800713:	c1 ea 1f             	shr    $0x1f,%edx
  800716:	01 d0                	add    %edx,%eax
  800718:	d1 f8                	sar    %eax
  80071a:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
		indicesOf8MB[1] = lastIndexOfShort * 2 / 3;
  800720:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800726:	01 c0                	add    %eax,%eax
  800728:	89 c1                	mov    %eax,%ecx
  80072a:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80072f:	f7 e9                	imul   %ecx
  800731:	c1 f9 1f             	sar    $0x1f,%ecx
  800734:	89 d0                	mov    %edx,%eax
  800736:	29 c8                	sub    %ecx,%eax
  800738:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
		indicesOf8MB[2] = lastIndexOfShort * 3 / 4;
  80073e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800744:	89 c2                	mov    %eax,%edx
  800746:	01 d2                	add    %edx,%edx
  800748:	01 d0                	add    %edx,%eax
  80074a:	85 c0                	test   %eax,%eax
  80074c:	79 03                	jns    800751 <_main+0x719>
  80074e:	83 c0 03             	add    $0x3,%eax
  800751:	c1 f8 02             	sar    $0x2,%eax
  800754:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
		indicesOf8MB[3] = lastIndexOfShort ;
  80075a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800760:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)

		//use one of the read pages from 3 MB to avoid victimizing it
		sum += byteArr[indicesOf3MB[0]] ;
  800766:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  80076c:	89 c2                	mov    %eax,%edx
  80076e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800774:	01 d0                	add    %edx,%eax
  800776:	8a 00                	mov    (%eax),%al
  800778:	0f be c0             	movsbl %al,%eax
  80077b:	01 45 dc             	add    %eax,-0x24(%ebp)

		shortArr = (short *) ptr_allocations[2];
  80077e:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800784:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		//2 reads
		sum = 0;
  80078a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  800791:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800798:	eb 20                	jmp    8007ba <_main+0x782>
		{
			sum += shortArr[indicesOf8MB[var]] ;
  80079a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80079d:	8b 84 85 c8 fe ff ff 	mov    -0x138(%ebp,%eax,4),%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	66 8b 00             	mov    (%eax),%ax
  8007b3:	98                   	cwtl   
  8007b4:	01 45 dc             	add    %eax,-0x24(%ebp)
		sum += byteArr[indicesOf3MB[0]] ;

		shortArr = (short *) ptr_allocations[2];
		//2 reads
		sum = 0;
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  8007b7:	ff 45 e4             	incl   -0x1c(%ebp)
  8007ba:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8007be:	7e da                	jle    80079a <_main+0x762>
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007c0:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8007c7:	eb 20                	jmp    8007e9 <_main+0x7b1>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
  8007c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007cc:	8b 84 85 c8 fe ff ff 	mov    -0x138(%ebp,%eax,4),%eax
  8007d3:	01 c0                	add    %eax,%eax
  8007d5:	89 c2                	mov    %eax,%edx
  8007d7:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8007dd:	01 c2                	add    %eax,%edx
  8007df:	66 8b 45 c2          	mov    -0x3e(%ebp),%ax
  8007e3:	66 89 02             	mov    %ax,(%edx)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007e6:	ff 45 e4             	incl   -0x1c(%ebp)
  8007e9:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8007ed:	7e da                	jle    8007c9 <_main+0x791>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007ef:	8b 5d 84             	mov    -0x7c(%ebp),%ebx
  8007f2:	e8 80 27 00 00       	call   802f77 <sys_calculate_free_frames>
  8007f7:	29 c3                	sub    %eax,%ebx
  8007f9:	89 d8                	mov    %ebx,%eax
  8007fb:	83 f8 04             	cmp    $0x4,%eax
  8007fe:	74 17                	je     800817 <_main+0x7df>
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	68 54 37 80 00       	push   $0x803754
  800808:	68 8e 00 00 00       	push   $0x8e
  80080d:	68 61 36 80 00       	push   $0x803661
  800812:	e8 e2 0c 00 00       	call   8014f9 <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800817:	8b 5d 80             	mov    -0x80(%ebp),%ebx
  80081a:	e8 71 27 00 00       	call   802f90 <sys_calculate_modified_frames>
  80081f:	29 c3                	sub    %eax,%ebx
  800821:	89 d8                	mov    %ebx,%eax
  800823:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800826:	74 17                	je     80083f <_main+0x807>
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 54 37 80 00       	push   $0x803754
  800830:	68 8f 00 00 00       	push   $0x8f
  800835:	68 61 36 80 00       	push   $0x803661
  80083a:	e8 ba 0c 00 00       	call   8014f9 <_panic>
		found = 0;
  80083f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  800846:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80084d:	eb 76                	jmp    8008c5 <_main+0x88d>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80084f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800856:	eb 5d                	jmp    8008b5 <_main+0x87d>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[indicesOf8MB[var]])), PAGE_SIZE))
  800858:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80085b:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800861:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800864:	89 d0                	mov    %edx,%eax
  800866:	01 c0                	add    %eax,%eax
  800868:	01 d0                	add    %edx,%eax
  80086a:	c1 e0 02             	shl    $0x2,%eax
  80086d:	01 c8                	add    %ecx,%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800877:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80087d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800882:	89 c2                	mov    %eax,%edx
  800884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800887:	8b 84 85 c8 fe ff ff 	mov    -0x138(%ebp,%eax,4),%eax
  80088e:	01 c0                	add    %eax,%eax
  800890:	89 c1                	mov    %eax,%ecx
  800892:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800898:	01 c8                	add    %ecx,%eax
  80089a:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  8008a0:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8008a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ab:	39 c2                	cmp    %eax,%edx
  8008ad:	75 03                	jne    8008b2 <_main+0x87a>
				{
					found++;
  8008af:	ff 45 d8             	incl   -0x28(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8008b2:	ff 45 e0             	incl   -0x20(%ebp)
  8008b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008b8:	8b 50 74             	mov    0x74(%eax),%edx
  8008bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008be:	39 c2                	cmp    %eax,%edx
  8008c0:	77 96                	ja     800858 <_main+0x820>
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  8008c2:	ff 45 e4             	incl   -0x1c(%ebp)
  8008c5:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8008c9:	7e 84                	jle    80084f <_main+0x817>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor8MB) panic("malloc: page is not added to WS");
  8008cb:	83 7d d8 04          	cmpl   $0x4,-0x28(%ebp)
  8008cf:	74 17                	je     8008e8 <_main+0x8b0>
  8008d1:	83 ec 04             	sub    $0x4,%esp
  8008d4:	68 98 37 80 00       	push   $0x803798
  8008d9:	68 9b 00 00 00       	push   $0x9b
  8008de:	68 61 36 80 00       	push   $0x803661
  8008e3:	e8 11 0c 00 00       	call   8014f9 <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008e8:	e8 8a 26 00 00       	call   802f77 <sys_calculate_free_frames>
  8008ed:	89 45 84             	mov    %eax,-0x7c(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008f0:	e8 9b 26 00 00       	call   802f90 <sys_calculate_modified_frames>
  8008f5:	89 45 80             	mov    %eax,-0x80(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008f8:	e8 fd 26 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  8008fd:	89 45 88             	mov    %eax,-0x78(%ebp)

		free(ptr_allocations[1]);
  800900:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  800906:	83 ec 0c             	sub    $0xc,%esp
  800909:	50                   	push   %eax
  80090a:	e8 3a 24 00 00       	call   802d49 <free>
  80090f:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800912:	e8 e3 26 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800917:	8b 55 88             	mov    -0x78(%ebp),%edx
  80091a:	89 d1                	mov    %edx,%ecx
  80091c:	29 c1                	sub    %eax,%ecx
  80091e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800921:	89 c2                	mov    %eax,%edx
  800923:	01 d2                	add    %edx,%edx
  800925:	01 d0                	add    %edx,%eax
  800927:	85 c0                	test   %eax,%eax
  800929:	79 05                	jns    800930 <_main+0x8f8>
  80092b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800930:	c1 f8 0c             	sar    $0xc,%eax
  800933:	39 c1                	cmp    %eax,%ecx
  800935:	74 17                	je     80094e <_main+0x916>
  800937:	83 ec 04             	sub    $0x4,%esp
  80093a:	68 b8 37 80 00       	push   $0x8037b8
  80093f:	68 a5 00 00 00       	push   $0xa5
  800944:	68 61 36 80 00       	push   $0x803661
  800949:	e8 ab 0b 00 00       	call   8014f9 <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  80094e:	e8 24 26 00 00       	call   802f77 <sys_calculate_free_frames>
  800953:	89 c2                	mov    %eax,%edx
  800955:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800958:	29 c2                	sub    %eax,%edx
  80095a:	89 d0                	mov    %edx,%eax
  80095c:	83 f8 07             	cmp    $0x7,%eax
  80095f:	74 17                	je     800978 <_main+0x940>
  800961:	83 ec 04             	sub    $0x4,%esp
  800964:	68 f4 37 80 00       	push   $0x8037f4
  800969:	68 a7 00 00 00       	push   $0xa7
  80096e:	68 61 36 80 00       	push   $0x803661
  800973:	e8 81 0b 00 00       	call   8014f9 <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800978:	e8 13 26 00 00       	call   802f90 <sys_calculate_modified_frames>
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800982:	29 c2                	sub    %eax,%edx
  800984:	89 d0                	mov    %edx,%eax
  800986:	83 f8 02             	cmp    $0x2,%eax
  800989:	74 17                	je     8009a2 <_main+0x96a>
  80098b:	83 ec 04             	sub    $0x4,%esp
  80098e:	68 48 38 80 00       	push   $0x803848
  800993:	68 a8 00 00 00       	push   $0xa8
  800998:	68 61 36 80 00       	push   $0x803661
  80099d:	e8 57 0b 00 00       	call   8014f9 <_panic>
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8009a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009a9:	e9 88 00 00 00       	jmp    800a36 <_main+0x9fe>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8009ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b5:	eb 6f                	jmp    800a26 <_main+0x9ee>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  8009b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009ba:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8009c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c3:	89 d0                	mov    %edx,%eax
  8009c5:	01 c0                	add    %eax,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	c1 e0 02             	shl    $0x2,%eax
  8009cc:	01 c8                	add    %ecx,%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8009d6:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8009dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009e1:	89 c2                	mov    %eax,%edx
  8009e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e6:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
  8009ed:	89 c1                	mov    %eax,%ecx
  8009ef:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8009f5:	01 c8                	add    %ecx,%eax
  8009f7:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  8009fd:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800a03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a08:	39 c2                	cmp    %eax,%edx
  800a0a:	75 17                	jne    800a23 <_main+0x9eb>
				{
					panic("free: page is not removed from WS");
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	68 80 38 80 00       	push   $0x803880
  800a14:	68 b0 00 00 00       	push   $0xb0
  800a19:	68 61 36 80 00       	push   $0x803661
  800a1e:	e8 d6 0a 00 00       	call   8014f9 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800a23:	ff 45 e0             	incl   -0x20(%ebp)
  800a26:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a29:	8b 50 74             	mov    0x74(%eax),%edx
  800a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2f:	39 c2                	cmp    %eax,%edx
  800a31:	77 84                	ja     8009b7 <_main+0x97f>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800a33:	ff 45 e4             	incl   -0x1c(%ebp)
  800a36:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800a3a:	0f 8e 6e ff ff ff    	jle    8009ae <_main+0x976>
			}
		}



		freeFrames = sys_calculate_free_frames() ;
  800a40:	e8 32 25 00 00       	call   802f77 <sys_calculate_free_frames>
  800a45:	89 45 84             	mov    %eax,-0x7c(%ebp)
		shortArr = (short *) ptr_allocations[2];
  800a48:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800a4e:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800a54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a57:	01 c0                	add    %eax,%eax
  800a59:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800a5c:	d1 e8                	shr    %eax
  800a5e:	48                   	dec    %eax
  800a5f:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		shortArr[0] = minShort;
  800a65:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800a6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a6e:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800a71:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800a77:	01 c0                	add    %eax,%eax
  800a79:	89 c2                	mov    %eax,%edx
  800a7b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800a81:	01 c2                	add    %eax,%edx
  800a83:	66 8b 45 c2          	mov    -0x3e(%ebp),%ax
  800a87:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8a:	8b 5d 84             	mov    -0x7c(%ebp),%ebx
  800a8d:	e8 e5 24 00 00       	call   802f77 <sys_calculate_free_frames>
  800a92:	29 c3                	sub    %eax,%ebx
  800a94:	89 d8                	mov    %ebx,%eax
  800a96:	83 f8 02             	cmp    $0x2,%eax
  800a99:	74 17                	je     800ab2 <_main+0xa7a>
  800a9b:	83 ec 04             	sub    $0x4,%esp
  800a9e:	68 54 37 80 00       	push   $0x803754
  800aa3:	68 bc 00 00 00       	push   $0xbc
  800aa8:	68 61 36 80 00       	push   $0x803661
  800aad:	e8 47 0a 00 00       	call   8014f9 <_panic>
		found = 0;
  800ab2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ab9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ac0:	e9 a3 00 00 00       	jmp    800b68 <_main+0xb30>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ac5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ac8:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800ace:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ad1:	89 d0                	mov    %edx,%eax
  800ad3:	01 c0                	add    %eax,%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	01 c8                	add    %ecx,%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800ae4:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800aea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800aef:	89 c2                	mov    %eax,%edx
  800af1:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800af7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800afd:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b08:	39 c2                	cmp    %eax,%edx
  800b0a:	75 03                	jne    800b0f <_main+0xad7>
				found++;
  800b0c:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  800b0f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b12:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800b18:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b1b:	89 d0                	mov    %edx,%eax
  800b1d:	01 c0                	add    %eax,%eax
  800b1f:	01 d0                	add    %edx,%eax
  800b21:	c1 e0 02             	shl    $0x2,%eax
  800b24:	01 c8                	add    %ecx,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b2e:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b39:	89 c2                	mov    %eax,%edx
  800b3b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800b41:	01 c0                	add    %eax,%eax
  800b43:	89 c1                	mov    %eax,%ecx
  800b45:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800b4b:	01 c8                	add    %ecx,%eax
  800b4d:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800b53:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800b59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b5e:	39 c2                	cmp    %eax,%edx
  800b60:	75 03                	jne    800b65 <_main+0xb2d>
				found++;
  800b62:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b65:	ff 45 e4             	incl   -0x1c(%ebp)
  800b68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b6b:	8b 50 74             	mov    0x74(%eax),%edx
  800b6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b71:	39 c2                	cmp    %eax,%edx
  800b73:	0f 87 4c ff ff ff    	ja     800ac5 <_main+0xa8d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800b79:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800b7d:	74 17                	je     800b96 <_main+0xb5e>
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	68 98 37 80 00       	push   $0x803798
  800b87:	68 c5 00 00 00       	push   $0xc5
  800b8c:	68 61 36 80 00       	push   $0x803661
  800b91:	e8 63 09 00 00       	call   8014f9 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b96:	e8 5f 24 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800b9b:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800b9e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba1:	01 c0                	add    %eax,%eax
  800ba3:	83 ec 0c             	sub    $0xc,%esp
  800ba6:	50                   	push   %eax
  800ba7:	e8 fb 17 00 00       	call   8023a7 <malloc>
  800bac:	83 c4 10             	add    $0x10,%esp
  800baf:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bb5:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800bbb:	89 c2                	mov    %eax,%edx
  800bbd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800bc0:	c1 e0 02             	shl    $0x2,%eax
  800bc3:	05 00 00 00 80       	add    $0x80000000,%eax
  800bc8:	39 c2                	cmp    %eax,%edx
  800bca:	72 17                	jb     800be3 <_main+0xbab>
  800bcc:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800bd2:	89 c2                	mov    %eax,%edx
  800bd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800bd7:	c1 e0 02             	shl    $0x2,%eax
  800bda:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800bdf:	39 c2                	cmp    %eax,%edx
  800be1:	76 17                	jbe    800bfa <_main+0xbc2>
  800be3:	83 ec 04             	sub    $0x4,%esp
  800be6:	68 bc 36 80 00       	push   $0x8036bc
  800beb:	68 ca 00 00 00       	push   $0xca
  800bf0:	68 61 36 80 00       	push   $0x803661
  800bf5:	e8 ff 08 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800bfa:	e8 fb 23 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800bff:	2b 45 88             	sub    -0x78(%ebp),%eax
  800c02:	83 f8 01             	cmp    $0x1,%eax
  800c05:	74 17                	je     800c1e <_main+0xbe6>
  800c07:	83 ec 04             	sub    $0x4,%esp
  800c0a:	68 24 37 80 00       	push   $0x803724
  800c0f:	68 cb 00 00 00       	push   $0xcb
  800c14:	68 61 36 80 00       	push   $0x803661
  800c19:	e8 db 08 00 00       	call   8014f9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c1e:	e8 54 23 00 00       	call   802f77 <sys_calculate_free_frames>
  800c23:	89 45 84             	mov    %eax,-0x7c(%ebp)
		intArr = (int *) ptr_allocations[2];
  800c26:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800c2c:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800c32:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c35:	01 c0                	add    %eax,%eax
  800c37:	c1 e8 02             	shr    $0x2,%eax
  800c3a:	48                   	dec    %eax
  800c3b:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		intArr[0] = minInt;
  800c41:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800c47:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800c4a:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800c4c:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800c52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c59:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800c5f:	01 c2                	add    %eax,%edx
  800c61:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800c64:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800c66:	8b 5d 84             	mov    -0x7c(%ebp),%ebx
  800c69:	e8 09 23 00 00       	call   802f77 <sys_calculate_free_frames>
  800c6e:	29 c3                	sub    %eax,%ebx
  800c70:	89 d8                	mov    %ebx,%eax
  800c72:	83 f8 02             	cmp    $0x2,%eax
  800c75:	74 17                	je     800c8e <_main+0xc56>
  800c77:	83 ec 04             	sub    $0x4,%esp
  800c7a:	68 54 37 80 00       	push   $0x803754
  800c7f:	68 d2 00 00 00       	push   $0xd2
  800c84:	68 61 36 80 00       	push   $0x803661
  800c89:	e8 6b 08 00 00       	call   8014f9 <_panic>
		found = 0;
  800c8e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c95:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800c9c:	e9 a6 00 00 00       	jmp    800d47 <_main+0xd0f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800ca1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ca4:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800caa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cad:	89 d0                	mov    %edx,%eax
  800caf:	01 c0                	add    %eax,%eax
  800cb1:	01 d0                	add    %edx,%eax
  800cb3:	c1 e0 02             	shl    $0x2,%eax
  800cb6:	01 c8                	add    %ecx,%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800cc0:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800cc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ccb:	89 c2                	mov    %eax,%edx
  800ccd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cd3:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800cd9:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800cdf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ce4:	39 c2                	cmp    %eax,%edx
  800ce6:	75 03                	jne    800ceb <_main+0xcb3>
				found++;
  800ce8:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800ceb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cee:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800cf4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cf7:	89 d0                	mov    %edx,%eax
  800cf9:	01 c0                	add    %eax,%eax
  800cfb:	01 d0                	add    %edx,%eax
  800cfd:	c1 e0 02             	shl    $0x2,%eax
  800d00:	01 c8                	add    %ecx,%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d0a:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d15:	89 c2                	mov    %eax,%edx
  800d17:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d1d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d24:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d2a:	01 c8                	add    %ecx,%eax
  800d2c:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800d32:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800d38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d3d:	39 c2                	cmp    %eax,%edx
  800d3f:	75 03                	jne    800d44 <_main+0xd0c>
				found++;
  800d41:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d44:	ff 45 e4             	incl   -0x1c(%ebp)
  800d47:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d4a:	8b 50 74             	mov    0x74(%eax),%edx
  800d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d50:	39 c2                	cmp    %eax,%edx
  800d52:	0f 87 49 ff ff ff    	ja     800ca1 <_main+0xc69>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800d58:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800d5c:	74 17                	je     800d75 <_main+0xd3d>
  800d5e:	83 ec 04             	sub    $0x4,%esp
  800d61:	68 98 37 80 00       	push   $0x803798
  800d66:	68 db 00 00 00       	push   $0xdb
  800d6b:	68 61 36 80 00       	push   $0x803661
  800d70:	e8 84 07 00 00       	call   8014f9 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d75:	e8 fd 21 00 00       	call   802f77 <sys_calculate_free_frames>
  800d7a:	89 45 84             	mov    %eax,-0x7c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d7d:	e8 78 22 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800d82:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800d85:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800d88:	01 c0                	add    %eax,%eax
  800d8a:	83 ec 0c             	sub    $0xc,%esp
  800d8d:	50                   	push   %eax
  800d8e:	e8 14 16 00 00       	call   8023a7 <malloc>
  800d93:	83 c4 10             	add    $0x10,%esp
  800d96:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800d9c:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800da2:	89 c2                	mov    %eax,%edx
  800da4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800da7:	c1 e0 02             	shl    $0x2,%eax
  800daa:	89 c1                	mov    %eax,%ecx
  800dac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800daf:	c1 e0 02             	shl    $0x2,%eax
  800db2:	01 c8                	add    %ecx,%eax
  800db4:	05 00 00 00 80       	add    $0x80000000,%eax
  800db9:	39 c2                	cmp    %eax,%edx
  800dbb:	72 21                	jb     800dde <_main+0xda6>
  800dbd:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800dc3:	89 c2                	mov    %eax,%edx
  800dc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800dc8:	c1 e0 02             	shl    $0x2,%eax
  800dcb:	89 c1                	mov    %eax,%ecx
  800dcd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800dd0:	c1 e0 02             	shl    $0x2,%eax
  800dd3:	01 c8                	add    %ecx,%eax
  800dd5:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800dda:	39 c2                	cmp    %eax,%edx
  800ddc:	76 17                	jbe    800df5 <_main+0xdbd>
  800dde:	83 ec 04             	sub    $0x4,%esp
  800de1:	68 bc 36 80 00       	push   $0x8036bc
  800de6:	68 e1 00 00 00       	push   $0xe1
  800deb:	68 61 36 80 00       	push   $0x803661
  800df0:	e8 04 07 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800df5:	e8 00 22 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800dfa:	2b 45 88             	sub    -0x78(%ebp),%eax
  800dfd:	83 f8 01             	cmp    $0x1,%eax
  800e00:	74 17                	je     800e19 <_main+0xde1>
  800e02:	83 ec 04             	sub    $0x4,%esp
  800e05:	68 24 37 80 00       	push   $0x803724
  800e0a:	68 e2 00 00 00       	push   $0xe2
  800e0f:	68 61 36 80 00       	push   $0x803661
  800e14:	e8 e0 06 00 00       	call   8014f9 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e19:	e8 dc 21 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800e1e:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800e21:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800e24:	89 d0                	mov    %edx,%eax
  800e26:	01 c0                	add    %eax,%eax
  800e28:	01 d0                	add    %edx,%eax
  800e2a:	01 c0                	add    %eax,%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 70 15 00 00       	call   8023a7 <malloc>
  800e37:	83 c4 10             	add    $0x10,%esp
  800e3a:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800e40:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800e46:	89 c2                	mov    %eax,%edx
  800e48:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e4b:	c1 e0 02             	shl    $0x2,%eax
  800e4e:	89 c1                	mov    %eax,%ecx
  800e50:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800e53:	c1 e0 03             	shl    $0x3,%eax
  800e56:	01 c8                	add    %ecx,%eax
  800e58:	05 00 00 00 80       	add    $0x80000000,%eax
  800e5d:	39 c2                	cmp    %eax,%edx
  800e5f:	72 21                	jb     800e82 <_main+0xe4a>
  800e61:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800e67:	89 c2                	mov    %eax,%edx
  800e69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e6c:	c1 e0 02             	shl    $0x2,%eax
  800e6f:	89 c1                	mov    %eax,%ecx
  800e71:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800e74:	c1 e0 03             	shl    $0x3,%eax
  800e77:	01 c8                	add    %ecx,%eax
  800e79:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800e7e:	39 c2                	cmp    %eax,%edx
  800e80:	76 17                	jbe    800e99 <_main+0xe61>
  800e82:	83 ec 04             	sub    $0x4,%esp
  800e85:	68 bc 36 80 00       	push   $0x8036bc
  800e8a:	68 e8 00 00 00       	push   $0xe8
  800e8f:	68 61 36 80 00       	push   $0x803661
  800e94:	e8 60 06 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800e99:	e8 5c 21 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800e9e:	2b 45 88             	sub    -0x78(%ebp),%eax
  800ea1:	83 f8 02             	cmp    $0x2,%eax
  800ea4:	74 17                	je     800ebd <_main+0xe85>
  800ea6:	83 ec 04             	sub    $0x4,%esp
  800ea9:	68 24 37 80 00       	push   $0x803724
  800eae:	68 e9 00 00 00       	push   $0xe9
  800eb3:	68 61 36 80 00       	push   $0x803661
  800eb8:	e8 3c 06 00 00       	call   8014f9 <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800ebd:	e8 b5 20 00 00       	call   802f77 <sys_calculate_free_frames>
  800ec2:	89 45 84             	mov    %eax,-0x7c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ec5:	e8 30 21 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800eca:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800ecd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800ed0:	89 c2                	mov    %eax,%edx
  800ed2:	01 d2                	add    %edx,%edx
  800ed4:	01 d0                	add    %edx,%eax
  800ed6:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800ed9:	83 ec 0c             	sub    $0xc,%esp
  800edc:	50                   	push   %eax
  800edd:	e8 c5 14 00 00       	call   8023a7 <malloc>
  800ee2:	83 c4 10             	add    $0x10,%esp
  800ee5:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800eeb:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800ef1:	89 c2                	mov    %eax,%edx
  800ef3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800ef6:	c1 e0 02             	shl    $0x2,%eax
  800ef9:	89 c1                	mov    %eax,%ecx
  800efb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800efe:	c1 e0 04             	shl    $0x4,%eax
  800f01:	01 c8                	add    %ecx,%eax
  800f03:	05 00 00 00 80       	add    $0x80000000,%eax
  800f08:	39 c2                	cmp    %eax,%edx
  800f0a:	72 21                	jb     800f2d <_main+0xef5>
  800f0c:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800f12:	89 c2                	mov    %eax,%edx
  800f14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800f17:	c1 e0 02             	shl    $0x2,%eax
  800f1a:	89 c1                	mov    %eax,%ecx
  800f1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800f1f:	c1 e0 04             	shl    $0x4,%eax
  800f22:	01 c8                	add    %ecx,%eax
  800f24:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800f29:	39 c2                	cmp    %eax,%edx
  800f2b:	76 17                	jbe    800f44 <_main+0xf0c>
  800f2d:	83 ec 04             	sub    $0x4,%esp
  800f30:	68 bc 36 80 00       	push   $0x8036bc
  800f35:	68 f0 00 00 00       	push   $0xf0
  800f3a:	68 61 36 80 00       	push   $0x803661
  800f3f:	e8 b5 05 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f44:	e8 b1 20 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800f49:	2b 45 88             	sub    -0x78(%ebp),%eax
  800f4c:	89 c2                	mov    %eax,%edx
  800f4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800f51:	89 c1                	mov    %eax,%ecx
  800f53:	01 c9                	add    %ecx,%ecx
  800f55:	01 c8                	add    %ecx,%eax
  800f57:	85 c0                	test   %eax,%eax
  800f59:	79 05                	jns    800f60 <_main+0xf28>
  800f5b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800f60:	c1 f8 0c             	sar    $0xc,%eax
  800f63:	39 c2                	cmp    %eax,%edx
  800f65:	74 17                	je     800f7e <_main+0xf46>
  800f67:	83 ec 04             	sub    $0x4,%esp
  800f6a:	68 24 37 80 00       	push   $0x803724
  800f6f:	68 f1 00 00 00       	push   $0xf1
  800f74:	68 61 36 80 00       	push   $0x803661
  800f79:	e8 7b 05 00 00       	call   8014f9 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f7e:	e8 77 20 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  800f83:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800f86:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800f89:	89 d0                	mov    %edx,%eax
  800f8b:	01 c0                	add    %eax,%eax
  800f8d:	01 d0                	add    %edx,%eax
  800f8f:	01 c0                	add    %eax,%eax
  800f91:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	50                   	push   %eax
  800f98:	e8 0a 14 00 00       	call   8023a7 <malloc>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800fa6:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800fac:	89 c1                	mov    %eax,%ecx
  800fae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800fb1:	89 d0                	mov    %edx,%eax
  800fb3:	01 c0                	add    %eax,%eax
  800fb5:	01 d0                	add    %edx,%eax
  800fb7:	01 c0                	add    %eax,%eax
  800fb9:	01 d0                	add    %edx,%eax
  800fbb:	89 c2                	mov    %eax,%edx
  800fbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800fc0:	c1 e0 04             	shl    $0x4,%eax
  800fc3:	01 d0                	add    %edx,%eax
  800fc5:	05 00 00 00 80       	add    $0x80000000,%eax
  800fca:	39 c1                	cmp    %eax,%ecx
  800fcc:	72 28                	jb     800ff6 <_main+0xfbe>
  800fce:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800fd4:	89 c1                	mov    %eax,%ecx
  800fd6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800fd9:	89 d0                	mov    %edx,%eax
  800fdb:	01 c0                	add    %eax,%eax
  800fdd:	01 d0                	add    %edx,%eax
  800fdf:	01 c0                	add    %eax,%eax
  800fe1:	01 d0                	add    %edx,%eax
  800fe3:	89 c2                	mov    %eax,%edx
  800fe5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800fe8:	c1 e0 04             	shl    $0x4,%eax
  800feb:	01 d0                	add    %edx,%eax
  800fed:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800ff2:	39 c1                	cmp    %eax,%ecx
  800ff4:	76 17                	jbe    80100d <_main+0xfd5>
  800ff6:	83 ec 04             	sub    $0x4,%esp
  800ff9:	68 bc 36 80 00       	push   $0x8036bc
  800ffe:	68 f7 00 00 00       	push   $0xf7
  801003:	68 61 36 80 00       	push   $0x803661
  801008:	e8 ec 04 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80100d:	e8 e8 1f 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  801012:	2b 45 88             	sub    -0x78(%ebp),%eax
  801015:	89 c1                	mov    %eax,%ecx
  801017:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80101a:	89 d0                	mov    %edx,%eax
  80101c:	01 c0                	add    %eax,%eax
  80101e:	01 d0                	add    %edx,%eax
  801020:	01 c0                	add    %eax,%eax
  801022:	85 c0                	test   %eax,%eax
  801024:	79 05                	jns    80102b <_main+0xff3>
  801026:	05 ff 0f 00 00       	add    $0xfff,%eax
  80102b:	c1 f8 0c             	sar    $0xc,%eax
  80102e:	39 c1                	cmp    %eax,%ecx
  801030:	74 17                	je     801049 <_main+0x1011>
  801032:	83 ec 04             	sub    $0x4,%esp
  801035:	68 24 37 80 00       	push   $0x803724
  80103a:	68 f8 00 00 00       	push   $0xf8
  80103f:	68 61 36 80 00       	push   $0x803661
  801044:	e8 b0 04 00 00       	call   8014f9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801049:	e8 29 1f 00 00       	call   802f77 <sys_calculate_free_frames>
  80104e:	89 45 84             	mov    %eax,-0x7c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  801051:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801054:	89 d0                	mov    %edx,%eax
  801056:	01 c0                	add    %eax,%eax
  801058:	01 d0                	add    %edx,%eax
  80105a:	01 c0                	add    %eax,%eax
  80105c:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80105f:	48                   	dec    %eax
  801060:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  801066:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  80106c:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		byteArr2[0] = minByte ;
  801072:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801078:	8a 55 c7             	mov    -0x39(%ebp),%dl
  80107b:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  80107d:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801083:	89 c2                	mov    %eax,%edx
  801085:	c1 ea 1f             	shr    $0x1f,%edx
  801088:	01 d0                	add    %edx,%eax
  80108a:	d1 f8                	sar    %eax
  80108c:	89 c2                	mov    %eax,%edx
  80108e:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801094:	01 c2                	add    %eax,%edx
  801096:	8a 45 c6             	mov    -0x3a(%ebp),%al
  801099:	88 c1                	mov    %al,%cl
  80109b:	c0 e9 07             	shr    $0x7,%cl
  80109e:	01 c8                	add    %ecx,%eax
  8010a0:	d0 f8                	sar    %al
  8010a2:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  8010a4:	8b 95 28 ff ff ff    	mov    -0xd8(%ebp),%edx
  8010aa:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8010b0:	01 c2                	add    %eax,%edx
  8010b2:	8a 45 c6             	mov    -0x3a(%ebp),%al
  8010b5:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8010b7:	8b 5d 84             	mov    -0x7c(%ebp),%ebx
  8010ba:	e8 b8 1e 00 00       	call   802f77 <sys_calculate_free_frames>
  8010bf:	29 c3                	sub    %eax,%ebx
  8010c1:	89 d8                	mov    %ebx,%eax
  8010c3:	83 f8 05             	cmp    $0x5,%eax
  8010c6:	74 17                	je     8010df <_main+0x10a7>
  8010c8:	83 ec 04             	sub    $0x4,%esp
  8010cb:	68 54 37 80 00       	push   $0x803754
  8010d0:	68 00 01 00 00       	push   $0x100
  8010d5:	68 61 36 80 00       	push   $0x803661
  8010da:	e8 1a 04 00 00       	call   8014f9 <_panic>
		found = 0;
  8010df:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8010ed:	e9 fc 00 00 00       	jmp    8011ee <_main+0x11b6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  8010f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010f5:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8010fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010fe:	89 d0                	mov    %edx,%eax
  801100:	01 c0                	add    %eax,%eax
  801102:	01 d0                	add    %edx,%eax
  801104:	c1 e0 02             	shl    $0x2,%eax
  801107:	01 c8                	add    %ecx,%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  801111:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801117:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80111c:	89 c2                	mov    %eax,%edx
  80111e:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801124:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  80112a:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  801130:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801135:	39 c2                	cmp    %eax,%edx
  801137:	75 03                	jne    80113c <_main+0x1104>
				found++;
  801139:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  80113c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80113f:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  801145:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801148:	89 d0                	mov    %edx,%eax
  80114a:	01 c0                	add    %eax,%eax
  80114c:	01 d0                	add    %edx,%eax
  80114e:	c1 e0 02             	shl    $0x2,%eax
  801151:	01 c8                	add    %ecx,%eax
  801153:	8b 00                	mov    (%eax),%eax
  801155:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  80115b:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  801161:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801166:	89 c2                	mov    %eax,%edx
  801168:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  80116e:	89 c1                	mov    %eax,%ecx
  801170:	c1 e9 1f             	shr    $0x1f,%ecx
  801173:	01 c8                	add    %ecx,%eax
  801175:	d1 f8                	sar    %eax
  801177:	89 c1                	mov    %eax,%ecx
  801179:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80117f:	01 c8                	add    %ecx,%eax
  801181:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  801187:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80118d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801192:	39 c2                	cmp    %eax,%edx
  801194:	75 03                	jne    801199 <_main+0x1161>
				found++;
  801196:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  801199:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80119c:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8011a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011a5:	89 d0                	mov    %edx,%eax
  8011a7:	01 c0                	add    %eax,%eax
  8011a9:	01 d0                	add    %edx,%eax
  8011ab:	c1 e0 02             	shl    $0x2,%eax
  8011ae:	01 c8                	add    %ecx,%eax
  8011b0:	8b 00                	mov    (%eax),%eax
  8011b2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  8011b8:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8011be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011c3:	89 c1                	mov    %eax,%ecx
  8011c5:	8b 95 28 ff ff ff    	mov    -0xd8(%ebp),%edx
  8011cb:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  8011d9:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8011df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011e4:	39 c1                	cmp    %eax,%ecx
  8011e6:	75 03                	jne    8011eb <_main+0x11b3>
				found++;
  8011e8:	ff 45 d8             	incl   -0x28(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8011eb:	ff 45 e4             	incl   -0x1c(%ebp)
  8011ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f1:	8b 50 74             	mov    0x74(%eax),%edx
  8011f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f7:	39 c2                	cmp    %eax,%edx
  8011f9:	0f 87 f3 fe ff ff    	ja     8010f2 <_main+0x10ba>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  8011ff:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
  801203:	74 17                	je     80121c <_main+0x11e4>
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	68 98 37 80 00       	push   $0x803798
  80120d:	68 0b 01 00 00       	push   $0x10b
  801212:	68 61 36 80 00       	push   $0x803661
  801217:	e8 dd 02 00 00       	call   8014f9 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80121c:	e8 d9 1d 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  801221:	89 45 88             	mov    %eax,-0x78(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  801224:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801227:	89 d0                	mov    %edx,%eax
  801229:	01 c0                	add    %eax,%eax
  80122b:	01 d0                	add    %edx,%eax
  80122d:	01 c0                	add    %eax,%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	01 c0                	add    %eax,%eax
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	50                   	push   %eax
  801237:	e8 6b 11 00 00       	call   8023a7 <malloc>
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  801245:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  80124b:	89 c1                	mov    %eax,%ecx
  80124d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801250:	89 d0                	mov    %edx,%eax
  801252:	01 c0                	add    %eax,%eax
  801254:	01 d0                	add    %edx,%eax
  801256:	c1 e0 02             	shl    $0x2,%eax
  801259:	01 d0                	add    %edx,%eax
  80125b:	89 c2                	mov    %eax,%edx
  80125d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801260:	c1 e0 04             	shl    $0x4,%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	05 00 00 00 80       	add    $0x80000000,%eax
  80126a:	39 c1                	cmp    %eax,%ecx
  80126c:	72 29                	jb     801297 <_main+0x125f>
  80126e:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  801274:	89 c1                	mov    %eax,%ecx
  801276:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801279:	89 d0                	mov    %edx,%eax
  80127b:	01 c0                	add    %eax,%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	c1 e0 02             	shl    $0x2,%eax
  801282:	01 d0                	add    %edx,%eax
  801284:	89 c2                	mov    %eax,%edx
  801286:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801289:	c1 e0 04             	shl    $0x4,%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  801293:	39 c1                	cmp    %eax,%ecx
  801295:	76 17                	jbe    8012ae <_main+0x1276>
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	68 bc 36 80 00       	push   $0x8036bc
  80129f:	68 10 01 00 00       	push   $0x110
  8012a4:	68 61 36 80 00       	push   $0x803661
  8012a9:	e8 4b 02 00 00       	call   8014f9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012ae:	e8 47 1d 00 00       	call   802ffa <sys_pf_calculate_allocated_pages>
  8012b3:	2b 45 88             	sub    -0x78(%ebp),%eax
  8012b6:	83 f8 04             	cmp    $0x4,%eax
  8012b9:	74 17                	je     8012d2 <_main+0x129a>
  8012bb:	83 ec 04             	sub    $0x4,%esp
  8012be:	68 24 37 80 00       	push   $0x803724
  8012c3:	68 11 01 00 00       	push   $0x111
  8012c8:	68 61 36 80 00       	push   $0x803661
  8012cd:	e8 27 02 00 00       	call   8014f9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8012d2:	e8 a0 1c 00 00       	call   802f77 <sys_calculate_free_frames>
  8012d7:	89 45 84             	mov    %eax,-0x7c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  8012da:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  8012e0:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  8012e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8012e9:	89 d0                	mov    %edx,%eax
  8012eb:	01 c0                	add    %eax,%eax
  8012ed:	01 d0                	add    %edx,%eax
  8012ef:	01 c0                	add    %eax,%eax
  8012f1:	01 d0                	add    %edx,%eax
  8012f3:	01 c0                	add    %eax,%eax
  8012f5:	d1 e8                	shr    %eax
  8012f7:	48                   	dec    %eax
  8012f8:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
		shortArr2[0] = minShort;
  8012fe:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
  801304:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801307:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  80130a:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  801310:	01 c0                	add    %eax,%eax
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80131a:	01 c2                	add    %eax,%edx
  80131c:	66 8b 45 c2          	mov    -0x3e(%ebp),%ax
  801320:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  801323:	8b 5d 84             	mov    -0x7c(%ebp),%ebx
  801326:	e8 4c 1c 00 00       	call   802f77 <sys_calculate_free_frames>
  80132b:	29 c3                	sub    %eax,%ebx
  80132d:	89 d8                	mov    %ebx,%eax
  80132f:	83 f8 02             	cmp    $0x2,%eax
  801332:	74 17                	je     80134b <_main+0x1313>
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	68 54 37 80 00       	push   $0x803754
  80133c:	68 18 01 00 00       	push   $0x118
  801341:	68 61 36 80 00       	push   $0x803661
  801346:	e8 ae 01 00 00       	call   8014f9 <_panic>
		found = 0;
  80134b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801352:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801359:	e9 a3 00 00 00       	jmp    801401 <_main+0x13c9>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  80135e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801361:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  801367:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80136a:	89 d0                	mov    %edx,%eax
  80136c:	01 c0                	add    %eax,%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	c1 e0 02             	shl    $0x2,%eax
  801373:	01 c8                	add    %ecx,%eax
  801375:	8b 00                	mov    (%eax),%eax
  801377:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  80137d:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  801383:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801388:	89 c2                	mov    %eax,%edx
  80138a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  801390:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801396:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  80139c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a1:	39 c2                	cmp    %eax,%edx
  8013a3:	75 03                	jne    8013a8 <_main+0x1370>
				found++;
  8013a5:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  8013a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013ab:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8013b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013b4:	89 d0                	mov    %edx,%eax
  8013b6:	01 c0                	add    %eax,%eax
  8013b8:	01 d0                	add    %edx,%eax
  8013ba:	c1 e0 02             	shl    $0x2,%eax
  8013bd:	01 c8                	add    %ecx,%eax
  8013bf:	8b 00                	mov    (%eax),%eax
  8013c1:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  8013c7:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  8013cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d2:	89 c2                	mov    %eax,%edx
  8013d4:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8013da:	01 c0                	add    %eax,%eax
  8013dc:	89 c1                	mov    %eax,%ecx
  8013de:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  8013ec:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8013f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f7:	39 c2                	cmp    %eax,%edx
  8013f9:	75 03                	jne    8013fe <_main+0x13c6>
				found++;
  8013fb:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8013fe:	ff 45 e4             	incl   -0x1c(%ebp)
  801401:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801404:	8b 50 74             	mov    0x74(%eax),%edx
  801407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80140a:	39 c2                	cmp    %eax,%edx
  80140c:	0f 87 4c ff ff ff    	ja     80135e <_main+0x1326>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  801412:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  801416:	74 17                	je     80142f <_main+0x13f7>
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	68 98 37 80 00       	push   $0x803798
  801420:	68 21 01 00 00       	push   $0x121
  801425:	68 61 36 80 00       	push   $0x803661
  80142a:	e8 ca 00 00 00       	call   8014f9 <_panic>
		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
*/
	return;
  80142f:	90                   	nop
}
  801430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801433:	5b                   	pop    %ebx
  801434:	5e                   	pop    %esi
  801435:	5f                   	pop    %edi
  801436:	5d                   	pop    %ebp
  801437:	c3                   	ret    

00801438 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80143e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801442:	7e 0a                	jle    80144e <libmain+0x16>
		binaryname = argv[0];
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80144e:	83 ec 08             	sub    $0x8,%esp
  801451:	ff 75 0c             	pushl  0xc(%ebp)
  801454:	ff 75 08             	pushl  0x8(%ebp)
  801457:	e8 dc eb ff ff       	call   800038 <_main>
  80145c:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80145f:	e8 61 1a 00 00       	call   802ec5 <sys_getenvid>
  801464:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  801467:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80146a:	89 d0                	mov    %edx,%eax
  80146c:	c1 e0 03             	shl    $0x3,%eax
  80146f:	01 d0                	add    %edx,%eax
  801471:	01 c0                	add    %eax,%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147c:	01 d0                	add    %edx,%eax
  80147e:	c1 e0 03             	shl    $0x3,%eax
  801481:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801486:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  801489:	e8 85 1b 00 00       	call   803013 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	68 bc 38 80 00       	push   $0x8038bc
  801496:	e8 89 01 00 00       	call   801624 <cprintf>
  80149b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80149e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a1:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	50                   	push   %eax
  8014ab:	68 e4 38 80 00       	push   $0x8038e4
  8014b0:	e8 6f 01 00 00       	call   801624 <cprintf>
  8014b5:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8014b8:	83 ec 0c             	sub    $0xc,%esp
  8014bb:	68 bc 38 80 00       	push   $0x8038bc
  8014c0:	e8 5f 01 00 00       	call   801624 <cprintf>
  8014c5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8014c8:	e8 60 1b 00 00       	call   80302d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8014cd:	e8 19 00 00 00       	call   8014eb <exit>
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	6a 00                	push   $0x0
  8014e0:	e8 c5 19 00 00       	call   802eaa <sys_env_destroy>
  8014e5:	83 c4 10             	add    $0x10,%esp
}
  8014e8:	90                   	nop
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <exit>:

void
exit(void)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8014f1:	e8 e8 19 00 00       	call   802ede <sys_env_exit>
}
  8014f6:	90                   	nop
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014ff:	8d 45 10             	lea    0x10(%ebp),%eax
  801502:	83 c0 04             	add    $0x4,%eax
  801505:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  801508:	a1 50 40 98 00       	mov    0x984050,%eax
  80150d:	85 c0                	test   %eax,%eax
  80150f:	74 16                	je     801527 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801511:	a1 50 40 98 00       	mov    0x984050,%eax
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	50                   	push   %eax
  80151a:	68 fd 38 80 00       	push   $0x8038fd
  80151f:	e8 00 01 00 00       	call   801624 <cprintf>
  801524:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801527:	a1 00 40 80 00       	mov    0x804000,%eax
  80152c:	ff 75 0c             	pushl  0xc(%ebp)
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	50                   	push   %eax
  801533:	68 02 39 80 00       	push   $0x803902
  801538:	e8 e7 00 00 00       	call   801624 <cprintf>
  80153d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801540:	8b 45 10             	mov    0x10(%ebp),%eax
  801543:	83 ec 08             	sub    $0x8,%esp
  801546:	ff 75 f4             	pushl  -0xc(%ebp)
  801549:	50                   	push   %eax
  80154a:	e8 7a 00 00 00       	call   8015c9 <vcprintf>
  80154f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	68 1e 39 80 00       	push   $0x80391e
  80155a:	e8 c5 00 00 00       	call   801624 <cprintf>
  80155f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801562:	e8 84 ff ff ff       	call   8014eb <exit>

	// should not return here
	while (1) ;
  801567:	eb fe                	jmp    801567 <_panic+0x6e>

00801569 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	8b 00                	mov    (%eax),%eax
  801574:	8d 48 01             	lea    0x1(%eax),%ecx
  801577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157a:	89 0a                	mov    %ecx,(%edx)
  80157c:	8b 55 08             	mov    0x8(%ebp),%edx
  80157f:	88 d1                	mov    %dl,%cl
  801581:	8b 55 0c             	mov    0xc(%ebp),%edx
  801584:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801588:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158b:	8b 00                	mov    (%eax),%eax
  80158d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801592:	75 23                	jne    8015b7 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  801594:	8b 45 0c             	mov    0xc(%ebp),%eax
  801597:	8b 00                	mov    (%eax),%eax
  801599:	89 c2                	mov    %eax,%edx
  80159b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159e:	83 c0 08             	add    $0x8,%eax
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	52                   	push   %edx
  8015a5:	50                   	push   %eax
  8015a6:	e8 c9 18 00 00       	call   802e74 <sys_cputs>
  8015ab:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8015ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	8b 40 04             	mov    0x4(%eax),%eax
  8015bd:	8d 50 01             	lea    0x1(%eax),%edx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8015c6:	90                   	nop
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8015d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8015d9:	00 00 00 
	b.cnt = 0;
  8015dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8015e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8015f2:	50                   	push   %eax
  8015f3:	68 69 15 80 00       	push   $0x801569
  8015f8:	e8 fa 01 00 00       	call   8017f7 <vprintfmt>
  8015fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  801600:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	50                   	push   %eax
  80160a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801610:	83 c0 08             	add    $0x8,%eax
  801613:	50                   	push   %eax
  801614:	e8 5b 18 00 00       	call   802e74 <sys_cputs>
  801619:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80161c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <cprintf>:

int cprintf(const char *fmt, ...) {
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80162a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80162d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	ff 75 f4             	pushl  -0xc(%ebp)
  801639:	50                   	push   %eax
  80163a:	e8 8a ff ff ff       	call   8015c9 <vcprintf>
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801645:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801650:	e8 be 19 00 00       	call   803013 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801655:	8d 45 0c             	lea    0xc(%ebp),%eax
  801658:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	ff 75 f4             	pushl  -0xc(%ebp)
  801664:	50                   	push   %eax
  801665:	e8 5f ff ff ff       	call   8015c9 <vcprintf>
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801670:	e8 b8 19 00 00       	call   80302d <sys_enable_interrupt>
	return cnt;
  801675:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	53                   	push   %ebx
  80167e:	83 ec 14             	sub    $0x14,%esp
  801681:	8b 45 10             	mov    0x10(%ebp),%eax
  801684:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801687:	8b 45 14             	mov    0x14(%ebp),%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80168d:	8b 45 18             	mov    0x18(%ebp),%eax
  801690:	ba 00 00 00 00       	mov    $0x0,%edx
  801695:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801698:	77 55                	ja     8016ef <printnum+0x75>
  80169a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80169d:	72 05                	jb     8016a4 <printnum+0x2a>
  80169f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016a2:	77 4b                	ja     8016ef <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016a4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8016a7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8016aa:	8b 45 18             	mov    0x18(%ebp),%eax
  8016ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b2:	52                   	push   %edx
  8016b3:	50                   	push   %eax
  8016b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8016ba:	e8 f1 1c 00 00       	call   8033b0 <__udivdi3>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	ff 75 20             	pushl  0x20(%ebp)
  8016c8:	53                   	push   %ebx
  8016c9:	ff 75 18             	pushl  0x18(%ebp)
  8016cc:	52                   	push   %edx
  8016cd:	50                   	push   %eax
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	e8 a1 ff ff ff       	call   80167a <printnum>
  8016d9:	83 c4 20             	add    $0x20,%esp
  8016dc:	eb 1a                	jmp    8016f8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	ff 75 20             	pushl  0x20(%ebp)
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	ff d0                	call   *%eax
  8016ec:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8016ef:	ff 4d 1c             	decl   0x1c(%ebp)
  8016f2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8016f6:	7f e6                	jg     8016de <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016f8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8016fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801706:	53                   	push   %ebx
  801707:	51                   	push   %ecx
  801708:	52                   	push   %edx
  801709:	50                   	push   %eax
  80170a:	e8 b1 1d 00 00       	call   8034c0 <__umoddi3>
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	05 34 3b 80 00       	add    $0x803b34,%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	0f be c0             	movsbl %al,%eax
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	ff 75 0c             	pushl  0xc(%ebp)
  801722:	50                   	push   %eax
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	ff d0                	call   *%eax
  801728:	83 c4 10             	add    $0x10,%esp
}
  80172b:	90                   	nop
  80172c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801734:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801738:	7e 1c                	jle    801756 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8b 00                	mov    (%eax),%eax
  80173f:	8d 50 08             	lea    0x8(%eax),%edx
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	89 10                	mov    %edx,(%eax)
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	8b 00                	mov    (%eax),%eax
  80174c:	83 e8 08             	sub    $0x8,%eax
  80174f:	8b 50 04             	mov    0x4(%eax),%edx
  801752:	8b 00                	mov    (%eax),%eax
  801754:	eb 40                	jmp    801796 <getuint+0x65>
	else if (lflag)
  801756:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80175a:	74 1e                	je     80177a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8b 00                	mov    (%eax),%eax
  801761:	8d 50 04             	lea    0x4(%eax),%edx
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	89 10                	mov    %edx,(%eax)
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	8b 00                	mov    (%eax),%eax
  80176e:	83 e8 04             	sub    $0x4,%eax
  801771:	8b 00                	mov    (%eax),%eax
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	eb 1c                	jmp    801796 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	8b 00                	mov    (%eax),%eax
  80177f:	8d 50 04             	lea    0x4(%eax),%edx
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	89 10                	mov    %edx,(%eax)
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	8b 00                	mov    (%eax),%eax
  80178c:	83 e8 04             	sub    $0x4,%eax
  80178f:	8b 00                	mov    (%eax),%eax
  801791:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801796:	5d                   	pop    %ebp
  801797:	c3                   	ret    

00801798 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80179b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80179f:	7e 1c                	jle    8017bd <getint+0x25>
		return va_arg(*ap, long long);
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8b 00                	mov    (%eax),%eax
  8017a6:	8d 50 08             	lea    0x8(%eax),%edx
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	89 10                	mov    %edx,(%eax)
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	8b 00                	mov    (%eax),%eax
  8017b3:	83 e8 08             	sub    $0x8,%eax
  8017b6:	8b 50 04             	mov    0x4(%eax),%edx
  8017b9:	8b 00                	mov    (%eax),%eax
  8017bb:	eb 38                	jmp    8017f5 <getint+0x5d>
	else if (lflag)
  8017bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017c1:	74 1a                	je     8017dd <getint+0x45>
		return va_arg(*ap, long);
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8b 00                	mov    (%eax),%eax
  8017c8:	8d 50 04             	lea    0x4(%eax),%edx
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	89 10                	mov    %edx,(%eax)
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	8b 00                	mov    (%eax),%eax
  8017d5:	83 e8 04             	sub    $0x4,%eax
  8017d8:	8b 00                	mov    (%eax),%eax
  8017da:	99                   	cltd   
  8017db:	eb 18                	jmp    8017f5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8b 00                	mov    (%eax),%eax
  8017e2:	8d 50 04             	lea    0x4(%eax),%edx
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	89 10                	mov    %edx,(%eax)
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8b 00                	mov    (%eax),%eax
  8017ef:	83 e8 04             	sub    $0x4,%eax
  8017f2:	8b 00                	mov    (%eax),%eax
  8017f4:	99                   	cltd   
}
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    

008017f7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	56                   	push   %esi
  8017fb:	53                   	push   %ebx
  8017fc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017ff:	eb 17                	jmp    801818 <vprintfmt+0x21>
			if (ch == '\0')
  801801:	85 db                	test   %ebx,%ebx
  801803:	0f 84 af 03 00 00    	je     801bb8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	53                   	push   %ebx
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	ff d0                	call   *%eax
  801815:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801818:	8b 45 10             	mov    0x10(%ebp),%eax
  80181b:	8d 50 01             	lea    0x1(%eax),%edx
  80181e:	89 55 10             	mov    %edx,0x10(%ebp)
  801821:	8a 00                	mov    (%eax),%al
  801823:	0f b6 d8             	movzbl %al,%ebx
  801826:	83 fb 25             	cmp    $0x25,%ebx
  801829:	75 d6                	jne    801801 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80182b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80182f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801836:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80183d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801844:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80184b:	8b 45 10             	mov    0x10(%ebp),%eax
  80184e:	8d 50 01             	lea    0x1(%eax),%edx
  801851:	89 55 10             	mov    %edx,0x10(%ebp)
  801854:	8a 00                	mov    (%eax),%al
  801856:	0f b6 d8             	movzbl %al,%ebx
  801859:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80185c:	83 f8 55             	cmp    $0x55,%eax
  80185f:	0f 87 2b 03 00 00    	ja     801b90 <vprintfmt+0x399>
  801865:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
  80186c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80186e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801872:	eb d7                	jmp    80184b <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801874:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801878:	eb d1                	jmp    80184b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80187a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801881:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	c1 e0 02             	shl    $0x2,%eax
  801889:	01 d0                	add    %edx,%eax
  80188b:	01 c0                	add    %eax,%eax
  80188d:	01 d8                	add    %ebx,%eax
  80188f:	83 e8 30             	sub    $0x30,%eax
  801892:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801895:	8b 45 10             	mov    0x10(%ebp),%eax
  801898:	8a 00                	mov    (%eax),%al
  80189a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80189d:	83 fb 2f             	cmp    $0x2f,%ebx
  8018a0:	7e 3e                	jle    8018e0 <vprintfmt+0xe9>
  8018a2:	83 fb 39             	cmp    $0x39,%ebx
  8018a5:	7f 39                	jg     8018e0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018a7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8018aa:	eb d5                	jmp    801881 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8018ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8018af:	83 c0 04             	add    $0x4,%eax
  8018b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8018b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b8:	83 e8 04             	sub    $0x4,%eax
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8018c0:	eb 1f                	jmp    8018e1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8018c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018c6:	79 83                	jns    80184b <vprintfmt+0x54>
				width = 0;
  8018c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8018cf:	e9 77 ff ff ff       	jmp    80184b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8018d4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8018db:	e9 6b ff ff ff       	jmp    80184b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8018e0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8018e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e5:	0f 89 60 ff ff ff    	jns    80184b <vprintfmt+0x54>
				width = precision, precision = -1;
  8018eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018f1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8018f8:	e9 4e ff ff ff       	jmp    80184b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8018fd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801900:	e9 46 ff ff ff       	jmp    80184b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801905:	8b 45 14             	mov    0x14(%ebp),%eax
  801908:	83 c0 04             	add    $0x4,%eax
  80190b:	89 45 14             	mov    %eax,0x14(%ebp)
  80190e:	8b 45 14             	mov    0x14(%ebp),%eax
  801911:	83 e8 04             	sub    $0x4,%eax
  801914:	8b 00                	mov    (%eax),%eax
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	50                   	push   %eax
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	ff d0                	call   *%eax
  801922:	83 c4 10             	add    $0x10,%esp
			break;
  801925:	e9 89 02 00 00       	jmp    801bb3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80192a:	8b 45 14             	mov    0x14(%ebp),%eax
  80192d:	83 c0 04             	add    $0x4,%eax
  801930:	89 45 14             	mov    %eax,0x14(%ebp)
  801933:	8b 45 14             	mov    0x14(%ebp),%eax
  801936:	83 e8 04             	sub    $0x4,%eax
  801939:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80193b:	85 db                	test   %ebx,%ebx
  80193d:	79 02                	jns    801941 <vprintfmt+0x14a>
				err = -err;
  80193f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801941:	83 fb 64             	cmp    $0x64,%ebx
  801944:	7f 0b                	jg     801951 <vprintfmt+0x15a>
  801946:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  80194d:	85 f6                	test   %esi,%esi
  80194f:	75 19                	jne    80196a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801951:	53                   	push   %ebx
  801952:	68 45 3b 80 00       	push   $0x803b45
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	e8 5e 02 00 00       	call   801bc0 <printfmt>
  801962:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801965:	e9 49 02 00 00       	jmp    801bb3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80196a:	56                   	push   %esi
  80196b:	68 4e 3b 80 00       	push   $0x803b4e
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	ff 75 08             	pushl  0x8(%ebp)
  801976:	e8 45 02 00 00       	call   801bc0 <printfmt>
  80197b:	83 c4 10             	add    $0x10,%esp
			break;
  80197e:	e9 30 02 00 00       	jmp    801bb3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801983:	8b 45 14             	mov    0x14(%ebp),%eax
  801986:	83 c0 04             	add    $0x4,%eax
  801989:	89 45 14             	mov    %eax,0x14(%ebp)
  80198c:	8b 45 14             	mov    0x14(%ebp),%eax
  80198f:	83 e8 04             	sub    $0x4,%eax
  801992:	8b 30                	mov    (%eax),%esi
  801994:	85 f6                	test   %esi,%esi
  801996:	75 05                	jne    80199d <vprintfmt+0x1a6>
				p = "(null)";
  801998:	be 51 3b 80 00       	mov    $0x803b51,%esi
			if (width > 0 && padc != '-')
  80199d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019a1:	7e 6d                	jle    801a10 <vprintfmt+0x219>
  8019a3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8019a7:	74 67                	je     801a10 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ac:	83 ec 08             	sub    $0x8,%esp
  8019af:	50                   	push   %eax
  8019b0:	56                   	push   %esi
  8019b1:	e8 0c 03 00 00       	call   801cc2 <strnlen>
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8019bc:	eb 16                	jmp    8019d4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8019be:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8019c2:	83 ec 08             	sub    $0x8,%esp
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	50                   	push   %eax
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	ff d0                	call   *%eax
  8019ce:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8019d1:	ff 4d e4             	decl   -0x1c(%ebp)
  8019d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019d8:	7f e4                	jg     8019be <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019da:	eb 34                	jmp    801a10 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8019dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019e0:	74 1c                	je     8019fe <vprintfmt+0x207>
  8019e2:	83 fb 1f             	cmp    $0x1f,%ebx
  8019e5:	7e 05                	jle    8019ec <vprintfmt+0x1f5>
  8019e7:	83 fb 7e             	cmp    $0x7e,%ebx
  8019ea:	7e 12                	jle    8019fe <vprintfmt+0x207>
					putch('?', putdat);
  8019ec:	83 ec 08             	sub    $0x8,%esp
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	6a 3f                	push   $0x3f
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	ff d0                	call   *%eax
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	eb 0f                	jmp    801a0d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8019fe:	83 ec 08             	sub    $0x8,%esp
  801a01:	ff 75 0c             	pushl  0xc(%ebp)
  801a04:	53                   	push   %ebx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	ff d0                	call   *%eax
  801a0a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a0d:	ff 4d e4             	decl   -0x1c(%ebp)
  801a10:	89 f0                	mov    %esi,%eax
  801a12:	8d 70 01             	lea    0x1(%eax),%esi
  801a15:	8a 00                	mov    (%eax),%al
  801a17:	0f be d8             	movsbl %al,%ebx
  801a1a:	85 db                	test   %ebx,%ebx
  801a1c:	74 24                	je     801a42 <vprintfmt+0x24b>
  801a1e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a22:	78 b8                	js     8019dc <vprintfmt+0x1e5>
  801a24:	ff 4d e0             	decl   -0x20(%ebp)
  801a27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a2b:	79 af                	jns    8019dc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a2d:	eb 13                	jmp    801a42 <vprintfmt+0x24b>
				putch(' ', putdat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	6a 20                	push   $0x20
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	ff d0                	call   *%eax
  801a3c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a3f:	ff 4d e4             	decl   -0x1c(%ebp)
  801a42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a46:	7f e7                	jg     801a2f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801a48:	e9 66 01 00 00       	jmp    801bb3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801a4d:	83 ec 08             	sub    $0x8,%esp
  801a50:	ff 75 e8             	pushl  -0x18(%ebp)
  801a53:	8d 45 14             	lea    0x14(%ebp),%eax
  801a56:	50                   	push   %eax
  801a57:	e8 3c fd ff ff       	call   801798 <getint>
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a62:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a6b:	85 d2                	test   %edx,%edx
  801a6d:	79 23                	jns    801a92 <vprintfmt+0x29b>
				putch('-', putdat);
  801a6f:	83 ec 08             	sub    $0x8,%esp
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	6a 2d                	push   $0x2d
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	ff d0                	call   *%eax
  801a7c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a85:	f7 d8                	neg    %eax
  801a87:	83 d2 00             	adc    $0x0,%edx
  801a8a:	f7 da                	neg    %edx
  801a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a8f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801a92:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a99:	e9 bc 00 00 00       	jmp    801b5a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801a9e:	83 ec 08             	sub    $0x8,%esp
  801aa1:	ff 75 e8             	pushl  -0x18(%ebp)
  801aa4:	8d 45 14             	lea    0x14(%ebp),%eax
  801aa7:	50                   	push   %eax
  801aa8:	e8 84 fc ff ff       	call   801731 <getuint>
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ab3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801ab6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801abd:	e9 98 00 00 00       	jmp    801b5a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801ac2:	83 ec 08             	sub    $0x8,%esp
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	6a 58                	push   $0x58
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	ff d0                	call   *%eax
  801acf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	6a 58                	push   $0x58
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	ff d0                	call   *%eax
  801adf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ae2:	83 ec 08             	sub    $0x8,%esp
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	6a 58                	push   $0x58
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	ff d0                	call   *%eax
  801aef:	83 c4 10             	add    $0x10,%esp
			break;
  801af2:	e9 bc 00 00 00       	jmp    801bb3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801af7:	83 ec 08             	sub    $0x8,%esp
  801afa:	ff 75 0c             	pushl  0xc(%ebp)
  801afd:	6a 30                	push   $0x30
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	ff d0                	call   *%eax
  801b04:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801b07:	83 ec 08             	sub    $0x8,%esp
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	6a 78                	push   $0x78
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	ff d0                	call   *%eax
  801b14:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801b17:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1a:	83 c0 04             	add    $0x4,%eax
  801b1d:	89 45 14             	mov    %eax,0x14(%ebp)
  801b20:	8b 45 14             	mov    0x14(%ebp),%eax
  801b23:	83 e8 04             	sub    $0x4,%eax
  801b26:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801b32:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801b39:	eb 1f                	jmp    801b5a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801b3b:	83 ec 08             	sub    $0x8,%esp
  801b3e:	ff 75 e8             	pushl  -0x18(%ebp)
  801b41:	8d 45 14             	lea    0x14(%ebp),%eax
  801b44:	50                   	push   %eax
  801b45:	e8 e7 fb ff ff       	call   801731 <getuint>
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b50:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801b53:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801b5a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b61:	83 ec 04             	sub    $0x4,%esp
  801b64:	52                   	push   %edx
  801b65:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b68:	50                   	push   %eax
  801b69:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	ff 75 08             	pushl  0x8(%ebp)
  801b75:	e8 00 fb ff ff       	call   80167a <printnum>
  801b7a:	83 c4 20             	add    $0x20,%esp
			break;
  801b7d:	eb 34                	jmp    801bb3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801b7f:	83 ec 08             	sub    $0x8,%esp
  801b82:	ff 75 0c             	pushl  0xc(%ebp)
  801b85:	53                   	push   %ebx
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	ff d0                	call   *%eax
  801b8b:	83 c4 10             	add    $0x10,%esp
			break;
  801b8e:	eb 23                	jmp    801bb3 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801b90:	83 ec 08             	sub    $0x8,%esp
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	6a 25                	push   $0x25
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	ff d0                	call   *%eax
  801b9d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ba0:	ff 4d 10             	decl   0x10(%ebp)
  801ba3:	eb 03                	jmp    801ba8 <vprintfmt+0x3b1>
  801ba5:	ff 4d 10             	decl   0x10(%ebp)
  801ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  801bab:	48                   	dec    %eax
  801bac:	8a 00                	mov    (%eax),%al
  801bae:	3c 25                	cmp    $0x25,%al
  801bb0:	75 f3                	jne    801ba5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801bb2:	90                   	nop
		}
	}
  801bb3:	e9 47 fc ff ff       	jmp    8017ff <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801bb8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    

00801bc0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  801bc9:	83 c0 04             	add    $0x4,%eax
  801bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd5:	50                   	push   %eax
  801bd6:	ff 75 0c             	pushl  0xc(%ebp)
  801bd9:	ff 75 08             	pushl  0x8(%ebp)
  801bdc:	e8 16 fc ff ff       	call   8017f7 <vprintfmt>
  801be1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801be4:	90                   	nop
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bed:	8b 40 08             	mov    0x8(%eax),%eax
  801bf0:	8d 50 01             	lea    0x1(%eax),%edx
  801bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfc:	8b 10                	mov    (%eax),%edx
  801bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c01:	8b 40 04             	mov    0x4(%eax),%eax
  801c04:	39 c2                	cmp    %eax,%edx
  801c06:	73 12                	jae    801c1a <sprintputch+0x33>
		*b->buf++ = ch;
  801c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0b:	8b 00                	mov    (%eax),%eax
  801c0d:	8d 48 01             	lea    0x1(%eax),%ecx
  801c10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c13:	89 0a                	mov    %ecx,(%edx)
  801c15:	8b 55 08             	mov    0x8(%ebp),%edx
  801c18:	88 10                	mov    %dl,(%eax)
}
  801c1a:	90                   	nop
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    

00801c1d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	01 d0                	add    %edx,%eax
  801c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c42:	74 06                	je     801c4a <vsnprintf+0x2d>
  801c44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c48:	7f 07                	jg     801c51 <vsnprintf+0x34>
		return -E_INVAL;
  801c4a:	b8 03 00 00 00       	mov    $0x3,%eax
  801c4f:	eb 20                	jmp    801c71 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c51:	ff 75 14             	pushl  0x14(%ebp)
  801c54:	ff 75 10             	pushl  0x10(%ebp)
  801c57:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c5a:	50                   	push   %eax
  801c5b:	68 e7 1b 80 00       	push   $0x801be7
  801c60:	e8 92 fb ff ff       	call   8017f7 <vprintfmt>
  801c65:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c79:	8d 45 10             	lea    0x10(%ebp),%eax
  801c7c:	83 c0 04             	add    $0x4,%eax
  801c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801c82:	8b 45 10             	mov    0x10(%ebp),%eax
  801c85:	ff 75 f4             	pushl  -0xc(%ebp)
  801c88:	50                   	push   %eax
  801c89:	ff 75 0c             	pushl  0xc(%ebp)
  801c8c:	ff 75 08             	pushl  0x8(%ebp)
  801c8f:	e8 89 ff ff ff       	call   801c1d <vsnprintf>
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ca5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cac:	eb 06                	jmp    801cb4 <strlen+0x15>
		n++;
  801cae:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801cb1:	ff 45 08             	incl   0x8(%ebp)
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	8a 00                	mov    (%eax),%al
  801cb9:	84 c0                	test   %al,%al
  801cbb:	75 f1                	jne    801cae <strlen+0xf>
		n++;
	return n;
  801cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ccf:	eb 09                	jmp    801cda <strnlen+0x18>
		n++;
  801cd1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cd4:	ff 45 08             	incl   0x8(%ebp)
  801cd7:	ff 4d 0c             	decl   0xc(%ebp)
  801cda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cde:	74 09                	je     801ce9 <strnlen+0x27>
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	8a 00                	mov    (%eax),%al
  801ce5:	84 c0                	test   %al,%al
  801ce7:	75 e8                	jne    801cd1 <strnlen+0xf>
		n++;
	return n;
  801ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801cfa:	90                   	nop
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	8d 50 01             	lea    0x1(%eax),%edx
  801d01:	89 55 08             	mov    %edx,0x8(%ebp)
  801d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d07:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d0a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d0d:	8a 12                	mov    (%edx),%dl
  801d0f:	88 10                	mov    %dl,(%eax)
  801d11:	8a 00                	mov    (%eax),%al
  801d13:	84 c0                	test   %al,%al
  801d15:	75 e4                	jne    801cfb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801d17:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801d28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d2f:	eb 1f                	jmp    801d50 <strncpy+0x34>
		*dst++ = *src;
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	8d 50 01             	lea    0x1(%eax),%edx
  801d37:	89 55 08             	mov    %edx,0x8(%ebp)
  801d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3d:	8a 12                	mov    (%edx),%dl
  801d3f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d44:	8a 00                	mov    (%eax),%al
  801d46:	84 c0                	test   %al,%al
  801d48:	74 03                	je     801d4d <strncpy+0x31>
			src++;
  801d4a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d4d:	ff 45 fc             	incl   -0x4(%ebp)
  801d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d53:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d56:	72 d9                	jb     801d31 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801d58:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801d69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d6d:	74 30                	je     801d9f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801d6f:	eb 16                	jmp    801d87 <strlcpy+0x2a>
			*dst++ = *src++;
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	8d 50 01             	lea    0x1(%eax),%edx
  801d77:	89 55 08             	mov    %edx,0x8(%ebp)
  801d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d83:	8a 12                	mov    (%edx),%dl
  801d85:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801d87:	ff 4d 10             	decl   0x10(%ebp)
  801d8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d8e:	74 09                	je     801d99 <strlcpy+0x3c>
  801d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d93:	8a 00                	mov    (%eax),%al
  801d95:	84 c0                	test   %al,%al
  801d97:	75 d8                	jne    801d71 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  801da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801da5:	29 c2                	sub    %eax,%edx
  801da7:	89 d0                	mov    %edx,%eax
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801dae:	eb 06                	jmp    801db6 <strcmp+0xb>
		p++, q++;
  801db0:	ff 45 08             	incl   0x8(%ebp)
  801db3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	8a 00                	mov    (%eax),%al
  801dbb:	84 c0                	test   %al,%al
  801dbd:	74 0e                	je     801dcd <strcmp+0x22>
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	8a 10                	mov    (%eax),%dl
  801dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc7:	8a 00                	mov    (%eax),%al
  801dc9:	38 c2                	cmp    %al,%dl
  801dcb:	74 e3                	je     801db0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	8a 00                	mov    (%eax),%al
  801dd2:	0f b6 d0             	movzbl %al,%edx
  801dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd8:	8a 00                	mov    (%eax),%al
  801dda:	0f b6 c0             	movzbl %al,%eax
  801ddd:	29 c2                	sub    %eax,%edx
  801ddf:	89 d0                	mov    %edx,%eax
}
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801de6:	eb 09                	jmp    801df1 <strncmp+0xe>
		n--, p++, q++;
  801de8:	ff 4d 10             	decl   0x10(%ebp)
  801deb:	ff 45 08             	incl   0x8(%ebp)
  801dee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801df5:	74 17                	je     801e0e <strncmp+0x2b>
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	8a 00                	mov    (%eax),%al
  801dfc:	84 c0                	test   %al,%al
  801dfe:	74 0e                	je     801e0e <strncmp+0x2b>
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	8a 10                	mov    (%eax),%dl
  801e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e08:	8a 00                	mov    (%eax),%al
  801e0a:	38 c2                	cmp    %al,%dl
  801e0c:	74 da                	je     801de8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801e0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e12:	75 07                	jne    801e1b <strncmp+0x38>
		return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
  801e19:	eb 14                	jmp    801e2f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	8a 00                	mov    (%eax),%al
  801e20:	0f b6 d0             	movzbl %al,%edx
  801e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e26:	8a 00                	mov    (%eax),%al
  801e28:	0f b6 c0             	movzbl %al,%eax
  801e2b:	29 c2                	sub    %eax,%edx
  801e2d:	89 d0                	mov    %edx,%eax
}
  801e2f:	5d                   	pop    %ebp
  801e30:	c3                   	ret    

00801e31 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 04             	sub    $0x4,%esp
  801e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e3d:	eb 12                	jmp    801e51 <strchr+0x20>
		if (*s == c)
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	8a 00                	mov    (%eax),%al
  801e44:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e47:	75 05                	jne    801e4e <strchr+0x1d>
			return (char *) s;
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	eb 11                	jmp    801e5f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801e4e:	ff 45 08             	incl   0x8(%ebp)
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	8a 00                	mov    (%eax),%al
  801e56:	84 c0                	test   %al,%al
  801e58:	75 e5                	jne    801e3f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e6d:	eb 0d                	jmp    801e7c <strfind+0x1b>
		if (*s == c)
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	8a 00                	mov    (%eax),%al
  801e74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e77:	74 0e                	je     801e87 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801e79:	ff 45 08             	incl   0x8(%ebp)
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	8a 00                	mov    (%eax),%al
  801e81:	84 c0                	test   %al,%al
  801e83:	75 ea                	jne    801e6f <strfind+0xe>
  801e85:	eb 01                	jmp    801e88 <strfind+0x27>
		if (*s == c)
			break;
  801e87:	90                   	nop
	return (char *) s;
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801e99:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801e9f:	eb 0e                	jmp    801eaf <memset+0x22>
		*p++ = c;
  801ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea4:	8d 50 01             	lea    0x1(%eax),%edx
  801ea7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ead:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801eaf:	ff 4d f8             	decl   -0x8(%ebp)
  801eb2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801eb6:	79 e9                	jns    801ea1 <memset+0x14>
		*p++ = c;

	return v;
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801ecf:	eb 16                	jmp    801ee7 <memcpy+0x2a>
		*d++ = *s++;
  801ed1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed4:	8d 50 01             	lea    0x1(%eax),%edx
  801ed7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801eda:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801edd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ee0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ee3:	8a 12                	mov    (%edx),%dl
  801ee5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eea:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eed:	89 55 10             	mov    %edx,0x10(%ebp)
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	75 dd                	jne    801ed1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f11:	73 50                	jae    801f63 <memmove+0x6a>
  801f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f16:	8b 45 10             	mov    0x10(%ebp),%eax
  801f19:	01 d0                	add    %edx,%eax
  801f1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f1e:	76 43                	jbe    801f63 <memmove+0x6a>
		s += n;
  801f20:	8b 45 10             	mov    0x10(%ebp),%eax
  801f23:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801f26:	8b 45 10             	mov    0x10(%ebp),%eax
  801f29:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f2c:	eb 10                	jmp    801f3e <memmove+0x45>
			*--d = *--s;
  801f2e:	ff 4d f8             	decl   -0x8(%ebp)
  801f31:	ff 4d fc             	decl   -0x4(%ebp)
  801f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f37:	8a 10                	mov    (%eax),%dl
  801f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f3c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801f3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f41:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f44:	89 55 10             	mov    %edx,0x10(%ebp)
  801f47:	85 c0                	test   %eax,%eax
  801f49:	75 e3                	jne    801f2e <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801f4b:	eb 23                	jmp    801f70 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f50:	8d 50 01             	lea    0x1(%eax),%edx
  801f53:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f59:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f5c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801f5f:	8a 12                	mov    (%edx),%dl
  801f61:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801f63:	8b 45 10             	mov    0x10(%ebp),%eax
  801f66:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f69:	89 55 10             	mov    %edx,0x10(%ebp)
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	75 dd                	jne    801f4d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f84:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801f87:	eb 2a                	jmp    801fb3 <memcmp+0x3e>
		if (*s1 != *s2)
  801f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8c:	8a 10                	mov    (%eax),%dl
  801f8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f91:	8a 00                	mov    (%eax),%al
  801f93:	38 c2                	cmp    %al,%dl
  801f95:	74 16                	je     801fad <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9a:	8a 00                	mov    (%eax),%al
  801f9c:	0f b6 d0             	movzbl %al,%edx
  801f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fa2:	8a 00                	mov    (%eax),%al
  801fa4:	0f b6 c0             	movzbl %al,%eax
  801fa7:	29 c2                	sub    %eax,%edx
  801fa9:	89 d0                	mov    %edx,%eax
  801fab:	eb 18                	jmp    801fc5 <memcmp+0x50>
		s1++, s2++;
  801fad:	ff 45 fc             	incl   -0x4(%ebp)
  801fb0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fb9:	89 55 10             	mov    %edx,0x10(%ebp)
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	75 c9                	jne    801f89 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd3:	01 d0                	add    %edx,%eax
  801fd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801fd8:	eb 15                	jmp    801fef <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	8a 00                	mov    (%eax),%al
  801fdf:	0f b6 d0             	movzbl %al,%edx
  801fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe5:	0f b6 c0             	movzbl %al,%eax
  801fe8:	39 c2                	cmp    %eax,%edx
  801fea:	74 0d                	je     801ff9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801fec:	ff 45 08             	incl   0x8(%ebp)
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ff5:	72 e3                	jb     801fda <memfind+0x13>
  801ff7:	eb 01                	jmp    801ffa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801ff9:	90                   	nop
	return (void *) s;
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802005:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80200c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802013:	eb 03                	jmp    802018 <strtol+0x19>
		s++;
  802015:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	8a 00                	mov    (%eax),%al
  80201d:	3c 20                	cmp    $0x20,%al
  80201f:	74 f4                	je     802015 <strtol+0x16>
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	8a 00                	mov    (%eax),%al
  802026:	3c 09                	cmp    $0x9,%al
  802028:	74 eb                	je     802015 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	8a 00                	mov    (%eax),%al
  80202f:	3c 2b                	cmp    $0x2b,%al
  802031:	75 05                	jne    802038 <strtol+0x39>
		s++;
  802033:	ff 45 08             	incl   0x8(%ebp)
  802036:	eb 13                	jmp    80204b <strtol+0x4c>
	else if (*s == '-')
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	8a 00                	mov    (%eax),%al
  80203d:	3c 2d                	cmp    $0x2d,%al
  80203f:	75 0a                	jne    80204b <strtol+0x4c>
		s++, neg = 1;
  802041:	ff 45 08             	incl   0x8(%ebp)
  802044:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80204b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80204f:	74 06                	je     802057 <strtol+0x58>
  802051:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802055:	75 20                	jne    802077 <strtol+0x78>
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	8a 00                	mov    (%eax),%al
  80205c:	3c 30                	cmp    $0x30,%al
  80205e:	75 17                	jne    802077 <strtol+0x78>
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	40                   	inc    %eax
  802064:	8a 00                	mov    (%eax),%al
  802066:	3c 78                	cmp    $0x78,%al
  802068:	75 0d                	jne    802077 <strtol+0x78>
		s += 2, base = 16;
  80206a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80206e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802075:	eb 28                	jmp    80209f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802077:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80207b:	75 15                	jne    802092 <strtol+0x93>
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8a 00                	mov    (%eax),%al
  802082:	3c 30                	cmp    $0x30,%al
  802084:	75 0c                	jne    802092 <strtol+0x93>
		s++, base = 8;
  802086:	ff 45 08             	incl   0x8(%ebp)
  802089:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802090:	eb 0d                	jmp    80209f <strtol+0xa0>
	else if (base == 0)
  802092:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802096:	75 07                	jne    80209f <strtol+0xa0>
		base = 10;
  802098:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	8a 00                	mov    (%eax),%al
  8020a4:	3c 2f                	cmp    $0x2f,%al
  8020a6:	7e 19                	jle    8020c1 <strtol+0xc2>
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	8a 00                	mov    (%eax),%al
  8020ad:	3c 39                	cmp    $0x39,%al
  8020af:	7f 10                	jg     8020c1 <strtol+0xc2>
			dig = *s - '0';
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	8a 00                	mov    (%eax),%al
  8020b6:	0f be c0             	movsbl %al,%eax
  8020b9:	83 e8 30             	sub    $0x30,%eax
  8020bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bf:	eb 42                	jmp    802103 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	8a 00                	mov    (%eax),%al
  8020c6:	3c 60                	cmp    $0x60,%al
  8020c8:	7e 19                	jle    8020e3 <strtol+0xe4>
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	8a 00                	mov    (%eax),%al
  8020cf:	3c 7a                	cmp    $0x7a,%al
  8020d1:	7f 10                	jg     8020e3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	8a 00                	mov    (%eax),%al
  8020d8:	0f be c0             	movsbl %al,%eax
  8020db:	83 e8 57             	sub    $0x57,%eax
  8020de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e1:	eb 20                	jmp    802103 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	8a 00                	mov    (%eax),%al
  8020e8:	3c 40                	cmp    $0x40,%al
  8020ea:	7e 39                	jle    802125 <strtol+0x126>
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	8a 00                	mov    (%eax),%al
  8020f1:	3c 5a                	cmp    $0x5a,%al
  8020f3:	7f 30                	jg     802125 <strtol+0x126>
			dig = *s - 'A' + 10;
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	8a 00                	mov    (%eax),%al
  8020fa:	0f be c0             	movsbl %al,%eax
  8020fd:	83 e8 37             	sub    $0x37,%eax
  802100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	3b 45 10             	cmp    0x10(%ebp),%eax
  802109:	7d 19                	jge    802124 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80210b:	ff 45 08             	incl   0x8(%ebp)
  80210e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802111:	0f af 45 10          	imul   0x10(%ebp),%eax
  802115:	89 c2                	mov    %eax,%edx
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	01 d0                	add    %edx,%eax
  80211c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80211f:	e9 7b ff ff ff       	jmp    80209f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802124:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802125:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802129:	74 08                	je     802133 <strtol+0x134>
		*endptr = (char *) s;
  80212b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212e:	8b 55 08             	mov    0x8(%ebp),%edx
  802131:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802133:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802137:	74 07                	je     802140 <strtol+0x141>
  802139:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80213c:	f7 d8                	neg    %eax
  80213e:	eb 03                	jmp    802143 <strtol+0x144>
  802140:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <ltostr>:

void
ltostr(long value, char *str)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80214b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802152:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802159:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215d:	79 13                	jns    802172 <ltostr+0x2d>
	{
		neg = 1;
  80215f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802166:	8b 45 0c             	mov    0xc(%ebp),%eax
  802169:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80216c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80216f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80217a:	99                   	cltd   
  80217b:	f7 f9                	idiv   %ecx
  80217d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802183:	8d 50 01             	lea    0x1(%eax),%edx
  802186:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802189:	89 c2                	mov    %eax,%edx
  80218b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218e:	01 d0                	add    %edx,%eax
  802190:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802193:	83 c2 30             	add    $0x30,%edx
  802196:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802198:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80219b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8021a0:	f7 e9                	imul   %ecx
  8021a2:	c1 fa 02             	sar    $0x2,%edx
  8021a5:	89 c8                	mov    %ecx,%eax
  8021a7:	c1 f8 1f             	sar    $0x1f,%eax
  8021aa:	29 c2                	sub    %eax,%edx
  8021ac:	89 d0                	mov    %edx,%eax
  8021ae:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8021b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8021b9:	f7 e9                	imul   %ecx
  8021bb:	c1 fa 02             	sar    $0x2,%edx
  8021be:	89 c8                	mov    %ecx,%eax
  8021c0:	c1 f8 1f             	sar    $0x1f,%eax
  8021c3:	29 c2                	sub    %eax,%edx
  8021c5:	89 d0                	mov    %edx,%eax
  8021c7:	c1 e0 02             	shl    $0x2,%eax
  8021ca:	01 d0                	add    %edx,%eax
  8021cc:	01 c0                	add    %eax,%eax
  8021ce:	29 c1                	sub    %eax,%ecx
  8021d0:	89 ca                	mov    %ecx,%edx
  8021d2:	85 d2                	test   %edx,%edx
  8021d4:	75 9c                	jne    802172 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8021d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8021dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e0:	48                   	dec    %eax
  8021e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8021e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021e8:	74 3d                	je     802227 <ltostr+0xe2>
		start = 1 ;
  8021ea:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8021f1:	eb 34                	jmp    802227 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8021f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f9:	01 d0                	add    %edx,%eax
  8021fb:	8a 00                	mov    (%eax),%al
  8021fd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802200:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802203:	8b 45 0c             	mov    0xc(%ebp),%eax
  802206:	01 c2                	add    %eax,%edx
  802208:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80220b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220e:	01 c8                	add    %ecx,%eax
  802210:	8a 00                	mov    (%eax),%al
  802212:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802214:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221a:	01 c2                	add    %eax,%edx
  80221c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80221f:	88 02                	mov    %al,(%edx)
		start++ ;
  802221:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802224:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80222d:	7c c4                	jl     8021f3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80222f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802232:	8b 45 0c             	mov    0xc(%ebp),%eax
  802235:	01 d0                	add    %edx,%eax
  802237:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80223a:	90                   	nop
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802243:	ff 75 08             	pushl  0x8(%ebp)
  802246:	e8 54 fa ff ff       	call   801c9f <strlen>
  80224b:	83 c4 04             	add    $0x4,%esp
  80224e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802251:	ff 75 0c             	pushl  0xc(%ebp)
  802254:	e8 46 fa ff ff       	call   801c9f <strlen>
  802259:	83 c4 04             	add    $0x4,%esp
  80225c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80225f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80226d:	eb 17                	jmp    802286 <strcconcat+0x49>
		final[s] = str1[s] ;
  80226f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802272:	8b 45 10             	mov    0x10(%ebp),%eax
  802275:	01 c2                	add    %eax,%edx
  802277:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	01 c8                	add    %ecx,%eax
  80227f:	8a 00                	mov    (%eax),%al
  802281:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802283:	ff 45 fc             	incl   -0x4(%ebp)
  802286:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802289:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80228c:	7c e1                	jl     80226f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80228e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802295:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80229c:	eb 1f                	jmp    8022bd <strcconcat+0x80>
		final[s++] = str2[i] ;
  80229e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022a1:	8d 50 01             	lea    0x1(%eax),%edx
  8022a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8022a7:	89 c2                	mov    %eax,%edx
  8022a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ac:	01 c2                	add    %eax,%edx
  8022ae:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8022b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b4:	01 c8                	add    %ecx,%eax
  8022b6:	8a 00                	mov    (%eax),%al
  8022b8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8022ba:	ff 45 f8             	incl   -0x8(%ebp)
  8022bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022c3:	7c d9                	jl     80229e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8022c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8022cb:	01 d0                	add    %edx,%eax
  8022cd:	c6 00 00             	movb   $0x0,(%eax)
}
  8022d0:	90                   	nop
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8022d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8022df:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ee:	01 d0                	add    %edx,%eax
  8022f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8022f6:	eb 0c                	jmp    802304 <strsplit+0x31>
			*string++ = 0;
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	8d 50 01             	lea    0x1(%eax),%edx
  8022fe:	89 55 08             	mov    %edx,0x8(%ebp)
  802301:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	8a 00                	mov    (%eax),%al
  802309:	84 c0                	test   %al,%al
  80230b:	74 18                	je     802325 <strsplit+0x52>
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	8a 00                	mov    (%eax),%al
  802312:	0f be c0             	movsbl %al,%eax
  802315:	50                   	push   %eax
  802316:	ff 75 0c             	pushl  0xc(%ebp)
  802319:	e8 13 fb ff ff       	call   801e31 <strchr>
  80231e:	83 c4 08             	add    $0x8,%esp
  802321:	85 c0                	test   %eax,%eax
  802323:	75 d3                	jne    8022f8 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	8a 00                	mov    (%eax),%al
  80232a:	84 c0                	test   %al,%al
  80232c:	74 5a                	je     802388 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  80232e:	8b 45 14             	mov    0x14(%ebp),%eax
  802331:	8b 00                	mov    (%eax),%eax
  802333:	83 f8 0f             	cmp    $0xf,%eax
  802336:	75 07                	jne    80233f <strsplit+0x6c>
		{
			return 0;
  802338:	b8 00 00 00 00       	mov    $0x0,%eax
  80233d:	eb 66                	jmp    8023a5 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80233f:	8b 45 14             	mov    0x14(%ebp),%eax
  802342:	8b 00                	mov    (%eax),%eax
  802344:	8d 48 01             	lea    0x1(%eax),%ecx
  802347:	8b 55 14             	mov    0x14(%ebp),%edx
  80234a:	89 0a                	mov    %ecx,(%edx)
  80234c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802353:	8b 45 10             	mov    0x10(%ebp),%eax
  802356:	01 c2                	add    %eax,%edx
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80235d:	eb 03                	jmp    802362 <strsplit+0x8f>
			string++;
  80235f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	8a 00                	mov    (%eax),%al
  802367:	84 c0                	test   %al,%al
  802369:	74 8b                	je     8022f6 <strsplit+0x23>
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	8a 00                	mov    (%eax),%al
  802370:	0f be c0             	movsbl %al,%eax
  802373:	50                   	push   %eax
  802374:	ff 75 0c             	pushl  0xc(%ebp)
  802377:	e8 b5 fa ff ff       	call   801e31 <strchr>
  80237c:	83 c4 08             	add    $0x8,%esp
  80237f:	85 c0                	test   %eax,%eax
  802381:	74 dc                	je     80235f <strsplit+0x8c>
			string++;
	}
  802383:	e9 6e ff ff ff       	jmp    8022f6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802388:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802389:	8b 45 14             	mov    0x14(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802395:	8b 45 10             	mov    0x10(%ebp),%eax
  802398:	01 d0                	add    %edx,%eax
  80239a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8023a0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  8023b0:	e8 7d 0f 00 00       	call   803332 <sys_isUHeapPlacementStrategyNEXTFIT>
  8023b5:	85 c0                	test   %eax,%eax
  8023b7:	0f 84 6f 03 00 00    	je     80272c <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  8023bd:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  8023c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8023ca:	01 d0                	add    %edx,%eax
  8023cc:	48                   	dec    %eax
  8023cd:	89 45 80             	mov    %eax,-0x80(%ebp)
  8023d0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8023d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023d8:	f7 75 84             	divl   -0x7c(%ebp)
  8023db:	8b 45 80             	mov    -0x80(%ebp),%eax
  8023de:	29 d0                	sub    %edx,%eax
  8023e0:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8023e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e7:	74 09                	je     8023f2 <malloc+0x4b>
  8023e9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8023f0:	76 0a                	jbe    8023fc <malloc+0x55>
			return NULL;
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	e9 4b 09 00 00       	jmp    802d47 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8023fc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	01 d0                	add    %edx,%eax
  802407:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80240c:	0f 87 a2 00 00 00    	ja     8024b4 <malloc+0x10d>
  802412:	a1 40 40 98 00       	mov    0x984040,%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	0f 85 95 00 00 00    	jne    8024b4 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  80241f:	a1 04 40 80 00       	mov    0x804004,%eax
  802424:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  80242a:	a1 04 40 80 00       	mov    0x804004,%eax
  80242f:	83 ec 08             	sub    $0x8,%esp
  802432:	ff 75 08             	pushl  0x8(%ebp)
  802435:	50                   	push   %eax
  802436:	e8 a3 0b 00 00       	call   802fde <sys_allocateMem>
  80243b:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  80243e:	a1 20 40 80 00       	mov    0x804020,%eax
  802443:	8b 55 08             	mov    0x8(%ebp),%edx
  802446:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80244d:	a1 20 40 80 00       	mov    0x804020,%eax
  802452:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802458:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  80245f:	a1 20 40 80 00       	mov    0x804020,%eax
  802464:	40                   	inc    %eax
  802465:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  80246a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  802471:	eb 2e                	jmp    8024a1 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802473:	a1 04 40 80 00       	mov    0x804004,%eax
  802478:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  80247d:	c1 e8 0c             	shr    $0xc,%eax
  802480:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802487:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  80248b:	a1 04 40 80 00       	mov    0x804004,%eax
  802490:	05 00 10 00 00       	add    $0x1000,%eax
  802495:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  80249a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a7:	72 ca                	jb     802473 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  8024a9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8024af:	e9 93 08 00 00       	jmp    802d47 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  8024b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  8024bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  8024c2:	a1 40 40 98 00       	mov    0x984040,%eax
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	75 1d                	jne    8024e8 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  8024cb:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  8024d2:	00 00 80 
				check = 1;
  8024d5:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  8024dc:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  8024df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  8024e6:	eb 08                	jmp    8024f0 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  8024e8:	a1 04 40 80 00       	mov    0x804004,%eax
  8024ed:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  8024f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  8024f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  8024fe:	a1 04 40 80 00       	mov    0x804004,%eax
  802503:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  802506:	eb 4d                	jmp    802555 <malloc+0x1ae>
				if (sz == size) {
  802508:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80250b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250e:	75 09                	jne    802519 <malloc+0x172>
					f = 1;
  802510:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802517:	eb 45                	jmp    80255e <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251c:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  802521:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802524:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  80252b:	85 c0                	test   %eax,%eax
  80252d:	75 10                	jne    80253f <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  80252f:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  802536:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  80253d:	eb 16                	jmp    802555 <malloc+0x1ae>
				} else {
					sz = 0;
  80253f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  802546:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  80254d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802550:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  802555:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  80255c:	76 aa                	jbe    802508 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  80255e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802562:	0f 84 95 00 00 00    	je     8025fd <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  802568:	a1 04 40 80 00       	mov    0x804004,%eax
  80256d:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  802573:	a1 04 40 80 00       	mov    0x804004,%eax
  802578:	83 ec 08             	sub    $0x8,%esp
  80257b:	ff 75 08             	pushl  0x8(%ebp)
  80257e:	50                   	push   %eax
  80257f:	e8 5a 0a 00 00       	call   802fde <sys_allocateMem>
  802584:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802587:	a1 20 40 80 00       	mov    0x804020,%eax
  80258c:	8b 55 08             	mov    0x8(%ebp),%edx
  80258f:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802596:	a1 20 40 80 00       	mov    0x804020,%eax
  80259b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8025a1:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  8025a8:	a1 20 40 80 00       	mov    0x804020,%eax
  8025ad:	40                   	inc    %eax
  8025ae:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  8025b3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8025ba:	eb 2e                	jmp    8025ea <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8025bc:	a1 04 40 80 00       	mov    0x804004,%eax
  8025c1:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8025c6:	c1 e8 0c             	shr    $0xc,%eax
  8025c9:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8025d0:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  8025d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8025d9:	05 00 10 00 00       	add    $0x1000,%eax
  8025de:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8025e3:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8025ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f0:	72 ca                	jb     8025bc <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  8025f2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8025f8:	e9 4a 07 00 00       	jmp    802d47 <malloc+0x9a0>

			} else {

				if (check_start) {
  8025fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802601:	74 0a                	je     80260d <malloc+0x266>

					return NULL;
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
  802608:	e9 3a 07 00 00       	jmp    802d47 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  80260d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  802614:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  80261b:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  802622:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  802629:	00 00 80 
				while (ptr < (uint32) temp_end) {
  80262c:	eb 4d                	jmp    80267b <malloc+0x2d4>
					if (sz == size) {
  80262e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802631:	3b 45 08             	cmp    0x8(%ebp),%eax
  802634:	75 09                	jne    80263f <malloc+0x298>
						f = 1;
  802636:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  80263d:	eb 44                	jmp    802683 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80263f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802642:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  802647:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80264a:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	75 10                	jne    802665 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  802655:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  80265c:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  802663:	eb 16                	jmp    80267b <malloc+0x2d4>
					} else {
						sz = 0;
  802665:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  80266c:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  802673:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802676:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  80267b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  802681:	72 ab                	jb     80262e <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  802683:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802687:	0f 84 95 00 00 00    	je     802722 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  80268d:	a1 04 40 80 00       	mov    0x804004,%eax
  802692:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  802698:	a1 04 40 80 00       	mov    0x804004,%eax
  80269d:	83 ec 08             	sub    $0x8,%esp
  8026a0:	ff 75 08             	pushl  0x8(%ebp)
  8026a3:	50                   	push   %eax
  8026a4:	e8 35 09 00 00       	call   802fde <sys_allocateMem>
  8026a9:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  8026ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8026b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b4:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8026bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8026c0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8026c6:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  8026cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8026d2:	40                   	inc    %eax
  8026d3:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  8026d8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  8026df:	eb 2e                	jmp    80270f <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8026e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8026e6:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  8026eb:	c1 e8 0c             	shr    $0xc,%eax
  8026ee:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8026f5:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  8026f9:	a1 04 40 80 00       	mov    0x804004,%eax
  8026fe:	05 00 10 00 00       	add    $0x1000,%eax
  802703:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  802708:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  80270f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802712:	3b 45 08             	cmp    0x8(%ebp),%eax
  802715:	72 ca                	jb     8026e1 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  802717:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80271d:	e9 25 06 00 00       	jmp    802d47 <malloc+0x9a0>

				} else {

					return NULL;
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	e9 1b 06 00 00       	jmp    802d47 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  80272c:	e8 d0 0b 00 00       	call   803301 <sys_isUHeapPlacementStrategyBESTFIT>
  802731:	85 c0                	test   %eax,%eax
  802733:	0f 84 ba 01 00 00    	je     8028f3 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  802739:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  802740:	10 00 00 
  802743:	8b 55 08             	mov    0x8(%ebp),%edx
  802746:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80274c:	01 d0                	add    %edx,%eax
  80274e:	48                   	dec    %eax
  80274f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  802755:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80275b:	ba 00 00 00 00       	mov    $0x0,%edx
  802760:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  802766:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80276c:	29 d0                	sub    %edx,%eax
  80276e:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802771:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802775:	74 09                	je     802780 <malloc+0x3d9>
  802777:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80277e:	76 0a                	jbe    80278a <malloc+0x3e3>
			return NULL;
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
  802785:	e9 bd 05 00 00       	jmp    802d47 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  80278a:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  802791:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  802798:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  80279f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  8027a6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  8027ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b0:	c1 e8 0c             	shr    $0xc,%eax
  8027b3:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  8027b9:	e9 80 00 00 00       	jmp    80283e <malloc+0x497>

			if (heap_mem[i] == 0) {
  8027be:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027c1:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	75 0c                	jne    8027d8 <malloc+0x431>

				count++;
  8027cc:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  8027cf:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  8027d6:	eb 2d                	jmp    802805 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  8027d8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8027de:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8027e1:	77 14                	ja     8027f7 <malloc+0x450>
  8027e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027e6:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8027e9:	76 0c                	jbe    8027f7 <malloc+0x450>

					min_sz = count;
  8027eb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027ee:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  8027f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  8027f7:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  8027fe:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  802805:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  80280c:	75 2d                	jne    80283b <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  80280e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  802814:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  802817:	77 22                	ja     80283b <malloc+0x494>
  802819:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80281c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  80281f:	76 1a                	jbe    80283b <malloc+0x494>

					min_sz = count;
  802821:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802824:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  802827:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80282a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  80282d:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  802834:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  80283b:	ff 45 b8             	incl   -0x48(%ebp)
  80283e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802841:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802846:	0f 86 72 ff ff ff    	jbe    8027be <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  80284c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  802852:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  802855:	77 06                	ja     80285d <malloc+0x4b6>
  802857:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80285b:	75 0a                	jne    802867 <malloc+0x4c0>
			return NULL;
  80285d:	b8 00 00 00 00       	mov    $0x0,%eax
  802862:	e9 e0 04 00 00       	jmp    802d47 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  802867:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80286a:	c1 e0 0c             	shl    $0xc,%eax
  80286d:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  802870:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802873:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  802879:	83 ec 08             	sub    $0x8,%esp
  80287c:	ff 75 08             	pushl  0x8(%ebp)
  80287f:	ff 75 c4             	pushl  -0x3c(%ebp)
  802882:	e8 57 07 00 00       	call   802fde <sys_allocateMem>
  802887:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80288a:	a1 20 40 80 00       	mov    0x804020,%eax
  80288f:	8b 55 08             	mov    0x8(%ebp),%edx
  802892:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  802899:	a1 20 40 80 00       	mov    0x804020,%eax
  80289e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8028a1:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8028a8:	a1 20 40 80 00       	mov    0x804020,%eax
  8028ad:	40                   	inc    %eax
  8028ae:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  8028b3:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8028ba:	eb 24                	jmp    8028e0 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8028bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028bf:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8028c4:	c1 e8 0c             	shr    $0xc,%eax
  8028c7:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8028ce:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  8028d2:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8028d9:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  8028e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8028e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e6:	72 d4                	jb     8028bc <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8028e8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8028ee:	e9 54 04 00 00       	jmp    802d47 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8028f3:	e8 d8 09 00 00       	call   8032d0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	0f 84 88 01 00 00    	je     802a88 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  802900:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  802907:	10 00 00 
  80290a:	8b 55 08             	mov    0x8(%ebp),%edx
  80290d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  802913:	01 d0                	add    %edx,%eax
  802915:	48                   	dec    %eax
  802916:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  80291c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  802922:	ba 00 00 00 00       	mov    $0x0,%edx
  802927:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  80292d:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  802933:	29 d0                	sub    %edx,%eax
  802935:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802938:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80293c:	74 09                	je     802947 <malloc+0x5a0>
  80293e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802945:	76 0a                	jbe    802951 <malloc+0x5aa>
			return NULL;
  802947:	b8 00 00 00 00       	mov    $0x0,%eax
  80294c:	e9 f6 03 00 00       	jmp    802d47 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  802951:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  802958:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  80295f:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  802966:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  80296d:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	c1 e8 0c             	shr    $0xc,%eax
  80297a:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  802980:	eb 5a                	jmp    8029dc <malloc+0x635>

			if (heap_mem[i] == 0) {
  802982:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802985:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	75 0c                	jne    80299c <malloc+0x5f5>

				count++;
  802990:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  802993:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  80299a:	eb 22                	jmp    8029be <malloc+0x617>
			} else {
				if (num_p <= count) {
  80299c:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8029a2:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  8029a5:	77 09                	ja     8029b0 <malloc+0x609>

					found = 1;
  8029a7:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  8029ae:	eb 36                	jmp    8029e6 <malloc+0x63f>
				}
				count = 0;
  8029b0:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  8029b7:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  8029be:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  8029c5:	75 12                	jne    8029d9 <malloc+0x632>

				if (num_p <= count) {
  8029c7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8029cd:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  8029d0:	77 07                	ja     8029d9 <malloc+0x632>

					found = 1;
  8029d2:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  8029d9:	ff 45 a4             	incl   -0x5c(%ebp)
  8029dc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029df:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8029e4:	76 9c                	jbe    802982 <malloc+0x5db>

			}

		}

		if (!found) {
  8029e6:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  8029ea:	75 0a                	jne    8029f6 <malloc+0x64f>
			return NULL;
  8029ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f1:	e9 51 03 00 00       	jmp    802d47 <malloc+0x9a0>

		}

		temp = ptr;
  8029f6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029f9:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  8029fc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029ff:	c1 e0 0c             	shl    $0xc,%eax
  802a02:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  802a05:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a08:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  802a0e:	83 ec 08             	sub    $0x8,%esp
  802a11:	ff 75 08             	pushl  0x8(%ebp)
  802a14:	ff 75 b0             	pushl  -0x50(%ebp)
  802a17:	e8 c2 05 00 00       	call   802fde <sys_allocateMem>
  802a1c:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802a1f:	a1 20 40 80 00       	mov    0x804020,%eax
  802a24:	8b 55 08             	mov    0x8(%ebp),%edx
  802a27:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  802a2e:	a1 20 40 80 00       	mov    0x804020,%eax
  802a33:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a36:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  802a3d:	a1 20 40 80 00       	mov    0x804020,%eax
  802a42:	40                   	inc    %eax
  802a43:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  802a48:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802a4f:	eb 24                	jmp    802a75 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802a51:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a54:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802a59:	c1 e8 0c             	shr    $0xc,%eax
  802a5c:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802a63:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802a67:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802a6e:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  802a75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7b:	72 d4                	jb     802a51 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  802a7d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  802a83:	e9 bf 02 00 00       	jmp    802d47 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  802a88:	e8 d6 08 00 00       	call   803363 <sys_isUHeapPlacementStrategyWORSTFIT>
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	0f 84 ba 01 00 00    	je     802c4f <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  802a95:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  802a9c:	10 00 00 
  802a9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa2:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802aa8:	01 d0                	add    %edx,%eax
  802aaa:	48                   	dec    %eax
  802aab:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802ab1:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  802abc:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802ac2:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802ac8:	29 d0                	sub    %edx,%eax
  802aca:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802acd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad1:	74 09                	je     802adc <malloc+0x735>
  802ad3:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802ada:	76 0a                	jbe    802ae6 <malloc+0x73f>
					return NULL;
  802adc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae1:	e9 61 02 00 00       	jmp    802d47 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  802ae6:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  802aed:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  802af4:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  802afb:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  802b02:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	c1 e8 0c             	shr    $0xc,%eax
  802b0f:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802b15:	e9 80 00 00 00       	jmp    802b9a <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  802b1a:	8b 45 90             	mov    -0x70(%ebp),%eax
  802b1d:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802b24:	85 c0                	test   %eax,%eax
  802b26:	75 0c                	jne    802b34 <malloc+0x78d>

						count++;
  802b28:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  802b2b:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  802b32:	eb 2d                	jmp    802b61 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  802b34:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802b3a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802b3d:	77 14                	ja     802b53 <malloc+0x7ac>
  802b3f:	8b 45 98             	mov    -0x68(%ebp),%eax
  802b42:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802b45:	73 0c                	jae    802b53 <malloc+0x7ac>

							max_sz = count;
  802b47:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b4a:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802b4d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802b50:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  802b53:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  802b5a:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  802b61:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  802b68:	75 2d                	jne    802b97 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  802b6a:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802b70:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802b73:	77 22                	ja     802b97 <malloc+0x7f0>
  802b75:	8b 45 98             	mov    -0x68(%ebp),%eax
  802b78:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802b7b:	76 1a                	jbe    802b97 <malloc+0x7f0>

							max_sz = count;
  802b7d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b80:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802b83:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802b86:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  802b89:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  802b90:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802b97:	ff 45 90             	incl   -0x70(%ebp)
  802b9a:	8b 45 90             	mov    -0x70(%ebp),%eax
  802b9d:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802ba2:	0f 86 72 ff ff ff    	jbe    802b1a <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  802ba8:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802bae:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802bb1:	77 06                	ja     802bb9 <malloc+0x812>
  802bb3:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802bb7:	75 0a                	jne    802bc3 <malloc+0x81c>
					return NULL;
  802bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbe:	e9 84 01 00 00       	jmp    802d47 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802bc3:	8b 45 98             	mov    -0x68(%ebp),%eax
  802bc6:	c1 e0 0c             	shl    $0xc,%eax
  802bc9:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  802bcc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802bcf:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  802bd5:	83 ec 08             	sub    $0x8,%esp
  802bd8:	ff 75 08             	pushl  0x8(%ebp)
  802bdb:	ff 75 9c             	pushl  -0x64(%ebp)
  802bde:	e8 fb 03 00 00       	call   802fde <sys_allocateMem>
  802be3:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802be6:	a1 20 40 80 00       	mov    0x804020,%eax
  802beb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bee:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  802bf5:	a1 20 40 80 00       	mov    0x804020,%eax
  802bfa:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802bfd:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  802c04:	a1 20 40 80 00       	mov    0x804020,%eax
  802c09:	40                   	inc    %eax
  802c0a:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  802c0f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802c16:	eb 24                	jmp    802c3c <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802c18:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802c1b:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802c20:	c1 e8 0c             	shr    $0xc,%eax
  802c23:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802c2a:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802c2e:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802c35:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  802c3c:	8b 45 90             	mov    -0x70(%ebp),%eax
  802c3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c42:	72 d4                	jb     802c18 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  802c44:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  802c4a:	e9 f8 00 00 00       	jmp    802d47 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802c4f:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  802c56:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  802c5d:	10 00 00 
  802c60:	8b 55 08             	mov    0x8(%ebp),%edx
  802c63:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  802c69:	01 d0                	add    %edx,%eax
  802c6b:	48                   	dec    %eax
  802c6c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802c72:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802c78:	ba 00 00 00 00       	mov    $0x0,%edx
  802c7d:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802c83:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  802c89:	29 d0                	sub    %edx,%eax
  802c8b:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802c8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c92:	74 09                	je     802c9d <malloc+0x8f6>
  802c94:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802c9b:	76 0a                	jbe    802ca7 <malloc+0x900>
		return NULL;
  802c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca2:	e9 a0 00 00 00       	jmp    802d47 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802ca7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	01 d0                	add    %edx,%eax
  802cb2:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802cb7:	0f 87 87 00 00 00    	ja     802d44 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  802cbd:	a1 04 40 80 00       	mov    0x804004,%eax
  802cc2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802cc5:	a1 04 40 80 00       	mov    0x804004,%eax
  802cca:	83 ec 08             	sub    $0x8,%esp
  802ccd:	ff 75 08             	pushl  0x8(%ebp)
  802cd0:	50                   	push   %eax
  802cd1:	e8 08 03 00 00       	call   802fde <sys_allocateMem>
  802cd6:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802cd9:	a1 20 40 80 00       	mov    0x804020,%eax
  802cde:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce1:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802ce8:	a1 20 40 80 00       	mov    0x804020,%eax
  802ced:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802cf3:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  802cfa:	a1 20 40 80 00       	mov    0x804020,%eax
  802cff:	40                   	inc    %eax
  802d00:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  802d05:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  802d0c:	eb 2e                	jmp    802d3c <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802d0e:	a1 04 40 80 00       	mov    0x804004,%eax
  802d13:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802d18:	c1 e8 0c             	shr    $0xc,%eax
  802d1b:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802d22:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  802d26:	a1 04 40 80 00       	mov    0x804004,%eax
  802d2b:	05 00 10 00 00       	add    $0x1000,%eax
  802d30:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  802d35:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  802d3c:	8b 45 88             	mov    -0x78(%ebp),%eax
  802d3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d42:	72 ca                	jb     802d0e <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  802d44:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  802d47:	c9                   	leave  
  802d48:	c3                   	ret    

00802d49 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
  802d4c:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802d4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  802d56:	e9 c1 00 00 00       	jmp    802e1c <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  802d65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d68:	0f 85 ab 00 00 00    	jne    802e19 <free+0xd0>

			if (heap_size[inx].size == 0) {
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	75 21                	jne    802d9d <free+0x54>
				heap_size[inx].size = 0;
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802d86:	00 00 00 00 
				heap_size[inx].vir = NULL;
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802d94:	00 00 00 00 
				return;
  802d98:	e9 8d 00 00 00       	jmp    802e2a <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	83 ec 08             	sub    $0x8,%esp
  802dad:	52                   	push   %edx
  802dae:	50                   	push   %eax
  802daf:	e8 0e 02 00 00       	call   802fc2 <sys_freeMem>
  802db4:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802db7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802dc4:	eb 24                	jmp    802dea <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	05 00 00 00 80       	add    $0x80000000,%eax
  802dce:	c1 e8 0c             	shr    $0xc,%eax
  802dd1:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  802dd8:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  802ddc:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802de3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	39 c2                	cmp    %eax,%edx
  802df9:	77 cb                	ja     802dc6 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802e05:	00 00 00 00 
			heap_size[inx].vir = NULL;
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802e13:	00 00 00 00 
			break;
  802e17:	eb 11                	jmp    802e2a <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  802e19:	ff 45 f4             	incl   -0xc(%ebp)
  802e1c:	a1 20 40 80 00       	mov    0x804020,%eax
  802e21:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802e24:	0f 8c 31 ff ff ff    	jl     802d5b <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  802e2a:	c9                   	leave  
  802e2b:	c3                   	ret    

00802e2c <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
  802e2f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802e32:	83 ec 04             	sub    $0x4,%esp
  802e35:	68 b0 3c 80 00       	push   $0x803cb0
  802e3a:	68 1c 02 00 00       	push   $0x21c
  802e3f:	68 d6 3c 80 00       	push   $0x803cd6
  802e44:	e8 b0 e6 ff ff       	call   8014f9 <_panic>

00802e49 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e49:	55                   	push   %ebp
  802e4a:	89 e5                	mov    %esp,%ebp
  802e4c:	57                   	push   %edi
  802e4d:	56                   	push   %esi
  802e4e:	53                   	push   %ebx
  802e4f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e5e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e61:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e64:	cd 30                	int    $0x30
  802e66:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e6c:	83 c4 10             	add    $0x10,%esp
  802e6f:	5b                   	pop    %ebx
  802e70:	5e                   	pop    %esi
  802e71:	5f                   	pop    %edi
  802e72:	5d                   	pop    %ebp
  802e73:	c3                   	ret    

00802e74 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802e74:	55                   	push   %ebp
  802e75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	6a 00                	push   $0x0
  802e7c:	6a 00                	push   $0x0
  802e7e:	6a 00                	push   $0x0
  802e80:	ff 75 0c             	pushl  0xc(%ebp)
  802e83:	50                   	push   %eax
  802e84:	6a 00                	push   $0x0
  802e86:	e8 be ff ff ff       	call   802e49 <syscall>
  802e8b:	83 c4 18             	add    $0x18,%esp
}
  802e8e:	90                   	nop
  802e8f:	c9                   	leave  
  802e90:	c3                   	ret    

00802e91 <sys_cgetc>:

int
sys_cgetc(void)
{
  802e91:	55                   	push   %ebp
  802e92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e94:	6a 00                	push   $0x0
  802e96:	6a 00                	push   $0x0
  802e98:	6a 00                	push   $0x0
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 01                	push   $0x1
  802ea0:	e8 a4 ff ff ff       	call   802e49 <syscall>
  802ea5:	83 c4 18             	add    $0x18,%esp
}
  802ea8:	c9                   	leave  
  802ea9:	c3                   	ret    

00802eaa <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802eaa:	55                   	push   %ebp
  802eab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	6a 00                	push   $0x0
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	50                   	push   %eax
  802eb9:	6a 03                	push   $0x3
  802ebb:	e8 89 ff ff ff       	call   802e49 <syscall>
  802ec0:	83 c4 18             	add    $0x18,%esp
}
  802ec3:	c9                   	leave  
  802ec4:	c3                   	ret    

00802ec5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802ec5:	55                   	push   %ebp
  802ec6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802ec8:	6a 00                	push   $0x0
  802eca:	6a 00                	push   $0x0
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 00                	push   $0x0
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 02                	push   $0x2
  802ed4:	e8 70 ff ff ff       	call   802e49 <syscall>
  802ed9:	83 c4 18             	add    $0x18,%esp
}
  802edc:	c9                   	leave  
  802edd:	c3                   	ret    

00802ede <sys_env_exit>:

void sys_env_exit(void)
{
  802ede:	55                   	push   %ebp
  802edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802ee1:	6a 00                	push   $0x0
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 04                	push   $0x4
  802eed:	e8 57 ff ff ff       	call   802e49 <syscall>
  802ef2:	83 c4 18             	add    $0x18,%esp
}
  802ef5:	90                   	nop
  802ef6:	c9                   	leave  
  802ef7:	c3                   	ret    

00802ef8 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802ef8:	55                   	push   %ebp
  802ef9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802efb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	6a 00                	push   $0x0
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	52                   	push   %edx
  802f08:	50                   	push   %eax
  802f09:	6a 05                	push   $0x5
  802f0b:	e8 39 ff ff ff       	call   802e49 <syscall>
  802f10:	83 c4 18             	add    $0x18,%esp
}
  802f13:	c9                   	leave  
  802f14:	c3                   	ret    

00802f15 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f15:	55                   	push   %ebp
  802f16:	89 e5                	mov    %esp,%ebp
  802f18:	56                   	push   %esi
  802f19:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f1a:	8b 75 18             	mov    0x18(%ebp),%esi
  802f1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f23:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	56                   	push   %esi
  802f2a:	53                   	push   %ebx
  802f2b:	51                   	push   %ecx
  802f2c:	52                   	push   %edx
  802f2d:	50                   	push   %eax
  802f2e:	6a 06                	push   $0x6
  802f30:	e8 14 ff ff ff       	call   802e49 <syscall>
  802f35:	83 c4 18             	add    $0x18,%esp
}
  802f38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f3b:	5b                   	pop    %ebx
  802f3c:	5e                   	pop    %esi
  802f3d:	5d                   	pop    %ebp
  802f3e:	c3                   	ret    

00802f3f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802f3f:	55                   	push   %ebp
  802f40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	52                   	push   %edx
  802f4f:	50                   	push   %eax
  802f50:	6a 07                	push   $0x7
  802f52:	e8 f2 fe ff ff       	call   802e49 <syscall>
  802f57:	83 c4 18             	add    $0x18,%esp
}
  802f5a:	c9                   	leave  
  802f5b:	c3                   	ret    

00802f5c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f5c:	55                   	push   %ebp
  802f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 00                	push   $0x0
  802f65:	ff 75 0c             	pushl  0xc(%ebp)
  802f68:	ff 75 08             	pushl  0x8(%ebp)
  802f6b:	6a 08                	push   $0x8
  802f6d:	e8 d7 fe ff ff       	call   802e49 <syscall>
  802f72:	83 c4 18             	add    $0x18,%esp
}
  802f75:	c9                   	leave  
  802f76:	c3                   	ret    

00802f77 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f77:	55                   	push   %ebp
  802f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	6a 00                	push   $0x0
  802f84:	6a 09                	push   $0x9
  802f86:	e8 be fe ff ff       	call   802e49 <syscall>
  802f8b:	83 c4 18             	add    $0x18,%esp
}
  802f8e:	c9                   	leave  
  802f8f:	c3                   	ret    

00802f90 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f90:	55                   	push   %ebp
  802f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 0a                	push   $0xa
  802f9f:	e8 a5 fe ff ff       	call   802e49 <syscall>
  802fa4:	83 c4 18             	add    $0x18,%esp
}
  802fa7:	c9                   	leave  
  802fa8:	c3                   	ret    

00802fa9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fa9:	55                   	push   %ebp
  802faa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fac:	6a 00                	push   $0x0
  802fae:	6a 00                	push   $0x0
  802fb0:	6a 00                	push   $0x0
  802fb2:	6a 00                	push   $0x0
  802fb4:	6a 00                	push   $0x0
  802fb6:	6a 0b                	push   $0xb
  802fb8:	e8 8c fe ff ff       	call   802e49 <syscall>
  802fbd:	83 c4 18             	add    $0x18,%esp
}
  802fc0:	c9                   	leave  
  802fc1:	c3                   	ret    

00802fc2 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802fc2:	55                   	push   %ebp
  802fc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	ff 75 0c             	pushl  0xc(%ebp)
  802fce:	ff 75 08             	pushl  0x8(%ebp)
  802fd1:	6a 0d                	push   $0xd
  802fd3:	e8 71 fe ff ff       	call   802e49 <syscall>
  802fd8:	83 c4 18             	add    $0x18,%esp
	return;
  802fdb:	90                   	nop
}
  802fdc:	c9                   	leave  
  802fdd:	c3                   	ret    

00802fde <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802fde:	55                   	push   %ebp
  802fdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 00                	push   $0x0
  802fe7:	ff 75 0c             	pushl  0xc(%ebp)
  802fea:	ff 75 08             	pushl  0x8(%ebp)
  802fed:	6a 0e                	push   $0xe
  802fef:	e8 55 fe ff ff       	call   802e49 <syscall>
  802ff4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ff7:	90                   	nop
}
  802ff8:	c9                   	leave  
  802ff9:	c3                   	ret    

00802ffa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ffa:	55                   	push   %ebp
  802ffb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 00                	push   $0x0
  803001:	6a 00                	push   $0x0
  803003:	6a 00                	push   $0x0
  803005:	6a 00                	push   $0x0
  803007:	6a 0c                	push   $0xc
  803009:	e8 3b fe ff ff       	call   802e49 <syscall>
  80300e:	83 c4 18             	add    $0x18,%esp
}
  803011:	c9                   	leave  
  803012:	c3                   	ret    

00803013 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  803013:	55                   	push   %ebp
  803014:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  803016:	6a 00                	push   $0x0
  803018:	6a 00                	push   $0x0
  80301a:	6a 00                	push   $0x0
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	6a 10                	push   $0x10
  803022:	e8 22 fe ff ff       	call   802e49 <syscall>
  803027:	83 c4 18             	add    $0x18,%esp
}
  80302a:	90                   	nop
  80302b:	c9                   	leave  
  80302c:	c3                   	ret    

0080302d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80302d:	55                   	push   %ebp
  80302e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	6a 11                	push   $0x11
  80303c:	e8 08 fe ff ff       	call   802e49 <syscall>
  803041:	83 c4 18             	add    $0x18,%esp
}
  803044:	90                   	nop
  803045:	c9                   	leave  
  803046:	c3                   	ret    

00803047 <sys_cputc>:


void
sys_cputc(const char c)
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
  80304a:	83 ec 04             	sub    $0x4,%esp
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803053:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803057:	6a 00                	push   $0x0
  803059:	6a 00                	push   $0x0
  80305b:	6a 00                	push   $0x0
  80305d:	6a 00                	push   $0x0
  80305f:	50                   	push   %eax
  803060:	6a 12                	push   $0x12
  803062:	e8 e2 fd ff ff       	call   802e49 <syscall>
  803067:	83 c4 18             	add    $0x18,%esp
}
  80306a:	90                   	nop
  80306b:	c9                   	leave  
  80306c:	c3                   	ret    

0080306d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80306d:	55                   	push   %ebp
  80306e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	6a 00                	push   $0x0
  803076:	6a 00                	push   $0x0
  803078:	6a 00                	push   $0x0
  80307a:	6a 13                	push   $0x13
  80307c:	e8 c8 fd ff ff       	call   802e49 <syscall>
  803081:	83 c4 18             	add    $0x18,%esp
}
  803084:	90                   	nop
  803085:	c9                   	leave  
  803086:	c3                   	ret    

00803087 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  803087:	55                   	push   %ebp
  803088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	6a 00                	push   $0x0
  80308f:	6a 00                	push   $0x0
  803091:	6a 00                	push   $0x0
  803093:	ff 75 0c             	pushl  0xc(%ebp)
  803096:	50                   	push   %eax
  803097:	6a 14                	push   $0x14
  803099:	e8 ab fd ff ff       	call   802e49 <syscall>
  80309e:	83 c4 18             	add    $0x18,%esp
}
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    

008030a3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	6a 00                	push   $0x0
  8030ab:	6a 00                	push   $0x0
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	50                   	push   %eax
  8030b2:	6a 17                	push   $0x17
  8030b4:	e8 90 fd ff ff       	call   802e49 <syscall>
  8030b9:	83 c4 18             	add    $0x18,%esp
}
  8030bc:	c9                   	leave  
  8030bd:	c3                   	ret    

008030be <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  8030be:	55                   	push   %ebp
  8030bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	6a 00                	push   $0x0
  8030c6:	6a 00                	push   $0x0
  8030c8:	6a 00                	push   $0x0
  8030ca:	6a 00                	push   $0x0
  8030cc:	50                   	push   %eax
  8030cd:	6a 15                	push   $0x15
  8030cf:	e8 75 fd ff ff       	call   802e49 <syscall>
  8030d4:	83 c4 18             	add    $0x18,%esp
}
  8030d7:	90                   	nop
  8030d8:	c9                   	leave  
  8030d9:	c3                   	ret    

008030da <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8030da:	55                   	push   %ebp
  8030db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	6a 00                	push   $0x0
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	50                   	push   %eax
  8030e9:	6a 16                	push   $0x16
  8030eb:	e8 59 fd ff ff       	call   802e49 <syscall>
  8030f0:	83 c4 18             	add    $0x18,%esp
}
  8030f3:	90                   	nop
  8030f4:	c9                   	leave  
  8030f5:	c3                   	ret    

008030f6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8030f6:	55                   	push   %ebp
  8030f7:	89 e5                	mov    %esp,%ebp
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8030ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  803102:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803105:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	6a 00                	push   $0x0
  80310e:	51                   	push   %ecx
  80310f:	52                   	push   %edx
  803110:	ff 75 0c             	pushl  0xc(%ebp)
  803113:	50                   	push   %eax
  803114:	6a 18                	push   $0x18
  803116:	e8 2e fd ff ff       	call   802e49 <syscall>
  80311b:	83 c4 18             	add    $0x18,%esp
}
  80311e:	c9                   	leave  
  80311f:	c3                   	ret    

00803120 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  803120:	55                   	push   %ebp
  803121:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  803123:	8b 55 0c             	mov    0xc(%ebp),%edx
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	6a 00                	push   $0x0
  80312b:	6a 00                	push   $0x0
  80312d:	6a 00                	push   $0x0
  80312f:	52                   	push   %edx
  803130:	50                   	push   %eax
  803131:	6a 19                	push   $0x19
  803133:	e8 11 fd ff ff       	call   802e49 <syscall>
  803138:	83 c4 18             	add    $0x18,%esp
}
  80313b:	c9                   	leave  
  80313c:	c3                   	ret    

0080313d <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80313d:	55                   	push   %ebp
  80313e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	6a 00                	push   $0x0
  80314b:	50                   	push   %eax
  80314c:	6a 1a                	push   $0x1a
  80314e:	e8 f6 fc ff ff       	call   802e49 <syscall>
  803153:	83 c4 18             	add    $0x18,%esp
}
  803156:	c9                   	leave  
  803157:	c3                   	ret    

00803158 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  803158:	55                   	push   %ebp
  803159:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  80315b:	6a 00                	push   $0x0
  80315d:	6a 00                	push   $0x0
  80315f:	6a 00                	push   $0x0
  803161:	6a 00                	push   $0x0
  803163:	6a 00                	push   $0x0
  803165:	6a 1b                	push   $0x1b
  803167:	e8 dd fc ff ff       	call   802e49 <syscall>
  80316c:	83 c4 18             	add    $0x18,%esp
}
  80316f:	c9                   	leave  
  803170:	c3                   	ret    

00803171 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  803171:	55                   	push   %ebp
  803172:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 00                	push   $0x0
  80317e:	6a 1c                	push   $0x1c
  803180:	e8 c4 fc ff ff       	call   802e49 <syscall>
  803185:	83 c4 18             	add    $0x18,%esp
}
  803188:	c9                   	leave  
  803189:	c3                   	ret    

0080318a <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  80318a:	55                   	push   %ebp
  80318b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	6a 00                	push   $0x0
  803192:	6a 00                	push   $0x0
  803194:	6a 00                	push   $0x0
  803196:	ff 75 0c             	pushl  0xc(%ebp)
  803199:	50                   	push   %eax
  80319a:	6a 1d                	push   $0x1d
  80319c:	e8 a8 fc ff ff       	call   802e49 <syscall>
  8031a1:	83 c4 18             	add    $0x18,%esp
}
  8031a4:	c9                   	leave  
  8031a5:	c3                   	ret    

008031a6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8031a6:	55                   	push   %ebp
  8031a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	6a 00                	push   $0x0
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	50                   	push   %eax
  8031b5:	6a 1e                	push   $0x1e
  8031b7:	e8 8d fc ff ff       	call   802e49 <syscall>
  8031bc:	83 c4 18             	add    $0x18,%esp
}
  8031bf:	90                   	nop
  8031c0:	c9                   	leave  
  8031c1:	c3                   	ret    

008031c2 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8031c2:	55                   	push   %ebp
  8031c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	6a 00                	push   $0x0
  8031ca:	6a 00                	push   $0x0
  8031cc:	6a 00                	push   $0x0
  8031ce:	6a 00                	push   $0x0
  8031d0:	50                   	push   %eax
  8031d1:	6a 1f                	push   $0x1f
  8031d3:	e8 71 fc ff ff       	call   802e49 <syscall>
  8031d8:	83 c4 18             	add    $0x18,%esp
}
  8031db:	90                   	nop
  8031dc:	c9                   	leave  
  8031dd:	c3                   	ret    

008031de <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8031de:	55                   	push   %ebp
  8031df:	89 e5                	mov    %esp,%ebp
  8031e1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031e7:	8d 50 04             	lea    0x4(%eax),%edx
  8031ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031ed:	6a 00                	push   $0x0
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	52                   	push   %edx
  8031f4:	50                   	push   %eax
  8031f5:	6a 20                	push   $0x20
  8031f7:	e8 4d fc ff ff       	call   802e49 <syscall>
  8031fc:	83 c4 18             	add    $0x18,%esp
	return result;
  8031ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803202:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803205:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803208:	89 01                	mov    %eax,(%ecx)
  80320a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	c9                   	leave  
  803211:	c2 04 00             	ret    $0x4

00803214 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803214:	55                   	push   %ebp
  803215:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803217:	6a 00                	push   $0x0
  803219:	6a 00                	push   $0x0
  80321b:	ff 75 10             	pushl  0x10(%ebp)
  80321e:	ff 75 0c             	pushl  0xc(%ebp)
  803221:	ff 75 08             	pushl  0x8(%ebp)
  803224:	6a 0f                	push   $0xf
  803226:	e8 1e fc ff ff       	call   802e49 <syscall>
  80322b:	83 c4 18             	add    $0x18,%esp
	return ;
  80322e:	90                   	nop
}
  80322f:	c9                   	leave  
  803230:	c3                   	ret    

00803231 <sys_rcr2>:
uint32 sys_rcr2()
{
  803231:	55                   	push   %ebp
  803232:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	6a 00                	push   $0x0
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 21                	push   $0x21
  803240:	e8 04 fc ff ff       	call   802e49 <syscall>
  803245:	83 c4 18             	add    $0x18,%esp
}
  803248:	c9                   	leave  
  803249:	c3                   	ret    

0080324a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80324a:	55                   	push   %ebp
  80324b:	89 e5                	mov    %esp,%ebp
  80324d:	83 ec 04             	sub    $0x4,%esp
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803256:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80325a:	6a 00                	push   $0x0
  80325c:	6a 00                	push   $0x0
  80325e:	6a 00                	push   $0x0
  803260:	6a 00                	push   $0x0
  803262:	50                   	push   %eax
  803263:	6a 22                	push   $0x22
  803265:	e8 df fb ff ff       	call   802e49 <syscall>
  80326a:	83 c4 18             	add    $0x18,%esp
	return ;
  80326d:	90                   	nop
}
  80326e:	c9                   	leave  
  80326f:	c3                   	ret    

00803270 <rsttst>:
void rsttst()
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803273:	6a 00                	push   $0x0
  803275:	6a 00                	push   $0x0
  803277:	6a 00                	push   $0x0
  803279:	6a 00                	push   $0x0
  80327b:	6a 00                	push   $0x0
  80327d:	6a 24                	push   $0x24
  80327f:	e8 c5 fb ff ff       	call   802e49 <syscall>
  803284:	83 c4 18             	add    $0x18,%esp
	return ;
  803287:	90                   	nop
}
  803288:	c9                   	leave  
  803289:	c3                   	ret    

0080328a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80328a:	55                   	push   %ebp
  80328b:	89 e5                	mov    %esp,%ebp
  80328d:	83 ec 04             	sub    $0x4,%esp
  803290:	8b 45 14             	mov    0x14(%ebp),%eax
  803293:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803296:	8b 55 18             	mov    0x18(%ebp),%edx
  803299:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80329d:	52                   	push   %edx
  80329e:	50                   	push   %eax
  80329f:	ff 75 10             	pushl  0x10(%ebp)
  8032a2:	ff 75 0c             	pushl  0xc(%ebp)
  8032a5:	ff 75 08             	pushl  0x8(%ebp)
  8032a8:	6a 23                	push   $0x23
  8032aa:	e8 9a fb ff ff       	call   802e49 <syscall>
  8032af:	83 c4 18             	add    $0x18,%esp
	return ;
  8032b2:	90                   	nop
}
  8032b3:	c9                   	leave  
  8032b4:	c3                   	ret    

008032b5 <chktst>:
void chktst(uint32 n)
{
  8032b5:	55                   	push   %ebp
  8032b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8032b8:	6a 00                	push   $0x0
  8032ba:	6a 00                	push   $0x0
  8032bc:	6a 00                	push   $0x0
  8032be:	6a 00                	push   $0x0
  8032c0:	ff 75 08             	pushl  0x8(%ebp)
  8032c3:	6a 25                	push   $0x25
  8032c5:	e8 7f fb ff ff       	call   802e49 <syscall>
  8032ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8032cd:	90                   	nop
}
  8032ce:	c9                   	leave  
  8032cf:	c3                   	ret    

008032d0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
  8032d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032d6:	6a 00                	push   $0x0
  8032d8:	6a 00                	push   $0x0
  8032da:	6a 00                	push   $0x0
  8032dc:	6a 00                	push   $0x0
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 26                	push   $0x26
  8032e2:	e8 62 fb ff ff       	call   802e49 <syscall>
  8032e7:	83 c4 18             	add    $0x18,%esp
  8032ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8032ed:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8032f1:	75 07                	jne    8032fa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8032f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8032f8:	eb 05                	jmp    8032ff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8032fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032ff:	c9                   	leave  
  803300:	c3                   	ret    

00803301 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  803301:	55                   	push   %ebp
  803302:	89 e5                	mov    %esp,%ebp
  803304:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803307:	6a 00                	push   $0x0
  803309:	6a 00                	push   $0x0
  80330b:	6a 00                	push   $0x0
  80330d:	6a 00                	push   $0x0
  80330f:	6a 00                	push   $0x0
  803311:	6a 26                	push   $0x26
  803313:	e8 31 fb ff ff       	call   802e49 <syscall>
  803318:	83 c4 18             	add    $0x18,%esp
  80331b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80331e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803322:	75 07                	jne    80332b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803324:	b8 01 00 00 00       	mov    $0x1,%eax
  803329:	eb 05                	jmp    803330 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80332b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803330:	c9                   	leave  
  803331:	c3                   	ret    

00803332 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803332:	55                   	push   %ebp
  803333:	89 e5                	mov    %esp,%ebp
  803335:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	6a 00                	push   $0x0
  80333e:	6a 00                	push   $0x0
  803340:	6a 00                	push   $0x0
  803342:	6a 26                	push   $0x26
  803344:	e8 00 fb ff ff       	call   802e49 <syscall>
  803349:	83 c4 18             	add    $0x18,%esp
  80334c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80334f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803353:	75 07                	jne    80335c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803355:	b8 01 00 00 00       	mov    $0x1,%eax
  80335a:	eb 05                	jmp    803361 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80335c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803361:	c9                   	leave  
  803362:	c3                   	ret    

00803363 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803363:	55                   	push   %ebp
  803364:	89 e5                	mov    %esp,%ebp
  803366:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803369:	6a 00                	push   $0x0
  80336b:	6a 00                	push   $0x0
  80336d:	6a 00                	push   $0x0
  80336f:	6a 00                	push   $0x0
  803371:	6a 00                	push   $0x0
  803373:	6a 26                	push   $0x26
  803375:	e8 cf fa ff ff       	call   802e49 <syscall>
  80337a:	83 c4 18             	add    $0x18,%esp
  80337d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803380:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803384:	75 07                	jne    80338d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803386:	b8 01 00 00 00       	mov    $0x1,%eax
  80338b:	eb 05                	jmp    803392 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80338d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803392:	c9                   	leave  
  803393:	c3                   	ret    

00803394 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803394:	55                   	push   %ebp
  803395:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803397:	6a 00                	push   $0x0
  803399:	6a 00                	push   $0x0
  80339b:	6a 00                	push   $0x0
  80339d:	6a 00                	push   $0x0
  80339f:	ff 75 08             	pushl  0x8(%ebp)
  8033a2:	6a 27                	push   $0x27
  8033a4:	e8 a0 fa ff ff       	call   802e49 <syscall>
  8033a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8033ac:	90                   	nop
}
  8033ad:	c9                   	leave  
  8033ae:	c3                   	ret    
  8033af:	90                   	nop

008033b0 <__udivdi3>:
  8033b0:	55                   	push   %ebp
  8033b1:	57                   	push   %edi
  8033b2:	56                   	push   %esi
  8033b3:	53                   	push   %ebx
  8033b4:	83 ec 1c             	sub    $0x1c,%esp
  8033b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033c7:	89 ca                	mov    %ecx,%edx
  8033c9:	89 f8                	mov    %edi,%eax
  8033cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033cf:	85 f6                	test   %esi,%esi
  8033d1:	75 2d                	jne    803400 <__udivdi3+0x50>
  8033d3:	39 cf                	cmp    %ecx,%edi
  8033d5:	77 65                	ja     80343c <__udivdi3+0x8c>
  8033d7:	89 fd                	mov    %edi,%ebp
  8033d9:	85 ff                	test   %edi,%edi
  8033db:	75 0b                	jne    8033e8 <__udivdi3+0x38>
  8033dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8033e2:	31 d2                	xor    %edx,%edx
  8033e4:	f7 f7                	div    %edi
  8033e6:	89 c5                	mov    %eax,%ebp
  8033e8:	31 d2                	xor    %edx,%edx
  8033ea:	89 c8                	mov    %ecx,%eax
  8033ec:	f7 f5                	div    %ebp
  8033ee:	89 c1                	mov    %eax,%ecx
  8033f0:	89 d8                	mov    %ebx,%eax
  8033f2:	f7 f5                	div    %ebp
  8033f4:	89 cf                	mov    %ecx,%edi
  8033f6:	89 fa                	mov    %edi,%edx
  8033f8:	83 c4 1c             	add    $0x1c,%esp
  8033fb:	5b                   	pop    %ebx
  8033fc:	5e                   	pop    %esi
  8033fd:	5f                   	pop    %edi
  8033fe:	5d                   	pop    %ebp
  8033ff:	c3                   	ret    
  803400:	39 ce                	cmp    %ecx,%esi
  803402:	77 28                	ja     80342c <__udivdi3+0x7c>
  803404:	0f bd fe             	bsr    %esi,%edi
  803407:	83 f7 1f             	xor    $0x1f,%edi
  80340a:	75 40                	jne    80344c <__udivdi3+0x9c>
  80340c:	39 ce                	cmp    %ecx,%esi
  80340e:	72 0a                	jb     80341a <__udivdi3+0x6a>
  803410:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803414:	0f 87 9e 00 00 00    	ja     8034b8 <__udivdi3+0x108>
  80341a:	b8 01 00 00 00       	mov    $0x1,%eax
  80341f:	89 fa                	mov    %edi,%edx
  803421:	83 c4 1c             	add    $0x1c,%esp
  803424:	5b                   	pop    %ebx
  803425:	5e                   	pop    %esi
  803426:	5f                   	pop    %edi
  803427:	5d                   	pop    %ebp
  803428:	c3                   	ret    
  803429:	8d 76 00             	lea    0x0(%esi),%esi
  80342c:	31 ff                	xor    %edi,%edi
  80342e:	31 c0                	xor    %eax,%eax
  803430:	89 fa                	mov    %edi,%edx
  803432:	83 c4 1c             	add    $0x1c,%esp
  803435:	5b                   	pop    %ebx
  803436:	5e                   	pop    %esi
  803437:	5f                   	pop    %edi
  803438:	5d                   	pop    %ebp
  803439:	c3                   	ret    
  80343a:	66 90                	xchg   %ax,%ax
  80343c:	89 d8                	mov    %ebx,%eax
  80343e:	f7 f7                	div    %edi
  803440:	31 ff                	xor    %edi,%edi
  803442:	89 fa                	mov    %edi,%edx
  803444:	83 c4 1c             	add    $0x1c,%esp
  803447:	5b                   	pop    %ebx
  803448:	5e                   	pop    %esi
  803449:	5f                   	pop    %edi
  80344a:	5d                   	pop    %ebp
  80344b:	c3                   	ret    
  80344c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803451:	89 eb                	mov    %ebp,%ebx
  803453:	29 fb                	sub    %edi,%ebx
  803455:	89 f9                	mov    %edi,%ecx
  803457:	d3 e6                	shl    %cl,%esi
  803459:	89 c5                	mov    %eax,%ebp
  80345b:	88 d9                	mov    %bl,%cl
  80345d:	d3 ed                	shr    %cl,%ebp
  80345f:	89 e9                	mov    %ebp,%ecx
  803461:	09 f1                	or     %esi,%ecx
  803463:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803467:	89 f9                	mov    %edi,%ecx
  803469:	d3 e0                	shl    %cl,%eax
  80346b:	89 c5                	mov    %eax,%ebp
  80346d:	89 d6                	mov    %edx,%esi
  80346f:	88 d9                	mov    %bl,%cl
  803471:	d3 ee                	shr    %cl,%esi
  803473:	89 f9                	mov    %edi,%ecx
  803475:	d3 e2                	shl    %cl,%edx
  803477:	8b 44 24 08          	mov    0x8(%esp),%eax
  80347b:	88 d9                	mov    %bl,%cl
  80347d:	d3 e8                	shr    %cl,%eax
  80347f:	09 c2                	or     %eax,%edx
  803481:	89 d0                	mov    %edx,%eax
  803483:	89 f2                	mov    %esi,%edx
  803485:	f7 74 24 0c          	divl   0xc(%esp)
  803489:	89 d6                	mov    %edx,%esi
  80348b:	89 c3                	mov    %eax,%ebx
  80348d:	f7 e5                	mul    %ebp
  80348f:	39 d6                	cmp    %edx,%esi
  803491:	72 19                	jb     8034ac <__udivdi3+0xfc>
  803493:	74 0b                	je     8034a0 <__udivdi3+0xf0>
  803495:	89 d8                	mov    %ebx,%eax
  803497:	31 ff                	xor    %edi,%edi
  803499:	e9 58 ff ff ff       	jmp    8033f6 <__udivdi3+0x46>
  80349e:	66 90                	xchg   %ax,%ax
  8034a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034a4:	89 f9                	mov    %edi,%ecx
  8034a6:	d3 e2                	shl    %cl,%edx
  8034a8:	39 c2                	cmp    %eax,%edx
  8034aa:	73 e9                	jae    803495 <__udivdi3+0xe5>
  8034ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034af:	31 ff                	xor    %edi,%edi
  8034b1:	e9 40 ff ff ff       	jmp    8033f6 <__udivdi3+0x46>
  8034b6:	66 90                	xchg   %ax,%ax
  8034b8:	31 c0                	xor    %eax,%eax
  8034ba:	e9 37 ff ff ff       	jmp    8033f6 <__udivdi3+0x46>
  8034bf:	90                   	nop

008034c0 <__umoddi3>:
  8034c0:	55                   	push   %ebp
  8034c1:	57                   	push   %edi
  8034c2:	56                   	push   %esi
  8034c3:	53                   	push   %ebx
  8034c4:	83 ec 1c             	sub    $0x1c,%esp
  8034c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034df:	89 f3                	mov    %esi,%ebx
  8034e1:	89 fa                	mov    %edi,%edx
  8034e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034e7:	89 34 24             	mov    %esi,(%esp)
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	75 1a                	jne    803508 <__umoddi3+0x48>
  8034ee:	39 f7                	cmp    %esi,%edi
  8034f0:	0f 86 a2 00 00 00    	jbe    803598 <__umoddi3+0xd8>
  8034f6:	89 c8                	mov    %ecx,%eax
  8034f8:	89 f2                	mov    %esi,%edx
  8034fa:	f7 f7                	div    %edi
  8034fc:	89 d0                	mov    %edx,%eax
  8034fe:	31 d2                	xor    %edx,%edx
  803500:	83 c4 1c             	add    $0x1c,%esp
  803503:	5b                   	pop    %ebx
  803504:	5e                   	pop    %esi
  803505:	5f                   	pop    %edi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    
  803508:	39 f0                	cmp    %esi,%eax
  80350a:	0f 87 ac 00 00 00    	ja     8035bc <__umoddi3+0xfc>
  803510:	0f bd e8             	bsr    %eax,%ebp
  803513:	83 f5 1f             	xor    $0x1f,%ebp
  803516:	0f 84 ac 00 00 00    	je     8035c8 <__umoddi3+0x108>
  80351c:	bf 20 00 00 00       	mov    $0x20,%edi
  803521:	29 ef                	sub    %ebp,%edi
  803523:	89 fe                	mov    %edi,%esi
  803525:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803529:	89 e9                	mov    %ebp,%ecx
  80352b:	d3 e0                	shl    %cl,%eax
  80352d:	89 d7                	mov    %edx,%edi
  80352f:	89 f1                	mov    %esi,%ecx
  803531:	d3 ef                	shr    %cl,%edi
  803533:	09 c7                	or     %eax,%edi
  803535:	89 e9                	mov    %ebp,%ecx
  803537:	d3 e2                	shl    %cl,%edx
  803539:	89 14 24             	mov    %edx,(%esp)
  80353c:	89 d8                	mov    %ebx,%eax
  80353e:	d3 e0                	shl    %cl,%eax
  803540:	89 c2                	mov    %eax,%edx
  803542:	8b 44 24 08          	mov    0x8(%esp),%eax
  803546:	d3 e0                	shl    %cl,%eax
  803548:	89 44 24 04          	mov    %eax,0x4(%esp)
  80354c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803550:	89 f1                	mov    %esi,%ecx
  803552:	d3 e8                	shr    %cl,%eax
  803554:	09 d0                	or     %edx,%eax
  803556:	d3 eb                	shr    %cl,%ebx
  803558:	89 da                	mov    %ebx,%edx
  80355a:	f7 f7                	div    %edi
  80355c:	89 d3                	mov    %edx,%ebx
  80355e:	f7 24 24             	mull   (%esp)
  803561:	89 c6                	mov    %eax,%esi
  803563:	89 d1                	mov    %edx,%ecx
  803565:	39 d3                	cmp    %edx,%ebx
  803567:	0f 82 87 00 00 00    	jb     8035f4 <__umoddi3+0x134>
  80356d:	0f 84 91 00 00 00    	je     803604 <__umoddi3+0x144>
  803573:	8b 54 24 04          	mov    0x4(%esp),%edx
  803577:	29 f2                	sub    %esi,%edx
  803579:	19 cb                	sbb    %ecx,%ebx
  80357b:	89 d8                	mov    %ebx,%eax
  80357d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803581:	d3 e0                	shl    %cl,%eax
  803583:	89 e9                	mov    %ebp,%ecx
  803585:	d3 ea                	shr    %cl,%edx
  803587:	09 d0                	or     %edx,%eax
  803589:	89 e9                	mov    %ebp,%ecx
  80358b:	d3 eb                	shr    %cl,%ebx
  80358d:	89 da                	mov    %ebx,%edx
  80358f:	83 c4 1c             	add    $0x1c,%esp
  803592:	5b                   	pop    %ebx
  803593:	5e                   	pop    %esi
  803594:	5f                   	pop    %edi
  803595:	5d                   	pop    %ebp
  803596:	c3                   	ret    
  803597:	90                   	nop
  803598:	89 fd                	mov    %edi,%ebp
  80359a:	85 ff                	test   %edi,%edi
  80359c:	75 0b                	jne    8035a9 <__umoddi3+0xe9>
  80359e:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a3:	31 d2                	xor    %edx,%edx
  8035a5:	f7 f7                	div    %edi
  8035a7:	89 c5                	mov    %eax,%ebp
  8035a9:	89 f0                	mov    %esi,%eax
  8035ab:	31 d2                	xor    %edx,%edx
  8035ad:	f7 f5                	div    %ebp
  8035af:	89 c8                	mov    %ecx,%eax
  8035b1:	f7 f5                	div    %ebp
  8035b3:	89 d0                	mov    %edx,%eax
  8035b5:	e9 44 ff ff ff       	jmp    8034fe <__umoddi3+0x3e>
  8035ba:	66 90                	xchg   %ax,%ax
  8035bc:	89 c8                	mov    %ecx,%eax
  8035be:	89 f2                	mov    %esi,%edx
  8035c0:	83 c4 1c             	add    $0x1c,%esp
  8035c3:	5b                   	pop    %ebx
  8035c4:	5e                   	pop    %esi
  8035c5:	5f                   	pop    %edi
  8035c6:	5d                   	pop    %ebp
  8035c7:	c3                   	ret    
  8035c8:	3b 04 24             	cmp    (%esp),%eax
  8035cb:	72 06                	jb     8035d3 <__umoddi3+0x113>
  8035cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035d1:	77 0f                	ja     8035e2 <__umoddi3+0x122>
  8035d3:	89 f2                	mov    %esi,%edx
  8035d5:	29 f9                	sub    %edi,%ecx
  8035d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035db:	89 14 24             	mov    %edx,(%esp)
  8035de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035e6:	8b 14 24             	mov    (%esp),%edx
  8035e9:	83 c4 1c             	add    $0x1c,%esp
  8035ec:	5b                   	pop    %ebx
  8035ed:	5e                   	pop    %esi
  8035ee:	5f                   	pop    %edi
  8035ef:	5d                   	pop    %ebp
  8035f0:	c3                   	ret    
  8035f1:	8d 76 00             	lea    0x0(%esi),%esi
  8035f4:	2b 04 24             	sub    (%esp),%eax
  8035f7:	19 fa                	sbb    %edi,%edx
  8035f9:	89 d1                	mov    %edx,%ecx
  8035fb:	89 c6                	mov    %eax,%esi
  8035fd:	e9 71 ff ff ff       	jmp    803573 <__umoddi3+0xb3>
  803602:	66 90                	xchg   %ax,%ax
  803604:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803608:	72 ea                	jb     8035f4 <__umoddi3+0x134>
  80360a:	89 d9                	mov    %ebx,%ecx
  80360c:	e9 62 ff ff ff       	jmp    803573 <__umoddi3+0xb3>
