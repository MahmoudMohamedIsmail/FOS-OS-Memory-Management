
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 c4 0d 00 00       	call   800dfa <libmain>
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
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	int envID = sys_getenvid();
  800043:	e8 3f 28 00 00       	call   802887 <sys_getenvid>
  800048:	89 45 ec             	mov    %eax,-0x14(%ebp)

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80004b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80004e:	89 d0                	mov    %edx,%eax
  800050:	c1 e0 03             	shl    $0x3,%eax
  800053:	01 d0                	add    %edx,%eax
  800055:	01 c0                	add    %eax,%eax
  800057:	01 d0                	add    %edx,%eax
  800059:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800060:	01 d0                	add    %edx,%eax
  800062:	c1 e0 03             	shl    $0x3,%eax
  800065:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int Mega = 1024*1024;
  80006d:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  800074:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  80007b:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  80007f:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  800083:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  800089:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  80008f:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  800096:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  80009d:	e8 97 28 00 00       	call   802939 <sys_calculate_free_frames>
  8000a2:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000a5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000ab:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	89 d7                	mov    %edx,%edi
  8000b7:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000b9:	e8 fe 28 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  8000be:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000c9:	83 ec 0c             	sub    $0xc,%esp
  8000cc:	50                   	push   %eax
  8000cd:	e8 97 1c 00 00       	call   801d69 <malloc>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8000db:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8000e1:	85 c0                	test   %eax,%eax
  8000e3:	79 0d                	jns    8000f2 <_main+0xba>
  8000e5:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8000eb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000f0:	76 14                	jbe    800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 e0 2f 80 00       	push   $0x802fe0
  8000fa:	6a 29                	push   $0x29
  8000fc:	68 45 30 80 00       	push   $0x803045
  800101:	e8 b5 0d 00 00       	call   800ebb <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800106:	e8 b1 28 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  80010b:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80010e:	3d 00 02 00 00       	cmp    $0x200,%eax
  800113:	74 14                	je     800129 <_main+0xf1>
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	68 5c 30 80 00       	push   $0x80305c
  80011d:	6a 2a                	push   $0x2a
  80011f:	68 45 30 80 00       	push   $0x803045
  800124:	e8 92 0d 00 00       	call   800ebb <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800129:	e8 0b 28 00 00       	call   802939 <sys_calculate_free_frames>
  80012e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	01 c0                	add    %eax,%eax
  800136:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800139:	48                   	dec    %eax
  80013a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80013d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800143:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800146:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800149:	8a 55 df             	mov    -0x21(%ebp),%dl
  80014c:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80014e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800151:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800154:	01 c2                	add    %eax,%edx
  800156:	8a 45 de             	mov    -0x22(%ebp),%al
  800159:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80015b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80015e:	e8 d6 27 00 00       	call   802939 <sys_calculate_free_frames>
  800163:	29 c3                	sub    %eax,%ebx
  800165:	89 d8                	mov    %ebx,%eax
  800167:	83 f8 03             	cmp    $0x3,%eax
  80016a:	74 14                	je     800180 <_main+0x148>
  80016c:	83 ec 04             	sub    $0x4,%esp
  80016f:	68 8c 30 80 00       	push   $0x80308c
  800174:	6a 31                	push   $0x31
  800176:	68 45 30 80 00       	push   $0x803045
  80017b:	e8 3b 0d 00 00       	call   800ebb <_panic>
		int var;
		int found = 0;
  800180:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800187:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80018e:	eb 7e                	jmp    80020e <_main+0x1d6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800190:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800193:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800199:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80019c:	89 d0                	mov    %edx,%eax
  80019e:	01 c0                	add    %eax,%eax
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	c1 e0 02             	shl    $0x2,%eax
  8001a5:	01 c8                	add    %ecx,%eax
  8001a7:	8b 00                	mov    (%eax),%eax
  8001a9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 c2                	mov    %eax,%edx
  8001b6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001b9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001bc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001c4:	39 c2                	cmp    %eax,%edx
  8001c6:	75 03                	jne    8001cb <_main+0x193>
				found++;
  8001c8:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  8001cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ce:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8001d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001d7:	89 d0                	mov    %edx,%eax
  8001d9:	01 c0                	add    %eax,%eax
  8001db:	01 d0                	add    %edx,%eax
  8001dd:	c1 e0 02             	shl    $0x2,%eax
  8001e0:	01 c8                	add    %ecx,%eax
  8001e2:	8b 00                	mov    (%eax),%eax
  8001e4:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ef:	89 c1                	mov    %eax,%ecx
  8001f1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8001f4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001f7:	01 d0                	add    %edx,%eax
  8001f9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001fc:	8b 45 ac             	mov    -0x54(%ebp),%eax
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
  80020e:	8b 45 e8             	mov    -0x18(%ebp),%eax
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
  800228:	68 d0 30 80 00       	push   $0x8030d0
  80022d:	6a 3b                	push   $0x3b
  80022f:	68 45 30 80 00       	push   $0x803045
  800234:	e8 82 0c 00 00       	call   800ebb <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800239:	e8 7e 27 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  80023e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800241:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800244:	01 c0                	add    %eax,%eax
  800246:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	50                   	push   %eax
  80024d:	e8 17 1b 00 00       	call   801d69 <malloc>
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80025b:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800261:	89 c2                	mov    %eax,%edx
  800263:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800266:	01 c0                	add    %eax,%eax
  800268:	05 00 00 00 80       	add    $0x80000000,%eax
  80026d:	39 c2                	cmp    %eax,%edx
  80026f:	72 16                	jb     800287 <_main+0x24f>
  800271:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800277:	89 c2                	mov    %eax,%edx
  800279:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027c:	01 c0                	add    %eax,%eax
  80027e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	76 14                	jbe    80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 e0 2f 80 00       	push   $0x802fe0
  80028f:	6a 40                	push   $0x40
  800291:	68 45 30 80 00       	push   $0x803045
  800296:	e8 20 0c 00 00       	call   800ebb <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 1c 27 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8002a3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 5c 30 80 00       	push   $0x80305c
  8002b2:	6a 41                	push   $0x41
  8002b4:	68 45 30 80 00       	push   $0x803045
  8002b9:	e8 fd 0b 00 00       	call   800ebb <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 76 26 00 00       	call   802939 <sys_calculate_free_frames>
  8002c3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  8002c6:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002cc:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  8002cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d2:	01 c0                	add    %eax,%eax
  8002d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002d7:	d1 e8                	shr    %eax
  8002d9:	48                   	dec    %eax
  8002da:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  8002dd:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8002e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e3:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  8002e6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	89 c2                	mov    %eax,%edx
  8002ed:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002f0:	01 c2                	add    %eax,%edx
  8002f2:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  8002f6:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8002f9:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8002fc:	e8 38 26 00 00       	call   802939 <sys_calculate_free_frames>
  800301:	29 c3                	sub    %eax,%ebx
  800303:	89 d8                	mov    %ebx,%eax
  800305:	83 f8 02             	cmp    $0x2,%eax
  800308:	74 14                	je     80031e <_main+0x2e6>
  80030a:	83 ec 04             	sub    $0x4,%esp
  80030d:	68 8c 30 80 00       	push   $0x80308c
  800312:	6a 48                	push   $0x48
  800314:	68 45 30 80 00       	push   $0x803045
  800319:	e8 9d 0b 00 00       	call   800ebb <_panic>
		found = 0;
  80031e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800325:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80032c:	e9 82 00 00 00       	jmp    8003b3 <_main+0x37b>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800334:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  80033a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80033d:	89 d0                	mov    %edx,%eax
  80033f:	01 c0                	add    %eax,%eax
  800341:	01 d0                	add    %edx,%eax
  800343:	c1 e0 02             	shl    $0x2,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	8b 00                	mov    (%eax),%eax
  80034a:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80034d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800350:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800355:	89 c2                	mov    %eax,%edx
  800357:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80035a:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80035d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800360:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800365:	39 c2                	cmp    %eax,%edx
  800367:	75 03                	jne    80036c <_main+0x334>
				found++;
  800369:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80036c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80036f:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800375:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800378:	89 d0                	mov    %edx,%eax
  80037a:	01 c0                	add    %eax,%eax
  80037c:	01 d0                	add    %edx,%eax
  80037e:	c1 e0 02             	shl    $0x2,%eax
  800381:	01 c8                	add    %ecx,%eax
  800383:	8b 00                	mov    (%eax),%eax
  800385:	89 45 98             	mov    %eax,-0x68(%ebp)
  800388:	8b 45 98             	mov    -0x68(%ebp),%eax
  80038b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800390:	89 c2                	mov    %eax,%edx
  800392:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800395:	01 c0                	add    %eax,%eax
  800397:	89 c1                	mov    %eax,%ecx
  800399:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80039c:	01 c8                	add    %ecx,%eax
  80039e:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003a1:	8b 45 94             	mov    -0x6c(%ebp),%eax
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
  8003b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
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
  8003cd:	68 d0 30 80 00       	push   $0x8030d0
  8003d2:	6a 51                	push   $0x51
  8003d4:	68 45 30 80 00       	push   $0x803045
  8003d9:	e8 dd 0a 00 00       	call   800ebb <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003de:	e8 d9 25 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  8003e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8003e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e9:	01 c0                	add    %eax,%eax
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	50                   	push   %eax
  8003ef:	e8 75 19 00 00       	call   801d69 <malloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8003fd:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800403:	89 c2                	mov    %eax,%edx
  800405:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800408:	c1 e0 02             	shl    $0x2,%eax
  80040b:	05 00 00 00 80       	add    $0x80000000,%eax
  800410:	39 c2                	cmp    %eax,%edx
  800412:	72 17                	jb     80042b <_main+0x3f3>
  800414:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80041a:	89 c2                	mov    %eax,%edx
  80041c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041f:	c1 e0 02             	shl    $0x2,%eax
  800422:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800427:	39 c2                	cmp    %eax,%edx
  800429:	76 14                	jbe    80043f <_main+0x407>
  80042b:	83 ec 04             	sub    $0x4,%esp
  80042e:	68 e0 2f 80 00       	push   $0x802fe0
  800433:	6a 56                	push   $0x56
  800435:	68 45 30 80 00       	push   $0x803045
  80043a:	e8 7c 0a 00 00       	call   800ebb <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  80043f:	e8 78 25 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  800444:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800447:	83 f8 01             	cmp    $0x1,%eax
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 5c 30 80 00       	push   $0x80305c
  800454:	6a 57                	push   $0x57
  800456:	68 45 30 80 00       	push   $0x803045
  80045b:	e8 5b 0a 00 00       	call   800ebb <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 d4 24 00 00       	call   802939 <sys_calculate_free_frames>
  800465:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  800468:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80046e:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800471:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800474:	01 c0                	add    %eax,%eax
  800476:	c1 e8 02             	shr    $0x2,%eax
  800479:	48                   	dec    %eax
  80047a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  80047d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800480:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800483:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800485:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800492:	01 c2                	add    %eax,%edx
  800494:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800497:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800499:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80049c:	e8 98 24 00 00       	call   802939 <sys_calculate_free_frames>
  8004a1:	29 c3                	sub    %eax,%ebx
  8004a3:	89 d8                	mov    %ebx,%eax
  8004a5:	83 f8 02             	cmp    $0x2,%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 8c 30 80 00       	push   $0x80308c
  8004b2:	6a 5e                	push   $0x5e
  8004b4:	68 45 30 80 00       	push   $0x803045
  8004b9:	e8 fd 09 00 00       	call   800ebb <_panic>
		found = 0;
  8004be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8004c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004cc:	e9 8b 00 00 00       	jmp    80055c <_main+0x524>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  8004d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004d4:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8004da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 02             	shl    $0x2,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	89 45 88             	mov    %eax,-0x78(%ebp)
  8004ed:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004f5:	89 c2                	mov    %eax,%edx
  8004f7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004fa:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8004fd:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800500:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800505:	39 c2                	cmp    %eax,%edx
  800507:	75 03                	jne    80050c <_main+0x4d4>
				found++;
  800509:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  80050c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80050f:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800515:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 02             	shl    $0x2,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8b 00                	mov    (%eax),%eax
  800525:	89 45 80             	mov    %eax,-0x80(%ebp)
  800528:	8b 45 80             	mov    -0x80(%ebp),%eax
  80052b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800530:	89 c2                	mov    %eax,%edx
  800532:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800535:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80053f:	01 c8                	add    %ecx,%eax
  800541:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800547:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80054d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800552:	39 c2                	cmp    %eax,%edx
  800554:	75 03                	jne    800559 <_main+0x521>
				found++;
  800556:	ff 45 f0             	incl   -0x10(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800559:	ff 45 f4             	incl   -0xc(%ebp)
  80055c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80055f:	8b 50 74             	mov    0x74(%eax),%edx
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	39 c2                	cmp    %eax,%edx
  800567:	0f 87 64 ff ff ff    	ja     8004d1 <_main+0x499>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80056d:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800571:	74 14                	je     800587 <_main+0x54f>
  800573:	83 ec 04             	sub    $0x4,%esp
  800576:	68 d0 30 80 00       	push   $0x8030d0
  80057b:	6a 67                	push   $0x67
  80057d:	68 45 30 80 00       	push   $0x803045
  800582:	e8 34 09 00 00       	call   800ebb <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800587:	e8 ad 23 00 00       	call   802939 <sys_calculate_free_frames>
  80058c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80058f:	e8 28 24 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  800594:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800597:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059a:	01 c0                	add    %eax,%eax
  80059c:	83 ec 0c             	sub    $0xc,%esp
  80059f:	50                   	push   %eax
  8005a0:	e8 c4 17 00 00       	call   801d69 <malloc>
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005ae:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  8005b4:	89 c2                	mov    %eax,%edx
  8005b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b9:	c1 e0 02             	shl    $0x2,%eax
  8005bc:	89 c1                	mov    %eax,%ecx
  8005be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c1:	c1 e0 02             	shl    $0x2,%eax
  8005c4:	01 c8                	add    %ecx,%eax
  8005c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8005cb:	39 c2                	cmp    %eax,%edx
  8005cd:	72 21                	jb     8005f0 <_main+0x5b8>
  8005cf:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  8005d5:	89 c2                	mov    %eax,%edx
  8005d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005da:	c1 e0 02             	shl    $0x2,%eax
  8005dd:	89 c1                	mov    %eax,%ecx
  8005df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e2:	c1 e0 02             	shl    $0x2,%eax
  8005e5:	01 c8                	add    %ecx,%eax
  8005e7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8005ec:	39 c2                	cmp    %eax,%edx
  8005ee:	76 14                	jbe    800604 <_main+0x5cc>
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 e0 2f 80 00       	push   $0x802fe0
  8005f8:	6a 6d                	push   $0x6d
  8005fa:	68 45 30 80 00       	push   $0x803045
  8005ff:	e8 b7 08 00 00       	call   800ebb <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800604:	e8 b3 23 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  800609:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80060c:	83 f8 01             	cmp    $0x1,%eax
  80060f:	74 14                	je     800625 <_main+0x5ed>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 5c 30 80 00       	push   $0x80305c
  800619:	6a 6e                	push   $0x6e
  80061b:	68 45 30 80 00       	push   $0x803045
  800620:	e8 96 08 00 00       	call   800ebb <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800625:	e8 92 23 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  80062a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80062d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800630:	89 d0                	mov    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	01 d0                	add    %edx,%eax
  800636:	01 c0                	add    %eax,%eax
  800638:	01 d0                	add    %edx,%eax
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	50                   	push   %eax
  80063e:	e8 26 17 00 00       	call   801d69 <malloc>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80064c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800652:	89 c2                	mov    %eax,%edx
  800654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800657:	c1 e0 02             	shl    $0x2,%eax
  80065a:	89 c1                	mov    %eax,%ecx
  80065c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065f:	c1 e0 03             	shl    $0x3,%eax
  800662:	01 c8                	add    %ecx,%eax
  800664:	05 00 00 00 80       	add    $0x80000000,%eax
  800669:	39 c2                	cmp    %eax,%edx
  80066b:	72 21                	jb     80068e <_main+0x656>
  80066d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800673:	89 c2                	mov    %eax,%edx
  800675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800678:	c1 e0 02             	shl    $0x2,%eax
  80067b:	89 c1                	mov    %eax,%ecx
  80067d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800680:	c1 e0 03             	shl    $0x3,%eax
  800683:	01 c8                	add    %ecx,%eax
  800685:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80068a:	39 c2                	cmp    %eax,%edx
  80068c:	76 14                	jbe    8006a2 <_main+0x66a>
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	68 e0 2f 80 00       	push   $0x802fe0
  800696:	6a 74                	push   $0x74
  800698:	68 45 30 80 00       	push   $0x803045
  80069d:	e8 19 08 00 00       	call   800ebb <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  8006a2:	e8 15 23 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  8006a7:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8006aa:	83 f8 02             	cmp    $0x2,%eax
  8006ad:	74 14                	je     8006c3 <_main+0x68b>
  8006af:	83 ec 04             	sub    $0x4,%esp
  8006b2:	68 5c 30 80 00       	push   $0x80305c
  8006b7:	6a 75                	push   $0x75
  8006b9:	68 45 30 80 00       	push   $0x803045
  8006be:	e8 f8 07 00 00       	call   800ebb <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8006c3:	e8 71 22 00 00       	call   802939 <sys_calculate_free_frames>
  8006c8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  8006cb:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006d1:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8006d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006da:	89 d0                	mov    %edx,%eax
  8006dc:	01 c0                	add    %eax,%eax
  8006de:	01 d0                	add    %edx,%eax
  8006e0:	01 c0                	add    %eax,%eax
  8006e2:	01 d0                	add    %edx,%eax
  8006e4:	c1 e8 03             	shr    $0x3,%eax
  8006e7:	48                   	dec    %eax
  8006e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8006ee:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8006f4:	8a 55 df             	mov    -0x21(%ebp),%dl
  8006f7:	88 10                	mov    %dl,(%eax)
  8006f9:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  8006ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800702:	66 89 42 02          	mov    %ax,0x2(%edx)
  800706:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80070c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80070f:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800712:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800718:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80071f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800725:	01 c2                	add    %eax,%edx
  800727:	8a 45 de             	mov    -0x22(%ebp),%al
  80072a:	88 02                	mov    %al,(%edx)
  80072c:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800732:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800739:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80073f:	01 c2                	add    %eax,%edx
  800741:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800745:	66 89 42 02          	mov    %ax,0x2(%edx)
  800749:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80074f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800756:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80075c:	01 c2                	add    %eax,%edx
  80075e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800761:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800764:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800767:	e8 cd 21 00 00       	call   802939 <sys_calculate_free_frames>
  80076c:	29 c3                	sub    %eax,%ebx
  80076e:	89 d8                	mov    %ebx,%eax
  800770:	83 f8 02             	cmp    $0x2,%eax
  800773:	74 14                	je     800789 <_main+0x751>
  800775:	83 ec 04             	sub    $0x4,%esp
  800778:	68 8c 30 80 00       	push   $0x80308c
  80077d:	6a 7c                	push   $0x7c
  80077f:	68 45 30 80 00       	push   $0x803045
  800784:	e8 32 07 00 00       	call   800ebb <_panic>
		found = 0;
  800789:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800797:	e9 a6 00 00 00       	jmp    800842 <_main+0x80a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  80079c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80079f:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8007a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a8:	89 d0                	mov    %edx,%eax
  8007aa:	01 c0                	add    %eax,%eax
  8007ac:	01 d0                	add    %edx,%eax
  8007ae:	c1 e0 02             	shl    $0x2,%eax
  8007b1:	01 c8                	add    %ecx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  8007bb:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8007c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007c6:	89 c2                	mov    %eax,%edx
  8007c8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ce:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8007d4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007df:	39 c2                	cmp    %eax,%edx
  8007e1:	75 03                	jne    8007e6 <_main+0x7ae>
				found++;
  8007e3:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  8007e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e9:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  8007ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f2:	89 d0                	mov    %edx,%eax
  8007f4:	01 c0                	add    %eax,%eax
  8007f6:	01 d0                	add    %edx,%eax
  8007f8:	c1 e0 02             	shl    $0x2,%eax
  8007fb:	01 c8                	add    %ecx,%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800805:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80080b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800810:	89 c2                	mov    %eax,%edx
  800812:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800818:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80081f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800825:	01 c8                	add    %ecx,%eax
  800827:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80082d:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800833:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800838:	39 c2                	cmp    %eax,%edx
  80083a:	75 03                	jne    80083f <_main+0x807>
				found++;
  80083c:	ff 45 f0             	incl   -0x10(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80083f:	ff 45 f4             	incl   -0xc(%ebp)
  800842:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800845:	8b 50 74             	mov    0x74(%eax),%edx
  800848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084b:	39 c2                	cmp    %eax,%edx
  80084d:	0f 87 49 ff ff ff    	ja     80079c <_main+0x764>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800853:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800857:	74 17                	je     800870 <_main+0x838>
  800859:	83 ec 04             	sub    $0x4,%esp
  80085c:	68 d0 30 80 00       	push   $0x8030d0
  800861:	68 85 00 00 00       	push   $0x85
  800866:	68 45 30 80 00       	push   $0x803045
  80086b:	e8 4b 06 00 00       	call   800ebb <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800870:	e8 c4 20 00 00       	call   802939 <sys_calculate_free_frames>
  800875:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800878:	e8 3f 21 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  80087d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800883:	89 c2                	mov    %eax,%edx
  800885:	01 d2                	add    %edx,%edx
  800887:	01 d0                	add    %edx,%eax
  800889:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80088c:	83 ec 0c             	sub    $0xc,%esp
  80088f:	50                   	push   %eax
  800890:	e8 d4 14 00 00       	call   801d69 <malloc>
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80089e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008a4:	89 c2                	mov    %eax,%edx
  8008a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008a9:	c1 e0 02             	shl    $0x2,%eax
  8008ac:	89 c1                	mov    %eax,%ecx
  8008ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b1:	c1 e0 04             	shl    $0x4,%eax
  8008b4:	01 c8                	add    %ecx,%eax
  8008b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	72 21                	jb     8008e0 <_main+0x8a8>
  8008bf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008c5:	89 c2                	mov    %eax,%edx
  8008c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ca:	c1 e0 02             	shl    $0x2,%eax
  8008cd:	89 c1                	mov    %eax,%ecx
  8008cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d2:	c1 e0 04             	shl    $0x4,%eax
  8008d5:	01 c8                	add    %ecx,%eax
  8008d7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8008dc:	39 c2                	cmp    %eax,%edx
  8008de:	76 17                	jbe    8008f7 <_main+0x8bf>
  8008e0:	83 ec 04             	sub    $0x4,%esp
  8008e3:	68 e0 2f 80 00       	push   $0x802fe0
  8008e8:	68 8b 00 00 00       	push   $0x8b
  8008ed:	68 45 30 80 00       	push   $0x803045
  8008f2:	e8 c4 05 00 00       	call   800ebb <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8008f7:	e8 c0 20 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  8008fc:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800904:	89 c1                	mov    %eax,%ecx
  800906:	01 c9                	add    %ecx,%ecx
  800908:	01 c8                	add    %ecx,%eax
  80090a:	85 c0                	test   %eax,%eax
  80090c:	79 05                	jns    800913 <_main+0x8db>
  80090e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800913:	c1 f8 0c             	sar    $0xc,%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 5c 30 80 00       	push   $0x80305c
  800922:	68 8c 00 00 00       	push   $0x8c
  800927:	68 45 30 80 00       	push   $0x803045
  80092c:	e8 8a 05 00 00       	call   800ebb <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800931:	e8 86 20 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  800936:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800939:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80093c:	89 d0                	mov    %edx,%eax
  80093e:	01 c0                	add    %eax,%eax
  800940:	01 d0                	add    %edx,%eax
  800942:	01 c0                	add    %eax,%eax
  800944:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800947:	83 ec 0c             	sub    $0xc,%esp
  80094a:	50                   	push   %eax
  80094b:	e8 19 14 00 00       	call   801d69 <malloc>
  800950:	83 c4 10             	add    $0x10,%esp
  800953:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800959:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80095f:	89 c1                	mov    %eax,%ecx
  800961:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800964:	89 d0                	mov    %edx,%eax
  800966:	01 c0                	add    %eax,%eax
  800968:	01 d0                	add    %edx,%eax
  80096a:	01 c0                	add    %eax,%eax
  80096c:	01 d0                	add    %edx,%eax
  80096e:	89 c2                	mov    %eax,%edx
  800970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800973:	c1 e0 04             	shl    $0x4,%eax
  800976:	01 d0                	add    %edx,%eax
  800978:	05 00 00 00 80       	add    $0x80000000,%eax
  80097d:	39 c1                	cmp    %eax,%ecx
  80097f:	72 28                	jb     8009a9 <_main+0x971>
  800981:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800987:	89 c1                	mov    %eax,%ecx
  800989:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80098c:	89 d0                	mov    %edx,%eax
  80098e:	01 c0                	add    %eax,%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	01 c0                	add    %eax,%eax
  800994:	01 d0                	add    %edx,%eax
  800996:	89 c2                	mov    %eax,%edx
  800998:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80099b:	c1 e0 04             	shl    $0x4,%eax
  80099e:	01 d0                	add    %edx,%eax
  8009a0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009a5:	39 c1                	cmp    %eax,%ecx
  8009a7:	76 17                	jbe    8009c0 <_main+0x988>
  8009a9:	83 ec 04             	sub    $0x4,%esp
  8009ac:	68 e0 2f 80 00       	push   $0x802fe0
  8009b1:	68 92 00 00 00       	push   $0x92
  8009b6:	68 45 30 80 00       	push   $0x803045
  8009bb:	e8 fb 04 00 00       	call   800ebb <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8009c0:	e8 f7 1f 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  8009c5:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8009c8:	89 c1                	mov    %eax,%ecx
  8009ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009cd:	89 d0                	mov    %edx,%eax
  8009cf:	01 c0                	add    %eax,%eax
  8009d1:	01 d0                	add    %edx,%eax
  8009d3:	01 c0                	add    %eax,%eax
  8009d5:	85 c0                	test   %eax,%eax
  8009d7:	79 05                	jns    8009de <_main+0x9a6>
  8009d9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009de:	c1 f8 0c             	sar    $0xc,%eax
  8009e1:	39 c1                	cmp    %eax,%ecx
  8009e3:	74 17                	je     8009fc <_main+0x9c4>
  8009e5:	83 ec 04             	sub    $0x4,%esp
  8009e8:	68 5c 30 80 00       	push   $0x80305c
  8009ed:	68 93 00 00 00       	push   $0x93
  8009f2:	68 45 30 80 00       	push   $0x803045
  8009f7:	e8 bf 04 00 00       	call   800ebb <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8009fc:	e8 38 1f 00 00       	call   802939 <sys_calculate_free_frames>
  800a01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a07:	89 d0                	mov    %edx,%eax
  800a09:	01 c0                	add    %eax,%eax
  800a0b:	01 d0                	add    %edx,%eax
  800a0d:	01 c0                	add    %eax,%eax
  800a0f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a12:	48                   	dec    %eax
  800a13:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a19:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a1f:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a25:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a2b:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a2e:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a30:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a36:	89 c2                	mov    %eax,%edx
  800a38:	c1 ea 1f             	shr    $0x1f,%edx
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	d1 f8                	sar    %eax
  800a3f:	89 c2                	mov    %eax,%edx
  800a41:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a47:	01 c2                	add    %eax,%edx
  800a49:	8a 45 de             	mov    -0x22(%ebp),%al
  800a4c:	88 c1                	mov    %al,%cl
  800a4e:	c0 e9 07             	shr    $0x7,%cl
  800a51:	01 c8                	add    %ecx,%eax
  800a53:	d0 f8                	sar    %al
  800a55:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a57:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a5d:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a63:	01 c2                	add    %eax,%edx
  800a65:	8a 45 de             	mov    -0x22(%ebp),%al
  800a68:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a6a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a6d:	e8 c7 1e 00 00       	call   802939 <sys_calculate_free_frames>
  800a72:	29 c3                	sub    %eax,%ebx
  800a74:	89 d8                	mov    %ebx,%eax
  800a76:	83 f8 05             	cmp    $0x5,%eax
  800a79:	74 17                	je     800a92 <_main+0xa5a>
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 8c 30 80 00       	push   $0x80308c
  800a83:	68 9b 00 00 00       	push   $0x9b
  800a88:	68 45 30 80 00       	push   $0x803045
  800a8d:	e8 29 04 00 00       	call   800ebb <_panic>
		found = 0;
  800a92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800a99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800aa0:	e9 fc 00 00 00       	jmp    800ba1 <_main+0xb69>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800aa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800aa8:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800aae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab1:	89 d0                	mov    %edx,%eax
  800ab3:	01 c0                	add    %eax,%eax
  800ab5:	01 d0                	add    %edx,%eax
  800ab7:	c1 e0 02             	shl    $0x2,%eax
  800aba:	01 c8                	add    %ecx,%eax
  800abc:	8b 00                	mov    (%eax),%eax
  800abe:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800ac4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800aca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800ad7:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800add:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800ae3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ae8:	39 c2                	cmp    %eax,%edx
  800aea:	75 03                	jne    800aef <_main+0xab7>
				found++;
  800aec:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af2:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afb:	89 d0                	mov    %edx,%eax
  800afd:	01 c0                	add    %eax,%eax
  800aff:	01 d0                	add    %edx,%eax
  800b01:	c1 e0 02             	shl    $0x2,%eax
  800b04:	01 c8                	add    %ecx,%eax
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b0e:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b19:	89 c2                	mov    %eax,%edx
  800b1b:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b21:	89 c1                	mov    %eax,%ecx
  800b23:	c1 e9 1f             	shr    $0x1f,%ecx
  800b26:	01 c8                	add    %ecx,%eax
  800b28:	d1 f8                	sar    %eax
  800b2a:	89 c1                	mov    %eax,%ecx
  800b2c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b32:	01 c8                	add    %ecx,%eax
  800b34:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b3a:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b40:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b45:	39 c2                	cmp    %eax,%edx
  800b47:	75 03                	jne    800b4c <_main+0xb14>
				found++;
  800b49:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b4f:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b58:	89 d0                	mov    %edx,%eax
  800b5a:	01 c0                	add    %eax,%eax
  800b5c:	01 d0                	add    %edx,%eax
  800b5e:	c1 e0 02             	shl    $0x2,%eax
  800b61:	01 c8                	add    %ecx,%eax
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b6b:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b76:	89 c1                	mov    %eax,%ecx
  800b78:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800b7e:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800b8c:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800b92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b97:	39 c1                	cmp    %eax,%ecx
  800b99:	75 03                	jne    800b9e <_main+0xb66>
				found++;
  800b9b:	ff 45 f0             	incl   -0x10(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b9e:	ff 45 f4             	incl   -0xc(%ebp)
  800ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba4:	8b 50 74             	mov    0x74(%eax),%edx
  800ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	0f 87 f3 fe ff ff    	ja     800aa5 <_main+0xa6d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bb2:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800bb6:	74 17                	je     800bcf <_main+0xb97>
  800bb8:	83 ec 04             	sub    $0x4,%esp
  800bbb:	68 d0 30 80 00       	push   $0x8030d0
  800bc0:	68 a6 00 00 00       	push   $0xa6
  800bc5:	68 45 30 80 00       	push   $0x803045
  800bca:	e8 ec 02 00 00       	call   800ebb <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bcf:	e8 e8 1d 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  800bd4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800bd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bda:	89 d0                	mov    %edx,%eax
  800bdc:	01 c0                	add    %eax,%eax
  800bde:	01 d0                	add    %edx,%eax
  800be0:	01 c0                	add    %eax,%eax
  800be2:	01 d0                	add    %edx,%eax
  800be4:	01 c0                	add    %eax,%eax
  800be6:	83 ec 0c             	sub    $0xc,%esp
  800be9:	50                   	push   %eax
  800bea:	e8 7a 11 00 00       	call   801d69 <malloc>
  800bef:	83 c4 10             	add    $0x10,%esp
  800bf2:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bf8:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800bfe:	89 c1                	mov    %eax,%ecx
  800c00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c03:	89 d0                	mov    %edx,%eax
  800c05:	01 c0                	add    %eax,%eax
  800c07:	01 d0                	add    %edx,%eax
  800c09:	c1 e0 02             	shl    $0x2,%eax
  800c0c:	01 d0                	add    %edx,%eax
  800c0e:	89 c2                	mov    %eax,%edx
  800c10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c13:	c1 e0 04             	shl    $0x4,%eax
  800c16:	01 d0                	add    %edx,%eax
  800c18:	05 00 00 00 80       	add    $0x80000000,%eax
  800c1d:	39 c1                	cmp    %eax,%ecx
  800c1f:	72 29                	jb     800c4a <_main+0xc12>
  800c21:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c27:	89 c1                	mov    %eax,%ecx
  800c29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c2c:	89 d0                	mov    %edx,%eax
  800c2e:	01 c0                	add    %eax,%eax
  800c30:	01 d0                	add    %edx,%eax
  800c32:	c1 e0 02             	shl    $0x2,%eax
  800c35:	01 d0                	add    %edx,%eax
  800c37:	89 c2                	mov    %eax,%edx
  800c39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c3c:	c1 e0 04             	shl    $0x4,%eax
  800c3f:	01 d0                	add    %edx,%eax
  800c41:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c46:	39 c1                	cmp    %eax,%ecx
  800c48:	76 17                	jbe    800c61 <_main+0xc29>
  800c4a:	83 ec 04             	sub    $0x4,%esp
  800c4d:	68 e0 2f 80 00       	push   $0x802fe0
  800c52:	68 ab 00 00 00       	push   $0xab
  800c57:	68 45 30 80 00       	push   $0x803045
  800c5c:	e8 5a 02 00 00       	call   800ebb <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  800c61:	e8 56 1d 00 00       	call   8029bc <sys_pf_calculate_allocated_pages>
  800c66:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800c69:	83 f8 04             	cmp    $0x4,%eax
  800c6c:	74 17                	je     800c85 <_main+0xc4d>
  800c6e:	83 ec 04             	sub    $0x4,%esp
  800c71:	68 5c 30 80 00       	push   $0x80305c
  800c76:	68 ac 00 00 00       	push   $0xac
  800c7b:	68 45 30 80 00       	push   $0x803045
  800c80:	e8 36 02 00 00       	call   800ebb <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c85:	e8 af 1c 00 00       	call   802939 <sys_calculate_free_frames>
  800c8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800c8d:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c93:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800c99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9c:	89 d0                	mov    %edx,%eax
  800c9e:	01 c0                	add    %eax,%eax
  800ca0:	01 d0                	add    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d0                	add    %edx,%eax
  800ca6:	01 c0                	add    %eax,%eax
  800ca8:	d1 e8                	shr    %eax
  800caa:	48                   	dec    %eax
  800cab:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cb1:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800cb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800cba:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800cbd:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cc3:	01 c0                	add    %eax,%eax
  800cc5:	89 c2                	mov    %eax,%edx
  800cc7:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ccd:	01 c2                	add    %eax,%edx
  800ccf:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800cd3:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800cd6:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800cd9:	e8 5b 1c 00 00       	call   802939 <sys_calculate_free_frames>
  800cde:	29 c3                	sub    %eax,%ebx
  800ce0:	89 d8                	mov    %ebx,%eax
  800ce2:	83 f8 02             	cmp    $0x2,%eax
  800ce5:	74 17                	je     800cfe <_main+0xcc6>
  800ce7:	83 ec 04             	sub    $0x4,%esp
  800cea:	68 8c 30 80 00       	push   $0x80308c
  800cef:	68 b3 00 00 00       	push   $0xb3
  800cf4:	68 45 30 80 00       	push   $0x803045
  800cf9:	e8 bd 01 00 00       	call   800ebb <_panic>
		found = 0;
  800cfe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d0c:	e9 a3 00 00 00       	jmp    800db4 <_main+0xd7c>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d14:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d1d:	89 d0                	mov    %edx,%eax
  800d1f:	01 c0                	add    %eax,%eax
  800d21:	01 d0                	add    %edx,%eax
  800d23:	c1 e0 02             	shl    $0x2,%eax
  800d26:	01 c8                	add    %ecx,%eax
  800d28:	8b 00                	mov    (%eax),%eax
  800d2a:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d30:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d3b:	89 c2                	mov    %eax,%edx
  800d3d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d43:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d49:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d54:	39 c2                	cmp    %eax,%edx
  800d56:	75 03                	jne    800d5b <_main+0xd23>
				found++;
  800d58:	ff 45 f0             	incl   -0x10(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d5e:	8b 88 f4 02 00 00    	mov    0x2f4(%eax),%ecx
  800d64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d67:	89 d0                	mov    %edx,%eax
  800d69:	01 c0                	add    %eax,%eax
  800d6b:	01 d0                	add    %edx,%eax
  800d6d:	c1 e0 02             	shl    $0x2,%eax
  800d70:	01 c8                	add    %ecx,%eax
  800d72:	8b 00                	mov    (%eax),%eax
  800d74:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d7a:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d85:	89 c2                	mov    %eax,%edx
  800d87:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d8d:	01 c0                	add    %eax,%eax
  800d8f:	89 c1                	mov    %eax,%ecx
  800d91:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d97:	01 c8                	add    %ecx,%eax
  800d99:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800d9f:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800da5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	75 03                	jne    800db1 <_main+0xd79>
				found++;
  800dae:	ff 45 f0             	incl   -0x10(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800db1:	ff 45 f4             	incl   -0xc(%ebp)
  800db4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800db7:	8b 50 74             	mov    0x74(%eax),%edx
  800dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dbd:	39 c2                	cmp    %eax,%edx
  800dbf:	0f 87 4c ff ff ff    	ja     800d11 <_main+0xcd9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800dc5:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800dc9:	74 17                	je     800de2 <_main+0xdaa>
  800dcb:	83 ec 04             	sub    $0x4,%esp
  800dce:	68 d0 30 80 00       	push   $0x8030d0
  800dd3:	68 bc 00 00 00       	push   $0xbc
  800dd8:	68 45 30 80 00       	push   $0x803045
  800ddd:	e8 d9 00 00 00       	call   800ebb <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800de2:	83 ec 0c             	sub    $0xc,%esp
  800de5:	68 f0 30 80 00       	push   $0x8030f0
  800dea:	e8 f7 01 00 00       	call   800fe6 <cprintf>
  800def:	83 c4 10             	add    $0x10,%esp

	return;
  800df2:	90                   	nop
}
  800df3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    

00800dfa <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e04:	7e 0a                	jle    800e10 <libmain+0x16>
		binaryname = argv[0];
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8b 00                	mov    (%eax),%eax
  800e0b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	ff 75 0c             	pushl  0xc(%ebp)
  800e16:	ff 75 08             	pushl  0x8(%ebp)
  800e19:	e8 1a f2 ff ff       	call   800038 <_main>
  800e1e:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800e21:	e8 61 1a 00 00       	call   802887 <sys_getenvid>
  800e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2c:	89 d0                	mov    %edx,%eax
  800e2e:	c1 e0 03             	shl    $0x3,%eax
  800e31:	01 d0                	add    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3e:	01 d0                	add    %edx,%eax
  800e40:	c1 e0 03             	shl    $0x3,%eax
  800e43:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e48:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800e4b:	e8 85 1b 00 00       	call   8029d5 <sys_disable_interrupt>
		cprintf("**************************************\n");
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	68 44 31 80 00       	push   $0x803144
  800e58:	e8 89 01 00 00       	call   800fe6 <cprintf>
  800e5d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e63:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800e69:	83 ec 08             	sub    $0x8,%esp
  800e6c:	50                   	push   %eax
  800e6d:	68 6c 31 80 00       	push   $0x80316c
  800e72:	e8 6f 01 00 00       	call   800fe6 <cprintf>
  800e77:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	68 44 31 80 00       	push   $0x803144
  800e82:	e8 5f 01 00 00       	call   800fe6 <cprintf>
  800e87:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e8a:	e8 60 1b 00 00       	call   8029ef <sys_enable_interrupt>

	// exit gracefully
	exit();
  800e8f:	e8 19 00 00 00       	call   800ead <exit>
}
  800e94:	90                   	nop
  800e95:	c9                   	leave  
  800e96:	c3                   	ret    

00800e97 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800e9d:	83 ec 0c             	sub    $0xc,%esp
  800ea0:	6a 00                	push   $0x0
  800ea2:	e8 c5 19 00 00       	call   80286c <sys_env_destroy>
  800ea7:	83 c4 10             	add    $0x10,%esp
}
  800eaa:	90                   	nop
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <exit>:

void
exit(void)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800eb3:	e8 e8 19 00 00       	call   8028a0 <sys_env_exit>
}
  800eb8:	90                   	nop
  800eb9:	c9                   	leave  
  800eba:	c3                   	ret    

00800ebb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ec1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec4:	83 c0 04             	add    $0x4,%eax
  800ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800eca:	a1 50 40 98 00       	mov    0x984050,%eax
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	74 16                	je     800ee9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ed3:	a1 50 40 98 00       	mov    0x984050,%eax
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	50                   	push   %eax
  800edc:	68 85 31 80 00       	push   $0x803185
  800ee1:	e8 00 01 00 00       	call   800fe6 <cprintf>
  800ee6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ee9:	a1 00 40 80 00       	mov    0x804000,%eax
  800eee:	ff 75 0c             	pushl  0xc(%ebp)
  800ef1:	ff 75 08             	pushl  0x8(%ebp)
  800ef4:	50                   	push   %eax
  800ef5:	68 8a 31 80 00       	push   $0x80318a
  800efa:	e8 e7 00 00 00       	call   800fe6 <cprintf>
  800eff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f02:	8b 45 10             	mov    0x10(%ebp),%eax
  800f05:	83 ec 08             	sub    $0x8,%esp
  800f08:	ff 75 f4             	pushl  -0xc(%ebp)
  800f0b:	50                   	push   %eax
  800f0c:	e8 7a 00 00 00       	call   800f8b <vcprintf>
  800f11:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	68 a6 31 80 00       	push   $0x8031a6
  800f1c:	e8 c5 00 00 00       	call   800fe6 <cprintf>
  800f21:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f24:	e8 84 ff ff ff       	call   800ead <exit>

	// should not return here
	while (1) ;
  800f29:	eb fe                	jmp    800f29 <_panic+0x6e>

00800f2b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8b 00                	mov    (%eax),%eax
  800f36:	8d 48 01             	lea    0x1(%eax),%ecx
  800f39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3c:	89 0a                	mov    %ecx,(%edx)
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	88 d1                	mov    %dl,%cl
  800f43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f46:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f54:	75 23                	jne    800f79 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	8b 00                	mov    (%eax),%eax
  800f5b:	89 c2                	mov    %eax,%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	83 c0 08             	add    $0x8,%eax
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	52                   	push   %edx
  800f67:	50                   	push   %eax
  800f68:	e8 c9 18 00 00       	call   802836 <sys_cputs>
  800f6d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	8b 40 04             	mov    0x4(%eax),%eax
  800f7f:	8d 50 01             	lea    0x1(%eax),%edx
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f88:	90                   	nop
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f94:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f9b:	00 00 00 
	b.cnt = 0;
  800f9e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800fa5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800fa8:	ff 75 0c             	pushl  0xc(%ebp)
  800fab:	ff 75 08             	pushl  0x8(%ebp)
  800fae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fb4:	50                   	push   %eax
  800fb5:	68 2b 0f 80 00       	push   $0x800f2b
  800fba:	e8 fa 01 00 00       	call   8011b9 <vprintfmt>
  800fbf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800fc2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800fc8:	83 ec 08             	sub    $0x8,%esp
  800fcb:	50                   	push   %eax
  800fcc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fd2:	83 c0 08             	add    $0x8,%eax
  800fd5:	50                   	push   %eax
  800fd6:	e8 5b 18 00 00       	call   802836 <sys_cputs>
  800fdb:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800fde:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <cprintf>:

int cprintf(const char *fmt, ...) {
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800fec:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	83 ec 08             	sub    $0x8,%esp
  800ff8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffb:	50                   	push   %eax
  800ffc:	e8 8a ff ff ff       	call   800f8b <vcprintf>
  801001:	83 c4 10             	add    $0x10,%esp
  801004:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801007:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801012:	e8 be 19 00 00       	call   8029d5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801017:	8d 45 0c             	lea    0xc(%ebp),%eax
  80101a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	83 ec 08             	sub    $0x8,%esp
  801023:	ff 75 f4             	pushl  -0xc(%ebp)
  801026:	50                   	push   %eax
  801027:	e8 5f ff ff ff       	call   800f8b <vcprintf>
  80102c:	83 c4 10             	add    $0x10,%esp
  80102f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801032:	e8 b8 19 00 00       	call   8029ef <sys_enable_interrupt>
	return cnt;
  801037:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	53                   	push   %ebx
  801040:	83 ec 14             	sub    $0x14,%esp
  801043:	8b 45 10             	mov    0x10(%ebp),%eax
  801046:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801049:	8b 45 14             	mov    0x14(%ebp),%eax
  80104c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80104f:	8b 45 18             	mov    0x18(%ebp),%eax
  801052:	ba 00 00 00 00       	mov    $0x0,%edx
  801057:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80105a:	77 55                	ja     8010b1 <printnum+0x75>
  80105c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80105f:	72 05                	jb     801066 <printnum+0x2a>
  801061:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801064:	77 4b                	ja     8010b1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801066:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801069:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80106c:	8b 45 18             	mov    0x18(%ebp),%eax
  80106f:	ba 00 00 00 00       	mov    $0x0,%edx
  801074:	52                   	push   %edx
  801075:	50                   	push   %eax
  801076:	ff 75 f4             	pushl  -0xc(%ebp)
  801079:	ff 75 f0             	pushl  -0x10(%ebp)
  80107c:	e8 f3 1c 00 00       	call   802d74 <__udivdi3>
  801081:	83 c4 10             	add    $0x10,%esp
  801084:	83 ec 04             	sub    $0x4,%esp
  801087:	ff 75 20             	pushl  0x20(%ebp)
  80108a:	53                   	push   %ebx
  80108b:	ff 75 18             	pushl  0x18(%ebp)
  80108e:	52                   	push   %edx
  80108f:	50                   	push   %eax
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	ff 75 08             	pushl  0x8(%ebp)
  801096:	e8 a1 ff ff ff       	call   80103c <printnum>
  80109b:	83 c4 20             	add    $0x20,%esp
  80109e:	eb 1a                	jmp    8010ba <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8010a0:	83 ec 08             	sub    $0x8,%esp
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 20             	pushl  0x20(%ebp)
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	ff d0                	call   *%eax
  8010ae:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010b1:	ff 4d 1c             	decl   0x1c(%ebp)
  8010b4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010b8:	7f e6                	jg     8010a0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010ba:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c8:	53                   	push   %ebx
  8010c9:	51                   	push   %ecx
  8010ca:	52                   	push   %edx
  8010cb:	50                   	push   %eax
  8010cc:	e8 b3 1d 00 00       	call   802e84 <__umoddi3>
  8010d1:	83 c4 10             	add    $0x10,%esp
  8010d4:	05 d4 33 80 00       	add    $0x8033d4,%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	0f be c0             	movsbl %al,%eax
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 0c             	pushl  0xc(%ebp)
  8010e4:	50                   	push   %eax
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	ff d0                	call   *%eax
  8010ea:	83 c4 10             	add    $0x10,%esp
}
  8010ed:	90                   	nop
  8010ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f1:	c9                   	leave  
  8010f2:	c3                   	ret    

008010f3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010f6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010fa:	7e 1c                	jle    801118 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8b 00                	mov    (%eax),%eax
  801101:	8d 50 08             	lea    0x8(%eax),%edx
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 10                	mov    %edx,(%eax)
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8b 00                	mov    (%eax),%eax
  80110e:	83 e8 08             	sub    $0x8,%eax
  801111:	8b 50 04             	mov    0x4(%eax),%edx
  801114:	8b 00                	mov    (%eax),%eax
  801116:	eb 40                	jmp    801158 <getuint+0x65>
	else if (lflag)
  801118:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80111c:	74 1e                	je     80113c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 50 04             	lea    0x4(%eax),%edx
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 10                	mov    %edx,(%eax)
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	83 e8 04             	sub    $0x4,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	ba 00 00 00 00       	mov    $0x0,%edx
  80113a:	eb 1c                	jmp    801158 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 50 04             	lea    0x4(%eax),%edx
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	89 10                	mov    %edx,(%eax)
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8b 00                	mov    (%eax),%eax
  80114e:	83 e8 04             	sub    $0x4,%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    

0080115a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80115d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801161:	7e 1c                	jle    80117f <getint+0x25>
		return va_arg(*ap, long long);
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8b 00                	mov    (%eax),%eax
  801168:	8d 50 08             	lea    0x8(%eax),%edx
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	89 10                	mov    %edx,(%eax)
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8b 00                	mov    (%eax),%eax
  801175:	83 e8 08             	sub    $0x8,%eax
  801178:	8b 50 04             	mov    0x4(%eax),%edx
  80117b:	8b 00                	mov    (%eax),%eax
  80117d:	eb 38                	jmp    8011b7 <getint+0x5d>
	else if (lflag)
  80117f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801183:	74 1a                	je     80119f <getint+0x45>
		return va_arg(*ap, long);
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8b 00                	mov    (%eax),%eax
  80118a:	8d 50 04             	lea    0x4(%eax),%edx
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	89 10                	mov    %edx,(%eax)
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8b 00                	mov    (%eax),%eax
  801197:	83 e8 04             	sub    $0x4,%eax
  80119a:	8b 00                	mov    (%eax),%eax
  80119c:	99                   	cltd   
  80119d:	eb 18                	jmp    8011b7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8b 00                	mov    (%eax),%eax
  8011a4:	8d 50 04             	lea    0x4(%eax),%edx
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	89 10                	mov    %edx,(%eax)
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8b 00                	mov    (%eax),%eax
  8011b1:	83 e8 04             	sub    $0x4,%eax
  8011b4:	8b 00                	mov    (%eax),%eax
  8011b6:	99                   	cltd   
}
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	56                   	push   %esi
  8011bd:	53                   	push   %ebx
  8011be:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011c1:	eb 17                	jmp    8011da <vprintfmt+0x21>
			if (ch == '\0')
  8011c3:	85 db                	test   %ebx,%ebx
  8011c5:	0f 84 af 03 00 00    	je     80157a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011cb:	83 ec 08             	sub    $0x8,%esp
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	53                   	push   %ebx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	ff d0                	call   *%eax
  8011d7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	8d 50 01             	lea    0x1(%eax),%edx
  8011e0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	0f b6 d8             	movzbl %al,%ebx
  8011e8:	83 fb 25             	cmp    $0x25,%ebx
  8011eb:	75 d6                	jne    8011c3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011ed:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011f1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8011f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8011ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801206:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80120d:	8b 45 10             	mov    0x10(%ebp),%eax
  801210:	8d 50 01             	lea    0x1(%eax),%edx
  801213:	89 55 10             	mov    %edx,0x10(%ebp)
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 d8             	movzbl %al,%ebx
  80121b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80121e:	83 f8 55             	cmp    $0x55,%eax
  801221:	0f 87 2b 03 00 00    	ja     801552 <vprintfmt+0x399>
  801227:	8b 04 85 f8 33 80 00 	mov    0x8033f8(,%eax,4),%eax
  80122e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801230:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801234:	eb d7                	jmp    80120d <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801236:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80123a:	eb d1                	jmp    80120d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80123c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801243:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801246:	89 d0                	mov    %edx,%eax
  801248:	c1 e0 02             	shl    $0x2,%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	01 c0                	add    %eax,%eax
  80124f:	01 d8                	add    %ebx,%eax
  801251:	83 e8 30             	sub    $0x30,%eax
  801254:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801257:	8b 45 10             	mov    0x10(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80125f:	83 fb 2f             	cmp    $0x2f,%ebx
  801262:	7e 3e                	jle    8012a2 <vprintfmt+0xe9>
  801264:	83 fb 39             	cmp    $0x39,%ebx
  801267:	7f 39                	jg     8012a2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801269:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80126c:	eb d5                	jmp    801243 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80126e:	8b 45 14             	mov    0x14(%ebp),%eax
  801271:	83 c0 04             	add    $0x4,%eax
  801274:	89 45 14             	mov    %eax,0x14(%ebp)
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	83 e8 04             	sub    $0x4,%eax
  80127d:	8b 00                	mov    (%eax),%eax
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801282:	eb 1f                	jmp    8012a3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801284:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801288:	79 83                	jns    80120d <vprintfmt+0x54>
				width = 0;
  80128a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801291:	e9 77 ff ff ff       	jmp    80120d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801296:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80129d:	e9 6b ff ff ff       	jmp    80120d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8012a2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a7:	0f 89 60 ff ff ff    	jns    80120d <vprintfmt+0x54>
				width = precision, precision = -1;
  8012ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012b3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012ba:	e9 4e ff ff ff       	jmp    80120d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012bf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012c2:	e9 46 ff ff ff       	jmp    80120d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ca:	83 c0 04             	add    $0x4,%eax
  8012cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8012d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d3:	83 e8 04             	sub    $0x4,%eax
  8012d6:	8b 00                	mov    (%eax),%eax
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	ff 75 0c             	pushl  0xc(%ebp)
  8012de:	50                   	push   %eax
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	ff d0                	call   *%eax
  8012e4:	83 c4 10             	add    $0x10,%esp
			break;
  8012e7:	e9 89 02 00 00       	jmp    801575 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ef:	83 c0 04             	add    $0x4,%eax
  8012f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8012f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f8:	83 e8 04             	sub    $0x4,%eax
  8012fb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8012fd:	85 db                	test   %ebx,%ebx
  8012ff:	79 02                	jns    801303 <vprintfmt+0x14a>
				err = -err;
  801301:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801303:	83 fb 64             	cmp    $0x64,%ebx
  801306:	7f 0b                	jg     801313 <vprintfmt+0x15a>
  801308:	8b 34 9d 40 32 80 00 	mov    0x803240(,%ebx,4),%esi
  80130f:	85 f6                	test   %esi,%esi
  801311:	75 19                	jne    80132c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801313:	53                   	push   %ebx
  801314:	68 e5 33 80 00       	push   $0x8033e5
  801319:	ff 75 0c             	pushl  0xc(%ebp)
  80131c:	ff 75 08             	pushl  0x8(%ebp)
  80131f:	e8 5e 02 00 00       	call   801582 <printfmt>
  801324:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801327:	e9 49 02 00 00       	jmp    801575 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80132c:	56                   	push   %esi
  80132d:	68 ee 33 80 00       	push   $0x8033ee
  801332:	ff 75 0c             	pushl  0xc(%ebp)
  801335:	ff 75 08             	pushl  0x8(%ebp)
  801338:	e8 45 02 00 00       	call   801582 <printfmt>
  80133d:	83 c4 10             	add    $0x10,%esp
			break;
  801340:	e9 30 02 00 00       	jmp    801575 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	83 c0 04             	add    $0x4,%eax
  80134b:	89 45 14             	mov    %eax,0x14(%ebp)
  80134e:	8b 45 14             	mov    0x14(%ebp),%eax
  801351:	83 e8 04             	sub    $0x4,%eax
  801354:	8b 30                	mov    (%eax),%esi
  801356:	85 f6                	test   %esi,%esi
  801358:	75 05                	jne    80135f <vprintfmt+0x1a6>
				p = "(null)";
  80135a:	be f1 33 80 00       	mov    $0x8033f1,%esi
			if (width > 0 && padc != '-')
  80135f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801363:	7e 6d                	jle    8013d2 <vprintfmt+0x219>
  801365:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801369:	74 67                	je     8013d2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80136b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136e:	83 ec 08             	sub    $0x8,%esp
  801371:	50                   	push   %eax
  801372:	56                   	push   %esi
  801373:	e8 0c 03 00 00       	call   801684 <strnlen>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80137e:	eb 16                	jmp    801396 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801380:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 0c             	pushl  0xc(%ebp)
  80138a:	50                   	push   %eax
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	ff d0                	call   *%eax
  801390:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801393:	ff 4d e4             	decl   -0x1c(%ebp)
  801396:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80139a:	7f e4                	jg     801380 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80139c:	eb 34                	jmp    8013d2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80139e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013a2:	74 1c                	je     8013c0 <vprintfmt+0x207>
  8013a4:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a7:	7e 05                	jle    8013ae <vprintfmt+0x1f5>
  8013a9:	83 fb 7e             	cmp    $0x7e,%ebx
  8013ac:	7e 12                	jle    8013c0 <vprintfmt+0x207>
					putch('?', putdat);
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	ff 75 0c             	pushl  0xc(%ebp)
  8013b4:	6a 3f                	push   $0x3f
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	ff d0                	call   *%eax
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	eb 0f                	jmp    8013cf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	ff 75 0c             	pushl  0xc(%ebp)
  8013c6:	53                   	push   %ebx
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	ff d0                	call   *%eax
  8013cc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cf:	ff 4d e4             	decl   -0x1c(%ebp)
  8013d2:	89 f0                	mov    %esi,%eax
  8013d4:	8d 70 01             	lea    0x1(%eax),%esi
  8013d7:	8a 00                	mov    (%eax),%al
  8013d9:	0f be d8             	movsbl %al,%ebx
  8013dc:	85 db                	test   %ebx,%ebx
  8013de:	74 24                	je     801404 <vprintfmt+0x24b>
  8013e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e4:	78 b8                	js     80139e <vprintfmt+0x1e5>
  8013e6:	ff 4d e0             	decl   -0x20(%ebp)
  8013e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ed:	79 af                	jns    80139e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ef:	eb 13                	jmp    801404 <vprintfmt+0x24b>
				putch(' ', putdat);
  8013f1:	83 ec 08             	sub    $0x8,%esp
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	6a 20                	push   $0x20
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	ff d0                	call   *%eax
  8013fe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801401:	ff 4d e4             	decl   -0x1c(%ebp)
  801404:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801408:	7f e7                	jg     8013f1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80140a:	e9 66 01 00 00       	jmp    801575 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	ff 75 e8             	pushl  -0x18(%ebp)
  801415:	8d 45 14             	lea    0x14(%ebp),%eax
  801418:	50                   	push   %eax
  801419:	e8 3c fd ff ff       	call   80115a <getint>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801424:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142d:	85 d2                	test   %edx,%edx
  80142f:	79 23                	jns    801454 <vprintfmt+0x29b>
				putch('-', putdat);
  801431:	83 ec 08             	sub    $0x8,%esp
  801434:	ff 75 0c             	pushl  0xc(%ebp)
  801437:	6a 2d                	push   $0x2d
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	ff d0                	call   *%eax
  80143e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801447:	f7 d8                	neg    %eax
  801449:	83 d2 00             	adc    $0x0,%edx
  80144c:	f7 da                	neg    %edx
  80144e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801451:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801454:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80145b:	e9 bc 00 00 00       	jmp    80151c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	ff 75 e8             	pushl  -0x18(%ebp)
  801466:	8d 45 14             	lea    0x14(%ebp),%eax
  801469:	50                   	push   %eax
  80146a:	e8 84 fc ff ff       	call   8010f3 <getuint>
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801475:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801478:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80147f:	e9 98 00 00 00       	jmp    80151c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801484:	83 ec 08             	sub    $0x8,%esp
  801487:	ff 75 0c             	pushl  0xc(%ebp)
  80148a:	6a 58                	push   $0x58
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	ff d0                	call   *%eax
  801491:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	6a 58                	push   $0x58
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	ff d0                	call   *%eax
  8014a1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	6a 58                	push   $0x58
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	ff d0                	call   *%eax
  8014b1:	83 c4 10             	add    $0x10,%esp
			break;
  8014b4:	e9 bc 00 00 00       	jmp    801575 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 30                	push   $0x30
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	6a 78                	push   $0x78
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	ff d0                	call   *%eax
  8014d6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dc:	83 c0 04             	add    $0x4,%eax
  8014df:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e5:	83 e8 04             	sub    $0x4,%eax
  8014e8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014f4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8014fb:	eb 1f                	jmp    80151c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014fd:	83 ec 08             	sub    $0x8,%esp
  801500:	ff 75 e8             	pushl  -0x18(%ebp)
  801503:	8d 45 14             	lea    0x14(%ebp),%eax
  801506:	50                   	push   %eax
  801507:	e8 e7 fb ff ff       	call   8010f3 <getuint>
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801515:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80151c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801520:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	52                   	push   %edx
  801527:	ff 75 e4             	pushl  -0x1c(%ebp)
  80152a:	50                   	push   %eax
  80152b:	ff 75 f4             	pushl  -0xc(%ebp)
  80152e:	ff 75 f0             	pushl  -0x10(%ebp)
  801531:	ff 75 0c             	pushl  0xc(%ebp)
  801534:	ff 75 08             	pushl  0x8(%ebp)
  801537:	e8 00 fb ff ff       	call   80103c <printnum>
  80153c:	83 c4 20             	add    $0x20,%esp
			break;
  80153f:	eb 34                	jmp    801575 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801541:	83 ec 08             	sub    $0x8,%esp
  801544:	ff 75 0c             	pushl  0xc(%ebp)
  801547:	53                   	push   %ebx
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	ff d0                	call   *%eax
  80154d:	83 c4 10             	add    $0x10,%esp
			break;
  801550:	eb 23                	jmp    801575 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801552:	83 ec 08             	sub    $0x8,%esp
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	6a 25                	push   $0x25
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	ff d0                	call   *%eax
  80155f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801562:	ff 4d 10             	decl   0x10(%ebp)
  801565:	eb 03                	jmp    80156a <vprintfmt+0x3b1>
  801567:	ff 4d 10             	decl   0x10(%ebp)
  80156a:	8b 45 10             	mov    0x10(%ebp),%eax
  80156d:	48                   	dec    %eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	3c 25                	cmp    $0x25,%al
  801572:	75 f3                	jne    801567 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801574:	90                   	nop
		}
	}
  801575:	e9 47 fc ff ff       	jmp    8011c1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80157a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80157b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157e:	5b                   	pop    %ebx
  80157f:	5e                   	pop    %esi
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    

