
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 52 0a 00 00       	call   800a88 <libmain>
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
  800040:	e8 d0 24 00 00       	call   802515 <sys_getenvid>
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

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	6a 01                	push   $0x1
  80006f:	e8 70 29 00 00       	call   8029e4 <sys_set_uheap_strategy>
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
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800096:	e8 2c 25 00 00       	call   8025c7 <sys_calculate_free_frames>
  80009b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80009e:	e8 a7 25 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8000a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	50                   	push   %eax
  8000b0:	e8 42 19 00 00       	call   8019f7 <malloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000bb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000be:	85 c0                	test   %eax,%eax
  8000c0:	79 0a                	jns    8000cc <_main+0x94>
  8000c2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000c5:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  8000ca:	76 14                	jbe    8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 80 2c 80 00       	push   $0x802c80
  8000d4:	6a 1a                	push   $0x1a
  8000d6:	68 b0 2c 80 00       	push   $0x802cb0
  8000db:	e8 69 0a 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8000e0:	e8 65 25 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 c7 2c 80 00       	push   $0x802cc7
  8000f7:	6a 1c                	push   $0x1c
  8000f9:	68 b0 2c 80 00       	push   $0x802cb0
  8000fe:	e8 46 0a 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 bf 24 00 00       	call   8025c7 <sys_calculate_free_frames>
  800108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80010b:	e8 3a 25 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800110:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800116:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 d5 18 00 00       	call   8019f7 <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] <  (USER_HEAP_START + 1*Mega) || (uint32) ptr_allocations[1] >  (USER_HEAP_START + 1*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800128:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80012b:	89 c2                	mov    %eax,%edx
  80012d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800130:	05 00 00 00 80       	add    $0x80000000,%eax
  800135:	39 c2                	cmp    %eax,%edx
  800137:	72 11                	jb     80014a <_main+0x112>
  800139:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80013c:	89 c2                	mov    %eax,%edx
  80013e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800141:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800146:	39 c2                	cmp    %eax,%edx
  800148:	76 14                	jbe    80015e <_main+0x126>
  80014a:	83 ec 04             	sub    $0x4,%esp
  80014d:	68 80 2c 80 00       	push   $0x802c80
  800152:	6a 23                	push   $0x23
  800154:	68 b0 2c 80 00       	push   $0x802cb0
  800159:	e8 eb 09 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80015e:	e8 e7 24 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800163:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800166:	3d 00 01 00 00       	cmp    $0x100,%eax
  80016b:	74 14                	je     800181 <_main+0x149>
  80016d:	83 ec 04             	sub    $0x4,%esp
  800170:	68 c7 2c 80 00       	push   $0x802cc7
  800175:	6a 25                	push   $0x25
  800177:	68 b0 2c 80 00       	push   $0x802cb0
  80017c:	e8 c8 09 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800181:	e8 41 24 00 00       	call   8025c7 <sys_calculate_free_frames>
  800186:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800189:	e8 bc 24 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  80018e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800194:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	50                   	push   %eax
  80019b:	e8 57 18 00 00       	call   8019f7 <malloc>
  8001a0:	83 c4 10             	add    $0x10,%esp
  8001a3:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] <  (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8001a6:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001a9:	89 c2                	mov    %eax,%edx
  8001ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001ae:	01 c0                	add    %eax,%eax
  8001b0:	05 00 00 00 80       	add    $0x80000000,%eax
  8001b5:	39 c2                	cmp    %eax,%edx
  8001b7:	72 13                	jb     8001cc <_main+0x194>
  8001b9:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c1:	01 c0                	add    %eax,%eax
  8001c3:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8001c8:	39 c2                	cmp    %eax,%edx
  8001ca:	76 14                	jbe    8001e0 <_main+0x1a8>
  8001cc:	83 ec 04             	sub    $0x4,%esp
  8001cf:	68 80 2c 80 00       	push   $0x802c80
  8001d4:	6a 2c                	push   $0x2c
  8001d6:	68 b0 2c 80 00       	push   $0x802cb0
  8001db:	e8 69 09 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8001e0:	e8 65 24 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8001e5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001ed:	74 14                	je     800203 <_main+0x1cb>
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	68 c7 2c 80 00       	push   $0x802cc7
  8001f7:	6a 2e                	push   $0x2e
  8001f9:	68 b0 2c 80 00       	push   $0x802cb0
  8001fe:	e8 46 09 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800203:	e8 bf 23 00 00       	call   8025c7 <sys_calculate_free_frames>
  800208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020b:	e8 3a 24 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800210:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800216:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	50                   	push   %eax
  80021d:	e8 d5 17 00 00       	call   8019f7 <malloc>
  800222:	83 c4 10             	add    $0x10,%esp
  800225:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] <  (USER_HEAP_START + 3*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 3*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800228:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800230:	89 c2                	mov    %eax,%edx
  800232:	01 d2                	add    %edx,%edx
  800234:	01 d0                	add    %edx,%eax
  800236:	05 00 00 00 80       	add    $0x80000000,%eax
  80023b:	39 c1                	cmp    %eax,%ecx
  80023d:	72 17                	jb     800256 <_main+0x21e>
  80023f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800247:	89 c2                	mov    %eax,%edx
  800249:	01 d2                	add    %edx,%edx
  80024b:	01 d0                	add    %edx,%eax
  80024d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	76 14                	jbe    80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 80 2c 80 00       	push   $0x802c80
  80025e:	6a 35                	push   $0x35
  800260:	68 b0 2c 80 00       	push   $0x802cb0
  800265:	e8 df 08 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80026a:	e8 db 23 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  80026f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800272:	3d 00 01 00 00       	cmp    $0x100,%eax
  800277:	74 14                	je     80028d <_main+0x255>
  800279:	83 ec 04             	sub    $0x4,%esp
  80027c:	68 c7 2c 80 00       	push   $0x802cc7
  800281:	6a 37                	push   $0x37
  800283:	68 b0 2c 80 00       	push   $0x802cb0
  800288:	e8 bc 08 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80028d:	e8 35 23 00 00       	call   8025c7 <sys_calculate_free_frames>
  800292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800295:	e8 b0 23 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  80029a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  80029d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002a0:	01 c0                	add    %eax,%eax
  8002a2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	50                   	push   %eax
  8002a9:	e8 49 17 00 00       	call   8019f7 <malloc>
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] <  (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002b4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002b7:	89 c2                	mov    %eax,%edx
  8002b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002bc:	c1 e0 02             	shl    $0x2,%eax
  8002bf:	05 00 00 00 80       	add    $0x80000000,%eax
  8002c4:	39 c2                	cmp    %eax,%edx
  8002c6:	72 14                	jb     8002dc <_main+0x2a4>
  8002c8:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002cb:	89 c2                	mov    %eax,%edx
  8002cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d0:	c1 e0 02             	shl    $0x2,%eax
  8002d3:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	76 14                	jbe    8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 80 2c 80 00       	push   $0x802c80
  8002e4:	6a 3e                	push   $0x3e
  8002e6:	68 b0 2c 80 00       	push   $0x802cb0
  8002eb:	e8 59 08 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8002f0:	e8 55 23 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8002f5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f8:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fd:	74 14                	je     800313 <_main+0x2db>
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 c7 2c 80 00       	push   $0x802cc7
  800307:	6a 40                	push   $0x40
  800309:	68 b0 2c 80 00       	push   $0x802cb0
  80030e:	e8 36 08 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800313:	e8 af 22 00 00       	call   8025c7 <sys_calculate_free_frames>
  800318:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031b:	e8 2a 23 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800320:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800323:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800326:	01 c0                	add    %eax,%eax
  800328:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	50                   	push   %eax
  80032f:	e8 c3 16 00 00       	call   8019f7 <malloc>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] <  (USER_HEAP_START + 6*Mega) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 6*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80033a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80033d:	89 c1                	mov    %eax,%ecx
  80033f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800342:	89 d0                	mov    %edx,%eax
  800344:	01 c0                	add    %eax,%eax
  800346:	01 d0                	add    %edx,%eax
  800348:	01 c0                	add    %eax,%eax
  80034a:	05 00 00 00 80       	add    $0x80000000,%eax
  80034f:	39 c1                	cmp    %eax,%ecx
  800351:	72 19                	jb     80036c <_main+0x334>
  800353:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800356:	89 c1                	mov    %eax,%ecx
  800358:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035b:	89 d0                	mov    %edx,%eax
  80035d:	01 c0                	add    %eax,%eax
  80035f:	01 d0                	add    %edx,%eax
  800361:	01 c0                	add    %eax,%eax
  800363:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800368:	39 c1                	cmp    %eax,%ecx
  80036a:	76 14                	jbe    800380 <_main+0x348>
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	68 80 2c 80 00       	push   $0x802c80
  800374:	6a 47                	push   $0x47
  800376:	68 b0 2c 80 00       	push   $0x802cb0
  80037b:	e8 c9 07 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800380:	e8 c5 22 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800385:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800388:	3d 00 02 00 00       	cmp    $0x200,%eax
  80038d:	74 14                	je     8003a3 <_main+0x36b>
  80038f:	83 ec 04             	sub    $0x4,%esp
  800392:	68 c7 2c 80 00       	push   $0x802cc7
  800397:	6a 49                	push   $0x49
  800399:	68 b0 2c 80 00       	push   $0x802cb0
  80039e:	e8 a6 07 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a3:	e8 1f 22 00 00       	call   8025c7 <sys_calculate_free_frames>
  8003a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003ab:	e8 9a 22 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8003b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003b6:	89 c2                	mov    %eax,%edx
  8003b8:	01 d2                	add    %edx,%edx
  8003ba:	01 d0                	add    %edx,%eax
  8003bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	50                   	push   %eax
  8003c3:	e8 2f 16 00 00       	call   8019f7 <malloc>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] <  (USER_HEAP_START + 8*Mega) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 8*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8003ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d1:	89 c2                	mov    %eax,%edx
  8003d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003d6:	c1 e0 03             	shl    $0x3,%eax
  8003d9:	05 00 00 00 80       	add    $0x80000000,%eax
  8003de:	39 c2                	cmp    %eax,%edx
  8003e0:	72 14                	jb     8003f6 <_main+0x3be>
  8003e2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e5:	89 c2                	mov    %eax,%edx
  8003e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ea:	c1 e0 03             	shl    $0x3,%eax
  8003ed:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003f2:	39 c2                	cmp    %eax,%edx
  8003f4:	76 14                	jbe    80040a <_main+0x3d2>
  8003f6:	83 ec 04             	sub    $0x4,%esp
  8003f9:	68 80 2c 80 00       	push   $0x802c80
  8003fe:	6a 50                	push   $0x50
  800400:	68 b0 2c 80 00       	push   $0x802cb0
  800405:	e8 3f 07 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  80040a:	e8 3b 22 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  80040f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800412:	3d 00 03 00 00       	cmp    $0x300,%eax
  800417:	74 14                	je     80042d <_main+0x3f5>
  800419:	83 ec 04             	sub    $0x4,%esp
  80041c:	68 c7 2c 80 00       	push   $0x802cc7
  800421:	6a 52                	push   $0x52
  800423:	68 b0 2c 80 00       	push   $0x802cb0
  800428:	e8 1c 07 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80042d:	e8 95 21 00 00       	call   8025c7 <sys_calculate_free_frames>
  800432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800435:	e8 10 22 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  80043a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80043d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800440:	89 c2                	mov    %eax,%edx
  800442:	01 d2                	add    %edx,%edx
  800444:	01 d0                	add    %edx,%eax
  800446:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800449:	83 ec 0c             	sub    $0xc,%esp
  80044c:	50                   	push   %eax
  80044d:	e8 a5 15 00 00       	call   8019f7 <malloc>
  800452:	83 c4 10             	add    $0x10,%esp
  800455:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] <  (USER_HEAP_START + 11*Mega) || (uint32) ptr_allocations[7] > (USER_HEAP_START + 11*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800458:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80045b:	89 c1                	mov    %eax,%ecx
  80045d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800460:	89 d0                	mov    %edx,%eax
  800462:	c1 e0 02             	shl    $0x2,%eax
  800465:	01 d0                	add    %edx,%eax
  800467:	01 c0                	add    %eax,%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	05 00 00 00 80       	add    $0x80000000,%eax
  800470:	39 c1                	cmp    %eax,%ecx
  800472:	72 1c                	jb     800490 <_main+0x458>
  800474:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800477:	89 c1                	mov    %eax,%ecx
  800479:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80047c:	89 d0                	mov    %edx,%eax
  80047e:	c1 e0 02             	shl    $0x2,%eax
  800481:	01 d0                	add    %edx,%eax
  800483:	01 c0                	add    %eax,%eax
  800485:	01 d0                	add    %edx,%eax
  800487:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80048c:	39 c1                	cmp    %eax,%ecx
  80048e:	76 14                	jbe    8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 80 2c 80 00       	push   $0x802c80
  800498:	6a 59                	push   $0x59
  80049a:	68 b0 2c 80 00       	push   $0x802cb0
  80049f:	e8 a5 06 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  768) panic("Wrong page file allocation: ");
  8004a4:	e8 a1 21 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8004a9:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004ac:	3d 00 03 00 00       	cmp    $0x300,%eax
  8004b1:	74 14                	je     8004c7 <_main+0x48f>
  8004b3:	83 ec 04             	sub    $0x4,%esp
  8004b6:	68 c7 2c 80 00       	push   $0x802cc7
  8004bb:	6a 5b                	push   $0x5b
  8004bd:	68 b0 2c 80 00       	push   $0x802cb0
  8004c2:	e8 82 06 00 00       	call   800b49 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004c7:	e8 fb 20 00 00       	call   8025c7 <sys_calculate_free_frames>
  8004cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004cf:	e8 76 21 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004da:	83 ec 0c             	sub    $0xc,%esp
  8004dd:	50                   	push   %eax
  8004de:	e8 b6 1e 00 00       	call   802399 <free>
  8004e3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  8004e6:	e8 5f 21 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8004eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ee:	29 c2                	sub    %eax,%edx
  8004f0:	89 d0                	mov    %edx,%eax
  8004f2:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004f7:	74 14                	je     80050d <_main+0x4d5>
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	68 e4 2c 80 00       	push   $0x802ce4
  800501:	6a 66                	push   $0x66
  800503:	68 b0 2c 80 00       	push   $0x802cb0
  800508:	e8 3c 06 00 00       	call   800b49 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80050d:	e8 b5 20 00 00       	call   8025c7 <sys_calculate_free_frames>
  800512:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800515:	e8 30 21 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  80051a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  80051d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800520:	83 ec 0c             	sub    $0xc,%esp
  800523:	50                   	push   %eax
  800524:	e8 70 1e 00 00       	call   802399 <free>
  800529:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  512) panic("Wrong page file free: ");
  80052c:	e8 19 21 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800531:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800534:	29 c2                	sub    %eax,%edx
  800536:	89 d0                	mov    %edx,%eax
  800538:	3d 00 02 00 00       	cmp    $0x200,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 e4 2c 80 00       	push   $0x802ce4
  800547:	6a 6e                	push   $0x6e
  800549:	68 b0 2c 80 00       	push   $0x802cb0
  80054e:	e8 f6 05 00 00       	call   800b49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800553:	e8 6f 20 00 00       	call   8025c7 <sys_calculate_free_frames>
  800558:	89 c2                	mov    %eax,%edx
  80055a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80055d:	39 c2                	cmp    %eax,%edx
  80055f:	74 14                	je     800575 <_main+0x53d>
  800561:	83 ec 04             	sub    $0x4,%esp
  800564:	68 fb 2c 80 00       	push   $0x802cfb
  800569:	6a 6f                	push   $0x6f
  80056b:	68 b0 2c 80 00       	push   $0x802cb0
  800570:	e8 d4 05 00 00       	call   800b49 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800575:	e8 4d 20 00 00       	call   8025c7 <sys_calculate_free_frames>
  80057a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80057d:	e8 c8 20 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800582:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  800585:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800588:	83 ec 0c             	sub    $0xc,%esp
  80058b:	50                   	push   %eax
  80058c:	e8 08 1e 00 00       	call   802399 <free>
  800591:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800594:	e8 b1 20 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800599:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80059c:	29 c2                	sub    %eax,%edx
  80059e:	89 d0                	mov    %edx,%eax
  8005a0:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005a5:	74 14                	je     8005bb <_main+0x583>
  8005a7:	83 ec 04             	sub    $0x4,%esp
  8005aa:	68 e4 2c 80 00       	push   $0x802ce4
  8005af:	6a 76                	push   $0x76
  8005b1:	68 b0 2c 80 00       	push   $0x802cb0
  8005b6:	e8 8e 05 00 00       	call   800b49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005bb:	e8 07 20 00 00       	call   8025c7 <sys_calculate_free_frames>
  8005c0:	89 c2                	mov    %eax,%edx
  8005c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005c5:	39 c2                	cmp    %eax,%edx
  8005c7:	74 14                	je     8005dd <_main+0x5a5>
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	68 fb 2c 80 00       	push   $0x802cfb
  8005d1:	6a 77                	push   $0x77
  8005d3:	68 b0 2c 80 00       	push   $0x802cb0
  8005d8:	e8 6c 05 00 00       	call   800b49 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8005dd:	e8 e5 1f 00 00       	call   8025c7 <sys_calculate_free_frames>
  8005e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005e5:	e8 60 20 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8005ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8005ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005f0:	89 d0                	mov    %edx,%eax
  8005f2:	c1 e0 09             	shl    $0x9,%eax
  8005f5:	29 d0                	sub    %edx,%eax
  8005f7:	83 ec 0c             	sub    $0xc,%esp
  8005fa:	50                   	push   %eax
  8005fb:	e8 f7 13 00 00       	call   8019f7 <malloc>
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] <  (USER_HEAP_START + 1*Mega) || (uint32) ptr_allocations[8] > (USER_HEAP_START + 1*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800606:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800609:	89 c2                	mov    %eax,%edx
  80060b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80060e:	05 00 00 00 80       	add    $0x80000000,%eax
  800613:	39 c2                	cmp    %eax,%edx
  800615:	72 11                	jb     800628 <_main+0x5f0>
  800617:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80061a:	89 c2                	mov    %eax,%edx
  80061c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80061f:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800624:	39 c2                	cmp    %eax,%edx
  800626:	76 17                	jbe    80063f <_main+0x607>
  800628:	83 ec 04             	sub    $0x4,%esp
  80062b:	68 80 2c 80 00       	push   $0x802c80
  800630:	68 80 00 00 00       	push   $0x80
  800635:	68 b0 2c 80 00       	push   $0x802cb0
  80063a:	e8 0a 05 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  80063f:	e8 06 20 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800644:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800647:	3d 80 00 00 00       	cmp    $0x80,%eax
  80064c:	74 17                	je     800665 <_main+0x62d>
  80064e:	83 ec 04             	sub    $0x4,%esp
  800651:	68 c7 2c 80 00       	push   $0x802cc7
  800656:	68 82 00 00 00       	push   $0x82
  80065b:	68 b0 2c 80 00       	push   $0x802cb0
  800660:	e8 e4 04 00 00       	call   800b49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800665:	e8 5d 1f 00 00       	call   8025c7 <sys_calculate_free_frames>
  80066a:	89 c2                	mov    %eax,%edx
  80066c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80066f:	39 c2                	cmp    %eax,%edx
  800671:	74 17                	je     80068a <_main+0x652>
  800673:	83 ec 04             	sub    $0x4,%esp
  800676:	68 08 2d 80 00       	push   $0x802d08
  80067b:	68 83 00 00 00       	push   $0x83
  800680:	68 b0 2c 80 00       	push   $0x802cb0
  800685:	e8 bf 04 00 00       	call   800b49 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80068a:	e8 38 1f 00 00       	call   8025c7 <sys_calculate_free_frames>
  80068f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800692:	e8 b3 1f 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800697:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80069a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80069d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	50                   	push   %eax
  8006a4:	e8 4e 13 00 00       	call   8019f7 <malloc>
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] <  (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[9] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8006af:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006b2:	89 c2                	mov    %eax,%edx
  8006b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006b7:	c1 e0 02             	shl    $0x2,%eax
  8006ba:	05 00 00 00 80       	add    $0x80000000,%eax
  8006bf:	39 c2                	cmp    %eax,%edx
  8006c1:	72 14                	jb     8006d7 <_main+0x69f>
  8006c3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006c6:	89 c2                	mov    %eax,%edx
  8006c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006cb:	c1 e0 02             	shl    $0x2,%eax
  8006ce:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d3:	39 c2                	cmp    %eax,%edx
  8006d5:	76 17                	jbe    8006ee <_main+0x6b6>
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	68 80 2c 80 00       	push   $0x802c80
  8006df:	68 89 00 00 00       	push   $0x89
  8006e4:	68 b0 2c 80 00       	push   $0x802cb0
  8006e9:	e8 5b 04 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8006ee:	e8 57 1f 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8006f3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8006f6:	3d 00 01 00 00       	cmp    $0x100,%eax
  8006fb:	74 17                	je     800714 <_main+0x6dc>
  8006fd:	83 ec 04             	sub    $0x4,%esp
  800700:	68 c7 2c 80 00       	push   $0x802cc7
  800705:	68 8b 00 00 00       	push   $0x8b
  80070a:	68 b0 2c 80 00       	push   $0x802cb0
  80070f:	e8 35 04 00 00       	call   800b49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800714:	e8 ae 1e 00 00       	call   8025c7 <sys_calculate_free_frames>
  800719:	89 c2                	mov    %eax,%edx
  80071b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80071e:	39 c2                	cmp    %eax,%edx
  800720:	74 17                	je     800739 <_main+0x701>
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	68 08 2d 80 00       	push   $0x802d08
  80072a:	68 8c 00 00 00       	push   $0x8c
  80072f:	68 b0 2c 80 00       	push   $0x802cb0
  800734:	e8 10 04 00 00       	call   800b49 <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800739:	e8 89 1e 00 00       	call   8025c7 <sys_calculate_free_frames>
  80073e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800741:	e8 04 1f 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800746:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  800749:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80074c:	89 d0                	mov    %edx,%eax
  80074e:	c1 e0 08             	shl    $0x8,%eax
  800751:	29 d0                	sub    %edx,%eax
  800753:	83 ec 0c             	sub    $0xc,%esp
  800756:	50                   	push   %eax
  800757:	e8 9b 12 00 00       	call   8019f7 <malloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] <  (USER_HEAP_START + 1*Mega + 512*kilo) || (uint32) ptr_allocations[10] > (USER_HEAP_START + 1*Mega + 512*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800762:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800765:	89 c2                	mov    %eax,%edx
  800767:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80076a:	c1 e0 09             	shl    $0x9,%eax
  80076d:	89 c1                	mov    %eax,%ecx
  80076f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800772:	01 c8                	add    %ecx,%eax
  800774:	05 00 00 00 80       	add    $0x80000000,%eax
  800779:	39 c2                	cmp    %eax,%edx
  80077b:	72 1b                	jb     800798 <_main+0x760>
  80077d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800780:	89 c2                	mov    %eax,%edx
  800782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800785:	c1 e0 09             	shl    $0x9,%eax
  800788:	89 c1                	mov    %eax,%ecx
  80078a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078d:	01 c8                	add    %ecx,%eax
  80078f:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800794:	39 c2                	cmp    %eax,%edx
  800796:	76 17                	jbe    8007af <_main+0x777>
  800798:	83 ec 04             	sub    $0x4,%esp
  80079b:	68 80 2c 80 00       	push   $0x802c80
  8007a0:	68 92 00 00 00       	push   $0x92
  8007a5:	68 b0 2c 80 00       	push   $0x802cb0
  8007aa:	e8 9a 03 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  8007af:	e8 96 1e 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8007b4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007b7:	83 f8 40             	cmp    $0x40,%eax
  8007ba:	74 17                	je     8007d3 <_main+0x79b>
  8007bc:	83 ec 04             	sub    $0x4,%esp
  8007bf:	68 c7 2c 80 00       	push   $0x802cc7
  8007c4:	68 94 00 00 00       	push   $0x94
  8007c9:	68 b0 2c 80 00       	push   $0x802cb0
  8007ce:	e8 76 03 00 00       	call   800b49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007d3:	e8 ef 1d 00 00       	call   8025c7 <sys_calculate_free_frames>
  8007d8:	89 c2                	mov    %eax,%edx
  8007da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007dd:	39 c2                	cmp    %eax,%edx
  8007df:	74 17                	je     8007f8 <_main+0x7c0>
  8007e1:	83 ec 04             	sub    $0x4,%esp
  8007e4:	68 08 2d 80 00       	push   $0x802d08
  8007e9:	68 95 00 00 00       	push   $0x95
  8007ee:	68 b0 2c 80 00       	push   $0x802cb0
  8007f3:	e8 51 03 00 00       	call   800b49 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8007f8:	e8 ca 1d 00 00       	call   8025c7 <sys_calculate_free_frames>
  8007fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800800:	e8 45 1e 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800805:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  800808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080b:	c1 e0 02             	shl    $0x2,%eax
  80080e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	50                   	push   %eax
  800815:	e8 dd 11 00 00       	call   8019f7 <malloc>
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] <  (USER_HEAP_START + 14*Mega) || (uint32) ptr_allocations[11] > (USER_HEAP_START + 14*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800820:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800823:	89 c1                	mov    %eax,%ecx
  800825:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800828:	89 d0                	mov    %edx,%eax
  80082a:	01 c0                	add    %eax,%eax
  80082c:	01 d0                	add    %edx,%eax
  80082e:	01 c0                	add    %eax,%eax
  800830:	01 d0                	add    %edx,%eax
  800832:	01 c0                	add    %eax,%eax
  800834:	05 00 00 00 80       	add    $0x80000000,%eax
  800839:	39 c1                	cmp    %eax,%ecx
  80083b:	72 1d                	jb     80085a <_main+0x822>
  80083d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800840:	89 c1                	mov    %eax,%ecx
  800842:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800845:	89 d0                	mov    %edx,%eax
  800847:	01 c0                	add    %eax,%eax
  800849:	01 d0                	add    %edx,%eax
  80084b:	01 c0                	add    %eax,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800856:	39 c1                	cmp    %eax,%ecx
  800858:	76 17                	jbe    800871 <_main+0x839>
  80085a:	83 ec 04             	sub    $0x4,%esp
  80085d:	68 80 2c 80 00       	push   $0x802c80
  800862:	68 9b 00 00 00       	push   $0x9b
  800867:	68 b0 2c 80 00       	push   $0x802cb0
  80086c:	e8 d8 02 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800871:	e8 d4 1d 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800876:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800879:	3d 00 04 00 00       	cmp    $0x400,%eax
  80087e:	74 17                	je     800897 <_main+0x85f>
  800880:	83 ec 04             	sub    $0x4,%esp
  800883:	68 c7 2c 80 00       	push   $0x802cc7
  800888:	68 9d 00 00 00       	push   $0x9d
  80088d:	68 b0 2c 80 00       	push   $0x802cb0
  800892:	e8 b2 02 00 00       	call   800b49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800897:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80089a:	e8 28 1d 00 00       	call   8025c7 <sys_calculate_free_frames>
  80089f:	29 c3                	sub    %eax,%ebx
  8008a1:	89 d8                	mov    %ebx,%eax
  8008a3:	83 f8 01             	cmp    $0x1,%eax
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 08 2d 80 00       	push   $0x802d08
  8008b0:	68 9e 00 00 00       	push   $0x9e
  8008b5:	68 b0 2c 80 00       	push   $0x802cb0
  8008ba:	e8 8a 02 00 00       	call   800b49 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8008bf:	e8 03 1d 00 00       	call   8025c7 <sys_calculate_free_frames>
  8008c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008c7:	e8 7e 1d 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8008cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8008cf:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008d2:	83 ec 0c             	sub    $0xc,%esp
  8008d5:	50                   	push   %eax
  8008d6:	e8 be 1a 00 00       	call   802399 <free>
  8008db:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  8008de:	e8 67 1d 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8008e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e6:	29 c2                	sub    %eax,%edx
  8008e8:	89 d0                	mov    %edx,%eax
  8008ea:	3d 00 01 00 00       	cmp    $0x100,%eax
  8008ef:	74 17                	je     800908 <_main+0x8d0>
  8008f1:	83 ec 04             	sub    $0x4,%esp
  8008f4:	68 e4 2c 80 00       	push   $0x802ce4
  8008f9:	68 a8 00 00 00       	push   $0xa8
  8008fe:	68 b0 2c 80 00       	push   $0x802cb0
  800903:	e8 41 02 00 00       	call   800b49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800908:	e8 ba 1c 00 00       	call   8025c7 <sys_calculate_free_frames>
  80090d:	89 c2                	mov    %eax,%edx
  80090f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800912:	39 c2                	cmp    %eax,%edx
  800914:	74 17                	je     80092d <_main+0x8f5>
  800916:	83 ec 04             	sub    $0x4,%esp
  800919:	68 fb 2c 80 00       	push   $0x802cfb
  80091e:	68 a9 00 00 00       	push   $0xa9
  800923:	68 b0 2c 80 00       	push   $0x802cb0
  800928:	e8 1c 02 00 00       	call   800b49 <_panic>

		//Next 1 MB Hole appended also
		freeFrames = sys_calculate_free_frames() ;
  80092d:	e8 95 1c 00 00       	call   8025c7 <sys_calculate_free_frames>
  800932:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800935:	e8 10 1d 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  80093a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  80093d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800940:	83 ec 0c             	sub    $0xc,%esp
  800943:	50                   	push   %eax
  800944:	e8 50 1a 00 00       	call   802399 <free>
  800949:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80094c:	e8 f9 1c 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800951:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800954:	29 c2                	sub    %eax,%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	3d 00 01 00 00       	cmp    $0x100,%eax
  80095d:	74 17                	je     800976 <_main+0x93e>
  80095f:	83 ec 04             	sub    $0x4,%esp
  800962:	68 e4 2c 80 00       	push   $0x802ce4
  800967:	68 b0 00 00 00       	push   $0xb0
  80096c:	68 b0 2c 80 00       	push   $0x802cb0
  800971:	e8 d3 01 00 00       	call   800b49 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800976:	e8 4c 1c 00 00       	call   8025c7 <sys_calculate_free_frames>
  80097b:	89 c2                	mov    %eax,%edx
  80097d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800980:	39 c2                	cmp    %eax,%edx
  800982:	74 17                	je     80099b <_main+0x963>
  800984:	83 ec 04             	sub    $0x4,%esp
  800987:	68 fb 2c 80 00       	push   $0x802cfb
  80098c:	68 b1 00 00 00       	push   $0xb1
  800991:	68 b0 2c 80 00       	push   $0x802cb0
  800996:	e8 ae 01 00 00       	call   800b49 <_panic>
	}

	//[5] Allocate again [test first fit]
	{
		//Allocate 2 MB + 128 KB - should be placed in the contiguous hole (256 KB + 2 MB)
		freeFrames = sys_calculate_free_frames() ;
  80099b:	e8 27 1c 00 00       	call   8025c7 <sys_calculate_free_frames>
  8009a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009a3:	e8 a2 1c 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  8009a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega + 128*kilo - kilo);
  8009ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ae:	c1 e0 06             	shl    $0x6,%eax
  8009b1:	89 c2                	mov    %eax,%edx
  8009b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b6:	01 d0                	add    %edx,%eax
  8009b8:	01 c0                	add    %eax,%eax
  8009ba:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8009bd:	83 ec 0c             	sub    $0xc,%esp
  8009c0:	50                   	push   %eax
  8009c1:	e8 31 10 00 00       	call   8019f7 <malloc>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] <  (USER_HEAP_START + 1*Mega + 768*kilo) || (uint32) ptr_allocations[12] > (USER_HEAP_START + 1*Mega + 768*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8009cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8009cf:	89 c1                	mov    %eax,%ecx
  8009d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009d4:	89 d0                	mov    %edx,%eax
  8009d6:	01 c0                	add    %eax,%eax
  8009d8:	01 d0                	add    %edx,%eax
  8009da:	c1 e0 08             	shl    $0x8,%eax
  8009dd:	89 c2                	mov    %eax,%edx
  8009df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e2:	01 d0                	add    %edx,%eax
  8009e4:	05 00 00 00 80       	add    $0x80000000,%eax
  8009e9:	39 c1                	cmp    %eax,%ecx
  8009eb:	72 21                	jb     800a0e <_main+0x9d6>
  8009ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8009f0:	89 c1                	mov    %eax,%ecx
  8009f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f5:	89 d0                	mov    %edx,%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	c1 e0 08             	shl    $0x8,%eax
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a03:	01 d0                	add    %edx,%eax
  800a05:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800a0a:	39 c1                	cmp    %eax,%ecx
  800a0c:	76 17                	jbe    800a25 <_main+0x9ed>
  800a0e:	83 ec 04             	sub    $0x4,%esp
  800a11:	68 80 2c 80 00       	push   $0x802c80
  800a16:	68 ba 00 00 00       	push   $0xba
  800a1b:	68 b0 2c 80 00       	push   $0x802cb0
  800a20:	e8 24 01 00 00       	call   800b49 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512+32) panic("Wrong page file allocation: ");
  800a25:	e8 20 1c 00 00       	call   80264a <sys_pf_calculate_allocated_pages>
  800a2a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a2d:	3d 20 02 00 00       	cmp    $0x220,%eax
  800a32:	74 17                	je     800a4b <_main+0xa13>
  800a34:	83 ec 04             	sub    $0x4,%esp
  800a37:	68 c7 2c 80 00       	push   $0x802cc7
  800a3c:	68 bc 00 00 00       	push   $0xbc
  800a41:	68 b0 2c 80 00       	push   $0x802cb0
  800a46:	e8 fe 00 00 00       	call   800b49 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800a4b:	e8 77 1b 00 00       	call   8025c7 <sys_calculate_free_frames>
  800a50:	89 c2                	mov    %eax,%edx
  800a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a55:	39 c2                	cmp    %eax,%edx
  800a57:	74 17                	je     800a70 <_main+0xa38>
  800a59:	83 ec 04             	sub    $0x4,%esp
  800a5c:	68 08 2d 80 00       	push   $0x802d08
  800a61:	68 bd 00 00 00       	push   $0xbd
  800a66:	68 b0 2c 80 00       	push   $0x802cb0
  800a6b:	e8 d9 00 00 00       	call   800b49 <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800a70:	83 ec 0c             	sub    $0xc,%esp
  800a73:	68 1c 2d 80 00       	push   $0x802d1c
  800a78:	e8 f7 01 00 00       	call   800c74 <cprintf>
  800a7d:	83 c4 10             	add    $0x10,%esp

	return;
  800a80:	90                   	nop
}
  800a81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a84:	5b                   	pop    %ebx
  800a85:	5f                   	pop    %edi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a92:	7e 0a                	jle    800a9e <libmain+0x16>
		binaryname = argv[0];
  800a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a97:	8b 00                	mov    (%eax),%eax
  800a99:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	ff 75 08             	pushl  0x8(%ebp)
  800aa7:	e8 8c f5 ff ff       	call   800038 <_main>
  800aac:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  800aaf:	e8 61 1a 00 00       	call   802515 <sys_getenvid>
  800ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  800ab7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aba:	89 d0                	mov    %edx,%eax
  800abc:	c1 e0 03             	shl    $0x3,%eax
  800abf:	01 d0                	add    %edx,%eax
  800ac1:	01 c0                	add    %eax,%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800acc:	01 d0                	add    %edx,%eax
  800ace:	c1 e0 03             	shl    $0x3,%eax
  800ad1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_disable_interrupt();
  800ad9:	e8 85 1b 00 00       	call   802663 <sys_disable_interrupt>
		cprintf("**************************************\n");
  800ade:	83 ec 0c             	sub    $0xc,%esp
  800ae1:	68 80 2d 80 00       	push   $0x802d80
  800ae6:	e8 89 01 00 00       	call   800c74 <cprintf>
  800aeb:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d\n", myEnv->pageFaultsCounter);
  800aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af1:	8b 80 dc 02 00 00    	mov    0x2dc(%eax),%eax
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	50                   	push   %eax
  800afb:	68 a8 2d 80 00       	push   $0x802da8
  800b00:	e8 6f 01 00 00       	call   800c74 <cprintf>
  800b05:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800b08:	83 ec 0c             	sub    $0xc,%esp
  800b0b:	68 80 2d 80 00       	push   $0x802d80
  800b10:	e8 5f 01 00 00       	call   800c74 <cprintf>
  800b15:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800b18:	e8 60 1b 00 00       	call   80267d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800b1d:	e8 19 00 00 00       	call   800b3b <exit>
}
  800b22:	90                   	nop
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800b2b:	83 ec 0c             	sub    $0xc,%esp
  800b2e:	6a 00                	push   $0x0
  800b30:	e8 c5 19 00 00       	call   8024fa <sys_env_destroy>
  800b35:	83 c4 10             	add    $0x10,%esp
}
  800b38:	90                   	nop
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <exit>:

