
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 cf 17 00 00       	call   801805 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 90 01 00 00    	sub    $0x190,%esp
	int envID = sys_getenvid();
  800043:	e8 4a 32 00 00       	call   803292 <sys_getenvid>
  800048:	89 45 e8             	mov    %eax,-0x18(%ebp)

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80004e:	89 d0                	mov    %edx,%eax
  800050:	c1 e0 03             	shl    $0x3,%eax
  800053:	01 d0                	add    %edx,%eax
  800055:	01 c0                	add    %eax,%eax
  800057:	01 d0                	add    %edx,%eax
  800059:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800060:	01 d0                	add    %edx,%eax
  800062:	c1 e0 03             	shl    $0x3,%eax
  800065:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int Mega = 1024*1024;
  80006d:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  800074:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
	char minByte = 1<<7;
  80007b:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
	char maxByte = 0x7F;
  80007f:	c6 45 da 7f          	movb   $0x7f,-0x26(%ebp)
	short minShort = 1<<15 ;
  800083:	66 c7 45 d8 00 80    	movw   $0x8000,-0x28(%ebp)
	short maxShort = 0x7FFF;
  800089:	66 c7 45 d6 ff 7f    	movw   $0x7fff,-0x2a(%ebp)
	int minInt = 1<<31 ;
  80008f:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
	int maxInt = 0x7FFFFFFF;
  800096:	c7 45 cc ff ff ff 7f 	movl   $0x7fffffff,-0x34(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  80009d:	e8 a2 32 00 00       	call   803344 <sys_calculate_free_frames>
  8000a2:	89 45 c8             	mov    %eax,-0x38(%ebp)

	void* ptr_allocations[20] = {0};
  8000a5:	8d 95 68 fe ff ff    	lea    -0x198(%ebp),%edx
  8000ab:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	89 d7                	mov    %edx,%edi
  8000b7:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000b9:	e8 09 33 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8000be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000c9:	83 ec 0c             	sub    $0xc,%esp
  8000cc:	50                   	push   %eax
  8000cd:	e8 a2 26 00 00       	call   802774 <malloc>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8000db:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  8000e1:	85 c0                	test   %eax,%eax
  8000e3:	79 0d                	jns    8000f2 <_main+0xba>
  8000e5:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  8000eb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000f0:	76 14                	jbe    800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 e0 39 80 00       	push   $0x8039e0
  8000fa:	6a 29                	push   $0x29
  8000fc:	68 45 3a 80 00       	push   $0x803a45
  800101:	e8 c0 17 00 00       	call   8018c6 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800106:	e8 bc 32 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  80010b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80010e:	3d 00 02 00 00       	cmp    $0x200,%eax
  800113:	74 14                	je     800129 <_main+0xf1>
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	68 58 3a 80 00       	push   $0x803a58
  80011d:	6a 2a                	push   $0x2a
  80011f:	68 45 3a 80 00       	push   $0x803a45
  800124:	e8 9d 17 00 00       	call   8018c6 <_panic>
		int freeFrames = sys_calculate_free_frames() ;
  800129:	e8 16 32 00 00       	call   803344 <sys_calculate_free_frames>
  80012e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800131:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800134:	01 c0                	add    %eax,%eax
  800136:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800139:	48                   	dec    %eax
  80013a:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80013d:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800143:	89 45 b8             	mov    %eax,-0x48(%ebp)
		byteArr[0] = minByte ;
  800146:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800149:	8a 55 db             	mov    -0x25(%ebp),%dl
  80014c:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80014e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800151:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800154:	01 c2                	add    %eax,%edx
  800156:	8a 45 da             	mov    -0x26(%ebp),%al
  800159:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80015b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80015e:	e8 e1 31 00 00       	call   803344 <sys_calculate_free_frames>
  800163:	29 c3                	sub    %eax,%ebx
  800165:	89 d8                	mov    %ebx,%eax
  800167:	83 f8 03             	cmp    $0x3,%eax
  80016a:	74 14                	je     800180 <_main+0x148>
  80016c:	83 ec 04             	sub    $0x4,%esp
  80016f:	68 88 3a 80 00       	push   $0x803a88
  800174:	6a 30                	push   $0x30
  800176:	68 45 3a 80 00       	push   $0x803a45
  80017b:	e8 46 17 00 00       	call   8018c6 <_panic>
		int var;
		int found = 0;
  800180:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800187:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80018e:	eb 7e                	jmp    80020e <_main+0x1d6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800193:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800199:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80019c:	89 d0                	mov    %edx,%eax
  80019e:	01 c0                	add    %eax,%eax
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	c1 e0 02             	shl    $0x2,%eax
  8001a5:	01 c8                	add    %ecx,%eax
  8001a7:	8b 00                	mov    (%eax),%eax
  8001a9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001ac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 c2                	mov    %eax,%edx
  8001b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b9:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001c4:	39 c2                	cmp    %eax,%edx
  8001c6:	75 03                	jne    8001cb <_main+0x193>
				found++;
  8001c8:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  8001cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ce:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8001d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001d7:	89 d0                	mov    %edx,%eax
  8001d9:	01 c0                	add    %eax,%eax
  8001db:	01 d0                	add    %edx,%eax
  8001dd:	c1 e0 02             	shl    $0x2,%eax
  8001e0:	01 c8                	add    %ecx,%eax
  8001e2:	8b 00                	mov    (%eax),%eax
  8001e4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001e7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ef:	89 c1                	mov    %eax,%ecx
  8001f1:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8001f4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f7:	01 d0                	add    %edx,%eax
  8001f9:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8001fc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800204:	39 c1                	cmp    %eax,%ecx
  800206:	75 03                	jne    80020b <_main+0x1d3>
				found++;
  800208:	ff 45 f0             	incl   -0x10(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80020b:	ff 45 f4             	incl   -0xc(%ebp)
  80020e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800211:	8b 50 74             	mov    0x74(%eax),%edx
  800214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800217:	39 c2                	cmp    %eax,%edx
  800219:	0f 87 71 ff ff ff    	ja     800190 <_main+0x158>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80021f:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 cc 3a 80 00       	push   $0x803acc
  80022d:	6a 3a                	push   $0x3a
  80022f:	68 45 3a 80 00       	push   $0x803a45
  800234:	e8 8d 16 00 00       	call   8018c6 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800239:	e8 89 31 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  80023e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800241:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800244:	01 c0                	add    %eax,%eax
  800246:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	50                   	push   %eax
  80024d:	e8 22 25 00 00       	call   802774 <malloc>
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80025b:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800261:	89 c2                	mov    %eax,%edx
  800263:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800266:	01 c0                	add    %eax,%eax
  800268:	05 00 00 00 80       	add    $0x80000000,%eax
  80026d:	39 c2                	cmp    %eax,%edx
  80026f:	72 16                	jb     800287 <_main+0x24f>
  800271:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800277:	89 c2                	mov    %eax,%edx
  800279:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80027c:	01 c0                	add    %eax,%eax
  80027e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	76 14                	jbe    80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 e0 39 80 00       	push   $0x8039e0
  80028f:	6a 3f                	push   $0x3f
  800291:	68 45 3a 80 00       	push   $0x803a45
  800296:	e8 2b 16 00 00       	call   8018c6 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 27 31 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002a3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 58 3a 80 00       	push   $0x803a58
  8002b2:	6a 40                	push   $0x40
  8002b4:	68 45 3a 80 00       	push   $0x803a45
  8002b9:	e8 08 16 00 00       	call   8018c6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 81 30 00 00       	call   803344 <sys_calculate_free_frames>
  8002c3:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr = (short *) ptr_allocations[1];
  8002c6:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002cc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  8002cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d2:	01 c0                	add    %eax,%eax
  8002d4:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002d7:	d1 e8                	shr    %eax
  8002d9:	48                   	dec    %eax
  8002da:	89 45 a0             	mov    %eax,-0x60(%ebp)
		shortArr[0] = minShort;
  8002dd:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  8002e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e3:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  8002e6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	89 c2                	mov    %eax,%edx
  8002ed:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002f0:	01 c2                	add    %eax,%edx
  8002f2:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  8002f6:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8002f9:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002fc:	e8 43 30 00 00       	call   803344 <sys_calculate_free_frames>
  800301:	29 c3                	sub    %eax,%ebx
  800303:	89 d8                	mov    %ebx,%eax
  800305:	83 f8 02             	cmp    $0x2,%eax
  800308:	74 14                	je     80031e <_main+0x2e6>
  80030a:	83 ec 04             	sub    $0x4,%esp
  80030d:	68 88 3a 80 00       	push   $0x803a88
  800312:	6a 47                	push   $0x47
  800314:	68 45 3a 80 00       	push   $0x803a45
  800319:	e8 a8 15 00 00       	call   8018c6 <_panic>
		found = 0;
  80031e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800325:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80032c:	e9 82 00 00 00       	jmp    8003b3 <_main+0x37b>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800334:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  80033a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80033d:	89 d0                	mov    %edx,%eax
  80033f:	01 c0                	add    %eax,%eax
  800341:	01 d0                	add    %edx,%eax
  800343:	c1 e0 02             	shl    $0x2,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	8b 00                	mov    (%eax),%eax
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800355:	89 c2                	mov    %eax,%edx
  800357:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80035a:	89 45 98             	mov    %eax,-0x68(%ebp)
  80035d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800360:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800365:	39 c2                	cmp    %eax,%edx
  800367:	75 03                	jne    80036c <_main+0x334>
				found++;
  800369:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80036c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80036f:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800375:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800378:	89 d0                	mov    %edx,%eax
  80037a:	01 c0                	add    %eax,%eax
  80037c:	01 d0                	add    %edx,%eax
  80037e:	c1 e0 02             	shl    $0x2,%eax
  800381:	01 c8                	add    %ecx,%eax
  800383:	8b 00                	mov    (%eax),%eax
  800385:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800388:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80038b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800390:	89 c2                	mov    %eax,%edx
  800392:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800395:	01 c0                	add    %eax,%eax
  800397:	89 c1                	mov    %eax,%ecx
  800399:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039c:	01 c8                	add    %ecx,%eax
  80039e:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003a1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	75 03                	jne    8003b0 <_main+0x378>
				found++;
  8003ad:	ff 45 f0             	incl   -0x10(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003b0:	ff 45 f4             	incl   -0xc(%ebp)
  8003b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b6:	8b 50 74             	mov    0x74(%eax),%edx
  8003b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003bc:	39 c2                	cmp    %eax,%edx
  8003be:	0f 87 6d ff ff ff    	ja     800331 <_main+0x2f9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8003c4:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8003c8:	74 14                	je     8003de <_main+0x3a6>
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	68 cc 3a 80 00       	push   $0x803acc
  8003d2:	6a 50                	push   $0x50
  8003d4:	68 45 3a 80 00       	push   $0x803a45
  8003d9:	e8 e8 14 00 00       	call   8018c6 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003de:	e8 e4 2f 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8003e3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8003e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e9:	01 c0                	add    %eax,%eax
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	50                   	push   %eax
  8003ef:	e8 80 23 00 00       	call   802774 <malloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8003fd:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  800403:	89 c2                	mov    %eax,%edx
  800405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800408:	c1 e0 02             	shl    $0x2,%eax
  80040b:	05 00 00 00 80       	add    $0x80000000,%eax
  800410:	39 c2                	cmp    %eax,%edx
  800412:	72 17                	jb     80042b <_main+0x3f3>
  800414:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80041a:	89 c2                	mov    %eax,%edx
  80041c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041f:	c1 e0 02             	shl    $0x2,%eax
  800422:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800427:	39 c2                	cmp    %eax,%edx
  800429:	76 14                	jbe    80043f <_main+0x407>
  80042b:	83 ec 04             	sub    $0x4,%esp
  80042e:	68 e0 39 80 00       	push   $0x8039e0
  800433:	6a 55                	push   $0x55
  800435:	68 45 3a 80 00       	push   $0x803a45
  80043a:	e8 87 14 00 00       	call   8018c6 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  80043f:	e8 83 2f 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800444:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800447:	83 f8 01             	cmp    $0x1,%eax
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 58 3a 80 00       	push   $0x803a58
  800454:	6a 56                	push   $0x56
  800456:	68 45 3a 80 00       	push   $0x803a45
  80045b:	e8 66 14 00 00       	call   8018c6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 df 2e 00 00       	call   803344 <sys_calculate_free_frames>
  800465:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int *) ptr_allocations[2];
  800468:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80046e:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800471:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800474:	01 c0                	add    %eax,%eax
  800476:	c1 e8 02             	shr    $0x2,%eax
  800479:	48                   	dec    %eax
  80047a:	89 45 88             	mov    %eax,-0x78(%ebp)
		intArr[0] = minInt;
  80047d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800480:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800483:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800485:	8b 45 88             	mov    -0x78(%ebp),%eax
  800488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800492:	01 c2                	add    %eax,%edx
  800494:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800497:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800499:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80049c:	e8 a3 2e 00 00       	call   803344 <sys_calculate_free_frames>
  8004a1:	29 c3                	sub    %eax,%ebx
  8004a3:	89 d8                	mov    %ebx,%eax
  8004a5:	83 f8 02             	cmp    $0x2,%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 88 3a 80 00       	push   $0x803a88
  8004b2:	6a 5d                	push   $0x5d
  8004b4:	68 45 3a 80 00       	push   $0x803a45
  8004b9:	e8 08 14 00 00       	call   8018c6 <_panic>
		found = 0;
  8004be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8004c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004cc:	e9 91 00 00 00       	jmp    800562 <_main+0x52a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  8004d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d4:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8004da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 02             	shl    $0x2,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8004ed:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8004f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004f5:	89 c2                	mov    %eax,%edx
  8004f7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004fa:	89 45 80             	mov    %eax,-0x80(%ebp)
  8004fd:	8b 45 80             	mov    -0x80(%ebp),%eax
  800500:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800505:	39 c2                	cmp    %eax,%edx
  800507:	75 03                	jne    80050c <_main+0x4d4>
				found++;
  800509:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  80050c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80050f:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800515:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 02             	shl    $0x2,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8b 00                	mov    (%eax),%eax
  800525:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80052b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800531:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800536:	89 c2                	mov    %eax,%edx
  800538:	8b 45 88             	mov    -0x78(%ebp),%eax
  80053b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800542:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800545:	01 c8                	add    %ecx,%eax
  800547:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  80054d:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800553:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800558:	39 c2                	cmp    %eax,%edx
  80055a:	75 03                	jne    80055f <_main+0x527>
				found++;
  80055c:	ff 45 f0             	incl   -0x10(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80055f:	ff 45 f4             	incl   -0xc(%ebp)
  800562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800565:	8b 50 74             	mov    0x74(%eax),%edx
  800568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80056b:	39 c2                	cmp    %eax,%edx
  80056d:	0f 87 5e ff ff ff    	ja     8004d1 <_main+0x499>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800573:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800577:	74 14                	je     80058d <_main+0x555>
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 cc 3a 80 00       	push   $0x803acc
  800581:	6a 66                	push   $0x66
  800583:	68 45 3a 80 00       	push   $0x803a45
  800588:	e8 39 13 00 00       	call   8018c6 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80058d:	e8 b2 2d 00 00       	call   803344 <sys_calculate_free_frames>
  800592:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800595:	e8 2d 2e 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  80059a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  80059d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005a0:	01 c0                	add    %eax,%eax
  8005a2:	83 ec 0c             	sub    $0xc,%esp
  8005a5:	50                   	push   %eax
  8005a6:	e8 c9 21 00 00       	call   802774 <malloc>
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005b4:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  8005ba:	89 c2                	mov    %eax,%edx
  8005bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005bf:	c1 e0 02             	shl    $0x2,%eax
  8005c2:	89 c1                	mov    %eax,%ecx
  8005c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c7:	c1 e0 02             	shl    $0x2,%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	05 00 00 00 80       	add    $0x80000000,%eax
  8005d1:	39 c2                	cmp    %eax,%edx
  8005d3:	72 21                	jb     8005f6 <_main+0x5be>
  8005d5:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  8005db:	89 c2                	mov    %eax,%edx
  8005dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e0:	c1 e0 02             	shl    $0x2,%eax
  8005e3:	89 c1                	mov    %eax,%ecx
  8005e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005e8:	c1 e0 02             	shl    $0x2,%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8005f2:	39 c2                	cmp    %eax,%edx
  8005f4:	76 14                	jbe    80060a <_main+0x5d2>
  8005f6:	83 ec 04             	sub    $0x4,%esp
  8005f9:	68 e0 39 80 00       	push   $0x8039e0
  8005fe:	6a 6c                	push   $0x6c
  800600:	68 45 3a 80 00       	push   $0x803a45
  800605:	e8 bc 12 00 00       	call   8018c6 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  80060a:	e8 b8 2d 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  80060f:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800612:	83 f8 01             	cmp    $0x1,%eax
  800615:	74 14                	je     80062b <_main+0x5f3>
  800617:	83 ec 04             	sub    $0x4,%esp
  80061a:	68 58 3a 80 00       	push   $0x803a58
  80061f:	6a 6d                	push   $0x6d
  800621:	68 45 3a 80 00       	push   $0x803a45
  800626:	e8 9b 12 00 00       	call   8018c6 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80062b:	e8 97 2d 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800630:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800633:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800636:	89 d0                	mov    %edx,%eax
  800638:	01 c0                	add    %eax,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	01 c0                	add    %eax,%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	83 ec 0c             	sub    $0xc,%esp
  800643:	50                   	push   %eax
  800644:	e8 2b 21 00 00       	call   802774 <malloc>
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800652:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800658:	89 c2                	mov    %eax,%edx
  80065a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065d:	c1 e0 02             	shl    $0x2,%eax
  800660:	89 c1                	mov    %eax,%ecx
  800662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800665:	c1 e0 03             	shl    $0x3,%eax
  800668:	01 c8                	add    %ecx,%eax
  80066a:	05 00 00 00 80       	add    $0x80000000,%eax
  80066f:	39 c2                	cmp    %eax,%edx
  800671:	72 21                	jb     800694 <_main+0x65c>
  800673:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800679:	89 c2                	mov    %eax,%edx
  80067b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067e:	c1 e0 02             	shl    $0x2,%eax
  800681:	89 c1                	mov    %eax,%ecx
  800683:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800686:	c1 e0 03             	shl    $0x3,%eax
  800689:	01 c8                	add    %ecx,%eax
  80068b:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	76 14                	jbe    8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 e0 39 80 00       	push   $0x8039e0
  80069c:	6a 73                	push   $0x73
  80069e:	68 45 3a 80 00       	push   $0x803a45
  8006a3:	e8 1e 12 00 00       	call   8018c6 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  8006a8:	e8 1a 2d 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8006ad:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8006b0:	83 f8 02             	cmp    $0x2,%eax
  8006b3:	74 14                	je     8006c9 <_main+0x691>
  8006b5:	83 ec 04             	sub    $0x4,%esp
  8006b8:	68 58 3a 80 00       	push   $0x803a58
  8006bd:	6a 74                	push   $0x74
  8006bf:	68 45 3a 80 00       	push   $0x803a45
  8006c4:	e8 fd 11 00 00       	call   8018c6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8006c9:	e8 76 2c 00 00       	call   803344 <sys_calculate_free_frames>
  8006ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  8006d1:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006d7:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8006dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006e0:	89 d0                	mov    %edx,%eax
  8006e2:	01 c0                	add    %eax,%eax
  8006e4:	01 d0                	add    %edx,%eax
  8006e6:	01 c0                	add    %eax,%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	c1 e8 03             	shr    $0x3,%eax
  8006ed:	48                   	dec    %eax
  8006ee:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8006f4:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006fa:	8a 55 db             	mov    -0x25(%ebp),%dl
  8006fd:	88 10                	mov    %dl,(%eax)
  8006ff:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  800705:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800708:	66 89 42 02          	mov    %ax,0x2(%edx)
  80070c:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800712:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800715:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800718:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80071e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800725:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80072b:	01 c2                	add    %eax,%edx
  80072d:	8a 45 da             	mov    -0x26(%ebp),%al
  800730:	88 02                	mov    %al,(%edx)
  800732:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800738:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80073f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800745:	01 c2                	add    %eax,%edx
  800747:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  80074b:	66 89 42 02          	mov    %ax,0x2(%edx)
  80074f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800755:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80075c:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800762:	01 c2                	add    %eax,%edx
  800764:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800767:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80076a:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80076d:	e8 d2 2b 00 00       	call   803344 <sys_calculate_free_frames>
  800772:	29 c3                	sub    %eax,%ebx
  800774:	89 d8                	mov    %ebx,%eax
  800776:	83 f8 02             	cmp    $0x2,%eax
  800779:	74 14                	je     80078f <_main+0x757>
  80077b:	83 ec 04             	sub    $0x4,%esp
  80077e:	68 88 3a 80 00       	push   $0x803a88
  800783:	6a 7b                	push   $0x7b
  800785:	68 45 3a 80 00       	push   $0x803a45
  80078a:	e8 37 11 00 00       	call   8018c6 <_panic>
		found = 0;
  80078f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800796:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80079d:	e9 a6 00 00 00       	jmp    800848 <_main+0x810>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007a5:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8007ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ae:	89 d0                	mov    %edx,%eax
  8007b0:	01 c0                	add    %eax,%eax
  8007b2:	01 d0                	add    %edx,%eax
  8007b4:	c1 e0 02             	shl    $0x2,%eax
  8007b7:	01 c8                	add    %ecx,%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8007c1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007cc:	89 c2                	mov    %eax,%edx
  8007ce:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007d4:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  8007da:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8007e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	75 03                	jne    8007ec <_main+0x7b4>
				found++;
  8007e9:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  8007ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ef:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8007f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f8:	89 d0                	mov    %edx,%eax
  8007fa:	01 c0                	add    %eax,%eax
  8007fc:	01 d0                	add    %edx,%eax
  8007fe:	c1 e0 02             	shl    $0x2,%eax
  800801:	01 c8                	add    %ecx,%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80080b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800811:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80081e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800825:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80082b:	01 c8                	add    %ecx,%eax
  80082d:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800833:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800839:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083e:	39 c2                	cmp    %eax,%edx
  800840:	75 03                	jne    800845 <_main+0x80d>
				found++;
  800842:	ff 45 f0             	incl   -0x10(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800845:	ff 45 f4             	incl   -0xc(%ebp)
  800848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80084b:	8b 50 74             	mov    0x74(%eax),%edx
  80084e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800851:	39 c2                	cmp    %eax,%edx
  800853:	0f 87 49 ff ff ff    	ja     8007a2 <_main+0x76a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800859:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  80085d:	74 17                	je     800876 <_main+0x83e>
  80085f:	83 ec 04             	sub    $0x4,%esp
  800862:	68 cc 3a 80 00       	push   $0x803acc
  800867:	68 84 00 00 00       	push   $0x84
  80086c:	68 45 3a 80 00       	push   $0x803a45
  800871:	e8 50 10 00 00       	call   8018c6 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 c9 2a 00 00       	call   803344 <sys_calculate_free_frames>
  80087b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80087e:	e8 44 2b 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800883:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800886:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800889:	89 c2                	mov    %eax,%edx
  80088b:	01 d2                	add    %edx,%edx
  80088d:	01 d0                	add    %edx,%eax
  80088f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	50                   	push   %eax
  800896:	e8 d9 1e 00 00       	call   802774 <malloc>
  80089b:	83 c4 10             	add    $0x10,%esp
  80089e:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008a4:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8008aa:	89 c2                	mov    %eax,%edx
  8008ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008af:	c1 e0 02             	shl    $0x2,%eax
  8008b2:	89 c1                	mov    %eax,%ecx
  8008b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b7:	c1 e0 04             	shl    $0x4,%eax
  8008ba:	01 c8                	add    %ecx,%eax
  8008bc:	05 00 00 00 80       	add    $0x80000000,%eax
  8008c1:	39 c2                	cmp    %eax,%edx
  8008c3:	72 21                	jb     8008e6 <_main+0x8ae>
  8008c5:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8008cb:	89 c2                	mov    %eax,%edx
  8008cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d0:	c1 e0 02             	shl    $0x2,%eax
  8008d3:	89 c1                	mov    %eax,%ecx
  8008d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d8:	c1 e0 04             	shl    $0x4,%eax
  8008db:	01 c8                	add    %ecx,%eax
  8008dd:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8008e2:	39 c2                	cmp    %eax,%edx
  8008e4:	76 17                	jbe    8008fd <_main+0x8c5>
  8008e6:	83 ec 04             	sub    $0x4,%esp
  8008e9:	68 e0 39 80 00       	push   $0x8039e0
  8008ee:	68 8a 00 00 00       	push   $0x8a
  8008f3:	68 45 3a 80 00       	push   $0x803a45
  8008f8:	e8 c9 0f 00 00       	call   8018c6 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8008fd:	e8 c5 2a 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800902:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800905:	89 c2                	mov    %eax,%edx
  800907:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090a:	89 c1                	mov    %eax,%ecx
  80090c:	01 c9                	add    %ecx,%ecx
  80090e:	01 c8                	add    %ecx,%eax
  800910:	85 c0                	test   %eax,%eax
  800912:	79 05                	jns    800919 <_main+0x8e1>
  800914:	05 ff 0f 00 00       	add    $0xfff,%eax
  800919:	c1 f8 0c             	sar    $0xc,%eax
  80091c:	39 c2                	cmp    %eax,%edx
  80091e:	74 17                	je     800937 <_main+0x8ff>
  800920:	83 ec 04             	sub    $0x4,%esp
  800923:	68 58 3a 80 00       	push   $0x803a58
  800928:	68 8b 00 00 00       	push   $0x8b
  80092d:	68 45 3a 80 00       	push   $0x803a45
  800932:	e8 8f 0f 00 00       	call   8018c6 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800937:	e8 8b 2a 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  80093c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80093f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800942:	89 d0                	mov    %edx,%eax
  800944:	01 c0                	add    %eax,%eax
  800946:	01 d0                	add    %edx,%eax
  800948:	01 c0                	add    %eax,%eax
  80094a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80094d:	83 ec 0c             	sub    $0xc,%esp
  800950:	50                   	push   %eax
  800951:	e8 1e 1e 00 00       	call   802774 <malloc>
  800956:	83 c4 10             	add    $0x10,%esp
  800959:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80095f:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800965:	89 c1                	mov    %eax,%ecx
  800967:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80096a:	89 d0                	mov    %edx,%eax
  80096c:	01 c0                	add    %eax,%eax
  80096e:	01 d0                	add    %edx,%eax
  800970:	01 c0                	add    %eax,%eax
  800972:	01 d0                	add    %edx,%eax
  800974:	89 c2                	mov    %eax,%edx
  800976:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800979:	c1 e0 04             	shl    $0x4,%eax
  80097c:	01 d0                	add    %edx,%eax
  80097e:	05 00 00 00 80       	add    $0x80000000,%eax
  800983:	39 c1                	cmp    %eax,%ecx
  800985:	72 28                	jb     8009af <_main+0x977>
  800987:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  80098d:	89 c1                	mov    %eax,%ecx
  80098f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800992:	89 d0                	mov    %edx,%eax
  800994:	01 c0                	add    %eax,%eax
  800996:	01 d0                	add    %edx,%eax
  800998:	01 c0                	add    %eax,%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	89 c2                	mov    %eax,%edx
  80099e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009a1:	c1 e0 04             	shl    $0x4,%eax
  8009a4:	01 d0                	add    %edx,%eax
  8009a6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009ab:	39 c1                	cmp    %eax,%ecx
  8009ad:	76 17                	jbe    8009c6 <_main+0x98e>
  8009af:	83 ec 04             	sub    $0x4,%esp
  8009b2:	68 e0 39 80 00       	push   $0x8039e0
  8009b7:	68 91 00 00 00       	push   $0x91
  8009bc:	68 45 3a 80 00       	push   $0x803a45
  8009c1:	e8 00 0f 00 00       	call   8018c6 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8009c6:	e8 fc 29 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8009cb:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8009ce:	89 c1                	mov    %eax,%ecx
  8009d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d3:	89 d0                	mov    %edx,%eax
  8009d5:	01 c0                	add    %eax,%eax
  8009d7:	01 d0                	add    %edx,%eax
  8009d9:	01 c0                	add    %eax,%eax
  8009db:	85 c0                	test   %eax,%eax
  8009dd:	79 05                	jns    8009e4 <_main+0x9ac>
  8009df:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009e4:	c1 f8 0c             	sar    $0xc,%eax
  8009e7:	39 c1                	cmp    %eax,%ecx
  8009e9:	74 17                	je     800a02 <_main+0x9ca>
  8009eb:	83 ec 04             	sub    $0x4,%esp
  8009ee:	68 58 3a 80 00       	push   $0x803a58
  8009f3:	68 92 00 00 00       	push   $0x92
  8009f8:	68 45 3a 80 00       	push   $0x803a45
  8009fd:	e8 c4 0e 00 00       	call   8018c6 <_panic>
		freeFrames = sys_calculate_free_frames() ;
  800a02:	e8 3d 29 00 00       	call   803344 <sys_calculate_free_frames>
  800a07:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	01 c0                	add    %eax,%eax
  800a11:	01 d0                	add    %edx,%eax
  800a13:	01 c0                	add    %eax,%eax
  800a15:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a18:	48                   	dec    %eax
  800a19:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a1f:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800a25:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		byteArr2[0] = minByte ;
  800a2b:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a31:	8a 55 db             	mov    -0x25(%ebp),%dl
  800a34:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a36:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a3c:	89 c2                	mov    %eax,%edx
  800a3e:	c1 ea 1f             	shr    $0x1f,%edx
  800a41:	01 d0                	add    %edx,%eax
  800a43:	d1 f8                	sar    %eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a4d:	01 c2                	add    %eax,%edx
  800a4f:	8a 45 da             	mov    -0x26(%ebp),%al
  800a52:	88 c1                	mov    %al,%cl
  800a54:	c0 e9 07             	shr    $0x7,%cl
  800a57:	01 c8                	add    %ecx,%eax
  800a59:	d0 f8                	sar    %al
  800a5b:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a5d:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800a63:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a69:	01 c2                	add    %eax,%edx
  800a6b:	8a 45 da             	mov    -0x26(%ebp),%al
  800a6e:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a70:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800a73:	e8 cc 28 00 00       	call   803344 <sys_calculate_free_frames>
  800a78:	29 c3                	sub    %eax,%ebx
  800a7a:	89 d8                	mov    %ebx,%eax
  800a7c:	83 f8 05             	cmp    $0x5,%eax
  800a7f:	74 17                	je     800a98 <_main+0xa60>
  800a81:	83 ec 04             	sub    $0x4,%esp
  800a84:	68 88 3a 80 00       	push   $0x803a88
  800a89:	68 99 00 00 00       	push   $0x99
  800a8e:	68 45 3a 80 00       	push   $0x803a45
  800a93:	e8 2e 0e 00 00       	call   8018c6 <_panic>
		found = 0;
  800a98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800aa6:	e9 fc 00 00 00       	jmp    800ba7 <_main+0xb6f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800aab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800aae:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab7:	89 d0                	mov    %edx,%eax
  800ab9:	01 c0                	add    %eax,%eax
  800abb:	01 d0                	add    %edx,%eax
  800abd:	c1 e0 02             	shl    $0x2,%eax
  800ac0:	01 c8                	add    %ecx,%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800aca:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800ad0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800add:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800ae3:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800ae9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800aee:	39 c2                	cmp    %eax,%edx
  800af0:	75 03                	jne    800af5 <_main+0xabd>
				found++;
  800af2:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800af8:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800afe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b01:	89 d0                	mov    %edx,%eax
  800b03:	01 c0                	add    %eax,%eax
  800b05:	01 d0                	add    %edx,%eax
  800b07:	c1 e0 02             	shl    $0x2,%eax
  800b0a:	01 c8                	add    %ecx,%eax
  800b0c:	8b 00                	mov    (%eax),%eax
  800b0e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b14:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b1f:	89 c2                	mov    %eax,%edx
  800b21:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b27:	89 c1                	mov    %eax,%ecx
  800b29:	c1 e9 1f             	shr    $0x1f,%ecx
  800b2c:	01 c8                	add    %ecx,%eax
  800b2e:	d1 f8                	sar    %eax
  800b30:	89 c1                	mov    %eax,%ecx
  800b32:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b38:	01 c8                	add    %ecx,%eax
  800b3a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b40:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b4b:	39 c2                	cmp    %eax,%edx
  800b4d:	75 03                	jne    800b52 <_main+0xb1a>
				found++;
  800b4f:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b55:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5e:	89 d0                	mov    %edx,%eax
  800b60:	01 c0                	add    %eax,%eax
  800b62:	01 d0                	add    %edx,%eax
  800b64:	c1 e0 02             	shl    $0x2,%eax
  800b67:	01 c8                	add    %ecx,%eax
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800b71:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800b77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b7c:	89 c1                	mov    %eax,%ecx
  800b7e:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800b84:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b8a:	01 d0                	add    %edx,%eax
  800b8c:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800b92:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800b98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b9d:	39 c1                	cmp    %eax,%ecx
  800b9f:	75 03                	jne    800ba4 <_main+0xb6c>
				found++;
  800ba1:	ff 45 f0             	incl   -0x10(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ba4:	ff 45 f4             	incl   -0xc(%ebp)
  800ba7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800baa:	8b 50 74             	mov    0x74(%eax),%edx
  800bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	0f 87 f3 fe ff ff    	ja     800aab <_main+0xa73>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bb8:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800bbc:	74 17                	je     800bd5 <_main+0xb9d>
  800bbe:	83 ec 04             	sub    $0x4,%esp
  800bc1:	68 cc 3a 80 00       	push   $0x803acc
  800bc6:	68 a4 00 00 00       	push   $0xa4
  800bcb:	68 45 3a 80 00       	push   $0x803a45
  800bd0:	e8 f1 0c 00 00       	call   8018c6 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd5:	e8 ed 27 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800bda:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800bdd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800be0:	89 d0                	mov    %edx,%eax
  800be2:	01 c0                	add    %eax,%eax
  800be4:	01 d0                	add    %edx,%eax
  800be6:	01 c0                	add    %eax,%eax
  800be8:	01 d0                	add    %edx,%eax
  800bea:	01 c0                	add    %eax,%eax
  800bec:	83 ec 0c             	sub    $0xc,%esp
  800bef:	50                   	push   %eax
  800bf0:	e8 7f 1b 00 00       	call   802774 <malloc>
  800bf5:	83 c4 10             	add    $0x10,%esp
  800bf8:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bfe:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c04:	89 c1                	mov    %eax,%ecx
  800c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	c1 e0 02             	shl    $0x2,%eax
  800c12:	01 d0                	add    %edx,%eax
  800c14:	89 c2                	mov    %eax,%edx
  800c16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c19:	c1 e0 04             	shl    $0x4,%eax
  800c1c:	01 d0                	add    %edx,%eax
  800c1e:	05 00 00 00 80       	add    $0x80000000,%eax
  800c23:	39 c1                	cmp    %eax,%ecx
  800c25:	72 29                	jb     800c50 <_main+0xc18>
  800c27:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c2d:	89 c1                	mov    %eax,%ecx
  800c2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	01 c0                	add    %eax,%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c42:	c1 e0 04             	shl    $0x4,%eax
  800c45:	01 d0                	add    %edx,%eax
  800c47:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c4c:	39 c1                	cmp    %eax,%ecx
  800c4e:	76 17                	jbe    800c67 <_main+0xc2f>
  800c50:	83 ec 04             	sub    $0x4,%esp
  800c53:	68 e0 39 80 00       	push   $0x8039e0
  800c58:	68 a9 00 00 00       	push   $0xa9
  800c5d:	68 45 3a 80 00       	push   $0x803a45
  800c62:	e8 5f 0c 00 00       	call   8018c6 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  800c67:	e8 5b 27 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800c6c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800c6f:	83 f8 04             	cmp    $0x4,%eax
  800c72:	74 17                	je     800c8b <_main+0xc53>
  800c74:	83 ec 04             	sub    $0x4,%esp
  800c77:	68 58 3a 80 00       	push   $0x803a58
  800c7c:	68 aa 00 00 00       	push   $0xaa
  800c81:	68 45 3a 80 00       	push   $0x803a45
  800c86:	e8 3b 0c 00 00       	call   8018c6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c8b:	e8 b4 26 00 00       	call   803344 <sys_calculate_free_frames>
  800c90:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800c93:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c99:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800c9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800ca2:	89 d0                	mov    %edx,%eax
  800ca4:	01 c0                	add    %eax,%eax
  800ca6:	01 d0                	add    %edx,%eax
  800ca8:	01 c0                	add    %eax,%eax
  800caa:	01 d0                	add    %edx,%eax
  800cac:	01 c0                	add    %eax,%eax
  800cae:	d1 e8                	shr    %eax
  800cb0:	48                   	dec    %eax
  800cb1:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
		shortArr2[0] = minShort;
  800cb7:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800cbd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cc0:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800cc3:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800cc9:	01 c0                	add    %eax,%eax
  800ccb:	89 c2                	mov    %eax,%edx
  800ccd:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cd3:	01 c2                	add    %eax,%edx
  800cd5:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800cd9:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800cdc:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800cdf:	e8 60 26 00 00       	call   803344 <sys_calculate_free_frames>
  800ce4:	29 c3                	sub    %eax,%ebx
  800ce6:	89 d8                	mov    %ebx,%eax
  800ce8:	83 f8 02             	cmp    $0x2,%eax
  800ceb:	74 17                	je     800d04 <_main+0xccc>
  800ced:	83 ec 04             	sub    $0x4,%esp
  800cf0:	68 88 3a 80 00       	push   $0x803a88
  800cf5:	68 b1 00 00 00       	push   $0xb1
  800cfa:	68 45 3a 80 00       	push   $0x803a45
  800cff:	e8 c2 0b 00 00       	call   8018c6 <_panic>
		found = 0;
  800d04:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d12:	e9 a3 00 00 00       	jmp    800dba <_main+0xd82>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d1a:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d23:	89 d0                	mov    %edx,%eax
  800d25:	01 c0                	add    %eax,%eax
  800d27:	01 d0                	add    %edx,%eax
  800d29:	c1 e0 02             	shl    $0x2,%eax
  800d2c:	01 c8                	add    %ecx,%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d36:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d41:	89 c2                	mov    %eax,%edx
  800d43:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d49:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d4f:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d55:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d5a:	39 c2                	cmp    %eax,%edx
  800d5c:	75 03                	jne    800d61 <_main+0xd29>
				found++;
  800d5e:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d64:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800d6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d6d:	89 d0                	mov    %edx,%eax
  800d6f:	01 c0                	add    %eax,%eax
  800d71:	01 d0                	add    %edx,%eax
  800d73:	c1 e0 02             	shl    $0x2,%eax
  800d76:	01 c8                	add    %ecx,%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800d80:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800d86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d8b:	89 c2                	mov    %eax,%edx
  800d8d:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d93:	01 c0                	add    %eax,%eax
  800d95:	89 c1                	mov    %eax,%ecx
  800d97:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d9d:	01 c8                	add    %ecx,%eax
  800d9f:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800da5:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800dab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db0:	39 c2                	cmp    %eax,%edx
  800db2:	75 03                	jne    800db7 <_main+0xd7f>
				found++;
  800db4:	ff 45 f0             	incl   -0x10(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800db7:	ff 45 f4             	incl   -0xc(%ebp)
  800dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800dbd:	8b 50 74             	mov    0x74(%eax),%edx
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc3:	39 c2                	cmp    %eax,%edx
  800dc5:	0f 87 4c ff ff ff    	ja     800d17 <_main+0xcdf>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800dcb:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800dcf:	74 17                	je     800de8 <_main+0xdb0>
  800dd1:	83 ec 04             	sub    $0x4,%esp
  800dd4:	68 cc 3a 80 00       	push   $0x803acc
  800dd9:	68 ba 00 00 00       	push   $0xba
  800dde:	68 45 3a 80 00       	push   $0x803a45
  800de3:	e8 de 0a 00 00       	call   8018c6 <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800de8:	e8 57 25 00 00       	call   803344 <sys_calculate_free_frames>
  800ded:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800df3:	e8 cf 25 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800df8:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800dfe:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	e8 09 23 00 00       	call   803116 <free>
  800e0d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e10:	e8 b2 25 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800e15:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  800e1b:	29 c2                	sub    %eax,%edx
  800e1d:	89 d0                	mov    %edx,%eax
  800e1f:	3d 00 02 00 00       	cmp    $0x200,%eax
  800e24:	74 17                	je     800e3d <_main+0xe05>
  800e26:	83 ec 04             	sub    $0x4,%esp
  800e29:	68 ec 3a 80 00       	push   $0x803aec
  800e2e:	68 c2 00 00 00       	push   $0xc2
  800e33:	68 45 3a 80 00       	push   $0x803a45
  800e38:	e8 89 0a 00 00       	call   8018c6 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e3d:	e8 02 25 00 00       	call   803344 <sys_calculate_free_frames>
  800e42:	89 c2                	mov    %eax,%edx
  800e44:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e4a:	29 c2                	sub    %eax,%edx
  800e4c:	89 d0                	mov    %edx,%eax
  800e4e:	83 f8 02             	cmp    $0x2,%eax
  800e51:	74 17                	je     800e6a <_main+0xe32>
  800e53:	83 ec 04             	sub    $0x4,%esp
  800e56:	68 28 3b 80 00       	push   $0x803b28
  800e5b:	68 c3 00 00 00       	push   $0xc3
  800e60:	68 45 3a 80 00       	push   $0x803a45
  800e65:	e8 5c 0a 00 00       	call   8018c6 <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800e71:	e9 be 00 00 00       	jmp    800f34 <_main+0xefc>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e79:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800e7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e82:	89 d0                	mov    %edx,%eax
  800e84:	01 c0                	add    %eax,%eax
  800e86:	01 d0                	add    %edx,%eax
  800e88:	c1 e0 02             	shl    $0x2,%eax
  800e8b:	01 c8                	add    %ecx,%eax
  800e8d:	8b 00                	mov    (%eax),%eax
  800e8f:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800e95:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800e9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ea0:	89 c2                	mov    %eax,%edx
  800ea2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ea5:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800eab:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800eb1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eb6:	39 c2                	cmp    %eax,%edx
  800eb8:	75 17                	jne    800ed1 <_main+0xe99>
				panic("free: page is not removed from WS");
  800eba:	83 ec 04             	sub    $0x4,%esp
  800ebd:	68 74 3b 80 00       	push   $0x803b74
  800ec2:	68 c8 00 00 00       	push   $0xc8
  800ec7:	68 45 3a 80 00       	push   $0x803a45
  800ecc:	e8 f5 09 00 00       	call   8018c6 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800ed1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ed4:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800eda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800edd:	89 d0                	mov    %edx,%eax
  800edf:	01 c0                	add    %eax,%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	c1 e0 02             	shl    $0x2,%eax
  800ee6:	01 c8                	add    %ecx,%eax
  800ee8:	8b 00                	mov    (%eax),%eax
  800eea:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800ef0:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800ef6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800efb:	89 c1                	mov    %eax,%ecx
  800efd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800f00:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f03:	01 d0                	add    %edx,%eax
  800f05:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800f0b:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800f11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f16:	39 c1                	cmp    %eax,%ecx
  800f18:	75 17                	jne    800f31 <_main+0xef9>
				panic("free: page is not removed from WS");
  800f1a:	83 ec 04             	sub    $0x4,%esp
  800f1d:	68 74 3b 80 00       	push   $0x803b74
  800f22:	68 ca 00 00 00       	push   $0xca
  800f27:	68 45 3a 80 00       	push   $0x803a45
  800f2c:	e8 95 09 00 00       	call   8018c6 <_panic>
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[0]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800f31:	ff 45 ec             	incl   -0x14(%ebp)
  800f34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f37:	8b 50 74             	mov    0x74(%eax),%edx
  800f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f3d:	39 c2                	cmp    %eax,%edx
  800f3f:	0f 87 31 ff ff ff    	ja     800e76 <_main+0xe3e>
				panic("free: page is not removed from WS");
		}


		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800f45:	e8 fa 23 00 00       	call   803344 <sys_calculate_free_frames>
  800f4a:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f50:	e8 72 24 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800f55:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f5b:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f61:	83 ec 0c             	sub    $0xc,%esp
  800f64:	50                   	push   %eax
  800f65:	e8 ac 21 00 00       	call   803116 <free>
  800f6a:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f6d:	e8 55 24 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  800f72:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  800f78:	29 c2                	sub    %eax,%edx
  800f7a:	89 d0                	mov    %edx,%eax
  800f7c:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f81:	74 17                	je     800f9a <_main+0xf62>
  800f83:	83 ec 04             	sub    $0x4,%esp
  800f86:	68 ec 3a 80 00       	push   $0x803aec
  800f8b:	68 d2 00 00 00       	push   $0xd2
  800f90:	68 45 3a 80 00       	push   $0x803a45
  800f95:	e8 2c 09 00 00       	call   8018c6 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800f9a:	e8 a5 23 00 00       	call   803344 <sys_calculate_free_frames>
  800f9f:	89 c2                	mov    %eax,%edx
  800fa1:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fa7:	29 c2                	sub    %eax,%edx
  800fa9:	89 d0                	mov    %edx,%eax
  800fab:	83 f8 03             	cmp    $0x3,%eax
  800fae:	74 17                	je     800fc7 <_main+0xf8f>
  800fb0:	83 ec 04             	sub    $0x4,%esp
  800fb3:	68 28 3b 80 00       	push   $0x803b28
  800fb8:	68 d3 00 00 00       	push   $0xd3
  800fbd:	68 45 3a 80 00       	push   $0x803a45
  800fc2:	e8 ff 08 00 00       	call   8018c6 <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800fc7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800fce:	e9 c2 00 00 00       	jmp    801095 <_main+0x105d>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fd6:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800fdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fdf:	89 d0                	mov    %edx,%eax
  800fe1:	01 c0                	add    %eax,%eax
  800fe3:	01 d0                	add    %edx,%eax
  800fe5:	c1 e0 02             	shl    $0x2,%eax
  800fe8:	01 c8                	add    %ecx,%eax
  800fea:	8b 00                	mov    (%eax),%eax
  800fec:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  800ff2:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  800ff8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ffd:	89 c2                	mov    %eax,%edx
  800fff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801002:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801008:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80100e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801013:	39 c2                	cmp    %eax,%edx
  801015:	75 17                	jne    80102e <_main+0xff6>
				panic("free: page is not removed from WS");
  801017:	83 ec 04             	sub    $0x4,%esp
  80101a:	68 74 3b 80 00       	push   $0x803b74
  80101f:	68 d7 00 00 00       	push   $0xd7
  801024:	68 45 3a 80 00       	push   $0x803a45
  801029:	e8 98 08 00 00       	call   8018c6 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80102e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801031:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  801037:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80103a:	89 d0                	mov    %edx,%eax
  80103c:	01 c0                	add    %eax,%eax
  80103e:	01 d0                	add    %edx,%eax
  801040:	c1 e0 02             	shl    $0x2,%eax
  801043:	01 c8                	add    %ecx,%eax
  801045:	8b 00                	mov    (%eax),%eax
  801047:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  80104d:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  801053:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801058:	89 c2                	mov    %eax,%edx
  80105a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80105d:	01 c0                	add    %eax,%eax
  80105f:	89 c1                	mov    %eax,%ecx
  801061:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801064:	01 c8                	add    %ecx,%eax
  801066:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  80106c:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  801072:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801077:	39 c2                	cmp    %eax,%edx
  801079:	75 17                	jne    801092 <_main+0x105a>
				panic("free: page is not removed from WS");
  80107b:	83 ec 04             	sub    $0x4,%esp
  80107e:	68 74 3b 80 00       	push   $0x803b74
  801083:	68 d9 00 00 00       	push   $0xd9
  801088:	68 45 3a 80 00       	push   $0x803a45
  80108d:	e8 34 08 00 00       	call   8018c6 <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[1]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801092:	ff 45 ec             	incl   -0x14(%ebp)
  801095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801098:	8b 50 74             	mov    0x74(%eax),%edx
  80109b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109e:	39 c2                	cmp    %eax,%edx
  8010a0:	0f 87 2d ff ff ff    	ja     800fd3 <_main+0xf9b>
				panic("free: page is not removed from WS");
		}

		//Free 6 MB

		freeFrames = sys_calculate_free_frames() ;
  8010a6:	e8 99 22 00 00       	call   803344 <sys_calculate_free_frames>
  8010ab:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010b1:	e8 11 23 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8010b6:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  8010bc:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8010c2:	83 ec 0c             	sub    $0xc,%esp
  8010c5:	50                   	push   %eax
  8010c6:	e8 4b 20 00 00       	call   803116 <free>
  8010cb:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 6*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010ce:	e8 f4 22 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8010d3:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  8010d9:	89 d1                	mov    %edx,%ecx
  8010db:	29 c1                	sub    %eax,%ecx
  8010dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8010e0:	89 d0                	mov    %edx,%eax
  8010e2:	01 c0                	add    %eax,%eax
  8010e4:	01 d0                	add    %edx,%eax
  8010e6:	01 c0                	add    %eax,%eax
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	79 05                	jns    8010f1 <_main+0x10b9>
  8010ec:	05 ff 0f 00 00       	add    $0xfff,%eax
  8010f1:	c1 f8 0c             	sar    $0xc,%eax
  8010f4:	39 c1                	cmp    %eax,%ecx
  8010f6:	74 17                	je     80110f <_main+0x10d7>
  8010f8:	83 ec 04             	sub    $0x4,%esp
  8010fb:	68 ec 3a 80 00       	push   $0x803aec
  801100:	68 e1 00 00 00       	push   $0xe1
  801105:	68 45 3a 80 00       	push   $0x803a45
  80110a:	e8 b7 07 00 00       	call   8018c6 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80110f:	e8 30 22 00 00       	call   803344 <sys_calculate_free_frames>
  801114:	89 c2                	mov    %eax,%edx
  801116:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80111c:	29 c2                	sub    %eax,%edx
  80111e:	89 d0                	mov    %edx,%eax
  801120:	83 f8 04             	cmp    $0x4,%eax
  801123:	74 17                	je     80113c <_main+0x1104>
  801125:	83 ec 04             	sub    $0x4,%esp
  801128:	68 28 3b 80 00       	push   $0x803b28
  80112d:	68 e2 00 00 00       	push   $0xe2
  801132:	68 45 3a 80 00       	push   $0x803a45
  801137:	e8 8a 07 00 00       	call   8018c6 <_panic>

		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80113c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801143:	e9 38 01 00 00       	jmp    801280 <_main+0x1248>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  801148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80114b:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  801151:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801154:	89 d0                	mov    %edx,%eax
  801156:	01 c0                	add    %eax,%eax
  801158:	01 d0                	add    %edx,%eax
  80115a:	c1 e0 02             	shl    $0x2,%eax
  80115d:	01 c8                	add    %ecx,%eax
  80115f:	8b 00                	mov    (%eax),%eax
  801161:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801167:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  80116d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801172:	89 c2                	mov    %eax,%edx
  801174:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80117a:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  801180:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  801186:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80118b:	39 c2                	cmp    %eax,%edx
  80118d:	75 17                	jne    8011a6 <_main+0x116e>
				panic("free: page is not removed from WS");
  80118f:	83 ec 04             	sub    $0x4,%esp
  801192:	68 74 3b 80 00       	push   $0x803b74
  801197:	68 e7 00 00 00       	push   $0xe7
  80119c:	68 45 3a 80 00       	push   $0x803a45
  8011a1:	e8 20 07 00 00       	call   8018c6 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  8011a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011a9:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8011af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011b2:	89 d0                	mov    %edx,%eax
  8011b4:	01 c0                	add    %eax,%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c1 e0 02             	shl    $0x2,%eax
  8011bb:	01 c8                	add    %ecx,%eax
  8011bd:	8b 00                	mov    (%eax),%eax
  8011bf:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  8011c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d0:	89 c2                	mov    %eax,%edx
  8011d2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8011d8:	89 c1                	mov    %eax,%ecx
  8011da:	c1 e9 1f             	shr    $0x1f,%ecx
  8011dd:	01 c8                	add    %ecx,%eax
  8011df:	d1 f8                	sar    %eax
  8011e1:	89 c1                	mov    %eax,%ecx
  8011e3:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8011e9:	01 c8                	add    %ecx,%eax
  8011eb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  8011f1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8011f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011fc:	39 c2                	cmp    %eax,%edx
  8011fe:	75 17                	jne    801217 <_main+0x11df>
				panic("free: page is not removed from WS");
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	68 74 3b 80 00       	push   $0x803b74
  801208:	68 e9 00 00 00       	push   $0xe9
  80120d:	68 45 3a 80 00       	push   $0x803a45
  801212:	e8 af 06 00 00       	call   8018c6 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  801217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80121a:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  801220:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801223:	89 d0                	mov    %edx,%eax
  801225:	01 c0                	add    %eax,%eax
  801227:	01 d0                	add    %edx,%eax
  801229:	c1 e0 02             	shl    $0x2,%eax
  80122c:	01 c8                	add    %ecx,%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  801236:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  80123c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801241:	89 c1                	mov    %eax,%ecx
  801243:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  801249:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  801257:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  80125d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801262:	39 c1                	cmp    %eax,%ecx
  801264:	75 17                	jne    80127d <_main+0x1245>
				panic("free: page is not removed from WS");
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	68 74 3b 80 00       	push   $0x803b74
  80126e:	68 eb 00 00 00       	push   $0xeb
  801273:	68 45 3a 80 00       	push   $0x803a45
  801278:	e8 49 06 00 00       	call   8018c6 <_panic>
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[6]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 6*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");

		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80127d:	ff 45 ec             	incl   -0x14(%ebp)
  801280:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801283:	8b 50 74             	mov    0x74(%eax),%edx
  801286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801289:	39 c2                	cmp    %eax,%edx
  80128b:	0f 87 b7 fe ff ff    	ja     801148 <_main+0x1110>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  801291:	e8 ae 20 00 00       	call   803344 <sys_calculate_free_frames>
  801296:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80129c:	e8 26 21 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8012a1:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012a7:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	50                   	push   %eax
  8012b1:	e8 60 1e 00 00       	call   803116 <free>
  8012b6:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012b9:	e8 09 21 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8012be:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  8012c4:	29 c2                	sub    %eax,%edx
  8012c6:	89 d0                	mov    %edx,%eax
  8012c8:	83 f8 02             	cmp    $0x2,%eax
  8012cb:	74 17                	je     8012e4 <_main+0x12ac>
  8012cd:	83 ec 04             	sub    $0x4,%esp
  8012d0:	68 ec 3a 80 00       	push   $0x803aec
  8012d5:	68 f2 00 00 00       	push   $0xf2
  8012da:	68 45 3a 80 00       	push   $0x803a45
  8012df:	e8 e2 05 00 00       	call   8018c6 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8012e4:	e8 5b 20 00 00       	call   803344 <sys_calculate_free_frames>
  8012e9:	89 c2                	mov    %eax,%edx
  8012eb:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	83 f8 02             	cmp    $0x2,%eax
  8012f8:	74 17                	je     801311 <_main+0x12d9>
  8012fa:	83 ec 04             	sub    $0x4,%esp
  8012fd:	68 28 3b 80 00       	push   $0x803b28
  801302:	68 f3 00 00 00       	push   $0xf3
  801307:	68 45 3a 80 00       	push   $0x803a45
  80130c:	e8 b5 05 00 00       	call   8018c6 <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801311:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801318:	e9 ce 00 00 00       	jmp    8013eb <_main+0x13b3>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  80131d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801320:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  801326:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801329:	89 d0                	mov    %edx,%eax
  80132b:	01 c0                	add    %eax,%eax
  80132d:	01 d0                	add    %edx,%eax
  80132f:	c1 e0 02             	shl    $0x2,%eax
  801332:	01 c8                	add    %ecx,%eax
  801334:	8b 00                	mov    (%eax),%eax
  801336:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  80133c:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  801342:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801347:	89 c2                	mov    %eax,%edx
  801349:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80134f:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  801355:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80135b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	75 17                	jne    80137b <_main+0x1343>
				panic("free: page is not removed from WS");
  801364:	83 ec 04             	sub    $0x4,%esp
  801367:	68 74 3b 80 00       	push   $0x803b74
  80136c:	68 f7 00 00 00       	push   $0xf7
  801371:	68 45 3a 80 00       	push   $0x803a45
  801376:	e8 4b 05 00 00       	call   8018c6 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80137b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137e:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  801384:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801387:	89 d0                	mov    %edx,%eax
  801389:	01 c0                	add    %eax,%eax
  80138b:	01 d0                	add    %edx,%eax
  80138d:	c1 e0 02             	shl    $0x2,%eax
  801390:	01 c8                	add    %ecx,%eax
  801392:	8b 00                	mov    (%eax),%eax
  801394:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  80139a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8013a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a5:	89 c2                	mov    %eax,%edx
  8013a7:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8013ad:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8013b4:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013ba:	01 c8                	add    %ecx,%eax
  8013bc:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  8013c2:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8013c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cd:	39 c2                	cmp    %eax,%edx
  8013cf:	75 17                	jne    8013e8 <_main+0x13b0>
				panic("free: page is not removed from WS");
  8013d1:	83 ec 04             	sub    $0x4,%esp
  8013d4:	68 74 3b 80 00       	push   $0x803b74
  8013d9:	68 f9 00 00 00       	push   $0xf9
  8013de:	68 45 3a 80 00       	push   $0x803a45
  8013e3:	e8 de 04 00 00       	call   8018c6 <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[4]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8013e8:	ff 45 ec             	incl   -0x14(%ebp)
  8013eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ee:	8b 50 74             	mov    0x74(%eax),%edx
  8013f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013f4:	39 c2                	cmp    %eax,%edx
  8013f6:	0f 87 21 ff ff ff    	ja     80131d <_main+0x12e5>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8013fc:	e8 43 1f 00 00       	call   803344 <sys_calculate_free_frames>
  801401:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801407:	e8 bb 1f 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  80140c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  801412:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801418:	83 ec 0c             	sub    $0xc,%esp
  80141b:	50                   	push   %eax
  80141c:	e8 f5 1c 00 00       	call   803116 <free>
  801421:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
  801424:	e8 9e 1f 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  801429:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  80142f:	89 d1                	mov    %edx,%ecx
  801431:	29 c1                	sub    %eax,%ecx
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	89 c2                	mov    %eax,%edx
  801438:	01 d2                	add    %edx,%edx
  80143a:	01 d0                	add    %edx,%eax
  80143c:	85 c0                	test   %eax,%eax
  80143e:	79 05                	jns    801445 <_main+0x140d>
  801440:	05 ff 0f 00 00       	add    $0xfff,%eax
  801445:	c1 f8 0c             	sar    $0xc,%eax
  801448:	39 c1                	cmp    %eax,%ecx
  80144a:	74 17                	je     801463 <_main+0x142b>
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	68 ec 3a 80 00       	push   $0x803aec
  801454:	68 00 01 00 00       	push   $0x100
  801459:	68 45 3a 80 00       	push   $0x803a45
  80145e:	e8 63 04 00 00       	call   8018c6 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801463:	e8 dc 1e 00 00       	call   803344 <sys_calculate_free_frames>
  801468:	89 c2                	mov    %eax,%edx
  80146a:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801470:	39 c2                	cmp    %eax,%edx
  801472:	74 17                	je     80148b <_main+0x1453>
  801474:	83 ec 04             	sub    $0x4,%esp
  801477:	68 28 3b 80 00       	push   $0x803b28
  80147c:	68 01 01 00 00       	push   $0x101
  801481:	68 45 3a 80 00       	push   $0x803a45
  801486:	e8 3b 04 00 00       	call   8018c6 <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  80148b:	e8 b4 1e 00 00       	call   803344 <sys_calculate_free_frames>
  801490:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801496:	e8 2c 1f 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  80149b:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  8014a1:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8014a7:	83 ec 0c             	sub    $0xc,%esp
  8014aa:	50                   	push   %eax
  8014ab:	e8 66 1c 00 00       	call   803116 <free>
  8014b0:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014b3:	e8 0f 1f 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8014b8:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  8014be:	29 c2                	sub    %eax,%edx
  8014c0:	89 d0                	mov    %edx,%eax
  8014c2:	83 f8 01             	cmp    $0x1,%eax
  8014c5:	74 17                	je     8014de <_main+0x14a6>
  8014c7:	83 ec 04             	sub    $0x4,%esp
  8014ca:	68 ec 3a 80 00       	push   $0x803aec
  8014cf:	68 07 01 00 00       	push   $0x107
  8014d4:	68 45 3a 80 00       	push   $0x803a45
  8014d9:	e8 e8 03 00 00       	call   8018c6 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014de:	e8 61 1e 00 00       	call   803344 <sys_calculate_free_frames>
  8014e3:	89 c2                	mov    %eax,%edx
  8014e5:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014eb:	29 c2                	sub    %eax,%edx
  8014ed:	89 d0                	mov    %edx,%eax
  8014ef:	83 f8 02             	cmp    $0x2,%eax
  8014f2:	74 17                	je     80150b <_main+0x14d3>
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	68 28 3b 80 00       	push   $0x803b28
  8014fc:	68 08 01 00 00       	push   $0x108
  801501:	68 45 3a 80 00       	push   $0x803a45
  801506:	e8 bb 03 00 00       	call   8018c6 <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80150b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801512:	e9 c5 00 00 00       	jmp    8015dc <_main+0x15a4>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  801517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80151a:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  801520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801523:	89 d0                	mov    %edx,%eax
  801525:	01 c0                	add    %eax,%eax
  801527:	01 d0                	add    %edx,%eax
  801529:	c1 e0 02             	shl    $0x2,%eax
  80152c:	01 c8                	add    %ecx,%eax
  80152e:	8b 00                	mov    (%eax),%eax
  801530:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  801536:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  80153c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801541:	89 c2                	mov    %eax,%edx
  801543:	8b 45 8c             	mov    -0x74(%ebp),%eax
  801546:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  80154c:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  801552:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801557:	39 c2                	cmp    %eax,%edx
  801559:	75 17                	jne    801572 <_main+0x153a>
				panic("free: page is not removed from WS");
  80155b:	83 ec 04             	sub    $0x4,%esp
  80155e:	68 74 3b 80 00       	push   $0x803b74
  801563:	68 0c 01 00 00       	push   $0x10c
  801568:	68 45 3a 80 00       	push   $0x803a45
  80156d:	e8 54 03 00 00       	call   8018c6 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  801572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801575:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  80157b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80157e:	89 d0                	mov    %edx,%eax
  801580:	01 c0                	add    %eax,%eax
  801582:	01 d0                	add    %edx,%eax
  801584:	c1 e0 02             	shl    $0x2,%eax
  801587:	01 c8                	add    %ecx,%eax
  801589:	8b 00                	mov    (%eax),%eax
  80158b:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  801591:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801597:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80159c:	89 c2                	mov    %eax,%edx
  80159e:	8b 45 88             	mov    -0x78(%ebp),%eax
  8015a1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8015a8:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8015ab:	01 c8                	add    %ecx,%eax
  8015ad:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
  8015b3:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8015b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015be:	39 c2                	cmp    %eax,%edx
  8015c0:	75 17                	jne    8015d9 <_main+0x15a1>
				panic("free: page is not removed from WS");
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	68 74 3b 80 00       	push   $0x803b74
  8015ca:	68 0e 01 00 00       	push   $0x10e
  8015cf:	68 45 3a 80 00       	push   $0x803a45
  8015d4:	e8 ed 02 00 00       	call   8018c6 <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[2]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8015d9:	ff 45 ec             	incl   -0x14(%ebp)
  8015dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015df:	8b 50 74             	mov    0x74(%eax),%edx
  8015e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e5:	39 c2                	cmp    %eax,%edx
  8015e7:	0f 87 2a ff ff ff    	ja     801517 <_main+0x14df>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 2nd 2 KB
		freeFrames = sys_calculate_free_frames() ;
  8015ed:	e8 52 1d 00 00       	call   803344 <sys_calculate_free_frames>
  8015f2:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8015f8:	e8 ca 1d 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  8015fd:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  801603:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  801609:	83 ec 0c             	sub    $0xc,%esp
  80160c:	50                   	push   %eax
  80160d:	e8 04 1b 00 00       	call   803116 <free>
  801612:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  801615:	e8 ad 1d 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  80161a:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  801620:	29 c2                	sub    %eax,%edx
  801622:	89 d0                	mov    %edx,%eax
  801624:	83 f8 01             	cmp    $0x1,%eax
  801627:	74 17                	je     801640 <_main+0x1608>
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	68 ec 3a 80 00       	push   $0x803aec
  801631:	68 15 01 00 00       	push   $0x115
  801636:	68 45 3a 80 00       	push   $0x803a45
  80163b:	e8 86 02 00 00       	call   8018c6 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801640:	e8 ff 1c 00 00       	call   803344 <sys_calculate_free_frames>
  801645:	89 c2                	mov    %eax,%edx
  801647:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80164d:	39 c2                	cmp    %eax,%edx
  80164f:	74 17                	je     801668 <_main+0x1630>
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	68 28 3b 80 00       	push   $0x803b28
  801659:	68 16 01 00 00       	push   $0x116
  80165e:	68 45 3a 80 00       	push   $0x803a45
  801663:	e8 5e 02 00 00       	call   8018c6 <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801668:	e8 d7 1c 00 00       	call   803344 <sys_calculate_free_frames>
  80166d:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801673:	e8 4f 1d 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  801678:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  80167e:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  801684:	83 ec 0c             	sub    $0xc,%esp
  801687:	50                   	push   %eax
  801688:	e8 89 1a 00 00       	call   803116 <free>
  80168d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 4) panic("Wrong free: Extra or less pages are removed from PageFile");
  801690:	e8 32 1d 00 00       	call   8033c7 <sys_pf_calculate_allocated_pages>
  801695:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  80169b:	29 c2                	sub    %eax,%edx
  80169d:	89 d0                	mov    %edx,%eax
  80169f:	83 f8 04             	cmp    $0x4,%eax
  8016a2:	74 17                	je     8016bb <_main+0x1683>
  8016a4:	83 ec 04             	sub    $0x4,%esp
  8016a7:	68 ec 3a 80 00       	push   $0x803aec
  8016ac:	68 1d 01 00 00       	push   $0x11d
  8016b1:	68 45 3a 80 00       	push   $0x803a45
  8016b6:	e8 0b 02 00 00       	call   8018c6 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8016bb:	e8 84 1c 00 00       	call   803344 <sys_calculate_free_frames>
  8016c0:	89 c2                	mov    %eax,%edx
  8016c2:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016c8:	29 c2                	sub    %eax,%edx
  8016ca:	89 d0                	mov    %edx,%eax
  8016cc:	83 f8 03             	cmp    $0x3,%eax
  8016cf:	74 17                	je     8016e8 <_main+0x16b0>
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 28 3b 80 00       	push   $0x803b28
  8016d9:	68 1e 01 00 00       	push   $0x11e
  8016de:	68 45 3a 80 00       	push   $0x803a45
  8016e3:	e8 de 01 00 00       	call   8018c6 <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8016e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8016ef:	e9 c2 00 00 00       	jmp    8017b6 <_main+0x177e>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  8016f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f7:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8016fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801700:	89 d0                	mov    %edx,%eax
  801702:	01 c0                	add    %eax,%eax
  801704:	01 d0                	add    %edx,%eax
  801706:	c1 e0 02             	shl    $0x2,%eax
  801709:	01 c8                	add    %ecx,%eax
  80170b:	8b 00                	mov    (%eax),%eax
  80170d:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  801713:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801719:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80171e:	89 c2                	mov    %eax,%edx
  801720:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801723:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  801729:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  80172f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801734:	39 c2                	cmp    %eax,%edx
  801736:	75 17                	jne    80174f <_main+0x1717>
				panic("free: page is not removed from WS");
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	68 74 3b 80 00       	push   $0x803b74
  801740:	68 22 01 00 00       	push   $0x122
  801745:	68 45 3a 80 00       	push   $0x803a45
  80174a:	e8 77 01 00 00       	call   8018c6 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80174f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801752:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  801758:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80175b:	89 d0                	mov    %edx,%eax
  80175d:	01 c0                	add    %eax,%eax
  80175f:	01 d0                	add    %edx,%eax
  801761:	c1 e0 02             	shl    $0x2,%eax
  801764:	01 c8                	add    %ecx,%eax
  801766:	8b 00                	mov    (%eax),%eax
  801768:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
  80176e:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  801774:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801779:	89 c2                	mov    %eax,%edx
  80177b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80177e:	01 c0                	add    %eax,%eax
  801780:	89 c1                	mov    %eax,%ecx
  801782:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801785:	01 c8                	add    %ecx,%eax
  801787:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  80178d:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
  801793:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801798:	39 c2                	cmp    %eax,%edx
  80179a:	75 17                	jne    8017b3 <_main+0x177b>
				panic("free: page is not removed from WS");
  80179c:	83 ec 04             	sub    $0x4,%esp
  80179f:	68 74 3b 80 00       	push   $0x803b74
  8017a4:	68 24 01 00 00       	push   $0x124
  8017a9:	68 45 3a 80 00       	push   $0x803a45
  8017ae:	e8 13 01 00 00       	call   8018c6 <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[7]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 4) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8017b3:	ff 45 ec             	incl   -0x14(%ebp)
  8017b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b9:	8b 50 74             	mov    0x74(%eax),%edx
  8017bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bf:	39 c2                	cmp    %eax,%edx
  8017c1:	0f 87 2d ff ff ff    	ja     8016f4 <_main+0x16bc>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
  8017c7:	e8 78 1b 00 00       	call   803344 <sys_calculate_free_frames>
  8017cc:	8d 50 04             	lea    0x4(%eax),%edx
  8017cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017d2:	39 c2                	cmp    %eax,%edx
  8017d4:	74 17                	je     8017ed <_main+0x17b5>
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	68 98 3b 80 00       	push   $0x803b98
  8017de:	68 27 01 00 00       	push   $0x127
  8017e3:	68 45 3a 80 00       	push   $0x803a45
  8017e8:	e8 d9 00 00 00       	call   8018c6 <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	68 cc 3b 80 00       	push   $0x803bcc
  8017f5:	e8 f7 01 00 00       	call   8019f1 <cprintf>
  8017fa:	83 c4 10             	add    $0x10,%esp

	return;
  8017fd:	90                   	nop
}
  8017fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801801:	5b                   	pop    %ebx
  801802:	5f                   	pop    %edi
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    

00801805 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80180b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80180f:	7e 0a                	jle    80181b <libmain+0x16>
		binaryname = argv[0];
  801811:	8b 45 0c             	mov    0xc(%ebp),%eax
  801814:	8b 00                	mov    (%eax),%eax
  801816:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80181b:	83 ec 08             	sub    $0x8,%esp
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	e8 0f e8 ff ff       	call   800038 <_main>
  801829:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  80182c:	e8 61 1a 00 00       	call   803292 <sys_getenvid>
  801831:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  801834:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801837:	89 d0                	mov    %edx,%eax
  801839:	c1 e0 03             	shl    $0x3,%eax
  80183c:	01 d0                	add    %edx,%eax
  80183e:	01 c0                	add    %eax,%eax
  801840:	01 d0                	add    %edx,%eax
  801842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801849:	01 d0                	add    %edx,%eax
  80184b:	c1 e0 03             	shl    $0x3,%eax
  80184e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801853:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  801856:	e8 85 1b 00 00       	call   8033e0 <sys_disable_interrupt>
		cprintf("**************************************\n");
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	68 20 3c 80 00       	push   $0x803c20
  801863:	e8 89 01 00 00       	call   8019f1 <cprintf>
  801868:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186e:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	50                   	push   %eax
  801878:	68 48 3c 80 00       	push   $0x803c48
  80187d:	e8 6f 01 00 00       	call   8019f1 <cprintf>
  801882:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801885:	83 ec 0c             	sub    $0xc,%esp
  801888:	68 20 3c 80 00       	push   $0x803c20
  80188d:	e8 5f 01 00 00       	call   8019f1 <cprintf>
  801892:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801895:	e8 60 1b 00 00       	call   8033fa <sys_enable_interrupt>

	// exit gracefully
	exit();
  80189a:	e8 19 00 00 00       	call   8018b8 <exit>
}
  80189f:	90                   	nop
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8018a8:	83 ec 0c             	sub    $0xc,%esp
  8018ab:	6a 00                	push   $0x0
  8018ad:	e8 c5 19 00 00       	call   803277 <sys_env_destroy>
  8018b2:	83 c4 10             	add    $0x10,%esp
}
  8018b5:	90                   	nop
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <exit>:

void
exit(void)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8018be:	e8 e8 19 00 00       	call   8032ab <sys_env_exit>
}
  8018c3:	90                   	nop
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8018cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8018cf:	83 c0 04             	add    $0x4,%eax
  8018d2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8018d5:	a1 50 50 98 00       	mov    0x985050,%eax
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	74 16                	je     8018f4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8018de:	a1 50 50 98 00       	mov    0x985050,%eax
  8018e3:	83 ec 08             	sub    $0x8,%esp
  8018e6:	50                   	push   %eax
  8018e7:	68 61 3c 80 00       	push   $0x803c61
  8018ec:	e8 00 01 00 00       	call   8019f1 <cprintf>
  8018f1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8018f4:	a1 00 50 80 00       	mov    0x805000,%eax
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	50                   	push   %eax
  801900:	68 66 3c 80 00       	push   $0x803c66
  801905:	e8 e7 00 00 00       	call   8019f1 <cprintf>
  80190a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80190d:	8b 45 10             	mov    0x10(%ebp),%eax
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	ff 75 f4             	pushl  -0xc(%ebp)
  801916:	50                   	push   %eax
  801917:	e8 7a 00 00 00       	call   801996 <vcprintf>
  80191c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	68 82 3c 80 00       	push   $0x803c82
  801927:	e8 c5 00 00 00       	call   8019f1 <cprintf>
  80192c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80192f:	e8 84 ff ff ff       	call   8018b8 <exit>

	// should not return here
	while (1) ;
  801934:	eb fe                	jmp    801934 <_panic+0x6e>