00801582 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801588:	8d 45 10             	lea    0x10(%ebp),%eax
  80158b:	83 c0 04             	add    $0x4,%eax
  80158e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	ff 75 f4             	pushl  -0xc(%ebp)
  801597:	50                   	push   %eax
  801598:	ff 75 0c             	pushl  0xc(%ebp)
  80159b:	ff 75 08             	pushl  0x8(%ebp)
  80159e:	e8 16 fc ff ff       	call   8011b9 <vprintfmt>
  8015a3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015a6:	90                   	nop
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015af:	8b 40 08             	mov    0x8(%eax),%eax
  8015b2:	8d 50 01             	lea    0x1(%eax),%edx
  8015b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	8b 10                	mov    (%eax),%edx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	8b 40 04             	mov    0x4(%eax),%eax
  8015c6:	39 c2                	cmp    %eax,%edx
  8015c8:	73 12                	jae    8015dc <sprintputch+0x33>
		*b->buf++ = ch;
  8015ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cd:	8b 00                	mov    (%eax),%eax
  8015cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8015d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d5:	89 0a                	mov    %ecx,(%edx)
  8015d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8015da:	88 10                	mov    %dl,(%eax)
}
  8015dc:	90                   	nop
  8015dd:	5d                   	pop    %ebp
  8015de:	c3                   	ret    