void
exit(void)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800b41:	e8 e8 19 00 00       	call   80252e <sys_env_exit>
}
  800b46:	90                   	nop
  800b47:	c9                   	leave  
  800b48:	c3                   	ret    

00800b49 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b52:	83 c0 04             	add    $0x4,%eax
  800b55:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800b58:	a1 50 40 98 00       	mov    0x984050,%eax
  800b5d:	85 c0                	test   %eax,%eax
  800b5f:	74 16                	je     800b77 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800b61:	a1 50 40 98 00       	mov    0x984050,%eax
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	50                   	push   %eax
  800b6a:	68 c1 2d 80 00       	push   $0x802dc1
  800b6f:	e8 00 01 00 00       	call   800c74 <cprintf>
  800b74:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800b77:	a1 00 40 80 00       	mov    0x804000,%eax
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	ff 75 08             	pushl  0x8(%ebp)
  800b82:	50                   	push   %eax
  800b83:	68 c6 2d 80 00       	push   $0x802dc6
  800b88:	e8 e7 00 00 00       	call   800c74 <cprintf>
  800b8d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	83 ec 08             	sub    $0x8,%esp
  800b96:	ff 75 f4             	pushl  -0xc(%ebp)
  800b99:	50                   	push   %eax
  800b9a:	e8 7a 00 00 00       	call   800c19 <vcprintf>
  800b9f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800ba2:	83 ec 0c             	sub    $0xc,%esp
  800ba5:	68 e2 2d 80 00       	push   $0x802de2
  800baa:	e8 c5 00 00 00       	call   800c74 <cprintf>
  800baf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800bb2:	e8 84 ff ff ff       	call   800b3b <exit>

	// should not return here
	while (1) ;
  800bb7:	eb fe                	jmp    800bb7 <_panic+0x6e>