00801936 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80193c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193f:	8b 00                	mov    (%eax),%eax
  801941:	8d 48 01             	lea    0x1(%eax),%ecx
  801944:	8b 55 0c             	mov    0xc(%ebp),%edx
  801947:	89 0a                	mov    %ecx,(%edx)
  801949:	8b 55 08             	mov    0x8(%ebp),%edx
  80194c:	88 d1                	mov    %dl,%cl
  80194e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801951:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801955:	8b 45 0c             	mov    0xc(%ebp),%eax
  801958:	8b 00                	mov    (%eax),%eax
  80195a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80195f:	75 23                	jne    801984 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  801961:	8b 45 0c             	mov    0xc(%ebp),%eax
  801964:	8b 00                	mov    (%eax),%eax
  801966:	89 c2                	mov    %eax,%edx
  801968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196b:	83 c0 08             	add    $0x8,%eax
  80196e:	83 ec 08             	sub    $0x8,%esp
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	e8 c9 18 00 00       	call   803241 <sys_cputs>
  801978:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80197b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801984:	8b 45 0c             	mov    0xc(%ebp),%eax
  801987:	8b 40 04             	mov    0x4(%eax),%eax
  80198a:	8d 50 01             	lea    0x1(%eax),%edx
  80198d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801990:	89 50 04             	mov    %edx,0x4(%eax)
}
  801993:	90                   	nop
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80199f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019a6:	00 00 00 
	b.cnt = 0;
  8019a9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8019b0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8019bf:	50                   	push   %eax
  8019c0:	68 36 19 80 00       	push   $0x801936
  8019c5:	e8 fa 01 00 00       	call   801bc4 <vprintfmt>
  8019ca:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8019cd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019d3:	83 ec 08             	sub    $0x8,%esp
  8019d6:	50                   	push   %eax
  8019d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8019dd:	83 c0 08             	add    $0x8,%eax
  8019e0:	50                   	push   %eax
  8019e1:	e8 5b 18 00 00       	call   803241 <sys_cputs>
  8019e6:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8019e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <cprintf>:

int cprintf(const char *fmt, ...) {
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019f7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8019fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	83 ec 08             	sub    $0x8,%esp
  801a03:	ff 75 f4             	pushl  -0xc(%ebp)
  801a06:	50                   	push   %eax
  801a07:	e8 8a ff ff ff       	call   801996 <vcprintf>
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a1d:	e8 be 19 00 00       	call   8033e0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a22:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	83 ec 08             	sub    $0x8,%esp
  801a2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a31:	50                   	push   %eax
  801a32:	e8 5f ff ff ff       	call   801996 <vcprintf>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801a3d:	e8 b8 19 00 00       	call   8033fa <sys_enable_interrupt>
	return cnt;
  801a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	53                   	push   %ebx
  801a4b:	83 ec 14             	sub    $0x14,%esp
  801a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a54:	8b 45 14             	mov    0x14(%ebp),%eax
  801a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801a5a:	8b 45 18             	mov    0x18(%ebp),%eax
  801a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a62:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801a65:	77 55                	ja     801abc <printnum+0x75>
  801a67:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801a6a:	72 05                	jb     801a71 <printnum+0x2a>
  801a6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a6f:	77 4b                	ja     801abc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801a71:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801a74:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801a77:	8b 45 18             	mov    0x18(%ebp),%eax
  801a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7f:	52                   	push   %edx
  801a80:	50                   	push   %eax
  801a81:	ff 75 f4             	pushl  -0xc(%ebp)
  801a84:	ff 75 f0             	pushl  -0x10(%ebp)
  801a87:	e8 f0 1c 00 00       	call   80377c <__udivdi3>
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	83 ec 04             	sub    $0x4,%esp
  801a92:	ff 75 20             	pushl  0x20(%ebp)
  801a95:	53                   	push   %ebx
  801a96:	ff 75 18             	pushl  0x18(%ebp)
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	e8 a1 ff ff ff       	call   801a47 <printnum>
  801aa6:	83 c4 20             	add    $0x20,%esp
  801aa9:	eb 1a                	jmp    801ac5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 20             	pushl  0x20(%ebp)
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	ff d0                	call   *%eax
  801ab9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801abc:	ff 4d 1c             	decl   0x1c(%ebp)
  801abf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801ac3:	7f e6                	jg     801aab <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801ac5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801ac8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad3:	53                   	push   %ebx
  801ad4:	51                   	push   %ecx
  801ad5:	52                   	push   %edx
  801ad6:	50                   	push   %eax
  801ad7:	e8 b0 1d 00 00       	call   80388c <__umoddi3>
  801adc:	83 c4 10             	add    $0x10,%esp
  801adf:	05 b4 3e 80 00       	add    $0x803eb4,%eax
  801ae4:	8a 00                	mov    (%eax),%al
  801ae6:	0f be c0             	movsbl %al,%eax
  801ae9:	83 ec 08             	sub    $0x8,%esp
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	50                   	push   %eax
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	ff d0                	call   *%eax
  801af5:	83 c4 10             	add    $0x10,%esp
}
  801af8:	90                   	nop
  801af9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801b01:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801b05:	7e 1c                	jle    801b23 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8b 00                	mov    (%eax),%eax
  801b0c:	8d 50 08             	lea    0x8(%eax),%edx
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	89 10                	mov    %edx,(%eax)
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	8b 00                	mov    (%eax),%eax
  801b19:	83 e8 08             	sub    $0x8,%eax
  801b1c:	8b 50 04             	mov    0x4(%eax),%edx
  801b1f:	8b 00                	mov    (%eax),%eax
  801b21:	eb 40                	jmp    801b63 <getuint+0x65>
	else if (lflag)
  801b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b27:	74 1e                	je     801b47 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8b 00                	mov    (%eax),%eax
  801b2e:	8d 50 04             	lea    0x4(%eax),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	89 10                	mov    %edx,(%eax)
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	8b 00                	mov    (%eax),%eax
  801b3b:	83 e8 04             	sub    $0x4,%eax
  801b3e:	8b 00                	mov    (%eax),%eax
  801b40:	ba 00 00 00 00       	mov    $0x0,%edx
  801b45:	eb 1c                	jmp    801b63 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	8b 00                	mov    (%eax),%eax
  801b4c:	8d 50 04             	lea    0x4(%eax),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	89 10                	mov    %edx,(%eax)
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8b 00                	mov    (%eax),%eax
  801b59:	83 e8 04             	sub    $0x4,%eax
  801b5c:	8b 00                	mov    (%eax),%eax
  801b5e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b63:	5d                   	pop    %ebp
  801b64:	c3                   	ret    

00801b65 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801b68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801b6c:	7e 1c                	jle    801b8a <getint+0x25>
		return va_arg(*ap, long long);
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	8b 00                	mov    (%eax),%eax
  801b73:	8d 50 08             	lea    0x8(%eax),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	89 10                	mov    %edx,(%eax)
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	8b 00                	mov    (%eax),%eax
  801b80:	83 e8 08             	sub    $0x8,%eax
  801b83:	8b 50 04             	mov    0x4(%eax),%edx
  801b86:	8b 00                	mov    (%eax),%eax
  801b88:	eb 38                	jmp    801bc2 <getint+0x5d>
	else if (lflag)
  801b8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b8e:	74 1a                	je     801baa <getint+0x45>
		return va_arg(*ap, long);
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	8b 00                	mov    (%eax),%eax
  801b95:	8d 50 04             	lea    0x4(%eax),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	89 10                	mov    %edx,(%eax)
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	8b 00                	mov    (%eax),%eax
  801ba2:	83 e8 04             	sub    $0x4,%eax
  801ba5:	8b 00                	mov    (%eax),%eax
  801ba7:	99                   	cltd   
  801ba8:	eb 18                	jmp    801bc2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	8b 00                	mov    (%eax),%eax
  801baf:	8d 50 04             	lea    0x4(%eax),%edx
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	89 10                	mov    %edx,(%eax)
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	8b 00                	mov    (%eax),%eax
  801bbc:	83 e8 04             	sub    $0x4,%eax
  801bbf:	8b 00                	mov    (%eax),%eax
  801bc1:	99                   	cltd   
}
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    

00801bc4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	56                   	push   %esi
  801bc8:	53                   	push   %ebx
  801bc9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bcc:	eb 17                	jmp    801be5 <vprintfmt+0x21>
			if (ch == '\0')
  801bce:	85 db                	test   %ebx,%ebx
  801bd0:	0f 84 af 03 00 00    	je     801f85 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801bd6:	83 ec 08             	sub    $0x8,%esp
  801bd9:	ff 75 0c             	pushl  0xc(%ebp)
  801bdc:	53                   	push   %ebx
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	ff d0                	call   *%eax
  801be2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801be5:	8b 45 10             	mov    0x10(%ebp),%eax
  801be8:	8d 50 01             	lea    0x1(%eax),%edx
  801beb:	89 55 10             	mov    %edx,0x10(%ebp)
  801bee:	8a 00                	mov    (%eax),%al
  801bf0:	0f b6 d8             	movzbl %al,%ebx
  801bf3:	83 fb 25             	cmp    $0x25,%ebx
  801bf6:	75 d6                	jne    801bce <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801bf8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801bfc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801c03:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801c0a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801c11:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c18:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1b:	8d 50 01             	lea    0x1(%eax),%edx
  801c1e:	89 55 10             	mov    %edx,0x10(%ebp)
  801c21:	8a 00                	mov    (%eax),%al
  801c23:	0f b6 d8             	movzbl %al,%ebx
  801c26:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801c29:	83 f8 55             	cmp    $0x55,%eax
  801c2c:	0f 87 2b 03 00 00    	ja     801f5d <vprintfmt+0x399>
  801c32:	8b 04 85 d8 3e 80 00 	mov    0x803ed8(,%eax,4),%eax
  801c39:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801c3b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801c3f:	eb d7                	jmp    801c18 <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801c41:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801c45:	eb d1                	jmp    801c18 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801c47:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801c4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c51:	89 d0                	mov    %edx,%eax
  801c53:	c1 e0 02             	shl    $0x2,%eax
  801c56:	01 d0                	add    %edx,%eax
  801c58:	01 c0                	add    %eax,%eax
  801c5a:	01 d8                	add    %ebx,%eax
  801c5c:	83 e8 30             	sub    $0x30,%eax
  801c5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801c62:	8b 45 10             	mov    0x10(%ebp),%eax
  801c65:	8a 00                	mov    (%eax),%al
  801c67:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801c6a:	83 fb 2f             	cmp    $0x2f,%ebx
  801c6d:	7e 3e                	jle    801cad <vprintfmt+0xe9>
  801c6f:	83 fb 39             	cmp    $0x39,%ebx
  801c72:	7f 39                	jg     801cad <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801c74:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801c77:	eb d5                	jmp    801c4e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801c79:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7c:	83 c0 04             	add    $0x4,%eax
  801c7f:	89 45 14             	mov    %eax,0x14(%ebp)
  801c82:	8b 45 14             	mov    0x14(%ebp),%eax
  801c85:	83 e8 04             	sub    $0x4,%eax
  801c88:	8b 00                	mov    (%eax),%eax
  801c8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801c8d:	eb 1f                	jmp    801cae <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801c8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c93:	79 83                	jns    801c18 <vprintfmt+0x54>
				width = 0;
  801c95:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801c9c:	e9 77 ff ff ff       	jmp    801c18 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801ca1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801ca8:	e9 6b ff ff ff       	jmp    801c18 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801cad:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801cae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cb2:	0f 89 60 ff ff ff    	jns    801c18 <vprintfmt+0x54>
				width = precision, precision = -1;
  801cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cbe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801cc5:	e9 4e ff ff ff       	jmp    801c18 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801cca:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ccd:	e9 46 ff ff ff       	jmp    801c18 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801cd2:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd5:	83 c0 04             	add    $0x4,%eax
  801cd8:	89 45 14             	mov    %eax,0x14(%ebp)
  801cdb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cde:	83 e8 04             	sub    $0x4,%eax
  801ce1:	8b 00                	mov    (%eax),%eax
  801ce3:	83 ec 08             	sub    $0x8,%esp
  801ce6:	ff 75 0c             	pushl  0xc(%ebp)
  801ce9:	50                   	push   %eax
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	ff d0                	call   *%eax
  801cef:	83 c4 10             	add    $0x10,%esp
			break;
  801cf2:	e9 89 02 00 00       	jmp    801f80 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801cf7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfa:	83 c0 04             	add    $0x4,%eax
  801cfd:	89 45 14             	mov    %eax,0x14(%ebp)
  801d00:	8b 45 14             	mov    0x14(%ebp),%eax
  801d03:	83 e8 04             	sub    $0x4,%eax
  801d06:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801d08:	85 db                	test   %ebx,%ebx
  801d0a:	79 02                	jns    801d0e <vprintfmt+0x14a>
				err = -err;
  801d0c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801d0e:	83 fb 64             	cmp    $0x64,%ebx
  801d11:	7f 0b                	jg     801d1e <vprintfmt+0x15a>
  801d13:	8b 34 9d 20 3d 80 00 	mov    0x803d20(,%ebx,4),%esi
  801d1a:	85 f6                	test   %esi,%esi
  801d1c:	75 19                	jne    801d37 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801d1e:	53                   	push   %ebx
  801d1f:	68 c5 3e 80 00       	push   $0x803ec5
  801d24:	ff 75 0c             	pushl  0xc(%ebp)
  801d27:	ff 75 08             	pushl  0x8(%ebp)
  801d2a:	e8 5e 02 00 00       	call   801f8d <printfmt>
  801d2f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801d32:	e9 49 02 00 00       	jmp    801f80 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801d37:	56                   	push   %esi
  801d38:	68 ce 3e 80 00       	push   $0x803ece
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	e8 45 02 00 00       	call   801f8d <printfmt>
  801d48:	83 c4 10             	add    $0x10,%esp
			break;
  801d4b:	e9 30 02 00 00       	jmp    801f80 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801d50:	8b 45 14             	mov    0x14(%ebp),%eax
  801d53:	83 c0 04             	add    $0x4,%eax
  801d56:	89 45 14             	mov    %eax,0x14(%ebp)
  801d59:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5c:	83 e8 04             	sub    $0x4,%eax
  801d5f:	8b 30                	mov    (%eax),%esi
  801d61:	85 f6                	test   %esi,%esi
  801d63:	75 05                	jne    801d6a <vprintfmt+0x1a6>
				p = "(null)";
  801d65:	be d1 3e 80 00       	mov    $0x803ed1,%esi
			if (width > 0 && padc != '-')
  801d6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d6e:	7e 6d                	jle    801ddd <vprintfmt+0x219>
  801d70:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801d74:	74 67                	je     801ddd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d79:	83 ec 08             	sub    $0x8,%esp
  801d7c:	50                   	push   %eax
  801d7d:	56                   	push   %esi
  801d7e:	e8 0c 03 00 00       	call   80208f <strnlen>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801d89:	eb 16                	jmp    801da1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801d8b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801d8f:	83 ec 08             	sub    $0x8,%esp
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	50                   	push   %eax
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	ff d0                	call   *%eax
  801d9b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801d9e:	ff 4d e4             	decl   -0x1c(%ebp)
  801da1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801da5:	7f e4                	jg     801d8b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801da7:	eb 34                	jmp    801ddd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801da9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801dad:	74 1c                	je     801dcb <vprintfmt+0x207>
  801daf:	83 fb 1f             	cmp    $0x1f,%ebx
  801db2:	7e 05                	jle    801db9 <vprintfmt+0x1f5>
  801db4:	83 fb 7e             	cmp    $0x7e,%ebx
  801db7:	7e 12                	jle    801dcb <vprintfmt+0x207>
					putch('?', putdat);
  801db9:	83 ec 08             	sub    $0x8,%esp
  801dbc:	ff 75 0c             	pushl  0xc(%ebp)
  801dbf:	6a 3f                	push   $0x3f
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	ff d0                	call   *%eax
  801dc6:	83 c4 10             	add    $0x10,%esp
  801dc9:	eb 0f                	jmp    801dda <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801dcb:	83 ec 08             	sub    $0x8,%esp
  801dce:	ff 75 0c             	pushl  0xc(%ebp)
  801dd1:	53                   	push   %ebx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	ff d0                	call   *%eax
  801dd7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801dda:	ff 4d e4             	decl   -0x1c(%ebp)
  801ddd:	89 f0                	mov    %esi,%eax
  801ddf:	8d 70 01             	lea    0x1(%eax),%esi
  801de2:	8a 00                	mov    (%eax),%al
  801de4:	0f be d8             	movsbl %al,%ebx
  801de7:	85 db                	test   %ebx,%ebx
  801de9:	74 24                	je     801e0f <vprintfmt+0x24b>
  801deb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801def:	78 b8                	js     801da9 <vprintfmt+0x1e5>
  801df1:	ff 4d e0             	decl   -0x20(%ebp)
  801df4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801df8:	79 af                	jns    801da9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801dfa:	eb 13                	jmp    801e0f <vprintfmt+0x24b>
				putch(' ', putdat);
  801dfc:	83 ec 08             	sub    $0x8,%esp
  801dff:	ff 75 0c             	pushl  0xc(%ebp)
  801e02:	6a 20                	push   $0x20
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	ff d0                	call   *%eax
  801e09:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e0c:	ff 4d e4             	decl   -0x1c(%ebp)
  801e0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e13:	7f e7                	jg     801dfc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801e15:	e9 66 01 00 00       	jmp    801f80 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801e1a:	83 ec 08             	sub    $0x8,%esp
  801e1d:	ff 75 e8             	pushl  -0x18(%ebp)
  801e20:	8d 45 14             	lea    0x14(%ebp),%eax
  801e23:	50                   	push   %eax
  801e24:	e8 3c fd ff ff       	call   801b65 <getint>
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e38:	85 d2                	test   %edx,%edx
  801e3a:	79 23                	jns    801e5f <vprintfmt+0x29b>
				putch('-', putdat);
  801e3c:	83 ec 08             	sub    $0x8,%esp
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	6a 2d                	push   $0x2d
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	ff d0                	call   *%eax
  801e49:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e52:	f7 d8                	neg    %eax
  801e54:	83 d2 00             	adc    $0x0,%edx
  801e57:	f7 da                	neg    %edx
  801e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801e5f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801e66:	e9 bc 00 00 00       	jmp    801f27 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801e6b:	83 ec 08             	sub    $0x8,%esp
  801e6e:	ff 75 e8             	pushl  -0x18(%ebp)
  801e71:	8d 45 14             	lea    0x14(%ebp),%eax
  801e74:	50                   	push   %eax
  801e75:	e8 84 fc ff ff       	call   801afe <getuint>
  801e7a:	83 c4 10             	add    $0x10,%esp
  801e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801e83:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801e8a:	e9 98 00 00 00       	jmp    801f27 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801e8f:	83 ec 08             	sub    $0x8,%esp
  801e92:	ff 75 0c             	pushl  0xc(%ebp)
  801e95:	6a 58                	push   $0x58
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	ff d0                	call   *%eax
  801e9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801e9f:	83 ec 08             	sub    $0x8,%esp
  801ea2:	ff 75 0c             	pushl  0xc(%ebp)
  801ea5:	6a 58                	push   $0x58
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	ff d0                	call   *%eax
  801eac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801eaf:	83 ec 08             	sub    $0x8,%esp
  801eb2:	ff 75 0c             	pushl  0xc(%ebp)
  801eb5:	6a 58                	push   $0x58
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	ff d0                	call   *%eax
  801ebc:	83 c4 10             	add    $0x10,%esp
			break;
  801ebf:	e9 bc 00 00 00       	jmp    801f80 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801ec4:	83 ec 08             	sub    $0x8,%esp
  801ec7:	ff 75 0c             	pushl  0xc(%ebp)
  801eca:	6a 30                	push   $0x30
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	ff d0                	call   *%eax
  801ed1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801ed4:	83 ec 08             	sub    $0x8,%esp
  801ed7:	ff 75 0c             	pushl  0xc(%ebp)
  801eda:	6a 78                	push   $0x78
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	ff d0                	call   *%eax
  801ee1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801ee4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee7:	83 c0 04             	add    $0x4,%eax
  801eea:	89 45 14             	mov    %eax,0x14(%ebp)
  801eed:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef0:	83 e8 04             	sub    $0x4,%eax
  801ef3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801ef5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ef8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801eff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801f06:	eb 1f                	jmp    801f27 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801f08:	83 ec 08             	sub    $0x8,%esp
  801f0b:	ff 75 e8             	pushl  -0x18(%ebp)
  801f0e:	8d 45 14             	lea    0x14(%ebp),%eax
  801f11:	50                   	push   %eax
  801f12:	e8 e7 fb ff ff       	call   801afe <getuint>
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801f20:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801f27:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2e:	83 ec 04             	sub    $0x4,%esp
  801f31:	52                   	push   %edx
  801f32:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f35:	50                   	push   %eax
  801f36:	ff 75 f4             	pushl  -0xc(%ebp)
  801f39:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3c:	ff 75 0c             	pushl  0xc(%ebp)
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	e8 00 fb ff ff       	call   801a47 <printnum>
  801f47:	83 c4 20             	add    $0x20,%esp
			break;
  801f4a:	eb 34                	jmp    801f80 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801f4c:	83 ec 08             	sub    $0x8,%esp
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	53                   	push   %ebx
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	ff d0                	call   *%eax
  801f58:	83 c4 10             	add    $0x10,%esp
			break;
  801f5b:	eb 23                	jmp    801f80 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801f5d:	83 ec 08             	sub    $0x8,%esp
  801f60:	ff 75 0c             	pushl  0xc(%ebp)
  801f63:	6a 25                	push   $0x25
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	ff d0                	call   *%eax
  801f6a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801f6d:	ff 4d 10             	decl   0x10(%ebp)
  801f70:	eb 03                	jmp    801f75 <vprintfmt+0x3b1>
  801f72:	ff 4d 10             	decl   0x10(%ebp)
  801f75:	8b 45 10             	mov    0x10(%ebp),%eax
  801f78:	48                   	dec    %eax
  801f79:	8a 00                	mov    (%eax),%al
  801f7b:	3c 25                	cmp    $0x25,%al
  801f7d:	75 f3                	jne    801f72 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801f7f:	90                   	nop
		}
	}
  801f80:	e9 47 fc ff ff       	jmp    801bcc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801f85:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f89:	5b                   	pop    %ebx
  801f8a:	5e                   	pop    %esi
  801f8b:	5d                   	pop    %ebp
  801f8c:	c3                   	ret    