008015df <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	01 d0                	add    %edx,%eax
  8015f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801600:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801604:	74 06                	je     80160c <vsnprintf+0x2d>
  801606:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80160a:	7f 07                	jg     801613 <vsnprintf+0x34>
		return -E_INVAL;
  80160c:	b8 03 00 00 00       	mov    $0x3,%eax
  801611:	eb 20                	jmp    801633 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801613:	ff 75 14             	pushl  0x14(%ebp)
  801616:	ff 75 10             	pushl  0x10(%ebp)
  801619:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80161c:	50                   	push   %eax
  80161d:	68 a9 15 80 00       	push   $0x8015a9
  801622:	e8 92 fb ff ff       	call   8011b9 <vprintfmt>
  801627:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80162a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801630:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80163b:	8d 45 10             	lea    0x10(%ebp),%eax
  80163e:	83 c0 04             	add    $0x4,%eax
  801641:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801644:	8b 45 10             	mov    0x10(%ebp),%eax
  801647:	ff 75 f4             	pushl  -0xc(%ebp)
  80164a:	50                   	push   %eax
  80164b:	ff 75 0c             	pushl  0xc(%ebp)
  80164e:	ff 75 08             	pushl  0x8(%ebp)
  801651:	e8 89 ff ff ff       	call   8015df <vsnprintf>
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801667:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166e:	eb 06                	jmp    801676 <strlen+0x15>
		n++;
  801670:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801673:	ff 45 08             	incl   0x8(%ebp)
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	84 c0                	test   %al,%al
  80167d:	75 f1                	jne    801670 <strlen+0xf>
		n++;
	return n;
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80168a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801691:	eb 09                	jmp    80169c <strnlen+0x18>
		n++;
  801693:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801696:	ff 45 08             	incl   0x8(%ebp)
  801699:	ff 4d 0c             	decl   0xc(%ebp)
  80169c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016a0:	74 09                	je     8016ab <strnlen+0x27>
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8a 00                	mov    (%eax),%al
  8016a7:	84 c0                	test   %al,%al
  8016a9:	75 e8                	jne    801693 <strnlen+0xf>
		n++;
	return n;
  8016ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016bc:	90                   	nop
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	8d 50 01             	lea    0x1(%eax),%edx
  8016c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cf:	8a 12                	mov    (%edx),%dl
  8016d1:	88 10                	mov    %dl,(%eax)
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	84 c0                	test   %al,%al
  8016d7:	75 e4                	jne    8016bd <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016f1:	eb 1f                	jmp    801712 <strncpy+0x34>
		*dst++ = *src;
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	8d 50 01             	lea    0x1(%eax),%edx
  8016f9:	89 55 08             	mov    %edx,0x8(%ebp)
  8016fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ff:	8a 12                	mov    (%edx),%dl
  801701:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801703:	8b 45 0c             	mov    0xc(%ebp),%eax
  801706:	8a 00                	mov    (%eax),%al
  801708:	84 c0                	test   %al,%al
  80170a:	74 03                	je     80170f <strncpy+0x31>
			src++;
  80170c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80170f:	ff 45 fc             	incl   -0x4(%ebp)
  801712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801715:	3b 45 10             	cmp    0x10(%ebp),%eax
  801718:	72 d9                	jb     8016f3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80171a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80172b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172f:	74 30                	je     801761 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801731:	eb 16                	jmp    801749 <strlcpy+0x2a>
			*dst++ = *src++;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8d 50 01             	lea    0x1(%eax),%edx
  801739:	89 55 08             	mov    %edx,0x8(%ebp)
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801742:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801745:	8a 12                	mov    (%edx),%dl
  801747:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801749:	ff 4d 10             	decl   0x10(%ebp)
  80174c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801750:	74 09                	je     80175b <strlcpy+0x3c>
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	75 d8                	jne    801733 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801761:	8b 55 08             	mov    0x8(%ebp),%edx
  801764:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801767:	29 c2                	sub    %eax,%edx
  801769:	89 d0                	mov    %edx,%eax
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801770:	eb 06                	jmp    801778 <strcmp+0xb>
		p++, q++;
  801772:	ff 45 08             	incl   0x8(%ebp)
  801775:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 0e                	je     80178f <strcmp+0x22>
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	8a 10                	mov    (%eax),%dl
  801786:	8b 45 0c             	mov    0xc(%ebp),%eax
  801789:	8a 00                	mov    (%eax),%al
  80178b:	38 c2                	cmp    %al,%dl
  80178d:	74 e3                	je     801772 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8a 00                	mov    (%eax),%al
  801794:	0f b6 d0             	movzbl %al,%edx
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	0f b6 c0             	movzbl %al,%eax
  80179f:	29 c2                	sub    %eax,%edx
  8017a1:	89 d0                	mov    %edx,%eax
}
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    