00800bb9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bca:	89 0a                	mov    %ecx,(%edx)
  800bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcf:	88 d1                	mov    %dl,%cl
  800bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	8b 00                	mov    (%eax),%eax
  800bdd:	3d ff 00 00 00       	cmp    $0xff,%eax
  800be2:	75 23                	jne    800c07 <putch+0x4e>
		sys_cputs(b->buf, b->idx);
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	89 c2                	mov    %eax,%edx
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	83 c0 08             	add    $0x8,%eax
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	52                   	push   %edx
  800bf5:	50                   	push   %eax
  800bf6:	e8 c9 18 00 00       	call   8024c4 <sys_cputs>
  800bfb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8b 40 04             	mov    0x4(%eax),%eax
  800c0d:	8d 50 01             	lea    0x1(%eax),%edx
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c16:	90                   	nop
  800c17:	c9                   	leave  
  800c18:	c3                   	ret    

00800c19 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c22:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c29:	00 00 00 
	b.cnt = 0;
  800c2c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c33:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	ff 75 08             	pushl  0x8(%ebp)
  800c3c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c42:	50                   	push   %eax
  800c43:	68 b9 0b 80 00       	push   $0x800bb9
  800c48:	e8 fa 01 00 00       	call   800e47 <vprintfmt>
  800c4d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800c50:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	50                   	push   %eax
  800c5a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c60:	83 c0 08             	add    $0x8,%eax
  800c63:	50                   	push   %eax
  800c64:	e8 5b 18 00 00       	call   8024c4 <sys_cputs>
  800c69:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800c6c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c7a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	83 ec 08             	sub    $0x8,%esp
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	e8 8a ff ff ff       	call   800c19 <vcprintf>
  800c8f:	83 c4 10             	add    $0x10,%esp
  800c92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800ca0:	e8 be 19 00 00       	call   802663 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800ca5:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb4:	50                   	push   %eax
  800cb5:	e8 5f ff ff ff       	call   800c19 <vcprintf>
  800cba:	83 c4 10             	add    $0x10,%esp
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800cc0:	e8 b8 19 00 00       	call   80267d <sys_enable_interrupt>
	return cnt;
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	53                   	push   %ebx
  800cce:	83 ec 14             	sub    $0x14,%esp
  800cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cdd:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ce8:	77 55                	ja     800d3f <printnum+0x75>
  800cea:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ced:	72 05                	jb     800cf4 <printnum+0x2a>
  800cef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cf2:	77 4b                	ja     800d3f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cf4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cf7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cfa:	8b 45 18             	mov    0x18(%ebp),%eax
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	52                   	push   %edx
  800d03:	50                   	push   %eax
  800d04:	ff 75 f4             	pushl  -0xc(%ebp)
  800d07:	ff 75 f0             	pushl  -0x10(%ebp)
  800d0a:	e8 f1 1c 00 00       	call   802a00 <__udivdi3>
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	83 ec 04             	sub    $0x4,%esp
  800d15:	ff 75 20             	pushl  0x20(%ebp)
  800d18:	53                   	push   %ebx
  800d19:	ff 75 18             	pushl  0x18(%ebp)
  800d1c:	52                   	push   %edx
  800d1d:	50                   	push   %eax
  800d1e:	ff 75 0c             	pushl  0xc(%ebp)
  800d21:	ff 75 08             	pushl  0x8(%ebp)
  800d24:	e8 a1 ff ff ff       	call   800cca <printnum>
  800d29:	83 c4 20             	add    $0x20,%esp
  800d2c:	eb 1a                	jmp    800d48 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d2e:	83 ec 08             	sub    $0x8,%esp
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	ff 75 20             	pushl  0x20(%ebp)
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	ff d0                	call   *%eax
  800d3c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d3f:	ff 4d 1c             	decl   0x1c(%ebp)
  800d42:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d46:	7f e6                	jg     800d2e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d48:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d56:	53                   	push   %ebx
  800d57:	51                   	push   %ecx
  800d58:	52                   	push   %edx
  800d59:	50                   	push   %eax
  800d5a:	e8 b1 1d 00 00       	call   802b10 <__umoddi3>
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	05 14 30 80 00       	add    $0x803014,%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f be c0             	movsbl %al,%eax
  800d6c:	83 ec 08             	sub    $0x8,%esp
  800d6f:	ff 75 0c             	pushl  0xc(%ebp)
  800d72:	50                   	push   %eax
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	ff d0                	call   *%eax
  800d78:	83 c4 10             	add    $0x10,%esp
}
  800d7b:	90                   	nop
  800d7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d84:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d88:	7e 1c                	jle    800da6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	8d 50 08             	lea    0x8(%eax),%edx
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	89 10                	mov    %edx,(%eax)
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8b 00                	mov    (%eax),%eax
  800d9c:	83 e8 08             	sub    $0x8,%eax
  800d9f:	8b 50 04             	mov    0x4(%eax),%edx
  800da2:	8b 00                	mov    (%eax),%eax
  800da4:	eb 40                	jmp    800de6 <getuint+0x65>
	else if (lflag)
  800da6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800daa:	74 1e                	je     800dca <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8b 00                	mov    (%eax),%eax
  800db1:	8d 50 04             	lea    0x4(%eax),%edx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 10                	mov    %edx,(%eax)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8b 00                	mov    (%eax),%eax
  800dbe:	83 e8 04             	sub    $0x4,%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc8:	eb 1c                	jmp    800de6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8b 00                	mov    (%eax),%eax
  800dcf:	8d 50 04             	lea    0x4(%eax),%edx
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 10                	mov    %edx,(%eax)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8b 00                	mov    (%eax),%eax
  800ddc:	83 e8 04             	sub    $0x4,%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800deb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800def:	7e 1c                	jle    800e0d <getint+0x25>
		return va_arg(*ap, long long);
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8b 00                	mov    (%eax),%eax
  800df6:	8d 50 08             	lea    0x8(%eax),%edx
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	89 10                	mov    %edx,(%eax)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	83 e8 08             	sub    $0x8,%eax
  800e06:	8b 50 04             	mov    0x4(%eax),%edx
  800e09:	8b 00                	mov    (%eax),%eax
  800e0b:	eb 38                	jmp    800e45 <getint+0x5d>
	else if (lflag)
  800e0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e11:	74 1a                	je     800e2d <getint+0x45>
		return va_arg(*ap, long);
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8b 00                	mov    (%eax),%eax
  800e18:	8d 50 04             	lea    0x4(%eax),%edx
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 10                	mov    %edx,(%eax)
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8b 00                	mov    (%eax),%eax
  800e25:	83 e8 04             	sub    $0x4,%eax
  800e28:	8b 00                	mov    (%eax),%eax
  800e2a:	99                   	cltd   
  800e2b:	eb 18                	jmp    800e45 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8b 00                	mov    (%eax),%eax
  800e32:	8d 50 04             	lea    0x4(%eax),%edx
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	89 10                	mov    %edx,(%eax)
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8b 00                	mov    (%eax),%eax
  800e3f:	83 e8 04             	sub    $0x4,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	99                   	cltd   
}
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e4f:	eb 17                	jmp    800e68 <vprintfmt+0x21>
			if (ch == '\0')
  800e51:	85 db                	test   %ebx,%ebx
  800e53:	0f 84 af 03 00 00    	je     801208 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e59:	83 ec 08             	sub    $0x8,%esp
  800e5c:	ff 75 0c             	pushl  0xc(%ebp)
  800e5f:	53                   	push   %ebx
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	ff d0                	call   *%eax
  800e65:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e68:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	0f b6 d8             	movzbl %al,%ebx
  800e76:	83 fb 25             	cmp    $0x25,%ebx
  800e79:	75 d6                	jne    800e51 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e7b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e7f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e86:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e8d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ea1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	0f b6 d8             	movzbl %al,%ebx
  800ea9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800eac:	83 f8 55             	cmp    $0x55,%eax
  800eaf:	0f 87 2b 03 00 00    	ja     8011e0 <vprintfmt+0x399>
  800eb5:	8b 04 85 38 30 80 00 	mov    0x803038(,%eax,4),%eax
  800ebc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ebe:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ec2:	eb d7                	jmp    800e9b <vprintfmt+0x54>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ec4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ec8:	eb d1                	jmp    800e9b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ed1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ed4:	89 d0                	mov    %edx,%eax
  800ed6:	c1 e0 02             	shl    $0x2,%eax
  800ed9:	01 d0                	add    %edx,%eax
  800edb:	01 c0                	add    %eax,%eax
  800edd:	01 d8                	add    %ebx,%eax
  800edf:	83 e8 30             	sub    $0x30,%eax
  800ee2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800eed:	83 fb 2f             	cmp    $0x2f,%ebx
  800ef0:	7e 3e                	jle    800f30 <vprintfmt+0xe9>
  800ef2:	83 fb 39             	cmp    $0x39,%ebx
  800ef5:	7f 39                	jg     800f30 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ef7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800efa:	eb d5                	jmp    800ed1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800efc:	8b 45 14             	mov    0x14(%ebp),%eax
  800eff:	83 c0 04             	add    $0x4,%eax
  800f02:	89 45 14             	mov    %eax,0x14(%ebp)
  800f05:	8b 45 14             	mov    0x14(%ebp),%eax
  800f08:	83 e8 04             	sub    $0x4,%eax
  800f0b:	8b 00                	mov    (%eax),%eax
  800f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f10:	eb 1f                	jmp    800f31 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f16:	79 83                	jns    800e9b <vprintfmt+0x54>
				width = 0;
  800f18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f1f:	e9 77 ff ff ff       	jmp    800e9b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f24:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f2b:	e9 6b ff ff ff       	jmp    800e9b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f30:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f35:	0f 89 60 ff ff ff    	jns    800e9b <vprintfmt+0x54>
				width = precision, precision = -1;
  800f3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f41:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f48:	e9 4e ff ff ff       	jmp    800e9b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f4d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f50:	e9 46 ff ff ff       	jmp    800e9b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f55:	8b 45 14             	mov    0x14(%ebp),%eax
  800f58:	83 c0 04             	add    $0x4,%eax
  800f5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f61:	83 e8 04             	sub    $0x4,%eax
  800f64:	8b 00                	mov    (%eax),%eax
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	50                   	push   %eax
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	ff d0                	call   *%eax
  800f72:	83 c4 10             	add    $0x10,%esp
			break;
  800f75:	e9 89 02 00 00       	jmp    801203 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7d:	83 c0 04             	add    $0x4,%eax
  800f80:	89 45 14             	mov    %eax,0x14(%ebp)
  800f83:	8b 45 14             	mov    0x14(%ebp),%eax
  800f86:	83 e8 04             	sub    $0x4,%eax
  800f89:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f8b:	85 db                	test   %ebx,%ebx
  800f8d:	79 02                	jns    800f91 <vprintfmt+0x14a>
				err = -err;
  800f8f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f91:	83 fb 64             	cmp    $0x64,%ebx
  800f94:	7f 0b                	jg     800fa1 <vprintfmt+0x15a>
  800f96:	8b 34 9d 80 2e 80 00 	mov    0x802e80(,%ebx,4),%esi
  800f9d:	85 f6                	test   %esi,%esi
  800f9f:	75 19                	jne    800fba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800fa1:	53                   	push   %ebx
  800fa2:	68 25 30 80 00       	push   $0x803025
  800fa7:	ff 75 0c             	pushl  0xc(%ebp)
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	e8 5e 02 00 00       	call   801210 <printfmt>
  800fb2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800fb5:	e9 49 02 00 00       	jmp    801203 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fba:	56                   	push   %esi
  800fbb:	68 2e 30 80 00       	push   $0x80302e
  800fc0:	ff 75 0c             	pushl  0xc(%ebp)
  800fc3:	ff 75 08             	pushl  0x8(%ebp)
  800fc6:	e8 45 02 00 00       	call   801210 <printfmt>
  800fcb:	83 c4 10             	add    $0x10,%esp
			break;
  800fce:	e9 30 02 00 00       	jmp    801203 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd6:	83 c0 04             	add    $0x4,%eax
  800fd9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdf:	83 e8 04             	sub    $0x4,%eax
  800fe2:	8b 30                	mov    (%eax),%esi
  800fe4:	85 f6                	test   %esi,%esi
  800fe6:	75 05                	jne    800fed <vprintfmt+0x1a6>
				p = "(null)";
  800fe8:	be 31 30 80 00       	mov    $0x803031,%esi
			if (width > 0 && padc != '-')
  800fed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff1:	7e 6d                	jle    801060 <vprintfmt+0x219>
  800ff3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ff7:	74 67                	je     801060 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ff9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	50                   	push   %eax
  801000:	56                   	push   %esi
  801001:	e8 0c 03 00 00       	call   801312 <strnlen>
  801006:	83 c4 10             	add    $0x10,%esp
  801009:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80100c:	eb 16                	jmp    801024 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80100e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	50                   	push   %eax
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	ff d0                	call   *%eax
  80101e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801021:	ff 4d e4             	decl   -0x1c(%ebp)
  801024:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801028:	7f e4                	jg     80100e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80102a:	eb 34                	jmp    801060 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80102c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801030:	74 1c                	je     80104e <vprintfmt+0x207>
  801032:	83 fb 1f             	cmp    $0x1f,%ebx
  801035:	7e 05                	jle    80103c <vprintfmt+0x1f5>
  801037:	83 fb 7e             	cmp    $0x7e,%ebx
  80103a:	7e 12                	jle    80104e <vprintfmt+0x207>
					putch('?', putdat);
  80103c:	83 ec 08             	sub    $0x8,%esp
  80103f:	ff 75 0c             	pushl  0xc(%ebp)
  801042:	6a 3f                	push   $0x3f
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	ff d0                	call   *%eax
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	eb 0f                	jmp    80105d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80104e:	83 ec 08             	sub    $0x8,%esp
  801051:	ff 75 0c             	pushl  0xc(%ebp)
  801054:	53                   	push   %ebx
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	ff d0                	call   *%eax
  80105a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80105d:	ff 4d e4             	decl   -0x1c(%ebp)
  801060:	89 f0                	mov    %esi,%eax
  801062:	8d 70 01             	lea    0x1(%eax),%esi
  801065:	8a 00                	mov    (%eax),%al
  801067:	0f be d8             	movsbl %al,%ebx
  80106a:	85 db                	test   %ebx,%ebx
  80106c:	74 24                	je     801092 <vprintfmt+0x24b>
  80106e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801072:	78 b8                	js     80102c <vprintfmt+0x1e5>
  801074:	ff 4d e0             	decl   -0x20(%ebp)
  801077:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80107b:	79 af                	jns    80102c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80107d:	eb 13                	jmp    801092 <vprintfmt+0x24b>
				putch(' ', putdat);
  80107f:	83 ec 08             	sub    $0x8,%esp
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	6a 20                	push   $0x20
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80108f:	ff 4d e4             	decl   -0x1c(%ebp)
  801092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801096:	7f e7                	jg     80107f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801098:	e9 66 01 00 00       	jmp    801203 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8010a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8010a6:	50                   	push   %eax
  8010a7:	e8 3c fd ff ff       	call   800de8 <getint>
  8010ac:	83 c4 10             	add    $0x10,%esp
  8010af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8010b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bb:	85 d2                	test   %edx,%edx
  8010bd:	79 23                	jns    8010e2 <vprintfmt+0x29b>
				putch('-', putdat);
  8010bf:	83 ec 08             	sub    $0x8,%esp
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	6a 2d                	push   $0x2d
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	ff d0                	call   *%eax
  8010cc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d5:	f7 d8                	neg    %eax
  8010d7:	83 d2 00             	adc    $0x0,%edx
  8010da:	f7 da                	neg    %edx
  8010dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010df:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010e2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010e9:	e9 bc 00 00 00       	jmp    8011aa <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010ee:	83 ec 08             	sub    $0x8,%esp
  8010f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010f7:	50                   	push   %eax
  8010f8:	e8 84 fc ff ff       	call   800d81 <getuint>
  8010fd:	83 c4 10             	add    $0x10,%esp
  801100:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801103:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801106:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80110d:	e9 98 00 00 00       	jmp    8011aa <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	ff 75 0c             	pushl  0xc(%ebp)
  801118:	6a 58                	push   $0x58
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	ff d0                	call   *%eax
  80111f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	6a 58                	push   $0x58
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	ff d0                	call   *%eax
  80112f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801132:	83 ec 08             	sub    $0x8,%esp
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	6a 58                	push   $0x58
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	ff d0                	call   *%eax
  80113f:	83 c4 10             	add    $0x10,%esp
			break;
  801142:	e9 bc 00 00 00       	jmp    801203 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801147:	83 ec 08             	sub    $0x8,%esp
  80114a:	ff 75 0c             	pushl  0xc(%ebp)
  80114d:	6a 30                	push   $0x30
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	ff d0                	call   *%eax
  801154:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801157:	83 ec 08             	sub    $0x8,%esp
  80115a:	ff 75 0c             	pushl  0xc(%ebp)
  80115d:	6a 78                	push   $0x78
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	ff d0                	call   *%eax
  801164:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801167:	8b 45 14             	mov    0x14(%ebp),%eax
  80116a:	83 c0 04             	add    $0x4,%eax
  80116d:	89 45 14             	mov    %eax,0x14(%ebp)
  801170:	8b 45 14             	mov    0x14(%ebp),%eax
  801173:	83 e8 04             	sub    $0x4,%eax
  801176:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801178:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801182:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801189:	eb 1f                	jmp    8011aa <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80118b:	83 ec 08             	sub    $0x8,%esp
  80118e:	ff 75 e8             	pushl  -0x18(%ebp)
  801191:	8d 45 14             	lea    0x14(%ebp),%eax
  801194:	50                   	push   %eax
  801195:	e8 e7 fb ff ff       	call   800d81 <getuint>
  80119a:	83 c4 10             	add    $0x10,%esp
  80119d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8011a3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011aa:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8011ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b1:	83 ec 04             	sub    $0x4,%esp
  8011b4:	52                   	push   %edx
  8011b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b8:	50                   	push   %eax
  8011b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8011bf:	ff 75 0c             	pushl  0xc(%ebp)
  8011c2:	ff 75 08             	pushl  0x8(%ebp)
  8011c5:	e8 00 fb ff ff       	call   800cca <printnum>
  8011ca:	83 c4 20             	add    $0x20,%esp
			break;
  8011cd:	eb 34                	jmp    801203 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011cf:	83 ec 08             	sub    $0x8,%esp
  8011d2:	ff 75 0c             	pushl  0xc(%ebp)
  8011d5:	53                   	push   %ebx
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	ff d0                	call   *%eax
  8011db:	83 c4 10             	add    $0x10,%esp
			break;
  8011de:	eb 23                	jmp    801203 <vprintfmt+0x3bc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011e0:	83 ec 08             	sub    $0x8,%esp
  8011e3:	ff 75 0c             	pushl  0xc(%ebp)
  8011e6:	6a 25                	push   $0x25
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	ff d0                	call   *%eax
  8011ed:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011f0:	ff 4d 10             	decl   0x10(%ebp)
  8011f3:	eb 03                	jmp    8011f8 <vprintfmt+0x3b1>
  8011f5:	ff 4d 10             	decl   0x10(%ebp)
  8011f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fb:	48                   	dec    %eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 25                	cmp    $0x25,%al
  801200:	75 f3                	jne    8011f5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801202:	90                   	nop
		}
	}
  801203:	e9 47 fc ff ff       	jmp    800e4f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801208:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801209:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5d                   	pop    %ebp
  80120f:	c3                   	ret    