00801f8d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801f93:	8d 45 10             	lea    0x10(%ebp),%eax
  801f96:	83 c0 04             	add    $0x4,%eax
  801f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa2:	50                   	push   %eax
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	e8 16 fc ff ff       	call   801bc4 <vprintfmt>
  801fae:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801fb1:	90                   	nop
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fba:	8b 40 08             	mov    0x8(%eax),%eax
  801fbd:	8d 50 01             	lea    0x1(%eax),%edx
  801fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc9:	8b 10                	mov    (%eax),%edx
  801fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fce:	8b 40 04             	mov    0x4(%eax),%eax
  801fd1:	39 c2                	cmp    %eax,%edx
  801fd3:	73 12                	jae    801fe7 <sprintputch+0x33>
		*b->buf++ = ch;
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	8b 00                	mov    (%eax),%eax
  801fda:	8d 48 01             	lea    0x1(%eax),%ecx
  801fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe0:	89 0a                	mov    %ecx,(%edx)
  801fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe5:	88 10                	mov    %dl,(%eax)
}
  801fe7:	90                   	nop
  801fe8:	5d                   	pop    %ebp
  801fe9:	c3                   	ret    

00801fea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	01 d0                	add    %edx,%eax
  802001:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802004:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80200b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80200f:	74 06                	je     802017 <vsnprintf+0x2d>
  802011:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802015:	7f 07                	jg     80201e <vsnprintf+0x34>
		return -E_INVAL;
  802017:	b8 03 00 00 00       	mov    $0x3,%eax
  80201c:	eb 20                	jmp    80203e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80201e:	ff 75 14             	pushl  0x14(%ebp)
  802021:	ff 75 10             	pushl  0x10(%ebp)
  802024:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802027:	50                   	push   %eax
  802028:	68 b4 1f 80 00       	push   $0x801fb4
  80202d:	e8 92 fb ff ff       	call   801bc4 <vprintfmt>
  802032:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802035:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802038:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802046:	8d 45 10             	lea    0x10(%ebp),%eax
  802049:	83 c0 04             	add    $0x4,%eax
  80204c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80204f:	8b 45 10             	mov    0x10(%ebp),%eax
  802052:	ff 75 f4             	pushl  -0xc(%ebp)
  802055:	50                   	push   %eax
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	ff 75 08             	pushl  0x8(%ebp)
  80205c:	e8 89 ff ff ff       	call   801fea <vsnprintf>
  802061:	83 c4 10             	add    $0x10,%esp
  802064:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802067:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802079:	eb 06                	jmp    802081 <strlen+0x15>
		n++;
  80207b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80207e:	ff 45 08             	incl   0x8(%ebp)
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	8a 00                	mov    (%eax),%al
  802086:	84 c0                	test   %al,%al
  802088:	75 f1                	jne    80207b <strlen+0xf>
		n++;
	return n;
  80208a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80209c:	eb 09                	jmp    8020a7 <strnlen+0x18>
		n++;
  80209e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8020a1:	ff 45 08             	incl   0x8(%ebp)
  8020a4:	ff 4d 0c             	decl   0xc(%ebp)
  8020a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020ab:	74 09                	je     8020b6 <strnlen+0x27>
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8a 00                	mov    (%eax),%al
  8020b2:	84 c0                	test   %al,%al
  8020b4:	75 e8                	jne    80209e <strnlen+0xf>
		n++;
	return n;
  8020b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8020c7:	90                   	nop
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	8d 50 01             	lea    0x1(%eax),%edx
  8020ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8020d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8020d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8020da:	8a 12                	mov    (%edx),%dl
  8020dc:	88 10                	mov    %dl,(%eax)
  8020de:	8a 00                	mov    (%eax),%al
  8020e0:	84 c0                	test   %al,%al
  8020e2:	75 e4                	jne    8020c8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8020e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8020f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8020fc:	eb 1f                	jmp    80211d <strncpy+0x34>
		*dst++ = *src;
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	8d 50 01             	lea    0x1(%eax),%edx
  802104:	89 55 08             	mov    %edx,0x8(%ebp)
  802107:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210a:	8a 12                	mov    (%edx),%dl
  80210c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80210e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802111:	8a 00                	mov    (%eax),%al
  802113:	84 c0                	test   %al,%al
  802115:	74 03                	je     80211a <strncpy+0x31>
			src++;
  802117:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80211a:	ff 45 fc             	incl   -0x4(%ebp)
  80211d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802120:	3b 45 10             	cmp    0x10(%ebp),%eax
  802123:	72 d9                	jb     8020fe <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802125:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802136:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213a:	74 30                	je     80216c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80213c:	eb 16                	jmp    802154 <strlcpy+0x2a>
			*dst++ = *src++;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	8d 50 01             	lea    0x1(%eax),%edx
  802144:	89 55 08             	mov    %edx,0x8(%ebp)
  802147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80214d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802150:	8a 12                	mov    (%edx),%dl
  802152:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802154:	ff 4d 10             	decl   0x10(%ebp)
  802157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80215b:	74 09                	je     802166 <strlcpy+0x3c>
  80215d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802160:	8a 00                	mov    (%eax),%al
  802162:	84 c0                	test   %al,%al
  802164:	75 d8                	jne    80213e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80216c:	8b 55 08             	mov    0x8(%ebp),%edx
  80216f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802172:	29 c2                	sub    %eax,%edx
  802174:	89 d0                	mov    %edx,%eax
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80217b:	eb 06                	jmp    802183 <strcmp+0xb>
		p++, q++;
  80217d:	ff 45 08             	incl   0x8(%ebp)
  802180:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8a 00                	mov    (%eax),%al
  802188:	84 c0                	test   %al,%al
  80218a:	74 0e                	je     80219a <strcmp+0x22>
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	8a 10                	mov    (%eax),%dl
  802191:	8b 45 0c             	mov    0xc(%ebp),%eax
  802194:	8a 00                	mov    (%eax),%al
  802196:	38 c2                	cmp    %al,%dl
  802198:	74 e3                	je     80217d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	8a 00                	mov    (%eax),%al
  80219f:	0f b6 d0             	movzbl %al,%edx
  8021a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a5:	8a 00                	mov    (%eax),%al
  8021a7:	0f b6 c0             	movzbl %al,%eax
  8021aa:	29 c2                	sub    %eax,%edx
  8021ac:	89 d0                	mov    %edx,%eax
}
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    

008021b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8021b3:	eb 09                	jmp    8021be <strncmp+0xe>
		n--, p++, q++;
  8021b5:	ff 4d 10             	decl   0x10(%ebp)
  8021b8:	ff 45 08             	incl   0x8(%ebp)
  8021bb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8021be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021c2:	74 17                	je     8021db <strncmp+0x2b>
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	8a 00                	mov    (%eax),%al
  8021c9:	84 c0                	test   %al,%al
  8021cb:	74 0e                	je     8021db <strncmp+0x2b>
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	8a 10                	mov    (%eax),%dl
  8021d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d5:	8a 00                	mov    (%eax),%al
  8021d7:	38 c2                	cmp    %al,%dl
  8021d9:	74 da                	je     8021b5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8021db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021df:	75 07                	jne    8021e8 <strncmp+0x38>
		return 0;
  8021e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e6:	eb 14                	jmp    8021fc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	8a 00                	mov    (%eax),%al
  8021ed:	0f b6 d0             	movzbl %al,%edx
  8021f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f3:	8a 00                	mov    (%eax),%al
  8021f5:	0f b6 c0             	movzbl %al,%eax
  8021f8:	29 c2                	sub    %eax,%edx
  8021fa:	89 d0                	mov    %edx,%eax
}
  8021fc:	5d                   	pop    %ebp
  8021fd:	c3                   	ret    

008021fe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 04             	sub    $0x4,%esp
  802204:	8b 45 0c             	mov    0xc(%ebp),%eax
  802207:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80220a:	eb 12                	jmp    80221e <strchr+0x20>
		if (*s == c)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8a 00                	mov    (%eax),%al
  802211:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802214:	75 05                	jne    80221b <strchr+0x1d>
			return (char *) s;
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	eb 11                	jmp    80222c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80221b:	ff 45 08             	incl   0x8(%ebp)
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	8a 00                	mov    (%eax),%al
  802223:	84 c0                	test   %al,%al
  802225:	75 e5                	jne    80220c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	8b 45 0c             	mov    0xc(%ebp),%eax
  802237:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80223a:	eb 0d                	jmp    802249 <strfind+0x1b>
		if (*s == c)
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	8a 00                	mov    (%eax),%al
  802241:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802244:	74 0e                	je     802254 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802246:	ff 45 08             	incl   0x8(%ebp)
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	8a 00                	mov    (%eax),%al
  80224e:	84 c0                	test   %al,%al
  802250:	75 ea                	jne    80223c <strfind+0xe>
  802252:	eb 01                	jmp    802255 <strfind+0x27>
		if (*s == c)
			break;
  802254:	90                   	nop
	return (char *) s;
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  802266:	8b 45 10             	mov    0x10(%ebp),%eax
  802269:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80226c:	eb 0e                	jmp    80227c <memset+0x22>
		*p++ = c;
  80226e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802271:	8d 50 01             	lea    0x1(%eax),%edx
  802274:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80227c:	ff 4d f8             	decl   -0x8(%ebp)
  80227f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802283:	79 e9                	jns    80226e <memset+0x14>
		*p++ = c;

	return v;
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
  80228d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802290:	8b 45 0c             	mov    0xc(%ebp),%eax
  802293:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80229c:	eb 16                	jmp    8022b4 <memcpy+0x2a>
		*d++ = *s++;
  80229e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a1:	8d 50 01             	lea    0x1(%eax),%edx
  8022a4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022ad:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8022b0:	8a 12                	mov    (%edx),%dl
  8022b2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8022b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8022bd:	85 c0                	test   %eax,%eax
  8022bf:	75 dd                	jne    80229e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8022cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8022d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022de:	73 50                	jae    802330 <memmove+0x6a>
  8022e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e6:	01 d0                	add    %edx,%eax
  8022e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022eb:	76 43                	jbe    802330 <memmove+0x6a>
		s += n;
  8022ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8022f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8022f9:	eb 10                	jmp    80230b <memmove+0x45>
			*--d = *--s;
  8022fb:	ff 4d f8             	decl   -0x8(%ebp)
  8022fe:	ff 4d fc             	decl   -0x4(%ebp)
  802301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802304:	8a 10                	mov    (%eax),%dl
  802306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802309:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80230b:	8b 45 10             	mov    0x10(%ebp),%eax
  80230e:	8d 50 ff             	lea    -0x1(%eax),%edx
  802311:	89 55 10             	mov    %edx,0x10(%ebp)
  802314:	85 c0                	test   %eax,%eax
  802316:	75 e3                	jne    8022fb <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802318:	eb 23                	jmp    80233d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80231a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80231d:	8d 50 01             	lea    0x1(%eax),%edx
  802320:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802323:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802326:	8d 4a 01             	lea    0x1(%edx),%ecx
  802329:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80232c:	8a 12                	mov    (%edx),%dl
  80232e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802330:	8b 45 10             	mov    0x10(%ebp),%eax
  802333:	8d 50 ff             	lea    -0x1(%eax),%edx
  802336:	89 55 10             	mov    %edx,0x10(%ebp)
  802339:	85 c0                	test   %eax,%eax
  80233b:	75 dd                	jne    80231a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80234e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802351:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802354:	eb 2a                	jmp    802380 <memcmp+0x3e>
		if (*s1 != *s2)
  802356:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802359:	8a 10                	mov    (%eax),%dl
  80235b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80235e:	8a 00                	mov    (%eax),%al
  802360:	38 c2                	cmp    %al,%dl
  802362:	74 16                	je     80237a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802364:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802367:	8a 00                	mov    (%eax),%al
  802369:	0f b6 d0             	movzbl %al,%edx
  80236c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80236f:	8a 00                	mov    (%eax),%al
  802371:	0f b6 c0             	movzbl %al,%eax
  802374:	29 c2                	sub    %eax,%edx
  802376:	89 d0                	mov    %edx,%eax
  802378:	eb 18                	jmp    802392 <memcmp+0x50>
		s1++, s2++;
  80237a:	ff 45 fc             	incl   -0x4(%ebp)
  80237d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802380:	8b 45 10             	mov    0x10(%ebp),%eax
  802383:	8d 50 ff             	lea    -0x1(%eax),%edx
  802386:	89 55 10             	mov    %edx,0x10(%ebp)
  802389:	85 c0                	test   %eax,%eax
  80238b:	75 c9                	jne    802356 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80238d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80239a:	8b 55 08             	mov    0x8(%ebp),%edx
  80239d:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a0:	01 d0                	add    %edx,%eax
  8023a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8023a5:	eb 15                	jmp    8023bc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	8a 00                	mov    (%eax),%al
  8023ac:	0f b6 d0             	movzbl %al,%edx
  8023af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b2:	0f b6 c0             	movzbl %al,%eax
  8023b5:	39 c2                	cmp    %eax,%edx
  8023b7:	74 0d                	je     8023c6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8023b9:	ff 45 08             	incl   0x8(%ebp)
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8023c2:	72 e3                	jb     8023a7 <memfind+0x13>
  8023c4:	eb 01                	jmp    8023c7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8023c6:	90                   	nop
	return (void *) s;
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8023d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8023d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023e0:	eb 03                	jmp    8023e5 <strtol+0x19>
		s++;
  8023e2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8a 00                	mov    (%eax),%al
  8023ea:	3c 20                	cmp    $0x20,%al
  8023ec:	74 f4                	je     8023e2 <strtol+0x16>
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	8a 00                	mov    (%eax),%al
  8023f3:	3c 09                	cmp    $0x9,%al
  8023f5:	74 eb                	je     8023e2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	8a 00                	mov    (%eax),%al
  8023fc:	3c 2b                	cmp    $0x2b,%al
  8023fe:	75 05                	jne    802405 <strtol+0x39>
		s++;
  802400:	ff 45 08             	incl   0x8(%ebp)
  802403:	eb 13                	jmp    802418 <strtol+0x4c>
	else if (*s == '-')
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	8a 00                	mov    (%eax),%al
  80240a:	3c 2d                	cmp    $0x2d,%al
  80240c:	75 0a                	jne    802418 <strtol+0x4c>
		s++, neg = 1;
  80240e:	ff 45 08             	incl   0x8(%ebp)
  802411:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802418:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80241c:	74 06                	je     802424 <strtol+0x58>
  80241e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802422:	75 20                	jne    802444 <strtol+0x78>
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	8a 00                	mov    (%eax),%al
  802429:	3c 30                	cmp    $0x30,%al
  80242b:	75 17                	jne    802444 <strtol+0x78>
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	40                   	inc    %eax
  802431:	8a 00                	mov    (%eax),%al
  802433:	3c 78                	cmp    $0x78,%al
  802435:	75 0d                	jne    802444 <strtol+0x78>
		s += 2, base = 16;
  802437:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80243b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802442:	eb 28                	jmp    80246c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802444:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802448:	75 15                	jne    80245f <strtol+0x93>
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	8a 00                	mov    (%eax),%al
  80244f:	3c 30                	cmp    $0x30,%al
  802451:	75 0c                	jne    80245f <strtol+0x93>
		s++, base = 8;
  802453:	ff 45 08             	incl   0x8(%ebp)
  802456:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80245d:	eb 0d                	jmp    80246c <strtol+0xa0>
	else if (base == 0)
  80245f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802463:	75 07                	jne    80246c <strtol+0xa0>
		base = 10;
  802465:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	8a 00                	mov    (%eax),%al
  802471:	3c 2f                	cmp    $0x2f,%al
  802473:	7e 19                	jle    80248e <strtol+0xc2>
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	8a 00                	mov    (%eax),%al
  80247a:	3c 39                	cmp    $0x39,%al
  80247c:	7f 10                	jg     80248e <strtol+0xc2>
			dig = *s - '0';
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	8a 00                	mov    (%eax),%al
  802483:	0f be c0             	movsbl %al,%eax
  802486:	83 e8 30             	sub    $0x30,%eax
  802489:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248c:	eb 42                	jmp    8024d0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	8a 00                	mov    (%eax),%al
  802493:	3c 60                	cmp    $0x60,%al
  802495:	7e 19                	jle    8024b0 <strtol+0xe4>
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	8a 00                	mov    (%eax),%al
  80249c:	3c 7a                	cmp    $0x7a,%al
  80249e:	7f 10                	jg     8024b0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	8a 00                	mov    (%eax),%al
  8024a5:	0f be c0             	movsbl %al,%eax
  8024a8:	83 e8 57             	sub    $0x57,%eax
  8024ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ae:	eb 20                	jmp    8024d0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	8a 00                	mov    (%eax),%al
  8024b5:	3c 40                	cmp    $0x40,%al
  8024b7:	7e 39                	jle    8024f2 <strtol+0x126>
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	8a 00                	mov    (%eax),%al
  8024be:	3c 5a                	cmp    $0x5a,%al
  8024c0:	7f 30                	jg     8024f2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	8a 00                	mov    (%eax),%al
  8024c7:	0f be c0             	movsbl %al,%eax
  8024ca:	83 e8 37             	sub    $0x37,%eax
  8024cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8024d6:	7d 19                	jge    8024f1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8024d8:	ff 45 08             	incl   0x8(%ebp)
  8024db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024de:	0f af 45 10          	imul   0x10(%ebp),%eax
  8024e2:	89 c2                	mov    %eax,%edx
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	01 d0                	add    %edx,%eax
  8024e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8024ec:	e9 7b ff ff ff       	jmp    80246c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8024f1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8024f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024f6:	74 08                	je     802500 <strtol+0x134>
		*endptr = (char *) s;
  8024f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fe:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802500:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802504:	74 07                	je     80250d <strtol+0x141>
  802506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802509:	f7 d8                	neg    %eax
  80250b:	eb 03                	jmp    802510 <strtol+0x144>
  80250d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <ltostr>:

void
ltostr(long value, char *str)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
  802515:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80251f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802526:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80252a:	79 13                	jns    80253f <ltostr+0x2d>
	{
		neg = 1;
  80252c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802533:	8b 45 0c             	mov    0xc(%ebp),%eax
  802536:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802539:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80253c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802547:	99                   	cltd   
  802548:	f7 f9                	idiv   %ecx
  80254a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80254d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802550:	8d 50 01             	lea    0x1(%eax),%edx
  802553:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802556:	89 c2                	mov    %eax,%edx
  802558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255b:	01 d0                	add    %edx,%eax
  80255d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802560:	83 c2 30             	add    $0x30,%edx
  802563:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802565:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802568:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80256d:	f7 e9                	imul   %ecx
  80256f:	c1 fa 02             	sar    $0x2,%edx
  802572:	89 c8                	mov    %ecx,%eax
  802574:	c1 f8 1f             	sar    $0x1f,%eax
  802577:	29 c2                	sub    %eax,%edx
  802579:	89 d0                	mov    %edx,%eax
  80257b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80257e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802581:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802586:	f7 e9                	imul   %ecx
  802588:	c1 fa 02             	sar    $0x2,%edx
  80258b:	89 c8                	mov    %ecx,%eax
  80258d:	c1 f8 1f             	sar    $0x1f,%eax
  802590:	29 c2                	sub    %eax,%edx
  802592:	89 d0                	mov    %edx,%eax
  802594:	c1 e0 02             	shl    $0x2,%eax
  802597:	01 d0                	add    %edx,%eax
  802599:	01 c0                	add    %eax,%eax
  80259b:	29 c1                	sub    %eax,%ecx
  80259d:	89 ca                	mov    %ecx,%edx
  80259f:	85 d2                	test   %edx,%edx
  8025a1:	75 9c                	jne    80253f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8025a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8025aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025ad:	48                   	dec    %eax
  8025ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8025b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025b5:	74 3d                	je     8025f4 <ltostr+0xe2>
		start = 1 ;
  8025b7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8025be:	eb 34                	jmp    8025f4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8025c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c6:	01 d0                	add    %edx,%eax
  8025c8:	8a 00                	mov    (%eax),%al
  8025ca:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8025cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d3:	01 c2                	add    %eax,%edx
  8025d5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025db:	01 c8                	add    %ecx,%eax
  8025dd:	8a 00                	mov    (%eax),%al
  8025df:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8025e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e7:	01 c2                	add    %eax,%edx
  8025e9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8025ec:	88 02                	mov    %al,(%edx)
		start++ ;
  8025ee:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8025f1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025fa:	7c c4                	jl     8025c0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8025fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8025ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802602:	01 d0                	add    %edx,%eax
  802604:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802607:	90                   	nop
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802610:	ff 75 08             	pushl  0x8(%ebp)
  802613:	e8 54 fa ff ff       	call   80206c <strlen>
  802618:	83 c4 04             	add    $0x4,%esp
  80261b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80261e:	ff 75 0c             	pushl  0xc(%ebp)
  802621:	e8 46 fa ff ff       	call   80206c <strlen>
  802626:	83 c4 04             	add    $0x4,%esp
  802629:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80262c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80263a:	eb 17                	jmp    802653 <strcconcat+0x49>
		final[s] = str1[s] ;
  80263c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80263f:	8b 45 10             	mov    0x10(%ebp),%eax
  802642:	01 c2                	add    %eax,%edx
  802644:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	01 c8                	add    %ecx,%eax
  80264c:	8a 00                	mov    (%eax),%al
  80264e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802650:	ff 45 fc             	incl   -0x4(%ebp)
  802653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802656:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802659:	7c e1                	jl     80263c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80265b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802662:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802669:	eb 1f                	jmp    80268a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80266b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80266e:	8d 50 01             	lea    0x1(%eax),%edx
  802671:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802674:	89 c2                	mov    %eax,%edx
  802676:	8b 45 10             	mov    0x10(%ebp),%eax
  802679:	01 c2                	add    %eax,%edx
  80267b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80267e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802681:	01 c8                	add    %ecx,%eax
  802683:	8a 00                	mov    (%eax),%al
  802685:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802687:	ff 45 f8             	incl   -0x8(%ebp)
  80268a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80268d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802690:	7c d9                	jl     80266b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802692:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802695:	8b 45 10             	mov    0x10(%ebp),%eax
  802698:	01 d0                	add    %edx,%eax
  80269a:	c6 00 00             	movb   $0x0,(%eax)
}
  80269d:	90                   	nop
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8026a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8026a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8026ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8026bb:	01 d0                	add    %edx,%eax
  8026bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8026c3:	eb 0c                	jmp    8026d1 <strsplit+0x31>
			*string++ = 0;
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	8d 50 01             	lea    0x1(%eax),%edx
  8026cb:	89 55 08             	mov    %edx,0x8(%ebp)
  8026ce:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8026d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d4:	8a 00                	mov    (%eax),%al
  8026d6:	84 c0                	test   %al,%al
  8026d8:	74 18                	je     8026f2 <strsplit+0x52>
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	8a 00                	mov    (%eax),%al
  8026df:	0f be c0             	movsbl %al,%eax
  8026e2:	50                   	push   %eax
  8026e3:	ff 75 0c             	pushl  0xc(%ebp)
  8026e6:	e8 13 fb ff ff       	call   8021fe <strchr>
  8026eb:	83 c4 08             	add    $0x8,%esp
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	75 d3                	jne    8026c5 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	8a 00                	mov    (%eax),%al
  8026f7:	84 c0                	test   %al,%al
  8026f9:	74 5a                	je     802755 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  8026fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	83 f8 0f             	cmp    $0xf,%eax
  802703:	75 07                	jne    80270c <strsplit+0x6c>
		{
			return 0;
  802705:	b8 00 00 00 00       	mov    $0x0,%eax
  80270a:	eb 66                	jmp    802772 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80270c:	8b 45 14             	mov    0x14(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	8d 48 01             	lea    0x1(%eax),%ecx
  802714:	8b 55 14             	mov    0x14(%ebp),%edx
  802717:	89 0a                	mov    %ecx,(%edx)
  802719:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802720:	8b 45 10             	mov    0x10(%ebp),%eax
  802723:	01 c2                	add    %eax,%edx
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80272a:	eb 03                	jmp    80272f <strsplit+0x8f>
			string++;
  80272c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80272f:	8b 45 08             	mov    0x8(%ebp),%eax
  802732:	8a 00                	mov    (%eax),%al
  802734:	84 c0                	test   %al,%al
  802736:	74 8b                	je     8026c3 <strsplit+0x23>
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	8a 00                	mov    (%eax),%al
  80273d:	0f be c0             	movsbl %al,%eax
  802740:	50                   	push   %eax
  802741:	ff 75 0c             	pushl  0xc(%ebp)
  802744:	e8 b5 fa ff ff       	call   8021fe <strchr>
  802749:	83 c4 08             	add    $0x8,%esp
  80274c:	85 c0                	test   %eax,%eax
  80274e:	74 dc                	je     80272c <strsplit+0x8c>
			string++;
	}
  802750:	e9 6e ff ff ff       	jmp    8026c3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802755:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802756:	8b 45 14             	mov    0x14(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802762:	8b 45 10             	mov    0x10(%ebp),%eax
  802765:	01 d0                	add    %edx,%eax
  802767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80276d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  80277d:	e8 7d 0f 00 00       	call   8036ff <sys_isUHeapPlacementStrategyNEXTFIT>
  802782:	85 c0                	test   %eax,%eax
  802784:	0f 84 6f 03 00 00    	je     802af9 <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  80278a:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  802791:	8b 55 08             	mov    0x8(%ebp),%edx
  802794:	8b 45 84             	mov    -0x7c(%ebp),%eax
  802797:	01 d0                	add    %edx,%eax
  802799:	48                   	dec    %eax
  80279a:	89 45 80             	mov    %eax,-0x80(%ebp)
  80279d:	8b 45 80             	mov    -0x80(%ebp),%eax
  8027a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a5:	f7 75 84             	divl   -0x7c(%ebp)
  8027a8:	8b 45 80             	mov    -0x80(%ebp),%eax
  8027ab:	29 d0                	sub    %edx,%eax
  8027ad:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8027b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b4:	74 09                	je     8027bf <malloc+0x4b>
  8027b6:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8027bd:	76 0a                	jbe    8027c9 <malloc+0x55>
			return NULL;
  8027bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c4:	e9 4b 09 00 00       	jmp    803114 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  8027c9:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	01 d0                	add    %edx,%eax
  8027d4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8027d9:	0f 87 a2 00 00 00    	ja     802881 <malloc+0x10d>
  8027df:	a1 40 50 98 00       	mov    0x985040,%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	0f 85 95 00 00 00    	jne    802881 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  8027ec:	a1 04 50 80 00       	mov    0x805004,%eax
  8027f1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  8027f7:	a1 04 50 80 00       	mov    0x805004,%eax
  8027fc:	83 ec 08             	sub    $0x8,%esp
  8027ff:	ff 75 08             	pushl  0x8(%ebp)
  802802:	50                   	push   %eax
  802803:	e8 a3 0b 00 00       	call   8033ab <sys_allocateMem>
  802808:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  80280b:	a1 20 50 80 00       	mov    0x805020,%eax
  802810:	8b 55 08             	mov    0x8(%ebp),%edx
  802813:	89 14 c5 44 50 88 00 	mov    %edx,0x885044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80281a:	a1 20 50 80 00       	mov    0x805020,%eax
  80281f:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802825:	89 14 c5 40 50 88 00 	mov    %edx,0x885040(,%eax,8)
			cnt_mem++;
  80282c:	a1 20 50 80 00       	mov    0x805020,%eax
  802831:	40                   	inc    %eax
  802832:	a3 20 50 80 00       	mov    %eax,0x805020
			int i = 0;
  802837:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  80283e:	eb 2e                	jmp    80286e <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802840:	a1 04 50 80 00       	mov    0x805004,%eax
  802845:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  80284a:	c1 e8 0c             	shr    $0xc,%eax
  80284d:	c7 04 85 40 50 80 00 	movl   $0x1,0x805040(,%eax,4)
  802854:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  802858:	a1 04 50 80 00       	mov    0x805004,%eax
  80285d:	05 00 10 00 00       	add    $0x1000,%eax
  802862:	a3 04 50 80 00       	mov    %eax,0x805004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  802867:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	3b 45 08             	cmp    0x8(%ebp),%eax
  802874:	72 ca                	jb     802840 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  802876:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80287c:	e9 93 08 00 00       	jmp    803114 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  802881:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  802888:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  80288f:	a1 40 50 98 00       	mov    0x985040,%eax
  802894:	85 c0                	test   %eax,%eax
  802896:	75 1d                	jne    8028b5 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  802898:	c7 05 04 50 80 00 00 	movl   $0x80000000,0x805004
  80289f:	00 00 80 
				check = 1;
  8028a2:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8028a9:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  8028ac:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  8028b3:	eb 08                	jmp    8028bd <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  8028b5:	a1 04 50 80 00       	mov    0x805004,%eax
  8028ba:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  8028bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  8028c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  8028cb:	a1 04 50 80 00       	mov    0x805004,%eax
  8028d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  8028d3:	eb 4d                	jmp    802922 <malloc+0x1ae>
				if (sz == size) {
  8028d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028db:	75 09                	jne    8028e6 <malloc+0x172>
					f = 1;
  8028dd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8028e4:	eb 45                	jmp    80292b <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8028e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e9:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  8028ee:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  8028f1:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	75 10                	jne    80290c <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  8028fc:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  802903:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  80290a:	eb 16                	jmp    802922 <malloc+0x1ae>
				} else {
					sz = 0;
  80290c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  802913:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  80291a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291d:	a3 04 50 80 00       	mov    %eax,0x805004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  802922:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  802929:	76 aa                	jbe    8028d5 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  80292b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80292f:	0f 84 95 00 00 00    	je     8029ca <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  802935:	a1 04 50 80 00       	mov    0x805004,%eax
  80293a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  802940:	a1 04 50 80 00       	mov    0x805004,%eax
  802945:	83 ec 08             	sub    $0x8,%esp
  802948:	ff 75 08             	pushl  0x8(%ebp)
  80294b:	50                   	push   %eax
  80294c:	e8 5a 0a 00 00       	call   8033ab <sys_allocateMem>
  802951:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802954:	a1 20 50 80 00       	mov    0x805020,%eax
  802959:	8b 55 08             	mov    0x8(%ebp),%edx
  80295c:	89 14 c5 44 50 88 00 	mov    %edx,0x885044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802963:	a1 20 50 80 00       	mov    0x805020,%eax
  802968:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80296e:	89 14 c5 40 50 88 00 	mov    %edx,0x885040(,%eax,8)
				cnt_mem++;
  802975:	a1 20 50 80 00       	mov    0x805020,%eax
  80297a:	40                   	inc    %eax
  80297b:	a3 20 50 80 00       	mov    %eax,0x805020
				int i = 0;
  802980:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802987:	eb 2e                	jmp    8029b7 <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802989:	a1 04 50 80 00       	mov    0x805004,%eax
  80298e:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802993:	c1 e8 0c             	shr    $0xc,%eax
  802996:	c7 04 85 40 50 80 00 	movl   $0x1,0x805040(,%eax,4)
  80299d:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  8029a1:	a1 04 50 80 00       	mov    0x805004,%eax
  8029a6:	05 00 10 00 00       	add    $0x1000,%eax
  8029ab:	a3 04 50 80 00       	mov    %eax,0x805004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8029b0:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  8029b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029bd:	72 ca                	jb     802989 <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  8029bf:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8029c5:	e9 4a 07 00 00       	jmp    803114 <malloc+0x9a0>

			} else {

				if (check_start) {
  8029ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ce:	74 0a                	je     8029da <malloc+0x266>

					return NULL;
  8029d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d5:	e9 3a 07 00 00       	jmp    803114 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  8029da:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  8029e1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  8029e8:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  8029ef:	c7 05 04 50 80 00 00 	movl   $0x80000000,0x805004
  8029f6:	00 00 80 
				while (ptr < (uint32) temp_end) {
  8029f9:	eb 4d                	jmp    802a48 <malloc+0x2d4>
					if (sz == size) {
  8029fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a01:	75 09                	jne    802a0c <malloc+0x298>
						f = 1;
  802a03:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  802a0a:	eb 44                	jmp    802a50 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802a0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a0f:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  802a14:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802a17:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	75 10                	jne    802a32 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  802a22:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  802a29:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  802a30:	eb 16                	jmp    802a48 <malloc+0x2d4>
					} else {
						sz = 0;
  802a32:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  802a39:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  802a40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a43:	a3 04 50 80 00       	mov    %eax,0x805004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  802a4e:	72 ab                	jb     8029fb <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  802a50:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a54:	0f 84 95 00 00 00    	je     802aef <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  802a5a:	a1 04 50 80 00       	mov    0x805004,%eax
  802a5f:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  802a65:	a1 04 50 80 00       	mov    0x805004,%eax
  802a6a:	83 ec 08             	sub    $0x8,%esp
  802a6d:	ff 75 08             	pushl  0x8(%ebp)
  802a70:	50                   	push   %eax
  802a71:	e8 35 09 00 00       	call   8033ab <sys_allocateMem>
  802a76:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  802a79:	a1 20 50 80 00       	mov    0x805020,%eax
  802a7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a81:	89 14 c5 44 50 88 00 	mov    %edx,0x885044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802a88:	a1 20 50 80 00       	mov    0x805020,%eax
  802a8d:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802a93:	89 14 c5 40 50 88 00 	mov    %edx,0x885040(,%eax,8)
					cnt_mem++;
  802a9a:	a1 20 50 80 00       	mov    0x805020,%eax
  802a9f:	40                   	inc    %eax
  802aa0:	a3 20 50 80 00       	mov    %eax,0x805020
					int i = 0;
  802aa5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  802aac:	eb 2e                	jmp    802adc <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  802aae:	a1 04 50 80 00       	mov    0x805004,%eax
  802ab3:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  802ab8:	c1 e8 0c             	shr    $0xc,%eax
  802abb:	c7 04 85 40 50 80 00 	movl   $0x1,0x805040(,%eax,4)
  802ac2:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  802ac6:	a1 04 50 80 00       	mov    0x805004,%eax
  802acb:	05 00 10 00 00       	add    $0x1000,%eax
  802ad0:	a3 04 50 80 00       	mov    %eax,0x805004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  802ad5:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  802adc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802adf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae2:	72 ca                	jb     802aae <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  802ae4:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  802aea:	e9 25 06 00 00       	jmp    803114 <malloc+0x9a0>

				} else {

					return NULL;
  802aef:	b8 00 00 00 00       	mov    $0x0,%eax
  802af4:	e9 1b 06 00 00       	jmp    803114 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  802af9:	e8 d0 0b 00 00       	call   8036ce <sys_isUHeapPlacementStrategyBESTFIT>
  802afe:	85 c0                	test   %eax,%eax
  802b00:	0f 84 ba 01 00 00    	je     802cc0 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  802b06:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  802b0d:	10 00 00 
  802b10:	8b 55 08             	mov    0x8(%ebp),%edx
  802b13:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  802b19:	01 d0                	add    %edx,%eax
  802b1b:	48                   	dec    %eax
  802b1c:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  802b22:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  802b28:	ba 00 00 00 00       	mov    $0x0,%edx
  802b2d:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  802b33:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  802b39:	29 d0                	sub    %edx,%eax
  802b3b:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802b3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b42:	74 09                	je     802b4d <malloc+0x3d9>
  802b44:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802b4b:	76 0a                	jbe    802b57 <malloc+0x3e3>
			return NULL;
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b52:	e9 bd 05 00 00       	jmp    803114 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  802b57:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  802b5e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  802b65:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  802b6c:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  802b73:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	c1 e8 0c             	shr    $0xc,%eax
  802b80:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  802b86:	e9 80 00 00 00       	jmp    802c0b <malloc+0x497>

			if (heap_mem[i] == 0) {
  802b8b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b8e:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	75 0c                	jne    802ba5 <malloc+0x431>

				count++;
  802b99:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  802b9c:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  802ba3:	eb 2d                	jmp    802bd2 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  802ba5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  802bab:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  802bae:	77 14                	ja     802bc4 <malloc+0x450>
  802bb0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bb3:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  802bb6:	76 0c                	jbe    802bc4 <malloc+0x450>

					min_sz = count;
  802bb8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  802bbe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bc1:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  802bc4:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  802bcb:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  802bd2:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  802bd9:	75 2d                	jne    802c08 <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  802bdb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  802be1:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  802be4:	77 22                	ja     802c08 <malloc+0x494>
  802be6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802be9:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  802bec:	76 1a                	jbe    802c08 <malloc+0x494>

					min_sz = count;
  802bee:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bf1:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  802bf4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bf7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  802bfa:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  802c01:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  802c08:	ff 45 b8             	incl   -0x48(%ebp)
  802c0b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c0e:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802c13:	0f 86 72 ff ff ff    	jbe    802b8b <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  802c19:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  802c1f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  802c22:	77 06                	ja     802c2a <malloc+0x4b6>
  802c24:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802c28:	75 0a                	jne    802c34 <malloc+0x4c0>
			return NULL;
  802c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2f:	e9 e0 04 00 00       	jmp    803114 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  802c34:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c37:	c1 e0 0c             	shl    $0xc,%eax
  802c3a:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  802c3d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c40:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  802c46:	83 ec 08             	sub    $0x8,%esp
  802c49:	ff 75 08             	pushl  0x8(%ebp)
  802c4c:	ff 75 c4             	pushl  -0x3c(%ebp)
  802c4f:	e8 57 07 00 00       	call   8033ab <sys_allocateMem>
  802c54:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802c57:	a1 20 50 80 00       	mov    0x805020,%eax
  802c5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5f:	89 14 c5 44 50 88 00 	mov    %edx,0x885044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  802c66:	a1 20 50 80 00       	mov    0x805020,%eax
  802c6b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802c6e:	89 14 c5 40 50 88 00 	mov    %edx,0x885040(,%eax,8)
		cnt_mem++;
  802c75:	a1 20 50 80 00       	mov    0x805020,%eax
  802c7a:	40                   	inc    %eax
  802c7b:	a3 20 50 80 00       	mov    %eax,0x805020
		i = 0;
  802c80:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802c87:	eb 24                	jmp    802cad <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802c89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c8c:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802c91:	c1 e8 0c             	shr    $0xc,%eax
  802c94:	c7 04 85 40 50 80 00 	movl   $0x1,0x805040(,%eax,4)
  802c9b:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802c9f:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802ca6:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  802cad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cb0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb3:	72 d4                	jb     802c89 <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  802cb5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802cbb:	e9 54 04 00 00       	jmp    803114 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  802cc0:	e8 d8 09 00 00       	call   80369d <sys_isUHeapPlacementStrategyFIRSTFIT>
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	0f 84 88 01 00 00    	je     802e55 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  802ccd:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  802cd4:	10 00 00 
  802cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cda:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  802ce0:	01 d0                	add    %edx,%eax
  802ce2:	48                   	dec    %eax
  802ce3:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  802ce9:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  802cef:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf4:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  802cfa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  802d00:	29 d0                	sub    %edx,%eax
  802d02:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802d05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d09:	74 09                	je     802d14 <malloc+0x5a0>
  802d0b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802d12:	76 0a                	jbe    802d1e <malloc+0x5aa>
			return NULL;
  802d14:	b8 00 00 00 00       	mov    $0x0,%eax
  802d19:	e9 f6 03 00 00       	jmp    803114 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  802d1e:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  802d25:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  802d2c:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  802d33:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  802d3a:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	c1 e8 0c             	shr    $0xc,%eax
  802d47:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  802d4d:	eb 5a                	jmp    802da9 <malloc+0x635>

			if (heap_mem[i] == 0) {
  802d4f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d52:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	75 0c                	jne    802d69 <malloc+0x5f5>

				count++;
  802d5d:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  802d60:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  802d67:	eb 22                	jmp    802d8b <malloc+0x617>
			} else {
				if (num_p <= count) {
  802d69:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d6f:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  802d72:	77 09                	ja     802d7d <malloc+0x609>

					found = 1;
  802d74:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  802d7b:	eb 36                	jmp    802db3 <malloc+0x63f>
				}
				count = 0;
  802d7d:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  802d84:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  802d8b:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  802d92:	75 12                	jne    802da6 <malloc+0x632>

				if (num_p <= count) {
  802d94:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d9a:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  802d9d:	77 07                	ja     802da6 <malloc+0x632>

					found = 1;
  802d9f:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  802da6:	ff 45 a4             	incl   -0x5c(%ebp)
  802da9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802dac:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802db1:	76 9c                	jbe    802d4f <malloc+0x5db>

			}

		}

		if (!found) {
  802db3:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  802db7:	75 0a                	jne    802dc3 <malloc+0x64f>
			return NULL;
  802db9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbe:	e9 51 03 00 00       	jmp    803114 <malloc+0x9a0>

		}

		temp = ptr;
  802dc3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dc6:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  802dc9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dcc:	c1 e0 0c             	shl    $0xc,%eax
  802dcf:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  802dd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dd5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  802ddb:	83 ec 08             	sub    $0x8,%esp
  802dde:	ff 75 08             	pushl  0x8(%ebp)
  802de1:	ff 75 b0             	pushl  -0x50(%ebp)
  802de4:	e8 c2 05 00 00       	call   8033ab <sys_allocateMem>
  802de9:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802dec:	a1 20 50 80 00       	mov    0x805020,%eax
  802df1:	8b 55 08             	mov    0x8(%ebp),%edx
  802df4:	89 14 c5 44 50 88 00 	mov    %edx,0x885044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  802dfb:	a1 20 50 80 00       	mov    0x805020,%eax
  802e00:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e03:	89 14 c5 40 50 88 00 	mov    %edx,0x885040(,%eax,8)
		cnt_mem++;
  802e0a:	a1 20 50 80 00       	mov    0x805020,%eax
  802e0f:	40                   	inc    %eax
  802e10:	a3 20 50 80 00       	mov    %eax,0x805020
		i = 0;
  802e15:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802e1c:	eb 24                	jmp    802e42 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802e1e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e21:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802e26:	c1 e8 0c             	shr    $0xc,%eax
  802e29:	c7 04 85 40 50 80 00 	movl   $0x1,0x805040(,%eax,4)
  802e30:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802e34:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802e3b:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  802e42:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e45:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e48:	72 d4                	jb     802e1e <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  802e4a:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  802e50:	e9 bf 02 00 00       	jmp    803114 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  802e55:	e8 d6 08 00 00       	call   803730 <sys_isUHeapPlacementStrategyWORSTFIT>
  802e5a:	85 c0                	test   %eax,%eax
  802e5c:	0f 84 ba 01 00 00    	je     80301c <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  802e62:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  802e69:	10 00 00 
  802e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802e75:	01 d0                	add    %edx,%eax
  802e77:	48                   	dec    %eax
  802e78:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802e7e:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802e84:	ba 00 00 00 00       	mov    $0x0,%edx
  802e89:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802e8f:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802e95:	29 d0                	sub    %edx,%eax
  802e97:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802e9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9e:	74 09                	je     802ea9 <malloc+0x735>
  802ea0:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802ea7:	76 0a                	jbe    802eb3 <malloc+0x73f>
					return NULL;
  802ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  802eae:	e9 61 02 00 00       	jmp    803114 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  802eb3:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  802eba:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  802ec1:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  802ec8:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  802ecf:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	c1 e8 0c             	shr    $0xc,%eax
  802edc:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802ee2:	e9 80 00 00 00       	jmp    802f67 <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  802ee7:	8b 45 90             	mov    -0x70(%ebp),%eax
  802eea:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  802ef1:	85 c0                	test   %eax,%eax
  802ef3:	75 0c                	jne    802f01 <malloc+0x78d>

						count++;
  802ef5:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  802ef8:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  802eff:	eb 2d                	jmp    802f2e <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  802f01:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802f07:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802f0a:	77 14                	ja     802f20 <malloc+0x7ac>
  802f0c:	8b 45 98             	mov    -0x68(%ebp),%eax
  802f0f:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802f12:	73 0c                	jae    802f20 <malloc+0x7ac>

							max_sz = count;
  802f14:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802f17:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802f1a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f1d:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  802f20:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  802f27:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  802f2e:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  802f35:	75 2d                	jne    802f64 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  802f37:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802f3d:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802f40:	77 22                	ja     802f64 <malloc+0x7f0>
  802f42:	8b 45 98             	mov    -0x68(%ebp),%eax
  802f45:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802f48:	76 1a                	jbe    802f64 <malloc+0x7f0>

							max_sz = count;
  802f4a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802f4d:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802f50:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f53:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  802f56:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  802f5d:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802f64:	ff 45 90             	incl   -0x70(%ebp)
  802f67:	8b 45 90             	mov    -0x70(%ebp),%eax
  802f6a:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802f6f:	0f 86 72 ff ff ff    	jbe    802ee7 <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  802f75:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802f7b:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802f7e:	77 06                	ja     802f86 <malloc+0x812>
  802f80:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802f84:	75 0a                	jne    802f90 <malloc+0x81c>
					return NULL;
  802f86:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8b:	e9 84 01 00 00       	jmp    803114 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802f90:	8b 45 98             	mov    -0x68(%ebp),%eax
  802f93:	c1 e0 0c             	shl    $0xc,%eax
  802f96:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  802f99:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802f9c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  802fa2:	83 ec 08             	sub    $0x8,%esp
  802fa5:	ff 75 08             	pushl  0x8(%ebp)
  802fa8:	ff 75 9c             	pushl  -0x64(%ebp)
  802fab:	e8 fb 03 00 00       	call   8033ab <sys_allocateMem>
  802fb0:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802fb3:	a1 20 50 80 00       	mov    0x805020,%eax
  802fb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbb:	89 14 c5 44 50 88 00 	mov    %edx,0x885044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  802fc2:	a1 20 50 80 00       	mov    0x805020,%eax
  802fc7:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802fca:	89 14 c5 40 50 88 00 	mov    %edx,0x885040(,%eax,8)
				cnt_mem++;
  802fd1:	a1 20 50 80 00       	mov    0x805020,%eax
  802fd6:	40                   	inc    %eax
  802fd7:	a3 20 50 80 00       	mov    %eax,0x805020
				i = 0;
  802fdc:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802fe3:	eb 24                	jmp    803009 <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802fe5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802fe8:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802fed:	c1 e8 0c             	shr    $0xc,%eax
  802ff0:	c7 04 85 40 50 80 00 	movl   $0x1,0x805040(,%eax,4)
  802ff7:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  802ffb:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  803002:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  803009:	8b 45 90             	mov    -0x70(%ebp),%eax
  80300c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300f:	72 d4                	jb     802fe5 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  803011:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  803017:	e9 f8 00 00 00       	jmp    803114 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  80301c:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  803023:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  80302a:	10 00 00 
  80302d:	8b 55 08             	mov    0x8(%ebp),%edx
  803030:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  803036:	01 d0                	add    %edx,%eax
  803038:	48                   	dec    %eax
  803039:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  80303f:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  803045:	ba 00 00 00 00       	mov    $0x0,%edx
  80304a:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  803050:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  803056:	29 d0                	sub    %edx,%eax
  803058:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80305b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305f:	74 09                	je     80306a <malloc+0x8f6>
  803061:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  803068:	76 0a                	jbe    803074 <malloc+0x900>
		return NULL;
  80306a:	b8 00 00 00 00       	mov    $0x0,%eax
  80306f:	e9 a0 00 00 00       	jmp    803114 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  803074:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	01 d0                	add    %edx,%eax
  80307f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  803084:	0f 87 87 00 00 00    	ja     803111 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80308a:	a1 04 50 80 00       	mov    0x805004,%eax
  80308f:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  803092:	a1 04 50 80 00       	mov    0x805004,%eax
  803097:	83 ec 08             	sub    $0x8,%esp
  80309a:	ff 75 08             	pushl  0x8(%ebp)
  80309d:	50                   	push   %eax
  80309e:	e8 08 03 00 00       	call   8033ab <sys_allocateMem>
  8030a3:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8030a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8030ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ae:	89 14 c5 44 50 88 00 	mov    %edx,0x885044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8030b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8030ba:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8030c0:	89 14 c5 40 50 88 00 	mov    %edx,0x885040(,%eax,8)
		cnt_mem++;
  8030c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8030cc:	40                   	inc    %eax
  8030cd:	a3 20 50 80 00       	mov    %eax,0x805020
		int i = 0;
  8030d2:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8030d9:	eb 2e                	jmp    803109 <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8030db:	a1 04 50 80 00       	mov    0x805004,%eax
  8030e0:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8030e5:	c1 e8 0c             	shr    $0xc,%eax
  8030e8:	c7 04 85 40 50 80 00 	movl   $0x1,0x805040(,%eax,4)
  8030ef:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8030f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8030f8:	05 00 10 00 00       	add    $0x1000,%eax
  8030fd:	a3 04 50 80 00       	mov    %eax,0x805004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  803102:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  803109:	8b 45 88             	mov    -0x78(%ebp),%eax
  80310c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310f:	72 ca                	jb     8030db <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  803111:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  803114:	c9                   	leave  
  803115:	c3                   	ret    

00803116 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  803116:	55                   	push   %ebp
  803117:	89 e5                	mov    %esp,%ebp
  803119:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  80311c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  803123:	e9 c1 00 00 00       	jmp    8031e9 <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 04 c5 40 50 88 00 	mov    0x885040(,%eax,8),%eax
  803132:	3b 45 08             	cmp    0x8(%ebp),%eax
  803135:	0f 85 ab 00 00 00    	jne    8031e6 <free+0xd0>

			if (heap_size[inx].size == 0) {
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 04 c5 44 50 88 00 	mov    0x885044(,%eax,8),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	75 21                	jne    80316a <free+0x54>
				heap_size[inx].size = 0;
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	c7 04 c5 44 50 88 00 	movl   $0x0,0x885044(,%eax,8)
  803153:	00 00 00 00 
				heap_size[inx].vir = NULL;
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	c7 04 c5 40 50 88 00 	movl   $0x0,0x885040(,%eax,8)
  803161:	00 00 00 00 
				return;
  803165:	e9 8d 00 00 00       	jmp    8031f7 <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 14 c5 44 50 88 00 	mov    0x885044(,%eax,8),%edx
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	83 ec 08             	sub    $0x8,%esp
  80317a:	52                   	push   %edx
  80317b:	50                   	push   %eax
  80317c:	e8 0e 02 00 00       	call   80338f <sys_freeMem>
  803181:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  803184:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  803191:	eb 24                	jmp    8031b7 <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  803193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803196:	05 00 00 00 80       	add    $0x80000000,%eax
  80319b:	c1 e8 0c             	shr    $0xc,%eax
  80319e:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  8031a5:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  8031a9:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8031b0:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 14 c5 44 50 88 00 	mov    0x885044(,%eax,8),%edx
  8031c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c4:	39 c2                	cmp    %eax,%edx
  8031c6:	77 cb                	ja     803193 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	c7 04 c5 44 50 88 00 	movl   $0x0,0x885044(,%eax,8)
  8031d2:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d9:	c7 04 c5 40 50 88 00 	movl   $0x0,0x885040(,%eax,8)
  8031e0:	00 00 00 00 
			break;
  8031e4:	eb 11                	jmp    8031f7 <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8031e6:	ff 45 f4             	incl   -0xc(%ebp)
  8031e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8031ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8031f1:	0f 8c 31 ff ff ff    	jl     803128 <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
  8031fc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8031ff:	83 ec 04             	sub    $0x4,%esp
  803202:	68 30 40 80 00       	push   $0x804030
  803207:	68 1c 02 00 00       	push   $0x21c
  80320c:	68 56 40 80 00       	push   $0x804056
  803211:	e8 b0 e6 ff ff       	call   8018c6 <_panic>

00803216 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
  803219:	57                   	push   %edi
  80321a:	56                   	push   %esi
  80321b:	53                   	push   %ebx
  80321c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	8b 55 0c             	mov    0xc(%ebp),%edx
  803225:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803228:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80322b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80322e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803231:	cd 30                	int    $0x30
  803233:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803239:	83 c4 10             	add    $0x10,%esp
  80323c:	5b                   	pop    %ebx
  80323d:	5e                   	pop    %esi
  80323e:	5f                   	pop    %edi
  80323f:	5d                   	pop    %ebp
  803240:	c3                   	ret    

00803241 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  803241:	55                   	push   %ebp
  803242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	6a 00                	push   $0x0
  803249:	6a 00                	push   $0x0
  80324b:	6a 00                	push   $0x0
  80324d:	ff 75 0c             	pushl  0xc(%ebp)
  803250:	50                   	push   %eax
  803251:	6a 00                	push   $0x0
  803253:	e8 be ff ff ff       	call   803216 <syscall>
  803258:	83 c4 18             	add    $0x18,%esp
}
  80325b:	90                   	nop
  80325c:	c9                   	leave  
  80325d:	c3                   	ret    

0080325e <sys_cgetc>:

int
sys_cgetc(void)
{
  80325e:	55                   	push   %ebp
  80325f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803261:	6a 00                	push   $0x0
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	6a 00                	push   $0x0
  803269:	6a 00                	push   $0x0
  80326b:	6a 01                	push   $0x1
  80326d:	e8 a4 ff ff ff       	call   803216 <syscall>
  803272:	83 c4 18             	add    $0x18,%esp
}
  803275:	c9                   	leave  
  803276:	c3                   	ret    

00803277 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  803277:	55                   	push   %ebp
  803278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	6a 00                	push   $0x0
  80327f:	6a 00                	push   $0x0
  803281:	6a 00                	push   $0x0
  803283:	6a 00                	push   $0x0
  803285:	50                   	push   %eax
  803286:	6a 03                	push   $0x3
  803288:	e8 89 ff ff ff       	call   803216 <syscall>
  80328d:	83 c4 18             	add    $0x18,%esp
}
  803290:	c9                   	leave  
  803291:	c3                   	ret    

00803292 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803292:	55                   	push   %ebp
  803293:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803295:	6a 00                	push   $0x0
  803297:	6a 00                	push   $0x0
  803299:	6a 00                	push   $0x0
  80329b:	6a 00                	push   $0x0
  80329d:	6a 00                	push   $0x0
  80329f:	6a 02                	push   $0x2
  8032a1:	e8 70 ff ff ff       	call   803216 <syscall>
  8032a6:	83 c4 18             	add    $0x18,%esp
}
  8032a9:	c9                   	leave  
  8032aa:	c3                   	ret    

008032ab <sys_env_exit>:

void sys_env_exit(void)
{
  8032ab:	55                   	push   %ebp
  8032ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8032ae:	6a 00                	push   $0x0
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	6a 00                	push   $0x0
  8032b6:	6a 00                	push   $0x0
  8032b8:	6a 04                	push   $0x4
  8032ba:	e8 57 ff ff ff       	call   803216 <syscall>
  8032bf:	83 c4 18             	add    $0x18,%esp
}
  8032c2:	90                   	nop
  8032c3:	c9                   	leave  
  8032c4:	c3                   	ret    

008032c5 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8032c5:	55                   	push   %ebp
  8032c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8032c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	6a 00                	push   $0x0
  8032d0:	6a 00                	push   $0x0
  8032d2:	6a 00                	push   $0x0
  8032d4:	52                   	push   %edx
  8032d5:	50                   	push   %eax
  8032d6:	6a 05                	push   $0x5
  8032d8:	e8 39 ff ff ff       	call   803216 <syscall>
  8032dd:	83 c4 18             	add    $0x18,%esp
}
  8032e0:	c9                   	leave  
  8032e1:	c3                   	ret    

008032e2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8032e2:	55                   	push   %ebp
  8032e3:	89 e5                	mov    %esp,%ebp
  8032e5:	56                   	push   %esi
  8032e6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8032e7:	8b 75 18             	mov    0x18(%ebp),%esi
  8032ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	56                   	push   %esi
  8032f7:	53                   	push   %ebx
  8032f8:	51                   	push   %ecx
  8032f9:	52                   	push   %edx
  8032fa:	50                   	push   %eax
  8032fb:	6a 06                	push   $0x6
  8032fd:	e8 14 ff ff ff       	call   803216 <syscall>
  803302:	83 c4 18             	add    $0x18,%esp
}
  803305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803308:	5b                   	pop    %ebx
  803309:	5e                   	pop    %esi
  80330a:	5d                   	pop    %ebp
  80330b:	c3                   	ret    

0080330c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80330c:	55                   	push   %ebp
  80330d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80330f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	6a 00                	push   $0x0
  803317:	6a 00                	push   $0x0
  803319:	6a 00                	push   $0x0
  80331b:	52                   	push   %edx
  80331c:	50                   	push   %eax
  80331d:	6a 07                	push   $0x7
  80331f:	e8 f2 fe ff ff       	call   803216 <syscall>
  803324:	83 c4 18             	add    $0x18,%esp
}
  803327:	c9                   	leave  
  803328:	c3                   	ret    

00803329 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803329:	55                   	push   %ebp
  80332a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80332c:	6a 00                	push   $0x0
  80332e:	6a 00                	push   $0x0
  803330:	6a 00                	push   $0x0
  803332:	ff 75 0c             	pushl  0xc(%ebp)
  803335:	ff 75 08             	pushl  0x8(%ebp)
  803338:	6a 08                	push   $0x8
  80333a:	e8 d7 fe ff ff       	call   803216 <syscall>
  80333f:	83 c4 18             	add    $0x18,%esp
}
  803342:	c9                   	leave  
  803343:	c3                   	ret    

00803344 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803344:	55                   	push   %ebp
  803345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803347:	6a 00                	push   $0x0
  803349:	6a 00                	push   $0x0
  80334b:	6a 00                	push   $0x0
  80334d:	6a 00                	push   $0x0
  80334f:	6a 00                	push   $0x0
  803351:	6a 09                	push   $0x9
  803353:	e8 be fe ff ff       	call   803216 <syscall>
  803358:	83 c4 18             	add    $0x18,%esp
}
  80335b:	c9                   	leave  
  80335c:	c3                   	ret    