008017a5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017a8:	eb 09                	jmp    8017b3 <strncmp+0xe>
		n--, p++, q++;
  8017aa:	ff 4d 10             	decl   0x10(%ebp)
  8017ad:	ff 45 08             	incl   0x8(%ebp)
  8017b0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b7:	74 17                	je     8017d0 <strncmp+0x2b>
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8a 00                	mov    (%eax),%al
  8017be:	84 c0                	test   %al,%al
  8017c0:	74 0e                	je     8017d0 <strncmp+0x2b>
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	8a 10                	mov    (%eax),%dl
  8017c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ca:	8a 00                	mov    (%eax),%al
  8017cc:	38 c2                	cmp    %al,%dl
  8017ce:	74 da                	je     8017aa <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d4:	75 07                	jne    8017dd <strncmp+0x38>
		return 0;
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017db:	eb 14                	jmp    8017f1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8a 00                	mov    (%eax),%al
  8017e2:	0f b6 d0             	movzbl %al,%edx
  8017e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	0f b6 c0             	movzbl %al,%eax
  8017ed:	29 c2                	sub    %eax,%edx
  8017ef:	89 d0                	mov    %edx,%eax
}
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ff:	eb 12                	jmp    801813 <strchr+0x20>
		if (*s == c)
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	8a 00                	mov    (%eax),%al
  801806:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801809:	75 05                	jne    801810 <strchr+0x1d>
			return (char *) s;
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	eb 11                	jmp    801821 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801810:	ff 45 08             	incl   0x8(%ebp)
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	84 c0                	test   %al,%al
  80181a:	75 e5                	jne    801801 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80182f:	eb 0d                	jmp    80183e <strfind+0x1b>
		if (*s == c)
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	8a 00                	mov    (%eax),%al
  801836:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801839:	74 0e                	je     801849 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80183b:	ff 45 08             	incl   0x8(%ebp)
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	84 c0                	test   %al,%al
  801845:	75 ea                	jne    801831 <strfind+0xe>
  801847:	eb 01                	jmp    80184a <strfind+0x27>
		if (*s == c)
			break;
  801849:	90                   	nop
	return (char *) s;
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80185b:	8b 45 10             	mov    0x10(%ebp),%eax
  80185e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801861:	eb 0e                	jmp    801871 <memset+0x22>
		*p++ = c;
  801863:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801866:	8d 50 01             	lea    0x1(%eax),%edx
  801869:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801871:	ff 4d f8             	decl   -0x8(%ebp)
  801874:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801878:	79 e9                	jns    801863 <memset+0x14>
		*p++ = c;

	return v;
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801885:	8b 45 0c             	mov    0xc(%ebp),%eax
  801888:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801891:	eb 16                	jmp    8018a9 <memcpy+0x2a>
		*d++ = *s++;
  801893:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801896:	8d 50 01             	lea    0x1(%eax),%edx
  801899:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80189c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a5:	8a 12                	mov    (%edx),%dl
  8018a7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018af:	89 55 10             	mov    %edx,0x10(%ebp)
  8018b2:	85 c0                	test   %eax,%eax
  8018b4:	75 dd                	jne    801893 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018d3:	73 50                	jae    801925 <memmove+0x6a>
  8018d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	01 d0                	add    %edx,%eax
  8018dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018e0:	76 43                	jbe    801925 <memmove+0x6a>
		s += n;
  8018e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018eb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018ee:	eb 10                	jmp    801900 <memmove+0x45>
			*--d = *--s;
  8018f0:	ff 4d f8             	decl   -0x8(%ebp)
  8018f3:	ff 4d fc             	decl   -0x4(%ebp)
  8018f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f9:	8a 10                	mov    (%eax),%dl
  8018fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fe:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801900:	8b 45 10             	mov    0x10(%ebp),%eax
  801903:	8d 50 ff             	lea    -0x1(%eax),%edx
  801906:	89 55 10             	mov    %edx,0x10(%ebp)
  801909:	85 c0                	test   %eax,%eax
  80190b:	75 e3                	jne    8018f0 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80190d:	eb 23                	jmp    801932 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80190f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801912:	8d 50 01             	lea    0x1(%eax),%edx
  801915:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801918:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80191e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801921:	8a 12                	mov    (%edx),%dl
  801923:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801925:	8b 45 10             	mov    0x10(%ebp),%eax
  801928:	8d 50 ff             	lea    -0x1(%eax),%edx
  80192b:	89 55 10             	mov    %edx,0x10(%ebp)
  80192e:	85 c0                	test   %eax,%eax
  801930:	75 dd                	jne    80190f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801943:	8b 45 0c             	mov    0xc(%ebp),%eax
  801946:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801949:	eb 2a                	jmp    801975 <memcmp+0x3e>
		if (*s1 != *s2)
  80194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194e:	8a 10                	mov    (%eax),%dl
  801950:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	38 c2                	cmp    %al,%dl
  801957:	74 16                	je     80196f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801959:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	0f b6 d0             	movzbl %al,%edx
  801961:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801964:	8a 00                	mov    (%eax),%al
  801966:	0f b6 c0             	movzbl %al,%eax
  801969:	29 c2                	sub    %eax,%edx
  80196b:	89 d0                	mov    %edx,%eax
  80196d:	eb 18                	jmp    801987 <memcmp+0x50>
		s1++, s2++;
  80196f:	ff 45 fc             	incl   -0x4(%ebp)
  801972:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801975:	8b 45 10             	mov    0x10(%ebp),%eax
  801978:	8d 50 ff             	lea    -0x1(%eax),%edx
  80197b:	89 55 10             	mov    %edx,0x10(%ebp)
  80197e:	85 c0                	test   %eax,%eax
  801980:	75 c9                	jne    80194b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801982:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80198f:	8b 55 08             	mov    0x8(%ebp),%edx
  801992:	8b 45 10             	mov    0x10(%ebp),%eax
  801995:	01 d0                	add    %edx,%eax
  801997:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80199a:	eb 15                	jmp    8019b1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	0f b6 d0             	movzbl %al,%edx
  8019a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a7:	0f b6 c0             	movzbl %al,%eax
  8019aa:	39 c2                	cmp    %eax,%edx
  8019ac:	74 0d                	je     8019bb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019ae:	ff 45 08             	incl   0x8(%ebp)
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019b7:	72 e3                	jb     80199c <memfind+0x13>
  8019b9:	eb 01                	jmp    8019bc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019bb:	90                   	nop
	return (void *) s;
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d5:	eb 03                	jmp    8019da <strtol+0x19>
		s++;
  8019d7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8a 00                	mov    (%eax),%al
  8019df:	3c 20                	cmp    $0x20,%al
  8019e1:	74 f4                	je     8019d7 <strtol+0x16>
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	3c 09                	cmp    $0x9,%al
  8019ea:	74 eb                	je     8019d7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8a 00                	mov    (%eax),%al
  8019f1:	3c 2b                	cmp    $0x2b,%al
  8019f3:	75 05                	jne    8019fa <strtol+0x39>
		s++;
  8019f5:	ff 45 08             	incl   0x8(%ebp)
  8019f8:	eb 13                	jmp    801a0d <strtol+0x4c>
	else if (*s == '-')
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	8a 00                	mov    (%eax),%al
  8019ff:	3c 2d                	cmp    $0x2d,%al
  801a01:	75 0a                	jne    801a0d <strtol+0x4c>
		s++, neg = 1;
  801a03:	ff 45 08             	incl   0x8(%ebp)
  801a06:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a11:	74 06                	je     801a19 <strtol+0x58>
  801a13:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a17:	75 20                	jne    801a39 <strtol+0x78>
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	8a 00                	mov    (%eax),%al
  801a1e:	3c 30                	cmp    $0x30,%al
  801a20:	75 17                	jne    801a39 <strtol+0x78>
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	40                   	inc    %eax
  801a26:	8a 00                	mov    (%eax),%al
  801a28:	3c 78                	cmp    $0x78,%al
  801a2a:	75 0d                	jne    801a39 <strtol+0x78>
		s += 2, base = 16;
  801a2c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a30:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a37:	eb 28                	jmp    801a61 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3d:	75 15                	jne    801a54 <strtol+0x93>
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	8a 00                	mov    (%eax),%al
  801a44:	3c 30                	cmp    $0x30,%al
  801a46:	75 0c                	jne    801a54 <strtol+0x93>
		s++, base = 8;
  801a48:	ff 45 08             	incl   0x8(%ebp)
  801a4b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a52:	eb 0d                	jmp    801a61 <strtol+0xa0>
	else if (base == 0)
  801a54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a58:	75 07                	jne    801a61 <strtol+0xa0>
		base = 10;
  801a5a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	8a 00                	mov    (%eax),%al
  801a66:	3c 2f                	cmp    $0x2f,%al
  801a68:	7e 19                	jle    801a83 <strtol+0xc2>
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	8a 00                	mov    (%eax),%al
  801a6f:	3c 39                	cmp    $0x39,%al
  801a71:	7f 10                	jg     801a83 <strtol+0xc2>
			dig = *s - '0';
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	8a 00                	mov    (%eax),%al
  801a78:	0f be c0             	movsbl %al,%eax
  801a7b:	83 e8 30             	sub    $0x30,%eax
  801a7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a81:	eb 42                	jmp    801ac5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	8a 00                	mov    (%eax),%al
  801a88:	3c 60                	cmp    $0x60,%al
  801a8a:	7e 19                	jle    801aa5 <strtol+0xe4>
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	8a 00                	mov    (%eax),%al
  801a91:	3c 7a                	cmp    $0x7a,%al
  801a93:	7f 10                	jg     801aa5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	8a 00                	mov    (%eax),%al
  801a9a:	0f be c0             	movsbl %al,%eax
  801a9d:	83 e8 57             	sub    $0x57,%eax
  801aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa3:	eb 20                	jmp    801ac5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	3c 40                	cmp    $0x40,%al
  801aac:	7e 39                	jle    801ae7 <strtol+0x126>
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	3c 5a                	cmp    $0x5a,%al
  801ab5:	7f 30                	jg     801ae7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	0f be c0             	movsbl %al,%eax
  801abf:	83 e8 37             	sub    $0x37,%eax
  801ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac8:	3b 45 10             	cmp    0x10(%ebp),%eax
  801acb:	7d 19                	jge    801ae6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801acd:	ff 45 08             	incl   0x8(%ebp)
  801ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad3:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ad7:	89 c2                	mov    %eax,%edx
  801ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adc:	01 d0                	add    %edx,%eax
  801ade:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ae1:	e9 7b ff ff ff       	jmp    801a61 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ae6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ae7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801aeb:	74 08                	je     801af5 <strtol+0x134>
		*endptr = (char *) s;
  801aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af0:	8b 55 08             	mov    0x8(%ebp),%edx
  801af3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801af5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801af9:	74 07                	je     801b02 <strtol+0x141>
  801afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afe:	f7 d8                	neg    %eax
  801b00:	eb 03                	jmp    801b05 <strtol+0x144>
  801b02:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <ltostr>:

void
ltostr(long value, char *str)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1f:	79 13                	jns    801b34 <ltostr+0x2d>
	{
		neg = 1;
  801b21:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b2e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b31:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b3c:	99                   	cltd   
  801b3d:	f7 f9                	idiv   %ecx
  801b3f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b45:	8d 50 01             	lea    0x1(%eax),%edx
  801b48:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b4b:	89 c2                	mov    %eax,%edx
  801b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b50:	01 d0                	add    %edx,%eax
  801b52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b55:	83 c2 30             	add    $0x30,%edx
  801b58:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b62:	f7 e9                	imul   %ecx
  801b64:	c1 fa 02             	sar    $0x2,%edx
  801b67:	89 c8                	mov    %ecx,%eax
  801b69:	c1 f8 1f             	sar    $0x1f,%eax
  801b6c:	29 c2                	sub    %eax,%edx
  801b6e:	89 d0                	mov    %edx,%eax
  801b70:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b7b:	f7 e9                	imul   %ecx
  801b7d:	c1 fa 02             	sar    $0x2,%edx
  801b80:	89 c8                	mov    %ecx,%eax
  801b82:	c1 f8 1f             	sar    $0x1f,%eax
  801b85:	29 c2                	sub    %eax,%edx
  801b87:	89 d0                	mov    %edx,%eax
  801b89:	c1 e0 02             	shl    $0x2,%eax
  801b8c:	01 d0                	add    %edx,%eax
  801b8e:	01 c0                	add    %eax,%eax
  801b90:	29 c1                	sub    %eax,%ecx
  801b92:	89 ca                	mov    %ecx,%edx
  801b94:	85 d2                	test   %edx,%edx
  801b96:	75 9c                	jne    801b34 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba2:	48                   	dec    %eax
  801ba3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ba6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801baa:	74 3d                	je     801be9 <ltostr+0xe2>
		start = 1 ;
  801bac:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bb3:	eb 34                	jmp    801be9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbb:	01 d0                	add    %edx,%eax
  801bbd:	8a 00                	mov    (%eax),%al
  801bbf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc8:	01 c2                	add    %eax,%edx
  801bca:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd0:	01 c8                	add    %ecx,%eax
  801bd2:	8a 00                	mov    (%eax),%al
  801bd4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdc:	01 c2                	add    %eax,%edx
  801bde:	8a 45 eb             	mov    -0x15(%ebp),%al
  801be1:	88 02                	mov    %al,(%edx)
		start++ ;
  801be3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801be6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bef:	7c c4                	jl     801bb5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bf1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf7:	01 d0                	add    %edx,%eax
  801bf9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bfc:	90                   	nop
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c05:	ff 75 08             	pushl  0x8(%ebp)
  801c08:	e8 54 fa ff ff       	call   801661 <strlen>
  801c0d:	83 c4 04             	add    $0x4,%esp
  801c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	e8 46 fa ff ff       	call   801661 <strlen>
  801c1b:	83 c4 04             	add    $0x4,%esp
  801c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c2f:	eb 17                	jmp    801c48 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c31:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c34:	8b 45 10             	mov    0x10(%ebp),%eax
  801c37:	01 c2                	add    %eax,%edx
  801c39:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	01 c8                	add    %ecx,%eax
  801c41:	8a 00                	mov    (%eax),%al
  801c43:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c45:	ff 45 fc             	incl   -0x4(%ebp)
  801c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c4b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c4e:	7c e1                	jl     801c31 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c50:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c57:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c5e:	eb 1f                	jmp    801c7f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c63:	8d 50 01             	lea    0x1(%eax),%edx
  801c66:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c69:	89 c2                	mov    %eax,%edx
  801c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6e:	01 c2                	add    %eax,%edx
  801c70:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c76:	01 c8                	add    %ecx,%eax
  801c78:	8a 00                	mov    (%eax),%al
  801c7a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c7c:	ff 45 f8             	incl   -0x8(%ebp)
  801c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c82:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c85:	7c d9                	jl     801c60 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c87:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8d:	01 d0                	add    %edx,%eax
  801c8f:	c6 00 00             	movb   $0x0,(%eax)
}
  801c92:	90                   	nop
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c98:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ca1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca4:	8b 00                	mov    (%eax),%eax
  801ca6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cad:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb0:	01 d0                	add    %edx,%eax
  801cb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cb8:	eb 0c                	jmp    801cc6 <strsplit+0x31>
			*string++ = 0;
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	8d 50 01             	lea    0x1(%eax),%edx
  801cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	8a 00                	mov    (%eax),%al
  801ccb:	84 c0                	test   %al,%al
  801ccd:	74 18                	je     801ce7 <strsplit+0x52>
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	8a 00                	mov    (%eax),%al
  801cd4:	0f be c0             	movsbl %al,%eax
  801cd7:	50                   	push   %eax
  801cd8:	ff 75 0c             	pushl  0xc(%ebp)
  801cdb:	e8 13 fb ff ff       	call   8017f3 <strchr>
  801ce0:	83 c4 08             	add    $0x8,%esp
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	75 d3                	jne    801cba <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	8a 00                	mov    (%eax),%al
  801cec:	84 c0                	test   %al,%al
  801cee:	74 5a                	je     801d4a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  801cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf3:	8b 00                	mov    (%eax),%eax
  801cf5:	83 f8 0f             	cmp    $0xf,%eax
  801cf8:	75 07                	jne    801d01 <strsplit+0x6c>
		{
			return 0;
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801cff:	eb 66                	jmp    801d67 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801d01:	8b 45 14             	mov    0x14(%ebp),%eax
  801d04:	8b 00                	mov    (%eax),%eax
  801d06:	8d 48 01             	lea    0x1(%eax),%ecx
  801d09:	8b 55 14             	mov    0x14(%ebp),%edx
  801d0c:	89 0a                	mov    %ecx,(%edx)
  801d0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d15:	8b 45 10             	mov    0x10(%ebp),%eax
  801d18:	01 c2                	add    %eax,%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d1f:	eb 03                	jmp    801d24 <strsplit+0x8f>
			string++;
  801d21:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	8a 00                	mov    (%eax),%al
  801d29:	84 c0                	test   %al,%al
  801d2b:	74 8b                	je     801cb8 <strsplit+0x23>
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	8a 00                	mov    (%eax),%al
  801d32:	0f be c0             	movsbl %al,%eax
  801d35:	50                   	push   %eax
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	e8 b5 fa ff ff       	call   8017f3 <strchr>
  801d3e:	83 c4 08             	add    $0x8,%esp
  801d41:	85 c0                	test   %eax,%eax
  801d43:	74 dc                	je     801d21 <strsplit+0x8c>
			string++;
	}
  801d45:	e9 6e ff ff ff       	jmp    801cb8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d4a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4e:	8b 00                	mov    (%eax),%eax
  801d50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d57:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5a:	01 d0                	add    %edx,%eax
  801d5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801d72:	e8 7d 0f 00 00       	call   802cf4 <sys_isUHeapPlacementStrategyNEXTFIT>
  801d77:	85 c0                	test   %eax,%eax
  801d79:	0f 84 6f 03 00 00    	je     8020ee <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801d7f:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801d86:	8b 55 08             	mov    0x8(%ebp),%edx
  801d89:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801d8c:	01 d0                	add    %edx,%eax
  801d8e:	48                   	dec    %eax
  801d8f:	89 45 80             	mov    %eax,-0x80(%ebp)
  801d92:	8b 45 80             	mov    -0x80(%ebp),%eax
  801d95:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9a:	f7 75 84             	divl   -0x7c(%ebp)
  801d9d:	8b 45 80             	mov    -0x80(%ebp),%eax
  801da0:	29 d0                	sub    %edx,%eax
  801da2:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801da5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801da9:	74 09                	je     801db4 <malloc+0x4b>
  801dab:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801db2:	76 0a                	jbe    801dbe <malloc+0x55>
			return NULL;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
  801db9:	e9 4b 09 00 00       	jmp    802709 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801dbe:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	01 d0                	add    %edx,%eax
  801dc9:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801dce:	0f 87 a2 00 00 00    	ja     801e76 <malloc+0x10d>
  801dd4:	a1 40 40 98 00       	mov    0x984040,%eax
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	0f 85 95 00 00 00    	jne    801e76 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801de1:	a1 04 40 80 00       	mov    0x804004,%eax
  801de6:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801dec:	a1 04 40 80 00       	mov    0x804004,%eax
  801df1:	83 ec 08             	sub    $0x8,%esp
  801df4:	ff 75 08             	pushl  0x8(%ebp)
  801df7:	50                   	push   %eax
  801df8:	e8 a3 0b 00 00       	call   8029a0 <sys_allocateMem>
  801dfd:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801e00:	a1 20 40 80 00       	mov    0x804020,%eax
  801e05:	8b 55 08             	mov    0x8(%ebp),%edx
  801e08:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801e0f:	a1 20 40 80 00       	mov    0x804020,%eax
  801e14:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e1a:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  801e21:	a1 20 40 80 00       	mov    0x804020,%eax
  801e26:	40                   	inc    %eax
  801e27:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  801e2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801e33:	eb 2e                	jmp    801e63 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801e35:	a1 04 40 80 00       	mov    0x804004,%eax
  801e3a:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801e3f:	c1 e8 0c             	shr    $0xc,%eax
  801e42:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801e49:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801e4d:	a1 04 40 80 00       	mov    0x804004,%eax
  801e52:	05 00 10 00 00       	add    $0x1000,%eax
  801e57:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801e5c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e66:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e69:	72 ca                	jb     801e35 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801e6b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801e71:	e9 93 08 00 00       	jmp    802709 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801e76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801e7d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801e84:	a1 40 40 98 00       	mov    0x984040,%eax
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	75 1d                	jne    801eaa <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801e8d:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801e94:	00 00 80 
				check = 1;
  801e97:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  801e9e:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801ea1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801ea8:	eb 08                	jmp    801eb2 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801eaa:	a1 04 40 80 00       	mov    0x804004,%eax
  801eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801eb2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801eb9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801ec0:	a1 04 40 80 00       	mov    0x804004,%eax
  801ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801ec8:	eb 4d                	jmp    801f17 <malloc+0x1ae>
				if (sz == size) {
  801eca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ecd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ed0:	75 09                	jne    801edb <malloc+0x172>
					f = 1;
  801ed2:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801ed9:	eb 45                	jmp    801f20 <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801edb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ede:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801ee3:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801ee6:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801eed:	85 c0                	test   %eax,%eax
  801eef:	75 10                	jne    801f01 <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801ef1:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801ef8:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801eff:	eb 16                	jmp    801f17 <malloc+0x1ae>
				} else {
					sz = 0;
  801f01:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801f08:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801f0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f12:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801f17:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801f1e:	76 aa                	jbe    801eca <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801f20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f24:	0f 84 95 00 00 00    	je     801fbf <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801f2a:	a1 04 40 80 00       	mov    0x804004,%eax
  801f2f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801f35:	a1 04 40 80 00       	mov    0x804004,%eax
  801f3a:	83 ec 08             	sub    $0x8,%esp
  801f3d:	ff 75 08             	pushl  0x8(%ebp)
  801f40:	50                   	push   %eax
  801f41:	e8 5a 0a 00 00       	call   8029a0 <sys_allocateMem>
  801f46:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801f49:	a1 20 40 80 00       	mov    0x804020,%eax
  801f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f51:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801f58:	a1 20 40 80 00       	mov    0x804020,%eax
  801f5d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f63:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  801f6a:	a1 20 40 80 00       	mov    0x804020,%eax
  801f6f:	40                   	inc    %eax
  801f70:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  801f75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801f7c:	eb 2e                	jmp    801fac <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801f7e:	a1 04 40 80 00       	mov    0x804004,%eax
  801f83:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801f88:	c1 e8 0c             	shr    $0xc,%eax
  801f8b:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801f92:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801f96:	a1 04 40 80 00       	mov    0x804004,%eax
  801f9b:	05 00 10 00 00       	add    $0x1000,%eax
  801fa0:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801fa5:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801fac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801faf:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fb2:	72 ca                	jb     801f7e <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801fb4:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801fba:	e9 4a 07 00 00       	jmp    802709 <malloc+0x9a0>

			} else {

				if (check_start) {
  801fbf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fc3:	74 0a                	je     801fcf <malloc+0x266>

					return NULL;
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fca:	e9 3a 07 00 00       	jmp    802709 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801fcf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801fd6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801fdd:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801fe4:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801feb:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801fee:	eb 4d                	jmp    80203d <malloc+0x2d4>
					if (sz == size) {
  801ff0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ff3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ff6:	75 09                	jne    802001 <malloc+0x298>
						f = 1;
  801ff8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801fff:	eb 44                	jmp    802045 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  802001:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802004:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  802009:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  80200c:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802013:	85 c0                	test   %eax,%eax
  802015:	75 10                	jne    802027 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  802017:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  80201e:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  802025:	eb 16                	jmp    80203d <malloc+0x2d4>
					} else {
						sz = 0;
  802027:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  80202e:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  802035:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802038:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  80203d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802040:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  802043:	72 ab                	jb     801ff0 <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  802045:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802049:	0f 84 95 00 00 00    	je     8020e4 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  80204f:	a1 04 40 80 00       	mov    0x804004,%eax
  802054:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  80205a:	a1 04 40 80 00       	mov    0x804004,%eax
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	ff 75 08             	pushl  0x8(%ebp)
  802065:	50                   	push   %eax
  802066:	e8 35 09 00 00       	call   8029a0 <sys_allocateMem>
  80206b:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  80206e:	a1 20 40 80 00       	mov    0x804020,%eax
  802073:	8b 55 08             	mov    0x8(%ebp),%edx
  802076:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  80207d:	a1 20 40 80 00       	mov    0x804020,%eax
  802082:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802088:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  80208f:	a1 20 40 80 00       	mov    0x804020,%eax
  802094:	40                   	inc    %eax
  802095:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  80209a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  8020a1:	eb 2e                	jmp    8020d1 <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8020a3:	a1 04 40 80 00       	mov    0x804004,%eax
  8020a8:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  8020ad:	c1 e8 0c             	shr    $0xc,%eax
  8020b0:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8020b7:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  8020bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8020c0:	05 00 10 00 00       	add    $0x1000,%eax
  8020c5:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  8020ca:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  8020d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020d7:	72 ca                	jb     8020a3 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  8020d9:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8020df:	e9 25 06 00 00       	jmp    802709 <malloc+0x9a0>

				} else {

					return NULL;
  8020e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e9:	e9 1b 06 00 00       	jmp    802709 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  8020ee:	e8 d0 0b 00 00       	call   802cc3 <sys_isUHeapPlacementStrategyBESTFIT>
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	0f 84 ba 01 00 00    	je     8022b5 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  8020fb:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  802102:	10 00 00 
  802105:	8b 55 08             	mov    0x8(%ebp),%edx
  802108:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80210e:	01 d0                	add    %edx,%eax
  802110:	48                   	dec    %eax
  802111:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  802117:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80211d:	ba 00 00 00 00       	mov    $0x0,%edx
  802122:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  802128:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80212e:	29 d0                	sub    %edx,%eax
  802130:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802133:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802137:	74 09                	je     802142 <malloc+0x3d9>
  802139:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802140:	76 0a                	jbe    80214c <malloc+0x3e3>
			return NULL;
  802142:	b8 00 00 00 00       	mov    $0x0,%eax
  802147:	e9 bd 05 00 00       	jmp    802709 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  80214c:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  802153:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  80215a:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  802161:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  802168:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	c1 e8 0c             	shr    $0xc,%eax
  802175:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  80217b:	e9 80 00 00 00       	jmp    802200 <malloc+0x497>

			if (heap_mem[i] == 0) {
  802180:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802183:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	75 0c                	jne    80219a <malloc+0x431>

				count++;
  80218e:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  802191:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  802198:	eb 2d                	jmp    8021c7 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  80219a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8021a0:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8021a3:	77 14                	ja     8021b9 <malloc+0x450>
  8021a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021a8:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8021ab:	76 0c                	jbe    8021b9 <malloc+0x450>

					min_sz = count;
  8021ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  8021b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8021b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  8021b9:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  8021c0:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  8021c7:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  8021ce:	75 2d                	jne    8021fd <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  8021d0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8021d6:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8021d9:	77 22                	ja     8021fd <malloc+0x494>
  8021db:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021de:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8021e1:	76 1a                	jbe    8021fd <malloc+0x494>

					min_sz = count;
  8021e3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021e6:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  8021e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8021ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  8021ef:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  8021f6:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  8021fd:	ff 45 b8             	incl   -0x48(%ebp)
  802200:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802203:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802208:	0f 86 72 ff ff ff    	jbe    802180 <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  80220e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  802214:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  802217:	77 06                	ja     80221f <malloc+0x4b6>
  802219:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80221d:	75 0a                	jne    802229 <malloc+0x4c0>
			return NULL;
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
  802224:	e9 e0 04 00 00       	jmp    802709 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  802229:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80222c:	c1 e0 0c             	shl    $0xc,%eax
  80222f:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  802232:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802235:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  80223b:	83 ec 08             	sub    $0x8,%esp
  80223e:	ff 75 08             	pushl  0x8(%ebp)
  802241:	ff 75 c4             	pushl  -0x3c(%ebp)
  802244:	e8 57 07 00 00       	call   8029a0 <sys_allocateMem>
  802249:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80224c:	a1 20 40 80 00       	mov    0x804020,%eax
  802251:	8b 55 08             	mov    0x8(%ebp),%edx
  802254:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  80225b:	a1 20 40 80 00       	mov    0x804020,%eax
  802260:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802263:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  80226a:	a1 20 40 80 00       	mov    0x804020,%eax
  80226f:	40                   	inc    %eax
  802270:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  802275:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  80227c:	eb 24                	jmp    8022a2 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  80227e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802281:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802286:	c1 e8 0c             	shr    $0xc,%eax
  802289:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802290:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802294:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  80229b:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  8022a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022a8:	72 d4                	jb     80227e <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8022aa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8022b0:	e9 54 04 00 00       	jmp    802709 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8022b5:	e8 d8 09 00 00       	call   802c92 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	0f 84 88 01 00 00    	je     80244a <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  8022c2:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  8022c9:	10 00 00 
  8022cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cf:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8022d5:	01 d0                	add    %edx,%eax
  8022d7:	48                   	dec    %eax
  8022d8:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  8022de:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8022e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e9:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  8022ef:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8022f5:	29 d0                	sub    %edx,%eax
  8022f7:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8022fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022fe:	74 09                	je     802309 <malloc+0x5a0>
  802300:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802307:	76 0a                	jbe    802313 <malloc+0x5aa>
			return NULL;
  802309:	b8 00 00 00 00       	mov    $0x0,%eax
  80230e:	e9 f6 03 00 00       	jmp    802709 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  802313:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  80231a:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  802321:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  802328:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  80232f:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	c1 e8 0c             	shr    $0xc,%eax
  80233c:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  802342:	eb 5a                	jmp    80239e <malloc+0x635>

			if (heap_mem[i] == 0) {
  802344:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802347:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  80234e:	85 c0                	test   %eax,%eax
  802350:	75 0c                	jne    80235e <malloc+0x5f5>

				count++;
  802352:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  802355:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  80235c:	eb 22                	jmp    802380 <malloc+0x617>
			} else {
				if (num_p <= count) {
  80235e:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802364:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  802367:	77 09                	ja     802372 <malloc+0x609>

					found = 1;
  802369:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  802370:	eb 36                	jmp    8023a8 <malloc+0x63f>
				}
				count = 0;
  802372:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  802379:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  802380:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  802387:	75 12                	jne    80239b <malloc+0x632>

				if (num_p <= count) {
  802389:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80238f:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  802392:	77 07                	ja     80239b <malloc+0x632>

					found = 1;
  802394:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  80239b:	ff 45 a4             	incl   -0x5c(%ebp)
  80239e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8023a1:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8023a6:	76 9c                	jbe    802344 <malloc+0x5db>

			}

		}

		if (!found) {
  8023a8:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  8023ac:	75 0a                	jne    8023b8 <malloc+0x64f>
			return NULL;
  8023ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b3:	e9 51 03 00 00       	jmp    802709 <malloc+0x9a0>

		}

		temp = ptr;
  8023b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8023bb:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  8023be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8023c1:	c1 e0 0c             	shl    $0xc,%eax
  8023c4:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  8023c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ca:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  8023d0:	83 ec 08             	sub    $0x8,%esp
  8023d3:	ff 75 08             	pushl  0x8(%ebp)
  8023d6:	ff 75 b0             	pushl  -0x50(%ebp)
  8023d9:	e8 c2 05 00 00       	call   8029a0 <sys_allocateMem>
  8023de:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  8023e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8023e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e9:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  8023f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8023f5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023f8:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8023ff:	a1 20 40 80 00       	mov    0x804020,%eax
  802404:	40                   	inc    %eax
  802405:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  80240a:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802411:	eb 24                	jmp    802437 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802413:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802416:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  80241b:	c1 e8 0c             	shr    $0xc,%eax
  80241e:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802425:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  802429:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  802430:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  802437:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80243a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243d:	72 d4                	jb     802413 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  80243f:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  802445:	e9 bf 02 00 00       	jmp    802709 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  80244a:	e8 d6 08 00 00       	call   802d25 <sys_isUHeapPlacementStrategyWORSTFIT>
  80244f:	85 c0                	test   %eax,%eax
  802451:	0f 84 ba 01 00 00    	je     802611 <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  802457:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  80245e:	10 00 00 
  802461:	8b 55 08             	mov    0x8(%ebp),%edx
  802464:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80246a:	01 d0                	add    %edx,%eax
  80246c:	48                   	dec    %eax
  80246d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802473:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802479:	ba 00 00 00 00       	mov    $0x0,%edx
  80247e:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802484:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80248a:	29 d0                	sub    %edx,%eax
  80248c:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80248f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802493:	74 09                	je     80249e <malloc+0x735>
  802495:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80249c:	76 0a                	jbe    8024a8 <malloc+0x73f>
					return NULL;
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a3:	e9 61 02 00 00       	jmp    802709 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  8024a8:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  8024af:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  8024b6:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  8024bd:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  8024c4:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	c1 e8 0c             	shr    $0xc,%eax
  8024d1:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8024d7:	e9 80 00 00 00       	jmp    80255c <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  8024dc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8024df:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	75 0c                	jne    8024f6 <malloc+0x78d>

						count++;
  8024ea:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  8024ed:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  8024f4:	eb 2d                	jmp    802523 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  8024f6:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8024fc:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8024ff:	77 14                	ja     802515 <malloc+0x7ac>
  802501:	8b 45 98             	mov    -0x68(%ebp),%eax
  802504:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802507:	73 0c                	jae    802515 <malloc+0x7ac>

							max_sz = count;
  802509:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80250c:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  80250f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802512:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  802515:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  80251c:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  802523:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  80252a:	75 2d                	jne    802559 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  80252c:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802532:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802535:	77 22                	ja     802559 <malloc+0x7f0>
  802537:	8b 45 98             	mov    -0x68(%ebp),%eax
  80253a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80253d:	76 1a                	jbe    802559 <malloc+0x7f0>

							max_sz = count;
  80253f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802542:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  802545:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802548:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  80254b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  802552:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802559:	ff 45 90             	incl   -0x70(%ebp)
  80255c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80255f:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802564:	0f 86 72 ff ff ff    	jbe    8024dc <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  80256a:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  802570:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802573:	77 06                	ja     80257b <malloc+0x812>
  802575:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802579:	75 0a                	jne    802585 <malloc+0x81c>
					return NULL;
  80257b:	b8 00 00 00 00       	mov    $0x0,%eax
  802580:	e9 84 01 00 00       	jmp    802709 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802585:	8b 45 98             	mov    -0x68(%ebp),%eax
  802588:	c1 e0 0c             	shl    $0xc,%eax
  80258b:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  80258e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802591:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  802597:	83 ec 08             	sub    $0x8,%esp
  80259a:	ff 75 08             	pushl  0x8(%ebp)
  80259d:	ff 75 9c             	pushl  -0x64(%ebp)
  8025a0:	e8 fb 03 00 00       	call   8029a0 <sys_allocateMem>
  8025a5:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  8025a8:	a1 20 40 80 00       	mov    0x804020,%eax
  8025ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b0:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  8025b7:	a1 20 40 80 00       	mov    0x804020,%eax
  8025bc:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8025bf:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  8025c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8025cb:	40                   	inc    %eax
  8025cc:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  8025d1:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8025d8:	eb 24                	jmp    8025fe <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8025da:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8025dd:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  8025e2:	c1 e8 0c             	shr    $0xc,%eax
  8025e5:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8025ec:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  8025f0:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  8025f7:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  8025fe:	8b 45 90             	mov    -0x70(%ebp),%eax
  802601:	3b 45 08             	cmp    0x8(%ebp),%eax
  802604:	72 d4                	jb     8025da <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  802606:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80260c:	e9 f8 00 00 00       	jmp    802709 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  802611:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  802618:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  80261f:	10 00 00 
  802622:	8b 55 08             	mov    0x8(%ebp),%edx
  802625:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80262b:	01 d0                	add    %edx,%eax
  80262d:	48                   	dec    %eax
  80262e:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  802634:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80263a:	ba 00 00 00 00       	mov    $0x0,%edx
  80263f:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  802645:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80264b:	29 d0                	sub    %edx,%eax
  80264d:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  802650:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802654:	74 09                	je     80265f <malloc+0x8f6>
  802656:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80265d:	76 0a                	jbe    802669 <malloc+0x900>
		return NULL;
  80265f:	b8 00 00 00 00       	mov    $0x0,%eax
  802664:	e9 a0 00 00 00       	jmp    802709 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  802669:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	01 d0                	add    %edx,%eax
  802674:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802679:	0f 87 87 00 00 00    	ja     802706 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80267f:	a1 04 40 80 00       	mov    0x804004,%eax
  802684:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802687:	a1 04 40 80 00       	mov    0x804004,%eax
  80268c:	83 ec 08             	sub    $0x8,%esp
  80268f:	ff 75 08             	pushl  0x8(%ebp)
  802692:	50                   	push   %eax
  802693:	e8 08 03 00 00       	call   8029a0 <sys_allocateMem>
  802698:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80269b:	a1 20 40 80 00       	mov    0x804020,%eax
  8026a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a3:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  8026aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8026af:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8026b5:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  8026bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8026c1:	40                   	inc    %eax
  8026c2:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  8026c7:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  8026ce:	eb 2e                	jmp    8026fe <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  8026d0:	a1 04 40 80 00       	mov    0x804004,%eax
  8026d5:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8026da:	c1 e8 0c             	shr    $0xc,%eax
  8026dd:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8026e4:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  8026e8:	a1 04 40 80 00       	mov    0x804004,%eax
  8026ed:	05 00 10 00 00       	add    $0x1000,%eax
  8026f2:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  8026f7:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  8026fe:	8b 45 88             	mov    -0x78(%ebp),%eax
  802701:	3b 45 08             	cmp    0x8(%ebp),%eax
  802704:	72 ca                	jb     8026d0 <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  802706:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
  80270e:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  802711:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  802718:	e9 c1 00 00 00       	jmp    8027de <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  802727:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272a:	0f 85 ab 00 00 00    	jne    8027db <free+0xd0>

			if (heap_size[inx].size == 0) {
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  80273a:	85 c0                	test   %eax,%eax
  80273c:	75 21                	jne    80275f <free+0x54>
				heap_size[inx].size = 0;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802748:	00 00 00 00 
				heap_size[inx].vir = NULL;
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802756:	00 00 00 00 
				return;
  80275a:	e9 8d 00 00 00       	jmp    8027ec <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	83 ec 08             	sub    $0x8,%esp
  80276f:	52                   	push   %edx
  802770:	50                   	push   %eax
  802771:	e8 0e 02 00 00       	call   802984 <sys_freeMem>
  802776:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802779:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802786:	eb 24                	jmp    8027ac <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278b:	05 00 00 00 80       	add    $0x80000000,%eax
  802790:	c1 e8 0c             	shr    $0xc,%eax
  802793:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  80279a:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  80279e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  8027a5:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  8027b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b9:	39 c2                	cmp    %eax,%edx
  8027bb:	77 cb                	ja     802788 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  8027c7:	00 00 00 00 
			heap_size[inx].vir = NULL;
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  8027d5:	00 00 00 00 
			break;
  8027d9:	eb 11                	jmp    8027ec <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  8027db:	ff 45 f4             	incl   -0xc(%ebp)
  8027de:	a1 20 40 80 00       	mov    0x804020,%eax
  8027e3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8027e6:	0f 8c 31 ff ff ff    	jl     80271d <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
  8027f1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8027f4:	83 ec 04             	sub    $0x4,%esp
  8027f7:	68 50 35 80 00       	push   $0x803550
  8027fc:	68 1c 02 00 00       	push   $0x21c
  802801:	68 76 35 80 00       	push   $0x803576
  802806:	e8 b0 e6 ff ff       	call   800ebb <_panic>

0080280b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80280b:	55                   	push   %ebp
  80280c:	89 e5                	mov    %esp,%ebp
  80280e:	57                   	push   %edi
  80280f:	56                   	push   %esi
  802810:	53                   	push   %ebx
  802811:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80281d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802820:	8b 7d 18             	mov    0x18(%ebp),%edi
  802823:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802826:	cd 30                	int    $0x30
  802828:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80282b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80282e:	83 c4 10             	add    $0x10,%esp
  802831:	5b                   	pop    %ebx
  802832:	5e                   	pop    %esi
  802833:	5f                   	pop    %edi
  802834:	5d                   	pop    %ebp
  802835:	c3                   	ret    

00802836 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	ff 75 0c             	pushl  0xc(%ebp)
  802845:	50                   	push   %eax
  802846:	6a 00                	push   $0x0
  802848:	e8 be ff ff ff       	call   80280b <syscall>
  80284d:	83 c4 18             	add    $0x18,%esp
}
  802850:	90                   	nop
  802851:	c9                   	leave  
  802852:	c3                   	ret    

00802853 <sys_cgetc>:

int
sys_cgetc(void)
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 00                	push   $0x0
  802860:	6a 01                	push   $0x1
  802862:	e8 a4 ff ff ff       	call   80280b <syscall>
  802867:	83 c4 18             	add    $0x18,%esp
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	6a 00                	push   $0x0
  80287a:	50                   	push   %eax
  80287b:	6a 03                	push   $0x3
  80287d:	e8 89 ff ff ff       	call   80280b <syscall>
  802882:	83 c4 18             	add    $0x18,%esp
}
  802885:	c9                   	leave  
  802886:	c3                   	ret    

00802887 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802887:	55                   	push   %ebp
  802888:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	6a 00                	push   $0x0
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	6a 02                	push   $0x2
  802896:	e8 70 ff ff ff       	call   80280b <syscall>
  80289b:	83 c4 18             	add    $0x18,%esp
}
  80289e:	c9                   	leave  
  80289f:	c3                   	ret    

008028a0 <sys_env_exit>:

void sys_env_exit(void)
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 04                	push   $0x4
  8028af:	e8 57 ff ff ff       	call   80280b <syscall>
  8028b4:	83 c4 18             	add    $0x18,%esp
}
  8028b7:	90                   	nop
  8028b8:	c9                   	leave  
  8028b9:	c3                   	ret    

008028ba <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8028ba:	55                   	push   %ebp
  8028bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8028bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	52                   	push   %edx
  8028ca:	50                   	push   %eax
  8028cb:	6a 05                	push   $0x5
  8028cd:	e8 39 ff ff ff       	call   80280b <syscall>
  8028d2:	83 c4 18             	add    $0x18,%esp
}
  8028d5:	c9                   	leave  
  8028d6:	c3                   	ret    