00801210 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801216:	8d 45 10             	lea    0x10(%ebp),%eax
  801219:	83 c0 04             	add    $0x4,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80121f:	8b 45 10             	mov    0x10(%ebp),%eax
  801222:	ff 75 f4             	pushl  -0xc(%ebp)
  801225:	50                   	push   %eax
  801226:	ff 75 0c             	pushl  0xc(%ebp)
  801229:	ff 75 08             	pushl  0x8(%ebp)
  80122c:	e8 16 fc ff ff       	call   800e47 <vprintfmt>
  801231:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801234:	90                   	nop
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	8b 40 08             	mov    0x8(%eax),%eax
  801240:	8d 50 01             	lea    0x1(%eax),%edx
  801243:	8b 45 0c             	mov    0xc(%ebp),%eax
  801246:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	8b 10                	mov    (%eax),%edx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	8b 40 04             	mov    0x4(%eax),%eax
  801254:	39 c2                	cmp    %eax,%edx
  801256:	73 12                	jae    80126a <sprintputch+0x33>
		*b->buf++ = ch;
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 0c             	mov    0xc(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8b 55 08             	mov    0x8(%ebp),%edx
  801268:	88 10                	mov    %dl,(%eax)
}
  80126a:	90                   	nop
  80126b:	5d                   	pop    %ebp
  80126c:	c3                   	ret    

0080126d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	01 d0                	add    %edx,%eax
  801284:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801287:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80128e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801292:	74 06                	je     80129a <vsnprintf+0x2d>
  801294:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801298:	7f 07                	jg     8012a1 <vsnprintf+0x34>
		return -E_INVAL;
  80129a:	b8 03 00 00 00       	mov    $0x3,%eax
  80129f:	eb 20                	jmp    8012c1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012a1:	ff 75 14             	pushl  0x14(%ebp)
  8012a4:	ff 75 10             	pushl  0x10(%ebp)
  8012a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012aa:	50                   	push   %eax
  8012ab:	68 37 12 80 00       	push   $0x801237
  8012b0:	e8 92 fb ff ff       	call   800e47 <vprintfmt>
  8012b5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012bb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012c9:	8d 45 10             	lea    0x10(%ebp),%eax
  8012cc:	83 c0 04             	add    $0x4,%eax
  8012cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d8:	50                   	push   %eax
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	ff 75 08             	pushl  0x8(%ebp)
  8012df:	e8 89 ff ff ff       	call   80126d <vsnprintf>
  8012e4:	83 c4 10             	add    $0x10,%esp
  8012e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fc:	eb 06                	jmp    801304 <strlen+0x15>
		n++;
  8012fe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801301:	ff 45 08             	incl   0x8(%ebp)
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	75 f1                	jne    8012fe <strlen+0xf>
		n++;
	return n;
  80130d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80131f:	eb 09                	jmp    80132a <strnlen+0x18>
		n++;
  801321:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801324:	ff 45 08             	incl   0x8(%ebp)
  801327:	ff 4d 0c             	decl   0xc(%ebp)
  80132a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80132e:	74 09                	je     801339 <strnlen+0x27>
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	84 c0                	test   %al,%al
  801337:	75 e8                	jne    801321 <strnlen+0xf>
		n++;
	return n;
  801339:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80134a:	90                   	nop
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	8d 50 01             	lea    0x1(%eax),%edx
  801351:	89 55 08             	mov    %edx,0x8(%ebp)
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
  801357:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80135d:	8a 12                	mov    (%edx),%dl
  80135f:	88 10                	mov    %dl,(%eax)
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	75 e4                	jne    80134b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801367:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80137f:	eb 1f                	jmp    8013a0 <strncpy+0x34>
		*dst++ = *src;
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8d 50 01             	lea    0x1(%eax),%edx
  801387:	89 55 08             	mov    %edx,0x8(%ebp)
  80138a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138d:	8a 12                	mov    (%edx),%dl
  80138f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801391:	8b 45 0c             	mov    0xc(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	84 c0                	test   %al,%al
  801398:	74 03                	je     80139d <strncpy+0x31>
			src++;
  80139a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
  8013a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013a6:	72 d9                	jb     801381 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bd:	74 30                	je     8013ef <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013bf:	eb 16                	jmp    8013d7 <strlcpy+0x2a>
			*dst++ = *src++;
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8d 50 01             	lea    0x1(%eax),%edx
  8013c7:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013d3:	8a 12                	mov    (%edx),%dl
  8013d5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013d7:	ff 4d 10             	decl   0x10(%ebp)
  8013da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013de:	74 09                	je     8013e9 <strlcpy+0x3c>
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	84 c0                	test   %al,%al
  8013e7:	75 d8                	jne    8013c1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f5:	29 c2                	sub    %eax,%edx
  8013f7:	89 d0                	mov    %edx,%eax
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013fe:	eb 06                	jmp    801406 <strcmp+0xb>
		p++, q++;
  801400:	ff 45 08             	incl   0x8(%ebp)
  801403:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	84 c0                	test   %al,%al
  80140d:	74 0e                	je     80141d <strcmp+0x22>
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8a 10                	mov    (%eax),%dl
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	38 c2                	cmp    %al,%dl
  80141b:	74 e3                	je     801400 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f b6 d0             	movzbl %al,%edx
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	0f b6 c0             	movzbl %al,%eax
  80142d:	29 c2                	sub    %eax,%edx
  80142f:	89 d0                	mov    %edx,%eax
}
  801431:	5d                   	pop    %ebp
  801432:	c3                   	ret    

00801433 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801436:	eb 09                	jmp    801441 <strncmp+0xe>
		n--, p++, q++;
  801438:	ff 4d 10             	decl   0x10(%ebp)
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801441:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801445:	74 17                	je     80145e <strncmp+0x2b>
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	84 c0                	test   %al,%al
  80144e:	74 0e                	je     80145e <strncmp+0x2b>
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8a 10                	mov    (%eax),%dl
  801455:	8b 45 0c             	mov    0xc(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	38 c2                	cmp    %al,%dl
  80145c:	74 da                	je     801438 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80145e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801462:	75 07                	jne    80146b <strncmp+0x38>
		return 0;
  801464:	b8 00 00 00 00       	mov    $0x0,%eax
  801469:	eb 14                	jmp    80147f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	0f b6 d0             	movzbl %al,%edx
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	0f b6 c0             	movzbl %al,%eax
  80147b:	29 c2                	sub    %eax,%edx
  80147d:	89 d0                	mov    %edx,%eax
}
  80147f:	5d                   	pop    %ebp
  801480:	c3                   	ret    

00801481 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	83 ec 04             	sub    $0x4,%esp
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148d:	eb 12                	jmp    8014a1 <strchr+0x20>
		if (*s == c)
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801497:	75 05                	jne    80149e <strchr+0x1d>
			return (char *) s;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	eb 11                	jmp    8014af <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80149e:	ff 45 08             	incl   0x8(%ebp)
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	84 c0                	test   %al,%al
  8014a8:	75 e5                	jne    80148f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	83 ec 04             	sub    $0x4,%esp
  8014b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014bd:	eb 0d                	jmp    8014cc <strfind+0x1b>
		if (*s == c)
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014c7:	74 0e                	je     8014d7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014c9:	ff 45 08             	incl   0x8(%ebp)
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	84 c0                	test   %al,%al
  8014d3:	75 ea                	jne    8014bf <strfind+0xe>
  8014d5:	eb 01                	jmp    8014d8 <strfind+0x27>
		if (*s == c)
			break;
  8014d7:	90                   	nop
	return (char *) s;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014ef:	eb 0e                	jmp    8014ff <memset+0x22>
		*p++ = c;
  8014f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f4:	8d 50 01             	lea    0x1(%eax),%edx
  8014f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014ff:	ff 4d f8             	decl   -0x8(%ebp)
  801502:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801506:	79 e9                	jns    8014f1 <memset+0x14>
		*p++ = c;

	return v;
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801513:	8b 45 0c             	mov    0xc(%ebp),%eax
  801516:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80151f:	eb 16                	jmp    801537 <memcpy+0x2a>
		*d++ = *s++;
  801521:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801524:	8d 50 01             	lea    0x1(%eax),%edx
  801527:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80152a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801530:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801533:	8a 12                	mov    (%edx),%dl
  801535:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801537:	8b 45 10             	mov    0x10(%ebp),%eax
  80153a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80153d:	89 55 10             	mov    %edx,0x10(%ebp)
  801540:	85 c0                	test   %eax,%eax
  801542:	75 dd                	jne    801521 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  80154f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801552:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80155b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801561:	73 50                	jae    8015b3 <memmove+0x6a>
  801563:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801566:	8b 45 10             	mov    0x10(%ebp),%eax
  801569:	01 d0                	add    %edx,%eax
  80156b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80156e:	76 43                	jbe    8015b3 <memmove+0x6a>
		s += n;
  801570:	8b 45 10             	mov    0x10(%ebp),%eax
  801573:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80157c:	eb 10                	jmp    80158e <memmove+0x45>
			*--d = *--s;
  80157e:	ff 4d f8             	decl   -0x8(%ebp)
  801581:	ff 4d fc             	decl   -0x4(%ebp)
  801584:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801587:	8a 10                	mov    (%eax),%dl
  801589:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	8d 50 ff             	lea    -0x1(%eax),%edx
  801594:	89 55 10             	mov    %edx,0x10(%ebp)
  801597:	85 c0                	test   %eax,%eax
  801599:	75 e3                	jne    80157e <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80159b:	eb 23                	jmp    8015c0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80159d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a0:	8d 50 01             	lea    0x1(%eax),%edx
  8015a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015af:	8a 12                	mov    (%edx),%dl
  8015b1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	75 dd                	jne    80159d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015d7:	eb 2a                	jmp    801603 <memcmp+0x3e>
		if (*s1 != *s2)
  8015d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015dc:	8a 10                	mov    (%eax),%dl
  8015de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e1:	8a 00                	mov    (%eax),%al
  8015e3:	38 c2                	cmp    %al,%dl
  8015e5:	74 16                	je     8015fd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ea:	8a 00                	mov    (%eax),%al
  8015ec:	0f b6 d0             	movzbl %al,%edx
  8015ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	0f b6 c0             	movzbl %al,%eax
  8015f7:	29 c2                	sub    %eax,%edx
  8015f9:	89 d0                	mov    %edx,%eax
  8015fb:	eb 18                	jmp    801615 <memcmp+0x50>
		s1++, s2++;
  8015fd:	ff 45 fc             	incl   -0x4(%ebp)
  801600:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801603:	8b 45 10             	mov    0x10(%ebp),%eax
  801606:	8d 50 ff             	lea    -0x1(%eax),%edx
  801609:	89 55 10             	mov    %edx,0x10(%ebp)
  80160c:	85 c0                	test   %eax,%eax
  80160e:	75 c9                	jne    8015d9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80161d:	8b 55 08             	mov    0x8(%ebp),%edx
  801620:	8b 45 10             	mov    0x10(%ebp),%eax
  801623:	01 d0                	add    %edx,%eax
  801625:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801628:	eb 15                	jmp    80163f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	0f b6 d0             	movzbl %al,%edx
  801632:	8b 45 0c             	mov    0xc(%ebp),%eax
  801635:	0f b6 c0             	movzbl %al,%eax
  801638:	39 c2                	cmp    %eax,%edx
  80163a:	74 0d                	je     801649 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80163c:	ff 45 08             	incl   0x8(%ebp)
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801645:	72 e3                	jb     80162a <memfind+0x13>
  801647:	eb 01                	jmp    80164a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801649:	90                   	nop
	return (void *) s;
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801655:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80165c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801663:	eb 03                	jmp    801668 <strtol+0x19>
		s++;
  801665:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	3c 20                	cmp    $0x20,%al
  80166f:	74 f4                	je     801665 <strtol+0x16>
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	8a 00                	mov    (%eax),%al
  801676:	3c 09                	cmp    $0x9,%al
  801678:	74 eb                	je     801665 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8a 00                	mov    (%eax),%al
  80167f:	3c 2b                	cmp    $0x2b,%al
  801681:	75 05                	jne    801688 <strtol+0x39>
		s++;
  801683:	ff 45 08             	incl   0x8(%ebp)
  801686:	eb 13                	jmp    80169b <strtol+0x4c>
	else if (*s == '-')
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8a 00                	mov    (%eax),%al
  80168d:	3c 2d                	cmp    $0x2d,%al
  80168f:	75 0a                	jne    80169b <strtol+0x4c>
		s++, neg = 1;
  801691:	ff 45 08             	incl   0x8(%ebp)
  801694:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80169b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80169f:	74 06                	je     8016a7 <strtol+0x58>
  8016a1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016a5:	75 20                	jne    8016c7 <strtol+0x78>
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	8a 00                	mov    (%eax),%al
  8016ac:	3c 30                	cmp    $0x30,%al
  8016ae:	75 17                	jne    8016c7 <strtol+0x78>
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	40                   	inc    %eax
  8016b4:	8a 00                	mov    (%eax),%al
  8016b6:	3c 78                	cmp    $0x78,%al
  8016b8:	75 0d                	jne    8016c7 <strtol+0x78>
		s += 2, base = 16;
  8016ba:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8016be:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016c5:	eb 28                	jmp    8016ef <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cb:	75 15                	jne    8016e2 <strtol+0x93>
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	3c 30                	cmp    $0x30,%al
  8016d4:	75 0c                	jne    8016e2 <strtol+0x93>
		s++, base = 8;
  8016d6:	ff 45 08             	incl   0x8(%ebp)
  8016d9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016e0:	eb 0d                	jmp    8016ef <strtol+0xa0>
	else if (base == 0)
  8016e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016e6:	75 07                	jne    8016ef <strtol+0xa0>
		base = 10;
  8016e8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 2f                	cmp    $0x2f,%al
  8016f6:	7e 19                	jle    801711 <strtol+0xc2>
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	3c 39                	cmp    $0x39,%al
  8016ff:	7f 10                	jg     801711 <strtol+0xc2>
			dig = *s - '0';
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f be c0             	movsbl %al,%eax
  801709:	83 e8 30             	sub    $0x30,%eax
  80170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170f:	eb 42                	jmp    801753 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 60                	cmp    $0x60,%al
  801718:	7e 19                	jle    801733 <strtol+0xe4>
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 7a                	cmp    $0x7a,%al
  801721:	7f 10                	jg     801733 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 57             	sub    $0x57,%eax
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801731:	eb 20                	jmp    801753 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8a 00                	mov    (%eax),%al
  801738:	3c 40                	cmp    $0x40,%al
  80173a:	7e 39                	jle    801775 <strtol+0x126>
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	8a 00                	mov    (%eax),%al
  801741:	3c 5a                	cmp    $0x5a,%al
  801743:	7f 30                	jg     801775 <strtol+0x126>
			dig = *s - 'A' + 10;
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	8a 00                	mov    (%eax),%al
  80174a:	0f be c0             	movsbl %al,%eax
  80174d:	83 e8 37             	sub    $0x37,%eax
  801750:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801756:	3b 45 10             	cmp    0x10(%ebp),%eax
  801759:	7d 19                	jge    801774 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80175b:	ff 45 08             	incl   0x8(%ebp)
  80175e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801761:	0f af 45 10          	imul   0x10(%ebp),%eax
  801765:	89 c2                	mov    %eax,%edx
  801767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176a:	01 d0                	add    %edx,%eax
  80176c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80176f:	e9 7b ff ff ff       	jmp    8016ef <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801774:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801775:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801779:	74 08                	je     801783 <strtol+0x134>
		*endptr = (char *) s;
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	8b 55 08             	mov    0x8(%ebp),%edx
  801781:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801783:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801787:	74 07                	je     801790 <strtol+0x141>
  801789:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178c:	f7 d8                	neg    %eax
  80178e:	eb 03                	jmp    801793 <strtol+0x144>
  801790:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <ltostr>:

void
ltostr(long value, char *str)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80179b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017ad:	79 13                	jns    8017c2 <ltostr+0x2d>
	{
		neg = 1;
  8017af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017bc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8017bf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017ca:	99                   	cltd   
  8017cb:	f7 f9                	idiv   %ecx
  8017cd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d3:	8d 50 01             	lea    0x1(%eax),%edx
  8017d6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017d9:	89 c2                	mov    %eax,%edx
  8017db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017de:	01 d0                	add    %edx,%eax
  8017e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017e3:	83 c2 30             	add    $0x30,%edx
  8017e6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017eb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017f0:	f7 e9                	imul   %ecx
  8017f2:	c1 fa 02             	sar    $0x2,%edx
  8017f5:	89 c8                	mov    %ecx,%eax
  8017f7:	c1 f8 1f             	sar    $0x1f,%eax
  8017fa:	29 c2                	sub    %eax,%edx
  8017fc:	89 d0                	mov    %edx,%eax
  8017fe:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801801:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801804:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801809:	f7 e9                	imul   %ecx
  80180b:	c1 fa 02             	sar    $0x2,%edx
  80180e:	89 c8                	mov    %ecx,%eax
  801810:	c1 f8 1f             	sar    $0x1f,%eax
  801813:	29 c2                	sub    %eax,%edx
  801815:	89 d0                	mov    %edx,%eax
  801817:	c1 e0 02             	shl    $0x2,%eax
  80181a:	01 d0                	add    %edx,%eax
  80181c:	01 c0                	add    %eax,%eax
  80181e:	29 c1                	sub    %eax,%ecx
  801820:	89 ca                	mov    %ecx,%edx
  801822:	85 d2                	test   %edx,%edx
  801824:	75 9c                	jne    8017c2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801826:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80182d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801830:	48                   	dec    %eax
  801831:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801834:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801838:	74 3d                	je     801877 <ltostr+0xe2>
		start = 1 ;
  80183a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801841:	eb 34                	jmp    801877 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801846:	8b 45 0c             	mov    0xc(%ebp),%eax
  801849:	01 d0                	add    %edx,%eax
  80184b:	8a 00                	mov    (%eax),%al
  80184d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801850:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801853:	8b 45 0c             	mov    0xc(%ebp),%eax
  801856:	01 c2                	add    %eax,%edx
  801858:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80185b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185e:	01 c8                	add    %ecx,%eax
  801860:	8a 00                	mov    (%eax),%al
  801862:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801864:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186a:	01 c2                	add    %eax,%edx
  80186c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80186f:	88 02                	mov    %al,(%edx)
		start++ ;
  801871:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801874:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80187d:	7c c4                	jl     801843 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80187f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	01 d0                	add    %edx,%eax
  801887:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801893:	ff 75 08             	pushl  0x8(%ebp)
  801896:	e8 54 fa ff ff       	call   8012ef <strlen>
  80189b:	83 c4 04             	add    $0x4,%esp
  80189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018a1:	ff 75 0c             	pushl  0xc(%ebp)
  8018a4:	e8 46 fa ff ff       	call   8012ef <strlen>
  8018a9:	83 c4 04             	add    $0x4,%esp
  8018ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018bd:	eb 17                	jmp    8018d6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8018bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c5:	01 c2                	add    %eax,%edx
  8018c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	01 c8                	add    %ecx,%eax
  8018cf:	8a 00                	mov    (%eax),%al
  8018d1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018d3:	ff 45 fc             	incl   -0x4(%ebp)
  8018d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018dc:	7c e1                	jl     8018bf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ec:	eb 1f                	jmp    80190d <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f1:	8d 50 01             	lea    0x1(%eax),%edx
  8018f4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018f7:	89 c2                	mov    %eax,%edx
  8018f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fc:	01 c2                	add    %eax,%edx
  8018fe:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801901:	8b 45 0c             	mov    0xc(%ebp),%eax
  801904:	01 c8                	add    %ecx,%eax
  801906:	8a 00                	mov    (%eax),%al
  801908:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80190a:	ff 45 f8             	incl   -0x8(%ebp)
  80190d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801910:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801913:	7c d9                	jl     8018ee <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801915:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801918:	8b 45 10             	mov    0x10(%ebp),%eax
  80191b:	01 d0                	add    %edx,%eax
  80191d:	c6 00 00             	movb   $0x0,(%eax)
}
  801920:	90                   	nop
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801926:	8b 45 14             	mov    0x14(%ebp),%eax
  801929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80192f:	8b 45 14             	mov    0x14(%ebp),%eax
  801932:	8b 00                	mov    (%eax),%eax
  801934:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80193b:	8b 45 10             	mov    0x10(%ebp),%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801946:	eb 0c                	jmp    801954 <strsplit+0x31>
			*string++ = 0;
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8d 50 01             	lea    0x1(%eax),%edx
  80194e:	89 55 08             	mov    %edx,0x8(%ebp)
  801951:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1) 
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8a 00                	mov    (%eax),%al
  801959:	84 c0                	test   %al,%al
  80195b:	74 18                	je     801975 <strsplit+0x52>
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	8a 00                	mov    (%eax),%al
  801962:	0f be c0             	movsbl %al,%eax
  801965:	50                   	push   %eax
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	e8 13 fb ff ff       	call   801481 <strchr>
  80196e:	83 c4 08             	add    $0x8,%esp
  801971:	85 c0                	test   %eax,%eax
  801973:	75 d3                	jne    801948 <strsplit+0x25>
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	84 c0                	test   %al,%al
  80197c:	74 5a                	je     8019d8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1) 
  80197e:	8b 45 14             	mov    0x14(%ebp),%eax
  801981:	8b 00                	mov    (%eax),%eax
  801983:	83 f8 0f             	cmp    $0xf,%eax
  801986:	75 07                	jne    80198f <strsplit+0x6c>
		{
			return 0;
  801988:	b8 00 00 00 00       	mov    $0x0,%eax
  80198d:	eb 66                	jmp    8019f5 <strsplit+0xd2>
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80198f:	8b 45 14             	mov    0x14(%ebp),%eax
  801992:	8b 00                	mov    (%eax),%eax
  801994:	8d 48 01             	lea    0x1(%eax),%ecx
  801997:	8b 55 14             	mov    0x14(%ebp),%edx
  80199a:	89 0a                	mov    %ecx,(%edx)
  80199c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a6:	01 c2                	add    %eax,%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019ad:	eb 03                	jmp    8019b2 <strsplit+0x8f>
			string++;
  8019af:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}
		
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	8a 00                	mov    (%eax),%al
  8019b7:	84 c0                	test   %al,%al
  8019b9:	74 8b                	je     801946 <strsplit+0x23>
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8a 00                	mov    (%eax),%al
  8019c0:	0f be c0             	movsbl %al,%eax
  8019c3:	50                   	push   %eax
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	e8 b5 fa ff ff       	call   801481 <strchr>
  8019cc:	83 c4 08             	add    $0x8,%esp
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 dc                	je     8019af <strsplit+0x8c>
			string++;
	}
  8019d3:	e9 6e ff ff ff       	jmp    801946 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;
		
		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019d8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dc:	8b 00                	mov    (%eax),%eax
  8019de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e8:	01 d0                	add    %edx,%eax
  8019ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019f0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <malloc>:
int cnt_mem = 0;
int heap_mem[size_uhmem] = { 0 };
struct hmem heap_size[size_uhmem] = { 0 };
int check = 0;