0080335d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80335d:	55                   	push   %ebp
  80335e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803360:	6a 00                	push   $0x0
  803362:	6a 00                	push   $0x0
  803364:	6a 00                	push   $0x0
  803366:	6a 00                	push   $0x0
  803368:	6a 00                	push   $0x0
  80336a:	6a 0a                	push   $0xa
  80336c:	e8 a5 fe ff ff       	call   803216 <syscall>
  803371:	83 c4 18             	add    $0x18,%esp
}
  803374:	c9                   	leave  
  803375:	c3                   	ret    

00803376 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803376:	55                   	push   %ebp
  803377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803379:	6a 00                	push   $0x0
  80337b:	6a 00                	push   $0x0
  80337d:	6a 00                	push   $0x0
  80337f:	6a 00                	push   $0x0
  803381:	6a 00                	push   $0x0
  803383:	6a 0b                	push   $0xb
  803385:	e8 8c fe ff ff       	call   803216 <syscall>
  80338a:	83 c4 18             	add    $0x18,%esp
}
  80338d:	c9                   	leave  
  80338e:	c3                   	ret    

0080338f <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80338f:	55                   	push   %ebp
  803390:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  803392:	6a 00                	push   $0x0
  803394:	6a 00                	push   $0x0
  803396:	6a 00                	push   $0x0
  803398:	ff 75 0c             	pushl  0xc(%ebp)
  80339b:	ff 75 08             	pushl  0x8(%ebp)
  80339e:	6a 0d                	push   $0xd
  8033a0:	e8 71 fe ff ff       	call   803216 <syscall>
  8033a5:	83 c4 18             	add    $0x18,%esp
	return;
  8033a8:	90                   	nop
}
  8033a9:	c9                   	leave  
  8033aa:	c3                   	ret    

008033ab <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8033ab:	55                   	push   %ebp
  8033ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8033ae:	6a 00                	push   $0x0
  8033b0:	6a 00                	push   $0x0
  8033b2:	6a 00                	push   $0x0
  8033b4:	ff 75 0c             	pushl  0xc(%ebp)
  8033b7:	ff 75 08             	pushl  0x8(%ebp)
  8033ba:	6a 0e                	push   $0xe
  8033bc:	e8 55 fe ff ff       	call   803216 <syscall>
  8033c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8033c4:	90                   	nop
}
  8033c5:	c9                   	leave  
  8033c6:	c3                   	ret    

008033c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8033c7:	55                   	push   %ebp
  8033c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8033ca:	6a 00                	push   $0x0
  8033cc:	6a 00                	push   $0x0
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	6a 00                	push   $0x0
  8033d4:	6a 0c                	push   $0xc
  8033d6:	e8 3b fe ff ff       	call   803216 <syscall>
  8033db:	83 c4 18             	add    $0x18,%esp
}
  8033de:	c9                   	leave  
  8033df:	c3                   	ret    

008033e0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8033e0:	55                   	push   %ebp
  8033e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8033e3:	6a 00                	push   $0x0
  8033e5:	6a 00                	push   $0x0
  8033e7:	6a 00                	push   $0x0
  8033e9:	6a 00                	push   $0x0
  8033eb:	6a 00                	push   $0x0
  8033ed:	6a 10                	push   $0x10
  8033ef:	e8 22 fe ff ff       	call   803216 <syscall>
  8033f4:	83 c4 18             	add    $0x18,%esp
}
  8033f7:	90                   	nop
  8033f8:	c9                   	leave  
  8033f9:	c3                   	ret    

008033fa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8033fa:	55                   	push   %ebp
  8033fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8033fd:	6a 00                	push   $0x0
  8033ff:	6a 00                	push   $0x0
  803401:	6a 00                	push   $0x0
  803403:	6a 00                	push   $0x0
  803405:	6a 00                	push   $0x0
  803407:	6a 11                	push   $0x11
  803409:	e8 08 fe ff ff       	call   803216 <syscall>
  80340e:	83 c4 18             	add    $0x18,%esp
}
  803411:	90                   	nop
  803412:	c9                   	leave  
  803413:	c3                   	ret    

00803414 <sys_cputc>:


void
sys_cputc(const char c)
{
  803414:	55                   	push   %ebp
  803415:	89 e5                	mov    %esp,%ebp
  803417:	83 ec 04             	sub    $0x4,%esp
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803420:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803424:	6a 00                	push   $0x0
  803426:	6a 00                	push   $0x0
  803428:	6a 00                	push   $0x0
  80342a:	6a 00                	push   $0x0
  80342c:	50                   	push   %eax
  80342d:	6a 12                	push   $0x12
  80342f:	e8 e2 fd ff ff       	call   803216 <syscall>
  803434:	83 c4 18             	add    $0x18,%esp
}
  803437:	90                   	nop
  803438:	c9                   	leave  
  803439:	c3                   	ret    

0080343a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80343a:	55                   	push   %ebp
  80343b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80343d:	6a 00                	push   $0x0
  80343f:	6a 00                	push   $0x0
  803441:	6a 00                	push   $0x0
  803443:	6a 00                	push   $0x0
  803445:	6a 00                	push   $0x0
  803447:	6a 13                	push   $0x13
  803449:	e8 c8 fd ff ff       	call   803216 <syscall>
  80344e:	83 c4 18             	add    $0x18,%esp
}
  803451:	90                   	nop
  803452:	c9                   	leave  
  803453:	c3                   	ret    

00803454 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  803454:	55                   	push   %ebp
  803455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	6a 00                	push   $0x0
  80345c:	6a 00                	push   $0x0
  80345e:	6a 00                	push   $0x0
  803460:	ff 75 0c             	pushl  0xc(%ebp)
  803463:	50                   	push   %eax
  803464:	6a 14                	push   $0x14
  803466:	e8 ab fd ff ff       	call   803216 <syscall>
  80346b:	83 c4 18             	add    $0x18,%esp
}
  80346e:	c9                   	leave  
  80346f:	c3                   	ret    

00803470 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  803470:	55                   	push   %ebp
  803471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	6a 00                	push   $0x0
  803478:	6a 00                	push   $0x0
  80347a:	6a 00                	push   $0x0
  80347c:	6a 00                	push   $0x0
  80347e:	50                   	push   %eax
  80347f:	6a 17                	push   $0x17
  803481:	e8 90 fd ff ff       	call   803216 <syscall>
  803486:	83 c4 18             	add    $0x18,%esp
}
  803489:	c9                   	leave  
  80348a:	c3                   	ret    

0080348b <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80348b:	55                   	push   %ebp
  80348c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80348e:	8b 45 08             	mov    0x8(%ebp),%eax
  803491:	6a 00                	push   $0x0
  803493:	6a 00                	push   $0x0
  803495:	6a 00                	push   $0x0
  803497:	6a 00                	push   $0x0
  803499:	50                   	push   %eax
  80349a:	6a 15                	push   $0x15
  80349c:	e8 75 fd ff ff       	call   803216 <syscall>
  8034a1:	83 c4 18             	add    $0x18,%esp
}
  8034a4:	90                   	nop
  8034a5:	c9                   	leave  
  8034a6:	c3                   	ret    

008034a7 <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  8034a7:	55                   	push   %ebp
  8034a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	6a 00                	push   $0x0
  8034af:	6a 00                	push   $0x0
  8034b1:	6a 00                	push   $0x0
  8034b3:	6a 00                	push   $0x0
  8034b5:	50                   	push   %eax
  8034b6:	6a 16                	push   $0x16
  8034b8:	e8 59 fd ff ff       	call   803216 <syscall>
  8034bd:	83 c4 18             	add    $0x18,%esp
}
  8034c0:	90                   	nop
  8034c1:	c9                   	leave  
  8034c2:	c3                   	ret    

008034c3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  8034c3:	55                   	push   %ebp
  8034c4:	89 e5                	mov    %esp,%ebp
  8034c6:	83 ec 04             	sub    $0x4,%esp
  8034c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8034cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  8034cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8034d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	6a 00                	push   $0x0
  8034db:	51                   	push   %ecx
  8034dc:	52                   	push   %edx
  8034dd:	ff 75 0c             	pushl  0xc(%ebp)
  8034e0:	50                   	push   %eax
  8034e1:	6a 18                	push   $0x18
  8034e3:	e8 2e fd ff ff       	call   803216 <syscall>
  8034e8:	83 c4 18             	add    $0x18,%esp
}
  8034eb:	c9                   	leave  
  8034ec:	c3                   	ret    

008034ed <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  8034ed:	55                   	push   %ebp
  8034ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  8034f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	6a 00                	push   $0x0
  8034f8:	6a 00                	push   $0x0
  8034fa:	6a 00                	push   $0x0
  8034fc:	52                   	push   %edx
  8034fd:	50                   	push   %eax
  8034fe:	6a 19                	push   $0x19
  803500:	e8 11 fd ff ff       	call   803216 <syscall>
  803505:	83 c4 18             	add    $0x18,%esp
}
  803508:	c9                   	leave  
  803509:	c3                   	ret    

0080350a <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80350a:	55                   	push   %ebp
  80350b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	6a 00                	push   $0x0
  803512:	6a 00                	push   $0x0
  803514:	6a 00                	push   $0x0
  803516:	6a 00                	push   $0x0
  803518:	50                   	push   %eax
  803519:	6a 1a                	push   $0x1a
  80351b:	e8 f6 fc ff ff       	call   803216 <syscall>
  803520:	83 c4 18             	add    $0x18,%esp
}
  803523:	c9                   	leave  
  803524:	c3                   	ret    

00803525 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  803525:	55                   	push   %ebp
  803526:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  803528:	6a 00                	push   $0x0
  80352a:	6a 00                	push   $0x0
  80352c:	6a 00                	push   $0x0
  80352e:	6a 00                	push   $0x0
  803530:	6a 00                	push   $0x0
  803532:	6a 1b                	push   $0x1b
  803534:	e8 dd fc ff ff       	call   803216 <syscall>
  803539:	83 c4 18             	add    $0x18,%esp
}
  80353c:	c9                   	leave  
  80353d:	c3                   	ret    

0080353e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80353e:	55                   	push   %ebp
  80353f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  803541:	6a 00                	push   $0x0
  803543:	6a 00                	push   $0x0
  803545:	6a 00                	push   $0x0
  803547:	6a 00                	push   $0x0
  803549:	6a 00                	push   $0x0
  80354b:	6a 1c                	push   $0x1c
  80354d:	e8 c4 fc ff ff       	call   803216 <syscall>
  803552:	83 c4 18             	add    $0x18,%esp
}
  803555:	c9                   	leave  
  803556:	c3                   	ret    

00803557 <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  803557:	55                   	push   %ebp
  803558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	6a 00                	push   $0x0
  80355f:	6a 00                	push   $0x0
  803561:	6a 00                	push   $0x0
  803563:	ff 75 0c             	pushl  0xc(%ebp)
  803566:	50                   	push   %eax
  803567:	6a 1d                	push   $0x1d
  803569:	e8 a8 fc ff ff       	call   803216 <syscall>
  80356e:	83 c4 18             	add    $0x18,%esp
}
  803571:	c9                   	leave  
  803572:	c3                   	ret    