008028d7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	56                   	push   %esi
  8028db:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8028dc:	8b 75 18             	mov    0x18(%ebp),%esi
  8028df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	56                   	push   %esi
  8028ec:	53                   	push   %ebx
  8028ed:	51                   	push   %ecx
  8028ee:	52                   	push   %edx
  8028ef:	50                   	push   %eax
  8028f0:	6a 06                	push   $0x6
  8028f2:	e8 14 ff ff ff       	call   80280b <syscall>
  8028f7:	83 c4 18             	add    $0x18,%esp
}
  8028fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028fd:	5b                   	pop    %ebx
  8028fe:	5e                   	pop    %esi
  8028ff:	5d                   	pop    %ebp
  802900:	c3                   	ret    

00802901 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802901:	55                   	push   %ebp
  802902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802904:	8b 55 0c             	mov    0xc(%ebp),%edx
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	6a 00                	push   $0x0
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	52                   	push   %edx
  802911:	50                   	push   %eax
  802912:	6a 07                	push   $0x7
  802914:	e8 f2 fe ff ff       	call   80280b <syscall>
  802919:	83 c4 18             	add    $0x18,%esp
}
  80291c:	c9                   	leave  
  80291d:	c3                   	ret    

0080291e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80291e:	55                   	push   %ebp
  80291f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802921:	6a 00                	push   $0x0
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	ff 75 0c             	pushl  0xc(%ebp)
  80292a:	ff 75 08             	pushl  0x8(%ebp)
  80292d:	6a 08                	push   $0x8
  80292f:	e8 d7 fe ff ff       	call   80280b <syscall>
  802934:	83 c4 18             	add    $0x18,%esp
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    