void* malloc(uint32 size) {
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyNEXTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	//NEXT FIT
	if (sys_isUHeapPlacementStrategyNEXTFIT()) {
  801a00:	e8 7d 0f 00 00       	call   802982 <sys_isUHeapPlacementStrategyNEXTFIT>
  801a05:	85 c0                	test   %eax,%eax
  801a07:	0f 84 6f 03 00 00    	je     801d7c <malloc+0x385>
		size = ROUNDUP(size, PAGE_SIZE);
  801a0d:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  801a14:	8b 55 08             	mov    0x8(%ebp),%edx
  801a17:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801a1a:	01 d0                	add    %edx,%eax
  801a1c:	48                   	dec    %eax
  801a1d:	89 45 80             	mov    %eax,-0x80(%ebp)
  801a20:	8b 45 80             	mov    -0x80(%ebp),%eax
  801a23:	ba 00 00 00 00       	mov    $0x0,%edx
  801a28:	f7 75 84             	divl   -0x7c(%ebp)
  801a2b:	8b 45 80             	mov    -0x80(%ebp),%eax
  801a2e:	29 d0                	sub    %edx,%eax
  801a30:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801a33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a37:	74 09                	je     801a42 <malloc+0x4b>
  801a39:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801a40:	76 0a                	jbe    801a4c <malloc+0x55>
			return NULL;
  801a42:	b8 00 00 00 00       	mov    $0x0,%eax
  801a47:	e9 4b 09 00 00       	jmp    802397 <malloc+0x9a0>
		}
		// first we can allocate by " Strategy Continues "
		if (ptr_uheap + size <= (uint32) USER_HEAP_MAX && !check) {
  801a4c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	01 d0                	add    %edx,%eax
  801a57:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801a5c:	0f 87 a2 00 00 00    	ja     801b04 <malloc+0x10d>
  801a62:	a1 40 40 98 00       	mov    0x984040,%eax
  801a67:	85 c0                	test   %eax,%eax
  801a69:	0f 85 95 00 00 00    	jne    801b04 <malloc+0x10d>

			void* ret = (void *) ptr_uheap;
  801a6f:	a1 04 40 80 00       	mov    0x804004,%eax
  801a74:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			sys_allocateMem(ptr_uheap, size);
  801a7a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	50                   	push   %eax
  801a86:	e8 a3 0b 00 00       	call   80262e <sys_allocateMem>
  801a8b:	83 c4 10             	add    $0x10,%esp

			heap_size[cnt_mem].size = size;
  801a8e:	a1 20 40 80 00       	mov    0x804020,%eax
  801a93:	8b 55 08             	mov    0x8(%ebp),%edx
  801a96:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801a9d:	a1 20 40 80 00       	mov    0x804020,%eax
  801aa2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801aa8:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
			cnt_mem++;
  801aaf:	a1 20 40 80 00       	mov    0x804020,%eax
  801ab4:	40                   	inc    %eax
  801ab5:	a3 20 40 80 00       	mov    %eax,0x804020
			int i = 0;
  801aba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801ac1:	eb 2e                	jmp    801af1 <malloc+0xfa>
			{

				heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801ac3:	a1 04 40 80 00       	mov    0x804004,%eax
  801ac8:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] = 1;
  801acd:	c1 e8 0c             	shr    $0xc,%eax
  801ad0:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801ad7:	01 00 00 00 

				ptr_uheap += (uint32) PAGE_SIZE;
  801adb:	a1 04 40 80 00       	mov    0x804004,%eax
  801ae0:	05 00 10 00 00       	add    $0x1000,%eax
  801ae5:	a3 04 40 80 00       	mov    %eax,0x804004
			heap_size[cnt_mem].size = size;
			heap_size[cnt_mem].vir = (void*) ptr_uheap;
			cnt_mem++;
			int i = 0;
			// init my array with 1 to make sure this frame is busy
			for (; i < size; i += PAGE_SIZE)
  801aea:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801af7:	72 ca                	jb     801ac3 <malloc+0xcc>
						/ (uint32) PAGE_SIZE)] = 1;

				ptr_uheap += (uint32) PAGE_SIZE;
			}

			return ret;
  801af9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  801aff:	e9 93 08 00 00       	jmp    802397 <malloc+0x9a0>

		} else {
			// second we can allocate by " Strategy NEXTFIT "
			void* temp_end = NULL;
  801b04:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

			int check_start = 0;
  801b0b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			// check first that we used " Strategy Continues " before and not do it again and turn to NEXTFIT
			if (!check) {
  801b12:	a1 40 40 98 00       	mov    0x984040,%eax
  801b17:	85 c0                	test   %eax,%eax
  801b19:	75 1d                	jne    801b38 <malloc+0x141>
				ptr_uheap = (uint32) USER_HEAP_START;
  801b1b:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801b22:	00 00 80 
				check = 1;
  801b25:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  801b2c:	00 00 00 
				check_start = 1;// to dont use second loop CZ ptr_uheap start from USER_HEAP_START
  801b2f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  801b36:	eb 08                	jmp    801b40 <malloc+0x149>
			} else {
				temp_end = (void*) ptr_uheap;
  801b38:	a1 04 40 80 00       	mov    0x804004,%eax
  801b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)

			}

			uint32 sz = 0;
  801b40:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int f = 0;
  801b47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			uint32 ptr = ptr_uheap;
  801b4e:	a1 04 40 80 00       	mov    0x804004,%eax
  801b53:	89 45 e0             	mov    %eax,-0x20(%ebp)
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801b56:	eb 4d                	jmp    801ba5 <malloc+0x1ae>
				if (sz == size) {
  801b58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b5b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b5e:	75 09                	jne    801b69 <malloc+0x172>
					f = 1;
  801b60:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801b67:	eb 45                	jmp    801bae <malloc+0x1b7>
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801b69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b6c:	05 00 00 00 80       	add    $0x80000000,%eax
						/ (uint32) PAGE_SIZE)] == 0) {
  801b71:	c1 e8 0c             	shr    $0xc,%eax
			while (ptr < (uint32) USER_HEAP_MAX) {
				if (sz == size) {
					f = 1;
					break;
				}
				if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801b74:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	75 10                	jne    801b8f <malloc+0x198>
						/ (uint32) PAGE_SIZE)] == 0) {

					sz += PAGE_SIZE;
  801b7f:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801b86:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  801b8d:	eb 16                	jmp    801ba5 <malloc+0x1ae>
				} else {
					sz = 0;
  801b8f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
					ptr += PAGE_SIZE;
  801b96:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
					ptr_uheap = ptr;
  801b9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ba0:	a3 04 40 80 00       	mov    %eax,0x804004

			uint32 sz = 0;
			int f = 0;
			uint32 ptr = ptr_uheap;
			// check if there are enough size in memory to allocate there
			while (ptr < (uint32) USER_HEAP_MAX) {
  801ba5:	81 7d e0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x20(%ebp)
  801bac:	76 aa                	jbe    801b58 <malloc+0x161>
					ptr_uheap = ptr;
				}

			}

			if (f) {
  801bae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bb2:	0f 84 95 00 00 00    	je     801c4d <malloc+0x256>

				void* ret = (void *) ptr_uheap;
  801bb8:	a1 04 40 80 00       	mov    0x804004,%eax
  801bbd:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

				sys_allocateMem(ptr_uheap, size);
  801bc3:	a1 04 40 80 00       	mov    0x804004,%eax
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	ff 75 08             	pushl  0x8(%ebp)
  801bce:	50                   	push   %eax
  801bcf:	e8 5a 0a 00 00       	call   80262e <sys_allocateMem>
  801bd4:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  801bd7:	a1 20 40 80 00       	mov    0x804020,%eax
  801bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bdf:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801be6:	a1 20 40 80 00       	mov    0x804020,%eax
  801beb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bf1:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  801bf8:	a1 20 40 80 00       	mov    0x804020,%eax
  801bfd:	40                   	inc    %eax
  801bfe:	a3 20 40 80 00       	mov    %eax,0x804020
				int i = 0;
  801c03:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801c0a:	eb 2e                	jmp    801c3a <malloc+0x243>
				{

					heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801c0c:	a1 04 40 80 00       	mov    0x804004,%eax
  801c11:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  801c16:	c1 e8 0c             	shr    $0xc,%eax
  801c19:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801c20:	01 00 00 00 

					ptr_uheap += (uint32) PAGE_SIZE;
  801c24:	a1 04 40 80 00       	mov    0x804004,%eax
  801c29:	05 00 10 00 00       	add    $0x1000,%eax
  801c2e:	a3 04 40 80 00       	mov    %eax,0x804004
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) ptr_uheap;
				cnt_mem++;
				int i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  801c33:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801c3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c40:	72 ca                	jb     801c0c <malloc+0x215>
							/ (uint32) PAGE_SIZE)] = 1;

					ptr_uheap += (uint32) PAGE_SIZE;
				}

				return ret;
  801c42:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801c48:	e9 4a 07 00 00       	jmp    802397 <malloc+0x9a0>

			} else {

				if (check_start) {
  801c4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c51:	74 0a                	je     801c5d <malloc+0x266>

					return NULL;
  801c53:	b8 00 00 00 00       	mov    $0x0,%eax
  801c58:	e9 3a 07 00 00       	jmp    802397 <malloc+0x9a0>
				}

//////////////back loop////////////////

				uint32 sz = 0;
  801c5d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
				int f = 0;
  801c64:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				uint32 ptr = USER_HEAP_START;
  801c6b:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
				ptr_uheap = USER_HEAP_START;
  801c72:	c7 05 04 40 80 00 00 	movl   $0x80000000,0x804004
  801c79:	00 00 80 
				while (ptr < (uint32) temp_end) {
  801c7c:	eb 4d                	jmp    801ccb <malloc+0x2d4>
					if (sz == size) {
  801c7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c81:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c84:	75 09                	jne    801c8f <malloc+0x298>
						f = 1;
  801c86:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
						break;
  801c8d:	eb 44                	jmp    801cd3 <malloc+0x2dc>
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801c8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c92:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] == 0) {
  801c97:	c1 e8 0c             	shr    $0xc,%eax
				while (ptr < (uint32) temp_end) {
					if (sz == size) {
						f = 1;
						break;
					}
					if (heap_mem[(int) ((ptr - (uint32) USER_HEAP_START)
  801c9a:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	75 10                	jne    801cb5 <malloc+0x2be>
							/ (uint32) PAGE_SIZE)] == 0) {

						sz += PAGE_SIZE;
  801ca5:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801cac:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
  801cb3:	eb 16                	jmp    801ccb <malloc+0x2d4>
					} else {
						sz = 0;
  801cb5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
						ptr += PAGE_SIZE;
  801cbc:	81 45 d0 00 10 00 00 	addl   $0x1000,-0x30(%ebp)
						ptr_uheap = ptr;
  801cc3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cc6:	a3 04 40 80 00       	mov    %eax,0x804004

				uint32 sz = 0;
				int f = 0;
				uint32 ptr = USER_HEAP_START;
				ptr_uheap = USER_HEAP_START;
				while (ptr < (uint32) temp_end) {
  801ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cce:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801cd1:	72 ab                	jb     801c7e <malloc+0x287>
						ptr_uheap = ptr;
					}

				}

				if (f) {
  801cd3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801cd7:	0f 84 95 00 00 00    	je     801d72 <malloc+0x37b>

					void* ret = (void *) ptr_uheap;
  801cdd:	a1 04 40 80 00       	mov    0x804004,%eax
  801ce2:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

					sys_allocateMem(ptr_uheap, size);
  801ce8:	a1 04 40 80 00       	mov    0x804004,%eax
  801ced:	83 ec 08             	sub    $0x8,%esp
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	50                   	push   %eax
  801cf4:	e8 35 09 00 00       	call   80262e <sys_allocateMem>
  801cf9:	83 c4 10             	add    $0x10,%esp

					heap_size[cnt_mem].size = size;
  801cfc:	a1 20 40 80 00       	mov    0x804020,%eax
  801d01:	8b 55 08             	mov    0x8(%ebp),%edx
  801d04:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
  801d0b:	a1 20 40 80 00       	mov    0x804020,%eax
  801d10:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d16:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
					cnt_mem++;
  801d1d:	a1 20 40 80 00       	mov    0x804020,%eax
  801d22:	40                   	inc    %eax
  801d23:	a3 20 40 80 00       	mov    %eax,0x804020
					int i = 0;
  801d28:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

					for (; i < size; i += PAGE_SIZE)
  801d2f:	eb 2e                	jmp    801d5f <malloc+0x368>
					{

						heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  801d31:	a1 04 40 80 00       	mov    0x804004,%eax
  801d36:	05 00 00 00 80       	add    $0x80000000,%eax
								/ (uint32) PAGE_SIZE)] = 1;
  801d3b:	c1 e8 0c             	shr    $0xc,%eax
  801d3e:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801d45:	01 00 00 00 

						ptr_uheap += (uint32) PAGE_SIZE;
  801d49:	a1 04 40 80 00       	mov    0x804004,%eax
  801d4e:	05 00 10 00 00       	add    $0x1000,%eax
  801d53:	a3 04 40 80 00       	mov    %eax,0x804004
					heap_size[cnt_mem].size = size;
					heap_size[cnt_mem].vir = (void*) ptr_uheap;
					cnt_mem++;
					int i = 0;

					for (; i < size; i += PAGE_SIZE)
  801d58:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  801d5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d62:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d65:	72 ca                	jb     801d31 <malloc+0x33a>
								/ (uint32) PAGE_SIZE)] = 1;

						ptr_uheap += (uint32) PAGE_SIZE;
					}

					return ret;
  801d67:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801d6d:	e9 25 06 00 00       	jmp    802397 <malloc+0x9a0>

				} else {

					return NULL;
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
  801d77:	e9 1b 06 00 00       	jmp    802397 <malloc+0x9a0>

		}

	}

	else if (sys_isUHeapPlacementStrategyBESTFIT()) {
  801d7c:	e8 d0 0b 00 00       	call   802951 <sys_isUHeapPlacementStrategyBESTFIT>
  801d81:	85 c0                	test   %eax,%eax
  801d83:	0f 84 ba 01 00 00    	je     801f43 <malloc+0x54c>

		size = ROUNDUP(size, PAGE_SIZE);
  801d89:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  801d90:	10 00 00 
  801d93:	8b 55 08             	mov    0x8(%ebp),%edx
  801d96:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801d9c:	01 d0                	add    %edx,%eax
  801d9e:	48                   	dec    %eax
  801d9f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  801da5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801dab:	ba 00 00 00 00       	mov    $0x0,%edx
  801db0:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  801db6:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801dbc:	29 d0                	sub    %edx,%eax
  801dbe:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801dc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dc5:	74 09                	je     801dd0 <malloc+0x3d9>
  801dc7:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801dce:	76 0a                	jbe    801dda <malloc+0x3e3>
			return NULL;
  801dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd5:	e9 bd 05 00 00       	jmp    802397 <malloc+0x9a0>
		}
		uint32 ptr = (uint32) USER_HEAP_START;
  801dda:	c7 45 c8 00 00 00 80 	movl   $0x80000000,-0x38(%ebp)
		uint32 temp = 0;
  801de1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		uint32 min_sz = size_uhmem + 1;
  801de8:	c7 45 c0 01 00 02 00 	movl   $0x20001,-0x40(%ebp)
		uint32 count = 0;
  801def:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
		int i = 0;
  801df6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	c1 e8 0c             	shr    $0xc,%eax
  801e03:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801e09:	e9 80 00 00 00       	jmp    801e8e <malloc+0x497>

			if (heap_mem[i] == 0) {
  801e0e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e11:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	75 0c                	jne    801e28 <malloc+0x431>

				count++;
  801e1c:	ff 45 bc             	incl   -0x44(%ebp)
				ptr += PAGE_SIZE;
  801e1f:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801e26:	eb 2d                	jmp    801e55 <malloc+0x45e>
			} else {
				if (num_p <= count && min_sz > count) {
  801e28:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801e2e:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801e31:	77 14                	ja     801e47 <malloc+0x450>
  801e33:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e36:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801e39:	76 0c                	jbe    801e47 <malloc+0x450>

					min_sz = count;
  801e3b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e3e:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801e41:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e44:	89 45 c4             	mov    %eax,-0x3c(%ebp)

				}
				count = 0;
  801e47:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
				ptr += PAGE_SIZE;
  801e4e:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
			}

			if (i == size_uhmem - 1) {
  801e55:	81 7d b8 ff ff 01 00 	cmpl   $0x1ffff,-0x48(%ebp)
  801e5c:	75 2d                	jne    801e8b <malloc+0x494>

				if (num_p <= count && min_sz > count) {
  801e5e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801e64:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801e67:	77 22                	ja     801e8b <malloc+0x494>
  801e69:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e6c:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  801e6f:	76 1a                	jbe    801e8b <malloc+0x494>

					min_sz = count;
  801e71:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e74:	89 45 c0             	mov    %eax,-0x40(%ebp)
					temp = ptr;
  801e77:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
					count = 0;
  801e7d:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
					ptr += PAGE_SIZE;
  801e84:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		// get min mem and can to fit in size
		for (; i < size_uhmem; i++) {
  801e8b:	ff 45 b8             	incl   -0x48(%ebp)
  801e8e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e91:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  801e96:	0f 86 72 ff ff ff    	jbe    801e0e <malloc+0x417>

			}

		}

		if (num_p > min_sz || temp == 0) {
  801e9c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  801ea2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  801ea5:	77 06                	ja     801ead <malloc+0x4b6>
  801ea7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801eab:	75 0a                	jne    801eb7 <malloc+0x4c0>
			return NULL;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb2:	e9 e0 04 00 00       	jmp    802397 <malloc+0x9a0>

		}

		temp = temp - (PAGE_SIZE * min_sz);
  801eb7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801eba:	c1 e0 0c             	shl    $0xc,%eax
  801ebd:	29 45 c4             	sub    %eax,-0x3c(%ebp)
		void* ret = (void*) temp;
  801ec0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ec3:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)

		sys_allocateMem(temp, size);
  801ec9:	83 ec 08             	sub    $0x8,%esp
  801ecc:	ff 75 08             	pushl  0x8(%ebp)
  801ecf:	ff 75 c4             	pushl  -0x3c(%ebp)
  801ed2:	e8 57 07 00 00       	call   80262e <sys_allocateMem>
  801ed7:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  801eda:	a1 20 40 80 00       	mov    0x804020,%eax
  801edf:	8b 55 08             	mov    0x8(%ebp),%edx
  801ee2:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  801ee9:	a1 20 40 80 00       	mov    0x804020,%eax
  801eee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801ef1:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  801ef8:	a1 20 40 80 00       	mov    0x804020,%eax
  801efd:	40                   	inc    %eax
  801efe:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  801f03:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801f0a:	eb 24                	jmp    801f30 <malloc+0x539>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  801f0c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f0f:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  801f14:	c1 e8 0c             	shr    $0xc,%eax
  801f17:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  801f1e:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  801f22:	81 45 c4 00 10 00 00 	addl   $0x1000,-0x3c(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  801f29:	81 45 b8 00 10 00 00 	addl   $0x1000,-0x48(%ebp)
  801f30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f33:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f36:	72 d4                	jb     801f0c <malloc+0x515>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  801f38:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801f3e:	e9 54 04 00 00       	jmp    802397 <malloc+0x9a0>

	} else if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801f43:	e8 d8 09 00 00       	call   802920 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	0f 84 88 01 00 00    	je     8020d8 <malloc+0x6e1>

		size = ROUNDUP(size, PAGE_SIZE);
  801f50:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  801f57:	10 00 00 
  801f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f5d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801f63:	01 d0                	add    %edx,%eax
  801f65:	48                   	dec    %eax
  801f66:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  801f6c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801f72:	ba 00 00 00 00       	mov    $0x0,%edx
  801f77:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  801f7d:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801f83:	29 d0                	sub    %edx,%eax
  801f85:	89 45 08             	mov    %eax,0x8(%ebp)

		if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  801f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f8c:	74 09                	je     801f97 <malloc+0x5a0>
  801f8e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801f95:	76 0a                	jbe    801fa1 <malloc+0x5aa>
			return NULL;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9c:	e9 f6 03 00 00       	jmp    802397 <malloc+0x9a0>
		}

		uint32 ptr = (uint32) USER_HEAP_START;
  801fa1:	c7 45 b4 00 00 00 80 	movl   $0x80000000,-0x4c(%ebp)
		uint32 temp = 0;
  801fa8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
		uint32 found = 0;
  801faf:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		uint32 count = 0;
  801fb6:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
		int i = 0;
  801fbd:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		uint32 num_p = size / PAGE_SIZE;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	c1 e8 0c             	shr    $0xc,%eax
  801fca:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

		for (; i < size_uhmem; i++) {
  801fd0:	eb 5a                	jmp    80202c <malloc+0x635>

			if (heap_mem[i] == 0) {
  801fd2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801fd5:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	75 0c                	jne    801fec <malloc+0x5f5>

				count++;
  801fe0:	ff 45 a8             	incl   -0x58(%ebp)
				ptr += PAGE_SIZE;
  801fe3:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
  801fea:	eb 22                	jmp    80200e <malloc+0x617>
			} else {
				if (num_p <= count) {
  801fec:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801ff2:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  801ff5:	77 09                	ja     802000 <malloc+0x609>

					found = 1;
  801ff7:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)

					break;
  801ffe:	eb 36                	jmp    802036 <malloc+0x63f>
				}
				count = 0;
  802000:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
				ptr += PAGE_SIZE;
  802007:	81 45 b4 00 10 00 00 	addl   $0x1000,-0x4c(%ebp)
			}

			if (i == size_uhmem - 1) {
  80200e:	81 7d a4 ff ff 01 00 	cmpl   $0x1ffff,-0x5c(%ebp)
  802015:	75 12                	jne    802029 <malloc+0x632>

				if (num_p <= count) {
  802017:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80201d:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  802020:	77 07                	ja     802029 <malloc+0x632>

					found = 1;
  802022:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
		uint32 found = 0;
		uint32 count = 0;
		int i = 0;
		uint32 num_p = size / PAGE_SIZE;

		for (; i < size_uhmem; i++) {
  802029:	ff 45 a4             	incl   -0x5c(%ebp)
  80202c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80202f:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  802034:	76 9c                	jbe    801fd2 <malloc+0x5db>

			}

		}

		if (!found) {
  802036:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  80203a:	75 0a                	jne    802046 <malloc+0x64f>
			return NULL;
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
  802041:	e9 51 03 00 00       	jmp    802397 <malloc+0x9a0>

		}

		temp = ptr;
  802046:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802049:	89 45 b0             	mov    %eax,-0x50(%ebp)
		temp = temp - (PAGE_SIZE * count);
  80204c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80204f:	c1 e0 0c             	shl    $0xc,%eax
  802052:	29 45 b0             	sub    %eax,-0x50(%ebp)
		void* ret = (void*) temp;
  802055:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802058:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)

		sys_allocateMem(temp, size);
  80205e:	83 ec 08             	sub    $0x8,%esp
  802061:	ff 75 08             	pushl  0x8(%ebp)
  802064:	ff 75 b0             	pushl  -0x50(%ebp)
  802067:	e8 c2 05 00 00       	call   80262e <sys_allocateMem>
  80206c:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  80206f:	a1 20 40 80 00       	mov    0x804020,%eax
  802074:	8b 55 08             	mov    0x8(%ebp),%edx
  802077:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) temp;
  80207e:	a1 20 40 80 00       	mov    0x804020,%eax
  802083:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802086:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  80208d:	a1 20 40 80 00       	mov    0x804020,%eax
  802092:	40                   	inc    %eax
  802093:	a3 20 40 80 00       	mov    %eax,0x804020
		i = 0;
  802098:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  80209f:	eb 24                	jmp    8020c5 <malloc+0x6ce>
		{

			heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  8020a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020a4:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  8020a9:	c1 e8 0c             	shr    $0xc,%eax
  8020ac:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  8020b3:	01 00 00 00 

			temp += (uint32) PAGE_SIZE;
  8020b7:	81 45 b0 00 10 00 00 	addl   $0x1000,-0x50(%ebp)
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) temp;
		cnt_mem++;
		i = 0;
		// init my array with 1 to make sure this frame is busy
		for (; i < size; i += PAGE_SIZE)
  8020be:	81 45 a4 00 10 00 00 	addl   $0x1000,-0x5c(%ebp)
  8020c5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8020c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020cb:	72 d4                	jb     8020a1 <malloc+0x6aa>
					/ (uint32) PAGE_SIZE)] = 1;

			temp += (uint32) PAGE_SIZE;
		}

		return ret;
  8020cd:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8020d3:	e9 bf 02 00 00       	jmp    802397 <malloc+0x9a0>

	}
	else if(sys_isUHeapPlacementStrategyWORSTFIT())
  8020d8:	e8 d6 08 00 00       	call   8029b3 <sys_isUHeapPlacementStrategyWORSTFIT>
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	0f 84 ba 01 00 00    	je     80229f <malloc+0x8a8>
	{
		size = ROUNDUP(size, PAGE_SIZE);
  8020e5:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  8020ec:	10 00 00 
  8020ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f2:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8020f8:	01 d0                	add    %edx,%eax
  8020fa:	48                   	dec    %eax
  8020fb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  802101:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802107:	ba 00 00 00 00       	mov    $0x0,%edx
  80210c:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  802112:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  802118:	29 d0                	sub    %edx,%eax
  80211a:	89 45 08             	mov    %eax,0x8(%ebp)

				if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  80211d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802121:	74 09                	je     80212c <malloc+0x735>
  802123:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80212a:	76 0a                	jbe    802136 <malloc+0x73f>
					return NULL;
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
  802131:	e9 61 02 00 00       	jmp    802397 <malloc+0x9a0>
				}
				uint32 ptr = (uint32) USER_HEAP_START;
  802136:	c7 45 a0 00 00 00 80 	movl   $0x80000000,-0x60(%ebp)
				uint32 temp = 0;
  80213d:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
				uint32 max_sz = -1;
  802144:	c7 45 98 ff ff ff ff 	movl   $0xffffffff,-0x68(%ebp)
				uint32 count = 0;
  80214b:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
				int i = 0;
  802152:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				uint32 num_p = size / PAGE_SIZE;
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	c1 e8 0c             	shr    $0xc,%eax
  80215f:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  802165:	e9 80 00 00 00       	jmp    8021ea <malloc+0x7f3>

					if (heap_mem[i] == 0) {
  80216a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80216d:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  802174:	85 c0                	test   %eax,%eax
  802176:	75 0c                	jne    802184 <malloc+0x78d>

						count++;
  802178:	ff 45 94             	incl   -0x6c(%ebp)
						ptr += PAGE_SIZE;
  80217b:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
  802182:	eb 2d                	jmp    8021b1 <malloc+0x7ba>
					} else {
						if (num_p <= count && max_sz < count) {
  802184:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80218a:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  80218d:	77 14                	ja     8021a3 <malloc+0x7ac>
  80218f:	8b 45 98             	mov    -0x68(%ebp),%eax
  802192:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  802195:	73 0c                	jae    8021a3 <malloc+0x7ac>

							max_sz = count;
  802197:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80219a:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  80219d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8021a0:	89 45 9c             	mov    %eax,-0x64(%ebp)

						}
						count = 0;
  8021a3:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
						ptr += PAGE_SIZE;
  8021aa:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
					}

					if (i == size_uhmem - 1) {
  8021b1:	81 7d 90 ff ff 01 00 	cmpl   $0x1ffff,-0x70(%ebp)
  8021b8:	75 2d                	jne    8021e7 <malloc+0x7f0>

						if (num_p <= count && max_sz > count) {
  8021ba:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8021c0:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8021c3:	77 22                	ja     8021e7 <malloc+0x7f0>
  8021c5:	8b 45 98             	mov    -0x68(%ebp),%eax
  8021c8:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8021cb:	76 1a                	jbe    8021e7 <malloc+0x7f0>

							max_sz = count;
  8021cd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8021d0:	89 45 98             	mov    %eax,-0x68(%ebp)
							temp = ptr;
  8021d3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8021d6:	89 45 9c             	mov    %eax,-0x64(%ebp)
							count = 0;
  8021d9:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
							ptr += PAGE_SIZE;
  8021e0:	81 45 a0 00 10 00 00 	addl   $0x1000,-0x60(%ebp)
				uint32 count = 0;
				int i = 0;
				uint32 num_p = size / PAGE_SIZE;

				// get min mem and can to fit in size
				for (; i < size_uhmem; i++) {
  8021e7:	ff 45 90             	incl   -0x70(%ebp)
  8021ea:	8b 45 90             	mov    -0x70(%ebp),%eax
  8021ed:	3d ff ff 01 00       	cmp    $0x1ffff,%eax
  8021f2:	0f 86 72 ff ff ff    	jbe    80216a <malloc+0x773>

					}

				}

				if (num_p > max_sz || temp == 0) {
  8021f8:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8021fe:	3b 45 98             	cmp    -0x68(%ebp),%eax
  802201:	77 06                	ja     802209 <malloc+0x812>
  802203:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802207:	75 0a                	jne    802213 <malloc+0x81c>
					return NULL;
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
  80220e:	e9 84 01 00 00       	jmp    802397 <malloc+0x9a0>

				}

				temp = temp - (PAGE_SIZE * max_sz);
  802213:	8b 45 98             	mov    -0x68(%ebp),%eax
  802216:	c1 e0 0c             	shl    $0xc,%eax
  802219:	29 45 9c             	sub    %eax,-0x64(%ebp)
				void* ret = (void*) temp;
  80221c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80221f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

				sys_allocateMem(temp, size);
  802225:	83 ec 08             	sub    $0x8,%esp
  802228:	ff 75 08             	pushl  0x8(%ebp)
  80222b:	ff 75 9c             	pushl  -0x64(%ebp)
  80222e:	e8 fb 03 00 00       	call   80262e <sys_allocateMem>
  802233:	83 c4 10             	add    $0x10,%esp

				heap_size[cnt_mem].size = size;
  802236:	a1 20 40 80 00       	mov    0x804020,%eax
  80223b:	8b 55 08             	mov    0x8(%ebp),%edx
  80223e:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
				heap_size[cnt_mem].vir = (void*) temp;
  802245:	a1 20 40 80 00       	mov    0x804020,%eax
  80224a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80224d:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
				cnt_mem++;
  802254:	a1 20 40 80 00       	mov    0x804020,%eax
  802259:	40                   	inc    %eax
  80225a:	a3 20 40 80 00       	mov    %eax,0x804020
				i = 0;
  80225f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802266:	eb 24                	jmp    80228c <malloc+0x895>
				{

					heap_mem[(int) ((temp - (uint32) USER_HEAP_START)
  802268:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80226b:	05 00 00 00 80       	add    $0x80000000,%eax
							/ (uint32) PAGE_SIZE)] = 1;
  802270:	c1 e8 0c             	shr    $0xc,%eax
  802273:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  80227a:	01 00 00 00 

					temp += (uint32) PAGE_SIZE;
  80227e:	81 45 9c 00 10 00 00 	addl   $0x1000,-0x64(%ebp)
				heap_size[cnt_mem].size = size;
				heap_size[cnt_mem].vir = (void*) temp;
				cnt_mem++;
				i = 0;
				// init my array with 1 to make sure this frame is busy
				for (; i < size; i += PAGE_SIZE)
  802285:	81 45 90 00 10 00 00 	addl   $0x1000,-0x70(%ebp)
  80228c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80228f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802292:	72 d4                	jb     802268 <malloc+0x871>

					temp += (uint32) PAGE_SIZE;
				}

				//cprintf("\n size = %d.........vir= %d  \n",num_p,((uint32) ret-USER_HEAP_START)/PAGE_SIZE);
				return ret;
  802294:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80229a:	e9 f8 00 00 00       	jmp    802397 <malloc+0x9a0>

	}