00803573 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  803573:	55                   	push   %ebp
  803574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	6a 00                	push   $0x0
  80357b:	6a 00                	push   $0x0
  80357d:	6a 00                	push   $0x0
  80357f:	6a 00                	push   $0x0
  803581:	50                   	push   %eax
  803582:	6a 1e                	push   $0x1e
  803584:	e8 8d fc ff ff       	call   803216 <syscall>
  803589:	83 c4 18             	add    $0x18,%esp
}
  80358c:	90                   	nop
  80358d:	c9                   	leave  
  80358e:	c3                   	ret    

0080358f <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80358f:	55                   	push   %ebp
  803590:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  803592:	8b 45 08             	mov    0x8(%ebp),%eax
  803595:	6a 00                	push   $0x0
  803597:	6a 00                	push   $0x0
  803599:	6a 00                	push   $0x0
  80359b:	6a 00                	push   $0x0
  80359d:	50                   	push   %eax
  80359e:	6a 1f                	push   $0x1f
  8035a0:	e8 71 fc ff ff       	call   803216 <syscall>
  8035a5:	83 c4 18             	add    $0x18,%esp
}
  8035a8:	90                   	nop
  8035a9:	c9                   	leave  
  8035aa:	c3                   	ret    

008035ab <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8035ab:	55                   	push   %ebp
  8035ac:	89 e5                	mov    %esp,%ebp
  8035ae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8035b1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8035b4:	8d 50 04             	lea    0x4(%eax),%edx
  8035b7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8035ba:	6a 00                	push   $0x0
  8035bc:	6a 00                	push   $0x0
  8035be:	6a 00                	push   $0x0
  8035c0:	52                   	push   %edx
  8035c1:	50                   	push   %eax
  8035c2:	6a 20                	push   $0x20
  8035c4:	e8 4d fc ff ff       	call   803216 <syscall>
  8035c9:	83 c4 18             	add    $0x18,%esp
	return result;
  8035cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8035cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8035d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8035d5:	89 01                	mov    %eax,(%ecx)
  8035d7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	c9                   	leave  
  8035de:	c2 04 00             	ret    $0x4

008035e1 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8035e1:	55                   	push   %ebp
  8035e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8035e4:	6a 00                	push   $0x0
  8035e6:	6a 00                	push   $0x0
  8035e8:	ff 75 10             	pushl  0x10(%ebp)
  8035eb:	ff 75 0c             	pushl  0xc(%ebp)
  8035ee:	ff 75 08             	pushl  0x8(%ebp)
  8035f1:	6a 0f                	push   $0xf
  8035f3:	e8 1e fc ff ff       	call   803216 <syscall>
  8035f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8035fb:	90                   	nop
}
  8035fc:	c9                   	leave  
  8035fd:	c3                   	ret    

008035fe <sys_rcr2>:
uint32 sys_rcr2()
{
  8035fe:	55                   	push   %ebp
  8035ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803601:	6a 00                	push   $0x0
  803603:	6a 00                	push   $0x0
  803605:	6a 00                	push   $0x0
  803607:	6a 00                	push   $0x0
  803609:	6a 00                	push   $0x0
  80360b:	6a 21                	push   $0x21
  80360d:	e8 04 fc ff ff       	call   803216 <syscall>
  803612:	83 c4 18             	add    $0x18,%esp
}
  803615:	c9                   	leave  
  803616:	c3                   	ret    

00803617 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  803617:	55                   	push   %ebp
  803618:	89 e5                	mov    %esp,%ebp
  80361a:	83 ec 04             	sub    $0x4,%esp
  80361d:	8b 45 08             	mov    0x8(%ebp),%eax
  803620:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803623:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803627:	6a 00                	push   $0x0
  803629:	6a 00                	push   $0x0
  80362b:	6a 00                	push   $0x0
  80362d:	6a 00                	push   $0x0
  80362f:	50                   	push   %eax
  803630:	6a 22                	push   $0x22
  803632:	e8 df fb ff ff       	call   803216 <syscall>
  803637:	83 c4 18             	add    $0x18,%esp
	return ;
  80363a:	90                   	nop
}
  80363b:	c9                   	leave  
  80363c:	c3                   	ret    

0080363d <rsttst>:
void rsttst()
{
  80363d:	55                   	push   %ebp
  80363e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803640:	6a 00                	push   $0x0
  803642:	6a 00                	push   $0x0
  803644:	6a 00                	push   $0x0
  803646:	6a 00                	push   $0x0
  803648:	6a 00                	push   $0x0
  80364a:	6a 24                	push   $0x24
  80364c:	e8 c5 fb ff ff       	call   803216 <syscall>
  803651:	83 c4 18             	add    $0x18,%esp
	return ;
  803654:	90                   	nop
}
  803655:	c9                   	leave  
  803656:	c3                   	ret    

00803657 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803657:	55                   	push   %ebp
  803658:	89 e5                	mov    %esp,%ebp
  80365a:	83 ec 04             	sub    $0x4,%esp
  80365d:	8b 45 14             	mov    0x14(%ebp),%eax
  803660:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803663:	8b 55 18             	mov    0x18(%ebp),%edx
  803666:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80366a:	52                   	push   %edx
  80366b:	50                   	push   %eax
  80366c:	ff 75 10             	pushl  0x10(%ebp)
  80366f:	ff 75 0c             	pushl  0xc(%ebp)
  803672:	ff 75 08             	pushl  0x8(%ebp)
  803675:	6a 23                	push   $0x23
  803677:	e8 9a fb ff ff       	call   803216 <syscall>
  80367c:	83 c4 18             	add    $0x18,%esp
	return ;
  80367f:	90                   	nop
}
  803680:	c9                   	leave  
  803681:	c3                   	ret    

00803682 <chktst>:
void chktst(uint32 n)
{
  803682:	55                   	push   %ebp
  803683:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803685:	6a 00                	push   $0x0
  803687:	6a 00                	push   $0x0
  803689:	6a 00                	push   $0x0
  80368b:	6a 00                	push   $0x0
  80368d:	ff 75 08             	pushl  0x8(%ebp)
  803690:	6a 25                	push   $0x25
  803692:	e8 7f fb ff ff       	call   803216 <syscall>
  803697:	83 c4 18             	add    $0x18,%esp
	return ;
  80369a:	90                   	nop
}
  80369b:	c9                   	leave  
  80369c:	c3                   	ret    

0080369d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80369d:	55                   	push   %ebp
  80369e:	89 e5                	mov    %esp,%ebp
  8036a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8036a3:	6a 00                	push   $0x0
  8036a5:	6a 00                	push   $0x0
  8036a7:	6a 00                	push   $0x0
  8036a9:	6a 00                	push   $0x0
  8036ab:	6a 00                	push   $0x0
  8036ad:	6a 26                	push   $0x26
  8036af:	e8 62 fb ff ff       	call   803216 <syscall>
  8036b4:	83 c4 18             	add    $0x18,%esp
  8036b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8036ba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8036be:	75 07                	jne    8036c7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8036c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8036c5:	eb 05                	jmp    8036cc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8036c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036cc:	c9                   	leave  
  8036cd:	c3                   	ret    

008036ce <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8036ce:	55                   	push   %ebp
  8036cf:	89 e5                	mov    %esp,%ebp
  8036d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8036d4:	6a 00                	push   $0x0
  8036d6:	6a 00                	push   $0x0
  8036d8:	6a 00                	push   $0x0
  8036da:	6a 00                	push   $0x0
  8036dc:	6a 00                	push   $0x0
  8036de:	6a 26                	push   $0x26
  8036e0:	e8 31 fb ff ff       	call   803216 <syscall>
  8036e5:	83 c4 18             	add    $0x18,%esp
  8036e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8036eb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8036ef:	75 07                	jne    8036f8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8036f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f6:	eb 05                	jmp    8036fd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8036f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036fd:	c9                   	leave  
  8036fe:	c3                   	ret    

008036ff <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8036ff:	55                   	push   %ebp
  803700:	89 e5                	mov    %esp,%ebp
  803702:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803705:	6a 00                	push   $0x0
  803707:	6a 00                	push   $0x0
  803709:	6a 00                	push   $0x0
  80370b:	6a 00                	push   $0x0
  80370d:	6a 00                	push   $0x0
  80370f:	6a 26                	push   $0x26
  803711:	e8 00 fb ff ff       	call   803216 <syscall>
  803716:	83 c4 18             	add    $0x18,%esp
  803719:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80371c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803720:	75 07                	jne    803729 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803722:	b8 01 00 00 00       	mov    $0x1,%eax
  803727:	eb 05                	jmp    80372e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80372e:	c9                   	leave  
  80372f:	c3                   	ret    

00803730 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803730:	55                   	push   %ebp
  803731:	89 e5                	mov    %esp,%ebp
  803733:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803736:	6a 00                	push   $0x0
  803738:	6a 00                	push   $0x0
  80373a:	6a 00                	push   $0x0
  80373c:	6a 00                	push   $0x0
  80373e:	6a 00                	push   $0x0
  803740:	6a 26                	push   $0x26
  803742:	e8 cf fa ff ff       	call   803216 <syscall>
  803747:	83 c4 18             	add    $0x18,%esp
  80374a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80374d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803751:	75 07                	jne    80375a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803753:	b8 01 00 00 00       	mov    $0x1,%eax
  803758:	eb 05                	jmp    80375f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80375a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80375f:	c9                   	leave  
  803760:	c3                   	ret    

00803761 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803761:	55                   	push   %ebp
  803762:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803764:	6a 00                	push   $0x0
  803766:	6a 00                	push   $0x0
  803768:	6a 00                	push   $0x0
  80376a:	6a 00                	push   $0x0
  80376c:	ff 75 08             	pushl  0x8(%ebp)
  80376f:	6a 27                	push   $0x27
  803771:	e8 a0 fa ff ff       	call   803216 <syscall>
  803776:	83 c4 18             	add    $0x18,%esp
	return ;
  803779:	90                   	nop
}
  80377a:	c9                   	leave  
  80377b:	c3                   	ret    

0080377c <__udivdi3>:
  80377c:	55                   	push   %ebp
  80377d:	57                   	push   %edi
  80377e:	56                   	push   %esi
  80377f:	53                   	push   %ebx
  803780:	83 ec 1c             	sub    $0x1c,%esp
  803783:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803787:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80378b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80378f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803793:	89 ca                	mov    %ecx,%edx
  803795:	89 f8                	mov    %edi,%eax
  803797:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80379b:	85 f6                	test   %esi,%esi
  80379d:	75 2d                	jne    8037cc <__udivdi3+0x50>
  80379f:	39 cf                	cmp    %ecx,%edi
  8037a1:	77 65                	ja     803808 <__udivdi3+0x8c>
  8037a3:	89 fd                	mov    %edi,%ebp
  8037a5:	85 ff                	test   %edi,%edi
  8037a7:	75 0b                	jne    8037b4 <__udivdi3+0x38>
  8037a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8037ae:	31 d2                	xor    %edx,%edx
  8037b0:	f7 f7                	div    %edi
  8037b2:	89 c5                	mov    %eax,%ebp
  8037b4:	31 d2                	xor    %edx,%edx
  8037b6:	89 c8                	mov    %ecx,%eax
  8037b8:	f7 f5                	div    %ebp
  8037ba:	89 c1                	mov    %eax,%ecx
  8037bc:	89 d8                	mov    %ebx,%eax
  8037be:	f7 f5                	div    %ebp
  8037c0:	89 cf                	mov    %ecx,%edi
  8037c2:	89 fa                	mov    %edi,%edx
  8037c4:	83 c4 1c             	add    $0x1c,%esp
  8037c7:	5b                   	pop    %ebx
  8037c8:	5e                   	pop    %esi
  8037c9:	5f                   	pop    %edi
  8037ca:	5d                   	pop    %ebp
  8037cb:	c3                   	ret    
  8037cc:	39 ce                	cmp    %ecx,%esi
  8037ce:	77 28                	ja     8037f8 <__udivdi3+0x7c>
  8037d0:	0f bd fe             	bsr    %esi,%edi
  8037d3:	83 f7 1f             	xor    $0x1f,%edi
  8037d6:	75 40                	jne    803818 <__udivdi3+0x9c>
  8037d8:	39 ce                	cmp    %ecx,%esi
  8037da:	72 0a                	jb     8037e6 <__udivdi3+0x6a>
  8037dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037e0:	0f 87 9e 00 00 00    	ja     803884 <__udivdi3+0x108>
  8037e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037eb:	89 fa                	mov    %edi,%edx
  8037ed:	83 c4 1c             	add    $0x1c,%esp
  8037f0:	5b                   	pop    %ebx
  8037f1:	5e                   	pop    %esi
  8037f2:	5f                   	pop    %edi
  8037f3:	5d                   	pop    %ebp
  8037f4:	c3                   	ret    
  8037f5:	8d 76 00             	lea    0x0(%esi),%esi
  8037f8:	31 ff                	xor    %edi,%edi
  8037fa:	31 c0                	xor    %eax,%eax
  8037fc:	89 fa                	mov    %edi,%edx
  8037fe:	83 c4 1c             	add    $0x1c,%esp
  803801:	5b                   	pop    %ebx
  803802:	5e                   	pop    %esi
  803803:	5f                   	pop    %edi
  803804:	5d                   	pop    %ebp
  803805:	c3                   	ret    
  803806:	66 90                	xchg   %ax,%ax
  803808:	89 d8                	mov    %ebx,%eax
  80380a:	f7 f7                	div    %edi
  80380c:	31 ff                	xor    %edi,%edi
  80380e:	89 fa                	mov    %edi,%edx
  803810:	83 c4 1c             	add    $0x1c,%esp
  803813:	5b                   	pop    %ebx
  803814:	5e                   	pop    %esi
  803815:	5f                   	pop    %edi
  803816:	5d                   	pop    %ebp
  803817:	c3                   	ret    
  803818:	bd 20 00 00 00       	mov    $0x20,%ebp
  80381d:	89 eb                	mov    %ebp,%ebx
  80381f:	29 fb                	sub    %edi,%ebx
  803821:	89 f9                	mov    %edi,%ecx
  803823:	d3 e6                	shl    %cl,%esi
  803825:	89 c5                	mov    %eax,%ebp
  803827:	88 d9                	mov    %bl,%cl
  803829:	d3 ed                	shr    %cl,%ebp
  80382b:	89 e9                	mov    %ebp,%ecx
  80382d:	09 f1                	or     %esi,%ecx
  80382f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803833:	89 f9                	mov    %edi,%ecx
  803835:	d3 e0                	shl    %cl,%eax
  803837:	89 c5                	mov    %eax,%ebp
  803839:	89 d6                	mov    %edx,%esi
  80383b:	88 d9                	mov    %bl,%cl
  80383d:	d3 ee                	shr    %cl,%esi
  80383f:	89 f9                	mov    %edi,%ecx
  803841:	d3 e2                	shl    %cl,%edx
  803843:	8b 44 24 08          	mov    0x8(%esp),%eax
  803847:	88 d9                	mov    %bl,%cl
  803849:	d3 e8                	shr    %cl,%eax
  80384b:	09 c2                	or     %eax,%edx
  80384d:	89 d0                	mov    %edx,%eax
  80384f:	89 f2                	mov    %esi,%edx
  803851:	f7 74 24 0c          	divl   0xc(%esp)
  803855:	89 d6                	mov    %edx,%esi
  803857:	89 c3                	mov    %eax,%ebx
  803859:	f7 e5                	mul    %ebp
  80385b:	39 d6                	cmp    %edx,%esi
  80385d:	72 19                	jb     803878 <__udivdi3+0xfc>
  80385f:	74 0b                	je     80386c <__udivdi3+0xf0>
  803861:	89 d8                	mov    %ebx,%eax
  803863:	31 ff                	xor    %edi,%edi
  803865:	e9 58 ff ff ff       	jmp    8037c2 <__udivdi3+0x46>
  80386a:	66 90                	xchg   %ax,%ax
  80386c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803870:	89 f9                	mov    %edi,%ecx
  803872:	d3 e2                	shl    %cl,%edx
  803874:	39 c2                	cmp    %eax,%edx
  803876:	73 e9                	jae    803861 <__udivdi3+0xe5>
  803878:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80387b:	31 ff                	xor    %edi,%edi
  80387d:	e9 40 ff ff ff       	jmp    8037c2 <__udivdi3+0x46>
  803882:	66 90                	xchg   %ax,%ax
  803884:	31 c0                	xor    %eax,%eax
  803886:	e9 37 ff ff ff       	jmp    8037c2 <__udivdi3+0x46>
  80388b:	90                   	nop

0080388c <__umoddi3>:
  80388c:	55                   	push   %ebp
  80388d:	57                   	push   %edi
  80388e:	56                   	push   %esi
  80388f:	53                   	push   %ebx
  803890:	83 ec 1c             	sub    $0x1c,%esp
  803893:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803897:	8b 74 24 34          	mov    0x34(%esp),%esi
  80389b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80389f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038ab:	89 f3                	mov    %esi,%ebx
  8038ad:	89 fa                	mov    %edi,%edx
  8038af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038b3:	89 34 24             	mov    %esi,(%esp)
  8038b6:	85 c0                	test   %eax,%eax
  8038b8:	75 1a                	jne    8038d4 <__umoddi3+0x48>
  8038ba:	39 f7                	cmp    %esi,%edi
  8038bc:	0f 86 a2 00 00 00    	jbe    803964 <__umoddi3+0xd8>
  8038c2:	89 c8                	mov    %ecx,%eax
  8038c4:	89 f2                	mov    %esi,%edx
  8038c6:	f7 f7                	div    %edi
  8038c8:	89 d0                	mov    %edx,%eax
  8038ca:	31 d2                	xor    %edx,%edx
  8038cc:	83 c4 1c             	add    $0x1c,%esp
  8038cf:	5b                   	pop    %ebx
  8038d0:	5e                   	pop    %esi
  8038d1:	5f                   	pop    %edi
  8038d2:	5d                   	pop    %ebp
  8038d3:	c3                   	ret    
  8038d4:	39 f0                	cmp    %esi,%eax
  8038d6:	0f 87 ac 00 00 00    	ja     803988 <__umoddi3+0xfc>
  8038dc:	0f bd e8             	bsr    %eax,%ebp
  8038df:	83 f5 1f             	xor    $0x1f,%ebp
  8038e2:	0f 84 ac 00 00 00    	je     803994 <__umoddi3+0x108>
  8038e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038ed:	29 ef                	sub    %ebp,%edi
  8038ef:	89 fe                	mov    %edi,%esi
  8038f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038f5:	89 e9                	mov    %ebp,%ecx
  8038f7:	d3 e0                	shl    %cl,%eax
  8038f9:	89 d7                	mov    %edx,%edi
  8038fb:	89 f1                	mov    %esi,%ecx
  8038fd:	d3 ef                	shr    %cl,%edi
  8038ff:	09 c7                	or     %eax,%edi
  803901:	89 e9                	mov    %ebp,%ecx
  803903:	d3 e2                	shl    %cl,%edx
  803905:	89 14 24             	mov    %edx,(%esp)
  803908:	89 d8                	mov    %ebx,%eax
  80390a:	d3 e0                	shl    %cl,%eax
  80390c:	89 c2                	mov    %eax,%edx
  80390e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803912:	d3 e0                	shl    %cl,%eax
  803914:	89 44 24 04          	mov    %eax,0x4(%esp)
  803918:	8b 44 24 08          	mov    0x8(%esp),%eax
  80391c:	89 f1                	mov    %esi,%ecx
  80391e:	d3 e8                	shr    %cl,%eax
  803920:	09 d0                	or     %edx,%eax
  803922:	d3 eb                	shr    %cl,%ebx
  803924:	89 da                	mov    %ebx,%edx
  803926:	f7 f7                	div    %edi
  803928:	89 d3                	mov    %edx,%ebx
  80392a:	f7 24 24             	mull   (%esp)
  80392d:	89 c6                	mov    %eax,%esi
  80392f:	89 d1                	mov    %edx,%ecx
  803931:	39 d3                	cmp    %edx,%ebx
  803933:	0f 82 87 00 00 00    	jb     8039c0 <__umoddi3+0x134>
  803939:	0f 84 91 00 00 00    	je     8039d0 <__umoddi3+0x144>
  80393f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803943:	29 f2                	sub    %esi,%edx
  803945:	19 cb                	sbb    %ecx,%ebx
  803947:	89 d8                	mov    %ebx,%eax
  803949:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80394d:	d3 e0                	shl    %cl,%eax
  80394f:	89 e9                	mov    %ebp,%ecx
  803951:	d3 ea                	shr    %cl,%edx
  803953:	09 d0                	or     %edx,%eax
  803955:	89 e9                	mov    %ebp,%ecx
  803957:	d3 eb                	shr    %cl,%ebx
  803959:	89 da                	mov    %ebx,%edx
  80395b:	83 c4 1c             	add    $0x1c,%esp
  80395e:	5b                   	pop    %ebx
  80395f:	5e                   	pop    %esi
  803960:	5f                   	pop    %edi
  803961:	5d                   	pop    %ebp
  803962:	c3                   	ret    
  803963:	90                   	nop
  803964:	89 fd                	mov    %edi,%ebp
  803966:	85 ff                	test   %edi,%edi
  803968:	75 0b                	jne    803975 <__umoddi3+0xe9>
  80396a:	b8 01 00 00 00       	mov    $0x1,%eax
  80396f:	31 d2                	xor    %edx,%edx
  803971:	f7 f7                	div    %edi
  803973:	89 c5                	mov    %eax,%ebp
  803975:	89 f0                	mov    %esi,%eax
  803977:	31 d2                	xor    %edx,%edx
  803979:	f7 f5                	div    %ebp
  80397b:	89 c8                	mov    %ecx,%eax
  80397d:	f7 f5                	div    %ebp
  80397f:	89 d0                	mov    %edx,%eax
  803981:	e9 44 ff ff ff       	jmp    8038ca <__umoddi3+0x3e>
  803986:	66 90                	xchg   %ax,%ax
  803988:	89 c8                	mov    %ecx,%eax
  80398a:	89 f2                	mov    %esi,%edx
  80398c:	83 c4 1c             	add    $0x1c,%esp
  80398f:	5b                   	pop    %ebx
  803990:	5e                   	pop    %esi
  803991:	5f                   	pop    %edi
  803992:	5d                   	pop    %ebp
  803993:	c3                   	ret    
  803994:	3b 04 24             	cmp    (%esp),%eax
  803997:	72 06                	jb     80399f <__umoddi3+0x113>
  803999:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80399d:	77 0f                	ja     8039ae <__umoddi3+0x122>
  80399f:	89 f2                	mov    %esi,%edx
  8039a1:	29 f9                	sub    %edi,%ecx
  8039a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039a7:	89 14 24             	mov    %edx,(%esp)
  8039aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039b2:	8b 14 24             	mov    (%esp),%edx
  8039b5:	83 c4 1c             	add    $0x1c,%esp
  8039b8:	5b                   	pop    %ebx
  8039b9:	5e                   	pop    %esi
  8039ba:	5f                   	pop    %edi
  8039bb:	5d                   	pop    %ebp
  8039bc:	c3                   	ret    
  8039bd:	8d 76 00             	lea    0x0(%esi),%esi
  8039c0:	2b 04 24             	sub    (%esp),%eax
  8039c3:	19 fa                	sbb    %edi,%edx
  8039c5:	89 d1                	mov    %edx,%ecx
  8039c7:	89 c6                	mov    %eax,%esi
  8039c9:	e9 71 ff ff ff       	jmp    80393f <__umoddi3+0xb3>
  8039ce:	66 90                	xchg   %ax,%ax
  8039d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039d4:	72 ea                	jb     8039c0 <__umoddi3+0x134>
  8039d6:	89 d9                	mov    %ebx,%ecx
  8039d8:	e9 62 ff ff ff       	jmp    80393f <__umoddi3+0xb3>