00802939 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 09                	push   $0x9
  802948:	e8 be fe ff ff       	call   80280b <syscall>
  80294d:	83 c4 18             	add    $0x18,%esp
}
  802950:	c9                   	leave  
  802951:	c3                   	ret    

00802952 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802955:	6a 00                	push   $0x0
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 0a                	push   $0xa
  802961:	e8 a5 fe ff ff       	call   80280b <syscall>
  802966:	83 c4 18             	add    $0x18,%esp
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	6a 00                	push   $0x0
  802978:	6a 0b                	push   $0xb
  80297a:	e8 8c fe ff ff       	call   80280b <syscall>
  80297f:	83 c4 18             	add    $0x18,%esp
}
  802982:	c9                   	leave  
  802983:	c3                   	ret    

00802984 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802987:	6a 00                	push   $0x0
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	ff 75 0c             	pushl  0xc(%ebp)
  802990:	ff 75 08             	pushl  0x8(%ebp)
  802993:	6a 0d                	push   $0xd
  802995:	e8 71 fe ff ff       	call   80280b <syscall>
  80299a:	83 c4 18             	add    $0x18,%esp
	return;
  80299d:	90                   	nop
}
  80299e:	c9                   	leave  
  80299f:	c3                   	ret    

008029a0 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	ff 75 0c             	pushl  0xc(%ebp)
  8029ac:	ff 75 08             	pushl  0x8(%ebp)
  8029af:	6a 0e                	push   $0xe
  8029b1:	e8 55 fe ff ff       	call   80280b <syscall>
  8029b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8029b9:	90                   	nop
}
  8029ba:	c9                   	leave  
  8029bb:	c3                   	ret    

008029bc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 0c                	push   $0xc
  8029cb:	e8 3b fe ff ff       	call   80280b <syscall>
  8029d0:	83 c4 18             	add    $0x18,%esp
}
  8029d3:	c9                   	leave  
  8029d4:	c3                   	ret    

008029d5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 10                	push   $0x10
  8029e4:	e8 22 fe ff ff       	call   80280b <syscall>
  8029e9:	83 c4 18             	add    $0x18,%esp
}
  8029ec:	90                   	nop
  8029ed:	c9                   	leave  
  8029ee:	c3                   	ret    

008029ef <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8029ef:	55                   	push   %ebp
  8029f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 00                	push   $0x0
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 11                	push   $0x11
  8029fe:	e8 08 fe ff ff       	call   80280b <syscall>
  802a03:	83 c4 18             	add    $0x18,%esp
}
  802a06:	90                   	nop
  802a07:	c9                   	leave  
  802a08:	c3                   	ret    

00802a09 <sys_cputc>:


void
sys_cputc(const char c)
{
  802a09:	55                   	push   %ebp
  802a0a:	89 e5                	mov    %esp,%ebp
  802a0c:	83 ec 04             	sub    $0x4,%esp
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a15:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a19:	6a 00                	push   $0x0
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	50                   	push   %eax
  802a22:	6a 12                	push   $0x12
  802a24:	e8 e2 fd ff ff       	call   80280b <syscall>
  802a29:	83 c4 18             	add    $0x18,%esp
}
  802a2c:	90                   	nop
  802a2d:	c9                   	leave  
  802a2e:	c3                   	ret    

00802a2f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a2f:	55                   	push   %ebp
  802a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a32:	6a 00                	push   $0x0
  802a34:	6a 00                	push   $0x0
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 13                	push   $0x13
  802a3e:	e8 c8 fd ff ff       	call   80280b <syscall>
  802a43:	83 c4 18             	add    $0x18,%esp
}
  802a46:	90                   	nop
  802a47:	c9                   	leave  
  802a48:	c3                   	ret    

00802a49 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802a49:	55                   	push   %ebp
  802a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 00                	push   $0x0
  802a53:	6a 00                	push   $0x0
  802a55:	ff 75 0c             	pushl  0xc(%ebp)
  802a58:	50                   	push   %eax
  802a59:	6a 14                	push   $0x14
  802a5b:	e8 ab fd ff ff       	call   80280b <syscall>
  802a60:	83 c4 18             	add    $0x18,%esp
}
  802a63:	c9                   	leave  
  802a64:	c3                   	ret    

00802a65 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  802a65:	55                   	push   %ebp
  802a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	6a 00                	push   $0x0
  802a6d:	6a 00                	push   $0x0
  802a6f:	6a 00                	push   $0x0
  802a71:	6a 00                	push   $0x0
  802a73:	50                   	push   %eax
  802a74:	6a 17                	push   $0x17
  802a76:	e8 90 fd ff ff       	call   80280b <syscall>
  802a7b:	83 c4 18             	add    $0x18,%esp
}
  802a7e:	c9                   	leave  
  802a7f:	c3                   	ret    

00802a80 <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	6a 00                	push   $0x0
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	50                   	push   %eax
  802a8f:	6a 15                	push   $0x15
  802a91:	e8 75 fd ff ff       	call   80280b <syscall>
  802a96:	83 c4 18             	add    $0x18,%esp
}
  802a99:	90                   	nop
  802a9a:	c9                   	leave  
  802a9b:	c3                   	ret    

00802a9c <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  802a9c:	55                   	push   %ebp
  802a9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	50                   	push   %eax
  802aab:	6a 16                	push   $0x16
  802aad:	e8 59 fd ff ff       	call   80280b <syscall>
  802ab2:	83 c4 18             	add    $0x18,%esp
}
  802ab5:	90                   	nop
  802ab6:	c9                   	leave  
  802ab7:	c3                   	ret    

00802ab8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
  802abb:	83 ec 04             	sub    $0x4,%esp
  802abe:	8b 45 10             	mov    0x10(%ebp),%eax
  802ac1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802ac4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ac7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	6a 00                	push   $0x0
  802ad0:	51                   	push   %ecx
  802ad1:	52                   	push   %edx
  802ad2:	ff 75 0c             	pushl  0xc(%ebp)
  802ad5:	50                   	push   %eax
  802ad6:	6a 18                	push   $0x18
  802ad8:	e8 2e fd ff ff       	call   80280b <syscall>
  802add:	83 c4 18             	add    $0x18,%esp
}
  802ae0:	c9                   	leave  
  802ae1:	c3                   	ret    

00802ae2 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	6a 00                	push   $0x0
  802aed:	6a 00                	push   $0x0
  802aef:	6a 00                	push   $0x0
  802af1:	52                   	push   %edx
  802af2:	50                   	push   %eax
  802af3:	6a 19                	push   $0x19
  802af5:	e8 11 fd ff ff       	call   80280b <syscall>
  802afa:	83 c4 18             	add    $0x18,%esp
}
  802afd:	c9                   	leave  
  802afe:	c3                   	ret    

00802aff <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  802aff:	55                   	push   %ebp
  802b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	6a 00                	push   $0x0
  802b0b:	6a 00                	push   $0x0
  802b0d:	50                   	push   %eax
  802b0e:	6a 1a                	push   $0x1a
  802b10:	e8 f6 fc ff ff       	call   80280b <syscall>
  802b15:	83 c4 18             	add    $0x18,%esp
}
  802b18:	c9                   	leave  
  802b19:	c3                   	ret    

00802b1a <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  802b1a:	55                   	push   %ebp
  802b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  802b1d:	6a 00                	push   $0x0
  802b1f:	6a 00                	push   $0x0
  802b21:	6a 00                	push   $0x0
  802b23:	6a 00                	push   $0x0
  802b25:	6a 00                	push   $0x0
  802b27:	6a 1b                	push   $0x1b
  802b29:	e8 dd fc ff ff       	call   80280b <syscall>
  802b2e:	83 c4 18             	add    $0x18,%esp
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 1c                	push   $0x1c
  802b42:	e8 c4 fc ff ff       	call   80280b <syscall>
  802b47:	83 c4 18             	add    $0x18,%esp
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	6a 00                	push   $0x0
  802b54:	6a 00                	push   $0x0
  802b56:	6a 00                	push   $0x0
  802b58:	ff 75 0c             	pushl  0xc(%ebp)
  802b5b:	50                   	push   %eax
  802b5c:	6a 1d                	push   $0x1d
  802b5e:	e8 a8 fc ff ff       	call   80280b <syscall>
  802b63:	83 c4 18             	add    $0x18,%esp
}
  802b66:	c9                   	leave  
  802b67:	c3                   	ret    

00802b68 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	50                   	push   %eax
  802b77:	6a 1e                	push   $0x1e
  802b79:	e8 8d fc ff ff       	call   80280b <syscall>
  802b7e:	83 c4 18             	add    $0x18,%esp
}
  802b81:	90                   	nop
  802b82:	c9                   	leave  
  802b83:	c3                   	ret    

00802b84 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	50                   	push   %eax
  802b93:	6a 1f                	push   $0x1f
  802b95:	e8 71 fc ff ff       	call   80280b <syscall>
  802b9a:	83 c4 18             	add    $0x18,%esp
}
  802b9d:	90                   	nop
  802b9e:	c9                   	leave  
  802b9f:	c3                   	ret    

00802ba0 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
  802ba3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802ba6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ba9:	8d 50 04             	lea    0x4(%eax),%edx
  802bac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802baf:	6a 00                	push   $0x0
  802bb1:	6a 00                	push   $0x0
  802bb3:	6a 00                	push   $0x0
  802bb5:	52                   	push   %edx
  802bb6:	50                   	push   %eax
  802bb7:	6a 20                	push   $0x20
  802bb9:	e8 4d fc ff ff       	call   80280b <syscall>
  802bbe:	83 c4 18             	add    $0x18,%esp
	return result;
  802bc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802bc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bca:	89 01                	mov    %eax,(%ecx)
  802bcc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	c9                   	leave  
  802bd3:	c2 04 00             	ret    $0x4

00802bd6 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802bd6:	55                   	push   %ebp
  802bd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802bd9:	6a 00                	push   $0x0
  802bdb:	6a 00                	push   $0x0
  802bdd:	ff 75 10             	pushl  0x10(%ebp)
  802be0:	ff 75 0c             	pushl  0xc(%ebp)
  802be3:	ff 75 08             	pushl  0x8(%ebp)
  802be6:	6a 0f                	push   $0xf
  802be8:	e8 1e fc ff ff       	call   80280b <syscall>
  802bed:	83 c4 18             	add    $0x18,%esp
	return ;
  802bf0:	90                   	nop
}
  802bf1:	c9                   	leave  
  802bf2:	c3                   	ret    

00802bf3 <sys_rcr2>:
uint32 sys_rcr2()
{
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 21                	push   $0x21
  802c02:	e8 04 fc ff ff       	call   80280b <syscall>
  802c07:	83 c4 18             	add    $0x18,%esp
}
  802c0a:	c9                   	leave  
  802c0b:	c3                   	ret    

00802c0c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802c0c:	55                   	push   %ebp
  802c0d:	89 e5                	mov    %esp,%ebp
  802c0f:	83 ec 04             	sub    $0x4,%esp
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802c18:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	6a 00                	push   $0x0
  802c24:	50                   	push   %eax
  802c25:	6a 22                	push   $0x22
  802c27:	e8 df fb ff ff       	call   80280b <syscall>
  802c2c:	83 c4 18             	add    $0x18,%esp
	return ;
  802c2f:	90                   	nop
}
  802c30:	c9                   	leave  
  802c31:	c3                   	ret    

00802c32 <rsttst>:
void rsttst()
{
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c35:	6a 00                	push   $0x0
  802c37:	6a 00                	push   $0x0
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 00                	push   $0x0
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 24                	push   $0x24
  802c41:	e8 c5 fb ff ff       	call   80280b <syscall>
  802c46:	83 c4 18             	add    $0x18,%esp
	return ;
  802c49:	90                   	nop
}
  802c4a:	c9                   	leave  
  802c4b:	c3                   	ret    

00802c4c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802c4c:	55                   	push   %ebp
  802c4d:	89 e5                	mov    %esp,%ebp
  802c4f:	83 ec 04             	sub    $0x4,%esp
  802c52:	8b 45 14             	mov    0x14(%ebp),%eax
  802c55:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c58:	8b 55 18             	mov    0x18(%ebp),%edx
  802c5b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c5f:	52                   	push   %edx
  802c60:	50                   	push   %eax
  802c61:	ff 75 10             	pushl  0x10(%ebp)
  802c64:	ff 75 0c             	pushl  0xc(%ebp)
  802c67:	ff 75 08             	pushl  0x8(%ebp)
  802c6a:	6a 23                	push   $0x23
  802c6c:	e8 9a fb ff ff       	call   80280b <syscall>
  802c71:	83 c4 18             	add    $0x18,%esp
	return ;
  802c74:	90                   	nop
}
  802c75:	c9                   	leave  
  802c76:	c3                   	ret    

00802c77 <chktst>:
void chktst(uint32 n)
{
  802c77:	55                   	push   %ebp
  802c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c7a:	6a 00                	push   $0x0
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	ff 75 08             	pushl  0x8(%ebp)
  802c85:	6a 25                	push   $0x25
  802c87:	e8 7f fb ff ff       	call   80280b <syscall>
  802c8c:	83 c4 18             	add    $0x18,%esp
	return ;
  802c8f:	90                   	nop
}
  802c90:	c9                   	leave  
  802c91:	c3                   	ret    