// this is to make malloc is work
	void* ret = NULL;
  80229f:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
	size = ROUNDUP(size, PAGE_SIZE);
  8022a6:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  8022ad:	10 00 00 
  8022b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	48                   	dec    %eax
  8022bc:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  8022c2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8022c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022cd:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  8022d3:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8022d9:	29 d0                	sub    %edx,%eax
  8022db:	89 45 08             	mov    %eax,0x8(%ebp)

	if (size == 0 || size > (USER_HEAP_MAX - USER_HEAP_START)) {
  8022de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e2:	74 09                	je     8022ed <malloc+0x8f6>
  8022e4:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8022eb:	76 0a                	jbe    8022f7 <malloc+0x900>
		return NULL;
  8022ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f2:	e9 a0 00 00 00       	jmp    802397 <malloc+0x9a0>
	}

	if (ptr_uheap + size <= (uint32) USER_HEAP_MAX) {
  8022f7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	01 d0                	add    %edx,%eax
  802302:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802307:	0f 87 87 00 00 00    	ja     802394 <malloc+0x99d>

		ret = (void *) ptr_uheap;
  80230d:	a1 04 40 80 00       	mov    0x804004,%eax
  802312:	89 45 8c             	mov    %eax,-0x74(%ebp)
		sys_allocateMem(ptr_uheap, size);
  802315:	a1 04 40 80 00       	mov    0x804004,%eax
  80231a:	83 ec 08             	sub    $0x8,%esp
  80231d:	ff 75 08             	pushl  0x8(%ebp)
  802320:	50                   	push   %eax
  802321:	e8 08 03 00 00       	call   80262e <sys_allocateMem>
  802326:	83 c4 10             	add    $0x10,%esp

		heap_size[cnt_mem].size = size;
  802329:	a1 20 40 80 00       	mov    0x804020,%eax
  80232e:	8b 55 08             	mov    0x8(%ebp),%edx
  802331:	89 14 c5 44 40 88 00 	mov    %edx,0x884044(,%eax,8)
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
  802338:	a1 20 40 80 00       	mov    0x804020,%eax
  80233d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802343:	89 14 c5 40 40 88 00 	mov    %edx,0x884040(,%eax,8)
		cnt_mem++;
  80234a:	a1 20 40 80 00       	mov    0x804020,%eax
  80234f:	40                   	inc    %eax
  802350:	a3 20 40 80 00       	mov    %eax,0x804020
		int i = 0;
  802355:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)

		for (; i < size; i += PAGE_SIZE)
  80235c:	eb 2e                	jmp    80238c <malloc+0x995>
		{

			heap_mem[(int) ((ptr_uheap - (uint32) USER_HEAP_START)
  80235e:	a1 04 40 80 00       	mov    0x804004,%eax
  802363:	05 00 00 00 80       	add    $0x80000000,%eax
					/ (uint32) PAGE_SIZE)] = 1;
  802368:	c1 e8 0c             	shr    $0xc,%eax
  80236b:	c7 04 85 40 40 80 00 	movl   $0x1,0x804040(,%eax,4)
  802372:	01 00 00 00 

			ptr_uheap += (uint32) PAGE_SIZE;
  802376:	a1 04 40 80 00       	mov    0x804004,%eax
  80237b:	05 00 10 00 00       	add    $0x1000,%eax
  802380:	a3 04 40 80 00       	mov    %eax,0x804004
		heap_size[cnt_mem].size = size;
		heap_size[cnt_mem].vir = (void*) ptr_uheap;
		cnt_mem++;
		int i = 0;

		for (; i < size; i += PAGE_SIZE)
  802385:	81 45 88 00 10 00 00 	addl   $0x1000,-0x78(%ebp)
  80238c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80238f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802392:	72 ca                	jb     80235e <malloc+0x967>
					/ (uint32) PAGE_SIZE)] = 1;

			ptr_uheap += (uint32) PAGE_SIZE;
		}
	}
	return ret;
  802394:	8b 45 8c             	mov    -0x74(%ebp),%eax

	//TODO: [PROJECT 2016 - BONUS2] Apply FIRST FIT and WORST FIT policies

//return 0;

}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <free>:
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address) {
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
  80239f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; inx < cnt_mem; inx++) {
  8023a6:	e9 c1 00 00 00       	jmp    80246c <free+0xd3>
		if (heap_size[inx].vir == virtual_address) {
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 04 c5 40 40 88 00 	mov    0x884040(,%eax,8),%eax
  8023b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b8:	0f 85 ab 00 00 00    	jne    802469 <free+0xd0>

			if (heap_size[inx].size == 0) {
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	8b 04 c5 44 40 88 00 	mov    0x884044(,%eax,8),%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	75 21                	jne    8023ed <free+0x54>
				heap_size[inx].size = 0;
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  8023d6:	00 00 00 00 
				heap_size[inx].vir = NULL;
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  8023e4:	00 00 00 00 
				return;
  8023e8:	e9 8d 00 00 00       	jmp    80247a <free+0xe1>

			}

			sys_freeMem((uint32) virtual_address, heap_size[inx].size);
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	83 ec 08             	sub    $0x8,%esp
  8023fd:	52                   	push   %edx
  8023fe:	50                   	push   %eax
  8023ff:	e8 0e 02 00 00       	call   802612 <sys_freeMem>
  802404:	83 c4 10             	add    $0x10,%esp

			int i = 0;
  802407:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802414:	eb 24                	jmp    80243a <free+0xa1>
			{
				heap_mem[(int) (((uint32) va - USER_HEAP_START) / PAGE_SIZE)] =
  802416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802419:	05 00 00 00 80       	add    $0x80000000,%eax
  80241e:	c1 e8 0c             	shr    $0xc,%eax
  802421:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  802428:	00 00 00 00 
						0;

				va += PAGE_SIZE;
  80242c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
			sys_freeMem((uint32) virtual_address, heap_size[inx].size);

			int i = 0;
			// init my array with 0 to make sure this frame is free
			uint32 va = (uint32) virtual_address;
			for (; i < heap_size[inx].size; i += PAGE_SIZE)
  802433:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 14 c5 44 40 88 00 	mov    0x884044(,%eax,8),%edx
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	39 c2                	cmp    %eax,%edx
  802449:	77 cb                	ja     802416 <free+0x7d>

				va += PAGE_SIZE;

			}

			heap_size[inx].size = 0;
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	c7 04 c5 44 40 88 00 	movl   $0x0,0x884044(,%eax,8)
  802455:	00 00 00 00 
			heap_size[inx].vir = NULL;
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	c7 04 c5 40 40 88 00 	movl   $0x0,0x884040(,%eax,8)
  802463:	00 00 00 00 
			break;
  802467:	eb 11                	jmp    80247a <free+0xe1>
	//panic("free() is not implemented yet...!!");
	//

	//virtual_address=ROUNDDOWN(virtual_address,PAGE_SIZE);
	int inx = 0;
	for (; inx < cnt_mem; inx++) {
  802469:	ff 45 f4             	incl   -0xc(%ebp)
  80246c:	a1 20 40 80 00       	mov    0x804020,%eax
  802471:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802474:	0f 8c 31 ff ff ff    	jl     8023ab <free+0x12>
	}

	//get the size of the given allocation using its address
	//you need to call sys_freeMem()

}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <realloc>:
//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size) {
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2016 - BONUS4] realloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	68 90 31 80 00       	push   $0x803190
  80248a:	68 1c 02 00 00       	push   $0x21c
  80248f:	68 b6 31 80 00       	push   $0x8031b6
  802494:	e8 b0 e6 ff ff       	call   800b49 <_panic>

00802499 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	57                   	push   %edi
  80249d:	56                   	push   %esi
  80249e:	53                   	push   %ebx
  80249f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024ae:	8b 7d 18             	mov    0x18(%ebp),%edi
  8024b1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8024b4:	cd 30                	int    $0x30
  8024b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8024b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8024bc:	83 c4 10             	add    $0x10,%esp
  8024bf:	5b                   	pop    %ebx
  8024c0:	5e                   	pop    %esi
  8024c1:	5f                   	pop    %edi
  8024c2:	5d                   	pop    %ebp
  8024c3:	c3                   	ret    

008024c4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_cputs, (uint32) s, len, 0, 0, 0);
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	ff 75 0c             	pushl  0xc(%ebp)
  8024d3:	50                   	push   %eax
  8024d4:	6a 00                	push   $0x0
  8024d6:	e8 be ff ff ff       	call   802499 <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
}
  8024de:	90                   	nop
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 01                	push   $0x1
  8024f0:	e8 a4 ff ff ff       	call   802499 <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	50                   	push   %eax
  802509:	6a 03                	push   $0x3
  80250b:	e8 89 ff ff ff       	call   802499 <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 02                	push   $0x2
  802524:	e8 70 ff ff ff       	call   802499 <syscall>
  802529:	83 c4 18             	add    $0x18,%esp
}
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <sys_env_exit>:

void sys_env_exit(void)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 04                	push   $0x4
  80253d:	e8 57 ff ff ff       	call   802499 <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
}
  802545:	90                   	nop
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80254b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	52                   	push   %edx
  802558:	50                   	push   %eax
  802559:	6a 05                	push   $0x5
  80255b:	e8 39 ff ff ff       	call   802499 <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	56                   	push   %esi
  802569:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80256a:	8b 75 18             	mov    0x18(%ebp),%esi
  80256d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802570:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802573:	8b 55 0c             	mov    0xc(%ebp),%edx
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	56                   	push   %esi
  80257a:	53                   	push   %ebx
  80257b:	51                   	push   %ecx
  80257c:	52                   	push   %edx
  80257d:	50                   	push   %eax
  80257e:	6a 06                	push   $0x6
  802580:	e8 14 ff ff ff       	call   802499 <syscall>
  802585:	83 c4 18             	add    $0x18,%esp
}
  802588:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80258b:	5b                   	pop    %ebx
  80258c:	5e                   	pop    %esi
  80258d:	5d                   	pop    %ebp
  80258e:	c3                   	ret    

0080258f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802592:	8b 55 0c             	mov    0xc(%ebp),%edx
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	52                   	push   %edx
  80259f:	50                   	push   %eax
  8025a0:	6a 07                	push   $0x7
  8025a2:	e8 f2 fe ff ff       	call   802499 <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	ff 75 0c             	pushl  0xc(%ebp)
  8025b8:	ff 75 08             	pushl  0x8(%ebp)
  8025bb:	6a 08                	push   $0x8
  8025bd:	e8 d7 fe ff ff       	call   802499 <syscall>
  8025c2:	83 c4 18             	add    $0x18,%esp
}
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 09                	push   $0x9
  8025d6:	e8 be fe ff ff       	call   802499 <syscall>
  8025db:	83 c4 18             	add    $0x18,%esp
}
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 0a                	push   $0xa
  8025ef:	e8 a5 fe ff ff       	call   802499 <syscall>
  8025f4:	83 c4 18             	add    $0x18,%esp
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 0b                	push   $0xb
  802608:	e8 8c fe ff ff       	call   802499 <syscall>
  80260d:	83 c4 18             	add    $0x18,%esp
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    

00802612 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	ff 75 0c             	pushl  0xc(%ebp)
  80261e:	ff 75 08             	pushl  0x8(%ebp)
  802621:	6a 0d                	push   $0xd
  802623:	e8 71 fe ff ff       	call   802499 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
	return;
  80262b:	90                   	nop
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	ff 75 0c             	pushl  0xc(%ebp)
  80263a:	ff 75 08             	pushl  0x8(%ebp)
  80263d:	6a 0e                	push   $0xe
  80263f:	e8 55 fe ff ff       	call   802499 <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
	return ;
  802647:	90                   	nop
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 0c                	push   $0xc
  802659:	e8 3b fe ff ff       	call   802499 <syscall>
  80265e:	83 c4 18             	add    $0x18,%esp
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	6a 10                	push   $0x10
  802672:	e8 22 fe ff ff       	call   802499 <syscall>
  802677:	83 c4 18             	add    $0x18,%esp
}
  80267a:	90                   	nop
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 11                	push   $0x11
  80268c:	e8 08 fe ff ff       	call   802499 <syscall>
  802691:	83 c4 18             	add    $0x18,%esp
}
  802694:	90                   	nop
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <sys_cputc>:


void
sys_cputc(const char c)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	83 ec 04             	sub    $0x4,%esp
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026a3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	50                   	push   %eax
  8026b0:	6a 12                	push   $0x12
  8026b2:	e8 e2 fd ff ff       	call   802499 <syscall>
  8026b7:	83 c4 18             	add    $0x18,%esp
}
  8026ba:	90                   	nop
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 13                	push   $0x13
  8026cc:	e8 c8 fd ff ff       	call   802499 <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	90                   	nop
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	ff 75 0c             	pushl  0xc(%ebp)
  8026e6:	50                   	push   %eax
  8026e7:	6a 14                	push   $0x14
  8026e9:	e8 ab fd ff ff       	call   802499 <syscall>
  8026ee:	83 c4 18             	add    $0x18,%esp
}
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(char* semaphoreName)
{
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32)semaphoreName, 0, 0, 0, 0);
  8026f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	50                   	push   %eax
  802702:	6a 17                	push   $0x17
  802704:	e8 90 fd ff ff       	call   802499 <syscall>
  802709:	83 c4 18             	add    $0x18,%esp
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <sys_waitSemaphore>:

void
sys_waitSemaphore(char* semaphoreName)
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  802711:	8b 45 08             	mov    0x8(%ebp),%eax
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	50                   	push   %eax
  80271d:	6a 15                	push   $0x15
  80271f:	e8 75 fd ff ff       	call   802499 <syscall>
  802724:	83 c4 18             	add    $0x18,%esp
}
  802727:	90                   	nop
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_signalSemaphore>:

void
sys_signalSemaphore(char* semaphoreName)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32)semaphoreName, 0, 0, 0, 0);
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	50                   	push   %eax
  802739:	6a 16                	push   $0x16
  80273b:	e8 59 fd ff ff       	call   802499 <syscall>
  802740:	83 c4 18             	add    $0x18,%esp
}
  802743:	90                   	nop
  802744:	c9                   	leave  
  802745:	c3                   	ret    

00802746 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void** returned_shared_address)
{
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
  802749:	83 ec 04             	sub    $0x4,%esp
  80274c:	8b 45 10             	mov    0x10(%ebp),%eax
  80274f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)returned_shared_address,  0);
  802752:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802755:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	6a 00                	push   $0x0
  80275e:	51                   	push   %ecx
  80275f:	52                   	push   %edx
  802760:	ff 75 0c             	pushl  0xc(%ebp)
  802763:	50                   	push   %eax
  802764:	6a 18                	push   $0x18
  802766:	e8 2e fd ff ff       	call   802499 <syscall>
  80276b:	83 c4 18             	add    $0x18,%esp
}
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <sys_getSharedObject>:



int
sys_getSharedObject(char* shareName, void** returned_shared_address)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32)shareName, (uint32)returned_shared_address, 0, 0, 0);
  802773:	8b 55 0c             	mov    0xc(%ebp),%edx
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	52                   	push   %edx
  802780:	50                   	push   %eax
  802781:	6a 19                	push   $0x19
  802783:	e8 11 fd ff ff       	call   802499 <syscall>
  802788:	83 c4 18             	add    $0x18,%esp
}
  80278b:	c9                   	leave  
  80278c:	c3                   	ret    

0080278d <sys_freeSharedObject>:

int
sys_freeSharedObject(char* shareName)
{
  80278d:	55                   	push   %ebp
  80278e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32)shareName, 0, 0, 0, 0);
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	50                   	push   %eax
  80279c:	6a 1a                	push   $0x1a
  80279e:	e8 f6 fc ff ff       	call   802499 <syscall>
  8027a3:	83 c4 18             	add    $0x18,%esp
}
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <sys_getCurrentSharedAddress>:

uint32 	sys_getCurrentSharedAddress()
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_current_shared_address,0, 0, 0, 0, 0);
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 1b                	push   $0x1b
  8027b7:	e8 dd fc ff ff       	call   802499 <syscall>
  8027bc:	83 c4 18             	add    $0x18,%esp
}
  8027bf:	c9                   	leave  
  8027c0:	c3                   	ret    

008027c1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 1c                	push   $0x1c
  8027d0:	e8 c4 fc ff ff       	call   802499 <syscall>
  8027d5:	83 c4 18             	add    $0x18,%esp
}
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    

008027da <sys_create_env>:

int
sys_create_env(char* programName, unsigned int page_WS_size)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, page_WS_size, 0, 0, 0);
  8027dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	6a 00                	push   $0x0
  8027e6:	ff 75 0c             	pushl  0xc(%ebp)
  8027e9:	50                   	push   %eax
  8027ea:	6a 1d                	push   $0x1d
  8027ec:	e8 a8 fc ff ff       	call   802499 <syscall>
  8027f1:	83 c4 18             	add    $0x18,%esp
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	50                   	push   %eax
  802805:	6a 1e                	push   $0x1e
  802807:	e8 8d fc ff ff       	call   802499 <syscall>
  80280c:	83 c4 18             	add    $0x18,%esp
}
  80280f:	90                   	nop
  802810:	c9                   	leave  
  802811:	c3                   	ret    

00802812 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802812:	55                   	push   %ebp
  802813:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	50                   	push   %eax
  802821:	6a 1f                	push   $0x1f
  802823:	e8 71 fc ff ff       	call   802499 <syscall>
  802828:	83 c4 18             	add    $0x18,%esp
}
  80282b:	90                   	nop
  80282c:	c9                   	leave  
  80282d:	c3                   	ret    

0080282e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802834:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802837:	8d 50 04             	lea    0x4(%eax),%edx
  80283a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	52                   	push   %edx
  802844:	50                   	push   %eax
  802845:	6a 20                	push   $0x20
  802847:	e8 4d fc ff ff       	call   802499 <syscall>
  80284c:	83 c4 18             	add    $0x18,%esp
	return result;
  80284f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802852:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802855:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802858:	89 01                	mov    %eax,(%ecx)
  80285a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	c9                   	leave  
  802861:	c2 04 00             	ret    $0x4

00802864 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	ff 75 10             	pushl  0x10(%ebp)
  80286e:	ff 75 0c             	pushl  0xc(%ebp)
  802871:	ff 75 08             	pushl  0x8(%ebp)
  802874:	6a 0f                	push   $0xf
  802876:	e8 1e fc ff ff       	call   802499 <syscall>
  80287b:	83 c4 18             	add    $0x18,%esp
	return ;
  80287e:	90                   	nop
}
  80287f:	c9                   	leave  
  802880:	c3                   	ret    

00802881 <sys_rcr2>:
uint32 sys_rcr2()
{
  802881:	55                   	push   %ebp
  802882:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	6a 21                	push   $0x21
  802890:	e8 04 fc ff ff       	call   802499 <syscall>
  802895:	83 c4 18             	add    $0x18,%esp
}
  802898:	c9                   	leave  
  802899:	c3                   	ret    

0080289a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
  80289d:	83 ec 04             	sub    $0x4,%esp
  8028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8028a6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	50                   	push   %eax
  8028b3:	6a 22                	push   $0x22
  8028b5:	e8 df fb ff ff       	call   802499 <syscall>
  8028ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8028bd:	90                   	nop
}
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <rsttst>:
void rsttst()
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 24                	push   $0x24
  8028cf:	e8 c5 fb ff ff       	call   802499 <syscall>
  8028d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8028d7:	90                   	nop
}
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028e6:	8b 55 18             	mov    0x18(%ebp),%edx
  8028e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028ed:	52                   	push   %edx
  8028ee:	50                   	push   %eax
  8028ef:	ff 75 10             	pushl  0x10(%ebp)
  8028f2:	ff 75 0c             	pushl  0xc(%ebp)
  8028f5:	ff 75 08             	pushl  0x8(%ebp)
  8028f8:	6a 23                	push   $0x23
  8028fa:	e8 9a fb ff ff       	call   802499 <syscall>
  8028ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802902:	90                   	nop
}
  802903:	c9                   	leave  
  802904:	c3                   	ret    

00802905 <chktst>:
void chktst(uint32 n)
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802908:	6a 00                	push   $0x0
  80290a:	6a 00                	push   $0x0
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	ff 75 08             	pushl  0x8(%ebp)
  802913:	6a 25                	push   $0x25
  802915:	e8 7f fb ff ff       	call   802499 <syscall>
  80291a:	83 c4 18             	add    $0x18,%esp
	return ;
  80291d:	90                   	nop
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802926:	6a 00                	push   $0x0
  802928:	6a 00                	push   $0x0
  80292a:	6a 00                	push   $0x0
  80292c:	6a 00                	push   $0x0
  80292e:	6a 00                	push   $0x0
  802930:	6a 26                	push   $0x26
  802932:	e8 62 fb ff ff       	call   802499 <syscall>
  802937:	83 c4 18             	add    $0x18,%esp
  80293a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80293d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802941:	75 07                	jne    80294a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802943:	b8 01 00 00 00       	mov    $0x1,%eax
  802948:	eb 05                	jmp    80294f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80294a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80294f:	c9                   	leave  
  802950:	c3                   	ret    

00802951 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802951:	55                   	push   %ebp
  802952:	89 e5                	mov    %esp,%ebp
  802954:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 26                	push   $0x26
  802963:	e8 31 fb ff ff       	call   802499 <syscall>
  802968:	83 c4 18             	add    $0x18,%esp
  80296b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80296e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802972:	75 07                	jne    80297b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802974:	b8 01 00 00 00       	mov    $0x1,%eax
  802979:	eb 05                	jmp    802980 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80297b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802980:	c9                   	leave  
  802981:	c3                   	ret    

00802982 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802982:	55                   	push   %ebp
  802983:	89 e5                	mov    %esp,%ebp
  802985:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802988:	6a 00                	push   $0x0
  80298a:	6a 00                	push   $0x0
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	6a 26                	push   $0x26
  802994:	e8 00 fb ff ff       	call   802499 <syscall>
  802999:	83 c4 18             	add    $0x18,%esp
  80299c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80299f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029a3:	75 07                	jne    8029ac <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8029aa:	eb 05                	jmp    8029b1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b1:	c9                   	leave  
  8029b2:	c3                   	ret    

008029b3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029b3:	55                   	push   %ebp
  8029b4:	89 e5                	mov    %esp,%ebp
  8029b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 26                	push   $0x26
  8029c5:	e8 cf fa ff ff       	call   802499 <syscall>
  8029ca:	83 c4 18             	add    $0x18,%esp
  8029cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8029d0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8029d4:	75 07                	jne    8029dd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8029d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029db:	eb 05                	jmp    8029e2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e2:	c9                   	leave  
  8029e3:	c3                   	ret    

008029e4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8029e4:	55                   	push   %ebp
  8029e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8029e7:	6a 00                	push   $0x0
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	ff 75 08             	pushl  0x8(%ebp)
  8029f2:	6a 27                	push   $0x27
  8029f4:	e8 a0 fa ff ff       	call   802499 <syscall>
  8029f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8029fc:	90                   	nop
}
  8029fd:	c9                   	leave  
  8029fe:	c3                   	ret    
  8029ff:	90                   	nop

00802a00 <__udivdi3>:
  802a00:	55                   	push   %ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	53                   	push   %ebx
  802a04:	83 ec 1c             	sub    $0x1c,%esp
  802a07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a17:	89 ca                	mov    %ecx,%edx
  802a19:	89 f8                	mov    %edi,%eax
  802a1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a1f:	85 f6                	test   %esi,%esi
  802a21:	75 2d                	jne    802a50 <__udivdi3+0x50>
  802a23:	39 cf                	cmp    %ecx,%edi
  802a25:	77 65                	ja     802a8c <__udivdi3+0x8c>
  802a27:	89 fd                	mov    %edi,%ebp
  802a29:	85 ff                	test   %edi,%edi
  802a2b:	75 0b                	jne    802a38 <__udivdi3+0x38>
  802a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a32:	31 d2                	xor    %edx,%edx
  802a34:	f7 f7                	div    %edi
  802a36:	89 c5                	mov    %eax,%ebp
  802a38:	31 d2                	xor    %edx,%edx
  802a3a:	89 c8                	mov    %ecx,%eax
  802a3c:	f7 f5                	div    %ebp
  802a3e:	89 c1                	mov    %eax,%ecx
  802a40:	89 d8                	mov    %ebx,%eax
  802a42:	f7 f5                	div    %ebp
  802a44:	89 cf                	mov    %ecx,%edi
  802a46:	89 fa                	mov    %edi,%edx
  802a48:	83 c4 1c             	add    $0x1c,%esp
  802a4b:	5b                   	pop    %ebx
  802a4c:	5e                   	pop    %esi
  802a4d:	5f                   	pop    %edi
  802a4e:	5d                   	pop    %ebp
  802a4f:	c3                   	ret    
  802a50:	39 ce                	cmp    %ecx,%esi
  802a52:	77 28                	ja     802a7c <__udivdi3+0x7c>
  802a54:	0f bd fe             	bsr    %esi,%edi
  802a57:	83 f7 1f             	xor    $0x1f,%edi
  802a5a:	75 40                	jne    802a9c <__udivdi3+0x9c>
  802a5c:	39 ce                	cmp    %ecx,%esi
  802a5e:	72 0a                	jb     802a6a <__udivdi3+0x6a>
  802a60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802a64:	0f 87 9e 00 00 00    	ja     802b08 <__udivdi3+0x108>
  802a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6f:	89 fa                	mov    %edi,%edx
  802a71:	83 c4 1c             	add    $0x1c,%esp
  802a74:	5b                   	pop    %ebx
  802a75:	5e                   	pop    %esi
  802a76:	5f                   	pop    %edi
  802a77:	5d                   	pop    %ebp
  802a78:	c3                   	ret    
  802a79:	8d 76 00             	lea    0x0(%esi),%esi
  802a7c:	31 ff                	xor    %edi,%edi
  802a7e:	31 c0                	xor    %eax,%eax
  802a80:	89 fa                	mov    %edi,%edx
  802a82:	83 c4 1c             	add    $0x1c,%esp
  802a85:	5b                   	pop    %ebx
  802a86:	5e                   	pop    %esi
  802a87:	5f                   	pop    %edi
  802a88:	5d                   	pop    %ebp
  802a89:	c3                   	ret    
  802a8a:	66 90                	xchg   %ax,%ax
  802a8c:	89 d8                	mov    %ebx,%eax
  802a8e:	f7 f7                	div    %edi
  802a90:	31 ff                	xor    %edi,%edi
  802a92:	89 fa                	mov    %edi,%edx
  802a94:	83 c4 1c             	add    $0x1c,%esp
  802a97:	5b                   	pop    %ebx
  802a98:	5e                   	pop    %esi
  802a99:	5f                   	pop    %edi
  802a9a:	5d                   	pop    %ebp
  802a9b:	c3                   	ret    
  802a9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802aa1:	89 eb                	mov    %ebp,%ebx
  802aa3:	29 fb                	sub    %edi,%ebx
  802aa5:	89 f9                	mov    %edi,%ecx
  802aa7:	d3 e6                	shl    %cl,%esi
  802aa9:	89 c5                	mov    %eax,%ebp
  802aab:	88 d9                	mov    %bl,%cl
  802aad:	d3 ed                	shr    %cl,%ebp
  802aaf:	89 e9                	mov    %ebp,%ecx
  802ab1:	09 f1                	or     %esi,%ecx
  802ab3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802ab7:	89 f9                	mov    %edi,%ecx
  802ab9:	d3 e0                	shl    %cl,%eax
  802abb:	89 c5                	mov    %eax,%ebp
  802abd:	89 d6                	mov    %edx,%esi
  802abf:	88 d9                	mov    %bl,%cl
  802ac1:	d3 ee                	shr    %cl,%esi
  802ac3:	89 f9                	mov    %edi,%ecx
  802ac5:	d3 e2                	shl    %cl,%edx
  802ac7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802acb:	88 d9                	mov    %bl,%cl
  802acd:	d3 e8                	shr    %cl,%eax
  802acf:	09 c2                	or     %eax,%edx
  802ad1:	89 d0                	mov    %edx,%eax
  802ad3:	89 f2                	mov    %esi,%edx
  802ad5:	f7 74 24 0c          	divl   0xc(%esp)
  802ad9:	89 d6                	mov    %edx,%esi
  802adb:	89 c3                	mov    %eax,%ebx
  802add:	f7 e5                	mul    %ebp
  802adf:	39 d6                	cmp    %edx,%esi
  802ae1:	72 19                	jb     802afc <__udivdi3+0xfc>
  802ae3:	74 0b                	je     802af0 <__udivdi3+0xf0>
  802ae5:	89 d8                	mov    %ebx,%eax
  802ae7:	31 ff                	xor    %edi,%edi
  802ae9:	e9 58 ff ff ff       	jmp    802a46 <__udivdi3+0x46>
  802aee:	66 90                	xchg   %ax,%ax
  802af0:	8b 54 24 08          	mov    0x8(%esp),%edx
  802af4:	89 f9                	mov    %edi,%ecx
  802af6:	d3 e2                	shl    %cl,%edx
  802af8:	39 c2                	cmp    %eax,%edx
  802afa:	73 e9                	jae    802ae5 <__udivdi3+0xe5>
  802afc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802aff:	31 ff                	xor    %edi,%edi
  802b01:	e9 40 ff ff ff       	jmp    802a46 <__udivdi3+0x46>
  802b06:	66 90                	xchg   %ax,%ax
  802b08:	31 c0                	xor    %eax,%eax
  802b0a:	e9 37 ff ff ff       	jmp    802a46 <__udivdi3+0x46>
  802b0f:	90                   	nop

00802b10 <__umoddi3>:
  802b10:	55                   	push   %ebp
  802b11:	57                   	push   %edi
  802b12:	56                   	push   %esi
  802b13:	53                   	push   %ebx
  802b14:	83 ec 1c             	sub    $0x1c,%esp
  802b17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b2f:	89 f3                	mov    %esi,%ebx
  802b31:	89 fa                	mov    %edi,%edx
  802b33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b37:	89 34 24             	mov    %esi,(%esp)
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	75 1a                	jne    802b58 <__umoddi3+0x48>
  802b3e:	39 f7                	cmp    %esi,%edi
  802b40:	0f 86 a2 00 00 00    	jbe    802be8 <__umoddi3+0xd8>
  802b46:	89 c8                	mov    %ecx,%eax
  802b48:	89 f2                	mov    %esi,%edx
  802b4a:	f7 f7                	div    %edi
  802b4c:	89 d0                	mov    %edx,%eax
  802b4e:	31 d2                	xor    %edx,%edx
  802b50:	83 c4 1c             	add    $0x1c,%esp
  802b53:	5b                   	pop    %ebx
  802b54:	5e                   	pop    %esi
  802b55:	5f                   	pop    %edi
  802b56:	5d                   	pop    %ebp
  802b57:	c3                   	ret    
  802b58:	39 f0                	cmp    %esi,%eax
  802b5a:	0f 87 ac 00 00 00    	ja     802c0c <__umoddi3+0xfc>
  802b60:	0f bd e8             	bsr    %eax,%ebp
  802b63:	83 f5 1f             	xor    $0x1f,%ebp
  802b66:	0f 84 ac 00 00 00    	je     802c18 <__umoddi3+0x108>
  802b6c:	bf 20 00 00 00       	mov    $0x20,%edi
  802b71:	29 ef                	sub    %ebp,%edi
  802b73:	89 fe                	mov    %edi,%esi
  802b75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b79:	89 e9                	mov    %ebp,%ecx
  802b7b:	d3 e0                	shl    %cl,%eax
  802b7d:	89 d7                	mov    %edx,%edi
  802b7f:	89 f1                	mov    %esi,%ecx
  802b81:	d3 ef                	shr    %cl,%edi
  802b83:	09 c7                	or     %eax,%edi
  802b85:	89 e9                	mov    %ebp,%ecx
  802b87:	d3 e2                	shl    %cl,%edx
  802b89:	89 14 24             	mov    %edx,(%esp)
  802b8c:	89 d8                	mov    %ebx,%eax
  802b8e:	d3 e0                	shl    %cl,%eax
  802b90:	89 c2                	mov    %eax,%edx
  802b92:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b96:	d3 e0                	shl    %cl,%eax
  802b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ba0:	89 f1                	mov    %esi,%ecx
  802ba2:	d3 e8                	shr    %cl,%eax
  802ba4:	09 d0                	or     %edx,%eax
  802ba6:	d3 eb                	shr    %cl,%ebx
  802ba8:	89 da                	mov    %ebx,%edx
  802baa:	f7 f7                	div    %edi
  802bac:	89 d3                	mov    %edx,%ebx
  802bae:	f7 24 24             	mull   (%esp)
  802bb1:	89 c6                	mov    %eax,%esi
  802bb3:	89 d1                	mov    %edx,%ecx
  802bb5:	39 d3                	cmp    %edx,%ebx
  802bb7:	0f 82 87 00 00 00    	jb     802c44 <__umoddi3+0x134>
  802bbd:	0f 84 91 00 00 00    	je     802c54 <__umoddi3+0x144>
  802bc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bc7:	29 f2                	sub    %esi,%edx
  802bc9:	19 cb                	sbb    %ecx,%ebx
  802bcb:	89 d8                	mov    %ebx,%eax
  802bcd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802bd1:	d3 e0                	shl    %cl,%eax
  802bd3:	89 e9                	mov    %ebp,%ecx
  802bd5:	d3 ea                	shr    %cl,%edx
  802bd7:	09 d0                	or     %edx,%eax
  802bd9:	89 e9                	mov    %ebp,%ecx
  802bdb:	d3 eb                	shr    %cl,%ebx
  802bdd:	89 da                	mov    %ebx,%edx
  802bdf:	83 c4 1c             	add    $0x1c,%esp
  802be2:	5b                   	pop    %ebx
  802be3:	5e                   	pop    %esi
  802be4:	5f                   	pop    %edi
  802be5:	5d                   	pop    %ebp
  802be6:	c3                   	ret    
  802be7:	90                   	nop
  802be8:	89 fd                	mov    %edi,%ebp
  802bea:	85 ff                	test   %edi,%edi
  802bec:	75 0b                	jne    802bf9 <__umoddi3+0xe9>
  802bee:	b8 01 00 00 00       	mov    $0x1,%eax
  802bf3:	31 d2                	xor    %edx,%edx
  802bf5:	f7 f7                	div    %edi
  802bf7:	89 c5                	mov    %eax,%ebp
  802bf9:	89 f0                	mov    %esi,%eax
  802bfb:	31 d2                	xor    %edx,%edx
  802bfd:	f7 f5                	div    %ebp
  802bff:	89 c8                	mov    %ecx,%eax
  802c01:	f7 f5                	div    %ebp
  802c03:	89 d0                	mov    %edx,%eax
  802c05:	e9 44 ff ff ff       	jmp    802b4e <__umoddi3+0x3e>
  802c0a:	66 90                	xchg   %ax,%ax
  802c0c:	89 c8                	mov    %ecx,%eax
  802c0e:	89 f2                	mov    %esi,%edx
  802c10:	83 c4 1c             	add    $0x1c,%esp
  802c13:	5b                   	pop    %ebx
  802c14:	5e                   	pop    %esi
  802c15:	5f                   	pop    %edi
  802c16:	5d                   	pop    %ebp
  802c17:	c3                   	ret    
  802c18:	3b 04 24             	cmp    (%esp),%eax
  802c1b:	72 06                	jb     802c23 <__umoddi3+0x113>
  802c1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c21:	77 0f                	ja     802c32 <__umoddi3+0x122>
  802c23:	89 f2                	mov    %esi,%edx
  802c25:	29 f9                	sub    %edi,%ecx
  802c27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c2b:	89 14 24             	mov    %edx,(%esp)
  802c2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c32:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c36:	8b 14 24             	mov    (%esp),%edx
  802c39:	83 c4 1c             	add    $0x1c,%esp
  802c3c:	5b                   	pop    %ebx
  802c3d:	5e                   	pop    %esi
  802c3e:	5f                   	pop    %edi
  802c3f:	5d                   	pop    %ebp
  802c40:	c3                   	ret    
  802c41:	8d 76 00             	lea    0x0(%esi),%esi
  802c44:	2b 04 24             	sub    (%esp),%eax
  802c47:	19 fa                	sbb    %edi,%edx
  802c49:	89 d1                	mov    %edx,%ecx
  802c4b:	89 c6                	mov    %eax,%esi
  802c4d:	e9 71 ff ff ff       	jmp    802bc3 <__umoddi3+0xb3>
  802c52:	66 90                	xchg   %ax,%ax
  802c54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802c58:	72 ea                	jb     802c44 <__umoddi3+0x134>
  802c5a:	89 d9                	mov    %ebx,%ecx
  802c5c:	e9 62 ff ff ff       	jmp    802bc3 <__umoddi3+0xb3>