00802c92 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802c92:	55                   	push   %ebp
  802c93:	89 e5                	mov    %esp,%ebp
  802c95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c98:	6a 00                	push   $0x0
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	6a 26                	push   $0x26
  802ca4:	e8 62 fb ff ff       	call   80280b <syscall>
  802ca9:	83 c4 18             	add    $0x18,%esp
  802cac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802caf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802cb3:	75 07                	jne    802cbc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802cb5:	b8 01 00 00 00       	mov    $0x1,%eax
  802cba:	eb 05                	jmp    802cc1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc1:	c9                   	leave  
  802cc2:	c3                   	ret    

00802cc3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802cc3:	55                   	push   %ebp
  802cc4:	89 e5                	mov    %esp,%ebp
  802cc6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	6a 00                	push   $0x0
  802ccf:	6a 00                	push   $0x0
  802cd1:	6a 00                	push   $0x0
  802cd3:	6a 26                	push   $0x26
  802cd5:	e8 31 fb ff ff       	call   80280b <syscall>
  802cda:	83 c4 18             	add    $0x18,%esp
  802cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ce0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802ce4:	75 07                	jne    802ced <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  802ceb:	eb 05                	jmp    802cf2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cf2:	c9                   	leave  
  802cf3:	c3                   	ret    

00802cf4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802cf4:	55                   	push   %ebp
  802cf5:	89 e5                	mov    %esp,%ebp
  802cf7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cfa:	6a 00                	push   $0x0
  802cfc:	6a 00                	push   $0x0
  802cfe:	6a 00                	push   $0x0
  802d00:	6a 00                	push   $0x0
  802d02:	6a 00                	push   $0x0
  802d04:	6a 26                	push   $0x26
  802d06:	e8 00 fb ff ff       	call   80280b <syscall>
  802d0b:	83 c4 18             	add    $0x18,%esp
  802d0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802d11:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802d15:	75 07                	jne    802d1e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802d17:	b8 01 00 00 00       	mov    $0x1,%eax
  802d1c:	eb 05                	jmp    802d23 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d23:	c9                   	leave  
  802d24:	c3                   	ret    

00802d25 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802d25:	55                   	push   %ebp
  802d26:	89 e5                	mov    %esp,%ebp
  802d28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d2b:	6a 00                	push   $0x0
  802d2d:	6a 00                	push   $0x0
  802d2f:	6a 00                	push   $0x0
  802d31:	6a 00                	push   $0x0
  802d33:	6a 00                	push   $0x0
  802d35:	6a 26                	push   $0x26
  802d37:	e8 cf fa ff ff       	call   80280b <syscall>
  802d3c:	83 c4 18             	add    $0x18,%esp
  802d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802d42:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802d46:	75 07                	jne    802d4f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802d48:	b8 01 00 00 00       	mov    $0x1,%eax
  802d4d:	eb 05                	jmp    802d54 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802d4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d54:	c9                   	leave  
  802d55:	c3                   	ret    

00802d56 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802d56:	55                   	push   %ebp
  802d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802d59:	6a 00                	push   $0x0
  802d5b:	6a 00                	push   $0x0
  802d5d:	6a 00                	push   $0x0
  802d5f:	6a 00                	push   $0x0
  802d61:	ff 75 08             	pushl  0x8(%ebp)
  802d64:	6a 27                	push   $0x27
  802d66:	e8 a0 fa ff ff       	call   80280b <syscall>
  802d6b:	83 c4 18             	add    $0x18,%esp
	return ;
  802d6e:	90                   	nop
}
  802d6f:	c9                   	leave  
  802d70:	c3                   	ret    
  802d71:	66 90                	xchg   %ax,%ax
  802d73:	90                   	nop

00802d74 <__udivdi3>:
  802d74:	55                   	push   %ebp
  802d75:	57                   	push   %edi
  802d76:	56                   	push   %esi
  802d77:	53                   	push   %ebx
  802d78:	83 ec 1c             	sub    $0x1c,%esp
  802d7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d8b:	89 ca                	mov    %ecx,%edx
  802d8d:	89 f8                	mov    %edi,%eax
  802d8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d93:	85 f6                	test   %esi,%esi
  802d95:	75 2d                	jne    802dc4 <__udivdi3+0x50>
  802d97:	39 cf                	cmp    %ecx,%edi
  802d99:	77 65                	ja     802e00 <__udivdi3+0x8c>
  802d9b:	89 fd                	mov    %edi,%ebp
  802d9d:	85 ff                	test   %edi,%edi
  802d9f:	75 0b                	jne    802dac <__udivdi3+0x38>
  802da1:	b8 01 00 00 00       	mov    $0x1,%eax
  802da6:	31 d2                	xor    %edx,%edx
  802da8:	f7 f7                	div    %edi
  802daa:	89 c5                	mov    %eax,%ebp
  802dac:	31 d2                	xor    %edx,%edx
  802dae:	89 c8                	mov    %ecx,%eax
  802db0:	f7 f5                	div    %ebp
  802db2:	89 c1                	mov    %eax,%ecx
  802db4:	89 d8                	mov    %ebx,%eax
  802db6:	f7 f5                	div    %ebp
  802db8:	89 cf                	mov    %ecx,%edi
  802dba:	89 fa                	mov    %edi,%edx
  802dbc:	83 c4 1c             	add    $0x1c,%esp
  802dbf:	5b                   	pop    %ebx
  802dc0:	5e                   	pop    %esi
  802dc1:	5f                   	pop    %edi
  802dc2:	5d                   	pop    %ebp
  802dc3:	c3                   	ret    
  802dc4:	39 ce                	cmp    %ecx,%esi
  802dc6:	77 28                	ja     802df0 <__udivdi3+0x7c>
  802dc8:	0f bd fe             	bsr    %esi,%edi
  802dcb:	83 f7 1f             	xor    $0x1f,%edi
  802dce:	75 40                	jne    802e10 <__udivdi3+0x9c>
  802dd0:	39 ce                	cmp    %ecx,%esi
  802dd2:	72 0a                	jb     802dde <__udivdi3+0x6a>
  802dd4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802dd8:	0f 87 9e 00 00 00    	ja     802e7c <__udivdi3+0x108>
  802dde:	b8 01 00 00 00       	mov    $0x1,%eax
  802de3:	89 fa                	mov    %edi,%edx
  802de5:	83 c4 1c             	add    $0x1c,%esp
  802de8:	5b                   	pop    %ebx
  802de9:	5e                   	pop    %esi
  802dea:	5f                   	pop    %edi
  802deb:	5d                   	pop    %ebp
  802dec:	c3                   	ret    
  802ded:	8d 76 00             	lea    0x0(%esi),%esi
  802df0:	31 ff                	xor    %edi,%edi
  802df2:	31 c0                	xor    %eax,%eax
  802df4:	89 fa                	mov    %edi,%edx
  802df6:	83 c4 1c             	add    $0x1c,%esp
  802df9:	5b                   	pop    %ebx
  802dfa:	5e                   	pop    %esi
  802dfb:	5f                   	pop    %edi
  802dfc:	5d                   	pop    %ebp
  802dfd:	c3                   	ret    
  802dfe:	66 90                	xchg   %ax,%ax
  802e00:	89 d8                	mov    %ebx,%eax
  802e02:	f7 f7                	div    %edi
  802e04:	31 ff                	xor    %edi,%edi
  802e06:	89 fa                	mov    %edi,%edx
  802e08:	83 c4 1c             	add    $0x1c,%esp
  802e0b:	5b                   	pop    %ebx
  802e0c:	5e                   	pop    %esi
  802e0d:	5f                   	pop    %edi
  802e0e:	5d                   	pop    %ebp
  802e0f:	c3                   	ret    
  802e10:	bd 20 00 00 00       	mov    $0x20,%ebp
  802e15:	89 eb                	mov    %ebp,%ebx
  802e17:	29 fb                	sub    %edi,%ebx
  802e19:	89 f9                	mov    %edi,%ecx
  802e1b:	d3 e6                	shl    %cl,%esi
  802e1d:	89 c5                	mov    %eax,%ebp
  802e1f:	88 d9                	mov    %bl,%cl
  802e21:	d3 ed                	shr    %cl,%ebp
  802e23:	89 e9                	mov    %ebp,%ecx
  802e25:	09 f1                	or     %esi,%ecx
  802e27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e2b:	89 f9                	mov    %edi,%ecx
  802e2d:	d3 e0                	shl    %cl,%eax
  802e2f:	89 c5                	mov    %eax,%ebp
  802e31:	89 d6                	mov    %edx,%esi
  802e33:	88 d9                	mov    %bl,%cl
  802e35:	d3 ee                	shr    %cl,%esi
  802e37:	89 f9                	mov    %edi,%ecx
  802e39:	d3 e2                	shl    %cl,%edx
  802e3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e3f:	88 d9                	mov    %bl,%cl
  802e41:	d3 e8                	shr    %cl,%eax
  802e43:	09 c2                	or     %eax,%edx
  802e45:	89 d0                	mov    %edx,%eax
  802e47:	89 f2                	mov    %esi,%edx
  802e49:	f7 74 24 0c          	divl   0xc(%esp)
  802e4d:	89 d6                	mov    %edx,%esi
  802e4f:	89 c3                	mov    %eax,%ebx
  802e51:	f7 e5                	mul    %ebp
  802e53:	39 d6                	cmp    %edx,%esi
  802e55:	72 19                	jb     802e70 <__udivdi3+0xfc>
  802e57:	74 0b                	je     802e64 <__udivdi3+0xf0>
  802e59:	89 d8                	mov    %ebx,%eax
  802e5b:	31 ff                	xor    %edi,%edi
  802e5d:	e9 58 ff ff ff       	jmp    802dba <__udivdi3+0x46>
  802e62:	66 90                	xchg   %ax,%ax
  802e64:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e68:	89 f9                	mov    %edi,%ecx
  802e6a:	d3 e2                	shl    %cl,%edx
  802e6c:	39 c2                	cmp    %eax,%edx
  802e6e:	73 e9                	jae    802e59 <__udivdi3+0xe5>
  802e70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e73:	31 ff                	xor    %edi,%edi
  802e75:	e9 40 ff ff ff       	jmp    802dba <__udivdi3+0x46>
  802e7a:	66 90                	xchg   %ax,%ax
  802e7c:	31 c0                	xor    %eax,%eax
  802e7e:	e9 37 ff ff ff       	jmp    802dba <__udivdi3+0x46>
  802e83:	90                   	nop

00802e84 <__umoddi3>:
  802e84:	55                   	push   %ebp
  802e85:	57                   	push   %edi
  802e86:	56                   	push   %esi
  802e87:	53                   	push   %ebx
  802e88:	83 ec 1c             	sub    $0x1c,%esp
  802e8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ea3:	89 f3                	mov    %esi,%ebx
  802ea5:	89 fa                	mov    %edi,%edx
  802ea7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802eab:	89 34 24             	mov    %esi,(%esp)
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	75 1a                	jne    802ecc <__umoddi3+0x48>
  802eb2:	39 f7                	cmp    %esi,%edi
  802eb4:	0f 86 a2 00 00 00    	jbe    802f5c <__umoddi3+0xd8>
  802eba:	89 c8                	mov    %ecx,%eax
  802ebc:	89 f2                	mov    %esi,%edx
  802ebe:	f7 f7                	div    %edi
  802ec0:	89 d0                	mov    %edx,%eax
  802ec2:	31 d2                	xor    %edx,%edx
  802ec4:	83 c4 1c             	add    $0x1c,%esp
  802ec7:	5b                   	pop    %ebx
  802ec8:	5e                   	pop    %esi
  802ec9:	5f                   	pop    %edi
  802eca:	5d                   	pop    %ebp
  802ecb:	c3                   	ret    
  802ecc:	39 f0                	cmp    %esi,%eax
  802ece:	0f 87 ac 00 00 00    	ja     802f80 <__umoddi3+0xfc>
  802ed4:	0f bd e8             	bsr    %eax,%ebp
  802ed7:	83 f5 1f             	xor    $0x1f,%ebp
  802eda:	0f 84 ac 00 00 00    	je     802f8c <__umoddi3+0x108>
  802ee0:	bf 20 00 00 00       	mov    $0x20,%edi
  802ee5:	29 ef                	sub    %ebp,%edi
  802ee7:	89 fe                	mov    %edi,%esi
  802ee9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802eed:	89 e9                	mov    %ebp,%ecx
  802eef:	d3 e0                	shl    %cl,%eax
  802ef1:	89 d7                	mov    %edx,%edi
  802ef3:	89 f1                	mov    %esi,%ecx
  802ef5:	d3 ef                	shr    %cl,%edi
  802ef7:	09 c7                	or     %eax,%edi
  802ef9:	89 e9                	mov    %ebp,%ecx
  802efb:	d3 e2                	shl    %cl,%edx
  802efd:	89 14 24             	mov    %edx,(%esp)
  802f00:	89 d8                	mov    %ebx,%eax
  802f02:	d3 e0                	shl    %cl,%eax
  802f04:	89 c2                	mov    %eax,%edx
  802f06:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f0a:	d3 e0                	shl    %cl,%eax
  802f0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f10:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f14:	89 f1                	mov    %esi,%ecx
  802f16:	d3 e8                	shr    %cl,%eax
  802f18:	09 d0                	or     %edx,%eax
  802f1a:	d3 eb                	shr    %cl,%ebx
  802f1c:	89 da                	mov    %ebx,%edx
  802f1e:	f7 f7                	div    %edi
  802f20:	89 d3                	mov    %edx,%ebx
  802f22:	f7 24 24             	mull   (%esp)
  802f25:	89 c6                	mov    %eax,%esi
  802f27:	89 d1                	mov    %edx,%ecx
  802f29:	39 d3                	cmp    %edx,%ebx
  802f2b:	0f 82 87 00 00 00    	jb     802fb8 <__umoddi3+0x134>
  802f31:	0f 84 91 00 00 00    	je     802fc8 <__umoddi3+0x144>
  802f37:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f3b:	29 f2                	sub    %esi,%edx
  802f3d:	19 cb                	sbb    %ecx,%ebx
  802f3f:	89 d8                	mov    %ebx,%eax
  802f41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f45:	d3 e0                	shl    %cl,%eax
  802f47:	89 e9                	mov    %ebp,%ecx
  802f49:	d3 ea                	shr    %cl,%edx
  802f4b:	09 d0                	or     %edx,%eax
  802f4d:	89 e9                	mov    %ebp,%ecx
  802f4f:	d3 eb                	shr    %cl,%ebx
  802f51:	89 da                	mov    %ebx,%edx
  802f53:	83 c4 1c             	add    $0x1c,%esp
  802f56:	5b                   	pop    %ebx
  802f57:	5e                   	pop    %esi
  802f58:	5f                   	pop    %edi
  802f59:	5d                   	pop    %ebp
  802f5a:	c3                   	ret    
  802f5b:	90                   	nop
  802f5c:	89 fd                	mov    %edi,%ebp
  802f5e:	85 ff                	test   %edi,%edi
  802f60:	75 0b                	jne    802f6d <__umoddi3+0xe9>
  802f62:	b8 01 00 00 00       	mov    $0x1,%eax
  802f67:	31 d2                	xor    %edx,%edx
  802f69:	f7 f7                	div    %edi
  802f6b:	89 c5                	mov    %eax,%ebp
  802f6d:	89 f0                	mov    %esi,%eax
  802f6f:	31 d2                	xor    %edx,%edx
  802f71:	f7 f5                	div    %ebp
  802f73:	89 c8                	mov    %ecx,%eax
  802f75:	f7 f5                	div    %ebp
  802f77:	89 d0                	mov    %edx,%eax
  802f79:	e9 44 ff ff ff       	jmp    802ec2 <__umoddi3+0x3e>
  802f7e:	66 90                	xchg   %ax,%ax
  802f80:	89 c8                	mov    %ecx,%eax
  802f82:	89 f2                	mov    %esi,%edx
  802f84:	83 c4 1c             	add    $0x1c,%esp
  802f87:	5b                   	pop    %ebx
  802f88:	5e                   	pop    %esi
  802f89:	5f                   	pop    %edi
  802f8a:	5d                   	pop    %ebp
  802f8b:	c3                   	ret    
  802f8c:	3b 04 24             	cmp    (%esp),%eax
  802f8f:	72 06                	jb     802f97 <__umoddi3+0x113>
  802f91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f95:	77 0f                	ja     802fa6 <__umoddi3+0x122>
  802f97:	89 f2                	mov    %esi,%edx
  802f99:	29 f9                	sub    %edi,%ecx
  802f9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f9f:	89 14 24             	mov    %edx,(%esp)
  802fa2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fa6:	8b 44 24 04          	mov    0x4(%esp),%eax
  802faa:	8b 14 24             	mov    (%esp),%edx
  802fad:	83 c4 1c             	add    $0x1c,%esp
  802fb0:	5b                   	pop    %ebx
  802fb1:	5e                   	pop    %esi
  802fb2:	5f                   	pop    %edi
  802fb3:	5d                   	pop    %ebp
  802fb4:	c3                   	ret    
  802fb5:	8d 76 00             	lea    0x0(%esi),%esi
  802fb8:	2b 04 24             	sub    (%esp),%eax
  802fbb:	19 fa                	sbb    %edi,%edx
  802fbd:	89 d1                	mov    %edx,%ecx
  802fbf:	89 c6                	mov    %eax,%esi
  802fc1:	e9 71 ff ff ff       	jmp    802f37 <__umoddi3+0xb3>
  802fc6:	66 90                	xchg   %ax,%ax
  802fc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fcc:	72 ea                	jb     802fb8 <__umoddi3+0x134>
  802fce:	89 d9                	mov    %ebx,%ecx
  802fd0:	e9 62 ff ff ff       	jmp    802f37 <__umoddi3+0xb3>
